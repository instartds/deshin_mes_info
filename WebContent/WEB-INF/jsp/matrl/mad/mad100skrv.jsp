<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mad100skrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="mad100skrv" /> 							<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> 			<!--영업담당 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>	<!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="B035" /> 			<!--수불유형 -->
	
</t:appConfig>
<style type="text/css">
</style>
<script type="text/javascript" >

function appMain() {    
	
	var inoutStore = Unilite.createStore('mad100ukrvinoutStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'입고'		, 'value':'1'},
			        {'text':'반품'		, 'value':'4'}
	    		]
	});
	
	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('Mad100skrvModel', {
	    fields: [			
			{name: 'INOUT_CODE'			,text:'<t:message code="system.label.purchase.custom" default="거래처"/>'		,type:'string'},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.purchase.customname" default="거래처명"/>'		,type:'string'},
			{name: 'ITEM_CODE'   		,text:'<t:message code="system.label.purchase.item" default="품목"/>'			,type:'string'},
			{name: 'ITEM_NAME'   		,text:'<t:message code="system.label.purchase.itemname2" default="품명"/>'			,type:'string'},
			{name: 'SPEC'	 			,text:'<t:message code="system.label.purchase.spec" default="규격"/>'			,type:'string'},
			{name: 'ORDER_UNIT'	 		,text:'<t:message code="system.label.purchase.unit" default="단위"/>'			,type:'string'},
			{name: 'SALE_BASIS_P'		,text:'판매가'		,type:'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'	 	,text:'<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'		,type:'uniUnitPrice'},
			{name: 'PURCHASE_RATE'	 	,text:'매입율'		,type:'uniPercent'},
			{name: 'INOUT_TYPE'	 		,text:'수불유형'		,type:'string', comboType:'AU', comboCode:'B035'},//,store: Ext.data.StoreManager.lookup('mad100ukrvinoutStore')},
			{name: 'INOUT_Q'	 		,text:'<t:message code="system.label.purchase.qty" default="수량"/>'			,type:'uniQty'},
			{name: 'INOUT_I'	 		,text:'<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'			,type:'uniPrice'}, /* 부가세 따라 계산됨 */
			{name: 'SUM_TAX_AMT'	 	,text:'<t:message code="system.label.purchase.vatamount" default="부가세액"/>'		,type:'uniPrice'},
			{name: 'TOTAL_SUM_I'	 	,text:'<t:message code="system.label.purchase.totalamount" default="합계"/>'			,type:'uniPrice'}

		]
	});
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mad100skrvMasterStore1', {
		model: 'Mad100skrvModel',
		uniOpt: {
           	isMaster: true,			// 상위 버튼,상태바 연결 
           	editable: false,		// 수정 모드 사용 
           	deletable:false,		// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'mad100skrvService.selectList'                	
		    }
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',		
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items: [{
		        fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120' ,
		        allowBlank:false,
		        child: 'WH_CODE',
		        value:UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
		    },
		    	Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
								panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
			    fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
			    name: 'WH_CODE', 
			    xtype: 'uniCombobox', 
			    store: Ext.data.StoreManager.lookup('whList'),
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('WH_CODE', newValue);
			     	}
			    }
		   },{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				allowBlank: false,
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INOUT_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName: 'CUSTOM_CODE_FR',
					textFieldName: 'CUSTOM_NAME_FR',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE_FR', panelSearch.getValue('CUSTOM_CODE_FR'));
								panelResult.setValue('CUSTOM_NAME_FR', panelSearch.getValue('CUSTOM_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUSTOM_CODE_FR', '');
							panelResult.setValue('CUSTOM_NAME_FR', '');
						}
					}
			}),
				Unilite.popup('CUST',{
					fieldLabel: '~',
					valueFieldName: 'CUSTOM_CODE_TO',
					textFieldName: 'CUSTOM_NAME_TO',
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE_TO', panelSearch.getValue('CUSTOM_CODE_TO'));
								panelResult.setValue('CUSTOM_NAME_TO', panelSearch.getValue('CUSTOM_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUSTOM_CODE_TO', '');
							panelResult.setValue('CUSTOM_NAME_TO', '');
						}
					}
			}), 
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			   }),{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',						            		
					//
					labelWidth:90,
					items : [{
						boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
						width: 60,
						name: 'INOUT_TYPE',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '입고',
						width: 60,
						name: 'INOUT_TYPE' ,
						inputValue: '1'
					},{
						boxLabel: '반품',
						width: 60,
						name: 'INOUT_TYPE' ,
						inputValue: '4'
					}],
					listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelResult.getField('INOUT_TYPE').setValue(newValue.INOUT_TYPE);
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,		
    	items: [{
		        fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120' ,
		        allowBlank:false,
		        child:'WH_CODE',
		        value:UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
						panelSearch.setValue('DIV_CODE', newValue);
						var field2 = panelSearch.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					}
				}
		    },
		    	Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
								panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
			    fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>',
			    name: 'WH_CODE', 
			    xtype: 'uniCombobox', 
			    store: Ext.data.StoreManager.lookup('whList'),
			    colspan : 2,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelSearch.setValue('WH_CODE', newValue);
			     	}
			    }
		   },{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				allowBlank: false,
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('INOUT_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();							
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('INOUT_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},
				Unilite.popup('CUST',{
						fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
						valueFieldName: 'CUSTOM_CODE_FR',
						textFieldName: 'CUSTOM_NAME_FR',
						extParam: {'CUSTOM_TYPE': ['1','2']},
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('CUSTOM_CODE_FR', panelResult.getValue('CUSTOM_CODE_FR'));
									panelSearch.setValue('CUSTOM_NAME_FR', panelResult.getValue('CUSTOM_NAME_FR'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('CUSTOM_CODE_FR', '');
								panelSearch.setValue('CUSTOM_NAME_FR', '');
							}
						}
				}),
					Unilite.popup('CUST',{	
						fieldLabel: '~',
						valueFieldName: 'CUSTOM_CODE_TO',
						textFieldName: 'CUSTOM_NAME_TO',
						labelWidth:10,
						colspan: 2,
						extParam: {'CUSTOM_TYPE': ['1','2']},
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('CUSTOM_CODE_TO', panelResult.getValue('CUSTOM_CODE_TO'));
									panelSearch.setValue('CUSTOM_NAME_TO', panelResult.getValue('CUSTOM_NAME_TO'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('CUSTOM_CODE_TO', '');
								panelSearch.setValue('CUSTOM_NAME_TO', '');
							}
						}
			}),
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			   }),{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',						            		
					//
					labelWidth:90,
					items : [{
						boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
						width: 60,
						name: 'INOUT_TYPE',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '입고',
						width: 60,
						name: 'INOUT_TYPE' ,
						inputValue: '1'
					},{
						boxLabel: '반품',
						width: 60,
						name: 'INOUT_TYPE' ,
						inputValue: '4'
					}],
					listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelSearch.getField('INOUT_TYPE').setValue(newValue.INOUT_TYPE);
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			}	
    });
	/**
     * Master Grid1 정의(Grid Panel),
     * @type 
     */
    var masterGrid = Unilite.createGrid('mad100skrvGrid1', {
    	layout: 'fit',
    	region:'center',
    	excelTitle: '거래처별 품목별 입고현황 조회',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useRowNumberer: false,
			useMultipleSorting: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        selType: 'cellmodel',		  
    	store: directMasterStore1,
         features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
            
        columns: [        
			{dataIndex: 'INOUT_CODE'			, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '매입처계', '<t:message code="system.label.purchase.total" default="총계"/>');
            }
            },          
			{dataIndex: 'CUSTOM_NAME'			, width: 140},
			{dataIndex: 'ITEM_CODE'  			, width: 120},
			{dataIndex: 'ITEM_NAME'  			, width: 300},
			{dataIndex: 'SPEC'	 				, width: 100},
			{dataIndex: 'ORDER_UNIT'		 	, width: 60},
			{dataIndex: 'SALE_BASIS_P'	 	, width: 100 },
			{dataIndex: 'ORDER_UNIT_P'	 	 	, width: 100 },
			{dataIndex: 'PURCHASE_RATE'	 	 	, width: 50, 
			renderer : function(val) {
                    if (val > 0) {
                        return val + '%';
                    } else if (val < 0) {
                        return val + '%';
                    }
                    return val;
                }
			},
			{dataIndex: 'INOUT_TYPE'	 	 	, width: 66  ,align:'center'},
			{dataIndex: 'INOUT_Q'	 	 		, width: 70 , summaryType: 'sum'},
			{dataIndex: 'INOUT_I'	 	 		, width: 120 , summaryType: 'sum'},
			{dataIndex: 'SUM_TAX_AMT'	 	 	, width: 120 , summaryType: 'sum'},
			{dataIndex: 'TOTAL_SUM_I'	 	 	, width: 120 , summaryType: 'sum'}	
			
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
		id: 'mad100skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			this.setDefault();
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('INOUT_DATE_FR', UniDate.get('today'));
			panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_FR', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
		/*	mad100skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE', provider['WH_CODE']);
					panelResult.setValue('WH_CODE', provider['WH_CODE']);
				}
			})*/
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
//        	panelResult.setValue('ORDER_DATE',new Date());
//			panelSearch.getForm().wasDirty = false;
//			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{	
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
   			var viewNormal = masterGrid.getView();
   			console.log("viewNormal : ",viewNormal);
      		viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
      		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		}
	});
};
</script>
