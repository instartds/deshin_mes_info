<%@page language="java" contentType="text/html; charset=utf-8"%>

<script type="text/javascript" >
            
// Ext.onReady(function() {});


function appMain() {
	console.log('appMain');
	var testForm = Ext.create('Unilite.com.form.UniDetailForm', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		defaultType : 'uniTextfield',
        items: [
        	 {
	              name: 'startYear',
	              fieldLabel: '시작년도'
	         },
	         {
	             name: 'endYear',
	             fieldLabel: '종료년도'
	         },
	         {	
	         	xtype:'uniDatefield',
	            name: 'startYear2',
	            fieldLabel: '시작'
	         },
	         {
	              name: 'endYear2',
	              fieldLabel: '종료'
	         }]
	}); //testForm
	var testForm2 = Ext.create('Unilite.com.form.UniDetailForm', {
		title: 'Time Card2',
		disabled : false,
		layout: { type: 'uniTable',
				columns : 3
		},
        items: [{
	              xtype: 'uniTextfield',
	              name: 'startYear',
	              fieldLabel: '시작년도'
	         }]
	}); //testForm	
	
	Unilite.Main({
		items : [testForm,testForm2]
	});  //Unilite.Main
}
</script>


<div id="formDiv" style="layout:absolute;top:100;left:100;border:1px solid #f00">OOOO</div>
<div id="formDiv2" style="layout:absolute;top:200;left:200;border:1px solid #f00">AAAA</div>
<input name="USERID" type='TEXT' />
      