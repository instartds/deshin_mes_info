<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="biv305skrv"  >
    <t:ExtComboStore comboType="BOR120" pgmId="biv305skrv"  />          <!-- 사업장 -->
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
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!--창고-->
    <t:ExtComboStore comboType="WU" />    <!--작업장(사용여부 Y) -->
    <t:ExtComboStore comboType="OU" />   <!--창고(사용여부 Y) -->
    <t:ExtComboStore comboType="O" />   <!--창고 -->
    <t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" /><!--창고Cell-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('Biv305skrvModel1', {
    	fields: [
	    	{name: 'LOT_NO', 		text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',					type: 'string'},
			{name: 'LOCATION', 		text: '<t:message code="system.label.inventory.location" default="위치"/>',					type: 'string'},
			{name: 'WH_CODE',		text: '<t:message code="system.label.inventory.warehouse" default="창고코드"/>',				type: 'string'},
			{name: 'WH_NAME',		text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>',			type: 'string'},
			{name: 'WH_CELL_CODE',	text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',			type: 'string'},
			{name: 'WH_CELL_NAME',	text: '<t:message code="system.label.inventory.warehousecellname" default="창고Cell명"/>',	type: 'string'},
			{name: 'ITEM_ACCOUNT',  text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',					type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_CODE', 	text: '<t:message code="system.label.inventory.item" default="품목"/>',						type: 'string'},
			{name: 'ITEM_NAME'	, 	text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',					type: 'string'},
			{name: 'SPEC', 			text: '<t:message code="system.label.inventory.spec" default="규격"/>',						type: 'string'},
			{name: 'STOCK_UNIT', 	text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'},
			{name: 'STOCK_Q', 		text: '<t:message code="system.label.inventory.onhandqty" default="현재고량"/>',				type: 'uniQty'},
			{name: 'BASIS_Q', 		text: '<t:message code="system.label.inventory.basicinventoryqty" default="기초재고량"/>',		type: 'uniQty'},
			{name: 'IN_Q', 			text: '<t:message code="system.label.inventory.receiptqty" default="입고량"/>',				type: 'uniQty'},
			{name: 'RETURN_Q', 		text: '<t:message code="system.label.inventory.returnqty" default="반품량"/>',				type: 'uniQty'},
			{name: 'OUT_Q', 		text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>',					type: 'uniQty'},
			{name: 'EXPIRATION_DAY',text: '<t:message code="system.label.sales.availableperiod" default="유효기간"/>',				type: 'uniDate'}
			
			]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('biv305skrvMasterStore1',{
        model: 'Biv305skrvModel1',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi: false          // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                   read: 'biv305skrvService.selectList1'
            }
        }
        ,loadStoreRecords: function()   {
            var param= Ext.getCmp('searchForm').getValues();
//          var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
//          var deptCode = UserInfo.deptCode;   //부서코드
//          if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
//              param.DEPT_CODE = deptCode;
//          }
            console.log( param );
            this.load({
                params: param
            });
        },
		listeners:{
			load:function( store, records, successful, operation, eOpts )	{
				/* if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
				} */
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
                    fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
                    name: 'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType: 'BOR120',
                    child:'WH_CODE',
                    allowBlank: false,
                    value: UserInfo.divCode,
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {
                                  panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{
    				fieldLabel:'일자',
                    xtype: 'uniDatefield',
                    name: 'TO_DATE',
                    value: UniDate.get('today'),
    				allowBlank: false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('TO_DATE', newValue);
                        }
                    }
    			},{
    				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
    				name: 'WH_CODE',
    				xtype: 'uniCombobox',
    				child: 'WH_CELL_CODE',
    				allowBlank: false,
					//20200305 추가: 멀티선택
					multiSelect: true,
    				store: Ext.data.StoreManager.lookup('whList'),
    	//			multiSelect:true,
    				listeners: {
    					change: function(field, newValue, oldValue, eOpts) {
    						panelResult.setValue('WH_CODE', newValue);
    					}
    				}
    			},{
		            fieldLabel: '<t:message code="system.label.inventory.issuewarehousecell" default="창고cell"/>',
		            name: 'WH_CELL_CODE',
		            fieldWidth: 150,
		            xtype:'uniCombobox',
					//20200305 추가: 멀티선택
					multiSelect: true,
		            store: Ext.data.StoreManager.lookup('whCellList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CELL_CODE', newValue);
						}
					}
//		            multiSelect:true
		        },{
		            fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
		            name: 'ITEM_ACCOUNT',
		            fieldWidth: 150,
		            xtype:'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					multiSelect: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
		        },
    			Unilite.popup('DIV_PUMOK',{
    				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
    				valueFieldName: 'ITEM_CODE',
    				textFieldName: 'ITEM_NAME',
    				validateBlank: false,
    				listeners: {
    					onValueFieldChange: function(field, newValue){
    						panelResult.setValue('ITEM_CODE', newValue);
    					},
    					onTextFieldChange: function(field, newValue){
    						panelResult.setValue('ITEM_NAME', newValue);
    					},
    					applyextparam: function(popup){
    						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
    					}
    				}
    			}), {
    	            fieldLabel: 'LOT_NO',
    	            name: 'LOT_NO',
    	            xtype: 'uniTextfield',
    	            hidden: false,
    				listeners: {
    					change: function(field, newValue, oldValue, eOpts) {
    						panelResult.setValue('LOT_NO', newValue);
    					}
    				}
    	        }, {
    	            fieldLabel: '<t:message code="system.label.inventory.spec" default="규격"/>',
    	            name: 'SPEC',
    	            xtype: 'uniTextfield',
    	            hidden: false,
    				listeners: {
    					change: function(field, newValue, oldValue, eOpts) {
    						panelResult.setValue('SPEC', newValue);
    					}
    				}
    	        },{
    				xtype		: 'radiogroup',
    				fieldLabel	: '<t:message code="system.label.inventory.stocktype" default="재고구분"/>',
    				name		: 'STOCK_YN',
    				width  		: 250,
    				holdable	: 'hold',
    				items		: [{
    					boxLabel	: '<t:message code="system.label.inventory.whole" default="전체"/>',
    					name		: 'STOCK_YN',
    					inputValue	: 'ALL'
    				},{
    					boxLabel	: '재고(유)',
    					name		: 'STOCK_YN',
    					inputValue	: 'NOT_ZERO',
    					checked: true
    				}],
    				listeners: {
    					change: function(field, newValue, oldValue, eOpts) {
    						panelResult.getField('STOCK_YN').setValue(newValue.STOCK_YN);
    					}
    				}
    			}]
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
        layout : {type : 'uniTable', columns : 5},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            child:'WH_CODE',
            allowBlank: false,
            value: UserInfo.divCode,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },{
			fieldLabel:'일자',
            xtype: 'uniDatefield',
            name: 'TO_DATE',
            value: UniDate.get('today'),
			allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                	panelSearch.setValue('TO_DATE', newValue);
                }
            }
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			child: 'WH_CELL_CODE',
			allowBlank: false,
			//20200305 추가: 멀티선택
			multiSelect: true,
			store: Ext.data.StoreManager.lookup('whList'),
//			multiSelect:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
            fieldLabel: '<t:message code="system.label.inventory.issuewarehousecell" default="창고cell"/>',
            name: 'WH_CELL_CODE',
            fieldWidth: 150,
            xtype:'uniCombobox',
			//20200305 추가: 멀티선택
			multiSelect: true,
            store: Ext.data.StoreManager.lookup('whCellList'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CELL_CODE', newValue);
				}
			}
//            multiSelect:true
        },{
            fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
            name: 'ITEM_ACCOUNT',
            fieldWidth: 150,
            xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			multiSelect: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
        },
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
            fieldLabel: '<t:message code="system.label.inventory.spec" default="규격"/>',
            name: 'SPEC',
            xtype: 'uniTextfield',
            hidden: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SPEC', newValue);
				}
			}
        }, {
            fieldLabel: 'LOT_NO',
            name: 'LOT_NO',
            xtype: 'uniTextfield',
            hidden: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('LOT_NO', newValue);
				}
			}
        },{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.inventory.stocktype" default="재고구분"/>',
			name		: 'STOCK_YN',
			holdable	: 'hold',
			width  		: 250,
			colspan     : 2,
			items		: [{
				boxLabel	: '<t:message code="system.label.inventory.whole" default="전체"/>',
				name		: 'STOCK_YN',
				inputValue	: 'ALL'
			},{
				boxLabel	: '재고(유)',
				name		: 'STOCK_YN',
				inputValue	: 'NOT_ZERO',
				checked: true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('STOCK_YN').setValue(newValue.STOCK_YN);
				}
			}
		}]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('biv305skrvGrid1', {
        // for tab
        region: 'center',
        //layout: 'fit',
        syncRowHeight: false,
        store: directMasterStore1,
        uniOpt:{
			useLiveSearch		: true,			//20200305 추가: 그리드 찾기기능 추가
        	filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        //tbar:[{xtype:'uniNumberfield', labelWidth: 110, fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>', id:'selectionSummary', value:0, decimalPrecision:4, format:'0,000.0000'}],
        features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id: 'masterGridTotal',     ftype: 'uniSummary',  showSummaryRow: true} ],
        columns:  [  {dataIndex: 'DIV_CODE',           width: 80, hidden: true},
	                     {dataIndex: 'WH_CODE',           width: 80},        //창고
	                     {dataIndex: 'WH_NAME',           width: 130,
	         				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	        					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
	        				}

	                     },        //창고
	                 	 {dataIndex: 'WH_CELL_CODE',	width: 85},
	        			 {dataIndex: 'WH_CELL_NAME',	width: 130},
	                     {dataIndex: 'LOCATION' ,          width: 180},           //위치
	                     {dataIndex: 'ITEM_ACCOUNT',         width: 123},
	            		 {dataIndex: 'ITEM_CODE',         width: 123},      	   //품목코드
	                     {dataIndex: 'ITEM_NAME',         width: 250 },        //품명
	                     {dataIndex: 'SPEC',					width: 250 },
	                     {dataIndex: 'LOT_NO',           	width: 100, align: 'center'},
	         			 {dataIndex: 'STOCK_UNIT',		width: 66,  align: 'center'},
	         		     {dataIndex: 'BASIS_Q',           	width: 100, summaryType: 'sum'},       	//기초재고량
	                     {dataIndex: 'IN_Q',           		width: 100, summaryType: 'sum'},       		//입고량
	                     {dataIndex: 'RETURN_Q',          width: 100,  hidden: true},     //반품량
	                     {dataIndex: 'OUT_Q',           	width: 100, summaryType: 'sum'},       	//출고량
	                     {dataIndex: 'STOCK_Q',           	width: 100, summaryType: 'sum'},       	//현재고량
	                     {dataIndex: 'EXPIRATION_DAY',           	width: 100}
          ] ,
          listeners:{
          	selectionchange:function( grid, selection, eOpts )	{

          	}, afterrender: function(grid) {

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
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('TO_DATE', UniDate.get('today'));
            panelResult.setValue('TO_DATE', UniDate.get('today'));
        },
        onQueryButtonDown: function()   {
            if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
            directMasterStore1.loadStoreRecords();

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
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.getStore().loadData({})
            this.fnInitBinding();

        }
    });

};


</script>
