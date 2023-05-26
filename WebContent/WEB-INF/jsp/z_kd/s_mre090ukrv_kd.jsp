<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mre090ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mre090ukrv_kd"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제조건 -->
    <t:ExtComboStore comboType="AU" comboCode="WM01" /> <!-- 소요량구분 -->

	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" /> <!-- 품질대상여부 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="B014" opts= '1;3' /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위 -->
    <t:ExtComboStore comboType="AU" comboCode="T109" /> <!-- 국내외구분 -->
    <t:ExtComboStore comboType="AU" comboCode="M517" /> <!-- 차수-->
    <t:ExtComboStore items="${COMBO_GW_STATUS}" storeId="gwStatus" />  <!-- 그룹웨어결재상태 -->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;	    //조회버튼 누르면 나오는 조회창
var referOtherMrpWindow;   //자재소요량참조
var outsidePlWindow;       //외주P/L참조
var itemRequestWindow;     //물품의뢰참조

var BsaCodeInfo = {
	gsAutoType:     '${gsAutoType}',
	gsDefaultMoney: '${gsDefaultMoney}'
};

var outDivCode = UserInfo.divCode;
var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
var selRecord = '';
function appMain() {


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mre090ukrv_kdService.selectList',
			update: 's_mre090ukrv_kdService.updateDetail',
			create: 's_mre090ukrv_kdService.insertDetail',
			destroy: 's_mre090ukrv_kdService.deleteDetail',
			syncAll: 's_mre090ukrv_kdService.saveAll'
		}
	});
	/**
	 * Model 정의
	 * @type
	 */
	Unilite.defineModel('s_mre090ukrv_kdModel', {
	    fields: [
			{name: 'COMP_CODE'			    ,text: '법인'				    ,type: 'string'},
            {name: 'DIV_CODE'               ,text: '사업장'                 ,type: 'string'},
            {name: 'PRDT_REQ_NUM'           ,text: '계획번호'               ,type: 'string'},
            {name: 'PRDT_REQ_SEQ'           ,text: '순번'                   ,type: 'int'},
            {name: 'ITEM_CODE'              ,text: '품목코드'               ,type: 'string', allowBlank: false},
            {name: 'ITEM_NAME'              ,text: '품목명'                 ,type: 'string'},
            {name: 'SPEC'                   ,text: '규격'                   ,type: 'string'},
            {name: 'STOCK_UNIT'             ,text: '재고단위'               ,type: 'string'},
            {name: 'PURCH_LD_TIME'          ,text: 'LEAD TIME'              ,type: 'int'},
            {name: 'TERMPLAN_Q'             ,text: '기간소요량'             ,type: 'uniQty'},
            {name: 'SAFE_STOCK_Q'           ,text: '안전재고량'             ,type: 'uniQty'},
            {name: 'STOCK_Q'                ,text: '현재고량'               ,type: 'uniQty'},
            {name: 'NOIN_Q'                 ,text: '미입고량'               ,type: 'uniQty'},
            {name: 'ORDER_PLAN_Q'           ,text: '구매계획량'             ,type: 'float', decimalPrecision: 4, format:'0,000', allowBlank: false},
            {name: 'NOT_PO_QTY'             ,text: '미발주량'               ,type: 'uniQty'},
            {name: 'DELIVERY_REQ_DATE'      ,text: '희망납기일'             ,type: 'uniDate', allowBlank: false},
            {name: 'DELIVERY_REQ_ORI_DATE'  ,text: '기존희망납기일'         ,type: 'uniDate'},
            {name: 'PLAN_Q_M0'              ,text: 'PLAN_Q_M0'              ,type: 'uniQty'},
            {name: 'PLAN_Q_M1'              ,text: 'PLAN_Q_M1'              ,type: 'uniQty'},
            {name: 'PLAN_Q_M2'              ,text: 'PLAN_Q_M2'              ,type: 'uniQty'},
            {name: 'PLAN_Q_M3'              ,text: 'PLAN_Q_M3'              ,type: 'uniQty'},
            {name: 'PLAN_Q_M4'              ,text: 'PLAN_Q_M4'              ,type: 'uniQty'},
            {name: 'PLAN_Q_M5'              ,text: 'PLAN_Q_M5'              ,type: 'uniQty'},
            {name: 'PLAN_Q_M6'              ,text: 'PLAN_Q_M6'              ,type: 'uniQty'},
            {name: 'ORDER_Q_M0'             ,text: 'ORDER_Q_M0'             ,type: 'uniQty'},
            {name: 'ORDER_Q_M1'             ,text: 'ORDER_Q_M1'             ,type: 'uniQty'},
            {name: 'ORDER_Q_M2'             ,text: 'ORDER_Q_M2'             ,type: 'uniQty'},
            {name: 'ORDER_Q_M3'             ,text: 'ORDER_Q_M3'             ,type: 'uniQty'},
            {name: 'ORDER_Q_M4'             ,text: 'ORDER_Q_M4'             ,type: 'uniQty'},
            {name: 'ORDER_Q_M5'             ,text: 'ORDER_Q_M5'             ,type: 'uniQty'},
            {name: 'ORDER_Q_M6'             ,text: 'ORDER_Q_M6'             ,type: 'uniQty'},
            {name: 'STOCK_Q_M0'             ,text: 'STOCK_Q_M0'             ,type: 'uniQty'},
            {name: 'STOCK_Q_M1'             ,text: 'STOCK_Q_M1'             ,type: 'uniQty'},
            {name: 'STOCK_Q_M2'             ,text: 'STOCK_Q_M2'             ,type: 'uniQty'},
            {name: 'STOCK_Q_M3'             ,text: 'STOCK_Q_M3'             ,type: 'uniQty'},
            {name: 'STOCK_Q_M4'             ,text: 'STOCK_Q_M4'             ,type: 'uniQty'},
            {name: 'STOCK_Q_M5'             ,text: 'STOCK_Q_M5'             ,type: 'uniQty'},
            {name: 'STOCK_Q_M6'             ,text: 'STOCK_Q_M6'             ,type: 'uniQty'},
            {name: 'ORDER_PLAN_MM1'         ,text: '최소계획년월'           ,type: 'string'},
            {name: 'ORDER_PLAN_MM2'         ,text: '최대계획년월'           ,type: 'string'},
            {name: 'DOM_FORIGN'             ,text: '국내외'                 ,type: 'string', comboType: 'AU', comboCode: 'T109'},
            {name: 'TRNS_RATE'              ,text: '입수'                   ,type: 'uniQty'},
            {name: 'SUPPLY_TYPE'            ,text: '조달구분'               ,type: 'string', comboType: 'AU', comboCode: 'B014'},
            {name: 'ITEM_ACCOUNT'           ,text: '품목계정'               ,type: 'string', comboType: 'AU', comboCode: 'B020'},
            {name: 'ORDER_PLAN_YYMM'        ,text: '계획년월'               ,type: 'string'},
            {name: 'REMARK'                 ,text: '비고'                   ,type: 'string'},
            {name: 'REQ_DATE'               ,text: '계획일'                 ,type: 'uniDate'},
            {name: 'DEPT_CODE'              ,text: '부서'                   ,type: 'string'},
            {name: 'PERSON_NUMB'            ,text: '사원'                   ,type: 'string'},
            {name: 'GW_FLAG'                ,text: '기안여부'                ,type: 'string', store:Ext.data.StoreManager.lookup("gwStatus")},
            {name: 'GW_DOC'                 ,text: '기안문서번호'                 ,type: 'string'},
            {name: 'DRAFT_NO'               ,text: '결재번호'               ,type: 'string'}
		]
	});

	Unilite.defineModel('s_mre090ukrv_kdModel2', {
        fields: [
            {name: 'ITEM_CODE'       ,text: '품목코드'            ,type: 'string'},
            {name: 'ITEM_NAME'       ,text: '품목명'              ,type: 'string'},
            {name: 'GUBUN'           ,text: '구분'                ,type: 'string', comboType: 'AU', comboCode: 'WM01'},
            {name: 'M0'              ,text: 'M월'                 ,type: 'uniQty'},
            {name: 'M1'              ,text: 'M + 1월'             ,type: 'uniQty'},
            {name: 'M2'              ,text: 'M + 2월'             ,type: 'uniQty'},
            {name: 'M3'              ,text: 'M + 3월'             ,type: 'uniQty'},
            {name: 'M4'              ,text: 'M + 4월'             ,type: 'uniQty'},
            {name: 'M5'              ,text: 'M + 5월'             ,type: 'uniQty'},
            {name: 'M6'              ,text: 'M + 6월'             ,type: 'uniQty'}
        ]
    });

	Unilite.defineModel('orderNoMasterModel', {		//조회버튼 누르면 나오는 조회창(생산구매계획번호)
	    fields: [
	    	{name: 'COMP_CODE'		    	, text: '법인'    	    , type: 'string'},
            {name: 'DIV_CODE'               , text: '사업장'        , type: 'string'},
            {name: 'PRDT_REQ_NUM'           , text: '계획번호'      , type: 'string'},
            {name: 'REQ_DATE'               , text: '계획일'        , type: 'uniDate'},
            {name: 'GW_TITLE'               , text: '기안제목'      , type: 'string'},
            {name: 'SUPPLY_TYPE'            , text: '조달구분'      , type: 'string', comboType: 'AU', comboCode: 'B014'},
            {name: 'DOM_FORIGN'             , text: '내수/수입'     , type: 'string', comboType: 'AU', comboCode: 'T109'},
            {name: 'DEPT_CODE'              , text: '부서코드'      , type: 'string'},
            {name: 'DEPT_NAME'              , text: '부서명'        , type: 'string'},
            {name: 'PERSON_NUMB'            , text: '사번'          , type: 'string'},
            {name: 'PERSON_NAME'            , text: '사원명'        , type: 'string'},
            {name: 'GW_FLAG'                , text: '기안여부'      ,type: 'string', store:Ext.data.StoreManager.lookup("gwStatus")},
            {name: 'GW_DOC'                 , text: 'GW_DOC'        , type: 'string'},
            {name: 'DRAFT_NO'               , text: 'DRAFT_NO'      , type: 'string'},
            {name: 'PLAN_ORDER'             ,text: '계획차수'           , type: 'string'}
		]
	});

	Unilite.defineModel('s_mre090ukrv_kdOtherModel', {	//자재소요량 참조
	    fields: [
	    	{name: 'ITEM_CODE'		        , text: '품목코드'  	    , type: 'string'},
            {name: 'ITEM_NAME'              , text: '품목명'            , type: 'string'},
            {name: 'SPEC'                   , text: '규격'              , type: 'string'},
            {name: 'STOCK_UNIT'             , text: '단위'              , type: 'string'},
            {name: 'PURCH_LD_TIME'          , text: 'LEAD TIME'         , type: 'string'},
            {name: 'TERMPLAN_Q'             , text: '기간소요량'        , type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'SAFE_STOCK_Q'           , text: '안전재고량'        , type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'STOCK_Q'                , text: '현재고량'          , type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'NOIN_Q'                 , text: '미입고량'          , type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'ODER_PLAN_Q'            , text: '구매계획량'        , type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'DELIVERY_REQ_DATE'      , text: '희망납기일'        , type: 'uniDate'},
            {name: 'DELIVERY_REQ_ORI_DATE'  , text: '기존희망납기일'    , type: 'string'},
            {name: 'PLAN_Q_M0'              , text: 'PLAN_Q_M0'         , type: 'string'},
            {name: 'PLAN_Q_M1'              , text: 'PLAN_Q_M1'         , type: 'string'},
            {name: 'PLAN_Q_M2'              , text: 'PLAN_Q_M2'         , type: 'string'},
            {name: 'PLAN_Q_M3'              , text: 'PLAN_Q_M3'         , type: 'string'},
            {name: 'PLAN_Q_M4'              , text: 'PLAN_Q_M4'         , type: 'string'},
            {name: 'PLAN_Q_M5'              , text: 'PLAN_Q_M5'         , type: 'string'},
            {name: 'PLAN_Q_M6'              , text: 'PLAN_Q_M6'         , type: 'string'},
            {name: 'ORDER_Q_M0'             , text: 'ORDER_Q_M0'        , type: 'string'},
            {name: 'ORDER_Q_M1'             , text: 'ORDER_Q_M1'        , type: 'string'},
            {name: 'ORDER_Q_M2'             , text: 'ORDER_Q_M2'        , type: 'string'},
            {name: 'ORDER_Q_M3'             , text: 'ORDER_Q_M3'        , type: 'string'},
            {name: 'ORDER_Q_M4'             , text: 'ORDER_Q_M4'        , type: 'string'},
            {name: 'ORDER_Q_M5'             , text: 'ORDER_Q_M5'        , type: 'string'},
            {name: 'ORDER_Q_M6'             , text: 'ORDER_Q_M6'        , type: 'string'},
            {name: 'STOCK_Q_M0'             , text: 'STOCK_Q_M0'        , type: 'string'},
            {name: 'STOCK_Q_M1'             , text: 'STOCK_Q_M1'        , type: 'string'},
            {name: 'STOCK_Q_M2'             , text: 'STOCK_Q_M2'        , type: 'string'},
            {name: 'STOCK_Q_M3'             , text: 'STOCK_Q_M3'        , type: 'string'},
            {name: 'STOCK_Q_M4'             , text: 'STOCK_Q_M4'        , type: 'string'},
            {name: 'STOCK_Q_M5'             , text: 'STOCK_Q_M5'        , type: 'string'},
            {name: 'STOCK_Q_M6'             , text: 'STOCK_Q_M6'        , type: 'string'},
            {name: 'ORDER_PLAN_MM1'         , text: 'ORDER_PLAN_MM1'    , type: 'string'},
            {name: 'ORDER_PLAN_MM2'         , text: 'ORDER_PLAN_MM2'    , type: 'string'},
            {name: 'DOM_FORIGN'             , text: 'DOM_FORIGN'        , type: 'string'},
            {name: 'TRNS_RATE'              , text: 'TRNS_RATE'         , type: 'string'},
            {name: 'SUPPLY_TYPE'            , text: 'SUPPLY_TYPE'       , type: 'string'},
            {name: 'ITEM_ACCOUNT'           , text: 'ITEM_ACCOUNT'      , type: 'string'},
            {name: 'ORDER_PLAN_YYMM'        , text: 'ORDER_PLAN_YYMM'   , type: 'string'}
		]
	});

	Unilite.defineModel('s_mre090ukrv_kdOtherModel2', {
        fields: [
            {name: 'ITEM_CODE'       ,text: '품목코드'            ,type: 'string'},
            {name: 'ITEM_NAME'       ,text: '품목명'              ,type: 'string'},
            {name: 'GUBUN'           ,text: '구분'                ,type: 'string', comboType: 'AU', comboCode: 'WM01'},
            {name: 'M0'              ,text: 'M월'                 ,type: 'uniQty'},
            {name: 'M1'              ,text: 'M + 1월'             ,type: 'uniQty'},
            {name: 'M2'              ,text: 'M + 2월'             ,type: 'uniQty'},
            {name: 'M3'              ,text: 'M + 3월'             ,type: 'uniQty'},
            {name: 'M4'              ,text: 'M + 4월'             ,type: 'uniQty'},
            {name: 'M5'              ,text: 'M + 5월'             ,type: 'uniQty'},
            {name: 'M6'              ,text: 'M + 6월'             ,type: 'uniQty'}
        ]
    });

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_mre090ukrv_kdMasterStore1',{
		model: 's_mre090ukrv_kdModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
           	editable: true,			// 수정 모드 사용
           	deletable: true,			// 삭제 가능 여부
           	allDeletable: true,
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param,
				// NEW ADD
				callback: function(records, operation, success){
					console.log(records);
					if(success){
						if(masterGrid.getStore().getCount() == 0){
							Ext.getCmp('GW').setDisabled(true);
							Ext.getCmp('GW2').setDisabled(true);
						}else if(masterGrid.getStore().getCount() != 0){
						  var gwFlag = directMasterStore1.data.items[0].data.GW_FLAG;
							UniBase.fnGwBtnControl('GW', gwFlag);
							if (gwFlag == '3')
							{
                Ext.getCmp('GW2').setDisabled(false);
							}
							else
							{
  							Ext.getCmp('GW2').setDisabled(true);
							}
						}
					}
				}
				//END
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
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("PRDT_REQ_NUM", master.PRDT_REQ_NUM);
						panelResult.setValue("PRDT_REQ_NUM", master.PRDT_REQ_NUM);
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						directMasterStore1.loadStoreRecords();
						if(directMasterStore1.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        }

					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_mre090ukrv_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners:{
            load: function(store, records, successful, eOpts) {
              /*   if(masterGrid.getStore().getCount() == 0) {
                    Ext.getCmp('GW').setDisabled(true);
                    Ext.getCmp('GW2').setDisabled(true);
                } else if(masterGrid.getStore().getCount() != 0) {
                    Ext.getCmp('GW').setDisabled(false);
                    Ext.getCmp('GW2').setDisabled(false);
                } else {
                    if(directMasterStore1.data.items[0].data.GW_FLAG == 'Y') {
                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], false);
                    } else {
                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], true);
                    }
                } */
            }
        }
	});

	var directMasterStore2 = Unilite.createStore('orderNoMasterStore', {   // grid2
        model: 's_mre090ukrv_kdModel2',
        autoLoad: false,
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read    : 's_mre090ukrv_kdService.selectList2'
            }
        },
        loadStoreRecords : function(param)   {
            this.load({
                params : param
            });
        }
    });

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	//조회버튼 누르면 나오는 조회창(생산구매계획번호)
		model: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read    : 's_mre090ukrv_kdService.selectOrderNumMasterList'
			}
		},
		loadStoreRecords : function()	{
			var param= orderNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var otherOrderStore = Unilite.createStore('s_mre090ukrv_kdOtherOrderStore', {   //자재소요량정보 참조
		model: 's_mre090ukrv_kdOtherModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 's_mre090ukrv_kdService.selectMrpList'
            }
        },
		listeners:{
        	load:function(store, records, successful, eOpts) {
				if(successful)	{
    			   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
    			   var orderRecords = new Array();
    			   if(masterRecords.items.length > 0)	{
    			   		console.log("store.items :", store.items);
    			   		console.log("records", records);
        			   	Ext.each(records,
        			   		function(item, i)	{
	   							Ext.each(masterRecords.items, function(record, i)	{
	   								console.log("record :", record);
   									if((record.data['ITEM_CODE'] == item.data['ITEM_CODE'])){
   										orderRecords.push(item);
   									}
	   							});
        			   		});
        			   store.remove(orderRecords);
    			   }
        		}
/* 				if(store.getCount() > 0){
	                var param = 0;
	                Ext.each(records, function(record, index) {
	                	param = record.get('ODER_PLAN_Q');
	                });
	                otherorderSearch.setValue('ORDER_PLAN_Q', param);
	        } */
        	}
        },
		loadStoreRecords : function()	{
			var param= otherorderSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(otherorderSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var otherOrderStore2 = Unilite.createStore('s_mre090ukrv_kdOtherOrderStore', {   //자재소요량정보 참조2
        model: 's_mre090ukrv_kdOtherModel2',
        autoLoad: false,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_mre090ukrv_kdService.selectMrpList2'
            }
        },
        loadStoreRecords : function(param)   {
            this.load({
                params : param
            });
        }
    });

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '기안여부TEMP',
            name:'GW_TEMP',
            xtype: 'uniTextfield',
            hidden: true
        },{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			holdable: 'hold',
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('DIV_CODE', newValue);
				}
			}
		},
        {
            fieldLabel:'생산구매계획번호',
            name: 'PRDT_REQ_NUM',
            xtype: 'uniTextfield',
            holdable: 'hold',
            labelWidth: 100,
            readOnly: true
        },
		{
	 		fieldLabel: '요청일자',
	 		xtype: 'uniDatefield',
	 		name: 'PRDT_REQ_DATE',
	 		value: UniDate.get('today'),
	 		allowBlank:false,
	 		holdable: 'hold'
		},
		{
            fieldLabel:'구매계획월',
            name: 'PLAN_YYYYMM',
            xtype: 'uniMonthfield',
	 		holdable: 'hold',
	    	listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					columnHeaderSet2(newValue);
				}
			}
        },
        {
            fieldLabel: '계획차수',
            name: 'PLAN_ORDER',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'M517',
            width: 180,
            allowBlank:true,
            holdable: 'hold',
            fieldStyle: 'text-align: center;'
        },
		Unilite.popup('DEPT', {
			fieldLabel: '부서',
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			holdable: 'hold',
			listeners: {
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					if(authoInfo == "A"){	//자기사업장
						popup.setExtParam({'TREE_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'TREE_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),
		Unilite.popup('Employee',{
			fieldLabel: '사원',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'PERSON_NAME',
            holdable: 'hold',
            labelWidth: 100,
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelResult.setValue('PERSON_NUMB', newValue);
					var param= Ext.getCmp('resultForm').getValues();
                    s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){
                            panelResult.setValue('DEPT_CODE', provider[0].DEPT_CODE);
                            panelResult.setValue('DEPT_NAME', provider[0].DEPT_NAME);
                        }
                    });
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('PERSON_NAME', newValue);
					var param= Ext.getCmp('resultForm').getValues();
                    s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){
                            panelResult.setValue('DEPT_CODE', provider[0].DEPT_CODE);
                            panelResult.setValue('DEPT_NAME', provider[0].DEPT_NAME);
                        }
                    });
				}
			}
		}),
        {
            fieldLabel: '조달구분',
            name: 'SUPPLY_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B014',
            allowBlank:false,
            holdable: 'hold'
        },{
            xtype: 'radiogroup',
            fieldLabel: '내수/수입',
            id: 'rdoSelect',
            holdable: 'hold',
            items: [{
                boxLabel: '내수',
                width: 50,
                name: 'DOM_FORIGN',
                inputValue: '1',
                checked: true
            },{
                boxLabel : '수입',
                width: 50,
                inputValue: '2',
                name: 'DOM_FORIGN'
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
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
	  		} else {
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
    });

    var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
	    trackResetOnLoad: true,
	    items: [{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value: UserInfo.divCode,
			allowBlank: false
		},
		{
			fieldLabel: '요청일',
			xtype: 'uniDateRangefield',
			startFieldName: 'REQ_DATE_FR',
			endFieldName: 'REQ_DATE_TO',
            allowBlank: false,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		Unilite.popup('DEPT', {
			fieldLabel: '부서',
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			listeners: {
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					if(authoInfo == "A"){	//자기사업장
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),
		{
			fieldLabel: '조달구분',
			name: 'SUPPLY_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B014',
			readOnly: true,
			colspan: 2
		},
		Unilite.popup('Employee',{
			fieldLabel: '사원',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'PERSON_NAME',
			autoPopup:true,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    orderNoSearch.setValue('PERSON_NUMB', newValue);
                    var param= Ext.getCmp('orderNoSearchForm').getValues();
                    s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){
                            orderNoSearch.setValue('DEPT_CODE', provider[0].DEPT_CODE);
                            orderNoSearch.setValue('DEPT_NAME', provider[0].DEPT_NAME);
                        }
                    });
                },
                onTextFieldChange: function(field, newValue){
                    orderNoSearch.setValue('PERSON_NAME', newValue);
                    var param= Ext.getCmp('orderNoSearchForm').getValues();
                    s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){
                            orderNoSearch.setValue('DEPT_CODE', provider[0].DEPT_CODE);
                            orderNoSearch.setValue('DEPT_NAME', provider[0].DEPT_NAME);
                        }
                    });
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
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    var otherorderSearch = Unilite.createSearchForm('otherorderForm', {     //자재소요량 참조
		layout: {type : 'uniTable', columns : 3},
		items :[
		  {
			  fieldLabel:'ORDER_PLAN_Q',
			  name:'ORDER_PLAN_Q',
			  hidden:true
		  },
		  {
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			allowBlank:false,
			comboType:'BOR120'
		},
		{
			fieldLabel: '기준년월',
			xtype: 'uniMonthfield',
            allowBlank:false,
			name: 'ORDER_PLAN_YYMM',
	    	listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					columnHeaderSet(newValue);
				}
			}
		},
		{
            fieldLabel: '조달구분',
            name: 'SUPPLY_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B014',
            readOnly: true
        },
        Unilite.popup('DIV_PUMOK',{
                fieldLabel: '품목코드',
                valueFieldName: 'ITEM_CODE',
                textFieldName: 'ITEM_NAME',
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': otherorderSearch.getValue('DIV_CODE')});
                    }
                }
        }),
        {
            fieldLabel: '품목계정',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020'
        },{
            xtype: 'radiogroup',
            fieldLabel: '내수/수입',
            id: 'rdoSelect2',
            items: [{
                boxLabel: '내수',
                width: 50,
                name: 'DOM_FORIGN',
                readOnly: true,
                inputValue: '1'
            },{
                boxLabel : '수입',
                width: 50,
                inputValue: '2',
                readOnly: true,
                name: 'DOM_FORIGN'
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
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid= Unilite.createGrid('s_mre090ukrv_kdGrid', {
    	region: 'center' ,
        layout: 'fit',
        excelTitle: '생산구매계획등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        tbar: [{
                itemId : 'GWBtn',
                id:'GW',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('PRDT_REQ_NUM');
                    if(confirm('기안 하시겠습니까?')) {
                        s_mre090ukrv_kdService.selectGwData(param, function(provider, response) {
                            if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                                panelResult.setValue('GW_TEMP', '기안중');
                                s_mre090ukrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                    UniAppManager.app.requestApprove();
                                });
                            } else {
                                alert('이미 기안된 자료입니다.');
                                return false;
                            }
                        });
                    }
                    UniAppManager.app.onQueryButtonDown();
                }
            },{
                itemId : 'GWBtn2',
                id:'GW2',
                iconCls : 'icon-referance'  ,
                text:'기안뷰',
                handler: function() {
                    var param = panelResult.getValues();
                    param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('PRDT_REQ_NUM');
                    record = masterGrid.getSelectedRecord();
                    s_mre090ukrv_kdService.selectDraftNo(param, function(provider, response) {
                        if(Ext.isEmpty(provider[0])) {
                            alert('draft No가 없습니다.');
                            return false;
                        } else {
                            UniAppManager.app.requestApprove2(record);
                        }
                    });
                    UniAppManager.app.onQueryButtonDown();
                }
            },{
    			xtype: 'splitbutton',
               	itemId:'orderTool',
    			text: '참조...',
    			iconCls : 'icon-referance',
    			menu: Ext.create('Ext.menu.Menu', {
    				items: [{
						itemId: 'mrpRefBtn',
						text: '자재소요량정보 참조',
						handler: function() {
							openOtherMrpWindow();
						}
					}]
    			})
    		}
        ],
    	store: directMasterStore1,
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
        	{dataIndex:'COMP_CODE'			   					                , width: 93, hidden: true},
            {dataIndex:'DIV_CODE'                                 , width: 93, hidden: true},
            {dataIndex:'PRDT_REQ_SEQ'                             , width: 50},
            {dataIndex:'PRDT_REQ_NUM'                             , width: 100, hidden: true},
            {dataIndex:'ITEM_CODE'                                , width: 110,
                editor: Unilite.popup('DIV_PUMOK_G', {
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
                        autoPopup:true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {
                                    if(i==0) {
                                        masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                    }
                                });
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE':                  panelResult.getValue('DIV_CODE')});
                            popup.setExtParam({'SUPPLY_TYPE_READONLY':      'supplyReadOnly'});
                        }
                    }
                })
            },
            {dataIndex:'ITEM_NAME'                                , width: 150},
            {dataIndex:'SPEC'                                     , width: 150},
            {dataIndex:'STOCK_UNIT'                               , width: 90},
            {dataIndex:'PURCH_LD_TIME'                            , width: 90},
            {dataIndex:'TERMPLAN_Q'                               , width: 90  },
            {dataIndex:'SAFE_STOCK_Q'                             , width: 90},
            {dataIndex:'STOCK_Q'                                  , width: 90},
            {dataIndex:'NOIN_Q'                                   , width: 90},
            {dataIndex:'ORDER_PLAN_Q'                             , width: 90},
            {dataIndex:'NOT_PO_QTY'                             , width: 90},
            {dataIndex:'DELIVERY_REQ_DATE'                        , width: 90},
            {dataIndex:'REMARK'                                   , width: 100},
            {dataIndex:'DELIVERY_REQ_ORI_DATE'                    , width: 93, hidden: true},
            {dataIndex:'PLAN_Q_M0'                                , width: 93, hidden: true},
            {dataIndex:'PLAN_Q_M1'                                , width: 93, hidden: true},
            {dataIndex:'PLAN_Q_M2'                                , width: 93, hidden: true},
            {dataIndex:'PLAN_Q_M3'                                , width: 93, hidden: true},
            {dataIndex:'PLAN_Q_M4'                                , width: 93, hidden: true},
            {dataIndex:'PLAN_Q_M5'                                , width: 93, hidden: true},
            {dataIndex:'PLAN_Q_M6'                                , width: 93, hidden: true},
            {dataIndex:'ORDER_Q_M0'                               , width: 93, hidden: true},
            {dataIndex:'ORDER_Q_M1'                               , width: 93, hidden: true},
            {dataIndex:'ORDER_Q_M2'                               , width: 93, hidden: true},
            {dataIndex:'ORDER_Q_M3'                               , width: 93, hidden: true},
            {dataIndex:'ORDER_Q_M4'                               , width: 93, hidden: true},
            {dataIndex:'ORDER_Q_M5'                               , width: 93, hidden: true},
            {dataIndex:'ORDER_Q_M6'                               , width: 93, hidden: true},
            {dataIndex:'STOCK_Q_M0'                               , width: 93, hidden: true},
            {dataIndex:'STOCK_Q_M1'                               , width: 93, hidden: true},
            {dataIndex:'STOCK_Q_M2'                               , width: 93, hidden: true},
            {dataIndex:'STOCK_Q_M3'                               , width: 93, hidden: true},
            {dataIndex:'STOCK_Q_M4'                               , width: 93, hidden: true},
            {dataIndex:'STOCK_Q_M5'                               , width: 93, hidden: true},
            {dataIndex:'STOCK_Q_M6'                               , width: 93, hidden: true},
            {dataIndex:'ORDER_PLAN_MM1'                           , width: 93, hidden: true},
            {dataIndex:'ORDER_PLAN_MM2'                           , width: 93, hidden: true},
            {dataIndex:'DOM_FORIGN'                               , width: 93, hidden: true},
            {dataIndex:'TRNS_RATE'                                , width: 93, hidden: true},
            {dataIndex:'SUPPLY_TYPE'                              , width: 93, hidden: true},
            {dataIndex:'ITEM_ACCOUNT'                             , width: 93, hidden: true},
            {dataIndex:'ORDER_PLAN_YYMM'                          , width: 93, hidden: true},
            {dataIndex:'REQ_DATE'                                 , width: 93, hidden: true},
            {dataIndex:'DEPT_CODE'                                , width: 93, hidden: true},
            {dataIndex:'PERSON_NUMB'                              , width: 93, hidden: true},
            {dataIndex:'GW_FLAG'                                  , width: 93, hidden: false, align: 'center'},
            {dataIndex:'GW_DOC'                                   , width: 130, hidden: false, align: 'center'},
            {dataIndex:'DRAFT_NO'                                 , width: 130, hidden: false, align: 'center'}
        ],
        listeners: {
			beforeedit  : function( editor, e, eOpts ) {
                if(panelResult.getValue('GW_TEMP') == '기안중') {
                    return false;
                }
				if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ORDER_PLAN_Q', 'DELIVERY_REQ_DATE', 'REMARK'])) {
					return true;
				} else {
                    return false;
				}
			},
			selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var selRow = masterGrid.getSelectedRecord();
                    var record = selected[0];
                    var param= panelResult.getValues();
                    param.DIV_CODE          = record.get('DIV_CODE');
                    param.ITEM_CODE         = record.get('ITEM_CODE');
                    param.ORDER_PLAN_YYMM   = record.get('ORDER_PLAN_YYMM');
                    if(selRow.phantom == false) {
                        directMasterStore2.loadStoreRecords(param);
                    } else if(selRow.phantom == true && record.get('TERMPLAN_Q') != 0) {
                    	directMasterStore2.loadStoreRecords(param);
                    }
                    columnHeaderSet2(record.get('ORDER_PLAN_YYMM'));
                }
            }
		},
		setItemData: function(record, dataClear, grdRecord) {
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			,"");
       			grdRecord.set('ITEM_NAME'			,"");
				grdRecord.set('ITEM_ACCOUNT'		,"");
				grdRecord.set('SPEC'				,"");
				grdRecord.set('STOCK_UNIT'			,"");
                grdRecord.set('PURCH_LD_TIME'       ,"");
                grdRecord.set('DOM_FORIGN'          ,"");
                grdRecord.set('TRNS_RATE'           ,"");
                grdRecord.set('SUPPLY_TYPE'         ,"");
                grdRecord.set('STOCK_Q'             ,"");
                grdRecord.set('NOIN_Q'              ,"");
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
                grdRecord.set('PURCH_LD_TIME'       , record['PURCH_LDTIME']);
//                grdRecord.set('DOM_FORIGN'          , record['DOM_FORIGN']);
                grdRecord.set('TRNS_RATE'           , record['TRNS_RATE']);
                grdRecord.set('SUPPLY_TYPE'         , record['SUPPLY_TYPE']);
                var param = {
                	"ITEM_CODE":   record['ITEM_CODE'],
                    "WH_CODE":     'KGM1'
                };
                s_mre090ukrv_kdService.fnStockQ(param, function(provider, response)  {
                    if(!Ext.isEmpty(provider)){
                        grdRecord.set('STOCK_Q'             , provider['STOCK_Q']);
                    }
                });
                var param2 = {
                	"DIV_CODE":          panelResult.getValue('DIV_CODE'),
                    "ITEM_CODE":         record['ITEM_CODE'],
                    "PRDT_REQ_DATE":     UniDate.getDbDateStr(panelResult.getValue('PRDT_REQ_DATE')).substring(0, 6),
                    "PURCH_LDTIME":     record['PURCH_LDTIME']
                };
                s_mre090ukrv_kdService.fnNointQ(param2, function(provider, response)  {
                    if(!Ext.isEmpty(provider)){
                        grdRecord.set('TERMPLAN_Q'            , provider['TERMPLAN_Q']);
                        grdRecord.set('SAFE_STOCK_Q'          , provider['SAFE_STOCK_Q']);
                        grdRecord.set('NOIN_Q'                , provider['NOIN_Q']);
                    }
                });
       		}
		},
		setMrpData:function(record) {
       		var grdRecord = this.getSelectedRecord();
       	    grdRecord.set('DIV_CODE'			          , panelResult.getValue('DIV_CODE'));
            grdRecord.set('PRDT_REQ_NUM'                  , panelResult.getValue('PRDT_REQ_NUM'));
       	 	grdRecord.set('ITEM_CODE'		     		  , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'                     , record['ITEM_NAME']);
            grdRecord.set('SPEC'                          , record['SPEC']);
            grdRecord.set('STOCK_UNIT'                    , record['STOCK_UNIT']);
            grdRecord.set('PURCH_LD_TIME'                 , record['PURCH_LD_TIME']);
            grdRecord.set('TERMPLAN_Q'                    , record['TERMPLAN_Q']);
            grdRecord.set('SAFE_STOCK_Q'                  , record['SAFE_STOCK_Q']);
            grdRecord.set('STOCK_Q'                       , record['STOCK_Q']);
            grdRecord.set('NOIN_Q'                        , record['NOIN_Q']);
            grdRecord.set('ORDER_PLAN_Q'                   , record['ODER_PLAN_Q']);
            grdRecord.set('DELIVERY_REQ_DATE'             , record['DELIVERY_REQ_DATE']);
            grdRecord.set('DELIVERY_REQ_ORI_DATE'         , record['DELIVERY_REQ_ORI_DATE']);
            grdRecord.set('PLAN_Q_M0'                     , record['PLAN_Q_M0']);
            grdRecord.set('PLAN_Q_M1'                     , record['PLAN_Q_M1']);
            grdRecord.set('PLAN_Q_M2'                     , record['PLAN_Q_M2']);
            grdRecord.set('PLAN_Q_M3'                     , record['PLAN_Q_M3']);
            grdRecord.set('PLAN_Q_M4'                     , record['PLAN_Q_M4']);
            grdRecord.set('PLAN_Q_M5'                     , record['PLAN_Q_M5']);
            grdRecord.set('PLAN_Q_M6'                     , record['PLAN_Q_M6']);
            grdRecord.set('ORDER_Q_M0'                    , record['ORDER_Q_M0']);
            grdRecord.set('ORDER_Q_M1'                    , record['ORDER_Q_M1']);
            grdRecord.set('ORDER_Q_M2'                    , record['ORDER_Q_M2']);
            grdRecord.set('ORDER_Q_M3'                    , record['ORDER_Q_M3']);
            grdRecord.set('ORDER_Q_M4'                    , record['ORDER_Q_M4']);
            grdRecord.set('ORDER_Q_M5'                    , record['ORDER_Q_M5']);
            grdRecord.set('ORDER_Q_M6'                    , record['ORDER_Q_M6']);
            grdRecord.set('STOCK_Q_M0'                    , record['STOCK_Q_M0']);
            grdRecord.set('STOCK_Q_M1'                    , record['STOCK_Q_M1']);
            grdRecord.set('STOCK_Q_M2'                    , record['STOCK_Q_M2']);
            grdRecord.set('STOCK_Q_M3'                    , record['STOCK_Q_M3']);
            grdRecord.set('STOCK_Q_M4'                    , record['STOCK_Q_M4']);
            grdRecord.set('STOCK_Q_M5'                    , record['STOCK_Q_M5']);
            grdRecord.set('STOCK_Q_M6'                    , record['STOCK_Q_M6']);
            grdRecord.set('ORDER_PLAN_MM1'                , record['ORDER_PLAN_MM1']);
            grdRecord.set('ORDER_PLAN_MM2'                , record['ORDER_PLAN_MM2']);
            grdRecord.set('DOM_FORIGN'                    , record['DOM_FORIGN']);
            grdRecord.set('TRNS_RATE'                     , record['TRNS_RATE']);
            grdRecord.set('SUPPLY_TYPE'                   , record['SUPPLY_TYPE']);
            grdRecord.set('ITEM_ACCOUNT'                  , record['ITEM_ACCOUNT']);
            grdRecord.set('ORDER_PLAN_YYMM'               , record['ORDER_PLAN_YYMM']);

            var param= panelResult.getValues();
            param.ITEM_CODE         = grdRecord.get('ITEM_CODE');
            param.ORDER_PLAN_YYMM   = grdRecord.get('ORDER_PLAN_YYMM');
            columnHeaderSet2(grdRecord.get('ORDER_PLAN_YYMM'));
            directMasterStore2.loadStoreRecords(param);
		}
    });

    var masterGrid2 = Unilite.createGrid('s_mre090ukrv_kdGrid2', {
            region: 'south' ,
            layout: 'fit',
            excelTitle: '기간소요량정보',
            uniOpt: {
                useGroupSummary: false,
                useLiveSearch: true,
                useContextMenu: true,
                useMultipleSorting: true,
                useRowNumberer: false,
                expandLastColumn: true,
                filter: {
                    useFilter: false,
                    autoCreate: false
                }
            },
            store: directMasterStore2,
            features: [{
                    id: 'masterGridSubTotal',
                    ftype: 'uniGroupingsummary',
                    showSummaryRow: false
                },{
                    id: 'masterGridTotal',
                    ftype: 'uniSummary',
                    showSummaryRow: false
                }
            ],
            columns: [
                {dataIndex:'ITEM_CODE'                              , width: 110},
                {dataIndex:'ITEM_NAME'                              , width: 200},
                {dataIndex:'GUBUN'                                  , width: 90},
                {dataIndex:'M0'                                     , width: 90},
                {dataIndex:'M1'                                     , width: 90},
                {dataIndex:'M2'                                     , width: 90},
                {dataIndex:'M3'                                     , width: 90},
                {dataIndex:'M4'                                     , width: 90},
                {dataIndex:'M5'                                     , width: 90},
                {dataIndex:'M6'                                     , width: 90}
            ],
    		listeners: {
    			afterrender: function(grid) {
    				columnHeaderSet2(panelResult.getValue('PLAN_YYYYMM'));
    			}
    		}
    });

	var orderNoMasterGrid = Unilite.createGrid('s_mre090ukrv_kdOrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창 (생산구매계획번호)
		layout : 'fit',
        //excelTitle: '구매요청등록(생산구매계획번호검색)',
		store: orderNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
        columns: [
			{ dataIndex: 'COMP_CODE'			,  width: 93, hidden: true},
            { dataIndex: 'DIV_CODE'             ,  width: 93, hidden: true},
            { dataIndex: 'PRDT_REQ_NUM'         ,  width: 130},
            { dataIndex: 'REQ_DATE'             ,  width: 100},
            { dataIndex: 'GW_TITLE'             ,  width: 250},
            { dataIndex: 'SUPPLY_TYPE'          ,  width: 80},
            { dataIndex: 'PLAN_ORDER'           ,  width: 80, align: 'center'},
            { dataIndex: 'DOM_FORIGN'           ,  width: 80},
            { dataIndex: 'DEPT_CODE'            ,  width: 93, hidden: true},
            { dataIndex: 'DEPT_NAME'            ,  width: 90 },
            { dataIndex: 'PERSON_NUMB'          ,  width: 93, hidden: true},
            { dataIndex: 'PERSON_NAME'          ,  width: 90 },
            { dataIndex: 'GW_FLAG'              ,  width: 80 },
            { dataIndex: 'GW_DOC'               ,  width: 93, hidden: true},
            { dataIndex: 'DRAFT_NO'             ,  width: 93, hidden: true}

		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				//UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'DIV_CODE':record.get('DIV_CODE'),
				'PRDT_REQ_NUM':record.get('PRDT_REQ_NUM'),
                'PRDT_REQ_DATE':record.get('REQ_DATE'),
                'PERSON_NUMB':record.get('PERSON_NUMB'),
				'PERSON_NAME':record.get('PERSON_NAME'),
				'DEPT_CODE':record.get('DEPT_CODE'),
                'DEPT_NAME':record.get('DEPT_NAME'),
                'SUPPLY_TYPE':record.get('SUPPLY_TYPE'),
                'DOM_FORIGN':record.get('DOM_FORIGN'),
                'PLAN_YYYYMM':record.get('PLAN_YYYYMM'),
                'PLAN_ORDER':record.get('PLAN_ORDER')
          	});
            panelResult.setAllFieldsReadOnly(true);
          	directMasterStore1.loadStoreRecords();
		}
    });


	var otherorderGrid = Unilite.createGrid('s_mre090ukrv_kdOtherorderGrid', {   //자재소요량정보 참조
		layout: 'fit',
    	store: otherOrderStore,
    	uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
        	listeners: {
        		select: function(grid, selectRecord, index, rowIndex, eOpts ){
        			selRecord = selectRecord;
        		},
				deselect:  function(grid, selectRecord, index, eOpts ){
					otherOrderStore2.loadData({});
				}
        	}
    	}),
        columns: [
			{ dataIndex: 'ITEM_CODE'		      	 ,  width: 110},
            { dataIndex: 'ITEM_NAME'                 ,  width: 200},
            { dataIndex: 'SPEC'                      ,  width: 200},
            { dataIndex: 'STOCK_UNIT'                ,  width: 90},
            { dataIndex: 'PURCH_LD_TIME'             ,  width: 90, align: 'right'},
            { dataIndex: 'TERMPLAN_Q'                ,  width: 90, align: 'right'},
            { dataIndex: 'SAFE_STOCK_Q'              ,  width: 90, align: 'right'},
            { dataIndex: 'STOCK_Q'                   ,  width: 90, align: 'right'},
            { dataIndex: 'NOIN_Q'                    ,  width: 90, align: 'right'},
            { dataIndex: 'ODER_PLAN_Q'               ,  width: 90, align: 'right'},
            { dataIndex: 'DELIVERY_REQ_DATE'         ,  width: 90},
            { dataIndex: 'DELIVERY_REQ_ORI_DATE'     ,  width: 90, hidden: true},
            { dataIndex: 'PLAN_Q_M0'                 ,  width: 90, hidden: true},
            { dataIndex: 'PLAN_Q_M1'                 ,  width: 90, hidden: true},
            { dataIndex: 'PLAN_Q_M2'                 ,  width: 90, hidden: true},
            { dataIndex: 'PLAN_Q_M3'                 ,  width: 90, hidden: true},
            { dataIndex: 'PLAN_Q_M4'                 ,  width: 90, hidden: true},
            { dataIndex: 'PLAN_Q_M5'                 ,  width: 90, hidden: true},
            { dataIndex: 'PLAN_Q_M6'                 ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_Q_M0'                ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_Q_M1'                ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_Q_M2'                ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_Q_M3'                ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_Q_M4'                ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_Q_M5'                ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_Q_M6'                ,  width: 90, hidden: true},
            { dataIndex: 'STOCK_Q_M0'                ,  width: 90, hidden: true},
            { dataIndex: 'STOCK_Q_M1'                ,  width: 90, hidden: true},
            { dataIndex: 'STOCK_Q_M2'                ,  width: 90, hidden: true},
            { dataIndex: 'STOCK_Q_M3'                ,  width: 90, hidden: true},
            { dataIndex: 'STOCK_Q_M4'                ,  width: 90, hidden: true},
            { dataIndex: 'STOCK_Q_M5'                ,  width: 90, hidden: true},
            { dataIndex: 'STOCK_Q_M6'                ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_PLAN_MM1'            ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_PLAN_MM2'            ,  width: 90, hidden: true},
            { dataIndex: 'DOM_FORIGN'                ,  width: 90, hidden: true},
            { dataIndex: 'TRNS_RATE'                 ,  width: 90, hidden: true},
            { dataIndex: 'SUPPLY_TYPE'               ,  width: 90, hidden: true},
            { dataIndex: 'ITEM_ACCOUNT'              ,  width: 90, hidden: true},
            { dataIndex: 'ORDER_PLAN_YYMM'           ,  width: 90, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				if(Ext.isEmpty(record))	{
	          		record = this.getSelectedRecord();
	          	}

			},
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                	//var record = selected[0];
                	var record = selRecord;
                    var param= otherorderSearch.getValues();
                    param.DIV_CODE          = record.get('DIV_CODE');
                    param.ITEM_CODE         = record.get('ITEM_CODE');
                    param.ORDER_PLAN_Q = record.get('ODER_PLAN_Q');
                    param.ORDER_PLAN_YYMM   = record.get('ORDER_PLAN_YYMM');
                    otherOrderStore2.loadStoreRecords(param);
                }
            }
		},
		returnData: function(record)	{
			var records = this.sortedSelectedRecords(this);
			Ext.each(records, function(record,i){
	        	UniAppManager.app.onNewDataButtonDown();
	        	masterGrid.setMrpData(record.data);
		    });
		    this.deleteSelectedRow();
		}
	});

	var otherorderGrid2 = Unilite.createGrid('s_mre090ukrv_kdOtherorderGrid2', {   //자재소요량정보 참조
        region: 'south' ,
        layout: 'fit',
        store: otherOrderStore2,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            onLoadSelectFirst: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }
        },
        columns: [
                {dataIndex:'ITEM_CODE'                              , width: 110},
                {dataIndex:'ITEM_NAME'                              , width: 200},
                {dataIndex:'GUBUN'                                  , width: 90},
                {dataIndex:'M0'                                     , width: 90},
                {dataIndex:'M1'                                     , width: 90},
                {dataIndex:'M2'                                     , width: 90},
                {dataIndex:'M3'                                     , width: 90},
                {dataIndex:'M4'                                     , width: 90},
                {dataIndex:'M5'                                     , width: 90},
                {dataIndex:'M6'                                     , width: 90}
            ]
    });

    function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
        orderNoSearch.setValue('DIV_CODE',          panelResult.getValue('DIV_CODE'));
        orderNoSearch.setValue('DEPT_CODE',         panelResult.getValue('DEPT_CODE'));
        orderNoSearch.setValue('DEPT_NAME',         panelResult.getValue('DEPT_NAME'));
        orderNoSearch.setValue('PERSON_NUMB',       panelResult.getValue('PERSON_NUMB'));
        orderNoSearch.setValue('PERSON_NAME',       panelResult.getValue('PERSON_NAME'));
        orderNoSearch.setValue('SUPPLY_TYPE',       panelResult.getValue('SUPPLY_TYPE'));
        orderNoSearch.setValue('REQ_DATE_FR',       UniDate.get('startOfMonth'));
        orderNoSearch.setValue('REQ_DATE_TO',       UniDate.get('today'));
        orderNoMasterStore.loadStoreRecords();

		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
            	title: '생산구매의뢰번호검색',
                width: 950,
                height: 500,
                layout: {type:'vbox', align:'stretch'},
                items: [orderNoSearch, orderNoMasterGrid], //orderNoDetailGrid],
                tbar:  ['->',{
					itemId : 'saveBtn',
					text: '조회',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId : 'OrderNoCloseBtn',
					text: '닫기',
					handler: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt)	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
					 	orderNoSearch.setValue('DIV_CODE',		    panelResult.getValue('DIV_CODE'));
					 	orderNoSearch.setValue('DEPT_CODE',		    panelResult.getValue('DEPT_CODE'));
					 	orderNoSearch.setValue('DEPT_NAME',		    panelResult.getValue('DEPT_NAME'));
                        orderNoSearch.setValue('PERSON_NUMB',       panelResult.getValue('PERSON_NUMB'));
                        orderNoSearch.setValue('PERSON_NAME',       panelResult.getValue('PERSON_NAME'));
                        orderNoSearch.setValue('SUPPLY_TYPE',       panelResult.getValue('SUPPLY_TYPE'));
                        orderNoSearch.setValue('REQ_DATE_FR',       UniDate.get('startOfMonth'));
                        orderNoSearch.setValue('REQ_DATE_TO',       UniDate.get('today'));
                        orderNoMasterStore.loadStoreRecords();
			         }
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
    }

	function openOtherMrpWindow() {    		//자재소요량정보 참조
		if(!panelResult.setAllFieldsReadOnly(true)) return false;
        otherorderSearch.setValue('DIV_CODE',           panelResult.getValue('DIV_CODE'));
        otherorderSearch.setValue('ITEM_ACCOUNT',       panelResult.getValue('ITEM_ACCOUNT'));
        otherorderSearch.setValue('SUPPLY_TYPE',        panelResult.getValue('SUPPLY_TYPE'));
        otherorderSearch.setValue('ORDER_PLAN_YYMM',    UniDate.get('today'));
        otherorderSearch.setValue('DOM_FORIGN',         Ext.getCmp('rdoSelect').getChecked()[0].inputValue);
        otherOrderStore.loadStoreRecords();

		if(!referOtherMrpWindow) {
			referOtherMrpWindow = Ext.create('widget.uniDetailWindow', {
                title: '자재소요량정보참조',
                width: 1290,
                height: 600,
                layout: {type:'vbox', align:'stretch'},
                items: [otherorderSearch, otherorderGrid, otherorderGrid2],
                tbar: ['->',{
					itemId : 'saveBtn',
					text: '조회',
					handler: function() {
                        otherOrderStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '적용 후 닫기',
					handler: function() {
						otherorderGrid.returnData();
						referOtherMrpWindow.hide();
						//directMasterStore1.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '닫기',
					handler: function() {
						referOtherMrpWindow.hide();
					},
					disabled: false
				}],
                listeners: {
					beforehide: function(me, eOpt)	{
						otherorderSearch.clearForm();
                        otherorderGrid.reset();
                        otherorderGrid2.reset();
	    			},
	    			beforeclose: function( panel, eOpts )	{
	    				otherorderSearch.clearForm();
                        otherorderGrid.reset();
                        otherorderGrid2.reset();
	    			},
	    			show: function( panel, eOpts )	{
	    				otherorderSearch.setValue('DIV_CODE',	        panelResult.getValue('DIV_CODE'));
				     	otherorderSearch.setValue('ITEM_ACCOUNT',	    panelResult.getValue('ITEM_ACCOUNT'));
				     	otherorderSearch.setValue('SUPPLY_TYPE',	    panelResult.getValue('SUPPLY_TYPE'));
                        otherorderSearch.setValue('ORDER_PLAN_YYMM',    UniDate.get('today'));
                        otherorderSearch.setValue('DOM_FORIGN',         Ext.getCmp('rdoSelect').getChecked()[0].inputValue);
                        otherOrderStore.loadStoreRecords();
                        columnHeaderSet(UniDate.get('today'));
	    			}
                }
			})
		}
		referOtherMrpWindow.center();
		referOtherMrpWindow.show();
	};

    function columnHeaderSet(basicDate){
    	if(Ext.isEmpty(basicDate)){
    		return false;
    	}
    	var curYyyyMm = UniDate.getDbDateStr(basicDate).substring(0,6);
		var yyyy = curYyyyMm.substring(0,4);
		var mm = curYyyyMm.substring(4,6);
		var dd = "01";
		var com_ymd = new Date(yyyy, mm-1, dd);
		var curYyyy = "";
		var curMm = "";
		 for(var i=0; i<7; i++){
				curYyyy = UniDate.getDbDateStr(UniDate.add(com_ymd, {months: + i})).substring(0,4);
        	curMm   = UniDate.getDbDateStr(UniDate.add(com_ymd, {months: + i})).substring(4,6);
        	otherorderGrid2.columns[i+3].setText(curMm +'월');

			}
    }

    function columnHeaderSet2(basicDate){
    	if(Ext.isEmpty(basicDate)){
    		return false;
    	}
    	var curYyyyMm = UniDate.getDbDateStr(basicDate).substring(0,6);
		var yyyy = curYyyyMm.substring(0,4);
		var mm = curYyyyMm.substring(4,6);
		var dd = "01";
		var com_ymd = new Date(yyyy, mm-1, dd);
		var curYyyy = "";
		var curMm = "";
		 for(var i=0; i<7; i++){
				curYyyy = UniDate.getDbDateStr(UniDate.add(com_ymd, {months: + i})).substring(0,4);
        	curMm   = UniDate.getDbDateStr(UniDate.add(com_ymd, {months: + i})).substring(4,6);
        	masterGrid2.columns[i+3].setText(curMm +'월');

			}
    }

    Unilite.Main({
		borderItems:[{
    			region:'center',
    			layout: 'border',
    			border: false,
    			items:[
    				masterGrid, masterGrid2, panelResult
    			]
    		}
		],
		id: 's_mre090ukrv_kdApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
			panelResult.setValue('PLAN_YYYYMM',UniDate.get('startOfMonth'));
			columnHeaderSet(panelResult.getValue('PLAN_YYYYMM'));
			panelResult.setValue('PLAN_ORDER', '1');
		},
		onQueryButtonDown: function()	{
			panelResult.setAllFieldsReadOnly(false);
            panelResult.setValue('GW_TEMP', '');
			var orderNo = panelResult.getValue('PRDT_REQ_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow()
			} else {
				directMasterStore1.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
				/**
				 * Detail Grid Default 값 설정
				 */
			 var poReqNum            = panelResult.getValue('PRDT_REQ_NUM');
			 var seq                 = directMasterStore1.max('PRDT_REQ_SEQ');
            	 if(!seq) seq = 1;
            	 else  seq += 1;
        	 var divCode             = panelResult.getValue('DIV_CODE');
        	 var reqDate             = panelResult.getValue('PRDT_REQ_DATE');
        	 var supplyType          = panelResult.getValue('SUPPLY_TYPE');
        	 var deliveryReqDate     = UniDate.get('today');
             var deliveryReqOriDate  = UniDate.get('today');
        	 var orderPlanYymm       = UniDate.getDbDateStr(panelResult.getValue('PRDT_REQ_DATE')).substring(0, 6);
        	 var orderPlanMm1        = UniDate.getDbDateStr(panelResult.getValue('PRDT_REQ_DATE')).substring(0, 6);
             var orderPlanMm2        = UniDate.getDbDateStr(panelResult.getValue('PRDT_REQ_DATE')).substring(0, 6);
             var domForign           = Ext.getCmp('rdoSelect').getChecked()[0].inputValue;

        	 var r = {
				PRDT_REQ_NUM:           poReqNum,
				PRDT_REQ_SEQ:           seq,
				DIV_CODE:               divCode,
				REQ_DATE:               reqDate,
				SUPPLY_TYPE:            supplyType,
				DELIVERY_REQ_DATE:      deliveryReqDate,
				DELIVERY_REQ_ORI_DATE:  deliveryReqOriDate,
				ORDER_PLAN_YYMM:        orderPlanYymm,
				ORDER_PLAN_MM1:         orderPlanMm1,
                ORDER_PLAN_MM2:         orderPlanMm2,
                DOM_FORIGN:             domForign
	        };
			masterGrid.createRow(r);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
            masterGrid2.reset();
			panelResult.clearForm();
//			panelResult.getField('PRDT_REQ_NUM').setReadOnly(true);
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			Ext.getCmp('GW').setDisabled(true);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(directMasterStore1.isDirty())	{
				directMasterStore1.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ORDER_YN') == 'Y')
				{
					alert('발주되어 삭제할수 없습니다');
				}else{
					masterGrid.deleteSelectedRow();
					if(directMasterStore1.getCount() == 0) {
					   	masterGrid2.reset();
					}
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						if(record.get('INSPEC_Q') > 1){
								alert('<t:message code="unilite.msg.sMM435"/>');
						}else{
							var deletable = true;
							if(deletable){
								masterGrid.reset();
								UniAppManager.app.onSaveDataButtonDown();
							}
							isNewData = false;
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
                masterGrid2.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRDT_REQ_DATE',new Date());
        	panelResult.setValue('MONEY_UNIT', BsaCodeInfo.gsDefaultMoney);
            panelResult.setValue('SUPPLY_TYPE', '1');
            panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
            Ext.getCmp('GW').setDisabled(true);
            Ext.getCmp('GW2').setDisabled(true);

		},
        requestApprove: function(){     //결재 요청
            var winWidth=1300;
            var winHeight=750;

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var prdtReqNum  = panelResult.getValue('PRDT_REQ_NUM');
            var spText      = 'EXEC omegaplus_kdg.UNILITE.USP_GW_S_MRE090UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + prdtReqNum + "'";
            var spCall      = encodeURIComponent(spText);

            /* frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_mre090ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('PRDT_REQ_NUM') + "&sp=" + spCall;
            frm.target   = "cardviewer";
            frm.method   = "post";
            frm.submit(); */
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_mre090ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('PRDT_REQ_NUM') + "&sp=" + spCall/* + Base64.encode()*/;
            UniBase.fnGw_Call(gwurl,frm,'GW');

        },
        requestApprove2: function(record){     // VIEW
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var prdtReqNum  = panelResult.getValue('PRDT_REQ_NUM');
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_MRE090UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + prdtReqNum + "'";
            var spCall      = encodeURIComponent(spText);

            frm.action   = groupUrl + "appr_id=" + record.data.GW_DOC + "&viewMode=docuView";
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();

        }
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PRDT_REQ_NO" : //발주순번
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
			    break;

			    case "DELIVERY_REQ_DATE" :
			        if(record.get('TERMPLAN_Q') != 0) {
                        if(newValue < record.get('DELIVERY_REQ_ORI_DATE')) {
                            alert("희망납기일은 기존희망납기일보다 작을수 없습니다.");
                            record.set('DELIVERY_REQ_DATE', oldValue);
                            break;
                        }
			        }
                break;
			}
			return rv;
		}
	});
};
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
