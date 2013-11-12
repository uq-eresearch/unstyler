# Unstyler.js

[![Build Status](https://travis-ci.org/tjdett/unstyler.png?branch=master)](https://travis-ci.org/tjdett/unstyler)

So, that point in your project comes, and you need to handle copy & paste from
Microsoft Word. At first, it looks great... and then you look at the HTML!

This library is an alternative to using a mature WYSIWYG editor that
incorporates "Paste from Word".

## Dependencies

None. :-)

## How to Use

```javascript
var goodHtml = unstyle(uglyWordHtml);
```

You might want to use it with JQuery in a paste handler:

```javascript
$('textarea#text').on('paste', function(e) {
  e.preventDefault();
  var clipboard = e.originalEvent.clipboardData;
  var html = clipboard.getData("text/html") || clipboard.getData("text/plain");
  $(e.target).val(unstyle(html));
});
```

Yes, it works for `contentEditable` too:

```javascript
$('div#html').on('paste', function(e) {
  e.preventDefault();
  var clipboard = e.originalEvent.clipboardData;
  var html = clipboard.getData("text/html") || clipboard.getData("text/plain");
  $(e.target).html(unstyle(html));
});
```



