#
# mathjax-helper
#
# This module will handle loading the MathJax environment, and attaching
# the appropriate event listeners to markdown-preview pane items so that
# latex display equations can be rendered.
#

cheerio = require 'cheerio'

exports.loadMathJax = ->
  # Load MathJax
  script        = document.createElement("script")
  script.addEventListener "load", () ->
    configureMathJax()
    enableMathjaxPreview()
  script.type   = "text/javascript";
  script.src    = process.env['HOME']+"/.atom/MathJax/MathJax.js?delayStartupUntil=configured"
  document.getElementsByTagName("head")[0].appendChild(script)
  return

exports.preprocessor = (text) ->
  # Replace latex blocks with MathJax script delimited blocks. See
  # docs.mathjax.org/en/latest/model.html for more info on MathJax preprocessor

  if !atom.config.get('markdown-preview.renderLaTex')
    return text

  # Parse displayed equations
  regex       = /^\s*?\n\$\$\n((?:[^\n]*\n+)*?)^\$\$(?=\n)/gm
  parsedText  = text.replace(regex, "\n<script type=\"math/tex; mode=display\">\n$1</script>")

  # Parse inline equations
  regex = /([^\\\$])\$(?!\$)([\s\S]*?)([^\\])\$/gm
  parsedText = parsedText.replace( regex, "$1<script type=\"math/tex\">`$2$3`</script>")

  # Parse escaped $
  regex = /[\\]\$/gm
  parsedText = parsedText.replace( regex, "$")

  return parsedText

exports.postprocessor = (html) ->
  if !atom.config.get('markdown-preview.renderLaTex')
    return html

  o = cheerio.load(html)
  regex = /(?:<code>|<\/code>)/gm
  o("script[type='math/tex']").contents().replaceWith () ->
    # The .text decodes the HTML entities for &,<,> as in code blocks the
    # are automatically converted into HTML entities
    o(this).text().replace regex, (match) ->
      switch match
        when '<code>'   then ''
        when '</code>'  then ''
        else ''
  o.html()

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

enableMathjaxPreview = ->
  # Process existing markdown-preview pane items and add markdown-changed callback
  panes = atom.workspace.getPaneItems();
  for pane in panes
    do (pane) ->
      if( pane.constructor.name == "MarkdownPreviewView" )
        MathJax.Hub.Queue ["Typeset", MathJax.Hub, pane[0]]
        pane.on 'markdown-preview:markdown-changed', () ->
          MathJax.Hub.Queue ["Typeset", MathJax.Hub, pane[0]]

  # Watch for new markdown-preview pane items, process and add markdown-changed callback
  atom.workspace.onDidAddPaneItem (event) ->
    MathJax.Hub.Queue ["Typeset", MathJax.Hub, event.item[0]]
    event.item.on 'markdown-preview:markdown-changed', () ->
      MathJax.Hub.Queue ["Typeset", MathJax.Hub, event.item[0]]

  return
