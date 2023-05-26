String.prototype.replaceAll = function(prepend, after){
	return this.split(prepend).join(after);
}

Date.prototype.formatter = function(type){
	var dt = this,
	yyyy = getTen(dt.getFullYear()),
	mm = getTen(dt.getMonth()+1),
	dd = getTen(dt.getDate()),
	hh24 = getTen(dt.getHours()),
	mi = getTen(dt.getMinutes()),
	ss = getTen(dt.getSeconds());
	
	if(type){
		return type.replace('yyyy', yyyy).replace('mm', mm).replace('dd', dd)
					.replace('hh24', hh24).replace('mi', mi).replace('ss', ss);
	}else{
		return hh24 + ':' + mi + ':' + ss;
	}
	
	function getTen(num){
		return num>9 ? ''+num : '0'+num;
	}
}

$.fn.animateNumber = function(value, decimal){
	var target = this;
	var beforeValue = this.text() ? this.text().split(',').join('') : 0;
	// Animate the element's value from x to y:
	$({someValue: beforeValue}).animate({someValue: value},{
		duration: 1000,
		easing:'swing', // can be anything
		step: function() { // called on every step
			setNumber(target, this.someValue);
	    },
	    complete: function(){
	    	setNumber(target, this.someValue);
	    }
	});
  
	function setNumber(target, value){
		//Update the element's text with rounded-up value:
//		target.text(commaSeparateNumber(Math.round(value)));
		target.text(value.format(decimal));
	}
	
	function commaSeparateNumber(val){
		while (/(\d+)(\d{3})/.test(val.toString())){
			val = val.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
		}
		return val;
	}
}

// 숫자 타입에서 쓸 수 있도록 format() 함수 추가
Number.prototype.format = function(decimal){
    if(this==0) return 0;
    decimal = decimal ? decimal : 0;
 
    var reg = /(^[+-]?\d+)(\d{3})/;
    var n = (this.toFixed(decimal) + '');
 
    while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
 
    return n;
};
 
// 문자열 타입에서 쓸 수 있도록 format() 함수 추가
String.prototype.format = function(decimal){
    var num = parseFloat(this);
    if( this == '' ) return '0';
    if( isNaN(num) ) return '0';
 
    return num.format(decimal);
};



$.ajaxSetup({
	timeout: 45*1000
});


window.mobileAndTabletcheck = function() {
	var check = false;
	(function(a){if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4)))check = true})(navigator.userAgent||navigator.vendor||window.opera);
	return check;
}

/**
 * https://datatables.net/manual/data/
 */
$.extend($.fn.dataTable.defaults, {
	serverSide: true,
	processing: true,
	language: {
		processing: '<i class="fa fa-spinner fa-spin"></i> Processing...'
	},
	ordering: false,
	pagingType: 'full_numbers',
	dom: '<"dataTables_filter">trip',
	ajax: {
		dataSrc: 'data',
		dataFilter: function(data){
			//console.log(data);
            var json = jQuery.parseJSON( data );
            json.recordsTotal = json.data[1];
            json.recordsFiltered = json.data[1];
            json.data = json.data[0];
            return JSON.stringify( json ); // return JSON string
        }
	},
    initComplete: function(settings, json){
    	var id = this[0].id;
    	var $modal = $(this).parent();
    	
		var toolbar =
		 		'<label>기간:<input type="text" class="form-control input-sm" name="date_st" /> ~<input type="text" class="form-control input-sm" name="date_ed" /></label>'
		 		+' <button type="button" class="btn btn-sm btn-primary"><i class="fa fa-search"></i> 검색</button>'
	//	 		+' <button type="button" class="btn btn-sm btn-success"><i class="fa fa-file-excel-o"></i> Excel</button>'
		$modal.find('.dataTables_filter').html(toolbar)
	 			.find('input[name=date_st], input[name=date_ed]').datepicker().val((new Date()).formatter('yyyy-mm-dd'));
    	
	 	$modal.find('.btn-primary').on('click',function(){
	 		$('#'+id).DataTable().ajax.reload();
	 	})
    }
});

Highcharts.setOptions({
	global: {
		useUTC: false
	}
});

(function($) {
	if($.datepicker) {
		$.datepicker._defaults.buttonImage = CONTEXT_ROOT + 'resources/img/ico_calendar.png';
		$.datepicker._defaults.showOn = "both";
		$.datepicker._defaults.buttonText = "날짜선택";
		$.datepicker._defaults.showButtonPanel = true;
	}
});


/**
 * form 상태의 parameter-value를 Object로 변환하여 리턴
 */
$.fn.serializeObject = function() {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value.trim() || '');
        } else {
            o[this.name] = this.value.trim() || '';
        }
    });
    return o;
};

function isUndifined(value){

	if(typeof value !== 'undefined'){
		return value
	}
	else{
		return null;
	}
}

function isNull(obj) {
	if(obj == null || obj == "undefined"  || obj == "" ) {
		return true;
	}
	else {
		return false;
	}
};