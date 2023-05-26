function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, paperHeight, rowsPerPage;
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
  window.DEBUG = true;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  t.it('Should export scheduler to multiple pages', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var verticalPages, horizontalPages, totalPages, _yield$t$createSchedu;

      return regeneratorRuntime.wrap(function _callee2$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              verticalPages = 3, horizontalPages = 2, totalPages = verticalPages * horizontalPages;
              _context3.next = 3;
              return t.createSchedulerForExport({
                startDate: new Date(2019, 10, 4),
                endDate: new Date(2019, 11, 9),
                verticalPages: verticalPages,
                horizontalPages: horizontalPages
              });

            case 3:
              _yield$t$createSchedu = _context3.sent;
              scheduler = _yield$t$createSchedu.scheduler;
              paperHeight = _yield$t$createSchedu.paperHeight;
              rowsPerPage = _yield$t$createSchedu.rowsPerPage;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                var html, _loop, i;

                return regeneratorRuntime.wrap(function _callee$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        _context2.next = 2;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'multipage',
                          scheduleRange: 'completeview'
                        });

                      case 2:
                        html = _context2.sent;
                        t.is(html.length, totalPages, "".concat(totalPages, " pages are exported"));
                        _loop = /*#__PURE__*/regeneratorRuntime.mark(function _loop(i) {
                          var _yield$t$setIframeAsy, doc, iframe, _t$getDateRangeFromEx, startDate, endDate, events;

                          return regeneratorRuntime.wrap(function _loop$(_context) {
                            while (1) {
                              switch (_context.prev = _context.next) {
                                case 0:
                                  _context.next = 2;
                                  return t.setIframeAsync({
                                    height: paperHeight,
                                    html: html[i].html
                                  });

                                case 2:
                                  _yield$t$setIframeAsy = _context.sent;
                                  doc = _yield$t$setIframeAsy.document;
                                  iframe = _yield$t$setIframeAsy.iframe;
                                  t.ok(t.assertRowsExportedWithoutGaps(doc, i % verticalPages !== 0, true), "Rows exported without gaps on page ".concat(i));

                                  if (i % verticalPages === 0) {
                                    t.ok(t.assertTicksExportedWithoutGaps(doc), "Ticks exported without gaps on page ".concat(i));
                                  }

                                  _t$getDateRangeFromEx = t.getDateRangeFromExportedPage(doc), startDate = _t$getDateRangeFromEx.startDate, endDate = _t$getDateRangeFromEx.endDate, events = scheduler.eventStore.query(function (record) {
                                    return DateHelper.intersectSpans(record.startDate, record.endDate, startDate, endDate) && record.resourceId > rowsPerPage * (i % verticalPages) - 1 && record.resourceId < rowsPerPage * (i % verticalPages + 1) - 1;
                                  });
                                  t.ok(t.assertExportedEventsList(doc, events), "All required events found on the page ".concat(i));
                                  iframe.remove();

                                case 10:
                                case "end":
                                  return _context.stop();
                              }
                            }
                          }, _loop);
                        });
                        i = 0;

                      case 6:
                        if (!(i < html.length)) {
                          _context2.next = 11;
                          break;
                        }

                        return _context2.delegateYield(_loop(i), "t0", 8);

                      case 8:
                        i++;
                        _context2.next = 6;
                        break;

                      case 11:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee);
              })));

            case 8:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should export specific range of dates', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var horizontalPages, verticalPages, totalPages, rangeStart, rangeEnd, _yield$t$createSchedu2;

      return regeneratorRuntime.wrap(function _callee4$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              horizontalPages = 3, verticalPages = 1, totalPages = 2, rangeStart = new Date(2019, 10, 11), rangeEnd = new Date(2019, 10, 25);
              _context6.next = 3;
              return t.createSchedulerForExport({
                horizontalPages: horizontalPages,
                verticalPages: verticalPages,
                startDate: new Date(2019, 10, 4),
                endDate: new Date(2019, 11, 9)
              });

            case 3:
              _yield$t$createSchedu2 = _context6.sent;
              scheduler = _yield$t$createSchedu2.scheduler;
              paperHeight = _yield$t$createSchedu2.paperHeight;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                var html, _loop2, i;

                return regeneratorRuntime.wrap(function _callee3$(_context5) {
                  while (1) {
                    switch (_context5.prev = _context5.next) {
                      case 0:
                        _context5.next = 2;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'multipage',
                          scheduleRange: 'daterange',
                          rangeStart: rangeStart,
                          rangeEnd: rangeEnd
                        });

                      case 2:
                        html = _context5.sent;
                        t.is(html.length, totalPages, "".concat(totalPages, " page exported"));
                        _loop2 = /*#__PURE__*/regeneratorRuntime.mark(function _loop2(i) {
                          var _yield$t$setIframeAsy2, doc, iframe, _t$getDateRangeFromEx2, startDate, endDate, tickCount, tickWidth, lockedGridWidth, normalGridWidth, splitterWidth, schedulerEl, normalGridEl, normalGridBox, normalHeaderEl, _t$getFirstLastVisibl, firstTick, lastTick, event, exportedEventEl, exportedEventBox, scale, eventStartCoord, expectedStartCoord;

                          return regeneratorRuntime.wrap(function _loop2$(_context4) {
                            while (1) {
                              switch (_context4.prev = _context4.next) {
                                case 0:
                                  _context4.next = 2;
                                  return t.setIframeAsync({
                                    height: paperHeight,
                                    html: html[i].html
                                  });

                                case 2:
                                  _yield$t$setIframeAsy2 = _context4.sent;
                                  doc = _yield$t$setIframeAsy2.document;
                                  iframe = _yield$t$setIframeAsy2.iframe;
                                  t.ok(t.assertRowsExportedWithoutGaps(doc, false, true), 'Rows exported without gaps');
                                  t.ok(t.assertTicksExportedWithoutGaps(doc), 'Ticks exported without gaps');
                                  _t$getDateRangeFromEx2 = t.getDateRangeFromExportedPage(doc), startDate = _t$getDateRangeFromEx2.startDate, endDate = _t$getDateRangeFromEx2.endDate, tickCount = 7 * 2, tickWidth = scheduler.tickSize, lockedGridWidth = scheduler.subGrids.locked.scrollable.scrollWidth, normalGridWidth = tickCount * tickWidth, splitterWidth = scheduler.resolveSplitter('locked').offsetWidth, schedulerEl = doc.querySelector('.b-scheduler'), normalGridEl = doc.querySelector('.b-grid-subgrid-normal'), normalGridBox = Rectangle.from(normalGridEl), normalHeaderEl = doc.querySelector('.b-grid-headers-normal'), _t$getFirstLastVisibl = t.getFirstLastVisibleTicks(doc), firstTick = _t$getFirstLastVisibl.firstTick, lastTick = _t$getFirstLastVisibl.lastTick;
                                  t.is(schedulerEl.offsetWidth, lockedGridWidth + normalGridWidth + splitterWidth, 'Scheduler width is ok');
                                  t.is(normalGridEl.offsetWidth, normalGridWidth, 'Normal grid width is ok');
                                  t.is(normalHeaderEl.offsetWidth, normalGridWidth, 'Normal header width is ok');

                                  if (i === 0) {
                                    t.is(firstTick.dataset.tickIndex, '0', 'First visible tick index is ok');
                                    t.is(lastTick.dataset.tickIndex, '3', 'Last visible tick index is ok');
                                  } else {
                                    t.is(firstTick.dataset.tickIndex, '3', 'First visible tick index is ok');
                                    t.is(lastTick.dataset.tickIndex, '13', 'Last visible tick index is ok');
                                  } // find first event which is fit completely into the exported range


                                  event = scheduler.eventStore.find(function (r) {
                                    return DateHelper.intersectSpans(startDate, endDate, r.startDate, r.endDate);
                                  });

                                  if (event) {
                                    exportedEventEl = doc.querySelector("[data-event-id=\"".concat(event.id, "\"]")), exportedEventBox = exportedEventEl.getBoundingClientRect(), scale = exportedEventBox.width / exportedEventEl.offsetWidth, eventStartCoord = DateHelper.getDurationInUnit(rangeStart, event.startDate, 'd') * tickWidth * scale, expectedStartCoord = normalGridBox.left + eventStartCoord;
                                    t.is(Math.round(exportedEventBox.left), Math.round(expectedStartCoord - (event.isMilestone ? exportedEventBox.height : 0) / 2), 'Event is positioned properly horizontally');
                                  }

                                  iframe.remove();

                                case 15:
                                case "end":
                                  return _context4.stop();
                              }
                            }
                          }, _loop2);
                        });
                        i = 0;

                      case 6:
                        if (!(i < totalPages)) {
                          _context5.next = 11;
                          break;
                        }

                        return _context5.delegateYield(_loop2(i), "t0", 8);

                      case 8:
                        i++;
                        _context5.next = 6;
                        break;

                      case 11:
                      case "end":
                        return _context5.stop();
                    }
                  }
                }, _callee3);
              })));

            case 7:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should export dependencies to multiple pages', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var verticalPages, horizontalPages, totalPages, _yield$t$createSchedu3;

      return regeneratorRuntime.wrap(function _callee6$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              verticalPages = 3, horizontalPages = 2, totalPages = verticalPages * horizontalPages;
              _context9.next = 3;
              return t.createSchedulerForExport({
                verticalPages: verticalPages,
                horizontalPages: horizontalPages,
                featuresConfig: {
                  dependencies: true
                }
              });

            case 3:
              _yield$t$createSchedu3 = _context9.sent;
              scheduler = _yield$t$createSchedu3.scheduler;
              paperHeight = _yield$t$createSchedu3.paperHeight;
              rowsPerPage = _yield$t$createSchedu3.rowsPerPage;
              t.chain(function (next) {
                scheduler.dependencyStore.filter(function (r) {
                  return !(r.toOutside || r.fromOutside);
                });
                scheduler.on({
                  dependenciesDrawn: next,
                  once: true
                });
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                var html, _loop3, i;

                return regeneratorRuntime.wrap(function _callee5$(_context8) {
                  while (1) {
                    switch (_context8.prev = _context8.next) {
                      case 0:
                        _context8.next = 2;
                        return t.getExportHtml(scheduler, {
                          columns: scheduler.columns.visibleColumns.map(function (c) {
                            return c.id;
                          }),
                          exporterType: 'multipage',
                          scheduleRange: 'completeview'
                        });

                      case 2:
                        html = _context8.sent;
                        t.is(html.length, totalPages, "".concat(totalPages, " pages are exported"));
                        _loop3 = /*#__PURE__*/regeneratorRuntime.mark(function _loop3(i) {
                          var _yield$t$setIframeAsy3, doc, iframe, _t$getDateRangeFromEx3, startDate, endDate, events, dependencies;

                          return regeneratorRuntime.wrap(function _loop3$(_context7) {
                            while (1) {
                              switch (_context7.prev = _context7.next) {
                                case 0:
                                  _context7.next = 2;
                                  return t.setIframeAsync({
                                    height: paperHeight,
                                    html: html[i].html
                                  });

                                case 2:
                                  _yield$t$setIframeAsy3 = _context7.sent;
                                  doc = _yield$t$setIframeAsy3.document;
                                  iframe = _yield$t$setIframeAsy3.iframe;
                                  _t$getDateRangeFromEx3 = t.getDateRangeFromExportedPage(doc), startDate = _t$getDateRangeFromEx3.startDate, endDate = _t$getDateRangeFromEx3.endDate, events = scheduler.eventStore.query(function (record) {
                                    return DateHelper.intersectSpans(record.startDate, record.endDate, startDate, endDate) && record.resourceId > rowsPerPage * (i % verticalPages) - 1 && record.resourceId < rowsPerPage * (i % verticalPages + 1) - 1;
                                  }), dependencies = scheduler.dependencyStore.query(function (r) {
                                    return events.includes(r.fromEvent) || events.includes(r.toEvent);
                                  });
                                  t.ok(events.length, "Some events found on page ".concat(i));
                                  t.ok(dependencies.length, "Some dependencies found on page ".concat(i));
                                  t.ok(t.assertExportedEventDependenciesList(doc, dependencies), "Dependencies exported correctly on page ".concat(i));
                                  iframe.remove();

                                case 10:
                                case "end":
                                  return _context7.stop();
                              }
                            }
                          }, _loop3);
                        });
                        i = 0;

                      case 6:
                        if (!(i < html.length)) {
                          _context8.next = 11;
                          break;
                        }

                        return _context8.delegateYield(_loop3(i), "t0", 8);

                      case 8:
                        i++;
                        _context8.next = 6;
                        break;

                      case 11:
                      case "end":
                        return _context8.stop();
                    }
                  }
                }, _callee5);
              })));

            case 8:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x3) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should export visible rows', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var _yield$t$createSchedu4, lastVisibleRowIndex, pages, i, _yield$t$setIframeAsy4, document, iframe, _i, _yield$t$setIframeAsy5, _document, _iframe;

      return regeneratorRuntime.wrap(function _callee7$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return t.createSchedulerForExport({
                verticalPages: 2,
                horizontalPages: 2,
                rowsPerPage: 20,
                height: 800
              });

            case 2:
              _yield$t$createSchedu4 = _context10.sent;
              scheduler = _yield$t$createSchedu4.scheduler;
              paperHeight = _yield$t$createSchedu4.paperHeight;
              // Add more events to change average row height
              lastVisibleRowIndex = scheduler.rowManager.rows.findIndex(function (row) {
                return row.top >= scheduler.bodyHeight;
              });
              scheduler.resourceStore.forEach(function (resource, index) {
                if (index >= lastVisibleRowIndex && scheduler.getRow(index)) {
                  scheduler.eventStore.add(resource.events[1].copy());
                  scheduler.eventStore.add(resource.events[1].copy());
                }
              });
              _context10.next = 9;
              return t.getExportHtml(scheduler, {
                exporterType: 'multipage',
                rowsRange: RowsRange.visible
              });

            case 9:
              pages = _context10.sent;
              t.is(pages.length, 2, '2 pages exported');
              i = 0;

            case 12:
              if (!(i < pages.length)) {
                _context10.next = 23;
                break;
              }

              _context10.next = 15;
              return t.setIframeAsync({
                html: pages[i].html,
                height: paperHeight
              });

            case 15:
              _yield$t$setIframeAsy4 = _context10.sent;
              document = _yield$t$setIframeAsy4.document;
              iframe = _yield$t$setIframeAsy4.iframe;
              t.is(document.querySelectorAll('.b-timeline-subgrid .b-grid-row').length, lastVisibleRowIndex, 'Correct amount of exported rows');
              iframe.remove();

            case 20:
              i++;
              _context10.next = 12;
              break;

            case 23:
              _context10.next = 25;
              return t.getExportHtml(scheduler, {
                exporterType: 'multipagevertical',
                rowsRange: RowsRange.visible,
                scheduleRange: ScheduleRange.currentview
              });

            case 25:
              pages = _context10.sent;
              t.is(pages.length, 1, '1 pages exported');
              _i = 0;

            case 28:
              if (!(_i < pages.length)) {
                _context10.next = 39;
                break;
              }

              _context10.next = 31;
              return t.setIframeAsync({
                html: pages[_i].html,
                height: paperHeight
              });

            case 31:
              _yield$t$setIframeAsy5 = _context10.sent;
              _document = _yield$t$setIframeAsy5.document;
              _iframe = _yield$t$setIframeAsy5.iframe;
              t.is(_document.querySelectorAll('.b-timeline-subgrid .b-grid-row').length, lastVisibleRowIndex, 'Correct amount of exported rows');

              _iframe.remove();

            case 36:
              _i++;
              _context10.next = 28;
              break;

            case 39:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x4) {
      return _ref7.apply(this, arguments);
    };
  }());
});