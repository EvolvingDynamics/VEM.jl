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
    num_sources = length(sources)
    for (index, target) in enumerate(targets)
        @inbounds field[index] =  mapreduce(kernel, +, circulations, radii, sources, Fill(target, num_sources))
    end
end