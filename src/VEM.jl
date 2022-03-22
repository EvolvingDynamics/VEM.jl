module VEM

using LinearAlgebra
using StaticArrays

include("linalg.jl")

include("blobs.jl")
export Blobs

include("compute_field.jl")
export compute_field
export compute_field!

end
