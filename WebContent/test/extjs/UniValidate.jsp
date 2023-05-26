<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript">

Ext.onReady(function() {


		Ext.create('Ext.Viewport', {
			layout : {
				type : 'vbox',
				pack : 'start',
				align : 'stretch'
			},

			items : [ {contentEl:'test'} ],
			renderTo : Ext.getBody()
		});

	});
	
	function chkBizNo() {
		var pins = ['1234561234567', '1234561234561','1234561234562','1234561234563','123456-1234563'];
		for(var i=0, len = pins.length; i<len; i++) { 
			var item = pins[i];
			console.log ('주민등록번호' , i, item, Unilite.validate('residentno',item) );
		}
		var bizNos = ['1234', '1234567890','5678123456','1078181337','107-81-81337'];
		for(var i=0, len = bizNos.length; i<len; i++) { 
			console.log ('사업자등록번호' , i, bizNos[i], Unilite.validate('bizno',bizNos[i]) );
		}
		var phoneNos = ['1234', '010-123-1234','5678123456','1078181337','107-81-81337'];
		for(var i=0, len = phoneNos.length; i<len; i++) { 
			console.log ('전화번호' , i, phoneNos[i], Unilite.validate('phone',phoneNos[i]) );
		}
		var dates = ['19910101', '1998/01/01','1998.01.01','1078181337','107-81-81337'];
		for(var i=0, len = dates.length; i<len; i++) { 
			var item = dates[i];
			console.log ('날자형식' , i, item, Unilite.validate('isDate',item) );
		}
	}
</script>
<!-- Search Area  -->
<div id="ext" > </div>
<div id="test">
<a href="#" onclick="chkBizNo()">  [검증] </a> (firebug 같은 web debuger를 사용하세요 !)
</div>
<!-- //List Area -->
