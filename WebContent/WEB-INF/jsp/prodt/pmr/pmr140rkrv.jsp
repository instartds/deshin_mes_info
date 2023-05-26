<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr140rkrv"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="W" /><!-- 작업장  -->
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
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.product.reporttype" default="보고서유형"/>',						            		
				items: [{
					boxLabel: '<t:message code="system.label.product.workorderper" default="작업지시별"/>', 
					width: 90, 
					name: 'rdoPrintItem',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.product.workorderrouting" default="작업지시공정별"/>', 
					width: 120,
					name: 'rdoPrintItem',
					inputValue: '2'
				}]
		},{	    
	    	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox', 
	    	comboType:'BOR120', 
	    	allowBlank:false,
	    	value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {	
					panelResult.setValue('WORK_SHOP_CODE','');					
				}
			}
    	},{	    
	    	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
	    	name:'WORK_SHOP_CODE',
	    	xtype: 'uniCombobox', 
	    	allowBlank:false,
	    	comboType:'W',
			listeners: {
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    store.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                    }else{
                        store.filterBy(function(record){
                            return false;   
                        });
                    }
                }
			}
	    	
    	},{
    		fieldLabel: '<t:message code="system.label.product.workday" default="작업일"/>',
    		xtype: 'uniDatefield',
	        name: 'PRODT_DATE',
	        allowBlank:false,
	        value: UniDate.get('today')
		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.product.printcondition" default="출력조건"/>',						            		
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>', 
					width: 50, 
					name: 'opt',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.product.productionstatus" default="생산현황"/>', 
					width: 70,
					name: 'opt',
					inputValue: '2'
				},{
					boxLabel : '<t:message code="system.label.product.defectstatus" default="불량현황"/>', 
					width: 70,
					name: 'opt',
					inputValue: '3'
				},{
					boxLabel : '<t:message code="system.label.product.specialremarkstatus" default="특기사항현황"/>', 
					width: 100,
					name: 'opt',
					inputValue: '4'
				},{
					boxLabel : '<t:message code="system.label.product.employeestatusentry" default="인원현황등록"/>', 
					width: 100,
					name: 'opt',
					inputValue: '5'
				}]
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
		id  : 'pmr140rkrvApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);

			
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
				if(param.rdoPrintItem==1){
					param.sPrintFlag = "WKORDNUM";
					param["10 sTxtValue2_fileTitle"]='작업일보현황(작업지시별)';
					
				}else{
					param.sPrintFlag = "PROGWORK";
					param["10 sTxtValue2_fileTitle"]='작업일보현황(공정별)';
				}
				param["PGM_ID"]='pmr140rkrv';
				
        		
				var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/prodt/pmr140crkrv.do',
                    prgID: 'pmr140rkrv',
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
					var labelText = invalid.items[0]['fieldLabel']+' : ';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
				}
	
			   	alert(labelText+Msg.sMB083);
			   	invalid.items[0].focus();
			}
			
			return r;
	    }
	});
};

</script>
