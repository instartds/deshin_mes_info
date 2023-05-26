<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr520rkrv">
    <t:ExtComboStore comboType="BOR120" pgmId="bpr520rkrv" /> <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
    #search_panel1 .x-panel-header-text-container-default {
        color: #333333;
        font-weight: normal;
        padding: 1px 2px;
    }
</style>
<script type="text/javascript">
    function appMain() {
        var panelSearch = Unilite.createSearchForm('bpr520rkrvForm', {
            region: 'center',
            padding: '1 1 1 1',
            border: true,
            layout: {
                type: 'uniTable',
                columns: 1
            },
            defaults:{
            	labelWidth:100
            	
            },
            items: [{
                fieldLabel: '<t:message code="system.label.base.reporttype" default="보고서유형"/>',
                xtype: 'uniRadiogroup',
                allowBlank: false,
                width: 235,
                items: [{
                    boxLabel: '<t:message code="system.label.base.explosion" default="정전개"/>',
                    name: 'DISPLAY_TYPE',
                    inputValue: '1',
                    checked: true,
                    width: 100
                }, {
                    boxLabel: '<t:message code="system.label.base.implosion" default="역전개"/>',
                    name: 'DISPLAY_TYPE',
                    inputValue: '2',
                    width: 100
                }],
				listeners:{
					change : function(radioGroup, newValue, oldValue, eOpts){
						if(newValue.DISPLAY_TYPE == 1){
							var itemAccnt1 = Ext.getCmp('itemAccnt1');
							var itemAccnt2 = Ext.getCmp('itemAccnt2');
							itemAccnt1.setHidden(false);
							itemAccnt2.setHidden(false);
						}else{
							var itemAccnt1 = Ext.getCmp('itemAccnt1');
							var itemAccnt2 = Ext.getCmp('itemAccnt2');
							
							panelSearch.setValue('ITEM_ACCNT_10',0);
                            panelSearch.setValue('ITEM_ACCNT_20',0);
							itemAccnt1.setHidden(true);
							itemAccnt2.setHidden(true);
						}
					}
				}
            }, {
                fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank: false
            }, {
                fieldLabel: '<t:message code="system.label.base.itemprint" default="제품인쇄"/>',
                id: 'itemAccnt1',
                name: 'ITEM_ACCOUNT_10',
                xtype: 'checkbox',
                inputValue: 10,
                uncheckedValue: 0
            }, {
                fieldLabel: '<t:message code="system.label.base.halfitemprint" default="반제품인쇄"/>',
                id: 'itemAccnt2',
                name: 'ITEM_ACCOUNT_20',
                xtype: 'checkbox',
                inputValue: 20,
                uncheckedValue: 0
            }, 
            Unilite.popup('DIV_PUMOK', {
                fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
                validateBlank: false,
                valueFieldName: 'ITEM_CODE',
                textFieldName: 'ITEM_NAME',
                allowBlank: false
            })
            ]

        });

        Unilite.Main({
            border: false,
            items: [
                panelSearch
            ],
            id: 'bpr520rkrvApp',
            fnInitBinding: function (params) {
                panelSearch.setValue('DIV_CODE', UserInfo.divCode);
                UniAppManager.setToolbarButtons(['query','reset'], false);
                UniAppManager.setToolbarButtons('print', true);
            },
            onPrintButtonDown: function () {
            	if(!panelSearch.getInvalidMessage()) return;   //필수체크
                    var param = panelSearch.getValues();
                    var win = Ext.create('widget.CrystalReport', {
                        url: CPATH + '/base/bpr520crkrv.do',
                        prgID: 'bpr520rkrv',
                        extParam: param
                    });
                    win.center();
                    win.show();
            }
        });
    };
</script>