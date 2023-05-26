<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ppl190skrv_kd">
    <t:ExtComboStore comboType="BOR120" pgmId="s_ppl190skrv_kd" /> <!-- 사업장 -->
    <t:ExtComboStore comboType="WU" />                  <!-- 작업장  -->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
    <t:ExtComboStore comboType="AU" comboCode="P001"  />
    <t:ExtComboStore comboType="AU" comboCode="P402"  />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_ppl190skrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',        text : '법인코드',      type : 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type : 'string', comboType : "BOR120"},
            {name : 'ORDER_TYPE',       text : '구분',        type : 'string'},
            {name : 'WK_PLAN_NUM',      text : '생산계획번호',   type : 'string'},
            {name : 'WORK_SHOP_CODE',   text : '작업장',       type : 'string' , comboType: 'WU'},
            {name : 'PRODT_PLAN_DATE',  text : '계획일',       type : 'uniDate'},
            
            {name : 'WK_PLAN_Q',        text : '생산계획량',      type: 'uniQty'},
            {name : 'WKORD_Q',          text : '작지량',      type: 'uniQty'},
            {name : 'NO_WKORD_Q',       text : '작지미발행량',      type: 'uniQty'},
            
            {name : 'ITEM_CODE',        text : '품목코드',      type : 'string'},
            {name : 'ITEM_NAME',        text : '품명',        type : 'string'},
            {name : 'SPEC',             text : '규격',        type : 'string'},
            {name : 'STOCK_UNIT',       text : '단위',        type : 'string'},
            {name : 'ORDER_NUM',        text : '수주번호',      type : 'string'}
        ]                         
    });     // End of Unilite.defineModel('s_ppl190skrv_kdModel', {
    
        Unilite.defineModel('s_ppl190skrv_kdModel2', {
        fields: [
//            {name : 'WORK_END_YN',          text : '상태',        type: 'string' , comboType:'AU', comboCode:'P001'},
            {name : 'WKORD_NUM',            text : '작업지시번호',   type: 'string'},
            {name : 'PRODT_WKORD_DATE',     text : '작업지시일',     type: 'uniDate'},
            {name : 'WORK_SHOP_CODE',       text : '작업장',       type : 'string' , comboType: 'WU'},
            {name : 'ITEM_CODE',            text : '품목코드',      type: 'string'},
            {name : 'ITEM_NAME',            text : '품명',        type: 'string'},
            {name : 'SPEC',                 text : '규격',        type: 'string'},
            {name : 'LOT_NO',               text : 'LOT NO',     type: 'string'},
            {name : 'PRODT_START_DATE',     text : '착수예정일',    type: 'uniDate'},
            {name : 'PRODT_END_DATE',       text : '완료예정일',    type: 'uniDate'},
            {name : 'WKORD_Q',              text : '작지수량',      type: 'uniQty'},
            {name : 'WORK_Q',              text : '생산실적량',     type: 'uniQty'},
//            {name : 'PRODT_Q',         text : '양품량',       type: 'uniQty'},
            {name : 'NO_WORK_Q',          text : '미실적량',      type: 'uniQty'}
        ]
    });     //End of Unilite.defineModel('s_ppl190skrv_kdModel2', {

    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore1 = Unilite.createStore('s_ppl190skrv_kdMasterStore1',{
            model: 's_ppl190skrv_kdModel',
            uniOpt: {
                isMaster: true,         // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable: false,           // 삭제 가능 여부 
                useNavi: false          // prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {          
                       read: 's_ppl190skrv_kdService.selectList'                    
                }
            },
            loadStoreRecords : function()   {
                var param = panelResult.getValues();            
                console.log( param );
                this.load({
                    params : param
                });
            }
    });
    
    var directMasterStore2 = Unilite.createStore('s_ppl190skrv_kdMasterStore2',{
            model: 's_ppl190skrv_kdModel2',
            uniOpt : {
                isMaster: true,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable: false,           // 삭제 가능 여부 
                useNavi: false          // prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {          
                       read: 's_ppl190skrv_kdService.selectDetailList'                  
                }
            },
            loadStoreRecords: function(param){   
                this.load({
                      params : param
                });         
            }
//          ,groupField: 'COMP_CODE'
    });     //End of var directMasterStore2 = Unilite.createStore('s_ppl190skrv_kdMasterStore2',{
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox', 
                comboType:'BOR120',
                allowBlank:false
            },{
                fieldLabel: '계획기간',
                xtype: 'uniDateRangefield',  
                startFieldName: 'PRODT_PLAN_DATE_FR',
                endFieldName:'PRODT_PLAN_DATE_TO',
                startDate: UniDate.get('mondayOfWeek'),
                endDate: UniDate.get('endOfWeek'),
                allowBlank:false,
                width: 315,
                textFieldWidth:170
            },{
                fieldLabel: '작업장',
                name: 'WORK_SHOP_CODE', 
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('wsList')
            },
                Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '품목코드',
                    validateBlank:false,
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    validateBlank: false,
    				autoPopup:true,
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE' : panelResult.getValue('DIV_CODE')});
                        }
                    }
            }),{
                fieldLabel: '생산계획번호',
                name: 'WK_PLAN_NUM', 
                xtype: 'uniTextfield'
            },{
                xtype:'container',
                defaultType:'uniTextfield',
                layout:{type:'hbox', align:'stretch'},
                items:[{
                    fieldLabel:'수주번호',
                    name : 'ORDER_NUM',
                    width:200
                }]
             },{
                fieldLabel: '참조유형',
                name:'PLAN_TYPE',
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'P402'
            }],
        setAllFieldsReadOnly: function(b) {
                var r= true
                if(b) {
                    var invalid = this.getForm().getFields().filterBy(function(field) {
                                                                        return !field.validate();
                                                                    });
                    if(invalid.length > 0) {
                        r=false;
                        var labelText = ''
        
                        if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                            var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                        } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                        }
    
                        alert(labelText+Msg.sMB083);
                        invalid.items[0].focus();
                    } else {
                    //  this.mask();            
                    }
                } else {
                    this.unmask();
                }
                return r;
            }
    }); 
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('s_ppl190skrv_kdGrid1', {
        layout : 'fit',
        region:'center',
        store : directMasterStore1, 
        uniOpt:{
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        selModel: 'rowmodel',       // 조회화면 selectionchange event 사용
        columns: [  
            {dataIndex : 'COMP_CODE',        width : 80, hidden:true},
            {dataIndex : 'DIV_CODE',         width : 120},
            {dataIndex : 'ORDER_TYPE',       width : 100},
            {dataIndex : 'WK_PLAN_NUM',      width : 130},
            {dataIndex : 'WORK_SHOP_CODE',   width : 150},
            {dataIndex : 'PRODT_PLAN_DATE',  width : 90, align:'center'},
            
            {dataIndex : 'WK_PLAN_Q',        width : 120},
            {dataIndex : 'WKORD_Q',       	 width : 120},
            {dataIndex : 'NO_WKORD_Q',       width : 120},
            
            {dataIndex : 'ITEM_CODE',        width : 110},
            {dataIndex : 'ITEM_NAME',        width : 160},
            {dataIndex : 'SPEC',             width : 140},
            {dataIndex : 'STOCK_UNIT',       width : 90},
            {dataIndex : 'ORDER_NUM',        width : 140}
        ],
        listeners: {
            selectionchange:function( model1, selected, eOpts ) {
            	if(selected.length > 0) {
//                var count = masterGrid1.getStore().getCount();
//                if(count > 0) {
                    var record = selected[0];
//                	var record = masterGrid1.getSelectedRecord();
//                    var param = Ext.getCmp('resultForm').getValues(); 
                    var param = {
                    	COMP_CODE      : UserInfo.compCode,
                        DIV_CODE       : record.get('DIV_CODE'),
                        WK_PLAN_NUM    : record.get('WK_PLAN_NUM')
                    }
                	
                    directMasterStore2.loadStoreRecords(param);
                } /*else {
                	masterGrid2.reset();
//                    UniAppManager.app.onResetButtonDown();                        
                }*/
            }
        }
    });     //End of  var masterGrid1 = Unilite.createGrid('s_ppl190skrv_kdGrid1', {
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
  var masterGrid2 = Unilite.createGrid('s_ppl190skrv_kdGrid2', {
        layout : 'fit',
        region:'south',
        store: directMasterStore2,
        uniOpt:{    
            expandLastColumn: false,
            useRowNumberer: true,
            useMultipleSorting: true
        },
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        columns: [
//            {dataIndex : 'WORK_END_YN',         width : 100},               
            {dataIndex : 'WKORD_NUM',           width : 130},
            {dataIndex : 'PRODT_WKORD_DATE',    width : 100},               
            {dataIndex : 'WORK_SHOP_CODE',      width : 120},
            {dataIndex : 'ITEM_CODE',           width : 110},
            {dataIndex : 'ITEM_NAME',           width : 160},
            {dataIndex : 'SPEC',                width : 140},              
            {dataIndex : 'LOT_NO',              width : 110}, 
            {dataIndex : 'PRODT_START_DATE',    width : 100},              
            {dataIndex : 'PRODT_END_DATE',      width : 100}, 
            {dataIndex : 'WKORD_Q',             width : 100},               
            {dataIndex : 'WORK_Q',             width : 100}, 
//            {dataIndex : 'GOOD_PRODT_Q',        width : 100},      
            {dataIndex : 'NO_WORK_Q',         width : 100}
        ] 
    });     //End of var masterGrid2 = Unilite.createGrid('s_ppl190skrv_kdGrid2', {   

    Unilite.Main({
        borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid1, masterGrid2, panelResult
         ]
      }
      ],
        id: 's_ppl190skrv_kdApp',
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            this.setDefault();
        },
        onQueryButtonDown : function(){
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore1.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['newData','deleteAll'], false);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid1.reset();
            masterGrid2.reset();
            this.setDefault();
        },
        setDefault: function() {
            directMasterStore1.clearData();
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PRODT_PLAN_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('PRODT_PLAN_DATE_TO', UniDate.get('endOfMonth'));
            UniAppManager.setToolbarButtons(['save'], false);
        }
    });     //End of Unilite.Main({
};      
</script>
