function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, paperHeight;
  Object.assign(window, {
    DateHelper: DateHelper,
    DomHelper: DomHelper,
    Override: Override,
    DataGenerator: DataGenerator,
    RandomGenerator: RandomGenerator,
    PaperFormat: PaperFormat,
    Rectangle: Rectangle
  });
  t.overrideAjaxHelper();
  t.beforeEach(function () {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });

  function assertContent(_x, _x2) {
    return _assertContent.apply(this, arguments);
  }

  function _assertContent() {
    _assertContent = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t, html) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return new Promise(function (resolve) {
                t.setIframe({
                  height: paperHeight + 50,
                  html: html[0].html,
                  onload: function onload(doc, frame) {
                    t.ok(t.assertHeaderPosition(doc), 'Header is exported ok');
                    t.ok(t.assertFooterPosition(doc), 'Footer is exported ok');
                    t.ok(t.assertRowsExportedWithoutGaps(doc, false, true), 'Rows exported without gaps');
                    t.ok(t.assertTicksExportedWithoutGaps(doc), 'Ticks exported without gaps');
                    t.isExportedTickCount(doc, scheduler.timeAxis.count);
                    t.is(doc.querySelectorAll(scheduler.unreleasedEventSelector).length, scheduler.eventStore.count / 2, 'All events exported');
                    frame.remove();
                    resolve();
                  }
                });
              });

            case 2:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));
    return _assertContent.apply(this, arguments);
  }

  t.it('Sanity', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var _yield$t$createSchedu, html, fileName;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.createSchedulerForExport();

            case 2:
              _yield$t$createSchedu = _context2.sent;
              scheduler = _yield$t$createSchedu.scheduler;
              paperHeight = _yield$t$createSchedu.paperHeight;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                var result, _result$response$requ;

                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        t.diag('Using singlepage export');
                        _context.next = 3;
                        return scheduler.features.pdfExport.export({
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'singlepage',
                          range: 'completeview'
                        });

                      case 3:
                        result = _context.sent;

                        if (!BrowserHelper.isIE11) {
                          t.ok(scheduler.enableEventAnimations, 'Event animations are enabled');
                        }

                        _result$response$requ = result.response.request.body;
                        html = _result$response$requ.html;
                        fileName = _result$response$requ.fileName;
                        t.is(html.length, 1, '1 page is exported');
                        t.is(fileName, 'Scheduler', 'File name is ok');
                        _context.next = 12;
                        return assertContent(t, html);

                      case 12:
                        t.diag('Using multipage export');
                        scheduler.features.pdfExport.on({
                          exportStep: function exportStep() {
                            t.notOk(scheduler.enableEventAnimations, 'Event animations are disabled during export');
                          },
                          thisObj: scheduler,
                          once: true
                        });
                        _context.next = 16;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'multipage',
                          range: 'completeview'
                        });

                      case 16:
                        html = _context.sent;

                        if (!BrowserHelper.isIE11) {
                          t.ok(scheduler.enableEventAnimations, 'Event animations are enabled');
                        }

                        t.is(html.length, 1, '1 page is exported');
                        _context.next = 21;
                        return assertContent(t, html);

                      case 21:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })));

            case 6:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should not trigger scrolls after export promise is resolved', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var _yield$t$createSchedu2;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.createSchedulerForExport();

            case 2:
              _yield$t$createSchedu2 = _context3.sent;
              scheduler = _yield$t$createSchedu2.scheduler;
              paperHeight = _yield$t$createSchedu2.paperHeight;
              _context3.next = 7;
              return scheduler.features.pdfExport.export({
                columns: scheduler.columns.map(function (c) {
                  return c.id;
                })
              });

            case 7:
              t.firesOk({
                observable: scheduler,
                events: {
                  horizontalscroll: 0
                }
              });
              t.firesOk({
                observable: scheduler.timeAxisSubGrid.scrollable,
                events: {
                  scrollEnd: 0
                }
              }); // Timeout is absolutely required here. We need to wait for some time to know that scheduler won't fire anything

              _context3.next = 11;
              return t.waitFor(1000);

            case 11:
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
  t.it('Should export with dependencies disabled', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var _yield$t$createSchedu3, html;

      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.createSchedulerForExport({
                featuresConfig: {
                  dependencies: true
                },
                config: {
                  dependencies: []
                }
              });

            case 2:
              _yield$t$createSchedu3 = _context5.sent;
              scheduler = _yield$t$createSchedu3.scheduler;
              paperHeight = _yield$t$createSchedu3.paperHeight;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        t.diag('Using singlepage export');
                        _context4.next = 3;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'singlepage',
                          range: 'completeview'
                        });

                      case 3:
                        html = _context4.sent;
                        t.is(html.length, 1, '1 page is exported');
                        _context4.next = 7;
                        return assertContent(t, html);

                      case 7:
                        t.diag('Using multipage export');
                        _context4.next = 10;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'multipage',
                          range: 'completeview'
                        });

                      case 10:
                        html = _context4.sent;
                        t.is(html.length, 1, '1 page is exported');
                        _context4.next = 14;
                        return assertContent(t, html);

                      case 14:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })));

            case 6:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should export with column lines disabled', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var _yield$t$createSchedu4, html;

      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.createSchedulerForExport({
                featuresConfig: {
                  columnLines: false
                }
              });

            case 2:
              _yield$t$createSchedu4 = _context7.sent;
              scheduler = _yield$t$createSchedu4.scheduler;
              paperHeight = _yield$t$createSchedu4.paperHeight;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
                return regeneratorRuntime.wrap(function _callee6$(_context6) {
                  while (1) {
                    switch (_context6.prev = _context6.next) {
                      case 0:
                        t.diag('Using singlepage export');
                        _context6.next = 3;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'singlepage',
                          range: 'completeview'
                        });

                      case 3:
                        html = _context6.sent;
                        t.is(html.length, 1, '1 page is exported');
                        _context6.next = 7;
                        return assertContent(t, html);

                      case 7:
                        t.diag('Using multipage export');
                        _context6.next = 10;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'multipage',
                          range: 'completeview'
                        });

                      case 10:
                        html = _context6.sent;
                        t.is(html.length, 1, '1 page is exported');
                        _context6.next = 14;
                        return assertContent(t, html);

                      case 14:
                      case "end":
                        return _context6.stop();
                    }
                  }
                }, _callee6);
              })));

            case 6:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should export when locked grid is wider than first page', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var _yield$t$createSchedu5, html;

      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return t.createSchedulerForExport({
                width: 2000,
                horizontalPages: 2,
                verticalPages: 1
              });

            case 2:
              _yield$t$createSchedu5 = _context9.sent;
              scheduler = _yield$t$createSchedu5.scheduler;
              paperHeight = _yield$t$createSchedu5.paperHeight;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
                return regeneratorRuntime.wrap(function _callee8$(_context8) {
                  while (1) {
                    switch (_context8.prev = _context8.next) {
                      case 0:
                        scheduler.subGrids.locked.width = 1000;
                        _context8.next = 3;
                        return new Promise(function (resolve) {
                          return setTimeout(resolve, 1000);
                        });

                      case 3:
                        t.diag('Using singlepage export');
                        _context8.next = 6;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'multipage',
                          range: ScheduleRange.currentview,
                          keepRegionSizes: {
                            locked: true
                          }
                        });

                      case 6:
                        html = _context8.sent;
                        t.is(html.length, 3, 'Few pages is exported');
                        _context8.next = 10;
                        return new Promise(function (resolve) {
                          t.setIframe({
                            height: paperHeight,
                            html: html[0].html,
                            onload: function onload(doc, frame) {
                              t.ok(t.assertHeaderPosition(doc), 'Header is exported ok');
                              t.ok(t.assertFooterPosition(doc), 'Footer is exported ok');
                              t.ok(t.assertRowsExportedWithoutGaps(doc, false, true), 'Rows exported without gaps');
                              t.isExportedTickCount(doc, 0);
                              t.is(doc.querySelectorAll(scheduler.unreleasedEventSelector).length, 0, 'No events exported');
                              frame.remove();
                              resolve();
                            }
                          });
                        });

                      case 10:
                      case "end":
                        return _context8.stop();
                    }
                  }
                }, _callee8);
              })));

            case 6:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x7) {
      return _ref8.apply(this, arguments);
    };
  }());
});