<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_biv361skrv_jw"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_biv361skrv_jw"  />          <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
    <t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
    <t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
    <t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
    <t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
    <t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
    <t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
    <t:ExtComboStore comboType="OU" />								<!-- 창고-->
	<t:ExtComboStore comboType="WU" />								<!-- 작업장-->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('S_biv361skrv_jwModel1', {
        fields: [	{name: 'ITEM_ACCOUNT',				text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',			type: 'string', comboType: 'AU', comboCode: 'B020'},
                 	{name: 'ITEM_CODE',					text: '<t:message code="system.label.inventory.item" default="품목"/>',					type: 'string'},
	    			{name: 'ITEM_NAME',					text: '<t:message code="system.label.inventory.itemname2" default="품명"/>',				type: 'string'},
	    			{name: 'SPEC',						text: '<t:message code="system.label.inventory.spec" default="규격"/>',					type: 'string'},
	    			{name: 'STOCK_UNIT',				text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type: 'string'},
	    			{name: 'INOUT_DATE',				text: '<t:message code="system.label.inventory.transdate" default="수불일"/>',				type: 'uniDate'},
	    			{name: 'IN_Q',						text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>',			type: 'uniQty'},
	    			{name: 'OUT_Q',						text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>',				type: 'uniQty'},
	    			{name: 'RTN_Q',						text: '<t:message code="system.label.inventory.returnqty" default="반품량"/>',				type: 'uniQty'},
	    			{name: 'INOUT_CODE_TYPE',			text: '<t:message code="system.label.inventory.tranplacedivision" default="수불처구분"/>',	type: 'string', comboType: 'AU', comboCode: 'B005'},
	    			{name: 'INOUT_CODE_NAME',			text: '<t:message code="system.label.inventory.tranplace" default="수불처"/>',	 			type: 'string'},
	    			{name: 'DIV_CODE_NAME',				text: '<t:message code="system.label.inventory.trandivision" default="수불사업장"/>',		type: 'string'},
	    			{name: 'WH_CODE_CODE',				text: '<t:message code="system.label.inventory.tranwarehousecode" default="수불창고코드"/>',	type: 'string'},
	    			{name: 'WH_CODE_NAME',				text: '<t:message code="system.label.inventory.tranwarehouse" default="수불창고"/>',		type: 'string'},
	    			{name: 'INOUT_TYPE_DETAIL_NAME',	text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>',				type: 'string'},
	    			{name: 'INOUT_PRSN',				text: '<t:message code="system.label.inventory.trancharger" default="수불담당자"/>',			type: 'string', comboType: 'AU', comboCode: 'B024'},
	    			{name: 'INOUT_NUM',					text: '<t:message code="system.label.inventory.tranno" default="수불번호"/>',				type: 'string'},
	    			{name: 'INOUT_SEQ',					text: '<t:message code="system.label.inventory.transeq" default="수불순번"/>',				type: 'int'},
	    			{name: 'LOT_NO',					text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',				type: 'string'},
	    			{name: 'MAKE_DATE',					text: '<t:message code="system.label.inventory.mfgdate" default="제조일"/>',				type: 'uniDate'},
	    			{name: 'MAKE_LOT_NO',				text: '<t:message code="system.label.inventory.mfglot" default="제조LOT"/>',				type: 'string'},
	    			{name: 'ORDER_NUM',					text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',		type: 'string'},
	    			{name: 'INSERT_DB_TIME',			text: '<t:message code="system.label.inventory.inputdate" default="입력일"/>',				type: 'uniDate'}

            ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_biv361skrv_jwMasterStore1',{
        model: 'S_biv361skrv_jwModel1',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi: false          // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                   read: 's_biv361skrv_jwService.selectList1'
            }
        }
        ,loadStoreRecords: function()   {
            var param= Ext.getCmp('searchForm').getValues();
            param.WH_CODE = panelResult.getValue('WH_CODE');
            param.ITEM_CODE = panelResult.getValue('ITEM_CODE');
            param.ITEM_NAME = panelResult.getValue('ITEM_NAME');
            param.LOT_NO = panelResult.getValue('LOT_NO');
            console.log( param );
            this.load({
                params: param
            });
        },

		listeners:{
			load:function( store, records, successful, operation, eOpts )	{
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				}
			}
        }
    });

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
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
            layout: {type: 'vbox', align: 'stretch'},
            items: [{
                xtype: 'container',
                layout: {type: 'uniTable', columns:1},
                items: [{
                    fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
                    name: 'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType: 'BOR120',
                    value: UserInfo.divCode,
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {
                            combo.changeDivCode(combo, newValue, oldValue, eOpts);
                            var field = panelResult.getField('INOUT_PRSN');
                            field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                }, {
                    fieldLabel: '<t:message code="system.label.inventory.transdate" default="수불일"/>',
                    width: 315,
                    xtype: 'uniDateRangefield',
                    startFieldName: 'INOUT_DATE_FR',
                    endFieldName: 'INOUT_DATE_TO',
                    //startDate: UniDate.get('startOfMonth'),
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('INOUT_DATE_FR',newValue);
                            //panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('INOUT_DATE_TO',newValue);
                            //panelResult.getField('ISSUE_REQ_DATE_TO').validate();
                        }
                    }
                },{
    				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
    				name:'WH_CODE',
    				xtype: 'uniCombobox',
    				comboType   : 'OU',
    				listeners: {
    				change: function(field, newValue, oldValue, eOpts) {
    					panelResult.setValue('WH_CODE', newValue);
    				},beforequery:function( queryPlan, eOpts )   {
                    	var store = queryPlan.combo.store;
                    	var store2 = panelResult.getField('WH_CODE').getStore();
                    	store.clearFilter();
                    	store2.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                        	store.filterBy(function(record){
                            	return record.get('option') == panelSearch.getValue('DIV_CODE');
                            })
                            store2.filterBy(function(record){
                            	return record.get('option') == panelSearch.getValue('DIV_CODE');
                            })
                        }else{
                        	store.filterBy(function(record){
                            	return false;
    						})
    						store2.filterBy(function(record){
                            	return false;
    						})
                        }
                    },
    			}
    		},
    		Unilite.popup('DIV_PUMOK',{
    			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
    			valueFieldName: 'ITEM_CODE',
    			textFieldName: 'ITEM_NAME',
    			validateBlank: false,
    			autoPopup: true,
    			listeners: {
    				applyextparam: function(popup){
    					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
    				},onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					}
    			}
    		}),{
                    fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'  ,
                    name: 'INOUT_PRSN',
                    xtype: 'uniCombobox',
                    comboType: 'AU',
                    comboCode: 'B024',
                    hidden:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('INOUT_PRSN', newValue);
                        }
                    },
                    onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                         if(eOpts){
                            combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                        }else{
                            combo.divFilterByRefCode('refCode1', newValue, divCode);
                        }
                    }
                }, {
                    fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
                    name: 'ITEM_ACCOUNT',
                    xtype: 'uniCombobox',
                    comboType: 'AU',
                    comboCode: 'B020',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('ITEM_ACCOUNT', newValue);
                        }
                    }
                },
        		Unilite.popup('LOT_NO',{
        			fieldLabel: 'LOT NO',
        			holdable: 'hold',
        			validateBlank:false,
        			valueFieldName: 'LOT_NO',
        			listeners: {
        				onSelected: {
        					fn: function(records, type) {
        						console.log('records : ', records);
        						panelResult.setValue('LOT_NO',records[0].LOT_NO);
//        						panelResult.setValue('ITEM_CODE', records[0].ITEM_CODE);
//        						panelResult.setValue('ITEM_NAME', records[0].ITEM_NAME);
        					},
        					scope: this
        				},
        				applyextparam: function(popup){
        					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
//        					popup.setExtParam({'ITEM_CODE': panelResult.getValue('ITEM_CODE')});
//        					popup.setExtParam({'ITEM_NAME': panelResult.getValue('ITEM_NAME')});
        				}
        			}
        		})]
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                }
            }
            return r;
        }
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            value: UserInfo.divCode,
            allowBlank: false,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
                    var field = panelSearch.getField('INOUT_PRSN');
                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
                    panelSearch.setValue('DIV_CODE', newValue);
                    panelResult.setValue('WH_CODE','');
                }
            }
        },{
            fieldLabel: '<t:message code="system.label.inventory.transdate" default="수불일"/>',
            width: 315,
            xtype: 'uniDateRangefield',
            allowBlank: false,
            startFieldName: 'INOUT_DATE_FR',
            endFieldName: 'INOUT_DATE_TO',
            //startDate: UniDate.get('startOfMonth'),
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('INOUT_DATE_FR',newValue);
                    //panelSearch.getField('ISSUE_REQ_DATE_FR').validate();

                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('INOUT_DATE_TO',newValue);
                    //panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
                }
            }
        },{		fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				comboType   : 'OU',
				colspan	 : 2,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				},beforequery:function( queryPlan, eOpts )   {
                	var store = queryPlan.combo.store;
                	store.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                    	store.filterBy(function(record){
                        	return record.get('option') == panelResult.getValue('DIV_CODE');
                        })
                    }else{
                    	store.filterBy(function(record){
                        	return false;
						})
                    }
                },
			}
		},
	,
	Unilite.popup('DIV_PUMOK',{
		fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
		valueFieldName: 'ITEM_CODE',
		textFieldName: 'ITEM_NAME',
		validateBlank: false,
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
            fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'  ,
            name: 'INOUT_PRSN',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B024',
            hidden:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('INOUT_PRSN', newValue);
                }
            },
            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                if(eOpts){
                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                }else{
                    combo.divFilterByRefCode('refCode1', newValue, divCode);
                }
            }
        }, {
            fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('ITEM_ACCOUNT', newValue);
                }
            }
        },
		Unilite.popup('LOT_NO',{
			fieldLabel: 'LOT NO',
			holdable: 'hold',
			validateBlank:false,
			valueFieldName: 'LOT_NO',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelSearch.setValue('LOT_NO',records[0].LOT_NO);
//						panelResult.setValue('ITEM_CODE', records[0].ITEM_CODE);
//						panelResult.setValue('ITEM_NAME', records[0].ITEM_NAME);
					},
					scope: this
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					//					popup.setExtParam({'ITEM_CODE': panelResult.getValue('ITEM_CODE')});
					//					popup.setExtParam({'ITEM_NAME': panelResult.getValue('ITEM_NAME')});
				}
			}
		})
        /*,{
            fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
            name: 'TXT_CREATE_LOC',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B031',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('TXT_CREATE_LOC', newValue);
                }
            }
        }*/]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('s_biv361skrv_jwGrid1', {
        // for tab
        region: 'center',
        //layout: 'fit',
        syncRowHeight: false,
        store: directMasterStore1,
        tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary', value:0, decimalPrecision:4, format:'0,000.0000'}],
        features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id: 'masterGridTotal',     ftype: 'uniSummary',  showSummaryRow: false} ],
        columns:  [
                    {dataIndex: 'ITEM_ACCOUNT',			width: 93,	locked:false, align:'center',
        				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
        					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.total" default="총계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
        				}
        			},
        			{dataIndex: 'ITEM_CODE',				width: 110,	locked:false},
        			{dataIndex: 'ITEM_NAME',				width: 150,	locked:false},
        			{dataIndex: 'SPEC',						width: 120,	hidden:false, align:'center'},
        			{dataIndex: 'STOCK_UNIT',				width: 66,	locked:false, align:'center'},
        			{dataIndex: 'INOUT_DATE',				width: 80,	locked:false},
        			//{dataIndex: 'STOCK_Q',  				width: 86},
        			{dataIndex: 'IN_Q',  					width: 86,	summaryType: 'sum'},
        			{dataIndex: 'OUT_Q',					width: 86,	summaryType: 'sum'},
        			{dataIndex: 'RTN_Q',					width: 86,	summaryType: 'sum'},
        			{dataIndex: 'INOUT_CODE_TYPE',			width: 100, align:'center'},
        			{dataIndex: 'INOUT_CODE_NAME',			width: 150},
        			{dataIndex: 'DIV_CODE_NAME',			width: 100, hidden:true },
        			{dataIndex: 'WH_CODE_CODE',				width: 85,	 hidden:false, align:'center'}, //
        			{dataIndex: 'WH_CODE_NAME',				width: 150},//
        			{dataIndex: 'INOUT_TYPE_DETAIL_NAME',	width: 150},//
        			{dataIndex: 'INOUT_PRSN',			width: 120,	hidden:false},//
        			{dataIndex: 'INOUT_NUM',				width: 120,	hidden:false},//
        			{dataIndex: 'INOUT_SEQ',				width: 73,	 hidden:true },//
        			{dataIndex: 'LOT_NO',					width: 106},
					{dataIndex: 'MAKE_DATE',				width: 80 ,	hidden:true},
        			{dataIndex: 'MAKE_LOT_NO',				width: 120,	hidden:true},
        			{dataIndex: 'ORDER_NUM',				width: 120,	hidden:false},
        			{dataIndex: 'INSERT_DB_TIME',			width: 150}
          ] ,
          listeners:{
          	selectionchange:function( grid, selection, eOpts )	{

          		if(selection && selection.startCell)	{
//          			var columnName = "SUM_SALE_AMT_WON";
          			var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
//          			if(selection.startCell.column.dataIndex==columnName && selection.endCell.column.dataIndex==columnName)	{
          			if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
	          			var sum = 0;

	          			for(var i=startIdx; i <= endIdx; i++){
	          				var record = store.getAt(i);
	          				sum += record.get(columnName);
	          			}
	          			displayField.setValue(sum);
	          		} else {
	          			displayField.setValue(0);
	          		}
          		}
          	}, afterrender: function(grid) {
           /*      var me = this;

                this.contextMenu = Ext.create('Ext.menu.Menu', {});
                this.contextMenu.add(
                    {
                        text: '매출등록 바로가기',   iconCls : '',
                        handler: function(menuItem, event) {
                            var record = grid.getSelectedRecord();
                            var params = {
                                    sender: me,
                                    'PGM_ID': 's_biv361skrv_jw',
                                    COMP_CODE: UserInfo.compCode,
                                    DIV_CODE: panelResult.getValue('DIV_CODE'),
                                    BILL_NUM: record.data.BILL_NUM
                                }
                                var rec = {data : {prgID : 'ssa100ukrv', 'text':''}};
                                parent.openTab(rec, '/sales/ssa100ukrv.do', params);
                        }
                    }
                ); */
            }
          }
    });
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
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('INOUT_DATE_FR', UniDate.get('today'));
            panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));


            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('INOUT_DATE_FR', UniDate.get('today'));
            panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));

			UniAppManager.setToolbarButtons('reset',true);
            var field = panelSearch.getField('INOUT_PRSN');
            field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
            var field = panelResult.getField('INOUT_PRSN');
            field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
        },
        onQueryButtonDown: function()   {
            if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
            directMasterStore1.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        onDetailButtonDown: function() {
            var as = Ext.getCmp('AdvanceSerch');
            if(as.isHidden())   {
                as.show();
            }else {
                as.hide()
            }
        },
        onResetButtonDown: function() {
        	this.suspendEvents();
        	panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.getStore().loadData({})
            this.fnInitBinding();

        }
    });

};


</script>
