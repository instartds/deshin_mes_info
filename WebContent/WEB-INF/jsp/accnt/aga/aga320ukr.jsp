<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aga320ukr">
	<t:ExtComboStore comboType="BOR120"  /> 										<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A001"	/> 							<!-- 차대구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A140"	/> 							<!-- 결제유형 -->
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {   
	var	gsChargeCode	= Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};	//ChargeCode 관련 전역변수
		chargeCode		= (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE

		
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read	: 'aga320ukrService.selectList',
//        	update	: 'aga320ukrService.updateList',
			create	: 'aga320ukrService.insertList',
			destroy	: 'aga320ukrService.deleteList',
			syncAll	: 'aga320ukrService.saveAll'
        }
	});

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aga320ukrModel', {
	   fields: [
			{name: 'COMP_CODE'			, text: '법인'			, type: 'string' },
			{name: 'PAY_TYPE'			, text: '결제유형'			, type: 'string'		, allowBlank: false		, comboType: "AU", comboCode: "A140"},
			{name: 'DR_CR'				, text: '차대구분'			, type: 'string'		, allowBlank: false		, comboType: "AU", comboCode: "A001"},
			{name: 'ACCNT'				, text: '계정코드'			, type: 'string'		, allowBlank: false },
			{name: 'ACCNT_NAME'			, text: '계정명'			, type: 'string' },
			{name: 'INSERT_DB_USER'		, text: '입력자'			, type: 'string' },
			{name: 'INSERT_DB_TIME'		, text: '입력일'			, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'			, type: 'string' },
			{name: 'UPDATE_DB_TIME'		, text: '수정일'			, type: 'uniDate'}
	    ]
	});
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aga320ukrmasterStore',{
		model	: 'aga320ukrModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 	
			deletable	: true,			// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: directProxy,
        
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
    		
        	if(inValidRecs.length == 0 )	{
				config = {
					success	: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
					} 
				};					
				this.syncAllDirect(config);
				
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
 		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
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
			title	: '기본정보', 	
	   		itemId	: 'search_panel1',
	        layout	: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items	: [{ 
				fieldLabel	: '결제유형',
				name		: 'AUTO_TYPE_H', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A140',
				listeners	: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					},
				
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AUTO_TYPE_H', newValue);
					}
				}
			}]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items: [{ 
				fieldLabel	: '결제유형',
				name		: 'AUTO_TYPE_H', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A140',
				listeners	: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					},
				
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AUTO_TYPE_H', newValue);
					}
				}
			}]
	});
	
	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aga320ukrGrid', {
    	layout	: 'fit',
        region	: 'center',
		store	: masterStore,
    	features: [{
    		id	: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id	: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	uniOpt: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: true,		
		    dblClickToEdit		: true,	
		    useGroupSummary		: false,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,
			copiedRow			: true, 	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
        columns: [
			{dataIndex: 'COMP_CODE'			, width: 100		, hidden: true}, 				
			{dataIndex: 'PAY_TYPE'			, width: 120}, 				
			{dataIndex: 'DR_CR'				, width: 120}, 				
			{dataIndex: 'ACCNT'				, width: 120,
				editor: Unilite.popup('ACCNT_G', {
					autoPopup		: true,
					textFieldName	: 'ACCNT_NAME',
					DBtextFieldName	: 'ACCNT_NAME',
					listeners: {
						scope: this,
						onSelected:function(records, type )	{
							var masterGridSelectRecord = masterGrid.uniOpt.currentRecord;
							masterGridSelectRecord.set('ACCNT'		, records[0].ACCNT_CODE);
							masterGridSelectRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear: function(type)	{
							var masterGridSelectRecord = masterGrid.uniOpt.currentRecord;
							masterGridSelectRecord.set('ACCNT'		, '');
							masterGridSelectRecord.set('ACCNT_NAME'	, '');
						},
						applyExtParam: {
							scope	: this,
							fn		: function(popup){
								var param = {
									'CHARGE_CODE'	: chargeCode,
									'ADD_QUERY'		: "SLIP_SW = 'Y' AND GROUP_YN = 'N'"
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
			}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 180,
				editor: Unilite.popup('ACCNT_G', {
					autoPopup: true,
					listeners: {
						scope: this,
						onSelected: function(records, type )	{
							var masterGridSelectRecord = masterGrid.uniOpt.currentRecord;
							masterGridSelectRecord.set('ACCNT'		, records[0].ACCNT_CODE);
							masterGridSelectRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear: function(type)	{
							var masterGridSelectRecord = masterGrid.uniOpt.currentRecord;
							masterGridSelectRecord.set('ACCNT'		, '');
							masterGridSelectRecord.set('ACCNT_NAME'	, '');
						},
						applyExtParam: {
							scope	: this,
							fn		: function(popup){
								var param = {
									'CHARGE_CODE'	: chargeCode,
									'ADD_QUERY'		: "SLIP_SW = 'Y' AND GROUP_YN = 'N'"
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
			}, 				
			{dataIndex: 'INSERT_DB_USER'	, width: 100		, hidden: true}, 				
			{dataIndex: 'INSERT_DB_TIME'	, width: 100		, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_USER'	, width: 100		, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100		, hidden: true} 				
		] ,
        listeners: {
			beforeedit  : function( editor, e, eOpts ) { 
				if (e.record.phantom) {					//신규행이면 모두 수정 가능
					return true;
					
				} else {								//신규행이 아니면 수정 불가능
				 	return false;
				}
       		}
		}
    });    
    
    
	Unilite.Main( {
		id			: 'aga320ukrApp',
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
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('save'		, false);
			UniAppManager.setToolbarButtons('reset'		, true);
			UniAppManager.setToolbarButtons('newData'	, true);
			
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('AUTO_TYPE_H');	
		},

		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
				return false;
			}
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},
		
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			this.fnInitBinding();
		},
		
		onNewDataButtonDown : function()	{        	 
			var r = {
			};	        
			masterGrid.createRow(r);
		},

		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true)	{				
				masterGrid.deleteSelectedRow();
				
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {			//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
					masterGrid.deleteSelectedRow();
			}
		},
		
		onSaveDataButtonDown: function () {
			masterStore.saveStore();
		}
	});
};
</script>
