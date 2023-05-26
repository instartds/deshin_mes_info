<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cam453skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="cam453skrv" /> 				<!-- 사업장 -->
	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
	<t:ExtComboStore comboType="AU" comboCode="CA06" />						<!-- 구분-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var wipYN = '${WIP_YN}';
var hideWipAmt = true;
if(wipYN == 'Y')	{
	hideWipAmt = false;
}
function appMain() {
   var cam453skrvModel=Unilite.defineModel('cam453skrvModel', {
   	fields: [
   			{name: 'ST_GB'	    		, text: '구분'   	    , type: 'string', comboType: 'AU', comboCode: 'CA09'},
	    	{name: 'PROD_ITEM_CODE'	    , text: '모품목코드'   	, type: 'string'},
	    	{name: 'PROD_ITEM_NAME'		, text: '모품목명'   	, type: 'string'},
	    	{name: 'PROD_ITEM_SPEC'		, text: '규격'    	, type: 'string'},
	    	{name: 'PRODT_Q'		    , text: '생산량'    	, type: 'uniQty'},
	    	{name: 'WIP_AMT'	    	, text: '재공'   		, type: 'uniPrice'},
	    	{name: 'MAT_DAMT_ONE'	    , text: '반제품'   	, type: 'uniPrice'},
	    	{name: 'MAT_DAMT_TWO'	    , text: '원자재'   	, type: 'uniPrice'},    	
	    	{name: 'MAT_IAMT_ONE'	    , text: '부자재'   	, type: 'uniPrice'},
	    	{name: 'MAT_IAMT_TWO'		, text: '공통재료비'    , type: 'uniPrice'},
	    	{name: 'LABOR_DAMT'	    	, text: '직접노무비'    , type: 'uniPrice'},
	    	{name: 'LABOR_IAMT'	    	, text: '간접노무비'    , type: 'uniPrice'},
	    	{name: 'EXPENSE_DAMT'	    , text: '직접경비'    	, type: 'uniPrice'},
	    	{name: 'EXPENSE_IAMT'	    , text: '간접경비'    	, type: 'uniPrice'},
	    	{name: 'TOTAL_AMT'	    	, text: '총계'    	, type: 'uniPrice'},
	    	{name: 'PER_UNIT_COST'	    , text: '단위당원가'    , type: 'uniPrice'}
		]
   });
   
   var cam453skrvStore=Unilite.createStore('Store', {	
   		model: 'cam453skrvModel',
		autoLoad: false,
		groupField : 'ST_GB',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read    : 'cam453skrvService.selectList'
				
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
         		 load:'cam453skrvService.selectWORK_SEQ'
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
           	layout: {type: 'uniTable', columns: 2},
           	defaultType: 'uniTextfield',
			items: [{ name: 'DIV_CODE', 
					fieldLabel: '사업장',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					value:UserInfo.divCode,
					hidden: false,
					colspan:2,
					editable:false,
					allowBlank:false,
					maxLength: 20,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
					}      
					,{ name: 'WORK_MONTH',
						fieldLabel: '기준월',
						xtype: 'uniMonthfield',
						value:UniDate.get('startOfMonth'),
						hidden: false,
						colspan:2,
						allowBlank:false,
						maxLength: 200,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('WORK_MONTH', newValue);
							}
						}
					}]
		},{
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[
								{ name: 'ITEM_ACCOUNT',
				        			fieldLabel: '모품목계정',
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
						  		,Unilite.popup('DIV_PUMOK',{
						  			fieldLabel: '품목코드',
						  			valueFieldName: 'PROD_ITEM_CODE',
						  			textFieldName: 'PROD_ITEM_NAME',
						  			colspan:2,
						  			listeners: {
						  				onSelected: {
											fn: function(records, type) {
												panelResult.setValue('PROD_ITEM_CODE', panelSearch.getValue('PROD_ITEM_CODE'));
												panelResult.setValue('PROD_ITEM_NAME', panelSearch.getValue('PROD_ITEM_NAME'));
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
						}
					}
        		},{ name: 'WORK_MONTH',
			  		fieldLabel: '기준월',
			  		xtype: 'uniMonthfield',
			  		value:UniDate.get('startOfMonth'),
			  		hidden: false,
			  		allowBlank:false,
			  		maxLength: 200,
			  		colspan:2,
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WORK_MONTH', newValue);
						}
					}
		  		}, { name: 'ITEM_ACCOUNT',
        			fieldLabel: '모품목계정',
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
		  		,Unilite.popup('DIV_PUMOK',{
		  			fieldLabel: '품목코드',
		  			valueFieldName: 'PROD_ITEM_CODE',
		  			textFieldName: 'PROD_ITEM_NAME',
		  			colspan:2,
		  			listeners: {
		  				onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PROD_ITEM_CODE', panelResult.getValue('PROD_ITEM_CODE'));
								panelSearch.setValue('PROD_ITEM_NAME', panelResult.getValue('PROD_ITEM_NAME'));
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
			expandLastColumn: false,
			state: {
				useState: false,		//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: cam453skrvStore,
        columns: [
        	{dataIndex: 'ST_GB'						, width: 100 },
        	{dataIndex: 'PROD_ITEM_CODE'			, width: 100 ,locked: false,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			{dataIndex: 'PROD_ITEM_NAME'			, width: 146 ,locked: false},
        	{dataIndex: 'PROD_ITEM_SPEC'			, width: 146 ,locked: false},
        	{dataIndex: 'PRODT_Q'					, width: 90,summaryType: 'sum' },
        	{dataIndex: 'WIP_AMT'					, width: 120,summaryType: 'sum' , hidden : hideWipAmt},
        	{text:'직접재료비',
        	 columns:[
        		 	 {dataIndex: 'MAT_DAMT_ONE'				, width: 120,summaryType: 'sum' },
        			 {dataIndex: 'MAT_DAMT_TWO'				, width: 120,summaryType: 'sum' },
        			 {dataIndex: 'MAT_IAMT_ONE'				, width: 120,summaryType: 'sum'}
        	 ]
        	},
        	{text:'간접재료비', dataIndex: 'MAT_IAMT_TWO'				, width: 120 ,summaryType: 'sum'},
        	{text:'노무비',
        	columns:[{dataIndex: 'LABOR_DAMT'				, width: 120,summaryType: 'sum'},
        			{dataIndex: 'LABOR_IAMT'				, width: 120 ,summaryType: 'sum'}
        			]
        	},
        	{text:'경비',
        	columns:[{dataIndex: 'EXPENSE_DAMT'				, width: 120,summaryType: 'sum'},
        			{dataIndex: 'EXPENSE_IAMT'				, width: 120 ,summaryType: 'sum'}
        			]
        	},
			{dataIndex: 'TOTAL_AMT'					, width: 120,  
				summaryType: 'count',
		        summaryRenderer: function(value, summaryData, dataIndex, metaData) {
		        	var wipAmt     = metaData.record.get("WIP_AMT"),
		        	    matDAmtOne = metaData.record.get("MAT_DAMT_ONE"),
	        	        matDAmtTwo = metaData.record.get("MAT_DAMT_TWO"),
		        		matIAmtOne = metaData.record.get("MAT_IAMT_ONE"),
		        	    matIAmtTwo = metaData.record.get("MAT_IAMT_TWO"),
		        	    laborDAmt = metaData.record.get("LABOR_DAMT"),
		        	    laborIAmt = metaData.record.get("LABOR_IAMT"),
		        	    expenseDAmt = metaData.record.get("EXPENSE_DAMT"),
		        	    expenseIAmt= metaData.record.get("EXPENSE_IAMT");
		        	var sAmt ;
		        	if(!hideWipAmt) {
		        		sAmt = Ext.util.Format.number((wipAmt + matDAmtOne + matDAmtTwo + matIAmtOne + matIAmtTwo + laborDAmt + laborIAmt + expenseDAmt + expenseIAmt) , UniFormat.Price);
		        	} else if(hideWipAmt) {
		        		sAmt = Ext.util.Format.number((matDAmtOne + matDAmtTwo + matIAmtOne + matIAmtTwo + laborDAmt + laborIAmt + expenseDAmt + expenseIAmt) , UniFormat.Price);
		        	} else {
		        		sAmt = 0;
		        	}
		            return sAmt ;
		            //return Ext.util.Format.number((wipAmt + matDAmtOne + matDAmtTwo + matIAmtOne + matIAmtTwo + laborDAmt + laborIAmt + expenseDAmt + expenseIAmt) , UniFormat.Price);
		        }
		    },
			{dataIndex: 'PER_UNIT_COST'				, width: 120,  
				summaryType: 'count',
		        summaryRenderer: function(value, summaryData, dataIndex, metaData) {
		        	var wipAmt     = metaData.record.get("WIP_AMT"),
	        	        matDAmtOne = metaData.record.get("MAT_DAMT_ONE"),
		        	    matDAmtTwo = metaData.record.get("MAT_DAMT_TWO"),
		        		matIAmtOne = metaData.record.get("MAT_IAMT_ONE"),
		        	    matIAmtTwo = metaData.record.get("MAT_IAMT_TWO"),
		        	    laborDAmt = metaData.record.get("LABOR_DAMT"),
		        	    laborIAmt = metaData.record.get("LABOR_IAMT"),
		        	    expenseDAmt = metaData.record.get("EXPENSE_DAMT"),
		        	    expenseIAmt= metaData.record.get("EXPENSE_IAMT"),
		        	    prodtQ = metaData.record.get("PRODT_Q");
		        	var sAmt ;
		        	if(prodtQ && prodtQ > 0 && !hideWipAmt) {
		        		sAmt = Ext.util.Format.number(((wipAmt + matDAmtOne + matDAmtTwo + matIAmtOne + matIAmtTwo + laborDAmt + laborIAmt + expenseDAmt + expenseIAmt) / prodtQ), UniFormat.Price);
		        	} else if(prodtQ && prodtQ > 0 && hideWipAmt) {
		        		sAmt = Ext.util.Format.number(((matDAmtOne + matDAmtTwo + matIAmtOne + matIAmtTwo + laborDAmt + laborIAmt + expenseDAmt + expenseIAmt) / prodtQ), UniFormat.Price);
		        	} else {
		        		sAmt = 0;
		        	}
		            return sAmt ;
		        }
			}
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
		id: 'cam453skrvApp',
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
			masterGrid.loadData({});
			panelResult.clearForm();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	
	/* 용		도	:	총계/단위당원가 계산해서 DISPLAY */
	function fnTotalAmtSet(){
		var dAmt1=0,dAmt2=0,dAmt3=0,dAmt4=0,dAmt5=0,dAmt6=0,dAmt7=0,dAmt8=0,dAmt9=0,dInoutQ=0,dTotAmt=0,dPerUnitCost=0;
		 var store = masterGrid.getStore();
		 var count = store.getCount();
		 for (var i = 0; i < count; i++) {
		  var record = store.getAt(i);
		  dAmt1=record.data.MAT_DAMT_ONE;
		  dAmt2=record.data.MAT_DAMT_TWO;
		  dAmt3=record.data.MAT_IAMT_ONE;
		  dAmt4=record.data.MAT_IAMT_TWO;
		  dAmt5=record.data.LABOR_DAMT;
		  dAmt6=record.data.LABOR_IAMT;
		  dAmt7=record.data.EXPENSE_DAMT;
		  dAmt8=record.data.EXPENSE_IAMT;
		  dTotAmt=dAmt1+dAmt2+dAmt3+dAmt4+dAmt5+dAmt6+dAmt7+dAmt8+dAmt9;
		  dTotAmt=decimal(dTotAmt,2);
		  record.data.TOTAL_AMT=dTotAmt;
		  dInoutQ=record.data.PRODT_Q;
		  dPerUnitCost=dTotAmt/dInoutQ;
		  dPerUnitCost=decimal(dPerUnitCost,2);
		  record.data.PER_UNIT_COST=dPerUnitCost;
		  record.commit();
		 }
		 console.log("masterGrid:",masterGrid);
	}
	function decimal(num,v){
	var vv = Math.pow(10,v);
	return Math.round(num*vv)/vv;
	}
    
};
</script>