<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sfa260skrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="sfa260skrv"  /> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->

</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('sfa260skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'		, text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'		, type: 'string'},
			{name: 'ITEM_LEVEL1'	, text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store'), child:'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL2'	, text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store'), child:'ITEM_LEVEL3'},
			{name: 'ITEM_LEVEL3'	, text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_CODE'	    , text: '<t:message code="system.label.sales.item" default="품목"/>'    	, type: 'string'},
			{name: 'ITEM_NAME'	    , text: '<t:message code="system.label.sales.itemname" default="품목명"/>'    	, type: 'string'},
			{name: 'AUTHOR1'	    , text: '저자'    	, type: 'string'},
			{name: 'PUBLISHER'		, text: '출판사'    	, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="system.label.sales.purchaseplace" default="매입처"/>'    	, type: 'string'},
			{name: 'PUB_DATE'		, text: '초판발행일'   , type: 'string'},
			{name: 'SALE_COMMON_P'	, text: '시중가'    	, type: 'uniPrice'},
			{name: 'SALE_P'	    	, text: '<t:message code="system.label.sales.sellingprice2" default="판매가"/>'    	, type: 'uniPrice'},
			{name: 'SALE_Q'	    	, text: '판매수량'    	, type: 'uniQty'},
			{name: 'SALE_AMT_O'	    , text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'    	, type: 'uniPrice'},
			{name: 'WH_CODE'		, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'    	, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
			{name: 'STOCK_Q'	    , text: '<t:message code="system.label.sales.onhandqty" default="현재고량"/>'    	, type: 'uniQty'}
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
	var MasterStore = Unilite.createStore('sfa260skrvMasterStore',{
			model: 'sfa260skrvModel',
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
               		read: 'sfa260skrvService.selectList'
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
			},listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
			}
		}
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
		    items: [{
        		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		holdable: 'hold',
        		allowBlank: false,
        		child:'WH_CODE',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},
		    
			    Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
								panelSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
								panelResult.getField('WH_CODE').setValue(records[0]['WH_CODE']);
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
				fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALES_DATE_FR',
				endFieldName: 'SALES_DATE_TO',
				colspan:2,
				startDate: UniDate.get('yesterday'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALES_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('SALES_DATE_TO',newValue);			    		
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
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
	});
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		holdable: 'hold',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		child:'WH_CODE',
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},
				Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
								panelSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
								panelResult.getField('WH_CODE').setValue(records[0]['WH_CODE']);
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),
		    	{
				fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
		},{
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM', 
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
		},{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALES_DATE_FR',
				endFieldName: 'SALES_DATE_TO',
				startDate: UniDate.get('yesterday'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALES_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('SALES_DATE_TO',newValue);			    		
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
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('sfa260skrvGrid', {
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
			{dataIndex:'COMP_CODE'			, width: 88,hidden:true},
        	{dataIndex:'ITEM_LEVEL1'		, width: 120,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{dataIndex:'ITEM_LEVEL2'		, width: 120},
        	{dataIndex:'ITEM_CODE'			, width: 120},
        	{dataIndex:'ITEM_NAME'			, width: 300},
        	{dataIndex:'AUTHOR1'			, width: 250},
        	{dataIndex:'PUBLISHER'	 		, width: 120},
        	{dataIndex:'CUSTOM_NAME'		, width: 130},
        	{dataIndex:'PUB_DATE'			, width: 130},
        	{dataIndex:'SALE_COMMON_P'	 	, width: 88  , summaryType: 'sum', hidden:true},
        	{dataIndex:'SALE_P'				, width: 88 },
        	{dataIndex:'SALE_Q'				, width: 88  , summaryType: 'sum'},
        	{dataIndex:'SALE_AMT_O'			, width: 88  , summaryType: 'sum'},
        	{dataIndex:'WH_CODE'	 		, width: 88},
        	{dataIndex:'STOCK_Q'	 		, width: 88  , summaryType: 'sum'}
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
		id: 'sfa260skrvApp',
		fnInitBinding: function() {
			//panelResult.setValue('DIV_CODE',UserInfo.divCode);
			//UniAppManager.setToolbarButtons('reset',false);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('SALES_DATE_FR', UniDate.get('yesterday'));
			panelSearch.setValue('SALES_DATE_TO', UniDate.get('today'));
			panelResult.setValue('SALES_DATE_FR', UniDate.get('yesterday'));
			panelResult.setValue('SALES_DATE_TO', UniDate.get('today'));
			
			sfa260skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/sfa/sfa260rkrPrint.do',
	            prgID: 'sfa260rkr',
	               extParam: {
	                  DIV_CODE  		: param.DIV_CODE,
	                  DEPT_CODE 		: param.DEPT_CODE,
	                  DEPT_NAME			: param.DEPT_NAME,
	                  WH_CODE  			: param.WH_CODE,
	                  SALES_DATE_FR  	: param.SALES_DATE_FR,
	                  SALES_DATE_TO		: param.SALES_DATE_TO,
	                  ITEM_LEVEL1  		: param.ITEM_LEVEL1,
	                  ITEM_LEVEL2  		: param.ITEM_LEVEL2,
	                  ITEM_LEVEL3  		: param.ITEM_LEVEL3                  
	               }
	            });
	            win.center();
	            win.show();
	               
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
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();
		}
	});
};
</script>
