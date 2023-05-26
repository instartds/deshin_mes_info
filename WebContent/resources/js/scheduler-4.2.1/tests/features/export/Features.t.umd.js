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
    PresetManager: PresetManager,
    PaperFormat: PaperFormat,
    Rectangle: Rectangle
  });
  t.overrideAjaxHelper();
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });

  function fixIE11Height(doc) {
    if (BrowserHelper.isIE11) {
      // IE11 doesn't calculate container height properly, this override is required to make
      // header assertions to pass
      doc.styleSheets[doc.styleSheets.length - 1].addRule('.b-export .b-export-content', 'height: 100% !important;');
    }
  }

  t.it('Should export scheduler to multiple pages', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var verticalPages, horizontalPages, _yield$t$createSchedu;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              verticalPages = 2, horizontalPages = 2;
              _context2.next = 3;
              return t.createSchedulerForExport({
                startDate: new Date(2019, 10, 4),
                endDate: new Date(2019, 11, 9),
                verticalPages: verticalPages,
                horizontalPages: horizontalPages
              });

            case 3:
              _yield$t$createSchedu = _context2.sent;
              scheduler = _yield$t$createSchedu.scheduler;
              paperHeight = _yield$t$createSchedu.paperHeight;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                var html, _yield$t$setIframeAsy, doc, iframe, events;

                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        scheduler.resourceStore.group('firstName');
                        _context.next = 3;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'singlepage'
                        });

                      case 3:
                        html = _context.sent;
                        _context.next = 6;
                        return t.setIframeAsync({
                          height: paperHeight,
                          html: html[0].html
                        });

                      case 6:
                        _yield$t$setIframeAsy = _context.sent;
                        doc = _yield$t$setIframeAsy.document;
                        iframe = _yield$t$setIframeAsy.iframe;
                        fixIE11Height(doc);
                        t.ok(t.assertRowsExportedWithoutGaps(doc, false, true), 'Rows exported without gaps');
                        t.ok(t.assertTicksExportedWithoutGaps(doc), 'Ticks exported without gaps');
                        events = scheduler.eventStore.query(function (r) {
                          return scheduler.timeAxis.isTimeSpanInAxis(r);
                        });
                        t.ok(t.assertExportedEventsList(doc, events), 'Events are exported correctly');
                        t.is(doc.querySelectorAll('.b-grid-row').length, scheduler.resourceStore.count * 2, 'All resources exported');
                        t.isExportedTickCount(doc, scheduler.timeAxis.count);
                        t.is(doc.querySelectorAll(scheduler.unreleasedEventSelector).length, scheduler.eventStore.count / 2, 'Event count is correct');
                        iframe.remove();

                      case 18:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })));

            case 7:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should export dependencies not visible on a first page', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var startDate, resources, pages, _yield$t$setIframeAsy2, document, iframe;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              startDate = new Date(2020, 6, 19), resources = DataGenerator.generateData(100);
              _context3.next = 3;
              return t.getSchedulerAsync({
                resources: resources,
                startDate: startDate,
                height: 400,
                width: 600,
                endDate: new Date(2020, 6, 26),
                features: {
                  dependencies: true,
                  pdfExport: {
                    exportServer: '/export'
                  }
                },
                events: [{
                  id: 1,
                  resourceId: resources[resources.length - 1].id,
                  startDate: new Date(2020, 6, 20),
                  duration: 2
                }, {
                  id: 2,
                  resourceId: resources[resources.length - 1].id,
                  startDate: new Date(2020, 6, 20),
                  duration: 2
                }],
                dependencies: [{
                  from: 1,
                  to: 2
                }]
              });

            case 3:
              scheduler = _context3.sent;
              _context3.next = 6;
              return t.getExportHtml(scheduler, {
                exporterType: 'multipagevertical'
              });

            case 6:
              pages = _context3.sent;
              _context3.next = 9;
              return t.setIframeAsync({
                height: 1123,
                html: pages[pages.length - 1].html
              });

            case 9:
              _yield$t$setIframeAsy2 = _context3.sent;
              document = _yield$t$setIframeAsy2.document;
              iframe = _yield$t$setIframeAsy2.iframe;
              t.ok(t.assertExportedEventDependenciesList(document, scheduler.dependencies), 'Dependency is exported');
              iframe.remove();

            case 14:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should export column lines', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var _yield$t$createSchedu2, pages, _yield$t$setIframeAsy3, document, iframe, ticks, lines;

      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.createSchedulerForExport({
                horizontalPages: 2
              });

            case 2:
              _yield$t$createSchedu2 = _context4.sent;
              scheduler = _yield$t$createSchedu2.scheduler;
              paperHeight = _yield$t$createSchedu2.paperHeight;
              _context4.next = 7;
              return t.getExportHtml(scheduler, {
                exporterType: 'multipagevertical'
              });

            case 7:
              pages = _context4.sent;
              _context4.next = 10;
              return t.setIframeAsync({
                height: paperHeight,
                html: pages[0].html
              });

            case 10:
              _yield$t$setIframeAsy3 = _context4.sent;
              document = _yield$t$setIframeAsy3.document;
              iframe = _yield$t$setIframeAsy3.iframe;
              ticks = Array.from(document.querySelectorAll('.b-lowest .b-sch-header-timeaxis-cell')).sort(function (a, b) {
                return a.offsetLeft - b.offsetLeft;
              }), lines = Array.from(document.querySelectorAll('.b-column-line, .b-column-line-major')).sort(function (a, b) {
                return a.getBoundingClientRect().left - b.getBoundingClientRect().left;
              });
              ticks.pop();
              t.is(ticks.length, lines.length, 'Correct amount of lines exported');
              ticks.forEach(function (tickEl, index) {
                if (index) {
                  var lineEl = lines[index - 1];
                  t.isApprox(lineEl.getBoundingClientRect().left, tickEl.getBoundingClientRect().left, 1, "Column line ".concat(index, " is aligned to tick el"));
                }
              });
              t.is(document.querySelectorAll('.b-column-line-major').length, 1, 'One major line exported');
              iframe.remove();

            case 19:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x3) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should export resource time ranges', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var _yield$t$createSchedu3, pages, _yield$t$setIframeAsy4, document, iframe, resourceRanges;

      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.createSchedulerForExport({
                horizontalPages: 2,
                verticalPages: 3,
                featuresConfig: {
                  resourceTimeRanges: true
                }
              });

            case 2:
              _yield$t$createSchedu3 = _context5.sent;
              scheduler = _yield$t$createSchedu3.scheduler;
              paperHeight = _yield$t$createSchedu3.paperHeight;
              scheduler.resourceTimeRanges = scheduler.resources.map(function (record, index) {
                return {
                  id: index + 1,
                  resourceId: record.id,
                  startDate: scheduler.timeAxis.getAt(1).startDate,
                  endDate: scheduler.timeAxis.getAt(2).startDate
                };
              });
              _context5.next = 8;
              return t.getExportHtml(scheduler, {
                exporterType: 'singlepage'
              });

            case 8:
              pages = _context5.sent;
              _context5.next = 11;
              return t.setIframeAsync({
                height: paperHeight,
                html: pages[0].html
              });

            case 11:
              _yield$t$setIframeAsy4 = _context5.sent;
              document = _yield$t$setIframeAsy4.document;
              iframe = _yield$t$setIframeAsy4.iframe;
              resourceRanges = Array.from(document.querySelectorAll('.b-sch-resourcetimerange'));
              t.is(resourceRanges.length, scheduler.resourceStore.count, 'All resource zones are exported');
              resourceRanges.forEach(function (element) {
                var resourceId = element.dataset.resourceId,
                    rowElement = document.querySelector(".b-grid-row[data-id=\"".concat(resourceId, "\"]")),
                    rowBox = rowElement.getBoundingClientRect(),
                    elBox = element.getBoundingClientRect();
                t.isApprox(elBox.y, rowBox.y, 1, "Resource ".concat(resourceId, " zone top position is ok"));
                t.isApprox(elBox.bottom, rowBox.bottom, 1, "Resource ".concat(resourceId, " zone bottom position is ok"));
              });
              iframe.remove();

            case 18:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
});