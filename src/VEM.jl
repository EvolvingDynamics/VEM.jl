module VEM

using LinearAlgebra

using FillArrays
using StaticArrays

include("linalg.jl")

include("vortex_blobs.jl")
export VortexBlobs
export circulation_type
export radius_type
export source_type
export dimension
export scalar_type

include("compute_field.jl")
export compute_field
export compute_field!

end
