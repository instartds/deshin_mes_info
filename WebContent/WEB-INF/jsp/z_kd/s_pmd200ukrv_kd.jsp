<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmd200ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmd200ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB08" /> <!--금형구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB09" /> <!--금형구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB10" /> <!--위치상태-->
    <t:ExtComboStore comboType="AU" comboCode="WB11" /> <!--수금구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부-->
    <t:ExtComboStore comboType="AU" comboCode="WB04" /> <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WB12" /> <!--의뢰구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB13" /> <!--보수코드-->
    <t:ExtComboStore comboType="AU" comboCode="WB14" /> <!--진행구분-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};

function appMain() {

    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmd200ukrv_kdService.selectList',
            update: 's_pmd200ukrv_kdService.updateDetail',
            create: 's_pmd200ukrv_kdService.insertDetail',
            destroy: 's_pmd200ukrv_kdService.deleteDetail',
            syncAll: 's_pmd200ukrv_kdService.saveAll'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_pmd200ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업자코드'             ,type: 'string'},
            {name: 'REQ_NO'                 ,text:'의뢰번호'               ,type: 'string', allowBlank: isAutoOrderNum},
            {name: 'REQ_DATE'               ,text:'의뢰일자'               ,type: 'uniDate', allowBlank : false},
            {name: 'REQ_TYPE'               ,text:'의뢰구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB12', allowBlank : false},
            {name: 'MOLD_CODE'              ,text:'금형코드'               ,type: 'string', allowBlank : false},
            {name: 'MOLD_NAME'              ,text:'금형명'                 ,type: 'string'},
            {name: 'MOLD_MTL'              ,text:'금형소재'                 ,type: 'string', comboType: 'AU', comboCode: 'I803'},
            {name: 'MOLD_STRC'              ,text:'금형구조'                 ,type: 'string'},
            
            {name: 'OEM_ITEM_CODE'          ,text:'품번'                   ,type: 'string'},
            {name: 'CAR_TYPE'               ,text:'차종'                   ,type: 'string', comboType: 'AU', comboCode: 'WB04'},
            {name: 'PROG_WORK_CODE'         ,text:'공정코드'               ,type: 'string'},
            {name: 'PROG_WORK_NAME'         ,text:'공정명'                 ,type: 'string'},
            {name: 'REPARE_HDATE'           ,text:'완료요청일'              ,type: 'uniDate', allowBlank : false},
            {name: 'REQ_DEPT_CODE'          ,text:'의뢰부서'               ,type: 'string', allowBlank : false},
            {name: 'REQ_DEPT_NAME'          ,text:'의뢰부서명'             ,type: 'string', allowBlank : false},
            {name: 'REQ_WORKMAN'            ,text:'의뢰자'                 ,type: 'string', allowBlank : false},
            {name: 'REQ_WORKMAN_NAME'       ,text:'의뢰자명'                 ,type: 'string'},
            {name: 'NOW_DEPR'               ,text:'이전 현상각'                 ,type: 'uniQty'},
            {name: 'DATE_BEHV'              ,text:'이전 보수완료일'             ,type: 'uniDate'},
            {name: 'CHK_DEPR'               ,text:'이전 점검상각수'             ,type: 'uniQty'},
            {name: 'REP_DEPT_CODE'          ,text:'처리부서'               ,type: 'string'},
            {name: 'REP_DEPT_NAME'          ,text:'처리부서명'             ,type: 'string'},
            {name: 'REP_WORKMAN'            ,text:'작업자'                 ,type: 'string'},
            {name: 'REP_WORKMAN_NAME'       ,text:'작업자명'                 ,type: 'string'},
            {name: 'REP_FR_DATE'            ,text:'보수시작일'             ,type: 'uniDate'},
            {name: 'REP_FR_HHMMSS'          ,text:'시작시간분'             ,type: 'string'},
            {name: 'REP_TO_DATE'            ,text:'보수완료일'             ,type: 'uniDate'},
            {name: 'REP_TO_HHMMSS'          ,text:'완료시간분'             ,type: 'string'},
            {name: 'SUM_REP_WORKTIME'       ,text:'총작업시간'             ,type: 'string'},
            {name: 'REP_CODE'               ,text:'보수코드'               ,type: 'string', comboType: 'AU', comboCode: 'WB13'},
            {name: 'STATUS'                 ,text:'진행구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB14'},
            {name: 'REQ_REMARK'             ,text:'의뢰내용'               ,type: 'string'},
            {name: 'RST_REMARK'             ,text:'결과내용'               ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_pmd200ukrv_kdMasterStore1',{
        model: 's_pmd200ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param = panelResult.getValues();
            this.load({
                  params : param/* ,
               // NEW ADD
                callback: function(records, operation, success){
                    console.log(records);
                    if(success){
                        if(masterGrid.getStore().getCount() == 0){
                            Ext.getCmp('GW').setDisabled(true);
                        }else if(masterGrid.getStore().getCount() != 0){
                            UniBase.fnGwBtnControl('GW',directMasterStore.data.items[0].data.GW_FLAG);
                        }
                    }
                }
                //END */
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
                        if(directMasterStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        id: 'RESULT_SEARCH',
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank : false,
                value: UserInfo.divCode
            },
            Unilite.popup('DEPT', {
                    fieldLabel: '부서',
                    valueFieldName: 'REQ_DEPT_CODE',
                    textFieldName: 'REQ_DEPT_NAME'
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '의뢰번호',
                name:'REQ_NO',
                xtype: 'uniTextfield',
//                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold'
            },{
                fieldLabel: '의뢰일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'REQ_DATE_FR',
                endFieldName: 'REQ_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
            Unilite.popup('MOLD_CODE',{
                fieldLabel: '금형',
                valueFieldName:'MOLD_CODE',
                textFieldName:'MOLD_NAME',
                valueFieldWidth: 120,
                textFieldWidth: 200,
                autoPopup: true,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                    }
                }
            })
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

    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type : 'uniTable', columns : 2},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
        region: 'center',
        masterGrid: masterGrid,
        items: [{
                fieldLabel: '의뢰내용',
                xtype: 'textareafield',
                name: 'REQ_REMARK',
                height : 50,
                width: 500
            },{
                fieldLabel: '결과내용',
                xtype: 'textareafield',
                name: 'RST_REMARK',
                height : 50,
                width: 500,
                readOnly: true
            }],
            loadForm: function(record)  {
                // window 오픈시 form에 Data load
                var count = masterGrid.getStore().getCount();
                if(count > 0) {
                    this.reset();
                    this.setActiveRecord(record[0] || null);
                    this.resetDirtyStatus();
                }
            }
//          ,api: {
//              submit: 'afd600ukrService.syncMaster'
//          }
    });

    var masterGrid = Unilite.createGrid('s_pmd200ukrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        selModel: 'rowmodel',
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
                xtype : 'button',
                text:'기안',
                id: 'printBtn',
                handler: function() {
                    var masterRecord = masterGrid.getSelectedRecord();
                    var count = masterGrid.getStore().getCount();
                    var param = panelResult.getValues();

                    if(count == 0) {
                        alert('기안 할 항목을 선택 후 진행하십시오.');
                        return false;
                    } else {
                        UniAppManager.app.requestApprove();
                    }
                }
            }
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'                          ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                           ,           width: 80, hidden: true},
            { dataIndex: 'REQ_NO'                             ,           width: 120},
            { dataIndex: 'REQ_DATE'                           ,           width: 90},
            { dataIndex: 'STATUS'                             ,           width: 90},
            { dataIndex: 'REQ_TYPE'                           ,           width: 90},
            { dataIndex: 'MOLD_CODE'                          ,           width: 120,
                editor: Unilite.popup('MOLD_CODE_G', {
                        textFieldName: 'MOLD_CODE',
                        DBtextFieldName: 'MOLD_CODE',
                        autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                    var rtnRecord = masterGrid.uniOpt.currentRecord;
                                    rtnRecord.set('MOLD_CODE'       , records[0]['MOLD_CODE']);
                                    rtnRecord.set('MOLD_NAME'       , records[0]['MOLD_NAME']);
                                    rtnRecord.set('OEM_ITEM_CODE'   , records[0]['OEM_ITEM_CODE']);
                                    rtnRecord.set('CAR_TYPE'        , records[0]['CAR_TYPE']);
                                    
                                    rtnRecord.set('MOLD_MTL'        , records[0]['MOLD_MTL']);
                                    rtnRecord.set('MOLD_STRC'        , records[0]['MOLD_STRC']);

//            edit: function(editor, e) { console.log(e);
                        var param = {
                              'COMP_CODE': UserInfo.compCode
                            , 'DIV_CODE' : panelResult.getValue('DIV_CODE')
                            , 'MOLD_CODE': rtnRecord.get('MOLD_CODE')
                        };
                        s_pmd200ukrv_kdService.selectMoldDetail(param, function(provider, response) {
                            if(!Ext.isEmpty(provider)) {
                                if ((provider[0].ST_LOCATION != '1') && (provider[0].ST_LOCATION != '4')) {
                                    alert('해당 금형 위치 확인바랍니다. 금형코드 : ' + rtnRecord.get('MOLD_CODE'));
                                    rtnRecord.set('MOLD_CODE',          '');
                                    rtnRecord.set('MOLD_NAME',          '');
                                    rtnRecord.set('OEM_ITEM_CODE',      '');
                                    rtnRecord.set('CAR_TYPE',           '');
                                    rtnRecord.set('PROG_WORK_CODE',     '');
                                    rtnRecord.set('PROG_WORK_NAME',     '');
                                    rtnRecord.set('NOW_DEPR',           '');
                                    rtnRecord.set('DATE_BEHV',          '');
                                    rtnRecord.set('CHK_DEPR',           '');
                                    return false;
                                }
                                else {
                                    rtnRecord.set('PROG_WORK_CODE',     provider[0].PROG_WORK_CODE);
                                    rtnRecord.set('PROG_WORK_NAME',     provider[0].PROG_WORK_NAME);
                                    rtnRecord.set('NOW_DEPR',           provider[0].NOW_DEPR);
                                    rtnRecord.set('DATE_BEHV',          provider[0].DATE_BEHV);
                                    rtnRecord.set('CHK_DEPR',           provider[0].CHK_DEPR);
                                }
                            }
                        });
//            },
                                },
                            scope: this
                            },
                            'onClear': function(type) {
                                var rtnRecord = masterGrid.uniOpt.currentRecord;
                                    rtnRecord.set('MOLD_CODE'       , '');
                                    rtnRecord.set('MOLD_NAME'       , '');
                                    rtnRecord.set('OEM_ITEM_CODE'   , '');
                                    rtnRecord.set('CAR_TYPE'        , '');
                                    rtnRecord.set('PROG_WORK_CODE',     '');
                                    rtnRecord.set('PROG_WORK_NAME',     '');
                            },
                            applyextparam: function(popup){
                                popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            }
                    }
                })
            },
            { dataIndex: 'MOLD_NAME'                          ,           width: 180},
			{dataIndex: 'MOLD_MTL' 	, width: 80},
			{dataIndex: 'MOLD_STRC' 	, width: 100},
            { dataIndex: 'OEM_ITEM_CODE'                      ,           width: 100},
            { dataIndex: 'CAR_TYPE'                           ,           width: 80},
            { dataIndex: 'PROG_WORK_CODE'                     ,           width: 100},
            { dataIndex: 'PROG_WORK_NAME'                     ,           width: 180},
            { dataIndex: 'REPARE_HDATE'                       ,           width: 100},
            { dataIndex: 'REQ_DEPT_CODE'                      ,           width: 100,
                'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'REQ_DEPT_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REQ_DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('REQ_DEPT_NAME',records[0]['TREE_NAME']);

                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REQ_DEPT_CODE','');
                            grdRecord.set('REQ_DEPT_NAME','');
                      },
                      applyextparam: function(popup){
                      	        var grdRecord = masterGrid.getSelectedRecord();
                                popup.setExtParam({'TREE_NAME': grdRecord.get('REQ_DEPT_CODE')});
                      }
                    }
                })
            },
            { dataIndex: 'REQ_DEPT_NAME'                      ,           width: 180,
              'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REQ_DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('REQ_DEPT_NAME',records[0]['TREE_NAME']);

                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REQ_DEPT_CODE','');
                            grdRecord.set('REQ_DEPT_NAME','');
                      },
                      applyextparam: function(popup){
                                var grdRecord = masterGrid.getSelectedRecord();
                                popup.setExtParam({'TREE_NAME': grdRecord.get('REQ_DEPT_NAME')});
                      }
                    }
                })
            },
            { dataIndex: 'REQ_WORKMAN'                        ,           width: 100,
            	'editor': Unilite.popup('Employee_G',{
                    autoPopup: true,
                    textFieldName:'PERSON_NUMB',
					DBtextFieldName: 'PERSON_NUMB',
                    listeners: {
                    	'onSelected': {
	                        fn: function(records, type) {
	                            var grdRecord = masterGrid.uniOpt.currentRecord;
	                            grdRecord.set('REQ_WORKMAN',records[0]['PERSON_NUMB']);
	                            grdRecord.set('REQ_WORKMAN_NAME',records[0]['NAME']);
	                            grdRecord.set('REQ_DEPT_CODE',records[0]['DEPT_CODE']);
	                            grdRecord.set('REQ_DEPT_NAME',records[0]['DEPT_NAME']);

	                        },
                        	scope: this
						},
						'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REQ_WORKMAN','');
                            grdRecord.set('REQ_WORKMAN_NAME','');
                            grdRecord.set('REQ_DEPT_CODE','');
                            grdRecord.set('REQ_DEPT_NAME','');
						}
					}
                })
            },
            { dataIndex: 'REQ_WORKMAN_NAME'                        ,           width: 100},
            { dataIndex: 'NOW_DEPR'                        ,           width: 130},
            { dataIndex: 'DATE_BEHV'                        ,           width: 110},
            { dataIndex: 'CHK_DEPR'                        ,           width: 130},
            { dataIndex: 'REP_DEPT_CODE'                      ,           width: 100,
                'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'REP_DEPT_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REP_DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('REP_DEPT_NAME',records[0]['TREE_NAME']);

                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REP_DEPT_CODE','');
                            grdRecord.set('REP_DEPT_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'REP_DEPT_NAME'                      ,           width: 180,
              'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REP_DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('REP_DEPT_NAME',records[0]['TREE_NAME']);

                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REP_DEPT_CODE','');
                            grdRecord.set('REP_DEPT_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'REP_WORKMAN'                        ,           width: 100},
            { dataIndex: 'REP_WORKMAN_NAME'                   ,           width: 100},
            { dataIndex: 'REP_FR_DATE'                        ,           width: 90},
            { dataIndex: 'REP_FR_HHMMSS'                      ,           width: 80, align : 'center'},
            { dataIndex: 'REP_TO_DATE'                        ,           width: 90},
            { dataIndex: 'REP_TO_HHMMSS'                      ,           width: 80, align : 'center'},
            { dataIndex: 'SUM_REP_WORKTIME'                   ,           width: 100},
            { dataIndex: 'REP_CODE'                           ,           width: 100},
            { dataIndex: 'REQ_REMARK'                         ,           width: 80, hidden: true},
            { dataIndex: 'RST_REMARK'                         ,           width: 80, hidden: true}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['REQ_DATE', 'REQ_TYPE', 'MOLD_CODE', 'REPARE_HDATE', 'REQ_DEPT_CODE', 'REQ_WORKMAN', 'REP_CODE']))
                    {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(e.record.data.STATUS != '1') {
                        return false;
                    } else {
                        if(UniUtils.indexOf(e.field, ['REQ_DATE', 'REQ_TYPE', 'REPARE_HDATE', 'REQ_DEPT_CODE', 'REQ_WORKMAN', 'REP_CODE']))
                        {
                            return true;
                        } else {
                            return false;
                        }
                    }
                }
            },
            /*edit: function(editor, e) { console.log(e);
                var fieldName = e.field;
                if(e.value == e.originalValue) return false;
                if(fieldName == 'MOLD_CODE'){
                    var newValue = e.value;
                    if(newValue) {
                        var param = {
                              'COMP_CODE': UserInfo.compCode
                            , 'MOLD_CODE': e.record.get('MOLD_CODE')
                        };
                        s_pmd200ukrv_kdService.selectMoldDetail(param, function(provider, response)   {
                            if(!Ext.isEmpty(provider)) {
                                e.record.set('OEM_ITEM_CODE',   provider[0].OEM_ITEM_CODE);
                                e.record.set('CAR_TYPE',        provider[0].CAR_TYPE);
                                e.record.set('PROG_WORK_CODE',  provider[0].PROG_WORK_CODE);
                                e.record.set('PROG_WORK_NAME',  provider[0].PROG_WORK_NAME);
                                e.record.set('NOW_DEPR',        provider[0].NOW_DEPR);
                                e.record.set('DATE_BEHV',       provider[0].DATE_BEHV);
                                e.record.set('CHK_DEPR',        provider[0].CHK_DEPR);
                            }
                            param2 = {
                                  'COMP_CODE': UserInfo.compCode
                                , 'MOLD_CODE': e.record.get('MOLD_CODE')
                            }
                        });
                    }
                }
            },*/
            selectionchange:function( model1, selected, eOpts ){
                inputTable.loadForm(selected);
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
                    panelResult,
                    {
                        region : 'south',
                        xtype : 'container',
                        highth: 20,
                        layout : 'fit',
                        items : [ inputTable ]
                    }
                ]
            }
        ],
        id  : 's_pmd200ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'], false);
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
            panelResult.clearForm();
            masterGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
            var compCode        =   UserInfo.compCode;
            var divCode         =   panelResult.getValue('DIV_CODE');
            var reqType         =   '1';
            var reqDate         =   UniDate.get('today');
            var repareHdate     =   UniDate.get('today');
            var reqDeptCode     =   panelResult.getValue('REQ_DEPT_CODE');
            var reqDeptName     =   panelResult.getValue('REQ_DEPT_NAME');
            var moldCode        =   panelResult.getValue('MOLD_CODE');
            var moldName        =   panelResult.getValue('MOLD_NAME');
            var oemItemCode     =   panelResult.getValue('OEM_ITEM_CODE');
            var repCode         =   '01';
//            var reqNo           =   panelResult.getValue('REQ_NO');

            var r = {
                COMP_CODE:          compCode,
                DIV_CODE:           divCode,
                REQ_TYPE:           reqType,
                REQ_DATE:           reqDate,
                REPARE_HDATE:       repareHdate,
                REQ_DEPT_CODE:      reqDeptCode,
                REQ_DEPT_NAME:      reqDeptName,
                REP_CODE:           repCode,
                STATUS:             '1'
//                MOLD_CODE:          moldCode,
//                MOLD_NAME:          moldName,
//                OEM_ITEM_CODE:      oemItemCode,
//                REQ_NO:             reqNo
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
            var record = masterGrid.getSelectedRecord();

            if(record.phantom === true) {
                masterGrid.deleteSelectedRow();
            } else {
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    if(record.get('STATUS') != '1') {
                        alert("진행구분이 '의뢰'가 아닌 경우 수정, 삭제가 불가능합니다.");
                    } else {
                        masterGrid.deleteSelectedRow();
                    }
                }
            }
        },
        onSaveDataButtonDown: function () {
            directMasterStore.saveStore();
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var record      = masterGrid.getSelectedRecord();
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var reqNo       = record.data['REQ_NO'];
            var userId      = UserInfo.userID;
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_PMD200UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + reqNo + "'";
            var spCall      = encodeURIComponent(spText);

/* //            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_pmd200ukrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_str900skrv2_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit(); */
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_pmd200ukrv_kd&draft_no=" + '0' + "&sp=" + spCall;
            UniBase.fnGw_Call(gwurl,frm,'');
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('REQ_DATE_TO', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save'], false);
        }
    });
}
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>