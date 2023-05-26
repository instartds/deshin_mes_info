<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cam451skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="cam451skrv" /> 				<!-- 사업장 -->
	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
	<t:ExtComboStore comboType="AU" comboCode="CA09" />  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var yearEvaluationYN = '${YEAR_EVALUATION_YN}';
var workMonthFr 	 = '${WORK_MONTH_FR}';

function appMain() {
   var cam451skrvModel=Unilite.defineModel('cam451skrvModel', {
   	fields: [
   			{name: 'COST_POOL_CODE'	    		, text: '부문코드'    		, type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'COST_POOL_NAME'	    			, text: '부문'    		, type: 'string'},
   			{name: 'ITEM_ACCOUNT'	    			, text: '품목계정'    		, type: 'string', comboType:'AU', comboCode:'B020'},
   			{name: 'PROD_TYPE'	    				, text: '생산구분'    		, type: 'string', comboType:'AU', comboCode:'CA09'},
	    	{name: 'PROD_ITEM_CODE'	    			, text: '품목코드'    		, type: 'string'},
	    	{name: 'PROD_ITEM_NAME'		    		, text: '품목명'   		, type: 'string'},
	    	{name: 'PROD_ITEM_SPEC'		    		, text: '규격'    		, type: 'string'},
	    	{name: 'PRODT_Q'		    			, text: '생산량'    		, type: 'uniQty'},
	    	{name: 'MAN_HOUR'		    			, text: '투입공수'    		, type: 'float', format:'0,000.00'},
	    	{name: 'MAT_DAMT_ONE'	    			, text: '재공/반제품'   	, type: 'uniPrice'},
	    	{name: 'MAT_DAMT_TWO'	    			, text: '원자재'   	    , type: 'uniPrice'},    	
	    	{name: 'MAT_IAMT_ONE'	    			, text: '부자재'   		, type: 'uniPrice'},
            {name: 'WORK_PROGRESS_MONTH'	    	, text: '당월완성률'   	, type: 'uniPercent'},
	    	{name: 'WORK_PROGRESS'	    			, text: '누적완성률'   	, type: 'uniPercent'},
	    	{name: 'MAN_HOUR_RATE'	    			, text: '투입비율(OH)'   	, type: 'float', format:'0,000.000000'},
	    	{name: 'MAT_DAMT_TWO_RATE'	    		, text: '투입비율(M)'   	, type: 'float', format:'0,000.000000'},
	    	{name: 'MAT_IAMT_TWO_RATE'	    		, text: '투입비율(S)'   	, type: 'float', format:'0,000.000000'},
	    	{name: 'MAT_IAMT_TWO'	    			, text: '간접재료비'    	, type: 'uniPrice'},
	    	{name: 'LABOR_DAMT'	    				, text: '직접노무비'    	, type: 'uniPrice'},
	    	{name: 'LABOR_IAMT'	    				, text: '간접노무비'    	, type: 'uniPrice'},
	    	{name: 'EXPENSE_DAMT'	    			, text: '직접경비'    		, type: 'uniPrice'},
	    	{name: 'EXPENSE_IAMT'	    			, text: '간접경비'    		, type: 'uniPrice'},
	    	{name: 'EXPENSE_FAMT'	    			, text: '외주가공비'    	, type: 'uniPrice'},
	    	{name: 'TOTAL_AMT'	    				, text: '총계'    		, type: 'uniPrice'},
	    	{name: 'PER_UNIT_COST'	    			, text: '단위당원가'    	, type: 'uniPrice'}
		]
   });
   
   var cam451skrvStore=Unilite.createStore('Store', {	
   		model: 'cam451skrvModel',
		autoLoad: false,
		groupField : 'COST_POOL_NAME',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read    : 'cam451skrvService.selectList'
				
			}
		},
		loadStoreRecords : function()	{
			var param= panelResult.getValues();	
			
			//var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			//var deptCode = UserInfo.deptCode;	//부서코드
			/*if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}*/
			console.log("param", param);
			this.load({
				params : param
			});
		},
		listeners:{
				load: function(store, records, successful, eOpts){
					
				}
			}
   });
   /**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		api: {
         		 load:'cam451skrvService.selectWORK_SEQ'
				},
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
			items: [{ name: 'DIV_CODE', 
					fieldLabel: '사업장',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					value:UserInfo.divCode,
					hidden: false,
					editable:false,
					allowBlank:false,
					maxLength: 20,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
							UniAppManager.app.setWorkMonthFrText(newValue, panelSearch.getValue("WORK_MONTH"));
						}
					}
					}      
					,{ name: 'WORK_MONTH',
						fieldLabel: '기준월',
						xtype: 'uniMonthfield',
						value:UniDate.get('startOfMonth'),
						hidden: false,
						allowBlank:false,
						maxLength: 200,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('WORK_MONTH', newValue);
								UniAppManager.app.setWorkMonthFrText(panelSearch.getValue("DIV_CODE"), newValue);
							}
						}
					},{
						xtype:'component',
						itemId : 'workMonthFrComponent',
						style:{'padding-left':'95px'},
						html:'(시작년월 : '+workMonthFr+')',
						hidden : (yearEvaluationYN == 'Y' && workMonthFr !='') ? false : true
					}]
		},{
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[
								{ name: 'ITEM_ACCOUNT',
				        			fieldLabel: '품목계정',
				        			xtype: 'uniCombobox',
				        			comboType: '0',
				        			comboCode:'B020',
				        			hidden: false,
				        			maxLength: 20,
				        			listeners: {
										change: function(field, newValue, oldValue, eOpts) {						
											panelResult.setValue('ITEM_ACCOUNT', newValue);
										}
									}
				        		}      
						  		,Unilite.popup('DIV_PUMOK',{ // 20210819 수정: 품목코드 팝업창 정규화
						  			fieldLabel: '품목코드',
						  			valueFieldName: 'PROD_ITEM_CODE',
						  			textFieldName: 'PROD_ITEM_NAME',
						  			colspan: 2,
						  			validateBlank: false,
						  			listeners: {
										onValueFieldChange: function( elm, newValue, oldValue ) {
											panelResult.setValue('PROD_ITEM_CODE', newValue);
											if(!Ext.isObject(oldValue)) {
												panelResult.setValue('PROD_ITEM_NAME', '');
												panelSearch.setValue('PROD_ITEM_NAME', '');
											}
										},
										onTextFieldChange: function( elm, newValue, oldValue ) {
											panelResult.setValue('PROD_ITEM_NAME', newValue);
											if(!Ext.isObject(oldValue)) {
												panelResult.setValue('PROD_ITEM_CODE', '');
												panelSearch.setValue('PROD_ITEM_CODE', '');
											}
										},
						  				applyextparam: function(popup){							
										popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),'FIND_TYPE':'00'});
									}
						  			}
						  		})      
						  		,{ name: 'ITEM_LEVEL1', 
						  			fieldLabel: '대분류' 		,
						  			maxLength: 200,
						  			xtype: 'uniCombobox',
				            		store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				            		child: 'ITEM_LEVEL2',
				            		listeners: {
					            		change: function(field, newValue, oldValue, eOpts) {
												panelResult.setValue('ITEM_LEVEL1', newValue);
										}
				            		}
				            	 }       
						  		,{ name: 'ITEM_LEVEL2',
						  			fieldLabel: '중분류' 		,
						  			maxLength: 200,
						  		 	xtype: 'uniCombobox',
									store: Ext.data.StoreManager.lookup('itemLeve2Store'),
									child: 'ITEM_LEVEL3',
				            		listeners: {
					            		change: function(field, newValue, oldValue, eOpts) {						
												panelResult.setValue('ITEM_LEVEL2', newValue);
										}
						  			}
						  		 }   
						  		,{ name: 'ITEM_LEVEL3',
							  		fieldLabel: '소분류',
							  		xtype:'uniCombobox',
							  		store: Ext.data.StoreManager.lookup('itemLeve3Store')
							  		,
							  		listeners: {
					            		change: function(field, newValue, oldValue, eOpts) {						
												panelResult.setValue('ITEM_LEVEL3', newValue);
										}
							  		}
							  	}				
				]
		}
		
		],
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
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout: {type: 'uniTable', columns: 3, tableAttrs:{cellpadding:3}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
		padding: '0 0 0 1',
		border:true,
		items: [ { name: 'DIV_CODE',
        			fieldLabel: '사업장',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
        			value:UserInfo.divCode,
        			hidden: false,
        			editable:false,
        			allowBlank:false,
        			maxLength: 20,
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
							UniAppManager.app.setWorkMonthFrText(newValue, panelSearch.getValue("WORK_MONTH"));
						}
					}
        		},{ name: 'WORK_MONTH',
			  		fieldLabel: '기준월',
			  		xtype: 'uniMonthfield',
			  		value:UniDate.get('startOfMonth'),
			  		hidden: false,
			  		allowBlank:false,
			  		maxLength: 200,
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WORK_MONTH', newValue);
							UniAppManager.app.setWorkMonthFrText(panelSearch.getValue("DIV_CODE"), newValue);
						}
					}
		  		},{
		  			xtype : 'container',
		  			items : [
			  			{
							xtype:'component',
							itemId : 'workMonthFrComponent',
							html:'(시작년월 : '+workMonthFr+')',
							style:{'padding-left' :'10px'},
							hidden : (yearEvaluationYN == 'Y' && workMonthFr != '') ? false : true
						}
		  			]
		  		} , { name: 'ITEM_ACCOUNT',
        			fieldLabel: '품목계정',
        			xtype: 'uniCombobox',
        			comboType: '0',
        			comboCode:'B020',
        			hidden: false,
        			maxLength: 20,
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
        		}      
		  		,Unilite.popup('DIV_PUMOK',{ // 20210819 수정: 품목코드 팝업창 정규화
		  			fieldLabel: '품목코드',
		  			valueFieldName: 'PROD_ITEM_CODE',
		  			textFieldName: 'PROD_ITEM_NAME',
		  			colspan: 2,
		  			validateBlank: false,
		  			listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('PROD_ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('PROD_ITEM_NAME', '');
								panelSearch.setValue('PROD_ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelSearch.setValue('PROD_ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('PROD_ITEM_CODE', '');
								panelSearch.setValue('PROD_ITEM_CODE', '');
							}
						},
		  				applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),'FIND_TYPE':'00'});
					}
		  			}
		  		})      
		  		,{ name: 'ITEM_LEVEL1', 
		  			fieldLabel: '대분류' 		,
		  			maxLength: 200,
		  			xtype: 'uniCombobox',
            		store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
            		child: 'ITEM_LEVEL2',
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_LEVEL1', newValue);
						}
					}
            	 }       
		  		,{ name: 'ITEM_LEVEL2',
		  			fieldLabel: '중분류' 		,
		  			maxLength: 200,
		  		 	xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'ITEM_LEVEL3',
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_LEVEL2', newValue);
						}
					}
		  		 }   
		  		,{ name: 'ITEM_LEVEL3',
			  		fieldLabel: '소분류',
			  		xtype:'uniCombobox',
			  		store: Ext.data.StoreManager.lookup('itemLeve3Store'),
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_LEVEL3', newValue);
						}
					}
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
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
    });		
	 /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('tio110skrvGrid1', {
		layout: 'fit',
		region: 'center',
		//excelTitle: '발주현황조회',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,state: {
				useState: false,		//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },/*
        viewConfig:{
        		forceFit : true,
                stripeRows: false,//是否隔行换色
                getRowClass : function(record,rowIndex,rowParams,store){
                	var cls = '';
                    if(record.get('PROD_ITEM_CODE')=="총계"){
                    	cls = 'x-change-cell_Background_essRow';	
                    }
                    return cls;
                }
            },*/
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: cam451skrvStore,
        columns: [
        	{dataIndex: 'COST_POOL_NAME'			, width: 150 },
        	{dataIndex: 'ITEM_ACCOUNT'				, width: 70 },
        	{dataIndex: 'PROD_TYPE'					, width: 100 },
        	{dataIndex: 'PROD_ITEM_CODE'			, width: 100 ,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
			{dataIndex: 'PROD_ITEM_NAME'			, width: 120 },
        	{dataIndex: 'PROD_ITEM_SPEC'			, width: 150 },
        	{dataIndex: 'PRODT_Q'					, width: 70,summaryType: 'sum'},
        	{dataIndex: 'MAN_HOUR'					, width: 80,summaryType: 'sum' 
        		,summaryRenderer: function(value, summaryData, dataIndex, metaData) {
		            return Ext.util.Format.number(value , '0,000.00');
		        }
        	 },
        	{text:'직접재료비',
        	 columns:[{dataIndex: 'MAT_DAMT_ONE'				, width: 90,summaryType: 'sum' },
        			 {dataIndex: 'MAT_DAMT_TWO'				, width: 90,summaryType: 'sum'  },
        			 {dataIndex: 'MAT_IAMT_ONE'				, width: 90,summaryType: 'sum'}
        	 ]
        	},
 	    	{dataIndex: 'WORK_PROGRESS_MONTH'		, width: 90 },
        	{dataIndex: 'WORK_PROGRESS'				, width: 90 },
        	{dataIndex: 'MAN_HOUR_RATE'				, width: 100 ,summaryType: 'sum'
        		,summaryRenderer: function(value, summaryData, dataIndex, metaData) {
        			if(Unilite.isGrandSummaryRow(summaryData, metaData)) {
            			return '';
        			}else {
        				return Ext.util.Format.number(Ext.Number.toFixed(value, 2), '0,000.000000');;
        			}
         		}
    		},
        	{dataIndex: 'MAT_DAMT_TWO_RATE'			, width: 100 ,summaryType: 'sum'
        		,summaryRenderer: function(value, summaryData, dataIndex, metaData) {
        			if(Unilite.isGrandSummaryRow(summaryData, metaData)) {
            			return '';
        			}else {
        				return Ext.util.Format.number(Ext.Number.toFixed(value, 2), '0,000.000000');
        			}
	         	}
        	},
        	{dataIndex: 'MAT_IAMT_TWO_RATE'			, width: 100 ,summaryType: 'sum'
        		,summaryRenderer: function(value, summaryData, dataIndex, metaData) {
        			if(Unilite.isGrandSummaryRow(summaryData, metaData)) {
            			return '';
        			}else {
        				return Ext.util.Format.number(Ext.Number.toFixed(value, 2), '0,000.000000');
        			}
	         	}
        	},
        	{dataIndex: 'MAT_IAMT_TWO'				, width: 90 ,summaryType: 'sum'},
        	{text:'노무비',
        		columns:[
        			{dataIndex: 'LABOR_DAMT'				, width: 90,summaryType: 'sum'},
        			{dataIndex: 'LABOR_IAMT'				, width: 90 ,summaryType: 'sum'}
        		]
        	},
        	{text:'경비',
        		columns:[
        			{dataIndex: 'EXPENSE_DAMT'				, width: 90,summaryType: 'sum'},
        			{dataIndex: 'EXPENSE_IAMT'				, width: 90 ,summaryType: 'sum'},
        			{dataIndex: 'EXPENSE_FAMT'				, width: 90,summaryType: 'sum' }
        		]
        	},
			{dataIndex: 'TOTAL_AMT'					, width: 90,  summaryType: 'sum'},
			{dataIndex: 'PER_UNIT_COST'				, width: 90}
		] 
    }); 
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,panelResult
			]
		},
			panelSearch  	
		],
		id: 'cam451skrvApp',
		fnInitBinding: function(param) {
			if(param && param.DIV_CODE)	{
				panelResult.setValue("DIV_CODE",param.DIV_CODE);
				panelResult.setValue("WORK_MONTH",param.WORK_MONTH);
				panelSearch.setValue("DIV_CODE",param.DIV_CODE);
				panelSearch.setValue("WORK_MONTH",param.WORK_MONTH);
			}
		},
		onQueryButtonDown: function() {	
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
			 	masterGrid.getStore().loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.getStore().loadData({});
			panelResult.clearForm();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        setWorkMonthFrText : function(divCode, workMonth )	{
        	var com1 = panelSearch.down('#workMonthFrComponent');
			var com2 = panelResult.down('#workMonthFrComponent');
			var comArray = [com1, com2];
			if(Ext.isEmpty(workMonth))	{
				workMonth =  panelSearch.getValue("WORK_MONTH");
			}
        	UniCost.setMorhFrText(divCode,workMonth, comArray)
        }
	});
    
};
</script>