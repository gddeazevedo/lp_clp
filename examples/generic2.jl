using JuMP
using Clp
using MathOptInterface

model = Model(Clp.Optimizer)

@variable(model, x1 >= 0)
@variable(model, x2 >= 0)

@objective(model, Max, x1 + 3x2)

@constraint(model, x1 + x2 <= 6)
@constraint(model, -x1 + 2x2 <= 8)

optimize!(model)

status = termination_status(model)
println(model)

if status == OPTIMAL
    println("Optimal solution found")

    println("Objective value: ", objective_value(model))
    println("Variable values: \nx1 = ", value(x1), "\nx2 = ", value(x2))
elseif status == INFEASIBLE
    println("Problem is infeasible")
end