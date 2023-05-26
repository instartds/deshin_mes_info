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
    scheduler && scheduler.destroy();
  });
  t.it('Should size regions according to the', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var _yield$t$createSchedu;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.createSchedulerForExport();

            case 2:
              _yield$t$createSchedu = _context3.sent;
              scheduler = _yield$t$createSchedu.scheduler;
              paperHeight = _yield$t$createSchedu.paperHeight;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                var splitterWidth, assertColumns, _assertColumns;

                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        _assertColumns = function _assertColumns3() {
                          _assertColumns = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(exporterType) {
                            var html, _yield$t$setIframeAsy, doc, iframe, expectedNormalWidth, lockedGridEl, normalGridEl, schedulerEl;

                            return regeneratorRuntime.wrap(function _callee$(_context) {
                              while (1) {
                                switch (_context.prev = _context.next) {
                                  case 0:
                                    _context.next = 2;
                                    return t.getExportHtml(scheduler, {
                                      columns: [],
                                      exporterType: exporterType
                                    });

                                  case 2:
                                    html = _context.sent;
                                    _context.next = 5;
                                    return t.setIframeAsync({
                                      height: paperHeight,
                                      html: html[0].html
                                    });

                                  case 5:
                                    _yield$t$setIframeAsy = _context.sent;
                                    doc = _yield$t$setIframeAsy.document;
                                    iframe = _yield$t$setIframeAsy.iframe;
                                    expectedNormalWidth = scheduler.timeAxisColumn.width, lockedGridEl = doc.getElementById(scheduler.subGrids.locked.id), normalGridEl = doc.getElementById(scheduler.subGrids.normal.id), schedulerEl = doc.getElementById(scheduler.id);
                                    t.is(lockedGridEl.offsetWidth, 0, 'Locked region width is ok');
                                    t.is(normalGridEl.offsetWidth, expectedNormalWidth, 'Normal region width is ok');
                                    t.is(schedulerEl.offsetWidth, expectedNormalWidth + splitterWidth, 'Scheduler width is ok');
                                    iframe.remove();

                                  case 13:
                                  case "end":
                                    return _context.stop();
                                }
                              }
                            }, _callee);
                          }));
                          return _assertColumns.apply(this, arguments);
                        };

                        assertColumns = function _assertColumns2(_x2) {
                          return _assertColumns.apply(this, arguments);
                        };

                        splitterWidth = scheduler.resolveSplitter('normal').offsetWidth;
                        _context2.next = 5;
                        return assertColumns('singlepage');

                      case 5:
                        _context2.next = 7;
                        return assertColumns('multipage');

                      case 7:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })));

            case 6:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should keep region size', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var _yield$t$createSchedu2, normalScrollWidth, lockedScrollWidth, splitterWidth, assertExport, _assertExport;

      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _assertExport = function _assertExport3() {
                _assertExport = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(config, locked, normal, total) {
                  var pages, _yield$t$setIframeAsy2, document, iframe, lockedEl, normalEl, gridEl;

                  return regeneratorRuntime.wrap(function _callee4$(_context4) {
                    while (1) {
                      switch (_context4.prev = _context4.next) {
                        case 0:
                          _context4.next = 2;
                          return t.getExportHtml(scheduler, config);

                        case 2:
                          pages = _context4.sent;
                          _context4.next = 5;
                          return t.setIframeAsync({
                            html: pages[0].html,
                            height: paperHeight
                          });

                        case 5:
                          _yield$t$setIframeAsy2 = _context4.sent;
                          document = _yield$t$setIframeAsy2.document;
                          iframe = _yield$t$setIframeAsy2.iframe;
                          lockedEl = document.querySelector('.b-grid-subgrid-locked');
                          normalEl = document.querySelector('.b-grid-subgrid-normal');
                          gridEl = document.querySelector('.b-gridbase');
                          t.is(lockedEl.offsetWidth, locked, 'Locked region width is ok');
                          t.is(normalEl.offsetWidth, normal, 'Normal region width is ok');
                          t.is(gridEl.offsetWidth, total, 'Scheduler width is ok');
                          iframe.remove();

                        case 15:
                        case "end":
                          return _context4.stop();
                      }
                    }
                  }, _callee4);
                }));
                return _assertExport.apply(this, arguments);
              };

              assertExport = function _assertExport2(_x4, _x5, _x6, _x7) {
                return _assertExport.apply(this, arguments);
              };

              _context5.next = 4;
              return t.createSchedulerForExport({
                config: {
                  subGridConfigs: {
                    locked: {
                      width: 150
                    }
                  }
                },
                width: 400
              });

            case 4:
              _yield$t$createSchedu2 = _context5.sent;
              scheduler = _yield$t$createSchedu2.scheduler;
              paperHeight = _yield$t$createSchedu2.paperHeight;
              normalScrollWidth = scheduler.timeAxisSubGrid.scrollable.scrollWidth, lockedScrollWidth = scheduler.subGrids.locked.scrollable.scrollWidth, splitterWidth = 5;
              _context5.next = 10;
              return assertExport({
                exporterType: 'singlepage',
                keepRegionSizes: {
                  locked: true
                }
              }, 150, normalScrollWidth, 150 + splitterWidth + normalScrollWidth);

            case 10:
              _context5.next = 12;
              return assertExport({
                exporterType: 'singlepage',
                keepRegionSizes: {
                  normal: true
                }
              }, lockedScrollWidth, scheduler.timeAxisSubGrid.width, lockedScrollWidth + splitterWidth + scheduler.timeAxisSubGrid.width);

            case 12:
              _context5.next = 14;
              return assertExport({
                exporterType: 'multipage',
                keepRegionSizes: {
                  locked: true
                }
              }, 150, normalScrollWidth, 150 + splitterWidth + normalScrollWidth);

            case 14:
              _context5.next = 16;
              return assertExport({
                exporterType: 'multipage',
                keepRegionSizes: {
                  normal: true
                }
              }, lockedScrollWidth, scheduler.timeAxisSubGrid.width, lockedScrollWidth + splitterWidth + scheduler.timeAxisSubGrid.width);

            case 16:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should export with collapsed regions', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var assertRegions, _yield$t$createSchedu3, pages, _yield$t$setIframeAsy3, document, iframe, _yield$t$setIframeAsy4;

      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              assertRegions = function _assertRegions(doc, locked, normal) {
                var splitterEl = doc.querySelector('.b-grid-splitter'),
                    lockedEl = doc.querySelector('.b-grid-subgrid-locked'),
                    normalEl = doc.querySelector('.b-grid-subgrid-normal');

                if (locked === 'collapsed') {
                  t.ok(lockedEl.className.match(/b-grid-subgrid-collapsed/), 'Locked subgrid is collapsed');
                } else {
                  t.isApprox(lockedEl.offsetWidth, locked, 1, 'Locked subgrid width is ok');
                }

                if (normal === 'collapsed') {
                  t.ok(normalEl.className.match(/b-grid-subgrid-collapsed/), 'Locked subgrid is collapsed');
                } else {
                  t.isApprox(normalEl.offsetWidth, normal, 1, 'Normal subgrid width is ok');
                }

                t.is(splitterEl.offsetWidth, 10, 'Splitter width is ok');
              };

              _context6.next = 3;
              return t.createSchedulerForExport();

            case 3:
              _yield$t$createSchedu3 = _context6.sent;
              scheduler = _yield$t$createSchedu3.scheduler;
              paperHeight = _yield$t$createSchedu3.paperHeight;
              _context6.next = 8;
              return Promise.all([scheduler.subGrids.locked.collapse(), scheduler.await('timelineViewportResize', {
                checkLog: false
              }), t.waitForAnimationFrame()]);

            case 8:
              _context6.next = 10;
              return t.getExportHtml(scheduler, {
                exporterType: 'singlepage'
              });

            case 10:
              pages = _context6.sent;
              _context6.next = 13;
              return t.setIframeAsync({
                height: 1123,
                html: pages[0].html
              });

            case 13:
              _yield$t$setIframeAsy3 = _context6.sent;
              document = _yield$t$setIframeAsy3.document;
              iframe = _yield$t$setIframeAsy3.iframe;
              assertRegions(document, 'collapsed', scheduler.timeAxisSubGrid.element.offsetWidth);
              iframe.remove();
              _context6.next = 20;
              return scheduler.subGrids.normal.collapse();

            case 20:
              _context6.next = 22;
              return t.getExportHtml(scheduler, {
                exporterType: 'singlepage',
                keepRegionSizes: {
                  locked: true
                }
              });

            case 22:
              pages = _context6.sent;
              _context6.next = 25;
              return t.setIframeAsync({
                height: 1123,
                html: pages[0].html
              });

            case 25:
              _yield$t$setIframeAsy4 = _context6.sent;
              document = _yield$t$setIframeAsy4.document;
              iframe = _yield$t$setIframeAsy4.iframe;
              assertRegions(document, scheduler.subGrids.locked.element.offsetWidth, 'collapsed');
              iframe.remove();

            case 30:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x8) {
      return _ref4.apply(this, arguments);
    };
  }()); // This is more of a sanity test that narrow scheduling view works and doesn't throw. There is no strong opinion on
  // this behavior.

  t.it('Should export with narrow time axis subgrid', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var _yield$t$createSchedu4, pages, _yield$t$setIframeAsy5, document, iframe;

      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.createSchedulerForExport();

            case 2:
              _yield$t$createSchedu4 = _context7.sent;
              scheduler = _yield$t$createSchedu4.scheduler;
              paperHeight = _yield$t$createSchedu4.paperHeight;
              scheduler.timeAxisSubGrid.width = 3;
              _context7.next = 8;
              return t.getExportHtml(scheduler, {
                exporterType: 'singlepage',
                keepRegionSizes: {
                  normal: true
                }
              });

            case 8:
              pages = _context7.sent;
              _context7.next = 11;
              return t.setIframeAsync({
                height: paperHeight,
                html: pages[0].html
              });

            case 11:
              _yield$t$setIframeAsy5 = _context7.sent;
              document = _yield$t$setIframeAsy5.document;
              iframe = _yield$t$setIframeAsy5.iframe;
              t.ok(t.assertRowsExportedWithoutGaps(document, false, true), 'Rows exported without gaps');
              t.ok(t.assertTicksExportedWithoutGaps(document), 'Ticks exported without gaps');
              t.is(document.querySelectorAll('.b-grid-row').length, scheduler.resourceStore.count * 2, 'All resources exported');
              t.isExportedTickCount(document, scheduler.timeAxis.count);
              t.is(document.querySelectorAll('.b-sch-event').length, scheduler.eventStore.count / 2, 'Event count is correct');
              t.is(document.querySelector('.b-grid-subgrid-normal').offsetWidth, 3, 'Normal grid width is ok');
              iframe.remove();

            case 21:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x9) {
      return _ref5.apply(this, arguments);
    };
  }());
});