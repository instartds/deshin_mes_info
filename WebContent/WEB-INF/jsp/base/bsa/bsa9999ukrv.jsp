<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bsa9999ukrv"  >

	<t:ExtComboStore comboType="BOR120" pgmId="bsa9999ukrv" /> 					<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="B083"  /> 		<!-- BOM PATH 정보 -->  
	<t:ExtComboStore comboType="AU" comboCode="A020"  /> 		<!-- 예/아니오 --> 
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var masterSelectedGrid = 'bsa9999ukrvGrid1';  // Grid1 createRow Default
	
	var bprYnStore = Unilite.createStore('bsa9999ukrvBPRYnStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'1'},
			        {'text':'아니오'	, 'value':'2'}
	    		]
	});
	
/**
	 *   Model 정의 
	 * @type 
	 */

	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',
		{
		api: {
			read: 'bpr560ukrvService.selectList',
			//update: 'bpr560ukrvService.updateDetail',
			create: 'bpr560ukrvService.insertDetail',
			destroy: 'bpr560ukrvService.deleteDetail',
			syncAll: 'bpr560ukrvService.saveAll'
		}
	});
	
	
	
	Unilite.defineModel('bsa9999ukrvModel1', {
		
	    fields: [{name: 'COMP_CODE'				,text: '<t:message code="system.label.base.companycode" default="법인코드"/>' 		,type: 'string', defaultValue: UserInfo.compCode},	 
				 {name: 'DIV_CODE'				,text: '<t:message code="system.label.base.division" default="사업장"/>' 		,type: 'string', defaultValue: UserInfo.divCode},	 
				 {name: 'PROD_ITEM_CODE'		,text: '모품목코드' 	,type: 'string' ,allowBlank:false},	 
				 {name: 'CHILD_ITEM_CODE'		,text: '자품목코드' 	,type: 'string', defaultValue: '$'},	 
				 {name: 'ITEM_NAME'				,text: '<t:message code="system.label.base.itemname" default="품목명"/>' 		,type: 'string'},	 
				 {name: 'SPEC'					,text: '<t:message code="system.label.base.spec" default="규격"/>' 			,type: 'string'},	 
				 {name: 'START_DATE'			,text: '시작일' 		,type: 'uniDate', defaultValue: UniDate.get('today')},	 
				 {name: 'STOP_DATE'				,text: '종료일' 		,type: 'uniDate', defaultValue: '2999.12.31'}
				 
		]
	});	

	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */	
	var directMasterStore1 = Unilite.createStore('bsa9999ukrvMasterStore1',{
			model: 'bsa9999ukrvModel1',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy1
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			saveStore: function(config) {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								
								panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);		
							 } 
					};
				
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('bsa9999ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// Unilite.messageBox(Msg.sMB083);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		
           	},
           	update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
//					UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
				
           	}
           	
		}
	});
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var makeProdItemBtn = Ext.create('Ext.Button',{
    		text:'모품목생성',
    		handler:function()	{
    			bpr560ukrvService.makeProdItems(
    				{'DIV_CODE': panelSearch.getValue('DIV_CODE')}
    				,function(provider, response)	{
    					console.log("provider:",provider);
    					console.log("response:",response);
    					Unilite.messageBox('모품목코드가 생성되었습니다.');
    					UniAppManager.app.onQueryButtonDown();
    				}
    			)
    		}
    })
    
 

    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{ 
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				value : UserInfo.divCode,
				allowBlank: false
			}, {
    			xtype: 'radiogroup',
    			fieldLabel: '품목검색',
    			items: [{
    				boxLabel: '현재 적용품목' , width: 120, name: 'APTITEM', inputValue: 'C', checked: true
    			}, {
    				boxLabel: '전체' , width: 70, name: 'APTITEM', inputValue: 'A'
    			}]
	        }, 		    
		    	Unilite.popup('DIV_PUMOK',{
		    	fieldLabel: '모품목코드',
		    	valueFieldName: 'PROD_ITEM_CODE',
				textFieldName: 'ITEM_NAME',
		    	textFieldWidth:170,
		    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PROD_ITEM_CODE', panelSearch.getValue('PROD_ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
									panelResult.setValue('PROD_ITEM_CODE', '');
									panelResult.setValue('ITEM_NAME', '');
								}
					}
		    })]
		}]
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value : UserInfo.divCode
			}, {
    			xtype: 'radiogroup',
    			fieldLabel: '품목검색',
    			items: [{
    				boxLabel: '현재 적용품목' , width: 120, name: 'APTITEM', inputValue: 'C', checked: true
    			}, {
    				boxLabel: '전체' , width: 70, name: 'APTITEM', inputValue: 'A'
    			}]
	        }, 		    
		    	Unilite.popup('DIV_PUMOK',{
		    	fieldLabel: '모품목코드',
		    	valueFieldName: 'PROD_ITEM_CODE',
				textFieldName: 'ITEM_NAME',
		    	textFieldWidth:170,
		    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PROD_ITEM_CODE', panelResult.getValue('PROD_ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelSearch.setValue('PROD_ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
						}
					}
		    })]
	});   
    

    var masterGrid1 = Unilite.createGrid('bsa9999ukrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',   
        flex: 1,
    	store: directMasterStore1,
    	itemId:'bsa9999ukrvGrid1',
    	uniOpt:{	
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
		    	useState: false,   //그리드 설정 (우측)버튼 사용 여부
		    	useStateList: false  //그리드 설정 (죄측)목록 사용 여부
		  	}
        },
        tbar:[makeProdItemBtn],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'COMP_CODE'					,width: 66, hidden: true   },
        		   { dataIndex: 'DIV_CODE'					,width: 66, hidden: false , locked:true  },
        		   { dataIndex: 'PROD_ITEM_CODE'			,width: 120, locked:true,
        		   	editor: Unilite.popup('DIV_PUMOK_G', {		
			 							textFieldName: 'PROD_ITEM_CODE',
			 							DBtextFieldName: 'ITEM_CODE',
			 							extParam: { DIV_CODE: UserInfo.divCode, ITEM_ACCOUNT:['10','20'], ITEM_EXCLUDE:'DIV_CODE'},
			  							autoPopup: true,
										listeners: {'onSelected': {
														fn: function(records, type) {
																masterGrid1.setItemData(records[0],false);
															},
														scope: this
														},
													'onClear': function(type) {
																	masterGrid1.setItemData(null,true);
																}
										}
								})
					},
        		   { dataIndex: 'CHILD_ITEM_CODE'			,width: 66,  hidden: true},
        		   { dataIndex: 'ITEM_NAME'					,width: 200 , locked:true,
        		   	editor: Unilite.popup('DIV_PUMOK_G', {
			 							extParam: {DIV_CODE: UserInfo.divCode, ITEM_ACCOUNT:['10','20'], ITEM_EXCLUDE:'DIV_CODE'},
			  							autoPopup: true,
										listeners: {'onSelected': {
														fn: function(records, type) {
											                   var grdRecord = masterGrid1.uniOpt.currentRecord
																masterGrid1.setItemData(records[0],false);
															},
														scope: this
														},
													'onClear': function(type) {
																	masterGrid1.setItemData(null,true);
																}
															}
								})
					},
        		  
        		   { dataIndex: 'SPEC'						,width: 170  },
        		   { dataIndex: 'START_DATE'				,width: 100   },
        		   { dataIndex: 'STOP_DATE'					,width: 100  }
        		   
        ] ,
        setItemData: function(record, dataClear) {
       		var grdRecord = this.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('PROD_ITEM_CODE'	,"");
       			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,""); 
       		}
       		else {
       			grdRecord.set('PROD_ITEM_CODE'	, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']); 
       		}
		}
		
  
    });
    
    Unilite.Main( {
		borderItems:[
		 masterGrid1	
		,panelSearch
		,panelResult
		],
		id  : 'bsa9999ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);

		},
		onQueryButtonDown : function()	{
			
			masterGrid1.getStore().loadStoreRecords();
			//	beforeRowIndex = -1;			
		},
		onNewDataButtonDown: function()	{
		
				var prodItemCode = panelSearch.getValue('PROD_ITEM_CODE');
	            masterGrid1.createRow({
	            		'DIV_CODE'			  : panelSearch.getValue('DIV_CODE'),    
	            		'PROD_ITEM_CODE'	  : prodItemCode
	            });
		},
		onResetButtonDown: function() {
			if(!UniAppManager.app._needSave())	{
				panelSearch.reset();
				panelSearch.getField('DIV_CODE').setReadOnly(false);
				//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
				panelResult.reset();
				panelResult.getField('DIV_CODE').setReadOnly(false);
				//panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
				masterGrid1.getStore().loadData({});
			}else {
				
			}
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
				directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid1.deleteSelectedRow(selIndex);
			}
		},
		rejectSave: function() {	// 저장
				var rowIndex = masterGrid2.getSelectedRowIndex();
				directMasterStore1.rejectChanges();
				
			
		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('bsa9999ukrvFileUploadPanel');
        	if(directMasterStore1.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
	

}
</script>
