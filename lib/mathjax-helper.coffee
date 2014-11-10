#
# mathjax-helper
#
# This module will handle loading the MathJax environment, and attaching
# the appropriate event listeners to markdown-preview pane items so that
# latex display equations can be rendered.
#

cheerio = require 'cheerio'

module.exports =
  loadMathJax: ->
    # Load MathJax
    script = document.createElement("script")
    script.addEventListener "load", () ->
      configureMathJax()
    script.type   = "text/javascript";
    script.src    = process.env['HOME']+"/.atom/MathJax/MathJax.js?delayStartupUntil=configured"
    document.getElementsByTagName("head")[0].appendChild(script)
    return

  preprocessor: (text) ->
    # Replace latex blocks with MathJax script delimited blocks. See
    # docs.mathjax.org/en/latest/model.html for more info on MathJax preprocessor

    # Begining of file cannot begin with $, prepend with ' ' if is so
    if text.charAt(0) is '$'
      text = [' ', text].join('')

    # Parse displayed equations
    # For the use case performance boost we HAVE to limit delimiters to \[...\]
    # becasue this gives a unique opening and closing delimiter. With $$ as
    # delimiters, then if we start to insert a new disp eq, '$$' then before we
    # add the closing delimiters the parser will match these too any following
    # $$ which will be opening delimiters to a following disp eq block. The
    # result is a cascade of changed disp equations, and this overloads the
    # postprocessor with many MathJax.Hub.Queue calls, which actually ends up
    # giving a perfromance hit rather than boost!
    #
    # The alternative is to restrict the number of MathJax.Hub.Queue calls to
    # one, and if we go over that then simply typeset the page.... actually Ill
    # try that first :D
    regex       = /^(?:\$\$|\\\[)[^\S\n]*\n((?:[^\n]*\n+)*?)^(?:\$\$|\\\])[^\S\n]*(?=\n)/gm
    parsedText  = text.replace(regex, "\n\n<script type=\"math/tex; mode=display\" class=\"math-tex\">\n$1</script>\n\n")

    # Parse inline equations
    regex = /([^\\\$])\$(?!\$)([\s\S]*?)([^\\])(?:\$|$)/gm
    parsedText = parsedText.replace( regex, "$1<span><script type=\"math/tex\" class=\"math-tex\">`$2$3`</script></span>")

    # Parse escaped $
    regex = /[\\]\$/gm
    parsedText = parsedText.replace( regex, "$")

    return parsedText

  postprocessor: (html, oldHtml, callback) ->
    o = cheerio.load(html.html())

    # Filter out code tags in inline equations
    regex = /(?:<code>|<\/code>)/gm
    o("script[type='math/tex']").contents().replaceWith () ->
      # The .text decodes the HTML entities for &,<,> as in code blocks the
      # are automatically converted into HTML entities
      o(this).text().replace regex, (match) ->
        switch match
          when '<code>'   then ''
          when '</code>'  then ''
          else ''

    # Find the LaTeX in the old html
    oldHTML       = cheerio.load("<div>#{oldHtml}</div>")
    oldEquations  = oldHTML("script[class='math-tex']")
    newEquations  = o("script[class='math-tex']")

    # Load the new html into a DOM object
    previewHTML           = document.createElement("div")
    previewHTML.innerHTML = o.html()
    equations             = previewHTML.getElementsByClassName("math-tex")

    # Check if the number of equations has changed
    if newEquations.length is oldEquations.length
      modEquations = []

      # Check if the LaTeX of each equation has changed
      for i in [0..(newEquations.length-1)]
        if newEquations.eq(i).html() is oldEquations.eq(i).html()
          newEquations.eq(i).before( cheerio.html(oldEquations.eq(i).prev()) )
        else
          if modEquations.length is 0
            console.log(i)
            modEquations.push(i)
          else
            break

      if modEquations.length > 1
        MathJax.Hub.Queue ["Typeset", MathJax.Hub, previewHTML]
      else
        # Update the DOM object with the processed html and typeset remaining eq
        previewHTML.innerHTML = o.html()
        for i in modEquations
          MathJax.Hub.Queue ["Typeset", MathJax.Hub, equations.item(i)]

    # If no of equations has changed simply queue the entire DOM for typesetting
    # manually queuing each equation causes performance to take a massive hit
    else
      console.log("not equal")
      MathJax.Hub.Queue ["Typeset", MathJax.Hub, previewHTML]

    renderPreview = () ->
      callback(null, previewHTML.innerHTML)
      return
    MathJax.Hub.Queue [renderPreview]

    return

configureMathJax = ->
  MathJax.Hub.Config
    # Similar to TeX-AMS_HTML without any extension. This kills the MathJax
    # preprocessor and the MathMenu and MathZoom features
    jax: ["input/TeX","output/HTML-CSS"]
    extensions: []
    TeX:
      extensions: ["AMSmath.js","AMSsymbols.js","noErrors.js","noUndefined.js"]
    messageStyle: "none"
    showMathMenu: false
  MathJax.Hub.Configured()
  return
