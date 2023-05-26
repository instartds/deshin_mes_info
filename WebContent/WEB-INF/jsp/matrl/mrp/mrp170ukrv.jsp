<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="mrp170ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {   
    
	var panelSearch = Unilite.createForm('mrp170ukrvForm', {	
		disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        defaults: {labelWidth: 120},
		items :[{
				fieldLabel: '확정사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false
				},{
					xtype:'component', 
					html:'<b>[최근 ROP품목 소요량계산 내용]</b>',
					margin: '10 0 10 47',
					tdAttrs: {Style: 'text-align:left'}
				},{                 
                    fieldLabel: '수급계획 담당자',
                    name:'PLAN_PSRN',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'M201',
                    readOnly:true
                },{ 
	    			fieldLabel: '소요량 계산일',
	    			name: 'ROP_DATE',
					xtype: 'uniDatefield',
					value: UniDate.get('today'),
					allowBlank:false,
					readOnly: true
				},{ 
	    			fieldLabel: '가용재고반영 기준일',
					name: 'BASIC_DATE',
					xtype: 'uniDatefield',
					value: UniDate.get('today'),
					allowBlank:false,
					readOnly: true
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect2',
				    fieldLabel: '현재고 반영',
				    items : [{
				    	boxLabel: '예',
				    	name: 'STOCK_YN',
				    	inputValue: 'Y',
				    	readOnly: true,
				    	width:80,
				    	checked: true
				    }, {
				    	boxLabel: '아니오',
				    	name: 'STOCK_YN' ,
				    	inputValue: 'N',
				    	readOnly: true,
				    	width:80
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect3',
				    fieldLabel: '안전재고 반영',
				    items : [{
				    	boxLabel: '예',
				    	name: 'SAFE_STOCK_YN',
				    	inputValue: 'Y',
				    	readOnly: true,
				    	width:80
				    }, {
				    	boxLabel: '아니오',
				    	name: 'SAFE_STOCK_YN' ,
				    	inputValue: 'N',
				    	readOnly: true,
				    	width:80,
				    	checked: true
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect4',
				    fieldLabel: '입고예정 반영',
				    items : [{
				    	boxLabel: '예',
				    	name: 'INSTOCK_PLAN_YN',
				    	inputValue: 'Y',
				    	readOnly: true,
				    	width:80
				    }, {
				    	boxLabel: '아니오',
				    	name: 'INSTOCK_PLAN_YN' ,
				    	inputValue: 'N',
				    	readOnly: true,
				    	width:80,
				    	checked: true
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect5',
				    fieldLabel: '출고예정 반영',
				    items : [{
				    	boxLabel: '예',
				    	name: 'OUTSTOCK_PLAN_YN',
				    	inputValue: 'Y',
				    	readOnly: true,
				    	width:80
				    }, {
				    	boxLabel: '아니오',
				    	name: 'OUTSTOCK_PLAN_YN' ,
				    	inputValue: 'N',
				    	readOnly: true,
				    	width:80,
				    	checked: true
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect8',
				    fieldLabel: '외주재고 반영',
				    items : [{
				    	boxLabel: '예',
				    	name: 'CUSTOM_STOCK_YN',
				    	inputValue: 'Y',
				    	readOnly: true,
				    	width:80
				    }, {
				    	boxLabel: '아니오',
				    	name: 'CUSTOM_STOCK_YN' ,
				    	inputValue: 'N',
				    	readOnly: true,
				    	width:80,
				    	checked: true
				    }]				
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
			    		text: '실행',
			    		width: 100,
						handler : function() {
							//var rv = true;
							if(confirm(Msg.sMB063)) {
								var param = panelSearch.getValues();
								//var param= Ext.getCmp('mrp170ukrvForm').getValues();
								console.log("param",param)
								panelSearch.getEl().mask('로딩중...','loading-indicator');
								Mrp170ukrvService.procButton(param, function(provider, response) {
									if(provider){
                                        UniAppManager.updateStatus(Msg.sMB011);
                                    }
                                    panelSearch.getEl().unmask();
									}
								)
							//} else {
								
							}
							//return rv;
							
						}			    		
			    	}]
			}],	
			api: {
				submit: 'mrp170ukrvService.checkPlanList'				
			},
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
		   					var labelText = invalid.items[0]['fieldLabel']+':';
		   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		   					var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
		   				}
				   		alert(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
						//this.mask();		    
		   			}
			  	} else {
	  				this.unmask();
	  			}
				return r;
	  		}		
	});    

	
    Unilite.Main( {
		id  : 'mrp170ukrvApp',
		items 	: [ panelSearch],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			if(Ext.isEmpty(${masterHead})){
                panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('ROP_DATE',UniDate.get('today'));
                panelSearch.setValue('BASIC_DATE',UniDate.get('today'));
                panelSearch.setValue('STOCK_YN','Y');
                panelSearch.setValue('SAFE_STOCK_YN','N');
                panelSearch.setValue('INSTOCK_PLAN_YN','N');
                panelSearch.setValue('OUTSTOCK_PLAN_YN','N');
                panelSearch.setValue('CUSTOM_STOCK_YN','N');
                
			}else{
                panelSearch.setValue('DIV_CODE', ${masterHead}['DIV_CODE']);
                panelSearch.setValue('ROP_DATE', ${masterHead}['ROP_DATE']);
                panelSearch.setValue('BASIC_DATE', ${masterHead}['BASIC_DATE']);
                panelSearch.setValue('PLAN_PSRN', ${masterHead}['PLAN_PSRN']);
                
                panelSearch.getField('STOCK_YN').setValue(${masterHead}['STOCK_YN']);
                panelSearch.getField('SAFE_STOCK_YN').setValue(${masterHead}['SAFE_STOCK_YN']);
                panelSearch.getField('INSTOCK_PLAN_YN').setValue(${masterHead}['INSTOCK_PLAN_YN']);
                panelSearch.getField('OUTSTOCK_PLAN_YN').setValue(${masterHead}['OUTSTOCK_PLAN_YN']);
                panelSearch.getField('CUSTOM_STOCK_YN').setValue(${masterHead}['CUSTOM_STOCK_YN']); 
			}
					
			
		}
	});

};


</script>
