struct Blobs{ChargeType, RadiusType, SourceType}
    charge::ChargeType
    radius::RadiusType
    source::SourceType
    
    function Blobs(charge, radius, source)
        if !(length(charge) == length(radius) == length(source))
            error("Inconsistent attribute lengths for construction of Blobs")
        end

        if !(eltype(eltype(charge)) == eltype(radius) == eltype(eltype(source)))
            error("Inconsistent attribute types for construction of Blobs")
        end

        if length(eltype(source)) == 2
            if !(eltype(charge) <: AbstractFloat)
                error("Invalid type of scalar value for attributes of Blobs")
            end
        elseif length(eltype(source)) == 3
            if length(eltype(charge)) != 3
                error("Invalid charge dimension for 3D Blobs")
            end
        else
            error("Invalid blob dimension")
        end

        if !(eltype(radius) <: AbstractFloat)
            error("Invalid type of scalar value for attributes of Blobs")
        end

        return new{typeof(charge), typeof(radius), typeof(source)}(charge, radius, source)
    end
end

charge_eltype(blobs::Blobs) = eltype(blobs.charge)
radius_eltype(blobs::Blobs) = eltype(blobs.radius)
source_eltype(blobs::Blobs) = eltype(blobs.source)

scalar_type(blobs::Blobs) = radius_eltype(blobs)