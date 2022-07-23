using Test
using StaticArrays
using VEM

@testset "2D" begin
    @testset "Construct blobs" begin
        @testset "Construct one blob" begin
            charge = [1.23]
            radius = [0.45]
            source = [SVector(0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test blobs.charge == charge
            @test blobs.radius == radius
            @test blobs.source == source
        end

        @testset "Construct multiple blobs" begin
            charge = [1.23, 4.56]
            radius = [0.45, 0.67]
            source = [SVector(0.0, 0.0), SVector(0.1, 0.1)]

            blobs = Blobs(charge, radius, source)

            @test blobs.charge == charge
            @test blobs.radius == radius
            @test blobs.source == source
        end

        @testset "Throw exception when constructing blobs with non-matching field lengths" begin
            charge_two = [1.23, 4.56]
            radius_two = [0.45, 0.67]
            source_two = [SVector(0.0, 0.0), SVector(0.1, 0.1)]

            charge_three = [1.23, 4.56, 7.89]
            radius_three = [0.45, 0.67, 0.89]
            source_three = [SVector(0.0, 0.0), SVector(0.1, 0.1), SVector(0.2, 0.2)]

            err = ArgumentError("Inconsistent number of charges, radii and sources.")

            @test_throws err Blobs(charge_three, radius_two, source_two)
            @test_throws err Blobs(charge_two, radius_three, source_two)
            @test_throws err Blobs(charge_three, radius_three, source_two)
            @test_throws err Blobs(charge_two, radius_two, source_three)
            @test_throws err Blobs(charge_three, radius_two, source_three)
            @test_throws err Blobs(charge_two, radius_three, source_three)
        end

        @testset "Throw exception when constructing blobs with non-scalar circulation" begin
            charge = [SVector(1.23, 4.56, 7.89)]
            radius = [0.45]
            source = [SVector(0.0, 0.0)]

            err = ArgumentError("Invalid circulation dimension for 2D blobs. It should be a scalar.")

            @test_throws err Blobs(charge, radius, source)
        end
    end

    @testset "Field interfaces" begin
        @testset "Blob charge type" begin
            charge = [1.23]
            radius = [0.45]
            source = [SVector(0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test charge_type(blobs) == eltype(charge)
        end

        @testset "Blob radius type" begin
            charge = [1.23]
            radius = [0.45]
            source = [SVector(0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test radius_type(blobs) == eltype(radius)
        end

        @testset "Blob source type" begin
            charge = [1.23]
            radius = [0.45]
            source = [SVector(0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test source_type(blobs) == eltype(source)
        end

        @testset "Blob dimension" begin
            charge = [1.23]
            radius = [0.45]
            source = [SVector(0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test dimension(blobs) == 2
        end

        @testset "Blob scalar_type" begin
            charge = [Float16(1.23)]
            radius = [Float16(0.45)]
            source = [SVector{2, Float16}(0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test scalar_type(blobs) == Float16
        end
    end
end

@testset "3D" begin
    @testset "Construct blobs" begin
        @testset "Construct one blob" begin
            charge = [SVector(1.23, 4.56, 7.89)]
            radius = [0.45]
            source = [SVector(0.0, 0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test blobs.charge == charge
            @test blobs.radius == radius
            @test blobs.source == source
        end

        @testset "Construct multiple blobs" begin
            charge = [SVector(1.23, 4.56, 7.89), SVector(3.21, 6.54, 9.87)]
            radius = [0.54, 0.67]
            source = [SVector(0.0, 0.0, 0.0), SVector(0.1, 0.1, 0.1)]

            blobs = Blobs(charge, radius, source)

            @test blobs.charge == charge
            @test blobs.radius == radius
            @test blobs.source == source
        end

        @testset "Throw exception when constructing blobs with non-matching field lengths" begin
            charge_two = [SVector(0.12, 0.34, 0.56), SVector(0.21, 0.43, 0.65)]
            radius_two = [0.45, 0.67]
            source_two = [SVector(0.0, 0.0, 0.0), SVector(0.1, 0.1, 0.1)]

            charge_three = [SVector(0.12, 0.34, 0.56), SVector(0.21, 0.43, 0.65), SVector(0.11, 0.22, 0.33)]
            radius_three = [0.45, 0.67,  0.89]
            source_three = [SVector(0.0, 0.0, 0.0), SVector(0.1, 0.1, 0.1), SVector(0.2, 0.2, 0.2)]

            err = ArgumentError("Inconsistent number of charges, radii and sources.")

            @test_throws err Blobs(charge_three, radius_two, source_two)
            @test_throws err Blobs(charge_two, radius_three, source_two)
            @test_throws err Blobs(charge_three, radius_three, source_two)
            @test_throws err Blobs(charge_two, radius_two, source_three)
            @test_throws err Blobs(charge_three, radius_two, source_three)
            @test_throws err Blobs(charge_two, radius_three, source_three)
        end

        @testset "Throw exception when constructing blobs with non-3-vector circulation" begin
            charge = [SVector(1.23, 4.56)]
            radius = [0.45]
            source = [SVector(0.0, 0.0, 0.0)]

            err = ArgumentError("Invalid circulation dimension for 3D blobs. It should be a 3-vector.")

            @test_throws err Blobs(charge, radius, source)
        end
    end

    @testset "Field interfaces" begin
        @testset "Blob charge type" begin
            charge = [SVector(1.23, 4.56, 7.89)]
            radius = [0.45]
            source = [SVector(0.0, 0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test charge_type(blobs) == eltype(charge)
        end

        @testset "Blob radius type" begin
            charge = [SVector(1.23, 4.56, 7.89)]
            radius = [0.45]
            source = [SVector(0.0, 0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test radius_type(blobs) == eltype(radius)
        end

        @testset "Blob source type" begin
            charge = [SVector(1.23, 4.56, 7.89)]
            radius = [0.45]
            source = [SVector(0.0, 0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test source_type(blobs) == eltype(source)
        end

        @testset "Blob dimension" begin
            charge = [SVector(1.23, 4.56, 7.89)]
            radius = [0.45]
            source = [SVector(0.0, 0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test dimension(blobs) == 3
        end

        @testset "Blob scalar type" begin
            charge = [SVector{3, Float16}(1.23, 4.56, 7.89)]
            radius = [Float16(0.45)]
            source = [SVector{3, Float16}(0.0, 0.0, 0.0)]

            blobs = Blobs(charge, radius, source)

            @test scalar_type(blobs) == Float16
        end
    end
end

@testset "Invalid dimension" begin
    @testset "Construct blobs" begin
        @testset "Throw exception when constructing 1D blobs" begin
            charge = [1.23]
            radius = [0.45]
            source = [SVector(0.0)]

            err = ArgumentError("Invalid blob dimension.")

            @test_throws err Blobs(charge, radius, source)
        end

        @testset "Throw exception when constructing 4D blobs" begin
            charge = [SVector(1.23, 4.56, 7.89)]
            radius = [0.45]
            source = [SVector(0.0, 0.0, 0.0, 0.0)]

            err = ArgumentError("Invalid blob dimension.")

            @test_throws err Blobs(charge, radius, source)
        end
    end
end