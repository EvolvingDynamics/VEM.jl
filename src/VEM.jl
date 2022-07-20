module VEM

using LinearAlgebra

using FillArrays
using StaticArrays

include("linalg.jl")

include("blobs.jl")
export Blobs
export charge_eltype
export radius_eltype
export source_eltype
export scalar_type

include("compute_field.jl")
export compute_field
export compute_field!

end
