<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="srq155skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="srq155skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--수주구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S085" /> <!--picking상태 -->
	<t:ExtComboStore comboType="AU" comboCode="S063" /> <!--주문유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S065" /> <!--주문구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */	
	Unilite.defineModel('srq155skrvModel', {
	    fields: [  	 
	    	 {name: 'CHOICE'           		,text: '<t:message code="system.label.sales.selection" default="선택"/>' 				,type: 'string'},
    		 {name: 'ISSUE_REQ_NUM'			,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>' 		,type: 'string'},
    		 {name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.client" default="고객"/>' 			,type: 'string'},
    		 {name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.client" default="고객"/>' 				,type: 'string'},
    		 {name: 'PICK_STATUS'			,text: '상태' 				,type: 'string'},
    		 {name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>' 			,type: 'string'},
    		 
    		 {name: 'ITEM_NAME'        		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 			,type: 'string'},
    		 {name: 'SPEC'             		,text: '<t:message code="system.label.sales.spec" default="규격"/>' 				,type: 'string'},
    		 {name: 'STOCK_UNIT'       		,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>' 			,type: 'string', displayField: 'value'},
    		 {name: 'ISSUE_REQ_QTY'			,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>' 		,type: 'string'},
    		 {name: 'ISSUE_QTY'		   		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>' 			,type: 'string'},
    		 {name: 'STOCK_Q'		   		,text: '<t:message code="system.label.sales.inventoryqty" default="재고량"/>' 			,type: 'string'},
    		 {name: 'ISSUE_REQ_DATE'   		,text: '<t:message code="system.label.sales.shipmentorderdate" default="출하지시일"/>'			,type: 'string'},
    		 {name: 'ISSUE_DATE'			,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>' 		,type: 'string'},
    		 {name: 'ISSUE_DIV_CODE'   		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>' 		,type: 'string'},
    		 {name: 'WH_CODE'				,text: '<t:message code="system.label.sales.warehouse" default="창고"/>' 				,type: 'string'},
    		 {name: 'WH_NAME'				,text: '<t:message code="system.label.sales.warehouse" default="창고"/>' 				,type: 'string'},
    		 {name: 'WH_CELL_CODE'			,text: '창고 Cell' 			,type: 'string'},
    		 {name: 'WH_CELL_NAME'			,text: '창고 Cell' 			,type: 'string'},
    		 {name: 'LOT_NO'           		,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>' 			,type: 'string'},
    		
    		 {name: 'COMP_CODE'				,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>' 			,type: 'string'},
    		 {name: 'DIV_CODE'				,text: '<t:message code="system.label.sales.division" default="사업장"/>' 			,type: 'string'},
    		 {name: 'ORDER_Q'          		,text: '주문량' 			,type: 'string'},
    		 {name: 'ISSUE_REQ_Q'      		,text: '수주출하지시량'		,type: 'string'},
    		 {name: 'OUTSTOCK_Q'       		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>' 			,type: 'string'},
    		 {name: 'RETURN_Q'         		,text: '<t:message code="system.label.sales.returnqty" default="반품량"/>' 			,type: 'string'},
    		 {name: 'DVRY_DATE'        		,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>' 			,type: 'string'},
    		 {name: 'ORDER_UNIT'       		,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>' 			,type: 'string', displayField: 'value'},
    		 {name: 'TRANS_RATE'       		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'string'},
    		 {name: 'BILL_TYPE'        		,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>' 		,type: 'string'},
    		 {name: 'ORDER_TYPE'       		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>' 			,type: 'string'},
    		 {name: 'INOUT_TYPE_DETAIL'		,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>' 			,type: 'string'},
    		 {name: 'ORDER_PRSN'       		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>' 			,type: 'string'},
    		 {name: 'ORDER_NUM'        		,text: '<t:message code="system.label.sales.sono" default="수주번호"/>' 			,type: 'string'},
    		 {name: 'SER_NO'           		,text: '<t:message code="system.label.sales.seq" default="순번"/>' 				,type: 'string'},
    		 {name: 'PO_NUM'           		,text: 'P/O번호' 			,type: 'string'},
    		 {name: 'PO_SEQ'           		,text: 'P/O순번' 			,type: 'string'},
    		 {name: 'ISSUE_DIV_CODE'   		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>' 		,type: 'string'},
    		 {name: 'SALE_CUSTOM_CODE' 		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>' 		,type: 'string'},
    		 {name: 'SALE_CUSTOM_NAME' 		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>' 			,type: 'string'},
    		 {name: 'ACCOUNT_YNC'       	,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>' 			,type: 'string'},
    		 {name: 'PROJECT_NO'       		,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>' 		,type: 'string'},
    		 {name: 'REMARK'           		,text: '<t:message code="system.label.sales.remarks" default="비고"/>' 				,type: 'string'},
    		
    		 {name: 'SO_TYPE'          		,text: '주문유형' 			,type: 'string'},
    		 {name: 'SO_KIND'          		,text: '<t:message code="system.label.sales.ordertype" default="주문구분"/>' 			,type: 'string'},
    		 {name: 'CUSTOMER_ID'      		,text: '주문자코드' 		,type: 'string'},
    		 {name: 'CUSTOMER_NAME'    		,text: '주문자' 			,type: 'string'},
    		 {name: 'RECEIVER_ID'      		,text: '<t:message code="system.label.sales.receiverid" default="수신자ID"/>' 		,type: 'string'},
    		 {name: 'RECEIVER_NAME'    		,text: '<t:message code="system.label.sales.receivername" default="수신자명"/>' 			,type: 'string'},
    		 {name: 'TELEPHONE_NUM1'   		,text: '전화번호1' 			,type: 'string'},
    		 {name: 'TELEPHONE_NUM2'   		,text: '전화번호2' 			,type: 'string'},
    		 {name: 'ADDRESS'          		,text: '<t:message code="system.label.sales.address" default="주소"/>' 				,type: 'string'},
    		 {name: 'DVRY_CUST_CD'     		,text: '<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>' 		,type: 'string'},
    		 {name: 'PICK_BOX_QTY'     		,text: 'Box수량' 			,type: 'string'},
    		 {name: 'PICK_EA_QTY'      		,text: 'EA수량' 			,type: 'string'},
    		 {name: 'SORT_KEY'         		,text: '정렬KEY' 			,type: 'string'}
		]
	});		//End of Unilite.defineModel('srq155skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('srq155skrvMasterStore1',{
			model: 'srq155skrvModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'srq155skrvService.selectList1'                	
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});	
			},
			groupField: 'ITEM_NAME'
	});		// End of var directMasterStore1 = Unilite.createStore('srq155skrvMasterStore1',{
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
		    items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
				name: 'SALES_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S010',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALES_PRSN', newValue);
					}
				}
			}, {
				fieldLabel: 'Packing 지시일',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'ISSUE_DATE_FR',
	            endFieldName: 'ISSUE_DATE_TO',				               
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            width: 315,
	            endDate: UniDate.get('today'),                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('ISSUE_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ISSUE_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			}, {
				fieldLabel: 'Picking 번호'	,
				name: 'ISSUE_REQ_NUM',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ISSUE_REQ_NUM', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.receivername" default="수신자명"/>'	,
				name: 'RECEIVER_NAME',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIVER_NAME', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'DVRY_DATE_FR',
	            endFieldName: 'DVRY_DATE_TO',				               
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            width: 315,
	            endDate: UniDate.get('today'),                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DVRY_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			}]
			}, {	
				title: '<t:message code="system.label.sales.additionalinfo" default="추가정보"/>', 	
				itemId: 'search_panel2',
		       	layout: {type: 'uniTable', columns: 1},
		       	defaultType: 'uniTextfield',
			    items: [{
				fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'	,
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B055'/*,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}*/
			}, {
	            xtype: 'radiogroup',		            		
	            fieldLabel: 'Picking 상태',            
	            items: [{
	            	boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
	            	width: 60,
	            	name: 'STATUS',
	            	inputValue: 'A'
	            }, {
	            	boxLabel: '미완료',
	            	width: 60, 
	            	name: 'STATUS',
	            	inputValue: 'Y',
	            	checked: true
	            }, {
	            	boxLabel: '완료',
	            	width: 60,
	            	name: 'STATUS' ,
	            	inputValue: 'N'
	            }]/*,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelResult.getField('STATUS').setValue(newValue.STATUS);
					}
				}*/
	        }, {
					fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	,
					name: '',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B055'
				},{
					fieldLabel: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'	,
					name: '',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S007'
				},
					Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',					
					validateBlank: false,
					id: 'bpr400ukrvCustPopup'
				}),{
        			fieldLabel: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
        			name: '',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120'
        		},{
        			fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
        			name: '',
        			xtype: 'uniCombobox',
        			comboType: 'AU'
        		},	
        			Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
		        	listeners: {
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
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
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
			name: 'SALES_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALES_PRSN', newValue);
				}
			}
		}, {
			fieldLabel: 'Packing 지시일',
            xtype: 'uniDateRangefield',
            startFieldName: 'ISSUE_DATE_FR',
            endFieldName: 'ISSUE_DATE_TO',				               
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            width: 315,
            endDate: UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('ISSUE_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ISSUE_DATE_TO',newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
		}, {
			fieldLabel: 'Picking 번호'	,
			name: 'ISSUE_REQ_NUM',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ISSUE_REQ_NUM', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.receivername" default="수신자명"/>'	,
			name: 'RECEIVER_NAME',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('RECEIVER_NAME', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
            xtype: 'uniDateRangefield',
            startFieldName: 'DVRY_DATE_FR',
            endFieldName: 'DVRY_DATE_TO',				               
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            width: 315,
            endDate: UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DVRY_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DVRY_DATE_TO',newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
		}/*, {
			fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'	,
			name: 'ORDER_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B055',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		}, {
            xtype: 'radiogroup',		            		
            fieldLabel: 'Picking 상태',            
            items: [{
            	boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
            	width: 60,
            	name: 'STATUS',
            	inputValue: 'A'
            }, {
            	boxLabel: '미완료',
            	width: 60, 
            	name: 'STATUS',
            	inputValue: 'Y',
            	checked: true
            }, {
            	boxLabel: '완료',
            	width: 60,
            	name: 'STATUS' ,
            	inputValue: 'N'
            }],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('STATUS').setValue(newValue.STATUS);
				}
			}
        }*/]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('srq155skrvGrid1', {
        layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'<t:message code="system.label.sales.detailsview" default="상세보기"/>',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	
    	store: directMasterStore1,
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [
        	{text:'Picking List' , locked: true ,
        		columns: [
		        	{ dataIndex: 'CHOICE'               ,   width: 33 , locked: true}, 				
					{ dataIndex: 'ISSUE_REQ_NUM'	    ,   width: 100, locked: true},

					{ dataIndex: 'CUSTOM_NAME'		    ,   width: 120, locked: true},
					{ dataIndex: 'PICK_STATUS'		    ,   width: 66 , locked: true}, 				
					{ dataIndex: 'ITEM_CODE'		    ,   width: 80 , locked: true}
				]},
			{ dataIndex: 'CUSTOM_CODE'		    ,   width: 66 , hidden: true}, 	
			{text:'Picking List' , 
        		columns: [	
					{ dataIndex: 'ITEM_NAME'            ,   width: 133}, 				
					{ dataIndex: 'SPEC'                 ,   width: 120},
					{ dataIndex: 'STOCK_UNIT'           ,   width: 66 , hidden: true}, 				
					{ dataIndex: 'ISSUE_REQ_QTY'	    ,   width: 100},
					{ dataIndex: 'ISSUE_QTY'		    ,   width: 100}, 				
					{ dataIndex: 'STOCK_Q'		   	    ,   width: 100},
					{ dataIndex: 'ISSUE_REQ_DATE'       ,   width: 73}, 				
					{ dataIndex: 'ISSUE_DATE'		    ,   width: 73 , hidden: true},
					{ dataIndex: 'ISSUE_DIV_CODE'       ,   width: 100}, 				
					{ dataIndex: 'WH_CODE'			    ,   width: 86 , hidden: true},
					{ dataIndex: 'WH_NAME'			    ,   width: 86}, 				
					{ dataIndex: 'WH_CELL_CODE'		    ,   width: 100 , hidden: true},
					{ dataIndex: 'WH_CELL_NAME'		    ,   width: 100}, 				
					{ dataIndex: 'LOT_NO'               ,   width: 120}
				]},
			{text:'수주정보' , 
        		columns: [	
					{ dataIndex: 'COMP_CODE'		    ,   width: 100 , hidden: true},
					{ dataIndex: 'DIV_CODE'			    ,   width: 100 , hidden: true}, 				
					{ dataIndex: 'ORDER_Q'              ,   width: 86  , hidden: true},
					{ dataIndex: 'ISSUE_REQ_Q'          ,   width: 86  , hidden: true}, 				
					{ dataIndex: 'OUTSTOCK_Q'           ,   width: 86  , hidden: true},
					{ dataIndex: 'RETURN_Q'             ,   width: 86  , hidden: true}, 				
					{ dataIndex: 'DVRY_DATE'            ,   width: 73 },
					{ dataIndex: 'ORDER_UNIT'           ,   width: 53  , hidden: true}, 				
					{ dataIndex: 'TRANS_RATE'           ,   width: 66 },
					{ dataIndex: 'BILL_TYPE'            ,   width: 80  , hidden: true}, 				
					{ dataIndex: 'ORDER_TYPE'           ,   width: 80  },
					{ dataIndex: 'INOUT_TYPE_DETAIL'    ,   width: 66  , hidden: true}, 				
					{ dataIndex: 'ORDER_PRSN'           ,   width: 80 },
					{ dataIndex: 'ORDER_NUM'            ,   width: 100 }, 				
					{ dataIndex: 'SER_NO'               ,   width: 53 },
					{ dataIndex: 'PO_NUM'               ,   width: 100 , hidden: true}, 				
					{ dataIndex: 'PO_SEQ'               ,   width: 53  , hidden: true},
					{ dataIndex: 'ISSUE_DIV_CODE'       ,   width: 80 , hidden: true}, 				
					{ dataIndex: 'SALE_CUSTOM_CODE'     ,   width: 66  , hidden: true},
					{ dataIndex: 'SALE_CUSTOM_NAME'     ,   width: 106 }, 				
					{ dataIndex: 'ACCOUNT_YNC'          ,   width: 66  , hidden: true},
					{ dataIndex: 'PROJECT_NO'           ,   width: 133 }, 				
					{ dataIndex: 'REMARK'               ,   width: 133 }
				]},
			{text:'주문정보' , 
        		columns: [	
				{ dataIndex: 'SO_TYPE'              ,   width: 80 },
				{ dataIndex: 'SO_KIND'              ,   width: 80 }, 				
				{ dataIndex: 'CUSTOMER_ID'          ,   width: 86  , hidden: true},
				{ dataIndex: 'CUSTOMER_NAME'        ,   width: 86 },
				{ dataIndex: 'RECEIVER_ID'          ,   width: 86  , hidden: true}, 				
				{ dataIndex: 'RECEIVER_NAME'        ,   width: 86 },
				{ dataIndex: 'TELEPHONE_NUM1'       ,   width: 93 }, 				
				{ dataIndex: 'TELEPHONE_NUM2'       ,   width: 93 },
				{ dataIndex: 'ADDRESS'              ,   width: 133 }, 				
				{ dataIndex: 'DVRY_CUST_CD'         ,   width: 106 , hidden: true},
				{ dataIndex: 'PICK_BOX_QTY'         ,   width: 80  , hidden: true}, 				
				{ dataIndex: 'PICK_EA_QTY'          ,   width: 80  , hidden: true},
				{ dataIndex: 'SORT_KEY'             ,   width: 80  , hidden: true} 				
			]
		}] 
    });		// End of var masterGrid = Unilite.createGrid('srq155skrvGrid1', {

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
		id : 'srq155skrvApp',
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
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
		}
	});		// End of Unilite.Main({
};
</script>
