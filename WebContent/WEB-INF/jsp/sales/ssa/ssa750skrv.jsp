<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa750skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa750skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->    
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */	    			
	Unilite.defineModel('ssa750skrvModel1', {
	    fields: [{name: 'DEPT_CODE'    			,text: '<t:message code="system.label.sales.department" default="부서"/>'		,type: 'string'},
	    		 {name: 'DEPT_NAME'				,text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'		,type: 'string'},
	    		 {name: 'PLAN_AMT_01'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_01'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_01'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_02'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_02'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_02'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_03'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_03'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_03'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_04'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_04'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_04'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_05'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_05'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_05'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_06'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_06'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_06'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_07'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_07'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_07'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_08'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_08'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_08'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_09'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_09'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_09'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_10'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_10'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_10'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_11'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_11'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_11'		,text: '달성율(%)'	,type: 'uniPercent'},
	    		 {name: 'PLAN_AMT_12'			,text: '계획'			,type: 'uniPrice'},
	    		 {name: 'SALE_AMT_12'			,text: '실적'			,type: 'uniPrice'},
	    		 {name: 'ACHIEVE_RATE_12'		,text: '달성율(%)'	,type: 'uniPercent'}
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa750skrvMasterStore1',{
		model: 'ssa750skrvModel1',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'ssa750skrvService.selectList1'                	
            }
        }
		,loadStoreRecords: function()	{			
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});			
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{	
        		xtype: 'container',
        		layout: {type: 'uniTable', columns:1},
        		items: [{
        			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        			name: 'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
        			allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
        		},{
				fieldLabel: '<t:message code="system.label.sales.salesyear" default="매출년도"/>',
				width: 170,
				name: 'SALE_YEAR',
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALE_YEAR', newValue);
					}
				}
			},
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
		                	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				})]	
			}]	            			 
		}],		
	    setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
    			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
    			allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
    		},{
				fieldLabel: '<t:message code="system.label.sales.salesyear" default="매출년도"/>',
				name: 'SALE_YEAR',
				width: 170,
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SALE_YEAR', newValue);
					}
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			})]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa750skrvGrid1', {
    	region: 'center',
    	uniOpt: {
			expandLastColumn: true,
		 	useRowNumberer: false,
		 	useContextMenu: true
        },    
		syncRowHeight: false,   
    	store: directMasterStore1,
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],
        columns:  [
        	{ dataIndex: 'DEPT_CODE'    					,	    	width: 100, locked: true },
        	{ dataIndex: 'DEPT_NAME'						,	    	width: 180, locked: true,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.totalamount" default="합계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{
				text:'<t:message code="system.label.sales.january" default="1월"/>',
           		columns:[ 
        			{ dataIndex: 'PLAN_AMT_01'						,	    	width: 100, summaryType:'sum' },
        			{ dataIndex: 'SALE_AMT_01'						,	    	width: 100, summaryType:'sum' },
        			{ dataIndex: 'ACHIEVE_RATE_01'					,	    	width: 70, summaryType:'average'}                
        		]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.february" default="2월"/>',                                                                                 
           		columns:[                                                                                  
        			{ dataIndex: 'PLAN_AMT_02'						,	    	width: 100, summaryType:'sum' },
        			{ dataIndex: 'SALE_AMT_02'						,	    	width: 100, summaryType:'sum' },
        			{ dataIndex: 'ACHIEVE_RATE_02'					,	    	width: 70, summaryType:'average' }                
        		]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.march" default="3월"/>',                                                                                 
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_03'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_03'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_03'					,	    	width: 70, summaryType:'average' }                
        	 	]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.april" default="4월"/>',                                                                                 
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_04'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_04'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_04'					,	    	width: 70, summaryType:'average' }                
        	 	]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.may" default="5월"/>',                                                                                 
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_05'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_05'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_05'					,	    	width: 70, summaryType:'average' }                
        	 	]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.june" default="6월"/>',                                                                                 
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_06'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_06'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_06'					,	    	width: 70, summaryType:'average' }                
        	 	]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.july" default="7월"/>',                                                                                 
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_07'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_07'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_07'					,	    	width: 70, summaryType:'average' }                
        	 	]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.august" default="8월"/>',                                                                                 
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_08'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_08'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_08'					,	    	width: 70, summaryType:'average' }                
        	 	]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.september" default="9월"/>',                                                                                 
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_09'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_09'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_09'					,	    	width: 70, summaryType:'average' }                
        	 	]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.october" default="10월"/>',                                                                                
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_10'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_10'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_10'					,	    	width: 70, summaryType:'average' }                
        	 	]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.november" default="11월"/>',                                                                                
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_11'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_11'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_11'					,	    	width: 70, summaryType:'average' }                
        	 	]                                                                                          
        	},{                                                                                            
				text:'<t:message code="system.label.sales.december" default="12월"/>',                                                                                
           		columns:[                                                                                  
		        	{ dataIndex: 'PLAN_AMT_12'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'SALE_AMT_12'						,	    	width: 100, summaryType:'sum' },
		        	{ dataIndex: 'ACHIEVE_RATE_12'					,	    	width: 70, summaryType:'average' }
		        ]
        	}
        ] 
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
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('SALE_YEAR', new Date().getFullYear());
//        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelResult.setValue('DEPT_NAME', UserInfo.deptName);
        	panelResult.setValue('SALE_YEAR', new Date().getFullYear());
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.loadStoreRecords();				
			
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);			
	
		},		
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});

};


</script>
