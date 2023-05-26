<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr810rkrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="bpr810rkrv"  />          <!-- 사업장 -->

    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >


function appMain() {
/*	
    var statusStore = Unilite.createStore('statusComboStore', {  
        fields: ['text', 'value'],
        data :  [
            {'text':'미완료'  , 'value':'N'},
            {'text':'등록중'  , 'value':'I'},
            {'text':'완료'   , 'value':'Y'}
        ]
    });*/

	Unilite.defineModel('printInfoModel', {
        fields: [
            {name: 'COMP_CODE'        ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'      ,type: 'string'},//allowBlank:false},
            {name: 'DIV_CODE'         ,text: '<t:message code="system.label.base.division" default="사업장"/>'       ,type: 'string'},//allowBlank:false},
            {name: 'PRODT_NUM'        ,text: '생산실적번호'   ,type: 'string'},//allowBlank:false},
            
            {name: 'ITEM_CODE'        ,text: '품번'        ,type: 'string',allowBlank:false},
            {name: 'ITEM_NAME'        ,text: '<t:message code="system.label.base.itemname2" default="품명"/>'        ,type: 'string',allowBlank:false},
            {name: 'SPEC'             ,text: '<t:message code="system.label.base.spec" default="규격"/>'        ,type: 'string',allowBlank:false},
            {name: 'TYPE'             ,text: 'TYPE'       ,type: 'string',allowBlank:true},
            {name: 'LOT_NO'           ,text: 'LOT NO'     ,type: 'string',maxLength: 6,allowBlank:false},
            {name: 'SERIAL_NO'        ,text: '시리얼 FROM'  ,type: 'string',allowBlank:false},
            {name: 'CNT'        	  ,text: '수량'        ,type: 'int'},
            {name: 'KS_MARK_GUBUN'    ,text: 'KS구분'      ,type: 'string'},
            {name: 'KS_MARK_NAME'     ,text: 'KS이름'      ,type: 'string'}
            
        ]
    });
    
    Unilite.defineModel('referenceInfoModel', {
        fields: [
            {name: 'COMP_CODE'        ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'              ,type: 'string',allowBlank:false},
            {name: 'DIV_CODE'         ,text: '<t:message code="system.label.base.division" default="사업장"/>'               ,type: 'string',allowBlank:false},
            {name: 'PRODT_NUM'        ,text: '생산실적번호'           ,type: 'string',allowBlank:false},
            {name: 'ITEM_CODE'        ,text: '품번'                ,type: 'string'},
            {name: 'ITEM_NAME'        ,text: '<t:message code="system.label.base.itemname2" default="품명"/>'                ,type: 'string'},
            {name: 'SPEC'             ,text: '<t:message code="system.label.base.spec" default="규격"/>'                ,type: 'string'},
            {name: 'WKORD_NUM'        ,text: '작업지시번호'           ,type: 'string'},
            {name: 'PRODT_DATE'       ,text: '생산일자'              ,type: 'uniDate'},
            {name: 'PRODT_Q'          ,text: '생산수량'              ,type: 'int'},
            {name: 'LOT_NO'           ,text: 'LOT NO'              ,type: 'string'},
            {name: 'TEMPC_01'         ,text: '출력여부'             ,type: 'string'},
            {name: 'FR_SERIAL_NO'     ,text: '시리얼(FR)'          ,type: 'string'},
            {name: 'TO_SERIAL_NO'     ,text: '시리얼(TO)'          ,type: 'string'},
            {name: 'REMARK'           ,text: '<t:message code="system.label.base.remarks" default="비고"/>'               ,type: 'string'}
            
            
            
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
                read: 'bpr810rkrvService.barCodeDataSelect'                   
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
                read: 'bpr810rkrvService.referenceInfo'                   
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
        colspan:4,
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
            { dataIndex: 'PRODT_NUM'         ,width:100, hidden:true  },
            
            { dataIndex: 'ITEM_CODE'       ,width:100,
                editor: Unilite.popup('DIV_PUMOK_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = printInfoGrid.uniOpt.currentRecord;
                            grdRecord.set('ITEM_CODE',records[0]['ITEM_CODE']);
                            grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
                            grdRecord.set('SPEC',records[0]['SPEC']);
                            
//                            grdRecord.set('LOT_NO',UniDate.getDbDateStr(UniDate.get('today')).substring(2,8));
                            
                            
                           var param ={
		                        "ITEM_CODE": records[0]['ITEM_CODE']
		                    }
		                    bpr810rkrvService.checkMarkGubun(param, function(provider, response)  {
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
                            
//                            grdRecord.set('LOT_NO',UniDate.getDbDateStr(UniDate.get('today')).substring(2,8));
                            var param ={
		                        "ITEM_CODE": records[0]['ITEM_CODE']
		                    }
		                    bpr810rkrvService.checkMarkGubun(param, function(provider, response)  {
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
            { dataIndex: 'SPEC'            ,width:150   },
            { dataIndex: 'TYPE'          ,width:150   },
            { dataIndex: 'LOT_NO'        ,width:120 },
            { dataIndex: 'SERIAL_NO'        ,width:100   },
            { dataIndex: 'CNT'        ,width:75   },
            { dataIndex: 'KS_MARK_NAME'      ,width:75,hidden:true  },
            
            { dataIndex: 'KS_MARK_GUBUN'      ,flex:1   }
        
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
            	
                if(UniUtils.indexOf(e.field, ['SERIAL_NO'])){
                	if(Ext.getCmp('rePrint').getValue().RE_PRINT == '1'){
                	    return true;
                	}else{
                		return false;
                	}
                }
            	
                
                if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','PRODT_NUM','KS_MARK_NAME','CNT'])){
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
                	
                	
                    if(Ext.getCmp('rePrint').getValue().RE_PRINT == '2'){
                	   if(selectRecord.get('TEMPC_01') == 'Y'){
                            Unilite.messageBox( "출력여부를 확인해 주십시오.");
                            
                            var sm = referenceInfoGrid.getSelectionModel();
                            var selRecords = referenceInfoGrid.getSelectionModel().getSelection();
                            sm.deselect(selRecords);
                            
                            return false;
                	   }
                       
                    }
                       
                    var selectPrintInfo = printInfoGrid.getSelectedRecord();
                    
                    
                    
                    selectPrintInfo.set('COMP_CODE',selectRecord.get('COMP_CODE'));
                    selectPrintInfo.set('DIV_CODE',selectRecord.get('DIV_CODE'));
                    selectPrintInfo.set('PRODT_NUM',selectRecord.get('PRODT_NUM'));
                    
                    selectPrintInfo.set('ITEM_CODE',selectRecord.get('ITEM_CODE'));
                    selectPrintInfo.set('ITEM_NAME',selectRecord.get('ITEM_NAME'));
                    selectPrintInfo.set('SPEC',selectRecord.get('SPEC'));
                    selectPrintInfo.set('CNT',selectRecord.get('PRODT_Q'));
                    
                    selectPrintInfo.set('LOT_NO',Ext.isEmpty(selectRecord.get('LOT_NO')) ? UniDate.getDbDateStr(UniDate.get('today')).substring(2, 8):selectRecord.get('LOT_NO'));
                    
                    printInfoForm.setValue('CNT',selectRecord.get('PRODT_Q'));
                    
                   var param ={
                            "S_COMP_CODE": selectRecord.get('COMP_CODE'),
                            "DIV_CODE": selectRecord.get('DIV_CODE'),
                            "LOT_NO" : Ext.isEmpty(selectRecord.get('LOT_NO')) ? UniDate.getDbDateStr(UniDate.get('today')).substring(2, 8):selectRecord.get('LOT_NO')
                    }
                    bpr810rkrvService.checkSerialNo(param, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){
                            
                            selectPrintInfo.set('SERIAL_NO',provider.SERIAL_NO+1);
                        }else{
                            
                            selectPrintInfo.set('SERIAL_NO','1');
                        }
                    });
                    
                	var param2 ={
                        "ITEM_CODE": selectRecord.get('ITEM_CODE')
                    }
                    bpr810rkrvService.checkMarkGubun(param2, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){
                            printInfoForm.setValue('KS_GUBUN','2');
                            selectPrintInfo.set('KS_MARK_GUBUN',provider.KS_MARK_GUBUN);
                            selectPrintInfo.set('KS_MARK_NAME',provider.KS_MARK_NAME);
                        }else{
                            printInfoForm.setValue('KS_GUBUN','1');
                            selectPrintInfo.set('KS_MARK_GUBUN','');
                            selectPrintInfo.set('KS_MARK_NAME','');
                        }
                    });
                    
                       
                       /*else{
                	
                        	var selectPrintInfo = printInfoGrid.getSelectedRecord();
                        	
                        	
                        	
                            selectPrintInfo.set('COMP_CODE',selectRecord.get('COMP_CODE'));
                            selectPrintInfo.set('DIV_CODE',selectRecord.get('DIV_CODE'));
                            selectPrintInfo.set('PRODT_NUM',selectRecord.get('PRODT_NUM'));
                        	
                        	selectPrintInfo.set('ITEM_CODE',selectRecord.get('ITEM_CODE'));
                        	selectPrintInfo.set('ITEM_NAME',selectRecord.get('ITEM_NAME'));
                        	selectPrintInfo.set('SPEC',selectRecord.get('SPEC'));
                        	selectPrintInfo.set('PRODT_DATE',selectRecord.get('PRODT_DATE'));
                        	selectPrintInfo.set('CNT',selectRecord.get('PRODT_Q'));
                        	selectPrintInfo.set('KS_GUBUN',selectRecord.get('KS_GUBUN'));  //임시
                            selectPrintInfo.set('ITEM_GUBUN',selectRecord.get('ITEM_GUBUN'));
                        	
                            printInfoForm.setValue('CNT',selectRecord.get('PRODT_Q'));
                            
                            
                            param ={
                                    "COMP_CODE": selectRecord.get('COMP_CODE'),
                                    "DIV_CODE": selectRecord.get('DIV_CODE')
                            }
                            bpr810rkrvService.checkSerialNo(param, function(provider, response)  {
                                if(!Ext.isEmpty(provider)){
                                	
                                    selectPrintInfo.set('SERIAL_NO',provider.SERIAL_NO+1);
                                }else{
                                	
                                    selectPrintInfo.set('SERIAL_NO','1');
                                }
                            });
                        
                        
                        }
                    }else{
                        
                    
                            var selectPrintInfo = printInfoGrid.getSelectedRecord();
                            
                            
                            
                            selectPrintInfo.set('COMP_CODE',selectRecord.get('COMP_CODE'));
                            selectPrintInfo.set('DIV_CODE',selectRecord.get('DIV_CODE'));
                            selectPrintInfo.set('PRODT_NUM',selectRecord.get('PRODT_NUM'));
                            
                            selectPrintInfo.set('ITEM_CODE',selectRecord.get('ITEM_CODE'));
                            selectPrintInfo.set('ITEM_NAME',selectRecord.get('ITEM_NAME'));
                            selectPrintInfo.set('SPEC',selectRecord.get('SPEC'));
                            selectPrintInfo.set('PRODT_DATE',selectRecord.get('PRODT_DATE'));
                            selectPrintInfo.set('CNT',selectRecord.get('PRODT_Q'));
                            selectPrintInfo.set('KS_GUBUN',selectRecord.get('KS_GUBUN'));  //임시
                            selectPrintInfo.set('ITEM_GUBUN',selectRecord.get('ITEM_GUBUN'));
                            
                            printInfoForm.setValue('CNT',selectRecord.get('PRODT_Q'));
                            
                            param ={
                                    "COMP_CODE": selectRecord.get('COMP_CODE'),
                                    "DIV_CODE": selectRecord.get('DIV_CODE')
                            }
                            bpr810rkrvService.checkSerialNo(param, function(provider, response)  {
                                if(!Ext.isEmpty(provider)){
                                    
                                    selectPrintInfo.set('SERIAL_NO',provider.SERIAL_NO+1);
                                }else{
                                    
                                    selectPrintInfo.set('SERIAL_NO','1');
                                }
                            });
                        
                        
                        	
                    	
                    }*/
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                }
            }
        }),

        columns: [
            { dataIndex: 'COMP_CODE'               ,width:100,hidden:true},
            { dataIndex: 'DIV_CODE'                ,width:100,hidden:true},
            { dataIndex: 'PRODT_NUM'               ,width:120},
            { dataIndex: 'ITEM_CODE'               ,width:100},
            { dataIndex: 'ITEM_NAME'               ,width:180},
            { dataIndex: 'SPEC'                    ,width:240},
            { dataIndex: 'WKORD_NUM'               ,width:120},
            { dataIndex: 'PRODT_DATE'              ,width:100},
            { dataIndex: 'PRODT_Q'                 ,width:100},
            { dataIndex: 'LOT_NO'                  ,width:100},
            { dataIndex: 'TEMPC_01'                ,width:100},
            { dataIndex: 'FR_SERIAL_NO'            ,width:100},
            { dataIndex: 'TO_SERIAL_NO'            ,width:100},
            { dataIndex: 'REMARK'                  ,width:200}
        
        
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
						selectedRecord.set('PRODT_NUM'    , '');
						selectedRecord.set('ITEM_CODE'    , '');
						selectedRecord.set('ITEM_NAME'    , '');
						selectedRecord.set('SPEC'         , '');
						selectedRecord.set('TYPE'         , '');
						selectedRecord.set('LOT_NO'       , UniDate.getDbDateStr(UniDate.get('today')).substring(2, 8));
//						selectedRecord.set('SERIAL_NO'    , '');
						selectedRecord.set('CNT'          , '');
						selectedRecord.set('KS_MARK_GUBUN', '');
						selectedRecord.set('KS_MARK_NAME' , '');
						
						if(Ext.getCmp('rePrint').getValue().RE_PRINT == '1'){
							selectedRecord.set('SERIAL_NO'    , '');
						}else{
							var param ={
			                    "S_COMP_CODE": UserInfo.compCode,
			                    "DIV_CODE": newValue,
			                    "LOT_NO" : UniDate.getDbDateStr(UniDate.get('today')).substring(2, 8)
				            }
				            bpr810rkrvService.checkSerialNo(param, function(provider, response)  {
				                if(!Ext.isEmpty(provider)){
									selectedRecord.set('SERIAL_NO'    , provider.SERIAL_NO+1);
				                }else{
									selectedRecord.set('SERIAL_NO'    , '1');
				                }
				            });
						}
                    }
					printInfoForm.setValue('CNT','');
					
					
					
		            referenceInfoForm.clearForm();
		            referenceInfoGrid.reset();
		            referenceInfoStore.clearData();
		            
					referenceInfoForm.setValue('PRODT_DATE_FR',UniDate.get('startOfMonth'));
					referenceInfoForm.setValue('PRODT_DATE_TO',UniDate.get('today'));
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
                layout: {type: 'uniTable', columns: 5,
                tableAttrs: { width: '100%'}
                },
                items: [{
            
                xtype: 'radiogroup',                            
                fieldLabel: '<t:message code="system.label.base.size" default="사이즈"/>',
                allowBlank:false,
                id:'size',
                items:[{
                    boxLabel: '대', 
                    width: 50, 
                    name: 'SIZE',
                    inputValue: '1',
                    checked: true
                },{
                    boxLabel : '소', 
                    width: 50,
                    name: 'SIZE',
                    inputValue: '2'
                },{
                    boxLabel : 'TR', 
                    width: 50,
                    name: 'SIZE',
                    inputValue: '3'
                }]
            
            },{
            
                xtype: 'radiogroup',                            
                fieldLabel: 'KS출력',
//                allowBlank:false,
                id:'ksGubun',
                items:[{
                    boxLabel: '없음', 
                    width: 50, 
                    name: 'KS_GUBUN',
                    inputValue: '1',
//                    readOnly:true,
                    checked: true
                },{
                    boxLabel : 'KS', 
                    width: 50,
                    name: 'KS_GUBUN',
//                    readOnly:true,
                    inputValue: '2'
                }]
            
            },{
                fieldLabel: 'ETL' ,
                name: 'ETL' ,
                xtype: 'checkboxfield'                  
            },{
                fieldLabel:'발행매수',
                labelWidth:280,
                xtype:'uniNumberfield',
                name:'CNT',
                
                allowBlank:false
            },{
            
                xtype: 'radiogroup',                            
                fieldLabel: '재발행',
                allowBlank:false,
                id:'rePrint',
                items:[{
                    boxLabel: '예', 
                    width: 50, 
                    name: 'RE_PRINT',
                    inputValue: '1'
                },{
                    boxLabel : '아니오', 
                    width: 60,
                    name: 'RE_PRINT',
                    inputValue: '2',
                    checked: true
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        var sm = referenceInfoGrid.getSelectionModel();
                        var selRecords = referenceInfoGrid.getSelectionModel().getSelection();
                        sm.deselect(selRecords);
                        
//                        printInfoForm.setValue('DIV_CODE',UserInfo.divCode);
                        printInfoForm.setValue('SIZE','1');
                        printInfoForm.setValue('KS_GUBUN','1');
                        printInfoForm.setValue('ETL',false);
						printInfoForm.setValue('CNT','');
//                        printInfoGrid.reset();
//                        printInfoStore.clearData();
//						printInfoGrid.createRow({COMP_CODE: UserInfo.compCode, DIV_CODE: UserInfo.divCode});
						
						var selectedRecord = printInfoGrid.getSelectedRecord();
	                    if(!Ext.isEmpty(selectedRecord)){
							selectedRecord.set('COMP_CODE'    , UserInfo.compCode);
							selectedRecord.set('DIV_CODE'     , printInfoForm.getValue('DIV_CODE'));
							selectedRecord.set('PRODT_NUM'    , '');
							selectedRecord.set('ITEM_CODE'    , '');
							selectedRecord.set('ITEM_NAME'    , '');
							selectedRecord.set('SPEC'         , '');
							selectedRecord.set('TYPE'         , '');
							selectedRecord.set('LOT_NO'       , UniDate.getDbDateStr(UniDate.get('today')).substring(2, 8));
//							selectedRecord.set('SERIAL_NO'    , '');
							selectedRecord.set('CNT'          , '');
							selectedRecord.set('KS_MARK_GUBUN', '');
							selectedRecord.set('KS_MARK_NAME' , '');
							
							if(Ext.getCmp('rePrint').getValue().RE_PRINT == '1'){
								selectedRecord.set('SERIAL_NO'    , '');
							}else{
								var param ={
				                    "S_COMP_CODE": UserInfo.compCode,
				                    "DIV_CODE": printInfoForm.getValue('DIV_CODE'),
				                    "LOT_NO": UniDate.getDbDateStr(UniDate.get('today')).substring(2, 8)
					            }
					            bpr810rkrvService.checkSerialNo(param, function(provider, response)  {
					                if(!Ext.isEmpty(provider)){
										selectedRecord.set('SERIAL_NO'    , provider.SERIAL_NO+1);
					                }else{
										selectedRecord.set('SERIAL_NO'    , '1');
					                }
					            });
							}
							
							
	                    }
                    }
                }
                
            },printInfoGrid
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
                        
                   /*     if(Ext.getCmp('rePrint').getValue().RE_PRINT == '1'){
                        	if(Ext.isEmpty(selectRecord.get('SERIAL_NO'))){
                        		Unilite.messageBox('재발행일시 시리얼FROM 값을 지정해 주셔야 합니다.\n시리얼FROM 값의 범위는 00001 ~ 99999 입니다.');
                        		
                        		return;
                        	}
                        }*/
                        
                        
                      var param = {
                            "SIZE": Ext.getCmp('size').getValue().SIZE,
                            "KS_GUBUN": Ext.getCmp('ksGubun').getValue().KS_GUBUN,
                            "CNT": printInfoForm.getValue('CNT'),
                            "RE_PRINT": Ext.getCmp('rePrint').getValue().RE_PRINT,
                            
                            "ETL": printInfoForm.getValue('ETL'),
                            
                            
                            
                            "S_COMP_CODE": selectRecord.get('COMP_CODE'),
                            "DIV_CODE": selectRecord.get('DIV_CODE'),
                            "PRODT_NUM": selectRecord.get('PRODT_NUM'),
                            
                            "ITEM_CODE": selectRecord.get('ITEM_CODE'),
                            "ITEM_NAME": selectRecord.get('ITEM_NAME'),
                            "SPEC": selectRecord.get('SPEC'),
                            "TYPE": selectRecord.get('TYPE'),
                            "LOT_NO": selectRecord.get('LOT_NO'),
                            "SERIAL_NO": selectRecord.get('SERIAL_NO'),
                            "KS_MARK_GUBUN": selectRecord.get('KS_MARK_GUBUN'),
                            "KS_MARK_NAME": selectRecord.get('KS_MARK_NAME'),
                            
                            
                            "SYSDATE": UniDate.getDbDateStr(UniDate.get('today'))
	                };
	                bpr810rkrvService.printAllLogic(param, function(provider, response)  {
	                    if(!Ext.isEmpty(provider)){
	                        if(provider=='Y'){
	                        	
	                        	if(Ext.getCmp('rePrint').getValue().RE_PRINT == '2'){
			                    	printInfoGrid.reset();
			                        printInfoStore.clearData();
									printInfoGrid.createRow({COMP_CODE: UserInfo.compCode, DIV_CODE: UserInfo.divCode});
									
									referenceInfoStore.loadStoreRecords();
			                    }
	                        	
	                    	    Unilite.messageBox( "성공");
	    
	                    	}else{
	                    	    Unilite.messageBox( "실패");
	                    	}
	                    }else{
	                        Unilite.messageBox( "실패");	
	                    }
	                    
	                    
	                    if(Ext.getCmp('rePrint').getValue().RE_PRINT == '2'){
	                    // 마지막발행 시리얼 + 1 관련
							var param ={
			                    "S_COMP_CODE": selectRecord.get('COMP_CODE'),
			                    "DIV_CODE": selectRecord.get('DIV_CODE'),
			                    "LOT_NO": selectRecord.get('LOT_NO')
				            }
				            bpr810rkrvService.checkSerialNo(param, function(provider, response)  {
				                if(!Ext.isEmpty(provider)){
									selectRecord.set('SERIAL_NO'    , provider.SERIAL_NO+1);
				                }else{
									selectRecord.set('SERIAL_NO'    , '1');
				                }
				            });
				            
	                     }
	                    
	                });
                        
                        
                        
                        
             /*           
                        
                    Ext.Ajax.request({
                        url : CPATH+'/barcode/bpr810rkrvBarcodePrint.do',
                        params: {
                        	
//                        	SIZE: printInfoForm.getValue('SIZE'),
                        	SIZE: Ext.getCmp('size').getValue().SIZE,
                        	KS_GUBUN: Ext.getCmp('ksGubun').getValue().KS_GUBUN,
                            CNT: printInfoForm.getValue('CNT'),
                            RE_PRINT: Ext.getCmp('rePrint').getValue().RE_PRINT,
                            
                            
                            
                            COMP_CODE: selectRecord.get('COMP_CODE'),
                            DIV_CODE: selectRecord.get('DIV_CODE'),
                            PRODT_NUM: selectRecord.get('PRODT_NUM'),
                            
                            ITEM_CODE: selectRecord.get('ITEM_CODE'),
                            ITEM_NAME: selectRecord.get('ITEM_NAME'),
                            SPEC: selectRecord.get('SPEC'),
                            TYPE: selectRecord.get('TYPE'),
                            LOT_NO: selectRecord.get('LOT_NO'),
                            SERIAL_NO: selectRecord.get('SERIAL_NO'),
                            KS_GUBUN: selectRecord.get('KS_GUBUN')
                        },
                        method: 'post',
                        success: function(response){
                            if(response.responseText == 'Y'){
                                Unilite.messageBox( "성공");
                            }else{
                                Unilite.messageBox( "실패");
                            }
                        },
                        failure: function(response){
                            Unilite.messageBox( "실패");
                        }
                    });
                    */
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
                store: Ext.data.StoreManager.lookup('wsList'),
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
                startFieldName: 'PRODT_DATE_FR',
                endFieldName:'PRODT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                width: 315
            }
            
            
            ]
        }]
    });
    Unilite.Main( {
    	borderItems:[{
            region: 'center',
//            layout: {type: 'vbox', align: 'stretch'},
            layout:'border',
            border: false,
//            autoScroll: true,
            id:'pageAll',
            items: [printInfoForm,referenceInfoForm, referenceInfoGrid
       /*     
            {
                title:'테스트 필드셋2',
                xtype: 'fieldset',
                padding: '50 50 100 50',
                layout: { type:'vbox'},
//                layout: {type : 'uniTable', columns : 1,
//                    tableAttrs: { width: '100%'}
//                },
                items: [
                
                    panelResult, detailGrid
                ]
                
        },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 1},
//                tdAttrs: {align : 'right'},
                items: [
                
                    printInfo
                ]
                
        },{
            title:'테스트 필드셋',
            xtype: 'fieldset',
            padding: '5 5 10 5',
            layout: {type : 'uniTable', columns : 1,
                tableAttrs: { width: '100%'}
            },
            items: [
                printInfo
            ]
        }
            */
            
            ]
        }],
		id  : 'bpr810rkrvApp',
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
            printInfoForm.setValue('SIZE','1');
            printInfoForm.setValue('KS_GUBUN','1');
            printInfoForm.setValue('RE_PRINT','2');
			printInfoForm.setValue('DIV_CODE',UserInfo.divCode);
			
			referenceInfoForm.setValue('PRODT_DATE_FR',UniDate.get('startOfMonth'));
			referenceInfoForm.setValue('PRODT_DATE_TO',UniDate.get('today'));
			
			var lotNo = UniDate.getDbDateStr(UniDate.get('today')).substring(2, 8);
			
			
			var param ={
                    "S_COMP_CODE": UserInfo.compCode,
                    "DIV_CODE": UserInfo.divCode,
                    "LOT_NO" : lotNo
            }
            bpr810rkrvService.checkSerialNo(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    
                    printInfoGrid.createRow({COMP_CODE: UserInfo.compCode,DIV_CODE:UserInfo.divCode,LOT_NO: lotNo, SERIAL_NO: provider.SERIAL_NO+1});
                }else{
                    
                    printInfoGrid.createRow({COMP_CODE: UserInfo.compCode,DIV_CODE:UserInfo.divCode,LOT_NO: lotNo, SERIAL_NO: '1'});
                }
            });
		}
		
		
	});
	
	Unilite.createValidator('validator01', {
		store: printInfoStore,
		grid: printInfoGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "LOT_NO" :
					if(UniBase.fnDateCheckValidator(newValue) == false){
						rv='<t:message code = "유효한 날짜를 입력해주세요"/>';	
						break;
					}
					
					var param ={
                            "S_COMP_CODE": record.get('COMP_CODE'),
                            "DIV_CODE": record.get('DIV_CODE'),
                            "LOT_NO" : newValue
                    }
                    bpr810rkrvService.checkSerialNo(param, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){
                            
                            record.set('SERIAL_NO',provider.SERIAL_NO+1);
                        }else{
                            
                            record.set('SERIAL_NO','1');
                        }
                    });
					
					
					//시리얼 FORM 재조회 해서 가져와야함..
	/*    //유효성 체크
				    if (newValue.length == 6) {
				    	var todayYY = UniDate.getDbDateStr(UniDate.get('today')).substring(0, 2);
				        var y = todayYY + newValue.substring(0, 2) ;   // yyyy
				        var m = newValue.substring(2, 4);   // mm
				        var d = newValue.substring(4, 6);  // dd
				
				        if (m<1 || m>12){
							rv='<t:message code = "유효한 날짜를 입력해주세요"/>';	
							break;
				        }
				
				        if ( d<1 || d>31){
							rv='<t:message code = "유효한 날짜를 입력해주세요"/>';	
							break;
				        }
				        
				        if ( (m==4 || m==6 || m==9 || m==11) && d == 31 ) {
							rv='<t:message code = "유효한 날짜를 입력해주세요"/>';	
							break;
				        }
				
				        if (m==2){
				            var isleap = (y % 4 == 0 && (y % 100 != 0 || y % 400 == 0));
				            if (d>29 || (d==29 && !isleap)){
								rv='<t:message code = "유효한 날짜를 입력해주세요"/>';	
								break;
				            }
				        }
				    }else{
				    	
						rv='<t:message code = "유효한 날짜를 입력해주세요"/>';	
						break;	
				    }*/
				break;
			}
			return rv;
		}
	}); // validator
	
	
	
	
};

</script>
