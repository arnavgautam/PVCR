using DelimitedFiles
using PyPlot
using Distributions
using DataFrames
using CSV
using Random
using Roots

Random.seed!(123)
PyPlot.svg(true)

cpalette10 = [
"#1f77b4"
"#ff7f0e"
"#2ca02c"
"#d62728"
"#9467bd"
"#e377c2"
"#8c564b"
"#7f7f7f"
"#bcbd22"
"#17becf"]

cpalette20 = ["#1f77b4",
 "#aec7e8",
 "#ff7f0e",
 "#ffbb78",
 "#2ca02c",
 "#98df8a",
 "#d62728",
 "#ff9896",
 "#9467bd",
 "#c5b0d5",
 "#8c564b",
 "#c49c94",
 "#e377c2",
 "#f7b6d2",
 "#7f7f7f",
 "#c7c7c7",
 "#bcbd22",
 "#dbdb8d",
 "#17becf",
 "#9edae5"]

include("types/tariffs.jl")
include("types/consumers.jl")
include("types/financials.jl")
include("types/pvsystems.jl")

include("functions/printing_results.jl")
include("functions/balance_energy.jl")
include("functions/balance_energy_nmw.jl")
include("functions/consumer.jl")
include("functions/billing.jl")
include("functions/financials.jl")
include("functions/pvsystem.jl")
include("functions/depictions.jl")
include("functions/tariff.jl")
include("functions/tariffs_hist.jl")
include("functions/printing_tariffs.jl")
include("functions/optimal_pvsystem.jl")
include("functions/retrieve_nsrdb_data.jl")

include("data/tariff_data.jl")
include("data/tariff_data_alternative.jl")
include("data/pvsystem_data.jl")
include("data/consumer_data.jl");