#
# katex-helper
#
# This module will provides methods to add the css and font dependencies, and
# to parse markdown formated text for LaTex equations
#

cheerio = require 'cheerio'
katex   = require 'katex'

module.exports =
  addKaTexCSS: ->
    # Add css dependency
    css       = document.createElement("link")
    css.rel   = "stylesheet";
    css.href  = process.env['HOME']+"/.atom/KaTex/katex.min.css"
    document.getElementsByTagName("head")[0].appendChild(css)

    cssDisplay = document.createElement("style")
    cssDisplay.innerHTML = "div.tex-disp {text-align: center; margin: 1em; font-size: 1.1em}"
    document.getElementsByTagName("head")[0].appendChild(cssDisplay)
    return

  preprocessor: (text) ->
    # Replace latex blocks with MathJax script delimited blocks. See
    # docs.mathjax.org/en/latest/model.html for more info on MathJax preprocessor

    # Parse displayed equations
    regex       = /^[^\S\n]*\n\$\$[^\S\n]*\n((?:[^\n]*\n+)*?)^\$\$[^\S\n]*(?=\n[^\S\n]*$)/gm
    parsedText  = text.replace regex, (match, p1) ->
      displayString = katex.renderToString("\\displaystyle {"+p1+"}")
      return "\n<div class=\"tex-disp\">\n"+displayString+"</div>"

    # Parse inline equations
    regex = /([^\\\$])\$(?!\$)([\s\S]*?)([^\\])\$/gm
    parsedText = parsedText.replace( regex, "$1<span class=\"tex-in\">`$2$3`</span>")

    # Parse escaped $
    regex = /[\\]\$/gm
    parsedText = parsedText.replace( regex, "$")

    return parsedText

  postprocessor: (html) ->
    o           = cheerio.load(html)
    regex       = /(?:<code>|<\/code>)/gm

    o("span.tex-in").each (index, elem) ->
      # Note contrary to the cheerio docs, elem cant replace o(this) as it
      # appeared to have no methods avilable?
      o(this).text (index, string) ->
      # The .text decodes the HTML entities for &,<,> as in code blocks the
      # are automatically converted into HTML entities
        inlineString = string.replace regex, (match) ->
          switch match
            when '<code>'   then ''
            when '</code>'  then ''
            else ''
        katex.renderToString(inlineString)
      o(this).html o(this).text()

    o.html()
