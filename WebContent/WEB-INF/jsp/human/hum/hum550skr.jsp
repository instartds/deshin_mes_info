<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum550skr">
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
	Unilite.defineModel('hum550skrModel1', {
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
			{name: 'PROMOTION_DATE1'	,text: '승진일'			,type: 'string'},
			{name: 'PROMOTION_YMD'		,text: '근속일'			,type: 'string'},
			{name: 'PROMOTION_DATE2'	,text: '승진일'			,type: 'string'},
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
	
	//2: 여성
	Unilite.defineModel('hum550skrModel2', {
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
			{name: 'PROMOTION_DATE1'	,text: '승진일'			,type: 'string'},
			{name: 'PROMOTION_YMD'		,text: '근속일'			,type: 'string'},
			{name: 'PROMOTION_DATE2'	,text: '승진일'			,type: 'string'},
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
	

	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	//1: 남성		
	var masterStore1 = Unilite.createStore('hum550skrMasterStore1',{
		model	: 'hum550skrModel1',
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
					read: 'hum550skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//1: 남성 flag
			param.WORK_GUBUN = 'M'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid1.getStore().getCount();  
				if(count > 0){
					UniAppManager.setToolbarButtons(['print'], true);
				}else{
					UniAppManager.setToolbarButtons(['print'], false);
				}

			}
		}
	});
	
	//2: 여성	
	var masterStore2 = Unilite.createStore('hum550skrMasterStore2',{
		model	: 'hum550skrModel2',
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
					read: 'hum550skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			//2: 여성 flag
			param.WORK_GUBUN = 'F'
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid2.getStore().getCount();  
				if(count > 0){
					UniAppManager.setToolbarButtons(['print'], true);
				}else{
					UniAppManager.setToolbarButtons(['print'], false);
				}

			}
		}
	});
	

	
	
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '기준일',	
				name		: 'ST_DATE', 
				xtype		: 'uniDatefield',
				id			: 'stDate',				
				value		: new Date(),				
				allowBlank	: false,	  	
				tdAttrs		: {width: 380} 
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
				valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type)	{
					},
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
			}),  
			Unilite.popup('DEPT',{
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT_CODE',
				textFieldName	: 'DEPT_NAME',
				validateBlank	: false,					
				tdAttrs			: {width: 380},  
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type)	{
					},
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
			}),{	    
				fieldLabel	: '재직구분',
				name		: 'WORK_GB',
				id			: 'workGb',
				xtype		: 'uniRadiogroup',
				width		: 300,
				items		: [{
					boxLabel	: '전체',
					name		: 'WORK_GB',
					inputValue	: ''							
				},{
					boxLabel	: '재직',
					name		: 'WORK_GB',
					inputValue	: '1'								
				},{
					boxLabel	: '퇴직',
					name		: 'WORK_GB',
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
	var masterGrid1 = Unilite.createGrid('hum550skrGrid1', {
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
				
		features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		selModel:'rowmodel',
		columns:  [
			{text: '인사현황', 
              	columns:[
					{ dataIndex: 'COMP_CODE'		 	, width: 110	, hidden: true},
					{ dataIndex: 'PERSON_RANK'			, width: 80		},
					{ dataIndex: 'PERSON_NUMB'			, width: 110	},
					{ dataIndex: 'PERSON_NAME'			, width: 110	},
					{ dataIndex: 'REPRE_NUM'			, width: 110	},
					{ dataIndex: 'ORG_NAME'				, width: 110	, hidden: true},
					{ dataIndex: 'GRAD_GUBUN_NAME'		, width: 100	},
					{ dataIndex: 'JOIN_DATE'			, width: 100	},
					{ dataIndex: 'WORK_YMD'				, width: 100	},
					{ dataIndex: 'POST_CODE'			, width: 80		},
					{ dataIndex: 'POST_NAME'			, width: 110	},
					{ dataIndex: 'DEPT_NAME'			, width: 110	}
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
	
	//2: 여성
	var masterGrid2 = Unilite.createGrid('hum550skrGrid2', {
		store	: masterStore2,
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
				
		features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
        selModel:'rowmodel',
		columns:  [
			{text: '인사현황', 
              	columns:[
					{ dataIndex: 'COMP_CODE'		 	, width: 110	, hidden: true},
					{ dataIndex: 'PERSON_RANK'			, width: 80		},
					{ dataIndex: 'PERSON_NUMB'			, width: 110	},
					{ dataIndex: 'PERSON_NAME'			, width: 110	},
					{ dataIndex: 'REPRE_NUM'			, width: 110	},
					{ dataIndex: 'ORG_NAME'				, width: 110	, hidden: true},
					{ dataIndex: 'GRAD_GUBUN_NAME'		, width: 100	},
					{ dataIndex: 'JOIN_DATE'			, width: 100	},
					{ dataIndex: 'WORK_YMD'				, width: 100	},
					{ dataIndex: 'POST_CODE'			, width: 80		},
					{ dataIndex: 'POST_NAME'			, width: 110	},
					{ dataIndex: 'DEPT_NAME'			, width: 110	}
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
	

	
	
	
	var tab = Unilite.createTabPanel('hum550skrTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '남성',
				xtype	: 'container',
				itemId	: 'hum550skrTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '여성',
				xtype	: 'container',
				itemId	: 'hum550skrTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard.getItemId() == 'hum550skrTab1')	{
					
				}else {
					
				}
			}
		}
	})
 
	
	
	
	Unilite.Main({
		id  : 'hum550skrApp',
		borderItems:[{
		  region: 'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, tab 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('ST_DATE'		, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('ST_DATE');
			//버튼 설정
			UniAppManager.setToolbarButtons('print'	, false);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			UniAppManager.setToolbarButtons('save'	, false);
		},
		
		onQueryButtonDown : function()	{
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
			//활성화 된 탭에 따른 조회로직
			var activeTab = tab.getActiveTab().getItemId();
			//1: 남성
			if (activeTab == 'hum550skrTab1'){
				masterStore1.loadStoreRecords();

			//2: 여성
			} else {
				masterStore2.loadStoreRecords();
			}
			
			UniAppManager.setToolbarButtons('reset', true);
		},				
				
		onResetButtonDown: function() {		
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});	
			masterGrid2.getStore().loadData({});
			this.fnInitBinding();	
		}
	});
};


</script>
