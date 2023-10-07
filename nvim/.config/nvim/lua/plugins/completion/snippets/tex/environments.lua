-- [
-- snip_env + autosnippets
-- ]
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

--[
-- personal imports
--]
local tex = require("plugins.completion.snippets.tex.utils.conditions")
local make_condition = require("luasnip.extras.conditions").make_condition
local in_bullets_cond = make_condition(tex.in_bullets)
local line_begin = require("luasnip.extras.conditions.expand").line_begin

M = {
	s(
		{ trig = "beg", name = "begin/end", dscr = "begin/end environment (generic)" },
		fmta(
			[[
    \begin{<>}
    <>
    \end{<>}
    ]],
			{ i(1), i(0), rep(1) }
		),
		{ condition = tex.in_text, show_condition = tex.in_text }
	),

	s(
		{ trig = "-i", name = "itemize", dscr = "bullet points (itemize)" },
		fmta(
			[[ 
    \begin{itemize}
    \item <>
    \end{itemize}
    ]],
			{ c(1, { i(0), sn(
				nil,
				fmta(
					[[
        [<>] <>
        ]],
					{ i(1), i(0) }
				)
			) }) }
		),
		{ condition = tex.in_text, show_condition = tex.in_text }
	),

	-- requires enumitem
	s(
		{ trig = "-e", name = "enumerate", dscr = "numbered list (enumerate)" },
		fmta(
			[[ 
    \begin{enumerate}<>
    \item <>
    \end{enumerate}
    ]],
			{
				c(
					1,
					{
						t(""),
						sn(
							nil,
							fmta(
								[[
        [label=<>]
        ]],
								{ c(1, { t("(\\alph*)"), t("(\\roman*)"), i(1) }) }
							)
						),
					}
				),
				c(2, { i(0), sn(
					nil,
					fmta(
						[[
        [<>] <>
        ]],
						{ i(1), i(0) }
					)
				) }),
			}
		),
		{ condition = tex.in_text, show_condition = tex.in_text }
	),

	s(
		{ trig = "doc!", name = "document", dscr = "document environment" },
		fmta(
			[[
    % --- LaTeX Lecture Notes Template - S. Venkatraman ---

    % --- Set document class and font size ---

    \documentclass[letterpaper, 12pt]{article}

    % --- Package imports ---

    % Extended set of colors
    \usepackage[dvipsnames]{xcolor}

    \usepackage{
      amsmath, amsthm, amssymb, mathtools, dsfont, units,          % Math typesetting
      graphicx, wrapfig, subfig, float,                            % Figures and graphics formatting
      listings, color, inconsolata, pythonhighlight,               % Code formatting
      fancyhdr, sectsty, hyperref, enumerate, enumitem, framed }   % Headers/footers, section fonts, links, lists

    % lipsum is just for generating placeholder text and can be removed
    \usepackage{hyperref, lipsum} 

    % --- Fonts ---

    \usepackage{newpxtext, newpxmath, inconsolata}

    % --- Page layout settings ---

    % Set page margins
    \usepackage[left=1.35in, right=1.35in, top=1.0in, bottom=.9in, headsep=.2in, footskip=0.35in]{geometry}

    % Anchor footnotes to the bottom of the page
    \usepackage[bottom]{footmisc}

    % Set line spacing
    \renewcommand{\baselinestretch}{1.2}

    % Set spacing between paragraphs
    \setlength{\parskip}{1.3mm}

    % Allow multi-line equations to break onto the next page
    \allowdisplaybreaks

    % --- Page formatting settings ---

    % Set image captions to be italicized
    \usepackage[font={it,footnotesize}]{caption}

    % Set link colors for labeled items (blue), citations (red), URLs (orange)
    \hypersetup{colorlinks=true, linkcolor=RoyalBlue, citecolor=RedOrange, urlcolor=ForestGreen}

    % Set font size for section titles (\large) and subtitles (\normalsize) 
    \usepackage{titlesec}
    \titleformat{\section}{\large\bfseries}{{\fontsize{19}{19}\selectfont\textreferencemark}\;\; }{0em}{}
    \titleformat{\subsection}{\normalsize\bfseries\selectfont}{\thesubsection\;\;\;}{0em}{}

    % Enumerated/bulleted lists: make numbers/bullets flush left
    %\setlist[enumerate]{wide=2pt, leftmargin=16pt, labelwidth=0pt}
    \setlist[itemize]{wide=0pt, leftmargin=16pt, labelwidth=10pt, align=left}

    % --- Table of contents settings ---

    \usepackage[subfigure]{tocloft}

    % Reduce spacing between sections in table of contents
    \setlength{\cftbeforesecskip}{.9ex}

    % Remove indentation for sections
    \cftsetindents{section}{0em}{0em}

    % Set font size (\large) for table of contents title
    \renewcommand{\cfttoctitlefont}{\large\bfseries}

    % Remove numbers/bullets from section titles in table of contents
    \makeatletter
    \renewcommand{\cftsecpresnum}{\begin{lrbox}{\@tempboxa}}
    \renewcommand{\cftsecaftersnum}{\end{lrbox}}
    \makeatother

    % --- Set path for images ---

    \graphicspath{{Images/}{../Images/}}

    % --- Math/Statistics commands ---

    % Add a reference number to a single line of a multi-line equation
    % Usage: "\numberthis\label{labelNameHere}" in an align or gather environment
    \newcommand\numberthis{\addtocounter{equation}{1}\tag{\theequation}}

    % Shortcut for bold text in math mode, e.g. $\b{X}$
    \let\b\mathbf

    % Shortcut for bold Greek letters, e.g. $\bg{\beta}$
    \let\bg\boldsymbol

    % Shortcut for calligraphic script, e.g. %\mc{M}$
    \let\mc\mathcal

    % \mathscr{(letter here)} is sometimes used to denote vector spaces
    \usepackage[mathscr]{euscript}

    % Convergence: right arrow with optional text on top
    % E.g. $\converge[p]$ for converges in probability
    \newcommand{\converge}[1][]{\xrightarrow{#1}}

    % Weak convergence: harpoon symbol with optional text on top
    % E.g. $\wconverge[n\to\infty]$
    \newcommand{\wconverge}[1][]{\stackrel{#1}{\rightharpoonup}}

    % Equality: equals sign with optional text on top
    % E.g. $X \equals[d] Y$ for equality in distribution
    \newcommand{\equals}[1][]{\stackrel{\smash{#1}}{=}}

    % Normal distribution: arguments are the mean and variance
    % E.g. $\normal{\mu}{\sigma}$
    \newcommand{\normal}[2]{\mathcal{N}\left(#1,#2\right)}

    % Uniform distribution: arguments are the left and right endpoints
    % E.g. $\unif{0}{1}$
    \newcommand{\unif}[2]{\text{Uniform}(#1,#2)}

    % Independent and identically distributed random variables
    % E.g. $ X_1,...,X_n \iid \normal{0}{1}$
    \newcommand{\iid}{\stackrel{\smash{\text{iid}}}{\sim}}

    % Sequences (this shortcut is mostly to reduce finger strain for small hands)
    % E.g. to write $\{A_n\}_{n\geq 1}$, do $\bk{A_n}{n\geq 1}$
    \newcommand{\bk}[2]{\{#1\}_{#2}}

    % Math mode symbols for common sets and spaces. Example usage: $\R$
    \newcommand{\R}{\mathbb{R}}	% Real numbers
    \newcommand{\C}{\mathbb{C}}	% Complex numbers
    \newcommand{\Q}{\mathbb{Q}}	% Rational numbers
    \newcommand{\Z}{\mathbb{Z}}	% Integers
    \newcommand{\N}{\mathbb{N}}	% Natural numbers
    \newcommand{\F}{\mathcal{F}}	% Calligraphic F for a sigma algebra
    \newcommand{\El}{\mathcal{L}}	% Calligraphic L, e.g. for L^p spaces

    % Math mode symbols for probability
    \newcommand{\pr}{\mathbb{P}}	% Probability measure
    \newcommand{\E}{\mathbb{E}}	% Expectation, e.g. $\E(X)$
    \newcommand{\var}{\text{Var}}	% Variance, e.g. $\var(X)$
    \newcommand{\cov}{\text{Cov}}	% Covariance, e.g. $\cov(X,Y)$
    \newcommand{\corr}{\text{Corr}}	% Correlation, e.g. $\corr(X,Y)$
    \newcommand{\B}{\mathcal{B}}	% Borel sigma-algebra

    % Other miscellaneous symbols
    \newcommand{\tth}{\text{th}}	% Non-italicized 'th', e.g. $n^\tth$
    \newcommand{\Oh}{\mathcal{O}}	% Big-O notation, e.g. $\O(n)$
    \newcommand{\1}{\mathds{1}}	% Indicator function, e.g. $\1_A$

    % Additional commands for math mode
    \DeclareMathOperator*{\argmax}{argmax}		% Argmax, e.g. $\argmax_{x\in[0,1]} f(x)$
    \DeclareMathOperator*{\argmin}{argmin}		% Argmin, e.g. $\argmin_{x\in[0,1]} f(x)$
    \DeclareMathOperator*{\spann}{Span}		% Span, e.g. $\spann\{X_1,...,X_n\}$
    \DeclareMathOperator*{\bias}{Bias}		% Bias, e.g. $\bias(\hat\theta)$
    \DeclareMathOperator*{\ran}{ran}			% Range of an operator, e.g. $\ran(T) 
    \DeclareMathOperator*{\dv}{d\!}			% Non-italicized 'with respect to', e.g. $\int f(x) \dv x$
    \DeclareMathOperator*{\diag}{diag}		% Diagonal of a matrix, e.g. $\diag(M)$
    \DeclareMathOperator*{\trace}{trace}		% Trace of a matrix, e.g. $\trace(M)$
    \DeclareMathOperator*{\supp}{supp}		% Support of a function, e.g., $\supp(f)$

    % Numbered theorem, lemma, etc. settings - e.g., a definition, lemma, and theorem appearing in that 
    % order in Lecture 2 will be numbered Definition 2.1, Lemma 2.2, Theorem 2.3. 
    % Example usage: \begin{theorem}[Name of theorem] Theorem statement \end{theorem}
    \theoremstyle{definition}
    \newtheorem{theorem}{Theorem}[section]
    \newtheorem{proposition}[theorem]{Proposition}
    \newtheorem{lemma}[theorem]{Lemma}
    \newtheorem{corollary}[theorem]{Corollary}
    \newtheorem{definition}[theorem]{Definition}
    \newtheorem{example}[theorem]{Example}
    \newtheorem{remark}[theorem]{Remark}

    % Un-numbered theorem, lemma, etc. settings
    % Example usage: \begin{lemma*}[Name of lemma] Lemma statement \end{lemma*}
    \newtheorem*{theorem*}{Theorem}
    \newtheorem*{proposition*}{Proposition}
    \newtheorem*{lemma*}{Lemma}
    \newtheorem*{corollary*}{Corollary}
    \newtheorem*{definition*}{Definition}
    \newtheorem*{example*}{Example}
    \newtheorem*{remark*}{Remark}
    \newtheorem*{claim}{Claim}

    % --- Left/right header text (to appear on every page) ---

    % Do not include a line under header or above footer
    \pagestyle{fancy}
    \renewcommand{\footrulewidth}{0pt}
    \renewcommand{\headrulewidth}{0pt}

    % Right header text: Lecture number and title
    \renewcommand{\sectionmark}[1]{\markright{#1} }
    \fancyhead[R]{\small\textit{\nouppercase{\rightmark}}}

    % Left header text: Short course title, hyperlinked to table of contents
    \fancyhead[L]{\hyperref[sec:contents]{\small Short title of document}}

    % --- Document starts here ---

    \begin{document}

    % --- Main title and subtitle ---

    \title{<> \\[1em]
    \normalsize <>}

    % --- Author and date of last update ---

    \author{\normalsize Mika Bohinen}
    \date{\normalsize\vspace{-1ex} Last updated: \today}

    % --- Add title and table of contents ---

    \maketitle
    \tableofcontents\label{sec:contents}

    % --- Main content: import lectures as subfiles ---

    \input{Lectures/Lecture1}

    % --- Bibliography ---

    % Start a bibliography with one item.
    % Citation example: "\cite{williams}".

    \begin{thebibliography}{1}

    \bibitem{williams}
      Williams, David.
      \textit{Probability with Martingales}.
      Cambridge University Press, 1991.
      Print.

    % Uncomment the following lines to include a webpage
    % \bibitem{webpage1}
    %   LastName, FirstName. ``Webpage Title''.
    %   WebsiteName, OrganizationName.
    %   Online; accessed Month Date, Year.\\
    %   \texttt{www.URLhere.com}

    \end{thebibliography}

    % --- Document ends here ---

    \end{document}
    ]],
			{ i(1), i(0) }
		)
	),

	-- generate new bullet points
	autosnippet(
		{ trig = "--", hidden = true },
		{ t("\\item") },
		{ condition = in_bullets_cond * line_begin, show_condition = in_bullets_cond * line_begin }
	),
	autosnippet(
		{ trig = "!-", name = "bullet point", dscr = "bullet point with custom text" },
		fmta(
			[[ 
    \item [<>]<>
    ]],
			{ i(1), i(0) }
		),
		{ condition = in_bullets_cond * line_begin, show_condition = in_bullets_cond * line_begin }
	),
}

return M
