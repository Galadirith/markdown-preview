# This file incorporates code from [markmon](https://github.com/yyjhao/markmon)
# covered by the following terms:
#
# Copyright (c) 2014, Yao Yujian, http://yjyao.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
"use strict"

{$}   = require 'atom'
fs    = require 'fs'
url   = require 'url'
path  = require 'path'

WrappedDomTree = require './wrapped-dom-tree'

module.exports = class UpdatePreview
  # @param dom A DOM element object
  #    https://developer.mozilla.org/en-US/docs/Web/API/element
  constructor: (dom, filePath) ->
    @tree     = new WrappedDomTree dom, true
    @htmlStr  = ""
    @filePath = filePath

  update: (htmlStr) ->
    if htmlStr is @htmlStr
      return

    firstTime = @htmlStr is ""
    @htmlStr  = htmlStr

    newDom            = document.createElement "div"
    newDom.className  = "update-preview"
    newDom.innerHTML  = htmlStr
    newTree           = new WrappedDomTree newDom

    r = @tree.diffTo newTree
    newTree.removeSelf()

    #
    # Add event listener to open links in markdown previews to local files with
    # relative file paths in atom
    #
    # @param aDOM A DOM element, in priniciple this can be any DOM element
    #   but it needs to have a "href" attribute, so typically should only be
    #   used for <a> tags
    #
    addLocalLinkListener = (aDOM) =>
      dirName   = path.dirname @filePath
      fileName  = $(aDOM).attr("href")
      filePath  = path.join dirName, fileName
      fs.exists filePath, (exists) ->
        if exists
          $(aDOM).click () ->
            atom.workspaceView.open filePath,
              split: 'left'
      return

    if firstTime
      r.possibleReplace = null
      r.last            = null
      $(@tree.shownTree.dom).find("a").each (i, elm) ->
        addLocalLinkListener elm
        return

    for elm in r.inserted
      if elm.tagName is "A"
        addLocalLinkListener elm

    return r
