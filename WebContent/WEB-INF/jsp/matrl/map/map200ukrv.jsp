<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map200ukrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="map200ukrv" /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B035" /> <!--수불구분-->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>  <!-- 세구분 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell1 {
background-color: #fcfac5;
}
.x-change-cell2 {
background-color: #fed9fe;
}
</style>
<script type="text/javascript" >
///// 최종마감일이 없을시  rdo disabled처리 해야함 map200ukrv.htm  283줄
function appMain() {	
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false ,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '매입기간',
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
			}, 
			Unilite.popup('CUST', {
				allowBlank: false ,
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
	//				textFieldWidth:170, 
	//				validateBlank:false, 
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},		        
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
			}), {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '작업선택',
	    		items: [{
	    			boxLabel: '매입집계',
	    			width: 105,
	    			name: 'GUBUN',
	    			inputValue: 'N'
	    		}, {
	    			boxLabel: '취소',
	    			width: 95,
	    			name: 'GUBUN',
	    			inputValue: 'C'
	    		}],
	    		listeners: {
					change: function(field, newValue, oldValue, eOpts){
						panelResult.getField('GUBUN').setValue(newValue.GUBUN);						
					}
				} 
	        },{
	        	margin: '0 0 0 40',
				xtype: 'button',
				text: '실행',	
	        	width: 285,
	//	        	tdAttrs:{'align':'center'},							   	
				handler : function() {
					if(!panelSearch.setAllFieldsReadOnly(true)){
			    		return false;
			    	}
					var me = this;
					panelSearch.getEl().mask();
					masterGrid1.getEl().mask();
//					masterGrid2.getEl().mask();
					var param = panelSearch.getValues();
					map200ukrvService.insertMasterMap200(param, function(provider, response)	{
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);							
						}
						panelSearch.getEl().unmask();
						masterGrid1.getEl().unmask();
//						masterGrid2.getEl().unmask();
						masterGrid1.getStore().loadStoreRecords();
//						masterGrid2.getStore().loadStoreRecords();
					});
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
				}
	  		}
			return r;
  		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					panelSearch.setValue('DIV_CODE', newValue);
				}
			} 
		},{
			xtype: 'component'
		},{
			xtype: 'component'
		}, {
			fieldLabel: '매입기간',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			xtype: 'uniDateRangefield',
			width: 315,
			allowBlank: false ,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INOUT_DATE_TO',newValue);
		    		
		    	}
		    }
		},{
	    	xtype: 'component'
	    }, {
    		xtype: 'radiogroup',		            		
    		fieldLabel: '작업선택',
    		items: [{
    			boxLabel: '매입집계',
    			width: 105,
    			name: 'GUBUN',
    			inputValue: 'N'
    		}, {
    			boxLabel: '취소',
    			width: 95,
    			name: 'GUBUN',
    			inputValue: 'C'
    		}],
    		listeners: {
				change: function(field, newValue, oldValue, eOpts){
					panelSearch.getField('GUBUN').setValue(newValue.GUBUN);						
				}
			} 
        }, 
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			allowBlank: false ,
//				textFieldWidth:170, 
//				validateBlank:false, 
			popupWidth: 710,
			extParam: {'CUSTOM_TYPE': ['1','2']},		        
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
		}),{
			xtype: 'component'
		},{
        	margin: '0 0 0 40',
			xtype: 'button',
			text: '실행',	 
        	width: 205,
//	        	tdAttrs:{'align':'center'},							   	
			handler : function() {
				if(!panelSearch.setAllFieldsReadOnly(true)){
		    		return false;
		    	}
				var me = this;
				panelResult.getEl().mask();
				masterGrid1.getEl().mask();
//				masterGrid2.getEl().mask();
				var param = panelSearch.getValues();
				map200ukrvService.insertMasterMap200(param, function(provider, response)	{
					if(provider){
						UniAppManager.updateStatus(Msg.sMB011);							
					}
					panelResult.getEl().unmask();
					masterGrid1.getEl().unmask();
//					masterGrid2.getEl().unmask();
					masterGrid1.getStore().loadStoreRecords();
//					masterGrid2.getStore().loadStoreRecords();
				});
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
				}
	  		}
			return r;
  		}
    });
	
	Unilite.defineModel('map200ukrvModel1', {
	    fields: [
				 {name: 'COMP_CODE' 			,text:'COMP_CODE',type:'string'	},
				 {name: 'DIV_CODE' 				,text:'<t:message code="system.label.purchase.division" default="사업장"/>' 	,type:'string'	},
				 {name: 'INOUT_TYPE' 			,text:'수불구분' 	,type:'string', comboType:'AU', comboCode:'B035'	},
				 {name: 'INOUT_DATE' 			,text:'매출일' 	,type:'uniDate', convert:dateToString	},
				 {name: 'INOUT_NUM' 			,text:'<t:message code="system.label.purchase.receiptno" default="입고번호"/>' 	,type:'string'	},
				 {name: 'INOUT_SEQ' 			,text:'<t:message code="system.label.purchase.seq" default="순번"/>' 		,type:'string'	},
				 {name: 'ITEM_CODE' 			,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 	,type:'string'	},
				 {name: 'ITEM_NAME' 			,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>' 	,type:'string'	},
				 {name: 'WH_CODE' 				,text:'<t:message code="system.label.purchase.warehouse" default="창고"/>' 		,type:'string', store: Ext.data.StoreManager.lookup('whList')	},
				 {name: 'INOUT_Q' 				,text:'<t:message code="system.label.purchase.issueqty" default="출고량"/>' 		,type:'uniQty'	},
				 {name: 'INOUT_Q2' 				,text:'<t:message code="system.label.purchase.receiptqty" default="입고량"/>' 		,type:'uniQty'	},
				 {name: 'TAX_TYPE' 				,text:'과세구분' 	,type:'string', comboType:'AU', comboCode:'B059'	},
				 {name: 'INOUT_I' 				,text:'<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'	,type:'uniPrice'	},
				 {name: 'INOUT_I2' 				,text:'<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'	,type:'uniPrice'	},
				 {name: 'INOUT_TAX_AMT' 		,text:'<t:message code="system.label.purchase.vatamount" default="부가세액"/>' 	,type:'uniPrice'	},
				 {name: 'INOUT_TAX_AMT2' 		,text:'<t:message code="system.label.purchase.vatamount" default="부가세액"/>' 	,type:'uniPrice'	},
				 {name: 'TOTAL_INOUT_I' 		,text:'<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'	,type:'uniPrice'	},
				 {name: 'TOTAL_INOUT_I2' 		,text:'<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'	,type:'uniPrice'	}
//				 {name: 'INOUT_P' 				,text:'INOUT_P'	,type:'uniPrice'	},
//				 {name: 'ORDER_UNIT' 			,text:'<t:message code="system.label.purchase.unit" default="단위"/>' 		,type:'string'	},
			]
	});
	
//	Unilite.defineModel('map200ukrvModel2', {
//	    fields: [
//				 {name: 'COMP_CODE' 			,text:'COMP_CODE',type:'string'	},
//				 {name: 'DIV_CODE' 				,text:'<t:message code="system.label.purchase.division" default="사업장"/>' 	,type:'string'	},
//				 {name: 'INOUT_TYPE' 			,text:'수불구분' 	,type:'string', comboType:'AU', comboCode:'B035'	},
//				 {name: 'INOUT_DATE' 			,text:'<t:message code="system.label.purchase.receiptdate" default="입고일"/>' 	,type:'uniDate', convert:dateToString	},
//				 {name: 'INOUT_NUM' 			,text:'<t:message code="system.label.purchase.receiptno" default="입고번호"/>' 	,type:'string'	},
//				 {name: 'INOUT_SEQ' 			,text:'<t:message code="system.label.purchase.seq" default="순번"/>' 		,type:'string'	},
//				 {name: 'ITEM_CODE' 			,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 	,type:'string'	},
//				 {name: 'ITEM_NAME' 			,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>' 	,type:'string'	},
//				 {name: 'WH_CODE' 				,text:'<t:message code="system.label.purchase.warehouse" default="창고"/>' 		,type:'string', store: Ext.data.StoreManager.lookup('whList')	},
//				 {name: 'ORDER_UNIT' 			,text:'<t:message code="system.label.purchase.unit" default="단위"/>' 		,type:'string'	},
//				 {name: 'INOUT_Q' 				,text:'<t:message code="system.label.purchase.qty" default="수량"/>' 		,type:'uniQty'	},
//				 {name: 'TAX_TYPE' 				,text:'과세구분' 	,type:'string', comboType:'AU', comboCode:'B059'	},
//				 {name: 'INOUT_P' 				,text:'INOUT_P'	,type:'uniPrice'	},
//				 {name: 'INOUT_I' 				,text:'<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'	,type:'uniPrice'	},
//				 {name: 'INOUT_TAX_AMT' 		,text:'<t:message code="system.label.purchase.vatamount" default="부가세액"/>' 	,type:'uniPrice'	},
//				 {name: 'TOTAL_INOUT_I' 		,text:'<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'	,type:'uniPrice'	}
//			]
//	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	  
	var directMasterStore1 = Unilite.createStore('map200ukrvMasterStore1', {
		model: 'map200ukrvModel1',
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
            	read: 'map200ukrvService.selectList1'                	
		    }
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params: param
			});
		},
		groupField: 'INOUT_DATE'
	});
	
//	var directMasterStore2 = Unilite.createStore('map200ukrvMasterStore2', {
//		model: 'map200ukrvModel2',
//		uniOpt: {
//           	isMaster: false,			// 상위 버튼,상태바 연결 
//           	editable: false,			// 수정 모드 사용 
//           	deletable:false,			// 삭제 가능 여부 
//            useNavi: false				// prev | newxt 버튼 사용
//		},
//        autoLoad: false,
//        proxy: {
//        	type: 'direct',
//            api: {
//            	read: 'map200ukrvService.selectList2'                	
//		    }
//		},
//		loadStoreRecords: function() {
//			var param= Ext.getCmp('searchForm').getValues();
//			this.load({
//				params: param
//			});
//		},
//		groupField: 'INOUT_DATE'
//	});
	
    var masterGrid1 = Unilite.createGrid('map200ukrvGrid1', {
    	region:'center',
    	store: directMasterStore1,
        layout : 'fit',
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
        features: [ {id : 'masterGridSubTotal1', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal1', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        border:true,
		columns:[{dataIndex:'COMP_CODE' 			,width:100, hidden: true	},
				 {dataIndex:'DIV_CODE' 				,width:100, hidden: true	},
				 {dataIndex:'INOUT_TYPE' 			,width:95	},
				 {dataIndex:'INOUT_DATE' 			,width:80	},
				 {dataIndex:'WH_CODE' 				,width:100},
				 {dataIndex:'ITEM_CODE' 			,width:100	},
				 {dataIndex:'ITEM_NAME' 			,width:200,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	            		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
	             }},				
//				 {dataIndex:'ORDER_UNIT' 			,width:75,
//					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//	            		return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
//	             }},
//				 {dataIndex:'INOUT_P' 				,width:80, summaryType: 'sum', hidden: true	},
				 {dataIndex:'TAX_TYPE' 				,width:95	, align: 'center'},
				 {
            	text: '매출',
         		columns: [ 
         			{dataIndex:'INOUT_Q' 			,width:90, summaryType: 'sum'	},
					{dataIndex:'INOUT_I' 			,width:90, summaryType: 'sum'	},
					{dataIndex:'INOUT_TAX_AMT' 		,width:90, summaryType: 'sum'	},
					{dataIndex:'TOTAL_INOUT_I' 		,width:90, summaryType: 'sum'	}
         		]},
				 {
            	text: '매입',
         		columns: [ 
         		 {dataIndex:'INOUT_Q2' 				,width:90, summaryType: 'sum',tdCls:'x-change-cell2'	},
				 {dataIndex:'INOUT_I2' 				,width:90, summaryType: 'sum',tdCls:'x-change-cell2'	},
				 {dataIndex:'INOUT_TAX_AMT2' 		,width:90, summaryType: 'sum',tdCls:'x-change-cell2'	},
				 {dataIndex:'TOTAL_INOUT_I2' 		,width:90, summaryType: 'sum',tdCls:'x-change-cell2'	}
         		]},				 
				 {dataIndex:'INOUT_NUM' 			,width:135	},
				 {dataIndex:'INOUT_SEQ' 			,width:50, align: 'center'	}
         ],
		listeners: {
		}
    });
    
//    var masterGrid2 = Unilite.createGrid('map200ukrvGrid2', {
//    	region:'east',
//    	store: directMasterStore2,
//        layout : 'fit',
//        split: true,
//		uniOpt: {
//			onLoadSelectFirst: false,  
//    		useGroupSummary: false,
//    		useLiveSearch: false,
//			useContextMenu: false,
//			useMultipleSorting: false,
//			useRowNumberer: true,
//			expandLastColumn: false,
//    		filter: {
//				useFilter: false,
//				autoCreate: false
//			}
//        },
//        features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: true },
//    	           	{id : 'masterGridTotal2', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
//        border:true,
//		columns:[{dataIndex:'COMP_CODE' 			,width:100, hidden: true	},
//				 {dataIndex:'DIV_CODE' 				,width:100, hidden: true	},
//				 {dataIndex:'INOUT_TYPE' 			,width:66	},
//				 {dataIndex:'INOUT_DATE' 			,width:80	},
//				 {dataIndex:'WH_CODE' 				,width:75},
//				 {dataIndex:'INOUT_NUM' 			,width:115	},
//				 {dataIndex:'INOUT_SEQ' 			,width:50, align: 'center'	},
//				 {dataIndex:'ITEM_CODE' 			,width:100	},
//				 {dataIndex:'ITEM_NAME' 			,width:140,
//					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//	            		return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
//	             }},				 
////				 {dataIndex:'ORDER_UNIT' 			,width:75,
////					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
////	            		return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
////	             }},
//				 {dataIndex:'INOUT_Q' 				,width:66, summaryType: 'sum'	},
//				 {dataIndex:'TAX_TYPE' 				,width:66	},
//				 {dataIndex:'INOUT_P' 				,width:80, summaryType: 'sum', hidden: true	},
//				 {dataIndex:'INOUT_I' 				,width:80, summaryType: 'sum'	},
//				 {dataIndex:'INOUT_TAX_AMT' 		,width:80, summaryType: 'sum'	},
//				 {dataIndex:'TOTAL_INOUT_I' 		,width:80, summaryType: 'sum'	}
//         ],
//		listeners: {
//			beforeedit  : function( editor, e, eOpts ) {
//				
//			}	
//		}
//    });

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid1/*,masterGrid2*/, panelResult
			]	
		},
			panelSearch  	
		],
		id: 'map200ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('query',true);
			UniAppManager.setToolbarButtons('reset',true);			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('INOUT_DATE_FR')));						
			panelSearch.getField( 'GUBUN').setValue('N');
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('INOUT_DATE_FR', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('INOUT_DATE_FR')));
			panelResult.getField( 'GUBUN').setValue('N');
			
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.getStore().loadData({})
//			masterGrid2.getStore().loadData({})
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid1.getStore().loadStoreRecords();
//			masterGrid2.getStore().loadStoreRecords();
			var viewNormal1 = masterGrid1.getView();
		    viewNormal1.getFeature('masterGridTotal1').toggleSummaryRow(true);
		    viewNormal1.getFeature('masterGridSubTotal1').toggleSummaryRow(true);
		    
//		    var viewNormal2 = masterGrid2.getView();
//		    viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
//		    viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
		}
	});
};
</script>
