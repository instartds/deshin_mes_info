//@charset UTF-8
/**
 * 
 * Popup
 * 
 * ## Example usage:
 *  
 *    @example
 *    listeners: {
 *			'onSelected':  function(records  ){
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
Ext.define('Unilite.com.form.popup.UniTreePopupAbstract', {
	
    requires: [
        'Ext.form.field.Text',
        'Ext.form.Label'
    ],

    /**
     * 
     * @cfg {Boolean} 
     * 잘못된 값을 그냥 둘것인지?
     * 
     * boolean/string (true/false/'value'/'text')
     * true : 잘못된 값은 valuefield, textfield 모두 clear함 
     * false : 잘못된 값은 valuefield, textfield 모두 그대로 놓아 둠
     * 'value' : 잘못된 값은 valuefield 만 clear함 
     * 'text' : 잘못된 값은 textfield 만 clear함 
     */
    validateBlank : false,	
    autoPopup : false,
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
	popupPage : '/com/popup/DeptTree.do',
	popupWidth:400,
	popupHeight:400,
	valueFieldWidth:60,
	textFieldWidth:90,
	descriptionWidth:90,
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
     * 
     * @cfg {String}
     */
    valuesName: 'VALUES_FIELD',
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
    },  // constructor
   	_supendEvents : function(supend) {
   		var me = this;
   		if(supend) {
       		if(me.valueField) {
   				me.valueField.suspendEvents(false);
       		}
   			me.textField.suspendEvents(false);
   			
   		} else {
   			if(me.valueField) {
   				me.valueField.resumeEvents();
       		}
   			me.textField.resumeEvents();
   			
   		}
   	},
   	
    _onDataLoad : function( records) {
    	var me = this;
    	me.extParam.TXT_SEARCH = '';
    	if(records!=null && (records.length == 1 || ( me.allowMulti && records.length > 1))) {
    		var rec = records[0];
    		
    		
    		me._supendEvents(true);

   			if(me.valueField) {
   				//var v= rec.get(me.getDBvalueFieldName());
   				var v = rec.getData()[me.getDBvalueFieldName()];
				me.valueField.setRawValue(v);
				me.valueField.setValue(v);
				me.valueField.uniChanged = false;
    			me.valueField.clearInvalid();
   			}

   			var v = rec.getData()[me.getDBtextFieldName()];
			me.textField.setRawValue(v);
			me.textField.setValue(v);
			me.textField.uniChanged = false;
    		me.textField.clearInvalid();
    		
			
    		me.values.setStoreData(records);
			me.values.uniChanged = false;
    		me.values.clearInvalid();
    		
    		me.description.setText(records.length);
    		
    		me._supendEvents(false);
    		
    		// data에는 fields에 정의된 값만 있음 !!!
    		me.fireEvent('onSelected',  records);	
    		
    		if(me.textField)  me.fireEvent('onTextFieldChange',   me.textField, me.textField.getValue());	
    		if(me.valueField) me.fireEvent('onValueFieldChange',  me.valueField, me.valueField.getValue());	
    		if(me.values) me.fireEvent('onValuesChange',  me.values, me.values.getStore().data.items);	
    	
    	} else  {
    		if(!Ext.isEmpty(me.uniChanged) &&(me.allowBlank === false || me.autoPopup)) {
    			me.openPopup();
    		}
    		me._clearValue(me);
    	} 
    }
    
    ,_clearValue : function (me) {
		me.textField.setValue('');
		me.textField.validate();
		if(me.valueField) {
			me.valueField.setValue('');
			me.valueField.validate();
		}
		if(me.validateBlank === 'value')	{
    		if(me.valueField) {
				me.valueField.setValue('');
				me.valueField.validate();
				
   			}
   			me.values.setValue('');
    	}else if(me.validateBlank === 'text')	{
    		me.textField.setValue('');
			me.textField.validate();
    	}else if(me.validateBlank === true)	{
    		if(me.valueField) {
				me.valueField.setValue('');
				me.valueField.validate();
				
   			}
   			me.values.setValue('');
			me.textField.setValue('');
			me.textField.validate();
    	}
		me.description.update('<span>&nbsp;<span>');
    	me.fireEvent('onClear');	
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
    openPopup: function() {
        var me = this;
        if(!me.hasListeners.applyextparam || me.fireEvent('applyextparam', me) !== false) {
		                            		
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
		        param[me.valuesName] = me.values.getValue();
		        param['pageTitle'] = me.pageTitle;
		        
		        if(me.app) {
		            var fn = function() {
		                var oWin =  Ext.WindowMgr.get(me.app);
		                if(!oWin) {
		                    oWin = Ext.create( me.app, {
		                            //id: me.app, 
		                            callBackFn: me.processResult, 
		                            callBackScope: me, 
		                            width: me.popupWidth,
		                            height: me.popupHeight,
		                            title:me.pageTitle,
		                            param: param,
		                            listeners:{
		                            	'beforeshow':function()	{
		                            		me.setExtParam({'isFieldSearch':false});
		                            	},
		                            	'beforeclose':function()	{
		                            		me.extParam.TXT_SEARCH = '';
		                            		//me.setExtParam({'TXT_SEARCH':''});
		                            	},
		                            	'hide':function()	{
		                            		me.extParam.TXT_SEARCH = '';
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
		            me.openPopupModalDialog(param)
		        }
	        }
        }
    },
    processResult: function(result) {
        var me = this, rv;
        console.log("Result: ", result);
        if(Ext.isEmpty(result)) {
    		if( Ext.isDefined(me.valueField) ) {
    			me.valueField.focus();
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
		                me.valueField.setValue(rec[me.getDBvalueFieldName()]);
		                me.valueField.clearInvalid();
		            }
		            me.textField.setValue(rec[me.getDBtextFieldName()]);
		            me.textField.clearInvalid();	            
		            
		            /*var recValues = new Array();
					Ext.each(result.data, function(record, idx){
						recValues.push(record[me.getDBvalueFieldName()])
					})
					me.values.setRawValue(recValues);
					me.values.setValue(recValues);*/
		            me.values.setStoreData(result.data);
					
	            }
	            me.description.setText(result.data.length);
    				    		
	            me._supendEvents(false);
	            
	            me.fireEvent('onSelected',  result); 
	            if(me.textField) me.fireEvent('onTextFieldChange',   me.textField, me.textField.getValue());	
    			if(me.valueField)  me.fireEvent('onValueFieldChange',  me.valueField, me.valueField.getValue());
    			if(me.values) me.fireEvent('onValuesChange',  me.values, me.values.getStore().data.items);	
    			
	    		 //me.textField.focus();
	            me._focusNext(me.textField);	//2014.09.03 값 입력 후 다음 필드 포커스 이동 구현.	           
	            this._fireBlurEvent(null);
	        }
        }
    },
    
    openPopupModalDialog: function(param) {
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
	    me.processResult(rv);

	    
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
    lookup:function() {
    	var me = this;
    	
    	elm = me.valueField;

    	this._onFieldBlur(elm, true) ;
    },
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
                    	
                        	this._onFieldBlur(elm);
                        	this.fireEvent('onValueFieldChange', elm, elm.getValue());
                    	
                    },
                    scope: this
					,delay:1
                },
                'change': {
                    fn: function(elm, newValue, oldValue, eOpts){
                    	if(newValue == '')	{
                    		elm.popupField.textField.setValue('');
                    		elm.popupField.values.setStoreData([]);                    		
                    	}
                        this._onFieldChange(elm,  newValue, oldValue);
                        this.fireEvent('onValueFieldChange', elm, newValue, oldValue);
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
		    triggers: {				
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
                        this._onFieldBlur(elm);
                        this.fireEvent('onTextFieldChange', elm, elm.getValue());
                    }
                    ,scope: this
					,delay:1
                },
                'change': {
                    fn: function(elm, newValue, oldValue, eOpts){
                    	if(newValue == '')	{
                    		elm.popupField.valueField.setValue('');
                    		elm.popupField.values.setStoreData([]);                    		
                    	}
                        this._onFieldChange(elm,  newValue, oldValue);
                        this.fireEvent('onTextFieldChange', elm, newValue, oldValue);
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
     _getValuesConfig: function() {
    	var me = this;
    	var lAllowBlank = (typeof me.allowBlank === 'undefined') ? true : me.allowBlank;
    	return Ext.apply({
			hidden		:true,
    		xtype		: 'tagfield',
    		store		:Ext.create('Ext.data.Store',{fields: [this.getDBvalueFieldName(),this.getDBtextFieldName()]}),
            id			: this.id + '-valuesField',
            displayField: this.getDBtextFieldName(),
          	valueField	: this.getDBvalueFieldName(),
          	queryMode	: 'local',
          	multiSelect : true,
            labelWidth	: 0,
            padding		:0, 
            margin		:0,
            hideLabel	: true,
            name		:this.valuesName,
            allowBlank 	: lAllowBlank,
            width:100,//me.valuesWidth,            
		    uniOpt:this.uniOpt,
		    uniChanged : false,
		    uniPopupChanged : false,
		    readOnly:me.readOnly,
            isPopupField: true,
            popupField: me,
            listeners: {
                'change': {
                    fn: function(elm, newValue, oldValue, eOpts){
                        this._onFieldChange(elm, newValue, oldValue);
                        this.fireEvent('onValuesChange', elm, elm.getStore().data.items);
                    }
                    ,scope: this
					,delay:1
                }               
            },
            setStoreData:function(records)	{
            	var me = this;
            	var store = me.getStore();
            	me.getStore().loadData(records);
            	var recValues = new Array();
				me.select(store.getData().items)
				me.popupField.description.setText(records.length);
            }
    	}, me.valuesConfig);
    },
    _getDescriptionConfig: function() {
    	var me = this;
    	return Ext.apply({
    		xtype: 'component',
            id: this.id + '-descriptionField',
            padding:0, margin:0,
            html:"<span>&nbsp;</span>",
            setText:function(cnt)	{
            	if(cnt > 1)	{
            		this.update('<span>&nbsp;외'+(cnt-1)+'건<span>');
            	}else {
            		this.update('<span>&nbsp;<span>');
            	}
            }
    	}, me.valuesConfig);
    },
    _onFieldChange : function (elm, newValue, oldValue) {
    	this.setExtParam({'isFieldSearch':true})
    	elm.uniChanged = true;
    	elm.uniPopupChanged = true;
    },
    _onFieldBlur : function(elm,  force) {
	    var me = this;
	    if(!me.hasListeners.applyextparam || me.fireEvent('applyextparam', me) !== false) {
	 			
			if( Ext.isEmpty(elm.getValue() ) && me.validateBlank === false ) {
	    			if(me.textField){
	    				me.textField.setValue();
	    			}
	    			if(me.valueField) {
	    				me.valueField.setValue();
	    			}	    		
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
		    		elm.setValue(elm.value);
		    		
		    		var  param = me.extParam;
		    		if(!Ext.isDefined(param['USE_YN']))	{
				        if(Ext.isDefined(me.useyn) && me.useyn != '' )	{
				        	param['USE_YN'] = me.useyn;
				        }
			        }

		    		param[me.getDBvalueFieldName()] = me.valueField.getValue().trim();
		    		param[me.getDBtextFieldName()] = '';
		       
	    			if(me.textField instanceof Ext.form.field.Date) {
		       			param[me.getDBtextFieldName()]  = me.textField.getSubmitValue().trim();
		       		}else{
	    				param[me.getDBtextFieldName()]  = me.textField.getValue().trim();
		       		}
	    			if(me.valueField) {
	    				//param[me.getDBvalueFieldName()] = '';
	    				param[me.getDBvalueFieldName()] = me.valueField.getValue().trim();
	    			}
			       	
		    		
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
										me._onDataLoad(records);
									}
								}
							}); 
		    			} else {
		    				me.openPopup();
		    			}
		    		}else {
		    			setTimeout(function(){
		    				me._onDataLoad(null);
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