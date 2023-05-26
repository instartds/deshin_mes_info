<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_pmd902rkrv_kd"  >
<t:ExtComboStore comboType="BOR120" pgmId="s_pmd902rkrv_kd"/> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="WB08" />                     <!--금형구분-->
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
					allowBlank: false
				},
				Unilite.popup('PROG_WORK_CODE', { 
                fieldLabel: '공정', 
                valueFieldName: 'PROG_WORK_CODE',
                textFieldName: 'PROG_WORK_NAME',
                valueFieldWidth: 100,
                textFieldWidth: 200,
//              allowBlank: false,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE' : panelSearch.getValue('DIV_CODE')});
                    }
                }
                }),
                Unilite.popup('MOLD_CODE',{ 
                        fieldLabel: '금형',
                        valueFieldName:'FR_MOLD_CODE',
                        textFieldName:'FR_MOLD_NAME',
                        valueFieldWidth: 100,
                        textFieldWidth: 200,
                        autoPopup:true,
                        listeners: {
                            applyextparam: function(popup){                         
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            }
                        }
                }),
                Unilite.popup('MOLD_CODE',{ 
                        fieldLabel: '~',
                        valueFieldName:'TO_MOLD_CODE',
                        textFieldName:'TO_MOLD_NAME',
                        valueFieldWidth: 100,
                        textFieldWidth: 200,
                        autoPopup:true,
                        listeners: {
                            applyextparam: function(popup){                         
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            }
                        }
                }),{
                    xtype: 'radiogroup',
                    fieldLabel: '출력방법',
                    id: 'rdoSelect',
                    items : [{
                        boxLabel: '금형순',
                        width: 60,
                        name: 'ORDER_BY',
                        checked: true,
                        inputValue: '1'
                    },{
                        boxLabel: '점검율순',
                        width: 70,
                        name: 'ORDER_BY',
                        inputValue: '2'
                    }]/*,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            if (Ext.getCmp('rdoSelect').getValue().GUBUN == '1') {
                                var workShopPopupId = Ext.getCmp('workShopId');
                                var customPopupId = Ext.getCmp('customId');
                                workShopPopupId.setVisible(true);
                                customPopupId.setVisible(false);
                            } else {
                                var workShopPopupId = Ext.getCmp('workShopId');
                                var customPopupId = Ext.getCmp('customId');
                                customPopupId.setVisible(true); 
                                workShopPopupId.setVisible(false);
                            }
                        }
                    }   */
                }
                ,{
                    fieldLabel: '출력범위(%)',
                    name:'OCCU_RATE',  
                    xtype: 'uniNumberfield',
                    value: 0,
                    decimalPrecision: 2
                }
                ,{
                    fieldLabel: '금형구분',
                    name:'MOLD_TYPE',  
                    xtype: 'uniCombobox', 
                    comboType:'AU',
                    comboCode:'WB08'
                }
                ,{
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
                            
                            var frm             = document.f1;
                            var compCode        = UserInfo.compCode;
                            var divCode         = panelSearch.getValue('DIV_CODE');
                            
                            if(Ext.isEmpty(panelSearch.getValue('PROG_WORK_CODE'))) {
                                var progWorkCode = '';
                            } else {
                                var progWorkCode = panelSearch.getValue('PROG_WORK_CODE');
                            }
                            
                            if(Ext.isEmpty(panelSearch.getValue('FR_MOLD_CODE'))) {
                                var frMoldCode = '';
                            } else {
                                var frMoldCode = panelSearch.getValue('FR_MOLD_CODE');
                            }
                            
                            if(Ext.isEmpty(panelSearch.getValue('TO_MOLD_CODE'))) {
                                var toMoldCode = '';
                            } else {
                                var toMoldCode = panelSearch.getValue('TO_MOLD_CODE');
                            }
                            
                            var orderBy         = Ext.getCmp('rdoSelect').getValue().ORDER_BY;
                            
                            if(Ext.isEmpty(panelSearch.getValue('OCCU_RATE'))) {
                                var occuRate = '0';
                            } else {
                                var occuRate = panelSearch.getValue('OCCU_RATE');
                            }
                            
                            if(Ext.isEmpty(panelSearch.getValue('MOLD_TYPE'))) {
                                var moldType = '0';
                            } else {
                                var moldType = panelSearch.getValue('MOLD_TYPE');
                            }
                            
                            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_PMD902RKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + progWorkCode + "'" + ', ' + "'" + frMoldCode + "'" + ', ' + "'" + toMoldCode + "'" + ', ' + "'" + orderBy + "'" + ', ' + "'" + occuRate + "'" + ', ' + "'" + moldType + "'";
                            var spCall      = encodeURIComponent(spText);
                            
           /*      //            frm.action = '/payment/payreq.php';
                            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_pmd902rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;
                //            frm.action   = groupUrl + "&prg_no=s_pmd902rkrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
                            frm.target   = "payviewer"; 
                            frm.method   = "post";
                            frm.submit(); */
							
                            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_pmd902rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;
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
		id: 's_pmd902rkrv_kdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
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
