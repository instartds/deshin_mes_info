<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms200rkrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mms200rkrv"  />
	<t:ExtComboStore comboType="AU" comboCode="S801" />
	<t:ExtComboStore comboType="AU" comboCode="S802" />
	<t:ExtComboStore comboType="AU" comboCode="S804" />
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
	    	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox', 
	    	comboType:'BOR120', 
	    	allowBlank:false,
	    	value: UserInfo.divCode,
	    	child: 'WH_CODE',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
    	},{
    		fieldLabel: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
    		xtype: 'uniDateRangefield',
    		startFieldName: 'DATE_FR',
    		endFieldName: 'DATE_TO',
    		allowBlank:false,
    		startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
    		width:315,
    		
    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    }
		},Unilite.popup('CUST',{
            fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelResult.setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelResult.setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
				}	
        }),{
			fieldLabel: '<t:message code="system.label.purchase.podivision" default="발주구분"/>',
			name: 'ORDER_TYPE',
			xtype:'uniCombobox',
			comboType:'AU', 
//			padding:5,
			comboCode:'M001',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					
				}
			}
		}]
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
		id  : 'map130rkrvApp',
		fnInitBinding : function() {

			panelResult.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_TO',UniDate.get('today'));

			
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
				
				param["sTxtValue2_fileTitle"]='<t:message code="system.label.purchase.importinspectionbadstatus" default="수입검사불량현황"/>';
				param["RPT_ID"]='mms200rkrv';
				param["PGM_ID"]='mms200rkrv';
        		
				var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/matrl/mms200crkrv.do',
                    prgID: 'mms200rkrv',
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
					var labelText = invalid.items[0]['fieldLabel']+':';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
				}
	
			   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
			   	invalid.items[0].focus();
			}
			
			return r;
	    }
	});
};

</script>
