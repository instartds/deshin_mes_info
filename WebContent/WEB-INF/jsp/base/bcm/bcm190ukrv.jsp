<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm190ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="bcm190ukrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var hasChecked = false;
function appMain() {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
		layout : {type : 'uniTable', columns : 2},
		padding		: '0 0 0 1',
		xtype		: 'container',
		defaultType	: 'container',
		border: false,
		flex		: 4,
		autoScroll	: true,
         items		: [{
 			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5, width: '80%'}, tdAttrs: {valign:'top'}},
 			defaultType	: 'uniFieldset',
 			defaults	: { padding: '10 15 20 10' , margin: '30 0 0 50'},
 			items		: [{
 				title	: '거래처코드 변환',
 				defaults: {type: 'uniTextfield', labelWidth:100},
 				layout	: { type: 'uniTable', columns: 2, tableAttrs: {cellpadding:5, width: '100%'}},
 				items	: [{
 					html	: "<font color = 'blue' >※ 거래처코드는 임시로 부여된 거래처코드 중 수주, 출고로 발생한 </br>&nbsp;&nbsp;&nbsp;&nbsp; 거래처코드에 대해서만 변경되며 매출이나 회계전표등이 발생</br>&nbsp;&nbsp;&nbsp;&nbsp; 하였을 경우 변경이 불가능 합니다.</font>",
 					xtype	: 'component',
 					padding	: '0 0 10 30',
 					colspan: 2
 				},Unilite.popup('CUST',{
 					fieldLabel: '현재 거래처',
 					textFieldWidth: 130,
 					autoPopup: true,
 					colspan: 2
 				}),
 				{
 					fieldLabel: '변환 거래처코드',
 					xtype:'uniTextfield',
 					name:'NEW_CUSTOM_CODE',
 					width: 325,
 				},{
 		         	xtype:'button',
 		         	text:'중복체크',
 		    		handler:function()	{
 		    			var param = panelResult.getValues();
 		    			bcm190ukrvService.existCheck(param, function(provider, response){
 		    				if(!Ext.isEmpty(provider)){
 		    					hasChecked = false;
 		    					Unilite.messageBox('현재 등록된 거래처코드가 있습니다. ( ' + provider[0].CUSTOM_FULL_NAME + ' )');
 		    				}else{
 		    					hasChecked = true;
 		    					Unilite.messageBox('변환 가능합니다.');
 		    				}
 		    			});
 		         	}
 		         },
 				{
 		         	xtype:'button',
 		         	text:'변환',
 		         	margin: '0 0 0 145',
 		         	width: 100,
 		    		handler:function()	{
 		    			var param = panelResult.getValues();
 		    			if(hasChecked == true){
 		    				Ext.getBody().mask();
 		    				bcm190ukrvService.changeData(param,function(provider, response){
 		    					if(response.type == 'rpc'){
 		    						hasChecked = false;
 		    	    				Unilite.messageBox('변환에 성공합니다.');
 		    					}
 		    					Ext.getBody().unmask();
 		    				});
 		    				
 		    			}else{
 		    				hasChecked = false;
 		    				Unilite.messageBox('중복체크를 먼저 진행하여 주십시오.');
 		    			}
 		         	}
 		         }]
 			}]
 		}]
		
		
		
    });


    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}
		],
		id  : 'bcm190ukrvApp',
		fnInitBinding : function() {
			
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		}
	});
};

</script>
