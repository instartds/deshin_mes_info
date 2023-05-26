function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest( /*#__PURE__*/function () {
  var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
    var sched, taskEl, firstTimeCellEl, task, verifyEventSignature, verifyScheduleEventSignature, verifyKeyEventSignature, removeEventListeners;
    return regeneratorRuntime.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            verifyKeyEventSignature = function _verifyKeyEventSignat(_ref4, expectedType) {
              var scheduler = _ref4.source,
                  assignmentRecord = _ref4.assignmentRecord,
                  eventRecord = _ref4.eventRecord,
                  eventRecords = _ref4.eventRecords,
                  assignmentRecords = _ref4.assignmentRecords,
                  event = _ref4.event;

              /**
               * Triggered when a keydown event is observed if there are selected events.
               * @event eventKeyDown
               * @param {Scheduler.view.Scheduler} source This Scheduler
               * @param {Scheduler.model.EventModel[]} eventRecords Event records
               * @param {Scheduler.model.AssignmentModel[]} assignmentRecords Assignment records
               * @param {KeyboardEvent} event Browser event
               */
              t.it('Should fire correct params for ' + event.type, function (t) {
                t.is(eventRecords.length, 1, '1 event selected');
                t.is(assignmentRecords.length, 1, '1 assignment selected');
                t.is(sched, scheduler, 'Correct argument for source: ' + event.type);
                t.ok(eventRecords[0].isEvent, 'Correct argument for eventRecord: ' + event.type);
                t.ok(assignmentRecords[0].isAssignment, 'Correct argument for assignmentRecord: ' + event.type);
                t.ok(event.type === expectedType && event.key === 'Enter', "Correct argument for event: ".concat(expectedType)); // Backwards compat

                t.isDeeply(eventRecords, eventRecord, 'Old singular param works');
                t.isDeeply(assignmentRecords, assignmentRecord, 'Old singular param works');
              });
            };

            verifyScheduleEventSignature = function _verifyScheduleEventS(_ref3) {
              var scheduler = _ref3.source,
                  date = _ref3.date,
                  tickStartDate = _ref3.tickStartDate,
                  tickEndDate = _ref3.tickEndDate,
                  index = _ref3.index,
                  resourceRecord = _ref3.resourceRecord,
                  event = _ref3.event;

              /**
               * @event scheduledblclick
               * Fires after a doubleclick on the schedule area
               * @param {SchedulerView} scheduler The scheduler object
               * @param {Date} clickedDate The clicked date
               * @param {Number} rowIndex The row index
               * @param {Event} e The event object
               */
              t.it('Should fire correct params for ' + event.type, function (t) {
                t.is(sched, scheduler, 'Correct argument for schedule' + event.type);
                t.ok(date instanceof Date, 'Correct argument for schedule' + event.type);
                t.ok(tickStartDate instanceof Date, 'Correct argument for schedule' + event.type);
                t.ok(tickEndDate instanceof Date, 'Correct argument for schedule' + event.type);
                t.is(index, 0, 'Correct 3rd argument for schedule' + event.type);
                t.isaOk(resourceRecord, ResourceModel, 'Correct argument for schedule' + event.type);
              });
            };

            verifyEventSignature = function _verifyEventSignature(_ref2) {
              var scheduler = _ref2.source,
                  eventRecord = _ref2.eventRecord,
                  event = _ref2.event;

              /**
               * @event event_xxx
               * Fires when xxx
               * @param {SchedulerView}    scheduler The scheduler view object
               * @param {EventModel}  eventRecord The event record
               * @param {Event}  e The event object
               */
              t.it('Should fire correct params for ' + event.type, function (t) {
                t.is(scheduler, sched, 'Correct 1st argument for event' + event.type);
                t.is(eventRecord, task, 'Correct 2nd argument for event' + event.type);
              });
            };

            t.resetCursorPosition = false;
            _context.next = 6;
            return t.getSchedulerAsync({
              width: 420,
              features: {
                eventEdit: false,
                scheduleMenu: false,
                eventMenu: false
              }
            }, 1);

          case 6:
            sched = _context.sent;
            taskEl = sched.getElementFromEventRecord(sched.eventStore.first);
            firstTimeCellEl = document.querySelector('.b-sch-timeaxis-cell');
            task = sched.resolveEventRecord(taskEl);
            removeEventListeners = sched.on({
              eventclick: verifyEventSignature,
              eventdblclick: verifyEventSignature,
              eventcontextmenu: verifyEventSignature,
              eventmouseenter: verifyEventSignature,
              eventmouseleave: verifyEventSignature
            });
            sched.on({
              schedulemousemove: verifyScheduleEventSignature,
              scheduleclick: verifyScheduleEventSignature,
              scheduledblclick: verifyScheduleEventSignature,
              schedulecontextmenu: verifyScheduleEventSignature,
              eventkeyup: function eventkeyup(event) {
                return verifyKeyEventSignature(event, 'keyup');
              },
              eventkeydown: function eventkeydown(event) {
                return verifyKeyEventSignature(event, 'keydown');
              },
              once: true
            });
            ['eventdblclick', 'eventcontextmenu', 'eventkeydown', 'eventkeyup', 'scheduledblclick', 'schedulecontextmenu'].forEach(function (evName) {
              return t.willFireNTimes(sched, evName, 1);
            });
            ['eventmouseenter', 'eventmouseleave', 'schedulemousemove'].forEach(function (evName) {
              return (// These events bubble in IE8
                t.firesAtLeastNTimes(sched, evName, 1)
              );
            });
            ['eventclick', 'scheduleclick'].forEach(function (evName) {
              return t.willFireNTimes(sched, evName, 3);
            });
            t.ok(firstTimeCellEl, 'Time cell found');
            t.wontFire(sched.subGrids.normal.scrollable, 'scroll', 'Time axis should never scroll after clicking a time axis cell'); // https://app.assembla.com/spaces/bryntum/tickets/7723/details

            t.wontFire(sched, 'beforeeventdrag', 'dragging not triggered by any mousedown/up/click actions');
            t.chain({
              click: taskEl
            }, function (next) {
              t.is(t.activeElement(), taskEl.parentNode, 'Event should be focused after a click');
              next();
            }, {
              doubleClick: taskEl
            }, {
              rightClick: taskEl
            }, {
              type: '[ENTER]',
              target: taskEl
            }, {
              moveCursorTo: '.b-sch-header-timeaxis-cell',
              offset: [5, 5]
            }, function (next) {
              t.selectorNotExists('.b-sch-event-wrap.b-released', 'No released events');
              sched.eventStore.forEach(function (event) {
                return event.unassign(event.resource);
              });
              sched.eventStore.removeAll(); // Must not trigger these again.

              removeEventListeners();
              next();
            }, {
              click: firstTimeCellEl,
              offset: [5, 5]
            }, {
              doubleClick: firstTimeCellEl,
              offset: [5, 5]
            }, {
              rightClick: firstTimeCellEl,
              offset: [5, 5]
            }, {
              moveCursorTo: '.b-sch-header-timeaxis-cell'
            });

          case 19:
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