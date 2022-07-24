using SafeTestsets  

@safetestset "Vortex blobs" begin include("vortex_blobs.jl") end
@safetestset "N-body summation" begin include("compute_field.jl") end
