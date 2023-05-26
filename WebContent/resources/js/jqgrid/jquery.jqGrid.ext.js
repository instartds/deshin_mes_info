jQuery.extend(jQuery.jgrid.defaults, {
		prmNames: {
			page:"miv_pageNo",
			rows:"miv_pageSize"
		},
		rowNum : 200,
		rowList: [10, 15, 25, 50, 100, 200],
		loadError : function(xhr,st,err) {
			alert("Server Failure !!!" + "Type: "+st+"; Response["+ xhr.status + "]: "+xhr.statusText );
			//$("#tblcontentsMessage").html("Type: "+st+"; Response: "+ xhr.status + " "+xhr.statusText); 
		}		
	});

/*
var gwdth = $("#gridarea").width();
$(window).bind('resize', function() {
    $("#list").setGridWidth(gwdth);
}).trigger('resize');
*/

/**
 * jqGrid 
 * desc   : 선택된 Rows를 Dataset Array를 만들어준다.
 *          isAll에 true를 넣어주면 전체 데이터를 가져온다.
 * return : array
 * 
 * comment : 데이터가 선택되지 않으면 빈 배열을 리턴한다.
 */
jQuery.fn.getArrayFromGridRow = function(isAll) {
	var _isAll = false;
	if ( arguments.length > 0 && isAll == true ) {
		_isAll = true;
	}

    var arrayData = [];	
	try {
        var $grid = this;
        
        // jqGird검사
        if ( $grid.jqGrid == null || $grid.jqGrid == undefined ) {
            return arrayData;
        }
        
        var selRows = ( _isAll ? $grid.getDataIDs() : $grid.getGridParam("selarrrow") );
        $.each(selRows, function(index, value) {
            arrayData[index] = $grid.getRowData(value);
        });
	}
	catch(e) {
		alert(e.message);
		return arrayData;
	}
	
    return arrayData;
};

/**
 * jqGrid 
 * desc   : 현재 선택된 Rows를 Dataset Array를 만들어준다.
 * return : array
 */
jQuery.fn.getArrayFromMultiSelectedRow = function() {
	return this.getArrayFromGridRow(false);
};

/**
 * jqGrid 
 * desc   : 전체 row를 Dataset Array를 만들어준다.
 * return : array
 */
jQuery.fn.getArrayFromAllRow = function() {
	return this.getArrayFromGridRow(true);
};

/**
 * jqGrid
 * desc   : form의 데이터를 json 형태로 변환해 준다.
 * return : 성공시에는 객체(JSON)을 리턴한다. 실패시에는 null을 리턴한다.
 */
jQuery.fn.serializeObject = function() {
	var obj = null;
	try {
		if ( this[0].tagName && this[0].tagName.toUpperCase() == "FORM" ) {
			var arr = this.serializeArray();
			if ( arr ) {
				obj = {};
				jQuery.each(arr, function() {
					obj[this.name] = this.value;
				});				
			}//if ( arr ) {
 		}
	}
	catch(e) {alert(e.message);}
	finally  {}
	
	return obj;
};

/**
* for Fix IE new line bug with textarea
*
*/
jQuery.fn.newLineUnFormatter = function(val) {
	//alert(val);
	return val;
};

