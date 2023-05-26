<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pos300skrv"  >
<t:ExtComboStore comboType="AU" comboCode="YP01"/>	<!-- POS명		-->
<t:ExtComboStore comboType="AU" comboCode="YP07"/>	<!-- 매장분류		-->
<t:ExtComboStore comboType="BOR120" pgmId="pos300skrv" /> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_POS_NO}" storeId="PosNo" /><!--POS 명-->
<t:ExtComboStore comboType="AU" comboCode="B010"/>	<!-- 마감여부		-->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('pos300skrvModel', {
	    fields: [
	    	{name:'COMP_CODE' 			, text: '법인코드' , type: 'string'},
	    	{name:'DIV_CODE' 			, text: '사업장' 	, type: 'string'},
	    	{name:'TREE_CODE'			, text: '부서코드'	, type: 'string'}, 
	    	{name:'TREE_NAME'			, text: '부서명'	, type: 'string'}, 
	    	{name:'SALE_DATE' 			, text: '매출일' 	, type: 'uniDate'},
	    	{name:'POS_NO'        		, text: 'POS'   , type: 'string'  },
	    	{name:'POS_NAME'        	, text: 'POS명'   , type: 'string'  },
	    	{name:'SALE_AMT_O' 			, text: '총매출' 	, type: 'uniPrice'},
	    	{name:'DISCOUNT_O' 			, text: '할인액' 	, type: 'uniPrice'},
	    	{name:'NETSALES' 			, text: '순매출' 	, type: 'uniPrice'},
	    	{name:'SALE_CNT' 			, text: '객수' 	, type: 'uniQty'},
	    	{name:'CASH_O' 				, text: '현금' 	, type: 'uniPrice'},
	    	{name:'CASH_RTN_O' 			, text: '현금반품금액' , type: 'uniPrice'},
	    	{name:'CARD_O' 				, text: '카드' 	, type: 'uniPrice'},
	    	{name:'TICKECT_O' 			, text: '상품권' 	, type: 'uniPrice'},
	    	{name:'CREDIT_O' 			, text: '외상' 	, type: 'uniPrice'},
	    	{name:'RETURN_O' 			, text: '반품' 	, type: 'uniPrice'},
	    	{name:'ETC' 				, text: '기타' 	, type: 'uniPrice'},
	    	{name:'BALANCE_OS' 			, text: '과부족' 	, type: 'uniPrice'},
	    	/*2015.08.10 추가 */
	    	{name:'GIFT_RETURN_CASH_O' 	, text: '상품권 회수금액' , type: 'uniPrice'},
	    	{name:'BANK_SALE_O' 		, text: '통장입금금액' 	, type: 'uniPrice'},
	    	{name:'ONLINE_CARD_SALE_O' 	, text: '온라인카드금액' , type: 'uniPrice'},
	    	{name:'ONLINE_CASH_SALE_O' 	, text: '온라인현금금액' , type: 'uniPrice'},
	    	{name:'CLOSE_YN' 			, text: '마감여부' , type: 'string', comboType: 'AU', comboCode:'B010'}
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
	var MasterStore = Unilite.createStore('pos300skrvMasterStore',{
			model: 'pos300skrvModel',
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
               		read: 'pos300skrvService.selectList'
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
        	},
        		Unilite.popup('DEPT',{
					fieldLabel: '부서',
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
		 		fieldLabel: '매출일',
		 		xtype: 'uniDatefield',
		 		name: 'SALE_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALE_DATE', newValue);
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
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},
        		Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
		 		fieldLabel: '매출일',
		 		xtype: 'uniDatefield',
		 		name: 'SALE_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SALE_DATE', newValue);
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
    var masterGrid = Unilite.createGrid('pos300skrvGrid', {
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
        	{dataIndex:'TREE_CODE' 		 		 	, width: 66
        	,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			{dataIndex:'TREE_NAME'  		 		, width: 120},
            {dataIndex:'POS_NO' 		 		 	, width: 66},
			{dataIndex:'POS_NAME' 		 		 	, width: 140},
			{dataIndex:'SALE_AMT_O'  		 		, width: 120 , summaryType: 'sum'},
			{dataIndex:'DISCOUNT_O'  		 		, width: 120 , summaryType: 'sum'},
			{dataIndex:'NETSALES' 	 		 		, width: 120 , summaryType: 'sum'},
			{dataIndex:'SALE_CNT' 	 		 		, width: 120 , summaryType: 'sum'},
			{dataIndex:'CASH_O' 		 		 	, width: 120 , summaryType: 'sum'},
			{dataIndex:'CASH_RTN_O' 		 		 , width: 120 , summaryType: 'sum'},
			{dataIndex:'CARD_O' 		 		 	, width: 120 , summaryType: 'sum'},
			{dataIndex:'TICKECT_O' 	 		 		, width: 120 , summaryType: 'sum'},
			{dataIndex:'CREDIT_O' 	 		 		, width: 120 , summaryType: 'sum'},
			{dataIndex:'RETURN_O' 	 		 		, width: 120 , summaryType: 'sum'},
			{dataIndex:'ETC' 		 		 		, width: 120 , summaryType: 'sum'},
			{dataIndex:'BALANCE_OS'  		 		, width: 120 , summaryType: 'sum'},
			/*2015.08.10 추가 */
			{dataIndex:'GIFT_RETURN_CASH_O' 	 	, width: 120 , summaryType: 'sum' , hidden:true},
			{dataIndex:'BANK_SALE_O' 	 		 	, width: 120 , summaryType: 'sum' , hidden:true},
			{dataIndex:'ONLINE_CARD_SALE_O' 	 	, width: 120 , summaryType: 'sum' , hidden:true},
			{dataIndex:'ONLINE_CASH_SALE_O' 		, width: 120 , summaryType: 'sum' , hidden:true},
			{dataIndex:'CLOSE_YN' 					, width: 120}
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
		id: 'pos300skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('save',false);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			/*panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);*/
			
			panelSearch.setValue('SALE_DATE',UniDate.get('today'));
			panelResult.setValue('SALE_DATE',UniDate.get('today'));

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
