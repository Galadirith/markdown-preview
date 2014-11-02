/**
 * mathjax-helper
 *
 * This module will handle loading the MathJax environment, and attaching
 * the appropriate event listeners to markdown-preview pane items so that
 * latex display equations can be rendered.
 */

module.exports = function() {
  // Load MathJax
  var script    = document.createElement("script");
  script.addEventListener("load", loadedMathJaxScript);
  script.type   = "text/javascript";
  script.src    = "c:/Users/Galadirith/.atom/MathJax/MathJax.js?config=TeX-AMS_HTML&delayStartupUntil=configured";
  document.getElementsByTagName("head")[0].appendChild(script);

  function loadedMathJaxScript() {
    configureMathJax();
    enableMathjaxPreview();
  }

  function configureMathJax() {
    MathJax.Hub.Config({
      extensions: ["MathMenu.js","MathZoom.js"],
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
        // Need an IIFE because the .Queue callls contain a callback that is not
        // actually invoked untill focus is brought to the tab/item. Regardless
        // of when the callback is called, you'd need the IIFE anyway otherwise
        // you'll be referencing panes[panes.length+1]! :D
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
