//@charset UTF-8
Ext.ns('Unilite.com');
Ext.define('Unilite.com.ValidateService',{
	store : null,
	grid: null,
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
				
				var rv = me.validate('grid', e.field, e.value, '', e.record, e.row, me.grid);
				if(rv != true) { 
					e.cancel = true;
					if(rv != false) {
						me.alert(rv, e.column.text); // 오류 메시지
					}
				} else {
					// 정상일 경우 
				}
			});
		} // me.grid
		if(me.forms && Ext.isObject(me.forms)) {   // typeof obj !== 'object'
			var keys = Object.keys(me.forms);
			
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
							Ext.apply(field, {'validator' : function() {
									var field = this, rv = true;
									var newValue = field.value;
									if(field.uniChanged) {
										console.log('valide check');
										var rv = me.validate('field', field.name, newValue, '', form.activeRecord, form);
										if(rv != true ) {
											me.resetToLastValue(field );
											me.alert(rv, field.fieldLabel); // 오류 메시지
											console.log('test');
											//field.focus();
											//rv = true;
										}else {
											var uniOpt = field.uniOpt || {};
											Ext.apply(uniOpt, {'lastValidValue': newValue});
											field.uniOpt = uniOpt;
										}
									} 
									var rec = form.activeRecord;
									return rv;
								} // function
							}); // validator
							//console.log("field added ",  field.xtype,  field.name);
						}
						
					}
				} 
			} // for forms
		}// me.forms
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
	validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		return true;
	}, 
	alert : function(message, tit) {
		Ext.MessageBox.show({
                        title: tit || 'Alert',
                        msg: message,
                        icon: Ext.MessageBox.ERROR,
                        buttons: Ext.Msg.OK
                    });
	}
});  // ValidateService