function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest('All translations should be used in the code base', function (t) {
  // NOTE: This test is required to be run against "module" bundle only!
  var testConfig = t.getConfig(),
      classRename = testConfig.classRename,
      ignoreList = testConfig.ignoreList,
      locale = window.bryntum.locales.En,
      bryntumClasses = window.bryntum.classes,
      singletons = ['MessageDialog', 'Ripple'],
      optionalKeys = {
    AnyClass: ['height', 'width', 'labelWidth', 'editorWidth', 'foo'],
    DateHelper: ['formats', 'weekStartDay'],
    PresetManager: ['secondAndMinute', 'minuteAndHour', 'hourAndDay', 'dayAndWeek', 'weekAndDay'],
    Localizable: ['group' // Used in snippet
    ]
  },
      isIgnored = function isIgnored(className, localeKey) {
    return (ignoreList === null || ignoreList === void 0 ? void 0 : ignoreList.includes(className)) || (ignoreList === null || ignoreList === void 0 ? void 0 : ignoreList.includes("".concat(className, ".").concat(localeKey)));
  },
      isOptional = function isOptional(className, localeKey) {
    var _optionalKeys$classNa;

    return optionalKeys.AnyClass.includes(localeKey) || ((_optionalKeys$classNa = optionalKeys[className]) === null || _optionalKeys$classNa === void 0 ? void 0 : _optionalKeys$classNa.includes(localeKey)) || isIgnored(className, localeKey);
  },
      moduleLocale = {},
      moduleLocaleStrict = {},
      moduleLocaleLazy = {},
      buildModuleLocale = function buildModuleLocale() {
    Object.entries(bryntumClasses).forEach(function (_ref) {
      var _ref2 = _slicedToArray(_ref, 2),
          className = _ref2[0],
          cls = _ref2[1];

      var circularReplacer = function circularReplacer() {
        var seen = new WeakSet();
        return function (key, value) {
          if (_typeof(value) === 'object' && value !== null) {
            if (seen.has(value)) {
              return;
            }

            seen.add(value);
          }

          return value;
        };
      },
          reLocale = /L{([\w\d. %(){}-]+)}/gm,
          classText = cls.toString() + cls.constructor.toString() + JSON.stringify(cls.configurable, circularReplacer());

      var m;

      while (m = reLocale.exec(classText)) {
        var classMatch = /((.*?)\.)?(.+)/g.exec(m[1]),
            localeKey = classMatch[3],
            localeClass = classMatch[2],
            setLocale = function setLocale(bundle, cls, key) {
          cls = (classRename === null || classRename === void 0 ? void 0 : classRename[cls]) || cls;
          bundle[cls] = bundle[cls] || {};
          bundle[cls][key] = key;
        }; // By original className


        // By original className
        setLocale(moduleLocale, className, localeKey); // By locale Class if exist

        // By locale Class if exist
        localeClass && setLocale(moduleLocale, localeClass, localeKey); // For checking localization

        // For checking localization
        setLocale(moduleLocaleStrict, localeClass || className, localeKey); // Localization is used from class with no localeClass

        // Localization is used from class with no localeClass
        !localeClass && setLocale(moduleLocaleLazy, className, localeKey);
      }
    });
  },
      checked$names = [],
      check$name = function check$name(t, className) {
    var reason = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : '';

    if (checked$names.includes(className)) {
      return;
    }

    checked$names.push(className);
    var bryntumClass = bryntumClasses[className];

    if (!hasOwnProperty.call(bryntumClass, '$name')) {
      t.fail("".concat(className, " class has no $name() static method. ").concat(reason));
    } else {
      var localeClassName = bryntumClass.$name,
          requiredClassName = (classRename === null || classRename === void 0 ? void 0 : classRename[className]) || className;

      if (localeClassName !== requiredClassName) {
        t.fail("".concat(className, " class has wrong $name() static method result.") + "\nExpected ".concat(requiredClassName, " got ").concat(localeClassName, ".") + '\nCheck exports in "webpack.entry.js" file or put renamed class to test "classRename" config in "tests/index.js"');
      }
    }
  }; // Build locale from classes in module bundle


  buildModuleLocale(); //console.log(JSON.stringify(moduleLocale, null, 2));

  t.it('Check English locale contains valid keys', function (t) {
    var count = 0;
    Object.entries(locale).forEach(function (_ref3) {
      var _ref4 = _slicedToArray(_ref3, 2),
          className = _ref4[0],
          cls = _ref4[1];

      Object.keys(cls).forEach(function (localeKey) {
        count++;

        if (localeKey.includes('.') || localeKey.includes('?')) {
          t.fail("'".concat(localeKey, "' in '").concat(className, "' has \".\" or \"?\" in locale key"));
        }
      });
    });
    t.pass("Checked ".concat(count, " entries"));
  });
  t.it('Check localization is not used in throw new Error()', function (t) {
    var count = 0;
    Object.entries(bryntumClasses).forEach(function (_ref5) {
      var _ref6 = _slicedToArray(_ref5, 2),
          className = _ref6[0],
          cls = _ref6[1];

      var classText = typeof cls === 'function' && cls.toString() || '';
      count++;

      if (/throw new Error\((me|this)\.L\(/.test(classText)) {
        t.fail("\"throw new Error(...)\" should not contain Localization me.L() or this.L() in class \"".concat(className, "\""));
      }
    });
    t.pass("Checked ".concat(count, " entries"));
  });
  t.it('Compare English locale with module bundle', function (t) {
    var count = 0;
    Object.entries(locale).filter(function (_ref7) {
      var _ref8 = _slicedToArray(_ref7, 1),
          className = _ref8[0];

      return !['localeName', 'localeDesc'].includes(className);
    }).forEach(function (_ref9) {
      var _ref10 = _slicedToArray(_ref9, 2),
          className = _ref10[0],
          clsValues = _ref10[1];

      Object.keys(clsValues).forEach(function (localeKey) {
        count++;

        if (!isOptional(className, localeKey)) {
          if (moduleLocale[className]) {
            if (!moduleLocale[className][localeKey]) {
              t.fail("En localization ".concat(className, ".'L{").concat(localeKey, "}' is not found in module bundle."));
            }
          } else {
            t.fail("En localization ".concat(className, ".'L{").concat(localeKey, "}' is not found in in module bundle. Add \"").concat(className, "\" to webpack.entry.js"));
          }
        }
      });
    });
    t.pass("Checked ".concat(count, " entries"));
  });
  t.it('Check localize works for each entry in moduleLocales', function (t) {
    var count = 0;
    Object.entries(moduleLocaleStrict).filter(function (_ref11) {
      var _ref12 = _slicedToArray(_ref11, 1),
          className = _ref12[0];

      return !['Object'].includes(className);
    }).forEach(function (_ref13) {
      var _ref14 = _slicedToArray(_ref13, 2),
          className = _ref14[0],
          clsValues = _ref14[1];

      Object.keys(clsValues).forEach(function (localeKey) {
        count++;

        if (!isOptional(className, localeKey)) {
          var _moduleLocaleLazy$cla;

          var bryntumClass = bryntumClasses[className]; // Check lazy locale loading and $name static method

          if ((_moduleLocaleLazy$cla = moduleLocaleLazy[className]) !== null && _moduleLocaleLazy$cla !== void 0 && _moduleLocaleLazy$cla[localeKey] && bryntumClass) {
            check$name(t, className, "Checking \"".concat(localeKey, "\" key."));
          }

          if (bryntumClass !== null && bryntumClass !== void 0 && bryntumClass.localize) {
            // Class is Localizable
            if (!bryntumClass.localize(localeKey)) {
              t.fail("".concat(className, ".localize('").concat(localeKey, "') failed"));
            }
          } else {
            var _locale$className;

            // Just check key in locale
            if (!((_locale$className = locale[className]) !== null && _locale$className !== void 0 && _locale$className[localeKey])) {
              t.fail("'L{".concat(localeKey, "}' localization is not found for ").concat(className));
            }
          }
        }
      });
    });
    t.pass("Checked ".concat(count, " entries"));
  });
  t.it('Check $name() and type() methods for Widget classes', function (t) {
    Object.entries(bryntumClasses).forEach(function (_ref15) {
      var _cls$prototype;

      var _ref16 = _slicedToArray(_ref15, 2),
          className = _ref16[0],
          cls = _ref16[1];

      // Skip checking singletons
      if (!singletons.includes(className) && (cls.prototype instanceof bryntumClasses.Widget || // eslint-disable-next-line no-prototype-builtins
      (_cls$prototype = cls.prototype) !== null && _cls$prototype !== void 0 && _cls$prototype.isPrototypeOf(bryntumClasses.Widget))) {
        // $name is mandatory for Widget class if there's no `get widgetClass` implementation
        if (!cls.widgetClass) {
          check$name(t, className, "$name is mandatory for Widget child class ".concat(className, "!"));
        } // type() is mandatory for Widget class


        if (!hasOwnProperty.call(cls, 'type')) {
          t.fail("".concat(className, " has no static type() method!"));
        } else if (/[A-Z]/.test(cls.type)) {
          t.fail("".concat(className, " static type() method should be in lower case!"));
        }
      }
    });
    t.pass("Ok");
  });
});