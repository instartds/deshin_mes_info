<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str300skrv" >	
	<t:ExtComboStore comboType="BOR120" pgmId="str300skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU"  comboCode="B001"/>
	<t:ExtComboStore comboType="AU"  comboCode="B024"/>	
	<t:ExtComboStore comboType="AU"  comboCode="A"	/>
	<t:ExtComboStore comboType="AU"  comboCode="S006"/>	
	<t:ExtComboStore comboType="AU"  comboCode="S007"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B020"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B021"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B036"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B001"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B116"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B013"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B010"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B039"/>	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore comboType="O" />		<!--창고-->
</t:appConfig>
<script type="text/javascript" >
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
function appMain() {
	/**
	 * Model 정의
	 * 
	 * @type
	 */

	Unilite.defineModel('str300skrvModel', {
		fields:  [   
					 {name:  'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},
					 {name:  'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
					 {name:  'ITEM_NAME1'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'		,type: 'string'},
					 {name:  'SPEC'						,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},	 
					 {name:  'ORDER_UNIT'				,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		,type: 'string'},		
					 {name:  'INOUT_Q'					,text: '<t:message code="system.label.sales.receiptqty" default="입고량"/>'		,type: 'uniQty'},  
					 {name:  'TRNS_RATE'				,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'uniQty'},
					 {name:  'STOCK_UNIT'				,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'		,type: 'string'},		
					 {name:  'ORDER_UNIT_Q'				,text: '<t:message code="system.label.sales.receiptqty" default="입고량"/>'		,type: 'uniQty'},	  
					 {name:  'WGT_UNIT'					,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'		,type: 'string'}, 
					 {name:  'UNIT_WGT'					,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'		,type: 'uniQty'}, 
					 {name:  'INOUT_WGT_Q'				,text: '<t:message code="system.label.sales.receiptqtywgt" default="입고량(중량)"/>'	,type: 'uniQty'},	   
					 {name:  'INOUT_TYPE_DETAIL'		,text: '<t:message code="system.label.sales.receiptplannedqty" default="입고유형"/>'		,type: 'string' ,comboType: "AU", comboCode: "S006"}, 
					 {name:  'INOUT_CODE_TYPE'			,text: '<t:message code="system.label.sales.tranplacedivision" default="수불처구분"/>'	,type: 'string' },   
					 {name:  'INOUT_CODE'				,text: '<t:message code="system.label.sales.receiptplace" default="입고처"/>CD'		,type: 'string' },		
					 {name:  'INOUT_NAME'				,text: '<t:message code="system.label.sales.receiptplaceworkcenter" default="입고처/작업장"/>'	,type: 'string'},		
					 {name:  'INOUT_DATE'				,text: '<t:message code="system.label.sales.receiptdate" default="입고일"/>'		,type: 'uniDate'},		
					 {name:  'ITEM_STATUS'  			,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'		,type: 'string' ,comboType: "AU", comboCode: "B021"},	   
					 {name:  'WH_CODE'					,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'			,type: 'string', store:  Ext.data.StoreManager.lookup('whList')},  
					 {name:  'WH_NAME'					,text: '창고명'		,type: 'string'},
					 {name:  'DIV_CODE'					,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string', comboType:'BOR120', defaultValue:UserInfo.divCode},
					 {name:  'INOUT_NUM'				,text: '<t:message code="system.label.sales.receiptno" default="입고번호"/>'		,type: 'string'},
					 {name:  'INOUT_SEQ'				,text: '<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'string'},
					 {name:  'LOT_NO'					,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		,type: 'string'},
					 {name:  'PROJECT_NO'				,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'   ,type: 'string'},
					 {name:  'REMARK'					,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'},  
					 {name:  'INOUT_PRSN'				,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'		,type: 'string',comboType: "AU", comboCode: "B024"},		
					 {name:  'BASIS_NUM'				,text: '<t:message code="system.label.sales.productionresultno" default="생산실적번호"/>'   ,type: 'string'},
					 {name:  'INOUT_METH'				,text: '<t:message code="system.label.sales.receiptmethod" default="입고방법"/>'		,type: 'string' ,comboType: "AU", comboCode: "B036"},		
					 {name:  'EVAL_INOUT_P'				,text: '<t:message code="system.label.sales.averageprice" default="평균단가"/>'		,type: 'uniUnitPrice'},	  
					 {name:  'SORT_KEY'					,text: 'SORTKEY'	,type: 'string' },
					 {name:  'UPDATE_DB_TIME'			,text: '<t:message code="system.label.sales.entrydate" default="등록일"/>'		,type: 'string'}  
			]
	});	
	
	Unilite.defineModel('str300skrvModel2', {
		fields:  [  
					 {name: 'ITEM_CODE1'		,text: '<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},
					 {name: 'ITEM_NAME1'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'   	,type: 'string'},
					 {name: 'ITEM_CODE2'		,text: '<t:message code="system.label.sales.item" default="품목"/>' 		,type: 'string'},
					 {name: 'ITEM_NAME2'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
					 {name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},
					 {name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
					 {name: 'ITEM_NAME_R1'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'		,type: 'string'},
					 {name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},	 
					 {name: 'ORDER_UNIT'		,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		,type: 'string'},		
					 {name: 'INOUT_Q'			,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'		,type: 'uniQty'},	
					 
					 {name: 'WGT_UNIT'			,text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>'  		,type: 'string' },  
					 {name: 'UNIT_WGT'			,text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>'  		,type: 'uniQty' },  
					 {name: 'INOUT_WGT_Q'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'	,type: 'uniQty' }, 
					 {name: 'INOUT_FOR_WGT_P'	,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'  	,type: 'uniUnitPrice'},  
					 {name: 'VOL_UNIT'			,text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>'  		,type: 'uniQty' },  
					 {name: 'UNIT_VOL'			,text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'  		,type: 'uniQty' },  
					 {name: 'INOUT_VOL_Q'		,text: '<t:message code="system.label.sales.tranqtyvol" default="수불량(부피)"/>'	,type: 'uniQty' },   
					 {name: 'INOUT_FOR_VOL_P'	,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'	,type: 'uniUnitPrice' },  
					 
					 {name: 'TRNS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'uniQty'},
					 {name: 'STOCK_UNIT'		,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'		,type: 'string'}, 
					 {name: 'MONEY_UNIT'		,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'   	,type: 'string'},   
					 {name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.sales.inventoryunitissueqty" default="재고단위출고량"/>'	,type: 'uniQty'},
					 {name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.sales.orderunitprice" default="구매단가"/>'		,type: 'uniUnitPrice' },  
					 {name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'			,type: 'uniER' }, 
					
					 {name: 'INOUT_P'  			,text: '<t:message code="system.label.sales.price" default="단가"/>'			,type: 'uniUnitPrice'},  
					 {name: 'INOUT_FOR_O'		,text: '<t:message code="system.label.sales.foreigncurrencyamount" default="외화금액"/>'		,type: 'uniFC'},	
					 {name: 'INOUT_I'			,text: '<t:message code="system.label.sales.localamount" default="원화금액"/>'		,type: 'uniPrice'},   
					 {name: 'TRANS_COST'		,text: '<t:message code="system.label.sales.shippingcharge" default="운반비"/>'		,type: 'uniPrice' },  
					 {name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'  	,type: 'string' ,comboType:"AU", comboCode:"S007"}, 
					 {name: 'INOUT_CODE_TYPE'	,text: '<t:message code="system.label.sales.receiptplacetype" default="입고처구분"/>'  	,type: 'string' },  
					 {name: 'INOUT_CODE'   		,text: '<t:message code="system.label.sales.tranplacecode" default="수불처코드"/>'  	,type: 'string' },  
					 {name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'		,type: 'string'},
					 {name: 'INOUT_NAME'		,text: '<t:message code="system.label.sales.issueplace" default="출고처"/>'		,type: 'string'},
					 {name: 'INOUT_DATE'		,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'  		,type: 'uniDate'},	
					 {name: 'DVRY_CUST_NAME'	,text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'		,type: 'string'},  
					 {name: 'DOM_FORIGN'		,text:'<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>' 	,type: 'string'},   
					 {name:  'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'			,type: 'string' ,store:  Ext.data.StoreManager.lookup('whList')},
					 {name:  'WH_NAME'			,text: '창고명'		,type: 'string'},
					 {name: 'INOUT_PRSN'   		,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>' 		,type: 'string' ,comboType:'AU', comboCode:'B024' },  
					 {name: 'ISSUE_DATE'		,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'   	,type: 'uniDate'},  
					 {name: 'ISSUE_REQ_NUM'		,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'	,type: 'string'},
					 {name: 'LOT_NO'			,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'		,type: 'string'},
					 {name: 'PROJECT_NO'		,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'  	,type: 'string'},
					 {name: 'REMARK'			,text:'<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'},   
					 {name: 'ACCOUNT_YNC'		,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'  	,type: 'string' ,comboType:'AU', comboCode:'S014' },  
					 {name: 'ORDER_NUM'			,text:'<t:message code="system.label.sales.sono" default="수주번호"/>'  		,type: 'string'},  
					 {name: 'DVRY_DATE'			,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'		,type: 'uniDate'},  
					 {name: 'DELIVERY_DATE'		,text:'<t:message code="system.label.sales.deliverydate2" default="납품일"/>'		,type: 'uniDate'},  
					 {name: 'ACCOUNT_Q'			,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'  		,type: 'uniQty'},  
					 {name: 'LC_NUM'			,text: '<t:message code="system.label.sales.lcno" default="L/C번호"/>'   	,type: 'string'},  
					 {name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'		,type: 'string'},  
					 {name: 'PO_NUM'			,text:'PO_NUM'   	,type: 'string' },  
					 {name: 'PO_SEQ'			,text:'PO_SEQ'   	,type: 'string' }, 
					 {name: 'INOUT_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'		,type: 'string'},  
					 {name: 'INOUT_METH'		,text: '<t:message code="system.label.sales.issuemethod" default="출고방법"/>'   	,type: 'string' ,comboType: "AU", comboCode: "B036"},  
					 {name: 'EVAL_INOUT_P'   	,text: '<t:message code="system.label.sales.averageprice" default="평균단가"/>'  	,type: 'uniUnitPrice'},  
					 {name:  'SORT_KEY'			,text: 'SORTKEY'	,type: 'string' },
					 {name: 'PRICE_TYPE'		,text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'  		,type: 'string' ,hidden:true},  
					 {name: 'UPDATE_DB_TIME' 	,text: '<t:message code="system.label.sales.entrydate" default="등록일"/>'		,type: 'uniDate'}
		]
	});

	var directMasterStore1 = Unilite.createStore('str300skrvMasterStore',{
			model:  'str300skrvModel',
			uniOpt:  {
				isMaster:  true,			// 상위 버튼 연결
				editable:  false,			// 수정 모드 사용
				deletable: false,			// 삭제 가능 여부
				useNavi:  false			// prev | next 버튼 사용
			},
			autoLoad:  false,
			proxy:  {
				type:  'direct',
				api:  {
					read:  'str300skrvService.selectList1'
				}
			}
			,loadStoreRecords:  function()	{
				var param= Ext.getCmp('searchForm').getValues();
				var authoInfo = pgmInfo.authoUser;				// 권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	// 부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params:  param
				});
				
			},
			groupField:  'ITEM_CODE'
			
	});
	
	var directMasterStore2 = Unilite.createStore('str300skrvMasterStore1',{
			model:  'str300skrvModel2',
			uniOpt:  {
				isMaster:  true,			// 상위 버튼 연결
				editable:  false,			// 수정 모드 사용
				deletable: false,			// 삭제 가능 여부
				useNavi:  false			// prev | next 버튼 사용
			},
			autoLoad:  false,
			proxy:  {
				type:  'direct',
				api:  {			
					read:  'str300skrvService.selectList2'
				}
			}
			,loadStoreRecords:  function()	{
				var param= Ext.getCmp('searchForm').getValues();
				var authoInfo = pgmInfo.authoUser;				// 권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	// 부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params:  param
				});
				
			},
			groupField:  'ITEM_CODE1'
			
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
		items: [
			{
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [
			{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				value : UserInfo.divCode,
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				child: 'WH_CODE',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('INOUT_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			{
				fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
				name: 'INOUT_PRSN', 
				xtype:'uniCombobox', 
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			{
				fieldLabel:  '<t:message code="system.label.sales.warehouse" default="창고"/>',
				name: 'WH_CODE', 
				xtype:'uniCombobox',  
				comboType: 'O',
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
			},	
			{
				fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_INOUT_DATE',newValue);			
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_INOUT_DATE',newValue);						
					}
				}
			},
			
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){	
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name:'CREATE_LOC', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				hidden:true,
				comboCode:'B031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						 panelResult.setValue('CREATE_LOC', newValue);
					}
				}
			}
/*			,
			{ 
				fieldLabel: '합계행',
				xtype: 'radiogroup',
				itemId: 'optSelect',
				width: 300,
				items:[{
					boxLabel:'출력',
					name: 'optSelect',
					inputValue: 'Y', 
					checked: true
				},{
					boxLabel:'미출력',
					name:'optSelect',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.down('#optSelect').setValue(newValue);
						summaryHandle(newValue.optSelect);
					}
				}
				
			}*/
			 ]
		},{
			title: '<t:message code="system.label.sales.additionalsearch" default="추가검색"/>', 	
   			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items:[{ 
					fieldLabel:'<t:message code="system.label.sales.majorgroup" default="대분류"/>',
					name:'ITEM_LEVEL1', 
					xtype:'uniCombobox',  
					store:  Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child:  'ITEM_LEVEL2'
				},{ 
					fieldLabel:'<t:message code="system.label.sales.middlegroup" default="중분류"/>',
					name:'ITEM_LEVEL2', 
					xtype:'uniCombobox',  
					store:  Ext.data.StoreManager.lookup('itemLeve2Store'), 
					child:  'ITEM_LEVEL3'
				},{ 
					fieldLabel:'<t:message code="system.label.sales.minorgroup" default="소분류"/>',
					name:'ITEM_LEVEL3',
					xtype:'uniCombobox',
					store:Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
					levelType:'ITEM'
				},
					Unilite.popup('ITEM_GROUP',{ 
							fieldLabel:'<t:message code="system.label.sales.repmodel" default="대표모델"/>', 
							textFieldName:'ITEM_GROUP',
							valueFieldName: 'ITEM_GROUP_NAME',
							
							validateBlank: false,
							popupWidth:710,
							listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
									},
									scope: this
								},
								onClear: function(type)	{
									
								},
								applyextparam: function(popup){	
								}
						}
				}),{ 
			 		xtype:  'container',
			 		colspan: 2,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel:'<t:message code="system.label.sales.receiptno" default="입고번호"/>',//출고번호
 						suffixTpl: '&nbsp;~&nbsp;', 
 						name:'FR_INOUT_NO', 
 						width: 218
 					},{
 						hideLabel:true, 
 						name:'TO_INOUT_NO', 
 						width: 107
 					}] 
				},{
					fieldLabel:'Lot No.',
					name:'LOT_NO',
					width: 325,
					xtype:'uniTextfield'
				},{
					fieldLabel:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
					name:'ITEM_ACCOUNT',
					xtype:'uniCombobox',
					comboType:'AU',
					comboCode: 'B020'
				},{ 
					
			 		xtype:  'container',
			 		colspan: 2,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel:'<t:message code="system.label.sales.receiptqty" default="입고량"/>',//출고량
 						suffixTpl:'&nbsp;~&nbsp;',
 						name:'FR_INOUT_QTY',
 						width: 218
 					},{
 						hideLabel:true, 
 						name:'TO_INOUT_QTY', 
 						width: 107
 					}]
 				},{ 
 					fieldLabel:'<t:message code="system.label.sales.receiptplannedqty" default="입고유형"/>',//출고유형
 					name: 'INOUT_TYPE_DETAIL',
 					xtype:'uniCombobox',
 					comboType:'AU',
 					comboCode: 'S007'
 				},{ 
 					fieldLabel:'<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>',
 					name:'GOOD_BAD',
 					xtype:'uniCombobox',
 					comboType: 'AU',
 					comboCode: 'B021'
 				},
 				Unilite.popup('AGENT_CUST', {
					fieldLabel: '<t:message code="system.label.sales.issueplace" default="출고처"/>',
					valueFieldName:'CUSTOM_CODE',
					textFieldName:'CUSTOM_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					holdable: 'hold',
					itemId:'CUSTOM_CODE',
					hidden:true,
					colspan: 2,
					validateBlank	: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
							},
							scope: this
						},
						onValueFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								CustomCodeInfo.gsUnderCalBase = '';
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								CustomCodeInfo.gsUnderCalBase = '';
							}
						}
					}
				}),
 				{ 
			 		xtype:  'container',
			 		colspan: 2,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					itemId:'FR_ORDER_NUM',
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>',
 						suffixTpl:'&nbsp;~&nbsp;',
 						name:'FR_ORDER_NUM',
 						width: 218
 					},{
 						hideLabel:true, 
 						name:'TO_ORDER_NUM',
 						width: 107
 					}]
 				},{ 
 					fieldLabel:'PO_NO',
 					name:'PO_NO', 
 					hidden:true,
 					width: 300
 				},{ 
 					fieldLabel: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>',
					xtype: 'radiogroup',
					itemId:'TYPE',
					id:'TYPE_RDO',
					hidden:true,
					width: 300,
					items:[{
						boxLabel:'<t:message code="system.label.sales.itemby" default="품목별"/>',
						name: 'TYPE',
						inputValue: '1', 
						checked: true
					},{
						boxLabel:'<t:message code="system.label.sales.byissueplace" default="출고처별"/>',
						name:'TYPE',
						inputValue: '2'
					},{
						boxLabel:'<t:message code="system.label.sales.bydeliveryplacename" default="배송처별"/>',
						name:'TYPE',
						inputValue: '3'
					}]
					
				},{ 
					fieldLabel: '<t:message code="system.label.sales.deliverylapse" default="납기경과"/>',
					xtype: 'radiogroup',		
					itemId:'DELIVERY',
					width: 300,
					hidden:true,
					items: [{
						boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>', 
						name:'DELIVERY',
						inputValue: '0', 
						checked: true
					},{
						boxLabel:'<t:message code="system.label.sales.deliveryobservance" default="납기준수"/>',
						name:'DELIVERY',
						inputValue: '1'
					},{
						boxLabel:'<t:message code="system.label.sales.deliverylapse" default="납기경과"/>',
						name:'DELIVERY',
						inputValue: '2'
					}]
					
				},{
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.sales.returninclusionyn" default="반품포함여부"/>',
					itemId:'RETURN',
					width: 300,
					hidden:true,
					items: [{
						boxLabel:'<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
						name:'RETURN',
						inputValue: '1',
						checked: true
					},{
						boxLabel:'<t:message code="system.label.sales.inclusion" default="포함"/>',
						name:'RETURN',
						inputValue: '2'
					},{
						hidden: true
					}]
				},{
					fieldLabel: '<t:message code="system.label.sales.salessubjectyn" default="매출대상여부"/>',
					xtype: 'radiogroup',
					itemId:'ACCOUNT_YNC',
					width: 300,
					hidden:true,
					items: [{
						boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>',
						name:'ACCOUNT_YNC',
						inputValue: '',
						checked: true
					},{
						boxLabel:'<t:message code="system.label.sales.yes" default="예"/>',
						name:'ACCOUNT_YNC',
						inputValue: 'Y'
					},{
						boxLabel:'<t:message code="system.label.sales.no" default="아니오"/>',
						name:'ACCOUNT_YNC',
						inputValue: 'N'
					}]
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
							var labelText = invalid.items[0]['fieldLabel']+' : ';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
						}
	
						Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
	
	var panelResult = Unilite.createSearchForm('panelResultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		defaultType: 'uniSearchSubPanel',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{		
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				holdable: 'hold',
				value : UserInfo.divCode,
				child: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				},
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('INOUT_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
			
			{
				fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
//				colspan:3,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					 if(panelSearch) {
						panelSearch.setValue('FR_INOUT_DATE',newValue);
					 }
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					 if(panelSearch) {
						panelSearch.setValue('TO_INOUT_DATE',newValue);
					 }
				}
			},
			{
				fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
				name: 'INOUT_PRSN', 
				xtype:'uniCombobox', 
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						 panelSearch.setValue('INOUT_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){	
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
/*			{
				xtype:'label',
		 		colspan:1,
		 		hidden:false,
		 		itemId:'SEAT1'
				
			},*/
			{
				fieldLabel:  '<t:message code="system.label.sales.warehouse" default="창고"/>',
				name: 'WH_CODE', 
				xtype:'uniCombobox', 
				comboType   : 'O',
				//store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
						 change: function(field, newValue, oldValue, eOpts) {
						 panelSearch.setValue('WH_CODE', newValue);
						 }
					}
			},
/*			{ 
				fieldLabel: '합계행',
				xtype: 'radiogroup',
				itemId:'optSelect',
				width: 300,
				items:[{
					boxLabel:'출력',
					name: 'optSelect',
					inputValue: 'Y', 
					checked: true
				},{
					boxLabel:'미출력',
					name:'optSelect',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.down('#optSelect').setValue(newValue);
						summaryHandle(newValue.optSelect);
					}
				}
				
			},*/
			{
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name:'CREATE_LOC', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				hidden:true,
				comboCode:'B031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						 panelSearch.setValue('CREATE_LOC', newValue);
					}
				}
			}
		/*,{
			title: '', 	
   			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 4},
			collapsed: true,
			defaultType: 'uniTextfield',
			items:[{ 
					fieldLabel:'<t:message code="system.label.sales.majorgroup" default="대분류"/>',
					name:'ITEM_LEVEL1', 
					xtype:'uniCombobox',  
					store:  Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child:  'ITEM_LEVEL2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_LEVEL1', newValue);
						}
					}
				},{
					fieldLabel:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
					name:'ITEM_ACCOUNT',
					xtype:'uniCombobox',
					comboType:'AU',
					comboCode: 'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{ 
			 		xtype:  'container',
			 		colspan: 1,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel:'<t:message code="system.label.sales.receiptqty" default="입고량"/>',//출고량
 						suffixTpl:'&nbsp;~&nbsp;',
 						name:'FR_INOUT_QTY',
 						width: 218,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('FR_INOUT_QTY', newValue);
							}
						}
 					},{
 						hideLabel:true, 
 						name:'TO_INOUT_QTY', 
 						width: 107,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('TO_INOUT_QTY', newValue);
							}
						}
 					}]
 				},{ 
 					fieldLabel:'PO_NO',
 					name:'PO_NO', 
 					hidden:true,
 					width: 300,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('PO_NO', newValue);
							}
						}
 				},
 				{
					xtype:'label',
			 		colspan:1,
			 		hidden:false,
			 		itemId:'SEAT2'
				},
 				{ 
					fieldLabel:'<t:message code="system.label.sales.middlegroup" default="중분류"/>',
					name:'ITEM_LEVEL2', 
					xtype:'uniCombobox',  
					colspan:3,
					store:  Ext.data.StoreManager.lookup('itemLeve2Store'), 
					child:  'ITEM_LEVEL3',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('ITEM_LEVEL2', newValue);
							}
						}
				},{ 
 					fieldLabel: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>',
					xtype: 'radiogroup',
					width: 300,
					itemId:'TYPE',
					hidden:true,
					items:[{
						boxLabel:'<t:message code="system.label.sales.itemby" default="품목별"/>',
						name: 'TYPE',
						inputValue: '1', 
						checked: true
					},{
						boxLabel:'출고처별',
						name:'TYPE',
						inputValue: '2'
					},{
						boxLabel:'배송처별',
						name:'TYPE',
						inputValue: '3'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.down('#TYPE').setValue(newValue);
						}
					}
					
				},
				{
					xtype:'label',
			 		colspan:1,
			 		hidden:false,
			 		itemId:'SEAT3'
				},
				{ 
					fieldLabel:'<t:message code="system.label.sales.minorgroup" default="소분류"/>',
					name:'ITEM_LEVEL3',
					xtype:'uniCombobox',
					store:Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
					levelType:'ITEM',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('ITEM_LEVEL3', newValue);
							}
						}
				},{ 
 					fieldLabel:'<t:message code="system.label.sales.receiptplannedqty" default="입고유형"/>',//출고유형
 					name: 'INOUT_TYPE_DETAIL',
 					xtype:'uniCombobox',
 					comboType:'AU',
 					comboCode: 'S007',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('INOUT_TYPE_DETAIL', newValue);
							}
						}
 				},{ 
 					fieldLabel:'<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>',
 					name:'GOOD_BAD',
 					xtype:'uniCombobox',
 					comboType: 'AU',
 					comboCode: 'B021' ,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('GOOD_BAD', newValue);
							}
						}
 				},{ 
					fieldLabel: '납기경과',
					xtype: 'radiogroup',														
					width: 300,
					itemId:'DELIVERY',
					hidden:true,
					items: [{
						boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>', 
						name:'DELIVERY',
						inputValue: '0', 
						checked: true
					},{
						boxLabel:'납기준수',
						name:'DELIVERY',
						inputValue: '1'
					},{
						boxLabel:'납기경과',
						name:'DELIVERY',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.down('#DELIVERY').setValue(newValue);
						}
					}
					
				},
				{
					xtype:'label',
			 		colspan:1,
			 		hidden:false,
			 		itemId:'SEAT4'
				},
				Unilite.popup('ITEM_GROUP',{ 
						fieldLabel:'<t:message code="system.label.sales.repmodel" default="대표모델"/>', 
						textFieldName:'ITEM_GROUP',
						valueFieldName: 'ITEM_GROUP_NAME',
						
						validateBlank: false,
						popupWidth:710,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_GROUP', panelResult.getValue('ITEM_GROUP'));
									panelSearch.setValue('ITEM_GROUP_NAME', panelResult.getValue('ITEM_GROUP_NAME'));	
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_GROUP', '');
								panelSearch.setValue('ITEM_GROUP_NAME', '');
							},
							applyextparam: function(popup){	
							}
					}
				}),
 					Unilite.popup('AGENT_CUST', {
					fieldLabel: '<t:message code="system.label.sales.issueplace" default="출고처"/>',
					valueFieldName:'CUSTOM_CODE',
					textFieldName:'CUSTOM_NAME',
					itemId:'CUSTOM_CODE',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					hidden:true,
					holdable: 'hold',
					colspan: 2,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
									CustomCodeInfo.gsUnderCalBase = '';
									panelSearch.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
					}
				}),
				
				{
					xtype: 'radiogroup',
					fieldLabel: '반품포함여부',
					width: 300,
					itemId:'RETURN',
					hidden: true,
					items: [{
						boxLabel:'<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
						name:'RETURN',
						inputValue: '1',
						checked: true
					},{
						boxLabel:'<t:message code="system.label.sales.inclusion" default="포함"/>',
						name:'RETURN',
						inputValue: '2'
					},{
						hidden: true
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.down('#RETURN').setValue(newValue);
						}
					}
					
				},
				{
					xtype:'label',
			 		colspan:3,
			 		hidden:false,
			 		itemId:'SEAT5'
				},	
				{ 
			 		xtype:  'container',
			 		colspan: 1,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel:'<t:message code="system.label.sales.receiptno" default="입고번호"/>',//출고번호
 						suffixTpl: '&nbsp;~&nbsp;', 
 						name:'FR_INOUT_NO', 
 						width: 218,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('FR_INOUT_NO', newValue);
							}
						}
 					},{
 						hideLabel:true, 
 						name:'TO_INOUT_NO', 
 						width: 107,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('TO_INOUT_NO', newValue);
							}
						}
 					}] 
				},{ 
			 		xtype:  'container',
			 		colspan: 2,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					defaultType:  'uniTextfield',
 					itemId:'FR_ORDER_NUM',
 					hidden:true,
 					items: [{
 						fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>',
 						suffixTpl:'&nbsp;~&nbsp;',
 						name:'FR_ORDER_NUM',
 						width: 218,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('FR_ORDER_NUM', newValue);
							}
						}
 					},{
 						hideLabel:true, 
 						name:'TO_ORDER_NUM',
 						width: 107,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('TO_ORDER_NUM', newValue);
							}
						}
 					}]
 				},{
					fieldLabel: '<t:message code="system.label.sales.salessubjectyn" default="매출대상여부"/>',
					xtype: 'radiogroup',
					itemId:'ACCOUNT_YNC',
					width: 300,
 					hidden:true,
					items: [{
						boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>',
						name:'ACCOUNT_YNC',
						inputValue: 'YN',
						checked: true
					},{
						boxLabel:'예',
						name:'ACCOUNT_YNC',
						inputValue: 'Y'
					},{
						boxLabel:'아니오',
						name:'ACCOUNT_YNC',
						inputValue: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.down('#ACCOUNT_YNC').setValue(newValue);
						}
					}
				},
				{
					xtype:'label',
			 		colspan:3,
			 		hidden:false,
			 		itemId:'SEAT6'
				},
				{
					fieldLabel:'Lot No.',
					name:'LOT_NO',
					width: 325,
					xtype:'uniTextfield',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('LOT_NO', newValue);
						}
					}
				}]
													  
		}*/
	]
	
   
	
	});
	
	var masterGrid = Unilite.createGrid('str300skrvGrid1', {
		// for tab
		region: 'center' ,
		layout:  'fit',
		title: '<t:message code="system.label.sales.byreceipt" default="입고별"/>',
		store:  directMasterStore1, 
		uniOpt:{
				expandLastColumn: false,
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features:  [ {id:  'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  true },
					 {id:  'masterGridTotal'   , ftype:  'uniSummary'		, showSummaryRow:  true} ],
		columns: [   { dataIndex: 'ITEM_CODE'			,width: 120 ,locked: false,
						 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							 return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.itemtotal" default="품목계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
						 }
					 },
					 { dataIndex: 'ITEM_NAME'			,width: 160 ,locked: false},
					 { dataIndex: 'ITEM_NAME1'			,width: 160 ,hidden: true},
					 { dataIndex: 'SPEC'				,width: 150 },
					 { dataIndex: 'ORDER_UNIT'			,width: 60  , align: 'center' ,hidden:true},
					 { dataIndex: 'TRNS_RATE'			,width: 66 },
					 { dataIndex: 'STOCK_UNIT'			,width: 66  , align: 'center'  },   
					 { dataIndex: 'INOUT_Q'				,width: 100 ,summaryType:'sum'},
					 { dataIndex: 'ORDER_UNIT_Q'		,width: 90 ,hidden:true},
					 { dataIndex: 'WGT_UNIT'			,width: 80 ,hidden:true},
					 { dataIndex: 'UNIT_WGT'			,width: 80 ,hidden:true},
					 { dataIndex: 'INOUT_WGT_Q'			,width: 100,hidden:true},
					 { dataIndex: 'INOUT_TYPE_DETAIL'	,width: 120 },
					 { dataIndex: 'INOUT_CODE_TYPE'		,width: 66 ,hidden:true},
					 { dataIndex: 'INOUT_CODE'			,width: 80 ,hidden:true},
					 { dataIndex: 'INOUT_NAME'			,width: 120 },
					 { dataIndex: 'INOUT_DATE'			,width: 80 },
					 { dataIndex: 'ITEM_STATUS'			,width: 66, align: 'center' },
					 { dataIndex: 'WH_CODE'				,width: 100, align: 'center' ,hidden:true   },
					 { dataIndex: 'WH_NAME'				,width: 100, align: 'center'   },
					 { dataIndex: 'DIV_CODE'			,width: 100,hidden:true },
					 { dataIndex: 'INOUT_NUM'			,width: 100 },
					 { dataIndex: 'INOUT_SEQ'			,width: 66   },
					 { dataIndex: 'LOT_NO'				,width: 100 },
					 { dataIndex: 'PROJECT_NO'			,width: 100 },
					 { dataIndex: 'REMARK'				,width: 120 },
					 { dataIndex: 'INOUT_PRSN'			,width: 100 },
					 { dataIndex: 'BASIS_NUM'			,width: 110},
					 { dataIndex: 'INOUT_METH'			,width: 80   },
					 { dataIndex: 'EVAL_INOUT_P'		,width: 100   },
					 { dataIndex: 'SORT_KEY'			,width: 120, hidden: true   }	
					 
					 
		  ] 
	});
	
	var masterGrid2 = Unilite.createGrid('str300skrvGrid2', {
		// for tab
		region: 'center' ,
		layout:  'fit',
		title: '<t:message code="system.label.sales.byissue" default="출고별"/>',
		store:  directMasterStore2, 
		uniOpt:{
			expandLastColumn: false,
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		features:  [ {id:  'masterGridSubTotal2', ftype:  'uniGroupingsummary', showSummaryRow:  true },
					 {id:  'masterGridTotal2', 	ftype:  'uniSummary'		  , showSummaryRow:  true} ],
		columns: [   
					 { dataIndex: 'ITEM_CODE1'			,width: 120 ,locked: false,
						 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
							 return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.itemsubtotal" default="품목소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
						 }
					 },
					 { dataIndex: 'ITEM_NAME1'			,width: 120 ,locked: false},
					 { dataIndex: 'ITEM_CODE2'  		,width: 120 ,hidden:true},
					 { dataIndex: 'ITEM_NAME2'  		,width: 120 ,hidden:true},
					 { dataIndex: 'ITEM_CODE'   		,width: 120 ,hidden:true},
					 { dataIndex: 'ITEM_NAME_R1'   		,width: 120 ,hidden:true},
					 { dataIndex: 'SPEC'				,width: 120 },
					 { dataIndex: 'ORDER_UNIT'			,width: 66, align: 'center' },
					 { dataIndex: 'INOUT_Q'				,width: 100,summaryType:'sum'},
					 
					 { dataIndex: 'WGT_UNIT'			,width: 80 ,hidden:true},
					 { dataIndex: 'UNIT_WGT'			,width: 80 ,hidden:true},
					 { dataIndex: 'INOUT_WGT_Q'		,width: 100,hidden:true},
					 { dataIndex: 'INOUT_FOR_WGT_P'		,width: 80 ,hidden:true},
					 { dataIndex: 'VOL_UNIT'			,width: 80 ,hidden:true},
					 { dataIndex: 'UNIT_VOL'			,width: 80 ,hidden:true},
					 { dataIndex: 'INOUT_VOL_Q'		,width: 80 ,hidden:true},
					 { dataIndex: 'INOUT_FOR_VOL_P'  	,width: 80 ,hidden:true},
					 
					 { dataIndex: 'TRNS_RATE'			,width: 66 },
					 { dataIndex: 'STOCK_UNIT'			,width: 120, align: 'center'  },
					 { dataIndex: 'ORDER_UNIT_Q'		,width: 120 ,summaryType:'sum'},
					 { dataIndex: 'ORDER_UNIT_P'		,width: 106 ,hidden:true},
					 { dataIndex: 'EXCHG_RATE_O'		,width: 80  ,hidden:true},
					 { dataIndex: 'MONEY_UNIT'			,width: 65, align: 'center'},
					 { dataIndex: 'INOUT_P'  			,width: 120  ,hidden:true},
					 { dataIndex: 'INOUT_FOR_O'		,width: 120},
					 { dataIndex: 'INOUT_I'				,width: 120 ,summaryType:'sum'},
					 { dataIndex: 'TRANS_COST'			,width: 80 ,hidden:true},
					 { dataIndex: 'INOUT_TYPE_DETAIL'	,width: 80 },
					 { dataIndex: 'INOUT_CODE_TYPE'		,width: 60 ,hidden:true},
					 { dataIndex: 'INOUT_CODE'   		,width: 30 ,hidden:true},
					 { dataIndex: 'SALE_CUSTOM_NAME'	,width: 120 },
					 { dataIndex: 'INOUT_NAME'			,width: 120 },
					 { dataIndex: 'INOUT_DATE'   		,width: 80 },
					 { dataIndex: 'DVRY_CUST_NAME'		,width: 100 },
					 { dataIndex: 'DOM_FORIGN'			,width: 100, align: 'center'},
					 { dataIndex: 'WH_CODE'				,width: 100, align: 'center' ,hidden:true   },
					 { dataIndex: 'WH_NAME'				,width: 100, align: 'center'   },
					 { dataIndex: 'INOUT_PRSN'   		,width: 66 , align: 'center'   },
					 { dataIndex: 'ISSUE_DATE'			,width: 80},
					 { dataIndex: 'ISSUE_REQ_NUM'		,width: 100 },
					 { dataIndex: 'LOT_NO'			,width: 80 },
					 { dataIndex: 'ACCOUNT_YNC'		,width: 80 , align: 'center'},
					 { dataIndex: 'ORDER_NUM'			,width: 120 },
					 { dataIndex: 'DVRY_DATE'			,width: 80 },
					 { dataIndex: 'DELIVERY_DATE'		,width: 80 ,hidden:true},
					 { dataIndex: 'ACCOUNT_Q'			,width: 80 },
					 { dataIndex: 'LC_NUM'				,width: 80 ,hidden:true },
					 { dataIndex: 'INOUT_NUM'			,width: 120 },
					 { dataIndex: 'INOUT_SEQ'			,width: 60 , align: 'center'},
					 { dataIndex: 'INOUT_METH'			,width: 80 , align: 'center'},
					 { dataIndex: 'PROJECT_NO'		  ,width: 100 },
					 { dataIndex: 'REMARK'			,width: 80 },
					 { dataIndex: 'PO_NUM'			,width: 80 ,hidden:true},
					 { dataIndex: 'PO_SEQ'				,width: 80 ,hidden:true},
					 { dataIndex: 'EVAL_INOUT_P'		,width: 80 ,hidden:true},
					 { dataIndex:  'SORT_KEY'		   ,width: 80 ,hidden:true},
					 { dataIndex: 'PRICE_TYPE'			,width: 80 ,hidden:true},
					
					 { dataIndex: 'UPDATE_DB_TIME' 		,width: 80 ,hidden:true }

		
//
//		.ColHidden(.ColIndex("INOUT_CODE"))			= True
//		.ColHidden(.ColIndex("INOUT_CODE_TYPE"))	= True	
//		.ColHidden(.ColIndex("TRANS_COST"))		 = True	
//		
//		.ColHidden(.ColIndex("ORDER_UNIT_P"))		= True
//		.ColHidden(.ColIndex("EXCHG_RATE_O"))	   = True			
//		
//		.ColHidden(.ColIndex("ITEM_CODE2"))			= True
//		.ColHidden(.ColIndex("ITEM_NAME2"))			= True   		
//		.ColHidden(.ColIndex("INOUT_P"))			= True	
//		.ColHidden(.ColIndex("PO_NUM"))				= True
//		.ColHidden(.ColIndex("PO_SEQ"))				= True 
//		.ColHidden(.ColIndex("SORT_KEY"))			= TRUE
//
//		.ColHidden(.ColIndex("PRICE_TYPE"))			= True
//'		.ColHidden(.ColIndex("INOUT_WGT_Q"))		= True
//		.ColHidden(.ColIndex("INOUT_FOR_WGT_P"))	= True
//		.ColHidden(.ColIndex("INOUT_VOL_Q"))		= True
//		.ColHidden(.ColIndex("INOUT_FOR_VOL_P"))	= True
//'		.ColHidden(.ColIndex("WGT_UNIT"))			= True
//'		.ColHidden(.ColIndex("UNIT_WGT"))			= True
//		.ColHidden(.ColIndex("VOL_UNIT"))			= True
//		.ColHidden(.ColIndex("UNIT_VOL"))			= True
					 
		  ] 
	});
	
	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab:  0,
		region: 'center',
		items:  [
			 masterGrid,
			 masterGrid2
		],
		 listeners:  {
			beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
					
				switch(newTabId)	{
					case 'str300skrvGrid1':
						var poSearch = Ext.getCmp('str300skrvPOSearch');
						//poSearch.setVisible(false);
						panelResult.getField('CREATE_LOC').setHidden(true);
						panelSearch.getField('CREATE_LOC').setHidden(true);
					   
//						for(var i= 1;i<=6;i++){
//							panelResult.down('#SEAT'+i).setHidden(false);
//						}
//						panelResult.getField('PO_NO').setHidden(true);
						panelSearch.getField('PO_NO').setHidden(true);
						
//						panelResult.down('#TYPE').setHidden(true);
						panelSearch.down('#TYPE').setHidden(true);
						
//						panelResult.down('#DELIVERY').setHidden(true);
						panelSearch.down('#DELIVERY').setHidden(true);
						
//						panelResult.down('#RETURN').setHidden(true);
						panelSearch.down('#RETURN').setHidden(true);
						
//						panelResult.down('#FR_ORDER_NUM').setHidden(true);
						panelSearch.down('#FR_ORDER_NUM').setHidden(true);
						
//						panelResult.down('#ACCOUNT_YNC').setHidden(true);
						panelSearch.down('#ACCOUNT_YNC').setHidden(true);
						
//						panelResult.down('#CUSTOM_CODE').setHidden(true);
						panelSearch.down('#CUSTOM_CODE').setHidden(true);
						
						
//						panelResult.getField('FR_INOUT_NO').setFieldLabel("입고번호");
						panelSearch.getField('FR_INOUT_NO').setFieldLabel("<t:message code="system.label.sales.receiptno" default="입고번호"/>");
						
//						panelResult.getField('FR_INOUT_QTY').setFieldLabel("입고량");
						panelSearch.getField('FR_INOUT_QTY').setFieldLabel("<t:message code="system.label.sales.receiptqty" default="입고량"/>");
						
//						panelResult.getField('INOUT_TYPE_DETAIL').setFieldLabel("입고유형");
						panelSearch.getField('INOUT_TYPE_DETAIL').setFieldLabel("<t:message code="system.label.sales.receiptplannedqty" default="입고유형"/>");
						break;
						
					case 'str300skrvGrid2':
						var poSearch = Ext.getCmp('str300skrvPOSearch');
						//poSearch.setVisible(false);	
						panelResult.getField('CREATE_LOC').setHidden(false);
						panelSearch.getField('CREATE_LOC').setHidden(false);
//						for(var i= 1;i<=6;i++){
//							panelResult.down('#SEAT'+i).setHidden(true);
//						}
						
//						panelResult.getField('PO_NO').setHidden(false);
						panelSearch.getField('PO_NO').setHidden(false);
						
//						panelResult.down('#TYPE').setHidden(false);
						panelSearch.down('#TYPE').setHidden(false);
						
//						panelResult.down('#DELIVERY').setHidden(false);
						panelSearch.down('#DELIVERY').setHidden(false);
						
//						panelResult.down('#RETURN').setHidden(false);
						panelSearch.down('#RETURN').setHidden(false);
						
//						panelResult.down('#FR_ORDER_NUM').setHidden(false);
						panelSearch.down('#FR_ORDER_NUM').setHidden(false);
						
//						panelResult.down('#ACCOUNT_YNC').setHidden(false);
						panelSearch.down('#ACCOUNT_YNC').setHidden(false);
						
//						panelResult.down('#CUSTOM_CODE').setHidden(false);
						panelSearch.down('#CUSTOM_CODE').setHidden(false);
						
//						panelResult.getField('FR_INOUT_NO').setFieldLabel("출고번호");
						panelSearch.getField('FR_INOUT_NO').setFieldLabel("<t:message code="system.label.sales.issueno" default="출고번호"/>");
						
//						panelResult.getField('FR_INOUT_QTY').setFieldLabel("출고량");
						panelSearch.getField('FR_INOUT_QTY').setFieldLabel("<t:message code="system.label.sales.issueqty" default="출고량"/>");
						
//						panelResult.getField('INOUT_TYPE_DETAIL').setFieldLabel("출고유형");
						panelSearch.getField('INOUT_TYPE_DETAIL').setFieldLabel("<t:message code="system.label.sales.issuetype" default="출고유형"/>");
						break;
						
					default:
						break;
				}
			}
		 }
	});
	
	Unilite.Main ({
		borderItems: [{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab,  panelResult
			]	
		},panelSearch
		// panelSearch
		],
		id: 'str300skrvApp',
		fnInitBinding: function() {
			//20210405 추가
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_INOUT_DATE')));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_INOUT_DATE')));

			str300skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'str300skrvGrid1') {
				masterGrid.reset();
			}else{
				masterGrid2.reset();
			}
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{
			var activeTabId = tab.getActiveTab().getId();
//			var viewNormal = masterGrid.normalGrid.getView();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal2 = masterGrid2.normalGrid.getView();
//			var viewLocked2 = masterGrid2.lockedGrid.getView();
			
			if(activeTabId == 'str300skrvGrid1'){
				directMasterStore1.loadStoreRecords();
//				console.log("viewNormal : ",viewNormal);
//				console.log("viewLocked : ",viewLocked);
//				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//				viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//				viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			}
			else if(activeTabId == 'str300skrvGrid2'){
				directMasterStore2.loadStoreRecords();
				
				if(Ext.getCmp('TYPE_RDO').getChecked()[0].inputValue == '1'){
					masterGrid2.getColumn('ITEM_CODE1').setText('<t:message code="system.label.sales.item" default="품목"/>');
					masterGrid2.getColumn('ITEM_NAME1').setText('<t:message code="system.label.sales.itemname" default="품목명"/>');
				}
				else if(Ext.getCmp('TYPE_RDO').getChecked()[0].inputValue == '2'){
					masterGrid2.getColumn('ITEM_CODE1').setText('<t:message code="system.label.sales.issueplacecode" default="출고처코드"/>');
					masterGrid2.getColumn('ITEM_NAME1').setText('<t:message code="system.label.sales.issueplacename" default="출고처명"/>');
				}
				else if(Ext.getCmp('TYPE_RDO').getChecked()[0].inputValue == '3'){
					masterGrid2.getColumn('ITEM_CODE1').setText('<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>');
					masterGrid2.getColumn('ITEM_NAME1').setText('<t:message code="system.label.sales.deliveryplacename" default="배송처명"/>');
				}
				
//				console.log("viewNormal2 : ",viewNormal2);
//				console.log("viewLocked2 : ",viewLocked2);
//				viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
//				viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
//				viewLocked2.getFeature('masterGridTotal2').toggleSummaryRow(true);
//				viewLocked2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
			} 
//			summaryHandle(panelResult.down("#optSelect").getValue().optSelect);
//			UniAppManager.setToolbarButtons('reset', true)
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
	function summaryHandle(type){
		var activeTabId = tab.getActiveTab().getId();
		var viewNormal = masterGrid.getView();
		//var viewLocked = masterGrid.lockedGrid.getView();
		var viewNormal2 = masterGrid2.getView();
		//var viewLocked2 = masterGrid2.lockedGrid.getView();

		if(activeTabId == 'str300skrvGrid1'){				
			
			console.log("viewNormal : ",viewNormal);
			//console.log("viewLocked : ",viewLocked);
			if(type == 'Y'){
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
				//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
				//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			}else{
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
				viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
				//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
				//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
			}
		}
		else if(activeTabId == 'str300skrvGrid2'){
			console.log("viewNormal2 : ",viewNormal2);
			//console.log("viewLocked2 : ",viewLocked2);
			if(type == 'Y'){
				viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
				viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
				//viewLocked2.getFeature('masterGridTotal2').toggleSummaryRow(true);
				//viewLocked2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
			}else{
				viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(false);
				viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(false);
				//viewLocked2.getFeature('masterGridTotal2').toggleSummaryRow(false);
				//viewLocked2.getFeature('masterGridSubTotal2').toggleSummaryRow(false);
			}
		} 
	}
};
</script>