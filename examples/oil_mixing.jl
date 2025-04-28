using JuMP
using Clp
using MathOptInterface

c1::Vector{Float32} = [22.0, 28.0, 35.0]
c2::Vector{Float32} = [19.0, 24.0, 20.0, 27.0] 

b::Vector{Float32} = [3500.0, 2200.0, 4200.0, 1800.0]

model = Model(Clp.Optimizer)

@variable(model, X[i=1:3, j=1:4] >= 0)

@objective(model, Max, sum(c1[i] * X[i, j] for i in 1:3, j in 1:4) - sum(c2[j] * X[i, j] for j in 1:4, i in 1:3))

@constraint(model, [i = 1:4], sum(X[j, i] for j in 1:3) <= b[i])
@constraints(model, begin 
    X[3, 1] <= 0.3 * sum(X[3, j] for j = 1:4)
    X[3, 2] >= 0.4 * sum(X[3, j] for j = 1:4)
    X[3, 3] <= 0.5 * sum(X[3, j] for j = 1:4)
    X[2, 1] <= 0.3 * sum(X[2, j] for j = 1:4)
    X[2, 2] >= 0.1 * sum(X[2, j] for j = 1:4)
    X[1, 1] <= 0.7 * sum(X[1, j] for j = 1:4)
end)

println(model)

optimize!(model)
status = termination_status(model)

if status == MOI.OPTIMAL
    println("Optimal solution found")
    println("Objective value: ", objective_value(model))
    
    for i in 1:3
        for j in 1:4
            println("X[$i, $j] = ", value(X[i, j]))
        end
    end
elseif status == MOI.INFEASIBLE
    println("Problem is infeasible")
end
