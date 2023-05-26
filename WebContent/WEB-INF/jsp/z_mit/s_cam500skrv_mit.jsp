<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_cam500skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_cam500skrv_mit" /> 				<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
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
   var s_cam500skrv_mitModel=Unilite.defineModel('s_cam500skrv_mitModel', {
   	fields: [
	    	{name: 'ITEM_CODE'	    			, text: '품목코드'    		, type: 'string'},
	    	{name: 'ITEM_NAME'		    		, text: '품목명'   			, type: 'string'},
	    	{name: 'ITEM_ACCOUNT'		    	, text: 'ITEM_ACCOUNT'   	, type: 'string'},
	    	{name: 'SPEC'		    			, text: '규격'    			, type: 'string'},
	    	{name: 'WH_CODE'		    		, text: '창고/외주처'    		, type: 'string'},
	    	{name: 'WH_CODE_NM'	    			, text: '창고/외주처명'   		, type: 'string'},
	    	{name: 'BASIS_Q'	    			, text: '이월수량'   	    , type: 'uniQty'},    	
	    	{name: 'BASIS_AMOUNT_I'	    		, text: '이월금액'   		, type: 'uniPrice'},
	    	//입고데이터(18)--------------------------------------------------------------------
	    	{name: 'InProdt_q'		    		, text: '수량'      		, type: 'uniQty'},
	    	{name: 'InProdt_p'	    			, text: '단가'    			, type: 'uniPrice'},
	    	{name: 'InProdt_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'InBuy_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'InProdtGood_q'	    		, text: '양품수량'    			, type: 'uniQty'},
	    	{name: 'InProdtBad_q'	    		, text: '불량수량'    			, type: 'uniQty'},
	    	{name: 'InBuy_p'	    			, text: '단가'    			, type: 'uniPrice'},
	    	{name: 'InBuy_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'InOutOrder_q'	    		, text: '수량'    			, type: 'uniQty'},
	    	{name: 'InOutOrder_p'	    		, text: '단가'    			, type: 'uniPrice'},
	    	{name: 'InOutOrder_i'	    		, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'InOther_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'InOther_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'InMove_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'InMove_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'InReplace_q'	    		, text: '수량'    			, type: 'uniQty'},
	    	{name: 'InReplace_i'	    		, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'InEtc_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'InEtc_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OS_InMove_q'	    		, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OS_InMove_i'	    		, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OS_InEtc_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OS_InEtc_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'InSum_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'InSum_p'	    			, text: '단가'    			, type: 'uniPrice'},
	    	{name: 'InSum_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    
	         
	    	//출고데이터(17)--------------------------------------------------------------------		
	    	{name: 'OutProdt_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutProdt_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutFinance_q'	    		, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutFinance_i'	    		, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutSale_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutSale_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutOutOrder_q'	    		, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutOutOrder_i'	    		, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutOther_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutOther_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutMove_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutMove_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutDisUse_q'	    		, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutDisUse_i'	    		, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutReplace_q'	    		, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutReplace_i'	    		, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutEtc_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutEtc_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutAdjust_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutAdjust_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OS_OutOutOrder_q'	    	, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OS_OutOutOrder_i'	    	, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OS_OutEtc_q'	    		, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OS_OutEtc_i'	    		, text: '금액'    			, type: 'uniPrice'},
	    	{name: 'OutSum_q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'OutSum_p'	    			, text: '단가'    			, type: 'uniPrice'},
	    	{name: 'OutSum_i'	    			, text: '금액'    			, type: 'uniPrice'},
	    	//재고데이터 ----------------------------------------------------------------------------
	    	{name: 'STOCK_Q'	    			, text: '수량'    			, type: 'uniQty'},
	    	{name: 'STOCK_P'	    			, text: '단가'    			, type: 'uniPrice'},
	    	{name: 'STOCK_I'	    			, text: '금액'    			, type: 'uniPrice'},
	    	//조회조건 --------------------------------------------------------------------------------
	    	{name: 'ITEM_LEVEL1'	    		, text: 'ITEM_LEVEL1'    	, type: 'string'},
	    	{name: 'ITEM_LEVEL2'	    		, text: 'ITEM_LEVEL2'    	, type: 'string'},
	    	{name: 'ITEM_LEVEL3'	    		, text: 'ITEM_LEVEL3'    	, type: 'string'}
		]
   });
   var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_cam500skrv_mitService.selectList'
        }
    });
   var s_cam500skrv_mitStore=Unilite.createStore('Store', {	
   		model: 's_cam500skrv_mitModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: directProxy,
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
		//groupField:'',
		listeners:{
			load: function(store, records, successful, eOpts){
				if(successful){
					if(panelResult.getValues().STATUS=='2'){
                    	masterGrid.getColumn("WH_CODE").show(); //창고/외주처
		                masterGrid.getColumn("WH_CODE_NM").show(); //창고/외주처명
		                masterGrid.getColumn("OutFinance_q").hide(); //재무수량
		                masterGrid.getColumn("OutFinance_i").hide(); //재무금액
		            }else{
		                //masterGrid.columns[4].hide();
		                //masterGrid.columns[5].hide();
		                masterGrid.getColumn("WH_CODE").hide(); //창고/외주처
		                masterGrid.getColumn("WH_CODE_NM").hide(); //창고/외주처명
		                masterGrid.getColumn("OutFinance_q").show(); //재무수량
		                masterGrid.getColumn("OutFinance_i").show(); //재무금액
		            } 
					
				}
			}
		}
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{ 
						name: 'DIV_CODE', 
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
								panelSearch.setValue('WH_CODE','');
								panelResult.setValue('WH_CODE','');
							}
						}
					},{
						fieldLabel: '기준월',
						xtype: 'uniMonthfield',
						name: 'WORK_MONTH',
						hidden: false,
						allowBlank:false,
						value: UniDate.get('startOfMonth'),
	        			listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('WORK_MONTH', newValue);
								//UniAppManager.app.setWorkMonthFrText(panelSearch.getValue("DIV_CODE"), newValue);
							},
							blur: function(field){
								UniAppManager.app.setWorkMonthFrText(panelSearch.getValue("DIV_CODE"), field.getValue());
							}
						}						
					},{
			  			xtype : 'container',
			  			items : [
				  			{
								xtype:'component',
								itemId : 'workMonthFrComponent',
								html:'(시작년월 : '+workMonthFr+')',

								style:{'padding-left' :'95px;margin-top:3px;'},
								hidden : (yearEvaluationYN == 'Y' && workMonthFr != '') ? false : true
							}
			  			]
			  		},
					
					{
						xtype: 'radiogroup',		            		
						fieldLabel: '재고구분',						            		
						//id: 'CONFIRM_TYPE',
						items: [{
							boxLabel: '전체', 
							width:60, 
							name: 'STATUS', 
							inputValue: '1', 
							checked: true
						},{
							boxLabel: '창고/외주처', 
							width:100, 
							name: 'STATUS', 
							inputValue: '2'
						}],
						listeners: {
		                    change: function(field, newValue, oldValue, eOpts) {            
		                        panelResult.getField('STATUS').setValue(newValue.STATUS);
		                       
		                    }
		                }
					},{
						fieldLabel: '창고',
						name:'WH_CODE',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('whList'),
						listeners: {
							beforequery:function(queryPlan)	{
								var sDivCode = panelSearch.getValue("DIV_CODE");
								if(sDivCode)	{
									var store = queryPlan.combo.store;
									store.filter('option', sDivCode);
								}
							},
		                    change: function(field, newValue, oldValue, eOpts) {     
		                    	panelResult.setValue("WH_CODE",newValue);
		                    }
						}
					},
					{ name: 'ITEM_ACCOUNT',
				        			fieldLabel: '모품목계정',
				        			xtype: 'uniCombobox',
				        			comboType: '0',
				        			comboCode:'B020',
				        			hidden: false,
				        			multiSelect:true,
				        			maxLength: 20,
				        			listeners: {
										change: function(field, newValue, oldValue, eOpts) {						
											panelResult.setValue('ITEM_ACCOUNT', newValue);
										}
									}
				        		}      
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
							  	},Unilite.popup('DIV_PUMOK',{
						  			fieldLabel: '품목코드',
						  			valueFieldName: 'ITEM_CODE',
						  			textFieldName: 'ITEM_NAME',
						  			listeners: {
						  				onSelected: {
											fn: function(records, type) {
												panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
												panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
											}
										},
						  				applyextparam: function(popup){							
										popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),'FIND_TYPE':'00'});
									}
						  			}
						  		}) ,Unilite.popup('CUST',{
						  			fieldLabel: '외주처',
						  			valueFieldName: 'CUSTOM_CODE',
						  			textFieldName: 'CUSTOM_NAME',
						  			listeners: {
						  				onSelected: {
											fn: function(records, type) {
												panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
												panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
											}
										}
						  			}
						  		}),
						  		{
									fieldLabel: '0 값 제외',
							           name: 'Except',
							           xtype: 'checkboxfield',
								       inputValue: 'Except',
								       checked: false,	
										labelWidth : 225,
								       listeners: {
								       	change: function(field, newValue, oldValue, eOpts) {						
												panelResult.setValue('Except', newValue);
										}
								       }
					    		},{
									xtype: 'checkboxfield',		            		
									fieldLabel: '생산입고에 양품/불량 표시',		
									labelWidth : 225,
									name: 'SHOW_DETAIL_Q', 
									checked: false,
									listeners: {
										change : function(field, newValue, oldValue, eOpts) {            
											panelResult.getField('SHOW_DETAIL_Q').checked = newValue;
											panelResult.getField('SHOW_DETAIL_Q').setValue(newValue)
					                        if(newValue){
								                 masterGrid.getColumn("InProdtGood_q").show();
								                 masterGrid.getColumn("InProdtBad_q").show();
								            }else{
								            	 masterGrid.getColumn("InProdtGood_q").hide();
								            	 masterGrid.getColumn("InProdtBad_q").hide();
								            }
					                        //UniAppManager.app.onQueryButtonDown();
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
		layout: {type: 'uniTable', columns: 5, tableAttrs:{cellpadding:1,width:'100%'}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
		padding: '0 0 0 1',
		border:true,
		items: [
				{ name: 'DIV_CODE',
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
							panelSearch.setValue('WH_CODE','');
							panelResult.setValue('WH_CODE','');
							UniAppManager.app.setWorkMonthFrText(newValue, panelResult.getValue("WORK_MONTH"));
						}
					}
        		}      
		  		,{
					fieldLabel: '기준월',
					xtype: 'uniMonthfield',
					name: 'WORK_MONTH',
					hidden: false,
					allowBlank:false,
					value: UniDate.get('startOfMonth'),
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WORK_MONTH', newValue);
						},
						blur: function(field){
							UniAppManager.app.setWorkMonthFrText(panelResult.getValue("DIV_CODE"), field.getValue());
						}
					}
				},{
		  			xtype : 'container',
		  			items : [
			  			{
							xtype:'component',
							itemId : 'workMonthFrComponent',
							html:'(시작년월 : '+workMonthFr+')',
							style:{'padding-left' :'10px;margin-top:3px;'},
							hidden : (yearEvaluationYN == 'Y' && workMonthFr != '') ? false : true
						}
		  			]
		  		},{
					xtype: 'radiogroup',		            		
					fieldLabel: '재고구분',						            		
					//id: 'CONFIRM_TYPE'
					items: [{
						boxLabel: '전체', 
						width:60, 
						name: 'STATUS', 
						inputValue: '1', 
						checked: true
					},{
						boxLabel: '창고/외주처',
						width:100, 
						name: 'STATUS', 
						inputValue: '2'
					}],
					listeners: {
	                    change: function(field, newValue, oldValue, eOpts) {            
	                        panelSearch.getField('STATUS').setValue(newValue.STATUS);
	                        setTimeout(function(){UniAppManager.app.onQueryButtonDown();}, 10);
	                    }
	                }
				},{
					fieldLabel: '창고',
					name:'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						beforequery:function(queryPlan)	{
							var sDivCode = panelSearch.getValue("DIV_CODE");
							if(sDivCode)	{
								var store = queryPlan.combo.store;
								store.filter('option', sDivCode);
							}
						},
	                    change: function(field, newValue, oldValue, eOpts) {     
	                    	panelSearch.setValue("WH_CODE",newValue);
	                    }
					}
				},
				{ name: 'ITEM_ACCOUNT',
        			fieldLabel: '모품목계정',
        			xtype: 'uniCombobox',
        			comboType: '0',
        			comboCode:'B020',
        			hidden: false,
        			multiSelect:true,
        			maxLength: 20,
        			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
        		}      
		  		,{ name: 'ITEM_LEVEL1', 
		  			fieldLabel: '대분류' 		,
		  			maxLength: 200,
		  			colspan : 2,
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
			  	,Unilite.popup('DIV_PUMOK',{
		  			fieldLabel: '품목코드',
		  			valueFieldName: 'ITEM_CODE',
		  			textFieldName: 'ITEM_NAME',
		  			listeners: {
		  				onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
							}
						},
		  				applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE'),'FIND_TYPE':'00'});
					}
		  			}
		  		})   
		  		,Unilite.popup('CUST',{
		  			fieldLabel: '외주처',
		  			colspan : 2,
		  			valueFieldName: 'CUSTOM_CODE',
		  			textFieldName: 'CUSTOM_NAME',
		  			listeners: {
		  				onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
							}
						}
		  			}
		  		}),
		  		{
					fieldLabel: '0 값 제외',
			           name: 'Except',
			           xtype: 'checkboxfield',
				       inputValue: 'Except',
				       checked: false,
					   labelWidth : 225,
				       listeners: {
				       	change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('Except', newValue);
						}
				       }
	    		},{
					xtype: 'checkboxfield',		            		
					fieldLabel: '생산입고에 양품/불량 표시',		
					name: 'SHOW_DETAIL_Q', 
					labelWidth : 225,
					checked: false,
					listeners: {
	                    change: function(field, newValue, oldValue, eOpts) {            
	                    	panelSearch.getField('SHOW_DETAIL_Q').checked = newValue;
	                    	panelSearch.getField('SHOW_DETAIL_Q').setValue(newValue)
	                        if(newValue){//InProdtGood_q, InProdtBad_q
				                 masterGrid.getColumn("InProdtGood_q").show();
				                 masterGrid.getColumn("InProdtBad_q").show();
				            }else{
				            	 masterGrid.getColumn("InProdtGood_q").hide();
				            	 masterGrid.getColumn("InProdtBad_q").hide();
				            }
	                        //UniAppManager.app.onQueryButtonDown();
	                    }
	                }
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
			},
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
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
			showSummaryRow: true
		}],
    	store: s_cam500skrv_mitStore,
        columns: [
        	{dataIndex: 'ITEM_CODE'			, width: 100 ,locked: true,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
			{dataIndex: 'ITEM_NAME'			, width: 150 ,locked: true},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 100 ,hidden: true},
        	{dataIndex: 'SPEC'				, width: 150 ,locked: true},
        	{dataIndex: 'WH_CODE'			, width: 80 ,hidden:true,locked: true},
        	{dataIndex: 'WH_CODE_NM'		, width: 100 ,hidden:true,locked: true},
        	{dataIndex: 'BASIS_Q'			, width: 90,summaryType: 'sum' },
        	{dataIndex: 'BASIS_AMOUNT_I'	, width: 110,summaryType: 'sum' },
        	{text:'입고',columns:[
        		{text:'생산입고'		,columns:[{dataIndex: 'InProdt_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'InProdtGood_q'	, width: 90,summaryType: 'sum', hidden:true },{dataIndex: 'InProdtBad_q'	, width: 90, summaryType: 'sum',  hidden:true }, {dataIndex: 'InProdt_p'	, width: 90 },{dataIndex: 'InProdt_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'구매입고'		,columns:[{dataIndex: 'InBuy_q'		, width: 90,summaryType: 'sum' },{dataIndex: 'InBuy_p'		, width: 90 },{dataIndex: 'InBuy_i'		, width: 110,summaryType: 'sum' }]},
        		{text:'외주입고'		,columns:[{dataIndex: 'InOutOrder_q', width: 90,summaryType: 'sum' },{dataIndex: 'InOutOrder_p', width: 90},{dataIndex: 'InOutOrder_i', width: 110,summaryType: 'sum' }]},
        		{text:'타계정'  		,columns:[{dataIndex: 'InOther_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'InOther_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'이동'  		,columns:[{dataIndex: 'InMove_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'InMove_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'대체입고'  		,columns:[{dataIndex: 'InReplace_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'InReplace_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'기타'  		,columns:[{dataIndex: 'InEtc_q'		, width: 90,summaryType: 'sum' },{dataIndex: 'InEtc_i'		, width: 110,summaryType: 'sum' }]},
        		{text:'외주이동입고'  	,columns:[{dataIndex: 'OS_InMove_q'		, width: 90,summaryType: 'sum' },{dataIndex: 'OS_InMove_i'		, width: 110,summaryType: 'sum' }]},
        		{text:'외주기타입고'  	,columns:[{dataIndex: 'OS_InEtc_q'		, width: 90,summaryType: 'sum' },{dataIndex: 'OS_InEtc_i'		, width: 110,summaryType: 'sum' }]},
        		{text:'계'  			,columns:[{dataIndex: 'InSum_q'		, width: 90,summaryType: 'sum' },{dataIndex: 'InSum_p'		, width: 90},{dataIndex: 'InSum_i'		, width: 110,summaryType: 'sum' }]}
        	]},
        	{text:'출고',columns:[
        		{text:'생산출고'		,columns:[{dataIndex: 'OutProdt_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutProdt_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'외주생산출고'  	,columns:[{dataIndex: 'OS_OutOutOrder_q', width: 90,summaryType: 'sum' },{dataIndex: 'OS_OutOutOrder_i'		, width: 110,summaryType: 'sum' }]},
        		{text:'재무출고'		,columns:[{dataIndex: 'OutFinance_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutFinance_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'매출출고'		,columns:[{dataIndex: 'OutSale_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutSale_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'타계정'  		,columns:[{dataIndex: 'OutOther_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutOther_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'이동'  		,columns:[{dataIndex: 'OutMove_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutMove_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'폐기'  		,columns:[{dataIndex: 'OutDisUse_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutDisUse_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'대체출고 '  	,columns:[{dataIndex: 'OutReplace_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutReplace_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'기타'  		,columns:[{dataIndex: 'OutEtc_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutEtc_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'재고실사조정'  	,columns:[{dataIndex: 'OutAdjust_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutAdjust_i'	, width: 110,summaryType: 'sum' }]},
        		{text:'외주이동출고'	,columns:[{dataIndex: 'OutOutOrder_q', width: 90,summaryType: 'sum' },{dataIndex: 'OutOutOrder_i', width: 110,summaryType: 'sum' }]},
        		{text:'외주기타출고'  	,columns:[{dataIndex: 'OS_OutEtc_q'		, width: 90,summaryType: 'sum' },{dataIndex: 'OS_OutEtc_i'		, width: 110,summaryType: 'sum' }]},
        		{text:'계'  			,columns:[{dataIndex: 'OutSum_q'	, width: 90,summaryType: 'sum' },{dataIndex: 'OutSum_p'	, width: 90},{dataIndex: 'OutSum_i'	, width: 110,summaryType: 'sum' }]}
        	]},
			{text:'재고',columns:[
				{dataIndex:'STOCK_Q',width:90,summaryType: 'sum'},
				{dataIndex:'STOCK_P',width:90},
				{dataIndex:'STOCK_I',width:110,summaryType: 'sum'}
			]
			},
			{dataIndex: 'ITEM_LEVEL1'	, width: 110,hidden:true },
			{dataIndex: 'ITEM_LEVEL2'	, width: 110,hidden:true },
			{dataIndex: 'ITEM_LEVEL3'	, width: 110,hidden:true }
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
		id: 's_cam500skrv_mitApp',
		fnInitBinding: function(param) {
			if(param && param.DIV_CODE)	{
				panelResult.setValue("DIV_CODE",param.DIV_CODE);
				panelResult.setValue("WORK_MONTH",param.WORK_MONTH)
				panelSearch.setValue("DIV_CODE",param.DIV_CODE);
				panelSearch.setValue("WORK_MONTH",param.WORK_MONTH);
			}
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
				workMonth =  UniDate.getMonthStr(panelSearch.getValue("WORK_MONTH"));
			} 
        	UniCost.setMorhFrText(divCode,workMonth, comArray)
        }
	});
	
	function fnPriceCompute(){
		var dProdt_q, dProdt_i, dProdt_p;			//'생산입고
		var dOrder_q, dOrder_i, dOrder_p;			//'구매입고
		var dOutOrder_q, dOutOrder_i, dOutOrder_p;	//'외주입고
		dProdt_q = 0	;dProdt_i = 0		;dProdt_p = 0;		//'생산입고
		dOrder_q = 0	;dOrder_i = 0		;dOrder_p = 0;		//'구매입고
		dOutOrder_q = 0 ;dOutOrder_i = 0	;dOutOrder_p = 0;	//'외주입고
		var store = masterGrid.getStore();
		var count = store.getCount();
		 for (var i = 0; i < count; i++) {
		  var record = store.getAt(i);
		  //[생산입고 단가구하기]*******************************************************
		  dProdt_i=record.data.InProdt_i;
		  dProdt_q=record.data.InProdt_q;
		  if(dProdt_i==0||dProdt_q==0){
		  	dProdt_p=0;
		  }else{
		  	dProdt_p=dProdt_i / dProdt_q;
		  }
		  record.data.InProdt_p=dProdt_p;
		  //[구매입고 단가구하기]*******************************************************
		  dOrder_i=record.data.InBuy_i;
		  dOrder_q=record.data.InBuy_q;
		  if(dOrder_i==0||dOrder_q==0){
		  	dOrder_p=0;
		  }else{
		  	dOrder_p=dOrder_i / dOrder_q;
		  }
		  record.data.InBuy_p=dOrder_p;
		  //[외주입고 단가구하기]*******************************************************
		  dOutOrder_i =record.data.InOutOrder_i;
		  dOutOrder_q=record.data.InOutOrder_q;
		  if (dOutOrder_i == 0 || dOutOrder_q == 0) 
			dOutOrder_p = 0;
		  else
			dOutOrder_p = dOutOrder_i / dOutOrder_q;
		  record.data.InOutOrder_p=dOutOrder_p;
		  record.commit();
		 }
	}
	function fnSumStockPriceCompute(){
		var dInSum_q, dInSum_i, dInSum_p;			//'입고계
		var dOutSum_q, dOutSum_i, dOutSum_p;			//'출고계
		var dStock_q, dStock_i, dStock_p;			//'재고
		
		dInSum_q = 0	;dInSum_i = 0		;dInSum_p = 0;		//'입고계	
		dOutSum_q = 0	;dOutSum_i = 0		;dOutSum_p = 0;		//'출고계
		dStock_q = 0	;dStock_i = 0		;dStock_p = 0;		//'재고
		var store = masterGrid.getStore();
		var count = store.getCount();
		 for (var i = 0; i < count; i++) {
		  var record = store.getAt(i);
		//입고의 수량/금액/단가구하기]**********************************************
		  dInSum_q=record.data.InProdt_q+record.data.InBuy_q+record.data.InOutOrder_q+
		  record.data.InOther_q+record.data.InMove_q+record.data.InEtc_q;
		  dInSum_i=record.data.InProdt_i+record.data.InBuy_i+record.data.InOutOrder_i+
		  record.data.InOther_i+record.data.InMove_i+record.data.InEtc_i;
		  record.data.InSum_q=dInSum_q;
		  record.data.InSum_i=dInSum_i;
		  if(dInSum_q==0||dInSum_i==0)
		  	dInSum_p = 0;	
		  else
			dInSum_p = dInSum_i / dInSum_q;
		  record.data.InSum_p=dInSum_p;
		//[출고의 수량/금액/단가구하기]**********************************************
		  dOutSum_q=record.data.OutProdt_q+record.data.OutSale_q+record.data.OutOutOrder_q+
		  record.data.OutOther_q+record.data.OutMove_q+record.data.OutDisUse_q+record.data.OutEtc_q;
		  dOutSum_i=record.data.OutProdt_i+record.data.OutSale_i+record.data.OutOutOrder_i+
		  record.data.OutOther_i+record.data.OutMove_i+record.data.OutDisUse_i+record.data.OutEtc_i;
		  record.data.OutSum_q=dOutSum_q;
		  record.data.OutSum_i=dOutSum_i;
		  	if (dOutSum_q == 0 || dOutSum_i == 0)
				dOutSum_p = 0;		
			else
				dOutSum_p = dOutSum_i / dOutSum_q;
			record.data.OutSum_p=dOutSum_p;
			
		//'[재고  수량/금액/단가구하기]**********************************************
			if(record.data.STOCK_Q=="")
				 dStock_q = 0;
			else
				dStock_q =record.data.STOCK_Q;
			if(record.data.STOCK_I=="")
				 dStock_i = 0;
			else
				dStock_i =record.data.STOCK_I;
			if (dStock_q == 0 || dStock_i == 0 ) 
				dStock_p = 0;
			else
				dStock_p = dStock_i / dStock_q;
			record.data.STOCK_P=dStock_p;
			record.commit();
		 }
		
		
	}
	function decimal(num,v){
	var vv = Math.pow(10,v);
	return Math.round(num*vv)/vv;
	}
    
};
</script>