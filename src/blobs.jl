struct Blobs{Dimension, ScalarType<:AbstractFloat, CirculationType<:Union{ScalarType, SVector{Dimension, ScalarType}}}
    circulation::Vector{CirculationType}
    radius::Vector{ScalarType}
    source::Vector{SVector{Dimension, ScalarType}}
    
    function Blobs(circulation, radius, source)
        D = length(eltype(source))
        TC = eltype(circulation)
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

        if !(length(circulation) == length(radius) == length(source))
            throw(ArgumentError("Inconsistent number of circulations, radii and sources."))
        end

        return new{D, TR, TC}(circulation, radius, source)
    end
end

circulation_type(blobs::Blobs) = eltype(blobs.circulation)
radius_type(blobs::Blobs) = eltype(blobs.radius)
source_type(blobs::Blobs) = eltype(blobs.source)

dimension(blobs::Blobs) = length(source_type(blobs))
const scalar_type = radius_type