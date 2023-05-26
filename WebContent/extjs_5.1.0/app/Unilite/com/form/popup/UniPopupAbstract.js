//@charset UTF-8
/**
 * 
 * Popup
 * 
 * ## Example usage:
 *  
 *    @example
 *    listeners: {
 *			'onSelected':  function(records, type  ){
 *				//var grdRecord = masterGrid.getSelectedRecord();
 *				var grdRecord = masterGrid.uniOpt.currentRecord;
 *				grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
 *			},
 *			'onClear':  function( type  ){
 *				// onClear는 커서가 떠난후 발생하므로 getSlected 사용 안함.
 *				//var grdRecord = masterGrid.getSelectedRecord(); 
 *				var grdRecord = masterGrid.uniOpt.currentRecord;
 *				grdRecord.set('MCUSTOM_NAME','');
 *				grdRecord.set('MANAGE_CUSTOM','');
 *			}
 *		}         
 */
Ext.define('Unilite.com.form.popup.UniPopupAbstract', {
	
    requires: [
        'Ext.form.field.Text',
        'Ext.form.Label'
    ],

    /**
     * 
     * @cfg {Boolean} 
     * 잘못된 값을 그냥 둘것인지?
     * 
     * true : 잘못된 값은 clear함 
     * 
     */
    validateBlank : true,	
        /**
     * 
     * @cfg {Boolean} 
     * 
     * default value is false
     * true : 팝업띄우지 않고 검색란에서 검색시 조회 결과가 2건 이상 조회시 onClear를 실행하지 않음 
     */
    allowMulti : false,
    store:'',
    api : '',
    pageTitle:'',
    readOnly: false,
	popupPage : '/com/popup/CustPopup.do',
	popupWidth:700,
	popupHeight:550,
	valueFieldWidth:60,
	textFieldWidth:90,
	extraFieldWidth:90,
	defaults: {
         hideLabel: true
    },
	
	//layout: 'uniPopupFieldLayout',
    /**
     * 
     * @cfg {String}
     */
    valueFieldName: 'VALUE_FIELD',
    /**
     * 
     * @cfg {String}
     */
    textFieldName: 'TEXT_FIELD',
    /**
     * DB의 Value field name 
     * @cfg {String}
     */
    DBvalueFieldName : undefined,
    /**
     * DB의 Text field name 
     * @cfg {String}
     */
    DBtextFieldName : undefined,
    
    textFieldConfig: {},
    
    /**
     * DB검색시 Like를 사용 할것인지?
     * @cfg {String} useLike
     */
    useLike : false,
    
    //width:320,typeof value !== 'undefined'
    /**
     * api 호출시 추가되는 parameters
     * @type  {Object}
     */
	extParam: {},
    
	//valueField, textField 외 부가필드
	extraFields: [],
	extraFieldsConfig: [],
	
	useBarcodeScanner:false,
	
	getDBvalueFieldName:function() {
		return (typeof this.DBvalueFieldName === 'undefined') ? this.valueFieldName : this.DBvalueFieldName;
	},
    getDBtextFieldName:function() {
		return (typeof this.DBtextFieldName === 'undefined') ? this.textFieldName : this.DBtextFieldName;
    	
    },
    /**
     * uniPopup 생성
     * 
     * @param {} config
     */
    constructor : function(config){    
        var me = this;
        config.trackResetOnLoad = true;
        if (config) {
            Ext.apply(me, config);
        }
        
        //addEvents 제거 - 5.0.1 deprecated
//        me.addEvents(
//        	/**
//             * @event onSelected
//             * 하나의 record가 선택되었을때 발생
//             * @param {Array} records
//             * @param {String} type
//             * [ TEXT | VALUE ] 
//             */
//        	'onSelected',
//        	
//        	/**
//             * @event onClear
//             * 데이타가 지워졌을때 발생 
//             * 주의! grid에서 onClear사용시 현재 record 가져올때는 아래 방법 사용 
//             *        
//			 * @param {String} type
//             * [ TEXT | VALUE ]
//             */
//        	'onClear',
//        	'applyextparam'
//        );        
        
    },  // constructor
   	_supendEvents : function(supend) {
   		var me = this;
   		if(supend) {
       		if(me.valueField) {
   				me.valueField.suspendEvents(false);
       		}
   			me.textField.suspendEvents(false);
   			Ext.each(me.extraFields, function(field){
	        	field.suspendEvents(false);
	        });
   		} else {
   			if(me.valueField) {
   				me.valueField.resumeEvents();
       		}
   			me.textField.resumeEvents();
   			Ext.each(me.extraFields, function(field){
	        	field.resumeEvents();
	        });
   		}
   	},
   	
    _onDataLoad : function( records,   type) {
    	var me = this;
    	me.extParam.TXT_SEARCH = '';
    	if(records!=null && (records.length == 1 || ( me.allowMulti && records.length > 1))) {
    		var rec = records[0];
    		console.log('popup(select) ' + type + ' : select 1 : ' + rec.get(me.getDBtextFieldName()));
    		me._supendEvents(true);
    		if(type == 'TEXT') {
       			if(me.valueField) {
       				//var v= rec.get(me.getDBvalueFieldName());
       				var v = rec.raw[me.getDBvalueFieldName()];
    				me.valueField.setRawValue(v);
       			}
       			//var v= rec.get(me.getDBtextFieldName());
       			var v = rec.raw[me.getDBtextFieldName()];
    			me.textField.setRawValue(v);
    			
    			Ext.each(me.extraFields, function(field){
		        	field.setRawValue(rec.raw[field.name]);
		        	field.uniChanged = false;
		        	field.clearInvalid();
		        });
    		} else {
       			if(me.valueField) {
       				//var v= rec.get(me.getDBvalueFieldName());
       				var v = rec.raw[me.getDBvalueFieldName()];
    				me.valueField.setRawValue(v);
       			}
       			//var v= rec.get(me.getDBtextFieldName());
       			var v = rec.raw[me.getDBtextFieldName()];
    			me.textField.setRawValue(v);
    			
    			Ext.each(me.extraFields, function(field){
		        	field.setRawValue(rec.raw[field.name]);
		        	field.uniChanged = false;
		        	field.clearInvalid();
		        });
    		}
    		me.textField.uniChanged = false;
    		me.textField.clearInvalid();
    		if(me.valueField) {
    			me.valueField.uniChanged = false;
    			me.valueField.clearInvalid();
    		}
    		me._supendEvents(false);
    		
    		// data에는 fields에 정의된 값만 있음 !!!
    		me.fireEvent('onSelected',  [rec.raw], type);	
    		//this._fireBlurEvent(null);
    	} else if (records!=null && records.length > 1) {
    		console.log('DATA Loaded:', type, records.length);
    		if(me.validateBlank ) {
    			console.log('onClear on records:' + records.length);
    			me._clearValue(me,type);
    		}else{
    			me.openPopup(type);
    		}
    	} else {
    		if(me.validateBlank) {
    			
    			me._clearValue(me,type);
    		}else{
    			me.openPopup(type);
    		}
    	}
    }
    ,_clearValue : function (me, type) {
    	if(type == 'TEXT') {
   			if(me.valueField) {
				me.valueField.setValue('');
				me.valueField.validate();
   			}
			me.textField.setValue('');
			me.textField.validate();
		} else {
   			if(me.valueField) {
				me.valueField.setValue('');
				me.valueField.validate();
   			}
			me.textField.setValue('');
			me.textField.validate();
		}
		Ext.each(me.extraFields, function(field){
	    	field.setValue('');
			field.validate();
	    });
    	me.fireEvent('onClear',  type);	
    },
    _checkReadOnly: function() {
    	var rv = false;
    	var me = this;
    	if(me.valueField ) {
    		if(me.valueField.readOnly) return true;
    	}
    	if(me.textField.readOnly) {
    		return true;
    	} else {
    		return false;
    	}
    	
    },
    openPopup: function(type) {
        var me = this;
        if(!me.hasListeners.applyextparam || me.fireEvent('applyextparam', me) !== false) {
        	
        	if(Ext.isFunction(me._setRecordExtParam))	{
    			me._setRecordExtParam();
    		}
		                            		
	        var param = me.extParam;
	        //param['page'] = 'CustPopup';
	        console.log("me.useyn :",me.useyn);
	        if(!Ext.isDefined(param['USE_YN']))	{
		        if(Ext.isDefined(me.useyn) && me.useyn != '' )	{
		        	param['USE_YN'] = me.useyn;
		        }
	        }
	        if(!me.textField.readOnly)	{
		        if(me.valueField ) {
		            param[me.getDBvalueFieldName()] = me.valueField.getValue().trim()   ;
		        }
		        //param[me.getDBtextFieldName()] = me.textField.getValue();   
		        
		        if(me.textField instanceof Ext.form.field.Date) {
	       			param[me.getDBtextFieldName()]  = me.textField.getSubmitValue();
	       		}else{
					param[me.getDBtextFieldName()]  = me.textField.getValue();
	       		}
		        param['TYPE'] = type;   
		        param['pageTitle'] = me.pageTitle;
		        
		        if(me.app) {
		            var fn = function() {
		                var oWin =  Ext.WindowMgr.get(me.app);
		                if(!oWin) {
		                    oWin = Ext.create( me.app, {
		                            //id: me.app, 
		                            callBackFn: me.processResult, 
		                            callBackScope: me, 
		                            popupType: type,
		                            width: me.popupWidth,
		                            height: me.popupHeight,
		                            title:me.pageTitle,
		                            param: param,
		                            listeners:{
		                            	'beforeshow':function()	{
		                            		if(Ext.isFunction(me._setRecordExtParam))	{
		                            			me._setRecordExtParam();
		                            			me.setExtParam({'isFieldSearch':false})
		                            		}
		                            	},
		                            	'beforeclose':function()	{
		                            		me.extParam.TXT_SEARCH = '';
		                            		me.extParam = {}
		                            	},
		                            	'hide':function()	{
		                            		me.extParam.TXT_SEARCH = '';
		                            		me.extParam = {}
		                            		//me.setExtParam({'TXT_SEARCH':''});
		                            	}
		                            }
		                     });
		                }
		                oWin.fnInitBinding(param);
		                oWin.center();
		                // animation을 원할경우 oWin.show(me) 하면 되나 느림 ㅠㅠ
		                oWin.show();
		            };
		            Unilite.require(me.app, fn, this, true);
		//            Ext.require(me.app, fn);            
		        } else {
		            me.openPopupModalDialog(param,type)
		        }
	        }
        }
    },
    processResult: function(result, type) {
        var me = this, rv;
        console.log("Result: ", result);
        if(Ext.isEmpty(result)) {
        	if(type == 'VALUE') {
        		if( Ext.isDefined(me.valueField) ) {
        			me.valueField.focus();
        		}
        	}else{
        		me.textField.focus();
        	}
        }else{
	        if(Ext.isDefined(result) && result.status == 'OK') {
//	            if( Ext.isDefined(me.valueField) ) {
//	                me.valueField.suspendEvents(false);
//	            }
//	            me.textField.suspendEvents(false);
	        	me._supendEvents(true);
	            
	            var rec = result.data[0];
	            //console.log("RV:", me.DBtextFieldName, rec[me.DBtextFieldName], rec);
	            if(rec)	{
		            if( Ext.isDefined(me.valueField) ) {
		                me.valueField.setValue(rec[me.DBvalueFieldName]);
		                me.valueField.clearInvalid();
		            }
		            me.textField.setValue(rec[me.getDBtextFieldName()]);
		            me.textField.clearInvalid();	            
		            //console.log("value : ", me.DBvalueFieldName," text : ",me.getDBtextFieldName())
		            Ext.each(me.extraFields, function(field){
			        	field.setValue(rec[field.name]);
			        	field.clearInvalid();
			        });
	            }
	            //me.textField.focus();
	            me._focusNext(me.textField);	//2014.09.03 값 입력 후 다음 필드 포커스 이동 구현.
	            
//	            if( Ext.isDefined(me.valueField) ) {
//	                me.valueField.resumeEvents();
//	            }
//	            me.textField.resumeEvents();
	            me._supendEvents(false);
	            
	            me.fireEvent('onSelected',  result.data, type); 
	            this._fireBlurEvent(null);
	        }
        }
    },
    
    openPopupModalDialog: function(param, type) {
    	var me = this;
    	var width = me.popupWidth, height = me.popupHeight;
    	var xPos = (screen.availWidth - width) / 2;
	    var yPos = (screen.availHeight - height ) / 2 ;
	
		
	
		// readonly면 popup 불가.
		if(me._checkReadOnly()) return false;
		
	    var sParam = UniUtils.param(param);
	    console.log("Parameters : ", param, sParam);
	    var features = "help:0;scroll:0;status:0;center:yes;" +
	           // "dialogTop="+yPos + "px;dialogLeft="+xPos +"px;" +
	            ";dialogWidth="+width +"px;dialogHeight="+height+"px" ;
	
	    var rv = window.showModalDialog(CPATH+me.popupPage+'?'+sParam, param, features);
	    me.processResult(rv, type);

	    
    },
   
   
    // private
    getLayoutItems: function() {
    	var me = this;
        return  me.items.items;
    }
    /**
     * 
     * @param {} v
     */
    ,setValue:function(v) {
    	this.textField.setValue(v);
    }
    /**
     * 
     */
    ,getValue: function() {
    	this.textField.getValue();
    }
    /**
     * 
     */
    ,reset:function() {
    	this.textField.reset();
    	
       	if(this.valueField) {
    		this.valueField.reset();
       	}
       	Ext.each(this.extraFields, function(field){
        	field.reset();
        });
    },
    isValid: function() { return true; },
    
    /**
     * 강제로 값을 조회하게 함.
     * @param {} type
     */
    lookup:function(type) {
    	var me = this;
    	var elm = "";
    	if( type == 'TEXT') {
    		elm = me.textField;
    	} else {
    		elm = me.valueField;
    	}
    	console.log("lookup",elm, type) ;
    	this._onFieldBlur(elm, type, true) ;
    },
    /*
    onFieldBlur: function( field, e ){ 
    	var items = this.field.items.items;
            
        for( var index = 0; index < items.length; index++ )
        {
            if (items[ index ].hasFocus) {
                return;
            }
        }
        
        this.onFieldBlur( field, e );
    },
    */
    defaultRenderer: function(value){
    	
    	return this.textField.getValue();
    },
    // value : {key: value, key2: value2}
    setExtParam : function(param)	{
    	var me = this;
    	Ext.Object.merge(me.extParam, param);
    	//me.extParam = param; 
    },
    // private  valuefield ( Code 값 저장 )
    _getValueFieldConfig:function(isHidden) {
    	var me = this, lHidden = isHidden || false;;
    	var lAllowBlank = (typeof me.allowBlank === 'undefined') ? true : me.allowBlank;
    	 return {
            xtype: 'textfield',
            id: this.id + '-valueField',
            //triggerCls :'x-form-search-trigger',
            labelWidth: 0,
            padding:0, margin:0,
            hideLabel: true,
            width: me.valueFieldWidth,
            label:'Code',
            name: this.valueFieldName,
            allowBlank : lAllowBlank,
            enableKeyEvents: true,
		    uniChanged : false,
		    uniPopupChanged : false,
		    uniOpt:this.uniOpt,
		    hidden: lHidden,
		    readOnly:me.readOnly,
            isPopupField: true,
            popupField: me,
		    
            /*
            onTriggerClick: function() {
		        me.openPopup( 'VALUE');
		    },
		    */
            listeners: {
            	'render' : function(c) {
            		 c.getEl().on('dblclick', function(){
					    	me.openPopup( 'VALUE');
					  });
            	},
                'blur': {
                    fn: function(elm){
                        this._onFieldBlur(elm, 'VALUE');
                    },
                    scope: this
					,delay:1
                },
                'change': {
                    fn: function(elm, newValue, oldValue, eOpts){
                        this._onFieldChange(elm, 'VALUE', newValue, oldValue);
                    }
                    ,scope: this
					,delay:1
                },
                'keydown': {
                  	fn: function(elm, e){
                  		switch( e.getKey() ) {
                  			case Ext.EventObjectImpl.F8:
                  				if(!(e.shiftKey || e.ctrlKey || e.altKey )) {
                  					me.openPopup( 'TEXT');
                  					e.stopEvent();
                  				}
                    			break;
                  		}
                  	} // fn
                    ,scope: this
                }  
            }
        };
    },
    // private
    _getTextFieldConfig: function() {
    	var me = this;
    	var lAllowBlank = (typeof me.allowBlank === 'undefined') ? true : me.allowBlank;
    	return Ext.apply({
            //xtype: 'triggerfield',
    		xtype: 'textfield',
            id: this.id + '-textField',
            //triggerCls :'x-form-search-trigger',
            labelWidth: 0,
            padding:0, margin:0,
            hideLabel: true,
            name:this.textFieldName,
            enableKeyEvents: true,
            allowBlank : lAllowBlank,
            fieldStyle: me.textFieldStyle,
            width:me.textFieldWidth,            
//            onTriggerClick: function() {
//		        me.openPopup( 'TEXT');
//		    },
		    triggers: {				//5.0 clear trigger
				popup: {
					cls: 'x-form-search-trigger',
					handler: function() {
						me.openPopup( 'TEXT');
					}
				}
			}, 
		    uniOpt:this.uniOpt,
		    uniChanged : false,
		    uniPopupChanged : false,
		    readOnly:me.readOnly,
            isPopupField: true,
            popupField: me,
            listeners: {
            	'render' : function(c) {
            		 c.getEl().on('dblclick', function(){
					    	me.openPopup( 'TEXT');
					  });
            	},
                'blur': {
                    fn: function(elm){
                        this._onFieldBlur(elm, 'TEXT');
                    }
                    ,scope: this
					,delay:1
                },
                'change': {
                    fn: function(elm, newValue, oldValue, eOpts){
                        this._onFieldChange(elm, 'TEXT', newValue, oldValue);
                    }
                    ,scope: this
					,delay:1
                },
                'keydown': {
                  	fn: function(elm, e){
                  		switch( e.getKey() ) {
                  			case Ext.EventObjectImpl.F8:
                  				if(!(e.shiftKey || e.ctrlKey || e.altKey )) {
                  					me.openPopup( 'TEXT');
                  					e.stopEvent();
                  				}
                    			break;
                  		}
                  	} // fn
                  	,scope: this
                }                  
            }
    	}, me.textFieldConfig);
    },
    
    _getExtraFieldsConfig: function() {
    	var me = this;
    	var fields = [];
    	var lAllowBlank = (typeof me.allowBlank === 'undefined') ? true : me.allowBlank;
    	
    	if(!Ext.isEmpty(me.extraFieldsConfig)) {
    		Ext.each(me.extraFieldsConfig, function(config){
    			fields.push(
    				{
			            xtype: 'textfield',
			            id: me.id + '-extraField'+ '-' + config.extraFieldName,
			            labelWidth: 0,
			            padding:0, margin:0,
			            hideLabel: true,
			            width: Ext.isDefined(config.extraFieldWidth) ? config.extraFieldWidth: me.extraFieldWidth,
			            name: config.extraFieldName,
			            allowBlank : lAllowBlank,
			            enableKeyEvents: true,
					    uniChanged : false,
					    uniPopupChanged : false,
					    uniOpt:me.uniOpt,
					    readOnly: Ext.isDefined(config.readOnly) ? config.readOnly: true,
			            isPopupField: true,
			            popupField: me,
			            listeners: {
			            	'blur': {
			                    fn: function(elm){
			                        me._onFieldBlur(elm, 'TEXT');
			                    }
			                    ,scope: me
								,delay:1
			                },
			                'change': {
			                    fn: function(elm, newValue, oldValue, eOpts){
			                        me._onFieldChange(elm, 'EXTRA', newValue, oldValue);
			                    }
			                    ,scope: me
								,delay:1
			                }	                
			            }
			    	}
    			)    			
    		});
    	}
    	
    	return fields;
    },
    _onFieldChange : function (elm, type, newValue, oldValue) {
    	this.setExtParam({'isFieldSearch':true})
    	elm.uniChanged = true;
    	elm.uniPopupChanged = true;
    },
    _onFieldBlur : function(elm, type, force) {
	    var me = this;
	    if(!me.hasListeners.applyextparam || me.fireEvent('applyextparam', me) !== false) {
	    //console.log('_onFieldBlur : elm.uniPopupChanged='+ elm.uniPopupChanged + ', type=' + type + ' , force : ' + force, elm);
//	    if(elm.uniPopupChanged || force) {
//	    	if(type == 'VALUE') {
//	    		console.log('_onFieldBlur : elm.uniChanged='+ elm.uniChanged + ', type=' + type + ' , force : ' + force);
//	    	}

//	    	if( Ext.isEmpty(elm.getValue() ) && elm.uniChanged =='false' ) {
			
			if( Ext.isEmpty(elm.getValue() ) && !me.validateBlank ) {
	    		if(type == 'VALUE') {
	    			if(me.textField){
	    				me.textField.setValue();
	    			}
	    		} else if(type == 'TEXT'){
	    			if(me.valueField) {
	    				me.valueField.setValue();
	    			}
	    		}
	    		Ext.each(me.extraFields, function(field){
		        	field.setValue();
		        });
	    		
	    	} else {
	    		
	    		// isDirty() ? uniChanged (onChange 기반이라 DEL이나 일부 이벤트 처리 안됨)
		    	if(( elm.uniPopupChanged  ) || force) {
		    	//if((elm.isDirty() ) || force) {
		    		elm.resetOriginalValue();
		    		elm.uniChanged = false;
		    		//elm.uniOpt.oldValue=elm.uniOpt.lastValidValue;	//2014.09.02 영업기회진행종합->영업기회세부정보에서 null 참조 오류
		    		if(!Ext.isEmpty(elm.uniOpt) && !Ext.isEmpty(elm.uniOpt.lastValidValue)){
		    			elm.uniOpt.oldValue=elm.uniOpt.lastValidValue;
		    		}
		    		console.log(type + "_onValueFieldChange:",elm.getValue(), elm);
		    		elm.setValue(elm.value);
		    		
		    		var  param = me.extParam;
		    		if(!Ext.isDefined(param['USE_YN']))	{
				        if(Ext.isDefined(me.useyn) && me.useyn != '' )	{
				        	param['USE_YN'] = me.useyn;
				        }
			        }
			       	if(me.valueField && type == 'VALUE') {
			    		param[me.getDBvalueFieldName()] = me.valueField.getValue().trim();
			    		param[me.getDBtextFieldName()] = '';
			       	}
			       	if( type == 'TEXT') {
		    			if(me.textField instanceof Ext.form.field.Date) {
			       			param[me.getDBtextFieldName()]  = me.textField.getSubmitValue().trim();
			       		}else{
		    				param[me.getDBtextFieldName()]  = me.textField.getValue().trim();
			       		}
		    			if(me.valueField) {
		    				//param[me.getDBvalueFieldName()] = '';
		    				param[me.getDBvalueFieldName()] = me.valueField.getValue().trim();
		    			}
			       	}
		    		param['TYPE'] = type;
		    		param['USELIKE'] = me.useLike;
		    		
		    		if(!(Ext.isEmpty(param[me.getDBtextFieldName()]) && Ext.isEmpty(param[me.getDBvalueFieldName()])) )	{
		    			if(!Ext.isEmpty(me.api))	{
		                    Ext.getBody().mask();
		                    //console.log('mask');
				    		me.store.load({
								params: param,
								limit: 2,
								scope: this,
								callback: function(records, operation, success) {
		                            console.log('unmask');
		                            Ext.getBody().unmask(); 
									if(success) {
										me._onDataLoad(records,  type);
									}
								}
							}); 
		    			} else {
		    				me.openPopup(type);
		    			}
		    		}else {
		    			setTimeout(function(){
		    				me._onDataLoad(null,  type);
		    				console.log("finish");
		    			}, 1000);
		    			//me._onDataLoad(null,  type);
		    			
		    		}
		    	}
		    	
		    	
	    	}
//	    }
    		elm.uniPopupChanged = false;
    	}
    },
    _fireBlurEvent:function(obj) {
    	var me = this;
    	//	this.textField.fireEvent('blur', this.textField);
    	
    	if( Ext.isDefined(me.valueField) ) {
			me.valueField.uniPopupChanged = false;
    	}
		me.textField.uniPopupChanged = false;
		Ext.each(me.extraFields, function(field){
        	field.uniPopupChanged = false;
        });
    },
    
    //값 입력 후 form 상에서 다음 form field에 포커스 이동
    _focusNext: function(field) {
    	
    	var me = this;
    	if(Ext.isEmpty(me.el)) return;
    	
    	var nextEl = null;
    	var fieldCell = me.el.up('.x-table-layout-cell');
    	
    	if(fieldCell && fieldCell.parent()) {
    		//nextEl = fieldCell.parent().next().down('.x-form-field');
    		var obj = fieldCell.parent().next();
    		if(obj) {
    			//nextEl = obj.query(':focusable')[0];
    			nextEl = obj.query('input:first-child')[0];
    		}
    	}
    	if(nextEl) {
    		nextEl.focus();
    		nextEl.select();
    	}else{
    		field.focus();
    	}
    	
    }
   
});