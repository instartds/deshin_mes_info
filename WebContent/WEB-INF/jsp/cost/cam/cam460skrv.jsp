<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cam460skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="cam460skrv" /> 				<!-- 사업장 -->

	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore comboType="AU" comboCode="CA06" />	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var yearEvaluationYN = '${YEAR_EVALUATION_YN}';
var workMonthFr 	 = '${WORK_MONTH_FR}';

function appMain() {
   var cam460skrvModel=Unilite.defineModel('cam460skrvModel', {
   	fields: [
 	    	{name: 'WKORD_NUM'	    				, text: '작업지시번호' 	, type: 'string'},
   			{name: 'WK_PRODT_GB'   					, text: '생산구분'    , type: 'string', comboType: 'AU', comboCode: 'CA09'},
 	    	{name: 'PRODT_WKORD_DATE'	    		, text: '작업지시일' 	, type: 'uniDate'},
 	    	{name: 'PRODT_START_DATE'	    		, text: '작업시작일' 	, type: 'uniDate'},
 	    	{name: 'PRODT_END_DATE'	    			, text: '작업종료일' 	, type: 'uniDate'},
	    	{name: 'WK_PROD_ITEM_CODE'	    		, text: '생산품목코드' 	, type: 'string'},
	    	{name: 'WK_PROD_ITEM_NAME'		   		, text: '생산품목명'  	, type: 'string'},
	    	{name: 'WKORD_Q'		    			, text: '작업지시량'  	, type: 'uniQty'},
   			{name: 'PRODT_GB'   					, text: '생산구분'    , type: 'string', comboType: 'AU', comboCode: 'CA09'},
	    	{name: 'WK_WORK_SHOP_NAME'	    		, text: '작업장'    	, type: 'string'},
	    	{name: 'WK_PRODT_Q'		    			, text: '생산량'    	, type: 'uniQty'},
	    	{name: 'WK_ITEM_CODE'	   				, text: '품목코드'    	, type: 'string'},
	    	{name: 'WK_ITEM_NAME'	   				, text: '품목명'    	, type: 'string'},
	    	{name: 'WK_INOUT_Q'		    			, text: '수량'    	, type: 'uniQty'},
	    	{name: 'UNIT_COST'	    				, text: '단가'  		, type: 'uniPrice'},
	    	{name: 'D_AMT'	    					, text: '금액'	  	, type: 'uniPrice'},
   			{name: 'ST_GB'	    					, text: '구분'   	    , type: 'string', comboType: 'AU', comboCode: 'CA09'},
	    	{name: 'WORK_SHOP_NAME'	    			, text: '작업장'    	, type: 'string'},
	    	{name: 'PROD_ITEM_CODE'	    			, text: '모품목코드'  	, type: 'string'},
	    	{name: 'PROD_ITEM_NAME'		    		, text: '모품목명'   	, type: 'string'},
	    	{name: 'PRODT_Q'		    			, text: '생산량'    	, type: 'uniQty'},
	    	{name: 'ITEM_CODE'	    				, text: '품목코드'    	, type: 'string'},
	    	{name: 'ITEM_NAME'	    				, text: '품목명'    	, type: 'string'},
	    	{name: 'INOUT_Q'		    			, text: '수량'    	, type: 'uniQty'},
	    	{name: 'WIP_AMT'	    				, text: '재공'   		, type: 'uniPrice'},
	    	{name: 'MAT_DAMT'	    				, text: '직접재료비'  	, type: 'uniPrice'},
	    	{name: 'MAT_IAMT'	    				, text: '간접재료비'  	, type: 'uniPrice'},
	    	{name: 'LABOR_DAMT'	    				, text: '직접노무비'  	, type: 'uniPrice'},
	    	{name: 'LABOR_IAMT'	    				, text: '간접노무비'  	, type: 'uniPrice'},
	    	{name: 'EXPENSE_DAMT'	    			, text: '직접경비'    	, type: 'uniPrice'},
	    	{name: 'EXPENSE_IAMT'	    			, text: '간접경비'    	, type: 'uniPrice'}
		]
   });

   var cam460skrvStore=Unilite.createStore('Store', {
   		model: 'cam460skrvModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		groupField : 'WK_PRODT_GB',
		proxy: {
			type: 'direct',
			api: {
				read    : 'cam460skrvService.selectList'

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
         		 load:'cam460skrvService.selectWORK_SEQ'
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
						xtype:'container',
						layout : {type:'uniTable', columns: 1},
						items : [{
							xtype:'component',
							itemId : 'workMonthFrComponent',
							style:{'padding-left':'95px'},
							html:'(시작년월 : '+workMonthFr+')',
							hidden : (yearEvaluationYN == 'Y' && workMonthFr !='') ? false : true
						}]
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
				        			editable:false,
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
							  	},{ name: 'WKORD_NUM',
							  		fieldLabel: '작업지시번호',
							  		hidden: false,
				        			listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											panelResult.setValue('WKORD_NUM', newValue);
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
		layout: {type: 'uniTable', columns: 3,  tdAttrs: {valign:'top'}},
	    defaultType: 'uniTextfield',
	    defaults : { margin: '0 0 0 0'},
		padding: '0 0 0 1',
		items: [ 
			{ 
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
						panelSearch.setValue('DIV_CODE', newValue);
						UniAppManager.app.setWorkMonthFrText(newValue, panelSearch.getValue("WORK_MONTH"));
					}
				}
     	 }
 		,{ 
 			name: 'WORK_MONTH',
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
			xtype:'container',
			layout : {type:'uniTable', columns: 1},
			items : [{
				xtype:'component',
				itemId : 'workMonthFrComponent',
				html:'(시작년월 : '+workMonthFr+')',
				style:{'padding-left' :'10px', 'padding-top' : '3px;'},
				hidden : (yearEvaluationYN == 'Y' && workMonthFr != '') ? false : true
			}]
		},{ 
			name: 'ITEM_ACCOUNT',
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
  		}),{ 
			name: 'ITEM_LEVEL1',
  			fieldLabel: '대분류',
  			maxLength: 200,
  			xtype: 'uniCombobox',
       		store: Ext.data.StoreManager.lookup('itemLeve1Store'),
       		child: 'ITEM_LEVEL2',
   			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL1', newValue);
				}
			}
      	},{ 
      		name: 'ITEM_LEVEL2',
  			fieldLabel: '중분류',
  			maxLength: 200,
  		 	xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLeve2Store'),
			child: 'ITEM_LEVEL3',
      			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL2', newValue);
				}
			}
		},{ 
			name: 'ITEM_LEVEL3',
	  		fieldLabel: '소분류',
	  		xtype:'uniCombobox',
	  		store: Ext.data.StoreManager.lookup('itemLeve3Store'),
      			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL3', newValue);
				}
			}

		},{ 
 			name: 'WKORD_NUM',
	  		fieldLabel: '작업지시번호',
	  		hidden: false,
	  		colspan:3,
     		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WKORD_NUM', newValue);
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
			expandLastColumn: true,
			state: {
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
    	store: cam460skrvStore,
        columns: [
        	{dataIndex: 'WK_PRODT_GB'					, width: 70 ,
    			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
 			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
             }},
        	{dataIndex: 'WKORD_NUM'						, width: 130 ,locked: false},
        	{
				text:'작업지시정보',
        		columns:[{dataIndex: 'WK_PROD_ITEM_CODE', width: 100 },
        				 {dataIndex: 'WK_PROD_ITEM_NAME', width: 146 },
        		         {dataIndex: 'PRODT_WKORD_DATE'	, width: 100 },
        				 {dataIndex: 'PRODT_START_DATE'	, width: 100 },
        				 {dataIndex: 'PRODT_END_DATE'	, width: 100 },
        				 {dataIndex: 'WKORD_Q'			, width: 90 }
        		]
        	},
        	{
				text:'생산집계정보',
        		columns:[{dataIndex: 'PRODT_GB'         , width: 70 },
        				 {dataIndex: 'WK_WORK_SHOP_NAME', width: 100 },
        				 {dataIndex: 'WK_PRODT_Q'		, width: 90}
        		]
        	},
        	{
				text:'재료비집계정보',
        		columns:[{dataIndex: 'WK_ITEM_CODE'		, width: 100 },
        				 {dataIndex: 'WK_ITEM_NAME'		, width: 146 },
        				 {dataIndex: 'WK_INOUT_Q'		, width: 90 ,summaryType: 'sum'},
        		         {dataIndex: 'UNIT_COST'        , width: 90 },
        				 {dataIndex: 'D_AMT'			, width: 90 ,summaryType: 'sum'}
        		]
        	},
        	{
				text:'원가집계정보(생산)',
        		columns:[{dataIndex: 'ST_GB'	        , width: 70 },
        		         {dataIndex: 'WORK_SHOP_NAME'	, width: 100 },
        		         {dataIndex: 'PROD_ITEM_CODE'	, width: 100 },
        				 {dataIndex: 'PROD_ITEM_NAME'	, width: 146 },
        				 {dataIndex: 'PRODT_Q'			, width: 90 ,summaryType: 'sum'}
        		]
        	},
        	{	
        		text:'원가집계정보(투입)',
	        	columns:[{dataIndex: 'ITEM_CODE'		, width: 100},
	        			 {dataIndex: 'ITEM_NAME'		, width: 146},
	        			 {dataIndex: 'INOUT_Q'			, width: 90 ,summaryType: 'sum'}
	       		]
        	},
        	{
        		text:'원가집계정보(재료비)',
        		columns:[{dataIndex: 'WIP_AMT'			, width: 120 ,summaryType: 'sum'},
        				 {dataIndex: 'MAT_DAMT'			, width: 120 ,summaryType: 'sum'},
        				 {dataIndex: 'MAT_IAMT'			, width: 120 ,summaryType: 'sum'}
        			]
        	},
        	{
        		text:'원가집계정보(노무비)',
            	columns:[{dataIndex: 'LABOR_DAMT'		, width: 120 ,summaryType: 'sum'},
            			 {dataIndex: 'LABOR_IAMT'		, width: 120 ,summaryType: 'sum'}
            	]
            },
        	{
            	text:'원가집계정보(경비)',
        		columns:[{dataIndex: 'EXPENSE_DAMT'		, width: 120 ,summaryType: 'sum'},
        				 {dataIndex: 'EXPENSE_IAMT'		, width: 120 ,summaryType: 'sum'}
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
				masterGrid,panelResult
			]
		},
			panelSearch
		],
		id: 'cam460skrvApp',
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