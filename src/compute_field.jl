function compute_field(kernel, blobs, targets)
    return compute_field(kernel,
                         blobs.circulation,
                         blobs.radius,
                         blobs.source,
                         targets)
end

function compute_field!(field, kernel, blobs, targets)
    return compute_field!(field,
                          kernel,
                          blobs.circulation,
                          blobs.radius,
                          blobs.source,
                          targets)
end

function compute_field(kernel, circulations, radii, sources, targets)
    T = promote_type(eltype(sources), eltype(targets))
    field = zeros(T, length(targets))
    compute_field!(field, kernel, circulations, radii, sources, targets)
    return field
end

function compute_field!(field, kernel, circulations, radii, sources, targets)
    for (index, target) in enumerate(targets)
        value = zero(eltype(field))
        for (circulation, radius, source) in zip(circulations, radii, sources)
            value += kernel(circulation, radius, source, target)
        end
        @inbounds field[index] = value
    end
end