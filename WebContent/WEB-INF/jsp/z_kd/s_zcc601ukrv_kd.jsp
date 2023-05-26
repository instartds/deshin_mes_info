<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc601ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc601ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!--사용여부-->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;   //조회버튼 누르면 나오는 조회창
var selectedGrid = 's_zcc601ukrv_kdGrid2';

function appMain() {
	
    var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zcc601ukrv_kdService.selectList'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zcc601ukrv_kdService.selectList1',
            update  : 's_zcc601ukrv_kdService.updateDetail1',
            create  : 's_zcc601ukrv_kdService.insertDetail1',
            destroy : 's_zcc601ukrv_kdService.deleteDetail1',
            syncAll : 's_zcc601ukrv_kdService.saveAll1'
        }
    });
    
    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zcc601ukrv_kdService.selectList2',
            update  : 's_zcc601ukrv_kdService.updateDetail2',
            create  : 's_zcc601ukrv_kdService.insertDetail2',
            destroy : 's_zcc601ukrv_kdService.deleteDetail2',
            syncAll : 's_zcc601ukrv_kdService.saveAll2'
        }
    });    
    
    /**
     *   Model 정의 
     * @type 
     */
    //그리드1, 2
    Unilite.defineModel('s_zcc601ukrv_kd1Model', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',       type : 'string', allowBlank : false},
            {name : 'DIV_CODE',             text : '사업장',         type : 'string', comboType : "BOR120"},
            {name : 'ENTRY_NUM',            text : '관리코드',        type : 'string'},
            {name : 'ENTRY_DATE',           text : '등록일자',        type : 'uniDate'},
            {name : 'DEPT_CODE',            text : '부서코드',        type : 'string'},
            {name : 'DEPT_NAME',            text : '부서명',         type : 'string'},
            {name : 'OEM_ITEM_CODE',        text : '품번',          type : 'string'},
            {name : 'ITEM_NAME',            text : '품명',          type : 'string'},
            {name : 'MAKE_QTY',             text : '금형벌수',        type : 'uniQty'},
            {name : 'MAKE_END_YN',          text : '제작완료',        type : 'string', comboType : 'AU', comboCode : 'B010'},
            {name : 'CUSTOM_CODE',          text : '납품업체',        type : 'string'},
            {name : 'CUSTOM_NAME',          text : '납품업체명',       type : 'string'},
            {name : 'MONEY_UNIT',           text : '화폐',            type : 'string', comboType : 'AU', comboCode : 'B004'},
            {name : 'EXCHG_RATE_O',         text : '환율',            type : 'uniER'},
            {name : 'MATERIAL_AMT',         text : '재료비',           type : 'uniPrice'},
            {name : 'MAKE_AMT',             text : '가공비',           type : 'uniPrice'},
            {name : 'ETC_AMT',              text : '기타',            type : 'uniPrice'},
            {name : 'TOTAL_AMT',            text : '합계',            type : 'uniPrice'},
            {name : 'EST_P',                text : '견적금액',          type : 'uniPrice'},
            {name : 'MARGIN_AMT',           text : '마진금액',          type : 'uniPrice'},
            {name : 'TEMP_P',               text : '임시금액',          type : 'uniPrice'},
            {name : 'NEGO_P',               text : '네고금액',          type : 'uniPrice'},
            {name : 'DELIVERY_AMT',         text : '납품금액',          type : 'uniPrice'},
            {name : 'DELIVERY_DATE',        text : '납품일자',          type : 'uniDate'},
            {name : 'COLLECT_AMT',          text : '수금금액',          type : 'uniPrice'},
            {name : 'COLLECT_DATE',         text : '수금일자',          type : 'uniDate'},
            {name : 'UN_COLLECT_AMT',       text : '미수금액',          type : 'uniPrice'},
            {name : 'CLOSE_YN',             text : '완료',            type : 'string', comboType : 'AU', comboCode : 'B010'}
        ]
    });

    //수금그리드
    Unilite.defineModel('s_zcc601ukrv_kd2Model', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',         type : 'string', allowBlank : false},
            {name : 'DIV_CODE',             text : '사업장',          type : 'string', comboType : "BOR120"},
            {name : 'ENTRY_NUM',            text : '관리코드',         type : 'string', allowBlank : false},
            {name : 'EST_SEQ',              text : '수금순번',         type : 'int', allowBlank : false},
            {name : 'COLLECT_DATE',         text : '일자',            type : 'uniDate', allowBlank : false},
            {name : 'COLLECT_QTY',          text : '수량',            type : 'uniPrice', allowBlank : false},
            {name : 'COLLECT_AMT',          text : '금액',            type : 'uniPrice', allowBlank : false},
            {name : 'REMARK',               text : '비고',            type : 'string'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */
    
    //그리드1
    var directMasterStore1 = Unilite.createStore('s_zcc601ukrv_kdMasterStore1',{
            model: 's_zcc601ukrv_kd1Model',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결 
                editable: false,        // 수정 모드 사용 
                deletable:false,        // 삭제 가능 여부 
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy1,
            loadStoreRecords : function(){
                var param= panelResult.getValues();          
                console.log(param);
                this.load({
                    params : param
                });
            }
    });    
    
    //그리드2
    var directMasterStore2 = Unilite.createStore('s_zcc601ukrv_kdMasterStore2',{
        model: 's_zcc601ukrv_kd1Model',
        uniOpt : {
            isMaster    : true,            // 상위 버튼 연결 
            editable    : true,            // 수정 모드 사용 
            deletable   : false,           // 삭제 가능 여부 
            useNavi     : false            // prev | newxt 버튼 사용
        },
        autoLoad : false,
        proxy: directProxy2,
        loadStoreRecords : function(param)   {   
//            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore : function() {
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);

                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();
                var toDelete = this.getRemovedRecords();
                var list = [].concat(toUpdate, toCreate);
                console.log("list:", list);

                //1. 마스터 정보 파라미터 구성
                var paramMaster = panelResult.getValues();    //syncAll 수정
                
                if(inValidRecs.length == 0) {
                    config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                                panelResult.getForm().wasDirty = false;
                                panelResult.resetDirtyStatus();
                                console.log("set was dirty to false");
                                UniAppManager.setToolbarButtons('save', false);     
                             } 
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_zcc601ukrv_kdGrid2');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
    }); // End of var directMasterStore2 
    
    
    //그리드3
    var directMasterStore3 = Unilite.createStore('s_zcc601ukrv_kdMasterStore3',{
        model: 's_zcc601ukrv_kd2Model',
        uniOpt : {
            isMaster    : true,            // 상위 버튼 연결 
            editable    : true,            // 수정 모드 사용 
            deletable   : true,            // 삭제 가능 여부 
            useNavi     : false            // prev | newxt 버튼 사용
        },
        autoLoad : false,
        proxy: directProxy3,
        loadStoreRecords : function(param)   {   
//            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore : function() {
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);

                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();
                var toDelete = this.getRemovedRecords();
                var list = [].concat(toUpdate, toCreate);
                console.log("list:", list);

                //1. 마스터 정보 파라미터 구성
                var paramMaster = panelResult.getValues();    //syncAll 수정
                
                if(inValidRecs.length == 0) {
                    config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                                panelResult.getForm().wasDirty = false;
                                panelResult.resetDirtyStatus();
                                console.log("set was dirty to false");
                                UniAppManager.setToolbarButtons('save', false);     
                             } 
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_zcc601ukrv_kdGrid3');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
    }); // End of var directMasterStore3
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
     var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding :'1 1 1 1',
        border :true,
        hidden : !UserInfo.appOption.collapseLeftSearch,
//        uniOnChange: function(basicForm, dirty, eOpts) {                
//            if(directMasterStore2.getCount() != 0 && panelResult.isDirty()) {
//                  UniAppManager.setToolbarButtons('save', true);
//            }
//        },
        items : [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode
            },{ 
                fieldLabel: '등록일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DATE',
                endFieldName: 'TO_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                colspan : 2
            },
            Unilite.popup('ENTRY_NUM1_KD', {
                    fieldLabel: '관리코드', 
                    valueFieldName: 'ENTRY_NUM',
                    textFieldName: 'ENTRY_NUM', 
                    validateBlank: false,
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
            }),
            Unilite.popup('DEPT', {
                    fieldLabel: '부서', 
                    valueFieldName: 'DEPT_CODE',
                    textFieldName: 'DEPT_NAME'
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',  
                xtype: 'uniTextfield'
            }
        ],
        api : {
            submit: 's_zcc601ukrv_kdService.syncForm'                
        },
        setAllFieldsReadOnly : function(b) { 
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
                    //this.mask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) ) {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ;       
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                //this.unmask();
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) ) {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField) {
                        var popupFC = item.up('uniPopupField') ; 
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        },
        setLoadRecord: function(record) {
            var me = this;   
            me.uniOpt.inLoading = false;
            me.setAllFieldsReadOnly(true);
        }
    });
    
    //그리드1
    var masterGrid1 = Unilite.createGrid('s_zcc601ukrv_kdGrid1', { 
        layout : 'fit',   
        region : 'center',                          
        store  : directMasterStore1,
        selModel: 'rowmodel',
        uniOpt : {    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        columns : [
            {dataIndex : 'COMP_CODE',           width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 100, hidden : true},
            {dataIndex : 'ENTRY_NUM',           width : 120},
            {dataIndex : 'ENTRY_DATE',          width : 90, align : 'center'},
            {dataIndex : 'DEPT_CODE',           width : 90},
            {dataIndex : 'DEPT_NAME',           width : 120},
            {dataIndex : 'OEM_ITEM_CODE',       width : 100},
            {dataIndex : 'ITEM_NAME',           width : 170},
            {dataIndex : 'MAKE_QTY',            width : 80},
            {dataIndex : 'MAKE_END_YN',         width : 80},
            {dataIndex : 'CUSTOM_CODE',         width : 100},
            {dataIndex : 'CUSTOM_NAME',         width : 170},
            {dataIndex : 'MONEY_UNIT',          width : 90},
            {dataIndex : 'EXCHG_RATE_O',        width : 90},
            {dataIndex : 'MATERIAL_AMT',        width : 120},
            {dataIndex : 'MAKE_AMT',            width : 120},
            {dataIndex : 'ETC_AMT',             width : 120},
            {dataIndex : 'TOTAL_AMT',           width : 120}
        ],
        listeners : {
            select : function() {
                selectedGrid = 's_zcc601ukrv_kdGrid1';
                UniAppManager.setToolbarButtons(['newData', 'deleteAll', 'delete'], false);
            }, 
            cellclick : function() {
                selectedGrid = 's_zcc601ukrv_kdGrid1';
                UniAppManager.setToolbarButtons(['newData', 'deleteAll', 'delete'], false);
            },
            render : function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedGrid = 's_zcc601ukrv_kdGrid1';
                    UniAppManager.setToolbarButtons(['newData', 'deleteAll', 'delete'], false);
                });
            },
            selectionchange : function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var param= panelResult.getValues(); 
                    param.ENTRY_NUM = record.data.ENTRY_NUM;
                    directMasterStore2.loadStoreRecords(param);
                }
            }, 
            beforeedit : function( editor, e, eOpts ) {
            	return false;
            }
        }
    });
    
    //그리드2
    var masterGrid2 = Unilite.createGrid('s_zcc601ukrv_kdGrid2', {
        layout : 'fit',
        region:'center',
        flex: 2,
        title : '금형비미수금',
        store : directMasterStore2, 
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: false
        },
        columns: [
            {dataIndex : 'COMP_CODE',       width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 100, hidden : true},
            {dataIndex : 'ENTRY_NUM',       width : 100, hidden : true},
            {dataIndex : 'EST_P',           width : 120},
            {dataIndex : 'MARGIN_AMT',      width : 120},
            {dataIndex : 'TEMP_P',          width : 120},
            {dataIndex : 'NEGO_P',          width : 120},
            {dataIndex : 'DELIVERY_AMT',    width : 120},
            {dataIndex : 'DELIVERY_DATE',   width : 90, align : 'center'},
            {dataIndex : 'COLLECT_AMT',     width : 120},
            {dataIndex : 'COLLECT_DATE',    width : 90, align : 'center'},
            {dataIndex : 'UN_COLLECT_AMT',  width : 120},
            {dataIndex : 'CLOSE_YN',        width : 100, hidden : true}
        ],
        listeners :{
            select : function() {
                selectedGrid = 's_zcc601ukrv_kdGrid2';
                UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'newData'], false);
            }, 
            cellclick : function() {
                selectedGrid = 's_zcc601ukrv_kdGrid2';
                UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'newData'], false);
            },
            selectionchange : function(model1, selected, eOpts) {
                if(selected.length > 0) {
                    var record = selected[0];
                    var param = panelResult.getValues();
                    param.DIV_CODE  = record.data.DIV_CODE;
                    param.ENTRY_NUM = record.data.ENTRY_NUM;
                    directMasterStore3.loadStoreRecords(param);
                }
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedGrid = 's_zcc601ukrv_kdGrid2';
                    UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'newData'], false);
                });
            }, 
            beforeedit : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['EST_P', 'TEMP_P', 'NEGO_P', 'DELIVERY_DATE', 'CLOSE_YN'])) 
                {
                    var record1 = masterGrid1.getSelectedRecord();
                    if(record1.get('MAKE_END_YN') == 'Y') {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return false;
                }
            }
        }
    });
    
    //그리드3
    var masterGrid3 = Unilite.createGrid('s_zcc601ukrv_kdGrid3', {
        layout : 'fit',
        region:'center',
        split: true,
        flex: 1,
        title : '수금내역',
        store : directMasterStore3,
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: false
        },
        columns: [
            {dataIndex : 'COMP_CODE',       width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 100, hidden : true},
            {dataIndex : 'ENTRY_NUM',       width : 100, hidden : true},
            {dataIndex : 'EST_SEQ',         width : 80},
            {dataIndex : 'COLLECT_DATE',    width : 90, align : 'center'},
            {dataIndex : 'COLLECT_QTY',     width : 80},
            {dataIndex : 'COLLECT_AMT',     width : 120},
            {dataIndex : 'REMARK',          width : 120}
        ],
        listeners :{
            select : function() {
                selectedGrid = 's_zcc601ukrv_kdGrid3';
                var count = masterGrid3.getStore().getCount();
                
                if(count == 0){
                   UniAppManager.setToolbarButtons(['newData'], true);
                   UniAppManager.setToolbarButtons(['delete', 'deleteAll'], false);
                } else {
            	   UniAppManager.setToolbarButtons(['delete', 'newData'], true);
//            	   UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'newData'], true);
                }
            }, 
            cellclick : function() {
                selectedGrid = 's_zcc601ukrv_kdGrid3';
                
                var count = masterGrid3.getStore().getCount();
                
                if(count == 0){
                   UniAppManager.setToolbarButtons(['newData'], true);
                   UniAppManager.setToolbarButtons(['delete', 'deleteAll'], false);
                } else {
                   UniAppManager.setToolbarButtons(['delete', 'newData'], true);
//                 UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'newData'], true);
                }
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedGrid = 's_zcc601ukrv_kdGrid3';
                    var count = masterGrid3.getStore().getCount();
                    
                    if(directMasterStore2.isDirty()){
                        grid.suspendEvents();
                        alert(Msg.sMB154);
                    } else {
                        masterSelectedGrid = girdNm;
                        if(grid.getStore().getCount() > 0)  {
                           UniAppManager.setToolbarButtons(['delete', 'newData'], true);
        //                 UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'newData'], true);
                        }else {
                           UniAppManager.setToolbarButtons(['newData'], true);
                           UniAppManager.setToolbarButtons(['delete', 'deleteAll'], false);
                        }
                    }
                });
            }, 
            beforeedit : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['COLLECT_DATE', 'COLLECT_QTY', 'REMARK'])) 
                {
            	   var record1 = masterGrid2.getSelectedRecord();
                    if(record1.get('NEGO_P') == 0) {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return false;
                }
            }
        }
    });
    
    
    Unilite.Main({
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    masterGrid1, panelResult,
                    {
                        region : 'south',
                        xtype : 'container',
                        layout: {type: 'hbox', align: 'stretch'},
                        flex: 1,
                        items : [ masterGrid2,  masterGrid3]
                    }
                ]
            }
        ],
        id : 's_zcc601ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'deleteAll'], false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
            }
            directMasterStore1.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown : function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm(); 
            masterGrid1.reset(); 
            masterGrid2.reset(); 
            masterGrid3.reset();
            this.setDefault();
        },
        onNewDataButtonDown : function() {
            var record = masterGrid2.getSelectedRecord();
            if(Ext.isEmpty(record)){
               return false;
            }
            var seq = directMasterStore3.max('EST_SEQ');
            if(!seq) seq = 1;
            else  seq += 1;
             
            var r = {
               COMP_CODE        : record.get('COMP_CODE'),
               DIV_CODE         : panelResult.getValue('DIV_CODE'),
               ENTRY_NUM        : record.get('ENTRY_NUM'),
               EST_SEQ          : seq
            }
            masterGrid3.createRow(r);
        },
        onDeleteDataButtonDown : function() {
            if(selectedGrid == 's_zcc601ukrv_kdGrid2') {
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid2.deleteSelectedRow();
                }
            } else if(selectedGrid == 's_zcc601ukrv_kdGrid3') {
            	var selRow1 = masterGrid3.getSelectedRecord();
                if(selRow1.phantom === true) {
                    masterGrid3.deleteSelectedRow();
                } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid3.deleteSelectedRow();
                }
            }
        },
        onDeleteAllButtonDown: function() {
            var records = directMasterStore3.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        /*---------삭제전 로직 구현 시작----------*/
                        
                        /*---------삭제전 로직 구현 끝-----------*/
                        
                        if(deletable){      
                            masterGrid3.reset();
                            UniAppManager.app.onSaveDataButtonDown();   
                        }                                                   
                    }
                    return false;
                }
            });
        },
        onSaveDataButtonDown : function () {
            if(selectedGrid == 's_zcc601ukrv_kdGrid2') {
                directMasterStore2.saveStore();
            } else if(selectedGrid == 's_zcc601ukrv_kdGrid3') {
                directMasterStore3.saveStore();
            }
        },
        setDefault: function() {
            directMasterStore1.clearData();
            directMasterStore2.clearData();
            directMasterStore3.clearData();
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save'], false);
            UniAppManager.setToolbarButtons(['newData'], false);
        },
        checkForNewDetail:function() { 
            return panelResult.setAllFieldsReadOnly(true);
        }                         
    });
    
    Unilite.createValidator('validator01', {
        store: directMasterStore2,
        grid: masterGrid2,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
        	var record2 = masterGrid1.getSelectedRecord();
        	
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
            var rv = true;
            
            switch(fieldName) {
                case "EST_P" :
                    if(newValue < 0) {
                        rv = Msg.sMB100;
                        break;
                    }
                    record.set('MARGIN_AMT', newValue - record2.get('TOTAL_AMT'));
                    break;
                    
                case "TEMP_P" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    if(record.get('NEGO_P') == 0) {
                        record.set('DELIVERY_AMT', newValue);
                    }
                    break;
                    
                case "NEGO_P" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    if(newValue != 0) {
                        record.set('DELIVERY_AMT', newValue);
                    } else {
                    	if(record.get('TEMP_P') == 0) {
                    	   record.set('DELIVERY_AMT', 0);
                    	}
                    	else {
                    		record.set('DELIVERY_AMT', record.get('TEMP_P'));
                    	}
                    }
                    
                    break;
            }
            return rv;
        }
    });
    
    Unilite.createValidator('validator02', {
        store: directMasterStore3,
        grid: masterGrid3,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            var record3 = masterGrid2.getSelectedRecord();
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
            var rv = true;
            
            switch(fieldName) {
                case "COLLECT_QTY" :
                    if(newValue < 0) {
                        rv = Msg.sMB100;
                        break;
                    }
                    record.set('COLLECT_AMT', newValue * record3.get('NEGO_P'));
                    break;
            }
            return rv;
        }
    });    
}

</script>