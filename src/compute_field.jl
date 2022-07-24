kernel_output_size(f::Function) = error("Interface method 'kernel_output_size' has not been extended for kernel '$f'.")

function kernel_output_type(kernel, blobs, targets)
    return similar_type(promote_type(source_type(blobs), eltype(targets)), kernel_output_size(kernel))
end

"""
    compute_field(kernel, blobs, targets)

Compute a field defined by `kernel` induced by a distribution of `blobs` at `targets`.

The induced field is specified by a `kernel` function.
The `kernel` computes the induction due to a single blob at a single target.
The dimension of the output must be defined by extending `kernel_output_size` for the type of the `kernel` function.
It should take `kernel` as input and return a `StaticArrays.Size`.
Outputs of arbitrary tensor rank are supported in 2D and 3D.

# Example

Compute the velocity due to three 2D blobs at four targets:

    using LinearAlgebra
    using StaticArrays
    using VEM

    function velocity(circulation, radius, source, target)
        r = target - source
        rSq = dot(r, r)

        f = cross(circulation, r)/(rSq*pi*2)
        g = 1 - exp(-rSq/(2*radius^2))

        return f*g
    end

    VEM.kernel_output_size(::typeof(velocity)) = Size(2)

    circulations = [1.23, 4.56, 7.89]
    radii = [0.45, 0.90, 1.80]
    sources = [SVector(-3.0, 4.0), SVector(-5.0, 0.0), SVector(1.0, 2.0)] 
    blobs = VortexBlobs(circulations, radii, sources)

    targets = [SVector(3.0, 5.0), SVector(-3.0, 5.0), SVector(-3.0, -5.0), SVector(3.0, -5.0)]

    velocity_field = compute_field(velocity, blobs, targets)
"""
function compute_field(kernel, blobs::VortexBlobs, targets)
    T = kernel_output_type(kernel, blobs, targets)
    field = zeros(T, length(targets))
    _compute_field!(field, kernel, blobs.circulation, blobs.radius, blobs.source, targets)
    return field
end

"""
    compute_field!(field, kernel, blobs, targets)

In-place version of [`compute_field`](@ref).

The induced field is stored in `field`.
The output type of `kernel` must be compatible with `eltype(field)`.
"""
function compute_field!(field, kernel, blobs::VortexBlobs, targets)
    _compute_field!(field, kernel, blobs.circulation, blobs.radius, blobs.source, targets)
end

function _compute_field!(field, kernel, circulations, radii, sources, targets)
    num_sources = length(sources)
    Threads.@threads for index in eachindex(targets)
        @inbounds field[index] = mapreduce(kernel, +, circulations, radii, sources, Fill(targets[index], num_sources))
    end
end