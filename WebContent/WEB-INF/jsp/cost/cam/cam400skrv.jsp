<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cam400skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="cam400skrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="CA06" />						<!-- 구분-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var yearEvaluationYN = '${YEAR_EVALUATION_YN}';
var workMonthFr 	 = '${WORK_MONTH_FR}';
function appMain() {
   var cam400skrvModel=Unilite.defineModel('cam400skrvModel', {
   	fields: [
	    	{name: 'PROD_ITEM_CODE'	    			, text: '모품목코드'    	, type: 'string'},
	    	{name: 'PROD_ITEM_NAME'		    		, text: '모품목명'   	, type: 'string'},
	    	{name: 'PROD_ITEM_SPEC'		    		, text: '규격'    		, type: 'string'},
	    	{name: 'PRODT_Q'		    			, text: '생산입고'    	, type: 'uniQty'},
	    	{name: 'ITEM_CODE'	    				, text: '자품목코드'   	, type: 'string'},
	    	{name: 'ITEM_NAME'	    				, text: '자품목명'   	, type: 'string'},   
	    	{name: 'ST_GB'	    					, text: '구분'   	    , type: 'string', comboType: 'AU', comboCode: 'CA09'},
	    	{name: 'INOUT_Q'	    				, text: '투입수량'   	, type: 'uniQty'},
	    	{name: 'INOUT_AMT'		    			, text: '투입금액'      	, type: 'uniPrice'},
	    	{name: 'SORT'	    					, text: '승인'    		, type: 'string'}
		]
   });
   
   var cam400skrvStore=Unilite.createStore('Store', {	
   		model: 'cam400skrvModel',
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
				read    : 'cam400skrvService.selectList'
				
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
		groupField:'PROD_ITEM_CODE'
   });
   /**
	 * 검색조건 (Search Panel)
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
							UniAppManager.app.setWorkMonthFrText(newValue, panelSearch.getValue("WORK_MONTH"));
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
			title:'모품목기준',
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
				        			multiSelect : true,
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
		},
		{
			title:'자품목기준',
			id: 'search_panel3',
			itemId:'search_panel3',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
	    	items:[{ name: 'ITEM_ACCOUNT2', 
				     fieldLabel: '자품목계정',
				     hidden: false,
				     editable:false,
				     maxLength: 20,
				     xtype: 'uniCombobox',
				     comboType:'0',
				     comboCode:'B020',
	        			multiSelect : true,
				     listeners: {
					     change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_ACCOUNT2', newValue);
						}
				     }
				  },Unilite.popup('DIV_PUMOK',{ // 20210819 수정: 품목코드 팝업창 정규화
			  			fieldLabel: '품목코드',
			  			valueFieldName: 'ITEM_CODE',
			  			textFieldName: 'ITEM_NAME',
			  			colspan: 2,
			  			validateBlank: false,
			  			listeners: {
							onValueFieldChange: function( elm, newValue, oldValue ) {
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_NAME', '');
									panelSearch.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function( elm, newValue, oldValue ) {
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('ITEM_CODE', '');
									panelSearch.setValue('ITEM_CODE', '');
								}
							},
			  				applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),'FIND_TYPE':'00'});
							}
			  			}
			  		}) ]
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
		layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5,width:'100%'}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
		padding: '0 0 0 1',
		border:true,
		items: [{ 
        			 defaultType: 'uniTextfield'
        			, border:0
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
											panelSearch.setValue('WORK_MONTH', newValue);
											UniAppManager.app.setWorkMonthFrText(panelSearch.getValue("DIV_CODE"), newValue);
										}
									}
						  		} ,{
									xtype:'component',
									itemId : 'workMonthFrComponent',
									html:'(시작년월 : '+workMonthFr+')',
									style:{'padding-left' :'10px'},
									hidden : (yearEvaluationYN == 'Y' && workMonthFr != '') ? false : true
								}           
					         ]
	    		},{ 
        			  title: '모품목기준 '
        			, defaultType: 'uniTextfield'
        			, layout: { type: 'uniTable', columns: 3}
        			, height: 80
        			, items :[	 { name: 'ITEM_ACCOUNT',
				        			fieldLabel: '모품목계정',
				        			xtype: 'uniCombobox',
				        			comboType: '0',
				        			comboCode:'B020',
				        			hidden: false,
				        			editable:false,
				        			multiSelect : true,
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
							  	
							  	}     
						  		]
	    		},{ 
        			  title: '자품목기준 '
        			, defaultType: 'uniTextfield'
        			, layout: { type: 'uniTable', columns: 3}
        			, height: 50
        			, items :[	 { name: 'ITEM_ACCOUNT2', 
				        			fieldLabel: '자품목계정',
				        			hidden: false,
				        			editable:false,
				        			maxLength: 20,
				        			xtype: 'uniCombobox',
				        			comboType:'0',
				        			comboCode:'B020',
				        			multiSelect : true,
				        			listeners: {
										change: function(field, newValue, oldValue, eOpts) {						
											panelSearch.setValue('ITEM_ACCOUNT2', newValue);
										}
									}
				        		},Unilite.popup('DIV_PUMOK',{ // 20210819 수정: 품목코드 팝업창 정규화
						  			fieldLabel: '품목코드',
						  			valueFieldName: 'ITEM_CODE',
						  			textFieldName: 'ITEM_NAME',
						  			colspan: 2,
						  			validateBlank: false,
						  			listeners: {
										onValueFieldChange: function( elm, newValue, oldValue ) {
											panelSearch.setValue('ITEM_CODE', newValue);
											if(!Ext.isObject(oldValue)) {
												panelResult.setValue('ITEM_NAME', '');
												panelSearch.setValue('ITEM_NAME', '');
											}
										},
										onTextFieldChange: function( elm, newValue, oldValue ) {
											panelSearch.setValue('ITEM_NAME', newValue);
											if(!Ext.isObject(oldValue)) {
												panelResult.setValue('ITEM_CODE', '');
												panelSearch.setValue('ITEM_CODE', '');
											}
										},
						  				applyextparam: function(popup){							
										popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),'FIND_TYPE':'00'});
									}
						  			}
						  		})         
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
		//excelTitle: '발주현황조회',
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
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: cam400skrvStore,
        columns: [
        	{dataIndex: 'PROD_ITEM_CODE'			, width: 146 ,locked: true,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			{dataIndex: 'PROD_ITEM_NAME'			, width: 146 },
        	{dataIndex: 'PROD_ITEM_SPEC'			, width: 146 },
        	{dataIndex: 'PRODT_Q'					, width: 146 },
			{dataIndex: 'ITEM_CODE'					, width: 80},
        	{dataIndex: 'ITEM_NAME'					, width: 146 },
        	{dataIndex: 'ST_GB'						, width: 100},
			{dataIndex: 'INOUT_Q'					, width: 80,summaryType: 'sum'},
			{dataIndex: 'INOUT_AMT'					, width: 250 ,summaryType: 'sum'},
			{dataIndex: 'SORT'						, width: 80,hidden:true}
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
		id: 'cam400skrvApp',
		fnInitBinding: function(param) {
			if(param && param.DIV_CODE)	{
				panelSearch.setValue("DIV_CODE",param.DIV_CODE);
				panelSearch.setValue("WORK_MONTH",param.WORK_MONTH);
				panelResult.setValue("DIV_CODE",param.DIV_CODE);
				panelResult.setValue("WORK_MONTH",param.WORK_MONTH);
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
			masterGrid.reset();
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