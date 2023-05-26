<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv105ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="biv105ukrv"/> 				<!-- 사업장 -->
	//<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
	<t:ExtComboStore comboType="OU" storeId="whList" />   					<!--창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="YP08"/>	<!-- 매입조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09"/>	<!-- 판매형태 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',
	gsMoneyUnit:		'${gsMoneyUnit}'
};

/*var output ='';
	for(var key in BsaCodeInfo){
 		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	}
	alert(output);*/

var excelWindow;	// 엑셀참조
var outDivCode = UserInfo.divCode;
var query02Load = "1";

function appMain() {

	var sumtypeCell = true;    //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
    if(BsaCodeInfo.gsSumTypeCell =='Y') {
        sumtypeCell = false;
    }

    var sumTypeLot = true;    //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
    if(BsaCodeInfo.gsSumTypeLot =='Y') {
        sumTypeLot = false;
    }

    //창고에 따른 창고cell 콤보load..
    var cbStore = Unilite.createStore('hat510ukrsComboStoreGrid',{
        autoLoad: false,
        uniOpt: {
            isMaster: false         // 상위 버튼 연결
        },
        fields: [
                {name: 'SUB_CODE', type : 'string'},
                {name: 'CODE_NAME', type : 'string'}
                ],
        proxy: {
            type: 'direct',
            api: {
                read: 'salesCommonService.fnRecordCombo'
            }
        },
        loadStoreRecords: function(whCode) {
            var param= masterForm.getValues();
            param.COMP_CODE= UserInfo.compCode;
//            param.DIV_CODE = UserInfo.divCode;
            param.WH_CODE = whCode;
            param.TYPE = 'BSA225T';
            console.log( param );
            this.load({
                params: param
            });
        }
    });

	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'biv105ukrvService.selectMaster1',
			update: 'biv105ukrvService.updateDetail',
			create: 'biv105ukrvService.insertDetail',
			destroy: 'biv105ukrvService.deleteDetail',
			syncAll: 'biv105ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'biv105ukrvService.selectMaster2',
			update: 'biv105ukrvService.updateDetail',
			create: 'biv105ukrvService.insertDetail',
			destroy: 'biv105ukrvService.deleteDetail',
			syncAll: 'biv105ukrvService.saveAll'
		}
	});

	var masterForm = Unilite.createSearchPanel('searchForm', {		// 메인
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
       		defaultType: 'uniTextfield',
	   		items : [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: '01',
				holdable: 'hold',
				child:'WH_CODE',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
            	fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
            	name: 'WH_CODE',
            	xtype: 'uniCombobox',
				holdable: 'hold',
            	store: Ext.data.StoreManager.lookup('whList'),
				allowBlank:false,
				onChange: function(newVal, oldVal) {
       				UniAppManager.app.fnYyyymmSet();
    			},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			}, {
            	fieldLabel: '<t:message code="system.label.inventory.basicyearmonth" default="기초년월"/>',
            	name: 'COUNT_DATE',
            	xtype: 'uniMonthfield',
				holdable: 'hold',
            	allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COUNT_DATE', newValue);
					}
				}
            },
			Unilite.popup('DIV_PUMOK',{ // 20210811 수정: 품목 조회조건 표준화
	        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						panelResult.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME', '');
							masterForm.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						panelResult.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE', '');
							masterForm.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
		   })]
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true);
		        			}
		       			}
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;
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
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		}
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ;
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				value: '01',
				child:'WH_CODE',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			}, {
            	fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
            	name: 'WH_CODE',
            	xtype: 'uniCombobox',
				holdable: 'hold',
            	store: Ext.data.StoreManager.lookup('whList'),
				allowBlank:false,
				onChange: function(newVal, oldVal) {
       				UniAppManager.app.fnYyyymmSet2();
    			},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WH_CODE', newValue);
					}
				}
			}, {
            	fieldLabel: '<t:message code="system.label.inventory.basicyearmonth" default="기초년월"/>',
            	name: 'COUNT_DATE',
				holdable: 'hold',
            	xtype: 'uniMonthfield',
            	//colspan: '2',
            	allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('COUNT_DATE', newValue);
					}
				}
            },
			Unilite.popup('DIV_PUMOK',{ // 20210811 수정: 품목 조회조건 표준화
	        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
	        	listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						masterForm.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME', '');
							masterForm.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						masterForm.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE', '');
							masterForm.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
		   })
		],
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true);
		        			}
		       			}
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;
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
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		}
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ;
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});

	//biv105ukrvs1 Model
	Unilite.defineModel('biv105ukrvs1Model', {		// 메인
	    fields: [{name: 'DIV_CODE' 		 		 ,text:'<t:message code="system.label.inventory.division" default="사업장"/>'			,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', child: 'WH_CODE'},
				 {name: 'WH_NAME' 		 		 ,text:'<t:message code="system.label.inventory.warehouse" default="창고"/>'			,type: 'string'},
				 {name: 'WH_CODE' 		 		 ,text:'<t:message code="system.label.inventory.warehouse" default="창고"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('whList'), child: 'WH_CELL_CODE'},
				 {name: 'ITEM_CODE' 	 		 ,text:'<t:message code="system.label.inventory.item" default="품목"/>'				,type: 'string', allowBlank: false},
				 {name: 'ITEM_NAME' 	 		 ,text:'<t:message code="system.label.inventory.itemname2" default="품명"/>'			,type: 'string'},
				 {name: 'SPEC'		     		 ,text:'<t:message code="system.label.inventory.spec" default="규격"/>'				,type: 'string'},
				 {name: 'STOCK_UNIT' 	 		 ,text:'<t:message code="system.label.inventory.unit" default="단위"/>'				,type: 'string'},
				 {name: 'WH_CELL_CODE'   		 ,text:'<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'	,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','SALE_DIV_CODE']},
				 {name: 'WH_CELL_NAME'   		 ,text:'<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'	,type: 'string'},
				 {name: 'LOT_NO' 		 		 ,text:'<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			,type: 'string', allowBlank: sumTypeLot},
				 {name: 'CUSTOM_CODE' 	 		 ,text:'<t:message code="system.label.inventory.custom" default="거래처"/>'			,type: 'string'},
				 {name: 'CUSTOM_NAME'	 		 ,text:'<t:message code="system.label.inventory.customname" default="거래처명"/>'		,type: 'string'},
//				 {name: 'PURCHASE_TYPE'	 		 ,text:'매입조건'		,type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'YP08'},
//				 {name: 'SALES_TYPE'	 		 ,text:'판매형태'		,type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'YP09'},
//				 {name: 'SALE_P'	 		 	 ,text:'판매가'		,type: 'uniUnitPrice', allowBlank: false},
//				 {name: 'PURCHASE_P'	 		 ,text:'매입가'		,type: 'uniUnitPrice', allowBlank: false},
//				 {name: 'PURCHASE_RATE'	 		 ,text:'매입율'		,type: 'uniPercent', allowBlank: false},
				 {name: 'GOOD_STOCK_Q' 	 		 ,text:'<t:message code="system.label.inventory.goodqty" default="양품수량"/>'			,type: 'uniQty', allowBlank: false},
				 {name: 'BAD_STOCK_Q' 	 		 ,text:'<t:message code="system.label.inventory.defectqty" default="불량수량"/>'		,type: 'uniQty'},
				 {name: 'STOCK_Q' 		 		 ,text:'<t:message code="system.label.base.basicinventoryqty" default="기초재고량"/>'	,type: 'uniQty'},
				 {name: 'AVERAGE_P' 	 		 ,text:'<t:message code="system.label.inventory.averageprice" default="평균단가"/>'	,type: 'uniUnitPrice', allowBlank: false},
				 {name: 'STOCK_I' 		 		 ,text:'<t:message code="system.label.inventory.basicamount" default="기초금액"/>'		,type: 'uniPrice'},
				 {name: 'BASIS_YYYYMM' 	 		 ,text:'<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>'	,type: 'string'},
				 {name: 'UPDATE_DB_USER' 		 ,text:'<t:message code="system.label.inventory.updateuser" default="수정자"/>'		,type: 'string'},
				 {name: 'UPDATE_DB_TIME' 		 ,text:'<t:message code="system.label.inventory.updatedate" default="수정일"/>'		,type: 'uniDate'},
				 {name: 'COMP_CODE'	     		 ,text:'COMP_CODE'	,type: 'string'},
                 {name: 'MONEY_UNIT'             ,text:'<t:message code="system.label.inventory.currencyunit" default="화폐단위"/>'  	,type: 'string'}
			]
	});

	// 엑셀참조
	Unilite.Excel.defineModel('excel.biv105.sheet01', {
	    fields: [
	    	{name: 'DIV_CODE' 		 		 ,text:'<t:message code="system.label.inventory.division" default="사업장"/>'			,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'WH_CODE' 		 		 ,text:'<t:message code="system.label.inventory.warehouse" default="창고"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ITEM_CODE' 	 		 	 ,text:'<t:message code="system.label.inventory.item" default="품목"/>'				,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME' 	 		 	 ,text:'<t:message code="system.label.inventory.itemname2" default="품명"/>'			,type: 'string'},
			{name: 'SPEC'		     		 ,text:'<t:message code="system.label.inventory.spec" default="규격"/>'				,type: 'string'},
			{name: 'STOCK_UNIT' 	 		 ,text:'<t:message code="system.label.inventory.unit" default="단위"/>'				,type: 'string'},
			{name: 'WH_CELL_CODE'   		 ,text:'<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'	,type: 'string'},
			{name: 'WH_CELL_NAME'   		 ,text:'<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'	,type: 'string'},
			{name: 'LOT_NO' 		 		 ,text:'<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			,type: 'string'},
			{name: 'CUSTOM_CODE' 	 		 ,text:'<t:message code="system.label.inventory.custom" default="거래처"/>'			,type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'	 		 ,text:'<t:message code="system.label.inventory.customname" default="거래처명"/>'		,type: 'string', allowBlank: false},
//			{name: 'PURCHASE_TYPE'	 		 ,text:'매입조건'		,type: 'string', allowBlank: false},
//			{name: 'SALES_TYPE'	 		 	 ,text:'판매형태'		,type: 'string', allowBlank: false},
//			{name: 'SALE_P'	 		 		 ,text:'판매가'		,type: 'uniUnitPrice', allowBlank: false},
//			{name: 'PURCHASE_P'	 		 	 ,text:'매입가'		,type: 'uniUnitPrice', allowBlank: false},
//			{name: 'PURCHASE_RATE'	 		 ,text:'매입율'		,type: 'uniPercent', allowBlank: false},
			{name: 'GOOD_STOCK_Q' 	 		 ,text:'<t:message code="system.label.inventory.goodqty" default="양품수량"/>'			,type: 'uniQty', allowBlank: false},
			{name: 'BAD_STOCK_Q' 	 		 ,text:'<t:message code="system.label.inventory.defectqty" default="불량수량"/>'		,type: 'uniQty', allowBlank: false},
			{name: 'STOCK_Q' 		 		 ,text:'<t:message code="system.label.base.basicinventoryqty" default="기초재고량"/>'	,type: 'uniQty'},
			{name: 'AVERAGE_P' 	 		 	 ,text:'<t:message code="system.label.inventory.averageprice" default="평균단가"/>'	,type: 'uniUnitPrice', allowBlank: false},
			{name: 'STOCK_I' 		 		 ,text:'<t:message code="system.label.inventory.basicamount" default="기초금액"/>'		,type: 'uniPrice'},
			{name: 'BASIS_YYYYMM' 	 		 ,text:'<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>'	,type: 'string'},
			{name: 'UPDATE_DB_USER' 		 ,text:'<t:message code="system.label.inventory.updateuser" default="수정자"/>'		,type: 'string'},
			{name: 'UPDATE_DB_TIME' 		 ,text:'<t:message code="system.label.inventory.updatedate" default="수정일"/>'		,type: 'uniDate'},
			{name: 'COMP_CODE'	     		 ,text:'COMP_CODE'	,type: 'string'}
		]
	});

	function openExcelWindow() {

			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUpload';
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'biv105ukrv',
                		extParam: {
                            'PGM_ID'    : 'biv105ukrv'
//                            'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                        },
                        grids: [{
                        		itemId: 'grid01',
                        		title: '<t:message code="system.label.inventory.balancestockinfo" default="기초재고정보"/>',
                        		useCheckbox: false,
                        		model : 'excel.biv105.sheet01',
                        		readApi: 'biv105ukrvService.selectExcelUploadSheet1',
                        		columns: [{dataIndex: 'DIV_CODE' 		 		 	, 		width: 80},
										  {dataIndex: 'WH_CODE' 		 		 	,		width: 66},
										  {dataIndex: 'ITEM_CODE'			        ,   	width: 110,
														editor: Unilite.popup('DIV_PUMOK_G', {
										 	 				textFieldName: 'ITEM_CODE',
										 	 				DBtextFieldName: 'ITEM_CODE',
										 	 				extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
															autoPopup: true,
											 				listeners: {'onSelected': {
																				fn: function(records, type) {
																	                    console.log('records : ', records);
																	                    Ext.each(records, function(record,i) {
																		        			if(i==0) {
																								masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																		        			} else {
																		        				UniAppManager.app.onNewDataButtonDown();
																		        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																		        			}
																						});
																				},
																				scope: this
																		},
																		'onClear': function(type) {
																			masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
																		}
																}
											 })
										},
										{dataIndex: 'ITEM_NAME'			        ,   width: 200,
												editor: Unilite.popup('DIV_PUMOK_G', {
										 		  				extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
																autoPopup: true,
																listeners: {'onSelected': {
																					fn: function(records, type) {
																		                    console.log('records : ', records);
																		                    Ext.each(records, function(record,i) {
																			        			if(i==0) {
																									masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																			        			} else {
																			        				UniAppManager.app.onNewDataButtonDown();
																			        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																			        			}
																							});
																					},
																					scope: this
																			},
																			'onClear': function(type) {
																				masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
																			}
																	}
												})
										  },
										  {dataIndex: 'SPEC'		     		 	,		width: 180 },
										  {dataIndex: 'STOCK_UNIT' 	 		 		,		width: 66 },
										  {dataIndex: 'WH_CELL_CODE'   		 		,		width: 66, hidden: true },
										  {dataIndex: 'WH_CELL_NAME'   		 		,		width: 100, hidden: true },
										  {dataIndex: 'LOT_NO' 		 		 		,		width: 80},
										  {dataIndex: 'CUSTOM_CODE'			        ,   	width: 100,
												editor: Unilite.popup('CUST_G', {
											 		textFieldName: 'CUSTOM_NAME',
											 		DBtextFieldName: 'CUSTOM_NAME',
											 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
													autoPopup: true,
													listeners: {'onSelected': {
															fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																	console.log('record',record);
																	if(i==0) {
																		masterGrid.setCustData(record,false);
																	} else {
																		UniAppManager.app.onNewDataButtonDown();
																		masterGrid.setCustData(record,false);
																	}
																});
															},
															scope: this
														},
														'onClear': function(type) {
															masterGrid.setCustData(null,true);
														}
													}
												})
										  },
										  {dataIndex: 'CUSTOM_NAME'			        ,   width: 170,
												editor: Unilite.popup('CUST_G', {
											 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
													autoPopup: true,
													listeners: {'onSelected': {
															fn: function(records, type) {
													    	    console.log('records : ', records);
															    Ext.each(records, function(record,i) {
																	if(i==0) {
																		masterGrid.setCustData(record,false);
																	} else {
																		UniAppManager.app.onNewDataButtonDown();
																		masterGrid.setCustData(record,false);
																	}
																});
															},
															scope: this
														},
														'onClear': function(type) {
															masterGrid.setCustData(null,true);
														}
													}
												})
										  },
//										  {dataIndex: 'PURCHASE_TYPE' 	 		 	,		width: 100 },
//										  {dataIndex: 'SALES_TYPE'	 	 	 		,		width: 100 },
//										  {dataIndex: 'SALE_P'	 		 	 		,		width: 100 },
//										  {dataIndex: 'PURCHASE_P'	 	 	 		,		width: 100 },
//										  {dataIndex: 'PURCHASE_RATE' 	 		 	,		width: 100 },
										  {dataIndex: 'GOOD_STOCK_Q' 	 		 	,		width: 100 },
										  {dataIndex: 'BAD_STOCK_Q' 	 		 	,		width: 100 },
										  {dataIndex: 'STOCK_Q' 		 		 	,		width: 100, hidden: true },
										  {dataIndex: 'AVERAGE_P' 	 		 		,		width: 100 },
										  {dataIndex: 'STOCK_I' 		 		 	,		width: 100 },
										  {dataIndex: 'BASIS_YYYYMM' 	 		 	,		width: 66, hidden: true },
										  {dataIndex: 'UPDATE_DB_USER' 		 		,		width: 66, hidden: true },
										  {dataIndex: 'UPDATE_DB_TIME' 		 		,		width: 66, hidden: true },
										  {dataIndex: 'COMP_CODE'	     		 	,		width: 66, hidden: true }
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
							/*excelWindow.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
                        	var grid = this.down('#grid01');
                			var records = grid.getSelectionModel().getSelection();
							Ext.each(records, function(record,i){
						        	UniAppManager.app.onNewDataButtonDown();
						        	masterGrid.setExcelData(record.data);
						        	//masterGrid.fnCulcSet(record.data);
						    });
							grid.getStore().remove(records);*/
							excelWindow.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');		///////// 엑셀업로드 최신로직
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
							biv105ukrvService.selectExcelUploadSheet1(param, function(provider, response){
						    	var store = masterGrid.getStore();
						    	var records = response.result;
						    	var countDate = UniDate.getDbDateStr(masterForm.getValue('COUNT_DATE')).substring(0, 6);
//								var monthDate = countDate.substring(0,4) + '.' + countDate.substring(4,6);
								for(var i=0; i<records.length; i++) {
									records[i].BASIS_YYYYMM = countDate;
								}
						    	store.insert(0, records);
						    	console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}

	//directMasterStore
	var directMasterStore = Unilite.createStore('biv105ukrvMasterStore1',{		// 메인
			model: 'biv105ukrvs1Model',
            uniOpt : {
            	isMaster: true,		// 상위 버튼 연결
           	 	editable: true,		// 수정 모드 사용
            	deletable: true,	// 삭제 가능 여부
				allDeletable: true,			// 전체 삭제 가능 여부
	        	useNavi : false		// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy1,
			loadStoreRecords: function(/*provider, response*/) {
				var param= masterForm.getValues();
				param.MONEY_UNIT = BsaCodeInfo.gsMoneyUnit;
				/*var basisDate = provider.BASIS_YYYYMM;
				basisDate = basisDate.substring(0,4) + '.' + basisDate.substring(4,6);*/
				console.log(param);
				this.load({
					params : param
				});
			},
            saveStore: function() {
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);

				var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords();
	       		var toDelete = this.getRemovedRecords();
	       		var list = [].concat(toUpdate, toCreate);
	       		console.log("inValidRecords : ", inValidRecs);
				console.log("list:", list);
				console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

				//1. 마스터 정보 파라미터 구성
				var paramMaster= masterForm.getValues();	//syncAll 수정
				paramMaster.MONEY_UNIT = BsaCodeInfo.gsMoneyUnit;



				if(inValidRecs.length == 0) {
					config = {
						params: [paramMaster],

						success: function(batch, option) {
							//2.마스터 정보(Server 측 처리 시 가공)
							/*var master = batch.operations[0].getResultSet();
							masterForm.setValue("ORDER_NUM", master.ORDER_NUM);*/
							//3.기타 처리
							masterForm.getForm().wasDirty = false;
							masterForm.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
						}
					};
					this.syncAllDirect(config);
				} else {

	                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		var count = masterGrid.getStore().getCount();	// 2번쿼리가 조회될때 newData로 처리
					var whCode = masterForm.getValue('WH_CODE');
					if(count > 0) {
						if(query02Load == "2") {
							/*var COUNTDATE = record.get('BASIS_YYYYMM');
							var YYYYMM = COUNTDATE.substring(0,4) + '.' + COUNTDATE.substring(4,6);
							for(var i=0; i<records.length; i++) {
								records[i].BASIS_YYYYMM = YYYYMM;
							}*/
							directMasterStore.loadStoreRecords();
							query02Load = "1";
						}
					} else {
						query02Load = "2";
						var param= masterForm.getValues();		// callback함수 처리, 레코드생성하면서 insert
			        	biv105ukrvService.selectMaster2(param, function(provider, response) {
			        		var store = masterGrid.getStore();
							var records = response.result;
							var countDate = UniDate.getDbDateStr(masterForm.getValue('COUNT_DATE')).substring(0, 6);
//							var monthDate = countDate.substring(0,4) + '.' + countDate.substring(4,6);
							for(var i=0; i<records.length; i++) {
								records[i].BASIS_YYYYMM = countDate;
							}
							store.insert(0, records);
						});
					}
	           	}
			}
	});	// End of var directMasterStore1

    var masterGrid = Unilite.createGrid('biv105ukrvGrid', {
	layout : 'fit',
        region:'center',
    	uniOpt: {
			expandLastColumn: false,
		 	useRowNumberer: true,
		 	useContextMenu: true
        },
        margin: 0,
         tbar: [{
				itemId: 'excelBtn',
				text: '<div style="color: blue"><t:message code="system.label.inventory.excelrefer" default="엑셀참조"/></div>',
	        	handler: function() {
	        		if(masterForm.setAllFieldsReadOnly(true) == false){
	                    return false;
	                } else {
	                    openExcelWindow();
	                }
		        }
			}],
        store: directMasterStore,
        features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', 	showSummaryRow: false },
    	    {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  		showSummaryRow: false}
    	],
		columns: [{dataIndex: 'DIV_CODE' 		 		 	, 		width: 80, hidden: true},
				  {dataIndex: 'ITEM_CODE'			        ,   	width: 110,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		textFieldName: 'ITEM_CODE',
					 		DBtextFieldName: 'ITEM_CODE',
					 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
								},
								applyextparam: function(popup){
									popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								}
							}
						})
				},
				{dataIndex: 'ITEM_NAME'			        ,   width: 255,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
							    	    console.log('records : ', records);
									    Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
								},
								applyextparam: function(popup){
									popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
								}
							}
						})
				  },
				  {dataIndex: 'SPEC'		     		 	,		width: 150 },
				  {dataIndex: 'STOCK_UNIT' 	 		 		,		width: 66 },
                  {dataIndex: 'WH_CODE'                     ,       width: 150, hidden: true},
				  {dataIndex: 'WH_NAME'                     ,       width: 80, hidden: true},
				  {dataIndex: 'WH_CELL_CODE'   		 		,		width: 90 },
				  {dataIndex: 'WH_CELL_NAME'   		 		,		width: 100, hidden: true },
				  {dataIndex: 'LOT_NO' 		 		 		,		width: 115},
				  {dataIndex: 'CUSTOM_CODE'			        ,   	width: 100,
						editor: Unilite.popup('CUST_G', {
					 		textFieldName: 'CUSTOM_CODE',
					 		DBtextFieldName: 'CUSTOM_CODE',
					 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setCustData(record,false, masterGrid.getSelectedRecord());
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setCustData(null,true, masterGrid.uniOpt.currentRecord);
								}
							}
						})
				  },
				  {dataIndex: 'CUSTOM_NAME'			        ,   width: 170,
						editor: Unilite.popup('CUST_G', {
					 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
							autoPopup: true,
							listeners: {'onSelected': {
									fn: function(records, type) {
							    	    console.log('records : ', records);
									    Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setCustData(record,false, masterGrid.getSelectedRecord());
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setCustData(null,true, masterGrid.uniOpt.currentRecord);
								}
							}
						})
				  },
//				  {dataIndex: 'PURCHASE_TYPE' 	 		 	,		width: 85 },
//				  {dataIndex: 'SALES_TYPE'	 	 	 		,		width: 85 },
//				  {dataIndex: 'SALE_P'	 		 	 		,		width: 100 },
//				  {dataIndex: 'PURCHASE_P'	 	 	 		,		width: 100 },
//				  {dataIndex: 'PURCHASE_RATE' 	 		 	,		width: 100 },
				  {dataIndex: 'GOOD_STOCK_Q' 	 		 	,		width: 80 },
				  {dataIndex: 'BAD_STOCK_Q' 	 		 	,		width: 80 },
				  {dataIndex: 'STOCK_Q' 		 		 	,		width: 100, hidden: true },
				  {dataIndex: 'AVERAGE_P' 	 		 		,		width: 100 },
				  {dataIndex: 'STOCK_I' 		 		 	,		width: 100 },
				  {dataIndex: 'BASIS_YYYYMM' 	 		 	,		width: 66, hidden: true },
				  {dataIndex: 'UPDATE_DB_USER' 		 		,		width: 66, hidden: true },
				  {dataIndex: 'UPDATE_DB_TIME' 		 		,		width: 66, hidden: true },
				  {dataIndex: 'COMP_CODE'	     		 	,		width: 66, hidden: true },
                  {dataIndex: 'MONEY_UNIT'                  ,       width: 100, hidden: true }
		],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['SALES_TYPE', 'PURCHASE_TYPE', 'SALE_P', 'PURCHASE_P', 'PURCHASE_RATE',
	        									  'GOOD_STOCK_Q', 'WH_CELL_CODE', 'BAD_STOCK_Q', 'AVERAGE_P', 'STOCK_I', 'LOT_NO']))
					{
						return true;
      				} else {
      					return false;
      				}
	        	} else {
	        		/*if(Ext.isEmpty(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME'])))
				   	{
				   		UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME'])
						return false;
      				}*/
	        		if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'CUSTOM_CODE', 'CUSTOM_NAME', 'LOT_NO',
	        									  'SALES_TYPE', 'PURCHASE_TYPE', 'SALE_P', 'PURCHASE_P', 'PURCHASE_RATE',
	        									  'GOOD_STOCK_Q', 'WH_CELL_CODE', 'BAD_STOCK_Q', 'AVERAGE_P', 'STOCK_I']))
				   	{
						return true;
      				} else {
      					return false;
      				}
	        	}
	        }
		},
		////품목정보 팝업에서 선택된 데이타가 그리드에 추가되는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear, grdRecord) {
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
       			grdRecord.set('SPEC'				, "");
       			grdRecord.set('STOCK_UNIT'			, "");
//				grdRecord.set('SALES_TYPE'			, '2');
//				grdRecord.set('PURCHASE_TYPE'		, '1');
				grdRecord.set('SALE_P'				, 0);
//				grdRecord.set('PURCHASE_P'			, 0);
//				grdRecord.set('PURCHASE_RATE'		, 0);
       			grdRecord.set('GOOD_STOCK_Q'		, 0);
       			grdRecord.set('BAD_STOCK_Q '		, 0);
       			grdRecord.set('AVERAGE_P'			, 0);
       			grdRecord.set('STOCK_I'				, 0);

       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('SPEC'				, record['SPEC']);
       			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('SALE_P'				, record['SALE_BASIS_P']);
       			grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
       			grdRecord.set('BAD_STOCK_Q '		, record['BAD_STOCK_Q']);
       			grdRecord.set('STOCK_I'				, record['STOCK_I']);

       			var param = {
       				"ITEM_CODE": 		record['ITEM_CODE'],
					"CUSTOM_CODE": 		record['CUSTOM_CODE'],
					"DIV_CODE": 		masterForm.getValue('DIV_CODE'),
					"MONEY_UNIT":		UserInfo.currency,
					"ORDER_UNIT": 		record['ORDER_UNIT']
				};
				biv105ukrvService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						grdRecord.set('CUSTOM_CODE', provider['CUSTOM_CODE']);
						grdRecord.set('CUSTOM_NAME', provider['CUSTOM_NAME']);
//						grdRecord.set('SALES_TYPE', provider['SALES_TYPE']);
//						grdRecord.set('PURCHASE_TYPE', provider['PURCHASE_TYPE']);
//						grdRecord.set('PURCHASE_RATE', provider['PURCHASE_RATE']);
//						grdRecord.set('PURCHASE_P', provider['PURCHASE_P']);
       					grdRecord.set('AVERAGE_P', provider['SALE_BASIS_P']);
       					grdRecord.set('STOCK_UNIT', provider['ORDER_UNIT']);
       					grdRecord.set('SPEC', provider['SPEC']);
					}
				})
       		}
		},
		setCustData: function(record, dataClear, grdRecord) {
       		if(dataClear) {
       			grdRecord.set('CUSTOM_CODE'			, "");
       			grdRecord.set('CUSTOM_NAME'			, "");
       			/*grdRecord.set('ITEM_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
       			grdRecord.set('CUSTOM_CODE'			, "");
       			grdRecord.set('CUSTOM_NAME'			, "");
       			grdRecord.set('SPEC'				, "");
       			grdRecord.set('STOCK_UNIT'			, "");
				grdRecord.set('SALES_TYPE'			, '2');
				grdRecord.set('PURCHASE_TYPE'		, '1');
				grdRecord.set('SALE_P'				, 0);
				grdRecord.set('PURCHASE_P'			, 0);
				grdRecord.set('PURCHASE_RATE'		, 0);
       			grdRecord.set('GOOD_STOCK_Q'		, 0);
       			grdRecord.set('BAD_STOCK_Q '		, 0);
       			grdRecord.set('AVERAGE_P'			, 0);
       			grdRecord.set('STOCK_I'				, 0);*/

       		} else {
       			if(grdRecord.get('ITEM_CODE') == '' && grdRecord.get('ITEM_NAME') == '') {
	       			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
	       			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
	       			grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
	       			grdRecord.set('BAD_STOCK_Q '		, record['BAD_STOCK_Q']);
	       			grdRecord.set('STOCK_I'				, record['STOCK_I']);

//	       			var param = {
//	       				"ITEM_CODE": 		grdRecord.get('ITEM_CODE'),
//						"CUSTOM_CODE": 		record['CUSTOM_CODE'],
//						"DIV_CODE": 		masterForm.getValue('DIV_CODE'),
//						"MONEY_UNIT":		UserInfo.currency,
//						"ORDER_UNIT": 		record['ORDER_UNIT']
//					};
//					biv105ukrvService.fnOrderPriceCust1(param, function(provider, response)	{
//						if(!Ext.isEmpty(provider)){
//							grdRecord.set('ITEM_CODE', provider['ITEM_CODE']);
//							grdRecord.set('ITEM_NAME', provider['ITEM_NAME']);
//							/*grdRecord.set('CUSTOM_CODE', provider['CUSTOM_CODE']);
//							grdRecord.set('CUSTOM_NAME', provider['CUSTOM_NAME']);*/
//							grdRecord.set('SALES_TYPE', provider['SALES_TYPE']);
//							grdRecord.set('SALE_P', provider['SALE_BASIS_P']);
//							grdRecord.set('PURCHASE_TYPE', provider['PURCHASE_TYPE']);
//							grdRecord.set('PURCHASE_RATE', provider['PURCHASE_RATE']);
//							grdRecord.set('PURCHASE_P', provider['PURCHASE_P']);
//	       					grdRecord.set('AVERAGE_P', provider['SALE_BASIS_P']);
//	       					grdRecord.set('STOCK_UNIT', provider['ORDER_UNIT']);
//	       					grdRecord.set('SPEC', provider['SPEC']);
//						}
//					})
       			} else {
	       			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
	       			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
	       			grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
	       			grdRecord.set('BAD_STOCK_Q '		, record['BAD_STOCK_Q']);
	       			grdRecord.set('STOCK_I'				, record['STOCK_I']);

//	       			var param = {
//	       				"ITEM_CODE": 		grdRecord.get('ITEM_CODE'),
//						"CUSTOM_CODE": 		record['CUSTOM_CODE'],
//						"DIV_CODE": 		masterForm.getValue('DIV_CODE'),
//						"MONEY_UNIT":		UserInfo.currency,
//						"ORDER_UNIT": 		record['ORDER_UNIT']
//					};
//					biv105ukrvService.fnOrderPriceCust2(param, function(provider, response)	{
//						if(!Ext.isEmpty(provider)){
//							grdRecord.set('ITEM_CODE', provider['ITEM_CODE']);
//							grdRecord.set('ITEM_NAME', provider['ITEM_NAME']);
//							/*grdRecord.set('CUSTOM_CODE', provider['CUSTOM_CODE']);
//							grdRecord.set('CUSTOM_NAME', provider['CUSTOM_NAME']);*/
//							grdRecord.set('SALES_TYPE', provider['SALES_TYPE']);
//							grdRecord.set('SALE_P', provider['SALE_BASIS_P']);
//							grdRecord.set('PURCHASE_TYPE', provider['PURCHASE_TYPE']);
//							grdRecord.set('PURCHASE_RATE', provider['PURCHASE_RATE']);
//							grdRecord.set('PURCHASE_P', provider['PURCHASE_P']);
//	       					grdRecord.set('AVERAGE_P', provider['SALE_BASIS_P']);
//	       					grdRecord.set('STOCK_UNIT', provider['ORDER_UNIT']);
//	       					grdRecord.set('SPEC', provider['SPEC']);
//						}
//					})
       			}
       		}
		},
		setExcelData: function(record) {
			var CountDate = UniDate.getDbDateStr(masterForm.getValue('COUNT_DATE')).substring(0, 6);
			var grdRecord = this.getStore().data.items;
			grdRecord.set('STOCK_Q' 			, record['GOOD_STOCK_Q'] + record['BAD_STOCK_Q']);
		}
    });	//End of var masterGrid = Unilite.createGrid('biv105ukrvGrid1', {

	Unilite.Main( {
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
		id : 'biv105ukrvApp',
		fnInitBinding: function() {
            cbStore.loadStoreRecords();
			masterForm.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			biv105ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
			this.setDefault();
		},
		onQueryButtonDown: function() {    	// 조회버튼 눌렀을떄
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			UniAppManager.setToolbarButtons('newData', true);
			directMasterStore.loadStoreRecords();
		},
		setDefault: function() {		// 기본값
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.getForm().wasDirty = false;
         	masterForm.resetDirtyStatus();
         	UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			masterForm.getField('WH_CODE').focus();
			panelResult.getField('WH_CODE').focus();
			directMasterStore.clearData();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			var a = masterForm.getValue('COUNT_DATE');
			var sBasisYyyymm = UniDate.getDbDateStr(a).substring(0, 4) + '<t:message code="system.label.inventory.year" default="년"/>' + UniDate.getDbDateStr(a).substring(4, 6) + '<t:message code="system.label.inventory.month" default="월"/>';
			if(confirm('<t:message code="system.message.inventory.message028" default="해당 창고의"/>' + ' ' + sBasisYyyymm + '<t:message code="system.message.inventory.message029" default="모든 자료는 마감됩니다."/>')) {
				directMasterStore.saveStore();
			} else {

			}
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow1 = masterGrid.getSelectedRecord();
			if(selRow1.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.inventory.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.inventory.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						if(record.get('INSPEC_Q') > 1){
								alert('<t:message code="system.message.inventory.message030" default="검사된 수량이 존재합니다. 데이터를 수정할 수 없습니다."/>');
						}else{
							var deletable = true;
							if(deletable){
								masterGrid.reset();
								UniAppManager.app.onSaveDataButtonDown();
							}
							isNewData = false;
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
		onNewDataButtonDown: function()	{		// 행추가
			if(!masterForm.setAllFieldsReadOnly(true)){
                return false;
            }else{
                panelResult.setAllFieldsReadOnly(true);
            }
			var countDate = UniDate.getDbDateStr(masterForm.getValue('COUNT_DATE')).substring(0, 6);
//			var monthDate = countDate.substring(0,4) + '.' + countDate.substring(4,6);
			var divCode			= masterForm.getValue('DIV_CODE');
			var whName    		= masterForm.getValue('WH_CODE');
			var whCode    		= masterForm.getValue('WH_CODE');
			var basisYyyymm		= countDate;
			var whCellCode		= '';
			var whCellName		= '';
			var lotNo     		= '';
			var customCode		= '';
			var customName		= '';
			var salesType		= '2';
			var purchaseType	= '1';
			var saleP			= '0';
			var purchaseP		= '0';
			var purchaseRate	= '0';
			var goodStockQ		= '0';
			var badStockQ 		= '0';
			var stockQ    		= '0';
			var averageP  		= '0';
			var stockI   		= '0';
			var compCode		= UserInfo.compCode;
			var moneyUnit       = BsaCodeInfo.gsMoneyUnit;

			var r = {
				DIV_CODE: 		divCode,
				WH_NAME:		whName,
				WH_CODE: 		whCode,
				BASIS_YYYYMM: 	basisYyyymm,
				WH_CELL_CODE: 	whCellCode,
				WH_CELL_NAME: 	whCellName,
				LOT_NO: 		lotNo,
				CUSTOM_CODE: 	customCode,
				CUSTOM_NAME: 	customName,
				SALES_TYPE:		salesType,
				PURCHASE_TYPE:	purchaseType,
				SALE_P:			saleP,
				PURCHASE_P:		purchaseP,
				PURCHASE_RATE:	purchaseRate,
				GOOD_STOCK_Q: 	goodStockQ,
				BAD_STOCK_Q: 	badStockQ,
				STOCK_Q: 		stockQ,
				AVERAGE_P: 		averageP,
				STOCK_I: 		stockI,
				COMP_CODE: 		compCode,
				MONEY_UNIT:     moneyUnit
			};
            cbStore.loadStoreRecords(whCode);
			masterGrid.createRow(r);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		fnYyyymmSet : function() {
			var param = {"DIV_CODE": masterForm.getValue('DIV_CODE'), "WH_CODE": masterForm.getValue('WH_CODE')};
			biv105ukrvService.YyyymmSet(param, function(provider, response)	{
				if(!Ext.isEmpty(provider['BASIS_YYYYMM'])){
					masterForm.setValue('COUNT_DATE', provider['BASIS_YYYYMM']);
				}
				if(Ext.isEmpty(provider['BASIS_YYYYMM'])){
					masterForm.setValue('COUNT_DATE', UniDate.get('today'));
				}
			})
		},
		fnYyyymmSet2 : function() {
			var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'), "WH_CODE": panelResult.getValue('WH_CODE')};
			biv105ukrvService.YyyymmSet(param, function(provider, response)	{
				if(!Ext.isEmpty(provider['BASIS_YYYYMM'])){
					panelResult.setValue('COUNT_DATE', provider['BASIS_YYYYMM']);
				}
				if(Ext.isEmpty(provider['BASIS_YYYYMM'])){
					panelResult.setValue('COUNT_DATE', UniDate.get('today'));
				}
			})
		}
	});//End of Unilite.Main( {

	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				/*case "CUSTOM_CODE" :		// 거래처
					if(record.get('ITEM_CODE') == '') {
						rv= Msg.sMS003;
						break;
					}
				break;

				case "CUSTOM_NAME" :		// 거래처
					if(record.get('ITEM_NAME') == '') {
						rv= Msg.sMS003;
						break;
					}
				break;*/

				case "GOOD_STOCK_Q" :	// 양품재고
					/*if(newValue < '0') {
						rv= Msg.sMB076;
						break;
					}*/
					if(newValue == '1') {
						record.set('GOOD_STOCK_Q','0');
					}
					if(record.get('AVERAGE_P' == '')) {
						record.set('AVERAGE_P','0');
					}
					record.set('STOCK_Q',(newValue + record.get('BAD_STOCK_Q')));
					record.set('STOCK_I',(record.get('STOCK_Q') * record.get('AVERAGE_P')));
				break;

				case "BAD_STOCK_Q" :	// 불량재고
					if(newValue < '0') {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
						break;
					}
					if(newValue == '') {
						record.set('BAD_STOCK_Q','0');
					}
					if(record.get('AVERAGE_P' == '')) {
						record.set('AVERAGE_P','0');
					}
					record.set('STOCK_Q',(record.get('GOOD_STOCK_Q') + newValue));
					record.set('STOCK_I',(record.get('STOCK_Q') * record.get('AVERAGE_P')));
				break;

				case "STOCK_Q" :	// 기초재고량
					if(newValue < '0') {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
						break;
					}
					if(newValue == '') {
						record.set('STOCK_Q','0');
					}
					if(record.get('AVERAGE_P' == '')) {
						record.set('AVERAGE_P','0');
					}
					record.set('STOCK_Q',(record.get('GOOD_STOCK_Q') + record.get('BAD_STOCK_Q')));
					record.set('STOCK_I',(newValue * record.get('AVERAGE_P')));
				break;

				case "AVERAGE_P" :	// 평균단가
					if(newValue == '') {
						record.set('AVERAGE_P','0');
					}
					if(newValue <= '0') {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
						break;
					}
					if(record.get('STOCK_Q' == '')) {
						record.set('STOCK_Q','0');
					}
					record.set('STOCK_I',(record.get('STOCK_Q') * newValue));
				break;

				case "STOCK_I" :	// 기초금액
					if(newValue == '') {
						record.set('STOCK_I','0');
					}
					if(newValue < '0') {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
						break;
					}
					if(record.get('STOCK_Q') != '0') {
						record.set('AVERAGE_P',(newValue / record.get('STOCK_Q')));
					} else {
						record.set('AVERAGE_P','0');
					}
				break;

				case "SALE_P"  :	// 판매가
					if(newValue == '') {
						record.set('SALE_P','0');
					}
					if(newValue < '0') {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
						break;
					}
					var sPurchaseRate = record.get('PURCHASE_RATE');
					var sSaleP = newValue;
					var sPurchaseP = record.get('PURCHASE_P');
					if(sSaleP == 0) {
						sPurchaseP = 0;
					} else {
						sPurchaseP = sSaleP * (sPurchaseRate / 100);
					}
					record.set('PURCHASE_P',sPurchaseP);
					record.set('AVERAGE_P',record.get('PURCHASE_P'));
					record.set('STOCK_I',(record.get('STOCK_Q') * record.get('AVERAGE_P')));
				break;

				case "PURCHASE_RATE"  :		// 매입율
					if(newValue == '') {
						record.set('PURCHASE_RATE','0');
					}
					if(newValue < '0') {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
						break;
					}
					var sPurchaseRate = newValue;
					var sSaleP = record.get('SALE_P');
					var sPurchaseP = record.get('PURCHASE_P');
					if(sSaleP == 0) {
						sPurchaseP = 0;
					} else {
						sPurchaseP = sSaleP * (sPurchaseRate / 100);;
					}
					record.set('PURCHASE_P',sPurchaseP);
					record.set('AVERAGE_P',record.get('PURCHASE_P'));
					record.set('STOCK_I',(record.get('STOCK_Q') * record.get('AVERAGE_P')));
				break;

				case "PURCHASE_P" :		// 매입가
					if(newValue == '') {
						record.set('PURCHASE_P','0');
					}
					if(newValue < '0') {
						rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
						break;
					}
					record.set('AVERAGE_P',newValue);
					record.set('STOCK_I',(record.get('STOCK_Q') * record.get('AVERAGE_P')));
				break;
			}
			return rv;
		}
	})
};
</script>
