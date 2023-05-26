function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

StartTest('All locales should have corresponding to English locale translations', function (t) {
  var _window$bryntum, _window$bryntum$local;

  var testConfig = t.getConfig(),
      // Ignore translations completely (merged with test config from tests/index.js)
  ignoreList = Object.assign({
    Core: [/DateHelper.unitAbbreviations\.\d\.\d/, /DateHelper.unitNames\.\d/, /DateHelper.nonWorkingDays\.\d/, /DateHelper.weekends\.\d/, /.*\.width$/, /.*\.height$/, /.*\.labelWidth$/, /.*\.editorWidth$/]
  }, testConfig.ignoreList),
      // Ignore translations for which En text equals = locale text  (merged with test config from tests/index.js)
  universalList = Object.assign({
    Core: []
  }, testConfig.universalList); // Append De locale from window

  if ((_window$bryntum = window.bryntum) !== null && _window$bryntum !== void 0 && (_window$bryntum$local = _window$bryntum.locales) !== null && _window$bryntum$local !== void 0 && _window$bryntum$local.De) {
    LocaleManager.locales.De = {
      desc: 'Deutsch',
      locale: window.bryntum.locales.De
    };
  } // Locales are loaded in "tests/index.js" file in Localization test group in "alsoPreloads"


  var locales = LocaleManager.locales,
      originalLocale = locales.En;
  originalLocale.localeName = 'En'; // Current locale for test

  var locale, localeName, matches, missing, redundant;

  function isIgnored(list, str) {
    return (list[localeName] || []).concat(list.Common || []).concat(list.Core).some(function (item) {
      return item instanceof RegExp ? item.test(str) : item === str;
    });
  }

  function assertMissing(t, original, asserted) {
    var path = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : '';
    Object.keys(original).forEach(function (key) {
      var currentPath = path ? "".concat(path, ".").concat(key) : key; // if path should not be ignored

      if (!isIgnored(ignoreList, currentPath)) {
        // localization is found
        if (key in asserted && _typeof(asserted[key]) === _typeof(original[key])) {
          // If value type is an object go inside
          if (_typeof(original[key]) === 'object') {
            assertMissing(t, original[key], asserted[key], currentPath);
          } // values are the same then probably it's a copy-paste from asserted locale
          else if (original[key] === asserted[key]) {
              if (!isIgnored(universalList, currentPath)) {
                matches.push(currentPath);
              }
            }
        } // localization not found
        else {
            missing.push(currentPath);
          }
      }
    });
  }

  function assertRedundant(t, master, asserted) {
    var path = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : '';
    Object.keys(asserted).forEach(function (localeKey) {
      var currentPath = path ? "".concat(path, ".").concat(localeKey) : localeKey;

      if (!isIgnored(ignoreList, currentPath)) {
        // if not found in master
        if (!(localeKey in master) || _typeof(master[localeKey]) !== _typeof(asserted[localeKey])) {
          redundant.push(currentPath);
        } else if (_typeof(asserted[localeKey]) === 'object') {
          assertRedundant(t, master[localeKey], asserted[localeKey], currentPath);
        }
      }
    });
  }

  function assertES6(t, asserted) {
    var path = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : '';
    Object.keys(asserted).forEach(function (localeKey) {
      var currentPath = path ? "".concat(path, ".").concat(localeKey) : localeKey,
          value = asserted[localeKey]; // if not found in master

      if (typeof value === 'function') {
        if (/=>/.test(value) || /`/.test(value)) {
          t.fail("ES6 Syntax found in '".concat(currentPath, "' in ").concat(localeName, "."));
        }
      } else if (_typeof(value) === 'object') {
        assertES6(t, value, currentPath);
      }
    });
  } // skip En locale during iterations


  delete locales.En;
  Object.keys(locales).forEach(function (name) {
    t.it("Check ".concat(name, " locale"), function (t) {
      locale = locales[name];
      localeName = name;
      t.ok(locale.desc, "Locale description is specified for ".concat(name)); // We suppose to use ES5 format for De localization

      !testConfig.skipES6Check && locale === locales.De && assertES6(t, locale); // Checking Missing Translations

      matches = [];
      missing = [];
      assertMissing(t, originalLocale.locale, locale.locale);

      if (matches.length > 0) {
        t.fail("The following ".concat(matches.length, " string(s) in ").concat(localeName, " match En locale (add to \"universalList\" to ignore for test in tests/index.js)"));
        matches.forEach(function (str) {
          return t.fail("'".concat(str, "',"));
        });
      }

      if (missing.length > 0) {
        t.fail("The following ".concat(missing.length, " string(s) in ").concat(localeName, " locale are missing (add to \"ignoreList\" to ignore for test in tests/index.js)."));
        missing.forEach(function (str) {
          return t.fail("'".concat(str, "',"));
        });
      } //Checking Redundant Translations


      redundant = [];
      assertRedundant(t, originalLocale.locale, locale.locale);

      if (redundant.length > 0) {
        t.fail("The following ".concat(redundant.length, " string(s) in ").concat(localeName, " are redundant (add to \"ignoreList\" to ignore for test in tests/index.js)"));
        redundant.forEach(function (str) {
          return t.fail("'".concat(str, "',"));
        });
      }
    });
  });
});