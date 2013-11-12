# :indentSize=2:tabSize=2:noTabs=true:

fs = require('fs')
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
  
  it 'should unmangle the test document', () ->
    fs.readFile __dirname+'/fixture/word.html', { 
      encoding: 'UTF-8'
    }, (err, html) ->
      throw err if (err)
      unstyledHtml = unstyle(html)
      expect(unstyledHtml).not.to.equal(html)
      # Check bold tags are converted to <strong>
      expect(unstyledHtml).to.contain("<strong>facilisis mollis sem</strong>")
      # Check italic tags are converted to <em>
      expect(unstyledHtml).to.contain("<em>purus vestibulum at</em>")
      # Check that nested bullets are nested properly
      expect(unstyledHtml).to.contain("<ul><li>Vestibulum")
      expect(unstyledHtml).to.contain("<ul><li>Aliquam")
      expect(unstyledHtml).to.contain("varius congue.</li></ul></li>")
      expect(unstyledHtml).to.contain("<li>Interdum")
      expect(unstyledHtml).to.contain("<ul><li>Sed sit amet ornare leo.")
      expect(unstyledHtml).to.contain("egestas urna.</li></ul></li></ul>")