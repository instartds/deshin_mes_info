<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pos200skrv"  >
<t:ExtComboStore comboType="AU" comboCode="YP01"/>	<!-- POS명		-->
<t:ExtComboStore comboType="AU" comboCode="YP07"/>	<!-- 매장분류		-->
<t:ExtComboStore comboType="AU" comboCode="B134"/>	<!-- 매장구분		-->
<t:ExtComboStore comboType="AU" comboCode="A028"/>	<!-- 카드구분		-->
<t:ExtComboStore comboType="BOR120" pgmId="pos200skrv" /> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_POS_NO}" storeId="PosNo" /><!--POS 명-->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('pos200skrvModel', {
	    fields: [
	    	{name:'COMP_CODE' 		, text: '법인코드'			, type: 'string'},
	    	{name:'DIV_CODE' 		, text: '사업장'			, type: 'string'},
	    	{name:'SHOP_CLASS' 		, text: '매장구분' 		,type:'string'	,allowBlank:false, comboType: 'AU', comboCode:'B134' },
	    	{name:'POS_NAME' 		, text: 'POS명'			, type: 'string' },
	    	{name:'POS_NO' 			, text: 'POS번호'			, type: 'string'},
	    	{name:'CARD_CODE' 		, text: '코드'			, type: 'string' /* ,comboType:"AU", comboCode:"A028" */},
	    	{name:'CARD_NAME' 		, text: '카드사명'			, type: 'string'},
	    	{name:'SALE_ACCOUNT' 	, text: '거래건수'			, type: 'uniQty'},
	    	{name:'COLLECT_AMT' 	, text: '금액'			, type: 'uniPrice'},
	    	{name:'FEE_RATE' 		, text: '수수료율'			, type: 'float'},
	    	{name:'FEE_P' 			, text: '수수료'			, type: 'uniPrice'}
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
	var MasterStore = Unilite.createStore('pos200skrvMasterStore',{
			model: 'pos200skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'pos200skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			},
			groupField: 'POS_NO'
	});		// End of var MasterStore 
	
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
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},{
        		fieldLabel: '매장구분',
        		name: 'SHOP_CLASS',
        		xtype: 'uniCombobox',
        		comboType: 'AU',
        		comboCode: 'B134',
        		value : 1,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SHOP_CLASS', newValue);
					}
				}
        	},{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'COLLECT_DATE_FR',
				endFieldName: 'COLLECT_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('COLLECT_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('COLLECT_DATE_TO',newValue);			    		
			    	}
			    }
			},{
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('PosNo'),
		        multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('POS_CODE', newValue);
					},
					beforequery: function(queryPlan, eOpts ) {
				        var pValue = panelSearch.getValue('DIV_CODE');
				        var store = queryPlan.combo.getStore();
				        if(!Ext.isEmpty(pValue)) {
				        	store.clearFilter(true);
				        	queryPlan.combo.queryFilter = null;    
				         	store.filter('option', pValue);
				        }else {
					         store.clearFilter(true);
					         queryPlan.combo.queryFilter = null; 
					         store.loadRawData(store.proxy.data);
				        }
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
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		colspan: 3,
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},{
        		fieldLabel: '매장구분',
        		name: 'SHOP_CLASS',
        		colspan: 3,
        		xtype: 'uniCombobox',
        		comboType: 'AU',
        		comboCode: 'B134',
        		value : 1,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SHOP_CLASS', newValue);
					}
				}
        	},{
				fieldLabel: '매출일',
				colspan: 3,
				xtype: 'uniDateRangefield',
				startFieldName: 'COLLECT_DATE_FR',
				endFieldName: 'COLLECT_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('COLLECT_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('COLLECT_DATE_TO',newValue);			    		
			    	}
			    }
			},{
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('PosNo'),
		        multiSelect: true, 
		        typeAhead: false,
				width: 400,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('POS_CODE', newValue);
						},
						beforequery: function(queryPlan, eOpts ) {
					        var pValue = panelSearch.getValue('DIV_CODE');
					        var store = queryPlan.combo.getStore();
					        if(!Ext.isEmpty(pValue)) {
					        	store.clearFilter(true);
					        	queryPlan.combo.queryFilter = null;    
					         	store.filter('option', pValue);
					        }else {
						         store.clearFilter(true);
						         queryPlan.combo.queryFilter = null; 
						         store.loadRawData(store.proxy.data);
					        }
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
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('pos200skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
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
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
			{dataIndex:'POS_NO' 	 	 	, width: 80
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			{dataIndex:'POS_NAME' 		 		, width: 140},                                      
			{dataIndex:'CARD_CODE' 				, width: 88},
			{dataIndex:'CARD_NAME' 				, width: 150},                                  	
			{dataIndex:'SALE_ACCOUNT' 			, width: 80 , summaryType: 'sum'},                                       	
			{dataIndex:'COLLECT_AMT' 			, width: 150 , summaryType: 'sum'},                                       	
 			{dataIndex:'FEE_RATE' 				, width: 120,
 			renderer : function(val) {
                    if (val > 0) {
                        return val + '%';
                    } else if (val < 0) {
                        return val + '%';
                    }
                    return val;
                }},
			{dataIndex:'FEE_P' 					, width: 170 , summaryType: 'sum'}        
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
		id: 'pos200skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('save',false);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			panelResult.setValue('SHOP_CLASS',1);
			panelSearch.setValue('SHOP_CLASS',1);
			
			panelSearch.setValue('COLLECT_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('COLLECT_DATE_TO',UniDate.get('today'));
			panelResult.setValue('COLLECT_DATE_FR',UniDate.get('today'));
			panelResult.setValue('COLLECT_DATE_TO',UniDate.get('today'));
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
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
		}
	});
};
</script>
