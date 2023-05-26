//@charset UTF-8
/**
 * 
 * event  onSelected : function( type(VALUE|TEXT), records(선택된 레코드들))
 * 
 */
Ext.define('Unilite.com.form.popup.UniPopupField', {
    extend: 'Ext.form.FieldContainer',
    alias: 'widget.uniPopupField',
    mixins: {
        observable: 'Ext.util.Observable',
        popupBehaviour:'Unilite.com.form.popup.UniPopupAbstract'
    },
    requires: [
        'Ext.form.field.Text',
        'Ext.form.Label',
   		'Unilite.com.form.popup.UniPopupFieldLayout'
    ],
    
    /**
     * 
     * @cfg {Boolean} 
     * Value field를 보여줄것인지 여부
     * 
     * true : value 필드를 hidden 처리함.
     * 
     */
    showValue:true,
    /**
     * 
     * @cfg {Boolean} 
     * Value field를 사용할지 여부
     * 
     * true : value field를 생성하지 않음.
     * 
     */
    textFieldOnly:false,
    
    padding: '0 0 0 0',
   	defaults: {
         hideLabel: true
    },
    componentLayout: 'uniPopupFieldLayout',
    layout: {
        type: 'table', columns: 2
        //,defaultMargins: { top: 0, right: 2, bottom: 0, left: 0 }
    },
    constructor : function(config){     
        var me = this;
        me.extParam = {};
        config.trackResetOnLoad = true;
        if (config) {
            Ext.apply(me, config);
        }
        me.mixins.popupBehaviour.constructor.call(me, config);
        me.callParent(arguments);
        //addEvents 제거 - 5.0.1 deprecated
//        me.addEvents('onSelected');
        
        this.store = new Ext.create('Ext.data.Store', {
        	autoload:false,
        	fields:[
		    	me.valueFieldName, 
		    	me.textFieldName
		    ],
        	proxy:{
		    	type: 'direct',
				        api: {
				        	read: me.api //'popupService.custPopup'
				        }
				    }
		        });
    },
    setReadOnly: function(readOnly) {
    	var me = this;
    	if( me.valueField) {
        	me.valueField.setReadOnly(readOnly);
        }
        me.textField.setReadOnly(readOnly);
        Ext.each(me.extraFields,  function(field){
        	field.setReadOnly(readOnly);
        });
    },
    // private
    initComponent: function() {
        var me = this;
        me.addCls('uni-popup-fields');
        //console.log("me.textFieldName", me.textFieldName, me.allowBlank);
        
   		var f1 = me._getValueFieldConfig(!me.showValue);
   		var f2 = me._getTextFieldConfig();
   		var others = me._getExtraFieldsConfig();
   		Ext.apply(f1, {fieldCls : 'x-form-field ' + me.fieldCls});
   		Ext.apply(f2, {fieldCls : 'x-form-field ' + me.fieldCls});
   		
   		var layoutCols = me.layout.columns;
   		if(!Ext.isEmpty(others)){
   			Ext.each(others, function(field) {
   				Ext.apply(field, {fieldCls : 'x-form-field ' + me.fieldCls});
   				layoutCols ++;
   			});
   			
   			Ext.apply(me.layout, {columns: layoutCols});
   		}
   		
   		
   		if(me.verticalMode) {
	       	if(me.textFieldOnly) {
	        	me.items =[ f2];
	       	} else {
	       		me.items =[Ext.applyIf(f1, {colspan: 2, margin: '0 5 0 0'}), f2 ];
	       		
	       		Ext.each(others, function(field) {
	   				me.items.push(field);
	   			});
	       	}
	       	
       	} else {
       		if(me.textFieldOnly) {
	        	me.items =[ f2];
	       	} else {
	       		me.items =[f1, f2 ];
	       		Ext.each(others, function(field) {
	   				me.items.push(field);
	   			});
	       	}
	       	
       	}
       	
        me.callParent(arguments);
        me.initRefs();
    },
    // private
    initRefs:function() {
    	var me = this;
       	if(! me.textFieldOnly) {
        	me.valueField = me.down('#' + me.id + '-valueField');
        }
        me.textField = me.down('#' + me.id + '-textField');
        me.extraFields = me.query('textfield[id^=' + me.id + '-extraField]');
    },
    getExtraFields: function() {
    	return me.extraFields;	
    },
    
    /**]
     * 
     * @param {} popupName   string
     * @param {} changeLable bool
     */
    setPopup:function(manageCode, pgTitle, changeLable)	{
    	var me = this;
    	var popupName = '';
    	var isDynamic = false;		//동적팝업(공통코드 팝업, 사용자정의 팝업) 일시 true
    	switch(manageCode){
    		case "A2" :
    			popupName = 'DEPT' 
			break;
			case "A3" :
    			popupName = 'BANK' 
			break;
			case "A4" :
    			popupName = 'CUST' 
			break;
			case "A6" :
    			popupName = 'Employee' 
			break;
			case "A7" :
    			popupName = '' 	//예산금액 팝업
			break;
			case "A9" :
    			popupName = 'COST_POOL' 
			break;
			case "B1" :
    			popupName = 'DIV_PUMOK' 
			break;
			case "C2" :
    			popupName = 'NOTE_NUM' 
			break;
			case "C7" :
    			popupName = 'CHECK_NUM' 
			break;
			case "D5" :
    			popupName = 'EX_LCNO' 
			break;
			case "D6" :
    			popupName = 'IN_LCNO' 
			break;
			case "D7" :
    			popupName = 'EX_BLNO' 
			break;
			case "D8" :
    			popupName = 'IN_BLNO' 
			break;
			case "E1" :
    			popupName = 'AC_PROJECT' 
			break;
			case "I2" :
    			popupName = '' 		//멀티 사업장 팝업
			break;
			case "O1" :
    			popupName = 'BANK_BOOK' 
			break;
			case "G5" :
    			popupName = 'CREDIT_NO' 
			break;
			case "M1" :
    			popupName = 'ASSET' 
			break;
			case "P2" :
    			popupName = 'DEBT_NO'
			break;
			
			
			default:
				var extParam = {};
				isDynamic = true;
				if(UniUtils.indexOf(manageCode, ["B5", "C0", "D2", "I4", "I5", "I7", "Q1", "A8"])){		//공통코드 팝업 생성
					popupName = 'COMMON';
					switch(manageCode){
						case "B5" :
							me.extParam.BSA_CODE = 'B013'							
						break;
						case "C0" :
							me.extParam.BSA_CODE = 'A058'
						break;
						case "D2" :
							me.extParam.BSA_CODE = 'B004'
						break;
						case "I4" :
							me.extParam.BSA_CODE = 'A003'
						break;
						case "I5" :
							me.extParam.BSA_CODE = 'A022'
						break;
						case "I7" :
							me.extParam.BSA_CODE = 'A149'
						break;
						case "Q1" :
							me.extParam.BSA_CODE = 'A171'
						break;
						case "A8" :
							me.extParam.BSA_CODE = 'A170'
						break;
					}
					
				}else if(UniUtils.indexOf(manageCode, ["R1", "Z0", "Z1", "Z2", "Z3", "Z4", "Z5", "Z6", "Z7", "Z8", "Z9",	//사용자 정의 팝업 생성
													   "Z10","Z11","Z12","Z13","Z14","Z15","Z16","Z17","Z18","Z19","Z20",
													   "Z21","Z22","Z23","Z24","Z25","Z26","Z27","Z28","Z29", "Z34", "Z35"])){
					popupName = 'USER_DEFINE';		
				}
			break;
    		
    	}
    	
    	if(isDynamic){	//동적팝업(공통코드 팝업, 사용자정의 팝업) 일시
    		var proxy = me.store.getProxy();
    		if(popupName == 'COMMON'){	//공통코드 팝업
    			
    			me.DBvalueFieldName 	= 'COMMON_CODE';
				me.DBtextFieldName 		= 'COMMON_NAME';
				me.api 					= 'popupService.commonPopup';
				me.app 					= 'Unilite.app.popup.CommonPopup';
				me.pageTitle			= pgTitle;
				me.popupWidth			= 579;
				me.popupHeight			= 407;
				me.extParam.PAGE_TITLE  = pgTitle;
//				me.useyn				= newConfig.useyn
				proxy.setConfig('api', {read: popupService.commonPopup });
    		}else if(popupName == 'USER_DEFINE'){	//사용자정의 팝업
    			
    			me.DBvalueFieldName 	= 'USER_DEFINE_CODE';
				me.DBtextFieldName 		= 'USER_DEFINE_NAME';
				me.api 					= 'popupService.userDefinePopup';
				me.app 					= 'Unilite.app.popup.UserDefinePopup';
				me.pageTitle			= pgTitle;
				me.popupWidth			= 725;
				me.popupHeight			= 455;
				me.extParam.AC_CD	 	= manageCode;
				me.extParam.PAGE_TITLE  = pgTitle;
//				me.useyn				= newConfig.useyn
				proxy.setConfig('api', {read: popupService.userDefinePopup });
    		}						
			if(changeLable) 	me.setFieldLabel(pgTitle);
    	}else{	//동적팝업이 아닐시...일반 팝업만 연동 시켜준다.
    		
    		var newConfig = Unilite.popup(popupName, changeLable);
	    	if(newConfig)	{
	    		me.DBvalueFieldName = newConfig.DBvalueFieldName;
				me.DBtextFieldName 	= newConfig.DBtextFieldName;
				me.api 				= newConfig.api;
				me.app 				= newConfig.app;
				me.useyn			= newConfig.useyn
				me.pageTitle		= newConfig.pageTitle;
				me.popupWidth		= newConfig.popupWidth;
			    me.popupHeight		= newConfig.popupHeight;
				var proxy = me.store.getProxy();
				proxy.setConfig('api', {read: newConfig.api });
				if(changeLable) 	me.setFieldLabel(newConfig.fieldLabel);
	    	} else {
	    		
	    		me.DBvalueFieldName = me.config.DBvalueFieldName;
				me.DBtextFieldName 	= me.config.DBtextFieldName;
				me.api 				= me.config.api;
				me.app 				= me.config.app;
				me.useyn			= me.config.useyn
				me.pageTitle		= me.config.pageTitle;
				me.popupWidth		= me.config.popupWidth;
			    me.popupHeight		= me.config.popupHeight;
				var proxy = me.store.getProxy();
				proxy.setConfig('api', {read: me.config.api });
				if(changeLable) 	me.setFieldLabel(me.config.fieldLabel);
	    	}
    	}
    	
    }
   
});