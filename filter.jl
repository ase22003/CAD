#requires basic.jl

@START_OF_DEBUG_CATEGORY "cad filter"

function round_corners_3D(radius::Real, size_of_child::RVect, child::String)::String
	"""THIS IS NOT RELIABLE"""
	resize((size_of_child),
		minkowski(
			child,
			sphere(radius)
		)
	)
end

@END_OF_DEBUG_CATEGORY
