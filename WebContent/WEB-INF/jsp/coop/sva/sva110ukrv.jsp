<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="sva110ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sva110ukrv" /> 			<!-- 사업장 		-->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>	<!-- 담당자명		-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
	<t:ExtComboStore items="${COMBO_VENDING_MACHINE_NO}" storeId="MachineNo" /><!--자판기명-->	
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var detailWin;
function appMain() {
	 
	/**
	 * Model 정의 
	 * @type 
	 */
	
	Unilite.defineModel('sva110ukrvModel', {
		// pkGen : user, system(default)
	    fields: [
				 {name: 'COMP_CODE' 		,text:'법인코드' 		,type:'string'	},
				 {name: 'POS_NO' 			,text:'자판기번호' 		,type:'string'	,allowBlank:false},	//PK	
				 {name: 'POS_NAME' 			,text:'자판기명' 		,type:'string'	,allowBlank:false},
				 {name: 'LOCATION' 			,text:'위치' 			,type:'string'	,allowBlank:false},
				 {name: 'DIV_CODE' 			,text:'사업장' 		,type:'string'	, comboType: 'BOR120', allowBlank:false},//PK
				 {name: 'DEPT_CODE' 		,text:'부서' 			,type:'string' 	, defaultValue: UserInfo.deptCode, allowBlank:false},
				 {name: 'DEPT_NAME' 		,text:'부서명' 		,type:'string' 	, defaultValue: UserInfo.deptName, allowBlank:false},
				 {name: 'WH_CODE' 			,text:'주창고' 		,type:'string' 	,store: Ext.data.StoreManager.lookup('whList'),allowBlank:false},
				 {name: 'BUSI_PRSN' 		,text:'영업담당' 		,type:'string'	,comboType:"AU", comboCode:"S010",allowBlank:false},
				 {name: 'STAFF_ID'			,text:'담당자' 		,type:'string'	},
				 {name: 'PHONE_NUMBER'		,text:'전화번호' 		,type:'string'	},
				 {name: 'POS_TYPE'			,text:'POS_TYPE' 	,type:'string', defaultValue: '4'	},
//				 {name: 'CUSTOM_TYPE' 		,text:'고객유형' 		,type:'string'	/*자판기 Type 5 */},
				 {name: 'REMARK' 			,text:'비고' 			,type:'string'	}
				 
			]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'sva110ukrvService.selectList',
			update: 'sva110ukrvService.updateDetail',
			create: 'sva110ukrvService.insertDetail',
			destroy: 'sva110ukrvService.deleteDetail',
			syncAll: 'sva110ukrvService.saveAll'
		}
	});	  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('sva110ukrvMasterStore',{
			model: 'sva110ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('sva110ukrvSearchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
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
	var panelSearch = Unilite.createSearchPanel('sva110ukrvSearchForm',{
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
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
		items:[{
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				//holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '자판기',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('MachineNo'),
		        multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('POS_CODE', newValue);
					}
				}
			}/*,
			Unilite.popup('DEPT', { 
				fieldLabel: '부서', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			})*/]            			 
		}],		
	    setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
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
  		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
    }); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '자판기',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('MachineNo'),
		        multiSelect: true, 
		        typeAhead: false,
				width: 400,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('POS_CODE', newValue);
						}
					}
			}/*,
			Unilite.popup('DEPT', { 
				fieldLabel: '부서', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			})*/],		
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
    });	
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('sva110ukrvGrid', {
    	region:'center',
    	store: directMasterStore,
        layout : 'fit',        
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: true
        },
        border:true,
		columns:[{dataIndex:'POS_NO' 			,width:100  },
				 {dataIndex:'POS_NAME' 			,width:200	},
				 {dataIndex:'LOCATION' 			,width:250	},
				 {dataIndex:'DIV_CODE' 			,width:100	},
				 {dataIndex: 'DEPT_CODE'		, width:100, hidden: true	
				  ,'editor' : Unilite.popup('DEPT_G',{  textFieldName:'DEPT_CODE',  textFieldWidth:100, DBtextFieldName: 'TREE_CODE'
								,listeners: {'onSelected': {
 								fn: function(records, type) {
 									var grdRecord = masterGrid.uniOpt.currentRecord;
 									grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
			                    	grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);			
 								},
 								scope: this
 							},
 							'onClear': function(type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
        						grdRecord.set('DEPT_CODE','');
		                    	grdRecord.set('DEPT_NAME','');
 							},
							applyextparam: function(popup){							
								var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
								var deptCode = UserInfo.deptCode;	//부서정보
								var divCode = '';					//사업장
								
								if(authoInfo == "A"){	
									popup.setExtParam({'DEPT_CODE': ""});
									popup.setExtParam({'DIV_CODE': UserInfo.divCode});
									
								}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
									popup.setExtParam({'DEPT_CODE': ""});
									popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
									
								}else if(authoInfo == "5"){		//부서권한
									popup.setExtParam({'DEPT_CODE': deptCode});
									popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								}
							}
		 				}
					})
				},
				 {dataIndex: 'DEPT_NAME'				, width:120	
				  ,'editor' : Unilite.popup('DEPT_G',{textFieldName:'DEPT_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME'
						,listeners: {'onSelected': {
 								fn: function(records, type) {
 									var grdRecord = masterGrid.uniOpt.currentRecord;
	        						grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
			                    	grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);	
 								},
 								scope: this
 							},
 							'onClear': function(type) {
 								var grdRecord = masterGrid.uniOpt.currentRecord;
		                    	grdRecord.set('DEPT_CODE','');
		                    	grdRecord.set('DEPT_NAME','');
 							},
							applyextparam: function(popup){							
								var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
								var deptCode = UserInfo.deptCode;	//부서정보
								var divCode = '';					//사업장
								
								if(authoInfo == "A"){	
									popup.setExtParam({'DEPT_CODE': ""});
									popup.setExtParam({'DIV_CODE': UserInfo.divCode});
									
								}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
									popup.setExtParam({'DEPT_CODE': ""});
									popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
									
								}else if(authoInfo == "5"){		//부서권한
									popup.setExtParam({'DEPT_CODE': deptCode});
									popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								}
							}
 						}
					})
				 },
				 {dataIndex:'WH_CODE' 			,width:120	},
				 {dataIndex:'BUSI_PRSN' 		,width:120	},
				 {dataIndex:'STAFF_ID'			,width:110	},
				 {dataIndex:'PHONE_NUMBER'		,width:110	},
//				 {dataIndex:'CUSTOM_TYPE' 		,width:100	,hidden:true},
				 {dataIndex:'REMARK' 			,width:300	}
         	 ],
         	 listeners: {
//         	 cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				UniAppManager.setToolbarButtons(['delete'], true);
//				UniAppManager.setToolbarButtons(['newData'], true);
         	 	beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){					
					if (UniUtils.indexOf(e.field, 
							['COMP_CODE','DIV_CODE','POS_NO']))
							{	
								return false;
							}					
						}
					}
				}
         
    });

    	
    Unilite.Main({
    	id  : 'sva110ukrvApp',
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid, panelResult
         ]},
	         panelSearch
      ]
		,onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('sva110ukrvGrid');
			 masterGrid.downloadExcelXml();
		},
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);	
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);
			UniAppManager.setToolbarButtons('save', false);				
	    },
		onQueryButtonDown: function()	{

			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				/*var param= panelResult.getValues();
				panelResult.uniOpt.inLoading=true;
				panelResult.getForm().load({
					params: param,
					success: function()	{
						panelResult.setAllFieldsReadOnly(true)

						panelResult.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
                        panelResult.uniOpt.inLoading=false;
                    }
				})*/
				directMasterStore.loadStoreRecords();	
				beforeRowIndex = -1;	
				
				panelSearch.setAllFieldsReadOnly(true);				
			}
		},
		onNewDataButtonDown : function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				var compCode = UserInfo.compCode;
				var divCode = panelSearch.getValue('DIV_CODE');
				var deptName = '자판기';
				var deptCode = '119';
				var whCode   = 'W066';
            	 var r = {
            	 	COMP_CODE:		compCode,
            	 	DIV_CODE: 		divCode,
            	 	DEPT_CODE:      deptCode,
            	 	WH_CODE:		whCode,
            	 	DEPT_NAME:      deptName
		        };
				masterGrid.createRow(r);
				
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		onSaveDataButtonDown: function (config) {			
			directMasterStore.saveStore(config);							
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//				if(selRow.get('ITEM_CODE') > 1)
//				{
//					alert('<t:message code="unilite.msg.sMM435"/>');
//				}else{
				masterGrid.deleteSelectedRow();
//				}
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);			
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function()	{
			directMasterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		} 	
		, confirmSaveData: function()	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
            }
	});	// Main
}; // main


</script>


