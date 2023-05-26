<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ppl115ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="ppl115ukrv"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="A207" />             <!-- 확정여부  -->
    <t:ExtComboStore comboType="AU" comboCode="P001" opts= '${gsList1}' />             <!-- 계획상태  -->
	<t:ExtComboStore comboType="WU" /><!-- 작업장-->
</t:appConfig>
</script>
<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
/*.x-change-cell_pink2 {
	background-color: #fed9fe;
	color: red; 
    text-align: right;
    font-weight: bolder;
}*/

.x-change-cell_pink1 {
	background-color: #fed9fe;
	color: red; 
}
.x-change-cell_green1 {
	background-color: #e5fcca;
	color: green; 
}
.x-change-cell_blue {
background-color: #3BA6CE;
}
.x-change-cell_textR {
		color: Red;
	}


</style>

<script type="text/javascript" >

var searchOrderWindow;
var searchSub1Window;
var windowParams;

function appMain() {

	var directProxyMaster = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'ppl115ukrvService.selectMaster',
//            create: 'ppl115ukrvService.insertMaster',
            update: 'ppl115ukrvService.updateMaster',
//            destroy: 'ppl115ukrvService.deleteMaster',
            syncAll: 'ppl115ukrvService.saveAllMaster'
        }
    }); 
    
    var subProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ppl115ukrvService.selectSubList'
		}
	});
	
    var addModel = null;
	var columns		= createGridColumn();
	var fields = createModelField();
	
	Unilite.defineModel('mainModel', {
		fields: fields
	});
	
	Unilite.defineModel('subModel', {
		fields: [
//			{name: 'SEQ'			, text: '순번'		, type: 'int'},
			{name: 'ITEM_ACCOUNT'	, text: '품목계정'		, type: 'string',comboType:'AU', comboCode:'B020'},
			{name: 'ITEM_CODE', text: '품목'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '품명'		, type: 'string'},
			{name: 'SPEC'			, text: '규격'		, type: 'string'},
			{name: 'STOCK_UNIT'		, text: '단위'		, type: 'string'},
			{name: 'UNIT_Q'			, text: '원단위수량'		, type: 'uniQty'},
			{name: 'ALLOCK_Q'			, text: '소요량'		, type: 'uniQty'},
			{name: 'WAITING_Q'		, text: '입고대기수량'	, type: 'uniQty'},
			{name: 'M_INOUT_Q'		, text: '입고수량'	, type: 'uniQty'},
			
			{name: 'GOOD_STOCK_Q'		, text: '현재고'		, type: 'uniQty'},
			{name: 'LACK_Q'			, text: '부족량'		, type: 'uniQty'},
			{name: 'M_CUSTOM_NAME'		, text: '거래처'		, type: 'string'},
			{name: 'M_ORDER_DATE'		, text: '발주일'		, type: 'uniDate'},
			{name: 'M_DVRY_DATE'		, text: '납기일'		, type: 'uniDate'}
		]
	});
	
    var masterStore = Unilite.createStore('masterStore',{
        model: 'mainModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxyMaster,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        },
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();    //syncAll 수정
            if(inValidRecs.length == 0 )    {
                var config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                 		masterStore.loadStoreRecords();
                     }
                };
                this.syncAllDirect(config);
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
		listeners:{
			load:function(store, records, successful, eOpts)	{
          		setColumnText();
          		day_change(masterGrid);
			}
		}
        //,
		//groupField:'SO_NUM'
    });
    
    var subStore = Unilite.createStore('subStore', {
		model	: 'subModel',
		proxy	: subProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function(record) {
			var param= record.data;
			this.load({
				params : param
			});
		}
	});
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox' ,
			allowBlank:false,
			comboType: 'BOR120'
	    },{
			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
		 	xtype: 'uniDateRangefield',
		 	startFieldName: 'DVRY_DATE_FR',
		 	endFieldName: 'DVRY_DATE_TO',
		 	width: 315
//			startDate: UniDate.get('today'),
//			endDate: UniDate.get('todayForMonth')
		},{
			fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
			xtype: 'uniTextfield',
			name: 'ORDER_NUM',
			colspan:2,
			listeners: {
                render: function(p) {
                    p.getEl().on('dblclick', function(p) {
                    	openSearchOrderWindow();
                    });
                }
            }
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'WU',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();

					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					} else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel: '착수예정일',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_START_DATE_FR',
			endFieldName: 'PRODT_START_DATE_TO',
			width: 350,
			startDate: UniDate.get('today'),
			endDate: UniDate.get('todayForMonth'),
			allowBlank:false
		},{
			xtype: 'radiogroup',
			fieldLabel : '일수기준',
			name:'RADIOS',
			items : [{
				boxLabel: '착수예정일',
				name: 'RDO_SELECT',
				inputValue : '1',
				width: 100,
				checked	: true
			}, {
				boxLabel: '완료예정일',
				name: 'RDO_SELECT' ,
				inputValue : '2',
				width: 100
			}]
		},{
			xtype: 'radiogroup',
			fieldLabel : '상태',
			name:'RADIOS2',
			items : [{
				boxLabel: '진행',
				name: 'RDO_SELECT2',
				inputValue : '1',
				width: 50,
				checked	: true
			}, {
				boxLabel: '전체',
				name: 'RDO_SELECT2' ,
				inputValue : '2',
				width: 50
			}]
		}]
    });

    var masterGrid = Unilite.createGrid('masterGrid', {
        layout : 'fit',
        region: 'center',
        flex:3,
        split:true,
//        preventHeader : true,
//        header:false,
//        hideCollapseTool:true,
//  fixed:true,      
        uniOpt: {
        	
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: true,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            },
            state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			pivot:{
				use : false,
				pivotWin : null
			}
        },
        
//        features: 'grouping',
        features: [{		
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: masterStore,
		columns:  columns,
        listeners: {
        	
        	selectionchangerecord:function(selected) {
				if(selected.phantom){
					subGrid.reset();
					subStore.loadData({});
				}else{
					subStore.loadStoreRecords(selected);
				}
			},
        	
        	
        	beforeedit  : function( editor, e, eOpts ) {
        		/*if (e.field == 'EQUIP_NAME'  || e.field == 'MOLD_CODE' || e.field == 'PRODT_START_DATE' || e.field == 'PRODT_END_DATE' || e.field == 'SEQ' || e.field == 'CONFIRM_YN' || e.field == 'WKORD_STATUS'){
					return true;
        		}*/
				if(UniUtils.indexOf(e.field, ['EQUIP_NAME','MOLD_CODE','PRODT_START_DATE','DAY_COUNT','PRODT_END_DATE','SEQ','CONFIRM_YN','WKORD_STATUS' ])){
					if(e.record.data.WKORD_STATUS_REF2 != 'Y'){ //완료, 마감일시 수정 불가
						return false;
					}else{
						var calcStandard = panelResult.getValue('RADIOS').RDO_SELECT;
						if(UniUtils.indexOf(e.field, 'PRODT_START_DATE')){
							if(calcStandard == '1'){	//일수기준이 착수예정일 1 일때 착수예정일 수정가능, 2일때 완료예정일
								return true;
							}else{
								return false;
							}
						}else if(UniUtils.indexOf(e.field, 'PRODT_END_DATE')){
							if(calcStandard == '2'){	//일수기준이 착수예정일 1 일때 착수예정일 수정가능, 2일때 완료예정일
								return true;
							}else{
								return false;
							}
						}else{
							return true;
						}
						
					}
				}
				
				else{
					return false;
				}
            }
        }
    });
    
	var subGrid = Unilite.createGrid('subGrid', {
		store	: subStore,
		layout	: 'fit',
		region	: 'south',
		flex:1,
		split:true,
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		selModel: 'rowmodel',
	/*	viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){
				var cls = '';
				if(!Ext.isEmpty(record.get('LACK_Q'))){		//부족량이 있을시
					cls = 'x-change-cellR';
				}
				return cls;
			}
		},*/
		columns	: [
//			{ dataIndex: 'SEQ'				, width: 60,align:'center' },
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 100  },
			{ dataIndex: 'ITEM_CODE'	, width: 120 },
			{ dataIndex: 'ITEM_NAME'		, width: 300 },
			{ dataIndex: 'SPEC'				, width: 150 },
			{ dataIndex: 'STOCK_UNIT'		, width: 40 , align:'center'},
			{ dataIndex: 'UNIT_Q'			, width: 100 },
			{ dataIndex: 'ALLOCK_Q'			, width: 100 },
			{ dataIndex: 'WAITING_Q'		, width: 100 },
			{ dataIndex: 'M_INOUT_Q'			, width: 100 },
			{ dataIndex: 'GOOD_STOCK_Q'			, width: 100 },
			{ dataIndex: 'LACK_Q'			, width: 100,
				renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
					if(val > 0){
						metaData.tdCls = 'x-change-cell_textR';
					}
					return Ext.util.Format.number(val, '0,000');
				}
			},
			
			{ dataIndex: 'M_CUSTOM_NAME'		, width: 200 },
			{ dataIndex: 'M_ORDER_DATE'			, width: 100 },
			{ dataIndex: 'M_DVRY_DATE'			, width: 100 }
			
		]
	});
	
    var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
	    layout: {
	        type: 'uniTable',
	        columns: 3
	    },
	    trackResetOnLoad: true,
	    items: [{
	            fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
	            name: 'DIV_CODE',
	            xtype: 'uniCombobox',
	            comboType: 'BOR120',
	            value: UserInfo.divCode,
	            allowBlank: false,
	            listeners: {
	                change: function(combo, newValue, oldValue, eOpts) {
	                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
	                    var field = orderNoSearch.getField('ORDER_PRSN');
	                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts); // panelResult의
	                    // 필터링
	                    // 처리
	                    // 위해..
	                }
	            }
	        }, {
	            fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'FR_ORDER_DATE',
	            endFieldName: 'TO_ORDER_DATE',
	            width: 350,
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            colspan: 2
	        }, {
	            fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>',
	            name: 'ORDER_PRSN',
	            xtype: 'uniCombobox',
	            comboType: 'AU',
	            comboCode: 'S010',
	            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
	                if (eOpts) {
	                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
	                } else {
	                    combo.divFilterByRefCode('refCode1', newValue, divCode);
	                }
	            }
	        },
	        Unilite.popup('AGENT_CUST', {
	            fieldLabel: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
	            validateBlank: false,
	            colspan: 2,
	            listeners: {
	                applyextparam: function(popup) {
	                    popup.setExtParam({
	                        'AGENT_CUST_FILTER': ['1', '3']
	                    });
	                    popup.setExtParam({
	                        'CUSTOM_TYPE': ['1', '3']
	                    });
	                }
	            }
	        }),
	        // Unilite.popup('AGENT_CUST',{fieldLabel:'프로젝트' , valueFieldName:'PROJECT_NO',
	        // textFieldName:'PROJECT_NAME', validateBlank: false}),
	        Unilite.popup('DIV_PUMOK', {
	            colspan: 2,
	            listeners: {
	                applyextparam: function(popup) {
	                    popup.setExtParam({
	                        'DIV_CODE': orderNoSearch.getValue('DIV_CODE')
	                    });
	                }
	            }
	        }),
	        {
	            fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
	            name: 'ORDER_TYPE',
	            xtype: 'uniCombobox',
	            comboType: 'AU',
	            comboCode: 'S002'
	        },
	        {
	            fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>',
	            name: 'PO_NUM'
	        }
	    ]
	}); // createSearchForm

    // 검색 모델(디테일)
    Unilite.defineModel('orderNoDetailModel', {
        fields: [
             { name: 'DIV_CODE'     ,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'           ,type: 'string' ,comboType:'BOR120'}
            ,{ name: 'ITEM_CODE'    ,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'       	,type: 'string' }
            ,{ name: 'ITEM_NAME'    ,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'     		,type: 'string' }
            ,{ name: 'SPEC'         ,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'    		,type: 'string' }

            ,{ name: 'ORDER_DATE'   ,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'        	,type: 'uniDate'}
            ,{ name: 'DVRY_DATE'    ,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'        	,type: 'uniDate'}

            ,{ name: 'WKORD_Q'      ,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'        	,type: 'uniQty' }
            ,{ name: 'ORDER_TYPE'   ,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S002'}
            ,{ name: 'ORDER_PRSN'   ,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S010'}
            ,{ name: 'PO_NUM'       ,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'      	,type: 'string' }
            ,{ name: 'PROJECT_NO'   ,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'       	,type: 'string' }
            ,{ name: 'ORDER_NUM'    ,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'       	,type: 'string' }
            ,{ name: 'SER_NO'       ,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'       	,type: 'string' }
            ,{ name: 'CUSTOM_CODE'  ,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'       	,type: 'string' }
            ,{ name: 'CUSTOM_NAME'  ,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'      	,type: 'string' }
            ,{ name: 'COMP_CODE'    ,text:'COMP_CODE'       ,type: 'string' }
            ,{ name: 'PJT_CODE'     ,text:'프로젝트코드'        	                                         		,type: 'string' }
            ,{ name: 'PJT_NAME'     ,text:'프로젝트'                                                        	,type: 'string' }
            ,{ name: 'FR_DATE'      ,text:'시작일'			                                                  	,type: 'string' }
            ,{ name: 'TO_DATE'      ,text:'종료일'         	                                              	,type: 'string' }
        ]
    });

 // 검색 스토어(디테일)
    var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
        model: 'orderNoDetailModel',
        autoLoad: false,
        uniOpt: {
            isMaster: false, // 상위 버튼 연결
            editable: false, // 수정 모드 사용
            deletable: false, // 삭제 가능 여부
            useNavi: false // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 'sof100ukrvService.selectOrderNumDetailList'
            }
        },
        loadStoreRecords: function() {
            var param = orderNoSearch.getValues();
            var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
            var deptCode = UserInfo.deptCode; // 부서코드
            if (authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))) {
                param.DEPT_CODE = deptCode;
            }
            console.log(param);
            this.load({
                params: param
            });
        }
    });

    // 검색 그리드(디테일)
    var orderNoDetailGrid = Unilite.createGrid('sof100ukrvOrderNoDetailGrid', {
        layout: 'fit',
        store: orderNoDetailStore,
        uniOpt: {
            useRowNumberer: false
        },
        columns: [
        	 { dataIndex: 'DIV_CODE'			,  width: 80 }
            ,{ dataIndex: 'ITEM_CODE'			,  width: 120 }
            ,{ dataIndex: 'ITEM_NAME'			,  width: 150 }
            ,{ dataIndex: 'SPEC'				,  width: 150 }
            ,{ dataIndex: 'ORDER_DATE'			,  width: 80 }
            ,{ dataIndex: 'DVRY_DATE'			,  width: 80 		,hidden:true}
            ,{ dataIndex: 'WKORD_Q'				,  width: 80 }
            ,{ dataIndex: 'ORDER_TYPE'			,  width: 90 }
            ,{ dataIndex: 'ORDER_PRSN'			,  width: 90 		,hidden:true}
            ,{ dataIndex: 'PO_NUM'				,  width: 100 }
            ,{ dataIndex: 'PROJECT_NO'			,  width: 90 }
            ,{ dataIndex: 'ORDER_NUM'			,  width: 120 }
            ,{ dataIndex: 'SER_NO'				,  width: 70 		,hidden:true}
            ,{ dataIndex: 'CUSTOM_CODE'			,  width: 120	 	,hidden:true}
            ,{ dataIndex: 'CUSTOM_NAME'			,  width: 200 }
            ,{ dataIndex: 'COMP_CODE'			,  width: 80 		,hidden:true}
            ,{ dataIndex: 'PJT_CODE'			,  width: 120 		,hidden:true}
            ,{ dataIndex: 'PJT_NAME'			,  width: 200 }
            ,{ dataIndex: 'FR_DATE'				,  width: 80	 	,hidden:true}
            ,{ dataIndex: 'TO_DATE'				,  width: 80 		,hidden:true}
        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                orderNoDetailGrid.returnData(record)
                searchOrderWindow.hide();
            }
        } // listeners
        ,
        returnData: function(record) {
            if (Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({
                'ORDER_NUM': record.get('ORDER_NUM'),
                'ORDER_DAY_COUNT': record.get('SER_NO'),
                'DVRY_DATE': record.get('DVRY_DATE'),
                'WKORD_Q': record.get('WKORD_Q'),
                'CUSTOM_NAME': record.get('CUSTOM_NAME')
            });

        }
    });
    
    function openSearchOrderWindow() {
        if (!searchOrderWindow) {
            searchOrderWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주번호검색',
                width: 1000,
                height: 580,
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                items: [orderNoSearch, orderNoDetailGrid],
                tbar: [
                       '->',{
                    itemId: 'searchBtn',
                    text: '조회',
                    handler: function() {
                        orderNoDetailStore.loadStoreRecords();
                    },
                    disabled: false
                }, {
                    itemId: 'closeBtn',
                    text: '닫기',
                    handler: function() {
                        searchOrderWindow.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt) {
                        orderNoSearch.clearForm();
                        orderNoDetailGrid.reset();
                        orderNoDetailStore.clearData();
                    },
                    beforeclose: function(panel, eOpts) {
                    },
                    show: function(panel, eOpts) {
                    	orderNoSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
                    	orderNoSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
                    	orderNoSearch.setValue('TO_ORDER_DATE', UniDate.get('today'));
                    }
                }
            })
        }
        searchOrderWindow.center();
        searchOrderWindow.show();
    }
    
    //후가공 상세보기
    Unilite.defineModel('sub1Model', {
        fields: [
             { name: 'ITEM_CODE'     	,text:'품번'           ,type: 'string'},
             { name: 'ITEM_NAME'     	,text:'품명'           ,type: 'string'},
             { name: 'SPEC'     		,text:'규격'           ,type: 'string'},
             { name: 'CLASSFICATION'      ,text:'거래처'          ,type: 'string'},
             { name: 'PROC_NAME'     	,text:'가공명'          ,type: 'string'}
        ]
    });

    var sub1Store = Unilite.createStore('sub1Store', {
        model: 'sub1Model',
        autoLoad: false,
        uniOpt: {
            isMaster: false, // 상위 버튼 연결
            editable: false, // 수정 모드 사용
            deletable: false, // 삭제 가능 여부
            useNavi: false // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 'ppl115ukrvService.selectSub1'
            }
        },
        loadStoreRecords: function(param) {
            this.load({
                params: param
            });
        }
    });

    var sub1Grid = Unilite.createGrid('sub1Grid', {
        layout: 'fit',
        store: sub1Store,
        uniOpt: {
            useRowNumberer: false,
            expandLastColumn: false,
			onLoadSelectFirst: false
        },
        columns: [
        	 { dataIndex: 'ITEM_CODE'  			,  width: 120 }
            ,{ dataIndex: 'ITEM_NAME'  			,  width: 200 }
            ,{ dataIndex: 'SPEC'     			,  width: 120 }
            ,{ dataIndex: 'PROC_NAME'  			,  width: 80 }
            ,{ dataIndex: 'CLASSFICATION'			,  width: 100 }
        ],
        viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('ITEM_CODE') == windowParams.ITEM_CODE){
					cls = 'x-change-cell_pink';	
				}
				return cls;
	        }
	    },
        listeners: {}
    });
    
    function openSearchSub1Window() {
        if (!searchSub1Window) {
            searchSub1Window = Ext.create('widget.uniDetailWindow', {
                title: '후가공 상세보기',
                width: 700,
                height: 580,
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                items: [sub1Grid],
                tbar: [
                       '->'
                       
                 /*,{
                    itemId: 'searchBtn',
                    text: '조회',
                    handler: function() {
                        orderNoDetailStore.loadStoreRecords();
                    },
                    disabled: false
                }, */
                	
                ,{
                    itemId: 'closeBtn',
                    text: '닫기',
                    handler: function() {
                        searchSub1Window.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt) {
                        sub1Store.loadData({}); 
                    },
                    beforeclose: function(panel, eOpts) {
//                        sub1Grid.reset();
                    },
                    show: function(panel, eOpts) {
                        sub1Store.loadStoreRecords(windowParams);
                    }
                }
            })
        }
        searchSub1Window.center();
        searchSub1Window.show();
    }
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[panelResult,masterGrid,subGrid]
        }],
        id  : 'ppl115ukrvApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
//	        addModel = null;
//	        createModelStore();
	        createStore_onQuery();
        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
			masterStore.loadData({});
            this.setDefault();
        },
        
        onSaveDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   // 필수체크
			
            if(masterStore.isDirty()) {
                masterStore.saveStore();
            }
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
            panelResult.setValue('PRODT_START_DATE_FR',UniDate.get('today'));
            panelResult.setValue('PRODT_START_DATE_TO',UniDate.get('todayForMonth'));
            
//            panelResult.setValue('DVRY_DATE_FR',UniDate.get('today'));
//            panelResult.setValue('DVRY_DATE_TO',UniDate.get('todayForMonth'));
            
            UniAppManager.setToolbarButtons(['save', 'delete', 'deleteAll'],false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
            panelResult.setValue('WORK_SHOP_CODE','WS110');
            
            
            day_change(masterGrid);
       
            
        },
        
        //칼렌더 기준 날짜계산
        fnGetWorkDate :function(fieldName,record,calcStandard, date,day,calType){
        	var param = {
				P_DATE : date,
				P_DAY : day,
				P_CAL_TYPE : calType
			}
			ppl114ukrvService.fnGetWorkDate(param , function(provider, response){
				if(!Ext.isEmpty(provider)){
					if(fieldName == 'DAY_COUNT'){
						if(calcStandard == '1'){
							record.set('PRODT_END_DATE',provider);
						}else{
							record.set('PRODT_START_DATE',provider);
						}
	        		}else if(fieldName == 'PRODT_START_DATE'){
						record.set('PRODT_END_DATE',provider);
		        			
		        	}else if(fieldName == 'PRODT_END_DATE'){
						record.set('PRODT_START_DATE',provider);
		        	}
				}
			})
        }
    });
    
    
  	function createGridColumn() {
		if(panelResult){
			var beforeConvertFr = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(6,8);
		}else{
			var beforeConvertFr = UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(6,8);
		}
		var startDateT	= new Date(beforeConvertFr);
		var endDateT		= new Date(beforeConvertTO);
		var sDate = startDateT;
		var eDate = endDateT;
		var columns = [        
			
			{dataIndex: 'COMP_CODE'     	, width: 100,lockable : true, locked:false, hidden: true,style: {textAlign: 'center' }	}, 
			{dataIndex: 'DIV_CODE'     		, width: 100,lockable : true, locked:false,hidden: true,style: {textAlign: 'center' }	}, 
		/*	{dataIndex: 'EQUIP_CODE'     		, width: 80,lockable : true, locked:true,style: {textAlign: 'center' }, hidden:true}, 
			{dataIndex: 'EQUIP_NAME'     		, width: 80,lockable : true, locked:true,style: {textAlign: 'center' }, tdCls:'x-change-cell',
			'editor' : Unilite.popup('EQU_MACH_CODE_G',{
					textFieldName:'EQU_MACH_NAME',
					DBtextFieldName: 'EQU_MACH_NAME',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('EQUIP_CODE',records[0]['EQU_MACH_CODE']);
								grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('EQUIP_CODE', '');
							grdRecord.set('EQUIP_NAME', '');
						},
						applyextparam: function(popup){
							var grdRecord = masterGrid.uniOpt.currentRecord;
							popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
							//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
						}
					}
				})
			
			}, */
			{dataIndex: 'SO_NUM'     		, width: 65,lockable : true, locked:true,style: {textAlign: 'center' }/*, resizable : false */	}, 
			{dataIndex: 'SO_SEQ'     		, width: 40,lockable : true, locked:true,style: {textAlign: 'center' }, align: 'center'	},
			
			//	{dataIndex: 'CUSTOM_CODE'       , width: 100,lockable : true, locked:true,style: {textAlign: 'center' }	, hidden:true}, 
			
			{dataIndex: 'CUSTOM_NAME'       , width: 150,lockable : true, locked:true,style: {textAlign: 'center' }	},
			{dataIndex: 'ITEM_NAME'     	, width: 250,lockable : true, locked:true,style: {textAlign: 'center' }	}, 

			{dataIndex: 'ITEM_MODEL'     	, width: 80,lockable : true, locked:true,style: {textAlign: 'center' }	}, 
/*			{dataIndex: 'MOLD_CODE'     	, width: 70,lockable : true, locked:true,style: {textAlign: 'center' }, tdCls:'x-change-cell',
				'editor' : Unilite.popup('CORE_CODE_G',{
						textFieldName:'CORE_NAME',
						DBtextFieldName: 'CORE_NAME',
						autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('MOLD_CODE',records[0]['CORE_CODE']);
//									grdRecord.set('EQUIP_NAME',records[0]['CORE_NAME']);
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('MOLD_CODE', '');
//								grdRecord.set('EQUIP_NAME', '');
							},
							applyextparam: function(popup){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								popup.setExtParam({'DIV_CODE': grdRecord.get('DIV_CODE')});
								//popup.setExtParam({'ITEM_CODE': grdRecord.get('ITEM_CODE')});
							}
						}
					})        
			}, */
			{dataIndex: 'WKORD_Q'     		, width: 70,lockable : true, locked:true,style: {textAlign: 'center' }, align: 'right',xtype:'uniNnumberColumn', format: UniFormat.Qty	}, 
			{dataIndex: 'DVRY_DATE'     	, width: 75,lockable : true, locked:true,style: {textAlign: 'center' }, align: 'center'	, xtype:'uniDateColumn', tdCls:'x-change-cell_pink'},
			
			{dataIndex: 'ITEM_CODE'     	, width: 65,lockable : true, locked:true,style: {textAlign: 'center' },hidden:true}, 
			{dataIndex: 'SPEC'     			, width: 100,lockable : true, locked:true,style: {textAlign: 'center' }}, 
			{dataIndex: 'WKORD_NUM'     	, width: 65,lockable : true, locked:true,style: {textAlign: 'center' },hidden:true}, 
			
			{dataIndex: 'PRODT_TYPE'     	, width: 65,lockable : true, locked:true,style: {textAlign: 'center' }	}, 
			{dataIndex: 'PRODT_MTRL'     	, width: 65,lockable : true, locked:true,style: {textAlign: 'center' },hidden:true	}, 
			{dataIndex: 'ITEM_COLOR'     	, width: 65,lockable : true, locked:true,style: {textAlign: 'center' },hidden:true	},
			
			{dataIndex: 'PS_OX'     	, width: 90,lockable : true, locked:true,style: {textAlign: 'center' }, align: 'center'	}, 

			{
				text: '후가공',
		        width: 50,
				align: 'center',
				xtype: 'actioncolumn',
				lockable : true,locked:true, resizable : false,
				items: [{
//	                  xtype: 'button',
//	                  text: '상세보기',
//	                  scale: 'large',
					tooltip: '상세보기',
//               padding		: '-2 0 2 0',
					icon	: CPATH+'/resources/css/icons/component-s.png',
					handler: function(grid, rowIndex, colIndex, item, e, record) {
//                      var selectRecord = event.record.data;
						grid.getSelectionModel().select(rowIndex);
						windowParams = {
							'DIV_CODE': record.get('DIV_CODE'),
							'SO_NUM': record.get('SO_NUM'),
							'SO_SEQ': record.get('SO_SEQ'),
							'ITEM_CODE': record.get('ITEM_CODE')
						}
						openSearchSub1Window();
					}
               }]
	       },
			
/*			{       text: '후가공',
		            width: 75,
		            name:'COL_BTN1',
		            xtype: 'widgetcolumn',
		            widget: {
		                xtype: 'button',
		                text: '상세보기',
		                listeners: {
		                	buffer:1,
		                	click: function(button, event, eOpts) {
		                		var selectRecord = event.record.data;
		                		
		                		windowParams = {
									'DIV_CODE': selectRecord.DIV_CODE,
									'SO_NUM': selectRecord.SO_NUM,
									'SO_SEQ': selectRecord.SO_SEQ
								}
		                		openSearchSub1Window();
		                	}
		                }
		            },lockable : true,locked:true, resizable : false, style: {textAlign: 'center' }	
		    },*/
			{dataIndex: 'PRODT_START_DATE'  , width: 75,lockable : true, locked:true,style: {textAlign: 'center' }, align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}, tdCls:'x-change-cell'	}, 
			{dataIndex: 'DAY_COUNT'     	, width: 40,lockable : true, locked:true,style: {textAlign: 'center' }, align: 'center', tdCls:'x-change-cell', editor: {xtype: 'uniTextfield'}	},
			
			
			
			
			{dataIndex: 'PRODT_END_DATE'    , width: 75,lockable : true, locked:true,hidden:true,style: {textAlign: 'center' }, align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}, tdCls:'x-change-cell'	}, 
			{dataIndex: 'CONFIRM_YN'     	, width: 65,lockable : true, locked:true,style: {textAlign: 'center' }, align: 'center', tdCls:'x-change-cell',
			editor: {
				xtype		: 'uniCombobox',
				lazyRender	: true,
				comboType	: 'AU',
				comboCode	: 'A207'
			},
			renderer: function (value) {
				var record = Ext.getStore('CBS_AU_A207').findRecord('value', value);
				if (record == null || record == undefined ) {
					return '';
				} else {
					return record.data.text
				}
			}
			
			
			}, 
			{dataIndex: 'SEQ'     		, width: 40,lockable : true, locked:true,style: {textAlign: 'center' }, align: 'center', tdCls:'x-change-cell', editor: {xtype: 'uniTextfield'}	}, 
			{dataIndex: 'WKORD_STATUS'       , width: 65,lockable : true, locked:true,style: {textAlign: 'center' }, align: 'center', tdCls:'x-change-cell',
			editor: {
				xtype		: 'uniCombobox',
				lazyRender	: true,
				comboType	: 'AU',
				comboCode	: 'P001'
			},
			renderer: function (value) {
				var record = Ext.getStore('CBS_AU_P001').findRecord('value', value);
				if (record == null || record == undefined ) {
					return '';
				} else {
					return record.data.text
				}
			}
			
			} 
		];
		var i=0; 
		while((eDate.getTime()-sDate.getTime())>=0){
				var year = sDate.getFullYear();
				var month = (sDate.getMonth()+1).toString().length==1?"0"+(sDate.getMonth()+1).toString():(sDate.getMonth()+1);
				var day = sDate.getDate().toString().length==1?"0"+sDate.getDate():sDate.getDate();
				var weekDay = getDate(sDate.toDateString().substring(0,3));
				columns.push(
						{text :month + '/' + day ,
		        			columns:[
				              {dataIndex: 'WKORD_DATE' +year+month+day    , text: weekDay,      width: 45  ,style: {textAlign: 'center' },align:'right', xtype:'uniNnumberColumn'  ,// format: UniFormat.Qty, 
				                  renderer: function(value, metaData, record) { 
				                  	var today = UniDate.getDateStr(UniDate.today());
				                  	var prodtStartDate = UniDate.getDbDateStr(record.data.PRODT_START_DATE);
				                  	var prodtEndDate = UniDate.getDbDateStr(record.data.PRODT_END_DATE);
				                  	/* if(metaData.column.dataIndex == 'WKORD_DATE'+today){
				                  		metaData.tdCls = 'data-selected';	
				                  	} */
				                  	if(metaData.column.dataIndex == 'WKORD_DATE'+prodtStartDate){
				                  		if(record.data.WKORD_STATUS == '9' || record.data.WKORD_STATUS == '8'){
				                  			//생산완료
				                  			metaData.tdCls = 'x-change-cell_green1';
				                  			value = Ext.util.Format.number(record.data.WKORD_Q,UniFormat.Qty);
				                  		}else{
				                  			metaData.tdCls = 'x-change-cell_pink1';
				                  			value = Ext.util.Format.number(record.data.WKORD_Q,UniFormat.Qty);
				                  		}
				                  	}else if(metaData.column.dataIndex.substring(10,19) >= prodtStartDate && metaData.column.dataIndex.substring(10,19) < prodtEndDate){
				                  		var beforeConvertFrT = UniDate.getDbDateStr(prodtStartDate).substring(0,4) + '/' + UniDate.getDbDateStr(prodtStartDate).substring(4,6) + '/' + UniDate.getDbDateStr(prodtStartDate).substring(6,8);
				           			var beforeConvertTOT = UniDate.getDbDateStr(prodtEndDate).substring(0,4) + '/' + UniDate.getDbDateStr(prodtEndDate).substring(4,6) + '/' + UniDate.getDbDateStr(prodtEndDate).substring(6,8);
				           			var startDateTT	= new Date(beforeConvertFrT);
				           			var endDateTT		= new Date(beforeConvertTOT);
				           			var sDateT = startDateTT;
				           			var eDateT = endDateTT;
				                   	var j=0;
				                   	while((eDateT.getTime()-sDateT.getTime())>=0){
				               			var yearT = sDateT.getFullYear();
				               			var monthT = (sDateT.getMonth()+1).toString().length==1?"0"+(sDateT.getMonth()+1).toString():(sDateT.getMonth()+1);
				               			var dayT = sDateT.getDate().toString().length==1?"0"+sDateT.getDate():sDateT.getDate();
				               			if('WKORD_DATE' +yearT+monthT+dayT == 'WKORD_DATE'+prodtEndDate){
				               				if(record.data.WKORD_STATUS == '9' || record.data.WKORD_STATUS == '8'){
					                  			//생산완료
					                  			metaData.tdCls = 'x-change-cell_green1';
				                  				value = Ext.util.Format.number(record.data.WKORD_Q,UniFormat.Qty);
					                  		}else{
					                  			metaData.tdCls = 'x-change-cell_pink1';
				                  				value = Ext.util.Format.number(record.data.WKORD_Q,UniFormat.Qty);
					                  		}
				                    	}
				               			sDateT.setDate(sDateT.getDate()+1);
				              			  j++;
				              			}
				                  	}
				                  	if(metaData.column.dataIndex == 'WKORD_DATE'+prodtEndDate){
//				                  		metaData.tdCls = 'x-change-cell_blue';	
				                  		if(record.data.WKORD_STATUS == '9' || record.data.WKORD_STATUS == '8'){
				                  			//생산완료
				                  			metaData.tdCls = 'x-change-cell_green1';
				                  			value = Ext.util.Format.number(record.data.WKORD_Q,UniFormat.Qty);
				                  		}else{
				                  			metaData.tdCls = 'x-change-cell_pink1';
				                  			value = Ext.util.Format.number(record.data.WKORD_Q,UniFormat.Qty);
				                  		}
				                  	}
				                      return value; 
				                  }
				              }
		    		]
	    		}
				  );
				  sDate.setDate(sDate.getDate()+1);
				  i++;
			}
		
		return columns;
	};

function createModelField() {
		if(panelResult){
			var beforeConvertFr = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(6,8);
		}else{
			var beforeConvertFr = UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(6,8);
		}
		var startDateT	= new Date(beforeConvertFr);
		var endDateT		= new Date(beforeConvertTO);
		var sDate = startDateT;
		var eDate = endDateT;
		var fields = [
			{name: 'COMP_CODE'     			, text: '법인코드'		, type: 'string'},
			{name: 'DIV_CODE'     			, text: '사업장'		, type: 'string'},
			{name: 'WKORD_NUM'     			, text: '작지번호'		, type: 'string'},
			{name: 'PROG_WORK_CODE'     	, text: '공정코드'		, type: 'string'},
//			{name: 'EQUIP_CODE'     		, text: '호기'		, type: 'string'},
//			{name: 'EQUIP_NAME'     		, text: '호기'		, type: 'string'},
			{name: 'SO_NUM'     			, text: '수주번호'		, type: 'string'},
			{name: 'SO_SEQ'     			, text: '순번'		, type: 'string'},
			{name: 'CUSTOM_CODE'     		, text: '고객사'		, type: 'string'},
			{name: 'CUSTOM_NAME'     		, text: '고객사'		, type: 'string'},
			{name: 'ITEM_NAME'     			, text: '품명'		, type: 'string'},
			{name: 'ITEM_MODEL'     		, text: '모델'		, type: 'string'},
//			{name: 'MOLD_CODE'     			, text: '금형'		, type: 'string'},
			{name: 'WKORD_Q'     			, text: '작지량'	, type: 'uniQty'},
			{name: 'DVRY_DATE'     			, text: '납기일'		, type: 'uniDate'},
			{name: 'ITEM_CODE'     			, text: '작지품번'		, type: 'string'},
			{name: 'SPEC'     				, text: '규격'		, type: 'string'},
			{name: 'WKORD_NUM'     			, text: '작지번호'		, type: 'string'},
			{name: 'PRODT_TYPE'     		, text: '부품타입'		, type: 'string'},
			{name: 'PRODT_MTRL'     		, text: '원료'		, type: 'string'},
			{name: 'ITEM_COLOR'     		, text: '품목색상'		, type: 'string'},
			
			{name: 'PS_OX'     		, text: '자재가능여부'		, type: 'string'},
			
			{name: 'COL_BTN1'     			, text: '후가공'		, type: 'string'},
			{name: 'PRODT_START_DATE'     	, text: '착수예정일'	, type: 'uniDate'},
			{name: 'DAY_COUNT'     			, text: '일수'		, type: 'int'},
			{name: 'PRODT_END_DATE'     	, text: '완료예정일'	, type: 'uniDate'},
			{name: 'CONFIRM_YN'     		, text: '확정여부'		, type: 'string', comboType:'AU', comboCode:'A004'},
			{name: 'SEQ'     				, text: 'SEQ'		, type: 'int'},
			{name: 'WKORD_STATUS'     		, text: '계획상태'		, type: 'string', comboType:'AU', comboCode:'P001'},
			
			{name: 'WKORD_STATUS_REF2'     	, text: '계획상태에 따른 로우 입력 제어'		, type: 'string'}
			
		];
		var j=0; 
		while((eDate.getTime()-sDate.getTime())>=0){
			var year = sDate.getFullYear();
			var month = (sDate.getMonth()+1).toString().length==1?"0"+(sDate.getMonth()+1).toString():(sDate.getMonth()+1);
			var day = sDate.getDate().toString().length==1?"0"+sDate.getDate():sDate.getDate();
			fields.push({name: 'WKORD_DATE'+year+month+day    , text: month + '/' + day,     type : 'string'});
			sDate.setDate(sDate.getDate()+1);
			j++;
		}
		console.log(fields);
		return fields;
	};

function createModelStore() {
		var beforeConvertFr = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(6,8);
		var beforeConvertTO = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(6,8);
		var startDate	= new Date(beforeConvertFr);
		var endDate		= new Date(beforeConvertTO);
	
		var fields = createModelField();
		var addColumn = createGridColumn();
		var tempModelName = new Date().toString();
		
		addModel = Unilite.defineModel(tempModelName, {
			fields: fields
		});
		var addStore = Unilite.createStore('addStore', {
			model: tempModelName,
			uniOpt: {
				isMaster: true,			// 상위 버튼 연결 
				editable: true,			// 수정 모드 사용 
				deletable: false,			// 삭제 가능 여부 
				useNavi: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: directProxyMaster,
			loadStoreRecords: function(){
				var param= panelResult.getValues();
				console.log(param);
				this.load({
					params: param
				});
			},
			listeners: {
	          	load: function(store, records, successful, eOpts) {
	          		setColumnText();
	          		day_change(masterGrid);
	          	},
	          	add: function(store, records, index, eOpts) {
	          	},
	          	update: function(store, record, operation, modifiedFieldNames, eOpts) {
	          	},
	          	remove: function(store, record, index, isMove, eOpts) {
	          	}
			}
		});
		addStore.loadStoreRecords();
		masterGrid.setColumnInfo(masterGrid, addColumn, fields);
		masterGrid.reconfigure(addStore, addColumn);
	};
	
	function createStore_onQuery() {
		var records, fields, columns
		// 그리드 컬럼명 조건에 맞게 재 조회하여 입력
//		var param = panelResult.getValues();
//			records	= response.result;
			fields	= createModelField();
			columns	= createGridColumn();
			masterStore.setFields(fields);
			masterGrid.setColumnInfo(masterGrid, columns, fields);
			masterGrid.reconfigure(masterStore, columns);
			masterStore.loadStoreRecords();
	}
	function setColumnText() {

		masterGrid.getColumn("COMP_CODE").setText("법인코드");    
		masterGrid.getColumn("DIV_CODE").setText("사업장");
//		masterGrid.getColumn("EQUIP_CODE").setText("호기");
//		masterGrid.getColumn("EQUIP_NAME").setText("호기");
		masterGrid.getColumn("SO_NUM").setText("수주번호");
		masterGrid.getColumn("SO_SEQ").setText("순번");
		masterGrid.getColumn("CUSTOM_NAME").setText("고객사");
		masterGrid.getColumn("ITEM_NAME").setText("품명");
		masterGrid.getColumn("ITEM_MODEL").setText("모델");
//		masterGrid.getColumn("MOLD_CODE").setText("금형");
		masterGrid.getColumn("WKORD_Q").setText("작지량");
		masterGrid.getColumn("DVRY_DATE").setText("납기일");
		masterGrid.getColumn("ITEM_CODE").setText("작지품번");
		masterGrid.getColumn("SPEC").setText("규격");
		masterGrid.getColumn("WKORD_NUM").setText("작지번호");
		masterGrid.getColumn("PRODT_TYPE").setText("부품타입");
		masterGrid.getColumn("PRODT_MTRL").setText("원료");
		masterGrid.getColumn("ITEM_COLOR").setText("품목색상");
		masterGrid.getColumn("PS_OX").setText("자재가능여부");
//		masterGrid.getColumn("COL_BTN1").setText("후가공");
		masterGrid.getColumn("PRODT_START_DATE").setText("착수예정일");
		masterGrid.getColumn("DAY_COUNT").setText("일수");
		masterGrid.getColumn("PRODT_END_DATE").setText("완료예정일");
		masterGrid.getColumn("CONFIRM_YN").setText("확정여부");
		masterGrid.getColumn("SEQ").setText("SEQ");
		masterGrid.getColumn("WKORD_STATUS").setText("계획상태");
	};
	
	function getDate(weekDay){
		var weekdays=new Array(7);
		weekdays[0]='<t:message code="system.label.product.sunday" default="일"/>';
		weekdays[1]='<t:message code="system.label.product.monday" default="월"/>';
		weekdays[2]='<t:message code="system.label.product.tuesday" default="화"/>';
		weekdays[3]='<t:message code="system.label.product.wednesday" default="수"/>';
		weekdays[4]='<t:message code="system.label.product.Thursday" default="목"/>';
		weekdays[5]='<t:message code="system.label.product.Friday" default="금"/>';
		weekdays[6]='<t:message code="system.label.product.saturday" default="토"/>';
		switch(weekDay){
		case "Sun" :
			weekDay = weekdays[0];
		break;
		case "Mon" :
			weekDay = weekdays[1];
		break;
		case "Tue" :
			weekDay = weekdays[2];
		break;
		case "Wed" :
			weekDay = weekdays[3];
		break;
		case "Thu" :
			weekDay = weekdays[4];
		break;
		case "Fri" :
			weekDay = weekdays[5];
		break;
		case "Sat" :
			weekDay = weekdays[6];
		break;
		}
		return weekDay;
	};
	
	function day_change(masterGrid){
    	if(panelResult){
			var beforeConvertFr = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_FR')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(0,4) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(4,6) + '/' + UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE_TO')).substring(6,8);
		}else{
			var beforeConvertFr = UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('today')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('todayForMonth')).substring(6,8);
		}
		var startDateT	= new Date(beforeConvertFr);
		var endDateT		= new Date(beforeConvertTO);
		var sDate = startDateT;
		var eDate = endDateT;
		var k = 0;
    	while((eDate.getTime()-sDate.getTime())>=0){
			var year = sDate.getFullYear();
			var month = (sDate.getMonth()+1).toString().length==1?"0"+(sDate.getMonth()+1).toString():(sDate.getMonth()+1);
			var day = sDate.getDate().toString().length==1?"0"+sDate.getDate():sDate.getDate();
			var today = UniDate.getDateStr(UniDate.today());
			if(masterGrid.getColumn("WKORD_DATE"+year+month+day).text == "일"){
				masterGrid.getColumn("WKORD_DATE"+year+month+day).setStyle('color', 'red');
			}
			if(masterGrid.getColumn("WKORD_DATE"+year+month+day).text == "토"){
				masterGrid.getColumn("WKORD_DATE"+year+month+day).setStyle('color', 'blue');
			}
			if(!Ext.isEmpty(masterGrid.getColumn("WKORD_DATE"+today))){
				masterGrid.getColumn("WKORD_DATE"+today).setStyle('background-color', '#62CEDB');
			}
			sDate.setDate(sDate.getDate()+1);
			k++;
		}
    	
    	
    	
    };  
    Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			var calcStandard = panelResult.getValue('RADIOS').RDO_SELECT;
			switch(fieldName) {
				case "DAY_COUNT" :
					if(calcStandard == '1'){
						UniAppManager.app.fnGetWorkDate(fieldName,record,calcStandard,UniDate.getDateStr(record.get('PRODT_START_DATE')),newValue-1,4);
					}else{
						UniAppManager.app.fnGetWorkDate(fieldName,record,calcStandard,UniDate.getDateStr(record.get('PRODT_END_DATE')),(newValue-1)*-1,4);
					}
				break;
				case "PRODT_START_DATE" :
					UniAppManager.app.fnGetWorkDate(fieldName,record,calcStandard,UniDate.getDateStr(newValue),record.get('DAY_COUNT')-1,4);
				break;
				case "PRODT_END_DATE" :
					UniAppManager.app.fnGetWorkDate(fieldName,record,calcStandard,UniDate.getDateStr(newValue),(record.get('DAY_COUNT')-1)*-1,4);
				break;
			}
			return rv;
		}
	});
}
</script>