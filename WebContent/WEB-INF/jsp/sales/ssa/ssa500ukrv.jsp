<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa500ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa500ukrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->		
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세구분-->
	<t:ExtComboStore comboType="AU" comboCode="B030"/> 	<!-- 세액포함여부 -->
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

function appMain() {     
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'ssa500ukrvService.selectDetailList',
			update: 'ssa500ukrvService.updateDetail',
			create: 'ssa500ukrvService.insertDetail',
			destroy: 'ssa500ukrvService.deleteDetail',
			syncAll: 'ssa500ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('ssa500ukrvModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'					,text: 'COMP_CODE'			,type: 'string', defaultValue: UserInfo.compCode, allowBlank: false},
	    	{name: 'DIV_CODE'					,text: '<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string', comboType: 'BOR120', allowBlank: false},
		    {name: 'BILL_NUM'					,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'				,type: 'string'},
		    {name: 'COLLECT_NUM'				,text: '<t:message code="system.label.sales.collectionno" default="수금번호"/>'				,type: 'string'},
		    {name: 'RECEIPT_NO'					,text: '접수번호'				,type: 'string'},
		    {name: 'BILL_SEQ'					,text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'int', defaultValue: 1},
		    {name: 'BILL_TYPE'					,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'				,type: 'string',comboType:'AU', comboCode: 'S024', defaultValue: '10', allowBlank: false},
	    	{name: 'SALE_DATE'					,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'				,type: 'uniDate', allowBlank: false},
		    {name: 'ORDER_TYPE'					,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				,type: 'string',comboType:'AU', comboCode: 'S002', defaultValue: 20, allowBlank: false},
		    {name: 'PURCHASE_CUSTOM_CODE'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string', allowBlank: false},
		    {name: 'PURCHASE_CUSTOM_NAME'		,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				,type: 'string'},
		    {name: 'MONEY_UNIT'					,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'				,type: 'string',comboType:'AU', comboCode: 'B004', defaultValue: 'KRW', displayField: 'value', allowBlank: false},
		    {name: 'CUST_TAX_TYPE'				,text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'			,type: 'string',comboType:'AU', comboCode: 'B030', allowBlank: false},//BCM100T 거래처의 포함,별도
		    {name: 'EXCHG_RATE_O'				,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'					,type: 'uniER', defaultValue: 1, allowBlank: false},
		    {name: 'INOUT_TYPE_DETAIL'			,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				,type: 'string', defaultValue: '10', allowBlank: false},
		    {name: 'ITEM_CODE'					,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string', allowBlank: false},
		    {name: 'ITEM_NAME'					,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
		 	{name: 'SALE_UNIT'					,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				,type: 'string', allowBlank: false},
		    {name: 'TRANS_RATE'					,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'    				,type: 'uniQty', defaultValue: 1, allowBlank: false},
		    {name: 'TAX_TYPE'					,text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'				,type: 'string',comboType:'AU', comboCode: 'B059', allowBlank: false},//BPR100T 품목의 과세,면세
			{name: 'SALE_LOC_AMT_I'				,text: '원화합계'				,type: 'uniPrice'},
		    {name: 'SALE_AMT_O'					,text: '<t:message code="system.label.sales.amount" default="금액"/>'					,type: 'uniPrice'},		    
		    {name: 'TAX_AMT_O'					,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'				,type: 'uniPrice'},
		    {name: 'ORDER_O_TAX_O'				,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'					,type: 'uniPrice'},
		    {name: 'PRICE_YN'					,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				,type: 'string', defaultValue: '1', allowBlank: false},
		    {name: 'WH_CODE'					,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'					,type: 'string', allowBlank: false},
		    {name: 'DEPT_CODE'					,text: '<t:message code="system.label.sales.department" default="부서"/>'				,type: 'string', allowBlank: false},
		    {name: 'DEPT_NAME'					,text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'				,type: 'string'},
		    {name: 'RATING_TYPE'				,text: '요율구분'				,type: 'string', allowBlank: false},	//TEMPC_01 
		    {name: 'CONSIGNMENT_RATE'			,text: '수수료/율'				,type: 'string', allowBlank: false},	//TEMPN_01
		    {name: 'CASH_AMT_O'					,text: '현금매출'				,type: 'uniPrice'},						//TEMPN_02
		    {name: 'CARD_AMT_O'					,text: '카드매출'				,type: 'uniPrice'},						//TEMPN_03
		    {name: 'SALE_AMT'					,text: '외상매출'				,type: 'uniPrice', editable: false},						
		    {name: 'SALE_CUSTOM_CODE'			,text: '외상거래처'				,type: 'string', editable: false},						
		    {name: 'SALE_CUSTOM_NAME'			,text: '외상거래처명'			,type: 'string', editable: false},						
		    {name: 'CONSIGNMENT_FEE'			,text: '수수료'				,type: 'uniPrice'},
		    {name: 'SALE_PRSN'					,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				,type: 'string',comboType:'AU', comboCode: 'S010', defaultValue: '01'},
		    {name: 'SALE_Q'						,text: '<t:message code="system.label.sales.qty" default="수량"/>'					,type: 'uniQty', defaultValue: 1},
		    {name: 'SALE_P'						,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
		    {name: 'CREATE_LOC'					,text: 'CREATE_LOC'			,type: 'string', defaultValue: '1'},
		    {name: 'TAX_CALC_TYPE'				,text: 'TAX_CALC_TYPE'		,type: 'string', defaultValue: '1'},  
		    {name: 'WON_CALC_BAS'				,text: 'WON_CALC_BAS'		,type: 'string', defaultValue: '3'},  
		    {name: 'REMARK'						,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					,type: 'string'},
			{name: 'INSERT_DB_USER'      		,text: 'INSERT_DB_USER'    	,type: 'string', defaultValue: UserInfo.userID},		    
		    {name: 'INSERT_DB_TIME'      		,text: 'INSERT_DB_TIME'    	,type: 'string'},
		    {name: 'UPDATE_DB_USER'      		,text: 'UPDATE_DB_USER'    	,type: 'string', defaultValue: UserInfo.userID}, 
			{name: 'UPDATE_DB_TIME'      		,text: 'UPDATE_DB_TIME'    	,type: 'string'},
			{name: 'CASH_YN'      				,text: 'CASH_YN'    		,type: 'string'}
		]
	}); //End of Unilite.defineModel('ssa500ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ssa500ukrvMasterStore1',{
		model: 'ssa500ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true	,		// 수정 모드 사용 
            deletable: true,		// 삭제 가능 여부
            allDeletable: true,		// 전체 삭제 가능 여부
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();	
			if(panelSearch.isValid())	{				
				console.log( param );
				this.load({
					params : param
				});
			}
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
					config = {
						params: [paramMaster],
						success: function(batch, option) {							
							UniAppManager.setToolbarButtons('save', false);							
							if(directMasterStore.getCount() == 0){
								UniAppManager.app.onResetButtonDown();
							}else{
								UniAppManager.app.onQueryButtonDown();
							}
						 } 
					};
				this.syncAllDirect(config);
			}else{
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}			
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
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
		    	fieldLabel: '매출일(조회)'
				,xtype: 'uniDateRangefield'
				,startFieldName: 'SALE_DATE_FR'
				,endFieldName: 'SALE_DATE_TO'		
				,width:315
				,onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('SALE_DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);
			    	}
			    }
			},Unilite.popup('COMMISSION_DIV_PUMOK',{
	        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
	        	listeners: {
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				}
		   }), {
		    	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox',
		    	comboType:'BOR120',
		    	allowBlank:false,
		    	holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				} 
	    	},{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),				
				name: 'SALE_DATE',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALE_DATE', newValue);
					}
				}
			}/*,{
				fieldLabel: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
				name: 'TAX_TYPE',
				xtype: 'uniRadiogroup',
				comboType: 'AU',
				comboCode: 'B030',
				width: 235,
				value: '1',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelResult.setValue('TAX_TYPE',newValue.TAX_TYPE);
					}
				}
			}*/]
		}],
	    setAllFieldsReadOnly: function(b) {	////readOnly 안먹음..
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
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
	    	fieldLabel: '매출일(조회)'
			,xtype: 'uniDateRangefield'
			,startFieldName: 'SALE_DATE_FR'
			,endFieldName: 'SALE_DATE_TO'		
			,width:315			
			,onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('SALE_DATE_FR',newValue);					
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('SALE_DATE_TO',newValue);
		    	}
		    }
		},Unilite.popup('COMMISSION_DIV_PUMOK',{
        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
        	valueFieldName: 'ITEM_CODE', 
			textFieldName: 'ITEM_NAME', 
			colspan: 2,
        	listeners: {
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				},
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
				}
			}
	   }), {
	    	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox',
	    	comboType:'BOR120',
	    	allowBlank:false,
	    	holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			} 
    	},{
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype: 'uniDatefield',
			value: UniDate.get('today'),				
			name: 'SALE_DATE',
			holdable: 'hold',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_DATE', newValue);
				}
			}
		}/*,{
			fieldLabel: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',
			name: 'TAX_TYPE',
			xtype: 'uniRadiogroup',
			comboType: 'AU',
			comboCode: 'B030',
			width: 235,
			value: '1',
			holdable: 'hold',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {				
					panelSearch.setValue('TAX_TYPE',newValue.TAX_TYPE);
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
//	   					var labelText = ''
//	   	
//						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
//	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
//	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
//	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
//	   					}
//	
//					   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
  		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa500ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        uniOpt: {
    		useLiveSearch: true,
			useMultipleSorting: true,
			expandLastColumn: false,
			state: {
				useState: false,   //그리드 설정 (우측)버튼 사용 여부
				useStateList: false  //그리드 설정 (죄측)목록 사용 여부
			}
        },
    	store: directMasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns: [
        	{dataIndex: 'COMP_CODE'					, width: 90, hidden: true},
			{dataIndex: 'SALE_DATE'					, width: 90, locked: true},
        	{dataIndex: 'BILL_NUM'					, width: 120, locked: true },
        	{dataIndex: 'COLLECT_NUM'				, width: 120, locked: true },
        	{dataIndex: 'RECEIPT_NO'				, width: 120, locked: true },
        	{dataIndex: 'BILL_SEQ'					, width: 50, locked: true, hidden: true},
			{dataIndex: 'DIV_CODE'					, width: 155},
			{dataIndex: 'ITEM_CODE'         		, width: 110, locked: true,
				editor: Unilite.popup('COMMISSION_DIV_PUMOK_G', {		
			 	 				textFieldName: 'ITEM_CODE',
			 	 				DBtextFieldName: 'ITEM_CODE',
//			 	 				extParam: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode, POPUP_TYPE: 'GRID_CODE'},
								autoPopup: true,
				 				listeners: {'onSelected': {
													fn: function(records, type) {
										                    console.log('records : ', records);
										                     Ext.each(records, function(record,i) {		
										                    	var param = {
																	"DIV_CODE": panelSearch.getValue('DIV_CODE'),
																	"ITEM_CODE": record['ITEM_CODE']
																};
											        			ssa500ukrvService.getCommission(param, function(provider, response){	
																	if(!Ext.isEmpty(provider)){
																		record.ITEM_CODE     = provider['ITEM_CODE'];
																		record.ITEM_NAME     = provider['ITEM_NAME'];
																		record.DEPT_CODE     = provider['DEPT_CODE'];
																		record.DEPT_NAME     = provider['DEPT_NAME'];
																		record.RATING_TYPE     = provider['RATING_TYPE'];
																		record.CONSIGNMENT_RATE     = provider['CONSIGNMENT_RATE'];
																		record.PURCHASE_CUSTOM_CODE   = provider['PURCHASE_CUSTOM_CODE'];
																		record.PURCHASE_CUSTOM_NAME   = provider['PURCHASE_CUSTOM_NAME'];
																		record.CUST_TAX_TYPE = provider['CUST_TAX_TYPE'];
																		record.TAX_CALC_TYPE = provider['TAX_CALC_TYPE'];
																		record.WON_CALC_BAS  = provider['WON_CALC_BAS'];
																		if(i==0) {
																			masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
													        			} else {
													        				UniAppManager.app.onNewDataButtonDown();
													        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
													        			}																		
																	}
																});
											        			
															}); 
													},
													scope: this
											},
											'onClear': function(type) {
//												masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
												var grdRecord = masterGrid.uniOpt.currentRecord
												grdRecord.set("ITEM_CODE", '');
												grdRecord.set("ITEM_NAME", '');
								       			grdRecord.set("DEPT_CODE", '');
												grdRecord.set("DEPT_NAME", '');
												grdRecord.set("RATING_TYPE", '');
												grdRecord.set("CONSIGNMENT_RATE", '');
//												grdRecord.set("SALE_CUSTOM_CODE", '');
//												grdRecord.set("SALE_CUSTOM_NAME", ''); 
											},
											applyextparam: function(popup){
												var record = masterGrid.getSelectedRecord();
												var divCode = record.get('DIV_CODE');
												popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
											}
				 				}
					 })
			},
			{dataIndex: 'ITEM_NAME'         	,		 width: 160, locked: true,
				editor: Unilite.popup('COMMISSION_DIV_PUMOK_G', {
//			 		  				extParam: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode},
									autoPopup: true,
									listeners: {'onSelected': {
													fn: function(records, type) {
										                    console.log('records : ', records);
										                     Ext.each(records, function(record,i) {		
										                    	var param = {
																	"DIV_CODE": panelSearch.getValue('DIV_CODE'),
																	"ITEM_CODE": record['ITEM_CODE']
																};
											        			ssa500ukrvService.getCommission(param, function(provider, response){	
																	if(!Ext.isEmpty(provider)){
																		record.ITEM_CODE     = provider['ITEM_CODE'];
																		record.ITEM_NAME     = provider['ITEM_NAME'];
																		record.DEPT_CODE     = provider['DEPT_CODE'];
																		record.DEPT_NAME     = provider['DEPT_NAME'];
																		record.RATING_TYPE     = provider['RATING_TYPE'];
																		record.CONSIGNMENT_RATE     = provider['CONSIGNMENT_RATE'];
																		record.PURCHASE_CUSTOM_CODE   = provider['PURCHASE_CUSTOM_CODE'];
																		record.PURCHASE_CUSTOM_NAME   = provider['PURCHASE_CUSTOM_NAME'];
																		record.CUST_TAX_TYPE = provider['CUST_TAX_TYPE'];
																		record.TAX_CALC_TYPE = provider['TAX_CALC_TYPE'];
																		record.WON_CALC_BAS  = provider['WON_CALC_BAS'];
																		if(i==0) {
																			masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
													        			} else {
													        				UniAppManager.app.onNewDataButtonDown();
													        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
													        			}																		
																	}
																});
											        			
															}); 
													},
													scope: this
											},
											'onClear': function(type) {
//												masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
												var grdRecord = masterGrid.uniOpt.currentRecord
												grdRecord.set("ITEM_CODE", '');
												grdRecord.set("ITEM_NAME", '');
								       			grdRecord.set("DEPT_CODE", '');
												grdRecord.set("DEPT_NAME", '');
												grdRecord.set("RATING_TYPE", '');
												grdRecord.set("CONSIGNMENT_RATE", '');
//												grdRecord.set("SALE_CUSTOM_CODE", '');
//												grdRecord.set("SALE_CUSTOM_NAME", ''); 
											},
											applyextparam: function(popup){
												var record = masterGrid.getSelectedRecord();
												var divCode = record.get('DIV_CODE');
												popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
											}
									}
					})
			},
			{dataIndex: 'PURCHASE_CUSTOM_CODE'		, width: 70},
			{dataIndex: 'PURCHASE_CUSTOM_NAME'		, width: 140},
        	{dataIndex: 'DEPT_CODE'				, width:100	
				  ,'editor' : Unilite.popup('DEPT_G',{  textFieldName:'DEPT_CODE',  textFieldWidth:100, DBtextFieldName: 'TREE_CODE',
													autoPopup: true,
													listeners: {'onSelected': {
					 								fn: function(records, type) {
					 									var grdRecord = masterGrid.uniOpt.currentRecord;
					 									grdRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
							                    		grdRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
					 								},
					 								scope: this
					 							},
					 							'onClear': function(type) {
													var grdRecord = masterGrid.uniOpt.currentRecord;
			                						grdRecord.set('DEPT_CODE','');
							                    	grdRecord.set('DEPT_NAME','');
					 							}
					 				}
								})
				},
			{dataIndex: 'DEPT_NAME'				, width:170	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }
				  ,'editor' : Unilite.popup('DEPT_G',{textFieldName:'DEPT_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME',
												autoPopup: true,
												listeners: {'onSelected': {
					 								fn: function(records, type) {
					 									var grdRecord = masterGrid.uniOpt.currentRecord;
					 									grdRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
							                    		grdRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
					 								},
					 								scope: this
					 							},
					 							'onClear': function(type) {
					 								var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('DEPT_CODE','');
							                    	grdRecord.set('DEPT_NAME','');
					 							}
					 				}
								})
				 },
			{dataIndex: 'RATING_TYPE'				, width: 120, hidden: true},
			{dataIndex: 'CONSIGNMENT_RATE'			, width: 90, align: 'right',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('RATING_TYPE') == '1'){
						return val + '%';
					}else{
						return Ext.util.Format.number(val,'0,000');
					}
    		}},
			{dataIndex: 'CASH_AMT_O'				, width: 90,tdCls:'x-change-cell1', summaryType: 'sum'},
			{dataIndex: 'CARD_AMT_O'				, width: 90,tdCls:'x-change-cell1', summaryType: 'sum'},
			{dataIndex: 'SALE_AMT'					, width: 90, summaryType: 'sum'},
			{dataIndex: 'SALE_CUSTOM_CODE'				, width: 70},
			{dataIndex: 'SALE_CUSTOM_NAME'				, width: 140},
			{dataIndex: 'CONSIGNMENT_FEE'			, width: 90,tdCls:'x-change-cell2', summaryType: 'sum'},
			{dataIndex: 'SALE_AMT_O'				, width: 90, summaryType: 'sum'},			
			{dataIndex: 'TAX_AMT_O'					, width: 90, summaryType: 'sum'},
			{dataIndex: 'ORDER_O_TAX_O'				, width: 90, summaryType: 'sum'},
			{dataIndex: 'TAX_TYPE'					, width: 70, align: 'center'},
			{dataIndex: 'CUST_TAX_TYPE'				, width: 90},
			{dataIndex: 'BILL_TYPE'					, width: 90},
			{dataIndex: 'MONEY_UNIT'				, width: 90, hidden: true},
			{dataIndex: 'EXCHG_RATE_O'				, width: 60, hidden: true},
			{dataIndex: 'ORDER_TYPE'				, width: 90, hidden: true},
			{dataIndex: 'SALE_PRSN'					, width: 60, hidden: true},
			{dataIndex: 'SALE_Q'					, width: 60, hidden: true},
			{dataIndex: 'SALE_P'					, width: 60, hidden: true},
			{dataIndex: 'TRANS_RATE'				, width: 90, hidden: true},
			{dataIndex: 'PRICE_YN'					, width: 90, hidden: true},
			{dataIndex: 'CUST_TAX_TYPE'				, width: 90, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL'			, width: 90, hidden: true},
			{dataIndex: 'SALE_UNIT'					, width: 90, hidden: true},
			{dataIndex: 'SALE_LOC_AMT_I'			, width: 90, hidden: true},
			{dataIndex: 'WH_CODE'					, width: 90, hidden: true},
			{dataIndex: 'CREATE_LOC'				, width: 90, hidden: true},
			{dataIndex: 'TAX_CALC_TYPE'				, width: 90, hidden: true},
			{dataIndex: 'WON_CALC_BAS'				, width: 90, hidden: true},
			{dataIndex: 'REMARK'					, width: 120}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
//				if(!Ext.isEmpty(e.record.get('RECEIPT_NO'))){
//					Unilite.messageBox('DHL접수 등록된 건은 수정 할수 없습니다.');
//					return false;
//				}
				if(e.record.phantom){
					if (UniUtils.indexOf(e.field,['ITEM_CODE', 'ITEM_NAME', 'BILL_TYPE', 'SALE_DATE','CASH_AMT_O', 'CARD_AMT_O', 'DEPT_CODE', 'DEPT_NAME'])){
						return true;	//품목코드,품목명, 부가세유형, 매출일
					}else{
						return false;
					}
				}else{
					if(UniUtils.indexOf(e.field, ['CASH_AMT_O'])){
						if(e.record.get('CASH_YN') == "N"){
							return false;
						}
						
					}else if(UniUtils.indexOf(e.field, ['CARD_AMT_O'])){
						if(e.record.get('CASH_YN') == "Y"){
							return false;
						}
					}else{
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
//			var isSuccess = this.checkDupleCode(record);
							//masterGrid.deleteSelectedRow();	
//			if(!isSuccess) directMasterStore.remove(grdRecord);	//품목코드 중복된 레코드는 제거하고 뿌려줌..
//       		if(dataClear) {
//   		grdRecord.set("ITEM_CODE", '');
//			grdRecord.set("ITEM_NAME", '');
//   		grdRecord.set("DEPT_CODE", '');
//			grdRecord.set("DEPT_NAME", '');
//			grdRecord.set("RATING_TYPE", '');
//			grdRecord.set("CONSIGNMENT_RATE", '');
//			grdRecord.set("SALE_CUSTOM_CODE", '');
//			grdRecord.set("SALE_CUSTOM_NAME", ''); 
//       		} else {       			
   			grdRecord.set("ITEM_CODE", record['ITEM_CODE']);
			grdRecord.set("ITEM_NAME", record['ITEM_NAME']);
			grdRecord.set("DEPT_CODE", record['DEPT_CODE']);
			grdRecord.set("DEPT_NAME", record['DEPT_NAME']);
			grdRecord.set("RATING_TYPE", record['RATING_TYPE']);
			grdRecord.set("CONSIGNMENT_RATE", record['CONSIGNMENT_RATE']);
			grdRecord.set("SALE_CUSTOM_CODE", record['SALE_CUSTOM_CODE']);
			grdRecord.set("SALE_CUSTOM_NAME", record['SALE_CUSTOM_NAME']);
			grdRecord.set("CUST_TAX_TYPE", record['CUST_TAX_TYPE']);
			grdRecord.set("TAX_CALC_TYPE", record['TAX_CALC_TYPE']);
			grdRecord.set("WON_CALC_BAS", record['WON_CALC_BAS']);	
			grdRecord.set("SALE_UNIT", record['SALE_UNIT']);
			grdRecord.set("TAX_TYPE", record['TAX_TYPE']);
			grdRecord.set("WH_CODE", record['WH_CODE']);
			grdRecord.set("PURCHASE_CUSTOM_CODE", record['PURCHASE_CUSTOM_CODE']);
			grdRecord.set("PURCHASE_CUSTOM_NAME", record['PURCHASE_CUSTOM_NAME']);
			if(record['RATING_TYPE'] == "2"){
				grdRecord.set("CONSIGNMENT_FEE", record['CONSIGNMENT_RATE']);
				UniAppManager.app.fnTaxCalculate(grdRecord, record['CONSIGNMENT_RATE']);
				
			}
			
//       		}
		},          
        checkDupleCode: function(record) {
        	var isSuccess = true;
        	var totRecords = directMasterStore.data.items;				//그리드의 모든 레코드
//        	var duplRecord = new Array();								
//        	var duReci = 0;
        	
        	Ext.each(totRecords, function(record1,i){
    			if( record1.get('ITEM_CODE') == record['ITEM_CODE'] && !Ext.isEmpty(record1.get('ITEM_NAME'))){
        			isSuccess = false;
					return isSuccess;
        		}
		    });
		    if(isSuccess){
		    	return true;
		    }else{
		    	return false;
		    }
        }
    });	//End of   var masterGrid = Unilite.createGrid('ssa500ukrvGrid1', {

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
		id: 'ssa500ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('SALE_DATE', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('today'));
        	panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
        	
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelResult.setValue('DEPT_NAME', UserInfo.deptName);
        	panelResult.setValue('SALE_DATE', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR', UniDate.get('today'));
        	panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('newData','reset',true);
		},
		onQueryButtonDown : function() {	
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}			
			directMasterStore.loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.setAllFieldsReadOnly(true)){
					return false;
			}
//			var sortSeq = directMasterStore.max('SORT_SEQ');
//        		if(!sortSeq) sortSeq = 1;
//        		else  sortSeq += 1;
			 var r = {
//			 	SORT_SEQ: sortSeq
			 	DIV_CODE : panelSearch.getValue('DIV_CODE'),	
				SALE_DATE : panelSearch.getValue('SALE_DATE')	
	        };
	        masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
//			masterGrid.createRow(r);
			panelResult.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
				
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var counter1 = 0;
			var counter2 = 0;
			records = directMasterStore.data.items;
			Ext.each(records, function(record,i) {
				if(record.get("CASH_AMT_O") == 0  && record.get("CARD_AMT_O")  == 0 && record.get("SALE_AMT") == 0)	{
						counter1 += 1;
						return false;
				}
				if(record.get("RATING_TYPE") == '2'){
					if(record.get("CONSIGNMENT_FEE") != (record.get("CASH_AMT_O") + record.get("CARD_AMT_O"))){
						counter2 += 1;
						return false;
					}				
				}
			});
			if(counter1 == 0 && counter2 == 0){
					directMasterStore.saveStore(config);
			}else if(counter1 != 0){
				Unilite.messageBox('매출금액을 입력해 주세요.')
				return false;
			}else if(counter2 != 0){
				Unilite.messageBox('매출금액과 수수료금액이 맞지 않습니다.')
				return false;
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				var record = masterGrid.getSelectedRecord();
				var param = {"DIV_CODE": record.get("DIV_CODE"), "RECEIPT_NO": record.get("RECEIPT_NO")}
				dhl100ukrvService.existBillNumCheck(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){	//픽업 등록되어 있을시 수정 불가
						Unilite.messageBox('<t:message code="system.message.sales.message139" default="매출번호 또는 수금번호가 등록된 건은 삭제할수 없습니다.재조회 후 작업을 진행하세요."/>');
						return false;
					}else{
						masterGrid.deleteSelectedRow();
					}
				});
			}
		},
		 onDeleteAllButtonDown: function() {
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						
						/*---------삭제전 로직 구현 끝----------*/
						
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
        fnOrderAmtCal: function(rtnRecord, fieldName, nValue) {
        	var cashAmtO =    fieldName=='CASH_AMT_O' 	    ? nValue : Unilite.nvl(rtnRecord.get('CASH_AMT_O'),0);
        	var cardAmtO =    fieldName=='CARD_AMT_O' 	    ? nValue : Unilite.nvl(rtnRecord.get('CARD_AMT_O'),0);
        	var saleAmt  = 	  rtnRecord.get('SALE_AMT');
    		dOrderO = cashAmtO + cardAmtO + saleAmt;
			this.fnTaxCalculate(rtnRecord, dOrderO);
        },
        fnTaxCalculate: function(rtnRecord, dOrderO, taxType) {
			var sTaxType 	  = Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;			//1.과세, 2.면세
			var sTaxInoutType = rtnRecord.get('CUST_TAX_TYPE');										//1.별도, 2.포함
			var dVatRate 	  = 10;
			
			var dOrderAmtO = 0;
			var dTaxAmtO = 0;
			var dAmountI = dOrderO;
			var dTemp = 0;
			var sWonCalBas = rtnRecord.get('WON_CALC_BAS');
			
			if(sTaxInoutType=="1") {	//별도
				dOrderAmtO = dOrderO;
				dTaxAmtO = dOrderO * dVatRate / 100
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderAmtO, sWonCalBas);
				
				if(UserInfo.currency == "CN"){
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, '3');
				}else{
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas);
				}
			}else if(sTaxInoutType=="2") {	//포함
				dAmountI = dOrderO;
				if(UserInfo.currency == "CN"){
					dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '3');
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, '3')
				}else{
					dTemp = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO = UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas);
				}
				dOrderAmtO = UniSales.fnAmtWonCalc(dAmountI - dTaxAmtO, sWonCalBas);
			}
			if(sTaxType == "2")	{	//면세
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, sWonCalBas ); 
				dTaxAmtO = 0;
			}
			if(rtnRecord.get('RATING_TYPE') == '1'){
				var amtSum = dOrderAmtO + dTaxAmtO;	//합계
				var consignment = amtSum * (rtnRecord.get('CONSIGNMENT_RATE') / 100);
				rtnRecord.set('SALE_AMT_O', dOrderAmtO);
				rtnRecord.set('ORDER_O_TAX_O', amtSum);
				rtnRecord.set('TAX_AMT_O', dTaxAmtO);
				rtnRecord.set('SALE_LOC_AMT_I', dOrderAmtO);
				rtnRecord.set('CONSIGNMENT_FEE', consignment);
			}else{
				var amtSum = dOrderAmtO + dTaxAmtO;	//합계
				rtnRecord.set('SALE_AMT_O', dOrderAmtO);
				rtnRecord.set('ORDER_O_TAX_O', amtSum);
				rtnRecord.set('TAX_AMT_O', dTaxAmtO);
				rtnRecord.set('SALE_LOC_AMT_I', dOrderAmtO);
			}
        }
	}); //End of Unilite.Main( {
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;	
			
			switch(fieldName) {
				case "CASH_AMT_O" :		                                     
//					if(newValue < 0 && !Ext.isEmpty(newValue))	{
//						rv = Msg.sMB076;	//양수만 입력 가능합니다.
//						break;
//					}
//					if(!record.phantom){
//						if(newValue == 0 && !Ext.isEmpty(newValue))	{
//							rv = '0이상 입력 가능합니다.';	//양수만 입력 가능합니다.
//							break;
//						}
//					}
					UniAppManager.app.fnOrderAmtCal(record, fieldName, newValue);
					break;                                                  
									
				case "CARD_AMT_O" :		
//					if(newValue < 0 && !Ext.isEmpty(newValue))	{
//						rv = Msg.sMB076;	//양수만 입력 가능합니다.
//						break;
//					}
//					if(!record.phantom){
//						if(newValue == 0 && !Ext.isEmpty(newValue))	{
//							rv = '0이상 입력 가능합니다.';	//양수만 입력 가능합니다.
//							break;
//						}
//					}
					UniAppManager.app.fnOrderAmtCal(record, fieldName, newValue);
					break;				
			}				
			return rv;
		}
	})
};

</script>
