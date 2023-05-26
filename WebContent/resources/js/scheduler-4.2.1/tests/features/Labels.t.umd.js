function _createForOfIteratorHelper(o, allowArrayLike) { var it = typeof Symbol !== "undefined" && o[Symbol.iterator] || o["@@iterator"]; if (!it) { if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") { if (it) o = it; var i = 0; var F = function F() {}; return { s: F, n: function n() { if (i >= o.length) return { done: true }; return { done: false, value: o[i++] }; }, e: function e(_e) { throw _e; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var normalCompletion = true, didErr = false, err; return { s: function s() { it = it.call(o); }, n: function n() { var step = it.next(); normalCompletion = step.done; return step; }, e: function e(_e2) { didErr = true; err = _e2; }, f: function f() { try { if (!normalCompletion && it.return != null) it.return(); } finally { if (didErr) throw err; } } }; }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;

  function createScheduler(_x, _x2) {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(labelConfig, schedulerConfig) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              scheduler && scheduler.destroy();
              scheduler = new Scheduler(Object.assign({
                features: {
                  labels: labelConfig,
                  eventTooltip: false,
                  eventDrag: {
                    showTooltip: false
                  }
                },
                columns: [{
                  field: 'name',
                  width: 150
                }],
                resources: [{
                  id: 1,
                  name: 'Steve',
                  job: 'Carpenter'
                }, {
                  id: 2,
                  name: 'John',
                  job: 'Contractor'
                }],
                events: [{
                  id: 1,
                  name: 'Work',
                  resourceId: 1,
                  startDate: new Date(2017, 0, 1),
                  endDate: new Date(2017, 0, 5)
                }, {
                  id: 2,
                  name: 'Plan',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 2),
                  endDate: new Date(2017, 0, 6)
                }],
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 6),
                barMargin: 0,
                rowHeight: 55,
                appendTo: document.body,
                enableEventAnimations: false
              }, schedulerConfig));
              _context10.next = 4;
              return t.waitForProjectReady();

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));
    return _createScheduler.apply(this, arguments);
  }

  function checkLabels(t, expected) {
    var msg = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : '';
    var labels = document.querySelectorAll('.b-sch-label'); // TODO: guess there is no guarantee that browsers deliver elements in querySelectorAll in same order, might need to come up with more reliable checking

    t.is(expected.length, expected.length, 'Correct number of labels' + msg);

    for (var i = 0; i < labels.length; i++) {
      t.is(labels[i].innerHTML, expected[i], 'Correct label ' + expected[i]);
    }

    if (!scheduler.features.labels.top) {
      t.is(document.querySelectorAll('.b-sch-label-top').length, 0, 'No top labels found');
    }

    if (!scheduler.features.labels.bottom) {
      t.is(document.querySelectorAll('.b-sch-label-bottom').length, 0, 'No bottom labels found');
    }
  }

  t.it('Using fields', function (t) {
    createScheduler({
      top: 'name',
      bottom: 'job'
    });
    checkLabels(t, ['Work', 'Carpenter', 'Plan', 'Contractor']);
  });
  t.it('Using renderers', function (t) {
    createScheduler({
      top: function top(_ref) {
        var resourceRecord = _ref.resourceRecord;
        return resourceRecord.name;
      },
      bottom: function bottom(_ref2) {
        var eventRecord = _ref2.eventRecord;
        return eventRecord.name;
      }
    });
    checkLabels(t, ['Steve', 'Work', 'John', 'Plan']);
  });
  t.it('Only top or bottom', function (t) {
    createScheduler({
      top: 'name'
    });
    checkLabels(t, ['Work', 'Plan'], ' on top');
    createScheduler({
      bottom: 'job'
    });
    checkLabels(t, ['Carpenter', 'Contractor'], ' on bottom');
  });
  t.it('Drag', function (t) {
    createScheduler({
      top: 'name'
    });
    t.chain({
      drag: '.b-sch-event',
      by: [100, 0]
    }, function (next) {
      checkLabels(t, ['Work', 'Plan'], 'In same order');
      next();
    });
  });
  t.it('Resize', function (t) {
    createScheduler({
      top: 'name'
    });
    t.chain({
      drag: '.b-sch-event',
      by: [50, 0],
      offset: ['100%-2', 10]
    }, function (next) {
      checkLabels(t, ['Work', 'Plan'], ' on top after resize');
      next();
    });
  });
  t.it('Layout', function (t) {
    createScheduler({
      top: 'name',
      bottom: 'job'
    });
    var wrapperEls = document.querySelectorAll('.b-sch-event-wrap');

    var _iterator = _createForOfIteratorHelper(wrapperEls),
        _step;

    try {
      for (_iterator.s(); !(_step = _iterator.n()).done;) {
        var wrapperEl = _step.value;
        var topLabel = wrapperEl.querySelector('.b-sch-label-top'),
            bottomLabel = wrapperEl.querySelector('.b-sch-label-bottom'),
            event = wrapperEl.querySelector('.b-sch-event'),
            topRect = topLabel.getBoundingClientRect(),
            bottomRect = bottomLabel.getBoundingClientRect(),
            eventRect = event.getBoundingClientRect();
        t.isLess(topRect.bottom, eventRect.top, 'Top label above event');
        t.isGreater(bottomRect.top, eventRect.bottom, 'Bottom label below event');
      }
    } catch (err) {
      _iterator.e(err);
    } finally {
      _iterator.f();
    }
  });
  t.it('Editing terminating with ENTER', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var event, duration;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createScheduler({
                right: {
                  field: 'fullDuration',
                  editor: {
                    type: 'durationfield',
                    minWidth: 110
                  },
                  renderer: function renderer(_ref4) {
                    var eventRecord = _ref4.eventRecord;
                    return eventRecord.duration + ' ' + DateHelper.getLocalizedNameOfUnit(eventRecord.durationUnit, eventRecord.duration !== 1);
                  }
                }
              });

            case 2:
              event = scheduler.eventStore.findByField('name', 'Work')[0].data, duration = event.duration;
              t.chain({
                dblclick: "[data-event-id=".concat(event.id, "] .b-sch-label-right")
              }, // Wait to focus the label feature's right editor
              {
                waitFor: function waitFor() {
                  return document.activeElement === scheduler.features.labels.right.editor.inputField.input;
                }
              }, // Spin up
              function (next) {
                t.click(scheduler.features.labels.right.editor.inputField.triggers.spin.upButton, next);
              }, {
                type: '[ENTER]'
              }, // Value should have changed
              function () {
                t.is(event.duration, duration + 1);
              });

            case 4:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Editing, typing new duration value with magnitude only, terminating with ENTER', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var event, duration;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return createScheduler({
                right: {
                  field: 'fullDuration',
                  editor: {
                    type: 'durationfield',
                    minWidth: 110
                  },
                  renderer: function renderer(_ref6) {
                    var eventRecord = _ref6.eventRecord;
                    return eventRecord.duration + ' ' + DateHelper.getLocalizedNameOfUnit(eventRecord.durationUnit, eventRecord.duration !== 1);
                  }
                }
              });

            case 2:
              event = scheduler.eventStore.findByField('name', 'Work')[0].data, duration = event.duration;
              t.chain({
                dblclick: "[data-event-id=".concat(event.id, "] .b-sch-label-right")
              }, // Wait to focus the label feature's right editor
              {
                waitFor: function waitFor() {
                  return document.activeElement === scheduler.features.labels.right.editor.inputField.input;
                }
              }, // Focus field
              function (next) {
                t.click(scheduler.features.labels.right.editor.inputField.input, next);
              }, // Typing duration only should use current unit as default
              {
                type: "".concat(duration + 1, "[ENTER]"),
                clearExisting: true
              }, // Value should have changed
              function () {
                t.is(event.duration, duration + 1);
              });

            case 4:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Editing terminating with focusout, with blurAction default, which is cancel', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var event, duration;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return createScheduler({
                right: {
                  field: 'fullDuration',
                  editor: {
                    type: 'durationfield',
                    minWidth: 110
                  },
                  renderer: function renderer(_ref8) {
                    var eventRecord = _ref8.eventRecord;
                    return eventRecord.duration + ' ' + DateHelper.getLocalizedNameOfUnit(eventRecord.durationUnit, eventRecord.duration !== 1);
                  }
                }
              });

            case 2:
              event = scheduler.eventStore.findByField('name', 'Work')[0].data, duration = event.duration;
              t.chain({
                dblclick: "[data-event-id=".concat(event.id, "] .b-sch-label-right")
              }, // Wait to focus the label feature's right editor
              {
                waitFor: function waitFor() {
                  return document.activeElement === scheduler.features.labels.right.editor.inputField.input;
                }
              }, // Spin up
              function (next) {
                t.click(scheduler.features.labels.right.editor.inputField.triggers.spin.upButton, next);
              }, function (next) {
                scheduler.focus();
                next();
              }, // Wait to focus the label feature's right editor to disappear
              {
                waitFor: function waitFor() {
                  return !scheduler.features.labels.right.editor.isVisible;
                }
              }, // Value should not have changed
              function () {
                t.is(event.duration, duration);
              });

            case 4:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x5) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Editing terminating with focusout, with blurAction: \'complete\'', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var event, duration;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return createScheduler({
                blurAction: 'complete',
                right: {
                  field: 'fullDuration',
                  editor: {
                    type: 'durationfield',
                    minWidth: 110
                  },
                  renderer: function renderer(_ref10) {
                    var eventRecord = _ref10.eventRecord;
                    return eventRecord.duration + ' ' + DateHelper.getLocalizedNameOfUnit(eventRecord.durationUnit, eventRecord.duration !== 1);
                  }
                }
              });

            case 2:
              event = scheduler.eventStore.findByField('name', 'Work')[0].data, duration = event.duration;
              t.chain({
                dblclick: "[data-event-id=".concat(event.id, "] .b-sch-label-right")
              }, // Wait to focus the label feature's right editor
              {
                waitFor: function waitFor() {
                  return document.activeElement === scheduler.features.labels.right.editor.inputField.input;
                }
              }, // Spin up
              function (next) {
                t.click(scheduler.features.labels.right.editor.inputField.triggers.spin.upButton, next);
              }, function (next) {
                scheduler.focus();
                next();
              }, // Wait to focus the label feature's right editor to disappear
              {
                waitFor: function waitFor() {
                  return !scheduler.features.labels.right.editor.isVisible;
                }
              },
              /*#__PURE__*/
              // Value should have changed
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        _context4.next = 2;
                        return scheduler.project.commitAsync();

                      case 2:
                        t.is(event.duration, duration + 1);

                      case 3:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })));

            case 4:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Event created from DragCreate', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return createScheduler({
                top: 'name',
                bottom: 'job'
              }, {
                events: []
              });

            case 2:
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [20, 80],
                by: [50, 0]
              }, {
                type: 'New event[ENTER]'
              }, function () {
                t.elementIsVisible(".b-sch-label-top:contains(New event)");
                t.elementIsVisible(".b-sch-label-bottom:contains(Contractor)");
              });

            case 3:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return createScheduler({
                top: 'name'
              });

            case 2:
              t.selectorExists('.b-sch-label-top', 'Labels found when enabled');
              scheduler.features.labels.disabled = true;
              t.selectorNotExists('.b-sch-label-top', 'No labels found when disabled');
              scheduler.features.labels.disabled = false;
              t.selectorExists('.b-sch-label-top', 'Labels found when enabled');

            case 7:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref13.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2147

  t.it('Layout mode, left labels', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return createScheduler({
                labelLayoutMode: 'estimate',
                left: {
                  renderer: function renderer(_ref15) {
                    var eventRecord = _ref15.eventRecord;
                    return "<i></i><u>".concat(eventRecord.name, "</u>");
                  }
                }
              }, {
                events: [{
                  id: 1,
                  name: 'Working hard',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 4, 12),
                  endDate: new Date(2017, 0, 7)
                }, {
                  id: 2,
                  name: 'Plan',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 2),
                  endDate: new Date(2017, 0, 4)
                }]
              });

            case 2:
              t.isApprox(t.rect('.b-grid-row[data-id="2"]').height, 111, 'Stacked with estimate');
              scheduler.features.labels.labelLayoutMode = 'measure';
              t.isApprox(t.rect('.b-grid-row[data-id="2"]').height, 111, 'Stacked with measure'); // Shorter string, wont be stacked when measuring but still stacked when estimating

              scheduler.eventStore.first.name = 'Working';
              t.isApprox(t.rect('.b-grid-row[data-id="2"]').height, 56, 'Not stacked with measure');
              scheduler.features.labels.labelLayoutMode = 'estimate';
              t.isApprox(t.rect('.b-grid-row[data-id="2"]').height, 111, 'Stacked with estimate'); // Even shorter string, not stacked at all (also makes sure html is not part of estimate)

              scheduler.eventStore.first.name = 'Worker';
              t.isApprox(t.rect('.b-grid-row[data-id="2"]').height, 56, 'Not stacked with estimate');

            case 11:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref14.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2147

  t.it('Layout mode, right labels', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return createScheduler({
                labelLayoutMode: 'estimate',
                right: 'name'
              }, {
                events: [{
                  id: 1,
                  name: 'Plan',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 4, 12),
                  endDate: new Date(2017, 0, 7)
                }, {
                  id: 2,
                  name: 'Working hard',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 2),
                  endDate: new Date(2017, 0, 4)
                }]
              });

            case 2:
              t.isApprox(t.rect('.b-grid-row[data-id="2"]').height, 111, 'Stacked with estimate');
              scheduler.features.labels.labelLayoutMode = 'measure';
              t.isApprox(t.rect('.b-grid-row[data-id="2"]').height, 111, 'Stacked with measure');
              scheduler.eventStore.last.name = 'Working';
              t.isApprox(t.rect('.b-grid-row[data-id="2"]').height, 56, 'Not stacked with measure');
              scheduler.features.labels.labelLayoutMode = 'estimate';
              t.isApprox(t.rect('.b-grid-row[data-id="2"]').height, 111, 'Stacked with estimate');

            case 9:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x10) {
      return _ref16.apply(this, arguments);
    };
  }());
});