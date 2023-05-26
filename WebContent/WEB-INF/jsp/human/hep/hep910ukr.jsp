<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hep910ukr"  >
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >


function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'hep910ukrService.selectList',
            update: 'hep910ukrService.updateDetail',
            syncAll: 'hep910ukrService.saveAll'
        }
    });
	

	Unilite.defineModel('hep910ukrModel', {
        fields: [
		 {name: 'COMP_CODE'         ,text: '법인코드'        ,type: 'string',allowBlank:false },
         {name: 'EVAL_YEARS'         ,text: '기준년도'        ,type: 'string',allowBlank:false },
             {name: 'DEPT_CODE'         ,text: '부서코드'       ,type: 'string' },
             {name: 'DEPT_NAME'         ,text: '부서'         ,type: 'string' },
             {name: 'DEPT_TEAM_CODE'    ,text: '팀코드'       ,type: 'string' },
             {name: 'DEPT_TEAM_NAME'    ,text: '팀'       ,type: 'string' },
             {name: 'TEAM_POINT'        ,text: '평가점수'       ,type : 'float', decimalPrecision:2, format:'0,000.00' },
             {name: 'WEIGHT_POINT'      ,text: '가중치'       ,type: 'int' },
             {name: 'FINAL_TEAM_POINT'  ,text: '평가점수 합계'       ,type: 'float', decimalPrecision:2, format:'0,000.00' },
             {name: 'DEPT_POINT'        ,text: '부서평균'       ,type : 'float', decimalPrecision:2, format:'0,000.00'
//             convert: setConvert
             }//,type: 'uniNumber' }
        ]
    });
    
//    function setConvert (value) {
//     return Math.floor(value*100) / 100;
//    }
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var detailStore = Unilite.createStore('hep910ukrStore', {
        model: 'hep910ukrModel',
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
            var paramMaster= panelSearch.getValues();   //syncAll 수정
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    
                    success: function(batch, option) {
                        panelSearch.getForm().wasDirty = false;
                        panelSearch.resetDirtyStatus();
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
            var param = Ext.getCmp('panelSearch').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
	
	var panelSearch = Unilite.createSearchForm('panelSearch',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3,
            tableAttrs: {width: '100%'},
            tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
        },
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {width: 600},    
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
                width:400,
                listeners: {
                    'onValuesChange':  function( field, records){
    //                            var tagfield = panelSearch.getField('DEPTS') ;
    //                            tagfield.setStoreData(records)
                    }
                }
            })]
        }
/*        {
            xtype: 'button',
            itemId : 'refBtn',
            text:'부서평균계산',
//            margin: '0 100 0 0',
//            padding: '0 10 0 0',
            tdAttrs: {align : 'center',width:200},
            handler: function() {
                if(!panelSearch.getInvalidMessage()){
                    return false;
                }
                
//                var formParam= Ext.getCmp('searchForm').getValues();
//                var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
//                var mon = payDate.getMonth() + 1;
//                var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
            }
         }*/
        ]
    });
	var detailGrid = Unilite.createGrid('hep910ukrGrid', {
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
            { dataIndex: 'COMP_CODE'        ,width:100, hidden:true},
            { dataIndex: 'EVAL_YEARS'       ,width:100, hidden:true},
            { dataIndex: 'DEPT_CODE'        ,width:100, hidden:true},
            { dataIndex: 'DEPT_NAME'        ,width:150},
            { dataIndex: 'DEPT_TEAM_CODE'   ,width:100, hidden:true},
            { dataIndex: 'DEPT_TEAM_NAME'   ,width:200},
//            Ext.applyIf({ dataIndex: 'TEAM_POINT'       ,width:100}, {format: '0,000.00' }),
            { dataIndex: 'TEAM_POINT'     ,width:100},
            { dataIndex: 'WEIGHT_POINT'     ,width:100},
            { dataIndex: 'FINAL_TEAM_POINT' ,width:100},
            
            
//            Ext.applyIf({ dataIndex: 'DEPT_POINT'       ,width:100}, {decimalPrecision:2,format: '0,000.00' })
            { dataIndex: 'DEPT_POINT'       ,width:100}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		if( UniUtils.indexOf(e.field, ['TEAM_POINT','WEIGHT_POINT','DEPT_POINT'])){
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
            	panelSearch, detailGrid
            ]
        }],
		id  : 'hep910ukrApp',
		fnInitBinding: function(){
            UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','print','newData'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			panelSearch.getField('EVAL_YEARS').setReadOnly(true);//조회 버튼 클릭 시 기준 년도 버튼 readOnly true
            detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function() {
            detailStore.saveStore();
        },
		onResetButtonDown: function() {
            panelSearch.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			UniAppManager.app.fnInitBinding();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('EVAL_YEARS',new Date().getFullYear());
            panelSearch.getField('EVAL_YEARS').setReadOnly(false);
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
            
            var records = detailStore.data.items;
            switch(fieldName) {
                case "TEAM_POINT" : //평가점수
                
                    record.set('FINAL_TEAM_POINT', newValue * record.get('WEIGHT_POINT'));
                    
                    var sumV = 0;
                    var cnt = 0;
                  	Ext.each(records, function(item, i){
                        if(record.get('DEPT_CODE') == item.get('DEPT_CODE')){
                            sumV = sumV + item.get('FINAL_TEAM_POINT');
                            cnt = cnt + 1;
                        }
                    })
                    Ext.each(records, function(item, i){
                        if(record.get('DEPT_CODE') == item.get('DEPT_CODE')){
                            item.set('DEPT_POINT',Math.floor(sumV/cnt*100)/100);
                            
                        }
                    })
              	 
              	break;
                case "WEIGHT_POINT" : //가중치
                
                    record.set('FINAL_TEAM_POINT', newValue * record.get('TEAM_POINT'));
                
                    var sumV = 0;
                    var cnt = 0;
                    Ext.each(records, function(item, i){
                        if(record.get('DEPT_CODE') == item.get('DEPT_CODE')){
                            sumV = sumV + item.get('FINAL_TEAM_POINT');
                            cnt = cnt + 1;
                        }
                    })
                    Ext.each(records, function(item, i){
                        if(record.get('DEPT_CODE') == item.get('DEPT_CODE')){
                            item.set('DEPT_POINT',Math.floor(sumV/cnt*100)/100);
                            
                        }
                    })
                    
                break;
                
                case "DEPT_POINT" : //부서평균
                    
                    Ext.each(records, function(item, i){
                        if(record.get('DEPT_CODE') == item.get('DEPT_CODE')){
                        	item.set('DEPT_POINT',newValue);
                        }
                    })
                break;
            }
            
            return rv;
        }
    });
};

</script>
