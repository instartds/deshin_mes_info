<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc210ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
    <t:ExtComboStore comboType="AU" comboCode="J503" /> <!-- 접수상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J505" /> <!-- 수금관리항목 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'arc210ukrService.selectList',
			update: 'arc210ukrService.updateDetail',
			create: 'arc210ukrService.insertDetail',
			destroy: 'arc210ukrService.deleteDetail',
			syncAll: 'arc210ukrService.saveAll'
		}
	});	
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Arc210ukrModel', {
	    fields: [
            {name: 'MNG_DATE'               ,text: '등록일'        ,type: 'uniDate'},
            {name: 'CONF_RECE_NO'           , text: '채권번호'     , type: 'string',allowBlank:false},
            {name: 'RECE_COMP_CODE'         , text: '회사코드'     , type: 'string',allowBlank:false},
            {name: 'RECE_COMP_NAME'         , text: '회사명'      , type: 'string',allowBlank:false},  
            
            {name: 'SEQ'                    , text: 'SEQ'     , type: 'int'},
//            {name: 'CUSTOM_CODE'            , text: '거래처'      , type: 'string'},
            {name: 'CUSTOM_NAME'            , text: '거래처명'     , type: 'string'},
            {name: 'MNG_GUBUN'              , text: '구분'        , type: 'string', comboType:'AU', comboCode:'J504'},
            {name: 'COLLECT_AMT'            , text: '수금액'       , type: 'uniPrice'},
            {name: 'REMARK'                 ,text: '내용'          ,type: 'string'},
            {name: 'NOTE_NUM'               ,text: '어음번호'       ,type: 'string'},
            {name: 'EXP_DATE'               ,text: '만기일자'       ,type: 'uniDate'},
            {name: 'DRAFTER'                ,text: '입력자코드'        ,type: 'string'},
            {name: 'DRAFTER_NAME'           ,text: '입력자'        ,type: 'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('arc210ukrDetailStore', {
		model: 'Arc210ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
//			allDeletable:true,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelResult.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
//						directDetailStore.loadStoreRecords();
						
						if (directDetailStore.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('arc210ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
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
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{ 
                fieldLabel: '조회기간',
                xtype: 'uniDateRangefield',
                startFieldName: 'MNG_DATE_FR',
                endFieldName: 'MNG_DATE_TO',
                allowBlank: false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('MNG_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('MNG_DATE_TO', newValue);                            
                    }
                }
            },
			Unilite.popup('COMP',{
                fieldLabel: '회사명', 
                valueFieldName:'RECE_COMP_CODE',
                textFieldName:'RECE_COMP_NAME',
//                autoPopup:true,
                validateBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('RECE_COMP_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('RECE_COMP_NAME', newValue);                
                    }
                }
            }), 	
			Unilite.popup('CONF_RECE',{
                fieldLabel: '채권번호', 
                valueFieldName:'CONF_RECE_NO',
                textFieldName:'CONF_RECE_CUSTOM_NAME',
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CONF_RECE_NO', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('RECE_COMP_NAME', newValue);                
                    }
                }
            }),   		
			Unilite.popup('CUST',{
                fieldLabel: '거래처', 
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                validateBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_CODE', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_NAME', newValue);              
                    }
                }
            }),{
                xtype: 'uniCombobox',
                fieldLabel: '수금관리항목',
                name:'COLL_MANA',  
                comboType:'AU',
                comboCode:'J505',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('COLL_MANA', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '구분',
                name:'MNG_GUBUN',   
                comboType:'AU',
                comboCode:'J504',
                listeners: {
                	beforequery: function(queryPlan, eOpts){
                        var store = queryPlan.combo.store;
                        store.clearFilter();
                        
                        if(!Ext.isEmpty(panelSearch.getValue('COLL_MANA'))){
                            store.filterBy(function(record){
                                return record.get('refCode2') == panelSearch.getValue('COLL_MANA');
                            })  
                        }else{
                            return false;
                        }
                    },
                    collapse:function(field, eOpts){
                        field.getStore().clearFilter();
                    },
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('MNG_GUBUN', newValue);
                    }
                }
            },
			Unilite.popup('Employee',{
                fieldLabel: '법무담당', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'CONF_DRAFTER',
                textFieldName:'CONF_DRAFTER_NAME',
//                extParam: {
//                    'ADD_QUERY': "Y"
//                },  
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CONF_DRAFTER', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('CONF_DRAFTER_NAME', newValue);             
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'ADD_QUERY': "Y"});                           
                    }
                }
            }), 					
			{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:600,
    //          colspan:2,
                items :[{
                    xtype: 'radiogroup',                            
                    fieldLabel: '조건',
    //              colspan:2,
//                  id: 'asStatus',
                    items: [{
                        boxLabel: '전체', 
                        width: 50,
                        name: 'J504_REF_CODE1',
                        inputValue: '',
                        checked: true  
                    },{
                        boxLabel: '관리일지', 
                        width: 70,
                        name: 'J504_REF_CODE1',
                        inputValue: '1' 
                    },{
                        boxLabel: '수금', 
                        width: 50,
                        name: 'J504_REF_CODE1',
                        inputValue: '2'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.getField('J504_REF_CODE1').setValue(newValue.J504_REF_CODE1);                 
                        }
                    }
                }]
            }]
		}]
	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
            fieldLabel: '조회기간',
            xtype: 'uniDateRangefield',
            startFieldName: 'MNG_DATE_FR',
            endFieldName: 'MNG_DATE_TO',
            allowBlank: false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('MNG_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('MNG_DATE_TO', newValue);                            
                }
            }
        },
        Unilite.popup('COMP',{
            fieldLabel: '회사명', 
            valueFieldName:'RECE_COMP_CODE',
            textFieldName:'RECE_COMP_NAME',
//            useLike : true,
//            autoPopup:true,
            validateBlank: false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('RECE_COMP_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('RECE_COMP_NAME', newValue);                
                }
            }
        }),     
        Unilite.popup('CONF_RECE',{
            fieldLabel: '채권번호', 
            valueFieldName:'CONF_RECE_NO',
            textFieldName:'CONF_RECE_CUSTOM_NAME',
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CONF_RECE_NO', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelResult.setValue('RECE_COMP_NAME', newValue);                
                }
            }
        }),         
        Unilite.popup('CUST',{
            fieldLabel: '거래처', 
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
            validateBlank: false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_CODE', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_NAME', newValue);              
                }
            }
        }),             
        {
            xtype: 'uniCombobox',
            fieldLabel: '수금관리항목',
            name:'COLL_MANA',  
            comboType:'AU',
            comboCode:'J505',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('COLL_MANA', newValue);
                }
            }
        },              
        Unilite.popup('Employee',{
            fieldLabel: '법무담당', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'CONF_DRAFTER',
            textFieldName:'CONF_DRAFTER_NAME',
//            extParam: {
//                'ADD_QUERY': "Y"
//            },  
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CONF_DRAFTER', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('CONF_DRAFTER_NAME', newValue);             
                },
                applyextparam: function(popup){
                    popup.setExtParam({'ADD_QUERY': "Y"});                           
                }
            }
        }), 
        {
            xtype: 'uniCombobox',
            fieldLabel: '구분',
            name:'MNG_GUBUN',   
            comboType:'AU',
            comboCode:'J504',
            listeners: {
                beforequery: function(queryPlan, eOpts){
                    var store = queryPlan.combo.store;
                    store.clearFilter();
                    
                    if(!Ext.isEmpty(panelResult.getValue('COLL_MANA'))){
                        store.filterBy(function(record){
                            return record.get('refCode2') == panelResult.getValue('COLL_MANA');
                        })  
                    }else{
                        return false;
                    }
                },
                collapse:function(field, eOpts){
                    field.getStore().clearFilter();
                },
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('MNG_GUBUN', newValue);
                }
            }
            
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:600,
//          colspan:2,
            items :[{
                xtype: 'radiogroup',                            
                fieldLabel: '조건',
//              colspan:2,
//                  id: 'asStatus',
                items: [{
                    boxLabel: '전체', 
                    width: 50,
                    name: 'J504_REF_CODE1',
                    inputValue: '',
                    checked: true  
                },{
                    boxLabel: '관리일지', 
                    width: 70,
                    name: 'J504_REF_CODE1',
                    inputValue: '1' 
                },{
                    boxLabel: '수금', 
                    width: 50,
                    name: 'J504_REF_CODE1',
                    inputValue: '2'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('J504_REF_CODE1').setValue(newValue.J504_REF_CODE1);                 
                    }
                }
            }]
        }]
    });		
    var detailGrid = Unilite.createGrid('arc210ukrGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '관리일지/수금등록',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			useRowContext: true,
			onLoadSelectFirst: true,
            copiedRow:true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directDetailStore,
		columns: [     
        	{ dataIndex: 'MNG_DATE'             ,width:100},
        	{ dataIndex: 'CONF_RECE_NO'         ,width:120,
                editor:Unilite.popup('CONF_RECE_G', {
                    autoPopup: true,
                    textFieldName:'CONF_RECE_CUSTOM_NAME',
                    DBtextFieldName: 'CONF_RECE_CUSTOM_NAME',
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('CONF_RECE_NO' , records[0].CONF_RECE_NO);
                            grdRecord.set('CUSTOM_NAME' , records[0].CONF_RECE_CUSTOM_NAME);
                            
                            grdRecord.set('RECE_COMP_CODE' , records[0].RECE_COMP_CODE);
                            grdRecord.set('RECE_COMP_NAME' , records[0].RECE_COMP_NAME);
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('CONF_RECE_NO' , '');
                            grdRecord.set('CUSTOM_NAME' , '');
                            
                            grdRecord.set('RECE_COMP_CODE' , '');
                            grdRecord.set('RECE_COMP_NAME' , '');
                        }
                    }
                })
            },
        	
            { dataIndex: 'RECE_COMP_CODE'       ,width:100,
                editor:Unilite.popup('COMP_G', {
                    autoPopup: true,
                    textFieldName:'COMP_NAME',
                    DBtextFieldName: 'COMP_NAME',
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('RECE_COMP_CODE' , records[0].COMP_CODE);
                            grdRecord.set('RECE_COMP_NAME' , records[0].COMP_NAME);
                            
                            grdRecord.set('RECE_COMP_CODE' , records[0].RECE_COMP_CODE);
                            grdRecord.set('RECE_COMP_NAME' , records[0].RECE_COMP_NAME);
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('RECE_COMP_CODE' , '');
                            grdRecord.set('RECE_COMP_NAME' , '');
                            
                            grdRecord.set('RECE_COMP_CODE' , '');
                            grdRecord.set('RECE_COMP_NAME' , '');
                        }
                    }
                })
            },
            { dataIndex: 'RECE_COMP_NAME'       ,width:150,
                editor:Unilite.popup('COMP_G', {
                    autoPopup: true,
                    textFieldName:'COMP_NAME',
                    DBtextFieldName: 'COMP_NAME',
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('RECE_COMP_CODE' , records[0].COMP_CODE);
                            grdRecord.set('RECE_COMP_NAME' , records[0].COMP_NAME);
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('RECE_COMP_CODE' , '');
                            grdRecord.set('RECE_COMP_NAME' , '');
                        }
                    }
                })
            },
            
            { dataIndex: 'SEQ'                  ,width:100,hidden:true},
//            { dataIndex: 'CUSTOM_CODE'          ,width:100},
            { dataIndex: 'CUSTOM_NAME'          ,width:150},
            { dataIndex: 'MNG_GUBUN'            ,width:100,align:'center'},
            { dataIndex: 'COLLECT_AMT'          ,width:100},
            { dataIndex: 'REMARK'               ,width:250},
            { dataIndex: 'NOTE_NUM'             ,width:100},
            { dataIndex: 'EXP_DATE'             ,width:100},
            { dataIndex: 'DRAFTER'              ,width:100,hidden:true},
            { dataIndex: 'DRAFTER_NAME'         ,width:100}
        ],
        listeners: {
        	afterrender:function()	{
        		
			},
			
			beforeedit : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['SEQ', 'CUSTOM_NAME', 'DRAFTER','DRAFTER_NAME','RECE_COMP_CODE', 'RECE_COMP_NAME'])){
                	return false;
                }else{
                	if(e.record.phantom == false){
                		if(UniUtils.indexOf(e.field, ['CONF_RECE_NO'])){
                            return false;
                        }else{
                        	return true;
                        }
                	}
                }
            }
        }
    });   
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid
			]	
		},
			panelSearch
		],
		id  : 'arc210ukrApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault();
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('MNG_DATE_FR');
		},
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			
			directDetailStore.loadStoreRecords();		
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
			 var mngDate = UniDate.get('today');
			 var drafter = UserInfo.personNumb;
			 var drafterName = UserInfo.userName;
        	 
        	 var r = {
			
				MNG_DATE: mngDate,
				DRAFTER: drafter,
				DRAFTER_NAME: drafterName
	        };
			detailGrid.createRow(r);
		},
		onResetButtonDown: function() {
//			panelSearch.clearForm();
//			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.setToolbarButtons('save', false);
		},
		
		onSaveDataButtonDown: function(config) {				
			directDetailStore.saveStore();
		},
		
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				
				
				detailGrid.deleteSelectedRow();
				
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();

			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function(){
			panelSearch.setValue('MNG_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('MNG_DATE_TO', UniDate.get('today'));
            panelResult.setValue('MNG_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('MNG_DATE_TO', UniDate.get('today'));
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
			}
			return rv;
		}
	});	
			
};

</script>