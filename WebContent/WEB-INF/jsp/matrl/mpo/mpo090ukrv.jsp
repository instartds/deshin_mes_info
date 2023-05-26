<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo090ukrv"  >
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
<t:ExtComboStore items="${COMBO_ORDER_WEEK}" storeId="orderWeekList" /><!--발주주차관련-->

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
var referProductionPlanWindow;			//생산계획참조팝업
var excelWindow;						//엑셀업로드

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo090ukrvService.selectMasterList',
            create: 'mpo090ukrvService.insertMaster',
			update: 'mpo090ukrvService.updateMaster',
			destroy: 'mpo090ukrvService.deleteMaster',
			syncAll: 'mpo090ukrvService.saveMaster'
		}
	});	
	
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo090ukrvService.selectDetailList',
			update: 'mpo090ukrvService.updateDetail',
			syncAll: 'mpo090ukrvService.saveDetail'
		}
	});	
	
	
	var directProxy2_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo090ukrvService.selectDetailList2'
//            create: 'mpo090ukrvService.insertMaster',
//			update: 'mpo090ukrvService.updateMaster',
//			destroy: 'mpo090ukrvService.deleteMaster',
//			syncAll: 'mpo090ukrvService.saveMaster'
		}
	});	
	var directProxy2_3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo090ukrvService.selectDetailList3'
		}
	});	
	
	/* 수주 참조 */
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo090ukrvService.selectOrderList'
		}
	});
	
	/* 생산계획 참조 */
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo090ukrvService.selectProdList'
		}
	});
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create: 'mpo090ukrvService.buttonInsert',
            syncAll: 'mpo090ukrvService.buttonSave'
		}
	});	
	
/*	var directButtonProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create: 'mpo090ukrvService.buttonInsert2',
            syncAll: 'mpo090ukrvService.buttonSave2'
		}
	});	*/
	

	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('mpo090ukrvModel', {
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
			
			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate',allowBlank:false},
			{name: 'WEEK_NUM'		,text: '<t:message code="system.label.purchase.deliveryweek" default="납기주차"/>'				,type: 'string',allowBlank:false},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},
			
			{name: 'MRP_CONTROL_NUM'	,text: 'MRP번호'				,type: 'string'},
			{name: 'REMARK'		 		,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'PROJECT_NAME'		,text: '프로젝트명'			,type: 'string'},
			{name: 'WK_PLAN_NUM'		,text: '생산계획번호'			,type: 'string'}
		
	    /*
	    
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string'},
			{name: 'WK_PLAN_NUM'				,text: '생산계획번호'				,type: 'string'},
			{name: 'PROD_ITEM_CODE'	 	,text: '<t:message code="system.label.purchase.item" default="품목"/>'					,type: 'string',allowBlank:false},
			{name: 'ITEM_NAME'	 		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '단위'				,type: 'string'},
			{name: 'ITEM_ACCOUNT'       ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'PRODT_PLAN_DATE'				,text: '계획일자'				,type: 'uniDate'},
			{name: 'WEEK_NUM'				,text: '계획주차'				,type: 'string'},
			{name: 'WK_PLAN_Q'				,text: '계획수량'				,type: 'uniQty'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.purchase.seq" default="순번"/>'					,type: 'string'},
			{name: 'MRP_CONTROL_NUM'	,text: 'MRP번호'				,type: 'string'},
			{name: 'ORDER_YN'				,text: '발주확정'			,type: 'string'}
			
			*/
		]  
	});
	
	Unilite.defineModel('mpo090ukrvModel2', {
	    fields: [
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string'},
			{name: 'PROD_ITEM_CODE'	 	,text: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>'		,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.purchase.seq" default="순번"/>'					,type: 'string'},
			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.purchase.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'	 		,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'					,type: 'string'},
			{name: 'ITEM_ACCOUNT'       ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'				,type: 'string', comboType:'AU', comboCode:'B014'},
	
			{name: 'CHILD_PRICE'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'CHILD_AMOUNT'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'					,type: 'uniPrice'},
			
			{name: 'PL_QTY'				,text: '<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'				,type: 'uniQty'}, //소요량 최초계산량
			{name: 'CSTOCK'				,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'			,type: 'uniQty'},
			
			{name: 'RECEIPT_PLAN_Q'				,text: '<t:message code="system.label.purchase.receiptplannedqty" default="입고예정량"/>'			,type: 'uniQty'},
			{name: 'ISSUE_PLAN_Q'				,text: '<t:message code="system.label.purchase.issueresevationqty" default="출고예정량"/>'			,type: 'uniQty'},
			
			{name: 'SAFE_STOCK_Q'		,text: '<t:message code="system.label.purchase.safetystock" default="안전재고"/>'			,type: 'uniQty'},
			{name: 'CALC_NET_QTY'		,text: '<t:message code="system.label.purchase.netreq" default="순소요량"/>'				,type: 'uniQty'}, //현재고, 안전재고 반영값
			{name: 'MINI_PURCH_Q'		,text: '<t:message code="system.label.purchase.minimumlot" default="최소LOT"/>'			,type: 'uniQty'},
			{name: 'MAX_PURCH_Q'		,text: '<t:message code="system.label.purchase.maximumlot" default="최대LOT"/>'			,type: 'uniQty'},
		{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'				,type: 'string'},
			{name: 'CALC_PLAN_QTY'		,text: '<t:message code="system.label.purchase.purchaseplanq" default="구매계획량"/>'				,type: 'float', decimalPrecision: 2, format:'0,000.00'},
			{name: 'ORDER_REQ_Q'		,text: '<t:message code="system.label.purchase.purchaserequestq" default="구매요청량"/>'				,type: 'float', decimalPrecision: 2, format:'0,000.00'}, //발주요청량
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					,type: 'uniQty'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'PO_NUM'				,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				,type: 'string'},
			{name: 'PO_SEQ'				,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				,type: 'int'},
			{name: 'PO_DATE'			,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'				,type: 'uniDate'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				,type: 'uniDate'}
			
		]  
	});	
	
	
	
	
	
	Unilite.defineModel('mpo090ukrvModel2_2', {
	    fields: [
            {name: 'PROD_ITEM_CODE'	 	,text: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>'		,type: 'string'},
	    	{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.purchase.item" default="품목"/>'				,type: 'string'},
	    	{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				,type: 'string'},
	    	{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				,type: 'string'},
	    	{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'				,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			,type: 'string', comboType:'AU', comboCode:'B020'},
	    	{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'			,type: 'string', comboType:'AU', comboCode:'B014'},
	    	{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			,type: 'string'},
	    	{name: 'CHILD_PRICE'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniUnitPrice'},
	    	{name: 'CHILD_AMOUNT'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'				,type: 'uniPrice'},
	    	{name: 'PL_QTY'				,text: '<t:message code="system.label.purchase.requiredqty" default="소요량"/>'			,type: 'uniQty'},
	    	{name: 'UNIT_Q'				,text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'		, defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
	    	{name: 'LOSS_RATE'			,text: '<t:message code="system.label.purchase.lossrate" default="LOSS율"/>'		, defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'}
		
		]  
	});	
	
	Unilite.defineModel('mpo090ukrvModel2_3', {
	    fields: [
	    	{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.purchase.item" default="품목"/>'				,type: 'string'},
	    	{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				,type: 'string'},
	    	{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				,type: 'string'},
	    	{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'				,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			,type: 'string', comboType:'AU', comboCode:'B020'},
	    	{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'			,type: 'string', comboType:'AU', comboCode:'B014'},
	    	{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			,type: 'string'},
	    	{name: 'CHILD_PRICE'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniUnitPrice'},
	    	{name: 'CHILD_AMOUNT'		,text: '<t:message code="system.label.purchase.amount" default="금액"/>'				,type: 'uniPrice'},
	    	{name: 'PL_QTY'				,text: '<t:message code="system.label.purchase.requiredqty" default="소요량"/>'			,type: 'uniQty'},
	    	{name: 'UNIT_Q'				,text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'		, defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
	    	{name: 'LOSS_RATE'			,text: '<t:message code="system.label.purchase.lossrate" default="LOSS율"/>'		, defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'}
		
		]  
	});	
		
	
	
	
	var buttonStore = Unilite.createStore('mpo090ukrvButtonStore',{      
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
                        
                        //	20210803	소요량 계산 후 조회시에는 날짜조건 안타도록 조회로직에서 처리.
//						panelResult.setValue("OPTION_DATE_FR", '');
//						panelResult.setValue("OPTION_DATE_TO", '');
//						panelResult.setValue("WEEK_NUM_FR", '');
//						panelResult.setValue("WEEK_NUM_TO", '');
                        
						panelResult.setValue("MRP_CONTROL_NUM", master.RtnMrpNum);
						
                        UniAppManager.app.onQueryButtonDown(true);
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
	
	var cardNoStore = Unilite.createStore('orderWeekStore',{
        proxy: {
           type: 'direct',
            api: {          
                read: 'mpo090ukrvService.getOrderWeek'                   
            }
        },
        loadStoreRecords: function(comboStore) {
            var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });
	
	
/*    
    var buttonStore2 = Unilite.createStore('mpo090ukrvButtonStore2',{      
        uniOpt: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,        	// 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy: directButtonProxy2,
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			var paramMaster			= panelResult.getValues();
            
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
    });*/
    
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore = Unilite.createStore('mpo090ukrvMasterStore',{
		model: 'mpo090ukrvModel',
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
		loadStoreRecords: function(bIsMrpProcessed) {
			var param= panelResult.getValues();
			
			if(!Ext.isEmpty(bIsMrpProcessed) && bIsMrpProcessed) {
				param.OPTION_DATE_FR	= '';
				param.OPTION_DATE_TO	= '';
				param.WEEK_NUM_FR		= '';
				param.WEEK_NUM_TO		= '';
			}
			
			if(!Ext.isEmpty(panelResult.getValue('MRP_CONTROL_NUM'))) {
				param.OPTION_DATE_FR	= '';
				param.OPTION_DATE_TO	= '';
				param.WEEK_NUM_FR		= '';
				param.WEEK_NUM_TO		= '';
			}
			
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
	var directDetailStore = Unilite.createStore('mpo090ukrvDetailStore',{
		model: 'mpo090ukrvModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,		// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy2,
		loadStoreRecords: function(record) {
			var param= panelResult2.getValues();
			param.DIV_CODE = record.data.DIV_CODE;
			param.MRP_CONTROL_NUM = record.data.MRP_CONTROL_NUM;

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
			
			var paramMaster= panelResult2.getValues();	//syncAll 수정 yoon
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
				var grid = Ext.getCmp('mpo090ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners: {
            load: function(store, records, successful, eOpts) {
            	if(store.sum('CALC_PLAN_QTY').toFixed(3) != 0 && store.sum('ORDER_REQ_Q').toFixed(3) == 0){
	            	Ext.each(records, function(record, index){
	            		record.set('ORDER_REQ_Q',record.get('CALC_PLAN_QTY'));
	            	
	            	})
	            	setTimeout( function() {
						UniAppManager.setToolbarButtons('save', true);
					}, 50 );
            	}
            }
        }
	});	
	
	
	var detailStore2 = Unilite.createStore('detailStore2',{
		model: 'mpo090ukrvModel2_2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy2_2,
		loadStoreRecords: function(record) {
			var param= record.data;
			this.load({
				params: param
			});
		}
//		saveStore: function() {
//			var inValidRecs = this.getInvalidRecords();
//			
//			var paramMaster= panelResult.getValues();	
//			
//			if(inValidRecs.length == 0) {
//				config = {
//					params: [paramMaster],
//					success: function(batch, option) {
//						var master = batch.operations[0].getResultSet();
//						UniAppManager.setToolbarButtons('save', false);		
//					 } 
//				};
//				this.syncAllDirect(config);
//			} else {
//                detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
//			}
//		}
	});
	
	
	var detailStore3 = Unilite.createStore('detailStore3',{
		model: 'mpo090ukrvModel2_3',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
           	editable: false,			// 수정 모드 사용 
           	deletable: false,			// 삭제 가능 여부 
	        useNavi: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy2_3,
		loadStoreRecords: function(param) {
			this.load({
				params: param
			});
		}
	});	
	
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 5},
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
		},

		{
			xtype:'container',
			layout:{type:'hbox', align:'stretch'},
			width:530,
			 items: [{
			 fieldLabel: '<t:message code="system.label.purchase.deliveryweek" default="납기주차"/>',
	            name: 'OPTION_DATE_FR',
	            xtype: 'uniDatefield',
//				allowBlank: false,
	            listeners: {
	                change: function(field, newValue, oldValue, eOpts) {
	                	
	                },
	                blur : function (field, event, eOpts) {
	                	if(Ext.isEmpty(field.value)){
	                    	panelResult.setValue('WEEK_NUM_FR','');
	                	}else{
		                	var param = {
		                		'OPTION_DATE' : UniDate.getDbDateStr(field.value),
                				'CAL_TYPE' : '3' //주단위
		                	}
		                	prodtCommonService.getCalNo(param, function(provider, response) {
		                        if(!Ext.isEmpty(provider.CAL_NO)){
		                        	panelResult.setValue('WEEK_NUM_FR',provider.CAL_NO);
		                        }else{
		                        	panelResult.setValue('WEEK_NUM_FR','');
		                        }
		                	})
	                	}
	                }
	            }
	        },{
				fieldLabel: '계획주차FR',
				xtype:'uniTextfield',
				name:'WEEK_NUM_FR',
				width: 60,
				hideLabel: true
//				allowBlank: false
			},{
				xtype:'component', 
			    html:'~',
			    style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
		       }
			},{
			 	fieldLabel: '계획주차',
				hideLabel: true,
	            name: 'OPTION_DATE_TO',
	            xtype: 'uniDatefield',
//				allowBlank: false,
	            listeners: {
	                change: function(field, newValue, oldValue, eOpts) {
	                	
	                },
	                blur : function (field, event, eOpts) {
	                	if(Ext.isEmpty(field.value)){
	                    	panelResult.setValue('WEEK_NUM_TO','');
	                	}else{
		                	var param = {
		                		'OPTION_DATE' : UniDate.getDbDateStr(field.value),
                				'CAL_TYPE' : '3' //주단위
		                	}
		                	prodtCommonService.getCalNo(param, function(provider, response) {
		                        if(!Ext.isEmpty(provider.CAL_NO)){
		                        	panelResult.setValue('WEEK_NUM_TO',provider.CAL_NO);
		                        }else{
		                        	panelResult.setValue('WEEK_NUM_TO','');
		                        }
		                	})
	                	}
	                }
	            }
	        },{
				fieldLabel: '계획주차TO',
				xtype:'uniTextfield',
				name:'WEEK_NUM_TO',
				width: 60,
				hideLabel: true
//				allowBlank: false
			}]
		},{ 
			name: 'ITEM_ACCOUNT',  				
			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>', 		 
			xtype:'uniCombobox', 
			comboType:'AU', 
			comboCode:'B020'
		},{
			fieldLabel:'MRP번호',
			xtype:'uniTextfield',
			name:'MRP_CONTROL_NUM'
		},{
			xtype: 'container',
			layout: {type : 'table', columns : 2},
			tdAttrs: {align: 'right'},
			width:150,
	    	items:[{
	        	xtype:'button',
	        	text:'<div style="color: red">소요량계산</div>',
	    		width: 100,
	        	handler:function(){
					if(!panelResult.getInvalidMessage()) return;   //필수체크
					
					var records = masterGrid.getSelectedRecords();
					if(Ext.isEmpty(records)){
						alert("소요량계산할 데이터를 선택해주십시오.");	
						return;
					}
		            fnMakeLogStore();
	        	}
	        }/*,{
	    		xtype: 'button',
	    		text: '발주확정',
	    		width: 100,
	    		id:'btn2',
				handler : function() {
					if(!panelResult.getInvalidMessage()) return;   //필수체크
					
					var records = directDetailStore.data.items;
					if(Ext.isEmpty(records)){
						alert("발주확정 할 데이터가 없습니다.");	
						return;
					}
					
					Ext.each(records, function(record, idx){
						if(Ext.isEmpty(record.get('CUSTOM_CODE')) || Ext.isEmpty(record.get('CUSTOM_NAME'))){
							alert('거래처를 확인하십시오.');
							return false;
						}
					})
					
		            fnMakeLogStore2();
					
				}
    		}*/]
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
        	colspan:3,
        	allowBlank:true
        }]
    });	
  
    var panelResult2 = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			name: 'ITEM_ACCOUNT',  				
			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>', 		 
			xtype:'uniCombobox', 
			comboType:'AU', 
			comboCode:'B020'
		},{
			fieldLabel	: '옵션',
			xtype		: 'uniCheckboxgroup',
			items		: [{
				boxLabel: '현재고',
				width	: 90,
				name	: 'TYPE1',
				checked	: true
			},{
				boxLabel: '입고예정량',
				width	: 90,
				name	: 'TYPE4'
			},{
				boxLabel: '출고예정량',
				width	: 90,
				name	: 'TYPE5'
			},{
				boxLabel: '안전재고',
				width	: 90,
				name	: 'TYPE2'
			},{
				boxLabel: 'MOQ',
				width	: 90,
				name	: 'TYPE3',
				checked	: true
			}]
		},{
			xtype: 'container',
			layout: {type : 'table', columns : 2},
			tdAttrs: {align: 'right'},
			width:150,
	    	items:[{
	        	xtype:'button',
	        	text:'<div style="color: red">발주확정(SUM)조회</div>',
	    		width: 150,
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
    var masterGrid = Unilite.createGrid('mpo090ukrvGrid', {
    	region: 'north' ,
        layout: 'fit',
	    split: true,
        uniOpt: {
        	onLoadSelectFirst:false,
			expandLastColumn: false,
			useRowNumberer: false
        },
        tbar: [{	//
			itemId: 'requestBtnExcel',
			text: '<div style="color: blue">엑셀업로드</div>',
			handler: function() {
				openExcelWindow();
			}
		},{
			itemId: 'requestBtnPlan',
			text: '<div style="color: blue">생산계획참조</div>',
			handler: function() {
				openProductionPlanWindow();
			}
		},{
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
    		showSummaryRow: false
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
        	{dataIndex:'MRP_CONTROL_NUM'	 		, width: 120 },
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
            grdRecord.set('DVRY_DATE'        , record['DVRY_DATE']);
            grdRecord.set('WEEK_NUM'        , record['WEEK_NUM']);
        },
        setPlanData: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'				, record['COMP_CODE']);
			grdRecord.set('DIV_CODE'				, record['DIV_CODE']);
			grdRecord.set('PROD_ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'				, record['ITEM_NAME']);
			grdRecord.set('SPEC'					, record['SPEC']);
			grdRecord.set('PL_QTY'					, record['WK_PLAN_Q']);
			grdRecord.set('WEEK_NUM'				, record['WEEK_NUM']);
			grdRecord.set('MRP_CONTROL_NUM'			, record['MRP_CONTROL_NUM']);
			grdRecord.set('ORDER_NUM'				, record['ORDER_NUM']);
			grdRecord.set('CSTOCK	'				, record['CSTOCK']);
			grdRecord.set('SER_NO'					, record['SEQ']);
			grdRecord.set('ITEM_ACCOUNT'			, record['ITEM_ACCOUNT']);
			grdRecord.set('SUPPLY_TYPE'				, record['SUPPLY_TYPE']);
			grdRecord.set('DVRY_DATE'				, record['DVRY_DATE']);
			grdRecord.set('WK_PLAN_NUM'				, record['WK_PLAN_NUM']);
			//panelResult.setValue('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			
			//grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);
			//grdRecord.set('PRODT_PLAN_DATE'			, record['PRODT_PLAN_DATE']);
			//grdRecord.set('ORDER_YN'				, record['ORDER_YN']);
			
        },
		setExcelData: function(records) {
			var nRecords = new Array();
			
			Ext.each(records, function(record, i){
				var r = {
					COMP_CODE		: UserInfo.compCode,
					DIV_CODE		: panelResult.getValue('DIV_CODE'),
					PROD_ITEM_CODE	: record.get('PROD_ITEM_CODE'),
					ITEM_NAME		: record.get('PROD_ITEM_NAME'),
					SPEC			: record.get('SPEC'),
					ITEM_ACCOUNT	: record.get('ITEM_ACCOUNT'),
					SUPPLY_TYPE		: record.get('SUPPLY_TYPE'),
					PL_QTY			: record.get('PL_QTY'),
					PL_COST			: 0,
					PL_AMOUNT		: 0,
					CSTOCK			: 0,
					ORDER_NUM		: record.get('ORDER_NUM'),
					SER_NO			: record.get('SER_NO'),
					DVRY_DATE		: record.get('DVRY_DATE'),
					WEEK_NUM		: record.get('WEEK_NUM'),
					CUSTOM_NAME		: '',
					MRP_CONTROL_NUM	: '',
					REMARK			: '',
					PROJECT_NO		: '',
					PROJECT_NAME	: '',
					WK_PLAN_NUM		: ''
				};
				nRecords[i] = directMasterStore.model.create( r );
			});
			
			directMasterStore.loadData(nRecords, true);
		},
        listeners:{
        	selectionchange:function(grid, selected, eOpts){
        		if(selected.length > 0)	{
	        		var record = selected[0];
	        		directDetailStore.loadData({});
	        		if(!record.phantom){
	        			
	        			directDetailStore.loadStoreRecords(record);
	        			detailStore2.loadStoreRecords(record);
	        			
	        		}
	        		
					var prodItemCodeRecords = new Array();
					var mrpControlNumRecords = new Array();
					var orderNumRecords = new Array();
					var serNoRecords = new Array();
					Ext.each(selected, function(record, idx) {
				   		prodItemCodeRecords.push(record.get('PROD_ITEM_CODE'));
				   		mrpControlNumRecords.push(record.get('MRP_CONTROL_NUM'));
				   		orderNumRecords.push(record.get('ORDER_NUM'));
				   		serNoRecords.push(record.get('SER_NO'));
					});

					var param = panelResult.getValues();

					param.dataCount = selected.length;
					param.prodItemCodeList = prodItemCodeRecords;
					param.mrpControlNumList = mrpControlNumRecords;
					param.orderNumList = orderNumRecords;
					param.serNoList = serNoRecords;

        			detailStore3.loadStoreRecords(param);

            		UniAppManager.setToolbarButtons('delete', true);
       			}else{
					detailGrid.reset();
					directDetailStore.clearData();
					
					detailGrid2.reset();
					detailStore2.clearData();

					detailGrid3.reset();
					detailStore3.clearData();
					
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
    var detailGrid= Unilite.createGrid('mpo090ukrvGrid2', {
    	region:'center',
        layout: 'fit',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
    	store: directDetailStore,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
    	tbar:[{
        	xtype:'button',
        	text:'<div style="color: blue">발주확정(SUM) 출력</div>',
    		width: 150,
        	handler:function(){
				var param = Ext.merge(panelResult.getValues(), panelResult2.getValues());     
				
				var selectedDetails = detailGrid.getSelectedRecords();
				if(Ext.isEmpty(selectedDetails)){
					alert('출력할 데이터를 선택하여 주십시오.');
					return;
				}
				param.PGM_ID= 'mpo090ukrv_1';
				param.MAIN_CODE= 'M030';
				
				param["MRP_CONTROL_NUM"] = selectedDetails[0].get('MRP_CONTROL_NUM');
				param["sTxtValue2_fileTitle"]='발주확정(SUM)';
	
				var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/matrl/mpo090_1clukrv.do',
				prgID: 'mpo090ukrv',
				extParam: param
				});
				win.center();
				win.show();
		
        	}
        }],
        columns: [
        	{dataIndex: 'COMP_CODE'			, width: 100 , 		hidden:true},
        	{dataIndex: 'DIV_CODE'			, width: 100 , 		hidden:true},
        	{dataIndex: 'PROD_ITEM_CODE'	, width: 100 , 		hidden:true},
        	{dataIndex: 'ORDER_NUM'	 		, width: 120, 		hidden:true },
        	{dataIndex: 'SER_NO'	 		, width: 80, 		hidden:true },
        	{dataIndex: 'CHILD_ITEM_CODE'	, width: 100 , locked:true},
			{dataIndex: 'ITEM_NAME'	 		, width: 200 , locked:true,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
          			return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.totalamount" default="합계"/>');
            	}
            },
			{dataIndex: 'SPEC'				, width: 120},
			{dataIndex: 'STOCK_UNIT'		, width: 66		,align:'center'  },
			{dataIndex: 'ITEM_ACCOUNT'      , width: 80 	,align:'center' },
			{dataIndex: 'SUPPLY_TYPE'		, width: 80		,align:'center'  },
			
			{dataIndex: 'CHILD_PRICE'		, width: 100 ,summaryType:'sum'},
			{dataIndex: 'CHILD_AMOUNT'		, width: 120 ,summaryType:'sum'},
			{dataIndex: 'PL_QTY'			, width: 100 ,summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'CSTOCK'			, width: 100 ,summaryType:'sum'},
			
			{dataIndex: 'RECEIPT_PLAN_Q'	, width: 100 ,summaryType:'sum'},
			{dataIndex: 'ISSUE_PLAN_Q'		, width: 100 ,summaryType:'sum'},
			
			{dataIndex: 'SAFE_STOCK_Q'		, width: 100 ,summaryType:'sum'},
			{dataIndex: 'CALC_NET_QTY'		, width: 100 ,summaryType:'sum',tdCls:'x-change-cell2'},
			{dataIndex: 'MINI_PURCH_Q'		, width: 80 ,summaryType:'sum'},
			{dataIndex: 'MAX_PURCH_Q'		, width: 80 ,summaryType:'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 70		,align:'center'  },
			{dataIndex: 'CALC_PLAN_QTY'		, width: 100 ,summaryType:'sum',tdCls:'x-change-cell2',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Ext.util.Format.number(value, '0,000.00');
				}
			},
			{dataIndex: 'ORDER_REQ_Q'		, width: 100,summaryType:'sum',tdCls:'x-change-cell',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Ext.util.Format.number(value, '0,000.00');
				}
			},
			{dataIndex: 'ORDER_Q'			, width: 100 ,summaryType:'sum'},
    		{dataIndex: 'CUSTOM_CODE'		, width: 80,
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
			{dataIndex: 'PO_NUM'	, width: 100 }, 
			{dataIndex: 'PO_SEQ'		, width: 100 }, 
			{dataIndex: 'PO_DATE'	, width: 100 },
			{dataIndex: 'DVRY_DATE'		, width: 100 } 
        ],
//        selModel:'spreadsheet',
        listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        		if(UniUtils.indexOf(e.field, ['ORDER_REQ_Q', 'CUSTOM_CODE', 'CUSTOM_NAME'])){
					return true;
				}
                return false;
        	}
        }
    });
    
    
    
    var detailGrid2= Unilite.createGrid('detailGrid2', {
    	region:'center',
        layout: 'fit',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
    	store: detailStore2,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
    	selModel : 'rowmodel',
        columns: [
			{dataIndex: 'PROD_ITEM_CODE'	, width: 100 , 		hidden:true},
			{dataIndex: 'CHILD_ITEM_CODE'		, width: 100 },
			{dataIndex: 'ITEM_NAME'				, width: 200 ,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
          			return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.totalamount" default="합계"/>');
            	}
            },
			{dataIndex: 'SPEC'					, width: 100 },
			{dataIndex: 'STOCK_UNIT'			, width: 80,align:'center' },
			{dataIndex: 'ITEM_ACCOUNT'			, width: 80,align:'center' },
			{dataIndex: 'SUPPLY_TYPE'			, width: 80,align:'center' },
			{dataIndex: 'ORDER_UNIT'			, width: 80,align:'center' },
			{dataIndex: 'CHILD_PRICE'			, width: 120 ,summaryType:'sum'},
			{dataIndex: 'CHILD_AMOUNT'			, width: 120 ,summaryType:'sum'},
			{dataIndex: 'PL_QTY'				, width: 120 ,summaryType:'sum'},
			{dataIndex: 'UNIT_Q'				, width: 120 },
			{dataIndex: 'LOSS_RATE'				, width: 120 }
        
        ],
        listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        	}
        }
    });
    
    var detailGrid3= Unilite.createGrid('detailGrid3', {
    	region:'center',
        layout: 'fit',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
    	store: detailStore3,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
    	tbar:[{
        	xtype:'button',
        	text:'<div style="color: blue">소요량내역(선택) 출력</div>',
    		width: 150,
        	handler:function(){
				var param = panelResult.getValues();
				var selectedMasters = masterGrid.getSelectedRecords();
				if(Ext.isEmpty(selectedMasters)){
					alert('출력할 데이터를 선택하여 주십시오.');
					return;
				}
				param.PGM_ID= 'mpo090ukrv_2';
				param.MAIN_CODE= 'M030';
				
				
				var prodItemCodeList;
				var wkPlanNumList;
				var mrpControlNumList;
				Ext.each(selectedMasters, function(record, idx) {
					if(idx ==0) {
						prodItemCodeList= record.get("PROD_ITEM_CODE");
						
						mrpControlNumList= record.get("MRP_CONTROL_NUM");
					} else {
						prodItemCodeList= prodItemCodeList	+ ',' + record.get("PROD_ITEM_CODE");
						
						mrpControlNumList= mrpControlNumList	+ ',' + record.get("MRP_CONTROL_NUM");
					}
	
				});
	
				param["dataCount"] = selectedMasters.length;
				param["PROD_ITEM_CODE"] = prodItemCodeList;
				param["MRP_CONTROL_NUM"] = mrpControlNumList;
				param["sTxtValue2_fileTitle"]='소요량내역(선택)';
	
				var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/matrl/mpo090_2clukrv.do',
				prgID: 'mpo090ukrv',
				extParam: param
				});
				win.center();
				win.show();
		
        	}
        }
    	
    	],
    	selModel : 'rowmodel',
        columns: [
			{dataIndex: 'CHILD_ITEM_CODE'		, width: 100 },
			{dataIndex: 'ITEM_NAME'				, width: 200 ,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
          			return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.totalamount" default="합계"/>');
            	}
            },
			{dataIndex: 'SPEC'					, width: 100 },
			{dataIndex: 'STOCK_UNIT'			, width: 80,align:'center' },
			{dataIndex: 'ITEM_ACCOUNT'			, width: 80,align:'center' },
			{dataIndex: 'SUPPLY_TYPE'			, width: 80,align:'center' },
			{dataIndex: 'ORDER_UNIT'			, width: 80,align:'center' },
			{dataIndex: 'CHILD_PRICE'			, width: 120 ,summaryType:'sum'},
			{dataIndex: 'CHILD_AMOUNT'			, width: 120 ,summaryType:'sum'},
			{dataIndex: 'PL_QTY'				, width: 120 ,summaryType:'sum'},
			{dataIndex: 'UNIT_Q'				, width: 120 },
			{dataIndex: 'LOSS_RATE'				, width: 120 }
        
        ],
        listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        	}
        }
    });
    
	Unilite.defineModel('mpo090ukrvRefModel', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
			{name: 'WK_PLAN_Q'			, text: '계획량'				, type: 'uniQty'},
			{name: 'WK_PLAN_NUM'		, text: '생산계획번호'			, type: 'string'},
			{name: 'PRODT_PLAN_DATE'	, text: '계획일자'				, type: 'uniDate'},
			{name: 'WEEK_NUM'			, text: '계획주차'				, type: 'string'},
			{name: 'MRP_CONTROL_NUM'	, text: 'MRP번호'				, type: 'string'},
			{name: 'ORDER_YN'			, text: '발주확정'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처'				, type: 'string'},
			{name: 'ORDER_NUM'			, text: '수주번호'				, type: 'string'},
			{name: 'SEQ'				, text: '수주순번'				, type: 'int'},
			{name: 'ITEM_ACCOUNT'		, text: '품목계정'				, type: 'string'},
			{name: 'SUPPLY_TYPE'		, text: '조달구분'				, type: 'string'},
			{name: 'DVRY_DATE'			, text: '납기일자'				, type: 'string'},
			{name: 'CSTOCK	'			, text: '현재고'				, type: 'string'}
		]
	});
	
	var prodStore = Unilite.createStore('mpo090ukrvProdStore', {
		model: 'mpo090ukrvRefModel',
        autoLoad: false,
        uniOpt : {
           	isMaster: false,			// 상위 버튼 연결
           	editable: false,			// 수정 모드 사용
           	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: directProxy4,
        loadStoreRecords : function()	{
			var param= prodSearch.getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
	    	load:function(store, records, successful, eOpts)	{
				if(successful)	{
//					var masterRecords = directMasterStore.data.filterBy(directMasterStore.filterNewOnly);
					var masterRecords = directMasterStore.data;  
				    var prodRecords = new Array();
				    if(masterRecords.items.length > 0)	{
	    				Ext.each(records, 
	    			   		function(item, i)	{
	   							Ext.each(masterRecords.items, function(record, i)	{
   									if( (record.data['DIV_CODE'] == item.data['DIV_CODE']) 
   											&& (record.data['WK_PLAN_NUM'] == item.data['WK_PLAN_NUM'] )
									){
   										prodRecords.push(item);
   									}
	   							});		
	    			   	});
	    			   store.remove(prodRecords);
				   }
				}
	    	}
	    }
	});
	
	
	 var prodSearch = Unilite.createSearchForm('prodForm', {
        layout :  {type : 'uniTable', columns : 3},
        items :[{
        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
        	name:'DIV_CODE',
        	xtype: 'uniCombobox', 
        	comboType:'BOR120',
			allowBlank: false,
        	readOnly: true
        },
        {
			xtype:'container',
			layout:{type:'hbox', align:'stretch'},
			width:530,
			colspan:2,
			items: [{
			fieldLabel: '계획주차',
	        	name: 'OPTION_DATE_FR',
	            xtype: 'uniDatefield',
				allowBlank: false,
	            listeners: {
	                change: function(field, newValue, oldValue, eOpts) {
	                	
	                },
	                blur : function (field, event, eOpts) {
	                	if(Ext.isEmpty(field.value)){
	                    	prodSearch.setValue('WEEK_NUM_FR','');
	                	}else{
		                	var param = {
		                		'OPTION_DATE' : UniDate.getDbDateStr(field.value),
                				'CAL_TYPE' : '3' //주단위
		                	}
		                	prodtCommonService.getCalNo(param, function(provider, response) {
		                        if(!Ext.isEmpty(provider.CAL_NO)){
		                        	prodSearch.setValue('WEEK_NUM_FR',provider.CAL_NO);
		                        }else{
		                        	prodSearch.setValue('WEEK_NUM_FR','');
		                        }
		                	})
	                	}
	                }
	            }
	        },{
				fieldLabel: '계획주차FR',
				xtype:'uniTextfield',
				name:'WEEK_NUM_FR',
				width: 60,
				hideLabel: true,
				allowBlank: false
			},{
				xtype:'component', 
			    html:'~',
			    style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
		       }
			},{
			 	fieldLabel: '계획주차',
				hideLabel: true,
	            name: 'OPTION_DATE_TO',
	            xtype: 'uniDatefield',
				allowBlank: false,
	            listeners: {
	                change: function(field, newValue, oldValue, eOpts) {
	                	
	                },
	                blur : function (field, event, eOpts) {
	                	if(Ext.isEmpty(field.value)){
	                    	prodSearch.setValue('WEEK_NUM_TO','');
	                	}else{
		                	var param = {
		                		'OPTION_DATE' : UniDate.getDbDateStr(field.value),
                				'CAL_TYPE' : '3' //주단위
		                	}
		                	prodtCommonService.getCalNo(param, function(provider, response) {
		                        if(!Ext.isEmpty(provider.CAL_NO)){
		                        	prodSearch.setValue('WEEK_NUM_TO',provider.CAL_NO);
		                        }else{
		                        	prodSearch.setValue('WEEK_NUM_TO','');
		                        }
		                	})
	                	}
	                }
	            }
	        },{
				fieldLabel: '계획주차TO',
				xtype:'uniTextfield',
				name:'WEEK_NUM_TO',
				width: 60,
				hideLabel: true,
				allowBlank: false
			}]
		
        },
        { 
   			name: 'ITEM_ACCOUNT',  				
			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype:'uniCombobox', 
			comboType:'AU', 
			comboCode:'B020',
			allowBlank: true
		},
		Unilite.popup('DIV_PUMOK',{ 
        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
        	valueFieldName: 'ITEM_CODE', 
			textFieldName: 'ITEM_NAME', 
        	listeners: {
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': prodSearch.getValue('DIV_CODE')});
				}
			}
   		}),
   		
   		{
			xtype: 'radiogroup',		            		
			fieldLabel: '발주확정',
			id: 'rdoSelect',
			items: [{
				boxLabel: '전체', 
				width: 80, 
				name: 'ORDER_YN',
	    		inputValue: 'A'
			},{
				boxLabel : '미확정', 
				width: 80,
				name: 'ORDER_YN',
	    		inputValue: 'N',
				checked: true  
			},{
				boxLabel : '확정', 
				width: 80,
				name: 'ORDER_YN',
	    		inputValue: 'Y'
			}]
   		}
   		]
    });
    
	 var prodGrid = Unilite.createGrid('mpo090ukrvProdGrid', {
    	layout : 'fit',
    	store: prodStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
        columns: [
        	{ dataIndex: 'DIV_CODE'      		, width: 120,hidden:true},
        	{ dataIndex: 'ITEM_CODE'     		, width: 100},
        	{ dataIndex: 'ITEM_NAME'     		, width: 200},
        	{ dataIndex: 'SPEC'          		, width: 100},
        	{ dataIndex: 'STOCK_UNIT'    		, width: 80,align:'center'},
        	{ dataIndex: 'WK_PLAN_Q'    		, width: 100},
        	{ dataIndex: 'WK_PLAN_NUM'    		, width: 120},
        	{ dataIndex: 'PRODT_PLAN_DATE'    	, width: 80},
        	{ dataIndex: 'WEEK_NUM'    		   	, width: 80},
        	{ dataIndex: 'MRP_CONTROL_NUM'    	, width: 120},
        	{ dataIndex: 'ORDER_YN'    		   	, width: 80,align:'center'},
        	{ dataIndex: 'CUSTOM_NAME'    		, width: 200}
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
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setPlanData(record.data);
			});
			this.getStore().remove(records);
			
        	panelResult.getField('DIV_CODE').setReadOnly(true);
       	}
    });
    
    
    
    function openProductionPlanWindow() {    		
		if(!panelResult.getInvalidMessage()) return;   //필수체크
  		
		if(!referProductionPlanWindow) {
			referProductionPlanWindow = Ext.create('widget.uniDetailWindow', {
                title: '생산계획참조',
                width: 1200,
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [prodSearch, prodGrid],
                tbar:  ['->',
			        {	itemId : 'saveBtn',
			        	id:'saveBtn2',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							
							if(!prodSearch.getInvalidMessage()) return;   //필수체크
							prodStore.loadStoreRecords();
						},
						disabled: false
					}, 
					{	itemId : 'confirmBtn',
						id:'confirmBtn2',
						text: '적용',
						handler: function() { 
							prodGrid.returnData();
							var maxIndex = 0;
							Ext.each(directMasterStore.data.items, function(record, index, records){
								if(record.phantom){
									maxIndex = index
								}
							});
							masterGrid.getSelectionModel().selectRange(0, maxIndex);
						},
						disabled: false
					},
					{	itemId : 'confirmCloseBtn',
						id:'confirmCloseBtn2',
						text: '적용 후 닫기',
						handler: function() {
							prodGrid.returnData();
							var maxIndex = 0;
							Ext.each(directMasterStore.data.items, function(record, index, records){
								if(record.phantom){
									maxIndex = index
								}
							});
							masterGrid.getSelectionModel().selectRange(0, maxIndex);
							referProductionPlanWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						id:'closeBtn2',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referProductionPlanWindow.hide();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{
						prodSearch.clearForm();
						prodGrid.reset();
						prodStore.clearData();
                	},
                	beforeclose: function( panel, eOpts )	{},
                	beforeshow: function ( me, eOpts )	{
                		prodSearch.setValue('DIV_CODE', panelResult.getValue("DIV_CODE"));
                		
                		prodSearch.setValue('OPTION_DATE_FR', panelResult.getValue("OPTION_DATE_FR"));
                		prodSearch.setValue('WEEK_NUM_FR', panelResult.getValue("WEEK_NUM_FR"));
                		prodSearch.setValue('OPTION_DATE_TO', panelResult.getValue("OPTION_DATE_TO"));
                		prodSearch.setValue('WEEK_NUM_TO', panelResult.getValue("WEEK_NUM_TO"));
                		
                		prodSearch.setValue('ITEM_ACCOUNT', panelResult.getValue("ITEM_ACCOUNT"));
//                		prodStore.loadStoreRecords();
                	}
                }
			})
		}
		referProductionPlanWindow.center();
		referProductionPlanWindow.show();
    }
    
      	//수주참조 참조 메인
    function openOrderInformationWindow() {    		
		if(!panelResult.getInvalidMessage()) return;   //필수체크
  		orderSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
  		
		if(!referOrderInformationWindow) {
			referOrderInformationWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주정보참조',
                width: 1200,				                
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [orderSearch, OrderGrid],
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
                		
						mpo090ukrvService.getThisWeek({}, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								orderSearch.setValue('ORDER_WEEK',provider.CAL_NO, false);
							}
						})
                		
                		
                		orderSearch.setValue('DIV_CODE', panelResult.getValue("DIV_CODE"));
//                		orderSearch.setValue('SUPPLY_TYPE', panelResult.getValue("SUPPLY_TYPE"));
                		orderSearch.setValue('ITEM_ACCOUNT', panelResult.getValue("ITEM_ACCOUNT"));
                		
                		
                		
                		
                	},
                	show: function ( me, eOpts )	{
//                		OrderStore.loadStoreRecords();
                		
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
	    	{name: 'DVRY_DATE'    		, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
	    	{name: 'WEEK_NUM'    		, text: '<t:message code="system.label.purchase.deliveryweek" default="납기주차"/>'				, type: 'string'},
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
           	isMaster: false,			// 상위 버튼 연결
           	editable: false,			// 수정 모드 사용
           	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: directProxy3,
        loadStoreRecords : function()	{
			var param= orderSearch.getValues();			
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

			var paramMaster= orderSearch.getValues();	//syncAll 수정
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
		},
		listeners:{
	    	load:function(store, records, successful, eOpts)	{
				if(successful)	{
					var masterRecords = directMasterStore.data;  
				    var prodRecords = new Array();
				    if(masterRecords.items.length > 0)	{
	    				Ext.each(records, 
	    			   		function(item, i)	{
	   							Ext.each(masterRecords.items, function(record, i)	{
   									if( (record.data['DIV_CODE'] == item.data['DIV_CODE']) 
   											&& (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) 
   											&& (record.data['SER_NO'] == item.data['SER_NO'])
									){
   										prodRecords.push(item);
   									}
	   							});		
	    			   	});
	    			   store.remove(prodRecords);
				   }
				}
	    	}
	    }
	});
	
    /**
	 * 수주정보참조을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주정보 참조 폼 정의
	 var orderSearch = Unilite.createSearchForm('OrderForm', {
            layout :  {type : 'uniTable', columns : 3},
            items :[{
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	readOnly: true
	        },{
				fieldLabel: '수주일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_ORDER_DATE',
				endFieldName: 'TO_ORDER_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
            },{ 
       			name: 'ITEM_ACCOUNT',  				
    			fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>', 		 
    			xtype:'uniCombobox', 
    			comboType:'AU', 
    			comboCode:'B020'
			},{
 		        xtype: 'uniCombobox',
		        fieldLabel: '납기주차',
		        name:'ORDER_WEEK',
		        store: Ext.data.StoreManager.lookup('orderWeekList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(field.valueCollection.items[0])){
							orderSearch.setValue('DVRY_DATE_FR', field.valueCollection.items[0].data.refCode1);
							orderSearch.setValue('DVRY_DATE_TO', field.valueCollection.items[0].data.refCode2);
						}
					}
				}
            },{
				fieldLabel: '주차일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
//            				startDate: UniDate.get('startOfMonth'),
//            				endDate: UniDate.get('today'),
				width: 315
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
								popup.setExtParam({'DIV_CODE': orderSearch.getValue('DIV_CODE')});
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
								popup.setExtParam({'DIV_CODE': orderSearch.getValue('DIV_CODE')});
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
									popup.setExtParam({'DIV_CODE': orderSearch.getValue('DIV_CODE')});
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
									popup.setExtParam({'DIV_CODE': orderSearch.getValue('DIV_CODE')});
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
        	{ dataIndex: 'DVRY_DATE'           		, width: 80},
        	{ dataIndex: 'WEEK_NUM'           		, width: 80},
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

	
	// 엑셀참조
	Unilite.Excel.defineModel('mpo090ukrvExcelModel', {
		fields: [
			{name: 'PROD_ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode"					default="품목코드"/>'	, type:'string'},
			{name: 'PROD_ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname"					default="품목명"/>'	, type:'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec"						default="규격"/>'		, type:'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount"				default="품목계정"/>'	, type:'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		, text: '<t:message code="system.label.purchase.procurementclassification"	default="조달구분"/>'	, type:'string', comboType:'AU', comboCode:'B014'},
			{name: 'PL_QTY'				, text: '<t:message code="system.label.purchase.productionqty"				default="생산량"/>'	, type:'uniQty'},
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliverydate"				default="납기일"/>'	, type:'uniDate'},
			{name: 'WEEK_NUM'			, text: '<t:message code="system.label.purchase.week"						default="주차"/>'		, type:'string'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.sono"						default="수주번호"/>'	, type:'string'},
			{name: 'SER_NO'				, text: '<t:message code="system.label.purchase.soseq"						default="수주순번"/>'	, type:'integer'}
		]
	});
	
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		
		if(directMasterStore.isDirty())	{
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}
		}
		
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: 'mpo090ukrv',
//				extParam: {
//					'PGM_ID': 'mpo090ukrv'
//				},
				grids: [{
					itemId		: 'grid01',
					title		: '자재소요량 엑셀 참조',
					useCheckbox	: true,
					model 		: 'mpo090ukrvExcelModel',
					readApi		: 'mpo090ukrvService.selectExcelUploadSheet',
					columns: [
						{dataIndex: 'PROD_ITEM_CODE'	, width: 120},
						{dataIndex: 'PROD_ITEM_NAME'	, width: 180},
						{dataIndex: 'SPEC'				, width: 120},
						{dataIndex: 'ITEM_ACCOUNT'		, width:  80},
						{dataIndex: 'SUPPLY_TYPE'		, width:  80},
						{dataIndex: 'PL_QTY'			, width: 100},
						{dataIndex: 'DVRY_DATE'			, width: 100},
						{dataIndex: 'WEEK_NUM'			, width: 100},
						{dataIndex: 'ORDER_NUM'			, width: 100},
						{dataIndex: 'SER_NO'			, width: 100}
					]
				}],
				listeners: {
					beforeshow: function( panel, eOpts ) {
						this.down('#grid01').getStore().sort({property : '_EXCEL_ROWNUM', direction: 'ASC'});
					},
					beforehide: function(me, eOpt) {
						var me		= this;
						var grid	= this.down('#grid01');
						excelWindow.getEl().unmask();
						grid.getStore().removeAll();
					},
					close: function() {
						var me		= this;
						var grid	= this.down('#grid01');
						excelWindow.getEl().unmask();
						grid.getStore().removeAll();
						this.hide();
					}
				},
				onApply:function() {
					var hasError	= false;
					var grid		= this.down('#grid01');
					var records		= grid.getSelectionModel().getSelection();
					
					if(records.length > 0){
						masterGrid.store.loadData({});
						masterGrid.setExcelData(records);
						
						excelWindow.close();
					}
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	}
	
	
    
    
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [{
	    	title: '발주확정(SUM)',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[panelResult2,detailGrid],
	    	id: 'tab1'
	    },{
	    	title: '소요량내역',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[detailGrid2],
	    	id: 'tab2' 
	    },{
	    	title: '소요량내역(선택)',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[detailGrid3],
	    	id: 'tab3' 
	    }],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
				if(!panelResult.getInvalidMessage()) return false;   // 필수체크
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				
//				if(newTabId == 'tab1'){
//					Ext.getCmp('btn2').setDisabled(false);	
//				}else{
//					Ext.getCmp('btn2').setDisabled(true);
//				}
				
//				UniAppManager.app.onQueryButtonDown();
			}
	    }
	});
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid, tab
			]}	
		],	
		id: 'mpo090ukrvApp',
		fnInitBinding: function() {
			this.setDefault();
		},
		onQueryButtonDown: function(bIsMrpProcessed)	{
//			if(!panelResult.getInvalidMessage()) return;   //필수체크
			directMasterStore.loadStoreRecords(bIsMrpProcessed);
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
			masterGrid.createRow(r,null,-1);
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
			
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelResult.setValue('OPTION_DATE_FR',UniDate.get('today'));
			panelResult.setValue('OPTION_DATE_TO',UniDate.get('todayOfNextMonth'));
			var param = {
        		'OPTION_DATE' : UniDate.getDbDateStr(UniDate.get('today')),
				'CAL_TYPE' : '3' //주단위
        	}
        	prodtCommonService.getCalNo(param, function(provider, response) {
                if(!Ext.isEmpty(provider.CAL_NO)){
                	panelResult.setValue('WEEK_NUM_FR',provider.CAL_NO);
                }else{
                	panelResult.setValue('WEEK_NUM_FR','');
                }
        	});
			var param = {
        		'OPTION_DATE' : UniDate.getDbDateStr(UniDate.get('todayOfNextMonth')),
				'CAL_TYPE' : '3' //주단위
        	}
        	prodtCommonService.getCalNo(param, function(provider, response) {
                if(!Ext.isEmpty(provider.CAL_NO)){
                	panelResult.setValue('WEEK_NUM_TO',provider.CAL_NO);
                }else{
                	panelResult.setValue('WEEK_NUM_TO','');
                }
        	});
        	
			UniAppManager.setToolbarButtons('save', false);							
			UniAppManager.setToolbarButtons(['newData','reset'], true);	
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
	Unilite.createValidator('validator02', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

				case "DVRY_DATE" :
					var param = {
		        		'OPTION_DATE' : UniDate.getDbDateStr(newValue),
						'CAL_TYPE' : '3' //주단위
		        	}
		        	prodtCommonService.getCalNo(param, function(provider, response) {
		                if(!Ext.isEmpty(provider.CAL_NO)){
							record.set('WEEK_NUM',provider.CAL_NO);
		                }else{
							record.set('WEEK_NUM','');
		                }
		        	});
		        	
		        	record.set('CONFIRM_YN',true);
		        	
				break;
			}
			return rv;
		}
	});
/*	function fnMakeLogStore2() {
		var records = directDetailStore.data.items;

		buttonStore2.clearData();
		Ext.each(records, function(record, index) {
			if(record.get('ORDER_Q') > 0){
	            record.phantom 			= true;
	            buttonStore2.insert(index, record);
			}
		});

        buttonStore2.saveStore();
	}*/
};
</script>
