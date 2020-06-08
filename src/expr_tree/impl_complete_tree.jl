
module implementation_complete_expr_tree

    using ..abstract_expr_node, ..trait_expr_node
    using ..abstract_expr_tree
    using ..trait_tree

    import ..abstract_expr_tree.create_expr_tree, ..abstract_expr_tree.create_Expr, ..abstract_expr_tree.create_Expr2
    import ..interface_expr_tree._inverse_expr_tree

    import ..implementation_tree.type_node

    import ..interface_expr_tree._get_expr_node, ..interface_expr_tree._get_expr_children, ..interface_expr_tree._inverse_expr_tree
    import ..interface_expr_tree._get_real_node, ..interface_expr_tree._transform_to_expr_tree


    mutable struct complete_node{ T <: Number}
        op :: abstract_expr_node.ab_ex_nd
        bounds  :: abstract_expr_tree.bounds{T}
    end

    create_complete_node(op :: ab_ex_nd, bouds :: abstract_expr_tree.bounds{T}) where T <: Number = complete_node{T}(op,bounds)
    create_complete_node(op :: ab_ex_nd, bi :: T, bs :: T) where T <: Number = complete_node{T}(op,abstract_expr_tree.bounds{T}(bi,bs))
    create_complete_node(op :: ab_ex_nd) = create_complete_node(op, (Float64)(-Inf), (Float64)(Inf))
    get_op_from_node(cmp_nope :: complete_node) = cmp_nope.op
    get_bounds_from_node(cmp_nope :: complete_node) = cmp_nope.bounds

    complete_expr_tree{T <: Number}  = type_node{complete_node{T}}

    create_complete_expr_tree(cn :: complete_node{T}, ch :: AbstractVector{complete_expr_tree{T}}) where T <: Number = complete_expr_tree{T}(cn,ch)
    create_complete_expr_tree(cn :: complete_node{T}) where T <: Number = create_complete_expr_tree(cn, Vector{complete_expr_tree{T}}(undef,0) )
    function create_complete_expr_tree(t :: type_node{ab_ex_nd})
        nd = trait_tree.get_node(t)
        ch = trait_tree.get_children(t)
        if isempty(ch)
            return create_complete_expr_tree(create_complete_node(nd))
        else
            new_ch = create_complete_expr_tree.(ch)
            new_nd = create_complete_node(trait_tree.get_node(t))
            return  create_complete_expr_tree(new_nd, new_ch)
        end
    end


    function create_Expr(t :: complete_expr_tree)
        nd = trait_tree.get_node(t)
        ch = trait_tree.get_children(t)
        op = get_op_from_node(nd)
        if isempty(ch)
            return trait_expr_node.node_to_Expr(op)
        else
            children_Expr = create_Expr.(ch)
            node_Expr = trait_expr_node.node_to_Expr(op)
            #défférenciation entre les opérateurs simple :+, :- et compliqué comme :^2
            #premier cas, les cas simple :+, :-
            if length(node_Expr) == 1
                return Expr(:call, node_Expr[1], children_Expr...)
            #les cas compliqués, pour le moment :^
            elseif length(node_Expr) == 2
                return Expr(:call, node_Expr[1], children_Expr..., node_Expr[2])
            else
                error("non traité")
            end
        end
    end




    create_expr_tree(field :: complete_node, children :: Vector{ type_node{complete_expr_tree}} ) = create_complete_node(field,children)

    create_expr_tree(field :: complete_node ) = t_expr_tree(get_op_from_node(field), [])

    _get_expr_node(t :: complete_expr_tree) = get_op_from_node(trait_tree.get_node(t))

    _get_expr_children(t :: complete_expr_tree) = trait_tree.get_children(t)

    function _inverse_expr_tree(t :: complete_expr_tree{T}) where T <: Number
        op_minus = abstract_expr_node.create_node_expr(:-)
        bounds = abstract_expr_tree.create_empty_bounds(T)
        node = create_complete_node(op_minus, bounds)
        return create_complete_expr_tree(node,[t])
    end

    _get_real_node(ex :: complete_expr_tree{T}) where T <: Number = _get_expr_node(ex)

    _transform_to_expr_tree(ex :: complete_expr_tree{T}) where T <: Number = abstract_expr_tree.create_expr_tree(get_op_from_node(trait_tree.get_node(ex)), _transform_to_expr_tree.(trait_tree.get_children(ex)) )


    function Base.copy(ex :: complete_expr_tree{T}) where T <: Number
        nd = trait_tree.get_node(ex)
        ch = trait_tree.get_children(ex)
        if isempty(ch)
            leaf = abstract_expr_tree.create_expr_tree(nd)
            return leaf
        else
            res_ch = Base.copy.(ch)
            new_node = create_complete_node(get_op_from_node(nd),get_bounds_from_node(nd))
            return create_expr_tree(new_node, res_ch)
        end
    end


    export complete_node

end  # moduleimplementation_expr_tree