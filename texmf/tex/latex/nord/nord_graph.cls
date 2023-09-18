\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nord_graph}[2023/03/30 Standalone TiKZ document with colours from Nord theme]

\RequirePackage{pgfopts}

\pgfkeys{
    /nord/.cd,
    background/.store in=\nord@background,
}

\ProcessPgfOptions{/nord}

\newcommand{\nordbackground}{\nord@background}

\LoadClass[tikz]{standalone}

\usetikzlibrary{
    arrows.meta,
    graphs,
    graphdrawing,
    quotes,
    shapes
}
\usegdlibrary{trees, layered}

\RequirePackage{nord_colour}

\tikzset{
    nord graph/.style={
            >={Stealth},
        },
}
