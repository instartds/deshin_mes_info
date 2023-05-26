<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm800ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="A071" /> <!-- 반제유형 -->
	<t:ExtComboStore comboType="BOR120"  pgmId="bcm800ukrv"/><!-- 사업장 -->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	
	var systemYNStore = Unilite.createStore('bcm800ukrvYNStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'1'},
			        {'text':'아니오'	, 'value':'2'}
	    		]
	});
	
	Unilite.defineModel('bcm800ukrvModel', {
	    fields: [  	  
	    	{name: 'MAIN_CODE'					,text:'메인코드'		,type : 'string' , allowBlank : false, readOnly:true},
			{name: 'SUB_CODE'					,text:'카드번호'		,type : 'string' , allowBlank : false, isPk:true,  pkGen:'user', readOnly:true},
			{name: 'CODE_NAME'					,text:'사용자명'		,type : 'string' , allowBlank : false},
			{name: 'CODE_NAME_EN'				,text:'코드명(영문)'	,type : 'string'},
			{name: 'CODE_NAME_JP'				,text:'코드명(일본)'	,type : 'string'},
			{name: 'CODE_NAME_CN'				,text:'코드명(중국)'	,type : 'string'},
			{name: 'CODE_NAME_VI'				,text:'코드명(베트남어)',type : 'string'},
			{name: 'REF_CODE1'					,text:'거래처코드'		,type : 'string'},
			{name: 'CUSTOM_NAME'				,text:'거래처'		,type : 'string'},
			{name: 'REF_CODE2'					,text:'<t:message code="system.label.base.division" default="사업장"/>'		,type : 'string' , xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'REF_CODE3'					,text:'참조3'			,type : 'string'},
			{name: 'REF_CODE4'					,text:'참조4'			,type : 'string'},  
			{name: 'REF_CODE5'					,text:'참조5'			,type : 'string'},
			{name: 'REF_CODE6'					,text:'참조6'			,type : 'string'},
			{name: 'REF_CODE7'					,text:'참조7'			,type : 'string'},
			{name: 'REF_CODE8'					,text:'참조8'			,type : 'string'},
			{name: 'REF_CODE9'					,text:'참조9'			,type : 'string'},
			{name: 'REF_CODE10'					,text:'참조10'		,type : 'string'},
			{name: 'SUB_LENGTH'					,text:''			,type : 'int'},
			{name: 'USE_YN'						,text:'<t:message code="system.label.base.useyn" default="사용여부"/>'		,type : 'string' , defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'},
			{name: 'SORT_SEQ'					,text:''			,type : 'int'	 , defaultValue:1	, allowBlank : false},
			{name: 'SYSTEM_CODE_YN'				,text:''			,type : 'string' ,store: Ext.data.StoreManager.lookup('bcm800ukrvYNStore') , defaultValue:'2'},
			{name: 'UPDATE_DB_USER'				,text:''			,type : 'string'},
			{name: 'UPDATE_DB_TIME'				,text:''			,type : 'string'},
			{name :'S_COMP_CODE'				,text:''			,type : 'string' , defaultValue: UserInfo.compCode	} 
		]
	}); //End of Unilite.defineModel('bcm800ukrvModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bcm800ukrvService.selectDetailList',
			update: 'bcm800ukrvService.updateDetail',
			create: 'bcm800ukrvService.insertDetail',
			destroy: 'bcm800ukrvService.deleteDetail',
			syncAll: 'bcm800ukrvService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bcm800ukrvMasterStore',{
		model: 'bcm800ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
		proxy: directProxy,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{	
//				var paramMaster= [];
//				var app = Ext.getCmp('bpr101ukrvApp');
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	
			if(inValidRecs.length == 0 )	{					
				config = {
					success: function(batch, option) {								
//						detailForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
	    defaults: {
			autoScroll:true
	  	},
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{	
			    fieldLabel: '카드번호',
			    name:'CARD_NO',
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CARD_NO', newValue);
						}
					}	
			},{	
			    fieldLabel: '사용자명',
			    name:'USER_NAMES',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('USER_NAMES', newValue);
					}
				}	
			},
			Unilite.popup('CUST',{ 
		        	fieldLabel: '거래처코드',
		        	valueFieldName: 'CUSTOM_CODE', 
					textFieldName: 'CUSTOM_NAME', 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					}
		   })]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{

    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{	
			    fieldLabel: '카드번호',
			    name:'CARD_NO',
			    xtype: 'uniTextfield',
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('CARD_NO', newValue);
						}
					}	
			},{	
			    fieldLabel: '사용자명',
			    name:'USER_NAMES',
			    xtype: 'uniTextfield',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('USER_NAMES', newValue);
					}
				}	
			},
			 Unilite.popup('CUST',{ 
			        	fieldLabel: '거래처코드',
			        	valueFieldName: 'CUSTOM_CODE', 
						textFieldName: 'CUSTOM_NAME',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
									panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('CUSTOM_CODE', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						}
			   })]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bcm800ukrvGrid', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        columns: [{dataIndex: 'MAIN_CODE'			, width: 100, hidden: true},
				  {dataIndex: 'SUB_CODE'			, width: 150},
				  {dataIndex: 'CODE_NAME'			, width: 300},
				  {dataIndex: 'CODE_NAME_EN'		, width: 133, hidden: true},
				  {dataIndex: 'CODE_NAME_CN'		, width: 133, hidden: true},
				  {dataIndex: 'CODE_NAME_JP'		, width: 133, hidden: true},
				  {dataIndex: 'CODE_NAME_VI'		, width: 133, hidden: true},
				  {dataIndex: 'SYSTEM_CODE_YN'		, width: 100, hidden: true},
				  {dataIndex: 'REF_CODE1'			 ,width: 80
				  ,editor : Unilite.popup('CUST_G',{						            
				    				textFieldName:'CUSTOM_NAME',
			  						autoPopup: true,
				    				listeners: {
						                'onSelected':  function(records, type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('REF_CODE1',records[0]['CUSTOM_CODE']);
						                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						                }
						                ,'onClear':  function( type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('REF_CODE1','');
						                    	grdRecord.set('CUSTOM_NAME','');
						                }
						            } // listeners
								}) 		
				},
				{dataIndex:'CUSTOM_NAME'	,width:220	
					,'editor' : Unilite.popup('CUST_G',	{				            
				    					textFieldName:'CUSTOM_NAME', 
			  							autoPopup: true,
					    				listeners: {
							                'onSelected':  function(records, type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('REF_CODE1',records[0]['CUSTOM_CODE']);
							                   		grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							                },
							                'onClear':  function( type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('REF_CODE1','');
							                    	grdRecord.set('CUSTOM_NAME','');
							                }
							            } // listeners
								}) 		
				},
		  		  {dataIndex: 'REF_CODE2'			, width: 160},
				  {dataIndex: 'REF_CODE3'			, width: 100, hidden: true},
				  {dataIndex: 'REF_CODE4'			, width: 100, hidden: true},
				  {dataIndex: 'REF_CODE5'			, width: 100, hidden: true},
				  {dataIndex: 'REF_CODE6'			, width: 100, hidden: true},
				  {dataIndex: 'REF_CODE7'			, width: 133, hidden: true},
				  {dataIndex: 'REF_CODE8'			, width: 100, hidden: true},
				  {dataIndex: 'REF_CODE9'			, width: 100, hidden: true},
				  {dataIndex: 'REF_CODE10'			, width: 100, hidden: true},
				  {dataIndex: 'SUB_LENGTH'			, width: 66, hidden: true},  
				  {dataIndex: 'USE_YN'				, width: 80 },				    
				  {dataIndex: 'SORT_SEQ'			, width: 66, hidden: true},					    			    
				  {dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true},					    
				  {dataIndex: 'UPDATE_DB_TIME'		, width: 66, hidden: true},					    
				  {dataIndex: 'S_COMP_CODE'			, width: 66, hidden: true}			    	  
		]
				,
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom || e.record.phantom){
					if (UniUtils.indexOf(e.field, ['MAIN_CODE','UPDATE_DB_USER','UPDATE_DB_TIME','S_COMP_CODE']))
					return false;
				}
				
			}
		}
    });	//End of   var masterGrid = Unilite.createGrid('bcm800ukrvGrid', {

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
		id: 'bcm800ukrvApp',
		fnInitBinding : function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('true',false);
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function(additemCode)	{
			var mainCode = 'YP17'
        	 var r = {
				MAIN_CODE: mainCode

	        };	        
			masterGrid.createRow(r);
			//openDetailWindow(null, true);
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		/**
		 *  삭제
		 *	@param 
		 *	@return
		 */
		 onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		/**
		 *  저장
		 *	@param 
		 *	@return
		 */
		onSaveDataButtonDown: function (config) {
//			var rtnrecord = masterGrid.getSelectedRecord();
//			if(!Ext.isEmpty(rtnrecord)){
//				if(Ext.isEmpty(rtnrecord.get('SALE_DATE'))){
//					rtnrecord.set('SALE_DATE', UniDate.get('today'))
//				}
//			}			
			directMasterStore.saveStore(config);			
		}/*,
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}*/
	}); //End of Unilite.Main( {
};

</script>
