<%@page language="java" contentType="text/html; charset=utf-8"%>

	var directMasterStore2020 = Unilite.createStore('had880skrMasterStore2020',{
		model: 'Had880skrModel',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
					read: 'had880skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});		// end of var directMasterStore2020 = Unilite.createStore('had880skrMasterStore2020',{
	
	var grid2020 = Unilite.createGrid('had880skrGrid2020', {
		// for tab		
		title: '2020년기준',
		layout : 'fit',
		region:'center',
		uniOpt:{	
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			},
			state: {					//그리드 설정 사용 여부
				useState: false,
				useStateList: false
			}
		},
		features: [	{id : 'grid2020SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'grid2020Total'	, ftype: 'uniSummary'		 , showSummaryRow: false	, dock : 'top' }],
		store: directMasterStore2020,
		columns: [
			{ dataIndex: 'DIV_CODE'					,					width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{ dataIndex: 'DEPT_CODE'				,					width: 120 },
			{ dataIndex: 'POST_CODE'				,					width: 70 },
			{ dataIndex: 'NAME'						,					width: 70 },
			{ dataIndex: 'PERSON_NUMB'				,					width: 80 },
			{ dataIndex: 'JOIN_DATE'				,					width: 90, hidden: true },
			{ dataIndex: 'RETR_DATE'				,					width: 90, hidden: true },
			{ text: '소득명세', columns: [
				{ text: '주(현)근무지', columns: [
					{ dataIndex: 'NOW_PAY_TOTAL_I'			,					width: 100, summaryType: 'sum'	, text: '급여총액' },
					{ dataIndex: 'NOW_BONUS_TOTAL_I'		,					width: 100, summaryType: 'sum'	, text: '상여총액' },
					{ dataIndex: 'NOW_ADD_BONUS_I'			,					width: 100, summaryType: 'sum'	, text: '인정상여' },
					{ dataIndex: 'NOW_STOCK_PROFIT_I'		,					width: 100, summaryType: 'sum'	, text: '주식매수선택<br/>행사이익' },
					{ dataIndex: 'NOW_OWNER_STOCK_DRAW_I'	,					width: 100, summaryType: 'sum'	, text: '우리사주조합<br/>인출금' },
					{ dataIndex: 'NOW_OF_RETR_OVER_I'		,					width: 100, summaryType: 'sum'	, text: '임원퇴직<br/>한도초과액' },
					{ dataIndex: 'NOW_TAX_INVENTION_I'		,					width: 100, summaryType: 'sum'	, text: '직무발명<br/>보상금과세분' },
					{ dataIndex: 'NOW_TAX_EXEMPTION'		,					width: 100, summaryType: 'sum'	, text: '비과세 계' },
					{ dataIndex: 'NOW_YOUTH_DED_I_SUM'		,					width: 100, summaryType: 'sum'	, text: '감면소득 계' }
				]},
				{ text: '종(전)근무지', columns: [
					{ dataIndex: 'OLD_PAY_TOTAL_I'			,					width: 100, summaryType: 'sum'	, text: '급여총액' },
					{ dataIndex: 'OLD_BONUS_TOTAL_I'		,					width: 100, summaryType: 'sum'	, text: '상여총액' },
					{ dataIndex: 'OLD_ADD_BONUS_I'			,					width: 100, summaryType: 'sum'	, text: '인정상여' },
					{ dataIndex: 'OLD_STOCK_PROFIT_I'		,					width: 100, summaryType: 'sum'	, text: '주식매수선택<br/>행사이익' },
					{ dataIndex: 'OLD_OWNER_STOCK_DRAW_I'	,					width: 100, summaryType: 'sum'	, text: '우리사주조합<br/>인출금' },
					{ dataIndex: 'OLD_OF_RETR_OVER_I'		,					width: 100, summaryType: 'sum'	, text: '임원퇴직<br/>한도초과액' },
					{ dataIndex: 'OLD_TAX_INVENTION_I'		,					width: 100, summaryType: 'sum'	, text: '직무발명<br/>보상금과세분' },
					{ dataIndex: 'OLD_TAX_EXEMPTION'		,					width: 100, summaryType: 'sum'	, text: '비과세 계' },
					{ dataIndex: 'OLD_YOUTH_DED_I_SUM'		,					width: 100, summaryType: 'sum'	, text: '감면소득 계' }
				]}
			]},
			{ text: '세액명세', columns: [
				{ text: '결정세액', columns: [
						{ dataIndex: 'DEF_IN_TAX_I'				,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'DEF_LOCAL_TAX_I'			,					width: 100, summaryType: 'sum' }
				]},
				{ text: '기납부세액', columns: [
					{ text: '주(현)근무지', columns: [
						{ dataIndex: 'NOW_IN_TAX_I'				,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'NOW_LOCAL_TAX_I'			,					width: 100, summaryType: 'sum' }
					]},
					{ text: '종(전)근무지', columns: [
						{ dataIndex: 'PREV_IN_TAX_I'			,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'PREV_LOCAL_TAX_I'			,					width: 100, summaryType: 'sum' }
					]}
				]},
				{ text: '차감징수(환급)세액', columns: [
					{ dataIndex: 'IN_TAX_I'					,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'LOCAL_TAX_I'				,					width: 100, summaryType: 'sum' }
				]},
				{ dataIndex: 'ACTUAL_TAX_RATE'			,					width:  60	, text: '실효<br/>세율' }
			]},
			{ text: '근로소득금액', columns: [
				{ dataIndex: 'INCOME_SUPP_TOTAL_I'		,					width: 100, summaryType: 'sum' },
				{ dataIndex: 'INCOME_DED_I'				,					width: 100, summaryType: 'sum' },
				{ dataIndex: 'EARN_INCOME_I'			,					width: 100, summaryType: 'sum' }
			]},
			{ text: '소득공제', columns: [
				{ text: '인적공제',columns: [
					{ text: '기본공제',columns: [
						{ dataIndex: 'PER_DED_I'				,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'SPOUSE_DED_I'				,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'SUPP_SUB_I'				,					width: 100, summaryType: 'sum' }
					]},
					{ text: '추가공제', columns: [
						{ dataIndex: 'AGED_DED_I'				,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'DEFORM_DED_I'				,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'WOMAN_DED_I'				,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'ONE_PARENT_DED_I'			,					width: 100, summaryType: 'sum' }
					]}
				]},
				{ text: '연금보험료공제', columns: [
					{ dataIndex: 'ANU_DED_I'				,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'PUBLIC_PENS_I'			,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'SOLDIER_PENS_I'			,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'SCH_PENS_I'				,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'POST_PENS_I'				,					width: 100, summaryType: 'sum' }
				]},
				{ text: '특별소득공제', columns: [
					{ text: '보험료', columns: [
						{ dataIndex: 'MED_PREMINM_I'			,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'HIRE_INSUR_I'				,					width: 100, summaryType: 'sum' }
					]},
					{ text: '주택자금', columns: [
						{ text: '주택임차차입금 원리금 상환액', columns: [
							{ dataIndex: 'HOUS_AMOUNT_I'			,					width: 100, summaryType: 'sum'	, text: '대출기관' },
							{ dataIndex: 'HOUS_AMOUNT_I_2'			,					width: 100, summaryType: 'sum'	, text: '거주자' }
						]},
						{ text: '장기주택저당차입금 이자 상환액', columns: [
							{ dataIndex: 'MORTGAGE_RETURN_I_2'		,					width: 100, summaryType: 'sum' },
							{ dataIndex: 'MORTGAGE_RETURN_I'		,					width: 100, summaryType: 'sum' },
							{ dataIndex: 'MORTGAGE_RETURN_I_3'		,					width: 100, summaryType: 'sum' },
							{ dataIndex: 'MORTGAGE_RETURN_I_5'		,					width: 100, summaryType: 'sum' },
							{ dataIndex: 'MORTGAGE_RETURN_I_4'		,					width: 100, summaryType: 'sum' },
							{ dataIndex: 'MORTGAGE_RETURN_I_6'		,					width: 100, summaryType: 'sum' },
							{ dataIndex: 'MORTGAGE_RETURN_I_7'		,					width: 100, summaryType: 'sum' },
							{ dataIndex: 'MORTGAGE_RETURN_I_8'		,					width: 100, summaryType: 'sum' },
							{ dataIndex: 'MORTGAGE_RETURN_I_9'		,					width: 100, summaryType: 'sum' }
						]}
					]},
					{ dataIndex: 'GIFT_DED_I'				,					width: 100, summaryType: 'sum'	, text: '기부금<br/>(이월분)' },
					{ dataIndex: 'SP_INCOME_DED_I'			,					width: 100, summaryType: 'sum'	, text: '특별소득공제<br/>계' }
				]},
				{ text: '그밖의소득공제', columns: [
					{ dataIndex: 'PRIV_PENS_I'				,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'COMP_PREMINUM_DED_I'		,					width: 100, summaryType: 'sum'	, text: '소기업<br/>소상공인' },
					{ text: '주택마련저축', columns: [
						{ dataIndex: 'HOUS_BU_AMT'				,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'HOUS_BU_AMOUNT_I'			,					width: 100, summaryType: 'sum'	, text: '주택청약<br/>종합저축' },
						{ dataIndex: 'HOUS_WORK_AMT'			,					width: 100, summaryType: 'sum'	, text: '근로자<br/>주택마련저축' }
					]},
					{ dataIndex: 'INVESTMENT_DED_I'			,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'CARD_DED_I'				,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'STAFF_STOCK_DED_I'		,					width: 100, summaryType: 'sum'	, text: '우리사주<br/>조합출연' },
					{ dataIndex: 'EMPLOY_WORKER_DED_I'		,					width: 100, summaryType: 'sum'	, text: '고용유지<br/>근로자' },
					{ dataIndex: 'LONG_INVEST_STOCK_DED_I'	,					width: 100, summaryType: 'sum'	, text: '장기집합<br/>투자증권' },
					{ dataIndex: 'ETC_INCOME_DED_I'			,					width: 100, summaryType: 'sum'	, text: '그 밖의<br/>소득공제 계' }
				]}
			]},
			{ text: '과세표준', columns: [
				{ dataIndex: 'OVER_INCOME_DED_LMT'		,					width: 100, summaryType: 'sum'	, text: '소득공제<br/>한도초과액' },
				{ dataIndex: 'TAX_STD_I'				,					width: 100, summaryType: 'sum'	, text: '종합소득<br/>과세표준' }
			]},
			{ dataIndex: 'COMP_TAX_I'				,					width: 100, summaryType: 'sum' },
			{ text: '세액감면', columns: [
				{ dataIndex: 'INCOME_REDU_I'			,					width: 120, summaryType: 'sum' },
				{ text: '외국인근로자 소득세 감면', columns: [
					{ dataIndex: 'SKILL_DED_RATE'			,					width:  60, summaryType: 'sum'	, text: '감면율' },
					{ dataIndex: 'SKILL_DED_I'				,					width: 100, summaryType: 'sum'	, text: '감면액' }
				]},
				{ text: '성과공유중소기업 경영성과급 감면', columns: [
					{ dataIndex: 'MANAGE_RESULT_REDU_RATE'	,					width:  60, summaryType: 'sum'	, text: '감면율' },
					{ dataIndex: 'MANAGE_RESULT_REDU_I'		,					width: 100, summaryType: 'sum'	, text: '감면액' }
				]},
				{ text: '핵심인력 성과보상기금 소득세 감면', columns: [
					{ dataIndex: 'CORE_COMPEN_FUND_REDU_RATE',					width:  60, summaryType: 'sum'	, text: '감면율' },
					{ dataIndex: 'CORE_COMPEN_FUND_REDU_I'	,					width: 100, summaryType: 'sum'	, text: '감면액' }
				]},
				{ text: '내국인 우수인력 복귀자 소득세 감면', columns: [
					{ dataIndex: 'RETURN_WORKER_REDU_RATE'	,					width:  60, summaryType: 'sum'	, text: '감면율' },
					{ dataIndex: 'RETURN_WORKER_REDU_I'		,					width: 100, summaryType: 'sum'	, text: '감면액' }
				]},
				{ text: '중소기업 취업청년 소득세 감면', columns: [
					{ dataIndex: 'YOUTH_EXEMP_RATE'			,					width:  60, summaryType: 'sum'	, text: '감면율' },
					{ dataIndex: 'YOUTH_DED_I'				,					width: 100, summaryType: 'sum'	, text: '감면액' }
				]},
				{ dataIndex: 'TAXES_REDU_I'				,					width: 100, summaryType: 'sum' },
				{ dataIndex: 'COMP_TAX_REDU_I'			,					width: 100, summaryType: 'sum'	, text: '세액감면 계' }
			]},
			{ text: '세액공제', columns: [
				{ dataIndex: 'IN_TAX_DED_I'				,					width: 100, summaryType: 'sum'	, text: '근로소득<br/>세액공제' },
				{ dataIndex: 'CHILD_TAX_DED_I'			,					width: 100, summaryType: 'sum' },
				{ text: '연금계좌', columns: [
					{ dataIndex: 'SCI_TAX_DED_I'			,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'RETIRE_TAX_DED_I'			,					width: 100, summaryType: 'sum'	, text: '근로자<br/>퇴직급여' },
					{ dataIndex: 'PENS_TAX_DED_I'			,					width: 100, summaryType: 'sum' }
				]},
				{ text: '특별세액공제', columns: [
					{ text: '보험료', columns: [
						{ dataIndex: 'ETC_INSUR_TAX_DED_I'		,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'DEFORM_INSUR_TAX_DED_I'	,					width: 100, summaryType: 'sum'	, text: '장애인<br/>전용보험' }
					]},
					{ dataIndex: 'MED_TAX_DED_I'			,					width: 100, summaryType: 'sum' },
					{ dataIndex: 'EDUC_TAX_DED_I'			,					width: 100, summaryType: 'sum' },
					{ text: '기부금', columns: [
						{ text: '정치자금기부금', columns: [
							{ dataIndex: 'POLICY_INDED_TAX_DED_I'			,					width: 100, summaryType: 'sum'	, text: '10만원미만' },
							{ dataIndex: 'POLICY_GIFT_TAX_DED_I'			,					width: 100, summaryType: 'sum'	, text: '10만원초과' }
						]},
						{ dataIndex: 'LEGAL_GIFT_TAX_DED_I'		,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'STAFF_GIFT_TAX_DED_I'		,					width: 100, summaryType: 'sum'	, text: '우리사주<br/>조합기부금' },
						{ dataIndex: 'APPOINT_GIFT_TAX_DED_I'	,					width: 100, summaryType: 'sum' },
						{ dataIndex: 'ASS_GIFT_TAX_DED_I'		,					width: 100, summaryType: 'sum'	, text: '종교단체<br/>기부금' }
					]},
					{ dataIndex: 'SP_TAX_DED_I'				,					width: 100, summaryType: 'sum'	, text: '특별세액공제<br/>계' },
					{ dataIndex: 'STD_TAX_DED_I'			,					width: 100, summaryType: 'sum' }
				]},
				{ dataIndex: 'NAP_TAX_DED_I'			,					width: 100, summaryType: 'sum'	, text: '납세조합공제' },
				{ dataIndex: 'HOUS_INTER_I'				,					width: 100, summaryType: 'sum'	, text: '주택차입금' },
				{ dataIndex: 'OUTSIDE_INCOME_I'			,					width: 100, summaryType: 'sum' },
				{ dataIndex: 'MON_RENT_I'				,					width: 100, summaryType: 'sum' },
				
				{ dataIndex: 'TAX_DED_SUM_I'			,					width: 100, summaryType: 'sum'	, text: '세액공제<br/>계' }
			]}
		]
	});
