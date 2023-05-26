<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_ssa902rkrv_kd"  >
<t:ExtComboStore comboType="BOR120" pgmId="s_ssa902rkrv_kd"/> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="WB19" />                     <!--부서구분-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

	var panelSearch = Unilite.createForm('biv150ukrv', {
		disabled :false
        , flex:1
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{
					fieldLabel: '사업장',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
//					colspan:2,
					allowBlank: false
				},
				{
                    xtype: 'container',
                    layout: {type: 'uniTable', columns:2},
                    items:[{
                            fieldLabel: '매출년도',
                            name: 'FR_SALE_YEAR',
                            xtype: 'uniYearField',
                            value: new Date().getFullYear(),
                            allowBlank: false
                        },{
                            fieldLabel: '~',
                            name: 'TO_SALE_YEAR',
                            xtype: 'uniYearField',
                            value: new Date().getFullYear(),
                            labelWidth: 15
                        }
                    ]
                }
//				,{
//                    fieldLabel: '매출년도',
//                    name: 'FR_SALE_YEAR',
//                    xtype: 'uniYearField',
//                    value: new Date().getFullYear(),
//                    allowBlank: false
//                },{
//                    fieldLabel: '~',
//                    name: 'TO_SALE_YEAR',
//                    xtype: 'uniYearField',
//                    value: new Date().getFullYear()
//                }
                ,{
                    xtype:'button',           //필드 타입
                    text: '기안',
                    id: 'GW',
                    margin: '0 0 2 95',
    //                margin: '0 0 0 0',
                    width: 80,
                    handler : function() {
                        if(panelSearch.setAllFieldsReadOnly(true) == false){
                            return false;
                        } else if(Ext.isEmpty(panelSearch.getValue('TO_SALE_YEAR')) || panelSearch.getValue('TO_SALE_YEAR') == '0'){
                            alert('매출년도를 입력하십시오.');
                            return false;
                        }
                        else {
                            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

                            var frm         = document.f1;
                            var compCode    = UserInfo.compCode;
                            var divCode     = panelSearch.getValue('DIV_CODE');
                            var frsaleYear  = panelSearch.getValue('FR_SALE_YEAR');
                            var tosaleYear  = panelSearch.getValue('TO_SALE_YEAR');

                            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_SSA902RKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + frsaleYear + "'" + ', ' + "'" + tosaleYear + "'";
                            var spCall      = encodeURIComponent(spText);

//                //            frm.action = '/payment/payreq.php';
//                            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ssa902rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//                //            frm.action   = groupUrl + "&prg_no=s_ssa902rkrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
//                            frm.target   = "payviewer";
//                            frm.method   = "post";
//                            frm.submit();
                            var gwurl = groupUrl  + "viewMode=docuDraft" + "&prg_no=s_ssa902rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;

                            UniBase.fnGw_Call(gwurl,frm,'');
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
        }
	});

	Unilite.Main( {
		items:[panelSearch],
		id: 's_ssa902rkrv_kdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('FR_SALE_YEAR',new Date().getFullYear());
            panelSearch.setValue('TO_SALE_YEAR',new Date().getFullYear());
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);

		}
	});

};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
