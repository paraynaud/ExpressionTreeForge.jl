using JuMP, MathOptInterface, ModelingToolkit
using NLPModelsJuMP, ADNLPModels


"""
    expr = get_expression_tree(adnlp::MathOptNLPModel)
    expr = get_expression_tree(adnlp::ADNLPModel)
    expr = get_expression_tree(model::JuMP.Model)

Return the objective function as a `Type_expr_tree` for a: `MathOptNLPModel`, `ADNLPModel `JuMP.Model`.
"""
get_expression_tree(nlp::MathOptNLPModel) = get_expression_tree(nlp.eval.m)
function get_expression_tree(model::JuMP.Model)
  evaluator = JuMP.NLPEvaluator(model)
  MathOptInterface.initialize(evaluator, [:ExprGraph])
  obj_Expr = MathOptInterface.objective_expr(evaluator)::Expr
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(obj_Expr)::ExpressionTreeForge.Type_expr_tree
  return expr_tree
end

function get_expression_tree(adnlp::ADNLPModel)
  n = adnlp.meta.nvar
  ModelingToolkit.@variables x[1:n]
  fun = adnlp.f(x)
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(fun)::ExpressionTreeForge.Type_expr_tree
  return expr_tree
end