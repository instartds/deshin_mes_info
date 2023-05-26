<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum550skr_kd">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="HX08" />					<!-- 성별 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의 
	 * @type 
	 */
	////////그리드 컬럼 가져오는 명 화면과 일치하지 않음 - 쿼리에서 조회하는 컬럼을 일단 다 적어놨음 : 추후 필요한 것만 사용, 누락된 것은 추가해야 함 (박재범부장님 휴가)
	////////<<재직구분>>  현재 sp에 재직구분 관련 로직 누락 (박재범부장님 휴가) - SP 수정 후, 재직구분 위치 확인하여 xml에서 주석풀고 위치만 맞추면 됨
	//1: 남성
	Unilite.defineModel('s_hum550skr_kdModel1', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'PERSON_RANK'		,text: '순위'				,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민등록번호'		,type: 'string'},
			{name: 'ORG_NAME'			,text: '최종학력'			,type: 'string'},
			{name: 'GRAD_GUBUN_NAME'	,text: '최종학력'			,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일'			,type: 'string'},
			{name: 'WORK_YMD'			,text: '근속일'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위코드'			,type: 'string'},
			{name: 'POST_NAME'			,text: '직위명'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'PROMOTION_DATE1'	,text: '승진일자'			,type: 'string'},
			{name: 'PROMOTION_YMD'		,text: '승진년수'			,type: 'string'},
			{name: 'PROMOTION_DATE2'	,text: '최종승급일자'			,type: 'string'},
			{name: 'PAY_GRADE_01'		,text: '호봉(급)'			,type: 'string'},
			{name: 'PAY_GRADE_01_NAME'	,text: '호봉(급)명'		,type: 'string'},
			{name: 'PAY_GRADE_03'		,text: '호봉(직)'			,type: 'string'},
			{name: 'PAY_GRADE_04'		,text: '호봉(기)'			,type: 'string'},
			{name: 'WAGES_AMT_01'		,text: '기본급'  			,type: 'uniPrice'},
			{name: 'WAGES_AMT_02'		,text: '시간외'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_03'		,text: '직책수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_04'		,text: '기술수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_05'		,text: '가족수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_06'		,text: '생산장려'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_07'		,text: '반장수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_08'		,text: '연구수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_09'		,text: '기타수당1'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_10'		,text: '기타수당2'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_11'		,text: '운전수당'			,type: 'uniPrice'},
			{name: 'WAGES_AMT_12'		,text: '연수수당'			,type: 'uniPrice'},
			{name: 'AF_WAGES_AMT_TOT'	,text: '합계'				,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_01'	,text: '기본급'  			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_02'	,text: '시간외'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_03'	,text: '직책수당'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_04'	,text: '기술수당'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_05'	,text: '가족수당'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_06'	,text: '생산장려'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_07'	,text: '반장수당'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_08'	,text: '연구수당'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_09'	,text: '기타수당1'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_10'	,text: '기타수당2'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_11'	,text: '운전수당'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_12'	,text: '연수수당'			,type: 'uniPrice'},
			{name: 'BE_WAGES_AMT_TOT'	,text: '합계'				,type: 'uniPrice'}
		]
	});
	
//	//2: 여성
//	Unilite.defineModel('s_hum550skr_kdModel2', {
//		fields: [
//			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
//			{name: 'PERSON_RANK'		,text: '순위'				,type: 'string'},
//			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
//			{name: 'PERSON_NAME'		,text: '성명'				,type: 'string'},
//			{name: 'REPRE_NUM'			,text: '주민등록번호'		,type: 'string'},
//			{name: 'ORG_NAME'			,text: '최종학력'			,type: 'string'},
//			{name: 'GRAD_GUBUN_NAME'	,text: '최종학력'			,type: 'string'},
//			{name: 'JOIN_DATE'			,text: '입사일'			,type: 'string'},
//			{name: 'WORK_YMD'			,text: '근속일'			,type: 'string'},
//			{name: 'POST_CODE'			,text: '직위코드'			,type: 'string'},
//			{name: 'POST_NAME'			,text: '직위명'			,type: 'string'},
//			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
//			{name: 'PROMOTION_DATE1'	,text: '승진일'			,type: 'string'},
//			{name: 'PROMOTION_YMD'		,text: '근속일'			,type: 'string'},
//			{name: 'PROMOTION_DATE2'	,text: '승진일'			,type: 'string'},
//			{name: 'PAY_GRADE_01'		,text: '호봉(급)'			,type: 'string'},
//			{name: 'PAY_GRADE_01_NAME'	,text: '호봉(급)명'		,type: 'string'},
//			{name: 'PAY_GRADE_03'		,text: '호봉(직)'			,type: 'string'},
//			{name: 'PAY_GRADE_04'		,text: '호봉(기)'			,type: 'string'},
//			{name: 'WAGES_AMT_01'		,text: '기본급'  			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_02'		,text: '시간외'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_03'		,text: '직책수당'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_04'		,text: '기술수당'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_05'		,text: '가족수당'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_06'		,text: '생산장려'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_07'		,text: '반장수당'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_08'		,text: '연구수당'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_09'		,text: '기타수당1'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_10'		,text: '기타수당2'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_11'		,text: '운전수당'			,type: 'uniPrice'},
//			{name: 'WAGES_AMT_12'		,text: '연수수당'			,type: 'uniPrice'},
//			{name: 'AF_WAGES_AMT_TOT'	,text: '합계'				,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_01'	,text: '기본급'  			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_02'	,text: '시간외'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_03'	,text: '직책수당'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_04'	,text: '기술수당'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_05'	,text: '가족수당'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_06'	,text: '생산장려'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_07'	,text: '반장수당'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_08'	,text: '연구수당'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_09'	,text: '기타수당1'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_10'	,text: '기타수당2'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_11'	,text: '운전수당'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_12'	,text: '연수수당'			,type: 'uniPrice'},
//			{name: 'BE_WAGES_AMT_TOT'	,text: '합계'				,type: 'uniPrice'}
//		]
//	});
//	

	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	//1: 남성		
	var masterStore1 = Unilite.createStore('s_hum550skr_kdMasterStore1',{
		model	: 's_hum550skr_kdModel1',
		uniOpt	: {
			isMaster	: true,				// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {			
					read: 's_hum550skr_kdService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//1: 남성 flag
			param.WORK_GUBUN = 'A'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid1.getStore().getCount();  
				if(count > 0){
					Ext.getCmp('GW1').setDisabled(false);
				}else{
					Ext.getCmp('GW1').setDisabled(true);
				}

			}
		}
	});
	
//	//2: 여성	
//	var masterStore2 = Unilite.createStore('s_hum550skr_kdMasterStore2',{
//		model	: 's_hum550skr_kdModel2',
//		uniOpt	: {
//			isMaster	: true,				// 상위 버튼 연결 
//			editable	: false,			// 수정 모드 사용 
//			deletable	: false,			// 삭제 가능 여부 
//			useNavi		: false				// prev | newxt 버튼 사용
//		},
//		autoLoad: false,
//		proxy	: {
//			type: 'direct',
//			api: {			
//					read: 's_hum550skr_kdService.selectList'
//			}
//		},
//		loadStoreRecords : function()	{
//			var param= Ext.getCmp('panelResultForm').getValues();
//			//2: 여성 flag
//			param.WORK_GUBUN = 'A'
//			console.log( param );
//			this.load({
//				params : param
//			});
//		},
//		listeners: {
//			load: function(store, records, successful, eOpts) {
//				var count = masterGrid2.getStore().getCount();  
//				if(count > 0){
//					Ext.getCmp('GW2').setDisabled(false);
//				}else{
//					Ext.getCmp('GW2').setDisabled(true);
//				}
//
//			}
//		}
//	});
//	

	
	
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
                fieldLabel  : '입사일',    
                xtype       : 'uniDateRangefield',
                startFieldName    : 'ST_DATE_FR',
                endFieldName    : 'ST_DATE_TO',
                id          : 'stDate',             
                value       : new Date(),               
                allowBlank  : false,        
                tdAttrs     : {width: 380} 
            },{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
//				multiSelect	: true, 
//				typeAhead	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
		 		}
			}, 
			Unilite.popup('Employee',{
				fieldLabel		: '사원',
				valueFieldName	: 'PERSON_NUMB_FR',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB_TO', panelResult.getValue('PERSON_NUMB_FR'));
                            panelResult.setValue('NAME1', panelResult.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB_FR', '');
                        panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
			}),Unilite.popup('Employee',{
                fieldLabel      : '~',
                valueFieldName  : 'PERSON_NUMB_TO',
                textFieldName   : 'NAME1',
                validateBlank   : false,
                autoPopup       : true,
                colspan         : 2,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('PERSON_NUMB_TO', '');
                        panelResult.setValue('NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),   
			Unilite.popup('DEPT',{
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT_CODE_FR',
				textFieldName	: 'DEPT_NAME',
				validateBlank	: false,					
				tdAttrs			: {width: 380},  
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_FR'));
                            panelResult.setValue('DEPT_NAME1', panelResult.getValue('DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE_FR', '');
                        panelResult.setValue('DEPT_NAME', '');
					},
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
			}),Unilite.popup('DEPT',{
                fieldLabel      : '~',
                valueFieldName  : 'DEPT_CODE_TO',
                textFieldName   : 'DEPT_NAME1',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                colspan         : 2,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelResult.setValue('DEPT_CODE_TO', '');
                        panelResult.setValue('DEPT_NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }), {
                fieldLabel  : '직책',
                name        : 'ABIL_CODE_FR', 
                xtype       : 'uniCombobox',
                comboType   : 'AU',
                comboCode   : 'H006',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	panelResult.setValue('ABIL_CODE_TO', newValue);
                    },
                    onClear: function(type) {
                        panelResult.setValue('ABIL_CODE_FR', '');
                    }
                }
            },{
                fieldLabel  : '~',
                name        : 'ABIL_CODE_TO', 
                xtype       : 'uniCombobox',
                comboType   : 'AU',
                comboCode   : 'H006',
                colspan         : 2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    },
                    onClear: function(type) {
                        panelResult.setValue('ABIL_CODE_TO', '');
                    }
                }
            },{	    
				fieldLabel	: '조회구분',
				name		: 'QUERY_TYPE',
				id			: 'query_type',
				xtype		: 'uniRadiogroup',
				width		: 300,
				items		: [{
					boxLabel	: '입사일자',
					name		: 'QUERY_TYPE',
					inputValue	: '1'								
				},{
					boxLabel	: '승진',
					name		: 'QUERY_TYPE',
					inputValue	: '2'
				}],	
				value		: '1'
			}
		]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	//1: 남성
	var masterGrid1 = Unilite.createGrid('s_hum550skr_kdGrid1', {
		store	: masterStore1,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {	
			expandLastColumn	: true,			//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,			//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,			//찾기 버튼 사용 여부
			useRowContext		: false,			
			onLoadSelectFirst	: true,
			filter: {							//필터 사용 여부
				useFilter	: true,
				autoCreate	: true
			}
		},
		
        tbar: [{
                itemId : 'GWBtn',
                id:'GW1',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    
                    if(!UniAppManager.app.isValidSearchForm()){
                        return false;
                    }

                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                }
            }
        ],
		
		features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		selModel:'rowmodel',
		columns:  [
			{text: '인사현황', 
              	columns:[
					{ dataIndex: 'COMP_CODE'		 	, width: 110	, hidden: true},
					{ dataIndex: 'PERSON_RANK'			, width: 50		},
					{ dataIndex: 'PERSON_NUMB'			, width: 110	},
					{ dataIndex: 'PERSON_NAME'			, width: 110	},
					{ dataIndex: 'REPRE_NUM'			, width: 110	},
					{ dataIndex: 'ORG_NAME'				, width: 110	, hidden: true},
					{ dataIndex: 'GRAD_GUBUN_NAME'		, width: 100	},
					{ dataIndex: 'JOIN_DATE'			, width: 100	},
					{ dataIndex: 'WORK_YMD'				, width: 100	},
					{ dataIndex: 'POST_CODE'			, width: 80		},
					{ dataIndex: 'POST_NAME'			, width: 110	},
					{ dataIndex: 'DEPT_NAME'			, width: 110	},
					{ dataIndex: 'PROMOTION_DATE1'      , width: 110    },
					{ dataIndex: 'PROMOTION_YMD'        , width: 110    },
					{ dataIndex: 'PROMOTION_DATE2'      , width: 110    }
			]},
			{text: '인상 후', 
              	columns:[
					{ dataIndex: 'PROMOTION_DATE1'		, width: 100	, hidden: true},
					{ dataIndex: 'PROMOTION_YMD'		, width: 100	, hidden: true},
					{ dataIndex: 'PROMOTION_DATE2'		, width: 100	, hidden: true},
					{ dataIndex: 'PAY_GRADE_01'			, width: 90		, hidden: true},
					{ dataIndex: 'PAY_GRADE_01_NAME'	, width: 90		},
					{ dataIndex: 'PAY_GRADE_03'			, width: 90		},
					{ dataIndex: 'PAY_GRADE_04'			, width: 90		},
					{ dataIndex: 'WAGES_AMT_01'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_02'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_03'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_04'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_05'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_06'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_07'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_08'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_09'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_10'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_11'			, width: 100	},
					{ dataIndex: 'WAGES_AMT_12'			, width: 100	},
					{ dataIndex: 'AF_WAGES_AMT_TOT'		, width: 100	}
			]},
			{text: '인상 전', 
              	columns:[
					{ dataIndex: 'BE_WAGES_AMT_01'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_02'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_03'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_04'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_05'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_06'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_07'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_08'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_09'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_10'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_11'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_12'		, width: 100	},
					{ dataIndex: 'BE_WAGES_AMT_TOT'		, width: 100	}
			]}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
//	
//	//2: 여성
//	var masterGrid2 = Unilite.createGrid('s_hum550skr_kdGrid2', {
//		store	: masterStore2,
//		region	: 'center',
//		layout	: 'fit',
//		uniOpt	: {	
//			expandLastColumn	: true,			//마지막 컬럼 * 사용 여부
//			useRowNumberer		: true,			//첫번째 컬럼 순번 사용 여부
//			useLiveSearch		: true,			//찾기 버튼 사용 여부
//			useRowContext		: false,			
//			onLoadSelectFirst	: true,
//			filter: {							//필터 사용 여부
//				useFilter	: true,
//				autoCreate	: true
//			}
//		},
//		
//        tbar: [{
//                itemId : 'GWBtn',
//                id:'GW2',
//                iconCls : 'icon-referance'  ,
//                text:'기안',
//                handler: function() {
//                    var param = panelResult.getValues();
//                    
//                    if(!UniAppManager.app.isValidSearchForm()){
//                        return false;
//                    }
//
//                    if(confirm('기안 하시겠습니까?')) {
//                       UniAppManager.app.requestApprove();
//                    }
//                }
//            }
//        ],
//		
//		features: [ 
//			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
//			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
//		],
//        selModel:'rowmodel',
//		columns:  [
//			{text: '인사현황', 
//              	columns:[
//					{ dataIndex: 'COMP_CODE'		 	, width: 110	, hidden: true},
//					{ dataIndex: 'PERSON_RANK'			, width: 80		},
//					{ dataIndex: 'PERSON_NUMB'			, width: 110	},
//					{ dataIndex: 'PERSON_NAME'			, width: 110	},
//					{ dataIndex: 'REPRE_NUM'			, width: 110	},
//					{ dataIndex: 'ORG_NAME'				, width: 110	, hidden: true},
//					{ dataIndex: 'GRAD_GUBUN_NAME'		, width: 100	},
//					{ dataIndex: 'JOIN_DATE'			, width: 100	},
//					{ dataIndex: 'WORK_YMD'				, width: 100	},
//					{ dataIndex: 'POST_CODE'			, width: 80		},
//					{ dataIndex: 'POST_NAME'			, width: 110	},
//					{ dataIndex: 'DEPT_NAME'			, width: 110	}
//			]},
//			{text: '인상 후', 
//              	columns:[
//					{ dataIndex: 'PROMOTION_DATE1'		, width: 100	, hidden: true},
//					{ dataIndex: 'PROMOTION_YMD'		, width: 100	, hidden: true},
//					{ dataIndex: 'PROMOTION_DATE2'		, width: 100	, hidden: true},
//					{ dataIndex: 'PAY_GRADE_01'			, width: 90		, hidden: true},
//					{ dataIndex: 'PAY_GRADE_01_NAME'	, width: 90		},
//					{ dataIndex: 'PAY_GRADE_03'			, width: 90		},
//					{ dataIndex: 'PAY_GRADE_04'			, width: 90		},
//					{ dataIndex: 'WAGES_AMT_01'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_02'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_03'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_04'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_05'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_06'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_07'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_08'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_09'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_10'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_11'			, width: 100	},
//					{ dataIndex: 'WAGES_AMT_12'			, width: 100	},
//					{ dataIndex: 'AF_WAGES_AMT_TOT'		, width: 100	}
//			]},
//			{text: '인상 전', 
//              	columns:[
//					{ dataIndex: 'BE_WAGES_AMT_01'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_02'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_03'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_04'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_05'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_06'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_07'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_08'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_09'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_10'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_11'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_12'		, width: 100	},
//					{ dataIndex: 'BE_WAGES_AMT_TOT'		, width: 100	}
//			]}
//		] ,
//		listeners:{
//			uniOnChange: function(grid, dirty, eOpts) {
//			}
//		}
//	});		
	

	
	
	
//	var tab = Unilite.createTabPanel('s_hum550skr_kdTab',{		
//		region		: 'center',
//		activeTab	: 0,
//		border		: false,
//		items		: [{
//				title	: '남성',
//				xtype	: 'container',
//				itemId	: 's_hum550skr_kdTab1',
//				layout	: {type:'vbox', align:'stretch'},
//				items	: [
//					
//				]
//			},{
//				title	: '여성',
//				xtype	: 'container',
//				itemId	: 's_hum550skr_kdTab2',
//				layout	: {type:'vbox', align:'stretch'},
//				items:[
//					
//				]
//			}
//		],
//		listeners:{
//			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
//				if(newCard.getItemId() == 's_hum550skr_kdTab1')	{
//					
//				}else {
//					
//				}
//			}
//		}
//	})
 
	
	
	
	Unilite.Main({
		id  : 's_hum550skr_kdApp',
		borderItems:[{
		  region: 'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult,masterGrid1
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('ST_DATE_FR'		, new Date());
			panelResult.setValue('ST_DATE_TO'        , new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('ST_DATE_FR');
			panelResult.onLoadSelectText('ST_DATE_TO');
			//버튼 설정
			UniAppManager.setToolbarButtons('print'	, false);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);
			
			Ext.getCmp('GW1').setDisabled(true);
			//Ext.getCmp('GW2').setDisabled(true);
		},
		
		onQueryButtonDown : function()	{
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
//			//활성화 된 탭에 따른 조회로직
//			var activeTab = tab.getActiveTab().getItemId();
			//1: 남성
			
				masterStore1.loadStoreRecords();
//
//			//2: 여성
//			} else {
//				masterStore2.loadStoreRecords();
//			}
			
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});	
			//masterGrid2.getStore().loadData({});
			this.fnInitBinding();	
		}, 
		
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm           = document.f1;
            var compCode      = UserInfo.compCode;
            var divCode       = panelResult.getValue('DIV_CODE');
            var userId        = UserInfo.userID
            var stdatefr      = UniDate.getDbDateStr(panelResult.getValue('ST_DATE_FR'));
            var stdateto      = UniDate.getDbDateStr(panelResult.getValue('ST_DATE_TO'));
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            
            var abilcodefr    = panelResult.getValue('ABIL_CODE_FR');
            var abilcodeto    = panelResult.getValue('ABIL_CODE_TO');
            
            var gubun         = Ext.getCmp('query_type').getChecked()[0].inputValue
            var humsex        = '';
            
    //        var activeTab = tab.getActiveTab().getItemId();
            //1: 입사일별
 //           if (activeTab == 's_hum550skr_kdTab1'){
                var humsex    = 'A'
//
//            //2: 퇴사일별
//            } else {
//                var humsex    = 'A'
//            }
            
            
            //var record = masterGrid.getSelectedRecord();
            var groupUrl    = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hum550skr&draft_no=0&sp=EXEC " 
            
                        
            var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HUM550SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                            + ', ' + "'" + stdatefr + "'" +', ' + "'" + stdateto + "'"
                            + ', ' + "'" + deptcodefr + "'" +', ' + "'" + deptcodeto + "'" 
                            + ', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'" 
                            + ', ' + "'" + abilcodefr + "'" +', ' + "'" + abilcodeto + "'" 
                            + ', ' + "'" + gubun + "'" + ', ' + "'" + humsex + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            
            
            
            //var groupUrl = "http://58.151.163.201:8070/ClipReport4/sample2.jsp?prg_no=hat890skr&sp=EXEC "

            frm.action   = groupUrl + spCall/* + Base64.encode()*/;
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
            
        }

	});
};


</script>


<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
