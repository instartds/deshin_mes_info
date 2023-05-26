<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map201skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map201skrv" /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B035" /> <!--수불구분-->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>  <!-- 세구분 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
</t:appConfig>
<style type="text/css">
.x-change-cell {
background-color: #fed9fe;
}
</style>

<script type="text/javascript" >
var PGM_TITLE = "매출조회(map201skrv)";

function appMain() {   
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map201skrvService.selectGrid'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Map201skrvModel', {
	    fields: [  	 	
				 {name: 'COMP_CODE' 			,text:'COMP_CODE',type:'string'},
				 {name: 'DIV_CODE' 				,text:'<t:message code="system.label.purchase.division" default="사업장"/>' 	,type:'string'},
				 {name: 'INOUT_TYPE' 			,text:'수불구분' 	,type:'string', comboType:'AU', comboCode:'B035'},
				 {name: 'INOUT_DATE' 			,text:'매출일' 	,type:'uniDate', convert:dateToString},
				 {name: 'WH_CODE' 				,text:'<t:message code="system.label.purchase.warehouse" default="창고"/>' 		,type:'string', store: Ext.data.StoreManager.lookup('whList')},
				 {name: 'ITEM_CODE' 			,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 	,type:'string'},
				 {name: 'ITEM_NAME' 			,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>' 	,type:'string'},
				 {name: 'TAX_TYPE' 				,text:'과세구분' 	,type:'string', comboType:'AU', comboCode:'B059'},
				 {name: 'INOUT_Q' 				,text:'<t:message code="system.label.purchase.issueqty" default="출고량"/>' 	,type:'uniQty'},
				 {name: 'INOUT_I' 				,text:'<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'	,type:'uniPrice'},
				 {name: 'INOUT_TAX_AMT' 		,text:'<t:message code="system.label.purchase.vatamount" default="부가세액"/>' 	,type:'uniPrice'},
				 {name: 'TOTAL_INOUT_I' 		,text:'<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'	,type:'uniPrice'}
		]  
	});		//End of Unilite.defineModel('Map201skrvModel', {
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('map201skrvMasterStore1',{
		model: 'Map201skrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();	
			console.log(param);
			this.load({
				params : param
			});
		},
		groupField: 'INOUT_DATE'
	});		// End of var directMasterStore1 = Unilite.createStore('map201skrvMasterStore1',{
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
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
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue, false);
					}
				}
			}, 
			Unilite.popup('CUST', {
				allowBlank: false ,
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				id:'CUSTOM1',
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']}
			}),{
				fieldLabel: '매출기간',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				xtype: 'uniDateRangefield',
				allowBlank: false ,
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
    });		// End of var masterForm = Unilite.createSearchForm('searchForm',{    
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
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			allowBlank: false ,
			id:'CUSTOM2',
			popupWidth: 710,
			extParam: {'CUSTOM_TYPE': ['1','2']}    
		}),{
			fieldLabel: '매출기간',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			xtype: 'uniDateRangefield',
			width: 315,
			allowBlank: false ,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(masterForm) {
					masterForm.setValue('INOUT_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(masterForm) {
		    		masterForm.setValue('INOUT_DATE_TO',newValue);
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('map201skrvGrid', {
    	region: 'center' ,
        layout: 'fit',
        uniOpt: {
    		onLoadSelectFirst: false,  
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useRowNumberer: true,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal1', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal1', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns: [
        	{dataIndex:'COMP_CODE' 			,width:100, hidden: true	},
				 {dataIndex:'DIV_CODE' 				,width:100, hidden: true	},
				 {dataIndex:'INOUT_TYPE' 			,width:95,align:'center'	},
				 {dataIndex:'INOUT_DATE' 			,width:80	},
				 {dataIndex:'WH_CODE' 				,width:120,align:'center'},
				 {dataIndex:'ITEM_CODE' 			,width:100	},
				 {dataIndex:'ITEM_NAME' 			,width:200,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	            		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
	             }},
				 {dataIndex:'TAX_TYPE' 				,width:95,align:'center'	},
				 {
            	text: '매출',
         		columns: [ 
         			{dataIndex:'INOUT_Q' 			,width:110, summaryType: 'sum'	},
					{dataIndex:'INOUT_I' 			,width:110, summaryType: 'sum'	},
					{dataIndex:'INOUT_TAX_AMT' 		,width:110, summaryType: 'sum'	},
					{dataIndex:'TOTAL_INOUT_I' 		,width:110, summaryType: 'sum'	}
         		]}
        ]
    });		// End of masterGrid= Unilite.createGrid('map201skrvGrid', {
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm  	
		],	
		id: 'map201skrvApp',
	    uniOpt: {
	    	showToolbar: true,
	    	isManual : false
	    },
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('query',true);
			UniAppManager.setToolbarButtons('reset',true);
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('INOUT_DATE_FR',UniDate.get('today'));
			masterForm.setValue('INOUT_DATE_TO',UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_FR',UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_TO',UniDate.get('today'));
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		setDefault: function() {
			map201skrvService.userCustom({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				masterForm.setValue('CUSTOM_CODE', provider['CUSTOM_CODE']);
				masterForm.setValue('CUSTOM_NAME', provider['CUSTOM_NAME']);
				panelResult.setValue('CUSTOM_CODE', provider['CUSTOM_CODE']);
				panelResult.setValue('CUSTOM_NAME', provider['CUSTOM_NAME']);
				}
			});
			Ext.getCmp('CUSTOM1').setReadOnly(true);
			Ext.getCmp('CUSTOM2').setReadOnly(true);
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 
			return masterForm.setAllFieldsReadOnly(true);
        }		
	});			
};
</script>