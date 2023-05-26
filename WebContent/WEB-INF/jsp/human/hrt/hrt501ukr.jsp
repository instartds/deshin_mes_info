<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hrt501ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H053" /> <!--정산구분-->
	<t:ExtComboStore comboType="AU" comboCode="H168" /> <!--퇴직사유--> 
</t:appConfig>
<style type="text/css">
.x-grid-item-focused  .x-grid-cell-inner:before {
    border: 0px; 
}
</style>
<script type="text/javascript" >

function appMain() {

	// tab01 form 로드 상태
	var formLoad = false;
	// 정산내역탭 로딩이 된 이후 저장 여부  
	var tab01Saved = false;
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hrt501ukrModel1', {
	    fields: [ {name: 'RETR_DATE'				    	,text:'거래처명'		,type:'uniDate'}
	    		 ,{name: 'RETR_TYPE'					    ,text:'화폐단위'		,type:'string'}
	    		 ,{name: 'PERSON_NUMB'				    	,text:'전일미수'		,type:'string'}
	    		 ,{name: 'PAY_YYYYMM'				    	,text:'급여년월'		,type:'string', editable:false}
	    		 ,{name: 'WAGES_CODE'					    ,text:'부가세'			,type:'string'}
	    		 ,{name: 'WAGES_NAME'				    	,text:'지급구분'		,type:'string', editable:false}
	    		 ,{name: 'AMOUNT_I'			    			,text:'금액'			,type:'uniPrice'}
	    		 ,{name: 'PAY_STRT_DATE'				    ,text:'매출계'			,type:'string'}
	    		 ,{name: 'PAY_LAST_DATE'			    	,text:'현금입금'		,type:'string'}
	    		 ,{name: 'WAGES_DAY'			    		,text:'어음입금'		,type:'string'}
			]
	});	
	
	Unilite.defineModel('Hrt501ukrModel2', {
		fields: [ {name: 'RETR_DATE'				    	,text:'거래처명'		,type:'uniDate'}
				 ,{name: 'RETR_TYPE'					    ,text:'화폐단위'		,type:'string'}
				 ,{name: 'PERSON_NUMB'				    	,text:'전일미수'		,type:'string'}
				 ,{name: 'PAY_YYYYMM'				    	,text:'급여년월'		,type:'string', editable:false}
				 ,{name: 'WEL_CODE'					    	,text:'부가세'			,type:'string'}
				 ,{name: 'WEL_NAME'				    		,text:'지급구분'		,type:'string', editable:false}
				 ,{name: 'GIVE_I'			    			,text:'금액'			,type:'uniPrice'}
				 ,{name: 'WEL_LEVEL1'				    	,text:'에누리'			,type:'string'}
				 ,{name: 'WEL_LEVEL2'				    	,text:'에누리'			,type:'string'}
				 ,{name: 'APPLY_YYMM'				    	,text:'에누리'			,type:'uniDate'}
				 ,{name: 'PAY_STRT_DATE'				    ,text:'매출계'			,type:'string'}
				 ,{name: 'PAY_LAST_DATE'			    	,text:'현금입금'		,type:'string'}
				 ,{name: 'WAGES_DAY'			    		,text:'어음입금'		,type:'string'}
			]
	});
	
	Unilite.defineModel('Hrt501ukrModel3', {
		fields: [ {name: 'RETR_DATE'				    	,text:'거래처명'		,type:'uniDate'}
				 ,{name: 'RETR_TYPE'					    ,text:'화폐단위'		,type:'string'}
				 ,{name: 'PERSON_NUMB'				    	,text:'전일미수'		,type:'string'}
				 ,{name: 'BONUS_YYYYMM'				    	,text:'상여구분'		,type:'string', editable:false}
				 ,{name: 'BONUS_TYPE'					    ,text:'부가세'			,type:'string'}
				 ,{name: 'BONUS_NAME'				    	,text:'상여구분'		,type:'string', editable:false}
				 ,{name: 'BONUS_I'			    			,text:'금액'			,type:'uniPrice'}
				 ,{name: 'BONUS_RATE'				    	,text:'에누리'			,type:'string'}
			]
	});
	
	Unilite.defineModel('Hrt501ukrModel4', {
		fields: [ {name: 'RETR_DATE'				    	,text:'거래처명'		,type:'uniDate'}
				 ,{name: 'RETR_TYPE'					    ,text:'화폐단위'		,type:'string'}
				 ,{name: 'PERSON_NUMB'				    	,text:'전일미수'		,type:'string'}
				 ,{name: 'BONUS_YYYYMM'				    	,text:'년월차년월'		,type:'string'}//, editable:false}
				 ,{name: 'BONUS_TYPE'					    ,text:'부가세'			,type:'string'}
				 ,{name: 'BONUS_NAME'				    	,text:'년월차구분'		,type:'string'}//, editable:false}
				 ,{name: 'BONUS_RATE'			    		,text:'에누리세엑'		,type:'string'}
				 ,{name: 'BONUS_I'			    			,text:'금액'			,type:'uniPrice'}
				 ,{name: 'SUPP_DATE'				    	,text:'지급일'			,type:'uniDate'}
				 ,{name: 'BONUS_RATE'				    	,text:'에누리'			,type:'string'}
			]
	});
	
	Unilite.defineModel('Hrt501ukrModel5', {
		fields: [ {name: 'SEQ'					    		,text:'부가세'			,type:'string'}
		         ,{name: 'DIVI_CODE'				    	,text:'구분'			,type:'string'}
				 ,{name: 'DIVI_NAME'					    ,text:'구분'			,type:'string'}
				 ,{name: 'DATA_TYPE'					    ,text:'화폐단위'		,type:'string'}
				 ,{name: 'CONTENT'				    		,text:'내용'			,type:'string'}
				 ,{name: 'REMARK'				    		,text:'산출식'			,type:'string'}
			]
	});
	
	Unilite.defineModel('Hrt501ukrModel6', {
		fields: [ {name: 'SUPP_DATE'					    ,text:'지급일자'		 ,type:'string'}
		         ,{name: 'RETR_DATE_FR'				    	,text:'중도정산기산일(FR)'	 ,type:'string'}
				 ,{name: 'RETR_DATE_TO'					    ,text:'중도정산기산일(TO)'	 ,type:'string'}
				 ,{name: 'RETR_ANNU_I'					    ,text:'퇴직급여'		 ,type:'uniPrice'}
				 ,{name: 'IN_TAX_I'				    		,text:'소득세'			 ,type:'uniPrice'}
				 ,{name: 'LOCAL_TAX_I'				    	,text:'지방소득세'		 ,type:'uniPrice'}
				 ,{name: 'BALANCE_I'				    	,text:'차인지급액'		 ,type:'uniPrice'}
				 ,{name: 'REMARK'				    		,text:'비고'			 ,type:'string'}
			]
	});
	
	
	/**
	 *  산정내역(임원) 콤보박스  Store
	 */
	var comboStore = Unilite.createStore('comboStore', {
	    fields: ['value', 'text', 'remark'],
		data :  [
			        {'value': 'JOIN_DATE', 			 'text': '입사일', 				  'remark': ''},
			        {'value': 'RETR_DATE', 			 'text': '퇴사일', 				  'remark': ''},
			        {'value': 'ORG_RETR_ANNU_I', 	 'text': '퇴직급여', 				  'remark': ''},
			        {'value': 'ORG_GLORY_AMOUNT_I',  'text': '명예퇴직급여', 				  'remark': ''},
			        {'value': 'ORG_ETC_AMOUNT_I',    'text': '기타지급', 				  'remark': ''},
			        {'value': 'ORG_GROUP_INSUR_I',   'text': '퇴직보험금', 				  'remark': ''},
			        {'value': 'M_SUPP_TOTAL_I',      'text': '중도정산퇴직금', 			  'remark': ''},
			        {'value': 'SUPP_TOTAL_I',        'text': '실제 퇴직금(a)', 			  'remark': ''},
			        {'value': 'Y2011_SUPP_TOTAL_I',  'text': '2011.12.31 중간정산가정액(b)', 'remark': ''},
			        {'value': 'STD_RETR_ANNU_I',     'text': '한도대상퇴직금(c)', 			  'remark': '실제퇴직금(a) - 2011.12.31 중간정산가정액(b)'},
			        {'value': 'Y_AVG_PAY_I',         'text': '연평균급여(d)', 			  'remark': '퇴직일부터소급(3년급여) / 36 * 12'},
			        {'value': 'CON_RETR_ANNU_I',     'text': '퇴직소득한도(e)', 			  'remark': '연평균급여(d) * 1/10 * 근속년수 * 3배'},
			        {'value': 'PAY_ANNU_I',          'text': '근로소득간주액(f)', 			  'remark': '한도대상퇴직금(c) - 퇴직소득한도(e)'},
			        {'value': 'RETR_ANNU_I',         'text': '퇴직소득금액', 				  'remark': '실제퇴직금(a) - 근로소득간주액(f)'},
			        {'value': 'R_IN_TAX_I',          'text': '소득세', 				  'remark': ''},
			        {'value': 'R_LOCAL_TAX_I',       'text': '주민세', 				  'remark': ''},
			        {'value': 'M_RETR_ANNU_I',       'text': '지급된 중도정산퇴직금', 		  'remark': ''}
	    		]
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hrt501ukrMasterStore1',{
			model: 'Hrt501ukrModel1',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'hrt501ukrService.selectList01'                	
                }
            }
			,loadStoreRecords : function()	{	
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: 'PAY_YYYYMM'
	});
	
	var directMasterStore2 = Unilite.createStore('hrt501ukrMasterStore1',{
		model: 'Hrt501ukrModel2',
		uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'hrt501ukrService.selectList02'                	
            }
        }
		,loadStoreRecords : function()	{	
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});			
		}
	});
			
	var directMasterStore3 = Unilite.createStore('hrt501ukrMasterStore3',{
		model: 'Hrt501ukrModel3',
		uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
           },
           autoLoad: false,
           proxy: {
               type: 'direct',
               api: {			
               	   read: 'hrt501ukrService.selectList03'                	
               }
           }
		,loadStoreRecords : function()	{	
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore4 = Unilite.createStore('hrt501ukrMasterStore4',{
		model: 'Hrt501ukrModel4',
		uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
           },
           autoLoad: false,
           proxy: {
               type: 'direct',
               api: {
            	   create: 'hrt501ukrService.insertList04',
               	   read: 'hrt501ukrService.selectList04',
               	   update: 'hrt501ukrService.updateList04',
               	   syncAll: 'hrt501ukrService.syncAll'
               }
           }
		,loadStoreRecords : function()	{	
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore5 = Unilite.createStore('hrt501ukrMasterStore5',{
		model: 'Hrt501ukrModel5',
		uniOpt : {
           	isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
           },
           autoLoad: false,
           proxy: {
               type: 'direct',
               api: {			
               	   read: 'hrt501ukrService.selectList05'                	
               }
           }
		,loadStoreRecords : function()	{	
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore6 = Unilite.createStore('hrt501ukrMasterStore6',{
		model: 'Hrt501ukrModel6',
		uniOpt : {
           	isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
           },
           autoLoad: false,
           proxy: {
               type: 'direct',
               api: {			
               	   read: 'hrt501ukrService.selectList06'                	
               }
           }
		,loadStoreRecords : function()	{	
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm',{
		padding: '10 10 10 10',
		layout : {type : 'uniTable', columns : 3},
		items : [{
			xtype: 'uniTextfield',
			fieldLabel: '성명',
			name: ''
		},
			Unilite.popup('Employee',{
			
			textFieldWidth: 170,
			id: 'PERSON_NUMB',
			allowBlank: false,
			listeners: {'onSelected': {
				fn: function(records, type) {
						console.log(records[0]);
						// 퇴사여부 확인
						if (records[0].RETR_DATE != '') {
							panelSearch.getForm().setValues({'RETR_DATE' : records[0].RETR_DATE, 'RETR_TYPE' : 'R'});
						} else {
							panelSearch.getForm().setValues({'RETR_TYPE' : 'M'});
						}
						// 임원, 직원 여부 확인
						Ext.Ajax.request({
							url: CPATH+'/human/checkRetrOTKind.do',
							params: { PERSON_NUMB : records[0].PERSON_NUMB },
							success: function(response){
								data = Ext.decode(response.responseText);
								console.log(data);
								Ext.getCmp('OT_KIND').setValue({OT_KIND : data.RETR_OT_KIND});
							},
							failure: function(response){
								console.log(response);
							}
						});
					},
				scope: this
				}
			}
		}),{
			xtype: 'radiogroup',		            		
			fieldLabel: '퇴직분류',
			id: 'OT_KIND',
			items: [{
				boxLabel: '임원',
				width: 50,
				name: 'OT_KIND',
				inputValue: 'OF',
				checked: true
			}, {
				boxLabel: '직원',
				width: 60,
				name: 'OT_KIND',
				inputValue: 'ST'
			}]
		}, {
			fieldLabel: '정산구분',
			name:'RETR_TYPE',
			id: 'RETR_TYPE',
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'H053',
			value: 'M',
			allowBlank: false
		}, {
	        fieldLabel: '정산일',
	        xtype: 'uniDatefield',
	        value: UniDate.get('today'),
	        allowBlank: false,
	        name: 'RETR_DATE',
	        id: 'RETR_DATE'
		}, {
			xtype: 'radiogroup',		            		
			fieldLabel: '세액계산',
			id: 'TAX_CALCU',
			name: 'TAX_CALCU',
			items: [{
				boxLabel: '한다',
				width: 50,
				name: 'TAX_CALCU',
				inputValue: 'Y',
				checked: true
			}, {
				boxLabel: '안한다',
				width: 60,
				name: 'TAX_CALCU',
				inputValue: 'N'
			}]
		}]
	});  
	    
	var search1 = Unilite.createSearchForm('search1',{	
		autoScroll: true,
		padding: '10 10 10 10',
		xtype: 'container',
// 		flex: 1,
	    api: {
        	load: 'hrt501ukrService.selectFormData01',
        	submit: 'hrt501ukrService.submitFormData01'
        },
        trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},		
		items: [{
			xtype: 'container',
			layout: {type: 'uniTable', columns:8},
			items: [{
				 xtype: 'container',
				 html:'<b>■ 근속내역</b>',
				 colspan: 8
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '정산시작일',
				name: 'JOIN_DATE',
				colspan: 2
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '정산(퇴직)일',
				name: 'RETR_DATE',
				colspan: 2
			}, {
	        	fieldLabel: '지급일',
		        xtype: 'uniDatefield',
		        id: 'SUPP_DATE',
		        name: 'SUPP_DATE',
		        allowBlank: false,
				colspan: 2
			}, {
				fieldLabel: '사유',
				name:'RETR_RESN', 	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'H168',
				value: '6',
				allowBlank: false,
				colspan: 2
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '근속기간',
				name: 'YYYYMMDD',
				colspan: 2
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '근속일수',
				name: 'LONG_TOT_DAY',
				value: '0',
				width: 160,
				colspan: 2
			}, {
				xtype: 'container',
				defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align: 'stretch'},
				width:245,
				margin:0,
				colspan: 2,
				items:[{
					fieldLabel: '누진/근속월수',
					suffixTpl: '&nbsp;/&nbsp;',
					name: 'ADD_MONTH',
					width:175
				}, {
					name: 'LONG_TOT_MONTH',
				    width:70
				}]
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '근속년수',
				name: 'LONG_YEARS',
				id: 'LONG_YEARS',
				value: '0',
				width: 160,
				colspan: 2
			},{
				xtype: 'hiddenfield',
				fieldLabel: '근속년',
				name: 'DUTY_YYYY'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '근속월',
				name: 'LONG_MONTH'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '근속일',
				name: 'LONG_DAY'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '3개월총일수',
				name: 'AVG_DAY'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '급여총액',
				name: 'PAY_TOTAL_I'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '상여총액',
				name: 'BONUS_TOTAL_I'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '년월차총액',
				name: 'YEAR_TOTAL_I'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '퇴직소득정률공제',
				name: 'SPEC_DED_I'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '근속연수공제',
				name: 'INCOME_DED_I'
			},{ // 영수증
				xtype: 'hiddenfield',
				fieldLabel: '(15)퇴직급여_최종',
				name: 'R_ANNU_TOTAL_I'
			},{ // 영수증
				xtype: 'hiddenfield',
				fieldLabel: '(17)과세대상 퇴직급여(15-16)_최종',
				name: 'R_TAX_TOTAL_I'
			},{ // 영수증
				xtype: 'hiddenfield',
				fieldLabel: '(15)퇴직급여_중간',
				name: 'M_ANNU_TOTAL_I'
			},{ // 영수증
				xtype: 'hiddenfield',
				fieldLabel: '(16)비과세 퇴직급여_중간',
				name: 'M_OUT_INCOME_I'
			},{ // 영수증
				xtype: 'hiddenfield',
				fieldLabel: '정산(합산)근속연수',
				name: 'S_LONG_YEARS'
			},{ // 영수증
				xtype: 'hiddenfield',
				fieldLabel: '2013이전근속연수',
				name: 'LONG_YEARS_BE13'
			},{ // 영수증
				xtype: 'hiddenfield',
				fieldLabel: '2013이후근속연수',
				name: 'LONG_YEARS_AF13'
			},{ // 영수증
				xtype: 'hiddenfield',
				fieldLabel: '최종분-기산일',
				name: 'R_CALCU_END_DATE'
			} // 이하 form submit용 hidden field -> detailForm내부의 field
			,{ 
				xtype: 'hiddenfield',
				fieldLabel: '중도정산(과세대상)(B)',
				name: 'M_TAX_TOTAL_I'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '근로소득간주액(C)',
				name: 'PAY_ANNU_I'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '실지급액',
				name: 'REAL_AMOUNT_I'
			}
			]			
		}, {
			xtype: 'container',
			layout: {
				type: 'uniTable',
				columns:8,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
    			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			defaults: {width: 120},
			items: [
				{ xtype: 'component',  html:'퇴직금계산내역', colspan: 2},
		    	{ xtype: 'component',  html:'지급내역', colspan: 2},
		    	{ xtype: 'component',  html:'세액내역', colspan: 2},
		    	{ xtype: 'component',  html:'공제내역', colspan: 2},		    	
		
				{ xtype: 'component', html:'3개월 급여'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'AVG_PAY_3'},
		    	{ xtype: 'component', html:'퇴직급여'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETR_ANNU_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnSuppTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'과세대상 퇴직급여'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'SUPP_TOTAL_I'},
		    	{ xtype: 'component', html:'소득세'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'IN_TAX_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnDedTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'3개월상여'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'AVG_BONUS_I_3'},
		    	{ xtype: 'component', html:'명예퇴직금'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'GLORY_AMOUNT_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnSuppTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'퇴직소득공제'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'EARN_INCOME_I'},
		    	{ xtype: 'component', html:'지방소득세'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'LOCAL_TAX_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnDedTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'3개월년차'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'AVG_YEAR_I_3'},
		    	{ xtype: 'component', html:'퇴직보험금'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'GROUP_INSUR_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnSuppTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'과세표준'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'TAX_STD_I'},
		    	{ xtype: 'component', html:'소득세환급액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DED_IN_TAX_ADD_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnDedTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'합계'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'TOT_WAGES_I'},
		    	{ xtype: 'component', html:'비과세소득'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'OUT_INCOME_I', id: 'OUT_INCOME_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnSuppTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'연평균과세표준'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'AVG_TAX_STD_I'},
		    	{ xtype: 'component', html:'주민세환급액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DED_IN_LOCAL_ADD_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnDedTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'평균임금'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'AVG_WAGES_I'},
		    	{ xtype: 'component', html:'기타지급'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ETC_AMOUNT_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnSuppTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'연평균산출세액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'AVR_COMP_TAX_I'},
		    	{ xtype: 'component', html:'기타공제'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DED_ETC_I'
		    		,listeners: {
		    			blur: function(comp, action) { 
		    				if (formLoad) fnDedTotI();
						}
		    		}
		    	},
		    	{ xtype: 'component', html:'근속일수'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '&nbsp;&nbsp;&nbsp;', readOnly:true, name: 'LONG_TOT_DAY', id: 'LONG_TOT_DAY'},
		    	{ xtype: 'component', html:'지급총액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETR_SUM_I', id: 'RETR_SUM_I'},
		    	{ xtype: 'component', html:'산출세액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'COMP_TAX_I'},
		    	{ xtype: 'component', html:'공제총액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DED_TOTAL_I'},
		    	
		    	{ xtype: 'component', html:'퇴직급여'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'ORI_RETR_ANNU_I'},
		    	{ xtype: 'component', html:'근로소득간주액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PAY_ANNU_I'},
		    	{ xtype: 'component', colspan: 4}
			    	
			]			
		}], 
		listeners: {
			actioncomplete: function(form, action) {
				// dirty change 이벤트 , load 후 
				search1.getForm().on({
					dirtychange: function(form, dirty, eOpts) {
						if (dirty) {
							UniAppManager.app.setToolbarButtons('save', true);
						} else {
							UniAppManager.app.setToolbarButtons('save', false);
						}
					}
				});
			}
// 		,
// 			,
// 			dirtychange: function(form, dirty, eOpts) {
// 				if (dirty) {
// 					UniAppManager.app.setToolbarButtons('save', true);
// 				} else {
// 					UniAppManager.app.setToolbarButtons('save', false);
// 				}
// 			}
		}
	});
	
	var search2 = Unilite.createSearchForm('search2',{	
		autoScroll: true,
		padding: '10 10 10 10',
		xtype: 'container',
// 		flex: 1,
	    api: {
        	load: 'hrt501ukrService.selectFormData02'
        },
        trackResetOnLoad: true,
		layout:{type:'vbox', align:'left', defaultMargins: '0 0 5 0'},		
		items: [{
			xtype: 'container',
			layout: {
				type: 'uniTable',
				columns:6,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
    			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			defaults: {width: 180},
			items: [
				{ xtype: 'component',  html:'과세내역', colspan: 2},
		    	{ xtype: 'component',  html:'법정퇴직'},
		    	{ xtype: 'component',  html:'산출산식', colspan: 3, width:540 },
		    	
		    	{ xtype: 'component',  html:'퇴직급여액', colspan: 2},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'A'},
		    	{ xtype: 'component',  html:'퇴직급여액 과세소득', colspan: 3, style: 'text-align:left', width: 520},
		    	
		    	{ xtype: 'component',  html:'퇴직급여액', rowspan: 6},
		    	{ xtype: 'component',  html:'소득공제(ⓐ)'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'B'},
		    	{ xtype: 'component',  html:'2011년 귀속부터 퇴직급여액의 40%', colspan: 3, style: 'text-align:left', width: 520},
		
		    	{ xtype: 'component',  html:'근속연수별공제(ⓑ)', rowspan: 4},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'C'},
		    	{ xtype: 'component',  html:'&nbsp;&nbsp;5년이하', width: 180, style: 'text-align:left'},
		    	{ xtype: 'component',  html:'&nbsp;&nbsp;30만 * 근속연수', colspan: 2, width: 360, style: 'text-align:left'},
		    	
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'D'},
		    	{ xtype: 'component',  html:'&nbsp;&nbsp;10년이하', width: 180, style: 'text-align:left'},
		    	{ xtype: 'component',  html:'&nbsp;&nbsp;150만 + {50만 * (근속연수 - 5)}', colspan: 2, width: 360, style: 'text-align:left'},
		    	
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'E'},
		    	{ xtype: 'component',  html:'&nbsp;&nbsp;20년이하', width: 180, style: 'text-align:left'},
		    	{ xtype: 'component',  html:'&nbsp;&nbsp;400만 + {80만 * (근속연수 - 10)}', colspan: 2, width: 360, style: 'text-align:left'},
		    	
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'F'},
		    	{ xtype: 'component',  html:'&nbsp;&nbsp;20년초과', width: 180, style: 'text-align:left'},
		    	{ xtype: 'component',  html:'&nbsp;&nbsp;1,200만 + {120만 * (근속연수 - 20)}', colspan: 2, width: 360, style: 'text-align:left'},
			    
		    	{ xtype: 'component',  html:'계 ((ⓐ) + (ⓑ))'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'G'},
		    	{ xtype: 'component',  html:'소득공제(ⓐ) + 근속연수별공제(ⓑ)', colspan: 3, style: 'text-align:left', width: 520},
		    	
		    	{ xtype: 'component',  html:'과세표준', colspan: 2},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'H'},
		    	{ xtype: 'component',  html:'퇴직급여액 - 퇴직소득공제', colspan: 3, style: 'text-align:left', width: 520},
		    	
		    	{ xtype: 'component',  html:'연평균과세표준', colspan: 2},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'I'},
		    	{ xtype: 'component',  html:'과세표준 / 세법상근속연수', colspan: 3, style: 'text-align:left', width: 520},
		    	
		    	{ xtype: 'component',  html:'퇴직급여액', rowspan: 5},
		    	{ xtype: 'component',  html:'1천 2백만원 이하'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'J'},
		    	{ xtype: 'component',  html:'6%', colspan: 3, style: 'text-align:left', width: 520},
		    	
		    	{ xtype: 'component',  html:'4천 6백만원 이하'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'K'},
		    	{ xtype: 'component',  html:'72만 + {(연평균과세표준 - 1,200만) * 15%}', colspan: 3, style: 'text-align:left', width: 520},
		    	
		    	{ xtype: 'component',  html:'8천 6백만원 이하'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'L'},
		    	{ xtype: 'component',  html:'582만 + {(연평균과세표준 - 4,600만) * 24%}', colspan: 3, style: 'text-align:left', width: 520},
		    	
		    	{ xtype: 'component',  html:'3억 이하'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'M'},
		    	{ xtype: 'component',  html:'1,590만 + {(연평균과세표준 - 8,800만) * 35%}', colspan: 3, style: 'text-align:left', width: 520},
		    	
		    	{ xtype: 'component',  html:'3억 초과'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'N'},
		    	{ xtype: 'component',  html:'9,010만 + {(연평균과세표준 - 3억) * 38%}', colspan: 3, style: 'text-align:left', width: 520},
		    	
		    	{ xtype: 'component',  html:'산출세액', colspan: 2},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'O'},
		    	{ xtype: 'component',  html:'연평균산출세액 * 세법상근속연수', colspan: 3, style: 'text-align:left', width: 520}
			]			
		}]
	});
	
	var detailForm = Unilite.createSimpleForm('detailForm', {
		region: 'south',
		items:[{
			 xtype: 'container',
			 html:'<b>■ 퇴직금 산출액 및 산출 세액</b>',
			 colspan: 8,
			 padding: '30 0 0 0'
		}, {
			xtype: 'container',
			layout: {
				type: 'uniTable',
				columns:6,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			defaults: {width: 120},
			items: [
				{ xtype: 'component', html:'지급총액(과세대상)(A)', rowspan: 2},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, rowspan: 2, name: 'RETR_SUM_I2', id: 'RETR_SUM_I2'},
		    	{ xtype: 'component', html:'중도정산(과세대상)(B)'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'M_TAX_TOTAL_I'},
		    	{ xtype: 'component', html:'과세대상 퇴직급여</br>(A) + (B) - (C)', rowspan: 2},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, rowspan: 2, name: 'SUPP_TOTAL_I'},
		    	
		    	
		    	{ xtype: 'component', html:'근로소득간주액(C)'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PAY_ANNU_I'},
		    	
		    	
		    	{ xtype: 'component', html:'산출세액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'COMP_TAX_I'},
		    	{ xtype: 'component', html:'기납부세액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'PAY_END_TAX'},
		    	{ xtype: 'component', html:'결정세액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DEF_TAX_I'},
		    	
		    	
		    	{ xtype: 'component', html:'지급총액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'RETR_SUM_I', id: 'RETR_SUM_I3'},
		    	{ xtype: 'component', html:'공제총액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'DED_TOTAL_I', id: 'DED_TOTAL_I2'},
		    	{ xtype: 'component', html:'실지급액'},
		    	{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'REAL_AMOUNT_I', id: 'REAL_AMOUNT_I'}
			]			
		}]
	});

	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */

    var masterGrid1 = Unilite.createGrid('hrt501ukrGrid1', {
        title: '급여내역',
    	layout : 'fit',        
        store: directMasterStore1,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: false,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },
        features: [{
	        	id: 'masterGridSubTotal',
	        	ftype: 'uniGroupingsummary', 
	        	showSummaryRow: false 
	        },{
		        id: 'masterGridTotal', 	
		        ftype: 'uniSummary', 
		        showSummaryRow: false
	        }],
    	flex: 1,
        columns:  [  { dataIndex:'RETR_DATE'	, hidden: true }
        			,{ dataIndex:'RETR_TYPE'	, hidden: true }
        			,{ dataIndex:'PERSON_NUMB'	, hidden: true }
        			,{ dataIndex:'PAY_YYYYMM'	, flex: 1, summaryType: 'totaltext'}
        			,{ dataIndex:'WAGES_CODE'	, hidden: true }
        			,{ dataIndex:'WAGES_NAME'	, flex: 1.5}
        			,{ dataIndex:'AMOUNT_I'		, flex: 4, summaryType: 'sum'}
        			,{ dataIndex:'PAY_STRT_DATE', hidden: true }
        			,{ dataIndex:'PAY_LAST_DATE', hidden: true }
        			,{ dataIndex:'WAGES_DAY'	, hidden: true }
          ],
          listeners: {
            	containerclick: function() {
            		setButtonState(false);
            	}, select: function() {
            		setButtonState(false);
            	}, cellclick: function() {
            		setButtonState(false);
            	}
          } 
    });
    
    var masterGrid2 = Unilite.createGrid('hrt501ukrGrid2', {
    	// for tab 
    	title: '기타수당내역',
        layout : 'fit',        
        store: directMasterStore2,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: false,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },
    	features: [{
    		id: 'masterGridTotal2', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
    	flex: 1,
		columns:  [  { dataIndex:'RETR_DATE'	, hidden: true }
					,{ dataIndex:'RETR_TYPE'	, hidden: true }
					,{ dataIndex:'PERSON_NUMB'	, hidden: true }
					,{ dataIndex:'PAY_YYYYMM'	, flex: 1, summaryType: 'totaltext'}
					,{ dataIndex:'WEL_CODE'		, hidden: true }
					,{ dataIndex:'WEL_NAME'		, flex: 1.5}
					,{ dataIndex:'GIVE_I'		, flex: 4, summaryType: 'sum'}
					,{ dataIndex:'WEL_LEVEL1'	, hidden: true }
					,{ dataIndex:'WEL_LEVEL2'	, hidden: true }
					,{ dataIndex:'APPLY_YYMM'	, hidden: true }
					,{ dataIndex:'PAY_STRT_DATE', hidden: true }
					,{ dataIndex:'PAY_LAST_DATE', hidden: true }
					,{ dataIndex:'WAGES_DAY'	, hidden: true }
		],
        listeners: {
        	containerclick: function() {
        		setButtonState(false);
        	}, select: function() {
        		setButtonState(false);
        	}, cellclick: function() {
        		setButtonState(false);
        	}
      }  
    });
    
    var masterGrid3 = Unilite.createGrid('hrt501ukrGrid3', {
    	// for tab 
    	title: '상여내역',
        layout : 'fit',        
        store: directMasterStore3,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: false,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },
    	features: [{
    		id: 'masterGridTotal3', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
    	flex: 1,
    	columns:  [  { dataIndex:'RETR_DATE'	, hidden: true }
					,{ dataIndex:'RETR_TYPE'	, hidden: true }
					,{ dataIndex:'PERSON_NUMB'	, hidden: true }
					,{ dataIndex:'BONUS_YYYYMM'	, flex: 1, summaryType: 'totaltext'}
					,{ dataIndex:'BONUS_TYPE'	, hidden: true }
					,{ dataIndex:'BONUS_NAME'	, flex: 1.5}
					,{ dataIndex:'BONUS_I'		, flex: 4, summaryType: 'sum'}
					,{ dataIndex:'BONUS_RATE'	, hidden: true }
		],
          listeners: {
            	containerclick: function() {
            		setButtonState(false);
            	}, select: function() {
            		setButtonState(false);
            	}, cellclick: function() {
            		setButtonState(false);
            	}
          } 
    });
    
    var masterGrid4 = Unilite.createGrid('hrt501ukrGrid4', {
    	// for tab 
    	title: '년월차내역',
        layout : 'fit',        
        store: directMasterStore4,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: false,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },
    	features: [{
    		id: 'masterGridTotal4', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
    	flex: 1,
		columns:  [  { dataIndex:'RETR_DATE'	, hidden: true }
					,{ dataIndex:'RETR_TYPE'	, hidden: true }
					,{ dataIndex:'PERSON_NUMB'	, hidden: true }
					,{ dataIndex:'BONUS_YYYYMM'	, flex: 1, summaryType: 'totaltext'}
					,{ dataIndex:'BONUS_TYPE'	, hidden: true }
					,{ dataIndex:'BONUS_NAME'	, flex: 1.5}
					,{ dataIndex:'BONUS_RATE'	, hidden: true}
					,{ dataIndex:'BONUS_I'		, flex: 4, summaryType: 'sum'}
					,{ dataIndex:'SUPP_DATE'	, hidden: true }
					,{ dataIndex:'BONUS_RATE'	, hidden: true }
		],
        listeners: {
        	containerclick: function() {
        		setButtonState(true);
        	}, select: function() {
        		setButtonState(true);
        	}, cellclick: function() {
        		setButtonState(true);
        	}, beforeedit: function(editor, e) {
        		//update시 금액만 수정이 가능하도록함
        		if (!e.record.phantom && !e.field == 'BONUS_I') {
        			return false;
        		}
        	}, edit: function(editor, e) {
				var fieldName = e.field;
				var num_check = /[0-9]/;
				if (fieldName == 'BONUS_I') {
					if (!num_check.test(e.value)) {
						Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
						e.record.set(fieldName, e.originalValue);
						return false;
					}
				}
        	}
      } 
    });
    
    var masterGrid5 = Unilite.createGrid('hrt501ukrGrid5', {
    	// for tab 
        layout : 'fit',        
        store: directMasterStore5,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: false,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },
    	flex: 1,
		columns:  [  { dataIndex:'SEQ'	, hidden: true }
					,{ dataIndex:'DIVI_CODE'	, flex: 1,
						editor: {
        					xtype: 'combobox',
        					store: comboStore,
        					lazyRender: true,
                            displayField : 'text',
                            valueField : 'value'
        				},
        				renderer: function(value) {
        					var record = comboStore.findRecord('value', value);
							if (record == null || record == undefined ) {
								return '';
							} else {
								return record.data.text;
							}
        				}
					 }
					,{ dataIndex:'DIVI_NAME'    , hidden: true }
					,{ dataIndex:'DATA_TYPE'    , hidden: true}
					,{ dataIndex:'CONTENT'		, flex: 1 }
					,{ dataIndex:'REMARK'	, flex: 6,
						editor: {
        					xtype: 'combobox',
        					store: comboStore,
        					lazyRender: true,
                            displayField : 'remark',
                            valueField : 'value'
        				},
        				renderer: function(value) {
        					var record = comboStore.findRecord('value', value);
							if (record == null || record == undefined ) {
								return '';
							} else {
								return record.data.remark;
							}
        				}
					 }
		] 
    });
    
    var masterGrid6 = Unilite.createGrid('hrt501ukrGrid6', {
    	// for tab 
        layout : 'fit',        
        store: directMasterStore6,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: false,
            useMultipleSorting: false,
		    state: {
			    useState: false,
			    useStateList: false
		    }
        },
    	features: [{
    		id: 'masterGridTotal6', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
    	flex: 1,
		columns:  [  { dataIndex:'SUPP_DATE'	, summaryType: 'totaltext' , width: 150, align: 'center'}
					,{ dataIndex:'RETR_DATE_FR'	, width: 150, align: 'center'}
					,{ dataIndex:'RETR_DATE_TO'	, width: 150, align: 'center'}
					,{ dataIndex:'RETR_ANNU_I'	, width: 150, summaryType: 'sum'}
					,{ dataIndex:'IN_TAX_I'		, width: 150, summaryType: 'sum'}
					,{ dataIndex:'LOCAL_TAX_I'	, width: 150, summaryType: 'sum'}
					,{ dataIndex:'BALANCE_I'	, width: 150, summaryType: 'sum'}
					,{ dataIndex:'REMARK'		, width: 300}
		] 
    });
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    id: 'tab',
	    items: [
			     {title: '정산내역'
				 ,id: 'hrt501ukrTab01'				    	 
			     ,autoScroll: true
			     ,layout:{type:'vbox', align:'stretch'}
			     ,items:[search1]
			     },
			     {title: '산정내역'
				 ,id: 'hrt501ukrTab02'			    	 
			     ,xtype:'container'
			     ,layout:{type:'hbox', align:'stretch'}
			     ,items:[masterGrid1, masterGrid2, masterGrid3, masterGrid4] 
			     },
			     {title: '산정내역(임원)'
				 ,id: 'hrt501ukrTab03'			    	 
			     ,xtype:'container'
			     ,layout:{type:'vbox', align:'stretch'}
			     ,items:[masterGrid5] 
			     },
			     {title: '소득세계산내역'
				 ,id: 'hrt501ukrTab04'			    	 
			     ,xtype:'container'
			     ,layout:{type:'vbox', align:'stretch'}
			     ,items:[search2] 
			     },
			     {title: '중간정산내역'
				 ,id: 'hrt501ukrTab05'			    	 
			     ,xtype:'container'
			     ,layout:{type:'vbox', align:'stretch'}
			     ,items:[masterGrid6] 
			     }
	    ],
	    listeners:{
	    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ){
	    		if(Ext.isObject(oldCard)){
	    			 if(UniAppManager.app._needSave()) {
	    				 
	    				 if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
	    					 UniAppManager.app.onSaveDataButtonDown();
							 this.setActiveTab(oldCard);	
	    				 } else {
	    					 Ext.Msg.alert("경고", "저장을 하셔야 합니다.");
	    					 return false;
	    				 }
	    				 
	    				 
	    				 /*
	    				 Ext.Msg.confirm('확인', Msg.sMB017 + '\n' + Msg.sMB061, function(btn){
 							if (btn == 'yes') {
 								UniAppManager.app.onSaveDataButtonDown();
 								this.setActiveTab(oldCard);	
 							} else {
 								Ext.Msg.alert("경고", "저장을 하셔야 합니다.");
//  								UniAppManager.setToolbarButtons('save',false);
//  								UniAppManager.app.loadTabData(newCard, newCard.getItemId());
 								return false;
 							}
 						});
	    				 */
	    				 
	    				 
	    			 }else {
	    				 if (!formLoad) {
	    					 //Ext.Msg.alert();
	    					 // tab 비활성화 상태임 메시지 표시를 하지 않음
	    					 return false;
	    				 // 폼 로드 후 탭을 변경시 최초 저장여부를 확인함	 
	    				 } else if (formLoad && !tab01Saved) {
	    					 // TODO: not change tab
// 	    					 Ext.Msg.alert("경고", "저장을 하셔야 합니다.");
// 	    				 	 return false;
							 // TODO:  form submit
							  /*
							 if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
		    					 UniAppManager.app.onSaveDataButtonDown();
								 this.setActiveTab(oldCard);	
		    				 } else {
		    					 Ext.Msg.alert("경고", "저장을 하셔야 합니다.");
		    					 return false;
		    				 }
							 */
							 
							///*
	    					 Ext.Msg.confirm('확인', Msg.sMB017 + '\n' + Msg.sMB061, function(btn){
    							if (btn == 'yes') {
    								var param = search1.getForm().getValues();
    								param.RETR_TYPE = panelSearch.getForm().findField('RETR_TYPE').getValue();
    								param.PERSON_NUMB = person_numb;
    								search1.getForm().submit({
    									 params : param,
    									 success : function(actionform, action) {
    										 	search1.getForm().wasDirty = false;
    										 	search1.resetDirtyStatus();									
    											UniAppManager.setToolbarButtons('save', false);
    											tab01Saved = true;
//    						            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
    									 }	
    								});
    								UniAppManager.app.loadTabData(newCard, newCard.getItemId());
    							} else {
    								Ext.Msg.alert("경고", "저장을 하셔야 합니다.");
    								return false;
    							}
    						});
    						//*/
    						
	    				 } else {
	    					 UniAppManager.app.loadTabData(newCard, newCard.getItemId());
	    				 }
	    			 }
	    		}
	    	}
	    }
	});
    

    Unilite.Main( {
		items : [panelSearch, tab, detailForm],
		id  : 'hrt501ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
// 			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
			setTabDisable(true);
		},
		onQueryButtonDown : function()	{				
			var activeTabId = tab.getActiveTab().getId();
			if (panelSearch.isValid()) {
				if (activeTabId == 'hrt501ukrTab01') {
					if (search1.isValid()) {
						setPanelReadOnly(true);
						UniAppManager.setToolbarButtons('reset',true);
						// tab01 form load
						var param = Ext.getCmp('searchForm').getValues();
						param.SUPP_DATE = Ext.getCmp('SUPP_DATE').rawValue.split('.').join('');
						param.RELOAD = 'N';
						search1.getForm().load({
							params : param,
							success: function(form, action){
							 	console.log(action);
							 	formLoad = true;
							 	setTabDisable(false);
							 	if (Ext.getCmp('OT_KIND').getValue().OT_KIND == 'ST') {
							 		tab.down('#hrt501ukrTab03').setDisabled(true);
							 	}
							 	// 특정필드를 입력 가능하게 변경
							 	search1.getForm().getFields().each(function(field) {
									if (field.name == 'RETR_ANNU_I' || field.name == 'GLORY_AMOUNT_I' || field.name == 'GROUP_INSUR_I' || field.name == 'OUT_INCOME_I' 
											|| field.name == 'ETC_AMOUNT_I' || field.name == 'DED_IN_TAX_ADD_I' || field.name == 'DED_IN_LOCAL_ADD_I' 
											|| field.name == 'DED_ETC_I' || field.name == 'RETR_RESN') {
										field.setReadOnly(false);	
									} else {
										field.setReadOnly(true);
									}
								});
							 	//하단 폼에 데이터를 입력
							 	detailForm.getForm().setValues(action.result.data);
							    // RETR_ANNU_I + GLORY_AMOUNT_I + GROUP_INSUR_I + ETC_AMOUNT_I
							    var RETR_SUM_I2 = action.result.data.RETR_ANNU_I + action.result.data.GLORY_AMOUNT_I + 
							    				action.result.data.GROUP_INSUR_I + action.result.data.ETC_AMOUNT_I;
							 	detailForm.getForm().setValues({ RETR_SUM_I2: RETR_SUM_I2});
							 
							 	// 첫 폼 로딩 후 탭 이동시 저장을 유도하기 위함
// 							 	search1.getForm().wasDirty = false;
//     							search1.resetDirtyStatus();
// 							 	UniAppManager.setToolbarButtons('save', true);
							 	
							},
							failure: function(form, action) {
								console.log(action);
								formLoad = false;
								setTabDisable(true);
							}
						});						
					} else {
						// invalid message
						var invalid = search1.getForm().getFields().filterBy(function(field) {
							return !field.validate();
						});
						if (invalid.length > 0) {
							r = false;
							var labelText = ''
				
							if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
								var labelText = invalid.items[0]['fieldLabel']
										+ '은(는)';
							} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
								var labelText = invalid.items[0].ownerCt['fieldLabel']
										+ '은(는)';
							}		
							Ext.Msg.alert('확인', labelText + Msg.sMB083);
							invalid.items[0].focus();
						}
					}
				} else {
					setPanelReadOnly(true);
					if(activeTabId == 'hrt501ukrTab02'){
						masterGrid1.getStore().loadStoreRecords();
						masterGrid2.getStore().loadStoreRecords();
						masterGrid3.getStore().loadStoreRecords();
						masterGrid4.getStore().loadStoreRecords();
						
						
						
						var view = masterGrid1.getView();
						view.getFeature('masterGridSubTotal').toggleSummaryRow(true);
						view.getFeature('masterGridTotal').toggleSummaryRow(true);
						
						
						
						
					} else if(activeTabId == 'hrt501ukrTab03'){
						masterGrid5.getStore().loadStoreRecords();
					} else if(activeTabId == 'hrt501ukrTab04'){
						search2.getForm().load({
							params : Ext.getCmp('searchForm').getValues(),
							success: function(form, action){
							 	console.log(action);
							},
							failure: function(form, action) {
								console.log(action);
							}
						});
					} else {
						masterGrid6.getStore().loadStoreRecords();
					}
				}
			} else {
				var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if (invalid.length > 0) {
					r = false;
					var labelText = ''
		
					if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']
								+ '은(는)';
					} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']
								+ '은(는)';
					}		
					Ext.Msg.alert('확인', labelText + Msg.sMB083);
					invalid.items[0].focus();
				}
			}
		},
		onResetButtonDown: function() {
			panelSearch.getForm().getFields().each(function(field) {
				field.setReadOnly(false);
			});
			panelSearch.getForm().setValues({'PERSON_NUMB' : ''});
			panelSearch.getForm().setValues({'NAME' : ''});
			panelSearch.getForm().setValues({'RETR_DATE' : ''});
			panelSearch.getForm().setValues({'RETR_TYPE' : ''});
			var activeTabId = tab.getActiveTab().getId();
			Ext.getCmp('SUPP_DATE').setValue('');
			UniAppManager.setToolbarButtons('reset', false);
			setTabDisable(true);
			// 데이터 삭제
			detailForm.getForm().getFields().each(function(field) {
				field.setValue('0');
			});
			search1.getForm().getFields().each(function(field) {
				if (field.name == 'JOIN_DATE' || field.name == 'RETR_DATE' || field.name == 'SUPP_DATE' || field.name == 'RETR_RESN' 
					|| field.name == 'YYYYMMDD' || field.name == 'LONG_TOT_DAY' || field.name == 'ADD_MONTH' 
					|| field.name == 'LONG_TOT_MONTH' || field.name == 'LONG_YEARS') {
					field.setReadOnly(false);
					field.setValue('');
				} else {
					field.setReadOnly(true);
					field.setValue('0');
				}
				Ext.getCmp('LONG_TOT_DAY').setReadOnly(true);
				Ext.getCmp('LONG_TOT_DAY').setValue('0');
				Ext.getCmp('LONG_YEARS').setValue('0');
				search1.getForm().findField('RETR_RESN').setValue('6');
				
			});
// 			search1.getForm().removeListener('dirtychange');
// 			search1.getForm().suspendEvent('dirtychange');
// 			search1.getForm().resumeEvent('dirtychange');
			formLoad = false;
			tab01Saved = false;
			UniAppManager.setToolbarButtons('save',false);
// 			search1.getForm().on({
// 				dirtychange: function(form, dirty, eOpts) {
// 					if (dirty) {
// 						UniAppManager.app.setToolbarButtons('save', true);
// 					} else {
// 						UniAppManager.app.setToolbarButtons('save', false);
// 					}
// 				}
// 			});
		},
		loadTabData: function(tab, itemId){
			if(tab.getId() == 'hrt501ukrTab01'){
				UniAppManager.setToolbarButtons('reset', true);
			} else {
				UniAppManager.setToolbarButtons('reset', false);
				if (tab.getId() == 'hrt501ukrTab02') {
					masterGrid1.getStore().loadStoreRecords();
					masterGrid2.getStore().loadStoreRecords();
					masterGrid3.getStore().loadStoreRecords();
					masterGrid4.getStore().loadStoreRecords();
					
					
// 					var viewNormal = masterGrid1.normalGrid.getView();
// 					console.log("viewLocked : ",viewLocked);
// 					console.log("viewNormal : ",viewNormal);
// 				    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
// 				    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
					
					
					
				} else if (tab.getId() == 'hrt501ukrTab03') {
					masterGrid5.getStore().loadStoreRecords();
				} else if (tab.getId() == 'hrt501ukrTab04') {
					search2.getForm().load({
						params : Ext.getCmp('searchForm').getValues(),
						success: function(form, action){
						 	console.log(action);
						},
						failure: function(form, action) {
							console.log(action);
						}
					});
				} else if (tab.getId() == 'hrt501ukrTab05') {
					masterGrid6.getStore().loadStoreRecords();
				}
			}
		},
		onNewDataButtonDown: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var record = {
					RETR_DATE: Ext.getCmp('RETR_DATE').getValue(),
					RETR_TYPE: Ext.getCmp('RETR_TYPE').getValue(),
					PERSON_NUMB: param.PERSON_NUMB,
					BONUS_TYPE: 'F',
					BONUS_NAME: '년차',
					SUPP_DATE: Ext.getCmp('SUPP_DATE').getValue()
			};
			masterGrid4.createRow(record);
			UniAppManager.setToolbarButtons('save', true);
		},  
		onDeleteDataButtonDown: function() {
			// 년월차 내역 그리드만 삭제가 가능함
			if (masterGrid4.getStore().getCount == 0) return;
			var selRow = masterGrid4.getSelectionModel().getSelection()[0];
			if (selRow.phantom === true)	{
				masterGrid4.deleteSelectedRow();
			} else {
				// 기존 행의 경우 삭제 하지 않음
				return false;
// 				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
// 					if (btn == 'yes') {
// 						masterGrid4.deleteSelectedRow();
// 						UniAppManager.app.setToolbarButtons('save', true);
// 					}
// 				});
			}
		}, 
		onSaveDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if (activeTabId == 'hrt501ukrTab01'){
				var person_numb = panelSearch.getForm().findField('PERSON_NUMB').getValue();
				if (person_numb == '') {
					Ext.Msg.alert('확인', '사번을 입력하십시오.');
					return false;
				} else {
					var param = search1.getForm().getValues();
					param.RETR_TYPE = panelSearch.getForm().findField('RETR_TYPE').getValue();
					param.PERSON_NUMB = person_numb;
					search1.getForm().submit({
						 params : param,
						 success : function(actionform, action) {
							 	search1.getForm().wasDirty = false;
							 	search1.resetDirtyStatus();									
								UniAppManager.setToolbarButtons('save', false);	
//			            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
						 }	
					});
					// 첫번째 탭에서는 저장 여부를 확인함
					tab01Saved = true;
				}
			} else if (activeTabId == 'hrt501ukrTab02') {
				if (masterGrid4.getStore().isDirty()) {
					masterGrid4.getStore().syncAll();
				}
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
    
    // 검색폼을 읽기상태로 만듬
    function setPanelReadOnly(readOnly){
    	panelSearch.getForm().getFields().each(function(field) {
			if (field.name != 'TAX_CALCU') {
				field.setReadOnly(readOnly);
			}
		});
    }
    
    //하위 탭의 이동가능 여부를 설정함
    function setTabDisable(disabled) {
    	tab.down('#hrt501ukrTab02').setDisabled(disabled);
//     	if (Ext.getCmp('OT_KIND').getValue() == 'OF') {
//     		tab.down('#hrt501ukrTab03').setDisabled(isTrue);
//     	}
		tab.down('#hrt501ukrTab03').setDisabled(disabled);
		tab.down('#hrt501ukrTab04').setDisabled(disabled);
		tab.down('#hrt501ukrTab05').setDisabled(disabled);
    }
    
    // 산정내역탭에서의  그리드 클릭시 추가, 삭제 버튼의 활성화 여부를 결정함
    function setButtonState(enable) {
    	if (enable) {
    		UniAppManager.setToolbarButtons('newData', true);
    		if (masterGrid4.getStore().getCount() > 0) {
    			UniAppManager.setToolbarButtons('delete', true);	
    		} else {
    			UniAppManager.setToolbarButtons('delete', false);
    		}
    	} else {
    		UniAppManager.setToolbarButtons('newData', false);
    		UniAppManager.setToolbarButtons('delete', false);
    	}
    }
    
    // 지급총액 계산
    function fnSuppTotI() {
    	var retrAnnu = 0;
    	var stxtGloryAmountI = 0; 
    	var stxtGroupInsurI = 0;
    	var stxtOutIncomeI = 0;
    	var sEtcAmount = 0;
    	var sOFPayAnnuI = 0 ;
    	
    	//퇴직금
    	var RETR_ANNU_I = search1.getForm().findField('RETR_ANNU_I').getValue();
    	if (RETR_ANNU_I != 0) {
    		retrAnnu = RETR_ANNU_I;
    	}
    	//명예퇴직지급
    	var GLORY_AMOUNT_I = search1.getForm().findField('GLORY_AMOUNT_I').getValue();
    	if (GLORY_AMOUNT_I != 0) {
    		stxtGloryAmountI = GLORY_AMOUNT_I;
    	}
    	//퇴직보험금
    	var GROUP_INSUR_I = search1.getForm().findField('GROUP_INSUR_I').getValue();
    	if (GROUP_INSUR_I != 0) {
    		stxtGroupInsurI = GROUP_INSUR_I;
    	}
    	//비과세소득
    	var OUT_INCOME_I = search1.getForm().findField('OUT_INCOME_I').getValue();
    	if (OUT_INCOME_I != 0) {
    		stxtOutIncomeI = OUT_INCOME_I;
    	}
    	//기타지급
    	var ETC_AMOUNT_I = search1.getForm().findField('ETC_AMOUNT_I').getValue();
    	if (ETC_AMOUNT_I != 0) {
    		sEtcAmount = ETC_AMOUNT_I;
    	}

    	//지급총액
    	var RETR_SUM_I = search1.getForm().findField('RETR_SUM_I').getValue();
    	
    	var RETR_SUM_I2 = Ext.getCmp('RETR_SUM_I2').getValue();
    	Ext.getCmp('RETR_SUM_I').setValue(retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount);
    	Ext.getCmp('RETR_SUM_I2').setValue(retrAnnu + stxtGloryAmountI + stxtGroupInsurI + sEtcAmount);
    	Ext.getCmp('RETR_SUM_I3').setValue(retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount);
    	// 영수증 데이터
    	search1.getForm().findField('R_ANNU_TOTAL_I').setValue(retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount);
    	search1.getForm().findField('R_TAX_TOTAL_I').setValue(retrAnnu + stxtGloryAmountI + stxtGroupInsurI + sEtcAmount);
    	
    	var param = search1.getForm().getValues();
		param.RETR_TYPE = panelSearch.getForm().findField('RETR_TYPE').getValue();
		param.PERSON_NUMB = panelSearch.getForm().findField('PERSON_NUMB').getValue();
		search1.getForm().submit({
			 params : param,
			 success : function(actionform, action) {
				 	search1.getForm().wasDirty = false;
				 	search1.resetDirtyStatus();									
					UniAppManager.setToolbarButtons('save', false);	
//            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
			 }	
		});
    	
    	//검색 조건 파라미터
    	var param= Ext.getCmp('searchForm').getValues();
    	// 전송용 파라미터
    	var params = new Object();
    	params.S_COMP_CODE = UserInfo.compCode;
    	params.PERSON_NUMB = param.PERSON_NUMB;
    	params.RETR_DATE = param.RETR_DATE; // 정산일
    	params.RETR_TYPE = param.RETR_TYPE; // 정산구분
    	params.TAX_CALCU = param.TAX_CALCU; // 세액계산여부
    	params.R_CALCU_END_DATE = search1.getForm().findField('R_CALCU_END_DATE').getValue(); // 최종분-기산일
    	params.S_LONG_YEARS = search1.getForm().findField('S_LONG_YEARS').getValue(); // 정산(합산)근속연수
    	params.LONG_YEARS_BE13 = search1.getForm().findField('LONG_YEARS_BE13').getValue(); // 2013이전근속연수
    	params.LONG_YEARS_AF13 = search1.getForm().findField('LONG_YEARS_AF13').getValue(); // 2013이후근속연수
    	params.PAY_END_TAX = detailForm.getForm().findField('PAY_END_TAX').getValue(); // 기납부세액 
    	params.R_ANNU_TOTAL_I = search1.getForm().findField('R_ANNU_TOTAL_I').getValue(); // 최종분-퇴직급여
    	params.OUT_INCOME_I = search1.getForm().findField('OUT_INCOME_I').getValue(); // 최종분-퇴직급여(비과세)
    	params.M_ANNU_TOTAL_I = search1.getForm().findField('M_ANNU_TOTAL_I').getValue(); // 중도정산-퇴직급여 
    	params.M_OUT_INCOME_I = search1.getForm().findField('M_OUT_INCOME_I').getValue(); // 중도정산-퇴직급여 (비과세)
    	params.DED_IN_TAX_ADD_I = search1.getForm().findField('DED_IN_TAX_ADD_I').getValue(); // 소득세환급액
    	params.DED_IN_LOCAL_ADD_I = search1.getForm().findField('DED_IN_LOCAL_ADD_I').getValue(); // 주민세환급액
    	params.DED_ETC_I = search1.getForm().findField('DED_ETC_I').getValue(); // 기타공제
    	
    	console.log(params);
    	
    	Ext.Ajax.request({
			url: CPATH+'/human/fnSuppTotI.do',
			params: params,
			success: function(response){
				data = Ext.decode(response.responseText);
				console.log(data);
				// returnvalue = 1
				var param = Ext.getCmp('searchForm').getValues();
				param.SUPP_DATE = Ext.getCmp('SUPP_DATE').rawValue.split('.').join('');
				param.RELOAD = 'Y';
				// 폼을 리로드 함
				search1.getForm().load({
					params : param,
					success: function(form, action){
					 	console.log(action);
					 	//하단 폼에 데이터를 입력
					 	detailForm.getForm().setValues(action.result.data);
					    // RETR_ANNU_I + GLORY_AMOUNT_I + GROUP_INSUR_I + ETC_AMOUNT_I
					    var RETR_SUM_I2 = action.result.data.RETR_ANNU_I + action.result.data.GLORY_AMOUNT_I + 
					    				action.result.data.GROUP_INSUR_I + action.result.data.ETC_AMOUNT_I;
					 	detailForm.getForm().setValues({ RETR_SUM_I2: RETR_SUM_I2});
					 	
					 	//근로소득 간주액
				    	var PAY_ANNU_I = search1.getForm().findField('PAY_ANNU_I').getValue();
				    	if (PAY_ANNU_I != 0) {
				    		sOFPayAnnuI = PAY_ANNU_I;
				    	}
				    	
				    	// 최종분퇴직급여 재계산 
				    	search1.getForm().findField('R_ANNU_TOTAL_I').setValue( retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount - sOFPayAnnuI );
				    	search1.getForm().findField('R_TAX_TOTAL_I').setValue( retrAnnu + stxtGloryAmountI + stxtGroupInsurI + sEtcAmount - sOFPayAnnuI );
				    
				    	// 폼 서브밋을 위한 히든 필드에 계산된 값을 집어 넣음
				    	search1.getForm().findField('M_TAX_TOTAL_I').setValue(detailForm.getForm().findField('M_TAX_TOTAL_I').getValue());
				    	search1.getForm().findField('PAY_ANNU_I').setValue(detailForm.getForm().findField('PAY_ANNU_I').getValue());
				    	search1.getForm().findField('REAL_AMOUNT_I').setValue(detailForm.getForm().findField('REAL_AMOUNT_I').getValue());
					},
					failure: function(form, action) {
						console.log(action);
					}
				});	
			},
			failure: function(response){
				console.log(response);
			}
		});
    
    }
    
    // 공제총액 계산
    function fnDedTotI() {
    	var inTax = 0; 
    	var localTax = 0; 
    	var etcAmount2 = 0; 
    	var groupInsur2 = 0; 
    	var gloryAmount2 = 0;
    	
    	// 소득세
    	var IN_TAX_I = search1.getForm().findField('IN_TAX_I').getValue();
    	if (IN_TAX_I != 0) {
    		inTax = IN_TAX_I;
    	}
    	// 지방소득세
    	var LOCAL_TAX_I = search1.getForm().findField('LOCAL_TAX_I').getValue();
    	if (LOCAL_TAX_I != 0) {
    		localTax = LOCAL_TAX_I;
    	}
    	// 소득세 환급액
    	var DED_IN_TAX_ADD_I = search1.getForm().findField('DED_IN_TAX_ADD_I').getValue();
    	if (DED_IN_TAX_ADD_I != 0) {
    		etcAmount2 = DED_IN_TAX_ADD_I;
    	}
    	// 주민세 환급액
    	var DED_IN_LOCAL_ADD_I = search1.getForm().findField('DED_IN_LOCAL_ADD_I').getValue();
    	if (DED_IN_LOCAL_ADD_I != 0) {
    		groupInsur2 = DED_IN_LOCAL_ADD_I;
    	}
    	// 기타공제
    	var DED_ETC_I = search1.getForm().findField('DED_ETC_I').getValue();
    	if (DED_ETC_I != 0) {
    		gloryAmount2 = DED_ETC_I;
    	}
    	
    	//공제총액
        search1.getForm().findField('DED_TOTAL_I').setValue(inTax + localTax + etcAmount2 + groupInsur2 + gloryAmount2);
    	Ext.getCmp('DED_TOTAL_I2').setValue(inTax + localTax + etcAmount2 + groupInsur2 + gloryAmount2);
        //실지급액
        Ext.getCmp('REAL_AMOUNT_I').setValue( Ext.getCmp('RETR_SUM_I3').getValue() - Ext.getCmp('DED_TOTAL_I2').getValue() );
        
     	// 폼 서브밋을 위한 히든 필드에 계산된 값을 집어 넣음
        search1.getForm().findField('M_TAX_TOTAL_I').setValue(detailForm.getForm().findField('M_TAX_TOTAL_I').getValue());
    	search1.getForm().findField('PAY_ANNU_I').setValue(detailForm.getForm().findField('PAY_ANNU_I').getValue());
    	search1.getForm().findField('REAL_AMOUNT_I').setValue(detailForm.getForm().findField('REAL_AMOUNT_I').getValue());
    	
    }

};
</script>
