<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms130ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="mms130ukrv"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->
</t:appConfig>
</script>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell1 {
background-color: #fed9fe;
}
.x-change-cell2 {
background-color: #e5fcca;
}
</style>

<script type="text/javascript" >

var searchOrderWindow;

function appMain() {
	var chkinterval = null;

	var directProxyMaster = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'mms130ukrvService.selectList'
//            create: 'mms130ukrvService.insertMaster',
//            update: 'mms130ukrvService.updateMaster',
//            destroy: 'mms130ukrvService.deleteMaster',
//            syncAll: 'mms130ukrvService.saveAllMaster'
        }
    }); 
    
    Unilite.defineModel('mainModel', {
        fields: [
            {name: 'ISSUE_SEQ'       ,text:'순번'        ,type: 'int'},
            {name: 'SO_NUM'       ,text:'수주번호'        ,type: 'string'},
            {name: 'SOF_CUSTOM_NAME'       ,text:'수주처'        ,type: 'string'},
            {name: 'ITEM_CODE'       ,text:'품번'        ,type: 'string'},
            {name: 'ITEM_NAME'       ,text:'품명'        ,type: 'string'},
            {name: 'SPEC'       		,text:'색상/규격/재질'        ,type: 'string'},
            {name: 'PACK_UNIT_Q'       ,text:'입수량'        ,type: 'uniQty'},
            {name: 'BOX_Q'       	,text:'박스수량'        ,type: 'uniQty'},
            {name: 'EACH_Q'       	,text:'낱개'        ,type: 'uniQty'},
            {name: 'ISSUE_Q'      	 ,text:'입고량'        ,type: 'uniQty'},
            {name: 'LOSS_Q'       	,text:'LOSS량'        ,type: 'uniQty'}
        ]
    });
 
    var masterStore = Unilite.createStore('masterStore',{
        model: 'mainModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxyMaster,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param,
                  callback : function(records, operation, success) {
					
				  }
            });
        },
/*        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();    //syncAll 수정
            if(inValidRecs.length == 0 )    {
                var config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                 		masterStore.loadStoreRecords();
                     }
                };
                this.syncAllDirect(config);
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },*/
		listeners:{
			load:function(store, records, successful, eOpts)	{
				
	    		setTimeout( function() {
	    			
				panelResult.getField('BARCODE').focus();
    			}, 50 );
    			
				clearInterval(chkinterval);
				chkinterval = setInterval(function(){
				
					panelResult.setValue('ISSUE_NUM','');
					UniAppManager.app.onResetButtonDown();
				}, 10000);	
			
//    			setTimeout( function() {
//	    			
//					panelResult.setValue('ISSUE_NUM','');
//					UniAppManager.app.onResetButtonDown();
//    			}, 5000 );
    			
//	    		setTimeout( Ext.bind(resetProc()), 5000 );
//    			clearTimeout(resetProc());
			}
		}

    });
    
//    function resetProc() {
//		panelResult.setValue('ISSUE_NUM','');
//		UniAppManager.app.onResetButtonDown();
//	}
   
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [/*{
        	xtype:'component',
        	html:'바코드접수',
        	colspan:2,
        	
			height:60,
			width:600,
			fieldStyle    : {
		     'fontSize'     : '50px'
		   }
        },*/{
			fieldLabel: '바코드',
			xtype: 'uniTextfield',
			name: 'BARCODE',/*
			height:60,
			width:600,
			fieldStyle    : {
		     'fontSize'     : '50px'
		   },*/
			listeners: {
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
					var newValue = panelResult.getValue('BARCODE');
						
						if(!Ext.isEmpty(newValue)) {
							Ext.getBody().mask('저장중...', 'loading');
							var param= {
								BARCODE : newValue
							}
							mms130ukrvService.mms130ukrvSave(param , function(provider, response){
								if(!Ext.isEmpty(provider))	{
								
		            				UniAppManager.updateStatus('정상처리 되었습니다. 접수번호는'+ provider.RECEIPT_NUM +'입니다.');
									panelResult.setValue('ISSUE_NUM',provider.BARCODE);
		            				panelResult.setValue('V_CUSTOM_CODE',provider.V_CUSTOM_CODE);
		            				panelResult.setValue('V_CUSTOM_NAME',provider.V_CUSTOM_NAME);
									Ext.getBody().unmask();
								}else{
									panelResult.setValue('ISSUE_NUM',panelResult.getValue('BARCODE'));
								}
								
								panelResult.setValue('BARCODE','');
        						panelResult.getField('BARCODE').focus();
					        	masterStore.loadStoreRecords();
					        	
								Ext.getBody().unmask();
							})
						}
						
					}
				}
			}
		},{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaults : {enforceMaxLength: true , readOnly:true},
			items:[{
				fieldLabel: '공급업체',
				name: 'V_CUSTOM_CODE',
				xtype: 'uniTextfield'/*,
				height:60,
				width:400,
				fieldStyle    : {
			     'fontSize'     : '50px'
			   }*/
			},{
				fieldLabel: '',
				name: 'V_CUSTOM_NAME',
				xtype: 'uniTextfield'/*,
				height:60,
				width:600,
				fieldStyle    : {
			     'fontSize'     : '50px'
			   }*/
			}]
	    },{
			fieldLabel: '납품번호',
			name: 'ISSUE_NUM',
			xtype: 'uniTextfield',
			hidden:true
		}]
    });

    var masterGrid = Unilite.createGrid('masterGrid', {
        layout : 'fit',
        region: 'center',
        store: masterStore,
        selModel: 'rowmodel',
        uniOpt: {
            useGroupSummary: true,
            state: {
				useState: false,
				useStateList: false
			},
            pivot:{
				use : false,
				pivotWin : null
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
        columns:  [
            { dataIndex: 'ISSUE_SEQ'                 , width: 60},
            { dataIndex: 'SO_NUM'                 , width: 100},
            { dataIndex: 'SOF_CUSTOM_NAME'           , width: 200},
            { dataIndex: 'ITEM_CODE'                 , width: 200,hidden:true},
            { dataIndex: 'ITEM_NAME'                 , width: 200},
            { dataIndex: 'SPEC'       	           , width: 150},
            { dataIndex: 'PACK_UNIT_Q'               , width: 100},
            { dataIndex: 'BOX_Q'       	           , width: 100},
            { dataIndex: 'EACH_Q'       	           , width: 100},
            { dataIndex: 'ISSUE_Q'      	           , width: 100},
            { dataIndex: 'LOSS_Q'       	           , width: 100}
            
        ],
	/*	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('CORE_CODE').substring(record.get('CORE_CODE').length-1) != 0){
					cls = 'x-change-cell_bg_FFFFC6';	
				}
				return cls;
	        }
	    },*/
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {},
           
        	beforeselect: function(){
        	},
            selectionchange:function( model1, selected, eOpts ){
            },
            onGridDblClick:function(grid, record, cellIndex, colName) {
            },
			cellclick :function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			}
        }
    });

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[panelResult,masterGrid]
        }],
		uniOpt:{showKeyText:false,
				showToolbar: false
//        	forceToolbarbutton:true
		},
        id  : 'mms130ukrvApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            masterStore.loadStoreRecords();
        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
			masterStore.loadData({});
            this.setDefault();
        },
        
        onSaveDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   // 필수체크
			
            if(masterStore.isDirty()) {
                masterStore.saveStore();
            }
        },
        setDefault: function() {
        	
            UniAppManager.setToolbarButtons(['query','save','newData', 'delete', 'deleteAll','reset'],false);
            
    		setTimeout( function() {
        		panelResult.getField('BARCODE').focus();
			}, 50 );
            
            
        }
    });
}
</script>