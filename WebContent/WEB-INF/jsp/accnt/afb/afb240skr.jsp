<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb240skr" >
	
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수

function appMain() {
	var columnName1 = '';
	var erTest		= 0;
	
	var deptList 	= ${deptList};
	var fields		= createModelField(deptList);
	var columns		= createGridColumn();
	/**
	 * Model 정의
	 * 
	 * @type
	 */

	Unilite.defineModel('Afb240skrModel', {
	    fields: fields
	});
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore = Unilite.createStore('afb240skrMasterStore',{
		model: 'Afb240skrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'afb240skrService.selectList'                	
            }
        }
		,loadStoreRecords : function(records) {
			var param= Ext.getCmp('searchForm').getValues();
			var deptList = [];
			for(i=0; i < records.length; i++) {
				deptList[i] = records[i].DEPT_CODE;
			}
			param.deptInfoList = deptList;
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * 
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{ 
    			fieldLabel: '예산년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'FR_BUDG_YYYYMM',
		        endFieldName: 'TO_BUDG_YYYYMM',
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        allowBlank:false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_BUDG_YYYYMM',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_BUDG_YYYYMM',newValue);
			    	}
			    }
	        },
		        Unilite.popup('DEPT', {
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE_FR', 
					textFieldName: 'DEPT_NAME_FR', 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE_FR'));
								panelResult.setValue('DEPT_NAME_FR', panelSearch.getValue('DEPT_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_FR', '');
							panelResult.setValue('DEPT_NAME_FR', '');
						}
					}
				}),
				Unilite.popup('DEPT',{ 
					fieldLabel: '~', 
					valueFieldName: 'DEPT_CODE_TO', 
					textFieldName: 'DEPT_NAME_TO', 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE_TO', panelSearch.getValue('DEPT_CODE_TO'));
								panelResult.setValue('DEPT_NAME_TO', panelSearch.getValue('DEPT_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE_TO', '');
							panelResult.setValue('DEPT_NAME_TO', '');
						}
					}
				}),
		    {
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',
				items: [{
					boxLabel: '과목', 
					width:  60, 
					name: 'ACCNT_DIVI', 
					inputValue: '1', 
					checked: true
				},{
					boxLabel: '세목', 
					width :60, 
					name: 'ACCNT_DIVI', 
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('ACCNT_DIVI').setValue(newValue.ACCNT_DIVI);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]		
		}]
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
    			fieldLabel: '예산년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'FR_BUDG_YYYYMM',
		        endFieldName: 'TO_BUDG_YYYYMM',
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        allowBlank:false,
		        colspan:3,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_BUDG_YYYYMM',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_BUDG_YYYYMM',newValue);
			    	}
			    }
	        },
		        Unilite.popup('DEPT', {
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE_FR', 
					textFieldName: 'DEPT_NAME_FR', 
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE_FR', panelResult.getValue('DEPT_CODE_FR'));
								panelSearch.setValue('DEPT_NAME_FR', panelResult.getValue('DEPT_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE_FR', '');
							panelSearch.setValue('DEPT_NAME_FR', '');
						}
					}
				}),
				Unilite.popup('DEPT',{ 
					fieldLabel: '~', 
					valueFieldName: 'DEPT_CODE_TO', 
					textFieldName: 'DEPT_NAME_TO', 
					labelWidth:10,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_TO'));
								panelSearch.setValue('DEPT_NAME_TO', panelResult.getValue('DEPT_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE_TO', '');
							panelSearch.setValue('DEPT_NAME_TO', '');
						}
					}
				}),
		    {
				xtype: 'radiogroup',		            		
				fieldLabel: '과목구분',
				items: [{
					boxLabel: '과목', 
					width: 60, 
					name: 'ACCNT_DIVI', 
					inputValue: '1', 
					checked: true
				},{
					boxLabel: '세목', 
					width: 60, 
					name: 'ACCNT_DIVI', 
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('ACCNT_DIVI').setValue(newValue.ACCNT_DIVI);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
    });		

    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
    
    var masterGrid = Unilite.createGrid('afb240skrGrid', {
        layout : 'fit',
        region:'center',
        excelTitle: '부서별예산실적조회',
        uniOpt : {					
			useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: true,			
		    dblClickToEdit		: false,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: true,	
		    filter: {				
				useFilter		: true,
				autoCreate		: true
			}			
		},
    	store: directMasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns:  columns,
		listeners: {
          	itemmouseenter:function(view, record, item, index, e, eOpts, column )	{ 
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{	
        	columnName = grid.eventPosition.column.dataIndex;
        	// 합계행 링크 제거
        	if(columnName == 'BUDG_TOT' || columnName == 'AMT_TOT' || columnName == 'DIFF_TOT' || columnName == 'RATE_TOT' || columnName == 'YEAR_BUDG'
        	|| columnName == 'DIVI' || columnName == 'ACCNT' || columnName == 'ACCNT_NAME'){
        		menu.down('#linkAgb110skr').hide();
        	}

        	columnName1 = columnName;
        	
        	// 합계행 링크 제거
        	if(record.get('DIVI') == '3') {
        		menu.down('#linkAgb110skr').hide();
        	}
        	
	      	return true;
	      	
      	},       
      	uniRowContextMenu:{
			items: [{	
	             	text: '보조부 이동',   
	             	itemId	: 'linkAgb110skr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb240(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAfb240:function(record)	{
			if(record)	{
				
				var temp = UniDate.getDbDateStr(panelSearch.getValue('TO_BUDG_YYYYMM')).substring(0, 6) + '01';
				var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
				var from_date = UniDate.getDbDateStr(panelSearch.getValue('FR_BUDG_YYYYMM')).substring(0, 6) + '01';
				var to_date   = UniDate.getDbDateStr(panelSearch.getValue('TO_BUDG_YYYYMM')).substring(0, 6) + lastDay;
						
				var startDay = UniDate.getDbDateStr(panelSearch.getValue('TO_BUDG_YYYYMM')).substring(0, 4) +  UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6);
				
				if(columnName1){
					var dept_code = columnName1.replace(/[^0-9]/g,'');  // 동적그리드 선택된 CODE
				}
				
				var param = {'DEPT_CODE' : dept_code, 'S_COMP_CODE' : UserInfo.compCode}
				
				afb240skrService.dept(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						var params = {
							action:'select',
							'PGM_ID'	 : 'afb240skr',
							'START_DATE' : startDay,
							'FR_DATE' 	 : from_date,	   
							'TO_DATE' 	 : to_date,	   
							'ACCNT_CODE' : record.data['ACCNT'],
							'ACCNT_NAME' : record.data['ACCNT_NAME'],
							'DIV_CODE'   : record.data['DIV_CODE'],
							'DEPT_CODE' : dept_code,
							'DEPT_NAME' : provider[0].DEPT_NAME
						}
						var rec = {data : {prgID : 'agb110skr', 'text':''}};									
						parent.openTab(rec, '/accnt/agb110skr.do', params);
					}
	  			}
  			)};
	    },
	    viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	        	if(record.get('DIVI') == '2'){
					cls = 'x-change-celltext_darkred';
					return cls;
				}
				
	          	if(record.get('DIVI') == '3') {
					cls = 'x-change-cell_normal';
				return cls;
	        	}
	        }
	    }
    });   
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],	
		id  : 'afb240skrApp',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_BUDG_YYYYMM');
			UniAppManager.setToolbarButtons('reset',true);
			panelSearch.setValue('FR_BUDG_YYYYMM',UniDate.get('today'));
			panelSearch.setValue('TO_BUDG_YYYYMM',UniDate.get('today'));
			panelResult.setValue('FR_BUDG_YYYYMM',UniDate.get('today'));
			panelResult.setValue('TO_BUDG_YYYYMM',UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{	
			erTest = 0;
			
			createStore_onQuery();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
		}
	});
	
	function createStore_onQuery() {		
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
	                read: 'afb240skrService.selectList'                	
	            }
	        },
			loadStoreRecords: function(records){
				var param= Ext.getCmp('searchForm').getValues();
				var deptList = [];
				for(i=0; i < records.length; i++) {
					deptList[i] = records[i].DEPT_CODE;
				}
				param.deptInfoList = deptList;
				console.log( param );
				this.load({
					params : param
				});
			},
			listeners: {
			}
		});
		var param= Ext.getCmp('searchForm').getValues();
		afb240skrService.getDeptList(param, function(provider, response) {
			var records = response.result;
			// 그리드 컬럼명 조건에 맞게 재 조회하여 입력
			var columns1 = createGridColumn(records);	
			store_onQuery.loadStoreRecords(records);
			masterGrid.setColumnInfo(masterGrid, columns1, fields);
			masterGrid.reconfigure(store_onQuery, columns1);
			masterGrid.setConfig ('useRowNumberer', false);
		});
	}
	
	function createModelField(deptList) {
		var fields = [  	  
	    	{name: 'DIVI' 			,text: '' 			,type: 'string'},
	    	{name: 'ACCNT' 			,text: '계정코드' 		,type: 'string'},
	    	{name: 'ACCNT_NAME' 	,text: '계정명' 		,type: 'string'},
	    	{name: 'YEAR_BUDG' 		,text: '연간예산' 		,type: 'uniPrice'},
	    	// 부서목록
	    	{name: 'BUDG_TOT' 		,text: '예산' 		,type: 'uniPrice'},
	    	{name: 'AMT_TOT' 		,text: '실적' 		,type: 'uniPrice'},
	    	{name: 'DIFF_TOT' 		,text: '차액' 		,type: 'uniPrice'},
	    	{name: 'RATE_TOT' 		,text: '달성률' 		,type: 'uniPercent'}
		] ;
					
		Ext.each(deptList, function(item, index) {
			fields.push({name: 'BUDG_' + item.DEPT_CODE, text:'예산', type:'uniPrice'})
			fields.push({name: 'AMT_' + item.DEPT_CODE, text:'실적', type:'uniPrice'})
			fields.push({name: 'DIFF_' + item.DEPT_CODE, text:'차액', type:'uniPrice'})
			fields.push({name: 'RATE_' + item.DEPT_CODE, text:'달성률', type:'uniPercent'})
		});
		console.log(fields);
		return fields;
	}
	
    // 그리드 컬럼 생성1
	function createGridColumn(records) {
		var columns = [   
			/*{ dataIndex: 'DIVI',					width: 80},*/
			Ext.applyIf({ dataIndex: 'ACCNT',		text: '계정코드'	, 				width: 80, style: 'text-align: center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            }, {align: 'center'}),
			{ dataIndex: 'ACCNT_NAME' 			,	text: '계정명', 				width: 160, 		 style: 'text-align: center'},
			Ext.applyIf({ dataIndex: 'YEAR_BUDG',	text: '연간예산', 				width: 120, 		 style: 'text-align: center', align: 'right', xtype:'uniNnumberColumn', format: '0,000'})	
		];
		// 쿼리읽어서 컬럼 셋팅
		Ext.each(records, function(item, index) {
			columns.push(
	      		{text: item.DEPT_NAME, 
	      			columns:[
	      				{dataIndex: 'BUDG_' + item.DEPT_CODE,	text: '예산',		width: 110, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: '0,000'},
						{dataIndex: 'AMT_' + item.DEPT_CODE,	text: '실적',		width: 110, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: '0,000'},
						{dataIndex: 'DIFF_' + item.DEPT_CODE,	text: '차액',		width: 110, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: '0,000'},
						{dataIndex: 'RATE_' + item.DEPT_CODE,	text: '달성률',	    width: 110, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Percent}
					]
			    }
			)
		});
		columns.push(
      		{text: '합계', 
      			columns:[
      				Ext.applyIf({dataIndex: 'BUDG_TOT',		text: '예산',		width: 110, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: '0,000'}),
		          	Ext.applyIf({dataIndex: 'AMT_TOT',		text: '실적',		width: 110, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: '0,000'}),
		          	Ext.applyIf({dataIndex: 'DIFF_TOT',		text: '차액',		width: 110, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: '0,000'}),
		          	Ext.applyIf({dataIndex: 'RATE_TOT',		text: '달성률',	width: 110, style: 'text-align: center', align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Percent})
		        ]
		    }
		);
		columns.push(
			Ext.applyIf({dataIndex: '',		text: '*',		flex: 1,		style: 'text-align: center',	align: 'right',minWidth:120, 
						resizable: false,	hideable:false,	sortable:false,	lockable:false,	menuDisabled: true,	draggable: false})
		)
		return columns;
	}
};


</script>
