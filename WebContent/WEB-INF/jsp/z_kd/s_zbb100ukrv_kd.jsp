<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zbb100ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zbb100ukrv_kd"  />    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />                 <!--차종-->
    <t:ExtComboStore comboType="AU" comboCode="WZ28" />                 <!--도면구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ29" />                 <!--부품구분-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};

function appMain() {
    
    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read: 's_zbb100ukrv_kdService.selectList',
            update: 's_zbb100ukrv_kdService.updateDetail',
            create: 's_zbb100ukrv_kdService.insertDetail',
            destroy: 's_zbb100ukrv_kdService.deleteDetail',
            syncAll: 's_zbb100ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zbb100ukrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',        text : '법인코드',              type : 'string'},
            {name : 'DIV_CODE',         text : '사업자코드',             type : 'string'},
            {name : 'DOC_NUM',          text : 'CAD번호',              type : 'string', allowBlank: isAutoOrderNum},
            {name : 'DOC_GUBUN',        text : '도면구분',             type : 'string', comboType: 'AU', comboCode: 'WZ28', allowBlank : false},
            {name : 'PART_GUBUN',       text : '부품구분',             type : 'string', comboType: 'AU', comboCode: 'WZ29', allowBlank : false},
            {name : 'CUSTOM_NAME',      text : '고객사',               type : 'string'},
            {name : 'ITEM_CODE',        text : '품목코드',              type : 'string', allowBlank : false},
            {name : 'ITEM_NAME',        text : '품목명',               type : 'string'},
            {name : 'OEM_ITEM_CODE',    text : '품번',                type : 'string'},
            {name : 'CAR_TYPE',         text : '차종',                type : 'string', comboType: 'AU', comboCode: 'WB04'},
            {name : 'REVISION_NO',      text : '도면리비젼',             type : 'int', allowBlank : false, maxLength : 2},
            {name : 'WORK_DATE',        text : '작성일자',              type : 'uniDate', allowBlank : false},
            {name : 'WORK_MAN',         text : '작성자',               type : 'string'},
            {name : 'REMARK',           text : '비고',                type : 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zbb100ukrv_kdMasterStore1', {
        model: 's_zbb100ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  true,            // 수정 모드 사용 
            deletable: true,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function() {
            var param = panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
            
            Ext.each(list, function(record, index) {
                if(!Ext.isEmpty(record.data['DOC_NUM'])) {
                    record.set('DOC_NUM', record.data['DOC_NUM']);
                }
            })
            
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
//                        UniAppManager.app.onQueryButtonDown();
                    } 
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1 
    
    var panelResult = Unilite.createSearchForm('resultForm', {
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank : false,
                value: UserInfo.divCode
            }, {
                fieldLabel: '도면구분',
                name:'DOC_GUBUN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ28'
            }, {
                fieldLabel: '부품구분',
                name:'PART_GUBUN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ29',
                colspan: 2
            }, {
                fieldLabel: '고객사',
                name:'CUSTOM_NAME',
                xtype: 'uniTextfield'
            }, {
                fieldLabel: '차종',
                name:'CAR_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WB04'
            }, {
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '품명',
                name:'ITEM_NAME',
                xtype: 'uniTextfield'
            }, {
                fieldLabel: 'CAD번호',
                name:'DOC_NUM',
                xtype: 'uniTextfield',
//                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold'
            }, {
                fieldLabel: '작성일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_WORK_DATE',
                endFieldName: 'TO_WORK_DATE',
                allowBlank : false,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            }, {
                fieldLabel: '비고',
                name:'REMARK',
                width: 500,
                xtype: 'uniTextfield'
            }
        ],
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
    
    var masterGrid = Unilite.createGrid('s_zbb100ukrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [ 
            {dataIndex : 'COMP_CODE',           width : 130, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 130, hidden : true},
            {dataIndex : 'DOC_NUM',             width : 120},
            {dataIndex : 'DOC_GUBUN',           width : 100},
            {dataIndex : 'PART_GUBUN',          width : 100},
            {dataIndex : 'CUSTOM_NAME',         width : 100},
            {dataIndex : 'ITEM_CODE',           width : 120,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
                        useBarcodeScanner: false,
                        autoPopup:true,
                        listeners: {'onSelected': {
//                            fn: function(records, type) {
//                                console.log('records : ', records);
//                                Ext.each(records, function(record,i) {                                                                     
//                                    if(i==0) {
//                                        masterGrid.setItemData(record, false, masterGrid.uniOpt.currentRecord);
//                                    } else {
//                                        UniAppManager.app.onNewDataButtonDown();
//                                        masterGrid.setItemData(record, false, masterGrid.getSelectedRecord());
//                                    }
//                                }); 
//                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid.setItemData(null, true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            var record  = masterGrid.getSelectedRecord();
                            var divCode = record.get('DIV_CODE');
                            popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
                            popup.setExtParam({'DIV_CODE': divCode});
                        }
                    }
                })
            ,hidden : true},
            {dataIndex : 'ITEM_NAME',           width : 170},
            {dataIndex : 'OEM_ITEM_CODE',       width : 120},
            {dataIndex : 'CAR_TYPE',            width : 130, comboType: 'AU', comboCode: 'WB04'},
            {dataIndex : 'REVISION_NO',         width : 130},
            {dataIndex : 'WORK_DATE',           width : 110, align : 'center'},
            {dataIndex : 'WORK_MAN',            width : 120},
            {dataIndex : 'REMARK',              width : 150}
                    
        ],
        listeners: {
            beforeedit : function(editor, e, eOpts) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['DOC_GUBUN', 'PART_GUBUN', 'CUSTOM_NAME', 'ITEM_CODE', 'REVISION_NO', 'WORK_DATE', 'WORK_MAN', 'REMARK'])) 
                    {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['CUSTOM_NAME', 'ITEM_CODE', 'WORK_MAN', 'REMARK','ITEM_NAME','CAR_TYPE','OEM_ITEM_CODE'])) 
                    {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        },
        setItemData: function(record, dataClear) {
            var grdRecord = this.getSelectedRecord();
            if(dataClear) {
                grdRecord.set('ITEM_CODE',      ''); 
                grdRecord.set('ITEM_NAME',      '');
                grdRecord.set('CAR_TYPE',       ''); 
                grdRecord.set('OEM_ITEM_CODE',  '');
            } else {                                    
                grdRecord.set('ITEM_CODE',      record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME',      record['ITEM_NAME']);
                grdRecord.set('CAR_TYPE',       record['CAR_TYPE']); 
                grdRecord.set('OEM_ITEM_CODE',  record['OEM_ITEM_CODE']);
            }
        }
    });
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[{
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid ]
                    },
                    panelResult
                ]
            }
        ],
        id : 's_zbb100ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'], false);
            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
            var compCode    = UserInfo.compCode; 
            var divCode     = panelResult.getValue('DIV_CODE');
            var workDate    = UniDate.get('today');
            
            var r = {
                COMP_CODE    : compCode,
                DIV_CODE     : divCode,
                WORK_DATE    : workDate
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
            var record = masterGrid.getSelectedRecord();
            
            if(record.phantom === true) {
                masterGrid.deleteSelectedRow();
            } else {
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
            }
        },
        onSaveDataButtonDown: function () {
            directMasterStore.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('FR_WORK_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_WORK_DATE', UniDate.get('today'));
            panelResult.getForm().wasDirty = false;
            UniAppManager.setToolbarButtons(['save'], false);
        }
    });                         
}
</script>