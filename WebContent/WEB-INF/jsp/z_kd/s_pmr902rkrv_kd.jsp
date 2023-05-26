<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr902rkrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr902rkrv_kd"  />             <!-- 사업장 -->
</t:appConfig>

<script type="text/javascript">

var checkedCount = 0;   // 체크된 레코드


function appMain() {

	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmr902rkrv_kdService.selectList'
        }
    });

    Unilite.defineModel('s_pmr902rkrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',        text : '법인코드',      type : 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type : 'string', comboType : "BOR120"},
            {name : 'WKORD_NUM',        text : '작업지시번호',   type : 'string'},
            {name : 'LINE_SEQ',         text : '공정수순',      type : 'string'},
            {name : 'PROG_WORK_CODE',   text : '공정코드',      type : 'string'},
            {name : 'PROG_WORK_NAME',   text : '공정명',       type : 'string'},
            {name : 'PROG_UNIT_Q',      text : '원단위량',      type : 'uniQty'},
            {name : 'WKORD_Q',          text : '작업지시량',    type : 'uniQty'},
            {name : 'PROG_UNIT',        text : '단위',         type : 'string'},
            {name : 'EQUIP_CODE',       text : '설비코드',      type : 'string'},
            {name : 'EQUIP_NAME',       text : '설비명',       type : 'string'},
            {name : 'MOLD_CODE',        text : '금형코드',      type : 'string'},
            {name : 'MOLD_NAME',        text : '금형명',       type : 'string'},
            {name:  'GW_FLAG'                , text: '기안'                         , type: 'string', comboType:'AU', comboCode:'WB17'},
            {name : 'GW_DOC',        text : '기안문서번호',       type : 'string'},
            {name : 'DRAFT_NO',        text : 'DRAFT_NO',       type : 'string'}
            //{name : 'CHECK_YN',         text : '체크여부',      type : 'string'}
        ]
    });

    var directMasterStore = Unilite.createStore('s_pmr902rkrv_kdMasterStore',{
        model: 's_pmr902rkrv_kdModel',
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능 여부
            useNavi : false          // prev | newxt 버튼 사용
        },
        expanded : false,
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param,
              	callback: function(records, operation, success) {
					console.log(records);
					if(success){
           		    	 if(directMasterStore.getCount() == 0) {
                          	Ext.getCmp('GW').setDisabled(true);
                          } else if(directMasterStore.getCount() != 0) {
                              UniBase.fnGwBtnControl('GW', directMasterStore.data.items[0].data.GW_FLAG);
                          }
					}
			    }
            });
        },
        listeners: {
            load:function( store, records, successful, operation, eOpts ) {

            }
        }
    });

    //panelResult(검색조건)
    var panelResult = Unilite.createSearchForm('resultForm', {
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
                value: UserInfo.divCode
            },
                Unilite.popup('WKORD_NUM_KDG', {
                    fieldLabel: '작업지시번호',
                    allowBlank:false,
                    popupWidth:1000,
                    listeners: {
                       applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE' : panelResult.getValue('DIV_CODE')});
                        }
                    }
                }
            ),{
                fieldLabel: '레코드(HIDDEN)',
                name:'COUNT',
                xtype: 'uniNumberfield',
                hidden: true
            }
        ],
        setAllFieldsReadOnly: function(b) {
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });
                if(invalid.length > 0) {
                    r = false;
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


    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_pmr902rkrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            onLoadSelectFirst   : false, //조회시 첫번째 레코드 select 사용여부
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        tbar: [/* {
                xtype : 'button',
                text:'기안',
                id: 'printBtn',
                handler: function() {
                    var masterRecord = masterGrid.getSelectedRecord();
                    UniAppManager.app.requestApprove(masterRecord);
                }
            } */
            {
                itemId : 'GWBtn',
                id:'GW',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                	var param = panelResult.getValues();
                	param.DRAFT_NO = UserInfo.compCode + UserInfo.divCode + panelResult.getValue('WKORD_NUM');
                	if(confirm('기안 하시겠습니까?')) {
                		s_pmr902rkrv_kdService.selectGwData(param, function(provider, response) {
                			if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                				s_pmr902rkrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                    UniAppManager.app.requestApprove();
                                });
                            } else {
                                alert('이미 기안된 자료입니다.');
                                return false;
                            }
                        });
                	}
                	UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
//        selModel : Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
//            listeners: {
//                select: function(grid, selectRecord, index, rowIndex, eOpts ) {
//                    UniAppManager.setToolbarButtons(['save'], false);
//                    checkedCount = checkedCount + 1;
//                    panelResult.setValue('COUNT', checkedCount);
//
//                    selectRecord.set('CHECK_YN', 'Y');
//
//                    if(panelResult.getValue('COUNT') > 0) {
//                        Ext.getCmp('printBtn').setDisabled(false);
//                    } else {
//                        Ext.getCmp('printBtn').setDisabled(true);
//                    }
//                },
//                deselect:  function(grid, selectRecord, index, eOpts ) {
//                    UniAppManager.setToolbarButtons(['save'], false);
//                    checkedCount = checkedCount - 1;
//                    panelResult.setValue('COUNT', checkedCount);
//
//                    selectRecord.set('CHECK_YN', '');
//
//                    if(panelResult.getValue('COUNT') > 0) {
//                        Ext.getCmp('printBtn').setDisabled(false);
//                    } else {
//                        Ext.getCmp('printBtn').setDisabled(true);
//                    }
//                }
//            }
//        }),
        features: [
            {id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: false },
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: false}
        ],
        columns:  [
            {dataIndex : 'COMP_CODE',       width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 120, hidden : true},
            {dataIndex : 'WKORD_NUM',       width : 120},
            {dataIndex : 'LINE_SEQ',        width : 80},
            {dataIndex : 'PROG_WORK_CODE',  width : 100},
            {dataIndex : 'PROG_WORK_NAME',  width : 150},
            {dataIndex : 'PROG_UNIT_Q',     width : 130},
            {dataIndex : 'WKORD_Q',         width : 110, hidden : true},
            {dataIndex : 'PROG_UNIT',       width : 90},
            {dataIndex : 'EQUIP_CODE',      width : 120},
            {dataIndex : 'EQUIP_NAME',      width : 150},
            {dataIndex : 'MOLD_CODE',       width : 120},
            {dataIndex : 'MOLD_NAME',       width : 150},
            {dataIndex:'GW_FLAG'                               , width: 100},
            {dataIndex:'GW_DOC'                                , width: 100},
            {dataIndex:'DRAFT_NO'                              , width: 100}
           // {dataIndex : 'CHECK_YN',        width : 100, hidden : true}
        ],
        listeners: {

        }
    });

    Unilite.Main( {
        borderItems:[{
//            region:'center',
//            layout: 'border',
//            border: false,
        	layout: {type: 'vbox', align: 'stretch'},
            region: 'center',
            items:[
                panelResult, masterGrid
            ]
        }],
        id  : 's_pmr902rkrv_kdApp',
        fnInitBinding : function() {
            panelResult.clearForm();
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();

            UniAppManager.setToolbarButtons('reset', true);
            UniAppManager.setToolbarButtons('save', false);

        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        requestApprove: function(record){     //결재 요청

            records = masterGrid.getSelectedRecords();
            var tempRecord = masterGrid.getSelectedRecord();
//            var lineSeq = tempRecord.get('LINE_SEQ');
            var lineSeq = '';

            Ext.each(records, function(record, index) {
            	if(!Ext.isEmpty(tempRecord)){
                	if(index == 0) {
                		lineSeq = record.get('LINE_SEQ');
                	}
                	else {
                	   lineSeq = lineSeq + ',' + record.get('LINE_SEQ')
                	}
            	}
            });
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm             = document.f1;
            var record          = masterGrid.getSelectedRecord();
            var compCode        = UserInfo.compCode;
            var divCode         = panelResult.getValue('DIV_CODE');
            var wkordNum        = panelResult.getValue('WKORD_NUM');
//            var lineSeq
            var userId          = UserInfo.userID;
            var spText1         = 'EXEC omegaplus_kdg.unilite.USP_GW_S_PMR902RKRV1_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + wkordNum + "'" + ', ' + "'" + lineSeq + "'"  + ', '+ "'" + userId + "'";
            var spText2         = 'EXEC omegaplus_kdg.unilite.USP_GW_S_PMR902RKRV2_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + wkordNum + "'";
            var spCall          = encodeURIComponent(spText1 + "^" + spText2);
            var draftNo         = UserInfo.compCode + divCode + wkordNum;

//            frm.action = '/payment/payreq.php';
  			 var gwurl = groupUrl  + "viewMode=docuDraft" + "&prg_no=s_pmr902rkrv_kd&draft_no=" + draftNo + "&sp=" + spCall;
  //          frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_pmr902rkrv_kd&draft_no=" + draftNo + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_pmr902rkrv2_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            //frm.target   = "payviewer";
            //frm.method   = "post";
            //frm.submit();
  			UniBase.fnGw_Call(gwurl,frm,'GW');
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_INOUT_DATE', UniDate.get('endOfMonth'));
            Ext.getCmp('GW').setDisabled(true);
        }
    });
};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>