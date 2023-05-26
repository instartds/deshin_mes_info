<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbs960ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var checkCount = 0;

function appMain() {
	
	Ext.create('Ext.data.Store', {
	storeId:"gubun",
    fields: ['text', 'value'],
    data : [
        {text:"중도퇴사",   value:"Y"},
        {text:"연말정산", 	value:"N"}
    	]
    });
	
	var InsurStore = Unilite.createStore('InsurStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'국민연금'	, 'value':'1'},
			        {'text':'건강보험'	, 'value':'2'},
			        {'text':'고용보험'	, 'value':'3'}			       
	    		]
	});
    // Direct Proxy 정의
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {

            read: 'hbs960ukrService.selectList',
            update: 'hbs960ukrService.update',
            create: 'hbs960ukrService.insert',
            syncAll: 'hbs960ukrService.saveAll'
        }
    });
    

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hbs960ukrModel', {
	   fields: [
			{name: 'CHOICE'				, text: '선택'				, type: 'boolean'},
			{name: 'CLOSE_ALL_YN'    	, text: '전체마감'				, type: 'string'},
			{name: 'CLOSE_PERSON_YN'   	, text: '개인마감'				, type: 'string'},
			{name: 'CLOSE_ALL_NAME'   	, text: '전체마감'				, type: 'string'},
			{name: 'CLOSE_PERSON_NAME'  , text: '개인마감'				, type: 'string'},
			{name: 'YEAR_YYYY'		    , text: '정산년도'				, type: 'string'},
			{name: 'DIV_CODE'   		, text: '사업장'				, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_CODE'   		, text: '부서코드'				, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'				, type: 'string'},
			{name: 'POST_NAME'			, text: '직위'				, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string'},
			{name: 'NAME'				, text: '성명'				, type: 'string'},
			{name: 'HALFWAY_TYPE'		, text: '정산구분'				, type: 'string'},
			{name: 'JOIN_DATE'			, text: '입사일'				, type: 'uniDate'},
			{name: 'RETR_DATE'			, text: '퇴사일'				, type: 'uniDate'}
	    ]
	});		// End of Ext.define('hbs960ukrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hpa300MasterStore',{
		model: 'hbs960ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
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
            var list = [].concat(toUpdate, toCreate);
 			console.log("inValidRecords : ", inValidRecs);
 			if(inValidRecs.length == 0 )	{
 				var paramMaster= panelSearch.getValues();   //syncAll 수정
 				var personNumbArr = new Array();
 				Ext.each(list, function(record, idx){
 					if(record.get("CLOSE_PERSON_YN") == "Y")	{
 	 					personNumbArr.push(record.get("PERSON_NUMB"))
 					}
 				});
 				paramMaster.personNumbArr = personNumbArr
 				hbs960ukrService.checkInstallmentPay(paramMaster, function(responseText){
 					if(responseText && responseText.length == 0)	{
	 					config = {
	 	                        params: [paramMaster],
	 	                        success: function(batch, option) {
	 	                        	UniAppManager.app.onQueryButtonDown();
	 	                        }
	 	                };
	 	 				//this.syncAllDirect(config);	
 					} else if(responseText && responseText.length > 0) {
 						var message = "";
 						Ext.each(responseText, function(record, idx){
 		 	 				message += record.NAME + "("+record.PERSON_NUMB+") \n";
 		 				});
 						Unilite.messageBox("연말정산분납 급여반영 내역이 있습니다.",message);
 					}
 				});
 				
 			}else {
 				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
 			}
 		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '기준년도',
                name: 'BASE_YEARS',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('BASE_YEARS', newValue);   
                    }
                }
			},{
				fieldLabel: '정산구분',
				name: 'RETR_TYPE', 
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('gubun'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('RETR_TYPE', newValue);
                    }
                }
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('YEAR_YYYY', newValue);
                    }
                }
			},Unilite.popup('DEPT',{
			  fieldLabel: '부서',
			  textFieldWidth: 170,
			  valueFieldName: 'DEPT_CODE',
			  textFieldName: 'DEPT_NAME',
			  validateBlank: false,
			  popupWidth: 710,
		      listeners: {
		      	  onSelected: {
                      fn: function(records, type) {
                          panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
                          panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                      },
                      scope: this
                  },
                  onClear: function(type) {
                      panelResult.setValue('DEPT_CODE', '');
                      panelResult.setValue('DEPT_NAME', '');
                      panelSearch.setValue('DEPT_CODE', '');
                      panelSearch.setValue('DEPT_NAME', '');
                  }
              }
			}),
		
				Unilite.popup('Employee', {
				textFieldWidth: 170, 
				validateBlank: false,
				valueFieldName: 'PERSON_NUMB',
                textFieldName: 'NAME',
				extParam: {'CUSTOM_TYPE': '3'},
				listeners: {
                     onSelected: {
                      fn: function(records, type) {
                          panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
                          panelResult.setValue('NAME', panelSearch.getValue('NAME'));
                      },
                      scope: this
                      },
                      onClear: function(type) {
                          panelResult.setValue('PERSON_NUMB', '');
                          panelResult.setValue('NAME', '');
                          panelSearch.setValue('PERSON_NUMB', '');
                          panelSearch.setValue('NAME', '');
                      }
                }
			})]
		},{	
			title: '추가정보', 	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [		
			{
		    	xtype: 'container',
		    	padding: '10 0 0 0',
		    	width: 300,
		    	layout: {
		    		type: 'hbox',
					align: 'center',
					pack:'center'
		    	},
		    	items:[{
		    		xtype: 'button',
		    		id: 'select',
		    		text: '전체선택',
		    		width: 100,
// 					margin: '0 0 0 110',
		    		handler: function(){
		    			var record = directMasterStore.data.items.length;
                        if(!Ext.isEmpty(record) && record == 0 ){
                            alert('선택할 데이터가 없습니다.');
                            return false;
                        }else{
                            SelectAll();
                        }			
		    		}
		    	},{
		    		xtype: 'button',
		    		id: 'deselect',
		    		text: '전체해제',
		    		width: 100,
// 					margin: '0 0 0 110',
		    		hidden: true,
		    		handler: function(){			    						    		
		    			DeSelectAll();  			
		    		}
		    	}]
		    }	    	
			]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm', {        
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '기준년도',
                name: 'BASE_YEARS',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BASE_YEARS', newValue);   
                    }
                }
            },{
				fieldLabel: '정산구분',
				name: 'RETR_TYPE', 
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('gubun'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('RETR_TYPE', newValue);
                    }
                }
            },{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                colspan:2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },Unilite.popup('DEPT',{
              fieldLabel: '부서',
              valueFieldName: 'DEPT_CODE',
              textFieldName: 'DEPT_NAME',
              textFieldWidth: 170,
              validateBlank: false,
              popupWidth: 710,
              listeners: {
                   onSelected: {
                      fn: function(records, type) {
                          panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
                          panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                      },
                      scope: this
                  },
                  onClear: function(type) {
                      panelResult.setValue('DEPT_CODE', '');
                      panelResult.setValue('DEPT_NAME', '');
                      panelSearch.setValue('DEPT_CODE', '');
                      panelSearch.setValue('DEPT_NAME', '');
                  }
              }
                    
            }),         
                Unilite.popup('Employee', {
                valueFieldName: 'PERSON_NUMB',
                textFieldName: 'NAME',
                textFieldWidth: 170, 
                validateBlank: false,
                extParam: {'CUSTOM_TYPE': '3'},
                listeners: {
                     onSelected: {
                      fn: function(records, type) {
                          panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
                          panelSearch.setValue('NAME', panelResult.getValue('NAME'));
                      },
                      scope: this
                      },
                      onClear: function(type) {
                          panelResult.setValue('PERSON_NUMB', '');
                          panelResult.setValue('NAME', '');
                          panelSearch.setValue('PERSON_NUMB', '');
                          panelSearch.setValue('NAME', '');
                      }
                }
            })
            ,{
                xtype:'component',
                width: 300
                }
            ,{
                xtype: 'container',
                padding: '0 0 5 0',
                width: 300,
                layout: {
                    type: 'hbox',
                    align: 'center',
                    pack:'center'
                },
                items:[{
                    xtype: 'button',
                    id: 'select1',
                    text: '전체선택',
                    width: 100,
//                  margin: '0 0 0 110',
                    handler: function(){  
                    	var record = directMasterStore.data.items.length;
                    	if(!Ext.isEmpty(record) && record == 0 ){
                    		alert('선택할 데이터가 없습니다.');
                    		return false;
                    	}else{
                    		SelectAll();
                    		UniAppManager.setToolbarButtons('save',true);
                    	}
                                    
                    }
                },{
                    xtype: 'button',
                    id: 'deselect1',
                    text: '전체해제',
                    width: 100,
//                  margin: '0 0 0 110',
                    hidden: true,
                    handler: function(){                                                    
                        DeSelectAll();
                        UniAppManager.setToolbarButtons('save',false);
                    }
                }]
            }]
        }); //end panelResult 
	function SelectAll(){		
		var grid = Ext.getCmp('hpa300Grid1');
		var button1 = Ext.getCmp('select1');
		var button2 = Ext.getCmp('deselect1');
		var model = grid.getStore().getRange();			
				
		Ext.each(model, function(record,i){
			record.set('CHOICE',true);
			checkCount = i+1;
		});
		
		button1.setVisible(false);
		button2.setVisible(true);	
	}
	
	function DeSelectAll(){
		var grid = Ext.getCmp('hpa300Grid1');
		var button1 = Ext.getCmp('select1');
		var button2 = Ext.getCmp('deselect1');
		var model = grid.getStore().getRange();
		
		Ext.each(model, function(record,i){
			record.set('CHOICE',false);
			checkCount = i+1;
		});
		button1.setVisible(true);
		button2.setVisible(false);
	}
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('hpa300Grid1', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
		uniOpt: {
			expandLastColumn: true,
        	useRowNumberer: true,
            useMultipleSorting: true
        },

        columns: [        
        	{dataIndex: 'CHOICE'			, width: 33, xtype : 'checkcolumn',
            	listeners: {
                        checkchange: function(CheckColumn, rowIndex, checked, eOpts){
                        	var button1 = Ext.getCmp('select1');
                            var button2 = Ext.getCmp('deselect1');
                            var grdRecord = masterGrid.getStore().getAt(rowIndex);
                            if(checked == true){
                                checkCount++;
                                UniAppManager.setToolbarButtons('save',true);
                                
                            }else{
                                checkCount--;
                            }
                            if(checkCount == 0){
                              UniAppManager.setToolbarButtons('save',false);
                              button1.setVisible(true);
                              button2.setVisible(false);
                            }else{
                              UniAppManager.setToolbarButtons('save',true);
                              button1.setVisible(false);
                              button2.setVisible(true);
                            }
                        }
                        
                    }
                }, 				
			{dataIndex: 'CLOSE_ALL_YN'    	, width: 120, editable: false, hidden: true}, 				
			{dataIndex: 'CLOSE_PERSON_YN'  	, width: 120, editable: false, hidden: true},
			{dataIndex: 'CLOSE_ALL_NAME'   	, width: 100, editable: false, align: 'center'}, 				
			{dataIndex: 'CLOSE_PERSON_NAME'	, width: 100, editable: false, align: 'center'},
			{dataIndex: 'YEAR_YYYY'			, width: 100, editable: false, hidden: false, align: 'center'},
			{dataIndex: 'DIV_CODE'  		, width: 120, editable: false},
			{dataIndex: 'DEPT_CODE'   		, width: 100, editable: false}, 				
			{dataIndex: 'DEPT_NAME'			, width: 150, editable: false}, 				
			{dataIndex: 'POST_NAME'			, width: 100, editable: false}, 				
			{dataIndex: 'PERSON_NUMB'		, width: 100, editable: false},
			{dataIndex: 'NAME'				, width: 100, editable: false}, 				
			{dataIndex: 'HALFWAY_TYPE'		, width: 100, editable: false, hidden: false, align: 'center'},
			{dataIndex: 'JOIN_DATE'			, width: 110, editable: false, hidden: false, align: 'center'}, 				
			{dataIndex: 'RETR_DATE'			, width: 110, editable: false, hidden: false, align: 'center'}
		]
    });  
    
	 Unilite.Main( {
		borderItems:[ 
			masterGrid,
		 	panelResult,
		 	panelSearch
		 	
		], 
		id : 'hpa300App',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);			
		},
		onQueryButtonDown : function()	{		
			directMasterStore.loadStoreRecords();
			
			var button1 = Ext.getCmp('select1');
			var button2 = Ext.getCmp('deselect1');
		
			button1.setVisible(true);
			button2.setVisible(false);
			
			checkCount = 0;
			
		},
		onNewDataButtonDown: function()   {
			
        },
		onSaveDataButtonDown : function(){
			directMasterStore.saveStore();
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
};


</script>
