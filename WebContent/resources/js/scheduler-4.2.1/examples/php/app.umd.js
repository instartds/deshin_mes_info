function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    Toast = _bryntum$scheduler.Toast; // Set random PHP session ID if it doesn't exist

var cookie = 'PHPSESSID=scheduler-php';

if (!document.cookie.includes(cookie)) {
  document.cookie = "".concat(cookie, "-").concat(Math.random().toString(16).substring(2));
}

var processException = function processException(event) {
  var _response$parsedJson;

  var action = event.action,
      response = event.response,
      serverMessage = response === null || response === void 0 ? void 0 : (_response$parsedJson = response.parsedJson) === null || _response$parsedJson === void 0 ? void 0 : _response$parsedJson.msg,
      exceptionText = "Command \"".concat(action, "\" failed.").concat(serverMessage ? " Server response: ".concat(serverMessage) : '');
  Toast.show({
    html: exceptionText,
    cls: 'php-demo-error-message',
    timeout: 5000
  });

  if (!serverMessage) {
    console.error("App Exception: ".concat(exceptionText), event);
  }
};

var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2018, 4, 21, 6),
  endDate: new Date(2018, 4, 21, 18),
  viewPreset: 'hourAndDay',
  rowHeight: 50,
  barMargin: 5,
  eventColor: 'blue',
  passStartEndParameters: true,
  features: {
    // Configure event editor to display 'brand' as resource name
    eventEdit: {
      resourceFieldConfig: {
        displayField: 'car'
      }
    }
  },
  columns: [{
    text: 'Id',
    field: 'id',
    width: 100,
    editor: false,
    hidden: true
  }, {
    text: 'Car',
    field: 'car',
    width: 150
  }, {
    type: 'date',
    text: 'Modified',
    field: 'dt',
    width: 90,
    format: 'HH:mm:ss',
    editor: false,
    hidden: true
  }],
  resourceStore: {
    // Add some custom fields
    fields: ['car', 'dt'],
    // Setup urls
    createUrl: 'php/resource/create.php',
    readUrl: 'php/resource/read.php',
    updateUrl: 'php/resource/update.php',
    deleteUrl: 'php/resource/delete.php',
    // Load and save automatically
    autoLoad: true,
    autoCommit: true,
    // Send as form data and not a JSON payload
    sendAsFormData: true,
    // Make it read only to prevent changes while committing
    listeners: {
      beforeCommit: function beforeCommit() {
        scheduler.readOnly = true;
      },
      commit: function commit() {
        scheduler.readOnly = false;
      },
      exception: function exception(event) {
        processException(event);
        scheduler.readOnly = false;
      }
    }
  },
  eventStore: {
    // Add a custom field and redefine durationUnit to default to hours
    fields: ['dt', {
      name: 'durationUnit',
      defaultValue: 'hour'
    }],
    // Setup urls
    createUrl: 'php/event/create.php',
    readUrl: 'php/event/read.php',
    updateUrl: 'php/event/update.php',
    deleteUrl: 'php/event/delete.php',
    // Load and save automatically
    autoLoad: true,
    autoCommit: true,
    // Send as form data and not a JSON payload
    sendAsFormData: true,
    // Make it read only to prevent changes while committing
    listeners: {
      beforeCommit: function beforeCommit() {
        scheduler.readOnly = true;
      },
      commit: function commit() {
        scheduler.readOnly = false;
      },
      exception: function exception(event) {
        processException(event);
        scheduler.readOnly = false;
      }
    }
  },
  tbar: [{
    type: 'button',
    ref: 'reloadButton',
    icon: 'b-fa b-fa-sync',
    text: 'Reload scheduler',
    onAction: function onAction() {
      return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                _context.next = 2;
                return Promise.all([scheduler.resourceStore.load(), scheduler.eventStore.load()]);

              case 2:
                Toast.show('Data reloaded');

              case 3:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      }))();
    }
  }, {
    type: 'button',
    ref: 'resetButton',
    color: 'b-red',
    icon: 'b-fa b-fa-recycle',
    text: 'Reset database',
    onAction: function onAction() {
      return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
        return regeneratorRuntime.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                _context2.next = 2;
                return Promise.all([scheduler.resourceStore.load({
                  reset: true
                }), scheduler.eventStore.load({
                  reset: true
                })]);

              case 2:
                Toast.show('Database was reset');

              case 3:
              case "end":
                return _context2.stop();
            }
          }
        }, _callee2);
      }))();
    }
  }]
});