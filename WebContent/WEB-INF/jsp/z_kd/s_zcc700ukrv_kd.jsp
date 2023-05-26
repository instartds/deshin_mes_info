<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc700ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc700ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!--사용여부-->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;   //조회버튼 누르면 나오는 조회창

function appMain() {
	
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zcc700ukrv_kdService.selectList',
            update  : 's_zcc700ukrv_kdService.updateDetail',
            create  : 's_zcc700ukrv_kdService.insertDetail',
            destroy : 's_zcc700ukrv_kdService.deleteDetail',
            syncAll : 's_zcc700ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zcc700ukrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',       type : 'string', allowBlank : false},
            {name : 'DIV_CODE',             text : '사업장',         type : 'string', comboType : "BOR120"},
            {name : 'ENTRY_NUM',            text : '관리코드',        type : 'string'},
            {name : 'ENTRY_DATE',           text : '등록일자',        type : 'uniDate', allowBlank : false},
            {name : 'DEPT_CODE',            text : '부서코드',        type : 'string', allowBlank : false},
            {name : 'DEPT_NAME',            text : '부서명',         type : 'string'},
            {name : 'OEM_ITEM_CODE',        text : '품번',          type : 'string', allowBlank : false, maxLength: 20},
            {name : 'ITEM_NAME',            text : '품명',          type : 'string', allowBlank : false, maxLength: 20},
            {name : 'MAKE_QTY',             text : '가공수량',        type : 'uniQty', allowBlank : false},
            {name : 'MAKE_END_YN',          text : '가공완료',        type : 'string', allowBlank : false, comboType : 'AU', comboCode : 'B010'},
            {name : 'CUSTOM_CODE',          text : '납품업체',        type : 'string', allowBlank : false},
            {name : 'CUSTOM_NAME',          text : '납품업체명',       type : 'string'},
            {name : 'MONEY_UNIT',           text : '화폐',            type : 'string', allowBlank : false, comboType : 'AU', comboCode : 'B004'},
            {name : 'EXCHG_RATE_O',         text : '환율',            type : 'uniER', allowBlank : false},
            {name : 'WIRE_P',               text : '와이어단가',       type : 'uniQty', allowBlank : false},
            {name : 'WIRE_S_P',             text : '와이어S단가',      type : 'uniQty', allowBlank : false},
            {name : 'LASER_P',              text : '레어지단가',       type : 'uniQty', allowBlank : false},
            {name : 'COAT_P',               text : '코팅단가',        type : 'uniQty', allowBlank : false},
            {name : 'ETC_P',                text : '기타단가',        type : 'uniQty', allowBlank : false},
            {name : 'TOTAL_P',              text : '합계',           type : 'uniQty'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zcc700ukrv_kdMasterStore1',{
        model: 's_zcc700ukrv_kdModel',
        uniOpt : {
            isMaster    : true,            // 상위 버튼 연결 
            editable    : true,            // 수정 모드 사용 
            deletable   : true,            // 삭제 가능 여부 
            useNavi     : false            // prev | newxt 버튼 사용
        },
        autoLoad : false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
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
    
                Ext.each(list, function(record, index) {
                    if(!Ext.isEmpty(record.data['ENTRY_NUM'])) {
                        record.set('ENTRY_NUM', record.data['ENTRY_NUM']);
                    }
                })
                
                console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
                
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
                    var grid = Ext.getCmp('s_zcc700ukrv_kdGrid');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
    }); // End of var directMasterStore1 
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
     var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding :'1 1 1 1',
        border :true,
        hidden : !UserInfo.appOption.collapseLeftSearch,
//        uniOnChange: function(basicForm, dirty, eOpts) {                
//            if(directMasterStore.getCount() != 0 && panelResult.isDirty()) {
//                  UniAppManager.setToolbarButtons('save', true);
//            }
//        },
        items : [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                //holdable: 'hold',
                value: UserInfo.divCode
            },{ 
                fieldLabel: '등록일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DATE',
                endFieldName: 'TO_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
               // holdable: 'hold'
            },
            Unilite.popup('ENTRY_NUM2_KD', {
                    fieldLabel: '관리코드', 
                    valueFieldName: 'ENTRY_NUM',
                    textFieldName: 'ENTRY_NUM', 
                    validateBlank: false,
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
            })
        ],
        api : {
            submit: 's_zcc700ukrv_kdService.syncForm'                
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
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });
    
    var masterGrid = Unilite.createGrid('s_zcc700ukrv_kdGrid', { 
        layout : 'fit',   
        region : 'center',                          
        store  : directMasterStore,
        uniOpt : {
            expandLastColumn    : false,
            useMultipleSorting  : true,
            useGroupSummary     : false,
            useLiveSearch       : true,
            useContextMenu      : true,
            useRowNumberer      : false,
            filter : {
                useFilter: true,
                autoCreate: true
            }
        },
        columns : [ 
            {dataIndex : 'COMP_CODE',           width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 100, hidden : true},
            {dataIndex : 'ENTRY_NUM',           width : 120},
            {dataIndex : 'ENTRY_DATE',          width : 90, align : 'center'},
            {dataIndex : 'DEPT_CODE',           width : 100,
                'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'DEPT_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                      }
                    }
                })
            },
            {dataIndex : 'DEPT_NAME',           width : 120,
            	'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'DEPT_NAME',
                    listeners: { 'onSelected': {
                        fn: function(records, type){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                      }
                    }
                })	
            },
            {dataIndex : 'OEM_ITEM_CODE',       width : 100},
            {dataIndex : 'ITEM_NAME',           width : 170},
            {dataIndex : 'MAKE_QTY',            width : 100			,format: '0,0'},
            {dataIndex : 'MAKE_END_YN',         width : 100},
            {dataIndex : 'CUSTOM_CODE',         width : 100,
              'editor' : Unilite.popup('AGENT_CUST_G', {
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup:true,
                    listeners: { 'onSelected' : {
                        fn: function(records, type){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
                        },
                        scope : this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE', '');
                            grdRecord.set('CUSTOM_NAME', '');
                      }
                    }
                })
            },
            {dataIndex : 'CUSTOM_NAME',         width: 170,
              'editor': Unilite.popup('AGENT_CUST_G', {
                    textFieldName : 'CUSTOM_NAME',
                    DBtextFieldName : 'CUSTOM_NAME',
                    autoPopup:true,
                    listeners : { 'onSelected': {
                        fn: function(records, type){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE', '');
                            grdRecord.set('CUSTOM_NAME', '');
                      }
                    }
                })
            },
            {dataIndex : 'MONEY_UNIT',          width : 100},
            {dataIndex : 'EXCHG_RATE_O',        width : 90},
            {dataIndex : 'WIRE_P',              width : 120},
            {dataIndex : 'WIRE_S_P',            width : 120},
            {dataIndex : 'LASER_P',             width : 120},
            {dataIndex : 'COAT_P',              width : 120},
            {dataIndex : 'ETC_P',               width : 120},
            {dataIndex : 'TOTAL_P',             width : 120}
        ],
        listeners: {
        	beforeedit : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['ENTRY_NUM',  'CUSTOM_NAME', 'TOTAL_P'])) {
                        return false;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['ENTRY_NUM',  'CUSTOM_NAME', 'TOTAL_P'])) {
                        return false;
                    }
                }
            }
        }
    });
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    masterGrid, panelResult
                ]
            }    
        ],
        id  : 's_zcc700ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'deleteAll'], false);
            UniAppManager.setToolbarButtons(['newData'], true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['newData'], true);
        },
        onResetButtonDown : function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            panelResult.clearForm(); 
            masterGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown : function() {       // 행추가
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
            }
            
            var compCode        =   UserInfo.compCode;
            var divCode         =   panelResult.getValue('DIV_CODE');
            var entryDate       =   UniDate.get('today');
            var moneyUnit       =   'KRW';
            var exchgRateO      =   1;
            var makeEndYN       =   'N';
            
            var r = {
                COMP_CODE       : compCode,
                DIV_CODE        : divCode,
                ENTRY_DATE      : entryDate,
                MONEY_UNIT      : moneyUnit,  
                EXCHG_RATE_O    : exchgRateO,
                MAKE_END_YN     : makeEndYN
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown : function() {
            var selRow1 = masterGrid.getSelectedRecord();
                if(selRow1.phantom === true) {
                    masterGrid.deleteSelectedRow();
                } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
        },
        onSaveDataButtonDown : function () {
        	directMasterStore.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save'], false);
        },
        checkForNewDetail:function() { 
            return panelResult.setAllFieldsReadOnly(true);
        }                         
    });
    
    Unilite.createValidator('validator01', {
        store: directMasterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
            var rv = true;
            
            switch(fieldName) {
                case "WIRE_P" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }                    
                    record.set('TOTAL_P', newValue + record.get('WIRE_S_P') + record.get('LASER_P') + record.get('COAT_P') + record.get('ETC_P'));
                    break;
                    
                case "WIRE_S_P" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    record.set('TOTAL_P', record.get('WIRE_P') + newValue + record.get('LASER_P') + record.get('COAT_P') + record.get('ETC_P'));
                    break;
                    
                case "LASER_P" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    record.set('TOTAL_P', record.get('WIRE_P') + record.get('WIRE_S_P') + newValue + record.get('COAT_P') + record.get('ETC_P'));
                    break;

                case "COAT_P" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    record.set('TOTAL_P', record.get('WIRE_P') + record.get('WIRE_S_P') + record.get('LASER_P') + newValue + record.get('ETC_P'));
                    break;
                    
                case "ETC_P" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    record.set('TOTAL_P', record.get('WIRE_P') + record.get('WIRE_S_P') + record.get('LASER_P') + record.get('COAT_P') + newValue);
                    break;
            }
            return rv;
        }
    });    
}

</script>