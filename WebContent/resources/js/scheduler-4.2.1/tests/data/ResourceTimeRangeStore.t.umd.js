function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest(function (t) {
  var resourceStore, rangeStore, range1, range2, range3;
  t.beforeEach(function (t) {
    resourceStore = new ResourceStore({
      data: [{
        id: 1,
        name: 'First resource'
      }, {
        id: 2,
        name: 'Second resource'
      }]
    });
    rangeStore = new ResourceTimeRangeStore({
      resourceStore: resourceStore,
      data: [{
        id: 1,
        resourceId: 1,
        name: 'First zone'
      }, {
        id: 2,
        resourceId: 1,
        name: 'Second zone'
      }, {
        id: 3,
        resourceId: 2,
        name: 'Third zone'
      }, {
        id: 4,
        resourceId: 3,
        name: 'Forth zone'
      }]
    });

    var _rangeStore$records = _slicedToArray(rangeStore.records, 3);

    range1 = _rangeStore$records[0];
    range2 = _rangeStore$records[1];
    range3 = _rangeStore$records[2];
  });
  t.it('Resource relation sanity checks', function (t) {
    t.isDeeply(rangeStore.map(function (r) {
      return r.resource;
    }), [resourceStore.first, resourceStore.first, resourceStore.last, {
      id: 3,
      placeHolder: true
    }], 'Correct resource initially');
    t.isDeeply(resourceStore.first.timeRanges, [range1, range2], 'Correct ranges initially');
    t.isDeeply(resourceStore.last.timeRanges, [range3], 'Correct ranges initially'); // Reassign using relation setter

    range1.resource = resourceStore.last;
    t.is(range1.resourceId, resourceStore.last.id, 'Assigning to resource worked'); // Reassign using relation key

    range2.resourceId = 2;
    t.is(range2.resource, resourceStore.last, 'Assigning to resourceId worked');
  });
  t.it('Ranges should get `resourceId=null` when resource is removed', function (t) {
    resourceStore.first.remove();
    t.is(range1.resourceId, null, 'First zone has resourceId null after removing resource');
    t.is(range2.resourceId, null, 'Second zone has resourceId null after removing resource');
  });
  t.it('Adding range should populate `resource` & `timeRanges`', function (t) {
    var _rangeStore$add = rangeStore.add({
      id: 5,
      resourceId: 1,
      name: 'Fifth zone'
    }),
        _rangeStore$add2 = _slicedToArray(_rangeStore$add, 1),
        zone5 = _rangeStore$add2[0];

    t.is(rangeStore.last.resource, resourceStore.first, 'Correct resource');
    t.isDeeply(resourceStore.first.timeRanges, [range1, range2, zone5], 'Correct timeRanges');
  });
});