<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="s_mrp110ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />	<!-- 수급계획 담당자 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
function appMain() {
	/**
	 * 작업조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createForm('s_mrp110ukrv_kd', {		
		disabled: false,
		flex: 1,
		layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
	    items: [{
			name: 'DIV_CODE',
			fieldLabel: '사업장',
			xtype: 'uniCombobox',
      		comboType: 'BOR120',
      		value: UserInfo.divCode,
      		hidden: false,
      		allowBlank: false,
      		maxLength: 20
		},{ 
	 		name: 'PLAN_PRSN', 
	 		fieldLabel: 'MRP 담당자',
	 		xtype: 'uniCombobox',
	 		comboType: 'AU',
	 		comboCode: 'M201',
	 		allowBlank: true
        },{
			fieldLabel: '판매계획월',
	        xtype: 'uniMonthfield',
	        name: 'BASE_MONTH',
	        value: UniDate.get('today'),
	        allowBlank: false
		},{
		    xtype: 'radiogroup',
		    id: 'rdoSelect3',
		    fieldLabel: '안전재고 반영',
		    items : [{
		    	boxLabel: '예',
		    	name: 'SAFETY_STOCK_YN',
		    	inputValue: 'Y',
		    	width:80,
				checked: true  
		    }, {
		    	boxLabel: '아니오',
		    	name: 'SAFETY_STOCK_YN' ,
		    	inputValue: 'N',
		    	width:80
		    }]				
		},{
			xtype: 'container',
	    	padding: '10 0 30 0',
	    	layout: {
	    		type: 'hbox',
				align: 'center',
				pack:'center'
	    	},
		    items: [{
				xtype: 'button',
		    	text: '실행',
		    	width: 60,
				handler: function() {
//					if(panelSearch.setAllFieldsReadOnly(true)){
						var param = panelSearch.getValues();

						console.log("param",param)

						panelSearch.getEl().mask('로딩중...','loading-indicator');
						s_mrp110ukrv_kdService.procButton(param, 
							function(provider, response) {
								if(provider) {	
									UniAppManager.updateStatus("작업이 완료되었습니다.");
								}
								console.log("response",response)
								panelSearch.getEl().unmask();
							}
						)
					
//						return panelSearch.setAllFieldsReadOnly(true);
//					}
				}
		    }]
		}]
	});	

	/* MRP전개 */
    Unilite.Main( {
		id: 's_mrp110ukrv_kdApp',
		items: [panelSearch],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail', 'query', 'reset'], false);
		}
    });

};
</script>
