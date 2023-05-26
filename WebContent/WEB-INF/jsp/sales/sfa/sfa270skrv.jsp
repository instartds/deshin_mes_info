<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sfa270skrv"  >
<t:ExtComboStore comboType="BOR120"  pgmId="sfa270skrv"/> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B055" /> 				<!-- 고객분류 -->

</t:appConfig>
<script type="text/javascript" >


function appMain() {	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('sfa270skrvModel', {
	    fields: [
	    	{name:'CUSTOM_CODE' 				, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'		, type: 'string'}, 	
	    	{name:'CUSTOM_NAME' 				, text: '<t:message code="system.label.sales.salesplacename" default="매출처명"/>'			, type: 'string'},  
	    	{name:'ITEM_CODE' 					, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'}, 	
	    	{name:'ITEM_NAME' 					, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},	
	    	{name:'PUBLISHER' 					, text: '출판사'			, type: 'string'},
	    	{name:'AUTHOR' 						, text: '저자'			, type: 'string'},
	    	{name:'PURCHASE_P' 					, text: '원가'			, type: 'uniPrice'},
	    	{name:'SALE_P' 						, text: '정가'			, type: 'uniPrice'},
	    	{name:'SALE_Q' 						, text: '<t:message code="system.label.sales.qty" default="수량"/>'			, type: 'uniQty'},
	    	{name:'SALE_AMT_TOT' 				, text: '판매합계'			, type: 'uniPrice'},
	    	{name:'DISCOUNT_AMT' 				, text: '<t:message code="system.label.sales.discountamount" default="할인금액"/>'			, type: 'uniPrice'},
	    	{name:'DELIVERY_AMT' 				, text: '납품가'			, type: 'uniPrice'},
	    	{name:'PROFIT_AMT' 					, text: '<t:message code="system.label.sales.salesprofit" default="매출이익"/>'			, type: 'uniPrice'}
	    ]	    
	});		//End of Unilite.defineModel
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('sfa270skrvMasterStore',{
			model: 'sfa270skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'sfa270skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
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
			},
			groupField: 'CUSTOM_CODE'
	});		// End of var MasterStore 
	
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
		    items: [{fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
       			endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelResult.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},
				Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					}
			}),
				Unilite.popup('DEPT',{ 
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
				name: 'AGENT_TYPE',	
				xtype:'uniCombobox',
				comboType:'AU', 
				comboCode:'B055', 
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {					
						panelResult.setValue('AGENT_TYPE', newValue);
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
	});
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
			hidden: !UserInfo.appOption.collapseLeftSearch,
			region: 'north',
			layout : {type : 'uniTable', columns : 2},
			padding:'1 1 1 1',
			border:true,
			items: [{fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
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
			},
				Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					}
			}),
				Unilite.popup('DEPT',{ 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
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
				fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
				name: 'AGENT_TYPE',	
				xtype:'uniCombobox',
				comboType:'AU', 
				comboCode:'B055', 
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {					
						panelSearch.setValue('AGENT_TYPE', newValue);
					}
				}
			}]
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('sfa270skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
        	{dataIndex:'CUSTOM_CODE' 					, width: 100 },
        	{dataIndex:'CUSTOM_NAME' 					, width: 130,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	return Unilite.renderSummaryRow(summaryData, metaData, '거래처계', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{dataIndex:'ITEM_CODE' 						, width: 105 },
        	{dataIndex:'ITEM_NAME' 						, width: 200 },
        	{dataIndex:'PUBLISHER' 						, width: 150 },
        	{dataIndex:'AUTHOR' 						, width: 100 },
        	{dataIndex:'PURCHASE_P' 					, width: 100, summaryType: 'sum' },
        	{dataIndex:'SALE_P' 					, width: 100, summaryType: 'sum' },
        	{dataIndex:'SALE_Q' 						, width: 80, summaryType: 'sum' },
        	{dataIndex:'SALE_AMT_TOT' 					, width: 100, summaryType: 'sum' },
        	{dataIndex:'DISCOUNT_AMT' 				, width: 100, summaryType: 'sum' },
        	{dataIndex:'DELIVERY_AMT' 				, width: 100, summaryType: 'sum' },
        	{dataIndex:'PROFIT_AMT' 					, width: 100, summaryType: 'sum' }
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
        	
//			{dataIndex:'COMP_CODE' 	  							, width: 100, hidden:true},
//			{dataIndex:'CUSTOM_CODE' 		  					, width: 100
//			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
//            }},
//			{dataIndex:'CUSTOM_NAME' 	  						, width: 300},
//			{dataIndex:'ITEM_CODE' 		  						, width: 100
//			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
//            }},
//			{dataIndex:'ITEM_NAME' 	  							, width: 300},
//			{dataIndex:'SALE_Q' 	  							, width: 100 , summaryType: 'sum'},
//			{dataIndex:'PURCHASE_P' 	  						, width: 100 , summaryType: 'sum'},
//			{dataIndex:'DISCCOUNT_P' 	  						, width: 100 , summaryType: 'sum'},
//			{dataIndex:'TAX_AMT_O' 				  				, width: 100 , summaryType: 'sum'},
//			{dataIndex:'SALE_AMT_O' 	  						, width: 100 , summaryType: 'sum'},
//			{dataIndex:'TOTAL_AMT_O' 			  				, width: 120 , summaryType: 'sum'},
//			{dataIndex:'SALES_PROFIT' 		  					, width: 100 , summaryType: 'sum'}


		]
    });		//End of var masterGrid 
    
    /**
	 * Main 정의(Main 정의)
	 * @type 
	 */
    Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id: 'sfa270skrvApp',
		fnInitBinding: function() {
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
			
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});
};
</script>
