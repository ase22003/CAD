#requires debug.jl
#requires utils.jl
#requires meta.jl

@START_OF_DEBUG_CATEGORY "cad basic"

const RVect = Union{Vector{<:Real}, Tuple{<:Real, <:Real, <:Real}}

#{{{ELEMENTARY FUNCTIONS
printed(vector::RVect)::String = "[$(vector[1]),$(vector[2]),$(vector[3])]"
#printed(children::Union{Tuple, Vector{String}})::String = ""

function cube(dim::RVect)::String
	"cube($(printed(dim)));"
end
cube(x::Real, y::Real, z::Real)::String = cube((x, y, z))

function cylinder(height::Real, radius1::Real, radius2::Real)::String
	"cylinder($height,$radius1,$radius2);"
end
cylinder(height::Real, radius::Real)::String = cylinder(height, radius, radius)

function sphere(radius::Real)::String
	"sphere($radius);"
end

function offset(radius::Real)::String
	"sphere($radius)"
end

function polyhedron(points::Vector{RVect}, faces::Vector{Vector{Real}})::String
	"polyhedron($points,$faces,10)"
end

function _oper(operation::String, vector::RVect, children::String...)::String
	"$operation($(printed(vector))){$(string(children...))}"
end

function _oper(operation::String, children::String...)::String
	"$operation(){$(string(children...))}"
end

for operation ∈  ("translate", "rotate", "scale", "resize", "mirror")
	run_meta_string("""function ( :: ( $operation ( :: vector RVect ) ( ... ( :: children String ) ) ) String ) ( _oper "$operation" vector ( ... children ) )""")
end

for operation ∈ ("hull", "union", "difference", "intersection", "minkowski", "rotate_extrude")
	run_meta_string("""function ( :: ( $operation ( ... ( :: children String ) ) ) String ) ( _oper "$operation" ( ... children ) )""")
	#=
	eval(
		:(
		@logged function $operation(children::String...)::String
			return _oper("$operation", children...)
		end
		)
	)
	=#
end
#}}}
#{{{OTHER FUNCTIONS
function scad_include(lib::String)::String
	"include <$lib.scad>"
end

function set_rendering_parameter(parameter::String, value::Real)::String
	"\$$parameter = $value;"
end

function scad_function(semicolon::Bool, name::String, params::Any...)::String
	string("$name($(string(["$param," for param ∈ params[1:end-1]], params[end])))", semicolon ? ";" : "")
end

function highlight(children::Vector{String})::String
	string("#", children...)
end
function highlight(child::String)::String
	string("#", child)
end
#}}}

@END_OF_DEBUG_CATEGORY
