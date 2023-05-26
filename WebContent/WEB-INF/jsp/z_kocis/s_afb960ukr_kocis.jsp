<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb960ukr_kocis"  >
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
    <t:ExtComboStore comboType="AU" comboCode="A170" opts='2;3'/> <!-- 이월/불용승인 구분 (예산구분) -->
    
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

var detailListWindow; 
function appMain() {
	Unilite.defineModel('detailListModel', {
        fields: [
            { name: 'BUDG_GUBUN'    ,text: '구분'     ,type: 'string', comboType: 'AU', comboCode: 'A170'},
            { name: 'BUDG_CODE'    ,text: '예산과목'     ,type: 'string'},
            { name: 'BUDG_NAME_1'  ,text: '부문'      ,type: 'string'},
            { name: 'BUDG_NAME_4'  ,text: '세부사업'   ,type: 'string'},
            { name: 'BUDG_NAME_6'  ,text: '목/세목'   ,type: 'string'},
            { name: 'AMT'          ,text: '금액(현지화)'   ,type: 'uniUnitPrice'},//,type: 'float', decimalPrecision:2, format:'0,000.00'},
            { name: 'REMARK'       ,text: '적요'   ,type: 'string'}
        ]
    });
    
    var detailListStore = Unilite.createStore('afb960ukrDetailListStore', {
        model: 'detailListModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_afb960ukrkocisService.selectDetailList'                 
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
                name: 'AC_YEAR',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
                        
                    }
                }
            }]
        }]
	});
	
	var panelResult = Unilite.createSearchForm('panelResult',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
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
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
                    
                }
            }
        },{
            xtype: 'uniTextfield',
            fieldLabel:'결의종류 값',
            name:'OPTION1',             //1:세출, 2:지급, 3:수입, 4:이체, 5:세목조정, 6:예산이월, 7:정정결의
            hidden:true
        },{
            xtype: 'uniTextfield',
            fieldLabel:'승인여부 값',        //'Y': 승인, 'N': 미승인
            name:'OPTION2',
            hidden:true            
        }]
    });
	
	var detailForm = Unilite.createForm('resultForm',{
		title:'● 년 결의현황',
        region: 'center',
        layout : {type : 'uniTable', columns : 1
//        tableAttrs: {width:'100%'}, 
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: 1000},//'100%'}
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'/*,width: '100%'*/}//width: '100%'/*,align : 'left'*/}
        },
        padding:'1 1 1 1',
        border:true,
        disabled:false,
        tbar:[{
            xtype:'button',
            itemId:'closeButton',
            text:'년마감',
            handler: function() {
            	if(!panelResult.getInvalidMessage()) return;
            	
            	
            	// 미승인 총건수가 1이상이면 월마감 버튼 비활성화
            	
            	//if()  승인 총건수가  1 이상일때만 실행
            	
            	
            	var param = {
                    DEPT_CODE: panelResult.getValue('DEPT_CODE'),
                    AC_YEAR: panelResult.getValue('AC_YEAR')
                    
                }
                Ext.getCmp('pageAll').getEl().mask('년마감 중...','loading-indicator');
                s_afb960ukrkocisService.closeMonth(param, function(provider, response)  {                           
                    if(!Ext.isEmpty(provider)){
                        UniAppManager.updateStatus("해당년이 마감되었습니다.");
                        
                        UniAppManager.app.onQueryButtonDown();      
                    }
                    Ext.getCmp('pageAll').getEl().unmask(); 
                    
                });
            }
        }],
        items: [{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 5,
                tableAttrs: {style: 'border : 0.1px solid #99BCE8;'},
                tdAttrs: {style: 'border : 0.1px solid #99BCE8;',  align : 'center'}
//                thAttrs: { align : 'center'}
            },
            padding:'10 0 0 10',
            defaults:{width: 140, height: 20},
            items: [
                { xtype: 'component',  html:'결의종류',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'component',  html:'미승인 총건수',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'component',  html:'미승인 총금액(현지화)',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'component',  html:'승인 총건수',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'component',  html:'승인 총금액(현지화)',tdAttrs: {style: 'background-color: #e8edf5;'}},
                
                { xtype: 'component',  html:'세출결의',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_COUNT_AFB503T', value:0, readOnly:true},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_AMT_AFB503T', value:0, decimalPrecision: 2, readOnly:true},
                { xtype: 'uniNumberfield', name:'TOTAL_COUNT_AFB503T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                            	if(el.value != 0){
                                    var param = '세출결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '1');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                            	}
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_AMT_AFB503T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '세출결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '1');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                
                { xtype: 'component',  html:'지급결의',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_COUNT_AFB700T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '지급결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '2');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'NO_TOTAL_AMT_AFB700T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '지급결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '2');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_COUNT_AFB700T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '지급결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '2');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_AMT_AFB700T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '지급결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '2');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'component',  html:'수입결의',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_COUNT_AFB800T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '수입결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '3');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'NO_TOTAL_AMT_AFB800T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '수입결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '3');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_COUNT_AFB800T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '수입결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '3');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_AMT_AFB800T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '수입결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '3');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'component',  html:'이체결의',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_COUNT_AFB740T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '이체결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '4');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'NO_TOTAL_AMT_AFB740T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '이체결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '4');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_COUNT_AFB740T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '이체결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '4');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_AMT_AFB740T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '이체결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '4');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                
                
                
                
                
                
                
                
                { xtype: 'component',  html:'세목조정',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_COUNT_AFB520T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '세목조정 상세리스트';
                                    
                                    detailListGrid.down('#AMT').setText("전용금액");
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '5');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'NO_TOTAL_AMT_AFB520T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '세목조정 상세리스트';
                                    
                                    detailListGrid.down('#AMT').setText("전용금액");
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '5');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_COUNT_AFB520T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '세목조정 상세리스트';
                                    
                                    detailListGrid.down('#AMT').setText("전용금액");
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '5');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_AMT_AFB520T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '세목조정 상세리스트';
                                    
                                    detailListGrid.down('#AMT').setText("전용금액");
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(false);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '5');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                
                
                
                
                
                { xtype: 'component',  html:'예산이월',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_COUNT_AFB530T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '예산이월 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(false);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '6');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'NO_TOTAL_AMT_AFB530T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '예산이월 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(false);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '6');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_COUNT_AFB530T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '예산이월 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(false);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '6');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_AMT_AFB530T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '예산이월 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(false);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '6');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                
                
           
                
                
                { xtype: 'component',  html:'정정결의',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_COUNT_AFB730T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '정정결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '7');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'NO_TOTAL_AMT_AFB730T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '정정결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '7');
                                    panelResult.setValue('OPTION2', 'N');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_COUNT_AFB730T', value:0, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '정정결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '7');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                { xtype: 'uniNumberfield', name:'TOTAL_AMT_AFB730T', value:0, decimalPrecision: 2, readOnly:true,
                    listeners: {
                        render: function(component) {
                            component.getEl().on('dblclick', function( event, el ) {
                                if(el.value != 0){
                                    var param = '정정결의 상세리스트';
                                    
                                    detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
                                    openDetailListWindow(param);
                                    panelResult.setValue('OPTION1', '7');
                                    panelResult.setValue('OPTION2', 'Y');
                                    detailListStore.loadStoreRecords();
                                }
                            });
                        }
                    }
                },
                
                
                
                
                
                
                
                
                { xtype: 'component',  html:'결의합계',tdAttrs: {style: 'background-color: #e8edf5;'}},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_COUNT', value:0, readOnly:true},
                { xtype: 'uniNumberfield', name:'NO_TOTAL_AMT', value:0, decimalPrecision: 2, readOnly:true},
                { xtype: 'uniNumberfield', name:'TOTAL_COUNT', value:0, readOnly:true},
                { xtype: 'uniNumberfield', name:'TOTAL_AMT', value:0, decimalPrecision: 2, readOnly:true}
            ]
        }],
        api: {
            load: 's_afb960ukrkocisService.selectForm'  
        }
    });
    var detailListGrid = Unilite.createGrid('detailListGrid', {
        layout: 'fit',
        region: 'center',
        excelTitle: '상세리스트',
        enableColumnHide: false,
        sortableColumns : false,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: false,
            useContextMenu: false,
            useMultipleSorting: false,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: false,         
                useStateList: false      
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
        store: detailListStore,
        selModel:'rowmodel',
        columns: [
            { dataIndex: 'BUDG_GUBUN'       ,width:80, hidden:true},
            {dataIndex: 'BUDG_CODE'         , width: 200,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
            { dataIndex: 'BUDG_NAME_1'  ,width:120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            { dataIndex: 'BUDG_NAME_4'  ,width:150},
            { dataIndex: 'BUDG_NAME_6'  ,width:150},
            { dataIndex: 'AMT'          ,width:120, itemId: 'AMT',
                summaryRenderer: function(val, params, data) {
                    return Ext.util.Format.number(val, '0,000.00');
                },
                summaryType:'sum'
            },
            { dataIndex: 'REMARK'       ,width:250}
            
        ],
        listeners:{
            afterrender:function()  {
                
                detailListGrid.getColumn('BUDG_GUBUN').setHidden(true);
            }
        }
    });   
    
    function openDetailListWindow(param) {
    	if(!Ext.isEmpty(detailListWindow)){
            detailListWindow.setTitle(param);
        }
        if(!detailListWindow) {
            detailListWindow = Ext.create('widget.uniDetailWindow', {
                title: param,
                width: 1100,
                height: 350,
                layout: {type: 'vbox', align: 'stretch'},
                items: [detailListGrid],
                tbar: [
                    '->',{
                        itemId: 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            detailListWindow.hide();
                            detailListGrid.reset();
                            detailListStore.clearData();
                        },
                        disabled: false
                    }
                ]
            })
        }
        detailListWindow.center();
        detailListWindow.show();
    }
    
    Unilite.Main( {
    	borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            id:'pageAll',
            items:[
                panelResult, detailForm  
            ]
        },panelSearch],
		id: 'afb960ukrApp',
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
			
			panelResult.setValue('OPTION1','');
			panelResult.setValue('OPTION2','');
						
            detailForm.mask('loading...');
            var param= panelResult.getValues();
			detailForm.getForm().load({
                params: param,
                success: function(form, action) {
                	detailForm.setValue('NO_TOTAL_COUNT',
                	   detailForm.getValue('NO_TOTAL_COUNT_AFB503T') + detailForm.getValue('NO_TOTAL_COUNT_AFB700T') + 
                	   detailForm.getValue('NO_TOTAL_COUNT_AFB800T') + detailForm.getValue('NO_TOTAL_COUNT_AFB740T') +
                	   
                	   detailForm.getValue('NO_TOTAL_COUNT_AFB520T') + detailForm.getValue('NO_TOTAL_COUNT_AFB530T') +
                	   detailForm.getValue('NO_TOTAL_COUNT_AFB730T') 
                	   
                	);
                	detailForm.setValue('NO_TOTAL_AMT',
                	   detailForm.getValue('NO_TOTAL_AMT_AFB503T') + detailForm.getValue('NO_TOTAL_AMT_AFB700T') + 
                       detailForm.getValue('NO_TOTAL_AMT_AFB800T') + detailForm.getValue('NO_TOTAL_AMT_AFB740T') +
                       
                       detailForm.getValue('NO_TOTAL_AMT_AFB520T') + detailForm.getValue('NO_TOTAL_AMT_AFB530T') +
                       detailForm.getValue('NO_TOTAL_AMT_AFB730T') 
                    );
                	detailForm.setValue('TOTAL_COUNT',
                	   detailForm.getValue('TOTAL_COUNT_AFB503T') + detailForm.getValue('TOTAL_COUNT_AFB700T') + 
                       detailForm.getValue('TOTAL_COUNT_AFB800T') + detailForm.getValue('TOTAL_COUNT_AFB740T') +
                       
                       detailForm.getValue('TOTAL_COUNT_AFB520T') + detailForm.getValue('TOTAL_COUNT_AFB530T') +
                       detailForm.getValue('TOTAL_COUNT_AFB730T') 
                    );
                	detailForm.setValue('TOTAL_AMT',
                	   detailForm.getValue('TOTAL_AMT_AFB503T') + detailForm.getValue('TOTAL_AMT_AFB700T') + 
                       detailForm.getValue('TOTAL_AMT_AFB800T') + detailForm.getValue('TOTAL_AMT_AFB740T') +
                       
                       detailForm.getValue('TOTAL_AMT_AFB520T') + detailForm.getValue('TOTAL_AMT_AFB530T') +
                       detailForm.getValue('TOTAL_AMT_AFB730T') 
                	);
                    detailForm.unmask();     
                    
                    
                    if(detailForm.getValue('NO_TOTAL_AMT') == 0 && detailForm.getValue('TOTAL_AMT') > 0 ){
                    	
                        detailForm.down('#closeButton').setDisabled(false);
                    }else{
                        detailForm.down('#closeButton').setDisabled(true);
                    }
                },
                failure: function(form, action) {
                    UniAppManager.app.fnInitInputFieldsDetailForm();    
                    detailForm.unmask();
                }
            });
		},
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
			detailForm.clearForm();
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
			
			panelSearch.setValue('AC_YEAR',new Date().getFullYear());
            panelResult.setValue('AC_YEAR',new Date().getFullYear());
            
            detailForm.down('#closeButton').setDisabled(true);
		},
		fnInitInputFieldsDetailForm: function(){
            detailForm.setValue('NO_TOTAL_COUNT_AFB503T',0);
            detailForm.setValue('NO_TOTAL_AMT_AFB503T',0);
            detailForm.setValue('TOTAL_COUNT_AFB503T',0);
            detailForm.setValue('TOTAL_AMT_AFB503T',0);
            detailForm.setValue('NO_TOTAL_COUNT_AFB700T',0);
            detailForm.setValue('NO_TOTAL_AMT_AFB700T',0);
            detailForm.setValue('TOTAL_COUNT_AFB700T',0);
            detailForm.setValue('TOTAL_AMT_AFB700T',0);
            detailForm.setValue('NO_TOTAL_COUNT_AFB800T',0);
            detailForm.setValue('NO_TOTAL_AMT_AFB800T',0);
            detailForm.setValue('TOTAL_COUNT_AFB800T',0);
            detailForm.setValue('TOTAL_AMT_AFB800T',0);
            detailForm.setValue('NO_TOTAL_COUNT_AFB740T',0);
            detailForm.setValue('NO_TOTAL_AMT_AFB740T',0);
            detailForm.setValue('TOTAL_COUNT_AFB740T',0);
            detailForm.setValue('TOTAL_AMT_AFB740T',0);
            
            detailForm.setValue('NO_TOTAL_COUNT_AFB520T',0);
            detailForm.setValue('NO_TOTAL_AMT_AFB520T',0);
            detailForm.setValue('TOTAL_COUNT_AFB520T',0);
            detailForm.setValue('TOTAL_AMT_AFB520T',0);
            
            detailForm.setValue('NO_TOTAL_COUNT_AFB530T',0);
            detailForm.setValue('NO_TOTAL_AMT_AFB530T',0);
            detailForm.setValue('TOTAL_COUNT_AFB530T',0);
            detailForm.setValue('TOTAL_AMT_AFB530T',0);
            
            detailForm.setValue('NO_TOTAL_COUNT_AFB730T',0);
            detailForm.setValue('NO_TOTAL_AMT_AFB730T',0);
            detailForm.setValue('TOTAL_COUNT_AFB730T',0);
            detailForm.setValue('TOTAL_AMT_AFB730T',0);
            
            detailForm.setValue('NO_TOTAL_COUNT',0);
            detailForm.setValue('NO_TOTAL_AMT',0);
            detailForm.setValue('TOTAL_COUNT',0);
            detailForm.setValue('TOTAL_AMT',0);
		}
	});
};


</script>
