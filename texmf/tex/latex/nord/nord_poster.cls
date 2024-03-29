\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nord_poster}[2023/11/09 tikzposter with colours from Nord theme]
\RequirePackage{pgfopts}

% TODO Add support for defaults:
% - Default paper should be: a0paper
% - Default orientation should be: portrait
\pgfkeys{
    /nord/.cd,
    background/.store in=\nord@background,
    orientation/.store in=\nord@orientation,
    paper/.store in=\nord@paper,
}

\ProcessPgfOptions{/nord}

\newcommand{\nordbackground}{\nord@background}
\newcommand{\nordorientation}{\nord@orientation}
\newcommand{\nordpaper}{\nord@paper}

\PassOptionsToPackage{
}{tikzposter}
\LoadClass[
    \nordpaper,
    \nordorientation,
]{tikzposter}

\PassOptionsToPackage{
    backend=biber,
    bibencoding=utf8,
    language=auto,
    style=numeric-comp,
    sorting=nyt,
    maxbibnames=99,
    maxcitenames=1,
    natbib=true,
    giveninits=true,
    url=false,
}{biblatex}
\RequirePackage{biblatex}

% Get rid of LaTeX/TikZ statement
\tikzposterlatexaffectionproofoff

\RequirePackage{amsmath}
\RequirePackage{filecontents}
\RequirePackage[utf8]{inputenc}


\RequirePackage{nord_colour}

% TODO Make style switch on background

\definecolorstyle{nordcolourstyle}{
    % \colorlet{colorOne}{black}
    % \colorlet{colorTwo}{mygray}
    % \colorlet{colorThree}{mygray}
}{
    % Background Colors ----------------
    \colorlet{backgroundcolor}{nord10}
    \colorlet{framecolor}{white}
    % Title Colors ---------------------
    \colorlet{titlefgcolor}{black}
    \colorlet{titlebgcolor}{white}
    % Block Colors ---------------------
    \colorlet{blocktitlebgcolor}{white}
    \colorlet{blocktitlefgcolor}{black}
    \colorlet{blockbodybgcolor}{white}
    \colorlet{blockbodyfgcolor}{black}
    % Innerblock Colors ----------------
    \colorlet{innerblocktitlebgcolor}{nord4}
    \colorlet{innerblocktitlefgcolor}{black}
    \colorlet{innerblockbodybgcolor}{white}
    \colorlet{innerblockbodyfgcolor}{black}
    % Note colors ----------------------
    \colorlet{notefgcolor}{black}
    \colorlet{notebgcolor}{nord13}
    \colorlet{notefrcolor}{white}
}

% \usetheme{Default}
% \usetheme{Autumn}\usecolorstyle[colorPalette=BrownBlueOrange]{Germany}
\usecolorstyle{nordcolourstyle}
\usetitlestyle{Default}
