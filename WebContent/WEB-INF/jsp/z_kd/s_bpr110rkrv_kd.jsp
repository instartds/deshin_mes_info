<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr110rkrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_bpr110rkrv_kd" /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

	var masterForm = Unilite.createSearchForm('masterFormForm', {
        disabled :false
        , title : '공급현황표'
        , flex:1
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
        , items :[
            {
                xtype:'container',
                html: '<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[내역]</b>',
                style: {
                    color: 'blue'
                }
            },{
                fieldLabel: '10년',
                labelWidth: 100,
                name:'txt10',
                suffixTpl: '건',
                xtype: 'uniNumberfield'
            },{
                fieldLabel: '7년',
                labelWidth: 100,
                name:'txt7',
                suffixTpl: '건',
                xtype: 'uniNumberfield'
            },{
                fieldLabel: '5년',
                labelWidth: 100,
                name:'txt5',
                suffixTpl: '건',
                xtype: 'uniNumberfield'
            },{
                xtype:'container',
                html: '<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[출력조건]</b>',
                style: {
                    color: 'blue'
                }
            },{
                fieldLabel: '만료기준일',
                labelWidth: 100,
                name: 'BASE_END_YYMMDD',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                allowBlank: false
            },{
                xtype: 'radiogroup',
                fieldLabel: '출력구분',
                labelWidth: 100,
                id: 'radioSelect1',
                items : [{
                        boxLabel: '전체',
                        name: 'PRT_GUBUN',
                        inputValue: '',
                        width:50,
                        checked: true
                    },{
                        boxLabel: '만료기준일까지',
                        name: 'PRT_GUBUN' ,
                        inputValue: '1',
                        width:110
                    },{
                        boxLabel: '제품중지품목',
                        name: 'PRT_GUBUN' ,
                        inputValue: '2',
                        width:100
                    }
                ]
            },{
                fieldLabel: '만료기준년수',
                labelWidth: 100,
                name:'BASE_OUT_YEAR',
                xtype: 'uniNumberfield',
                allowBlank: false,
                value: 10
            },{
                xtype: 'radiogroup',
                fieldLabel: '만료기준년수구분',
                id: 'radioSelect2',
                labelWidth: 100,
                items : [{
                        boxLabel: '전체',
                        name: 'BASE_GUBUN',
                        inputValue: '',
                        width:50,
                        checked: true
                    },{
                        boxLabel: '초과',
                        name: 'BASE_GUBUN' ,
                        inputValue: '1',
                        width:50
                    },{
                        boxLabel: '부족',
                        name: 'BASE_GUBUN' ,
                        inputValue: '2',
                        width:50
                    }
                ]
            },
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                labelWidth: 100,
                valueFieldName:'ITEM_MAKER',
                textFieldName:'CUSTOM_NAME',
                allowBlank: true
            }),{
                xtype: 'button',
                text: '기안',
                margin: '0 0 2 120',
                width: 60,
                handler : function(records) {
                    if(masterForm.setAllFieldsReadOnly(true) == false){
                        return false;
                    } else {
                        UniAppManager.app.requestApprove();
                        UniAppManager.app.onQueryButtonDown();
                    }
                }
            }
        ],
        api: {
            load: 's_bpr110rkrv_kdService.selectMaster'
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

    var masterForm2 = Unilite.createSearchForm('masterFormForm2', {
        disabled :false
        , title : '폐기현황표'
        , flex:1
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
        , items :[
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                valueFieldName:'ITEM_MAKER',
                textFieldName:'CUSTOM_NAME',
                allowBlank: true
            }),{
                fieldLabel: '폐기시작일',
                name: 'FR_YYMMDD',
                xtype: 'uniDatefield',
//                value: UniDate.get('startOfMonth'),
                allowBlank: true
            },{
                fieldLabel: '폐기종료일',
                name: 'TO_YYMMDD',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                allowBlank: false
            },{
                xtype: 'button',
                text: '기안',
                margin: '0 0 2 120',
                width: 60,
                handler : function(records) {
                    if(masterForm2.setAllFieldsReadOnly(true) == false){
                        return false;
                    } else {
                        UniAppManager.app.requestApprove2();
                        UniAppManager.app.onQueryButtonDown();
                    }
                }
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

    var tab = Unilite.createTabPanel('tabPanel',{
        items: [
             masterForm,
             masterForm2
        ],
        listeners: {
            beforetabchange : function(tabPanel, newCard, oldCard, eOpts) {
                var newTabId = newCard.getId();
                    console.log("newCard:  " + newCard.getId());
                    console.log("oldCard:  " + oldCard.getId());

                switch(newTabId) {
                    case 'masterFormForm':

                        break;

                    case 'masterFormForm2':

                    default:
                        break;
                }
            }
         }
    });

    Unilite.Main ({
		items:[tab],
		id: 's_bpr110rkrv_kdApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			this.setDefault();
		},
		onQueryButtonDown: function() {

			 var activeTabId = tab.getActiveTab().getId();
			 if(activeTabId == 'masterFormForm'){
				var param= masterForm.getValues();
	                masterForm.uniOpt.inLoading = true;
	                Ext.getBody().mask('로딩중...','loading-indicator');
	                masterForm.getForm().load({
	                    params: param,
	                    success:function(form, action)  {
	                   	 	console.log(action.result.data);
	                        masterForm.setValue('txt10',action.result.data.FLD_10 );
	                        masterForm.setValue('txt7',action.result.data.FLD_7 );
	                        masterForm.setValue('txt5',action.result.data.FLD_5 );
	                    	Ext.getBody().unmask();
	                        masterForm.uniOpt.inLoading = false;
	                    },
	                     failure: function(batch, option) {
	                        Ext.getBody().unmask();
	                     }
	                })
				 }

            },
		setDefault: function() {
        	masterForm.setValue('BASE_OUT_YEAR', '10');
            masterForm.setValue('radioSelect1', '');
            masterForm.setValue('radioSelect2', '');
//            masterForm2.setValue('FR_YYMMDD', UniDate.get('startOfMonth'));
            masterForm2.setValue('TO_YYMMDD', UniDate.get('today'));
			UniAppManager.setToolbarButtons('save', false);

			 var activeTabId = tab.getActiveTab().getId();
			 if(activeTabId == 'masterFormForm'){
				 var param= masterForm.getValues();
	                masterForm.uniOpt.inLoading = true;
	                Ext.getBody().mask('로딩중...','loading-indicator');

	                masterForm.getForm().load({
	                    params: param,
	                    success:function(form, action)  {
                   	 		console.log(action.result.data);
	                        masterForm.setValue('txt10',action.result.data.FLD_10 );
	                        masterForm.setValue('txt7',action.result.data.FLD_7 );
	                        masterForm.setValue('txt5',action.result.data.FLD_5 );
	                    	Ext.getBody().unmask();
	                        masterForm.uniOpt.inLoading = false;

	                    },
	                     failure: function(batch, option) {
	                    	 Ext.getBody().unmask();
	                     }
	                })
			 }
		},
        requestApprove: function(){     //결재 요청
            var winWidth=1300;
            var winHeight=750;

            var frm              = document.f1;
            var baseEndYymmdd    = UniDate.getDbDateStr(masterForm.getValue('BASE_END_YYMMDD'));
            var prtGubun         = Ext.getCmp('radioSelect1').getChecked()[0].inputValue;
            var baseOutYear      = masterForm.getValue('BASE_OUT_YEAR');
            var baseGubun        = Ext.getCmp('radioSelect2').getChecked()[0].inputValue;
            var itemMaker        = masterForm.getValue('ITEM_MAKER');
            var spText           = 'EXEC omegaplus_kdg.UNILITE.USP_GW_BOUT01 ' + "'" + baseEndYymmdd + "'" + ', ' + "'" + prtGubun + "'" + ', ' + "'" + baseOutYear + "'" + ', ' + "'" + baseGubun + "'" + ', ' + "'" + itemMaker + "'";
            var spCall           = encodeURIComponent(spText);

            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_bpr110rkrv_kd_tab1&draft_no=" + 0 + "&sp=" + spCall;
            frm.target   = "cardviewer";
            frm.method   = "post";
            frm.submit();


        },
        requestApprove2: function(){     //결재 요청
            var winWidth=1300;
            var winHeight=750;

            var frm         = document.f1;
            var itemMaker   = masterForm2.getValue('ITEM_MAKER');
            var fryymmdd    = '';

            if (UniDate.getDbDateStr(masterForm2.getValue('FR_YYMMDD')) != null)
              fryymmdd    = UniDate.getDbDateStr(masterForm2.getValue('FR_YYMMDD'));

            var toyymmdd    = ""+ UniDate.getDbDateStr(masterForm2.getValue('TO_YYMMDD'));
            var spText      = 'EXEC omegaplus_kdg.UNILITE.USP_GW_BOUT02 ' + "'" + itemMaker + "'" + ', ' + "'" + fryymmdd + "'" + ', ' + "'" + toyymmdd + "'";
            var spCall      = encodeURIComponent(spText);

            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_bpr110rkrv_kd_tab2&draft_no=" + 0 + "&sp=" + spCall;
            frm.target   = "cardviewer";
            frm.method   = "post";
            frm.submit();


        }
	});
}
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>