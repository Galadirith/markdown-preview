# LaTex

This fork of [markdown-preview](https://github.com/atom/markdown-preview)
enables LaTex to be rendered in a preview window of a markdown document in
[Atom](https://atom.io/). If focus is given to either the markdown source editor
or the preview window then this can be toggled in the menu **Packages &rsaquo;
Markdown Preview &rsaquo; Toggle LaTex in Active Preview** or using the keymap
`ctrl-shift-x`. Note that the default is to preview without rendering LaTex.

## Syntax

The syntax to specify an equation uses dollar signs `$`. If you want to
literally display a dollar sign you can use `\$`.

1.  **Displayed equations** are delimited by `$$`. They should occupy their own
    line. Here is an example:

    ````
    ... Here she comes to wreck the day. it's because i'm green isn't it! hey,
    maybe i will give you a call sometime. your number still 911?
    $$
    R_{\mu \nu} - {1 \over 2}g_{\mu \nu}\,R + g_{\mu \nu} \Lambda =
      {8 \pi G \over c^4} T_{\mu \nu}
    $$
    kinda hot in these rhinos. look at that, it's exactly three seconds before
    i honk your nose and pull your underwear over your head ...
    ````

    You can also use the delimiters `\[ ... \]` for display equations. Here is
    an example:

    ````
    ... Here she comes to wreck the day. it's because i'm green isn't it! hey,
    maybe i will give you a call sometime. your number still 911?
    \[
    R_{\mu \nu} - {1 \over 2}g_{\mu \nu}\,R + g_{\mu \nu} \Lambda =
      {8 \pi G \over c^4} T_{\mu \nu}
    \]
    kinda hot in these rhinos. look at that, it's exactly three seconds before
    i honk your nose and pull your underwear over your head ...
    ````

    You can use either format in the same document, and in fact the parser will
    even match `$$ ... \]` and `\[ ... $$`, however it is advised to use only a
    single format in a particular markdown document. 

2.  **Inline eqautions** are delimited by `$`, and there are no specifications
    on their placement. Here is an example:

    ````
    ... Here she comes to wreck the day. $\int -xe^{x^2} dx$ it's because i'm
    green isn't it! hey, maybe i will give you a call sometime. your number
    still 911? kinda hot in $\int -xe^{x^2} dx$ these rhinos. look at that,
    it's exactly three seconds before i honk your $\int -xe^{x^2} dx$ nose and
    pull your underwear over your head ...
    ````

## Installation

1.  Clone [galadirith/markdown-preview](https://github.com/Galadirith/markdown-preview)
    to your local computer (the location doesn't matter):

    ````bash
    $ git clone https://github.com/Galadirith/markdown-preview.git
    ````

2.  Checkout the katex branch (you should still be in the same directory ;D):

    ````bash
    $ cd markdown-preview
    $ git checkout katex
    ````

2.  Install the dependencies for the package with atom's package manager:

    ````bash
    $ apm install
    ````

3.  Link this package to your atom dev environment (it is advised not to link to
    your main atom environment, but if you would like to then drop the --dev):

    ````bash
    $ apm link --dev
    ````

4.  Download [KaTex](https://github.com/Khan/KaTeX/releases/download/v0.1.1/katex.tar.gz)
    and unzip it into your `~/.atom` directory. This is necessary because
    special css and fonts are required to render LaTeX processed by KaTeX, but
    these are not currently distributed as part of the node KaTeX package (which
    is a dependency for this package)

5.  To start using this feature open an atom dev window:

    ````bash
    # To open a dev window
    $ atom --dev

    # To open the current directory in a dev window
    $ atom --dev .
    ````
