<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl120skrv"  >
<t:ExtComboStore comboType="BOR120"  /> 					 	<!-- 사업장 -->  
<t:ExtComboStore comboType="AU" comboCode="B020" /> 		 	<!-- 품목계정 -->
<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->

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
	Unilite.defineModel('Ppl120skrvModel', {
		fields: [
			{name: 'DIV_CODE'		    , text: '<t:message code="system.label.product.division" default="사업장"/>'				, type: 'string'},
			{name: 'WORKSHOP'		    , text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				, type: 'string'},
			{name: 'ITEM'		    , text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		    , text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'GUBUN'		    , text: '<t:message code="system.label.product.classfication" default="구분"/>'				, type: 'string'},
			{name: 'ITEM_CODE'		    , text: '<t:message code="system.label.product.onhandstock" default="현재고"/>'				, type: 'string'},
			
			
			{name: 'T_WK_PLAN_Q'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'T_WK_PLAN_A'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'T_PL_A'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'T_PRICE_A'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q1'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A1'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A1'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A1'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q2'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A2'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A2'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A2'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q3'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A3'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A3'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A3'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q4'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A4'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A4'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A4'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q5'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A5'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A5'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A5'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q6'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A6'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A6'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A6'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q7'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A7'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A7'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A7'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q8'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A8'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A8'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A8'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q9'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A9'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A9'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A9'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q10'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A10'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A10'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A10'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q11'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A11'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A11'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A11'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'},
			
			{name: 'WK_PLAN_Q12'		    , text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'				, type: 'uniQty'},
			{name: 'WK_PLAN_A12'		    , text: '<t:message code="system.label.product.resultsamount" default="실적액"/>'				, type: 'uniPrice'},
			{name: 'PL_A12'		    , text: '<t:message code="system.label.product.plunitprice" default="PL단가"/>'				, type: 'uniUnitPrice'},
			{name: 'PRICE_A12'		    , text: '<t:message code="system.label.product.receiptamount" default="입고액"/>'				, type: 'uniPrice'}
		]                           
	});		//End of Unilite.defineModel('Ppl120skrvModel', {
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */		
	var MasterStore = Unilite.createStore('ppl120skrvMasterStore',{
		model: 'Ppl120skrvModel',
		uniOpt: {
			isMaster: 	true,			// 상위 버튼 연결 
			editable: 	false,			// 수정 모드 사용 
    		deletable:	false,			// 삭제 가능 여부 
        	useNavi : 	false			// prev | next 버튼 사용
		},
		autoLoad: false,
 		proxy: {
			type: 'direct',
			api: {			
				read: 'ppl120skrvService.selectList0'                	
				 }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();		
				param.TYPE ="1";
					console.log( param );
					this.load({
						params : param
					});
				}
	});		//End of var directMasterStore1 = Unilite.createStore('ppl120skrvMasterStore1',{

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		 		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		allowBlank:false,
		 		value : UserInfo.divCode,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		 	},{
            	fieldLabel: '<t:message code="system.label.product.baseyear" default="기준년도"/>',
            	name: 'FR_DATE',
            	xtype: 'uniYearField',
		 		value: new Date().getFullYear(),
				holdable: 'hold', 
            	allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FR_DATE', newValue);
						/*var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
						getDate(date);*/
					}
				}
            }	 			 	
		 	
/*		 	,{
            	fieldLabel: '<t:message code="system.label.product.planmonth" default="계획월"/>',
            	name: 'FR_DATE',
            	xtype: 'uniMonthfield',
		 		value: UniDate.get('startOfMonth'),
            	allowBlank: false,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('FR_DATE', newValue);
					}
				}
			}*/
			]
		}],
		setAllFieldsReadOnly: function(b) { 								//////////////////////////// 필수값 입력안하고 조회버튼 눌렀을떄 메세지 처리 함수
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
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
		 		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		 		name:'DIV_CODE', 
		 		xtype: 'uniCombobox',
		 		comboType:'BOR120',
		 		allowBlank:false,
		 		value : UserInfo.divCode,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		 	},{
		 		fieldLabel: '<t:message code="system.label.product.baseyear" default="기준년도"/>',
		 		xtype: 'uniYearField',
		 		name: 'FR_DATE',
		 		value: new Date().getFullYear(),
		 		allowBlank:false,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('FR_DATE', newValue);
					/*var date=Ext.util.Format.date(panelSearch.getValue('FR_DATE'), 'Y-m-d');
					getDate(date);*/
					}
				}
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid= Unilite.createGrid('ppl120skrvGrid', {
    	layout : 'fit',
    	region:'center',
        title: '<t:message code="system.label.product.itembystatus" default="품목별현황"/>',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			},
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        	columns: [
        		
				{dataIndex:'DIV_CODE'        , width: 0,	hidden: true},
        		{text :'<t:message code="system.label.product.iteminfo" default="품목정보"/>',locked: true,
	        			columns:[ 
	        				
	        				{dataIndex:'WORKSHOP'       , width: 100, 
                                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                                    
                                return Unilite.renderSummaryRow(summaryData, metaData, '','<t:message code="system.label.product.totalamount" default="합계"/>');
                                }
                            },
	        				{text :'<t:message code="system.label.product.itemname" default="품목명"/>',
				        			columns:[ 
				        				{dataIndex:'ITEM_NAME'       , width: 126}
				        			]
			        		},
			        		{dataIndex:'GUBUN'       , width: 68 , align:'center' },
			        		{text :'<t:message code="system.label.product.item" default="품목"/>',
				        			columns:[ 
				        				{dataIndex:'ITEM_CODE'       , width: 126}
				        			]
			        		}
	        			]
        		},
        		{text :'<t:message code="system.label.product.whole" default="전체"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'T_WK_PLAN_Q'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'T_WK_PLAN_A'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'T_PL_A'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'T_PRICE_A'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'1<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q1'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A1'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A1'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A1'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'2<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q2'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A2'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A2'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A2'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'3<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q3'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A3'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A3'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A3'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'4<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q4'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A4'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A4'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A4'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'5<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q5'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A5'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A5'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A5'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'6<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q6'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A6'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A6'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A6'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'7<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q7'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A7'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A7'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A7'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'8<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q8'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A8'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A8'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A8'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'9<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q9'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A9'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A9'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A9'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'10<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q10'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A10'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A10'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A10'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'11<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q11'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A11'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A11'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A11'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		},
        		{text :'12<t:message code="system.label.product.month" default="월"/>',
	        			columns:[ 
	        			//계획량 계획액 PL액 발주액
	        				{text :'<t:message code="system.label.product.planqty" default="계획량"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_Q12'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.planamount" default="계획액"/>',
				        			columns:[ 
				        				{dataIndex:'WK_PLAN_A12'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.plamount" default="PL액"/>',
				        			columns:[ 
				        				{dataIndex:'PL_A12'       , width: 126, summaryType: 'sum'}
				        			]
			        		},
			        		{text :'<t:message code="system.label.product.poamount" default="발주액"/>',
				        			columns:[ 
				        				{dataIndex:'PRICE_A12'       , width: 126, summaryType: 'sum'}
				        			]
			        		}
		
	        			]
        		}
        		
		]                                    
    });	
    
    
    Unilite.Main({
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
		id : 'ppl120skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
		},
		onQueryButtonDown: function() {		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}
			else{			
				var viewNormal = masterGrid.normalGrid.getView();
				var viewLocked = masterGrid.lockedGrid.getView();
				MasterStore.loadStoreRecords();
				console.log("viewNormal : ",viewNormal);
				console.log("viewLocked : ",viewLocked);
		    	viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    	viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    	viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    	viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				
			}
		},
		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()){
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});		// End of Unilite.Main
};
</script>

