/*
*  jQuery tui tablespan plugin 0.2
*
*  Copyright (c) 2010 china yewf
*
* Dual licensed under the MIT and GPL licenses:
*   http://www.opensource.org/licenses/mit-license.php
*   http://www.gnu.org/licenses/gpl.html
*
* Create: 2010-09-16 10:34:51 yewf $
* Revision: $Id: tui.tablespan.js  2010-09-21 10:08:36 yewf $
*
* Table rows or cols span
*/


/* rowspan。
Index starts from 0, contains hidden columns, note that the automatic jqgrid is a serial number column

Use：
$("#jqGridId").tuiTableRowSpan("3, 4, 8");
*/
jQuery.fn.tuiTableRowSpan = function(colIndexs) {
    return this.each(function() {
        var indexs = eval("([" + colIndexs + "])");
        for (var i = 0; i < indexs.length; i++) {
            var colIdx = indexs[i];
            var that;
            $('tbody tr', this).each(function(row) {
                $('td:eq(' + colIdx + ')', this).filter(':visible').each(function(col) {
                    if (that != null && $(this).html() == $(that).html()) {
                        rowspan = $(that).attr("rowSpan");
                        if (rowspan == undefined) {

                            $(that).attr("rowSpan", 1);
                            rowspan = $(that).attr("rowSpan");
                        }
                        rowspan = Number(rowspan) + 1;
                        $(that).attr("rowSpan", rowspan); // do your action for the colSpan cell here
                        $(this).remove(); // .hide(); // do your action for the old cell here
                    } else {
                        that = this;
                    }
                    // that = (that == null) ? this : that; // set the that if not already set
                });

            });
        }
    });
};

/* jqgrid header colspan。
Index starts from 0, contains hidden columns, note that the automatic jqgrid is a serial number column
   
Use：
$("#jqGridId").tuiJqgridColSpan({
    cols: [
        { indexes: "3, 4", title: "The combined title" },
        { indexes: "6, 7", title: "The combined title" },
        { indexes: "11, 12, 13", title: "The combined title" }
    ]
});

Notes：
1.Have not been merged rowSpan equal 2, ie two lines. Dragging out a BUG, can not display layer position synchronization jqgrid;
2.jqgrid the table header must have the aria-labelledby = 'gbox_tableid' such property;
3.only for jqgrid;
*/
var tuiJqgridColSpanInit_kkccddqq = false;
jQuery.fn.tuiJqgridColSpan = function(options) {
    options = $.extend({}, { UnbindDragEvent: true, cols: null }, options);

    if (tuiJqgridColSpanInit_kkccddqq) {
        return;
    }

    // validate parameters
    if (options.cols == null || options.cols.length == 0) {
        alert("cols parameters must be set");
        return;
    }

    // Line parameters must be passed in the order of columns, from small to large order, such as 3,4,5
    var error = false;
    for (var i = 0; i < options.cols.length; i++) {
        var colIndexs = eval("([" + options.cols[i].indexes + "])");

        for (var j = 0; j < colIndexs.length; j++) {
            if (j == colIndexs.length - 1) break;

            if (colIndexs[j] != colIndexs[j + 1] - 1) {
                error = true;
                break;
            }
        }

        if (error) break;
    }

    if (error) {
        alert("Line parameters must be passed in the order of columns, such as: 3,4,5");
        return;
    }

    // Below is a table header to transform jqgrid
    var resizing = false,
    currentMoveObj, startX = 0;

    var tableId = $(this).attr("id");
    // thead
    var jqHead = $("table[aria-labelledby='gbox_" + tableId + "']");
    var jqDiv = $("div#gbox_" + tableId);

    var oldTr = $("thead tr", jqHead);
    var oldThs = $("thead tr:first th", jqHead);

    // Th in the original line up and down respectively, the following line clone, an increase above this line, and height equal 0
    var ftr = $("<tr/>").css("height", "auto").addClass("ui-jqgrid-labels").attr("role", "rowheader").insertBefore(oldTr);
    var ntr = $("<tr/>").addClass("ui-jqgrid-labels").attr("role", "rowheader").insertAfter(oldTr);
    oldThs.each(function(index) {
        var cth = $(this);
        var cH = cth.css("height"), cW = cth.css("width"),
        nth = $("<th/>").css("height", cH),
        fth = $("<th/>").css("height", 0);
        // IE8 or firefox in the following, there will be more than an edge, so to get rid of.
        if (($.browser.msie && $.browser.version == "8.0") || $.browser.mozilla) {
            fth.css({ "border-top": "solid 0px #fff", "border-bottom": "solid 0px #fff" });
        }

        if (cth.css("display") == "none") {
            nth.css({ "display": "none", "white-space": "nowrap", "width": 0 });
            fth.css({ "display": "none", "white-space": "nowrap", "width": 0 });
        }
        else {
            nth.css("width", cW);
            fth.css("width", cW);

            // Add an event here, drag the column to resolve
            var res = cth.children("span.ui-jqgrid-resize");
            res && res.bind("mousedown", function(e) {
                currentMoveObj = $(this);
                startX = getEventPos(e).x;

                resizing = true;
                document.onselectstart = new Function("return false");
            });
        }
        // Increase in the first line
        fth.addClass(cth.attr("class")).attr("role", "columnheader").appendTo(ftr);

        // Increase in the third line
        cth.children().clone().appendTo(nth);
        nth.addClass(cth.attr("class")).attr("role", "columnheader").appendTo(ntr);
    });

    // colspan.
    // Note: This is not on top of the loop processing, because each traverse must perform the following operation.
    for (var i = 0; i < options.cols.length; i++) {
        var colIndexs = eval("([" + options.cols[i].indexes + "])");
        var colTitle = options.cols[i].title;

        var isrowSpan = false;
        for (var j = 0; j < colIndexs.length; j++) {
            oldThs.eq(colIndexs[j]).attr({ "colSpan": colIndexs.length, "rowSpan": "1" });

            // Hide the columns are combined, can not remove, so the sort function jqgrid dislocation.
            if (j != 0) {
                oldThs.eq(colIndexs[j]).attr("colSpan", "1").hide();
            }

            // Remove the extra tag after th clone
            $("thead tr:last th", jqHead).eq(colIndexs[j]).attr("tuidel", "false");

            // add column title
            if (j == 0) {
                var div = oldThs.eq(colIndexs[j]).find("div.ui-jqgrid-sortable");
                var divCld = div.children();

                div.text(colTitle);
                div.append(divCld);
            }
        }
    }
    // remove the extra column
    $("thead tr:last th[tuidel!='false']", jqHead).remove();
    // No increase in the combined list of attributes rowSpan
    oldThs.each(function() {
        if ($(this).attr("colSpan") == 1) {
            $(this).attr("rowSpan", 2);
        }
    });

    var jqBody = $(this);
    // Binding drag events
    $(document).bind("mouseup", function(e) {
        var ret = true;
        if (resizing) {
            var parentTh = currentMoveObj.parent();
            var currentIndex = parentTh.parents("tr").find("th").index(parentTh);

            var width, diff;
            var tbodyTd = $("tbody tr td", jqBody);
            var currentTh = $("thead tr:first th", jqHead).eq(currentIndex);

            // Td width of first use, if td is not present, use the width of the incident
            if (tbodyTd.length > 0) {
                diff = 0;
                width = parseInt(tbodyTd.eq(currentIndex).css("width"));
            }
            else {
                diff = getEventPos(e).x - startX;
                width = parseInt(currentTh.css("width"));
            }

            var lastWidth = diff + width;
            currentTh.css("width", lastWidth + "px");

            resizing = false;
            ret = false;
        }
        document.onselectstart = new Function("return true");
        return ret;
    });

    // Set is initialized
    tuiJqgridColSpanInit_kkccddqq = true;

    // Adapt to different browsers to get mouse coordinates
    getEvent = function(evt) {
        evt = window.event || evt;

        if (!evt) {
            var fun = getEvent.caller;
            while (fun != null) {
                evt = fun.arguments[0];
                if (evt && evt.constructor == Event)
                    break;
                fun = fun.caller;
            }
        }

        return evt;
    }

    getAbsPos = function(pTarget) {
        var x_ = y_ = 0;

        if (pTarget.style.position != "absolute") {
            while (pTarget.offsetParent) {
                x_ += pTarget.offsetLeft;
                y_ += pTarget.offsetTop;
                pTarget = pTarget.offsetParent;
            }
        }
        x_ += pTarget.offsetLeft;
        y_ += pTarget.offsetTop;
        return { x: x_, y: y_ };
    }

    getEventPos = function(evt) {
        var _x, _y;
        evt = getEvent(evt);
        if (evt.pageX || evt.pageY) {
            _x = evt.pageX;
            _y = evt.pageY;
        } else if (evt.clientX || evt.clientY) {
            _x = evt.clientX + (document.body.scrollLeft || document.documentElement.scrollLeft) - (document.body.clientLeft || document.documentElement.clientLeft);
            _y = evt.clientY + (document.body.scrollTop || document.documentElement.scrollTop) - (document.body.clientTop || document.documentElement.clientTop);
        } else {
            return getAbsPos(evt.target);
        }
        return { x: _x, y: _y };
    }
}; 