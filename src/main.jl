struct Pessoa
    nome::String
    idade::UInt8
end

function to_string(p::Pessoa)
    return "Nome: $(p.nome), Idade: $(p.idade)"
end


p = Pessoa("João", 30)
println(to_string(p))
