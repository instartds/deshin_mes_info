<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc300ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
    <t:ExtComboStore comboType="AU" comboCode="J503" /> <!-- 접수상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J505" /> <!-- 수금관리항목 -->
    
    <t:ExtComboStore comboType="AU" comboCode="J506" /> <!-- 비용구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J507" /> <!-- 청구구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

function appMain() {
//	var statusStore = Unilite.createStore('statusComboStore', {  
//        fields: ['text', 'value'],
//        data :  [
//            {'text':'청구'    , 'value':'Y'},
//            {'text':'미청구'   , 'value':'N'}
//        ]
//    });
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'arc300ukrService.selectList',
			update: 'arc300ukrService.updateDetail',
			create: 'arc300ukrService.insertDetail',
			destroy: 'arc300ukrService.deleteDetail',
			syncAll: 'arc300ukrService.saveAll'
		}
	});	
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Arc300ukrModel', {
	    fields: [
            {name: 'CHARGE_YN'              , text: '청구여부'     , type: 'string', comboType:'AU', comboCode:'J507'},
            {name: 'CHARGE_YN_DUMMY'        , text: 'CHARGE_YN_DUMMY'     , type: 'string'},
            
            
            {name: 'ROW_NUMBER'         , text: 'NO'     , type: 'string'},
            {name: 'DOC_ID'             , text: 'DOC_ID'     , type: 'string'},
            
            {name: 'EPN_DATE'               , text: '등록일'      , type: 'uniDate'},
            {name: 'RECE_COMP_CODE'         , text: '회사코드'     , type: 'string'},
            {name: 'RECE_COMP_NAME'         , text: '회사명'      , type: 'string'},  
            {name: 'EPN_GUBUN'              , text: '비용구분'     , type: 'string', comboType:'AU', comboCode:'J506'},
            {name: 'REMARK'                 , text: '내용'        , type: 'string'},
            {name: 'EPN_AMT'                , text: '금액'        , type: 'uniPrice'},
            {name: 'CHARGE_DATE'            , text: '청구일자'      , type: 'uniDate'},
            {name: 'CHARGE_DATE_DUMMY'      , text: 'CHARGE_DATE_DUMMY'      , type: 'uniDate'},
            {name: 'DRAFTER'                , text: '입력자'       , type: 'string'}
           
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('arc300ukrDetailStore', {
		model: 'Arc300ukrModel',
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
                var grid = Ext.getCmp('arc300ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		
           		UniAppManager.setToolbarButtons('delete', false);
           		
           	},
           	add: function(store, records, index, eOpts) {
           		
//           		var selRow = detailGrid.getSelectedRecord();
//                
//            if(selRow.length > 0){
//                UniAppManager.setToolbarButtons('delete', true);
//            }else{
//                UniAppManager.setToolbarButtons('delete', false);
//            }
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
                startFieldName: 'EPN_DATE_FR',
                endFieldName: 'EPN_DATE_TO',
                allowBlank: false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('EPN_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('EPN_DATE_TO', newValue);                            
                    }
                }
            },
			Unilite.popup('COMP',{
                fieldLabel: '회사명', 
                valueFieldName:'RECE_COMP_CODE',
                textFieldName:'RECE_COMP_NAME',
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
            { 
                fieldLabel: '청구일',
                xtype: 'uniDateRangefield',
                startFieldName: 'CHARGE_DATE_FR',
                endFieldName: 'CHARGE_DATE_TO',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('CHARGE_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('CHARGE_DATE_TO', newValue);                            
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
                xtype: 'uniCombobox',
                fieldLabel: '비용구분',
                name:'EPN_GUBUN',   
                comboType:'AU',
                comboCode:'J506',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('EPN_GUBUN', newValue);
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
                        name: 'CHARGE_YN',
                        inputValue: '',
                        checked: true  
                    },{
                        boxLabel: '청구', 
                        width: 50,
                        name: 'CHARGE_YN',
                        inputValue: 'Y' 
                    },{
                        boxLabel: '미청구', 
                        width: 70,
                        name: 'CHARGE_YN',
                        inputValue: 'N'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.getField('CHARGE_YN').setValue(newValue.CHARGE_YN);                 
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
            startFieldName: 'EPN_DATE_FR',
            endFieldName: 'EPN_DATE_TO',
            allowBlank: false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('EPN_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('EPN_DATE_TO', newValue);                            
                }
            }
        },
        Unilite.popup('COMP',{
            fieldLabel: '회사명', 
            valueFieldName:'RECE_COMP_CODE',
            textFieldName:'RECE_COMP_NAME',
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
        { 
            fieldLabel: '청구일',
            xtype: 'uniDateRangefield',
            startFieldName: 'CHARGE_DATE_FR',
            endFieldName: 'CHARGE_DATE_TO',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('CHARGE_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('CHARGE_DATE_TO', newValue);                            
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
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:600,
//          colspan:2,
            items :[{
                xtype: 'uniCombobox',
                fieldLabel: '비용구분',
                name:'EPN_GUBUN',   
                comboType:'AU',
                comboCode:'J506',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('EPN_GUBUN', newValue);
                    }
                }               
            }]
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
                    name: 'CHARGE_YN',
                    inputValue: '',
                    checked: true  
                },{
                    boxLabel: '청구', 
                    width: 50,
                    name: 'CHARGE_YN',
                    inputValue: 'Y' 
                },{
                    boxLabel: '미청구', 
                    width: 70,
                    name: 'CHARGE_YN',
                    inputValue: 'N'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('CHARGE_YN').setValue(newValue.CHARGE_YN);                 
                    }
                }
            }]
        }]
    });		
    var detailGrid = Unilite.createGrid('arc300ukrGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '비용청구등록',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
			onLoadSelectFirst: false,
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
			showSummaryRow: true
		}],
		store: directDetailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
            listeners: {  
            	beforeselect: function(rowSelection, record, index, eOpts) {
//                    if(record.phantom == true){
//                        return false;	
//                    }
                },
            	
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                	if(selectRecord.phantom == true){
                        return false; 
                    }else{
                	
                        if(selectRecord.get('CHARGE_YN') == 'N'){
                            selectRecord.set('CHARGE_YN','Y');
                            selectRecord.set('CHARGE_DATE',UniDate.get('today'));
                            
                        }else if(selectRecord.get('CHARGE_YN') == 'Y'){
                        	selectRecord.set('CHARGE_YN','N');
                        	selectRecord.set('CHARGE_DATE','');
                        }
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	if(selectRecord.phantom == true){
                        return false; 
                    }else{
                    	
                        selectRecord.set('CHARGE_YN',selectRecord.get('CHARGE_YN_DUMMY'));
                        selectRecord.set('CHARGE_DATE',selectRecord.get('CHARGE_DATE_DUMMY'));
                    }
                }
            }
        }),
		columns: [     
        	{ dataIndex: 'CHARGE_YN'                 ,width:80 ,align:'center'},
        	{ dataIndex: 'CHARGE_YN_DUMMY'           ,width:100, hidden:true },
        	
        	{ dataIndex: 'ROW_NUMBER'                 ,width:50,align:'center'},
        	{ dataIndex: 'DOC_ID'                     ,width:100, hidden:true},
        	
            { dataIndex: 'EPN_DATE'                  ,width:100},
            { dataIndex: 'RECE_COMP_CODE'            ,width:100,
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
                }),
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
                
            },
            { dataIndex: 'RECE_COMP_NAME'            ,width:200,
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
            { dataIndex: 'EPN_GUBUN'                 ,width:100,align:'center'},
            { dataIndex: 'REMARK'                    ,width:300},
            { dataIndex: 'EPN_AMT'                   ,width:100 ,summaryType: 'sum'},
            { dataIndex: 'CHARGE_DATE'               ,width:100},
            { dataIndex: 'CHARGE_DATE_DUMMY'         ,width:100,hidden:true},
            { dataIndex: 'DRAFTER'                   ,width:100}
        ],
        listeners: {
        	afterrender:function()	{
        		
			},
			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['CHARGE_DATE'])){
                    if(e.record.data.CHARGE_YN == 'Y'){
                        return true;
                    }else{
                        return false;
                    }
                }else if(UniUtils.indexOf(e.field, ['CHARGE_YN','CHARGE_YN_DUMMY','ROW_NUMBER','DOC_ID'])){
                    return false;
                }else{
                    if(e.record.phantom == false){
                        if(UniUtils.indexOf(e.field, ['RECE_COMP_CODE','RECE_COMP_NAME', 'CONF_RECE_NO','EPN_DATE','EPN_GUBUN'])){
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
		id  : 'arc300ukrApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault();
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('EPN_DATE_FR');
		},
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			
			directDetailStore.loadStoreRecords();
			
			
			
			/*var selRow = detailGrid.getSelectedRecord();
                
                if(selRow.length > 0){
                    UniAppManager.setToolbarButtons('delete', true);
                }else{
                    UniAppManager.setToolbarButtons('delete', false);
                }*/
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
			 var chargeYn = 'N';
			 var epnDate = UniDate.get('today');
			 var drafter = UserInfo.personNumb;
			 
			 var tempDate = UniDate.getDbDateStr(epnDate).substring(0,6) + '01';
                 tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
             var transDate = new Date(tempDate);
			 var chargeDate =  UniDate.getDbDateStr(UniDate.add((UniDate.add(transDate, {months: +1})), {days: -1}));
        	 
        	 var r = {
			    CHARGE_YN: chargeYn,
				EPN_DATE: epnDate,
				DRAFTER: drafter,
				CHARGE_DATE: chargeDate
	        };
			detailGrid.createRow(r);
			var sm = detailGrid.getSelectionModel();
			var selRecords = detailGrid.getSelectionModel().getSelection();
			sm.deselect(selRecords);
//			UniAppManager.setToolbarButtons('delete', false);
			
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
    			var sm = detailGrid.getSelectionModel();
                var selRecords = detailGrid.getSelectionModel().getSelection();
                sm.deselect(selRecords);
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();
                var sm = detailGrid.getSelectionModel();
                var selRecords = detailGrid.getSelectionModel().getSelection();
                sm.deselect(selRecords);
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
			panelSearch.setValue('EPN_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('EPN_DATE_TO', UniDate.get('today'));
            panelResult.setValue('EPN_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('EPN_DATE_TO', UniDate.get('today'));
            
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "EPN_DATE":
				    var tempDate = UniDate.getDbDateStr(newValue).substring(0,6) + '01';
                    tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
                    var transDate = new Date(tempDate);
                    var chargeDate =  UniDate.getDbDateStr(UniDate.add((UniDate.add(transDate, {months: +1})), {days: -1}));
                    
                    record.set('CHARGE_DATE',chargeDate);
             break;
			}
			return rv;
		}
	});	
			
};

</script>