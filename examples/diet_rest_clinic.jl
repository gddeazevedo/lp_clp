using JuMP
using Cbc
using MathOptInterface

# Matriz de constituição nutritiva
A::Matrix{Float32} = [
    60.0  100.0 300.0 10.0  20.0  150.0;
    80.0  50.0  350.0 20.0  10.0  100.0;
    80.0  20.0  100.0 40.0  20.0  90.0;
    100.0 25.0  100.0 25.0  10.0  100.0;
    40.0  30.0  300.0 10.0  20.0  150.0;
    50.0  35.0  350.0 20.0  10.0  200.0;
    0.0   50.0  100.0 40.0  20.0  90.0;
    40.0  25.0  100.0 25.0  10.0  80.0;
    80.0  10.0  250.0 40.0  50.0  100.0;
]

# Matriz de consumo dos ingredientes
B::Matrix{Float32} = [
    60.0  50.0  80.0  60.0  50.0  100.0;
    30.0  60.0  30.0  100.0 50.0  150.0;
    20.0  60.0  20.0  60.0  60.0  120.0;
    20.0  40.0  30.0  80.0  30.0  80.0;
    40.0  80.0  0.0   80.0  0.0   150.0;
    50.0  50.0  0.0   100.0 0.0   100.0;
    0.0   100.0 0.0   100.0 0.0   100.0;
    0.0   50.0  20.0  120.0 50.0  50.0;
    0.0   40.0  10.0  150.0 100.0 40.0;
]

# Demanda dos programas de treinamento
N::Matrix{Float32} = [
    150.0 200.0 400.0 30.0 40.0 250.0;
    180.0 220.0 500.0 20.0 60.0 300.0;
]


# Custos dos ingredientes
c::Vector{Float32} = [4.0, 6.0, 1.5, 0.9, 1.0, 0.7]

# Quantidade de pessoas por programa
p::Vector{Float32} = [20.0, 30.0]


model = Model(Cbc.Optimizer)
set_silent(model)

@variable(model, x[1:9] >= 0)
@variable(model, y[1:9] >= 0)


@objective(model, Min, sum(c[j] * B[i,j] * y[i] for i=1:9, j=1:6))

for j = 1:6
    @constraint(model, sum(A[i, j] * y[i] for i = 1:9) >= sum(N[s, j] * p[s] for s = 1:2))
end


for i = 1:9
    @constraint(model, y[i] <= 50 * x[i])
end

@constraints(model, begin
    sum(x[i] for i = 1:4) == 1
    sum(x[i] for i = 5:7) == 1
    sum(x[i] for i = 8:9) == 1
    sum(y[i] for i = 1:4) == 50
    sum(y[i] for i = 5:7) == 50
    sum(y[i] for i = 8:9) == 50
end)

for j = 1:6
    @objective(model, Min, c[j] * sum(B[i,j] * y[i] for i=1:9))
end

println(model)

optimize!(model)

status = termination_status(model)

if status == OPTIMAL
    println("Optimal solution found")
    println("Objective value: ", objective_value(model))
    println("Variable values: ", value.(x))
    println("Variable values: ", value.(y))
elseif status == INFEASIBLE
    println("Problem is infeasible")
end