using JuMP
using Clp
import MathOptInterface as MOI


model = Model(Clp.Optimizer)


@variable(model, x1 >= 0)
@variable(model, x2 >= 0)

@objective(model, Min, -x1 - x2)
@constraint(model, x1 + 2x2 <= 3)
@constraint(model, 2x1 + x2 <= 3)

optimize!(model)
status = termination_status(model)

println(model)

if status == MOI.OPTIMAL
    println("Optimal solution found")

    println("Objective value: ", objective_value(model))
    println("Variable values: \nx1 = ", value(x1), "\nx2 = ", value(x2))
end
