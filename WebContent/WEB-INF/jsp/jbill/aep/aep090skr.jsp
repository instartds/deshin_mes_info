<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep090skrService"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="B602"/>				<!-- 게시유형  	-->  
	<t:ExtComboStore comboType="AU" comboCode="B603"/>				<!-- 게시대상  	-->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var noticeDetailGridWindow;  //공지사항 내용

function appMain() {     
	//var gsBaseMonthHidden = true;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aep090skrService.selectList',
			//update: 'aep090skrService.updateList',
			//create: 'aep090skrService.insertList
			destroy: 'aep090skrService.deleteList',
			syncAll: 'aep090skrService.saveAll'
		}
	});	
	
	
	Unilite.defineModel('aep090skrModel', {
	    fields: [{name: 'COMP_CODE'    		,text:'COMP_CODE'		,type : 'string', defaultValue: UserInfo.userID}, 
				 {name: 'FROM_DATE'    		,text:'게시일'			,type : 'uniDate', editable: false},
				 {name: 'BULLETIN_ID'    	,text:'등록번호'		,type : 'string'},
				 {name: 'TO_DATE'    		,text:'게시종료일'		,type : 'uniDate'}, 
				 {name: 'USER_ID'    		,text:'게시자'			,type : 'string', allowBlank: false, editable: false},
				 {name: 'USER_NAME'	 		,text:'게시자' 			,type : 'string'},
				 {name: 'TYPE_FLAG'    		,text:'게시유형'		,type : 'string', comboType: 'AU', comboCode: 'B602'}, 
				 {name: 'AUTH_FLAG'    		,text:'게시대상'		,type : 'string', comboType: 'AU', comboCode: 'B603'}, 
				 {name: 'DIV_CODE'    		,text:'사업장'			,type : 'string', comboType: 'BOR120', defaultValue: UserInfo.divCode}, 
				 {name: 'DEPT_CODE'    		,text:'부서코드'		,type : 'string'},
				 {name: 'DEPT_NAME'    		,text:'부서'			,type : 'string'},
				 {name: 'OFFICE_CODE'   	,text:'영업소'			,type : 'string', comboType: 'AU', comboCode: 'GO01'}, 
				 {name: 'TITLE'    			,text:'제목'			,type : 'string', allowBlank: false, editable: false}, 
				 {name: 'CONTENTS'    		,text:'내용'			,type : 'string', editable: false}, 
				 {name: 'ACCESS_CNT'    	,text:'조회횟수'		,type : 'int'}				 
			]
	}); //End of Unilite.defineModel('aep080ukrServiceImplModel1', {

	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */	
	  
	var directMasterStore = Unilite.createStore('aep090skrMasterStore',{
		model: 'aep090skrModel',
		uniOpt: {
					isMaster: true,				// 상위 버튼 연결 
		        	editable: false,				// 수정 모드 사용 
		        	deletable: false,			// 삭제 가능 여부 
		            useNavi: false				// prev | newxt 버튼 사용
            },
        autoLoad: false,
        proxy: directProxy,
//         proxy: {
//            type: 'direct',
//            api: {			
//                read: 'aep090skrService.selectMasterList'                	
//            }
//         }, 
		loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		},
        saveStore	: function()	{				
			var inValidRecs = this.getInvalidRecords();	
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		
//			DIVERT_DIVI에 따른 필수 체크
//        	var list = [].concat(toUpdate,toCreate);
//       	if(fnCheckReqiured(list)) return false;
			
			if(inValidRecs.length == 0 )	{
				config = {
					success: function(batch, option) {
						UniAppManager.app.onQueryButtonDown();
					 } 
				};
				this.syncAllDirect(config);				
			}else {    				
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners	: {
			load: function(store, records, successful, eOpts) {
				
           	}				
		}	
	}); //End of var directMasterStore = Unilite.createStore('aep080ukrServiceImplMasterStore1',{
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '공지사항',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
			title: '검색조건', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield', 
	    	items:[{
	    		xtype: 'uniTextfield',
	    		fieldLabel: '제목',
	    		name: 'TITLE',
	    		//hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COMPANY_NUM', newValue);
					}
				}	    		
	    	},{
	    		xtype: 'uniTextfield',
	    		fieldLabel: '게시자',
	    		name: 'USER_ID',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('USER_ID', newValue);
					}
				}
	    	},{
	    		fieldLabel: '게시일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'DATE_FR',
			    endFieldName: 'DATE_TO',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DATE_FR', newValue);
						panelResult.setValue('DATE_TO', newValue);
					}
				}				
			},{	    
				fieldLabel: '게시시작일',
				xtype: 'uniDatefield',				
				name: 'FROM_DATE',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FROM_DATE', newValue);
					}
				}
			},{	    
				fieldLabel: '게시종료일',
				xtype: 'uniDatefield',			
				name: 'TO_DATE',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TO_DATE', newValue);
					}
				}
			},{	    
				fieldLabel: '게시유형',
				name: 'TYPE_FLAG',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B602',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TYPE_FLAG', newValue);
					}
				}	
			},{	    
				fieldLabel: '게시대상',
				name: 'AUTH_FLAG',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B603',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AUTH_FLAG', newValue);
					}
				}	
			}]				
		}]

	});	//end panelSearch     
    
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
	    		xtype: 'uniTextfield',
	    		fieldLabel: '제목',
	    		name: 'TITLE',
	    		//hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COMPANY_NUM', newValue);
					}
				}	    		
	    	},{
	    		xtype: 'uniTextfield',
	    		fieldLabel: '게시자',
	    		name: 'USER_ID',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('USER_ID', newValue);
					}
				}
	    	},{
	    		fieldLabel: '게시일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'DATE_FR',
			    endFieldName: 'DATE_TO',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DATE_FR', newValue);
						panelSearch.setValue('DATE_TO', newValue);
					}
				}				
			},{	    
				fieldLabel: '게시시작일',
				xtype: 'uniDatefield',				
				name: 'FROM_DATE',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('FROM_DATE', newValue);
					}
				}
			},{	    
				fieldLabel: '게시종료일',
				xtype: 'uniDatefield',			
				name: 'TO_DATE',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TO_DATE', newValue);
					}
				}
			},{	    
				fieldLabel: '게시유형',
				name: 'TYPE_FLAG',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B602',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TYPE_FLAG', newValue);
					}
				}	
			},{	    
				fieldLabel: '게시대상',
				name: 'AUTH_FLAG',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B603',
	    		hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AUTH_FLAG', newValue);
					}
				}	
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
					} else {
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			}	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aep090skrGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{	useGroupSummary: false,
		    		useLiveSearch: true,
					useContextMenu: false,
					useMultipleSorting: true,
					useRowNumberer: true,
					expandLastColumn: true,
					onLoadSelectFirst: true,
					copiedRow:true                  
		        },
        selModel:'rowmodel',
		columns:[
				 {dataIndex: 'TO_DATE'    		,width: 100, hidden: true },
				 {dataIndex: 'TITLE'    		,width: 300},
				 {dataIndex: 'CONTENTS'    		,width: 680},
				 {dataIndex: 'USER_ID'    		,width: 100, hidden: true },
				 {dataIndex: 'USER_NAME'        ,width: 100},
				 {dataIndex: 'FROM_DATE'    	,width: 100},
				 {dataIndex: 'TYPE_FLAG'    	,width: 100, hidden: true },
				 {dataIndex: 'AUTH_FLAG'    	,width: 100, hidden: true },
				 {dataIndex: 'DIV_CODE'    		,width: 130, hidden: true },
				 {dataIndex: 'DEPT_CODE'    	,width: 100, hidden: true },
				 {dataIndex: 'DEPT_NAME'    	,width: 100, hidden: true },
				 {dataIndex: 'BULLETIN_ID'    	,width: 400, hidden: true }
		],
		listeners: {	
      		selectionchangerecord: function( selected ) {
      			//detailForm.setActiveRecord(selected);
			}/*,
			beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
        		var columnName = view.eventPosition.column.dataIndex;
        			if(columnName == 'CONTENTS'){
                    	noticeDetailForm.setValue('TITLE', record.get('TITLE'));
                    	noticeDetailForm.setValue('CONTENTS', record.get('CONTENTS'));
                    	noticeDetailForm.setValue('BULLETIN_ID', record.get('BULLETIN_ID'));
                    	    			
	        			opennoticeDetailGridWindow();
        			} else if (columnName == 'TITLE') {
						var params = {
							appId: UniAppManager.getApp().id,
							sender: this,
							action: 'new',
							TITLE: record.get('TITLE'),
							CONTENTS: record.get('CONTENTS'),
							BULLETIN_ID: record.get('BULLETIN_ID')
						}
						var rec = {data : {prgID : 'aep080ukr', 'text':''}};									
						parent.openTab(rec, '/jbill/aep080ukr.do', params);	
        			} else{
	        			return false;
        			}
        	}*/,
      		onGridDblClick: function(grid, record, cellIndex, colName) {
            	noticeDetailForm.setValue('TITLE', record.get('TITLE'));
            	noticeDetailForm.setValue('CONTENTS', record.get('CONTENTS'));
            	noticeDetailForm.setValue('BULLETIN_ID', record.get('BULLETIN_ID'));
                    	    			
	        	opennoticeDetailGridWindow();
	        	
/*				//화면이동
				var params = {
					appId: UniAppManager.getApp().id,
					sender: this,
					action: 'new',
					ACCNT_CODE: record.get('ACCNT'),
					ACCNT_NAME: record.get('ACCNT_NAME')
				}
				var rec = {data : {prgID : 'aba410ukr', 'text':''}};									
				parent.openTab(rec, '/accnt/aba410ukr.do', params);	*/	
          	}        	
        }
    });

    var noticeDetailForm = Unilite.createForm('noticeDetailForm',{
//      split:true,
        region: 'center',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
//        border:true,
        disabled:false,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            padding:'10 10 10 10',
            items :[{
				fieldLabel: '제목',
				name:'TITLE',
				xtype: 'uniTextfield',
				width: 980,
				readOnly: true
				},{
				fieldLabel: '내용',
				name:'CONTENTS',
				xtype: 'textareafield',
				width: 980,
				height: 400,
				readOnly: true	
				},{
				fieldLabel: '등록번호',
				name:'BULLETIN_ID',
				xtype: 'uniTextfield',
				readOnly: true,
				hidden: true
				}]
        }]
    });
    
    function opennoticeDetailGridWindow() {          

        if(!noticeDetailGridWindow) {
            noticeDetailGridWindow = Ext.create('widget.uniDetailWindow', {
                title: '공지사항',
                width: 1100,                                
                height: 510,
                layout:{type:'vbox', align:'stretch'},
                items: [noticeDetailForm],
                tbar:  [
                    '->',/*{
//                        itemId : 'Btn',
                        text: '확인',
                        handler: function() {
                        	if(!elecSlipTransForm.getInvalidMessage()) return; 
                        	
                        	var searchRecords = directMasterStore.data.items;
                        	buttonStore.clearData();
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                    record.phantom = true;
                                    buttonStore.insert(i, record);
                                }
                            });
                            
                            buttonFlag = 'btnConf';
                            preEmpNo = searchForm.getValue('CARD_EXPENSE_ID');
                            nxtEmpNo =  elecSlipTransForm.getValue('PERSON_NUMB');
                            transDesc = elecSlipTransForm.getValue('TRANS_DESC');
                            
                            buttonStore.saveStore();
                        	
                            noticeDetailGridWindow.hide();
//                          draftNoGrid.reset();
                          	noticeDetailForm.clearForm();
                        },
                        disabled: false
                    },*/{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            noticeDetailGridWindow.hide();
                          	noticeDetailForm.clearForm();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    show: function ( panel, eOpts ) {
//                    	bankAccountDetailForm.setValue('BANK_CODE', record.get('BANK_CODE'));
                    }
                }
            })
        }
        noticeDetailGridWindow.center();
        noticeDetailGridWindow.show();
    } 
    
    
	Unilite.Main( {
		borderItems:[{
			border: false,
			region: 'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]
		}	 
		,panelSearch
		],
		id  : 'aep080ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',false);
			//UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);			
		},
		onQueryButtonDown : function()	{		
			masterGrid.getStore().loadStoreRecords();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore();
		}	
	});
};


</script>
