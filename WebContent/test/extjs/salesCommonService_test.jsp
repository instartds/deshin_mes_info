<%@page language="java" contentType="text/html; charset=utf-8"%>

<script type="text/javascript" >

function appMain() {
	console.log('appMain');
	var fnExchangeRateService = Unilite.createForm('fnExchangeRateService', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		tbar: [
            	{
	            	itemId : 'fnGetCRedit', iconCls : 'icon-referance'	,
	        		text:'fnGetCRedit',
	        		handler: function() { //#COMP_CODE#, #MONEY_UNIT#,#S_DATE#
		        					var param = fnExchangeRateService.getValues();
									salesCommonService.fnExchangeRate(param, function(provider, response)	{
											fnExchangeRateService.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'MONEY_UNIT', name:'MONEY_UNIT', value:'KRW'},
       		 		 {fieldLabel:'S_DATE', name:'S_DATE', xtype:'uniDatefield', value:'20140530', colspan:2},
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	});
	
	var fnOrgCdService = Unilite.createForm('fnOrgCdService', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		tbar: [
            	{
	            	itemId : 'fnOrgCd', iconCls : 'icon-referance'	,
	        		text:'fnOrgCd',
	        		handler: function() { //#COMP_CODE#, #MONEY_UNIT#,#S_DATE#
		        					var param = fnOrgCdService.getValues();
									salesCommonService.fnOrgCd(param, function(provider, response)	{
											fnOrgCdService.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'TYPE', name:'TYPE', value:''},
       		 		 {fieldLabel:'TREE_CODE', name:'TREE_CODE',  value:'', colspan:2},
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	}
	); //fnOrgCdService
	
	var fnGetOrgInfoService = Unilite.createForm('fnGetOrgInfoService', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		tbar: [
            	{
	            	itemId : 'fnGetOrgInfo', iconCls : 'icon-referance'	,
	        		text:'fnGetOrgInfo',
	        		handler: function() { //#COMP_CODE#, #MONEY_UNIT#,#S_DATE#
		        					var param = fnGetOrgInfoService.getValues();
									salesCommonService.fnGetOrgInfo(param, function(provider, response)	{
										
											fnGetOrgInfoService.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'DIV_CODE', name:'DIV_CODE', value:'01'},
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	}
	); //fnGetOrgInfoService
	
	
	var fnCloseCheckService = Unilite.createForm('fnCloseCheckService', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		tbar: [
            	{
	            	itemId : 'fnCloseCheck', iconCls : 'icon-referance'	,
	        		text:'fnCloseCheck',
	        		handler: function() { //#COMP_CODE#, #MONEY_UNIT#,#S_DATE#
		        					var param = fnCloseCheckService.getValues();
									salesCommonService.fnCloseCheck(param, function(provider, response)	{
											fnCloseCheckService.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'DIV_CODE', name:'DIV_CODE', value:'01'},
       		 		 {fieldLabel:'WH_CODE', name:'WH_CODE', value:'CH001'},
       		 		 {fieldLabel:'S_DATE', name:'S_DATE', xtype:'uniDatefield', value:'20140530'},
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	}
	); //fnCloseCheckService
	
	var fnGetPrevNextNoService = Unilite.createForm('fnGetPrevNextNoService', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2
		},
		tbar: [
            	{
	            	itemId : 'fnGetPrevNextNo', iconCls : 'icon-referance'	,
	        		text:'fnGetPrevNextNo',
	        		handler: function() { //#COMP_CODE#, #MONEY_UNIT#,#S_DATE#
		        					var param = fnGetPrevNextNoService.getValues();
									salesCommonService.fnGetPrevNextNo(param, function(provider, response)	{
											fnGetPrevNextNoService.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'DIV_CODE', name:'DIV_CODE', value:'01'},
       		 		 {fieldLabel:'TYPE', name:'TYPE', value:''},
       		 		 {fieldLabel:'MOVE', name:'MOVE', value:'P'},
       		 		 
       		 		 {fieldLabel:'ESTI_NUM', name:'ESTI_NUM', value:''},
       		 		 {fieldLabel:'ORDER_NUM', name:'ORDER_NUM', value:''},
       		 		 {fieldLabel:'ISSUE_REQ_NUM', name:'ISSUE_REQ_NUM', value:''},
       		 		 {fieldLabel:'INOUT_NUM', name:'INOUT_NUM', value:''},
       		 		 
       		 		 {fieldLabel:'BILL_NUM', name:'BILL_NUM', value:''},
       		 		 {fieldLabel:'PUB_NUM', name:'PUB_NUM', value:''},
       		 		 {fieldLabel:'COLLECT_NUM', name:'COLLECT_NUM', value:''},
       		 		 {fieldLabel:'sCollectMoneyFlag', name:'sCollectMoneyFlag', value:'Y'},
       		 		 
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	}
	); //fnGetPrevNextNoService
	
	var fnGetPriceInfo2Service = Unilite.createForm('fnGetPriceInfo2Service', {
		disabled : false,
		layout: { type: 'uniTable',
				columns : 2,
				tdAttrs:{valign:'top'}
		},
		tbar: [
            	{
	            	itemId : 'fnGetPriceInfo2', iconCls : 'icon-referance'	,
	        		text:'fnGetPriceInfo2',
	        		handler: function() { //#COMP_CODE#, #MONEY_UNIT#,#S_DATE#
		        					var param = fnGetPriceInfo2Service.getValues();
									salesCommonService.fnGetPriceInfo2(param, function(provider, response)	{
											fnGetPriceInfo2Service.setValue('textareafield', JSON.stringify(provider, null, '\t'));
									})
		        			}
       		 	}
       		 ],
       		 items:[ {fieldLabel:'COMP_CODE', name:'COMP_CODE', value:'MASTER'},
       		 		 {fieldLabel:'DIV_CODE', name:'DIV_CODE', value:'01'},
       		 		 {fieldLabel:'CUSTOM_CODE', name:'CUSTOM_CODE', value:''},
       		 		 {fieldLabel:'AGENT_TYPE', name:'AGENT_TYPE', value:''},
       		 		 
       		 		 {fieldLabel:'ITEM_CODE', name:'ITEM_CODE', value:''},
       		 		 {fieldLabel:'MONEY_UNIT', name:'MONEY_UNIT', value:'KRW'},
       		 		 {fieldLabel:'ORDER_UNIT', name:'ORDER_UNIT', xtype:'uniCombobox' , comboType:'AU', comboCode:'B013', value:''},
       		 		 {fieldLabel:'STOCK_UNIT', name:'STOCK_UNIT', value:''},
       		 		 
       		 		 {fieldLabel:'TRANS_RATE', name:'TRANS_RATE', value:'0'},
       		 		 {fieldLabel:'BASIS_DATE', name:'BASIS_DATE', value:''},
       		 		 {fieldLabel:'WGT_UNIT', name:'WGT_UNIT', value:''},
       		 		 {fieldLabel:'VOL_UNIT', name:'VOL_UNIT', value:''},
       				 {hideLabel:true, xtype:'textareafield', name:'textareafield', width:500, height:100, colspan:2}
       		 ]
	}
	); //fnGetPrevNextNoService
	Ext.create('Ext.Viewport',{
			renderTo : Ext.getBody(),
		layout: { type: 'uniTable',
				columns : 2
		},
		items : [	fnExchangeRateService, 
					fnOrgCdService, 
					fnGetOrgInfoService,
					fnCloseCheckService,
					fnGetPrevNextNoService,
					fnGetPriceInfo2Service
				]
	});  //Unilite.Main
}
</script>

      