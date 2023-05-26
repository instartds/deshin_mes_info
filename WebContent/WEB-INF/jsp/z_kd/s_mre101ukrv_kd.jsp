<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mre101ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mre101ukrv_kd"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제조건 -->

	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" /> <!-- 품질대상여부 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위 -->
	<t:ExtComboStore items="${COMBO_GW_STATUS}" storeId="gwStatus" />  <!-- 그룹웨어결재상태 -->
	<t:ExtComboStore comboType="AU" comboCode="WB22" />             <!-- 의뢰서구분  -->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;	     //조회버튼 누르면 나오는 조회창
var mre090Window;           //생산계획참조
var itemRequestWindow;      //물품의뢰참조
var requestRegWindow;       //금형외주가공의뢰참조

var BsaCodeInfo = {
	gsAutoType:     '${gsAutoType}',
	gsDefaultMoney: '${gsDefaultMoney}'
};


var outDivCode = UserInfo.divCode;
var aa = 0;
function appMain() {

	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoOrderNum = true;
	}

	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mre101ukrv_kdService.selectList',
			update: 's_mre101ukrv_kdService.updateDetail',
			create: 's_mre101ukrv_kdService.insertDetail',
			destroy: 's_mre101ukrv_kdService.deleteDetail',
			syncAll: 's_mre101ukrv_kdService.saveAll'
		}
	});
	/**
	 * Model 정의
	 * @type
	 */
	Unilite.defineModel('s_mre101ukrv_kdModel', {
	    fields: [
            {name: 'COMP_CODE'          ,text: '법인코드'               ,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장'				    ,type: 'string'},
			{name: 'PO_REQ_NUM'			,text: '구매계획번호'			,type: 'string',allowBlank: isAutoOrderNum},
			{name: 'PO_SER_NO'			,text: '순번'					,type: 'int', allowBlank: false},
			{name: 'ITEM_CODE'			,text: '품목코드'				,type: 'string', allowBlank: true},//2020.02.27 아이템코드 필수 제거
			{name: 'ITEM_NAME'			,text: '품목명'				    ,type: 'string'},
			{name: 'SPEC'				,text: '규격'					,type: 'string'},
            {name: 'ORDER_UNIT'         ,text: '구매단위'               ,type: 'string',comboType:'AU',comboCode:'B013',displayField: 'value'},
            {name: 'ORDER_Q'            ,text: '발주요청량(구매)'       ,type: 'uniQty', allowBlank: false},
            {name: 'TRNS_RATE'          ,text: '입수'                   ,type: 'uniQty', allowBlank: false},
            {name: 'ORDER_UNIT_Q'       ,text: '발주요청량(재고)'       ,type: 'uniQty', editable: false},
            {name: 'CUSTOM_CODE'        ,text: '거래처'                 ,type: 'string', allowBlank: false},
            {name: 'CUSTOM_NAME'        ,text: '거래처명'               ,type: 'string'},
            {name: 'MONEY_UNIT'         ,text: '화폐단위'               ,type: 'string',comboType:'AU',comboCode:'B004', displayField: 'value'},
            {name: 'EXCHG_RATE_O'       ,text: '환율'                   ,type: 'uniER'},
            {name: 'UNIT_PRICE_TYPE'    ,text: '단가형태'               ,type: 'string',comboType:'AU',comboCode:'M301', allowBlank: false},
            {name: 'ORDER_P'            ,text: '단가'                   ,type: 'uniUnitPrice'},
            {name: 'ORDER_O'            ,text: '금액'                   ,type: 'uniUnitPrice'},
            {name: 'ORDER_LOC_P'        ,text: '자사단가'               ,type: 'uniPrice'},
            {name: 'ORDER_LOC_O'        ,text: '자사금액'               ,type: 'uniPrice'},
            {name: 'PO_REQ_DATE'        ,text: '발주예정일'             ,type: 'uniDate', allowBlank: false},
            {name: 'DVRY_DATE'          ,text: '납기일'                 ,type: 'uniDate', allowBlank: false},
            {name: 'DELIVERY_REQ_DATE'  ,text: '희망납기일'             ,type: 'uniDate'},
            {name: 'WH_CODE'            ,text: '납품창고'               ,type: 'string',store: Ext.data.StoreManager.lookup('whList')},
            {name: 'INSPEC_FLAG'        ,text: '품질대상여부'           ,type: 'string',comboType:'AU',comboCode:'Q002'},
            {name: 'PURCH_LDTIME'       ,text: 'LEAD TIME'              ,type: 'uniQty'},
            {name: 'TERMPLAN_Q'         ,text: '기간소요량'             ,type: 'uniQty'},
            {name: 'SAFE_STOCK_Q'       ,text: '안전재고량'             ,type: 'uniQty'},
            {name: 'PAB_STOCK_Q'        ,text: '현재고량'               ,type: 'uniQty'},
            {name: 'R_ORDER_Q'          ,text: '미입고량'               ,type: 'uniQty'},
            {name: 'REQ_DEPT_CODE'      ,text: '부서코드'               ,type: 'string'},
            {name: 'REQ_DEPT_NAME'      ,text: '부서명'                 ,type: 'string'},
            {name: 'REMARK'             ,text: '비고'                   ,type: 'string'},
            {name: 'PRDT_REQ_NUM'       ,text: '생산구매계획번호'       ,type: 'string'},
            {name: 'PRDT_REQ_SEQ'       ,text: '생산구매계획순번'       ,type: 'int'},
            {name: 'ITEM_REQ_SEQ'       ,text: '물품의뢰순번'           ,type: 'int'},
            {name: 'ITEM_REQ_NUM'       ,text: '물품의뢰번호'           ,type: 'string'},
            {name: 'ORDER_YN'           ,text: '진행상태'               ,type: 'string'},
            //{name: 'GW_FLAG'            ,text: '기안여부'               ,type: 'string'},
            {name: 'GW_FLAG'                ,text: '기안여부'                ,type: 'string', store:Ext.data.StoreManager.lookup("gwStatus")},
            {name: 'GW_DOC'             ,text: '기안문서번호'           ,type: 'string'},
            {name: 'DRAFT_NO'           ,text: 'DRAFT_NO'               ,type: 'string'},
            {name: 'STOCK_UNIT'	 		,text: '재고단위'				,type: 'string'},
			{name: 'SUPPLY_TYPE'		,text: '조달구분'				,type: 'string',comboType:'AU',comboCode:'B014'},
			{name: 'ORDER_REQ_NUM'		,text: '발주예정번호'			,type: 'string'},
			{name: 'DOM_FORIGN'		,text: '내수/수입'			,type: 'string'},
			{name: 'REF_TYPE'		,text: '참조구분'			,type: 'string'},
			{name: 'PLAN_YYYYMM'		,text: '계획년월'			,type: 'string'},//생산구매요청등록의 차수 추가
			{name: 'PLAN_ORDER'		,text: '계획차수'			,type: 'string'},//생산구매요청등록의 차수 추가
			{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'		    ,type: 'string'},
			{name: 'UPDATE_DB_TIME'	 	,text: 'UPDATE_DB_TIME'		    ,type: 'string'}
		]
	});

	Unilite.defineModel('orderNoMasterModel', {		//조회버튼 누르면 나오는 조회창(의뢰번호)
	    fields: [
	    	{name: 'PO_REQ_DATE'		    	, text: '요청일자'    	, type: 'uniDate'},
	    	{name: 'SUPPLY_TYPE'		        , text: '조달구분'		, type: 'string',comboType:'AU', comboCode:'B014'},
	    	{name: 'PO_REQ_NUM'		    		, text: '구매계획번호'  , type: 'string'},
	    	{name: 'PO_SER_NO'		    		, text: '구매계획순번'  , type: 'string'},
	    	{name: 'ITEM_CODE'		    		, text: '품목코드'  , type: 'string'},
	    	{name: 'ITEM_NAME'		    		, text: '품목명'  , type: 'string'},
	    	{name: 'CUSTOM_CODE'		    	, text: '거래처'  , type: 'string'},
	    	{name: 'CUSTOM_NAME'		    	, text: '거래처명'  , type: 'string'},
	    	{name: 'DEPT_CODE'	    			, text: '부서코드'   	, type: 'string'},
	    	{name: 'DEPT_NAME'	    			, text: '부서명'   	    , type: 'string'},
	    	{name: 'PERSON_NUMB'		    	, text: '담당자'    	, type: 'string'},
	    	{name: 'PERSON_NAME'	    		, text: '담당자명'    	, type: 'string'},
	    	{name: 'REQ_DEPT_NAME'	    		, text: '의뢰부서'    	, type: 'string'},
	    	{name: 'MONEY_UNIT'		    		, text: '화폐'    	    , type: 'string'},
	    	{name: 'EXCHG_RATE_O'	    		, text: '환율'    	    , type: 'string'},
	    	{name: 'ITEM_ACCOUNT'		    	, text: '품목계정'    	, type: 'string', comboType:'AU',comboCode:'B020'},
	    	{name: 'DIV_CODE'		    		, text: '사업장'    	, type: 'string',comboType:'BOR120'},
	    	{name: 'GW_STATUS'		    		  , text: '기안여부'  , type: 'string'}

		]
	});

	Unilite.defineModel('s_mre090ukrv_kdModel', {  //생산구매계획 참조
        fields: [
            {name: 'COMP_CODE'              ,text: '법인코드'           ,type: 'string'},
            {name: 'DIV_CODE'               ,text: '사업장'             ,type: 'string'},
            {name: 'REQ_DATE'               ,text: '요청일'             ,type: 'uniDate'},
            {name: 'ITEM_CODE'              ,text: '품목코드'           ,type: 'string'},
            {name: 'ITEM_NAME'              ,text: '품목명'             ,type: 'string'},
            {name: 'SPEC'                   ,text: '규격'               ,type: 'string'},
            {name: 'ORDER_UNIT'             ,text: '단위(구매)'         ,type: 'string'},
            {name: 'TRNS_RATE'              ,text: '입수'               ,type: 'uniQty'},
            {name: 'STOCK_UNIT'             ,text: '단위(재고)'         ,type: 'string'},
            {name: 'WH_CODE'                ,text: '창고'               ,type: 'string'},
            {name: 'PURCH_LD_TIME'          ,text: 'LEAD TIME'          ,type: 'uniQty'},
            {name: 'TERMPLAN_Q'             ,text: '기간소요량'         ,type: 'uniQty'},
            {name: 'SAFE_STOCK_Q'           ,text: '안전재고량'         ,type: 'uniQty'},
            {name: 'STOCK_Q'                ,text: '현재고량'           ,type: 'uniQty'},
            {name: 'NOIN_Q'                 ,text: '미입고량'           ,type: 'uniQty'},
            {name: 'ORDER_PLAN_Q'           ,text: '구매계획량'         ,type: 'uniQty'},
            {name: 'ING_PLAN_Q'             ,text: '진행수량'           ,type: 'uniQty'},
            {name: 'REMAIN_Q'               ,text: '잔량'               ,type: 'uniQty'},
            {name: 'DELIVERY_REQ_DATE'      ,text: '희망납기일'         ,type: 'uniDate'},
            {name: 'DELIVERY_REQ_ORI_DATE'  ,text: '납기예정일'         ,type: 'uniDate'},
            {name: 'REQ_TREE_CODE'              ,text: '요청부서코드'       ,type: 'string'},
            {name: 'REQ_TREE_NAME'              ,text: '요청부서명'         ,type: 'string'},
            {name: 'REMARK'                 ,text: '비고'               ,type: 'string'},
            {name: 'PRDT_REQ_NUM'           ,text: '계획번호'           ,type: 'string'},
            {name: 'PRDT_REQ_SEQ'           ,text: '순번'               ,type: 'int'},
            {name: 'LATEST_CUSTOM_CODE'     ,text: '최근거래처코드'     ,type: 'string'},
            {name: 'LATEST_CUSTOM_NAME'     ,text: '최근거래처명'       ,type: 'string'},
            {name: 'PLAN_YYYYMM'            ,text: '계획년월'           , type: 'string'},
            {name: 'PLAN_ORDER'             ,text: '계획차수'           , type: 'string'},
            {name: 'MONEY_UNIT'             ,text: '화폐단위'           , type: 'string'}
        ]
    });

    Unilite.defineModel('s_mre101ukrv_kdItemRequestModel', {  //품목의뢰 참조
        fields: [
            {name: 'COMP_CODE'             , text: '법인코드'             , type: 'string'},
            {name: 'DIV_CODE'              , text: '사업장'               , type: 'string'},
            {name: 'ITEM_REQ_NUM'          , text: '품목의뢰번호'         , type: 'string'},
            {name: 'ITEM_REQ_SEQ'          , text: '의뢰순번'             , type: 'int'},
            {name: 'ITEM_CODE'             , text: '품목코드'             , type: 'string'},
            {name: 'ITEM_NAME'             , text: '품목명'               , type: 'string'},
            {name: 'SPEC'                  , text: '규격'                 , type: 'string'},
            {name: 'STOCK_UNIT'            , text: '재고단위'             , type: 'string'},
            {name: 'ITEM_ACCOUNT'          , text: '품목계정'             , type: 'string',xtype:'uniCombobox', comboType:'AU', comboCode:'B020'},
            {name: 'TRNS_RATE'             , text: '입수'                 , type: 'uniQty'},
            {name: 'ORDER_UNIT'            , text: '구매단위'             , type: 'string'},
            {name: 'REQ_Q'                 , text: '의뢰량'               , type: 'uniQty'},
            {name: 'ING_PLAN_Q'            , text: '진행수량'             , type: 'uniQty'},
            {name: 'REMAIN_Q'              , text: '잔량'                 , type: 'uniQty'},
            {name: 'DEPT_CODE'             , text: '부서'                 , type: 'string'},
            {name: 'DEPT_NAME'             , text: '요청부서명'           , type: 'string'},
            {name: 'PERSON_NUMB'           , text: '사원'                 , type: 'string'},
            {name: 'ITEM_REQ_DATE'         , text: '의뢰일'               , type: 'uniDate'},
            {name: 'MONEY_UNIT'            , text: '화폐단위'             , type: 'string'},
            {name: 'EXCHG_RATE_O'          , text: '환율'                 , type: 'uniER'},
            {name: 'DELIVERY_DATE'         , text: '납기일'               , type: 'uniDate'},
            {name: 'USE_REMARK'            , text: '용도'                 , type: 'string'},
            {name: 'GW_DOCU_NUM'           , text: 'GW문서번호'           , type: 'string'},
            {name: 'GW_FLAG'               , text: 'GW기안상태'           , type: 'string'},
            {name: 'NEXT_YN'               , text: '진행상태'             , type: 'string'},
            {name: 'LATEST_CUSTOM_CODE'    , text: '최근거래처코드'          ,type: 'string'},
            {name: 'LATEST_CUSTOM_NAME'    , text: '최근거래처명'           ,type: 'string'},
            {name: 'P_REQ_TYPE'            , text: '의뢰서구분'            , type: 'string',comboType:'AU', comboCode:'WB22'}
        ]
    });

    Unilite.defineModel('s_mre101ukrv_kdRequestRegModel', {  //금형외주가공의뢰참조
        fields: [
            {name: 'COMP_CODE'             , text: '법인코드'             , type: 'string'},
            {name: 'DIV_CODE'              , text: '사업장'               , type: 'string'},
            {name: 'ITEM_REQ_NUM'          , text: '품목의뢰번호'         , type: 'string'},
            {name: 'ITEM_REQ_SEQ'          , text: '의뢰순번'             , type: 'int'},
            {name: 'ITEM_CODE'             , text: '품목코드'             , type: 'string'},
            {name: 'ITEM_NAME'             , text: '품목명'               , type: 'string'},
            {name: 'SPEC'                  , text: '규격'                 , type: 'string'},
            {name: 'STOCK_UNIT'            , text: '재고단위'             , type: 'string'},
            {name: 'ITEM_ACCOUNT'          , text: '품목계정'             , type: 'string',xtype:'uniCombobox', comboType:'AU', comboCode:'B020'},
            {name: 'GARO_NUM'              ,text:'가로'                 		,type: 'int'},
            {name: 'GARO_NUM_UNIT'         ,text:'단위'                 		,type: 'string',editable:false},
            {name: 'SERO_NUM'              ,text:'세로'                 		,type: 'int'},
            {name: 'SERO_NUM_UNIT'         ,text:'단위'                 		,type: 'string',editable:false},
            {name: 'THICK_NUM'             ,text:'두께'                 		,type: 'int'},
            {name: 'THICK_NUM_UNIT'        ,text:'단위'                 		,type: 'string',editable:false},
            {name: 'BJ_NUM'                ,text:'비중'                 		,type: 'int',editable:false},
            {name: 'CAL_QTY'               ,text:'환산수량'                  ,type: 'uniQty',editable:false},
            {name: 'PURCHASE_P'            ,text:'구매단가'                  ,type: 'uniUnitPrice',editable:false},
            {name: 'TRNS_RATE'             , text: '입수'                 , type: 'uniQty'},
            {name: 'ORDER_UNIT'            , text: '구매단위'             , type: 'string'},
            {name: 'REQ_Q'                 , text: '의뢰량'               , type: 'uniQty'},
            {name: 'ING_PLAN_Q'            , text: '진행수량'             , type: 'uniQty'},
            {name: 'REMAIN_Q'              , text: '잔량'                 , type: 'uniQty'},
            {name: 'DEPT_CODE'             , text: '부서'                 , type: 'string'},
            {name: 'DEPT_NAME'             , text: '요청부서명'           , type: 'string'},
            {name: 'PERSON_NUMB'           , text: '사원'                 , type: 'string'},
            {name: 'ITEM_REQ_DATE'         , text: '의뢰일'               , type: 'uniDate'},
            {name: 'MONEY_UNIT'            , text: '화폐단위'             , type: 'string'},
            {name: 'EXCHG_RATE_O'          , text: '환율'                 , type: 'uniER'},
            {name: 'DELIVERY_DATE'         , text: '납기일'               , type: 'uniDate'},
            {name: 'USE_REMARK'            , text: '용도'                 , type: 'string'},
            {name: 'GW_DOCU_NUM'           , text: 'GW문서번호'           , type: 'string'},
            {name: 'GW_FLAG'               , text: 'GW기안상태'           , type: 'string'},
            {name: 'NEXT_YN'               , text: '진행상태'             , type: 'string'},
            {name: 'LATEST_CUSTOM_CODE'    , text: '최근거래처코드'          ,type: 'string'},
            {name: 'LATEST_CUSTOM_NAME'    , text: '최근거래처명'           ,type: 'string'},
            {name: 'MAKE_GUBUN'            , text: '가공구분'             , type: 'string',comboType:'AU', comboCode:'WZ21'},
            {name: 'HM_CODE'               , text:'항목(부품)명'           ,type: 'string', comboType:'AU', comboCode:'WZ22',allowBlank:false},
            {name: 'MOLD_ITEM_NAME'        , text: '금형품명'            ,type: 'string'},
            {name: 'CUSTOM_CODE'    	   , text: '거래처코드'           ,type: 'string'},
            {name: 'CUSTOM_NAME'    	   , text: '거래처명'            ,type: 'string'},
            {name: 'PRICE'              ,text:'단가'                 		,type: 'uniUnitPrice',editable:false},
            {name: 'AMT'            	,text:'금액'                 		,type: 'uniPrice',editable:false},
            {name: 'MONEY_UNIT'             ,text: '화폐단위'           , type: 'string'}
        ]
    });

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_mre101ukrv_kdMasterStore1',{
		model: 's_mre101ukrv_kdModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
           	editable: true,			// 수정 모드 사용
           	deletable: true,			// 삭제 가능 여부
           	allDeletable: true,
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
		proxy: directProxy,
//		listeners: {
//           	load: function(store, records, successful, eOpts) {
//           		this.fnSumOrderO();
//           	},
//           	add: function(store, records, index, eOpts) {
//           		this.fnSumOrderO();
//           	},
//           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
//           		this.fnSumOrderO();
//           	},
//           	remove: function(store, record, index, isMove, eOpts) {
//           		this.fnSumOrderO();
//           	}
//		},
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
						}else if(masterGrid.getStore().getCount() != 0){
							UniBase.fnGwBtnControl('GW',directMasterStore1.data.items[0].data.GW_FLAG);
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
						panelResult.setValue("PO_REQ_NUM", master.PO_REQ_NUM);
						panelResult.setValue("PO_REQ_NUM", master.PO_REQ_NUM);
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						 Ext.getCmp('GW').setDisabled(false);//기안버튼 저장 후 활성화
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if(directMasterStore1.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        }
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_mre101ukrv_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnSumOrderO: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sSumOrderO = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
			var sSumOrderLocO = Ext.isNumeric(this.sum('ORDER_LOC_O')) ? this.sum('ORDER_LOC_O'):0;
			//panelResult.setValue('SumOrderO',sSumOrderO);
			//panelResult.setValue('SumOrderLocO',sSumOrderLocO);
		},
        listeners:{
            load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					panelResult.setValue('DOM_FORIGN',records[0].data['DOM_FORIGN']);
				}
            }
        }
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	//조회버튼 누르면 나오는 조회창(의뢰번호)
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
				read    : 's_mre101ukrv_kdService.selectOrderNumMasterList'
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

	var mre090Store = Unilite.createStore('mre090ukrvStore', {   //물품의뢰 참조
        model: 's_mre090ukrv_kdModel',
        autoLoad: false,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false             // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_mre101ukrv_kdService.selectMre090List'
            }
        },
        loadStoreRecords : function()   {
            var param= mre090Search.getValues();
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners:{
            load:function(store, records, successful, eOpts)    {
                if(successful)  {
                   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
                   var deleteRecords = new Array();

                   if(masterRecords.items.length > 0)   {
                    console.log("store.items :", store.items);
                    console.log("records", records);
                        Ext.each(records,
                        function(item, i)   {
                            Ext.each(masterRecords.items, function(record, i)   {
                                    console.log("record :", record);
                                if( (record.data['PRDT_REQ_NUM'] == item.data['PRDT_REQ_NUM']) // record = masterRecord   item = 참조 Record
                                    && (record.data['PRDT_REQ_SEQ'] == item.data['PRDT_REQ_SEQ'])
                                    )
                                {
                                    deleteRecords.push(item);
                                }
                            });
                        });
                       store.remove(deleteRecords);
                   }
                }
            }
        }
    });

    var itemRequestStore = Unilite.createStore('s_mre101ukrv_kdOutsidePlStore', {   //물품의뢰 참조
        model: 's_mre101ukrv_kdItemRequestModel',
        autoLoad: false,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false             // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_mre101ukrv_kdService.selectItemRequestList'
            }
        },
        loadStoreRecords : function()   {
            var param= itemRequestSearch.getValues();
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners:{
            load:function(store, records, successful, eOpts)    {
                if(successful)  {
                   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
                   var deleteRecords = new Array();

                   if(masterRecords.items.length > 0)   {
                    console.log("store.items :", store.items);
                    console.log("records", records);

                       Ext.each(records,
                            function(item, i)   {
                                Ext.each(masterRecords.items, function(record, i)   {
                                        console.log("record :", record);
                                    if( (record.data['ITEM_REQ_NUM'] == item.data['ITEM_REQ_NUM']) // record = masterRecord   item = 참조 Record
                                        && (record.data['ITEM_REQ_SEQ'] == item.data['ITEM_REQ_SEQ'])
                                        )
                                    {
                                        deleteRecords.push(item);
                                    }
                                });
                            });
                       store.remove(deleteRecords);
                   }
                }
            }
        }
    });


    var requestRegStore = Unilite.createStore('s_mre101ukrv_kdOutsidePlStore', {   //의뢰서 등록 참조
        model: 's_mre101ukrv_kdRequestRegModel',
        autoLoad: false,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false             // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_mre101ukrv_kdService.selectRequestRegList'
            }
        },
        loadStoreRecords : function()   {
            var param= requestRegSearch.getValues();
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners:{
            load:function(store, records, successful, eOpts)    {
                if(successful)  {
                   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
                   var deleteRecords = new Array();

                   if(masterRecords.items.length > 0)   {
                    console.log("store.items :", store.items);
                    console.log("records", records);

                       Ext.each(records,
                            function(item, i)   {
                                Ext.each(masterRecords.items, function(record, i)   {
                                        console.log("record :", record);
                                    if( (record.data['ITEM_REQ_NUM'] == item.data['ITEM_REQ_NUM']) // record = masterRecord   item = 참조 Record
                                        && (record.data['ITEM_REQ_SEQ'] == item.data['ITEM_REQ_SEQ'])
                                        )
                                    {
                                        deleteRecords.push(item);
                                    }
                                });
                            });
                       store.remove(deleteRecords);
                   }
                }
            }
        }
    });

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
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
			value: UserInfo.divCode
		},
        {
            fieldLabel:'구매계획번호',
            name: 'PO_REQ_NUM',
            id: 'PO_REQ_NUM',
            xtype: 'uniTextfield',
            holdable: 'hold',
            readOnly: true
        },
		{
	 		fieldLabel: '요청일자',
	 		xtype: 'uniDatefield',
	 		name: 'PO_REQ_DATE',
	 		value: UniDate.get('today'),
	 		allowBlank:false,
	 		holdable: 'hold'
		},
        {
          xtype: 'component'
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
            autoPopup:true,
            allowBlank:false,
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
            fieldLabel: '화폐',
            name:'MONEY_UNIT',
            fieldStyle: 'text-align: center;',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B004',
            displayField: 'value',
            allowBlank:true,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
//                    UniAppManager.app.fnExchngRateO();
                },
                blur: function( field, The, eOpts )    {
                   UniAppManager.app.fnExchngRateO();
                }
            }
        },
        {
          xtype: 'component'
        },
        {
            fieldLabel: '조달구분',
            name: 'SUPPLY_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B014',
            allowBlank:false,
            holdable: 'hold'
        },
        {
            fieldLabel: '품목계정',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020',
            allowBlank:true,
            readOnly: false,
            holdable: 'hold'
        },
        {
            fieldLabel:'환율',
            name: 'EXCHG_RATE_O',
            xtype: 'uniNumberfield',
            allowBlank:true,
            decimalPrecision: 4,
            value: 1,
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
			startFieldName: 'PO_REQ_DATE_FR',
			endFieldName: 'PO_REQ_DATE_TO',
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
			comboCode: 'B014'
		},
		{
			fieldLabel: '품목계정',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020'
		},
		Unilite.popup('Employee',{
			fieldLabel: '사원',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'PERSON_NAME',
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					//panelResult.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					//panelResult.setValue('PERSON_NAME', newValue);
				}
			}
		}),{
			fieldLabel	: '구매계획번호',
			name		: 'PO_REQ_NUM',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
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

    var mre090Search = Unilite.createSearchForm('mre090SearchForm',{
        layout : {type : 'uniTable', columns : 3},
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },
        {
            fieldLabel:'생산구매계획번호',
            name: 'PO_REQ_NUM',
            xtype: 'uniTextfield',
            labelWidth: 100
        },
        {
            fieldLabel: '요청일',
            xtype: 'uniDateRangefield',
            startFieldName: 'PO_REQ_DATE_FR',
            endFieldName: 'PO_REQ_DATE_TO',
            allowBlank: false,
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
        },
        {
            fieldLabel: '조달구분',
            name: 'SUPPLY_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B014',
            readOnly: true,
            allowBlank:false
        },
        {
            fieldLabel: '품목계정',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            labelWidth: 100,
            comboCode: 'B020',
            readOnly: false,
            holdable: 'hold'
        },{
            xtype: 'radiogroup',
            fieldLabel: '내수/수입',
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

    var itemRequestSearch = Unilite.createSearchForm('itemRequestForm', {     //품품의뢰 참조
        layout: {type : 'uniTable', columns : 3},
        items :[{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },
        Unilite.popup('DEPT', {
			fieldLabel: '부서',
			labelWidth: 100,
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
        {
            fieldLabel: '요청일',
            xtype: 'uniDateRangefield',
            startFieldName: 'ITEM_REQ_DATE_FR',
            endFieldName: 'ITEM_REQ_DATE_TO',
            allowBlank: false,
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
        },
        {
            fieldLabel: '조달구분',
            name: 'SUPPLY_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B014',
            readOnly: true,
            allowBlank:false
        },
        {
            fieldLabel: '품목계정',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            labelWidth: 100,
            comboCode: 'B020',
            readOnly: false,
            holdable: 'hold'
        },{
            fieldLabel: '의뢰서구분',
            name:'P_REQ_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WB22',
            holdable: 'hold',
            multiSelect: true,
        }
/*         ,{
            xtype: 'radiogroup',
            fieldLabel: '내수/수입',
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
        } */
        ],
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


    var requestRegSearch = Unilite.createSearchForm('requestRegForm', {     //금형외주가공의뢰참조
        layout: {type : 'uniTable', columns : 3},
        items :[{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },
        Unilite.popup('DEPT', {
			fieldLabel: '부서',
		//	labelWidth: 100,
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
        {
            fieldLabel: '요청일',
            xtype: 'uniDateRangefield',
            startFieldName: 'ITEM_REQ_DATE_FR',
            endFieldName: 'ITEM_REQ_DATE_TO',
            allowBlank: false,
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
        },
        Unilite.popup('AGENT_CUST', {
            fieldLabel:'거래처',
            autoPopup: true,
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME'
        }),{
            fieldLabel: '가공구분',
            name:'MAKE_GUBUN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WZ21'
        } ,
        {
            fieldLabel: '품목계정',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020',
            readOnly: false,
            holdable: 'hold'
        },{
            fieldLabel: '금형품명',
            name:'ITEM_NAME',
            xtype: 'uniTextfield',
            width: 312
        }
        ],
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
    var masterGrid= Unilite.createGrid('s_mre101ukrv_kdGrid', {
    	region: 'center' ,
        layout: 'fit',
        excelTitle: '구매요청등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
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
                    param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('PO_REQ_NUM');
                    if(confirm('기안 하시겠습니까?')) {
                        s_mre101ukrv_kdService.selectGwData(param, function(provider, response) {
                            if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                                panelResult.setValue('GW_TEMP', '기안중');
                                s_mre101ukrv_kdService.makeDraftNum(param, function(provider2, response)   {
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
                itemId: 'refBtn',
                text: '<div style="color: blue">생산계획 참조</div>',
                handler: function() {
                    openMre090Window();
                }
            },{
                itemId: 'plRefBtn3',
                text: '<div style="color: blue">구매요청 참조</div>',
                handler: function() {
                    openItemRequestWindow();
                }
            },{
                itemId: 'plRefBtn4',
                text: '<div style="color: blue">금형의뢰 참조</div>',
                handler: function() {
                	openRequestRegWindow();
                }
            }],
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
        columns: [
        	{dataIndex:'COMP_CODE'          				   , width: 100, hidden: true},
            {dataIndex:'DIV_CODE'			                   , width: 100, hidden: true},
            {dataIndex:'PO_REQ_NUM'			                   , width: 100, hidden: true},
            {dataIndex:'PO_SER_NO'			                   , width: 70},
            {dataIndex: 'ITEM_CODE'                            , width: 110,
                    editor: Unilite.popup('DIV_PUMOK_G', {
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
                        autoPopup: true,
                        listeners: {'onSelected': {
                               /*  fn: function(records, type) {
                                    console.log('records : ', records);
                                    Ext.each(records, function(record,i) {
                                        console.log('record',record);
                                        if(i==0) {

                                        	var curRecord = masterGrid.uniOpt.currentRecord;
                                        	var oriOrderP = curRecord.get('ORDER_P'); //2020.02.27 기존 계획단가 변경전 변수에 세팅
                                        	var oriItemCode = curRecord.get('ITEM_CODE');//2020.02.27 기존 거래처 변경전 변수에 세팅
                                        	if(!Ext.isEmpty(oriItemCode)){
                                        		oriItemCode = '';
                                        	}
                                        	var isErr = false;
                                        	if(curRecord.get('GW_FLAG') == '1' || curRecord.get('GW_FLAG') == '3'){//2020.02.27 기안완료이거나 기안중일 경우
                                        		var param = {
                                   					 "ITEM_CODE": record['ITEM_CODE'],
                                   					 "CUSTOM_CODE": record['MAIN_CUSTOM_CODE'],
                                   					 "DIV_CODE": panelResult.getValue('DIV_CODE'),
                                   					 "MONEY_UNIT": panelResult.getValue('MONEY_UNIT'),
                                   					 "ORDER_UNIT": record['ORDER_UNIT'],
                                   					 "ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
                                   					 "PO_REQ_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
                                   					 "AC_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'))
                                   			    };
                                        		s_mre101ukrv_kdService.fnOrderPrice2(param, function(provider, response)	{
						        					if(!Ext.isEmpty(provider)){
						        						if( provider['ORDER_P'] != oriOrderP && oriOrderP != 0 ){
						        							isErr = true;
						        							Unilite.messageBox('<t:message code="system.message.purchase.message106" default="단가등록부터 진행해주세요."/>');
						        							curRecord.set('ITEM_CODE',oriItemCode);
						        							curRecord.commit();
						        							UniAppManager.setToolbarButtons(['save'], false);
						        							return false;
						        						}else{

						        							masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
						        						}
						                            }else{

						                            	masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
						                            }
						        				});
                                        	}else{
                                        		masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                        	}

                                       		if (isErr == true){
												return false;
											}

                                        } else {

                                        	UniAppManager.app.onNewDataButtonDown();
                                            masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                        }
                                    });
                                }, 2020.06.02 체크로직 제거*/
                                fn: function(records, type) {
                                    console.log('records : ', records);
                                    Ext.each(records, function(record,i) {
                                        console.log('record',record);
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
                                popup.setExtParam({'SUPPLY_TYPE':               panelResult.getValue('SUPPLY_TYPE')});
//                                popup.setExtParam({'DOM_FORIGN':                Ext.getCmp('rdoSelect').getChecked()[0].inputValue});
                                popup.setExtParam({'SUPPLY_TYPE_READONLY':      'supplyReadOnly'});
                            }
                        }
                })
            },
            {dataIndex:'ITEM_NAME'			                   , width: 200,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
			 	}
            },
            {dataIndex:'SPEC'				                   , width: 150},
            {dataIndex:'ORDER_UNIT'                            , width: 100, align: 'center'},
            {dataIndex:'ORDER_Q'                               , width: 125, summaryType: 'sum'},
            {dataIndex:'TRNS_RATE'                             , width: 100},
            {dataIndex:'ORDER_UNIT_Q'                          , width: 125, hidden: true},
            {dataIndex: 'CUSTOM_CODE'                          , width: 90,
                'editor' : Unilite.popup('CUST_G',{
                    textFieldName:'CUSTOM_CODE',
                    DBtextFieldName:'CUSTOM_CODE',
                    autoPopup: true,
                    listeners: {
                        'onSelected':  function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            var record = masterGrid.getSelectedRecord();
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('MONEY_UNIT',records[0]['MONEY_UNIT']);
                            var param = {
                            	"ITEM_CODE": record.data.ITEM_CODE,
                                "CUSTOM_CODE": records[0]['CUSTOM_CODE'],
                                "DIV_CODE": panelResult.getValue('DIV_CODE'),
                                "MONEY_UNIT": records[0]['MONEY_UNIT'],
                                "ORDER_UNIT": record.data.ORDER_UNIT,
                                "ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
                                "PO_REQ_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
                                "AC_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'))
                            };
                            s_mre101ukrv_kdService.fnExchgRateO(param, function(provider, response)  {

	                            	if(!Ext.isEmpty(provider)){

	                            		if(provider[0]['BASE_EXCHG'] == 0){
	                            			grdRecord.set('EXCHG_RATE_O',1);
	                            		}else{
	                            			grdRecord.set('EXCHG_RATE_O',provider[0]['BASE_EXCHG']);
	                            		}

	                            		 grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * grdRecord.get('ORDER_P') * provider[0]['BASE_EXCHG']);
	                            		 grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * grdRecord.get('ORDER_P') * provider[0]['BASE_EXCHG']);
				                            s_mre101ukrv_kdService.fnMinimumChk(param, function(provider, response)  {

				                            		   s_mre101ukrv_kdService.fnOrderPrice2(param, function(provider, response)  {

				                                           if(!Ext.isEmpty(provider)){
				                                               grdRecord.set('ORDER_P', provider['ORDER_P']);
				                                               grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P'] );
				                                               grdRecord.set('ORDER_LOC_P', provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O'));
				                                               grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O'));
			                                            	   grdRecord.set('UNIT_PRICE_TYPE', 'Y');

				                                           } else {
				                                               grdRecord.set('ORDER_P', 0);
				                                               grdRecord.set('ORDER_O', 0);
				                                               grdRecord.set('ORDER_LOC_P', 0);
				                                               grdRecord.set('ORDER_LOC_O', 0);
				                                           }

				                                       });

				                            });
	                            	 }

	                            });
	                        },
                        'onClear':  function( type  ){
                        	var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_NAME','');
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('ORDER_P','');
                            grdRecord.set('UNIT_PRICE_TYPE','');
                        }
                    }
                })
            },
            {dataIndex:'CUSTOM_NAME'                           , width: 150},
            {dataIndex:'UNIT_PRICE_TYPE'                       , width: 100},
            {dataIndex:'ORDER_P'                               , width: 100},
            {dataIndex:'ORDER_O'                               , width: 100, summaryType: 'sum'},
            {dataIndex:'MONEY_UNIT'                            , width: 70, hidden: false, align: 'center'},
            {dataIndex:'EXCHG_RATE_O'                          , width: 100, hidden: false},
            {dataIndex:'ORDER_LOC_P'                           , width: 100, hidden: false},
            {dataIndex:'ORDER_LOC_O'                           , width: 100, hidden: false, summaryType: 'sum'},
            {dataIndex:'PO_REQ_DATE'                           , width: 100},
            {dataIndex:'DVRY_DATE'                             , width: 100},
            {dataIndex:'DELIVERY_REQ_DATE'                     , width: 100},
            {dataIndex:'WH_CODE'                               , width: 120,
                listeners: {
                    'onSelected':  function(records, type  ) {
                        var grdRecord = masterGrid.uniOpt.currentRecord;
                        var record = masterGrid.getSelectedRecord();
                        if(Ext.isEmpty(record.data.WH_CODE)) {
                            var param = {
                                "ITEM_CODE": record.data.ITEM_CODE,
                                "WH_CODE": 'KGM1'
                            };
                        } else {
                            var param = {
                            	"ITEM_CODE": record.data.ITEM_CODE,
                                "WH_CODE": record.data.WH_CODE
                            };
                        }
                        s_mre101ukrv_kdService.fnStockQ(param, function(provider, response)  {
                            if(!Ext.isEmpty(provider)){
                                grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                            }
                        });
                    },
                    'onClear':  function( type  ){
                        var grdRecord = masterGrid.uniOpt.currentRecord;
                        grdRecord.set('WH_CODE','');
                        grdRecord.set('PAB_STOCK_Q','');
                    }
                }
            },
            {dataIndex:'INSPEC_FLAG'                           , width: 100},
            {dataIndex:'PURCH_LDTIME'                          , width: 100},
            {dataIndex:'TERMPLAN_Q'                            , width: 100},
            {dataIndex:'SAFE_STOCK_Q'                          , width: 100},
            {dataIndex:'PAB_STOCK_Q'                           , width: 100},
            {dataIndex:'R_ORDER_Q'                             , width: 100},
            {dataIndex:'REQ_DEPT_CODE'                         , width: 100,
            	editor: Unilite.popup('DEPT_G',{
            		//		  			textFieldName: 'TREE_NAME',
            		 	 				DBtextFieldName: 'TREE_NAME',
            							autoPopup:true,
            							listeners: {'onSelected': {
            								fn: function(records, type) {
            										var rtnRecord = masterGrid.uniOpt.currentRecord;
            										rtnRecord.set('REQ_DEPT_CODE', records[0]['TREE_CODE']);
            										rtnRecord.set('REQ_DEPT_NAME', records[0]['TREE_NAME']);
            									},
            								scope: this
            								},
            								'onClear': function(type) {
            									var rtnRecord = masterGrid.uniOpt.currentRecord;
            										rtnRecord.set('REQ_DEPT_CODE', '');
            										rtnRecord.set('REQ_DEPT_NAME', '');
            								},
            								applyextparam: function(popup){

            								}
            							}
            				})

            },
            {dataIndex:'REQ_DEPT_NAME'                         , width: 200,
            	editor: Unilite.popup('DEPT_G',{
            		//		  			textFieldName: 'TREE_NAME',
            		 	 				DBtextFieldName: 'TREE_NAME',
            							autoPopup:true,
            							listeners: {'onSelected': {
            								fn: function(records, type) {
            										var rtnRecord = masterGrid.uniOpt.currentRecord;
            										rtnRecord.set('REQ_DEPT_CODE', records[0]['TREE_CODE']);
            										rtnRecord.set('REQ_DEPT_NAME', records[0]['TREE_NAME']);
            									},
            								scope: this
            								},
            								'onClear': function(type) {
            									var rtnRecord = masterGrid.uniOpt.currentRecord;
            										rtnRecord.set('REQ_DEPT_CODE', '');
            										rtnRecord.set('REQ_DEPT_NAME', '');
            								},
            								applyextparam: function(popup){

            								}
            							}
            				})

            },
            {dataIndex:'REMARK'                                , width: 100},
            {dataIndex:'PRDT_REQ_NUM'                          , width: 120},
            {dataIndex:'PRDT_REQ_SEQ'                          , width: 120},
            {dataIndex:'ITEM_REQ_SEQ'                          , width: 100},
            {dataIndex:'ITEM_REQ_NUM'                          , width: 100},
            {dataIndex:'ORDER_YN'                              , width: 100, hidden: true},
            {dataIndex:'GW_FLAG'                               , width: 100},
            {dataIndex:'GW_DOC'                                , width: 100},
            {dataIndex:'DRAFT_NO'                              , width: 100},
            {dataIndex:'STOCK_UNIT'	 		                   , width: 100, hidden: true},
            {dataIndex:'SUPPLY_TYPE'		                   , width: 100, hidden: true},
            {dataIndex:'ORDER_REQ_NUM'		                   , width: 100, hidden: true},
            {dataIndex:'UPDATE_DB_USER'		                   , width: 100, hidden: true},
            {dataIndex:'UPDATE_DB_TIME'	 	                   , width: 100, hidden: true},
            {dataIndex:'DOM_FORIGN'	 	                   , width: 100, hidden: true},
            {dataIndex:'REF_TYPE'	 	                   , width: 80, hidden: true},
            {dataIndex:'PLAN_YYYYMM'	 	               , width: 80, hidden: true},
            {dataIndex:'PLAN_ORDER'	 	                   , width: 80, hidden: true}
        ],
        listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.ORDER_YN == 'Y' || panelResult.getValue('GW_TEMP') == '기안중' || e.record.data.GW_FLAG == '3'){
					if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','SPEC','ORDER_TYPE','CUSTOM_CODE'])) {
	                    return true;
	                }
					return false;
				}
				if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ORDER_Q', 'TRNS_RATE', 'CUSTOM_CODE', 'UNIT_PRICE_TYPE',
				                              'ORDER_P', 'PO_REQ_DATE', 'DVRY_DATE', 'WH_CODE', 'INSPEC_FLAG', 'REMARK','ORDER_UNIT','MONEY_UNIT'
				                              //2020.03.24 품목명, SPEC, 부서코드 입력 가능하도록 수정
				                              ,'ITEM_NAME','SPEC','REQ_DEPT_CODE','REQ_DEPT_NAME'])) {
                    return true;
                } else {
                	return false;
                }
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
       			grdRecord.set('ITEM_CODE'			,"");
       			grdRecord.set('ITEM_NAME'			,"");
				grdRecord.set('ITEM_ACCOUNT'		,"");
				grdRecord.set('SPEC'				,"");
				grdRecord.set('ORDER_UNIT'			,"");
				grdRecord.set('STOCK_UNIT'			,"");
				grdRecord.set('TRNS_RATE'			,'1');
				grdRecord.set('ORDER_P'				,0);
				grdRecord.set('DVRY_DATE'			,UniDate.get('today'));
				grdRecord.set('INSPEC_FLAG'			,"");
				grdRecord.set('ORDER_P'		        ,0);
                grdRecord.set('WH_CODE'             ,"");
                grdRecord.set('CUSTOM_CODE'         ,"");
                grdRecord.set('CUSTOM_NAME'         ,"");
       		} else {

       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
				grdRecord.set('ORDER_P'				, record['BASIS_P']);
				grdRecord.set('DVRY_DATE'			, UniDate.add((panelResult.getValue('PO_REQ_DATE')), {days: + record['PURCH_LDTIME']}));
                grdRecord.set('INSPEC_FLAG'         , record['INSPEC_YN']);
                grdRecord.set('WH_CODE'             , record['WH_CODE']);
                grdRecord.set('CUSTOM_CODE'         , record['MAIN_CUSTOM_CODE']);
                grdRecord.set('CUSTOM_NAME'         , record['MAIN_CUSTOM_NAME']);
                grdRecord.set('PURCH_LDTIME'        , record['PURCH_LDTIME']);

				var param = {
					 "ITEM_CODE": record['ITEM_CODE'],
					 "CUSTOM_CODE": record['MAIN_CUSTOM_CODE'],
					 "DIV_CODE": panelResult.getValue('DIV_CODE'),
					 "MONEY_UNIT": panelResult.getValue('MONEY_UNIT'),
					 "ORDER_UNIT": record['ORDER_UNIT'],
					 "ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
					 "PO_REQ_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
					 "AC_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'))
			    };

				 s_mre101ukrv_kdService.fnCustomMoneyUnit(param, function(provider, response)  {

					 if(!Ext.isEmpty(provider)){
						 grdRecord.set('MONEY_UNIT', provider[0]['MONEY_UNIT']);
						 param.DIV_CODE =  panelResult.getValue('DIV_CODE');
						 param.MONEY_UNIT = provider[0]['MONEY_UNIT'];
						 param.AC_DATE =  UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'));
						 param.PO_REQ_DATE = UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'));
						 param.CUSTOM_CODE = record['MAIN_CUSTOM_CODE'];
						 param.ORDER_UNIT =  record['ORDER_UNIT'];
							 s_mre101ukrv_kdService.fnExchgRateO(param, function(provider, response)  {
								 	if(!Ext.isEmpty(provider)){
								 		 if(provider[0]['BASE_EXCHG'] == 0){
	                                            grdRecord.set('EXCHG_RATE_O',1);
	                                        }else{
	                                            grdRecord.set('EXCHG_RATE_O',provider[0]['BASE_EXCHG']);
	                                      }
	                            		 grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * grdRecord.get('ORDER_P') * provider[0]['BASE_EXCHG']);
	                            		 grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * grdRecord.get('ORDER_P') * provider[0]['BASE_EXCHG']);
											 s_mre101ukrv_kdService.fnMinimumChk(param, function(provider, response)  {
										                 	if(!Ext.isEmpty(provider)){
										                 		s_mre101ukrv_kdService.fnOrderPrice(param, function(provider, response)	{
										        					if(!Ext.isEmpty(provider)){
										        						grdRecord.set('ORDER_P', provider['ORDER_P']);
										        						grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P'] );
										        						grdRecord.set('ORDER_LOC_P', provider['ORDER_P']);
										        						grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O'));
										                               	grdRecord.set('UNIT_PRICE_TYPE','Y');

										        						//UniAppManager.app.fnCalOrderAmt(grdRecord, "O", provider['ORDER_P']);
										        					} else {
										                                grdRecord.set('ORDER_P', 0);
										                                grdRecord.set('ORDER_O', 0);
										                                grdRecord.set('ORDER_LOC_P', 0);
										                                grdRecord.set('ORDER_LOC_O', 0);
										                            }
										        				});
										                 	}
							                 });
								 	}
						 });
					 }
				 });
				//현재고 : 납품창고 지정후
                var param = {"ITEM_CODE": record['ITEM_CODE'],
                              "WH_CODE": record['WH_CODE']
                            };
                s_mre101ukrv_kdService.fnStockQ(param, function(provider, response)  {
                    if(!Ext.isEmpty(provider)){
                        grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                    }
                });

                var param2 = {
                    "DIV_CODE":          panelResult.getValue('DIV_CODE'),
                    "ITEM_CODE":         record['ITEM_CODE'],
                    "PO_REQ_DATE":       UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')).substring(0, 6)
                };
                s_mre101ukrv_kdService.fnNointQ(param2, function(provider, response)  {
                    if(!Ext.isEmpty(provider)){
                        grdRecord.set('R_ORDER_Q'             , provider['NOIN_Q'] * grdRecord.get('TRNS_RATE'));
                    }
                });

				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       		}
		},
        setMre090Data:function(record) {
            var grdRecord = this.getSelectedRecord();
            var customCode = '';
            grdRecord.set('DIV_CODE'                   , record['DIV_CODE']);
            grdRecord.set('PO_REQ_NUM'                 , panelResult.getValue('PO_REQ_NUM'));
            grdRecord.set('PRDT_REQ_NUM'               , record['PRDT_REQ_NUM']);
            grdRecord.set('PRDT_REQ_SEQ'               , record['PRDT_REQ_SEQ']);
            grdRecord.set('ITEM_CODE'                  , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'                  , record['ITEM_NAME']);
            grdRecord.set('SPEC'                       , record['SPEC']);
            grdRecord.set('STOCK_UNIT'                 , record['STOCK_UNIT']);
            grdRecord.set('WH_CODE'                    , record['WH_CODE']);
            grdRecord.set('R_ORDER_Q'                  , record['NOIN_Q']);
            //현재고 : 납품창고 지정후
            var param = {"ITEM_CODE": record['ITEM_CODE'],
                          "WH_CODE": record['WH_CODE']
                        };
            s_mre101ukrv_kdService.fnStockQ(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                }
            });
            grdRecord.set('ORDER_UNIT_Q'               , record['ORDER_PLAN_Q']);
            grdRecord.set('ORDER_UNIT'                 , record['ORDER_UNIT']);
            grdRecord.set('TRNS_RATE'                  , record['TRNS_RATE']);
//            grdRecord.set('ORDER_Q'                    , record['ORDER_PLAN_Q']);
            grdRecord.set('ORDER_Q'                    , record['REMAIN_Q']);
//            grdRecord.set('MONEY_UNIT'                 , record['MONEY_UNIT']);
//            grdRecord.set('EXCHG_RATE_O'               , record['EXCHG_RATE_O']);
//            grdRecord.set('DVRY_REQ_DATE'              , record['DELIVERY_REQ_DATE']);
            grdRecord.set('DELIVERY_REQ_DATE'          , record['DELIVERY_REQ_DATE']);
            grdRecord.set('DVRY_DATE'                  , record['DELIVERY_REQ_ORI_DATE']);
            grdRecord.set('WH_CODE'                    , record['WH_CODE']);
            grdRecord.set('SUPPLY_TYPE'                , record['SUPPLY_TYPE']);
            grdRecord.set('CUSTOM_CODE'                , record['LATEST_CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME'                , record['LATEST_CUSTOM_NAME']);
            grdRecord.set('REMARK'                     , record['REMARK']);
//            grdRecord.set('MRP_CONTROL_NUM'            , record['MRP_CONTROL_NUM']);
            grdRecord.set('ORDER_YN'                   , record['ORDER_YN']);
            grdRecord.set('REQ_DEPT_CODE'              , record['REQ_TREE_CODE']);
            grdRecord.set('REQ_DEPT_NAME'              , record['REQ_TREE_NAME']);

            if(!Ext.isEmpty(record['PURCH_LDTIME'])) {
                grdRecord.set('PURCH_LDTIME'               , record['PURCH_LDTIME']);
            } else {
            	var param = {
            		"ITEM_CODE": grdRecord.get('ITEM_CODE'),
                    "DIV_CODE": grdRecord.get('DIV_CODE')
                };
            	s_mre101ukrv_kdService.purchLdTime(param, function(provider, response)  {
                    grdRecord.set('PURCH_LDTIME'               , provider['PURCH_LDTIME']);
                });
            }
            grdRecord.set('COMP_CODE'                  , record['COMP_CODE']);
            grdRecord.set('UPDATE_DB_USER'             , record['UPDATE_DB_USER']);
            grdRecord.set('UPDATE_DB_TIME'             , record['UPDATE_DB_TIME']);

            var moneyUnit = record['MONEY_UNIT']
			if(Ext.isEmpty(moneyUnit)){
				moneyUnit = panelResult.getValue('MONEY_UNIT');
			}
            grdRecord.set('MONEY_UNIT'                  , moneyUnit);
            var param = {"ITEM_CODE": record['ITEM_CODE'],
                         "CUSTOM_CODE": record['LATEST_CUSTOM_CODE'],
                         "DIV_CODE": panelResult.getValue('DIV_CODE'),
                        //"MONEY_UNIT": panelResult.getValue('MONEY_UNIT'),
                         "MONEY_UNIT": moneyUnit,
                         "ORDER_UNIT": record['ORDER_UNIT'],
                         "ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
                         "PO_REQ_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'))
                        };
            s_mre101ukrv_kdService.fnOrderPrice(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                	var param = {
                    		"AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
                            "MONEY_UNIT" : moneyUnit
                    	};
                     s_mre101ukrv_kdService.fnExchgRateO(param, function(provider1, response) {
                     	 if(!Ext.isEmpty(provider1)){
                     		  grdRecord.set('EXCHG_RATE_O', provider1[0].BASE_EXCHG)
                          	  grdRecord.set('ORDER_P', provider['ORDER_P']);
                              grdRecord.set('ORDER_LOC_P', provider['ORDER_P']);
                              grdRecord.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                              grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P']);
                              grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P']);
                              UniAppManager.app.fnCalOrderAmt(grdRecord, "O", grdRecord.get('ORDER_O'));
                     	 }
                     });

                } else {
                	var param = {
                    		"AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
                            "MONEY_UNIT" : moneyUnit
                    	};
                     s_mre101ukrv_kdService.fnExchgRateO(param, function(provider1, response) {
                     	 if(!Ext.isEmpty(provider1)){
                     		  grdRecord.set('EXCHG_RATE_O', provider1[0].BASE_EXCHG)
                     		  grdRecord.set('ORDER_P', 0);
                              grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * 0);
                              grdRecord.set('ORDER_LOC_P', 0);
                              grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * 0);
                     	 }
                     });

                }
            });
            grdRecord.set('REF_TYPE'             , 'P');//참조타입 추가
            grdRecord.set('PLAN_YYYYMM'            , record['PLAN_YYYYMM']);//생산구매요청등록의 차수추가
            grdRecord.set('PLAN_ORDER'             , record['PLAN_ORDER']);//생산구매요청등록의 차수추가
        },
        setItemRequestData:function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'            , panelResult.getValue('DIV_CODE'));

            grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
            grdRecord.set('ITEM_ACCOUNT'        , record['ITEM_ACCOUNT']);
            grdRecord.set('SPEC'                , record['SPEC']);
            grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
            grdRecord.set('SUPPLY_TYPE'         , panelResult.getValue('SUPPLY_TYPE'));
            grdRecord.set('R_ORDER_Q'           , '0');  //미입고량
            grdRecord.set('ORDER_UNIT'          , record['ORDER_UNIT']);
            grdRecord.set('ORDER_UNIT_Q'        , record['REMAIN_Q']);
            grdRecord.set('TRNS_RATE'           , record['TRNS_RATE']);
            grdRecord.set('ORDER_Q'             , record['REMAIN_Q']);
            grdRecord.set('CUSTOM_CODE'         , record['LATEST_CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME'         , record['LATEST_CUSTOM_NAME']);
            grdRecord.set('REQ_DEPT_CODE'       , record['DEPT_CODE']);
            grdRecord.set('REQ_DEPT_NAME'       , record['DEPT_NAME']);


            //현재고 : 납품창고 지정후
            var param = {"ITEM_CODE": record['ITEM_CODE'],
                          "WH_CODE": record['WH_CODE']
                        };
            s_mre101ukrv_kdService.fnStockQ(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                }
            });
            grdRecord.set('ITEM_REQ_NUM'       , record['ITEM_REQ_NUM']);
            grdRecord.set('ITEM_REQ_SEQ'       , record['ITEM_REQ_SEQ']);
            if(!Ext.isEmpty(record['PURCH_LDTIME'])) {
                grdRecord.set('PURCH_LDTIME'               , record['PURCH_LDTIME']);
            } else {
                var param = {
                    "ITEM_CODE": grdRecord.get('ITEM_CODE'),
                    "DIV_CODE": grdRecord.get('DIV_CODE')
                };
                s_mre101ukrv_kdService.purchLdTime(param, function(provider, response)  {
                    grdRecord.set('PURCH_LDTIME'               , provider['PURCH_LDTIME']);
                    grdRecord.set('DELIVERY_REQ_DATE'       , record['DELIVERY_DATE']);
                    grdRecord.set('DVRY_DATE'           , UniDate.add((grdRecord.get('PO_REQ_DATE')), {days: + grdRecord.get('PURCH_LDTIME')}));
                });
            }
            grdRecord.set('PAB_STOCK_Q'         , '0');

            var moneyUnit = record['MONEY_UNIT']
			if(Ext.isEmpty(moneyUnit)){
				moneyUnit = panelResult.getValue('MONEY_UNIT');
			}
            grdRecord.set('MONEY_UNIT'                  , moneyUnit);

            var param = {"ITEM_CODE": record['ITEM_CODE'],
                         "CUSTOM_CODE": record['LATEST_CUSTOM_CODE'],
                         "DIV_CODE": panelResult.getValue('DIV_CODE'),
                         "MONEY_UNIT": moneyUnit,
                         "ORDER_UNIT": record['ORDER_UNIT'],
                         "ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
                         "PO_REQ_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'))
                        };
            s_mre101ukrv_kdService.fnOrderPrice(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
	                var param = {
	                    		"AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
	                            "MONEY_UNIT" : moneyUnit
	                    		};
	            	 s_mre101ukrv_kdService.fnExchgRateO(param, function(provider1, response) {
	            		 if(!Ext.isEmpty(provider1)){
	            				grdRecord.set('EXCHG_RATE_O', provider1[0].BASE_EXCHG)
	                		 	grdRecord.set('ORDER_P', provider['ORDER_P']);
	                            grdRecord.set('ORDER_LOC_P', provider['ORDER_P']);
	                            grdRecord.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
	                            grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P']);
	                            grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P']);
	                            UniAppManager.app.fnCalOrderAmt(grdRecord, "O", grdRecord.get('ORDER_O'));
	            		 }
	            	 });

                } else {
                	 var param = {
	                    		"AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
	                            "MONEY_UNIT" : moneyUnit
	                    		};
	            	 s_mre101ukrv_kdService.fnExchgRateO(param, function(provider1, response) {
	            		 if(!Ext.isEmpty(provider1)){
	            			 grdRecord.set('ORDER_P', 0);
	                         grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * 0);
	                         grdRecord.set('ORDER_LOC_P', 0);
	                         grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * 0);
	            		 }
	            	 });

                }
            });
            grdRecord.set('REF_TYPE'             , 'M');//참조타입 추가
        },
        setRequestRegData:function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'            , panelResult.getValue('DIV_CODE'));

            grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
            grdRecord.set('ITEM_ACCOUNT'        , record['ITEM_ACCOUNT']);
            grdRecord.set('SPEC'                , record['SPEC']);
            grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
            grdRecord.set('SUPPLY_TYPE'         , panelResult.getValue('SUPPLY_TYPE'));
            grdRecord.set('R_ORDER_Q'           , '0');  //미입고량
            grdRecord.set('ORDER_UNIT'          , record['ORDER_UNIT']);
            grdRecord.set('ORDER_UNIT_Q'        , record['REMAIN_Q']);
            grdRecord.set('TRNS_RATE'           , record['TRNS_RATE']);
            grdRecord.set('ORDER_Q'             , record['CAL_QTY']);
            grdRecord.set('CUSTOM_CODE'         , record['LATEST_CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME'         , record['LATEST_CUSTOM_NAME']);
            grdRecord.set('REQ_DEPT_CODE'       , record['DEPT_CODE']);
            grdRecord.set('REQ_DEPT_NAME'       , record['DEPT_NAME']);
            grdRecord.set('REMARK'       		, record['REMARK']);
            grdRecord.set('CUSTOM_CODE'         , record['CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME'         , record['CUSTOM_NAME']);

            //현재고 : 납품창고 지정후
            var param = {"ITEM_CODE": record['ITEM_CODE'],
                          "WH_CODE": record['WH_CODE']
                        };
            s_mre101ukrv_kdService.fnStockQ(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                }
            });
            grdRecord.set('ITEM_REQ_NUM'       , record['ITEM_REQ_NUM']);
            grdRecord.set('ITEM_REQ_SEQ'       , record['ITEM_REQ_SEQ']);
            if(!Ext.isEmpty(record['PURCH_LDTIME'])) {
                grdRecord.set('PURCH_LDTIME'               , record['PURCH_LDTIME']);
            } else {
                var param = {
                    "ITEM_CODE": grdRecord.get('ITEM_CODE'),
                    "DIV_CODE": grdRecord.get('DIV_CODE')
                };
                s_mre101ukrv_kdService.purchLdTime(param, function(provider, response)  {
                    grdRecord.set('PURCH_LDTIME'               , provider['PURCH_LDTIME']);
                    grdRecord.set('DELIVERY_REQ_DATE'       , record['DELIVERY_DATE']);
                    grdRecord.set('DVRY_DATE'           , UniDate.add((grdRecord.get('PO_REQ_DATE')), {days: + grdRecord.get('PURCH_LDTIME')}));
                });
            }
            grdRecord.set('PAB_STOCK_Q'         , '0');

          /*   var param = {"ITEM_CODE": record['ITEM_CODE'],
                         "CUSTOM_CODE": record['LATEST_CUSTOM_CODE'],
                         "DIV_CODE": panelResult.getValue('DIV_CODE'),
                         "MONEY_UNIT": panelResult.getValue('MONEY_UNIT'),
                         "ORDER_UNIT": record['ORDER_UNIT'],
                         "ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
                         "PO_REQ_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'))
                        };
            s_mre101ukrv_kdService.fnOrderPrice(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('ORDER_P', provider['ORDER_P']);
                    grdRecord.set('ORDER_LOC_P', provider['ORDER_P']);
                    grdRecord.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                    grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P']);
                    grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * provider['ORDER_P']);
                } else {
                    grdRecord.set('ORDER_P', 0);
                    grdRecord.set('ORDER_O' , grdRecord.get('ORDER_Q') * 0);
                    grdRecord.set('ORDER_LOC_P', 0);
                    grdRecord.set('ORDER_LOC_O' , grdRecord.get('ORDER_Q') * 0);
                }
            }); */
            grdRecord.set('ORDER_P', record['PRICE']);
            grdRecord.set('ORDER_LOC_P', record['PRICE']);
            grdRecord.set('UNIT_PRICE_TYPE', 'Y');
            grdRecord.set('ORDER_O' , record['AMT']);
            grdRecord.set('ORDER_LOC_O' ,record['AMT']);
            grdRecord.set('REF_TYPE'             , 'Z');//참조타입 추가

            var moneyUnit = record['MONEY_UNIT']
			if(Ext.isEmpty(moneyUnit)){
				moneyUnit = panelResult.getValue('MONEY_UNIT');
			}
            grdRecord.set('MONEY_UNIT'                  , moneyUnit);
            var param = {
            		"AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
                    "MONEY_UNIT" : moneyUnit
            		};
            s_mre101ukrv_kdService.fnExchgRateO(param, function(provider, response) {
       		 if(!Ext.isEmpty(provider)){
      			grdRecord.set('EXCHG_RATE_O', provider[0].BASE_EXCHG)
      			grdRecord.set('ORDER_LOC_P', record['PRICE'] * provider[0].BASE_EXCHG);
      			grdRecord.set('ORDER_LOC_O' ,record['AMT'] * provider[0].BASE_EXCHG);
       		 }
       	 });
        }
    });

	var orderNoMasterGrid = Unilite.createGrid('s_mre101ukrv_kdOrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창 (의뢰번호)
		layout : 'fit',
        //excelTitle: '구매요청등록(의뢰번호검색)',
		store: orderNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
        columns: [
            { dataIndex: 'PO_REQ_DATE'		    ,  width: 80},
            { dataIndex: 'SUPPLY_TYPE'		    ,  width: 70,align:'center'},
            { dataIndex: 'PO_REQ_NUM'		    ,  width: 133},
            { dataIndex: 'PO_SER_NO'		    ,  width: 80,hidden:true},

            { dataIndex: 'ITEM_CODE'		    ,  width: 100},
            { dataIndex: 'ITEM_NAME'		    ,  width: 120},
            { dataIndex: 'CUSTOM_CODE'	    ,  width: 80,hidden:true},
            { dataIndex: 'CUSTOM_NAME'	    ,  width: 120},

            { dataIndex: 'DEPT_CODE'	   		,  width: 80},
            { dataIndex: 'DEPT_NAME'	   		,  width: 80},
            { dataIndex: 'PERSON_NUMB'		    ,  width: 80,align:'center'},
            { dataIndex: 'PERSON_NAME'	        ,  width: 80,align:'center'},
            { dataIndex: 'REQ_DEPT_NAME'	   		,  width: 80},
            { dataIndex: 'GW_STATUS'	        ,  width: 60,align:'center'},
            { dataIndex: 'MONEY_UNIT'		    ,  width: 100,align:'center',hidden:true},
            { dataIndex: 'EXCHG_RATE_O'         ,  width: 100,hidden:true},
            { dataIndex: 'DIV_CODE'		        ,  width: 66,hidden:true},
            { dataIndex: 'ITEM_ACCOUNT'		        ,  width: 66,hidden:true}

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
                'DIV_CODE'          :record.data.DIV_CODE,
                'PO_REQ_NUM'        :record.data.PO_REQ_NUM,
                'PO_REQ_DATE'       :record.data.PO_REQ_DATE,
                'MONEY_UNIT'        :record.data.MONEY_UNIT,
                'EXCHG_RATE_O'      :record.data.EXCHG_RATE_O,

                'DEPT_CODE'         :record.data.DEPT_CODE,
                'DEPT_NAME'         :record.data.DEPT_NAME,
                'PERSON_NUMB'       :record.data.PERSON_NUMB,
                'PERSON_NAME'       :record.data.PERSON_NAME,

                'SUPPLY_TYPE'       :record.data.SUPPLY_TYPE,
                'ITEM_ACCOUNT'      :record.data.ITEM_ACCOUNT
            });
          	panelResult.setAllFieldsReadOnly(true);
            panelResult.setAllFieldsReadOnly(true);
          	directMasterStore1.loadStoreRecords();
		}
    });

    var mre090Grid = Unilite.createGrid('mre090ukrvGrid', {   // 생산구매계획
        layout: 'fit',
        store: mre090Store,
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
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
        columns: [
            {dataIndex:'COMP_CODE'                             , width: 100, hidden: true},
            {dataIndex:'DIV_CODE'                              , width: 100, hidden: true},
            {dataIndex:'REQ_DATE'                              , width: 100},
            {dataIndex:'ITEM_CODE'                             , width: 100},
            {dataIndex:'ITEM_NAME'                             , width: 200},
            {dataIndex:'SPEC'                                  , width: 200},
            {dataIndex:'WH_CODE'                               , width: 100},
            {dataIndex:'ORDER_UNIT'                            , width: 100, align: 'center'},
            {dataIndex:'TRNS_RATE'                             , width: 100},
            {dataIndex:'STOCK_UNIT'                            , width: 100, align: 'center'},
            {dataIndex:'PURCH_LD_TIME'                         , width: 100},
            {dataIndex:'TERMPLAN_Q'                            , width: 100},
            {dataIndex:'SAFE_STOCK_Q'                          , width: 100},
            {dataIndex:'STOCK_Q'                               , width: 100},
            {dataIndex:'NOIN_Q'                                , width: 100},
            {dataIndex:'ORDER_PLAN_Q'                          , width: 100},
            {dataIndex:'ING_PLAN_Q'                            , width: 100},
            {dataIndex:'REMAIN_Q'                              , width: 100},
            {dataIndex:'DELIVERY_REQ_DATE'                     , width: 120},
            {dataIndex:'DELIVERY_REQ_ORI_DATE'                 , width: 120},
            {dataIndex:'REQ_TREE_CODE'                         , width: 100},
            {dataIndex:'REQ_TREE_NAME'                         , width: 120},
            {dataIndex:'LATEST_CUSTOM_CODE'                    , width: 100},
            {dataIndex:'LATEST_CUSTOM_NAME'                    , width: 150},
            {dataIndex:'MONEY_UNIT'                            , width: 100, align: 'center'},
            {dataIndex:'REMARK'                                , width: 200},
            {dataIndex:'PRDT_REQ_NUM'                          , width: 100},
            {dataIndex:'PRDT_REQ_SEQ'                          , width: 100},
            {dataIndex:'PLAN_YYYYMM'                           , width: 80, align: 'center'},
            {dataIndex:'PLAN_ORDER'                            , width: 80, align: 'center'}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                }

            }
        },
        returnData: function(record)    {
        	var records = this.getSelectedRecords();
            Ext.each(records, function(record,i) {
                UniAppManager.app.onNewDataButtonDown();
                masterGrid.setMre090Data(record.data);
            });
            this.getStore().remove(records);
        }
    });

    var itemRequestGrid = Unilite.createGrid('s_mre101ukrv_kdItemRequestGrid', {   // 구매요청
        layout: 'fit',
        store: itemRequestStore,
        uniOpt: {
            useGroupSummary: true,
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
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
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
                  { dataIndex: 'COMP_CODE'            ,  width: 90, hidden: true},
                  { dataIndex: 'DIV_CODE'             ,  width: 90, hidden: true},
                  { dataIndex: 'ITEM_REQ_DATE'        ,  width: 90},
                  { dataIndex: 'DEPT_CODE'            ,  width: 90},
                  { dataIndex: 'DEPT_NAME'            ,  width: 90},
                  { dataIndex: 'ITEM_CODE'            ,  width: 90},
                  { dataIndex: 'ITEM_NAME'            ,  width: 100},
                  { dataIndex: 'SPEC'                 ,  width: 100},
                  { dataIndex: 'ITEM_ACCOUNT'         ,  width: 70},
                  { dataIndex: 'STOCK_UNIT'           ,  width: 70, align: 'center'},
                  { dataIndex: 'TRNS_RATE'            ,  width: 90},
                  { dataIndex: 'ORDER_UNIT'           ,  width: 70, align: 'center'},
                  { dataIndex: 'REQ_Q'                ,  width: 90},
                  { dataIndex: 'ING_PLAN_Q'           ,  width: 90},
                  { dataIndex: 'REMAIN_Q'             ,  width: 90},
                  { dataIndex: 'DELIVERY_DATE'        ,  width: 90},
                  { dataIndex: 'LATEST_CUSTOM_CODE'   ,  width: 100},
                  { dataIndex: 'LATEST_CUSTOM_NAME'   ,  width: 120},
                  { dataIndex: 'MONEY_UNIT'           ,  width: 90, hidden: false, align: 'center'},
                  { dataIndex: 'EXCHG_RATE_O'         ,  width: 90, hidden: false},
                  { dataIndex: 'USE_REMARK'           ,  width: 90},
                  { dataIndex: 'P_REQ_TYPE'           ,  width: 100, align: 'center'},
                  { dataIndex: 'ITEM_REQ_NUM'         ,  width: 90},
                  { dataIndex: 'ITEM_REQ_SEQ'         ,  width: 90},
                  { dataIndex: 'PERSON_NUMB'          ,  width: 90, hidden: true},
                  { dataIndex: 'GW_DOCU_NUM'          ,  width: 90, hidden: true},
                  { dataIndex: 'GW_FLAG'              ,  width: 90, hidden: true},
                  { dataIndex: 'NEXT_YN'              ,  width: 90, hidden: true}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                }

            }
        },
        returnData: function(record)    {
            var records = this.getSelectedRecords();
            Ext.each(records, function(record,i){
                UniAppManager.app.onNewDataButtonDown();
                masterGrid.setItemRequestData(record.data);
            });
            this.deleteSelectedRow();
        }
    });

    var requestRegGrid = Unilite.createGrid('s_mre101ukrv_kdRequestRegGrid', {   // 금형외주가공의뢰참조
        layout: 'fit',
        store: requestRegStore,
        uniOpt: {
            useGroupSummary: true,
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
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
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
            { dataIndex: 'COMP_CODE'            ,  width: 90, hidden: true},
            { dataIndex: 'DIV_CODE'             ,  width: 90, hidden: true},
            { dataIndex: 'ITEM_REQ_DATE'        ,  width: 90},
            { dataIndex: 'MOLD_ITEM_NAME'       ,  width: 150},
            { dataIndex: 'MAKE_GUBUN'           ,  width: 100, align: 'center'},
            { dataIndex: 'HM_CODE'              ,  width: 100, align: 'center'},
            { dataIndex: 'ITEM_CODE'            ,  width: 90},
            { dataIndex: 'ITEM_NAME'            ,  width: 150},
            { dataIndex: 'SPEC'                 ,  width: 100},
            { dataIndex: 'ORDER_UNIT'           ,  width: 70, align: 'center'},
            { dataIndex: 'REQ_Q'                ,  width: 90},
            { dataIndex: 'ING_PLAN_Q'           ,  width: 90},
            { dataIndex: 'REMAIN_Q'             ,  width: 90},
            { dataIndex: 'AMT'             		,  width: 110},
            { dataIndex: 'PRICE'           		,  width: 90, hidden: true},

            { dataIndex: 'CAL_QTY'              ,  width: 90, hidden: true},
            { dataIndex: 'PURCHASE_P'           ,  width: 90, hidden: true},


            { dataIndex: 'CUSTOM_CODE'          ,  width: 90},
            { dataIndex: 'CUSTOM_NAME'          ,  width: 150},
            { dataIndex: 'MONEY_UNIT'           ,  width: 100, align: 'center'},
            { dataIndex: 'ITEM_REQ_NUM'         ,  width: 90},
            { dataIndex: 'ITEM_REQ_SEQ'         ,  width: 90},
            { dataIndex: 'DEPT_CODE'            ,  width: 90},
            { dataIndex: 'DEPT_NAME'            ,  width: 90},


            { dataIndex: 'ITEM_ACCOUNT'         ,  width: 70, align: 'center', hidden: true},
            { dataIndex: 'STOCK_UNIT'           ,  width: 70, align: 'center', hidden: true},
            { dataIndex: 'TRNS_RATE'            ,  width: 90, hidden: true},
            { dataIndex: 'DELIVERY_DATE'        ,  width: 90, hidden: true},
            { dataIndex: 'GARO_NUM'             ,  width: 60, hidden: true},
            { dataIndex: 'GARO_NUM_UNIT'        ,  width: 60, hidden: true},
            { dataIndex: 'SERO_NUM'             ,  width: 60, hidden: true},
            { dataIndex: 'SERO_NUM_UNIT'        ,  width: 60, hidden: true},
            { dataIndex: 'THICK_NUM'            ,  width: 60, hidden: true},
            { dataIndex: 'THICK_NUM_UNIT'       ,  width: 60, hidden: true},
            { dataIndex: 'BJ_NUM'               ,  width: 60, hidden: true},
            { dataIndex: 'LATEST_CUSTOM_CODE'   ,  width: 100, hidden: true},
            { dataIndex: 'LATEST_CUSTOM_NAME'   ,  width: 120, hidden: true}

        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                }

            }
        },
        returnData: function(record)    {
            var records = this.getSelectedRecords();
            Ext.each(records, function(record,i){
                UniAppManager.app.onNewDataButtonDown();
                masterGrid.setRequestRegData(record.data);
            });
            this.deleteSelectedRow();
        }
    });

    function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
            	title: '구매의뢰검색',
                width: 1080,
                height: 580,
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
						Ext.getCmp('PO_REQ_NUM').setConfig('readOnly',true);
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
                        orderNoSearch.setValue('DIV_CODE',       panelResult.getValue('DIV_CODE'));
                        orderNoSearch.setValue('DEPT_CODE',      panelResult.getValue('DEPT_CODE'));
                        orderNoSearch.setValue('DEPT_NAME',      panelResult.getValue('DEPT_NAME'));
                        orderNoSearch.setValue('PERSON_NUMB',    panelResult.getValue('PERSON_NUMB'));
                        orderNoSearch.setValue('PERSON_NAME',    panelResult.getValue('PERSON_NAME'));
                        orderNoSearch.setValue('ITEM_ACCOUNT',   panelResult.getValue('ITEM_ACCOUNT'));
                        orderNoSearch.setValue('SUPPLY_TYPE',    panelResult.getValue('SUPPLY_TYPE'));
                        orderNoSearch.setValue('PO_REQ_DATE_FR',   UniDate.get('startOfMonth'));
                        orderNoSearch.setValue('PO_REQ_DATE_TO',   UniDate.get('today'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
    }

    function openMre090Window() {            //생산계획 참조
        //if(!Unilite.Main.checkForNewDetail()) return false;
        if(!panelResult.setAllFieldsReadOnly(true)) return false;

        if(!mre090Window) {
            mre090Window = Ext.create('widget.uniDetailWindow', {
                title: '생산계획참조',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [mre090Search, mre090Grid],
                tbar: ['->',{
                    itemId : 'saveBtn',
                    text: '조회',
                    handler: function() {
                        mre090Store.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'confirmCloseBtn',
                    text: '적용 후 닫기',
                    handler: function() {
                        mre090Grid.returnData();
                        mre090Window.hide();
                        //directMasterStore1.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'closeBtn',
                    text: '닫기',
                    handler: function() {
                        mre090Window.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    beforeshow: function ( me, eOpts )  {
                        mre090Search.clearForm();
                        mre090Grid.reset();
                    },
                    show: function( panel, eOpts )  {
                        mre090Search.setValue('DIV_CODE',           panelResult.getValue('DIV_CODE'));
                        mre090Search.setValue('SUPPLY_TYPE',        panelResult.getValue('SUPPLY_TYPE'));
                        mre090Search.setValue('DOM_FORIGN',         Ext.getCmp('rdoSelect').getChecked()[0].inputValue);
                        mre090Search.setValue('ITEM_ACCOUNT',       panelResult.getValue('ITEM_ACCOUNT'));
                        mre090Search.setValue('PO_REQ_DATE_FR',     UniDate.get('startOfMonth'));
                        mre090Search.setValue('PO_REQ_DATE_TO',     UniDate.get('today'));

                        mre090Store.loadStoreRecords();
                    }
                }
            })
        }
        mre090Window.center();
        mre090Window.show();
    };

    function openItemRequestWindow() {            //물품의뢰 참조
        //if(!Unilite.Main.checkForNewDetail()) return false;
        if(!panelResult.setAllFieldsReadOnly(true)) return false;

        if(!itemRequestWindow) {
            itemRequestWindow = Ext.create('widget.uniDetailWindow', {
                title: '구매요청참조',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [itemRequestSearch, itemRequestGrid],
                tbar: ['->',{
                    itemId : 'saveBtn',
                    text: '조회',
                    handler: function() {
//                        if(itemRequestSearch.setAllFieldsReadOnly(true) == false){
//                            return false;
//                        }
                        itemRequestStore.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'confirmCloseBtn',
                    text: '적용 후 닫기',
                    handler: function() {
                        itemRequestGrid.returnData();
                        itemRequestWindow.hide();
                        //directMasterStore1.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'closeBtn',
                    text: '닫기',
                    handler: function() {
                        itemRequestWindow.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    beforeshow: function ( me, eOpts )  {
                        itemRequestSearch.setValue('DIV_CODE',           panelResult.getValue('DIV_CODE'));
                        itemRequestSearch.setValue('SUPPLY_TYPE',        panelResult.getValue('SUPPLY_TYPE'));
                        itemRequestSearch.setValue('DOM_FORIGN',         Ext.getCmp('rdoSelect').getChecked()[0].inputValue);
                        //itemRequestSearch.setValue('ITEM_ACCOUNT',       panelResult.getValue('ITEM_ACCOUNT'));
                        itemRequestSearch.setValue('ITEM_REQ_DATE_FR',     UniDate.get('startOfMonth'));
                        itemRequestSearch.setValue('ITEM_REQ_DATE_TO',     UniDate.get('today'));

                        mre090Store.loadStoreRecords();
                    },
                    show: function( panel, eOpts )  {
                        itemRequestSearch.setValue('DIV_CODE',           panelResult.getValue('DIV_CODE'));
                        itemRequestSearch.setValue('SUPPLY_TYPE',        panelResult.getValue('SUPPLY_TYPE'));
                        itemRequestSearch.setValue('DOM_FORIGN',         Ext.getCmp('rdoSelect').getChecked()[0].inputValue);
                        //itemRequestSearch.setValue('ITEM_ACCOUNT',       panelResult.getValue('ITEM_ACCOUNT'));
                        itemRequestSearch.setValue('ITEM_REQ_DATE_FR',     UniDate.get('startOfMonth'));
                        itemRequestSearch.setValue('ITEM_REQ_DATE_TO',     UniDate.get('today'));

                        itemRequestStore.loadStoreRecords();
                    }
                }
            })
        }
        itemRequestWindow.center();
        itemRequestWindow.show();
    };

    function openRequestRegWindow() {            //금형외주가공의뢰참조
        //if(!Unilite.Main.checkForNewDetail()) return false;
        if(!panelResult.setAllFieldsReadOnly(true)) return false;

        if(!requestRegWindow) {
            requestRegWindow = Ext.create('widget.uniDetailWindow', {
                title: '금형외주가공의뢰참조',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [requestRegSearch, requestRegGrid],
                tbar: ['->',{
                    itemId : 'saveBtn',
                    text: '조회',
                    handler: function() {
//                        if(requestRegSearch.setAllFieldsReadOnly(true) == false){
//                            return false;
//                        }
                        requestRegStore.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'confirmCloseBtn',
                    text: '적용 후 닫기',
                    handler: function() {
                        requestRegGrid.returnData();
                        requestRegWindow.hide();
                        //directMasterStore1.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'closeBtn',
                    text: '닫기',
                    handler: function() {
                        requestRegWindow.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    beforeshow: function ( me, eOpts )  {
                    	requestRegSearch.clearForm();
                    	requestRegGrid.reset();
                    	requestRegSearch.setValue('DIV_CODE',           panelResult.getValue('DIV_CODE'));
                        requestRegSearch.setValue('SUPPLY_TYPE',        panelResult.getValue('SUPPLY_TYPE'));
                        requestRegSearch.setValue('DOM_FORIGN',         Ext.getCmp('rdoSelect').getChecked()[0].inputValue);
                        requestRegSearch.setValue('ITEM_ACCOUNT',       panelResult.getValue('ITEM_ACCOUNT'));
                        requestRegSearch.setValue('ITEM_REQ_DATE_FR',     UniDate.get('startOfMonth'));
                        requestRegSearch.setValue('ITEM_REQ_DATE_TO',     UniDate.get('today'));

                        requestRegStore.loadStoreRecords();
                    },
                    show: function( panel, eOpts )  {
                        requestRegSearch.setValue('DIV_CODE',           panelResult.getValue('DIV_CODE'));
                        requestRegSearch.setValue('SUPPLY_TYPE',        panelResult.getValue('SUPPLY_TYPE'));
                        requestRegSearch.setValue('DOM_FORIGN',         Ext.getCmp('rdoSelect').getChecked()[0].inputValue);
                        requestRegSearch.setValue('ITEM_ACCOUNT',       panelResult.getValue('ITEM_ACCOUNT'));
                        requestRegSearch.setValue('ITEM_REQ_DATE_FR',     UniDate.get('startOfMonth'));
                        requestRegSearch.setValue('ITEM_REQ_DATE_TO',     UniDate.get('today'));

                        requestRegStore.loadStoreRecords();
                    }
                }
            })
        }
        requestRegWindow.center();
        requestRegWindow.show();
    };

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}
		],
		id: 's_mre101ukrv_kdApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
            Ext.getCmp('GW').setDisabled(true);
		},
		onQueryButtonDown: function()	{
            panelResult.setValue('GW_TEMP', '');
			panelResult.setAllFieldsReadOnly(false);
			var orderNo = panelResult.getValue('PO_REQ_NUM');
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
			 var poReqNum = panelResult.getValue('PO_REQ_NUM');
			 var seq = directMasterStore1.max('PO_SER_NO');
        	 if(!seq) seq = 1;
        	 else  seq += 1;
        	 var divCode = panelResult.getValue('DIV_CODE');
        	 var moneyUnit = panelResult.getValue('MONEY_UNIT'); // MoneyUnit
        	 var exchgRateO = panelResult.getValue('EXCHG_RATE_O');
        	 var domForign = panelResult.getValues().DOM_FORIGN;
        	 var unitPriceType = 'Y';
        	 var orderYn = 'N';
        	 var dvryDate = UniDate.get('today');
//             var poReqDate = UniDate.get('today');

        	 var orderQ = '0';
        	 var orderP = '0';
        	 var orderO = '0';
        	 var orderUnitQ = '0';

        	 var trnsRate = '1';
        	 var orderLocP = '0';
        	 var orderLocO = '0';
        	 var inspecFlag = 'N';
             var prdtReqNum = '';
             var supplyType = panelResult.getValue('SUPPLY_TYPE');
        	 var r = {
				PO_REQ_NUM: poReqNum,
				PO_SER_NO: seq,
				DIV_CODE: divCode,
				UNIT_PRICE_TYPE: unitPriceType,
				ORDER_YN: orderYn,

				ORDER_Q: orderQ,
				ORDER_P: orderP,
				ORDER_O: orderO,
				ORDER_UNIT_Q: orderUnitQ,

				TRNS_RATE: trnsRate,
				ORDER_LOC_P: orderLocP,
				ORDER_LOC_O: orderLocO,
				DVRY_DATE: dvryDate,
//				PO_REQ_DATE: poReqDate,
				MONEY_UNIT: moneyUnit,
				EXCHG_RATE_O: exchgRateO,
				INSPEC_FLAG: inspecFlag,
				PRDT_REQ_NUM:prdtReqNum,
				PO_REQ_DATE: dvryDate,
				SUPPLY_TYPE: supplyType,
				DOM_FORIGN : domForign
	        };
	        masterGrid.createRow(r);
            panelResult.setAllFieldsReadOnly(true);

//            var param = panelResult.getValues();
//            s_mre101ukrv_kdService.selectGwData(param, function(provider, response) {
//                if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
//                	masterGrid.createRow(r);
//                } else {
//                    alert('이미 기안된 자료입니다.');
//                    return false;
//                }
//            });
		},
		onResetButtonDown: function() {
		//	panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
		//	panelResult.clearForm();
			panelResult.setValue('PO_REQ_NUM','');
			if(confirm('사원정보를 삭제 하시겠습니까?')) {
				panelResult.setValue('PERSON_NUMB','');
				panelResult.setValue('PERSON_NAME','');
			}
			directMasterStore1.clearData();
			Ext.getCmp('GW').setDisabled(true);
            panelResult.setValue('GW_TEMP', '');
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ORDER_YN') == 'Y')
				{
					alert('발주되어 삭제할수 없습니다');
				}else{
					masterGrid.deleteSelectedRow();
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
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PO_REQ_DATE',new Date());
/*
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_NAME',UserInfo.deptName);
            panelResult.setValue('PERSON_NUMB',UserInfo.userID);
            panelResult.setValue('PERSON_NAME',UserInfo.userName);
*/
        	panelResult.setValue('MONEY_UNIT', BsaCodeInfo.gsDefaultMoney);
            panelResult.setValue('SUPPLY_TYPE', '1');
//            panelResult.setValue('ITEM_ACCOUNT', '00');
//            panelResult.setValue('ITEM_ACCOUNT', '00');
        	// panelResult.setValue('DIV_CODE',UserInfo.divCode);

        	Ext.getCmp('PO_REQ_NUM').setConfig('readOnly',true);
            UniAppManager.app.fnExchngRateO();

            panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);

		},
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var poReqNum    = panelResult.getValue('PO_REQ_NUM');
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_MRE101UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + poReqNum + "'";
            var spCall      = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
            /* frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_mre101ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('PO_REQ_NUM') + "&sp=" + spCall;
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit(); */
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_mre101ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('PO_REQ_NUM') + "&sp=" + spCall/* + Base64.encode()*/;
            UniBase.fnGw_Call(gwurl,frm,'GW');
        },
        fnExchngRateO:function() {
        	var param = {
        		"AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
                "MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
        	};
            s_mre101ukrv_kdService.fnExchgRateO(param, function(provider, response) {
                panelResult.setValue('EXCHG_RATE_O', provider[0].BASE_EXCHG);
                panelResult.setValue('EXCHG_RATE_O', provider[0].BASE_EXCHG);
            });
        },
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('PO_REQ_NUM')))	{
				alert('의뢰번호는 필수입력값이고 수동입력입니다 먼저 입력후 진행하십시오');
				return false;
			}
			return panelResult.setAllFieldsReadOnly(true);
        },
		fnCalOrderAmt: function(rtnRecord, sType, nValue) {
			var dOrderUnitQ= sType =='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q'),0);  //발주요청량
			var dOrderUnitP= sType =='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_P'),0);       //구매단위 단가
			var dOrderO= sType =='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O'),0);
			var dTransRate= sType =='R' ? nValue : Unilite.nvl(rtnRecord.get('TRNS_RATE'),1);
			var dOrderQ;  //발주요청량(구매)
			///var dOrderP;
			var dExchgRateO= sType =='X' ? nValue : Unilite.nvl(rtnRecord.get('EXCHG_RATE_O'),1); //환율
			var dOrderLocP= sType =='L' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_P'),0);
			var dOrderLocO= sType =='I' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_O'),0);

			if(sType == 'P' || sType == 'Q'){
				dOrderQ = dOrderUnitQ * dTransRate;
				rtnRecord.set('ORDER_UNIT_Q', dOrderQ);

				dOrderO = dOrderUnitQ * dOrderUnitP; //금액 = 발주요청량 * 단가
				rtnRecord.set('ORDER_O', dOrderO);

				//dOrderP = dOrderUnitP / dTransRate;
				//rtnRecord.set('ORDER_P', dOrderP);

				dOrderLocP = dOrderUnitP * dExchgRateO;
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderLocO = dOrderUnitQ * dOrderLocP;
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);

			}else if(sType == 'R'){      //구매입수
				dOrderQ = dOrderUnitQ * dTransRate; //재고량(재고) = 재고구매량(구매) * 입수
				//dOrderQ = dOrderUnitQ * dTransRate;
				rtnRecord.set('ORDER_UNIT_Q', dOrderQ);

				//dOrderP = dOrderUnitP / dTransRate;
				//rtnRecord.set('ORDER_P', dOrderP);
			}else if(sType == 'O'){                 // DISABLE
				if(Math.abs(dOrderUnitQ) > '0'){
					dOrderUnitP = Math.abs(dOrderO) / Math.abs(dOrderUnitQ);
					rtnRecord.set('ORDER_P', dOrderUnitP);

					dOrderP = dOrderUnitP / dTransRate;
					rtnRecord.set('ORDER_P', dOrderP);

					dOrderLocP = dOrderUnitP * dExchgRateO;
					rtnRecord.set('ORDER_LOC_P', dOrderLocP);

					dOrderLocO = dOrderUnitQ * dOrderLocP;
					rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				}else{
					rtnRecord.set('ORDER_P', '0');
					rtnRecord.set('ORDER_P', '0');
					rtnRecord.set('ORDER_LOC_P', '0');

					dOrderLocO = dOrderO * dExchgRateO;
					rtnRecord.set('ORDER_LOC_O', dOrderLocO);
				}
			}else if(sType == 'X'){                //환율
				dOrderLocP = dOrderUnitP * dExchgRateO;
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderLocO = dOrderUnitQ * dOrderLocP;
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);

				dOrderO = dOrderUnitQ * dOrderUnitP;
				rtnRecord.set('ORDER_O', dOrderO);
			}else if(sType == 'L'){               //자사단가  DISABLE
				dOrderLocO = dOrderLocP * dOrderUnitQ;
				rtnRecord.set('ORDER_LOC_O', dOrderLocO);

				dOrderUnitP = dOrderLocP / dExchgRateO;
				rtnRecord.set('ORDER_P', dOrderUnitP);

				dOrderO = dOrderUnitQ * dOrderUnitP;
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = dOrderUnitQ * dTransRate;
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);
			}else if(sType == 'I'){           //자사금액 DISABLE
				dOrderLocP = dOrderLocO / dOrderUnitQ;
				rtnRecord.set('ORDER_LOC_P', dOrderLocP);

				dOrderUnitP = dOrderLocP / dExchgRateO;
				rtnRecord.set('ORDER_P', dOrderUnitP);

				dOrderO = dOrderUnitQ * dOrderUnitP;
				rtnRecord.set('ORDER_O', dOrderO);

				dOrderQ = dOrderUnitQ * dTransRate;
				rtnRecord.set('ORDER_Q', dOrderQ);

				dOrderP = dOrderUnitP / dTransRate;
				rtnRecord.set('ORDER_P', dOrderP);
			}
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ITEM_CODE" :

         /*         var param = {"ITEM_CODE": newValue,
                                 "CUSTOM_CODE": record.get('CUSTOM_CODE'),
                                 "DIV_CODE": panelResult.getValue('DIV_CODE'),
                                 "MONEY_UNIT": panelResult.getValue('MONEY_UNIT'),
                                 "ORDER_UNIT": record.get('ORDER_UNIT'),
                                 "ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
                                 "PO_REQ_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'))
                                };
                    s_mre101ukrv_kdService.fnOrderPrice(param, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){

                            record.set('ORDER_P', provider['ORDER_P']);
                            record.set('ORDER_LOC_P', provider['ORDER_P']);
                            record.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                        } else {
                        	record.set('ORDER_P', 0);
                        	record.set('ORDER_LOC_P', 0);
                        }
                    }); */
                    break;

                case "CUSTOM_CODE" :
                    var param = {"ITEM_CODE": record.get('ITEM_CODE'),
                                 "CUSTOM_CODE": newValue,
                                 "DIV_CODE": panelResult.getValue('DIV_CODE'),
                                 "MONEY_UNIT": panelResult.getValue('MONEY_UNIT'),
                                 "ORDER_UNIT": record.get('ORDER_UNIT'),
                                 "ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
                                 "PO_REQ_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'))
                                };
                    s_mre101ukrv_kdService.fnOrderPrice(param, function(provider, response)  {
                        if(!Ext.isEmpty(provider)){

                            record.set('ORDER_P', provider['ORDER_P']);
                            record.set('ORDER_LOC_P', provider['ORDER_P']);
                            record.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                        } else {
                            record.set('ORDER_P', 0);
                            record.set('ORDER_LOC_P', 0);
                        }
                    });
                    break;

				case "PO_SER_NO" : //발주순번
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}

				case "ORDER_UNIT" :
					directMasterStore1.fnSumOrderO();
				break;

//				case "ORDER_UNIT_Q" :
//                    if(newValue <= 0){
//                        rv='<t:message code="unilite.msg.sMB076"/>';
//                        break;
//                    }
//                    UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
//                    directMasterStore1.fnSumOrderO();
//                    break;

                case "ORDER_Q" :
                    if(newValue <= 0){
                        rv='<t:message code="unilite.msg.sMB076"/>';
                        break;
                    }
                    UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
                    directMasterStore1.fnSumOrderO();
                    break;

				case "ORDER_P":
					if(record.get('UNIT_PRICE_TYPE') == 'Y'){
						if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "P", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_O" :
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "MONEY_UNIT" :

							var param = {
									"AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE')),
									"ITEM_CODE": record.get('ITEM_CODE'),
	                                 "CUSTOM_CODE":  record.get('CUSTOM_CODE'),
	                                 "DIV_CODE": panelResult.getValue('DIV_CODE'),
	                                 "MONEY_UNIT": newValue,
	                                 "ORDER_UNIT": record.get('ORDER_UNIT'),
	                                 "ORDER_DATE": UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE')),
	                                 "PO_REQ_DATE":UniDate.getDbDateStr(panelResult.getValue('PO_REQ_DATE'))
	                                };

				            s_mre101ukrv_kdService.fnExchgRateO(param, function(provider, response) {
				            	   if(!Ext.isEmpty(provider)){
				            		   record.set('EXCHG_RATE_O', provider[0].BASE_EXCHG);
				            		   UniAppManager.app.fnCalOrderAmt(record, "X", record.get("EXCHG_RATE_O"));
				    				   directMasterStore1.fnSumOrderO();
				            	   }


				                 /*    s_mre101ukrv_kdService.fnOrderPrice(param, function(provider1, response)  {
				                        if(!Ext.isEmpty(provider1)){
				                            record.set('ORDER_P', provider1['ORDER_P']);
				                            record.set('ORDER_LOC_P', provider1['ORDER_P']);
				                            record.set('UNIT_PRICE_TYPE', provider1['PRICE_TYPE']);

				                        } else {
				                            record.set('ORDER_P', 0);
				                            record.set('ORDER_LOC_P', 0);
				                            UniAppManager.app.fnCalOrderAmt(record, "X", record.get("EXCHG_RATE_O"));
					    					directMasterStore1.fnSumOrderO();
				                        }

				                    }); */
				            });


					break;

				case "EXCHG_RATE_O":
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "X", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_P":	             //자사단가
					if(record.get('UNIT_PRICE_TYPE') == 'Y'){
						if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
						}
					}
					UniAppManager.app.fnCalOrderAmt(record, "L", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "ORDER_LOC_O":              //자사금액
					if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "I", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "DVRY_DATE":
					if(newValue < panelResult.getValue('ORDER_DATE')){
						rv='<t:message code="unilite.msg.sMM374"/>';
								break;
					}
					break;

				case "TRNS_RATE":
					if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "R", newValue);
					directMasterStore1.fnSumOrderO();
					break;

				case "PO_REQ_DATE":
					if(newValue > record.get('DVRY_DATE')){
						rv='발주예정일이 납기일 이후일 수는 없습니다.';
								break;
					}
					record.set('DVRY_DATE', UniDate.add(newValue, {days: + record.get('PURCH_LDTIME')}));

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
