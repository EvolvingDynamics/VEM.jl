@inline function LinearAlgebra.cross(scalar::Number, vector::StaticVector{2})
    @inbounds return typeof(vector)(-scalar*vector[2], scalar*vector[1])
end