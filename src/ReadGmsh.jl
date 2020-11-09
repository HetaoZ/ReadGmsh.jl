module ReadGmsh

import Gmsh: gmsh
export get_nodes, get_elems, get_bounds, get_nodes_elems, get_nodes_elems_bounds

function get_nodes_elems(file::String, elemtype::Int)
    gmsh.initialize()
    # gmsh.option.setNumber("General.Terminal", 1)
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
    # @info "Collected "*string(length(nodeTags))*" nodes."

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
    if n > 0
        nt = length(elemNodeTags)
        elemNodeTags = reshape(elemNodeTags, (Int(nt/n),n))
    end

    # @info "Collected "*string(n)*" elements of Type "*string(elemtype)    
    
    gmsh.finalize()    

    return nodeTags, nodeCoords, elemTags, elemNodeTags
end

function get_nodes(file::String)
    gmsh.initialize()
    # gmsh.option.setNumber("General.Terminal", 1)
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
    # @info "Collected "*string(length(nodeTags))*" nodes."
    
    gmsh.finalize()

    return nodeTags, nodeCoords
end

function get_elems(file::String, elemtype::Int)
    gmsh.initialize()
    # gmsh.option.setNumber("General.Terminal", 1)
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
    if n > 0
        nt = length(elemNodeTags)
        elemNodeTags = reshape(elemNodeTags, (Int(nt/n),n))
    end

    # @info "Collected "*string(n)*" elements of Type "*string(elemtype)
    
    gmsh.finalize()

    return elemTags, elemNodeTags
end

"""
Get the boundaries of given combined entities. Not for physical groups.

A `bound` of a N dimensional entity is a (N-1) dimensional entity.

`boundNodeTags` is an array of which each column describes the connection of a `bound`'s nodes.
"""
function get_bounds(file, elemtype, dim)
    @assert dim in (1,2,3)
    gmsh.initialize()
    # gmsh.option.setNumber("General.Terminal", 1)
    gmsh.open(file)

    for g in gmsh.model.getPhysicalGroups(dim)
        name = gmsh.model.getPhysicalName(g...)
        if name == "boundary"
            entities = gmsh.model.getEntitiesForPhysicalGroup(g...)

            elemTags = Int[]
            elemNodeTags = Int[]
            for e in entities
                # global elemTags
                # global elemNodeTags
                # get the mesh elements for each elementary entity
                bounds = gmsh.model.getBoundary((dim,e))
                # println(bounds)
                
                for bound in bounds
                    elemTypes_, elemTags_, elemNodeTags_ = gmsh.model.mesh.getElements(dim-1, bound[2])
                
                    # println(elemTypes_)
                    # println(elemTags_)
                    # println(elemNodeTags_)
                    # println(elemTypes_[1])
                    # println(elemtype)
    
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
            end
            n = length(elemTags)
            if n > 0
                nt = length(elemNodeTags)
                elemNodeTags = reshape(elemNodeTags, (Int(nt/n),n))
            end

            # ents_dimTags = [(dim,ent) for ent in ents]
            # bs = gmsh.model.getBoundary(ents_dimTags,true)
            # if dim == 1
            #     # bs is an array of node dimTags.
            #     boundNodeTags = [bs[1][2]  bs[2][2]]
            # elseif dim == 2
            #     # bs is an array of segment dimTags.
            #     nbounds = length(bs)
            #     boundNodeTags = Matrix{Int}(undef,2,nbounds)
            #     for k in eachindex(bs) 
            #         # bbs is an array of node dimTags.
            #         bbs = gmsh.model.getBoundary(bs[k])
            #         boundNodeTags[:,k] = map(bb->bb[2], bbs)
            #     end
            # else
            #     # bs is an array of polygon dimTags.
            #     nbounds = length(bs)
            #     boundNodeTagsTmp = Vector{Vector{Int}}(undef,nbounds)
            #     for k in eachindex(bs)
            #         # bbs is an array of segment dimTags.
            #         bbs = gmsh.model.getBoundary(bs[k])
            #         for bb in bbs
            #             # bbbs is an array of node dimTags.
            #             bbbs = gmsh.model.getBoundary(bb)
            #             boundNodeTagsTmp[] = map(bbb->bbb[2], bbbs)
            # end
            
            gmsh.finalize()
    
            return elemTags, elemNodeTags
        end
    end
    error("No physical group named boundary found.")
end
export get_bounds

function get_nodes_elems_bounds(f, elemtype, dim)
    nodeTags, nodeCoords = get_nodes(f)
    elemTags, elemNodeTags = get_elems(f, elemtype)
    boundElemTags, boundElemNodeTags = get_bounds(f, elemtype, dim)
    return nodeTags, nodeCoords, elemTags, elemNodeTags, boundElemTags, boundElemNodeTags
end
return get_nodes_elems_bounds

# function getmass(mshfile::String, dim::Int, tag::Int)
#     gmsh.initialize()
    
#     gmsh.open(mshfile)
#     gmsh.model.occ.synchronize()
    
#     m = gmsh.model.occ.getMass(dim, tag)
    
#     gmsh.finalize()

#     return m
# end

end
