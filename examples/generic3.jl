using JuMP
using Clp
using MathOptInterface

model = Model(Clp.Optimizer)

@variable(model, x1 >= 0)
@variable(model, x2 >= 0)
@variable(model, x3 >= 0)
@variable(model, x4 >= 0)

@objective(model, Min, -x1 -3x2)

@constraint(model, x1 + x2 + x3 == 6)
@constraint(model, -x1 + x2 + x4 == 8)

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