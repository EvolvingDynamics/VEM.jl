module VEM

using LinearAlgebra
using StaticArrays

include("linalg.jl")

include("compute_field.jl")
export compute_field

end
