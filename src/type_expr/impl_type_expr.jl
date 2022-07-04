module implementation_type_expr

import ..interface_type_expr:
  _is_constant, _is_linear, _is_quadratic, _is_more, _is_cubic, _type_product, _type_power

export t_type_expr_basic,
  _is_constant,
  _is_linear,
  _is_quadratic,
  _is_more_than_quadratic,
  _is_cubic,
  return_constant,
  return_linear,
  return_quadratic,
  return_cubic,
  return_more

@enum t_type_expr_basic constant = 0 linear = 1 quadratic = 2 cubic = 3 more = 4

############## interface methods ###################

"""
    bool = _is_constant(t::t_type_expr_basic)

Check if `t` equals `constant`.
"""
@inline _is_constant(t::t_type_expr_basic) = (t == constant)

"""
    bool = _is_linear(t::t_type_expr_basic)

Check if `t` equals `linear`.
"""
@inline _is_linear(t::t_type_expr_basic) = (t == linear)

"""
    bool = _is_quadratic(t::t_type_expr_basic)

Check if `t` equals `quadratic`.
"""
@inline _is_quadratic(t::t_type_expr_basic) = (t == quadratic)

"""
    bool = _is_cubic(t::t_type_expr_basic)

Check if `t` equals `cubic`.
"""
@inline _is_cubic(t::t_type_expr_basic) = (t == cubic)

"""
    bool = _is_more(t::t_type_expr_basic)

Check if `t` equals `more`.
"""
@inline _is_more(t::t_type_expr_basic) = (t == more)

"""
    constant = return_constant()

Return `constant::t_type_expr_basic`.
"""
@inline return_constant() = t_type_expr_basic(0)

"""
    linear = return_linear()

Return `linear::t_type_expr_basic`.
"""
@inline return_linear() = t_type_expr_basic(1)

"""
    quadratic = return_quadratic()

Return `quadratic::t_type_expr_basic`.
"""
@inline return_quadratic() = t_type_expr_basic(2)

"""
    cubic = return_cubic()

Return `cubic::t_type_expr_basic`.
"""
@inline return_cubic() = t_type_expr_basic(3)

"""
    more = return_more()

Return `more::t_type_expr_basic`.
"""
@inline return_more() = t_type_expr_basic(4)

"""
    result_type = _type_product(a::t_type_expr_basic, b::t_type_expr_basic)

Return `result_type::t_type_expr_basic`, the type resulting of the product `a*b`.
"""
function _type_product(a::t_type_expr_basic, b::t_type_expr_basic)
  if _is_constant(a)
    return b
  elseif _is_linear(a)
    if _is_constant(b)
      return linear
    elseif _is_linear(b)
      return quadratic
    elseif _is_quadratic(b)
      return cubic
    else
      return more
    end
  elseif _is_quadratic(a)
    if _is_constant(b)
      return quadratic
    elseif _is_linear(b)
      return cubic
    else
      return more
    end
  elseif _is_cubic(a)
    if _is_constant(b)
      return cubic
    else
      return more
    end
  elseif _is_more(a)
    return more
  end
end

"""
    result_type = _type_power(index_power::Number, b::t_type_expr_basic)

Return `result_type::t_type_expr_basic`, resulting of `b^(index)`.
"""
function _type_power(index_power::Number, b::t_type_expr_basic)
  if index_power == 0
    return constant
  elseif index_power == 1
    return b
  else
    if _is_constant(b)
      return constant
    elseif _is_linear(b)
      if index_power == 2
        return quadratic
      elseif index_power == 3
        return cubic
      else
        return more
      end
    else
      return more
    end
  end
end

end
