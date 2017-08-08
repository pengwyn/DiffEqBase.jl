__precompile__()

module DiffEqBase

using RecipesBase, SimpleTraits, RecursiveArrayTools, Compat, Juno, LinearMaps

import Base: length, size, getindex, setindex!, show, print,
             next, start, done, similar, indices

import Base: resize!, deleteat!

import RecursiveArrayTools: recursivecopy!, tuples

import RecursiveArrayTools: chain

function solve end
function solve! end
function init end

# Problems
abstract type DEProblem end
abstract type DEElement end
abstract type DESensitivity end

export DEProblem, DEElement, DESensitivity

abstract type AbstractSteadyStateProblem{uType,isinplace} <: DEProblem end

export AbstractSteadyStateProblem

abstract type AbstractNoiseProblem <: DEProblem end

export AbstractNoiseProblem

abstract type AbstractODEProblem{uType,tType,isinplace} <: DEProblem end
abstract type AbstractDiscreteProblem{uType,tType,isinplace} <:
                      AbstractODEProblem{uType,tType,isinplace} end

export AbstractODEProblem, AbstractDiscreteProblem

abstract type AbstractRODEProblem{uType,tType,isinplace,ND} <: DEProblem end

export AbstractRODEProblem

abstract type AbstractSDEProblem{uType,tType,isinplace,ND} <:
                      AbstractRODEProblem{uType,tType,isinplace,ND} end

export AbstractSDEProblem

abstract type AbstractDAEProblem{uType,duType,tType,isinplace} <: DEProblem end

export AbstractDAEProblem

abstract type AbstractDDEProblem{uType,tType,lType,isinplace} <: DEProblem end
abstract type AbstractConstantLagDDEProblem{uType,tType,lType,isinplace} <:
                      AbstractDDEProblem{uType,tType,lType,isinplace} end

export AbstractDDEProblem,
       AbstractConstantLagDDEProblem

abstract type AbstractSecondOrderODEProblem{uType,tType,isinplace} <: AbstractODEProblem{uType,tType,isinplace} end

export AbstractSecondOrderODEProblem

# Algorithms
abstract type DEAlgorithm end
abstract type AbstractSteadyStateAlgorithm <: DEAlgorithm end
abstract type AbstractODEAlgorithm <: DEAlgorithm end
abstract type AbstractSecondOrderODEAlgorithm <: DEAlgorithm end
abstract type AbstractRODEAlgorithm <: DEAlgorithm end
abstract type AbstractSDEAlgorithm <: DEAlgorithm end
abstract type AbstractDAEAlgorithm <: DEAlgorithm end
abstract type AbstractDDEAlgorithm <: DEAlgorithm end

export DEAlgorithm, AbstractSteadyStateAlgorithm, AbstractODEAlgorithm,
       AbstractSecondOrderODEAlgorithm,
       AbstractRODEAlgorithm, AbstractSDEAlgorithm,
       AbstractDAEAlgorithm, AbstractDDEAlgorithm

# Monte Carlo Simulations
abstract type AbstractMonteCarloProblem <: DEProblem end
abstract type AbstractMonteCarloEstimator <: DEProblem end

export AbstractMonteCarloProblem, MonteCarloProblem
export MonteCarloSolution, MonteCarloTestSolution, MonteCarloSummary
export AbstractMonteCarloEstimator

abstract type AbstractDiffEqInterpolation <: Function end
abstract type AbstractDEOptions end
abstract type DECache end
abstract type DECallback end

abstract type DEDataArray{T,N} <: AbstractArray{T,N} end
const DEDataVector{T} = DEDataArray{T,1}
const DEDataMatrix{T} = DEDataArray{T,2}

export AbstractDiffEqInterpolation, AbstractDEOptions, DECache, DECallback, DEDataArray,
       DEDataVector, DEDataMatrix

# Integrators
abstract type DEIntegrator end
abstract type AbstractSteadyStateIntegrator <: DEIntegrator end
abstract type AbstractODEIntegrator <: DEIntegrator end
abstract type AbstractSecondOrderODEIntegrator <: DEIntegrator end
abstract type AbstractRODEIntegrator <: DEIntegrator end
abstract type AbstractSDEIntegrator <: DEIntegrator end
abstract type AbstractDDEIntegrator <: DEIntegrator end
abstract type AbstractDAEIntegrator <: DEIntegrator end

export DEIntegrator, AbstractODEIntegrator,
       AbstractSecondOrderODEIntegrator,
       AbstractRODEIntegrator, AbstractSDEIntegrator,
       AbstractDDEIntegrator, AbstractDAEIntegrator

# Solutions
abstract type AbstractNoTimeSolution{T,N} <: AbstractArray{T,N} end
abstract type AbstractTimeseriesSolution{T,N} <: AbstractDiffEqArray{T,N} end
abstract type AbstractMonteCarloSolution{T,N} <: AbstractVectorOfArray{T,N} end
abstract type AbstractNoiseProcess{T,N,isinplace} <: AbstractDiffEqArray{T,N} end

const DESolution = Union{AbstractTimeseriesSolution,
                         AbstractNoTimeSolution,
                         AbstractMonteCarloSolution,
                         AbstractNoiseProcess}
export DESolution, AbstractTimeseriesSolution,
       AbstractSteadyStateSolution,AbstractNoTimeSolution,
       AbstractNoiseProcess

abstract type AbstractSteadyStateSolution{T,N} <: AbstractNoTimeSolution{T,N} end
abstract type AbstractODESolution{T,N} <: AbstractTimeseriesSolution{T,N} end

export AbstractODESolution

# Needed for plot recipes
abstract type AbstractDDESolution{T,N} <: AbstractODESolution{T,N} end
abstract type AbstractRODESolution{T,N} <: AbstractODESolution{T,N} end
abstract type AbstractDAESolution{T,N} <: AbstractODESolution{T,N} end
abstract type AbstractSensitivitySolution{T,N} end

export AbstractRODESolution,
       AbstractDAESolution,
       AbstractDDESolution,
       AbstractSensitivitySolution, AbstractMonteCarloSolution

# Misc
abstract type Tableau end
abstract type ODERKTableau <: Tableau end
abstract type DECostFunction end

export Tableau, ODERKTableau, DECostFunction

abstract type AbstractParameterizedFunction{isinplace} <: Function end
abstract type ConstructedParameterizedFunction{isinplace} <: AbstractParameterizedFunction{isinplace} end
export AbstractParameterizedFunction, ConstructedParameterizedFunction

abstract type AbstractDiffEqOperator{T} <: AbstractLinearMap{T} end
abstract type AbstractDiffEqLinearOperator{T} <: AbstractDiffEqOperator{T} end
export AbstractDiffEqLinearOperator, AbstractDiffEqOperator

include("utils.jl")
include("extended_functions.jl")
include("solutions/steady_state_solutions.jl")
include("solutions/ode_solutions.jl")
include("solutions/rode_solutions.jl")
include("solutions/dae_solutions.jl")
include("solutions/monte_solutions.jl")
include("solutions/solution_interface.jl")
include("tableaus.jl")
include("diffeqfunction.jl")
include("problems/discrete_problems.jl")
include("problems/steady_state_problems.jl")
include("problems/ode_problems.jl")
include("problems/rode_problems.jl")
include("problems/sde_problems.jl")
include("problems/noise_problems.jl")
include("problems/dae_problems.jl")
include("problems/dde_problems.jl")
include("problems/monte_problems.jl")
include("problems/problem_traits.jl")
include("interpolation.jl")
include("callbacks.jl")
include("integrator_interface.jl")
include("parameters_interface.jl")
include("constructed_parameterized_functions.jl")
include("diffeq_operator.jl")
include("linear_nonlinear.jl")
include("common_defaults.jl")
include("data_array.jl")
include("internal_euler.jl")

mutable struct ConvergenceSetup{P,C}
    probs::P
    convergence_axis::C
end

export DEParameters, Mesh, ExplicitRKTableau, ImplicitRKTableau

export isinplace, noise_class

export solve, solve!, init, step!

export tuples, intervals

export resize!,deleteat!,addat!,full_cache,user_cache,u_cache,du_cache,
       resize_non_user_cache!,deleteat_non_user_cache!,addat_non_user_cache!,
       terminate!,
       add_tstop!,add_saveat!,set_abstol!,
       set_reltol!,get_du,get_dt,get_proposed_dt,set_proposed_dt!,u_modified!,
       savevalues!

export numargs, @def

export recursivecopy!, copy_fields, copy_fields!

export construct_correlated_noisefunc

export HasJac, HastGrad, HasParamFuncs, HasParamDeriv, HasParamJac,
       HasInvJac,HasInvW, HasInvW_t, HasHes, HasInvHes, HasSyms

export has_jac, has_invjac, has_invW, has_invW_t, has_hes, has_invhes,
       has_tgrad, has_paramfuncs, has_paramderiv, has_paramjac,
       has_syms, has_analytic

export DiscreteProblem

export SteadyStateProblem, SteadyStateSolution
export NoiseProblem
export ODEProblem, ODESolution
export AbstractDynamicalODEProblem, DynamicalODEFunction,
       DynamicalODEProblem, SecondOrderODEProblem
export RODEProblem, RODESolution, SDEProblem
export SecondOrderSDEProblem
export DAEProblem, DAESolution
export ConstantLagDDEProblem, DDEProblem

export ParameterizedFunction, DAEParameterizedFunction,
       DDEParameterizedFunction,
       ProbParameterizedFunction, OutputParameterizedFunction

export DiffEqFunction

export calculate_monte_errors

export build_solution, calculate_solution_errors!

export ConvergenceSetup

export ContinuousCallback, DiscreteCallback, CallbackSet

export initialize!

export param_values, num_params, problem_new_parameters, set_param_values!

export white_noise_func_wrapper, white_noise_func_wrapper!

export is_diagonal_noise, is_sparse_noise

export LinSolveFactorize, DEFAULT_LINSOLVE

export AffineDiffEqOperator, update_coefficients!, update_coefficients, is_constant

export isautodifferentiable

end # module
