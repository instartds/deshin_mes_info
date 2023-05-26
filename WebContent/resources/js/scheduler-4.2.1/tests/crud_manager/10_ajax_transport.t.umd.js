function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

StartTest(function (t) {
  var realFetch = AjaxHelper.fetch;
  var assertBeforeFetch; // Override AjaxHelper.fetch to be able to assert its arguments

  AjaxHelper.fetch = function (url, config) {
    assertBeforeFetch && assertBeforeFetch(url, config); // we don't want to assert the same arguments twice

    assertBeforeFetch = null;
    return Promise.resolve({
      success: true
    });
  }; // dummy encoder, does nothing


  var TestEncoder = function TestEncoder(Base) {
    return /*#__PURE__*/function (_Base) {
      _inherits(_class, _Base);

      var _super = _createSuper(_class);

      function _class() {
        _classCallCheck(this, _class);

        return _super.apply(this, arguments);
      }

      _createClass(_class, [{
        key: "encode",
        value: //format  : 'xml',
        function encode(data) {
          return data;
        }
      }, {
        key: "decode",
        value: function decode(data) {
          return data;
        }
      }]);

      return _class;
    }(Base);
  };

  var TestCrudManager1 = /*#__PURE__*/function (_AjaxTransport) {
    _inherits(TestCrudManager1, _AjaxTransport);

    var _super2 = _createSuper(TestCrudManager1);

    function TestCrudManager1() {
      _classCallCheck(this, TestCrudManager1);

      return _super2.apply(this, arguments);
    }

    return TestCrudManager1;
  }(AjaxTransport(TestEncoder(AbstractCrudManager)));

  t.it('Correctly prepare params for Ajax request', function (t) {
    var crud = new TestCrudManager1({
      transport: {
        load: {
          url: 'loadurl',
          method: 'POST',
          paramName: 'smth',
          params: {
            qwe: 'rty'
          },
          requestConfig: {}
        },
        sync: {
          url: 'syncurl',
          method: 'PUT'
        }
      }
    });
    t.it('for the load packet', function (t) {
      crud.on({
        beforesend: function beforesend(_ref) {
          var requestConfig = _ref.requestConfig;
          t.isDeeply(requestConfig, {
            url: 'loadurl',
            method: 'POST',
            params: {
              smth: '{foo:"bar"}',
              qwe: 'rty'
            }
          }, 'Correctly formed params');
        },
        once: true
      });
      crud.sendRequest({
        data: '{foo:"bar"}',
        type: 'load',
        success: function success() {},
        failure: function failure() {},
        thisObj: 'thisObj'
      });
    });
    t.it('for the sync packet', function (t) {
      crud.on({
        beforesend: function beforesend(_ref2) {
          var requestConfig = _ref2.requestConfig;
          t.isDeeply(requestConfig, {
            url: 'syncurl',
            method: 'PUT',
            params: {},
            headers: {
              'Content-Type': 'application/json'
            },
            body: '{"qwe":"rty"}'
          }, 'Correctly formed params');
        },
        once: true
      });

      assertBeforeFetch = function assertBeforeFetch(url, config) {
        t.is(config.body, '{"qwe":"rty"}', 'Proper body passed to fetch() method');
      };

      crud.sendRequest({
        data: '{"qwe":"rty"}',
        type: 'sync',
        success: function success() {},
        failure: function failure() {},
        thisObj: 'thisObj2'
      });
    });
  });
  t.it('Supports requestConfig config for Ajax request', function (t) {
    var crud = new TestCrudManager1({
      transport: {
        load: {
          url: 'loadurl',
          method: 'POST',
          paramName: 'smth',
          params: {
            qwe: 'rty'
          },
          requestConfig: {
            url: 'loadurl2',
            method: 'GET',
            params: {
              foo: 'bar'
            }
          }
        },
        sync: {
          url: 'syncurl',
          method: 'PUT',
          requestConfig: {
            url: 'syncurl2',
            method: 'POST',
            params: {
              foo: 'bar'
            }
          }
        }
      }
    });
    t.it('for the load packet', function (t) {
      crud.on({
        beforesend: function beforesend(_ref3) {
          var requestConfig = _ref3.requestConfig;
          t.isDeeply(requestConfig, {
            url: 'loadurl2',
            method: 'GET',
            params: {
              smth: 'loaddata',
              foo: 'bar'
            }
          }, 'Correctly formed params');
        },
        once: true
      });
      crud.sendRequest({
        data: 'loaddata',
        type: 'load',
        success: function success() {},
        failure: function failure() {},
        thisObj: 'thisObj'
      });
    });
    t.it('for the sync packet', function (t) {
      crud.on({
        beforesend: function beforesend(_ref4) {
          var requestConfig = _ref4.requestConfig;
          t.isDeeply(requestConfig, {
            url: 'syncurl2',
            method: 'POST',
            body: 'syncdata',
            headers: {
              'Content-Type': 'application/json'
            },
            params: {
              foo: 'bar'
            }
          }, 'Correctly formed params');
        },
        once: true
      });
      crud.sendRequest({
        data: 'syncdata',
        type: 'sync',
        success: function success() {},
        failure: function failure() {},
        thisObj: 'thisObj2'
      });
    });
  });
  t.it('Should support providing request headers and fetchOptions for the Ajax request', function (t) {
    var crud = new TestCrudManager1({
      transport: {
        load: {
          url: 'loadurl',
          method: 'GET',
          requestConfig: {
            headers: {
              qwe: 'rty'
            },
            // https://app.assembla.com/spaces/bryntum/tickets/9067
            fetchOptions: {
              foo: 'bar'
            }
          }
        }
      }
    });

    assertBeforeFetch = function assertBeforeFetch(url, config) {
      t.is(url, 'loadurl', 'Url is correct');
      t.is(config.headers.qwe, 'rty', 'Proper header passed to fetch() method');
      t.is(config.foo, 'bar', 'Proper fetchOptions passed to fetch() method');
    };

    crud.sendRequest({
      data: 'syncdata',
      type: 'load'
    });
  });
  t.it('Should append Content-Type:application/json header for POST requests', function (t) {
    var crudSync = new TestCrudManager1({
      transport: {
        sync: {
          url: 'syncurl',
          method: 'POST'
        }
      }
    });

    assertBeforeFetch = function assertBeforeFetch(url, config) {
      t.is(config.headers['Content-Type'], 'application/json', 'Proper JSON header passed to fetch() method');
    };

    crudSync.sendRequest({
      data: '{"qwe":"rty"}',
      type: 'sync',
      success: function success() {},
      failure: function failure() {},
      thisObj: 'thisObj2'
    });
  });
  t.it('Should not append Content-Type header for GET requests', function (t) {
    var crudSync = new TestCrudManager1({
      transport: {
        load: {
          url: 'loadurl'
        }
      }
    });

    assertBeforeFetch = function assertBeforeFetch(url, config) {
      t.notOk(config.headers, 'No headers added for GET request');
    };

    crudSync.sendRequest({
      data: '{"qwe":"rty"}',
      type: 'load',
      success: function success() {},
      failure: function failure() {},
      thisObj: 'thisObj2'
    });
  });
  t.it('Should throw if trying to load without a URL', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var crud, crudWithRequestConfig;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.mockUrl('read', {
                responseText: JSON.stringify({
                  success: true
                })
              });
              crud = new CrudManager({
                transport: {
                  load: {}
                }
              });
              _context.next = 4;
              return crud.load().catch(function (e) {
                t.isInstanceOf(e, Error, 'error returned');
                t.is(e.message, 'Trying to request without URL specified');
              });

            case 4:
              crudWithRequestConfig = new CrudManager({
                transport: {
                  load: {
                    requestConfig: {
                      url: 'read'
                    }
                  }
                }
              });
              _context.next = 7;
              return crudWithRequestConfig.load().catch(function () {
                return t.fail('should not catch anything here');
              });

            case 7:
              t.pass('Does not throw if URL is configured in requestConfig object');

            case 8:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should throw in DEBUG mode if trying to load with a URL containing null/undefined/[object', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var _window$bryntum;

      var crud;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              if ((_window$bryntum = window.bryntum) !== null && _window$bryntum !== void 0 && _window$bryntum.isDebug) {
                _context2.next = 3;
                break;
              }

              t.pass('Test for debug mode only. Skipping.');
              return _context2.abrupt("return");

            case 3:
              AjaxHelper.fetch = realFetch;
              crud = new CrudManager({
                transport: {
                  load: {
                    requestConfig: {
                      url: 'foo?undefined'
                    }
                  }
                }
              });
              _context2.next = 7;
              return crud.load().catch(function (e) {
                return t.like(e.message, 'Incorrect URL: foo?undefined');
              });

            case 7:
              crud = new CrudManager({
                transport: {
                  load: {
                    requestConfig: {
                      url: 'foo?null'
                    }
                  }
                }
              });
              _context2.next = 10;
              return crud.load().catch(function (e) {
                return t.like(e.message, 'Incorrect URL: foo?null');
              });

            case 10:
              crud = new CrudManager({
                transport: {
                  load: {
                    requestConfig: {
                      url: 'foo?' + window.toString()
                    }
                  }
                }
              });
              _context2.next = 13;
              return crud.load().catch(function (e) {
                return t.like(e.message, 'Incorrect URL: foo?[object');
              });

            case 13:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Handles cases when paramName is empty and GET request is used', function (t) {
    var crud = new TestCrudManager1({
      transport: {
        load: {
          url: 'loadurl',
          method: 'POST',
          params: {
            qwe: 'rty'
          },
          requestConfig: {
            url: 'loadurl2',
            method: 'GET',
            params: {
              foo: 'bar'
            }
          }
        },
        sync: {
          url: 'syncurl',
          method: 'PUT',
          requestConfig: {
            url: 'syncurl2',
            method: 'GET',
            params: {
              foo: 'bar'
            }
          }
        }
      }
    });
    t.it('for the load packet', function (t) {
      crud.on({
        beforesend: function beforesend(_ref7) {
          var requestConfig = _ref7.requestConfig;
          t.isDeeply(requestConfig, {
            url: 'loadurl2',
            method: 'GET',
            params: {
              data: 'loaddata',
              foo: 'bar'
            }
          }, 'Correctly formed params');
        },
        once: true
      });
      crud.sendRequest({
        data: 'loaddata',
        type: 'load',
        success: function success() {},
        failure: function failure() {},
        thisObj: 'thisObj'
      });
    });
    t.it('for the sync packet', function (t) {
      crud.on({
        beforesend: function beforesend(_ref8) {
          var requestConfig = _ref8.requestConfig;
          t.isDeeply(requestConfig, {
            url: 'syncurl2',
            method: 'GET',
            params: {
              data: 'syncdata',
              foo: 'bar'
            }
          }, 'Correctly formed params');
        },
        once: true
      });
      crud.sendRequest({
        data: 'syncdata',
        type: 'sync',
        success: function success() {},
        failure: function failure() {},
        thisObj: 'thisObj2'
      });
    });
  });
  t.it('Should handle a successful response w/o table sections correctly', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var crud, spy;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  events: {
                    rows: [{
                      id: 1,
                      startDate: '2020-11-18',
                      endDate: '2020-11-19',
                      name: 'one'
                    }, {
                      id: 2,
                      startDate: '2020-11-18',
                      endDate: '2020-11-19',
                      name: 'two'
                    }]
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'foo'
                    }]
                  },
                  assignments: {
                    rows: [{
                      id: 1,
                      resourceId: 1,
                      eventId: 1
                    }]
                  }
                })
              });
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true
                })
              });
              crud = new CrudManager({
                autoSync: true,
                transport: {
                  load: {
                    url: 'load'
                  },
                  sync: {
                    url: 'sync'
                  }
                }
              });
              spy = t.spyOn(crud, 'sync');
              _context3.next = 6;
              return crud.load();

            case 6:
              t.notOk(crud.hasChanges(), 'crud manager has no changes after load()');
              crud.resourceStore.first.name = 'smth';
              t.ok(crud.hasChanges(), 'crud manager has changes');
              _context3.next = 11;
              return t.waitForEvent(crud, 'sync');

            case 11:
              t.notOk(crud.hasChanges(), 'crud manager has no changes');
              crud.assignmentStore.first.eventId = 2;
              crud.eventStore.first.name = 'uno';
              t.ok(crud.hasChanges(), 'crud manager has changes');
              _context3.next = 17;
              return t.waitForEvent(crud, 'sync');

            case 17:
              t.notOk(crud.hasChanges(), 'crud manager has no changes');
              _context3.next = 20;
              return t.waitFor(100);

            case 20:
              t.is(spy.calls.count(), 2, 'proper number of sync() calls');

            case 21:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should handle a successful response with server changes only correctly', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var crud, spy, resourceStore, newResource, newAssignment;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  events: {
                    rows: [{
                      id: 1,
                      startDate: '2020-11-18',
                      endDate: '2020-11-19',
                      name: 'one'
                    }, {
                      id: 2,
                      startDate: '2020-11-18',
                      endDate: '2020-11-19',
                      name: 'two'
                    }]
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'foo'
                    }]
                  },
                  assignments: {
                    rows: [{
                      id: 1,
                      resourceId: 1,
                      eventId: 1
                    }]
                  }
                })
              });
              crud = new CrudManager({
                project: new ProjectModel(),
                autoSync: true,
                transport: {
                  load: {
                    url: 'load'
                  },
                  sync: {
                    url: 'sync'
                  }
                }
              });
              spy = t.spyOn(crud, 'sync');
              _context4.next = 5;
              return crud.load();

            case 5:
              resourceStore = crud.resourceStore;
              resourceStore.first.name = 'smth';
              newResource = resourceStore.add({
                name: 'smbdy'
              })[0];
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  resources: {
                    rows: [{
                      $PhantomId: newResource.id,
                      id: 2
                    }]
                  }
                })
              });
              t.ok(crud.hasChanges(), 'crud manager has changes');
              _context4.next = 12;
              return t.waitForEvent(crud, 'sync');

            case 12:
              t.notOk(crud.hasChanges(), 'crud manager has no changes');
              crud.assignmentStore.first.eventId = 2;
              crud.eventStore.first.name = 'uno';
              newAssignment = crud.assignmentStore.add({
                eventId: 2,
                resourceId: 2
              })[0];
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  assignments: {
                    rows: [{
                      $PhantomId: newAssignment.id,
                      id: 2
                    }]
                  }
                })
              });
              t.ok(crud.hasChanges(), 'crud manager has changes');
              _context4.next = 20;
              return t.waitForEvent(crud, 'sync');

            case 20:
              t.notOk(crud.hasChanges(), 'crud manager has no changes');
              _context4.next = 23;
              return t.waitFor(100);

            case 23:
              t.is(spy.calls.count(), 2, 'proper number of sync() calls');

            case 24:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref10.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/541

  t.it('Should send POST params on form Request Payload instead of query string on url', function (t) {
    var crud = new CrudManager({
      encoder: {
        requestData: {
          foo: 'bar'
        }
      },
      transport: {
        sync: {
          url: 'syncurl',
          method: 'POST'
        }
      }
    });

    AjaxHelper.fetch = function (url, params) {
      t.isDeeply(crud.decode(params.body), {
        id: 1,
        name: 'test',
        foo: 'bar'
      }, 'Correct params');
      return Promise.resolve({
        success: true
      });
    };

    crud.sendRequest({
      data: crud.encode({
        id: 1,
        name: 'test'
      }),
      type: 'sync',
      success: function success() {},
      failure: function failure() {},
      thisObj: 'thisObj'
    });
  });
});