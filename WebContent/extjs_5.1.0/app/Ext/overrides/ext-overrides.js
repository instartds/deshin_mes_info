//@charset UTF-8
/**
 * ExtJS bug overrides
 */
 
 /**
  * Store insert 오류 with locking grid
  * ExtJS version : 5.1.0
  */
Ext.override(Ext, {
	validIdRe: /^[a-z_][a-z0-9\-_.]*$/i
});

Ext.override(Ext.dom.Element, {
	
	validIdRe: /^[a-z_][a-z0-9\-_.]*$/i

});

Ext.override(Ext.Component, {
	
	validIdRe: /^[a-z_][a-z0-9\-_.]*$/i

});

Ext.override(Ext.form.trigger.Trigger, {
	
	validIdRe: /^[a-z_][a-z0-9\-_.]*$/i

});

