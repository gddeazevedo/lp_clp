using Clp
using JuMP
using MathOptInterface

A::Matrix{Float32} = [
    2   2  10   20;
    50  20  10  30;
    80  70  10  80
]

c::Vector{Float32} = [2.0, 4.0, 1.5, 1.0]
b::Vector{Float32} = [11, 70, 250]

n::UInt8 = length(c)
m::UInt8 = length(b)

model = Model(Clp.Optimizer)
set_silent(model)

@variable(model, x[1:n] >= 0)
@objective(model, Min, sum(c[j] * x[j] for j = 1:n))
@constraint(model, [i = 1:m], sum(A[i, j] * x[j] for j = 1:n) >= b[i])

optimize!(model)
status = termination_status(model)

println(model)

if status == OPTIMAL
    println("Optimal solution found")

    println("Objective value: ", objective_value(model))
    println("Variable values: ", value.(x))
elseif status == INFEASIBLE
    println("Problem is infeasible")
end


