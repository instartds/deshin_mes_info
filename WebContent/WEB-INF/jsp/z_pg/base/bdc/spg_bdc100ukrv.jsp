<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="spg_bdc100ukrv"  >
<t:ExtComboStore items="${BDC100ukv_DEPT}" storeId="SPG_BDC100ukrvDeptStore" />
<t:ExtComboStore items="${BDC100ukv_CUSTOM}" storeId="SPG_BDC100ukrvCustomStore" />
<t:ExtComboStore comboType="AU" comboCode="B241"/>
<t:ExtComboStore comboType="AU" comboCode="CM10"/>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('spg_bdc100ukrvModel', {
	    fields: [
	             {name:'DOC_NO'			,text:'파일관리번호',	type:'string' , isPk:true, editable:false},
	             {name:'DOC_NAME'		,text:'파일관리명',		type:'string' , allowBlank:false},
	             {name:'DOC_DESC'		,text:'파일관리설명',	type:'string'},
	             {name:'REG_EMP'		,text:'등록자ID',		type:'string' , editable:false},
	             {name:'REG_EMP_NAME'	,text:'등록자',			type:'string' , editable:false},
	             {name:'REG_DEPT'		,text:'등록부서코드',	type:'string' , editable:false},
	             {name:'REG_DEPT_NAME'	,text:'등록부서',		type:'string' , editable:false},
	             {name:'REG_DATE'		,text:'등록일',			type:'uniDate' , editable:false},
	             {name:'CUSTOM_CODE'	,text:'거래처코드',		type:'string' },
	             {name:'CUSTOM_NAME'	,text:'거래처',			type:'string' },
	             {name:'PROJECT_NO'		,text:'영업기회번호',	type:'string' },
	             {name:'PROJECT_NAME'	,text:'영업기회명',		type:'string' },
	           
	             {name:'CHANNEL_DEPT'	,text:'채널',			type:'string' , store: Ext.data.StoreManager.lookup('SPG_BDC100ukrvDeptStore')},	 
	             {name:'CHANNEL_CUSTOM'	,text:'거래처(채널)',			type:'string' , store: Ext.data.StoreManager.lookup('SPG_BDC100ukrvCustomStore')},	
	             {name:'FILE_TYPE'		,text:'파일종류',		type:'string' , comboType:'AU',comboCode:'B241'},
	             
	             {name:'AUTH_LEVEL'		,text:'권한레벨',		type:'string' , defaultValue: 10, comboType:'AU', comboCode:'CM10', allowBlank:false},
	             {name:'READCNT'		,text:'조회수',			type:'int' 	  , editable:false},
	             {name:'REMARK'			,text:'비고',			type:'string' , editable:false},
	             {name:'ADD_FIDS'		,text:'등록파일',		type:'string' , editable:false},
	             {name:'DEL_FIDS'		,text:'삭제파일',		type:'string' , editable:false},
	             {name:'READ_ONLY'		,text:'수정여부',		type:'string' , editable:false}
	             
	            ]
	});
	

	var directMasterStore = Unilite.createStore('spg_bdc100ukrvStore', {
			model: 'spg_bdc100ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
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
	                	Ext.getCmp('spg_bdc100ukrvDetail').reset();			         
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
				//console.log("validate( ) ", this.getInvalidRecords()[0].validate( ) );
				//console.log("validate( ).items[0]['field']  ", this.getInvalidRecords()[0].validate( ).items[0]['field'] );
				console.log("store : ", this);
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					if(config==null)	{
						config = {success : 
											function()	{
												UniAppManager.setToolbarButtons( 'newData', true);
												detailForm.setActiveRecord(masterGrid.getSelectedRecord() || null); 
												detailForm.setReadOnly(masterGrid.getSelectedRecord().get('READ_ONLY'));
											}
									}
					}
					this.syncAll(config);
					
				}else {
					alert(Msg.sMB083);
				}
			},insertRecord : function(index)	{
            	 var r =  Ext.create ('spg_bdc100ukrvModel', {
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
	var searchOptStore = Unilite.createStore('SPG_Bdc100ukrvSearchOptStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'파일관리명+내용'	, 'value':'1'},
			        {'text':'파일관리명'		, 'value':'2'},
			        {'text':'파일명'		, 'value':'3'}
	    		]
		});
		       
	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */     
  	var panelSearch = Unilite.createSearchForm('searchForm', {
        
            //layout : {type : 'vbox' , align: 'stretch' },
  			layout : {type : 'uniTable', columns : 3},
            items :[
				        		{ fieldLabel: '등록일자'
					               ,xtype: 'uniDateRangefield'
					               ,startFieldName: 'REG_DATE_FR'
					               ,endFieldName: 'REG_DATE_TO'	
					               ,width: 320
					               //,startDate: UniDate.get('startOfMonth')
					               ,startDate: UniDate.get('startOfYear')
					               ,endDate: UniDate.get('today')
				            	 }
				            	,{ fieldLabel: '검색조건 '
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,width: 470
					               ,colspan:2
					               ,defaults: { hideLabel: true}
					               ,items: [
						               		 {fieldLabel: 'Select Option'	,name:'SEARCH_OPTION'	,xtype:'uniCombobox', width:150, value:'1', store: Ext.data.StoreManager.lookup('SPG_Bdc100ukrvSearchOptStore'), margin: '0 2 0 0', allowBlank:false }
						                    
						                    ,{fieldLabel: 'Search Text'		,name:'SEARCH_TEXT' 	,xtype:'uniTextfield' , width:230}		                   
					                	   ]
					               
				            	 }
				            	,{ fieldLabel: '등록부서'  ,	name: 'REG_DEPT_NAME'}
				       			,{ fieldLabel: '등록자'  ,		name: 'REG_EMP_NAME',colspan:2}
				       			
				       			/*	, Unilite.popup('DEPT',{fieldLabel:'등록부서', valueFieldName:'REG_DEPT_NAME', textFieldName:'REG_DEPT', valueFieldWidth:85, textFieldWidth:160, validateBlank: false}) 
				            	    , Unilite.popup('USER',{fieldLabel:'등록자'  , valueFieldName:'REG_EMP_NAME' , textFieldName:'REG_EMP', valueFieldWidth:85, textFieldWidth:160, validateBlank: false, colspan:2}) 
					       		*/
				       			,{ fieldLabel: '채널',			 name: 'CHANNEL_DEPT',		xtype:'uniCombobox', 
				       				store: Ext.data.StoreManager.lookup('SPG_BDC100ukrvDeptStore'), child: 'CHANNEL_CUSTOM'	
				       			 }
				       			,{ fieldLabel: '거래처',		 name: 'CHANNEL_CUSTOM',		xtype:'uniCombobox', 
				       				store: Ext.data.StoreManager.lookup('SPG_BDC100ukrvCustomStore')
				       			  }
				       			,{ fieldLabel: '파일종류' ,		 name: 'FILE_TYPE',		xtype:'uniCombobox', 
				       			   comboType:'AU',comboCode:'B241'}
			       			

        			]
        
    }); // createSearchForm

       /**
		 * Master Grid 정의(Grid Panel)
		 * 
		 * @type
		 */ 

    var masterGrid = Unilite.createGrid('spg_bdc100ukrvGrid', {
        title: '기본',
        layout : 'fit',
        uniOpt:{
        	store : directMasterStore
        },
    	store: directMasterStore,
        columns:  [ 
        			 {dataIndex:'DOC_NO'		,width: 100 },
		             {dataIndex:'DOC_NAME'		,width: 250 },
		             {dataIndex:'REG_EMP_NAME'		,width: 80 },
		             {dataIndex:'REG_DEPT_NAME'	,width: 100 },
		             {dataIndex:'REG_DATE'		,width: 100 },
		             {dataIndex:'READCNT'		,width: 60 }
          ],
       listeners: {	
          		selectionchange: function( grid, selected, eOpts ) {
          			var detailForm = Ext.getCmp('spg_bdc100ukrvDetail');
          			detailForm.setActiveRecord(selected[0] || null);   
          			
          			if(selected[0])	{          				
          				if(selected[0].phantom != true) {
          					detailForm.setReadOnly(selected[0].get('READ_ONLY'));
	          				var selected_doc_no = selected[0].data['DOC_NO'];
	          				var tab = this.up('tabpanel').getActiveTab();
	          				if(Unilite.nvl(selected_doc_no,false) && tab.getId() == 'spg_bdc100ukrvDetail' )	{
		          				bdc100ukrvService.getFileList({DOC_NO : selected_doc_no},
																		function(provider, response) {
																			var fp = Ext.getCmp('spg_bdc100ukrvFileUploadPanel');
																			fp.loadData(response.result);
																		}
																	 )
	          				}
          				} else {
          					bdc100ukrvService.getFileList({DOC_NO : ''},
																		function(provider, response) {
																			var fp = Ext.getCmp('spg_bdc100ukrvFileUploadPanel');
																			fp.clear();
																		}
																	 )
          				}
						
          			}
        			         			  
  				},  // selectionchange
  				onGridDblClick: function(grid, record, cellIndex, colName) {
  					var tabPanel = Ext.getCmp('spg_bdc100ukrvtabPanel');
  					tabPanel.setActiveTab(1);
  					console.log('dblclick');

  				},
  				beforeedit : function ( editor, e, eOpts )	{  					
  					if(e.record.data['READ_ONLY'] == 'true')	 {
  						console.log('beforeedit e : ', e.record.data['READ_ONLY']);
  						return false;
  					}

  				}
         } // listeners
         
    });  // masterGrid
    
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
      
      var detailForm = Unilite.createForm('spg_bdc100ukrvDetail', {
    	// to Make TAB
    	  title: '상세'
        , autoScroll:true         
        , layout : 'fit'
	    , layout: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}}
	    , masterGrid: masterGrid
		, items :[	 
					 {fieldLabel: '파일관리번호'		, name: 'DOC_NO', colspan : 3},
					 {xtype:'button', text:'바로가기 생성',  colspan : 1,
					 	handler: function() {
					 		this.up('form').makeLink();
					 	}
					 }
					,{fieldLabel: '파일관리명'			, name: 'DOC_NAME', width:800, colspan : 4, allowBlank:false}
					,{fieldLabel: '파일관리설명' 		, name: 'DOC_DESC',	xtype: 'textarea', width:800, height:130,	colspan : 4}
					,{fieldLabel: '등록자'			, name: 'REG_EMP_NAME', readOnly:true, width:220}
					,{fieldLabel: '등록부서'		, name: 'REG_DEPT_NAME', readOnly:true, width:220}
					,{fieldLabel: '등록일'			, name: 'REG_DATE', xtype : 'uniDatefield',  readOnly:true, width:220}
					,{fieldLabel: '권한레벨'		, name: 'AUTH_LEVEL', xtype:'uniCombobox',comboType:'AU', comboCode:'CM10', allowBlank:false, width:140, labelWidth:60}
					
	       			,{ fieldLabel: '채널',		name: 'CHANNEL_DEPT',		xtype:'uniCombobox',  width:220,
				       				store: Ext.data.StoreManager.lookup('SPG_BDC100ukrvDeptStore'), child: 'CHANNEL_CUSTOM'	
	       			 }
	       			,{ fieldLabel: '거래처',		 name: 'CHANNEL_CUSTOM',		xtype:'uniCombobox',  width:220,
	       				store: Ext.data.StoreManager.lookup('SPG_BDC100ukrvCustomStore')
	       			  }
	       			,{ fieldLabel: '파일종류' ,		name: 'FILE_TYPE',		xtype:'uniCombobox',  colspan:2,
	       			   comboType:'AU',comboCode:'B241'}
					,{ fieldLabel: ' '  ,	 xtype:'displayfield', align:'left', colspan:4}
					,{ 
				     			xtype:'xuploadpanel',
				     			id : 'spg_bdc100ukrvFileUploadPanel',
						    	itemId:'fileUploadPanel',						    	
						    	flex:1,
						    	colspan:4,
						    	width: 800,
						    	height:200,
						    	listeners : {
						    		change: function() {
						    			UniAppManager.setToolbarButtons('save', true);
						    		}
						    	}
						    	
					}		
					
		   ],
		         
         setReadOnly: function(t)	{
         	var b = false;
         	if(t=='true') {
         		b=true;
         	}
         	this.getField('DOC_NAME').setReadOnly(b); 
         	this.getField('DOC_DESC').setReadOnly(b);
         	this.getField('AUTH_LEVEL').setReadOnly(b);
         	
         	this.getField('CHANNEL_DEPT').setReadOnly(b);
         	this.getField('CHANNEL_CUSTOM').setReadOnly(b);
         	this.getField('FILE_TYPE').setReadOnly(b);
//		         	var fp = Ext.getCmp('spg_bdc100ukrvFileUploadPanel');
         	var fp = this.down('xuploadpanel');
         	fp.setReadOnly( b );
         },
		   makeLink: function() {
		   	 	var win = Ext.create('widget.window', {
		                title: '바로가기 생성',
					    modal: true,
					    closable: false,
		                header: {
		                    titlePosition: 2,
		                    titleAlign: 'left'
		                },
		                closeAction: 'hide',
		                width: 500,				                
		                height: 220,
		                layout: {
		                    type: 'fit',
		                    padding: 0
		                },		         
		                items: [downloadLinkDetail]
					});
					var iForm = win.down('form');
					iForm.setValue('DOC_NO',this.getValue('DOC_NO'));

					var params = {'DOC_NO' : this.getValue('DOC_NO')};
					bdc100ukrvService.makeExtLink(params,{
						success: function(rec) {
							console.log("rec:" , rec.data.url);
							iForm.setValue('URL', rec.data.url);
						}
					});
						
					if(clipper == undefined) {
							clipper = new ZeroClipboard(document.getElementById('d_clip_button'));
							clipper.on( 'ready', function(event) {
								console.log( 'movie is loaded' );
								clipper.on( 'copy', function(event) {
									var frm = win.down('form')
									var txt = frm.getValue('URL');
									
						          	event.clipboardData.setData('text/plain', txt);
									console.log( 'copied' );
						        } );
						        clipper.on( "aftercopy", function( event ) {
								    alert("바로가기 주소가 복사 되었습니다./n " + event.data["text/plain"] );
								  } );
							});// clipper.on
							
							clipper.on( 'error', function(event) {
						        alert( '바로가기 복사기능을 사용하기위한 Adobe flashplayer가 설치 되어있지 않습니다./n "' + event.name + '": ' + event.message );
						        ZeroClipboard.destroy();
						     } );
					}
				win.show();
		   }
	});
	var downloadLinkDetail = Ext.create('Unilite.com.form.UniDetailFormSimple', {
	    autoScroll:true,
	    flex: 1,
	    tbar: ['->',
	        { 	xtype: 'button', 
	        	text: '닫기', 
	        	handler: function(btn, evt) {
	        		this.up('.window').close();
	        	}
	        }
        ],
		fieldDefaults: {
			readOnly: true
		},
		layout: {
	    	type:'vbox' , 
       		align: 'stretch'
	    },
		defaultType: 'displayfield',
	    items: [ 
	    	{ value: '아래와 같이 바로가기가 생성 되었습니다. 복사 버튼을 이용해 주소를 복사하시면 됩니다.'},
			{	xtype:'container',	
				margin: '5 0 5 0',
			    layout: {
			        align: 'middle',
			        pack: 'center',
			        type: 'hbox'
			    },
				items: [
					{
						contentEl:'d_clip_button'
					}
				]
			},
			{xtype: 'fieldset',
				defaultType: 'displayfield',
				layout: {
			    	type:'uniTable' ,  
			    	columns: 2, 
		        	tableAttrs: {
			            style: {
			                width: '100%'
			            }
			         }
			    },
				items:[
		    		{fieldLabel: '파일관리번호',	name: 'DOC_NO'},
		    		{fieldLabel: '작성자',			name: 'C_OWNER',  value: UserInfo.userName },
		    		{fieldLabel: '다운로드가능기간',name: 'C_EXPIRE_DATE', colspan:2,  
		    			value: moment().add('day',7).format('YYYY.MM.DD')},
		    		{fieldLabel: '바로가기',		name: 'URL',   value:'', colspan:2, }
	    		]
			}
	    ]
	});
    var tab = Unilite.createTabPanel('spg_bdc100ukrvtabPanel',{
	    activeTab: 0,
	    items: [
	        masterGrid,
	        detailForm
	    ],
	    listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				var oldTabId = oldCard.getId();
				
				var fp = Ext.getCmp('spg_bdc100ukrvFileUploadPanel');
				/* 저장여부 확인 */
				if(directMasterStore.isDirty() || fp.isDirty())	{
					if(confirm(Msg.sMB061))	{
						UniAppManager.app.saveStoreEvent('TabChange', newCard);
						return false;
					} else {
						UniAppManager.app.rejectSave();
					}
				}
				

				if(newTabId =='spg_bdc100ukrvDetail') {
					var detailForm = Ext.getCmp('spg_bdc100ukrvDetail');
					var selectedRec = masterGrid.getSelectedRecord();
          			detailForm.setActiveRecord(selectedRec || null);
          			
          			if(selectedRec)	{
          				detailForm.setReadOnly(selectedRec.get('READ_ONLY'));
          				var selected_doc_no = selectedRec.data['DOC_NO'];
          				if(Unilite.nvl(selected_doc_no,false))	{
          					bdc100ukrvService.getFileList({DOC_NO : selected_doc_no},
																	function(provider, response) {
																	var fp = Ext.getCmp('spg_bdc100ukrvFileUploadPanel');
																	fp.loadData(response.result);
																}
															 )
          				}
						
          			}
          			//조회수 update
					if(selectedRec)	{
						if(selectedRec.data['DOC_NO']!=null && selectedRec.data['DOC_NO'] != '')	{
	          				var param = {'DOC_NO': selectedRec.data['DOC_NO']};
							bdc100ukrvService.updateReadCnt(param);
						}
          			}
				}
				
			}
	    }
	});

    Unilite.Main( {
    		 id  : 'spg_bdc100ukrvApp',
			 items 	: [ panelSearch, tab]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'], true);
			}
			,onQueryButtonDown:function () {
				directMasterStore.loadStoreRecords();	
				UniAppManager.setToolbarButtons( 'newData', true);
			}
			,onNewDataButtonDown: function()	{
				tab.setActiveTab(1);
				var rowIndex = masterGrid.getSelectedRowIndex(0);
				var r = directMasterStore.insertRecord(rowIndex);   
		        masterGrid.select(rowIndex);
				var fp = Ext.getCmp('spg_bdc100ukrvFileUploadPanel');
				detailForm.setReadOnly('false');
				fp.clear();
				UniAppManager.setToolbarButtons( 'newData', false);
			},
			onResetButtonDown:function() {
				panelSearch.reset();
				masterGrid.reset();
				detailForm.clearForm();
				var fp = Ext.getCmp('spg_bdc100ukrvFileUploadPanel');
				fp.clear();
				UniAppManager.setToolbarButtons( 'newData', true);
			},
			onSaveDataButtonDown: function (config) {
				var fp = Ext.getCmp('spg_bdc100ukrvFileUploadPanel');
				var addFiles = fp.getAddFiles();
				var delFiles = fp.getRemoveFiles();
				console.log(addFiles.length)
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
				//if(addFiles.length > 0 || delFiles.length > 0)	
				//fp 의 dirty 값 리셋
				fp.uploadFiles();
				directMasterStore.saveStore(config);
			},
			onDeleteDataButtonDown: function() {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailForm.clearForm();
					masterGrid.deleteSelectedRow();
				}
			},
			onDetailButtonDown:function() {
				var as = Ext.getCmp('spg_bdc100ukrvAdvanceSerch');	
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
														if(selected)  detailForm.setReadOnly(selected.get('READ_ONLY'));
														tab.setActiveTab(newCard);
													}
											 };
						break;
				}
				this.onSaveDataButtonDown(config);
			}, // end saveStoreEvent()
			rejectSave: function()	{
				directMasterStore.rejectChanges();
				var fp = Ext.getCmp('spg_bdc100ukrvFileUploadPanel');
				fp.getStore().rejectChanges();
				fp.clear();
				var rowIndex = masterGrid.getSelectedRowIndex();
				if(rowIndex >= 0){
					masterGrid.getSelectionModel().select(rowIndex);
					var selected = masterGrid.getSelectedRecord();
					detailForm.setActiveRecord(selected || null);
					var selected_doc_no = '';
					if(selected) {
						detailForm.setReadOnly(selected.get('READ_ONLY'));
						selected_doc_no = selected.data['DOC_NO'];
					}
	  				bdc100ukrvService.getFileList({DOC_NO : selected_doc_no},
															function(provider, response) {															
																fp.loadData(response.result);
															}
														 )
				}
				directMasterStore.onStoreActionEnable();
				UniAppManager.setToolbarButtons('newData',true);
			} // end rejectSave()
		
		});

};
</script>
<form id="exportform" method="get" target="_blank">
        <input type="hidden" id="fid" name="fid" value="" />
        <input type="hidden" name="inline" value="N" />
</form>
<div id="d_clip_button">복사</div>