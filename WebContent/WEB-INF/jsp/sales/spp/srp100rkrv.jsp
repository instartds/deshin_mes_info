<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srp100rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="srp100rkrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위-->
		<t:ExtComboStore comboType="AU" comboCode="S148" /> <!-- 화폐단위-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell_light_Yellow {
background-color: #FFFFA1;
}

.x-change-cell_yellow {
background-color: #FAED7D;
}

</style>
<script type="text/javascript" >

function appMain() {

	var panelSearch = Unilite.createSearchForm('srp100rkrForm', {
		region: 'center',
    	disabled :false,
    	border: false,
    	flex:1,
    	layout: {
	    	type: 'uniTable',
			columns:1
	    },
	    defaults:{
	    	width:325,
			labelWidth:120
	    },
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:400,
		items : [
			{
		    	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox',
		    	comboType:'BOR120',
		    	allowBlank:false,
		    	value: UserInfo.divCode
	    	},{
				fieldLabel: '견적확정구분',
			 	xtype: 'radiogroup',
			 	items:[{
			 		boxLabel:'진행',
			 		name: 'ESTI_TYPE',
			 		inputValue: '1',
			 		checked: true
			 	},{
			 		boxLabel:'확정',
			 		name:'ESTI_TYPE',
			 		inputValue: '2'
			 	}]
			},{
                fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'  ,
                name: 'ESTI_PRSN',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'S010'
            },{
                fieldLabel: '견적일',
                name: 'ESTI_DATE',
	            xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: new Date(),
				width: 350
            },{
				fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
				name: 'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B055'
			},{
    			fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
    			name:'AREA_TYPE',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'B056'
    		},{
    			fieldLabel: '견적번호',
    			name: 'ESTI_NUM',
    			xtype: 'uniTextfield'
            },Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),{
    			fieldLabel: '견적건명',
    			name: 'ESTI_NAME',
    			xtype: 'uniTextfield'
            },{
				fieldLabel: '부가세 포함여부',
    		 	xtype: 'radiogroup',
    		 	items:[{
    		 		boxLabel:'별도',
    		 		name: 'TAX_YN',
    		 		inputValue: 'Y'

    		 	},{
    		 		boxLabel:'포함',
    		 		name:'PRINT_YN',
    		 		inputValue: 'N',
    		 		checked: true
    		 	}]
    		},{
				fieldLabel: '고객담당자 인쇄여부',
    		 	xtype: 'radiogroup',
    		 	items:[{
    		 		boxLabel:'<t:message code="system.label.sales.yes" default="예"/>',
    		 		name: 'CUSTOM_PRSN_PRINT',
    		 		inputValue: 'Y'

    		 	},{
    		 		boxLabel:'<t:message code="system.label.sales.no" default="아니오"/>',
    		 		name:'CUSTOM_PRSN_PRINT',
    		 		inputValue: 'N',
    		 		checked: true
    		 	}]
    		},{
				fieldLabel: 'DC울 인쇄여부',
    		 	xtype: 'radiogroup',
    		 	items:[{
    		 		boxLabel:'<t:message code="system.label.sales.yes" default="예"/>',
    		 		name: 'DC_PRINT',
    		 		inputValue: 'Y'

    		 	},{
    		 		boxLabel:'<t:message code="system.label.sales.no" default="아니오"/>',
    		 		name:'DC_PRINT',
    		 		inputValue: 'N',
    		 		checked: true
    		 	}]
	    	}
		]
	});

	 Unilite.Main( {
	 	border: false,
	 	items:[
	 		panelSearch
	 		],

		id : 'srp100rkrApp',
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',true);

			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params);
            }


		},
        //링크로 넘어오는 params 받는 부분 (Agj100skr)
       /*  processParams: function(params) {
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'str103ukrv' || params.PGM_ID == 'str104ukrv') {
                panelSearch.setValue('INOUT_CODE'       , params.INOUT_CODE);
                panelSearch.setValue('INOUT_NUM'       , params.INOUT_NUM);
                panelSearch.setValue('DIV_CODE'       , params.DIV_CODE);
                panelSearch.setValue('INOUT_DATE'       , params.INOUT_DATE);
                panelSearch.setValue('CUSTOM_CODE'       , params.CUSTOM_CODE);
                panelSearch.setValue('CUSTOM_NAME'       , params.CUSTOM_NAME);
            }
        }, */
		onQueryButtonDown : function()	{
		},
		onDetailButtonDown:function() {
		},
		onPrintButtonDown: function() {
			if(this.onFormValidate()){
				var param= panelSearch.getValues();
				param.PGM_ID = PGM_ID;  //프로그램ID
				param.MAIN_CODE = 'S036'
				var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/sales/srp100clrkrv.do',
				prgID: 'srp100rkrv',
				extParam: param
				});
				win.center();
				win.show();
			}
		},
	    onFormValidate: function(){
	    	var r= true
	        var invalid = panelSearch.getForm().getFields().filterBy(
	     		function(field) {
					return !field.validate();
				}
		    );

			if(invalid.length > 0) {
				r=false;
				var labelText = ''

				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+' : ';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
				}

			   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
			   	invalid.items[0].focus();
			}
			return r;
	    }

	});
};


</script>
