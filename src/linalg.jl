@inline function LinearAlgebra.cross(scalar::TS, vector::StaticVector{2, TV}) where {TS<:Number, TV<:Number}
    @inbounds return similar_type(vector, promote_type(TS, TV))(-scalar*vector[2], scalar*vector[1])
end