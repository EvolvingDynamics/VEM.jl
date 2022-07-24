"""
    VortexBlobs{Dimension, ScalarType<:AbstractFloat, CirculationType<:Union{ScalarType, SVector{Dimension, ScalarType}}}

Construct a distribution of 2D or 3D blobs.

The state of the distribution is completely specified by three properties:

 - The circulation carried by the blobs: `circulation`
 - The core radius of the blobs: `radius`
 - The coordinates of the blobs: `source`

 Note that circulation is a scalar in 2D and a 3-vector in 3D.

 # Example

 Construct a distribution of two 2D blobs:

    using StaticArrays
    using VEM
    
    circulation = [1.23, 4.56]
    radius = [0.45, 0.67]
    source = [SVector(0.0, 0.0), SVector(0.1, 0.1)]
    
    blobs = VortexBlobs(circulation, radius, source)

 Construct a distribution of 3D blobs:

     using StaticArrays
     using VEM
     
     circulation = [SVector(1.23, 4.56, 7.89), SVector(3.21, 6.54, 9.87)]
     radius = [0.54, 0.67]
     source = [SVector(0.0, 0.0, 0.0), SVector(0.1, 0.1, 0.1)]
    
     blobs = VortexBlobs(circulation, radius, source)
"""
struct VortexBlobs{Dimension, ScalarType<:AbstractFloat, CirculationType<:Union{ScalarType, SVector{Dimension, ScalarType}}}
    circulation::Vector{CirculationType}
    radius::Vector{ScalarType}
    source::Vector{SVector{Dimension, ScalarType}}
    
    function VortexBlobs(circulation, radius, source)
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

"""
    circulation_type(blobs::VortexBlobs)

Determine the type of the circulation carried by a blob.

# Example

    julia> circulation_type(blobs::VortexBlobs{2, Float32})
    Float32
    
    julia> circulation_type(blobs::VortexBlobs{3, Float16})
    SVector{3, Float16}
"""
circulation_type(blobs::VortexBlobs) = eltype(blobs.circulation)

"""
    radius_type(blobs::VortexBlobs)

Determine the type of the radius of a blob.

# Example
    
    julia> radius_type(blobs::VortexBlobs{2, Float32})
    Float32
    
    julia> radius_type(blobs::VortexBlobs{3, Float16})
    Float16
"""
radius_type(blobs::VortexBlobs) = eltype(blobs.radius)

"""
    source_type(blobs::VortexBlobs)

Determine the type of the source of a blob.

# Example

    julia> source_type(blobs::VortexBlobs{2, Float32})
    SVector{2, Float32}
    
    julia> source_type(blobs::VortexBlobs{3, Float16})
    SVector{3, Float16}
"""
source_type(blobs::VortexBlobs) = eltype(blobs.source)

"""
    dimension_type(blobs::VortexBlobs)

Determine the dimension of a blob.

# Example

    julia> dimension(blobs::VortexBlobs{2})
    2
    
    julia> dimension_type(blobs::VortexBlobs{3})
    3
"""
dimension(blobs::VortexBlobs) = length(source_type(blobs))

"""
    scalar_type(blobs::VortexBlobs)

Determine the primitive type used for the data contained by the `VortexBlobs` struct.

# Example
    
    julia> scalar_type(blobs::VortexBlobs{2, Float32})
    Float32
    
    julia> scalar_type(blobs::VortexBlobs{3, Float16})
    Float16
"""
const scalar_type = radius_type