<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp270skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp270skrv" /> 	  <!-- 사업장 -->
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

	Unilite.defineModel('pmp270skrvModel', {
		fields: [
	    	{name: 'WKORD_NUM'       	, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'  , type: 'string'},
	    	{name: 'WK_PLAN_NUM'       	, text: '<t:message code="system.label.product.productionplanno" default="생산계획번호"/>'  , type: 'string'},
			{name: 'ITEM_CODE'       	, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
			{name: 'ITEM_NAME'       	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},

			{name: 'CARE_REASON'       	, text: '관리대상품목사유'		, type: 'string'},

			{name: 'SPEC'            	, text: '<t:message code="system.label.product.spec" default="규격"/>'		, type: 'string'},
			{name: 'STOCK_UNIT'      	, text: '<t:message code="system.label.product.unit" default="단위"/>'		, type: 'string'},
			{name: 'WORK_END_YN'     	, text: '<t:message code="system.label.product.status" default="상태"/>'		, type: 'string' , comboType:'AU', comboCode:'P001'},

			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	, type: 'uniDate'},
			{name: 'PRODT_END_DATE'  	, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	, type: 'uniDate'},
			{name: 'WKORD_Q'         	, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'         	, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'JAN_PRODT_Q'        , text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'		, type: 'uniQty'},

			{name: 'ORDER_NUM'       	, text: '<t:message code="system.label.product.sono" default="수주번호"/>'		, type: 'string'},
			{name: 'ORDER_Q'         	, text: '<t:message code="system.label.product.soqty" default="수주량"/>'		, type: 'uniQty'},
			{name: 'DVRY_DATE'       	, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'REMARK2'         	, text: '<t:message code="system.label.product.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'  	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'},
			{name: 'WORK_SHOP_NAME'  	, text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'		, type: 'string'},
			{name: 'REMARK1'         	, text: '<t:message code="system.label.product.remarks" default="비고"/>'		, type: 'string'},
			{name: 'PROD_DRAW_YN'		, text: 'PROD_DRAW_YN'			, type: 'string'}

		]
	});

	var directMasterStore1 = Unilite.createStore('pmp270skrvMasterStore1',{
		model: 'pmp270skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'pmp270skrvService.selectList'
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
        	colspan:3,
        	width: 315,
        	startDate: UniDate.get('mondayOfWeek'),
        	endDate: UniDate.get('sundayOfNextWeek'),
        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_FR',newValue);
					// panelSearch.getField('ISSUE_REQ_DATE_FR').validate();

            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PRODT_START_DATE_TO',newValue);
		    		// panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
		    	}
		    }
		},{
	            xtype: 'container',
	            layout: {type : 'uniTable', columns : 2},
	            margin      : '0 0 0 100',
	            width:400,
	            items :[{
			            xtype       : 'button',
			            text        : '<div style="color: blue"><t:message code="system.label.product.packagingorder" default="포장지시서"/></div>',
			            width       : 120,
			            margin      : '0 0 2 10',
			            itemId:'btnPrint1',
			            tdAttrs     : {align: 'left'},
			            handler     : function(btn) {

			            	if(BsaCodeInfo.gsSiteCode == 'NOVIS' || BsaCodeInfo.gsSiteCode == 'COV'){
								UniAppManager.app.onPrintButtonDown();
							}else{
				            	var selectedRecords = masterGrid.getSelectedRecords();

				                if(Ext.isEmpty(selectedRecords)){
				                    Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
				                    return;
				                }

				                var wkordNumList;

				                Ext.each(selectedRecords, function(record, idx) {
				                    if(idx ==0) {
				                        wkordNumList= record.get("WKORD_NUM");
				                    } else {
				                        wkordNumList= wkordNumList  + ',' + record.get("WKORD_NUM");
				                    }

				                });

				                var param = panelResult.getValues();

				                param["WKORD_NUM"] = wkordNumList;
				                param["dataCount"] = selectedRecords.length;
				                param["USER_LANG"] = UserInfo.userLang;
				                param["PGM_ID"]= PGM_ID;
				                param["MAIN_CODE"] = 'P010';  //생산용 공통 코드

				                win = Ext.create('widget.ClipReport', {
				                    url: CPATH+'/prodt/pmp260clrkrv_1.do',
				                    prgID: 'pmp270skrv',
				                    extParam: param
				                });

				                win.center();
				                win.show();
							}
				        }
				    },{
				        xtype       : 'button',
				        text        : '<div style="color: red"><t:message code="system.label.product.mfgorder" default="제조지시서"/></div>',
				        width       : 120,
				        margin      : '0 0 2 15',
			            itemId:'btnPrint2',
				        tdAttrs     : {align: 'right'},
				        handler     : function(btn) {
				            var selectedRecords = masterGrid.getSelectedRecords();
							var isErr = false;
							var errItemCode = '';
							var errItemName = '';

				            if(Ext.isEmpty(selectedRecords)){
				                Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
				                return;
				            }
				            /* Ext.each(selectedRecords, function(record,i){
			                	 if(record.get('PROD_DRAW_YN') == 'N'){
			                		 errItemCode = record.get('ITEM_CODE');
			                		 errItemName = record.get('ITEM_NAME');
			                		 isErr = true;
			                		 return false;
			                	 }
                           });
						  if(isErr == true){
							  alert('품목 ' + errItemCode  + '[' + errItemName + ']의\n공정도가 등록돼 있지 않습니다.');
							  return false;
						  } */
				            var wkordNumList;

				            Ext.each(selectedRecords, function(record, idx) {
				                if(idx ==0) {
				                    wkordNumList= record.get("WKORD_NUM");
				                } else {
				                    wkordNumList= wkordNumList  + ',' + record.get("WKORD_NUM");
				                }

				            });

				            var param = panelResult.getValues();

				            param["WKORD_NUM"] = wkordNumList;
				            param["dataCount"] = selectedRecords.length;
				            param["USER_LANG"] = UserInfo.userLang;
				            param["PGM_ID"]= PGM_ID;
				            param["MAIN_CODE"] = 'P010';  //생산용 공통 코드

				            win = Ext.create('widget.ClipReport', {
				                url: CPATH+'/prodt/pmp260clrkrv_2.do',
				                prgID: 'pmp270skrv',
				                extParam: param
				            });

				            win.center();
				            win.show();
				    }
				}]
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
//    				colspan:2,
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
         	}),
				{  xtype: 'container',
	            layout: {type : 'uniTable', columns : 2},
	            margin      : '0 0 0 100',
	            width:400,
	            items :[{
	                    xtype       : 'button',
	                    text        : '<div style="color: red"><t:message code="system.label.product.weighingorder" default="칭량지시서"/></div>',
	                    width       : 120,
	                    margin      : '0 0 2 10',
			            itemId:'btnPrint3',
	                    tdAttrs     : {align: 'left'},
	                    handler     : function(btn) {
	                        var selectedRecords = masterGrid.getSelectedRecords();

	                        if(Ext.isEmpty(selectedRecords)){
	                            Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
	                            return;
	                        }

	                        var wkordNumList;

	                        Ext.each(selectedRecords, function(record, idx) {
	                            if(idx ==0) {
	                                wkordNumList= record.get("WKORD_NUM");
	                            } else {
	                                wkordNumList= wkordNumList  + ',' + record.get("WKORD_NUM");
	                            }

	                        });

	                        var param = panelResult.getValues();

	                        param["WKORD_NUM"] = wkordNumList;
	                        param["dataCount"] = selectedRecords.length;
	                        param["USER_LANG"] = UserInfo.userLang;
	                        param["PGM_ID"]= 'pmp260ukrv_3';
	                        param["MAIN_CODE"] = 'P010';  //생산용 공통 코드

	                        win = Ext.create('widget.ClipReport', {
	                            url: CPATH+'/prodt/pmp260clrkrv_3.do',
	                            prgID: 'pmp270skrv',
	                            extParam: param
	                        });

	                        win.center();
	                        win.show();
	                }
	            },{
	                xtype       : 'button',
	                text        : '<div style="color: red"><t:message code="system.label.product.mfgorder" default="제조지시서"/><t:message code="system.label.product.old" default="(구)"/></div>',
	                width       : 120,
	                margin      : '0 0 2 15',
			        itemId:'btnPrint4',
	                tdAttrs     : {align: 'right'},
	                handler     : function(btn) {
	                    var selectedRecords = masterGrid.getSelectedRecords();
	                    var isErr = false;
						var errItemCode = '';
						var errItemName = '';

	                    if(Ext.isEmpty(selectedRecords)){
	                        Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
	                        return;
	                    }

	                    var wkordNumList;

	                    Ext.each(selectedRecords, function(record, idx) {
	                        if(idx ==0) {
	                            wkordNumList= record.get("WKORD_NUM");
	                        } else {
	                            wkordNumList= wkordNumList  + ',' + record.get("WKORD_NUM");
	                        }

	                    });

	                    var param = panelResult.getValues();

	                    param["WKORD_NUM"] = wkordNumList;
	                    param["dataCount"] = selectedRecords.length;
	                    param["USER_LANG"] = UserInfo.userLang;
	                    param["PGM_ID"]= PGM_ID;
	                    param["MAIN_CODE"] = 'P010';  //생산용 공통 코드

	                    win = Ext.create('widget.ClipReport', {
	                        url: CPATH+'/prodt/pmp260clrkrv_4.do',
	                        prgID: 'pmp270skrv',
	                        extParam: param
	                    });

	                    win.center();
	                    win.show();
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
		},{
	            xtype: 'container',
	            layout: {type : 'uniTable', columns : 2},
	            margin      : '0 0 0 100',
	            width:400,
	            items :[{
			            xtype       : 'button',
			            text        : '<div style="color: red"><t:message code="system.label.product.submaterialsqtyrequest" default="부자재소요량청구"/></div>',
				        width       : 120,
				        margin      : '0 0 2 10',
			            itemId:'btnPrint5',
				        tdAttrs     : {align: 'left'},
				        handler     : function(btn) {
				        	var param = panelResult.getValues();
				            var selectedRecords = masterGrid.getSelectedRecords();
							var itemPrint = "";

				            param["PGM_ID"]= 'mtr260skrv';
				            param["MAIN_CODE"] = 'M030';

				            if(Ext.isEmpty(selectedRecords)){
				                Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
				                return;
				            }
				            var wkordNumList;

				            Ext.each(selectedRecords, function(record, idx) {
				                if(idx ==0) {
				                    itemPrint= record.get("WKORD_NUM");
				                } else {
				                    itemPrint= itemPrint  + ',' + record.get("WKORD_NUM");
				                }

				            });

				            param.ITEM_PRINT = itemPrint;

							var win = Ext.create('widget.ClipReport', {
								url: CPATH+'/matrl/mtr260clskrv.do',
								prgID: 'mtr260skrv',
								extParam: param
							});

				            win.center();
				            win.show();

				        }
			    }]
		}]

    });

	var masterGrid = Unilite.createGrid('pmp270skrvGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
		uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst:false,
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

			    		//UniAppManager.setToolbarButtons('print',true);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					if (this.selected.getCount() == 0) {
			    		//UniAppManager.setToolbarButtons('print',false);
					}
				}
			}
		}),
		columns: [

			{dataIndex: 'WKORD_NUM'       	, width: 130},
			{  text: '작업지시',
				width: 100,
				xtype: 'widgetcolumn',
				widget: {
					xtype: 'button',
					text: '바코드',
					listeners: {
						buffer:1,
						click: function(button, event, eOpts) {
							gsSelRecord = event.record.data;
							openWkordBarcodeWindow();
						}
					}
				}
			},
			{dataIndex: 'WK_PLAN_NUM'       , width: 130},
			{dataIndex: 'ITEM_CODE'       	, width: 120},
			{dataIndex: 'ITEM_NAME'       	, width: 200},
			{dataIndex: 'CARE_REASON'       	, width: 200},
			{dataIndex: 'SPEC'            	, width: 80},
			{dataIndex: 'STOCK_UNIT'      	, width: 50,align:'center'},
			{dataIndex: 'WORK_END_YN'     	, width: 50,align:'center'},
			{dataIndex: 'PRODT_START_DATE'	, width: 100},
			{dataIndex: 'PRODT_END_DATE'  	, width: 100},
			{dataIndex: 'WKORD_Q'         	, width: 100, summaryType: 'sum'},
			{dataIndex: 'PRODT_Q'        	, width: 100, summaryType: 'sum'},
			{dataIndex: 'JAN_PRODT_Q'       , width: 100, summaryType: 'sum'},


			{dataIndex: 'ORDER_NUM'      	, width: 120},
			{dataIndex: 'ORDER_Q'         	, width: 100},
			{dataIndex: 'DVRY_DATE'       	, width: 100},
			{dataIndex: 'REMARK1'        	, width: 250},
			{dataIndex: 'REMARK2'         	, width: 66 ,hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'  	, width: 66	,hidden: true},
			{dataIndex: 'WORK_SHOP_NAME'  	, width: 66	,hidden: true},
			{dataIndex: 'PROD_DRAW_YN'			, width: 50 , hidden: true}
		]
	});

	 //작업지시 바코드폼
  	var wkordBarcodeForm = Unilite.createSearchForm('wkordBarcodeForm', {
  		layout	: {type : 'uniTable', columns : 1},
  		tdAttrs	: {align: 'center'},
  		border:true,
  		items	: [{		xtype: 'component',
									border: true,
									id:'barcodeValue',
									padding: '0 0 0 0',
									margin:'0 0 0 75',
									hidden:false,
									height: 65,
									width: 350
									//tdAttrs: {style: 'border-top: 1px; border:solid; #cccccc;padding-top: 2px;' }
					}]
  	});

	function openWkordBarcodeWindow() {
 		//if(!UniAppManager.app.checkForNewDetail()) return false;
 		if(!wkordBarcodeWindow) {
 			wkordBarcodeWindow = Ext.create('widget.uniDetailWindow', {
 				title		: '작업지시바코드',
 				width		: 350,
 				height		: 140,
 		 		//resizable	: false,
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
		id: 'pmp270skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','save'], false);

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));

			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
			panelResult.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));

			if(BsaCodeInfo.gsSiteCode == 'NOVIS' || BsaCodeInfo.gsSiteCode == 'COV'){
				panelResult.down('#btnPrint1').setText('<div style="color: blue">작업지시서</div>');
				panelResult.down('#btnPrint2').setHidden(true);
				panelResult.down('#btnPrint4').setHidden(true);


			}
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

            if(Ext.isEmpty(selectedRecords)){
                Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                return;
            }

			var wkordNumList;
			Ext.each(selectedRecords, function(record, idx) {
				if(idx ==0) {
					wkordNumList= record.get("WKORD_NUM");
				} else {
					wkordNumList= wkordNumList	+ ',' + record.get("WKORD_NUM");
				}

			});

			var param = panelResult.getValues();

			param["WKORD_NUM"] = wkordNumList;
			param["dataCount"] = selectedRecords.length;
            param["USER_LANG"] = UserInfo.userLang;
            param["PGM_ID"]= PGM_ID;
            param["MAIN_CODE"] = 'P010';  //생산용 공통 코드

            param["sTxtValue2_fileTitle"]='작업지시서';

        	win = Ext.create('widget.ClipReport', {
                url: CPATH+'/prodt/pmp190clrkrv.do',
                prgID: 'pmp270skrv',
                extParam: param
            });

            win.center();
            win.show();
        }
	});
};


</script>
