<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="aiss300skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!--상각완료여부-->
	<t:ExtComboStore comboType="AU" comboCode="A042" /> <!--자산구분-->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!--분할여부-->
	<t:ExtComboStore comboType="AU" comboCode="A044" /> <!--자산상태-->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >
var getChargeCode = '${getChargeCode}';

//국고보조금사용여부
var gsGovGrandCont = '${gsGovGrandCont}'

var useGovGrantCont = false;
if(gsGovGrandCont == "1"){
	useGovGrantCont = true;
}

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Aiss300skrvModel', {
		fields: [
			{name: 'COMP_CODE'			,text: 'COMP_CODE'	,type: 'string'},
			{name: 'ASST_DIVI'			,text: '자산구분'		,type: 'string',comboType:'AU', comboCode:'A042'},
			{name: 'ACCNT'				,text: 'ACCNT'		,type: 'string'},
			{name: 'ACCNT_NAME'			,text: '계정과목'		,type: 'string'},
			{name: 'ASST'				,text: '자산코드'		,type: 'string'},
			{name: 'ASST_NAME'			,text: '자산명'		,type: 'string'},
			{name: 'SPEC'				,text: '규격'			,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장'		,type: 'string',comboType:'BOR120'},
			{name: 'DEPT_CODE'			,text: 'DEPT_CODE'	,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서'			,type: 'string'},
			{name: 'PJT_CODE'			,text: 'PJT_CODE'	,type: 'string'},
			{name: 'PJT_NAME'			,text: '사업명'		,type: 'string'},
			{name: 'ACQ_Q'				,text: '취득수량'		,type: 'int'},
			{name: 'STOCK_Q'			,text: '재고수량'		,type: 'int'},
			{name: 'DRB_YEAR'			,text: '내용년수'		,type: 'string'},
			{name: 'ACQ_DATE'			,text: '취득일'		,type: 'uniDate'},
			{name: 'FOR_ACQ_AMT_I'		,text: '외화취득가액'		,type: 'uniFC'},
			{name: 'ACQ_AMT_I'			,text: '취득가액'		,type: 'uniPrice'},
			{name: 'FI_REVAL_TOT_I'		,text: '재평가액'		,type: 'uniPrice'},
			{name: 'FI_DPR_TOT_I'		,text: '상각누계액'		,type: 'uniPrice'},
			{name: 'FL_BALN_I'			,text: '미상각잔액'		,type: 'uniPrice'},
			{name: 'DPR_STS2'			,text: '상각여부'		,type: 'string',comboType:'AU', comboCode:'A035'},
			{name: 'DPR_YYYYMM'			,text: '상각년월'		,type: 'string'},
			{name: 'WASTE_SW'			,text: '매각폐기여부'		,type: 'string',comboType:'AU', comboCode:'A035'},
			{name: 'WASTE_YYYYMM'		,text: '매각페기년월'		,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사번'			,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'			,type: 'string'},
			{name: 'ASST_STS'			,text: '자산상태'		,type: 'string',comboType:'AU', comboCode:'A044'},
			{name: 'PLACE_INFO'			,text: '위치정보'		,type: 'string'},
			{name: 'PAT_YN'				,text: '분할여부'		,type: 'string',comboType:'AU', comboCode:'A020'},
			{name: 'SALE_MANAGE_COST'	,text: '판매비용'		,type: 'uniPrice'},
			{name: 'PRODUCE_COST'		,text: '제조원가'		,type: 'uniPrice'},
			{name: 'SALE_COST'			,text: '영업외비용'		,type: 'uniPrice'},
			{name: 'FI_CAPI_TOT_I'		,text: '증가액'		,type: 'uniPrice'},
			{name: 'FI_SALE_TOT_I'		,text: '감소액'		,type: 'uniPrice'},
			{name: 'GOV_GRANT_ACCNT'			,text: '국고보조금 <br/>계정코드'		,type: 'string'},
			{name: 'GOV_GRANT_ACCNT_NAME'		,text: '국고보조금 <br/>계정명'		,type: 'string'},
			{name: 'GOV_GRANT_AMT_I'			,text: '국고보조금'				,type: 'uniPrice'},
			{name: 'GOV_GRANT_DPR_TOT_I'		,text: '국고보조금 <br/>누적차감액'	,type: 'uniPrice'},
			{name: 'YRDPRI_GOV_DPR_TOT_I'		,text: '상각누계 <br/>-국고차감누계'	,type: 'uniPrice'},
			{name: 'GOV_GRANT_BALN_I'			,text: '국고보조금 <br/>미차감잔액'	,type: 'uniPrice'},
			{name: 'BALNDPRI_GOV_BALN_I'		,text: '미상각잔액 <br/>-국고미차감잔액'	,type: 'uniPrice'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('aiss300skrvMasterStore1',{
		model: 'Aiss300skrvModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable:false,		// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'aiss300skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ACCNT_NAME',
		listeners: {
			load: function(store, records, successful, eOpts) {
//				var viewNormal = masterGrid.normalGrid.getView();
//				var viewLocked = masterGrid.lockedGrid.getView();
//				if(store.getCount() > 0){
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//				}else{
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
//					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
//				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
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
		defaults : {enforceMaxLength: true},
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
			items : [
			Unilite.popup('ASSET', {
				fieldLabel: '자산코드', 
				valueFieldName: 'ASSET_CODE',
				textFieldName: 'ASSET_NAME',
//				textFieldWidth:170, 
				autoPopup : true,
				popupWidth: 710,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_NAME', newValue);
					}
				}
			}),
			Unilite.popup('ASSET',{
				fieldLabel: '~', 
				valueFieldName: 'ASSET_CODE2',
				textFieldName: 'ASSET_NAME2',
				popupWidth: 710,
				autoPopup : true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_CODE2', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_NAME2', newValue);
					}
				}
			}),
			{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true,
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '자산구분',
				name:'ASST_DIVI',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A042',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('ASST_DIVI', newValue);
					}
				}
			}/*,{
				xtype: 'button',
				text: '출력',
				width: 100,
				margin: '0 0 0 120',
				handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
				}
			}*/]
		},{
			title: '추가정보',
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [
			Unilite.popup('ACCNT', {
				fieldLabel: '계정과목', 
				valueFieldName: 'ACCNT_CODE',
				textFieldName: 'ACCNT_NAME',
				listeners: {
					'applyextparam': function(popup){
						popup.setExtParam({
							'CHARGE_CODE': getChargeCode,
							'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y'"
						});
					}
				}
			}),
			Unilite.popup('ACCNT',{
				fieldLabel: '~',
				valueFieldName: 'ACCNT_CODE2',
				textFieldName: 'ACCNT_NAME2',
				listeners: {
					'applyextparam': function(popup){
						popup.setExtParam({
							'CHARGE_CODE': getChargeCode,
							'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y'"
						});
					}
				}
			}),
			{
				fieldLabel: '상각완료여부',
				name:'DPR_STS2',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A035'
			},
			Unilite.popup('DEPT', {
				fieldLabel: '부서',
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME'
			}),
			Unilite.popup('DEPT',{
				fieldLabel: '~',
				valueFieldName: 'DEPT_CODE2',
				textFieldName: 'DEPT_NAME2'
			}),
			{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				defaults : {enforceMaxLength: true},
				width:600,
				items :[{
					fieldLabel:'내용년수',
					xtype: 'uniNumberfield',
					name: 'DRB_YEAR_FR',
					maxLength:3,
					width:195
				},{
					xtype:'component',
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'',
					xtype: 'uniNumberfield',
					name: 'DRB_YEAR_TO',
					maxLength:3,
					width:110
				}]
			},
			Unilite.popup('AC_PROJECT', {
				fieldLabel: '사업코드',
				valueFieldName: 'AC_PROJECT_CODE',
				textFieldName: 'AC_PROJECT_NAME',
				popupWidth: 710
			}),
			Unilite.popup('AC_PROJECT',{
				fieldLabel: '~', 
				valueFieldName: 'AC_PROJECT_CODE2',
				textFieldName: 'AC_PROJECT_NAME2',
				popupWidth: 710
			}),
			{
				fieldLabel: '취득일',
				xtype: 'uniDateRangefield',
				startFieldName: 'ACQ_DATE_FR',
				endFieldName: 'ACQ_DATE_TO',
				width: 315
			},{
				fieldLabel:'취득가액',
				xtype: 'uniNumberfield',
				name: 'ACQ_AMT_I_FR'
			},{
				fieldLabel:'~',
				xtype: 'uniNumberfield',
				name: 'ACQ_AMT_I_TO'
			},{
				xtype: 'radiogroup',
				fieldLabel: ' ',
//				id: 'rdoSelect',
				items : [{
					boxLabel: '원화',
					name: 'rdoLocalMoney',
					inputValue: 'Y',
					checked: true,
					width:50
				},{
					boxLabel: '외화',
					name: 'rdoLocalMoney' ,
					inputValue: 'N',
					width:50
				}]
			},
			/*{
				fieldLabel: '사용일',
				xtype: 'uniDateRangefield',
				startFieldName: 'USE_DATE_FR',
				endFieldName: 'USE_DATE_TO',
				width: 315
			},{
				fieldLabel:'외화취득가액', 
				xtype: 'uniNumberfield',
				name: 'FOR_ACQ_AMT_I_FR'
			},{
				fieldLabel:'~', 
				xtype: 'uniNumberfield',
				name: 'FOR_ACQ_AMT_I_TO'
			},*/{
				fieldLabel: '상각완료년월',
				xtype: 'uniDateRangefield',
				startFieldName: 'DPR_YYYYMM_FR',
				endFieldName: 'DPR_YYYYMM_TO',
				width: 315
			},/*{
				xtype: 'radiogroup',
				fieldLabel: '매각/폐기여부',
				id: 'rdoSelect',
				items : [{
					boxLabel: '전체',
					name: 'WASTE_SW',
					inputValue: 'A',
					checked: true,
					width:50
				},{
					boxLabel: '예',
					name: 'WASTE_SW' ,
					inputValue: 'Y',
					width:40
				},{
					boxLabel: '아니오',
					name: 'WASTE_SW',
					inputValue: 'N',
					width:60
				}]
			},*/
			{
				fieldLabel: '매각폐기여부',
				name:'WASTE_SW',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A020'
			},{
				fieldLabel: '매각/폐기년월',
				xtype: 'uniMonthRangefield',
				startFieldName: 'WASTE_YYYYMM_FR',
				endFieldName: 'WASTE_YYYYMM_TO',
				width: 315
			},
			Unilite.popup('Employee', {
				fieldLabel: '사용자',
				valueFieldName: 'FR_PERSON_NUMB',
				textFieldName: 'FR_PERSON_NAME',
				popupWidth: 710
			}),
			Unilite.popup('Employee',{
				fieldLabel: '~',
				valueFieldName: 'TO_PERSON_NUMB',
				textFieldName: 'TO_PERSON_NAME',
				popupWidth: 710
			}),{
				xtype:'uniTextfield',
				fieldLabel:'위치정보',
				name:'PLACE_INFO'
			},{
				xtype: 'checkboxfield',
				fieldLabel: '분할 전 자산',
				boxLabel: '포함',
				inputValue  : 'Y',
				name: 'CHK_PAT_YN'
			}]
		}]		
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2
//			tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:500,
			colspan:2,
			items :[
			Unilite.popup('ASSET', {
				fieldLabel: '자산코드',
				valueFieldName: 'ASSET_CODE',
				textFieldName: 'ASSET_NAME',
				popupWidth: 710,
				autoPopup : true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_NAME', newValue);
					}
				}
			}),
			Unilite.popup('ASSET',{
				fieldLabel: '~',
				valueFieldName: 'ASSET_CODE2',
				textFieldName: 'ASSET_NAME2',
				labelWidth:10,
				popupWidth: 710,
				autoPopup : true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_CODE2', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_NAME2', newValue);
					}
				}
			})]
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			multiSelect: true,
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			width: 325,
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '700'/*, align : 'center'*/},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '자산구분',
			name:'ASST_DIVI',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A042',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('ASST_DIVI', newValue);
				}
			}
		}]
	});	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	
	var masterGrid = Unilite.createGrid('agb240skrGrid1', {
//		layout : 'fit',
		region : 'center',
		store : directMasterStore,
		excelTitle: '자산대장조회',
		uniOpt: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: false,
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
			{dataIndex: 'COMP_CODE'					,  width: 100, hidden:true},
			{dataIndex: 'ASST_DIVI'					,  width: 100},
			{dataIndex: 'ACCNT'						,  width: 100, hidden:true},
			{dataIndex: 'ACCNT_NAME'				,  width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
				}
			},
			{dataIndex: 'GOV_GRANT_ACCNT'			,  width: 100, hidden : true},
			{dataIndex: 'GOV_GRANT_ACCNT_NAME'		,  width: 130, hidden : !useGovGrantCont},
			{dataIndex: 'ASST'						,  width: 120},
			{dataIndex: 'ASST_NAME'					,  width: 150},
			{dataIndex: 'SPEC'						,  width: 100},
			{dataIndex: 'DIV_CODE'					,  width: 100},
			{dataIndex: 'DEPT_CODE'					,  width: 100, hidden:true},
			{dataIndex: 'DEPT_NAME'					,  width: 100},
			{dataIndex: 'PJT_CODE'					,  width: 100, hidden:true},
			{dataIndex: 'PJT_NAME'					,  width: 100},
			{dataIndex: 'ACQ_Q'						,  width: 100 ,summaryType: 'sum'},
			{dataIndex: 'STOCK_Q'					,  width: 100 ,summaryType: 'sum'},
			{dataIndex: 'DRB_YEAR'					,  width: 100},
			{dataIndex: 'ACQ_DATE'					,  width: 100},
			{dataIndex: 'FOR_ACQ_AMT_I'				,  width: 100 ,summaryType: 'sum'},
			{dataIndex: 'ACQ_AMT_I'					,  width: 100 ,summaryType: 'sum'},
			{dataIndex: 'GOV_GRANT_AMT_I'			,  width: 100 ,summaryType: 'sum', hidden : !useGovGrantCont},
			{dataIndex: 'FI_CAPI_TOT_I'				,  width: 100 ,summaryType: 'sum'},
			{dataIndex: 'FI_SALE_TOT_I'				,  width: 100 ,summaryType: 'sum'},
			{dataIndex: 'FI_REVAL_TOT_I'			,  width: 100 ,summaryType: 'sum'},
			{dataIndex: 'FI_DPR_TOT_I'				,  width: 100 ,summaryType: 'sum'},
			{dataIndex: 'GOV_GRANT_DPR_TOT_I'		,  width: 100 ,summaryType: 'sum', hidden : !useGovGrantCont},
			{dataIndex: 'YRDPRI_GOV_DPR_TOT_I'		,  width: 120 ,summaryType: 'sum', hidden : !useGovGrantCont},
			{dataIndex: 'FL_BALN_I'					,  width: 100 ,summaryType: 'sum'},
			{dataIndex: 'GOV_GRANT_BALN_I'			,  width: 100 ,summaryType: 'sum', hidden : !useGovGrantCont},
			{dataIndex: 'BALNDPRI_GOV_BALN_I'		,  width: 120 ,summaryType: 'sum', hidden : !useGovGrantCont},
			{dataIndex: 'DPR_STS2'					,  width: 100},
			{dataIndex: 'DPR_YYYYMM'				,  width: 100,align:'center'},
			{dataIndex: 'WASTE_SW'					,  width: 100},
			{dataIndex: 'WASTE_YYYYMM'				,  width: 100,align:'center'},
			{dataIndex: 'PERSON_NUMB'				,  width: 100},
			{dataIndex: 'PERSON_NAME'				,  width: 100},
			{dataIndex: 'ASST_STS'					,  width: 80},
			{dataIndex: 'PLACE_INFO'				,  width: 100},
			{dataIndex: 'PAT_YN'					,  width: 100},
			{dataIndex: 'SALE_MANAGE_COST'			,  width: 100},
			{dataIndex: 'PRODUCE_COST'				,  width: 100},
			{dataIndex: 'SALE_COST'					,  width: 100}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				masterGrid.gotoAiss300ukrv(record);
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
			//menu.showAt(event.getXY());
			return true;
		},
		uniRowContextMenu:{
			items: [{
				text	: '자산정보 등록',   
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					masterGrid.gotoAiss300ukrv(param.record);
				}
			}]
		},
		gotoAiss300ukrv:function(record) {
			if(record)	{
				var params = record;
				params.PGM_ID 			= 'aiss300skrv';
				params.ASST 			=	record.get('ASST');
				params.ASST_NAME 		=	record.get('ASST_NAME');
			}
			var rec1 = {data : {prgID : 'aiss300ukrv', 'text':''}};
			parent.openTab(rec1, '/accnt/aiss300ukrv.do', params);
		}
	});
	
	Unilite.Main( {
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
		id  : 'aiss300skrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);
			
//			var viewNormal = masterGrid.normalGrid.getView();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ASSET_CODE');
		},
		onQueryButtonDown : function()	{
			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		}
	});
};

</script>
