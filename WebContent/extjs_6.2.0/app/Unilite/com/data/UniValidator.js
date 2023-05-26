//@charset UTF-8
/**
 * Unilite용 확장 validator
 */

Ext.define('Ext.override.data.validator.Presence', {
	override: 'Ext.data.validator.Presence',
    type: 'presence',
    config: {
        
        message: '필수 입력값 입니다.',
        
        allowEmpty: false
    },
    validate: function(value) {
        var valid = !(value === undefined || value === null);
        if (valid && !this.getAllowEmpty()) {
            valid = !(value === '');
        }
        if(valid && Ext.isNumber(value))	{
        	if(value == 0)	valid=false;
        }
        return valid ? true : this.getMessage();
    }
});
