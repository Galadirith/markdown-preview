#
# mathjax-helper
#
# This module will handle loading the MathJax environment, and attaching
# the appropriate event listeners to markdown-preview pane items so that
# latex display equations can be rendered.
#

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

exports.parseMarkdownLatex = (text) ->
  # Replace latex blocks with MathJax script delimited blocks. See
  # docs.mathjax.org/en/latest/model.html for more info on MathJax preprocessor

  # Parse displayed equations
  regex       = /^\s*?\n\$\$\n((?:[^\n]*\n+)*?)^\$\$(?=\n)/gm
  parsedText  = text.replace(regex, "\n<script type=\"math/tex; mode=display\">\n$1</script>")

  # Parse inline equations
  regex = /([^\\\$])\$(?!\$)([\s\S]*?)([^\\])\$/gm
  parsedText = parsedText.replace( regex, "$1<script type=\"math/tex\">$2$3</script>")

  # Parse escaped $
  regex = /[\\]\$/gm
  parsedText = parsedText.replace( regex, "$")

  return parsedText

configureMathJax = ->
  MathJax.Hub.Config
    # Similar to TeX-AMS_HTML without the 'tex2jax.js' extension. This kills
    # the MathJax preprocessor
    jax: ["input/TeX","output/HTML-CSS"]
    extensions: ["MathMenu.js","MathZoom.js"]
    TeX:
      extensions: ["AMSmath.js","AMSsymbols.js","noErrors.js","noUndefined.js"]
    messageStyle: "none"
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
