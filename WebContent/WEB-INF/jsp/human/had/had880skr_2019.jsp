<%@page language="java" contentType="text/html; charset=utf-8"%>
			
	var directMasterStore2019 = Unilite.createStore('had880skrMasterStore2019',{
		model: 'Had880skrModel',
		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
            	//비고(*) 사용않함
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
	});		// end of var directMasterStore2019 = Unilite.createStore('had880skrMasterStore2019',{
	
    
    var grid2019 = Unilite.createGrid('had880skrGrid2019', {
    	// for tab    	
    	title: '2019년기준',
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
        features: [{id : 'grid2019SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           {id : 'grid2019Total', 	 ftype: 'uniSummary', 	      showSummaryRow: true, dock : 'top'} ],
    	store: directMasterStore2019,
    	columns: [
    		{ dataIndex: 'DIV_CODE'					,   				width: 120,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            } },
    		{ dataIndex: 'DEPT_CODE'				,   				width: 120 },
    		{ dataIndex: 'POST_CODE'				,   				width: 70 },
    		{ dataIndex: 'NAME'						,   				width: 70 },
    		{ dataIndex: 'PERSON_NUMB'				,   				width: 80 },
    		{ dataIndex: 'JOIN_DATE'				,   				width: 90, hidden: true },
    		{ dataIndex: 'RETR_DATE'				,   				width: 90, hidden: true },
    		{ dataIndex: 'NOW_PAY_TOTAL_I'			,   				width: 120, summaryType: 'sum' },
    		{ dataIndex: 'NOW_BONUS_TOTAL_I'     	,   				width: 120, summaryType: 'sum' },
    		{ dataIndex: 'NOW_ADD_BONUS_I'			,   				width: 120, summaryType: 'sum' },
    		{ dataIndex: 'PREV_PAY_TOTAL_I'			,   				width: 120, summaryType: 'sum' },
    		{ dataIndex: 'PREV_BONUS_TOTAL_I'    	,   				width: 120, summaryType: 'sum' },
    		{ dataIndex: 'TAX_EXEMPTION'         	,   				width: 120, summaryType: 'sum' },
    		{ text: '결정세액',
	        	columns: [
	        		{ dataIndex: 'DEF_IN_TAX_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'DEF_LOCAL_TAX_I'			,   				width: 120, summaryType: 'sum' }
	        	]
	        }, 
	        { text: '기납부세액(주,현)',
	        	columns: [
	        		{ dataIndex: 'NOW_IN_TAX_I'				,   				width: 120, summaryType: 'sum' },
    				{ dataIndex: 'NOW_LOCAL_TAX_I'			,   				width: 120, summaryType: 'sum' }
	        	]
	        },
    		{ text: '기납부세액(종,전)',
	        	columns: [
	        		{ dataIndex: 'PREV_IN_TAX_I'			,   				width: 120, summaryType: 'sum' },
    				{ dataIndex: 'PREV_LOCAL_TAX_I'			,   				width: 120, summaryType: 'sum' }
	        	]
    		},
    		{ text: '차감징수(환급)세액',
	        	columns: [
	        		{ dataIndex: 'IN_TAX_I'					,   				width: 120, summaryType: 'sum' },
    				{ dataIndex: 'LOCAL_TAX_I'				,   				width: 120, summaryType: 'sum' }	
	        	]
    		},
    		{ dataIndex: 'INCOME_SUPP_TOTAL_I'		,   				width: 120, summaryType: 'sum' },
    		{ dataIndex: 'INCOME_DED_I'				,   				width: 120, summaryType: 'sum' },
    		{ dataIndex: 'EARN_INCOME_I'			,   				width: 120, summaryType: 'sum' },       
    		{ text: '기본공제',
	        	columns: [
	        		{ dataIndex: 'PER_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'SPOUSE_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'SUPP_SUB_I'				,   				width: 120, summaryType: 'sum' }
	        	]
    		},
    		{ text: '추가공제',
	        	columns: [
	        		{ dataIndex: 'AGED_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'DEFORM_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'WOMAN_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'ONE_PARENT_DED_I'			,   				width: 120, summaryType: 'sum' }
	        	]
    		},
    		{ text: '연금보험료공제',
	        	columns: [
	        		{ dataIndex: 'ANU_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'PUBLIC_PENS_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'SOLDIER_PENS_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'SCH_PENS_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'POST_PENS_I'				,   				width: 120, summaryType: 'sum' }
	        	]
	        },
    		{ text: '특별소득공제',
	        	columns: [
	        		{ dataIndex: 'MED_PREMINM_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'HIRE_INSUR_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'HOUS_AMOUNT_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'HOUS_AMOUNT_I_2'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MORTGAGE_RETURN_I_2'		,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MORTGAGE_RETURN_I'		,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MORTGAGE_RETURN_I_3'		,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MORTGAGE_RETURN_I_5'		,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MORTGAGE_RETURN_I_4'		,   				width: 120, summaryType: 'sum' },	        		
	        		{ dataIndex: 'MORTGAGE_RETURN_I_6'		,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MORTGAGE_RETURN_I_7'		,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MORTGAGE_RETURN_I_8'		,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MORTGAGE_RETURN_I_9'		,   				width: 135, summaryType: 'sum' },
	        		{ dataIndex: 'GIFT_DED_I'				,   				width: 120, summaryType: 'sum' }
	        	]
	        },
    		{ text: '그밖의소득공제',
	        	columns: [
	        		{ dataIndex: 'PRIV_PENS_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'COMP_PREMINUM_DED_I'		,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'HOUS_BU_AMT'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'HOUS_BU_AMOUNT_I'			,   				width: 125, summaryType: 'sum' },
	        		{ dataIndex: 'HOUS_WORK_AMT'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'INVESTMENT_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'CARD_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'STAFF_STOCK_DED_I'		,   				width: 120, summaryType: 'sum' },
	        		//{ dataIndex: 'STAFF_GIFT_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'EMPLOY_WORKER_DED_I'		,   				width: 120, summaryType: 'sum' },
	        		//{ dataIndex: 'NOT_AMOUNT_LOAN_DED_I'	,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'LONG_INVEST_STOCK_DED_I'	,   				width: 120, summaryType: 'sum' }
	        	]
	        },        		
    		{ dataIndex: 'OVER_INCOME_DED_LMT'		,   				width: 120, summaryType: 'sum' },
    		{ dataIndex: 'TAX_STD_I'				,   				width: 120, summaryType: 'sum' },
    		{ dataIndex: 'COMP_TAX_I'				,   				width: 120, summaryType: 'sum' },
    		{ text: '세액감면',
	        	columns: [
	        		{ dataIndex: 'INCOME_REDU_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'SKILL_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'YOUTH_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'YOUTH_DED_I4'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'YOUTH_DED_I3'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'YOUTH_DED_I2'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'TAXES_REDU_I'				,   				width: 120, summaryType: 'sum' }
	        	]
	        },
    		{ text: '세액공제',
	        	columns: [
	        		{ dataIndex: 'IN_TAX_DED_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'CHILD_TAX_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'SCI_TAX_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'RETIRE_TAX_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'PENS_TAX_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'ETC_INSUR_TAX_DED_I'		,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'DEFORM_INSUR_TAX_DED_I'	,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MED_TAX_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'EDUC_TAX_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'GIFT_TAX_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'STD_TAX_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'NAP_TAX_DED_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'HOUS_INTER_I'				,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'OUTSIDE_INCOME_I'			,   				width: 120, summaryType: 'sum' },
	        		{ dataIndex: 'MON_RENT_I'				,   				width: 120, summaryType: 'sum' }
	        	]
	        }								
		] 
    });

