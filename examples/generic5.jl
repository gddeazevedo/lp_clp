using JuMP
using Clp
using MathOptInterface


model_canonical = Model(Clp.Optimizer)
set_silent(model_canonical)

@variable(model_canonical, x1 >= 0)
@variable(model_canonical, x2 >= 0)

@objective(model_canonical, Max, 2x1 + 3x2)

@constraints(model_canonical, begin
    x1 + x2 <= 2
    4x1 + 6x2 <= 9
    -x1 - 2x2 >= 4
end)

println("Model canonical form: \n", model_canonical)
optimize!(model_canonical)
status = termination_status(model_canonical)

if status == MOI.OPTIMAL
    println("Optimal solution found\n----------------------")

    println("Objective value: ", objective_value(model_canonical))
    println("Variable values: \n\tx1 = ", value(x1), "\n\tx2 = ", value(x2))
elseif status == MOI.INFEASIBLE
    println("Problem is infeasible")
end

println("\n\n\n")

model_std = Model(Clp.Optimizer)
set_silent(model_std)

@variable(model_std, x1 >= 0)
@variable(model_std, x2 >= 0)
@variable(model_std, x3 >= 0)
@variable(model_std, x4 >= 0)
@variable(model_std, x5 >= 0)

@objective(model_std, Min, -2x1 - 3x2)

@constraints(model_std, begin
    x1 + x2 + x3 == 2
    4x1 + 6x2 + x4 == 9
    -x1 - 2x2 - x5 == 4
end)

println("Model standard form: \n", model_std)
optimize!(model_std)
status = termination_status(model_std)
if status == MOI.OPTIMAL
    println("Optimal solution found\n----------------------")

    println("Objective value: ", objective_value(model_std))
    println("Variable values: \n\tx1 = ", value(x1), "\n\tx2 = ", value(x2), "\n\tx3 = ", value(x3), "\n\tx4 = ", value(x4), "\n\tx5 = ", value(x5))
elseif status == MOI.INFEASIBLE
    println("Problem is infeasible")
end