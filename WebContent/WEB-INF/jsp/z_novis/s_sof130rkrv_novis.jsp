<%--
'   프로그램명 : 수주현황조회 (영업)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof130rkrv_novis"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sof130rkrv_novis"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B138" storeId="boxTypeStore"/>  	<!-- 박스형태 -->
	<t:ExtComboStore comboType="AU" comboCode="S106"/>							<!-- 라벨종류  -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333; font-weight: normal; padding: 1px 2px;}
</style>
<script type="text/javascript" >
var opt = "P";
var gsLabelCustomCode = '${gsLabelCustomCode}';
var gsLabelCustomName = '${gsLabelCustomName}';
function appMain() {

	Ext.create('Ext.data.Store', {
		storeId:"printType",
	    fields: ['text', 'value'],
	    data : [
	        {text:"의료기기",   value:"A"},
	        {text:"산업체"	 ,   value:"B"}
	    ]
	});

	Unilite.defineModel('S_sof130rkrv_novisModel', {
	    fields: [
			{name: 'ORDER_NUM'		 		, text:'<t:message code="system.label.sales.sono" default="수주번호"/>' 						, type:'string'},
			{name: 'SER_NO'		 			, text:'SER_NO' 						, type:'string'},
			{name: 'CUSTOM_CODE'		 	, text:'<t:message code="system.label.sales.custom" default="거래처코드"/>'   			, type:'string'},
			{name: 'CUSTOM_NAME'			, text:'<t:message code="system.label.sales.customname" default="거래처"/>'			, type:'string'},
			{name: 'ITEM_CODE'             	, text:'<t:message code="system.label.sales.itemcode" default="품목코드"/>'             , type: 'string'},
			{name: 'ITEM_NAME'		 		, text:'<t:message code="system.label.sales.itemname" default="품목명"/>' 				, type:'string'},
			{name: 'LOT_NO'					, text:'LOT NO'					,type:'string'},
			{name: 'ORDER_UNIT'             , text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'             	, type: 'string'},
			{name: 'STOCK_UNIT'             , text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'           	, type: 'string'},
			{name: 'ORDER_Q'               	, text:'생산량'          			, type: 'uniQty'},
			{name: 'IN_Q'                	, text:'입고량'          			, type: 'uniQty'},
			{name: 'OUT_Q'                	, text:'출고량'          			, type: 'uniQty'},
			{name: 'BOX_TYPE'             	, text:'박스형태'             	, type: 'string'   , comboType:"AU", comboCode:"B138"},
			{name: 'PRINT_Q'             	, text:'출력수량'             	, type: 'int'},
			{name: 'LABEL_TYPE'            	, text:'출력양식'             	, type: 'string'   , comboType:"AU", comboCode:"S106"},
			//{name: 'LABEL_TYPE'			, text: '출력양식'				, type: 'string' , xtype:'uniCombobox', comboType: 'AU', store: Ext.data.StoreManager.lookup('printType')},
			{name: 'ORDER_SEQ'		 		, text:'ORDER_SEQ' 		,type: 'int'},
			{name: 'EA_QTY'		 			, text:'EA_QTY' 		,type: 'int'},
			{name: 'MOD_QTY'		 		, text:'MOD_QTY' 		,type: 'int'},
			{name: 'BOX_UNIT'		 		, text:'BOX_UNIT' 		,type: 'string'}

		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_sof130rkrv_novisMasterStore1', {
		model: 'S_sof130rkrv_novisModel',
		uniOpt: {
           	isMaster: false,			// 상위 버튼,상태바 연결
           	editable: true,		// 수정 모드 사용
           	deletable:false,		// 삭제 가능 여부
            useNavi: false			// prev | next 버튼 사용
		},
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {
            	read: 's_sof130rkrv_novisService.selectList1'
		    }
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			this.load({
				params: param
			});
		},
        listeners: {
            load: function(store, records, successful, eOpts) {
            	Ext.each(records, function(record,i) {
                	if(Ext.isEmpty(record.get('LABEL_TYPE'))){
                		record.set('LABEL_TYPE','A');
                	}
                	if( Ext.isEmpty(record.get('BOX_TYPE'))){
                		record.set('PRINT_Q', 1);
                	}else{
                		record.set('PRINT_Q', Math.ceil(record.get('OUT_Q')/record.get('BOX_TYPE')));
                	}
				});
            	store.commitChanges();
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            	store.commitChanges();
            }
        }
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	    	items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.productiondate" default="생산일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'PRODT_START_DATE',
		        endFieldName: 'PRODT_END_DATE',
		        width: 470,
		        allowBlank: false,
		        startDate: UniDate.get('today'),
		        endDate: UniDate.get('today'),
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
		        	if(panelResult) {
						panelResult.setValue('PRODT_START_DATE',newValue);
		        	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_END_DATE',newValue);
			    	}
				}
	        },Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				autoPopup: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							prStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},{
		 		    xtype: 'radiogroup',
				    fieldLabel: '옵션',
				    id: 'optRadio',
				    hidden:true,
				    colspan: 2,
				    items : [{
				    	boxLabel: '생산',
				    	name: 'OPT' ,
				    	inputValue: 'P',
				    	checked: true,
				    	width:95
				    }, {boxLabel: '외주',
				    	name: 'OPT',
				    	inputValue: 'M',
				    	width:95
				    }],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							opt = newValue.OPT;
							panelResult.getField('OPT').setValue(newValue.OPT);
							masterGrid.reset();
							directMasterStore.commitChanges();
						}
					}
				},{
		            fieldLabel: 'LOT NO',
		            name:'LOT_NO',
		            xtype: 'uniTextfield',
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('LOT_NO', newValue);
						}
					}
		        }
			]
   		},
        Unilite.popup('AGENT_CUST', {
            //fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
            fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
            allowBlank: true,
            holdable: 'hold',
            margin : '0 0 0 0',
//            extParam: {'CUSTOM_TYPE': ['1','2']},
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        console.log('records : ' , records);
                        panelResult.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
                        panelResult.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
                    },
                    scope: this
                },
                onClear: function(type) {
                   // CustomCodeInfo.gsUnderCalBase = '';
                	  panelResult.setValue('CUSTOM_CODE', '');
                	  panelResult.setValue('CUSTOM_NAME', '');
                },
                applyextparam: function(popup){
                   // popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                   // popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                }
            }
        })],
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
				}
	  		}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.productiondate" default="생산일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'PRODT_START_DATE',
		        endFieldName: 'PRODT_END_DATE',
		        allowBlank: false,
		        startDate: UniDate.get('today'),
		        endDate: UniDate.get('today'),
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
		        	if(panelResult) {
						panelResult.setValue('PRODT_START_DATE',newValue);
		        	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_END_DATE',newValue);
			    	}
				}
	        },Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				autoPopup: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
 		         	xtype:'button',
 		         	text:'대라벨출력',
 		         	id: 'btnPrint2',
 		         	hidden: false,
 		         	margin : '0 4 1 10',
 		         	handler:function()	{
		    			  var param = panelResult.getValues();
		  				  var selectedDetails = masterGrid.getSelectedRecords();

		                    param["PGM_ID"]= PGM_ID;
		                	var printKey= "";
		                	var itemPrint = "";
		                	var boxType = "";
		                	var boxUnit = "";

		                		Ext.each(selectedDetails, function(record, idx) {
			                		if(idx ==0) {
			                			printKey = record.get("ORDER_NUM");
			                			itemPrint =record.get("ORDER_NUM") + ':' + record.get('PRINT_Q') + '^' + record.get('EA_QTY') + '^^' + record.get('MOD_QTY');
			                			boxType = record.get("ORDER_NUM") + ':' + record.get("BOX_TYPE");
			                			boxUnit = record.get("ORDER_NUM") + ':' + record.get("BOX_UNIT");

			                    	}else{
			                    		printKey = printKey + ','  +  record.get("ORDER_NUM");
			                    		itemPrint = itemPrint + ',' + record.get("ORDER_NUM") + ':' + record.get('PRINT_Q') + '^' + record.get('EA_QTY') + '^^' + record.get('MOD_QTY');
			                    		boxType = boxType + ',' + record.get("ORDER_NUM") + ':' + record.get("BOX_TYPE");
			                    		boxUnit = boxUnit + ',' + record.get("ORDER_NUM") + ':' + record.get("BOX_UNIT");
			                    	}
			    				});

		                    if(Ext.isEmpty(itemPrint)){
		                    	//Ext.getCmp('btnPrint1').disable();
		            			Ext.getCmp('btnPrint2').disable();
		                    }else{
		                    	//Ext.getCmp('btnPrint1').enable();
		            			Ext.getCmp('btnPrint2').enable();
		                    }
		                    param["dataCount"] = selectedDetails.length;
	                        param["USER_LANG"] = UserInfo.userLang;
	                        param["PGM_ID"]= PGM_ID;
	                        param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
		                    param.PRINT_KEY = printKey;
		                    param.ITEM_PRINT = itemPrint;
		                    param.SEL_BOX_TYPE = boxType;
		                    param.SEL_BOX_UNIT = boxUnit;

		  		  	    var win = Ext.create('widget.ClipReport', {
		  						url: CPATH+'/z_novis/s_sof130clrkrv_novis_label.do',
		  						prgID: 's_sof130rkrv_novis',
		  						extParam: param
		  						});
		  						win.center();
		  						win.show();
	         			}

	         },{
 		         	xtype:'button',
 		         	text:'출고전표',
 		         	id: 'btnPrint3',
 		         	margin : '0 4 1 20',
 		         	handler:function()	{
		    			  var param = panelResult.getValues();
		  				  var selectedDetails = masterGrid.getSelectedRecords();
						  if(Ext.isEmpty(selectedDetails)){
							  Unilite.messageBox('출력할 데이터를 선택해주세요.');
							  return false;
						  }
		                    param["PGM_ID"]= PGM_ID;
		                	var printKey= "";
		                	var itemPrint = "";
		                	var packType = "";
		                	if(opt == 'P'){
		                		Ext.each(selectedDetails, function(record, idx) {
			                		if(idx ==0) {
			                			printKey = record.get("ORDER_NUM");

			                			outQ = record.get("OUT_Q");

			                    	}else{
			                    		printKey = printKey + ','  +  record.get("ORDER_NUM");

			                			outQ = outQ + ','  +  record.get("OUT_Q");
			                    	}
			    				});
		              		}else{
		              			Ext.each(selectedDetails, function(record, idx) {
			                		if(idx ==0) {
			                			printKey = record.get("ORDER_NUM") + record.get("ORDER_SEQ");
			                    	}else{
			                    		printKey = printKey + ','  +  record.get("ORDER_NUM") + record.get("ORDER_SEQ");
			                    	}
			    				});
		              		}

		                    if(Ext.isEmpty(itemPrint)){
		                    	//Ext.getCmp('btnPrint1').disable();
		            			Ext.getCmp('btnPrint2').disable();
		                    }else{
		                    	//Ext.getCmp('btnPrint1').enable();
		            			Ext.getCmp('btnPrint2').enable();
		                    }
		                    param["dataCount"] = selectedDetails.length;
	                        param["USER_LANG"] = UserInfo.userLang;
	                        param["PGM_ID"]= PGM_ID;
	                        param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
		                    param.PRINT_KEY = printKey;
		                    param.OUT_Q = outQ;


		  		  	    var win = Ext.create('widget.ClipReport', {
		  						url: CPATH+'/z_novis/s_sof130clrkrv_novis.do',
		  						prgID: 's_sof130rkrv_novis',
		  						extParam: param
		  						});
		  						win.center();
		  						win.show();
	         			}

	         },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
						store.clearFilter();
						prStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
							prStore.filterBy(function(record){
								return record.get('option') == panelResult.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
							prStore.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},{
	 		    xtype: 'radiogroup',
			    fieldLabel: '옵션',
			    hidden:true,
			    items : [{
			    	boxLabel: '생산',
			    	name: 'OPT' ,
			    	inputValue: 'P',
			    	checked: true,
			    	width:95
			    }, {boxLabel: '외주',
			    	name: 'OPT',
			    	inputValue: 'M',
			    	width:95
			    }],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						opt = newValue.OPT;
						panelSearch.getField('OPT').setValue(newValue.OPT);
						masterGrid.reset();
						directMasterStore.commitChanges();

					}
				}
			},{
	            fieldLabel: 'LOT NO',
	            name:'LOT_NO',
	            xtype: 'uniTextfield',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('LOT_NO', newValue);
					}
				}
	        },
	        Unilite.popup('AGENT_CUST', {
	            //fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
	            fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
	            valueFieldName:'CUSTOM_CODE',
	            textFieldName:'CUSTOM_NAME',
	            allowBlank: true,
	            holdable: 'hold',
	            margin : '0 0 0 0',
//	            extParam: {'CUSTOM_TYPE': ['1','2']},
	            listeners: {
	                onSelected: {
	                    fn: function(records, type) {
	                        console.log('records : ', records);
	                        panelSearch.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
	                        panelSearch.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
	                    },
	                    scope: this
	                },
	                onClear: function(type) {
	                  //  CustomCodeInfo.gsUnderCalBase = '';
	                	  panelSearch.setValue('CUSTOM_CODE', '');
	                	  panelSearch.setValue('CUSTOM_NAME', '');
	                },
	                applyextparam: function(popup){
	                  /*  popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
	                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});*/
	                }
	            }
	        }),{
	    		xtype: 'uniCheckboxgroup',
	    		fieldLabel: '판매원 포함',
	    		hidden:true,
	    		//id: 'check1',
	    		items: [{
	    			boxLabel: '',
	    			width: 100,
	    			name: 'WITH_SALES_MAN',
	    			checked:true,
	    			inputValue: 'Y'
	    		}],listeners: {
   				 	change: function(field, newValue, oldValue, eOpts) {

					}
	        	}
	        },{
	             fieldLabel: 'ITEM_PRINT',
	             xtype: 'uniTextfield',
	             name: 'ITEM_PRINT',
	             hidden: true
	         },{
	             fieldLabel: 'ITEM_LOT',
	             xtype: 'uniTextfield',
	             name: 'ITEM_LOT',
	             hidden: true
	         }
		]
    });

	/**
     * Master Grid1 정의(Grid Panel),
     * @type
     */
    var masterGrid = Unilite.createGrid('s_sof130rkrv_novisGrid1', {
    	layout: 'fit',
    	region:'center',
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                    /* if(Ext.isEmpty(panelResult.getValue('ORDER_NUM'))) {
                        panelResult.setValue('ORDER_NUM', selectRecord.get('ORDER_NUM'));
                    } else {
                        var orderNums = panelResult.getValue('ORDER_NUM');
                        orderNums = orderNums + ',' + selectRecord.get('ORDER_NUM');
                        panelResult.setValue('ORDER_NUM', orderNums);
                    } */
                    if(Ext.isEmpty(selectRecord)){
                    	//Ext.getCmp('btnPrint1').disable();
            			Ext.getCmp('btnPrint2').disable();
                    }else{
                    	//Ext.getCmp('btnPrint1').enable();
            			Ext.getCmp('btnPrint2').enable();
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	/* var selectedDetails = masterGrid.getSelectedRecords();
                	var orderNums = "";
                	Ext.each(selectedDetails, function(record, idx) {
                		if(idx ==0) {
                			orderNums = record.get("ORDER_NUM");
                    	}else{
                    		orderNums = orderNums + ',' + record.get("ORDER_NUM");
                    	}
    				});
                	panelResult.setValue('ORDER_NUM', orderNums); */
                	var selectedDetails = masterGrid.getSelectedRecords();
                    if(Ext.isEmpty(selectedDetails)){
                    	//Ext.getCmp('btnPrint1').disable();
            			Ext.getCmp('btnPrint2').disable();
                    }else{
                    	//Ext.getCmp('btnPrint1').enable();
            			Ext.getCmp('btnPrint2').enable();
                    }
                }
            }
        }),
        uniOpt: {
        	expandLastColumn: true,
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useRowContext 		: true,
			onLoadSelectFirst: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }

        },
    	store: directMasterStore,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],

        columns: [
			{dataIndex: 'ITEM_CODE'     		, width: 100,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
	            }
			},
			{dataIndex: 'ITEM_NAME'		 		, width: 200},
			{dataIndex: 'LOT_NO'			 	, width: 130},
			{dataIndex: 'ORDER_UNIT'             , width: 100},
			{dataIndex: 'STOCK_UNIT'             , width: 100},
			{dataIndex: 'ORDER_Q'      			, width: 100, summaryType: 'sum'},
			{dataIndex: 'IN_Q'               , width: 100},
			{dataIndex: 'OUT_Q'                , width: 100},
			{dataIndex: 'BOX_TYPE'               , width: 100},
			{dataIndex: 'PRINT_Q'                , width: 100},
			{dataIndex: 'LABEL_TYPE'                , width: 120},
			{dataIndex: 'ORDER_NUM'		 		, width: 100, hidden: true},
			{dataIndex: 'ORDER_SEQ'		 		, width: 100, hidden: true},
			{dataIndex: 'EA_QTY'		 		, width: 100, hidden: true},
			{dataIndex: 'MOD_QTY'		 		, width: 100, hidden: true},
			{dataIndex: 'BOX_UNIT'		 		, width: 100, hidden: true}
			/* { text:'프로세스' , dataIndex:'service', width: 128,
 			   renderer:function(value,cellmeta){
 				   return "<input type='button'  style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 116px;' value='거래명세서 출력' >"
 				},
                	listeners:{
                   	click:function(val,metaDate,record,rowIndex,colIndex,store,view){
                 		var params = store;
							masterGrid.printBtn(params);
                    	}
 				}
            },
            {dataIndex: 'DEAL_REPORT_TYPE'    		, width: 120}, */

		],
		 listeners: {
	        	beforeedit: function( editor, e, eOpts ) {
					 if(!e.record.phantom) {
						if(UniUtils.indexOf(e.field, ['PRINT_Q','BOX_TYPE','LABEL_TYPE','OUT_Q']))
						{
							return true;
		  				} else {
		  					return false;
		  				}
					} else {
						if(UniUtils.indexOf(e.field, ['PRINT_Q','BOX_TYPE','LABEL_TYPE','OUT_Q']))
					   	{
							return true;
		  				} else {
		  					return false;
		  				}
					}
				},cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
					//beforeRowIndex = rowIndex;
				}
			 }/* ,
        printBtn:function(record){
				var param= record.data;
				if(record.data.DEAL_REPORT_TYPE == '15'){
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/sales/sof120clskrv_5.do',
						prgID: 's_sof130rkrv_novis_5',
						extParam: param
						});
						win.center();
						win.show();
				}else{
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/sales/sof120clskrv.do',
						prgID: 's_sof130rkrv_novis',
						extParam: param
						});
						win.center();
						win.show();
				}
        }  */
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
			panelSearch
		],
		id: 's_sof130rkrv_novisApp',
		fnInitBinding: function() {
			panelResult.getField('OPT').setValue('P');
			panelSearch.getField('OPT').setValue('P');
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('PRODT_END_DATE', UniDate.get('today'));
			panelSearch.setValue('PRODT_START_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRODT_END_DATE', UniDate.get('today'));
			panelResult.setValue('PRODT_START_DATE', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
			panelSearch.setValue('CUSTOM_CODE',gsLabelCustomCode);
			panelResult.setValue('CUSTOM_CODE',gsLabelCustomCode);
			panelSearch.setValue('CUSTOM_NAME',gsLabelCustomName);
			panelResult.setValue('CUSTOM_NAME',gsLabelCustomName);
			//Ext.getCmp('btnPrint1').disable();
			Ext.getCmp('btnPrint2').disable();
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		}
	});

    Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
				case "BOX_TYPE" :	// 박스형태
					record.set('PRINT_Q', Math.ceil(record.get('OUT_Q')/parseInt(newValue)));
					record.set('EA_QTY', newValue);
					record.set('MOD_QTY',record.get('OUT_Q') % parseInt(newValue));

					var boxTypeStore =  Ext.data.StoreManager.lookup('boxTypeStore');//박스유형콤보스토어
					var selText      = '';
					var selTextLen      = 0 ;
					Ext.each(boxTypeStore.data.items, function(comboData, idx) {//박스유형콤보스토어에서 선택한 박스유형에 해당하는 단위를 가져옴
						if(comboData.get('value') == newValue){
							selText = comboData.get('text');
							selTextLen = selText.length;
							record.set('BOX_UNIT', selText.substring(comboData.get('value').length, selTextLen));
						}
					});
				break;

			}
			return rv;
		}
	});
};
</script>

