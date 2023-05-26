function _createForOfIteratorHelper(o, allowArrayLike) { var it = typeof Symbol !== "undefined" && o[Symbol.iterator] || o["@@iterator"]; if (!it) { if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") { if (it) o = it; var i = 0; var F = function F() {}; return { s: F, n: function n() { if (i >= o.length) return { done: true }; return { done: false, value: o[i++] }; }, e: function e(_e2) { throw _e2; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var normalCompletion = true, didErr = false, err; return { s: function s() { it = it.call(o); }, n: function n() { var step = it.next(); normalCompletion = step.done; return step; }, e: function e(_e3) { didErr = true; err = _e3; }, f: function f() { try { if (!normalCompletion && it.return != null) it.return(); } finally { if (didErr) throw err; } } }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var _bryntum$scheduler = bryntum.scheduler,
    WidgetHelper = _bryntum$scheduler.WidgetHelper,
    DomHelper = _bryntum$scheduler.DomHelper,
    EventModel = _bryntum$scheduler.EventModel,
    Toast = _bryntum$scheduler.Toast,
    Scheduler = _bryntum$scheduler.Scheduler;
var userNames = ['Austin', 'Bennett', 'Christopher', 'Dominic', 'Eddi', 'Felix', 'Grady', 'Henry', 'Ivan', 'Jack', 'Kane', 'Lambert', 'Mickey', 'Nolan', 'Oliver', 'Princeton', 'Quentin', 'Remi', 'Samson', 'Thomas', 'Urbain', 'Vance', 'Weston', 'Xavier', 'York', 'Zane', 'Ariel', 'Brinley', 'Catarina', 'Diana', 'Emma', 'Fiona', 'Gabriella', 'Harmony', 'Isabella', 'Jillian', 'Katalina', 'Lily', 'Matilda', 'Nadia', 'Olivia', 'Priscilla', 'Quinn', 'Renee', 'Staci', 'Trinity', 'Ursula', 'Victoria', 'Wendy', 'Xenia', 'Yasmine', 'Zoe'],
    eventNames = ['Important client', 'Customer meeting', 'Coffee pause', 'Wedding', 'Visit parents', 'Visit post office', 'Visit to school', 'Presentation', 'Movie'],
    eventIcons = ['b-fa-exclamation-circle', 'b-fa-calendar', 'b-fa-cat', 'b-fa-info', 'b-fa-clock', 'b-fa-calendar', 'b-fa-calendar', 'b-fa-car', 'b-fa-clock', 'b-fa-video', 'b-fa-calendar-alt', 'b-fa-candy-corn', 'b-fa-film', 'b-fa-train'],
    demoServer = /bryntum.com/.test(window.location.hostname) ? 'wss://dev.bryntum.com:8081' : undefined;
/**
 * WebSocketHelper class to support scheduler data sending and receiving via WebSocket.
 * Subscribes to Scheduler events and sends them via WebSocket to server.
 * Receives messages from server and updates scheduler events and resources based on received data.
 */

var WebSocketHelper = /*#__PURE__*/function () {
  //region Constructor

  /**
   * Constructs WebSocketHelper class for scheduler instance
   * @param scheduler
   */
  function WebSocketHelper(scheduler, label) {
    _classCallCheck(this, WebSocketHelper);

    var me = this,
        params = me.getUrlParams(),
        autoLogin = params.thumb || params.auto;
    me._scheduler = scheduler;
    me._ignoreChange = false;
    me._protocol = window.location.protocol === 'https' ? 'wss://' : 'ws://';
    me._host = params.wsHost || demoServer || "".concat(me._protocol).concat(window.location.hostname, ":8080");
    me._userName = params.wsName || WebSocketHelper.random(userNames);
    me._debug = params.debug;
    me._label = label; // Setup event store change listener

    scheduler.eventStore.on({
      change: 'onEventStoreChange',
      addConfirmed: 'onEventStoreAddConfirmed',
      thisObj: me
    }); // Update event properties on create

    scheduler.on({
      beforeEventEdit: me.onBeforeEventEdit,
      eventDrag: me.onEventDrag,
      // Always send an event after a drop, in case it was aborted or dropped back to same position (which does not trigger change)
      afterEventDrop: me.onEventDrop,
      thisObj: me
    });
    me.setConnectedState(false);

    if (autoLogin) {
      me.wsOpen();
    }
  } //endregion
  //region Getters and setters

  /**
   * WebSocket server host name and port
   * @returns {string} host name and port
   */


  _createClass(WebSocketHelper, [{
    key: "host",
    get: function get() {
      return this._host;
    },
    set: function set(value) {
      this._host = value;
    }
    /**
     * WebSocket user name
     * @returns {String} user name
     */

  }, {
    key: "userName",
    get: function get() {
      return this._userName;
    },
    set: function set(value) {
      this._userName = value;
    }
    /**
     * WebSocket state
     * @returns {string} WebSocket state
     */

  }, {
    key: "state",
    get: function get() {
      return this._socket ? this._socket.readyState : null;
    } //endregion
    //region WebSocket methods

    /**
     * Send a command to the server
     * @param {Object} data Accepts an object that will be transmitted as a JSON string
     */

  }, {
    key: "wsSend",
    value: function wsSend(data) {
      var socket = this._socket;

      if (socket.readyState === WebSocket.OPEN) {
        var json = JSON.stringify(data);
        this.debugLog(">>> ".concat(json));
        socket.send(json); // For debug and testing purposes

        this._scheduler.trigger('wsSend', {
          data: data
        });
      }
    }
  }, {
    key: "wsResetData",
    value:
    /**
     * Send reset data command to the server
     */
    function wsResetData() {
      this.wsSend({
        command: 'reset'
      });
    }
  }, {
    key: "wsReceive",
    value:
    /**
     * Processes received data
     * @data {Object} data JSON data object
     */
    function wsReceive(data) {
      var me = this,
          scheduler = me._scheduler,
          eventRecord = data.id ? scheduler.eventStore.getById(data.id) : null;
      me.debugLog("<<< ".concat(JSON.stringify(data))); // For debug and testing purposes

      me._scheduler.trigger('wsReceive', {
        data: data
      });

      switch (data.command) {
        // User has connected to the server
        case 'hello':
          WidgetHelper.toast("".concat(data.userName, " just connected"));
          break;
        // User has disconnected from the server

        case 'bye':
          WidgetHelper.toast("".concat(data.userName, " disconnected"));
          break;

        case 'users':
          WebSocketHelper.showOnlineUsers(data.users);
          break;
        // User reset the data

        case 'reset':
          if (data.userName === me._userName) {
            WidgetHelper.toast("Data was reset");
          } else {
            WidgetHelper.toast("".concat(data.userName, " reset the data"));
          }

          break;
        // Received dataset from server

        case 'dataset':
          Object.assign(scheduler, data.dataset);
          scheduler.unmaskBody();
          me.updateTimeLine();
          break;
        // Updating an event (the record), reflect changes

        case 'updateEvent':
          // Allow dragging & resizing that was disabled by other user performing some operation
          eventRecord.draggable = true;
          eventRecord.resizeable = true;
          Object.keys(data.changes).forEach(function (key) {
            if (key.endsWith('Date')) {
              data.changes[key] = new Date(data.changes[key]);
            }
          });
          Object.assign(eventRecord, data.changes);
          me.updateTimeLine();
          break;
        // Removing an event

        case 'removeEvent':
          WidgetHelper.toast("".concat(data.userName, " removed \"").concat(data.records.map(function (id) {
            return scheduler.eventStore.getById(id).name;
          }).join(', '), "\""));
          scheduler.eventStore.remove(data.records);
          break;
        // Adding an event

        case 'addEvent':
          scheduler.eventStore.add(data.records);
          WidgetHelper.toast("".concat(data.userName, " added \"").concat(data.records.map(function (rec) {
            return rec.name;
          }).join(', '), "\""));
          break;
        // Dragging or resizing, move the local element to match ongoing operation

        case 'dragEvent':
        case 'resizeEvent':
          {
            var element = scheduler.getElementFromEventRecord(eventRecord),
                startDate = new Date(data.startDate),
                startX = scheduler.getCoordinateFromDate(startDate);

            if (!element) {
              break;
            }

            element.dataset.userName = data.userName; // Prevent dragging & resizing while other user is performing an action on the event

            eventRecord.draggable = false;
            eventRecord.resizeable = false;

            if (element) {
              // Dragging, match position
              if (data.command === 'dragEvent') {
                element.classList.add('b-remote-drag');
                DomHelper.setTranslateXY(element.parentElement, startX, data.newY * scheduler.rowHeight);
              } // Resizing, match position + size


              if (data.command === 'resizeEvent') {
                element.classList.add("b-remote-resize-".concat(data.edge));
                var endDate = new Date(data.endDate),
                    endX = scheduler.getCoordinateFromDate(endDate);
                DomHelper.setTranslateX(element.parentElement, startX);
                element.parentElement.style.width = "".concat(Math.abs(endX - startX), "px");
              }
            }

            break;
          }

        default:
          me.debugLog("Unhandled message command ".concat(data.command));
      }
    }
  }, {
    key: "wsOpen",
    value:
    /**
     * Connect to the server and start listening for messages
     */
    function wsOpen() {
      var me = this;

      if (!me._host || me._host.trim() === '') {
        WidgetHelper.toast("Server address can not be empty");
        return;
      }

      if (!me._userName || me.userName.trim() === '') {
        WidgetHelper.toast("User name can not be empty");
        return;
      }

      var scheduler = me._scheduler,
          wsHost = (/^wss?:\/\//i.test(me._host) ? '' : me._protocol) + me._host;
      scheduler.maskBody("<div style=\"text-align: center\">Connecting to<br>".concat(wsHost, "</div>"));
      var socket = me._socket = new WebSocket(wsHost);

      socket.onerror = function () {
        scheduler.maskBody('Error connecting to server!');
      }; // Called when socket is established


      socket.onopen = function () {
        WidgetHelper.toast("Connected to server");
        me.setConnectedState(true);
        me._label.html = "Login: ".concat(me._userName); // User login to server

        scheduler.maskBody('Connecting ...');
        me.wsSend({
          command: 'hello',
          userName: me._userName
        });
        scheduler.maskBody('Requesting data ...');
        me.wsSend({
          command: 'dataset'
        });
      };

      socket.onclose = function () {
        WidgetHelper.toast("Disconnected from server");
        me.setConnectedState(false);
      }; // Called when a message is received from the server


      socket.onmessage = /*#__PURE__*/function () {
        var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(msg) {
          return regeneratorRuntime.wrap(function _callee$(_context) {
            while (1) {
              switch (_context.prev = _context.next) {
                case 0:
                  me._ignoreChange = true;
                  _context.prev = 1;
                  me.wsReceive(JSON.parse(msg.data));
                  _context.next = 5;
                  return me._scheduler.project.commitAsync();

                case 5:
                  _context.prev = 5;
                  me._ignoreChange = false;
                  return _context.finish(5);

                case 8:
                case "end":
                  return _context.stop();
              }
            }
          }, _callee, null, [[1,, 5, 8]]);
        }));

        return function (_x) {
          return _ref.apply(this, arguments);
        };
      }();
    }
  }, {
    key: "wsClose",
    value:
    /**
     * Close socket and disconnect from the server
     */
    function wsClose() {
      var scheduler = this._scheduler,
          socket = this._socket;

      if (socket) {
        socket.close();
      }

      if (scheduler) {
        scheduler.events = [];
        scheduler.resources = [];
      }
    }
  }, {
    key: "getUrlParams",
    value: //endregion
    //region Helper functions

    /**
     * Decode params from window search string.
     */
    function getUrlParams() {
      var params = {},
          pairs = window.location.search.substring(1).split('&');
      pairs.forEach(function (pair) {
        if (pair !== '') {
          var _pair$split = pair.split('=', 2),
              _pair$split2 = _slicedToArray(_pair$split, 2),
              key = _pair$split2[0],
              _pair$split2$ = _pair$split2[1],
              value = _pair$split2$ === void 0 ? true : _pair$split2$;

          params[key] = value;
        }
      });
      return params;
    }
    /**
     * Updates Scheduler's timeline to fit all events
     */

  }, {
    key: "updateTimeLine",
    value: function updateTimeLine() {
      var scheduler = this._scheduler;

      if (scheduler.events.length > 0) {
        scheduler.setTimeSpan(scheduler.eventStore.min('startDate'), scheduler.eventStore.max('endDate'));
      }
    }
    /**
     * Get random value from array
     * @param array input values
     * @returns {*} random array value
     */

  }, {
    key: "debugLog",
    value:
    /**
     * Output console debug log
     * @param txt log text
     */
    function debugLog(txt) {
      if (this._debug) {
        console.log(txt);
      }
    }
    /**
     * Sets visibility for elements with the specified css class
     * @param {String} cls css class name
     * @param {Boolean} visible flag
     */

  }, {
    key: "setVisibility",
    value: function setVisibility(cls, visible) {
      DomHelper.forEachSelector(document.body, cls, function (element) {
        element.style.display = visible ? 'flex' : 'none';
      });
    }
    /**
     * Sets visual state for login / logout controls
     * @param {Boolean} connected Connected status
     */

  }, {
    key: "setConnectedState",
    value: function setConnectedState(connected) {
      var scheduler = this._scheduler;
      this.setVisibility('.b-login', !connected);
      this.setVisibility('.b-logout', connected);
      WebSocketHelper.clearOnlineUsers();

      if (!connected) {
        scheduler.events = [];
        scheduler.maskBody('<div style="text-align: center">OFFLINE</div>');
      }
    }
    /**
     * Clears online users
     */

  }, {
    key: "onEventStoreChange",
    value: //endregion
    // region event listeners
    function onEventStoreChange(event) {
      var me = this,
          action = event.action,
          changes = event.changes; // Log received change event

      me.debugLog(JSON.stringify(event)); // Filter out non-persistable records.
      // This would be records in the middle of a batch update, or tentative "isCreating" records

      var records = (event.records ? event.records : [event.record]).filter(function (r) {
        return r.isPersistable;
      });

      if (!records.length || me._ignoreChange) {
        return;
      }

      switch (action) {
        case 'update':
          {
            var data = {}; // changes has format { value, old }, we only need value

            Object.keys(changes).forEach(function (key) {
              data[key] = changes[key].value;
            });
            me.wsSend({
              command: 'updateEvent',
              id: records[0].id,
              changes: data
            });
            break;
          }

        case 'remove':
          me.wsSend({
            command: 'removeEvent',
            records: records.map(function (rec) {
              return rec.id;
            })
          });
          break;

        case 'add':
          me.wsSend({
            command: 'addEvent',
            records: records
          });
          break;
      }

      me.updateTimeLine();
    }
  }, {
    key: "onEventStoreAddConfirmed",
    value: function onEventStoreAddConfirmed(_ref2) {
      var record = _ref2.record;
      this.wsSend({
        command: 'addEvent',
        records: [record]
      });
    }
  }, {
    key: "onBeforeEventEdit",
    value: function onBeforeEventEdit(_ref3) {
      var eventRecord = _ref3.eventRecord;

      if (!eventRecord.name) {
        eventRecord.name = WebSocketHelper.random(eventNames);
        eventRecord.iconCls = "b-fa ".concat(WebSocketHelper.random(eventIcons));
      }
    }
  }, {
    key: "onEventDrag",
    value: function onEventDrag(_ref4) {
      var eventRecords = _ref4.eventRecords,
          startDate = _ref4.startDate,
          context = _ref4.context;
      this.wsSend({
        command: 'dragEvent',
        id: eventRecords[0].id,
        startDate: startDate,
        newY: context.context.newY / this._scheduler.rowHeight
      });
    }
  }, {
    key: "onEventDrop",
    value: function onEventDrop(_ref5) {
      var eventRecords = _ref5.eventRecords,
          valid = _ref5.valid;

      if (!valid) {
        var eventRec = eventRecords[0];
        this.wsSend({
          command: 'updateEvent',
          id: eventRec.id,
          changes: {
            startDate: eventRec.startDate,
            endDate: eventRec.endDate,
            resourceId: eventRec.resourceId
          }
        });
      }
    } // endregion

  }], [{
    key: "random",
    value: function random(array) {
      return array[Math.floor(Math.random() * array.length)];
    }
  }, {
    key: "clearOnlineUsers",
    value: function clearOnlineUsers() {
      DomHelper.removeEachSelector(document, '.ws-online-user');
    }
    /**
     * Shows online users
     */

  }, {
    key: "showOnlineUsers",
    value: function showOnlineUsers(users) {
      WebSocketHelper.clearOnlineUsers();

      var _iterator = _createForOfIteratorHelper(users),
          _step;

      try {
        for (_iterator.s(); !(_step = _iterator.n()).done;) {
          var user = _step.value;
          WidgetHelper.append({
            type: 'widget',
            cls: 'ws-online-user',
            html: "<label>".concat(user, "</label>")
          }, 'ws-online-container');
        }
      } catch (err) {
        _iterator.e(err);
      } finally {
        _iterator.f();
      }
    }
  }]);

  return WebSocketHelper;
}();
/**
 * Override generateID method to create unique event ID
 * @returns {string} new event id
 */


EventModel.prototype.generateId = function () {
  var uuid = ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, function (c) {
    return (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16);
  });
  return "event-".concat(uuid);
};
/* eslint-disable no-unused-vars */
//region Init Scheduler


var scheduler = new Scheduler({
  appendTo: 'container',
  autoAdjustTimeAxis: false,
  emptyText: '',
  zoomOnMouseWheel: false,
  zoomOnTimeAxisDoubleClick: false,
  features: {
    regionResize: false,
    cellMenu: {
      items: {
        removeRow: false
      }
    }
  },
  responsiveLevels: {
    small: {
      levelWidth: 800,
      rowHeight: 35,
      barMargin: 5
    },
    normal: {
      levelWidth: '*',
      rowHeight: 50,
      barMargin: 10
    }
  },
  viewPreset: {
    base: 'hourAndDay',
    timeResolution: {
      unit: 'minute',
      increment: 5
    }
  },
  columns: [{
    field: 'name',
    text: 'Name',
    width: 70
  }],
  tbar: [{
    type: 'textfield',
    ref: 'wsHost',
    placeholder: 'Address:Port',
    label: 'Host',
    cls: 'b-login',
    inputType: 'url',
    width: 300,
    required: true,
    onChange: function onChange(_ref6) {
      var value = _ref6.value;
      wsHelper.host = value;
    }
  }, {
    type: 'textfield',
    ref: 'wsUserName',
    placeholder: 'Your name',
    label: 'Username',
    cls: 'b-login',
    onChange: function onChange(_ref7) {
      var value = _ref7.value;
      wsHelper.userName = value;
    }
  }, {
    type: 'button',
    ref: 'wsLogin',
    cls: 'b-login b-blue',
    icon: 'b-fa b-fa-sign-in-alt',
    text: 'Login',
    onClick: function onClick() {
      if (scheduler.widgetMap.wsHost.isValid) {
        wsHelper.wsOpen();
      } else {
        Toast.show('Invalid host');
      }
    }
  }, {
    type: 'widget',
    ref: 'wsLoginLabel',
    html: '<label>:</label>',
    cls: 'b-logout b-login-name'
  }, {
    type: 'button',
    ref: 'wsReset',
    cls: 'b-logout b-blue',
    icon: 'b-fa b-fa-trash',
    text: 'Reset data',
    onClick: function onClick() {
      wsHelper.wsResetData();
    }
  }, {
    type: 'button',
    ref: 'wsLogout',
    cls: 'b-logout b-red',
    icon: 'b-fa b-fa-sign-out-alt',
    text: 'Logout',
    onClick: function onClick() {
      wsHelper.wsClose();
    }
  }]
});
var _scheduler$widgetMap = scheduler.widgetMap,
    wsHost = _scheduler$widgetMap.wsHost,
    wsUserName = _scheduler$widgetMap.wsUserName,
    wsLoginLabel = _scheduler$widgetMap.wsLoginLabel; //endregion
//region Online user container

WidgetHelper.append([{
  type: 'container',
  id: 'ws-online',
  cls: 'b-logout',
  items: [{
    type: 'container',
    cls: 'ws-online-users',
    items: [{
      type: 'widget',
      html: '<label>Who is online:</label>'
    }, {
      type: 'container',
      id: 'ws-online-container'
    }]
  }]
}], 'container'); //endregion
//region Init WebSocketHelper

var wsHelper = scheduler.webSocketHelper = new WebSocketHelper(scheduler, wsLoginLabel);
wsHost.value = wsHelper.host;
wsUserName.value = wsHelper.userName; //endregion