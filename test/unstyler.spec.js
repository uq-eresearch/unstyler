(function() {
  var coffeescript, expect, foldLeft, fs, unstyle;

  fs = require('fs');

  expect = require('chai').expect;

  coffeescript = require("coffee-script");

  foldLeft = require(__dirname + "/../src/unstyler.coffee").foldLeft;

  unstyle = require(__dirname + "/../src/unstyler.coffee").unstyle;

  describe('.foldLeft', function() {
    return it('just testing it works', function() {
      expect(foldLeft([1, 2, 3, 4, 5], 0, function(m, n) {
        return m + n;
      })).to.equal(15);
      return expect(foldLeft({
        1: 7,
        3: 4,
        5: 3
      }, 0, function(m, v, k) {
        return m + v - k;
      })).to.equal(5);
    });
  });

  describe('.unstyle', function() {
    it('should leave clean html alone', function() {
      var html;
      html = '<ul><li>a</li><li>b</li></ul>';
      return expect(unstyle(html)).to.equal(html);
    });
    return it('should unmangle the test document', function() {
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
