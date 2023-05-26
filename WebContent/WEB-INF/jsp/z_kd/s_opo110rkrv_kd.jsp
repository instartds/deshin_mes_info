<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_opo110rkrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_opo110rkrv_kd"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
//    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },
        Unilite.popup('CUST', {
            fieldLabel: '거래처',
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
            extParam: {'CUSTOM_TYPE': ['1','2']}
        }),{
            fieldLabel: '발주일',
            xtype: 'uniDateRangefield',
            startFieldName: 'ORDER_DATE_FR',
            endFieldName: 'ORDER_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
        },
          {
            fieldLabel: '구매담당',
            name:'ORDER_PRSN',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'M201'
        }, {
            fieldLabel: '양식구분',
            name: 'FORM',
            id: 'formGubun',
            xtype: 'uniRadiogroup',             
            allowBlank: false,
            colspan:2,
            layout: {type: 'table', columns : 2},
            items: [
                {
                    boxLabel  : '한글',
                    name      : 'FORM',
                    inputValue: '1',
                    width: 60,
                    checked: true
                }, {
                    boxLabel  : '영문',
                    name      : 'FORM',
                    inputValue: '2'
                }
            ]
        },{
            fieldLabel: '담당자',
            name:'FROM_PRSN',
            xtype: 'uniTextfield',             
            allowBlank: false,
            width: 300,
            value : '오 원 석 전무 / 경영지원본부장'
        }
        ]
    });		

    
    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}	
		],	
		id  : 's_opo110rkrv_kdApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
        onPrintButtonDown: function() {
        	if(this.onFormValidate()){
				var param = panelResult.getValues();
				var win = Ext.create('widget.CrystalReport', {
					url: CPATH+'/z_kd/s_opo110crkrv_kd.do',
					prgID: 's_opo110crkrv_kd',
						extParam: param
					});
					win.center();
					win.show();
        	}
		},
	    onFormValidate: function(){
	    	var r= true
	        var invalid = panelResult.getForm().getFields().filterBy(
	     		function(field) {
					return !field.validate();
				}
		    );
   	
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
			}
			return r;
	    }
	});
};

</script>
