<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tit100ukrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="tit100ukrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="0" comboCode="T029" /> <!-- 신고자 -->
	<t:ExtComboStore comboType="0" comboCode="T008" /> <!-- 항구코드(선적항/도착항) -->
	<t:ExtComboStore comboType="0" comboCode="T009" /> <!-- 세관 -->
	<t:ExtComboStore comboType="B" comboCode="B013" /> <!-- 중량단위 -->
	<t:ExtComboStore comboType="B" comboCode="B004" /> <!-- <t:message code="system.label.trade.packagingtype" default="포장형태"/> -->
	<t:ExtComboStore comboType="0" comboCode="T005" /> <!-- 가격조건 -->
	<t:ExtComboStore comboType="0" comboCode="T016" /> <!-- 결제방법 -->
	<t:ExtComboStore comboType="0" comboCode="T006" /> <!-- <t:message code="system.label.trade.paymentcondition" default="결제조건"/> -->
	<t:ExtComboStore comboType="0" comboCode="T021" /> <!-- 신고구분 -->
	<t:ExtComboStore comboType="0" comboCode="T011" /> <!-- 검사구분 -->
	<t:ExtComboStore comboType="0" comboCode="T027" /> <!-- <t:message code="system.label.trade.transporttype" default="운송형태"/> -->
	<t:ExtComboStore comboType="0" comboCode="B012" /> <!-- 선박국적 -->
	<t:ExtComboStore comboType="AU" comboCode="B001" /> <!-- 사업장 -->
	<t:ExtComboStore comboType="0" comboCode="T109" /> <!-- 국내외구분 -->
	<t:ExtComboStore comboType="0" comboCode="T002" /> <!-- 무역종류 -->
	<t:ExtComboStore comboType="AU" comboCode="T113" /> <!-- 페이지링크 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {
	
	var masterModel =Unilite.defineModel('masterModel', {       //조회버튼 누르면 나오는 조회창masterModel
        fields: [
            {name: 'PASS_SER_NO'             , text: '통관 관리번호'       , type: 'string'},
            {name: 'INVOICE_DATE'            , text: '통관일'       , type: 'uniDate', allowBlank: false},
            {name: 'INVOICE_NO'              , text: '송장번호'       , type: 'string', allowBlank: false},
            {name: 'DIV_CODE'                , text: '<t:message code="system.label.trade.division" default="사업장"/>'       , type: 'string'},
            {name: 'EP_NO'                   , text: '면허번호'       , type: 'string'},
            {name: 'TRADE_TYPE'              , text: '<t:message code="system.label.trade.tradetype" default="무역종류"/>'       , type: 'string'},
            {name: 'PjctCD'                  , text: '프로젝트 NO'       , type: 'string'},
            {name: 'EP_DATE'                 , text: '면허일'       , type: 'uniDate'},
            {name: 'ED_DATE'                 , text: '<t:message code="system.label.trade.reportdate" default="신고일"/>'       , type: 'uniDate'},
            {name: 'ED_NO'                   , text: '<t:message code="system.label.trade.reportno" default="신고번호"/>'       , type: 'string'},
            {name: 'APP_DATE'                , text: '요청일'       , type: 'uniDate', allowBlank: false},
            {name: 'DISCHGE_DATE'            , text: '도착일'       , type: 'uniDate', allowBlank: false},
            {name: 'SHIP_FIN_DATE'           , text: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>'       , type: 'uniDate'},
            {name: 'REPORTOR'                , text: '신고자'       , type: 'string'},
            {name: 'BL_SER_NO'               , text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'       , type: 'string'},
            {name: 'DEST_PORT'               , text: '<t:message code="system.label.trade.arrivalport" default="도착항"/>'       , type: 'string', allowBlank: false},
            {name: 'DEST_PORT_NM'            , text: '<t:message code="system.label.trade.arrivalport" default="도착항"/>'       , type: 'string', allowBlank: false},
            {name: 'SHIP_PORT'               , text: '<t:message code="system.label.trade.shipmentport" default="선적항"/>'       , type: 'string', allowBlank: false},
            {name: 'SHIP_PORT_NM'            , text: '<t:message code="system.label.trade.shipmentport" default="선적항"/>'       , type: 'string', allowBlank: false},
            {name: 'VESSEL_NATION_CODE'      , text: '선박국적'       , type: 'string'},
            {name: 'VESSEL_NM'               , text: 'VESSEL명'       , type: 'string'},
            {name: 'DEVICE_NO'               , text: '장치확인번호'       , type: 'string'},
            {name: 'DEVICE_PLACE'            , text: '장치장소'       , type: 'string'},
            {name: 'CUSTOMS'                 , text: '세관'       , type: 'string'},
            {name: 'EXAM_TXT'                , text: '조사란'       , type: 'string'},
            {name: 'IMPORTER'                , text: '<t:message code="system.label.trade.importer" default="수입자"/>'       , type: 'string'},
            {name: 'IMPORTER_NM'             , text: '<t:message code="system.label.trade.importer" default="수입자"/>'       , type: 'string'},
            {name: 'EXPORTER'                , text: '<t:message code="system.label.trade.exporter" default="수출자"/>'       , type: 'string'},
            {name: 'EXPORTER_NM'             , text: '<t:message code="system.label.trade.exporter" default="수출자"/>'       , type: 'string'},
            {name: 'GROSS_WEIGHT'            , text: '총중량'       , type: 'uniQty'},
            {name: 'WEIGHT_UNIT'             , text: '<t:message code="system.label.trade.weightunit" default="중량단위"/>'       , type: 'string'},
            {name: 'PACKING_TYPE'            , text: '<t:message code="system.label.trade.packagingtype" default="포장형태"/>'       , type: 'string'},
            {name: 'TOT_PACKING_COUNT'       , text: '총포장갯수'       , type: 'uniQty'},
            {name: 'PASS_AMT'                , text: '통관금액'       , type: 'uniPrice'},
            {name: 'PASS_AMT_UNIT'           , text: '<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'       , type: 'string', allowBlank: false},
            {name: 'PASS_EXCHANGE_RATE'      , text: '통관환율'       , type: 'string', allowBlank: false},
            {name: 'PASS_AMT_WON'            , text: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'       , type: 'uniPrice'},
            {name: 'CIF_AMT'                 , text: 'CIf 금액(USD)'       , type: 'uniFC'},
            {name: 'CIF_AMT_UNIT'            , text: 'Cif화폐단위'       , type: 'string'},
            {name: 'CIF_EXCHANGE_RATE'       , text: 'USD 환율'       , type: 'string', defaultValue: '0'},
            {name: 'CIF_AMT_WON'             , text: 'CIf 원화금액'       , type: 'uniPrice'},
            {name: 'PAY_METHODE'             , text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'       , type: 'string'},
            {name: 'TERMS_PRICE'             , text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'       , type: 'string'},
            {name: 'PAY_TERMS'               , text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'       , type: 'string'},
            {name: 'PAY_DURING'              , text: '기간'       , type: 'string'},
            {name: 'EP_TYPE'                 , text: '신고구분'       , type: 'string', allowBlank: false},
            {name: 'INSPECT_TYPE'            , text: '검사구분'       , type: 'string'},
            {name: 'FORM_TRANS'              , text: '<t:message code="system.label.trade.transporttype" default="운송형태"/>'       , type: 'string'},
            {name: 'TARIFF_TAX'              , text: '관세'       , type: 'uniPrice'},
            {name: 'VALUE_TAX'               , text: '부가세'       , type: 'uniPrice'},
            {name: 'INCOME_TAX'              , text: '소득세'       , type: 'uniPrice'},
            {name: 'INHA_TAX'                , text: '주민세'       , type: 'uniPrice'},
            {name: 'EDUC_TAX'                , text: '교육세'       , type: 'uniPrice'},
            {name: 'TRAF_TAX'                , text: '교통세'       , type: 'uniPrice'},
            {name: 'ARGRI_TAX'               , text: '농특세'       , type: 'uniPrice'},
            {name: 'INPUT_NO'                , text: '반입번호'       , type: 'string'},
            {name: 'INPUT_DATE'              , text: '반입일'       , type: 'uniDate'},
            {name: 'OUTPUT_DATE'             , text: '반출일'       , type: 'uniDate'},
            {name: 'PAYMENT_DATE'            , text: '납부일'       , type: 'uniDate'},
            {name: 'DVRY_DATE'               , text: '<t:message code="system.label.trade.deliverydate" default="납기일"/>'       , type: 'uniDate'},
            {name: 'TAXBILL_DATE'            , text: '계산서발행일'   , type: 'uniDate'},
            {name: 'TAXBILL_NO'              , text: '계산서번호'    , type: 'string'},
            {name: 'REMARKS1'                , text: '비고1'       , type: 'string'},
            {name: 'REMARKS2'                , text: '비고2'       , type: 'string'},
            {name: 'REMARKS3'                , text: '비고3'       , type: 'string'},
            {name: 'OPR_FLAG'                , text: 'OPR_FLAG'       , type: 'string'},
            {name: 'PROJECT_NO'              , text: 'PROJECT_NO'       , type: 'string'},
            {name: 'SO_SER_NO'               , text: 'SO_SER_NO'       , type: 'string'},
            {name: 'LC_SER_NO'               , text: 'LC_SER_NO'       , type: 'string'}
        ]
    });
    
    
	var reffModel = Unilite.defineModel('reffModel', {		//선적참조 모델
	    fields: [
	    	{name: 'DIV_CODE'	    			, text: '<t:message code="system.label.trade.division" default="사업장"/>'    	, type: 'string',comboType:'BOR120'},
	    	{name: 'BL_SER_NO'		    		, text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'   , type: 'string'},
	    	{name: 'BL_NO'		    			, text: '<t:message code="system.label.trade.blno" default="B/L번호"/>'    	, type: 'string'},
	    	{name: 'BL_DATE'		    		, text: 'B/L일'    		, type: 'uniDate'},
	    	{name: 'IMPORTER_NM'	    		, text: 'IMPORTER_NM'   , type: 'string',comboType:'0',comboCode:'T006'},
	    	{name: 'EXPORTER_NM'	    		, text: '<t:message code="system.label.trade.importer" default="수입자"/>'   	    , type: 'string'},    	
	    	{name: 'PAY_TEMRS'	    			, text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'   	, type: 'string'},
	    	{name: 'TERMS_PRICE'		    	, text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'      , type: 'string'},
	    	{name: 'EXCHANGE_RATE'	    		, text: '승인'    		, type: 'string'},
	    	{name: 'AGREE_PRSN'		    		, text: '승인자'    	, type: 'string'},
	    	{name: 'AGREE_PRSN_NAME'    		, text: '승인자명'    	, type: 'string'},
	    	{name: 'TRADE_TYPE'		    		, text: '승인일'    	, type: 'uniDate'},
	    	{name: 'NATION_INOUT'		    	, text: '<t:message code="system.label.trade.currency" default="화폐 "/>'    		, type: 'string'},
	    	{name: 'PROJECT_NO'	    			, text: 'PROJECT_NO'    	, type: 'string'},
	    	{name: 'EXPENSE_FLAG'			    , text: '비고'    		, type: 'string'},
	    	{name: 'INVOICE_NO'	    			, text: 'INVOICE_NO'    , type: 'string'},
	    	{name: 'CUSTOMS'		    		, text: 'CUSTOMS'    	, type: 'string'},
	    	{name: 'EP_TYPE'		    		, text: 'EP_TYPE'    	, type: 'string'},
	    	{name: 'LC_NO'		    			, text: 'LC_NO'    		, type: 'string'},
	    	{name: 'IMPORTER'	 				, text: 'IMPORTER'	 				, type: 'string'},
	    	{name: 'EXPORTER'	 				, text: 'EXPORTER'	 				, type: 'string'},
	    	{name: 'PAY_METHODE'	 			, text: 'PAY_METHODE'	 			, type: 'string'},
	    	{name: 'PAY_DURING'	 				, text: 'PAY_DURING'	 			, type: 'string'},
	    	{name: 'SO_SER_NO'	 				, text: 'SO_SER_NO'	 				, type: 'string'},
	    	{name: 'LC_SER_NO'	 				, text: 'LC_SER_NO'	 				, type: 'string'},
	    	{name: 'VESSEL_NAME'	 			, text: 'VESSEL_NAME'	 			, type: 'string'},
	    	{name: 'VESSEL_NATION_CODE'	 		, text: 'VESSEL_NATION_CODE'	    , type: 'string'},
	    	{name: 'DEST_PORT'	 				, text: 'DEST_PORT'	 				, type: 'string'},
	    	{name: 'DEST_PORT_NM'	 			, text: 'DEST_PORT_NM'	 			, type: 'string'},
	    	{name: 'SHIP_PORT'	 				, text: 'SHIP_PORT'	 				, type: 'string'},
	    	{name: 'SHIP_PORT_NM'	 			, text: 'SHIP_PORT_NM'	 			, type: 'string'},
	    	{name: 'PACKING_TYPE'	 			, text: 'PACKING_TYPE'	 			, type: 'string'},
	    	{name: 'GROSS_WEIGHT'	 			, text: 'GROSS_WEIGHT'	 			, type: 'string'},
	    	{name: 'WEIGHT_UNIT'	 			, text: 'WEIGHT_UNIT'	 			, type: 'string'},
	    	{name: 'DATE_SHIPPING'	 			, text: 'DATE_SHIPPING'	 			, type: 'string'},
	    	{name: 'PROJECT_NAME'	 			, text: 'PROJECT_NAME'	 			, type: 'string'},
	    	{name: 'RECEIVE_AMT'	 			, text: 'RECEIVE_AMT'	 			, type: 'string'},
	    	{name: 'AMT_UNIT'	 				, text: 'AMT_UNIT'	 				, type: 'string'},
	    	{name: 'TRADE_TYPE'	 				, text: 'TRADE_TYPE'	 			, type: 'string'},
	    	{name: 'PASS_AMT'	 				, text: 'PASS_AMT'	 				, type: 'uniPrice'}
	    	
		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'tit100ukrvService.selectList',
            update: 'tit100ukrvService.updateDetail',
            create: 'tit100ukrvService.insertDetail',
            destroy: 'tit100ukrvService.deleteDetail',
            syncAll: 'tit100ukrvService.saveAll'
        }
    });
    
	var directMasterStore = Unilite.createStore('directMasterStore', {	
		model: 'masterModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();	
			console.log( param );
			this.load({
				params : param
			});
		},
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelSearch.getValues();   //syncAll 수정
            if(inValidRecs.length == 0) {               
                    config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                                //2.마스터 정보(Server 측 처리 시 가공)
                                var master = batch.operations[0].getResultSet();
                                panelSearch.setValue("PASS_SER_NO", master.PASS_SER_NO);
                                panelResult.setValue("PASS_SER_NO", master.PASS_SER_NO);
                                
                                //3.기타 처리
                                panelSearch.getForm().wasDirty = false;
                                panelSearch.resetDirtyStatus();
                                console.log("set was dirty to false");
                                UniAppManager.setToolbarButtons('save', false);

                                if(directMasterStore.getCount() == 0){
                                    UniAppManager.app.onResetButtonDown();
                                }
                             } 
                    };
                this.syncAllDirect(config);
            } else {                
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners:{
            update:function( store, record, operation, modifiedFieldNames, eOpts )  {
                masterForm.setActiveRecord(record);
            },
            load: function(store, records, successful, eOpts) {
            	var records = directMasterStore.data.items;
            	Ext.each(records, function(record, index){
                    masterForm.loadForm(record);
                });
                
            }
        }
	});
	
	var directReffStore = Unilite.createStore('directMasterStore', {   //선적참조 
        model: 'reffModel',
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
                read    : 'tit100ukrvService.selectList2'
            }
        },
        loadStoreRecords : function()   {
            var param= panelReff.getValues();    
            //var authoInfo = pgmInfo.authoUser;                //권한정보(N-전체,A-자기사업장>5-자기부서)
            //var deptCode = UserInfo.deptCode; //부서코드
            /*if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
                param.DEPT_CODE = deptCode;
            }*/
            console.log( param );
            this.load({
                params : param
            });
        }
    });
    
    
    var masterGrid = Unilite.createGrid('tit100ukrvMasterGrid', {
        layout : 'fit',   
        region: 'south',
        store: directMasterStore,        
        uniOpt:{    
            expandLastColumn: false,
            useRowNumberer: false
        },
        columns: [ 
            { dataIndex: 'PASS_SER_NO'             ,  width: 100},
            { dataIndex: 'INVOICE_DATE'            ,  width: 100},
            { dataIndex: 'INVOICE_NO'              ,  width: 100},
            { dataIndex: 'DIV_CODE'                ,  width: 100},
            { dataIndex: 'EP_NO'                   ,  width: 100},
            { dataIndex: 'TRADE_TYPE'              ,  width: 100},
            { dataIndex: 'PjctCD'                  ,  width: 100},
            { dataIndex: 'EP_DATE'                 ,  width: 100},
            { dataIndex: 'ED_DATE'                 ,  width: 100},
            { dataIndex: 'ED_NO'                   ,  width: 100},
            { dataIndex: 'APP_DATE'                ,  width: 100},
            { dataIndex: 'DISCHGE_DATE'            ,  width: 100},
            { dataIndex: 'SHIP_FIN_DATE'           ,  width: 100},
            { dataIndex: 'REPORTOR'                ,  width: 100},
            { dataIndex: 'BL_SER_NO'               ,  width: 100},
            { dataIndex: 'DEST_PORT'               ,  width: 100},
            { dataIndex: 'DEST_PORT_NM'            ,  width: 100},
            { dataIndex: 'SHIP_PORT'               ,  width: 100},
            { dataIndex: 'SHIP_PORT_NM'            ,  width: 100},
            { dataIndex: 'VESSEL_NATION_CODE'      ,  width: 100},
            { dataIndex: 'VESSEL_NM'               ,  width: 100},
            { dataIndex: 'DEVICE_NO'               ,  width: 100},
            { dataIndex: 'DEVICE_PLACE'            ,  width: 100},
            { dataIndex: 'CUSTOMS'                 ,  width: 100},
            { dataIndex: 'EXAM_TXT'                ,  width: 100},
            { dataIndex: 'IMPORTER'                ,  width: 100},
            { dataIndex: 'IMPORTER_NM'             ,  width: 100},
            { dataIndex: 'EXPORTER'                ,  width: 100},
            { dataIndex: 'EXPORTER_NM'             ,  width: 100},
            { dataIndex: 'GROSS_WEIGHT'            ,  width: 100},
            { dataIndex: 'WEIGHT_UNIT'             ,  width: 100},
            { dataIndex: 'PACKING_TYPE'            ,  width: 100},
            { dataIndex: 'TOT_PACKING_COUNT'       ,  width: 100},
            { dataIndex: 'PASS_AMT'                ,  width: 100},
            { dataIndex: 'PASS_AMT_UNIT'           ,  width: 100, align: 'center'},
            { dataIndex: 'PASS_EXCHANGE_RATE'      ,  width: 100},
            { dataIndex: 'PASS_AMT_WON'            ,  width: 100},
            { dataIndex: 'CIF_AMT'                 ,  width: 100},
            { dataIndex: 'CIF_AMT_UNIT'            ,  width: 100, align: 'center'},
            { dataIndex: 'CIF_EXCHANGE_RATE'       ,  width: 100},
            { dataIndex: 'CIF_AMT_WON'             ,  width: 100},
            { dataIndex: 'PAY_METHODE'             ,  width: 100},
            { dataIndex: 'TERMS_PRICE'             ,  width: 100},
            { dataIndex: 'PAY_TERMS'               ,  width: 100},
            { dataIndex: 'PAY_DURING'              ,  width: 100},
            { dataIndex: 'EP_TYPE'                 ,  width: 100},
            { dataIndex: 'INSPECT_TYPE'            ,  width: 100},
            { dataIndex: 'FORM_TRANS'              ,  width: 100},
            { dataIndex: 'TARIFF_TAX'              ,  width: 100},
            { dataIndex: 'VALUE_TAX'               ,  width: 100},
            { dataIndex: 'INCOME_TAX'              ,  width: 100},
            { dataIndex: 'INHA_TAX'                ,  width: 100},
            { dataIndex: 'EDUC_TAX'                ,  width: 100},
            { dataIndex: 'TRAF_TAX'                ,  width: 100},
            { dataIndex: 'ARGRI_TAX'               ,  width: 100},
            { dataIndex: 'INPUT_NO'                ,  width: 100},
            { dataIndex: 'INPUT_DATE'              ,  width: 100},
            { dataIndex: 'OUTPUT_DATE'             ,  width: 100},
            { dataIndex: 'PAYMENT_DATE'            ,  width: 100},
            { dataIndex: 'DVRY_DATE'               ,  width: 100},
            { dataIndex: 'TAXBILL_DATE'            ,  width: 100},
            { dataIndex: 'TAXBILL_NO'              ,  width: 100},
            { dataIndex: 'REMARKS1'                ,  width: 100},
            { dataIndex: 'REMARKS2'                ,  width: 100},
            { dataIndex: 'REMARKS3'                ,  width: 100},
            { dataIndex: 'OPR_FLAG'                ,  width: 100},
            { dataIndex: 'PROJECT_NO'              ,  width: 100},
            { dataIndex: 'SO_SER_NO'               ,  width: 100},
            { dataIndex: 'LC_SER_NO'               ,  width: 100}            
        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                this.returnData();
                SearchInfoWindow.hide();
            },
            selectionchangerecord:function(selected) {
                masterForm.loadForm(selected);
            }
        },
        returnData:function()   {
        
        }
    });
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.trade.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [
				{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				colspan:2,
				comboType: 'BOR120',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {	
							masterForm.setValue('DIV_CODE', newValue);
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			},{
				fieldLabel: '통관관리번호', 
				xtype:'uniTextfield',
				name:'PASS_SER_NO',
				listeners: {
					render: function(p) { 
						     p.getEl().on('dblclick', function(p){ 
						     	
						     })
					}
				}
			},
				{
				name: 'page',
				hidden:true,
				xtype: 'uniTextfield',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue("page",newValue);
						}
					}
			}
			]
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
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});
	var panelReff=Unilite.createSearchForm('searchForm2', {	
		layout :  {type : 'uniTable', columns : 2},
	    items: [{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name:'DIV_CODE',
			colspan:2,
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value:UserInfo.divCode,
			readOnly:true
		},
		{
			fieldLabel: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>',
			name: 'BL_SER_NO', 
			xtype: 'uniTextfield'
		},
		{
			fieldLabel: '<t:message code="system.label.trade.blno" default="B/L번호"/>',
			name: 'BL_NO', 
			xtype: 'uniTextfield'
		},
		{
			fieldLabel: '발주일',
			xtype: 'uniDateRangefield',
			startFieldName: 'BL_DATE_FR',
			endFieldName: 'BL_DATE_TO',
			allowBlank: false,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315
		},
		Unilite.popup('CUST',{
				fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
				valueFieldName: 'EXPORTER', 
				colspan:2,
				textFieldName: 'EXPORTER_NM'
			})
		]
	});
	
	var panelResult = Unilite.createSearchForm('tit100ukrvresultForm',{
		title   : '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',	
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2
		,tableAttrs: { style: { width: '100%'} }
		
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				colspan:2,
				comboType: 'BOR120',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {	
							masterForm.setValue('DIV_CODE', newValue);
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
			},{
			fieldLabel: '통관관리번호', 
			xtype:'uniTextfield',
			name:'PASS_SER_NO',
			listeners: {
				render: function(p) { 
					     p.getEl().on('dblclick', function(p){ 
					     	
					     })
				}
			}
				
			},
			{
				xtype:'form',cloumn:3,
				width:250,
				margin:'0 0 0 400',
				border:false, 
				items:[
					{
						text: '<t:message code="system.label.trade.shipmentapply" default="선적적용"/>', 
						margin:'0 10 0 0',
						xtype:'button',
						handler: function() {
							panelReff.setValue("DIV_CODE",panelSearch.getValue("DIV_CODE"));
					    	openSearchInfoWindow();
				    	} 
					},{
						text: '내역등록', 
						xtype:'button',
						id:'btn_2',
						margin:'0 10 0 0',
						handler: function() {
					    	var params = {
					    		"TRADE_DIV":'I',
					    		"PASS_SER_NO":panelResult.getValue("PASS_SER_NO"),
					    		"PASS_AMT_UNIT":panelResult.getValue("PASS_AMT_UNIT"),
					    		"PASS_EXCHANGE_RATE":panelResult.getValue("PASS_EXCHANGE_RATE"),
					    		"PAY_METHODE":panelResult.getValue("PAY_METHODE"),
					    		"EXPORTER":panelResult.getValue("EXPORTER"),
					    		"APP_DATE":panelResult.getValue("APP_DATE"),
					    		"OUTPUT_DATE":panelResult.getValue("OUTPUT_DATE"),
					    		"BL_SER_NO":panelResult.getValue("BL_SER_NO"),
					    		"TRADE_TYPE":panelResult.getValue("TRADE_TYPE"),
					    		"DIV_CODE"  :panelResult.getValue("DIV_CODE")
					    	}
				    		var rec1 = {data : {prgID : 'tit100ukr', 'text':''}};							
							parent.openTab(rec1, '/trade/tit100ukr.do', params);
				    	} 
					},{
						text: '<t:message code="system.label.trade.expenseentry" default="경비등록"/>', 
						xtype:'button',
						id:'btn_3',
						margin:'0 10 0 0',
						handler: function() {
					    	var params = {
					    		"TRADE_DIV":'P',
					    		"BASIC_PAPER_NO":panelResult.getValue("PASS_SER_NO"),
					    		//"TRADE_CUSTOM_CODE":panelResult.getValue("EXPORTER"),
					    		"CUST_CODE":panelResult.getValue("EXPORTER"),
					    		"DIV_CODE"  :panelResult.getValue("DIV_CODE")
					    	}
				    		var rec1 = {data : {prgID : 'tix100ukrv', 'text':''}};							
							parent.openTab(rec1, '/trade/tix100ukrv.do', params);
				    	} 
					}
				]
			},	
			
				{
				name: 'page',
				hidden:true,
				xtype: 'uniTextfield',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue("page",newValue);
						}
					}
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
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
    });		
   	
	var masterForm = Unilite.createSearchForm('masterForm',{
        region: 'center',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        autoScroll: true,
//        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            xtype: 'container',
            colspan: 3,
            layout: {type: 'uniTable', columns: 4},
            items:[{
                fieldLabel: '통관 관리번호',
                name: 'PASS_SER_NO',
                xtype: 'uniTextfield',
                readOnly: true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '<t:message code="system.label.trade.tradetype" default="무역종류"/>',
                name: 'TRADE_TYPE',
                xtype: 'uniCombobox',
                comboType:'0',
                comboCode:'T002',
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },
            Unilite.popup('PROJECT', {
                fieldLabel: '프로젝트 NO',
                readOnly:true,
                colspan:3,
                valueFieldName: 'PjctCD', 
                textFieldName: 'PjctNM'   
            }),{
                fieldLabel: '통관일',
                name: 'INVOICE_DATE',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                allowBlank: false,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '송장번호',
                name: 'INVOICE_NO',
                xtype: 'uniTextfield',
                allowBlank: false,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '면허번호',
                name: 'EP_NO',
                xtype: 'uniTextfield',
                colspan:2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },{
                fieldLabel: '면허일',
                name: 'EP_DATE',
                xtype: 'uniDatefield',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '<t:message code="system.label.trade.reportdate" default="신고일"/>',
                name: 'ED_DATE',
                xtype: 'uniDatefield',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '<t:message code="system.label.trade.reportno" default="신고번호"/>',
                name: 'ED_NO',
                xtype: 'uniTextfield',
                colspan:2,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '요청일',
                name: 'APP_DATE',
                xtype: 'uniDatefield',
                value:UniDate.get('today'),
                allowBlank: false,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '도착일',
                name: 'DISCHGE_DATE',
                xtype: 'uniDatefield',
                allowBlank: false,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>',
                name: 'SHIP_FIN_DATE',
                xtype: 'uniDatefield',
                colspan:2,
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '신고자',
                name: 'REPORTOR',
                xtype: 'uniCombobox',
                comboType: '0',
                comboCode: 'T029',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '선박국적',
                name: 'VESSEL_NATION_CODE',
                xtype: 'uniCombobox',
                comboType: '0',
                comboCode: 'B012',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: 'VESSEL명',
                name: 'VESSEL_NM',
                xtype: 'uniTextfield',
                width:400,
                colspan:2,
                comboType: 'BOR120',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.trade.arrivalport" default="도착항"/>',
                name: 'DEST_PORT',
                xtype: 'uniCombobox',
                comboType: '0',
                comboCode: 'T008',
                allowBlank: false,
                listeners: {
                        render:function(elm){
                            elm.on('select',function(queryPlan,eOpts)  {
                                var selectdata=eOpts.data;
                                console.log("selectdata:",selectdata);
                                masterForm.setValue("DEST_PORT",selectdata.value);
                                masterForm.setValue("DEST_PORT_NM",selectdata.text);
                            });
                        }
                    }
            },{
                name: 'DEST_PORT_NM',
                xtype: 'uniTextfield',
                width:245,            
                allowBlank: false,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '<t:message code="system.label.trade.shipmentport" default="선적항"/>',
                name: 'SHIP_PORT',
                xtype: 'uniCombobox',
                comboType: '0',
                comboCode: 'T008',
                allowBlank: false,
                listeners: {
                        render:function(elm){
                            elm.on('select',function(queryPlan,eOpts)  {
                                var selectdata=eOpts.data;
                                console.log("selectdata:",selectdata);
                                masterForm.setValue("SHIP_PORT",selectdata.value);
                                masterForm.setValue("SHIP_PORT_NM",selectdata.text);
                            });
                        }
                    }
            },{
                name: 'SHIP_PORT_NM',
                xtype: 'uniTextfield',
                width:155,
                allowBlank: false,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '신고구분',
                name: 'EP_TYPE',
                xtype: 'uniCombobox',
                comboType: '0',
                comboCode: 'T021',
                allowBlank: false,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '장치확인번호',
                name: 'DEVICE_NO',
                xtype: 'uniTextfield',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '장치장소',
                name: 'DEVICE_PLACE',
                xtype: 'uniTextfield',
                width:400,
                colspan:2,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '검사구분',
                name: 'INSPECT_TYPE',
                xtype: 'uniCombobox',
                comboType: '0',
                comboCode: 'T011',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '세관',
                name: 'CUSTOMS',
                xtype: 'uniCombobox',
                comboType: '0',
                comboCode: 'T009',
                allowBlank: false,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '조사란',
                name: 'EXAM_TXT',
                width:400,
                xtype: 'uniTextfield',
                colspan:2,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                fieldLabel: '<t:message code="system.label.trade.packagingtype" default="포장형태"/>',
                name: 'PACKING_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'T026',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },{
                fieldLabel: '총포장갯수',
                name: 'TOT_PACKING_COUNT',
                xtype: 'uniNumberfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},
                colspan: 2,
                items:[{
                    fieldLabel: '총중량',
                    name: 'GROSS_WEIGHT',
                    xtype:'uniNumberfield',
                    width:175
                },{
                    name: 'WEIGHT_UNIT',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'B013', 
                    displayField: 'value'
                }]
            },{
                fieldLabel: '통관환율',
                name: 'PASS_EXCHANGE_RATE',
                xtype:'uniNumberfield',
                decimalPrecision:UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.') : 0,
                value: '1',
                allowBlank: false,
                value:0.0,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            masterForm.setValue("PASS_AMT_WON",masterForm.getValue("PASS_AMT")*newValue);
                        }
                    }
            },{
                fieldLabel: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>',
                name: 'PASS_AMT_WON',
                xtype:'uniNumberfield',
                value:0.0,
                decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 3},
                colspan: 2,
                items:[{
                    fieldLabel: '통관금액',
                    name: 'PASS_AMT',
                    xtype:'uniNumberfield',
                    decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                    readOnly:true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            masterForm.setValue("PASS_AMT_WON",masterForm.getValue("PASS_EXCHANGE_RATE")*newValue);
                        }
                    },
                    width:175
                },{
                    name: 'PASS_AMT_UNIT',
                    xtype: 'uniCombobox',
                    comboType: 'AU',
                    comboCode: 'B004',
                    displayField: 'value',
                    allowBlank: false,
                    value:UserInfo.divCode,
                    fieldStyle: 'text-align: center;',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    margin: '0 0 0 6',
                    xtype: 'button',
                    id: 'startButton',
                    text: '추가입력',
                    handler : function() {
                        if(Ext.getCmp('hiddenArea').isHidden()){
                           Ext.getCmp('hiddenArea').show();   
                        }else{
                           Ext.getCmp('hiddenArea').hide();
                        }
                    }
                }]
            }]
        },{
            xtype: 'container',
            colspan: 3,
            layout: {type: 'vbox', align: 'stretch'},
            items:[{
                xtype: 'container',
                id: 'hiddenArea',
                layout: {type: 'uniTable', columns: 3},
                items:[{
                    fieldLabel: 'USD 환율',
                    name: 'CIF_EXCHANGE_RATE',                    
                    xtype:'uniNumberfield',
                    decimalPrecision:UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.') : 0,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: 'CIf 원화금액',
                    name: 'CIF_AMT_WON',
                    
                    xtype:'uniNumberfield',
                    value:0.0,
                    decimalPrecision:UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.') : 0,
                    readOnly:true,
                    listeners: {
                            change: function(field, newValue, oldValue, eOpts) {                        
                            }
                        }
                },{
                    xtype: 'container',
                    layout: {type: 'uniTable', columns: 2},
                    colspan: 2,
                    items:[{
                        fieldLabel: 'CIf 금액(USD)',
                        name: 'CIF_AMT',
                        xtype:'uniNumberfield',
                        decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                        listeners:{
                            change: function(field, newValue, oldValue, eOpts) {    
                                masterForm.setValue("CIF_AMT_WON",newValue*masterForm.getValue("CIF_EXCHANGE_RATE"));
                            }                            
                        },
                        width:175
                    },{
                        name: 'CIF_AMT_UNIT',
                        xtype: 'uniCombobox',
                        displayField: 'value',
                        comboType: 'AU',
                        comboCode: 'B004',
                        fieldStyle: 'text-align: center;',
                        listeners:{
                            render:function(elm)    {
                                elm.on('beforequery',function(queryPlan, eOpts)  {
                                    var store = queryPlan.combo.store;
                                   // store.clearFilter();
                                    store.filterBy(function(item){
                                        return item.get('refCode3') == 1;
                                    })
                                
                                });
                                elm.on('select',function(queryPlan,eOpts)  {
                                    var selectdata=eOpts.data;
                                     console.log("eOpts : ",eOpts.data);
                                    masterForm.setValue("CIF_EXCHANGE_RATE",1.0);
                                });
                            }
                        }
                    }]
                },
                Unilite.popup('CUST',{
                    fieldLabel: '<t:message code="system.label.trade.importer" default="수입자"/>',
                    valueFieldName: 'IMPORTER', 
                    textFieldName: 'IMPORTER_NM',
                    readOnly:true,
                    colspan: 2
                }),
                Unilite.popup('CUST',{
                    fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
                    valueFieldName: 'EXPORTER', 
                    colspan:4,
                    textFieldName: 'EXPORTER_NM',
                    readOnly:true
                }),{
                    fieldLabel: '<t:message code="system.label.trade.payingterm" default="결제방법"/>',
                    name: 'PAY_METHODE',
                    xtype: 'uniCombobox',
                    comboType:'0',
                    comboCode:'T016',
                    readOnly:true,
                    listeners: {
                            change: function(field, newValue, oldValue, eOpts) {                        
                            }
                        }
                }
                ,{
                    fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',
                    name: 'TERMS_PRICE',
                    xtype: 'uniCombobox',
                    comboType:'0',
                    comboCode:'T005',
                    readOnly:true,
                    listeners: {
                            change: function(field, newValue, oldValue, eOpts) {                        
                            }
                        }
                },{
                    xtype: 'container',
                    layout: {type: 'uniTable', columns: 2},
                    colspan: 2,
                    items:[{
                        fieldLabel: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>',  
                        name: 'PAY_TERMS',
                        xtype: 'uniCombobox',
                        comboType:'0',
                        comboCode:'T006',
                        readOnly:true,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {                        
                            }
                        }
                    },{
                        name: 'PAY_DURING',
                        xtype: 'uniTextfield',
                        width:80,
                        readOnly:true,
                        suffixTpl: 'Day',
                        listeners: {
//                           render: function(obj) {
//                                 var font=document.createElement("font");
//                                 font.setAttribute("vertical-align","middle");
//                                 var tips=document.createTextNode('Day');
//                                 font.appendChild(tips);
//                                obj.el.dom.parentNode.appendChild(font);
//                             }
                        }
                    }]
                },{
                    fieldLabel: '관세',
                    name: 'TARIFF_TAX',
                    xtype:'uniNumberfield',
                    decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '부가세',
                    name: 'VALUE_TAX',
                    xtype:'uniNumberfield',
                    decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '소득세',
                    name: 'INCOME_TAX',
                    xtype:'uniNumberfield',
                    decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '주민세',
                    name: 'INHA_TAX',
                    xtype:'uniNumberfield',
                    decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '교육세',
                    name: 'EDUC_TAX',
                    xtype:'uniNumberfield',
                    decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '교통세',
                    name: 'TRAF_TAX',
                    xtype:'uniNumberfield',
                    decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '농특세',
                    name: 'ARGRI_TAX',
                    xtype:'uniNumberfield',
                    decimalPrecision:UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '계산서발행일',
                    name: 'TAXBILL_DATE',
                    xtype: 'uniDatefield',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '계산서번호',
                    name: 'TAXBILL_NO',
                    xtype: 'uniTextfield',
                    colspan:3,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '반입번호',
                    name: 'INPUT_NO',
                    xtype: 'uniTextfield',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '반입일',
                    name: 'INPUT_DATE',
                    xtype: 'uniDatefield',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '반출일',
                    name: 'OUTPUT_DATE',
                    xtype: 'uniDatefield',
                    colspan:2,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '<t:message code="system.label.trade.transporttype" default="운송형태"/>',
                    name: 'FORM_TRANS',
                    xtype: 'uniCombobox',
                    comboType: '0',
                    comboCode: 'T027',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    fieldLabel: '납부일',
                    name: 'PAYMENT_DATE',
                    xtype: 'uniDatefield',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                }
                ,{
                    fieldLabel: '<t:message code="system.label.trade.deliverydate" default="납기일"/>',
                    name: 'DVRY_DATE',
                    colspan:3,
                    xtype: 'uniDatefield',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                }
                
                ,{
                    fieldLabel: '비고',
                    name: 'REMARKS1',
                    xtype: 'uniTextfield',
                    colspan:4,
                    width:735,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                }
                ,{
                    name: 'REMARKS2',
                    xtype: 'uniTextfield',
                    colspan:4,
                    margin:'0 0 0 95',
                    width:640,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },{
                    name: 'REMARKS3',
                    xtype: 'uniTextfield',
                    colspan:4,
                    margin:'0 0 0 95',
                    width:640,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                }]
            },{
                fieldLabel: 'DIV_CODE',
                name: 'DIV_CODE',
                xtype: 'uniTextfield',
                hidden:true,
                allowBlank: false,
                value:UserInfo.divCode,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                hidden:true,
                fieldLabel: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>',
                name: 'BL_SER_NO',
                xtype: 'uniTextfield',
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                name: 'OPR_FLAG',
                xtype: 'uniTextfield',
                hidden:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                name: 'PROJECT_NO',
                xtype: 'uniTextfield',
                hidden:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                name: 'SO_SER_NO',
                hidden:true,
                xtype: 'uniTextfield',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            },{
                name: 'LC_SER_NO',
                hidden:true,
                xtype: 'uniTextfield',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
            }]
        }],     
        api: {
            load: 'tit101ukrvService.selectMaster',
            submit: 'tit101ukrvService.syncForm'                
        },
        listeners: {
            uniOnChange:function( basicForm, field, newValue, oldValue ) {     
//                if(!oldValue) return false;
//                if(basicForm.isDirty() && newValue != oldValue && detailStore.data.items[0]) {
//                    UniAppManager.setToolbarButtons('save', true);
//                }else {
//                    UniAppManager.setToolbarButtons('save', false);
//                }
//                if(Ext.isEmpty(basicForm.getField('TOT_PACKING_COUNT').getValue())){
//                    basicForm.getField('TOT_PACKING_COUNT').setValue(0);
//                }
            }
         },
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
        },
        setLoadRecord: function(record) {
            var me = this;          
            me.uniOpt.inLoading=false;
//          me.setAllFieldsReadOnly(true);
        },
        loadForm: function(record)  {
//                this.reset();
            this.setActiveRecord(record || null);   
            this.resetDirtyStatus();
        }
    });
    
	var reffGrid=Unilite.createGrid('tit100ukrvGrid', {
		layout : 'fit',       
		store: directReffStore,
		selModel : {
			selType : 'rowmodel',
			mode : 'SINGLE'
			},
		uniOpt:{	
			expandLastColumn: false,
			useRowNumberer: false
		},
        columns: [ 
			{ dataIndex: 'DIV_CODE'	    		,  width: 180},
			{ dataIndex: 'BL_SER_NO'		    ,  width: 133},
			{ dataIndex: 'BL_NO'		    	,  width: 93,align:'center'},
			{ dataIndex: 'BL_DATE'		    	,  width: 133},
			{ dataIndex: 'IMPORTER_NM'	   		,  width: 80,hidden:true},
			{ dataIndex: 'EXPORTER_NM'	   		,  width: 80}, 
			{ dataIndex: 'PAY_TEMRS'	   		,  width: 80}, 
			{ dataIndex: 'TERMS_PRICE'		    ,  width: 93,align:'center'},
			{ dataIndex: 'EXCHANGE_RATE'	    ,  width: 66,align:'center',hidden:true},
			{ dataIndex: 'BL_AMT'		    	,  width: 100,hidden:true},
			{ dataIndex: 'BL_AMT_WON'      		,  width: 100,hidden:true},
			{ dataIndex: 'TRADE_TYPE'		    ,  width: 66,hidden:true},
			{ dataIndex: 'NATION_INOUT'		    ,  width: 66,hidden:true},
			{ dataIndex: 'PROJECT_NO'	    	,  width: 66,hidden:true},
			{ dataIndex: 'EXPENSE_FLAG'			,  width: 66,hidden:true},
			{ dataIndex: 'INVOICE_NO'	    	,  width: 66,hidden:true},
			{ dataIndex: 'CUSTOMS'		    	,  width: 66,hidden:true},
			{ dataIndex: 'EP_TYPE'		    	,  width: 66,hidden:true},
			{ dataIndex: 'LC_NO'		    	,  width: 66,hidden:true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				this.returnData();
				SearchInfoWindow.hide();
			}
		},
		returnData:function()	{
			var record = this.getSelectedRecord();
			panelSearch.setValue("PASS_SER_NO",'');
            panelResult.setValue("PASS_SER_NO",'');
			var r = {
			   PASS_SER_NO:'',                
               PASS_AMT:record.data.PASS_AMT,
               PASS_AMT_UNIT:record.data.AMT_UNIT,
               SHIP_FIN_DATE:record.data.BL_DATE,
               BL_SER_NO:record.data.BL_SER_NO,
               CUSTOMS:record.data.CUSTOMS,
               DEST_PORT:record.data.DEST_PORT,
               DEST_PORT_NM:record.data.DEST_PORT_NM,
               EP_TYPE:record.data.EP_TYPE,
               PASS_EXCHANGE_RATE:record.data.EXCHANGE_RATE,
               EXPORTER:record.data.EXPORTER,
               EXPORTER_NM:record.data.EXPORTER_NM,
               GROSS_WEIGHT:record.data.GROSS_WEIGHT,
               IMPORTER:record.data.IMPORTER,
               IMPORTER_NM:record.data.IMPORTER_NM,
               INVOICE_NO:record.data.INVOICE_NO,
               LC_SER_NO:record.data.LC_SER_NO,
               PACKING_TYPE:record.data.PACKING_TYPE,
               PAY_DURING:record.data.PAY_DURING,
               PAY_METHODE:record.data.PAY_METHODE,
               PAY_TERMS:record.data.PAY_TEMRS,
               PROJECT_NO:record.data.PROJECT_NO,
               SHIP_PORT:record.data.SHIP_PORT,
               SHIP_PORT_NM:record.data.SHIP_PORT_NM,
               SO_SER_NO:record.data.SO_SER_NO,
               TERMS_PRICE:record.data.TERMS_PRICE,
               TRADE_TYPE:record.data.TRADE_TYPE,
               VESSEL_NATION_CODE:record.data.VESSEL_NATION_CODE,
               WEIGHT_UNIT:record.data.WEIGHT_UNIT,
               APP_DATE:UniDate.get('today'),
               INVOICE_DATE:UniDate.get('today')
			}
			masterGrid.createRow(r);
			Ext.getCmp("btn_2").enable();
			Ext.getCmp("btn_3").enable();
//			masterForm.loadForm(record);
//			masterForm.setActiveRecord(record);
			
			
			
//			Ext.each(records, function(record,i){	
				//masterForm.setValue("AGREE_PRSN",record.data.AGREE_PRSN);
				//masterForm.setValue("AGREE_PRSN_NAME",record.data.AGREE_PRSN_NAME);
//				console.log("record",record);
//				masterForm.setValue("PASS_SER_NO",'');
//				panelSearch.setValue("PASS_SER_NO",'');
//				panelResult.setValue("PASS_SER_NO",'');
//				masterForm.setValue("PASS_AMT",record.data.PASS_AMT);
//				masterForm.setValue("PASS_AMT_UNIT",record.data.AMT_UNIT);
//				//masterForm.setValue("BL_AMT",record.data.BL_AMT);
//				//masterForm.setValue("BL_AMT_WON",record.data.BL_AMT_WON);
//				masterForm.setValue("SHIP_FIN_DATE",record.data.BL_DATE);
//				//masterForm.setValue("BL_NO",record.data.BL_NO);
//				masterForm.setValue("BL_SER_NO",record.data.BL_SER_NO);
//				masterForm.setValue("CUSTOMS",record.data.CUSTOMS);
//				//masterForm.setValue("DATE_SHIPPING",record.data.DATE_SHIPPING);
//				masterForm.setValue("DEST_PORT",record.data.DEST_PORT);
//				masterForm.setValue("DEST_PORT_NM",record.data.DEST_PORT_NM);
//				masterForm.setValue("EP_TYPE",record.data.EP_TYPE);
//				masterForm.setValue("PASS_EXCHANGE_RATE",record.data.EXCHANGE_RATE);
//				//masterForm.setValue("EXPENSE_FLAG",record.data.EXPENSE_FLAG);
//				masterForm.setValue("EXPORTER",record.data.EXPORTER);
//				masterForm.setValue("EXPORTER_NM",record.data.EXPORTER_NM);
//				masterForm.setValue("GROSS_WEIGHT",record.data.GROSS_WEIGHT);
//				masterForm.setValue("IMPORTER",record.data.IMPORTER);
//				masterForm.setValue("IMPORTER_NM",record.data.IMPORTER_NM);
//				masterForm.setValue("INVOICE_NO",record.data.INVOICE_NO);
//				//masterForm.setValue("LC_NO",record.data.LC_NO);
//				masterForm.setValue("LC_SER_NO",record.data.LC_SER_NO);
//				//masterForm.setValue("NATION_INOUT",record.data.NATION_INOUT);
//				masterForm.setValue("PACKING_TYPE",record.data.PACKING_TYPE);
//				masterForm.setValue("PAY_DURING",record.data.PAY_DURING);
//				masterForm.setValue("PAY_METHODE",record.data.PAY_METHODE);
//				masterForm.setValue("PAY_TERMS",record.data.PAY_TEMRS);
//				//masterForm.setValue("PROJECT_NAME",record.data.PROJECT_NAME);
//				masterForm.setValue("PROJECT_NO",record.data.PROJECT_NO);
//				//masterForm.setValue("RECEIVE_AMT",record.data.RECEIVE_AMT);
//				masterForm.setValue("SHIP_PORT",record.data.SHIP_PORT);
//				masterForm.setValue("SHIP_PORT_NM",record.data.SHIP_PORT_NM);
//				masterForm.setValue("SO_SER_NO",record.data.SO_SER_NO);
//				masterForm.setValue("TERMS_PRICE",record.data.TERMS_PRICE);
//				masterForm.setValue("TRADE_TYPE",record.data.TRADE_TYPE);
//				//masterForm.setValue("VESSEL_NAME",record.data.AGREE_PRSN);
//				masterForm.setValue("VESSEL_NATION_CODE",record.data.VESSEL_NATION_CODE);
//				masterForm.setValue("WEIGHT_UNIT",record.data.WEIGHT_UNIT);
//DIV_CODE
//			});
		}
	});
    
	function openSearchInfoWindow() {			//선적적용
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
            	title: '<t:message code="system.label.trade.shipmentapply" default="선적적용"/>',
                width: 800,				                
                height: 500,
                layout: {type:'vbox', align:'stretch'},	                
                items: [panelReff, reffGrid], 
                tbar:  ['->',
								        {	itemId : 'saveBtn',
											text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
											handler: function() {
												directReffStore.loadStoreRecords();
											},
											disabled: false
										}, 
										{	itemId : 'confirmBtn',
											text: '<t:message code="system.label.trade.shipmentapply" default="선적적용"/>',
											handler: function() {
												reffGrid.returnData();
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											text: '선적적용 후 닫기',
											handler: function() {
												reffGrid.returnData();
												SearchInfoWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '<t:message code="system.label.trade.close" default="닫기"/>',
											handler: function() {
												SearchInfoWindow.hide();
											},
											disabled: false
										}
					],
				listeners : {
					beforehide: function(me, eOpt)	{
						panelReff.clearForm();
						reffGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						panelReff.clearForm();
						reffGrid.reset();
					},
					show: function( panel, eOpts )	{
					 	
			        }
				}		
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
    }
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,masterForm/*, masterGrid*/
			]
		},
			panelSearch ],
		id: 'tit100ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('APP_DATE',UniDate.get('today'));
			masterForm.setValue('INVOICE_DATE',UniDate.get('today'));
			masterForm.setValue('GROSS_WEIGHT',0.0);
			masterForm.setValue('PASS_AMT_UNIT',0.0);
			masterForm.setValue('TOT_PACKING_COUNT',0.0);
			masterForm.setValue('PASS_AMT_WON',0.0);
			masterForm.setValue('CIF_AMT',0.0);
			masterForm.setValue('CIF_EXCHANGE_RATE',0.0);
			masterForm.setValue('CIF_AMT_WON',0.0);
			masterForm.setValue('TARIFF_TAX',0.0);
			masterForm.setValue('VALUE_TAX',0.0);
			masterForm.setValue('INCOME_TAX',0.0);
			masterForm.setValue('INHA_TAX',0.0);
			masterForm.setValue('EDUC_TAX',0.0);
			masterForm.setValue('TRAF_TAX',0.0);
			masterForm.setValue('ARGRI_TAX',0.0);
			masterForm.setValue('PASS_AMT',0.0);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			Ext.getCmp('btn_2').disable();  
			Ext.getCmp('btn_3').disable();  
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('prev',true);
			UniAppManager.setToolbarButtons('next',true);
			UniAppManager.setToolbarButtons('newData',false);
		},
		onQueryButtonDown: function() {	
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterForm.clearForm();
                masterForm.resetDirtyStatus();
                directMasterStore.loadStoreRecords();
                Ext.getCmp("btn_2").enable();
                Ext.getCmp("btn_3").enable();                                
			}			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();			
			panelResult.clearForm();			
			masterForm.clearForm();
			UniAppManager.setToolbarButtons('save', false);	
			UniAppManager.setToolbarButtons('deleteAll', false);	
			this.fnInitBinding();
		},		
		onPrevDataButtonDown:  function()	{
			panelSearch.setValue("page","prev");
			var param= panelSearch.getValues();
				masterForm.uniOpt.inLoading=true;
				Ext.getBody().mask('로딩중...','loading-indicator');
				masterForm.getForm().load({
					params: param,
					success:function(actionform, action)	{
						panelSearch.setValue("PASS_SER_NO",action.result.data.PASS_SER_NO);
						panelResult.setValue("PASS_SER_NO",action.result.data.PASS_SER_NO);
						masterForm.uniOpt.inLoading=false;
						UniAppManager.setToolbarButtons('deleteAll',true);
						Ext.getCmp("btn_2").enable();
						Ext.getCmp("btn_3").enable();
						Ext.getBody().unmask();
					},
					 failure: function(batch, option) {
					 	console.log("option:",option);
					 	Ext.Msg.alert("확인",'<t:message code="unilite.msg.sMS035"  default="자료의 처음입니다" />');
						//UniAppManager.app.onResetButtonDown();
					 	masterForm.uniOpt.inLoading=false;
					 	Ext.getBody().unmask();					 
					 }
				});
			console.log("param:",param);
		   
		    UniAppManager.setToolbarButtons('excel',true);
		},
		onNextDataButtonDown:  function()	{
			panelSearch.setValue("page","next");
			var param= panelSearch.getValues();
				masterForm.uniOpt.inLoading=true;
				Ext.getBody().mask('로딩중...','loading-indicator');
				masterForm.getForm().load({
					params: param,
					success:function(actionform, action)	{
						panelSearch.setValue("PASS_SER_NO",action.result.data.PASS_SER_NO);
						panelResult.setValue("PASS_SER_NO",action.result.data.PASS_SER_NO);
						masterForm.uniOpt.inLoading=false;
						UniAppManager.setToolbarButtons('deleteAll',true);
						Ext.getCmp("btn_2").enable();
						Ext.getCmp("btn_3").enable();
						Ext.getBody().unmask();
					},
					 failure: function(batch, option) {
					 	console.log("option:",option);
					 	Ext.Msg.alert("확인",'<t:message code="unilite.msg.sMS036"  default="자료의 마지막입니다" />');
					 	masterForm.uniOpt.inLoading=false;
					 	Ext.getBody().unmask();					 
					 }
				});
			console.log("param:",param);
		   
		    UniAppManager.setToolbarButtons('excel',true);
		},
		onDeleteDataButtonDown:function(){
			
		},
		onDeleteAllButtonDown:function(){
			masterForm.setValue("OPR_FLAG","D");
			var param= masterForm.getValues();
			masterForm.getForm().submit({
				params:param,
				waitMsg: 'Uploading...',
				success:function(form, action){
	 					masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();	
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('save', false);	
	            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
				}
			});
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();			
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	
};
</script>
