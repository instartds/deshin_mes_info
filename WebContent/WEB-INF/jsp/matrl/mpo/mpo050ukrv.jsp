<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo050ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo050ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M021"  /><!-- 구매담당자 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->	

</t:appConfig>
<script type="text/javascript" >



function appMain() {   

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo050ukrvService.selectList',
			update: 'mpo050ukrvService.updateDetail',
			create: 'mpo050ukrvService.insertDetail',
			destroy: 'mpo050ukrvService.deleteDetail',
			syncAll: 'mpo050ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('mpo050ukrvModel', {
	    fields: [  	 	    
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string'},
			{name: 'ITEM_LEVEL1'	 	,text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'				,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2'	 	,text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'				,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve2Store')},
			{name: 'ITEM_LEVEL3'	 	,text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>'				,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_CODE'	 		,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				,type: 'string'},
			{name: 'ITEM_NAME'	 		,text: '도서명'				,type: 'string'},
			{name: 'AUTHOR1'	 		,text: '저자'					,type: 'string'},
			{name: 'PUBLISHER'	 		,text: '출판사'				,type: 'string'},
			{name: 'SALE_CUSTOM_CODE'	,text: '매입처'				,type: 'string'},
			{name: 'PUB_DATE'	 		,text: '초판발행일'				,type: 'uniDate'},
			{name: 'BOOK_P'	 			,text: '정가'					,type: 'uniUnitPrice'},
			{name: 'SALE_Q'	 			,text: '판매수량'				,type: 'uniQty'},
			{name: 'SALE_AMT_O'			,text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'				,type: 'uniPrice'},
			{name: 'STOCK_Q'			,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'				,type: 'string'},
			{name: 'ORDER_REQ_Q'		,text: '주문수량'				,type: 'uniQty' , allowBlank:false},
			{name: 'ORDER_STATUS'		,text: '구매요청상태'			,type: 'string'},
			{name: 'REMARK'		 		,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					,type: 'string'},
			
			{name: 'BILL_NUM'			,text: 'BILL_NUM'			,type: 'string'},
			{name: 'ORDER_REQ_DATE'		,text: '구매요청일'				,type: 'uniDate'},
			{name: 'DEPT_CODE'		 	,text: '담당자 부서코드'			,type: 'string'},
			{name: 'ORDER_PRSN_CODE'	,text: '담당자코드'				,type: 'string'},
			{name: 'POS_NO'		 		,text: '포스번호'				,type: 'string'},
			{name: 'COMP_CODE'	 		,text: 'COMP_CODE'			,type: 'string'},
			{name: 'INSERT_DB_USER'		,text: 'INSERT_DB_USER'		,type: 'string'},
			{name: 'INSERT_DB_TIME'	 	,text: 'INSERT_DB_TIME'		,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'	 	,text: 'UPDATE_DB_TIME'		,type: 'string'}
		]  
	});		//End of Unilite.defineModel('mpo050ukrvModel', {
	

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('mpo050ukrvMasterStore1',{
		model: 'mpo050ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
			
		proxy: {
			type: 'direct',
			api: {
				read    : 'mpo050ukrvService.selectMasterList'
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
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
					var master = batch.operations[0].getResultSet();
					masterForm.setValue("BILL_NUM", master.BILL_NUM);
					var orderNum = masterForm.getValue('BILL_NUM');
					Ext.each(list, function(record, index) {
						if(record.data['BILL_NUM'] != orderNum) {
							record.set('BILL_NUM', orderNum);
						}
					})
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					 } 
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('mpo050ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnSumOrderO: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sSumOrderO = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
			var sSumOrderLocO = Ext.isNumeric(this.sum('ORDER_LOC_O')) ? this.sum('ORDER_LOC_O'):0;
			masterForm.setValue('SumOrderO',sSumOrderO);
			masterForm.setValue('SumOrderLocO',sSumOrderLocO);
			masterForm.fnCreditCheck()
		}
	});		// End of var directMasterStore1 = Unilite.createStore('mpo050ukrvMasterStore1',{
	
	
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '발주조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
       /* listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },*/
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
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DEPT', {
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
				valueFieldName:'DEPT_CODE',
		    	textFieldName:'DEPT_NAME',
				valueFieldWidth: 85,
				textFieldWidth: 150,
/*				allowBlank: false,
				holdable: 'hold',*/
				listeners: {
					onSelected: {
						fn: function(records, type) {
							
							panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
								
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_NAME', '');
							}
				}
			}),{
		        fieldLabel: '매출기간',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'SALE_DATE_FR',
		        endFieldName: 'SALE_DATE_TO',
/*		        allowBlank: false,
			//	holdable: 'hold',
*/		        width: 315,
		        startDate: UniDate.get('yesterday'),
		        endDate: UniDate.get('today'),
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
    			fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
    			name: 'TXTLV_L1',
    			xtype: 'uniCombobox',
    			store: Ext.data.StoreManager.lookup('itemLeve1Store'),
    			child: 'TXTLV_L2',
/*    			allowBlank:false,
				holdable: 'hold',*/
    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L1', newValue);
						}
					}
    		}, {
    			fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
    			name: 'TXTLV_L2',
    			xtype: 'uniCombobox' ,
    			store: Ext.data.StoreManager.lookup('itemLeve2Store') , 
    			child: 'TXTLV_L3',
/*    			allowBlank:false,
				holdable: 'hold',*/
    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L2', newValue);
						}
					}
    		},{
		 		fieldLabel: '구매요청일',
		 		xtype: 'uniDatefield',
		 		name: 'ORDER_REQ_DATE',
		 		value: UniDate.get('today'),
/*		 		allowBlank:false,
				holdable: 'hold',*/
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ORDER_REQ_DATE', newValue);
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201',
/*				allowBlank:false,
				holdable: 'hold',*/
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			}]
		}],setAllFieldsReadOnly: function(b) {	
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
						//this.mask();
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
  					//this.unmask();
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
  		},		

		fnCreditCheck: function() {
			if(BsaCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
				if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
					alert('<t:message code="unilite.msg.sMS284" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
					return false;
				}
			}
			return true;
		},
		setLoadRecord: function(record)	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
    });		// End of var masterForm = Unilite.createSearchForm('searchForm',{    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DEPT', {
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
				valueFieldName:'DEPT_CODE',
		    	textFieldName:'DEPT_NAME',
				valueFieldWidth: 85,
				textFieldWidth: 150,
/*				allowBlank: false,
				holdable: 'hold',*/
				colspan: 2,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							
							masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
								
								masterForm.setValue('DEPT_CODE', '');
								masterForm.setValue('DEPT_NAME', '');
							}
				}
			}),{
		        fieldLabel: '매출기간',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'SALE_DATE_FR',
		        endFieldName: 'SALE_DATE_TO',
/*		        allowBlank: false,
			//	holdable: 'hold',
*/		        width: 315,
		        startDate: UniDate.get('yesterday'),
		        endDate: UniDate.get('today'),
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(masterForm) {
							masterForm.setValue('SALE_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(masterForm) {
				    		masterForm.setValue('SALE_DATE_TO',newValue);	
				    	}
				    }
			},{
    			fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
    			name: 'TXTLV_L1',
    			xtype: 'uniCombobox',
    			store: Ext.data.StoreManager.lookup('itemLeve1Store'),
    			child: 'TXTLV_L2',
/*    			allowBlank:false,
				holdable: 'hold',*/
    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('TXTLV_L1', newValue);
						}
					}
    		}, {
    			fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
    			name: 'TXTLV_L2',
    			xtype: 'uniCombobox' ,
    			store: Ext.data.StoreManager.lookup('itemLeve2Store') , 
    			child: 'TXTLV_L3',
/*    			allowBlank:false,
				holdable: 'hold',*/
    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('TXTLV_L2', newValue);
						}
					}
    		},{
		 		fieldLabel: '구매요청일',
		 		xtype: 'uniDatefield',
		 		name: 'ORDER_REQ_DATE',
		 		value: UniDate.get('today'),
/*		 		allowBlank:false,
				holdable: 'hold',*/
		 		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('ORDER_REQ_DATE', newValue);
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M201',
/*				allowBlank:false,
				holdable: 'hold',*/
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('ORDER_PRSN', newValue);
					}
				}
			}]
		,setAllFieldsReadOnly: function(b) {	
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
						//this.mask();
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
  					//this.unmask();
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
  		},
  		setLoadRecord: function(record)	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
  
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('mpo050ukrvGrid', {
    	region: 'center' ,
        layout: 'fit',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        /*tbar: [{
			xtype: 'splitbutton',
           	itemId:'orderTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'otherorderBtn',
					text: '타발주참조',
					handler: function() {
						openOtherOrderWindow();
					}
				}, {
					itemId: 'excelBtn',
					text: '엑셀참조',
		        	handler: function() {
			        		openExcelWindow();
			        }
				}]
			})
		}],  */
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns: [
        	{dataIndex:'DIV_CODE'					, width: 100 ,hidden: true},
        	{dataIndex:'ITEM_LEVEL1'				, width: 120 },
        	{dataIndex:'ITEM_LEVEL2'				, width: 120 },
        	
        	{dataIndex:'ITEM_CODE'	 				, width: 100},
        	{dataIndex:'ITEM_NAME'	 				, width: 140 },
        	{dataIndex:'AUTHOR1'	 				, width: 100 },
        	{dataIndex:'PUBLISHER'	 				, width: 100 },
        	{dataIndex:'ITEM_LEVEL3'				, width: 100 },
        	{dataIndex:'SALE_CUSTOM_CODE'	 		, width: 100 },
        	{dataIndex:'PUB_DATE'	 				, width: 100 },
        	{dataIndex:'BOOK_P'	 					, width: 100 },
        	{dataIndex:'SALE_Q'	 					, width: 100},
        	{dataIndex:'SALE_AMT_O'					, width: 100 },
        	{dataIndex:'STOCK_Q'					, width: 100 },
        	{dataIndex:'ORDER_REQ_Q'				, width: 100 },
        	{dataIndex:'ORDER_STATUS'				, width: 100 },
        	{dataIndex:'REMARK'		 				, width: 220 },
        	
        	
        	{dataIndex:'BILL_NUM'	 				, width: 50 ,hidden: true},
        	{dataIndex:'ORDER_REQ_DATE'				, width: 50 ,hidden: true},
        	{dataIndex:'DEPT_CODE'					, width: 50 ,hidden: true},
        	{dataIndex:'ORDER_PRSN_CODE'	 		, width: 50 ,hidden: true},
        	{dataIndex:'POS_NO'						, width: 50 ,hidden: true},
        	{dataIndex:'COMP_CODE'	 				, width: 50 ,hidden: true},
        	{dataIndex:'INSERT_DB_USER'				, width: 50 ,hidden: true},
        	{dataIndex:'INSERT_DB_TIME'				, width: 50 ,hidden: true},
        	{dataIndex:'UPDATE_DB_USER'				, width: 50 ,hidden: true},
        	{dataIndex:'UPDATE_DB_TIME'				, width: 50 ,hidden: true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
      			if(!e.record.phantom){
      				if (UniUtils.indexOf(e.field, 
      						['DIV_CODE','ITEM_LEVEL1','ITEM_LEVEL2','ITEM_CODE','ITEM_NAME','AUTHOR1','PUBLISHER','ITEM_LEVEL3',
      						 'SALE_CUSTOM_CODE','SALE_CUSTOM_CODE','PUB_DATE','BOOK_P','SALE_Q','SALE_AMT_O','STOCK_Q',
      						 'ORDER_STATUS','BILL_NUM','ORDER_REQ_DATE','DEPT_CODE','ORDER_PRSN_CODE','POS_NO','COMP_CODE',
      						 'INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME']))
      					return false;
      			}
        	}
        }
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
			masterForm  	
		],	
		id: 'mpo050ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			var orderNo = masterForm.getValue('BILL_NUM');
			if(Ext.isEmpty(orderNo)) {
				directMasterStore1.loadStoreRecords();	
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
			
			detailGrid.createRow(r, null, detailGrid.getStore().getCount() - 1);
			masterForm.setAllFieldsReadOnly(true);
			
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
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
				if(selRow.get('INSPEC_Q') > 1)
				{
					alert('<t:message code="unilite.msg.sMM435"/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
			}
		},
		setDefault: function() {
			masterForm.setValue('DIV_CODE','01');
			
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);	
        	
		},
		checkForNewDetail:function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('BILL_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			
			/**
			 * 여신한도 확인
			 */ 
			if(!masterForm.fnCreditCheck())	{
				return false;
			}
			
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});		// End of Unilite.Main({
};
</script>
