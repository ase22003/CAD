#requires debug.jl
#requires utils.jl
#requires meta.jl

@START_OF_DEBUG_CATEGORY "openscad"

RVect = Union{Vector{Real}, Tuple{Real, Real, Real}}

#{{{ELEMENTARY OPENSCAD FUNCTIONS
printed(vector::RVect)::String = "[$(vector[1]),$(vector[2]),$(vector[3])]"
#printed(children::Union{Tuple, Vector{String}})::String = ""

@logged function cube(dim::RVect)::String
	return "cube($(printed(dim)));"
end
cube(x::Real, y::Real, z::Real)::String = cube((x, y, z))

@logged function cylinder(height::Real, radius1::Real, radius2::Real)::String
	return "cylinder($height,$radius1,$radius2);"
end
cylinder(height::Real, radius::Real)::String = cylinder(height, radius, radius)

function _oper(operation::String, vector::RVect, children::String...)::String
	return "$operation($(printed(vector))){$(string(children...))}"
end

for operation ∈  ("translate", "rotate", "scale", "resize", "mirror")
	run_meta_string("""function ( :: ( $operation ( :: vector RVect ) ( ... ( :: children String ) ) ) String ) ( _oper "$operation" vector ( ... children ) )""")
end
#}}}

@END_OF_DEBUG_CATEGORY
