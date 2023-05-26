<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssd110skrv" >
<t:ExtComboStore comboType="BOR120" pgmId="ssd110skrv"/> 				<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="ssd110skrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="ssd110skrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="ssd110skrvLevel3Store" />
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

	
	Unilite.defineModel('Ssd110skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'		, type: 'string'},
	    
	    	{name: 'DEPT_CODE'			, text: '<t:message code="system.label.sales.department" default="부서"/>'		, type: 'string'},
	    	{name: 'DEPT_NAME'			, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'		, type: 'string'},
	    	{name: 'ITEM_LEVEL1'		, text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'		, type: 'string',store: Ext.data.StoreManager.lookup('ssd110skrvLevel1Store')},
	    	{name: 'ITEM_LEVEL2'		, text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'		, type: 'string',store: Ext.data.StoreManager.lookup('ssd110skrvLevel2Store')},
	    	{name: 'ITEM_LEVEL3'		, text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'		, type: 'string',store: Ext.data.StoreManager.lookup('ssd110skrvLevel3Store')},
	    	
	    	{name: 'SALE_Q1'			, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'DISCOUNT_AMT1'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_AMT_O1'		, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'TAX_AMT_O1'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_TAX_AMT1'		, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'},
	    	
	    	{name: 'SALE_Q2'			, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'DISCOUNT_AMT2'		, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_AMT_O2'		, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'TAX_AMT_O2'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_TAX_AMT2'		, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'},
	    	
	    	
	    	{name: 'SUM_SALE_Q'			, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		, type: 'uniQty'},
	    	{name: 'SUM_DISCOUNT_AMT'	, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_SALE_AMT_O'		, text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_TAX_AMT_O'		, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		, type: 'uniPrice'},
	    	{name: 'SUM_SALE_TAX_AMT'	, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'		, type: 'uniPrice'}
	    ]
	});//End of Unilite.defineModel('Ssd110skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssd110skrvMasterStore1', {
		model: 'Ssd110skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ssd110skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();	
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
				
		}, groupField: 'DEPT_CODE'
			
	});//End of var directMasterStore1 = Unilite.createStore('ssd110skrvMasterStore1', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('DIV_CODE', newValue);
				}
			}
		},
        	Unilite.popup('DEPT', { 
			   		fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
			   		valueFieldName: 'DEPT_CODE',
			        textFieldName: 'DEPT_NAME',
			    	
			    	listeners: {
			     		onSelected: {
			      			fn: function(records, type) {
			       				panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
			       				panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
			                },
			      			scope: this
			     		},
			     		onClear: function(type) {
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
			    	}
		   }),{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SALE_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);
			    	}
			    }
			},{ 
				name: 'ITEM_LEVEL1',  			
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('ssd110skrvLevel1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL2',  			
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('ssd110skrvLevel2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL3',  			
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('ssd110skrvLevel3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('DEPT', { 
	   		fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
	   		valueFieldName: 'DEPT_CODE',
	        textFieldName: 'DEPT_NAME',
	    	
	    	colspan:3,
	    	listeners: {
	     		onSelected: {
	      			fn: function(records, type) {
	       				panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
	       				panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
	                },
	      			scope: this
	     		},
	     		onClear: function(type) {
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
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
	    	}
		}),{
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'SALE_DATE_FR',
			endFieldName: 'SALE_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('SALE_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('SALE_DATE_TO',newValue);
		    	}
		    }
		},{ 
				name: 'ITEM_LEVEL1',  			
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('ssd110skrvLevel1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL2',  			
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('ssd110skrvLevel2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL3',  			
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('ssd110skrvLevel3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
					   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ssd110skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		
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
        },/*
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],*/
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id: 'masterGridTotal',    ftype: 'uniSummary',  showSummaryRow: true} ],		
    	store: directMasterStore1,
    
        columns: [
        	{dataIndex: 'COMP_CODE'			, width: 80,hidden:true},
        	{dataIndex: 'DIV_CODE'			, width: 80,hidden:true},
        
        	{dataIndex: 'DEPT_CODE'			, width: 80,
   							summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	       					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            				}
            											},
        	{dataIndex: 'DEPT_NAME'			, width: 100},
        	{dataIndex: 'ITEM_LEVEL1'		, width: 150},
        	{dataIndex: 'ITEM_LEVEL2'		, width: 130},
        	{dataIndex: 'ITEM_LEVEL3'		, width: 110},
			{ 
         	text:'위탁',
         		columns: [
		         	{dataIndex: 'SALE_Q1'			, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'DISCOUNT_AMT1'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SALE_AMT_O1'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'TAX_AMT_O1'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SALE_TAX_AMT1'		, width: 100,summaryType: 'sum'}
	         	]
			},{ 
	      	text:'현매',
     			columns: [
		        	{dataIndex: 'SALE_Q2'			, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'DISCOUNT_AMT2'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SALE_AMT_O2'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'TAX_AMT_O2'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SALE_TAX_AMT2'		, width: 100,summaryType: 'sum'}
	        	]
			},{ 
    	 	text:'<t:message code="system.label.sales.totalamount" default="합계"/>',
	     		columns: [
		        	{dataIndex: 'SUM_SALE_Q'			, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SUM_DISCOUNT_AMT'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SUM_SALE_AMT_O'		, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SUM_TAX_AMT_O'			, width: 80,summaryType: 'sum'},
		        	{dataIndex: 'SUM_SALE_TAX_AMT'		, width: 100,summaryType: 'sum'}
	        	]
    	 }] 
    });//End of var masterGrid = Unilite.createGrid('ssd110skrvGrid1', {  
	
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
		id: 'ssd110skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',true);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelSearch.setValue('SALE_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('SALE_DATE_TO',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('SALE_DATE_TO',UniDate.get('today'));
		},
		onQueryButtonDown: function() {
			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			}
			
		},
		
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});

};


</script>
