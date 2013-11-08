(function() {
  var coffeescript, expect, jqueryFactory, jsdom, unstyle;

  jsdom = require("jsdom");

  expect = require('chai').expect;

  coffeescript = require("coffee-script");

  jqueryFactory = require('jquery');

  unstyle = require(__dirname + "/../src/unstyler.coffee").unstyle;

  describe('.unstyle', function() {
    return it('should leave clean html alone', function() {
      var html;
      html = '<ul><li>a</li><li>b</li></ul>';
      return expect(unstyle(html)).to.equal(html);
    });
  });

}).call(this);
