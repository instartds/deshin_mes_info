<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mtr111skrv"  >
   <t:ExtComboStore comboType="BOR120" pgmId="mtr111skrv" />          <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
   <t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 --> 
   <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 --> 
   <t:ExtComboStore comboType="AU" comboCode="B035" /> <!-- 수불타입 -->
   <t:ExtComboStore comboType="AU" comboCode="B036" /> <!-- 수불방법 -->
   <t:ExtComboStore comboType="AU" comboCode="B031" /> <!-- 생성경로 --> 
   <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 통화 -->
   <t:ExtComboStore comboType="AU" comboCode="B059" /><!-- 세구분 -->
   <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고 -->
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
   <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />   
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var BsaCodeInfo = {
	gsInOutPrsn: '${gsInOutPrsn}'
};
function appMain() {
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Mtr111skrvModel', {
		fields: [
            {name: 'GUBUN'              , text: '<t:message code="system.label.purchase.classfication" default="구분"/>'              , type: 'string'},
		
			{name: 'DIV_CODE'			    , text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string',comboType:'BOR120'},
			
            {name: 'ITEM_CODE'		        , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'},
            {name: 'ITEM_NAME'		        , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
            {name: 'SPEC'		        	, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
            {name: 'INOUT_DATE'	    	    , text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'				, type: 'uniDate'},
            {name: 'CONFIRM_YN'	    	    , text: '<t:message code="system.label.purchase.confirmedpending" default="확정여부"/>'				, type: 'string'},
            {name: 'INOUT_CODE'	            , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
            {name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				, type: 'string'},
            {name: 'INOUT_Q'			    , text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'				, type: 'uniQty'},
            {name: 'INOUT_P'			    , text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
            {name: 'INOUT_I'			    , text: '<t:message code="system.label.purchase.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
            {name: 'INOUT_TAX_AMT'  	    , text: '<t:message code="system.label.purchase.vatamount" default="부가세액"/>'				, type: 'uniPrice'},
	    	{name: 'INOUT_TOTAL_I'  	    , text: '<t:message code="system.label.purchase.totalamount1" default="합계금액"/>'				, type: 'uniPrice'},
	    	{name: 'TAX_TYPE'		  	    , text: '<t:message code="system.label.purchase.taxtype" default="세구분"/>'				, type: 'string',comboType:'AU', comboCode:'B059'},
	    	
            
//            {name: 'EXPENSE_I'			    , text: '수입부대비'			, type: 'uniPrice'},
//            {name: 'INOUT_I_TOTAL'		    , text: '합계금액(부대비포함)'	, type: 'uniPrice'},
//            {name: 'INOUT_FOR_P'	        , text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>'				, type: 'uniFC'},
//            {name: 'INOUT_FOR_O'	        , text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>'				, type: 'uniFC'},
//            {name: 'MONEY_UNIT'			    , text: '통화'				, type: 'string'},
//            {name: 'EXCHG_RATE_O'		    , text: '입고환율'				, type: 'uniER'},
            {name: 'STOCK_UNIT'			    , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'				, type: 'string'},
            {name: 'INOUT_TYPE'			    , text: '<t:message code="system.label.purchase.trantype1" default="수불타입"/>'				, type: 'string',comboType:'AU', comboCode:'B035'},
            {name: 'WH_CODE'			    , text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'				, type: 'string',store: Ext.data.StoreManager.lookup('whList')},
            {name: 'INOUT_PRSN'			    , text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'				, type: 'string',comboType:'AU', comboCode:'B024'},
            {name: 'INOUT_NUM'			    , text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'				, type: 'string'},
            {name: 'INOUT_METH'			    , text: '<t:message code="system.label.purchase.tranmethod" default="수불방법"/>'				, type: 'string',comboType:'AU', comboCode:'B036'},
//            {name: 'INOUT_TYPE_DETAIL'		, text: '수불유형'				, type: 'string'},
            
            
            {name: 'ORDER_UNIT_Q'				    , text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
            {name: 'ORDER_O'          , text: '<t:message code="system.label.purchase.poamount" default="발주금액"/>'              , type: 'uniPrice'},
            {name: 'R_ORDER_P'          , text: '<t:message code="system.label.purchase.receiptorderprice" default="입고대발주액"/>'              , type: 'uniPrice'},
			{name: 'SO_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'	, type: 'string'},

            {name: 'ORDER_DATE'			    , text: '<t:message code="system.label.purchase.podate" default="발주일"/>'				, type: 'uniDate'},
            {name: 'ORDER_NUM'			    , text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
            {name: 'ORDER_SEQ'			    , text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'				, type: 'int'},
//            {name: 'DVRY_DATE'			    , text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'				, type: 'uniDate'},
            {name: 'BUY_Q'				    , text: '<t:message code="system.label.purchase.purchaseqty" default="매입량"/>'				, type: 'uniQty'},
            
            {name: 'ITEM_LEVEL1'		    , text: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>'				, type: 'string'},
            {name: 'ITEM_LEVEL2'		    , text: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>'				, type: 'string'},
            {name: 'ITEM_LEVEL3'		    , text: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>'				, type: 'string'},
            {name: 'REMARK'				    , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
//            {name: 'PROJECT_NO'			    , text: '<t:message code="system.label.purchase.manageno" default="관리번호"/>'				, type: 'string'},
            {name: 'LOT_NO'			        , text: 'LOT NO'				, type: 'string'},
//            {name: 'LC_NUM'				    , text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				, type: 'string'},
//            {name: 'BL_NUM'				    , text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'				, type: 'string'},
            {name: 'CREATE_LOC'			    , text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'				, type: 'string',comboType:'AU', comboCode:'B031'},
            
            {name: 'UPDATE_DB_TIME'		    , text: '<t:message code="system.label.purchase.entrydate" default="등록일"/>'				, type: 'uniDate'}           
		]
	});//End of Unilite.defineModel('Mtr111skrvModel', {
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore1 = Unilite.createStore('mtr111skrvMasterStore1',{
		model: 'Mtr111skrvModel',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결 
			editable: false,         // 수정 모드 사용 
			deletable:false,         // 삭제 가능 여부 
			useNavi : false         // prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {         
					read: 'mtr111skrvService.selectList'                   
				}
			},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();      
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('searchForm').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'ITEM_CODE'
	});//End of var directMasterStore1 = Unilite.createStore('mtr111skrvMasterStore1',{

   /**
    * 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',		
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
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('INOUT_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						var field2 = panelResult.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					},
                    afterrender: function(field) {
                        var divStore = field.getStore();
                        divStore.insert(0, {"value":"", "option":null, "text":'<t:message code="system.label.purchase.wholecompany" default="전사"/>'});
                    }
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_NAME', '');
					},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>', 
				name:'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_FR_DATE',
				endFieldName: 'INOUT_TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				//holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('INOUT_FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INOUT_TO_DATE',newValue);
			    	}
			    }
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				//validateBlank:false, 
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>', 
				name: 'INOUT_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'M001',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ORDER_TYPE', newValue);
						}
					}
			},{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',						            		
					labelWidth:90,
					colspan:2,
					items : [{
						boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
						width: 60,
						name: 'INOUT_TYPE',
						inputValue: 'A',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.purchase.receipt" default="입고"/>',
						width: 60,
						name: 'INOUT_TYPE' ,
						inputValue: '1'
					},{
						boxLabel: '<t:message code="system.label.purchase.return" default="반품"/>',
						width: 60,
						name: 'INOUT_TYPE' ,
						inputValue: '4'
					}],
					listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelResult.getField('INOUT_TYPE').setValue(newValue.INOUT_TYPE);
							}
						}
				},{
					fieldLabel: 'LOT NO',
					name: 'LOT_NO',
					xtype: 'uniTextfield'
				}
			/*{ 
				name: 'ITEM_LEVEL1',  			
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL2',  			
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL3',  			
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}*/]                         
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
	
					   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
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
				holdable: 'hold',
				child:'WH_CODE',
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);						
					var field = panelSearch.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
					var field2 = panelSearch.getField('WH_CODE');		
						field2.getStore().clearFilter(true);
					},
                    afterrender: function(field) {
                        var divStore = field.getStore();
                        divStore.insert(0, {"value":"", "option":null, "text":'<t:message code="system.label.purchase.wholecompany" default="전사"/>'});
                    }
				}
			},
			Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelSearch.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_NAME', '');
					},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.warehouse" default="창고"/>', 
				name:'WH_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WH_CODE', newValue);
					}
				}
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_FR_DATE',
				endFieldName: 'INOUT_TO_DATE',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				//holdable: 'hold',
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('INOUT_FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('INOUT_TO_DATE',newValue);
			    	}
			    }
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE', 
				textFieldName: 'CUSTOM_NAME', 
				//validateBlank:false, 
				popupWidth: 710,
				extParam: {'CUSTOM_TYPE': ['1','2']},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_CODE', newValue);
								panelResult.setValue('CUSTOM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('CUSTOM_NAME', newValue);
								panelResult.setValue('CUSTOM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>', 
				name: 'INOUT_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('INOUT_PRSN', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_CODE', newValue);
									panelResult.setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_NAME', '');
										panelResult.setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelSearch.setValue('ITEM_NAME', newValue);
									panelResult.setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelSearch.setValue('ITEM_CODE', '');
										panelResult.setValue('ITEM_CODE', '');
									}
								},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'M001',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ORDER_TYPE', newValue);
						}
					}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.purchase.classfication" default="구분"/>',						            		
				labelWidth:90,
				colspan:2,
				items : [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width: 60,
					name: 'INOUT_TYPE',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.receipt" default="입고"/>',
					width: 60,
					name: 'INOUT_TYPE' ,
					inputValue: '1'
				},{
					boxLabel: '<t:message code="system.label.purchase.return" default="반품"/>',
					width: 60,
					name: 'INOUT_TYPE' ,
					inputValue: '4'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelSearch.getField('INOUT_TYPE').setValue(newValue.INOUT_TYPE);
						}
					}
			}/*,{ 
				name: 'ITEM_LEVEL1',  			
				fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'ITEM_LEVEL2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL2',  			
				fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'ITEM_LEVEL3',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				name: 'ITEM_LEVEL3',  			
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}*/],
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
	
					   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mtr111skrvGrid1', {
       // for tab       
		//layout: 'fit',
		excelTitle: '<t:message code="system.label.purchase.receiptstatusinquiry2" default="입고현황조회"/>',
		region:'center',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: true,
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
//		selModel:'rowmodel',
		columns: [
            {dataIndex: 'GUBUN'             , width: 100,align:'center'},
			{dataIndex: 'DIV_CODE'			    , width: 80, hidden: true},
			
            {dataIndex: 'ITEM_CODE'		        , width: 120,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
            {dataIndex: 'ITEM_NAME'		        , width: 230},
            {dataIndex: 'SPEC'		        	, width: 80},
            {dataIndex: 'INOUT_DATE'	    	, width: 80},
            {dataIndex: 'CONFIRM_YN'	    	, width: 80,align:'center'},
            {dataIndex: 'INOUT_CODE'	        , width: 150, hidden: true},
            {dataIndex: 'CUSTOM_NAME'			, width: 166},
            {dataIndex: 'INOUT_Q'			    , width: 80,summaryType: 'sum'},
            {dataIndex: 'INOUT_P'			    , width: 100},
            {dataIndex: 'INOUT_I'			    , width: 100,summaryType: 'sum'},
            {dataIndex: 'INOUT_TAX_AMT'			, width: 100,summaryType: 'sum'},
            {dataIndex: 'INOUT_TOTAL_I'			, width: 100,summaryType: 'sum'},
            {dataIndex: 'TAX_TYPE'				, width: 50, align:'center'},
//            {dataIndex: 'EXPENSE_I'				, width: 100,summaryType: 'sum'},
//            {dataIndex: 'INOUT_I_TOTAL'			, width: 133,summaryType: 'sum'},
//            {dataIndex: 'INOUT_FOR_P'	        , width: 100},
//            {dataIndex: 'INOUT_FOR_O'	        , width: 100,summaryType: 'sum'},
//            {dataIndex: 'MONEY_UNIT'			, width: 66},
//            {dataIndex: 'EXCHG_RATE_O'		    , width: 66},
            {dataIndex: 'STOCK_UNIT'			, width: 66,align:'center'},
            {dataIndex: 'INOUT_TYPE'			, width: 75,align:'center'},
            {dataIndex: 'WH_CODE'			    , width: 90,align:'center'},
            {dataIndex: 'INOUT_PRSN'			, width: 66,align:'center'},
            {dataIndex: 'INOUT_NUM'				, width: 120,align:'center'},
            {dataIndex: 'INOUT_METH'			, width: 66,align:'center'},
//            {dataIndex: 'INOUT_TYPE_DETAIL'		, width: 66},
            
            {dataIndex: 'ORDER_UNIT_Q'             , width: 80},
            {dataIndex: 'ORDER_O'             , width: 100},
            {dataIndex: 'R_ORDER_P'             , width: 100},
			{ dataIndex: 'SO_NUM'		,width:100,hidden:true},

            {dataIndex: 'ORDER_DATE'			, width: 93},
            {dataIndex: 'ORDER_NUM'				, width: 133},
            {dataIndex: 'ORDER_SEQ'				, width: 88},
//            {dataIndex: 'DVRY_DATE'				, width: 93},
            {dataIndex: 'BUY_Q'					, width: 93},
            {dataIndex: 'REMARK'				, width: 133},
//            {dataIndex: 'PROJECT_NO'			, width: 133},
            
            {dataIndex: 'ITEM_LEVEL1'		    , width: 120,align:'center'},             
            {dataIndex: 'ITEM_LEVEL2'		    , width: 100,align:'center'},
            {dataIndex: 'ITEM_LEVEL3'		    , width: 100,align:'center'},
            {dataIndex: 'LOT_NO'			    , width: 113},
//            {dataIndex: 'LC_NUM'				, width: 113},
//            {dataIndex: 'BL_NUM'				, width: 113},
            {dataIndex: 'CREATE_LOC'			, width: 66,align:'center', hidden: true},
            
            {dataIndex: 'UPDATE_DB_TIME'		, width: 90}
		] 
	});//End of var masterGrid = Unilite.createGrid('mtr111skrvGrid1', {   

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id: 'mtr111skrvApp',
		fnInitBinding: function(params) {
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');			
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('INOUT_FR_DATE', UniDate.get('today'));
			panelSearch.setValue('INOUT_TO_DATE', UniDate.get('today'));
			panelResult.setValue('INOUT_FR_DATE', UniDate.get('today'));
			panelResult.setValue('INOUT_TO_DATE', UniDate.get('today'));
//			panelSearch.setValue('CREATE_LOC', '1');
//			panelSearch.setValue('INOUT_TYPE_DETAIL', '10');
			
//			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelSearch.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			panelResult.setValue('INOUT_PRSN',BsaCodeInfo.gsInOutPrsn);
			UniAppManager.app.processParams(params);
					if(params && params.INOUT_DATE){
						masterGrid.getStore().loadStoreRecords();				
					}
	/*		mtr111skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
					
				}
			});
	*/		
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {  
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('excel',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        processParams: function(params) {
			this.uniOpt.appParams = params;		
			if(params && params.INOUT_DATE) {
				if(params.action == 'new') {
		//				alert('assd')
					panelSearch.setValue('INOUT_FR_DATE', params.INOUT_DATE);
					panelSearch.setValue('INOUT_TO_DATE', params.INOUT_DATE);
					panelResult.setValue('INOUT_FR_DATE', params.INOUT_DATE);
					panelResult.setValue('INOUT_TO_DATE', params.INOUT_DATE);
					
					panelSearch.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelSearch.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelResult.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelSearch.setValue('DIV_CODE', params.DIV_CODE);
					panelResult.setValue('DIV_CODE', params.DIV_CODE);
					panelSearch.setValue('DEPT_CODE', params.DEPT_CODE);
					panelResult.setValue('DEPT_CODE', params.DEPT_CODE);
					panelSearch.setValue('DEPT_NAME', params.DEPT_NAME);
					panelResult.setValue('DEPT_NAME', params.DEPT_NAME);
					panelSearch.setValue('WH_CODE', params.WH_CODE);
					panelResult.setValue('WH_CODE', params.WH_CODE);
					panelSearch.setValue('INOUT_PRSN','');
					panelResult.setValue('INOUT_PRSN','');
				}
			}
		}
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});//End of Unilite.Main( {
};


</script>