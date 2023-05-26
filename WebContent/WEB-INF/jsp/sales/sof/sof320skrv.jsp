<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof320skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="BOR120" pgmId="sof320skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->      
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->       
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!--수주구분-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('sof320skrvModel1', {
		fields: [
			 {name: 'CUSTOM_CODE'		 	,text:'<t:message code="system.label.sales.client" default="고객"/>'			,type:'string'},
    		 {name: 'CUSTOM_NAME'		 	,text:'<t:message code="system.label.sales.client" default="고객"/>'				,type:'string'},
    		 {name: 'PROJECT_NO'		 	,text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'		    ,type:'string'},
    		 {name: 'PJT_NAME'			 	,text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'			    ,type:'string'},
    		 {name: 'ORDER_NUM'		 		,text:'<t:message code="system.label.sales.sono" default="수주번호"/>'			,type:'string'},
    		 {name: 'ORDER_DATE'		 	,text:'<t:message code="system.label.sales.sodate" default="수주일"/>'			    ,type:'uniDate'},
    		 {name: 'PJT_AMT'			 	,text:'총금액'			    ,type:'uniPrice'},
    		 {name: 'TOT_ORDER_AMT'	 		,text:'수주금액'			,type:'uniPrice'},
    		 {name: 'TOT_SALE_AMT'		 	,text:'<t:message code="system.label.sales.salesamount2" default="매출금액"/>'			,type:'uniPrice'},
    		 {name: 'COLLECT_AMT'		 	,text:'<t:message code="system.label.sales.collectionamount" default="수금액"/>'			    ,type:'uniPrice'},
    		 {name: 'REMAIN_AMT'		 	,text:'<t:message code="system.label.sales.balanceamount2" default="잔액"/>'				,type:'uniPrice'},
    		 {name: 'COLLECT_RATE'		 	,text:'진척율(%)'			,type:'uniPercent'},
    		 {name: 'SALE_REMAIN_AMT'	 	,text:'수주잔고'			,type:'uniPrice'},
    		 {name: 'BUY_AMT'			 	,text:'매입액'			    ,type:'uniPrice'},
    		 {name: 'ACCOUNT_AMT'		 	,text:'지급결의금액'		,type:'uniPrice'},
    		 {name: 'NOTPAY_AMT'		 	,text:'미지급금'			,type:'uniPrice'},
    		 {name: 'VASALE_AMT'		 	,text:'부가가치매출액'		,type:'uniPrice'},
    		 {name: 'TOT_MAN_COST'		 	,text:'투입인건비'			,type:'uniPrice'},
    		 {name: 'ESTIMATED_PROFIT'	 	,text:'예상손익'			,type:'uniPrice'},
    		 {name: 'ORDER_PRSN'		 	,text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type:'string', comboType:'AU', comboCode:'S010'},
    		 {name: 'DIV_CODE'			 	,text:'<t:message code="system.label.sales.division" default="사업장"/>'			    ,type:'string', comboType:'BOR120', defaultValue:UserInfo.divCode},
    		 {name: 'ORDER_TYPE'		 	,text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type:'string', comboType:'AU', comboCode:'S002'},
    		 {name: 'AGENT_TYPE'		 	,text:'고객구분'			,type:'string', comboType:'AU', comboCode:'B055'},
    		 {name: 'AREA_TYPE'		 		,text:'<t:message code="system.label.sales.area" default="지역"/>'				,type:'string', comboType:'AU', comboCode:'B056'},
    		 {name: 'DIVI'				 	,text:'완료구분'			,type:'string'},
    		 {name: 'REMARK'			 	,text:'<t:message code="system.label.sales.remarks" default="비고"/>'				,type:'string'}  			
		]
	});	
	
	Unilite.defineModel('sof320skrvModel2', {
	    fields: [
	    	 {name: 'ITEM_CODE'	 			,text:'<t:message code="system.label.sales.item" default="품목"/>'			,type:'string'},
    		 {name: 'ITEM_NAME'	 			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'			    ,type:'string'},
    		 {name: 'ORDER_Q'		 		,text:'수주수량'			,type:'uniQty'},
    		 {name: 'DVRY_DATE'	 			,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'			    ,type:'uniDate'},
    		 {name: 'WKORD_Q'		 		,text:'작업지시량'			,type:'uniQty'},
    		 {name: 'PRODT_Q'		 		,text:'생산수량'			,type:'uniQty'},
    		 {name: 'PROD_END_DATE' 		,text:'생산완료일'			,type:'uniDate'},
    		 {name: 'INOUT_DATE'	 		,text:'<t:message code="system.label.sales.issuedate" default="출고일"/>'			    ,type:'uniDate'},
    		 {name: 'ORDER_UNIT_Q'	 		,text:'출고수량'			,type:'uniQty'},
    		 {name: 'REMAIN_Q'		 		,text:'잔량'				,type:'uniQty'},
    		 {name: 'PROCESS_RATE'	 		,text:'진행률(%)'			    ,type:'uniPercent'},
    		 {name: 'DIV_CODE'		 		,text:'<t:message code="system.label.sales.division" default="사업장"/>'			    ,type:'string'},
    		 {name: 'ORDER_NUM'	 			,text:'오더번호'			,type:'string'},
    		 {name: 'SER_NO'		 		,text:'<t:message code="system.label.sales.seq" default="순번"/>'				,type:'string'}  			
		]
	});	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sof320skrvMasterStore1',{
			model: 'sof320skrvModel1',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'sof320skrvService.selectList'                	
                }
            },
            loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});			
			}
			//groupField: 'ITEM_NAME'
	});		
	
	var directMasterStore2 = Unilite.createStore('sof320skrvMasterStore2',{
			model: 'sof320skrvModel2',
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'sof320skrvService.selectList2'                	
                }
            },
            loadStoreRecords: function(record)	{
				var param= Ext.getCmp('searchForm').getValues();
				param.ORDER_NUM = record.data.ORDER_NUM;
				param.DIV_CODE = record.data.DIV_CODE;
				console.log( param );
				this.load({
					params: param
				});
			}
			//groupField: 'CUSTOM_NAME1'	
	});		// End of var directMasterStore2 = Unilite.createStore('sof320skrvMasterStore2',{

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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
    			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    			name:'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType:'BOR120',
    			allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		}, {
    			fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'ORDER_DATE_FR',
			    endFieldName: 'ORDER_DATE_TO',
			    startDate: UniDate.get('startOfMonth'),
			    endDate: UniDate.get('today'),
			    width:315,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			}, 
				Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName: 'PROJECT_NO_CODE',
				textFieldName: 'PROJECT_NO_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PROJECT_NO_CODE', panelSearch.getValue('PROJECT_NO_CODE'));
							panelResult.setValue('PROJECT_NO_NAME', panelSearch.getValue('PROJECT_NO_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PROJECT_NO_CODE', '');
						panelResult.setValue('PROJECT_NO_NAME', '');
					}
				}
			}),{
    			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
    			name:'SALE_PRSN',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'S010',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALE_PRSN', newValue);
					}
				}
    		},
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),{
    	  		xtype: 'radiogroup',		            		
			    fieldLabel: '진척율100%',						            		
			    items : [{
			    	boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>',
			    	width: 60,
			    	name: 'RDO_PROGRESS',
			    	inputValue: '1',
                    checked: true
			    },{
			    	boxLabel: '제외',
			    	width: 60,
			    	name: 'RDO_PROGRESS',
			    	inputValue: '2'
			    }],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelResult.getField('RDO_PROGRESS').setValue(newValue.RDO_PROGRESS);
					}
				}	
			}]
		},{ 
			title: '<t:message code="system.label.sales.additionalinfo" default="추가정보"/>', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
    			fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'	,
    			name:'AGENT_TYPE',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'B055'
    		},{
    			fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	,
    			name:'ORDER_TYPE',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'S002'
    		},{
    			fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>'	,
    			name:'AREA_TYPE',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'B056'
    		},{
    	  		xtype: 'radiogroup',		            		
			    fieldLabel: '완료구분',						            		
			    id: 'rdoSelect',						            		
			    items : [{
			    	boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
			    	width: 60,
			    	name: 'rdoSelect',
			    	inputValue: '',
                    checked: true
			    },{
			    	boxLabel: '예',
			    	width: 60,
			    	name: 'rdoSelect',
			    	inputValue: 'A'
			    },{
			    	boxLabel: '아니요',
			    	width: 60,
			    	name: 'rdoSelect',
			    	inputValue: 'N'
			    }]	
			},{
				fieldLabel: '총금액',
				name:'FR_ORDER_AMT',
				xtype: 'uniTextfield',
				suffixTpl: '이상'
			}, {
				fieldLabel: '~',
				name:'TO_ORDER_AMT',
				xtype: 'uniTextfield',
				suffixTpl: '이하'
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
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'ORDER_DATE_FR',
		    endFieldName: 'ORDER_DATE_TO',
		    startDate: UniDate.get('startOfMonth'),
		    endDate: UniDate.get('today'),
		    width:315,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ORDER_DATE_TO',newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
		}, 
			Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName: 'PROJECT_NO_CODE',
			textFieldName: 'PROJECT_NO_NAME',
			autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PROJECT_NO_CODE', panelResult.getValue('PROJECT_NO_CODE'));
						panelSearch.setValue('PROJECT_NO_NAME', panelResult.getValue('PROJECT_NO_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PROJECT_NO_CODE', '');
					panelSearch.setValue('PROJECT_NO_NAME', '');
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name:'SALE_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
	  		xtype: 'radiogroup',		            		
		    fieldLabel: '진척율100%',						            		
		    items : [{
		    	boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>',
		    	width: 60,
		    	name: 'RDO_PROGRESS',
		    	inputValue: '1',
                checked: true
		    },{
		    	boxLabel: '제외',
		    	width: 60,
		    	name: 'RDO_PROGRESS',
		    	inputValue: '2'
		    }],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('RDO_PROGRESS').setValue(newValue.RDO_PROGRESS);
				}
			}	
		}]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('sof320skrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true,
                    onLoadSelectFirst   : true, 
        },
/*        tbar: [{
        	text:'<t:message code="system.label.sales.detailsview" default="상세보기"/>',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
        selModel:'rowmodel',
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	 {dataIndex: 'CUSTOM_CODE'		       	,      		width: 66 , hidden: true}, 				
			 {dataIndex: 'CUSTOM_NAME'		       	,      		width: 133}, 				
			 {dataIndex: 'PROJECT_NO'		     	,      		width: 100}, 
			 {dataIndex: 'PJT_NAME'			       	,      		width: 133}, 				
			 {dataIndex: 'ORDER_NUM'			    ,      		width: 100}, 				
			 {dataIndex: 'ORDER_DATE'		       	,      		width: 80}, 
			 {dataIndex: 'PJT_AMT'			       	,      		width: 100}, 				
			 {dataIndex: 'TOT_ORDER_AMT'		    ,      		width: 100}, 				
			 {dataIndex: 'TOT_SALE_AMT'		       	,      		width: 100}, 
			 {dataIndex: 'COLLECT_AMT'		        ,      		width: 100}, 				
			 {dataIndex: 'REMAIN_AMT'		       	,      		width: 100}, 				
			 {dataIndex: 'COLLECT_RATE'		       	,      		width: 100}, 
			 {dataIndex: 'SALE_REMAIN_AMT'	       	,      		width: 100}, 				
			 {dataIndex: 'BUY_AMT'			       	,      		width: 100}, 				
			 {dataIndex: 'ACCOUNT_AMT'		       	,      		width: 100}, 
			 {dataIndex: 'NOTPAY_AMT'		       	,      		width: 100}, 				
			 {dataIndex: 'VASALE_AMT'		       	,      		width: 110}, 				
			 {dataIndex: 'TOT_MAN_COST'		       	,      		width: 106}, 
			 {dataIndex: 'ESTIMATED_PROFIT'	       	,      		width: 106}, 				
			 {dataIndex: 'ORDER_PRSN'		       	,      		width: 90}, 				
			 {dataIndex: 'DIV_CODE'			       	,      		width: 90}, 
			 {dataIndex: 'ORDER_TYPE'		       	,      		width: 90}, 				
			 {dataIndex: 'AGENT_TYPE'		       	,      		width: 90}, 				
			 {dataIndex: 'AREA_TYPE'			    ,      		width: 90}, 
			 {dataIndex: 'DIVI'				       	,      		width: 90}, 				
			 {dataIndex: 'REMARK'			       	,      		width: 166}
        ],
        listeners:{
        	select: function(grid, record, index, eOpts ){      
        		directMasterStore2.loadStoreRecords(record);
            }   
        }
    });		// End of var masterGrid= Unilite.createGrid('sof320skrvGrid1', {
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
	var detailGrid= Unilite.createGrid('sof320skrvGrid2', {
    	layout : 'fit',
    	region:'south',
        store : directMasterStore2, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
/*        tbar: [{
        	text:'<t:message code="system.label.sales.detailsview" default="상세보기"/>',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
	    	features: [{
	    		id: 'masterGridSubTotal', 
	    		ftype: 'uniGroupingsummary',
	    		showSummaryRow: false 
	    	},{
	    		id: 'masterGridTotal',
	    		ftype: 'uniSummary',
	    		showSummaryRow: false
	    }],
	    columns:  [
        	 {dataIndex: 'ITEM_CODE'			,      		width: 106}, 				
			 {dataIndex: 'ITEM_NAME'		    ,      		width: 140}, 				
			 {dataIndex: 'ORDER_Q'		       	,      		width: 86}, 
			 {dataIndex: 'DVRY_DATE'		    ,      		width: 86}, 				
			 {dataIndex: 'WKORD_Q'		       	,      		width: 86}, 				
			 {dataIndex: 'PRODT_Q'		       	,      		width: 86}, 
			 {dataIndex: 'PROD_END_DATE'	    ,      		width: 86}, 				
			 {dataIndex: 'INOUT_DATE'	       	,      		width: 86}, 				
			 {dataIndex: 'ORDER_UNIT_Q'	       	,      		width: 86}, 
			 {dataIndex: 'REMAIN_Q'		       	,      		width: 86}, 				
			 {dataIndex: 'PROCESS_RATE'	       	,      		width: 86}, 				
			 {dataIndex: 'DIV_CODE'		       	,      		width: 66 ,hidden: true}, 
			 {dataIndex: 'ORDER_NUM'		    ,      		width: 66 ,hidden: true}, 				
			 {dataIndex: 'SER_NO'		       	,      		width: 66 ,hidden: true}

        ] 
	});		// End of var detailGrid= Unilite.createGrid('sof320skrvGrid2', {
    
    Unilite.Main({
    	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				masterGrid, detailGrid
			]	
		},
			panelSearch
		],		
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid, detailGrid
			]	
		}		
		,panelSearch 
		],
		id: 'sof320skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
			//var viewLocked = masterGrid.lockedGrid.getView();
			//var viewNormal = masterGrid.normalGrid.getView();
			//console.log("viewLocked : ",viewLocked);
			//console.log("viewNormal : ",viewNormal);
		    //viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    //viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    //viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    //viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>