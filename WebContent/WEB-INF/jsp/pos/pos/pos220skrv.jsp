<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pos220skrv"  >
<t:ExtComboStore comboType="AU" comboCode="YP01"/>	<!-- POS명		-->
<t:ExtComboStore comboType="AU" comboCode="YP07"/>	<!-- 매장분류		-->
<t:ExtComboStore comboType="AU" comboCode="A028"/>	<!-- 카드분류		-->
<t:ExtComboStore comboType="BOR120" pgmId="pos220skrv" /> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_POS_NO}" storeId="PosNo" /><!--POS 명-->
</t:appConfig>


<style type="text/css">
.x-change-cell2 {
background-color: #fed9fe;
}
</style>


<script type="text/javascript" >


function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('pos220skrvModel', {
	    fields: [
	    	{name:'FRANCHISE_NUM' 		, text: '가맹점번호'		, type: 'string'},
	    	{name:'CARD_ACC_NUM' 		, text: '카드승인번호'		, type: 'string'},
	    	{name:'CARD_NO' 			, text: '카드번호'			, type: 'string'},
	    	{name:'APPVAL_DATE' 		, text: '승인일자'			, type: 'uniDate'},
	    	{name:'APPVAL_TIME' 		, text: '승인시간'			, type: 'string'},
	    	{name:'COLLECT_AMT' 		, text: '거래금액'			, type: 'uniPrice'},
	    	{name:'CARD_CUST_CODE' 		, text: '매입사'			, type: 'string'},
	    	{name:'CARD_ACC_NUM2' 		, text: '카드승인번호'		, type: 'string'},
	    	{name:'CARD_NO2' 			, text: '카드번호'			, type: 'string'},
	    	{name:'APPVAL_DATE2' 		, text: '승인일자'			, type: 'uniDate'},
	    	{name:'APPVAL_TIME2' 		, text: '승인시간'			, type: 'string'},
	    	{name:'COLLECT_AMT2' 		, text: '거래금액'			, type: 'uniPrice'},
	    	{name:'CARD_CUST_CODE2' 	, text: '매입사'			, type: 'string'},
	    	{name:'BILL_NUM' 			, text: '전표번호'			, type: 'string'},
	    	
	    	{name:'DEPT_CODE' 			, text: '부서코드'			, type: 'string'},
	    	{name:'DEPT_NAME' 			, text: '부서명'			, type: 'string'},
	    	{name:'POS_NO' 				, text: 'POS번호'			, type: 'string'},
	    	{name:'POS_NAME' 			, text: 'POS명'			, type: 'string'},
	    	{name:'CARD_CUST_CODE2' 	, text: '매입사코드'		, type: 'string'},
	    	{name:'CODE_NAME' 			, text: '매입사명'			, type: 'string'},
	    	{name:'RECEIPT_NO' 			, text: '영수증번호'		, type: 'string'}

	    	
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
	var MasterStore = Unilite.createStore('pos220skrvMasterStore',{
			model: 'pos220skrvModel',
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
               		read: 'pos220skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
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
			},{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
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
			}]
		},{
				name: 'CARD_CUST_CODE',
				fieldLabel: '매입사코드', 
				xtype:'uniCombobox',
				comboType: 'AU',
				comboCode: 'A028',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelResult.setValue('CARD_CUST_CODE', newValue);
					}
				}
			},{
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '매장구분',
	    		items: [{
	    			boxLabel: '직영',
	    			width: 60,
	    			name: 'SHOP_CLASS',
	    			inputValue: '1',
	    			checked: true
	    		}, {
	    			boxLabel: '위탁',
	    			width: 70,
	    			name: 'SHOP_CLASS',
	    			inputValue: '2'
	    		}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('SHOP_CLASS').setValue(newValue.SHOP_CLASS);	
					}
				}	
			}/*,{
		    	xtype: 'container',
		    	padding: '10 0 0 0',
		    	layout: {
		    		type: 'hbox',
					pack:'center'
		    	},
		    	items:[{
		    		xtype: 'button',
		    		text: '카드대사실행',
		    		handler: function() {
		    			if(confirm("카드대사 작업을 실행 하시겠습니까?")){
						panelSearch.getEl().mask();
						panelResult.getEl().mask();
						masterGrid.getEl().mask();	
						var param = {DIV_CODE: panelSearch.getValue('DIV_CODE'), APPVAL_DATE2_FR: UniDate.getDbDateStr(panelSearch.getValue('APPVAL_DATE2'))
									 ,APPVAL_DATE2_TO: UniDate.getDbDateStr(panelSearch.getValue('APPVAL_DATE2'))}   
									 				
							pos220skrvService.CardImportStart(param, function(provider, response)	{
							if(provider){
								UniAppManager.updateStatus(Msg.sMB011);
								alert("카드대사 작업이 완료 되었습니다.");							
							}
							panelSearch.getEl().unmask();
							panelResult.getEl().unmask();
							masterGrid.getEl().unmask();
						});
					}
					else{
						
						}
					}
		    	}]
			}*/],
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
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('PosNo'),
		        multiSelect: true, 
		        typeAhead: false,
		        colspan:2,
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
			},{
				fieldLabel: '매출일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('SALE_DATE_FR',newValue);
                	}

			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);
			    	}
			    	
			    }
			},{
				name: 'CARD_CUST_CODE',
				fieldLabel: '매입사코드', 
				xtype:'uniCombobox',
				comboType: 'AU',
				comboCode: 'A028',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CARD_CUST_CODE', newValue);
					}
				}
			},{
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '매장구분',
	    	//	id : 'A',
	    		items: [{
	    			boxLabel: '직영',
	    			width: 60,
	    			name: 'SHOP_CLASS',
	    			inputValue: '1',
	    			checked: true
	    		}, {
	    			boxLabel: '위탁',
	    			width: 70,
	    			name: 'SHOP_CLASS',
	    			inputValue: '2'
	    		}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('SHOP_CLASS').setValue(newValue.SHOP_CLASS);
					}
				}
			}/*,{
	        	margin: '0 0 0 95',
				xtype: 'button',
				text: '카드대사실행',	
	        	width: 150,
//	        	tdAttrs:{'align':'center'},
				handler : function() {
					var me = this;
					if(confirm("카드대사 작업을 실행 하시겠습니까?")){
						panelSearch.getEl().mask();
						panelResult.getEl().mask();
						masterGrid.getEl().mask();
						var param = {DIV_CODE: panelSearch.getValue('DIV_CODE'), APPVAL_DATE2_FR: UniDate.getDbDateStr(panelSearch.getValue('APPVAL_DATE2'))
									 ,APPVAL_DATE2_TO: UniDate.getDbDateStr(panelSearch.getValue('APPVAL_DATE2'))}   
								 
						pos220skrvService.CardImportStart(param, function(provider, response)	{
							if(provider){
								UniAppManager.updateStatus(Msg.sMB011);
								alert("카드대사 작업이 완료 되었습니다.");							
							}
							panelSearch.getEl().unmask();
							panelResult.getEl().unmask();
							masterGrid.getEl().unmask();
						});
					}
					else{
					
					}
   				}
			}*/],
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
    var masterGrid = Unilite.createGrid('pos220skrvGrid', {
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
			   { 
				text: 'VAN사 매출자료',
				columns: [
					{dataIndex:'FRANCHISE_NUM'  				, width: 120  ,hidden:true,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
		            }},
					{dataIndex:'CARD_ACC_NUM'  				, width: 100},
					{dataIndex:'CARD_NO'  					, width: 180},
					{dataIndex:'APPVAL_DATE'  				, width: 100},
					{dataIndex:'APPVAL_TIME'  				, width: 150},
					{dataIndex:'COLLECT_AMT'  				, width: 100, summaryType: 'sum'},
					{dataIndex:'CARD_CUST_CODE'  			, width: 100}
			]},{ 
				text: '자사 매출자료',
				columns: [
					{dataIndex:'CARD_ACC_NUM2'  			, width: 100  },
					{dataIndex:'CARD_NO2'  					, width: 180  },
					{dataIndex:'APPVAL_DATE2'  				, width: 100  },
					{dataIndex:'APPVAL_TIME2'  				, width: 150  },
					{dataIndex:'COLLECT_AMT2'  				, width: 100  , summaryType: 'sum'},
					{dataIndex:'CARD_CUST_CODE2'  			, width: 70  },
					{dataIndex:'BILL_NUM'  					, width: 170  }
				]},
			{dataIndex:'DEPT_CODE'  					, width: 88  },
			{dataIndex:'DEPT_NAME'  					, width: 130 },
			{dataIndex:'POS_NO'  						, width: 66  },
			{dataIndex:'POS_NAME'  						, width: 150 },
			{dataIndex:'CARD_CUST_CODE2'  				, width: 70  },
			{dataIndex:'CODE_NAME'  					, width: 120 },
			{dataIndex:'RECEIPT_NO'  					, width: 88  }
		] /**,
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('COLLECT_AMT') != record.get('COLLECT_AMT2')){
					cls = 'x-change-cell2';	
				}
				return cls;
	        }
	    }	**/	
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
		id: 'pos220skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('save',false);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('SALE_DATE_FR',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR',UniDate.get('today'));
			
			panelSearch.setValue('SALE_DATE_TO',UniDate.get('today'));
			panelResult.setValue('SALE_DATE_TO',UniDate.get('today'));
			
			panelSearch.setValue('SHOP_CLASS','1');
			panelResult.setValue('SHOP_CLASS','1');
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
