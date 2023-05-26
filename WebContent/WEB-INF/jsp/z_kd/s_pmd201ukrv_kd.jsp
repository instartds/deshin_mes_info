<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmd201ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmd201ukrv_kd"  />             <!-- 사업장 -->
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

	var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmd201ukrv_kdService.selectList',
            update: 's_pmd201ukrv_kdService.updateDetail',
            syncAll: 's_pmd201ukrv_kdService.saveAll'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_pmd201ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업자코드'             ,type: 'string'},
            {name: 'REQ_NO'                 ,text:'의뢰번호'               ,type: 'string', allowBlank: isAutoOrderNum},
            {name: 'REQ_DATE'               ,text:'의뢰일자'               ,type: 'uniDate'},
            {name: 'REQ_TYPE'               ,text:'의뢰구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB12'},
            {name: 'MOLD_CODE'              ,text:'금형코드'               ,type: 'string'},
            {name: 'MOLD_NAME'              ,text:'금형명'                 ,type: 'string'},
            {name: 'OEM_ITEM_CODE'          ,text:'품번'                   ,type: 'string'},
            {name: 'CAR_TYPE'               ,text:'차종'                   ,type: 'string', comboType: 'AU', comboCode: 'WB04'},
            {name: 'PROG_WORK_CODE'         ,text:'공정코드'               ,type: 'string'},
            {name: 'PROG_WORK_NAME'         ,text:'공정명'                 ,type: 'string'},
            {name: 'REPARE_HDATE'           ,text:'요망일'                 ,type: 'uniDate'},
            {name: 'REQ_DEPT_CODE'          ,text:'의뢰부서'               ,type: 'string'},
            {name: 'REQ_DEPT_NAME'          ,text:'의뢰부서명'             ,type: 'string'},
            {name: 'NOW_DEPR'               ,text:'이전 현상각'                 ,type: 'uniQty'},
            {name: 'DATE_BEHV'              ,text:'이전 보수완료일'             ,type: 'uniDate'},
            {name: 'CHK_DEPR'               ,text:'이전 점검상각수'             ,type: 'uniQty'},
            {name: 'REP_DEPT_CODE'          ,text:'처리부서'               ,type: 'string', allowBlank: false},
            {name: 'REP_DEPT_NAME'          ,text:'처리부서명'             ,type: 'string', allowBlank: false},
            {name: 'REP_WORKMAN'            ,text:'작업자'                 ,type: 'string', allowBlank: false},
            {name: 'REP_WORKMAN_NAME'       ,text:'작업자명'                 ,type: 'string'},
//            {name: 'REP_FR_DATE'            ,text:'보수시작일'             ,type: 'uniDate'},
//            {name: 'REP_FR_HHMMSS'          ,text:'시작시간분'             ,type: 'string'},
            {name: 'REP_FR_DATE'            ,text:'일'                   ,type: 'uniDate'},
            {name: 'FR_H'                   , text: '시'                 , type: 'int', maxLength: 2},
            {name: 'FR_M'                   , text: '분'                 , type: 'int', maxLength: 2},
//            {name: 'REP_TO_DATE'            ,text:'보수완료일'             ,type: 'uniDate'},
            {name: 'REP_TO_DATE'            ,text:'일'                   ,type: 'uniDate'},
            {name: 'TO_H'                   , text: '시'                 , type: 'int', maxLength: 2},
            {name: 'TO_M'                   , text: '분'                 , type: 'int', maxLength: 2},
//            {name: 'REP_TO_HHMMSS'          ,text:'완료시간분'             ,type: 'string'},
            {name: 'SUM_REP_WORKTIME'       ,text:'총작업시간'              ,type: 'string'},
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
    var directMasterStore = Unilite.createStore('s_pmd201ukrv_kdMasterStore1',{
        model: 's_pmd201ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
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
                allowBlank:false,
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
            me.uniOpt.inLoading=false;
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
                width: 500,
                readOnly: true
            },{
                fieldLabel: '결과내용',
                xtype: 'textareafield',
                name: 'RST_REMARK',
                height : 50,
                width: 500
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

    var masterGrid = Unilite.createGrid('s_pmd201ukrv_kdmasterGrid', {
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
            { dataIndex: 'COMP_CODE'                          ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                           ,           width: 80, hidden: true},
            { dataIndex: 'REQ_NO'                             ,           width: 120},
            { dataIndex: 'REQ_DATE'                           ,           width: 90},
            { dataIndex: 'STATUS'                             ,           width: 80},
            { dataIndex: 'REQ_TYPE'                           ,           width: 80},
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
                                rtnRecord.set('CAR_TYPE'        , records[0]['OEM_ITEM_CODE']);
                            },
                        scope: this
                        },
                        'onClear': function(type) {
                            var rtnRecord = masterGrid.uniOpt.currentRecord;
                                rtnRecord.set('MOLD_CODE'       , '');
                                rtnRecord.set('MOLD_NAME'       , '');
                                rtnRecord.set('OEM_ITEM_CODE'   , '');
                                rtnRecord.set('CAR_TYPE'        , '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            { dataIndex: 'MOLD_NAME'                          ,           width: 200},
            { dataIndex: 'OEM_ITEM_CODE'                      ,           width: 100},
            { dataIndex: 'CAR_TYPE'                           ,           width: 80},
            { dataIndex: 'PROG_WORK_CODE'                     ,           width: 100},
            { dataIndex: 'PROG_WORK_NAME'                     ,           width: 200},
            { dataIndex: 'REPARE_HDATE'                       ,           width: 80},
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
                      }
                    }
                })
            },
            { dataIndex: 'REQ_DEPT_NAME'                      ,           width: 200,
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
                      }
                    }
                })
            },
            { dataIndex: 'NOW_DEPR'                     ,           width: 130},
            { dataIndex: 'DATE_BEHV'                    ,           width: 140},
            { dataIndex: 'CHK_DEPR'                     ,           width: 130},
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
            { dataIndex: 'REP_DEPT_NAME'                      ,           width: 200,
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
            { dataIndex: 'REP_WORKMAN'                        ,           width: 100,
            	'editor': Unilite.popup('Employee_G',{
                    autoPopup: true,
                    textFieldName:'PERSON_NUMB',
					DBtextFieldName: 'PERSON_NUMB',
                    listeners: {
                    	'onSelected': {
	                        fn: function(records, type) {
	                            var grdRecord = masterGrid.uniOpt.currentRecord;
	                            grdRecord.set('REP_WORKMAN',records[0]['PERSON_NUMB']);
	                            grdRecord.set('REP_WORKMAN_NAME',records[0]['NAME']);
	                            grdRecord.set('REP_DEPT_CODE',records[0]['DEPT_CODE']);
	                            grdRecord.set('REP_DEPT_NAME',records[0]['DEPT_NAME']);


	                        },
                        	scope: this
						},
						'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('REP_WORKMAN','');
                            grdRecord.set('REP_WORKMAN_NAME','');
                            grdRecord.set('REP_DEPT_CODE','');
                            grdRecord.set('REP_DEPT_NAME','');
						}
					}
                })
            },
            { dataIndex: 'REP_WORKMAN_NAME'                        ,           width: 100},
            {text: '보수시작',
                columns: [
                    {dataIndex: 'REP_FR_DATE'       , width: 90/*, editor:
                        {
                            xtype: 'datefield',
//                            allowBlank: false,
                            format: 'Y/m/d'
                        }
                    */},
                    {dataIndex: 'FR_H'            , width: 50, align: 'right'},
                    {dataIndex: 'FR_M'            , width: 50, align: 'right'}
                ]
            },
            {text: '보수완료',
                columns: [
                    {dataIndex: 'REP_TO_DATE'       , width: 90/*, editor:
                        {
                            xtype: 'datefield',
//                            allowBlank: false,
                            format: 'Y/m/d'
                        }*/
                    },
                    {dataIndex: 'TO_H'              , width: 50, align: 'right'},
                    {dataIndex: 'TO_M'              , width: 50, align: 'right'}
                ]
            },
//            { dataIndex: 'REP_FR_DATE'                        ,           width: 80},
//            { dataIndex: 'REP_FR_HHMMSS'                      ,           width: 80},
//            { dataIndex: 'REP_TO_DATE'                        ,           width: 80},
//            { dataIndex: 'REP_TO_HHMMSS'                      ,           width: 80},
            { dataIndex: 'SUM_REP_WORKTIME'                   ,           width: 100, align : 'right'},
            { dataIndex: 'REP_CODE'                           ,           width: 80},
            { dataIndex: 'REQ_REMARK'                         ,           width: 80, hidden: true},
            { dataIndex: 'RST_REMARK'                         ,           width: 80, hidden: true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		if(UniUtils.indexOf(e.field, ['STATUS'])) {
        			return true;
        		}
            	else if(UniUtils.indexOf(e.field, ['REP_DEPT_CODE', 'REP_FR_DATE', 'REP_TO_DATE', 'REP_WORKMAN',
            			                       'REP_FR_HMMSS', 'REP_TO_HMMSS', 'REP_CODE', 'FR_H', 'FR_M', 'TO_H', 'TO_M'])) {
                    var record = masterGrid.getSelectedRecord();
                    if(record.get('STATUS') == '3') {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return false;
                }
            },
            selectionchange:function( model1, selected, eOpts ){
                inputTable.loadForm(selected);
            }, edit: function(editor, e) {
                var fieldName = e.field;
                var num_check = /[0-9]/;
                if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('_M') != -1) {
                    if (!num_check.test(e.value)) {
                            Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
                            e.record.set(fieldName, e.originalValue);
                            return false;
                    }
                    if (fieldName.indexOf('_H') != -1) {
                        if (parseInt(e.value) > 24 || parseInt(e.value) < 0) {
                            Ext.Msg.alert('확인', '정확한 시를 입력하십시오.');
                            e.record.set(fieldName, e.originalValue);
                            return false;
                        }
                    } else {
                        if (parseInt(e.value) > 59 || parseInt(e.value) < 0) {
                            Ext.Msg.alert('확인', '정확한 분을 입력하십시오.');
                            e.record.set(fieldName, e.originalValue);
                            return false;
                        }
                    }
                }
                if(fieldName == 'REP_FR_DATE'){
                    var newValue = e.value;

                    var frDate = parseInt(UniDate.getDbDateStr(newValue));
                    var toDate = parseInt(UniDate.getDbDateStr(e.record.get('REP_TO_DATE')));
                    if(newValue) {
                        if (frDate > toDate) {
                            alert('보수시작일이 보수완료일보다 클 수 없습니다.');
                            e.record.set('REP_TO_DATE', '');
                            return false;
                        }
                    }

                     if(Ext.isEmpty(newValue)) {
                        e.record.set('FR_H', '');
                        e.record.set('FR_M', '');
                        e.record.set('REP_TO_DATE', '');
                        e.record.set('TO_H', '');
                        e.record.set('TO_M', '');
                        e.record.set('SUM_REP_WORKTIME', '');
                    }
                }

                if(fieldName == 'REP_TO_DATE'){
                    var newValue = e.value;

                    var frDate = parseInt(UniDate.getDbDateStr(e.record.get('REP_FR_DATE')));
                    var toDate = parseInt(UniDate.getDbDateStr(newValue));

                    if(newValue) {
                        if (frDate > toDate) {
                            alert('보수완료일이 보수시작일보다 작을 수 없습니다.');
                            e.record.set('REP_TO_DATE', '');
                            return false;
                        }
                    }

                     if(Ext.isEmpty(newValue)) {
                        e.record.set('SUM_REP_WORKTIME', '');
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
        id  : 's_pmd201ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
//            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['newData','deleteAll'],false);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            this.setDefault();
        },
        onSaveDataButtonDown: function () {
        	if (!checkValidaionGrid()) {
                return false;
            }
            directMasterStore.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('REQ_DATE_TO', UniDate.get('today'));
        }
    });

    Unilite.createValidator('validator01', {
        store: directMasterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "REP_FR_DATE" :

//                    var frDate = parseInt(UniDate.getDbDateStr(newValue));
//                    var toDate = parseInt(UniDate.getDbDateStr(record.get('REP_TO_DATE')));
//
//                    if (frDate > toDate) {
//                        alert('보수시작일이 보수완료일보다 클 수 없습니다.');
//                        record.set('REP_FR_DATE', '');
//                        break;
//                    }

                    if(Ext.isEmpty(newValue)) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else if(Ext.isEmpty(record.get('REP_TO_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else {

                        var param = {
                              'REP_FR_DATE': UniDate.getDbDateStr(newValue)
                            , 'FR_H': record.get('FR_H')
                            , 'FR_M': record.get('FR_M')
                            , 'REP_TO_DATE': UniDate.getDbDateStr(record.get('REP_TO_DATE'))
                            , 'TO_H': record.get('TO_H')
                            , 'TO_M': record.get('TO_M')
                        };
                        s_pmd201ukrv_kdService.calcMinute(param, function(provider, response) {
                            if(!Ext.isEmpty(provider)) {
                                record.set('SUM_REP_WORKTIME', provider[0].CAL_MINUTE);
                            }
                        });
                    }

                    break;

                case "FR_H" :
                    if(Ext.isEmpty(record.get('REP_FR_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else if(Ext.isEmpty(record.get('REP_TO_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else {

                        var param = {
                              'REP_FR_DATE': UniDate.getDbDateStr(record.get('REP_FR_DATE'))
                            , 'FR_H': newValue
                            , 'FR_M': record.get('FR_M')
                            , 'REP_TO_DATE': UniDate.getDbDateStr(record.get('REP_TO_DATE'))
                            , 'TO_H': record.get('TO_H')
                            , 'TO_M': record.get('TO_M')
                        };
                        s_pmd201ukrv_kdService.calcMinute(param, function(provider, response) {
                            if(!Ext.isEmpty(provider)) {
                                record.set('SUM_REP_WORKTIME', provider[0].CAL_MINUTE);
                            }
                        });
                    }

                    break;

                case "FR_M" :
                    if(Ext.isEmpty(record.get('REP_FR_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else if(Ext.isEmpty(record.get('REP_TO_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else {

                        var param = {
                              'REP_FR_DATE': UniDate.getDbDateStr(record.get('REP_FR_DATE'))
                            , 'FR_H': record.get('FR_H')
                            , 'FR_M': newValue
                            , 'REP_TO_DATE': UniDate.getDbDateStr(record.get('REP_TO_DATE'))
                            , 'TO_H': record.get('TO_H')
                            , 'TO_M': record.get('TO_M')
                        };
                        s_pmd201ukrv_kdService.calcMinute(param, function(provider, response) {
                            if(!Ext.isEmpty(provider)) {
                                record.set('SUM_REP_WORKTIME', provider[0].CAL_MINUTE);
                            }
                        });
                    }

                    break;

                case "REP_TO_DATE" :

//                    var frDate = parseInt(UniDate.getDbDateStr(record.get('REP_FR_DATE')));
//                    var toDate = parseInt(UniDate.getDbDateStr(newValue));
//
//                    if (frDate > toDate) {
//                        alert('보수완료일이 보수시작일보다 작을 수 없습니다.');
//                        record.set('REP_TO_DATE', '');
//                        break;
//                    }

                    if(Ext.isEmpty(record.get('REP_FR_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else if(Ext.isEmpty(newValue)) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else {

                        var param = {
                              'REP_FR_DATE': UniDate.getDbDateStr(record.get('REP_FR_DATE'))
                            , 'FR_H': record.get('FR_H')
                            , 'FR_M': record.get('FR_M')
                            , 'REP_TO_DATE': UniDate.getDbDateStr(newValue)
                            , 'TO_H': record.get('TO_H')
                            , 'TO_M': record.get('TO_M')
                        };
                        s_pmd201ukrv_kdService.calcMinute(param, function(provider, response) {
                            if(!Ext.isEmpty(provider)) {
                                record.set('SUM_REP_WORKTIME', provider[0].CAL_MINUTE);
                            }
                        });
                    }

//                    if(newValue) {
//                        record.set('STATUS','2');
//                    } else if(record.set('REP_TO_DATE','')) {
//                        record.set('STATUS','');
//                    }

                    break;

                case "TO_H" :
                    if(Ext.isEmpty(record.get('REP_FR_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else if(Ext.isEmpty(record.get('REP_TO_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else {

                        var param = {
                              'REP_FR_DATE': UniDate.getDbDateStr(record.get('REP_FR_DATE'))
                            , 'FR_H': record.get('FR_H')
                            , 'FR_M': record.get('FR_M')
                            , 'REP_TO_DATE': UniDate.getDbDateStr(record.get('REP_TO_DATE'))
                            , 'TO_H': newValue
                            , 'TO_M': record.get('TO_M')
                        };
                        s_pmd201ukrv_kdService.calcMinute(param, function(provider, response) {
                            if(!Ext.isEmpty(provider)) {
                                record.set('SUM_REP_WORKTIME', provider[0].CAL_MINUTE);
                            }
                        });
                    }

                    break;

                case "TO_M" :
                    if(Ext.isEmpty(record.get('REP_FR_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else if(Ext.isEmpty(record.get('REP_TO_DATE'))) {
                        record.set('SUM_REP_WORKTIME', '');
                    } else {

                        var param = {
                              'REP_FR_DATE': UniDate.getDbDateStr(record.get('REP_FR_DATE'))
                            , 'FR_H': record.get('FR_H')
                            , 'FR_M': record.get('FR_M')
                            , 'REP_TO_DATE': UniDate.getDbDateStr(record.get('REP_TO_DATE'))
                            , 'TO_H': record.get('TO_H')
                            , 'TO_M': newValue
                        };
                        s_pmd201ukrv_kdService.calcMinute(param, function(provider, response) {
                            if(!Ext.isEmpty(provider)) {
                                record.set('SUM_REP_WORKTIME', provider[0].CAL_MINUTE);
                            }
                        });
                    }

                    break;

            }
            return rv;
        }
    })

    // 쿼리 조건에 이용하기 위하여 근태년월의 형식을 변경함
    function dateChange(value) {
        if (value == null || value == '') return '';
        var year = value.getFullYear();
        var mon = value.getMonth() + 1;
        var day = value.getDate();
        return year + '' + (mon >= 10 ? mon : '0' + mon) + '' + day;
    }

    // insert, update 전 입력값  검증(시작/종료 시간)
    function checkValidaionGrid() {
         // 시작시간/종료시간 검증
		var rightTimeInputed = true;
         // 필수 입력항목 입력 여부 검증
         var necessaryFieldInputed = true;
         var MsgTitle = '확인';
         var MsgErr01 = '시작시간이 종료 시간 보다 클 수 없습니다.';
         var MsgErr02 = '은(는) 필수 입력 항목 입니다.';

//         var selectedModel = masterGrid.getStore().getRange();
         var records = directMasterStore.data.items;
         Ext.each(records, function(record,i){
			if(record.dirty == true){
	         	var date_fr = parseInt(dateChange(record.data.REP_FR_DATE));
	            var date_to = parseInt(dateChange(record.data.REP_TO_DATE));
	            var fr_time = parseInt(record.data.FR_H*60 + record.data.FR_M);
	            var to_time = parseInt(record.data.TO_H*60 + record.data.TO_M);

	             if ( (date_fr != '' && date_to == '') || (date_fr == '' && date_to != '') ) {
	                 rightTimeInputed = false;
	                 return;
	             } else if (date_fr != '' && date_to != '') {
	                 if ((date_fr > date_to)) {
	                     rightTimeInputed = false;
	                     return;
	                 } else {
	                    if (date_fr == date_to && fr_time >= to_time) {
	                        rightTimeInputed = false;
	                        return;
	                    }
	                 }
	             }
             }
         });

         if (!rightTimeInputed) {
             Ext.Msg.alert(MsgTitle, MsgErr01);
             return rightTimeInputed;
         }
         if (!necessaryFieldInputed) {
             Ext.Msg.alert(MsgTitle, MsgErr02);
             return necessaryFieldInputed;
         }
         return true;
     }
};
</script>