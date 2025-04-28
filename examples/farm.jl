using JuMP
using Clp
using MathOptInterface

model = Model(Clp.Optimizer)


@variable(model, x[1:3] >= 0)

@objective(model, Max, 2.16x[1] + 1.26x[2] + 0.812x[3])

@constraint(model, x[1] >= 400)
@constraint(model, x[2] >= 800)
@constraint(model, x[3] >= 10_000)
@constraint(model, x[1] + x[2] + x[3] <= 200_000)
@constraint(model, 0.2x[1] + 0.3x[2] + 0.4x[3] <= 60_000)

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