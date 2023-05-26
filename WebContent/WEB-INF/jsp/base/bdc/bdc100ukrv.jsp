<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="bdc100ukrv"  >
	<t:ExtComboStore items="${BDC100ukv_DOC_LEVEL1}" storeId="BDC100ukrvLevel1Store" />
	<t:ExtComboStore items="${BDC100ukv_DOC_LEVEL2}" storeId="BDC100ukrvLevel2Store" />
	<t:ExtComboStore items="${BDC100ukv_DOC_LEVEL3}" storeId="BDC100ukrvLevel3Store" />
	<t:ExtComboStore comboType="AU" comboCode="CM10" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript" >
var detailWin;
function appMain() {
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	
	Unilite.defineModel('Bdc100ukrvModel', {
	    fields: [
	             {name:'DOC_NO'			,text:'문서번호',		type:'string' , isPk:true, editable:false},
	             {name:'DOC_NAME'		,text:'문서명',		type:'string' , allowBlank:false},
	             {name:'DOC_DESC'		,text:'문서설명',		type:'string'},
	             {name:'REG_EMP'		,text:'등록자ID',		type:'string' , editable:false},
	             {name:'REG_EMP_NAME'	,text:'등록자',		type:'string' , editable:false},
	             {name:'REG_DEPT'		,text:'등록부서코드',	type:'string' , editable:false},
	             {name:'REG_DEPT_NAME'	,text:'등록부서',		type:'string' , editable:false},
	             {name:'REG_DATE'		,text:'등록일',		type:'uniDate' , editable:false},
	             {name:'CUSTOM_CODE'	,text:'거래처코드',	type:'string' },
	             {name:'CUSTOM_NAME'	,text:'거래처',		type:'string' },
	             {name:'PROJECT_NO'		,text:'영업기회번호',	type:'string' },
	             {name:'PROJECT_NAME'	,text:'영업기회명',	type:'string' },
	             {name:'DOC_LEVEL1'		,text:'<t:message code="system.label.base.majorgroup" default="대분류"/>',		type:'string' , store: Ext.data.StoreManager.lookup('BDC100ukrvLevel1Store')},	 
	             {name:'DOC_LEVEL2'		,text:'<t:message code="system.label.base.middlegroup" default="중분류"/>',		type:'string' , store: Ext.data.StoreManager.lookup('BDC100ukrvLevel2Store')},	
	             {name:'DOC_LEVEL3'		,text:'<t:message code="system.label.base.minorgroup" default="소분류"/>',		type:'string' , store: Ext.data.StoreManager.lookup('BDC100ukrvDetailLevel3Store')},	
	             {name:'AUTH_LEVEL'		,text:'권한레벨',		type:'string' , defaultValue: 10, comboType:'AU' ,comboCode:'CM10', allowBlank:false},
	             {name:'READCNT'		,text:'조회수',		type:'int' 	  , editable:false},
	             {name:'REMARK'			,text:'<t:message code="system.label.base.remarks" default="비고"/>',			type:'string' , editable:false},
	             {name:'ADD_FIDS'		,text:'등록파일',		type:'string' , editable:false},
	             {name:'DEL_FIDS'		,text:'삭제파일',		type:'string' , editable:false}
	             
	            ]
	});
	

	var directMasterStore = Unilite.createStore('bdc100ukrvStore', {
			model: 'Bdc100ukrvModel',
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
	                	Ext.getCmp('bdc100ukrvDetail').reset();			         
	                }                
            	}
            }
            ,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					if(config==null)	{
						config = {success : 
											function()	{
												UniAppManager.setToolbarButtons( 'newData', true);
												detailForm.setActiveRecord(masterGrid.getSelectedRecord() || null); 
											}
									}
					}
					this.syncAll(config);
					
				}else {
					Unilite.messageBox(Msg.sMB083);
				}
			},insertRecord : function(index)	{
            	 var r =  Ext.create ('Bdc100ukrvModel', {
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
	var searchOptStore = Unilite.createStore('Bdc100ukrvSearchOptStore', {
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
	var panelSearch = Unilite.createSearchForm('searchForm',{
		region:'west',	
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		split:true,
		padding:0,
		width:350,
        margin: '0 0 0 0',
	    border: true,
		collapsible: false,	
		autoScroll:true,
		collapseDirection: 'rigth',
		tools: [{
			region:'west',
			type: 'left', 	
			itemId:'left',
			tooltip: 'Hide',
			handler: function(event, toolEl, panelHeader) {
						panelSearch.collapse(); 
				    }
			}
		],
		items:[{
		xtype:'container',
		defaults:{
			collapsible:true,
			titleCollapse:true,
			hideCollapseTool : true,
			bodyStyle:{'border-width': '0px',
						'spacing-bottom':'3px'
			},
			header:{ xtype:'header',
					 style:{
							'background-color': '#D9E7F8',
							'background-image':'none',
							'color': '#333333',
							'font-weight': 'normal',
							'border-width': '0px',
							'spacing':'5px'
							}
					}
		},		
		layout: {type: 'vbox', align:'stretch'},
	    defaultType: 'panel',
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout : {type : 'vbox' , align: 'stretch' },
            items :[{   
            	xtype: 'container',
	            defaultType: 'uniTextfield',
	            layout : {type : 'uniTable', columns : 1},
			    items :[{
				       	  fieldLabel: '등록일자',
				   	      xtype: 'uniDateRangefield',
				   	      startFieldName: 'REG_DATE_FR',
				   	      endFieldName: 'REG_DATE_TO',	
				   	      width: 330,
				   	      startDate: UniDate.get('startOfYear'),
				   	      endDate: UniDate.get('today'),
	        			  labelWidth:67
				   	  },{
				   		  fieldLabel: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
				   		  name:'SEARCH_OPTION',
				   		  xtype:'uniCombobox',
				   		  width:245, value:'1',
				   		  store: Ext.data.StoreManager.lookup('Bdc100ukrvSearchOptStore'),
				   		  margin: '0 2 0 0',
				   		  allowBlank:false,
	        			  labelWidth:67
				   	  },{
				   		  fieldLabel: ' ',
				   		  name:'SEARCH_TEXT',
				   		  xtype:'uniTextfield',
				   		  width:317,
	        			  labelWidth:67
				   	  },{
				   		  fieldLabel: '등록부서',
				   		  name: 'REG_DEPT_NAME',
	        			  labelWidth:67
				   	  },{
				   		  fieldLabel: '등록자',
				   		  name: 'REG_EMP_NAME',
	        			  labelWidth:67
				   	  }
	        			/*	, Unilite.popup('DEPT',{fieldLabel:'등록부서', valueFieldName:'REG_DEPT_NAME', textFieldName:'REG_DEPT', valueFieldWidth:85, textFieldWidth:160, validateBlank: false}) 
	             	    , Unilite.popup('USER',{fieldLabel:'등록자'  , valueFieldName:'REG_EMP_NAME' , textFieldName:'REG_EMP', valueFieldWidth:85, textFieldWidth:160, validateBlank: false, colspan:2}) 
		        		*/
       			]
			},{ 		
           		hidden: false,
				xtype: 'container',
				defaultType: 'uniTextfield',	
        		itemId : 'AdvanceSerch',
				layout: {type: 'uniTable', columns: 1},			    
			    items :[{
			    		 fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
			    		 name: 'DOC_LEVEL1',
			    		 xtype:'uniCombobox', 
		       			 store: Ext.data.StoreManager.lookup('BDC100ukrvLevel1Store'),
		       			 child: 'DOC_LEVEL2',
	        			  labelWidth:67
		       		 },{
		       			 fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
		       			 name: 'DOC_LEVEL2',
		       			 xtype:'uniCombobox',		       			 
		       			 store: Ext.data.StoreManager.lookup('BDC100ukrvLevel2Store'),
		       			 child: 'DOC_LEVEL3',
	        			 labelWidth:67
		       		 },{
		       			 fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>' ,
		       			 name: 'DOC_LEVEL3',
		       			 xtype:'uniCombobox',
		       			 labelWidth:67,
		       			 store: Ext.data.StoreManager.lookup('BDC100ukrvLevel3Store')
		       		 },
		       			 Unilite.popup('CUST',{
		       			 fieldLabel:'거래처' ,
		       			 valueFieldWidth:85,
		       			 textFieldWidth:160,
		       			 validateBlank: false,
	        			 labelWidth:67
		       		 }),
		       			 Unilite.popup('CLIENT_PROJECT',{
		       			 fieldLabel:'영업기회명',
		       			 
		       			 valueFieldWidth:85,
		       			 textFieldWidth:160,
		       			 validateBlank: false,		       			 
	        			 labelWidth:67,
		       			 colspan:2}) 
		        ]
   			}
        	]		
		}]
		}]
	});	//end panelSearch    
    
    

       /**
		 * Master Grid 정의(Grid Panel)
		 * 
		 * @type
		 */ 

    var masterGrid = Unilite.createGrid('bdc100ukrvGrid', {
        layout : 'fit',
        region: 'center',
        uniOpt:{
        			useRowNumberer: true,
                    useMultipleSorting: true
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
						                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						                    	
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
						                    	grdRecord.set('PROJECT_NAME',records[0]['PROJECT_NAME']);
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
		             {dataIndex:'READCNT'		,width: 60 },
		             {dataIndex:'REMARK'		,flex: 1 }
          ],
          listeners: {
                onGridDblClick: function(grid, record, cellIndex, colName) {
                    openDetailWindow(record);
                }
          }
//       ,listeners: {	
//          		selectionchange: function( grid, selected, eOpts ) {
//          			var detailForm = Ext.getCmp('bdc100ukrvDetail');
//          			detailForm.setActiveRecord(selected[0] || null);   
//          			if(selected[0])	{
//          				/*
//          				if( selected[0].data['DOC_LEVEL1'])	{
//	          				detailDocLevel2Store.loadStoreRecords();
//	          				detailForm.setValue("DOC_LEVEL2", selected[0].data['DOC_LEVEL2'])
//	          				if( selected[0].data['DOC_LEVEL2'])	{
//		          				detailDocLevel3Store.loadStoreRecords();
//		          				detailForm.setValue("DOC_LEVEL3", selected[0].data['DOC_LEVEL3'])
//	          				}
//          				}
//          				*/
//          				var selected_doc_no = selected[0].data['DOC_NO'];
//          				bdc100ukrvService.getFileList({DOC_NO : selected_doc_no},
//																function(provider, response) {
//																	var fp = Ext.getCmp('bdc100ukrvFileUploadPanel');
//																	fp.loadData(response.result);
//																}
//															 )
//						
//          			}
//          			         			  
//  				}
//	        	
//         }
         
    });  // masterGrid
    
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
	var detailForm = Unilite.createForm('bdc100ukrvDetail', {    
		autoScroll:true,         
        layout : 'fit',
	    layout: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}},
	    masterGrid: masterGrid,
	    defaults:{labelWidth:60},
		items :[{
			fieldLabel: '문서번호'	,
			name: 'DOC_NO',
			colspan : 4
		}, {
			fieldLabel: '문서명',
			name: 'DOC_NAME',
			width:800,
			colspan : 4,
			allowBlank:false
		}, {
			fieldLabel: '문서설명'	,
			name: 'DOC_DESC',	
			xtype: 'textarea',
			width:800,
			height:130,
			colspan : 4
		}, {
			fieldLabel: '등록자',
			name: 'REG_EMP_NAME',
			readOnly:true,
			width:200
		}, {
			fieldLabel: '등록부서'	,
			name: 'REG_DEPT_NAME',
			readOnly:true,
			width:200
		}, {
			fieldLabel: '등록일',
			name: 'REG_DATE',
			xtype: 'uniDatefield',
			readOnly:true,
			width:200
		}, {
			fieldLabel: '권한레벨'	,
			name: 'AUTH_LEVEL',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'CM10',
			allowBlank:false,
			width:200
		}, {
			fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>' ,
			name: 'DOC_LEVEL1',
			xtype:'uniCombobox', 
			store: Ext.data.StoreManager.lookup('BDC100ukrvLevel1Store'),
			child:'DOC_LEVEL2',
			width:200
	    }, {
	    	fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
	    	name: 'DOC_LEVEL2',
	    	xtype:'uniCombobox', 
	       	store: Ext.data.StoreManager.lookup('BDC100ukrvLevel2Store'),
	       	child: 'DOC_LEVEL3',
	       	width:200
	    }, {
	    	fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
	    	name: 'DOC_LEVEL3',
	    	xtype:'uniCombobox',
	    	colspan:2,
			store: Ext.data.StoreManager.lookup('BDC100ukrvLevel3Store')
		},
			Unilite.popup('CUST',{
			fieldLabel: '거래처',
			valueFieldWidth:100,
			textFieldWidth:235, colspan:2
		}),
			Unilite.popup('CLIENT_PROJECT',{
			fieldLabel: '영업기회',
			colspan:2,
			valueFieldWidth:100,
			textFieldWidth:235
	   }),{
	   		fieldLabel: ' ',
	   		xtype:'displayfield',
	   		colspan:4}
				,{
	     			xtype:'xuploadpanel',
	     			id : 'bdc100ukrvFileUploadPanel',
			    	itemId:'fileUploadPanel',
			    	colspan : 4,
			    	flex:1,
			    	height:200,
			    	listeners : {
			    		change: function() {
		                    if(detailWin.isVisible()) {       // 처음 윈도열때는 윈독 존재 하지 않음.
		       				     detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
		                    }
			    		}
			    	}
				}
		 ]
		         ,loadForm: function(record)	{
       				// window 오픈시 form에 Data load
					this.reset();
					this.setActiveRecord(record || null);   
					this.resetDirtyStatus();
                    var win = this.up('uniDetailFormWindow');
                    
                    if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
       				     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                         win.setToolbarButtons(['prev','next'],true);
                    }
                    
                    //첨부파일
       				var fp = Ext.getCmp('bdc100ukrvFileUploadPanel');
				    
//				    var docNo=record.data['DOC_NO']
//				    if(docNo != '' && docNo != null && docNo  !== 'undefined' )	{
       				if(record && !Ext.isEmpty(record.data['DOC_NO'])) {
       					var docNo=record.data['DOC_NO'];
				   	 	bdc100ukrvService.getFileList({DOC_NO : docNo},
															function(provider, response) {
																var fp = Ext.getCmp('bdc100ukrvFileUploadPanel');
																fp.loadData(response.result);
															}
														 )
						//조회수 update
						var param = {'DOC_NO': docNo};
						bdc100ukrvService.updateReadCnt(param);
					}else {
						fp.clear(); // 	fp.loadData() 실행 시 데이타 삭제됨.
					}
       			}
       			
       			, listeners : {
       				uniOnChange : function( form, field, newValue, oldValue )	{
       					var b = form.isValid();
                        this.up('uniDetailFormWindow').setToolbarButtons(['saveBtn','saveCloseBtn'],b);
                        this.up('uniDetailFormWindow').setToolbarButtons(['prev','next'],!b);   // 저장이 필요할경우 이전 다음 disable
       				}
       				
       			}
	});  // detailForm
	
	
		function openDetailWindow(selRecord, isNew) {
    		// 그리드 저장 여부 확인
    		var edit = masterGrid.findPlugin('cellediting');
			if(edit && edit.editing)	{
				setTimeout("edit.completeEdit()", 1000);
			}
			
			//UniAppManager.app.confirmSaveData();
    		
			// 추가 Record 인지 확인			
			if(isNew)	{		
				//var r = masterGrid.createRow();
				//selRecord = r[0];
				selRecord = masterGrid.createRow();
				if(!selRecord)	{
					selRecord = masterGrid.getSelectedRecord();
				}
			}
			// form에 data load
			detailForm.loadForm(selRecord);
			
			
			if(!detailWin) {
				detailWin = Ext.create('widget.uniDetailFormWindow', {
	                title: '상세정보',
	                width: 830,				                
	                height: 580,
	                isNew: false,
	                x:0,
	                y:0,
	                items: [detailForm],
	                listeners : {
	                			 show:function( window, eOpts)	{
	                			 	detailForm.body.el.scrollTo('top',0);	
	                			 }
	                },
                    onCloseButtonDown: function() {
                        this.hide();
                    },
                    onDeleteDataButtonDown: function() {
                        var record = masterGrid.getSelectedRecord();
                        var phantom = record.phantom;
                        UniAppManager.app.onDeleteDataButtonDown();
                        var config = {success : 
                                    function()  {
                                        detailWin.hide();
                                    }
                            }
                        if(!phantom)    {
                            
                                UniAppManager.app.onSaveDataButtonDown(config);
                            
                        } else {
                            detailWin.hide();
                        }
                    },
                    onSaveDataButtonDown: function() {
                        var config = {success : function()	{
                        						var selRecord = masterGrid.getSelectedRecord();
                        						detailForm.loadForm(selRecord);				// 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.
                    						 	detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                    						 	detailWin.setToolbarButtons(['prev','next'],true);
                    						 	
                    					}
                    	}
                        UniAppManager.app.onSaveDataButtonDown(config);
                    },
                    onSaveAndCloseButtonDown: function() {
                        if(!detailForm.isDirty())   {
                            detailWin.hide();
                        }else {
                            var config = {success : 
                                        function()  {
                                            detailWin.hide();
                                        }
                                }
                            UniAppManager.app.onSaveDataButtonDown(config);
                        }
                    },
			        onPrevDataButtonDown:  function()   {
			            if(masterGrid.selectPriorRow()) {
	                        var record = masterGrid.getSelectedRecord();
	                        if(record) {
                                detailForm.loadForm(record);
                                
	                        }
                        }
			        },
			        onNextDataButtonDown:  function()   {
			            if(masterGrid.selectNextRow()) {
                            var record = masterGrid.getSelectedRecord();
                            if(record) {
                                detailForm.loadForm(record);
                               
                            }
                        }
			        }
				})
    		}
    		
			detailWin.show();
				
    }
    
    
    
//    var tab = Unilite.createTabPanel('bdc100ukrvtabPanel', {
//	    activeTab: 0,
//	    items: [
//	        masterGrid,
//	        detailForm
//	    ],
//	    listeners : {
//			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
//				var newTabId = newCard.getId();
//				var oldTabId = oldCard.getId();
//				
//				var edit = masterGrid.findPlugin('cellediting');
//				if(edit && edit.editing)	{
//					setTimeout("edit.completeEdit()", 1000);
//				}
//				var fp = Ext.getCmp('bdc100ukrvFileUploadPanel');
//				/* 저장여부 확인 */
//				if(directMasterStore.isDirty() || fp.isDirty())	{
//					if(confirm(Msg.sMB061))	{
//						UniAppManager.app.saveStoreEvent('TabChange', newCard);
//						return false;
//					} else {
//						UniAppManager.app.rejectSave();
//					}
//				}
//				//Tab 이동전 기존 Tab에서 확인해야할 사항
//				/*if(oldTabId =='bdc100ukrvDetail') {
//						// Tab 이동시 버튼 Setting
//						var fp = Ext.getCmp('bdc100ukrvFileUploadPanel');
//						var store = Ext.getCmp('bdc100ukrvGrid').getStore();
//						if(fp.isDirty())	{							
//							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
//								var addFiles = fp.getAddFiles();
//								var delFiles = fp.getRemoveFiles();
//								masterGrid.getSelectedRecord().set('ADD_FIDS',  addFiles)
//								masterGrid.getSelectedRecord().set('DEL_FIDS',  delFiles);
//								if(addFiles.length > 0 || delFiles.length > 0)	fp.uploadFiles();
//								
//								var inValidRecs = store.getInvalidRecords();
//								if(inValidRecs.length == 0 )	{
//									store.saveStore();	
//								}else {
//									store.saveStore();	
//									return false;
//								}
//									
//							}else {
//								Ext.getCmp('bdc100ukrvDetail').reset();
//								fp.clear();
//								UniAppManager.setToolbarButtons( 'newData', true);
//							}	
//						}
//						
//				}*/
//				if(newTabId =='bdc100ukrvDetail') {
//					var detailForm = Ext.getCmp('bdc100ukrvDetail');
//					selectedRec = masterGrid.getSelectedRecord();
//          			detailForm.setActiveRecord(selectedRec || null);   
//          			if(selectedRec)	{
//          				/*
//          				if( selectedRec.data['DOC_LEVEL1'])	{
//	          				detailDocLevel2Store.loadStoreRecords();
//	          				detailForm.setValue("DOC_LEVEL2", selectedRec.data['DOC_LEVEL2'])
//	          				if( selectedRec.data['DOC_LEVEL2'])	{
//		          				detailDocLevel3Store.loadStoreRecords();
//		          				detailForm.setValue("DOC_LEVEL3", selectedRec.data['DOC_LEVEL3'])
//	          				}
//          				}
//          				*/
//          				var selected_doc_no = selectedRec.data['DOC_NO'];
//          				bdc100ukrvService.getFileList({DOC_NO : selected_doc_no},
//																function(provider, response) {
//																	var fp = Ext.getCmp('bdc100ukrvFileUploadPanel');
//																	fp.loadData(response.result);
//																}
//															 )
//						
//          			}
//
//          			if(selectedRec)	{
//          				var param = {'DOC_NO': selectedRec.data['DOC_NO']};
//						bdc100ukrvService.updateReadCnt(param);
//          			}
//					
//				}
//				
//			}
//	    }
//	});  // tab

    Unilite.Main( {
		items:[ {
				  layout:'fit',
				  flex:1,
				  border:false,
				  items:[{
				  		layout:'border',
				  		border:false,
				  		items:[
				 		 masterGrid
						,panelSearch
						]}
					]
				}
		],
		fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
		},
		onQueryButtonDown:function () {
				directMasterStore.loadStoreRecords();	
				UniAppManager.setToolbarButtons( 'newData', true);
		},
		onNewDataButtonDown: function()	{
				openDetailWindow(null, true);
//				tab.setActiveTab(1);
//				var rowIndex = masterGrid.getSelectedRowIndex(0);
//				var r = directMasterStore.insertRecord(rowIndex);   
//		        masterGrid.select(rowIndex);	
//		        Ext.getCmp('bdc100ukrvFileUploadPanel').reset();
//				UniAppManager.setToolbarButtons( 'newData', false);
		},
		onResetButtonDown:function() {
				Ext.getCmp('searchForm').reset();
				masterGrid.reset();
				UniAppManager.setToolbarButtons( 'newData', true);
		},
		onSaveDataButtonDown: function (config) {
				var edit = masterGrid.findPlugin('cellediting');
				if(edit && edit.editing)	{
					//setTimeout("edit.completeEdit()", 1000);
                    edit.completeEdit();
                    Unilite.messageBox('수정중인 작업이 있습니다.');
                    return false;
				}
				this.getTopToolbar().down('#query').focus();
				var fp = Ext.getCmp('bdc100ukrvFileUploadPanel');
				var addFiles = fp.getAddFiles();
				var delFiles = fp.getRemoveFiles();
				console.log("addFiles : " , addFiles.length)
				
				if(addFiles.length > 0)	{
                    masterGrid.getSelectedRecord().set('ADD_FIDS', addFiles );
                } else {
                    masterGrid.getSelectedRecord().set('ADD_FIDS', '' );
                }
				
				if(delFiles.length > 0)	{
                    masterGrid.getSelectedRecord().set('DEL_FIDS', delFiles );
                } else {
                    masterGrid.getSelectedRecord().set('DEL_FIDS', '' );
                }
				
				//if(addFiles.length > 0 || delFiles.length > 0)	fp.uploadFiles();
                
				directMasterStore.saveStore(config);
		},
		onDeleteDataButtonDown: function() {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailForm.clearForm();
					masterGrid.deleteSelectedRow();
				}
		},
		onDetailButtonDown:function() {
			var as = panelSearch.down('#AdvanceSerch');	
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
														detailForm.setActiveRecord(selected || null);
														tab.setActiveTab(newCard);
													}
											 };
						break;
				}
				this.onSaveDataButtonDown(config);
		}// end saveStoreEvent()
		, confirmSaveData: function()	{
				var fp = Ext.getCmp('bdc100ukrvFileUploadPanel');
            	if(directMasterStore.isDirty())	{		//  || fp.isDirty()는 제거함 파일선택과 동시에 올라가므로, fid가 master table의 저장여부는 Master의 hidden필드(ADD_FIDS, DEL_FIDS)도 체크한다.
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
				
            },
		rejectSave: function()	{
				directMasterStore.rejectChanges();
				var fp = Ext.getCmp('bdc100ukrvFileUploadPanel');
				fp.getStore().rejectChanges();
				fp.clear();
				var rowIndex = masterGrid.getSelectedRowIndex();
				if(rowIndex >= 0){
					masterGrid.getSelectionModel().select(rowIndex);
					var selected = masterGrid.getSelectedRecord();
					detailForm.setActiveRecord(selected || null);
					var selected_doc_no = selected.data['DOC_NO'];
	  				bdc100ukrvService.getFileList({DOC_NO : selected_doc_no},
															function(provider, response) {															
																fp.loadData(response.result);
															}
														 )
				}
				directMasterStore.onStoreActionEnable();
				UniAppManager.setToolbarButtons('newData',true);
		}
	});
} // appMain
</script>
<form id="exportform" method="get" target="_blank">
        <input type="hidden" id="fid" name="fid" value="" />
        <input type="hidden" name="inline" value="N" />
</form>
