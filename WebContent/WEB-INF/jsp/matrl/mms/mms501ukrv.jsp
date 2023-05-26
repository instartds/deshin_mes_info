<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms501ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 입고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M505" /> <!-- 생성경로 (폼) -->
	<t:ExtComboStore comboType="AU" comboCode="B031" /> <!-- 생성경로 (그리드) -->
	<t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 입고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!-- 품목상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
	<t:ExtComboStore comboType="AU" comboCode="S014" /> <!-- 기표대상 -->
		<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var BsaCodeInfo = {
//	gsInoutTypeDetail: '${gsInoutTypeDetail}',
	gsDefaultData: '${gsDefaultData}',
	gsInTypeAccountYN: ${gsInTypeAccountYN},
	gsExcessRate: '${gsExcessRate}',
	gsInvstatus: '${gsInvstatus}',
	gsProcessFlag: '${gsProcessFlag}',
	gsInspecFlag: '${gsInspecFlag}',
	gsMap100UkrLink: '${gsMap100UkrLink}',
	gsSumTypeLot: '${gsSumTypeLot}',
	gsSumTypeCell: '${gsSumTypeCell}',
	gsDefaultMoney: '${gsDefaultMoney}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/


var gsInoutTypeDetail = Ext.data.StoreManager.lookup('CBS_AU_M103').getAt(0).get('value');
var outDivCode = UserInfo.divCode;




function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mms501ukrvService.selectList',
			update: 'mms501ukrvService.updateDetail',
			create: 'mms501ukrvService.insertDetail',
			destroy: 'mms501ukrvService.deleteDetail',
			syncAll: 'mms501ukrvService.saveAll'
		}
	});


	/**
	 *   Model 정의
	 * @type
	 */

	Unilite.defineModel('Mms501ukrvModel', {
	    fields: [
	    	{name: 'INOUT_NUM'         ,text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>' 			,type: 'string'},
	    	{name: 'INOUT_SEQ'         ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'int', allowBlank: false},
	    	{name: 'INOUT_METH'        ,text: '<t:message code="system.label.purchase.method" default="방법"/>' 				,type: 'string'},
	    	{name: 'INOUT_TYPE_DETAIL' ,text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>' 			,type: 'string',comboType:'AU',comboCode:'M103', allowBlank: false},
	    	{name: 'ITEM_CODE'         ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 			,type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME'         ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>' 			,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'      ,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' 			,type: 'string'},
	    	{name: 'SPEC'              ,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 				,type: 'string'},
	    	{name: 'ORDER_UNIT'        ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>' 			,type: 'string'},


	    	{name: 'CONDITION'         ,text: '조건' 			,type: 'string'},
	    	{name: 'TYPE'        	   ,text: '형태' 			,type: 'string'},




	    	{name: 'ITEM_STATUS'       ,text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>' 			,type: 'string', allowBlank: false},
	    	{name: 'ORIGINAL_Q'        ,text: '<t:message code="system.label.purchase.existinginqty" default="기존입고량"/>' 			,type: 'uniQty'},
	    	{name: 'GOOD_STOCK_Q'      ,text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>' 			,type: 'uniQty'},
	    	{name: 'BAD_STOCK_Q'       ,text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>' 			,type: 'uniQty'},
	    	{name: 'NOINOUT_Q'         ,text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>' 			,type: 'uniQty'},
	    	{name: 'PRICE_YN'          ,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>' 			,type: 'string', allowBlank: false},
	    	{name: 'MONEY_UNIT'        ,text: '<t:message code="system.label.purchase.currency" default="화폐"/>' 				,type: 'string'},
	    	{name: 'INOUT_FOR_P'       ,text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>' 		,type: 'uniUnitPrice'},
	    	{name: 'INOUT_FOR_O'       ,text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>' 		,type: 'uniPrice'},

	    	{name: 'SALE_PRICE'    ,text: '판매가' 			,type: 'uniPrice'},
	    	{name: 'PURCHASE_RATE'     ,text: '매입율' 			,type: 'uniER'},

            {name: 'ORDER_UNIT_FOR_P'  ,text: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>' 				,type: 'uniUnitPrice', allowBlank: false},
            {name: 'ORDER_UNIT_Q'      ,text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>' 			,type: 'uniQty', allowBlank: false},
            {name: 'ORDER_UNIT_FOR_O'  ,text: '<t:message code="system.label.purchase.amount" default="금액"/>' 				,type: 'uniPrice', allowBlank: false},
            {name: 'BAR_CODE'  		   ,text: '바코드' 			,type: 'string'},



	    	{name: 'ACCOUNT_YNC'       ,text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>' 			,type: 'string', allowBlank: false},
	    	{name: 'EXCHG_RATE_O'      ,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>' 				,type: 'uniER'},
	    	{name: 'INOUT_P'           ,text: '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>' 		,type: 'uniUnitPrice'},
	    	{name: 'INOUT_I'           ,text: '<t:message code="system.label.purchase.coamountstock" default="자사금액(재고)"/>' 		,type: 'uniPrice'},
	    	{name: 'ORDER_UNIT_P'      ,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>' 			,type: 'uniPrice'},
	    	{name: 'ORDER_UNIT_I'      ,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>' 			,type: 'uniPrice'},
	    	{name: 'STOCK_UNIT'        ,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>' 			,type: 'string'},
	    	{name: 'TRNS_RATE'         ,text: '<t:message code="system.label.purchase.containedqty" default="입수"/>' 				,type: 'string'},
	    	{name: 'INOUT_Q'           ,text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>' 		,type: 'uniQty', allowBlank: false},
	    	{name: 'ORDER_TYPE'        ,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>' 			,type: 'string', allowBlank: false},
	    	{name: 'LC_NUM'            ,text: 'LC/NO(*)' 		,type: 'string'},
	    	{name: 'BL_NUM'            ,text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>' 			,type: 'string'},
	    	{name: 'ORDER_NUM'         ,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>' 			,type: 'string'},
	    	{name: 'ORDER_SEQ'         ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'int'},
	    	{name: 'ORDER_Q'           ,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>' 			,type: 'uniQty'},
	    	{name: 'INOUT_CODE_TYPE'   ,text: '<t:message code="system.label.purchase.receiptplacetype" default="입고처구분"/>' 			,type: 'string'},
	    	{name: 'WH_CODE'           ,text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>' 			,type: 'string'},
	    	{name: 'WH_CELL_CODE'	   ,text: 'CELL창고' 			,type: 'string'},
	    	{name: 'WH_CELL_NAME'	   ,text: 'CELL창고명' 			,type: 'string'},
	    	{name: 'INOUT_DATE'        ,text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>' 			,type: 'uniDate'},
	    	{name: 'INOUT_PRSN'        ,text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>' 			,type: 'string'},
	    	{name: 'ACCOUNT_Q'         ,text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>' 			,type: 'uniQty'},
	    	{name: 'CREATE_LOC'        ,text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>' 			,type: 'string'},
	    	{name: 'SALE_C_DATE'       ,text: '<t:message code="system.label.purchase.billclosingdate" default="계산서마감일"/>' 		,type: 'uniDate'},
	    	{name: 'REMARK'            ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 				,type: 'string'},
	    	{name: 'PROJECT_NO'        ,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>' 			,type: 'string'},
	    	{name: 'LOT_NO'            ,text: 'LOT NO' 			,type: 'string'},
	    	{name: 'INOUT_TYPE'        ,text: '<t:message code="system.label.purchase.type" default="타입"/>' 				,type: 'string'},
	    	{name: 'INOUT_CODE'        ,text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>' 			,type: 'string'},
	    	{name: 'DIV_CODE'          ,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 			,type: 'string'},
	    	{name: 'CUSTOM_NAME'       ,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>' 			,type: 'string'},
	    	{name: 'COMPANY_NUM'       ,text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>' 			,type: 'string'},
	    	{name: 'INSTOCK_Q'         ,text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>' 		,type: 'uniQty'},
	    	{name: 'SALE_DIV_CODE'     ,text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>' 			,type: 'string'},
	    	{name: 'SALE_CUSTOM_CODE'  ,text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>' 			,type: 'string'},
	    	{name: 'BILL_TYPE'         ,text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>' 			,type: 'string'},
	    	{name: 'SALE_TYPE'         ,text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>' 			,type: 'string'},
	    	{name: 'UPDATE_DB_USER'    ,text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>' 			,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'    ,text: '수정한 날짜' 		,type: 'uniDate'},
	    	{name: 'EXCESS_RATE'       ,text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>' 		,type: 'string'},
	    	{name: 'INSPEC_NUM'        ,text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>' 			,type: 'string'},
	    	{name: 'INSPEC_SEQ'        ,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 				,type: 'int'},
	    	{name: 'COMP_CODE'         ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 			,type: 'string'},
	    	{name: 'BASIS_NUM'         ,text: 'BASIS_NUM' 		,type: 'string'},
	    	{name: 'BASIS_SEQ'         ,text: 'BASIS_SEQ' 		,type: 'int'},
	    	{name: 'SCM_FLAG_YN'       ,text: 'SCM_FLAG_YN' 	,type: 'string'}
		]
	});

	Unilite.defineModel('inoutNoMasterModel', {		//조회버튼 누르면 나오는 조회창
	    fields: [
	    	{name: 'INOUT_NAME'       		    		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'    	, type: 'string'},
	    	{name: 'INOUT_DATE'       		    		, text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'    	, type: 'uniDate'},
	    	{name: 'INOUT_CODE'       		    		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'   , type: 'string'},
	    	{name: 'WH_CODE'          		    		, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'    	, type: 'string',  comboType   : 'OU'},
	    	{name: 'WH_CELL_CODE'     		    		, text: '입고창고Cell' , type: 'string'},
	    	{name: 'DIV_CODE'         		    		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'    	, type: 'string',comboType:'BOR120'},
	    	{name: 'INOUT_PRSN' 	     		    	, text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'    	, type: 'string'},
	    	{name: 'INOUT_NUM'        		    		, text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'    	, type: 'string'},
	    	{name: 'MONEY_UNIT'       		    		, text: '<t:message code="system.label.purchase.currency" default="화폐"/>'    	, type: 'string'},
	    	{name: 'EXCHG_RATE_O'     		    		, text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'    	, type: 'uniER'},
	    	{name: 'CREATE_LOC'       		    		, text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'    	, type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mms501ukrvMasterStore1', {
		model: 'Mms501ukrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult2.setValue("INOUT_NUM", master.INOUT_NUM);
						var inoutNum = masterForm.getValue('INOUT_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['INOUT_NUM'] != inoutNum) {
								record.set('INOUT_NUM', inoutNum);
							}
						})
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('mms501ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		this.fnSumAmountI();
           	},
           	add: function(store, records, index, eOpts) {
           		this.fnSumAmountI();
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		this.fnSumAmountI();
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           		this.fnSumAmountI();
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		fnSumAmountI:function(){
			console.log("=============Exec fnSumAmountI()");

				var dAmountI = Ext.isNumeric(this.sum('INOUT_FOR_O')) ? this.sum('INOUT_FOR_O'):0; // 재고단위금액
				var dIssueAmtWon = Ext.isNumeric(this.sum('INOUT_I')) ? this.sum('INOUT_I'):0;	// 자사금액(재고)

				panelResult.setValue('SumInoutO',dAmountI);
				panelResult.setValue('IssueAmtWon',dIssueAmtWon);
		}
	});//End of var directMasterStore1 = Unilite.createStore('mms501ukrvMasterStore1', {
	var inoutNoMasterStore = Unilite.createStore('inoutNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model: 'inoutNoMasterModel',
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
            	read: 'mms501ukrvService.selectinoutNoMasterList'
            }
        }
        ,loadStoreRecords : function()	{
			var param= inoutNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult2.show();
	        },
	        expand: function() {
	        	panelResult2.hide();
	        }
	    },
		items: [{
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName:'CUSTOM_CODE',
			    	textFieldName:'CUSTOM_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					allowBlank: false,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
								masterForm.setValue('EXCHG_RATE_O', '1');
								panelResult2.setValue('CUSTOM_CODE2', masterForm.getValue('CUSTOM_CODE'));
								panelResult2.setValue('CUSTOM_NAME2', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
									panelResult2.setValue('CUSTOM_CODE2', '');
									panelResult2.setValue('CUSTOM_NAME2', '');
								}
					}
				}),
			{
		        fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
		        name: 'INOUT_DATE',
		        xtype: 'uniDatefield',
		       	value: UniDate.get('today'),
		     	allowBlank: false,
		     	holdable: 'hold',
		     	width : 200,
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType   : 'OU',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				readOnly: true
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				allowBlank: false,
				displayField: 'value',
				fieldStyle: 'text-align: center;',
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
				name:'EXCHG_RATE_O',
				xtype: 'uniTextfield',
				allowBlank: false,
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name: 'CREATE_LOC',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'M505',
				hidden:false
			},{
				fieldLabel:'ITEM_CODE',
				name:'ITEM_CODE',
				xtype: 'uniTextfield',
				hidden: true

			},{
				fieldLabel:'ORDER_UNIT',
				name:'ORDER_UNIT',
				xtype: 'uniTextfield',
				hidden: true

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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
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

	});//End of var masterForm = Unilite.createSearchForm('searchForm', {
	var panelResult2 = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST', {
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName:'CUSTOM_CODE2',
			    	textFieldName:'CUSTOM_NAME2',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					allowBlank: false,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
								masterForm.setValue('EXCHG_RATE_O', '1');
								masterForm.setValue('CUSTOM_CODE', panelResult2.getValue('CUSTOM_CODE2'));
								masterForm.setValue('CUSTOM_NAME', panelResult2.getValue('CUSTOM_NAME2'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
									masterForm.setValue('CUSTOM_CODE', '');
									masterForm.setValue('CUSTOM_NAME', '');
								}
					}
				}),
			{
		        fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
		        name: 'INOUT_DATE',
		        xtype: 'uniDatefield',
		       	value: UniDate.get('today'),
		     	allowBlank: false,
		     	width : 200,
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType   : 'OU',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INOUT_PRSN', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				readOnly: true
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'south',
	    items: [{
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 2,
	        	tableAttrs: {align:'right'}
	        },
	        items: [{
	        	fieldLabel: '금액합계',
	        	name:'SumInoutO',
	        	xtype: 'uniNumberfield',
	        	readOnly: true
	        },{
	       	 	fieldLabel: '자사금액합계',
	       	 	name:'IssueAmtWon',
	       	 	xtype: 'uniNumberfield',
	        	readOnly: true
	        }]
	    }]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    var inoutNoSearch = Unilite.createSearchForm('inoutNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 3},
	    trackResetOnLoad: true,
	    items: [
			{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false
			},
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					textFieldWidth: 170,
					validateBlank: false
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType   : 'OU'
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>',
				name: 'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024'
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			}]
    }); // createSearchForm
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('mms501ukrvGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
               		 { dataIndex: 'INOUT_NUM'         , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_SEQ'         , 	width:66, locked: true},
               		 { dataIndex: 'INOUT_METH'        , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_TYPE_DETAIL' , 	width:66, locked: true},
               		 { dataIndex: 'ITEM_CODE' 	      , width:88,locked: true,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 							textFieldName: 'ITEM_CODE',
					 							DBtextFieldName: 'ITEM_CODE',
					 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
		                    					autoPopup: true,
												listeners: {'onSelected': {
																fn: function(records, type) {
																		console.log('records : ', records);
																		Ext.each(records, function(record,i) {
																							console.log('record',record);
																							if(i==0) {
																								masterGrid.setItemData(record,false);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								masterGrid.setItemData(record,false);
																							}
																		});
																	},
																scope: this
																},
															'onClear': function(type) {
																	var a = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');

																	masterGrid.setItemData(null,true);
																	masterGrid.uniOpt.currentRecord.set('ITEM_CODE',a);

																	if(a != ''){
																		alert("미등록상품입니다.");
																	}
																		}
												}
										})
					},
               		 {dataIndex: 'ITEM_NAME', width:88,locked: true,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 							extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
		                    					autoPopup: true,
												listeners: {'onSelected': {
																fn: function(records, type) {
													                    console.log('records : ', records);
													                    Ext.each(records, function(record,i) {
																		        			if(i==0) {
																								masterGrid.setItemData(record,false);
																		        			} else {
																		        				UniAppManager.app.onNewDataButtonDown();
																		        				masterGrid.setItemData(record,false);
																		        			}
																		});
																	},
																scope: this
																},
															'onClear': function(type) {
																			masterGrid.setItemData(null,true);
																		}
																	}
										})
					},
               		 { dataIndex: 'ITEM_ACCOUNT'      , 	width:66, hidden: true},
               		 { dataIndex: 'SPEC'              , 	width:133, hidden: true},
               		 { dataIndex: 'ORDER_UNIT'        , 	width:66, hidden: true},

               		 { dataIndex: 'CONDITION'		  ,		width:66},
               		 { dataIndex: 'TYPE'			  ,		width:66},


               		 { dataIndex: 'ITEM_STATUS'       , 	width:80, hidden: true},
               		 { dataIndex: 'ORIGINAL_Q'        , 	width:66, hidden: true},
               		 { dataIndex: 'GOOD_STOCK_Q'      , 	width:66},
               		 { dataIndex: 'BAD_STOCK_Q'       , 	width:66, hidden: true},
               		 { dataIndex: 'NOINOUT_Q'         , 	width:66, hidden: true},
               		 { dataIndex: 'PRICE_YN'          , 	width:66, hidden: true},
               		 { dataIndex: 'MONEY_UNIT'        , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_FOR_P'       , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_FOR_O'       , 	width:66, hidden: true},

               		 { dataIndex: 'SALE_PRICE'	  ,		width:66},
               		 { dataIndex: 'PURCHASE_RATE'	  ,		width:66},

               		 { dataIndex: 'ORDER_UNIT_FOR_P'  , 	width:120},

               		  { dataIndex: 'ORDER_UNIT_Q'     , 	width:102},

               		 { dataIndex: 'ORDER_UNIT_FOR_O'  , 	width:116},

               		 { dataIndex: 'BAR_CODE'	  	  ,		width:66},

               		 { dataIndex: 'ACCOUNT_YNC'       , 	width:66, hidden: true},
               		 { dataIndex: 'EXCHG_RATE_O'      , 	width:62, hidden: true},
               		 { dataIndex: 'INOUT_P'           , 	width:66, hidden: true},
               		 { dataIndex: 'INOUT_I'           , 	width:66, hidden: true},
               		 { dataIndex: 'ORDER_UNIT_P'      , 	width:88, hidden: true},
               		 { dataIndex: 'ORDER_UNIT_I'      , 	width:100, hidden: true},
               		 { dataIndex: 'STOCK_UNIT'        , 	width:80, hidden: true},
               		 { dataIndex: 'TRNS_RATE'         , 	width:80, hidden: true},
               		 { dataIndex: 'INOUT_Q'           , 	width:124, hidden: true},
               		 { dataIndex: 'ORDER_TYPE'        , 	width:60, hidden: true},
               		 { dataIndex: 'LC_NUM'            , 	width:100, hidden: true},
               		 { dataIndex: 'BL_NUM'            , 	width:66, hidden: true},
               		 { dataIndex: 'ORDER_NUM'         , 	width:133, hidden: true},
               		 { dataIndex: 'ORDER_SEQ'         , 	width:33, hidden: true},
               		 { dataIndex: 'ORDER_Q'           , 	width:100, hidden: true},
               		 { dataIndex: 'INOUT_CODE_TYPE'   , 	width:33, hidden: true},
               		 { dataIndex: 'WH_CODE'           , 	width:66, hidden: true},
               		 { dataIndex: 'WH_CELL_CODE'	  , 	width:166, hidden: true},
               		 { dataIndex: 'WH_CELL_NAME'	  , 	width:166, hidden: true},
               		 { dataIndex: 'INOUT_DATE'        , 	width:73, hidden: true},
               		 { dataIndex: 'INOUT_PRSN'        , 	width:33, hidden: true},
               		 { dataIndex: 'ACCOUNT_Q'         , 	width:33, hidden: true},
               		 { dataIndex: 'CREATE_LOC'        , 	width:33, hidden: true},
               		 { dataIndex: 'SALE_C_DATE'       , 	width:33, hidden: true},
               		 { dataIndex: 'REMARK'            , 	width:133},
               		 { dataIndex: 'PROJECT_NO'        , 	width:133, hidden: true},
               		 { dataIndex: 'LOT_NO'            , 	width:133},
               		 { dataIndex: 'INOUT_TYPE'        , 	width:33, hidden: true},
               		 { dataIndex: 'INOUT_CODE'        , 	width:66, hidden: true},
               		 { dataIndex: 'DIV_CODE'          , 	width:33, hidden: true},
               		 { dataIndex: 'CUSTOM_NAME'       , 	width:100, hidden: true},
               		 { dataIndex: 'COMPANY_NUM'       , 	width:88, hidden: true},
               		 { dataIndex: 'INSTOCK_Q'         , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_DIV_CODE'     , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_CUSTOM_CODE'  , 	width:66, hidden: true},
               		 { dataIndex: 'BILL_TYPE'         , 	width:66, hidden: true},
               		 { dataIndex: 'SALE_TYPE'         , 	width:66, hidden: true},
               		 { dataIndex: 'UPDATE_DB_USER'    , 	width:66, hidden: true},
               		 { dataIndex: 'UPDATE_DB_TIME'    , 	width:66, hidden: true},
               		 { dataIndex: 'EXCESS_RATE'       , 	width:66, hidden: true},
               		 { dataIndex: 'INSPEC_NUM'        , 	width:66, hidden: true},
               		 { dataIndex: 'INSPEC_SEQ'        , 	width:66, hidden: true},
               		 { dataIndex: 'COMP_CODE'         , 	width:66, hidden: true},
               		 { dataIndex: 'BASIS_NUM'         , 	width:66, hidden: true},
               		 { dataIndex: 'BASIS_SEQ'         , 	width:66, hidden: true},
               		 { dataIndex: 'SCM_FLAG_YN'       , 	width:66, hidden: true}
        ],
        listeners: {
        	afterrender: function(masterGrid) {
		    	var me = this;
		    	this.contextMenu = Ext.create('Ext.menu.Menu', {});
		     	this.contextMenu.add({
						text: '상품정보 등록',   iconCls : '',
				        handler: function(menuItem, event) {
				        	var records = masterGrid.getSelectionModel().getSelection();
				         	var record = records[0];
							var params = {
								appId: UniAppManager.getApp().id,
								sender: me,
								action: 'new',
//											_EXCEL_JOBID: excelWindow.jobID,
//											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),
								ITEM_CODE: record.get('ITEM_CODE')
							}
							var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};
							parent.openTab(rec, '/base/bpr101ukrv.do', params);
				                	}
				});
				this.contextMenu.add({
						text: '도서정보 등록',   iconCls : '',
				        handler: function(menuItem, event) {
				        	var records = masterGrid.getSelectionModel().getSelection();
				         	var record = records[0];
							var params = {
								appId: UniAppManager.getApp().id,
								sender: me,
								action: 'newB',
//											_EXCEL_JOBID: excelWindow.jobID,
//											_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),
								ITEM_CODE: record.get('ITEM_CODE')
							}
							var rec = {data : {prgID : 'bpr102ukrv', 'text':''}};
							parent.openTab(rec, '/base/bpr102ukrv.do', params);
				                	}
				});
			   /* me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
		        	event.stopEvent();
		        	if(record.get('ITEM_CODE') == '')
					me.contextMenu.showAt(event.getXY());
				});*/
			},

		beforeedit : function( editor, e, eOpts ) {
			if(e.record.data.ACCOUNT_Q != '0'){
				return false;
			}
			if(!Ext.isEmpty(e.record.data.ORDER_NUM)){
				if(e.record.phantom){
					if(e.record.ORDER_TYPE == '3'){
						if(e.field == 'BL_NUM') return true;
					}else{
						if(e.field == 'BL_NUM') return false;
					}
					if(e.field == 'EXCHG_RATE_O')return true;
					if(e.field == 'MONEY_UNIT')return true;
					if(e.field == 'ACCOUNT_YNC')return true;
					if(e.field == 'ORDER_UNIT_Q')return true;
					if(e.field == 'INOUT_TYPE_DETAIL')return true;
					if(e.field == 'ITEM_STATUS')return true;
					if(e.field == 'INOUT_SEQ')return true;
					if(e.field == 'INOUT_I')return true;
					if(e.field == 'INOUT_P')return true;
					if(e.field == 'PRICE_YN')return true;
					if(e.field == 'LOT_NO')return true;
					if(e.field == 'ORDER_UNIT_P')return true;
					if(e.field == 'ORDER_UNIT_I')return true;
					if(e.field == 'ORDER_UNIT_FOR_P')return true;
					if(e.field == 'ORDER_UNIT_FOR_O')return true;
					if(e.field == 'REMARK')return true;
					if(e.field == 'PROJECT_NO')return true;
					if(e.field == 'TRANS_COST')return true;
					if(e.field == 'TARIFF_AMT')return true;
					else{
						return false;
					}
				}
			}else{
				if(e.record.phantom){
					if(e.record.ORDER_TYPE == '3'){
						if(e.field == 'BL_NUM') return true;
					}else{
						if(e.field == 'BL_NUM') return false;
					}
					if(e.record.phantom){
						if(e.field == 'ITEM_CODE') return true;
						if(e.field == 'ITEM_NAME') return true;
						if(e.field == 'INOUT_METH') return true;
						if(e.field == 'WH_CODE') return true;
						if(e.field == 'WH_CELL_CODE') return true;
						if(e.field == 'ORDER_TYPE') return true;
						if(e.field == 'INOUT_SEQ') return true;
					}else{
						if(e.field == 'ITEM_CODE') return false;
						if(e.field == 'ITEM_NAME') return false;
						if(e.field == 'INOUT_METH') return false;
						if(e.field == 'WH_CODE') return false;
						if(e.field == 'WH_CELL_CODE') return false;
						if(e.field == 'ORDER_TYPE') return false;
						if(e.field == 'INOUT_SEQ') return false;
					}
					if(e.field == 'ORDER_UNIT_P')return true;
					if(e.field == 'ORDER_UNIT_I')return true;
					if(e.field == 'ORDER_UNIT_FOR_P')return true;
					if(e.field == 'ORDER_UNIT_FOR_O')return true;
					if(e.field == 'ORDER_UNIT')return true;
					if(e.field == 'REMARK')return true;
					if(e.field == 'PROJECT_NO')return true;
					if(e.field == 'TRANS_COST')return true;
					if(e.field == 'TARIFF_AMT')return true;
					if(e.field == 'LOT_NO')return true;
					if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
						if(e.field == 'TRNS_RATE')return true;
					}else{
						if(e.field == 'TRNS_RATE')return false;
					}
				}else{
					return false;
				}
			}
			if(e.record.phantom == false )
				{
					if(e.record.data.RECEIPT_Q == e.record.data.INSPEC_Q)	{
      					if(e.field=='RECEIPT_Q') return false;
      					if(e.field=='LOT_NO') return false;
						if(e.field=='REMARK') return false;
						if(e.field=='RECEIPT_PRSN') return false;
						if(e.field=='PROJECT_NO') return false;
      				}else {
      					if(e.field=='RECEIPT_Q') return true;
      					if(e.field=='LOT_NO') return true;
						if(e.field=='REMARK') return true;
						if(e.field=='RECEIPT_PRSN') return true;
						if(e.field=='PROJECT_NO') return true;
      				}
					if(e.field=='RECEIPT_SEQ') return false;
					if(e.field=='ITEM_CODE') return false;
					if(e.field=='ITEM_NAME') return false;
					if(e.field=='SPEC') return false;
					if(e.field=='ORDER_UNIT') return false;
					if(e.field=='NOT_RECEIPT_Q') return false;
					if(e.field=='INSPEC_Q') return false;
					if(e.field=='ORDER_NUM') return false;
					if(e.field=='ORDER_SEQ') return false;
					if(e.field=='TRADE_FLAG_YN') return false;
				}
				else if(e.record.phantom )	{
						if(e.field=='LOT_NO') return true;
						if(e.field=='REMARK') return true;
						if(e.field=='RECEIPT_Q') return true;
						if(e.field=='RECEIPT_PRSN') return true;
						if(e.field=='PROJECT_NO') return true;
						if(e.field=='RECEIPT_SEQ') return false;
						if(e.field=='ITEM_CODE') return false;
						if(e.field=='ITEM_NAME') return false;
						if(e.field=='SPEC') return false;
						if(e.field=='ORDER_UNIT') return false;
						if(e.field=='NOT_RECEIPT_Q') return false;
						if(e.field=='INSPEC_Q') return false;
						if(e.field=='ORDER_NUM') return false;
						if(e.field=='ORDER_SEQ') return false;
						if(e.field=='TRADE_FLAG_YN') return false;
      			}
			}
		},
        setItemData: function(record, dataClear) {
       		var grdRecord = this.getSelectedRecord();
       		if(dataClear) {
       		/*	grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('ORDER_Q'			,0);
				grdRecord.set('ORDER_P'			,0);
				grdRecord.set('ORDER_WGT_Q'		,0);
				grdRecord.set('ORDER_WGT_P'		,0);
				grdRecord.set('ORDER_VOL_Q'		,0);
				grdRecord.set('ORDER_VOL_P'		,0);
				grdRecord.set('ORDER_O'			,0);
				grdRecord.set('PROD_SALE_Q'		,0);
				grdRecord.set('PROD_Q'			,0);
				grdRecord.set('STOCK_Q'			,0);
				grdRecord.set('DISCOUNT_RATE'	,0);
				grdRecord.set('WGT_UNIT'		,"");
				grdRecord.set('UNIT_WGT'		,0);
				grdRecord.set('VOL_UNIT'		,"");
				grdRecord.set('UNIT_VOL'		,0);*/
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);

       			grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
				grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
				grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			//	grdRecord.set('ORDER_UNIT_FOR_P'    , record['ORDER_P']);


				masterForm.setValue('ITEM_CODE',record['ITEM_CODE']);
				masterForm.setValue('ORDER_UNIT',record['ORDER_UNIT']);



				var param = {"ITEM_CODE": record['ITEM_CODE'],
							"CUSTOM_CODE": masterForm.getValue('CUSTOM_CODE'),
							"DIV_CODE": masterForm.getValue('DIV_CODE'),
							"MONEY_UNIT": masterForm.getValue('MONEY_UNIT'),
							"ORDER_UNIT": masterForm.getValue('ORDER_UNIT'),
							"INOUT_DATE": masterForm.getValue('INOUT_DATE')
				};
					mms501ukrvService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
					grdRecord.set('ORDER_UNIT_FOR_P', provider['ORDER_P']);
					grdRecord.set('ORDER_UNIT_P', (provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O')));
					grdRecord.set('PURCHASE_RATE', provider['PURCHASE_RATE']);
					}
				})


				var param = {"ITEM_CODE": record['ITEM_CODE']};
					mms501ukrvService.fnSaleBasisP(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
					grdRecord.set('SALE_PRICE', provider['SALE_BASIS_P']);
					}
				})




				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
       		}
		}
    });

    var inoutNoMasterGrid = Unilite.createGrid('mms501ukrvinoutNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
        // title: '기본',
        layout : 'fit',
		store: inoutNoMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false
		},
        columns:  [
			{ dataIndex: 'INOUT_NAME'       		    ,  width:166},
			{ dataIndex: 'INOUT_DATE'       		    ,  width:86},
			{ dataIndex: 'INOUT_CODE'       		    ,  width:100,hidden:true},
			{ dataIndex: 'WH_CODE'          		    ,  width:120},
			{ dataIndex: 'WH_CELL_CODE'     		    ,  width:120,hidden:true},
			{ dataIndex: 'DIV_CODE'         		    ,  width:100},
			{ dataIndex: 'INOUT_PRSN' 	     		    ,  width:100},
			{ dataIndex: 'INOUT_NUM'        		    ,  width:146},
			{ dataIndex: 'MONEY_UNIT'       		    ,  width:53,hidden:true},
			{ dataIndex: 'EXCHG_RATE_O'     		    ,  width:53,hidden:true},
			{ dataIndex: 'CREATE_LOC'       		    ,  width:53,hidden:true}
		],
        listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				inoutNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
				masterForm.setAllFieldsReadOnly(true);
			     // 	directMasterStore1.fnSumAmountI();
			}
		},
		returnData: function(record)	{
          	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	masterForm.setValues({
          		'INOUT_DATE':record.get('INOUT_DATE'),
          		'INOUT_NUM':record.get('INOUT_NUM'),
          		'WH_CODE':record.get('WH_CODE'),
          		'CUSTOM_CODE':record.get('INOUT_CODE'),
          		'CUSTOM_NAME':record.get('INOUT_NAME'),
          		'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
          		'MONEY_UNIT':record.get('MONEY_UNIT')
          		});
        //  	UniAppManager.app.fnSumAmountI();
       //   		directMasterStore1.fnSumAmountI();
          	panelResult2.setValues({
          		/*'INOUT_DATE':record.get('INOUT_DATE'),
          		'INOUT_NUM':record.get('INOUT_NUM'),
          		'WH_CODE':record.get('WH_CODE'),*/
          		'CUSTOM_CODE2':record.get('INOUT_CODE'),
          		'CUSTOM_NAME2':record.get('INOUT_NAME'),
          		'INOUT_PRSN':record.get('INOUT_PRSN'),
          		'WH_CODE':record.get('WH_CODE'),
          		'INOUT_DATE':record.get('INOUT_DATE'),
          		'INOUT_NUM':record.get('INOUT_NUM')
          	/*	'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
          		'MONEY_UNIT':record.get('MONEY_UNIT')*/
          		});
          }
    });

    function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '입고번호검색',
                width: 830,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [inoutNoSearch, inoutNoMasterGrid], //inoutNoDetailGrid],
                tbar:  ['->',
			        {
			        	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							inoutNoMasterStore.loadStoreRecords();
						},
						disabled: false
					}, {
						itemId : 'inoutNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
		    ],
				listeners : {
					beforehide: function(me, eOpt)	{
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
						//inoutNoDetailGrid.reset();
					},
					 beforeclose: function( panel, eOpts )	{
						inoutNoSearch.clearForm();
						inoutNoMasterGrid.reset();
						//inoutNoDetailGrid.reset();
		 			},
					 show: function( panel, eOpts )	{
			    		inoutNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
				 		inoutNoSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth', masterForm.getValue('INOUT_DATE')));
				 		inoutNoSearch.setValue('INOUT_DATE_TO',masterForm.getValue('INOUT_DATE'));
				 		inoutNoSearch.setValue('WH_CODE',masterForm.getValue('WH_CODE'));
				 		inoutNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
				 		inoutNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
				 		inoutNoSearch.setValue('INOUT_PRSN',masterForm.getValue('INOUT_PRSN'));
			    	/*	inoutNoSearch.setValue('ORDER_PRSN',masterForm.getValue('ORDER_PRSN'));
			    		inoutNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('CUSTOM_CODE'));
			    		inoutNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
			    		inoutNoSearch.setValue('ORDER_TYPE',masterForm.getValue('ORDER_TYPE'));
			    		*/
					 }
                }
			})
		}
		SearchInfoWindow.show();
    }

    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult2, panelResult
			]
		},
			masterForm
		],
		id  : 'mms501ukrvApp',
		fnInitBinding: function(){
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData', 'prev', 'next'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			masterForm.setAllFieldsReadOnly(false);
			var inoutNo = masterForm.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
			//	var param= masterForm.getValues();
			//	masterForm.getForm().load({params: param})
				directMasterStore1.loadStoreRecords();
				masterForm.setAllFieldsReadOnly(true);
			};
/*
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	*/
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 var accountYnc = 'Y';
				 var inoutNum = masterForm.getValue('INOUT_NUM');
				 var seq = directMasterStore1.max('INOUT_SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
            	 var inoutType = '1';
            	 var inoutCodeType = '4';
            	 var whCode = masterForm.getValue('WH_CODE');
            	 var whCellCode = masterForm.getValue('WH_CELL_CODE');
            	 var inoutPrsn = masterForm.getValue('INOUT_PRSN');
            	 var inoutCode = masterForm.getValue('CUSTOM_CODE');
            	 var customName = masterForm.getValue('CUSTOM_NAME');
            	 var createLoc = '2';
            	 var inoutDate = masterForm.getValue('INOUT_DATE');
            	 var inoutMeth = '2';
            	 var inoutTypeDetail = gsInoutTypeDetail; //gsInoutTypeDetail ?? 확인필요
            	 var itemStatus = '1';
            	 var accountQ = '0';
            	 var orderUnitQ = '0';
            	 var inoutQ = '0';
            	 var inoutI = '0';
            	 var moneyUnit = masterForm.getValue('MONEY_UNIT');
            	 var inoutP = '0';
            	 var inoutForP = '0';
            	 var inoutForO = '0';
            	 var originalQ = '0';
            	 var noinoutQ = '0';
            	 var goodStockQ ='0';
            	 var badStockQ = '0';
            	 var exchgRateO = masterForm.getValue('EXCHG_RATE_O');
            	 var trnsRate = '1';
            	 var divCode = masterForm.getValue('DIV_CODE');
            	 var companyNum = BsaCodeInfo.gsCompanyNum // ??확인필요
            	 var saleDivCode = '*';
            	 var saleCustomCode = '*';
            	 var saleType = '*';
            	 var billType = '*';
            	 var priceYn = 'Y';
            	 var excessRate = '0';
            	 var orderType = '1';
            	 var transCost = '0';
            	 var tariffAmt = '0';

           // 	 var compCode =  ??확인 필요


            	 var r = {
            	 	ACCOUNT_YNC: 		accountYnc,
            	 	INOUT_TYPE:         inoutType,
            	 	INOUT_CODE_TYPE:    inoutCodeType,
            	 	WH_CODE:            whCode,
            	 	WH_CELL_CODE:       whCellCode,
            	 	INOUT_PRSN:         inoutPrsn,
            	 	INOUT_CODE:         inoutCode,
            	 	CUSTOM_NAME:        customName,
            	 	CREATE_LOC:         createLoc,
            	 	INOUT_DATE:         inoutDate,
            	 	INOUT_METH:         inoutMeth,
            	 	INOUT_TYPE_DETAIL:  inoutTypeDetail,
            	 	ITEM_STATUS:        itemStatus,
            	 	ACCOUNT_Q:          accountQ,
            	 	ORDER_UNIT_Q:       orderUnitQ,
            	 	INOUT_Q:            inoutQ,
            	 	INOUT_I:            inoutI,
            	 	MONEY_UNIT:         moneyUnit,
            	 	INOUT_P:            inoutP,
            	 	INOUT_FOR_P:        inoutForP,
            	 	INOUT_FOR_O:        inoutForO,
            	 	ORIGINAL_Q:         originalQ,
            	 	NOINOUT_Q:          noinoutQ,
            	 	GOOD_STOCK_Q:       goodStockQ,
            	 	BAD_STOCK_Q:        badStockQ,
            	 	EXCHG_RATE_O:       exchgRateO,
            	 	TRNS_RATE:          trnsRate,
            	 	DIV_CODE:           divCode,
            	 	COMPANY_NUM:        companyNum,
            	 	SALE_DIV_CODE:      saleDivCode,
            	 	SALE_CUSTOM_CODE:   saleCustomCode,
            	 	SALE_TYPE:          saleType,
            	 	BILL_TYPE:          billType,
            	 	PRICE_YN:           priceYn,
            	 	EXCESS_RATE:        excessRate,
            	 	ORDER_TYPE:         orderType,
            	 	TRANS_COST:         transCost,
            	 	TARIFF_AMT:         tariffAmt,
            	// 	COMP_CODE:
					INOUT_NUM: inoutNum,
					INOUT_SEQ: seq
		        };
				masterGrid.createRow(r,'ITEM_CODE',masterGrid.getStore().getCount() - 1);
				masterForm.setAllFieldsReadOnly(true);
				panelResult2.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult2.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult2.clearForm();
			panelResult.clearForm();
			directMasterStore1.clearData();
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
				if(selRow.get('ACCOUNT_Q') != 0)
				{
					alert('<t:message code="unilite.msg.sMM008"/>');
				}else{
					masterGrid.deleteSelectedRow();
				}
			}
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('INOUT_NUM')))	{
				alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {

        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult2.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.setValue('INOUT_DATE',new Date());
        	panelResult2.setValue('INOUT_DATE',new Date());
        	masterForm.setValue('CREATE_LOC','1');
        	panelResult2.setValue('CREATE_LOC','1');
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},

 		fnInTypeAccountYN:function(subCode){
 			var fRecord ='';
        	Ext.each(BsaCodeInfo.gsInTypeAccountYN, function(item, i)	{
        		if(item['codeNo'] == subCode && !Ext.isEmpty(item['refCode4'])) {
        			fRecord = item['refCode4'];
        		}
        	});
        	if(Ext.isEmpty(fRecord)){
        		fRecord = 'N'
        	}
        	return fRecord;
        },
        cbStockQ: function(provider, params)	{
	    	var rtnRecord = params.rtnRecord;

			//var dStockQ = Unilite.nvl(provider['STOCK_Q'], 0);
			//var dOrderQ = Unilite.nvl(rtnRecord.get('ORDER_Q'), 0);
			//var lTrnsRate = rtnRecord.get('TRANS_RATE');

	    	var dGoodStockQ = provider['GOOD_STOCK_Q'];
	    	var dBadStockQ = provider['BAD_STOCK_Q'];
			rtnRecord.set('GOOD_STOCK_Q', dGoodStockQ);
			rtnRecord.set('BAD_STOCK_Q', dBadStockQ);
	    }
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

				case "INOUT_SEQ" :
					if(newValue != ''){
						if(newValue <= 0){
							rv='<t:message code="unilite.msg.sMB076"/>';
							break;
						}
//						else if(clng(grdsheet1.TextMatrix(lRow,lCol)) != fnCDbl(grdsheet1.TextMatrix(lRow,lCol))){ //?
//							rv='<t:message code="unilite.msg.sMB087"/>';
//						}
					}

				case "ITEM_CODE" :
					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');

						directMasterStore1.fnSumAmountI();
					}
					break;
				case "ITEM_NAME" :
					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');

						directMasterStore1.fnSumAmountI();
					}
					break;
				case "ORDER_UNIT_Q" :	//입고량
					if(newValue != oldValue){
						if(record.get('ITEM_CODE') == ''){
							rv='<t:message code="unilite.msg.sMM033"/>';
							break;
						}
					}

					var dInoutQ3 = newValue * record.get('TRNS_RATE');

					if(!(newValue < '0')){
						if(record.get('ORDER_NUM') != ''){

							//var dTempQ =0;
							var dOrderQ = record.get('ORDER_Q');	//발주량
							var dInoutQ = newValue * record.get('TRNS_RATE');	//입력한 입고량  * 입수
							var dNoInoutQ =  record.get('NOINOUT_Q');	//미입고량

							var dEnableQ = (dOrderQ + dOrderQ * record.get('EXCESS_RATE') / 100) / record.get('TRNS_RATE');
											//(발주량 + 발주량 * 과입고허용률 / 100) / 입수
							var dTempQ = ((dOrderQ - dNoInoutQ + dInoutQ - record.get('ORIGINAL_Q')) / record.get('TRNS_RATE'));
											// ( 발주량 - 미입고량 + (입력한 입고량*입수) - 기존입고량	) / 입수

							if(dNoInoutQ > 0){
								if(dTempQ > dEnableQ){
									 dEnableQ = (dNoInoutQ + record.get('ORIGINAL_Q')) / record.get('TRNS_RATE') + (dEnableQ - (dOrderQ / record.get('TRNS_RATE')));
									//	(미입고량 + 기존입고량) / 입수 + (1100 - 발주량 /입수 )
									rv='<t:message code = "unilite.msg.sMM351"/>' + '<t:message code = "unilite.msg.sMM534"/>' + ":" + dEnableQ;
									break;
								}
							}
						}
					}


					record.set('INOUT_Q',dInoutQ3);

					if(BsaCodeInfo.gsInvstatus == '+'){
						if(record.get('STOCK_CARE_YN') == 'Y'){
							if(newValue < 0){
								var dInoutQ1 = 0;
								var dOriginalQ = 0;

								dInoutQ1 = dInoutQ1 + newValue;
								dOriginalQ = dOriginalQ + record.get('ORIGINAL_Q');

								if(record.get('ITEM_STATUS') == '1'){
									dStockQ = record.get('GOOD_STOCK_Q');
								}else{
									dStockQ = record.get('BAD_STOCK_Q');
								}

								if((dStockQ - dOriginalQ) < dInoutQ1 * -1){
									rv='<t:message code = "unilite.msg.sMM349"/>'+" : " + (dStockQ - dOriginalQ) ;
										record.set('INOUT_Q', oldValue);
								}
							}
						}
					}

					if(record.get('ORDER_UNIT_P') != ''){
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_P') * newValue));	//자사금액= 자사단가 * 입력한입고량
					//	record.set('ORDER_UNIT_I') =
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('ORDER_UNIT_I','0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_FOR_P') * newValue));	//구매금액 = 구매단가 * 입력한 입고량
						//record.set('ORDER_UNIT_FOR_O') =
				//보류 반올림		Math.round(record.get('ORDER_UNIT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_FOR_O")), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					}else{
						record.set('ORDER_UNIT_FOR_O','0');
					}

					record.set('INOUT_P',(record.get('ORDER_UNIT_P') / record.get('TRNS_RATE')));	//자사단가(재고) = 자사단가 / 입수
					record.set('INOUT_I',record.get('ORDER_UNIT_I'));	//자사금액(재고) = 자사금액
					record.set('INOUT_FOR_O',record.get('ORDER_UNIT_FOR_O'));	//재고단위금액  = 구매금액

					directMasterStore1.fnSumAmountI();

				break;
				case "INOUT_P" :	//자사단가(재고)
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
					}

					record.set('INOUT_I', (record.get('INOUT_Q') * newValue));	//자사금액(재고) = 재고단위 수량 * 입력한 자사단가(재고)
					//record.set('INOUT_I') =
			//보류 반올림		Math.round(record.get('INOUT_I'),CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(grdsheet1.Row, grdsheet1.colindex("INOUT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));

                    if(record.get('EXCHG_RATE_O') != 0){
                    	record.set('INOUT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));	//재고단위단가 = 입력한 자사단가(재고) / 환율
                    	record.set('INOUT_FOR_O',(record.get('INOUT_Q') * newValue / record.get('EXCHG_RATE_O')));	//재고단위금액 = 재고단위수량 * 입력한 자사단가(재고) / 환율
                    	//record.set('INOUT_FOR_O') =
             //보류 반올림       	Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(grdsheet1.Row, grdsheet1.colindex("INOUT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
                    }else{
                    	record.set('INOUT_FOR_O','0');
                    	record.set('INOUT_FOR_P','0');
                    }
                    directMasterStore1.fnSumAmountI();
					break;
				case "INOUT_I" :	//자사금액(재고)
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}

					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_P',(newValue / record.get('INOUT_Q')));	// 자사단가(재고) = 입력한 자사금액(재고) / 재고단위수량
					}else{
						record.set('INOUT_P','0');
					}

					if(record.get('EXCHG_RATE_O') != 0){
                    	record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고) / 환율
                    	record.set('INOUT_FOR_O',(newValue / record.get('EXCHG_RATE_O')));	//재고단위금액 = 입력한 자사금액(재고) / 환율
                    	//record.set('INOUT_FOR_O' =
           //보류 반올림         	Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(grdsheet1.Row, grdsheet1.colindex("INOUT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
                    }else{
                    	record.set('INOUT_FOR_O','0');
                    	record.set('INOUT_FOR_P','0');
                    }
                    directMasterStore1.fnSumAmountI();
					break;
//				case "ORDER_UNIT" :
				case "TRNS_RATE" :	//입수
					if(newValue <= 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}

					if(record.get('ORDER_UNIT_Q') != ''){
						record.set('INOUT_Q',record.get('ORDER_UNIT_Q') * newValue); 	//재고단위수량 = 입고량 * 입력한 입수
					}else{
						record.set('INOUT_Q','0');
					}



					if(record.get('ORDER_UNIT_P') != ''){
						record.set('INOUT_P',(record.get('ORDER_UNIT_P') / newValue));	//자사단가(재고) = 자사단가 / 입력한 입수
					}else{
						record.set('INOUT_P','0');
					}

					if(record.get('ORDER_UNIT_FOR_P') != ''){
						record.set('INOUT_FOR_P',(record.get('ORDER_UNIT_FOR_P') / newValue));	//재고단위단가 = 구매단가 / 입력한 입수
					}else{
						record.set('INOUT_FOR_P','0');
					}
					break;
				case "ORDER_UNIT_P":	//자사단가
					if((record.get('ACCOUNT_YNC') == 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}

					}

					record.set('INOUT_P',(newValue / record.get('TRNS_RATE')));	//자사단가(재고) = 입력한 자사단가 / 입수
					record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * newValue));	//자사금액 = 입고량 * 입력한 자사단가
					//record.set('ORDER_UNIT_I') =
				//보류 반올림	Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
                    record.set('INOUT_I',(record.get('ORDER_UNIT_I')));	//자사금액(재고) = 자사금액
                    //record.set('INOUT_I') =
               //보류 반올림     Math.round(record.get('INOUT_I'),CustomCodeInfo.gsUnderCalBase);
                    //fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("INOUT_I")), top.sWonflag,top.goCnn.GetFSET("M_FSET_IS"));

                    if(record.get('EXCHG_RATE_O') != 0){
                    	record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고)/환율
                    	record.set('ORDER_UNIT_FOR_P',(newValue / record.get('EXCHG_RATE_O')));	//	구매단가 = 입력한 자사단가 / 환율
                    	record.set('ORDER_UNIT_FOR_O',(record.get('ORDER_UNIT_Q') * newValue / record.get('EXCHG_RATE_O')));	//구매금액 = 입고량 * 입력한 자사단가 / 환율
                    	//record.set('ORDER_UNIT_FOR_O') =
               //보류 반올림     	Math.round(record.get('ORDER_UNIT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));

                    	record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
                    	//record.set('INOUT_FOR_O') =
               //보류 반올림     	Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
                    	//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("INOUT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));

                    }else{
                    	record.set('INOUT_FOR_O','0');
                    	record.set('INOUT_FOR_P','0');
                    	record.set('ORDER_UNIT_FOR_O','0');
                    	record.set('ORDER_UNIT_FOR_P','0');
                    }
                    directMasterStore1.fnSumAmountI();
                    break;
				case "ORDER_UNIT_I" :	//자사금액
					if(record.get('ORDER_UNIT_Q') != ''){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code = "unilite.msg.sMB076"/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code = "unilite.msg.sMB077"/>';
							break;
						}
					}

					//record.set('INOUT_I') =
		//보류 반올림			Math.round(newValue,CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(lRow,lCol), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_P',(record.get('INOUT_I') / record.get('INOUT_Q')));	//자사단가(재고) = 자사금액(재고) / 재고단위수량
						record.set('ORDER_UNIT_P',(newValue / record.get('ORDER_UNIT_Q')));	//자사단가 = 입력한 자사금액 / 입고량
					}else{
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_P','0');
					}

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_P') / record.get('EXCHG_RATE_O')));	//재고단위단가 = 자사단가(재고) / 환율
						record.set('ORDER_UNIT_FOR_P',(record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O')));	//구매단가 = 자사단가 / 환율
						record.set('ORDER_UNIT_FOR_O',(newValue / record.get('EXCHG_RATE_O')));	//구매금액 = 입력한 자사금액 / 환율
						//record.set('ORDER_UNIT_FOR_O') =
			//보류 반올림			Math.round(record.get('ORDER_UNIT_FOR_O'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_FOR_O")),top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
						record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					}else{
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}
                    directMasterStore1.fnSumAmountI();
                    break;

				case "ORDER_UNIT_FOR_P":	//구매단가
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}

					}

					//record.set('ORDER_UNIT_FOR_O') =
		//보류 반올림			Math.round((record.get('ORDER_UNIT_Q') * newValue),CustomCodeInfo.gsUnderCalBase);
					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * newValue);
					//fnRound(fnCDbl(grdsheet1.TextMatrix(lRow,grdsheet1.colindex("ORDER_UNIT_Q")))  *  fnCDbl(grdsheet1.TextMatrix(lRow,	grdsheet1.colindex("ORDER_UNIT_FOR_P"))), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
                    directMasterStore1.fnSumAmountI();

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(newValue * record.get('EXCHG_RATE_O')));	//자사단가 = 입력한 구매단가 * 환율
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가
						//record.set('ORDER_UNIT_I') =
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
						//record.set('INOUT_I') =
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag,top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;

				case "EXCHG_RATE_O" :	//환율
					if((record.get('ACCOUNT_YNC')== 'Y') && (record.get('INOUT_TYPE_DETAIL') != '91') && (record.get('PRICE_YN') == 'Y')){
						if(newValue <= 0){
							rv='<t:message code = "unilite.msg.sMM375"/>';
							break;
						}
					}else{
						if(newValue < 0){
							rv='<t:message code = "unilite.msg.sMM376"/>';
							break;
						}
					}

					//record.set('ORDER_UNIT_FOR_O') =
		//보류 반올림			Math.round((record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P')),CustomCodeInfo.gsUnderCalBase);
					//fnRound(fnCDbl(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_Q")))  *  fnCDbl(grdsheet1.TextMatrix(lRow,grdsheet1.colindex("ORDER_UNIT_FOR_P"))), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
                    directMasterStore1.fnSumAmountI();

					if(newValue != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * newValue));	//자사단가(재고) = 재고단위단가 * 입력한 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * newValue));
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));
						//record.set('ORDER_UNIT_I') =
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
						//record.set('INOUT_I') =
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;

				case "ORDER_UNIT_FOR_O" : //구매금액
					if(record.get('ORDER_UNIT_Q') != ''){
						if((newValue <= 0) && (record.get('ORDER_UNIT_Q') > 0)){
							rv='<t:message code = "unilite.msg.sMB076"/>';
							break;
						}else if((newValue >= 0) && (record.get('ORDER_UNIT_Q') < 0)){
							rv='<t:message code = "unilite.msg.sMB077"/>';
							break;
						}
					}

					//record.set('INOUT_FOR_O') =
			//보류 반올림 		Math.round(newValue,CustomCodeInfo.gsUnderCalBase);
					//fnRound(grdsheet1.TextMatrix(lRow,lCol) , top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
						record.set('ORDER_UNIT_FOR_P',(newValue / record.get('ORDER_UNIT_Q')));	//구매단가 = 입력한 구매금액 / 입고량
					}else{
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_P','0');
					}

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I',(newValue * record.get('EXCHG_RATE_O')));	//자사금액 = 입력한 구매금액 * 환율
						//record.set('ORDER_UNIT_I') =
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
						//record.set('INOUT_I') =
			//보류 반올림			Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"))
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
                    directMasterStore1.fnSumAmountI();
                    break;

				case "MONEY_UNIT" :
			//			"mms510ukrs1v
			//			1392줄~1404줄"

			//			"mms510ukrs1v
			//			1406줄~1416줄"
					if(newValue == BsaCodeInfo.gsDefaultMoney){
						record.set('EXCHG_RATE_O','1');
					}//else

					//record.set('ORDER_UNIT_FOR_O') =
		//보류 반올림			Math.round((record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P')),CustomCodeInfo.gsUnderCalBase);

					record.set('ORDER_UNIT_FOR_O', record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P'));	//구매금액 = 입고량 * 구매단가
					//fnRound(fnCDbl(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_Q"))) * fnCDbl(grdsheet1.TextMatrix(lRow,grdsheet1.colindex("ORDER_UNIT_FOR_P"))), top.sWonflag, top.goCnn.GetFSET("M_FSET_OS"));
					record.set('INOUT_FOR_O',(record.get('ORDER_UNIT_FOR_O')));	//재고단위금액 = 구매금액
					if(record.get('INOUT_Q') != 0){
						record.set('INOUT_FOR_P',(record.get('INOUT_FOR_O') / record.get('INOUT_Q')));	//재고단위단가 = 재고단위금액 / 재고단위수량
					}
                    directMasterStore1.fnSumAmountI();

					if(record.get('EXCHG_RATE_O') != 0){
						record.set('INOUT_P',(record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가(재고) = 재고단위단가 * 환율
						record.set('ORDER_UNIT_P',(record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O')));	//자사단가 = 구매단가 * 환율
						record.set('ORDER_UNIT_I',(record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P')));	//자사금액 = 입고량 * 자사단가
						//record.set('ORDER_UNIT_I') =
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")), top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
						//record.set('INOUT_I') =
				//보류 반올림		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
						//fnRound(grdsheet1.TextMatrix(lRow, grdsheet1.colindex("ORDER_UNIT_I")),top.sWonflag, top.goCnn.GetFSET("M_FSET_IS"));
					}else{
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');
					}
					break;

				case "INOUT_TYPE_DETAIL" :
				record.set('ACCOUNT_YNC', UniAppManager.app.fnInTypeAccountYN(newValue));

					if(record.get('ACCOUNT_YNC') == 'N'){
						record.set('PRICE_YN','N');
						record.set('INOUT_FOR_O','0');
						record.set('INOUT_FOR_P','0');
						record.set('ORDER_UNIT_FOR_O','0');
						record.set('ORDER_UNIT_FOR_P','0');
						record.set('INOUT_I','0');
						record.set('INOUT_P','0');
						record.set('ORDER_UNIT_I','0');
						record.set('ORDER_UNIT_P','0');

                    	directMasterStore1.fnSumAmountI();
					}else{
						record.set('PRICE_YN','Y');
					}
					break;

				case "ACCOUNT_YNC":
					if(newValue == 'N'){
						record.set('PRICE_YN','N');
					}
					break;
				case "PRICE_YN":
					if(newValue == 'Y'){
						if((record.get('INOUT_P') == 0) || (record.get('ORDER_UNIT_P') == 0)){
							rv='<t:message code = "unilite.msg.sMM327"/>';
							break;
						}
					}
					break;
				case "PROJECT_NO":
				//	UniAppManager.app.fnPlanNumChange(); //fnPlanNumChange 만들어야함
					break;
				case "TRANS_COST":
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMM376"/>';
						break;
					}

				case "TARIFF_AMT":
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMM376"/>';
						break;
					}
	/*
*//*							이전값 != 입력값 일때
			If "" & grdSheet1.TextMatrix(lRow,0) = " " Then               '갱신될 자료
			       grdSheet1.TextMatrix(lRow,0)    =        "U"
			       glAffectedCnt = glAffectedCnt + 1
			End If


			'        변경된 자료가 존재함으로 저장할 수 있음
			If top.goCnn.bEnableSaveBtn = 0 Then
			   top.goCnn.bEnableSaveBtn        = 1
			    grdSheet1.RowData(grdSheet1.row) = "S"
			End If*/
	//				break;
			}
				return rv;
						}
			});
	Unilite.createValidator('validator02', {
		forms: {'formA:':masterForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "EXCHG_RATE_O" :  // 환율
					if(masterForm.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney){
							if(newValue != '1'){
								rv='<t:message code = "unilite.msg.sMM336"/>';
								break;
							}
					}
					break;

			}
			return rv;
		}
	}); // validator02

};

</script>