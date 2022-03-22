struct Blobs{CirculationType, RadiusType, SourceType}
    circulation::CirculationType
    radius::RadiusType
    source::SourceType
    
    function Blobs(circulation, radius, source)
        if !(length(circulation) == length(radius) == length(source))
            error("Inconsistent field lengths for construction of Blobs")
        end

        if !(eltype(circulation) == eltype(radius) == eltype(eltype(source)))
            error("Inconsistent field types for construction of Blobs")
        end

        return new{typeof(circulation), typeof(radius), typeof(source)}(circulation, radius, source)
    end
end