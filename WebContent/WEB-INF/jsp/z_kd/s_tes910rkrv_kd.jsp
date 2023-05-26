<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_tes910rkrv_kd"  >
<t:ExtComboStore comboType="BOR120" pgmId="s_tes910rkrv_kd"/> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="WB19" />                     <!--부서구분-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     
    gsMoneyUnit : '${gsMoneyUnit}'
};

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
					allowBlank: false
				},{
                    fieldLabel: '기준년월',
                    name:'BASE_MONTH',
                    xtype: 'uniMonthfield',
                    value: UniDate.get('today'),
                    allowBlank:false
                },      
                Unilite.popup('AGENT_CUST', {
                        fieldLabel: '거래처', 
                        valueFieldName: 'CUSTOM_CODE',
                        textFieldName: 'CUSTOM_NAME',
                        hidden : false
                }),{
                    fieldLabel: '화폐', 
                    name: 'MONEY_UNIT', 
                    xtype: 'uniCombobox', 
                    comboType: 'AU', 
                    comboCode: 'B004',
                    allowBlank: false,
                    hidden : true,
                    displayField: 'value',
                    fieldStyle: 'text-align: center;'
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
			    		id: 'GW',
		    			width: 60,							   	
						handler : function(records) {
							
                            if(!panelSearch.setAllFieldsReadOnly(true)){
                                return false;
                            }
                            
                            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
                            
                            var frm         = document.f1;
                            var compCode    = UserInfo.compCode;
                            var divCode     = panelSearch.getValue('DIV_CODE');
                            var baseMonth   = UniDate.getDbDateStr(panelSearch.getValue('BASE_MONTH'));
                            var customCode  = panelSearch.getValue('CUSTOM_CODE');
                            var moneyUnit   = panelSearch.getValue('MONEY_UNIT');
                            
                            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_TES910RKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + baseMonth + "'" + ', ' + "'" + customCode + "'";
                            var spCall      = encodeURIComponent(spText);
                            
//                //            frm.action = '/payment/payreq.php';
//                            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_tes910rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//                //            frm.action   = groupUrl + "&prg_no=s_tes910rkrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
//                            frm.target   = "payviewer"; 
//                            frm.method   = "post";
//                            frm.submit();
                            
                            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_tes910rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;

                            UniBase.fnGw_Call(gwurl,frm,''); /*end*/


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
		id: 's_tes910rkrv_kdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('BASE_MONTH', UniDate.get('today'));
            panelSearch.setValue('CUSTOM_CODE', '13301');
            panelSearch.setValue('CUSTOM_NAME', '청도KDG');
            panelSearch.setValue('MONEY_UNIT', 'USD');
            
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
