function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, paperHeight, rowHeight;
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
  t.it('Should export visible rows', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var _yield$t$createSchedu, doExport, _doExport, topRecord, assertContent;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              assertContent = function _assertContent(doc) {
                var rows = Array.from(doc.querySelectorAll('.b-grid-subgrid-normal .b-grid-row')),
                    bodyContainerEl = doc.querySelector('.b-grid-body-container');
                t.is(rows.length, 5, '5 rows exported');
                rows.forEach(function (el, index) {
                  t.is(el.dataset.id, topRecord.id + index, "Row ".concat(index, " is exported ok"));
                });
                t.ok(t.assertHeaderPosition(doc), 'Header is exported ok');
                t.ok(t.assertFooterPosition(doc), 'Footer is exported ok');
                var events = scheduler.eventStore.query(function (r) {
                  return scheduler.timeAxis.isTimeSpanInAxis(r) && r.resourceId < 6;
                });
                t.ok(events.length, 'Event list to check not empty');
                t.assertExportedEventsList(doc, events);
                t.is(bodyContainerEl.ownerDocument.defaultView.getComputedStyle(bodyContainerEl).overflowY, 'hidden', 'Scrollbar is hidden');
              };

              _doExport = function _doExport3() {
                _doExport = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(rowsRange, exporterType, callback) {
                  var html, _yield$t$setIframeAsy, document, iframe;

                  return regeneratorRuntime.wrap(function _callee2$(_context2) {
                    while (1) {
                      switch (_context2.prev = _context2.next) {
                        case 0:
                          _context2.next = 2;
                          return t.getExportHtml(scheduler, {
                            columns: scheduler.columns.getRange().map(function (r) {
                              return r.id;
                            }),
                            exporterType: exporterType,
                            rowsRange: rowsRange
                          });

                        case 2:
                          html = _context2.sent;
                          t.is(html.length, 1, '1 page is exported');
                          _context2.next = 6;
                          return t.setIframeAsync({
                            height: paperHeight + 50,
                            html: html[0].html
                          });

                        case 6:
                          _yield$t$setIframeAsy = _context2.sent;
                          document = _yield$t$setIframeAsy.document;
                          iframe = _yield$t$setIframeAsy.iframe;
                          callback(document);
                          iframe.remove();

                        case 11:
                        case "end":
                          return _context2.stop();
                      }
                    }
                  }, _callee2);
                }));
                return _doExport.apply(this, arguments);
              };

              doExport = function _doExport2(_x2, _x3, _x4) {
                return _doExport.apply(this, arguments);
              };

              _context3.next = 5;
              return t.createSchedulerForExport({
                height: 300
              });

            case 5:
              _yield$t$createSchedu = _context3.sent;
              scheduler = _yield$t$createSchedu.scheduler;
              paperHeight = _yield$t$createSchedu.paperHeight;
              topRecord = scheduler.store.getAt(0);
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        t.diag('Exporting visible rows to single page');
                        _context.next = 3;
                        return doExport(RowsRange.visible, 'singlepage', assertContent);

                      case 3:
                        t.diag('Exporting visible rows to multiple pages');
                        _context.next = 6;
                        return doExport(RowsRange.visible, 'multipage', assertContent);

                      case 6:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })));

            case 10:
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
  t.it('Should export visible rows (scrolled)', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var _yield$t$createSchedu2, doExport, _doExport4, topRecord, assertContent;

      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              assertContent = function _assertContent2(doc) {
                function matches(el, selector) {
                  var matches = doc.querySelectorAll(selector);
                  var i = matches.length;

                  while (--i >= 0 && matches.item(i) !== el) {}

                  return i > -1;
                }

                function closest(el, selector) {
                  if (!doc.documentElement.contains(el)) return null;

                  do {
                    if (matches(el, selector)) return el;
                    el = el.parentElement || el.parentNode;
                  } while (el !== null && el.nodeType === 1);

                  return null;
                }

                var rows = Array.from(doc.querySelectorAll('.b-grid-subgrid-locked .b-grid-row')),
                    bodyContainerEl = doc.querySelector('.b-grid-body-container'),
                    bodyContainerBox = bodyContainerEl.getBoundingClientRect(),
                    gridHeaderEl = doc.querySelector('.b-grid-header-container'),
                    gridHeaderBox = gridHeaderEl.getBoundingClientRect();
                t.is(rows.length, 5, '5 rows exported');
                rows.forEach(function (el, index) {
                  t.is(el.dataset.id, topRecord.id + index, "Row ".concat(index, " is exported ok"));
                });
                t.is(closest(doc.elementFromPoint(bodyContainerBox.left + 1, gridHeaderBox.bottom + 1), '.b-grid-row'), rows[0], 'First visible row is ok');
                t.ok(t.assertHeaderPosition(doc), 'Header is exported ok');
                t.ok(t.assertFooterPosition(doc), 'Footer is exported ok');
                var events = scheduler.eventStore.query(function (r) {
                  return scheduler.timeAxis.isTimeSpanInAxis(r) && r.resourceId > 4 && r.resourceId < 10;
                });
                t.ok(events.length, 'Event list to check not empty');
                t.assertExportedEventsList(doc, events);
                t.is(bodyContainerEl.ownerDocument.defaultView.getComputedStyle(bodyContainerEl).overflowY, 'hidden', 'Scrollbar is hidden');
              };

              _doExport4 = function _doExport6() {
                _doExport4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(rowsRange, exporterType, callback) {
                  var html, _yield$t$setIframeAsy2, document, iframe;

                  return regeneratorRuntime.wrap(function _callee5$(_context5) {
                    while (1) {
                      switch (_context5.prev = _context5.next) {
                        case 0:
                          _context5.next = 2;
                          return t.getExportHtml(scheduler, {
                            columns: scheduler.columns.getRange().map(function (r) {
                              return r.id;
                            }),
                            exporterType: exporterType,
                            rowsRange: rowsRange
                          });

                        case 2:
                          html = _context5.sent;
                          t.is(html.length, 1, '1 page is exported');
                          _context5.next = 6;
                          return t.setIframeAsync({
                            height: paperHeight + 50,
                            html: html[0].html
                          });

                        case 6:
                          _yield$t$setIframeAsy2 = _context5.sent;
                          document = _yield$t$setIframeAsy2.document;
                          iframe = _yield$t$setIframeAsy2.iframe;
                          callback(document);
                          iframe.remove();

                        case 11:
                        case "end":
                          return _context5.stop();
                      }
                    }
                  }, _callee5);
                }));
                return _doExport4.apply(this, arguments);
              };

              doExport = function _doExport5(_x6, _x7, _x8) {
                return _doExport4.apply(this, arguments);
              };

              _context6.next = 5;
              return t.createSchedulerForExport({
                height: 300
              });

            case 5:
              _yield$t$createSchedu2 = _context6.sent;
              scheduler = _yield$t$createSchedu2.scheduler;
              paperHeight = _yield$t$createSchedu2.paperHeight;
              topRecord = scheduler.store.getById(5);
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        _context4.next = 2;
                        return scheduler.scrollRowIntoView(topRecord, {
                          block: 'start'
                        });

                      case 2:
                        t.diag('Exporting visible rows to single page');
                        _context4.next = 5;
                        return doExport(RowsRange.visible, 'singlepage', assertContent);

                      case 5:
                        t.diag('Exporting visible rows to multiple pages');
                        _context4.next = 8;
                        return doExport(RowsRange.visible, 'multipage', assertContent);

                      case 8:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })));

            case 10:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x5) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should align rows', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var verticalPages, totalPages, rowsPerPage, _yield$t$createSchedu3;

      return regeneratorRuntime.wrap(function _callee8$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              // Exporting grid with content height to 7.5 rows. Which means we will get 15 rows and every page having enough
              // height to fit 7.5. rows. We expect 2 pages with 7 rows and 1 page with 1 row as a result
              verticalPages = 2, totalPages = 3, rowsPerPage = 7.5;
              _context9.next = 3;
              return t.createSchedulerForExport({
                verticalPages: verticalPages,
                rowsPerPage: rowsPerPage,
                featuresConfig: {
                  dependencies: true
                }
              });

            case 3:
              _yield$t$createSchedu3 = _context9.sent;
              scheduler = _yield$t$createSchedu3.scheduler;
              paperHeight = _yield$t$createSchedu3.paperHeight;
              rowHeight = _yield$t$createSchedu3.rowHeight;
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, function (next) {
                scheduler.dependencyStore.filter(function (r) {
                  return !(r.toOutside || r.fromOutside);
                });
                scheduler.on({
                  dependenciesDrawn: next,
                  once: true
                });
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                var html, _loop, i;

                return regeneratorRuntime.wrap(function _callee7$(_context8) {
                  while (1) {
                    switch (_context8.prev = _context8.next) {
                      case 0:
                        _context8.next = 2;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.getRange().map(function (r) {
                            return r.id;
                          }),
                          alignRows: true,
                          exporterType: 'multipage'
                        });

                      case 2:
                        html = _context8.sent;
                        t.is(html.length, totalPages, "".concat(totalPages, " pages exported"));
                        _loop = /*#__PURE__*/regeneratorRuntime.mark(function _loop(i) {
                          var _yield$t$setIframeAsy3, doc, iframe, rows, headerBox, footerBox, lastRowBox, _scheduler, startDate, endDate, events, dependencies;

                          return regeneratorRuntime.wrap(function _loop$(_context7) {
                            while (1) {
                              switch (_context7.prev = _context7.next) {
                                case 0:
                                  _context7.next = 2;
                                  return t.setIframeAsync({
                                    height: paperHeight + 50,
                                    html: html[i].html
                                  });

                                case 2:
                                  _yield$t$setIframeAsy3 = _context7.sent;
                                  doc = _yield$t$setIframeAsy3.document;
                                  iframe = _yield$t$setIframeAsy3.iframe;
                                  rows = Array.from(doc.querySelectorAll('.b-timeline-subgrid .b-grid-row')), headerBox = doc.querySelector('.b-export-header').getBoundingClientRect(), footerBox = doc.querySelector('.b-export-footer').getBoundingClientRect();

                                  if (i === 0) {
                                    t.is(rows.length, Math.floor(rowsPerPage) - 1, 'Correct amount of rows on 1st page');
                                    t.isApprox(rows[0].getBoundingClientRect().top, headerBox.bottom + rowHeight, 1, 'First row on the page is aligned properly');
                                  } else {
                                    if (i === 1) {
                                      t.is(rows.length, Math.floor(rowsPerPage), 'Correct amount of rows on 2nd page');
                                    } else {
                                      t.is(rows.length, 1, 'Correct amount of rows on 3rd page');
                                    }

                                    t.isApprox(rows[0].getBoundingClientRect().top, headerBox.bottom, 1, 'First row on the page is aligned properly');
                                  }

                                  lastRowBox = rows[rows.length - 1].getBoundingClientRect();
                                  t.isLess(lastRowBox.bottom, footerBox.top, 'Last row is fully visible');
                                  _scheduler = scheduler, startDate = _scheduler.startDate, endDate = _scheduler.endDate, events = scheduler.events.filter(function (r) {
                                    return DateHelper.intersectSpans(startDate, endDate, r.startDate, r.endDate) && r.resourceId > rowsPerPage * (i % totalPages) - 1 && r.resourceId < rowsPerPage * (i % totalPages + 1) - 1;
                                  }), dependencies = scheduler.dependencies.filter(function (r) {
                                    return events.includes(r.fromEvent) || events.includes(r.toEvent);
                                  });
                                  t.ok(t.assertExportedEventsList(doc, events), "Events are exported ok on page ".concat(i));
                                  t.ok(t.assertExportedEventDependenciesList(doc, dependencies), "Dependencies are exported ok on page ".concat(i));
                                  t.assertGridHeightAlignedWithLastRow(doc);
                                  iframe.remove();

                                case 14:
                                case "end":
                                  return _context7.stop();
                              }
                            }
                          }, _loop);
                        });
                        i = 0;

                      case 6:
                        if (!(i < totalPages)) {
                          _context8.next = 11;
                          break;
                        }

                        return _context8.delegateYield(_loop(i), "t0", 8);

                      case 8:
                        i++;
                        _context8.next = 6;
                        break;

                      case 11:
                      case "end":
                        return _context8.stop();
                    }
                  }
                }, _callee7);
              })));

            case 8:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref5.apply(this, arguments);
    };
  }());
});