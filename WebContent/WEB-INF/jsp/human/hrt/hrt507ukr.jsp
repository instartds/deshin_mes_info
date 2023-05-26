<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hrt507ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H053" />
</t:appConfig>
<style type="text/css">
</style>
<script type="text/javascript" >

function appMain() {

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		width: 380,
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{
			title: '기본정보',
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [
		     	Unilite.popup('Employee',{
				validateBlank: true,
				allowBlank: false,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					}
				}
			}),
			{
				fieldLabel: '정산구분',
				name:'RETR_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H053',
				hidden:true
			}, {
		        fieldLabel: '정산일',
		        xtype: 'uniDatefield',
		        name: 'RETR_DATE',
				hidden:true
			},
			{
                fieldLabel: '지급일',
                xtype: 'uniDatefield',
                name: 'SUPP_DATE',
                hidden:true
            }
		]}
	]}
	);		// end of var panelSearch = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 7},
		padding:'1 1 1 1',
		border:true,
    	items: [
	     	Unilite.popup('Employee',{
			validateBlank: true,
			allowBlank: false,
			colspan: 4,
			width:270,
			listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);
				}
			}
		}),{
            fieldLabel: '정산구분',
            name:'RETR_TYPE',
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'H053',
            hidden:true,
            allowBlank: false,
            labelWidth: 118,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                }
            }
        }, {
            fieldLabel: '정산일',
            xtype: 'uniDatefield',
            allowBlank: false, 
            hidden:true,
            name: 'RETR_DATE',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                }
            }
        },{
                fieldLabel: '지급일',
                xtype: 'uniDatefield',
                allowBlank: false,
                name: 'SUPP_DATE',
                hidden:true
            },{
            xtype: 'component'
        },{
            xtype: 'component'
        },{
            xtype:'button',
            itemId:'hrt507btn',
            text:'출력',
            tdAttrs:{'align':'right', 'width':'100%', 'style':'padding-right:10px;'},
            handler:function()    {
                var params = {
                    'PERSON_NUMB' : panelResult.getValue('PERSON_NUMB'),
                    'NAME' : panelResult.getValue('NAME'),
                    'RETR_TYPE' : panelResult.getValue('RETR_TYPE'),
                    'RETR_DATE' : UniDate.getDateStr(panelResult.getValue('RETR_DATE')),
                    'SUPP_DATE' : UniDate.getDateStr(panelResult.getValue('SUPP_DATE'))
                }  
                var rec = {data : {prgID : 'hrt716rkr', 'text':'퇴직금소득영수증'}};                            
                parent.openTab(rec, '/human/hrt716rkr.do', params);
                
            }
        }]
    });

    var mainTable = Unilite.createForm('hrt507ukrMainTable',{
    	padding:'0 1 0 1',
//	    title:'&nbsp;',
		border: true,
		disabled: false,
		height: 230,
		region: 'center',
		layout: {
			type: 'uniTable',
			columns: 1
		},
		defaults: {readOnly: true},
		items: [{
			xtype: 'container',
			padding: '5 7 0 7',
			layout: {
				type: 'uniTable',
				columns:4,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
			},
			defaults:{padding: '0 0 1 0'},
			items:[
				{ xtype: 'uniDatefield',   name: 'RETR_DATE' 			,hidden:true},
				{ xtype: 'uniTextfield',   name: 'PERSON_NUMB' 			,hidden:true},
				{ xtype: 'uniTextfield',   name: 'RETR_TYPE' 			,hidden:true},
				{ xtype: 'uniDatefield',   name: 'JOIN_DATE' 			,hidden:true},
				{ xtype: 'uniTextfield',   name: 'DUTY_YYYY' 			,hidden:true},
				{ xtype: 'uniTextfield',   name: 'LONG_MONTH' 			,hidden:true},
				{ xtype: 'uniTextfield',   name: 'LONG_DAY' 			,hidden:true},
				{ xtype: 'uniTextfield',   name: 'LONG_TOT_DAY' 		,hidden:true},
				{ xtype: 'uniTextfield',   name: 'ADD_MONTH' 			,hidden:true},
				{ xtype: 'uniTextfield',   name: 'LONG_TOT_MONTH' 		,hidden:true},
				{ xtype: 'uniTextfield',   name: 'LONG_YEARS' 			,hidden:true},
				{ xtype: 'uniTextfield',   name: 'AVG_DAY' 				,hidden:true},
				{ xtype: 'uniNumberfield', name: 'RETR_SUM_I' 			,hidden:true},
				{ xtype: 'uniNumberfield', name: 'SUPP_TOTAL_I' 		,hidden:true},
				{ xtype: 'uniNumberfield', name: 'EARN_INCOME_I' 		,hidden:true},
				{ xtype: 'uniNumberfield', name: 'IN_TAX_I' 			,hidden:true},
				{ xtype: 'uniNumberfield', name: 'LOCAL_TAX_I' 			,hidden:true},
				{ xtype: 'uniNumberfield', name: 'SP_TAX_I' 			,hidden:true},
				{ xtype: 'uniNumberfield', name: 'DED_IN_TAX_ADD_I' 	,hidden:true},
				{ xtype: 'uniNumberfield', name: 'DED_IN_LOCAL_ADD_I' 	,hidden:true},
				{ xtype: 'uniNumberfield', name: 'DED_ETC_I' 			,hidden:true},
				{ xtype: 'uniNumberfield', name: 'DED_TOTAL_I' 			,hidden:true},
				{ xtype: 'uniNumberfield', name: 'REAL_AMOUNT_I' 		,hidden:true},
				{ xtype: 'uniTextfield', name: 'RETR_PENSION_KIND' 		,hidden:true},


				{ xtype: 'component',  html:'주민등록번호', tdAttrs: {width: 193, height: 34}},
				{ xtype: 'uniTextfield', name: 'REPRE_NUM', width: '99.7%', readOnly: true,
				listeners:{
					blur: function(field, event, eOpts ){
                            if(field.lastValue != field.originalValue){
                                if(!Ext.isEmpty(field.lastValue)){
                                    var param = {
                                        "DECRYP_WORD" : field.lastValue
                                    };
                                    humanCommonService.encryptField(param, function(provider, response)  {
                                        if(!Ext.isEmpty(provider)){
                                            mainTable.setValue('REPRE_NUM_EXPOS',provider);
                                        }else{
                                            mainTable.setValue('REPRE_NUM',"");
                                            mainTable.setValue('REPRE_NUM_EXPOS',"");
                                        }
                                        field.originalValue = field.lastValue; 
                                    });
                                }else{
                                    mainTable.setValue('REPRE_NUM_EXPOS',"");
                                }
                            }
                        },
                    afterrender:function(field) {
                        field.getEl().on('dblclick', field.onDblclick);
                    }
                },
                     onDblclick:function(event, elm) {
                     	var params = {'INCRYP_WORD':mainTable.getValue('REPRE_NUM_EXPOS')};
                        Unilite.popupDecryptCom(params);
                     }
                },
                { xtype: 'uniTextfield', name: 'REPRE_NUM_EXPOS', hidden:true , width: '99%', tdAttrs: {width: 200}},
				{ xtype: 'component',  html:'주소', tdAttrs: {width: 193}},
				{ xtype: 'uniTextfield', name: 'ADDR_NAME', width: '99.9%', tdAttrs: {width: 812}, readOnly: true},

				{ xtype: 'component',  html:'귀속연도', tdAttrs: {height: 34}},
				{ xtype: 'container',
				  margin: '0 0 0 1',
				  layout: {type: 'hbox', align: 'stretch'},
				  defaults: {readOnly: true},
				  items:[{
					  	xtype: 'uniDatefield', name: 'RETR_DATE_FR', fieldStyle: "text-align: center;", suffixTpl: '부터', padding: '0 0 2 0'
				  },{
					  	xtype: 'uniDatefield', name: 'RETR_DATE_TO', fieldStyle: "text-align: center;", suffixTpl: '까지', padding: '0 0 2 0'
				  }]
				},
				{ xtype: 'component',  html:'퇴사사유', tdAttrs: {height: 34}},
				{
		    		xtype: 'radiogroup',
		    		tdAttrs: {align : 'left'},
		    		items: [
		    			{boxLabel: '졍년퇴직', width: 92, name: 'RETR_RESN', inputValue: '1'},
		    			{boxLabel: '정리해고', width: 92, name: 'RETR_RESN', inputValue: '2'},
		    			{boxLabel: '자발적퇴직', width: 92, name: 'RETR_RESN', inputValue: '3'},
		    			{boxLabel: '임원퇴직', width: 92, name: 'RETR_RESN', inputValue: '4'},
		    			{boxLabel: '중간정산', width: 92, name: 'RETR_RESN', inputValue: '5'},
		    			{boxLabel: '기타', width: 92, name: 'RETR_RESN', inputValue: '6'}
		    		]
		        },
		        { xtype: 'component',  html:'확정급여형 퇴직연금</br>제도 가입일'},
		        { xtype: 'uniDatefield', name: 'RETR_ANN_JOIN_DATE', tdAttrs: {align : 'left'}, margin: '0 0 0 1'},
				{ xtype: 'component',  html:'2011.12.31 퇴직금'},
				{ xtype: 'uniNumberfield', name: 'RETR_ANNU_I_20111231', tdAttrs: {align : 'left'}, readOnly: true, value: 0, margin: '0 0 0 2'}

			]
		}, {
			xtype: 'container',
			padding: '5 7 0 7',
			layout: {
				type: 'uniTable',
				columns:5,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
			},
			defaults:{padding: '0 0 1 0'},
			items:[
				{ xtype: 'component',  html:'퇴직</br>급여</br>현황', width: 40, tdAttrs: {width: 40}, rowspan: 6},
				{ xtype: 'component',  html:'근무처구분', tdAttrs: {height: 30}},
				{ xtype: 'component',  html:'중간지급&nbsp;&nbsp;등', width: '99.2%' , tdAttrs: {width: 400}},
				{ xtype: 'component',  html:'최&nbsp;&nbsp;종', width: '99.2%' , tdAttrs: {width: 400}},
				{ xtype: 'component',  html:'정&nbsp;&nbsp;산', width: '99.2%' , tdAttrs: {width: 400}},

				{ xtype: 'component',  html:'&nbsp;&nbsp;(13)근무처명', tdAttrs: {align : 'left'}},
				{ xtype: 'uniTextfield', name: 'M_DIV_NAME', width: '99.2%' , tdAttrs: {width: 400}},
				{ xtype: 'uniTextfield', name: 'R_DIV_NAME', width: '99.2%' , tdAttrs: {width: 400}, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},

				{ xtype: 'component',  html:'&nbsp;&nbsp;(14)사업자등록번호', tdAttrs: {align : 'left'}},
				{ xtype: 'uniTextfield', name: 'M_COMPANY_NUM', width: '99.2%' , tdAttrs: {width: 400}},
				{ xtype: 'uniTextfield', name: 'R_COMPANY_NUM', width: '99.2%' , tdAttrs: {width: 400}, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},

				{ xtype: 'component',  html:'&nbsp;&nbsp;(15)퇴직급여', tdAttrs: {align : 'left'}},
				{ xtype: 'uniNumberfield', name: 'M_ANNU_TOTAL_I', width: '99.2%' , tdAttrs: {width: 400}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'R_ANNU_TOTAL_I', width: '99.2%' , tdAttrs: {width: 400}, value: 0, readOnly: true},
				{ xtype: 'uniNumberfield', name: 'S_ANNU_TOTAL_I', width: '99.2%' , tdAttrs: {width: 400}, value: 0, readOnly: true},

				{ xtype: 'component',  html:'&nbsp;&nbsp;(16)비과세 퇴직급여', tdAttrs: {align : 'left'}},
				{ xtype: 'uniNumberfield', name: 'M_OUT_INCOME_I', width: '99.2%' , tdAttrs: {width: 400}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'R_OUT_INCOME_I', width: '99.2%' , tdAttrs: {width: 400}, value: 0, readOnly: true},
				{ xtype: 'uniNumberfield', name: 'S_OUT_INCOME_I', width: '99.2%' , tdAttrs: {width: 400}, value: 0, readOnly: true},

				{ xtype: 'component',  html:'&nbsp;&nbsp;(17)과세대상 퇴직급여((15)-(16))', tdAttrs: {align : 'left'}},
				{ xtype: 'uniNumberfield', name: 'M_TAX_TOTAL_I', width: '99.2%' , tdAttrs: {width: 400}, value: 0, readOnly: true},
				{ xtype: 'uniNumberfield', name: 'R_TAX_TOTAL_I', width: '99.2%' , tdAttrs: {width: 400}, value: 0, readOnly: true},
				{ xtype: 'uniNumberfield', name: 'S_TAX_TOTAL_I', width: '99.2%' , tdAttrs: {width: 400}, value: 0, readOnly: true}
			]
		}, {
			xtype: 'container',
			padding: '5 7 0 7',
			layout: {
				type: 'uniTable',
				columns:16,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
			},
			defaults:{padding: '0 0 1 0'},
			items:[
				{ xtype: 'component',  html:'근속</br>연수', width: 40, tdAttrs: {width: 40}, rowspan: 7},
				{ xtype: 'component',  html:'구&nbsp;&nbsp;분', rowspan: 2, colspan: 2},
				{ xtype: 'component',  html:'(18)입사일', rowspan: 2, width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'(19)기산일', rowspan: 2, width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'(20)퇴사일', rowspan: 2, width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'(21)지급일', rowspan: 2, width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'(22)근속월수', rowspan: 2, width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'(23)제외월수', colspan: 3, width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'(24)가산월수', colspan: 3, width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'(25)중복월수', rowspan: 2, width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'(26)근속연수', rowspan: 2, width: '97%', tdAttrs: {width: 92}},

				{ xtype: 'component',  html:'2012이전', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'2013이후', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'합계', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'2012이전', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'2013이후', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'component',  html:'합계', width: '97%', tdAttrs: {width: 92}},

				{ xtype: 'component',  html:'&nbsp;&nbsp;중간지급 근속연수', tdAttrs: {align : 'left'}, colspan: 2},
				{ xtype: 'uniDatefield', name: 'M_JOIN_DATE', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'uniDatefield', name: 'M_CALCU_END_DATE', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'uniDatefield', name: 'M_RETR_DATE', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'uniDatefield', name: 'M_SUPP_DATE', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'uniNumberfield', name: 'M_LONG_MONTHS', width: '97%', tdAttrs: {width: 92}, readOnly: true, value: 0},
				{ xtype: 'uniNumberfield', name: 'M_EXEP_MONTHS_BE13', width: '97%', tdAttrs: {width: 92}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'M_EXEP_MONTHS_AF13', width: '97%', tdAttrs: {width: 92}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'M_EXEP_MONTHS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},
				{ xtype: 'uniNumberfield', name: 'M_ADD_MONTHS_BE13', width: '97%', tdAttrs: {width: 92}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'M_ADD_MONTHS_AF13', width: '97%', tdAttrs: {width: 92}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'M_ADD_MONTHS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'M_LONG_YEARS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},

				{ xtype: 'component',  html:'&nbsp;&nbsp;최종 근속연수', tdAttrs: {align : 'left'}, colspan: 2},
				{ xtype: 'uniDatefield', name: 'R_JOIN_DATE', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'uniDatefield', name: 'R_CALCU_END_DATE', width: '97%', tdAttrs: {width: 92}},
				{ xtype: 'uniDatefield', name: 'R_RETR_DATE', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'uniDatefield', name: 'R_SUPP_DATE', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'uniNumberfield', name: 'R_LONG_MONTHS', width: '97%', tdAttrs: {width: 92}, readOnly: true, value: 0},
				{ xtype: 'uniNumberfield', name: 'R_EXEP_MONTHS_BE13', width: '97%', tdAttrs: {width: 92}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'R_EXEP_MONTHS_AF13', width: '97%', tdAttrs: {width: 92}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'R_EXEP_MONTHS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},
				{ xtype: 'uniNumberfield', name: 'R_ADD_MONTHS_BE13', width: '97%', tdAttrs: {width: 92}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'R_ADD_MONTHS_AF13', width: '97%', tdAttrs: {width: 92}, value: 0, minValue:0},
				{ xtype: 'uniNumberfield', name: 'R_ADD_MONTHS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'R_LONG_YEARS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},

				{ xtype: 'component',  html:'&nbsp;&nbsp;정산 근속연수', tdAttrs: {align : 'left'}, colspan: 2},
				{ xtype: 'uniDatefield', name: 'S_JOIN_DATE', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'uniDatefield', name: 'S_CALCU_END_DATE', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'uniDatefield', name: 'S_RETR_DATE', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'S_LONG_MONTHS', width: '97%', tdAttrs: {width: 92}, readOnly: true, value: 0},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'S_EXEP_MONTHS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'S_ADD_MONTHS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},
				{ xtype: 'uniNumberfield', name: 'S_DUPLI_MONTHS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},
				{ xtype: 'uniNumberfield', name: 'S_LONG_YEARS', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},

				{ xtype: 'component',  html:'&nbsp;&nbsp;안분', tdAttrs: {align : 'left'}, rowspan: 2},
				{ xtype: 'component',  html:'&nbsp;&nbsp;2012.12.31 이전', tdAttrs: {align : 'left'}},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniDatefield', name: 'CALCU_END_DATE_BE13', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'uniDatefield', name: 'RETR_DATE_BE13', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'LONG_MONTHS_BE13', width: '97%', tdAttrs: {width: 92}, readOnly: true, value: 0},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'EXEP_MONTHS_BE13', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'ADD_MONTHS_BE13', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'LONG_YEARS_BE13', width: '97%', tdAttrs: {width: 92}, value: 0, readOnly: true},

				{ xtype: 'component',  html:'&nbsp;&nbsp;2013.01.01 이후', tdAttrs: {align : 'left'}},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniDatefield', name: 'CALCU_END_DATE_AF13', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'uniDatefield', name: 'RETR_DATE_AF13', width: '97%', tdAttrs: {width: 92}, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'LONG_MONTHS_AF13', width: '97%', tdAttrs: {width: 93}, readOnly: true, value: 0},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'EXEP_MONTHS_AF13', width: '97%', tdAttrs: {width: 93}, value: 0, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'ADD_MONTHS_AF13', width: '97%', tdAttrs: {width: 93}, value: 0, readOnly: true},
				{ xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
				{ xtype: 'uniNumberfield', name: 'LONG_YEARS_AF13', width: '97%', tdAttrs: {width: 93}, value: 0, readOnly: true}
			]
		}, {
			xtype: 'container',
			padding: '5 7 0 7',
			layout: {
				type: 'uniTable',
				columns:4,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
			},
			defaults:{padding: '0 0 1 0'},
			items:[
			    { xtype: 'component',  html:'개정</br>규정에</br>따른</br>계산</br>방법', width: 40, tdAttrs: {width: 40}, rowspan: 9},
				{ xtype: 'component',  html:'퇴직</br>소득</br>과세</br>표준</br>계산', width: 40, tdAttrs: {width: 40}, rowspan: 6},
				{ xtype: 'component',  html:'계산내용', tdAttrs: {height: 30}},
				{ xtype: 'component',  html:'금액', tdAttrs: {height: 30} },
				{ xtype: 'component',  html:'&nbsp;&nbsp;(27)퇴직소득(17)', tdAttrs: {align : 'left', width: '30%'}},
				{ xtype: 'uniNumberfield', value: 0, name: 'S_TAX_TOTAL_I2', width: '99%', readOnly: true},
				{ xtype: 'component',  html:'&nbsp;&nbsp;(28)근속연수공제' , tdAttrs: {align : 'left'}},
                { xtype: 'uniNumberfield', value: 0, name: 'INCOME_DED_I', width: '99%',  readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(29)환산급여[(27-28)x12배/정산근속연수]', tdAttrs: {align : 'left'}},
                { xtype: 'uniNumberfield', value: 0, name: 'PAY_TOTAL_I_16', width: '99%' , readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(30)환산급여별공제' , tdAttrs: {align : 'left'}},
                { xtype: 'uniNumberfield', value: 0, name: 'PAY_TOTAL_DED_I_16', width: '99%' , readOnly: true},
				{ xtype: 'component',  html:'&nbsp;&nbsp;(31)퇴직소득과세표준(29-30)', tdAttrs: {align : 'left'}},
				{ xtype: 'uniNumberfield', value: 0, name: 'TAX_STD_I_16', width: '99%' , readOnly: true},
                { xtype: 'component',  html:'세액</br>계산</br>', width: 40, tdAttrs: {width: 40}, rowspan: 3},
                { xtype: 'component',  html:'계산내용', tdAttrs: {height: 30} },
                { xtype: 'component',  html:'금액', tdAttrs: {height: 30} },
				{ xtype: 'component',  html:'&nbsp;&nbsp;(32)환산산출세액(31x세율)', tdAttrs: {align : 'left'}},
				{ xtype: 'uniNumberfield', value: 0, name: 'CHANGE_COMP_TAX_I_16', width: '99%' , readOnly: true},
				{ xtype: 'component',  html:'&nbsp;&nbsp;(33)산출세액(32x정산근속연수/12배)', tdAttrs: {align : 'left'}},
                { xtype: 'uniNumberfield', value: 0, name: 'COMP_TAX_I_16', width: '99%' , readOnly: true}
			]
		}, {
			xtype: 'container',
			padding: '5 7 0 7',
			layout: {
				type: 'uniTable',
				columns:7,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
			},
			defaults:{padding: '0 0 1 0'},
			items:[
				{ xtype: 'component',  html:'종전</br>규정에</br>따른</br>계산</br>방법', width: 40, tdAttrs: {width: 40}, rowspan:12},
                { xtype: 'component',  html:'과세</br>표준</br>계산', width: 40, tdAttrs: {width: 40}, rowspan: 5},
                { xtype: 'component',  html:'계산내용', tdAttrs: {height: 30},colspan: 2},
                { xtype: 'component',  html:'중간지급&nbsp;등', tdAttrs: {height: 30} },
                { xtype: 'component',  html:'최&nbsp;종', tdAttrs: {height: 30} },
                { xtype: 'component',  html:'정&nbsp;산', tdAttrs: {height: 30} },
                { xtype: 'component',  html:'&nbsp;&nbsp;(34)퇴직소득(17)', tdAttrs: {align : 'left'},colspan:2},
                { xtype: 'uniNumberfield', value: 0, name: 'M_TAX_TOTAL_I2', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'R_TAX_TOTAL_I2', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'S_TAX_TOTAL_I3', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(35)퇴직소득정률공제', width: '99%' , tdAttrs: {align : 'left', width: 240},colspan: 2},
                { xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
                { xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
                { xtype: 'uniNumberfield', value: 0, name: 'SPEC_DED_I', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(36)근속연수공제', width: '99%' , tdAttrs: {align : 'left', width: 240},colspan:2},
                { xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
                { xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
                { xtype: 'uniNumberfield', value: 0, name: 'INCOME_DED_I2', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(37)퇴직소득과세표준(34-35-36)', width: '99%' , tdAttrs: {align : 'left', width: 240},colspan:2},
                { xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
                { xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
                { xtype: 'uniNumberfield', value: 0, name: 'TAX_STD_I', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'component',  html:'세액</br>계산</br>', width: 40, tdAttrs: {width: 40}, rowspan: 8},
                { xtype: 'component',  html:'계산내용', tdAttrs: {height: 30} ,colspan:2},
                { xtype: 'component',  html:'2012.12.31&nbsp;이전', tdAttrs: {height: 30} },
                { xtype: 'component',  html:'2013.1.1&nbsp;이후', tdAttrs: {height: 30} },
                { xtype: 'component',  html:'합&nbsp;계', tdAttrs: {height: 30} },
                { xtype: 'component',  html:'&nbsp;&nbsp;(38)과세표준안분(37x각근속연수/정산근속연수)', width: '99%' , tdAttrs: {align : 'left', width: 240},colspan:2},
                { xtype: 'uniNumberfield', value: 0, name: 'DIVI_TAX_STD_BE13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'DIVI_TAX_STD_AF13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'DIVI_TAX_STD', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(39)연평균과세표준(38/각근속연수)', width: '99%' , tdAttrs: {align : 'left', width: 240},colspan:2},
                { xtype: 'uniNumberfield', value: 0, name: 'AVG_TAX_STD_BE13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'AVG_TAX_STD_AF13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'AVG_TAX_STD', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(40)환산과세표준(39x5배)', tdAttrs: {align : 'left'},colspan: 2},
                { xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
                { xtype: 'uniNumberfield', value: 0, name: 'EX_TAX_STD_AF13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'EX_TAX_STD', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(41)환산산출세액(40x세율)', tdAttrs: {align : 'left'},colspan: 2},
                { xtype: 'component', baseCls: 'x-close-cell_dark', height: 22, margin: '0 1 3 1'},
                { xtype: 'uniNumberfield', value: 0, name: 'EX_COMP_TAX_AF13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'EX_COMP_TAX', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                
                { xtype: 'component',  html:'&nbsp;&nbsp;(42)연평균산출세액(12.12.31이전:(39x세율, 13.1.1이후:((41)/5배)', width: '99%' , tdAttrs: {align : 'left', width: 240},colspan: 2},
                { xtype: 'uniNumberfield', value: 0, name: 'AVR_COMP_TAX_BE13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'AVR_COMP_TAX_AF13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'AVR_COMP_TAX', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(43)산출세액(42x각 근속연수)', width: '99%' , tdAttrs: {align : 'left', width: 240},colspan: 2},
                { xtype: 'uniNumberfield', value: 0, name: 'COMP_TAX_BE13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'COMP_TAX_AF13', width: '99%' , tdAttrs: {width: 240}, readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'COMP_TAX', width: '99%' , tdAttrs: {width: 240}, readOnly: true}
                
			]
		},{
            xtype: 'container',
            padding: '5 7 0 7',
            layout: {
                type: 'uniTable',
                columns:3,
                tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
                tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
            },
            defaults:{padding: '0 0 1 0'},
            items:[
                { xtype: 'component',  html:'퇴직</br>소득</br>세액</br>계산', width: 40, tdAttrs: {width: 40}, rowspan: 4},
                { xtype: 'component',  html:'&nbsp;&nbsp;(44)퇴직일이 속하는 과세연도', tdAttrs: {align : 'left'}},
                { xtype: 'textfield', value: 0, name: 'CHANGE_TAX_YEAR_16', width: '99%' , tdAttrs: {width: 500}, fieldStyle:'text-align:center;',readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(45)퇴직소득세 산출세액 &nbsp;(33x퇴직연도별비율)+[(43x(100%-퇴직연도별비율)]', width: '99%' , tdAttrs: {align : 'left'}},
                { xtype: 'uniNumberfield', value: 0, name: 'EXEMPTION_COMP_TAX_I_16', width: '99%' , tdAttrs: {width: 500}, readOnly: true},
                { xtype: 'component',  html:'&nbsp;&nbsp;(46)기납부(또는 과세이연)세액', width: '99%' , tdAttrs: {align : 'left'}},
                { xtype: 'uniNumberfield', value: 0, name: 'LOCAL_END_TAX', width: '99%' , tdAttrs: {width: 500}, readOnly: true,hidden:true},
                { xtype: 'uniNumberfield', value: 0, name: 'PAY_END_TAX', width: '99%' , tdAttrs: {width: 500}},
                { xtype: 'component',  html:'&nbsp;&nbsp;(47)신고대상액(45-46)', width: '99%' , tdAttrs: {align : 'left'}},
                { xtype: 'uniNumberfield', value: 0, name: 'CHANGE_TARGET_TAX_I_16', width: '99%' , tdAttrs: {width: 500}, readOnly: true}
            ]
        }, {
			xtype: 'container',
			padding: '5 7 0 7',
			layout: {
				type: 'uniTable',
				columns:9,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
			},
			defaults:{padding: '0 0 1 0'},
			items:[
				{ xtype: 'component',  html:'이연</br>퇴직</br>소득</br>세액</br>계산', width: 40, tdAttrs: {width: 40}, rowspan: 3},
				{ xtype: 'component',  html:'(48)신고대상세액((47))', rowspan: 2,tdAttrs: {width: 200}},
				{ xtype: 'component',  html:'연금계좌 입금내역', colspan: 5},
				{ xtype: 'component',  html:'(50)퇴직급여((17))', rowspan: 2},
				{ xtype: 'component',  html:'(51)퇴직소득세</br>((48)*(49)/(50))', rowspan: 2},

				{ xtype: 'component',  html:'연금계좌취급자'},
				{ xtype: 'component',  html:'사업자등록번호'},
				{ xtype: 'component',  html:'계좌번호'},
				{ xtype: 'component',  html:'입금일'},
				{ xtype: 'component',  html:'(49)계좌입금금액'},

				{ xtype: 'uniNumberfield', value: 0, name: 'DEF_TAX_I2', readOnly: true, width: '99.6%'},
				{ xtype: 'uniNumberfield', value: 0, name: 'DEF_TAX_I', hidden: true, width: '99.6%'},

				{ xtype: 'uniTextfield', name: 'COMP_NAME', width: '99%' ,tdAttrs: {width: 200}},
				{ xtype: 'uniTextfield', name: 'COMP_NUM', width: '99%' , tdAttrs: {width: 200}},
				{ xtype: 'uniTextfield', name: 'BANK_ACCOUNT', width: '99%',readOnly: true, tdAttrs: {width: 200},
				listeners:{
                    blur: function(field, event, eOpts ){
                            if(field.lastValue != field.originalValue){
                                if(!Ext.isEmpty(field.lastValue)){
                                    var param = {
                                        "DECRYP_WORD" : field.lastValue
                                    };
                                    humanCommonService.encryptField(param, function(provider, response)  {
                                        if(!Ext.isEmpty(provider)){
                                            mainTable.setValue('BANK_ACCOUNT_EXPOS',provider);
                                        }else{
                                            mainTable.setValue('BANK_ACCOUNT',"");
                                            mainTable.setValue('BANK_ACCOUNT_EXPOS',"");
                                        }
                                        field.originalValue = field.lastValue; 
                                    });
                                }else{
                                    mainTable.setValue('BANK_ACCOUNT_EXPOS',"");
                                }
                            }
                        },
                    afterrender:function(field) {
                        field.getEl().on('dblclick', field.onDblclick);
                    }
                },
                     onDblclick:function(event, elm) {
                        var params = {'INCRYP_WORD':mainTable.getValue('BANK_ACCOUNT_EXPOS')};
                        Unilite.popupDecryptCom(params);
                     }
                },
				{ xtype: 'uniTextfield', name: 'BANK_ACCOUNT_EXPOS', hidden:true , width: '99%', tdAttrs: {width: 200}},
				{ xtype: 'uniDatefield', name: 'DEPOSIT_DATE' , width: '99%', tdAttrs: {width: 200}},
				{ xtype: 'uniNumberfield', value: 0, name: 'TRANS_RETR_PAY', width: '99%', tdAttrs: {width: 200}, minValue:0
//				listeners:{
//                    change:function(field, eOpts)   {
//                        UniAppManager.app.fnDeferTaxI()
//                    }
//                  }
                },
				{ xtype: 'uniNumberfield', value: 0, name: 'DEFER_TAX_TOTAL_I', width: '99%', tdAttrs: {width: 200}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'DEFER_TAX_I', width: '99%', tdAttrs: {width: 200}, readOnly: true}
			]
		}, {
			xtype: 'container',
			padding: '5 7 7 7',
			layout: {
				type: 'uniTable',
				columns:6,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
			},
			defaults:{padding: '0 0 1 0'},
			items:[
				{ xtype: 'component',  html:'납</br>부</br>명</br>세', width: 40, tdAttrs: {width: 40}, rowspan: 6},
				{ xtype: 'component',  html:'구분', tdAttrs: {height: 30}},
				{ xtype: 'component',  html:'소득세', width: '99%' , tdAttrs: {width: 300}},
				{ xtype: 'component',  html:'지방소득세', width: '99%' , tdAttrs: {width: 300}},
				{ xtype: 'component',  html:'농어촌특별세', width: '99%' , tdAttrs: {width: 300}},
				{ xtype: 'component',  html:'계', width: '99%' , tdAttrs: {width: 300}},

				{ xtype: 'component',  html:'&nbsp;&nbsp;(53)신고대상세액((47))', tdAttrs: {align : 'left'}},
				{ xtype: 'uniNumberfield', value: 0, name: 'IN_TAX_I1', width: '99%' , tdAttrs: {width: 300}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'LOCAL_TAX_I1', width: '99%' , tdAttrs: {width: 300}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'SP_TAX_I1', width: '99%' , tdAttrs: {width: 300}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'SUM_TAX_I1', width: '99%' , tdAttrs: {width: 300}, readOnly: true},

				{ xtype: 'component',  html:'&nbsp;&nbsp;(54)이연퇴직소득세((51))', tdAttrs: {align : 'left'}},
				{ xtype: 'uniNumberfield', value: 0, name: 'IN_TAX_I2', width: '99%' , tdAttrs: {width: 300}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'LOCAL_TAX_I2', width: '99%' , tdAttrs: {width: 300}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'DEFER_SP_TAX_I', width: '99%' , tdAttrs: {width: 300}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'SUM_TAX_I2', width: '99%' , tdAttrs: {width: 300}, readOnly: true},

				{ xtype: 'component',  html:'&nbsp;&nbsp;(55)차감원천징수세액((53)-(54))', tdAttrs: {align : 'left'}},
				{ xtype: 'uniNumberfield', value: 0, name: 'BAL_IN_TAX_I', width: '99%' , tdAttrs: {width: 300}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'BAL_LOCAL_TAX_I', width: '99%' , tdAttrs: {width: 300}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'BAL_SP_TAX_I', width: '99%' , tdAttrs: {width: 300}, readOnly: true},
				{ xtype: 'uniNumberfield', value: 0, name: 'SUM_TAX_I3', width: '99%' , tdAttrs: {width: 300}, readOnly: true}
			]
		}],
		api: {
	 		load: 'hrt507ukrService.selectMaster',
	 		submit:'hrt507ukrService.syncMaster'
		},
		listeners:{
			validitychange : function( form, valid, eOpts ) {
				if(valid && form.isDirty() && !mainTable.uniOpt.inLoading)	{
					//UniAppManager.setToolbarButtons('save',true);
				}
			},
			uniOnChange:function( field, value, oldValue)	{
				if(field.isDirty() && !mainTable.uniOpt.inLoading)	{
					UniAppManager.setToolbarButtons('save',true);
				}else if(!mainTable.getForm().isDirty())	{
					UniAppManager.setToolbarButtons('save',false);
				}
			}
		}
    });

    Unilite.Main({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		panelResult, mainTable
         	]
      	},
      	panelSearch
      	],
		id  : 'hrt507ukrApp',
		fnInitBinding : function(param) {
			UniAppManager.setToolbarButtons('reset',false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PERSON_NUMB');

			if(param && param.PERSON_NUMB)	{
				panelSearch.setValue('PERSON_NUMB',param.PERSON_NUMB);
				panelResult.setValue('PERSON_NUMB',param.PERSON_NUMB);

				if( param.NAME )	{
					panelSearch.setValue('NAME',param.NAME);
					panelResult.setValue('NAME',param.NAME);
				}
				if(param.RETR_TYPE)	{
					panelSearch.setValue('RETR_TYPE',param.RETR_TYPE);
					panelResult.setValue('RETR_TYPE',param.RETR_TYPE)
				}
				if(param.RETR_DATE)	{
					panelSearch.setValue('RETR_DATE',param.RETR_DATE);
					panelResult.setValue('RETR_DATE',param.RETR_DATE)
				}
				if(param.SUPP_DATE) {
                    panelSearch.setValue('SUPP_DATE',param.SUPP_DATE);
                    panelResult.setValue('SUPP_DATE',param.SUPP_DATE)
                }
				panelSearch.setReadOnly(true);
				panelResult.setReadOnly(true);
				this.onQueryButtonDown();
			}
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			var param= panelSearch.getValues();
			//mainTable.mask('로딩중...', 'loading');
			mainTable.uniOpt.inLoading = true;
			mainTable.getForm().load({
				params: param,
				success:function(form, response)	{
					var rsult = response.result.data;
//					alert(444444);
					if(rsult.RETR_PENSION_KIND == 'DB')	{
//					if(result.RETR_PENSION_KIND == 'DB')	{
						mainTable.getField('RETR_ANN_JOIN_DATE').setReadOnly(false);
						mainTable.getField('COMP_NAME').setReadOnly(false);
						mainTable.getField('COMP_NUM').setReadOnly(false);
						mainTable.getField('BANK_ACCOUNT').setReadOnly(false);
						mainTable.getField('DEPOSIT_DATE').setReadOnly(false);
						mainTable.getField('TRANS_RETR_PAY').setReadOnly(false);
						mainTable.getField('DEFER_TAX_I').setReadOnly(false);

					} else {
						mainTable.getField('RETR_ANN_JOIN_DATE').setReadOnly(true);
						mainTable.getField('COMP_NAME').setReadOnly(true);
						mainTable.getField('COMP_NUM').setReadOnly(true);
						mainTable.getField('BANK_ACCOUNT').setReadOnly(true);
						mainTable.getField('DEPOSIT_DATE').setReadOnly(true);
						mainTable.getField('TRANS_RETR_PAY').setReadOnly(true);
						mainTable.getField('DEFER_TAX_I').setReadOnly(true);
					}
					UniAppManager.app.fnSuppTotI();
					mainTable.uniOpt.inLoading = false;
					//mainTable.getEl().unmask();
				},
				failure: function(form, action) {
//					mainTable.getEl().unmask();
					mainTable.uniOpt.inLoading = false;
					mainTable.getField('RETR_ANN_JOIN_DATE').setReadOnly(true);
					mainTable.getField('COMP_NAME').setReadOnly(true);
					mainTable.getField('COMP_NUM').setReadOnly(true);
//					mainTable.getField('BANK_ACCOUNT_EXPOS').setReadOnly(true);
					mainTable.getField('DEPOSIT_DATE').setReadOnly(true);
					mainTable.getField('TRANS_RETR_PAY').setReadOnly(true);
					mainTable.getField('DEFER_TAX_I').setReadOnly(true);
				}
			})

		},
		onSaveDataButtonDown:function()	{
			if(mainTable.isValid())	{
				if(mainTable.getValue("RETR_PENSION_KIND") == "DB")	{
					if(Ext.isEmpty(mainTable.getValue("RETR_ANN_JOIN_DATE")))	{
						alert("확정급여형 퇴직연금제도 가입일은 필수 입력입니다.");
						mainTable.getField("RETR_ANN_JOIN_DATE").focus();
						return;
					}
					if(Ext.isEmpty(mainTable.getValue("COMP_NAME")))	{
						alert("연금계좌 취급자는 필수 입력입니다.");
						mainTable.getField("COMP_NAME").focus();
						return;
					}
					if(Ext.isEmpty(mainTable.getValue("COMP_NUM")))	{
						alert("사업자등록번호는 필수 입력입니다.");
						mainTable.getField("COMP_NUM").focus();
						return;
					}
					if(Ext.isEmpty(mainTable.getValue("BANK_ACCOUNT")))	{
						alert("계좌번호는 필수 입력입니다.");
						mainTable.getField("BANK_ACCOUNT").focus();
						return;
					}
					if(Ext.isEmpty(mainTable.getValue("DEPOSIT_DATE")))	{
						alert("입금일은 필수 입력입니다.");
						mainTable.getField("DEPOSIT_DATE").focus();
						return;
					}
				}
				mainTable.submit({
					 success : function(form, action) {
				 		Ext.getBody().unmask();
	 					mainTable.getForm().wasDirty = false;
						mainTable.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
	            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
	            		
						mainTable.getForm().load({
							params: panelSearch.getValues()
						});
					 }
				});
			} else {
				mainTable.getInvalidMessage();
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		fnSuppTotI:function()	{
			var dMOutIncomeI, dROutIncomeI;

			//(15)퇴직급여			
			var dMAnnuTotalI = !Ext.isEmpty(mainTable.getValue("M_ANNU_TOTAL_I")) ?  mainTable.getValue("M_ANNU_TOTAL_I") : 0;			
			var dRAnnuTotalI = !Ext.isEmpty(mainTable.getValue("R_ANNU_TOTAL_I")) ?  mainTable.getValue("R_ANNU_TOTAL_I") : 0;        
            mainTable.setValue("S_ANNU_TOTAL_I" , dMAnnuTotalI + dRAnnuTotalI);
            
			//(16)비과세 퇴직급여
            var dMOutIncomeI =  !Ext.isEmpty(mainTable.getValue("M_OUT_INCOME_I")) ?  mainTable.getValue("M_OUT_INCOME_I") : 0;  
            var dROutIncomeI =  !Ext.isEmpty(mainTable.getValue("R_OUT_INCOME_I")) ?  mainTable.getValue("R_OUT_INCOME_I") : 0;       
            mainTable.setValue("S_OUT_INCOME_I", dMOutIncomeI + dROutIncomeI);

            //((17)과세대상 퇴직급여((15)-(16))
            mainTable.setValue("M_TAX_TOTAL_I", dMAnnuTotalI - dMOutIncomeI);
            mainTable.setValue("R_TAX_TOTAL_I", dRAnnuTotalI - dROutIncomeI);             
            mainTable.setValue("S_TAX_TOTAL_I", dMAnnuTotalI + dRAnnuTotalI - dMOutIncomeI - dROutIncomeI);
            
            //(27)퇴직소득(17)           
            mainTable.setValue("S_TAX_TOTAL_I2" , dMAnnuTotalI + dRAnnuTotalI - dMOutIncomeI - dROutIncomeI);
            
            //(34)퇴직소득(17)
            mainTable.setValue("M_TAX_TOTAL_I2", mainTable.getValue("M_TAX_TOTAL_I"))
            mainTable.setValue("R_TAX_TOTAL_I2", mainTable.getValue("R_TAX_TOTAL_I"))
            mainTable.setValue("S_TAX_TOTAL_I3", mainTable.getValue("M_TAX_TOTAL_I") + mainTable.getValue("R_TAX_TOTAL_I"))

            //(50)퇴직급여(17)
			mainTable.setValue("DEFER_TAX_TOTAL_I", (dMAnnuTotalI + dRAnnuTotalI - dMOutIncomeI - dROutIncomeI));
            
            var params = getParams();	
			
            hrt507ukrService.retireProcStChangedSuppTotal(params, function(responseText, response){
                if (responseText) {
                    UniAppManager.app.fnReDisplayData(responseText);     
                }
                
                UniAppManager.app.fnDeferTaxI();
            })	
			
		},
	
		fnReDisplayData: function(data) {
			
           //세액내역-------------------------------------------------------------------------------------
            mainTable.setValue('SUPP_TOTAL_I', data.SUPP_TOTAL_I);   //(숨김)퇴직급여액
            mainTable.setValue('SPEC_DED_I', data.SPEC_DED_I);       // 퇴직소득정률공제
            mainTable.setValue('INCOME_DED_I', data.INCOME_DED_I);   // 퇴근속연수공제            
            mainTable.setValue('EARN_INCOME_I', data.EARN_INCOME_I); // (숨김)퇴직소득공제
            
            mainTable.setValue('DIVI_TAX_STD_BE13', data.DIVI_TAX_STD_BE13); // (38)과세표준안분_이전
            mainTable.setValue('DIVI_TAX_STD_AF13', data.DIVI_TAX_STD_AF13); // (38)과세표준안분_이후
            mainTable.setValue('TAX_STD_I', data.TAX_STD_I);                 // (38)과세표준안분_정산(합산)
            
            mainTable.setValue('AVG_TAX_STD_BE13', data.AVG_TAX_STD_BE13);  // (39)연평균과세표준_이전
            mainTable.setValue('AVG_TAX_STD_AF13', data.AVG_TAX_STD_AF13);  // (39)연평균과세표준_이후
            mainTable.setValue('AVG_TAX_STD_I', data.TAX_STD_I);            // (39)연평균과세표준-정산(합산)
            
            mainTable.setValue('EX_TAX_STD_AF13', data.EX_TAX_STD_AF13);    // (40)환산과세표준_이후
            mainTable.setValue('EX_TAX_STD_AF13', data.EX_TAX_STD_AF13);    // (40)환산과세표준_정산(합산)
            
            mainTable.setValue('EX_COMP_TAX_AF13', data.EX_COMP_TAX_AF13);  // (41)환산산출세액_이후
            mainTable.setValue('EX_COMP_TAX', data.EX_COMP_TAX);            // (41)환산산출세액_정산(합산)            
            
            mainTable.setValue('AVR_COMP_TAX_BE13', data.AVR_COMP_TAX_BE13); // (42)연평균산출세액_이전
            mainTable.setValue('AVR_COMP_TAX_AF13', data.AVR_COMP_TAX_AF13); // (42)연평균산출세액_이후
            mainTable.setValue('AVR_COMP_TAX_I', data.AVR_COMP_TAX_I);       // (42)연평균산출세액_정산(합산)
            
            mainTable.setValue('COMP_TAX_BE13', data.COMP_TAX_BE13); // (43)산출세액_이전
            mainTable.setValue('COMP_TAX_AF13', data.COMP_TAX_AF13); // (43)산출세액_이후
            mainTable.setValue('COMP_TAX_I', data.COMP_TAX_I);       // (43)산출세액_정산(합산)            
            
            mainTable.setValue('DEF_TAX_I', data.DEF_TAX_I);        // 결정세액
            
            //'2016.01.01 이후--------------------------------------------------------------------------------------
            mainTable.setValue('SUPP_TOTAL_I2', data.SUPP_TOTAL_I);                         // (27)정산퇴직소득
            mainTable.setValue('INCOME_DED_I2', data.INCOME_DED_I);                         // (28)근속연수공제
            mainTable.setValue('PAY_TOTAL_I_16', data.PAY_TOTAL_I_16);                      // (29)환산급여
            mainTable.setValue('PAY_TOTAL_DED_I_16', data.PAY_TOTAL_DED_I_16);              // (30)환산급여별공제
            mainTable.setValue('TAX_STD_I_16', data.TAX_STD_I_16);                          // (31)퇴직소득과세표준
            mainTable.setValue('CHANGE_COMP_TAX_I_16', data.CHANGE_COMP_TAX_I_16);          // (32)환산산출세액
            mainTable.setValue('COMP_TAX_I_16', data.COMP_TAX_I_16);                        // (33)산출세액 
            mainTable.setValue('EXEMPTION_COMP_TAX_I_16', data.EXEMPTION_COMP_TAX_I_16);    // (45)퇴직소득세산출세액
            mainTable.setValue('CHANGE_TARGET_TAX_I_16', data.CHANGE_TARGET_TAX_I_16);      // (47)신고대상액
            
            //'공제내역-----------------------------------------------------------------------------------------------
            //detailForm.getForm().setValues(data);            
            mainTable.setValue('IN_TAX_I', data.IN_TAX_I);                  //소득세
            mainTable.setValue('LOCAL_TAX_I', data.LOCAL_TAX_I);            //지방소득세 
            mainTable.setValue('DED_TOTAL_I', data.DED_TOTAL_I);            //공제총액 
            
            mainTable.setValue('IN_TAX_I1', data.DEF_IN_TAX_I);          //신고대상세액(소득세) 
            mainTable.setValue('LOCAL_TAX_I1', data.DEF_LOCAL_TAX_I);    //신고대상세액(지방소득세) 
            
            mainTable.setValue('REAL_AMOUNT_I', data.REAL_AMOUNT_I);        //실지급액 
            
            mainTable.setValue('DEF_TAX_I2', data.DEF_TAX_I);                //이연퇴직소득세  
        },
		//이연퇴직소득계산,납부명세
		fnDeferTaxI:function()	{
			var dDefTaxI2		= mainTable.getValue("DEF_TAX_I2");
			//var dDefTaxI2		= mainTable.getValue("DEFER_TAX_I");
			var dTransRetrPay	= mainTable.getValue("TRANS_RETR_PAY");
			var dRetrTaxI		= !Ext.isEmpty(mainTable.getValue("DEFER_TAX_TOTAL_I")) ?  mainTable.getValue("DEFER_TAX_TOTAL_I"):0;
           
			var dDeferTaxI = 0 ;
			if(dRetrTaxI != 0 ) {
				dDeferTaxI =UniHuman.fix(((dDefTaxI2 * dTransRetrPay) / dRetrTaxI) / 10) * 10;
			}
			
			mainTable.setValue("DEFER_TAX_I", (dDefTaxI2 * dTransRetrPay) / dRetrTaxI);
			
			//이연퇴직소득세 - 소득세
			mainTable.setValue("IN_TAX_I2", (dDefTaxI2 * dTransRetrPay) / dRetrTaxI);

//			var dlocalTax = UniHuman.fix(Math.floor(dDeferTaxI / 10));

			mainTable.setValue("LOCAL_TAX_I2", UniHuman.fix(((dDefTaxI2 * dTransRetrPay) / dRetrTaxI) / 10));

			UniAppManager.app.fnInLocalTaxI();
		},
		//용  도 : 납부명세
		fnInLocalTaxI:function()	{
			var dInTaxI1, dLocalTaxI1, dSpTaxI1, dSumTaxI1
			var dInTaxI2, dLocalTaxI2, dSpTaxI2, dSumTaxI2
			var dInTaxI3, dLocalTaxI3, dSpTaxI3, dSumTaxI3

			dInTaxI1			= mainTable.getValue("IN_TAX_I1");
			dLocalTaxI1			= mainTable.getValue("LOCAL_TAX_I1");
			dSpTaxI1			= mainTable.getValue("SP_TAX_I1");

			dSumTaxI1			= dInTaxI1 + dLocalTaxI1 + dSpTaxI1;

			mainTable.setValue("SUM_TAX_I1", dSumTaxI1);

			dInTaxI2			= mainTable.getValue("IN_TAX_I2");
			dLocalTaxI2			= mainTable.getValue("LOCAL_TAX_I2");
			dSpTaxI2			= mainTable.getValue("DEFER_SP_TAX_I");

			dSumTaxI2			= dInTaxI2 + dLocalTaxI2 + dSpTaxI2;

			mainTable.setValue("SUM_TAX_I2", dSumTaxI2);
			

			dInTaxI3			= UniHuman.fix((dInTaxI1    - dInTaxI2   ) / 10) * 10
			dLocalTaxI3			= UniHuman.fix((dLocalTaxI1 - dLocalTaxI2) / 10) * 10
			dSpTaxI3			= UniHuman.fix((dSpTaxI1    - dSpTaxI2   ) / 10) * 10

			dSumTaxI3			= dInTaxI3 + dLocalTaxI3 + dSpTaxI3
			
			mainTable.setValue("BAL_IN_TAX_I", dInTaxI3);
			mainTable.setValue("BAL_LOCAL_TAX_I", dLocalTaxI3);
			mainTable.setValue("BAL_SP_TAX_I", dSpTaxI3);
			mainTable.setValue("SUM_TAX_I3", dSumTaxI3);
			
			//mainTable.setValue("IN_TAX_I", mainTable.getValue("BAL_IN_TAX_I"));		    //소득세
			//mainTable.setValue("LOCAL_TAX_I", mainTable.getValue("BAL_LOCAL_TAX_I"));	//지방소득
			//mainTable.setValue("SP_TAX_I", mainTable.getValue("BAL_SP_TAX_I"));		    //농어촌	

			//공제총액
			mainTable.setValue("DED_TOTAL_I",  mainTable.getValue("IN_TAX_I") + mainTable.getValue("LOCAL_TAX_I") + mainTable.getValue("SP_TAX_I") + mainTable.getValue("DED_IN_TAX_ADD_I") + mainTable.getValue("DED_IN_LOCAL_ADD_I") + mainTable.getValue("DED_ETC_I"));

			//실지급액
			mainTable.setValue("REAL_AMOUNT_I", mainTable.getValue("RETR_SUM_I") - mainTable.getValue("DED_TOTAL_I"));
	    },
	    
	    fnDateChanged: function()	{

	    }

	});
	function getParams() {
        var params = Ext.getCmp('panelResultForm').getValues(); 
        
        params.TAX_CALCU = 'Y'
        params.R_ANNU_TOTAL_I = mainTable.getValue('R_ANNU_TOTAL_I');   // 최종분-퇴직급여
        params.OUT_INCOME_I = mainTable.getValue('R_OUT_INCOME_I');       // 최종분-퇴직급여(비과세)
        params.M_ANNU_TOTAL_I = mainTable.getValue('M_ANNU_TOTAL_I');   // 중도정산-퇴직급여
        params.M_OUT_INCOME_I = mainTable.getValue('M_OUT_INCOME_I');   // 중도정산-퇴직급여 (비과세)
        params.PAY_END_TAX = mainTable.getValue('PAY_END_TAX');      // 기납부세액
       
        if (Ext.isEmpty(mainTable.getValue('DED_IN_TAX_ADD_I'))) {
            var ded_in_tax_add_i = 0;
            params.DED_IN_TAX_ADD_I = ded_in_tax_add_i;                 // 소득세환급액
        } else {
            params.DED_IN_TAX_ADD_I = mainTable.getValue('DED_IN_TAX_ADD_I');
        }
        
        if (Ext.isEmpty(mainTable.getValue('DED_IN_LOCAL_ADD_I'))) {
            var ded_in_local_add_i = 0;
        params.DED_IN_LOCAL_ADD_I = ded_in_local_add_i;                 // 주민세환급액
        } else {
            params.DED_IN_LOCAL_ADD_I = mainTable.getValue('DED_IN_LOCAL_ADD_I');
        }
        
        if (Ext.isEmpty(mainTable.getValue('DED_ETC_I'))) {
            var ded_etc_i = 0;
            params.DED_ETC_I = ded_etc_i;                               // 기타공제1
        } else {
            params.DED_ETC_I = mainTable.getValue('DED_ETC_I');
        }
        params.DED_ETC_I2 = 0; // 기타공제2
        params.DED_ETC_I3 = 0; // 중도퇴직정산소득세
        params.DED_ETC_I4 = 0; // 중도퇴직정산지방소득세
        params.DED_ETC_I5 = 0; // 건강보험료정산
        params.DED_ETC_I6 = 0; // 장기요양보험료정산
        
        params.S_LONG_YEARS = mainTable.getValue('S_LONG_YEARS'); // 정산(합산)근속연수
        params.LONG_YEARS_BE13 = mainTable.getValue('LONG_YEARS_BE13'); // 2013이전근속연수
        params.LONG_YEARS_AF13 = mainTable.getValue('LONG_YEARS_AF13'); // 2013이후근속연수 
        params.R_CALCU_END_DATE = UniDate.getDateStr(mainTable.getValue('R_CALCU_END_DATE')); // 최종분-기산일
        params.LONG_YEARS = mainTable.getValue('LONG_YEARS'); // 근속연수        
        
        params.EXEP_MONTHS_BE13 = mainTable.getValue('EXEP_MONTHS_BE13'); // 2013이전 제외 월
        params.R_EXEP_DAY_BE13 = mainTable.getValue('R_EXEP_DAY_BE13'); // 2013이전 제외 일
        params.EXEP_MONTHS_AF13 = mainTable.getValue('EXEP_MONTHS_AF13'); // 2013이후 제외 월
        params.R_EXEP_DAY_AF13 = mainTable.getValue('R_EXEP_DAY_AF13'); // 2013이후 제외 일
//
//        params.DUTY_YYYY = mainTable.getValue('DUTY_YYYY'); // 근속년
//        params.LONG_MONTH = mainTable.getValue('LONG_MONTH'); // 근속월
//        params.LONG_DAY = mainTable.getValue('LONG_DAY'); // 근속일
//        params.LONG_TOT_DAY = mainTable.getValue('LONG_TOT_DAY1'); // 누진근속일수
//        params.LONG_TOT_MONTH = mainTable.getValue('LONG_TOT_MONTH'); // 누진근속월수
//        //params.RETR_OT_KINE = panelResult.getValue('OT_KIND').OT_KIND; // 퇴직분류
//        params.PAY_TOTAL_I = mainTable.getValue('PAY_TOTAL_I'); // 급여총액
//        params.BONUS_TOTAL_I = mainTable.getValue('BONUS_TOTAL_I'); // 상여총액
//        params.INCOME_DED_I = mainTable.getValue('INCOME_DED_I'); // 근속년수공제
//        params.KEY_VALUE = UniDate.getDateStr(new Date());
//
//        params.LOCAL_END_TAX = mainTable.getValue('LOCAL_END_TAX');
//        params.PAY_END_TAX_16 = mainTable.getValue('PAY_END_TAX_16');
//        
//        params.DEF_TAX_I = mainTable.getValue('DEF_TAX_I'); // 결정세액
//
//        params.DAVG_ETC3 = Unilite.nvl(directMasterStore2.sum("GIVE_I"), 0); // 기타수당 총액
//        
//        params.AVG_BONUS_I_3 = mainTable.getValue('AVG_BONUS_I_3')
//        params.AVG_YEAR_I_3 = mainTable.getValue('AVG_YEAR_I_3')
//        params.DELETE_FLAG = '';
//
//        params.SUPP_TOTAL_I = mainTable.getValue('SUPP_TOTAL_I1'); //과세대상 퇴직급여, 정산퇴직 소득

        return params;
    }    
        
	Unilite.createValidator('validator01', {
		forms :{'formA:':mainTable},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue)	{
				return true;
			}
			var rv = true;
			switch(fieldName)	{
				case 'M_COMPANY_NUM':		//중간지급-사업자등록번호
					if(Unilite.validate('bizno',newValue) !== true)	{
				 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
				 			rv = false;
				 			return rv;
				 		}
				 	}
				 	if(newValue.length == 10)	{
				 		record.set('M_COMPANY_NUM', newValue.substring(0,3)+'-'+newValue.substring(3,6)+'-'+newValue.substring(6,10));
				 	}
				break;
				case 'M_ANNU_TOTAL_I' :		//중간지급-퇴직급여
					if(Ext.isEmpty(newValue))	{
						rv=false;
						return rv;
					}
					UniAppManager.app.fnSuppTotI();
				break;
				case 'M_OUT_INCOME_I' :		//중간지급-비과세퇴직급여
					if(Ext.isEmpty(newValue))	{
						rv=false;
						return rv;
					}
					UniAppManager.app.fnSuppTotI();
				break;
				case 'M_CALCU_END_DATE' :	//근속연수-기산일-중간
					if(UniDate.diff(newValue, record.get('M_RETR_DATE')) > 0)	{
						rv="기산일은 퇴사일보다 이전 일자를 입력하십시오.";
						return rv;
					}
					UniAppManager.app.fnDateChanged();
				break;
				case 'M_RETR_DATE' :		//근속연수-퇴사일-중간
					if(UniDate.diff(record.get('M_RETR_DATE'),newValue) > 0)	{
						rv="퇴사일은 기산일보다 이후 일자를 입력하십시오.";
						return rv;
					}
					UniAppManager.app.fnDateChanged();
				break;
				case 'R_CALCU_END_DATE' :	//근속연수-기산일-최종
					if(UniDate.diff(newValue, record.get('R_RETR_DATE')) > 0)	{
						rv="기산일은 퇴사일보다 이전 일자를 입력하십시오.";
						return rv;
					}
					UniAppManager.app.fnDateChanged();
				break;
				case 'M_EXEP_MONTHS_BE13' :	//근속연수-제외월수-중간(2013이전)
					UniAppManager.app.fnDateChanged();
				break;
				case 'M_EXEP_MONTHS_AF13' :	//근속연수-제외월수-중간(2013이후)
					UniAppManager.app.fnDateChanged();
				break;
				case 'M_ADD_MONTHS_BE13' :	//근속연수-가산월수-중간(2013이전)
					UniAppManager.app.fnDateChanged();
				break;
				case 'M_ADD_MONTHS_AF13' :	//근속연수-가산월수-중간(2013이후)
					UniAppManager.app.fnDateChanged();
				break;
				case 'R_EXEP_MONTHS_BE13' :	//근속연수-제외월수-최종(2013이전)
					UniAppManager.app.fnDateChanged();
				break;
				case 'R_EXEP_MONTHS_AF13' :	//근속연수-제외월수-최종(2013이후)
					UniAppManager.app.fnDateChanged();
				break;
				case 'R_ADD_MONTHS_BE13' :	//근속연수-가산월수-최종(2013이전)
					UniAppManager.app.fnDateChanged();
				break;
				case 'R_ADD_MONTHS_AF13' :	//근속연수-가산월수-최종(2013이후)
					UniAppManager.app.fnDateChanged();
				break;
				case 'PAY_END_TAX' :		//기납부세액
					UniAppManager.app.fnSuppTotI();
				break;
				case 'COMP_NUM':			//사업자등록번호
					if(Unilite.validate('bizno',newValue) !== true)	{
				 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
				 			rv = false;
				 			return rv;
				 		}
				 	}
				 	if(newValue.length == 10)	{
				 		record.set('COMP_NUM', newValue.substring(0,3)+'-'+newValue.substring(3,6)+'-'+newValue.substring(6,10));
				 	}
				break;
				case 'TRANS_RETR_PAY' :		//계좌입금금액
//					if(newValue == '')	{
//						rv=false;
//			 			return rv;
//					}
					UniAppManager.app.fnDeferTaxI();
					
				break;
				
				case 'DEFER_TAX_I' :		//(51)퇴직소득세				
					UniAppManager.app.fnDeferTaxI();
				break;
				
				default:
					break;
			}
			return rv;

		}
	});
};


</script>
