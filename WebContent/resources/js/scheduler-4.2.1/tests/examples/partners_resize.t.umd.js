function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest(function (t) {
  var _bryntum$queryAll = bryntum.queryAll('scheduler'),
      _bryntum$queryAll2 = _slicedToArray(_bryntum$queryAll, 2),
      topScheduler = _bryntum$queryAll2[0],
      bottomScheduler = _bryntum$queryAll2[1],
      _document$querySelect = document.querySelectorAll('.b-grid-body-container .b-grid-splitter:not(.b-hide-display)'),
      _document$querySelect2 = _slicedToArray(_document$querySelect, 2),
      topSplitter = _document$querySelect2[0],
      bottomSplitter = _document$querySelect2[1];

  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-event'
    }, function () {
      t.checkGridSanity(topScheduler); // t.checkGridSanity(bottomScheduler); // Sanity check not working with hidden headers
    });
  });
  t.it('Width + collapsed state should be synced when changed programmatically', function (t) {
    var sameWidth = function sameWidth() {
      return t.samePx(t.rect(topScheduler.subGrids.locked.element).width, t.rect(bottomScheduler.subGrids.locked.element).width);
    },
        checkWidth = function checkWidth(width) {
      return [function (next) {
        t.waitForGridEvents([[topScheduler.subGrids.normal, 'resize'], [bottomScheduler.subGrids.normal, 'resize']], next);
        topScheduler.subGrids.locked.width = width;
      }, {
        waitFor: function waitFor() {
          return bottomScheduler.subGrids.locked.element.offsetWidth === width;
        },
        desc: "Bottom locked grid has correct width ".concat(width)
      }];
    };

    t.chain( // Wait for both schedulers to render events
    {
      waitForSelector: '[data-ref=top-scheduler] .b-sch-event'
    }, {
      waitForSelector: '[data-ref=bottom-scheduler] .b-sch-event'
    }, checkWidth(160), checkWidth(140), /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              return _context.abrupt("return", topScheduler.subGrids.locked.collapse());

            case 1:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })), {
      waitFor: function waitFor() {
        return bottomScheduler.subGrids.locked.collapsed === true;
      },
      desc: "Top locked grid is collapsed"
    }, {
      waitFor: function waitFor() {
        return sameWidth();
      },
      desc: "Locked subgrids are synchronized"
    }, {
      waitFor: 50,
      desc: "Wait for Subgid's afterinternalresize() event to be removed"
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              return _context2.abrupt("return", topScheduler.subGrids.locked.expand());

            case 1:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      waitFor: function waitFor() {
        return bottomScheduler.subGrids.locked.collapsed === false;
      },
      desc: "Bottom locked grid is expanded"
    }, {
      waitFor: function waitFor() {
        return sameWidth();
      },
      desc: "Locked subgrids are synchronized"
    });
  });
  t.it('Width + collapsed state should be synced using splitters', function (t) {
    var checkWidth = function checkWidth(width) {
      return [{
        waitFor: function waitFor() {
          return topScheduler.subGrids.locked.element.offsetWidth === width;
        },
        desc: "Top locked grid has correct width ".concat(width)
      }, {
        waitFor: function waitFor() {
          return bottomScheduler.subGrids.locked.element.offsetWidth === width;
        },
        desc: "Bottom locked grid has correct width ".concat(width)
      }];
    },
        checkCollapse = function checkCollapse(collapsed) {
      return [{
        waitFor: function waitFor() {
          return topScheduler.subGrids.locked.collapsed === collapsed;
        },
        desc: "Top locked grid is ".concat(collapsed ? '' : 'not', " collapsed")
      }, {
        waitFor: function waitFor() {
          return bottomScheduler.subGrids.locked.collapsed === collapsed;
        },
        desc: "Bottom locked grid is ".concat(collapsed ? '' : 'not', " collapsed")
      }];
    };

    t.chain( // Wait for both schedulers to render events
    {
      waitForSelector: '[data-ref=top-scheduler] .b-sch-event'
    }, {
      waitForSelector: '[data-ref=bottom-scheduler] .b-sch-event'
    }, {
      drag: topSplitter,
      by: [20, 0],
      desc: 'Resize top locked grid'
    }, checkWidth(160), {
      drag: bottomSplitter,
      by: [-20, 0],
      offset: [0, '10%'],
      desc: 'Resize bottom locked grid'
    }, checkWidth(140), {
      moveMouseTo: topSplitter
    }, {
      click: '.b-icon-collapse-gridregion',
      desc: 'Collapse bottom locked grid'
    }, checkCollapse(true), {
      moveMouseTo: bottomSplitter
    }, {
      click: '[data-ref="bottom-scheduler"] .b-icon-expand-gridregion',
      desc: 'Expand bottom locked grid'
    }, checkCollapse(false));
  });
  t.it('Should be able to destroy a partner with no errors', function (t) {
    bottomScheduler.destroy();
  });
  t.it('ResizeObserver loop limit exceeded by monkeys', function (t) {
    t.chain({
      rightclick: '.b-grid-splitter'
    }, {
      doubleclick: [308, 395]
    });
  });
});