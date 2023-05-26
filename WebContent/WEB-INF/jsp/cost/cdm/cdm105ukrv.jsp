<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cdm105ukrv"  >
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
	var panelSearch = Unilite.createForm('cdm105ukrv', {		
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
			name: 'WORK_MONTH',
		 	fieldLabel: '기준월',
		 	xtype: 'uniMonthfield',
		  	value: UniDate.get('startOfMonth'),
		  	hidden: false,
		  	allowBlank: false,
		  	maxLength: 200
		},{ 
	 		name: 'APPLY_UNIT', 
	 		fieldLabel: '적용단가',
	 		xtype: 'uniCombobox',
		  	value: '02',
	 		comboType: 'AU',
	 		comboCode: 'CC05',
	 		allowBlank: false
		},{ 
	 		name: 'DIST_KIND', 
	 		fieldLabel: '간접비배부유형',
	 		xtype: 'uniCombobox',
		  	value: '01',
	 		comboType: 'AU',
	 		comboCode: 'C101',
	 		allowBlank: false
		},{
			fieldLabel: '원가계산이력',
			xtype: 'radiogroup',		            		
			id: 'rdoSelect',
			items: [{
				boxLabel: '예(작업회수 추가)', 
				width: 150, 
				name: 'DEL_OPTION',
	    		inputValue: '01',
			},{
				boxLabel: '아니오(이전계산내역삭제)', 
				width: 200,
				name: 'DEL_OPTION',
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
//					if(panelSearch.setAllFieldsReadOnly(true)){
						var param = panelSearch.getValues();

						console.log("param",param)

//						param.LANG_TYPE		= 'ko';												//언어구분
//						param.CALL_PATH		= 'Batch';											//호출경로(Batch, List)
//						param.BILL_PUB_NUM	= '';												//계산서번호/계산서발행번호
//						param.KEY_VALUE		= '';												//KEY 문자열
						
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						cdm105ukrvService.procButton(param, 
							function(provider, response) {
								if(provider) {	
									UniAppManager.updateStatus("원가계산이 완료되었습니다.");
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

	/* 원가계산 */
    Unilite.Main( {
		id: 'cdm105ukrvApp',
		items: [panelSearch],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail', 'query', 'reset'], false);
		}
    });

};
</script>