<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="map050ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="map050ukrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP10" /> <!--지급유형-->  
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 지급담당 -->
</t:appConfig>
<style type="text/css">
.x-change-cell {
background-color: #fed9fe;
}
</style>

<script type="text/javascript" >



var CustomCodeInfo = {
	gsUnderCalBase: ''
};

/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/

var outDivCode = UserInfo.divCode;

function appMain() {   
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'map050ukrvService.selectGrid',
			update: 'map050ukrvService.updateDetail',
			create: 'map050ukrvService.insertDetail',
			destroy: 'map050ukrvService.deleteDetail',
			syncAll: 'map050ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Map050ukrvModel', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		,type: 'string'},  	 	
	    	{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'		,type: 'string'},  	 	
	    	{name: 'CHANGE_BASIS_DATE'	,text: '거래일자'		,type: 'uniDate'},  
	    	{name: 'INOUT_NUM'			,text: '<t:message code="system.label.purchase.purchaseno" default="매입번호"/>'		,type: 'string'},  
	    //	{name: 'ITEM_CODE'			,text: 'ITEM_CODE'	,type: 'string'},  	 	
	    	{name: 'ITEM_NAME'			,text: '거래내역'		,type: 'string'},  	 	
	    	{name: 'CNT'				,text: '종수'			,type: 'uniQty'},  	 	
	    	{name: 'BUY_Q'				,text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'		,type: 'uniQty'},  	 	
	    	{name: 'BUY_I'				,text: '매입액'		,type: 'uniPrice'},  	 	
	    	{name: 'R_BUY_Q'			,text: '반품수량'		,type: 'uniQty'},  	 	
	    	{name: 'R_BUY_I'			,text: '반품액'		,type: 'uniPrice'},  	 	
	    	{name: 'PAY_AMT'			,text: '지급액'		,type: 'uniPrice'},  	 	
//	    	{name: 'M_PAY_AMT'			,text: '조정액'		,type: 'uniPrice'},  	 	
	    	{name: 'CALCUL_I'			,text: '잔액'			,type: 'uniPrice'},
	    	{name: 'DEPT_NAME'			,text: '매장명'		,type: 'string'},
	    	{name: 'BALANCE_AMT'		,text: '대사잔액'		,type: 'uniPrice',allowBlank: false},  	 	
	    	{name: 'BALANCE_DATE'		,text: '대사일자'		,type: 'uniDate',allowBlank: false},  	 	
	    	{name: 'BALANCE_PRSN'		,text: '<t:message code="system.label.purchase.charger" default="담당자"/>'		,type: 'string',comboType:'AU', comboCode:'M201',allowBlank: false},  	 	
	    	{name: 'REMARK'				,text: '내용'			,type: 'string'}
			
		]  
	});		//End of Unilite.defineModel('Map050ukrvModel', {
	
	Unilite.defineModel('Map050ukrvModel2', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'		,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
	    	{name: 'DIV_CODE'		,text: '<t:message code="system.label.purchase.division" default="사업장"/>'			,type: 'string'},
			{name: 'INOUT_SEQ'		,text: '<t:message code="system.label.purchase.seq" default="순번"/>'				,type: 'int'},
			{name: 'ITEM_CODE'		,text: '품번'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				,type: 'string'},
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.purchase.unit" default="단위"/>'				,type: 'string'},
			{name: 'INOUT_Q'		,text: '<t:message code="system.label.purchase.qty" default="수량"/>'				,type: 'uniQty'},
			{name: 'INOUT_P'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniUnitPrice'},
			{name: 'TAX_TYPE' 		,text: '과세구분'			,type: 'string',comboType:'AU',comboCode:'B059'},
			{name: 'INOUT_I'		,text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'			,type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'	,text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'			,type: 'uniPrice'},
			{name: 'TOTAL_INOUT_I'	,text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'			,type: 'uniPrice'}
		]  
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('map050ukrvMasterStore1',{
		model: 'Map050ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
           	
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
			
		proxy: directProxy,
		listeners: {
           	load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
			},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();	
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			
			var paramMaster= masterForm.getValues();
			
				var inValidRecs = this.getInvalidRecords();
  /*          	var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords();        		
	       		var toDelete = this.getRemovedRecords();
	       		var list = [].concat(toUpdate, toCreate);*/
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					config = {
						params: [paramMaster],
							
						success: function(batch, option) {
							directMasterStore1.loadStoreRecords();
							masterGrid2.reset();
							beforeRowIndex = -1;
			//				var a = batch.operations[0].getResultSet();
							
		//					masterForm.setValue("BALANCE_AMT", a.BALANCE_AMT);
						/*	Ext.each(list, function(record, index) {
								record.set('BALANCE_AMT', a.BALANCE_AMT);
							
						})*/
					/*	var param = {
							"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
							"DIV_CODE": masterForm.getValue('DIV_CODE')
				};
					map050ukrvService.checkBalanceAmt(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						var records = masterGrid.getSelectedRecords();
						Ext.each(records,  function(record, index, records){
							record.set('BALANCE_AMT', provider['BALANCE_AMT']);
						});
						
					}
				})*/
					 } 
					};
				this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});		// End of var directMasterStore1 = Unilite.createStore('map050ukrvMasterStore1',{
	
		var directMasterStore2 = Unilite.createStore('map050ukrvMasterStore2', {
		model: 'Map050ukrvModel2',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'map050ukrvService.selectList2'                	
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params : param
			});
		}
	});
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
//				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					allowBlank: false,
//		            holdable: 'hold',
		            extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'CHANGE_BASIS_DATE_FR',
				endFieldName: 'CHANGE_BASIS_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
//				holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('CHANGE_BASIS_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('CHANGE_BASIS_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel:'<t:message code="system.label.purchase.purchaseno" default="매입번호"/>',
				name:'CHANGE_BASIS_NUM',
				xtype:'uniTextfield',
				hidden:true	
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
//				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST', { 
					fieldLabel: '매입처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					allowBlank: false,
//		            holdable: 'hold',
		            extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE', '');
								masterForm.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
				fieldLabel: '실적일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'CHANGE_BASIS_DATE_FR',
				endFieldName: 'CHANGE_BASIS_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
//				holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('CHANGE_BASIS_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('CHANGE_BASIS_DATE_TO',newValue);
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
    var masterGrid= Unilite.createGrid('map050ukrvGrid', {
    	region: 'center' ,
//        layout: 'fit',
        excelTitle: '매입처별 거래원장대사등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        }, 
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
        columns: [
        	{dataIndex:'COMP_CODE'					, width: 88, hidden:true },
        	{dataIndex:'DIV_CODE'					, width: 88, hidden:true },
        	{dataIndex:'CHANGE_BASIS_DATE'			, width: 88 ,
	        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(record.get('ITEM_NAME') == '출금'){
                        return '<div style= "background-color:' + '#fcfac5' + '">' + UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6) + '.' + UniDate.getDbDateStr(val).substring(6, 8) + '</div>';
        			}else if (record.get('ITEM_NAME') == '전기(월) 이월 금액'){
        				return '';
        			}else{
        				return UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6) + '.' + UniDate.getDbDateStr(val).substring(6, 8);
        			}
                }
        	
        	},
        	{dataIndex:'INOUT_NUM'					, width: 150,align:'center',
	        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
	        			if(record.get('ITEM_NAME') == '출금'){
	                        return '<div style= "background-color:' + '#fcfac5' + '">' + '' + '</div>';
	        			}else{
	        				return val;
	        			}
	                }
        	},
        //	{dataIndex:'ITEM_CODE'					, width: 88, hidden:true},
        	{dataIndex:'ITEM_NAME'					, width: 200 ,
        		renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(record.get('ITEM_NAME') == '출금'){
                        return '<div style= "background-color:' + '#fcfac5' + '">' + val + '</div>';
        			}else{
        				return val;
        			}
                },
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
        	{dataIndex:'CNT'					, width: 60, summaryType: 'sum',
        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(record.get('ITEM_NAME') == '출금'){
                        return '<div style= "background-color:' + '#fcfac5' + '">' + val + '</div>';
        			}else{
        				return val;
        			}
                }},
        	{dataIndex:'BUY_Q'				, width: 88, summaryType: 'sum',
        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(record.get('ITEM_NAME') == '출금'){
                        return '<div style= "background-color:' + '#fcfac5' + '">' + Ext.util.Format.number(val,'0,000') + '</div>';
        			}else{
        				return Ext.util.Format.number(val,'0,000');
        			}
                }},
        	{dataIndex:'BUY_I'					, width: 88, summaryType: 'sum',
        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(record.get('ITEM_NAME') == '출금'){
                        return '<div style= "background-color:' + '#fcfac5' + '">' + Ext.util.Format.number(val,'0,000') + '</div>';
        			}else{
        				return Ext.util.Format.number(val,'0,000');
        			}
                }},
        	{dataIndex:'R_BUY_Q'				, width: 88, summaryType: 'sum',
        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(record.get('ITEM_NAME') == '출금'){
                        return '<div style= "background-color:' + '#fcfac5' + '">' + Ext.util.Format.number(val,'0,000') + '</div>';
        			}else{
        				return Ext.util.Format.number(val,'0,000');
        			}
                }},
        	{dataIndex:'R_BUY_I'				, width: 88, summaryType: 'sum',
        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(record.get('ITEM_NAME') == '출금'){
                        return '<div style= "background-color:' + '#fcfac5' + '">' + Ext.util.Format.number(val,'0,000') + '</div>';
        			}else{
        				return Ext.util.Format.number(val,'0,000');
        			}
                }},
        	{dataIndex:'PAY_AMT'						, width: 88, summaryType: 'sum',
        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(record.get('ITEM_NAME') == '출금'){
                        return '<div style= "background-color:' + '#fcfac5' + '">' + Ext.util.Format.number(val,'0,000') + '</div>';
        			}else{
        				return Ext.util.Format.number(val,'0,000');
        			}
                }},
//        	{dataIndex:'M_PAY_AMT'					, width: 88 },
        	{dataIndex:'CALCUL_I'					, width: 88,tdCls:'x-change-cell',
        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(record.get('ITEM_NAME') == '출금'){
                        return '<div style= "background-color:' + '#fcfac5' + '">' + Ext.util.Format.number(val,'0,000') + '</div>';
        			}else{
        				return Ext.util.Format.number(val,'0,000');
        			}
                }
        	},
        	{dataIndex:'DEPT_NAME'					, width: 100 },
        	{dataIndex:'BALANCE_AMT'				, width: 88,
        		renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			var rec = masterGrid.getStore().getAt(rowIndex);
					if (val != rec.get('CALCUL_I')){
                        return '<span style= "color:' + '#da3f3a' + '">' + Ext.util.Format.number(val,'0,000') + '</span>';
                    }
                    return Ext.util.Format.number(val,'0,000');
                }
                
        	},  	
        	{dataIndex:'BALANCE_DATE'				, width: 88 },
        	{dataIndex:'BALANCE_PRSN'				, width: 88,align:'center' },
        	{dataIndex:'REMARK'						, width: 600 }
        ],
        listeners: {
        	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					masterForm.setValue('CHANGE_BASIS_NUM',record.get('INOUT_NUM'));
//					masterForm.setValue('G_INOUT_CODE',record.get('INOUT_CODE'));
					directMasterStore2.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
			},
        	
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.CHANGE_BASIS_DATE == null){
					return false;
				}else {
				if(UniUtils.indexOf(e.field, ['BALANCE_DATE','BALANCE_PRSN','REMARK'])){
						return true;
					}else{
						return false;
					}
				}
			/*	if(e.record.phantom == true){
					if(UniUtils.indexOf(e.field, ['PAYMENT_SEQ','SUM_O'])){
						return false;
					}else{
						return true;
					}
				}else{
					if(UniUtils.indexOf(e.field, ['PAYMENT_TYPE','PAY_LOC_AMT','REMARK'])){
						return true;
					}else{
						return false;
					}
				}*/
			}
		}
		
    });		// End of masterGrid= Unilite.createGrid('map050ukrvGrid', {
    
	var masterGrid2 = Unilite.createGrid('map050ukrvGrid2', {
//		layout: 'fit',
		region: 'south',
		split:true,
		flex: 0.5,
		excelTitle: '거래내역(detail)',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore2,
		columns: [
				{dataIndex: 'COMP_CODE'				,width:80,hidden:true},
				{dataIndex: 'DIV_CODE'				,width:80,hidden:true},
				{dataIndex: 'INOUT_SEQ'				,width:88},
				{dataIndex: 'ITEM_CODE'				,width:150,align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}},
				{dataIndex: 'ITEM_NAME'				,width:200},
				{dataIndex: 'ORDER_UNIT'			,width:60,align:'center'},
				{dataIndex: 'INOUT_Q'				,width:88,summaryType: 'sum'},
				{dataIndex: 'INOUT_P'				,width:88},
				{dataIndex: 'TAX_TYPE' 		   		,width:88,align:'center'},
				{dataIndex: 'INOUT_I'				,width:88,summaryType: 'sum'},
				{dataIndex: 'INOUT_TAX_AMT'			,width:88,summaryType: 'sum'},
				{dataIndex: 'TOTAL_INOUT_I'			,width:88,summaryType: 'sum'}
				
		]
	});//End of var masterGrid = Unilite.createGrid('map101ukrvGrid1', {
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult,masterGrid2
			]
			
//			items:[masterGrid2]
		},
			masterForm  	
		],	
		id: 'map050ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('CHANGE_BASIS_DATE_FR',UniDate.get('startOfMonth'));
			masterForm.setValue('CHANGE_BASIS_DATE_TO',UniDate.get('today'));
			panelResult.setValue('CHANGE_BASIS_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('CHANGE_BASIS_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset'/*, 'prev', 'next'*/], true);
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				
				directMasterStore1.loadStoreRecords();
				masterGrid2.reset();
				beforeRowIndex = -1;
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
				
				/*
				masterGrid.getStore().load({
				success: function()	{
						masterForm.setAllFieldsReadOnly(true)
//						if(BsaCodeInfo.gsDraftFlag == 'Y' && masterForm.getValue('STATUS') != '1') 	{
//							checkDraftStatus = true;							
//						}
						masterForm.uniOpt.inLoading=false;
					
					masterForm.setValue('PAYMENT_NUM',directMasterStore1.data.items[0].get('PAYMENT_NUM'));
	           		masterForm.setValue('PAY_CUSTOM_CODE',directMasterStore1.data.items[0].get('PAY_CUSTOM_CODE'));
	           		masterForm.setValue('PAY_CUSTOM_NAME',directMasterStore1.data.items[0].get('CUSTOM_NAME'));
	           		masterForm.setValue('PAYMENT_PRSN',directMasterStore1.data.items[0].get('PAYMENT_PRSN'));
	           		masterForm.setValue('PAY_DIV_CODE',directMasterStore1.data.items[0].get('PAY_DIV_CODE'));
					},
					failure: function(form, action) {
                        masterForm.uniOpt.inLoading=false;
                    }
				
				});*/

			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 var divCode = masterForm.getValue('DIV_CODE');
				 var seq = directMasterStore1.max('PAYMENT_SEQ');
            	 if(!seq) seq = 1;
            	 else  seq += 1;
            	// var paymentType ='A1';
            	 
            	 var r = {
					PAYMENT_SEQ: seq,
					DIV_CODE: divCode
				//	PAYMENT_TYPE: paymentType
		        };
				masterGrid.createRow(r,seq-2);
				masterForm.setAllFieldsReadOnly(false);
				panelResult.setAllFieldsReadOnly(false);
			},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid2.reset();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
				directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
			}
		},
		/*onDeleteAllButtonDown: function() {
			if(confirm('삭제 하시겠습니까?')) {
				masterGrid.reset();
				UniAppManager.app.onSaveDataButtonDown();
			}
		},*/
		setDefault: function() {
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 
			return masterForm.setAllFieldsReadOnly(true);
        },
        onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/map/map050rkrPrint.do',
	            prgID: 'map050rkr',
	               extParam: {
	                  
	                  DIV_CODE  			: param.DIV_CODE,
	                  DEPT_CODE 			: param.DEPT_CODE,
	                  CUSTOM_CODE   		: param.CUSTOM_CODE,
	                  CUSTOM_NAME 			: param.CUSTOM_NAME,
	                  CHANGE_BASIS_DATE_FR 	: param.CHANGE_BASIS_DATE_FR,
	                  CHANGE_BASIS_DATE_TO  : param.CHANGE_BASIS_DATE_TO,
	                  CHANGE_BASIS_NUM    	: param.CHANGE_BASIS_NUM
	               }
	            });
	            win.center();
	            win.show();
	               
	      }
	});	
		Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BALANCE_DATE":
						if(newValue != '' && newValue != null){
							record.set('BALANCE_AMT',record.get('CALCUL_I'));
						}
						break;
				case "BALANCE_PRSN":
						if(newValue != '' && newValue != null){
							record.set('BALANCE_AMT',record.get('CALCUL_I'));
						}
						break;
//				case "REMARK":
//						record.set('BALANCE_AMT',record.get('CALCUL_I'));
				
				//	masterForm.setValue('BLAN_AMT', record.get('SUM_O') - newValue);
			}
				return rv;
						}
			});	
			
};
</script>
