using JuMP
using Clp
using MathOptInterface


model = Model(Clp.Optimizer)
set_silent(model)

@variable(model, x1 >= 0)
@variable(model, x2 >= 0)

@objective(model, Max, 3x1 + 5x2)
@constraint(model, x1 <= 4)
@constraint(model, x2 <= 6)
@constraint(model, 3x1 + 2x2 <= 18)

optimize!(model)
status = termination_status(model)
println(model)
if status == OPTIMAL
    println("Optimal solution found\n----------------------")

    println("Objective value: ", objective_value(model))
    println("Variable values: \n\tx1 = ", value(x1), "\n\tx2 = ", value(x2))
elseif status == INFEASIBLE
    println("Problem is infeasible")
end
