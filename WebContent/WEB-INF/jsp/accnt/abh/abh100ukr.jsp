<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh100ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="A113" /> <!-- 은행구분 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

function appMain() {
//var choosePopup = 'BANK_G';					//은행구분에 따른 다른 팝업 호출
//var popupCode	= 'BANK_CODE';
//var popupName	= 'BANK_NAME';

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'abh100ukrService.selectList',
			update	: 'abh100ukrService.updateDetail',
			create	: 'abh100ukrService.insertDetail',
			destroy	: 'abh100ukrService.deleteDetail',
			syncAll	: 'abh100ukrService.saveAll'
		}
	});	
	
	/*  Model 정의 
	 * @type  
	 */
	Unilite.defineModel('abh100ukrModel', {
	    fields: [                                                                                                                                        //Msg.sABH100T01
	    	{name: 'BR_BANK_CODE'		,text: '브랜치은행코드'			,type: 'string'		,maxLength: 10	,allowBlank:false},                                              //Msg.sABH100T02
	    	{name: 'BR_BANK_NAME'		,text: '브랜치은행명'			,type: 'string'		,maxLength: 30	,allowBlank:false},                                              //Msg.sABH100T05
	    	{name: 'BR_GUBUN'			,text: '은행구분'				,type: 'string'		,maxLength: 8	,allowBlank:false		,comboType:'AU'		,comboCode:'A113'},  //Msg.sABH100T03
	    	{name: 'BANK_CODE'			,text: '은행코드'				,type: 'string'		,maxLength: 8	,allowBlank:false},                                              //Msg.sABH100T04
	    	{name: 'BANK_NAME'			,text: '은행명'				,type: 'string'		,maxLength: 20},                                                                   
	    	{name: 'INSERT_DB_USER'		,text: 'INSERT_DB_USER'		,type: 'string'	},                                                                   
	    	{name: 'INSERT_DB_TIME'		,text: 'INSERT_DB_TIME'		,type: 'string' },                                                                   
	    	{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'		,type: 'string'	},                                                                   
	    	{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME'		,type: 'string'	},
	    	{name: 'COMP_CODE'			,text: 'COMP_CODE'			,type: 'string'	}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('abh100ukrMasterStore', {
		model	: 'abh100ukrModel',
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
			var param= [];
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
	
    var masterGrid = Unilite.createGrid('abh100ukrGrid', {
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
			{ dataIndex: 'BR_BANK_CODE'			, width:130},
        	{ dataIndex: 'BR_BANK_NAME'			, width:200},
        	{ dataIndex: 'BR_GUBUN'				, width:100},
        	{ dataIndex: 'BANK_CODE'			, width:130		, 
				 getEditor: function(record) {
				 	if(record.get('BR_GUBUN') == "1"){
				 		return  Ext.create('Ext.grid.CellEditor', {
			            	ptype: 'cellediting',
						    clicksToEdit: 1, 						// 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
						    autoCancel : false,
						    selectOnFocus:true,
			               	field: Unilite.popup('BANK_G',{
									autoPopup: true,
							  		textFieldName	: 'BANK_CODE',
				        	  	 	DBtextFieldName	: 'BANK_CODE',
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
         				 	})	
				 	} else {
				 		return  Ext.create('Ext.grid.CellEditor', {
			            	ptype: 'cellediting',
						    clicksToEdit: 1, 						// 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
						    autoCancel : false,
						    selectOnFocus:true,
			               	field: Unilite.popup('CUST_G',{
								autoPopup: true,
						  		textFieldName	: 'CUSTOM_CODE',
			        	  	 	DBtextFieldName	: 'CUSTOM_CODE',
			        	  	 	listeners: { 'onSelected': {
				                    fn: function(records, type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			    						grdRecord.set('BANK_CODE',records[0]['CUSTOM_CODE']);
			    						grdRecord.set('BANK_NAME',records[0]['CUSTOM_NAME']);
			    						
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
     				 	})
				 	}
				}
        	},
        	{ dataIndex: 'BANK_NAME'			, width:200		,
				getEditor: function(record) {
					if(record.get('BR_GUBUN') == "1"){
				 		return  Ext.create('Ext.grid.CellEditor', {
			        		ptype: 'cellediting',
						    clicksToEdit: 1, 						// 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
						    autoCancel : false,
						    selectOnFocus:true,
			               	field: Unilite.popup('BANK_G',{
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
				 		})
				 	} else {
				 		return  Ext.create('Ext.grid.CellEditor', {
			            	ptype: 'cellediting',
						    clicksToEdit: 1, 						// 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
						    autoCancel : false,
						    selectOnFocus:true,
			               	field: Unilite.popup('CUST_G',{
						  		autoPopup: true,
			        	  	 	listeners: { 'onSelected': {
				                    fn: function(records, type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			    						grdRecord.set('BANK_CODE',records[0]['CUSTOM_CODE']);
			    						grdRecord.set('BANK_NAME',records[0]['CUSTOM_NAME']);
			    						
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
				 		})
				 	}
				}
        	}
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
					if(UniUtils.indexOf(e.field, ['BR_BANK_CODE'])){
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
			region	:'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid
			]	
		}],
		id  : 'abh100ukrApp',
		
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['newData', 'reset'], true);
			UniAppManager.setToolbarButtons('save', false);
			
		},
		
		onQueryButtonDown: function() {      
			masterStore.loadStoreRecords();		
		},
		
		onNewDataButtonDown: function()	{
			var compCode = UserInfo.compCode;
			var r = {
				COMP_CODE	: compCode,
				BR_GUBUN	: '1'
			};
			masterGrid.createRow(r);
			UniAppManager.setToolbarButtons('delete', true);
		},
		
		onResetButtonDown: function() {
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

/*	Unilite.createValidator('validator01', {			//BR_GUBUN 값이 따라 은행코드 팝업 변경되어야 함		
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}			
			var rv = true;	
			
			switch(fieldName) {
				case "BR_GUBUN" :		
					if(newValue == '1')	{
						choosePopup = 'BANK_G';
						popupCode	= 'BANK_CODE';
						popupName	= 'BANK_NAME';
					} else {
						choosePopup = 'CUST_G';
						popupCode	= 'CUSTOM_CODE';
						popupName	= 'CUSTOM_NAME';
					}
					break;					
			}
			return rv;
		}
	}); 
*/
};

</script>