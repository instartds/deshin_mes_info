<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt100ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt100ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B012" /><!-- 국가코드-->
    <t:ExtComboStore comboType="AU" comboCode="WR01" /> <!--비율/단가-->
    <t:ExtComboStore comboType="AU" comboCode="WR02" /> <!--프로젝트타입-->
    <t:ExtComboStore comboType="AU" comboCode="WR03" /> <!--작업반기-->
</t:appConfig>
<script type="text/javascript" >

var selectedMasterGrid = 's_ryt100ukrv_kdGrid';
var savedGridA = false;
var savedGridB = false;
var chkResetFlag = false;
function appMain() {
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt100ukrv_kdService.selectList',
            update: 's_ryt100ukrv_kdService.updateDetail',
            create: 's_ryt100ukrv_kdService.insertDetail',
            destroy: 's_ryt100ukrv_kdService.deleteDetail',
            syncAll: 's_ryt100ukrv_kdService.saveAll'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt100ukrv_kdService.selectList2',
            update: 's_ryt100ukrv_kdService.updateDetail2',
            create: 's_ryt100ukrv_kdService.insertDetail2',
            destroy: 's_ryt100ukrv_kdService.deleteDetail2',
            syncAll: 's_ryt100ukrv_kdService.saveAll2'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_ryt100ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'             ,text:'법인코드'                 ,type: 'string'},
            {name: 'DIV_CODE'              ,text:'사업자코드'                ,type: 'string'},
            {name: 'CUSTOM_CODE'           ,text:'거래처코드'                ,type: 'string', allowBlank: false},
            {name: 'CUSTOM_NAME'           ,text:'거래처명'                 ,type: 'string'},
            {name: 'CON_DATE'              ,text:'계약일자'                 ,type: 'uniDate', allowBlank: false},
            {name: 'CON_YEAR'              ,text:'계약기간(년)'              ,type: 'int'},
            {name: 'HALF1_MM'              ,text:'1반기시작월'               ,type: 'int', maxLength: 2},
            {name: 'HALF2_MM'              ,text:'2반기시작월'               ,type: 'int', maxLength: 2},
            {name: 'EXP_DATE'              ,text:'만료일자'                 ,type: 'uniDate', allowBlank: false},
            {name: 'CALC_STANDARD'         ,text:'정산기준'                 ,type: 'string', comboType:'AU', comboCode:'WR05'},
            {name: 'MONEY_UNIT'            ,text:'화폐'                   ,type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name: 'EXP_REMARK'            ,text:'만료일비고'                ,type: 'string'},
            {name: 'INIT_PAY'              ,text:'초기지불내용'               ,type: 'string'},
            {name: 'ROYALTY_REMARK'        ,text:'로얄티조건'                ,type: 'string'},
            {name: 'PAY_PERIOD'            ,text:'지급기준시기'               ,type: 'string'},
            {name: 'INVITE_PAY'            ,text:'초청시비용내용'              ,type: 'string'},
            {name: 'NATION_CODE'           ,text:'국가'                    ,type: 'string', comboType:'AU', comboCode:'B012'},
            {name: 'ADDR1'                 ,text:'주소'                    ,type: 'string'},
            {name: 'CONTRACT_NUM'          ,text:'계약번호'                  ,type: 'string'}
        ]
    });

    Unilite.defineModel('s_ryt100ukrv_kdModel2', {
        fields: [
            {name: 'COMP_CODE'             ,text:'법인코드'                 ,type: 'string'},
            {name: 'DIV_CODE'              ,text:'사업자코드'               ,type: 'string'},
            {name: 'CUSTOM_CODE'           ,text:'거래처코드'               ,type: 'string'},
            {name: 'CON_DATE'              ,text:'계약일자'                 ,type: 'uniDate'},
            {name: 'SEQ'                   ,text:'순번'                     ,type: 'int'},
            {name: 'ITEM_CODE'             ,text:'품목코드'                 ,type: 'string', allowBlank: false},
            {name: 'ITEM_NAME'             ,text:'품목명'                   ,type: 'string'},
            {name: 'SPEC'             	   ,text:'규격'                   ,type: 'string'},
            {name: 'CON_FR_YYMM'           ,text:'시작월'                   ,type: 'string', allowBlank: false, maxLength: 6},
            {name: 'CON_TO_YYMM'           ,text:'종료월'                   ,type: 'string', allowBlank: false, maxLength: 6},
            {name: 'GUBUN1'                ,text:'비율/단가'                ,type: 'string', allowBlank: false, comboType:'AU', comboCode:'WR01'},
            {name: 'RATE_N'                ,text:'로얄티'                     ,type: 'uniPercent'},
            {name: 'PJT_TYPE'              ,text:'프로젝트타입'              ,type: 'string', comboType:'AU', comboCode:'WR02'},
            {name: 'PJT_CODE'              ,text:'프로젝트코드'              ,type: 'string', comboType:'AU', comboCode:'WR02', displayField: 'value'},
            {name: 'CONTRACT_NUM'           ,text:'계약번호'                ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_ryt100ukrv_kdMasterStore1',{
        model: 's_ryt100ukrv_kdModel',
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
                        UniAppManager.app.onQueryButtonDown();
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1

    var directMasterStore2 = Unilite.createStore('s_ryt100ukrv_kdMasterStore2',{
        model: 's_ryt100ukrv_kdModel2',
        uniOpt : {
            isMaster:  false,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function(param)   {
//            var param= panelResult.getValues();
		if(!Ext.isEmpty(param)){
			var selCustom     = param.CUSTOM_CODE;
			var selDivCode    = param.DIV_CODE;
			var selContractNum = param.CONTRACT_NUM;
		}
        	if(selectedMasterGrid == 's_ryt100ukrv_kdGrid2') {
        		var param= panelResult2.getValues();
        		param.CUSTOM_CODE    = selCustom;
        		param.DIV_CODE       = selDivCode;
        		param.CONTRACT_NUM    = selContractNum;
        	}

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
                if(record.data['GUBUN1'] == 'R') {
                    if(Ext.isEmpty(record.data['RATE_N']) || record.data['RATE_N'] == 0) {
                    	alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '비율: 필수 입력값 입니다.');
                    isErr = true;
                    return false;
                    }
                }
            });
            if(isErr) return false;

            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult2.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
//                        var record = masterGrid.getSelectedRecord();
//                        var param = {
//                            DIV_CODE       : record.data.DIV_CODE,
//                            CUSTOM_CODE    : record.data.CUSTOM_CODE,
//                            CON_DATE       : UniDate.getDbDateStr(record.data.CON_DATE).substring(0, 4)
//                        }
//                        directMasterStore2.loadStoreRecords(param);
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners:{
        	load:function()	{
        		Ext.getBody().unmask();
        	},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
				if( directMasterStore.isDirty() || store.isDirty() )	{
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
        }
    });

    /**
     * 검색조건 (resultForm)
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
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '계약일자',
                labelWidth: 107,
                xtype: 'uniDateRangefield',
                startFieldName: 'CON_DATE_FR',
                endFieldName: 'CON_DATE_TO',
                allowBlank:true,
             /*    startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'), */
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('CON_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('CON_DATE_TO', newValue);
                    }
                }
            },{
                layout: {type:'uniTable', column:2},
                xtype: 'container',
                labelWidth: 170,
                items: [{
                        fieldLabel: '거래처',
                        xtype: 'uniTextfield',
                        name: 'CUSTOM_CODE',
                        flex:2,
                        width:155,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('CUSTOM_CODE', newValue);
                            }
                        }
                    },{
                        xtype: 'uniTextfield',
                        name: 'CUSTOM_NAME',
                        flex:1,
                        width:153,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('CUSTOM_NAME', newValue);
                            }
                        }
                }]
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

    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type : 'uniTable', columns : 3},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
     //   margin:'1 1 1 1',
        region: 'south',
        masterGrid: masterGrid,
        items: [
            {
                fieldLabel: 'InitialPay',
                xtype: 'textareafield',
                name: 'INIT_PAY',
                height : 40,
                width: 325
            },{
                fieldLabel: 'Royalty조건',
                xtype: 'textareafield',
                name: 'ROYALTY_REMARK',
                height : 40,
                width: 325
            },{
                fieldLabel: '초청시지불비용',
                xtype: 'textareafield',
                name: 'INVITE_PAY',
                height : 40,
                width: 325
            }
        ],
        loadForm: function(record)  {
            // window 오픈시 form에 Data load
            var count = masterGrid.getStore().getCount();
            var selRecord =  masterGrid.getSelectedRecord();
            if(count > 0) {
                this.reset();
                this.setActiveRecord(selRecord || null);
                this.resetDirtyStatus();
            }
        }
    });

    var panelResult2 = Unilite.createSearchForm('detailForm2', { //createForm
        layout : {type : 'uniTable', columns : 2},
        disabled: false,
  //      flex:0.5,
        border:true,
        padding:'1 1 1 1',
 //       margin :'1 1 1 1',
//        region: 'north',
        masterGrid: masterGrid2,
        items: [
            {
                fieldLabel: '비율/단가',
                xtype: 'uniCombobox',
                holdable: 'hold',
                comboType:'AU',
                comboCode:'WR01',
                name: 'INIT_PAY'
            }/* ,{
                fieldLabel: '작업기간',
                xtype: 'uniMonthRangefield',
                startFieldName: 'CON_FR_YYMM',
                endFieldName: 'CON_TO_YYMM',
                holdable: 'hold'
            } */,{
				xtype: 'uniCheckboxgroup',
				fieldLabel: '',
				id: 'chkAllYn',
				padding: '0 0 0 0',
				margin: '0 0 0 90',
				items: [{
					boxLabel: '전체 기간 조회',
					width: 200,
					name: 'ALL_YN',
					inputValue: 'Y',
					checked: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							    var selRow = masterGrid.getSelectedRecord();
			                    if(!Ext.isEmpty(selRow)){
			                    	 var param = {
						                        DIV_CODE       : selRow.get('DIV_CODE'),
						                        CUSTOM_CODE    : selRow.get('CUSTOM_CODE'),
						                       // CON_DATE       : UniDate.getDbDateStr(selRow.get('CON_DATE')).substring(0, 4)
						                        CONTRACT_NUM    : selRow.get('CONTRACT_NUM')
						                    }
						                    	//Ext.getBody().mask();
						                    	param.INIT_PAY = panelResult2.getValue('INIT_PAY');
						                    	if(panelResult2.getValue('ALL_YN') == true){
						                    		param.ALL_YN ='Y';
						                    	}else{
						                    		param.ALL_YN ='N';
						                    	}
						                    	if(chkResetFlag == false){
						                    		directMasterStore2.loadStoreRecords(param);
						                    	}
						                    	chkResetFlag = false;
			                    }

						}
					}
				}]
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

    var masterGrid = Unilite.createGrid('s_ryt100ukrv_kdGrid', {
      //  layout : 'fit',
        region: 'center',
        store: directMasterStore,
        selModel: 'rowmodel',
        flex: 0.5,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            onLoadSelectFirst: true,
            useRowNumberer: false,       //순번표시
            copiedRow: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        tbar: [{
                xtype : 'button',
                text:'출력',
                id: 'printBtn',
                handler: function() {
                    UniAppManager.app.requestApprove();
                }
            }
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'             ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'              ,           width: 80, hidden: true},
            { dataIndex: 'CUSTOM_CODE'           ,           width: 110,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup:true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                            var param = {
                                  'COMP_CODE': UserInfo.compCode
                                , 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
                            };
                            s_ryt100ukrv_kdService.selectCustData(param, function(provider, response) {
                                grdRecord.set('NATION_CODE' , provider[0].NATION_CODE);
                                grdRecord.set('ADDR1'       , provider[0].ADDR1);
                            });
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('CUSTOM_NAME','');
                            grdRecord.set('NATION_CODE','');
                            grdRecord.set('ADDR1','');
                      }
                    }
                })
            },
            { dataIndex: 'CUSTOM_NAME'           ,           width: 200},
            { dataIndex: 'CON_DATE'              ,           width: 80},
            { dataIndex: 'CON_YEAR'              ,           width: 100},
            { dataIndex: 'HALF1_MM'              ,           width: 100},
            { dataIndex: 'HALF2_MM'              ,           width: 100},
            { dataIndex: 'EXP_DATE'              ,           width: 80},
            { dataIndex: 'CALC_STANDARD'         ,           width: 80, align: 'center'},
            { dataIndex: 'MONEY_UNIT'            ,           width: 80, align: 'center'},
            { dataIndex: 'EXP_REMARK'            ,           width: 100},
            { dataIndex: 'INIT_PAY'              ,           width: 80, hidden: true},
            { dataIndex: 'ROYALTY_REMARK'        ,           width: 80, hidden: true},
            { dataIndex: 'PAY_PERIOD'            ,           width: 100},
            { dataIndex: 'INVITE_PAY'            ,           width: 90, hidden: true},
            { dataIndex: 'NATION_CODE'           ,           width: 150},
            { dataIndex: 'ADDR1'                 ,           width: 500},
            { dataIndex: 'CONTRACT_NUM'          ,           width: 100, hidden: true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		var count = masterGrid2.getStore().getCount();

                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['CUSTOM_NAME', 'NATION_CODE', 'ADDR1','CONTRACT_NUM']))
                    {
                        return false;
                    } else {
                    	/* if(count == 0) {
                            return true;
                    	} else {
                            return false;
                    	} */
                    	 return true;
                    }
                } else {
                	if(UniUtils.indexOf(e.field, ['CUSTOM_NAME', 'NATION_CODE', 'ADDR1','CONTRACT_NUM']))
                    {
                        return false;
                    } else {
                        /* if(count == 0) {
                            return true;
                        } else {
                            return false;
                        }*/
                    	 return true;
                    }
                }
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                	var oldGrid = Ext.getCmp(selectedMasterGrid);
			    	grid.changeFocusCls(oldGrid);
                	selectedMasterGrid = girdNm;
                });
            },
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var selRow = masterGrid.getSelectedRecord();
                    var param = {
                        DIV_CODE       : record.data.DIV_CODE,
                        CUSTOM_CODE    : record.data.CUSTOM_CODE,
                        //CON_DATE       : UniDate.getDbDateStr(record.data.CON_DATE).substring(0, 4)
                        CONTRACT_NUM    : record.data.CONTRACT_NUM
                    }

                    if(selRow.phantom == false) {
                    	Ext.getBody().mask();
                    	param.INIT_PAY = panelResult2.getValue('INIT_PAY');
                    	if(panelResult2.getValue('ALL_YN') == true){
                    		param.ALL_YN ='Y';
                    	}else{
                    		param.ALL_YN ='N';
                    	}
                        directMasterStore2.loadStoreRecords(param);
                        inputTable.loadForm(selected);
                    } else {
                    	masterGrid2.reset();
                    }
                }
            }
        }
    });

    var masterGrid2 = Unilite.createGrid('s_ryt100ukrv_kdGrid2', {
        //layout : 'fit',
        region: 'south',
        flex: 3,
        store: directMasterStore2,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            lockable:true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [
            { dataIndex: 'COMP_CODE'        ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'         ,           width: 80, hidden: true},
            { dataIndex: 'CUSTOM_CODE'      ,           width: 80, hidden: true},
            { dataIndex: 'CON_DATE'         ,           width: 80, hidden: true},
            { dataIndex: 'SEQ'              ,           width: 80, hidden: true},
            {dataIndex: 'ITEM_CODE'                    ,       width: 120,
                    editor: Unilite.popup('DIV_PUMOK_G', {
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        autoPopup:true,
                        extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
                        listeners: {'onSelected': {
                                fn: function(records, type) {
                                    console.log('records : ', records);
                                    Ext.each(records, function(record,i) {
                                        console.log('record',record);
                                        if(i==0) {
                                            masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
                                        } else {
                                            UniAppManager.app.onNewDataButtonDown();
                                            masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
//                                            var param = {
//                                                  'COMP_CODE': UserInfo.compCode
//                                                , 'ITEM_CODE': grdRecord.get('ITEM_CODE')
//                                                , 'DIV_CODE': grdRecord.get('DIV_CODE')
//                                                , 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
//                                            };
//                                            s_ryt100ukrv_kdService.selectItemData(param, function(provider, response) {
//                                                if(provider[0].CNT == 0) {
//                                                    grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
//                                                    grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
//                                                } else {
//                                                    alert("품목은 하나의 거래처만 가질수 있습니다.")
//                                                    grdRecord.set('ITEM_CODE','');
//                                                    grdRecord.set('ITEM_NAME','');
//                                                }
//                                            });
                                        }
                                    });
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
                            },
                            applyextparam: function(popup){
                                popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            }
                        }
                    })
            },
            { dataIndex: 'ITEM_NAME'        ,           width: 300},
            { dataIndex: 'SPEC'        		,           width: 120},
            { dataIndex: 'CON_FR_YYMM'      ,           width: 80/*, xtype: 'UniMonthColumn'*/, align: 'center'},
            { dataIndex: 'CON_TO_YYMM'      ,           width: 80/*, xtype: 'UniMonthColumn'*/, align: 'center'},
            { dataIndex: 'GUBUN1'           ,           width: 100, align: 'center'},
            { dataIndex: 'RATE_N'           ,           width: 80},
            { dataIndex: 'PJT_TYPE'         ,           width: 200},
            { dataIndex: 'PJT_CODE'         ,           width: 100, align: 'center'},
            { dataIndex: 'CONTRACT_NUM'      ,           width: 100, hidden:true}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['ITEM_NAME','CONTRACT_NUM','SPEC','PJT_CODE']))
                    {
                        return false;
                    } else {
                        if(UniUtils.indexOf(e.field, ['RATE_N']))
                        {
                            /* if(e.record.data.GUBUN1 != 'P') {
                                return true;
                            } else {
                            	return false;
                            } */
                            return true;
                    	} else {
                    	   return true;
                    	}
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['ITEM_NAME','CONTRACT_NUM','SPEC','PJT_CODE']))
                    {
                        return false;
                    } else {
                        if(UniUtils.indexOf(e.field, ['RATE_N']))
                        {
                          /*   if(e.record.data.GUBUN1 != 'P') {
                                return true;
                            } else {
                                return false;
                            } */
                            return true;
                        } else {
                           return true;
                        }
                    }
                }
            },
            render: function(grid, eOpts){
                var girdNm = grid.getItemId()
                grid.getEl().on('click', function(e, t, eOpt) {
                	var oldGrid = Ext.getCmp(selectedMasterGrid);
			    	grid.changeFocusCls(oldGrid);
                	selectedMasterGrid = girdNm;
                    if(directMasterStore.isDirty()){
                        grid.suspendEvents();
                        selectedMasterGrid = 's_ryt100ukrv_kdGrid';
                        alert(Msg.sMB154);//먼저 저당하십시오
                    } else {
                        masterSelectedGrid = girdNm;
                        if(grid.getStore().getCount() > 0)  {
                            UniAppManager.setToolbarButtons('delete', true);
                        }else {
                            UniAppManager.setToolbarButtons('delete', false);
                        }
                        selectedMasterGrid = 's_ryt100ukrv_kdGrid2';
                    }
                });

            },
            edit: function(editor, e) { console.log(e);
                var newValue = e.value;
                var fieldName = e.field;
                var list = directMasterStore2.data.items;
                var record1 = masterGrid.getSelectedRecord();
//                var selRow1 = masterGrid2.getSelectedRecord();
                var isErr = false;

               /*  if(e.record.getData().GUBUN1 == 'P'){
                	e.record.set('RATE_N', '0');
                } */
                if(fieldName == 'CON_FR_YYMM'){
                	if(parseInt(newValue.substring(4, 6)) > 12 || parseInt(newValue.substring(4, 6)) < 01) {
                        alert("정확한 날짜를 입력하세요.");
                        e.record.set('CON_FR_YYMM', e.originalValue);
                        return false;
                    }
                    if(!Ext.isEmpty(record1.data.EXP_DATE)) {
                        if(parseInt(UniDate.getDbDateStr(record1.data.EXP_DATE).substring(0, 6)) < parseInt(newValue)) {
                            alert("만료일보다 시작월이 클수없습니다.");
                            e.record.set('CON_FR_YYMM', e.originalValue);
                            return false;
                        }
                    }
                    if(parseInt(UniDate.getDbDateStr(record1.data.CON_DATE).substring(0, 6)) > parseInt(newValue)) {
                        alert("계약일자보다 시작월이 작을수없습니다.");
                        e.record.set('CON_FR_YYMM', e.originalValue);
                        return false;
                    }
//                    Ext.each(list, function(record, index) {
////                    	if(e.record.phantom == false) {
//                            if(parseInt(newValue) >= parseInt(record.get('CON_FR_YYMM')) && parseInt(newValue) <= parseInt(record.get('CON_TO_YYMM'))) {
//                                isErr = true;
//                                return false;
//                            }
////                    	}
//                    });
//                    if(isErr == true) {
//                        alert("작업기간 내에서 입력하세요.");
//                        e.record.set('CON_FR_YYMM'       , e.originalValue);
//                        return false;
//                    }
                }
                if(fieldName == 'CON_TO_YYMM') {
                	if(parseInt(newValue.substring(4, 6)) > 12 || parseInt(newValue.substring(4, 6)) < 01) {
                        alert("정확한 날짜를 입력하세요.");
                        e.record.set('CON_TO_YYMM', e.originalValue);
                        return false;
                    }
                    if(!Ext.isEmpty(record1.data.EXP_DATE)) {
                        if(UniDate.getDbDateStr(record1.data.EXP_DATE).substring(0, 6) < newValue) {
                            alert("만료일보다 종료월이 클수없습니다.");
                            e.record.set('CON_TO_YYMM', e.originalValue);
                            return false;
                        }
                    }
                    if(UniDate.getDbDateStr(record1.data.CON_DATE).substring(0, 6) > newValue) {
                        alert("계약일자보다 종료월이 작을수없습니다.");
                        e.record.set('CON_TO_YYMM', e.originalValue);
                        return false;
                    }
//                	Ext.each(list, function(record, index) {
////                		if(e.record.phantom == false) {
//                            if(parseInt(newValue) >= parseInt(record.get('CON_FR_YYMM')) && parseInt(newValue) <= parseInt(record.get('CON_TO_YYMM'))) {
//                                isErr = true;
//                                return false;
//                            }
////                		}
//                    });
//                    if(isErr == true) {
//                        alert("작업기간 내에서 입력하세요.");
//                        e.record.set('CON_TO_YYMM'       , e.originalValue);
//                        return false;
//                    }
                }
            }
        },
        setItemData: function(record, dataClear, grdRecord) {
            if(dataClear) {
                grdRecord.set('ITEM_CODE'       , "");
                grdRecord.set('ITEM_NAME'       , "");
                grdRecord.set('SPEC'       , "");
            } else {
            	grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
                grdRecord.set('SPEC', record['SPEC']);

                var param = {
                      'COMP_CODE': UserInfo.compCode
                    , 'ITEM_CODE': grdRecord.get('ITEM_CODE')
                    , 'DIV_CODE': grdRecord.get('DIV_CODE')
                    , 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
                };
                s_ryt100ukrv_kdService.selectItemData(param, function(provider, response) {
                    if(provider[0].CNT == 0) {
                        grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
                        grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
                    } else {
                        alert("품목은 하나의 거래처만 가질수 있습니다.")
                        grdRecord.set('ITEM_CODE','');
                        grdRecord.set('ITEM_NAME','');
                    }
                });
            }
        }
    });

    /*
     * panelResult   n
     * inputTable    n
     * masterGrid    c
     * panelResult2  s
     * masterGrid2   s
     * */
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, masterGrid,
            {
                region : 'south',
                xtype : 'container',
                layout: {type: 'vbox', align: 'stretch'},
                flex: 1,
                margin: '-2 1 1 1',
                split:true,
                items : [ inputTable, panelResult2,  masterGrid2]
            }]
        }
        ],
        id  : 's_ryt100ukrv_kdApp',
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
            if(savedGridA){
                directMasterStore.loadStoreRecords();
                savedGridA = false;
            }else if(savedGridB){
            	 var selRow = masterGrid.getSelectedRecord();
                 var param = {
                     DIV_CODE       : selRow.get('DIV_CODE'),
                     CUSTOM_CODE    : selRow.get('CUSTOM_CODE'),
                    // CON_DATE       : UniDate.getDbDateStr(selRow.get('CON_DATE')).substring(0, 4)
                     CONTRACT_NUM    : selRow.get('CONTRACT_NUM')
                 }
                 	Ext.getBody().mask();
                 	param.INIT_PAY = panelResult2.getValue('INIT_PAY');
                 	if(panelResult2.getValue('ALL_YN') == true){
                 		param.ALL_YN ='Y';
                 	}else{
                 		param.ALL_YN ='N';
                 	}
            	directMasterStore2.loadStoreRecords(param);
            	savedGridB = false;
            }else{
            	directMasterStore.loadStoreRecords();
            }
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult2.setAllFieldsReadOnly(false);
            chkResetFlag = true;
            panelResult.clearForm();
            inputTable.clearForm();
            panelResult2.clearForm();
        	masterGrid.getStore().loadData({});
        	masterGrid2.getStore().loadData({});
            this.setDefault();
            panelResult2.setValue('ALL_YN','Y');
            //UniAppManager.setToolbarButtons(['save', 'reset'], false);
        },
        onNewDataButtonDown: function() {       // 행추가
        	if(selectedMasterGrid == 's_ryt100ukrv_kdGrid') {
                var compCode      = UserInfo.compCode;
                var divCode       = panelResult.getValue('DIV_CODE');
                var conDate       = UniDate.get('today');
                var flag          = 'N';

                var r = {
                    COMP_CODE      : compCode,
                    DIV_CODE       : divCode,
                    CON_DATE       : conDate,
                    FLAG           : flag
                }
                masterGrid.createRow(r);
            } else {
                var record       = masterGrid.getSelectedRecord();
                var compCode     = UserInfo.compCode;
                var divCode      = record.get('DIV_CODE');
                var customCode   = record.get('CUSTOM_CODE');
                var seq = directMasterStore2.max('SEQ');
                    if(!seq) seq = 1;
                    else seq += 1;
                var conDate      = record.get('CON_DATE');
                var rateN        = 0;
                var conFrYymm = panelResult2.getValues().CON_FR_YYMM;
                var conToYymm = panelResult2.getValues().CON_TO_YYMM
                var gubun1 = panelResult2.getValue('INIT_PAY');
                var contractNum    = record.get('CONTRACT_NUM');


                var r = {
                    COMP_CODE      : compCode,
                    DIV_CODE       : divCode,
                    CUSTOM_CODE    : customCode,
                    SEQ            : seq,
                    CON_DATE       : conDate,
                    RATE_N         : rateN,
                    CON_FR_YYMM : conFrYymm,
                    CON_TO_YYMM : conToYymm,
                    GUBUN1 : gubun1,
                    CONTRACT_NUM : contractNum
                }
                masterGrid2.createRow(r);
            }
        },
        onDeleteDataButtonDown: function() {
        	if(selectedMasterGrid == 's_ryt100ukrv_kdGrid') {
        		var count = masterGrid2.getStore().getCount();
                if(count > 0) {
                    alert("품목정보를 삭제한 후 진행하세요.");
                    return false;
                } else {
            		var selRow1 = masterGrid.getSelectedRecord();
                    if(selRow1.phantom === true) {
                        masterGrid.deleteSelectedRow();
                    } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid.deleteSelectedRow();
                    }
                }
        	} else {
        		var selRow2 = masterGrid2.getSelectedRecord();
                if(selRow2.phantom === true) {
                    masterGrid2.deleteSelectedRow();
                } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid2.deleteSelectedRow();
                }
        	}
        },
        onSaveDataButtonDown: function () {
/*         	if(selectedMasterGrid == 's_ryt100ukrv_kdGrid') {
                directMasterStore.saveStore();
                savedGridA = true;
        	} else {
        		directMasterStore2.saveStore();
        		savedGridB = true;
        	} */
        	if(directMasterStore.isDirty())	{
				directMasterStore.saveStore();	//Master 데이타 저장 성공 후 Detail 저장함.
				//savedGridA = true;
			}else if(directMasterStore2.isDirty())	{
				directMasterStore2.saveStore();
				//savedGridB = true;
			}
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID;
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_RYT100UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'";
            var spCall      = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ryt100ukrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_ryt100ukrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
         //   panelResult.setValue('CON_DATE_FR', UniDate.get('startOfYear'));
         //   panelResult.setValue('CON_DATE_TO', UniDate.get('today'));
           // panelResult2.setValue('INIT_PAY', 'R');
        //    panelResult2.setValue('CON_FR_YYMM', UniDate.get('startOfYear'));
         //   panelResult2.setValue('CON_TO_YYMM', UniDate.get('endOfYear'));
            UniAppManager.setToolbarButtons('save', false);
        }
    });


/*    Unilite.createValidator('validator01', {
       store: directMasterStore,
       grid: masterGrid,
       validate: function( type, fieldName, newValue, oldValue, record, eopt) {
           if(newValue == oldValue){
               return false;
           }
           console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
           var rv = true;
           var record1 = masterGrid.getSelectedRecord();
           switch(fieldName) {
               case "CON_DATE" :
                   if(UniDate.getDbDateStr(record.set('EXP_DATE')) < newValue) {
                       alert("계약일자보다 만료일자가 작을수없습니다.");
                       record.set('CON_DATE', oldValue);
                       break;
                   }

                   var cnt = directMasterStore2.getCount();
                   if(cnt > 0){
		          	   Ext.each(directMasterStore2.data.items, function(record2, index) {
		          		 	record2.set('CON_DATE', newValue);
		               });
                   }
                   break;

           }
           return rv;
       }
   }); */

  Unilite.createValidator('validator02', {
      store: directMasterStore2,
      grid: masterGrid2,
      validate: function( type, fieldName, newValue, oldValue, record, eopt) {
          if(newValue == oldValue){
              return false;
          }
          console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
          var rv = true;
          switch(fieldName) {
              case "PJT_TYPE" :
            	  				record.set('PJT_CODE', newValue);
                    break;
          }
          return rv;
      }
  });

}
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>