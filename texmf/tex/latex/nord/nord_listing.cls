\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nord_listing}[2025/03/26 Standalone listing document with colours from Nord theme]

\RequirePackage{pgfopts}

\pgfkeys{
    /nord/.cd,
    background/.store in=\nord@background,
}

\ProcessPgfOptions{/nord}

\newcommand{\nordbackground}{\nord@background}

\LoadClass[minted]{standalone}

\usepackage{tcolorbox}
\tcbuselibrary{minted}

\RequirePackage{nord_colour}
\colorlet{nord frame}{nord fg!10!nord bg}

\tcbset{
    default minted options={
        autogobble,
        fontsize=\footnotesize,
        stripall,
        tabsize=4,
    },
    colback=nord bg,
    colframe=nord frame,
    fonttitle=\footnotesize,
    listing only,
}
\ifthenelse{\equal{\nordbackground}{light}}
{
    % \tcbset{
    %     minted style=bw,
    % }
    \usemintedstyle{bw}
}
{
    % \tcbset{
    %     minted style=nord,
    % }
    \usemintedstyle{nord}
}
\newtcblisting[]{nordcpplisting}[1]{%
    minted language=c++,
    title={#1},
}
\newtcblisting[]{nordpythonlisting}[1]{%
    minted language=python,
    title={#1},
}
% TODO For some reason bash statements are always shown in black, also on dark background
\newtcblisting[]{nordbashlisting}[1]{%
    minted language=bash,
    title={#1},
}

% \newmintinline{"nordcpp"}{c++}{style=nord}
% \newmintinline["nordpython"]{"c++"}{}
