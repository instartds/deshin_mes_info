<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp270skrv_novis"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp270skrv_novis" /> 	  <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="P001"  /> 		  <!-- 진행상태 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript" src="<c:url value='/resources/js/jsbarcode/jquery-barcode.js' />" ></script>
<script type="text/javascript" >
var BsaCodeInfo = {
	gsSiteCode			: '${gsSiteCode}'
};
var gsSelRecord;
var wkordBarcodeWindow;//제조지시 바코드 팝업
function appMain() {

	Unilite.defineModel('s_pmp270skrv_novisModel', {
		fields: [
	    	{name: 'WKORD_NUM'       	, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'  	, type: 'string'},
			{name: 'ITEM_CODE'       	, text: '<t:message code="system.label.product.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'       	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'            	, text: '<t:message code="system.label.product.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'      	, text: '<t:message code="system.label.product.unit" default="단위"/>'				, type: 'string'},
			{name: 'WORK_END_YN'     	, text: '<t:message code="system.label.product.status" default="상태"/>'				, type: 'string' , comboType:'AU', comboCode:'P001'},
			{name: 'LOT_NO'    			, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'WKORD_Q'         	, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'         	, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'JAN_PRODT_Q'        , text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'			, type: 'uniQty'},
			
			{name: 'PROG_WORK_NAME'    	, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
			{name: 'BOX_QTY'    		, text: '<t:message code="system.label.product.boxqty3" default="용기수량"/>'			, type: 'int'},
			{name: 'WHOLE_WEIGHT'    	, text: '<t:message code="system.label.product.wholewei" default="전체무게"/>'			, type: 'float'	, decimalPrecision: 3	, format: '#,###.###'},
			{name: 'BOX_WEIGHT'	    	, text: '<t:message code="system.label.product.boxwei" default="용기무게"/>'			, type: 'float'	, decimalPrecision: 3	, format: '#,###.###'},
			{name: 'REAL_WEIGHT'    	, text: '<t:message code="system.label.product.realwei" default="실제무게"/>'			, type: 'float'	, decimalPrecision: 3	, format: '#,###.###'},
			{name: 'WORK_DATE'    		, text: '<t:message code="system.label.product.workday" default="작업일"/>'			, type: 'uniDate'},
			{name: 'REMARK'         	, text: '<t:message code="system.label.product.remarks" default="비고"/>'				, type: 'string'}
		]
	});

	var directMasterStore1 = Unilite.createStore('s_pmp270skrv_novisMasterStore1',{
		model: 's_pmp270skrv_novisModel',
		uniOpt: {
			isMaster:  false,		// 상위 버튼 연결
			editable:  true,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi:   false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_pmp270skrv_novisService.selectList'
			}
		},
		listeners: {
           	load:function(store, records, successful, eOpts) {
				UniAppManager.setToolbarButtons('save', false);
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});

    var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items:[{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
        		}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
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
                name: 'ITEM_ACCOUNT',
                fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
                xtype:'uniCombobox',
                comboType:'AU',
                comboCode:'B020',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ITEM_ACCOUNT', newValue);
                    }
                }
            },{
	        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'PRODT_START_DATE_FR',
	        	endFieldName: 'PRODT_START_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('mondayOfWeek'),
	        	endDate: UniDate.get('sundayOfNextWeek'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_START_DATE_TO',newValue);
			    	}
			    }
			},
            Unilite.popup('DIV_PUMOK',{
                fieldLabel: '<t:message code="system.label.base.itemcode" default="품목"/>',
                valueFieldName: 'ITEM_CODE',
                textFieldName: 'ITEM_NAME',

                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            console.log('records : ', records);
                            panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
                            panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('ITEM_CODE', '');
                        panelResult.setValue('ITEM_NAME', '');
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                    }
                }
     		}),
			{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:300,
				items :[{
					fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_FR',
					width:200,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WKORD_NUM_FR', newValue);
						}
					}
				},{
					xtype:'component',
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'',
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_TO',
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WKORD_NUM_TO', newValue);
						}
					}
				}]
			},{
				xtype: 'radiogroup',
				fieldLabel: '   ',
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 50,
					name: 'WORK_END_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 50,
					name: 'WORK_END_YN' ,
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 50,
					name: 'WORK_END_YN' ,
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 50,
					name: 'WORK_END_YN' ,
					inputValue: 'F'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items:[{
    		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
    		name: 'DIV_CODE',
    		value : UserInfo.divCode,
    		xtype: 'uniCombobox',
    		comboType: 'BOR120',
    		allowBlank: false,
    		colspan:1,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
					panelResult.setValue('WORK_SHOP_CODE','');
				}
    		}
		},{
        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
        	xtype: 'uniDateRangefield',
        	startFieldName: 'PRODT_START_DATE_FR',
        	endFieldName: 'PRODT_START_DATE_TO',
        	colspan:4,
        	width: 315,
        	startDate: UniDate.get('mondayOfWeek'),
        	endDate: UniDate.get('sundayOfNextWeek'),
        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_FR',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PRODT_START_DATE_TO',newValue);
		    	}
		    }
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'W',
			allowBlank:false,
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
                name: 'ITEM_ACCOUNT',
                fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
                xtype:'uniCombobox',
                colspan:2,
                comboType:'AU',
                comboCode:'B020',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('ITEM_ACCOUNT', newValue);
                    }
                }
        },
        Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '<t:message code="system.label.base.itemcode" default="품목"/>',
                    valueFieldName: 'ITEM_CODE',
                    textFieldName: 'ITEM_NAME',
    				labelWidth:150,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
                                panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('ITEM_CODE', '');
                            panelSearch.setValue('ITEM_NAME', '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
         	}),{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            margin      : '0 0 0 100',
            width:400,
            items :[{
		            xtype       : 'button',
		            text        : '<t:message code="system.label.product.inspeclabelprint" default="검사라벨출력"/>',
		            width       : 120,
		            margin      : '0 0 2 10',
		            itemId		:'btnPrint1',
		            tdAttrs     : {align: 'left'},
		            handler     : function(btn) {
							UniAppManager.app.onPrintButtonDown();
			        }
			    }]
            },
			{
		    xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:300,
			items :[{
				fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				xtype: 'uniTextfield',
				name: 'WKORD_NUM_FR',
				width:200,
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WKORD_NUM_FR', newValue);
					}
				}
			},{
				xtype:'component',
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'',
				xtype: 'uniTextfield',
				name: 'WKORD_NUM_TO',
				width: 110,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WKORD_NUM_TO', newValue);
					}
				}
			}]
		},{
			xtype: 'radiogroup',
			fieldLabel: '   ',
			labelWidth:90,
			width: 315,
			colspan:3,
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
				width: 50,
				name: 'WORK_END_YN',
				inputValue: '',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
				width: 50,
				name: 'WORK_END_YN' ,
				inputValue: 'N'
			},{
				boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
				width: 50,
				name: 'WORK_END_YN' ,
				inputValue: 'Y'
			},{
				boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
				width: 50,
				name: 'WORK_END_YN' ,
				inputValue: 'F'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);

					setTimeout(function(){
						UniAppManager.app.onQueryButtonDown();
					}, 50);
				}
			}
		}]

    });

	var masterGrid = Unilite.createGrid('s_pmp270skrv_novisGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
		uniOpt:{
        	expandLastColumn   : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
    		useGroupSummary    : false,
			useRowNumberer     : false,
			onLoadSelectFirst  : false, 
			filter: {
				useFilter: true,
				autoCreate: true
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
		store: directMasterStore1,
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount() > 0) {

					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					if (this.selected.getCount() == 0) {
					}
				}
			}
		}),
		columns: [

			{dataIndex: 'WKORD_NUM'       	, editable: false   , width: 130},
			{dataIndex: 'ITEM_CODE'       	, editable: false	, width: 120},
			{dataIndex: 'ITEM_NAME'       	, editable: false	, width: 200},
			{dataIndex: 'SPEC'            	, editable: false	, width: 80},
			{dataIndex: 'STOCK_UNIT'      	, editable: false	, width: 50,align:'center'},
			{dataIndex: 'WORK_END_YN'     	, editable: false	, width: 50,align:'center'},
			{dataIndex: 'LOT_NO'           	, editable: false	, width: 80},
			{dataIndex: 'WKORD_Q'         	, editable: false	, width: 100, summaryType: 'sum'},
			{dataIndex: 'PRODT_Q'        	, editable: false	, width: 100, summaryType: 'sum'},
			{dataIndex: 'JAN_PRODT_Q'       , editable: false	, width: 100, summaryType: 'sum'},
			{dataIndex: 'PROG_WORK_NAME'   	, width: 100        ,align:'center'},
			
			{dataIndex: 'BOX_QTY'      		, width: 100},
			{dataIndex: 'WHOLE_WEIGHT'      , width: 100},
			{dataIndex: 'BOX_WEIGHT'      	, width: 100},
			{dataIndex: 'REAL_WEIGHT'      	, width: 100},
			{dataIndex: 'WORK_DATE'      	, width: 100},
			{dataIndex: 'REMARK'         	, width: 120 }
		]
	});

	 //작업지시 바코드폼
  	var wkordBarcodeForm = Unilite.createSearchForm('wkordBarcodeForm', {
  		layout	: {type : 'uniTable', columns : 1},
  		tdAttrs	: {align: 'center'},
  		border:true,
		items	: [{xtype: 'component',
					border: true,
					id:'barcodeValue',
					padding: '0 0 0 0',
					margin:'0 0 0 75',
					hidden:false,
					height: 65,
					width: 350
		}]
  	});

	function openWkordBarcodeWindow() {
 		if(!wkordBarcodeWindow) {
 			wkordBarcodeWindow = Ext.create('widget.uniDetailWindow', {
 				title		: '작업지시바코드',
 				width		: 350,
 				height		: 140,
 				layout		:{type:'vbox', align:'stretch'},
 				tdAttrs	: {align: 'center'},
 				tbar:['->',{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.product.close" default="닫기"/>',
						handler: function() {
							wkordBarcodeWindow.hide();
						},
						disabled: false
					}
				],
 				items		: [wkordBarcodeForm],
 				listeners	: {
 					beforehide	: function(me, eOpt) {

 					},
 					beforeclose: function( panel, eOpts ) {

 					},
 					beforeshow: function ( me, eOpts ) {

 					},
					show: function(me, eOpts) {
						$("#barcodeValue").barcode(gsSelRecord.WKORD_NUM, "code128");
					}
 				}
 			})
 		}
 		wkordBarcodeWindow.center();
 		wkordBarcodeWindow.show();
 	}
	Unilite.Main( {
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
		id: 's_pmp270skrv_novisApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','save'], false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));

			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));

		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			masterGrid.getStore().loadStoreRecords();

		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onPrintButtonDown: function () {

            var selectedRecords = masterGrid.getSelectedRecords();

            // check 된 항목 확인
            if(Ext.isEmpty(selectedRecords)){
                Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                return;
            }
            
			var wkordNum    = '';  // 제조번호
			var progWorkNm  = '';  // 공정명
			var boxQty      = '';  // 용기수량
			var wholeWeight = '';  // 전체무게
			var boxWeight   = '';  // 용기무게
			var realWeight  = '';  // 실제무게
			var workDate    = '';  // 작업일자
			var remark      = '';  // 비고
			
			// 데이터 세팅
            Ext.each(selectedRecords, function(record, idx) {

				wkordNum    += ((idx == 0) ? '' : ',')  + record.get("WKORD_NUM");
				progWorkNm  += ((idx == 0) ? '' : ',')  + record.get("PROG_WORK_NAME");
				boxQty      += ((idx == 0) ? '' : ',')  + record.get("BOX_QTY");
				wholeWeight += ((idx == 0) ? '' : ',')  + record.get("WHOLE_WEIGHT");
				boxWeight   += ((idx == 0) ? '' : ',')  + record.get("BOX_WEIGHT");
				realWeight  += ((idx == 0) ? '' : ',')  + record.get("REAL_WEIGHT");
				workDate    += ((idx == 0) ? '' : ',')  + UniDate.getDbDateStr(record.get("WORK_DATE"));
				remark      += ((idx == 0) ? '' : ',')  + record.get("REMARK");
			});

			var param = panelResult.getValues();

			// 조회 param 값
			param.DIV_CODE       = panelResult.getValue('DIV_CODE');
            param.WORK_SHOP_CODE = panelResult.getValue('WORK_SHOP_CODE');
            
			param["dataCount"]      = selectedRecords.length;
			param["PROG_WORK_NAME"] = progWorkNm;
			param["WKORD_NUM"]      = wkordNum;
			param["BOX_QTY"]        = boxQty;
			param["WHOLE_WEIGHT"]   = wholeWeight;
			param["BOX_WEIGHT"]     = boxWeight;
			param["REAL_WEIGHT"]    = realWeight;
			param["WORK_DATE"]      = workDate;
			param["REMARK"]         = remark;
            param["PGM_ID"]         = PGM_ID;
            param["MAIN_CODE"]      = 'P010';  // 생산

            // 리포트 호출
        	win = Ext.create('widget.ClipReport', {
                url: CPATH+'/z_novis/s_pmp270clrkrv.do',
                prgID: 's_pmp270skrv_novis',
                extParam: param
            });

            win.center();
            win.show();
        }
	});
};


</script>
