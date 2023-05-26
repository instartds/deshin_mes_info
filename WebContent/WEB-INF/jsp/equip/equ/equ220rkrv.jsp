<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ220rkrv">
    <t:ExtComboStore comboType="BOR120" pgmId="equ220rkrv" /> <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
    #search_panel1 .x-panel-header-text-container-default {
        color: #333333;
        font-weight: normal;
        padding: 1px 2px;
    }

    .x-change-cell_light_Yellow {
       background-color: #FFFFA1;
    }

    .x-change-cell_yellow {
        background-color: #FAED7D;
    }
</style>
<script type="text/javascript">
    function appMain() {
        var panelSearch = Unilite.createSearchForm('equ220rkrvForm', {
        	region: 'center',
            padding: '1 1 1 1',
            border: false,
            layout: {
                type: 'uniTable',
                columns: 1
            },
            items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank: false,
                value: UserInfo.divCode
            },{
                fieldLabel: '제작년월',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DATE',
                endFieldName: 'TO_DATE',
                startDate: UniDate.get('aMonthAgo'),
                endDate: UniDate.get('today'),
                width: 315,
                allowBlank: false
            },
            Unilite.popup('EQU_CODE', {
                fieldLabel: '장비(금형)번호',
                valueFieldName: 'EQU_CODE',
                textFieldName: 'EQU_NAME',
                validateBlank: false,
                listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('EQU_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('EQU_CODE', '');
						}
					},
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                    }
                }
            }),
            {
                fieldLabel: '자산번호',
                xtype: 'uniTextfield',
                name: 'ASSETS_NO'
            },
            Unilite.popup('CUST', {
                fieldLabel: '보관처',
                valueFieldName: 'CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME',
                validateBlank: false,
                listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					}
				}
            })
            ]
        });

        Unilite.Main({
            border: false,
            items: [
                panelSearch
            ],

            id: 'equ220rkrvApp',
            fnInitBinding: function () {
                panelSearch.setValue('DIV_CODE', UserInfo.divCode);
                
                UniAppManager.setToolbarButtons('query', false);
                UniAppManager.setToolbarButtons('print', true);

                /*if (!Ext.isEmpty(params && params.PGM_ID)) {
                    this.processParams(params);
                }*/
            },
            onPrintButtonDown: function () {
                if(!panelSearch.getInvalidMessage()) return;   //필수체크
                var param = panelSearch.getValues();
                param["sTxtValue2_fileTitle"]='금형보유현황';
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH + '/equit/equ220crkrv.do',
                    prgID: 'equ220rkrv',
                    extParam: param
                });
                win.center();
                win.show();
            },
            onResetButtonDown: function() { // 20210810 추가: 신규버튼 클릭 시 초기화
				panelSearch.clearForm();
	
				this.fnInitBinding();
			}
        });
    };
</script>