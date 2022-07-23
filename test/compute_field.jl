using LinearAlgebra, Test
using StaticArrays
using VEM

function vector_kernel(circulation, radius, source, target)
    r = target - source
    rSq = dot(r, r)
    rhoSq = rSq/(radius*radius)

    f = cross(circulation, r)/(rSq*pi*2)
    g = 1 - exp(-rhoSq/2)

    return f*g
end

VEM.kernel_output_size(::typeof(vector_kernel)) = Size(2)

function dyadic_kernel(circulation, radius, source, target)
    T = similar_type(promote_type(typeof(source), typeof(target)), Size(2, 2))

    r = target - source
    rSq = dot(r, r)
    eSq = radius*radius
    circulationCrossR = cross(circulation, r)
    expRho = exp(-rSq/(2*eSq))
    c = rSq*pi*2
    A = T(0, circulation, -circulation, 0)

    f = circulationCrossR/c
    f_grad = (A - (2/rSq)*circulationCrossR*r')/c

    g = 1 - expRho
    g_grad = expRho*r/eSq

    return f_grad*g + f*g_grad'
end

VEM.kernel_output_size(::typeof(dyadic_kernel)) = Size(2, 2)

@testset "Single source single target" begin
    circulation = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]
    target = [SVector(3.0, 4.0)]

    blobs = Blobs(circulation, radius, source)

    @test compute_field(vector_kernel, blobs, target) == [vector_kernel(circulation[1], radius[1], source[1], target[1])]
end

@testset "Multiple sources single target" begin
    circulations = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    target = [SVector(3.0, 4.0)]

    blobs = Blobs(circulations, radii, sources)

    @test compute_field(vector_kernel, blobs, target) == [sum(vector_kernel.(circulations, radii, sources, target))]
end

@testset "Single source multiple targets" begin
    circulation = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]
    targets = [SVector(3.0, 4.0), SVector(-3.0, 4.0), SVector(-3.0, -4.0), SVector(3.0, -4.0)]

    blobs = Blobs(circulation, radius, source)

    @test compute_field(vector_kernel, blobs, targets) == [sum(vector_kernel.(circulation, radius, source, Ref(target))) for target in targets]
end

@testset "Multiple sources multiple targets" begin
    circulations = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]

    blobs = Blobs(circulations, radii, sources)

    @test compute_field(vector_kernel, blobs, targets) == [sum(vector_kernel.(circulations, radii, sources, Ref(target))) for target in targets]
end

@testset "Compute field in place" begin
    circulations = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]
    field = zeros(eltype(sources), length(targets))

    blobs = Blobs(circulations, radii, sources)
    compute_field!(field, vector_kernel, blobs, targets)

    @test field == [sum(vector_kernel.(circulations, radii, sources, Ref(target))) for target in targets]
end

@testset "Compute dyadic field" begin
    circulations = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]

    blobs = Blobs(circulations, radii, sources)

    @test compute_field(dyadic_kernel, blobs, targets) == [sum(dyadic_kernel.(circulations, radii, sources, Ref(target))) for target in targets]
end

@testset "Interface method kernel_output_size extended for kernel" begin
    circulation = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]
    target = [SVector(3.0, 4.0)]

    blobs = Blobs(circulation, radius, source)

    function kernel(circulation, radius, source, target)
        return SVector(0.0, 0.0)
    end

    VEM.kernel_output_size(::typeof(kernel)) = Size(2)

    @test compute_field(kernel, blobs, target) == [SVector(0.0, 0.0)]
end

@testset "Interface method kernel_output_size not extended for kernel" begin
    circulation = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]
    target = [SVector(3.0, 4.0)]

    blobs = Blobs(circulation, radius, source)

    function kernel(circulation, radius, source, target)
        return SVector(0.0, 0.0)
    end

    @test_throws ErrorException("Interface method 'kernel_output_size' has not been extended for kernel '$kernel'.") compute_field(kernel, blobs, target) 
end