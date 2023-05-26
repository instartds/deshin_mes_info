<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="ass600skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!--상각완료여부-->
	<t:ExtComboStore comboType="AU" comboCode="A042" /> <!--자산구분-->
	<t:ExtComboStore comboType="AU" comboCode="A388" /><!--원화외화구분-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var getChargeCode = ${getChargeCode};

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ass600skrModel', {
		fields: [
			{name: 'ASST_DIVI'						,text: '자산구분'			,type: 'string' ,comboType:'AU', comboCode:'A042'},
			{name: 'ACCNT'							,text: '계정'				,type: 'string'},
			{name: 'ACCNT_NAME'						,text: '계정과목'			,type: 'string'},
			{name: 'ASST'							,text: '자산코드'			,type: 'string'},
			{name: 'ASST_NAME'						,text: '자산명'			,type: 'string'},
			{name: 'SPEC'							,text: '규격'				,type: 'string'},
			{name: 'DIV_NAME'						,text: '사업장'			,type: 'string'},
			{name: 'DEPT_NAME'						,text: '부서'				,type: 'string'},
			{name: 'PJT_NAME'						,text: '프로젝트'			,type: 'string'},
			{name: 'ACQ_Q'							,text: '취득수량'			,type: 'uniQty'},
			{name: 'STOCK_Q'						,text: '재고수량'			,type: 'uniQty'},
			{name: 'DRB_YEAR'						,text: '내용년수'			,type: 'string'},
			{name: 'ACQ_DATE'						,text: '취득일'			,type: 'uniDate'},
			{name: 'ACQ_AMT_I'						,text: '취득가액'			,type: 'uniPrice'},
			{name: 'FOR_ACQ_AMT_I'					,text: '외화취득가액'			,type: 'uniFC'},
			{name: 'DPR_STS2'						,text: '상각여부'			,type: 'string'},
			{name: 'DPR_YYYYMM'						,text: '상각년월'			,type: 'uniDate'},
			{name: 'WASTE_SW'						,text: '매각폐기여부'			,type: 'string'},
			{name: 'WASTE_YYYYMM'					,text: '매각폐기년월'			,type: 'uniDate'},
			{name: 'SALE_MANAGE_COST'				,text: '판매비용'			,type: 'uniPrice'},
			{name: 'PRODUCE_COST'					,text: '제조원가'			,type: 'uniPrice'},
			{name: 'SALE_COST'						,text: '영업외비용'			,type: 'uniPrice'},
			{name: 'COST_POOL_NAME'					,text: 'Cost Pool'		,type: 'string'},
			{name: 'COST_DIRECT'					,text: 'Cost Pool 직과'	,type: 'string'},
			{name: 'ITEMLEVEL1_NAME'				,text: '대분류'			,type: 'string'},
			{name: 'ITEMLEVEL2_NAME'				,text: '중분류'			,type: 'string'},
			{name: 'ITEMLEVEL3_NAME'				,text: '소분류'			,type: 'string'},
			{name: 'CUSTOM_NAME'					,text: '구입처'			,type: 'string'},
			{name: 'PERSON_NAME'					,text: '사용자'			,type: 'string'},
			{name: 'PLACE_INFO'						,text: '위치정보'			,type: 'string'},
			{name: 'SERIAL_NO'						,text: '일련번호'			,type: 'string'},
			{name: 'BAR_CODE'						,text: 'Bar Code'		,type: 'string'},
			{name: 'REMARK'							,text: '비고'				,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('ass600skrMasterStore1',{
		model: 'Ass600skrModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'ass600skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ACCNT',
		listeners: {
			load: function(store, records, successful, eOpts) {
				var viewNormal = masterGrid.normalGrid.getView();
				var viewLocked = masterGrid.lockedGrid.getView();
				if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
				}
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
				validateBlank:false,
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
				validateBlank:false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_CODE2', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_NAME2', newValue);
					}
				}
			}),{
				fieldLabel: '자산구분',
				name:'ASST_DIVI',
				xtype: 'uniCombobox',
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'AU',
				comboCode:'A042',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ASST_DIVI', newValue);
					}
				}
			},{
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
				fieldLabel: '상각완료여부',
				name:'DPR_STS2',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A035',
				width: 325,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DPR_STS2', newValue);
					}
				}
			}]
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
				validateBlank:false,
				listeners: {
					applyExtParam:{
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : "SPEC_DIVI IN ('K', 'K2')",
								'CHARGE_CODE': (Ext.isEmpty(getChargeCode) && Ext.isEmpty(getChargeCode[0])) ? '':getChargeCode[0].SUB_CODE
							}
							popup.setExtParam(param);
						}
					}
				}
			}),
			Unilite.popup('ACCNT',{
				fieldLabel: '~',
				valueFieldName: 'ACCNT_CODE2',
				textFieldName: 'ACCNT_NAME2',
				validateBlank: false,
				listeners: {
					applyExtParam:{
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : "SPEC_DIVI IN ('K', 'K2')",
								'CHARGE_CODE': (Ext.isEmpty(getChargeCode) && Ext.isEmpty(getChargeCode[0])) ? '':getChargeCode[0].SUB_CODE
							}
							popup.setExtParam(param);
						}
					}
				}
			}),{
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
			Unilite.popup('DEPT', {
				fieldLabel: '사용부서',
				valueFieldName: 'DEPT_CODE_FR',
				textFieldName: 'DEPT_NAME_FR',
				validateBlank:false
			}),
			Unilite.popup('DEPT',{
				fieldLabel: '~',
				valueFieldName: 'DEPT_CODE_TO',
				textFieldName: 'DEPT_NAME_TO',
				validateBlank: false
			}),
			Unilite.popup('AC_PROJECT', {
				fieldLabel: '프로젝트',
				valueFieldName: 'AC_PROJECT_CODE',
				textFieldName: 'AC_PROJECT_NAME',
				validateBlank:false,
				popupWidth: 710
			}),
			Unilite.popup('AC_PROJECT',{
				fieldLabel: '~',
				valueFieldName: 'AC_PROJECT_CODE2',
				textFieldName: 'AC_PROJECT_NAME2',
				validateBlank: false,
				popupWidth: 710
			}),{
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
				fieldLabel:'외화취득가액',
				xtype: 'uniNumberfield',
				name: 'FOR_ACQ_AMT_I_FR'
			},{
				fieldLabel:'~',
				xtype: 'uniNumberfield',
				name: 'FOR_ACQ_AMT_I_TO'
			},{
				fieldLabel: '사용일',
				xtype: 'uniDateRangefield',
				startFieldName: 'USE_DATE_FR',
				endFieldName: 'USE_DATE_TO',
				width: 315
			},{
				fieldLabel:'', //취득가액 원화/외화구분
				xtype: 'uniRadiogroup',
				name: 'CURRENCY_KIND',
				comboType:'AU',
				comboCode:'A388',
				allowBlank:true
			},{
				fieldLabel: '상각년월',
				xtype: 'uniMonthRangefield',
				startFieldName: 'DPR_YYYYMM_FR',
				endFieldName: 'DPR_YYYYMM_TO',
				width: 315,
				
			},
			Unilite.popup('Employee_ACCNT', {
				fieldLabel: '사용자',
				valueFieldName: 'PERSON_NUMB_FR',
				textFieldName: 'NAME_FR',
				validateBlank:false
			}),
			Unilite.popup('Employee_ACCNT',{
				fieldLabel: '~',
				valueFieldName: 'PERSON_NUMB_TO',
				textFieldName: 'NAME_TO',
				validateBlank: false
			}),{
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
			},{
				fieldLabel: '매각/폐기년월',
				xtype: 'uniMonthRangefield',
				startFieldName: 'WASTE_YYYYMM_FR',
				endFieldName: 'WASTE_YYYYMM_TO',
				width: 315
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:600,
			items :[
			Unilite.popup('ASSET', {
				fieldLabel: '자산코드',
				valueFieldName: 'ASSET_CODE',
				textFieldName: 'ASSET_NAME',
				popupWidth: 710,
				validateBlank:false,
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
				validateBlank:false,
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
			fieldLabel: '자산구분',
			name:'ASST_DIVI',
			xtype: 'uniCombobox',
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'AU',
			comboCode:'A042',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ASST_DIVI', newValue);
				}
			}
		},{
			xtype: 'container',
			html: '&nbsp;'
		},{
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
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '상각완료여부',
			name:'DPR_STS2',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A035',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DPR_STS2', newValue);
				}
			}
		},{
			xtype: 'button',
			text: '출    력',
			width: 120,
			tdAttrs:{style:'padding-left:50px'},
			handler: function() {
				var params = panelSearch.getValues();
				
				var rec1 = {data : {prgID : 'ass600rkr', 'text':''}};
				parent.openTab(rec1, '/accnt/ass600rkr.do', params);
			}
		}]
	});	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb240skrGrid1', {
		region : 'center',
		store : directMasterStore, 
		excelTitle: '고정자산대장조회',
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
			{dataIndex: 'ACCNT'								,  width: 80,hidden:true},
			{dataIndex: 'ASST_DIVI'							,  width: 150,locked:true},
			{dataIndex: 'ACCNT_NAME'						,  width: 100,locked:true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
				}
			},
			{dataIndex: 'ASST'								,  width: 150,locked:true},
			{dataIndex: 'ASST_NAME'							,  width: 200,locked:true},
			{dataIndex: 'SPEC'								,  width: 133},
			{dataIndex: 'DIV_NAME'							,  width: 100},
			{dataIndex: 'DEPT_NAME'							,  width: 100},
			{dataIndex: 'PJT_NAME'							,  width: 100},
			{dataIndex: 'ACQ_Q'								,  width: 88,summaryType: 'sum'},
			{dataIndex: 'STOCK_Q'							,  width: 88,summaryType: 'sum'},
			{dataIndex: 'DRB_YEAR'							,  width: 88,align:'center'},
			{dataIndex: 'ACQ_DATE' 							,  width: 86},
			{dataIndex: 'ACQ_AMT_I'							,  width: 100,summaryType: 'sum'},
			{dataIndex: 'FOR_ACQ_AMT_I'						,  width: 100,summaryType: 'sum'},
			{dataIndex: 'DPR_STS2'							,  width: 86,align:'center'},
			{dataIndex: 'DPR_YYYYMM'						,  width: 86},
			{dataIndex: 'WASTE_SW'							,  width: 86,align:'center'},
			{dataIndex: 'WASTE_YYYYMM'						,  width: 86},
			{dataIndex: 'SALE_MANAGE_COST'					,  width: 73},
			{dataIndex: 'PRODUCE_COST'						,  width: 73},
			{dataIndex: 'SALE_COST'							,  width: 73},
			{dataIndex: 'COST_POOL_NAME'					,  width: 100},
			{dataIndex: 'COST_DIRECT'						,  width: 100},
			{dataIndex: 'ITEMLEVEL1_NAME'					,  width: 100},
			{dataIndex: 'ITEMLEVEL2_NAME'					,  width: 100},
			{dataIndex: 'ITEMLEVEL3_NAME'					,  width: 100},
			{dataIndex: 'CUSTOM_NAME'						,  width: 120},
			{dataIndex: 'PERSON_NAME'						,  width: 66},
			{dataIndex: 'PLACE_INFO'						,  width: 133},
			{dataIndex: 'SERIAL_NO'							,  width: 133},
			{dataIndex: 'BAR_CODE'							,  width: 166},
			{dataIndex: 'REMARK'							,  width: 166}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			celldblclick:function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				var clickedDataIndex = view.panel.headerCt.getHeaderAtIndex(cellIndex).dataIndex;
				if(clickedDataIndex =='ASST')	{
					view.ownerGrid.gotoAss300ukr(record);
				}
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
			menu.showAt(event.getXY());
			return true;
		},
		uniRowContextMenu:{
			items: [
				{	text	: '고정자산 등록',   
					handler	: function(menuItem, event) {
						var param = menuItem.up('menu');
						masterGrid.gotoAss300ukr(param.record);
					}
				}
			]
		},
		gotoAss300ukr:function(record)	{
			if(record)	{
				var params = record;
				params.PGM_ID 			= 'ass600skr';
				params.ASST 			=	record.get('ASST');
				params.ASST_NAME 		=	record.get('ASST_NAME');
			}
			var rec1 = {data : {prgID : 'ass300ukr', 'text':''}};
			parent.openTab(rec1, '/accnt/ass300ukr.do', params);
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
		id  : 'ass600skrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var viewNormal = masterGrid.normalGrid.getView();
			var viewLocked = masterGrid.lockedGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ASSET_CODE');
		},
		onQueryButtonDown : function()	{	
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			UniAppManager.setToolbarButtons('reset',true);
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