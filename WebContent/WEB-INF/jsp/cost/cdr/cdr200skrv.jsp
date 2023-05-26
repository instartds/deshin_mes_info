<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cdr200skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="cdr200skrv" /> 				<!-- 사업장 -->
	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
   var cdr200skrvModel=Unilite.defineModel('cdr200skrvModel', {
   	fields: [
	    	{name: 'PROD_ITEM_CODE'	    			, text: '모품목코드'    	, type: 'string'},
	    	{name: 'PROD_ITEM_NAME'		    		, text: '모품목명'   		, type: 'string'},
	    	{name: 'PROD_ITEM_SPEC'		    		, text: '규격'    			, type: 'string'},
	    	{name: 'PRODT_Q'		    			, text: '생산량'    		, type: 'uniQty'},
	    	{name: 'MAT_DAMT_ONE'	    			, text: '재공/반제품'   	, type: 'uniPrice'},
	    	{name: 'MAT_DAMT_TWO'	    			, text: '원자재'   	    	, type: 'uniPrice'},    	
	    	{name: 'MAT_IAMT_ONE'	    			, text: '부자재'   			, type: 'uniPrice'},
	    	{name: 'MAT_IAMT_TWO'		    		, text: '공통재료비'      	, type: 'uniPrice'},
	    	{name: 'LABOR_DAMT'	    				, text: '직접노무비'    	, type: 'uniPrice'},
	    	{name: 'LABOR_IAMT'	    				, text: '간접노무비'    	, type: 'uniPrice'},
	    	{name: 'EXPENSE_DAMT'	    			, text: '직접경비'    		, type: 'uniPrice'},
	    	{name: 'EXPENSE_IAMT'	    			, text: '간접경비'    		, type: 'uniPrice'},
	    	{name: 'OUTPRODT_AMT'	    			, text: '외주가공비'    	, type: 'uniPrice'},
	    	{name: 'TOTAL_AMT'	    				, text: '총계'    			, type: 'uniPrice'},
	    	{name: 'PER_UNIT_COST'	    			, text: '단위당원가'    	, type: 'uniPrice'}
		]
   });
   
   var cdr200skrvStore=Unilite.createStore('Store', {	
   		model: 'cdr200skrvModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read    : 'cdr200skrvService.selectList'
				
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
		groupField:'',
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
         		 load:'cdr200skrvService.selectWORK_SEQ'
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
							alert(panelResult.getValue("DIV_CODE"));
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
					}        
					,{ name: 'WORK_SEQ',
					fieldLabel: '작업회수',
					hidden: false,
					allowBlank:false,
					maxLength: 200,
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WORK_SEQ', newValue);
						}
					}
					},{ name: 'LAST_WORK_SEQ',
					width:120,
					xtype:'uniNumberfield',
					margin:'0 0 3 -70',
					fieldLabel: '/',
					readOnly:true,
					hidden: false,
					maxLength: 200,
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue.lenght>3){
									return oldValue;
							}
							panelResult.setValue('LAST_WORK_SEQ', newValue);
						}
					}
				}  
					]
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
				        			editable:false,
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
		layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:3,width:'100%'}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
		padding: '0 0 0 1',
		border:true,
		items: [{ 
        			 defaultType: 'uniTextfield'
        			, layout: { type: 'uniTable', columns: 4}
        			, height: 30
        			, items :[	 { name: 'DIV_CODE',
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
											panelSearch.setValue('WORK_MONTH', newValue);
										}
									}
						  		}        
						  		,{ name: 'WORK_SEQ',
							  		fieldLabel: '작업회수',
							  		hidden: false,
							  		allowBlank:false,
							  		maxLength: 200,
				        			listeners: {
										change: function(field, newValue, oldValue, eOpts) {						
											panelSearch.setValue('WORK_SEQ', newValue);
										}
									}
						  		},{ name: 'LAST_WORK_SEQ',
						  			width:110,
						  			xtype:'uniNumberfield',
						  			margin:'0 0 3 -70',
							  		fieldLabel: '/',
							  		readOnly:true,
							  		hidden: false,
							  		maxLength: 200,
				        			listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											if(newValue.lenght>3){
												return oldValue;
											}
											panelSearch.setValue('LAST_WORK_SEQ', newValue);
										}
									}
						  		}       
					         ]
	    		},{ 
        			 defaultType: 'uniTextfield'
        			, layout: { type: 'uniTable', columns: 3}
        			, height: 60
        			, items :[	 { name: 'ITEM_ACCOUNT',
				        			fieldLabel: '모품목계정',
				        			xtype: 'uniCombobox',
				        			comboType: '0',
				        			comboCode:'B020',
				        			hidden: false,
				        			editable:false,
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
							  	
							  	}     
						  		]
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
		excelTitle: '발주현황조회',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
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
    	store: cdr200skrvStore,
        columns: [
        	{dataIndex: 'PROD_ITEM_CODE'			, width: 146 ,locked: true,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
			{dataIndex: 'PROD_ITEM_NAME'			, width: 146 ,locked: true},
        	{dataIndex: 'PROD_ITEM_SPEC'			, width: 146 ,locked: true},
        	{dataIndex: 'PRODT_Q'					, width: 146,summaryType: 'sum' },
        	{text:'직접재료비',
        	columns:[{dataIndex: 'MAT_DAMT_ONE'				, width: 146,summaryType: 'sum' },
        			{dataIndex: 'MAT_DAMT_TWO'				, width: 146,summaryType: 'sum'  }
        			]
        	},
        	{text:'간접재료비',
        	columns:[{dataIndex: 'MAT_IAMT_ONE'				, width: 146,summaryType: 'sum'},
        			{dataIndex: 'MAT_IAMT_TWO'				, width: 146 ,summaryType: 'sum'}
        			]
        	},
        	{text:'노무비',
        	columns:[{dataIndex: 'LABOR_DAMT'				, width: 146,summaryType: 'sum'},
        			{dataIndex: 'LABOR_IAMT'				, width: 146 ,summaryType: 'sum'}
        			]
        	},
        	{text:'경비',
        	columns:[{dataIndex: 'EXPENSE_DAMT'				, width: 146,summaryType: 'sum'},
        			{dataIndex: 'EXPENSE_IAMT'				, width: 146 ,summaryType: 'sum'}
        			]
        	},
			{dataIndex: 'OUTPRODT_AMT'				, width: 146,summaryType: 'sum' },
			{dataIndex: 'TOTAL_AMT'					, width: 146,summaryType: 'sum'},
			{dataIndex: 'PER_UNIT_COST'				, width: 200,summaryType: 'average' }
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
		id: 'cdr200skrvApp',
		fnInitBinding: function() {
			getLast_WORK_SEQ();
		},
		onQueryButtonDown: function() {	
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			/*masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);*/
			 masterGrid.getStore().loadStoreRecords();
			 getLast_WORK_SEQ();
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	
	function getLast_WORK_SEQ(){
		var param= panelResult.getValues();	
			panelSearch.getForm().load({
					params: param,
					success:function(actionform, action)	{
						console.log("action:",action);
						panelSearch.setValue("LAST_WORK_SEQ",action.result.data.LAST_WORK_SEQ);
						panelResult.setValue("LAST_WORK_SEQ",action.result.data.LAST_WORK_SEQ);
						fnTotalAmtSet();
						panelSearch.uniOpt.inLoading=false;
						Ext.getBody().unmask();
					},
					 failure: function(batch, option) {
					 	console.log("option:",option);
					 	if(option.response!=null){
					 	panelSearch.setValue("LAST_WORK_SEQ",option.result.LAST_WORK_SEQ);
						panelResult.setValue("LAST_WORK_SEQ",option.result.LAST_WORK_SEQ);
						fnTotalAmtSet();
					 	}else{
					 	panelSearch.setValue("WORK_SEQ",0);
						panelResult.setValue("WORK_SEQ",0);
					 	panelSearch.setValue("LAST_WORK_SEQ",0);
						panelResult.setValue("LAST_WORK_SEQ",0);
					 	}
					 	panelSearch.uniOpt.inLoading=false;
					 	Ext.getBody().unmask();					 
					 }
				});
	}
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
		  dAmt9=record.data.OUTPRODT_AMT;
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