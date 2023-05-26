<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="mrp160ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="M201" />		 <!-- 수급계획 담당자 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="MRP160ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="MRP160ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="MRP160ukrvLevel3Store" />	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var panelSearch = Unilite.createForm('mrp160ukrvForm', {		
		disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items :[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode
				},{					
	    			fieldLabel: '수급계획 담당자',
	    			name:'PLAN_PSRN',
	    			xtype: 'uniCombobox',
	    			comboType:'AU',
	    			comboCode:'M201'
	    		},{ 
	    			fieldLabel: '소요량 계산일',
	    			name:'ROP_DATE',
					xtype: 'uniDatefield',
					value: UniDate.get('yesterday'),
					readOnly:true
				},{ 
	    			fieldLabel: '가용재고반영 기준일',
	    			name:'BASE_DATE',
					xtype: 'uniDatefield',
					value: UniDate.get('yesterday'),
					allowBlank:false
				},
                Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
                        //validateBlank:    false,
                        textFieldName:  'ITEM_NAME',
                        valueFieldName: 'ITEM_CODE'
                }),{
                    name: 'ITEM_LEVEL1',
                    fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
                    xtype:'uniCombobox',
                    store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'),
                    child: 'ITEM_LEVEL2'
                  }, {
                    name: 'ITEM_LEVEL2',
                    fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
                    xtype:'uniCombobox',
                    store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'),
                    child: 'ITEM_LEVEL3'
                    
                 }, {
                    name: 'ITEM_LEVEL3',
                    fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
                    xtype:'uniCombobox',
                    store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')
                },{
                    xtype: 'radiogroup',
                    id: 'rdoSelect1',
                    fieldLabel: '가용재고 반영',
                    items : [{
                        boxLabel: '예',
                        name: 'EXC_STOCK_YN',
                        inputValue: 'Y',
                        width:80,
                        checked: true
                    }, {
                        boxLabel: '아니오',
                        name: 'EXC_STOCK_YN' ,
                        inputValue: 'N',
                        width:80
                    }]
                },{
				    xtype: 'radiogroup',
				    id: 'rdoSelect2',
				    fieldLabel: '현재고 반영',
				    items : [{
				    	boxLabel: '예',
				    	name: 'STOCK_YN',
				    	inputValue: 'Y',
				    	width:80,
				    	checked: true
				    }, {
				    	boxLabel: '아니오',
				    	name: 'STOCK_YN' ,
				    	inputValue: 'N',
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
				    	width:80
				    }, {
				    	boxLabel: '아니오',
				    	name: 'SAFE_STOCK_YN' ,
				    	inputValue: 'N',
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
				    	width:80
				    }, {
				    	boxLabel: '아니오',
				    	name: 'INSTOCK_PLAN_YN' ,
				    	inputValue: 'N',
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
				    	width:80
				    }, {
				    	boxLabel: '아니오',
				    	name: 'OUTSTOCK_PLAN_YN' ,
				    	inputValue: 'N',
				    	width:80,
				    	checked: true
				    }]				
				},{
                    xtype: 'radiogroup',
                    id: 'rdoSelect6',
                    fieldLabel: '외주재고 반영',
                    items : [{
                        boxLabel: '예',
                        name: 'CUSTOM_STOCK_YN',
                        inputValue: 'Y',
                        width:80
                    }, {
                        boxLabel: '아니오',
                        name: 'CUSTOM_STOCK_YN' ,
                        inputValue: 'N',
                        width:80,
                        checked: true
                    }]              
                },{
			    	xtype: 'container',
			    	padding: '10 0 0 100',
			    	layout: {
			    		type: 'hbox',
						pack:'left'
			    	},
			    	items:[{
			    		xtype: 'button',
			    		text: '실행',
			    		width: 100,
			    		handler: function() {
			    			var rv = true;
                            if(confirm(Msg.sMB063)) {
                            	var param= panelSearch.getValues();
                                var me = this;
                                panelSearch.getEl().mask('로딩중...','loading-indicator');
                                mrp160ukrvService.spCall(param, function(provider, response) {
                                    success: {
                                        panelSearch.getEl().unmask();
                                        Ext.Msg.alert('확인','작업이 정상적으로 처리되었습니다.');
                                    }
                                });
                            } else {
                            	
                            }
                            return rv;       
			    			
//    			    		if(confirm('<t:message code="unilite.msg.sMM392"/>')){
//    			    			if(panelSearch.getValue('STOCK_YN') ==true ||
//    								panelSearch.getValue('SAFE_STOCK_YN') ==true ||
//    								panelSearch.getValue('INSTOCK_PLAN_YN') ==true ||
//    								panelSearch.getValue('OUTSTOCK_PLAN_YN') ==true ||
//    								panelSearch.getValue('CUSTOM_STOCK_YN') ==true){
//    								panelSearch.setValue('EXC_STOCK_YN', true);
//    							}else{
//    								panelSearch.setValue('EXC_STOCK_YN', 'N');
//    							}
//    			    			//panelSearch.saveForm();
//    			    			
//    			    		}
    			    			
						}
						
			    	}]
		}],	
		api: {
			submit: 'mrp160ukrvService.syncForm'				
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
		id  : 'mrp160ukrvApp',
		items 	: [ panelSearch],		
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//panelSearch.setValue('BASE_DATE',UniDate.get('today'));
			//panelSearch.setValue('ROP_DATE',UniDate.get('today'));

			
			panelSearch.setValue('STOCK_YN','Y');
			panelSearch.setValue('SAFE_STOCK_YN','N');
			panelSearch.setValue('INSTOCK_PLAN_YN','N');
			panelSearch.setValue('OUTSTOCK_PLAN_YN','N');
			panelSearch.setValue('CUSTOM_STOCK_YN','N');
			panelSearch.setValue('EXC_STOCK_YN','Y');

			
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('save',false);
		//	UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
		}

	});
		
};


</script>
