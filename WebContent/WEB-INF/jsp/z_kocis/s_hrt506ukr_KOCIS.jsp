<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hrt506ukr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="H053" opts="M;R"/> <!--정산구분-->
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
	//2.산정내역 (급여내역 모델)
	Unilite.defineModel('Hrt506ukrModel1', {
		fields: [ {name: 'RETR_DATE'			,text:'퇴사일'		,type:'uniDate'}
				 ,{name: 'RETR_TYPE'			,text:'구분'			,type:'string'}
				 ,{name: 'PERSON_NUMB'			,text:'사번'			,type:'string'}
				 ,{name: 'PAY_YYYYMM'			,text:'급여년월'		,type:'string', editable:false}
				 ,{name: 'WAGES_CODE'			,text:'수당코드'		,type:'string'}
				 ,{name: 'WAGES_NAME'			,text:'지급구분'		,type:'string', editable:false}
				 ,{name: 'AMOUNT_I'				,text:'금액'			,type:'uniPrice'}
				 ,{name: 'PAY_STRT_DATE'		,text:'급여평균시작일'	,type:'string'}
				 ,{name: 'PAY_LAST_DATE'		,text:'급여평균종료일'	,type:'string'}
				 ,{name: 'WAGES_DAY'			,text:'급여일수'		,type:'string'}
			]
	});	
	
	//2.산정내역 (기타수당내역 모델)
	Unilite.defineModel('Hrt506ukrModel2', {
		fields: [ {name: 'RETR_DATE'			,text:'퇴사일'		,type:'uniDate'}
				 ,{name: 'RETR_TYPE'			,text:'구분'			,type:'string'}
				 ,{name: 'PERSON_NUMB'			,text:'사번'			,type:'string'}
				 ,{name: 'PAY_YYYYMM'			,text:'급여년월'		,type:'string', editable:false}
				 ,{name: 'WEL_CODE'				,text:'수당코드'		,type:'string'}
				 ,{name: 'WEL_NAME'				,text:'지급구분'		,type:'string', editable:false}
				 ,{name: 'GIVE_I'				,text:'금액'			,type:'uniPrice'}
				 ,{name: 'WEL_LEVEL1'			,text:'소득산입종류'	,type:'string'}
				 ,{name: 'WEL_LEVEL2'			,text:'비과세코드'		,type:'string'}
				 ,{name: 'APPLY_YYMM'			,text:'기준년월'		,type:'uniDate'}
				 ,{name: 'PAY_STRT_DATE'		,text:'급여평균시작일'	,type:'string'}
				 ,{name: 'PAY_LAST_DATE'		,text:'급여평균종료일'	,type:'string'}
				 ,{name: 'WAGES_DAY'			,text:'급여일수'		,type:'string'}
			]
	});
	
	//2.산정내역 (상여내역 모델)
	Unilite.defineModel('Hrt506ukrModel3', {
		fields: [ {name: 'RETR_DATE'			,text:'퇴사일'		,type:'uniDate'}
				 ,{name: 'RETR_TYPE'			,text:'구분'			,type:'string'}
				 ,{name: 'PERSON_NUMB'			,text:'사번'			,type:'string'}
				 ,{name: 'BONUS_YYYYMM'			,text:'상여년월'		,type:'string', editable:false}
				 ,{name: 'BONUS_TYPE'			,text:'상여구분'		,type:'string'}
				 ,{name: 'BONUS_NAME'			,text:'상여구분'		,type:'string', editable:false}
				 ,{name: 'BONUS_I'				,text:'금액'			,type:'uniPrice'}
				 ,{name: 'BONUS_RATE'			,text:'상여율'		,type:'uniER'}
			]
	});
	
	//2.산정내역 (년월차내역 모델)
	Unilite.defineModel('Hrt506ukrModel4', {
		fields: [ {name: 'RETR_DATE'			,text:'퇴사일'		,type:'uniDate'}
				 ,{name: 'RETR_TYPE'			,text:'구분'			,type:'string'}
				 ,{name: 'PERSON_NUMB'			,text:'사번'			,type:'string'}
				 ,{name: 'BONUS_YYYYMM'			,text:'년월차년월'		,type:'string'}//, editable:false}
				 ,{name: 'BONUS_TYPE'			,text:'년월차구분'		,type:'string'}
				 ,{name: 'BONUS_NAME'			,text:'년월차구분'		,type:'string'}//, editable:false}
				 ,{name: 'BONUS_I'				,text:'금액'			,type:'uniPrice'}
				 ,{name: 'SUPP_DATE'			,text:'지급일'		,type:'uniDate'}
				 ,{name: 'BONUS_RATE'			,text:'상여율'		,type:'uniER'}
			]
	});


	
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	//2.산정내역
	var masterStore1 = Unilite.createStore('hrt506ukrMasterStore1',{
		model: 'Hrt506ukrModel1',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 (임시로 수정 안되게 변경)
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				   read: 's_hrt506ukrService_KOCIS.selectList01'					
			}
		},
		loadStoreRecords : function()	{	
			var param		= Ext.getCmp('searchForm').getValues();	
			param.WORK_TYPE	= '2'
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'PAY_YYYYMM'
	});
	
	var masterStore2 = Unilite.createStore('hrt506ukrMasterStore1',{
		model: 'Hrt506ukrModel2',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 (임시로 수정 안되게 변경)
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				   read: 's_hrt506ukrService_KOCIS.selectList02'					
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
			
	var masterStore3 = Unilite.createStore('hrt506ukrMasterStore3',{
		model: 'Hrt506ukrModel3',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 (임시로 수정 안되게 변경)
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt506ukrService_KOCIS.selectList03'					
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
	
	var masterStore4 = Unilite.createStore('hrt506ukrMasterStore4',{
		model: 'Hrt506ukrModel4',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 (임시로 수정 안되게 변경)
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				create: 's_hrt506ukrService_KOCIS.insertList04',
				read: 's_hrt506ukrService_KOCIS.selectList04',
				update: 's_hrt506ukrService_KOCIS.updateList04',
				syncAll: 's_hrt506ukrService_KOCIS.syncAll'
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


	
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		width		: 380,
		items		: [{	
				title: '기본정보', 	
		   		itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
				items: [
				 	Unilite.popup('Employee',{ 	
					fieldLabel		: '직원',
					allowBlank		: false,			
					validateBlank	: true,
					listeners		: {
						onSelected: {
						},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);				
						}
					}
				}), {
					fieldLabel	: '정산구분',
					name		: 'RETR_TYPE',
//					id			: 'RETR_TYPE',
					xtype		: 'uniCombobox', 
					comboType	: 'AU',
					comboCode	: 'H053',
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('RETR_TYPE', newValue);
						}
					}
				}, {
					fieldLabel	: '정산일',
					name		: 'RETR_DATE',
//					id			: 'RETR_DATE',
					xtype		: 'uniDatefield',
					allowBlank	: false, 
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('RETR_DATE', newValue);
						}
					}
				}
			]}
		]
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [
		 	Unilite.popup('Employee',{
			fieldLabel		: '직원',
			validateBlank	: true,
			allowBlank		: false,
			labelWidth		: 118,
			listeners		: {
				onSelected: {
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}), {
			fieldLabel	: '정산구분',
			name		: 'RETR_TYPE',
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'H053',
			allowBlank	: false,
			labelWidth	: 118,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('RETR_TYPE', newValue);
				}
			}
		}, {
			fieldLabel	: '정산일',
			name		: 'RETR_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false, 
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RETR_DATE', newValue);
				}
			}
		}/*, {
			text	: '퇴직금 재계산 TEST',
			xtype: 'button',
			name: 'test',
			id: 'test',
			width: 200,	
			handler : function() {
				fnRetireProcSTChangedPayment();
			}
		}*/
	]});


	
	
	
	/** 탭 : 1. 정산내역 입력 panel
	 */
	var search1 = Unilite.createSearchForm('search1',{	
		xtype		: 'container',
		autoScroll	: true,
		border		: false,
		padding		: '5 7 0 7',
 		flex		: 1,
		api			: {
			load	: 's_hrt506ukrService_KOCIS.selectFormData01',
			submit	: 's_hrt506ukrService_KOCIS.submitFormData01'
		},
		trackResetOnLoad: true,
		layout		:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},		
		items		: [{
			xtype: 'container',
			layout: {type: 'uniTable', columns:8/*,  tdAttrs: {style: 'border : 1px solid #ced9e7;', valign:'top'}*/},
			items: [{
				 xtype: 'container',				
				 html:'<b>■ 근속내역 (현지화)</b>',
				 tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'left'},
				 colspan: 8,
				 margin: '0 0 5 0'
			}, {
				xtype		: 'uniDatefield',
				fieldLabel	: '정산시작일',
				name		: 'JOIN_DATE',
				id			: 'JOIN_DATE',
				labelWidth	: 110,
				colspan		: 2
			}, {
				xtype		: 'uniDatefield',
				fieldLabel	: '정산(퇴직)일',
				name		: 'RETR_DATE',
				id			: 'RETR_DATE',
				labelWidth	: 110,
				colspan		: 2
			}, {
				fieldLabel	: '지급일',
				xtype		: 'uniDatefield',
				name		: 'SUPP_DATE',
				id			: 'SUPP_DATE',
				allowBlank	: false,
				labelWidth	: 110,
				colspan		: 2
			}, {
				fieldLabel	: '사유',	
				xtype		: 'uniCombobox', 
				name		: 'RETR_RESN', 
				id			: 'RETR_RESN', 
				comboType	:'AU',
				comboCode	: 'H168',
				value		: '6',
				allowBlank: false,
				labelWidth: 110,
				colspan: 2
			}, {
				xtype		: 'uniTextfield',
				fieldLabel	: '근속기간(년/월/일)',
				name		: 'YYYYMMDD',
				id			: 'YYYYMMDD',
				labelWidth	: 110,
				colspan		: 2,
				fieldStyle	: "text-align:right;"
			}, {
				xtype		: 'uniNumberfield',
				fieldLabel	: '근속일수',
				name		: 'LONG_TOT_DAY1',
				id			: 'LONG_TOT_DAY1',
				labelWidth	: 110,
				value		: '0',
				colspan		: 2
			}, {
				xtype		: 'container',
				defaultType	: 'uniNumberfield',
				layout		: {type: 'hbox', align: 'stretch'},
				width		: 300,
				margin		: 0,				
				colspan		: 2,
				items		: [{
					fieldLabel	: '누진/근속월수',
					labelWidth	: 110,
					name		: 'ADD_MONTH',
					id			: 'ADD_MONTH',
					width		: 200
				}, {
				 	fieldLabel	: '/',
					name		: 'LONG_TOT_MONTH',
					id			: 'LONG_TOT_MONTH',
					labelWidth	: 10,
					width		: 65
				}]
			}, {
				xtype			: 'uniTextfield',
				fieldLabel		: '근속년수',
				name			: 'LONG_YEARS',
				id				: 'LONG_YEARS',
				value			: '0',
				labelWidth		: 110,
				width			: 230,
				fieldStyle		: "text-align:right;",
				colspan			: 2
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '근속년',
				name		: 'DUTY_YYYY'
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '근속월',
				name		: 'LONG_MONTH'
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '근속일',
				name		: 'LONG_DAY'
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '3개월총일수',
				name		: 'AVG_DAY'
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '급여총액',
				name		: 'PAY_TOTAL_I'
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '상여총액',
				name		: 'BONUS_TOTAL_I'
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '년월차총액',
				name		: 'YEAR_TOTAL_I'
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '퇴직소득정률공제',
				name		: 'SPEC_DED_I'
			},{
				xtype: 'hiddenfield',
				fieldLabel: '근속연수공제',
				name: 'INCOME_DED_I'
			},{ // 영수증
				xtype		: 'hiddenfield',
				fieldLabel	: '(15)퇴직급여_최종',
				name		: 'R_ANNU_TOTAL_I'
			},{ // 영수증
				xtype		: 'hiddenfield',
				fieldLabel	: '(17)과세대상 퇴직급여(15-16)_최종',
				name		: 'R_TAX_TOTAL_I'
			},{ // 영수증
				xtype		: 'hiddenfield',
				fieldLabel	: '(15)퇴직급여_중간',
				name		: 'M_ANNU_TOTAL_I'
			},{ // 영수증
				xtype		: 'hiddenfield',
				fieldLabel	: '(16)비과세 퇴직급여_중간',
				name		: 'M_OUT_INCOME_I'
			},{ // 영수증
				xtype		: 'hiddenfield',
				fieldLabel	: '정산(합산)근속연수',
				name		: 'S_LONG_YEARS'
			},{ // 영수증
				xtype		: 'hiddenfield',
				fieldLabel	: '2013이전근속연수',
				name		: 'LONG_YEARS_BE13'
			},{ // 영수증
				xtype		: 'hiddenfield',
				fieldLabel	: '2013이후근속연수',
				name		: 'LONG_YEARS_AF13'
			},{ // 영수증
				xtype		: 'hiddenfield',
				fieldLabel	: '최종분-기산일',
				name		: 'R_CALCU_END_DATE'
			} // 이하 form submit용 hidden field -> detailForm내부의 field
			,{ 
				xtype		: 'hiddenfield',
				fieldLabel	: '중도정산(과세대상)(B)',
				name		: 'M_TAX_TOTAL_I'
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '근로소득간주액(C)',
				name		: 'PAY_ANNU_I'
			},{
				xtype		: 'hiddenfield',
				fieldLabel	: '실지급액',
				name		: 'REAL_AMOUNT_I'
			}]			
		},{
			xtype: 'container',	
			margin: '10 0 0 0',
			layout: {
				type: 'table',
				columns:4,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', align : 'center'}

			},
			defaults:{width: '97.5%', margin: '2 2 2 2'},
			items: [
				{ xtype: 'component',  html:'퇴직금계산내역', colspan: 2, tdAttrs: {height: 29}},
				{ xtype: 'component',  html:'지급내역', colspan: 2},
								
				{ xtype: 'component',  html:'3개월급여'},
				{ xtype: 'uniNumberfield', value: 0, name: 'AVG_PAY_3'/* , suffixTpl: '원' */, readOnly: true/*, fieldCls: 'no-border-text-field'*/},
				{ xtype: 'component',  html:'퇴직급여'},
				{ xtype: 'uniNumberfield', value: 0, name: 'RETR_ANNU_I'/* , suffixTpl: '원' */,
					listeners: {
						blur: function( field, The, eOpts )	{
//							fnSuppTotI();
						}
					}
				},
					
				{ xtype: 'component',  html:'3개월상여'},
				{ xtype: 'uniNumberfield', value: 0, name: 'AVG_BONUS_I_3'/* , suffixTpl: '원' */, readOnly: true},
				{ xtype: 'component',  html:'명예퇴직금'},
				{ xtype: 'uniNumberfield', value: 0, name: 'GLORY_AMOUNT_I'/* , suffixTpl: '원' */,
					listeners: {
						blur: function( field, The, eOpts )	{
//							fnSuppTotI();
						}
					}
				},
				
				{ xtype: 'component',  html:'3개월년차'},
				{ xtype: 'uniNumberfield', value: 0, name: 'AVG_YEAR_I_3'/* , suffixTpl: '원' */, readOnly: true},
				{ xtype: 'component',  html:'퇴직보험금'},
				{ xtype: 'uniNumberfield', value: 0, name: 'GROUP_INSUR_I'/* , suffixTpl: '원' */,
					listeners: {
						blur: function( field, The, eOpts )	{
//							fnSuppTotI();
						}
					}
				},
				
				{ xtype: 'component',  html:'합계'},
				{ xtype: 'uniNumberfield', value: 0, name: 'TOT_WAGES_I'/* , suffixTpl: '원' */, readOnly: true},
				{ xtype: 'component',  html:'비과세소득'},
				{ xtype: 'uniNumberfield', value: 0, name: 'OUT_INCOME_I'/* , suffixTpl: '원' */,
					listeners: {
						blur: function( field, The, eOpts )	{
//							fnSuppTotI();
						}
					}
				},
				
				{ xtype: 'component',  html:'평균임금'},
				{ xtype: 'uniNumberfield', value: 0, name: 'AVG_WAGES_I'/* , suffixTpl: '원' */, readOnly: true},
				{ xtype: 'component',  html:'기타지급'},
				{ xtype: 'uniNumberfield', value: 0, name: 'ETC_AMOUNT_I'/* , suffixTpl: '원' */,
					listeners: {
						blur: function( field, The, eOpts )	{
//							fnSuppTotI();
						}
					}
				},
				
				{ xtype: 'component',  html:'근속일수'},
				{ xtype: 'uniNumberfield', name: 'LONG_TOT_DAY2', readOnly: true, fieldStyle: "text-align:right;"}, 
				{ xtype: 'component',  html:'지급총액'},
				{ xtype: 'uniNumberfield', value: 0, name: 'RETR_SUM_I'/* , suffixTpl: '원' */, readOnly: true},
				
				{ xtype: 'component',  html:'퇴직급여'},
				{ xtype: 'uniNumberfield', value: 0, name: 'ORI_RETR_ANNU_I'/* , suffixTpl: '원' */, readOnly: true},
				{ xtype: 'component',  html:'근로소득간주액'},				
				{ xtype: 'uniNumberfield', value: 0, name: ''/* , suffixTpl: '원' */, readOnly: true}
			]			
		}], 
		listeners: {
			actioncomplete: function(form, action) {
				// dirty change 이벤트 , load 후 
				search1.getForm().on({
					dirtychange: function(form, dirty, eOpts) {
						if (dirty && formLoad) {
							UniAppManager.app.setToolbarButtons('save', true);

						} else {
							UniAppManager.app.setToolbarButtons('save', false);
						}
					}
				});
			}
		}
	});
	
	/** 탭 : 3.소득세계산내역 입력 panel (사용 안 함)
	 */
	var search2 = Unilite.createSearchForm('search2',{	
		autoScroll: true,
		border: false,
		padding: '5 7 0 7',
		xtype: 'container',
 		flex: 1,
		api: {
			load: 's_hrt506ukrService_KOCIS.selectFormData02'
		},
		trackResetOnLoad: true,
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},		
		items: [{
			xtype: 'container',
			margin: '10 0 0 0',
			layout: {
				type: 'table',
				columns:6,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
			},
			defaults:{width: '98.5%', margin: '2 2 2 2'},
			items: [
				{ xtype: 'component',  html:'2015.12.31 이전 계산 내역', colspan: 6, tdAttrs: {height: 29}},
				
				{ xtype: 'component',  html:'과세내역', colspan: 2, tdAttrs: {height: 29}},
				{ xtype: 'component',  html:'법정퇴직'},
				{ xtype: 'component',  html:'산출산식', colspan: 3 },
				
				{ xtype: 'component',  html:'퇴직급여액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'A'},
				{ xtype: 'component',  html:'퇴직급여액 과세소득', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'퇴직소득공제', rowspan: 6, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 15%', align : 'center'}},
				{ xtype: 'component',  html:'소득공제(ⓐ)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 15%', align : 'center'}},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'B', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 15%', align : 'center'}},
				{ xtype: 'component',  html:'2011년 귀속부터 퇴직급여액의 40%', colspan: 3, style: 'text-align:left'},
		
				{ xtype: 'component',  html:'근속연수별공제(ⓑ)', rowspan: 4},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'C'},
				{ xtype: 'component',  html:'&nbsp;&nbsp;5년이하', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%', align : 'center'}},
				{ xtype: 'component',  html:'&nbsp;&nbsp;30만 * 근속연수', colspan: 2, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%', align : 'center'}},
				
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'D'},
				{ xtype: 'component',  html:'&nbsp;&nbsp;10년이하', style: 'text-align:left'},
				{ xtype: 'component',  html:'&nbsp;&nbsp;150만 + {50만 * (근속연수 - 5)}', colspan: 2, style: 'text-align:left'},
				
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'E'},
				{ xtype: 'component',  html:'&nbsp;&nbsp;20년이하', style: 'text-align:left'},
				{ xtype: 'component',  html:'&nbsp;&nbsp;400만 + {80만 * (근속연수 - 10)}', colspan: 2, style: 'text-align:left'},
				
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'F'},
				{ xtype: 'component',  html:'&nbsp;&nbsp;20년초과', style: 'text-align:left'},
				{ xtype: 'component',  html:'&nbsp;&nbsp;1,200만 + {120만 * (근속연수 - 20)}', colspan: 2, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'계 ((ⓐ) + (ⓑ))'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'G'},
				{ xtype: 'component',  html:'소득공제(ⓐ) + 근속연수별공제(ⓑ)', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'과세표준', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'H'},
				{ xtype: 'component',  html:'퇴직급여액 - 퇴직소득공제', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'연평균과세표준', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'I'},
				{ xtype: 'component',  html:'과세표준 / 세법상근속연수', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'연평균산출세액', rowspan: 5},
				{ xtype: 'component',  html:'1천 2백만원 이하'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'J'},
				{ xtype: 'component',  html:'6%', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'4천 6백만원 이하'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'K'},
				{ xtype: 'component',  html:'72만 + {(연평균과세표준 - 1,200만) * 15%}', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'8천 6백만원 이하'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'L'},
				{ xtype: 'component',  html:'582만 + {(연평균과세표준 - 4,600만) * 24%}', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'3억 이하'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'M'},
				{ xtype: 'component',  html:'1,590만 + {(연평균과세표준 - 8,800만) * 35%}', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'3억 초과'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'N'},
				{ xtype: 'component',  html:'9,010만 + {(연평균과세표준 - 3억) * 38%}', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'산출세액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'O'},
				{ xtype: 'component',  html:'연평균산출세액 * 세법상근속연수', colspan: 3, style: 'text-align:left'},
				
				
				{ xtype: 'component',  html:'2016.01.01 이후 계산 내역 == 퇴직급여액, 근속연수별공제 금액은 2015.12.31 이전 계산내역 참조', colspan: 6, tdAttrs: {height: 29}},
				
				{ xtype: 'component',  html:'환산급여', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'P'},
				{ xtype: 'component',  html:'((정산퇴직소득 - 근속연수공제) / 정산근속연수) * 12배', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'환산급여별공제', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'Q'},
				{ xtype: 'component',  html:'환산급여별공제 프로그램에서 내용 확인 : 기준금액 + ((환산급여 - 기준금액) * 세율)', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'퇴직소득과세표준', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'R'},
				{ xtype: 'component',  html:'환산급여 - 환산급여별공제', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'환산산출세액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'S'},
				{ xtype: 'component',  html:'퇴직소득과세표준 * 종합소득세율', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'산출세액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'T'},
				{ xtype: 'component',  html:'(환산산출세액 / 12배) * 정산근속연수', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'특례적용산출세액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'V'},
				{ xtype: 'component',  html:'(2015.12.31 이전의 산출세액 * 80%) + (2016.01.01 이후 산출세액 * 20%)', colspan: 3, style: 'text-align:left'},
				
				{ xtype: 'component',  html:'신고대상액', colspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'W'},
				{ xtype: 'component',  html:'특례적용산출세액 - 기납부(또는 기과세이연) 세액 == 소득세', colspan: 3, style: 'text-align:left'}				
			]			
		}]
	});

	/** 공통 데이터 view panel (아랫쪽) */
	var detailForm = Unilite.createSimpleForm('detailForm', {
		xtype	: 'container',
		region	: 'south',
		layout	: {type: 'uniTable', columns:8},
		items	: [{
			 xtype: 'container',
			 html:'<b>■ 퇴직금 산출액 및 산출 세액</b>',
			 tdAttrs: {style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'left'},
			 colspan: 8,
			 margin: '30 0 0 6'
		}, {
			xtype: 'container',
			margin: '5 0 0 0',
			padding: '5 7 20 7',
			layout: {
				type: 'table',
				columns:6,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
				tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', align : 'center'}
			},
			defaults:{width: '98.5%', margin: '2 2 2 2'},
			items: [
				{ xtype: 'component', html:'지급총액(과세대상)(A)', rowspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, rowspan: 2, name: 'RETR_SUM_I2', id: 'RETR_SUM_I2'},
				{ xtype: 'component', html:'중도정산(과세대상)(B)'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'M_TAX_TOTAL_I'},
				{ xtype: 'component', html:'과세대상 퇴직급여</br>(A) + (B) - (C)', rowspan: 2},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, rowspan: 2, name: 'SUPP_TOTAL_I3'},
				
				
				{ xtype: 'component', html:'근로소득간주액(C)'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'PAY_ANNU_I'},
				
				
				{ xtype: 'component', html:'산출세액'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'COMP_TAX_I'},
				{ xtype: 'component', html:'기납부세액'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'PAY_END_TAX'},
				{ xtype: 'component', html:'결정세액'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'DEF_TAX_I'},
				
				
				{ xtype: 'component', html:'지급총액'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'RETR_SUM_I', id: 'RETR_SUM_I3'},
				{ xtype: 'component', html:'공제총액'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'DED_TOTAL_I', id: 'DED_TOTAL_I2'},
				{ xtype: 'component', html:'실지급액'},
				{ xtype: 'uniNumberfield', value:'0'/* , suffixTpl: '원' */, readOnly:true, name: 'REAL_AMOUNT_I', id: 'REAL_AMOUNT_I'}
			]			
		}]
	});


	
	
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	//2.산정내역 탭 grid1
	var masterGrid1 = Unilite.createGrid('hrt506ukrGrid1', {
		title: '급여내역',
		layout : 'fit',		
		store: masterStore1,
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
			id: 'masterGridSubTotal1',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal1', 	
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		flex: 1,
		columns:  [  { dataIndex:'RETR_DATE'	, hidden: true }
					,{ dataIndex:'RETR_TYPE'	, hidden: true }
					,{ dataIndex:'PERSON_NUMB'	, hidden: true }
					,{ dataIndex:'PAY_YYYYMM'	, width: 100, summaryType: 'totaltext',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
					}}
					,{ dataIndex:'WAGES_CODE'	, hidden: true }
					,{ dataIndex:'WAGES_NAME'	, width: 130}
					,{ dataIndex:'AMOUNT_I'		, minWidth: 120, flex: 1, summaryType: 'sum'}
					,{ dataIndex:'PAY_STRT_DATE', hidden: true }
					,{ dataIndex:'PAY_LAST_DATE', hidden: true }
					,{ dataIndex:'WAGES_DAY'	, hidden: true }
		  ],
		  listeners: {
				containerclick: function() {
					setButtonState(false);
				},
				select: function() {
					setButtonState(false);
				}, 
				cellclick: function() {
					setButtonState(false);
				}
		  } 
	});
	
	//2.산정내역 탭 grid2
	var masterGrid2 = Unilite.createGrid('hrt506ukrGrid2', {
		// for tab 
		title: '기타수당내역',
		layout : 'fit',		
		store: masterStore2,
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
			id: 'masterGridSubTotal2',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal2', 	
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		flex: 1,
		columns:  [  { dataIndex:'RETR_DATE'	, hidden: true }
					,{ dataIndex:'RETR_TYPE'	, hidden: true }
					,{ dataIndex:'PERSON_NUMB'	, hidden: true }
					,{ dataIndex:'PAY_YYYYMM'	, width: 100, summaryType: 'totaltext',
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
					}}
					,{ dataIndex:'WEL_CODE'		, hidden: true }
					,{ dataIndex:'WEL_NAME'		, width: 130}
					,{ dataIndex:'GIVE_I'		, minWidth: 120, flex: 1, summaryType: 'sum'}
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
			}, 
			select: function() {
				setButtonState(false);
			}, 
			cellclick: function() {
				setButtonState(false);
			}
	  }  
	});
	
	//2.산정내역 탭 grid3
	var masterGrid3 = Unilite.createGrid('hrt506ukrGrid3', {
		// for tab 
		title: '상여내역',
		layout : 'fit',		
		store: masterStore3,
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
			id: 'masterGridSubTotal3',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal3', 	
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		flex: 1,
		columns:  [  { dataIndex:'RETR_DATE'	, hidden: true }
					,{ dataIndex:'RETR_TYPE'	, hidden: true }
					,{ dataIndex:'PERSON_NUMB'	, hidden: true }
					,{ dataIndex:'BONUS_YYYYMM'	, summaryType: 'totaltext', width: 100,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
					}}
					,{ dataIndex:'BONUS_TYPE'	, hidden: true }
					,{ dataIndex:'BONUS_NAME'	, width: 130}
					,{ dataIndex:'BONUS_I'		, minWidth: 120, flex: 1, summaryType: 'sum'}
					,{ dataIndex:'BONUS_RATE'	, hidden: true }
		],
		  listeners: {
				containerclick: function() {
					setButtonState(false);
				}, 
				select: function() {
					setButtonState(false);
				}, 
				cellclick: function() {
					setButtonState(false);
				}
		  } 
	});
	
	//2.산정내역 탭 grid4
	var masterGrid4 = Unilite.createGrid('hrt506ukrGrid4', {
		// for tab 
		title: '년월차내역',
		layout : 'fit',		
		store: masterStore4,
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
			id: 'masterGridSubTotal4',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal4', 	
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		flex: 1,
		columns:  [  { dataIndex:'RETR_DATE'	, hidden: true }
					,{ dataIndex:'RETR_TYPE'	, hidden: true }
					,{ dataIndex:'PERSON_NUMB'	, hidden: true }
					,{ dataIndex:'BONUS_YYYYMM'	, summaryType: 'totaltext', width: 100,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
					}}
					,{ dataIndex:'BONUS_TYPE'	, hidden: true }
					,{ dataIndex:'BONUS_NAME'	, width: 130}
					,{ dataIndex:'BONUS_RATE'	, hidden: true}
					,{ dataIndex:'BONUS_I'		, minWidth: 120, flex: 1, summaryType: 'sum'}
					,{ dataIndex:'SUPP_DATE'	, hidden: true }
					,{ dataIndex:'BONUS_RATE'	, hidden: true }
		],
		listeners: {
			containerclick: function() {
				setButtonState(true);
			}, 
			select: function() {
				setButtonState(true);
			}, 
			cellclick: function() {
				setButtonState(true);
			}, 
			beforeedit: function(editor, e) {
				//update시 금액만 수정이 가능하도록함
				if (!e.record.phantom && !e.field == 'BONUS_I') {
					return false;
				}
			}, 
			edit: function(editor, e) {
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


	
	
	
	var tab = Unilite.createTabPanel('tabPanel',{
		id			: 'tab',
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
			title		: '정산내역',
			id			: 'hrt506ukrTab01',
			layout		: {type:'vbox', align:'stretch'} ,
			items		: [search1],
			autoScroll	: true
		},{
			title		: '산정내역',
			id			: 'hrt506ukrTab02',
			xtype		: 'container',
			layout		: {type:'hbox', align:'stretch'},
			items		: [masterGrid1, masterGrid2, masterGrid3, masterGrid4] 
		 },{
		 	title		: '소득세계산내역',
		 	id			: 'hrt506ukrTab04',
		 	layout		: {type:'vbox', align:'stretch'},
		 	items		: [search2],
			autoScroll	: true,
		 	hidden		: true
		}],
		listeners:{
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ){
				if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
				 
				if(UniAppManager.app._needSave()) {
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
										UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
								 }	
							});
							UniAppManager.app.loadTabData(newCard, newCard.getItemId());
						} else {
							Ext.Msg.alert("경고", "저장을 하셔야 합니다.");
							return false;
						}
					});
				 }
//					var activeTabId = tab.getActiveTab().getId(); 
				if (newCard.getId() == 'hrt506ukrTab01') {
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
							 	/*if (panelSearch.getField('OT_KIND').getValue().OT_KIND == 'ST') {
							 		tab.down('#hrt506ukrTab03').setDisabled(true);
							 	}*/
							 	// 특정필드를 입력 가능하게 변경
							 	search1.getForm().getFields().each(function(field) {
//									if (field.name == 'RETR_ANNU_I' || field.name == 'GLORY_AMOUNT_I' || field.name == 'GROUP_INSUR_I' || field.name == 'OUT_INCOME_I' 
//											|| field.name == 'ETC_AMOUNT_I' 
//											|| field.name == 'DED_ETC_I' || field.name == 'RETR_RESN') {
//										field.setReadOnly(false);	
//									} else {
										field.setReadOnly(true);
//									}
								});
							 	//하단 폼에 데이터를 입력
							 	detailForm.getForm().setValues(action.result.data);
								// RETR_ANNU_I + GLORY_AMOUNT_I + GROUP_INSUR_I + ETC_AMOUNT_I
								var RETR_SUM_I2 = action.result.data.RETR_ANNU_I + action.result.data.GLORY_AMOUNT_I + 
												action.result.data.GROUP_INSUR_I + action.result.data.ETC_AMOUNT_I;
							 	detailForm.getForm().setValues({ RETR_SUM_I2: RETR_SUM_I2});
							 
							 	// 첫 폼 로딩 후 탭 이동시 저장을 유도하기 위함
// 							 	search1.getForm().wasDirty = false;
//	 							search1.resetDirtyStatus();
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
					if(newCard.getId() == 'hrt506ukrTab02'){
						masterGrid1.getStore().loadStoreRecords();
						masterGrid2.getStore().loadStoreRecords();
						masterGrid3.getStore().loadStoreRecords();
						masterGrid4.getStore().loadStoreRecords();
						
						var view1 = masterGrid1.getView();
						var view2 = masterGrid2.getView();
						var view3 = masterGrid3.getView();
						var view4 = masterGrid4.getView();
						view1.getFeature('masterGridSubTotal1').toggleSummaryRow(true);
						view1.getFeature('masterGridTotal1').toggleSummaryRow(true);
//						view2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
						view2.getFeature('masterGridTotal2').toggleSummaryRow(true);
//						view3.getFeature('masterGridSubTotal3').toggleSummaryRow(true);
						view3.getFeature('masterGridTotal3').toggleSummaryRow(true);
//						view4.getFeature('masterGridSubTotal4').toggleSummaryRow(true);
						view4.getFeature('masterGridTotal4').toggleSummaryRow(true);
						
					} else if(newCard.getId() == 'hrt506ukrTab04'){
						search2.getForm().load({
							params : Ext.getCmp('searchForm').getValues(),
							success: function(form, action){
							 	console.log(action);
							},
							failure: function(form, action) {
								console.log(action);
							}
						});
					} 
				}
			}
		}
	});


	
	
	
	Unilite.Main( {
		id			: 's_hrt506ukrApp',
		borderItems : [{
		 	region	:'center',
		 	layout	: 'border',
		 	border	: false,
		 	items	: [
		   		panelResult, tab, detailForm
			]	
		},
		panelSearch	 
		],
		fnInitBinding : function(params) {			
			panelSearch.setValue('RETR_TYPE', 'R');
			panelSearch.setValue('RETR_DATE', UniDate.get('today'));
			
			panelResult.setValue('RETR_TYPE', 'R');
			panelResult.setValue('RETR_DATE', UniDate.get('today'));
			;
			UniAppManager.setToolbarButtons('reset',false);
//			tab.down('#hrt506ukrTab03').setDisabled(true);
//			setTabDisable(true);
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
				UniAppManager.app.onQueryButtonDown();
			}
		},
		
		onQueryButtonDown : function()	{				
			if(!this.isValidSearchForm()) {
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();
			//1.정산내역
			if (activeTabId == 'hrt506ukrTab01') {
				setPanelReadOnly(true);
				UniAppManager.setToolbarButtons('reset',true);
				
				search1.uniOpt.inLoading = true;
				// tab01 form load
				var param = Ext.getCmp('searchForm').getValues();
				param.SUPP_DATE = UniDate.getDbDateStr(Ext.getCmp('SUPP_DATE').getValue());
				param.WORK_TYPE	= '1';			//'1' : 정산내역, '2' : 산정내역 (미사용 -  '3' : 산정내역(임원), '4' : 소득세계산내역, '5' : 중간정산내역)
				param.RELOAD = 'N';
				search1.getForm().load({
					params : param,
					success: function(form, action){
					 	console.log(action);
					 	formLoad = true;
					 	setTabDisable(false);

					 	//조회조건 필드 비활성화
					 	panelSearch.getForm().getFields().each(function(field) {
							field.setReadOnly(true);
						});
					 	panelResult.getForm().getFields().each(function(field) {
							field.setReadOnly(true);
						});
					 	
					 	// 특정필드를 입력 가능하게 변경
					 	search1.getForm().getFields().each(function(field) {
//							if (field.name == 'RETR_ANNU_I' || field.name == 'GLORY_AMOUNT_I' || field.name == 'GROUP_INSUR_I' || field.name == 'OUT_INCOME_I' 
//									|| field.name == 'ETC_AMOUNT_I' 
//									|| field.name == 'DED_ETC_I' || field.name == 'RETR_RESN') {
//								field.setReadOnly(false);	
//							} else {
								field.setReadOnly(true);
//							}
						});

						//하단 폼에 데이터를 입력
					 	detailForm.getForm().setValues(action.result.data);
						// RETR_ANNU_I + GLORY_AMOUNT_I + GROUP_INSUR_I + ETC_AMOUNT_I
						var RETR_SUM_I2 = action.result.data.RETR_ANNU_I + action.result.data.GLORY_AMOUNT_I + 
										action.result.data.GROUP_INSUR_I + action.result.data.ETC_AMOUNT_I;
					 	detailForm.getForm().setValues({ RETR_SUM_I2: RETR_SUM_I2});
					 
					 	// 첫 폼 로딩 후 탭 이동시 저장을 유도하기 위함
// 							 	search1.getForm().wasDirty = false;
//	 							search1.resetDirtyStatus();
// 							 	UniAppManager.setToolbarButtons('save', true);
					 	
						search1.uniOpt.inLoading = false;
					 	UniAppManager.setToolbarButtons('delete', true);
					},
					failure: function(form, action) {
						console.log(action);
						formLoad = false;
						setTabDisable(true);
						
						search1.uniOpt.inLoading = false;
					}
				});		
				
			} else {
				setPanelReadOnly(true);
				
				//2.산정내역
				if(activeTabId == 'hrt506ukrTab02'){
					masterGrid1.getStore().loadStoreRecords();
					masterGrid2.getStore().loadStoreRecords();
					masterGrid3.getStore().loadStoreRecords();
					masterGrid4.getStore().loadStoreRecords();
					
					var view1 = masterGrid1.getView();
					var view2 = masterGrid2.getView();
					var view3 = masterGrid3.getView();
					var view4 = masterGrid4.getView();
					view1.getFeature('masterGridSubTotal1').toggleSummaryRow(true);
					view1.getFeature('masterGridTotal1').toggleSummaryRow(true);
					view2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
					view2.getFeature('masterGridTotal2').toggleSummaryRow(true);
					view3.getFeature('masterGridSubTotal3').toggleSummaryRow(true);
					view3.getFeature('masterGridTotal3').toggleSummaryRow(true);
					view4.getFeature('masterGridSubTotal4').toggleSummaryRow(true);
					view4.getFeature('masterGridTotal4').toggleSummaryRow(true);
					
					
				//3.소득세계산내역
				}  else if(activeTabId == 'hrt506ukrTab04'){
					search2.getForm().load({
						params : Ext.getCmp('searchForm').getValues(),
						success: function(form, action){
						 	console.log(action);
						},
						failure: function(form, action) {
							console.log(action);
						}
					});
				}
			}
		},
		
		onResetButtonDown: function() {
		 	//조회조건 필드 초기화
			panelSearch.getForm().getFields().each(function(field) {
				field.setReadOnly(false);
			});
		 	panelResult.getForm().getFields().each(function(field) {
				field.setReadOnly(false);
			});
			
			//조회조건 필드 초기값 설정
			panelSearch.getForm().setValues({'PERSON_NUMB' : ''});
			panelSearch.getForm().setValues({'NAME' : ''});
			panelSearch.setValue('RETR_TYPE', 'R');
			panelSearch.setValue('RETR_DATE', UniDate.get('today'));
			
			panelResult.getForm().setValues({'PERSON_NUMB' : ''});
			panelResult.getForm().setValues({'NAME' : ''});
			panelResult.setValue('RETR_TYPE', 'R');
			panelResult.setValue('RETR_DATE', UniDate.get('today'));
			
			var activeTabId = tab.getActiveTab().getId();
			Ext.getCmp('SUPP_DATE').setValue('');
			UniAppManager.setToolbarButtons('reset', false);
			setTabDisable(true);
			// 데이터 초기화
			detailForm.getForm().getFields().each(function(field) {
				field.setValue('0');
			});
			search1.getForm().getFields().each(function(field) {
				if (field.name == 'JOIN_DATE' || field.name == 'RETR_DATE' || field.name == 'SUPP_DATE' || field.name == 'RETR_RESN' 
					|| field.name == 'YYYYMMDD' || field.name == 'LONG_TOT_DAY1' || field.name == 'ADD_MONTH' || field.name == 'LONG_TOT_MONTH'
					|| field.name == 'LONG_YEARS') {
					field.setReadOnly(false);
					field.setValue('');
				
				} else if (field.name == 'RETR_ANNU_I' || field.name == 'GLORY_AMOUNT_I' || field.name == 'GROUP_INSUR_I' || field.name == 'OUT_INCOME_I' || field.name == 'ETC_AMOUNT_I') {
					field.setReadOnly(false);
					field.setValue(0);
					
				} else {
					field.setReadOnly(true);
					field.setValue('0');
				}
//				Ext.getCmp('LONG_TOT_DAY1').setReadOnly(false);
				Ext.getCmp('LONG_TOT_DAY1').setValue('0');
				Ext.getCmp('LONG_YEARS').setValue('0');
				search1.getForm().findField('RETR_RESN').setValue('6');
			});
// 			search1.getForm().removeListener('dirtychange');
// 			search1.getForm().suspendEvent('dirtychange');
// 			search1.getForm().resumeEvent('dirtychange');
			formLoad = false;
			tab01Saved = false;
			
			UniAppManager.setToolbarButtons('delete', false);
			UniAppManager.setToolbarButtons('save'	, false);

			masterGrid1.getStore().loadStoreRecords({});
			masterGrid2.getStore().loadStoreRecords({});
			masterGrid3.getStore().loadStoreRecords({});
			masterGrid4.getStore().loadStoreRecords({});
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
			//1.정산내역
			if(tab.getId() == 'hrt506ukrTab01'){
				UniAppManager.setToolbarButtons('reset', true);
				
			} else {
				UniAppManager.setToolbarButtons('reset', false);

				//2.산정내역
				if (tab.getId() == 'hrt506ukrTab02') {
					masterGrid1.getStore().loadStoreRecords();
					masterGrid2.getStore().loadStoreRecords();
					masterGrid3.getStore().loadStoreRecords();
					masterGrid4.getStore().loadStoreRecords();
					
				//3.소득세계산내역
				} else if (tab.getId() == 'hrt506ukrTab04') {
					search2.getForm().load({
						params : Ext.getCmp('searchForm').getValues(),
						success: function(form, action){
						 	console.log(action);
						},
						failure: function(form, action) {
							console.log(action);
						}
					});
				}
			}
		},
		
		onNewDataButtonDown: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var record = {
					RETR_DATE: panelSearch.getValue('RETR_DATE'),
					RETR_TYPE: panelSearch.getValue('RETR_TYPE'),
					PERSON_NUMB: param.PERSON_NUMB,
					BONUS_TYPE: 'F',
					BONUS_NAME: '년차',
					SUPP_DATE: Ext.getCmp('SUPP_DATE').getValue()
			};
			masterGrid4.createRow(record);
			UniAppManager.setToolbarButtons('save', true);
		},  
		
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			//1.정산내역
			if (activeTabId == 'hrt506ukrTab01') {

				if(confirm('해당 데이터를 삭제 하시겠습니까?')) {
					var param = {
						S_COMP_CODE : UserInfo.compCode,
						RETR_DATE	: UniDate.getDbDateStr(panelSearch.getValue('RETR_DATE')),
						RETR_TYPE	: panelSearch.getValue('RETR_TYPE'),
						PERSON_NUMB	: panelSearch.getValue('PERSON_NUMB')
					}
					s_hrt506ukrService_KOCIS.deleteFromData01(param, function(provider, response){
						if(provider == 0) {
							UniAppManager.app.onResetButtonDown();
							UniAppManager.setToolbarButtons('delete', false);
							UniAppManager.setToolbarButtons('save'	, false);
						}
					});
				}
				
			} else {
				// 년월차 내역 그리드만 삭제가 가능함
				if (masterGrid4.getStore().getCount == 0) {
					alert("삭제할 데이터가 없습니다.");
					return false;
				}
				
				var selRow = masterGrid4.getSelectionModel().getSelection()[0];
				if ((!Ext.isEmpty(selRow)) && selRow.phantom === true)	{
					masterGrid4.deleteSelectedRow();
					
				} else {
					// 기존 행의 경우 삭제 하지 않음
					alert('기존에 등록된 데이터는 삭제할 수 없습니다.');
					return false;
				}
			}
		}, 
		
		onSaveDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if (activeTabId == 'hrt506ukrTab01'){
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
								UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
						 }	
					});
					// 첫번째 탭에서는 저장 여부를 확인함
					tab01Saved = true;
				}
				
			} else if (activeTabId == 'hrt506ukrTab02') {
				if (masterGrid4.getStore().isDirty()) {
					masterGrid4.getStore().syncAll();
				}
			}
		},

        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 's_hrt700skr_KOCIS') {
				panelSearch.setValue('PERSON_NUMB'	, params.PERSON_NUMB);
				panelSearch.setValue('NAME'			, params.NAME);
				panelSearch.setValue('RETR_TYPE'	, params.RETR_TYPE);
				panelSearch.setValue('RETR_DATE'	, params.RETR_DATE);
				
				panelResult.setValue('PERSON_NUMB'	, params.PERSON_NUMB);
				panelResult.setValue('NAME'			, params.NAME);
				panelResult.setValue('RETR_TYPE'	, params.RETR_TYPE);
				panelResult.setValue('RETR_DATE'	, params.RETR_DATE);
			}
        }
	});


	
	// 검색폼을 읽기상태로 만듬
	function setPanelReadOnly(readOnly){
		panelSearch.getForm().getFields().each(function(field) {
//			if (field.name != 'TAX_CALCU') {
//				field.setReadOnly(readOnly);
//			}
		});
	}


	
	//하위 탭의 이동가능 여부를 설정함
	function setTabDisable(disabled) {
		tab.down('#hrt506ukrTab02').setDisabled(disabled);
		tab.down('#hrt506ukrTab04').setDisabled(disabled);
	}


	
	// 산정내역 탭에서의 그리드 클릭시 추가, 삭제 버튼의 활성화 여부를 결정함
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


	
	// 급여/기타수당/상여/년월차 변경시 퇴직급여 재계산 (///////////////추후 진행)
	function fnRetireProcSTChangedPayment() {
		//변수 선언, 변수값 설정
		var dAvgPay3, dAvgEtc3, dAvgBonusI3, dAvgYearI3, dLongTotDay;

		dAvgPay3	= masterStore1.sumBy(function(record, id){ return true;}, ['AMOUNT_I']).AMOUNT_I;		//급여내역 합계 (급여총액)
		dAvgEtc3	= masterStore2.sumBy(function(record, id){ return true;}, ['GIVE_I']).GIVE_I;			//기타수당 합계
		dAvgBonusI3	= masterStore3.sumBy(function(record, id){ return true;}, ['BONUS_I']).BONUS_I;		//상세내역 합계
		dAvgYearI3	= masterStore4.sumBy(function(record, id){ return true;}, ['BONUS_I']).BONUS_I;		//년월차 합계
		dLongTotDay	= search1.getValue('LONG_TOT_DAY2');								//근속일수
		
		//search1 Field에 값 설정
		search1.setValue('PAY_TOTAL_I'		, dAvgPay3 + dAvgEtc3);						//급여총액
		search1.setValue('BONUS_TOTAL_I'	, dAvgBonusI3);								//상여총액
		search1.setValue('YEAR_TOTAL_I'		, dAvgYearI3);								//년월차총액
		
		search1.setValue('AVG_PAY_3'		, dAvgPay3 + dAvgEtc3);						//3개월급여
		search1.setValue('AVG_BONUS_I_3'	, dAvgBonusI3 / 4);							//3개월상여
		search1.setValue('AVG_YEAR_I_3'		, dAvgYearI3 / 4);							//3개월년차
		
		//합계
		search1.setValue('TOT_WAGES_I'		, search1.getValue('AVG_PAY_3') + search1.getValue('AVG_BONUS_I_3') + search1.getValue('AVG_YEAR_I_3'));
		//평균임금
		search1.setValue('AVG_WAGES_I'		, parseInt(search1.getValue('TOT_WAGES_I') / 3));		
		
		var param	= {
			S_COMP_CODE 		: UserInfo.compCode,
			PERSON_NUMB			: panelSearch.getValue('PERSON_NUMB'),			//사번
			RETR_TYPE			: panelSearch.getValue('RETR_TYPE'),			//정산구분
			R_CALCU_END_DATE	: search1.getValue('R_CALCU_END_DATE'),			//최종분-기산일
			RETR_DATE			: UniDate.getDbDateStr(search1.getValue('RETR_DATE')),
																				//지급일
			dAvgPay3			: dAvgPay3,										//급여총액
			dAvgEtc3			: dAvgEtc3, 									//기타수당 총액
			AVG_BONUS_I_3		: search1.getValue('AVG_BONUS_I_3'),			//3개월상여
			AVG_YEAR_I_3		: search1.getValue('AVG_YEAR_I_3'),				//3개월년차
			LONG_TOT_DAY		: search1.getValue('LONG_TOT_DAY'),				//근속일수
			LONG_TOT_MONTH		: search1.getValue('LONG_TOT_MONTH'),			//근속월수
			LONG_YEARS			: search1.getValue('LONG_YEARS'),				//근속년수
			LONG_MONTH			: search1.getValue('LONG_MONTH'),				//근속월
			LONG_DAY			: search1.getValue('LONG_DAY'),					//근속일
			DUTY_YYYY			: search1.getValue('DUTY_YYYY'),				//근속년
			INCOME_DED_I		: search1.getValue('INCOME_DED_I')				//근속년수공제
			
		}
		s_hrt506ukrService_KOCIS.fnRetireProcSTChangedPayment(param, function(provider, response){
		});
		
	}
	
	// 지급총액 계산
	function fnSuppTotI() {
		var retrAnnu			= 0;
		var stxtGloryAmountI	= 0; 
		var stxtGroupInsurI		= 0;
		var stxtOutIncomeI		= 0;
		var sEtcAmount			= 0;
		var sOFPayAnnuI			= 0 ;
		
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

		search1.setValue('RETR_SUM_I' , retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount);
		search1.setValue('RETR_SUM_I2', retrAnnu + stxtGloryAmountI + stxtGroupInsurI + sEtcAmount);
		search1.setValue('RETR_SUM_I3', retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount);

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
//					UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
			 }	
		});
		
		//검색 조건 파라미터
		var param= Ext.getCmp('searchForm').getValues();
		// 전송용 파라미터
		var params = new Object();
		params.S_COMP_CODE		= UserInfo.compCode;
		params.PERSON_NUMB		= param.PERSON_NUMB;
		params.RETR_DATE		= param.RETR_DATE;												// 정산일
		params.RETR_TYPE		= param.RETR_TYPE;												// 정산구분
		params.R_CALCU_END_DATE	= search1.getForm().findField('R_CALCU_END_DATE').getValue();	// 최종분-기산일
		params.S_LONG_YEARS		= search1.getForm().findField('S_LONG_YEARS').getValue(); 		// 정산(합산)근속연수
		params.LONG_YEARS_BE13	= search1.getForm().findField('LONG_YEARS_BE13').getValue(); 	// 2013이전근속연수
		params.LONG_YEARS_AF13	= search1.getForm().findField('LONG_YEARS_AF13').getValue(); 	// 2013이후근속연수
		params.PAY_END_TAX		= detailForm.getForm().findField('PAY_END_TAX').getValue(); 	// 기납부세액 
		params.R_ANNU_TOTAL_I	= search1.getForm().findField('R_ANNU_TOTAL_I').getValue();		// 최종분-퇴직급여
		params.OUT_INCOME_I		= search1.getForm().findField('OUT_INCOME_I').getValue(); 		// 최종분-퇴직급여(비과세)
		params.M_ANNU_TOTAL_I	= search1.getForm().findField('M_ANNU_TOTAL_I').getValue();		// 중도정산-퇴직급여 
		params.M_OUT_INCOME_I	= search1.getForm().findField('M_OUT_INCOME_I').getValue();		// 중도정산-퇴직급여 (비과세)
		params.SUPP_TOT_I		= 'Y';															// 계산을 위한 조회일 경우 메세지 생략하기 위해 FLAG 넘김
//		params.TAX_CALCU		= param.TAX_CALCU;												// 세액계산여부
//		params.DED_IN_TAX_ADD_I	= search1.getForm().findField('DED_IN_TAX_ADD_I').getValue();	// 소득세환급액
//		params.DED_IN_LOCAL_ADD_I = search1.getForm().findField('O').getValue();				// 주민세환급액
//		params.DED_ETC_I		= search1.getForm().findField('DED_ETC_I').getValue();			// 기타공제
		
		console.log(params);
		
		Ext.Ajax.request({
			url: CPATH+'/z_kocis/fnSuppTotI.do',
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


	
/*	// 공제총액 계산
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
		실지급액
		Ext.getCmp('REAL_AMOUNT_I').setValue( Ext.getCmp('RETR_SUM_I3').getValue() - Ext.getCmp('DED_TOTAL_I2').getValue() );
		
	 	// 폼 서브밋을 위한 히든 필드에 계산된 값을 집어 넣음
		search1.getForm().findField('M_TAX_TOTAL_I').setValue(detailForm.getForm().findField('M_TAX_TOTAL_I').getValue());
		search1.getForm().findField('PAY_ANNU_I').setValue(detailForm.getForm().findField('PAY_ANNU_I').getValue());
		search1.getForm().findField('REAL_AMOUNT_I').setValue(detailForm.getForm().findField('REAL_AMOUNT_I').getValue());
	}
*/
};
</script>
