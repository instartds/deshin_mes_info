<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="bdc100ukrv_sample_sample"  >
	<t:ExtComboStore items="${BDC100ukv_DOC_LEVEL1}" storeId="bdc100ukrv_sampleLevel1Store" />
	<t:ExtComboStore items="${BDC100ukv_DOC_LEVEL2}" storeId="bdc100ukrv_sampleLevel2Store" />
	<t:ExtComboStore items="${BDC100ukv_DOC_LEVEL3}" storeId="bdc100ukrv_sampleLevel3Store" />
	<t:ExtComboStore comboType="AU" comboCode="CM10" />
</t:appConfig>
<script type="text/javascript" >
var detailWin;
function appMain() {
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	
	Unilite.defineModel('bdc100ukrv_sampleModel', {
	    fields: [
	             {name:'DOC_NO'			,text:'문서번호',		type:'string' , isPk:true, editable:false},
	             {name:'DOC_NAME'		,text:'문서명',			type:'string' , allowBlank:false},
	             {name:'DOC_DESC'		,text:'문서설명',		type:'string'},
	             {name:'REG_EMP'		,text:'등록자ID',			type:'string' , editable:false},
	             {name:'REG_EMP_NAME'	,text:'등록자',			type:'string' , editable:false},
	             {name:'REG_DEPT'		,text:'등록부서코드',		type:'string' , editable:false},
	             {name:'REG_DEPT_NAME'	,text:'등록부서',		type:'string' , editable:false},
	             {name:'REG_DATE'		,text:'등록일',			type:'uniDate' , editable:false},
	             {name:'CUSTOM_CODE'	,text:'거래처코드',		type:'string' },
	             {name:'CUSTOM_NAME'	,text:'거래처',			type:'string' },
	             {name:'PROJECT_NO'		,text:'영업기회번호',	type:'string' },
	             {name:'PROJECT_NAME'	,text:'영업기회명',		type:'string' },
	             {name:'DOC_LEVEL1'		,text:'<t:message code="system.label.base.majorgroup" default="대분류"/>',			type:'string' , store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleLevel1Store')},	 
	             {name:'DOC_LEVEL2'		,text:'<t:message code="system.label.base.middlegroup" default="중분류"/>',			type:'string' , store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleLevel2Store')},	
	             {name:'DOC_LEVEL3'		,text:'<t:message code="system.label.base.minorgroup" default="소분류"/>',			type:'string' , store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleDetailLevel3Store')},	
	             {name:'AUTH_LEVEL'		,text:'권한레벨',		type:'string' , defaultValue: 10, comboType:'AU', comboCode:'CM10', allowBlank:false},
	             {name:'READCNT'		,text:'조회수',			type:'int' 	  , editable:false},
	             {name:'ADD_FIDS'		,text:'등록파일',		type:'string' , editable:false},
	             {name:'DEL_FIDS'		,text:'삭제파일',		type:'string' , editable:false}
	             
	            ]
	});
	

	var directMasterStore = Unilite.createStore('bdc100ukrv_sampleStore', {
			model: 'bdc100ukrv_sampleModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'bdc100ukrvService.selectList'
                	,update : 'bdc100ukrvService.updateMulti'
					,create : 'bdc100ukrvService.insertMulti'
					,destroy: 'bdc100ukrvService.deleteMulti'
					,syncAll: 'bdc100ukrvService.syncAll'
                }
            }
            ,listeners: {
	            write: function(proxy, operation){
	                if (operation.action == 'destroy') {
	                	Ext.getCmp('bdc100ukrv_sampleDetail').reset();			         
	                }                
            	}
            }
            ,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
			saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					if(config==null)	{
						config = {success : function()	{} };
					}
					this.syncAll(config);
					
				}else {
					Unilite.messageBox(Msg.sMB083);
				}
			},insertRecord : function(index)	{
            	 var r =  Ext.create ('bdc100ukrv_sampleModel', {
			          REG_EMP		: UserInfo.userID  
			        ,REG_EMP_NAME	: UserInfo.userName
					,REG_DEPT		: UserInfo.deptCode	
					,REG_DEPT_NAME	: UserInfo.deptName
					,REG_DATE	: new Date()
		        });
		        this.insert(index, r);
				return r;
            }
	});

   
	
	/**
	 * 검색 옵션 Store
	 * 
	 * @type
	 */
	var searchOptStore = Unilite.createStore('bdc100ukrv_sampleSearchOptStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'문서명+내용'	, 'value':'1'},
			        {'text':'문서명'		, 'value':'2'},
			        {'text':'파일명'		, 'value':'3'}
	    		]
		});
		       
	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */     
  	var panelSearch = Unilite.createSearchForm('searchForm', {
        
            layout : {type : 'vbox' , align: 'stretch' },
            items :[  
            		{   xtype: 'container',
	            		defaultType: 'uniTextfield',
	            		layout : {type : 'uniTable', columns : 2},
			        	items : [
				        		{ fieldLabel: '등록일자'
					               ,xtype: 'uniDateRangefield'
					               ,startFieldName: 'REG_DATE_FR'
					               ,endFieldName: 'REG_DATE_TO'	
					               ,width: 470
					               ,startDate: UniDate.get('startOfYear') // UniDate.get('startOfMonth')
					               ,endDate: UniDate.get('today')
				            	 }
				            	,{ fieldLabel: '검색조건 '
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,width: 470
					               ,defaults: { hideLabel: true}
					               ,items: [
						               		 {fieldLabel: 'Select Option'	,name:'SEARCH_OPTION'	,xtype:'uniCombobox', width:150, value:'1', store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleSearchOptStore'), margin: '0 2 0 0', allowBlank:false }
						                    
						                    ,{fieldLabel: 'Search Text'		,name:'SEARCH_TEXT' 	,xtype:'uniTextfield' , width:230}		                   
					                	   ]
					               
				            	 }
				            	,{ fieldLabel: '등록부서'  ,	name: 'REG_DEPT_NAME'}
				       			,{ fieldLabel: '등록자'  ,		name: 'REG_EMP_NAME'}
				       			/*	, Unilite.popup('DEPT',{fieldLabel:'등록부서', valueFieldName:'REG_DEPT_NAME', textFieldName:'REG_DEPT', valueFieldWidth:85, textFieldWidth:160, validateBlank: false}) 
				            	    , Unilite.popup('USER',{fieldLabel:'등록자'  , valueFieldName:'REG_EMP_NAME' , textFieldName:'REG_EMP', valueFieldWidth:85, textFieldWidth:160, validateBlank: false, colspan:2}) 
					       		*/
			       			]
           			 },
	            	{
	           			hidden: true,
					    xtype: 'container',
					    defaultType: 'uniTextfield',	
	        		 	id : 'bdc100ukrv_sampleAdvanceSerch',
					    layout: {type: 'uniTable', columns: 3},			    
				        items:[
				       			{ fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',		name: 'DOC_LEVEL1',		xtype:'uniCombobox', 
				       				store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleLevel1Store'), child: 'DOC_LEVEL2'	
				       			 }
				       			,{ fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',		 name: 'DOC_LEVEL2',		xtype:'uniCombobox', 
				       				store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleLevel2Store'), child: 'DOC_LEVEL3'
				       			  }
				       			,{ fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>' ,		name: 'DOC_LEVEL3',		xtype:'uniCombobox', 
				       				store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleLevel3Store')}
				       			,Unilite.popup('CUST',{fieldLabel:'거래처' , valueFieldWidth:85, textFieldWidth:160, validateBlank: false})
					            ,Unilite.popup('CLIENT_PROJECT',{fieldLabel:'영업기회명' , valueFieldWidth:85, textFieldWidth:160, validateBlank: false, colspan:2}) 
				            ]
	       				}
        			]
        
    }); // createSearchForm

       /**
		 * Master Grid 정의(Grid Panel)
		 * 
		 * @type
		 */ 

    var masterGrid = Unilite.createGrid('bdc100ukrv_sampleGrid', {
        //title: '기본',
        layout : 'fit',
        uniOpt:{
        	store : directMasterStore
        },
        tbar: [
            {
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore,
        columns:  [  
        			 {dataIndex:'DOC_NO'		,width: 100 },
		             {dataIndex:'DOC_NAME'		,width: 250 },
		             {dataIndex:'REG_EMP_NAME'		,width: 80 },
		             {dataIndex:'REG_DEPT_NAME'	,width: 100 },
		             {dataIndex:'REG_DATE'		,width: 100 },
		             {dataIndex:'CUSTOM_NAME'	,width: 150  
		             		,'editor' : Unilite.popup('CUST_G', {
			  							autoPopup: true,
			  							listeners: {
						                'onSelected': {
						                    fn: function(records, type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
						                    	
						                    },
						                    scope: this
						                },
						                'onClear':  function( type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('CUSTOM_CODE','');
						                    	grdRecord.set('CUSTOM_NAME','');
						                }
						            }
								}
								)},
		             {dataIndex:'PROJECT_NAME'	,width: 150 
		             		,'editor' : Unilite.popup('CLIENT_PROJECT_G', {
			  							autoPopup: true,
			  							listeners: {
						                'onSelected': {
						                    fn: function(records, type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('PROJECT_NO',records[0]['PROJECT_NO']);
						                    	
						                    },
						                    scope: this
						                },
						                'onClear':  function( type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('CUSTOM_CODE','');
						                    	grdRecord.set('PROJECT_NAME','');
						                }
						            }
								}
								)},
		             {dataIndex:'DOC_LEVEL1'	,width: 100 },	
		             {dataIndex:'DOC_LEVEL2'	,width: 100 ,hidden : true},
		             {dataIndex:'DOC_LEVEL3'	,width: 100 ,hidden : true},
		             {dataIndex:'READCNT'		,width: 60 }
          ] 
       ,listeners: {	
          		onGridDblClick:function(grid, record, cellIndex, colName) {
  					openDetailWindow(record);
  				}
       		}
         
    });
    
    function openDetailWindow(selRecord, isNew) {
    		// 그리드 저장 여부 확인
    		var edit = masterGrid.findPlugin('cellediting');
			if(edit && edit.editing)	{
				setTimeout("edit.completeEdit()", 1000);
			}
			UniAppManager.app.confirmSaveData();
    		
			// 추가 Record 인지 확인			
			if(isNew)	{		
				var r = masterGrid.createRow();
				selRecord = r[0];
			}
			// form에 data load
			detailForm.loadForm(selRecord);
			
			if(!detailWin) {
				detailWin = Ext.create('widget.uniDetailWindow', {
	                title: '상세정보',
	                width: 830,				                
	                height: 500,
	                isNew: false,
	                x:0,
	                y:0,
	                items: [detailForm],
	                listeners : {beforehide: function(me, eOpt)	{
	                							UniAppManager.app.confirmSaveData();
	                							me.setX(0);
	                							me.setY(0);
	                						},
	                			 beforeclose: function( panel, eOpts )	{
	                			 				UniAppManager.app.confirmSaveData();
	                			 				
	                			 			}
	                }
				})
    		}
    		
			detailWin.show();
				
    }
    
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
      var detailForm = Unilite.createForm('bdc100ukrv_sampleDetail', {
    	// to Make TAB
    	disabled :false
        , autoScroll:true  
	    , layout: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}}
	    , masterGrid: masterGrid
		, items :[	 {fieldLabel: '문서번호'		, name: 'DOC_NO', colspan: 4}					 
					,{fieldLabel: '문서명'			, name: 'DOC_NAME', width:800, colspan : 4, allowBlank:false}
					,{fieldLabel: '문서설명' 		, name: 'DOC_DESC',	xtype: 'textarea', width:800, height:130,	colspan : 4}
					,{fieldLabel: '등록자'			, name: 'REG_EMP_NAME', readOnly:true, width:220}
					,{fieldLabel: '등록부서'		, name: 'REG_DEPT_NAME', readOnly:true, width:220}
					,{fieldLabel: '등록일'			, name: 'REG_DATE', xtype : 'uniDatefield',  readOnly:true, width:220}
					,{fieldLabel: '권한레벨'		, name: 'AUTH_LEVEL', xtype:'uniCombobox', comboType:'AU', comboCode:'CM10', allowBlank:false, width:140}
					,{ fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>'  ,		name: 'DOC_LEVEL1',		xtype:'uniCombobox', 
						store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleLevel1Store'), child:'DOC_LEVEL2', width:220
	       			 }
	       			,{ fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>'  ,		name: 'DOC_LEVEL2',		xtype:'uniCombobox', 
	       				store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleLevel2Store'), child: 'DOC_LEVEL3', width:220
	       			  }
	       			,{ fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>'  ,		name: 'DOC_LEVEL3',		xtype:'uniCombobox', colspan:2,
	       				store: Ext.data.StoreManager.lookup('bdc100ukrv_sampleLevel3Store')}
					,Unilite.popup('CUST',{fieldLabel: '거래처', valueFieldWidth:115, textFieldWidth:240, colspan:2})
					,Unilite.popup('CLIENT_PROJECT',{fieldLabel: '영업기회', colspan:2, valueFieldWidth:85, textFieldWidth:190})
					,{
			     			xtype:'xuploadpanel',
			     			id : 'bdc100ukrv_sampleFileUploadPanel',
					    	itemId:'fileUploadPanel',
					    	colspan : 4,
					    	flex:1,
					    	height:150,
					    	listeners : {
					    		change: function() {
					    			UniAppManager.setToolbarButtons('save', true);
					    			
					    		}
					    	}
					}
		         ],
		         dockedItems: [{
								    xtype: 'toolbar',
								    dock: 'bottom',
								    ui: 'footer',
								    items: [
									        {	id : 'saveBtn',
												itemId : 'saveBtn',
												text: '저장',
												handler: function() {
													UniAppManager.app.onSaveDataButtonDown();
												},
												disabled: true
											}, '-',{
												id : 'saveCloseBtn',
												itemId : 'saveCloseBtn',
												text: '저장 후 닫기',
												handler: function() {								
													if(!detailForm.isDirty() && !detailForm.down('#fileUploadPanel').isDirty())	{
														detailWin.hide();
													}else {
														var config = {success : 
																	function()	{
																		detailWin.hide();
																	}
															}
														UniAppManager.app.onSaveDataButtonDown(config);
													}
												},
												disabled: true
											}, '-',{
												id : 'deleteCloseBtn',
												itemId : 'deleteCloseBtn',
												text: '삭제',
												handler: function() {
														var record = masterGrid.getSelectedRecord();
														var phantom = record.phantom;
														UniAppManager.app.onDeleteDataButtonDown();
														var config = {success : 
																	function()	{
																		detailWin.hide();
																	}
															}
														if(!phantom)	{
															UniAppManager.app.onSaveDataButtonDown(config);
														} else {
															detailWin.hide();
														}
													
												},
												disabled: false
											}, '->',{
												itemId : 'closeBtn',
												text: '닫기',
												handler: function() {
													detailWin.hide();
												},
												disabled: false
											}
								    ]
								}]
				,loadForm: function(record)	{
       				// window 오픈시 form에 Data load
					this.reset();
					this.setActiveRecord(record || null);   
					this.resetDirtyStatus();
					
					var fp = this.down('#fileUploadPanel');
					//fp.clear();
					if(record)	{
						var selected_doc_no = record.data['DOC_NO'];
						bdc100ukrvService.getFileList({DOC_NO : selected_doc_no},
															function(provider, response) {
																var fp = Ext.getCmp('bdc100ukrv_sampleFileUploadPanel');
																fp.loadData(response.result);
															}
														 )	
					}
					
					Ext.getCmp('saveBtn').setDisabled(true);
       				Ext.getCmp('saveCloseBtn').setDisabled(true);
       			}
       			, listeners : {
       				uniOnChange : function( form, field, newValue, oldValue )	{
       					var b = !form.isValid();
       					console.log("record.isValid()", b);
       					Ext.getCmp('saveBtn').setDisabled(b);
       					Ext.getCmp('saveCloseBtn').setDisabled(b);
       				}
       				
       			}
				
	});
	
    

    Unilite.Main( {
    		 id  : 'bdc100ukrv_sampleApp',
			 items 	: [ panelSearch, masterGrid]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData', 'detail'],true);
			}
			,onQueryButtonDown:function () {
				directMasterStore.loadStoreRecords();	

			}
			,onNewDataButtonDown: function()	{
				//var r = masterGrid.createRow();  
				openDetailWindow(null, true);
			},
			onResetButtonDown:function() {
				Ext.getCmp('searchForm').reset();
				masterGrid.reset();

			},
			onSaveDataButtonDown: function (config) {
				var fp = Ext.getCmp('bdc100ukrv_sampleFileUploadPanel');
				var addFiles = fp.getAddFiles();
				var delFiles = fp.getRemoveFiles();
				console.log(addFiles.length)
				if(addFiles.length > 0)	masterGrid.getSelectedRecord().set('ADD_FIDS', addFiles );
				else masterGrid.getSelectedRecord().set('ADD_FIDS', '' );
				if(delFiles.length > 0)	masterGrid.getSelectedRecord().set('DEL_FIDS', delFiles );
				else masterGrid.getSelectedRecord().set('DEL_FIDS', '' );
				if(addFiles.length > 0 || delFiles.length > 0)	fp.uploadFiles();
				directMasterStore.saveStore(config);
			},
			onDeleteDataButtonDown: function() {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailForm.clearForm();
					masterGrid.deleteSelectedRow();
				}
			},
			onDetailButtonDown:function() {
				var as = Ext.getCmp('bdc100ukrv_sampleAdvanceSerch');	
				if(as.isHidden())	{
					as.show();
				}else {
					as.hide()
				}
			},
			saveStoreEvent: function(str, newCard)	{
				var config = null;
				switch(str)  {
						case 'TabChange' : 
							config= {success: function()	{
														var selected = masterGrid.getSelectedRecord();
											 }
									};
						break;
				}
				this.onSaveDataButtonDown(config);
			}, // end saveStoreEvent()
			rejectSave: function()	{
				var rowIndex = masterGrid.getSelectedRowIndex();
				//masterGrid.select(rowIndex);
				directMasterStore.rejectChanges();
				if(masterGrid.getStore().getCount() > 0)	{
					masterGrid.select(rowIndex);
				}
				var fp = Ext.getCmp('bdc100ukrv_sampleFileUploadPanel');
				fp.getStore().rejectChanges();
				fp.clear();
				directMasterStore.onStoreActionEnable();
			}, confirmSaveData: function(config)	{
				var fp = Ext.getCmp('bdc100ukrv_sampleFileUploadPanel');
            	if(directMasterStore.isDirty() || fp.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown(config);
					} else {
						this.rejectSave();
					}
				}
				
            }
		});

}
</script>
<form id="exportform" method="get" target="_blank">
        <input type="hidden" id="fid" name="fid" value="" />
        <input type="hidden" name="inline" value="N" />
</form>
