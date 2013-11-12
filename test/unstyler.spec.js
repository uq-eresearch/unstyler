(function() {
  var coffeescript, expect, foldLeft, fs, unstyle;

  fs = require('fs');

  expect = require('chai').expect;

  coffeescript = require("coffee-script");

  foldLeft = require(__dirname + "/../src/unstyler.coffee").foldLeft;

  unstyle = require(__dirname + "/../src/unstyler.coffee");

  describe('.unstyle.foldLeft', function() {
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
        var unstyledHtml;
        if (err) {
          throw err;
        }
        unstyledHtml = unstyle(html);
        expect(unstyledHtml).not.to.equal(html);
        expect(unstyledHtml).to.contain("<strong>facilisis mollis sem</strong>");
        expect(unstyledHtml).to.contain("<em>purus vestibulum at</em>");
        expect(unstyledHtml).to.contain("<ul><li>Vestibulum");
        expect(unstyledHtml).to.contain("<ul><li>Aliquam");
        expect(unstyledHtml).to.contain("varius congue.</li></ul></li>");
        expect(unstyledHtml).to.contain("<li>Interdum");
        expect(unstyledHtml).to.contain("<ul><li>Sed sit amet ornare leo.");
        return expect(unstyledHtml).to.contain("egestas urna.</li></ul></li></ul>");
      });
    });
  });

}).call(this);
