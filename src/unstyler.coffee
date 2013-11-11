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

  replaceOp = (regex, replacement) -> (text) ->
    text.replace(new RegExp(regex.source, 'mg'), replacement)

  removeOp = (regex) -> (text) ->
    text.replace(new RegExp(regex.source, 'mg'), '')

  # Based on Jeff Atwood's "Cleaning Word's Nasty HTML"
  # http://www.codinghorror.com/blog/2006/01/cleaning-words-nasty-html.html
  operations = [
    # nothing useful comes after </html>
    removeOp(/(?:<\/html>)[\s\S]+/)
    # get rid of unnecessary tag spans (comments and title)
    removeOp(/<!--(\w|\W)+?-->/)
    removeOp(/<title>(\w|\W)+?<\/title>/)
    #extract "mso-list" style to attributes
    #replaceOp(/(\s+style='[^']*)(?:mso-list\:([^;]+));?([^']+')/, " mso-list='$2' $1$3")
    # Get rid of classes and styles
    removeOp(/\s?class=([\'"][^\'"]*[\'"]|\w+)/)
    removeOp(/\s+style='[^']+'/)
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
    # Turn textual ordered list points into real ones
    replaceOp(/(?:<p>\d+\.)(?:&nbsp;\s*)+([^<]+)<\/p>/, "<ol><li>$1</li></ol>")
    # Turn textual unordered list points into real ones
    replaceOp(/(?:<p>[·o])(?:&nbsp;\s*)+([^<]+)<\/p>/, "<ul><li>$1</li></ul>")
    # Replace bold with strong
    replaceOp(/<b>([\s\S]*)<\/b>/, "<strong>$1</strong>")
    # Replace italic with em
    replaceOp(/<i>([\s\S]*)<\/i>/, "<em>$1</em>")
  ]

  unstyle = (html) ->
    foldLeft operations, html, (text, f) ->
      f(text)

  exports.foldLeft = foldLeft
  exports.unstyle = unstyle
)(exports ? this['unstyler'] = {});