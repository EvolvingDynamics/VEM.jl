using VEM
using Documenter

DocMeta.setdocmeta!(VEM, :DocTestSetup, :(using VEM); recursive=true)

makedocs(;
    modules=[VEM],
    authors="Carlos Fernando Baptista",
    repo="https://github.com/EvolvingDynamics/VEM.jl/blob/{commit}{path}#{line}",
    sitename="VEM.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://EvolvingDynamics.github.io/VEM.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/EvolvingDynamics/VEM.jl",
    devbranch="master",
)
