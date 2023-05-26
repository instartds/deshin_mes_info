<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hep920ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직급-->
     
    
    <t:ExtComboStore comboType="AU" comboCode="H008" /> <!-- 담당업무-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >


function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'hep920ukrService.selectList',
            update: 'hep920ukrService.updateDetail',
            syncAll: 'hep920ukrService.saveAll'
        }
    });
	

	Unilite.defineModel('hep920ukrModel', {
        fields: [
            {name: 'COMP_CODE'         ,text: '법인코드'        ,type: 'string',allowBlank:false},
            {name: 'EVAL_YEARS'         ,text: '기준년도'        ,type: 'string',allowBlank:false},
            
            {name: 'ABIL_CODE'         ,text: '직급코드'        ,type: 'string'},
            {name: 'ABIL_NAME'         ,text: '직급'        ,type: 'string'},
            {name: 'PERSON_NUMB'         ,text: '사번'        ,type: 'string'},
            {name: 'NAME'           ,text: '성명'        ,type: 'string'},
            {name: 'JOB_CODE'           ,text: '담당업무코드'        ,type: 'string'},
            {name: 'JOB_NAME'         ,text: '담당업무'        ,type: 'string'},
            {name: 'JOIN_DATE'         ,text: '입사일'        ,type: 'uniDate'},
            {name: 'RETR_DATE'         ,text: '퇴사일'        ,type: 'uniDate'},
            {name: 'RETR_RESN'         ,text: '퇴사구분코드'        ,type: 'string'},
            {name: 'RETR_RESN_NAME'         ,text: '퇴사구분'        ,type: 'string'},
            
            {name: 'DEPT_CODE'         ,text: '현부서코드'        ,type: 'string'},
            {name: 'DEPT_NAME'         ,text: '현부서'        ,type: 'string'},
            
            
            {name: 'DEPT_CODE1'         ,text: '부서코드1'        ,type: 'string'},
            {name: 'DEPT_NAME1'         ,text: '부서'        ,type: 'string'},
            {name: 'WORK_MMCNT1'         ,text: '근무일수'        ,type: 'int'},
            {name: 'DEPT_POINT1'         ,text: '점수'        ,type : 'float', decimalPrecision:2, format:'0,000.00'},
            
            {name: 'DEPT_CODE2'         ,text: '부서코드2'        ,type: 'string'},
            {name: 'DEPT_NAME2'         ,text: '부서'        ,type: 'string'},
            {name: 'WORK_MMCNT2'         ,text: '근무일수'        ,type: 'int'},
            {name: 'DEPT_POINT2'         ,text: '점수'        ,type : 'float', decimalPrecision:2, format:'0,000.00'},
            
            {name: 'DEPT_CODE3'         ,text: '부서코드3'        ,type: 'string'},
            {name: 'DEPT_NAME3'         ,text: '부서'        ,type: 'string'},
            {name: 'WORK_MMCNT3'         ,text: '근무일수'        ,type: 'int'},
            {name: 'DEPT_POINT3'         ,text: '점수'        ,type : 'float', decimalPrecision:2, format:'0,000.00'},
            
            {name: 'DEPT_CODE4'         ,text: '부서코드4'        ,type: 'string'},
            {name: 'DEPT_NAME4'         ,text: '부서'        ,type: 'string'},
            {name: 'WORK_MMCNT4'         ,text: '근무일수'        ,type: 'int'},
            {name: 'DEPT_POINT4'         ,text: '점수'        ,type : 'float', decimalPrecision:2, format:'0,000.00'},
            
            {name: 'DEPT_CODE5'         ,text: '부서코드5'        ,type: 'string'},
            {name: 'DEPT_NAME5'         ,text: '부서'        ,type: 'string'},
            {name: 'WORK_MMCNT5'         ,text: '근무일수'        ,type: 'int'},
            {name: 'DEPT_POINT5'         ,text: '점수'        ,type : 'float', decimalPrecision:2, format:'0,000.00'},
            
            {name: 'LAST_POINT'         ,text: '최종점수'        ,type : 'float', decimalPrecision:2, format:'0,000.00'},
            {name: 'RMK'            ,text: '비고'        ,type: 'string'}
            
        ]
    });
    
//    function setConvert (value) {
//     return Math.floor(value*100) / 100;
//    }
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var detailStore = Unilite.createStore('hep920ukrStore', {
        model: 'hep920ukrModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
//        groupField:'DEPT_NAME',
//        autoSort :false,
//        sortOnLoad : false,
//        sorters :'DEPT_CODE',
        proxy: directProxy,
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();   //syncAll 수정
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false); 
                        
                        UniAppManager.app.onQueryButtonDown();
                        }
                    
                };
                this.syncAllDirect(config);
            } else {
                detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
	
	var panelResult = Unilite.createSearchForm('panelResult',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2,
            tableAttrs: {width: '100%'},
            tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
        },
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {width: 1000},    
            items:[{
                xtype: 'uniYearField',
                fieldLabel: '기준년도',
                name: 'EVAL_YEARS',
                allowBlank:false,
                width:250
            },
            Unilite.treePopup('DEPTTREE',{
                fieldLabel: '부서',
                valueFieldName:'DEPT',
                textFieldName:'DEPT_NAME' ,
                valuesName:'DEPTS' ,
                DBvalueFieldName:'TREE_CODE',
                DBtextFieldName:'TREE_NAME',
                selectChildren:true,
                validateBlank:true,
                autoPopup:true,
                useLike:true,
                width:450,
                labelWidth: 150,
                listeners: {
                    'onValuesChange':  function( field, records){
    //                            var tagfield = panelResult.getField('DEPTS') ;
    //                            tagfield.setStoreData(records)
                    }
                }
            }),{
                xtype: 'uniCombobox',
                fieldLabel: '담당업무',
                name: 'JOB_CODE',
                comboType: 'AU',
                comboCode: 'H008',
                width:250
            }]
        },{
            xtype: 'button',
            itemId : 'refBtn',
            text:'대상자점수생성',
//            margin: '0 100 0 0',
//            padding: '0 10 0 0',
            tdAttrs: {align : 'right',width:200},
            colspan:2,
            handler: function() {
                if(!panelResult.getInvalidMessage()){
                    return false;
                }
                 if(confirm('대상자점수 생성시 기존데이터는 삭제됩니다. \n생성 하시겠습니까?')) {
                        Ext.getBody().mask('작업 중...','loading-indicator');
                        
                        
                        
                    var param = panelResult.getValues();
                        
                    hep920ukrService.beforeSelect(param, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){
                            if(provider == 'Y'){
                                alert('대상자점수 생성을 성공 하였습니다.')
                            }else{
                                alert('대상자점수 생성을 실패 하였습니다.');
                            }
                            Ext.getBody().unmask();
                            	
                     /*       Hep920ukrService.createBaseData (param, function(provider, response) {
                                if (provider != 0){
                                    alert('데이터 생성 실패');
                                } else {
    //                                Ext.Msg.alert('확인', '대상자 생성이 완료되었습니다.');
                                }
                                
    //                            Ext.getBody().unmask();
                                // 조회
                                directMasterStore.loadStoreRecords();
                            });*/
                        }
                    });
                
                
                
//                var formParam= Ext.getCmp('searchForm').getValues();
//                var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
//                var mon = payDate.getMonth() + 1;
//                var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
                }
            }
         },{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {width: 1100},    
            items:[
            Unilite.popup('Employee', {
                fieldLabel: '사번', 
                valueFieldName: 'PERSON_NUMB',
                textFieldName: 'NAME',
                
                width:350
            }),{
                xtype: 'uniCombobox',
                fieldLabel: '직급',
                name: 'ABIL_CODE',
                comboType: 'AU',
                comboCode: 'H006',
                labelWidth: 50,
                width:285
            },{
                xtype: 'uniCombobox',
                fieldLabel: '퇴사구분',
                name: 'RETR_RESN',
                comboType: 'AU',
                comboCode: 'H023',
                labelWidth: 155,
                width:315
            }]
        
        }]
    });
	var detailGrid = Unilite.createGrid('hep920ukrGrid', {
        layout: 'fit',
        region: 'center',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: false,
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
            showSummaryRow: false,
            dock:'bottom'
        }],
        store: detailStore,
        selModel:'rowmodel',
        columns: [
            { dataIndex: 'COMP_CODE'             ,width:100,hidden:true},
            { dataIndex: 'EVAL_YEARS'            ,width:100,hidden:true},
            
            { dataIndex: 'ABIL_CODE'             ,width:100,hidden:true},
            { dataIndex: 'ABIL_NAME'             ,width:150,align:'center'},
            { dataIndex: 'PERSON_NUMB'           ,width:100,align:'center'},
            { dataIndex: 'NAME'                  ,width:80,align:'center'},
            { dataIndex: 'JOB_CODE'                  ,width:100,hidden:true},
            { dataIndex: 'JOB_NAME'             ,width:120,align:'center'},
            { dataIndex: 'JOIN_DATE'             ,width:100},
            { dataIndex: 'RETR_DATE'             ,width:100},
            { dataIndex: 'RETR_RESN'             ,width:100,hidden:true},
            { dataIndex: 'RETR_RESN_NAME'        ,width:120,align:'center'},
       
            { dataIndex: 'DEPT_CODE'             ,width:100,hidden:true},
            { dataIndex: 'DEPT_NAME'             ,width:150},
         
            {text:'부서1', 
                columns:[
                    { dataIndex: 'DEPT_CODE1'            ,width:150,hidden:true},
                    { dataIndex: 'DEPT_NAME1'            ,width:150,
                        editor: Unilite.popup('DEPT_G',{
                            autoPopup: true,
                            listeners:{
                                scope:this,
                                onSelected:function(records, type ) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE1',records[0]['TREE_CODE']);
                                    grdRecord.set('DEPT_NAME1',records[0]['TREE_NAME']);
                                    
                                    
                                    var param= {
                                        "U_DEPT_CODE" : records[0]['TREE_CODE']
                                        ,"U_DAY" : grdRecord.get('WORK_MMCNT1')
                                        ,"EVAL_YEARS" : grdRecord.get('EVAL_YEARS')
                                    }
                                    
                                    hep920ukrService.operSelect(param, function(provider, response){
                                        if(!Ext.isEmpty(provider)){
                                            grdRecord.set('DEPT_POINT1',provider);
                                        }else{
                                        	grdRecord.set('DEPT_POINT1',0.00);
                                        }
                                    
                                        
                                        grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                    });
                                    
                                },
                                onClear:function(type) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE1','');
                                    grdRecord.set('DEPT_NAME1','');
                                    
                                    grdRecord.set('DEPT_POINT1',0);
                                    grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                }
                            }
                        })
                    },
                    { dataIndex: 'WORK_MMCNT1'           ,width:80,align:'center'},
                    { dataIndex: 'DEPT_POINT1'           ,width:60,align:'center'}
                ]
            },
            
            {text:'부서2', 
                columns:[
                    { dataIndex: 'DEPT_CODE2'            ,width:150,hidden:true},
                    { dataIndex: 'DEPT_NAME2'            ,width:150,
                        editor: Unilite.popup('DEPT_G',{
                            autoPopup: true,
                            listeners:{
                                scope:this,
                                onSelected:function(records, type ) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE2',records[0]['TREE_CODE']);
                                    grdRecord.set('DEPT_NAME2',records[0]['TREE_NAME']);
                                    
                                    
                                    var param= {
                                        "U_DEPT_CODE" : records[0]['TREE_CODE']
                                        ,"U_DAY" : grdRecord.get('WORK_MMCNT2')
                                        ,"EVAL_YEARS" : grdRecord.get('EVAL_YEARS')
                                    }
                                    
                                    hep920ukrService.operSelect(param, function(provider, response){
                                        if(!Ext.isEmpty(provider)){
                                            grdRecord.set('DEPT_POINT2',provider);
                                        }else{
                                            grdRecord.set('DEPT_POINT2',0.00);
                                        }
                                    
                                        
                                        grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                    
                                    });
                                    
                                },
                                onClear:function(type) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE2','');
                                    grdRecord.set('DEPT_NAME2','');
                                    
                                    grdRecord.set('DEPT_POINT2',0);
                                    grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                }
                            }
                        })
                    
                    },
                    { dataIndex: 'WORK_MMCNT2'           ,width:80,align:'center'},
                    { dataIndex: 'DEPT_POINT2'           ,width:60,align:'center'}
                ]
            },
            
            {text:'부서3', 
                columns:[
                    { dataIndex: 'DEPT_CODE3'            ,width:150,hidden:true},
                    { dataIndex: 'DEPT_NAME3'            ,width:150,
                        editor: Unilite.popup('DEPT_G',{
                            autoPopup: true,
                            listeners:{
                                scope:this,
                                onSelected:function(records, type ) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE3',records[0]['TREE_CODE']);
                                    grdRecord.set('DEPT_NAME3',records[0]['TREE_NAME']);
                                    
                                    
                                    var param= {
                                        "U_DEPT_CODE" : records[0]['TREE_CODE']
                                        ,"U_DAY" : grdRecord.get('WORK_MMCNT3')
                                        ,"EVAL_YEARS" : grdRecord.get('EVAL_YEARS')
                                    }
                                    
                                    hep920ukrService.operSelect(param, function(provider, response){
                                        if(!Ext.isEmpty(provider)){
                                            grdRecord.set('DEPT_POINT3',provider);
                                        }else{
                                            grdRecord.set('DEPT_POINT3',0.00);
                                        }
                                    
                                        
                                        grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                    
                                    });
                                    
                                },
                                onClear:function(type) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE3','');
                                    grdRecord.set('DEPT_NAME3','');
                                    
                                    grdRecord.set('DEPT_POINT3',0);
                                    grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                }
                            }
                        })
                    
                    },
                    { dataIndex: 'WORK_MMCNT3'           ,width:80,align:'center'},
                    { dataIndex: 'DEPT_POINT3'           ,width:60,align:'center'}
                ]
            },
            
            {text:'부서4', 
                columns:[
                    { dataIndex: 'DEPT_CODE4'            ,width:150,hidden:true},
                    { dataIndex: 'DEPT_NAME4'            ,width:150,
                        editor: Unilite.popup('DEPT_G',{
                            autoPopup: true,
                            listeners:{
                                scope:this,
                                onSelected:function(records, type ) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE4',records[0]['TREE_CODE']);
                                    grdRecord.set('DEPT_NAME4',records[0]['TREE_NAME']);
                                    
                                    
                                    var param= {
                                        "U_DEPT_CODE" : records[0]['TREE_CODE']
                                        ,"U_DAY" : grdRecord.get('WORK_MMCNT4')
                                        ,"EVAL_YEARS" : grdRecord.get('EVAL_YEARS')
                                    }
                                    
                                    hep920ukrService.operSelect(param, function(provider, response){
                                        if(!Ext.isEmpty(provider)){
                                            grdRecord.set('DEPT_POINT4',provider);
                                        }else{
                                            grdRecord.set('DEPT_POINT4',0.00);
                                        }
                                    
                                        
                                        grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                    
                                    });
                                    
                                },
                                onClear:function(type) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE4','');
                                    grdRecord.set('DEPT_NAME4','');
                                    
                                    grdRecord.set('DEPT_POINT4',0);
                                    grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                }
                            }
                        })
                    
                    },
                    { dataIndex: 'WORK_MMCNT4'           ,width:80,align:'center'},
                    { dataIndex: 'DEPT_POINT4'           ,width:60,align:'center'}
                ]
            },
            
            {text:'부서5', 
                columns:[
                    { dataIndex: 'DEPT_CODE5'            ,width:150,hidden:true},
                    { dataIndex: 'DEPT_NAME5'            ,width:150,
                        editor: Unilite.popup('DEPT_G',{
                            autoPopup: true,
                            listeners:{
                                scope:this,
                                onSelected:function(records, type ) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE5',records[0]['TREE_CODE']);
                                    grdRecord.set('DEPT_NAME5',records[0]['TREE_NAME']);
                                    
                                    
                                    var param= {
                                        "U_DEPT_CODE" : records[0]['TREE_CODE']
                                        ,"U_DAY" : grdRecord.get('WORK_MMCNT5')
                                        ,"EVAL_YEARS" : grdRecord.get('EVAL_YEARS')
                                    }
                                    
                                    hep920ukrService.operSelect(param, function(provider, response){
                                        if(!Ext.isEmpty(provider)){
                                            grdRecord.set('DEPT_POINT5',provider);
                                        }else{
                                            grdRecord.set('DEPT_POINT5',0.00);
                                        }
                                    
                                        
                                        grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                    
                                    });
                                    
                                },
                                onClear:function(type) {
                                    var grdRecord = detailGrid.uniOpt.currentRecord;
                                    grdRecord.set('DEPT_CODE5','');
                                    grdRecord.set('DEPT_NAME5','');
                                    
                                    grdRecord.set('DEPT_POINT5',0);
                                    grdRecord.set('LAST_POINT',grdRecord.get('DEPT_POINT1')+ grdRecord.get('DEPT_POINT2') + grdRecord.get('DEPT_POINT3') + grdRecord.get('DEPT_POINT4') + grdRecord.get('DEPT_POINT5'));
                                }
                            }
                        })
                    
                    },
                    { dataIndex: 'WORK_MMCNT5'           ,width:80,align:'center'},
                    { dataIndex: 'DEPT_POINT5'           ,width:60,align:'center'}
                ]
            },
            { dataIndex: 'LAST_POINT'            ,width:80,align:'center'},
            { dataIndex: 'RMK'                   ,width:150}
                
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		if( UniUtils.indexOf(e.field, ['DEPT_NAME1','WORK_MMCNT1','DEPT_NAME2','WORK_MMCNT2','DEPT_NAME3',
        		                               'WORK_MMCNT3','DEPT_NAME4','WORK_MMCNT4','DEPT_NAME5','WORK_MMCNT5'])){
        			return true;
        		}else{
        			return false;
        		}
        	}
        }
    });   

    Unilite.Main( {
    	borderItems:[{
            region: 'center',
            layout: {type: 'vbox', align: 'stretch'},
            border: false,
            autoScroll: true,
            id:'pageAll',
            items: [
            	panelResult, detailGrid
            ]
        }],
		id  : 'hep920ukrApp',
		fnInitBinding: function(){
            UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','print','newData'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			panelResult.getField('EVAL_YEARS').setReadOnly(true);//조회 버튼 클릭 시 기준 년도 버튼 readOnly true
            detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function() {
            detailStore.saveStore();
        },
		onResetButtonDown: function() {
            panelResult.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			UniAppManager.app.fnInitBinding();
		},
		fnInitInputFields: function(){
			panelResult.setValue('EVAL_YEARS',new Date().getFullYear());
            panelResult.getField('EVAL_YEARS').setReadOnly(false);
		}
	});
	
	
	Unilite.createValidator('validator01', {
        store: detailStore,
        grid: detailGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            var rv = true;
/*            
            switch(fieldName) {
                case "DEPT_POINT" :
                
                var a = 0 ;
                
                a = Math.floor(newValue*100) / 100;
                
                alert(a);
            	
            }*/
//            52002
            var records = detailStore.data.items;
            switch(fieldName) {
                case "WORK_MMCNT1" : //근무일수1
                
                var param= {
                    "U_DEPT_CODE" : record.get('DEPT_CODE1')
                    ,"U_DAY" : newValue
                    ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                }
                
                hep920ukrService.operSelect(param, function(provider, response){
                    if(!Ext.isEmpty(provider)){
                        record.set('DEPT_POINT1',provider);
                    }else{
                        record.set('DEPT_POINT1',0.00);	
                    }
                    
                    record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                    
                });
                
                
                
                break;
                case "WORK_MMCNT2" : //근무일수2
                
                var param= {
                    "U_DEPT_CODE" : record.get('DEPT_CODE2')
                    ,"U_DAY" : newValue
                    ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                }
                
                hep920ukrService.operSelect(param, function(provider, response){
                    if(!Ext.isEmpty(provider)){
                        record.set('DEPT_POINT2',provider);
                    }else{
                        record.set('DEPT_POINT2',0.00); 
                    }
                    record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                });
                break;
                case "WORK_MMCNT3" : //근무일수3
                
                var param= {
                    "U_DEPT_CODE" : record.get('DEPT_CODE3')
                    ,"U_DAY" : newValue
                    ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                }
                
                hep920ukrService.operSelect(param, function(provider, response){
                    if(!Ext.isEmpty(provider)){
                        record.set('DEPT_POINT3',provider);
                    }else{
                        record.set('DEPT_POINT3',0.00); 
                    }
                    record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                });
                break;
                case "WORK_MMCNT4" : //근무일수4
                
                var param= {
                    "U_DEPT_CODE" : record.get('DEPT_CODE4')
                    ,"U_DAY" : newValue
                    ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                }
                
                hep920ukrService.operSelect(param, function(provider, response){
                    if(!Ext.isEmpty(provider)){
                        record.set('DEPT_POINT4',provider);
                    }else{
                        record.set('DEPT_POINT4',0.00); 
                    }
                    record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                });
                break;
                case "WORK_MMCNT5" : //근무일수5
                
                var param= {
                    "U_DEPT_CODE" : record.get('DEPT_CODE5')
                    ,"U_DAY" : newValue
                    ,"EVAL_YEARS" : record.get('EVAL_YEARS')
                }
                
                hep920ukrService.operSelect(param, function(provider, response){
                    if(!Ext.isEmpty(provider)){
                        record.set('DEPT_POINT5',provider);
                    }else{
                        record.set('DEPT_POINT5',0.00); 
                    }
                    record.set('LAST_POINT',record.get('DEPT_POINT1')+ record.get('DEPT_POINT2') + record.get('DEPT_POINT3') + record.get('DEPT_POINT4') + record.get('DEPT_POINT5'));
                });
                break;
            }
            
            return rv;
        }
    });
};

</script>
