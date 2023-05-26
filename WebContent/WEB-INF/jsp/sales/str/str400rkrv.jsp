<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str400rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="str400rkrv" />	<!-- 사업장 --> 
	<t:ExtComboStore comboType="OU" />							<!-- 입고창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	

.x-change-cell_light_Yellow {
background-color: #FFFFA1;
}

.x-change-cell_yellow {
background-color: #FAED7D;
}

</style>
<script type="text/javascript" >

function appMain() {
	var panelSearch = Unilite.createSearchForm('str400rkrForm', {
		region		: 'center',
		disabled	: false,
		border		: false,
		flex		: 1,
		layout		: {
			type	: 'uniTable',
			columns	: 1
		},
		defaults	: {
			width		: 325,
			labelWidth	: 120
		},
		defaultType	: 'uniTextfield',
		padding		: '20 0 0 0',
		width		: 400,
		items		: [{
				fieldLabel	: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
				name		: 'INOUT_DATE',
				xtype		: 'uniDatefield',
				value		: new Date(),
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WH_CODE', '');
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'OU',
				listeners	: {
					beforequery:function( queryPlan, eOpts ){
						var store = queryPlan.combo.store;
							store.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							})
						}else{
							store.filterBy(function(record){
								return false;
							})
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
				xtype		: 'uniTextfield',
				name		: 'INOUT_NUM',
				holdable	: 'hold'
			},{
				fieldLabel	: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
				name		: 'AGENT_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B055',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
				name		: 'AREA_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B056'
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.sales.client" default="고객"/>',
				valueFieldName	: 'CUSTOM_CODE',	//EXPORTER
				textFieldName	: 'CUSTOM_NAME',
				textFieldWidth	: 175, 
				popupWidth		: 710,
				validateBlank	: false,
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
			}),{
				fieldLabel	: '<t:message code="system.label.sales.priceamountprintyn" default="단가/금액출력여부"/>',
				xtype		: 'radiogroup',
				itemId		: 'PRINT_YN',
				width		: 300,
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
					name		: 'PRINT_YN',
					inputValue	: 'Y'
				},{
					boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
					name		: 'PRINT_YN',
					inputValue	: 'N',
					checked		: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.issueprinttype" default="출고인쇄구분"/>',
				xtype		: 'radiogroup',
				itemId		: 'PRINT_CUST',
				width		: 300,
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.clientby" default="고객별"/>',
					name		: 'PRINT_KIND',
					inputValue	: 'CUST',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.bydeliveryplacename" default="배송처별"/>',
					name		: 'PRINT_KIND',
					inputValue	: 'DVRY'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}
		]
	});



	Unilite.Main( {
		id		: 'str400rkrApp',
		border	: false,
		items	: [
			panelSearch
		],
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE'	, UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset', 'query', 'detail'],false);
			UniAppManager.setToolbarButtons('print',true);

			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		//링크로 넘어오는 params 받는 부분 (Agj100skr)
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'str103ukrv' || params.PGM_ID == 'str104ukrv') {
				panelSearch.setValue('INOUT_CODE'	, params.INOUT_CODE);
				panelSearch.setValue('INOUT_NUM'	, params.INOUT_NUM);
				panelSearch.setValue('DIV_CODE'		, params.DIV_CODE);
				panelSearch.setValue('INOUT_DATE'	, params.INOUT_DATE);
				panelSearch.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
				panelSearch.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
			}
		},
		onQueryButtonDown : function() {
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
		/*	if(this.onFormValidate()){
				var param= panelSearch.getValues();
				
				var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/sales/str400clrkr.do',
				prgID: 'str400rkr',
				extParam: param
				});
				win.center();
				win.show(); 
			} */
			if(this.onFormValidate()){
				var param= panelSearch.getValues();
				param.ACCNT_DIV_NAME = panelSearch.getField('DIV_CODE').getRawValue();
				var win = Ext.create('widget.PDFPrintWindow', {
					url		: CPATH+'/str/str400rkrPrint1.do',
					prgID	: 'str400rkr',
					extParam: param
				});
				win.center();
				win.show();
			}
		},
		onFormValidate: function(){
			var r= true
			var invalid = panelSearch.getForm().getFields().filterBy(
				function(field) {
					return !field.validate();
				}
			);
			if(invalid.length > 0) {
				r = false;
				var labelText = ''
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+' : ';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
				}
				Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				invalid.items[0].focus();
			}
			return r;
		}
	});
};
</script>
