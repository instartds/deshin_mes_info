function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, paperHeight;
  var exporterType = 'multipagevertical';
  Object.assign(window, {
    DateHelper: DateHelper,
    DomHelper: DomHelper,
    Override: Override,
    DataGenerator: DataGenerator,
    RandomGenerator: RandomGenerator,
    Scheduler: Scheduler,
    PresetManager: PresetManager,
    PaperFormat: PaperFormat,
    Rectangle: Rectangle
  });
  t.overrideAjaxHelper();
  window.DEBUG = true;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });

  function getTotalPages(vertical, horizontal) {
    // Content should scale horizontally by 1 / horizontalPages, apply same scale to vertical pages
    return Math.ceil(vertical / horizontal);
  }

  t.it('Should export scheduler to multiple pages', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var verticalPages, horizontalPages, totalPages, _yield$t$createSchedu, html, indices, _loop, i;

      return regeneratorRuntime.wrap(function _callee$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              verticalPages = 4, horizontalPages = 2, totalPages = getTotalPages(verticalPages, horizontalPages);
              _context2.next = 3;
              return t.createSchedulerForExport({
                startDate: new Date(2019, 10, 4),
                endDate: new Date(2019, 11, 9),
                rowsPerPage: 20,
                verticalPages: verticalPages,
                horizontalPages: horizontalPages
              });

            case 3:
              _yield$t$createSchedu = _context2.sent;
              scheduler = _yield$t$createSchedu.scheduler;
              paperHeight = _yield$t$createSchedu.paperHeight;
              _context2.next = 8;
              return t.getExportHtml(scheduler, {
                exporterType: exporterType,
                scheduleRange: ScheduleRange.completeview
              });

            case 8:
              html = _context2.sent;
              t.is(html.length, totalPages, "".concat(totalPages, " pages are exported"));
              indices = new Set();
              _loop = /*#__PURE__*/regeneratorRuntime.mark(function _loop(i) {
                var _yield$t$setIframeAsy, doc, iframe;

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
                        t.subTest("Checking page: ".concat(i), function (t) {
                          t.ok(t.assertRowsExportedWithoutGaps(doc, i !== 0, i !== html.length - 1, false), 'Rows exported without gaps');

                          if (i % verticalPages === 0) {
                            t.ok(t.assertTicksExportedWithoutGaps(doc), 'Ticks exported without gaps');
                          }

                          var exportedRows = Array.from(doc.querySelectorAll('.b-timeline-subgrid .b-grid-row')),
                              exportedRowsIds = new Set();
                          exportedRows.forEach(function (el) {
                            var id = parseInt(el.dataset.id);
                            exportedRowsIds.add(id);
                            indices.add(id);
                          });

                          var _t$getDateRangeFromEx = t.getDateRangeFromExportedPage(doc),
                              startDate = _t$getDateRangeFromEx.startDate,
                              endDate = _t$getDateRangeFromEx.endDate,
                              events = scheduler.eventStore.query(function (record) {
                            return DateHelper.intersectSpans(record.startDate, record.endDate, startDate, endDate) && exportedRowsIds.has(record.resourceId);
                          });

                          t.ok(t.assertExportedEventsList(doc, events), 'All required events found');
                          iframe.remove();
                        });

                      case 6:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _loop);
              });
              i = 0;

            case 13:
              if (!(i < html.length)) {
                _context2.next = 18;
                break;
              }

              return _context2.delegateYield(_loop(i), "t0", 15);

            case 15:
              i++;
              _context2.next = 13;
              break;

            case 18:
              t.is(indices.size, scheduler.resourceStore.count, 'All rows are exported');

            case 19:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should export specific range of dates', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var horizontalPages, verticalPages, totalPages, rangeStart, rangeEnd, _yield$t$createSchedu2;

      return regeneratorRuntime.wrap(function _callee3$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              horizontalPages = 2, verticalPages = 2, totalPages = 2, rangeStart = new Date(2019, 10, 11), rangeEnd = new Date(2019, 10, 25);
              _context5.next = 3;
              return t.createSchedulerForExport({
                horizontalPages: horizontalPages,
                verticalPages: verticalPages,
                rowsPerPage: 20,
                startDate: new Date(2019, 10, 4),
                endDate: new Date(2019, 11, 9)
              });

            case 3:
              _yield$t$createSchedu2 = _context5.sent;
              scheduler = _yield$t$createSchedu2.scheduler;
              paperHeight = _yield$t$createSchedu2.paperHeight;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                var html, _loop2, i;

                return regeneratorRuntime.wrap(function _callee2$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        _context4.next = 2;
                        return t.getExportHtml(scheduler, {
                          exporterType: exporterType,
                          scheduleRange: ScheduleRange.daterange,
                          rangeStart: rangeStart,
                          rangeEnd: rangeEnd
                        });

                      case 2:
                        html = _context4.sent;
                        t.is(html.length, totalPages, "".concat(totalPages, " page exported"));
                        _loop2 = /*#__PURE__*/regeneratorRuntime.mark(function _loop2(i) {
                          var _yield$t$setIframeAsy2, doc, iframe;

                          return regeneratorRuntime.wrap(function _loop2$(_context3) {
                            while (1) {
                              switch (_context3.prev = _context3.next) {
                                case 0:
                                  _context3.next = 2;
                                  return t.setIframeAsync({
                                    height: paperHeight,
                                    html: html[i].html
                                  });

                                case 2:
                                  _yield$t$setIframeAsy2 = _context3.sent;
                                  doc = _yield$t$setIframeAsy2.document;
                                  iframe = _yield$t$setIframeAsy2.iframe;
                                  t.subTest("Checking page: ".concat(i), function (t) {
                                    t.ok(t.assertHeaderPosition(doc), 'Header is exported ok');
                                    t.ok(t.assertFooterPosition(doc), 'Footer is exported ok');
                                    t.ok(t.assertRowsExportedWithoutGaps(doc, i !== 0, i !== html.length - 1, false), 'Rows exported without gaps');

                                    if (i === 0) {
                                      t.ok(t.assertTicksExportedWithoutGaps(doc), 'Ticks exported without gaps');
                                    }

                                    var _t$getDateRangeFromEx2 = t.getDateRangeFromExportedPage(doc),
                                        startDate = _t$getDateRangeFromEx2.startDate,
                                        endDate = _t$getDateRangeFromEx2.endDate,
                                        tickCount = 7 * 2,
                                        tickWidth = scheduler.tickSize,
                                        lockedGridWidth = scheduler.subGrids.locked.scrollable.scrollWidth,
                                        normalGridWidth = tickCount * tickWidth,
                                        splitterWidth = scheduler.resolveSplitter('locked').offsetWidth,
                                        schedulerEl = doc.querySelector('.b-scheduler'),
                                        normalGridEl = doc.querySelector('.b-grid-subgrid-normal'),
                                        normalGridBox = Rectangle.from(normalGridEl),
                                        normalHeaderEl = doc.querySelector('.b-grid-headers-normal'),
                                        _t$getFirstLastVisibl = t.getFirstLastVisibleTicks(doc),
                                        firstTick = _t$getFirstLastVisibl.firstTick,
                                        lastTick = _t$getFirstLastVisibl.lastTick;

                                    t.is(schedulerEl.offsetWidth, lockedGridWidth + normalGridWidth + splitterWidth, 'Scheduler width is ok');
                                    t.is(normalGridEl.offsetWidth, normalGridWidth, 'Normal grid width is ok');
                                    t.is(normalHeaderEl.offsetWidth, normalGridWidth, 'Normal header width is ok');
                                    t.is(firstTick.dataset.tickIndex, '0', 'First visible tick index is ok');
                                    t.is(lastTick.dataset.tickIndex, '13', 'Last visible tick index is ok'); // find first event which is fit completely into the exported range

                                    var event = scheduler.eventStore.find(function (r) {
                                      return DateHelper.intersectSpans(startDate, endDate, r.startDate, r.endDate) && !r.isMilestone && doc.querySelector("[data-id=\"".concat(r.resourceId, "\"]"));
                                    });

                                    if (event) {
                                      var exportedEventEl = doc.querySelector("[data-event-id=\"".concat(event.id, "\"]")),
                                          exportedEventBox = exportedEventEl.getBoundingClientRect(),
                                          scale = exportedEventBox.width / exportedEventEl.offsetWidth,
                                          eventStartCoord = DateHelper.getDurationInUnit(rangeStart, event.startDate, 'd') * tickWidth * scale,
                                          expectedStartCoord = normalGridBox.left + eventStartCoord;
                                      t.is(Math.round(exportedEventBox.left), Math.round(expectedStartCoord - (event.isMilestone ? exportedEventBox.height : 0) / 2), 'Event is positioned properly horizontally');
                                    }

                                    iframe.remove();
                                  });

                                case 6:
                                case "end":
                                  return _context3.stop();
                              }
                            }
                          }, _loop2);
                        });
                        i = 0;

                      case 6:
                        if (!(i < html.length)) {
                          _context4.next = 11;
                          break;
                        }

                        return _context4.delegateYield(_loop2(i), "t0", 8);

                      case 8:
                        i++;
                        _context4.next = 6;
                        break;

                      case 11:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee2);
              })));

            case 7:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Should export dependencies to multiple pages', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var verticalPages, horizontalPages, totalPages, _yield$t$createSchedu3;

      return regeneratorRuntime.wrap(function _callee6$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              verticalPages = 4, horizontalPages = 2, totalPages = getTotalPages(verticalPages, horizontalPages);
              _context9.next = 3;
              return t.createSchedulerForExport({
                config: {
                  enableEventAnimations: false,
                  useInitialAnimation: false
                },
                verticalPages: verticalPages,
                horizontalPages: horizontalPages,
                rowsPerPage: 20,
                featuresConfig: {
                  dependencies: true
                }
              });

            case 3:
              _yield$t$createSchedu3 = _context9.sent;
              scheduler = _yield$t$createSchedu3.scheduler;
              paperHeight = _yield$t$createSchedu3.paperHeight;
              t.chain(function (next) {
                scheduler.dependencyStore.filter(function (r) {
                  return !(r.toOutside || r.fromOutside);
                });
                scheduler.on({
                  dependenciesDrawn: next,
                  once: true
                });
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                var assertExport, _assertExport;

                return regeneratorRuntime.wrap(function _callee5$(_context8) {
                  while (1) {
                    switch (_context8.prev = _context8.next) {
                      case 0:
                        _assertExport = function _assertExport3() {
                          _assertExport = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                            var repeatHeader,
                                html,
                                indices,
                                _loop3,
                                i,
                                _args7 = arguments;

                            return regeneratorRuntime.wrap(function _callee4$(_context7) {
                              while (1) {
                                switch (_context7.prev = _context7.next) {
                                  case 0:
                                    repeatHeader = _args7.length > 0 && _args7[0] !== undefined ? _args7[0] : false;
                                    _context7.next = 3;
                                    return t.getExportHtml(scheduler, {
                                      exporterType: exporterType,
                                      repeatHeader: repeatHeader,
                                      scheduleRange: ScheduleRange.completeview
                                    });

                                  case 3:
                                    html = _context7.sent;
                                    indices = new Set();
                                    t.is(html.length, totalPages, "".concat(totalPages, " pages are exported"));
                                    _loop3 = /*#__PURE__*/regeneratorRuntime.mark(function _loop3(i) {
                                      var _yield$t$setIframeAsy3, doc, iframe;

                                      return regeneratorRuntime.wrap(function _loop3$(_context6) {
                                        while (1) {
                                          switch (_context6.prev = _context6.next) {
                                            case 0:
                                              _context6.next = 2;
                                              return t.setIframeAsync({
                                                height: paperHeight,
                                                html: html[i].html
                                              });

                                            case 2:
                                              _yield$t$setIframeAsy3 = _context6.sent;
                                              doc = _yield$t$setIframeAsy3.document;
                                              iframe = _yield$t$setIframeAsy3.iframe;
                                              t.subTest("Checking page: ".concat(i), function (t) {
                                                var exportedRows = Array.from(doc.querySelectorAll('.b-timeline-subgrid .b-grid-row')),
                                                    exportedRowsIds = new Set();
                                                exportedRows.forEach(function (el) {
                                                  var id = parseInt(el.dataset.id);
                                                  exportedRowsIds.add(id);
                                                  indices.add(id);
                                                });

                                                var _t$getDateRangeFromEx3 = t.getDateRangeFromExportedPage(doc),
                                                    startDate = _t$getDateRangeFromEx3.startDate,
                                                    endDate = _t$getDateRangeFromEx3.endDate,
                                                    events = scheduler.eventStore.query(function (record) {
                                                  return DateHelper.intersectSpans(record.startDate, record.endDate, startDate, endDate) && exportedRowsIds.has(record.resourceId);
                                                }),
                                                    dependencies = scheduler.dependencyStore.query(function (r) {
                                                  return events.includes(r.sourceEvent) || events.includes(r.targetEvent);
                                                });

                                                t.ok(events.length, 'Some events found');
                                                t.ok(dependencies.length, 'Some dependencies found');

                                                if (repeatHeader) {
                                                  t.ok(t.assertGridHeader(doc), 'Grid header is repeated ok');
                                                }

                                                t.ok(t.assertExportedEventDependenciesList(doc, dependencies), 'Dependencies exported correctly');
                                                iframe.remove();
                                              });

                                            case 6:
                                            case "end":
                                              return _context6.stop();
                                          }
                                        }
                                      }, _loop3);
                                    });
                                    i = 0;

                                  case 8:
                                    if (!(i < html.length)) {
                                      _context7.next = 13;
                                      break;
                                    }

                                    return _context7.delegateYield(_loop3(i), "t0", 10);

                                  case 10:
                                    i++;
                                    _context7.next = 8;
                                    break;

                                  case 13:
                                    t.is(indices.size, scheduler.resourceStore.count, 'All rows are exported');

                                  case 14:
                                  case "end":
                                    return _context7.stop();
                                }
                              }
                            }, _callee4);
                          }));
                          return _assertExport.apply(this, arguments);
                        };

                        assertExport = function _assertExport2() {
                          return _assertExport.apply(this, arguments);
                        };

                        _context8.next = 4;
                        return assertExport(false);

                      case 4:
                        _context8.next = 6;
                        return new Promise(function (resolve) {
                          return requestAnimationFrame(resolve);
                        });

                      case 6:
                        _context8.next = 8;
                        return assertExport(true);

                      case 8:
                      case "end":
                        return _context8.stop();
                    }
                  }
                }, _callee5);
              })));

            case 7:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x3) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should export visible rows', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var verticalPages, horizontalPages, totalPages, _yield$t$createSchedu4, assertExport, _assertExport4;

      return regeneratorRuntime.wrap(function _callee8$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _assertExport4 = function _assertExport6() {
                _assertExport4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(repeatHeader) {
                  var html, indices, _loop4, i;

                  return regeneratorRuntime.wrap(function _callee7$(_context11) {
                    while (1) {
                      switch (_context11.prev = _context11.next) {
                        case 0:
                          t.diag("Exporting ".concat(repeatHeader ? '' : 'not', " repeating header"));
                          _context11.next = 3;
                          return t.getExportHtml(scheduler, {
                            exporterType: exporterType,
                            repeatHeader: repeatHeader,
                            rowsRange: RowsRange.visible,
                            scheduleRange: ScheduleRange.currentview
                          });

                        case 3:
                          html = _context11.sent;
                          t.is(html.length, totalPages, "".concat(totalPages, " pages are exported"));
                          indices = new Set();
                          _loop4 = /*#__PURE__*/regeneratorRuntime.mark(function _loop4(i) {
                            var _yield$t$setIframeAsy4, doc, iframe;

                            return regeneratorRuntime.wrap(function _loop4$(_context10) {
                              while (1) {
                                switch (_context10.prev = _context10.next) {
                                  case 0:
                                    _context10.next = 2;
                                    return t.setIframeAsync({
                                      height: paperHeight,
                                      html: html[i].html
                                    });

                                  case 2:
                                    _yield$t$setIframeAsy4 = _context10.sent;
                                    doc = _yield$t$setIframeAsy4.document;
                                    iframe = _yield$t$setIframeAsy4.iframe;
                                    t.subTest("Checking page: ".concat(i), function (t) {
                                      t.ok(t.assertRowsExportedWithoutGaps(doc, false, false, true), 'Rows exported without gaps');
                                      t.ok(t.assertTicksExportedWithoutGaps(doc), 'Ticks exported without gaps');
                                      var exportedRows = Array.from(doc.querySelectorAll('.b-timeline-subgrid .b-grid-row')),
                                          exportedRowsIds = new Set();
                                      exportedRows.forEach(function (el) {
                                        var id = parseInt(el.dataset.id);
                                        exportedRowsIds.add(id);
                                        indices.add(id);
                                      });

                                      var _t$getDateRangeFromEx4 = t.getDateRangeFromExportedPage(doc),
                                          startDate = _t$getDateRangeFromEx4.startDate,
                                          endDate = _t$getDateRangeFromEx4.endDate,
                                          events = scheduler.eventStore.query(function (record) {
                                        return DateHelper.intersectSpans(record.startDate, record.endDate, startDate, endDate) && exportedRowsIds.has(record.resourceId);
                                      });

                                      t.ok(t.assertExportedEventsList(doc, events), 'All required events found');
                                      t.assertGridHeightAlignedWithLastRow(doc);
                                      iframe.remove();
                                    });

                                  case 6:
                                  case "end":
                                    return _context10.stop();
                                }
                              }
                            }, _loop4);
                          });
                          i = 0;

                        case 8:
                          if (!(i < html.length)) {
                            _context11.next = 13;
                            break;
                          }

                          return _context11.delegateYield(_loop4(i), "t0", 10);

                        case 10:
                          i++;
                          _context11.next = 8;
                          break;

                        case 13:
                          t.is(indices.size, Math.round(scheduler.bodyHeight / scheduler.rowHeight), 'Visible rows are exported');

                        case 14:
                        case "end":
                          return _context11.stop();
                      }
                    }
                  }, _callee7);
                }));
                return _assertExport4.apply(this, arguments);
              };

              assertExport = function _assertExport5(_x5) {
                return _assertExport4.apply(this, arguments);
              };

              verticalPages = 2, horizontalPages = 2, totalPages = 1;
              _context12.next = 5;
              return t.createSchedulerForExport({
                startDate: new Date(2019, 10, 4),
                endDate: new Date(2019, 11, 9),
                rowsPerPage: 20,
                height: 900,
                width: 650,
                verticalPages: verticalPages,
                horizontalPages: horizontalPages
              });

            case 5:
              _yield$t$createSchedu4 = _context12.sent;
              scheduler = _yield$t$createSchedu4.scheduler;
              paperHeight = _yield$t$createSchedu4.paperHeight;
              _context12.next = 10;
              return assertExport(false);

            case 10:
              _context12.next = 12;
              return assertExport(true);

            case 12:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x4) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should export large view', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var _yield$t$createSchedu5, html, indices, _loop5, i;

      return regeneratorRuntime.wrap(function _callee9$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return t.createSchedulerForExport({
                rowsPerPage: 20,
                verticalPages: 12,
                horizontalPages: 2,
                config: {
                  barMargin: 0
                }
              });

            case 2:
              _yield$t$createSchedu5 = _context14.sent;
              scheduler = _yield$t$createSchedu5.scheduler;
              _context14.next = 6;
              return t.getExportHtml(scheduler, {
                exporterType: 'multipagevertical'
              });

            case 6:
              html = _context14.sent;
              t.is(html.length, 6, '6 pages exported');
              indices = new Set();
              _loop5 = /*#__PURE__*/regeneratorRuntime.mark(function _loop5(i) {
                var _yield$t$setIframeAsy5, doc, iframe;

                return regeneratorRuntime.wrap(function _loop5$(_context13) {
                  while (1) {
                    switch (_context13.prev = _context13.next) {
                      case 0:
                        _context13.next = 2;
                        return t.setIframeAsync({
                          height: paperHeight,
                          html: html[i].html
                        });

                      case 2:
                        _yield$t$setIframeAsy5 = _context13.sent;
                        doc = _yield$t$setIframeAsy5.document;
                        iframe = _yield$t$setIframeAsy5.iframe;
                        t.subTest("Checking page: ".concat(i), function (t) {
                          t.ok(t.assertRowsExportedWithoutGaps(doc, false, false, false), 'Rows exported without gaps');
                          t.ok(t.assertTicksExportedWithoutGaps(doc), 'Ticks exported without gaps');
                          var exportedRows = Array.from(doc.querySelectorAll('.b-timeline-subgrid .b-grid-row')),
                              exportedRowsIds = new Set();
                          exportedRows.forEach(function (el) {
                            var id = parseInt(el.dataset.id);
                            exportedRowsIds.add(id);
                            indices.add(id);
                          });

                          var _t$getDateRangeFromEx5 = t.getDateRangeFromExportedPage(doc),
                              startDate = _t$getDateRangeFromEx5.startDate,
                              endDate = _t$getDateRangeFromEx5.endDate,
                              events = scheduler.eventStore.query(function (record) {
                            return DateHelper.intersectSpans(record.startDate, record.endDate, startDate, endDate) && exportedRowsIds.has(record.resourceId);
                          });

                          t.ok(t.assertExportedEventsList(doc, events), 'All required events found');
                          t.assertGridHeightAlignedWithLastRow(doc);
                          iframe.remove();
                        });

                      case 6:
                      case "end":
                        return _context13.stop();
                    }
                  }
                }, _loop5);
              });
              i = 0;

            case 11:
              if (!(i < html.length)) {
                _context14.next = 16;
                break;
              }

              return _context14.delegateYield(_loop5(i), "t0", 13);

            case 13:
              i++;
              _context14.next = 11;
              break;

            case 16:
              t.is(indices.size, scheduler.resourceStore.count, 'All rows are exported');

            case 17:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x6) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should export large view with variable row heights', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var _yield$t$createSchedu6, assertExport, _assertExport7;

      return regeneratorRuntime.wrap(function _callee12$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _assertExport7 = function _assertExport9() {
                _assertExport7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(repeatHeader) {
                  return regeneratorRuntime.wrap(function _callee11$(_context17) {
                    while (1) {
                      switch (_context17.prev = _context17.next) {
                        case 0:
                          _context17.next = 2;
                          return new Promise(function (resolve) {
                            t.subTest("Exporting scheduler (repeatHeader: ".concat(repeatHeader, ")"), /*#__PURE__*/function () {
                              var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
                                var html, indices, _loop6, i;

                                return regeneratorRuntime.wrap(function _callee10$(_context16) {
                                  while (1) {
                                    switch (_context16.prev = _context16.next) {
                                      case 0:
                                        _context16.next = 2;
                                        return t.getExportHtml(scheduler, {
                                          exporterType: 'multipagevertical',
                                          repeatHeader: repeatHeader
                                        });

                                      case 2:
                                        html = _context16.sent;
                                        indices = new Set();
                                        _loop6 = /*#__PURE__*/regeneratorRuntime.mark(function _loop6(i) {
                                          var _yield$t$setIframeAsy6, doc, iframe;

                                          return regeneratorRuntime.wrap(function _loop6$(_context15) {
                                            while (1) {
                                              switch (_context15.prev = _context15.next) {
                                                case 0:
                                                  _context15.next = 2;
                                                  return t.setIframeAsync({
                                                    height: paperHeight,
                                                    html: html[i].html
                                                  });

                                                case 2:
                                                  _yield$t$setIframeAsy6 = _context15.sent;
                                                  doc = _yield$t$setIframeAsy6.document;
                                                  iframe = _yield$t$setIframeAsy6.iframe;
                                                  t.subTest("Checking page: ".concat(i), function (t) {
                                                    t.ok(t.assertRowsExportedWithoutGaps(doc, false, false, false), 'Rows exported without gaps');
                                                    t.ok(t.assertTicksExportedWithoutGaps(doc), 'Ticks exported without gaps');
                                                    var exportedRows = Array.from(doc.querySelectorAll('.b-timeline-subgrid .b-grid-row'));
                                                    exportedRows.forEach(function (el) {
                                                      var id = parseInt(el.dataset.id);
                                                      indices.add(id);
                                                    });
                                                    iframe.remove();
                                                  });

                                                case 6:
                                                case "end":
                                                  return _context15.stop();
                                              }
                                            }
                                          }, _loop6);
                                        });
                                        i = 0;

                                      case 6:
                                        if (!(i < html.length)) {
                                          _context16.next = 11;
                                          break;
                                        }

                                        return _context16.delegateYield(_loop6(i), "t0", 8);

                                      case 8:
                                        i++;
                                        _context16.next = 6;
                                        break;

                                      case 11:
                                        t.is(indices.size, scheduler.resourceStore.count, 'All rows are exported');
                                        resolve();

                                      case 13:
                                      case "end":
                                        return _context16.stop();
                                    }
                                  }
                                }, _callee10);
                              }));

                              return function (_x9) {
                                return _ref9.apply(this, arguments);
                              };
                            }());
                          });

                        case 2:
                        case "end":
                          return _context17.stop();
                      }
                    }
                  }, _callee11);
                }));
                return _assertExport7.apply(this, arguments);
              };

              assertExport = function _assertExport8(_x8) {
                return _assertExport7.apply(this, arguments);
              };

              _context18.next = 4;
              return t.createSchedulerForExport({
                rowsPerPage: 20,
                horizontalPages: 1,
                verticalPages: 1,
                startDate: new Date(2020, 6, 12),
                endDate: new Date(2020, 6, 26),
                config: {
                  barMargin: 0,
                  crudManager: {
                    autoLoad: true,
                    transport: {
                      load: {
                        url: 'features/export/MultiPageVertical_data.json'
                      }
                    }
                  }
                }
              });

            case 4:
              _yield$t$createSchedu6 = _context18.sent;
              scheduler = _yield$t$createSchedu6.scheduler;
              _context18.next = 8;
              return scheduler.crudManager.await('load');

            case 8:
              _context18.next = 10;
              return assertExport(false);

            case 10:
              _context18.next = 12;
              return assertExport(true);

            case 12:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x7) {
      return _ref8.apply(this, arguments);
    };
  }());
});