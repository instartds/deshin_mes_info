<%--
'   프로그램명 : 일일제품생산현황조회
'
'   작  성  자 :
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr320skrv_kodi"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmr320skrv_kodi"/>		<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}

	Unilite.defineModel('Sof100skrvModel', {
		fields: [
			{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.product.custom" default="거래처"/>'					,type:'string'},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.product.customname" default="거래처명"/>'				,type:'string'},
			{name: 'ORDER_NUM'			,text:'<t:message code="system.label.product.sono" default="수주번호"/>'					,type:'string'},
			{name: 'SER_NO'			    ,text:'<t:message code="system.label.product.seq" default="순번"/>'						,type:'integer'},
			{name: 'WEEK_NUM'			,text:'<t:message code="system.label.product.planweeknum" default="계획주차"/>'				,type:'string'},
			{name: 'ORDER_Q'			,text:'<t:message code="system.label.product.soqty" default="수주량"/>'					,type:'uniQty'},
			{name: 'ORDER_REM_Q'		,text:'<t:message code="system.label.product.undeliveryqty" default="미납량"/>'			,type:'uniQty'},
			{name: 'WK_PLAN_Q'			,text:'<t:message code="system.label.product.productionplanquantity" default="생산계획량"/>'	,type:'uniQty'},
			{name: 'WKORD_Q'			,text:'<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'},
			{name: 'INIT_DVRY_DATE'		,text:'<t:message code="system.label.product.deliverydate" default="납기일"/>'				,type:'uniDate',convert:dateToString},
			{name: 'DVRY_DATE'			,text:'<t:message code="system.label.sales.changeddeliverydate" default="납기변경일"/>'		,type:'uniDate',convert:dateToString},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.product.item" default="품목"/>'						,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.product.itemname" default="품목명"/>'					,type:'string'},
			{name: 'INOUT_DATE'			,text:'<t:message code="system.label.sales.deliverydate2" default="납품일"/>'				,type:'uniDate',convert:dateToString},
			{name: 'WK_PLAN_NUM'		,text:'<t:message code="system.label.product.productionplanno" default="생산계획번호"/>'		,type:'string'},
			{name: 'WKORD_NUM'			,text:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'PRODT_NUM'			,text:'<t:message code="system.label.product.productionresultno" default="생산실적번호"/>'	,type:'string'},
			{name: 'PRODT_DATE'		    ,text:'<t:message code="system.label.product.productiondate" default="생산일"/>'			,type:'uniDate',convert:dateToString},
			{name: 'WORK_Q'			    ,text:'<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty'},
			{name: 'GOOD_WORK_Q'		,text:'<t:message code="system.label.product.goodoutputqty" default="양품생산량"/>'			,type:'uniQty'},
			{name: 'BAD_WORK_Q'			,text:'<t:message code="system.label.product.defect" default="불량"/>'					,type:'uniQty'},
			{name: 'IN_STOCK_Q'			,text:'<t:message code="system.label.product.receiptqty" default="입고량"/>'				,type:'uniQty'},
			{name: 'SAVING_Q'			,text:'<t:message code="system.label.product.savingqty" default="관리품"/>'				,type:'uniQty'},
			{name: 'BOX_TRNS_RATE'		,text:'<t:message code="system.label.product.boxinguniqty" default="포장단위수량"/>'			,type:'uniQty'},
			{name: 'BOX_Q'			    ,text:'<t:message code="system.label.product.boxqty" default="포장박스"/>'					,type:'uniQty'},
			{name: 'PIECE'			    ,text:'<t:message code="system.label.product.piece" default="낱개"/>'						,type:'uniQty'},
			{name: 'LOT_NO'			    ,text:'<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type:'string'},
			{name: 'REMARK'			    ,text:'<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'PRODT_DATE_A'		,text:'<t:message code="system.label.inventory.mfgdate" default="제조일"/>'				,type:'uniDate',convert:dateToString},
			{name: 'PRODT_DATE_B'		,text:'<t:message code="system.label.product.chargingdate" default="충전일"/>'				,type:'uniDate',convert:dateToString},
			{name: 'PRODT_DATE_C'		,text:'<t:message code="system.label.sales.packdate" default="포장일"/>'					,type:'uniDate',convert:dateToString},
			{name: 'EXPIRATION_DATE'	,text:'<t:message code="system.label.inventory.expirationdateII" default="사용기한"/>'		,type:'uniDate',convert:dateToString},
			{name: 'ITEM_ACCOUNT'		,text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>'				,type:'string' ,comboType: 'AU'	,comboCode: 'B020'}


			]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_pmr320skrv_kodiMasterStore', {
		model	: 'Sof100skrvModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼,상태바 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 's_pmr320skrv_kodiService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			param.INSPEC_ITEM = Ext.getCmp('rdoSelect1').getChecked()[0].inputValue;
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			this.load({
				params: param
			});
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				}
			}
		}
//		groupField: 'ITEM_CODE'
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.productionresultdate" default="생산실적일"/>',
				startFieldName: 'PRODT_DATE_FR',
				endFieldName: 'PRODT_DATE_TO',
				xtype: 'uniDateRangefield',
				allowBlank: false,
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_DATE_TO',newValue);

					}
				}
			},
				 Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				autoPopup:false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
				Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE':['1','3']},
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':['1','3']});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
				xtype: 'uniTextfield',
				name: 'SO_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SO_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				xtype: 'uniTextfield',
				name: 'WKORD_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_NUM', newValue);
					}
				}
			},{
				xtype: 'checkbox',
				name: 'REMARK_YN',
				inputValue :'Y',
				checked:true,
				fieldLabel:'<t:message code="system.label.product.remarkrendering" default="비고표현"/>',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REMARK_YN', newValue);

						if(newValue == false){
							masterGrid.getColumn('REMARK').setVisible(false);
						}else{
							masterGrid.getColumn('REMARK').setVisible(true);
						}
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '검사품목',
				id			: 'rdoSelect1',
				items		: [{
					boxLabel	: '반제품',
					name		: 'INSPEC_ITEM',
					width		: 80,
					inputValue	: '1'
				},{
					boxLabel	: '제품',
					name		: 'INSPEC_ITEM',
					width		: 70,
					inputValue	: '2',
					checked		: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('INSPEC_ITEM').setValue(newValue.INSPEC_ITEM);
						masterGrid.reset();
						directMasterStore.clearData();

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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE',newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.productionresultdate" default="생산실적일"/>',
				startFieldName: 'PRODT_DATE_FR',
				endFieldName: 'PRODT_DATE_TO',
				xtype: 'uniDateRangefield',
				allowBlank: false,
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('PRODT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('PRODT_DATE_TO',newValue);

					}
				}
			},{
			fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
			xtype: 'uniTextfield',
			name: 'SO_NUM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SO_NUM', newValue);
				}
			}
		},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>',
				extParam: {'CUSTOM_TYPE':'3'},
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				autoPopup: true,
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':'3'});
					}
				}
			}),{
			fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			xtype: 'uniTextfield',
			name: 'WKORD_NUM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WKORD_NUM', newValue);
				}
			}
		},{
				xtype: 'checkbox',
				name: 'REMARK_YN',
				inputValue :'Y',
				checked:true,
				fieldLabel:'<t:message code="system.label.product.remarkrendering" default="비고표현"/>',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('REMARK_YN', newValue);

						if(newValue == false){
							masterGrid.getColumn('REMARK').setVisible(false);
						}else{
							masterGrid.getColumn('REMARK').setVisible(true);
						}
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '검사품목',
				id			: 'rdoSelect2',
				items		: [{
					boxLabel	: '반제품',
					name		: 'INSPEC_ITEM',
					width		: 80,
					inputValue	: '1'
				},{
					boxLabel	: '제품',
					name		: 'INSPEC_ITEM',
					width		: 70,
					inputValue	: '2',
					checked		: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('INSPEC_ITEM').setValue(newValue.INSPEC_ITEM);
						masterGrid.reset();
						directMasterStore.clearData();

					}
				}
			}]
	});


	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_pmr320skrv_kodiGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel		: true,			//엑셀 다운로드 사용 여부
				exportGroup		: true, 		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'CUSTOM_CODE'			, width: 120},
			{dataIndex: 'CUSTOM_NAME'			, width: 200},
			{dataIndex: 'ORDER_NUM'			, width: 150,  align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'SER_NO'			, width: 80,  align: 'center'},
			{dataIndex: 'WEEK_NUM'			, width: 150,  align: 'center'},
			{dataIndex: 'ORDER_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'ORDER_REM_Q'		, width: 120, summaryType: 'sum'},
			{dataIndex: 'WK_PLAN_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'WKORD_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'INIT_DVRY_DATE'			, width: 120},
			{dataIndex: 'DVRY_DATE'				, width: 100,  align: 'center'},
			{dataIndex: 'ITEM_CODE'				, width: 120},
			{dataIndex: 'ITEM_NAME'				, width: 200},
			{dataIndex: 'INOUT_DATE'			, width: 100,  align: 'center'},
			{dataIndex: 'WK_PLAN_NUM'			, width: 150,  align: 'center'},
			{dataIndex: 'WKORD_NUM'				, width: 150,  align: 'center'},
			{dataIndex: 'PRODT_NUM'				, width: 150,  align: 'center'},
			{dataIndex: 'PRODT_DATE'			, width: 100,  align: 'center'},
			{dataIndex: 'WORK_Q'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'GOOD_WORK_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'BAD_WORK_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'IN_STOCK_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'SAVING_Q'				, width: 120, summaryType: 'sum'},
			{dataIndex: 'BOX_TRNS_RATE'			, width: 120},
			{dataIndex: 'BOX_Q'					, width: 120, summaryType: 'sum'},
			{dataIndex: 'PIECE'					, width: 120, summaryType: 'sum'},
			{dataIndex: 'LOT_NO'				, width: 100},
			{dataIndex: 'REMARK'				, width: 200, hidden: false},
			{dataIndex: 'PRODT_DATE_A'			, width: 100,  align: 'center'},
			{dataIndex: 'PRODT_DATE_B'			, width: 100,  align: 'center'},
			{dataIndex: 'PRODT_DATE_C'			, width: 100,  align: 'center'},
			{dataIndex: 'EXPIRATION_DATE'		, width: 100,  align: 'center'},
			{dataIndex: 'ITEM_ACCOUNT'			, width: 120,  align: 'center'}

		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				/*if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;
						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummary').setValue(sum);
					} else {
						this.down('#selectionSummary').setValue(0);
					}
				}*/
			},
			afterrender: function(grid) {
			}
		}
	});


	Unilite.Main({
		id			: 's_pmr320skrv_kodiApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PRODT_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('PRODT_DATE_TO')));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('PRODT_DATE_TO')));

			panelSearch.setValue('INSPEC_ITEM','2');
			panelResult.setValue('INSPEC_ITEM','2');


		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();

		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		}
	});
};
</script>