<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb220skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A081" /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B042"  /> 		<!-- 금액단위 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {

var getStDt			= Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;			//당기시작월 관련 전역변수
	gsStDate		= getStDt[0].STDT;
	gsFcDate		= getStDt[0].TODT;
	gsChargeCode	= Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};	//ChargeCode 관련 전역변수
	gsChargeDivi	= fnGetRefCode();										//부서 확인 - 현업부서의 경우 다른부서 조회 불가
	
	
	gsTodayYear     = UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4);
	
	
//초기화 시 Model, Grid 만들기
	fields			= createModelField();
	columns			= createGridColumn();
//조회시 마다 생성할 모델 / store / 전역변수	
//	model_onQuery	= null;
	store_onQuery	= null;
	columnName		= null;
//시작달과 끝날의 개월 차
	interval		= null;

	/*  Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afb220Model', {
		fields : fields
	});		// End of Ext.define('Afb220skrModel', {

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('afb220MasterStore1',{
		model: 'Afb220Model',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'afb220skrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			//로그인사용자가 현업부서일 경우 부서를 set하게 됨 -> DEPTS 누락되어 수동 처리
			if(Ext.isEmpty(param.DEPTS) && !Ext.isEmpty(param.DEPT)) {
				param.DEPTS = [panelSearch.getValue('DEPT')];
			}
			this.load({
				params : param
			});
		}
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
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
			title	: '기본정보', 	
	   		itemId	: 'search_panel1',
	        layout	: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items	: [{
				fieldLabel		: '예산년월',
	            xtype			: 'uniMonthRangefield',
	            startFieldName	: 'BUDGET_YYMM_FR',
	            endFieldName	: 'BUDGET_YYMM_TO',
	            startDate		: gsTodayYear + gsStDate.substring(4, 6),
	            endDate			: UniDate.get('today'),
	            allowBlank		: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('BUDGET_YYMM_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('BUDGET_YYMM_TO', newValue);				    		
			    	}
			    }
	     	},
			Unilite.popup('DEPT', { 
				fieldLabel		: '부서', 
				valueFieldName	: 'DEPT_CODE',
				textFieldName	: 'DEPT_NAME',
				holdable		: 'hold',
				listeners		: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);	
					}
				}
			})
		]},{
			title	: '추가정보', 	
	   		itemId	: 'search_panel2',
	        layout	: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items	: [{
        		fieldLabel	: '금액단위',
        		name		: 'AMT_UNIT',
        		xtype		: 'uniCombobox',
        		comboType	: 'AU',
        		allowBlank	: false,
        		comboCode	: 'B042',
        		value		: '1'
			},{
				xtype		: 'radiogroup',		            		
				fieldLabel	: '과목구분',						            		
				id			: 'rdoSelect',
				items		: [{
					boxLabel	: '과목', 
					width		: 70, 
					name		: 'rdoSelect',
        			inputValue	: '1',
					checked		: true  
				},{
					boxLabel	: '세목', 
					width		: 70,
        			inputValue	: '2',
					name		: 'rdoSelect'
				}]
			}]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2/*,
		tableAttrs	: {style: 'border : 1px solid #ced9e7;', width: '100%'},
		tdAttrs		: {style: 'border : 1px solid #ced9e7;', align : 'center'}*/
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel		: '예산년월',
	            xtype			: 'uniMonthRangefield',
	            startFieldName	: 'BUDGET_YYMM_FR',
	            endFieldName	: 'BUDGET_YYMM_TO',
	            startDate		: gsTodayYear + gsStDate.substring(4, 6),
	            endDate			: UniDate.get('today'),
	            allowBlank		: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('BUDGET_YYMM_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('BUDGET_YYMM_TO', newValue);				    		
			    	}
			    }
	     	},
			Unilite.popup('DEPT', { 
				fieldLabel		: '부서', 
				valueFieldName	: 'DEPT_CODE',
				textFieldName	: 'DEPT_NAME',
				holdable		: 'hold',
				listeners		: {
			    	onValueFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_CODE', newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_NAME', newValue);	
					}
				}
			})
		]
	});
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('afb220Grid1', {
    	layout	: 'fit',
        region	: 'center',
		store	: masterStore,
    	features: [{
    		id		: 'masterGridSubTotal',
    		ftype	: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id		: 'masterGridTotal', 	
    		ftype	: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	uniOpt : {						
			useMultipleSorting	: true,			
		    useLiveSearch		: true,			
		    onLoadSelectFirst	: false,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: false,		
			expandLastColumn	: true,			
			useRowContext		: true,		
		    filter: {					
				useFilter		: true,	
				autoCreate		: true	
			}				
		},
    	sortableColumns: false,
		columns	: columns,
		selModel: 'rowmodel',
	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
				columnName			= grid.eventPosition.column.dataIndex;
			var partOfcolumnName	= columnName.substring(0, 6); 
			if (Ext.isEmpty(record.get('ACCNT')) || record.get('ACCNT') == '0' || record.get(columnName) == 0 || partOfcolumnName != 'RESULT'){
	  			return false;
			} else {
	  			return true;
			}
  		},
        uniRowContextMenu:{
			items: [{
	        		text: '예산실적조회 보기',   
	            	itemId	: 'linkAfb200skr',
	            	handler: function(menuItem, event) {
	            		var record			= masterGrid.getSelectedRecord();
						//링크시 넘길 예산년월 값 계산
						var strtYear		= UniDate.getDbDateStr(panelSearch.getValue('BUDGET_YYMM_FR')).substring(0,4);
       					var strtMonth		= UniDate.getDbDateStr(panelSearch.getValue('BUDGET_YYMM_FR')).substring(5,6);

	            		if (strtMonth < 10) {																		//MM만들기
	            			strtMonth = '0' + strtMonth;
	            		}  
						var strtDate		= strtYear + strtMonth;														//YYYYMM
						var budgetYyyymm	= parseInt(strtDate) + parseInt(columnName.substring(6)) -1;				//오른쪽 클릭한 컬럼의 순번 값 더하기
	            			budgetYyyymm	= (budgetYyyymm.toString()).substring(4) <= 12 ? budgetYyyymm : budgetYyyymm + 100 -12
	            			budgetYyyymm	= budgetYyyymm.toString();													//문자열로 변환
	            		var param = {
	            			'PGM_ID'		: 'afb220skr',
							'BUDG_YYYYMM'	: budgetYyyymm,
							'DEPT_CODE_FR' 	: panelSearch.getValue('DEPT_CODE'),
							'DEPT_CODE_TO'	: panelSearch.getValue('DEPT_CODE'),
							'DEPT_NAME_FR' 	: panelSearch.getValue('DEPT_NAME'),
							'DEPT_NAME_TO'	: panelSearch.getValue('DEPT_NAME'),
							'ACCNT_FR'		: record.data['ACCNT'],
							'ACCNT_TO'		: record.data['ACCNT'],
							'ACCNT_NAME_FR'	: record.data['ACCNT_NAME'],
							'ACCNT_NAME_TO'	: record.data['ACCNT_NAME'],
							'ACCNT_DIVI'	: panelSearch.getValue('rdoSelect')
	            		};
	            		masterGrid.gotoAfb200skr(param);
	            	}
	        	}
	        ]
	    },
		gotoAfb200skr:function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 'afb200skr', 'text':''}};							
			parent.openTab(rec1, '/accnt/afb200skr.do', params);
    	},
    	
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('ACCNT') == '0'){
					cls = 'x-change-cell_normal';
				} else if (Ext.isEmpty(record.get('ACCNT')) || record.get('ACCNT_CD') == '99999') {
					cls = 'x-change-cell_dark';
				}
				if(record.get('ACCNT_DIVI') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }
    });    
    
	 Unilite.Main( {
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid, panelResult
			]
		},
		panelSearch  	
		], 
		id : 'afb220App',
		
		fnInitBinding : function(params) {
			//링크로 넘어올 경우 링크 받기
			if(params && params.PGM_ID) {
				this.processParams(params);
			}

			//초기화 시 예산년도로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BUDGET_YYMM_FR');

			//버튼 초기화
			UniAppManager.setToolbarButtons('detail'	, false);
			UniAppManager.setToolbarButtons('reset'		, false);
		},
		
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
//			createModelField();
			createStore_onQuery();
		},        
		//링크로 넘어오는 params 받는 부분
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'afb210skr') {
				panelSearch.setValue('BUDGET_YYMM_FR'	,params.BUDGET_YYMM_FR);
				panelSearch.setValue('BUDGET_YYMM_TO'	,params.BUDGET_YYMM_TO);
				panelSearch.setValue('DEPT_CODE'		,params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME'		,params.DEPT_NAME);
				panelSearch.setValue('AMT_UNIT'			,params.AMT_UNIT);
				panelSearch.setValue('rdoSelect'		,params.rdoSelect);
				
				panelResult.setValue('BUDGET_YYMM_FR'	,params.BUDGET_YYMM_FR);
				panelResult.setValue('BUDGET_YYMM_TO'	,params.BUDGET_YYMM_TO);
				panelResult.setValue('DEPT_CODE'		,params.DEPT_CODE);
				panelResult.setValue('DEPT_NAME'		,params.DEPT_NAME);

				UniAppManager.app.onQueryButtonDown();
			}
        }
	});
	
	function fnGetRefCode(REF_CODE2){
		var param = {
			ADD_QUERY1	: "ISNULL(REF_CODE2,'') AS REF_CODE2",
			ADD_QUERY2	: '',
			MAIN_CODE	: 'A009',
			SUB_CODE	: gsChargeCode[0].SUB_CODE
		}
		accntCommonService.fnGetRefCodes(param, function(provider, response)	{
			if (provider.REF_CODE2 == '2') {
				panelSearch.setValue('DEPT_CODE', UserInfo.deptCode)
				panelSearch.setValue('DEPT_NAME', UserInfo.deptName)
				panelSearch.getField('DEPT_CODE').setReadOnly(true);
				panelSearch.getField('DEPT_NAME').setReadOnly(true);
				
				panelResult.setValue('DEPT_CODE', UserInfo.deptCode)
				panelResult.setValue('DEPT_NAME', UserInfo.deptName)
				panelResult.getField('DEPT_CODE').setReadOnly(true);
				panelResult.getField('DEPT_NAME').setReadOnly(true);
				
				return provider.REF_CODE2;
			}
//			gsChargeDiviCo = gsAuParam(0);
		});
	}

	// 모델 필드 생성
	function createModelField() {
		//모델 생성을 위한 개월 수 구하기
		if (panelSearch) {
			var startDate	= panelSearch.getValue('BUDGET_YYMM_FR')
			var endDate		= panelSearch.getValue('BUDGET_YYMM_TO')
			var strtMonth		= parseInt(UniDate.getDbDateStr(panelSearch.getValue('BUDGET_YYMM_FR')).substring(4,6));
		} else {
			var beforeConvertFr = gsStDate.substring(0,4) + '/' + gsStDate.substring(4,6) + '/' + gsStDate.substring(6,8);
			var beforeConvertTO = UniDate.get('today').substring(0,4) + '/' + UniDate.get('today').substring(4,6) + '/' + UniDate.get('today').substring(6,8);
			var startDate	= new Date(beforeConvertFr);
			var endDate		= new Date(beforeConvertTO);
			var strtMonth	= parseInt(UniDate.getDbDateStr(gsStDate).substring(4,6));
		}
		
		var yearDiff	= endDate.getYear()	- startDate.getYear();
		var monthDiff	= endDate.getMonth()- startDate.getMonth();
		 
		interval		= yearDiff*12 + monthDiff;
		
		//필드 생성
		var fields = [
			{name: 'ACCNT_CD'			, text: '계정코드'			, type: 'string'},
			{name: 'ACCNT'				, text: '계정과목'			, type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정과목명'			, type: 'string'}
		];
		for (var i = 0; i <= interval; i++){
			var month = strtMonth + i <= 12 ? strtMonth + i : strtMonth + i -12 
			fields.push(
  				{name: 'BUDG'			+ (i+1),	text: '예산',		type:'uniPrice'  },
				{name: 'RESULT'			+ (i+1),	text: '실적',		type:'uniPrice'  },
				{name: 'BALANCE'		+ (i+1),	text: '차액',		type:'uniPrice'  },
				{name: 'ACHIEVE_RATE'	+ (i+1),	text: '달성률',	type:'uniPercent'  }
			);
		}
		fields.push({name: 'BUDG_T'				, text: '예산'			, type: 'uniPrice'}),
		fields.push({name: 'RESULT_T'			, text: '실적'			, type: 'uniPrice'}),
		fields.push({name: 'BALANCE_T'			, text: '차액'			, type: 'uniPrice'}),
		fields.push({name: 'ACHIEVE_T'			, text: '달성률'			, type: 'uniPercent'}),
		fields.push({name: 'ACCNT_DIVI'			, text: ''				, type: 'string'})
		console.log(fields);
		return fields;
	}

	function createStore_onQuery() {
		columns1 = createGridColumn();
		store_onQuery = Unilite.createStore('store_onQuery', {
			uniOpt: {
	            isMaster	: true,			// 상위 버튼 연결 
	            editable	: false,		// 수정 모드 사용 
	            deletable	: false,		// 삭제 가능 여부 
		        useNavi		: false			// prev | newxt 버튼 사용
	        },
			autoLoad: false,
	        proxy: {
	           type: 'direct',
	            api: {			
	                read: 'afb220skrService.selectList1'                	
	            }
	        },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				//로그인사용자가 현업부서일 경우 부서를 set하게 됨 -> DEPTS 누락되어 수동 처리
				if(Ext.isEmpty(param.DEPTS) && !Ext.isEmpty(param.DEPT)) {
					param.DEPTS = [panelSearch.getValue('DEPT')];
				}
				
				var startDate	= panelSearch.getValue('BUDGET_YYMM_FR')
				var endDate		= panelSearch.getValue('BUDGET_YYMM_TO')
				
				var budgetYymmFr	= UniDate.getDbDateStr(startDate);
				var budgetYymmTo	= UniDate.getDbDateStr(endDate);
				param.gsFrDate		= budgetYymmFr.substring(0,4) + '/' + budgetYymmFr.substring(4,6) + '/' + '01';
				param.gsToDate		= budgetYymmTo.substring(0,4) + '/' + budgetYymmTo.substring(4,6) + '/' + '01';
				
				var yearDiff	= endDate.getYear()	- startDate.getYear();
				var monthDiff	= endDate.getMonth()- startDate.getMonth();
				
				interval		= yearDiff*12 + monthDiff;
				var monthRange	= [];
				for (i=0; i <= interval; i++){
					monthRange.push((parseInt(budgetYymmFr.substring(0,6)) + i)/*.toString()*/);
				}
				param.monthRange		= monthRange;
				
				this.load({
					params : param
				});
			},
			listeners: {
				load: function() {}								
			}
		});
		store_onQuery.loadStoreRecords();
		masterGrid.setColumnInfo(masterGrid, columns1, fields);
		masterGrid.reconfigure(store_onQuery, columns1);
	}
	
	// 그리드 컬럼 생성
	function createGridColumn() {
		//그리드 생성을 위한 개월 수 구하기
		if (panelSearch) {
			var startDate	= panelSearch.getValue('BUDGET_YYMM_FR')
			var endDate		= panelSearch.getValue('BUDGET_YYMM_TO')
			var strtYear	= UniDate.getDbDateStr(panelSearch.getValue('BUDGET_YYMM_FR')).substring(0,4);
			var strtMonth	= parseInt(UniDate.getDbDateStr(panelSearch.getValue('BUDGET_YYMM_FR')).substring(4,6));
		} else {
			var beforeConvertFr = gsStDate.substring(0,4) + '/' + gsStDate.substring(4,6) + '/' + gsStDate.substring(6,8);
			var beforeConvertTO = UniDate.get('today').substring(0,4) + '/' + UniDate.get('today').substring(4,6) + '/' + UniDate.get('today').substring(6,8);
			var startDate	= new Date(beforeConvertFr);
			var endDate		= new Date(beforeConvertTO);
			var strtYear	= UniDate.getDbDateStr(gsStDate).substring(4,6);
			var strtMonth	= parseInt(UniDate.getDbDateStr(gsStDate).substring(4,6));
		}
		
		var yearDiff	= endDate.getYear()	- startDate.getYear();
		var monthDiff	= endDate.getMonth()- startDate.getMonth();
		 
		interval		= yearDiff*12 + monthDiff;
		
		//필드 생성
		var columns = [
			{xtype: 'rownumberer',	sortable:false,	width: 35,	align:'center  !important',	resizable: true/*,	locked: true*/},
			{dataIndex: 'ACCNT_CD',			text: '계정코드',			width: 110, 	style: 'text-align: center'			/*, type: 'string'*/,	hidden: true},
			{dataIndex: 'ACCNT', 			text: '계정과목',			width: 80, 		style: 'text-align: center'			/*, type: 'string'*/, 	align: 'center', 
				//합계행은 계정과목 생략
				renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
					if(record.get('ACCNT') == '0'){
						return '';
					}else{
						return val;
					}
				}				
			},
			{dataIndex: 'ACCNT_NAME', 		text: '계정과목명',			width: 150, 	style: 'text-align: center'			/*, type: 'string'*/}
		];
		for (var i = 0; i <= interval; i++){
			var month = strtMonth + i <= 12 ? strtMonth + i : strtMonth + i -12 
			columns.push(
	      		{text: month + '월', 
	      			columns:[
	      				{dataIndex: 'BUDG'			+ (i+1),	text: '예산',		width: 110,	style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price,	summaryType: 'sum'  },
						{dataIndex: 'RESULT'		+ (i+1),	text: '실적',		width: 110,	style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price,	summaryType: 'sum'  },
						{dataIndex: 'BALANCE'		+ (i+1),	text: '차액',		width: 110,	style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price,	summaryType: 'sum'  },
						{dataIndex: 'ACHIEVE_RATE'	+ (i+1),	text: '달성률',	width: 80,	style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Percent,	summaryType: 'sum'  }
					]
			    }
			);
		}
		columns.push(
      		{text: '합계', 
      			columns:[
      				{dataIndex: 'BUDG_T',		text: '예산',		width: 110, 	style: 'text-align: center', 	align: 'right' , 	xtype:'uniNnumberColumn', 	format: UniFormat.Price,	summaryType: 'sum'  },
					{dataIndex: 'RESULT_T',		text: '실적',		width: 110, 	style: 'text-align: center', 	align: 'right' ,	xtype:'uniNnumberColumn', 	format: UniFormat.Price,	summaryType: 'sum'  },
					{dataIndex: 'BALANCE_T',	text: '차액',		width: 110, 	style: 'text-align: center', 	align: 'right' , 	xtype:'uniNnumberColumn',	format: UniFormat.Price,	summaryType: 'sum'  },
					{dataIndex: 'ACHIEVE_T',	text: '달성률',	width: 80, 		style: 'text-align: center', 	align: 'right' , 	xtype:'uniNnumberColumn',	format: UniFormat.Percent,	summaryType: 'sum'  },
					{dataIndex: 'ACCNT_DIVI',	text: '',		width: 80,		style: 'text-align: center',	hidden: true}
				]
			}
		)
		console.log(columns);
		return columns;
	}	
};
</script>
