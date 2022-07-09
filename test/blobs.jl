using Test
using StaticArrays
using VEM

@testset "Construct 2D Blobs" begin
    circulation = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]

    blobs = Blobs(circulation, radius, source)

    @test blobs.circulation == circulation
    @test blobs.radius == radius
    @test blobs.source == source
end

@testset "Construct 3D Blobs" begin
    circulation = [SVector(1.23, 3.45, 5.67)]
    radius = [0.45]
    source = [SVector(0.0, 0.0, 0.0)]

    blobs = Blobs(circulation, radius, source)

    @test blobs.circulation == circulation
    @test blobs.radius == radius
    @test blobs.source == source
end

@testset "Construct Blobs with invalid source dimension" begin
    circulation = [SVector(1.23, 3.45, 5.67)]
    radius = [0.45]
    source = [SVector(0.0, 0.0, 0.0, 0.0)]

    @test_throws ErrorException("Sources of Blobs must be 2D or 3D") blobs = Blobs(circulation, radius, source)
end

@testset "Construct inconsistent Blobs with 2D source not 1D circulation" begin
    circulation = [SVector(1.23, 3.45)]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]

    @test_throws ErrorException("Inconsistent dimension of circulation for a 2D source") blobs = Blobs(circulation, radius, source)
end

@testset "Construct inconsistent Blobs with 3D source not 3D circulation" begin
    circulation = [SVector(1.23, 3.45)]
    radius = [0.45]
    source = [SVector(0.0, 0.0, 0.0)]

    @test_throws ErrorException("Inconsistent dimension of circulation for a 3D source") blobs = Blobs(circulation, radius, source)
end

@testset "Field length inconsistency" begin
    circulation = [1.23, 4.04]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]

    @test_throws ErrorException("Inconsistent field lengths for construction of Blobs") blobs = Blobs(circulation, radius, source)
end

@testset "Field type inconsistency" begin
    circulation = Float16[1.23]
    radius = Float32[0.45]
    source = [SVector(0.0, 0.0)]

    @test_throws ErrorException("Inconsistent field types for construction of Blobs") blobs = Blobs(circulation, radius, source)
end