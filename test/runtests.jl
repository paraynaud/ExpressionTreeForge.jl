using Test
using ExpressionTreeForge
using JuMP, LinearAlgebra, MathOptInterface, ModelingToolkit, SparseArrays

include("first_test.jl")
include("test_on_tree/ordered_include.jl")
include("unitary_test/ordered_include.jl")
include("NLPSupport.jl")