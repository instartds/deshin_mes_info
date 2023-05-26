<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa430rkrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="ssa430rkrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
	function appMain(){
		var panelSearch = Unilite.createSearchForm('searchForm',{
			region: 'center',
			layout : {type : 'uniTable', columns : 1},
			padding:'1 1 1 1',
			border:true,
			items:[{
				fieldLabel:'<t:message code="system.label.sales.division" default="사업장"/>',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				name:'DIV_CODE',
				allowBlank:false,
				value: UserInfo.divCode
			},{
        		fieldLabel:'<t:message code="system.label.sales.salesdate" default="매출일"/>',
        		xtype: 'uniDateRangefield',
        		startFieldName: 'FR_DATE',
        		endFieldName:'TO_DATE',
        		width:315,
        		startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
				valueFieldName: 'CUSTOM_CODE'
			}),
			{
	    		fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
		    	name:'AGENT_TYPE',
		    	comboType:'AU',
		    	xtype: 'uniCombobox', 
		    	comboCode:'B055'
			},{
	    		fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
		    	name:'AREA_TYPE',
		    	comboType:'AU',
		    	xtype: 'uniCombobox', 
		    	comboCode:'B056'
			},{
				xtype: 'radiogroup',		            		
        		fieldLabel: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',
    			items: [{
    				boxLabel: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',  
    				name: 'rdoSelect1', 
                    width:70,
    				inputValue: 'S', 
    				checked: true 
    			},{
    				boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>', 
    				name: 'rdoSelect1' , 
    				inputValue: 'T'
    			}],
    			listeners:{
					change : function(radioGroup, newValue, oldValue, eOpts){
						if(newValue.rdoSelect1 == "S"){
							panelSearch.setValue('MONEY_UNIT', '');
                            panelSearch.getField("MONEY_UNIT").setDisabled(true);
						}else{
							panelSearch.getField("MONEY_UNIT").setDisabled(false);
						}
					}
				}
			},{
        		fieldLabel: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
        		name:'MONEY_UNIT',
        		xtype: 'uniCombobox',
        		comboType:'AU',
        		comboCode:'B004',
        		displayField: 'value',
        		fieldStyle: 'text-align: center;'
        	}]
		});
		Unilite.Main({
			borderItems:[{
				region:'center',
				layout: 'border',
				border: true,
				items:[
					panelSearch
				]}
			],
			id  : 'ssa430rkrvApp',
			fnInitBinding : function() {
				UniAppManager.setToolbarButtons('print',true);
				UniAppManager.setToolbarButtons('query',false);
				
				panelSearch.getField("MONEY_UNIT").setDisabled(true);
				panelSearch.getField('rdoSelect1').setValue("S");
				panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
                panelSearch.setValue('TO_DATE',UniDate.get('today'));
			},
			onResetButtonDown: function() {
				panelSearch.clearForm();
				this.fnInitBinding();
			},
			onPrintButtonDown: function() {
                if(!panelSearch.getInvalidMessage()) return;   //필수체크
				var param = panelSearch.getValues();
				param["PGM_ID"]='ssa430rkrv';
				param["sTxtValue2_fileTitle"]="출력일자변경";
				param["DIV_NAME"]=panelSearch.getField('DIV_CODE').getRawValue();
				if(param.rdoSelect1=='S'){
					param["tradeYN"]='S'
				}else{
					param["tradeYN"]='T'
				}
				var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/sales/ssa430crkrv.do',
                    prgID: 'ssa430rkrv',
                    extParam: param
                });
				win.center();
				win.show();
			}
		});
	}
</script>