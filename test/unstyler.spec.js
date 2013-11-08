(function() {
  var coffeescript, expect, fs, unstyle;

  fs = require('fs');

  expect = require('chai').expect;

  coffeescript = require("coffee-script");

  unstyle = require(__dirname + "/../src/unstyler.coffee").unstyle;

  describe('.unstyle', function() {
    it('should leave clean html alone', function() {
      var html;
      html = '<ul><li>a</li><li>b</li></ul>';
      return expect(unstyle(html)).to.equal(html);
    });
    return it.skip('should unmangle the test document', function() {
      return fs.readFile(__dirname + '/fixture/word.html', {
        encoding: 'UTF-8'
      }, function(err, html) {
        if (err) {
          throw err;
        }
        return expect(unstyle(html)).not.to.equal(html);
      });
    });
  });

}).call(this);
