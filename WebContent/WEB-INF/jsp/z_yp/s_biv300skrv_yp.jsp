<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_biv300skrv_yp"  >

	<t:ExtComboStore comboType="BOR120"  pgmId="s_biv300skrv_yp"/> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="Z008" />            <!-- 품목분류 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>	<!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴.
	gsAvgPHiddenYN: 		'${gsAvgPHiddenYN}',
	gsWHGroupYN:			'${gsWHGroupYN}'
};

//var output =''; 	// 입고내역 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

function appMain() {
	var AvgPHiddenYN = false;	// 현재고 단가필드 숨김여부 (Y:숨김, N:보여줌)
	if(BsaCodeInfo.gsAvgPHiddenYN =='Y')	{
		AvgPHiddenYN = true;
	}
	/**
	 *   Model 정의
	 * @type
	 */

	Unilite.defineModel('S_biv300skrv_ypModel', {
	    fields: [
	    	{name: 'ITEM_ACCOUNT',		text: '품목계정',			type: 'string'},
	    	{name: 'ACCOUNT1',			text: '품목계정코드',		type: 'string'},
	    	{name: 'DIV_CODE',			text: '사업장',			type: 'string'},

	    	{name: 'ITEM_LEVEL1',		text: '대분류',			type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
            {name: 'ITEM_LEVEL2',		text: '중분류',			type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
            {name: 'ITEM_LEVEL3',		text: '소분류',			type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
	    	{name: 'ITEM_CODE',			text: '품목코드',			type: 'string'},
	    	{name: 'ITEM_NAME',			text: '품목',				type: 'string'},
	    	{name: 'SPEC',				text: '규격',				type: 'string'},
	    	{name: 'STOCK_UNIT',		text: '재고단위',			type: 'string'},
	    	{name: 'STOCK_P',			text: '재고단가',			type: 'uniUnitPrice'},
	    	{name: 'STOCK_Q',			text: '총재고량',			type: 'uniQty'},
	    	{name: 'STOCK_AMT',			text: '총재고금액',			type: 'uniPrice'},
	    	{name: 'GOOD_STOCK_Q',		text: '양품재고량',			type: 'uniQty'},
	    	{name: 'GOOD_STOCK_AMT',	text: '양품재고금액',		type: 'uniPrice'},
	    	{name: 'BAD_STOCK_Q',		text: '불량재고량',			type: 'uniQty'},
	    	{name: 'BAD_STOCK_AMT',		text: '불량재고금액',		type: 'uniPrice'},
	    	{name: 'LOCATION',			text: 'LOCATION',		type: 'string'},
	    	{name: 'CUSTOM_CODE',		text: '주거래처코드',		type: 'string'},
	    	{name: 'CUSTOM_NAME',		text: '주거래처',			type: 'string'}
	    ]
	});

	Unilite.defineModel('S_biv300skrv_ypModel2', {
	    fields:  [
	    	{name: 'ITEM_ACCOUNT'		,		text: '창고',				type: 'string'},
	    	{name: 'ACCOUNT1'			,		text: '창고코드',			type: 'string'},
	    	{name: 'DIV_CODE'			,		text: '사업장',			type: 'string'},

	    	{name: 'ITEM_LEVEL1'		,		text: '대분류',			type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
            {name: 'ITEM_LEVEL2'		,		text: '중분류',			type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
            {name: 'ITEM_LEVEL3'		,		text: '소분류',			type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
	    	{name: 'ITEM_CODE'			,		text: '품목코드',			type: 'string'},
	    	{name: 'ITEM_NAME'			,		text: '품목',				type: 'string'},
	    	{name: 'SPEC'				,		text: '규격',				type: 'string'},
	    	{name: 'STOCK_UNIT'			,		text: '재고단위',			type: 'string'},
	    	{name: 'STOCK_P'			,		text: '재고단가',			type: 'uniUnitPrice'},
	    	{name: 'STOCK_Q'			,		text: '총재고량',			type: 'uniQty'},
	    	{name: 'STOCK_AMT'			,		text: '총재고금액',			type: 'uniPrice'},
	    	{name: 'GOOD_STOCK_Q'		,		text: '양품재고량',			type: 'uniQty'},
	    	{name: 'GOOD_STOCK_AMT'		,		text: '양품재고금액',		type: 'uniPrice'},
	    	{name: 'BAD_STOCK_Q'		,		text: '불량재고량',			type: 'uniQty'},
	    	{name: 'BAD_STOCK_AMT'		,		text: '불량재고금액',		type: 'uniPrice'},
	    	{name: 'LOCATION'			,		text: 'LOCATION',		type: 'string'}
		]
	});

	Unilite.defineModel('S_biv300skrv_ypModel3', {
	    fields:  [
	    	{name: 'LOT_NO'			,		text: 'LOT NO',			    type: 'string'},
	    	{name: 'WH_CODE'		,		text: '창고코드',			type: 'string'},
	    	{name: 'WH_NAME'		,		text: '창고명',			    type: 'string'},
	    	{name: 'ITEM_CODE'		,		text: '품목코드',			type: 'string'},
	    	{name: 'ITEM_NAME'		,		text: '품목명',			    type: 'string'},
	    	{name: 'SPEC'			,		text: '규격',				type: 'string'},
	    	{name: 'STOCK_UNIT'		,		text: '재고단위',			type: 'string'},
	    	{name: 'STOCK'			,		text: '총재고량',			type: 'uniQty'},
	    	{name: 'GOOD_STOCK'		,		text: '양품재고량',			type: 'uniQty'},
	    	{name: 'BAD_STOCK'		,		text: '불량재고량',			type: 'uniQty'},
	    	//{name: 'REMARK'			,		text: '비고',				type: 'string'},
	    	{name: 'DIV_CODE'		,		text: '사업장코드',			type: 'string'},
	    	{name: 'WH_CODE'		,		text: '창고코드',			type: 'string'},
	    	{name: 'CUSTOM_CODE'		,		text: '거래처코드',			type: 'string'},
	    	{name: 'CUSTOM_NAME'		,		text: '거래처명',			type: 'string'}

		]
	});
    /*
    Unilite.defineModel('S_biv300skrv_ypModel4', {
        fields:  [
            {name: 'DIV_CODE'         ,       text: '사업장',           type: 'string'},
            {name: 'CUSTOM_CODE'      ,       text: '거래처',           type: 'string'},
            {name: 'CUSTOM_NAME'      ,       text: '거래처명',         type: 'string'},
            {name: 'ITEM_CODE'        ,       text: '품목코드',         type: 'string'},
            {name: 'ITEM_NAME'        ,       text: '품목명',           type: 'string'},
            {name: 'SPEC'             ,       text: '규격',             type: 'string'},
            {name: 'STOCK_UNIT'       ,       text: '재고단위',         type: 'string'},
            {name: 'STOCK_P'          ,       text: '재고단가',         type: 'uniUnitPrice'},
            {name: 'STOCK_Q'          ,       text: '총재고량',         type: 'uniQty'},
            {name: 'STOCK_AMT'        ,       text: '총재고금액',       type: 'uniPrice'},
            {name: 'GOOD_STOCK_Q'     ,       text: '양품재고량',       type: 'uniQty'},
            {name: 'GOOD_STOCK_AMT'   ,       text: '양품재고금액',     type: 'uniPrice'},
            {name: 'BAD_STOCK_Q'      ,       text: '불량재고량',       type: 'uniQty'},
            {name: 'BAD_STOCK_AMT'    ,       text: '불량재고금액',     type: 'uniPrice'}

        ]
    });

    Unilite.defineModel('S_biv300skrv_ypModel5', {
        fields:  [
            {name: 'DIV_CODE'         ,       text: '사업장',          type: 'string'},
            {name: 'WH_CODE'          ,       text: '창고코드',        type: 'string'},
            {name: 'WH_NAME'          ,       text: '창고명',          type: 'string'},
            {name: 'WH_CELL_CODE'     ,       text: '창고CELL코드',    type: 'string'},
            {name: 'WH_CELL_NAME'     ,       text: '창고CELL',        type: 'string'},
            {name: 'LOT_NO'           ,       text: 'LOT NO',          type: 'string'},
            {name: 'ITEM_CODE'        ,       text: '품목코드',        type: 'string'},
            {name: 'ITEM_NAME'        ,       text: '품목명',          type: 'string'},
            {name: 'SPEC'             ,       text: '규격',            type: 'string'},
            {name: 'STOCK_UNIT'       ,       text: '재고단위',        type: 'string'},
            {name: 'STOCK'            ,       text: '총재고량',        type: 'uniQty'},
            {name: 'GOOD_STOCK'       ,       text: '양품재고량',      type: 'uniQty'},
            {name: 'BAD_STOCK'        ,       text: '불량재고량',      type: 'uniQty'}
            //{name: 'REMARK'           ,       text: '비고',            type: 'string'}

        ]
    });
	*/
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_biv300skrv_ypMasterStore1',{
		model: 'S_biv300skrv_ypModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable:false,		// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 's_biv300skrv_ypService.selectMaster'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.SUBCON_FLAG = Ext.getCmp('rdoSelect').getChecked()[0].inputValue;
            param.QUERY_TYPE = '1'
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore2 = Unilite.createStore('s_biv300skrv_ypMasterStore2',{
		model: 'S_biv300skrv_ypModel2',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 's_biv300skrv_ypService.selectMaster2'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
            param.QUERY_TYPE = '2'
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var directMasterStore3 = Unilite.createStore('s_biv300skrv_ypMasterStore3',{
		model: 'S_biv300skrv_ypModel3',
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 's_biv300skrv_ypService.selectMaster3'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
            param.FR_LOT = lotSubForm.getValue('FR_LOT');
            param.TO_LOT = lotSubForm.getValue('TO_LOT');
			console.log( param );
			this.load({
				params : param
			});
		}
	});
    /*
    var directMasterStore4 = Unilite.createStore('s_biv300skrv_ypMasterStore4',{
        model: 'S_biv300skrv_ypModel4',
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
                    //비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 's_biv300skrv_ypService.selectMaster4'}
        },
        loadStoreRecords : function() {
            var param= Ext.getCmp('searchForm').getValues();
            param.CUSTOM_CODE = customSubForm.getValue('CUSTOM_CODE');
            param.CUSTOM_NAME = customSubForm.getValue('CUSTOM_NAME');
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var directMasterStore5 = Unilite.createStore('s_biv300skrv_ypMasterStore5',{
        model: 'S_biv300skrv_ypModel5',
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
                    //비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 's_biv300skrv_ypService.selectMaster5'}
        },
        loadStoreRecords : function() {
            var param= Ext.getCmp('searchForm').getValues();
            console.log( param );
            this.load({
                params : param
            });
        }
    });
	*/
	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			    items: [{
					fieldLabel: '사업장',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					child:'WH_CODE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '창고',
					name: 'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '계정',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
                    fieldLabel: '품목분류',
                    name:'ITEM_GUBUN',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'Z008',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('ITEM_GUBUN', newValue);
                        }
                    }
                },
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '품목코드',
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
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			   })]
			},{
				title: '추가정보',
				defaultType: 'uniTextfield',
				items: [{
					fieldLabel: '대분류',
					name: 'TXTLV_L1',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child: 'TXTLV_L2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXTLV_L1', newValue);
						}
					}
				},{
					fieldLabel: '중분류',
					name: 'TXTLV_L2',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'TXTLV_L3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXTLV_L2', newValue);
						}
					}
				},{
					fieldLabel: '소분류',
					name: 'TXTLV_L3',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
			        parentNames:['TXTLV_L1','TXTLV_L2'],
			        levelType:'ITEM',
			        listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXTLV_L3', newValue);
						}
					}
				}]
			}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
					fieldLabel: '사업장',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					child:'WH_CODE',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel: '창고',
					name: 'WH_CODE',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
				},{
					fieldLabel: '계정',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
                    fieldLabel: '품목분류',
                    name:'ITEM_GUBUN',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'Z008',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('ITEM_GUBUN', newValue);
                        }
                    }
                },
				Unilite.popup('DIV_PUMOK',{
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE',
						textFieldName: 'ITEM_NAME',
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
			   }),{
					fieldLabel: '대분류',
					name: 'TXTLV_L1',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child: 'TXTLV_L2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('TXTLV_L1', newValue);
						}
					}
				},{
					fieldLabel: '중분류',
					name: 'TXTLV_L2',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'TXTLV_L3',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('TXTLV_L2', newValue);
						}
					}
				},{
					fieldLabel: '소분류',
					name: 'TXTLV_L3',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve3Store'),
			        parentNames:['TXTLV_L1','TXTLV_L2'],
			        levelType:'ITEM',
			        listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('TXTLV_L3', newValue);
						}
					}
				}
			]
	});

	var itemSubForm = Unilite.createSearchForm('itemSubForm',{
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '1'},
        items: [{
                xtype: 'radiogroup',
                fieldLabel: '외주재고포함여부',
                labelWidth: 100,
                id: 'rdoSelect',
                items: [{
                    boxLabel: '포함안함',
                    width: 70,
                    inputValue: '1',
                    name: 'SUBCON_FLAG',
                    checked: true
                },{
                    boxLabel : '포함함',
                    width: 70,
                    inputValue: '2',
                    name: 'SUBCON_FLAG'
                }]
        }]
    });

    var lotSubForm = Unilite.createSearchForm('lotSubForm',{
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '1'},
        items: [{
            xtype: 'container',
            items:[{
                xtype: 'container',
                defaultType: 'uniTextfield',
                layout: {type: 'uniTable', columns: 2},
                width: 250,
                items: [{
                    fieldLabel: 'LOT NO',
                    //suffixTpl: '&nbsp;~&nbsp;',
                    width: 200,
                    name: 'FR_LOT'
                }, {
                    name: 'TO_LOT',
                    width: 135,
                    fieldLabel: '~',
                    labelWidth: 15
                }]
            }]
        }]
    });

    var customSubForm = Unilite.createSearchForm('customSubForm',{
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '1'},
        items: [
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '외주처',
                valueFieldName : 'CUSTOM_CODE',
                textFieldName  : 'CUSTOM_NAME'
            })
        ]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

	var masterGrid = Unilite.createGrid('s_biv300skrv_ypGrid_1', {
    	region: 'center' ,
        layout : 'fit',
//        title: '품목별',
    	excelTitle: '현재고현황조회(품목별)',
        store : directMasterStore1,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	//store: directMasterStore1,
        columns:  [
        	{dataIndex: 'ITEM_ACCOUNT'	,		width: 120,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}
            },
			{dataIndex: 'ACCOUNT1'		,		width: 66, hidden:true},
			{dataIndex: 'DIV_CODE'		,		width: 66, hidden:true},
//			{dataIndex: 'ITEM_LEVEL1'	, 		width: 120,align:'center', locked: true},
//            {dataIndex: 'ITEM_LEVEL2'	, 		width: 100,align:'center', locked: true},
//            {dataIndex: 'ITEM_LEVEL3'	, 		width: 100,align:'center', locked: true},
			{dataIndex: 'ITEM_CODE'		,		width: 120},
			{dataIndex: 'ITEM_NAME'		,		width: 200},
			{dataIndex: 'SPEC'			,		width: 180},
			{dataIndex: 'STOCK_UNIT'	,		width: 80},
			{dataIndex: 'STOCK_P'		,		width: 100, hidden: AvgPHiddenYN},
			{dataIndex: 'STOCK_Q'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'STOCK_AMT'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_Q'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_AMT',		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_AMT'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'LOCATION'		,		width: 86, hidden:true},
			{dataIndex: 'CUSTOM_CODE'	,		width: 86, hidden:true},
			{dataIndex: 'CUSTOM_NAME'	,		width: 86, hidden:true}
		]
	});

	var masterGrid2 = Unilite.createGrid('s_biv300skrv_ypGrid_2', {
    	region: 'center' ,
        layout : 'fit',
//        title: '창고별',
    	excelTitle: '현재고현황조회(창고별)',
        store : directMasterStore2,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal2', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	//store: directMasterStore2,
        columns:  [
			{dataIndex: 'ACCOUNT1'		,		width: 85,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '총계', '총계');
            	}
            },
        	{dataIndex: 'ITEM_ACCOUNT'	,		width: 100},
			{dataIndex: 'DIV_CODE'		,		width: 80, hidden:true},
//			{dataIndex: 'ITEM_LEVEL1'	, 		width: 120,align:'center', locked: true},
//            {dataIndex: 'ITEM_LEVEL2'	, 		width: 100,align:'center', locked: true},
//            {dataIndex: 'ITEM_LEVEL3'	, 		width: 100,align:'center', locked: true},
			{dataIndex: 'ITEM_CODE'		,		width: 120},
			{dataIndex: 'ITEM_NAME'		,		width: 200},
			{dataIndex: 'SPEC'			,		width: 180},
			{dataIndex: 'STOCK_UNIT'	,		width: 80},
			{dataIndex: 'STOCK_P'		,		width: 100, hidden: AvgPHiddenYN},
			{dataIndex: 'STOCK_Q'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'STOCK_AMT'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_Q'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK_AMT',		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_Q'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK_AMT'	,		width: 100, summaryType: 'sum'},
			{dataIndex: 'LOCATION'		,		width: 100}

		]
	});

	var masterGrid3 = Unilite.createGrid('s_biv300skrv_ypGrid_3', {
    	region: 'center' ,
        layout : 'fit',
//        title: 'LOT별',
    	excelTitle: '현재고현황조회(LOT별)',
        store : directMasterStore3,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
        features: [ {id : 'masterGridSubTotal3', ftype: 'uniGroupingsummary', showSummaryRow: true },
                    {id : 'masterGridTotal3',   ftype: 'uniSummary',      showSummaryRow: true} ],
    	//store: directMasterStore3,
        columns:  [
			{dataIndex: 'LOT_NO'			,		width: 115,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }
            },
			{dataIndex: 'WH_CODE'			,		width: 85},
			{dataIndex: 'WH_NAME'			,		width: 100},
			{dataIndex: 'ITEM_CODE'			,		width: 120},
			{dataIndex: 'ITEM_NAME'			,		width: 200},
			{dataIndex: 'SPEC'				,		width: 140},
			{dataIndex: 'STOCK_UNIT'		,		width: 80},
			{dataIndex: 'STOCK'				,		width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_STOCK'		,		width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_STOCK'			,		width: 100, summaryType: 'sum'},
			//{dataIndex: 'REMARK'			,		width: 100},
			{dataIndex: 'DIV_CODE'			,		width: 66, hidden: true},
			{dataIndex: 'WH_CODE'			,		width: 100, hidden: true},
			{dataIndex: 'CUSTOM_CODE'			,		width: 100, align:'center', hidden: false},
			{dataIndex: 'CUSTOM_NAME'			,		width: 150, hidden: false},
		]
	});
    /*
    var masterGrid4 = Unilite.createGrid('s_biv300skrv_ypGrid_4', {
        region: 'center' ,
        layout : 'fit',
//        title: '외주처별',
        excelTitle: '현재고현황조회(외주처별)',
        store : directMasterStore4,
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: false,
                    useMultipleSorting: true
        },
        features: [ {id : 'masterGridSubTotal4', ftype: 'uniGroupingsummary', showSummaryRow: true },
                    {id : 'masterGridTotal4',   ftype: 'uniSummary',      showSummaryRow: true} ],
        //store: directMasterStore3,
        columns:  [
            {dataIndex: 'DIV_CODE'            ,       width: 100, hidden: true},
            {dataIndex: 'CUSTOM_CODE'         ,       width: 100, hidden: true},
            {dataIndex: 'CUSTOM_NAME'         ,       width: 200,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex: 'ITEM_CODE'           ,       width: 100},
            {dataIndex: 'ITEM_NAME'           ,       width: 200},
            {dataIndex: 'SPEC'                ,       width: 100},
            {dataIndex: 'STOCK_UNIT'          ,       width: 100},
            {dataIndex: 'STOCK_P'             ,       width: 100, hidden: AvgPHiddenYN},
            {dataIndex: 'STOCK_Q'             ,       width: 100, summaryType: 'sum'},
            {dataIndex: 'STOCK_AMT'           ,       width: 100, summaryType: 'sum'},
            {dataIndex: 'GOOD_STOCK_Q'        ,       width: 100, summaryType: 'sum'},
            {dataIndex: 'GOOD_STOCK_AMT'      ,       width: 100, summaryType: 'sum'},
            {dataIndex: 'BAD_STOCK_Q'         ,       width: 100, summaryType: 'sum'},
            {dataIndex: 'BAD_STOCK_AMT'       ,       width: 100, summaryType: 'sum'}
        ]
    });

    var masterGrid5 = Unilite.createGrid('s_biv300skrv_ypGrid_5', {
        region: 'center' ,
        layout : 'fit',
//        title: 'CELL별',
        excelTitle: '현재고현황조회(CELL별)',
        store : directMasterStore5,
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: false,
                    useMultipleSorting: true
        },
        features: [ {id : 'masterGridSubTotal5', ftype: 'uniGroupingsummary', showSummaryRow: true },
                    {id : 'masterGridTotal5',   ftype: 'uniSummary',      showSummaryRow: true} ],
        //store: directMasterStore3,
        columns:  [
            {dataIndex: 'DIV_CODE'                 ,       width: 85, hidden: true},
            {dataIndex: 'WH_CODE'                  ,       width: 85, hidden: true},
            {dataIndex: 'WH_NAME'                  ,       width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex: 'WH_CELL_CODE'             ,       width: 85, hidden: true},
            {dataIndex: 'WH_CELL_NAME'             ,       width: 100},
            {dataIndex: 'LOT_NO'                   ,       width: 100},
            {dataIndex: 'ITEM_CODE'                ,       width: 100},
            {dataIndex: 'ITEM_NAME'                ,       width: 200},
            {dataIndex: 'SPEC'                     ,       width: 100},
            {dataIndex: 'STOCK_UNIT'               ,       width: 100},
            {dataIndex: 'STOCK'                    ,       width: 100, summaryType: 'sum'},
            {dataIndex: 'GOOD_STOCK'               ,       width: 100, summaryType: 'sum'},
            {dataIndex: 'BAD_STOCK'                ,       width: 100, summaryType: 'sum'}
           //{dataIndex: 'REMARK'                   ,       width: 100}
        ]
    });
	*/
	var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
             {
                 title: '품목별'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[itemSubForm, masterGrid]
                 ,id: 's_biv300skrv_ypGrid1'
             },
             {
                 title: '창고별'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[masterGrid2]
                 ,id: 's_biv300skrv_ypGrid2'
             },
             {
                 title: 'LOT별'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[lotSubForm, masterGrid3]
                 ,id: 's_biv300skrv_ypGrid3'
             }/*,
             {
                 title: '외주처별'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[customSubForm, masterGrid4]
                 ,id: 's_biv300skrv_ypGrid4'
             },
             {
                 title: 'CELL별'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[masterGrid5]
                 ,id: 's_biv300skrv_ypGrid5'
             }*/
        ]
	});

    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch
		],
		id  : 's_biv300skrv_ypApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			s_biv300skrv_ypService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		onQueryButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 's_biv300skrv_ypGrid1'){
				directMasterStore1.loadStoreRecords();
			}
			else if(activeTabId == 's_biv300skrv_ypGrid2'){
				directMasterStore2.loadStoreRecords();
			}
			else if(activeTabId == 's_biv300skrv_ypGrid3'){
				directMasterStore3.loadStoreRecords();
			}
            else if(activeTabId == 's_biv300skrv_ypGrid4'){
                directMasterStore4.loadStoreRecords();
            }
            else if(activeTabId == 's_biv300skrv_ypGrid5'){
                directMasterStore5.loadStoreRecords();
            }
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();

			masterGrid.getStore().loadData({});
			masterGrid2.getStore().loadData({});
			masterGrid3.getStore().loadData({});

//			masterGrid.reset();
//			directMasterStore1.clearData();
//			masterGrid2.reset();
//			directMasterStore2.clearData();
//			masterGrid3.reset();
//			directMasterStore3.clearData();
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
