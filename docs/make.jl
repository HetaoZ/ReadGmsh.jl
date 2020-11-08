using ReadGmsh
using Documenter

makedocs(;
    modules=[ReadGmsh],
    authors="Hetao Z.",
    repo="https://github.com/HetaoZ/ReadGmsh.jl/blob/{commit}{path}#L{line}",
    sitename="ReadGmsh.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://HetaoZ.github.io/ReadGmsh.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/HetaoZ/ReadGmsh.jl",
)
