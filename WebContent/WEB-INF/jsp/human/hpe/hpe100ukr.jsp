<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="hpe100ukr">
	<t:ExtComboStore comboType="BOR120"  pgmId="hpe100ukr"/> 			<!-- 사업장 -->
</t:appConfig>
<style>
.x-grid-cell-essential {background-color:yellow;}
</style>

<script type="text/javascript" >
var bCloseAllYN = "";

function appMain() {

	/**
	 * Model 정의
	 * @type
	 */
	Unilite.defineModel('hpe100ukrMasterModel', {
		fields: [
			{name: 'CHOICE'					,text:'선택'				,type : 'bool'},
			{name: 'COMP_CODE'				,text:'법인코드'			,type : 'string'},
			{name: 'YEAR_YYYY'				,text:'정산년도'			,type : 'string'},
			{name: 'HALF_YEAR'				,text:'반기구분'			,type : 'string'},
			{name: 'PERSON_NUMB'			,text:'사번'				,type : 'string'},
			{name: 'NAME'					,text:'13.성명'			,type : 'string'},
			{name: 'FORI_YN'				,text:'내외국인구분코드'		,type : 'string'},
			{name: 'FORI_NAME'				,text:'내외국인구분'			,type : 'string'},
			{name: 'REPRE_NUM'				,text:'12.주민(외국인)등록번호'	,type : 'string'},
			{name: 'TAXABLE_INCOME_AMT'		,text:'19.과세소득'			,type : 'uniPrice'},
			{name: 'ETC_INCOME_AMT'			,text:'20.인정상여'			,type : 'uniPrice'},
			{name: 'TOTAL_INCOME_AMT'		,text:'소득합계'				,type : 'uniPrice'},
			{name: 'TELEPHON'				,text:'15.전화번호'			,type : 'string'},
			{name: 'WORKDATE_FR'			,text:'근무시작일'			,type : 'uniDate'},
			{name: 'WORKDATE_TO'			,text:'근무종료일'			,type : 'uniDate'},
			{name: 'LIVE_GUBUN'				,text:'거주구분코드'			,type : 'string'},
			{name: 'LIVE_GUBUN_NAME'		,text:'15.거주구분'			,type : 'string'},
			{name: 'LIVE_CODE'				,text:'거주국가코드'			,type : 'string'},
			{name: 'LIVE_NATION_NAME'		,text:'거주국가'			,type : 'string'}
		]
	});
	
	Unilite.defineModel('hpe100ukrDetailModel', {
		fields: [
			{name: 'COMP_CODE'				,text:'법인코드'		,type : 'string'},
			{name: 'YEAR_YYYY'				,text:'정산년도'		,type : 'string'},
			{name: 'HALF_YEAR'				,text:'반기구분'		,type : 'string'},
			{name: 'PERSON_NUMB'			,text:'사번'			,type : 'string'},
			{name: 'SUMMARY_TYPE'			,text:'집계구분'		,type : 'string'},
			{name: 'INCOME_TYPE'			,text:'구분코드'		,type : 'string'},
			{name: 'INCOME_NAME'			,text:'구분/항목'		,type : 'string'},
			{name: 'TOTAL_AMT'				,text:'계'			,type : 'uniPrice'},
			{name: 'INCOME_AMT_01_07'		,text:'1월'			,type : 'uniPrice'},
			{name: 'INCOME_AMT_02_08'		,text:'2월'			,type : 'uniPrice'},
			{name: 'INCOME_AMT_03_09'		,text:'3월'			,type : 'uniPrice'},
			{name: 'INCOME_AMT_04_10'		,text:'4월'			,type : 'uniPrice'},
			{name: 'INCOME_AMT_05_11'		,text:'5월'			,type : 'uniPrice'},
			{name: 'INCOME_AMT_06_12'		,text:'6월'			,type : 'uniPrice'},
			{name: 'ADJUST_AMT'				,text:'조정금액'		,type : 'uniPrice'}
		]
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
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
			items: [{
				fieldLabel: '정산년도',
				xtype: 'uniYearField',
				name: 'YEAR_YYYY',
				allowBlank:false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('YEAR_YYYY', newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '반기구분',
				id:'rdoHalfYearS',
				holdable: 'hold',
				items: [{
					boxLabel: '상반기',
					width: 70,
					name: 'HALF_YEAR',
					inputValue: '1'
				},{
					boxLabel : '하반기',
					width: 70,
					name: 'HALF_YEAR',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {					
						panelResult.getField('HALF_YEAR').setValue(newValue.HALF_YEAR);
					}
				}
			},{
				fieldLabel: '신고사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DEPT', {
				fieldLabel: '부서',
				popupWidth: 710,
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('Employee', {
				fieldLabel: '사원',
				valueFieldName: 'PERSON_NUMB',
				textFieldName: 'NAME',
				validateBlank: false,
				autoPopup: true,
				allowBlank: true,
				holdable: 'hold',
				listeners: {
					'onSelected': {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB',	records[0].PERSON_NUMB);
							panelResult.setValue('NAME',		records[0].NAME);
						},
						scope: this
					},
					'onClear': function(type) {
						panelResult.setValue('PERSON_NUMB','');
						panelResult.setValue('NAME','');
					},
					applyextparam: function(popup) {
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						popup.setExtParam({'BASE_DT': '00000000'});
					}
				}
			}),{
				xtype: 'radiogroup',
				fieldLabel: '재직구분',
				id:'rdoRetrYnS',
				holdable: 'hold',
				items: [{
					boxLabel: '전체',
					width: 70,
					name: 'RETR_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel: '재직',
					width: 70,
					name: 'RETR_YN',
					inputValue: 'N'
				},{
					boxLabel : '퇴직',
					width: 70,
					name: 'RETR_YN',
					inputValue: 'Y'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {					
						panelResult.getField('RETR_YN').setValue(newValue.RETR_YN);
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
						labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText + Msg.sMB083);
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
							var popupFC = item.up('uniPopupField') ;       
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
						if(item.holdable == 'hold') {
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

	var panelResult = Unilite.createSearchForm('resultForm', {		
		region : 'north',
		layout : {type : 'uniTable', columns : 6},
		padding: '1 1 1 1',
		border : true,
		hidden : !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '정산년도',
			xtype: 'uniYearField',
			name: 'YEAR_YYYY',
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('YEAR_YYYY', newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '반기구분',
			id:'rdoHalfYearR',
			holdable: 'hold',
			items: [{
				boxLabel: '상반기',
				width: 70,
				name: 'HALF_YEAR',
				inputValue: '1'
			},{
				boxLabel : '하반기',
				width: 70,
				name: 'HALF_YEAR',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {					
					panelSearch.getField('HALF_YEAR').setValue(newValue.HALF_YEAR);
				}
			}
		},{
			fieldLabel: '신고사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
	    	xtype: 'component',
	    	text: '',
	    	width: 100
		},{
	    	xtype: 'button',
	    	text: '비과세일괄집계',
	    	width: 120,
	    	handler : function() {
	    		UniAppManager.app.fnGotoHad210ukr();
	    	}
		},{
	    	xtype: 'button',
	    	text: '집계자료가져오기',
	    	width: 120,
	    	margin: '0 0 0 3',
	    	handler : function() {
	    		UniAppManager.app.fnGetSummaryData();
	    	}
		},
		Unilite.popup('DEPT', {
			fieldLabel: '부서',
			popupWidth: 710,
			valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('Employee', {
			fieldLabel: '사원',
			valueFieldName: 'PERSON_NUMB',
			textFieldName: 'NAME',
			validateBlank: false,
			autoPopup: true,
			allowBlank: true,
			holdable: 'hold',
			listeners: {
				'onSelected': {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB',	records[0].PERSON_NUMB);
						panelSearch.setValue('NAME',		records[0].NAME);
					},
					scope: this
				},
				'onClear': function(type) {
					panelSearch.setValue('PERSON_NUMB','');
					panelSearch.setValue('NAME','');
				},
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					popup.setExtParam({'BASE_DT': '00000000'});
				}
			}
		}),{
			xtype: 'radiogroup',
			fieldLabel: '재직구분',
			id:'rdoRetrYnR',
			holdable: 'hold',
			items: [{
				boxLabel: '전체',
				width: 70,
				name: 'RETR_YN',
				inputValue: '',
				checked: true
			},{
				boxLabel: '재직',
				width: 70,
				name: 'RETR_YN',
				inputValue: 'N'
			},{
				boxLabel : '퇴직',
				width: 70,
				name: 'RETR_YN',
				inputValue: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {					
					panelSearch.getField('RETR_YN').setValue(newValue.RETR_YN);
				}
			}
		},{
	    	xtype: 'component',
	    	text: '',
	    	width: 100
		},{
	    	xtype: 'button',
	    	text: '전체마감',
	    	itemId: 'btnCloseAll',
	    	width: 120,
	    	handler : function() {
	    		UniAppManager.app.fnSetCloseAll('Y');
	    	}
		},{
	    	xtype: 'button',
	    	text: '마감취소',
	    	itemId: 'btnCancelAll',
	    	width: 120,
	    	margin: '0 0 0 3',
	    	handler : function() {
	    		UniAppManager.app.fnSetCloseAll('N');
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
						labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText + Msg.sMB083);
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
							var popupFC = item.up('uniPopupField') ;       
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
						if(item.holdable == 'hold') {
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
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('hpe100ukrMasterStore', {
		model: 'hpe100ukrMasterModel',
		uniOpt: {
			isMaster : false,		// 상위 버튼 연결
			editable : true,		// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi  : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'uniDirect',
			api: {
				read   : 'hpe100ukrService.selectList',
				update : 'hpe100ukrService.updateMaster',
				destroy: 'hpe100ukrService.deleteMaster',
				syncAll: 'hpe100ukrService.saveMaster'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster = Ext.getCmp('searchForm').getValues();
			var rv = true;
			
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store) {
				UniAppManager.app.fnGetCloseAll();
				
				if (store.getCount() > 0) {
					if(bCloseAllYN != "Y")
						UniAppManager.setToolbarButtons(['delete', 'deleteAll'], true);
				} else {
					UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'save'], false);
					masterGrid.reset();
					detailGrid.reset();
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				//	commitChanges 함수에서 아래 로직을 타는것을 방지하기 위함.
				if(operation == "commit")
					return;
				
				if(bCloseAllYN != "Y") {
					if(this.isDirty())
						UniAppManager.setToolbarButtons('save', true);
					else
						UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});

	var directDetailStore = Unilite.createStore('hpe100ukrDetailStore', {
		model: 'hpe100ukrDetailModel',
		uniOpt: {
			isMaster : false,		// 상위 버튼 연결
			editable : true,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi  : false,			// prev | newxt 버튼 사용
			lastRecord : null
		},
		autoLoad: false,
		proxy: {
			type: 'uniDirect',
			api: {
				read   : 'hpe100ukrService.selectDetail',
				update : 'hpe100ukrService.updateDetail',
				syncAll: 'hpe100ukrService.saveDetail'
			}
		},
		loadStoreRecords: function(record) {
			var param = {
				COMP_CODE	: record.get('COMP_CODE'),
				YEAR_YYYY	: record.get('YEAR_YYYY'),
				HALF_YEAR	: record.get('HALF_YEAR'),
				PERSON_NUMB	: record.get('PERSON_NUMB')
			};
			this.uniOpt.lastRecord = record;
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster = Ext.getCmp('searchForm').getValues();
			var rv = true;
			
			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directDetailStore.loadStoreRecords(directDetailStore.uniOpt.lastRecord);
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store) {
				if(Ext.getCmp('tabPanel').getActiveTab().id == 'hpe100ukrDetailGridTab')	{
					UniAppManager.setToolbarButtons('delete', false);
					if(panelSearch.getValues().HALF_YEAR == "1")	{
						detailGrid.getColumn("INCOME_AMT_01_07").setText("1월");
						detailGrid.getColumn("INCOME_AMT_02_08").setText("2월");
						detailGrid.getColumn("INCOME_AMT_03_09").setText("3월");
						detailGrid.getColumn("INCOME_AMT_04_10").setText("4월");
						detailGrid.getColumn("INCOME_AMT_05_11").setText("5월");
						detailGrid.getColumn("INCOME_AMT_06_12").setText("6월");
					} else {
						detailGrid.getColumn("INCOME_AMT_01_07").setText("7월");
						detailGrid.getColumn("INCOME_AMT_02_08").setText("8월");
						detailGrid.getColumn("INCOME_AMT_03_09").setText("9월");
						detailGrid.getColumn("INCOME_AMT_04_10").setText("10월");
						detailGrid.getColumn("INCOME_AMT_05_11").setText("11월");
						detailGrid.getColumn("INCOME_AMT_06_12").setText("12월");
					}
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				if(bCloseAllYN != "Y") {
					if(this.isDirty())
						UniAppManager.setToolbarButtons('save', true);
					else
						UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});

	/**
	 * Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('hpe100ukrMasterGrid', {
		layout	: 'fit',
		region	: 'center',
		title	: '지급명세서',
		flex	: 1,
		store	: directMasterStore,
		uniOpt: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			state: {
				useState	: false,
				useStateList: false
			}
		},
		features: [	{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		tbar:[{
	    	text: '연간 근로소득 조회',
	    	handler : function() {
	    		UniAppManager.app.fnGotoHad800skr();
	    	}
		}],
		columns: [
			{dataIndex: 'CHOICE'				, width: 50		, xtype: 'checkcolumn'},
			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'YEAR_YYYY'				, width: 100	, hidden: true},
			{dataIndex: 'HALF_YEAR'				, width: 100	, hidden: true},
			{dataIndex: 'PERSON_NUMB'			, width: 80		, editable: false	, align: 'center'	,
				summaryRenderer: function(value, summaryData, dataIndex, metaData ) 
				{
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'NAME'					, width: 100	, editable: false},
			{dataIndex: 'FORI_YN'				, width: 100	, hidden: true},
			{dataIndex: 'FORI_NAME'				, width: 100	, editable: false	, align: 'center'},
			{dataIndex: 'REPRE_NUM'				, width: 150	, editable: false	, align: 'center'},
			{dataIndex: 'TAXABLE_INCOME_AMT'	, width: 130	, editable: false	, summaryType: 'sum'},
			{dataIndex: 'ETC_INCOME_AMT'		, width: 130	, editable: false	, summaryType: 'sum'},
			{dataIndex: 'TOTAL_INCOME_AMT'		, width: 130	, editable: false	, summaryType: 'sum'},
			{dataIndex: 'TELEPHON'				, width: 120	, editable: false	, align: 'center', hidden:true,
				renderer: function(value, meta, record) {
				 	if(Ext.isEmpty(value)) {
				 		meta.tdCls = 'x-grid-cell-essential';
				 	}
				 	return value;
				}
			},
			{dataIndex: 'WORKDATE_FR'			, width: 100},
			{dataIndex: 'WORKDATE_TO'			, width: 100},
			{dataIndex: 'LIVE_GUBUN'			, width: 100	, hidden: true},
			{dataIndex: 'LIVE_GUBUN_NAME'		, flex : 1		, editable: false	, align: 'center'},
			{dataIndex: 'LIVE_CODE'				, width: 100	, editable: false	, align: 'center', hidden:true},
			{dataIndex: 'LIVE_NATION_NAME'		, width: 150	, editable: false, hidden:true}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(bCloseAllYN == "Y")
					return false;
				
				return true;
			},
			selectionchangerecord : function( record ) {
				if(!Ext.isEmpty(record)) {
					Ext.getCmp('hpe100ukrPersonGrid').selectById(record.id);
				}
			}
		}
	});
	
	var personGrid = Unilite.createGrid('hpe100ukrPersonGrid', {
		layout	: 'fit',
		region	: 'center',
		title	: '사원정보',
		flex	: 1,
		store	: directMasterStore,
		uniOpt: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			state: {
				useState	: false,
				useStateList: false
			}
		},
		columns: [
			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'YEAR_YYYY'				, width: 100	, hidden: true},
			{dataIndex: 'HALF_YEAR'				, width: 100	, hidden: true},
			{dataIndex: 'PERSON_NUMB'			, width: 100	, editable: false	, align: 'center'},
			{dataIndex: 'NAME'					, width: 100	, editable: false}
		],
		listeners: {
			selectionchangerecord : function( record ) {
				if(!Ext.isEmpty(record)) {
					directDetailStore.loadStoreRecords(record);
				}
			}
		}
	});
	
	var detailGrid = Unilite.createGrid('hpe100ukrDetailGrid', {
		layout	: 'fit',
		region	: 'east',
		title	: '소득명세',
		flex	: 4,
		store	: directDetailStore,
		uniOpt: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			state: {
				useState	: false,
				useStateList: false
			}
		},
		columnDefaults: {
			style	: 'text-align:center',
			margin	: '0 0 0 0',
			sortable: false
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				
				if(record.get('INCOME_TYPE') == 'ZZZ2') {
					cls = 'x-change-cell_normal';
				}
				else if(record.get('INCOME_TYPE') == 'ZZZ1') {
					cls = 'x-change-cell_light';
				}
				
				return cls;
			}
		},
		columns: [
			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'YEAR_YYYY'				, width: 100	, hidden: true},
			{dataIndex: 'HALF_YEAR'				, width: 100	, hidden: true},
			{dataIndex: 'PERSON_NUMB'			, width: 100	, hidden: true},
			{dataIndex: 'SUMMARY_TYPE'			, width: 100	, hidden: true},
			{dataIndex: 'INCOME_TYPE'			, width: 100	, hidden: true},
			{dataIndex: 'INCOME_NAME'			, width: 300	, editable: false},
			{dataIndex: 'TOTAL_AMT'				, width: 120	, editable: false},
			{dataIndex: 'INCOME_AMT_01_07'		, width: 120	, editable: false},
			{dataIndex: 'INCOME_AMT_02_08'		, width: 120	, editable: false},
			{dataIndex: 'INCOME_AMT_03_09'		, width: 120	, editable: false},
			{dataIndex: 'INCOME_AMT_04_10'		, width: 120	, editable: false},
			{dataIndex: 'INCOME_AMT_05_11'		, width: 120	, editable: false},
			{dataIndex: 'INCOME_AMT_06_12'		, width: 120	, editable: false},
			{dataIndex: 'ADJUST_AMT'			, width: 120}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				var mRecord = personGrid.getSelectedRecord();
				var summaryType = e.record.get('SUMMARY_TYPE');
				var incomeType = String(e.record.get('INCOME_TYPE')).substring(0, 3);
				
				if(bCloseAllYN == "Y")
					return false;
				
				//if(mRecord.get('CLOSE_TYPE') == '1')
				//	return false;
				
				if(summaryType == '3' || summaryType == '4' || incomeType == 'ZZZ')
					return false;
				
				return true;
			},
			edit : function( editor, e, eOpts ) {	//	validateedit
				Ext.getCmp('hpe100ukrDetailGrid').fnCalcAmt(e.record.get('SUMMARY_TYPE'));
			}
		},
		fnCalcAmt: function(sumType) {
			var mRecord = personGrid.getSelectedRecord();
			var mColumn = '';
			
			var incomeAmtTot = 0;
			var incomeAmt1   = 0;
			var incomeAmt2   = 0;
			var incomeAmt3   = 0;
			var incomeAmt4   = 0;
			var incomeAmt5   = 0;
			var incomeAmt6   = 0;
			var incomeAmtAdj = 0;
			
			if(sumType == '1') {
				mColumn = 'TAXABLE_INCOME_AMT';
			}
			else {
				mColumn = 'NONTAXABLE_INCOME_AMT';
			}
			
			Ext.each(directDetailStore.data.items, function(record, index){
				if(sumType == record.get('SUMMARY_TYPE')) {
					if(String(record.get('INCOME_TYPE')).substring(0, 3) == 'ZZZ') {
						record.set('TOTAL_AMT'			, incomeAmtTot);
						record.set('INCOME_AMT_01_07'	, incomeAmt1  );
						record.set('INCOME_AMT_02_08'	, incomeAmt2  );
						record.set('INCOME_AMT_03_09'	, incomeAmt3  );
						record.set('INCOME_AMT_04_10'	, incomeAmt4  );
						record.set('INCOME_AMT_05_11'	, incomeAmt5  );
						record.set('INCOME_AMT_06_12'	, incomeAmt6  );
						record.set('ADJUST_AMT'			, incomeAmtAdj);
						
						mRecord.set(mColumn			  	,	incomeAmtTot);
						mRecord.set('TOTAL_INCOME_AMT'	,	mRecord.get('TAXABLE_INCOME_AMT')
														  + mRecord.get('NONTAXABLE_INCOME_AMT'));
						
						directMasterStore.commitChanges();
					}
					else {
						record.set('TOTAL_AMT',   record.get('INCOME_AMT_01_07')
												+ record.get('INCOME_AMT_02_08')
												+ record.get('INCOME_AMT_03_09')
												+ record.get('INCOME_AMT_04_10')
												+ record.get('INCOME_AMT_05_11')
												+ record.get('INCOME_AMT_06_12')
												+ record.get('ADJUST_AMT'));
						
						incomeAmtTot += record.get('TOTAL_AMT');
						incomeAmt1   += record.get('INCOME_AMT_01_07');
						incomeAmt2   += record.get('INCOME_AMT_02_08');
						incomeAmt3   += record.get('INCOME_AMT_03_09');
						incomeAmt4   += record.get('INCOME_AMT_04_10');
						incomeAmt5   += record.get('INCOME_AMT_05_11');
						incomeAmt6   += record.get('INCOME_AMT_06_12');
						incomeAmtAdj += record.get('ADJUST_AMT');
					}
				}
				
				if(sumType == '2' && record.get('SUMMARY_TYPE') == '3' && String(record.get('INCOME_TYPE')).substring(0, 3) == 'ZZZ') {
					incomeAmtTot += record.get('TOTAL_AMT');
					incomeAmt1   += record.get('INCOME_AMT_01_07');
					incomeAmt2   += record.get('INCOME_AMT_02_08');
					incomeAmt3   += record.get('INCOME_AMT_03_09');
					incomeAmt4   += record.get('INCOME_AMT_04_10');
					incomeAmt5   += record.get('INCOME_AMT_05_11');
					incomeAmt6   += record.get('INCOME_AMT_06_12');
					incomeAmtAdj += record.get('ADJUST_AMT');
				}
				
				if(sumType == '2' && record.get('SUMMARY_TYPE') == '4') {
					record.set('TOTAL_AMT'			, incomeAmtTot);
					record.set('INCOME_AMT_01_07'	, incomeAmt1  );
					record.set('INCOME_AMT_02_08'	, incomeAmt2  );
					record.set('INCOME_AMT_03_09'	, incomeAmt3  );
					record.set('INCOME_AMT_04_10'	, incomeAmt4  );
					record.set('INCOME_AMT_05_11'	, incomeAmt5  );
					record.set('INCOME_AMT_06_12'	, incomeAmt6  );
					record.set('ADJUST_AMT'			, incomeAmtAdj);
				}
				
			});
		}
	});
	
	var tab = Unilite.createTabPanel('tabPanel', {
		region:'center',
		items: [
			masterGrid,
			{	layout: {type: 'hbox', align: 'stretch'},
				title : '소득명세' ,
				id: 'hpe100ukrDetailGridTab',
				items: [
					personGrid,
					detailGrid
				]
			}
		],
		listeners: {
			beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts ) {
				var oldTabId = oldCard.getId();
				var newTabId = newCard.getId();
				
				if(bCloseAllYN == "Y") {
					UniAppManager.setToolbarButtons(['save', 'delete', 'deleteAll'], false);
					return;
				}
				
				if(oldTabId == 'hpe100ukrMasterGrid' && directMasterStore.isDirty()) {
					if(confirm('저장되지 않은 데이터가 있습니다. 그대로 진행하시겠습니까?'))
						directMasterStore.rejectChanges();
					else
						return false;
				}
				
				if(oldTabId == 'hpe100ukrDetailGridTab' && directDetailStore.isDirty()) {
					if(confirm('저장되지 않은 데이터가 있습니다. 그대로 진행하시겠습니까?'))
						directDetailStore.rejectChanges();
					else
						return false;
				}
				
				switch(newTabId)	{
					case 'hpe100ukrMasterGrid':
						if(directMasterStore.isDirty())
							UniAppManager.setToolbarButtons('save', true);
						else
							UniAppManager.setToolbarButtons('save', false);
						
						if(directMasterStore.getCount() > 0)
							UniAppManager.setToolbarButtons(['delete', 'deleteAll'], true);
						else
							UniAppManager.setToolbarButtons(['delete', 'deleteAll'], false);
						
						if(directMasterStore.getCount() > 0)
							Ext.getCmp('hpe100ukrMasterGrid').selectById(directDetailStore.uniOpt.lastRecord.id);
						
						break;
					
					case 'hpe100ukrDetailGridTab':
						if(directDetailStore.isDirty())
							UniAppManager.setToolbarButtons('save', true);
						else
							UniAppManager.setToolbarButtons('save', false);
						
						UniAppManager.setToolbarButtons(['delete', 'deleteAll'], false);
						
						break;
					
					default:
						break;
				}
			}
		}
	});

	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]},
			panelSearch
		],
		id : 'hpe100ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			var month = Ext.Date.format(UniDate.add(UniDate.today(),{'months':-1} ),'n');
			var halfYear = "1";
			if(month > 6)	{
				halfYear="2";
			}
			panelSearch.getField('HALF_YEAR').setValue(halfYear);
			panelResult.getField('HALF_YEAR').setValue(halfYear);
			
			panelSearch.setValue('YEAR_YYYY', UniDate.add(UniDate.today(),{'months':-1} ).getFullYear());
			panelResult.setValue('YEAR_YYYY', UniDate.add(UniDate.today(),{'months':-1} ).getFullYear());
			
			panelSearch.getField('RETR_YN').setValue('');
			panelResult.getField('RETR_YN').setValue('');
			
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons(['save','delete','deleteAll'],false);
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			
			panelSearch.clearForm();
			panelResult.clearForm();
			
			this.fnInitBinding();
		},
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
			
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			
			if(activeTabId == 'hpe100ukrMasterGrid') {
				var data = directMasterStore.data.items;
				var grid = Ext.getCmp('hpe100ukrMasterGrid');
				
				if(!confirm('선택하신 데이터를 삭제하시겠습니까?')) {
					return;
				}
				
				for(var lIndex = data.length - 1; lIndex >= 0; lIndex--) {
					if(data[lIndex].data.CHOICE) {
						grid.selectById(data[lIndex].id);
						grid.deleteSelectedRow();
					}
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			
			if(activeTabId == 'hpe100ukrMasterGrid') {
				var data = directMasterStore.data.items;
				var grid = Ext.getCmp('hpe100ukrMasterGrid');
				
				if(!confirm('전체삭제 하시겠습니까?')) {
					return;
				}
				
				directMasterStore.removeAll();
				directMasterStore.saveStore();
			}
		},
		onSaveDataButtonDown: function(config) {
			var activeTabId = tab.getActiveTab().getId();
			
			if(activeTabId == 'hpe100ukrMasterGrid') {
				directMasterStore.saveStore();
			}
			else {
				directDetailStore.saveStore();
			}
		},
		fnGetSummaryData : function() {
			var param = panelSearch.getValues();
			hpe100ukrService.fnGetPayAmt(param, function(provider, response) {
				console.log("provider : ", provider);
				if(provider) {
					if(provider.ERROR_DESC == "success") {
						alert("집계자료가져오기 작업이 완료되었습니다.");
					}
					else {
						alert(provider.ERROR_DESC);
					}
				}
			});
		},
		fnGotoHad210ukr : function() {
			var params = {
					'PGM_ID'		: 'hpe100ukr',
					'YEAR_YYYY'		: panelSearch.getValue('YEAR_YYYY')
			}
			//전송
			var rec1 = {data : {prgID : 'had210ukr', 'text':''}};
			parent.openTab(rec1, '/human/had210ukr.do', params);
			
		},
		fnGotoHad800skr : function() {
			var halfYear = panelResult.getValues().HALF_YEAR;
			var payYmFr = '0101';
			var payYmTo = '0630';
			
			if(halfYear == '2') {
				payYmFr = '0701';
				payYmTo = '1231';
			}
			
			var params = {
					'PGM_ID'		: 'hpe100ukr',
					'DIV_CODE'		: panelSearch.getValue('DIV_CODE'),
					'PAY_YYYYMM_FR'	: panelSearch.getValue('YEAR_YYYY') + payYmFr,
					'PAY_YYYYMM_TO'	: panelSearch.getValue('YEAR_YYYY') + payYmTo,
					'DATE_GUBUN'	: '2'	//지급
			}
			//전송
			var rec1 = {data : {prgID : 'had800skr', 'text':''}};
			parent.openTab(rec1, '/human/had800skr.do', params);
			
		},
		fnGetCloseAll : function() {
			var param = panelSearch.getValues();
			
			hpe100ukrService.fnGetCloseAll(param, function(provider, response) {
				console.log("provider : ", provider);
				
				bCloseAllYN = provider.CLOSE_TYPE;
				if(bCloseAllYN == "Y") {
					Ext.getCmp('resultForm').getComponent('btnCloseAll' ).setDisabled(true);
					Ext.getCmp('resultForm').getComponent('btnCancelAll').setDisabled(false);
					
					UniAppManager.setToolbarButtons(['save','delete','deleteAll'],false);
				}
				else {
					Ext.getCmp('resultForm').getComponent('btnCloseAll' ).setDisabled(false);
					Ext.getCmp('resultForm').getComponent('btnCancelAll').setDisabled(true);
					
					if(Ext.getStore('hpe100ukrMasterStore').getCount() > 0)
						UniAppManager.setToolbarButtons(['delete','deleteAll'],true);
				}
			});
		},
		fnSetCloseAll : function(closeType) {
			var param = panelSearch.getValues();
			param.CLOSE_TYPE = closeType;
			
			if(directMasterStore.isDirty() || directDetailStore.isDirty()) {
				if(confirm('저장되지 않은 데이터가 있습니다. 그대로 진행하시겠습니까?')) {
					directMasterStore.rejectChanges();
					directDetailStore.rejectChanges();
				}
				else
					return false;
			}
				
			hpe100ukrService.fnSetCloseAll(param, function(provider, response) {
				console.log("provider : ", provider);
				if(provider){
					if(closeType == 'Y')
						alert("전체마감 작업이 완료되었습니다.");
					else
						alert("마감취소 작업이 완료되었습니다.");
				}
				
				UniAppManager.app.fnGetCloseAll();
			});
		}
	});
}
</script>