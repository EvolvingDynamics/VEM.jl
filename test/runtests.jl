using SafeTestsets  

@safetestset "Blobs" begin include("blobs.jl") end
@safetestset "N-body summation" begin include("compute_field.jl") end
