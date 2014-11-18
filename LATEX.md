# LaTex

This fork of [markdown-preview](https://github.com/atom/markdown-preview)
enables LaTex to be rendered in a preview window of a markdown document in
[Atom](https://atom.io/). If focus is given to either the markdown source editor
or the preview window then this can be toggled in the menu **Packages &rsaquo;
Markdown Preview &rsaquo; Toggle LaTex Rendering** or using the keymap
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

2.  Checkout the `mathjax-markmon` branch (you should still be in the same
    directory ;D):

    ````bash
    $ cd markdown-preview
    $ git checkout mathjax-markmon
    ````

2.  Install the dependencies for the package with atom's package manager:

    ````bash
    $ apm install
    ````

3.  Link this package to atom:

    ````bash
    $ apm link
    ````

4.  Clone [MathJax](https://github.com/mathjax/mathjax) into your `~/.atom`
    directory:

    ````bash
    $ cd ~/.atom
    $ git clone https://github.com/mathjax/MathJax.git
    ````

5.  Open atom an enjoy LaTeX enabled markdown ;D

## Uninstallation

1.  Navigate to the folder
    [galadirith/markdown-preview](https://github.com/Galadirith/markdown-preview)
    was cloned into in step (2) of the installation, for example if I clond it
    into the downloads folder of my home directory I would do the following:

    ````bash
    $ cd ~/downloads/markdown-preview
    ````

2.  Unlink this package from atom:

    ````bash
    $ apm unlink
    ````

3.  Delete the `markdown-preview` folder. You can do this using a gui file
    explorer or a cli as follows:

    ````bash
    $ cd ..
    $ rm -rf markdown-preview/
    ````

4.  Delete `MathJax` from your `~/.atom` directory ():

    ````bash
    $ cd ~/.atom
    $ rm -rf MathJax/
    ````

All traces of [galadirith/markdown-preview](https://github.com/Galadirith/markdown-preview)
are now removed from you system.


## Developer Installation

1.  Clone [galadirith/markdown-preview](https://github.com/Galadirith/markdown-preview)
    to your local computer (the location doesn't matter):

    ````bash
    $ git clone https://github.com/Galadirith/markdown-preview.git
    ````

2.  Checkout the `mathjax-markmon` branch (you should still be in the same
    directory ;D):

    ````bash
    $ cd markdown-preview
    $ git checkout mathjax-markmon
    ````

2.  Install the dependencies for the package with atom's package manager:

    ````bash
    $ apm install
    ````

3.  Link this package to your atom dev environment:

    ````bash
    $ apm link --dev
    ````

4.  Clone [MathJax](https://github.com/mathjax/mathjax) into your `~/.atom`
    directory:

    ````bash
    $ cd ~/.atom
    $ git clone https://github.com/mathjax/MathJax.git
    ````

5.  Open an atom dev window:

    ````bash
    # To open a dev window
    $ atom --dev

    # To open the current directory in a dev window
    $ atom --dev .
    ````
