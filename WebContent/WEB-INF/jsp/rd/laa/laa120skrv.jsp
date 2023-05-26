<%--
'	프로그램명 : 연구소처방등록 (코디)
'
'	작  성  자 : 시너지시스템즈(주) 개발실
'	작  성  일 :
'
'	최종수정자 : 연구소전용 성분비관련 처방(내용물) 등록용으로 개발
'	최종수정일 :
'
'	버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="laa120skrv">
	<t:ExtComboStore comboType="AU" comboCode="B001" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /><!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
	<t:ExtComboStore items="${regulation}" storeId="regulation" />
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>	
</t:appConfig>

<script type="text/javascript" >

var SearchInfoWindow;					// SearchInfoWindow : 검색창
var activeTabId = 'laa120skrvGrid1';	// 활성화된 탭에 따라 조회쿼리 분개하기 위해 선언
function appMain(){
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('laa120skrvMaterModel',{
		fields: [
			{name: 'COMP_CODE'			,text: '법인코드'		,type: 'string'},		//법인코드'
			{name: 'ITEM_CODE'			,text: '원료코드'		,type: 'string'},		//원료코드'
			{name: 'ITEM_NAME'			,text: '원료명'		,type: 'string'},		//원료명'
			{name: 'MATERIAL_CONTENT'	,text: '원료함량'		,type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},	//원료함량'
			{name: 'CHEMICAL_CODE'		,text: '성분코드'		,type: 'string'},		//성분코드'
			{name: 'CHEMICAL_NAME'		,text: '한글명'		,type: 'string'},		//성분명_한글'
			{name: 'CHEMICAL_NAME_EN'	,text: '영문명'		,type: 'string'},		//성분명_영문'
			{name: 'CHEMICAL_NAME_CH'	,text: '중문명'		,type: 'string'},		//성분명_중문'
			{name: 'CHEMICAL_NAME_JP'	,text: '일문명'		,type: 'string'},		//성분명_일문'
			{name: 'ACTUAL_CONTENT'		,text: '실제함량'		,type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},	//실제함량'
			{name: 'UNIT_RATE'			,text: '구성성분비(%)'	,type: 'float' , decimalPrecision: 1 , format:'0,000.0'},		//UNIT_RATE'
			{name: 'CAS_NO'				,text: 'CAS NO'		,type: 'string'},		//CAS NO'
			{name: 'FUNCTION_DESC'		,text: 'Function'	,type: 'string'},		//기능'
			{name: 'CONTROL_CH'			,text: '중국규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_중국'
			{name: 'CONTROL_JP'			,text: '일본규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_일본'
			{name: 'CONTROL_USA'		,text: '미국규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_미국'
			{name: 'CONTROL_ETC1'		,text: '기타1규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_기타1'
			{name: 'CONTROL_ETC2'		,text: '기타2규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_기타2'
			{name: 'CONTROL_ETC3'		,text: '기타3규제'		,type: 'string'},		//규제_기타3'
			{name: 'CONTROL_ETC4'		,text: '기타4규제'		,type: 'string'},		//규제_기타4'
			{name: 'CONTROL_ETC5'		,text: '기타5규제'		,type: 'string'},		//규제_기타5'
			{name: 'REMARK'				,text: '비고'			,type: 'string'}		//비고'
		]
	});


	/** directMasterStore 정의
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('laa120skrvMasterStore',{
		model	: 'laa120skrvMaterModel',
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'laa120skrvService.selectList'
			}
		},
		uniOpt	:{
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용 
		},
		// 검색 조건을 통해 DB에서 데이타 읽어 오기 
		loadStoreRecords : function() {
			var param= Ext.getCmp('resultForm').getValues();
			param.DIV_CODE = UserInfo.divCode;
			console.log( param );
			this.load({
				params : param
			});
		},
 		groupField: 'ITEM_CODE',
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
//					var fields = panelResult.getForm().getFields();
//					Ext.each(fields.items, function(item) {
//						item.setReadOnly(true);
//					});
				}
			}
		}
	});
	
	var directMasterStore2 = Unilite.createStore('laa120skrvMasterStore2',{
		model	: 'laa120skrvMaterModel',
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'laa120skrvService.selectList2'
			}
		},
		uniOpt	:{
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용 
		},
		// 검색 조건을 통해 DB에서 데이타 읽어 오기 
		loadStoreRecords : function() {
			var param= Ext.getCmp('resultForm').getValues();
			param.DIV_CODE = UserInfo.divCode;
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
//					var fields = panelResult.getForm().getFields();
//					Ext.each(fields.items, function(item) {
//						item.setReadOnly(true);
//					});
				}
			}
		}
	});


	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title		: '기본정보',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [
				//내용물(반제품)
				Unilite.popup('BOM_COPY',{ 
					fieldLabel		: '내용물', 
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					allowBlank		: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('ITEM_CODE', records[0].PROD_ITEM_CODE);
								panelSearch.setValue('ITEM_NAME', records[0].ITEM_NAME);
								
								panelResult.setValue('ITEM_CODE', records[0].PROD_ITEM_CODE);
								panelResult.setValue('ITEM_NAME', records[0].ITEM_NAME);
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
							
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.pageTitle = '<t:message code="system.label.base.refprescription" default="처방참조"/>';
							popup.setExtParam({
								'title'			: '<t:message code="system.label.base.refprescription" default="처방참조"/>',
								'pageTitle'		: '<t:message code="system.label.base.refprescription" default="처방참조"/>',
								'DIV_CODE'		: UserInfo.divCode,
								'PROD_ITEM_CODE': panelResult.getValue('ITEM_CODE'),
								'TABLE_NAME'	: 'BPR580T',
								'PROD_ITEM_YN'	: 'Y'
							});
						}
					}
				})
			]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable' , columns: 3 },
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [
			//내용물(반제품)
			Unilite.popup('BOM_COPY',{ 
				fieldLabel		: '내용물', 
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				textFieldWidth	: 300,
				allowBlank		: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('ITEM_CODE', records[0].PROD_ITEM_CODE);
							panelSearch.setValue('ITEM_NAME', records[0].ITEM_NAME);
							
							panelResult.setValue('ITEM_CODE', records[0].PROD_ITEM_CODE);
							panelResult.setValue('ITEM_NAME', records[0].ITEM_NAME);
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
						
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.pageTitle = '<t:message code="system.label.base.refprescription" default="처방참조"/>';
						popup.setExtParam({
							'title'			: '<t:message code="system.label.base.refprescription" default="처방참조"/>',
							'pageTitle'		: '<t:message code="system.label.base.refprescription" default="처방참조"/>',
							'DIV_CODE'		: UserInfo.divCode,
							'PROD_ITEM_CODE': panelResult.getValue('ITEM_CODE'),
							'TABLE_NAME'	: 'BPR580T',
							'PROD_ITEM_YN'	: 'Y'
						});
					}
				}
		})]
	});


	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	: {
			useRowNumberer: true
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex:'COMP_CODE'			, width:105 , hidden: true},
			{dataIndex:'ITEM_CODE'			, width:100},
			{dataIndex:'ITEM_NAME'			, width:200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
				}
			},
			{dataIndex:'MATERIAL_CONTENT'	, width:130/* , summaryType: 'sum'*/},
			{dataIndex:'CHEMICAL_CODE'		, width:100},
			{dataIndex:'CHEMICAL_NAME_EN'	, width:200},
			{dataIndex:'CHEMICAL_NAME'		, width:200},
			{dataIndex:'CHEMICAL_NAME_CH'	, width:200, hidden: true},
			{dataIndex:'CHEMICAL_NAME_JP'	, width:200, hidden: true},
			{dataIndex:'UNIT_RATE'			, width:110 },
			{dataIndex:'ACTUAL_CONTENT'		, width:130 , summaryType: 'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">' + Ext.util.Format.number(value,'0,000.000000')+'</div>', '<div align="right">' + Ext.util.Format.number(value,'0,000.000000')+'</div>');
				}
			},
			{dataIndex:'CAS_NO'				, width:100},
			{dataIndex:'FUNCTION_DESC'		, width:100},
			{dataIndex:'CHEMICAL_NAME_CH'	, width:200, hidden: true},
			{dataIndex:'CHEMICAL_NAME_JP'	, width:200, hidden: true},
			{dataIndex:'CONTROL_CH'			, width:100, hidden: true},
			{dataIndex:'CONTROL_JP'			, width:100, hidden: true},
			{dataIndex:'CONTROL_USA'		, width:100, hidden: true},
			{dataIndex:'CONTROL_ETC1'		, width:100, hidden: true},
			{dataIndex:'CONTROL_ETC2'		, width:100, hidden: true},
			{dataIndex:'CONTROL_ETC3'		, width:100, hidden: true},
			{dataIndex:'CONTROL_ETC4'		, width:100, hidden: true},
			{dataIndex:'CONTROL_ETC5'		, width:100, hidden: true},
			{dataIndex:'REMARK'				, width:200}
		],
		listeners: {
		}
	});

	var masterGrid2 = Unilite.createGrid('masterGrid2', {
		store	: directMasterStore2,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	: {
			useRowNumberer: true
		},
		features: [ {id : 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal1'	, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex:'COMP_CODE'			, width:105 , hidden: true},
//			{dataIndex:'ITEM_CODE'			, width:100},
//			{dataIndex:'ITEM_NAME'			, width:200},
//			{dataIndex:'MATERIAL_CONTENT'	, width:130 , summaryType: 'sum'},
			{dataIndex:'CHEMICAL_CODE'		, width:100},
			{dataIndex:'CHEMICAL_NAME_EN'	, width:200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
				}
			},
			{dataIndex:'CHEMICAL_NAME'		, width:200},
//			{dataIndex:'UNIT_RATE'			, width:110},
			{dataIndex:'ACTUAL_CONTENT'		, width:130 , summaryType: 'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<div align="right">' + Ext.util.Format.number(value,'0,000.000000')+'</div>');
				}
			},
			{dataIndex:'CAS_NO'				, width:100},
			{dataIndex:'FUNCTION_DESC'		, width:100}
//			{dataIndex:'CHEMICAL_NAME_CH'	, width:200},
//			{dataIndex:'CHEMICAL_NAME_JP'	, width:200},
//			{dataIndex:'CONTROL_CH'			, width:100},
//			{dataIndex:'CONTROL_JP'			, width:100},
//			{dataIndex:'CONTROL_USA'		, width:100},
//			{dataIndex:'CONTROL_ETC1'		, width:100},
//			{dataIndex:'CONTROL_ETC2'		, width:100},
//			{dataIndex:'CONTROL_ETC3'		, width:100},
//			{dataIndex:'CONTROL_ETC4'		, width:100},
//			{dataIndex:'CONTROL_ETC5'		, width:100},
//			{dataIndex:'REMARK'				, width:100}
		],
		listeners: {
		}
	});

	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		items		: [{
			title	: '복합성분비',
			xtype	: 'container',
			id		: 'laa120skrvGrid1',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid]
		},{
			title	: '단일성분비',
			xtype	: 'container',
			id		: 'laa120skrvGrid2',
			layout	: {type:'vbox', align:'stretch'},
			items	: [masterGrid2]
		}],
		listeners	: {
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts ) {
				activeTabId = tab.getActiveTab().getId();
			}
		}
	});



	Unilite.Main({
		id			: 'laa120skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [tab, panelResult]
		},
		panelSearch
		],
		fnInitBinding : function() {
			//초기화 시 내용물로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ITEM_CODE');
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			if(activeTabId == 'laa120skrvGrid1') {
				directMasterStore.loadStoreRecords();
			} else {
				directMasterStore2.loadStoreRecords();
			}
		},
		onResetButtonDown:function() {
			activeTabId = 'laa120skrvGrid1';
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			tab.setActiveTab(Ext.getCmp('laa120skrvGrid1'));
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		}
	});
};
</script>