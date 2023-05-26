<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_ssa904rkrv_kd"  >
<t:ExtComboStore comboType="BOR120" pgmId="s_ssa904rkrv_kd"/> 			<!-- 사업장 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    var groupUrl =  '${groupUrl}'; //그룹웨어 호출 url

	var panelSearch = Unilite.createForm('biv150ukrv', {
		disabled :false
        , flex:1
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{
					fieldLabel: '사업장',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank: false
				},{
                    fieldLabel: '기준년월',
                    xtype: 'uniMonthRangefield',
                    startFieldName: 'FR_MONTH',
                    endFieldName: 'TO_MONTH',
                    allowBlank: false
                },{
			    	xtype: 'container',
			    	padding: '10 0 0 0',
			    	layout: {
			    		type: 'hbox',
						align: 'center',
						pack:'center'
			    	},
			    	items:[{
			    		xtype: 'button',
			    		text: '기안',
			    		id:'GW',
		    			width: 60,
						handler : function(records) {

                            if(!panelSearch.setAllFieldsReadOnly(true)){
                                return false;
                            }

                            var startMonth  = UniDate.getDbDateStr(panelSearch.getValue('FR_MONTH'));
                            var endMonth    = UniDate.getDbDateStr(panelSearch.getValue('TO_MONTH'));

                            if(startMonth.substring(0, 4) != endMonth.substring(0, 4)) {
                                alert('기준년월은 같은 년도여야 합니다.');
                                return false;
                            }

                            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

                            var frm         = document.f1;
                            var compCode    = UserInfo.compCode;
                            var divCode     = panelSearch.getValue('DIV_CODE');
                            var frMonth     = UniDate.getDbDateStr(panelSearch.getValue('FR_MONTH'));
                            var toMonth     = UniDate.getDbDateStr(panelSearch.getValue('TO_MONTH'));
                            var gubun1      = 'M';
                            var gubun2      = 'D';
                            var spText1     = 'EXEC omegaplus_kdg.unilite.USP_GW_S_SSA904RKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + frMonth + "'" + ', ' + "'" + toMonth + "'" + ', ' + "'" + gubun1 + "'";
                            var spText2     = 'EXEC omegaplus_kdg.unilite.USP_GW_S_SSA904RKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + frMonth + "'" + ', ' + "'" + toMonth + "'" + ', ' + "'" + gubun2 + "'";
                            var spCall      = encodeURIComponent(spText1 + "^" + spText2);

//                //            frm.action = '/payment/payreq.php';
//                            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ssa904rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//                //            frm.action   = groupUrl + "&prg_no=s_ssa904rkrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
//                            frm.target   = "payviewer";
//                            frm.method   = "post";
//                            frm.submit();

                           var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ssa904rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;
							console.log(gwurl);
                            UniBase.fnGw_Call(gwurl,frm,'');

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
		id: 's_ssa904rkrv_kdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('FR_MONTH',UniDate.get('startOfMonth'));
            panelSearch.setValue('TO_MONTH',UniDate.get('today'));
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
