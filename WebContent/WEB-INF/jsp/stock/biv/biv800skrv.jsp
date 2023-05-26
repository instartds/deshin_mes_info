<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv800skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="biv800skrv" /> 				<!-- 사업장 -->
	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
	<t:ExtComboStore comboType="AU" comboCode="B035" />  
	<t:ExtComboStore comboType="AU" comboCode="B131" />  
	<t:ExtComboStore comboType="AU" comboCode="B711" />  
	<t:ExtComboStore comboType="AU" comboCode="B712" />  
	<t:ExtComboStore comboType="AU" comboCode="B713" />  
	<t:ExtComboStore comboType="OU"  />  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
   var biv800skrvModel=Unilite.defineModel('biv800skrvModel', {
   	fields: [
   	     	 { name : 'DIV_CODE'					, text : '사업장코드'	, type : 'string' }
   		   , { name : 'ITEM_CODE'					, text : '품목코드'	, type : 'string' }
   		   , { name : 'ITEM_NAME'					, text : '폼목명'		, type : 'string' }
   		   , { name : 'SPEC'						, text : '규격'		, type : 'string' }
   		   , { name : 'WH_CODE'						, text : '창고'		, type : 'string' , comboType:'OU'}
   		   , { name : 'INOUT_TYPE'					, text : '수불타입'	, type : 'string' , comboType:'AU', comboCode:'B035'}
   		   , { name : 'INOUT_TYPE_DETAIL_NAME'		, text : '수불유형'	, type : 'string' }
   		   , { name : 'INOUT_DATE'					, text : '수불일'		, type : 'uniDate' }
   		   , { name : 'INOUT_NUM'					, text : '수불번호'	, type : 'string' }
   		   , { name : 'INOUT_SEQ'					, text : '순번'	    , type : 'int'    }
   		   , { name : 'IN_Q'						, text : '입고량'		, type : 'uniQty'  	}
   		   , { name : 'OUT_Q'						, text : '출고량'		, type : 'uniQty' 	}
   		   , { name : 'ALLOC_Q'						, text : '선출량'		, type : 'uniQty' 	}
   		   , { name : 'INOUT_P'						, text : '단가'		, type : 'uniUnitPrice' }
   		   , { name : 'IN_I'						, text : '입고액'		, type : 'uniPrice' }
   		   , { name : 'OUT_I'						, text : '출고액'		, type : 'uniPrice' }

   		   , { name : 'IN_FIFO_STATUS'				, text : '처리구분'	, type : 'string' 	, comboType:'AU', comboCode:'B712'}
   		   , { name : 'IN_IN_Q'						, text : '입고량'		, type : 'uniQty' 	, convert : nulltoBlank}
   		   , { name : 'IN_OUT_Q'					, text : '출고량'		, type : 'uniQty' 	, convert : nulltoBlank}
   		   , { name : 'IN_BAL_Q'					, text : '잔량'		, type : 'uniQty' 	, convert : nulltoBlank}
   		   , { name : 'IN_PRICE_GUBUN'				, text : '단가구분'	, type : 'string' 	, comboType:'AU', comboCode:'B711'}
   		   , { name : 'IN_CONFIRM_YN'				, text : '단가확정'	, type : 'string' 	, comboType:'AU', comboCode:'B131'}
   		   , { name : 'IN_IN_P'						, text : '입고단가'	, type : 'uniUnitPrice' , convert : nulltoBlank}
   		   , { name : 'BASIS_GUBUN'		  			, text : '참조구분'	, type : 'string' , comboType:'AU', comboCode:'B713'}
   		   , { name : 'BASIS_NUM'					, text : '참조번호'	, type : 'string' }
   		   , { name : 'BASIS_SEQ'					, text : '순번'	    , type : 'int'      , convert : nulltoBlank}
   		   
   		   , { name : 'OUT_FIFO_STATUS'				, text : '처리구분'	, type : 'string' , comboType:'AU', comboCode:'B712'}
   		   , { name : 'OUT_IN_NUM'					, text : '입고번호'	, type : 'string' }
   		   , { name : 'OUT_IN_SEQ'					, text : '순번'	    , type : 'int'    , convert : nulltoBlank}
   		   , { name : 'OUT_OUT_Q'					, text : '출고량'		, type : 'uniQty' , convert : nulltoBlank}
   		   , { name : 'OUT_IN_Q'					, text : '입고량'		, type : 'uniQty' , convert : nulltoBlank}
   		   , { name : 'OUT_LAST_BAL_Q'				, text : '선출_전'	, type : 'uniQty' , convert : nulltoBlank}
   		   , { name : 'OUT_ALLOC_Q'					, text : '선출량'		, type : 'uniQty' , convert : nulltoBlank}
   		   , { name : 'OUT_BAL_Q'					, text : '선출_후'	, type : 'uniQty' , convert : nulltoBlank}
   		   , { name : 'OUT_PRICE_GUBUN'				, text : '단가구분'	, type : 'string' , comboType:'AU', comboCode:'B711'}
   		   , { name : 'OUT_CONFIRM_YN'				, text : '단가확정'	, type : 'string' , comboType:'AU', comboCode:'B131'}
   		   , { name : 'OUT_OUT_P'					, text : '출고단가'	, type : 'uniUnitPrice' , convert : nulltoBlank}
		]
   });
   
   function nulltoBlank (value) {
	   if(Ext.isEmpty(value)){
		   return '';
	   } else {
		  return value;
	   }
   }
  
   var biv800skrvStore=Unilite.createStore('Store', {	
   		model: 'biv800skrvModel',
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
				read    : 'biv800skrvService.selectList'
				
			}
		},
		loadStoreRecords : function()	{
			var param= panelResult.getValues();	
			
			console.log("param", param);
			this.load({
				params : param
			});
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
					}
				}
			},{
				fieldLabel: '수불기간',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_TO',newValue);
					}
				}
			}, { 
				name: 'ITEM_ACCOUNT',
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
			,Unilite.popup('DIV_PUMOK',{
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
			})      
			,{ 
				name: 'ITEM_LEVEL1', 
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
			},{ 
				name: 'ITEM_LEVEL2',
				fieldLabel: '중분류',
				maxLength: 200,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL3',
				fieldLabel: '소분류',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}]
		}]
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
        		},{
    				fieldLabel: '수불기간',
    				xtype: 'uniDateRangefield',
    				startFieldName: 'INOUT_DATE_FR',
    				endFieldName: 'INOUT_DATE_TO',
    				startDate: UniDate.get('startOfMonth'),
    				endDate: UniDate.get('today'),
    				allowBlank: false,
    				width: 315,
    				colspan : 2,
    				onStartDateChange: function(field, newValue, oldValue, eOpts) {
    					if(panelResult) {
    						panelResult.setValue('INOUT_DATE_FR',newValue);
    					}
    				},
    				onEndDateChange: function(field, newValue, oldValue, eOpts) {
    					if(panelResult) {
    						panelResult.setValue('INOUT_DATE_TO',newValue);
    					}
    				}
    			},{ 
    				name: 'ITEM_ACCOUNT',
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
        		},Unilite.popup('DIV_PUMOK',{
		  			fieldLabel: '품목코드',
		  			valueFieldName: 'ITEM_CODE',
		  			textFieldName: 'ITEM_NAME',
		  			colspan:2,
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
		  		}) ,{ 
        			name: 'ITEM_LEVEL1', 
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
				}]
    	});		
	 /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('tio110skrvGrid1', {
		layout: 'fit',
		region: 'center',
		//excelTitle: '발주현황조회',
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
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
        },
    	store: biv800skrvStore,
        columns: [
        	 	 { dataIndex : 'DIV_CODE'					, width : 100 , hidden :true , locked:true}
        	   , { dataIndex : 'ITEM_CODE'					, width : 100 , locked:true ,
				   summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
					}
        	     }
        	   , { dataIndex : 'ITEM_NAME'					, width : 200 , locked:true}
        	   , { dataIndex : 'SPEC'						, width : 200 , locked:true}

      		   , {
    				text	: '수불내역',
    				columns	: [
    			        	     { dataIndex : 'WH_CODE'					, width : 100 }
      			        	   , { dataIndex : 'INOUT_TYPE'					, width : 70 }
    			        	   , { dataIndex : 'INOUT_TYPE_DETAIL_NAME'		, width : 100 }
    			        	   , { dataIndex : 'INOUT_DATE'					, width : 80 }
    			        	   , { dataIndex : 'INOUT_NUM'					, width : 120 }
    			        	   , { dataIndex : 'INOUT_SEQ'					, width : 50 , align : 'center'}
    			        	   , { dataIndex : 'IN_Q'						, width : 70 , summaryType : 'sum'}
    			        	   , { dataIndex : 'OUT_Q'						, width : 70 , summaryType : 'sum'}
    			        	   , { dataIndex : 'ALLOC_Q'					, width : 70 , summaryType : 'sum'}
    			        	   , { dataIndex : 'INOUT_P'					, width : 70 }
    			        	   , { dataIndex : 'IN_I'						, width : 90 , summaryType : 'sum'}
    			        	   , { dataIndex : 'OUT_I'						, width : 90 , summaryType : 'sum'}
     				]
    		   }        	   
        	   
      		   , {
	   				text	: '선입내역',
	   				columns	: [
	   			        	     { dataIndex : 'IN_FIFO_STATUS'				, width : 100 }
	     			           , { dataIndex : 'IN_IN_Q'					, width : 70 }
	   			        	   , { dataIndex : 'IN_OUT_Q'					, width : 70 }
	   			        	   , { dataIndex : 'IN_BAL_Q'					, width : 70 }
	   			        	   , { dataIndex : 'IN_PRICE_GUBUN'				, width : 100 }
	   			        	   , { dataIndex : 'IN_CONFIRM_YN'				, width : 80 }
	   			        	   , { dataIndex : 'IN_IN_P'					, width : 70 }
	   			        	   , { dataIndex : 'BASIS_GUBUN'				, width : 100 }
	   			        	   , { dataIndex : 'BASIS_NUM'					, width : 120 }
	   			        	   , { dataIndex : 'BASIS_SEQ'					, width : 50, align : 'center'}
	    				]
	   		   }        	   
        	   
      		   , {
	   				text	: '선출내역',
	   				columns	: [
	   			        	     { dataIndex : 'OUT_FIFO_STATUS'			, width : 100 }
			   			   	   , { dataIndex : 'OUT_IN_NUM'					, width : 120 }
			   			   	   , { dataIndex : 'OUT_IN_SEQ'					, width : 50, align : 'center'}
		     			       , { dataIndex : 'OUT_OUT_Q'					, width : 70 }
		   			           , { dataIndex : 'OUT_IN_Q'					, width : 70 }
		   			           , { dataIndex : 'OUT_LAST_BAL_Q'				, width : 70 }
		   			           , { dataIndex : 'OUT_ALLOC_Q'				, width : 70 }
		   			           , { dataIndex : 'OUT_BAL_Q'					, width : 70 }
		   			       	   , { dataIndex : 'OUT_PRICE_GUBUN'			, width : 100 }
		   			       	   , { dataIndex : 'OUT_CONFIRM_YN'				, width : 80 }
		   			       	   , { dataIndex : 'OUT_OUT_P'					, width : 70 }
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
		id: 'biv800skrvApp',
		fnInitBinding: function(param) {
			if(param && param.DIV_CODE)	{
				panelResult.setValue("DIV_CODE",param.DIV_CODE);
				panelSearch.setValue("DIV_CODE",param.DIV_CODE);
			}
		},
		onQueryButtonDown: function() {	
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			 	masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.getStore().loadData({});
			panelResult.clearForm();
			this.fnInitBinding();
		}
	});
    
};
</script>