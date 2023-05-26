/********** CTR : Control
************************************************************/

/*
 * $('.ip_address').mask("000.000.000.000", options);
*/
var ipOption = { 
    onKeyPress: function(cep, event, currentField, options){
//          console.log('An key was pressed!:', cep, ' event: ', event,'currentField: ', currentField, ' options: ', options);
		if(cep){
			var ipArray = cep.split(".");
			var lastValue = ipArray[ipArray.length-1];
			if(lastValue !== "" && parseInt(lastValue) > 255){
			    ipArray[ipArray.length-1] =  '255';
			    var resultingValue = ipArray.join(".");
			    currentField.attr('value',resultingValue);
			}
		}             
    }
};

var ElCTR = {
		/*Input : {
			ipAddr : function(){
				
			}
		},*/
		Select : {
			addOpt : function(id, value, boolEmpty){
				
				var html = '';
				$.each(value, function(index, item){
					if(index == 0){
						if(boolEmpty) {
							html += '<option value="">선택</option>';
						}
					}
					html += '<option value="' + item.code + '">' + item.name + '</option>'
				});
				
				$(id).append(html);
			}
		}
}

var CTR = {
	
		
		/***** 텍스트박스
		******************************/
		inputText 	: {
			draw : function(sName, value, display){
				$('[name="' + sName + '"]').append($(this).html(sName, value, display));
			},
			html : function(sName, value, display){
				var html = '<input type="text" name="' + sName + '" value="' + value + '" class="form-control" aria-label="...">';
				return html;
			}
		},
		
		/***** 텍스트박스+콤보박스
		******************************/
		/*		
		 * <div class="form-group row mb-2">
		        <div class="col-2 pr-0">
		            <label for="input-equip-field-1" class="col-form-label">field 2</label>
		        </div>
		
		        <div class="col-10">
		            <div class="row ">
		                <div class="col-lg-7 col-6 pr-0">
		                    <input type="text" class="form-control" id="input-equip-field-1" placeholder="">
		                </div>
		                <div class="col-lg-3 col-4 pl-0">
		                    <select class="form-control">
		                        <option>선 택</option>
		                        <option>Option 1</option>
		                        <option>Option 2</option>
		                        <option>Option 3</option>
		                    </select>
		                </div>
		                <div class="col-lg-2 col-1 pl-0">
		                    <button class="btn btn-success btn-rounded">
		                        <strong>X</strong>
		                    </button>
		                </div>
		            </div>
		        </div>
		    </div>
		*/
		cboText : {
			draw : function(sName, aCboData, bEmptyYn, sFirstCode, sFirstName){
				$('[name="'+ sName +'"]').append($(this).html(sName, aCboData, bEmptyYn, sFirstCode, sFirstName));
			},
			html : function(sName, aCboData, bEmptyYn, sFirstCode, sFirstName){
				var nmName = sName + 'Nm';
				var cdName = sName + 'Cd';
				var liHtml = '';
				
				$.each(aCboData, function(index, item){
					if(index == 0){
						if(bEmptyYn) {
							liHtml += '<option value="">&nbsp;</option>';
						}
					}
					liHtml += '<option value="' + item.code + '">' + item.name + '</option>'
				});
				
				var html = '<div class="input-group cboText '+ sName + '">';
				html += '<input type="text" name="' + nmName + '" value="" class="form-control" aria-label="...">';
				html += '<div class="input-group-btn">';
				html += '<input type="hidden" name="' + cdName + '" value="' + sFirstName + '" style="display: none;" >';
				html += '<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style="width:77px;">';
				html += sFirstCode + '&nbsp';
				//html += '선택' + '&nbsp';
				html += '<span class="caret"></span>';
				html += '</button>';
				html += '<ul class="dropdown-menu dropdown-menu-right" role="menu">';
				html += liHtml;
				html += '</ul>';
				html += '</div>';
				html += '</div>';
				
				return html;
			},
			set : function(sName, sCode, sName, bText){
				var nmName = 'txt' + sName;
				var cdName = 'cbo' + sName;
				$('[name="'+ cdName +'"]').attr('value', sCode);
				
				$('[name="'+ cdName +'"]').attr('value', sCode);
				if(bText)
					$('[name="'+ nmName +'"]').html(cboText + ' <span class="caret"></span>');
				else
					$('[name="'+ cdName +'"]').next().html(sName + '&nbsp<span class="caret"></span>');
			}
		},

		/***** 텍스트박스+콤보박스
		 *    콤보박스 선택 시 텍스트박스에 데이터가 들어가야 하는 ctr
		******************************/
		
		cboInText : {
			html : function(sName, aCboData, bEmptyYn, sFirstCode, sFirstName){
				var nmName = sName + 'Nm';
				var cdName = sName + 'Cd';
				var liHtml = '';
				$.each(aCboData, function(index, item){
					if(index == 0){
						if(bEmptyYn) {
							liHtml += '<a class="dropdown-item" href="#" data-value="">&nbsp; </a>';	
						}
						/*else {
							firstCode = item.code;
							firstName = item.name;
						}*/
					}
					liHtml += '<a class="dropdown-item" href="#" data-value="' + item.code + '">' + item.name + ' </a>';
				});
				/*
				 * <div class="input-group">
					    <input type="text" class="form-control" placeholder="" aria-label="" aria-describedby="basic-addon1">
					    <div class="input-group-prepend">
					        <button class="btn btn-primary   dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> 선 택 </button>
					        <div class="dropdown-menu">
					            <a class="dropdown-item" href="#">Action</a>
					            <a class="dropdown-item" href="#">Another action</a>
					            <a class="dropdown-item" href="#">Something else here</a>
					        </div>
					    </div>
					</div>
				*/
				var html = '';
				html +='<div class="input-group cboInText">';
				html +='<input type="text" class="form-control" placeholder="" aria-label="" aria-describedby="" id="' + nmName + '" name="' + nmName + '" value="' + sFirstName + '">';
				html +='<div class="input-group-prepend">';
				html +='<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> 선 택 </button>';
				html +='<input type="hidden" id="' + cdName + '" name="' + cdName + '" value="' + sFirstCode + '" style="display: none;" >';
				html +='<div class="dropdown-menu">';
				html += liHtml;
				html +='</div>';
				html +='</div>';
				html +='</div>';
				
				return html; 
			} 	
		},
		
		/***** 콤보박스
		******************************/
		cboBox : {
			draw : function(sName, aCboData, bEmptyYn, sFirstCode, sFirstName){
					$(sName).append($(this).html(sName, aCboData, bEmptyYn, sFirstCode, sFirstName));
				},
			html : function(sName, aCboData, bEmptyYn, sFirstCode, sFirstName){
				var nmName = 'nm' + sName;
				var cdName = 'cd' + sName;
				var liHtml = '';
				$.each(aCboData, function(index, item){
					if(index == 0){
						if(bEmptyYn) {
							liHtml += '<li><a href="#" data-value="">&nbsp; </a></li>';	
						}
						/*else {
							firstCode = item.code;
							firstName = item.name;
						}*/
					}
					liHtml += '<li><a href="#" data-value="' + item.code + '">' + item.name + ' </a></li>';
				});
				
				var html = '<div class="dropdown cboBox '+ sName + '">';
				html += '<input type="hidden" name="' + cdName + '" value="' + sFirstCode + '" style="display: none;" >';
				html += '<button style="width:100%" class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">';				
				html += '<span name="' + nmName + '" style="overflow:hidden;">' + sFirstName + '</span>';
				html += '<span class="caret"></span>';
				html += '</button>';
				html += '<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">';
				html += liHtml;
				html += '</ul>';
				html += '</div>';
				
				return html; 
			} 
		},
		
		titlePanel : {
			draw : function(sLocName){
				$('[name="'+ sLocName +'"]').append($(this).html(sTitle));
			},
			html : function(name, sTitle, chartNo){
				var titleName = 'tl' + name;
				var bodyName = 'bd' + name;
				var html  = '<div class="chartGrourp" value="' + chartNo + '">';
				html += '<div class="col-sm-4 col-xs-12">';
				html += '<div class="panel panel-primary">';
				html += '<div class="panel-heading">';
				html += '<div class="row">';
				html += '<div class="col-xs-8"><h3 class="panel-title" name= "' + titleName + '">' + sTitle + '</h3></div>';
				/*html += '<div class="col-xs-1"><button type="button" class="btn btn-primary" name="btnDel" aria-label="Left Align" style="border:0px; padding:0px;"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></button></div>';*/
				html += '<div class="col-xs-1"><button type="button" class="btn btn-primary" name="btnGoUrl" aria-label="Left Align" style="border:0px; padding:0px;"><span class="glyphicon glyphicon-comment" aria-hidden="true"></span></button></div>';
				html += '<div class="col-xs-1"><button type="button" class="btn btn-primary" name="btnPop" aria-label="Left Align" style="border:0px; padding:0px;"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></button></div>';
				html += '<div class="col-xs-1"><button type="button" class="btn btn-primary" name="btnDel" aria-label="Left Align" style="border:0px; padding:0px;"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button></div>';
				html += '</div>';
				html += '</div>';
				html += '<div class="panel-body" name="' + bodyName + '" style="height:300px; padding:0px;">';
				html += 'Panel content';
				html += '</div>';
				html += '</div>';
				html += '</div>';
				
				return html;
				
				
			}
		}
		
}
