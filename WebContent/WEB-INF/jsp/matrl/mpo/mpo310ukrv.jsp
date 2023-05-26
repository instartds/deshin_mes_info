<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo310ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="mpo310ukrv"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->
    <t:ExtComboStore comboType="AU" comboCode="M042" /> 			<!-- 생산계획 -->
	<t:ExtComboStore comboType="WU" /><!-- 작업장-->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<style type="text/css">

.x-change-cell1 {
background-color: #fed9fe;
}
.x-change-cell2 {
background-color: #e5fcca;
}
</style>

<script type="text/javascript" >

var searchOrderWindow;
var detailWin;						//수주정보 윈도우

function appMain() {

	var directProxyMaster = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'mpo310ukrvService.selectMaster',
//            create: 'mpo310ukrvService.insertMaster',
            update: 'mpo310ukrvService.updateMaster',
//            destroy: 'mpo310ukrvService.deleteMaster',
            syncAll: 'mpo310ukrvService.saveAllMaster'
        }
    }); 
    
    Unilite.defineModel('mainModel', {
        fields: [
            {name: 'COMP_CODE'          ,text:'법인코드'        ,type: 'string'},
            {name: 'DIV_CODE'           ,text:'사업장'        ,type: 'string'},
            {name: 'ORDER_NUM'          ,text:'수주번호'        ,type: 'string'},
            {name: 'SER_NO'          ,text:'순번'        ,type: 'int'},
            {name: 'SALE_CUSTOM_NAME'     ,text:'수주거래처'        ,type: 'string'},
            {name: 'DVRY_DATE'     ,text:'수주납기일'        ,type: 'uniDate'},
            {name: 'ISSUE_DATE'     ,text:'수주출고일'        ,type: 'uniDate'},
            {name: 'ISSUE_Q'     ,text:'수주출고량'        ,type: 'uniQty'},
            {name: 'DVRY_CUST_NM'     ,text:'납품거래처'        ,type: 'string'},
            {name: 'MODEL_COL'          ,text:'모델'        ,type: 'string'},
            {name: 'ITEM_CODE'          ,text:'품번'        ,type: 'string'},
            {name: 'ITEM_NAME'          ,text:'품명'        ,type: 'string'},
            {name: 'SPEC'            	,text:'규격'        ,type: 'string'},
            {name: 'CLASSFICATION'        ,text:'거래처'        ,type: 'string'},
            {name: 'M_ORDER_PRSN_NAME'            ,text:'구매담당'        ,type: 'string'},
            {name: 'PROC_NAME'            		,text:'가공명'        ,type: 'string'},
            {name: 'STATUS'             ,text:'상태'        ,type: 'string'},
            {name: 'ORDER_Q'            ,text:'발주수량'        ,type: 'uniQty'},
            {name: 'ORDER_DATE'         ,text:'발주일'        ,type: 'uniDate'},
            {name: 'CONFM_YN'             ,text:'접수확인'        ,type: 'string'},
            {name: 'DVRY_ESTI_DATE'     ,text:'납품예정일'        ,type: 'uniDate'},
            {name: 'INIT_DVRY_DATE'     ,text:'최초납기일'        ,type: 'uniDate'},
            {name: 'DUE_DATE'           ,text:'수정납기일'        ,type: 'uniDate',allowBlank:false},
            {name: 'REASON'             ,text:'계획현황'        ,type: 'string', comboType:'AU', comboCode:'M042'},
            {name: 'CITEM_CODE'          ,text:'출고품목코드'        ,type: 'string'},
            {name: 'CITEM_NAME'          ,text:'출고품명'        ,type: 'string'},
            {name: 'REQ_DATE'           ,text:'출고일'        ,type: 'uniDate'},
            {name: 'OUTSTOCK_Q'         ,text:'출고수량'        ,type: 'uniQty'},
            {name: 'IN_DATE'            ,text:'입고일'        ,type: 'uniDate'},
            {name: 'INSTOCK_Q'          ,text:'입고수량'        ,type: 'uniQty'},
            {name: 'LOSS_Q'            	,text:'로스량'        ,type: 'uniQty'},
            {name: 'JAN_Q'              ,text:'잔량'        ,type: 'uniQty'},
            {name: 'REMARK'             ,text:'비고'        ,type: 'string'},
            {name: 'M_ORDER_NUM'        ,text:'발주번호'        ,type: 'string'},
            {name: 'M_ORDER_SEQ'        ,text:'발주순번'        ,type: 'int'},
            {name: 'TYPE'             ,text:'TYPE'        ,type: 'string'},	//1 작업지시, 2 외주/내수
            {name: 'PROG_WORK_CODE'             ,text:'PROG_WORK_CODE'        ,type: 'string'}
           
        ]
    });
    Unilite.defineModel('subModel1', {
        fields: [
            {name: 'COMP_CODE'          ,text:'법인코드'        ,type: 'string'},
            {name: 'DIV_CODE'           ,text:'사업장'        ,type: 'string'},
            {name: 'INOUT_DATE'          ,text:'입고일'        ,type: 'uniDate'},
            {name: 'INOUT_Q'          ,text:'입고수량'        ,type: 'uniQty'}
           
        ]
    });
    
    Unilite.defineModel('subModel2', {
        fields: [
            {name: 'COMP_CODE'          ,text:'법인코드'        ,type: 'string'},
            {name: 'DIV_CODE'           ,text:'사업장'        ,type: 'string'},
            {name: 'INOUT_DATE'          ,text:'출고일'        ,type: 'uniDate'},
            {name: 'INOUT_Q'          ,text:'출고수량'        ,type: 'uniQty'}
           
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
			}
		},
		grouper: {
        	property: 'ORDER_NUM',
        	groupFn: function (item) {
				return item.get('ORDER_NUM') + ', 순번: ' + item.get('SER_NO');
         	}
        }

    });
    
    var subStore1 = Unilite.createStore('subStore1',{
        model: 'subModel1',
        uniOpt : {
            isMaster:  false,            // 상위 버튼 연결
            editable:  false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 'mpo310ukrvService.selectSub1'
			}
		},
        loadStoreRecords : function(param)   {
//            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        },
		listeners:{
			load:function(store, records, successful, eOpts)	{
			}
		}
    });
    
    var subStore2 = Unilite.createStore('subStore2',{
        model: 'subModel2',
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi: false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 'mpo310ukrvService.selectSub2'
			}
		},
        loadStoreRecords : function(param)   {
//            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        },
		listeners:{
			load:function(store, records, successful, eOpts)	{
			}
		}
    });
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5},
        padding:'1 1 1 1',
        border:true,
        items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox' ,
			allowBlank:false,
			comboType: 'BOR120'
	    },{
			fieldLabel: '수주일',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			width: 350,
			allowBlank:false,
			startDate: UniDate.get('twoMonthsAgo'),
			endDate: UniDate.get('todayForMonth')
		},{
			fieldLabel: '<t:message code="system.label.product.sono" default="수주번호"/>',
			xtype: 'uniTextfield',
			name: 'ORDER_NUM',
			listeners: {
                render: function(p) {
                    p.getEl().on('dblclick', function(p) {
                         openSearchOrderWindow();
                    });
                }
            }
		},{
			fieldLabel : '<t:message code="system.label.sales.closingyn" default="마감여부"/>',
			name: 'ORDER_STATUS', 
			xtype: 'uniCombobox', 
			comboType: 'AU',
			comboCode: 'S011',
			colspan: 2
		},
	    Unilite.popup('CUST', {
			fieldLabel: '거래처',
			valueFieldName: 'CUSTOM_CODE',
	   	 	textFieldName: 'CUSTOM_NAME',
	   	 	autoPopup:true
		}),
		{
			fieldLabel: '수주납기일',
		 	xtype: 'uniDateRangefield',
		 	startFieldName: 'DVRY_DATE_FR',
		 	endFieldName: 'DVRY_DATE_TO',
		 	width: 315,
			startDate: UniDate.get('twoMonthsAgo'),
			endDate: UniDate.get('todayForMonth')
		},{
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'S010'
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'WU',
			listeners: {
				beforequery:function( queryPlan, eOpts ) {
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
				}
			}
		},{
			fieldLabel: '모델',
			name:'MODEL_COL',
			xtype: 'uniTextfield'
		},
		
		
		
		
		 Unilite.popup('CUST', {
			fieldLabel: '발주처',
			valueFieldName: 'M_CUSTOM_CODE',
	   	 	textFieldName: 'M_CUSTOM_NAME',
	   	 	autoPopup:true
		}),{
			fieldLabel: '발주납기일',
		 	xtype: 'uniDateRangefield',
		 	startFieldName: 'M_DVRY_DATE_FR',
		 	endFieldName: 'M_DVRY_DATE_TO',
		 	width: 315
		},{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'M_ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'M201',
			listeners: {
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('refCode4') == panelResult.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		}, {
			xtype: 'radiogroup',
			fieldLabel : ' ',				
			items : [{
				boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
				name: 'RDO_SELECT2',
				inputValue : '1',
				width: 70,
				checked	: true
			}, {
				boxLabel: '수주품목',
				name: 'RDO_SELECT2' ,
				inputValue : '2',
				width: 70
			}]
		}, {
			xtype: 'radiogroup',
			fieldLabel : ' ',				
			items : [{
				boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
				name: 'RDO_SELECT',
				inputValue : '1',
				width: 70
			}, {
				boxLabel: '<t:message code="system.label.sales.issuecomplateexclusive" default="출고완료 미포함"/>',
				name: 'RDO_SELECT' ,
				inputValue : '2',
				width: 150,
				checked	: true
			}]
		/*	listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(panelResult){
						panelResult.getField('RDO_SELECT').setValue(newValue.RDO_SELECT);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}*/
		}]
    });

    var masterGrid = Unilite.createGrid('masterGrid', {
        layout : 'fit',
        region: 'north',
        store: masterStore,
        split:true,
        selModel: 'rowmodel',
        flex:3,
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
            }
        },
        features: [{		
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
        columns:  [
            { dataIndex: 'COMP_CODE'           , width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'            , width: 80, hidden: true},
            {
				text	: '수주정보',
				xtype	: 'widgetcolumn',
				width	: 120,
				widget	: {
					xtype		: 'button',
					text		: '수주정보 확인',
					listeners	: {
						buffer	: 1,
						click	: function(button, event, eOpts) {
							var record = event.record.data;
							openDetailWindow(record);
						}
					}
				},
				onWidgetAttach: function(column, widget, record) {
					widget.setText(record.get('DOC_YN') == 'Y'?'<div style="color: red">수주정보 확인</div>':'<div style="color: black">수주정보 확인</div>');
				}
			},
            { dataIndex: 'ORDER_NUM'           , width: 80},
            { dataIndex: 'SER_NO'           , width: 60},
            { dataIndex: 'SALE_CUSTOM_NAME'      , width: 200},
            { dataIndex: 'DVRY_DATE'      , width: 100},
            { dataIndex: 'DVRY_CUST_NM'      , width: 200,hidden:true},
            
            { dataIndex: 'ISSUE_DATE'      , width: 100},
            { dataIndex: 'ISSUE_Q'      , width: 100},
            
            { dataIndex: 'MODEL_COL'           , width: 100},
            { dataIndex: 'ITEM_CODE'           , width: 120},
            { dataIndex: 'ITEM_NAME'           , width: 250},
            { dataIndex: 'SPEC'                , width: 150},
            { dataIndex: 'CLASSFICATION'         , width: 150},
            { dataIndex: 'M_ORDER_PRSN_NAME'              , width: 80,align:'center'},
            { dataIndex: 'PROC_NAME'                  , width: 100,align:'center'},
            { dataIndex: 'STATUS'              , width: 80,align:'center'},
            { dataIndex: 'ORDER_Q'             , width: 100},
            { dataIndex: 'ORDER_DATE'          , width: 100},
            { dataIndex: 'CONFM_YN'          , width: 80,align:'center'},
            { dataIndex: 'DVRY_ESTI_DATE'      , width: 100},
            { dataIndex: 'INIT_DVRY_DATE'      , width: 100},
            { dataIndex: 'DUE_DATE'            , width: 100,tdCls:'x-change-cell_bg_FFFFC6'},	//연노랑
            { dataIndex: 'REASON'            , width: 100,align:'center',tdCls:'x-change-cell_bg_FFFFC6'},	//연노랑
            { dataIndex: 'CITEM_CODE'          , width: 100, hidden: true},
            { dataIndex: 'CITEM_NAME'          , width: 200, hidden: true},
            { dataIndex: 'REQ_DATE'            , width: 100,tdCls:'x-change-cell1'},		//연분홍
            { dataIndex: 'OUTSTOCK_Q'          , width: 100,tdCls:'x-change-cell1'},
            { dataIndex: 'IN_DATE'                  , width: 100,tdCls:'x-change-cell2'},	//연녹색
            { dataIndex: 'INSTOCK_Q'           , width: 100,tdCls:'x-change-cell2'},
            { dataIndex: 'LOSS_Q'                  , width: 100,tdCls:'x-change-cell2'},
            { dataIndex: 'JAN_Q'               , width: 100,tdCls:'x-change-cell2'},
            { dataIndex: 'REMARK'              , width: 200,tdCls:'x-change-cell_bg_FFFFC6'},	//연노랑
            { dataIndex: 'M_ORDER_NUM'         , width: 100, hidden: true},
            { dataIndex: 'M_ORDER_SEQ'         , width: 100, hidden: true}
            
        ],
	/*	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	if(record.get('CORE_CODE').substring(record.get('CORE_CODE').length-1) != 0){
					cls = 'x-change-cell_bg_FFFFC6';	
				}
				return cls;
	        }
	    },*/
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['REMARK','REASON'])){
					return true;
				}else if(UniUtils.indexOf(e.field, ['DUE_DATE'])){
    				if(e.record.data.TYPE == '2'){
						return true;
        			}else{
        				return false;
        			}
				}else{
					return false;
				}
            },
           
        	beforeselect: function(){
        	},
            selectionchange:function( model1, selected, eOpts ){
        	
	      		if(selected.length > 0) {
					var record = selected[0];
					if(Ext.isEmpty(record.get('M_ORDER_NUM'))){
						subStore1.loadData({});
						subStore2.loadData({});
					}else{
						var param = {
							DIV_CODE : record.get('DIV_CODE'),
							M_ORDER_NUM : record.get('M_ORDER_NUM'),
							M_ORDER_SEQ : record.get('M_ORDER_SEQ'),
							CITEM_CODE : record.get('CITEM_CODE')
						};
						subStore1.loadStoreRecords(param);
						subStore2.loadStoreRecords(param);
					}
				}else{
					subStore1.loadData({});
					subStore2.loadData({});
				}
				
            },
            onGridDblClick:function(grid, record, cellIndex, colName) {
            },
			cellclick :function(grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			}
        }
    });
    var subGrid1 = Unilite.createGrid('subGrid1', {
        layout : 'fit',
        region: 'north',
        store: subStore1,
        split:true,
        flex:1,
        selModel: 'rowmodel',
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            onLoadSelectFirst: false,
            filter: {
                useFilter: true,
                autoCreate: true
            },state: {
                useState: false,         
                useStateList: false      
            }
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true,
			dock: 'bottom'
		}],
        columns:  [
            { dataIndex: 'COMP_CODE'           , width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'            , width: 80, hidden: true},
            { dataIndex: 'INOUT_DATE'           , width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
            { dataIndex: 'INOUT_Q'           , width: 100, summaryType: 'sum'}
            
        ]
    });
    var subGrid2 = Unilite.createGrid('subGrid2', {
        layout : 'fit',
        region: 'center',
        store: subStore2,
        split:true,
        flex:1,
        selModel: 'rowmodel',
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            onLoadSelectFirst: false,
            filter: {
                useFilter: true,
                autoCreate: true
            },state: {
                useState: false,         
                useStateList: false      
            }
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true,
			dock: 'bottom'
		}],
        columns:  [
            { dataIndex: 'COMP_CODE'           , width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'            , width: 80, hidden: true},
            { dataIndex: 'INOUT_DATE'           , width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
            { dataIndex: 'INOUT_Q'           , width: 100, summaryType: 'sum'}
            
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

            ,{ name: 'ORDER_Q'      ,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'        	,type: 'uniQty' }
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
            ,{ dataIndex: 'ORDER_Q'				,  width: 80 }
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
                'ORDER_SEQ': record.get('SER_NO'),
                'DVRY_DATE': record.get('DVRY_DATE'),
                'ORDER_Q': record.get('ORDER_Q'),
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
    
    //수주정보 확인버튼관련
	var detailForm = Unilite.createForm('orderInfo', {
		autoScroll	: true,
		layout		: 'fit',
		layout		: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}},
		defaults	: {labelWidth:60},
		disabled	: false,
		items		: [{
			xtype	: 'xuploadpanel',
			id		: 'orderInfoFileUploadPanel',
			itemId	: 'fileUploadPanel',
			flex	: 1,
			width	: 975,
			height	: 300,
			listeners : {
			}
		}],
		loadForm: function(record)	{
			this.reset();
			this.resetDirtyStatus();

			var fp = Ext.getCmp('orderInfoFileUploadPanel');
			var ordernum = record.ORDER_NUM;
			if(!Ext.isEmpty(ordernum)) {
				s_sof110skrv_shService.getFileList({DOC_NO : ordernum}, function(provider, response) {
					fp.loadData(response.result.data);
				})
			}else {
				fp.clear(); //  fp.loadData() 실행 시 데이타 삭제됨.
			}
		}
	});  // detailForm
	function openDetailWindow(record) {
		detailForm.loadForm(record);
		if(!detailWin) {
			detailWin = Ext.create('widget.uniDetailWindow', {
				title	: '수주정보',
				width	: 1000,
				height	: 370,
				isNew	: false,
				x		: 0,
				y		: 0,
				layout	: {type:'vbox', align:'stretch'},
				items	: [detailForm],
				tbar	: ['->', {
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						detailWin.hide();
					},
					disabled: false
				}],
				listeners : {
					show:function( window, eOpts)  {
						detailForm.body.el.scrollTo('top',0);
					}
				}
			})
		}
		detailWin.show();
		detailWin.center();
	}
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[panelResult,{
                region: 'center',
                xtype: 'container',
                layout: 'fit',
                layout: {type:'vbox', align:'stretch'},
                split:true,
                flex: 1,
                items: [ masterGrid]
            },{
                region: 'east',
                xtype: 'container',
                layout: 'fit',
                layout: {type:'vbox', align:'stretch'},
                split:true,
                width:250,
                items: [subGrid1,subGrid2]
			}]
        }],
        id  : 'mpo310ukrvApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            masterStore.loadStoreRecords();
        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
			masterStore.loadData({});
            subGrid1.reset();
			subStore1.loadData({});
            subGrid2.reset();
			subStore2.loadData({});
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
            
            panelResult.setValue('ORDER_DATE_FR',UniDate.get('twoMonthsAgo'));
            panelResult.setValue('ORDER_DATE_TO',UniDate.get('todayForMonth'));
            
            panelResult.setValue('DVRY_DATE_FR',UniDate.get('twoMonthsAgo'));
            panelResult.setValue('DVRY_DATE_TO',UniDate.get('todayForMonth'));
            
            UniAppManager.setToolbarButtons(['save', 'delete', 'deleteAll'],false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
            masterStore.setGrouper({
	        	property: 'ORDER_NUM',
	        	groupFn: function (item) {
					return item.get('ORDER_NUM') + ', 순번: ' + item.get('SER_NO');
	         	}
	        });
        }
    });
}
</script>