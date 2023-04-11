% https://www.overleaf.com/learn/latex/Writing_your_own_class
% https://tex.stackexchange.com/questions/239416/spaces-and-commata-in-stringoptions-as-possible-in-hyperref/553533#553533
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nord_presentation}[2022/12/14 Antibes Beamer theme and colours from Nord theme]
\RequirePackage{pgfopts}

% TODO Add support for defaults:
% - Default background is: dark
\pgfkeys{
    /nord/.cd,
    background/.store in=\nord@background,
}

\ProcessPgfOptions{/nord}

\newcommand{\nordbackground}{\nord@background}

\LoadClass[
    t,
    11pt,
    aspectratio=169,
]{beamer}


\RequirePackage{tikz}
\usetikzlibrary{positioning, shapes.geometric}

\usetheme{Antibes}

\RequirePackage{nord_colour}


\colorlet{nord frame}{nord fg!10!nord bg}
\colorlet{nord bullet}{nord fg!50!nord bg}
\colorlet{nord alert}{nord10}


\usepackage[export]{adjustbox}
\RequirePackage{caption}
\RequirePackage{environ}
\RequirePackage{hyperref}
\RequirePackage[utf8]{inputenc}  % This file contains utf8 encoded text
\RequirePackage{lmodern}
\RequirePackage{subcaption}
\RequirePackage{tabulary}
\RequirePackage{textcomp}  % textrightarrow
\RequirePackage{wrapfig}
\RequirePackage{textpos}

\bibliographystyle{apalike}

\beamertemplatenavigationsymbolsempty

% Use while designing theme:
% \usecolortheme[named=red]{structure}

\setbeamercolor{palette primary}{bg=nord bg, fg=nord fg}
\setbeamercolor{palette secondary}{bg=nord bg, fg=nord fg}
\setbeamercolor{palette ternary}{bg=nord bg, fg=nord fg}
\setbeamercolor{palette ternary}{bg=nord bg, fg=nord fg}

\setbeamercolor{normal text}{bg=nord bg, fg=nord fg}
\setbeamercolor{titlelike}{bg=}  % Transparent title background
\setbeamercolor{background canvas}{bg=nord bg}

\setbeamercolor{title in head/foot}{bg=nord bg, fg=nord fg}
\setbeamercolor{section in head/foot}{bg=nord bg, fg=nord fg}
\setbeamercolor{subsection in head/foot}{bg=nord bg, fg=nord fg}

\setbeamercolor{item}{fg=nord bullet}  % Bullet itself in lists
\setbeamercolor{section in toc}{fg=nord fg}  % Text in ToC
\setbeamercolor{subsection in toc}{fg=nord fg}  % Text in ToC
\setbeamercolor{subsubsection in toc}{fg=nord fg}  % Text in ToC

\setbeamercolor{block title}{bg=nord9}  % Blue
\setbeamercolor{block title alerted}{bg=nord11}  % Red
\setbeamercolor{block title example}{bg=nord14}  % Green

\setbeamercolor{alerted text}{fg=nord alert}  % Blue
\setbeamerfont{alerted text}{series=\bfseries}

\setbeamercolor{bibliography entry author}{fg=nord fg}
\setbeamercolor{bibliography entry title}{fg=nord alert}
\setbeamercolor{bibliography entry location}{fg=nord fg}
\setbeamercolor{bibliography entry note}{fg=nord fg}
\setbeamercolor{bibliography item}{fg=nord fg}


\setbeamercolor{navigation symbols}{fg=nord fg}
\setbeamercolor{navigation symbols dimmed}{fg=nord fg}

% Use while designing the theme:
% \setbeamercolor{palette sidebar primary}{bg=nord11}
% \setbeamercolor{palette sidebar secondary}{bg=nord11}
% \setbeamercolor{palette sidebar ternary}{bg=nord11}
% \setbeamercolor{palette sidebar quaternary}{bg=nord11}


\usepackage{tcolorbox}
\tcbuselibrary{minted}

% TODO Add environment for Python, reusing most of the C++ stuff (default environment?)
%    - Make a nordlisting environment that accepts a language argument
% TODO Add / verify support for inline code(?)
% TODO Make style switch on background

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
    title=#1,
}
\newtcblisting[]{nordpythonlisting}[1]{%
    minted language=python,
    title=#1,
}

% \newmintinline{"nordcpp"}{c++}{style=nord}
% \newmintinline["nordpython"]{"c++"}{}
