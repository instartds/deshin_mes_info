<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hrt502ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="H053" /> <!--정산구분-->
	<t:ExtComboStore comboType="AU" comboCode="H168" /> <!--퇴직사유--> 
</t:appConfig>
<script type="text/javascript" >

function appMain() {


	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	//var form1 = Ext.create('Ext.form.Panel', {
 	var form1 = Unilite.createSearchForm('SearchForm', {
		autoScroll: true,		
		xtype: 'container',		
		api: {
        	load: 'hrt502ukrService.selectList',
        	submit: 'hrt502ukrService.form01Submit'
        },
		region:'center',
		layout:{type:'vbox', align:'left'},
		listeners: {
			click : function(){
				alert("blur");
			}
		},
		items: [        
		    {
		    	xtype: 'container',
		    	layout: {type: 'uniTable', align:'left', columns:4},
		    	padding: '10 10 10 10',
		    	
		    	items: [
// 					Unilite.popup('Employee',{
// 						
// 						textFieldWidth: 170,
// 						id: 'PERSON_NUMB',
// 						allowBlank: false
// 						}),
						{ xtype: 'uniTextfield',  id: 'PERSON_NUMB', name: 'PERSON_NUMB', readOnly: true, value: '2008090101'},
						{ xtype: 'uniTextfield', fieldLabel: '성명', id: 'PERSON_NAME', name: 'PERSON_NAME', readOnly: true},
						{ xtype: 'uniTextfield', id: 'RETR_TYPE', name: 'RETR_TYPE', hidden: true, value: 'M'},
						{ xtype: 'uniTextfield', id: 'RETR_DATE', name: 'RETR_DATE', hidden: true, value: '20150127'},
						{ xtype: 'uniTextfield', id: 'JOIN_DATE', name: 'JOIN_DATE', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'DUTY_YYYY', name: 'DUTY_YYYY', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'LONG_MONTH', name: 'LONG_MONTH', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'LONG_DAY', name: 'LONG_DAY', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'LONG_TOT_DAY', name: 'LONG_TOT_DAY', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'ADD_MONTH', name: 'ADD_MONTH', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'LONG_TOT_MONTH', name: 'LONG_TOT_MONTH', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'LONG_YEARS', name: 'LONG_YEARS', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'AVG_DAY', name: 'AVG_DAY', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'RETR_SUM_I', name: 'RETR_SUM_I', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'SUPP_TOTAL_I', name: 'SUPP_TOTAL_I', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'EARN_INCOME_I', name: 'EARN_INCOME_I', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'DED_IN_TAX_ADD_I', name: 'DED_IN_TAX_ADD_I', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'DED_IN_LOCAL_ADD_I', name: 'DED_IN_LOCAL_ADD_I', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'DED_ETC_I', name: 'DED_ETC_I', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'DED_TOTAL_I', name: 'DED_TOTAL_I', hidden: true, value: ''},
						{ xtype: 'uniTextfield', id: 'REAL_AMOUNT_I', name: 'REAL_AMOUNT_I', hidden: true, value: ''}
		    	        ]
		    },	   	
		    
			{
				xtype: 'container',
				padding: '0 10 10 10',
				
				layout: {
					type: 'uniTable',
					columns:4,					
					tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
					tdAttrs: {style: 'border : 1px solid #ced9e7;'}
				},
// 				defaults: {width: 120},
				items: [							
					{ xtype: 'component', html:'주민등록번호', layout:{align : 'center'}, style: 'text-align:center'},
			    	{ xtype: 'uniTextfield', name: 'REPRE_NUM', readOnly:true, width: 350},
			    	{ xtype: 'component', html:'주소', style: 'text-align:center', width: 130},
			    	{ xtype: 'uniTextfield', name: 'ADDR_NAME', readOnly:true, width: 890},
			    				    	
			    	{ xtype: 'component', html:'귀속연도', style: 'text-align:center'},
			    	{
			    		xtype: 'container',
			    		layout:{ type: 'hbox'},
			    		defaults: {align : 'center', align:'left'},
			    		items:[
						{ xtype: 'uniDatefield', suffixTpl: ' 부터 ', name: 'RETR_DATE_FR', readOnly:true},
						{ xtype: 'uniDatefield', suffixTpl: ' 까지', name: 'RETR_DATE_TO', readOnly:true}
			    		       ]			    		
			    	},
			    	
			    	{ xtype: 'component', html:'퇴직사유', style: 'text-align:center'},
			    	{
						xtype: 'radiogroup',					
						id: 'rdo1',
						items: [
						  { boxLabel: '정년퇴직', width: 80, name: 'RETR_RESN', inputValue: '1', checked: true}, 
						  { boxLabel: '정리해고',	width: 80, name: 'RETR_RESN', inputValue: '2'},
						  { boxLabel: '자발적퇴직',	width: 80, name: 'RETR_RESN', inputValue: '3'},
						  { boxLabel: '임원퇴직',	width: 80, name: 'RETR_RESN', inputValue: '4'},
						  { boxLabel: '중간정산',	width: 80, name: 'RETR_RESN', inputValue: '5'},
						  { boxLabel: '기타',	width: 50, name: 'RETR_RESN', inputValue: '6'}
						  ]
					},
			    				    	
			    	{ xtype: 'component', html:'확정급여형 퇴직연금 제도 가입일', style: 'text-align:center'},
			    	{ xtype: 'uniDatefield', name: 'RETR_ANN_JOIN_DATE'},
			    	{ xtype: 'component', html:'2011.12.31 퇴직금', style: 'text-align:center'},
			    	{ xtype: 'uniNumberfield', name: 'RETR_ANNU_I_20111231', id: 'RETR_ANNU_I_20111231', value:'0', readOnly:true},		    	
				    	
				]			
			},		        
		   
			   {
					xtype: 'container',
					padding: '0 10 10 10',
					
					layout: {
						type: 'uniTable',
						columns:5,
						tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
		    			tdAttrs: {style: 'border : 1px solid #ced9e7;'}
					},
// 					defaults: {width: 120},
					items: [
						{ xtype: 'component',  html:'퇴직급여현황', style: 'text-align:center', rowspan: 6, width: 30},
						
						{ xtype: 'component',  html:'근무처 구분', style: 'text-align:center', width: 400},
				    	{ xtype: 'component',  html:'중간지급 등', style: 'text-align:center', width: 366},
				    	{ xtype: 'component',  html:'최종', style: 'text-align:center', width: 366},
				    	{ xtype: 'component',  html:'정산', style: 'text-align:center', width: 366},		    	
				
						{ xtype: 'component', html:'(13)근무처명', style: 'text-align:left'},
						{ xtype: 'uniTextfield', name: 'M_DIV_NAME', width: 373},
						{ xtype: 'uniTextfield', name: 'R_DIV_NAME', width: 373, readOnly:true},
				    	{ xtype: 'uniTextfield', name: '', width: 373, readOnly:true},		    	
				    	
				    	{ xtype: 'component', html:'(14)사업자등록번호', style: 'text-align:left'},
				    	{ xtype: 'uniTextfield', name: 'M_COMPANY_NUM', width: 373},
						{ xtype: 'uniTextfield', name: 'R_COMPANY_NUM', width: 373, readOnly:true},
				    	{ xtype: 'uniTextfield', name: '', width: 373, readOnly:true},		    	
				    	
				    	{ xtype: 'component', html:'(15)퇴직급여', style: 'text-align:left'},
				    	{ xtype: 'uniNumberfield', name: 'M_ANNU_TOTAL_I', id: 'M_ANNU_TOTAL_I', value:'0', width: 373, listeners: {'blur': function(){ SuppTotI() } }},
				    	{ xtype: 'uniNumberfield', name: 'R_ANNU_TOTAL_I', id: 'R_ANNU_TOTAL_I', value:'0', width: 373, readOnly:true},
				    	{ xtype: 'uniNumberfield', name: 'S_ANNU_TOTAL_I', id: 'S_ANNU_TOTAL_I', value:'0', width: 373, readOnly:true},		    
				    	
				    	{ xtype: 'component', html:'(16)비과세 퇴직급여', style: 'text-align:left'},
				    	{ xtype: 'uniNumberfield', name: 'M_OUT_INCOME_I', id: 'M_OUT_INCOME_I', value:'0', width: 373, listeners: {'blur': function(){ SuppTotI() } }},
				    	{ xtype: 'uniNumberfield', name: 'R_OUT_INCOME_I', id: 'R_OUT_INCOME_I', value:'0', width: 373, readOnly:true},
				    	{ xtype: 'uniNumberfield', name: 'S_OUT_INCOME_I', id: 'S_OUT_INCOME_I', value:'0', width: 373, readOnly:true},		    	
				    	
				    	{ xtype: 'component', html:'(17)과세대상 퇴직급여((15)-(16))', style: 'text-align:left'},
				    	{ xtype: 'uniNumberfield', name: 'M_TAX_TOTAL_I', id: 'M_TAX_TOTAL_I', value:'0', width: 373, readOnly:true},
				    	{ xtype: 'uniNumberfield', name: 'R_TAX_TOTAL_I', id: 'R_TAX_TOTAL_I', value:'0', width: 373, readOnly:true},
				    	{ xtype: 'uniNumberfield', name: 'S_TAX_TOTAL_I', id: 'S_TAX_TOTAL_I', value:'0', width: 373, readOnly:true},		    	
					]			
				},		
			   {
					xtype: 'container',
					padding: '0 10 10 10',
					
					layout: {
						type: 'uniTable',
						columns:16,
						tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
		    			tdAttrs: {style: 'border : 1px solid #ced9e7;'}
					},
					defaults: {width: 100},
					items: [
							{ xtype: 'component',  html:'근속연수', style: 'text-align:center', rowspan: 7, width: 30},
							
							{ xtype: 'component',  html:'구분', rowspan: 2, colspan: 2, width: 100, style: 'text-align:center', width: 200},
					    	{ xtype: 'component',  html:'(18)입사일', rowspan: 2, style: 'text-align:center', width: 100},
					    	{ xtype: 'component',  html:'(19)기산일', rowspan: 2, style: 'text-align:center', width: 100},
					    	{ xtype: 'component',  html:'(20)퇴사일', rowspan: 2, style: 'text-align:center', width: 100},
					    	{ xtype: 'component',  html:'(21)지급일', rowspan: 2, style: 'text-align:center', width: 100},
					    	{ xtype: 'component',  html:'(22)근속월수', rowspan: 2, style: 'text-align:center', width: 100},
					    	{ xtype: 'component',  html:'(23)제외월수', colspan: 3, style: 'text-align:center'},
					    	{ xtype: 'component',  html:'(24)가산월수', colspan: 3, style: 'text-align:center'},					    	
					    	{ xtype: 'component',  html:'(25)중복월수', rowspan: 2, style: 'text-align:center', width: 100},
					    	{ xtype: 'component',  html:'(26)근속연수', rowspan: 2, style: 'text-align:center', width: 100},					    	
					    	{ xtype: 'component',  html:'2012이전', style: 'text-align:center', width: 100},
							{ xtype: 'component',  html:'2013이후', style: 'text-align:center', width: 100},
							{ xtype: 'component',  html:'합계', style: 'text-align:center', width: 100},
							{ xtype: 'component',  html:'2012이전', style: 'text-align:center', width: 100},
							{ xtype: 'component',  html:'2013이후', style: 'text-align:center', width: 100},
							{ xtype: 'component',  html:'합계', style: 'text-align:center', width: 100},
							
							{ xtype: 'component',  html:'중간지급 근속연수', colspan: 2, style: 'text-align:left'},
							{ xtype: 'uniDatefield', name: 'M_JOIN_DATE', id: 'M_JOIN_DATE'},
							{ xtype: 'uniDatefield', name: 'M_CALCU_END_DATE', id: 'M_CALCU_END_DATE', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniDatefield', name: 'M_RETR_DATE', id: 'M_RETR_DATE', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniDatefield', name: 'M_SUPP_DATE', id: 'M_SUPP_DATE'},
							{ xtype: 'uniNumberfield', name: 'M_LONG_MONTHS', id: 'M_LONG_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'M_EXEP_MONTHS_BE13', id: 'M_EXEP_MONTHS_BE13', value:'0', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniNumberfield', name: 'M_EXEP_MONTHS_AF13', id: 'M_EXEP_MONTHS_AF13', value:'0', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniNumberfield', name: 'M_EXEP_MONTHS', id: 'M_EXEP_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'M_ADD_MONTHS_BE13', id: 'M_ADD_MONTHS_BE13', value:'0', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniNumberfield', name: 'M_ADD_MONTHS_AF13', id: 'M_ADD_MONTHS_AF13', value:'0', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniNumberfield', name: 'M_ADD_MONTHS', id: 'M_ADD_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'M_LONG_YEARS', id: 'M_LONG_YEARS', value:'0', readOnly:true},
							
							{ xtype: 'component',  html:'최종 근속연수', colspan: 2, style: 'text-align:left'},
							{ xtype: 'uniDatefield', name: 'R_JOIN_DATE', readOnly:true},
							{ xtype: 'uniDatefield', name: 'R_CALCU_END_DATE', id: 'R_CALCU_END_DATE', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniDatefield', name: 'R_RETR_DATE', readOnly:true},
							{ xtype: 'uniDatefield', name: 'R_SUPP_DATE', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'R_LONG_MONTHS', id: 'R_LONG_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'R_EXEP_MONTHS_BE13', id: 'R_EXEP_MONTHS_BE13', value:'0', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniNumberfield', name: 'R_EXEP_MONTHS_AF13', id: 'R_EXEP_MONTHS_AF13', value:'0', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniNumberfield', name: 'R_EXEP_MONTHS', id: 'R_EXEP_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'R_ADD_MONTHS_BE13', id: 'R_ADD_MONTHS_BE13', value:'0', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniNumberfield', name: 'R_ADD_MONTHS_AF13', id: 'R_ADD_MONTHS_AF13', value:'0', listeners: {'blur': function(){ fnDateChanged() } }},
							{ xtype: 'uniNumberfield', name: 'R_ADD_MONTHS', id: 'R_ADD_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'R_LONG_YEARS', id: 'R_LONG_YEARS', value:'0', readOnly:true},
							
							{ xtype: 'component',  html:'정산 근속연수', colspan: 2, style: 'text-align:left'},
							{ xtype: 'uniDatefield', name: 'S_JOIN_DATE', readOnly:true},
							{ xtype: 'uniDatefield', name: 'S_CALCU_END_DATE', readOnly:true},
							{ xtype: 'uniDatefield', name: 'S_RETR_DATE', readOnly:true},
							{ xtype: 'uniDatefield', name: '', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'S_LONG_MONTHS', id: 'S_LONG_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'S_EXEP_MONTHS', id: 'S_EXEP_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'S_ADD_MONTHS', id: 'S_ADD_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'S_DUPLI_MONTHS', id: 'S_DUPLI_MONTHS', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'S_LONG_YEARS', id: 'S_LONG_YEARS', value:'0', readOnly:true},
							
							{ xtype: 'component',  html:'안분', rowspan: 2, style: 'text-align:left', width: 30},
							{ xtype: 'component',  html:'2012.12.31이전'},
							{ xtype: 'uniDatefield', name: '', readOnly:true},
							{ xtype: 'uniDatefield', name: 'CALCU_END_DATE_BE13', readOnly:true},
							{ xtype: 'uniDatefield', name: 'RETR_DATE_BE13', readOnly:true},
							{ xtype: 'uniDatefield', name: '', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'LONG_MONTHS_BE13', id: 'LONG_MONTHS_BE13', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'EXEP_MONTHS_BE13', id: 'EXEP_MONTHS_BE13', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'ADD_MONTHS_BE13', id: 'ADD_MONTHS_BE13', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'LONG_YEARS_BE13', id: 'LONG_YEARS_BE13', value:'0', readOnly:true},
							
							{ xtype: 'component',  html:'2013.01.01이후', style: 'text-align:left'},
							{ xtype: 'uniDatefield', name: '', readOnly:true},
							{ xtype: 'uniDatefield', name: 'CALCU_END_DATE_AF13', readOnly:true},
							{ xtype: 'uniDatefield', name: 'RETR_DATE_AF13', readOnly:true},
							{ xtype: 'uniDatefield', name: '', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'LONG_MONTHS_AF13', id: 'LONG_MONTHS_AF13', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'EXEP_MONTHS_AF13', id: 'EXEP_MONTHS_AF13', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'ADD_MONTHS_AF13', id: 'ADD_MONTHS_AF13', value:'0', readOnly:true},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly:true},
							{ xtype: 'uniNumberfield', name: 'LONG_YEARS_AF13', id: 'LONG_YEARS_AF13', value:'0', readOnly:true}
									    	
						]			
					},			
			
				   {
						xtype: 'container',
						padding: '0 10 10 10',
						
						layout: {
							type: 'uniTable',
							columns:5,
							tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			    			tdAttrs: {style: 'border : 1px solid #ced9e7;'}
						},
// 						defaults: {width: 120},
						items: [
							{ xtype: 'component',  html:'퇴직소득과세표준계산', style: 'text-align:center', rowspan: 5, width: 30},
							
							{ xtype: 'component',  html:'계산내용', style: 'text-align:center', width: 400},
					    	{ xtype: 'component',  html:'중간지급 등', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'최종', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'정산', style: 'text-align:center'},		    	
					
							{ xtype: 'component', html:'(27)퇴직소득((17))'},
							{ xtype: 'uniNumberfield', name: 'M_TAX_TOTAL_I2', id: 'M_TAX_TOTAL_I2', value:'0', readOnly:true, width: 373},
							{ xtype: 'uniNumberfield', name: 'R_TAX_TOTAL_I2', id: 'R_TAX_TOTAL_I2', value:'0', readOnly:true, width: 373},
							{ xtype: 'uniNumberfield', name: 'S_TAX_TOTAL_I2', id: 'S_TAX_TOTAL_I2', value:'0', readOnly:true, width: 373},
					    	
					    	{ xtype: 'component', html:'(28)퇴직소득정률공제'},
					    	{ xtype: 'uniNumberfield', name: '', readOnly:true, width: 373},
							{ xtype: 'uniNumberfield', name: '', readOnly:true, width: 373},
							{ xtype: 'uniNumberfield', name: 'SPEC_DED_I', id: 'SPEC_DED_I', value:'0', readOnly:true, width: 373},		    	
					    	
					    	{ xtype: 'component', html:'(29)근속연수공제'},
					    	{ xtype: 'uniNumberfield', name: '', readOnly:true, width: 373},
							{ xtype: 'uniNumberfield', name: '', readOnly:true, width: 373},
							{ xtype: 'uniNumberfield', name: 'INCOME_DED_I', id: 'INCOME_DED_I', value:'0', readOnly:true, width: 373},		    
					    	
					    	{ xtype: 'component', html:'(30)퇴직소득과세표준((27)-(28)-(29))'},
					    	{ xtype: 'uniNumberfield', name: '', readOnly:true, width: 373},
							{ xtype: 'uniNumberfield', name: '', readOnly:true, width: 373},
							{ xtype: 'uniNumberfield', name: 'TAX_STD_I', id: 'TAX_STD_I', value:'0', readOnly:true, width: 373},	    	
					    	  	
						]			
					},
			
				   {
						xtype: 'container',
						padding: '0 10 10 10',
						
						layout: {
							type: 'uniTable',
							columns:5,
							tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			    			tdAttrs: {style: 'border : 1px solid #ced9e7;'}
						},
// 						defaults: {width: 120},
						items: [
							{ xtype: 'component',  html:'퇴직소득세액계산', style: 'text-align:center', rowspan: 9, width: 30},
							
							{ xtype: 'component',  html:'계산내용', style: 'text-align:center', width: 400},
					    	{ xtype: 'component',  html:'2012.12.31이전', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'2013.1.1이후', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'합계', style: 'text-align:center'},		    	
					
							{ xtype: 'component', html:'(31)과세표준안분((30)*각근속연수/정산근속연수)'},
							{ xtype: 'uniNumberfield', name: 'DIVI_TAX_STD_BE13', id: 'DIVI_TAX_STD_BE13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'DIVI_TAX_STD_AF13', id: 'DIVI_TAX_STD_AF13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'DIVI_TAX_STD', id: 'DIVI_TAX_STD', value:'0', readOnly: true, width: 373},
					    	
					    	{ xtype: 'component', html:'(32)연평균과세표준((31)/각근속연수)'},
					    	{ xtype: 'uniNumberfield', name: 'AVG_TAX_STD_BE13', id: 'AVG_TAX_STD_BE13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'AVG_TAX_STD_AF13', id: 'AVG_TAX_STD_AF13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'AVG_TAX_STD', id: 'AVG_TAX_STD', value:'0', readOnly: true, width: 373},		    	
					    	
					    	{ xtype: 'component', html:'(33)환산과세표준((32) * 5배)'},
					    	{ xtype: 'uniNumberfield', name: '', value:'', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'EX_TAX_STD_AF13', id: 'EX_TAX_STD_AF13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'EX_TAX_STD', id: 'EX_TAX_STD', value:'0', readOnly: true, width: 373},		    
					    	
					    	{ xtype: 'component', html:'(34)환산산출세액((33) * 세율)'},
					    	{ xtype: 'uniNumberfield', name: '', value:'', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'EX_COMP_TAX_AF13', id: 'EX_COMP_TAX_AF13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'EX_COMP_TAX', id: 'EX_COMP_TAX', value:'0', readOnly: true, width: 373},
					    	
					    	{ xtype: 'component', html:'(35)연평균산출세액((34) / 5배)'},
					    	{ xtype: 'uniNumberfield', name: 'AVR_COMP_TAX_BE13', id: 'AVR_COMP_TAX_BE13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'AVR_COMP_TAX_AF13', id: 'AVR_COMP_TAX_AF13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'AVR_COMP_TAX', id: 'AVR_COMP_TAX', value:'0', readOnly: true, width: 373},
					    	
					    	{ xtype: 'component', html:'(36)산출세액((35) * 각근속연수)'},
					    	{ xtype: 'uniNumberfield', name: 'COMP_TAX_BE13', id: 'COMP_TAX_BE13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'COMP_TAX_AF13', id: 'COMP_TAX_AF13', value:'0', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'COMP_TAX', id: 'COMP_TAX', value:'0', readOnly: true, width: 373},
					    	
					    	{ xtype: 'component', html:'(37)기납부(또는 기과세이연)세액'},
					    	{ xtype: 'uniNumberfield', name: '', value:'', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'PAY_END_TAX', id: 'PAY_END_TAX', value:'0', width: 373, listeners: {'blur': function(){ SuppTotI() } }},
					    	
					    	{ xtype: 'component', html:'(38)신고대상세액((36)-(37))'},
					    	{ xtype: 'uniNumberfield', name: '', value:'', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: '', value:'', readOnly: true, width: 373},
							{ xtype: 'uniNumberfield', name: 'DEF_TAX_I', id: 'DEF_TAX_I', value:'0', readOnly: true, width: 373},
					    	  	
						]			
					},		
			
				   {
						xtype: 'container',
						padding: '0 10 10 10',
						
						layout: {
							type: 'uniTable',
							columns:9,
							tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			    			tdAttrs: {style: 'border : 1px solid #ced9e7;'}
						},
// 						defaults: {width: 130},
						items: [
							{ xtype: 'component',  html:'이연퇴직소득세액계산', style: 'text-align:center', rowspan: 3, width: 30},
							
							{ xtype: 'component',  html:'(39)신고대상세액((38))', rowspan: 2, style: 'text-align:center'},
					    	{ xtype: 'component',  html:'연금계좌 입금내역', colspan: 5, style: 'text-align:center'},
					    	{ xtype: 'component',  html:'(41)퇴직급여((17))', rowspan: 2, style: 'text-align:center'},
					    	{ xtype: 'component',  html:'(42)퇴직소득세((39)*(40)/(41))', rowspan: 2, style: 'text-align:center'},	
					    	
					    	{ xtype: 'component',  html:'연금계좌취급자', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'사업자등록번호', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'계좌번호', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'입금일', style: 'text-align:center'},	
					    	{ xtype: 'component',  html:'(40)계좌입금금액', style: 'text-align:center'},	
					
					    	{ xtype: 'uniNumberfield', name: 'DEF_TAX_I2', id: 'DEF_TAX_I2', value:'0', readOnly: true, width: 320},
							{ xtype: 'uniTextfield', name: 'COMP_NAME', value:'', width: 240},
					    	{ xtype: 'uniTextfield', name: 'COMP_NUM', value:''},
					    	{ xtype: 'uniTextfield', name: 'BANK_ACCOUNT', value:'', width: 240},		    	
					    	
					    	{ xtype: 'uniDatefield', name: 'DEPOSIT_DATE'},
					    	{ xtype: 'uniNumberfield', name: 'TRANS_RETR_PAY', id: 'TRANS_RETR_PAY', value:'0'},
					    	{ xtype: 'uniNumberfield', name: 'DEFER_TAX_TOTAL_I', id: 'DEFER_TAX_TOTAL_I', value:'0', readOnly: true},
					    	{ xtype: 'uniNumberfield', name: 'DEFER_TAX_I', id: 'DEFER_TAX_I', value:'0', readOnly: true, width: 176},			    					    			    	
					    	  	
						]			
					},
				
				   {
						xtype: 'container',
						padding: '0 10 10 10',
						
						layout: {
							type: 'uniTable',
							columns:6,
							tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			    			tdAttrs: {style: 'border : 1px solid #ced9e7;'}
						},
// 						defaults: {width: 120},
						items: [
							{ xtype: 'component',  html:'납부명세', style: 'text-align:center', rowspan: 4, width: 30},
							
							{ xtype: 'component',  html:'구분', style: 'text-align:center', width: 320},
					    	{ xtype: 'component',  html:'소득세', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'지방소득세', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'농어촌특별세', style: 'text-align:center'},
					    	{ xtype: 'component',  html:'계', style: 'text-align:center'},
					
							{ xtype: 'component', html:'(43)신고대상세액((38))'},
							{ xtype: 'uniNumberfield', name: 'IN_TAX_I1', id: 'IN_TAX_I1', value:'0', readOnly: true, width: 300},
							{ xtype: 'uniNumberfield', name: 'LOCAL_TAX_I1', id: 'LOCAL_TAX_I1', value:'0', readOnly: true, width: 300},
							{ xtype: 'uniNumberfield', name: 'SP_TAX_I1', id: 'SP_TAX_I1', value:'0', readOnly: true, width: 300},
							{ xtype: 'uniNumberfield', name: 'SUM_TAX_I1', id: 'SUM_TAX_I1', value:'0', readOnly: true, width: 300},
					    	
					    	{ xtype: 'component', html:'(44)이연퇴직소득세((42))'},
					    	{ xtype: 'uniNumberfield', name: 'IN_TAX_I2', id: 'IN_TAX_I2', value:'0', readOnly: true, width: 300},
							{ xtype: 'uniNumberfield', name: 'LOCAL_TAX_I2', id: 'LOCAL_TAX_I2', value:'0', readOnly: true, width: 300},
							{ xtype: 'uniNumberfield', name: 'SP_TAX_I2', id: 'SP_TAX_I2', value:'0', readOnly: true, width: 300},
							{ xtype: 'uniNumberfield', name: 'SUM_TAX_I2', id: 'SUM_TAX_I2', value:'0', readOnly: true, width: 300},
					    	
					    	{ xtype: 'component', html:'(45)차감원천징수세액((38)-(42))'},
					    	{ xtype: 'uniNumberfield', name: 'IN_TAX_I3', id: 'IN_TAX_I3', value:'0', readOnly: true, width: 300},
							{ xtype: 'uniNumberfield', name: 'LOCAL_TAX_I3', id: 'LOCAL_TAX_I3', value:'0', readOnly: true, width: 300},
							{ xtype: 'uniNumberfield', name: 'SP_TAX_I3', id: 'SP_TAX_I3', value:'0', readOnly: true, width: 300},
							{ xtype: 'uniNumberfield', name: 'SUM_TAX_I3', id: 'SUM_TAX_I3', value:'0', readOnly: true, width: 300},				    			    	
					    	  	
						]			
					}
								
		]
	    	
	});
 	
 	/*
	용	도 : 중간지급-퇴직급여,비과세퇴직급여,과세대상퇴직급여 계산
	*/
	function SuppTotI(){
		var M_ANNU_TOTAL_I=0, M_OUT_INCOME_I=0, R_ANNU_TOTAL_I=0, R_OUT_INCOME_I=0;
		//중간지급-퇴직급여
		if(Ext.getCmp('M_ANNU_TOTAL_I').value == ""){ M_ANNU_TOTAL_I = 0 }
		else{ M_ANNU_TOTAL_I = Ext.getCmp('M_ANNU_TOTAL_I').value; } 		
		//최종분-퇴직급여
		if(Ext.getCmp('R_ANNU_TOTAL_I').value == ""){ R_ANNU_TOTAL_I = 0 }
		else{ R_ANNU_TOTAL_I = Ext.getCmp('R_ANNU_TOTAL_I').value; }
		
		//정산-퇴직급여
		form1.setValue('S_ANNU_TOTAL_I',M_ANNU_TOTAL_I+R_ANNU_TOTAL_I);
		form1.setValue('S_TAX_TOTAL_I2',M_ANNU_TOTAL_I+R_ANNU_TOTAL_I);
		
		//중간지급-비과세퇴직급여
		if(Ext.getCmp('M_OUT_INCOME_I').value == ""){ M_OUT_INCOME_I = '' }
		else{ M_OUT_INCOME_I = Ext.getCmp('M_OUT_INCOME_I').value; }
		
		//최종분-비과세퇴직급여
		if(Ext.getCmp('R_OUT_INCOME_I').value == ""){ R_OUT_INCOME_I = '' }
		else{ R_OUT_INCOME_I = Ext.getCmp('R_OUT_INCOME_I').value; }
		
		//정산-비과세퇴직급여
		form1.setValue('S_OUT_INCOME_I',M_OUT_INCOME_I+R_OUT_INCOME_I);
		
		//중간지급-과세대상퇴직급여
		form1.setValue('M_TAX_TOTAL_I',M_ANNU_TOTAL_I-M_OUT_INCOME_I);
		form1.setValue('M_TAX_TOTAL_I2',M_ANNU_TOTAL_I-M_OUT_INCOME_I);
		
		//최종분-과세대상퇴직급여
		form1.setValue('R_TAX_TOTAL_I',R_ANNU_TOTAL_I-R_OUT_INCOME_I);
		
		//정산-과세대상퇴직급여
		form1.setValue('S_TAX_TOTAL_I',M_ANNU_TOTAL_I+R_ANNU_TOTAL_I-M_OUT_INCOME_I-R_OUT_INCOME_I);
		
		//이연퇴직소득세액계산-퇴직급여
		form1.setValue('DEFER_TAX_TOTAL_I',R_ANNU_TOTAL_I-R_OUT_INCOME_I);
		
		fnRetireProcSTChangedSuppTotal();
		
		DeferTaxI();
	}
	
	function DeferTaxI(){
		var DEF_TAX_I2=0, TRANS_RETR_PAY=0, RETR_TAX_I=0, DEFER_TAX_I=0;
	
		DEF_TAX_I2		= Ext.getCmp('DEF_TAX_I2').value;
		TRANS_RETR_PAY	= Ext.getCmp('TRANS_RETR_PAY').value;
		RETR_TAX_I		= Ext.getCmp('DEFER_TAX_TOTAL_I').value;
		
		if(RETR_TAX_I == 0){
			DEFER_TAX_I = 0;
		}else{
			DEFER_TAX_I = (DEF_TAX_I2 * TRANS_RETR_PAY) / RETR_TAX_I;
		}
		form1.setValue('DEFER_TAX_I',DEFER_TAX_I);
		form1.setValue('IN_TAX_I2',DEFER_TAX_I);
		form1.setValue('LOCAL_TAX_I2',DEFER_TAX_I * (10/100));
		
		InLocalTaxI();
	}
	
	function InLocalTaxI(){
		var IN_TAX_I1, LOCAL_TAX_I1, SP_TAX_I1, SUM_TAX_I1;
		var IN_TAX_I2, LOCAL_TAX_I2, SP_TAX_I2, SUM_TAX_I2;
		var IN_TAX_I3, LOCAL_TAX_I3, SP_TAX_I3, SUM_TAX_I3;
	
		IN_TAX_I1			= Ext.getCmp('IN_TAX_I1').value;
		LOCAL_TAX_I1			= Ext.getCmp('LOCAL_TAX_I1').value;
		SP_TAX_I1			= Ext.getCmp('SP_TAX_I1').value;
	
		SUM_TAX_I1			= IN_TAX_I1 + LOCAL_TAX_I1 + SP_TAX_I1;		
		form1.setValue('SUM_TAX_I1',SUM_TAX_I1);	
	
		IN_TAX_I2			= Ext.getCmp('IN_TAX_I2').value;
		LOCAL_TAX_I2			= Ext.getCmp('LOCAL_TAX_I2').value;
		SP_TAX_I2			= Ext.getCmp('SP_TAX_I2').value;
	
		SUM_TAX_I2			= IN_TAX_I2 + LOCAL_TAX_I2 + SP_TAX_I2;		
		form1.setValue('SUM_TAX_I2',SUM_TAX_I2);		
		
	
		IN_TAX_I3			= (IN_TAX_I1 - IN_TAX_I2) / 10 * 10;
		LOCAL_TAX_I3			= (LOCAL_TAX_I1 - LOCAL_TAX_I2) / 10 * 10;
		SP_TAX_I3			= (SP_TAX_I1 - SP_TAX_I2) / 10 * 10;
				
		SUM_TAX_I3			= IN_TAX_I3 + LOCAL_TAX_I3 + SP_TAX_I3;
		
		form1.setValue('IN_TAX_I3',IN_TAX_I3);
		form1.setValue('LOCAL_TAX_I3',LOCAL_TAX_I3);
		form1.setValue('SP_TAX_I3',SP_TAX_I3);
		form1.setValue('SUM_TAX_I3',SUM_TAX_I3);	
		
		form1.setValue('IN_TAX_I',IN_TAX_I3);	//소득세
		form1.setValue('LOCAL_TAX_I',LOCAL_TAX_I3);	//지방소득
		form1.setValue('SP_TAX_I',SP_TAX_I3);	//농어촌
	
		//공제총액		
// 		form1.setValue('DED_TOTAL_I',Ext.getCmp('IN_TAX_I').value + Ext.getCmp('LOCAL_TAX_I').value + Ext.getCmp('SP_TAX_I').value + Ext.getCmp('DED_IN_TAX_ADD_I').value + Ext.getCmp('DED_IN_LOCAL_ADD_I').value + Ext.getCmp('DED_ETC_I').value);
		//실지급액		
		form1.setValue('REAL_AMOUNT_I',Ext.getCmp('RETR_SUM_I').value - Ext.getCmp('DED_TOTAL_I').value);
	}
	 	
	/*
	 * 용      도 : 퇴직금 재계산(퇴직급여/명예퇴직금/퇴직보험금/비과세소득/기타지급 변경에 의한 세액 재계산)
	*/
 	function fnRetireProcSTChangedSuppTotal(){
 		//검색 조건 파라미터
    	var param= Ext.getCmp('SearchForm').getValues();
// 		var param= form1.getValues();
    	// 전송용 파라미터
    	var params = new Object();
    	params.S_COMP_CODE = UserInfo.compCode;	//법인코드
    	params.PERSON_NUMB = param.PERSON_NUMB;	//사번
    	params.RETR_TYPE = param.RETR_TYPE; // 정산구분
    	params.RETR_DATE = param.RETR_DATE; // 정산일
    	params.TAX_CALCU = 'Y'; // 세액계산여부
//     	params.TAX_CALCU = param.TAX_CALCU; // 세액계산여부
		params.R_ANNU_TOTAL_I = form1.getForm().findField('R_ANNU_TOTAL_I').getValue(); // 최종분-퇴직급여
    	params.R_OUT_INCOME_I = form1.getForm().findField('R_OUT_INCOME_I').getValue(); // 최종분-퇴직급여(비과세)
    	params.M_ANNU_TOTAL_I = form1.getForm().findField('M_ANNU_TOTAL_I').getValue(); // 중도정산-퇴직급여 
    	params.M_OUT_INCOME_I = form1.getForm().findField('M_OUT_INCOME_I').getValue(); // 중도정산-퇴직급여 (비과세)
    	params.PAY_END_TAX = form1.getForm().findField('PAY_END_TAX').getValue(); // 기납부세액
    	params.DED_IN_TAX_ADD_I = form1.getForm().findField('DED_IN_TAX_ADD_I').getValue(); // 소득세환급액
    	params.DED_IN_LOCAL_ADD_I = form1.getForm().findField('DED_IN_LOCAL_ADD_I').getValue(); // 주민세환급액
    	params.DED_ETC_I = form1.getForm().findField('DED_ETC_I').getValue(); // 기타공제
    	params.LONG_YEARS = form1.getForm().findField('S_LONG_YEARS').getValue(); // 정산(합산)근속연수    	
    	params.LONG_YEARS_BE13 = form1.getForm().findField('LONG_YEARS_BE13').getValue(); // 2013이전근속연수
    	params.LONG_YEARS_AF13 = form1.getForm().findField('LONG_YEARS_AF13').getValue(); // 2013이후근속연수
    	params.R_CALCU_END_DATE = form1.getForm().findField('R_CALCU_END_DATE').getValue(); // 최종분-기산일	
    	
    	console.log(params);
    	
    	Ext.Ajax.request({
			url: CPATH+'/human/fnSuppTotI502.do',
			params: params,
			success: function(response){
				data = Ext.decode(response.responseText);
				console.log('data',data);
				
				/* 세액내역 */
		    	form1.setValue('SUPP_TOTAL_I',data.IN_TAX_I3);		//(숨김)퇴직급여액
		    	
		    	form1.setValue('SPEC_DED_I',data.SPEC_DED_I);			//퇴직소득정률공제
		    	form1.setValue('INCOME_DED_I',data.INCOME_DED_I);		//근속연수공제
		    	form1.setValue('EARN_INCOME_I',data.EARN_INCOME_I);	//(숨김)퇴직소득공제
		    	
		    	form1.setValue('DIVI_TAX_STD_BE13',data.DIVI_TAX_STD_BE13);	//(31)과세표준안분_이전
		    	form1.setValue('DIVI_TAX_STD_AF13',data.DIVI_TAX_STD_AF13);	//(31)과세표준안분_이후
		    	form1.setValue('DIVI_TAX_STD',data.TAX_STD_I);						//(31)과세표준안분_정산(합산)
		    	form1.setValue('TAX_STD_I',data.TAX_STD_I);								//(숨김)과세표준
		    	
		    	form1.setValue('AVG_TAX_STD_BE13',data.AVG_TAX_STD_BE13);					//(32)연평균과세표준_이전
		    	form1.setValue('AVG_TAX_STD_AF13',data.AVG_TAX_STD_AF13);					//(32)연평균과세표준_이후
		    	form1.setValue('AVG_TAX_STD',data.AVG_TAX_STD_I);						//(32)연평균과세표준_정산(합산)
		    	
		    	form1.setValue('EX_TAX_STD_AF13',data.EX_TAX_STD_AF13);		//(33)환산과세표준_이후
		    	form1.setValue('EX_TAX_STD',data.EX_TAX_STD_AF13);				//(33)환산과세표준_정산(합산)
		    	
		    	form1.setValue('EX_COMP_TAX_AF13',data.EX_COMP_TAX_AF13);	//(34)환산산출세액_이후
		    	form1.setValue('EX_COMP_TAX',data.EX_COMP_TAX_AF13);			//(34)환산산출세액_정산(합산)
		    	
		    	form1.setValue('AVR_COMP_TAX_BE13',data.AVR_COMP_TAX_BE13);	//(35)연평균산출세액_이전
		    	form1.setValue('AVR_COMP_TAX_AF13',data.AVR_COMP_TAX_AF13);	//(35)연평균산출세액_이후
		    	form1.setValue('AVR_COMP_TAX',data.AVR_COMP_TAX_I);				//(35)연평균산출세액_정산(합산)
		    	
		    	form1.setValue('COMP_TAX_BE13',data.COMP_TAX_BE13);				//(36)산출세액_이전
		    	form1.setValue('COMP_TAX_AF13',data.COMP_TAX_AF13);				//(36)산출세액_이후
		    	form1.setValue('COMP_TAX_I',data.COMP_TAX_I);						//(36)산출세액_정산(합산)
		    	
		    	form1.setValue('DEF_TAX_I',data.DEF_TAX_I);								//결정세액
		    	
		    	/* 공제내역 */
		    	form1.setValue('IN_TAX_I1',data.IN_TAX_I);									//소득세
		    	form1.setValue('LOCAL_TAX_I1',data.LOCAL_TAX_I);						//지방소득세
		    	
//		     	form1.setValue('DED_IN_TAX_ADD_I',data.DED_IN_TAX_ADD_I);		//소득세 환급액
//		     	form1.setValue('DED_IN_LOCAL_ADD_I',data.DED_IN_LOCAL_ADD_I);//주민세 환급액
//		     	form1.setValue('DED_ETC_I',data.DED_ETC_I);								//기타공제
		    	form1.setValue('DED_TOTAL_I',data.DED_TOTAL_I);						//공제총액
		    	
		    	form1.setValue('IN_TAX_I3',data.DEF_IN_TAX_I);					//신고대상세액(소득세)
		    	form1.setValue('LOCAL_TAX_I3',data.DEF_LOCAL_TAX_I);		//신고대상세액(지방소득세)
		    	
		    	form1.setValue('REAL_AMOUNT_I',data.REAL_AMOUNT_I);				//실지급액
		    	/* 이연퇴직소득세액계산의 데이터 */
		    	form1.setValue('DEF_TAX_I2',data.DEF_TAX_I);							//결정세액(DEF_IN_TAX_I=DEF_TAX_I)

			},
			failure: function(response){
				console.log(response);
			}
		});
    	

    	
 	}
	
	/*
	 * 용	도 : 중간지급-퇴직급여,비과세퇴직급여,과세대상퇴직급여 계산
	 */	 
	function fnDateChanged(){
		//검색 조건 파라미터
    	var param= Ext.getCmp('SearchForm').getValues();
// 		var param= form1.getValues();
    	// 전송용 파라미터
    	var params = new Object();
    	params.S_COMP_CODE = UserInfo.compCode;	//법인코드    	
    	params.M_CALCU_END_DATE = form1.getForm().findField('M_CALCU_END_DATE').getValue();	//(19)기산일_중간
    	params.M_RETR_DATE = form1.getForm().findField('M_RETR_DATE').getValue();	//(20)퇴사일_중간
    	params.M_EXEP_MONTHS_BE13 = form1.getForm().findField('M_EXEP_MONTHS_BE13').getValue();	//(23)제외월수_중간(2013이전)
    	params.M_EXEP_MONTHS_AF13 = form1.getForm().findField('M_EXEP_MONTHS_AF13').getValue();	//(23)제외월수_중간(2013이후)
    	params.M_ADD_MONTHS_BE13 = form1.getForm().findField('M_ADD_MONTHS_BE13').getValue();		//(24)가산월수_중간(2013이전)
    	params.M_ADD_MONTHS_AF13 = form1.getForm().findField('M_ADD_MONTHS_AF13').getValue();	//(24)가산월수_중간(2013이후)
    	params.R_CALCU_END_DATE = form1.getForm().findField('R_CALCU_END_DATE').getValue();			//(19)기산일_최종
    	params.R_RETR_DATE = form1.getForm().findField('R_RETR_DATE').getValue();							//(20)퇴사일_최종
    	params.R_EXEP_MONTHS_BE13 = form1.getForm().findField('R_EXEP_MONTHS_BE13').getValue();	//(23)제외월수_최종(2013이전)
    	params.R_EXEP_MONTHS_AF13 = form1.getForm().findField('R_EXEP_MONTHS_AF13').getValue();	//(23)제외월수_최종(2013이후)
    	params.R_ADD_MONTHS_BE13 = form1.getForm().findField('R_ADD_MONTHS_BE13').getValue();		//(24)가산월수_최종(2013이전)
    	params.R_ADD_MONTHS_AF13 = form1.getForm().findField('R_ADD_MONTHS_AF13').getValue();		//(24)가산월수_최종(2013이후)
    	
    	console.log(params);
    	
    	Ext.Ajax.request({
			url: CPATH+'/human/fnDateChanged.do',
			params: params,
			success: function(response){
				data = Ext.decode(response.responseText);
				console.log('fnDateChanged',data);
					
				form1.setValue('M_LONG_MONTHS',data.M_LONG_MONTHS);		//(22)근속월수_중간
				form1.setValue('M_EXEP_MONTHS',data.M_EXEP_MONTHS);		//(23)제외월수_중간
				form1.setValue('M_ADD_MONTHS',data.M_ADD_MONTHS);		//(24)가산월수_중간
				form1.setValue('M_LONG_YEARS',data.M_LONG_YEARS);		//(26)근속연수_중간
				
				form1.setValue('R_LONG_MONTHS',data.R_LONG_MONTHS);		//(22)근속월수_최종
				form1.setValue('R_EXEP_MONTHS',data.R_EXEP_MONTHS);		//(23)제외월수_최종
				form1.setValue('R_ADD_MONTHS',data.R_ADD_MONTHS);		//(24)가산월수_최종
				form1.setValue('R_LONG_YEARS',data.R_LONG_YEARS);		//(26)근속연수_최종
				
				form1.setValue('S_CALCU_END_DATE',data.S_CALCU_END_DATE);		//(19)기산일_정산
				form1.setValue('S_RETR_DATE',data.S_RETR_DATE);		//(20)퇴사일_정산
				form1.setValue('S_LONG_MONTHS',data.S_LONG_MONTHS);		//(22)근속월수_정산
				form1.setValue('S_EXEP_MONTHS',data.S_EXEP_MONTHS);		//(23)제외월수_정산
				form1.setValue('S_ADD_MONTHS',data.S_ADD_MONTHS);		//(24가산월수_정산)
				form1.setValue('S_DUPLI_MONTHS',data.S_DUPLI_MONTHS);		//(25)중복월수
				form1.setValue('S_LONG_YEARS',data.S_LONG_YEARS);		//(26)근속연수_정산
				
				form1.setValue('CALCU_END_DATE_BE13',data.CALCU_END_DATE_BE13);		//(19)기산일_이전
				form1.setValue('RETR_DATE_BE13',data.RETR_DATE_BE13);		//(20)퇴사일_이전
				form1.setValue('LONG_MONTHS_BE13',data.LONG_MONTHS_BE13);		//(22)근속월수_이전
				form1.setValue('EXEP_MONTHS_BE13',data.EXEP_MONTHS_BE13);		//(23)제외월수_이전
				form1.setValue('ADD_MONTHS_BE13',data.ADD_MONTHS_BE13);		//(24)가산월수_이전
				form1.setValue('LONG_YEARS_BE13',data.LONG_YEARS_BE13);		//(26)근속연수_이전
				
				form1.setValue('CALCU_END_DATE_AF13',data.CALCU_END_DATE_AF13);		//(19)기산일_이후
				form1.setValue('RETR_DATE_AF13',data.RETR_DATE_AF13);		//(20)퇴사일_이후
				form1.setValue('LONG_MONTHS_AF13',data.LONG_MONTHS_AF13);		//(22)근속월수_이후
				form1.setValue('EXEP_MONTHS_AF13',data.EXEP_MONTHS_AF13);		//(23)제외월수_이후
				form1.setValue('ADD_MONTHS_AF13',data.ADD_MONTHS_AF13);		//(24)가산월수_이후
				form1.setValue('LONG_YEARS_AF13',data.LONG_YEARS_AF13);		//(26)근속연수_이후				
				
				form1.setValue('JOIN_DATE',data.S_CALCU_END_DATE);		//정산시작일
				form1.setValue('DUTY_YYYY',data.DUTY_YYYY);		//근속년
				form1.setValue('LONG_MONTH',data.LONG_MONTH);		//근속월
				form1.setValue('LONG_DAY',data.LONG_DAY);		//근속일
				form1.setValue('LONG_TOT_DAY',data.LONG_TOT_DAY);		//근속일수
				form1.setValue('LONG_TOT_MONTH',data.LONG_TOT_MONTH);		//근속월수
				form1.setValue('LONG_YEARS',data.LONG_YEARS);		//근속년수
				form1.setValue('AVG_DAY',data.AVG_DAY);		//3개월총일수
				
				
			},
			failure: function(response){
				console.log(response);
			}
		});
	}
	    
   

    Unilite.Main( {    	
		borderItems : [ form1],
		id  : 'hrt502ukrvApp',
		fnInitBinding : function() {
// 			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',true);
		},
		onQueryButtonDown : function()	{				
			var RETR_TYPE = Ext.getCmp('RETR_TYPE').value;
			var RETR_DATE = Ext.getCmp('RETR_DATE').value;
			var PERSON_NUMB = Ext.getCmp('PERSON_NUMB').value;
			
			var param = form1.getForm().getValues();
			
			form1.getForm().load( {params : { 'RETR_TYPE':RETR_TYPE, 'RETR_DATE':RETR_DATE, 'PERSON_NUMB':PERSON_NUMB}} );		
			
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onSaveDataButtonDown: function(){				
			var param = form1.getForm().getValues();
			console.log("param",param);
			form1.getForm().submit( {params : param} );
		}
		
	});

};


</script>
