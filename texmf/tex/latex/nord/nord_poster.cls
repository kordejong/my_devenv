\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nord_poster}[2023/11/09 tikzposter with colours from Nord theme]
\RequirePackage{pgfopts}

% TODO Add support for defaults:
% - Default paper should be: a0paper
% - Default orientation should be: portrait
\pgfkeys{
    /nord/.cd,
    paper/.store in=\nord@paper,
    orientation/.store in=\nord@orientation,
}

\ProcessPgfOptions{/nord}

\newcommand{\nordpaper}{\nord@paper}
\newcommand{\nordorientation}{\nord@orientation}

\PassOptionsToPackage{
}{tikzposter}
\LoadClass[
    \nordpaper,
    \nordorientation,
]{tikzposter}

\usepackage{filecontents}
