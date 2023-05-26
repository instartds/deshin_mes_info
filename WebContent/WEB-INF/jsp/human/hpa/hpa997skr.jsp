<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa997skr"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> 							<!-- 고용구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" />								<!-- 사원구분 -->
		<t:ExtComboStore comboType="BOR120"  />											<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa997skrModel', {		
	    fields: [{name: 'TITLE1'   		,text: 'TITLE1' 		,type: 'string'},	    		
				 {name: 'TITLE2'   	 	,text: 'TITLE2' 		,type: 'string'},	    		
				 {name: 'TOT_AMT'   	,text: 'TOT_AMT'		, type: 'float'		,decimalPrecision:3		, format:'0,000.00'},	    		
				 {name: 'REMARK'	 	,text: '비고' 			,type: 'string'},	    		
				 {name: 'NON_GUBUN'   	,text: 'NON_GUBUN'		,type: 'string'},	    		
				 {name: 'GUBUN'  		,text: 'GUBUN' 			,type: 'string'},	    		
				 {name: 'TOT_GUBUN'   	,text: 'TOT_GUBUN'		,type: 'string'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa997skrMasterStore',{
		model: 'Hpa997skrModel',
		uniOpt: {
           	isMaster	: true,				// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
	            	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'hpa997skrService.selectList'                	
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
			title: '기본정보',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items: [{ 
    			fieldLabel: '급여년월',
    			name:'PAY_YYYYMM',
				xtype: 'uniMonthfield',
				value: UniDate.get('today'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);			
						//그리드 컬럼명 세팅
						if (!Ext.isEmpty(panelSearch.getValue('PAY_YYYYMM'))){
							var setTextName = panelSearch.getValue('PAY_YYYYMM')
							setTextName = UniDate.getDbDateStr(setTextName).substring(4, 6) + '월'
							masterGrid.getColumn('TOT_AMT').setText(setTextName);
						}
					}
				}
			},{
		        fieldLabel: '사업장',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: false, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
			    listeners: {
			      change: function(field, newValue, oldValue, eOpts) {      
			       panelResult.setValue('DIV_CODE', newValue);
			      }
	     		}
			},{
	            fieldLabel: '고용구분',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_GUBUN', newValue);
			    	}
	     		}
	        },  
		        Unilite.popup('DEPT',{
		        fieldLabel: '부서',
			    valueFieldName:'DEPT_CODE_FR',
			    textFieldName:'DEPT_NAME_FR',
//		        validateBlank:false,  
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
			    valueFieldName:'DEPT_CODE_TO',
			    textFieldName:'DEPT_NAME_TO',
//		        validateBlank:false,  
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
		    }),{
                fieldLabel: '사원구분',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('EMPLOY_TYPE', newValue);
			    	}
	     		}
            },
		      	Unilite.popup('Employee',{
		      	fieldLabel : '사원',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
//			    validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));	
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					}
				}
      		})]
        }]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '급여년월',
			name:'PAY_YYYYMM',
			xtype: 'uniMonthfield',
			value: UniDate.get('today'),
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_YYYYMM', newValue);
					if (!Ext.isEmpty(panelResult.getValue('PAY_YYYYMM'))){
						//그리드 컬럼명 세팅
						var setTextName = panelResult.getValue('PAY_YYYYMM')
						setTextName = UniDate.getDbDateStr(setTextName).substring(4, 6) + '월'
						masterGrid.getColumn('TOT_AMT').setText(setTextName); 
					}
				}
			}
		},{
	        fieldLabel: '사업장',
		    name:'DIV_CODE', 
		    xtype: 'uniCombobox',
			multiSelect: false, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			colspan: 2,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('DIV_CODE', newValue);
		      }
     		}
		},{
            fieldLabel: '고용구분',
            name:'PAY_GUBUN', 	
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'H011',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_GUBUN', newValue);
		    	}
     		}
        },
	        Unilite.popup('DEPT',{
		        fieldLabel: '부서',
			    valueFieldName:'DEPT_CODE_FR',
			    textFieldName:'DEPT_NAME_FR',
//		        validateBlank:false,  
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
		        labelWidth: 13,
			    valueFieldName:'DEPT_CODE_TO',
			    textFieldName:'DEPT_NAME_TO',
//				validateBlank:false,  
				tdAttrs: {align : 'left'},
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
		    })
		,{
            fieldLabel: '사원구분',
            name:'EMPLOY_TYPE', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H024',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('EMPLOY_TYPE', newValue);
		    	}
     		}
        },
	      	Unilite.popup('Employee',{
	      	fieldLabel : '사원',
		    valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			colspan: 2,
//			validateBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));	
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				}
			}
  		})]
	});

	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa997skrGrid1', {
    	region		: 'center',
    	store: masterStore,
        selModel	: 'rowmodel',
        uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
    		filter: {
				useFilter		: false,
				autoCreate		: false
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
        columns:  [ { text:'구분',
						columns: [
		        			{ dataIndex:'TITLE1'		, width: 180		, text: '분류'},
							{ dataIndex:'TITLE2'		, width: 180		, text: '상세'}
						]
					},
					{ dataIndex:'TOT_AMT'		, width: 200},
					{ dataIndex:'REMARK'		, width: 400},
					{ dataIndex:'NON_GUBUN'		, width: 100	, hidden: true},
					{ dataIndex:'GUBUN'			, width: 130	, hidden: true},
					{ dataIndex:'TOT_GUBUN'		, width: 130	, hidden: true}
        ],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('TOT_GUBUN') == '99'){
		          	if(record.get('GUBUN') == '5'){
						cls = 'x-change-cell_normal';
					} else if(record.get('GUBUN') == '7') {
						cls = 'x-change-cell_dark';
					} else {
						cls = 'x-change-cell_light';
					}
				} 
				return cls;
	        }
	    }
    });      
	
	Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		], 
		id : 'hpa997skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('PAY_YYYYMM', UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM', UniDate.get('today'));
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);

			//그리드 컬럼명 세팅
			var setTextName = panelSearch.getValue('PAY_YYYYMM')
			setTextName = UniDate.getDbDateStr(setTextName).substring(4, 6) + '월'
			masterGrid.getColumn('TOT_AMT').setText(setTextName);  

			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{			
				masterGrid.reset();
				masterStore.clearData();
				masterGrid.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('reset',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		onSaveAsExcelButtonDown :function() {
			masterGrid.downloadExcelXml(false, '타이틀');
			masterGrid.getStore().groupField = null;
			masterGrid.getStore().load();
		},
		onPrintButtonDown : function() {
			//do something!!
		}
	});
};
</script>
