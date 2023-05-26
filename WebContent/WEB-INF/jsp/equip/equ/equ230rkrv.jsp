<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ230rkrv"  >
	<t:ExtComboStore comboType="BOR120" /> 					 	 <!-- 사업장 -->  
</t:appConfig>
<script type="text/javascript" >
function appMain() {   
	var panelResult = Unilite.createSearchForm('equ230rkrvForm', {
		region: 'center',
		padding:'1 1 1 1',
		border:false, 
	 	layout : {type : 'uniTable', columns : 1},
    	items :[{
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank: false,
            value: UserInfo.divCode
        },
        {
            fieldLabel: '제작년월',
            xtype: 'uniDateRangefield',
            startFieldName: 'FR_DATE',
            endFieldName: 'TO_DATE',
//            startDate: UniDate.get('aMonthAgo'),
//            endDate: UniDate.get('today'),
            width: 315
//            allowBlank: false
        },
        
        Unilite.popup('EQU_CODE', {
            fieldLabel: '장비(금형)번호',
            valueFieldName: 'EQU_CODE',
            textFieldName: 'EQU_NAME',
            allowBlank: false,
            listeners: {
                applyextparam: function(popup){
                    popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                }
            }
        }),
        {
            fieldLabel: '자산번호',
            xtype: 'uniTextfield',
            name: 'ASSETS_NO'
        },
        Unilite.popup('CUST', {
            fieldLabel: '제작처',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,            
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
			listeners: {
				onValueFieldChange:function( elm, newValue, oldValue) {	
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange:function( elm, newValue, oldValue) {					
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}            
            
        })]
	});
	
	Unilite.Main( {
	 	border: false,
	 	items: [panelResult],
		id : 'equ230rkrvApp',
		fnInitBinding : function(param) {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//            panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
//            panelResult.setValue('TO_DATE', UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown : function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			var param = panelResult.getForm().getValues();
            param["sTxtValue2_fileTitle"]='금형이력카드';
			param["PGM_ID"]= PGM_ID;
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/equit/eqt220crkrv.do',
                prgID: 'equ230rkrv',
                extParam: param
            });
			win.center();
			win.show();
		}
	});
};
</script>

