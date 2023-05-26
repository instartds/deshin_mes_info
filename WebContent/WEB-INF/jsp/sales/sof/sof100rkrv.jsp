<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof100rkrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="sof100rkrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->       
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
	function appMain(){
		var panelSearch = Unilite.createSearchForm('searchForm',{
			region: 'center',
			layout : {type : 'uniTable', columns : 1},
			padding:'1 1 1 1',
			border:true,
			items:[
				{
					xtype:'radiogroup',
					fieldLabel: '<t:message code="system.label.sales.reporttype" default="보고서유형"/>',
					items:[
						{
							boxLabel:'<t:message code="system.label.sales.itemby" default="품목별"/>',
							width:100,
							name:'PRINT_ITEM',
							inputValue:'1',
							checked:true
						},{
							boxLabel:'<t:message code="system.label.sales.clientby" default="고객별"/>',
							width:100,
							name:'PRINT_ITEM',
							inputValue:'2'
						},{
							boxLabel:'<t:message code="system.label.sales.deliverydateby" default="납기일별"/>',
							width:100,
							name:'PRINT_ITEM',
							inputValue:'3'
						},{
							boxLabel:'<t:message code="system.label.sales.sonoby" default="수주번호별"/>',
							width:100,
							name:'PRINT_ITEM',
							inputValue:'4'
						}
					],
					listeners:{
						change : function(radioGroup, newValue, oldValue, eOpts){
							if(newValue.PRINT_ITEM == "4"){
								var orderNum1 = Ext.getCmp('orderNum');
								orderNum1.setHidden(false);
							}else{
								var orderNum1 = Ext.getCmp('orderNum');
								orderNum1.setHidden(true);
							}
						}
					}
				},{
					fieldLabel:'<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					xtype: 'uniCombobox',
					name:'ORDER_PRSN',
					comboType:'AU',
					allowBlank:false,
					comboCode:'S010'
				},{
					fieldLabel:'<t:message code="system.label.sales.division" default="사업장"/>',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					name:'DIV_CODE',
					allowBlank:false,
					value: UserInfo.divCode
				},{
            		fieldLabel:'<t:message code="system.label.sales.sodate" default="수주일"/>',
            		xtype: 'uniDateRangefield',
            		startFieldName: 'FR_DATE',
            		endFieldName:'TO_DATE',
            		width:315,
            		startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today')
				},Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.client" default="고객"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					allowBlank		: false,
					autoPopup		: true,
					listeners		: {
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
							}
						}
					}
					
				}),Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE', 
					textFieldName	: 'ITEM_NAME', 
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),
				{
					fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
					name: 'CUST_LEVEL',
					xtype : 'uniCombobox',
					comboType:'AU',
					comboCode:'B055'
				},{
					fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
					name: 'AREA_TYPE' ,
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'B056'
				},{
					fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
					name:'ORDER_TYPE',	
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'S002'
				},{
					name: 'ITEM_LEVEL1',
	    			fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
	    			xtype:'uniCombobox',
	                store: Ext.data.StoreManager.lookup('itemLeve1Store'),
	                child: 'ITEM_LEVEL2'
				},{
					name: 'ITEM_LEVEL2',
	              	fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
	              	xtype:'uniCombobox',
	                store: Ext.data.StoreManager.lookup('itemLeve2Store'),
	                child: 'ITEM_LEVEL3'
				},{
					name: 'ITEM_LEVEL3',
	             	fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
	             	xtype:'uniCombobox',
	                store: Ext.data.StoreManager.lookup('itemLeve3Store')
				},Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
		        	valueFieldName: 'MODEL_CODE', 
					textFieldName: 'MODEL_NAME', 
					validateBlank: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('MODEL_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('MODEL_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),
				{
			 	 	xtype: 'container',
		   			defaultType: 'uniNumberfield',
					layout: {type: 'hbox', align:'stretch'},
					width:325,
					margin:0,
					items:[{
						fieldLabel:'<t:message code="system.label.sales.soqty" default="수주량"/>',
						suffixTpl:'&nbsp;~&nbsp;',
						name: 'FR_ORDER_QTY',
						width:218
					}, {
						name: 'TO_ORDER_QTY',
						width:107
				}]
			},{
				    xtype: 'radiogroup',
				    fieldLabel: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',			    
				    colspan: 2,
				    items : [{
				    	boxLabel: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
				    	name: 'OPT_SELECT',
				    	inputValue: 'Y',
				    	checked: true,
				    	width:100
				    }, {
				    	boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>',
				    	name: 'OPT_SELECT' ,
				    	inputValue: 'N',
				    	width:100
				    }]				
				},
				{
                    xtype: 'container',
                    layout: {type: 'vbox'},
                    items:[{
                    	xtype:'uniTextfield',
    					fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>',
    					name: 'ORDER_NUM',
                        id:'orderNum'
    					
    				}]
				}
			]
		});
		Unilite.Main({
			borderItems:[
				{
					region:'center',
					layout: 'border',
					border: true,
					items:[
						panelSearch
					]
				}
			],
			id  : 'sof100rkrvApp',
			fnInitBinding : function() {
				UniAppManager.setToolbarButtons('print',true);
				UniAppManager.setToolbarButtons('query',false);
				
				panelSearch.setValue('PRINT_ITEM','1');
                Ext.getCmp('orderNum').setHidden(true);
				panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
                panelSearch.setValue('TO_DATE',UniDate.get('today'));
                panelSearch.setValue('OPT_SELECT','Y');
                
			},
			onResetButtonDown: function() {
				panelSearch.clearForm();
				this.fnInitBinding();
			},
			onPrintButtonDown: function() {
	        	if(!panelSearch.getInvalidMessage()) return;   //필수체크
					var param = panelSearch.getValues();
					if(param.PRINT_ITEM==1){
						param.sPrintFlag = "ITEM";
						param.sPrintFlagStr = "<t:message code="system.label.sales.itemby" default="품목별"/>";
						param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.sostatusprint" default="수주현황 출력"/>(<t:message code="system.label.sales.itemby" default="품목별"/>)';
						param["RPT_ID"]='sof100rkrv1';
					}else if(param.PRINT_ITEM==2){
						param.sPrintFlag = "CUSTOM";
						param.sPrintFlagStr = "<t:message code="system.label.sales.clientby" default="고객별"/>";
						param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.sostatusprint" default="수주현황 출력"/>(<t:message code="system.label.sales.clientby" default="고객별"/>)';
						param["RPT_ID"]='sof100rkrv2';
					}else if(param.PRINT_ITEM==3){
						param.sPrintFlag = "DATE";
						param.sPrintFlagStr = "<t:message code="system.label.sales.deliverydateby" default="납기일별"/>";
						param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.sostatusprint" default="수주현황 출력"/>(<t:message code="system.label.sales.deliverydateby" default="납기일별"/>)';
						param["RPT_ID"]='sof100rkrv3';
					}else if(param.PRINT_ITEM==4){
						param.sPrintFlag = "ORDER";
						param.sPrintFlagStr = "<t:message code="system.label.sales.sonoby" default="수주번호별"/>";
						param["sTxtValue2_fileTitle"]='<t:message code="system.label.sales.sostatusprint" default="수주현황 출력"/>(<t:message code="system.label.sales.sonoby" default="수주번호별"/>)';
						param["RPT_ID"]='sof100rkrv4';
					}
					param["PGM_ID"]='sof100rkrv';
					if(param.OPT_SELECT=="Y"){
						param["TradeYN_Name"]="<t:message code="system.label.sales.tradeinclusion" default="무역포함"/>";
					}else{
						param["TradeYN_Name"]="<t:message code="system.label.sales.tradenoninclusion" default="무역미포함"/>";
					}
					param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
					param["ORDER_NAME"]=panelSearch.getField('ORDER_PRSN').getRawValue();
					var win = Ext.create('widget.CrystalReport', {
	                    url: CPATH+'/sales/sof100crkrv.do',
	                    prgID: 'sof100rkrv',
	                    extParam: param
	                });
						win.center();
						win.show();
	        	
			}
		});
	}
</script>