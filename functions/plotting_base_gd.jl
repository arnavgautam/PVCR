# Year  Month  Energy generated?  Energy Desposited?  Withdrawn energy?     Amount of energy used     Company   Tariff number   
# A       B          C                     D               E                         F                 G               H               
# ANNO, MES,  ENERGIA_GENERADA,  ENERGIA_DEPOSITADA, ENERGIA_RETIRADA  IMPORTE_POR_ENERGIA_RETIRADA,  EMPRESA, CODIGO_TARIFA,

# Tariff description   Total consumption
#         I                 J                K                       L               M                 N               O
# CODIGO_TARIFA1,     TOTAL_CONSUMO_KWH, TOTAL_IMPORTE_ENE, Suma de DISTRITO, Recuento de DISTRITO,  Provincia1,  CONSUMO_NATURAL,  SECTOR,  Data_Check

using DataFrames
using PyPlot

tariff_categories = ["Residential", "Commercial Industrial", "Medium Voltage"]

tariff_category_mappings = Dict([
        (1, tariff_categories[1]),
        (4, tariff_categories[2]),
        (5, tariff_categories[2]),
        (6, tariff_categories[2]),
        (7, tariff_categories[2]),
        (12, tariff_categories[3])
        ])

f = open("data/pv_output.txt");
onekW_output_solar_year = map(row -> tryparse(Float64,row), readlines(f));

output_by_month = Array{Float64}(undef,12)
# First entry for looping purposes only
days_per_month = [0,31,28,31,30,31,30,31,31,30,31,30,31]

for i=1:12
    output_by_month[i] = sum(onekW_output_solar_year[sum(days_per_month[1:i])*24+1:sum(days_per_month[1:i+1])*24])
end

function generation_to_installation(data_frame)
    installation_array = Array{Float64}(undef,0)
    for r in eachrow(data_frame)
        month = r.MES
        generation = r.ENERGIA_GENERADA
        installation = generation / output_by_month[month]
        push!(installation_array, installation)
    end
    return installation_array
end
        

# This function cleans up the data for a particular utility+tariff
function create_consumption_and_installation_arrays(utility_bill_df)    
    # Only keep entries with valid ENERGIA_GENERADA and CONSUMO_NATURAL
    cleaned_df = filter(row -> (!ismissing(row.ENERGIA_GENERADA) && !ismissing(row.CONSUMO_NATURAL)), utility_bill_df)
    
    # Only keep entries with PV system output > 100 kWh per month (this would mean it's a roughly 1kW system)
    string_to_float(str) = tryparse(Float64, str)
    cleaned_df[:CONSUMO_NATURAL] = map(string_to_float, cleaned_df[:CONSUMO_NATURAL])
    cleaned_df = filter(row -> (row.CONSUMO_NATURAL > 100), cleaned_df)
    
    consumption_and_installation = [[],[]]
    consumption_and_installation[1] = cleaned_df[:CONSUMO_NATURAL]
    
    # We need, not generation, but installed size
    # Thus, each value in ENERGIA_GENERADA needs to be divided by the energy generated by a theoretical 1kW system
    # As of right now, we use an example output of a "solar year" from pv_output.txt
    consumption_and_installation[2] = generation_to_installation(cleaned_df)
    
    
    return consumption_and_installation
end

# This function takes in consumption and installation arrays, and plots them
function plot_consumption_and_installation(consumption_and_installation, tariff_name, company_name)
    plt.figure()
    # Plot out the actual PV system sizes that people have based on their energy bills
    the_plot = plot(consumption_and_installation[1], consumption_and_installation[2], ".")
    ylabel("PV System Capacity [kW]")
    xlabel("Consumer Monthly Energy use [kWh]")
    grid("on");
    title(string("PV System Capacity for ", company_name, " Consumer with Tariff ", tariff_name))
    return the_plot
end

function plot_base_GD_vs_economically_rational(consumption_and_installation, tariff_name, company_name, consumption, model_predictions)
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    # Plot out the actual PV system sizes that people have based on their energy bills
    ax1.scatter(consumption_and_installation[1], consumption_and_installation[2], marker=".", label = string("Actual PV System Installation for ", tariff_name, " Consumer"))
    # Plot out the installation predicted by the economically rational model
    ax1.plot(consumption, model_predictions, c = "r", label = string("Optimal PV System for ", tariff_name, " Consumer"))
    legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.);
    ylabel("PV System Capacity [kW]")
    xlabel("Consumer Monthly Energy use [kWh]")
    grid("on");
    title(string("PV System Capacity for ", company_name, " Consumer with Tariff ", tariff_name))
end
  
function plot_single_tariff_category_per_company_with_model_prediction(company_data, tariff_category, company_name, consumption, model_predictions)
    company_data_split_by_tariff_category = Array{DataFrame}(undef,3)

    # Loop through all tariffs that we care about
    for (tariff_num, tariff_category) in tariff_category_mappings
        next_value = filter(row -> (!ismissing(row.CODIGO_TARIFA) && row.CODIGO_TARIFA == string(tariff_num)), company_data)
        category_index = findfirst(t -> t == tariff_category, tariff_categories)
        if !isassigned(company_data_split_by_tariff_category, category_index)
            company_data_split_by_tariff_category[category_index] = next_value
        else
            append!(company_data_split_by_tariff_category[category_index], next_value)
        end
    end
    
    category_index = findfirst(t -> t == tariff_category, tariff_categories)
    
    plot_base_GD_vs_economically_rational(create_consumption_and_installation_arrays(
                company_data_split_by_tariff_category[category_index]), tariff_categories[category_index], company_name, consumption, model_predictions)
end

function plot_all_tariffs_per_company(company_data, company_name)
    company_data_split_by_tariff_category = Array{DataFrame}(undef,3)

    # Loop through all tariffs that we care about
    for (tariff_num, tariff_category) in tariff_category_mappings
        next_value = filter(row -> (!ismissing(row.CODIGO_TARIFA) && row.CODIGO_TARIFA == string(tariff_num)), company_data)
        category_index = findfirst(t -> t == tariff_category, tariff_categories)
        if !isassigned(company_data_split_by_tariff_category, category_index)
            company_data_split_by_tariff_category[category_index] = next_value
        else
            append!(company_data_split_by_tariff_category[category_index], next_value)
        end
    end
    
    # Loop through and plot each tariff category
    for i in 1:3
        plot_consumption_and_installation(create_consumption_and_installation_arrays(
                company_data_split_by_tariff_category[i]), tariff_categories[i], company_name)
    end
end