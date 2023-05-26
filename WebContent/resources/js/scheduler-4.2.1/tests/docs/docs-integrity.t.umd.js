function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

StartTest(function (t) {
  var config = t.getConfig(),
      testTags = function testTags(t, tag, ignoreList) {
    var missingTags = [];
    window.docsJson.classes.forEach(function (cls) {
      var ignoreIndex = ignoreList.indexOf(cls.modulePath);

      if (cls.modulePath.includes("/".concat(tag, "/")) && !cls[tag] && ignoreIndex === -1) {
        missingTags.push(cls.modulePath);
      }

      if (ignoreIndex >= 0) {
        ignoreList.splice(ignoreIndex, 1);
      }
    });

    if (missingTags.length > 0) {
      t.fail("Classes below don't have \"@".concat(tag, "\" docs tag. To ignore add class name to \"tests/index.js\" to \"ignore/").concat(tag, "s\" test config array\n"));
      missingTags.forEach(function (cls) {
        return t.fail("'".concat(cls, "'"));
      });
    }

    if (ignoreList.length > 0) {
      t.fail("Redundant test ignore items in \"tests/index.js\" in \"ignore/".concat(tag, "s\" test config array"));
      ignoreList.forEach(function (cls) {
        return t.fail("'".concat(cls, "'"));
      });
    }

    if (missingTags.length === 0 && ignoreList.length === 0) {
      t.pass("Docs @".concat(tag, " integrity is OK"));
    }
  };

  t.it('Check @feature tags in docs', function (t) {
    testTags(t, 'feature', _toConsumableArray(config.ignore.features));
  });
  t.it('Check @mixin tags in docs', function (t) {
    testTags(t, 'mixin', _toConsumableArray(config.ignore.mixins));
  });
});