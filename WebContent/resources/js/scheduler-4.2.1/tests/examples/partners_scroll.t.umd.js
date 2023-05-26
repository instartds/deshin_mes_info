function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest(function (t) {
  // Sequence fails with very quick (faster than a human can do) click sequence after a delete.
  t.it('Scroll should be synced', function (t) {
    var _bryntum$queryAll = bryntum.queryAll('scheduler'),
        _bryntum$queryAll2 = _slicedToArray(_bryntum$queryAll, 2),
        topScheduler = _bryntum$queryAll2[0],
        bottomScheduler = _bryntum$queryAll2[1];

    t.checkGridSanity(topScheduler);
    t.chain( // Wait for both schedulers to render events
    {
      waitForSelector: '[data-ref=top-scheduler] .b-sch-event'
    }, {
      waitForSelector: '[data-ref=bottom-scheduler] .b-sch-event'
    }, function (next) {
      topScheduler.subGrids.normal.scrollable.x = 100;
      next();
    }, {
      waitFor: function waitFor() {
        return bottomScheduler.subGrids.normal.scrollable.x === 100;
      }
    }, // Allow UI to catch up now that we have shorter waitFors
    {
      waitForAnimationFrame: null
    }, function (next) {
      bottomScheduler.subGrids.normal.scrollable.x = 50;
      next();
    }, {
      waitFor: function waitFor() {
        return topScheduler.subGrids.normal.scrollable.x === 50;
      }
    }, // Allow UI to catch up now that we have shorter waitFors
    {
      waitForAnimationFrame: null
    }, function (next) {
      // Should be able to destroy a partner with no errors
      bottomScheduler.destroy(); // Wait for the scroll event to fire. Nothing should happen
      // if the link has been broken property upon destruction

      t.waitForEvent(topScheduler.subGrids.normal.scrollable, 'scroll', next);
      topScheduler.subGrids.normal.scrollable.x = 100;
    }, function () {
      t.pass('Scrolled correctly');
    });
  });
});