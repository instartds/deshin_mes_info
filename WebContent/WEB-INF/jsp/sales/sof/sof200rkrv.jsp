<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof200rkrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="sof200rkrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->       
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
	function appMain(){
		var panelSearch = Unilite.createSearchForm('searchForm',{
			region: 'center',
			layout : {type : 'uniTable', columns : 1},
			padding:'1 1 1 1',
			border:true,
			items:[
				{
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
            		fieldLabel:'<t:message code="system.label.sales.deliverydate" default="납기일"/>',
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
					autoPopup		: true,
					validateBlank	: true,
					allowBlank		: false,
					listeners: {
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
					fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
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
				}),{
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
					id:'ORDER_TYPE',
					comboCode:'S002',
					disabled: false
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
				}/*
				// 중복되는 로직 20210806 주석처리
				 ,Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		        	valueFieldName: 'MODEL_CODE', 
					textFieldName: 'MODEL_NAME', 
					validateBlank: false
				}) */,{
				 	 	xtype: 'container',
			   			defaultType: 'uniNumberfield',
						layout: {type: 'hbox', align:'stretch'},
						width:325,
						margin:0,
						items:[{
							fieldLabel:'<t:message code="system.label.sales.undeliveryqty" default="미납량"/>',
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
				    	name: 'RADIO_SELECT',
				    	inputValue: 'N',
				    	checked:true,
				    	width:100
				    }, {
				    	boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>',
				    	name: 'RADIO_SELECT' ,
				    	inputValue: 'Y',
				    	width:100
				    }],listeners:{
						change : function(radioGroup, newValue, oldValue, eOpts){
							if(newValue.RADIO_SELECT == "N"){
								var orderType = Ext.getCmp('ORDER_TYPE');
								orderType.setDisabled(false);
							}else{
								var orderType = Ext.getCmp('ORDER_TYPE');
								orderType.setDisabled(true);
							}
						}
					}
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
				id  : 'sof200rkrvApp',
				fnInitBinding : function() {
					UniAppManager.setToolbarButtons('print',true);
					UniAppManager.setToolbarButtons('query',false);
					
                    panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                    panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
                    panelSearch.setValue('TO_DATE',UniDate.get('today'));
                    panelSearch.setValue('RADIO_SELECT','N');
                    Ext.getCmp('ORDER_TYPE').setDisabled(false);
				},
				onResetButtonDown: function() {
					panelSearch.clearForm();
					this.fnInitBinding();
				},
				onPrintButtonDown: function() {
                    if(!panelSearch.getInvalidMessage()) return;   //필수체크
					var param = panelSearch.getValues();
					param["sTxtValue2_fileTitle"]="<t:message code="system.label.sales.unissuedstatusprint" default="미납현황출력"/>";
					if(param.RADIO_SELECT=='Y'){
						param["tradeYN"]="Y";
						param["tradeYNAME"]="<t:message code="system.label.sales.tradeinclusion" default="무역포함"/>";
					}else{
						param["tradeYN"]="N";
						param["tradeYNAME"]="<t:message code="system.label.sales.nonetradeinclusion" default="무역포함안함"/>";
					}
					param["PGM_ID"]='sof200rkrv';
					param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
					param["ORDER_NAME"]=panelSearch.getField('ORDER_PRSN').getRawValue();
					var win = Ext.create('widget.CrystalReport', {
	                    url: CPATH+'/sales/sof200crkrv.do',
	                    prgID: 'sof200rkrv',
	                    extParam: param
	                });
						win.center();
						win.show();
				}
		});
	}
</script>