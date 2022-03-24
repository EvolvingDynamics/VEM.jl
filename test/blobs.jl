using Test
using StaticArrays
using VEM

@testset "Construct Blobs" begin
    circulation = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]

    blobs = Blobs(circulation, radius, source)

    @test blobs.circulation == circulation
    @test blobs.radius == radius
    @test blobs.source == source
end

@testset "Field length consistency" begin
    circulation = [1.23, 4.04]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]

    @test_throws ErrorException("Inconsistent field lengths for construction of Blobs") blobs = Blobs(circulation, radius, source)
end

@testset "Field type consistency" begin
    circulation = Float16[1.23]
    radius = Float32[0.45]
    source = [SVector(0.0, 0.0)]

    @test_throws ErrorException("Inconsistent field types for construction of Blobs") blobs = Blobs(circulation, radius, source)
end