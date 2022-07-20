using Test
using StaticArrays
using VEM

@testset "Construction in 2D" begin    
    @testset "Construct a blob" begin
        charge = [1.23]
        radius = [0.45]
        source = [SVector(0.0, 0.0)]

        blobs = Blobs(charge, radius, source)

        @test blobs.charge == charge
        @test blobs.radius == radius
        @test blobs.source == source
    end

    @testset "Construct blobs" begin
        charge = [1.23, 4.56]
        radius = [0.45, 0.67]
        source = [SVector(0.0, 0.0), SVector(0.1, 0.1)]

        blobs = Blobs(charge, radius, source)

        @test blobs.charge == charge
        @test blobs.radius == radius
        @test blobs.source == source
    end

    @testset "Inconsistent attribute lengths" begin
        charge = [1.23]
        radius = [0.45, 0.67]
        source = [SVector(0.0, 0.0)]

        @test_throws ErrorException("Inconsistent attribute lengths for construction of Blobs") blobs = Blobs(charge, radius, source)
    end

    @testset "Inconsistent attribute types" begin
        charge = [1.23]
        radius = Float32[0.45]
        source = [SVector(0.0, 0.0)]

        @test_throws ErrorException("Inconsistent attribute types for construction of Blobs") blobs = Blobs(charge, radius, source)
    end

    @testset "Invalid charge dimension" begin
        charge = [SVector(1.23, 4.56)]
        radius = [0.45]
        source = [SVector(0.0, 0.0)]

        @test_throws ErrorException("Invalid type of scalar value for attributes of Blobs") blobs = Blobs(charge, radius, source)
    end
end

@testset "Construction in 3D" begin
    @testset "Construct a blob" begin
        charge = [SVector(1.23, 4.56, 7.89)]
        radius = [0.45]
        source = [SVector(0.0, 0.0, 0.0)]

        blobs = Blobs(charge, radius, source)

        @test blobs.charge == charge
        @test blobs.radius == radius
        @test blobs.source == source
    end

    @testset "Construct blobs" begin
        charge = [SVector(1.23, 4.56, 7.89), SVector(3.21, 6.54, 9.87)]
        radius = [0.54, 0.67]
        source = [SVector(0.0, 0.0, 0.0), SVector(0.1, 0.1, 0.1)]

        blobs = Blobs(charge, radius, source)

        @test blobs.charge == charge
        @test blobs.radius == radius
        @test blobs.source == source
    end

    @testset "Inconsistent attribute lengths" begin
        charge = [SVector(1.23, 4.56, 7.89), SVector(3.21, 6.54, 9.87)]
        radius = [0.54]
        source = [SVector(0.0, 0.0, 0.0), SVector(0.1, 0.1, 0.1)]

        @test_throws ErrorException("Inconsistent attribute lengths for construction of Blobs") blobs = Blobs(charge, radius, source)
    end

    @testset "Inconsistent attribute types" begin
        charge = [SVector(1.23, 4.56, 7.89), SVector(3.21, 6.54, 9.87)]
        radius = Float32[0.54, 0.67]
        source = [SVector(0.0, 0.0, 0.0), SVector(0.1, 0.1, 0.1)]

        @test_throws ErrorException("Inconsistent attribute types for construction of Blobs") blobs = Blobs(charge, radius, source)
    end

    @testset "Invalid charge dimension" begin
        charge = [SVector(1.23, 7.89), SVector(3.21, 9.87)]
        radius = [0.54, 0.67]
        source = [SVector(0.0, 0.0, 0.0), SVector(0.1, 0.1, 0.1)]

        @test_throws ErrorException("Invalid charge dimension for 3D Blobs") blobs = Blobs(charge, radius, source)
    end

    @testset "Invalid scalar value type" begin
        charge = [SVector(1//3, 4//6, 7//9), SVector(3//1, 6//4, 9//7)]
        radius = [0//4, 0//7]
        source = [SVector(0//2, 0//2, 0//2), SVector(1//2, 1//2, 1//2)]

        @test_throws ErrorException("Invalid type of scalar value for attributes of Blobs") blobs = Blobs(charge, radius, source)
    end
end

@testset "Attributes interface" begin
    @testset "Blob charge eltype" begin
        charge = [1.23]
        radius = [0.45]
        source = [SVector(0.0, 0.0)]

        blobs = Blobs(charge, radius, source)

        @test charge_eltype(blobs) == eltype(charge)
    end

    @testset "Blob radius eltype" begin
        charge = [1.23]
        radius = [0.45]
        source = [SVector(0.0, 0.0)]

        blobs = Blobs(charge, radius, source)

        @test radius_eltype(blobs) == eltype(radius)
    end

    @testset "Blob source eltype" begin
        charge = [1.23]
        radius = [0.45]
        source = [SVector(0.0, 0.0)]

        blobs = Blobs(charge, radius, source)

        @test source_eltype(blobs) == eltype(source)
    end
end