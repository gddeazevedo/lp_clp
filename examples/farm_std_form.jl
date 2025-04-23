using JuMP
using Clp
import MathOptInterface as MOI

A::Matrix{Float32} = [
    1.0  0.0  0.0  -1.0   0.0   0.0  0.0  0.0;
    0.0  1.0  0.0   0.0  -1.0   0.0  0.0  0.0;
    0.0  0.0  1.0   0.0   0.0  -1.0  0.0  0.0;
    1.0  1.0  1.0   0.0   0.0   0.0  1.0  0.0;
    0.2  0.3  0.4   0.0   0.0   0.0  0.0  1.0;
]

c::Vector{Float32} = [-2.16, -1.26, -0.812, 0.0, 0.0, 0.0, 0.0, 0.0]
b::Vector{Float32} = [
    400,
    800,
    10_000,
    200_000,
    60_000
]

n::UInt8 = length(c)
m::UInt8 = length(b)

model = Model(Clp.Optimizer)
set_silent(model)

@variable(model, x[1:n] >= 0)
@objective(model, Min, sum(c[j] * x[j] for j = 1:n))
@constraint(model, [i = 1:m], sum(A[i, j] * x[j] for j = 1:n) == b[i])

optimize!(model)
status = termination_status(model)
println(model)

if status == MOI.OPTIMAL
    println("Optimal solution found")

    println("Objective value: ", objective_value(model))
    println("Variable values: ", value.(x))
elseif status == MOI.INFEASIBLE
    println("Problem is infeasible")
end