% https://www.overleaf.com/learn/latex/Writing_your_own_class
% https://tex.stackexchange.com/questions/239416/spaces-and-commata-in-stringoptions-as-possible-in-hyperref/553533#553533
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nord_presentation}[2022/12/14 Antibes Beamer theme and colours from Nord theme]
\RequirePackage{pgfopts}

\LoadClass[t, 11pt, aspectratio=169]{beamer}

% TODO Default background for presentations is dark, so use that in case this option in not passed
\pgfkeys{
    /nord/.cd,
    background/.store in=\nord@background,
}

\ProcessPgfOptions{/nord}

\newcommand{\nordbackground}{\nord@background}


\RequirePackage{tikz}
\usetikzlibrary{positioning, shapes.geometric}

\usetheme{Antibes}


\RequirePackage{nord_colour}


%%% \RequirePackage{listings}

%%% \RequirePackage{etoolbox}
%%% \RequirePackage{xcolor}
%%% 
%%% 
%%% % nord -------------------------------------------------------------------------
%%% % https://www.nordtheme.com/docs/swatches (.gpl)
%%% % nord: Polar Night: four dark colors
%%% \definecolor{nord0}{RGB}{46, 52, 64}  % Dark
%%% % \definecolor{nord0}{cmyk}{0.0706, 0.0471, 0.0, 0.749}  % Dark
%%% \definecolor{nord1}{RGB}{59, 66, 82}  % Lighter than nord0
%%% % \definecolor{nord1}{cmyk}{0.0902, 0.0627, 0.0, 0.6784}  % Lighter than nord0
%%% \definecolor{nord2}{RGB}{67, 76, 94}  % Lighter than nord1
%%% % \definecolor{nord2}{cmyk}{0.1059, 0.0706, 0.0, 0.6314}  % Lighter than nord1
%%% \definecolor{nord3}{RGB}{76, 86, 106}  % Lighter than nord2
%%% % \definecolor{nord3}{cmyk}{0.1176, 0.0784, 0.0, 0.5843}  % Lighter than nord2
%%% 
%%% % nord: Snow Storm: three bright colors
%%% \definecolor{nord4}{RGB}{216, 222, 233}  % Bright
%%% % \definecolor{nord4}{cmyk}{0.0667, 0.0431, 0.0, 0.0863}  % Bright
%%% \definecolor{nord5}{RGB}{229, 233, 240}  % Lighter than nord4
%%% % \definecolor{nord5}{cmyk}{0.0431, 0.0275, 0.0, 0.0588}  % Ligher than nord4
%%% \definecolor{nord6}{RGB}{236, 239, 244}  % Lighter than nord5
%%% % \definecolor{nord6}{cmyk}{0.0314, 0.0196, 0.0, 0.0431}  % Ligher than nord5
%%% 
%%% % nord: Frost: four bluish colors
%%% \definecolor{nord7}{RGB}{143, 188, 187}  % Calm, frozen polar water
%%% % \definecolor{nord7}{cmyk}{0.1765, 0.0, 0.0039, 0.2627}  % Calm, frozen polar water
%%% \definecolor{nord8}{RGB}{136, 192, 208}  % Bright, shiny, pure and clear ice
%%% % \definecolor{nord8}{cmyk}{0.2824, 0.0627, 0.0, 0.1843}  % Bright, shiny, pure and clear ice
%%% \definecolor{nord9}{RGB}{129, 161, 193}  % Darkened, arctic waters
%%% % \definecolor{nord9}{cmyk}{0.251, 0.1255, 0.0, 0.2431}  % Darkened, arctic waters
%%% \definecolor{nord10}{RGB}{94, 129, 172}  % Dark, deep arctic ocean
%%% % \definecolor{nord10}{cmyk}{0.3059, 0.1686, 0.0, 0.3255}  % Dark, deep arctic ocean
%%% 
%%% % nord: Aurora: Five colorful components
%%% \definecolor{nord11}{RGB}{191, 97, 106}  % Redish
%%% % \definecolor{nord11}{cmyk}{0.0, 0.3686, 0.3333, 0.251}  % Redish
%%% \definecolor{nord12}{RGB}{208, 135, 112}  % Orange
%%% % \definecolor{nord12}{cmyk}{0.0, 0.2863, 0.3765, 0.1843}  % Orange
%%% \definecolor{nord13}{RGB}{235, 203, 139}  % Dark yellow
%%% % \definecolor{nord13}{cmyk}{0.0, 0.1255, 0.3765, 0.0784}  % Dark yellow
%%% \definecolor{nord14}{RGB}{163, 190, 140}  % Green
%%% % \definecolor{nord14}{cmyk}{0.1059, 0.0, 0.1961, 0.2549}  % Green
%%% \definecolor{nord15}{RGB}{180, 142, 173}  % Purple
%%% % \definecolor{nord15}{cmyk}{0.0, 0.149, 0.0275, 0.2941}  % Purple
%%% % nord -------------------------------------------------------------------------
%%% 
%%% % \colorlet{neg col}{nord red}
%%% % \colorlet{pos col}{nord green}
%%% 
%%% \colorlet{nord red}{nord11}
%%% \colorlet{nord green}{nord14}
%%% \colorlet{nord blue}{nord10}
%%% \colorlet{nord orange}{nord12}
%%% \colorlet{nord purple}{nord15}
%%% \colorlet{nord yellow}{nord13}
%%% \colorlet{nord gray}{nord3}
%%% 
%%% 
%%% \ifcsundef{kdjbackgroundvariant}{
%%%     % Light background
%%%     \colorlet{lue pen}{nord0}  % Darkest gray
%%% }{
%%%     \ifcsstring{kdjbackgroundvariant}{light}{
%%%         % Light background
%%%         \colorlet{lue pen}{nord0}  % Darkest gray
%%%     }{
%%%         % Dark background:
%%%         \colorlet{lue pen}{nord4}  % Lightest gray
%%%     }
%%% }
%%% 
%%% \colorlet{lue text on fill}{nord0}  % Darkest gray
%%% \colorlet{lue text}{lue pen}
%%% 
%%% 
%%% 
%%% \colorlet{comment_color}{nord10}
%%% \colorlet{identifier_color}{lue text}
%%% \colorlet{keyword_color}{lue text}
%%% \colorlet{number_color}{nord3}
%%% \colorlet{string_color}{nord12}
%%% 
%%% 
%%% \lstdefinestyle{style}{
%%%     basicstyle=%
%%%         \ttfamily
%%%         \lst@ifdisplaystyle\footnotesize\fi,
%%%     commentstyle=\itshape\color{comment_color},
%%%     identifierstyle=\color{identifier_color},
%%%     numberstyle=\color{number_color},
%%%     keywordstyle=\color{keyword_color},
%%%     stringstyle=\color{string_color},
%%%     showstringspaces=false,
%%%     % frame=single,
%%%     breaklines=true,
%%%     % postbreak=\mbox{\textcolor{red}{$\hookrightarrow$}\space},
%%% }
%%% 
%%% \lstset{
%%%     style=style}
%%% 
%%% % \lstMakeShortInline[columns=fixed]|
%%% \lstMakeShortInline|
%%% 
%%% % This command allows for code to contain suggestions where to break words: my_long\-er_name
%%% \newcommand{\lstpython}[1]{
%%%         \lstinline[
%%%                 language=Python,
%%%                 breaklines=true,
%%%                 mathescape,
%%%                 literate={\-}{}{0\discretionary{-}{}{}}
%%%             ]§#1§
%%%     }
%%% 
%%% \lstnewenvironment{pythonlisting}[2]
%%%     {
%%%         \noindent
%%%         \minipage{\textwidth}
%%%         \lstset{
%%%             language=Python,
%%%             style=style,
%%%             caption={#1},
%%%             label={#2}
%%%         }
%%%     }
%%%     {
%%%         \endminipage
%%%     }
%%% 
%%% \lstnewenvironment{cpplisting}[2]
%%%     {
%%%         \noindent
%%%         \minipage{\textwidth}
%%%         \lstset{
%%%             language=C++,
%%%             style=style,
%%%             caption={#1},
%%%             label={#2}
%%%         }
%%%     }
%%%     {
%%%         \endminipage
%%%     }


\colorlet{kdj_bullet}{nord fg!50!nord bg}
\colorlet{kdj_alert}{nord10}


\RequirePackage{caption}
\RequirePackage{environ}
\RequirePackage{hyperref}
\RequirePackage[utf8]{inputenc}  % This file contains utf8 encoded text
\RequirePackage{lmodern}
\RequirePackage{subcaption}
\RequirePackage{tabulary}
\RequirePackage{textcomp}  % textrightarrow
% \RequirePackage{tikz}
\RequirePackage{wrapfig}
\RequirePackage{textpos}

\bibliographystyle{apalike}


%%% % - https://www.nordtheme.com/docs/colors-and-palettes
%%% % - https://ramblingacademic.com/2015/12/08/how-to-quickly-overhaul-beamer-colors/
%%% % - http://www.cpt.univ-mrs.fr/~masson/latex/Beamer-appearance-cheat-sheet.pdf
%%% 
%%% 
%%% % \setbeameroption{show notes on second screen=left}  % right, left, top, bottom
%%% % \setbeameroption{show only notes}
%%% 
%%% % \addtobeamertemplate{headline}{}{%
%%% % \begin{textblock*}{100mm}(.85\textwidth,-1cm)
%%% %     \Huge\textcolor{white}{\textbf{\TeX}}
%%% % \end{textblock*}}
%%% 
%%% \setbeamertemplate{navigation symbols}{}
%%% % \useoutertheme[footline=empty,subsection=false]{miniframes}
%%% % \useinnertheme{circles}
%%% 
%%% % \addtobeamertemplate{footline}{%
%%% %     \setlength\unitlength{1ex}%
%%% %     \begin{picture}(0,0)
%%% %         \put(130,1){\makebox(0,0)[bl]{
%%% %         \includegraphics[height=0.5cm]{figure/uu_logo}
%%% %         \includegraphics[height=0.5cm]{figure/cc_by_logo}
%%% %         }}%
%%% %     \end{picture}%
%%% % }{}
%%% 
%%% % \def\vfilll{\vskip 0pt plus 1filll minus 0pt}
%%% 
%%% \captionsetup[figure]{labelformat=empty}
%%% \captionsetup[table]{labelformat=empty}

\beamertemplatenavigationsymbolsempty


%%% % https://tex.stackexchange.com/questions/4302/prettiest-way-to-typeset-c-cplusplus/4304#4304
%%% \RequirePackage{relsize}
%%% \newcommand\cpp{C\nolinebreak[4]\hspace{-.05em}\raisebox{.4ex}{\relsize{-3}{\textbf{++}}}}


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

\setbeamercolor{item}{fg=kdj_bullet}  % Bullet itself in lists
\setbeamercolor{section in toc}{fg=nord fg}  % Text in ToC
\setbeamercolor{subsection in toc}{fg=nord fg}  % Text in ToC
\setbeamercolor{subsubsection in toc}{fg=nord fg}  % Text in ToC

\setbeamercolor{block title}{bg=nord9}  % Blue
\setbeamercolor{block title alerted}{bg=nord11}  % Red
\setbeamercolor{block title example}{bg=nord14}  % Green

\setbeamercolor{alerted text}{fg=kdj_alert}  % Blue
\setbeamerfont{alerted text}{series=\bfseries}

\setbeamercolor{bibliography entry author}{fg=nord fg}
\setbeamercolor{bibliography entry title}{fg=kdj_alert}
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

