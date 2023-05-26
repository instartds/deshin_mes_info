//@charset UTF-8
/**
 *  form 과 grid를 같은 함수(get, set)로 처리하기 위한 객체
 */
Ext.define('Unilite.com.ValidateService.ExtRec',{
	type : null,
	obj: null,
	constructor: function(config) {
		Ext.apply(this, config);
	},
	/**
	 * 
	 * @param {} fieldName
	 * @return {}
	 */
	get:function(fieldName) {
		if(this.type =='grid') {
			return this.obj.get(fieldName);
		} else if ( this.type == 'form' ) {
			return this.obj.getValue(fieldName);
		}
	},
	/**
	 * 
	 * @param {} fieldName
	 * @param {} value
	 * @return {}
	 */
	set:function(fieldName, value) {
		if(this.type =='grid') {
			return this.obj.set(fieldName, value);
		} else if( this.type == 'form' ) {
			return this.obj.setValue(fieldName, value);
		}
	}
});//ExtRec

/**
 * @class Unilite.com.ValidateService
 * 
 */
Ext.define('Unilite.com.ValidateService',{
	/**
	 * 
	 * @cfg {Unilite.com.data.UniStore} 
	 */
	store : null,
	/**
	 * 
	 * @cfg {Unilite.com.grid.UniGridPanel} 
	 */
	grid: null,
	/**
	 * 
	 * @cfg {Unilite.com.form.UniDetailForm} 
	 */
	forms:null, 
	
	constructor: function(config) {
		Ext.apply(this, config);
		var me = this;
		console.log("uniValidator");
		if(me.grid) {
			console.log('grid added');
			me.grid.on('validateedit',function(editor, e)  {
				/**
				 * editor : Ext.grid.plugin.CellEditing
				 * e : Object
				 *   An edit event with the following properties:
				 *   	grid - The grid
				 *   	record - The record being edited	
				 *   		//  e.record.data[e.field] = e.value;
				 *   	field - The field name being edited
				 *   	value - The value being set
				 *   	originalValue - The original value for the field, before the edit.
				 *   	row - The grid table row
				 *   	column - The grid Column defining the column that is being edited.
				 *   	rowIdx - The row index that is being edited
				 *   	colIdx - The column index that is being edited
				 *   	cancel - Set this to true to cancel the edit or return false from your handler.
				 */
				var eRec = Ext.create('Unilite.com.ValidateService.ExtRec', {type:'grid', obj:e.record});
				
				var rv = me.validate('grid', e.field, e.value, e.originalValue, eRec,  me.grid, editor, e);
				if(rv != true) { 
					e.cancel = true;
					if(rv != false) {
						me.alert(rv, e.column.text); // 오류 메시지						
					}
					
				} else {
					// 정상일 경우 
				}
			}); // validateedit 
		} // me.grid
        
		if(me.forms && Ext.isObject(me.forms)) {   // typeof obj !== 'object'
			//var keys = Unilite.getKeys(me.forms); // Object.keys(obj) IE 9부터 지원
			
			for(var key in me.forms) {
				var form = me.forms[key]; 
				if(form instanceof Ext.form.Panel ) {
					console.log('Validator Service for form : ' , form.id);
					var fields = form.getForm().getFields( );
					for(i = 0, len = fields.length; i < len; i ++) {
						var field = fields.getAt(i);
						// 사실 getFields에서는 form 필드만 가져옴 					
						if(field.isFormField) {
							// validator - text/number
							
							// 각 필드에 담담 폼
							Ext.apply(field, {uniOpt: {ownForm:form}});
							
							// 각 필드에 validator 함수 정의 ( 메모리 효율성을 위해 외부 함수사용) 
							// radiogroup과 checkboxgroup는 validator를 사용 하지 않음 
							// 그래서 uniRadioGroup과 uniCheckBox그룹만지원함..!!!
							
							Ext.apply(field, {'validator': function() {
										var field = this;
										//console.log()
										return me._fieldBeforeFn(field, me);
									} // function
							});
						}
						
					}
				} 
			} // for forms
		}// me.forms
	}, 

	setUseConfirmMsg: function ( b )	{
		this._useConfirmMsg = b;
	},
	// form 항목의 validator 호출 /호출 처리 사전 사후 처리 
	_fieldBeforeFn:function(field, service ) {
		var rv = true,  form=field.uniOpt.ownForm, lastValidValue = field.uniOpt.lastValidValue;
		var newValue = field.value;
		
		if(field.uniChanged) {
			if(form.uniOpt.inLoading) {
				var uniOpt = field.uniOpt || {};
				Ext.apply(uniOpt, {'lastValidValue': newValue});
				field.uniOpt = uniOpt;
			}
			
			//if(!form.uniOpt.inLoading && field.isDirty()) {
			if(!form.uniOpt.inLoading) {
				//console.log('Validator dirty : ' , form.id);;
				// form 과 grid를 같은 함수로 처리하기 위한 객체
				var eRec = Ext.create('Unilite.com.ValidateService.ExtRec', {type:'form', obj:form});
				//form.activeRecord
				var rv = service.validate('field', field.name, newValue, lastValidValue, eRec, form, field, null);
				if(rv != true ) {
					service.resetToLastValue(field );
					service.alert(rv, field.fieldLabel); // 오류 메시지
				}else {
					var uniOpt = field.uniOpt || {};
					Ext.apply(uniOpt, {'lastValidValue': newValue});
					field.uniOpt = uniOpt;
				}
			}
		}
		return rv;
	},
	
	resetToLastValue : function(field){
        var me = field, uniOpt = field.uniOpt || {};

        me.beforeReset();
        me.setValue(uniOpt.lastValidValue || me.originalValue);
        me.clearInvalid();
        // delete here so we reset back to the original state
        delete me.wasValid;
    },
	/**
	 * 
	 * @param {} type		[grid | form]
	 * @param {} fieldName	수정이 발생된 column name
	 * @param {} newValue	신규값
	 * @param {} oldValue
	 * @param {} record
	 * @param {} eopt
	 * @return {Boolean|string}		
	 */
	validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
		return true;
	}, 
	alert: function(message, tit) {
		if(!(message == false || message == true || message == undefined))	{
			Ext.MessageBox.show({
	                        title: tit || 'Alert',
	                        msg: message,
	                        icon: Ext.MessageBox.ERROR,
	                        buttons: Ext.Msg.OK
	                    });
		}
	}
});  // ValidateService