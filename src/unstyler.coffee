###!
# Copyright (c) 2013 The University of Queensland
# (UQ ITEE e-Research Group)
#
# MIT Licensed
###
"use strict"
((exportFunc) ->
  
  # Implementing foldLeft so we can apply lists of operations
  foldLeft = (iterable, zero, f) ->
    foldLeftArray = (iterable, zero, f) ->
      memo = zero
      for n in iterable
        memo = f(memo, n)
      memo
    if iterable instanceof Array
      foldLeftArray(iterable, zero, f)
    else
      fPair = (zero, pair) -> f(zero, pair[1], pair[0])
      foldLeftArray([k, v] for k, v of iterable, zero, fPair)
  
  # Another common utility function that's very useful for handling lists
  takeWhile = (iterable, f) ->
    l = []
    for i in iterable
      if f(i)
        l.push(i)
      else
        break
    l
        
  # Higher order function for text replacement operations
  replaceOp = (regex, replacement) -> (text) ->
    text.replace(new RegExp(regex.source, 'mg'), replacement)

  # Higher order function for text removal operations
  removeOp = (regex) -> (text) ->
    text.replace(new RegExp(regex.source, 'mg'), '')

  # Find a MS Word paragraphs that are actually list items
  locateLists = (text) ->
    re = /<p[^>]+style='[^']*mso-list\:[\s\S]+?<\/p>/m
    indexes = []
    i = 0
    while (m = text[i..].match(re))
      matchStr = m[0]
      foundAt = i + m.index
      untilIndex = foundAt + matchStr.length
      msoList = matchStr.match(/l(\d+) level(\d+)/)
      rootId = parseInt(msoList[1])
      depth = parseInt(msoList[2])
      listType =
        if (/^<p[^>]*>\d+\.(&nbsp;\s*)+/.test(text[foundAt...untilIndex]))
          'ol'
        else
          'ul'
      indexes.push {
        start: foundAt
        end: untilIndex
        type: listType
        root: rootId
        depth: depth
      }
      i = untilIndex
    indexes
  
  # Convert MS Word lists to actual HTML lists. Handles nesting.
  convertLists = (text) ->
    # Create function to insert string at index
    insertOp = (i, str) -> 
      # Function which inserts the string at the specified index
      f = (t) -> t[0..(i-1)] + str + t[i..]
      # Override toString so debugging is easier
      f.toString = () -> "Insert @ "+i+": "+str
      # Return function
      f
    # Specialized versions of insertOp
    openListOp = (indexes) ->
      insertOp(indexes[0].start, "<"+indexes[0].type+">")
    closeListOp = (indexes) ->
      insertOp(indexes[indexes.length - 1].end, "</"+indexes[0].type+">")
    # Handle increasing depth for lists by checking for depth increases
    # for second-element onwards and recursively handling.
    partitionDepths = (l) ->
      if l.length == 0
        []
      else
        differentDepth = takeWhile(l[1..], (i) -> l[0].depth != i.depth)
        if differentDepth.length == 0
          (new Array()).concat(
            [insertOp(l[0].start, "<li>"), insertOp(l[0].end, "</li>")],
            partitionDepths(l[1..]))
        else
          (new Array()).concat(
            [insertOp(l[0].start, "<li>"),
             openListOp(differentDepth)],
            partitionDepths(differentDepth),
            [closeListOp(differentDepth),
             insertOp(differentDepth[differentDepth.length-1].end, "</li>")],
            partitionDepths(l[(differentDepth.length+1)..]))
    # Get insertions by breaking up lists by root ID
    partitionRoots = (l) ->
      if l.length == 0
        []
      else
        sameRoot = takeWhile(l, (i) -> l[0].root == i.root)
        (new Array()).concat(
          [openListOp(sameRoot)],
          partitionDepths(sameRoot),
          [closeListOp(sameRoot)],
          partitionRoots(l[(sameRoot.length)..]))
    # Find a MS Word paragraphs that are actually list items
    indexes = locateLists(text)
    if (indexes.length == 0)
      text
    else
      # Assemble insertion actions to perform
      insertions = partitionRoots(indexes)
      # Apply insertions in reverse, so indexes remain valid
      foldLeft insertions.reverse(), text, (text, f) ->
        f(text)
    
  # Based on Jeff Atwood's "Cleaning Word's Nasty HTML"
  # http://www.codinghorror.com/blog/2006/01/cleaning-words-nasty-html.html
  operations = [
    # nothing useful comes after </html>
    removeOp(/(?:<\/html>)[\s\S]+/)
    # get rid of unnecessary tag spans (comments and title)
    removeOp(/<!--(\w|\W)+?-->/)
    removeOp(/<title>(\w|\W)+?<\/title>/)
    # Get rid of unnecessary tags
    removeOp(/<(meta|link|\/?o:|\/?style|\/?div|\/?st\d|\/?head|\/?html|body|\/?body|\/?span|!\[)[^>]*?>/)
    # Get rid of empty paragraph tags
    removeOp(/(<[^>]+>)+&nbsp;(<\/\w+>)+/)
    # remove bizarre v: element attached to <img> tag
    removeOp(/\s+v:\w+=""[^""]+""/)
    # remove extra lines
    removeOp(/(\n\r){2,}/)
    # Fix mdash
    replaceOp(/Ã¢â‚¬â€œ/, "&mdash;")
    #extract "mso-list" style to attributes
    convertLists
    # Filter textual ordered list points (real ones should now exist)
    replaceOp(/(?:<p[^>]*>(?:(?:&nbsp;)+\s*)?[a-z0-9]+\.)(?:&nbsp;\s*)+([^<]+)<\/p>/, "$1")
    # Filter textual unordered list points (real ones should now exist)
    replaceOp(/(?:<p[^>]*>[·o])(?:&nbsp;\s*)+([^<]+)<\/p>/, "$1")
    # Get rid of classes and styles
    removeOp(/\s?class=([\'"][^\'"]*[\'"]|\w+)/)
    removeOp(/\s+style='[^']+'/)
    # Replace bold with strong
    replaceOp(/<b>([\s\S]*)<\/b>/, "<strong>$1</strong>")
    # Replace italic with em
    replaceOp(/<i>([\s\S]*)<\/i>/, "<em>$1</em>")
    # Convert remaining new lines to spaces
    replaceOp(/(\r\n)/, ' ')
  ]

  unstyle = (html) ->
    foldLeft operations, html, (text, f) ->
      f(text)

  # Export module as a single function
  unstylerModule = unstyle 
  # Include utility functions for testing
  unstylerModule.foldLeft = foldLeft
  unstylerModule.takeWhile = takeWhile

  exportFunc(unstylerModule)
)(
  # Export module appropriately for environment
  if exports ? false
    # Node.js
    (m) -> module.exports = m
  else if window ? false
    # Browser
    (m) -> window.unstyle = m
  else
    # As return value
    (m) -> m
)