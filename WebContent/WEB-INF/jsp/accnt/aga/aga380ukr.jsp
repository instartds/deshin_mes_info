<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aga380ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A001" /> <!-- 차대구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A101" includeMainCode="true" /> <!-- 구분(기표구분:10 이체지급일 경우) -->
	<t:ExtComboStore comboType="AU" comboCode="A103" includeMainCode="true" /> <!-- 구분(기표구분:20 입금/출금일 경우) -->
	<t:ExtComboStore comboType="AU" comboCode="A104" includeMainCode="true" /> <!-- 유형(구분:10 입금일 경우) -->
	<t:ExtComboStore comboType="AU" comboCode="A105" includeMainCode="true" /> <!-- 유형(구분:20 출금일 경우) -->
	<t:ExtComboStore comboType="AU" comboCode="A394" /> <!-- 급여기표구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A393" /> <!-- 거래유형 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

//급여자동기표
function appMain() {
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aga380ukrService.selectList',
			update	: 'aga380ukrService.updateDetail',
			create	: 'aga380ukrService.insertDetail',
			destroy	: 'aga380ukrService.deleteDetail',
			syncAll	: 'aga380ukrService.saveAll'
		}
	});	
	
	/* 구분 콤보컬럼 관련 스토어
	 */
	var setDiviTypeStore = Ext.create('Ext.data.Store', {
        id 		: 'comboStoreSetDiviType',
		fields	: ['name', 'value'],
        data:[].concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_A101').getData().items).concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_A103').getData().items)
    });
    
	/* 화폐구분 콤보컬럼 관련 스토어
	 */
	var setMethTypeStore = Ext.create('Ext.data.Store', {
        id		: 'comboStoreMethType',
		fields	: ['name', 'value'],
        data:[].concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_A104').getData().items).concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_A105').getData().items)
    });
	
	/*  Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aga380ukrModel', {
	    fields: [
			{name: 'SEQ'			    ,text: '순번'				    ,type: 'string' },	
	    	{name: 'GUBUN'			    ,text: '기표구분'				,type: 'string'		,allowBlank:false		,comboType:'AU'			,comboCode:'A394'},
	    	{name: 'BUSI_TYPE'			,text: '거래유형'				,type: 'string'		,comboType:'AU'			,comboCode:'A393'},
	    	{name: 'DR_CR'				,text: '차대구분'				,type: 'string'		,allowBlank:false		,comboType:'AU'			,comboCode:'A001'},
	    	{name: 'ACCNT'				,text: '계정코드'				,type: 'string'		,allowBlank:false},
	    	{name: 'ACCNT_NAME'			,text: '계정명'				,type: 'string' },	    		    	
	    	{name: 'AMT_GUBUN'			,text: '퇴직금계정구분'			,type: 'string'		,allowBlank:false		,comboType:'AU'			,comboCode:'A390'},
	    	{name: 'BIZ_GUBUN'		    ,text: '수입구분'				,type: 'string'	},
	    	{name: 'BIZ_GUBUN_NAME'		,text: '수입구분명'				,type: 'string'	},
	    	{name: 'REMARK'				,text: '적요'					,type: 'string' },
	    	{name: 'INSERT_DB_USER'		,text: 'INSERT_DB_USER'		,type: 'string' },
	    	{name: 'INSERT_DB_TIME'		,text: 'INSERT_DB_TIME'		,type: 'uniDate' },
	    	{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'		,type: 'string' },
	    	{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME'		,type: 'uniDate' },
	    	{name: 'COMP_CODE'			,text: 'COMP_CODE'			,type: 'string' }
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aga380ukrMasterStore', {
		model	: 'aga380ukrModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			allDeletable: false,		// 전체삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			/*
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
  
			//SET_TYPE변경에 따른 필수 체크			
        	var list = [].concat(toUpdate,toCreate);
        	var isErr = false;
        	var alertMessage = '';
        	
        	
        	Ext.each(list, function(record, index) {
	        	if(record.get('AUTO_TYPE') == '10') {					//기표구분이 이체지급(10)일 경우
	        		if  (Ext.isEmpty(record.get('DIVI_TYPE'))){			//구분 필드는 필수!!
						alertMessage = alertMessage + ' 구분';
						isErr = true;
	        		}
				} else if (record.get('AUTO_TYPE') == '20') {			//기표구분이 입금/출금(20)일 경우
	        		if  (Ext.isEmpty(record.get('DIVI_TYPE'))){			//구분, 화폐구분, 유형 필드는 필수!!
						alertMessage = alertMessage + ' 구분';
						isErr = true;
	        		}
	        		if  (Ext.isEmpty(record.get('MONEY_TYPE'))){
						alertMessage = alertMessage + ' 화폐구분';
						isErr = true;
	        		}
	        		if  (Ext.isEmpty(record.get('METH_TYPE'))){
						alertMessage = alertMessage + ' 유형';
						isErr = true;
	        		}
				}
        	});
        	if (isErr) return false;
			*/

			//var paramMaster= panelResult.getValues();
			if(inValidRecs.length == 0) {
				config = {
 				    //params: [paramMaster],
					success: function(batch, option) {
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						if (masterStore.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
        		if(store.getCount() > 0){
        			UniAppManager.setToolbarButtons('delete', true);

        		} else {
        			UniAppManager.setToolbarButtons('delete', false);
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
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
        collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
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
						fieldLabel	: '급여기표구분',
						name		: 'GUBUN',
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	: 'A394',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('GUBUN', newValue);
							}
						}
					},
					{
						fieldLabel: '거래유형',
						name:'BUSI_TYPE',
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'A393',
						listeners: {
									change: function(field, newValue, oldValue, eOpts) {						
										    panelResult.setValue('BUSI_TYPE', newValue);
									}
						}
					}]	
			}]
		});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border:true,
		items: [{
					fieldLabel	: '급여기표구분',
					name		: 'GUBUN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'A394',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('GUBUN', newValue);
						}
					}
				},
				{
					fieldLabel: '거래유형',
					name:'BUSI_TYPE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'A393',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('BUSI_TYPE', newValue);
						}
					}
				}]
    });		

    var masterGrid = Unilite.createGrid('aga380ukrGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '',
		uniOpt : {					
			useMultipleSorting	: true,			 
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: true,		//체크박스모델은 false로 변경	
		    dblClickToEdit		: true,		
		    useGroupSummary		: false,		
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: false,			
			useRowContext		: false,	// rink 항목이 있을경우만 true	
			copiedRow			: true,		
			filter: {				
				useFilter	: false,		
				autoCreate	: true		
			}					
        },
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		tbar	: [
		],
		store	: masterStore,
		columns: [
			{ dataIndex: 'SEQ'			    , width:100, hidden: true},
			{ dataIndex: 'GUBUN'			, width:100},
        	{ dataIndex: 'BUSI_TYPE'		, width:100},       	
        	{ dataIndex: 'DR_CR'			, width:100},
    		{ dataIndex: 'ACCNT'			, width:100		, align:'center',
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
						   	grdRecord.set('ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT'		, '');
							grdRecord.set('ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'"
//									'CHARGE_CODE': getChargeCode
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{ dataIndex: 'ACCNT_NAME'			, width:170,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
						   	grdRecord.set('ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT'		, '');
							grdRecord.set('ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'"
//									'CHARGE_CODE': getChargeCode
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{ dataIndex: 'AMT_GUBUN'		    , width:130},  
        	{dataIndex: 'BIZ_GUBUN'			,		width: 133,
		 		editor: Unilite.popup('COM_ABA210_G', {
			  		autoPopup: true,
    				DBtextFieldName: 'COM_ABA210_NAME',
	 				listeners: {
	 					'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.getSelectedRecord();
								record = records[0];									
								grdRecord.set('BIZ_GUBUN', record['COM_ABA210_CODE']);
								grdRecord.set('BIZ_GUBUN_NAME', record['COM_ABA210_NAME']);
							},
								scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('BIZ_GUBUN', '');
							grdRecord.set('BIZ_GUBUN_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'SUB_CODE': 'E3'});
						}
					}
				 })
			},
			  {dataIndex: 'BIZ_GUBUN_NAME'			,		width: 133,
		 		editor: Unilite.popup('COM_ABA210_G', {
			  		autoPopup: true,
    				DBtextFieldName: 'COM_ABA210_NAME',
	 				listeners: {
	 					'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.getSelectedRecord();
								record = records[0];									
								grdRecord.set('BIZ_GUBUN', record['COM_ABA210_CODE']);
								grdRecord.set('BIZ_GUBUN_NAME', record['COM_ABA210_NAME']);
							},
								scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('BIZ_GUBUN', '');
							grdRecord.set('BIZ_GUBUN_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'SUB_CODE': 'E3'});
						}
					}
				 })
			},
        	{ dataIndex: 'REMARK'				, flex: 1},        	
        	{ dataIndex: 'INSERT_DB_USER'		, width:100		, hidden: true},
        	{ dataIndex: 'INSERT_DB_TIME'		, width:100		, hidden: true},
        	{ dataIndex: 'UPDATE_DB_USER'		, width:100		, hidden: true},
        	{ dataIndex: 'UPDATE_DB_TIME'		, width:100		, hidden: true},
        	{ dataIndex: 'COMP_CODE'			, width:100 	, hidden: true

        	}
        ],
        listeners: {
        	beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
        	},
      
        	afterrender:function()	{        		
			},
			beforeedit : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if(UniUtils.indexOf(e.field, ['GUBUN', 'BUSI_TYPE'])){
						return false;
					}else{
						return true;	
					}
				}else{
					return true;	
				}
			
			}
		}
    });   

    Unilite.Main( {
		borderItems:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]	
		},
			panelSearch
		],
		id  : 'aga380ukrApp',
		
		fnInitBinding: function(){
			if((Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE == ''){					//회계담당자가 없을 경우 알림 메세지
				//Ext.Msg.alert('확인',Msg.sMA0054);
			}
			UniAppManager.setToolbarButtons(['newData', 'reset'], true);
			UniAppManager.setToolbarButtons('save', false);
			
			//초기화 시 거래일자로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('GUBUN');
		},
		
		onQueryButtonDown: function() {      
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();		
		},
		
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
			var compCode = UserInfo.compCode;
			var r = {
				COMP_CODE: compCode
			};
			masterGrid.createRow(r);
			UniAppManager.setToolbarButtons('delete', true);
		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			
			UniAppManager.app.fnInitBinding();
		},
		
		onSaveDataButtonDown: function(config) {				
			masterStore.saveStore();
		},
		
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();						
			console.log("selRow",selRow);
			
			if (selRow.phantom == true) {
				masterGrid.deleteSelectedRow();
				
			} else if (confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {			//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
				UniAppManager.setToolbarButtons('save'	, true);
			}
		}
		
		/*onDeleteAllButtonDown: function() {			
			var records = masterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},*/
	});
	
};

</script>