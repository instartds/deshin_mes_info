<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr813rkrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="bpr813rkrv"  />          <!-- 사업장 -->

	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >


function appMain() {
	
   /* var statusStore = Unilite.createStore('statusComboStore', {
        fields: ['text', 'value'],
        data :  [
            {'text':'미완료'  , 'value':'N'},
            {'text':'등록중'  , 'value':'I'},
            {'text':'완료'   , 'value':'Y'}
        ]
    });*/

	Unilite.defineModel('printInfoModel', {
        fields: [
            {name: 'COMP_CODE'        ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'      ,type: 'string'},
            {name: 'DIV_CODE'         ,text: '<t:message code="system.label.base.division" default="사업장"/>'       ,type: 'string'},
            
            {name: 'ITEM_CODE'        ,text: '품번'        ,type: 'string',allowBlank:false},
            {name: 'ITEM_NAME'        ,text: '<t:message code="system.label.base.itemname2" default="품명"/>'        ,type: 'string',allowBlank:false},
            {name: 'SPEC'             ,text: '<t:message code="system.label.base.spec" default="규격"/>'        ,type: 'string',allowBlank:false},
            {name: 'LOT_NO'           ,text: 'LOT NO'     ,type: 'string',maxLength: 6,allowBlank:false},
            {name: 'SERIAL_NO'        ,text: '시리얼 FROM'  ,type: 'string',allowBlank:false}
            
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
    
	 var printInfoGrid = Unilite.createGrid('printInfoGrid', {
        layout: 'fit',
        region: 'center',
        width:750,
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
                            
                            grdRecord.set('LOT_NO',UniDate.getDbDateStr(UniDate.get('today')).substring(2,8));
                            
                           
                            
                        },
                        onClear:function(type) {
                            var grdRecord = printInfoGrid.uniOpt.currentRecord;
                            grdRecord.set('ITEM_CODE','');
                            grdRecord.set('ITEM_NAME','');
                            grdRecord.set('SPEC','');
                            grdRecord.set('LOT_NO','');
                          
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
                        },
                        onClear:function(type) {
                            var grdRecord = printInfoGrid.uniOpt.currentRecord;
                            grdRecord.set('ITEM_CODE','');
                            grdRecord.set('ITEM_NAME','');
                            grdRecord.set('SPEC','');
                            grdRecord.set('LOT_NO','');
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
            { dataIndex: 'SPEC'          ,width:150   },
            { dataIndex: 'LOT_NO'        ,width:120   },
            { dataIndex: 'SERIAL_NO'     ,flex:1 }
        
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
            	
                
                if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE'])){
                    return false;
                }
            }
        }
    });
    
	var printInfoForm = Unilite.createSearchForm('printInfoForm',{
        region: 'center',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 3, 
            	tableAttrs: { width: '100%'}
            },
            items: [{
	            fieldLabel:'<t:message code="system.label.base.division" default="사업장"/>',
	            xtype: 'uniCombobox',
	            comboType: 'BOR120',
	            name:'DIV_CODE',
	            allowBlank:false,
	            value: UserInfo.divCode,
		        listeners: {
		            change: function(field, newValue, oldValue, eOpts) {
		                
						printInfoForm.setValue('CNT','');
//		                printInfoGrid.reset();
//		                printInfoStore.clearData();
		                var selectedRecord = printInfoGrid.getSelectedRecord();
		                
		                if(!Ext.isEmpty(selectedRecord)){
							selectedRecord.set('COMP_CODE'    , UserInfo.compCode);
							selectedRecord.set('DIV_CODE'     , newValue);
							selectedRecord.set('ITEM_CODE'    , '');
							selectedRecord.set('ITEM_NAME'    , '');
							selectedRecord.set('SPEC'         , '');
							selectedRecord.set('LOT_NO'       , '');
	                    
		                
		                
							if(Ext.getCmp('rePrint').getValue().RE_PRINT == '1'){
								selectedRecord.set('SERIAL_NO'    , '');
							}else{
								var param ={
				                    "S_COMP_CODE": UserInfo.compCode,
				                    "DIV_CODE": newValue
					            }
					            bpr813rkrvService.checkSerialNo(param, function(provider, response)  {
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
	        },{
                fieldLabel:'발행매수',
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
                    	
                        printInfoForm.setValue('DIV_CODE',UserInfo.divCode);
						printInfoForm.setValue('CNT','');
		                var selectedRecord = printInfoGrid.getSelectedRecord();
		                
		                if(!Ext.isEmpty(selectedRecord)){
							selectedRecord.set('COMP_CODE'    , UserInfo.compCode);
							selectedRecord.set('DIV_CODE'     , UserInfo.divCode);
							selectedRecord.set('ITEM_CODE'    , '');
							selectedRecord.set('ITEM_NAME'    , '');
							selectedRecord.set('SPEC'         , '');
							selectedRecord.set('LOT_NO'       , '');
                    	
	                        if(newValue.RE_PRINT == '1'){
								selectedRecord.set('SERIAL_NO'    , '');
	                        	
//		                        printInfoGrid.reset();
//		                        printInfoStore.clearData();
//		                        printInfoGrid.createRow({COMP_CODE: UserInfo.compCode, DIV_CODE:UserInfo.divCode});
	                        }else{
	                        	
								var param ={
				                    "S_COMP_CODE": UserInfo.compCode,
				                    "DIV_CODE": UserInfo.divCode
					            }
					            bpr813rkrvService.checkSerialNo(param, function(provider, response)  {
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
                    
                        
                        if(Ext.getCmp('rePrint').getValue().RE_PRINT == '1'){
                        	if(Ext.isEmpty(selectRecord.get('SERIAL_NO'))){
                        		Unilite.messageBox('재발행일시 시리얼FROM 값을 지정해 주셔야 합니다.\n시리얼FROM 값의 범위는 00001 ~ 99999 입니다.');
                        		
                        		return;
                        	}
                        }
                        
                        
                      var param = {
                            "CNT": printInfoForm.getValue('CNT'),
                            "RE_PRINT": Ext.getCmp('rePrint').getValue().RE_PRINT,
                            
                            "S_COMP_CODE": selectRecord.get('COMP_CODE'),
                            "DIV_CODE": selectRecord.get('DIV_CODE'),
                            
                            "ITEM_CODE": selectRecord.get('ITEM_CODE'),
                            "ITEM_NAME": selectRecord.get('ITEM_NAME'),
                            "SPEC": selectRecord.get('SPEC'),
                            "LOT_NO": selectRecord.get('LOT_NO'),
                            "SERIAL_NO": selectRecord.get('SERIAL_NO'),
                            
                            
                            "SYSDATE": UniDate.getDbDateStr(UniDate.get('today'))
	                };
	                bpr813rkrvService.printAllLogic(param, function(provider, response)  {
	                    if(!Ext.isEmpty(provider)){
	                        if(provider=='Y'){
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
			                    "DIV_CODE": selectRecord.get('DIV_CODE')
				            }
				            bpr813rkrvService.checkSerialNo(param, function(provider, response)  {
				                if(!Ext.isEmpty(provider)){
									selectRecord.set('SERIAL_NO'    , provider.SERIAL_NO+1);
				                }else{
									selectRecord.set('SERIAL_NO'    , '1');
				                }
				            });
				            
	                     }
	                });
                        
                    }
                }]
            }]
        }]
    });
   
    Unilite.Main( {
    	borderItems:[{
            region: 'center',
            layout:'border',
            border: false,
            id:'pageAll',
            items: [printInfoForm
            ]
        }],
		id  : 'bpr813rkrvApp',
		fnInitBinding: function(){
            UniAppManager.app.onResetButtonDown();
		},
		
		onResetButtonDown: function() {
            printInfoForm.clearForm();
			printInfoGrid.reset();
			printInfoStore.clearData();
			
			UniAppManager.app.fnInitInputFields();
		},
		fnInitInputFields: function(){
			UniAppManager.setToolbarButtons(['save','newData','print','query'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
			printInfoForm.setValue('DIV_CODE',UserInfo.divCode);
            printInfoForm.setValue('RE_PRINT','2');
			
            
            var param ={
                "S_COMP_CODE": UserInfo.compCode,
                "DIV_CODE": UserInfo.divCode
            }
            bpr813rkrvService.checkSerialNo(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    
					printInfoGrid.createRow({COMP_CODE: UserInfo.compCode,DIV_CODE:UserInfo.divCode, SERIAL_NO: provider.SERIAL_NO+1});
                }else{
                    
					printInfoGrid.createRow({COMP_CODE: UserInfo.compCode,DIV_CODE:UserInfo.divCode, SERIAL_NO: '1'});
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
				break;
			}
			return rv;
		}
	}); // validator
};

</script>
