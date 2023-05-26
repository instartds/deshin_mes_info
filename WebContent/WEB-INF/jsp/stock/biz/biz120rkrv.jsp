<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biz120ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var outDivCode = UserInfo.divCode;

function appMain() {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items : [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false
			},
			Unilite.popup('CUST',{
				fieldLabel: '외주처', 
				textFieldWidth: 170,
				allowBlank:false
			}),
			
			{
				fieldLabel: '실사일',//COUNT_DATE pop控件和vb不一样
				name: 'COUNT_DATE',
				xtype: 'uniDatefield',
				textFieldWidth: 70,
				allowBlank:false
			}
//			,{					
//    			fieldLabel: '실사반영일',
//    			name:'COUNT_DATE2',
//    			xtype: 'uniTextfield',
//    			readOnly: true
//    		}
    		,{
				fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>', 
				name:'ITEM_ACCOUNT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B020'
			},{ 
				fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1' , 
				xtype: 'uniCombobox' ,  
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'ITEM_LEVEL2'
			},{ 
				fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'ITEM_LEVEL3'
			},{ 
				fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve3Store')
			}]
    });
	
	
	
	

   
	
    Unilite.Main( {
		borderItems:[ 
			panelResult
		],  	    	 
		id: 'biz120ukrvApp',
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next','print'], true);
			this.setDefault();
		},
		setDefault: function() {		// 기본값
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.getForm().wasDirty = false;
         	panelResult.resetDirtyStatus();                            
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelResult.clearForm();
			this.fnInitBinding();
			panelResult.getField('CUSTOM_CODE').focus();
		},
		onPrintButtonDown: function() {
			if(this.onFormValidate()){
				var param = panelResult.getValues();
		        console.log(param);
		        var win = Ext.create('widget.PDFPrintWindow', {
		            url: CPATH+'/biz/biz120rkrPrint.do',
		            prgID: 'biz120rkr',
	                extParam: param
	            });
	            win.center();
	            win.show();
			}
	         
	    },
	    onFormValidate: function(){
	    	var r= true
	        var invalid = panelResult.getForm().getFields().filterBy(
	     		function(field) {
					return !field.validate();
				}
		    );
   	
			if(invalid.length > 0) {
				r=false;
				var labelText = ''
	
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+' : ';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
				}
	
			   	alert(labelText+Msg.sMB083);
			   	invalid.items[0].focus();
			}
			return r;
	    }
	    
	});
  
};
		
</script>