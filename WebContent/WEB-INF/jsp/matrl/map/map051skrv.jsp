<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map051skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map051skrv"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP10"/>				<!--지급유형-->
	<t:ExtComboStore comboType="AU" comboCode="M201"/>				<!-- 지급담당 -->
</t:appConfig>
<style type="text/css">
	.x-change-cell {
		background-color: #fed9fe;
	}
</style>

<script type="text/javascript" >
var getVmiUserLevel = '${getVmiUserLevel}';
var PGM_TITLE = "거래처원장대사조회";

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/


function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map051skrvService.selectGrid'
		}
	});

	/**
	 * Model 정의 
	 * @type
	 */
	Unilite.defineModel('Map051skrvModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '법인코드'		,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장'		,type: 'string'},
			{name: 'CHANGE_BASIS_DATE'	,text: '거래일자'		,type: 'uniDate'},
		//	{name: 'ITEM_CODE'			,text: 'ITEM_CODE'	,type: 'string'},
			{name: 'ITEM_NAME'			,text: '거래내역'		,type: 'string'},
			{name: 'DEPT_NAME'			,text: '매장'			,type: 'string'},
			{name: 'CNT'				,text: '종수'			,type: 'uniQty'},
			{name: 'BUY_Q'				,text: '매입수량'		,type: 'uniQty'},
			{name: 'BUY_I'				,text: '매입액'		,type: 'uniPrice'},
			{name: 'R_BUY_Q'			,text: '반품수량'		,type: 'uniQty'},
			{name: 'R_BUY_I'			,text: '반품액'		,type: 'uniPrice'},
			{name: 'PAY_AMT'			,text: '지급액'		,type: 'uniPrice'},
//			{name: 'M_PAY_AMT'			,text: '조정액'		,type: 'uniPrice'},
			{name: 'CALCUL_I'			,text: '잔액'			,type: 'uniPrice'},
			{name: 'INOUT_NUM'			,text: '매입번호'		,type: 'string'}
			
		]
	});		//End of Unilite.defineModel('Map051skrvModel', {

	Unilite.defineModel('Map051skrvModel2', {
		fields: [
			{name: 'COMP_CODE'		,text: '법인코드'			,type: 'string'},
			{name: 'DIV_CODE'		,text: '사업장'			,type: 'string'},
			{name: 'INOUT_SEQ'		,text: '순번'				,type: 'int'},
			{name: 'ITEM_CODE'		,text: '품번'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '품명'				,type: 'string'},
			{name: 'ORDER_UNIT'		,text: '단위'				,type: 'string'},
			{name: 'INOUT_Q'		,text: '수량'				,type: 'uniQty'},
			{name: 'INOUT_P'		,text: '단가'				,type: 'uniPrice'},
			{name: 'TAX_TYPE' 		,text: '과세구분'			,type: 'string',comboType:'AU',comboCode:'B059'},
			{name: 'INOUT_I'		,text: '공급가액'			,type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'	,text: '부가세'			,type: 'uniPrice'},
			{name: 'TOTAL_INOUT_I'	,text: '합계금액'			,type: 'uniPrice'}
		]
	});


	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('map051skrvMasterStore1',{
		model: 'Map051skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
			
		proxy: directProxy,
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();	
			console.log(param);
			this.load({
				params : param
			});
		}
	});		// End of var directMasterStore1 = Unilite.createStore('map051skrvMasterStore1',{
	
	var directMasterStore2 = Unilite.createStore('map051skrvMasterStore2', {
		model: 'Map051skrvModel2',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'map051skrvService.selectList2'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
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
			items:[{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue, false);
					}
				}
			},
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					id:'CUSTOM1',
					valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
					allowBlank: false,
					readOnly: true
			}),{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'CHANGE_BASIS_DATE_FR',
				endFieldName: 'CHANGE_BASIS_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {

						panelResult.setValue('CHANGE_BASIS_DATE_FR',newValue);
						//panelResult.getField('CHANGE_BASIS_DATE_FR').setValue(UniDate.getDateStr(newValue));
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('CHANGE_BASIS_DATE_TO',newValue);
//						panelResult.getField('CHANGE_BASIS_DATE_TO').setValue(UniDate.getDateStr(newValue));
					}
				}
			},{
				fieldLabel:'매입번호',
				name:'CHANGE_BASIS_NUM',
				xtype:'uniTextfield',
				hidden:true	
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
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) ) {
								if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField) {
								var popupFC = item.up('uniPopupField');
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
					}
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
				}
				return r;
			}
	});		// End of var masterForm = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					id:'CUSTOM2',
					valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
					textFieldWidth: 170, 
					allowBlank: false,
					readOnly: true
			}),{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'CHANGE_BASIS_DATE_FR',
				endFieldName: 'CHANGE_BASIS_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(masterForm) {

						masterForm.setValue('CHANGE_BASIS_DATE_FR',newValue);
						//masterForm.getField('CHANGE_BASIS_DATE_FR').setValue(UniDate.getDateStr(newValue));
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(masterForm) {
						masterForm.setValue('CHANGE_BASIS_DATE_TO',newValue);
						//masterForm.getField('CHANGE_BASIS_DATE_TO').setValue(UniDate.getDateStr(newValue));
					}
				}
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
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) ) {
								if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField) {
								var popupFC = item.up('uniPopupField');
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})
					}
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
				}
				return r;
			}
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{

	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid= Unilite.createGrid('map051skrvGrid', {
		region: 'center' ,
		layout: 'fit',
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		}, 
		store: directMasterStore1,
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary',
			showSummaryRow: false 
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{dataIndex:'COMP_CODE'					, width: 88, hidden:true },
			{dataIndex:'DIV_CODE'					, width: 88, hidden:true },
			{dataIndex:'CHANGE_BASIS_DATE'			, width: 88,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
		//	{dataIndex:'ITEM_CODE'				, width: 88, hidden:true},
			{dataIndex:'ITEM_NAME'				, width: 250 },
			{dataIndex:'CNT'					, width: 88, summaryType: 'sum' },
			{dataIndex:'BUY_Q'					, width: 88, summaryType: 'sum' },
			{dataIndex:'BUY_I'					, width: 88, summaryType: 'sum' },
			{dataIndex:'R_BUY_Q'				, width: 88, summaryType: 'sum' },
			{dataIndex:'R_BUY_I'				, width: 88, summaryType: 'sum' },
			{dataIndex:'PAY_AMT'				, width: 88, summaryType: 'sum' },
//			{dataIndex:'M_PAY_AMT'				, width: 88 },
			{dataIndex:'CALCUL_I'				, width: 88, tdCls:'x-change-cell' },
			{dataIndex:'DEPT_NAME'				, width: 250 },
			{dataIndex:'INOUT_NUM'				, width: 150,hidden:true}
			
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					masterForm.setValue('CHANGE_BASIS_NUM',record.get('INOUT_NUM'));
//					masterForm.setValue('G_INOUT_CODE',record.get('INOUT_CODE'));
					directMasterStore2.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
			},
			
			beforeedit  : function( editor, e, eOpts ) {
			}
		}
	});		// End of masterGrid= Unilite.createGrid('map051skrvGrid', {
	
	var masterGrid2 = Unilite.createGrid('map050ukrvGrid2', {
//		layout: 'fit',
		region: 'south',
		split:true,
		flex: 0.5,
		excelTitle: '거래내역(detail)',
		uniOpt: {
			useGroupSummary: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
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
		store: directMasterStore2,
		columns: [
				{dataIndex: 'COMP_CODE'				,width:80,hidden:true},
				{dataIndex: 'DIV_CODE'				,width:80,hidden:true},
				{dataIndex: 'INOUT_SEQ'				,width:88},
				{dataIndex: 'ITEM_CODE'				,width:150,align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}},
				{dataIndex: 'ITEM_NAME'				,width:200},
				{dataIndex: 'ORDER_UNIT'			,width:60,align:'center'},
				{dataIndex: 'INOUT_Q'				,width:88,summaryType: 'sum'},
				{dataIndex: 'INOUT_P'				,width:88},
				{dataIndex: 'TAX_TYPE' 				,width:88,align:'center'},
				{dataIndex: 'INOUT_I'				,width:88,summaryType: 'sum'},
				{dataIndex: 'INOUT_TAX_AMT'			,width:88,summaryType: 'sum'},
				{dataIndex: 'TOTAL_INOUT_I'			,width:88,summaryType: 'sum'}
		]
	});
	Unilite.Main({
		id			: 'map051skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult,masterGrid2
			]
		},
			masterForm
		],
		uniOpt: {
			showToolbar: true,
			isManual : false
		},
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE'				, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'				, UserInfo.divCode);
			masterForm.setValue('CHANGE_BASIS_DATE_FR'	, UniDate.get('startOfMonth'));
			masterForm.setValue('CHANGE_BASIS_DATE_TO'	, UniDate.get('today'));
			panelResult.setValue('CHANGE_BASIS_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('CHANGE_BASIS_DATE_TO'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();
				masterGrid2.reset();
				beforeRowIndex = -1;
			}
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		setDefault: function() {
			map051skrvService.userCustom({}, function(provider, response) {
				if(!Ext.isEmpty(provider)){
				masterForm.setValue('CUSTOM_CODE'	, provider['CUSTOM_CODE']);
				masterForm.setValue('CUSTOM_NAME'	, provider['CUSTOM_NAME']);
				panelResult.setValue('CUSTOM_CODE'	, provider['CUSTOM_CODE']);
				panelResult.setValue('CUSTOM_NAME'	, provider['CUSTOM_NAME']);
			
				}
			});
			if(getVmiUserLevel == '0'){
				Ext.getCmp('CUSTOM1').setReadOnly(false);
				Ext.getCmp('CUSTOM2').setReadOnly(false);
			}else{
				Ext.getCmp('CUSTOM1').setReadOnly(true);
				Ext.getCmp('CUSTOM2').setReadOnly(true);
			}
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 
			return masterForm.setAllFieldsReadOnly(true);
		}
	});
};
</script>