<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="ssa101ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa101ukrv"  /> 		   		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>		<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" />   	<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/> 		<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S007"/> 		<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A"/>			<!-- 출고창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />   	<!-- 판매단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/> 		<!-- 과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S003"/> 		<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B035"/>		<!-- 수불타입 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>   	<!-- 세액포함여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S014"/> 		<!-- 매출대상 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/> 		<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B116"/>		<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S065"/>   	<!-- 주문구분 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">
var SearchInfoWindow;	// SearchInfoWindow : 검색창
var referSalesOrderWindow;	// 수주참조
var referIssueWindow; // 출고(미매출)/반품출고참조

var BsaCodeInfo = {	
	gsCreditYn: '${gsCreditYn}',
	gsAutoType: '${gsAutoType}',
	gsMoneyUnit: '${gsMoneyUnit}',
	gsVatRate: 	${gsVatRate},
	gsInvStatus: '${gsInvStatus}',
	gsOptDivCode: '${gsOptDivCode}',
	gsProcessFlag: '${gsProcessFlag}',
	gsBusiPrintYN: '${gsBusiPrintYN}',
	gsBusiPrintPgm: '${gsBusiPrintPgm}',
	gsMoneyExYn: '${gsMoneyExYn}',
	gsAdvanUseYn: '${gsAdvanUseYn}',
	gsPointYn: '${gsPointYn}',
	gsUnitChack: '${gsUnitChack}',
	gsPriceGubun: '${gsPriceGubun}',
	gsWeight: '${gsWeight}',
	gsVolume: '${gsVolume}',
	gsCustManageYN: '${gsCustManageYN}',
	gsPrsnManageYN: '${gsPrsnManageYN}'
};

var CustomCodeInfo = {	
	gsAgentType : '',    
	gsCustCreditYn : '', 
	gsUnderCalBase : '', 
	gsTaxCalType : '',   
	gsRefTaxInout : ''
};

var gsTaxInout = '';
//var output ='';
//	for(var key in BsaCodeInfo){
//		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//	}
//Unilite.messageBox(output);
function appMain() {
	var isAutoBillNum = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoBillNum = true;
	}
	
	var isCustManageYN = false;			
	if(BsaCodeInfo.gsCustManageYN=='N')	{
		isCustManageYN = true;
	}
	
	var isPrsnManageYN = false;			
	if(BsaCodeInfo.gsPrsnManageYN=='N')	{
		isPrsnManageYN = true;
	}


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'ssa101ukrvService.selectDetailList',
			update: 'ssa101ukrvService.updateDetail',
			create: 'ssa101ukrvService.insertDetail',
			destroy: 'ssa101ukrvService.deleteDetail',
			syncAll: 'ssa101ukrvService.saveAll'
		}
	});	
	
  	//마스터 폼
	var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '매출정보',
        defaultType: 'uniSearchSubPanel',
	    items: [{	
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items: [{ 
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){	
							//여신액 구하기
							var divCode = newValue;
							var CustomCode = masterForm.getValue('SALE_CUSTOM_CODE');
							var saleDate = masterForm.getField('SALE_DATE').getSubmitValue()
							var moneyUnit = BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
						}
					}
				}
			}, 
				Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>',
					valueFieldName:'SALE_CUSTOM_CODE',
					
					allowBlank: false,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								CustomCodeInfo.gsAgentType    = records[0]["AGENT_TYPE"];   //거래처분류	
								CustomCodeInfo.gsCustCreditYn = records[0]["CREDIT_YN"];
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"]; //원미만계산
								CustomCodeInfo.gsTaxCalType   = records[0]["TAX_CALC_TYPE"];  
								CustomCodeInfo.gsRefTaxInout  = records[0]["TAX_TYPE"]; 	//세액포함여부	
								salesorderSearch.setValue('CUSTOM_CODE', masterForm.getValue('SALE_CUSTOM_CODE'));//수주참조에 SET
								salesorderSearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));//수주참조에 SET
								
								if(Ext.isEmpty(masterForm.getValue('MONEY_UNIT')) && !Ext.isEmpty(records[0]["MONEY_UNIT"])){
									masterForm.setValue('MONEY_UNIT', records[0]["MONEY_UNIT"]);
								}
								if(Ext.isEmpty(masterForm.getValue('SALE_PRSN')) && !Ext.isEmpty(records[0]["BUSI_PRSN"])){
									masterForm.setValue('SALE_PRSN', records[0]["BUSI_PRSN"]);
								}
								if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
									masterForm.setValue('TAX_TYPE', CustomCodeInfo.gsRefTaxInout)
								}
								
								if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){	
									//여신액 구하기
									var divCode = UserInfo.divCode;
									var CustomCode = masterForm.getValue('SALE_CUSTOM_CODE');
									var saleDate = masterForm.getField('SALE_DATE').getSubmitValue()
									var moneyUnit = BsaCodeInfo.gsMoneyUnit;
									//마스터폼에 여신액 set
									UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
								}
								
	                    	},
							scope: this
						},
						onClear: function(type)	{
							CustomCodeInfo.gsAgentType = '';
							CustomCodeInfo.gsCustCreditYn = '';
							CustomCodeInfo.gsUnderCalBase = '';
							CustomCodeInfo.gsTaxCalType = '';
							CustomCodeInfo.gsRefTaxInout = '';
							salesorderSearch.setValue('CUSTOM_CODE', '');//수주참조에 SET
							salesorderSearch.setValue('CUSTOM_NAME', '');//수주참조에 SET
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'SALE_PRSN',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010',
				allowBlank: false,
				holdable: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),				
				name: 'SALE_DATE',
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){	
							//여신액 구하기										
							var divCode = UserInfo.divCode;;
							var CustomCode = masterForm.getValue('SALE_CUSTOM_CODE');
							var saleDate = UniDate.getDbDateStr(newValue);
							var moneyUnit = BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
						}
					}
				}
			}]	
   		}, {
   			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
				name:'BILL_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S024',
				value: '10',
				allowBlank: false,
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
				name:'BILL_NUM', 	
				xtype: 'uniTextfield',
				readOnly: isAutoBillNum,
				allowBlank: isAutoBillNum,
				holdable: isAutoBillNum ? 'readOnly':'hold'
			},
				Unilite.popup('ITEM2',{	//카드 팝업?
				fieldLabel: '카드가맹점',
				
				validateBlank: false, 
				valueFieldName:'CARD_CUST_NM',
				textFieldName:'CARD_NM',
				readOnly: true,
				holdable: 'hold'
			}),{
				fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
				name:'PROJECT_NO', 	
				xtype: 'uniNumberfield'
			},{
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name:'ORDER_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S002',
				value: '10',
				allowBlank: false,
				holdable: 'hold'
			},{
				xtype: 'uniRadiogroup',		            		
				fieldLabel: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',	
				name:'TAX_TYPE',
				labelWidth: 90,
				comboType:'AU',
				comboCode:'B030',
				holdable: 'hold'
			},{
				fieldLabel: '<t:message code="system.label.sales.remarks" default="비고"/>',
				xtype:'textarea',
				name: 'REMARK',
				height: 50
			}, {
				fieldLabel: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>(1)',
				name:'TOT_SALE_TAX_O', 	
				xtype: 'uniNumberfield',
				value: 0,
				holdable: 'hold'
			}, {
				fieldLabel: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>(2)',
				name:'TOT_TAX_AMT', 	
				xtype: 'uniNumberfield',
				value: 0,
				holdable: 'hold'
			}, {
				fieldLabel: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>(3)',
				name:'TOT_SALE_EXP_O', 	
				xtype: 'uniNumberfield',
				value: 0,
				holdable: 'hold'
			}, {
				fieldLabel: '총액[(1)+(2)+(3)]',
				name:'TOT_AMT', 	
				xtype: 'uniNumberfield',
				value: 0,
				holdable: 'hold'
			}, {
				fieldLabel: '<t:message code="system.label.sales.exslipdate" default="결의전표일"/>',
				name:'', 	
				xtype: 'uniTextfield',
				holdable: 'hold'
			}, {
				fieldLabel: '<t:message code="system.label.sales.exslipno" default="결의전표번호"/>',
				name:'txtExNum', 	
				xtype: 'uniNumberfield',
				holdable: 'hold'
			}, {
				xtype: 'uniNumberfield',	
				name: 'EXCHG_RATE_O',	//환율,
				hidden: true
			}, {
				xtype: 'uniNumberfield',	//여신잔액
				name: 'TOT_REM_CREDIT_I',
				hidden: false
			}, {
				xtype: 'uniTextfield',	//화폐단위
				name: 'MONEY_UNIT',
				hidden: false
			}, {
				xtype: 'uniNumberfield',
				name: 'EXCHG_AMT_I',		//환율
				hidden: true
			}, {
				xtype: 'hiddenfield',
				name: 'CARD_CUST_CD'	//카드가맹점			
			}, {
				xtype: 'hiddenfield',
				name: 'TAX_TYPE'				
			}]
		}/*, {	
			title:' ',
        	defaultType: 'uniTextfield',
        	id: 'search_panel3',
        	itemId:'search_panel3',
        	layout: {type: 'uniTable', columns: 1},
			items:[]
		}*/],
		api: {
			load: 'ssa101ukrvService.selectMaster',
			submit: 'ssa101ukrvService.syncMaster'				
		},		
		listeners: {			
			uniOnChange: function(basicForm, dirty, eOpts) {				
				UniAppManager.setToolbarButtons('save', true);
			}
		},
// fnCreditCheck: function() {
// if(BsaCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
// if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
// Unilite.messageBox('<t:message code="unilite.msg.sMS284" default="해당 업체에 대한 여신액이 부족합니다.
// 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
// return false;
// }
// }
// return true;
// },
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
					//this.mask();
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
				//this.unmask();
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
	});// End of var masterForm = Unilite.createSearchForm('searchForm', {

	//마스터 모델
	Unilite.defineModel('Ssa101ukrvModel', {
		fields: [
			{name: 'BILL_SEQ'          		, text: '<t:message code="system.label.sales.seq" default="순번"/>'    				, type: 'int'},
			{name: 'INOUT_TYPE_DETAIL' 		, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>' 			   	, type: 'string',comboType:'AU', comboCode: 'S007'}, 
			{name: 'OUT_DIV_CODE'      		, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'  			, type: 'string', comboType: 'BOR120'}, 
			{name: 'WH_CODE'           		, text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'   			, type: 'string', comboType: 'OU'}, 
			{name: 'ITEM_CODE'         		, text: '<t:message code="system.label.sales.item" default="품목"/>' 			   	, type: 'string'},
			{name: 'ITEM_NAME'         		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'   			 	, type: 'string'}, 
			{name: 'SPEC'              		, text: '<t:message code="system.label.sales.spec" default="규격"/>'    				, type: 'string'}, 
			{name: 'SALE_UNIT'         		, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'  			, type: 'string'}, 
			{name: 'PRICE_TYPE'			 	, text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'  			, type: 'string'}, 	
			{name: 'TRANS_RATE'        		, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'    				, type: 'string'}, 
			{name: 'SALE_Q'            		, text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'    			, type: 'uniQty'}, 
			{name: 'SALE_P'            		, text: '<t:message code="system.label.sales.price" default="단가"/>'    				, type: 'uniUnitPrice'},	
			{name: 'SALE_WGT_Q'			 	, text: '매출량(중량)'  		, type: 'uniQty'}, 
			{name: 'SALE_FOR_WGT_P'		 	, text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'    		, type: 'uniUnitPrice'}, 
			{name: 'SALE_VOL_Q'			 	, text: '매출량(부피)'    		, type: 'uniQty'}, 
			{name: 'SALE_FOR_VOL_P'		 	, text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'    		, type: 'uniUnitPrice'}, 
			{name: 'SALE_WGT_P'			 	, text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'   	 	, type: 'uniQty'}, 
			{name: 'SALE_VOL_P'			 	, text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'   		, type: 'uniUnitPrice'}, 
			{name: 'SALE_AMT_O'        		, text: '<t:message code="system.label.sales.amount" default="금액"/>'    				, type: 'uniPrice'}, 
			{name: 'TAX_TYPE'          		, text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'    			, type: 'string'}, 
			{name: 'TAX_AMT_O'         		, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'    			, type: 'uniPrice'}, 
			{name: 'ORDER_O_TAX_O'     		, text: '<t:message code="system.label.sales.salestotal" default="매출계"/>'    			, type: 'string'},	
			{name: 'WGT_UNIT'			 	, text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'    			, type: 'string'}, 
			{name: 'UNIT_WGT'			 	, text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'    			, type: 'uniQty'}, 
			{name: 'VOL_UNIT'			 	, text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'    			, type: 'string'}, 
			{name: 'UNIT_VOL'			 	, text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'    			, type: 'string'}, 
			{name: 'DISCOUNT_RATE'     		, text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'   		 	, type: 'string'}, 
			{name: 'STOCK_Q'             	, text: '<t:message code="system.label.sales.inventoryqty" default="재고량"/>'    			, type: 'uniQty'}, 
			{name: 'DVRY_CUST_CD'      		, text: '<t:message code="system.label.sales.deliveryplacecode" default="배송처코드"/>'   			, type: 'string'}, 
			{name: 'DVRY_CUST_NAME'    		, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'    			, type: 'string'}, 
			{name: 'PRICE_YN'          		, text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'    			, type: 'string'}, 
			{name: 'LOT_NO'            		, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'   			 	, type: 'string'}, 
			{name: 'INOUT_NUM'         		, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'  			, type: 'string'}, 
			{name: 'INOUT_SEQ'         		, text: '<t:message code="system.label.sales.issueseq" default="출고순번"/>'    			, type: 'string'}, 
			{name: 'INOUT_DATE'        		, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'    			, type: 'string'}, 
			{name: 'ORDER_NUM'         		, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'   			, type: 'string'}, 
			{name: 'PUB_NUM'           		, text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'    		, type: 'string'}, 
			{name: 'DIV_CODE'            	, text: 'DIV_CODE'    			, type: 'string'}, 
			{name: 'BILL_NUM'            	, text: 'BILL_NUM'    			, type: 'string'}, 
			{name: 'SALE_LOC_AMT_I'      	, text: 'SALE_LOC_AMT_I'    	, type: 'string'}, 
			{name: 'INOUT_TYPE'          	, text: 'INOUT_TYPE'    		, type: 'string'}, 
			{name: 'SER_NO'              	, text: 'SER_NO'    			, type: 'string'}, 
			{name: 'STOCK_UNIT'          	, text: 'STOCK_UNIT'    		, type: 'string'}, 
			{name: 'ITEM_STATUS'         	, text: 'ITEM_STATUS'    		, type: 'string'}, 
			{name: 'ACCOUNT_YNC'         	, text: 'ACCOUNT_YNC'    		, type: 'string'}, 
			{name: 'ORIGIN_Q'            	, text: 'ORIGIN_Q'    			, type: 'string'}, 
			{name: 'REF_SALE_PRSN'       	, text: 'REF_SALE_PRSN'    		, type: 'string'}, 
			{name: 'REF_CUSTOM_CODE'     	, text: 'REF_CUSTOM_CODE'    	, type: 'string'}, 
			{name: 'REF_SALE_DATE'       	, text: 'REF_SALE_DATE'    		, type: 'string'}, 
			{name: 'REF_BILL_TYPE'       	, text: 'REF_BILL_TYPE'    		, type: 'string'}, 
			{name: 'REF_CARD_CUST_CD'    	, text: 'REF_CARD_CUST_CD'    	, type: 'string'}, 
			{name: 'REF_SALE_TYPE'       	, text: 'REF_SALE_TYPE'    		, type: 'string'}, 
			{name: 'REF_PROJECT_NO'      	, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'    		, type: 'string'}, 
			{name: 'REF_TAX_INOUT'       	, text: 'REF_TAX_INOUT'    		, type: 'string'}, 
			{name: 'REF_REMARK'          	, text: 'REF_REMARK'    		, type: 'string'}, 
			{name: 'REF_EX_NUM'          	, text: 'REF_EX_NUM'    		, type: 'string'}, 
			{name: 'REF_MONEY_UNIT'      	, text: 'REF_MONEY_UNIT'    	, type: 'string'}, 
			{name: 'REF_EXCHG_RATE_O'    	, text: 'REF_EXCHG_RATE_O'    	, type: 'string'}, 
			{name: 'STOCK_CARE_YN'       	, text: 'STOCK_CARE_YN'    		, type: 'string'}, 
			{name: 'UNSALE_Q'            	, text: 'UNSALE_Q'    			, type: 'string'}, 
			{name: 'UPDATE_DB_USER'      	, text: 'UPDATE_DB_USER'    	, type: 'string'}, 
			{name: 'UPDATE_DB_TIME'      	, text: 'UPDATE_DB_TIME'    	, type: 'string'}, 
			{name: 'DATA_REF_FLAG'       	, text: 'DATA_REF_FLAG'    		, type: 'string'}, 
			{name: 'SRC_CUSTOM_CODE'     	, text: 'SRC_CUSTOM_CODE'    	, type: 'string'}, 
			{name: 'SRC_CUSTOM_NAME'     	, text: 'SRC_CUSTOM_NAME'    	, type: 'string'}, 
			{name: 'SRC_ORDER_PRSN'      	, text: 'SRC_ORDER_PRSN'    	, type: 'string'}, 
			{name: 'REF_CODE2'           	, text: 'REF_CODE2'    			, type: 'string'}, 
			{name: 'SOF110T_ACCOUNT_YNC' 	, text: 'SOF110T_ACCOUNT_YNC'   , type: 'string'}, 
			{name: 'COMP_CODE'           	, text: 'COMP_CODE'    			, type: 'string'}, 
			{name: 'INOUT_CUSTOM_CODE'   	, text: 'INOUT_CUSTOM_CODE'    	, type: 'string'}, 
			{name: 'INOUT_CUSTOM_NAME'   	, text: 'INOUT_CUSTOM_NAME'    	, type: 'string'}, 
			{name: 'INOUT_AGENT_TYPE'    	, text: 'INOUT_AGENT_TYPE'    	, type: 'string'}, 
			{name: 'ADVAN_YN'            	, text: 'ADVAN_YN'    			, type: 'string'}, 
			{name: 'GUBUN'               	, text: 'GUBUN'    				, type: 'string'}
		]
	});// End of Unilite.defineModel('Ssa101ukrvModel', {
	
	// 마스터 스토어 정의
	var detailStore = Unilite.createStore('ssa101ukrvDetailStore', {
		model: 'Ssa101ukrvModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},

		/*
		 * syncAll 수정 proxy: { type: 'direct', api: { read:
		 * 'ssa101ukrvService.selectDetailList', update:
		 * 'ssa101ukrvService.updateDetail', create:
		 * 'ssa101ukrvService.insertDetail', destroy:
		 * 'ssa101ukrvService.deleteDetail', syncAll:
		 * 'ssa101ukrvService.syncAll' } },
		 */

		proxy: directProxy,
		listeners: {
           	load: function(store, records, successful, eOpts) {
//           		this.fnOrderAmtSum();
           	},
           	add: function(store, records, index, eOpts) {
//           		this.fnOrderAmtSum();
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
//           		this.fnOrderAmtSum();
           	},
           	remove: function(store, record, index, isMove, eOpts) {
//           		this.fnOrderAmtSum();
           	}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
			console.log(param);
			this.load({
				params : param
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

			var orderNum = masterForm.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			// 1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	// syncAll 수정
			
			if(inValidRecs.length == 0) {
				// if(config==null) {
					/*
					 * syncAll 수정 config = { success: function() {
					 * detailForm.getForm().wasDirty = false;
					 * detailForm.resetDirtyStatus(); console.log("set was dirty
					 * to false"); UniAppManager.setToolbarButtons('save',
					 * false); } };
					 */
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								// 2.마스터 정보(Server 측 처리 시 가공)
								var master = batch.operations[0].getResultSet();
								masterForm.setValue("ORDER_NUM", master.ORDER_NUM);
								
								// 3.기타 처리
								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);		

							 } 
					};
				// }
				// this.syncAll(config);
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('ssa101ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
			}
		},
		fnOrderAmtSum: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sumOrder = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
			var sumTax = Ext.isNumeric(this.sum('ORDER_TAX_O')) ? this.sum('ORDER_TAX_O'):0;
			var sumTot = sumOrder+sumTax;
			masterForm.setValue('ORDER_O',sumOrder);
			masterForm.setValue('ORDER_TAX_O',sumTax);
			masterForm.setValue('TOT_ORDER_AMT',sumTot);
			masterForm.fnCreditCheck()
		}
	});
	
	// 마스터 그리드
	var masterGrid = Unilite.createGrid('ssa101ukrvGrid1', {
       // for tab
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'orderTool',
			text: '<t:message code="system.label.sales.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'salesorderBtn',
					text: '<t:message code="system.label.sales.sorefer" default="수주참조"/>',
					handler: function() {
						openSalesOrderWindow();
						}
				},{
					itemId: 'issueBtn',
					text: '<t:message code="system.label.sales.issuereturnrefer" default="출고(미매출)/반품출고참조"/>',
					handler: function() {
						openIssueWindow();
						}
				}]
			})
		}],
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: detailStore,
		columns: [
			{dataIndex: 'BILL_SEQ'          	,		 width: 40	},
			{dataIndex: 'INOUT_TYPE_DETAIL' 	,		 width: 66	},
			{dataIndex: 'OUT_DIV_CODE'      	,		 width: 150	},
			{dataIndex: 'WH_CODE'           	,		 width: 120	},
			{dataIndex: 'ITEM_CODE'         	,		 width: 113	},
			{dataIndex: 'ITEM_NAME'         	,		 width: 126	},
			{dataIndex: 'SPEC'              	,		 width: 133	},
			{dataIndex: 'SALE_UNIT'         	,		 width: 66	},
			{dataIndex: 'PRICE_TYPE'			,		 width: 93	},
			{dataIndex: 'TRANS_RATE'        	,		 width: 73	},
			{dataIndex: 'SALE_Q'            	,		 width: 93	},
			{dataIndex: 'SALE_P'            	,		 width: 86	},
			{dataIndex: 'SALE_WGT_Q'			,		 width: 106	},
			{dataIndex: 'SALE_FOR_WGT_P'		,		 width: 106	},
			{dataIndex: 'SALE_VOL_Q'			,		 width: 106	},
			{dataIndex: 'SALE_FOR_VOL_P'		,		 width: 106	},
			{dataIndex: 'SALE_WGT_P'			,		 width: 106, hidden: true	},
			{dataIndex: 'SALE_VOL_P'			,		 width: 106, hidden: true	},
			{dataIndex: 'SALE_AMT_O'        	,		 width: 66	},
			{dataIndex: 'TAX_TYPE'          	,		 width: 66	},
			{dataIndex: 'TAX_AMT_O'         	,		 width: 66	},
			{dataIndex: 'ORDER_O_TAX_O'     	,		 width: 66	},
			{dataIndex: 'WGT_UNIT'			 	,		 width: 100	},
			{dataIndex: 'UNIT_WGT'			 	,		 width: 80	},
			{dataIndex: 'VOL_UNIT'			 	,		 width: 93	},
			{dataIndex: 'UNIT_VOL'			 	,		 width: 100	},
			{dataIndex: 'DISCOUNT_RATE'     	,		 width: 66	},
			{dataIndex: 'STOCK_Q'             	,		 width: 66	},
			{dataIndex: 'DVRY_CUST_CD'      	,		 width: 113, hidden: true	},
			{dataIndex: 'DVRY_CUST_NAME'    	,		 width: 113	},
			{dataIndex: 'PRICE_YN'          	,		 width: 66	},
			{dataIndex: 'LOT_NO'            	,		 width: 100	},
			{dataIndex: 'INOUT_NUM'         	,		 width: 100	},
			{dataIndex: 'INOUT_SEQ'         	,		 width: 60	},
			{dataIndex: 'INOUT_DATE'        	,		 width: 80	},
			{dataIndex: 'ORDER_NUM'         	,		 width: 100	},
			{dataIndex: 'PUB_NUM'           	,		 width: 100	},
			{dataIndex: 'DIV_CODE'            	,		 width: 66, hidden: true},
			{dataIndex: 'BILL_NUM'            	,		 width: 66, hidden: true	},
			{dataIndex: 'SALE_LOC_AMT_I'      	,		 width: 66, hidden: true	},
			{dataIndex: 'INOUT_TYPE'          	,		 width: 66, hidden: true	},
			{dataIndex: 'SER_NO'              	,		 width: 66, hidden: true	},
			{dataIndex: 'STOCK_UNIT'          	,		 width: 66, hidden: true	},
			{dataIndex: 'ITEM_STATUS'         	,		 width: 66, hidden: true	},
			{dataIndex: 'ACCOUNT_YNC'         	,		 width: 66, hidden: true	},
			{dataIndex: 'ORIGIN_Q'            	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_SALE_PRSN'       	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_CUSTOM_CODE'     	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_SALE_DATE'       	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_BILL_TYPE'       	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_CARD_CUST_CD'    	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_SALE_TYPE'       	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_PROJECT_NO'      	,		 width: 120	},
			{dataIndex: 'REF_TAX_INOUT'       	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_REMARK'          	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_EX_NUM'          	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_MONEY_UNIT'      	,		 width: 66, hidden: true	},
			{dataIndex: 'REF_EXCHG_RATE_O'    	,		 width: 66, hidden: true	},
			{dataIndex: 'STOCK_CARE_YN'       	,		 width: 66, hidden: true	},
			{dataIndex: 'UNSALE_Q'            	,		 width: 66, hidden: true	},
			{dataIndex: 'UPDATE_DB_USER'      	,		 width: 66, hidden: true	},
			{dataIndex: 'UPDATE_DB_TIME'      	,		 width: 66, hidden: true	},
			{dataIndex: 'DATA_REF_FLAG'       	,		 width: 66, hidden: true	},
			{dataIndex: 'SRC_CUSTOM_CODE'     	,		 width: 86, hidden: isCustManageYN	},
			{dataIndex: 'SRC_CUSTOM_NAME'     	,		 width: 133, hidden: isCustManageYN	},
			{dataIndex: 'SRC_ORDER_PRSN'      	,		 width: 100, hidden: isPrsnManageYN	},
			{dataIndex: 'REF_CODE2'           	,		 width: 66, hidden: true	},
			{dataIndex: 'SOF110T_ACCOUNT_YNC' 	,		 width: 66, hidden: true	},
			{dataIndex: 'COMP_CODE'           	,		 width: 66, hidden: true	},
			{dataIndex: 'INOUT_CUSTOM_CODE'   	,		 width: 66, hidden: true	},
			{dataIndex: 'INOUT_CUSTOM_NAME'   	,		 width: 66, hidden: true	},
			{dataIndex: 'INOUT_AGENT_TYPE'    	,		 width: 66, hidden: true	},
			{dataIndex: 'ADVAN_YN'            	,		 width: 66, hidden: true	},
			{dataIndex: 'GUBUN'               	,		 width: 66, hidden: true	}			
		],
		listeners: {	
          		
       	},
		disabledLinkButtons: function(b) {
       		this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
       		this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear) {
       		var grdRecord = this.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		,"");
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
				grdRecord.set('UNIT_VOL'		,0);
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				// grdRecord.set('OUT_DIV_CODE' ,record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
				
				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       		}
		},
		setEstiData:function(record) {
       		var grdRecord = this.getSelectedRecord();
       
       		// grdRecord.set('DIV_CODE' , record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);	
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);	
			grdRecord.set('SPEC'				, record['SPEC']);	
			grdRecord.set('ORDER_UNIT'			, record['ESTI_UNIT']);	
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);	
			grdRecord.set('ORDER_Q'				, record['ESTI_QTY']);	
			grdRecord.set('ORDER_P'				, record['ESTI_PRICE']);	
			grdRecord.set('SCM_FLAG_YN'			, 'N');	
			if(masterForm.getValue('TAX_TYPE') != 50)	
			{
				grdRecord.set('TAX_TYPE'		,masterForm.getValue('TAX_TYPE').TAX_TYPE);	
			}
			if(Ext.isEmpty(masterForm.getValue('DVRY_DATE')))	{
				
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('SALE_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);	
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);	
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);	
			grdRecord.set('OUT_DIV_CODE'		, UserInfo.divCode);	
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);	
			grdRecord.set('ACCOUNT_YNC'			, 'Y');	
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('SALE_CUST_CD'));
			}
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('SALE_CUST_NM'));
			}
			grdRecord.set('PROD_PLAN_Q'			, 0);	
			grdRecord.set('ESTI_NUM'			, record['ESTI_NUM']);	
			grdRecord.set('ESTI_SEQ'			, record['ESTI_SEQ']);	
			grdRecord.set('REF_ORDER_DATE'		, masterForm.getValue('SALE_DATE'));	
			grdRecord.set('REF_ORD_CUST'		, masterForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('REF_ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, masterForm.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, masterForm.getValue('TAX_TYPE').TAX_TYPE);
			// FIXME gsExchageRate값 설정
			// grdRecord.set('REF_EXCHG_RATE_O' ,gsExchageRate);
			grdRecord.set('REF_REMARK'			, masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ESTI_QTY']);	
			grdRecord.set('REF_BILL_TYPE'		, masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_METH'));	
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);	
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);	
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);	
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);

			UniSales.fnGetPriceInfo(grdRecord
									,'R'
									,UserInfo.compCode
									,masterForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ESTI_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,masterForm.getValue('SALE_DATE')
									,grdRecord.get('ORDER_Q')
									,record['WGT_UNIT']
									,record['VOL_UNIT']
									,record['UNIT_WGT']
									,record['UNIT_VOL']
									,record['PRICE_TYPE']
									);
			
			// 수주수량/단가(중량) 재계산
			var	sUnitWgt   = grdRecord.get('UNIT_WGT');
			var	sOrderWgtQ = grdRecord.set('ORDER_WGT_Q', (grdRecord.get('ORDER_Q') * sUnitWgt));
			
			if( sUnitWgt == 0)	{ 
				grdRecord.set('ORDER_WGT_P'		,0);
			} else {
				grdRecord.set('ORDER_WGT_P', (grdRecord.get('ORDER_P') / sUnitWgt))
			}
			
			// 수주수량/단가(부피) 재계산
			var	sUnitVol   = grdRecord.get('UNIT_VOL');
			var	sOrderVolQ = grdRecord.set('ORDER_VOL_Q', (grdRecord.get('ORDER_Q') * sUnitVol));
			
			if( sUnitVol == 0)	{ 
				grdRecord.set('ORDER_VOL_P'		,0);
			} else {
				grdRecord.set('ORDER_VOL_P', (grdRecord.get('ORDER_P') / sUnitVol))
			}
			
			/*
			 * 
			 * Call top.fraBody1.fnOrderAmtCal(lRow, "Q") Call
			 * top.fraBody1.fnStockQ(lRow) //현재고량 조회
			 */
			
			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = grdRecord.get('TRANS_RATE');
			
			if(!Ext.isEmpty(grdRecord.get('STOCK_Q')))	{
				dStockQ = grdRecord.get('STOCK_Q');
			}
			
			if(!Ext.isEmpty(grdRecord.get('ORDER_Q')))	{
				dOrderQ = grdRecord.get('ORDER_Q');
			}
			
			if(dStockQ > 0 )	{
				if(dStockQ > dOrderQ)	{	// '재고량 > 수주량
					grdRecord.set('PROD_SALE_Q'		,0);	
					grdRecord.set('PROD_Q'		,0);	
					grdRecord.set('PROD_END_DATE'		,'');	
				} else {
					if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate - dStockQ ) );	
							grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
						}
					}
				}
			}else {
				if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,dOrderQ);	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate ) );	

						}
					}
			}
			
		
		},
		setRefData: function(record) {
       		var grdRecord = this.getSelectedRecord();
       
       		grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);	
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);	
			grdRecord.set('SPEC'				, record['SPEC']);	
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);	
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);	
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);	
			grdRecord.set('ORDER_P'				, record['ORDER_P']);	
			grdRecord.set('SCM_FLAG_YN'			, 'N');	
			
			if(masterForm.getValue('TAX_TYPE') != 50)	
			{
				grdRecord.set('TAX_TYPE'		,record['TAX_TYPE']);	
			}
			if(Ext.isEmpty(masterForm.getValue('DVRY_DATE')))	{
				
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('SALE_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);	
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);	
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);	
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);	
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);	
			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);	
			
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('SALE_CUST_CD'));
			}
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('SALE_CUST_NM'));
			}			
			
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);	
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);	
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('PROD_PLAN_Q'			, 0);	
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('PRE_ACCNT_YN'		, record['PRE_ACCNT_YN']);
			grdRecord.set('REF_ORDER_DATE'		, masterForm.getValue('SALE_DATE'));	
			grdRecord.set('REF_ORD_CUST'		, masterForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('REF_ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, masterForm.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, masterForm.getValue('TAX_TYPE').TAX_TYPE);
			// FIXME gsExchageRate값 설정
			// grdRecord.set('REF_EXCHG_RATE_O' ,gsExchageRate);
			grdRecord.set('REF_REMARK'			, masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ORDER_Q']);	
			grdRecord.set('REF_BILL_TYPE'		, masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_METH'));	
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);	
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);	
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);	
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			
			UniSales.fnGetPriceInfo(grdRecord
									,'R'
									,UserInfo.compCode
									,masterForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ORDER_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,masterForm.getValue('SALE_DATE')
									,grdRecord.get('ORDER_Q')
									,grdRecord.get('WGT_UNIT')
									,grdRecord.get('VOL_UNIT')
									,grdRecord.get('UNIT_WGT')
									,grdRecord.get('UNIT_VOL')
									,grdRecord.get('PRICE_TYPE')
									);

			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			UniSales.fnStockQ(grdRecord, UserInfo.compCode, record['OUT_DIV_CODE'], null,record['ITEM_CODE'],record['WH_CODE'])	;				
			// FIXME fnStockQ가 실행 후 STOCK_Q 값을 가져온 후 아래 로직을 실행해야 함..
			
			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = grdRecord.get('TRANS_RATE');
			
			if(!Ext.isEmpty(grdRecord.get('STOCK_Q')))	{
				dStockQ = grdRecord.get('STOCK_Q');
			}
			
			if(!Ext.isEmpty(grdRecord.get('ORDER_Q')))	{
				dOrderQ = grdRecord.get('ORDER_Q');
			}
			
			if(dStockQ > 0 )	{
				if(dStockQ > dOrderQ)	{	// '재고량 > 수주량
					grdRecord.set('PROD_SALE_Q'		,0);	
					grdRecord.set('PROD_Q'		,0);	
					grdRecord.set('PROD_END_DATE'		,'');	
				} else {
					if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate - dStockQ ) );	
							grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
						}
					}
				}
			}else {
				if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,dOrderQ);	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate ) );	

						}
					}
			}
			
			
       }

	});// End of var masterGrid = Unilite.createGrid('ssa101ukrvGrid1', {

	//검색창 폼
	var salesNoSearch = Unilite.createSearchForm('salesNoSearchForm', {		
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [
			{
		    	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
		    	name: 'DIV_CODE',
		    	xtype:'uniCombobox',
		    	comboType:'BOR120',
		    	value:UserInfo.divCode,
		    	allowBlank:false,
		    	colspan: 2
		    },	    
				Unilite.popup('AGENT_CUST',{
				fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
				validateBlank: false
			}),{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				width: 350	    
			}, {
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'		,
				name: 'SALE_PRSN',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S010'
			}, {
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		,
				name: 'ORDER_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S002'
			}, {
				fieldLabel: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'		,
				name: 'BILL_TYPE',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'S024',
				value: '10'
			}, {
				fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
				xtype: 'uniTextfield',
				name:'PROJECT_NO',
				width:315
			}, {
				fieldLabel: '<t:message code="system.label.sales.issueno" default="출고번호"/>',
				xtype: 'uniTextfield',
				name:'INOUT_NUM',
				width:315
			}, {
				fieldLabel: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
				xtype: 'uniTextfield',
				name:'BILL_NUM',
				width:315
			},
				Unilite.popup('DIV_PUMOK',{
			}),{
				fieldLabel: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>'	,
				xtype: 'uniRadiogroup',
				allowBlank: false,
				width: 235,
				name:'RDO_TYPE',
				items: [
					{boxLabel:'<t:message code="system.label.sales.master" default="마스터"/>', name:'RDO_TYPE', inputValue:'master', checked:true},
					{boxLabel:'<t:message code="system.label.sales.detail" default="디테일"/>', name:'RDO_TYPE', inputValue:'detail'}
				],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.RDO_TYPE=='detail')	{
							if(salesNoMasterGrid) salesNoMasterGrid.hide();
							if(salesNoDetailGrid) salesNoDetailGrid.show();
						} else {
							if(salesNoDetailGrid) salesNoDetailGrid.hide();
							if(salesNoMasterGrid) salesNoMasterGrid.show();
						}
					}
				}
			}]
    }); // createSearchForm
    
	//검색창 마스터 모델
	Unilite.defineModel('salesNoMasterModel', {
	    fields: [
	    	{name: 'DIV_CODE'         		, text: '<t:message code="system.label.sales.division" default="사업장"/>'    	, type: 'string', comboType: 'BOR120'},
	    	{name: 'SALE_CUSTOM_CODE' 		, text: '<t:message code="system.label.sales.client" default="고객"/>'    	    , type: 'string'},  
	    	{name: 'CUSTOM_NAME'      		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'    	, type: 'string'},  
	    	{name: 'ITEM_CODE'        		, text: '<t:message code="system.label.sales.item" default="품목"/>'    	    , type: 'string'},  
	    	{name: 'ITEM_NAME'        		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'    	    , type: 'string'},  
	    	{name: 'SALE_DATE'        		, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'    	, type: 'uniDate'},  
	    	{name: 'BILL_TYPE'        		, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'    , type: 'string', comboType: 'AU', comboCode: 'S024' },  
	    	{name: 'SALE_TYPE'        		, text: '<t:message code="system.label.sales.salesclass" default="매출구분"/>'  , type: 'string'},  
	    	{name: 'SALE_TYPE_NAME'   		, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'    	, type: 'string'},  
	    	{name: 'SALE_Q'           		, text: '<t:message code="system.label.sales.qty" default="수량"/>'    	    , type: 'uniQty'},  
	    	{name: 'SALE_TOT_O'       		, text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'    	, type: 'uniPrice'},  
	    	{name: 'SALE_LOC_AMT_I'   		, text: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>'    	, type: 'uniPrice'},  
	    	{name: 'SALE_LOC_EXP_I'   		, text: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>'    	, type: 'uniPrice'},  
	    	{name: 'TAX_AMT_O'        		, text: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>'    	, type: 'uniPrice'},  
	    	{name: 'SALE_PRSN'        		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'    	, type: 'string'},  
	    	{name: 'SALE_PRSN_NAME'   		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'    	, type: 'string'},  
	    	{name: 'BILL_NUM'         		, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'    	, type: 'string'},  
	    	{name: 'PROJECT_NO'       		, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'  , type: 'string'},  
	    	{name: 'INOUT_NUM'        		, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'    	, type: 'string'},
	    	
	    	/*거래처 정보*/
	    	{name: 'AGENT_TYPE'        		, text: 'AGENT_TYPE'    , type: 'string'},  
	    	{name: 'CREDIT_YN'   			, text: 'CREDIT_YN'    	, type: 'string'},  
	    	{name: 'WON_CALC_BAS'         	, text: 'WON_CALC_BAS'  , type: 'string'},  
	    	{name: 'TAX_CALC_TYPE'       	, text: 'TAX_CALC_TYPE' , type: 'string'},  
	    	{name: 'TAX_TYPE'        		, text: 'TAX_TYPE'    	, type: 'string'}
	    	
	    	
		]
	});
	
	//검색창 디테일 모델
	Unilite.defineModel('salesNoDetailModel', {
	    fields: [
	     	{name: 'DIV_CODE'         		, text: '<t:message code="system.label.sales.division" default="사업장"/>'    	, type: 'string', comboType: 'BOR120'},
	    	{name: 'SALE_CUSTOM_CODE' 		, text: '<t:message code="system.label.sales.client" default="고객"/>'    	    , type: 'string'},  
	    	{name: 'CUSTOM_NAME'      		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'    	, type: 'string'},  
	    	{name: 'ITEM_CODE'        		, text: '<t:message code="system.label.sales.item" default="품목"/>'    	    , type: 'string'},  
	    	{name: 'ITEM_NAME'        		, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'    	    , type: 'string'},  
	    	{name: 'SALE_DATE'        		, text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'    	, type: 'uniDate'},  
	    	{name: 'BILL_TYPE'        		, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'    , type: 'string', comboType: 'AU', comboCode: 'S024'},  
	    	{name: 'SALE_TYPE'        		, text: '<t:message code="system.label.sales.salesclass" default="매출구분"/>'  , type: 'string'},  
	    	{name: 'SALE_TYPE_NAME'   		, text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'    	, type: 'string'},  
	    	{name: 'SALE_Q'           		, text: '<t:message code="system.label.sales.qty" default="수량"/>'    	    , type: 'uniQty'},  
	    	{name: 'SALE_TOT_O'       		, text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'    	, type: 'uniPrice'},  
	    	{name: 'SALE_LOC_AMT_I'   		, text: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>'    	, type: 'uniPrice'},  
	    	{name: 'SALE_LOC_EXP_I'   		, text: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>'    	, type: 'uniPrice'},  
	    	{name: 'TAX_AMT_O'        		, text: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>'    	, type: 'uniPrice'},  
	    	{name: 'SALE_PRSN'        		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'    	, type: 'string'},  
	    	{name: 'SALE_PRSN_NAME'   		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'    	, type: 'string'},  
	    	{name: 'BILL_NUM'         		, text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'    	, type: 'string'},  
	    	{name: 'PROJECT_NO'       		, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'  , type: 'string'},  
	    	{name: 'INOUT_NUM'        		, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'    	, type: 'string'}	           
	    ]
	});

	// 검색 스토어(마스터)
	var salesNoMasterStore = Unilite.createStore('salesNoMasterStore', {
			model: 'salesNoMasterModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'ssa101ukrvService.selectSalesNumMasterList'
                }
            }
            ,loadStoreRecords : function()	{
				var param= salesNoSearch.getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
	// 검색 스토어(디테일)
	var salesNoDetailStore = Unilite.createStore('salesNoDetailStore', {
			model: 'salesNoDetailModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'ssa101ukrvService.selectSalesNumDetailList'
                }
            }
            ,loadStoreRecords : function()	{
				var param= salesNoSearch.getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
	// 검색창 그리드(마스터)
    var salesNoMasterGrid = Unilite.createGrid('ssa101ukrvSalesNoMasterGrid', {
        // title: '기본',
        layout : 'fit',       
		store: salesNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
        columns:  [ 
					 { dataIndex: 'DIV_CODE'         ,  width: 73},
					 { dataIndex: 'SALE_CUSTOM_CODE' ,  width: 100,hidden:true},
					 { dataIndex: 'CUSTOM_NAME'      ,  width: 100},
					 { dataIndex: 'ITEM_CODE'        ,  width: 100,hidden:true},
					 { dataIndex: 'ITEM_NAME'        ,  width: 166,hidden:true},
					 { dataIndex: 'SALE_DATE'        ,  width: 100},
					 { dataIndex: 'BILL_TYPE'        ,  width: 73},
					 { dataIndex: 'SALE_TYPE'        ,  width: 100,hidden:true},
					 { dataIndex: 'SALE_TYPE_NAME'   ,  width: 100},
					 { dataIndex: 'SALE_Q'           ,  width: 86},
					 { dataIndex: 'SALE_TOT_O'       ,  width: 86},
					 { dataIndex: 'SALE_LOC_AMT_I'   ,  width: 86},
					 { dataIndex: 'SALE_LOC_EXP_I'   ,  width: 80},
					 { dataIndex: 'TAX_AMT_O'        ,  width: 80},
					 { dataIndex: 'SALE_PRSN'        ,  width: 100,hidden:true},
					 { dataIndex: 'SALE_PRSN_NAME'   ,  width: 66},
					 { dataIndex: 'BILL_NUM'         ,  width: 120},
					 { dataIndex: 'PROJECT_NO'       ,  width: 86},
					 { dataIndex: 'INOUT_NUM'        ,  width: 100} 
					    
          ] ,
          listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
		          	salesNoMasterGrid.returnData(record);
		          	UniAppManager.app.onQueryButtonDown();
		          	SearchInfoWindow.hide();
	          }
          } // listeners
          ,returnData: function(record)	{
          	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	masterForm.setValues({'DIV_CODE':record.get('DIV_CODE'), 'BILL_NUM':record.get('BILL_NUM')});
          	
          	CustomCodeInfo.gsAgentType    = record.get("AGENT_TYPE");   //거래처분류	
			CustomCodeInfo.gsCustCreditYn = record.get("CREDIT_YN");
			CustomCodeInfo.gsUnderCalBase = record.get("WON_CALC_BAS"); //원미만계산
			CustomCodeInfo.gsTaxCalType   = record.get("TAX_CALC_TYPE");  
			CustomCodeInfo.gsRefTaxInout  = record.get("TAX_TYPE"); 	//세액포함여부
          }
    });
	// 검색창 그리드(디테일)
	var salesNoDetailGrid = Unilite.createGrid('ssa101ukrvSalesNoDetailGrid', {
        layout : 'fit',       
		store: salesNoDetailStore,
		uniOpt:{
					useRowNumberer: false
		},
		hidden : true,
        columns:  [ 
					 { dataIndex: 'DIV_CODE'         ,  width: 73},
					 { dataIndex: 'SALE_CUSTOM_CODE' ,  width: 100,hidden:true},
					 { dataIndex: 'CUSTOM_NAME'      ,  width: 100},
					 { dataIndex: 'ITEM_CODE'        ,  width: 120},
					 { dataIndex: 'ITEM_NAME'        ,  width: 166},
					 { dataIndex: 'SALE_DATE'        ,  width: 80},
					 { dataIndex: 'BILL_TYPE'        ,  width: 73},
					 { dataIndex: 'SALE_TYPE'        ,  width: 100,hidden:true},
					 { dataIndex: 'SALE_TYPE_NAME'   ,  width: 100},
					 { dataIndex: 'SALE_Q'           ,  width: 86},
					 { dataIndex: 'SALE_TOT_O'       ,  width: 86},
					 { dataIndex: 'SALE_LOC_AMT_I'   ,  width: 86},
					 { dataIndex: 'SALE_LOC_EXP_I'   ,  width: 80},
					 { dataIndex: 'TAX_AMT_O'        ,  width: 80},
					 { dataIndex: 'SALE_PRSN'        ,  width: 100,hidden:true},
					 { dataIndex: 'SALE_PRSN_NAME'   ,  width: 66},
					 { dataIndex: 'BILL_NUM'         ,  width: 120},
					 { dataIndex: 'PROJECT_NO'       ,  width: 86},
					 { dataIndex: 'INOUT_NUM'        ,  width: 100}
          ] ,
          listeners: {
	          onGridDblClick:function(grid, record, cellIndex, colName) {
		          	salesNoDetailGrid.returnData(record)
		          	UniAppManager.app.onQueryButtonDown();
		          	SearchInfoWindow.hide();
	          }
          } // listeners
          ,returnData: function(record)	{
          	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
          	}
          	masterForm.uniOpt.inLoading=true;
          	masterForm.setValues({'DIV_CODE':record.get('DIV_CODE'), 'BILL_NUM':record.get('BILL_NUM')});
    		masterForm.uniOpt.inLoading=false;
          }
    });
    
	//검색창 메인
    function openSearchInfoWindow() {			
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '매출번호검색',
                width: 830,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},	                
                items: [salesNoSearch, salesNoMasterGrid, salesNoDetailGrid],
                tbar:  ['->',
								        {	itemId : 'saveBtn',
											text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
											handler: function() {
												var rdoType = salesNoSearch.getValue('RDO_TYPE');
												console.log('rdoType : ',rdoType)
												if(rdoType.RDO_TYPE=='master')	{
													salesNoMasterStore.loadStoreRecords();
												}else {
													salesNoDetailStore.loadStoreRecords();
												}
											},
											disabled: false
										}, {
											itemId : 'SalesNoCloseBtn',
											text: '<t:message code="system.label.sales.close" default="닫기"/>',
											handler: function() {
												SearchInfoWindow.hide();
											},
											disabled: false
										}
							    ],
				listeners : {beforehide: function(me, eOpt)	{
											salesNoSearch.clearForm();
											salesNoMasterGrid.reset();
                							salesNoDetailGrid.reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											salesNoSearch.clearForm();
											salesNoMasterGrid.reset();
                							salesNoDetailGrid.reset();
                			 			},
                			 show: function( panel, eOpts )	{
								salesNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
                			 	salesNoSearch.setValue('SALE_DATE_FR',UniDate.get('startOfMonth', masterForm.getValue('SALE_DATE')));
                			 	salesNoSearch.setValue('SALE_DATE_TO',masterForm.getValue('SALE_DATE'));
                			 	salesNoSearch.setValue('CUSTOM_CODE',masterForm.getValue('SALE_CUSTOM_CODE'));
                			 	salesNoSearch.setValue('CUSTOM_NAME',masterForm.getValue('CUSTOM_NAME'));
                			 	salesNoSearch.setValue('SALE_PRSN',masterForm.getValue('SALE_PRSN'));
                			 	salesNoSearch.setValue('BILL_TYPE',masterForm.getValue('BILL_TYPE'));
                			 	salesNoSearch.setValue('ORDER_TYPE',masterForm.getValue('ORDER_TYPE'));
                			
                			 }
                }		
			})
		}
		SearchInfoWindow.show();
    }
    
	
	
	// 수주참조 폼
    var salesorderSearch = Unilite.createSearchForm('salesorderForm', {
        
            layout :  {type : 'uniTable', columns : 4},
            items :[
            	Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.salesorder" default="수주"/><t:message code="system.label.sales.client" default="고객"/>', 
					 
					validateBlank: false
				}),
			{
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_DVRY_DATE',
				endFieldName: 'TO_DVRY_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',						            		
				
				colspan:2,
				items: [{
					boxLabel: '별도', 
					width:60, 
					name: 'TAX_INOUT', 
					inputValue: '1', 
					checked: true
				},{
					boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>', 
					width:60, 
					name: 'TAX_INOUT', 
					inputValue: '2'
				}
			]},
				Unilite.popup('', { 
					fieldLabel: '<t:message code="system.label.sales.sono" default="수주번호"/>', 
					 
					validateBlank: false,
					name: 'ORDER_NUM'
				}),
			    Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
		        	
		        	listeners: {
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': salesorderSearch.getValue('DIV_CODE')});
						}
					}
			   }),
				Unilite.popup('', { 
					fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>', 
					 
					validateBlank: false,
					name: 'PROJECT_NO'
				}),
			{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010'
			}]
    });
	
	// 수주참조 모델
	Unilite.defineModel('ssa101ukrvSALESModel', {	
	    fields: [
			{name: 'CHOICE'							, text: '<t:message code="system.label.sales.selection" default="선택"/>'    		, type: 'string'},
			{name: 'ORDER_NUM'						, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'    	, type: 'string'},
			{name: 'SER_NO'							, text: '<t:message code="system.label.sales.seq" default="순번"/>'    		, type: 'string'},
			{name: 'SO_KIND'						, text: '<t:message code="system.label.sales.ordertype" default="주문구분"/>'    	, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'				, text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'    	, type: 'string'},
			{name: 'ITEM_CODE'						, text: '<t:message code="system.label.sales.item" default="품목"/>'    	, type: 'string'},
			{name: 'ITEM_NAME'						, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'    	, type: 'string'},
			{name: 'SPEC'							, text: '<t:message code="system.label.sales.spec" default="규격"/>'    		, type: 'string'},
			{name: 'ORDER_UNIT'						, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'    	, type: 'string', displayField: 'value'},
			{name: 'TRANS_RATE'						, text: '<t:message code="system.label.sales.containedqty" default="입수"/>'    		, type: 'string'},
			{name: 'DVRY_DATE'						, text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'    	, type: 'uniDate'},
			{name: 'NOT_SALE_Q'						, text: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>'    	, type: 'uniQty'},
			{name: 'ORDER_Q'						, text: '<t:message code="system.label.sales.soqty" default="수주량"/>'    	, type: 'uniQty'},
			{name: 'PROJECT_NO'						, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'  , type: 'string'},
			{name: 'CUSTOM_NAME'					, text: '<t:message code="system.label.sales.soplace" default="수주처"/>'    	, type: 'string'},
			{name: 'ORDER_PRSN'						, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'    	, type: 'string'},
			{name: 'PO_NUM'							, text: '<t:message code="system.label.sales.pono" default="PO번호"/>'    	, type: 'string'},
			{name: 'CUSTOM_CODE'					, text: 'CUSTOM_CODE'   , type: 'string'},
			{name: 'OUT_DIV_CODE'					, text: 'OUT_DIV_CODE'  , type: 'string'},
			{name: 'ORDER_P'						, text: 'ORDER_P'    	, type: 'string'},
			{name: 'ORDER_O'						, text: 'ORDER_O'    	, type: 'string'},
			{name: 'TAX_TYPE'						, text: 'TAX_TYPE'    	, type: 'string'},
			{name: 'WH_CODE'						, text: 'WH_CODE'    	, type: 'string'},
			{name: 'MONEY_UNIT'						, text: 'MONEY_UNIT'    , type: 'string'},
			{name: 'EXCHG_RATE_O'					, text: 'EXCHG_RATE_O'  , type: 'string'},
			{name: 'ACCOUNT_YNC'					, text: '<t:message code="system.label.sales.salessubjectyn" default="매출대상여부"/>'  , type: 'string'},
			{name: 'DISCOUNT_RATE'					, text: 'DISCOUNT_RATE' , type: 'string'},
			{name: 'DVRY_CUST_CD'					, text: 'DVRY_CUST_CD'  , type: 'string'},
			{name: 'BILL_TYPE'						, text: 'BILL_TYPE'     , type: 'string'},
			{name: 'ORDER_TYPE'						, text: 'ORDER_TYPE'    , type: 'string'},
			{name: 'PRICE_YN'						, text: 'PRICE_YN'    	, type: 'string'},
			{name: 'STOCK_CARE_YN'					, text: 'STOCK_CARE_YN' , type: 'string'},
			{name: 'STOCK_UNIT'						, text: 'STOCK_UNIT'    , type: 'string'},
			{name: 'DVRY_CUST_NAME'					, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'    	, type: 'string'},
			{name: 'TAX_INOUT'						, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'  , type: 'string'},
			{name: 'ORDER_TAX_O'					, text: 'ORDER_TAX_O'   , type: 'string'}
		]
	});
	
	// 수주참조 스토어
	var salesOrderStore = Unilite.createStore('ssa101ukrvSalesOrderStore', {
			model: 'ssa101ukrvSALESModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'ssa101ukrvService.selectSalesOrderList'                	
                }
            },
            listeners:{
            	load:function(store, records, successful, eOpts)	{
            			if(successful)	{
            			   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);  
            			   var estiRecords = new Array();
            			   
            			   if(masterRecords.items.length > 0)	{
            			   		console.log("store.items :", store.items);
            			   		console.log("records", records);
            			   	
	            			   	Ext.each(records, 
	            			   		function(item, i)	{           			   								
			   							Ext.each(masterRecords.items, function(record, i)	{
			   								console.log("record :", record);
			   							
			   									if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM']) 
			   											&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
			   									  ) 
			   									{
			   										estiRecords.push(item);
			   									}
			   							});		
	            			   	});
	            			   store.remove(estiRecords);
            			   }
            			}
            	}
            }
            ,loadStoreRecords : function()	{
				var param= salesorderSearch.getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	// 수주참조 그리드
    var salesorderGrid = Unilite.createGrid('ssa101ukrvSalesorderGrid', {
        // title: '기본',
        layout : 'fit',
    	store: salesOrderStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
        	onLoadSelectFirst : false
        },
        columns:  [  
					 { dataIndex: 'CHOICE'								,  width:33},
					 { dataIndex: 'ORDER_NUM'							,  width:93},
					 { dataIndex: 'SER_NO'								,  width:40},
					 { dataIndex: 'SO_KIND'								,  width:66},
					 { dataIndex: 'INOUT_TYPE_DETAIL'					,  width:80,hidden:true},
					 { dataIndex: 'ITEM_CODE'							,  width:100},
					 { dataIndex: 'ITEM_NAME'							,  width:113},
					 { dataIndex: 'SPEC'								,  width:113},
					 { dataIndex: 'ORDER_UNIT'							,  width:66},
					 { dataIndex: 'TRANS_RATE'							,  width:40},
					 { dataIndex: 'DVRY_DATE'							,  width:73},
					 { dataIndex: 'NOT_SALE_Q'							,  width:80},
					 { dataIndex: 'ORDER_Q'								,  width:80},
					 { dataIndex: 'PROJECT_NO'							,  width:86},
					 { dataIndex: 'CUSTOM_NAME'							,  width:100},
					 { dataIndex: 'ORDER_PRSN'							,  width:80},
					 { dataIndex: 'PO_NUM'								,  width:86},
					 { dataIndex: 'CUSTOM_CODE'							,  width:66,hidden:true},
					 { dataIndex: 'OUT_DIV_CODE'						,  width:66,hidden:true},
					 { dataIndex: 'ORDER_P'								,  width:66,hidden:true},
					 { dataIndex: 'ORDER_O'								,  width:66,hidden:true},
					 { dataIndex: 'TAX_TYPE'							,  width:66,hidden:true},
					 { dataIndex: 'WH_CODE'								,  width:66,hidden:true},
					 { dataIndex: 'MONEY_UNIT'							,  width:66,hidden:true},
					 { dataIndex: 'EXCHG_RATE_O'						,  width:66,hidden:true},
					 { dataIndex: 'ACCOUNT_YNC'							,  width:86},
					 { dataIndex: 'DISCOUNT_RATE'						,  width:66,hidden:true},
					 { dataIndex: 'DVRY_CUST_CD'						,  width:66,hidden:true},
					 { dataIndex: 'BILL_TYPE'							,  width:66,hidden:true},
					 { dataIndex: 'ORDER_TYPE'							,  width:66,hidden:true},
					 { dataIndex: 'PRICE_YN'							,  width:66,hidden:true},
					 { dataIndex: 'STOCK_CARE_YN'						,  width:66,hidden:true},
					 { dataIndex: 'STOCK_UNIT'							,  width:66,hidden:true},
					 { dataIndex: 'DVRY_CUST_NAME'						,  width:86},
					 { dataIndex: 'TAX_INOUT'							,  width:66},
					 { dataIndex: 'ORDER_TAX_O'							,  width:66,hidden:true}
          ] 
       ,listeners: {	
          		onGridDblClick:function(grid, record, cellIndex, colName) {
  					
  				}
       		}
       	,returnData: function()	{
       		var records = this.getSelectedRecords();
       		
			Ext.each(records, function(record,i){	
							        	UniAppManager.app.onNewDataButtonDown();
							        	detailGrid.setEstiData(record.data);								        
								    }); 
			this.deleteSelectedRow();
       	}
         
    });
	
	
	// 수주참조 메인
    function openSalesOrderWindow() {    		
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
  	
//  		salesorderSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));	
//  		salesorderSearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
  		salesorderSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', masterForm.getValue('SALE_DATE')) );
  		salesorderSearch.setValue('TO_ESTI_DATE', masterForm.getValue('SALE_DATE'));
  		salesorderSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));      		
  		salesOrderStore.loadStoreRecords(); 
  		
		if(!referSalesOrderWindow) {
			referSalesOrderWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.sales.sorefer" default="수주참조"/>',
                width: 830,				                
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [salesorderSearch, salesorderGrid],
                tbar:  ['->',
								        {	itemId : 'saveBtn',
											text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
											handler: function() {
												salesOrderStore.loadStoreRecords();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '<t:message code="system.label.sales.close" default="닫기"/>',
											handler: function() {
												referSalesOrderWindow.hide();
											},
											disabled: false
										}
							    ]
							,
                listeners : {beforehide: function(me, eOpt)	{
                							 salesorderSearch.clearForm();
                							 salesorderGrid.reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											 salesorderSearch.clearForm();
                							 salesorderGrid.reset();              			 			},
                			 beforeshow: function ( me, eOpts )	{
                			 	salesOrderStore.loadStoreRecords();
                			 }
                }
			})
		}
		
		referSalesOrderWindow.show();
    }
	
	
	 // 출고(미매출)/반품출고참조 폼
	var issueSearch = Unilite.createSearchForm('issueForm', {
        
            layout :  {type : 'uniTable', columns : 4},
            items :[
           	{
				fieldLabel: '<t:message code="system.label.sales.transdate" default="수불일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},
            	Unilite.popup('', { 
					fieldLabel: '<t:message code="system.label.sales.tranno" default="수불번호"/>', 
					 
					validateBlank: false,
					name: 'INOUT_NUM'
				}),
			{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>',						            		
				id: 'TAX_INOUT',
				colspan:2,
				items: [{
					boxLabel: '별도', 
					width:60, 
					name: 'TAX_INOUT', 
					inputValue: '1', 
					checked: true
				},{
					boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>', 
					width:60, 
					name: 'TAX_INOUT', 
					inputValue: '2'
				}
			]},
			    Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
		        	
		        	listeners: {
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': issueSearch.getValue('DIV_CODE')});
						}
					}
			   }),
				Unilite.popup('', { 
					fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>', 
					 
					validateBlank: false,
					name: 'PROJECT_NO'
				}),
			{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.sales.tranyn" default="수불여부"/>',						            		
				id: 'INOUT_TYPE',
				items: [{
					boxLabel: '<t:message code="system.label.sales.issue" default="출고"/>', 
					width:60, 
					name: 'INOUT_TYPE', 
					inputValue: 'I', 
					checked: true
				},{
					boxLabel: '<t:message code="system.label.sales.return" default="반품"/>', 
					width:60, 
					name: 'INOUT_TYPE', 
					inputValue: 'R'
				}
			]},{
				fieldLabel: '<t:message code="system.label.sales.issuecharger" default="출고담당"/>',
				name:'INOUT_PRSN',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010'
			}]
    });

	// 출고(미매출)/반품출고참조 모델
	Unilite.defineModel('ssa101ukrvISSUEModel', {	
	    fields: [
			{name: 'CHOICE'           					, text: '<t:message code="system.label.sales.selection" default="선택"/>'    			, type: 'string'},
			{name: 'ITEM_CODE'        					, text: '<t:message code="system.label.sales.item" default="품목"/>'    		, type: 'string'},
			{name: 'ITEM_NAME'        					, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'    		, type: 'string'},
			{name: 'SPEC'             					, text: '<t:message code="system.label.sales.spec" default="규격"/>'    			, type: 'string'},
			{name: 'ORDER_UNIT'       					, text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'    		, type: 'string', displayField: 'value'},
			{name: 'NOT_SALE_Q'       					, text: '<t:message code="system.label.sales.notbillingqty" default="미매출량"/>'    		, type: 'uniQty'},
			{name: 'ORDER_UNIT_Q'     					, text: '<t:message code="system.label.sales.tranqty" default="수불량"/>'    		, type: 'uniQty'},
			{name: 'INOUT_WGT_Q'	  					, text: '수불량(중량)'    	, type: 'uniQty'},
			{name: 'INOUT_VOL_Q'	  					, text: '수불량(부피)'    	, type: 'uniQty'},
			{name: 'ORDER_UNIT_P'     					, text: '<t:message code="system.label.sales.price" default="단가"/>'    			, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_O'     					, text: '<t:message code="system.label.sales.tranamount" default="수불금액"/>'    		, type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'    					, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'    		, type: 'uniPrice'},
			{name: 'PROJECT_NO'       					, text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'    	, type: 'string'},
			{name: 'INOUT_NUM'        					, text: '<t:message code="system.label.sales.tranno" default="수불번호"/>'    		, type: 'string'},
			{name: 'INOUT_SEQ'        					, text: '<t:message code="system.label.sales.seq" default="순번"/>'    			, type: 'string'},
			{name: 'INOUT_TYPE'       					, text: '<t:message code="system.label.sales.trantype1" default="수불타입"/>'    		, type: 'string'},
			{name: 'CUSTOM_NAME'      					, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'    		, type: 'string'},
			{name: 'DIV_CODE'         					, text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'    	, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'					, text: 'INOUT_TYPE_DETAIL' , type: 'string'},
			{name: 'WH_CODE'          					, text: 'WH_CODE'    		, type: 'string'},
			{name: 'TRNS_RATE'        					, text: 'TRNS_RATE'    		, type: 'string'},
			{name: 'MONEY_UNIT'       					, text: 'MONEY_UNIT'    	, type: 'string'},
			{name: 'EXCHG_RATE_O'     					, text: 'EXCHG_RATE_O'    	, type: 'string'},
			{name: 'ORDER_NUM'        					, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'    		, type: 'string'},
			{name: 'ORDER_SEQ'        					, text: '<t:message code="system.label.sales.soseq" default="수주순번"/>'    		, type: 'string'},
			{name: 'TAX_TYPE'         					, text: 'TAX_TYPE'    		, type: 'string'},
			{name: 'DVRY_CUST_CD'     					, text: 'DVRY_CUST_CD'    	, type: 'string'},
			{name: 'LOT_NO'           					, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'    		, type: 'string'},
			{name: 'PRICE_YN'         					, text: 'PRICE_YN'    		, type: 'string'},
			{name: 'DISCOUNT_RATE'    					, text: 'DISCOUNT_RATE'    	, type: 'string'},
			{name: 'STOCK_CARE_YN'    					, text: 'STOCK_CARE_YN'    	, type: 'string'},
			{name: 'STOCK_UNIT'       					, text: 'STOCK_UNIT'    	, type: 'string'},
			{name: 'ACCOUNT_YNC'      					, text: 'ACCOUNT_YNC'    	, type: 'string'},
			{name: 'DVRY_CUST_NAME'   					, text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'    		, type: 'string'},
			{name: 'CUSTOM_CODE'      					, text: 'CUSTOM_CODE'    	, type: 'string'},
			{name: 'CUSTOM_NAME'      					, text: 'CUSTOM_NAME'    	, type: 'string'},
			{name: 'ORDER_PRSN'       					, text: 'ORDER_PRSN'    	, type: 'string'},
			{name: 'SOF100_TAX_INOUT' 					, text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>'    	, type: 'string'},
			{name: 'INOUT_DATE'       					, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'    		, type: 'uniDate'},
			{name: 'REF_CODE2'        					, text: 'REF_CODE2'    		, type: 'string'},
			{name: 'AGENT_TYPE'       					, text: 'AGENT_TYPE'    	, type: 'string'},
			{name: 'PRICE_TYPE'       					, text: 'PRICE_TYPE'    	, type: 'string'},
			{name: 'INOUT_FOR_WGT_P'  					, text: 'INOUT_FOR_WGT_P'   , type: 'string'},
			{name: 'INOUT_FOR_VOL_P'  					, text: 'INOUT_FOR_VOL_P'   , type: 'string'},
			{name: 'INOUT_WGT_P'      					, text: 'INOUT_WGT_P'    	, type: 'string'},
			{name: 'INOUT_VOL_P'      					, text: 'INOUT_VOL_P'    	, type: 'string'},
			{name: 'WGT_UNIT'         					, text: 'WGT_UNIT'    		, type: 'string'},
			{name: 'UNIT_WGT'         					, text: 'UNIT_WGT'    		, type: 'string'},
			{name: 'VOL_UNIT'         					, text: 'VOL_UNIT'    		, type: 'string'},
			{name: 'UNIT_VOL'         					, text: 'UNIT_VOL'    		, type: 'string'}
		]
	});

	// 출고(미매출)/반품출고참조 스토어
	var issueStore = Unilite.createStore('ssa101ukrvIssueStore', {
			model: 'ssa101ukrvISSUEModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'ssa101ukrvService.selectIssueList'                	
                }
            },
            listeners:{
            	load:function(store, records, successful, eOpts)	{
            			if(successful)	{
            			   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);  
            			   var estiRecords = new Array();
            			   
            			   if(masterRecords.items.length > 0)	{
            			   		console.log("store.items :", store.items);
            			   		console.log("records", records);
            			   	
	            			   	Ext.each(records, 
	            			   		function(item, i)	{           			   								
			   							Ext.each(masterRecords.items, function(record, i)	{
			   								console.log("record :", record);
			   							
			   									if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM']) 
			   											&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
			   									  ) 
			   									{
			   										estiRecords.push(item);
			   									}
			   							});		
	            			   	});
	            			   store.remove(estiRecords);
            			   }
            			}
            	}
            }
            ,loadStoreRecords : function()	{
				var param= issueSearch.getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	// 출고(미매출)/반품출고참조 그리드
    var issueGrid = Unilite.createGrid('ssa101ukrvIssueGrid', {
        // title: '기본',
        layout : 'fit',
    	store: issueStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
        	onLoadSelectFirst : false
        },
        columns:  [  
					 { dataIndex: 'CHOICE'           				,  width:33},
					 { dataIndex: 'ITEM_CODE'        				,  width:100},
					 { dataIndex: 'ITEM_NAME'        				,  width:113},
					 { dataIndex: 'SPEC'             				,  width:120},
					 { dataIndex: 'ORDER_UNIT'       				,  width:60},
					 { dataIndex: 'NOT_SALE_Q'       				,  width:86},
					 { dataIndex: 'ORDER_UNIT_Q'     				,  width:86},
					 { dataIndex: 'INOUT_WGT_Q'	  					,  width:80},
					 { dataIndex: 'INOUT_VOL_Q'	  					,  width:80},
					 { dataIndex: 'ORDER_UNIT_P'     				,  width:80},
					 { dataIndex: 'ORDER_UNIT_O'     				,  width:93},
					 { dataIndex: 'INOUT_TAX_AMT'    				,  width:93},
					 { dataIndex: 'PROJECT_NO'       				,  width:86},
					 { dataIndex: 'INOUT_NUM'        				,  width:93},
					 { dataIndex: 'INOUT_SEQ'        				,  width:40},
					 { dataIndex: 'INOUT_TYPE'       				,  width:60},
					 { dataIndex: 'CUSTOM_NAME'      				,  width:100},
					 { dataIndex: 'DIV_CODE'         				,  width:86},
					 { dataIndex: 'INOUT_TYPE_DETAIL'				,  width:66,hidden:true},
					 { dataIndex: 'WH_CODE'          				,  width:66,hidden:true},
					 { dataIndex: 'TRNS_RATE'        				,  width:66,hidden:true},
					 { dataIndex: 'MONEY_UNIT'       				,  width:66,hidden:true},
					 { dataIndex: 'EXCHG_RATE_O'     				,  width:66,hidden:true},
					 { dataIndex: 'ORDER_NUM'        				,  width:66},
					 { dataIndex: 'ORDER_SEQ'        				,  width:66},
					 { dataIndex: 'TAX_TYPE'         				,  width:66,hidden:true},
					 { dataIndex: 'DVRY_CUST_CD'     				,  width:66,hidden:true},
					 { dataIndex: 'LOT_NO'           				,  width:66,hidden:true},
					 { dataIndex: 'PRICE_YN'         				,  width:66,hidden:true},
					 { dataIndex: 'DISCOUNT_RATE'    				,  width:66,hidden:true},
					 { dataIndex: 'STOCK_CARE_YN'    				,  width:66,hidden:true},
					 { dataIndex: 'STOCK_UNIT'       				,  width:66,hidden:true},
					 { dataIndex: 'ACCOUNT_YNC'      				,  width:66,hidden:true},
					 { dataIndex: 'DVRY_CUST_NAME'   				,  width:86},
					 { dataIndex: 'CUSTOM_CODE'      				,  width:86,hidden:true},
					 { dataIndex: 'CUSTOM_NAME'      				,  width:133,hidden:true},
					 { dataIndex: 'ORDER_PRSN'       				,  width:86,hidden:true},
					 { dataIndex: 'SOF100_TAX_INOUT' 				,  width:100},
					 { dataIndex: 'INOUT_DATE'       				,  width:66},
					 { dataIndex: 'REF_CODE2'        				,  width:66,hidden:true},
					 { dataIndex: 'AGENT_TYPE'       				,  width:66,hidden:true},
					 { dataIndex: 'PRICE_TYPE'       				,  width:66},
					 { dataIndex: 'INOUT_FOR_WGT_P'  				,  width:66},
					 { dataIndex: 'INOUT_FOR_VOL_P'  				,  width:66},
					 { dataIndex: 'INOUT_WGT_P'      				,  width:66},
					 { dataIndex: 'INOUT_VOL_P'      				,  width:66},
					 { dataIndex: 'WGT_UNIT'         				,  width:66},
					 { dataIndex: 'UNIT_WGT'         				,  width:66},
					 { dataIndex: 'VOL_UNIT'         				,  width:66},
					 { dataIndex: 'UNIT_VOL'         				,  width:66}
          ] 
       ,listeners: {	
          		onGridDblClick:function(grid, record, cellIndex, colName) {
  					
  				}
       		}
       	,returnData: function()	{
       		var records = this.getSelectedRecords();
       		
			Ext.each(records, function(record,i){	
							        	UniAppManager.app.onNewDataButtonDown();
							        	detailGrid.setEstiData(record.data);								        
								    }); 
			this.deleteSelectedRow();
       	}
         
    });
    
    // 출고(미매출)/반품출고참조 메인
    function openIssueWindow() {    		
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
  	
  		issueSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));	
  		issueSearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
  		issueSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', masterForm.getValue('SALE_DATE')) );
  		issueSearch.setValue('TO_ESTI_DATE', masterForm.getValue('SALE_DATE'));
  		issueSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));      		
  		issueStore.loadStoreRecords(); 
  		
		if(!referIssueWindow) {
			referIssueWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.sales.issuereturnrefer" default="출고(미매출)/반품출고참조"/>',
                width: 830,				                
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [issueSearch, issueGrid],
                tbar:  ['->',
								        {	itemId : 'saveBtn',
											text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
											handler: function() {
												issueStore.loadStoreRecords();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '<t:message code="system.label.sales.close" default="닫기"/>',
											handler: function() {
												referIssueWindow.hide();
											},
											disabled: false
										}
							    ]
							,
                listeners : {beforehide: function(me, eOpt)	{
                							 issueSearch.clearForm();
                							 issueGrid.reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											 issueSearch.clearForm();
                							 issueGrid.reset();
                			 			},
                			 beforeshow: function ( me, eOpts )	{
                			 	issueStore.loadStoreRecords();
                			 }
                }
			})
		}
		
		referIssueWindow.show();
    }

	Unilite.Main( {
		borderItems:[ 
	 		masterGrid,
			masterForm
		],  	
		id: 'ssa101ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
//			detailGrid.disabledLinkButtons(false);
//			masterForm.getField('INOUT_PRSN').focus();
			this.setDefault();
		},
		onQueryButtonDown: function() {         
			masterForm.setAllFieldsReadOnly(false);
			var billNo = masterForm.getValue('BILL_NUM');
			if(Ext.isEmpty(billNo)) {
				openSearchInfoWindow() 
			} else {
				var param= masterForm.getValues();
				masterForm.uniOpt.inLoading=true;
				masterForm.getForm().load({
					params: param,
					success:function(form, action)	{
						masterForm.setAllFieldsReadOnly(true)
						masterForm.setValue('TOT_AMT', masterForm.getValue('TOT_SALE_TAX_O') + masterForm.getValue('TOT_TAX_AMT') + masterForm.getValue('TOT_SALE_EXP_O'));
						action.result.data.TAX_TYPE == '1' ? gsTaxInout = '1' : gsTaxInout = '2';						
						
						if(CustomCodeInfo.gsCustCreditYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){	
							//여신액 구하기
							var divCode = UserInfo.divCode;
							var CustomCode = masterForm.getValue('SALE_CUSTOM_CODE');
							var saleDate = masterForm.getField('SALE_DATE').getSubmitValue()
							var moneyUnit = BsaCodeInfo.gsMoneyUnit;
							//마스터폼에 여신액 set
							UniAppManager.app.fnGetCustCredit(divCode, CustomCode, saleDate, moneyUnit);
						}					
						
						masterForm.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
                        masterForm.uniOpt.inLoading=false;
                    }
				})
				detailStore.loadStoreRecords();	
			}
/*
 * masterGrid.getStore().loadStoreRecords(); var viewLocked =
 * masterGrid.lockedGrid.getView(); var viewNormal =
 * masterGrid.normalGrid.getView(); console.log("viewLocked: ",viewLocked);
 * console.log("viewNormal: ",viewNormal);
 * viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
 * viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
 * viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
 * viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
 */			
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			this.fnInitBinding();
		},

//		checkForNewDetail:function() { 
//			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('ORDER_NUM')))	{
//				Unilite.messageBox('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
//				return false;
//			}
//			
//			/**
//			 * 여신한도 확인
//			 */ 
//			if(!masterForm.fnCreditCheck())	{
//				return false;
//			}
//			
//			/**
//			 * 마스터 데이타 수정 못 하도록 설정
//			 */
//			return masterForm.setAllFieldsReadOnly(true);
//        },

		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');   
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {
			masterForm.setValue('DIV_CODE', UserInfo.divCode); 
			masterForm.setValue('SALE_DATE', UniDate.get('today'));
			masterForm.setValue('BILL_TYPE', '10');
			masterForm.setValue('ORDER_TYPE', 0);
			masterForm.setValue('TOT_SALE_TAX_O', 0);	//과세총액(1)
			masterForm.setValue('TOT_TAX_AMT', 0);		//세액 합계(2)
			masterForm.setValue('TOT_SALE_EXP_O', 0);	//면세 총액(3)
			masterForm.setValue('TOT_AMT', 0);			//총액[(1)+(2)+(3)
			masterForm.setValue('TOT_REM_CREDIT_I', 0); //여신잔액
			masterForm.setValue('EXCHG_RATE_O', 0);	//환율
			gsTaxInout = '1';
			
			masterForm.getField('TOT_SALE_TAX_O').setReadOnly(true);
			masterForm.getField('TOT_TAX_AMT').setReadOnly(true);
			masterForm.getField('TOT_SALE_EXP_O').setReadOnly(true);
			masterForm.getField('TOT_AMT').setReadOnly(true);	
			
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);	
		},
		fnGetCustCredit: function(divCode, customCode, sDate, moneyUnit){
			var param = {"DIV_CODE": divCode, "CUSTOM_CODE": customCode, "SALE_DATE": sDate, "MONEY_UNIT": moneyUnit}
			ssa101ukrvService.getCustCredit(param, function(provider, response)	{				
				var credit = Ext.isEmpty(provider[0]['CREDIT'])? 0 : provider[0]['CREDIT'];
				masterForm.setValue('TOT_REM_CREDIT_I', credit);
			});		
		}
	});// End of Unilite.Main( {
};


</script>