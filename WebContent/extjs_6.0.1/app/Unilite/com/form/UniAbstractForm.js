//@charset UTF-8
/**
 * Unilite용 Abstract Form
 */
 Ext.define('Unilite.com.form.UniAbstractForm', {
	extend : 'Ext.form.Panel',
	requires: [
		'Ext.ux.DataTip'
	],
	deferredRender : true,
	border : false,
	padding : '5 5 0 5',
	width : '100%',
	defaultType : 'uniTextfield',
	autoScroll:true,
	paramsAsHash: true, //
	activeRecord: null,
	fieldDefaults : {
		msgTarget : 'qtip',
		labelAlign : 'right',
		blankText : '값을 입력해 주세요!',
		labelWidth : 90,
		//width:250,
		labelSeparator : "",
	    validateOnChange: false,
        autoFitErrors: true   //false  //화면 깨짐 
	},
	uniOpt: {
		inLoading : false
	},
	plugins: {
        ptype: 'datatip'
    },
	initComponent: function(){
		
		//addEvents 제거 - 5.0.1 deprecated
//		this.addEvents('uniOnChange');
        this.callParent();
	},
	/**
	 * 폼의 모든 항목을 
	 * readOnly 
	 *   : true -> 읽기 전용으로
	 *   : false ->  원상복원
	 * @param {} readOnly
	 */
	setReadOnly: function(readOnly) {
		var me = this;
		var frm = me.getForm();
		var fields = frm.getFields( );
		for(var i = 0, len = fields.length; i < len; i ++) {
			var field = fields.getAt(i);
			if(readOnly) {
				field.rawReadOnly2 = field.readOnly;
				field.setReadOnly(readOnly);
			} else {
				if(Ext.isDefined(field.rawReadOnly2)) {
					field.setReadOnly(field.rawReadOnly2);
				} else {
					field.setReadOnly(readOnly);
				}
			}
		}
	},
	/**
	 * 폼값 reset
	 */
	reset: function() {
		this.uniOpt.inLoading = true;
		var frm = this.getForm().reset();
		this.uniOpt.inLoading = false;
	},
 	/**
 	 * 편집 record를 지정 
 	 * 내부적으로 loadrecord를 호출 함.
 	 * @param {} record
 	 */
	setActiveRecord: function(record) {
		var me = this;
		me.uniOpt.inLoading = true;
		//Ext.suspendLayouts();
		//console.log("setActiveRecord0 : " , record);
		me.activeRecord = record;
		if (record) {
		 	var frm = me.getForm();
		 	frm.clearInvalid( );
			var fields = frm.getFields( );
			for(var i = 0, len = fields.length; i < len; i ++) {
				var field = fields.getAt(i);
				field.uniChanged = false;
			}
			for(var i = 0, len = record.fields.length; i < len; i ++) {
				//var column = record.fields.getAt(i);
				var column = record.getFields()[i];
				var field = me.getField(column.name);
				if(field) {
					if(column.isPk ) {
						if(!Ext.isDefined(field.rawReadOnly)) {
							field.rawReadOnly = field.readOnly;
						}
						var lReadonly = true;
						// 신규 건이고 kgen 
						if( record.phantom && column.pkGen && column.pkGen == 'user' ) {
							lReadonly = false;
						}
						field.setReadOnly(lReadonly);
					}
					//console.log(column.name + '  readonly= ' + field.readOnly + ', rawReadOnly= ' + field.rawReadOnly, record.get(column.name) );
					//me.setValue(column.name, record.get(column.name), true)
				}
			}
			//console.log(me.id+">setActiveRecord: is dirty =",frm.isDirty( ) , record.getData());
		 	
            frm.loadRecord(record);
			frm._record = record;
            

			
		 	me.setDisabled( false );
         } else {
         	me.setDisabled( true );
         }
         
		 //Ext.resumeLayouts(true);
		me.uniOpt.inLoading = false;
  		
	},
	/**
	 * values{object} 는 JSON object이며
	 * onChange 이벤트 발생 시킴
	 */
	setValues:function(values) {
		return this.getForm().setValues(values);
	},
	// onChange 발생 안시킴.
	setValue:function(name, value, silent) {
		var field = this.getField(name);
		var defaultSilent = true;
		
		// 계층 분류코드 change event default 설정
		if(field && field.xtype == 'uniCombobox') 	defaultSilent = false;
		
		var mSilent = Ext.isDefined(silent) ? silent : defaultSilent;
		var valueObj = {};
		valueObj[name] = value;
		var rv = null;
		
		if(!field) {
			var fields = this.getForm().getFields();
			
			console.log("Field [" + name + "] not found!", fields);
			return null;
		}
		
		if( this.getValue(name) == value) return;
		
		if(mSilent ) {
			field.suspendEvents(false);
		}
		if(field.xtype == 'uniRadiogroup') {
			console.log('xtype:', field.xtype,'>', valueObj);
			rv= field.setValue(valueObj);
			//rv= field.setRawValue(valueObj);// date타입으로 값이 저장 되어 화면에 포맷을 따르지 않게됨 2013/12/11
		} else if(field.xtype == 'uniCombobox') {
			console.log('xtype:', field.xtype,'>', valueObj);
			rv= field.setValue(value);
			//rv= field.select(value);
			//rv= field.setRawValue(valueObj);
		} else if(field.xtype == 'uniDatefield') {
			var v = Ext.isDate(value) ? UniDate.getDateStr(value):value;
			rv= field.setValue(v);
		}else if(field.xtype == 'uniDatefieldForRange')	{
			var v = Ext.isDate(value) ? UniDate.getDateStr(value):value;
			rv= field.setValue(v);
			field.up('fieldcontainer')._updateMinMax();
		}else if(field.xtype == 'uniMonthfieldForRange')	{
			var v = Ext.isDate(value) ? UniDate.getDateStr(value):value;
			rv= field.setValue(v);
			field.up('fieldcontainer')._updateMinMax();
		} else if(field.xtype == 'uniTimefield') {
			console.log('xtype:', field.xtype,'>', valueObj);
			rv= field.setValue(UniDate.extSafeParse(field.initDate + ' ' + value,field.initDateFormat + ' Hi'));
			//rv= field.setRawValue(valueObj);	 
		} else if(field.xtype == 'uniCheckboxgroup') {
			console.log('xtype:', field.xtype,'>', valueObj);
			var valueObjA = {};
			if(Ext.isArray(value)) {
				
				valueObjA[name+'[]'] = value;
			} else {
				var t= new Array();
				t.push(value);
				valueObjA[name+'[]'] = t;
			}
			
			console.log("uniCheckboxgroup:", valueObjA)
			rv= field.setValue(valueObjA);
			//rv= field.setRawValue(valueObjA);
		} else {
			//console.log('xtype:', field.xtype,'>', valueObj);
			// rv= this.getForm().setValues(valueObj);
			//rv= field.setRawValue(value);
			rv= field.setValue(value);
			if(field.fieldContainer)  field.fieldContainer._updateMinMax();
		}
		if (this.trackResetOnLoad) {
			//2014.11.11 modified
			//setValue 에서는 orignalValue 를 reset 안함. (isDirty() 체크 클 위해)
			//loadRecord, setValues 에서는 extjs가 trackResetOnLoad 가 true 인 경우 각 필드의 resetOriginalValue()를 수행함.
            
			//field.resetOriginalValue();
         }
         if(! this.uniOpt.inLoading) {
			var rec = this.activeRecord; //this.getRecord();
			var form = this.getForm();
			
			if(rec) {
				console.log ( "update record.field value change detected on ", field.name);
				//form.updateRecord(rec);	//form의 내용을 rec에 write 함.
				this._updateRecord(rec);
			}
			
			//setValue 시 change event 2016.06.14
			var oldValue = field.uniOpt ? field.uniOpt.oldValue : null;
			this._onFieldChangedFunction(field, value, oldValue);
			field.fireEvent('uniOnChange', field, value, oldValue);
			if(this.uniOpt && !this.uniOpt.inLoading) this.fireEvent( 'uniOnChange',  this, field, value, oldValue  ) ;
			//setValue 시 change event end
         }
		if(mSilent ) {
			field.resumeEvents();
		}
		
		return rv;
	},
	getValue: function(name) {
		var field = this.getField(name);
		
		if(field) {
			return field.getValue();
		} else {
			return null;
		}
	},
	// id나 name으로 조회 
	getField: function(name) {
		/*
		var fields = this.getForm().getFields();
		fields.each(function(f) {
			if(field instanceof Ext.form.field.Field ) {
					console.log(f);
			}
		})
		*/
		return this.getForm().findField(name);//
	},
	/**
	 * 값이 변경 되었는지 확인
	 * 
	 * @return {boolean}
	 * true : load후 변경됨
	 * false : load후 변경된 내용 없음.
	 */
	isDirty: function() {
		return this.getForm().isDirty();
	},
	/**
	 * 주어진 필드값들 중 빈 값이 있는지 확인
	 * fieldNames = array()
	 * @param {} fieldNames
	 * 
	 * @return {boolean}
	 */
	checkManadatory: function(fieldNames) {
		var rv = true,   frm = this.getForm();
		
		for(var i = 0, len=fieldNames.length; i < len; i ++) {
			var field = frm.findField(fieldNames[i]); 
			var value = field.getSubmitValue()
			if(Ext.isEmpty(value)) {
				return field;
			}
		}
		return rv;
	},
	_onAfterRenderFunction: function(form, rOpts) {
		var me = form;
		var fields = me.getForm().getFields( );
		if(me.masterGrid) {
			me.masterGrid.addChildForm(me);
		}
		for(var i = 0, len=fields.length; i < len; i ++) {
			me._onFieldAddFunction(form, fields.getAt(i), i);
		}
		// console.log('detail form is rendering. ' + fields.length + ' items');
	} ,
	// 필드가 추가 될때 unilite를 위한 추가 기능을 등록 한다.
	_onFieldAddFunction : function(form, field, index ){		
			// console.log(form.id +"-" + index + " field added : " , field);
			if( field.isFormField ) {
				if(Ext.isFunction(field.setOwnerForm)) {
					field.setOwnerForm( form );
				}
	      		
	      		/**
	             * @event uniOnChange
	             * // VB의 onChange와 같이 onBLur시 변경된 값이 있을 경우 발생
	             * @param field 
	             * @param newValue
	             * @param oldValue
	             */
	            //addEvents 제거 - 5.0.1 deprecated 
//				field.addEvents('uniOnChange');

	        	field.on('change', form._onFieldChangedFunction, this);
	        	
	        	// radio, checkbox등은 focus를 가지지 않음 !!
        		//field.on('focus',function( field, The, eOpts ) {console.log("gotFocus : ", field); } , this);
	        	
	        	if ('radiogroup' == field.ariaRole || 'group' == field.ariaRole || 'combobox' == field.ariaRole || 'tagfield' == field.ariaRole )  {
					// radiogroup / change( this, newValue, oldValue, eOpts )13
					// checkboxgroup // change( this, newValue, oldValue, eOpts )13
					field.on('change', function(field, newValue, oldValue, eOpts) {
							console.log('radiogroup change');
							form._onFieldBlurFunction('change',field, newValue);
					}, this );
				}else if ('radio' == field.ariaRole || 'checkbox' == field.ariaRole)  {
					
				} else {
					// blur( this, The, eOpts )
					field.on('blur', function(field, The, eOpts) {
							form._onFieldBlurFunction('blur',field);
						}, this );
				}
                if(Ext.isDefined(field.allowBlank) && ! field.allowBlank ) {
                    if(field.isPopupField) {
                        if(field.popupField) {
                            field.popupField.labelClsExtra = 'required_field_label';
                        }
                    } else {
                        field.labelClsExtra = 'required_field_label';
                    }
                }
				if(field.readOnly) {
					field.tabIndex = -1;
				}
				var opt = field.uniOpt || {};
				field.uniOpt = opt;
	        	
	      }
	      return true;
	},
	
	// 수정 되었는지 표시 
	_onFieldChangedFunction:function(field, newValue, oldValue, eOpts) {
		var me = this;
		//console.log ( field.fieldLabel,"(",field.name, ")",'_onFieldChangedFunc (oldValue => newValue)', oldValue, "=>" , newValue);
		if(!me.uniOpt.inLoading) {
			field.uniChanged = true;
			if(!Ext.isDefined(field.uniOpt))  field.uniOpt = {};
			field.uniOpt.oldValue = oldValue;
		}
	},
	
	/*
	 change event 에서 사용시 변경된 value 값 사용
	 * */
	getChangeEventValues:function( fieldName, newValue)	{
		var values = this.getForm().getValues();
		if(fieldName && newValue)	{
			values[fieldName] = newValue;
		}
		return values;
	},
	/**
	 * Clear all field's value 
	 * % The reset() method just resets the form back to the last record loaded.
	 */
	clearForm:function(){
	     Ext.each(this.getForm().getFields().items, function(field){
	            field.setValue('');
	     });
	 },
	
	_onFieldBlurFunction:function(type, field, newValue) {
		var me = this;
		// change event가 모든 상황에서 발생하는것이 아니라 uniChange가 제대로 반영 되지 않음.
		// 그래서 isDirty로 변경함. 2013/12/19
		//if(! me.uniOpt.inLoading && (field.uniChanged == true || type == 'change')) {
		
		//2014.11.11 modified. - isDirty 체크를 위해 위의 setValue() 함수내에서 orignalValue를 reset 하지 않도록 수정.
		if(! me.uniOpt.inLoading && (field.uniChanged || field.isDirty() || type == 'change')) {
			var rec = this.activeRecord; //this.getRecord();
			var form = this.getForm();
			
			if(rec) {
				console.log ( "update record.field value change detected on ", field.name);
				//form.updateRecord(rec);	//form의 내용을 rec에 write 함. form 과 record type이 다를 경우 convert 필요(ex>회계 관리항목)
				me._updateRecord(rec);
			}
			var mNewVal = null;
			if(Ext.isDefined(newValue)) {
				mNewVal = newValue;
			} else {
				if('radiogroup' == field.ariaRole ) {
					mNewVal = {};
					mNewVal[field.name] =  field.getValue();
				} else if( 'radio' == field.ariaRole ) {
					mNewVal = {};
					mNewVal[field.name] =  field.getValue();
				} else {
					mNewVal = field.getValue();
				}
			}
			
			//2016.06.12 데이타 변경 없이 blur event 발생시 저장버튼 활성화로 인해 조건 추가함
			if(form.isDirty() || (field.uniOpt.oldValue == null && field.isDirty()) || mNewVal != field.uniOpt.oldValue) {
				field.fireEvent( 'uniOnChange',  field, mNewVal, field.uniOpt.oldValue  ) ;
				
				me.fireEvent( 'uniOnChange',  me, field, mNewVal, field.uniOpt.oldValue  ) ;
			}
			
			field.uniChanged = false;
		};
	},
	
	/**
	 * record와 form values sync 시 uniDatefield 의 경우 record type 이 string 이면 sync 가 안되므로 추가된 함수
	 * 회계 관리항목에서 필요
	 * Ext.form.Basic.updateRecord(record) 이용
	 * @param {} record
	 * @return {}
	 */
	_updateRecord: function(record) {
		var form = this.getForm();
        record = record || form._record;
        if (!record) {
            //<debug> 
            Ext.raise("A record is required.");
            //</debug> 
            return this;
        }
        
        var fields = record.self.fields,
            values = form.getFieldValues(),
            obj = {},
            i = 0,
            len = fields.length,
            name;
 
        for (; i < len; ++i) {
            name  = fields[i].name;
 
            if (values.hasOwnProperty(name)) {
            	if(this.getField(name) && this.getField(name).xtype == "uniDatefield" && 
            	   record.getField(name) && record.getField(name).type == "string")	{
            	   	obj[name] = UniDate.getDateStr(values[name]);
            	} else {
                	obj[name] = values[name];
            	}
            }
        }
 
        record.beginEdit();
        record.set(obj);
        record.endEdit();
 
        return this;
    },
	
	/**
	 * Save 나 reset후 form의 상태를 초기상태로 변경함 
	 * - trackResetOnLoad:true 로 했을 경우 저장후 상태가 reset 안되는 현상이 있어 이를 호출 해야함.
	 */
	resetDirtyStatus: function() {
		var me = this;
		//var form = this.getForm();
		var items = me.getForm().getFields().items,
		    i = 0,
		    len = items.length;
		for(; i < len; i++) {
		    var c = items[i];
		    //c.value = '';
		    if(c.mixins && c.mixins.field && typeof c.mixins.field['initValue'] == 'function'){
		        c.mixins.field.initValue.apply(c);
		        c.wasDirty = false;
		    }
		}
		me.getForm().wasDirty = false;	
	},
	onLoadSelectText:function(fieldName)	{
		var me = this;
		var startField = me.getField(fieldName);
		
		startField.on('afterrender', function(field, eOpt){
			var fEl = Ext.isEmpty(field.el.down('.x-form-cb-input')) ? field.el.down('.x-form-field'):field.el.down('.x-form-cb-input');
			fEl.focus(10);	
			setTimeout(function(){ fEl.dom.select() }, 100);
			
		})
	}
	,
	getInvalidMessage:function()	{
		var me = this;
		
		var invalid = me.getForm().getFields().filterBy(function(field) {
															return !field.validate();
														});				   															
		if(invalid.length > 0) {
			var labelText = ''

			if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
				var labelText = invalid.items[0]['fieldLabel']+'은(는)';
			} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
				var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
			}

		   	alert(labelText+Msg.sMB083);
		   	invalid.items[0].focus();
		   	return false;
		} 
		return true;
	}
});