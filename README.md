# Como rodar o código?

## Buildar a imagem do projeto

```bash
make build
```

## Rodar o script

```bash
make run
```

## Rodar exemplos

```bash
make run-example file=<arquivo de exemplo>
```

## Rodar exemplo C++

```bash
g++ -o problema_lp problema_lp.cpp -lClp -lCoinUtils -lOsiClp -lOsi

clp -import ./data/modelo.lp -primalsimplex -solution output.txt
```

```bash
julia -e 'using Pkg; Pkg.instantiate()'
julia -e 'using Pkg; Pkg.add(["Clp", "JuMP", "MathOptInterface"])'
```
