# :indentSize=2:tabSize=2:noTabs=true:

fs = require('fs')
expect = require('chai').expect
coffeescript = require("coffee-script")
unstyle = require(__dirname+"/../src/unstyler.coffee").unstyle

describe '.unstyle', () ->
  it 'should leave clean html alone', () ->
    html = '<ul><li>a</li><li>b</li></ul>'
    expect(unstyle(html)).to.equal(html)
  
  it.skip 'should unmangle the test document', () ->
    fs.readFile __dirname+'/fixture/word.html', { 
      encoding: 'UTF-8'
    }, (err, html) ->
      throw err if (err)
      expect(unstyle(html)).not.to.equal(html) 