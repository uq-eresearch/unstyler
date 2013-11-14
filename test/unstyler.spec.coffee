# :indentSize=2:tabSize=2:noTabs=true:

fs = require('fs')
iconv = require('iconv-lite')
expect = require('chai').expect
coffeescript = require("coffee-script")
unstyle = require(__dirname+"/../src/unstyler.coffee")

describe '.unstyle.foldLeft', () ->
  it 'should act like normal FP foldLeft', () ->
    foldLeft = unstyle.foldLeft
    expect(foldLeft [1,2,3,4,5], 0, (m, n) -> m + n).to.equal(15)
    expect(foldLeft {1: 7, 3: 4, 5: 3}, 0, (m, v, k) -> m + v - k).to.equal(5)
    
describe '.unstyle.takeWhile', () ->
  it 'should return elements prior to the first that is false', () ->
    expect(unstyle.takeWhile [1,2,3,4,2], (n) -> n < 4).to.deep.equal([1,2,3])

describe '.unstyle', () ->
  it 'should leave clean html alone', () ->
    html = '<ul><li>a</li><li>b</li></ul>'
    expect(unstyle(html)).to.equal(html)
    
  it 'should leave preformatted text alone', () ->
    html = '<ul><li><pre>a\n \nb\n</pre></li></ul>'
    expect(unstyle(html)).to.equal(html)
  
  it 'should unmangle modern Word HTML', () ->
    fs.readFile __dirname+'/fixture/word.html', { 
      encoding: 'UTF-8'
    }, (err, html) ->
      throw err if (err)
      unstyledHtml = unstyle(html)
      expect(unstyledHtml).not.to.equal(html)
      # Check bold tags are converted to <strong>
      expect(unstyledHtml).to.contain("<strong>facilisis mollis sem</strong>")
      # Check italic tags are converted to <em>
      expect(unstyledHtml).to.contain("<em>purus\nvestibulum at</em>")
      # Check that nested bullets are nested properly
      expect(unstyledHtml).to.contain("<ul><li>Vestibulum")
      expect(unstyledHtml).to.contain("<ul><li>Aliquam")
      expect(unstyledHtml).to.contain("varius congue.</li></ul></li>")
      expect(unstyledHtml).to.contain("<li>Interdum")
      expect(unstyledHtml).to.contain("<ul><li>Sed sit amet ornare leo.")
      expect(unstyledHtml).to.contain("egestas urna.</li></ul></li></ul>")

  it 'should unmangle modern Word HTML with 3-tier lists', () ->
    fs.readFile __dirname+'/fixture/word_nested_lists.html', (err, buffer) ->
      throw err if (err)
      html = iconv.decode(buffer, 'windows-1252')
      unstyledHtml = unstyle(html)
      expect(unstyledHtml).not.to.equal(html)
      # Check bullets are stripped properly
      for x in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
        expect(unstyledHtml).to.contain('<li>'+x)
      expect(unstyledHtml).to.contain('<ol><li>A')
      expect(unstyledHtml).to.contain('<ol><li>B')
      expect(unstyledHtml).to.contain('<ol><li>C')
      expect(unstyledHtml).to.contain('<ul><li>J')
      expect(unstyledHtml).to.contain('<ul><li>K')
      expect(unstyledHtml).to.contain('<ul><li>L')

  it 'should unmangle older Word HTML with upper-case tags', () ->
    fs.readFile __dirname+'/fixture/emule.html', { 
      encoding: 'UTF-8'
    }, (err, html) ->
      throw err if (err)
      unstyledHtml = unstyle(html)
      expect(unstyledHtml).not.to.equal(html)
      # Check upper-case tags are gone
      expect(unstyledHtml).not.to.contain("<P")
      expect(unstyledHtml).not.to.contain("<B")
      # Check lists are unstyled with "type" attribute
      expect(unstyledHtml).not.to.contain("<ul type")
      # Check list items are unstyled
      expect(unstyledHtml).not.to.contain("<li style")
      expect(unstyledHtml).to.contain("<li>")
      # Check list items are closed
      # Note: there's still no solution for nested lists
      expect(unstyledHtml).to.match(/flexible\.\s*<\/li>/)
      # Check bold tags are converted to <strong>
      expect(unstyledHtml).not.to.contain("<b>")
      expect(unstyledHtml).to.contain("<strong>")
      # Check breaks are closed
      expect(unstyledHtml).not.to.contain("<br>")
      expect(unstyledHtml).to.contain("<br/>")
      