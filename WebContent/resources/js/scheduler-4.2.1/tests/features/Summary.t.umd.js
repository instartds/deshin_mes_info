function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var mode = t.project.getScriptDescriptor(t).url.includes('horizontal') ? 'horizontal' : 'vertical';
  var scheduler;

  function createSingleSummary(_x) {
    return _createSingleSummary.apply(this, arguments);
  }

  function _createSingleSummary() {
    _createSingleSummary = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(config) {
      var wait,
          _args19 = arguments;
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              wait = _args19.length > 1 && _args19[1] !== undefined ? _args19[1] : true;
              _context19.next = 3;
              return t.getSchedulerAsync(Object.assign({
                viewPreset: 'hourAndDay',
                height: 300,
                mode: mode,
                features: {
                  summary: {
                    renderer: function renderer(_ref25) {
                      var events = _ref25.events;
                      return events.length || '';
                    }
                  }
                },
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 1, 8),
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 200,
                  locked: true,
                  sum: 'count',
                  summaryRenderer: function summaryRenderer(_ref26) {
                    var sum = _ref26.sum;
                    return 'Total: ' + sum;
                  }
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
                  startDate: new Date(2017, 0, 1, 1),
                  endDate: new Date(2017, 0, 1, 2),
                  durationUnit: 'h'
                }, {
                  id: 2,
                  name: 'Play',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 1, 1),
                  endDate: new Date(2017, 0, 1, 2),
                  durationUnit: 'h'
                }, {
                  id: 3,
                  name: 'Plan',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 1, 3),
                  endDate: new Date(2017, 0, 1, 4),
                  durationUnit: 'h'
                }]
              }, config));

            case 3:
              scheduler = _context19.sent;

              if (!wait) {
                _context19.next = 9;
                break;
              }

              _context19.next = 7;
              return t.waitForSelector(scheduler.unreleasedEventSelector);

            case 7:
              _context19.next = 9;
              return t.waitForSelector('.b-sch-summarybar .b-timeaxis-tick');

            case 9:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));
    return _createSingleSummary.apply(this, arguments);
  }

  function createMultiSummary() {
    return _createMultiSummary.apply(this, arguments);
  }

  function _createMultiSummary() {
    _createMultiSummary = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20() {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              _context20.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'hourAndDay',
                height: 300,
                mode: mode,
                features: {
                  summary: {
                    summaries: [{
                      label: 'Count',
                      renderer: function renderer(_ref27) {
                        var events = _ref27.events;
                        return events.length || '';
                      }
                    }, {
                      label: 'Steve',
                      renderer: function renderer(_ref28) {
                        var events = _ref28.events;
                        return events.filter(function (event) {
                          return event.resource.name === 'Steve';
                        }).length || '';
                      }
                    }]
                  }
                },
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 1, 8),
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 200,
                  locked: true,
                  sum: 'count',
                  summaryRenderer: function summaryRenderer(_ref29) {
                    var sum = _ref29.sum;
                    return 'Total: ' + sum;
                  }
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
                  startDate: new Date(2017, 0, 1, 1),
                  endDate: new Date(2017, 0, 1, 2)
                }, {
                  id: 2,
                  name: 'Play',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 1, 1),
                  endDate: new Date(2017, 0, 1, 2)
                }, {
                  id: 3,
                  name: 'Plan',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 1, 3),
                  endDate: new Date(2017, 0, 1, 4)
                }]
              });

            case 2:
              scheduler = _context20.sent;
              _context20.next = 5;
              return t.waitForSelector(scheduler.unreleasedEventSelector);

            case 5:
              _context20.next = 7;
              return t.waitForSelector('.b-sch-summarybar .b-timeaxis-tick');

            case 7:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));
    return _createMultiSummary.apply(this, arguments);
  }

  t.beforeEach(function (t) {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.it('Rendering sanity checks', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var checker;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createSingleSummary();

            case 2:
              checker = scheduler.isHorizontal ? 'hasSameWidth' : 'hasSameHeight';
              t.elementIsEmpty('.b-sch-summarybar :nth-child(1)', '');
              t.contentLike('.b-sch-summarybar :nth-child(2) .b-timeaxis-summary-value', /^2$/);
              t.elementIsEmpty('.b-sch-summarybar :nth-child(3)', '');
              t.contentLike('.b-sch-summarybar :nth-child(4) .b-timeaxis-summary-value', /^1$/);
              t.elementIsEmpty('.b-sch-summarybar :nth-child(5)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(6)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(7)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(8)', '');
              t[checker]('.b-sch-summarybar', scheduler.isHorizontal ? '.b-grid-header.b-sch-timeaxiscolumn' : '.b-verticaltimeaxiscolumn', 'footer el sized as header el');
              t[checker]('.b-sch-summarybar :nth-child(1)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(1)');
              t[checker]('.b-sch-summarybar :nth-child(2)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(2)');
              t[checker]('.b-sch-summarybar :nth-child(3)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(3)');
              t[checker]('.b-sch-summarybar :nth-child(4)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(4)');
              t[checker]('.b-sch-summarybar :nth-child(5)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(5)');
              t[checker]('.b-sch-summarybar :nth-child(6)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(6)');
              t[checker]('.b-sch-summarybar :nth-child(7)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(7)');

            case 19:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should refresh once after data set', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return createSingleSummary();

            case 2:
              spy = t.spyOn(scheduler.features.summary, 'updateScheduleSummaries');
              scheduler.events = [];
              _context2.next = 6;
              return t.waitForProjectReady();

            case 6:
              t.expect(spy).toHaveBeenCalled(1);

            case 7:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Should refresh once after event remove', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return createSingleSummary();

            case 2:
              spy = t.spyOn(scheduler.features.summary, 'updateScheduleSummaries');
              scheduler.eventStore.remove(scheduler.eventStore.last);
              _context3.next = 6;
              return t.waitForProjectReady();

            case 6:
              t.expect(spy).toHaveBeenCalled(1);
              t.elementIsEmpty('.b-sch-summarybar :nth-child(1)', '');
              t.contentLike('.b-sch-summarybar :nth-child(2) .b-timeaxis-summary-value', /^2$/);
              t.elementIsEmpty('.b-sch-summarybar :nth-child(3)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(4)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(5)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(6)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(7)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(8)', '');

            case 15:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x4) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should not count event that has no resource in view', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return createSingleSummary();

            case 2:
              scheduler.eventStore.last.resourceId = null;
              _context4.next = 5;
              return t.waitForProjectReady();

            case 5:
              t.elementIsEmpty('.b-sch-summarybar :nth-child(1)', '');
              t.contentLike('.b-sch-summarybar :nth-child(2) .b-timeaxis-summary-value', /^2$/);
              t.elementIsEmpty('.b-sch-summarybar :nth-child(3)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(4)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(5)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(6)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(7)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(8)', '');

            case 13:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should not count filtered out event ', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return createSingleSummary();

            case 2:
              scheduler.eventStore.filter(function (ev) {
                return ev.name !== 'Plan';
              });
              t.elementIsEmpty('.b-sch-summarybar :nth-child(1)', '');
              t.contentLike('.b-sch-summarybar :nth-child(2) .b-timeaxis-summary-value', /^2$/);
              t.elementIsEmpty('.b-sch-summarybar :nth-child(3)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(4)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(5)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(6)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(7)', '');
              t.elementIsEmpty('.b-sch-summarybar :nth-child(8)', '');

            case 11:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should redraw ticks when time axis view model is changed', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return createSingleSummary();

            case 2:
              t.selectorCountIs('.b-sch-summarybar .b-timeaxis-tick', 8);

              if (scheduler.isHorizontal) {
                t.is(document.querySelector('.b-sch-summarybar .b-timeaxis-tick').offsetWidth, document.querySelector('.b-sch-header-row:last-child .b-sch-header-timeaxis-cell').offsetWidth);
              } else {
                t.is(document.querySelector('.b-sch-summarybar .b-timeaxis-tick').offsetHeight, document.querySelector('.b-sch-header-row-main .b-sch-header-timeaxis-cell').offsetHeight);
              }

              scheduler.setTimeSpan(new Date(2017, 0, 1, 8), new Date(2017, 0, 1, 18));
              t.selectorCountIs('.b-sch-summarybar .b-timeaxis-tick', 10);
              scheduler.setTimeSpan(new Date(2017, 0, 1, 8), new Date(2017, 0, 1, 18));
              scheduler.timeAxisViewModel.setTickSize(200);
              _context6.next = 10;
              return t.waitForAnimations();

            case 10:
              if (scheduler.isHorizontal) {
                t.is(document.querySelector('.b-sch-summarybar .b-timeaxis-tick').offsetWidth, document.querySelector('.b-sch-header-row:last-child .b-sch-header-timeaxis-cell').offsetWidth);
              } else {
                t.is(document.querySelector('.b-sch-summarybar .b-timeaxis-tick').offsetHeight, document.querySelector('.b-sch-header-row-main .b-sch-header-timeaxis-cell').offsetHeight);
              }

            case 11:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Multiple summaries should be supported', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return createMultiSummary();

            case 2:
              t.selectorExists('.b-sch-summarybar :nth-child(2) :nth-child(1):textEquals(2)', 'First sum correct');
              t.selectorExists('.b-sch-summarybar :nth-child(2) :nth-child(2):textEquals(1)', 'Second sum correct');
              t.selectorExists('.b-sch-summarybar :nth-child(4) :nth-child(1):textEquals(1)', 'Third sum correct');
              t.chain({
                moveMouseTo: '.b-sch-summarybar :nth-child(2) :nth-child(1)'
              }, {
                waitForSelector: '.b-timeaxis-summary-tip'
              }, function () {
                t.selectorExists('.b-timeaxis-summary-tip label:textEquals(Count)', 'Count label found');
                t.selectorExists('.b-timeaxis-summary-tip .b-timeaxis-summary-value:first-of-type:textEquals(2)', 'Correct sum');
                t.selectorExists('.b-timeaxis-summary-tip label:textEquals(Steve)', 'Steve label found');
                t.selectorExists('.b-timeaxis-summary-tip .b-timeaxis-summary-value:textEquals(1)', 'Correct sum');
                scheduler.destroy();
                t.selectorNotExists('.b-timeaxis-summary-tip', 'Tooltip cleaned up');
              });

            case 6:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return createSingleSummary();

            case 2:
              scheduler.features.summary.disabled = true;

              if (scheduler.isVertical) {
                t.selectorNotExists('.b-sch-summarybar', 'Summaries hidden');
              } else {
                t.elementIsNotVisible('.b-sch-summarybar', 'Summaries hidden');
              }

              scheduler.features.summary.disabled = false;
              t.elementIsVisible('.b-sch-summarybar', 'Summaries shown');

            case 6:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref8.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/70

  t.it('Should align with columns when autoAdjustTimeAxis is set to false', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var middleHeaderCells, summaryCells;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'weekAndMonth',
                autoAdjustTimeAxis: false,
                features: {
                  summary: {
                    renderer: function renderer(_ref10) {
                      var events = _ref10.events;
                      return events.length || '';
                    }
                  }
                }
              });

            case 2:
              scheduler = _context9.sent;
              middleHeaderCells = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell'), summaryCells = t.query('.b-sch-summarybar .b-timeaxis-tick');
              summaryCells.forEach(function (element, idx) {
                t.is(element.offsetWidth, middleHeaderCells[idx].offsetWidth, "Summary column for ".concat(middleHeaderCells[idx].innerText, " aligned"));
              });

            case 5:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x10) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should refresh once on add', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return createSingleSummary();

            case 2:
              spy = t.spyOn(scheduler.features.summary, 'updateScheduleSummaries').and.callThrough();
              scheduler.eventStore.add([{
                id: 100,
                resourceId: 1,
                startDate: new Date(2017, 0, 1, 1),
                endDate: new Date(2017, 0, 1, 2)
              }, {
                id: 101,
                resourceId: 1,
                startDate: new Date(2017, 0, 1, 1),
                endDate: new Date(2017, 0, 1, 2)
              }]);
              _context10.next = 6;
              return t.waitForProjectReady();

            case 6:
              t.expect(spy).toHaveBeenCalled(1);

            case 7:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x11) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Should refresh once on updates', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return createSingleSummary();

            case 2:
              spy = t.spyOn(scheduler.features.summary, 'updateScheduleSummaries').and.callThrough();
              scheduler.eventStore.first.duration = 3;
              scheduler.eventStore.last.duration = 3;
              _context11.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.expect(spy).toHaveBeenCalled(1);

            case 8:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x12) {
      return _ref12.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2468

  t.it('Should support refreshing summary', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var showFoo;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              showFoo = true;
              _context12.next = 3;
              return t.getSchedulerAsync({
                viewPreset: 'weekAndMonth',
                autoAdjustTimeAxis: false,
                mode: mode,
                features: {
                  summary: {
                    renderer: function renderer(_ref14) {
                      var events = _ref14.events;
                      return showFoo ? 'foo' : 'bar';
                    }
                  }
                },
                data: [{
                  id: 1
                }],
                columns: [{
                  text: 'Name'
                }]
              });

            case 3:
              scheduler = _context12.sent;
              _context12.next = 6;
              return t.waitForSelector('.b-timeaxis-summary-value:contains(foo)');

            case 6:
              showFoo = false;
              scheduler.features.summary.refresh();
              _context12.next = 10;
              return t.waitForSelector('.b-timeaxis-summary-value:contains(bar)');

            case 10:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x13) {
      return _ref13.apply(this, arguments);
    };
  }());
  mode === 'vertical' && t.it('Should hide footer in vertical mode', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return createSingleSummary();

            case 2:
              t.selectorExists('.b-grid-footer-container.b-hidden', 'Footer hidden in vertical mode');

            case 3:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x14) {
      return _ref15.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2631

  mode === 'horizontal' && t.it('Should support summing only selected records', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return createSingleSummary({
                features: {
                  summary: {
                    selectedOnly: true,
                    renderer: function renderer(_ref17) {
                      var events = _ref17.events;
                      return events.length || '';
                    }
                  }
                }
              });

            case 2:
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(1)', '');
              t.contentLike('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(2) .b-timeaxis-summary-value', /^2$/);
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(3)', '');
              t.contentLike('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(4) .b-timeaxis-summary-value', /^1$/);
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(5)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(6)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(7)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(8)', '');
              _context14.next = 12;
              return t.click('.b-grid-cell');

            case 12:
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(1)', '');
              t.contentLike('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(2) .b-timeaxis-summary-value', /^1$/);
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(3)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(4)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(5)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(6)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(7)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(8)', '');
              _context14.next = 22;
              return scheduler.selectAll();

            case 22:
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(1)', '');
              t.contentLike('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(2) .b-timeaxis-summary-value', /^2$/);
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(3)', '');
              t.contentLike('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(4) .b-timeaxis-summary-value', /^1$/);
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(5)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(6)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(7)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(8)', '');
              _context14.next = 32;
              return scheduler.deselectAll();

            case 32:
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(1)', '');
              t.contentLike('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(2) .b-timeaxis-summary-value', /^2$/);
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(3)', '');
              t.contentLike('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(4) .b-timeaxis-summary-value', /^1$/);
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(5)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(6)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(7)', '');
              t.elementIsEmpty('.b-grid-footer.b-sch-timeaxiscolumn :nth-child(8)', '');

            case 40:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x15) {
      return _ref16.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1083

  t.it('Should refresh summary when filtered', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return createSingleSummary({
                viewPreset: 'weekAndMonth',
                autoAdjustTimeAxis: false,
                mode: mode
              });

            case 2:
              scheduler.resourceStore.filter(function (resource) {
                return resource.name === 'Steve';
              });

              if (!(mode === 'horizontal')) {
                _context15.next = 6;
                break;
              }

              _context15.next = 6;
              return t.waitForSelector('.b-grid-footer[data-column=name] .b-grid-summary-value:contains(Total: 1)');

            case 6:
              _context15.next = 8;
              return t.waitForSelector('.b-timeaxis-summary-value:contains(1)');

            case 8:
              scheduler.resourceStore.clearFilters();

              if (!(mode === 'horizontal')) {
                _context15.next = 12;
                break;
              }

              _context15.next = 12;
              return t.waitForSelector('.b-grid-footer[data-column=name] .b-grid-summary-value:contains(Total: 2)');

            case 12:
              _context15.next = 14;
              return t.waitForSelector('.b-timeaxis-summary-value:contains(3)');

            case 14:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x16) {
      return _ref18.apply(this, arguments);
    };
  }());
  t.it('Should refresh summary when feature is enabled after starting disabled', /*#__PURE__*/function () {
    var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return createSingleSummary({
                mode: mode,
                features: {
                  summary: {
                    disabled: true,
                    renderer: function renderer(_ref20) {
                      var events = _ref20.events;
                      return events.length;
                    }
                  }
                }
              }, false);

            case 2:
              if (mode === 'vertical') {
                t.selectorNotExists('.b-timeaxis-summary-value');
                t.selectorNotExists('.b-sch-summarybar');
              } else {
                t.elementIsNotVisible('.b-sch-summarybar');
              }

              scheduler.features.summary.disabled = false;
              _context16.next = 6;
              return t.waitForSelector('.b-sch-summarybar .b-timeaxis-summary-value:contains(1)');

            case 6:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x17) {
      return _ref19.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/3064

  t.it('Should refresh summary after zooming', /*#__PURE__*/function () {
    var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return createSingleSummary({
                mode: mode,
                features: {
                  summary: {
                    renderer: function renderer(_ref22) {
                      var events = _ref22.events;
                      return events.length;
                    }
                  }
                }
              }, false);

            case 2:
              scheduler.features.summary.disabled = false;
              _context17.next = 5;
              return t.waitForSelector('.b-timeaxis-summary-value:contains(1)');

            case 5:
              scheduler.zoomOut();
              _context17.next = 8;
              return t.waitForSelector('.b-timeaxis-summary-value:contains(1)');

            case 8:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x18) {
      return _ref21.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/3125

  t.it('Should correctly filter out events outside of time axis', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _context18.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2021, 6, 1),
                endDate: new Date(2021, 6, 4),
                features: {
                  summary: {
                    renderer: function renderer(_ref24) {
                      var events = _ref24.events;
                      return events.length || '';
                    }
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r2',
                  name: 'Event 1',
                  startDate: '2021-07-02',
                  endDate: '2021-07-03'
                }, {
                  id: 2,
                  resourceId: 'r2',
                  name: 'Event 2',
                  startDate: '2021-07-04',
                  endDate: '2021-07-05'
                }, {
                  id: 3,
                  resourceId: 'r2',
                  name: 'Event 3',
                  startDate: '2021-06-30',
                  endDate: '2021-07-01'
                }]
              });

            case 2:
              scheduler = _context18.sent;
              _context18.next = 5;
              return t.waitForSelector(scheduler.unreleasedEventSelector);

            case 5:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Single event record rendered');
              t.contentLike('.b-sch-summarybar .b-timeaxis-tick:nth-child(2)', '1', 'Summary is ok');
              scheduler.timeAxis.filter(function (t) {
                return t.startDate < new Date(2021, 6, 2) || new Date(2021, 6, 3) <= t.startDate;
              });
              _context18.next = 10;
              return t.waitForSelectorNotFound(scheduler.unreleasedEventSelector);

            case 10:
              document.querySelectorAll('.b-sch-summarybar .b-timeaxis-tick').forEach(function (el) {
                t.is(el.innerHTML, '', 'Summary bar is empty');
              });

            case 11:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x19) {
      return _ref23.apply(this, arguments);
    };
  }());
});