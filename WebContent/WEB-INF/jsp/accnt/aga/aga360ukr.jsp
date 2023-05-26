<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aga360ukr">									<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A001"	/> 							<!-- 차대구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A073"	/> 							<!-- 계산식구분(+, -) -->
	<t:ExtComboStore comboType="AU" comboCode="A176"	/> 							<!-- 지출결의_금액구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A004"    />                          <!-- 세트여부(YN) -->
	<t:ExtComboStore items="${COMBO_APP_TYPE}"	storeId="aga360ukrAppTypeStore" />	<!-- 어플리케이션 ID -->
	<t:ExtComboStore items="${COMBO_GUBUN_1}"	storeId="aga360ukrGubun1Store" />	<!-- 구분1 -->
	<t:ExtComboStore items="${COMBO_GUBUN_2}"	storeId="aga360ukrGubun2Store" />	<!-- 구분2 -->
	<t:ExtComboStore items="${COMBO_GUBUN_3}"	storeId="aga360ukrGubun3Store" />	<!-- 구분3 -->
	<t:ExtComboStore items="${COMBO_GUBUN_4}"	storeId="aga360ukrGubun4Store" />	<!-- 구분4 -->
	<t:ExtComboStore items="${COMBO_GUBUN_5}"	storeId="aga360ukrGubun5Store" />	<!-- 구분5 -->
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {   

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read	: 'aga360ukrService.selectList',
        	update	: 'aga360ukrService.updateList',
			create	: 'aga360ukrService.insertList',
			destroy	: 'aga360ukrService.deleteList',
			syncAll	: 'aga360ukrService.saveAll'
        }
	});

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aga360ukrModel', {
	   fields: [
			{name: 'COMP_CODE'			, text: '법인'			, type: 'string' },
			{name: 'APP_TYPE'			, text: '어플리케이션ID'	, type: 'string'		, allowBlank: false		, store: Ext.data.StoreManager.lookup('aga360ukrAppTypeStore')	, child:'GUBUN_1'},
			{name: 'GUBUN_1'			, text: '구분1'			, type: 'string'		, allowBlank: false		, store: Ext.data.StoreManager.lookup('aga360ukrGubun1Store')	, child:'GUBUN_2'},
			{name: 'GUBUN_2'			, text: '구분2'			, type: 'string'		, allowBlank: true		, store: Ext.data.StoreManager.lookup('aga360ukrGubun2Store')	, child:'GUBUN_3'},
			{name: 'GUBUN_3'			, text: '구분3'			, type: 'string'		, allowBlank: true		, store: Ext.data.StoreManager.lookup('aga360ukrGubun3Store')	, child:'GUBUN_4'},
			{name: 'GUBUN_4'			, text: '구분4'			, type: 'string'		, allowBlank: true		, store: Ext.data.StoreManager.lookup('aga360ukrGubun4Store')	, child:'GUBUN_5'},
			{name: 'GUBUN_5'			, text: '구분5'			, type: 'string'		, allowBlank: true		, store: Ext.data.StoreManager.lookup('aga360ukrGubun5Store')	, parentNames:['APP_TYPE', 'GUBUN1', 'GUBUN2', 'GUBUN3', 'GUBUN4']	, levelType:'APP'},
			{name: 'DR_CR'				, text: '차대구분'			, type: 'string'		, allowBlank: false		, comboType: "AU", comboCode: "A001"},
			{name: 'CAL_DIVI'			, text: '부호'			, type: 'string'		, allowBlank: false		, comboType: "AU", comboCode: "A073"},
			{name: 'AMT_DIVI'			, text: '금액구분'			, type: 'string'		, allowBlank: false		, comboType: "AU", comboCode: "A176"},
			{name: 'ACCNT'				, text: '계정코드'			, type: 'string'		, allowBlank: false },
			{name: 'ACCNT_NAME'			, text: '계정과목명'		, type: 'string' },
			
			{name: 'IN_USER_ID'			, text: '입력자'			, type: 'string' },
			{name: 'IN_DEPT_CODE'		, text: '입력부서'			, type: 'string' },
			{name: 'DEPT_CODE'			, text: '귀속부서'			, type: 'string' },
			{name: 'BIZ_GUBUN'			, text: '수입구분'			, type: 'string' },
			{name: 'PJT_CODE'			, text: '프로젝트코드'		, type: 'string' },
			{name: 'ITEM_CODE'			, text: '제품코드'			, type: 'string' },
			{name: 'ITEM_NAME'			, text: '제품명'			, type: 'string' },
			{name: 'BON_ACCNT'			, text: '본계정'			, type: 'string' },
			{name: 'SET_YN'             , text: '세트여부(YN)'      , type: 'string' , comboType: "AU", comboCode: "A004"},
			{name: 'REMARK1'			, text: '비고1'			, type: 'string' },
			{name: 'REMARK2'			, text: '비고2'			, type: 'string' },
			{name: 'REMARK3'			, text: '비고3'			, type: 'string' },
			{name: 'INSERT_DB_USER'		, text: '입력자'			, type: 'string' },
			{name: 'INSERT_DB_TIME'		, text: '입력일'			, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'			, type: 'string' },
			{name: 'UPDATE_DB_TIME'		, text: '수정일'			, type: 'uniDate'},
			{name: 'TEMPC_01'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPC_02'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPC_03'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPN_01'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPN_02'			, text: '여유컬럼'			, type: 'string' },
			{name: 'TEMPN_03'			, text: '여유컬럼'			, type: 'string' }
	    ]
	});
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('aga360ukrmasterStore',{
		model	: 'aga360ukrModel',
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
				fieldLabel	: '어플리케이션',
				name		: 'APP_TYPE', 
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('aga360ukrAppTypeStore'),
				listeners	: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					},
					
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('APP_TYPE', newValue);
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
				fieldLabel	: '어플리케이션',
				name		: 'APP_TYPE', 
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('aga360ukrAppTypeStore'),
				listeners	: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					},
					
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('APP_TYPE', newValue);
					}
				}
			}]
	});
	
	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aga360ukrGrid', {
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
			{dataIndex: 'APP_TYPE'			, width: 120}, 				
			{dataIndex: 'GUBUN_1'			, width: 100}, 				
			{dataIndex: 'GUBUN_2'			, width: 100}, 				
			{dataIndex: 'GUBUN_3'			, width: 100}, 				
			{dataIndex: 'GUBUN_4'			, width: 100}, 				
			{dataIndex: 'GUBUN_5'			, width: 100}, 				
			{dataIndex: 'DR_CR'				, width: 100}, 				
			{dataIndex: 'CAL_DIVI'			, width: 100}, 				
			{dataIndex: 'AMT_DIVI'			, width: 100}, 				
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
//									'CHARGE_CODE':gsChargeCode,
									'ADD_QUERY':"SLIP_SW = 'Y' AND GROUP_YN = 'N'"
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
			}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 160,
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
//									'CHARGE_CODE':gsChargeCode,
									'ADD_QUERY':"SLIP_SW = 'Y' AND GROUP_YN = 'N'"
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
			}, 				

			{dataIndex: 'IN_USER_ID'		, width: 140}, 				
			{dataIndex: 'IN_DEPT_CODE'		, width: 140}, 				
			{dataIndex: 'DEPT_CODE'			, width: 140}, 				
			{dataIndex: 'BIZ_GUBUN'			, width: 140}, 				
			{dataIndex: 'PJT_CODE'			, width: 140}, 				
			{dataIndex: 'ITEM_CODE'			, width: 140}, 				
			{dataIndex: 'ITEM_NAME'			, width: 140}, 				
			{dataIndex: 'BON_ACCNT'			, width: 140},	
            {dataIndex: 'SET_YN'            , width: 100}, 
			{dataIndex: 'REMARK1'			, width: 140}, 				
			{dataIndex: 'REMARK2'			, width: 140}, 				
			{dataIndex: 'REMARK3'			, width: 140}, 				
			{dataIndex: 'INSERT_DB_USER'	, width: 100		, hidden: true}, 				
			{dataIndex: 'INSERT_DB_TIME'	, width: 100		, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_USER'	, width: 100		, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPC_01'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPC_02'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPC_03'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPN_01'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPN_02'			, width: 100		, hidden: true}, 				
			{dataIndex: 'TEMPN_03'			, width: 100		, hidden: true}
		] ,
        listeners: {
			beforeedit  : function( editor, e, eOpts ) { 
				if (e.record.phantom) {					//신규행이면 모두 수정 가능
					return true;
					
				} else {								//신규행이 아니면 아래 내용만 수정 가능
	  				if (UniUtils.indexOf(e.field, ['IN_USER_ID', 'IN_DEPT_CODE', 'DEPT_CODE', 'BIZ_GUBUN', 'PJT_CODE', 'ITEM_CODE', 'ITEM_NAME', 'BON_ACCNT', 'SET_YN', 'REMARK1', 'REMARK2', 'REMARK3'])){
	  					return true;
					}else{
					 	return false;
					}
				}
       		}
		}
    });    
    
    
	Unilite.Main( {
		id			: 'aga360ukrApp',
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
			activeSForm.onLoadSelectText('APP_TYPE');	
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
