<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbs700skr">
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {

	/** Model 정의 
	 * @type 
	 */
	//1: 개인별
	Unilite.defineModel('hbs700skrModel1', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
			{name: 'NAME'				,text: '이름'				,type: 'string'},
			{name: 'CNRC_YEAR'			,text: '연봉계약년도'		,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'				,type: 'string', comboType:'AU',comboCode:'H005'},
			{name: 'ABIL_CODE'			,text: '직급'				,type: 'string', comboType:'AU',comboCode:'H006'},
			{name: 'JOIN_DATE'			,text: '입사일'			,type: 'uniDate'},
			{name: 'SEX_CODE'			,text: '성별'				,type: 'string'},
			{name: 'ANNUAL_SALARY_I'	,text: '연봉'				,type: 'uniPrice'},
			{name: 'WAGES_STD_I_TOT'	,text: '월지급액'			,type: 'uniPrice'},
			{name: 'AGRN_YN'			,text: '동의여부'			,type: 'string', comboType:'AU',comboCode:'B010'},
			{name: 'AGRN_DATE'			,text: '동의일자'			,type: 'uniDate'},
			{name: 'DECS_YN'			,text: '확정여부'			,type: 'string', comboType:'AU',comboCode:'B010'},
			{name: 'RMK'				,text: '비고'				,type: 'string'}
		]
	});
	
	//2: 연도별
	Unilite.defineModel('hbs700skrModel2', {
		fields: [
			{name: 'COMP_CODE'		 	,text: 'COMP_CODE'		,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사번'				,type: 'string'},
			{name: 'NAME'				,text: '이름'				,type: 'string'},
			{name: 'CNRC_YEAR'			,text: '연봉계약년도'		,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'				,type: 'string', comboType:'AU',comboCode:'H005'},
			{name: 'ABIL_CODE'			,text: '직급'				,type: 'string', comboType:'AU',comboCode:'H006'},
			{name: 'JOIN_DATE'			,text: '입사일'			,type: 'uniDate'},
			{name: 'SEX_CODE'			,text: '성별'				,type: 'string'},
			{name: 'ANNUAL_SALARY_I'	,text: '연봉'				,type: 'uniPrice'},
			{name: 'WAGES_STD_I_TOT'	,text: '월지급액'			,type: 'uniPrice'},
			{name: 'AGRN_YN'			,text: '동의여부'			,type: 'string', comboType:'AU',comboCode:'B010'},
			{name: 'AGRN_DATE'			,text: '동의일자'			,type: 'uniDate'},
			{name: 'DECS_YN'			,text: '확정여부'			,type: 'string', comboType:'AU',comboCode:'B010'},
			{name: 'RMK'				,text: '비고'				,type: 'string'}
		]
	});
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	//1: 개인별
	var masterStore1 = Unilite.createStore('hbs700skrMasterStore1',{
		model	: 'hbs700skrModel1',
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
					read: 'hbs700skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();

			param.WORK_GB = '1'
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'PERSON_NUMB',
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
	
	//2: 연도별
	var masterStore2 = Unilite.createStore('hbs700skrMasterStore2',{
		model	: 'hbs700skrModel2',
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
					read: 'hbs700skrService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();

			param.WORK_GB = '2'
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'CNRC_YEAR',
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
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [
			{
                fieldLabel: '조회기준년도',
                name: 'CNRC_YEAR',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
//                    change: function(field, newValue, oldValue, eOpts) {                        
//                        panelResult.setValue('MERITS_YEARS', newValue - 1);   
//                    }
                }
			},  
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
//				textFieldWidth:89,
				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	//panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	//panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),

			{
				xtype		: 'component',
				width		: 200
			},
			
            Unilite.popup('Employee',{
            fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
            valueFieldName:'PERSON_NUMB',
            textFieldName:'NAME',
            validateBlank:false,
            autoPopup:true,
            listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
                            //panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
                            //panelResult.setValue('NAME', panelSearch.getValue('NAME'));                                                                                                             
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('PERSON_NUMB', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('NAME', newValue);                
                    }
                }
            }),
            
            {
                xtype: 'radiogroup',                            
                fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',                    
                items: [{
                    boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
                    width: 70, 
                    name: 'SEX_CODE',
                    inputValue: '',
                    checked: true  
                },{
                    boxLabel : '<t:message code="system.label.human.male" default="남"/>', 
                    width: 70,
                    name: 'SEX_CODE',
                    inputValue: 'M'
                },{
                    boxLabel: '<t:message code="system.label.human.female" default="여"/>', 
                    width: 70, 
                    name: 'SEX_CODE',
                    inputValue: 'F' 
                }]
            },
            
            {
                xtype: 'radiogroup',                            
                fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',           
                items: [{
                    boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: ''  
                },{
                    boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
                    width: 70,
                    name: 'RDO_TYPE',
                    inputValue: 'Z',
                    checked: true
                },{
                    boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: '00000000'  
                }]
            }
		]
	});
	
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	//1: 개인별
	var masterGrid1 = Unilite.createGrid('hbs700skrGrid1', {
		store	: masterStore1,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {	
			expandLastColumn	: true,			//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,			//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,			//찾기 버튼 사용 여부
			useRowContext		: false,			
			onLoadSelectFirst	: true,
			
			excel: {
				useExcel      : true,		//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			},
			
			filter: {							//필터 사용 여부
				useFilter	: true,
				autoCreate	: true
			}
		},
		
		features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true}
			//,{id: 'masterGrid1Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'PERSON_NUMB'		, width: 100,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계');
            	}
			
			},
			{ dataIndex: 'NAME'				, width: 90		},
			{ dataIndex: 'CNRC_YEAR'		, width: 100	},
			{ dataIndex: 'DEPT_CODE'		, width: 100	},
			{ dataIndex: 'DEPT_NAME'		, width: 180	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'ABIL_CODE'		, width: 110	},
			{ dataIndex: 'JOIN_DATE'		, width: 100	},
			{ dataIndex: 'SEX_CODE'			, width: 80		},
			
			{ dataIndex: 'ANNUAL_SALARY_I'	, width: 100	, summaryType: 'sum'},
			{ dataIndex: 'WAGES_STD_I_TOT'	, width: 100	, summaryType: 'sum'},
			{ dataIndex: 'AGRN_YN'			, width: 100	},
			{ dataIndex: 'AGRN_DATE'		, width: 100	},
			{ dataIndex: 'DECS_YN'			, width: 100	},
			{ dataIndex: 'RMK'				, width: 180	}
			
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});	
	
	//2: 연도별
	var masterGrid2 = Unilite.createGrid('hbs700skrGrid2', {
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
			{id: 'masterGrid2SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true}
			//,{id: 'masterGrid2Total',	ftype: 'uniSummary',		 showSummaryRow: false} 
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 110	, hidden: true},
			{ dataIndex: 'CNRC_YEAR'		, width: 100	,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계');
            	}
			
			},
			{ dataIndex: 'PERSON_NUMB'		, width: 100	},
			{ dataIndex: 'NAME'				, width: 90		},

			{ dataIndex: 'DEPT_CODE'		, width: 100	},
			{ dataIndex: 'DEPT_NAME'		, width: 180	},
			{ dataIndex: 'POST_CODE'		, width: 110	},
			{ dataIndex: 'ABIL_CODE'		, width: 110	},
			{ dataIndex: 'JOIN_DATE'		, width: 100	},
			{ dataIndex: 'SEX_CODE'			, width: 80		},
			
			{ dataIndex: 'ANNUAL_SALARY_I'	, width: 100	, summaryType: 'sum'},
			{ dataIndex: 'WAGES_STD_I_TOT'	, width: 100	, summaryType: 'sum'},
			{ dataIndex: 'AGRN_YN'			, width: 100	},
			{ dataIndex: 'AGRN_DATE'		, width: 100	},
			{ dataIndex: 'DECS_YN'			, width: 100	},
			{ dataIndex: 'RMK'				, width: 180	}
		] ,
		listeners:{
			uniOnChange: function(grid, dirty, eOpts) {
			}
		}
	});		
	
	
	var tab = Unilite.createTabPanel('hbs700skrTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '개인별',
				xtype	: 'container',
				itemId	: 'hbs700skrTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '연도별',
				xtype	: 'container',
				itemId	: 'hbs700skrTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard.getItemId() == 'hbs700skrTab1')	{
					masterStore1.loadStoreRecords();
				}else if(newCard.getItemId() == 'hbs700skrTab2') {
                    masterStore2.loadStoreRecords();
                }
			}
		}
	})
 
	
	Unilite.Main({
		id  : 'hbs700skrApp',
		borderItems:[{
		  region:'center',
		  layout: {type: 'vbox', align: 'stretch'},
		  border: false,
		  items:[
				panelResult, tab 
		  ]}
		], 
		fnInitBinding : function() {
			//초기값 설정
			panelResult.setValue('CNRC_YEAR', new Date().getFullYear());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('CNRC_YEAR');
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
			//1: 개인별
			if (activeTab == 'hbs700skrTab1'){
				masterStore1.loadStoreRecords();

			//2: 연도별
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
