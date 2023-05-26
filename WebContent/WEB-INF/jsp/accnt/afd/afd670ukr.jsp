<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="afd670ukr">
    <t:ExtComboStore comboType="BOR120"	/>				<!-- 사업장-->
    <t:ExtComboStore comboType="AU" comboCode="B004" />	<!--화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="A089" />	<!--화폐단위-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    

<script type="text/javascript" >

function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afd670ukrMasterModel', {
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'				, type: 'string'},
			{name: 'DIV_CODE'					, text: '사업장코드'				, type: 'string'},
			{name: 'LOANNO'						, text: '차입번호'				, type: 'string'},
			{name: 'LOAN_NAME'					, text: '차입명'				, type: 'string'},
			{name: 'CUSTOM'						, text: '차입처코드'				, type: 'string'},
			{name: 'CUSTOM_NAME'				, text: '차입처'				, type: 'string'},
			{name: 'LOAN_GUBUN'					, text: '차입구분'				, type: 'string'	, comboType: "AU"	, comboCode: "A089"},
			{name: 'PUB_DATE'					, text: '차입일'				, type: 'uniDate'},
			{name: 'EXP_DATE'					, text: '만기일'				, type: 'uniDate'},
			{name: 'AMT_I'						, text: '차입금액'				, type: 'uniPrice'},
			{name: 'INT_RATE'					, text: '차입이율'				, type: 'uniPercent'},
			{name: 'MONEY_UNIT'					, text: '화폐단위'				, type: 'string'},
			{name: 'PRI_AMT'					, text: '상환금액'				, type: 'uniPrice'},
			{name: 'JAN_AMT'					, text: '잔액'				, type: 'uniPrice'}
		]
	});

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afd670ukrDetailModel', {
		fields: [
			{name: 'COMP_CODE'					, text: '법인코드'				, type: 'string'	, allowBlank: false},
			{name: 'LOANNO'						, text: '차입번호'				, type: 'string'	, allowBlank: false},
			{name: 'PLAN_DATE'					, text: '계획일자'				, type: 'uniDate'	, allowBlank: false},
			{name: 'P_PRINCIPAL_AMT'			, text: '계획상환금액'			, type: 'uniPrice' },
			{name: 'P_INTEREST_AMT'				, text: '계획이자지급액'			, type: 'uniPrice'},
			{name: 'INT_FR_DATE'				, text: '이자대상기간(FROM)'		, type: 'uniDate'},
			{name: 'INT_TO_DATE'				, text: '이자대상기간(TO)'		, type: 'uniDate'},
			{name: 'PAYMENT_DATE'				, text: '상환일자'				, type: 'uniDate'},            
			{name: 'PRI_AMT'					, text: '상환금액'				, type: 'uniPrice'},
			{name: 'INT_AMT'					, text: '이지지급액'				, type: 'uniPrice'},
			{name: 'MONEY_UNIT'					, text: '화폐단위'				, type: 'string'	, comboType: 'AU'	, comboCode: 'B004'},
			{name: 'EXCHG_RATE_O'				, text: '환율'				, type: 'uniER'},
			{name: 'P_FOR_PRINCIPAL_AMT'		, text: '계획상환금액(외화)'		, type: 'uniFC'},
			{name: 'P_FOR_INT_AMT'				, text: '계획이자지급액(외화)'		, type: 'uniFC'},
			{name: 'FOR_PRI_AMT'				, text: '상환금액(외화)'			, type: 'uniFC'},
			{name: 'FOR_INT_AMT'				, text: '이지지급액(외화)'			, type: 'uniFC'}
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afd670ukrService.selectListDetail' ,
			update: 'afd670ukrService.updateDetail',
			create: 'afd670ukrService.insertDetail',
			destroy: 'afd670ukrService.deleteDetail',
			syncAll: 'afd670ukrService.saveAll'
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */                 
	var masterStore = Unilite.createStore('afd670ukrMasterStore1',{
		model: 'Afd670ukrMasterModel',
		uniOpt : {
			isMaster : false,		// 상위 버튼 연결 
			editable : false,		// 수정 모드 사용 
			deletable: false,		// 삭제 가능 여부 
			useNavi	 : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read	: 'afd670ukrService.selectListMaster'
			}
		},
		loadStoreRecords : function() {
			var param = Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */                 
	var detailStore = Unilite.createStore('afd670ukrDetailStore1',{
		model: 'Afd670ukrDetailModel',
		uniOpt : {
			isMaster : true,		// 상위 버튼 연결 
			editable : true,		// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			useNavi	 : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords : function(record) {
			if(Ext.isEmpty(record)) {
				return;
			}
			
			var param = {
				COMP_CODE	: record.get('COMP_CODE'),
				LOANNO		: record.get('LOANNO'),
				REPAY_YN	: panelResult.getValue('REPAY_YN')
			};
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					} 
				};                  
				this.syncAllDirect(config);
			}
			else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('DEBT_NO', {
				textFieldName	: 'LOAN_NAME',
				valueFieldName	: 'LOANNO',
				autoPopup		: true,
				allowBlank		: true
			}),{
				xtype: 'radiogroup',
				fieldLabel: '구분',
				id:'rdoRetrYnR',
				items: [{
					boxLabel: '전체',
					width: 80,
					name: 'REPAY_YN',
					inputValue: ''
				},{
					boxLabel: '미완료',
					width: 80,
					name: 'REPAY_YN',
					inputValue: 'N',
					checked: true
				},{
					boxLabel : '완료',
					width: 80,
					name: 'REPAY_YN',
					inputValue: 'Y'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						
					}
				}
			},{
		    	xtype: 'component',
		    	text: '',
		    	width: 100
			},{
		    	xtype: 'button',
		    	text: '계획생성',
		    	itemId: 'btnMakePlan',
		    	width: 120,
		    	handler : function() {
		    		UniAppManager.app.fnMakePlan();
		    	}
			}
		]
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('afd670ukrMasterGrid1', {
		region:'west',
		store : masterStore,
		flex  : 1,
		uniOpt: {
			expandLastColumn    : true,
			useMultipleSorting  : true,
			filter: {
				useFilter       : true,
				autoCreate      : true
			}
		},
		selModel: 'rowmodel',
		features: [{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
				   {id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{ dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 100	, hidden: true},
			{ dataIndex: 'LOANNO'				, width:  60},
            { dataIndex: 'LOAN_NAME'			, width: 120},
            { dataIndex: 'CUSTOM'				, width:  80	, hidden: true},
            { dataIndex: 'CUSTOM_NAME'			, width: 100},
            { dataIndex: 'LOAN_GUBUN'			, width: 100},
            { dataIndex: 'MONEY_UNIT'			, width: 100	, hidden: true},
            { dataIndex: 'AMT_I'				, width: 120},
            { dataIndex: 'PRI_AMT'				, width: 120},
            { dataIndex: 'JAN_AMT'				, width: 120},
            { dataIndex: 'PUB_DATE'				, width: 100},
            { dataIndex: 'EXP_DATE'				, width: 100},
            { dataIndex: 'INT_RATE'				, width: 100}
		],
		listeners: {
			selectionchangerecord : function( record ) {
				if(!Ext.isEmpty(record)) {
					detailStore.loadStoreRecords(record);
				}
			}
		}
	});

	/**
	 * Detail Grid1 정의(Grid Panel)
	 * @type 
	 */
	var detailGrid = Unilite.createGrid('afd670ukrDetailGrid1', {
		region:'center',
		store : detailStore, 
		flex  : 2,
		uniOpt: {
			expandLastColumn    : true,
			useMultipleSorting  : true,
			/*useLiveSearch       : true,
			onLoadSelectFirst   : true,
			dblClickToEdit      : false,
			useGroupSummary     : true,
			useContextMenu      : false,
			useRowNumberer      : true,
			useRowContext       : false,*/
			filter: {
				useFilter       : true,
				autoCreate      : true
			}
		},
		selModel: 'rowmodel',
		features: [{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
				   {id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
			{ dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{ dataIndex: 'LOANNO'				, width:  70	, hidden: true},
            { dataIndex: 'PLAN_DATE'			, width: 130},
            { dataIndex: 'MONEY_UNIT'			, width:  80	, align: 'center'},
            { dataIndex: 'EXCHG_RATE_O'			, width: 100	, hidden: false},
            { dataIndex: 'P_PRINCIPAL_AMT'		, width: 130	, summaryType: 'sum'},
            { dataIndex: 'P_FOR_PRINCIPAL_AMT'	, width: 130	, summaryType: 'sum'},
            { dataIndex: 'P_INTEREST_AMT'		, width: 130	, hidden: true},
            { dataIndex: 'P_FOR_INT_AMT'		, width: 130	, hidden: true},
            { dataIndex: 'INT_FR_DATE'			, width: 100	, hidden: true},
            { dataIndex: 'INT_TO_DATE'			, width: 100	, hidden: true},
            { dataIndex: 'PAYMENT_DATE'			, width: 100},
            { dataIndex: 'PRI_AMT'				, width: 130	, summaryType: 'sum'},
            { dataIndex: 'FOR_PRI_AMT'			, width: 130	, summaryType: 'sum'},
            { dataIndex: 'INT_AMT'				, width: 130	, hidden: true},
            { dataIndex: 'FOR_INT_AMT'			, width: 130	, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['COMP_CODE', 'LOANNO'])) {
					return false;
				} else if(e.record.get('MONEY_UNIT') == 'KRW' && UniUtils.indexOf(e.field, ['P_FOR_PRINCIPAL_AMT', 'FOR_PRI_AMT', 'FOR_INT_AMT'])) {
					return false;
				} else if(e.record.get('MONEY_UNIT') != 'KRW' && UniUtils.indexOf(e.field, ['P_PRINCIPAL_AMT', 'PRI_AMT', 'INT_AMT'])) {
					return false;
				} else if( e.record.phantom && UniUtils.indexOf(e.field, ['MONEY_UNIT'])) {
					return false;
				} else if(!e.record.phantom && UniUtils.indexOf(e.field, ['PLAN_DATE', 'MONEY_UNIT', 'P_PRINCIPAL_AMT', 'P_FOR_PRINCIPAL_AMT', 'P_INTEREST_AMT', 'P_FOR_INT_AMT', 'INT_FR_DATE', 'INT_TO_DATE'])) {
					return false;
				} else {
					return true;
				}
			}
		}
	});

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, detailGrid, panelResult
			]
		}   
		],  
		id  : 'afd670ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown : function()  {
			if(!this.isValidSearchForm()){
				return false;
			}
			else {
				masterGrid.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('newData', true); 
			}
		},
		onNewDataButtonDown: function() {
			var mRecord = masterGrid.getSelectedRecord();
			
			var r = {
				COMP_CODE			: mRecord.data.COMP_CODE,
				LOANNO				: mRecord.data.LOANNO,
				MONEY_UNIT			: mRecord.data.MONEY_UNIT,
				EXCHG_RATE_O		: (mRecord.data.MONEY_UNIT == 'KRW' ? 1 : mRecord.data.EXCHG_RATE_O),
				P_PRINCIPAL_AMT		: 0,
				P_FOR_PRINCIPAL_AMT	: 0,
				P_INTEREST_AMT		: 0,
				INT_FR_DATE			: '',
				INT_TO_DATE			: '',
				PRI_AMT				: 0,
				FOR_PRI_AMT			: 0,
				INT_AMT				: 0,
				FOR_INT_AMT			: 0
			};
			detailGrid.createRow(r);
        },
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			//masterGrid.reset();
			this.fnInitBinding();
		},
		fnMakePlan : function() {
			if(masterGrid.getStore().getCount() < 1) {
				return;
			}
			
			var record = masterGrid.getSelectedRecord();
			var param = {
				COMP_CODE	: record.get('COMP_CODE'),
				LOANNO		: record.get('LOANNO')
			}
			
			afd670ukrService.fnCheckList(param, function(provider, response){
				if(!Ext.isEmpty(provider) && provider[0].PLAN_COUNT > 0) {
					if(confirm('생성되어있는 계획이 있습니다. 삭제하고 계속 진행하시겠습니까?')) {
						afd670ukrService.fnMakePlan(param, function(provider, response){
							if(!Ext.isEmpty(provider)) {
								alert('계획이 생성되었습니다.');
								detailStore.loadStoreRecords(record);
							}
						});
					}
				}
				else {
					afd670ukrService.fnMakePlan(param, function(provider, response){
						if(!Ext.isEmpty(provider)) {
							alert('계획이 생성되었습니다.');
							detailStore.loadStoreRecords(record);
						}
					});
				}
			});
		}
	});
	
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var moneyUnit = record.get('MONEY_UNIT');
			
			switch(fieldName) {
				case "PLAN_DATE" :
					
					var pubDate = masterGrid.getSelectedRecord().get('PUB_DATE')
					
					if(pubDate > newValue){
						rv = "계획일자가 차입일보다 과거일 수 없습니다.";
						break;
					}
					
					record.set('INT_FR_DATE', newValue);
					record.set('INT_TO_DATE', newValue);
				break;
				
				case "EXCHG_RATE_O" :
					if(newValue <= 0) {
						rv = "환율은 최소 1이상이여야 합니다.";   
						record.set('EXCHG_RATE_O', oldValue);
						break;
					}
					
					record.set('PRI_AMT', record.get('FOR_PRI_AMT') / newValue);
					record.set('INT_AMT', record.get('FOR_INT_AMT') / newValue);
				break;
				
				case "PRI_AMT" :
				case "INT_AMT" :
					if(newValue < 0) {
						rv = "금액이 0보다 적을 수 없습니다.";     
						break;
					}
				break;
				
				case "FOR_PRI_AMT" :
					if(newValue < 0) {
						rv = "금액이 0보다 적을 수 없습니다.";     
						break;
					}
					record.set('PRI_AMT', newValue / record.get('EXCHG_RATE_O'));
				break;
				
				case "FOR_INT_AMT" :
					if(newValue < 0) {
						rv = "금액이 0보다 적을 수 없습니다.";     
						break;
					}
					record.set('INT_AMT', newValue / record.get('EXCHG_RATE_O'));
				break;
				
			}
			return rv;
		}
	});

};

</script>
