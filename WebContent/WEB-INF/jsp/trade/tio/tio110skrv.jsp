<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tio110skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="tio110skrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="0" comboCode="T016" /> <!-- 결제방법 콤보 -->
	<t:ExtComboStore comboType="0" comboCode="M201" /> <!-- 구매담당 콤보 -->
	<t:ExtComboStore comboType="0" comboCode="M007" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="0" comboCode="T006" /> <!-- <t:message code="system.label.trade.paymentcondition" default="결제조건"/> -->
	<t:ExtComboStore comboType="0" comboCode="T005" /> <!-- 가격조건 -->
	<t:ExtComboStore comboType="0" comboCode="B001" /> <!-- 사업장 -->
	<t:ExtComboStore comboType="0" comboCode="A020" /> <!-- 종료여부 -->
	<t:ExtComboStore comboType="W" comboCode="A" /> <!-- 창고 -->
	<t:ExtComboStore comboType="0" comboCode="B020" /> <!-- 계정 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('tio110skrvModel', {
	    fields: [
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.trade.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'SPEC'				, text: '<t:message code="system.label.trade.spec" default="규격"/>'			, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '거래처명'		, type: 'string'},
	    	{name: 'CUSTOM_CODE'		, text: '거래처코드'	, type: 'string'},
	    	{name: 'ORDER_PRSN'			, text: '담당자명'		, type: 'string' , comboType: 'AU', comboCode: 'H008'},
	    	{name: 'PRSN_NAME'			, text: '<t:message code="system.label.trade.charger" default="담당자"/>'		, type: 'string'},
	    	{name: 'TRADE_TYPE'			, text: '<t:message code="system.label.trade.tradetype" default="무역종류"/>'		, type: 'string', comboType: 'AU', comboCode: 'T002'},
	    	{name: 'PAY_TERMS'			, text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'		, type: 'string', comboType: 'AU', comboCode: 'T006'},
	    	{name: 'PAY_METHODE'		, text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'		, type: 'string'},
	    	{name: 'TRANS_FLAG'			, text: '진행사항'		, type: 'string'},
	    	{name: 'TERMS_PRICE'        , text: '지불조건'		, type: 'string'},
	    	{name: 'ORDER_DATE'         , text: '<t:message code="system.label.trade.contractdate" default="계약일"/>'		, type: 'uniDate'},
	    	{name: 'DVRY_DATE'          , text: '<t:message code="system.label.trade.deliverydate" default="납기일"/>'		, type: 'uniDate'},
	    	{name: 'ORDER_Q'            , text: '구매단위량'	, type: 'uniQty'},
	    	{name: 'ORDER_UNIT'         , text: '구매단위'		, type: 'string'},
	    	{name: 'TRNS_RATE'          , text: '<t:message code="system.label.trade.containedqty" default="입수"/>'			, type: 'string'},
	    	{name: 'STOCK_UNIT_Q'       , text: '재고단위량'	, type: 'uniQty'},
	    	{name: 'STOCK_UNIT'         , text: '재고단위'		, type: 'string'},
	    	{name: 'ORDER_P'            , text: '외화단가'		, type: 'uniQty'},
	    	{name: 'ORDER_O'         	, text: '외화금액'		, type: 'uniFC'},
	    	{name: 'MONEY_UNIT'         , text: '통화'			, type: 'string'},
	    	{name: 'EXCHG_RATE'	        , text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'			, type: 'string'},
	    	{name: 'ORDER_I'			, text: '원화금액'		, type: 'uniPrice'},
	    	{name: 'GU_QTY'				, text: '구매단위발주량', type: 'uniQty'},
	    	{name: 'TRANS_RATE'			, text: '변환계수'		, type: 'string' },
	    	{name: 'JEA_QTY'	    	, text: '재고단위발주량', type: 'uniQty' },
	    	{name: 'LC_QTY'				, text: 'LC수량'		, type: 'uniQty'},
	    	{name: 'BL_QTY'				, text: '선적수량'		, type: 'uniQty'},
	    	{name: 'INSTOCK_Q'			, text: '입고량'		, type: 'uniQty'},
	    	{name: 'UN_Q'				, text: '미입고량'		, type: 'uniQty'},
	    	{name: 'WH_CODE'			, text: '창고'			, type: 'string'},
	    	{name: 'WH_NAME'			, text: '창고명'		, type: 'string'},
	    	{name: 'SO_SER_NO'			, text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
	    	{name: 'SO_SER'				, text: 'OFFER순번'		, type: 'string'},
	    	{name: 'ORDER_NUM'			, text: '발주번호'		, type: 'string'},
	    	{name: 'ORDER_SEQ'			, text: '발주순번'		, type: 'string'},
	    	{name: 'CONTROL_STATUS'		, text: '강제종료'		, type: 'string'},
	    	{name: 'AGREE_STATUS'		, text: '승인'			, type: 'string', comboType: 'AU', comboCode: 'P117'},
	    	{name: 'REMARK'				, text: '비고'			, type: 'string'},
	    	{name: 'PROJECT_NO'			, text: '프로젝트번호'	, type: 'string'}
	    ]
	});
	
	Unilite.defineModel('tio110skrvModel2', {
	    fields: [
	    	{name: 'CUSTOM_NAME'		, text: '거래처명'		, type: 'string'},
	    	{name: 'CUSTOM_CODE'		, text: '거래처코드'	, type: 'string'},
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.trade.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'SPEC'				, text: '<t:message code="system.label.trade.spec" default="규격"/>'			, type: 'string'},
	    	{name: 'ORDER_PRSN'			, text: '담당자명'		, type: 'string' , comboType: 'AU', comboCode: 'H008'},
	    	{name: 'PRSN_NAME'			, text: '<t:message code="system.label.trade.charger" default="담당자"/>'		, type: 'string' },
	    	{name: 'TRADE_TYPE'			, text: '<t:message code="system.label.trade.tradetype" default="무역종류"/>'		, type: 'string', comboType: 'AU', comboCode: 'T002'},
	    	{name: 'PAY_TERMS'			, text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'		, type: 'string', comboType: 'AU', comboCode: 'T006'},
	    	{name: 'PAY_METHODE'		, text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'		, type: 'string'},
	    	{name: 'TRANS_FLAG'			, text: '진행사항'		, type: 'string'},
	    	{name: 'TERMS_PRICE'        , text: '지불조건'		, type: 'string'},
	    	{name: 'ORDER_DATE'         , text: '<t:message code="system.label.trade.contractdate" default="계약일"/>'		, type: 'uniDate'},
	    	{name: 'DVRY_DATE'          , text: '<t:message code="system.label.trade.deliverydate" default="납기일"/>'		, type: 'uniDate'},
	    	{name: 'ORDER_Q'            , text: '구매단위량'	, type: 'uniQty'},
	    	{name: 'ORDER_UNIT'         , text: '구매단위'		, type: 'string'},
	    	{name: 'TRNS_RATE'          , text: '<t:message code="system.label.trade.containedqty" default="입수"/>'			, type: 'string'},
	    	{name: 'STOCK_UNIT_Q'       , text: '재고단위량'	, type: 'uniQty'},
	    	{name: 'STOCK_UNIT'         , text: '재고단위'		, type: 'string'},
	    	{name: 'ORDER_P'            , text: '외화단가'		, type: 'uniQty'},
	    	{name: 'ORDER_O'         	, text: '외화금액'		, type: 'uniFC'},
	    	{name: 'MONEY_UNIT'         , text: '통화'			, type: 'string'},
	    	{name: 'EXCHG_RATE'	        , text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'			, type: 'string'},
	    	{name: 'ORDER_I'			, text: '원화금액'		, type: 'uniPrice'},
	    	{name: 'GU_QTY'				, text: '구매단위발주량', type: 'uniQty'},
	    	{name: 'TRANS_RATE'			, text: '변환계수'		, type: 'string' },
	    	{name: 'JEA_QTY'	    	, text: '재고단위발주량', type: 'uniQty' },
	    	{name: 'LC_QTY'				, text: 'LC수량'		, type: 'uniQty'},
	    	{name: 'BL_QTY'				, text: '선적수량'		, type: 'uniQty'},
	    	{name: 'INSTOCK_Q'			, text: '입고량'		, type: 'uniQty'},
	    	{name: 'UN_Q'				, text: '미입고량'		, type: 'uniQty'},
	    	{name: 'WH_CODE'			, text: '창고'			, type: 'string'},
	    	{name: 'WH_NAME'			, text: '창고명'		, type: 'string'},
	    	{name: 'SO_SER_NO'			, text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
	    	{name: 'SO_SER'				, text: 'OFFER순번'		, type: 'string'},
	    	{name: 'ORDER_NUM'			, text: '발주번호'		, type: 'string'},
	    	{name: 'ORDER_SEQ'			, text: '발주순번'		, type: 'string'},
	    	{name: 'CONTROL_STATUS'		, text: '강제종료'		, type: 'string'},
	    	{name: 'AGREE_STATUS'		, text: '승인'			, type: 'string', comboType: 'AU', comboCode: 'P117'},
	    	{name: 'REMARK'				, text: '비고'			, type: 'string'},
	    	{name: 'PROJECT_NO'			, text: '프로젝트번호'	, type: 'string'}
	    ]
	});
	
	Unilite.defineModel('tio110skrvModel3', {
	    fields: [
	    	{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.trade.charger" default="담당자"/>'		, type: 'string'  , comboType: 'AU', comboCode: 'H008'},
	    	{name: 'PRSN_NAME'			, text: '<t:message code="system.label.trade.charger" default="담당자"/>'		, type: 'string'},
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.trade.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '거래처명'		, type: 'string'},
	    	{name: 'CUSTOM_CODE'		, text: '거래처코드'	, type: 'string'},
	    	{name: 'SPEC'				, text: '<t:message code="system.label.trade.spec" default="규격"/>'			, type: 'string'},
	    	{name: 'TRADE_TYPE'			, text: '<t:message code="system.label.trade.tradetype" default="무역종류"/>'		, type: 'string', comboType: 'AU', comboCode: 'T002'},
	    	{name: 'PAY_TERMS'			, text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'		, type: 'string', comboType: 'AU', comboCode: 'T006'},
	    	{name: 'PAY_METHODE'		, text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'		, type: 'string'},
	    	{name: 'TRANS_FLAG'			, text: '진행사항'		, type: 'string'},
	    	{name: 'TERMS_PRICE'        , text: '지불조건'		, type: 'string'},
	    	{name: 'ORDER_DATE'         , text: '<t:message code="system.label.trade.contractdate" default="계약일"/>'		, type: 'uniDate'},
	    	{name: 'DVRY_DATE'          , text: '<t:message code="system.label.trade.deliverydate" default="납기일"/>'		, type: 'uniDate'},
	    	{name: 'ORDER_Q'            , text: '구매단위량'	, type: 'uniQty'},
	    	{name: 'ORDER_UNIT'         , text: '구매단위'		, type: 'string'},
	    	{name: 'TRNS_RATE'          , text: '<t:message code="system.label.trade.containedqty" default="입수"/>'			, type: 'string'},
	    	{name: 'STOCK_UNIT_Q'       , text: '재고단위량'	, type: 'uniQty'},
	    	{name: 'STOCK_UNIT'         , text: '재고단위'		, type: 'string'},
	    	{name: 'ORDER_P'            , text: '외화단가'		, type: 'uniQty'},
	    	{name: 'ORDER_O'         	, text: '외화금액'		, type: 'uniFC'},
	    	{name: 'MONEY_UNIT'         , text: '통화'			, type: 'string'},
	    	{name: 'EXCHG_RATE'	        , text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'			, type: 'string'},
	    	{name: 'ORDER_I'			, text: '원화금액'		, type: 'uniPrice'},
	    	{name: 'GU_QTY'				, text: '구매단위발주량', type: 'uniQty'},
	    	{name: 'TRANS_RATE'			, text: '변환계수'		, type: 'string' },
	    	{name: 'JEA_QTY'	    	, text: '재고단위발주량', type: 'uniQty' },
	    	{name: 'LC_QTY'				, text: 'LC수량'		, type: 'uniQty'},
	    	{name: 'BL_QTY'				, text: '선적수량'		, type: 'uniQty'},
	    	{name: 'INSTOCK_Q'			, text: '입고량'		, type: 'uniQty'},
	    	{name: 'UN_Q'				, text: '미입고량'		, type: 'uniQty'},
	    	{name: 'WH_CODE'			, text: '창고'			, type: 'string'},
	    	{name: 'WH_NAME'			, text: '창고명'		, type: 'string'},
	    	{name: 'SO_SER_NO'			, text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
	    	{name: 'SO_SER'				, text: 'OFFER순번'		, type: 'string'},
	    	{name: 'ORDER_NUM'			, text: '발주번호'		, type: 'string'},
	    	{name: 'ORDER_SEQ'			, text: '발주순번'		, type: 'string'},
	    	{name: 'CONTROL_STATUS'		, text: '강제종료'		, type: 'string'},
	    	{name: 'AGREE_STATUS'		, text: '승인'			, type: 'string', comboType: 'AU', comboCode: 'P117'},
	    	{name: 'REMARK'				, text: '비고'			, type: 'string'},
	    	{name: 'PROJECT_NO'			, text: '프로젝트번호'	, type: 'string'}
	    ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('tio110skrvMasterStore1', {
		model: 'tio110skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'tio110skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();	
			/*var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}*/
			console.log( param );
			param.QUERY_TYPE="1";
			this.load({
				params: param
			});
		},
		groupField: 'ITEM_CODE'	
	});
	
	var directMasterStore2 = Unilite.createStore('tio110skrvMasterStore2', {
		model: 'tio110skrvModel2',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'tio110skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();	
			/*var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}*/
			console.log( param );
			param.QUERY_TYPE="2";
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME'	
	});
	
	var directMasterStore3 = Unilite.createStore('tio110skrvMasterStore3', {
		model: 'tio110skrvModel3',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'tio110skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();	
			/*var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}*/
			console.log( param );
			param.QUERY_TYPE="3";
			this.load({
				params: param
			});
		},
		groupField: 'PRSN_NAME'	
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
			items: [{
				fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			},
			{
				fieldLabel: '<t:message code="system.label.trade.contractdate" default="계약일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FRORDERDATE',
				endFieldName: 'TOORDERDATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FRORDERDATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TOORDERDATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.trade.payingterm" default="결제방법"/>', 
				name: 'PAYMETHODE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'T016',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAYMETHODE', newValue);
					}
				}
			}]
		},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('CUST', {
					fieldLabel: '거래처', 
					valueFieldName: 'FRCUSTOM_CODE', 
					textFieldName: 'FRCUSTOM_NAME', 
					validateBlank:false, 
					popupWidth: 710,
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {								
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('FRCUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('FRCUSTOM_CODE', '');
							}
						}
					}					
				}),
				Unilite.popup('CUST',{ 
					fieldLabel: '~', 
					valueFieldName: 'TOCUSTOM_CODE', 
					textFieldName: 'TOCUSTOM_NAME', 
					validateBlank: false, 
					popupWidth: 710,
					extParam: {'CUSTOM_TYPE': ['1','2']},
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {								
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('TOCUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('TOCUSTOM_CODE', '');
							}
						}
					}					
				}),
		    	Unilite.popup('ITEM',{ 
		    		fieldLabel: '<t:message code="system.label.trade.itemcode" default="품목코드"/>',
		    		name:'FRITEM',
					validateBlank: false, 		    		
			        valueFieldName: 'FRITEM_CODE', 
					textFieldName: 'FRITEM_NAME',
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {								
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('FRITEM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('FRITEM_CODE', '');
							}
						}
					}					
			        	
		    	}),
				Unilite.popup('ITEM',{ 
					fieldLabel: '~',
					validateBlank: false, 					
		        	valueFieldName: 'TOITEM_CODE', 
					textFieldName: 'TOITEM_NAME',
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {								
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('TOITEM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('TOITEM_CODE', '');
							}
						}
					}						
				}),
			{
				fieldLabel: '<t:message code="system.label.trade.deliverydate" default="납기일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FRDVRYDATE',
				endFieldName: 'TODVRYDATE',
				width:315
			},(
				Unilite.popup('PRO',{
					fieldLabel: '관리번호', 
					name:'PROJECT_NO',
					textFieldWidth: 70
				})
			),{
				fieldLabel: '승인여부', 
				name: 'AGREESTATUS', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A014'
			},{
				fieldLabel: '구매담당', 
				name: 'IMPORTNM', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M201'
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
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value:UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		},{
			fieldLabel: '<t:message code="system.label.trade.contractdate" default="계약일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FRORDERDATE',
			endFieldName: 'TOORDERDATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FRORDERDATE',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TOORDERDATE',newValue);
		    	}
		    }
		},{
			fieldLabel: '<t:message code="system.label.trade.payingterm" default="결제방법"/>', 
			name: 'PAYMETHODE', 
			xtype: 'uniCombobox', 
			comboType: 'AU', 
			comboCode: 'T016',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAYMETHODE', newValue);
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
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
    });		
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('tio110skrvGrid1', {
		layout: 'fit',
		region: 'center',
		excelTitle: '발주현황조회',
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
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: directMasterStore1,
        columns: [
        	{dataIndex: 'ITEM_CODE'			, width: 146 ,locked: true,
		    	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '품목계', '총계');
            	}},
			{dataIndex: 'ITEM_NAME'			, width: 80 ,locked: true},
        	{dataIndex: 'SPEC'				, width: 146 },
        	{dataIndex: 'CUSTOM_NAME'		, width: 146 },
			{dataIndex: 'CUSTOM_CODE'		, width: 80,hidden: true},
        	{dataIndex: 'ORDER_PRSN'		, width: 80 },
			{dataIndex: 'PRSN_NAME'			, width: 80,hidden: true},
			{dataIndex: 'TRADE_TYPE'		, width: 80 ,align: 'center'},
			{dataIndex: 'PAY_TERMS'			, width: 80},
			{dataIndex: 'PAY_METHODE'		, width: 80 ,align: 'center'},
			{dataIndex: 'TRANS_FLAG'		, width: 80},
			{dataIndex: 'TERMS_PRICE'		, width: 80},
			{dataIndex: 'ORDER_DATE'		, width: 93 },
			{dataIndex: 'DVRY_DATE'			, width: 73 ,align: 'center'},
			{dataIndex: 'ORDER_Q'			, width: 93,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 106},
			{dataIndex: 'TRNS_RATE'			, width: 80,hidden: true},
			{dataIndex: 'STOCK_UNIT_Q'		, width: 93,summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'		, width: 106 },
			{dataIndex: 'ORDER_P'			, width: 93 },
			{dataIndex: 'ORDER_O'			, width: 93 ,summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 93 ,align: 'center'},
			{dataIndex: 'EXCHG_RATE'		, width: 100 ,align: 'center'},
			{dataIndex: 'ORDER_I'			, width: 106,summaryType: 'sum'},
			{dataIndex: 'TRANS_RATE'		, width: 100,hidden:true},
			{dataIndex: 'GU_QTY'			, width: 88 ,align: 'center'},
			{dataIndex: 'JEA_QTY'			, width: 66 ,align: 'center'},
			{dataIndex: 'LC_QTY'			, width: 66 ,align: 'center',summaryType: 'sum'},
			{dataIndex: 'BL_QTY'			, width: 80,summaryType: 'sum'},
			{dataIndex: 'INSTOCK_Q'			, width: 66,summaryType: 'sum'},
			{dataIndex: 'UN_Q'				, width: 133,summaryType: 'sum'},
			{dataIndex: 'WH_CODE'			, width: 133,hidden: true},
			{dataIndex: 'WH_NAME'			, width: 120},
			{dataIndex: 'SO_SER_NO'			, width: 120},
			{dataIndex: 'SO_SER'			, width: 80},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'ORDER_SEQ'			, width: 80,hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80},
			{dataIndex: 'AGREE_STATUS'		, width: 80},
			{dataIndex: 'REMARK'			, width: 80},
			{dataIndex: 'PROJECT_NO'		, width: 80}
		] 
    });  
    var masterGrid2 = Unilite.createGrid('tio110skrvGrid2', {
		layout: 'fit',
		region: 'center',
		excelTitle: '발주현황조회',
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
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: directMasterStore2,
        columns: [
        	{dataIndex: 'CUSTOM_NAME'		, width: 146 ,locked: true,
		    	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '거래처계', '총계');
            	}},
			{dataIndex: 'CUSTOM_CODE'		, width: 80,hidden: true},
        	{dataIndex: 'ITEM_CODE'			, width: 120 ,locked: true},
			{dataIndex: 'ITEM_NAME'			, width: 120 ,locked: true},
        	{dataIndex: 'SPEC'				, width: 80 },
        	{dataIndex: 'ORDER_PRSN'		, width: 80 },
			{dataIndex: 'PRSN_NAME'			, width: 146,hidden: true},
			{dataIndex: 'TRADE_TYPE'		, width: 80 ,align: 'center'},
			{dataIndex: 'PAY_TERMS'			, width: 80},
			{dataIndex: 'PAY_METHODE'		, width: 80 ,align: 'center'},
			{dataIndex: 'TRANS_FLAG'		, width: 80},
			{dataIndex: 'TERMS_PRICE'		, width: 80},
			{dataIndex: 'ORDER_DATE'		, width: 93 },
			{dataIndex: 'DVRY_DATE'			, width: 73 ,align: 'center'},
			{dataIndex: 'ORDER_Q'			, width: 93,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 106},
			{dataIndex: 'TRNS_RATE'			, width: 80,hidden: true},
			{dataIndex: 'STOCK_UNIT_Q'		, width: 93,summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'		, width: 106 },
			{dataIndex: 'ORDER_P'			, width: 93 },
			{dataIndex: 'ORDER_O'			, width: 93 ,summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 93 ,align: 'center'},
			{dataIndex: 'EXCHG_RATE'		, width: 100 ,align: 'center'},
			{dataIndex: 'ORDER_I'			, width: 106,summaryType: 'sum'},
			{dataIndex: 'TRANS_RATE'		, width: 100,hidden:true},
			{dataIndex: 'GU_QTY'			, width: 88 ,align: 'center'},
			{dataIndex: 'JEA_QTY'			, width: 66 ,align: 'center'},
			{dataIndex: 'LC_QTY'			, width: 66 ,align: 'center',summaryType: 'sum'},
			{dataIndex: 'BL_QTY'			, width: 80,summaryType: 'sum'},
			{dataIndex: 'INSTOCK_Q'			, width: 66,summaryType: 'sum'},
			{dataIndex: 'UN_Q'				, width: 133,summaryType: 'sum'},
			{dataIndex: 'WH_CODE'			, width: 133,hidden: true},
			{dataIndex: 'WH_NAME'			, width: 120},
			{dataIndex: 'SO_SER_NO'			, width: 120},
			{dataIndex: 'SO_SER'			, width: 80},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'ORDER_SEQ'			, width: 80,hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80},
			{dataIndex: 'AGREE_STATUS'		, width: 80},
			{dataIndex: 'REMARK'			, width: 80},
			{dataIndex: 'PROJECT_NO'		, width: 80}
		] 
    });  
    
     var masterGrid3 = Unilite.createGrid('tio110skrvGrid3', {
		layout: 'fit',
		region: 'center',
		excelTitle: '발주현황조회',
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
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: directMasterStore3,
        columns: [
        	{dataIndex: 'ORDER_PRSN'		, width: 80 ,hidden:true},
			{dataIndex: 'PRSN_NAME'			, width: 146,locked: true,
		    	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '담당자계', '총계');
            	}},
			{dataIndex: 'ITEM_CODE'			, width: 80 ,locked: true},
			{dataIndex: 'ITEM_NAME'			, width: 146 ,locked: true},
			{dataIndex: 'SPEC'				, width: 146 },
        	{dataIndex: 'CUSTOM_NAME'		, width: 146 },
			{dataIndex: 'CUSTOM_CODE'		, width: 80,hidden: true},
			{dataIndex: 'TRADE_TYPE'		, width: 80 ,align: 'center'},
			{dataIndex: 'PAY_TERMS'			, width: 80},
			{dataIndex: 'PAY_METHODE'		, width: 80 ,align: 'center'},
			{dataIndex: 'TRANS_FLAG'		, width: 80},
			{dataIndex: 'TERMS_PRICE'		, width: 80},
			{dataIndex: 'ORDER_DATE'		, width: 93 },
			{dataIndex: 'DVRY_DATE'			, width: 73 ,align: 'center'},
			{dataIndex: 'ORDER_Q'			, width: 93,summaryType: 'sum'},
			{dataIndex: 'ORDER_UNIT'		, width: 106},
			{dataIndex: 'TRNS_RATE'			, width: 80,hidden: true},
			{dataIndex: 'STOCK_UNIT_Q'		, width: 93,summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'		, width: 106 },
			{dataIndex: 'ORDER_P'			, width: 93 },
			{dataIndex: 'ORDER_O'			, width: 93 ,summaryType: 'sum'},
			{dataIndex: 'MONEY_UNIT'		, width: 93 ,align: 'center'},
			{dataIndex: 'EXCHG_RATE'		, width: 100 ,align: 'center'},
			{dataIndex: 'ORDER_I'			, width: 106,summaryType: 'sum'},
			{dataIndex: 'TRANS_RATE'		, width: 100,hidden:true},
			{dataIndex: 'GU_QTY'			, width: 88 ,align: 'center'},
			{dataIndex: 'JEA_QTY'			, width: 66 ,align: 'center'},
			{dataIndex: 'LC_QTY'			, width: 66 ,align: 'center',summaryType: 'sum'},
			{dataIndex: 'BL_QTY'			, width: 80,summaryType: 'sum'},
			{dataIndex: 'INSTOCK_Q'			, width: 66,summaryType: 'sum'},
			{dataIndex: 'UN_Q'				, width: 133,summaryType: 'sum'},
			{dataIndex: 'WH_CODE'			, width: 133,hidden: true},
			{dataIndex: 'WH_NAME'			, width: 120},
			{dataIndex: 'SO_SER_NO'			, width: 120},
			{dataIndex: 'SO_SER'			, width: 80},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'ORDER_SEQ'			, width: 80,hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80},
			{dataIndex: 'AGREE_STATUS'		, width: 80},
			{dataIndex: 'REMARK'			, width: 80},
			{dataIndex: 'PROJECT_NO'		, width: 80}
		] 
    }); 
    
    //创建标签页面板
	var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [
                 {
                     title: '품목별'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid]
                     ,id: 'tio110skrvGridTab'
                 },
                 {
                     title: '거래처별'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid2]
                     ,id: 'tio110skrvGridTab2' 
                 },
                 {
                     title: '담당자별'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid3]
                     ,id: 'tio110skrvGridTab3' 
                 }
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var newTabId = newCard.getId();
                console.log("newCard:  " + newCard.getId());
                console.log("oldCard:  " + oldCard.getId());        
                //탭 넘길때마다 초기화
                UniAppManager.setToolbarButtons(['save', 'newData' ], false);
                panelResult.setAllFieldsReadOnly(false);
                if(newTabId == 'tio110skrvGridTab'){
					panelResult.setAllFieldsReadOnly(false);
			        masterGrid.getStore().loadStoreRecords();
			        UniAppManager.setToolbarButtons('excel',true);
				}
				if(newTabId == 'tio110skrvGridTab2' ){
					panelResult.setAllFieldsReadOnly(false);
					masterGrid2.getStore().loadStoreRecords();
					UniAppManager.setToolbarButtons('excel',true);
				} 
				if(newTabId == 'tio110skrvGridTab3' ){
					panelResult.setAllFieldsReadOnly(false);
					masterGrid3.getStore().loadStoreRecords();
					UniAppManager.setToolbarButtons('excel',true);
				}
//              Ext.getCmp('confirm_check').hide(); //확정버튼 hidden
                
            } 
        }
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
		id: 'tio110skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('FRORDERDATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TOORDERDATE',UniDate.get('today'));
			panelResult.setValue('FRORDERDATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TOORDERDATE',UniDate.get('today'));
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {	
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			/*masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);*/
				var activeTabId = tab.getActiveTab().getId();  
				if(activeTabId == 'tio110skrvGridTab'){
					panelResult.setAllFieldsReadOnly(false);
			         masterGrid.getStore().loadStoreRecords();
			         UniAppManager.setToolbarButtons('excel',true);
				}
				if(activeTabId == 'tio110skrvGridTab2' ){
					panelResult.setAllFieldsReadOnly(false);
					 masterGrid2.getStore().loadStoreRecords();
					 UniAppManager.setToolbarButtons('excel',true);
				} 
				if(activeTabId == 'tio110skrvGridTab3' ){
					panelResult.setAllFieldsReadOnly(false);
					 masterGrid3.getStore().loadStoreRecords();
					 UniAppManager.setToolbarButtons('excel',true);
				}
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};
</script>
