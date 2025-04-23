\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nord_plot}[2025/04/15 Standalone PGFPlots / TiKZ plot with colours from Nord theme]

\RequirePackage{pgfopts}

\pgfkeys{
    /nord/.cd,
    background/.store in=\nord@background,
}

\ProcessPgfOptions{/nord}

\newcommand{\nordbackground}{\nord@background}

\LoadClass[tikz]{standalone}

% \usetikzlibrary{
%   ...
% }

\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}

\RequirePackage{nord_colour}
