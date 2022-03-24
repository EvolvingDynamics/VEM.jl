using LinearAlgebra, Test
using StaticArrays
using VEM

function kernel(circulation, radius, source, target)
    r = target - source
    rSq = dot(r, r)
    rhoSq = rSq/(radius*radius)

    f = cross(circulation, r)/(rSq*pi*2)
    g = 1 - exp(-rhoSq/2)

    return f*g
end

@testset "Single source single target" begin
    circulation = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]
    target = [SVector(3.0, 4.0)]

    blobs = Blobs(circulation, radius, source)

    @test compute_field(kernel, blobs, target) == [kernel(circulation[1], radius[1], source[1], target[1])]
end

@testset "Multiple sources single target" begin
    circulations = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    target = [SVector(3.0, 4.0)]

    blobs = Blobs(circulations, radii, sources)

    @test compute_field(kernel, blobs, target) == [sum(kernel.(circulations, radii, sources, target))]
end

@testset "Single source multiple targets" begin
    circulation = [1.23]
    radius = [0.45]
    source = [SVector(0.0, 0.0)]
    targets = [SVector(3.0, 4.0), SVector(-3.0, 4.0), SVector(-3.0, -4.0), SVector(3.0, -4.0)]

    blobs = Blobs(circulation, radius, source)

    @test compute_field(kernel, blobs, targets) == [sum(kernel.(circulation, radius, source, Ref(target))) for target in targets]
end

@testset "Multiple sources multiple targets" begin
    circulations = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]

    blobs = Blobs(circulations, radii, sources)

    @test compute_field(kernel, blobs, targets) == [sum(kernel.(circulations, radii, sources, Ref(target))) for target in targets]
end

@testset "Compute field low-level interface consistency" begin
    circulations = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]

    blobs = Blobs(circulations, radii, sources)

    @test compute_field(kernel, blobs, targets) == VEM._compute_field(kernel, circulations, radii, sources, targets)
end

@testset "Compute field in place" begin
    circulations = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]
    field = zeros(eltype(sources), length(targets))

    blobs = Blobs(circulations, radii, sources)
    compute_field!(field, kernel, blobs, targets)

    @test field == [sum(kernel.(circulations, radii, sources, Ref(target))) for target in targets]
end