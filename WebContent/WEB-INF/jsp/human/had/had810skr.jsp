<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had810skr"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A097" /> <!-- 정산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Had810skrModel1', {
		fields: [ 
			{name:'TITLE',					text:'내역',				type:'string'},
			{name:'ETC_INCOME_I',			text:'기타소득(인정상여)',	type:'uniPrice'},
			{name:'OUTSIDE_INCOME_I',		text:'국외비과세소득',		type:'uniPrice'},
			{name:'EDUC_SUPP_I',			text:'교육비지원',			type:'uniPrice'},
			{name:'MED_SUPP_I',				text:'의료비지원',			type:'uniPrice'}
		]	
	});
	
	Unilite.defineModel('Had810skrModel2', {
		fields: [ 
			{name:'NONTAX_CODE',			text:'비과세코드',			type:'string'},
			{name:'NONTAX_CODE_NAME',		text:'비과세항목명',		type:'string'},
			{name:'NON_TAX_EMPTION_I',		text:'주(현)',			type:'uniPrice'},
			{name:'P1_NON_TAX_EMPTION_I',	text:'종(전)1',			type:'uniPrice'},
			{name:'P2_NON_TAX_EMPTION_I',	text:'종(전)2',			type:'uniPrice'}
		]	
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('had810skrMasterStore1',{
			model: 'Had810skrModel1',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'had810skrService.gridSelectList1'   
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});	
	
	var directMasterStore2 = Unilite.createStore('had810skrMasterStore2',{
			model: 'Had810skrModel2',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'had810skrService.gridSelectList2'                	
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});

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
			items: [{
	    		fieldLabel: '정산년도',
    			fieldStyle: "text-align:center;",
    			name:'YEAR_YYYY',
    			xtype: 'uniYearField',
    			allowBlank:false,
    			value:UniHuman.getTaxReturnYear(),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('YEAR_YYYY', newValue);
					}
				}
    		},			
	     	Unilite.popup('Employee',{ 				
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
			}),{
    			fieldLabel: '외국인단일세율',
    			name:'PLAN_SAVE_YN', 
    			inputValue :'Y',
    			xtype:'checkbox',
    			readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PLAN_SAVE_YN', newValue);
					}
				}
    		}]
		}]
	});		// end of var panelSearch = Unilite.createSearchForm('searchForm',{
	
	 var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{
    		fieldLabel: '정산년도',
			fieldStyle: "text-align:center;",
			name:'YEAR_YYYY',
			xtype: 'uniYearField',
			allowBlank:false,
			value:UniHuman.getTaxReturnYear(),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('YEAR_YYYY', newValue);
				}
			}
		},			
     	Unilite.popup('Employee',{ 				
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
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),{
			fieldLabel: '외국인단일세율',
			name:'PLAN_SAVE_YN', 
			inputValue :'Y',
			labelWidth: 130,
			xtype:'checkbox',
			readOnly: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PLAN_SAVE_YN', newValue);
				}
			}
		}]
    });
    
    <%@include file="./had810skr_2018.jsp" %>
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('had810skrGrid1', {
    	// for tab    	
//        layout : 'fit',
        region:'center',
        title: '기타소득내역',
        height: 150,
        width: 735,
        sortableColumns: false,
        uniOpt:{
         	expandLastColumn: false,		//내용검색 버튼 사용 여부		
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			excel: {
				useExcel: false,
				exportGroup : false
			}
        },
    	store: directMasterStore1,
        columns:  [  
        	{dataIndex: 'TITLE',					width: 150},
        	{dataIndex: 'ETC_INCOME_I',				width: 150, flex:1},
        	{dataIndex: 'OUTSIDE_INCOME_I',			width: 100, flex:1},
        	{dataIndex: 'EDUC_SUPP_I',				width: 100, flex:1},
        	{dataIndex: 'MED_SUPP_I',				width: 100, flex:1}
        ]  
    });	
    
    var masterGrid2 = Unilite.createGrid('had810skrGrid2', {
    	// for tab    	
//        layout : 'fit',
        region:'center',
        title: '비과세',
        height: 150,
        width: 493,
        sortableColumns: false,
        uniOpt:{
         	expandLastColumn: false,		//내용검색 버튼 사용 여부		
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			excel: {
				useExcel: false,
				exportGroup : false
			}
        },
    	store: directMasterStore2,
        columns:  [
//        	{dataIndex: 'NONTAX_CODE',				width: 150},
        	{dataIndex: 'NONTAX_CODE_NAME',			width: 150},
        	{dataIndex: 'NON_TAX_EMPTION_I',		width: 100, flex:1},
        	{dataIndex: 'P1_NON_TAX_EMPTION_I',		width: 100, flex:1},
        	{dataIndex: 'P2_NON_TAX_EMPTION_I',		width: 100, flex:1}
        ]  
    });
	
    var table1 = Unilite.createForm('table1',{
    	padding:'0 0 0 0',
//	    title:'&nbsp;',
		//border: 0,
		disabled: false,
		height: 200,
		region: 'right',
		layout: {
			type: 'uniTable',
			columns: 11,
			tableAttrs: {style: 'border : 0px solid #ced9e7;'},
			tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center', width: 123}
		},
		defaults: {readOnly: true},
		items: [
			{ xtype: 'component',  html:'소득내역&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #B4B7C7; ', align : 'right', width: 123, height: 28 } 	},
			{ xtype: 'component',  html:'급여총액'	, tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	},
			{ xtype: 'component',  html:'상여총액', tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	 	},
			{ xtype: 'component',  html:'인정상여', tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	 	},
			{ xtype: 'component',  html:'주식매수선택권', tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	},
			{ xtype: 'component',  html:'우리사주조합', tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	 },
			{ xtype: 'component',  html:'계', tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	 		},
			{ xtype: 'component',  html:'소득세', tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	 	},
			{ xtype: 'component',  html:'주민세', tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	 	},
			{ xtype: 'component',  html:'농어촌특별세', tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	 },
			{ xtype: 'component',  html:'계', tdAttrs: {style: 'border : 0px solid #B4B7C7; background-color : #B2CCFF;', width: 123} 	 		},
			
			{ xtype: 'component',  html:'주(현)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 123 }},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_PAY_TOT_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_BONUS_TOTAL_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_ADD_BONUS_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_STOCK_PROFIT_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_OWNER_STOCK_DRAW_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_PAY_HAM'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_IN_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_LOCAL_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_SP_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NOW_LOCAL_HAM'},
			
			{ xtype: 'component',  html:'종(전)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 123 }},
			{ xtype: 'uniNumberfield', width: 123	, name:'OLD_PAY_TOT_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'OLD_BONUS_TOTAL_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'OLD_ADD_BONUS_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'OLD_STOCK_PROFIT_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'OLD_OWNER_STOCK_DRAW_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'OLD_PAY_HAM'},
			{ xtype: 'uniNumberfield', width: 123	, name:'PRE_IN_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'PRE_LOCAL_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'PRE_SP_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'PRE_LOCAL_HAM'},
			
			{ xtype: 'component',  html:'납세조합&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 123 }},
			{ xtype: 'uniNumberfield', width: 123	, name:'NAP_PAY_TOT_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NAP_BONUS_TOTAL_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:''},
			{ xtype: 'uniNumberfield', width: 123	, name:''},
			{ xtype: 'uniNumberfield', width: 123	, name:''},
			{ xtype: 'uniNumberfield', width: 123	, name:'NAP_PAY_HAM'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NAP_IN_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NAP_LOCAL_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NAP_SP_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'NAP_LOCAL_HAM'},
			
			{ xtype: 'component',  html:'합계&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 123 }},
			{ xtype: 'uniNumberfield', width: 123	, name:'PAY_TOTAL_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'BONUS_TOTAL_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'ADD_BONUS_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'STOCK_PROFIT_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'OWNER_STOCK_DRAW_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'TOT_PAY_HAM'},
			{ xtype: 'uniNumberfield', width: 123	, name:'IN_TAX_HAM'},
			{ xtype: 'uniNumberfield', width: 123	, name:'LOCAL_TAX_HAM'},
			{ xtype: 'uniNumberfield', width: 123	, name:'SP_TAX_HAM'},
			{ xtype: 'uniNumberfield', width: 123	, name:'CHONG_HAM'},
			
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component',  html:'결정세액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 123 }},
			{ xtype: 'uniNumberfield', width: 123	, name:'DEF_IN_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'DEF_LOCAL_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'DEF_SP_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'DEF_HAM'},
			
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component', width: 123},
			{ xtype: 'component',  html:'차감징수액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 123 }},
			{ xtype: 'uniNumberfield', width: 123	, name:'IN_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'LOCAL_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'SP_TAX_I'},
			{ xtype: 'uniNumberfield', width: 123	, name:'LOCAL_HAM'}		
		],
		api: {
	 		load: 'had810skrService.selectForm'		
		}
    });
   
    var table2 = Unilite.createForm('table2',{
    	padding:'0 0 0 0',
		disabled: false,
		
		layout: {
			type: 'uniTable',
			columns: 8,
			tableAttrs: {style: 'border : 0px solid #ced9e7;'},
			tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
		},
		defaults: {readOnly: true},
		items: [
			{ xtype: 'component',  html:'총급여액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right' }},
			{ xtype: 'uniNumberfield', name: 'INCOME_SUPP_TOTAL_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'이자상환액(15년~29년)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MORTGAGE_RETURN_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'우리사주조합출연금액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'STAFF_STOCK_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'외국인기술자&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'SKILL_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'근로소득공제&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right' }},
			{ xtype: 'uniNumberfield', name: 'INCOME_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'이자상환액(30년이상)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MORTGAGE_RETURN_I_3', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'우리사주조합기부금&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'STAFF_GIFT_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'조세조약&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'TAXES_REDU_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'근로소득금액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right' }},
			{ xtype: 'uniNumberfield', name: 'EARN_INCOME_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'고정금리비거치상환대출&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MORTGAGE_RETURN_I_5', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'고용유지중소기업근로자&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'EMPLOY_WORKER_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'세액공제'	, tdAttrs: {style: 'border : 1px solid #ced9e7; background-color : #B2CCFF;', width: 120}, height: 10, colspan: 2 	},
			
			{ xtype: 'component',  html:'기본공제'	, tdAttrs: {style: 'border : 1px solid #ced9e7; background-color : #B2CCFF;'}, height: 10, colspan: 2 	},
			{ xtype: 'component',  html:'기타대출&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MORTGAGE_RETURN_I_4', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'장기집합투자증권저축&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'LONG_INVEST_STOCK_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'근로소득세액공제&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'IN_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'본인&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right' }},
			{ xtype: 'uniNumberfield', name: 'PER_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'15년(고정이면서비거치)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MORTGAGE_RETURN_I_6', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'연금보험료공제'	, tdAttrs: {style: 'border : 1px solid #ced9e7; background-color : #B2CCFF;', width: 120}, height: 10, colspan: 2 	},
			{ xtype: 'component',  html:'자녀세액공제&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'container',
//			margin: '0 0 0 0',
//				style: {
//			      paddingTop: '0px',
//			      marginTop: '0px'
//		     	},
			  layout: {type: 'hbox', align: 'stretch'},
			  defaults: {readOnly: true},
			  items:[{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniTextfield', name: 'MANY_CHILD_NUM',
				  	fieldStyle: "text-align:right;",
				  	width: 50
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//		     		}	
			  },{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniNumberfield', name: 'CHILD_TAX_DED_I',
				  	width: 126
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//			     	}
			  }]			
			},
			
			{ xtype: 'component',  html:'배우자&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'container',
//			margin: '0 0 0 0',
//				style: {
//			      paddingTop: '0px',
//			      marginTop: '0px'
//		     	},
			  layout: {type: 'hbox', align: 'stretch'},
			  defaults: {readOnly: true},			  
			  items:[{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniTextfield', name: 'SPOUSE',
				  	width: 50,
				  	fieldStyle: "text-align:right;"
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//		     		}	
			  },{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniNumberfield', name: 'SPOUSE_DED_I',
				  	width: 126
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//			     	}
			  }]			
			},
			{ xtype: 'component',  html:'15년(고정이거나비거치)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MORTGAGE_RETURN_I_7', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'국민연금&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'ANU_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'기타보험료&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'ETC_INSUR_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'부양자&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'container',
//			margin: '0 0 0 0',
//				style: {
//			      paddingTop: '0px',
//			      marginTop: '0px'
//		     	},
			  layout: {type: 'hbox', align: 'stretch'},
			  defaults: {readOnly: true},			  
			  items:[{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniTextfield', name: 'SUPP_NUM',
				  	width: 50,
				  	fieldStyle: "text-align:right;"
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//		     		}	
			  },{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniNumberfield', name: 'SUPP_SUB_I',
				  	width: 126
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//			     	}
			  }]			
			},
			{ xtype: 'component',  html:'15년(그밖의대출)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MORTGAGE_RETURN_I_8', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'공무원연금&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'PUBLIC_PENS_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'장애인전용보장보험료&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'DEFORM_INSUR_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'추가공제'	, tdAttrs: {style: 'border : 1px solid #ced9e7; background-color : #B2CCFF;'}, height: 10, colspan: 2 	},
			{ xtype: 'component',  html:'10년(고정이거나비거치)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MORTGAGE_RETURN_I_9', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'군인연금&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'SOLDIER_PENS_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'의료비&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MED_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'경로우대(70세이상)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'container',
//			margin: '0 0 0 0',
//				style: {
//			      paddingTop: '0px',
//			      marginTop: '0px'
//		     	},
			  layout: {type: 'hbox', align: 'stretch'},
			  defaults: {readOnly: true},			  
			  items:[{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniTextfield', name: 'AGED_NUM',
				  	width: 50,
				  	fieldStyle: "text-align:right;"
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//		     		}	
			  },{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniNumberfield', name: 'AGED_DED_I',
				  	width: 126
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//			     	}
			  }]			
			},
			{ xtype: 'component',  html:'기부금(이월분)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'GIFT_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'사립학교교직원연금&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'SCH_PENS_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'교육비&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'EDUC_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'장애인&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'container',
//			margin: '0 0 0 0',
//				style: {
//			      paddingTop: '0px',
//			      marginTop: '0px'
//		     	},
			  layout: {type: 'hbox', align: 'stretch'},
			  defaults: {readOnly: true},			  
			  items:[{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniTextfield', name: 'DEFORM_NUM',
				  	width: 50,
				  	fieldStyle: "text-align:right;"
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//		     		}	
			  },{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniNumberfield', name: 'DEFORM_DED_I',
				  	width: 126
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//			     	}
			  }]			
			},
			{ xtype: 'component',  html:'차감근로소득&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'DED_INCOME_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'별정우체국연금&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'POST_PENS_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'기부금&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'GIFT_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'부녀자&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'container',
//			margin: '0 0 0 0',
//				style: {
//			      paddingTop: '0px',
//			      marginTop: '0px'
//		     	},
			  layout: {type: 'hbox', align: 'stretch'},
			  defaults: {readOnly: true},			  
			  items:[{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniTextfield', name: 'WOMAN',
				  	width: 50,
				  	fieldStyle: "text-align:right;"
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//		     		}	
			  },{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniNumberfield', name: 'WOMAN_DED_I',
				  	width: 126
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//			     	}
			  }]			
			},
			{ xtype: 'component',  html:'그밖의소득공제'	, tdAttrs: {style: 'border : 1px solid #ced9e7; background-color : #B2CCFF;', width: 120}, height: 10, colspan: 2 	},
			{ xtype: 'component',  html:'특별공제종합한도초과액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'OVER_INCOME_DED_LMT', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'표준세액공제&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'STD_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'한부모&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'container',
//			margin: '0 0 0 0',
//				style: {
//			      paddingTop: '0px',
//			      marginTop: '0px'
//		     	},
			  layout: {type: 'hbox', align: 'stretch'},
			  defaults: {readOnly: true},			  
			  items:[{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniTextfield', name: 'ONE_PARENT',
				  	width: 50,
				  	fieldStyle: "text-align:right;"
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//		     		}	
			  },{
//			  	padding: '0 0 0 0',
//			  	margin: '0 0 0 0',
				  	xtype: 'uniNumberfield', name: 'ONE_PARENT_DED_I',
				  	width: 126
//					style: {
//						paddingTop: '0px',
//						marginTop: '0px'
//			     	}
			  }]			
			},
			{ xtype: 'component',  html:'개인연금저축&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'PRIV_PENS_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'소득과세표준&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'TAX_STD_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'납세조합세액공제 &nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'NAP_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'특별소득공제'	, tdAttrs: {style: 'border : 1px solid #ced9e7; background-color : #B2CCFF;'}, height: 10, colspan: 2 	},
			{ xtype: 'component',  html:'청약저축&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'HOUS_BU_AMT', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'산출세액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'COMP_TAX_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'주택자금상환액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'HOUS_INTER_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'건강보험료&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right' }},
			{ xtype: 'uniNumberfield', name: 'MED_PREMINM_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'근로자주택마련저축&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'HOUS_WORK_AMT', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'세액감면'	, tdAttrs: {style: 'border : 1px solid #ced9e7; background-color : #B2CCFF;', width: 120}, height: 10, colspan: 2 	},
			{ xtype: 'component',  html:'외국납부세액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'OUTSIDE_INCOME_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'고용보험료&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'HIRE_INSUR_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'주택청약종합저축&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'HOUS_BU_AMOUNT_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'소득세법&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'INCOME_REDU_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'월세액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'MON_RENT_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'주택자금(대출기관)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right' }},
			{ xtype: 'uniNumberfield', name: 'HOUS_AMOUNT_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'신용카드&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'CARD_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'중소기업취업자(100%)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'YOUTH_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'과학기술인&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'SCI_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'주택자금(거주자)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right' }},
			{ xtype: 'uniNumberfield', name: 'HOUS_AMOUNT_I_2', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'소기업소상공인공제부금&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'COMP_PREMINUM_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'중소기업취업자(70%)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'YOUTH_DED_I3', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'퇴직연금불입액&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'RETIRE_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			
			{ xtype: 'component',  html:'이자상환액(15년미만)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right' }},
			{ xtype: 'uniNumberfield', name: 'MORTGAGE_RETURN_I_2', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'투자조합출자공제&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'INVESTMENT_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'중소기업취업자(50%)&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'YOUTH_DED_I2', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}},
			{ xtype: 'component',  html:'연금저축&nbsp;', tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'right', width: 180 }},
			{ xtype: 'uniNumberfield', name: 'PENS_TAX_DED_I', width: 176, tdAttrs: {style: 'border-bottom : 0px solid #ced9e7;', align : 'left'}}
		],
		api: {
	 		load: 'had810skrService.selectForm'		
		}
    });
	var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',    
    	autoScroll: true,
	    items: [{
	    	xtype: 'container',
	    	title: '2018년기준',
	    	id:'tab_2018',
	    	layout: {type: 'uniTable', columns: 1},
//	    	layout: {type: 'hbox', align: 'stretch'},
	    	items:[{
	    		margin: '0 0 0 127',
	    		xtype: 'container',
	    		layout: {type: 'uniTable', columns: 3},
	    		items:[
	    			masterGrid1_2018,
		    		{xtype: 'component', width: 2},
		    		masterGrid2_2018
	    		]
	    	},{
    			xtype: 'container',
    			margin: '0 0 0 5',
    			colspan: 3,    			
    			items:[
    				table1_2018, table2_2018
    			]
    		}]
	    },{
	    	xtype: 'container',
	    	title: '2017년기준',
	    	id:'tab_2017',
	    	layout: {type: 'uniTable', columns: 1},
//	    	layout: {type: 'hbox', align: 'stretch'},
	    	items:[{
	    		margin: '0 0 0 127',
	    		xtype: 'container',
	    		layout: {type: 'uniTable', columns: 3},
	    		items:[
	    			masterGrid1,
		    		{xtype: 'component', width: 2},
		    		masterGrid2
	    		]
	    	},{
    			xtype: 'container',
    			margin: '0 0 0 5',
    			colspan: 3,    			
    			items:[
    				table1, table2
    			]
    		}]
	    }],
		listeners: {
			beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
	     		var newTabId = newCard.getId();
				switch(newTabId)	{
				
				}
	     	},
        	tabchange: function( tabPanel, newCard, oldCard ) {
        	
        	}
		}
    });
    Unilite.Main({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		tab, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id  : 'had810skrApp',
		fnInitBinding : function() {			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PERSON_NUMB');
			UniAppManager.setToolbarButtons([ 'prev', 'next'], true);
		},
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()){
				return false;
			}
//			Ext.getBody().mask('로딩중...', 'loading')
			if(tab.getActiveTab().getId()=="tab_2017")	{
				masterGrid1.getStore().loadStoreRecords();
				masterGrid2.getStore().loadStoreRecords();
				var param = panelSearch.getValues();
				table1.getForm().load({
					params: param,
					success: function(form, action) {		
						panelSearch.setValue("PLAN_SAVE_YN",action.result.data.FORE_SINGLE_YN);
						panelResult.setValue("PLAN_SAVE_YN",action.result.data.FORE_SINGLE_YN);
					},
					failure: function(form, action) {
					}
				});
				table2.getForm().load({
					params: param,
					success: function(form, action) {		
	//					Ext.getBody().unmask();
					},
					failure: function(form, action) {
					}
				});
			} else if(tab.getActiveTab().getId()=="tab_2018")	{
				masterGrid1_2018.getStore().loadStoreRecords();
				masterGrid2_2018.getStore().loadStoreRecords();
				var param = panelSearch.getValues();
				table1_2018.getForm().load({
					params: param,
					success: function(form, action) {		
						panelSearch.setValue("PLAN_SAVE_YN",action.result.data.FORE_SINGLE_YN);
						panelResult.setValue("PLAN_SAVE_YN",action.result.data.FORE_SINGLE_YN);
					},
					failure: function(form, action) {
					}
				});
				table2_2018.getForm().load({
					params: param,
					success: function(form, action) {		
	//					Ext.getBody().unmask();
					},
					failure: function(form, action) {
					}
				});
			}
		},
		onResetButtonDown: function() {
			masterGrid1.reset();
			masterGrid2.reset();
			panelSearch.clearForm();
			panelResult.clearForm();
			table1.clearForm();
			table2.clearForm();
			
			masterGrid1_2018.reset();
			masterGrid2_2018.reset();
			table1_2018.clearForm();
			table2_2018.clearForm();
			
			this.fnInitBinding();
		},
		
        onPrevDataButtonDown:  function()    {
            had810skrService.selectPrev(panelSearch.getValues(), function(responseText, response){
                if(responseText){
                    panelSearch.setValue('PERSON_NUMB', responseText.PREV_PERSON_NUMB);
                    panelSearch.setValue('NAME', responseText.NAME);
                    panelSearch.setValue('PLAN_SAVE_YN', responseText.FORE_SINGLE_YN);
                    panelResult.setValue('PERSON_NUMB', responseText.PREV_PERSON_NUMB);
                    panelResult.setValue('NAME', responseText.NAME);
                    panelResult.setValue('PLAN_SAVE_YN', responseText.FORE_SINGLE_YN);
                    UniAppManager.app.onQueryButtonDown();
                }
            })
            
        },
        onNextDataButtonDown:  function()    {
            had810skrService.selectNext(panelSearch.getValues(), function(responseText, response){
                if(responseText){
                    panelSearch.setValue('PERSON_NUMB', responseText.NEXT_PERSON_NUMB);
                    panelSearch.setValue('NAME', responseText.NAME);
                    panelSearch.setValue('PLAN_SAVE_YN', responseText.FORE_SINGLE_YN);
                    panelResult.setValue('PERSON_NUMB', responseText.NEXT_PERSON_NUMB);
                    panelResult.setValue('NAME', responseText.NAME);
                    panelResult.setValue('PLAN_SAVE_YN', responseText.FORE_SINGLE_YN);
                    
                    UniAppManager.app.onQueryButtonDown();
                }
            })
        }
	});

};


</script>
