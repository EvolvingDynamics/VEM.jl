function compute_field(kernel, blobs, targets)
    T = promote_type(eltype(blobs.source), eltype(targets))
    field = zeros(T, length(targets))
    _compute_field!(field, kernel, blobs.circulation, blobs.radius, blobs.source, targets)
    return field
end

function compute_field!(field, kernel, blobs, targets)
    _compute_field!(field, kernel, blobs.circulation, blobs.radius, blobs.source, targets)
end

function _compute_field!(field, kernel, circulations, radii, sources, targets)
    num_sources = length(sources)
    for (index, target) in enumerate(targets)
        @inbounds field[index] = mapreduce(kernel, +, circulations, radii, sources, Fill(target, num_sources))
    end
end