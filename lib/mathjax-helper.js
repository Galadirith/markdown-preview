/**
 * mathjax-helper
 *
 * This module will handle loading the MathJax environment, and attaching
 * the appropriate event listeners to markdown-preview pane items so that
 * latex display equations can be rendered.
 */

exports.loadMathJax = function() {
  // Load MathJax
  var script    = document.createElement("script");
  script.addEventListener("load", loadedMathJaxScript);
  script.type   = "text/javascript";
  script.src    = process.env['HOME']+"/.atom/MathJax/MathJax.js?delayStartupUntil=configured";
  document.getElementsByTagName("head")[0].appendChild(script);

  function loadedMathJaxScript() {
    configureMathJax();
    enableMathjaxPreview();
  }

  // We use the configuration for TeX-AMS_HTML but without the 'tex2jax.js'
  // extension. This kills MathJax's preprocessor for latex equations so that
  // mathjax-helper can take full control of parsing them
  function configureMathJax() {
    MathJax.Hub.Config({
      jax: ["input/TeX","output/HTML-CSS"],
      extensions: ["MathMenu.js","MathZoom.js"],
      TeX: {
        extensions: ["AMSmath.js","AMSsymbols.js","noErrors.js","noUndefined.js"]
      },
      messageStyle: "none"
    });

    MathJax.Hub.Configured();
  }

  function enableMathjaxPreview() {

    // Process existing markdown-preview pane items and add markdown-changed callback
    var panes = atom.workspace.getPaneItems();
    var i;
    for( i=0; i<panes.length; i++ ) {
      if( panes[i].constructor.name == "MarkdownPreviewView" ) {
        (function(pane) {
          MathJax.Hub.Queue(["Typeset", MathJax.Hub, pane[0]]);
          panes[i].on(
            'markdown-preview:markdown-changed',
            function(){MathJax.Hub.Queue(["Typeset", MathJax.Hub, pane[0]])}
          );
        })(panes[i]);
      }
    }

    // Watch for new markdown-preview pane items, process and add markdown-changed callback
    atom.workspace.onDidAddPaneItem(function(event){
      MathJax.Hub.Queue(["Typeset", MathJax.Hub, event.item[0]])
      event.item.on(
        'markdown-preview:markdown-changed',
        function(){MathJax.Hub.Queue(["Typeset", MathJax.Hub, event.item[0]])}
      )
    });
  }
}

exports.parseMarkdownLatex = function(text) {

  // Replace latex blocks with MathJax script delimited blocks. See
  // docs.mathjax.org/en/latest/model.html for more info on MathJax preprocessor

  // Parse displayed equations
  var regex       = /^\s*?\n\$\$\n((?:[^\n]*\n+)*?)^\$\$(?=\n)/gm;
  var parsedText  = text.replace(regex, "\n<script type=\"math/tex; mode=display\">\n$1</script>");

  // Parse inline equations
  regex = /([^\\\$])\$(?!\$)([\s\S]*?)([^\\])\$/gm;
  parsedText = parsedText.replace( regex, "$1<script type=\"math/tex\">$2$3</script>");

  // Parse escaped $
  regex = /[\\]\$/gm;
  parsedText = parsedText.replace( regex, "$");

  return parsedText;
}
