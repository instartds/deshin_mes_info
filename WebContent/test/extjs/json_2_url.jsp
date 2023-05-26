<%@page language="java" contentType="text/html; charset=utf-8"%>

<script type="text/javascript">
	Ext.require([ '*' ]);
	
	

Ext.onReady(function() {    
	//var params = {'a':212, 	  'b':'abc'};
	//var t = JSON.stringify(params) ;
	if(typeof params !== 'undefined') {
		Ext.Object.each(params, function(key, value) {			
			console.log("key: " , key, "  =  ", value );
		});
	}
});
</script>

