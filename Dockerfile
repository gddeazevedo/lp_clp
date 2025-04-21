FROM julia:1.11.5

WORKDIR /app

RUN apt-get update && apt-get install -y gcc g++ && rm -rf /var/lib/apt/lists/*


RUN julia -e 'using Pkg; Pkg.instantiate()'

RUN julia -e 'using Pkg; Pkg.add(["Clp", "JuMP", "JSON3", "MathOptInterface"])'

COPY src ./src

CMD ["julia", "src/main.jl"]
