<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp120rkrv_kd"  >
<t:ExtComboStore comboType="BOR120" pgmId="s_pmp120rkrv_kd"  />          <!-- 사업장 -->
<t:ExtComboStore comboType="WU" />					<!-- 작업장  -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >


function appMain() {
	
    var statusStore = Unilite.createStore('statusComboStore', {  
        fields: ['text', 'value'],
        data :  [
            {'text':'미완료'  , 'value':'N'},
            {'text':'완료'   , 'value':'Y'}
        ]
    });

	Unilite.defineModel('printInfoModel', {
        fields: [
            {name: 'COMP_CODE'        ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'      ,type: 'string'},
            {name: 'DIV_CODE'         ,text: '<t:message code="system.label.base.division" default="사업장"/>'       ,type: 'string',allowBlank:false},
            {name: 'WKORD_NUM'        ,text: '작업지시번호'   ,type: 'string'},
            
            {name: 'SPEC'        	  ,text: '품번'        ,type: 'string',allowBlank:false},
            {name: 'ITEM_CODE'        ,text: '품목코드'        ,type: 'string',allowBlank:false},
            {name: 'ITEM_NAME'        ,text: '<t:message code="system.label.base.itemname2" default="품명"/>'        ,type: 'string',allowBlank:false},
            
            {name: 'STOCK_UNIT'       ,text: '단위'       ,type: 'string'},
            
            {name: 'LOT_NO'           ,text: 'LOT NO'     ,type: 'string',allowBlank:false},//,maxLength: 6
            {name: 'PACK_QTY'         ,text: '입수량'      ,type: 'int',allowBlank:false},

            {name: 'PROG_WORK_CODE'       ,text: '공정코드'       ,type: 'string'}
           
        ]
    });
    
    Unilite.defineModel('referenceInfoModel', {
        fields: [
            {name: 'COMP_CODE'        ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'              ,type: 'string',allowBlank:false},
            {name: 'DIV_CODE'         ,text: '<t:message code="system.label.base.division" default="사업장"/>'               ,type: 'string',allowBlank:false},
            
            {name: 'WORK_SHOP_CODE'   ,text: '작업장'           ,type: 'string',comboType: 'WU',allowBlank:false},
            
            {name: 'WKORD_NUM'        ,text: '작업지시번호'           ,type: 'string',allowBlank:false},
            {name: 'ITEM_CODE'        ,text: '품목코드'                ,type: 'string'},
            {name: 'ITEM_NAME'        ,text: '<t:message code="system.label.base.itemname2" default="품명"/>'                ,type: 'string'},
            {name: 'SPEC'             ,text: '<t:message code="system.label.base.spec" default="규격"/>'                ,type: 'string'},
	
            {name: 'PRODT_WKORD_DATE' ,text: '작업지시일'              ,type: 'uniDate'},
            {name: 'LOT_NO'           ,text: 'LOT NO'                ,type: 'string'},
            
            {name: 'WKORD_Q'          ,text: '작업지시량'              ,type: 'uniQty'},
            {name: 'PRINT_YN'         ,text: '출력여부'                ,type: 'string', xtype: 'uniCombobox'	, store: statusStore},
            
            {name: 'STOCK_UNIT'       ,text: 'STOCK_UNIT'           ,type: 'string'},
            
            {name: 'PACK_QTY'         ,text: 'PACK_QTY'           ,type: 'string'},
            
            {name: 'PRINT_Q'         ,text: 'PRINT_Q'           ,type: 'int'}
            
        ]
    });
    
    var printInfoStore = Unilite.createStore('printInfoStore', {
        model: 'printInfoModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: true,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        /*proxy: {
            type: 'direct',
            api: {          
                read: 's_pmp120rkrv_kdService.barCodeDataSelect'                   
            }
        },*/
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
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    
    var referenceInfoStore = Unilite.createStore('referenceInfoStore', {
        model: 'referenceInfoModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 's_pmp120rkrv_kdService.referenceInfo'                   
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
            var param = referenceInfoForm.getValues();
            param.DIV_CODE = printInfoForm.getValue('DIV_CODE');
            
            this.load({
                params: param
            });
        }
    }); 
    
	 var printInfoGrid = Unilite.createGrid('printInfoGrid', {
        layout: 'fit',
        region: 'center',
        width:1000,
        height:75,
        colspan:2,
        uniOpt: {
            userToolbar:false,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: true,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: false,         
                useStateList: false      
            }
        },
        store: printInfoStore,
        selModel:'rowmodel',
        columns: [
             { dataIndex: 'COMP_CODE'         ,width:100, hidden:true },
            { dataIndex: 'DIV_CODE'         ,width:100, hidden:true  },
            { dataIndex: 'WKORD_NUM'         ,width:100, hidden:true  },
            
            { dataIndex: 'SPEC'            ,width:200   },
            { dataIndex: 'ITEM_CODE'       ,width:200,
                editor: Unilite.popup('DIV_PUMOK_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = printInfoGrid.uniOpt.currentRecord;
                            grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
                            grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
                            grdRecord.set('SPEC',records[0]['SPEC']);
                            grdRecord.set('STOCK_UNIT',records[0]['STOCK_UNIT']);
                            
//                            grdRecord.set('LOT_NO',UniDate.getDbDateStr(UniDate.get('today')).substring(2,8));
                            
                        },
                        onClear:function(type) {
                            var grdRecord = printInfoGrid.uniOpt.currentRecord;
                            grdRecord.set('ITEM_CODE','');
                            grdRecord.set('ITEM_NAME','');
                            grdRecord.set('SPEC','');
                            grdRecord.set('LOT_NO','');
                            grdRecord.set('STOCK_UNIT','');
                            
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'DIV_CODE' :printInfoForm.getValue('DIV_CODE')
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })
            },
            { dataIndex: 'ITEM_NAME'       ,width:200
                /*editor: Unilite.popup('DIV_PUMOK_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = printInfoGrid.uniOpt.currentRecord;
                            grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
                            grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
                            grdRecord.set('SPEC',records[0]['SPEC']);
                            
                            grdRecord.set('LOT_NO',UniDate.getDbDateStr(UniDate.get('today')).substring(2,8));
                            
                            var param ={
		                        "ITEM_CODE": records[0]['ITEM_CODE']
		                    }
		                    s_pmp120rkrv_kdService.checkMarkGubun(param, function(provider, response)  {
		                        if(!Ext.isEmpty(provider)){
		                            printInfoForm.setValue('KS_GUBUN','2');
		                            grdRecord.set('KS_MARK_GUBUN',provider.KS_MARK_GUBUN);
		                            grdRecord.set('KS_MARK_NAME',provider.KS_MARK_NAME);
		                        }else{
		                            printInfoForm.setValue('KS_GUBUN','1');
		                            grdRecord.set('KS_MARK_GUBUN','');
		                            grdRecord.set('KS_MARK_NAME','');
		                        }
		                    });
                            
                        },
                        onClear:function(type) {
                            var grdRecord = printInfoGrid.uniOpt.currentRecord;
                            grdRecord.set('ITEM_CODE','');
                            grdRecord.set('ITEM_NAME','');
                            grdRecord.set('SPEC','');
                            grdRecord.set('TYPE','');
                            grdRecord.set('KS_MARK_GUBUN','');
                            grdRecord.set('KS_MARK_NAME','');
                            grdRecord.set('LOT_NO','');
                            printInfoForm.setValue('KS_GUBUN','1');
                          
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'DIV_CODE' :printInfoForm.getValue('DIV_CODE')
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                })*/
            },
            { dataIndex: 'STOCK_UNIT'            ,width:100   },
            { dataIndex: 'LOT_NO'        ,width:120 },
            { dataIndex: 'PACK_QTY'        ,width:80   }
        
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','SPEC','LOT_NO','PACK_QTY'])){
                    return true;
                }else{
                	return false;
                }
            }
        }
    });
    var referenceInfoGrid = Unilite.createGrid('referenceInfoGrid', {
        layout: 'fit',
        region: 'center',
//        width:1100,
//        height:70,
        colspan:3,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: false,         
                useStateList: false      
            }
        },
        store: referenceInfoStore,
        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: false, toggleOnClick: false, mode:'SINGLE',
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                	
                	
                       
                    var selectPrintInfo = printInfoGrid.getSelectedRecord();
                    
                    
                    
                    selectPrintInfo.set('COMP_CODE',selectRecord.get('COMP_CODE'));
                    selectPrintInfo.set('DIV_CODE',selectRecord.get('DIV_CODE'));
                    selectPrintInfo.set('WKORD_NUM',selectRecord.get('WKORD_NUM'));
                    
                    selectPrintInfo.set('ITEM_CODE',selectRecord.get('ITEM_CODE'));
                    selectPrintInfo.set('ITEM_NAME',selectRecord.get('ITEM_NAME'));
                    selectPrintInfo.set('SPEC',selectRecord.get('SPEC'));
                    
                    selectPrintInfo.set('STOCK_UNIT',selectRecord.get('STOCK_UNIT'));
                    
                    selectPrintInfo.set('LOT_NO',selectRecord.get('LOT_NO'));
                    
                    selectPrintInfo.set('PACK_QTY',selectRecord.get('PACK_QTY'));
                    
                    selectPrintInfo.set('PROG_WORK_CODE',selectRecord.get('PROG_WORK_CODE'));
                    
                    printInfoForm.setValue('PRINT_Q',selectRecord.get('PRINT_Q'));
                    
                    
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                }
            }
        }),

        columns: [
            { dataIndex: 'COMP_CODE'               ,width:100,hidden:true},
            { dataIndex: 'DIV_CODE'                ,width:100,hidden:true},
            { dataIndex: 'WORK_SHOP_CODE'          ,width:120},
            { dataIndex: 'WKORD_NUM'               ,width:120},
            { dataIndex: 'ITEM_CODE'               ,width:100},
            { dataIndex: 'ITEM_NAME'               ,width:180},
            { dataIndex: 'SPEC'                    ,width:240},
            { dataIndex: 'PRODT_WKORD_DATE'        ,width:100},
            { dataIndex: 'LOT_NO'                  ,width:100},
            { dataIndex: 'WKORD_Q'                 ,width:100},
            { dataIndex: 'PRINT_YN'                ,width:80,align:'center'}
        
        
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
            
            }
        }
    });   
    
    
    
	var printInfoForm = Unilite.createSearchForm('printInfoForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel:'<t:message code="system.label.base.division" default="사업장"/>',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            name:'DIV_CODE',
            allowBlank:false,
            value: UserInfo.divCode,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    var sm = referenceInfoGrid.getSelectionModel();
                    var selRecords = referenceInfoGrid.getSelectionModel().getSelection();
                    sm.deselect(selRecords);
                    
//                    printInfoGrid.reset();
//                    printInfoStore.clearData();
//					printInfoGrid.createRow({COMP_CODE: UserInfo.compCode, DIV_CODE: newValue});
					
                    var selectedRecord = printInfoGrid.getSelectedRecord();
                    if(!Ext.isEmpty(selectedRecord)){
						selectedRecord.set('COMP_CODE'    , UserInfo.compCode);
						selectedRecord.set('DIV_CODE'     , newValue);
						selectedRecord.set('WKORD_NUM'    , '');
						selectedRecord.set('ITEM_CODE'    , '');
						selectedRecord.set('ITEM_NAME'    , '');
						selectedRecord.set('SPEC'         , '');
						selectedRecord.set('STOCK_UNIT'         , '');
						selectedRecord.set('LOT_NO'       , '');
						selectedRecord.set('PACK_QTY'          , '');
						
						selectedRecord.set('PROG_WORK_CODE'          , '');
                    }
					printInfoForm.setValue('PRINT_Q','');
					
					
					
		            referenceInfoForm.clearForm();
		            referenceInfoGrid.reset();
		            referenceInfoStore.clearData();
		            
					referenceInfoForm.setValue('PRODT_WKORD_DATE_FR',UniDate.get('startOfMonth'));
					referenceInfoForm.setValue('PRODT_WKORD_DATE_TO',UniDate.get('today'));
                }
            }
        },/*{
            title:'출력정보',
            xtype: 'fieldset',
//            margine: '5 5 10 5',
            padding: '10 10 10 10',
            layout: {type : 'uniTable', columns : 4,
                tableAttrs: { width: '100%'}
            },
            items: [*/
    	{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 3
//            tableAttrs: { width: '100%'}
            },
            items: [{
            	xtype:'component'
            	
            },{
            	xtype:'component'
            	
            },{
                fieldLabel:'발행매수',
//                labelWidth:380,
                xtype:'uniNumberfield',
                name:'PRINT_Q',
                
                allowBlank:false
            },
            	printInfoGrid
            ,{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 1},
                tdAttrs: {align : 'right'},
                items: [{
                    xtype:'button',
                    text:'바코드출력',
                    width:200,
                    height:75,
                    margin:'0 0 5 0',
                    id : 'barcodeTest1',
                    handler:function(){
                        if(!printInfoForm.getInvalidMessage()) return;   //필수체크
                        
                        var inValidRecs = printInfoStore.getInvalidRecords();
                        
                        
                        
                        var paramMaster= printInfoForm.getValues(); 
                        
                        if(inValidRecs.length != 0) {
                            printInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                            
                            return;
                        }
                    
                        var selectRecord = printInfoGrid.getSelectedRecord(); 
                    
                        
						var param = {
                      	
	                        "PRINT_Q": printInfoForm.getValue('PRINT_Q'),
	                        
	                        "DIV_CODE": selectRecord.get('DIV_CODE'),
	                        "WKORD_NUM": selectRecord.get('WKORD_NUM'),
	                        
	                        "ITEM_CODE": selectRecord.get('ITEM_CODE'),
	                        "ITEM_NAME": selectRecord.get('ITEM_NAME'),
	                        "SPEC": selectRecord.get('SPEC'),
	                        
	                        "STOCK_UNIT": selectRecord.get('STOCK_UNIT'),
	                        "LOT_NO": selectRecord.get('LOT_NO'),
	                        
	                        "PACK_QTY": selectRecord.get('PACK_QTY'),
	                        
	                        "PROG_WORK_CODE": selectRecord.get('PROG_WORK_CODE')
	                            
		                };
		                
						param["USER_LANG"] = UserInfo.userLang;
						param["PGM_ID"]= PGM_ID;
						param["MAIN_CODE"] = 'P010';//생산용 공통 코드
						
						var win = null;
						win = Ext.create('widget.ClipReport', {
							url: CPATH+'/z_kd/s_pmp120clrkrv_kd.do',
							prgID: 's_pmp120rkrv_kd',
							extParam: param
						});
			//			win.center();	팝업에서 호출시 위치 못찾는현상 때문에 제거
						win.show();
						
                    }
                }]
            }]
        }]
    });
   
    var referenceInfoForm = Unilite.createSearchForm('referenceInfoForm',{
        region: 'north',
        title:'참조정보',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 3,
                tableAttrs: { width: '100%'}
            },
//            height:50,
            items: [{
                fieldLabel:'작업장',
                xtype: 'uniCombobox',
                comboType: 'WU',
                name:'WORK_SHOP_CODE',
                allowBlank:false
            },
            Unilite.popup('DIV_PUMOK',{
                fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
                validateBlank:false,
                valueFieldName:'ITEM_CODE',
                textFieldName:'ITEM_NAME', 
//                allowBlank:false,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': printInfoForm.getValue('DIV_CODE')});
                    }
                }
            }),{
                fieldLabel: '생산일자', 
                xtype: 'uniDateRangefield', 
                startFieldName: 'PRODT_WKORD_DATE_FR',
                endFieldName:'PRODT_WKORD_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 315
            }]
        }]
    });
    Unilite.Main( {
    	borderItems:[{
            region: 'center',
            layout:'border',
            border: false,
            id:'pageAll',
            items: [
            	printInfoForm,referenceInfoForm, referenceInfoGrid
          	]
        }],
		id  : 's_pmp120rkrv_kdApp',
		fnInitBinding: function(){
            UniAppManager.app.onResetButtonDown();
		},
		
        onQueryButtonDown: function() {
//            if(!printInfoForm.getInvalidMessage()) return;   //필수체크
            
            if(Ext.isEmpty(printInfoForm.getValue('DIV_CODE'))){
                Unilite.messageBox('사업장은 필수입력 항목입니다.');
                return;
            }
            if(!referenceInfoForm.getInvalidMessage()) return;   //필수체크
            referenceInfoStore.loadStoreRecords();
        },
		onResetButtonDown: function() {
            printInfoForm.clearForm();
			printInfoGrid.reset();
			printInfoStore.clearData();
			
            referenceInfoForm.clearForm();
            referenceInfoGrid.reset();
            referenceInfoStore.clearData();
//			detailStore.loadStoreRecords();
			UniAppManager.app.fnInitInputFields();
		},
		fnInitInputFields: function(){
			UniAppManager.setToolbarButtons(['save','newData','print'], false);
            UniAppManager.setToolbarButtons(['reset'], true);

			printInfoForm.setValue('DIV_CODE',UserInfo.divCode);
			
			referenceInfoForm.setValue('PRODT_WKORD_DATE_FR',UniDate.get('startOfMonth'));
			referenceInfoForm.setValue('PRODT_WKORD_DATE_TO',UniDate.get('today'));
			printInfoGrid.createRow({COMP_CODE: UserInfo.compCode, DIV_CODE: UserInfo.divCode});
		}
		
		
	});
	
	
	Unilite.createValidator('validator01', {
		store: printInfoStore,
		grid: printInfoGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PACK_QTY":
					var referSelectR = referenceInfoGrid.getSelectedRecord();
					if(!Ext.isEmpty(referSelectR)){
						printInfoForm.setValue('PRINT_Q',Math.ceil(referSelectR.get('WKORD_Q') / newValue));  
					}
				
				break;
				
				
			}
			return rv;
		}
	});
};

</script>
