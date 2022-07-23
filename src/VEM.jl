module VEM

using LinearAlgebra

using FillArrays
using StaticArrays

include("linalg.jl")

include("blobs.jl")
export Blobs
export charge_type
export radius_type
export source_type
export dimension
export scalar_type

include("compute_field.jl")
export compute_field
export compute_field!

end
