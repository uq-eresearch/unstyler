((exports) ->

  foldLeft = (iterable, zero, f) ->
    typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'
    foldLeftArray = (iterable, zero, f) ->
      if iterable.length == 0
        zero
      else
        foldLeftArray(iterable[1..],  f(zero, iterable[0]), f)
    if typeIsArray(iterable)
      foldLeftArray(iterable, zero, f)
    else
      fPair = (zero, pair) -> f(zero, pair[1], pair[0])
      foldLeftArray([k, v] for k, v of iterable, zero, fPair)

  # Based on Jeff Atwood's "Cleaning Word's Nasty HTML"
  # http://www.codinghorror.com/blog/2006/01/cleaning-words-nasty-html.html
  removalPatterns = [
    # get rid of unnecessary tag spans (comments and title)
    '<!--(\w|\W)+?-->'
    '<title>(\w|\W)+?<\/title>'
    # Get rid of classes and styles
    '\s?class=\w+'
    "\s+style='[^']+'"
    # Get rid of unnecessary tags
    '<(meta|link|/?o:|/?style|/?div|/?st\d|/?head|/?html|body|/?body|/?span|!\\[)[^>]*?>'
    # Get rid of empty paragraph tags
    '(<[^>]+>)+&nbsp;(</\w+>)+'
    # remove bizarre v: element attached to <img> tag
    '\s+v:\w+=""[^""]+""'
    # remove extra lines
    '(\n\r){2,}'
  ]

  replacementPatterns = {
    'Ã¢â‚¬â€œ': "&mdash;"
  }

  removeElements = (html) ->
    foldLeft removalPatterns, html, (text, pattern) ->
      text.replace(new RegExp(pattern, 'g'), '')

  replaceElements = (html) ->
    foldLeft replacementPatterns, html, (text, replacement, pattern) ->
      text.replace(new RegExp(pattern, 'g'), replacement)

  unstyle = (html) ->
    replaceElements(removeElements(html))

  exports.foldLeft = foldLeft
  exports.unstyle = unstyle
)(exports ? this['unstyler'] = {});