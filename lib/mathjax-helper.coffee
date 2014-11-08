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

    if !@queryRenderLaTex()
      return text

    # Begining of file cannot begin with $, prepend with ' ' if is so
    if text.charAt(0) is '$'
      text = [' ', text].join('')


    # Parse displayed equations
    regex       = /^(?:\$\$|\\\[)[^\S\n]*\n((?:[^\n]*\n+)*?)^(?:\$\$|\\\])[^\S\n]*(?=\n)/gm
    parsedText  = text.replace(regex, "\n\n<script type=\"math/tex; mode=display\">\n$1</script>\n\n")

    # Parse inline equations
    regex = /([^\\\$])\$(?!\$)([\s\S]*?)([^\\])\$/gm
    parsedText = parsedText.replace( regex, "$1<span><script type=\"math/tex\">`$2$3`</script></span>")

    # Parse escaped $
    regex = /[\\]\$/gm
    parsedText = parsedText.replace( regex, "$")

    return parsedText

  postprocessor: (html, callback) ->
    if !@queryRenderLaTex()
      callback(null, html.html().trim())
      return # adding this return makes it work, why?

    o = cheerio.load(html.html())
    regex = /(?:<code>|<\/code>)/gm
    o("script[type='math/tex']").contents().replaceWith () ->
      # The .text decodes the HTML entities for &,<,> as in code blocks the
      # are automatically converted into HTML entities
      o(this).text().replace regex, (match) ->
        switch match
          when '<code>'   then ''
          when '</code>'  then ''
          else ''

    previewHTML           = document.createElement("div")
    previewHTML.innerHTML = o.html()

    renderPreview = () ->
      callback(null, previewHTML.innerHTML)
      return
    MathJax.Hub.Queue ["Typeset", MathJax.Hub, previewHTML, renderPreview]

    return

  queryRenderLaTex: ->
    atom.config.get('markdown-preview.renderLaTex')

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
