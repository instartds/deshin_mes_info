<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="bcm100ukrv"  >
</t:appConfig >
<script type="text/javascript" >
Ext.define('model', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'uname', type: 'String'},
            {name: 'age', type: 'int'}
        ],
        validations: [
            {type: 'presence', field: 'uname'}
        ]
});
var records = new Array();
records.push( Ext.ModelManager.create({uname: 'a', age:10}, 'model') ) ;
records.push( Ext.ModelManager.create({uname: '', age:20}, 'model') ) ;


for(var i =0, len = records.length ; i < len ; i ++ ) {
var errors = records[i].validate();
	console.log( 'uname : [' + records[i].get('uname') +']');
	console.log("isValid :", errors.isValid() , errors.getByField('uname')); // [{field: 'number', message: 'must be present'}]
	            
}         
</script>            