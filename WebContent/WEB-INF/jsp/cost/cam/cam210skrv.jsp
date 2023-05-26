<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cam210skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="cam210skrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" opts="2;3"/>
	<t:ExtComboStore comboType="AU" comboCode="CA10"/>
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var yearEvaluationYN = '${YEAR_EVALUATION_YN}';
var workMonthFr 	 = '${WORK_MONTH_FR}';

function appMain() {
   var cam210skrvModel=Unilite.defineModel('cam210skrvModel', {
   	fields: [
   			{name: 'ST_GB'	    			, text: '생산구분'    		, type: 'string', comboType:'AU', comboCode:'B014'},
   			{name: 'SUM_GB'	    			, text: '집계구분'    		, type: 'string', comboType:'AU', comboCode:'CA10'},
   			{name: 'WORK_SHOP_CD'	    	, text: '작업장코드'    	, type: 'string'},
	    	{name: 'WORK_SHOP_NAME'	    	, text: '작업장명'    		, type: 'string'},
	    	{name: 'ITEM_CODE'		    	, text: '품목코드'   		, type: 'string'},
	    	{name: 'ITEM_NAME'		    	, text: '품목명'   		, type: 'string'},
	    	{name: 'SPEC'		    		, text: '규격'    		, type: 'string'},
	    	{name: 'INOUT_Q'		    	, text: '투입수량'    		, type: 'uniQty'},
	    	{name: 'UNIT_COST'		    	, text: '단가'    		, type: 'uniPrice'},
	    	{name: 'AMT'	    			, text: '금액'   			, type: 'uniPrice'},
		]
   });
   var cam210skrvStore=Unilite.createStore('Store', {	
   		model: 'cam210skrvModel',
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
				read    : 'cam210skrvService.selectList'
				
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
         		 load:'cam210skrvService.selectWORK_SEQ'
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
					},{
						name: 'ST_GB',
						fieldLabel: '생산구분',
						xtype: 'uniCombobox',
						comboType :'AU',
						comboCode :'B014',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('ST_GB', newValue);
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
				        			fieldLabel: '품목계정',
				        			xtype: 'uniCombobox',
				        			comboType: '0',
				        			comboCode:'B020',
				        			hidden: false,
				        			editable:false,
				        			maxLength: 20,
				        			multiSelect: true, 
				        	        typeAhead: false,
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
						  		}),{
									name: 'SUM_GB',
									fieldLabel: '집계구분',
									xtype: 'uniCombobox',
				        			multiSelect: true, 
									comboType :'AU',
									comboCode :'CA10',
									width     :270,
									hidden: false,
									listeners: {
										change: function(field, newValue, oldValue, eOpts) {						
											panelResult.setValue('SUM_GB', newValue);
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
		layout: {type: 'uniTable', columns: 4, tableAttrs:{cellpadding:3}, tdAttrs: {valign:'top'}},
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
							style:{'padding-left' :'10px;margin-top:3px;'},
							hidden : (yearEvaluationYN == 'Y' && workMonthFr != '') ? false : true
						}
		  			]
		  		} , {
					name: 'ST_GB',
					fieldLabel: '생산구분',
					xtype: 'uniCombobox',
					width     :270,
					comboType :'AU',
					comboCode :'B014',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ST_GB', newValue);
						}
					}
				}, { name: 'ITEM_ACCOUNT',
        			fieldLabel: '품목계정',
        			xtype: 'uniCombobox',
        			comboType: '0',
        			comboCode:'B020',
        			hidden: false,
        			editable:false,
        			multiSelect: true, 
        	        typeAhead: false,
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
					name: 'SUM_GB',
					fieldLabel: '집계구분',
					xtype: 'uniCombobox',
        			multiSelect: true, 
					comboType :'AU',
					comboCode :'CA10',
					width     :270,
					hidden: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('SUM_GB', newValue);
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
	var masterGrid = Unilite.createGrid('cam210skrvGrid1', {
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
				useState: true,		//그리드 설정 버튼 사용 여부
				useStateList: true		//그리드 설정 목록 사용 여부
			},
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
    	store: cam210skrvStore,
        columns: [
        	{dataIndex: 'ST_GB'				, width: 70  ,
    			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
 			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
             }
        	},
        	{dataIndex: 'SUM_GB'			, width: 180 },
        	{dataIndex: 'WORK_SHOP_CD'		, width: 100 },
        	{dataIndex: 'WORK_SHOP_NAME'	, width: 200},
			{dataIndex: 'ITEM_CODE'			, width: 120 },
        	{dataIndex: 'ITEM_NAME'			, width: 200 },
        	{dataIndex: 'SPEC'				, width: 350 },
        	{dataIndex: 'INOUT_Q'			, width: 100	,summaryType: 'sum'},
        	{dataIndex: 'UNIT_COST'			, width: 100 },
        	{dataIndex: 'AMT'				, width: 100	,summaryType: 'sum'}
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
		id: 'cam210skrvApp',
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