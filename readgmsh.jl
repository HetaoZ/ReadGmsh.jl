module ReadGmsh

import Gmsh: gmsh
export getnodes, getelems

function getnodes(file::String)
    gmsh.initialize()
    gmsh.option.setNumber("General.Terminal", 1)
    gmsh.open(file)
    
    # get all elementary entities in the model
    entities = gmsh.model.getEntities()
    
    nodeTags = Int[]
    nodeCoords = Float64[]
    for e in entities
        # get the mesh nodes for each elementary entity
        nodeTags_, nodeCoords_, nodeParams_ = gmsh.model.mesh.getNodes(e[1], e[2])
    #     println((Int.(nodeTags),nodeCoords,nodeParams))
        append!(nodeTags, nodeTags_)
        append!(nodeCoords, nodeCoords_)
    end
    nodeCoords = reshape(nodeCoords, (3,Int(length(nodeCoords)/3)))
    println("Collected ",length(nodeTags)," nodes.")
    
    gmsh.finalize()

    return nodeTags, nodeCoords
end

function getelems(file::String, elemtype::Int)
    gmsh.initialize()
    gmsh.option.setNumber("General.Terminal", 1)
    gmsh.open(file)
    
    # get all elementary entities in the model
    entities = gmsh.model.getEntities()

    elemTags = Int[]
    elemNodeTags = Int[]
    for e in entities
        # get the mesh elements for each elementary entity
        elemTypes_, elemTags_, elemNodeTags_ = gmsh.model.mesh.getElements(e[1], e[2])
    #     println((Int.(elemTypes), [Int.(et) for et in elemTags], [Int.(ent) for ent in elemNodeTags]))
        if length(elemTypes_) > 0
            if elemTypes_[1] == elemtype
                for et in elemTags_
                    append!(elemTags, et)
                end
                for ent in elemNodeTags_
                    append!(elemNodeTags, ent)
                end
            end
        end
    end
    n = length(elemTags)
    nt = length(elemNodeTags)
    elemNodeTags = reshape(elemNodeTags, (n,Int(nt/n)))
    println("Collected ",n," elements of Type ",elemtype," that has ",Int(nt/n)," bounding nodes.")
    
    gmsh.finalize()

    return elemTags, elemNodeTags
end

end
