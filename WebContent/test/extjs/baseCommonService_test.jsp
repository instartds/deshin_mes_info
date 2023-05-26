<%@page language="java" contentType="text/html; charset=utf-8"%>

<script type="text/javascript" >

function appMain() {
	console.log('appMain');
	var fnAutoNoService = Unilite.createForm('fnAutoNoService', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		tbar: [
            	{
	            	itemId : 'fnAutoNo', 
	        		text:'fnAutoNo',
	        		handler: function() { //#COMP_CODE#, #MONEY_UNIT#,#S_DATE#
		        						var param = fnAutoNoService.getValues();
										baseCommonService.fnAutoNo(param, function(provider, response)	{
										fnAutoNoService.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],  
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'DIV_CODE', name:'DIV_CODE', value:'01'},
       		 		 {fieldLabel:'TABLE_ID', name:'TABLE_ID'},
       		 		 {fieldLabel:'JOB_ID', name:'JOB_ID'},
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	}); //fnAutoNoService
	
	var fnLastYyMmService = Unilite.createForm('fnLastYyMmService', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		tbar: [
            	{
	            	itemId : 'fnLastYyMm',
	        		text:'fnLastYyMm',
	        		handler: function() { //#COMP_CODE#, #MONEY_UNIT#,#S_DATE#
		        					var param = fnLastYyMmService.getValues();
									baseCommonService.fnLastYyMm(param, function(provider, response)	{
											fnLastYyMmService.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'DIV_CODE', name:'DIV_CODE', value:'01'},
       		 		 {fieldLabel:'WH_CODE', name:'WH_CODE', value:'CH001', colspan:2},
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	}
	); //fnLastYyMmService
	
	var fnStockqService = Unilite.createForm('fnStockqService', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		tbar: [
            	{
	            	itemId : 'fnStockq'	,
	        		text:'fnStockq',
	        		handler: function() { 
		        					var param = fnStockqService.getValues();
									baseCommonService.fnStockQ(param, function(provider, response)	{
										
											fnStockqService.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'WH_CODE', name:'WH_CODE', value:'CH001'},
       		 		 {fieldLabel:'ITEM_CODE', name:'ITEM_CODE', value:'CH001', colspan:2},
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	}
	); //fnStockqService
	
	
	var fnStockPriceService = Unilite.createForm('fnStockPriceService', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		tbar: [
            	{
	            	itemId : 'fnStockPrice', iconCls : 'icon-referance'	,
	        		text:'fnStockPrice',
	        		handler: function() { //#COMP_CODE#, #MONEY_UNIT#,#S_DATE#
		        					var param = fnStockPriceService.getValues();
									baseCommonService.fnStockPrice(param, function(provider, response)	{
											fnStockPriceService.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'WH_CODE', name:'WH_CODE', value:'CH001'},
       		 		 {fieldLabel:'ITEM_CODE', name:'ITEM_CODE', value:'CH001', colspan:2},
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	}
	); //fnStockPriceService
	
	Ext.create('Ext.Viewport',{
			renderTo : Ext.getBody(),
		layout: { type: 'uniTable',
				columns : 2
		},
		items : [	fnAutoNoService, 
					fnLastYyMmService, 
					fnStockqService,
					fnStockPriceService
				]
	});  //Unilite.Main
}
</script>

      