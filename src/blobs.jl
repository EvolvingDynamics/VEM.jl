struct Blobs{ChargeType, RadiusType, SourceType}
    charge::ChargeType
    radius::RadiusType
    source::SourceType
    
    function Blobs(charge, radius, source)
        if !(length(charge) == length(radius) == length(source))
            error("Inconsistent field lengths for construction of Blobs")
        end

        if !(eltype(eltype(charge)) == eltype(radius) == eltype(eltype(source)))
            error("Inconsistent field types for construction of Blobs")
        end

        if length(eltype(source)) != 2 && length(eltype(source)) != 3
            error("Sources of Blobs must be 2D or 3D")
        end

        if length(eltype(source)) == 2
            if !(eltype(charge) <: AbstractFloat)
                error("Inconsistent dimension of charge for a 2D source")
            end
        end

        if length(eltype(source)) == 3
            if length(eltype(charge)) != 3
                error("Inconsistent dimension of charge for a 3D source")
            end
        end

        return new{typeof(charge), typeof(radius), typeof(source)}(charge, radius, source)
    end
end