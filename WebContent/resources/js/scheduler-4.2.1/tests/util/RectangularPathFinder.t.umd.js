function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest(function (t) {
  function getBoxConnectionPoint(box, side, shift, arrowSize) {
    var point = {};

    switch (side) {
      case 'left':
        point.x = box.start - arrowSize;
        point.y = (box.top + box.bottom) / 2 + shift;
        break;

      case 'right':
        point.x = box.end + arrowSize;
        point.y = (box.top + box.bottom) / 2 + shift;
        break;

      case 'top':
        point.x = (box.start + box.end) / 2 + shift;
        point.y = box.top - arrowSize;
        break;

      case 'bottom':
        point.x = (box.start + box.end) / 2 + shift;
        point.y = box.bottom + arrowSize;
        break;
    }

    return point;
  }

  function checkLineData(t, pathFinder, lineDef, lineSegmentsData, expectSegments) {
    var startConnPoint, endConnPoint, firstSegment, lastSegment, isLineContinous, i;
    t.ok(lineSegmentsData, 'Path found');

    if (lineSegmentsData) {
      //lineDef = Object.assign({}, lineDef, pathFinder.config);
      lineDef = Object.assign({}, pathFinder.config, lineDef);
      startConnPoint = getBoxConnectionPoint(lineDef.startBox, lineDef.startSide, lineDef.startShift, lineDef.startArrowSize);
      endConnPoint = getBoxConnectionPoint(lineDef.endBox, lineDef.endSide, lineDef.endShift, lineDef.endArrowSize);
      firstSegment = lineSegmentsData[0];
      lastSegment = lineSegmentsData[lineSegmentsData.length - 1]; // checking line length

      t.is(lineSegmentsData.length, expectSegments, 'Line contain expected amount of segments'); // checking line start

      t.ok(startConnPoint.x === firstSegment.x1 && startConnPoint.y === firstSegment.y1, 'Line starts at correct start point'); // checking line end

      t.ok(endConnPoint.x === lastSegment.x2 && endConnPoint.y === lastSegment.y2, 'Line ends at correct end point'); // checking line connectivity

      for (i = 1, isLineContinous = true; isLineContinous && i < lineSegmentsData.length; ++i) {
        isLineContinous = lineSegmentsData[i - 1].x2 === lineSegmentsData[i].x1 && lineSegmentsData[i - 1].y2 === lineSegmentsData[i].y1;
      }

      t.ok(isLineContinous, 'Line is continous, i.e. it has no gaps');
    }
  } // eslint-disable-next-line no-unused-vars


  function drawConnection(pathFinderConfig, lineDef) {
    var body = document.body,
        painter,
        lineContEl;
    var div1 = document.createElement('div');
    div1.style.position = 'absolute'; //border   : '1px solid black',

    div1.style.border = '0px none';
    div1.style.backgroundColor = 'orange';
    div1.style.top = lineDef.startBox.top + 'px';
    div1.style.left = lineDef.startBox.start + 'px';
    div1.style.width = lineDef.startBox.end - lineDef.startBox.start + 'px';
    div1.style.height = lineDef.startBox.bottom - lineDef.startBox.top + 'px';
    body.appendChild(div1);
    var div2 = document.createElement('div');
    div2.style.position = 'absolute'; //border   = '1px solid black',

    div2.style.border = '0px none';
    div2.style.backgroundColor = 'orange';
    div2.style.top = lineDef.endBox.top + 'px';
    div2.style.left = lineDef.endBox.start + 'px';
    div2.style.width = lineDef.endBox.end - lineDef.endBox.start + 'px';
    div2.style.height = lineDef.endBox.bottom - lineDef.endBox.top + 'px';
    body.appendChild(div2);
    lineDef.otherBoxes && lineDef.otherBoxes.forEach(function (box) {
      var otherDiv = document.createElement('div');
      otherDiv.style.position = 'absolute'; //border   = '1px solid black';

      otherDiv.style.border = '0px none';
      otherDiv.style.backgroundColor = 'red';
      otherDiv.style.top = box.top + 'px';
      otherDiv.style.left = box.start + 'px';
      otherDiv.style.width = box.end - box.start + 'px';
      otherDiv.style.height = box.bottom - box.top + 'px';
      body.appendChild(otherDiv);
    });
    lineContEl = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    lineContEl.style.position = 'absolute';
    lineContEl.style.overflow = 'visible';
    body.appendChild(lineContEl);
    var pathFinder = new RectangularPathFinder(pathFinderConfig);
    var path = pathFinder.findPath(lineDef);
    lineContEl.innerHTML = path.map(function (line) {
      return "<line style=\"stroke:black;stroke-width:1px;\" x1=\"".concat(line.x1, "\" x2=\"").concat(line.x2, "\" y1=\"").concat(line.y1, "\" y2=\"").concat(line.y2, "\"></line>");
    });
  }

  t.describe('Rectangular path finder takes a line specification and divides it into a list of segments consisting a line', function (t) {
    t.it("It should properly segment a line with minimal amount of segments possible regardles of line's boxes connection sides", function (t) {
      //
      //        +---------+  1 segment   +----------+
      //     +--|         |------------->|-shift    |<-+
      //     |  +---------+              |          |  |
      //     |               5 segments  +----------+  |
      //     +-----------------------------------------+
      var pathFinder, lineDef, lineSegmentsData, testPlan;
      pathFinder = new RectangularPathFinder({
        verticalMargin: 10
      });
      lineDef = {
        startBox: {
          top: 100,
          start: 100,
          bottom: 250,
          end: 250
        },
        endBox: {
          top: 100,
          start: 400,
          bottom: 300,
          end: 550
        },
        endShift: -25
      }; // start side - end side - segments amount

      testPlan = {
        'left': {
          'left': 5,
          'right': 5,
          'top': 4,
          'bottom': 4
        },
        'right': {
          'left': 1,
          'right': 5,
          'top': 4,
          'bottom': 4
        },
        'top': {
          'left': 4,
          'right': 4,
          'top': 3,
          'bottom': 5
        },
        'bottom': {
          'left': 4,
          'right': 4,
          'top': 5,
          'bottom': 3
        }
      };
      Object.entries(testPlan).forEach(function (entry) {
        var _entry = _slicedToArray(entry, 2),
            startSide = _entry[0],
            endSideTestPlan = _entry[1];

        Object.entries(endSideTestPlan).forEach(function (entry2) {
          var _entry2 = _slicedToArray(entry2, 2),
              endSide = _entry2[0],
              expectedSegments = _entry2[1];

          lineDef.startSide = startSide;
          lineDef.endSide = endSide;
          lineSegmentsData = pathFinder.findPath(lineDef);
          t.diag('From ' + startSide + ' to ' + endSide + ' expect segments ' + expectedSegments);
          checkLineData(t, pathFinder, lineDef, lineSegmentsData, expectedSegments);
        });
      });
    });
    t.it('Should support advanced pathfinding', function (t) {
      //                    +---+--------------------+
      //     +-------+      |***|********************|
      //  +--+       |      |***+---------------+----+
      //  |  +-------+      |***|   +------+    |****|
      //  |                 |***| +>|      |    |****|
      //  |                 |***| | +------+    +----+
      //  |                 |***| +-+------+------------+
      //  |                 |***+--------------------+  |
      //  |                 |***|********************|  |
      //  |                 +---+--------------------+  |
      //  +---------------------------------------------+
      var pathFinder, lineDef;
      pathFinder = new RectangularPathFinder({
        verticalMargin: 10
      });
      lineDef = {
        startBox: {
          top: 50,
          start: 50,
          bottom: 100,
          end: 100
        },
        endBox: {
          top: 125,
          start: 300,
          bottom: 225,
          end: 350
        },
        otherBoxes: [{
          top: 50,
          start: 200,
          bottom: 300,
          end: 250
        }, {
          top: 50,
          start: 250,
          bottom: 100,
          end: 500
        }, {
          top: 250,
          start: 250,
          bottom: 300,
          end: 500
        }, {
          top: 100,
          start: 450,
          bottom: 225,
          end: 500
        }]
      }; //drawConnection(pathFinder.getConfig(), lineDef);

      checkLineData(t, pathFinder, lineDef, pathFinder.findPath(lineDef), 7);
    });
    t.it('Should properly report when path could not be found', function (t) {//                    +---+--------------------+
      //     +-------+      |***|********************|
      //  +--+       |      |***+---------------+----+
      //  |  +-------+      |***|   +------+    |****|
      //  |                 |***|   |      |    |****|
      //  |                 |***|   +------+    |****|
      //  |                 |***|               |****|  X
      //  |                 |***+---------------+----+  |
      //  |                 |***|********************|  |
      //  |                 +---+--------------------+  |
      //  +---------------------------------------------+
      // let pathFinder = new RectangularPathFinder({
      //     verticalMargin : 10
      // });
      //
      // let lineDef = {
      //     startBox   : { top : 50, start : 50, bottom : 100, end : 100 },
      //     endBox     : { top : 125, start : 300, bottom : 225, end : 350 },
      //     otherBoxes : [
      //         { top : 50, start : 200, bottom : 300, end : 250 },
      //         { top : 50, start : 250, bottom : 100, end : 500 },
      //         { top : 250, start : 250, bottom : 300, end : 500 },
      //         { top : 100, start : 450, bottom : 250, end : 500 }
      //     ]
      // };
      //TODO: This test does nothing?
      //drawConnection(pathFinder.getConfig(), lineDef);
    });
  });
  t.describe('Path finder calculations', function (t) {
    function buildPath(points) {
      var result = [];

      for (var i = 0, l = points.length - 1; i < l; i++) {
        var p1 = points[i],
            p2 = points[i + 1];
        result.push({
          x1: p1.x,
          x2: p2.x,
          y1: p1.y,
          y2: p2.y
        });
      }

      return result;
    }

    t.it('Should take other horizontal margin into account', function (t) {
      var lineDef = {
        startBox: {
          top: 100,
          bottom: 200,
          start: 100,
          end: 200
        },
        endBox: {
          top: 400,
          bottom: 500,
          start: 100,
          end: 200
        },
        otherBoxes: [{
          top: 250,
          bottom: 350,
          start: 100,
          end: 200
        }, // Config above allows two paths of identical price, so path may differ in browsers.
        // This box is only required to eliminate one of the paths
        {
          top: 200,
          bottom: 250,
          start: 100,
          end: 110
        }],
        startSide: 'bottom',
        endSide: 'top'
      };
      var pathFinder = new RectangularPathFinder({
        startArrowMargin: 10,
        startArrowSize: 0,
        endArrowMargin: 10,
        endArrowSize: 0,
        horizontalMargin: 0,
        verticalMargin: 0,
        otherHorizontalMargin: 10,
        otherVerticalMargin: 10
      });
      var path = pathFinder.findPath(lineDef);
      t.is(path.length, 5, '5 lines in path');
      drawConnection(pathFinder.config, lineDef);
      t.isDeeply(path, buildPath([{
        x: 150,
        y: 200
      }, {
        x: 150,
        y: 210
      }, {
        x: 210,
        y: 210
      }, {
        x: 210,
        y: 360
      }, {
        x: 150,
        y: 360
      }, {
        x: 150,
        y: 400
      }]));
    });
  });
});