<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb980ukr_kocis"  >
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="HE24" /> <!-- 월 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
    
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    

<script type="text/javascript" >

var SAVE_FLAG = '';
function appMain() {
	Unilite.defineModel('afb980ukrModel', {
        fields: [
            {name: 'COMP_CODE'      ,text: '법인코드'           ,type: 'string'},
            {name: 'DEPT_CODE'      ,text: '기관코드'           ,type: 'string'},
            {name: 'DEPT_NAME'      ,text: '기관명'            ,type: 'string'},
            {name: 'AC_YYYY'        ,text: '회계년도'           ,type: 'string'},
            {name: 'ACC_MM01'        ,text: '1월'              ,type: 'string'},
            {name: 'ACC_MM02'        ,text: '2월'              ,type: 'string'},
            {name: 'ACC_MM03'        ,text: '3월'              ,type: 'string'},
            {name: 'ACC_MM04'        ,text: '4월'              ,type: 'string'},
            {name: 'ACC_MM05'        ,text: '5월'              ,type: 'string'},
            {name: 'ACC_MM06'        ,text: '6월'              ,type: 'string'},
            {name: 'ACC_MM07'        ,text: '7월'              ,type: 'string'},
            {name: 'ACC_MM08'        ,text: '8월'              ,type: 'string'},
            {name: 'ACC_MM09'        ,text: '9월'              ,type: 'string'},
            {name: 'ACC_MM10'       ,text: '10월'             ,type: 'string'},
            {name: 'ACC_MM11'       ,text: '11월'             ,type: 'string'},
            {name: 'ACC_MM12'       ,text: '12월'             ,type: 'string'},
            {name: 'ACC_MM13'       ,text: '13월'             ,type: 'string'},
            {name: 'CLOSE_YYYY'    ,text: '년'               ,type: 'string'}
        ]
    });
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var searchStore = Unilite.createStore('afb980ukrSearchStore', {
        model: 'afb980ukrModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_afb980ukrkocisService.selectList'                 
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
        loadStoreRecords: function() {
            var param = Ext.getCmp('panelResult').getValues();
            
   /*         var startField = panelSearch.getField('AC_DATE_FR');
            var startDateValue = startField.getStartDate();
            var endField = panelSearch.getField('AC_DATE_TO');
            var endDateValue = endField.getEndDate(); 
            
            param.AC_DATE_FR = startDateValue;
            param.AC_DATE_TO = endDateValue;*/
            
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
	
	
	var panelSearch = Unilite.createSearchPanel('panelSearch', {          
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
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },{
                xtype: 'uniYearField',
                fieldLabel: '회계년도',
                name: 'AC_YYYY',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YYYY', newValue);
                        
                    }
                }
            }]
        }]
	});
	
	var panelResult = Unilite.createSearchForm('panelResult',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },{
            xtype: 'uniYearField',
            fieldLabel: '회계년도',
            name: 'AC_YYYY',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YYYY', newValue);
                    
                }
            }
        }]
    });
	
	
	var searchGrid = Unilite.createGrid('afb980ukrGrid', {
        title:'● 월마감 상태',
//      split:true,
        layout: 'fit',
        region: 'center',
        excelTitle: '마감관리',
//        height:300,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: true,
            useRowContext: false,
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
            showSummaryRow: true,
            dock:'bottom'
        }],
        store: searchStore,
        selModel:'rowmodel',
        columns: [
            { dataIndex: 'COMP_CODE'    ,width:100,hidden:true},
            { dataIndex: 'DEPT_CODE'    ,width:100},
            { dataIndex: 'DEPT_NAME'    ,width:100},
            { dataIndex: 'AC_YYYY'      ,width:80, align:'center'},
            { dataIndex: 'ACC_MM01'      ,width:60, align:'center'},
            { dataIndex: 'ACC_MM02'      ,width:60, align:'center'},
            { dataIndex: 'ACC_MM03'      ,width:60, align:'center'},
            { dataIndex: 'ACC_MM04'      ,width:60, align:'center'},
            { dataIndex: 'ACC_MM05'      ,width:60, align:'center'},
            { dataIndex: 'ACC_MM06'      ,width:60, align:'center'},
            { dataIndex: 'ACC_MM07'      ,width:60, align:'center'},
            { dataIndex: 'ACC_MM08'      ,width:60, align:'center'},
            { dataIndex: 'ACC_MM09'      ,width:60, align:'center'},
            { dataIndex: 'ACC_MM10'     ,width:60, align:'center'},
            { dataIndex: 'ACC_MM11'     ,width:60, align:'center'},
            { dataIndex: 'ACC_MM12'     ,width:60, align:'center'},
            { dataIndex: 'ACC_MM13'     ,width:60, align:'center'},
            { dataIndex: 'CLOSE_YYYY'  ,width:60, align:'center'}
        ],
        listeners: {
            /*selectionchangerecord:function(selected){
            	detailForm.setValue('AC_DATE',selected.data.AC_DATE);
                detailForm.setValue('DOC_NO',selected.data.DOC_NO);
                detailForm.setValue('AC_GUBUN',selected.data.AC_GUBUN);
                detailForm.setValue('ACCT_NO',selected.data.ACCT_NO);
                detailForm.setValue('BUDG_CODE',selected.data.BUDG_CODE);
                detailForm.setValue('WON_AMT',selected.data.WON_AMT);
                detailForm.setValue('REMARK',selected.data.REMARK);
                
                SAVE_FLAG= 'U';
                
                detailForm.getField('AC_DATE').setReadOnly(true);
                detailForm.getField('AC_GUBUN').setReadOnly(true);
                detailForm.getField('ACCT_NO').setReadOnly(true);
                
                
            }*/
        	
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
            	detailForm.setValue('DEPT_CODE'  ,selectRecord.get('DEPT_CODE'));
                detailForm.setValue('AC_YYYY'    ,selectRecord.get('AC_YYYY'));
                detailForm.setValue('ACC_MM01'    ,selectRecord.get('ACC_MM01'));
                detailForm.setValue('ACC_MM02'    ,selectRecord.get('ACC_MM02'));
                detailForm.setValue('ACC_MM03'    ,selectRecord.get('ACC_MM03'));
                detailForm.setValue('ACC_MM04'    ,selectRecord.get('ACC_MM04'));
                detailForm.setValue('ACC_MM05'    ,selectRecord.get('ACC_MM05'));
                detailForm.setValue('ACC_MM06'    ,selectRecord.get('ACC_MM06'));
                detailForm.setValue('ACC_MM07'    ,selectRecord.get('ACC_MM07'));
                detailForm.setValue('ACC_MM08'    ,selectRecord.get('ACC_MM08'));
                detailForm.setValue('ACC_MM09'    ,selectRecord.get('ACC_MM09'));
                detailForm.setValue('ACC_MM10'   ,selectRecord.get('ACC_MM10'));
                detailForm.setValue('ACC_MM11'   ,selectRecord.get('ACC_MM11'));
                detailForm.setValue('ACC_MM12'   ,selectRecord.get('ACC_MM12'));
                detailForm.setValue('ACC_MM13'   ,selectRecord.get('ACC_MM13'));
                detailForm.setValue('CLOSE_YYYY',selectRecord.get('CLOSE_YYYY'));
                
                
                
                detailForm.getField('DEPT_CODE').setReadOnly(true);
                detailForm.getField('AC_YYYY').setReadOnly(true);
            }
        }
    });   
	
	
	var detailForm = Unilite.createForm('resultForm',{
//      split:true,
//		width:750,
		height:140,
        region: 'center',
        layout: {type: 'uniTable', columns: 1
//        tableAttrs: {width:'100%'}
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: 1000},//'100%'}
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'/*,width: '100%'*/}//width: '100%'/*,align : 'left'*/}
    
        },
        padding:'1 1 1 1',
        border:true,
        disabled:false,
        tbar:[{
                xtype:'button',
                itemId:'resetButton',
                text:'초기화',
                handler: function() {
                    detailForm.clearForm();
                    UniAppManager.app.fnInitInputFieldsDetailForm();
                    SAVE_FLAG = 'N';
                    
                    detailForm.getField('DEPT_CODE').setReadOnly(false);
                    detailForm.getField('AC_YYYY').setReadOnly(false);
                }
            },{
                xtype:'button',
                itemId:'saveButton',
                text:'저장',
                handler: function() {
                    
                    //필수 체크 관련 확인필요
                    if(!detailForm.getInvalidMessage()){
                        return;
                    }/*else{
                            
                    }*/
                    if(Ext.isEmpty(detailForm.getValue('DEPT_CODE'))){
                    	alert('기관명을 입력해 주십시오.');
                    	return;
                    }else if(Ext.isEmpty(detailForm.getValue('AC_YYYY')) || detailForm.getValue('AC_YYYY') == 0){
                        alert('회계년도를 입력해 주십시오.');
                        return;
                    }
                    
                    
                    Ext.getCmp('pageAll').getEl().mask('저장 중...','loading-indicator');
                    var param = detailForm.getValues();
                    param.SAVE_FLAG = SAVE_FLAG;
                    detailForm.getForm().submit({
                    params : param,
                        success : function(form, action) {
                            detailForm.getForm().wasDirty = false;
                            detailForm.resetDirtyStatus();
                            UniAppManager.setToolbarButtons('save', false);
                            UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
//                            if(SAVE_FLAG == ''){
//                                detailForm.setValue('DOC_NO',action.result.DOC_NO);
//                            }
                            detailForm.setValue('DOC_NO',action.result.DOC_NO);
                            Ext.getCmp('pageAll').getEl().unmask();  
                            UniAppManager.app.onQueryButtonDown();
                            SAVE_FLAG = 'U';
                            
                            detailForm.getField('DEPT_CODE').setReadOnly(true);
                            detailForm.getField('AC_YYYY').setReadOnly(true);
                        },
                        failure: function(){
                            Ext.getCmp('pageAll').getEl().unmask();  
                        }
                    });
                }
            }],
        items: [{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 16,
                tableAttrs: {style: 'border : 0.1px solid #99BCE8;'},
                tdAttrs: {style: 'border : 0.1px solid #99BCE8;',  align : 'center'}
            },
//            tdAttrs: {align : 'right',style: 'border : 1px solid #FFFFFF;'},
            padding:'10 10 0 10',
            defaults:{height: 20},
            items: [	
        		{ xtype: 'component',  html:'기관명',tdAttrs: {style: 'background-color: #e8edf5;'}},   
                { xtype: 'component',  html:'회계년도',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'1월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'2월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'3월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'4월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'5월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'6월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'7월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'8월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'9월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'10월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'11월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'12월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'13월',tdAttrs: {style: 'background-color: #e8edf5;'}}, 
                { xtype: 'component',  html:'년',tdAttrs: {style: 'background-color: #e8edf5;'}},
        			
        		
                { xtype: 'uniCombobox', fieldLabel: '', name: 'DEPT_CODE', store: Ext.data.StoreManager.lookup('deptKocis')},
                { xtype: 'uniYearField', fieldLabel: '', name: 'AC_YYYY'},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM01'    , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM02'    , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM03'    , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM04'    , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM05'    , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM06'    , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM07'    , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM08'    , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM09'    , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM10'   , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM11'   , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM12'   , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'ACC_MM13'   , inputValue:'Y', tdAttrs: {width:40,align:'center'}},
                { xtype: 'checkboxfield', fieldLabel: '', name: 'CLOSE_YYYY', inputValue:'Y', tdAttrs: {width:40,align:'center'}}
            ]
        }],
        api: {
            load: 's_afb980ukrkocisService.selectForm' ,
            submit: 's_afb980ukrkocisService.syncMaster'   
        },
        listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                console.log("onDirtyChange");
            /*    if(basicForm.isDirty()) {
                    if(requestFlag == 'Y'){
                        UniAppManager.setToolbarButtons('save', false);
                    }else{ 
                        UniAppManager.setToolbarButtons('save', true);
                    }
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }*/
            }
        }
    });
    Unilite.Main( {
		/*borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				detailForm, subForm1, subForm2, detailGrid
			]	
		}],*/
    	borderItems:[{
            region: 'center',
            layout: {type: 'vbox', align: 'stretch'},
            border: false,
            autoScroll: true,
            id:'pageAll',
            items: [panelResult, searchGrid,detailForm]
        },
            panelSearch],
		id  : 'afb980ukrApp',
		fnInitBinding: function(params){
			var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            UniAppManager.app.fnInitInputFields();
            UniAppManager.app.fnInitInputFieldsDetailForm();
//            activeSForm.onLoadSelectText('GL_DATE_FR');   
			
//			this.setDefault(params);
			UniAppManager.setToolbarButtons(['newData','save','print'], false);
            UniAppManager.setToolbarButtons(['reset'/*,'print'*/], true);
            
//            detailForm.onLoadSelectText('RECE_DATE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
            searchStore.loadStoreRecords();
			
	/*
				var param= detailForm.getValues();
				
				detailForm.getForm().load({
					params: param,
					success: function(form, action) {
						
						SAVE_FLAG = action.result.data.SAVE_FLAG;
						
						
//						detailForm.unmask();
						
						
						subForm1.getForm().load({
							params: param,
							success: function(form, action) {
						
//								subForm1.unmask();
						
							},
							failure: function(form, action) {
//								subForm1.unmask();
							}
						})
						
						
						
						if(SAVE_FLAG == 'U'){
							UniAppManager.setToolbarButtons('delete',true);	
						}
						detailForm.getField('RECE_DATE').focus();  
					},
					failure: function(form, action) {
//						detailForm.unmask();
//						subForm1.unmask();
					}
				});
				searchStore.loadStoreRecords();	
				
				UniAppManager.setToolbarButtons('reset',true);
//				panelResult.setAllFieldsReadOnly(true);
				
//			}
				
				*/
		},
/*		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
//			 var compCode = UserInfo.compCode;
        	 
        	 var r = {
			
//				COMP_CODE: compCode
	        };
			detailGrid.createRow(r);
		},*/
		onResetButtonDown: function() {
//			panelSearch.clearForm();
            panelSearch.clearForm();
            panelResult.clearForm();
			detailForm.clearForm();
			searchGrid.reset();
			searchStore.clearData();
			UniAppManager.app.fnInitInputFields();
            UniAppManager.app.fnInitInputFieldsDetailForm();
			UniAppManager.setToolbarButtons(['newData','save','delete'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			
			SAVE_FLAG = 'N';
			
		},
		
		setDefault: function(params){
			
			if(!Ext.isEmpty(params.RECE_NO)){
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
                UniAppManager.app.fnInitInputFieldsDetailForm();				
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'arc100skr') {
				detailForm.setValue('RECE_NO',params.RECE_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'arc110ukr') {
                detailForm.setValue('RECE_NO',params.RECE_NO);
                this.onQueryButtonDown();
			}
		},
		
		fnInitInputFields: function(){
			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			
			if(!Ext.isEmpty(UserInfo.deptCode)){
				if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                    
//                    detailForm.setHidden(true);
				}else{
					panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
//                    detailForm.setHidden(false);
				}
			}else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
			}
			
			panelSearch.setValue('AC_YYYY',new Date().getFullYear());
            
            panelResult.setValue('AC_YYYY',new Date().getFullYear());

		},
		fnInitInputFieldsDetailForm: function(){
            detailForm.setValue('DEPT_CODE',UserInfo.deptCode);
            detailForm.setValue('AC_DATE',UniDate.get('today'));
            
            detailForm.getField('DEPT_CODE').setReadOnly(false);
            detailForm.getField('AC_YYYY').setReadOnly(false);
		}
	});
};


</script>