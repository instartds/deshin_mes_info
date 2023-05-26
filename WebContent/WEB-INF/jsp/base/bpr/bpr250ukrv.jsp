<%--
'   프로그램명 : 사업장품목정보등록 (기준)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버	  전 : OMEGA Plus V6.0.0
--%>


<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr250ukrv"  >

<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 계정 -->
<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
<t:ExtComboStore comboType="W" /><!-- 주창고  -->
<t:ExtComboStore comboType="AU" comboCode="B061" /><!-- 발주방침 -->
<t:ExtComboStore comboType="AU" comboCode="B037" /><!-- ABC구분 -->
<t:ExtComboStore comboType="AU" comboCode="B039" /><!-- 출고방법 -->
<t:ExtComboStore comboType="AU" comboCode="B023" /><!-- 실적입고방법 -->
<t:ExtComboStore comboType="AU" comboCode="B061" /><!-- Lot sizing -->
<t:ExtComboStore comboType="O" /><!--  주작업장 -->
<t:ExtComboStore comboType="BOR120" /><!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B052" /><!-- 품목정보검색항목 -->
<t:ExtComboStore comboType="AU" comboCode="B018" /><!-- 예(1)/아니오(2) -->
<t:ExtComboStore comboType="AU" comboCode="P006" /><!-- 생산방식 -->
<t:ExtComboStore comboType="AU" comboCode="Q005" /><!-- 수입검사방법 -->
<t:ExtComboStore comboType="AU" comboCode="Q006" /><!-- 공정검사방법 -->
<t:ExtComboStore comboType="AU" comboCode="Q007" /><!-- 출하검사방법 -->
<t:ExtComboStore comboType="AU" comboCode="A020" /><!-- 예(Y)/아니오(N) -->
<t:ExtComboStore comboType="AU" comboCode="M201" /><!-- 구매담당 -->
<t:ExtComboStore comboType="AU" comboCode="B074" /><!-- 양산구분 -->
<t:ExtComboStore comboType="AU" comboCode="B202" /><!-- 저장구분 -->
<t:ExtComboStore comboType="AU" comboCode="B093" /><!-- 공정구분  -->
<t:ExtComboStore comboType="AU" comboCode="CD37" /><!-- 품목조회방식 -->
<t:ExtComboStore comboType="AU" comboCode="CD38" /><!-- 적상적용단가  -->
<t:ExtComboStore comboType="AU" comboCode="WB19" /><!-- 츨고부서구분 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="BPR250ukrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="BPR250ukrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="BPR250ukrvLevel3Store" />
<t:ExtComboStore items="${COMBO_DIV_PRSN}" storeId="BPR250ukrvDIV_PRSNStore" />

<t:ExtComboStore comboType="AU" comboCode="B093" /><!-- 공정  -->
<t:ExtComboStore comboType="OU" /><!-- 창고  -->
<t:ExtComboStore comboType="WU" /><!-- 작업장  -->
</t:appConfig>

<script type="text/javascript" >
var detailWin;
var sumtypeCell = true; //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
if('${gsSumTypeCell}' =='Y') {
	sumtypeCell = false;
}
function appMain() {
	// 창고 콤보
//	var BSA220TComboStore = Unilite.createStore('bpr250ukrvBSA220TComboStore',{
//		   	autoLoad: false,
//		   	storeId:'bpr250ukrvBSA220TComboStore',
//			fields:['value','text','option'],
//		   	proxy: {
//			   type: 'direct',		/*'uniDirect',*/
//			   api: {
//			   	read: 'baseCommonService.fnRecordCombo'
//
//			   }
//			}
//			,loadStoreRecords : function(divCode)	{
//				if(divCode == '' || divCode==null) divCode=UserInfo.divCode;
//				console.log('fnRecordCombo divCode', divCode);
//				var param= {'TYPE':'BSA220T','COMP_CODE':UserInfo.compCode, 'DIV_CODE':divCode};
//				console.log( param );
//				this.load({
//					params : param
//				});
//			}
//	});
//	// 작업장 콤보
//	var BSA230TComboStore = Unilite.createStore('bpr250ukrvBSA230TComboStore',{
//		   	autoLoad: false,
//			fields:['value','text','option'],
//		   	proxy: {
//			   type: 'direct',		/*'uniDirect',*/
//			   api: {
//			   	read: 'baseCommonService.fnRecordCombo'
//
//			   }
//			}
//			,loadStoreRecords : function(divCode)	{
//				if(divCode == '' || divCode==null) divCode=UserInfo.divCode;
//				console.log('fnRecordCombo divCode', divCode);
//				var param= {'TYPE':'BSA230T','COMP_CODE':UserInfo.compCode, 'DIV_CODE':divCode};
//				console.log( param );
//				this.load({
//					params : param
//				});
//			}
//	});
//
//
//	//공정구분 콤보
//	var DIV_PRSNComboStore = Unilite.createStore('bpr250ukrvDIV_PRSNComboStore',{
//		   	autoLoad: false,
//			fields:['value','text','option'],
//		   	proxy: {
//			   type: 'direct',		/*'uniDirect',*/
//			   api: {
//			   	read: 'baseCommonService.fnRecordCombo'
//
//			   }
//			}
//			,loadStoreRecords : function(divCode)	{
//				if(divCode == '' || divCode==null) divCode=UserInfo.divCode;
//				console.log('fnRecordCombo divCode', divCode);
//				var param= {'TYPE':'DIV_PRSN','COMP_CODE':UserInfo.compCode, 'DIV_CODE':divCode};
//				console.log( param );
//				this.load({
//					params : param
//				});
//			}
//	});
//

	function fnRecordCombo(fName,  divCode, type)	{
		var param= {'TYPE':type,'COMP_CODE':UserInfo.compCode, 'DIV_CODE':divCode};
		var field = detailForm.getField(fName)
		var store = field.getStore();
		//Unilite.messageBox("fnRecordCombo");
		store.clearFilter(true);
		store.filter('option', divCode);
		field.parentOptionValue = divCode;
		field.clearValue();
		/*baseCommonService.fnRecordCombo(param
										,function(provider, response)	{
											//var store = Ext.data.StoreManager.lookup(storeId);
											var field = detailForm.getField(fName)
											var store = field.getStore();
											store.removeAll();
											store.loadData(provider);



											console.log("finish");
										})*/
	}
	Unilite.defineModel('bpr250ukrvModel', {
		fields: [
			 {name: 'DIV_CODE'					,text:'<t:message code="system.label.base.division" default="사업장"/>'  			 ,type : 'string'	, allowBlank:false 	,allowBlank:false, isPk:true, pkGen:'user'}
			,{name: 'ITEM_CODE'					,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>'		   ,type : 'string'	, allowBlank:false , editable:false}
			,{name: 'ITEM_NAME'					,text:'<t:message code="system.label.base.itemname" default="품목명"/>'			,type : 'string'	, allowBlank:false , editable:false}
			,{name: 'ITEM_NAME1'				,text:'<t:message code="system.label.base.itemname01" default="품명1"/>'		 	 ,type : 'string'}
			,{name: 'ITEM_NAME2'				,text:'<t:message code="system.label.base.itemname02" default="품명2"/>'		 	 ,type : 'string'}
			,{name: 'SPEC'						,text:'<t:message code="system.label.base.spec" default="규격"/>'		 	 ,type : 'string', editable:false}
			,{name: 'SFLAG'						,text:'<t:message code="system.label.base.entryyn" default="등록여부"/>'		  ,type : 'string', comboType:'AU', comboCode:'B018', editable:false}
			,{name: 'BCNT'						,text:'<t:message code="system.label.base.bomentry" default="BOM등록"/>'		  ,type : 'string', comboType:'AU', comboCode:'B018'}
			,{name: 'BCNT1'						,text:'<t:message code="system.label.base.purchaseregister" default="구매단가등록"/>'		 ,type : 'string', comboType:'AU', comboCode:'B018'}
			,{name: 'BCNT2'						,text:'<t:message code="system.label.base.salesunitentry" default="판매단가등록"/>'		 ,type : 'string', comboType:'AU', comboCode:'B018'}
			,{name: 'STOCK_UNIT'				,text:'<t:message code="system.label.base.inventoryunit" default="재고단위"/>'		  ,type : 'string', editable:false, displayField: 'value'}

			,{name: 'ITEM_LEVEL1'				,text:'<t:message code="system.label.base.majorgroup" default="대분류"/>'		   ,type : 'string', store: Ext.data.StoreManager.lookup('BPR250ukrvLevel1Store'), child:'ITEM_LEVEL2'}
			,{name: 'ITEM_LEVEL2'				,text:'<t:message code="system.label.base.middlegroup" default="중분류"/>'		   ,type : 'string', store: Ext.data.StoreManager.lookup('BPR250ukrvLevel2Store'), child:'ITEM_LEVEL3'}
			,{name: 'ITEM_LEVEL3'				,text:'<t:message code="system.label.base.minorgroup" default="소분류"/>'		   ,type : 'string', store: Ext.data.StoreManager.lookup('BPR250ukrvLevel3Store')}

			,{name: 'ITEM_ACCOUNT'				,text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>'		 ,type : 'string'	, allowBlank:false , comboType:'AU', comboCode:'B020'}
			,{name: 'SUPPLY_TYPE'				,text:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>'		 ,type : 'string'	, allowBlank:false , comboType:'AU', comboCode:'B014'}
//				,{name: 'ITEM_GUBUN'				,text:'저장구분'		 													,type : 'string', comboType:'AU', comboCode:'B202'}
			,{name: 'ORDER_UNIT'				,text:'<t:message code="system.label.base.purchaseunit" default="구매단위"/>'		 ,type : 'string'	, allowBlank:false , comboType:'AU', comboCode:'B013', displayField: 'value'}
			,{name: 'TRNS_RATE'					,text:'<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>'														  ,type : 'uniER'	, allowBlank:false }

			,{name: 'WH_CODE'					,text:'<t:message code="system.label.base.mainwarehouse" default="주창고"/>'		   ,type : 'string'	, allowBlank:false , comboType:'OU'}
			,{name: 'LOCATION'					,text:'Location'	   ,type : 'string'}
			,{name: 'ORDER_PLAN'				,text:'<t:message code="system.label.base.popolicy" default="발주방침"/>'		  ,type : 'string'	, allowBlank:false , comboType:'AU', comboCode:'B061', defaultValue:'1'}
			,{name: 'MATRL_PRESENT_DAY'   		,text:'<t:message code="system.label.base.materialfixedperiod" default="자재올림기간"/>'	   ,type : 'uniPrice'}
			,{name: 'PURCHASE_BASE_P'			,text:'<t:message code="system.label.base.purchaseprice" default="구매단가"/>'		  ,type : 'uniUnitPrice'}
			,{name: 'ORDER_PRSN'				,text:'<t:message code="system.label.base.purchasecharger" default="자사구매담당"/>'  ,type : 'string', comboType:'AU', comboCode:'M201'}
			,{name: 'ABC_FLAG'					,text:'<t:message code="system.label.base.abcclassification" default="ABC구분"/>'		 ,type : 'string', comboType:'AU', comboCode:'B037'}
			,{name: 'LOT_YN'					,text:'<t:message code="system.label.base.lotmanageyn" default="LOT관리여부"/>'														,type : 'string' , comboType:'AU', comboCode:'A020', allowBlank:false, defaultValue: 'N'}
			,{name: 'PHANTOM_YN'				,text:'<t:message code="system.label.base.phantomyn" default="팬텀여부"/>'														   ,type : 'string' , comboType:'AU', comboCode:'A020', allowBlank:false}
			,{name: 'EXCESS_RATE'				,text:'<t:message code="system.label.base.overreceiptrate" default="과입고허용율"/>'	   ,type : 'uniPercent' }
			,{name: 'EXPENSE_RATE'				,text:'<t:message code="system.label.base.importexpenserate" default="수입부대비용율"/>'	  ,type : 'uniPercent' }
			//MRP정보
			,{name: 'ORDER_KIND'				,text:'<t:message code="system.label.base.ordercreationyn" default="오더생성여부"/>'	  ,type : 'string', comboType:'AU', comboCode:'A020'}
			,{name: 'NEED_Q_PRESENT'			,text:'<t:message code="system.label.base.reqroundtype" default="소요량올림구분"/>'	 ,type : 'string', comboType:'AU', comboCode:'A020'}
			,{name: 'EXC_STOCK_CHECK_YN'  		,text:'<t:message code="system.label.base.availableinventorycheck" default="가용재고체크"/>'	  ,type : 'string', comboType:'AU', comboCode:'A020'}
			,{name: 'SAFE_STOCK_Q'				,text:'<t:message code="system.label.base.safetystockqty" default="안전재고량"/>'	   ,type : 'uniPrice'}
			,{name: 'NEED_Q_PRESENT_Q'			,text:'<t:message code="system.label.base.reqroundcount" default="소요량올림수"/>'	  ,type : 'uniQty'}   //uniQty
			//구매정보
			,{name: 'PURCH_LDTIME'				,text:'<t:message code="system.label.base.purchaselt" default="구매 L/T"/>'		,type : 'int'}
			,{name: 'MINI_PURCH_Q'				,text:'<t:message code="system.label.base.minumunorderqty" default="최소발주량"/>'	   ,type : 'uniQty'}
			,{name: 'MAX_PURCH_Q'				,text:'<t:message code="system.label.base.maximumorderqty" default="최대발주량"/>'	   ,type : 'uniQty'}
			,{name: 'CUSTOM_CODE'				,text:'<t:message code="system.label.base.maincustomcode" default="주거래처코드"/>'	  ,type : 'string'}
			,{name: 'CUSTOM_NAME'				,text:'<t:message code="system.label.base.maincustom" default="주거래처"/>'		,type : 'string'}
			,{name: 'TEMPC_01'					,text:'<t:message code="system.label.base.salesdeptdivision" default="매출부서구분"/>', type : 'string', comboType:'AU', comboCode:'WB19'}
			//
			,{name: 'ROP_YN'					,text:'<t:message code="system.label.base.ropyn" default="ROP대상여부"/>'	 ,type : 'string' , comboType:'AU', comboCode:'A020'}
			,{name: 'DAY_AVG_SPEND'				,text:'<t:message code="system.label.base.averageqty" default="일일평균소비량"/>'	,type : 'uniQty'	 }
			,{name: 'ORDER_POINT'				,text:'<t:message code="system.label.base.fixedorderqty" default="고정발주량"/>'	   ,type : 'uniQty'	 }
			,{name: 'BASIS_P'					,text:'<t:message code="system.label.base.inventoryprice" default="재고단가"/>'		,type : 'uniUnitPrice'}
			,{name: 'COST_YN'					,text:'<t:message code="system.label.base.costcalculationobject" default="원가계산대상"/>'	 ,type : 'string' , comboType:'AU', comboCode:'A020'}
			,{name: 'COST_PRICE'				,text:'<t:message code="system.label.base.cost" default="원가"/>'		   ,type : 'uniPrice'}
			,{name: 'REAL_CARE_YN'				,text:'<t:message code="system.label.base.stockcountingitem" default="실사대상"/>'		,type : 'string' , comboType:'AU', comboCode:'A020'}
			,{name: 'REAL_CARE_PERIOD'			,text:'<t:message code="system.label.base.stockcountingcycel" default="실사주기"/>'		,type : 'int'}
			,{name: 'MINI_PACK_Q'				,text:'<t:message code="system.label.base.minimumpackagingunit" default="최소포장단위"/>'	 ,type : 'uniQty'}
			//생산정보
			,{name: 'ORDER_METH'				,text:'<t:message code="system.label.base.productionmethod" default="생산방식"/>'		 ,type : 'string', comboType:'AU', comboCode:'P006'}
			,{name: 'OUT_METH'					,text:'<t:message code="system.label.base.issuemethod" default="출고방법"/>'		 ,type : 'string', comboType:'AU', comboCode:'B039'}
			,{name: 'RESULT_YN'					,text:'<t:message code="system.label.base.resultsreceiptmethod" default="실적입고방법"/>'	  ,type : 'string', comboType:'AU', comboCode:'B023'}
			,{name: 'PRODUCT_LDTIME'			,text:'<t:message code="system.label.base.mfglt" default="제조 L/T"/>'		,type : 'int'}
			,{name: 'MAX_PRODT_Q'				,text:'<t:message code="system.label.base.maximumproductqty" default="최대생산량"/>'	   ,type : 'uniQty'}
			,{name: 'STAN_PRODT_Q'				,text:'<t:message code="system.label.base.standardproductionqty" default="표준생산량"/>'	   ,type : 'uniQty'}
			,{name: 'ROUT_TYPE'					,text:'<t:message code="system.label.base.routingtype" default="공정구분"/>'	,type : 'string', store: Ext.data.StoreManager.lookup('BPR250ukrvDIV_PRSNStore') }
			,{name: 'WORK_SHOP_CODE'			,text:'<t:message code="system.label.base.mainworkcenter" default="주작업장"/>'		 ,type : 'string', comboType:'WU'}
			,{name: 'ITEM_TYPE'					,text:'<t:message code="system.label.base.productiontype" default="양산구분"/>'		 ,type : 'string', comboType:'AU', comboCode:'B074'}
			,{name: 'MAN_HOUR'					,text:'<t:message code="system.label.base.standardtacttime" default="표준공수"/>'		 ,type : 'uniER'}

			,{name: 'ITEM_CODE2'				,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>'		 ,type : 'string'}
			,{name: 'DIST_LDTIME'				,text:'<t:message code="system.label.base.polt" default="발주 L/T"/>'		,type : 'int'}
			,{name: 'ATP_LDTIME'				,text:'<t:message code="system.label.base.atplt" default="ATP L/T"/>'	   ,type : 'int'}
			,{name: 'INSPEC_YN'					,text:'<t:message code="system.label.base.qualityyn" default="품질대상여부"/>'	 ,type : 'string', comboType:'AU', comboCode:'A020'}
			,{name: 'BAD_RATE'					,text:'<t:message code="system.label.base.defectrate" default="불량율"/>'		 ,type : 'uniPercent'}
			,{name: 'INSPEC_METH_MATRL'			,text:'<t:message code="system.label.base.importinspectionmethod" default="수입검사방법"/>'	 ,type : 'string', comboType:'AU', comboCode:'Q005'}
			,{name: 'INSPEC_METH_PROG'			,text:'<t:message code="system.label.base.routinginspemethod" default="공정검사방법"/>'	 ,type : 'string', comboType:'AU', comboCode:'Q006'}
			,{name: 'INSPEC_METH_PRODT'			,text:'<t:message code="system.label.base.shipmentinspectionmethod" default="출하검사방법"/>'	 ,type : 'string', comboType:'AU', comboCode:'Q007'}
			,{name: 'ITEM_ACCOUNT_ORG'			,text:'<t:message code="system.label.base.itemaccountorg" default="품목계정조회값"/>'	,type : 'string'}
			//20190305 추가 (관리대상품목, 사유)
			,{name: 'CARE_YN'					,text: '<t:message code="system.label.base.manageditems" default="관리대상품목"/>'	, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'}
			,{name: 'CARE_REASON'				,text: '<t:message code="system.label.base.reason" default="사유"/>'				, type: 'string'}
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr250ukrvService.selectDetailList',
			update: 'bpr250ukrvService.updateDetail',
//			create: 'bpr250ukrvService.insertDetail',
			destroy: 'bpr250ukrvService.deleteDetail',
			syncAll: 'bpr250ukrvService.saveAll'
		}
	});

	var directMasterStore = Unilite.createStore('bpr250ukrvMasterStore',{
			model: 'bpr250ukrvModel',
		   	autoLoad: false,
			uniOpt : {
				isMaster: true,			// 상위 버튼 연결
				editable: true,			// 수정 모드 사용
				deletable:true,			// 삭제 가능 여부
				useNavi : false			// prev | next 버튼 사용
			},
		   	proxy: directProxy
			,listeners: {
				load: function(store, records, successful, eOpts) {
			   		if(!Ext.isEmpty(records)){
			   			panelSearch.getField('DIV_CODE').setReadOnly( true );
			   			panelResult.getField('DIV_CODE').setReadOnly( true );
		   			}
		   		},
				write: function(proxy, operation){
					if (operation.action == 'destroy') {
						Ext.getCmp('detailForm').reset();
					}
				}
			}
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('bpr250ukrvSearchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
			,saveStore : function(config)	{
//				var app = Ext.getCmp('bpr250ukrvApp');
				var inValidRecs = this.getInvalidRecords();

				if(inValidRecs.length == 0 )	{
					if(config == null)	{
						config = {success : function() {

								 }};
					}
					this.syncAllDirect(config);
				}else {

			   		 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					if(masterGrid.isVisible())	{
						detailForm.setActiveRecord(record);
					}
				}
			}
	});

	var panelSearch = Unilite.createSearchPanel('bpr250ukrvSearchForm',{
		title:'<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
		defaults: {
			autoScroll:true
	  	},
		width: 330,
		items: [
			{
				title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
				id: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
				items :[{
									name: 'DIV_CODE'
									  ,fieldLabel:'<t:message code="system.label.base.division" default="사업장"/>'
									  ,allowBlank:false
									  ,xtype:'uniCombobox'
									  ,comboType:'BOR120'
									  ,enableKeyEvents:false
									  ,value:UserInfo.divCode
									  ,listeners:{
									  			  change:function( combo, newValue, oldValue, eOpts )	{
									  						panelResult.setValue('DIV_CODE', newValue);
									  			  			fnRecordCombo('WH_CODE', newValue, 'BSA220T');
									  			  			fnRecordCombo('WORK_SHOP_CODE', newValue, 'BSA230T');
									  			  			fnRecordCombo('ROUT_TYPE', newValue, 'DIV_PRSN');
									  				   }
									  			}
									  }
									 //,{name: 'WH_CODE'					,fieldLabel:'<t:message code="unilite.msg.sMR352" default="주창고"/>'		 	,xtype:'uniCombobox'	, allowBlank:false , store: BSA220TComboStore}

									,{name: 'ITEM_CODE'	,fieldLabel:'<t:message code="system.label.base.itemcode" default="품목코드"/>',
										listeners: {
											change: function(field, newValue, oldValue, eOpts) {
												panelResult.setValue('ITEM_CODE', newValue);
											}
										}
									}
									,{name: 'ITEM_NAME'	,fieldLabel:'<t:message code="system.label.base.itemname" default="품목명"/>',
										listeners: {
											change: function(field, newValue, oldValue, eOpts) {
												panelResult.setValue('ITEM_NAME', newValue);
											}
										}
									}
									,{name: 'ITEM_ACCOUNT' ,fieldLabel:'<t:message code="system.label.base.itemaccount" default="품목계정"/>' ,xtype:'uniCombobox'	, comboType:'AU', comboCode:'B020',
										listeners: {
											change: function(field, newValue, oldValue, eOpts) {
												panelResult.setValue('ITEM_ACCOUNT', newValue);
											}
										}
									}
									,{name: 'FIND_TYPE'	,fieldLabel:'<t:message code="system.label.base.searchitem" default="검색항목"/>' ,xtype:'uniCombobox'	, comboType:'AU', comboCode:'B052',
						 				listeners: {
											change: function(field, newValue, oldValue, eOpts) {
												panelResult.setValue('FIND_TYPE', newValue);
											}
										}
						 			}
									,{name: 'FIND_TXT'	,fieldLabel:'<t:message code="system.label.base.searchword" default="검색어"/>',
										listeners: {
											change: function(field, newValue, oldValue, eOpts) {
												panelResult.setValue('FIND_TXT', newValue);
											}
										}
									}
									/*,{	xtype:'container'
										,colspan: 2
										,width: 490
										,layout : 'hbox'
										,defaults: {align:'stretch'}

										,items:[//Unilite.popup('ITEM',{textFieldWidth:160, valueFieldWidth:80,width: 340})
												//,{name: 'ITEM_SPEC'  ,xtype: 'uniTextfield'  ,fieldLabel:'<t:message code="system.label.base.spec" default="규격"/>', hideLabel:true, width:150, readOnly:true}
											   ]
									}*/
									,{name: 'SUPPLY_TYPE'	,fieldLabel:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B014',
										listeners: {
											change: function(field, newValue, oldValue, eOpts) {
												panelResult.setValue('SUPPLY_TYPE', newValue);
											}
										}
									}
									,{name: 'ORDER_PRSN'	,fieldLabel:'<t:message code="system.label.base.purchasecharge" default="구매담당"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'M201',
										listeners: {
											change: function(field, newValue, oldValue, eOpts) {
												panelResult.setValue('ORDER_PRSN', newValue);
											}
										}
									}
									,{name: 'SFLAG'	,fieldLabel:'<t:message code="system.label.base.entryyn" default="등록여부"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B018', value: '1' ,
										listeners: {
											change: function(field, newValue, oldValue, eOpts) {
												panelResult.setValue('SFLAG', newValue);
											}
										}
									}
								]
						 },
						 {
							title:'<t:message code="system.label.base.additionalinfo" default="추가정보"/>',
				   			id: 'search_panel2',
							itemId:'search_panel2',
							defaultType: 'uniTextfield',
							layout: {type: 'uniTable', columns: 1},
						 	items: [ {name: 'BCNT'	,fieldLabel:'<t:message code="system.label.base.bomentry" default="BOM등록"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B018'}
									,{name: 'BCNT1'	,fieldLabel:'<t:message code="system.label.base.purchaseregister" default="구매단가등록"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B018'}
									,{name: 'DIST_LDTIME'	,fieldLabel:'<t:message code="system.label.base.poltentry" default="발주 L/T 등록"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B018'}
									,{name: 'BCNT2'	,fieldLabel:'<t:message code="system.label.base.salesunitentry" default="판매단가등록"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B018'}
//									,{name: 'ITEM_GUBUN'	,fieldLabel:'저장구분', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B202'}
									,{name: 'ORDER_METH' 	,fieldLabel:'<t:message code="system.label.base.productionmethod" default="생산방식"/>'	 	,xtype:'uniCombobox', comboType:'AU', comboCode:'P006'}
								  ]
						 }
	   		 ]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			   name: 'DIV_CODE'
			  ,fieldLabel:'<t:message code="system.label.base.division" default="사업장"/>'
			  ,allowBlank:false
			  ,xtype:'uniCombobox'
			  ,comboType:'BOR120'
			  ,enableKeyEvents:false
			  ,value:UserInfo.divCode
			  ,listeners:{
			  			  change:function( combo, newValue, oldValue, eOpts )	{
			  						panelSearch.setValue('DIV_CODE', newValue);
			  			  			fnRecordCombo('WH_CODE', newValue, 'BSA220T');
			  			  			fnRecordCombo('WORK_SHOP_CODE', newValue, 'BSA230T');
			  			  			fnRecordCombo('ROUT_TYPE', newValue, 'DIV_PRSN');
			  				   }
			  			}
			  }
			 //,{name: 'WH_CODE'					,fieldLabel:'<t:message code="unilite.msg.sMR352" default="주창고"/>'		 	,xtype:'uniCombobox'	, allowBlank:false , store: BSA220TComboStore}
			,{name: 'ITEM_CODE'	,fieldLabel:'<t:message code="system.label.base.itemcode" default="품목코드"/>',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_CODE', newValue);
					}
				}
			}
			,{name: 'ITEM_NAME'	,fieldLabel:'<t:message code="system.label.base.itemname" default="품목명"/>',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_NAME', newValue);
					}
				}
			}
			,{name: 'ITEM_ACCOUNT' ,fieldLabel:'<t:message code="system.label.base.itemaccount" default="품목계정"/>' ,xtype:'uniCombobox'	, comboType:'AU', comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}
			,{name: 'FIND_TYPE'	,fieldLabel:'<t:message code="system.label.base.searchitem" default="검색항목"/>' ,xtype:'uniCombobox'	, comboType:'AU', comboCode:'B052',
 				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('FIND_TYPE', newValue);
					}
				}
 			}
			,{name: 'FIND_TXT'	,fieldLabel:'<t:message code="system.label.base.searchword" default="검색어"/>',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('FIND_TXT', newValue);
					}
				}
			}
			/*,{	xtype:'container'
				,colspan: 2
				,width: 490
				,layout : 'hbox'
				,defaults: {align:'stretch'}

				,items:[//Unilite.popup('ITEM',{textFieldWidth:160, valueFieldWidth:80,width: 340})
						//,{name: 'ITEM_SPEC'  ,xtype: 'uniTextfield'  ,fieldLabel:'<t:message code="system.label.base.spec" default="규격"/>', hideLabel:true, width:150, readOnly:true}
					   ]
			}*/
			,{name: 'SUPPLY_TYPE'	,fieldLabel:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B014',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SUPPLY_TYPE', newValue);
					}
				}
			}
			,{name: 'ORDER_PRSN'	,fieldLabel:'<t:message code="system.label.base.purchasecharge" default="구매담당"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'M201',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_PRSN', newValue);
					}
				}
			}
			,{name: 'SFLAG'	,fieldLabel:'<t:message code="system.label.base.entryyn" default="등록여부"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B018', value:'1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SFLAG', newValue);
					}
				}
			}]
	});

	 var masterGrid = Unilite.createGrid('bpr250ukrvGrid', {
	 	region:'center',
		store : directMasterStore,
		sortableColumns : true,
		uniOpt:{
					 expandLastColumn: true
					,useRowNumberer: false
					,useMultipleSorting: true
				},
		/*tbar: [
				{
				text:'상세보기',
				handler: function() {
					var record = masterGrid.getSelectedRecord();
					if(record) {
						openDetailWindow(record);
					}
				}
		}],*/
		columns:  [  { dataIndex: 'DIV_CODE',  			width: 80 			, hidden: true}
					,{ dataIndex: 'ITEM_CODE',  		width: 160		  , isLink:true}
					,{ dataIndex: 'ITEM_NAME',  		width: 140		  }
					,{ dataIndex: 'ITEM_NAME1',  		width: 80		   , hidden: true}
					,{ dataIndex: 'ITEM_NAME2',  		width: 80		   , hidden: true}
					,{ dataIndex: 'SPEC',  				width: 170		  }
					,{ dataIndex: 'SFLAG',  			width: 80			, align: 'center'}
					,{ dataIndex: 'BCNT',  				width: 80		   , hidden: true}
					,{ dataIndex: 'BCNT1',  			width: 80		   , hidden: true}
					,{ dataIndex: 'BCNT2',  			width: 80		   , hidden: true}
					,{ dataIndex: 'STOCK_UNIT',  		width: 80		   , align: 'center'}

					,{ dataIndex: 'ITEM_ACCOUNT', 		width: 80		   }
					,{ dataIndex: 'SUPPLY_TYPE',  		width: 100		  }
//					,{ dataIndex: 'ITEM_GUBUN',  		width: 80		  , hidden: true}

					,{ dataIndex: 'ABC_FLAG',  			width: 80		   , hidden: true}
					,{ dataIndex: 'ORDER_UNIT',  		width: 80		   , align: 'center'}
					,{ dataIndex: 'ITEM_LEVEL1',  	width: 140	, hidden: true,store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'), child:'ITEM_LEVEL2'}
					,{ dataIndex: 'ITEM_LEVEL2',  	width: 140	, hidden: true,store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'), child:'ITEM_LEVEL3'}
					,{ dataIndex: 'ITEM_LEVEL3',  	width: 140	, hidden: true,store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')}

					,{ dataIndex: 'TRNS_RATE',  		width: 80		   }
					,{ dataIndex: 'WH_CODE',  			width: 100,
						 listeners:{
							render:function(elm)	{
								var tGrid = elm.getView().ownerGrid;
								elm.editor.on('beforequery',function(queryPlan, eOpts)  {

									var grid = tGrid;
									var record = grid.uniOpt.currentRecord;

									var store = queryPlan.combo.store;
									store.clearFilter();
									store.filterBy(function(item){
										return item.get('option') == record.get('DIV_CODE');
									})
								});
								elm.editor.on('collapse',function(combo,  eOpts )   {
									var store = combo.store;
									store.clearFilter();
								});
							}
						}
					}
					,{ dataIndex: 'ORDER_PLAN',  		width: 100		  }
					,{ dataIndex: 'LOCATION',  			width: 80		   }
					,{ dataIndex: 'MATRL_PRESENT_DAY',  width: 90			, hidden: true}
					,{ dataIndex: 'LOT_YN',  			width: 100			, hidden: true, hidden: sumtypeCell	}
					,{ dataIndex: 'PHANTOM_YN',  		width: 90			, hidden: true}
					,{ dataIndex: 'PURCHASE_BASE_P',  	width: 80	  		}
					,{ dataIndex: 'ORDER_PRSN',  		width: 100		  , hidden: true}

					,{ dataIndex: 'EXCESS_RATE',  		width: 80		   , hidden: true}
					,{ dataIndex: 'EXPENSE_RATE', 		width: 80		   , hidden: true}
					,{ dataIndex: 'TEMPC_01',		   width: 80		   , hidden: true}
					,{ text: '<t:message code="system.label.base.mrpinformation" default="MRP정보"/>'
					  ,columns:[
								 { dataIndex: 'ORDER_KIND',  		width: 100   , hidden: true}
								,{ dataIndex: 'NEED_Q_PRESENT',  	width: 100   , hidden: true}
								,{ dataIndex: 'EXC_STOCK_CHECK_YN', width: 100   }
								,{ dataIndex: 'SAFE_STOCK_Q',  		width: 100   }
								,{ dataIndex: 'NEED_Q_PRESENT_Q',  	width: 100   , hidden: true}
							  ]
					 }
					,{ text: '<t:message code="system.label.base.buyinformation" default="구매정보"/>'
					  ,columns:[
								 { dataIndex: 'PURCH_LDTIME',  		width: 80	, hidden: true}
								,{ dataIndex: 'MINI_PURCH_Q',  		width: 90	, hidden: true}
								,{ dataIndex: 'MAX_PURCH_Q',  		width: 90	, hidden: true}
								,{ dataIndex: 'COMP_CODE',  		width: 80	, hidden: true}
								,{ dataIndex: 'CUSTOM_CODE',  		width: 80	, hidden: true}
								,{ dataIndex: 'CUSTOM_NAME',  		width: 130,
								  'editor': Unilite.popup('AGENT_CUST_G',{
										autoPopup : true,
										listeners : {
											'onSelected': {
												fn: function(records, type  ){
													var grdRecord = masterGrid.uniOpt.currentRecord;
													grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
													grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
												},
												scope: this
											},
											'onClear' : function(type)  {
												var grdRecord = masterGrid.uniOpt.currentRecord;
												grdRecord.set('CUSTOM_CODE','');
												grdRecord.set('CUSTOM_NAME','');
											},
											'applyextparam': function(popup){
//												popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','2']});
//												popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
											}
										}
									})
								}
							]
					}
					,{ dataIndex: 'ROP_YN',  			width: 100		   , hidden: true}
					,{ dataIndex: 'DAY_AVG_SPEND',  	width: 80	   	 , hidden: true}
					,{ dataIndex: 'ORDER_POINT',  		width: 80		 	 , hidden: true}
					,{ dataIndex: 'BASIS_P',  			width: 80			, hidden: true}
					,{ dataIndex: 'COST_YN',  			width: 80			, hidden: true}
					,{ dataIndex: 'COST_PRICE',  		width: 80			, hidden: true}
					,{ dataIndex: 'REAL_CARE_YN',  		width: 80			 , hidden: true}
					,{ dataIndex: 'REAL_CARE_PERIOD',  	width: 80			 , hidden: true}
					,{ dataIndex: 'MINI_PACK_Q',  		width: 80		 	 , hidden: true}
					,{ dataIndex: 'ITEM_ACCOUNT', 		width: 80			, hidden: true}

					,{ text: '<t:message code="system.label.base.productioninfo" default="생산정보"/>'
					  ,columns:[
				  				 { dataIndex: 'ORDER_METH',  		width: 90   }
								,{ dataIndex: 'OUT_METH',  			width: 90   }
								,{ dataIndex: 'RESULT_YN',  		width: 90   }
								,{ dataIndex: 'PRODUCT_LDTIME',  	width: 80   , hidden: true}
								,{ dataIndex: 'MAX_PRODT_Q',  		width: 90   , hidden: true}
								,{ dataIndex: 'STAN_PRODT_Q',  		width: 90   , hidden: true}
								,{ dataIndex: 'MAN_HOUR',	  		width: 90   , hidden: true}
								,{ dataIndex: 'ROUT_TYPE',  		width: 90   , hidden: true}
								,{ dataIndex: 'WORK_SHOP_CODE',  	width: 130,
									 listeners:{
										render:function(elm)	{
											var tGrid = elm.getView().ownerGrid;
											elm.editor.on('beforequery',function(queryPlan, eOpts)  {

												var grid = tGrid;
												var record = grid.uniOpt.currentRecord;

												var store = queryPlan.combo.store;
												store.clearFilter();
												store.filterBy(function(item){
													return item.get('option') == record.get('DIV_CODE');
												})
											});
											elm.editor.on('collapse',function(combo,  eOpts )   {
												var store = combo.store;
												store.clearFilter();
											});
										}
									}
								}
								,{ dataIndex: 'ITEM_TYPE',  		width: 90   , hidden: true}
					  ]
					}
					,{ text: '<t:message code="system.label.base.qualityinformation" default="품질정보"/>'
					  ,columns:[
								 { dataIndex: 'INSPEC_YN',			width: 90	}
								,{ dataIndex: 'BAD_RATE',			width: 80	, hidden: true}
								,{ dataIndex: 'INSPEC_METH_MATRL',	width: 110	, hidden: true}
								,{ dataIndex: 'INSPEC_METH_PROG',	width: 110	, hidden: true}
								,{ dataIndex: 'INSPEC_METH_PRODT',	width: 110	, hidden: true}
								//20190305 추가 (관리대상품목, 사유)
								,{ dataIndex: 'CARE_YN',			width: 80	, hidden: true}
								,{ dataIndex: 'CARE_REASON',		width: 80	, hidden: true}
							]
					}
		  ],
		   listeners: {
			  	selectionchangerecord:function(selected)	{
			  		detailForm.setActiveRecord(selected)
			  	},
			  	onGridDblClick:function(grid, record, cellIndex, colName) {
			  		if(!record.phantom) {
			  			switch(colName)	{
						case 'ITEM_CODE' :
								masterGrid.hide();
								break;
						default:
								break;
			  			}
			  		}
			  	},
			  	/*
				beforehide: function(grid, eOpts )	{
					if(directMasterStore.isDirty() )	{
						var config={
							success:function()	{
								masterGrid.hide();
							}
						};
						UniAppManager.app.confirmSaveData(config);
						return false;
					}
				},
				*/
				hide:function()	{
					detailForm.show();
				}
		  }
	});

	var detailForm = Unilite.createForm('detailForm', {
		hidden: true,
		autoScroll: true,
		masterGrid: masterGrid,
		border: false,
		padding: '0 0 0 1',
		//disabled:false,
		layout: {type: 'uniTable', columns: 3, tdAttrs: {valign:'top'}},
		xtype:'container',
		defaultType: 'container',
		items:[{
				title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
				colspan: 3,
				defaultType: 'uniTextfield',
				flex : 1,
				layout: {
					type: 'uniTable',
					tableAttrs: { style: { width: '100%' } },
					columns: 1
				},
				items :[
						 {name: 'ITEM_CODE'					,fieldLabel:'<t:message code="system.label.base.itemcode" default="품목코드"/>'	   	,readOnly: true , allowBlank:false, width:300 }
						,{name: 'ITEM_NAME'					,fieldLabel:'<t:message code="system.label.base.itemname" default="품목명"/>'		 ,readOnly: true , allowBlank:false, width:400 }
						,{name: 'ITEM_NAME1'				,fieldLabel:'<t:message code="system.label.base.itemname01" default="품명1"/>'		 	,readOnly: true, width:400 }
						,{name: 'ITEM_NAME2'				,fieldLabel:'<t:message code="system.label.base.itemname02" default="품명2"/>'		 	,readOnly: true, width:758 }
						,{name: 'SPEC'						,fieldLabel:'<t:message code="system.label.base.spec" default="규격"/>'		 	,readOnly: true, width:758}
						/*,{name: 'SFLAG'						,fieldLabel:'<t:message code="unilite.msg.sMR350" default="등록여부"/>'		 	,xtype:'uniCombobox', comboType:'AU', comboCode:'B018'}
						,{name: 'BCNT'						,fieldLabel:'<t:message code="unilite.msg.sMR391" default="BOM등록"/>'		 	,xtype:'uniCombobox', comboType:'AU', comboCode:'B018'}
						,{name: 'BCNT1'						,fieldLabel:'<t:message code="unilite.msg.sMR355" default="구매단가"/>'		 	,xtype:'uniCombobox', comboType:'AU', comboCode:'B018'}
						,{name: 'BCNT2'						,fieldLabel:'<t:message code="unilite.msg.sMR393" default="판매단가"/>'		 	,xtype:'uniCombobox', comboType:'AU', comboCode:'B018'}
						,{name: 'STOCK_UNIT'				,fieldLabel:'<t:message code="unilite.msg.sMR036" default="재고단위"/>'		 	,xtype:'uniCombobox'}
						,{name: 'STOCK_UNIT'				,fieldLabel:'<t:message code="unilite.msg.sMR036" default="재고단위"/>'		 	,xtype:'uniCombobox'}
						*/
					]
				},
				{
				layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
				defaultType: 'uniFieldset',
				masterGrid: masterGrid,
				defaults : { margin: '0 0 0 0'},
				items : [{
					title: '<t:message code="system.label.base.basicsupportinfo" default="기본조달정보"/>',
					layout: {
						type: 'uniTable',
						columns: 1
					},
					defaults:{type: 'uniTextfield', labelWidth:85},
					height:465,
					items :[
						 {name: 'ITEM_ACCOUNT'				,fieldLabel:'<t:message code="system.label.base.itemaccount" default="품목계정"/>'		 	,xtype:'uniCombobox'	, allowBlank:false , comboType:'AU', comboCode:'B020'}
						,{name: 'SUPPLY_TYPE'				,fieldLabel:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>'		 	,xtype:'uniCombobox'	, allowBlank:false , comboType:'AU', comboCode:'B014'}
						,{name: 'ORDER_UNIT'				,fieldLabel:'<t:message code="system.label.base.purchaseunit" default="구매단위"/>'		 	,xtype:'uniCombobox'	, allowBlank:false , comboType:'AU', fieldStyle: 'text-align: center;', comboCode:'B013', displayField: 'value'}
						,{name: 'TRNS_RATE'					, fieldLabel: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>' 	 	   ,xtype:'uniNumberfield'	,decimalPrecision:4, format:'0,000.0000'}
						,{name: 'WH_CODE'					,fieldLabel:'<t:message code="system.label.base.mainwarehouse" default="주창고"/>'		 	,xtype:'uniCombobox'	, allowBlank:false , comboType:'OU',
							   listeners : {
											beforequery:function( queryPlan, eOpts )   {
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
						 }
//						,{name: 'ITEM_GUBUN'				,fieldLabel:'저장구분'  															,xtype:'uniCombobox'	, comboType:'AU', comboCode:'B202'}
						,{name: 'LOCATION'					,fieldLabel:'Location'}
						,{name: 'ORDER_PLAN'				,fieldLabel:'<t:message code="system.label.base.popolicy" default="발주방침"/>'		 	,xtype:'uniCombobox'	, allowBlank:false , allowBlank:false , comboType:'AU', comboCode:'B061'}
						,{name: 'MATRL_PRESENT_DAY'   		,fieldLabel:'<t:message code="system.label.base.materialfixedperiod" default="자재올림기간"/>'	 	,xtype:'uniNumberfield'}
						,{name: 'PURCHASE_BASE_P'			,fieldLabel:'<t:message code="system.label.base.purchaseprice" default="구매단가"/>'		 	,xtype:'uniNumberfield'}
						,{name: 'ORDER_PRSN'				,fieldLabel:'<t:message code="system.label.base.purchasecharge" default="구매담당"/>'		,xtype:'uniCombobox', comboType:'AU', comboCode:'M201'}
						,{name: 'ABC_FLAG'					,fieldLabel:'<t:message code="system.label.base.abcclassification" default="ABC구분"/>'		 	,xtype:'uniCombobox', comboType:'AU', comboCode:'B037'}
						,{name: 'EXCESS_RATE'				,fieldLabel:'<t:message code="system.label.base.overreceiptrate" default="과입고허용율"/>'	 	,xtype:'uniNumberfield'	, decimalPrecision:2}
						,{name: 'EXPENSE_RATE'				,fieldLabel:'<t:message code="system.label.base.importexpenserate" default="수입부대비용율"/>'	   ,xtype:'uniNumberfield' ,  decimalPrecision:2}
						,
						Unilite.popup('AGENT_CUST_SINGLE',{
							fieldLabel: '<t:message code="system.label.base.maincustomcode" default="주거래처코드"/>',
							textFieldName:'CUSTOM_CODE',
							DBtextFieldName: 'CUSTOM_CODE',
							readOnly: false,
							autoPopup: true,
							holdable: 'hold',
							listeners: {
								applyextparam: function(popup){
									popup.setExtParam({'SINGLE_CODE': true});
								},
								onSelected: {
									fn: function(records, type) {
										 detailForm.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
									 },
								scope: this
								},
								onClear: function(type)	{		////onClear가 먹지 않음
									detailForm.setValue('CUSTOM_NAME', '');
								}
							}
						}),
						Unilite.popup('AGENT_CUST_SINGLE',{
							fieldLabel: '<t:message code="system.label.base.maincustom" default="주거래처"/>',
							textFieldName:'CUSTOM_NAME',
							DBtextFieldName: 'CUSTOM_NAME',
							readOnly: false,
							autoPopup: true,
							holdable: 'hold',
							listeners: {
								applyextparam: function(popup){
									popup.setExtParam({'SINGLE_CODE': false});
								},
								onSelected: {
									fn: function(records, type) {
										 detailForm.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
									},
								scope: this
								},
								onClear: function(type)	{		////onClear가 먹지 않음
									detailForm.setValue('CUSTOM_CODE', '');
								}
							}
						})
						,{name: 'TEMPC_01'				  ,fieldLabel:'<t:message code="system.label.base.salesdeptdivision" default="매출부서구분"/>',xtype:'uniCombobox', comboType:'AU', comboCode:'WB19', value : '1'}
					]
			}
									,{  title: '<t:message code="system.label.base.inventorytraninfor" default="재고(수불)정보"/>'
										, layout: {
													type: 'uniTable',
													columns: 1
												},
												height:140
										, defaults : { type:'uniTextfield'}

										,items :[	 {name: 'BASIS_P'					,fieldLabel:'<t:message code="system.label.base.inventoryprice" default="재고단가"/>'		 	,xtype:'uniNumberfield'}
													,{name: 'REAL_CARE_YN'				,fieldLabel:'<t:message code="system.label.base.stockcountingitem" default="실사대상"/>'		 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false}
													,{name: 'REAL_CARE_PERIOD'			,fieldLabel:'<t:message code="system.label.base.stockcountingcycel" default="실사주기"/>'		 	,xtype:'uniNumberfield'		,suffixTpl:'&nbsp;개월'}
													,{name: 'MINI_PACK_Q'				,fieldLabel:'<t:message code="system.label.base.minimumpackagingqty" default="최소포장량"/>'	 	,xtype:'uniNumberfield'}
												]
						}/*,{  title: ''
							, layout: {
										type: 'uniTable',
										columns: 1
									},
									height:78
							,defaults:{type: 'uniTextfield', labelWidth:85,  margin: '0 0 0 0'}
							,items :[	 {name: 'LOT_YN'					,fieldLabel:'<t:message code="system.label.base.lotmanageyn" default="LOT관리여부"/>'	 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false }
										,{name: 'PHANTOM_YN'				,fieldLabel:'<t:message code="system.label.base.phantomyn" default="팬텀여부"/>'	 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false }
									]
						}*/
								]
					},
					{
						layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
						defaultType: 'uniFieldset',
						masterGrid: masterGrid,
						defaults:{  margin: '0 0 0 0'},
						items : [
							{  title: '<t:message code="system.label.base.qualityinformation" default="품질정보"/>'
							, layout: {
										type: 'uniTable',
										columns: 1
									},
									height: 205
							,defaults:{type: 'uniTextfield', labelWidth:85,  margin: '0 0 0 0'}
							,items :[
								{name: 'INSPEC_YN'					,fieldLabel:'<t:message code="system.label.base.qualityyn" default="품질대상여부"/>'	 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false}
								,{name: 'BAD_RATE'					,fieldLabel:'<t:message code="system.label.base.defectrate" default="불량율"/>'		 		,xtype:'uniNumberfield',  decimalPrecision:2}
								,{name: 'INSPEC_METH_MATRL'   		,fieldLabel:'<t:message code="system.label.base.importinspectionmethod" default="수입검사방법"/>'	 	,xtype:'uniCombobox', comboType:'AU', comboCode:'Q005'}
								,{name: 'INSPEC_METH_PROG'			,fieldLabel:'<t:message code="system.label.base.routinginspemethod" default="공정검사방법"/>'	 	,xtype:'uniCombobox', comboType:'AU', comboCode:'Q006'}
								,{name: 'INSPEC_METH_PRODT'   		,fieldLabel:'<t:message code="system.label.base.shipmentinspectionmethod" default="출하검사방법"/>'	 	,xtype:'uniCombobox', comboType:'AU', comboCode:'Q007'
							},{	//20190305 추가
								fieldLabel	: '<t:message code="system.label.base.manageditems" default="관리대상품목"/>',
								xtype		: 'radiogroup',
								items		: [{
									boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>',
									name		: 'CARE_YN',
									inputValue	: 'N',
									width		: 70,
									checked		: true
								},{
									boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
									name		: 'CARE_YN',
									inputValue	: 'Y',
									width		: 70
								}]
							},{
								fieldLabel	: '<t:message code="system.label.base.reason" default="사유"/>',
								name		: 'CARE_REASON',
								xtype		: 'uniTextfield'
							}]
						},
									{  title: '<t:message code="system.label.base.mrpinformation" default="MRP정보"/>'
										, layout: {
													type: 'uniTable',
													columns: 1
												}
										,defaults:{type: 'uniTextfield', labelWidth:85}
										,height:275
										,items :[	 {name: 'ORDER_KIND'				,fieldLabel:'<t:message code="system.label.base.ordercreationyn" default="오더생성여부"/>'	 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false}
													,{name: 'NEED_Q_PRESENT'			,fieldLabel:'<t:message code="system.label.base.reqround" default="소요량올림"/>'   	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false}
													,{name: 'EXC_STOCK_CHECK_YN'  		,fieldLabel:'<t:message code="system.label.base.availableinventorycheck" default="가용재고체크"/>'	 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false}
													,{name: 'SAFE_STOCK_Q'				,fieldLabel:'<t:message code="system.label.base.safetystockqty" default="안전재고량"/>'	   	,xtype:'uniNumberfield'}
													,{name: 'MINI_PURCH_Q'				,fieldLabel:'<t:message code="system.label.base.minumunorderqty" default="최소발주량"/>'	   	,xtype:'uniNumberfield'}
													,{name: 'MAX_PURCH_Q'				,fieldLabel:'<t:message code="system.label.base.maximumorderqty" default="최대발주량"/>'	   	,xtype:'uniNumberfield'}
													,{name: 'NEED_Q_PRESENT_Q'			,fieldLabel:'<t:message code="system.label.base.reqroundcount" default="소요량올림수"/>'	 	,xtype:'uniNumberfield'}
													,{name: 'PURCH_LDTIME'				,fieldLabel:'<t:message code="system.label.base.polt" default="발주 L/T"/>'		 	,xtype:'uniNumberfield'}
													,{name: 'DIST_LDTIME'				,fieldLabel:'<t:message code="system.label.base.reorderlt" default="재발주 L/T"/>'		 	,xtype:'uniNumberfield'}
												 ]
									}
									,{  title: '<t:message code="system.label.base.ropinformation" default="ROP정보"/>'
										, layout: {
													type: 'uniTable',
													columns: 1
												}
												,height:112
										,defaults:{ type:'uniTextfield', labelWidth:85}
										,items :[	 {name: 'ROP_YN'					,fieldLabel:'<t:message code="system.label.base.ropyn" default="ROP대상여부"/>'	  	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false}
													,{name: 'DAY_AVG_SPEND'				,fieldLabel:'<t:message code="system.label.base.averageqty" default="일일평균소비량"/>'   		,xtype:'uniNumberfield'	}
													,{name: 'ORDER_POINT'				,fieldLabel:'<t:message code="system.label.base.fixedorderqty" default="고정발주량"/>'	   	,xtype:'uniNumberfield'	}

												 ]
									}/*
									,{  title: '<t:message code="system.label.base.inventorytraninfor" default="재고(수불)정보"/>'
										, layout: {
													type: 'uniTable',
													columns: 1
												},
												height:142
										, defaults : { type:'uniTextfield'}

										,items :[	 {name: 'BASIS_P'					,fieldLabel:'<t:message code="system.label.base.inventoryprice" default="재고단가"/>'		 	,xtype:'uniNumberfield'}
													,{name: 'REAL_CARE_YN'				,fieldLabel:'<t:message code="system.label.base.stockcountingitem" default="실사대상"/>'		 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false}
													,{name: 'REAL_CARE_PERIOD'			,fieldLabel:'<t:message code="system.label.base.stockcountingcycel" default="실사주기"/>'		 	,xtype:'uniNumberfield'		,suffixTpl:'&nbsp;개월'}
													,{name: 'MINI_PACK_Q'				,fieldLabel:'<t:message code="system.label.base.minimumpackagingqty" default="최소포장량"/>'	 	,xtype:'uniNumberfield'}
												]
						}*/]
					},
					{
						layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
						defaults:{margin: '0 0 0 0'},
						masterGrid: masterGrid,
						defaultType: 'uniFieldset',
						items : [
						{  title: '<t:message code="system.label.base.productioninfo" default="생산정보"/>'
							, layout: {
										type: 'uniTable',
										columns: 1
									}
						,height:305
							 ,defaults:{type: 'uniTextfield', labelWidth:85,  margin: '0 0 0 0'}
							,items :[	 {name: 'ORDER_METH'				,fieldLabel:'<t:message code="system.label.base.productionmethod" default="생산방식"/>'		 	,xtype:'uniCombobox', comboType:'AU', comboCode:'P006'}
										,{name: 'OUT_METH'					,fieldLabel:'<t:message code="system.label.base.issuemethod" default="출고방법"/>'		 	,xtype:'uniCombobox', comboType:'AU', comboCode:'B039'}
										,{name: 'RESULT_YN'					,fieldLabel:'<t:message code="system.label.base.resultsreceiptmethod" default="실적입고방법"/>'	 	,xtype:'uniCombobox', comboType:'AU', comboCode:'B023'}
										,{name: 'PRODUCT_LDTIME'			,fieldLabel:'<t:message code="system.label.base.mfglt" default="제조 L/T"/>'		 	,xtype:'uniNumberfield'}
										,{name: 'ATP_LDTIME'				,fieldLabel:'<t:message code="system.label.base.atplt" default="ATP L/T"/>'		 		,xtype:'uniNumberfield'}
										,{name: 'ROUT_TYPE'					,fieldLabel:'<t:message code="system.label.base.routingtype" default="공정구분"/>'		,xtype:'uniCombobox' , store: Ext.data.StoreManager.lookup('BPR250ukrvDIV_PRSNStore')}
										,{name: 'WORK_SHOP_CODE'			,fieldLabel:'<t:message code="system.label.base.mainworkcenter" default="주작업장"/>'		 	,xtype:'uniCombobox', comboType:'WU',
												   listeners : {
																beforequery:function( queryPlan, eOpts )   {
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
										 }
										,{name: 'MAX_PRODT_Q'				,fieldLabel:'<t:message code="system.label.base.maximumproductqty" default="최대생산량"/>'	   	,xtype:'uniNumberfield'}
										,{name: 'STAN_PRODT_Q'				,fieldLabel:'<t:message code="system.label.base.standardproductionqty" default="표준생산량"/>'	   	,xtype:'uniNumberfield'}
										,{name: 'MAN_HOUR'					,fieldLabel:'<t:message code="system.label.base.standardtacttime" default="표준공수"/>'				,xtype:'uniNumberfield',  decimalPrecision:2}
										,{name: 'ITEM_TYPE'					,fieldLabel:'<t:message code="system.label.base.productiontype" default="양산구분"/>'		 	,xtype:'uniCombobox', comboType:'AU', comboCode:'B074'}
									]
						}
						/*,{  title: '<t:message code="system.label.base.qualityinformation" default="품질정보"/>'
							, layout: {
										type: 'uniTable',
										columns: 1
									},
									height: 205
							,defaults:{type: 'uniTextfield', labelWidth:85,  margin: '0 0 0 0'}
							,items :[
								{name: 'INSPEC_YN'					,fieldLabel:'<t:message code="system.label.base.qualityyn" default="품질대상여부"/>'	 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false}
								,{name: 'BAD_RATE'					,fieldLabel:'<t:message code="system.label.base.defectrate" default="불량율"/>'		 		,xtype:'uniNumberfield',  decimalPrecision:2}
								,{name: 'INSPEC_METH_MATRL'   		,fieldLabel:'<t:message code="system.label.base.importinspectionmethod" default="수입검사방법"/>'	 	,xtype:'uniCombobox', comboType:'AU', comboCode:'Q005'}
								,{name: 'INSPEC_METH_PROG'			,fieldLabel:'<t:message code="system.label.base.routinginspemethod" default="공정검사방법"/>'	 	,xtype:'uniCombobox', comboType:'AU', comboCode:'Q006'}
								,{name: 'INSPEC_METH_PRODT'   		,fieldLabel:'<t:message code="system.label.base.shipmentinspectionmethod" default="출하검사방법"/>'	 	,xtype:'uniCombobox', comboType:'AU', comboCode:'Q007'
							},{	//20190305 추가
								fieldLabel	: '<t:message code="system.label.base.manageditems" default="관리대상품목"/>',
								xtype		: 'radiogroup',
								items		: [{
									boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
									name		: 'CARE_YN',
									inputValue	: 'Y',
									width		: 70
								},{
									boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>',
									name		: 'CARE_YN',
									inputValue	: 'N',
									width		: 70,
									checked		: true
								}]
							},{
								fieldLabel	: '<t:message code="system.label.base.reason" default="사유"/>',
								name		: 'CARE_REASON',
								xtype		: 'uniTextfield'
							}]
						}*/
						,{  title: '<t:message code="system.label.base.costinfo" default="원가정보"/>'
							, layout: {
										type: 'uniTable',
										columns: 1
									},
									height: 82
							,defaults:{type: 'uniTextfield', labelWidth:85,  margin: '0 0 0 0'}
							,items :[	 {name: 'COST_YN'					,fieldLabel:'<t:message code="system.label.base.costcalculationobject" default="원가계산대상"/>'	 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false }
										,{name: 'COST_PRICE'				,fieldLabel:'<t:message code="system.label.base.cost" default="원가"/>'		 		,xtype:'uniNumberfield'}
									]
						},{  title: ''
							, layout: {
										type: 'uniTable',
										columns: 1
									},
									height:75
							,defaults:{type: 'uniTextfield', labelWidth:85,  margin: '0 0 0 0'}
							,items :[	 {name: 'LOT_YN'					,fieldLabel:'<t:message code="system.label.base.lotmanageyn" default="LOT관리여부"/>'	 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false }
										,{name: 'PHANTOM_YN'				,fieldLabel:'<t:message code="system.label.base.phantomyn" default="팬텀여부"/>'	 	,xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false }
									]
						}
					]
		}]
			/*
   			,dockedItems: [{
									xtype: 'toolbar',
									dock: 'bottom',
									ui: 'footer',
									items: [
											{	id : 'saveBtn',
												itemId : 'saveBtn',
												text: '저장',
												handler: function() {
													UniAppManager.app.onSaveDataButtonDown();
												},
												disabled: true
											}, '-',{
												id : 'saveCloseBtn',
												itemId : 'saveCloseBtn',
												text: '저장 후 닫기',
												handler: function() {
													if(!detailForm.isDirty() )	{
														detailWin.hide();
													}else {
														var config = {success :
																	function()	{
																		detailWin.hide();
																	}
															}
														UniAppManager.app.onSaveDataButtonDown(config);
													}
												},
												disabled: true
											}, '-',{
												id : 'deleteCloseBtn',
												itemId : 'deleteCloseBtn',
												text: '삭제',
												handler: function() {
														var record = masterGrid.getSelectedRecord();
														var phantom = record.phantom;
														UniAppManager.app.onDeleteDataButtonDown();
														var config = {success :
																	function()	{

																		detailWin.hide();
																	}
															}
														if(!phantom)	{
															UniAppManager.app.onSaveDataButtonDown(config);
														} else {
															detailWin.hide();
														}

												},
												disabled: false
											}, '->',{
												itemId : 'closeBtn',
												text: '닫기',
												handler: function() {
													detailWin.hide();
												},
												disabled: false
											}
									]
								}]
					*/
				,loadForm: function(record)	{
	   				// window 오픈시 form에 Data load
					this.reset();
					this.setActiveRecord(record || null);
					this.resetDirtyStatus();
				},
	   			listeners:{
	   				/*
					beforehide: function(grid, eOpts )	{
						if(directMasterStore.isDirty() )	{
							var config={
								success:function()	{
									detailForm.hide();
								}
							};
							UniAppManager.app.confirmSaveData(config);
							return false;
						}
					},
					*/
					hide:function()	{
						masterGrid.show();
						if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
							panelResult.show();
						}
					}

	   			}

	});
	/*
	function openDetailWindow(selRecord, isNew) {
			// 그리드 저장 여부 확인
			var edit = masterGrid.findPlugin('cellediting');
			if(edit && edit.editing)	{
				setTimeout("edit.completeEdit()", 1000);
			}
			UniAppManager.app.confirmSaveData();

			// 추가 Record 인지 확인
			if(isNew)	{
				var r = masterGrid.createRow();
				selRecord = r[0];
			}
			// form에 data load
			detailForm.loadForm(selRecord);

			if(!detailWin) {
				detailWin = Ext.create('widget.uniDetailFormWindow', {
					title: '상세정보',
					width: 860,
					height: 500,
					isNew: false,
					x:0,
					y:0,
					items: [detailForm],
					listeners : {
								 show:function( window, eOpts)	{
								 	detailForm.body.el.scrollTo('top',0);
								 }
					},
					 onCloseButtonDown: function() {
						this.hide();
					},
					onDeleteDataButtonDown: function() {
						var record = masterGrid.getSelectedRecord();
						var phantom = record.phantom;
						UniAppManager.app.onDeleteDataButtonDown();
						var config = {success :
									function()  {
										detailWin.hide();
									}
							}
						if(!phantom)	{

								UniAppManager.app.onSaveDataButtonDown(config);

						} else {
							detailWin.hide();
						}
					},
					onSaveDataButtonDown: function() {
						var config = {success : function()	{
											 	detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
											 	detailWin.setToolbarButtons(['prev','next'],true);
										}
						}
						UniAppManager.app.onSaveDataButtonDown(config);
					},
					onSaveAndCloseButtonDown: function() {
						if(!detailForm.isDirty())   {
							detailWin.hide();
						}else {
							var config = {success :
										function()  {
											detailWin.hide();
										}
								}
							UniAppManager.app.onSaveDataButtonDown(config);
						}
					},
					onPrevDataButtonDown:  function()   {
						if(masterGrid.selectPriorRow()) {
							var record = masterGrid.getSelectedRecord();
							if(record) {
								detailForm.loadForm(record);
							}
						}
					},
					onNextDataButtonDown:  function()   {
						if(masterGrid.selectNextRow()) {
							var record = masterGrid.getSelectedRecord();
							if(record) {
								detailForm.loadForm(record);
							}
						}
					}
				})
			}
			detailWin.show();
	}
	*/

	 Unilite.Main({
	  	id  : 'bpr250ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'<t:message code="system.label.base.divisioniteminfo" default="사업장별 품목정보"/>',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [
					{
						type: 'hum-grid',
						handler: function () {
							detailForm.hide();
							//masterGrid.show();
							//panelResult.show();
						}
					},{

						type: 'hum-photo',
						handler: function () {
							masterGrid.hide();
							panelResult.hide();
							//detailForm.show();
						}
					},{
						xtype: 'button',
						itemId:'procTool',
						margin:'0 0 0 10',
						text: '<t:message code="system.label.base.referprogram" default="관련화면"/>',
						width: 70,
						menu: Ext.create('Ext.menu.Menu', {
							items: [
							{
								itemId: 'issueLinkBtn',
								text: '<t:message code="system.label.base.manufacturebomentry" default="제조BOM등록"/>',
								handler: function() {
									var record = masterGrid.getSelectedRecord();

									if(!Ext.isEmpty(record)){
										var params = {
											'PGM_ID' : 'bpr250ukrv',
											'DIV_CODE' : record.get('DIV_CODE'),
											'ITEM_CODE' : record.get('ITEM_CODE'),
											'ITEM_NAME' : record.get('ITEM_NAME')
										}
										var rec = {data : {prgID : 'bpr560ukrv', 'text':''}};
										parent.openTab(rec, '/base/bpr560ukrv.do', params);
									}
								}
							}, {
								itemId: 'itemLinkBtn',
								text: '<t:message code="system.label.base.iteminfoentry" default="품목정보등록"/>',
								handler: function() {
									var record = masterGrid.getSelectedRecord();

									if(!Ext.isEmpty(record)){
										var params = {
											'PGM_ID' : 'bpr250ukrv',
											'ITEM_CODE' : record.get('ITEM_CODE')
										}
										var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};
										parent.openTab(rec, '/base/bpr100ukrv.do', params);
									}
								}
							}]
						})
					}
				],
				items:[
					masterGrid,
					detailForm
				]
			}
		],
		/**
		* 기본값 셋업
		*/
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['reset','detail'],true);
			UniAppManager.setToolbarButtons('save',false);


			if(!Ext.isEmpty(params.ITEM_CODE)){
				this.processParams(params);
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;

			if(params.PGM_ID == 'bpr100ukrv') {
				panelSearch.setValue('DIV_CODE',UserInfo.divCode);
				panelResult.setValue('DIV_CODE',UserInfo.divCode);
				panelSearch.setValue('ITEM_CODE',params.ITEM_CODE);
				panelResult.setValue('ITEM_CODE',params.ITEM_CODE);
				this.onQueryButtonDown();
			}
		},
		/**
		 *  조회
		 */
		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()){
				return false;
			}
			detailForm.clearForm();
			detailForm.resetDirtyStatus();
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			masterGrid.createRow();
			/*panelSearch.getField('DIV_CODE').setReadOnly( true );
			openDetailWindow(null, true);*/
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},
		/**
		 *  삭제
		 */
		 onDeleteDataButtonDown: function() {
			if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
//				masterGrid.deleteSelectedRow();
//				detailForm.clearForm();
				masterGrid.deleteSelectedRow();
//				masterGrid.getStore().onStoreActionEnable();
			}
		},

		checkMandatoryVal:function() {
			//var toCreate = this.getNewRecords();
			var updateReco = directMasterStore.getUpdatedRecords();
			var bValueChk = true;
			bValueChk = Ext.each(updateReco, function(record,i){
				if (record.get('ROP_YN') == 'Y'){
						if (Ext.isEmpty(record.get('DAY_AVG_SPEND')) || record.get('DAY_AVG_SPEND')==0){
							Unilite.messageBox('<t:message code="system.message.base.message028" default="ROP대상일경우에 일일평균소비량: 필수입력값입니다."/>');
							return false;
						}
						if (Ext.isEmpty(record.get('ORDER_POINT')) || record.get('ORDER_POINT')==0){
							Unilite.messageBox('<t:message code="system.message.base.message029" default="ROP대상일경우에 고정발주량: 필수입력값입니다."/>');
							return false;
						}
					}

				});
			return bValueChk;
		},


		/**
		 *  저장
		 */
		onSaveDataButtonDown: function (config) {
			if(!UniAppManager.app.checkMandatoryVal()){
				return;
			}else{
				directMasterStore.saveStore(config);
			}
		}
		,onResetButtonDown:function() {
			panelSearch.getForm().reset();
			detailForm.clearForm();
			panelResult.getForm().reset();
			masterGrid.reset();
			directMasterStore.clearData();
			panelSearch.getField('DIV_CODE').setReadOnly( false );

			detailForm.setValue('ORDER_KIND'		, 'Y');
			detailForm.setValue('NEED_Q_PRESENT'	, 'Y');
			detailForm.setValue('EXC_STOCK_CHECK_YN', 'Y');
			detailForm.setValue('ROP_YN'			, 'Y');
			detailForm.setValue('REAL_CARE_YN'		, 'Y');
			detailForm.setValue('INSPEC_YN'			, 'Y');
			detailForm.setValue('COST_YN'			, 'Y');
			detailForm.setValue('ORDER_METH'			, '3');
			//20190305 추가
			detailForm.setValue('CARE_YN'			, 'N');
			UniAppManager.setToolbarButtons('save',false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}/* ,
		 rejectSave: function()	{
			directMasterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
			console.log("directMasterStore.count()" , directMasterStore.count());
			if (directMasterStore.count() == 0) {
				panelSearch.getField('DIV_CODE').setReadOnly( false );
			}
		},
		confirmSaveData: function()	{
				if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
			}  */
	});
};

</script>