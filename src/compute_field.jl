kernel_output_size(f::Function) = error("Interface method 'kernel_output_size' has not been extended for kernel '$f'.")

function kernel_output_type(kernel, blobs, targets)
    return similar_type(promote_type(source_eltype(blobs), eltype(targets)), kernel_output_size(kernel))
end

function compute_field(kernel, blobs, targets)
    T = kernel_output_type(kernel, blobs, targets)
    field = zeros(T, length(targets))
    _compute_field!(field, kernel, blobs.charge, blobs.radius, blobs.source, targets)
    return field
end

function compute_field!(field, kernel, blobs, targets)
    _compute_field!(field, kernel, blobs.charge, blobs.radius, blobs.source, targets)
end

function _compute_field!(field, kernel, charges, radii, sources, targets)
    num_sources = length(sources)
    for (index, target) in enumerate(targets)
        @inbounds field[index] = mapreduce(kernel, +, charges, radii, sources, Fill(target, num_sources))
    end
end