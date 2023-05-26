<%--
'   프로그램명 : 수주현황조회 (영업)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr820skrv_kodi"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmr820skrv_kodi"/>		<!-- 사업장 -->
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
			{name: 'SO_NUM'			    ,text:'<t:message code="system.label.product.sono" default="수주번호"/>'						,type:'string'},
			{name: 'SO_SEQ'			    ,text:'<t:message code="system.label.product.soseq" default="수주순번"/>'						,type:'integer'},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.product.item" default="품목"/>'								,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.product.itemname" default="품목명"/>'							,type:'string'},
			{name: 'ORDER_Q'			,text:'<t:message code="system.label.product.soqty" default="수주량"/>'						,type:'uniQty'},
			{name: 'MAN_HOUR_A'		    ,text:'제조투입공수'								,type:'uniQty'},
			{name: 'MAN_HOUR_B'		    ,text:'성형투입공수'					,type:'uniQty'},
			{name: 'MAN_HOUR_C'		    ,text:'포장투입공수'					,type:'uniQty'},
			{name: 'MAN_HOUR_TOT'		,text:'총 투입공수'				,type:'uniQty'}

			]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_pmr820skrv_kodiMasterStore', {
		model	: 'Sof100skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼,상태바 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 's_pmr820skrv_kodiService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
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
			}),{
				fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
				xtype: 'uniTextfield',
				name: 'SO_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SO_NUM', newValue);
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
			}),{
			fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
			xtype: 'uniTextfield',
			name: 'SO_NUM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SO_NUM', newValue);
				}
			}
		}]
	});


	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_pmr820skrv_kodiGrid', {
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
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: false
		}],
		columns: [
			{dataIndex: 'SO_NUM'			, width: 150},
			{dataIndex: 'SO_SEQ'		    , width: 80,  align: 'center'},
			{dataIndex: 'ITEM_CODE'			, width: 150},
			{dataIndex: 'ITEM_NAME'			, width: 250},
			{dataIndex: 'ORDER_Q'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'MAN_HOUR_A'		, width: 120, summaryType: 'sum'},
			{dataIndex: 'MAN_HOUR_B'		, width: 120, summaryType: 'sum'},
			{dataIndex: 'MAN_HOUR_C'		, width: 120, summaryType: 'sum'},
			{dataIndex: 'MAN_HOUR_TOT'		, width: 120, summaryType: 'sum'}

		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
			/*	if(selection && selection.startCell) {
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
		id			: 's_pmr820skrv_kodiApp',
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