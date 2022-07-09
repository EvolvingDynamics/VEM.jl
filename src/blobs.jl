struct Blobs{CirculationType, RadiusType, SourceType}
    circulation::CirculationType
    radius::RadiusType
    source::SourceType
    
    function Blobs(circulation, radius, source)
        if !(length(circulation) == length(radius) == length(source))
            error("Inconsistent field lengths for construction of Blobs")
        end

        if !(eltype(eltype(circulation)) == eltype(radius) == eltype(eltype(source)))
            error("Inconsistent field types for construction of Blobs")
        end

        if length(eltype(source)) != 2 && length(eltype(source)) != 3
            error("Sources of Blobs must be 2D or 3D")
        end

        if length(eltype(source)) == 2
            if !(eltype(circulation) <: AbstractFloat)
                error("Inconsistent dimension of circulation for a 2D source")
            end
        end

        if length(eltype(source)) == 3
            if length(eltype(circulation)) != 3
                error("Inconsistent dimension of circulation for a 3D source")
            end
        end

        return new{typeof(circulation), typeof(radius), typeof(source)}(circulation, radius, source)
    end
end