((exports) ->

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

  # Based on Jeff Atwood's "Cleaning Word's Nasty HTML"
  # http://www.codinghorror.com/blog/2006/01/cleaning-words-nasty-html.html
  removalPatterns = [
    # nothing useful comes after </html>
    /(?:<\/html>)[\s\S]+/
    # get rid of unnecessary tag spans (comments and title)
    /<!--(\w|\W)+?-->/
    /<title>(\w|\W)+?<\/title>/
    # Get rid of classes and styles
    /\s?class=([\'"][^\'"]*[\'"]|\w+)/
    /\s+style='[^']+'/
    # Get rid of unnecessary tags
    /<(meta|link|\/?o:|\/?style|\/?div|\/?st\d|\/?head|\/?html|body|\/?body|\/?span|!\[)[^>]*?>/
    # Get rid of empty paragraph tags
    /(<[^>]+>)+&nbsp;(<\/\w+>)+/
    # remove bizarre v: element attached to <img> tag
    /\s+v:\w+=""[^""]+""/
    # remove extra lines
    /(\n\r){2,}/
  ]

  replacementPatterns = [
    [/Ã¢â‚¬â€œ/, "&mdash;"]
    # Turn textual ordered list points into real ones
    [/(?:<p>\d+\.)(?:&nbsp;\s*)+([^<]+)<\/p>/, "<ol><li>$1</li></ol>"]
    # Turn textual unordered list points into real ones
    [/(?:<p>[·o])(?:&nbsp;\s*)+([^<]+)<\/p>/, "<ul><li>$1</li></ul>"]
    # Replace bold with strong
    [/<b>([\s\S]*)<\/b>/, "<strong>$1</strong>"]
    # Replace italic with em
    [/<i>([\s\S]*)<\/i>/, "<em>$1</em>"]
  ]

  removeElements = (html) ->
    foldLeft removalPatterns, html, (text, regex) ->
      text.replace(RegExp(regex.source, 'mg'), '')

  replaceElements = (html) ->
    foldLeft replacementPatterns, html, (text, pair) ->
      [regex, replacement] = pair
      text.replace(new RegExp(regex.source, 'mg'), replacement)

  unstyle = (html) ->
    replaceElements(removeElements(html))

  exports.foldLeft = foldLeft
  exports.unstyle = unstyle
)(exports ? this['unstyler'] = {});