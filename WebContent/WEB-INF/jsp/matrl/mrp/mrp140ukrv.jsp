<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="mrp140ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="M201" />		 <!-- 수급계획 담당자 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
	var panelSearch = Unilite.createForm('mrp140ukrvForm', {	
		disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items :[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false
				},{
					xtype	: 'component'
				},{
					xtype:'component', 
					html:'[<t:message code="system.label.purchase.lastmrpcontent" default="최근 MRP전개 내용"/>]',
					tdAttrs: {Style: 'text-align:left'}
				},{					
	    			fieldLabel: '<t:message code="system.label.purchase.mrpcontrolnum" default="MRP 전개번호"/>',
	    			name:'MRP_CONTROL_NUM',
	    			xtype: 'uniTextfield',
	    			readOnly:true
	    		},{					
	    			fieldLabel: 'MRP <t:message code="system.label.purchase.charger" default="담당자"/>',
	    			name:'PLAN_PRSN',
	    			xtype: 'uniTextfield',
	    			readOnly:true
	    		},{					
	    			fieldLabel: '<t:message code="system.label.purchase.basisdate" default="기준일"/>',
	    			name:'BASE_DATE',
	    			xtype: 'uniDatefield',
	    			readOnly:true
	    		},{					
	    			fieldLabel: '<t:message code="system.label.purchase.confirmdate" default="확정일"/>',
	    			name:'FIRM_DATE',
	    			xtype: 'uniDatefield',
	    			readOnly:true
	    		},{					
	    			fieldLabel: '<t:message code="system.label.purchase.forecastdate" default="예시일"/>',
	    			name:'PLAN_DATE',
	    			xtype: 'uniDatefield',
	    			readOnly:true
	    		},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect1',
				    fieldLabel: '<t:message code="system.label.purchase.availableinventoryapply" default="가용재고 반영"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'EXC_STOCK_YN',
				    	inputValue: 'Y',
				    	readOnly:true,
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'EXC_STOCK_YN' ,
				    	inputValue: 'N',
				    	width:80,
				    	readOnly:true,
				    	checked: true
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect2',
				    fieldLabel: '<t:message code="system.label.purchase.onhandstockapply" default="현재고 반영"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'STOCK_YN',
				    	inputValue: 'Y',
				    	readOnly:true,
				       	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'STOCK_YN' ,
				    	inputValue: 'N',
				    	readOnly:true,
				    	width:80
				    	//checked: true
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect3',
				    fieldLabel: '<t:message code="system.label.purchase.safetystockapply" default="안전재고 반영"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'SAFE_STOCK_YN',
				    	inputValue: 'Y',
				    	readOnly:true,
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'SAFE_STOCK_YN' ,
				    	inputValue: 'N',
				    	readOnly:true,
				    	width:80
				    	//checked: true
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect8',
				    fieldLabel: '<t:message code="system.label.purchase.substockapply" default="외주재고 반영"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'CUSTOM_STOCK_YN',
				    	inputValue: 'Y',
				    	readOnly:true,
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'CUSTOM_STOCK_YN' ,
				    	inputValue: 'N',
				    	readOnly:true,
				    	width:80
				    	//checked: true
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect4',
				    fieldLabel: '<t:message code="system.label.purchase.receiptplannedapply" default="입고예정 반영"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'INSTOCK_PLAN_YN',
				    	inputValue: 'Y',
				    	readOnly:true,
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'INSTOCK_PLAN_YN' ,
				    	inputValue: 'N',
				    	readOnly:true,
				    	width:80
				    	//checked: true
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect5',
				    fieldLabel: '<t:message code="system.label.purchase.issueresevationapply" default="출고예정 반영"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'OUTSTOCK_PLAN_YN',
				    	inputValue: 'Y',
				    	readOnly:true,
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'OUTSTOCK_PLAN_YN' ,
				    	inputValue: 'N',
				    	readOnly:true,
				    	width:80
				    	//checked: true
				    }]				
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect7',
				    fieldLabel: '<t:message code="system.label.purchase.uncertainorderapply" default="미확정오더 반영"/>',
				    items : [{
				    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
				    	name: 'PLAN_YN',
				    	inputValue: 'Y',
				    	readOnly:true,
				    	width:80
				    }, {
				    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
				    	name: 'PLAN_YN' ,
				    	inputValue: 'N',
				    	readOnly:true,
				    	width:80
				    	//checked: true
				    }]				
				},{					
	    			fieldLabel: '<t:message code="system.label.purchase.openorderamount" default="Open오더 갯수"/>',
	    			name:'OPEN_COUNT',
	    			//value:'0',
	    			xtype: 'uniNumberfield',
	    			readOnly:true,
	    			suffixTpl: '&nbsp;개'
	    		},{					
	    			fieldLabel: '<t:message code="system.label.purchase.convertorderamount" default="전환오더 갯수"/>',
	    			name:'CONVERT_COUNT',
	    			//value:'0',
	    			xtype: 'uniNumberfield',
	    			readOnly:true,
	    			suffixTpl: '&nbsp;개'
	    		},{					
	    			fieldLabel: '<t:message code="system.label.purchase.certainorderamount" default="확정오더 갯수"/>',
	    			name:'DICISION_COUNT',
	    			//value:'0',
	    			xtype: 'uniNumberfield',
	    			readOnly:true,
	    			suffixTpl: '&nbsp;개'
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
			    		id: 'startButton',
			    		name: 'EXECUTE_TYPE',
			    		text: '<t:message code="system.label.purchase.execute" default="실행"/>',
			    		handler : function() {
					    			if(!panelSearch.setAllFieldsReadOnly(true)){
							    		return false;
							    	}	  
							    	var param= panelSearch.getValues();
							    	param['EXECUTE_TYPE'] = 'OK';
							    	mrp140ukrvService.syncMaster(param);
							    	alert('<t:message code="system.message.purchase.message055" default="작업이 정상적으로 처리되었습니다."/>')
					    		}
			    	},{
			    		xtype: 'button',
			    		id: 'deleteButton',
			    		name: 'EXECUTE_TYPE',
			    		text: '<t:message code="system.label.purchase.delete" default="삭제"/>',
			    		handler : function() {
					    			if(!panelSearch.setAllFieldsReadOnly(true)){
							    		return false;
							    	}	
							    	var param= panelSearch.getValues();
							    	param['EXECUTE_TYPE'] = 'DEL';
							    	mrp140ukrvService.syncMaster(param);
                                    alert('<t:message code="system.message.purchase.message055" default="작업이 정상적으로 처리되었습니다."/>')
					    		}
			    	}/*,{
			    		xtype: 'button',
			    		id: 'cancelButton',
			    		text: '<t:message code="system.label.purchase.close" default="닫기"/>',
			    		handler : function() {
					    			if(!panelSearch.setAllFieldsReadOnly(true)){
							    		return false;
							    	}	    			
					    		}
			    	}*/]
			    }],
				api: {
	         		 //submit: 'mrp110ukrvService.syncMaster'
	         		 //load: 'mrp110ukrvService.selectMaster',
					 
				}
			, listeners : {
				dirtychange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
//					UniAppManager.setToolbarButtons('save', true);
			}/*,
			beforeaction:function(basicForm, action, eOpts)	{
				console.log("action : ",action);
				console.log("action.type : ",action.type);
				if(action.type =='directsubmit')	{
					var invalid = this.getForm().getFields().filterBy(function(field) {
					            return !field.validate();
					    });
			        	
		         	if(invalid.length > 0)	{
			        	r=false;
			        	var labelText = ''
			        	
			        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
			        		var labelText = invalid.items[0]['fieldLabel']+':';
			        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
			        		var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
			        	}
			        	alert(labelText+Msg.sMB083);
			        	invalid.items[0].focus();
			        }																									
				}
			}*/	
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
			   		alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
  		    
		//}]
	});    
	
    Unilite.Main( {
		id  : 'mrp140ukrvApp',
		items 	: [ panelSearch],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			var param= Ext.getCmp('mrp140ukrvForm').getValues(); 
			mrp140ukrvService.defaultSet(param, function(provider, response) {
                   if(!Ext.isEmpty(provider)){
                	   panelSearch.setValue('MRP_CONTROL_NUM', provider[0].MRP_CONTROL_NUM);
                       panelSearch.setValue('PLAN_PSRN', provider[0].PLAN_PSRN);
                       panelSearch.setValue('BASE_DATE', provider[0].BASE_DATE);
                       panelSearch.setValue('FIRM_DATE', provider[0].FIRM_DATE);
                       panelSearch.setValue('PLAN_DATE', provider[0].PLAN_DATE);
                       panelSearch.setValue('EXC_STOCK_YN', provider[0].EXC_STOCK_YN);
                       panelSearch.setValue('STOCK_YN', provider[0].STOCK_YN);
                       panelSearch.setValue('SAFE_STOCK_YN', provider[0].SAFE_STOCK_YN);
                       panelSearch.setValue('CUSTOM_STOCK_YN', provider[0].CUSTOM_STOCK_YN);
                       panelSearch.setValue('INSTOCK_PLAN_YN', provider[0].INSTOCK_PLAN_YN);
                       panelSearch.setValue('OUTSTOCK_PLAN_YN', provider[0].OUTSTOCK_PLAN_YN);
                       panelSearch.setValue('PLAN_YN', provider[0].PLAN_YN);
                       panelSearch.setValue('OPEN_COUNT', provider[0].OPEN_COUNT);
                       panelSearch.setValue('CONVERT_COUNT', provider[0].CONVERT_COUNT);
                       panelSearch.setValue('DICISION_COUNT', provider[0].DICISION_COUNT);   
                   }
                }
            )			
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',true);
			//this.setToolbarButtons(['newData','reset', 'query'],false);
		}
	});

};


</script>
