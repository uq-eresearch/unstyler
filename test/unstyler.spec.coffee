# :indentSize=2:tabSize=2:noTabs=true:

jsdom = require("jsdom")
expect = require('chai').expect
coffeescript = require("coffee-script")
jqueryFactory = require('jquery')
unstyle = require(__dirname+"/../src/unstyler.coffee").unstyle


describe '.unstyle', () ->
  it 'should leave clean html alone', () ->
    html = '<ul><li>a</li><li>b</li></ul>'
    expect(unstyle(html)).to.equal(html) 