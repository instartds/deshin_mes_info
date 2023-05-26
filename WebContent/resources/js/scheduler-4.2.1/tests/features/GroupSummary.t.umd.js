function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;

  function createScheduler(_x) {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(config) {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              _context20.next = 2;
              return t.getSchedulerAsync(Object.assign({
                viewPreset: 'hourAndDay',
                height: 300,
                features: {
                  group: 'job',
                  groupSummary: {
                    summaries: [{
                      label: 'Count',
                      renderer: function renderer(_ref25) {
                        var events = _ref25.events;
                        return events.length;
                      }
                    }, {
                      label: 'Carpenters',
                      renderer: function renderer(_ref26) {
                        var events = _ref26.events;
                        return events.filter(function (event) {
                          return event.resource.job === 'Carpenter';
                        }).length;
                      }
                    }]
                  },
                  eventTooltip: false,
                  scheduleTooltip: false,
                  eventEdit: false
                },
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 1, 8),
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 200,
                  summaries: [{
                    sum: 'count',
                    label: 'Persons'
                  }]
                }],
                resources: [{
                  id: 1,
                  name: 'Steve',
                  job: 'Carpenter'
                }, {
                  id: 2,
                  name: 'Linda',
                  job: 'Carpenter'
                }, {
                  id: 3,
                  name: 'John',
                  job: 'Painter'
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
                  endDate: new Date(2017, 0, 1, 2)
                }, {
                  id: 3,
                  name: 'Plan',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 1, 3),
                  endDate: new Date(2017, 0, 1, 4)
                }, {
                  id: 4,
                  name: 'Plan',
                  resourceId: 3,
                  startDate: new Date(2017, 0, 1, 3),
                  endDate: new Date(2017, 0, 1, 4)
                }]
              }, config));

            case 2:
              scheduler = _context20.sent;

            case 3:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));
    return _createScheduler.apply(this, arguments);
  }

  t.beforeEach(function () {
    var _scheduler, _scheduler$destroy;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  });
  t.it('Rendering sanity checks', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createScheduler();

            case 2:
              t.contentLike('.b-grid-cell.b-group-title', 'Carpenter (2)');
              t.selectorExists('.b-grid-subgrid-locked .b-grid-summary-label:textEquals(Persons)');
              t.selectorExists('.b-grid-subgrid-locked .b-grid-summary-value:textEquals(2)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(1):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(2):textEquals(22)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(3):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(4):textEquals(11)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(5):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(6):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(7):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(8):textEquals(00)');
              t.hasSameWidth('.b-timeaxis-group-summary > :nth-child(1)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(1)');
              t.hasSameWidth('.b-timeaxis-group-summary > :nth-child(2)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(2)');
              t.hasSameWidth('.b-timeaxis-group-summary > :nth-child(3)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(3)');
              t.hasSameWidth('.b-timeaxis-group-summary > :nth-child(4)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(4)');
              t.hasSameWidth('.b-timeaxis-group-summary > :nth-child(5)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(5)');
              t.hasSameWidth('.b-timeaxis-group-summary > :nth-child(6)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(6)');
              t.hasSameWidth('.b-timeaxis-group-summary > :nth-child(7)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(7)');
              t.hasSameWidth('.b-timeaxis-group-summary > :nth-child(8)', '.b-sch-header-row-main .b-sch-header-timeaxis-cell:nth-child(8)');

            case 21:
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
  t.it('Should refresh after event move', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return createScheduler();

            case 2:
              scheduler.eventStore.first.setStartDate(new Date(2017, 0, 1, 2), true);
              _context2.next = 5;
              return scheduler.project.commitAsync();

            case 5:
              t.selectorExists('.b-timeaxis-group-summary :nth-child(1):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(2):textEquals(11)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(3):textEquals(11)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(4):textEquals(11)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(5):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(6):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(7):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(8):textEquals(00)');

            case 13:
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
  t.it('Should refresh after event remove', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return createScheduler();

            case 2:
              scheduler.eventStore.first.remove();
              _context3.next = 5;
              return scheduler.project.commitAsync();

            case 5:
              t.selectorExists('.b-timeaxis-group-summary :nth-child(1):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(2):textEquals(11)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(3):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(4):textEquals(11)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(5):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(6):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(7):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(8):textEquals(00)');

            case 13:
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
              return createScheduler();

            case 2:
              scheduler.eventStore.first.resourceId = null;
              _context4.next = 5;
              return t.waitForProjectReady();

            case 5:
              t.selectorExists('.b-timeaxis-group-summary :nth-child(1):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(2):textEquals(11)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(3):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(4):textEquals(11)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(5):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(6):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(7):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(8):textEquals(00)');

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
              return createScheduler();

            case 2:
              scheduler.eventStore.filter(function (ev) {
                return ev.name !== 'Plan';
              });
              t.selectorExists('.b-timeaxis-group-summary :nth-child(1):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(2):textEquals(22)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(3):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(4):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(5):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(6):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(7):textEquals(00)');
              t.selectorExists('.b-timeaxis-group-summary :nth-child(8):textEquals(00)');

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
              return createScheduler();

            case 2:
              t.selectorCountIs('.b-group-footer[data-index="3"] .b-timeaxis-tick', 8);
              t.is(document.querySelector('.b-group-footer .b-timeaxis-tick').offsetWidth, document.querySelector('.b-sch-header-row:last-child .b-sch-header-timeaxis-cell').offsetWidth);
              scheduler.setTimeSpan(new Date(2017, 0, 1, 8), new Date(2017, 0, 1, 18));
              t.selectorCountIs('.b-group-footer[data-index="3"] .b-timeaxis-tick', 10);
              scheduler.setTimeSpan(new Date(2017, 0, 1, 8), new Date(2017, 0, 1, 18));
              scheduler.timeAxisViewModel.setTickSize(200);
              t.is(document.querySelector('.b-group-footer .b-timeaxis-tick').offsetWidth, document.querySelector('.b-sch-header-row:last-child .b-sch-header-timeaxis-cell').offsetWidth);

            case 9:
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
  t.it('Should display tooltip', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return createScheduler();

            case 2:
              t.chain({
                moveMouseTo: '.b-timeaxis-group-summary .b-timeaxis-tick:nth-child(2) .b-timeaxis-summary-value'
              }, {
                waitForSelector: '.b-timeaxis-summary-tip'
              }, function () {
                t.selectorExists('.b-timeaxis-summary-tip label:textEquals(Count)', 'Count label found');
                t.selectorExists('.b-timeaxis-summary-tip .b-timeaxis-summary-value:first-of-type:textEquals(2)', 'Correct sum');
                t.selectorExists('.b-timeaxis-summary-tip label:textEquals(Carpenters)', 'Carpenters label found');
                t.selectorExists('.b-timeaxis-summary-tip .b-timeaxis-summary-value:textEquals(2)', 'Correct sum');
              });

            case 3:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref7.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7619

  t.it('Should not create a new event when dblclicking footer', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return createScheduler();

            case 2:
              t.chain({
                dblclick: '.b-timeaxis-group-summary'
              }, function () {
                t.selectorCountIs('.b-sch-event', 4, 'No new event rendered');
                t.is(scheduler.eventStore.count, 4, 'No new event in store');
              });

            case 3:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return createScheduler();

            case 2:
              scheduler.features.groupSummary.disabled = true;
              t.selectorNotExists('.b-timeaxis-group-summary', 'No summary');
              scheduler.features.groupSummary.disabled = false;
              t.selectorExists('.b-timeaxis-group-summary', 'Summary shown');

            case 6:
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
  t.it('Should not show empty meta rows after remove all from the group', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return createScheduler();

            case 2:
              t.chain({
                waitForRowsVisible: scheduler
              }, {
                contextmenu: '.b-grid-cell:textEquals(Steve)'
              }, {
                click: '.b-menu-text:textEquals(Delete)'
              }, {
                contextmenu: '.b-grid-cell:textEquals(Linda)'
              }, {
                click: '.b-menu-text:textEquals(Delete)'
              }, {
                waitForSelectorNotFound: '.b-group-title:textEquals(Carpenter (0))'
              }, function () {
                t.pass('Empty group not shown');
              });

            case 3:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x11) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should support collapsing summary to header if `collapseToHeader` is set', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var _scheduler2, rowManager, expandedRowCount, initialHeight, schedulerSummaryRow, heightAfterExpand;

      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return createScheduler();

            case 2:
              scheduler.features.groupSummary.collapseToHeader = true;
              _scheduler2 = scheduler, rowManager = _scheduler2.rowManager, expandedRowCount = rowManager.rowCount;
              _context11.next = 6;
              return scheduler.scrollable.scrollTo(null, scheduler.scrollable.maxY);

            case 6:
              initialHeight = t.query('[data-id="group-header-Carpenter"]')[0].offsetHeight;
              _context11.next = 9;
              return t.click('[data-id="group-header-Painter"] .b-group-title');

            case 9:
              t.is(rowManager.rowCount, expandedRowCount - 2);
              schedulerSummaryRow = rowManager.lastVisibleRow.elements.normal;
              t.selectorCountIs('.b-timeaxis-tick:nth-child(1) .b-timeaxis-summary-value:nth-child(1):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(1) .b-timeaxis-summary-value:nth-child(2):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(2) .b-timeaxis-summary-value:nth-child(1):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(2) .b-timeaxis-summary-value:nth-child(2):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(3) .b-timeaxis-summary-value:nth-child(1):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(3) .b-timeaxis-summary-value:nth-child(2):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(4) .b-timeaxis-summary-value:nth-child(1):textEquals(1)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(4) .b-timeaxis-summary-value:nth-child(2):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(5) .b-timeaxis-summary-value:nth-child(1):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(5) .b-timeaxis-summary-value:nth-child(2):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(6) .b-timeaxis-summary-value:nth-child(1):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(6) .b-timeaxis-summary-value:nth-child(2):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(7) .b-timeaxis-summary-value:nth-child(1):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(7) .b-timeaxis-summary-value:nth-child(2):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(8) .b-timeaxis-summary-value:nth-child(1):textEquals(0)', schedulerSummaryRow, 1);
              t.selectorCountIs('.b-timeaxis-tick:nth-child(8) .b-timeaxis-summary-value:nth-child(2):textEquals(0)', schedulerSummaryRow, 1); // Collapse Carpenter group

              _context11.next = 29;
              return t.click('[data-id="group-header-Carpenter"] .b-group-title');

            case 29:
              t.is(rowManager.rowCount, 2); // Expand Carpenter group

              _context11.next = 32;
              return t.click('[data-id="group-header-Carpenter"] .b-group-title');

            case 32:
              t.is(rowManager.rowCount, expandedRowCount - 2);
              heightAfterExpand = t.query('[data-id="group-header-Carpenter"]')[0].offsetHeight; // https://github.com/bryntum/support/issues/2756

              t.is(heightAfterExpand, initialHeight, 'Height restored correctly after expanding'); // Data cell in the scheduler part must be empty

              t.selectorCountIs('.b-timeline-subgrid .b-grid-row[data-index="1"] .b-sch-timeaxis-cell:textEquals()', 1);

            case 36:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x12) {
      return _ref11.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1897

  t.it('Should pass group parameters to renderer', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return createScheduler({
                features: {
                  group: 'job',
                  groupSummary: {
                    summaries: [{
                      label: 'Count',
                      renderer: function renderer(_ref13) {
                        var events = _ref13.events,
                            groupRecord = _ref13.groupRecord,
                            groupField = _ref13.groupField,
                            groupValue = _ref13.groupValue;
                        t.ok(groupRecord);
                        t.is(groupField, 'job');
                        t.ok(['Painter', 'Carpenter'].includes(groupValue));
                        return events.length;
                      }
                    }]
                  },
                  eventTooltip: false,
                  scheduleTooltip: false,
                  eventEdit: false
                }
              });

            case 2:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x13) {
      return _ref12.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/70

  t.it('Should align with columns when autoAdjustTimeAxis is set to false', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var middleHeaderCells, groupSummaryCells1, groupSummaryCells2;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return createScheduler({
                viewPreset: 'weekAndMonth',
                autoAdjustTimeAxis: false,
                startDate: new Date(2017, 0, 4),
                endDate: new Date(2017, 0, 9),
                events: [{
                  id: 1,
                  name: 'Work',
                  resourceId: 1,
                  startDate: new Date(2017, 0, 4),
                  endDate: new Date(2017, 0, 5)
                }, {
                  id: 2,
                  name: 'Play',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 5),
                  endDate: new Date(2017, 0, 6)
                }, {
                  id: 3,
                  name: 'Plan',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 6),
                  endDate: new Date(2017, 0, 7)
                }, {
                  id: 4,
                  name: 'Plan',
                  resourceId: 3,
                  startDate: new Date(2017, 0, 7),
                  endDate: new Date(2017, 0, 8)
                }, {
                  id: 5,
                  name: 'Work',
                  resourceId: 3,
                  startDate: new Date(2017, 0, 8),
                  endDate: new Date(2017, 0, 10)
                }],
                features: {
                  group: 'job',
                  groupSummary: {
                    summaries: [{
                      label: 'Count',
                      renderer: function renderer(_ref15) {
                        var events = _ref15.events;
                        return events.length;
                      }
                    }]
                  },
                  eventTooltip: false,
                  scheduleTooltip: false,
                  eventEdit: false
                }
              });

            case 2:
              middleHeaderCells = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell'), groupSummaryCells1 = t.query('.b-group-footer[data-id="group-footer-Carpenter"] .b-timeaxis-group-summary .b-timeaxis-tick'), groupSummaryCells2 = t.query('.b-group-footer[data-id="group-footer-Painter"] .b-timeaxis-group-summary .b-timeaxis-tick');
              groupSummaryCells1.forEach(function (element, idx) {
                t.is(element.offsetWidth, middleHeaderCells[idx].offsetWidth, "\"Carpenter\" group summary column for ".concat(middleHeaderCells[idx].innerText, " aligned"));
              });
              groupSummaryCells2.forEach(function (element, idx) {
                t.is(element.offsetWidth, middleHeaderCells[idx].offsetWidth, "\"Painter\" group summary column for ".concat(middleHeaderCells[idx].innerText, " aligned"));
              });

            case 5:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x14) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('Should not crash when zooming in', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return createScheduler({
                features: {
                  group: 'job',
                  groupSummary: {
                    summaries: [{
                      label: 'Count',
                      renderer: function renderer(_ref17) {
                        var events = _ref17.events;
                        return events.length;
                      }
                    }]
                  }
                }
              });

            case 2:
              scheduler.zoomIn();
              t.pass('Rendered ok');

            case 4:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x15) {
      return _ref16.apply(this, arguments);
    };
  }());
  t.it('Should only redraw affected footers on add', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return createScheduler({
                height: 768 // To avoid scrollbars

              });

            case 2:
              spy = t.spyOn(scheduler.features.groupSummary, 'generateHtml').and.callThrough();
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
              _context15.next = 6;
              return t.waitForProjectReady();

            case 6:
              t.expect(spy).toHaveBeenCalled(2); // Once for name column, once for timeaxis

            case 7:
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
  t.it('Should only redraw affected footers on update', /*#__PURE__*/function () {
    var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return createScheduler({
                height: 768 // To avoid scrollbars

              });

            case 2:
              spy = t.spyOn(scheduler.features.groupSummary, 'generateHtml').and.callThrough();
              scheduler.eventStore.first.duration = 3;
              _context16.next = 6;
              return t.waitForProjectReady();

            case 6:
              t.expect(spy).toHaveBeenCalled(2); // Once for name column, once for timeaxis

            case 7:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x17) {
      return _ref19.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2468

  t.it('Should support refreshing group summary', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      var showFoo;
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              showFoo = true;
              scheduler = t.getScheduler({
                viewPreset: 'hourAndDay',
                height: 300,
                features: {
                  group: 'job',
                  groupSummary: {
                    summaries: [{
                      label: 'Count',
                      renderer: function renderer(_ref21) {
                        var events = _ref21.events;
                        return showFoo ? 'foo' : 'bar';
                      }
                    }, {
                      label: 'Carpenters',
                      renderer: function renderer(_ref22) {
                        var events = _ref22.events;
                        return showFoo ? 'foo' : 'bar';
                      }
                    }]
                  },
                  eventTooltip: false,
                  scheduleTooltip: false,
                  eventEdit: false
                },
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 1, 8),
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 200,
                  summaries: [{
                    sum: 'count',
                    label: 'Persons'
                  }]
                }],
                resources: [{
                  id: 1,
                  name: 'Steve',
                  job: 'Carpenter'
                }, {
                  id: 2,
                  name: 'Linda',
                  job: 'Carpenter'
                }, {
                  id: 3,
                  name: 'John',
                  job: 'Painter'
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
                  endDate: new Date(2017, 0, 1, 2)
                }, {
                  id: 3,
                  name: 'Plan',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 1, 3),
                  endDate: new Date(2017, 0, 1, 4)
                }, {
                  id: 4,
                  name: 'Plan',
                  resourceId: 3,
                  startDate: new Date(2017, 0, 1, 3),
                  endDate: new Date(2017, 0, 1, 4)
                }]
              });
              _context17.next = 4;
              return t.waitForSelector('.b-timeaxis-group-summary .b-timeaxis-summary-value:contains(foo)');

            case 4:
              showFoo = false;
              scheduler.features.groupSummary.refresh();
              _context17.next = 8;
              return t.waitForSelector('.b-timeaxis-group-summary .b-timeaxis-summary-value:contains(bar)');

            case 8:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x18) {
      return _ref20.apply(this, arguments);
    };
  }());
  t.it('Should not crash when filtering with collapsed group', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _context18.next = 2;
              return createScheduler();

            case 2:
              scheduler.features.group.toggleCollapse(scheduler.resourceStore.groupRecords[2]);
              scheduler.eventStore.filter(function (e) {
                return e.name.startsWith('P');
              });
              t.pass('Did not crash');

            case 5:
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
  t.it('Should not crash when filtering with group footer below buffer', /*#__PURE__*/function () {
    var _ref24 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return createScheduler();

            case 2:
              // Make sure footer is below the buffer
              scheduler.resourceStore.insert(3, [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}]);
              scheduler.eventStore.filter(function (e) {
                return e.name.startsWith('P');
              });
              t.pass('Did not crash');

            case 5:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x20) {
      return _ref24.apply(this, arguments);
    };
  }());
});