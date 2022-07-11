using LinearAlgebra, Test
using StaticArrays
using VEM

function vector_kernel(charge, radius, source, target)
    r = target - source
    rSq = dot(r, r)
    rhoSq = rSq/(radius*radius)

    f = cross(charge, r)/(rSq*pi*2)
    g = 1 - exp(-rhoSq/2)

    return f*g
end

VEM.kernel_output_size(::typeof(vector_kernel)) = Tuple{2}

function dyadic_kernel(charge, radius, source, target)
    r = target - source
    rSq = dot(r, r)
    rhoSq = rSq/(radius*radius)

    f = -cross(charge, r)*(r'/(rSq*pi))
    g = 1 - exp(-rhoSq/2)

    return f*g
end

VEM.kernel_output_size(::typeof(dyadic_kernel)) = Tuple{2, 2}

@testset "Single source single target" begin
    charge = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]
    target = [SVector(3.0, 4.0)]

    blobs = Blobs(charge, radius, source)

    @test compute_field(vector_kernel, blobs, target) == [vector_kernel(charge[1], radius[1], source[1], target[1])]
end

@testset "Multiple sources single target" begin
    charges = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    target = [SVector(3.0, 4.0)]

    blobs = Blobs(charges, radii, sources)

    @test compute_field(vector_kernel, blobs, target) == [sum(vector_kernel.(charges, radii, sources, target))]
end

@testset "Single source multiple targets" begin
    charge = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]
    targets = [SVector(3.0, 4.0), SVector(-3.0, 4.0), SVector(-3.0, -4.0), SVector(3.0, -4.0)]

    blobs = Blobs(charge, radius, source)

    @test compute_field(vector_kernel, blobs, targets) == [sum(vector_kernel.(charge, radius, source, Ref(target))) for target in targets]
end

@testset "Multiple sources multiple targets" begin
    charges = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]

    blobs = Blobs(charges, radii, sources)

    @test compute_field(vector_kernel, blobs, targets) == [sum(vector_kernel.(charges, radii, sources, Ref(target))) for target in targets]
end

@testset "Compute field in place" begin
    charges = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]
    field = zeros(eltype(sources), length(targets))

    blobs = Blobs(charges, radii, sources)
    compute_field!(field, vector_kernel, blobs, targets)

    @test field == [sum(vector_kernel.(charges, radii, sources, Ref(target))) for target in targets]
end

@testset "Compute dyadic field" begin
    charges = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]

    blobs = Blobs(charges, radii, sources)

    @test compute_field(dyadic_kernel, blobs, targets) == [sum(dyadic_kernel.(charges, radii, sources, Ref(target))) for target in targets]
end

@testset "Method kernel_output_size not defined for kernel" begin
    charge = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]
    target = [SVector(3.0, 4.0)]

    blobs = Blobs(charge, radius, source)

    function foo()
        return nothing
    end

    @test_throws ErrorException("Output size computation for kernel '$foo' has not yet been implemented via 'kernel_output_size'.") compute_field(foo, blobs, target) 
end