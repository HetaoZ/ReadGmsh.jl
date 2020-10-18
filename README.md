# ReadGmsh
Read .msh file and return info of nodes and elements as arrays.

# Usage

This package is not yet registried. Please add readgmsh.jl to your project directory.

# Examples

```julia
import ReadGmsh: getnodes, getelems
nodeTags, nodeCoords = getnodes("examples/rect2d.msh")
elemTags_1, elemNodeTags_1 = getelems("examples/rect2d.msh", 1) # Element Type = 1
elemTags_2, elemNodeTags_2 = getelems("examples/rect2d.msh", 2) # Element Type = 2
```
