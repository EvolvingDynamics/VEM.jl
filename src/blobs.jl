struct Blobs{Dimension, ScalarType<:AbstractFloat, ChargeType<:Union{ScalarType, SVector{Dimension, ScalarType}}}
    charge::Vector{ChargeType}
    radius::Vector{ScalarType}
    source::Vector{SVector{Dimension, ScalarType}}
    
    function Blobs(charge, radius, source)
        D = length(eltype(source))
        TC = eltype(charge)
        TR = eltype(radius)
        TS = eltype(source)

        if D == 2
            if TC != TR
                throw(ArgumentError("Invalid circulation dimension for 2D blobs. It should be a scalar."))
            end
        elseif D == 3
            if TC != TS
                throw(ArgumentError("Invalid circulation dimension for 3D blobs. It should be a 3-vector."))
            end
        else
            throw(ArgumentError("Invalid blob dimension."))
        end

        if !(length(charge) == length(radius) == length(source))
            throw(ArgumentError("Inconsistent number of charges, radii and sources."))
        end

        return new{D, TR, TC}(charge, radius, source)
    end
end

charge_type(blobs::Blobs) = eltype(blobs.charge)
radius_type(blobs::Blobs) = eltype(blobs.radius)
source_type(blobs::Blobs) = eltype(blobs.source)

dimension(blobs::Blobs) = length(source_type(blobs))
const scalar_type = radius_type