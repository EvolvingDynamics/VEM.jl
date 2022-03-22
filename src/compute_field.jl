function compute_field(kernel, circulations, radii, sources, targets)
    T = promote_type(eltype(sources), eltype(targets))
    field = zeros(T, length(targets))

    for (index, target) in enumerate(targets)
        value = zero(T)
        for (circulation, radius, source) in zip(circulations, radii, sources)
            value += kernel(circulation, radius, source, target)
        end
        @inbounds field[index] = value
    end
    
    return field
end