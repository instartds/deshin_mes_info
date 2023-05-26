<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt200ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt200ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B131" /> <!--BOM적용여부 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
    <t:ExtComboStore comboType="AU" comboCode="WR01" /> <!--비율/단가 -->
    <t:ExtComboStore comboType="AU" comboCode="WR02" /> <!--프로젝트타입-->
    <t:ExtComboStore comboType="AU" comboCode="WR03" /> <!--작업반기-->
    <t:ExtComboStore comboType="AU" comboCode="WR04" /> <!--수량/금액-->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;   //조회버튼 누르면 나오는 조회창

function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt200ukrv_kdService.selectList',
            update: 's_ryt200ukrv_kdService.updateDetail',
            create: 's_ryt200ukrv_kdService.insertDetail',
            destroy: 's_ryt200ukrv_kdService.deleteDetail',
            syncAll: 's_ryt200ukrv_kdService.saveAll'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('inoutNoMasterModel', {       // (DETAIL)
        fields: [
            {name: 'COMP_CODE'             ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'              ,text:'사업장'                 ,type: 'string'},
            {name: 'SEQ'                   ,text:'순번'                   ,type: 'int'},
            {name: 'CON_FR_YYMM'           ,text:'개시년월'               ,type: 'string'},
            {name: 'CON_TO_YYMM'           ,text:'종료년월'               ,type: 'string'},
            {name: 'CUSTOM_CODE'           ,text:'거래처코드'             ,type: 'string'},
            {name: 'GUBUN1'                ,text:'비율단가구분'           ,type: 'string', comboType:'AU', comboCode:'WR01'},
            {name: 'GUBUN2'                ,text:'수량금액구분'           ,type: 'string', comboType:'AU', comboCode:'WR04'},   // master
            {name: 'GUBUN3'                ,text:'BOM적용'                ,type: 'string', comboType:'AU', comboCode:'B131'},   // master
            {name: 'ITEM_CODE'             ,text:'품목코드'               ,type: 'string'},
            {name: 'ITEM_NAME'             ,text:'품목명'                 ,type: 'string'},
            {name: 'SPEC'                  ,text:'규격'                   ,type: 'string'},
            {name: 'OEM_ITEM_CODE'         ,text:'품번(OEM)'              ,type: 'string'},
            {name: 'RATE_N'                ,text:'비율(%)'                ,type: 'uniPercent'},
            {name: 'PJT_TYPE'              ,text:'프로젝트타입'           ,type: 'string', comboType:'AU', comboCode:'WR02'},
            {name: 'MONEY_UNIT'            ,text:'화폐단위'               ,type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},   // master
            {name: 'RYT_P'                 ,text:'단가'                   ,type: 'float', format: '0,000,000.000,000'},                                   // master
            {name: 'WORK_YEAR'                  ,text:'WORK_YEAR'                   ,type: 'string' , hidden:true},
            {name: 'WORK_SEQ'                  ,text:'WORK_SEQ'                   ,type: 'string' , hidden:true}
        ]
    });

    Unilite.defineModel('s_ryt200ukrv_kdModel', {          // 검색팝업창(MASTER)
        fields: [
            {name: 'COMP_CODE'             ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'              ,text:'사업자코드'             ,type: 'string'},
            {name: 'CUSTOM_CODE'           ,text:'거래처코드'             ,type: 'string'},
            {name: 'CUSTOM_NAME'           ,text:'거래처명'               ,type: 'string'},
            {name: 'CON_FR_YYMM'           ,text:'시작년월'               ,type: 'string'},
            {name: 'CON_TO_YYMM'           ,text:'종료년월'               ,type: 'string'},
            {name: 'GUBUN1'                ,text:'비율단가구분'           ,type: 'string', comboType:'AU', comboCode:'WR01'},
            {name: 'GUBUN2'                ,text:'수량금액구분'           ,type: 'string', comboType:'AU', comboCode:'WR04'},
            {name: 'GUBUN3'                ,text:'BOM적용'                ,type: 'string', comboType:'AU', comboCode:'B131'},
            {name: 'MONEY_UNIT'            ,text:'화폐단위'               ,type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name: 'RYT_P'                 ,text:'단가'                   ,type: 'float', format: '0,000,000.000,000'},
            {name: 'WORK_YEAR'                  ,text:'WORK_YEAR'                   ,type: 'string'},
            {name: 'WORK_SEQ'                  ,text:'WORK_SEQ'                   ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_ryt200ukrv_kdMasterStore1',{
        model: 'inoutNoMasterModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  false,            // 수정 모드 사용
            deletable: false,            // 삭제 가능 여부
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

            var isErr = false;
            Ext.each(list, function(record, index) {
                if(record.data['GUBUN1'] == 'P') {
                    if(Ext.isEmpty(panelResult.getValue('RYT_P')) || panelResult.getValue('RYT_P') == 0) {
                        alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '단가: 필수 입력값 입니다.');
                        isErr = true;
                        return false;
                    }
                }
            });
            if(isErr) return false;

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
        masterGrid: masterGrid,
//        uniOnChange: function(basicForm, dirty, eOpts) {
//            if(directMasterStore.getCount() != 0 && panelResult.isDirty()) {
//                  UniAppManager.setToolbarButtons('save', true);
//            }
//        },
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
				comboType : 'AU',
			    comboCode : 'BS90',
				holdable: 'hold',
				value: new Date().getFullYear(),
				allowBlank: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				holdable: 'hold',
				allowBlank: false
				},
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처',
                    allowBlank:false,
                    holdable: 'hold',
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
                                s_ryt200ukrv_kdService.selectMasterData(param, function(provider, response) {
                                    if(!Ext.isEmpty(provider))   {
                                        panelResult.setValue('DIV_CODE', provider[0].DIV_CODE);
                                        panelResult.setValue('CUSTOM_CODE', provider[0].CUSTOM_CODE);
                                        panelResult.setValue('CUSTOM_NAME', provider[0].CUSTOM_NAME);
                                        panelResult.setValue('CON_FR_YYMM', provider[0].CON_FR_YYMM);
                                        panelResult.setValue('CON_TO_YYMM', provider[0].CON_TO_YYMM);
                                        panelResult.setValue('GUBUN1', provider[0].GUBUN1);
                                        panelResult.setValue('GUBUN2', provider[0].GUBUN2);
                                        panelResult.setValue('GUBUN3', provider[0].GUBUN3);
                                        panelResult.setValue('MONEY_UNIT', provider[0].MONEY_UNIT);
                                        var rytP = provider[0].RYT_P;
                                        if(Ext.isEmpty(rytP)) {
                                            rytP = 0.0000;
                                        }
                                        panelResult.setValue('RYT_P', rytP);
//                                        panelResult.setAllFieldsReadOnly(true);
//                                        UniAppManager.app.onQueryButtonDown();
                                    } else {
                                    	panelResult.setValue('RYT_P', 0.0000);
                                    }
                                });
                            },
                            scope: this
                        }
                    }
            }),{
                fieldLabel: '비율/단가',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WR01',
                allowBlank:false,
                name: 'GUBUN1',
                holdable: 'hold',
                listeners: {
                	change: function(field, newValue, oldValue, eOpts) {
                		if(panelResult.getValue('GUBUN1') == 'R') {
                            //panelResult.getField('RYT_P').setReadOnly(true);
                            panelResult.getField('RYT_P').setConfig('fieldLabel','비율');
                		} else {
                            panelResult.getField('RYT_P').setReadOnly(false);
                            panelResult.getField('RYT_P').setConfig('fieldLabel','단가');
                		}
                        if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
                            var param = panelResult.getValues();
                            s_ryt200ukrv_kdService.selectMasterData(param, function(provider, response) {
                                if(!Ext.isEmpty(provider))   {
                                    panelResult.setValue('DIV_CODE', provider[0].DIV_CODE);
                                    panelResult.setValue('CUSTOM_CODE', provider[0].CUSTOM_CODE);
                                    panelResult.setValue('CUSTOM_NAME', provider[0].CUSTOM_NAME);
                                    panelResult.setValue('CON_FR_YYMM', provider[0].CON_FR_YYMM);
                                    panelResult.setValue('CON_TO_YYMM', provider[0].CON_TO_YYMM);
                                    panelResult.setValue('GUBUN1', provider[0].GUBUN1);
                                    panelResult.setValue('GUBUN2', provider[0].GUBUN2);
                                    panelResult.setValue('GUBUN3', provider[0].GUBUN3);
                                    panelResult.setValue('MONEY_UNIT', provider[0].MONEY_UNIT);
                                    var rytP = provider[0].RYT_P;
                                    if(Ext.isEmpty(rytP)) {
                                        rytP = 0.0000;
                                    }
                                    panelResult.setValue('RYT_P', rytP);
//                                    panelResult.setAllFieldsReadOnly(true);
//                                    UniAppManager.app.onQueryButtonDown();
                                } else {
                                    panelResult.setValue('RYT_P', 0.0000);
                                }
                            });
                        }
                    }
                }
            },{
                fieldLabel: 'BOM적용여부',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B131',
                allowBlank:false,
                holdable: 'hold',
                name: 'GUBUN3'
            },{
                fieldLabel: '작업기간',
                xtype: 'uniMonthRangefield',
                allowBlank:true,
                startFieldName: 'CON_FR_YYMM',
                endFieldName: 'CON_TO_YYMM',
                holdable: 'hold',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
                        var param = panelResult.getValues();
                        s_ryt200ukrv_kdService.selectMasterData(param, function(provider, response) {
                            if(!Ext.isEmpty(provider))   {
                                panelResult.setValue('DIV_CODE', provider[0].DIV_CODE);
                                panelResult.setValue('CUSTOM_CODE', provider[0].CUSTOM_CODE);
                                panelResult.setValue('CUSTOM_NAME', provider[0].CUSTOM_NAME);
                                panelResult.setValue('CON_FR_YYMM', provider[0].CON_FR_YYMM);
                                panelResult.setValue('CON_TO_YYMM', provider[0].CON_TO_YYMM);
                                panelResult.setValue('GUBUN1', provider[0].GUBUN1);
                                panelResult.setValue('GUBUN2', provider[0].GUBUN2);
                                panelResult.setValue('GUBUN3', provider[0].GUBUN3);
                                panelResult.setValue('MONEY_UNIT', provider[0].MONEY_UNIT);
                                var rytP = provider[0].RYT_P;
                                if(Ext.isEmpty(rytP)) {
                                    rytP = 0.0000;
                                }
                                panelResult.setValue('RYT_P', rytP);
                                panelResult.setAllFieldsReadOnly(true);
                                UniAppManager.app.onQueryButtonDown();
                            } else {
                                panelResult.setValue('RYT_P', 0.0000);
                            }
                        });
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(!Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
                        var param = panelResult.getValues();
                        s_ryt200ukrv_kdService.selectMasterData(param, function(provider, response) {
                            if(!Ext.isEmpty(provider))   {
                                panelResult.setValue('DIV_CODE', provider[0].DIV_CODE);
                                panelResult.setValue('CUSTOM_CODE', provider[0].CUSTOM_CODE);
                                panelResult.setValue('CUSTOM_NAME', provider[0].CUSTOM_NAME);
                                panelResult.setValue('CON_FR_YYMM', provider[0].CON_FR_YYMM);
                                panelResult.setValue('CON_TO_YYMM', provider[0].CON_TO_YYMM);
                                panelResult.setValue('GUBUN1', provider[0].GUBUN1);
                                panelResult.setValue('GUBUN2', provider[0].GUBUN2);
                                panelResult.setValue('GUBUN3', provider[0].GUBUN3);
                                panelResult.setValue('MONEY_UNIT', provider[0].MONEY_UNIT);
                                var rytP = provider[0].RYT_P;
                                if(Ext.isEmpty(rytP)) {
                                    rytP = 0.0000;
                                }
                                panelResult.setValue('RYT_P', rytP);
                                panelResult.setAllFieldsReadOnly(true);
                                UniAppManager.app.onQueryButtonDown();
                            } else {
                                panelResult.setValue('RYT_P', 0.0000);
                            }
                        });
                    }
                }
            },{
                fieldLabel: '단가',
                xtype: 'uniNumberfield',
                holdable: 'hold',
                name:'RYT_P',
                renderer : Ext.util.Format.numberRenderer( '0,000.000,000'),
                renderer : Ext.util.Format.numberRenderer( '0.0000'),
                value: 0.0000
            },{
                fieldLabel: '수량/금액',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WR04',
                allowBlank:false,
                holdable: 'hold',
                name: 'GUBUN2'
            },{
                fieldLabel: '화폐',
                name: 'MONEY_UNIT',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B004',
                allowBlank: false,
                holdable: 'hold',
                displayField: 'value',
                hidden:true
            },{
                fieldLabel: '법인temp',
                xtype: 'uniTextfield',
                name:'COMP_CODE',
                hidden: true
            }
        ],
        api: {
            submit: 's_ryt200ukrv_kdService.syncMaster'
        },
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

    var masterGrid = Unilite.createGrid('s_ryt200ukrv_kdmasterGrid', {
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
        tbar: [{
            xtype: 'button',
            text: '내역생성',
            margin:'0 0 0 100',
            handler: function() {
            	if(UniAppManager.app.beforeSaveCheck() == false) {
                    return false;
                } else {
                	if(panelResult.setAllFieldsReadOnly(true) == false){
                        return false;
                    }
                    var param = panelResult.getValues();


                    s_ryt200ukrv_kdService.selectList(param, function(provider, response) {
                    	if(Ext.isEmpty(provider)) {
                    	    s_ryt200ukrv_kdService.selectList3(param, function(provider2, response2) {
                    	    	if(Ext.isEmpty(provider2)) {
                                    panelResult.setAllFieldsReadOnly(false)
                                } else {
                                    panelResult.setAllFieldsReadOnly(true)
                                }
                                var records2 = response2.result;
                                masterGrid.reset();
                                Ext.each(records2, function(record,i){
                                    UniAppManager.app.onNewDataButtonDown();
                                    masterGrid.setProviderData(record);
                                });
                            });
                    	} else {
                    		if(confirm('기존 데이터가 있습니다. 재생성하시겠습니까?')) {
                        	    s_ryt200ukrv_kdService.beforeSaveDelete(param, function(provider3, response3){
                        	       s_ryt200ukrv_kdService.selectList3(param, function(provider4, response4) {
                        	       	    if(Ext.isEmpty(provider4)) {
                                            panelResult.setAllFieldsReadOnly(false)
                                        } else {
                                            panelResult.setAllFieldsReadOnly(true)
                                        }
                                        var records4 = response4.result;
                                        masterGrid.reset();
                                        directMasterStore.clearData();
                                        Ext.each(records4, function(record,i){
                                            UniAppManager.app.onNewDataButtonDown();
                                            masterGrid.setProviderData(record);
                                        });
                                    });
                        	    });
                    		}
                    	}
                    });
                }
//                s_ryt200ukrv_kdService.selectList3(param, function(provider, response) {
//                    var records = response.result;
//                    Ext.each(records, function(record,i){
//                        UniAppManager.app.onNewDataButtonDown();
//                        masterGrid.setProviderData(record);
//                    });
//                });
            }
        }],
        columns:  [
            { dataIndex: 'COMP_CODE'            ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'             ,           width: 80, hidden: true},
            { dataIndex: 'SEQ'                  ,           width: 80, hidden: true},
            { dataIndex: 'CUSTOM_CODE'          ,           width: 80, hidden: true},
            { dataIndex: 'GUBUN1'               ,           width: 80, hidden: true},
            { dataIndex: 'ITEM_CODE'            ,           width: 110},
            { dataIndex: 'ITEM_NAME'            ,           width: 200},
            { dataIndex: 'SPEC'                 ,           width: 300},
            { dataIndex: 'OEM_ITEM_CODE'        ,           width: 150},
            {dataIndex: 'CON_FR_YYMM'           , width: 80                 , align: 'center'
            	,renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    if(!Ext.isEmpty(val)){
                        return  val.substring(0,4) + '.' + val.substring(4,6);
                       }}},
            { dataIndex: 'CON_TO_YYMM'          ,           width: 80 , align: 'center'
            	,renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    if(!Ext.isEmpty(val)){
                        return  val.substring(0,4) + '.' + val.substring(4,6);
                       }}},
            { dataIndex: 'RATE_N'               ,           width: 80},
            { dataIndex: 'PJT_TYPE'             ,           width: 200},
            { dataIndex: 'GUBUN2'               ,           width: 200, hidden: true},
            { dataIndex: 'GUBUN3'               ,           width: 200, hidden: true},
            { dataIndex: 'MONEY_UNIT'           ,           width: 200, hidden: true},
            { dataIndex: 'RYT_P'                ,           width: 200},
            { dataIndex: 'WORK_YEAR'               ,           width: 80, hidden: true},
            { dataIndex: 'WORK_SEQ'               ,           width: 80, hidden: true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field)) {
                        return false;
                    }
                } else {
                	if(UniUtils.indexOf(e.field))
                    {
                        return false;
                    }
                }
            }
        },
        setProviderData: function(record) {
            var grdRecord = this.getSelectedRecord();

            grdRecord.set('COMP_CODE'               , record['COMP_CODE']);
            grdRecord.set('DIV_CODE'                , record['DIV_CODE']);
            grdRecord.set('CUSTOM_CODE'             , record['CUSTOM_CODE']);
            grdRecord.set('GUBUN1'                  , record['GUBUN1']);
            grdRecord.set('GUBUN2'                  , record['GUBUN2']);
            grdRecord.set('GUBUN3'                  , record['GUBUN3']);
            grdRecord.set('CON_FR_YYMM'             , record['CON_FR_YYMM']);
            grdRecord.set('CON_TO_YYMM'             , record['CON_TO_YYMM']);
            grdRecord.set('ITEM_CODE'               , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'               , record['ITEM_NAME']);
            grdRecord.set('SPEC'                    , record['SPEC']);
            grdRecord.set('OEM_ITEM_CODE'           , record['OEM_ITEM_CODE']);
            grdRecord.set('RATE_N'                  , record['RATE_N']);
            grdRecord.set('PJT_TYPE'                , record['PJT_TYPE']);
            grdRecord.set('WORK_YEAR'                , panelResult.getValue('WORK_YEAR'));
            grdRecord.set('WORK_SEQ'                , panelResult.getValue('WORK_SEQ'));
        }
    });

    var inoutNoMasterStore = Unilite.createStore('inoutNoMasterStore', {    //조회버튼 누르면 나오는 조회창
        model: 's_ryt200ukrv_kdModel',
        autoLoad: false,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_ryt200ukrv_kdService.selectList2'
            }
        }
        ,loadStoreRecords : function()  {
            var param= inoutNoSearch.getValues();
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var inoutNoSearch = Unilite.createSearchForm('inoutNoSearchForm', {     //조회버튼 누르면 나오는 조회창
        layout: {type: 'uniTable', columns : 4},
        trackResetOnLoad: true,
        items: [
            {
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode
            } ,{
            	fieldLabel: '작업년도',
				name: 'WORK_YEAR',
				xtype: 'uniCombobox',
				comboType : 'AU',
			    comboCode : 'BS90',
				holdable: 'hold',
				value: new Date().getFullYear(),
				allowBlank: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				holdable: 'hold',
				allowBlank: false
			},
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({
                            'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                            'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                            'ADD_QUERY2': " AND DIV_CODE = ",
                            'ADD_QUERY3': "))"
                        });   //WHERE절 추카 쿼리
                    }
                }
            })/* ,{
                fieldLabel: '작업기간',
                xtype: 'uniMonthRangefield',
                allowBlank:false,
                startFieldName: 'CON_FR_YYMM',
                endFieldName: 'CON_TO_YYMM'
            } */
        ]
    }); // createSearchForm

    var inoutNoMasterGrid = Unilite.createGrid('s_ryt200ukrv_kdMasterGrid', {     //조회버튼 누르면 나오는 조회창
        layout : 'fit',
        excelTitle: '기술마스터팝업',
        store: inoutNoMasterStore,
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: false
        },
        columns:  [
            { dataIndex: 'COMP_CODE'                     ,  width:100, hidden: true},
            { dataIndex: 'DIV_CODE'                      ,  width:100, hidden: true},
            { dataIndex: 'CUSTOM_CODE'                   ,  width:110},
            { dataIndex: 'CUSTOM_NAME'                   ,  width:200},
            { dataIndex: 'CON_FR_YYMM'                   ,  width:100},
            { dataIndex: 'CON_TO_YYMM'                   ,  width:100},
            { dataIndex: 'GUBUN1'                        ,  width:100},
            { dataIndex: 'GUBUN2'                        ,  width:100},
            { dataIndex: 'GUBUN3'                        ,  width:100},
            { dataIndex: 'MONEY_UNIT'                    ,  width:100},
            { dataIndex: 'RYT_P'                         ,  width:100},
            { dataIndex: 'WORK_YEAR'                      ,  width:100, hidden: true},
            { dataIndex: 'WORK_SEQ'                      ,  width:100, hidden: true},

        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                inoutNoMasterGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                SearchInfoWindow.hide();
                panelResult.setAllFieldsReadOnly(true);
            }
        },
        returnData: function(record)    {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({
                'DIV_CODE'      :record.get('DIV_CODE'),
                'CUSTOM_CODE'   :record.get('CUSTOM_CODE'),
                'CUSTOM_NAME'   :record.get('CUSTOM_NAME'),
                'CON_FR_YYMM'   :inoutNoSearch.getValue('CON_FR_YYMM'),
                'CON_TO_YYMM'   :inoutNoSearch.getValue('CON_TO_YYMM'),
                'GUBUN1'        :record.get('GUBUN1'),
                'GUBUN2'        :record.get('GUBUN2'),
                'GUBUN3'        :record.get('GUBUN3'),
                'MONEY_UNIT'    :record.get('MONEY_UNIT'),
                'WORK_YEAR'   : record.get('WORK_YEAR'),
                'WORK_SEQ'   : record.get('WORK_SEQ'),
            });
        }
    });

    function openSearchInfoWindow() {           //조회버튼 누르면 나오는 조회창
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '기술마스터검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'}, //위치 확인 필요
                items: [inoutNoSearch, inoutNoMasterGrid],
                tbar:  ['->',
                    {
                        itemId : 'saveBtn',
                        text: '조회',
                        handler: function() {
                            inoutNoMasterStore.loadStoreRecords();
                        },
                        disabled: false
                    }, {
                        itemId : 'inoutNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchInfoWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        inoutNoSearch.clearForm();
                        inoutNoMasterGrid.reset();
                    },
                     beforeclose: function( panel, eOpts )  {
                        inoutNoSearch.clearForm();
                        inoutNoMasterGrid.reset();
                    },
                    show: function( panel, eOpts )  {
                        inoutNoSearch.setValue('DIV_CODE'       , panelResult.getValue('DIV_CODE'));
                        inoutNoSearch.setValue('WORK_YEAR'   , panelResult.getValue('WORK_YEAR'));
                        inoutNoSearch.setValue('WORK_SEQ'  , panelResult.getValue('WORK_SEQ'));
                       // inoutNoSearch.setValue('CON_FR_YYMM'    , panelResult.getValue('CON_FR_YYMM'));
                       // inoutNoSearch.setValue('CON_TO_YYMM'    , panelResult.getValue('CON_TO_YYMM'));
                     }
                }
            })
        }
        SearchInfoWindow.center();
        SearchInfoWindow.show();
    };


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
        id  : 's_ryt200ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	var customCode = panelResult.getValue('CUSTOM_CODE');
            if(Ext.isEmpty(customCode)) {
                openSearchInfoWindow()
            } else {
            	if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                }
                directMasterStore.loadStoreRecords();
            }
            UniAppManager.setToolbarButtons(['reset', 'deleteAll'], true);
            UniAppManager.setToolbarButtons(['newData'], false);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
        	var compCode        =   UserInfo.compCode;
            var divCode         =   panelResult.getValue('DIV_CODE');
            var seq             =   directMasterStore.max('SEQ');
                 if(!seq) seq = 1;
                 else seq += 1;
            var gubun2          =   panelResult.getValue('GUBUN2');
            var gubun3          =   panelResult.getValue('GUBUN3');
            var moneyUnit       =   panelResult.getValue('MONEY_UNIT');
            var conFrYymm       =   panelResult.getValue('CON_FR_YYMM');
            var conToYymm       =   panelResult.getValue('CON_TO_YYMM');
            var rytP            =   panelResult.getValue('RYT_P');
            var workYear =  panelResult.getValue('WORK_YEAR');
            var workSeq =  panelResult.getValue('WORK_SEQ');

            var r = {
                COMP_CODE       : compCode,
                DIV_CODE        : divCode,
                SEQ             : seq,
                GUBUN2          : gubun2,
                GUBUN3          : gubun3,
                MONEY_UNIT      : moneyUnit,
                CON_FR_YYMM     : UniDate.getDbDateStr(conFrYymm).substring(0,6),
                CON_TO_YYMM     : UniDate.getDbDateStr(conFrYymm).substring(0,6),
                RYT_P           : rytP,
                WORK_YEAR	:workYear,
                WORK_SEQ:  workSeq
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
        	var record = masterGrid.getSelectedRecord();
            if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
            	masterGrid.deleteSelectedRow();
            }
        },
        onDeleteAllButtonDown: function() {
            var records = directMasterStore.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;

                        if(deletable){
                            masterGrid.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }

        },
        onSaveDataButtonDown: function () {
        	if(panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            } else {
            	if(UniAppManager.app.beforeSaveCheck() == false) {
                    return false;
            	} else {
            		var param= panelResult.getValues();
                    Ext.getBody().mask('로딩중...','loading-indicator');
                    panelResult.getForm().submit({
                         params : param,
                         success : function(form, action) {
                            directMasterStore.saveStore();
                            Ext.getBody().unmask();
                            panelResult.getForm().wasDirty = false;
                            panelResult.resetDirtyStatus();
                            UniAppManager.setToolbarButtons([ 'save', 'newData'], false);
                            UniAppManager.setToolbarButtons([ 'query', 'reset', 'deleteAll'],true);

                            //UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
                         }
                    });
            	}
            }
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('COMP_CODE',UserInfo.compCode);
            panelResult.setValue('CON_FR_YYMM', UniDate.get('startOfYear'));
            panelResult.setValue('CON_TO_YYMM', UniDate.get('today'));
            panelResult.setValue('MONEY_UNIT', 'KRW');
            panelResult.setValue('GUBUN1', 'R');
            panelResult.setValue('GUBUN2', 'Q');
            panelResult.setValue('GUBUN3', 'N');
            panelResult.setValue('WORK_SEQ','1');
            panelResult.setValue('WORK_YEAR', UniDate.get('startOfYear').substring(0,4));
            panelResult.getField('RYT_P', 0.0000);
           // panelResult.getField('RYT_P').setReadOnly(true);
            UniAppManager.setToolbarButtons(['save', 'deleteAll', 'reset'], false);
        },
        beforeSaveCheck: function() {
        	var r = true;
            if(panelResult.getValue('GUBUN1') == 'P') {
                if(Ext.isEmpty(panelResult.getValue('RYT_P')) || panelResult.getValue('RYT_P') == 0) {
                    alert('단가: 필수 입력값 입니다.');
                    r= false;
                }
            }
            return r;
        }
    });
}
</script>