<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afs200ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 은행구분 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'afs200ukrService.selectList',
			update	: 'afs200ukrService.updateDetail',
			create	: 'afs200ukrService.insertDetail',
			destroy	: 'afs200ukrService.deleteDetail',
			syncAll	: 'afs200ukrService.saveAll'
		}
	});	
	
	/*  Model 정의 
	 * @type  
	 */
	Unilite.defineModel('afs200ukrModel', {
	    fields: [	
	    	{name: 'PURCHASE_CARD_NUM'		,text: '구매카드번호'		,type: 'string'		,maxLength: 20		, allowBlank: false},		
	    	{name: 'PURCHASE_CARD_NAME'		,text: '구매카드명'			,type: 'string'		,maxLength: 30		, allowBlank: false},		
	    	{name: 'BANK_CODE'				,text: '은행코드'			,type: 'string'		,maxLength: 8		, allowBlank: false},			
	    	{name: 'BANK_NAME'				,text: '은행명'			,type: 'string'		,maxLength: 20},			
	    	{name: 'AMT_I'					,text: '한도액'			,type: 'uniPrice'	,maxLength: 30		, allowBlank: false},	  
	    	{name: 'BANK_ACCOUNT'			,text: '결제계좌번호'		,type: 'string'		,maxLength: 30		, allowBlank: false},		
	    	{name: 'EXP_DATE'				,text: '한도만료일'			,type: 'uniDate'	,maxLength: 10},		  
	    	{name: 'EXPR_DATE'				,text: '유효년월'			,type: 'uniMonth'	,maxLength: 7},			 
	    	{name: 'REMARK'					,text: '비고'				,type: 'string'		,maxLength: 100},			
	    	{name: 'DIV_CODE'				,text: '사업장'			,type: 'string'		,maxLength: 20		, allowBlank: false		, comboType: 'BOR120'},
	    	{name: 'MAIN_CARD_YN'			,text: '브랜치주지급카드'	,type: 'string'		,maxLength: 30		, allowBlank: false		, comboType: 'AU'		, comboCode: 'A020'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('afs200ukrMasterStore', {
		model	: 'afs200ukrModel',
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
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
  
/*			//폼에서 필요한 조건 가져올 경우
			var paramMaster= panelResult.getValues();	*/
			if(inValidRecs.length == 0) {
				config = {
//					params: [paramMaster],
					success: function(batch, option) {
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
			items	: [
				Unilite.popup('PURCHASE_CARD',{ 
				    fieldLabel	: '구매카드', 
				    valueFieldName: 'PURCHASE_CARD_NUM',
					textFieldName: 'PURCHASE_CARD_NAME',
					listeners	: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PURCHASE_CARD_NUM', panelSearch.getValue('PURCHASE_CARD_NUM'));
								panelResult.setValue('PURCHASE_CARD_NAME', panelSearch.getValue('PURCHASE_CARD_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PURCHASE_CARD_NUM', '');
							panelResult.setValue('PURCHASE_CARD_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				})
			]	
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [
			Unilite.popup('PURCHASE_CARD',{ 
			    fieldLabel	: '구매카드', 
			    valueFieldName: 'PURCHASE_CARD_NUM',
				textFieldName: 'PURCHASE_CARD_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PURCHASE_CARD_NUM', panelResult.getValue('PURCHASE_CARD_NUM'));
							panelSearch.setValue('PURCHASE_CARD_NAME', panelResult.getValue('PURCHASE_CARD_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PURCHASE_CARD_NUM', '');
						panelSearch.setValue('PURCHASE_CARD_NAME', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			})
		]
    });		

    var masterGrid = Unilite.createGrid('afs200ukrGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '전표엑셀업로드',
		uniOpt : {					
			useMultipleSorting	: true,			 
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: true,		//체크박스모델은 false로 변경	
		    dblClickToEdit		: true,		
		    useGroupSummary		: false,		
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
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
			{ dataIndex: 'PURCHASE_CARD_NUM'		, width:130},
        	{ dataIndex: 'PURCHASE_CARD_NAME'		, width:200},
        	{ dataIndex: 'BANK_CODE'	 			, width:100		,
			  'editor': Unilite.popup('BANK_G',{
			  		autoPopup: true,
			  		textFieldName : 'BANK_CODE',
        	  	 	DBtextFieldName : 'BANK_CODE',
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
    						grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('BANK_CODE','');
    						grdRecord.set('BANK_NAME','');
	                  }
        	  	 	}
				})
			},
        	{ dataIndex: 'BANK_NAME'	 			, width:130		,
				'editor': Unilite.popup('BANK_G',{
			 		autoPopup: true,
        	 		listeners: { 'onSelected': {
	         			fn: function(records, type  ){
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
    						grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
    						
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('BANK_CODE','');
    						grdRecord.set('BANK_NAME','');
	                  }
        	  	 	}
				})
			},
			{ dataIndex: 'AMT_I'					, width:100},
        	{ dataIndex: 'BANK_ACCOUNT'				, width:130},
        	{ dataIndex: 'EXP_DATE'					, width:100},
        	{ dataIndex: 'EXPR_DATE'				, width:100 /*,
				renderer: function(value) {	  	
					var r = value;
					if (value) {
						if(value.length >= 4) {
							r = value.substring(0,4) + '.' + value.substring(4,6);
						}
					}
					return r;
	 			}*/
	        },
			{ dataIndex: 'REMARK'					, width:200},
        	{ dataIndex: 'DIV_CODE'					, width:100},
        	{ dataIndex: 'MAIN_CARD_YN'				, width:120}
        ],
        listeners: {
        	beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
        	},
        	
       		celldblclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
//    			if(cellIndex==8)	{
//    				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, null, null, null,  'VALUE');			
//    			}
    		},
    		
        	afterrender:function()	{
        	},
        	
			beforeedit : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if(UniUtils.indexOf(e.field, ['PURCHASE_CARD_NUM'])){
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
		id  : 'afs200ukrApp',
		
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['newData', 'reset'], true);
			UniAppManager.setToolbarButtons('save', false);
			
			//초기화 시 거래일자로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PURCHASE_CARD_NUM');
		},
		
		onQueryButtonDown: function() {      
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();		
		},
		
		onNewDataButtonDown: function()	{
			var compCode = UserInfo.compCode;
			var r = {
				COMP_CODE	: compCode
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
	});

};

</script>