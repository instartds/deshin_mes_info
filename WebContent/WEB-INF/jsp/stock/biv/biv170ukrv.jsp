<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv170ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type= "text/css">
.x-grid-cell {
    border-left: 0px !important;
    border-right: 0px !important;
}
.x-tree-icon-leaf {
    background-image:none;
}
.search-hr {
	height: 1px;
	border: 0;
	color: #fff;
	background-color: #330;
	width: 98%;
}
.x-grid-item-focused  .x-grid-cell-inner:before {
    border: 0px; 
}
</style>
<script type="text/javascript" >

function appMain() {     	

    var panelSearch = Unilite.createForm('searchForm', {
		disabled :false      
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{					
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode
			}, {
				fieldLabel		: '<t:message code="system.label.inventory.basisyearmonth" default="기준년월"/>',
	            xtype			: 'uniMonthRangefield',
	            startFieldName	: 'GI_YYMM_FR',
	            endFieldName	: 'GI_YYMM_TO',
	            startDate		: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4)-1 + '01',
	            endDate			: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4)-1 + '12',
	            allowBlank		: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('GI_YYMM_FR', newValue);						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('GI_YYMM_TO', newValue);				    		
			    	}
			    }
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
			    		text: '<t:message code="system.label.inventory.execute" default="실행"/>',	
			    		width: 60,	
						handler : function(records) {
			    			var rv = true;
			//		                            	var param= panelSearch.getValues();
			//		                            	var fromDate = panelSearch.getValue('GI_YYMM_FR').replace('.','');
			//										var toDate = panelSearch.getValue('GI_YYMM_TO').replace('.','');
			//		                                var me = this;
			//		                                param.GI_YYMM_FR = fromDate;
			//		                                param.GI_YYMM_TO = toDate;
			//		                                param.DIV_CODE = UserInfo.compCode;
			    			
			    			var param = panelSearch.getValues();
			    			
			    			
			    		/*	var param = {
											COMP_CODE: UserInfo.compCode,
											DIV_CODE: panelSearch.getValue('DIV_CODE'),
											GI_YYMM_FR: UniDate.getDbDateStr(panelSearch.getValue('GI_YYMM_FR')).substring(0, 6),
											GI_YYMM_TO: UniDate.getDbDateStr(panelSearch.getValue('GI_YYMM_TO')).substring(0, 6),
											USER_ID: UserInfo.userID
										}*/
			                    panelSearch.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
			                    biv170ukrvService.spCall(param, function(provider, response) {
			                        success: {
			                            panelSearch.getEl().unmask();
			                            Ext.Msg.alert('<t:message code="system.label.inventory.confirm" default="확인"/>','<t:message code="system.message.inventory.message009" default="작업이 완료 되었습니다."/>');
			                        }
			                    });
			
			                return rv;       
			    			
						}
			    	}]
			}, {
				xtype: 'container',
				html: 
				'<ul style>' +
				'<li>&nbsp;<Span><t:message code="system.label.inventory.explanation" default="ROP 대상품목의 발주점을 계산하기위해 일일 평균소비량을 계산합니다."/></Span>' +
				'<li>&nbsp;<Span><t:message code="system.label.inventory.explanation1" default="대상이되는 품목으로는 사업장별 품목정보의 조달구분이 구매로 되어 있고, ROP품목대상으로 체크가 되어 있어야 합니다."/></Span>' +
				'<li>&nbsp;<Span><t:message code="system.label.inventory.explanation2" default="일일 평균소비량 = 기준년월 사이의 출고수량 / 기준년월  사이의 일수"/> </Span>' +
				'<li>&nbsp;<Span><t:message code="system.label.inventory.explanation3" default="일일 평균소비량은 사업장별 품목정보의 일일평균소비량에 반영됩니다."/> </Span>' +
				'</ul>'	
				
			}],
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
		   					var labelText = invalid.items[0]['fieldLabel']+' : ';
		   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		   					var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
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
	});  
    
    
    
    
    
    
    
    
	
    
	 Unilite.Main({
		items:[panelSearch],
		id : 'biv170ukrvApp',
		fnInitBinding : function() {	
//			UniAppManager.setToolbarButtons('detail',false);
//			UniAppManager.setToolbarButtons('reset',false);
		}
	});
};
</script>
