<%--
'   프로그램명 : 구매요청등록 (구매)
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
<t:appConfig pgmId="mpo070ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo070ukrv" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->

</t:appConfig>
<style type="text/css">

.x-change-cell {
background-color: #FFFFC6;
}
.x-change-cell2 {
background-color: #FDE3FF;
}
</style>
<script type="text/javascript" >

var referOrderInformationWindow;		//수주정보참조

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo070ukrvService.selectMasterList',
            create: 'mpo070ukrvService.insertMaster',
			update: 'mpo070ukrvService.updateMaster',
			destroy: 'mpo070ukrvService.deleteMaster',
			syncAll: 'mpo070ukrvService.saveMaster'
		}
	});


	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo070ukrvService.selectDetailList',
			update: 'mpo070ukrvService.updateDetail',
			syncAll: 'mpo070ukrvService.saveDetail'
		}
	});

	/* 수주정보 참조 */
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo070ukrvService.selectOrderList'
		}
	});

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create: 'mpo070ukrvService.buttonInsert',
            syncAll: 'mpo070ukrvService.buttonSave'
		}
	});
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('mpo070ukrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string'},
			{name: 'PROD_ITEM_CODE'	 	,text: '<t:message code="system.label.purchase.item" default="품목"/>'					,type: 'string',allowBlank:false},
			{name: 'ITEM_NAME'	 		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'					,type: 'string'},
			{name: 'ITEM_ACCOUNT'       ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'				,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'PL_QTY'				,text: '계산수량'				,type: 'uniQty',allowBlank:false},
			{name: 'PL_COST'			,text: '재료비'				,type: 'uniPrice'},
			{name: 'PL_AMOUNT'			,text: '외주가공비'				,type: 'uniPrice'},
			{name: 'CSTOCK'				,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'				,type: 'uniQty'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.purchase.seq" default="순번"/>'					,type: 'string'},

			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate'},
			{name: 'WEEK_NUM'		,text: '<t:message code="system.label.purchase.deliveryweek" default="납기주차"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},

			{name: 'MRP_CONTROL_NUM'	,text: 'MRP번호'				,type: 'string'},
			{name: 'REMARK'		 		,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'PROJECT_NAME'		,text: '프로젝트명'			,type: 'string'}
		]
	});

	Unilite.defineModel('mpo070ukrvModel2', {
	    fields: [
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string'},
			{name: 'PROD_ITEM_CODE'	 	,text: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>'				,type: 'string'},
			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.purchase.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'	 		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'					,type: 'string'},
			{name: 'ITEM_ACCOUNT'       ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'				,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'UNIT_Q'				,text: '윈단위량'				,type: 'uniQty'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string'},
			{name: 'CHILD_PRICE'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'					,type: 'uniPrice'},
			{name: 'CHILD_AMOUNT'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'					,type: 'uniPrice'},
			{name: 'CSTOCK'				,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'				,type: 'uniQty'},
			{name: 'PURCH_LDTIME'		,text: '구매LT'				,type: 'uniQty'},
			{name: 'SAFE_STOCK_Q'		,text: '<t:message code="system.label.purchase.safetystock" default="안전재고"/>'				,type: 'uniQty'},
			{name: 'PL_QTY'				,text: '소요량'				,type: 'uniQty'},
			{name: 'CALC_PLAN_QTY'		,text: '<t:message code="system.label.purchase.purchaseplanq" default="구매계획량"/>'				,type: 'float', decimalPrecision: 3, format:'0,000.000'},
			{name: 'ORDER_REQ_Q'		,text: '<t:message code="system.label.purchase.purchaserequestq" default="구매요청량"/>'				,type: 'float', decimalPrecision: 3, format:'0,000.000'}, //발주요청량
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				,type: 'uniQty'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					,type: 'string'},
			{name: 'ORDER_REQ_NUM'		,text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'			,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				,type: 'string'},
	    	{name: 'ORDER_SEQ'        		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'				, type: 'int'}
		]
	});


	var buttonStore = Unilite.createStore('mpo070ukrvButtonStore',{
        uniOpt: {
            isMaster	: false,            // 상위 버튼 연결
            editable	: false,            // 수정 모드 사용
            deletable	: false,        	// 삭제 가능 여부
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			//폼에서 필요한 조건 가져올 경우
			var paramMaster			= panelResult.getValues();
//			paramMaster.DIV_CODE	= addResult.getValue('DIV_CODE');
//            paramMaster.OPR_FLAG	= buttonFlag;
//            paramMaster.LANG_TYPE	= UserInfo.userLang

			if(inValidRecs.length == 0) {
                config = {
					params: [paramMaster],
                    success: function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();

                        UniAppManager.app.onQueryButtonDown();
                        buttonStore.clearData();
                     },

                     failure: function(batch, option) {
                        buttonStore.clearData();
                     }
                };
                this.syncAllDirect(config);

            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('mpo070ukrvMasterStore',{
		model: 'mpo070ukrvModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결
           	editable: true,			// 수정 모드 사용
           	deletable: true,			// 삭제 가능 여부
	        useNavi: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
        saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var paramMaster= panelResult.getValues();	//syncAll 수정

			config = {
				params: [paramMaster],
				success: function(batch, option) {

					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.app.onQueryButtonDown();
				}
			};
			this.syncAllDirect(config);
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
        listeners: {
            load: function(store, records, successful, eOpts) {
            	panelResult.getField('DIV_CODE').setReadOnly(true);
            },
            add: function(store, records, index, eOpts) {
            	UniAppManager.setToolbarButtons('delete', true);
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
	});


	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directDetailStore = Unilite.createStore('mpo070ukrvDetailStore',{
		model: 'mpo070ukrvModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
           	editable: true,			// 수정 모드 사용
           	deletable: true,			// 삭제 가능 여부
	        useNavi: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy2,
		loadStoreRecords: function(record) {
			var param= panelResult2.getValues();
			param.DIV_CODE = record.data.DIV_CODE;
			param.MRP_CONTROL_NUM = record.data.MRP_CONTROL_NUM;
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var paramMaster= panelResult.getValues();	//syncAll 수정
			//paramMaster.put("PROD_ITEM_CODE", )
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('mpo070ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: false,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			holdable: 'hold',
//			readOnly: true,
			value: UserInfo.divCode
		},{
			name: 'ITEM_ACCOUNT',
			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B020'
		},{
			name: 'SUPPLY_TYPE',
			fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B014'
		}, Unilite.popup('PROJECT',{
			fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
			valueFieldName:'PJT_CODE',
		    textFieldName:'PJT_NAME',
       		DBvalueFieldName: 'PJT_CODE',
		    DBtextFieldName: 'PJT_NAME',
			validateBlank: false,
			textFieldOnly: false,
			colspan:3,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('REMARK', records[0]['PJT_NAME']);
					},
					scope: this
				},
				onClear: function(type) {
				}
			}
		}),{
        	xtype:'uniTextfield',
        	fieldLabel:'<t:message code="system.label.purchase.remarks" default="비고"/>',
        	name:'REMARK',
        	width: 700,
        	colspan:2,
        	allowBlank:true
        },{
        	xtype:'button',
        	text:'소요량계산',
        	margin: '0 0 0 100',
        	handler:function(){
				if(!panelResult.getInvalidMessage()) return;   //필수체크

				var records = masterGrid.getSelectedRecords();
				if(Ext.isEmpty(records)){
					alert("소요량계산할 데이터를 선택해주십시오.");
					return;
				}
	            fnMakeLogStore();
        	}
        }]
    });

    var panelResult2 = Unilite.createSearchForm('resultForm2',{
    	region: 'south',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			name: 'ITEM_ACCOUNT',
			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B020'
		},{
			xtype: 'container',
			layout: {type : 'table', columns : 2},
			tdAttrs: {align: 'right'},
			width:150,
	    	items:[{
	        	xtype:'button',
	        	text:'<div style="color: red">조회</div>',
	    		width: 100,
	        	handler:function(){
					var record = masterGrid.getSelectedRecord();
					if(Ext.isEmpty(record)){
						alert('조회 할 데이터가 없습니다.');
						return false;
					}else{
        				directDetailStore.loadStoreRecords(record);
					}
	        	}
	        }]
		}]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('mpo070ukrvGrid', {
    	region: 'center' ,
        layout: 'fit',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        tbar: [{
			itemId: 'requestBtn',
			text: '<div style="color: blue">수주정보참조</div>',
			handler: function() {
				openOrderInformationWindow();
			}
		}],
    	store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
    	selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly : false,
			toggleOnClick:false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){

            		UniAppManager.setToolbarButtons('delete', true);
				},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			if(grid.selected.items.length == 0){
            			UniAppManager.setToolbarButtons('delete', false);
	    			}
	    		}
			}
		}),
        columns: [
        	{dataIndex:'COMP_CODE'					, width: 100 , 		hidden:true},
        	{dataIndex:'DIV_CODE'					, width: 100 , 		hidden:true},
        	{dataIndex:'PROD_ITEM_CODE'	 			, width: 100 ,
        		editor: Unilite.popup('DIV_PUMOK_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROD_ITEM_CODE',records[0]['ITEM_CODE']);
                            grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);

                        },
                        onClear:function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROD_ITEM_CODE','');
                            grdRecord.set('ITEM_NAME','');

                        }
                    }
                }),
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
          			return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.totalamount" default="합계"/>');
            	}
        	},
        	{dataIndex:'ITEM_NAME'	 				, width: 140,
        		editor: Unilite.popup('DIV_PUMOK_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROD_ITEM_CODE',records[0]['ITEM_CODE']);
                            grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);

                        },
                        onClear:function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROD_ITEM_CODE','');
                            grdRecord.set('ITEM_NAME','');

                        }
                    }
                })

        	},
        	{dataIndex:'SPEC'	 					, width: 100 },
        	{dataIndex:'ITEM_ACCOUNT'	 			, width: 80 },
        	{dataIndex:'SUPPLY_TYPE'	 			, width: 80 },
        	{dataIndex:'PL_QTY'	 					, width: 80 		,summaryType: 'sum'},
        	{dataIndex:'PL_COST'	 				, width: 80 		,summaryType: 'sum'},
        	{dataIndex:'PL_AMOUNT'	 				, width: 100 		,summaryType: 'sum'},
        	{dataIndex:'CSTOCK'	 					, width: 80 		,summaryType: 'sum'},
        	{dataIndex:'ORDER_NUM'	 				, width: 120 },
        	{dataIndex:'SER_NO'	 					, width: 80 },

        	{dataIndex:'DVRY_DATE'	 				, width: 80 },
        	{dataIndex:'WEEK_NUM'	 				, width: 80 },
        	{dataIndex:'CUSTOM_NAME'				, width: 150 },

        	{dataIndex:'PROJECT_NO'					, width: 100 },
        	{dataIndex:'PROJECT_NAME'				, width: 150 },
        	{dataIndex:'MRP_CONTROL_NUM'	 		, width: 120 },
        	{dataIndex:'REMARK'		 				, width: 220 ,flex: 1}
        ],
        setData: function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('COMP_CODE'           , record['COMP_CODE']);
            grdRecord.set('DIV_CODE'          	, panelResult.getValue('DIV_CODE'));
            grdRecord.set('PROD_ITEM_CODE'      , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'          	, record['ITEM_NAME']);
            grdRecord.set('SPEC'          		, record['SPEC']);
            grdRecord.set('ITEM_ACCOUNT'        , record['ITEM_ACCOUNT']);
            grdRecord.set('SUPPLY_TYPE'         , record['SUPPLY_TYPE']);
            grdRecord.set('PL_QTY'          	, record['ORDER_Q']);
            grdRecord.set('CSTOCK'          	, record['CSTOCK']);
            grdRecord.set('ORDER_NUM'          	, record['ORDER_NUM']);
            grdRecord.set('SER_NO'          	, record['SER_NO']);
            grdRecord.set('PROJECT_NO'          , record['PROJECT_NO']);
            grdRecord.set('PROJECT_NAME'        , record['PROJECT_NAME']);
        },
        listeners:{
        	selectionchange:function(grid, selected, eOpts){
        		if(selected.length > 0)	{
	        		var record = selected[0];
	        		directDetailStore.loadData({})
	        		if(!record.phantom){
	        			directDetailStore.loadStoreRecords(record);
	        		}
            		UniAppManager.setToolbarButtons('delete', true);
       			}else{
					detailGrid.reset();
					directDetailStore.clearData();
            		UniAppManager.setToolbarButtons('save', false);
       			}
        	},
        	beforeedit:function(editor, e, eOpts) {
				if(e.record.phantom == false){
					if(UniUtils.indexOf(e.field, ['PL_QTY'])){
						return true;
					}else{
						return false;
					}
				}else{
					return true;
				}
            }
        }
    });

    /**
     * Master Grid2 정의(Grid Panel)
     * @type
     */
    var detailGrid= Unilite.createGrid('mpo070ukrvGrid2', {
    	region:'south',
        layout: 'fit',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
    	store: directDetailStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns: [
        	{dataIndex: 'COMP_CODE'			, width: 100 , 		hidden:true},
        	{dataIndex: 'DIV_CODE'			, width: 100 , 		hidden:true},
        	{dataIndex: 'PROD_ITEM_CODE'	, width: 100 , 		hidden:true},
        	{dataIndex: 'CHILD_ITEM_CODE'	, width: 100 , locked:true},
			{dataIndex: 'ITEM_NAME'	 		, width: 200 , locked:true},
			{dataIndex: 'SPEC'				, width: 160},
			{dataIndex: 'STOCK_UNIT'		, width: 66		,align:'center'  },
			{dataIndex: 'ITEM_ACCOUNT'      , width: 80 	,align:'center' },
			{dataIndex: 'SUPPLY_TYPE'		, width: 80		,align:'center'  },
			{dataIndex: 'UNIT_Q'			, width: 80 , 		hidden:true},
			{dataIndex: 'ORDER_UNIT'		, width: 80		,align:'center'  },
			{dataIndex: 'CHILD_PRICE'		, width: 80 },
			{dataIndex: 'CHILD_AMOUNT'		, width: 80 },
			{dataIndex: 'CSTOCK'			, width: 80 },
			{dataIndex: 'PURCH_LDTIME'		, width: 80 },
			{dataIndex: 'SAFE_STOCK_Q'		, width: 80 },
			{dataIndex: 'PL_QTY'			, width: 80 },
			{dataIndex: 'CALC_PLAN_QTY'		, width: 100 ,tdCls:'x-change-cell2'},
			{dataIndex: 'ORDER_REQ_Q'		, width: 100,tdCls:'x-change-cell'},
			{dataIndex: 'ORDER_Q'			, width: 100 },
    		{dataIndex: 'CUSTOM_CODE'		, width: 66,
			  'editor': Unilite.popup('CUST_G',{
        	  	 	textFieldName : 'CUSTOM_CODE',
        	  	 	DBtextFieldName : 'CUSTOM_CODE',
					autoPopup:true,
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;
    						grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    						grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;
    						grdRecord.set('CUSTOM_CODE','');
    						grdRecord.set('CUSTOM_NAME','');
	                  }
        	  	 	}
				})
			},
    		{dataIndex: 'CUSTOM_NAME'		, width: 170,
			  'editor': Unilite.popup('CUST_G',{
					autoPopup:true,
        	  	 	listeners: { 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;
    						grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    						grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
	                    },
	                    scope: this
	                  },
	                  'onClear' : function(type)	{
	                    	var grdRecord = detailGrid.uniOpt.currentRecord;
    						grdRecord.set('CUSTOM_CODE','');
    						grdRecord.set('CUSTOM_NAME','');
	                  }
        	  	 	}
				})
			},
			{dataIndex: 'PROJECT_NO'	, width: 100 },
			{dataIndex: 'REMARK'		, width: 200 },
			{dataIndex: 'ORDER_REQ_NUM'	, width: 100 },
			{dataIndex: 'ORDER_NUM'	, width: 100 	, hidden: true} ,
			{dataIndex: 'ORDER_SEQ'	, width: 100 	, hidden: true}
        ],
        listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        		if(UniUtils.indexOf(e.field, ['ORDER_REQ_Q', 'CUSTOM_CODE', 'CUSTOM_NAME'])){
					return true;
				}
                return false;
        	}
        }
    });

  	//수주참조 참조 메인
    function openOrderInformationWindow() {
		if(!panelResult.getInvalidMessage()) return;   //필수체크
  		OrderSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));

		if(!referOrderInformationWindow) {
			referOrderInformationWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주정보참조',
                width: 1200,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [OrderSearch, OrderGrid],
                tbar:  ['->',
			        {	itemId : 'saveBtn',
			        	id:'saveBtn1',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							OrderStore.loadStoreRecords();
						},
						disabled: false
					},
					{	itemId : 'confirmBtn',
						id:'confirmBtn1',
						text: '확인',
						handler: function() {

							if(!Ext.isEmpty(masterGrid.getSelectedRecords)){
								OrderGrid.returnData();
								var maxIndex = 0;
								Ext.each(directMasterStore.data.items, function(record, index, records){
									if(record.phantom){
										maxIndex = index
									}
								});
								masterGrid.getSelectionModel().selectRange(0, maxIndex);
							}
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						id:'confirmCloseBtn1',
						text: '확인 후 닫기',
						handler: function() {
							if(!Ext.isEmpty(masterGrid.getSelectedRecords)){
								OrderGrid.returnData();
								var maxIndex = 0;
								Ext.each(directMasterStore.data.items, function(record, index, records){
									if(record.phantom){
										maxIndex = index
									}
								});
								masterGrid.getSelectionModel().selectRange(0, maxIndex);
								referOrderInformationWindow.hide();
							}
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						id:'closeBtn1',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referOrderInformationWindow.hide();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{},
                	beforeclose: function( panel, eOpts )	{},
                	beforeshow: function ( me, eOpts )	{
                		OrderSearch.setValue('DIV_CODE', panelResult.getValue("DIV_CODE"));
                		OrderSearch.setValue('SUPPLY_TYPE', panelResult.getValue("SUPPLY_TYPE"));
                		OrderSearch.setValue('ITEM_ACCOUNT', panelResult.getValue("ITEM_ACCOUNT"));
                		OrderStore.loadStoreRecords();
                	}
                }
			})
		}
		referOrderInformationWindow.center();
		referOrderInformationWindow.show();
    }

 // 수주정보 참조 모델 정의
	Unilite.defineModel('mpo070ukrvOrderModel', {
	    fields: [
	    	{name: 'DIV_CODE'    		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'},
	    	{name: 'ORDER_NUM'     		, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				, type: 'string'},
	    	{name: 'SER_NO'        		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'				, type: 'int'},
		    {name: 'ITEM_CODE'     		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
		    {name: 'ITEM_NAME'     		, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				, type: 'string'},
		    {name: 'SPEC'          		, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
		    {name: 'STOCK_UNIT'    		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
		    {name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				, type: 'string', comboType:'AU', comboCode:'B020'},
		    {name: 'SUPPLY_TYPE'		, text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'				, type: 'string', comboType:'AU', comboCode:'B014'},
		    {name: 'ORDER_DATE'    		, text: '수주일'				, type: 'uniDate'},
		    {name: 'ORDER_Q'       		, text: '<t:message code="system.label.purchase.soqty" default="수주량"/>' 			, type: 'uniQty'},
		    {name: 'CSTOCK'				, text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'				, type: 'uniQty'},
		    {name: 'WORK_SHOP_CODE'		, text: '주작업장'				, type: 'string' , comboType: 'WU'},
		    {name: 'PROJECT_NO'    		, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			, type: 'string'},
		    {name: 'PROJECT_NAME'    	, text: '프로젝트명'			, type: 'string'},
		    {name: 'PJT_CODE'      		, text: '프로젝트코드'			, type: 'string'}
		]
	});

	//수주정보 참조 스토어 정의
	var OrderStore = Unilite.createStore('mpo070ukrvOrderStore', {
		model: 'mpo070ukrvOrderModel',
        autoLoad: false,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결
           	editable: false,			// 수정 모드 사용
           	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: directProxy3,
        loadStoreRecords : function()	{
			var param= OrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);

			var paramMaster= OrderSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						var param = {KEY_VALUE: master.KEY_VALUE};

						OrderStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('mpo070ukrvOrderGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

    /**
	 * 수주정보참조을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주정보 참조 폼 정의
	 var OrderSearch = Unilite.createSearchForm('OrderForm', {
            layout :  {type : 'uniTable', columns : 3},
            items :[{
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120',
	        	readOnly: true
	        },{
       			name: 'ITEM_ACCOUNT',
    			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
    			xtype:'uniCombobox',
    			comboType:'AU',
    			comboCode:'B020',
    			listeners: {
    				change: function(field, newValue, oldValue, eOpts) {
    					panelResult.setValue('ITEM_ACCOUNT', newValue);
    				}
    			}
			},
			{ fieldLabel: '수주일'
                           ,xtype: 'uniDateRangefield'
                           ,startFieldName: 'FR_ORDER_DATE'
                           ,endFieldName: 'TO_ORDER_DATE'
                           ,width: 350
                           ,startDate: UniDate.get('startOfMonth')
                           ,endDate: UniDate.get('today')
                         },
			 Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>',
				valueFieldName:'PJT_CODE',
			    textFieldName:'PJT_NAME',
	       		DBvalueFieldName: 'PJT_CODE',
			    DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
				textFieldOnly: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('REMARK', records[0]['PJT_NAME']);
							panelResult.setValue('PJT_CODE', records[0]['PJT_CODE']);
							panelResult.setValue('PJT_NAME', records[0]['PJT_NAME']);
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup) {
					},
					change: function(field, newValue, oldValue, eOpts) {
                    }
				}
			}),
					{
                 xtype: 'fieldcontainer',
                 fieldLabel: '<t:message code="system.label.purchase.sono" default="수주번호"/>',
                 combineErrors: true,
                 msgTarget : 'side',
                 layout: {type : 'table', columns : 3},
                 defaults: {
                     flex: 1,
                     hideLabel: true
                 },
                 defaultType : 'textfield',
                 items: [
                 	Unilite.popup('ORDER_NUM',{
			        	fieldLabel: '',
			        	valueFieldName: 'FROM_NUM',
			        	textFieldName: 'FROM_NUM',
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
			   		})/* ,
                 	{xtype:  'displayfield', value:'&nbsp;~&nbsp;'},
                 	Unilite.popup('ORDER_NUM',{
			        	fieldLabel: '',
			        	valueFieldName: 'TO_NUM',
			        	textFieldName: 'TO_NUM',
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
			   		}) */
                   ]
               },{
	                 xtype: 'fieldcontainer',
	                 fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
	                 combineErrors: true,
	                 msgTarget : 'side',
	                 colspan:2,
	                 layout: {type : 'table', columns : 3},
	                 defaults: {
	                     flex: 1,
	                     hideLabel: true
	                 },
	                 defaultType : 'textfield',
	                 items: [
		                 Unilite.popup('DIV_PUMOK',{
				        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				        	valueFieldName: 'ITEM_CODE_FR',
							textFieldName: 'ITEM_NAME_FR',
							allowBlank:false,
				        	listeners: {
								applyextparam: function(popup){
									popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
								}
							}
				   		})/* ,
				   		{xtype:  'displayfield', value:'&nbsp;~&nbsp;'},
	                 	Unilite.popup('DIV_PUMOK',{
					        fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					        valueFieldName: 'ITEM_CODE_TO',
							textFieldName: 'ITEM_NAME_TO',
							allowBlank:false,
					        listeners: {
								applyextparam: function(popup){
									popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
								}
							}
					   	}) */
                  	]
				}
    		]
    });


	/* 수주정보 그리드 */
	 var OrderGrid = Unilite.createGrid('mpo070ukrvOrderGrid', {
    	layout : 'fit',
    	store: OrderStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
        columns: [
        	{ dataIndex: 'ORDER_NUM'        		, width: 120},
        	{ dataIndex: 'SER_NO'           		, width: 80},
        	{ dataIndex: 'ITEM_CODE'        		, width: 120},
        	{ dataIndex: 'ITEM_NAME'        		, width: 140},
        	{ dataIndex: 'SPEC'             		, width: 126},
        	{ dataIndex: 'STOCK_UNIT'       		, width: 80},
        	{ dataIndex: 'ITEM_ACCOUNT'          	, width: 80},
        	{ dataIndex: 'SUPPLY_TYPE'       		, width: 80},
        	{ dataIndex: 'ORDER_DATE'       		, width: 80},
        	{ dataIndex: 'ORDER_Q'          		, width: 80},
        	{ dataIndex: 'CSTOCK'					, width: 100},
        	{ dataIndex: 'WORK_SHOP_CODE'   		, width: 100  	, hidden: true},
        	{ dataIndex: 'PROJECT_NO'       		, width: 100},
        	{ dataIndex: 'PROJECT_NAME'       		, width: 130},
        	{ dataIndex: 'PJT_CODE'         		, width: 100 	, hidden: true}
		]
		,listeners: {
        	onGridDblClick:function(grid, record, cellIndex, colName) {
  			},
	       	deselect: function( model, record, index, eOpts ){
			},
			select: function( model, record, index, eOpts ){
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
      			records = this.getSelectedRecords();
      		}
			Ext.each(records, function(record,i) {
				panelResult.setValue('REMARK'        , record.data.PROJECT_NAME);
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setData(record.data);
			});
        	panelResult.getField('DIV_CODE').setReadOnly(true);
       	}
    });

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,panelResult2, detailGrid, panelResult
			]}
		],
		id: 'mpo070ukrvApp',
		fnInitBinding: function() {
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;   //필수체크

			var divCode 		= panelResult.getValue('DIV_CODE');
			var itemAccount 	= panelResult.getValue('ITEM_ACCOUNT');
			var supplyType 		= panelResult.getValue('SUPPLY_TYPE');
			var pjtCode 		= panelResult.getValue('PJT_CODE');
			var remark 			= panelResult.getValue('REMARK');
			var compCode 		= UserInfo.compCode;
	       	var r = {
	       		COMP_CODE 				: compCode,
	       		DIV_CODE 				: divCode,
	       		PROD_ITEM_CODE 			: '',
	       		ITEM_NAME 				: '',
	       		SPEC					: '',
	       		ITEM_ACCOUNT			: itemAccount,
	       		SUPPLY_TYPE				: supplyType,
	       		PL_QTY					: 0,
	       		PL_COST					: 0,
	       		PL_AMOUNT				: 0,
	       		CSTOCK					: 0,
	       		ORDER_NUM				: '',
	       		SER_NO					: 0,
	       		MRP_CONTROL_NUM			: '',
	       		REMARK					: remark
	       	}
			masterGrid.createRow(r);
        	UniAppManager.setToolbarButtons('delete', true);
		},
		onResetButtonDown: function() {

			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			detailGrid.reset();
			directDetailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
//			directMasterStore.saveStore();
			directDetailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {

			var selRows = masterGrid.getSelectedRecords();
			var cnt = 0;
			Ext.each(selRows, function(row, index){
				if(row.phantom == false){
					cnt = cnt + 1;
				}
			});

			if(cnt > 0){
				if(confirm("선택한 데이터를 삭제 합니다. 삭제 하시겠습니까?"))	{
					var selRow = masterGrid.getSelectedRecord();

					if(selRow) {
						masterGrid.deleteSelectedRow();
					}
					directMasterStore.saveStore();
				}
			}else{
				var selRow = masterGrid.getSelectedRecord();

				if(selRow) {
					masterGrid.deleteSelectedRow();
				}
			}

		},
		setDefault: function() {
			// panelResult.setValue('DIV_CODE','01');

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('newData','reset', true);
        	panelResult.getField('DIV_CODE').setReadOnly(false);
		}
	});

	function fnMakeLogStore() {
		var records = masterGrid.getSelectedRecords();

		buttonStore.clearData();
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
            buttonStore.insert(index, record);
		});

        buttonStore.saveStore();
	}
};
</script>
