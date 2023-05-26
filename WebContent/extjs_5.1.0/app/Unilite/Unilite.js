//@charset UTF-8

window.onerror = function(msg, url, line, col, error) {
   // Note that col & error are new to the HTML 5 spec and may not be 
   // supported in every browser.  It worked for me in Chrome.
   var extra = !col ? '' : '\ncolumn: ' + col;
   extra += !error ? '' : '\nerror: ' + error;

   // You can view the information in an alert to see things working like this:
   var errorMsg = "Error: " + msg + "\nurl: " + url + "\nline: " + line + extra;
   console.log(errorMsg);
   alert(errorMsg);

   // TODO: Report this error via ajax so you can keep track
   //       of what pages have JS issues

   var suppressErrorAlert = false; // true
   // If you return true, then error alerts (like in older versions of 
   // Internet Explorer) will be suppressed.
   return suppressErrorAlert;
};
/*
 * Debuger가 설치 안된 브라우져(일부 IE)에서 console 오류 발생 방지
 */
var alertFallback = false;

if (typeof console === "undefined" || typeof console.log === "undefined") {
	// https://developer.mozilla.org/en-US/docs/Web/API/console
	console = {
		/**
	    * @private
	    */
		_out: function(msg) {
			if (alertFallback) {
					alert(msg);
			}
		},
		log: function(msg) {
			this._out(msg);
		},
		info: function(msg) {
			this._out(msg);
		},
		warn: function(msg) {
			this._out(msg);
		},
		error: function(msg) {
			this._out(msg);
		}
	};
}

function hideAddressBar() {
  if(!window.location.hash){
      if(document.height < window.outerHeight)
      {
          document.body.style.height = (window.outerHeight + 50) + 'px';
      }
 
      setTimeout( function(){ 
        window.scrollTo(0, 1);
       }, 50 );
  }
}




/**
 * @class Unilite
 * ## 사용예 
 * 
 * 
 */


//Ext.Error.handle = function(err) {
//    if (err.someProperty == 'NotReallyAnError') {
//        // maybe log something to the application here if applicable
//        return true;
//    }
//    console.log("ERROR!ERRO!\n");
//    console.log(err);
//    // any non-true return value (including none) will cause the error to be thrown
//}


Ext.define('Unilite', {
    singleton: true,
    requires: [
    	'Unilite.com.UniValidator'
	],
	/**
	 * default DB용 date format (Ymd, '20141231')
	 * @type String
	 */
    dbDateFormat: 'Ymd',
    dbMonthFormat: 'Ym',
    /**
	 * default date display format (Ymd, '2014.12.31')
	 * system설정에따라 변경됨.
	 * @type String
	 */
    dateFormat :'Y.m.d',
    monthFormat :'Y.m',
    /**
     * 
     * @type String
     */
    altFormats : 'Ymd|Y.m.d|Y/m/d|Y-m-d|Y-m-d H:i:s',
    altMonthFormats : 'Ym|Y.m|Y/m|Y-m|Ymd|Y.m.d|Y/m/d|Y-m-d',
    /**
     * null이나 empty이면 defaultValue를 돌려줌
     * @param {} obj
     * @param {} defaultValue
     * @return {}
     */
    nvl: function(obj, defaultValue) {
    	if(!Ext.isDefined(obj)) { 
    		return defaultValue;
    	}
		return Ext.isEmpty(obj) ? defaultValue : obj;
	}, // nvl
    /**
     * 확장자 "do"인 js 프로그램 Load 함수.
     * @param {} className
     * @param {} onLoad
     * @param {Object} scope
     * @param {Boolean} forceReload
     */
	require: function(className, onLoad, scope, forceReload) {
        var Loader = Ext.Loader,
            Manager = Ext.ClassManager,
            pass = Ext.Function.pass;
            
        scope = scope || Ext.global;
        if(!Ext.isDefined(forceReload)) {
            forceReload = false;
        }
        
        var isCreated = false;
        // 한번 로딩 했으면 다시 읽지 않게 처리
        if(forceReload) {
            isCreated = false;
            var objArray=Ext.ComponentQuery.query(className);
            console.log("forceReload. Ext.ComponentQuery.query: ",className);
            if(objArray) {
                for (var i=0; i<objArray.length; i++) {
				    objArray[i].destroy();
				}
            }
        } else {
            isCreated = Manager.isCreated(className); 
        }
        if(!isCreated) {
	        var filePath = Loader.getPath(className);
	        if(!Ext.isEmpty(EXT_ROOT))
	        	filePath = filePath.replace(EXT_ROOT+"/", "")
	        filePath = filePath.substring(0, filePath.length-3) + '.do';
	        if(!onLoad) {
	             onLoad = function() { console.log(className + " loaded.");};
	        }
	        //Ext.Loader.loadScriptFile(newPath,onLoad,function() {},Ext.Loader,false);
	        //deprecated 5.0.1
//	        Loader.loadScriptFile(
//	                        filePath,
//	                        onLoad, //pass(Loader.onFileLoaded, [className, filePath], Loader),
//	                        pass(Loader.onFileLoadError, [className, filePath], Loader),
//	                        Loader,
//	                        false
//	        );        
	        Loader.loadScript({
	        				url : filePath,
	        				onLoad: onLoad, //pass(Loader.onFileLoaded, [className, filePath], Loader),
	        				onError: pass(Loader.onFileLoadError, [className, filePath], Loader),
	        				scope: Loader
	        });
	        console.log("Dynamic javascript load. Path = " + filePath);
        } else {
            onLoad.call(scope);
        }
    },
	grid: {
		comboRenderer : function(combo){
		    return function(value){
		        //multiSelect 일 때 grid에서 combo 선택하면 blank 로 보여되는 오류로 인해 변경
//		        var record = combo.findRecord(combo.valueField, value);
//		        return record ? record.get(combo.displayField) : combo.valueNotFoundText;
		    	
		    	var valueNotFoundText = combo.valueNotFoundText,
		            i, len, record,
		            dataObj,
		            displayTplData = [];
						
		        if(combo.multiSelect && typeof value === 'string' && value.indexOf(combo.delimiter.trim()) > -1 ) {
		        	value = value.split(combo.delimiter.trim());
		        }else{
		        	value = Ext.Array.from(value);
		        }
		        for (i = 0, len = value.length; i < len; i++) {
		            record = value[i];
		            if (!record || !record.isModel) {
		                record = combo.findRecordByValue(record);
		            }
		 
		            if (record) {
		                displayTplData.push(record.data);
		            }
		            else {
		                if (!combo.forceSelection) {
		                    dataObj = {};
		                    dataObj[combo.displayField] = value[i];
		                    displayTplData.push(dataObj);
		                }
		                else if (Ext.isDefined(valueNotFoundText)) {
		                    displayTplData.push(valueNotFoundText);
		                }
		            }
		        }
				        
		        combo.displayTplData = displayTplData;
		        combo.setRawValue(combo.getDisplayValue());
		        
		    	return combo.getRawValue();
		    }
		}
	}, // grid,
	form: {
		createCombobox : function(field) {
			var lComboType = field.comboType, 
				lComboCode=field.comboCode;
			var lAllowBlank = Unilite.nvl(field['allowBlank'],true);
			var comboConfig ={ 
							comboType: field.comboType,
							comboCode: field.comboCode,
							allowBlank: field.allowBlank,
							store:field.store
						};
			// 다단계 콤보 처리 
			if(field.child) {
				Ext.apply(comboConfig, {'child': field.child})
			}
			if(field.parentFieldName) {
				Ext.apply(comboConfig, {'parentFieldName': field.parentFieldName})
			}	
			if(field.name) {
				Ext.apply(comboConfig, {'name': field.name})
			}
			if(field.displayField) {
				Ext.apply(comboConfig, {'displayField': field.displayField})
			}
			if(field.valueField) {
				Ext.apply(comboConfig, {'valueField': field.valueField})
			}
			if(Ext.isDefined(field.multiSelect)) {
				Ext.apply(comboConfig, {'multiSelect': field.multiSelect})
			}
			if(Ext.isDefined(field.typeAhead)) {
				Ext.apply(comboConfig, {'typeAhead': field.typeAhead})
			}
			if(field.parentNames) {
				Ext.apply(comboConfig, {'parentNames': field.parentNames})
			}
			if(field.levelType) {
				Ext.apply(comboConfig, {'levelType': field.levelType})
			}
			if(field.delimiter) {
				Ext.apply(comboConfig, {'delimiter': field.delimiter})
			}
			var combo ;
			if(Ext.isDefined(field.multiSelect)) {
				combo = Ext.create('Unilite.com.form.field.UniComboBox', comboConfig);	
			}else {
				combo = Ext.create('Unilite.com.form.field.UniComboBox', comboConfig);
			}
			return combo;
		} 
	},// form
	
	/**
	 * 모델을 정의 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.data.Model}
	 */
	defineModel : function (id, config) {
		config = this._fieldConfigure(config);
		Ext.apply(config, {extend:'Unilite.com.data.UniModel'});
		Ext.define(id, config);
	},
		/**
	 * Tree 모델을 정의 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.data.Model}
	 */
	defineTreeModel : function (id, config) {
		config = this._fieldConfigure(config);
		Ext.apply(config, {extend:'Unilite.com.data.UniTreeModel'});
		Ext.define(id, config);
	},
    /**
     * @private
     * @param {} config
     * @return {}
     */
	_fieldConfigure:function(config) {
		var types = Ext.data.Types;
		if(config.fields) {
			for(i =0, len = config.fields.length; i< len; i ++ ) {
				var field = config.fields[i];
				if(field.type) {
//					if(field.type == 'uniDate') {
//						field.type = types.UNIDATE;
//						Ext.apply(field, {dateWriteFormat : Unilite.dbDateFormat});
//					} else if (field.type == 'uniMonth') {
//						field.type = types.UNIMONTH;
//						Ext.apply(field, {dateWriteFormat : Unilite.dbMonthFormat});
//					} else if (field.type == 'uniQty') {
//						field.type = types.UNIQTY;
//					} else if (field.type == 'uniUnitPrice') {
//						field.type = types.UNIUNITPRICE;
//					} else if (field.type == 'uniPrice') {
//						field.type = types.UNIPRICE;
//					} else if (field.type == 'uniPercent') {
//						field.type = types.UNIPERCENT;
//					} else if (field.type == 'uniFC') {
//						field.type = types.UNIFC;
//					} else if (field.type == 'uniER') {
//						field.type = types.UNIER;
//					} else if (field.type == 'uniTime') {
//						field.type = types.UNITIME;
//					} else if (field.type == 'uniYear') {
//						field.type = types.UNIYEAR;
//					} else if (field.type == 'uniPassword') {
//						field.type = types.UNIPASSWORD;
//					}
				}
				if(Ext.isDefined( field.allowBlank) ) {
					if( field.allowBlank  == false ) {
//						config.validations = config.validations || [];
//						config.validations.push({'type': 'presence', 'field': field.name});
						config.validators = config.validators || [];
						config.validators.push({'type': 'presence', 'field': field.name});
					}
					
				}
				// child field 처리 
				if(field.child) {
					for(var j = 0; j < len; j++) {
						if(config.fields[j].name == field.child) {
							config.fields[j].parentFieldName = field.name;
							console.log(field.name + '\'s child is ' + field.child +'. '+ config.fields[j].name + ' parent is ' + field.name);
							//Ext.apply
							break;
						}
					}
				}
			}
		}
		return config;
	}, 
	/**
	 * UniStore 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.data.UniStore}
	 */
	createStore: function(id, config) {
		// Ext.apply(config, {'id':id, storeId: id});
        Ext.apply(config, {storeId: id});
		return  Ext.create('Unilite.com.data.UniStore', config);
	}, 
    /**
     * UniStore 생성 
     * @param {} id
     * @param {} config
     * @return {Unilite.com.data.UniStore}
     */
    createStoreSimple: function(id, config) {
        // Ext.apply(config, {'id':id, storeId: id});
        Ext.apply(config, {storeId: id});
        return  Ext.create('Unilite.com.data.UniStoreSimple', config);
    },     
	/**
	 * UniGridPanel 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.grid.UniGridPanel}
	 */
	createGrid : function(id, config) {
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id':id});
		}
		return  Ext.create('Unilite.com.grid.UniGridPanel', config);
	},
	/**
	 * UniTreeStore 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.data.UniTreeStore}
	 */
	createTreeStore: function(id, config) {
		//Ext.apply(config, {'id':id});
        Ext.apply(config, {storeId: id});
		return  Ext.create('Unilite.com.data.UniTreeStore', config);
	},	
	/**
	 * UniTreeGridPanel 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.grid.UniGridPanel}
	 */
	createTreeGrid : function(id, config) {
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id':id});
		}
		return  Ext.create('Unilite.com.grid.UniTreeGridPanel', config);
	},	
	/**
	 * uniSearchForm 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.form.UniSearchForm}
	 */
	createSearchForm : function(id, config) {
		Ext.apply(config, {'xtype':'uniSearchForm'});
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
		//return  config;
		return Ext.create('Unilite.com.form.UniSearchForm', config);
	},
    /**
     * uniSearchForm 생성 
     * @param {} id
     * @param {} config
     * @return {Unilite.com.form.UniSearchForm}
     */
    createSearchPanel : function(id, config) {
    	Ext.apply(config, {'xtype':'uniSearchPanel'});
    	if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
        //return  config;
        return Ext.create('Unilite.com.form.UniSearchPanel', config);
    },    
	/**
	 * uniDetailForm 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.form.UniDetailForm}
	 */
	createForm : function(id, config) {
		//popup 창 폼의 경우  id 룰 부여하면 중복날 수 있음.->popup의 ext.component 개체들은 id를 할당하지 않는다.
		//id를 할당하지 않으면 자동할당 됨.
		//Ext.apply(config, {'xtype':'uniDetailForm', 'id': id});
		Ext.apply(config, {'xtype':'uniDetailForm'});
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
		//return  config;
		return Ext.create('Unilite.com.form.UniDetailForm', config);
	},
	/**
	 * uniDetailFormSimple 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.form.UniDetailFormSimple}
	 */
	createSimpleForm : function(id, config) {
		Ext.apply(config, {'xtype':'uniDetailFormSimple'});
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
		//return  config;
		return Ext.create('Unilite.com.form.UniDetailFormSimple', config);
	},
	 /**
     * uniOperatePanel 생성 
     * @param {} id
     * @param {} config
     * @return {Unilite.com.form.UniSearchForm}
     */
    createOperatePanel : function(id, config) {
        Ext.apply(config, {'xtype':'uniOperatePanel'});
        if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id': id});
		}
        //return  config;
        return Ext.create('Unilite.com.form.UniOperatePanel', config);
    },  
	/**
	 * UniTabPanel 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.tab.UniTabPanel}
	 */
	createTabPanel : function(id, config) {
		if(!Ext.isEmpty(id)) {
			Ext.apply(config, {'id':id});
		}
		return  Ext.create('Unilite.com.tab.UniTabPanel', config);
	},	
	/**
	 * ValidateService 생성 
	 * @param {} id
	 * @param {} config
	 * @return {Unilite.com.ValidateService}
	 */
	createValidator : function(id, config) {
		Ext.apply(config, {'id':id});
		return  Ext.create('Unilite.com.ValidateService', config);
	},
	/**
	 * 
	 * @param {Object} config
	 * @return {Unilite.com.BaseApp}
	 */
	Main: function(config) {
		return Ext.create('Unilite.com.BaseApp',config);
	},
	
	/**
	 * 
	 * @param {Object} config
	 * @return {Unilite.com.BasePopupApp}
	 */
	PopupMain: function(config) {
		return Ext.create('Unilite.com.BasePopupApp',config);
	},
	/**
	 * Client가 Mobile인지 확인
	 * @return {boolean}
	 */
	isMobile: function() {
		if( this._isMobile === undefined) {
			var a = navigator.userAgent;
			// http://detectmobilebrowsers.com/
			//if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4)))  {
			if (/(ipad).+mobile|(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a) )  {
				this._isMobile = true;
			} else {
				this._isMobile = false;
			}
		}
		return this._isMobile;
	},
    getViewportSize: function() {
        var viewportwidth;
	    var viewportheight;
	    // The more standards compliant browsers (mozilla/netscape/opera/chrome/IE7)
	    // use window.innerWidth and window.innerHeight
	    if (typeof window.innerWidth != 'undefined') {
	        viewportwidth = window.innerWidth;
	        viewportheight = window.innerHeight;
	    }
	    // IE6 in standards compliant mode (i.e. with a valid doctype as the first
	    // line in the document)
	    else if (typeof document.documentElement != 'undefined'
	            && typeof document.documentElement.clientWidth != 'undefined'
	            && document.documentElement.clientWidth != 0) {
	        viewportwidth = document.documentElement.clientWidth;
	        viewportheight = document.documentElement.clientHeight;
	    }
	    // older versions of IE
	    else {
	        viewportwidth = document.getElementsByTagName('body')[0].clientWidth;
	        viewportheight = document.getElementsByTagName('body')[0].clientHeight;
	    }
	    return {width:viewportwidth, height: viewportheight};
	},
    getOrientation: function() {
	    var orientation = window.orientation;
	    var rv = '';
	
	    if (orientation === 0 || orientation === 180)
	        rv = 'portrait';
	    else if (orientation === 90 || orientation === -90)
	        rv = 'landscape';
	    else {
	        // JavaScript orientation not supported. Work it out.
	        if (document.documentElement.clientWidth > document.documentElement.clientHeight)
	            rv = 'landscape';
	        else
	            rv = 'portrait';
	
	    }
	    return rv;
	},
	getScale: function() {
	    return document.body.clientWidth / window.innerWidth;
	},
	/**
	 * 검증 함수 모음.
	 * @param {String} type
	 * residentno | bizno | phone | isDate
	 * @param {String} value
	 * @return {Boolean}
	 */
	validate: function (type, value) {
		var rv;
		switch(type) 	{
			case 'residentno':
				rv = UniValidator.residentno(value);
				break;
			case 'bizno':
				rv = UniValidator.bizno(value);
				break;
			case 'phone':
				rv =  UniValidator.phone(value);
				break;
			case 'homephone':
				rv =  UniValidator.homephone(value);
				break;
			case 'handphone':
				rv =  UniValidator.handphone(value);
				break;
			case 'isDate':
				rv =  UniValidator.isDate(value);
				break;
			
			default:
				rv = false;
		}
		return rv;
	}
	,isGrandSummaryRow:function (summaryData, metaData) {
		//if(Ext.String.endsWith(summaryData.record.id,'grand-summary-record')) {
		if(metaData.record.ownerGroup){
			return false;
		} else {
			return true;
		}		
	}
	,renderSummaryRow: function (summaryData, metaData, sumLabel, gsumLabel) {
		var rv = '<div align="center"></div>';
                  	
      	if(this.isGrandSummaryRow(summaryData, metaData)) {
			rv =  '<div align="center">'+gsumLabel+'</div>';
    	}  else {
			rv = '<div align="center">'+sumLabel+'</div>';
    	}
		return rv;
	}
	/**
	 * Object.keys(object) 가 IE 9 부터 지원 되어 별도로 구현 함.
	 * @param {} object
	 * @return {Array}
	 */
	,getKeys : function(object) {
		if (Type(object) !== OBJECT_TYPE) { throw new TypeError(); }
	    var results = [];
	    for (var property in object) {
	      if (object.hasOwnProperty(property)) {
	        results.push(property);
	      }
	    }
	    return results;
	}
	,getParams: function() {
		var getParams = document.URL.split("?");
		return Ext.urlDecode(getParams[getParams.length - 1]);
	},
	/**
	 * form에서 다음 폼필드로 포커스 이동
	 * @param {} field	현재 focus를 가지고 있는 폼 필드
	 * @param {} selectText	텍스트 선택 상태 활성화 여부 (optional)
	 */
	focusNextField: function(field, selectText, e) {
		var form = field.up('form');
		var focusable, targetField;		

		if(form && field.isFormField) { //form 내 필드인 경우
			if(Ext.isDefined(field.triggerBlur))
				field.triggerBlur();
			else
				field.blur();
			
			focusable = field.nextNode('field:focusable');
			if(focusable && focusable.el) {
				targetField = focusable.el.down('.x-form-field');
				if(targetField) {
					targetField.focus(10);					
					if(selectText) 
						targetField.dom.select();
				}
			}else{
				// 조회 프로그램인 경우 마지막 필드인 경우 조회버튼 실행
				editablePGM = false;
				if(Ext.isDefined(PGM_ID) && PGM_ID.indexOf("ukr")==6)	{
					editablePGM = true;
				}
				
				var isPopup = (Ext.isDefined(form.el.up('.x-window')) && !Ext.isEmpty(form.el.up('.x-window')) ) ? true : false;
				
				if(!editablePGM && !isPopup)	{
					if(Ext.isDefined(UniAppManager) && Ext.isDefined(UniAppManager.app))	{
						UniAppManager.app.onQueryButtonDown();
					}
				} else {
					focusable = form.down('field:focusable')	// 마지막 form field 인 경우 폼의 처음에서 검색				
					if(focusable && focusable.el) {
						targetField = focusable.el.down('.x-form-field');
						if(targetField) {
							targetField.focus(10);						
							if(selectText) 
								targetField.dom.select();
						}else{
							field.focus();
						}
					}
				}
			}
		}else {	// //grid 내 필드인 경우
			var grid = field.up('grid');
			if(grid) {
				if (e.getKey() === Ext.EventObjectImpl.RIGHT || e.getKey() === Ext.EventObjectImpl.LEFT) {
					
					e.keyCode = Ext.EventObjectImpl.TAB;
					e.shiftKey = false;
					//e.target = field.el;
					//grid.getSelectionModel().getPosition().view.editingPlugin.fireEvent('specialkey', null, field, e);
					grid.editing.fireEvent('specialkey', null, field, e);
					e.stopEvent();
				}
				
			}
		}
	},
	/**
	 * form에서 이전 폼필드로 포커스 이동
	 * @param {} field	현재 focus를 가지고 있는 폼 필드
	 * @param {} selectText	텍스트 선택 상태 활성화 여부 (optional)
	 */
	focusPrevField: function(field, selectText, e) {
		var form = field.up('form');
		var focusable, targetField; 
		
		if(form && field.isFormField) { //form 내 필드인 경우
			if(Ext.isDefined(field.triggerBlur))
				field.triggerBlur();
			else
				field.blur();
			
			focusable = field.previousNode('field:focusable');
			if(focusable && focusable.el) {
				targetField = focusable.el.down('.x-form-field');
				if(targetField) {
					targetField.focus(10);					
					if(selectText) 
						targetField.dom.select();
				}
			}else{
				focusable = form.query('field:focusable')	// 맨처음 form field 인 경우 폼의 마지막 필드 검색
				focusable = focusable[focusable.length - 1];
				if(focusable && focusable.el) {
					targetField = focusable.el.down('.x-form-field');
					if(targetField) {
						targetField.focus(10);						
						if(selectText) 
							targetField.dom.select();
					}else{
						field.focus();
					}
				}
			}
		}else {	// //grid 내 필드인 경우
			var grid = field.up('grid');
			if(grid) {
				if (e.getKey() === Ext.EventObjectImpl.RIGHT || Ext.EventObjectImpl.LEFT) {
					e.keyCode = Ext.EventObjectImpl.TAB;
					e.shiftKey = true;
					//e.target = field.el;
					//field.fireEvent('specialkey', field, e);
					//grid.getSelectionModel().getPosition().view.editingPlugin.fireEvent('specialkey', null, field, e);
					grid.editing.fireEvent('specialkey', null, field, e);
					e.stopEvent();
				}
				
			}
		}
	}

});// define(UniLite)


function uniDirectExceptionProcessor(event) {
	console.log("uniDirectExceptionProcessor / Ext.direct.Exception:", event );
	var vMessage = "";
	var rexp = /<br \/>/g ;
	var sWHere = event.where.replace(rexp, "\n");
	if(event.message != sWHere) {
		vMessage = event.message + "<br/> - " + event.where
	}else {
		vMessage = event.where
	}
	
	if( event.type == "exception" ) {
		if (event.message == "InvalidSessionException") {
	 		Ext.MessageBox.show({
                title: 'Warning',
                msg: event.where,
                icon: Ext.MessageBox.ERROR,
                buttons: Ext.Msg.OK,
                fn: function(btn, text) {
                	document.location.href	= CPATH ;
                }
            });			
		} else {
	 		Ext.MessageBox.show({
                title: 'REMOTE EXCEPTION',
                msg: vMessage,
                icon: Ext.MessageBox.ERROR,
                buttons: Ext.Msg.OK
            });
		}
	
	} else {
			Ext.MessageBox.show({
                title:  event.type,
                msg: vMessage,
                icon: Ext.MessageBox.ERROR,
                buttons: Ext.Msg.OK
            });
	}
    Ext.getBody().unmask();
};


//Ext.apply(Ext.data.Types, {
//	UniPrice : {
//		convert: function(v) {
//	            if (typeof v === 'number') {
//	                return v;
//	            }
//	            return v !== undefined && v !== null && v !== '' ?
//	                parseFloat(String(v).replace(Ext.data.Types.stripRe, ''), 10) : (this.useNull ? null : 0);
//	        },
//	    sortType: Ext.data.SortTypes.none,
//	    type: 'uniPrice'
//	}
//});

Ext.apply(Ext.form.VTypes, {
	/**
	 * 연도 입력시 연도 비교용 
	 * @param {} val
	 * @param {} field
	 * @return {Boolean}
	 */
    yearRange : function(val, field) {
        // startYear, endYear
        if (field.startYearField && (!this.maxValue || (val != this.maxValue))) {
            var start = Ext.getCmp(field.startYearField);
            start.setMaxValue(val);
            //start.validate();
            this.maxValue = val;
        } else if (field.endYearField && (!this.minValue || (val != this.minValue))) {
            var end = Ext.getCmp(field.endYearField);
            end.setMinValue(val);
            //end.validate();
            this.minValue = val;
        }
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
        return true;
    },
    uniDateRange : function(val, field) {
    	if(! field.isInit ) {
    		field.isInit = true;
    		if(!val) {
    			return;
    		}
	        var date = field.parseDate(val);
	 
	        if(!date){
	            return;
	        }
	        if (field.startDateField && (!this.dateRangeMax || (date.getTime() != this.dateRangeMax.getTime()))) {
	            //var start = Ext.getCmp(field.startDateField);
	            var start = field.startDateField;
	            start.setMaxValue(date);
	            start.validate();
	            this.dateRangeMax = date;
	        }
	        else if (field.endDateField && (!this.dateRangeMin || (date.getTime() != this.dateRangeMin.getTime()))) {
	            //var end = Ext.getCmp(field.endDateField);
	            var end = field.endDateField;
	            end.setMinValue(date);
	            end.validate();
	            this.dateRangeMin = date;
	        }
	    	delete field.isInit; 
    	}
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
        return true;
    }
});

Ext.apply('Ext.form.field.Date', {format:Unilite.dateFormat});
Ext.apply('Ext.grid.PropertyColumnModel', {dateFormat:Unilite.dateFormat});
Ext.apply('Ext.picker.Date', {format:Unilite.dateFormat});
Ext.apply('Ext.util.Format', {dateFormat:Unilite.dateFormat});

	
// Advance File-Size
Ext.util.Format.fileSize = function(value) {
	if (value > 1) {
		var s = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
		var e = Math.floor(Math.log(value) / Math.log(1024));
		if (e > 0) {
			return (value / Math.pow(1024, Math.floor(e))).toFixed(2) + " " + s[e];
		} else {
			return value + " " + s[e];
		}
	} else if (value == 1) {
		return "1 Byte";
	}
	return '-';
}

String.format = function() {
	var s = arguments[0];
	for (var i = 0; i < arguments.length - 1; i++) {
		var reg = new RegExp("\\{" + i + "\\}", "gm");
		s = s.replace(reg, arguments[i + 1]);
	}
	return s;
}
