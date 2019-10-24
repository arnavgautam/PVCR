using Pandas
using PyCall
using PyPlot
using DelimitedFiles

# Eventually move run_solar_data_through_sam_ssc here

# This function is completely unnecessary right now, I'm just keeping it here as reference in case it's useful in the future
@pyimport pypvwatts;
function predict_solar_output_at_location(lat=9.817934,lon=-84.070552)
    PVWatts = pypvwatts.PVWatts
    # Get api key
    credential_file = open("nrel-credentials.txt")
    nrel_credentials = readlines(credential_file)
        # You must have an NSRDB api key
    api_key = nrel_credentials[4]
    close(credential_file)
    
    
    PVWatts.api_key = api_key
    result = PVWatts.request(
        system_capacity=4, module_type=1, array_type=1,
        azimuth=190, tilt=30, dataset="tmy2",
        losses=13, lat=lat, lon=lon)
    println(result.ac_annual)
end

function get_nsrdb_raw_solar_data(lat,lon,year)
    # Declare all variables as strings. Spaces must be replaced with "+", i.e., change "John Smith" to "John+Smith".

    # Set the attributes to extract (e.g., dhi, ghi, etc.), separated by commas.
    attributes = "ghi,dhi,dni,wind_speed,air_temperature,solar_zenith_angle"

    # Set leap year to true or false. True will return leap day data if present, false will not.
    leap_year = "false"

    # Set time interval in minutes, i.e., "30" is half hour intervals. Valid intervals are 30 & 60.
    interval = "60"

    # Specify Coordinated Universal Time (UTC), "true" will use UTC, "false" will use the local time zone of the data.
    # NOTE: In order to use the NSRDB data in SAM, you must specify UTC as "false". SAM requires the data to be in the
    # local time zone.
    utc = "false"

    # Have a file named "nrel-credentials.txt", with line-separated
    # - Full+Name
    # - Email address
    # - Your+Affiliation
    # - API Key
    credential_file = open("nrel-credentials.txt")
    nrel_credentials = readlines(credential_file)
    
    # Your full name, use "+" instead of spaces.
    your_name = nrel_credentials[1]

    # Your email address
    your_email = nrel_credentials[2]

    # Your affiliation
    your_affiliation = nrel_credentials[3]

    # You must have an NSRDB api key
    api_key = nrel_credentials[4]
    close(credential_file)

    # Please join our mailing list so we can keep you up-to-date on new developments.
    mailing_list = "false";
    
    # Your reason for using the NSRDB.
    reason_for_use = "data+analysis"

    
    # Declare url string
    url = "http://developer.nrel.gov/api/solar/nsrdb_psm3_download.csv?wkt=POINT($(lon)%20$(lat))&names=$(year)&leap_day=$(leap_year)&interval=$(interval)&utc=$(utc)&full_name=$(your_name)&email=$(your_email)&affiliation=$(your_affiliation)&mailing_list=$(mailing_list)&reason=$(reason_for_use)&api_key=$(api_key)&attributes=$(attributes)";

    # The first two rows are not data values
    # The column names and the "first row" are metadata identifiers and values, respectively
    # The "second row" is what we'd consider the "column names" for the actual data, which is row 3 and beyond

    # read the actual data, "row" 3 and below
    nsrdb_data_frame = read_csv(url, skiprows=2);
    
    return nsrdb_data_frame;
end

function get_nsrdb_sam_pv_output(;pipeline=true)
    if pipeline == true
        nsrdb_data_frame = get_nsrdb_raw_solar_data(9.817934, -84.070552, 2010);
        py"""
        import sys
        sys.path.insert(0, ".")
        sys.path.insert(0, "./functions")
        """
        call_ssc_with_dataframe = pyimport("nsrdb_python")["call_ssc_with_dataframe"]
        call_ssc_with_dataframe(nsrdb_data_frame);
        pv_output = values(nsrdb_data_frame["Generation"])
    else
        pv_output=readdlm("data/pv_output.txt", '\t', Float64, '\n')
    end
    return pv_output
end
    
function plot_pysam_output(df, i=5030, j=40)
    plt.style.use("ggplot")
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax2 = ax.twinx()
    ax.plot(df[["GHI", "DNI", "DHI", "Solar Zenith Angle"]][i:i+j]) # , handles={"90 Degree Zenith": "--","Solar Zenith Angle": "-o", "DNI": "-o", "DHI": "-o", "GHI": "-o"}
    ax2.plot(df[["Generation"]][i:i+j], color="g") #, handles={"Generation": "y-o"}
    ax.grid()
    ax.set_ylabel("W/m2")
    ax2.set_ylabel("kW")
    ax.legend(df[["GHI", "DNI", "DHI", "Solar Zenith Angle"]][i:i+j], loc="upper left")
    ax2.legend(df[["Generation"]][i:i+j], loc="upper right")
end    