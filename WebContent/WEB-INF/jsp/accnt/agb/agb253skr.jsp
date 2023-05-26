<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb253skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

/*
 * 조회조건, 기준월을 
 * ac_code1 = 'L4' -> AC_DATA1
 * ac_code2 = 'L4' -> AC_DATA2
 * ac_code3 = 'L4' -> AC_DATA3
 * ac_code4 = 'L4' -> AC_DATA4
 * ac_code5 = 'L4' -> AC_DATA5
 * ac_code6 = 'L4' -> AC_DATA6
 */


function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('agb253skrModel', {
		fields: [  	  
			{name: 'AGENT_TYPE' 		, text: '고객타입' 		,type: 'string'},
			{name: 'AGENT_NAME' 	  	, text: '고객분류'		,type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '거래처코드' 	,type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명' 		,type: 'string'},
			{name: 'AMT_1'				, text: '1개월' 		,type: 'uniPrice'},
			{name: 'AMT_2'				, text: '2개월' 		,type: 'uniPrice'},
			{name: 'AMT_3'				, text: '3개월' 		,type: 'uniPrice'},
			{name: 'AMT_4'				, text: '4개월' 		,type: 'uniPrice'},
			{name: 'AMT_5'				, text: '5개월' 		,type: 'uniPrice'},
			{name: 'AMT_6'				, text: '6개월' 		,type: 'uniPrice'},
			{name: 'AMT_7'				, text: '7개월' 		,type: 'uniPrice'},
			{name: 'AMT_8'				, text: '8개월' 		,type: 'uniPrice'},
			{name: 'AMT_9'				, text: '9개월' 		,type: 'uniPrice'},
			{name: 'AMT_10'				, text: '10개월' 		,type: 'uniPrice'},
			{name: 'AMT_11'				, text: '11개월' 		,type: 'uniPrice'},
			{name: 'AMT_12'				, text: '12개월' 		,type: 'uniPrice'},
			{name: 'AMT_13'				, text: '1년이하'		,type: 'uniPrice'},
			{name: 'AMT_14'				, text: '13개월'		,type: 'uniPrice'},
			{name: 'AMT_15'				, text: '14개월'		,type: 'uniPrice'},
			{name: 'AMT_16'				, text: '15개월'		,type: 'uniPrice'},
			{name: 'AMT_17'				, text: '16개월'		,type: 'uniPrice'},
			{name: 'AMT_18'				, text: '17개월'		,type: 'uniPrice'},
			{name: 'AMT_19'				, text: '18개월'		,type: 'uniPrice'},
			{name: 'AMT_20'				, text: '19개월'		,type: 'uniPrice'},
			{name: 'AMT_21'				, text: '20개월'		,type: 'uniPrice'},
			{name: 'AMT_22'				, text: '21개월'		,type: 'uniPrice'},
			{name: 'AMT_23'				, text: '22개월'		,type: 'uniPrice'},
			{name: 'AMT_24'				, text: '23개월'		,type: 'uniPrice'},
			{name: 'AMT_25'				, text: '24개월'		,type: 'uniPrice'},
			{name: 'AMT_26'				, text: '1년 ~ 2년'	,type: 'uniPrice'},
			{name: 'AMT_27'				, text: '25개월'		,type: 'uniPrice'},
			{name: 'AMT_28'				, text: '26개월'		,type: 'uniPrice'},
			{name: 'AMT_29'				, text: '27개월'		,type: 'uniPrice'},
			{name: 'AMT_30'				, text: '28개월'		,type: 'uniPrice'},
			{name: 'AMT_31'				, text: '29개월'		,type: 'uniPrice'},
			{name: 'AMT_32'				, text: '30개월'		,type: 'uniPrice'},
			{name: 'AMT_33'				, text: '31개월'		,type: 'uniPrice'},
			{name: 'AMT_34'				, text: '32개월'		,type: 'uniPrice'},
			{name: 'AMT_35'				, text: '33개월'		,type: 'uniPrice'},
			{name: 'AMT_36'				, text: '34개월'		,type: 'uniPrice'},
			{name: 'AMT_37'				, text: '35개월'		,type: 'uniPrice'},
			{name: 'AMT_38'				, text: '36개월'		,type: 'uniPrice'},
			{name: 'AMT_39'				, text: '2년 ~ 3년'	,type: 'uniPrice'},
			{name: 'AMT_40'				, text: '3년초과'		,type: 'uniPrice'},
			{name: 'AMT_TOT'			, text: '계' 		,type: 'uniPrice'},
			{name: 'GUBUN'				, text: '구분' 		,type: 'string'}
		]		  
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agb253skrMasterStore1',{
		model: 'agb253skrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
		   type: 'direct',
			api: {			
				read: 'agb253skrService.selectList'					
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'AGENT_NAME',
		listeners : {
			load: function(store, records, successful, eOpts) {
				var grid = Ext.getCmp('agb253skrGrid1');
				var dispType1 = panelResult.getValues().DISP_TYPE1;
				var dispType2 = panelResult.getValues().DISP_TYPE2;
				var dispType3 = panelResult.getValues().DISP_TYPE3;
				
				var col01 = grid.getColumnIndex("AMT_1");
				var col02 = grid.getColumnIndex("AMT_14");
				var col03 = grid.getColumnIndex("AMT_27");
				
				if(dispType1 == 'M') {
					grid.columns[col01	 ].show();
					grid.columns[col01 +  1].show();
					grid.columns[col01 +  2].show();
					grid.columns[col01 +  3].show();
					grid.columns[col01 +  4].show();
					grid.columns[col01 +  5].show();
					grid.columns[col01 +  6].show();
					grid.columns[col01 +  7].show();
					grid.columns[col01 +  8].show();
					grid.columns[col01 +  9].show();
					grid.columns[col01 + 10].show();
					grid.columns[col01 + 11].show();
					grid.columns[col01 + 12].hide();
				}
				else {
					grid.columns[col01	 ].hide();
					grid.columns[col01 +  1].hide();
					grid.columns[col01 +  2].hide();
					grid.columns[col01 +  3].hide();
					grid.columns[col01 +  4].hide();
					grid.columns[col01 +  5].hide();
					grid.columns[col01 +  6].hide();
					grid.columns[col01 +  7].hide();
					grid.columns[col01 +  8].hide();
					grid.columns[col01 +  9].hide();
					grid.columns[col01 + 10].hide();
					grid.columns[col01 + 11].hide();
					grid.columns[col01 + 12].show();
				}
				
				if(dispType2 == 'M') {
					grid.columns[col02	 ].show();
					grid.columns[col02 +  1].show();
					grid.columns[col02 +  2].show();
					grid.columns[col02 +  3].show();
					grid.columns[col02 +  4].show();
					grid.columns[col02 +  5].show();
					grid.columns[col02 +  6].show();
					grid.columns[col02 +  7].show();
					grid.columns[col02 +  8].show();
					grid.columns[col02 +  9].show();
					grid.columns[col02 + 10].show();
					grid.columns[col02 + 11].show();
					grid.columns[col02 + 12].hide();
				}
				else {
					grid.columns[col02	 ].hide();
					grid.columns[col02 +  1].hide();
					grid.columns[col02 +  2].hide();
					grid.columns[col02 +  3].hide();
					grid.columns[col02 +  4].hide();
					grid.columns[col02 +  5].hide();
					grid.columns[col02 +  6].hide();
					grid.columns[col02 +  7].hide();
					grid.columns[col02 +  8].hide();
					grid.columns[col02 +  9].hide();
					grid.columns[col02 + 10].hide();
					grid.columns[col02 + 11].hide();
					grid.columns[col02 + 12].show();
				}
				
				if(dispType3 == 'M') {
					grid.columns[col03	 ].show();
					grid.columns[col03 +  1].show();
					grid.columns[col03 +  2].show();
					grid.columns[col03 +  3].show();
					grid.columns[col03 +  4].show();
					grid.columns[col03 +  5].show();
					grid.columns[col03 +  6].show();
					grid.columns[col03 +  7].show();
					grid.columns[col03 +  8].show();
					grid.columns[col03 +  9].show();
					grid.columns[col03 + 10].show();
					grid.columns[col03 + 11].show();
					grid.columns[col03 + 12].hide();
				}
				else {
					grid.columns[col03	 ].hide();
					grid.columns[col03 +  1].hide();
					grid.columns[col03 +  2].hide();
					grid.columns[col03 +  3].hide();
					grid.columns[col03 +  4].hide();
					grid.columns[col03 +  5].hide();
					grid.columns[col03 +  6].hide();
					grid.columns[col03 +  7].hide();
					grid.columns[col03 +  8].hide();
					grid.columns[col03 +  9].hide();
					grid.columns[col03 + 10].hide();
					grid.columns[col03 + 11].hide();
					grid.columns[col03 + 12].show();
				}
				
			}
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title: '기본정보', 	
	   		itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{ 
				fieldLabel: '기준월',
				xtype: 'uniDatefield',
				name: 'AC_DATE',
				value: UniDate.get('endOfMonth'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_DATE', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
				Unilite.popup('ACCNT',{ 
					fieldLabel: '계정과목', 
					valueFieldName: 'ACCOUNT_CODE_FR',
					textFieldName: 'ACCOUNT_NAME_FR', 
					autoPopup:true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ACCOUNT_CODE_FR', panelSearch.getValue('ACCOUNT_CODE_FR'));
								panelResult.setValue('ACCOUNT_NAME_FR', panelSearch.getValue('ACCOUNT_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ACCOUNT_CODE_FR', '');
							panelResult.setValue('ACCOUNT_NAME_FR', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "(SPEC_DIVI IN ('G1', 'D1'))",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
			}),   	
				Unilite.popup('ACCNT',{ 
					fieldLabel: '~', 
					valueFieldName: 'ACCOUNT_CODE_TO',
					textFieldName: 'ACCOUNT_NAME_TO',
					autoPopup:true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ACCOUNT_CODE_TO', panelSearch.getValue('ACCOUNT_CODE_TO'));
								panelResult.setValue('ACCOUNT_NAME_TO', panelSearch.getValue('ACCOUNT_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ACCOUNT_CODE_TO', '');
							panelResult.setValue('ACCOUNT_NAME_TO', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "(SPEC_DIVI IN ('G1', 'D1'))",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				}),{
			 		fieldLabel: '고객분류',
			 		name:'AGENT_TYPE', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'B055',
			 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}
		 		},
					Unilite.popup('CUST',{ 
					fieldLabel: '거래처', 
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,					
					valueFieldName: 'CUST_CODE_FR',
					textFieldName: 'CUST_NAME_FR',
					listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUST_CODE_FR', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_NAME_FR', '');
									panelSearch.setValue('CUST_NAME_FR', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUST_NAME_FR', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_CODE_FR', '');
									panelSearch.setValue('CUST_CODE_FR', '');
								}
							}
					}
				}),   	
				Unilite.popup('CUST',{ 
					fieldLabel: '~',
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,						
					valueFieldName: 'CUST_CODE_TO',
					textFieldName: 'CUST_NAME_TO',
					listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUST_CODE_TO', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_NAME_TO', '');
									panelSearch.setValue('CUST_NAME_TO', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUST_NAME_TO', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_CODE_TO', '');
									panelSearch.setValue('CUST_CODE_TO', '');
								}
							}
					}
				}),{
					xtype: 'radiogroup',							
					fieldLabel: '1년차 표시방식',
					name: 'DISP_TYPE1',
					items: [{
						boxLabel : '개월', 
						width: 70,
						inputValue: 'M',
						checked: true
					},{
						boxLabel: '년', 
						width: 70, 
						inputValue: 'Y' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DISP_TYPE1', newValue);
						}
					}
				},{
					xtype: 'radiogroup',							
					fieldLabel: '2년차 표시방식',
					name: 'DISP_TYPE2',
					items: [{
						boxLabel : '개월', 
						width: 70,
						inputValue: 'M',
						checked: true
					},{
						boxLabel: '년', 
						width: 70, 
						inputValue: 'Y' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DISP_TYPE1', newValue);
						}
					}
				},{
					xtype: 'radiogroup',							
					fieldLabel: '3년차 표시방식',
					name: 'DISP_TYPE3',
					items: [{
						boxLabel : '개월', 
						width: 70,
						inputValue: 'M',
						checked: true
					},{
						boxLabel: '년', 
						width: 70, 
						inputValue: 'Y' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DISP_TYPE1', newValue);
						}
					}
				}]		
			}],
			setAllFieldsReadOnly: function(b) { 
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
						return !field.validate();
					});					  
					if(invalid.length > 0) {
				 		r=false;
					 	var labelText = ''
				 		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					  		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					  		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
						}
						alert(labelText+Msg.sMB083);
						invalid.items[0].focus();
				 	} else {
				  		//this.mask();
				  		var fields = this.getForm().getFields();
				  		Ext.each(fields.items, function(item) {
				   			if(Ext.isDefined(item.holdable) ) {
					 			if (item.holdable == 'hold') {
					 				item.setReadOnly(true); 
								}
				   			} 
				   			if(item.isPopupField) {
								var popupFC = item.up('uniPopupField') ;	   
								if(popupFC.holdable == 'hold') {
					 				popupFC.setReadOnly(true);
								}
				   			}
				  		})
				   	}
				} else {
					//this.unmask();
				   	var fields = this.getForm().getFields();
				 	Ext.each(fields.items, function(item) {
				  		if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(false);
				   			}
				  		} 
				  		if(item.isPopupField) {
				   			var popupFC = item.up('uniPopupField') ; 
				   			if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
				  			}
				  		}
				 	})
				}
				return r;
			}
	});	  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
				fieldLabel: '기준월',
				xtype: 'uniDatefield',
				name: 'AC_DATE',
				value: UniDate.get('endOfMonth'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_DATE', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},
				Unilite.popup('ACCNT',{
				fieldLabel: '계정과목',
	//			validateBlank:false,	 
				valueFieldName: 'ACCOUNT_CODE_FR',
				textFieldName: 'ACCOUNT_NAME_FR',
		 		child: 'ITEM',
		 		autoPopup:true,
				listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCOUNT_CODE_FR', panelResult.getValue('ACCOUNT_CODE_FR'));
								panelSearch.setValue('ACCOUNT_NAME_FR', panelResult.getValue('ACCOUNT_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCOUNT_CODE_FR', '');
							panelSearch.setValue('ACCOUNT_NAME_FR', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "(SPEC_DIVI IN ('G1', 'D1'))",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
   	 		}),   	
				Unilite.popup('ACCNT',{ 
					fieldLabel: '~',
					popupWidth: 710,
					valueFieldName: 'ACCOUNT_CODE_TO',
					textFieldName: 'ACCOUNT_NAME_TO',
					autoPopup:true,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCOUNT_CODE_TO', panelResult.getValue('ACCOUNT_CODE_TO'));
								panelSearch.setValue('ACCOUNT_NAME_TO', panelResult.getValue('ACCOUNT_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCOUNT_CODE_TO', '');
							panelSearch.setValue('ACCOUNT_NAME_TO', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "(SPEC_DIVI IN ('G1', 'D1'))",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
			}),{
			 		fieldLabel: '고객분류',
			 		name:'AGENT_TYPE', 
			 		xtype: 'uniCombobox',
			 		comboType:'AU',
			 		comboCode:'B055',
			 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('AGENT_TYPE', newValue);
						}
					}
		 	},
				Unilite.popup('CUST',{ 
				fieldLabel: '거래처',  
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,				
				valueFieldName: 'CUST_CODE_FR',
				textFieldName: 'CUST_NAME_FR',
				listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelSearch.setValue('CUST_CODE_FR', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_NAME_FR', '');
									panelSearch.setValue('CUST_NAME_FR', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelSearch.setValue('CUST_NAME_FR', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_CODE_FR', '');
									panelSearch.setValue('CUST_CODE_FR', '');
								}
							}
				}
			}),   	
			Unilite.popup('CUST',{ 
				fieldLabel: '~',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,					
				valueFieldName: 'CUST_CODE_TO',
				textFieldName: 'CUST_NAME_TO',
				colspan:2,
				listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelSearch.setValue('CUST_CODE_TO', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_NAME_TO', '');
									panelSearch.setValue('CUST_NAME_TO', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelSearch.setValue('CUST_NAME_TO', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUST_CODE_TO', '');
									panelSearch.setValue('CUST_CODE_TO', '');
								}
							}
				}
			}),{
				xtype: 'radiogroup',							
				fieldLabel: '1년차 표시방식',
				name: 'DISP_TYPE1',
				items: [{
					boxLabel : '개월', 
					width: 70,
					inputValue: 'M',
					checked: true
				},{
					boxLabel: '년', 
					width: 70, 
					inputValue: 'Y' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DISP_TYPE1', newValue);
					}
				}
			},{
				xtype: 'radiogroup',							
				fieldLabel: '2년차 표시방식',
				name: 'DISP_TYPE2',
				items: [{
					boxLabel : '개월', 
					width: 70,
					inputValue: 'M',
					checked: true
				},{
					boxLabel: '년', 
					width: 70, 
					inputValue: 'Y' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DISP_TYPE1', newValue);
					}
				}
			},{
				xtype: 'radiogroup',							
				fieldLabel: '3년차 표시방식',
				name: 'DISP_TYPE3',
				items: [{
					boxLabel : '개월', 
					width: 70,
					inputValue: 'M',
					checked: true
				},{
					boxLabel: '년', 
					width: 70, 
					inputValue: 'Y' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DISP_TYPE1', newValue);
					}
				}
			}],
			setAllFieldsReadOnly: function(b) { 
				var r = true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
						return !field.validate();
					});					  
					if(invalid.length > 0) {
				 		r=false;
					 	var labelText = ''
				 		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					  		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					  		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
						}
						alert(labelText+Msg.sMB083);
						invalid.items[0].focus();
				 	} else {
				  		//this.mask();
				  		var fields = this.getForm().getFields();
				  		Ext.each(fields.items, function(item) {
				   			if(Ext.isDefined(item.holdable) ) {
					 			if (item.holdable == 'hold') {
					 				item.setReadOnly(true); 
								}
				   			} 
				   			if(item.isPopupField) {
								var popupFC = item.up('uniPopupField') ;	   
								if(popupFC.holdable == 'hold') {
					 				popupFC.setReadOnly(true);
								}
				   			}
				  		})
				   	}
				} else {
					//this.unmask();
				   	var fields = this.getForm().getFields();
				 	Ext.each(fields.items, function(item) {
				  		if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(false);
				   			}
				  		} 
				  		if(item.isPopupField) {
				   			var popupFC = item.up('uniPopupField') ; 
				   			if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
				  			}
				  		}
				 	})
				}
				return r;
			}
	});	 
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	
	var masterGrid = Unilite.createGrid('agb253skrGrid1', {
		layout : 'fit',
		region : 'center',
		store : directMasterStore, 
		uniOpt:{
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
			lockable			: true,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true 
			},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 	  
			showSummaryRow: true
		}],
		columns: [		
			{dataIndex: 'AGENT_TYPE' 		, width: 66  ,hidden:true}, 				
			{dataIndex: 'AGENT_NAME' 		, width: 86	 ,locked:true	, align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		   			return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
			}}, 				
			{dataIndex: 'CUSTOM_CODE'		, width: 86  , locked:true},
			{dataIndex: 'CUSTOM_NAME'		, width: 120 , locked:true},
			{dataIndex: 'AMT_1'				, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_2'				, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_3'				, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_4'				, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_5'				, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_6'				, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_7'				, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_8'				, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_9'				, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_10'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_11'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_12'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_13'			, width: 120 , summaryType: 'sum' , hidden: true },
			{dataIndex: 'AMT_14'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_15'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_16'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_17'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_18'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_19'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_20'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_21'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_22'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_23'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_24'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_25'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_26'			, width: 120 , summaryType: 'sum' , hidden: true },
			{dataIndex: 'AMT_27'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_28'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_29'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_30'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_31'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_32'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_33'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_34'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_35'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_36'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_37'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_38'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_39'			, width: 120 , summaryType: 'sum' , hidden: true },
			{dataIndex: 'AMT_40'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'AMT_TOT'			, width: 120 , summaryType: 'sum' },
			{dataIndex: 'GUBUN'				, width: 120 , hidden: true }
		]
	});
	
	 Unilite.Main({
		id : 'agb253skrApp',
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					masterGrid, panelResult
				]
			},
			panelSearch  	
		],
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE');
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}		
			directMasterStore.loadStoreRecords();	
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>