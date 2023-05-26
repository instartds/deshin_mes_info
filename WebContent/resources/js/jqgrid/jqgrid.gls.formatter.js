/**
 * yyyymmddhhmiss to yyyy/mm/dd hh:mi:ss convert
 * @param cellvalue
 * @param options
 * @param rowObject
 * @returns {String}
 */
function jsLongDateFormmater(cellvalue, options, rowObject) {
	if(cellvalue=='' || cellvalue==null) return '';
	return cellvalue.substring(0, 4) + "/" + cellvalue.substring(4, 6) + "/"
			+ cellvalue.substring(6, 8) + " " + cellvalue.substring(8, 10)
			+ ":" + cellvalue.substring(10, 12) + ":"
			+ cellvalue.substring(12, 14);
}

function jsShortDateFormmater(cellvalue, options, rowObject) {
	if(cellvalue=='' || cellvalue==null) return '';
	return cellvalue.substring(0, 4) + "/" + cellvalue.substring(4, 6) + "/"
			+ cellvalue.substring(6, 8);
}

/**
 * jqgrid <-> textarea bind
 * colmodel edittype: 'textarea', unformat: unfrmttextarea 추가
 */
function unfrmttextarea (cellvalue, options, cellobject) {
    return cellvalue;
}