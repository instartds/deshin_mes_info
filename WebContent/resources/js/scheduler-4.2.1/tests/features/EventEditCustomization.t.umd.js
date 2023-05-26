function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, firstRec, lastRec;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler = null;
  });

  function setup() {
    return _setup.apply(this, arguments);
  }

  function _setup() {
    _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16() {
      var config,
          editRecords,
          _args16 = arguments;
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              config = _args16.length > 0 && _args16[0] !== undefined ? _args16[0] : {};
              editRecords = _args16.length > 1 && _args16[1] !== undefined ? _args16[1] : true;
              scheduler && scheduler.destroy();
              scheduler = t.getScheduler(Object.assign({
                features: {
                  eventTooltip: false,
                  eventEdit: true // is enabled by default already, but in case we change our minds...

                },
                allowOverlap: false,
                forceFit: true,
                appendTo: document.body
              }, config));
              firstRec = scheduler.eventStore.first;
              lastRec = scheduler.eventStore.last;

              if (editRecords) {
                firstRec.cls = 'FOO';
                lastRec.cls = 'BAR';
                lastRec.assign(firstRec.resource);
                lastRec.setStartDate(firstRec.endDate, true);
              }

              _context16.next = 9;
              return t.waitForProjectReady();

            case 9:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));
    return _setup.apply(this, arguments);
  }

  t.describe('legacy customization', function (t) {
    // region https://app.assembla.com/spaces/bryntum/tickets/6871
    t.it('Should display extra fields at correct positions: Test 1 and Test 2 should go last (default)', /*#__PURE__*/function () {
      var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
        var expectedWidgets, refs;
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                expectedWidgets = ['nameField', 'resourceField', 'startDateField', 'startTimeField', 'endDateField', 'endTimeField', 'recurrenceCombo', 'editRecurrenceButton', 'test1Field', 'test2Field'];
                _context.next = 3;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      extraItems: [{
                        type: 'text',
                        label: 'Test 1',
                        ref: 'test1Field'
                      }, {
                        type: 'text',
                        label: 'Test 2',
                        ref: 'test2Field'
                      }]
                    }
                  }
                }, false);

              case 3:
                // Order of widgets should be correct in config when sorted by weight
                refs = Object.entries(scheduler.eventEdit.editorConfig.items).sort(function (lhs, rhs) {
                  return lhs[1].weight - rhs[1].weight;
                }).map(function (_ref2) {
                  var _ref3 = _slicedToArray(_ref2, 1),
                      ref = _ref3[0];

                  return ref;
                });
                t.is(refs.join('|'), expectedWidgets.join('|'), 'Displays all widgets at correct positions');

              case 5:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      }));

      return function (_x) {
        return _ref.apply(this, arguments);
      };
    }());
    t.it('Should display extra fields at correct positions: Test 1 and Test 2 should go first', /*#__PURE__*/function () {
      var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
        var expectedWidgets, refs;
        return regeneratorRuntime.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                expectedWidgets = ['test1Field', 'test2Field', 'nameField', 'resourceField', 'startDateField', 'startTimeField', 'endDateField', 'endTimeField', 'recurrenceCombo', 'editRecurrenceButton'];
                _context2.next = 3;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      extraItems: [{
                        type: 'text',
                        label: 'Test 1',
                        ref: 'test1Field',
                        index: 0
                      }, {
                        type: 'text',
                        label: 'Test 2',
                        ref: 'test2Field',
                        index: 1
                      }]
                    }
                  }
                }, false);

              case 3:
                // Order of widgets should be correct in config when sorted by weight
                refs = Object.entries(scheduler.eventEdit.editorConfig.items).sort(function (lhs, rhs) {
                  return lhs[1].weight - rhs[1].weight;
                }).map(function (_ref5) {
                  var _ref6 = _slicedToArray(_ref5, 1),
                      ref = _ref6[0];

                  return ref;
                });
                t.is(refs.join('|'), expectedWidgets.join('|'), 'Displays all widgets at correct positions');

              case 5:
              case "end":
                return _context2.stop();
            }
          }
        }, _callee2);
      }));

      return function (_x2) {
        return _ref4.apply(this, arguments);
      };
    }());
    t.it('Should display extra fields at correct positions: Test 1 and Test 2 should go last (same as default)', /*#__PURE__*/function () {
      var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
        var expectedWidgets, refs;
        return regeneratorRuntime.wrap(function _callee3$(_context3) {
          while (1) {
            switch (_context3.prev = _context3.next) {
              case 0:
                expectedWidgets = ['nameField', 'resourceField', 'startDateField', 'startTimeField', 'endDateField', 'endTimeField', 'recurrenceCombo', 'editRecurrenceButton', 'test1Field', 'test2Field'];
                _context3.next = 3;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      extraItems: [{
                        type: 'text',
                        label: 'Test 2',
                        ref: 'test2Field',
                        index: 100
                      }, {
                        type: 'text',
                        label: 'Test 1',
                        ref: 'test1Field',
                        index: 99
                      }]
                    }
                  }
                }, false);

              case 3:
                // Order of widgets should be correct in config when sorted by weight
                refs = Object.entries(scheduler.eventEdit.editorConfig.items).sort(function (lhs, rhs) {
                  return lhs[1].weight - rhs[1].weight;
                }).map(function (_ref8) {
                  var _ref9 = _slicedToArray(_ref8, 1),
                      ref = _ref9[0];

                  return ref;
                });
                t.is(refs.join('|'), expectedWidgets.join('|'), 'Displays all widgets at correct positions');

              case 5:
              case "end":
                return _context3.stop();
            }
          }
        }, _callee3);
      }));

      return function (_x3) {
        return _ref7.apply(this, arguments);
      };
    }());
    t.it('Should display extra fields at correct positions: Test 1 should go first, Test 2 should go last (default)', /*#__PURE__*/function () {
      var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
        var expectedWidgets, refs;
        return regeneratorRuntime.wrap(function _callee4$(_context4) {
          while (1) {
            switch (_context4.prev = _context4.next) {
              case 0:
                expectedWidgets = ['test1Field', 'nameField', 'resourceField', 'startDateField', 'startTimeField', 'endDateField', 'endTimeField', 'recurrenceCombo', 'editRecurrenceButton', 'test2Field'];
                _context4.next = 3;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      extraItems: [{
                        type: 'text',
                        label: 'Test 1',
                        ref: 'test1Field',
                        index: 0
                      }, {
                        type: 'text',
                        label: 'Test 2',
                        ref: 'test2Field'
                      }]
                    }
                  }
                }, false);

              case 3:
                // Order of widgets should be correct in config when sorted by weight
                refs = Object.entries(scheduler.eventEdit.editorConfig.items).sort(function (lhs, rhs) {
                  return lhs[1].weight - rhs[1].weight;
                }).map(function (_ref11) {
                  var _ref12 = _slicedToArray(_ref11, 1),
                      ref = _ref12[0];

                  return ref;
                });
                t.is(refs.join('|'), expectedWidgets.join('|'), 'Displays all widgets at correct positions');

              case 5:
              case "end":
                return _context4.stop();
            }
          }
        }, _callee4);
      }));

      return function (_x4) {
        return _ref10.apply(this, arguments);
      };
    }());
    t.it('Should display extra fields at correct positions: Test 1 should go first, Test 2 should go last (same as default)', /*#__PURE__*/function () {
      var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
        var expectedWidgets, refs;
        return regeneratorRuntime.wrap(function _callee5$(_context5) {
          while (1) {
            switch (_context5.prev = _context5.next) {
              case 0:
                expectedWidgets = ['test1Field', 'nameField', 'resourceField', 'startDateField', 'startTimeField', 'endDateField', 'endTimeField', 'recurrenceCombo', 'editRecurrenceButton', 'test2Field'];
                _context5.next = 3;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      extraItems: [{
                        type: 'text',
                        label: 'Test 1',
                        ref: 'test1Field',
                        index: 0
                      }, {
                        type: 'text',
                        label: 'Test 2',
                        ref: 'test2Field',
                        index: 100
                      }]
                    }
                  }
                }, false);

              case 3:
                // Order of widgets should be correct in config when sorted by weight
                refs = Object.entries(scheduler.eventEdit.editorConfig.items).sort(function (lhs, rhs) {
                  return lhs[1].weight - rhs[1].weight;
                }).map(function (_ref14) {
                  var _ref15 = _slicedToArray(_ref14, 1),
                      ref = _ref15[0];

                  return ref;
                });
                t.is(refs.join('|'), expectedWidgets.join('|'), 'Displays all widgets at correct positions');

              case 5:
              case "end":
                return _context5.stop();
            }
          }
        }, _callee5);
      }));

      return function (_x5) {
        return _ref13.apply(this, arguments);
      };
    }()); // endregion https://app.assembla.com/spaces/bryntum/tickets/6871

    t.it('Should support configuring startDate, startTime, endDate and endTime fields', /*#__PURE__*/function () {
      var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
        return regeneratorRuntime.wrap(function _callee6$(_context6) {
          while (1) {
            switch (_context6.prev = _context6.next) {
              case 0:
                _context6.next = 2;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      startDateConfig: {
                        editable: false
                      },
                      endDateConfig: {
                        editable: false
                      },
                      startTimeConfig: {
                        editable: false
                      },
                      endTimeConfig: {
                        editable: false
                      }
                    }
                  }
                }, false);

              case 2:
                scheduler.editEvent(scheduler.eventStore.first);
                t.chain({
                  waitFor: function waitFor() {
                    return bryntum.query('timefield');
                  }
                }, function () {
                  var edit = scheduler.features.eventEdit;
                  t.is(edit.startDateField.editable, false, 'startDateConfig');
                  t.is(edit.startTimeField.editable, false, 'startDateConfig');
                  t.is(edit.endDateField.editable, false, 'startTimeConfig');
                  t.is(edit.endTimeField.editable, false, 'endTimeConfig');
                });

              case 4:
              case "end":
                return _context6.stop();
            }
          }
        }, _callee6);
      }));

      return function (_x6) {
        return _ref16.apply(this, arguments);
      };
    }()); // https://app.assembla.com/spaces/bryntum/tickets/7519

    t.it('Should create accessors for all fields with ref or id', /*#__PURE__*/function () {
      var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
        var expectedAccessors, async;
        return regeneratorRuntime.wrap(function _callee7$(_context7) {
          while (1) {
            switch (_context7.prev = _context7.next) {
              case 0:
                expectedAccessors = ['nameField', 'resourceField', 'startDateField', 'startTimeField', 'endDateField', 'endTimeField', 'test2', 'test1', 'saveButton', 'deleteButton', 'cancelButton'];
                async = t.beginAsync();
                _context7.next = 4;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      extraItems: [{
                        type: 'text',
                        label: 'Test 2',
                        id: 'test2'
                      }, {
                        type: 'text',
                        label: 'Test 1',
                        ref: 'test1'
                      }]
                    }
                  },
                  listeners: {
                    beforeEventEditShow: function beforeEventEditShow(_ref18) {
                      var eventEdit = _ref18.eventEdit;
                      expectedAccessors.forEach(function (name) {
                        return t.ok(name in eventEdit, "Accessor for ".concat(name, " found"));
                      });
                      t.endAsync(async);
                    }
                  }
                }, false);

              case 4:
                scheduler.editEvent(scheduler.eventStore.first);

              case 5:
              case "end":
                return _context7.stop();
            }
          }
        }, _callee7);
      }));

      return function (_x7) {
        return _ref17.apply(this, arguments);
      };
    }());
    t.it('Should be able to filter resource combo', /*#__PURE__*/function () {
      var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
        return regeneratorRuntime.wrap(function _callee8$(_context8) {
          while (1) {
            switch (_context8.prev = _context8.next) {
              case 0:
                _context8.next = 2;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: true
                  },
                  listeners: {
                    beforeEventEditShow: function beforeEventEditShow(_ref20) {
                      var eventEdit = _ref20.eventEdit;
                      eventEdit.resourceField.store.filter(function (r) {
                        return r.name.length > 3;
                      });
                    }
                  }
                }, false);

              case 2:
                scheduler.editEvent(scheduler.eventStore.first);
                t.chain({
                  click: '.b-combo .b-fieldtrigger'
                }, function () {
                  t.selectorCountIs('.b-list-item', 5, 'Combo filtered');
                });

              case 4:
              case "end":
                return _context8.stop();
            }
          }
        }, _callee8);
      }));

      return function (_x8) {
        return _ref19.apply(this, arguments);
      };
    }()); // https://app.assembla.com/spaces/bryntum/tickets/8878

    t.it('Specifying listeners for event editor should not break drag create feature and tooltip', /*#__PURE__*/function () {
      var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
        var counter, beforeCloseHandler;
        return regeneratorRuntime.wrap(function _callee9$(_context9) {
          while (1) {
            switch (_context9.prev = _context9.next) {
              case 0:
                counter = 0; // failed to check that this function is called with isCalledOnce, used `counter` instead

                beforeCloseHandler = function beforeCloseHandler() {
                  counter++;
                };

                scheduler = t.getScheduler({
                  features: {
                    eventTooltip: true,
                    eventEdit: {
                      editorConfig: {
                        listeners: {
                          beforeclose: beforeCloseHandler
                        }
                      }
                    }
                  }
                });
                t.firesOnce(scheduler.features.eventEdit.getEditor(), 'beforehide');
                t.chain({
                  drag: '.b-sch-timeaxis-cell',
                  fromOffset: [2, 2],
                  by: [50, 0]
                }, {
                  click: 'button:contains(Cancel)'
                }, {
                  waitForSelectorNotFound: '.b-eventeditor:not(.b-hidden)'
                }, function (next) {
                  t.is(counter, 1, 'beforeCloseHandler has been called once');
                  next();
                }, {
                  waitForSelectorNotFound: '.b-sch-dragcreator-proxy'
                }, {
                  moveCursorTo: '.b-sch-event'
                }, {
                  waitForSelector: '.b-sch-event-tooltip'
                });

              case 5:
              case "end":
                return _context9.stop();
            }
          }
        }, _callee9);
      }));

      return function (_x9) {
        return _ref21.apply(this, arguments);
      };
    }()); // https://app.assembla.com/spaces/bryntum/tickets/7809

    t.it('Changing eventType should toggle fields', /*#__PURE__*/function () {
      var _ref22 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
        var editor;
        return regeneratorRuntime.wrap(function _callee10$(_context10) {
          while (1) {
            switch (_context10.prev = _context10.next) {
              case 0:
                _context10.next = 2;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      extraItems: [{
                        type: 'combo',
                        cls: 'event-type',
                        label: 'Type',
                        ref: 'eventTypeField',
                        name: 'eventType',
                        items: ['Shazam', 'Meeting']
                      }, {
                        type: 'text',
                        label: 'Location',
                        ref: 'locationField',
                        dataset: {
                          eventType: 'Meeting'
                        }
                      }]
                    }
                  },
                  eventStore: t.getEventStore({
                    fields: ['eventType']
                  })
                }, false);

              case 2:
                t.chain({
                  dblclick: '.b-sch-event'
                }, function (next) {
                  editor = scheduler.features.eventEdit.editor;
                  t.is(editor.widgetMap.locationField.isVisible, false, 'Location not visible');
                  next();
                }, {
                  type: 'Meeting[ENTER]',
                  target: '.event-type input',
                  clearExisting: true
                }, function (next) {
                  t.is(editor.widgetMap.locationField.isVisible, true, 'Location visible');
                  t.selectorExists('.b-eventeditor[data-event-type=Meeting]', 'Event type applied to dataset');
                  next();
                }, {
                  click: 'button:textEquals(Save)'
                }, {
                  dblclick: '.b-sch-event'
                }, function (next) {
                  t.is(editor.widgetMap.locationField.isVisible, true, 'Location visible');
                  t.selectorExists('.b-eventeditor[data-event-type=Meeting]', 'Event type applied to dataset');
                  next();
                }, {
                  type: 'Shazam[ENTER]',
                  target: '.event-type input',
                  clearExisting: true
                }, function () {
                  t.is(editor.widgetMap.locationField.isVisible, false, 'Location not visible');
                  t.selectorExists('.b-eventeditor[data-event-type=Shazam]', 'Event type applied to dataset');
                });

              case 3:
              case "end":
                return _context10.stop();
            }
          }
        }, _callee10);
      }));

      return function (_x10) {
        return _ref22.apply(this, arguments);
      };
    }());
  });
  t.describe('items object-based customization', function (t) {
    t.it('Should insert items according to weight', /*#__PURE__*/function () {
      var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
        var expectedWidgets, refs;
        return regeneratorRuntime.wrap(function _callee11$(_context11) {
          while (1) {
            switch (_context11.prev = _context11.next) {
              case 0:
                expectedWidgets = ['test1Field', 'nameField', 'resourceField', 'startDateField', 'startTimeField', 'endDateField', 'endTimeField', 'recurrenceCombo', 'editRecurrenceButton', 'test2Field'];
                _context11.next = 3;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      items: {
                        test1Field: {
                          type: 'text',
                          label: 'Test 1',
                          ref: 'test1Field',
                          weight: 0
                        },
                        test2Field: {
                          type: 'text',
                          label: 'Test 2',
                          ref: 'test2Field',
                          weight: 2000
                        }
                      }
                    }
                  }
                }, false);

              case 3:
                // Order of widgets should be correct in config when sorted by weight
                refs = Object.entries(scheduler.eventEdit.editorConfig.items).sort(function (lhs, rhs) {
                  return lhs[1].weight - rhs[1].weight;
                }).map(function (_ref24) {
                  var _ref25 = _slicedToArray(_ref24, 1),
                      ref = _ref25[0];

                  return ref;
                });
                t.is(refs.join('|'), expectedWidgets.join('|'), 'Displays all widgets at correct positions');

              case 5:
              case "end":
                return _context11.stop();
            }
          }
        }, _callee11);
      }));

      return function (_x11) {
        return _ref23.apply(this, arguments);
      };
    }());
    t.it('Should support configuring startDate, startTime, endDate and endTime fields', /*#__PURE__*/function () {
      var _ref26 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
        return regeneratorRuntime.wrap(function _callee12$(_context12) {
          while (1) {
            switch (_context12.prev = _context12.next) {
              case 0:
                _context12.next = 2;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      items: {
                        startDateField: {
                          editable: false
                        },
                        endDateField: {
                          editable: false
                        },
                        startTimeField: {
                          editable: false
                        },
                        endTimeField: {
                          editable: false
                        }
                      }
                    }
                  }
                }, false);

              case 2:
                scheduler.editEvent(scheduler.eventStore.first);
                t.chain({
                  waitFor: function waitFor() {
                    return bryntum.query('timefield');
                  }
                }, function () {
                  var edit = scheduler.features.eventEdit;
                  t.is(edit.startDateField.editable, false, 'startDateConfig');
                  t.is(edit.startTimeField.editable, false, 'startDateConfig');
                  t.is(edit.endDateField.editable, false, 'startTimeConfig');
                  t.is(edit.endTimeField.editable, false, 'endTimeConfig');
                });

              case 4:
              case "end":
                return _context12.stop();
            }
          }
        }, _callee12);
      }));

      return function (_x12) {
        return _ref26.apply(this, arguments);
      };
    }()); // https://app.assembla.com/spaces/bryntum/tickets/7519

    t.it('Should create accessors for all fields with ref or id', /*#__PURE__*/function () {
      var _ref27 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
        var expectedAccessors, async;
        return regeneratorRuntime.wrap(function _callee13$(_context13) {
          while (1) {
            switch (_context13.prev = _context13.next) {
              case 0:
                expectedAccessors = ['nameField', 'resourceField', 'startDateField', 'startTimeField', 'endDateField', 'endTimeField', 'test2', 'test1', 'saveButton', 'deleteButton', 'cancelButton'];
                async = t.beginAsync();
                _context13.next = 4;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      items: {
                        test2: {
                          type: 'text',
                          label: 'Test 2',
                          id: 'test2'
                        },
                        test1: {
                          type: 'text',
                          label: 'Test 1'
                        }
                      }
                    }
                  },
                  listeners: {
                    beforeEventEditShow: function beforeEventEditShow(_ref28) {
                      var eventEdit = _ref28.eventEdit;
                      expectedAccessors.forEach(function (name) {
                        return t.ok(name in eventEdit, "Accessor for ".concat(name, " found"));
                      });
                      t.endAsync(async);
                    }
                  }
                }, false);

              case 4:
                scheduler.editEvent(scheduler.eventStore.first);

              case 5:
              case "end":
                return _context13.stop();
            }
          }
        }, _callee13);
      }));

      return function (_x13) {
        return _ref27.apply(this, arguments);
      };
    }());
    t.it('Should be able to filter resource combo', /*#__PURE__*/function () {
      var _ref29 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
        return regeneratorRuntime.wrap(function _callee14$(_context14) {
          while (1) {
            switch (_context14.prev = _context14.next) {
              case 0:
                _context14.next = 2;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: true
                  },
                  listeners: {
                    beforeEventEditShow: function beforeEventEditShow(_ref30) {
                      var eventEdit = _ref30.eventEdit;
                      eventEdit.resourceField.store.filter(function (r) {
                        return r.name.length > 3;
                      });
                    }
                  }
                }, false);

              case 2:
                scheduler.editEvent(scheduler.eventStore.first);
                t.chain({
                  click: '.b-combo .b-fieldtrigger'
                }, function () {
                  t.selectorCountIs('.b-list-item', 5, 'Combo filtered');
                });

              case 4:
              case "end":
                return _context14.stop();
            }
          }
        }, _callee14);
      }));

      return function (_x14) {
        return _ref29.apply(this, arguments);
      };
    }()); // https://app.assembla.com/spaces/bryntum/tickets/8878

    t.it('Specifying listeners for event editor should not break drag create feature and tooltip', function (t) {
      var counter = 0; // failed to check that this function is called with isCalledOnce, used `counter` instead

      var beforeCloseHandler = function beforeCloseHandler() {
        counter++;
      };

      scheduler = t.getScheduler({
        features: {
          eventTooltip: true,
          eventEdit: {
            editorConfig: {
              listeners: {
                beforeclose: beforeCloseHandler
              }
            }
          }
        }
      });
      t.firesOnce(scheduler.features.eventEdit.getEditor(), 'beforehide');
      t.chain({
        drag: '.b-sch-timeaxis-cell',
        fromOffset: [2, 2],
        by: [50, 0]
      }, {
        click: 'button:contains(Cancel)'
      }, {
        waitForSelectorNotFound: '.b-eventeditor:not(.b-hidden)'
      }, function (next) {
        t.is(counter, 1, 'beforeCloseHandler has been called once');
        next();
      }, {
        waitForSelectorNotFound: '.b-sch-dragcreator-proxy'
      }, {
        moveCursorTo: '.b-sch-event'
      }, {
        waitForSelector: '.b-sch-event-tooltip'
      });
    }); // https://app.assembla.com/spaces/bryntum/tickets/7809

    t.it('Changing eventType should toggle fields', /*#__PURE__*/function () {
      var _ref31 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
        var editor;
        return regeneratorRuntime.wrap(function _callee15$(_context15) {
          while (1) {
            switch (_context15.prev = _context15.next) {
              case 0:
                _context15.next = 2;
                return setup({
                  features: {
                    eventTooltip: false,
                    eventEdit: {
                      items: {
                        eventTypeField: {
                          type: 'combo',
                          cls: 'event-type',
                          label: 'Type',
                          ref: 'eventTypeField',
                          name: 'eventType',
                          items: ['Shazam', 'Meeting']
                        },
                        locationField: {
                          type: 'text',
                          label: 'Location',
                          ref: 'locationField',
                          dataset: {
                            eventType: 'Meeting'
                          }
                        }
                      }
                    }
                  },
                  eventStore: t.getEventStore({
                    fields: ['eventType']
                  })
                }, false);

              case 2:
                t.chain({
                  dblclick: '.b-sch-event'
                }, function (next) {
                  editor = scheduler.features.eventEdit.editor;
                  t.is(editor.widgetMap.locationField.isVisible, false, 'Location not visible');
                  next();
                }, {
                  type: 'Meeting[ENTER]',
                  target: '.event-type input',
                  clearExisting: true
                }, function (next) {
                  t.is(editor.widgetMap.locationField.isVisible, true, 'Location visible');
                  t.selectorExists('.b-eventeditor[data-event-type=Meeting]', 'Event type applied to dataset');
                  next();
                }, {
                  click: 'button:textEquals(Save)'
                }, {
                  dblclick: '.b-sch-event'
                }, function (next) {
                  t.is(editor.widgetMap.locationField.isVisible, true, 'Location visible');
                  t.selectorExists('.b-eventeditor[data-event-type=Meeting]', 'Event type applied to dataset');
                  next();
                }, {
                  type: 'Shazam[ENTER]',
                  target: '.event-type input',
                  clearExisting: true
                }, function () {
                  t.is(editor.widgetMap.locationField.isVisible, false, 'Location not visible');
                  t.selectorExists('.b-eventeditor[data-event-type=Shazam]', 'Event type applied to dataset');
                });

              case 3:
              case "end":
                return _context15.stop();
            }
          }
        }, _callee15);
      }));

      return function (_x15) {
        return _ref31.apply(this, arguments);
      };
    }());
  });
});