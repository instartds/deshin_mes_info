<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt600ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt600ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WR02" /> <!--프로젝트타입-->
    <t:ExtComboStore comboType="AU" comboCode="WR03" /> <!--작업반기-->
</t:appConfig>
<script type="text/javascript" >


function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt600ukrv_kdService.selectList',
            update: 's_ryt600ukrv_kdService.updateDetail',
            create: 's_ryt600ukrv_kdService.insertDetail',
            destroy: 's_ryt600ukrv_kdService.deleteDetail',
            syncAll: 's_ryt600ukrv_kdService.saveAll'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_ryt600ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string'},
            {name: 'CUSTOM_CODE'            ,text:'거래처코드'             ,type: 'string', allowBlank: false},
            {name: 'CUSTOM_NAME'            ,text:'거래처명'               ,type: 'string', allowBlank: false},
            {name: 'CON_FR_YYMM'            ,text:'시작년월'               ,type: 'string', allowBlank: false, maxLength: 6},
            {name: 'CON_TO_YYMM'            ,text:'종료년월'               ,type: 'string', allowBlank: false, maxLength: 6},
//            {name: 'WK_HALF_YEAR'           ,text:'작업반기'               ,type: 'string', allowBlank: false, comboType:'AU', comboCode:'WR03'},
            {name: 'PJT_TYPE'               ,text:'프로젝트구분'           ,type: 'string', allowBlank: false, comboType:'AU', comboCode:'WR02'},
            {name: 'AMT_SALES'              ,text:'매출금액'               ,type: 'uniPrice'},
            {name: 'AMT_MATERIAL'           ,text:'재료비'                 ,type: 'uniPrice'},
            {name: 'AMT_NET'                ,text:'순매가'                 ,type: 'uniPrice'},
            {name: 'AMT_ROYALTY'            ,text:'기술료'                 ,type: 'uniPrice', allowBlank: false},
            {name: 'SEND_DATE'              ,text:'송금일'                 ,type: 'uniDate', allowBlank: false},
            {name: 'WORK_YEAR'               ,text:'작업년도'                 ,type: 'string'},
            {name: 'WORK_SEQ'               ,text:'반기'                 ,type: 'int'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_ryt600ukrv_kdMasterStore1',{
        model: 's_ryt600ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
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

            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();    //syncAll 수정

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

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode
            },{
            	fieldLabel: '작업년도',
                name: 'WORK_YEAR',
                xtype: 'uniCombobox',
                holdable: 'hold',
                comboType : 'AU',
                comboCode : 'BS90',
                value: new Date().getFullYear(),
                allowBlank: false,
                hidden: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				value:'1',
				holdable: 'hold',
				allowBlank: false
				},
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처',
                    holdable: 'hold',
                    allowBlank: false,
                    listeners: {
                        applyextparam: function(popup){
                            popup.setExtParam({
                                'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                                'ADD_QUERY2': " AND DIV_CODE = ",
                                'ADD_QUERY3': "))"
                            });   //WHERE절 추카 쿼리
                        },
                        onSelected: {
                            fn: function(records, type) {
                                var param = panelResult.getValues();
                                s_ryt600ukrv_kdService.selectMasterData(param, function(provider, response) {
                                    if(!Ext.isEmpty(provider))   {
                                        panelResult.setValue('DIV_CODE', provider[0].DIV_CODE);
                                        panelResult.setValue('CUSTOM_CODE', provider[0].CUSTOM_CODE);
                                        panelResult.setValue('CUSTOM_NAME', provider[0].CUSTOM_NAME);
                                        panelResult.setValue('CON_FR_YYMM', provider[0].CON_FR_YYMM);
                                        panelResult.setValue('CON_TO_YYMM', provider[0].CON_TO_YYMM);
                                        panelResult.setAllFieldsReadOnly(true);
                                        UniAppManager.app.onQueryButtonDown();
                                    }
                                });
                            },
                            scope: this
                        }
                    }
            })
            ,{
                fieldLabel: '작업기간',
                xtype: 'uniMonthRangefield',
                allowBlank:true,
                startFieldName: 'CON_FR_YYMM',
                endFieldName: 'CON_TO_YYMM',
                holdable: 'hold',
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
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });

    var masterGrid = Unilite.createGrid('s_ryt600ukrv_kdmasterGrid', {
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
            { dataIndex: 'COMP_CODE'          ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'           ,           width: 80, hidden: true},
            {dataIndex: 'CUSTOM_CODE'             , width:120,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup:true,
                    listeners: {
                      applyextparam: function(popup){
                            popup.setExtParam({
                                'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                                'ADD_QUERY2': " AND DIV_CODE = ",
                                'ADD_QUERY3': "))"
                            });   //WHERE절 추카 쿼리
                        },
                      'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('CUSTOM_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'CUSTOM_NAME'        ,           width: 200},
            { dataIndex: 'CON_FR_YYMM'        ,           width: 80},
            { dataIndex: 'CON_TO_YYMM'        ,           width: 80},
//            { dataIndex: 'WK_HALF_YEAR'       ,           width: 80},
            { dataIndex: 'PJT_TYPE'           ,           width: 100},
            { dataIndex: 'AMT_SALES'          ,           width: 100},
            { dataIndex: 'AMT_MATERIAL'       ,           width: 100},
            { dataIndex: 'AMT_NET'            ,           width: 100},
            { dataIndex: 'AMT_ROYALTY'        ,           width: 100},
            { dataIndex: 'SEND_DATE'          ,           width: 100},
            { dataIndex: 'WORK_YEAR'          ,           width: 100, hidden: true},
            { dataIndex: 'WORK_SEQ'          ,           width: 100, hidden: true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['DIV_CODE', 'CUSTOM_NAME']))
                    {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                	if(UniUtils.indexOf(e.field, ['DIV_CODE', 'CUSTOM_NAME']))
                    {
                        return false;
                    } else {
                        return true;
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
        id  : 's_ryt600ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
        	var compCode        =   UserInfo.compCode;
            var divCode         =   panelResult.getValue('DIV_CODE');
            var customCode      =   panelResult.getValue('CUSTOM_CODE');
            var customName      =   panelResult.getValue('CUSTOM_NAME');
            var conFrYymm       =   panelResult.getValue('CON_FR_YYMM');
            var conToYymm       =   panelResult.getValue('CON_TO_YYMM');
            var workYear        =   panelResult.getValue('WORK_YEAR');
            var workSeq         =   panelResult.getValue('WORK_SEQ');
//            var wkHalfYear      =   '';
            var pjtType         =   '';
            var amtSales        =   0;
            var amtMaterial     =   0;
            var amtNet          =   0;
            var amtRoyalty      =   0;
            var sendDate        =   UniDate.get('today');

            var r = {
                COMP_CODE       : compCode,
                DIV_CODE        : divCode,
                CUSTOM_CODE     : customCode,
                CUSTOM_NAME     : customName,
                CON_FR_YYMM     : UniDate.getDbDateStr(conFrYymm).substring(0, 6),
                CON_TO_YYMM     : UniDate.getDbDateStr(conToYymm).substring(0, 6),
//                WK_HALF_YEAR    : wkHalfYear,
                PJT_TYPE        : pjtType,
                AMT_SALES       : amtSales,
                AMT_MATERIAL    : amtMaterial,
                AMT_NET         : amtNet,
                AMT_ROYALTY     : amtRoyalty,
                SEND_DATE       : sendDate,
                WORK_YEAR       : workYear,
                WORK_SEQ        : workSeq
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
        	var record = masterGrid.getSelectedRecord();
            if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
            	masterGrid.deleteSelectedRow();
            }
        },
        onSaveDataButtonDown: function () {
            directMasterStore.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('WORK_YEAR',     new Date().getFullYear());
            panelResult.setValue('WORK_SEQ',   '1');
            //panelResult.setValue('CON_FR_YYMM', UniDate.get('startOfYear'));
            //panelResult.setValue('CON_TO_YYMM', UniDate.get('today'));
        }
    });
}
</script>