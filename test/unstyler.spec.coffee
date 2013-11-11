# :indentSize=2:tabSize=2:noTabs=true:

fs = require('fs')
expect = require('chai').expect
coffeescript = require("coffee-script")
foldLeft = require(__dirname+"/../src/unstyler.coffee").foldLeft
unstyle = require(__dirname+"/../src/unstyler.coffee").unstyle

describe '.foldLeft', () ->
  it 'just testing it works', () ->
    expect(foldLeft [1,2,3,4,5], 0, (m, n) -> m + n).to.equal(15)
    expect(foldLeft {1: 7, 3: 4, 5: 3}, 0, (m, v, k) -> m + v - k).to.equal(5)

describe '.unstyle', () ->
  it 'should leave clean html alone', () ->
    html = '<ul><li>a</li><li>b</li></ul>'
    expect(unstyle(html)).to.equal(html)
  
  it 'should unmangle the test document', () ->
    fs.readFile __dirname+'/fixture/word.html', { 
      encoding: 'UTF-8'
    }, (err, html) ->
      throw err if (err)
      expect(unstyle(html)).not.to.equal(html)