\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nord_figure}[2023/03/30 Standalone TiKZ document with colours from Nord theme]

\RequirePackage{pgfopts}

\pgfkeys{
    /nord/.cd,
    background/.store in=\nord@background,
}

\ProcessPgfOptions{/nord}

\newcommand{\nordbackground}{\nord@background}

\LoadClass[tikz]{standalone}

\usetikzlibrary{positioning, shapes.geometric}

\RequirePackage{nord_colour}
