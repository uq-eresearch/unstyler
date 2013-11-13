---
layout: default
title: unstyler.js
---

<h1 class="page-header">
unstyler.js<br/>
<small>Clean up ugly word processor HTML</small>
</h1>

<a class="btn btn-primary" href="https://github.com/uq-eresearch/unstyler/releases/download/v{{site.currentVersion}}/unstyler.min.js">
  <i class="glyphicon glyphicon-download-alt"></i>
  Download ({{site.currentVersion}})
</a>

So, that point in your project comes, and you need to handle copy & paste from
Microsoft Word. At first, it looks great... and then you look at the HTML!

This library is an alternative to using a mature WYSIWYG editor that
incorporates "Paste from Word".

## Demo

{% include example.html %}

## Dependencies

None. :-)

JQuery is used on this page but only to get the content to manipulate.

## How to Use

{% highlight javascript %}
var goodHtml = unstyle(uglyWordHtml);
{% endhighlight %}

You might want to use it with JQuery in a paste handler:

{% highlight javascript %}
$('textarea#text').on('paste', function(e) {
  e.preventDefault();
  var clipboard = e.originalEvent.clipboardData;
  var html = clipboard.getData("text/html") || clipboard.getData("text/plain");
  $(e.target).val(unstyle(html));
});
{% endhighlight %}

Yes, it works for `contentEditable` too:

{% highlight javascript %}
$('div#html').on('paste', function(e) {
  e.preventDefault();
  var clipboard = e.originalEvent.clipboardData;
  var html = clipboard.getData("text/html") || clipboard.getData("text/plain");
  $(e.target).html(unstyle(html));
});
{% endhighlight %}

## Licence

MIT 