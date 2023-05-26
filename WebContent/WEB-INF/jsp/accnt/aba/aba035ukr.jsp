<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba035ukr" >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A093" /> 			<!-- 재무제표양식차수 -->
	<t:ExtComboStore comboType="AU" comboCode="B042"  /> 			<!-- 금액단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A094"  /> 			<!-- 집계구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A001"  /> 			<!-- 잔액 -->
	<t:ExtComboStore comboType="AU" comboCode="B010"  /> 			<!-- 시스템코드 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var gsGubun = '${gsGubun}';	//재무제표 양식차수
function appMain() {
	var gbHideLabel = true;
	var omitListWin;
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aba035ukrModel', {
	   fields: [
	    	{name: 'GUBUN'			, text: '구분'					, type: 'string'},
			{name: 'DIVI'			, text: '구분'					, type: 'string'},
			{name: 'SEQ' 			, text: '순번'					, type: 'string', allowBlank: false, maxLength: 5},
			{name: 'ACCNT_CD'		, text: '항목코드'					, type: 'string', allowBlank: false, maxLength: 16},
			{name: 'ACCNT_NAME'   	, text: '항목명'					, type: 'string', allowBlank: false, maxLength: 50},
			{name: 'START_ACCNT'	, text: '시작계정코드'				, type: 'string', allowBlank: false, maxLength: 16},
			{name: 'END_ACCNT'		, text: '종료계정코드'				, type: 'string', maxLength: 16},
			{name: 'ADD_ACCNT'		, text: '추가계정코드'				, type: 'string', maxLength: 100},
			{name: 'DELETE_ACCNT'	, text: '삭제계정코드'				, type: 'string', maxLength: 100},
			{name: 'OPT_DIVI'		, text: '집계구분'					, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A094'},
			{name: 'RIGHT_LEFT' 	, text: '잔액'					, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A001'},
			{name: 'DIS_DIVI' 		, text: '시스템코드'					, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'B010'},
			{name: 'ACCNT_NAME2' 	, text: '항목명2'					, type: 'string', maxLength: 50},
			{name: 'ACCNT_NAME3' 	, text: '항목명3'					, type: 'string', maxLength: 50},
			{name: 'INSERT_DB_USER'	, text: 'INSERT_DB_USER'		, type: 'string', defaultValue: UserInfo.userID},
			{name: 'INSERT_DB_TIME'	, text: 'INSERT_DB_TIME'		, type: 'string'},
			{name: 'UPDATE_DB_USER'	, text: 'UPDATE_DB_USER'		, type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'	, text: 'UPDATE_DB_TIME'		, type: 'string'},
			{name: 'COMP_CODE'		, text: 'COMP_CODE'				, type: 'string', defaultValue: UserInfo.comCode}
	    ]
	});	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aba035ukrService.selectDetailList',
			update: 'aba035ukrService.updateDetail',
			create: 'aba035ukrService.insertDetail',
			destroy: 'aba035ukrService.deleteDetail',
			syncAll: 'aba035ukrService.saveAll'
		}
	});
	
	var directMasterStore = Unilite.createStore('aba410MasterStore1',{
		model: 'Aba035ukrModel',
		autoLoad: false,
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : true			// prev | next 버튼 사용
		},
		proxy: directProxy 
		,loadStoreRecords : function() {
			var param= panelSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
			aba035ukrService.selectOmitCnt({'GUBUN' : panelSearch.getValue("GUBUN")}, function(provider, result ) {
				var cnt = '0';
				var accnt_nm = '';
				if(provider){
					gbHideLabel	= (Number(provider.OMIT_CNT) == 0 ? true : false);
					
					cnt			= Number(provider.OMIT_CNT) - 1;
					accnt_nm	= provider.ACCNT_NAME + (cnt > 0 ? ' 외 ' + String(cnt) + '건의' : '');
				}
				Ext.getCmp('omission_cnt').setHtml('<a href="javascript:UniAppManager.app.openOmitInfo();" style="color:red">※ ' + accnt_nm + ' 계정이 누락되어있습니다. (클릭)</a>');
				Ext.getCmp('omission_cnt').setHidden(gbHideLabel);
			});
		}
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		,saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				directMasterStore.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
			layout : {type : 'vbox', align : 'stretch'},
			items : [{
				xtype:'container',
				layout : {type : 'uniTable', columns : 1},
				items:[{
					fieldLabel: '재무제표양식차수',
					name: 'GUBUN',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A093',
					allowBlank: false,
					value : '01',
					labelWidth: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('GUBUN', newValue);
						}
					}
				}]	
			}]
		}],		
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) { return !field.validate();});
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
				}
			}
			return r;
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '재무제표양식차수',
			name: 'GUBUN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'A093',
			allowBlank: false,
			value : '01',
			labelWidth: 110,
			tdAttrs: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('GUBUN', newValue);
				}
			}
		},{
			width: 100,
			xtype: 'button',
			text: '집계항목적용',
			tdAttrs: {align: 'right'},
			margin: '0 100 0 0',
			handler : function() {
				if(confirm(Msg.sMA0221)){
					var param = {GUBUN: panelSearch.getValue('GUBUN')};
					Ext.getBody().mask('로딩중...','loading-indicator');
					aba035ukrService.insertTotItem(param, function(provider, response) {
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);
						}
						Ext.getBody().unmask();
					});	
				}
			}
		},{
			xtype: 'component',
			tdAttrs: {align: 'left', width: 15}
		}]
	});

	/**
	 * Master Grid 정의(Grid Panel)
	 * @type 
	 */

	var masterGrid = Unilite.createGrid('aba410Grid', {
		layout : 'fit',
		region : 'center',
		store: directMasterStore,
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			copiedRow: true
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false 
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}]
		,
		columns: [{dataIndex: 'GUBUN'				, width: 33, hidden: true},
				  {dataIndex: 'DIVI'				, width: 33, hidden: true},
				  {dataIndex: 'SEQ' 				, width: 53},
				  {dataIndex: 'ACCNT_CD'			, width: 80},
				  {dataIndex: 'ACCNT_NAME'   		, minWidth: 240, flex: 1},
				  {dataIndex: 'START_ACCNT'			, width: 100},
				  {dataIndex: 'END_ACCNT'			, width: 86},
				  {dataIndex: 'ADD_ACCNT'			, width: 166},
				  {dataIndex: 'DELETE_ACCNT'		, width: 166},
				  {dataIndex: 'OPT_DIVI'			, width: 90},
				  {dataIndex: 'RIGHT_LEFT' 			, width: 76},
				  {dataIndex: 'DIS_DIVI' 			, width: 90},
				  {dataIndex: 'ACCNT_NAME2' 		, minWidth: 90, flex: 1},
				  {dataIndex: 'ACCNT_NAME3' 		, minWidth: 90, flex: 1},
				  {dataIndex: 'UPDATE_DB_USER'		, width: 86, hidden: true},
				  {dataIndex: 'UPDATE_DB_TIME'		, width: 133, hidden: true}
		], 
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
			if(!e.record.phantom){
				if (UniUtils.indexOf(e.field, ['SEQ', 'ACCNT_CD'])){
					return false;
					}
				}
			},
			render:function(grid, eOpt)	{
				var tbar = grid._getToolBar();
				tbar[0].insert(i++,{
					xtype : 'component',
					style : 'color:#ff0000;font-weight: bold;font-size:11px',
					id    : 'omission_cnt',
					html  : ' ',		//	'※ 0건의 계정이 누락되어있습니다.'
					hidden: gbHideLabel
				});
			}
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
		id : 'aba410App',
		fnInitBinding : function(params) {
			panelSearch.setValue('GUBUN', gsGubun);
			panelResult.setValue('GUBUN', gsGubun);
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);
			UniAppManager.setToolbarButtons('save', false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('GUBUN');
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
			Ext.getCmp('omission_cnt').setHtml('※ 0건의 계정이 누락되어있습니다.');
		},
		onNewDataButtonDown : function(additemCode) {
			var moneyUnit = UserInfo.currency;
			var toDay = UniDate.get('today');
			var itemCode = '';
			if(!Ext.isEmpty(additemCode)){
				itemCode = additemCode
			}
			var r = {
				GUBUN: panelSearch.getValue('GUBUN'),
				DIVI: '50',
				DIS_DIVI: 'N'
			};
			masterGrid.createRow(r, 'SEQ');
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.get('DIS_DIVI') == "Y"){
				alert(Msg.sMB078);	//자료를 삭제 할 수 없습니다.
				return false;
			}
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();	
			}
			
			Ext.getCmp('omission_cnt').setHtml('※ 0건의 계정이 누락되어있습니다.');
		},
		onSaveDataButtonDown: function () {
			directMasterStore.saveStore();
		},
		openOmitInfo:function() {
			var paramData = {
				'GUBUN' : panelSearch.getValue("GUBUN")
			};
			
			if(!omitListWin) {
				Unilite.defineModel('aba035OmitModel', {
					fields: [
						{name: 'ACCNT'			, text: '계정코드'		, type: 'string'},
						{name: 'ACCNT_NAME'		, text: '계정명'		, type: 'string'}
					]
				});
				var aba035OmitStore = Unilite.createStore('aba035OmitStore',{
					model: 'aba035OmitModel',
					uniOpt : {
						isMaster : false,		// 상위 버튼 연결
						editable : false,		// 수정 모드 사용
						deletable: false,		// 삭제 가능 여부
						useNavi  : false		// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'direct',
						api: {
							read: 'aba035ukrService.selectOmitList'
						}
					},
					loadStoreRecords: function(){
						var param = omitListWin.paramData;
						
						console.log( param );
						this.load({
							params: param
						});
					}
				});
				
				omitListWin = Ext.create('widget.uniDetailWindow', {
					title: '시산표설정 누락계정',
					width: 400,
					height:389,
					layout: {type:'vbox', align:'stretch'},
					items: [{
						xtype:'container',
						height:328,
						layout: {type:'vbox', align:'stretch'},
						items:[
							Unilite.createGrid('aba035OmitGrid', {
								layout : 'fit',
								store : aba035OmitStore,
								sortableColumns: false,
								uniOpt:{
									expandLastColumn: false,	//마지막 컬럼 * 사용 여부
									useRowNumberer: false,		//첫번째 컬럼 순번 사용 여부
									useLiveSearch: false,		//찾기 버튼 사용 여부
									filter: {					//필터 사용 여부
										useFilter: false,
										autoCreate: false
									},
									userToolbar :false
								},
								columns:  [
									{dataIndex: 'ACCNT'			, width: 70},
									{dataIndex: 'ACCNT_NAME'	, flex: 1}
								]
							})
						]}
					],
					bbar:{
						layout: {
							pack: 'center',
							type: 'hbox'
						},
						dock:'bottom',
						items : [{
							itemId : 'closeBtn',
							text: '닫기',
							width:100,
							handler: function() {
								omitListWin.hide();
							},
							disabled: false
						}]
					},
					listeners : {
						show: function( panel, eOpts )	{
							aba035OmitStore.loadStoreRecords();
						}
					}
				});
			}
			
			omitListWin.paramData = paramData;
			omitListWin.center();
			omitListWin.show();
		}
	});
};

</script>