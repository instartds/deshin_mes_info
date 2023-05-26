<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cdm405ukrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="CD03" />	<!-- 원가담당자 -->	
	<t:ExtComboStore comboType="AU" comboCode="CC05" />	<!-- 재료비적용단가 -->	
	<t:ExtComboStore comboType="AU" comboCode="C101" />	<!-- 간접재료비 배부유형 -->	
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
	var panelSearch = Unilite.createForm('cdm405ukrv', {		
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
	 		name: 'COST_PRSN', 
	 		fieldLabel: '원가담당자',
	 		xtype: 'uniCombobox',
	 		comboType: 'AU',
	 		comboCode: 'CD03',
	 		allowBlank: true
        },{
			name: 'LAST_WORK_MONTH',
		 	fieldLabel: '최종마감년월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
            readOnly: true,
		  	hidden: false,
		  	maxLength: 200
        },{
			name: 'COST_WORK_MONTH',
		 	fieldLabel: '최종계산년월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
            readOnly: true,
		  	hidden: false,
		  	maxLength: 200
        },{
			name: 'WORK_MONTH',
		 	fieldLabel: '마감작업년월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
            readOnly: true,
		  	hidden: false,
		  	maxLength: 200
		},{
			fieldLabel: '원가단가수정',
			xtype: 'radiogroup',		            		
			id: 'rdoSelect',
			items: [{
				boxLabel: '반영함', 
				width: 150, 
				name: 'UPDATE_OPTION',
	    		inputValue: '01',
			},{
				boxLabel: '반영안함', 
				width: 200,
				name: 'UPDATE_OPTION',
	    		inputValue: '02',
				checked: true  
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
					var param = panelSearch.getValues();

					console.log("param",param)

					param.WORK_GUBUN	= 'CLOSE';			//작업구분(마감:CLOSE/취소:CANCEL)
					
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					cdm405ukrvService.procButton(param, 
						function(provider, response) {
							if(provider) {	
								UniAppManager.updateStatus("해당 월의 원가작업이 마감되었습니다.");
							}
							console.log("response",response)
							panelSearch.getEl().unmask();
						}
					)
				}
		    },{
				xtype: 'button',
		    	text: '취소',
		    	width: 60,
				handler: function() {
					var param = panelSearch.getValues();

					console.log("param",param)

					param.WORK_GUBUN	= 'CANCEL';			//작업구분(마감:CLOSE/취소:CANCEL)
					
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					cdm405ukrvService.procButton(param, 
						function(provider, response) {
							if(provider) {	
								UniAppManager.updateStatus("원가마감이 취소되었습니다.");
							}
							console.log("response",response)
							panelSearch.getEl().unmask();
						}
					)
				}
			}]
		}]
	});	

	/* 원가마감 */
    Unilite.Main( {
		id: 'cdm405ukrvApp',
		items: [panelSearch],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail', 'query', 'reset'], false);
		}
    });

};
</script>