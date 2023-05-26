<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sva120ukrv"  >
    <t:ExtComboStore comboType="BOR120" pgmId="sva120ukrv"  />          <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
    <t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
    <t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 출고유형 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell {
background-color: #fcfac5;
}
</style>
<script type="text/javascript" >


/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/


function appMain() {
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'sva120ukrvService.selectList',
            update: 'sva120ukrvService.updateDetail',
            create: 'sva120ukrvService.insertDetail',
            //destroy: 'sva120ukrvService.deleteDetail',
            syncAll: 'sva120ukrvService.saveAll'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('Sva120ukrvModel', {
        fields: [
            {name: 'COMP_CODE'        ,text: '법인코드'             ,type: 'string'},
            {name: 'POS_NO'           ,text: '코드'           ,type: 'string'},
            {name: 'POS_NAME'         ,text: '명'             ,type: 'string'},
            {name: 'LOCATION'         ,text: '위치'                 ,type: 'string'},
            {name: 'SALE_Q'           ,text: '현금'     ,type: 'uniQty'},
            {name: 'CARD_SALE_Q'      ,text: '카드'     ,type: 'uniQty'},
            {name: 'SALE_O'           ,text: '현금'       ,type: 'uniPrice'},
            {name: 'CARD_SALE_O'      ,text: '카드'       ,type: 'uniPrice'},
            {name: 'COLLECT_AMT'      ,text: '현금'         ,type: 'uniPrice'},
            {name: 'CARD_COLLECT_AMT' ,text: '카드'         ,type: 'uniPrice'},
            {name: 'LESS_O'           ,text: '과부족'               ,type: 'uniPrice'},
            {name: 'BILL_NUM'         ,text: '현금'       ,type: 'string'},
            {name: 'CARD_BILL_NUM'    ,text: '카드'       ,type: 'string'},
            {name: 'COLLECT_NUM'      ,text: '수금번호(현금)'       ,type: 'string'},
            {name: 'COLLECT_SEQ'      ,text: '수금순번(현금)'       ,type: 'int'},
            {name: 'CARD_COLLECT_NUM' ,text: '수금번호(카드)'       ,type: 'string'},
            {name: 'CARD_COLLECT_SEQ' ,text: '수금순번(카드)'       ,type: 'int'},
            {name: 'REMARK'           ,text: '비고'                 ,type: 'string'}
        ]
    });     //End of Unilite.defineModel('Sva120ukrvModel', {

    /**
     * Store 정의(Service 정의)
     * @type
     */

    var directMasterStore1 = Unilite.createStore('sva120ukrvMasterStore1',{
            model: 'Sva120ukrvModel',
            uniOpt: {
                isMaster: true,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable: false,           // 삭제 가능 여부
                useNavi: false              // prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
         /*   proxy: {
                type: 'direct',
                api: {
                       read: 'sva120ukrvService.selectMasterList',
                       syncAll: 'sva120ukrvService.syncAll'
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
            loadStoreRecords: function()    {
                var param= masterForm.getValues();
                var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                var deptCode = UserInfo.deptCode;   //부서코드
                if(authoInfo == "5" && Ext.isEmpty(masterForm.getValue('DEPT_CODE'))){
                    param.DEPT_CODE = deptCode;
                }
                console.log( param );
                this.load({
                    params : param
                });
            },
            saveStore : function()  {
                var paramMaster= masterForm.getValues();
                var inValidRecs = this.getInvalidRecords();

                var rv = true;

                if(inValidRecs.length == 0 )    {
                    config = {
                        params: [paramMaster],
                    success: function(batch, option) {
                        directMasterStore1.loadStoreRecords();
                     }
                };
                    this.syncAllDirect(config);
                }else {
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
    });     // End of var directMasterStore1 = Unilite.createStore('sva120ukrvMasterStore1',{


    /**
     * 검색조건 (Search Panel)
     * @type
     */

    var masterForm = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
            collapse: function () {
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        },
        items: [{
            title: '기본정보',
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items : [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }

            },
            Unilite.popup('DEPT', {
                fieldLabel: '부서',
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                allowBlank: false,
                holdable: 'hold',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
                            panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                                panelResult.setValue('DEPT_CODE', '');
                                panelResult.setValue('DEPT_NAME', '');
                    },
                        applyextparam: function(popup){
                            var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                            var deptCode = UserInfo.deptCode;   //부서정보
                            var divCode = '';                   //사업장

                            if(authoInfo == "A"){   //자기사업장
                                popup.setExtParam({'DEPT_CODE': ""});
                                popup.setExtParam({'DIV_CODE': UserInfo.divCode});

                            }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                                popup.setExtParam({'DEPT_CODE': ""});
                                popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});

                            }else if(authoInfo == "5"){     //부서권한
                                popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                                popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                            }
                        }
                }
            }),
            {
                fieldLabel: '판매일자',
                xtype: 'uniDatefield',
                name: 'FR_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('FR_DATE', newValue);
                    }
                }
            }]
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
                        var fields = this.getForm().getFields();
                        Ext.each(fields.items, function(item) {
                            if(Ext.isDefined(item.holdable) )   {
                                if (item.holdable == 'hold') {
                                    item.setReadOnly(true);
                                }
                            }
                            if(item.isPopupField)   {
                                var popupFC = item.up('uniPopupField')  ;
                                if(popupFC.holdable == 'hold') {
                                    popupFC.setReadOnly(true);
                                }
                            }
                        })
                    }
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(false);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold' ) {
                                item.setReadOnly(false);
                            }
                        }
                    })
                }
                return r;
            }
    });     // End of var masterForm = Unilite.createSearchForm('searchForm',{


     var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        masterForm.setValue('DIV_CODE', newValue);
                    }
                }

            },
            Unilite.popup('DEPT', {
                fieldLabel: '부서',
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                allowBlank: false,
                holdable: 'hold',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
                            masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        masterForm.setValue('DEPT_CODE', '');
                        masterForm.setValue('DEPT_NAME', '');
                    },
                        applyextparam: function(popup){
                            var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                            var deptCode = UserInfo.deptCode;   //부서정보
                            var divCode = '';                   //사업장

                            if(authoInfo == "A"){   //자기사업장
                                popup.setExtParam({'DEPT_CODE': ""});
                                popup.setExtParam({'DIV_CODE': UserInfo.divCode});

                            }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                                popup.setExtParam({'DEPT_CODE': ""});
                                popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});

                            }else if(authoInfo == "5"){     //부서권한
                                popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                                popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                            }
                        }
                }
            }),
            {
                fieldLabel: '판매일자',
                xtype: 'uniDatefield',
                name: 'FR_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        masterForm.setValue('FR_DATE', newValue);
                    }
                }
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
                        var fields = this.getForm().getFields();
                        Ext.each(fields.items, function(item) {
                            if(Ext.isDefined(item.holdable) )   {
                                if (item.holdable == 'hold') {
                                    item.setReadOnly(true);
                                }
                            }
                            if(item.isPopupField)   {
                                var popupFC = item.up('uniPopupField')  ;
                                if(popupFC.holdable == 'hold') {
                                    popupFC.setReadOnly(true);
                                }
                            }
                        })
                    }
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(false);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold' ) {
                                item.setReadOnly(false);
                            }
                        }
                    })
                }
                return r;
            }
    });     // end of var panelResult = Unilite.createSearchForm('resultForm',{



    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid= Unilite.createGrid('sva120ukrvGrid1', {
        layout:'fit',
        region:'center',

        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            filter: {
                useFilter: false,
                autoCreate: false
            },
            state: {
                useState: false,   //그리드 설정 (우측)버튼 사용 여부
                useStateList: false  //그리드 설정 (죄측)목록 사용 여부
            }
        },
        store: directMasterStore1,
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: true
        },{
            id: 'masterGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: true
        }],
        columns:  [
            {dataIndex:'COMP_CODE'      , width: 80,hidden:true},
            {text: '자판기',
            	columns: [{dataIndex:'POS_NO'     , width: 100},
				              {dataIndex:'POS_NAME'   , width: 200,
				                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				               }}]
            },
            {dataIndex:'LOCATION'       , width: 300},
            {text: '총판매수량',
            		columns:[{dataIndex:'SALE_Q'         , width: 120,summaryType: 'sum'},
            					{dataIndex:'CARD_SALE_Q'         , width: 120,summaryType: 'sum'}]
            }
            {text: '판매금액',
            		columns:[{dataIndex:'SALE_O'         , width: 120,summaryType: 'sum'},
            					 {dataIndex:'CARD_SALE_O'         , width: 120,summaryType: 'sum'}]
            },
            {text: '입금액',
            	columns:[{dataIndex:'COLLECT_AMT'    , width: 120, tdCls:'x-change-cell',summaryType: 'sum'},
            				 {dataIndex:'CARD_COLLECT_AMT'    , width: 120, tdCls:'x-change-cell',summaryType: 'sum'}]
            },
            {dataIndex:'LESS_O'         , width: 120,summaryType: 'sum'},
            {text: '매출번호',
            	columns:[{dataIndex:'BILL_NUM'       , width: 120},
            				 {dataIndex:'CARD_BILL_NUM'       , width: 120}]
            },
            {dataIndex:'COLLECT_NUM'    , width: 120},
            {dataIndex:'COLLECT_SEQ'    , width: 60},
            {dataIndex:'CARD_COLLECT_NUM'    , width: 120},
            {dataIndex:'CARD_COLLECT_SEQ'    , width: 60},
            {dataIndex:'REMARK'         , width: 200}

        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {

            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {

            },
            beforeedit  : function( editor, e, eOpts ) {
                    if (UniUtils.indexOf(e.field,
                            ['COLLECT_AMT']))
                            {
                                return true;
                            }else{
                                return false;
                            }

            },
            afterrender: function(masterGrid) {
                this.contextMenu = Ext.create('Ext.menu.Menu', {listeners: {
                    beforeshow : function(menu, eOpts ){

                    }
                }});
            }
        }
    });     // End of var masterGrid= Unilite.createGrid('sva120ukrvGrid1', {



    Unilite.Main({
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
                ]

        },
            masterForm
        ],
        id: 'sva120ukrvApp',
        fnInitBinding: function() {
            masterForm.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            masterForm.setValue('DEPT_CODE',UserInfo.deptCode);
            masterForm.setValue('DEPT_NAME',UserInfo.deptName);
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_NAME',UserInfo.deptName);
            masterForm.setValue('FR_DATE',UniDate.get('today'));
            panelResult.setValue('FR_DATE',UniDate.get('today'));



            UniAppManager.setToolbarButtons('save',false);
            UniAppManager.setToolbarButtons('reset',true);
        },
        onQueryButtonDown: function()   {
            if(masterForm.setAllFieldsReadOnly(true) == false) {
                return false;
            }else{
            directMasterStore1.loadStoreRecords();
            panelResult.setAllFieldsReadOnly(true)
            }
        },
        onSaveDataButtonDown: function(config) {
            var param = {"FR_DATE": UniDate.getDbDateStr(masterForm.getValue('FR_DATE')).substring(0, 8)};
                sva120ukrvService.billDateCheck(param, function(provider, response) {
                    if(!Ext.isEmpty(provider)){
                        alert("매출집계가 완료된 일자 입니다. 수정 및 저장할 수 없습니다.")
                    }else{
                        directMasterStore1.saveStore();
                    }
                });

        },
        onResetButtonDown: function() {
//          UniAppManager.setToolbarButtons('save',false);
            masterForm.clearForm();
            masterForm.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            panelResult.clearForm();
//          directMasterStore1.clearData();
            this.fnInitBinding();
        }
    });     // End of Unilite.Main({


    Unilite.createValidator('validator01', {
        store: directMasterStore1,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
        console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "COLLECT_AMT" :

                    if(record.get('SALE_Q') == 0 ){
                        rv='<t:message code="판매내역이 존재하지 않습니다."/>';
//                      Ext.Msg.alert('판매도수관련오류','판매내역이 존재하지 않습니다');
                        break;
                    }
                    if(record.get('BILL_NUM') == '' || record.get('BILL_NUM') == null){
                        rv='<t:message code="매출번호가 존재하지 않습니다."/>';
//                      Ext.Msg.alert('판매도수관련오류','판매내역이 존재하지 않습니다');
                        break;
                    }

            }
                return rv;
                        }
            });
};
</script>
