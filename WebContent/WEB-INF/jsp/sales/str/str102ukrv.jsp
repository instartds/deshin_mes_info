<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="str102ukrv">
<t:ExtComboStore comboType="AU" comboCode="S002"/>				<!-- 수주구분 -->
<t:ExtComboStore comboType="AU" comboCode="S007"/>				<!-- 출고유형 -->
<t:ExtComboStore comboType="AU" comboCode="S010"/>				<!-- 영업담당자 -->
<t:ExtComboStore comboType="AU" comboCode="B024"/>				<!-- 수불담당자 -->
<t:ExtComboStore comboType="AU" comboCode="B004"/>				<!-- 화폐단위 -->
<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5'/>	<!-- 생성경로 -->
<t:ExtComboStore comboType="BOR120" pgmId="str102ukrv"/>		<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >
var orderNoWin;
var EstimateWin;
var RefWin;
var BsaCodeInfo = {
	gsCreditYn			: '${gsCreditYn}',
	gsAutoType			: '${gsAutoType}',
	gsMoneyUnit			: '${gsMoneyUnit}',
	gsVatRate			: ${gsVatRate},
	gsProdtDtAutoYN		: '${gsProdtDtAutoYN}',
	gsSaleAutoYN		: '${gsSaleAutoYN}',
	gsSof100ukrLink		: '${gsSof100ukrLink}',
	gsSrq100UkrLink		: '${gsSrq100UkrLink}',
	gsStr100UkrLink		: '${gsStr100UkrLink}',
	gsSsa100UkrLink		: '${gsSsa100UkrLink}',
	gsProcessFlag		: '${gsProcessFlag}',
	gsCondShowFlag		: '${gsCondShowFlag}',
	gsDraftFlag			: '${gsDraftFlag}',
	gsApp1AmtInfo		: '${gsApp1AmtInfo}',
	gsApp2AmtInfo		: '${gsApp2AmtInfo}',
	gsTimeYN			: '${gsTimeYN}',
	gsScmUseYN			: '${gsScmUseYN}',
	gsPjtCodeYN			: '${gsPjtCodeYN}',
	gsPointYn			: '${gsPointYn}',
	gsUnitChack			: '${gsUnitChack}',
	gsPriceGubun		: '${gsPriceGubun}',
	gsWeight			: '${gsWeight}',
	gsVolume			: '${gsVolume}',
	gsOrderTypeSaleYN	: '${gsOrderTypeSaleYN}'
};
	
var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCrYn		: '',
	gsUnderCalBase	: ''
};

var outDivCode = UserInfo.divCode;

function appMain() {
	/** Model 정의
	 * @type
	 */
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}
	var isDraftFlag = true;			// allowBlank
	if(BsaCodeInfo.gsDraftFlag=='1') {
		isDraftFlag = false;
	}

	Unilite.defineModel('str102ukrvModel', {
		fields: [{name: 'DIV_CODE'			,text: '<t:message code="unilite.msg.sMS631" default="사업장"/>'			,type : 'string', allowBlank:false } 
			,{name: 'ISSUE_REQ_METH'	,text: '<t:message code="unilite.msg.sMS778" default="출하지시방법"/>'		,type : 'string', allowBlank:false } 
			,{name: 'ISSUE_REQ_PRSN'	,text: '<t:message code="unilite.msg.sMS779" default="출하지시담당자"/>'		,type : 'string'} 
			,{name: 'ISSUE_REQ_DATE'	,text: '<t:message code="unilite.msg.sMS574" default="출하지시일"/>'			,type : 'string', allowBlank:false } 
			,{name: 'ISSUE_REQ_NUM'	 ,text: '<t:message code="unilite.msg.sMS697" default="출하지시번호"/>'		,type : 'int', allowBlank:false } 
			,{name: 'ISSUE_REQ_SEQ'	 ,text: '<t:message code="unilite.msg.sMSR003" default="출하지시순번"/>'		,type : 'int', allowBlank:false } 
			,{name: 'CUSTOM_CODE'		,text: '<t:message code="unilite.msg.sMS507" default="고객"	/>'			,type : 'string', allowBlank:false } 
			,{name: 'CUSTOM_NAME'		,text: '<t:message code="unilite.msg.sMS507" default="고객"	/>'			,type : 'string'} 
			,{name: 'BILL_TYPE'			,text: '<t:message code="unilite.msg.sMS717" default="부가세유형"/>'			,type : 'string', allowBlank:false } 
			,{name: 'ORDER_TYPE'		,text: '<t:message code="unilite.msg.sMS832" default="판매유형"/>'			,type : 'string', allowBlank:false } 
			,{name: 'INOUT_TYPE_DETAIL' ,text: '<t:message code="unilite.msg.sMS833" default="출고유형"/>'			,type : 'string', allowBlank:false } 
			,{name: 'ISSUE_DIV_CODE'	,text: '<t:message code="unilite.msg.sMSR291" default="출고사업장"/>'			,type : 'string', allowBlank:false } 
			,{name: 'WH_CODE'			,text: '<t:message code="unilite.msg.sMS699" default="출하창고"/>'			,type : 'string', allowBlank:false } 
			,{name: 'ITEM_CODE'			,text: '<t:message code="unilite.msg.sMS501" default="품목코드"/>'			,type : 'string', allowBlank:false } 
			,{name: 'ITEM_NAME'			,text: '<t:message code="unilite.msg.sMS688" default="품목명"/>'			,type : 'string'} 
			,{name: 'SPEC'				,text: '<t:message code="unilite.msg.sMSR033" default="규격"	/>'			,type : 'string'} 
			,{name: 'ORDER_UNIT'		,text: '<t:message code="unilite.msg.sMS690" default="판매단위"/>'			,type : 'string', allowBlank:false } 
			,{name: 'PRICE_TYPE'		,text: '<t:message code="unilite.msg.sMS767" default="단가구분"/>'			,type : 'string'} 
			,{name: 'TRANS_RATE'		,text: '<t:message code="unilite.msg.sMSR010" default="입수"	/>'			,type : 'int', allowBlank:false } 
			,{name: 'STOCK_Q'			,text: '<t:message code="unilite.msg.sMS780" default="재고수량"/>'			,type : 'int'} 
			,{name: 'ISSUE_REQ_QTY'		,text: '<t:message code="unilite.msg.sMS683" default="출하지시량"/>'			,type : 'int', allowBlank:false } 
			,{name: 'ISSUE_FOR_PRICE'	,text: '<t:message code="unilite.msg.sMRBW149" default="외화단가"/>'			,type : 'int', allowBlank:false } 
			,{name: 'ISSUE_WGT_Q'		,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'	,type : 'int'} 
			,{name: 'ISSUE_FOR_WGT_P'	,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'	,type : 'int'} 
			,{name: 'ISSUE_VOL_Q'		,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>(<t:message code="system.label.sales.volumn" default="부피"/>)' ,type : 'int'} 
			,{name: 'ISSUE_FOR_VOL_P'	,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'	,type : 'int'} 
			,{name: 'ISSUE_FOR_AMT'	 ,text: '<t:message code="unilite.msg.sMS681" default="외화금액"/>'		,type : 'int', allowBlank:false } 
			,{name: 'ISSUE_REQ_PRICE'	,text: '자사단가'			,type : 'int'} 
			,{name: 'ISSUE_WGT_P'		,text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)'		,type : 'int'} 
			,{name: 'ISSUE_VOL_P'		,text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)'		,type : 'int'} 
			,{name: 'ISSUE_REQ_AMT'	 ,text: '<t:message code="system.label.sales.coamount" default="자사금액"/>'				,type : 'int'} 
			,{name: 'TAX_TYPE'			,text: '<t:message code="unilite.msg.sMSR289" default="과세구분"/>'			,type : 'string', allowBlank:false } 
			,{name: 'ISSUE_REQ_TAX_AMT' ,text: '<t:message code="unilite.msg.sMS646" default="세액"	/>'			,type : 'int'} 
			,{name: 'WGT_UNIT'			,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'			,type : 'string'} 
			,{name: 'UNIT_WGT'			,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>' 			,type : 'int'} 
			,{name: 'VOL_UNIT'			,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'			,type : 'string'} 
			,{name: 'UNIT_VOL'			,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'		,type : 'int'} 
			,{name: 'ISSUE_DATE'		,text: '<t:message code="unilite.msg.sMS781" default="출고요청일"/>'			,type : 'string'} 
			,{name: 'DELIVERY_TIME'	 ,text: '<t:message code="unilite.msg.sMS781" default="출고요청시간"/>'		,type : 'string'} 
			,{name: 'DISCOUNT_RATE'	 ,text: '<t:message code="unilite.msg.sMS716" default="할인율"/>'			,type : 'int'} 
			,{name: 'LOT_NO'			,text: '<t:message code="unilite.msg.sMS782" default="LOT NO"/>'			,type : 'string'} 
			,{name: 'PRICE_YN'			,text: '<t:message code="unilite.msg.sMS767" default="단가구분"/>'			,type : 'string', allowBlank:false } 
			,{name: 'SALE_CUSTOM_CODE'  ,text: '<t:message code="unilite.msgsMS665." default="매출처"/>'			,type : 'string'} 
			,{name: 'SALE_CUSTOM_NAME'  ,text: '<t:message code="unilite.msg.sMS665" default="매출처"/>'			,type : 'string'} 
			,{name: 'ACCOUNT_YNC'		,text: '<t:message code="unilite.msg.sMSR049" default="매출대상"/>'			,type : 'string'} 
			,{name: 'DVRY_CUST_CD'	  ,text: '<t:message code="unilite.msg.sMSR293" default="배송처"/>'			,type : 'string'} 
			,{name: 'DVRY_CUST_NAME'	,text: '<t:message code="unilite.msg.sMSR293" default="배송처"/>'			,type : 'string'} 
			,{name: 'PROJECT_NO'		,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type : 'string'} 
			,{name: 'PO_NUM'			,text: '<t:message code="system.label.sales.pono2" default="P/O 번호"/>'			,type : 'int'}
			,{name: 'PO_SEQ'			,text: '<t:message code="system.label.sales.poseq2" default="P/O 순번"/>'			,type : 'int'} 
			,{name: 'ORDER_NUM'			,text: '<t:message code="unilite.msg.sMS533" default="수주번호"/>'			,type : 'int'} 
			,{name: 'SER_NO'			,text: '<t:message code="unilite.msg.sMS783" default="수주순번"/>'			,type : 'string'} 
			,{name: 'REMARK'			,text: '<t:message code="unilite.msg.sMS742" default="비고"	/>'			,type : 'string'} 
			,{name: 'UPDATE_DB_USER'	,text: '<t:message code="unilite.msg.sMSR304" default="수정자"/>'			,type : 'string'} 
			,{name: 'UPDATE_DB_TIME'	,text: '<t:message code="unilite.msg.sMSR305" default="수정일"/>'			,type : ''} 
			,{name: 'DEPT_CODE'			,text: '<t:message code="unilite.msg.sMS784" default="출하지시부서"/>'		,type : 'string', allowBlank:false } 
			,{name: 'TREE_NAME'			,text: '<t:message code="unilite.msg.sMS785" default="부서명"/>'			,type : 'string', allowBlank:false } 
			,{name: 'MONEY_UNIT'		,text: '<t:message code="unilite.msg.sMSR047" default="화폐단위"/>'			,type : 'string', allowBlank:false } 
			,{name: 'EXCHANGE_RATE'	 ,text: '<t:message code="unilite.msg.sMSR031" default="환율"	/>'			,type : 'int', allowBlank:false } 
			,{name: 'ISSUE_QTY'			,text: '<t:message code="unilite.msg.sMS584" default="출고량"/>'			,type : 'int'} 
			,{name: 'RETURN_Q'			,text: '<t:message code="unilite.msg." default="반품량"/>'			,type : 'int'} 
			,{name: 'ORDER_Q'			,text: '<t:message code="unilite.msg." default="주문량"/>'			,type : 'int'} 
			,{name: 'ISSUE_REQ_Q'		,text: '<t:message code="unilite.msg." default="수주의 출하지시량"/>'		,type : 'int'} 
			,{name: 'DVRY_DATE'			,text: '<t:message code="unilite.msg.sMS510" default="납기일"/>'			,type : 'string'} 
			,{name: 'DVRY_TIME'			,text: '<t:message code="unilite.msg.sMS510" default="납기시간"/>'			,type : 'string'} 
			,{name: 'TAX_INOUT'			,text: 'TAX_INOUT'		,type : 'string'} 
			,{name: 'STOCK_UNIT'		,text: 'STOCK_UNIT'			,type : 'string'} 
			,{name: 'PRE_ACCNT_YN'		,text: 'PRE_ACCNT_YN'		,type : 'string'} 
			,{name: 'REF_FLAG'			,text: 'REF_FLAG'	,type : 'string'} 
			,{name: 'SALE_P'			,text: 'SALE_P'	,type : 'int'} 
			,{name: 'AMEND_YN'			,text: 'AMEND_YN'	,type : 'string'} 
			,{name: 'OUTSTOCK_Q'		,text: 'OUTSTOCK_Q'		,type : 'int'} 
			,{name: 'ORDER_CUST_NM'	 ,text: 'ORDER_CUST_NM'			,type : 'string'} 
			,{name: 'STOCK_CARE_YN'	 ,text: 'STOCK_CARE_YN'	,type : 'string'} 
			,{name: 'NOTOUT_Q'			,text: 'NOTOUT_Q'	,type : 'string'} 
			,{name: 'SORT_KEY'			,text: 'SORT_KEY'		,type : 'string'} 
			,{name: 'REF_AGENT_TYPE'	,text: 'REF_AGENT_TYPE'			,type : 'string'} 
			,{name: 'REF_WON_CALC_TYPE' ,text: 'REF_WON_CALC_TYPE'			,type : 'string'} 
			,{name: 'REF_CODE2'			,text: 'REF_CODE2'				,type : 'string'} 
			,{name: 'COMP_CODE'			,text: 'COMP_CODE'			,type : 'string', allowBlank:false } 
			,{name: 'SCM_FLAG_YN'		,text: 'SCM_FLAG_YN'		,type : 'string'} 
			,{name: 'REF_LOC'			,text: 'REF_LOC',type : 'string'} 
			,{name: 'PAY_METHODE1'		,text: 'PAY_METHODE1'				,type : 'string'} 
			,{name: 'LC_SER_NO'			,text: 'LC_SER_NO'				,type : 'string'} 
			,{name: 'GUBUN'				,text: 'GUBUN'				,type : 'string'} 
		]
	});



	var directMasterStore = Unilite.createStore('str102ukrvStore', {
			model: 'str102ukrvModel',
			autoLoad: false,
			uniOpt : {
				isMaster: true,			// 상위 버튼 연결
				editable: true,			// 수정 모드 사용
				deletable:true,			// 삭제 가능 여부
				useNavi : false			// prev | next 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
						read : 'str102ukrvService.selectDetailList'
					,update : 'str102ukrvService.updateDetail'
					,create : 'str102ukrvService.insertDetail'
					,destroy: 'str102ukrvService.deleteDetail'
					,syncAll: 'str102ukrvService.syncAll'
				}
			}
			,listeners:{
				load:function( store, records, successful, eOpts ) {
					this.fnOrderAmtSum();
				}
				,add : function( store, records, index, eOpts ) {
					this.fnOrderAmtSum();
				}
				,update : function( store, record, operation, modifiedFieldNames, eOpts ) {
					this.fnOrderAmtSum();
				}
				,remove : function( store, record, index, isMove, eOpts ) {
					this.fnOrderAmtSum();
				}
			}
			,loadStoreRecords : function() {
				var param= detailForm.getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			saveStore : function(config) {
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				var toCreate = this.getNewRecords();
				var toUpdate = this.getUpdatedRecords();
				var toDelete = this.getRemovedRecords();
				var list = [].concat( toUpdate, toCreate	);
				
				console.log("list:", list);
				var orderNum = detailForm.getValue('ORDER_NUM');
				Ext.each(list, function(record, index) {
					if(record.data['ORDER_NUM'] != orderNum) {
						record.set('ORDER_NUM',orderNum);
					}
				})
				
				console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
				
				if(inValidRecs.length == 0 ) {
					if(config==null) {
						config = {success : function() {
												detailForm.getForm().wasDirty = false;
												detailForm.resetDirtyStatus();
												console.log("set was dirty to false");
												UniAppManager.setToolbarButtons('save', false);
											} 
								};
					}
					this.syncAll(config);
					
				}else {
					Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				}
			}
			, fnOrderAmtSum: function() {
				console.log("=============Exec fnOrderAmtSum()");
				var sumOrder = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
				var sumTax = Ext.isNumeric(this.sum('ORDER_TAX_O')) ? this.sum('ORDER_TAX_O'):0;
				var sumTot = sumOrder+sumTax;
				detailForm.setValue('ORDER_O',sumOrder);
				detailForm.setValue('ORDER_TAX_O',sumTax);
				detailForm.setValue('TOT_ORDER_AMT',sumTot);
				detailForm.fnCreditCheck()
			}
	});

	
 
	/**
	 * 수주등록 Master Form
	 * 
	 * @type
	 */	 
	var detailForm = Unilite.createForm('str102ukrvDetail', {
		// to Make TAB
		disabled :false
		, autoScroll:true  
		, layout: {type: 'vbox', align:'stretch'}
		, items :[{ xtype: 'container'
					,defaultType: 'uniTextfield'
					,layout: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}}
					,items :[	{fieldLabel: '<t:message code="unilite.msg.sMS540" default="사업장"/>'  ,		name: 'DIV_CODE',	xtype:'uniCombobox', comboType:'BOR120', value:UserInfo.divCode, allowBlank:false}
								,{fieldLabel: '<t:message code="unilite.msg.sMR047" default="출고일"/>'  ,		name: 'ORDER_DATE', xtype:'uniDatefield', value:new Date(), allowBlank:false,
								  listeners:{ blur : function( field, event, eOpts ) {
													//detailForm.setValue('REMAIN_CREDIT', UniSales.fnGetCustCredit(UserInfo.compCode, detailForm.getValue('DIV_CODE'), detailForm.getValue("CUSTOM_CODE"), detailForm.getValue('ORDER_DATE'), UserInfo.currency));													
												}
											}
								 }
								 ,Unilite.popup('AGENT_CUST',{fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' , allowBlank:false, colspan:2})
								 ,{fieldLabel: '<t:message code="unilite.msg.sMS127" default="매출일"/>'  ,		name: 'ORDER_DATE', xtype:'uniDatefield', value:new Date(), allowBlank:false,
								  listeners:{ blur : function( field, event, eOpts ) {
													//detailForm.setValue('REMAIN_CREDIT', UniSales.fnGetCustCredit(UserInfo.compCode, detailForm.getValue('DIV_CODE'), detailForm.getValue("CUSTOM_CODE"), detailForm.getValue('ORDER_DATE'), UserInfo.currency));													
												}
											}
								 }
								,{fieldLabel: '<t:message code="unilite.msg.sMS836" default="수불담당"/>'		, name: 'ORDER_PRSN',	xtype:'uniCombobox', comboType:'AU', comboCode:'B024', allowBlank:false}
								,{fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'		, name: 'CREATE_LOC',	xtype:'uniCombobox', comboType:'AU', comboCode:'B031', allowBlank:false, value:'1'}
								,{fieldLabel: '<t:message code="unilite.msg.sMRBW144" default="출고번호"/>'}
								,{fieldLabel: '<t:message code="system.label.sales.taxabletotalamount" default="과세총액"/>(1)', name: '', xtype:'uniNumberfield'}
								,{fieldLabel: '<t:message code="system.label.sales.taxexemptiontotalamount" default="면세총액"/>(3)', name: '', xtype:'uniNumberfield'}
								,{fieldLabel: '수량총계', name: '', xtype:'uniNumberfield'}								
								,{fieldLabel: '<t:message code="unilite.msg.sMB184" default="화폐"/>'	,name:'', 	xtype: 'uniCombobox', comboType:'AU',comboCode:'B004', value:'KRW', allowBlank: false, displayField: 'value', fieldStyle: 'text-align: center;'  }
								,{fieldLabel: '<t:message code="system.label.sales.taxtotalamount" default="세액합계"/>(2)', name: '', xtype:'uniNumberfield'}
								,{fieldLabel: '출고총액[(1)+(2)+(3)]', name: '', xtype:'uniNumberfield', labelWidth: 335, colspan:3}
							]
					 }
				 ]
		 ,api: {
				 load: 'str102ukrvService.selectMaster',
				 submit: 'str102ukrvService.syncMaster'
				}
		, listeners : {
				dirtychange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					UniAppManager.setToolbarButtons('save', true);
				}
		}
		 ,fnCreditCheck: function() {
				 if(BsaCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
					if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT') ) {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck002" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
						return false;
					}
				}
				return true;
		 }
		 ,setAllFieldsReadOnly: function(b) {
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
					}else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}

					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}else {
					this.mask();
				}
			}else {
				this.unmask();
			}
			return r;
		}
	});

	
	 var discountSearch = Unilite.createSearchForm('discountSearch', {
			layout :  {type : 'uniTable', columns : 2, tableAttrs:{align:'right'} },
			items :[
			]
		
	});

		/**
		 * 수주내역 Master Grid 정의(Grid Panel)
		 * 
		 * @type
		 */ 
	var masterGrid = Unilite.createGrid('str102ukrvGrid', {
		// title: '기본',
		layout : 'fit',
		uniOpt:{
					 expandLastColumn: false
					,useRowNumberer: false
		},
		tbar: [
			{
				itemId : 'estimateBtn', iconCls : 'icon-referance'	,
				text:'<t:message code="system.label.sales.reference" default="참조..."/>',
				handler: function() {
					openEstimateWindow();
					}
			 },
			 {
				itemId : 'estimateBtn', iconCls : 'icon-referance'	,
				text:'<t:message code="system.label.sales.shipmentorderrefer" default="출하지시참조"/>',
				handler: function() {
					openEstimateWindow();
					}
			 },
			 {
				itemId : 'estimateBtn', iconCls : 'icon-referance'	,
				text:'<t:message code="system.label.sales.soofferrefer" default="수주(오퍼)참조"/>',
				handler: function() {
					openEstimateWindow();
					}
			 }
			],
		store: directMasterStore,
		columns:  [
			 { dataIndex: 'DIV_CODE',  width: 10, hidden: true } 
			,{ dataIndex: 'ISSUE_REQ_METH',  width: 10, hidden: true } 
			,{ dataIndex: 'ISSUE_REQ_PRSN',  width: 10, hidden: true } 
			,{ dataIndex: 'ISSUE_REQ_DATE',  width: 10, hidden: true } 
			,{ dataIndex: 'ISSUE_REQ_NUM',  width: 10, hidden: true } 
			,{ dataIndex: 'ISSUE_REQ_SEQ',  width: 60 } 
			,{ dataIndex: 'CUSTOM_CODE',  width: 120, hidden: true } 
			,{ dataIndex: 'CUSTOM_NAME',  width: 200 } 
			,{ dataIndex: 'BILL_TYPE',  width: 120 } 
			,{ dataIndex: 'ORDER_TYPE',  width: 0 } 
			,{ dataIndex: 'INOUT_TYPE_DETAIL',  width: 90 } 
			,{ dataIndex: 'ISSUE_DIV_CODE',  width: 120 } 
			,{ dataIndex: 'WH_CODE',  width: 100 } 
			,{ dataIndex: 'ITEM_CODE',  width: 120 } 
			,{ dataIndex: 'ITEM_NAME',  width: 200 } 
			,{ dataIndex: 'SPEC',  width: 200 } 
			,{ dataIndex: 'ORDER_UNIT',  width: 80, align: 'center' } 
			,{ dataIndex: 'PRICE_TYPE',  width: 100 } 
			,{ dataIndex: 'TRANS_RATE',  width: 80 } 
			,{ dataIndex: 'STOCK_Q',  width: 160 }
			,{ dataIndex: 'ISSUE_REQ_QTY',  width: 160 } 
			,{ dataIndex: 'ISSUE_FOR_PRICE',  width: 160 } 
			,{ dataIndex: 'ISSUE_WGT_Q',  width: 160 } 
			,{ dataIndex: 'ISSUE_FOR_WGT_P',  width: 160 } 
			,{ dataIndex: 'ISSUE_VOL_Q',  width: 160 } 
			,{ dataIndex: 'ISSUE_FOR_VOL_P',  width: 160 }
			,{ dataIndex: 'ISSUE_FOR_AMT',  width: 160 } 
			,{ dataIndex: 'ISSUE_REQ_PRICE',  width: 160 } 
			,{ dataIndex: 'ISSUE_WGT_P',  width: 160 } 
			,{ dataIndex: 'ISSUE_VOL_P',  width: 160 } 
			,{ dataIndex: 'ISSUE_REQ_AMT',  width: 160 } 
			,{ dataIndex: 'TAX_TYPE',  width: 80 } 
			,{ dataIndex: 'ISSUE_REQ_TAX_AMT',  width: 160 } 
			,{ dataIndex: 'WGT_UNIT',  width: 100 } 
			,{ dataIndex: 'UNIT_WGT',  width: 100 } 
			,{ dataIndex: 'VOL_UNIT',  width: 100 } 
			,{ dataIndex: 'UNIT_VOL',  width: 100 } 
			,{ dataIndex: 'ISSUE_DATE',  width: 120 } 
			,{ dataIndex: 'DELIVERY_TIME',  width: 120 } 
			,{ dataIndex: 'DISCOUNT_RATE',  width: 90 } 
			,{ dataIndex: 'LOT_NO',  width: 120 } 
			,{ dataIndex: 'PRICE_YN',  width: 80 } 
			,{ dataIndex: 'SALE_CUSTOM_CODE',  width: 120, hidden: true } 
			,{ dataIndex: 'SALE_CUSTOM_NAME',  width: 120 } 
			,{ dataIndex: 'ACCOUNT_YNC',  width: 80 } 
			,{ dataIndex: 'DVRY_CUST_CD',  width: 120, hidden: true } 
			,{ dataIndex: 'DVRY_CUST_NAME',  width: 120 } 
			,{ dataIndex: 'PROJECT_NO',  width: 140 } 
			,{ dataIndex: 'PO_NUM',  width: 120 } 
			,{ dataIndex: 'PO_SEQ',  width: 80 } 
			,{ dataIndex: 'ORDER_NUM',  width: 120 } 
			,{ dataIndex: 'SER_NO',  width: 80 } 
			,{ dataIndex: 'REMARK',  width: 160 } 
			,{ dataIndex: 'UPDATE_DB_USER',  width: 10, hidden: true } 
			,{ dataIndex: 'UPDATE_DB_TIME',  width: 10, hidden: true } 
			,{ dataIndex: 'DEPT_CODE',  width: 10, hidden: true } 
			,{ dataIndex: 'TREE_NAME',  width: 10, hidden: true } 
			,{ dataIndex: 'MONEY_UNIT',  width: 50, hidden: true } 
			,{ dataIndex: 'EXCHANGE_RATE',  width: 50, hidden: true } 
			,{ dataIndex: 'ISSUE_QTY',  width: 10, hidden: true } 
			,{ dataIndex: 'RETURN_Q',  width: 10, hidden: true } 
			,{ dataIndex: 'ORDER_Q',  width: 10, hidden: true } 
			,{ dataIndex: 'ISSUE_REQ_Q',  width: 10, hidden: true } 
			,{ dataIndex: 'DVRY_DATE',  width: 120 } 
			,{ dataIndex: 'DVRY_TIME',  width: 120 } 
			,{ dataIndex: 'TAX_INOUT',  width: 10, hidden: true } 
			,{ dataIndex: 'STOCK_UNIT',  width: 10, hidden: true } 
			,{ dataIndex: 'PRE_ACCNT_YN',  width: 10, hidden: true } 
			,{ dataIndex: 'REF_FLAG',  width: 10, hidden: true } 
			,{ dataIndex: 'SALE_P',  width: 10, hidden: true } 
			,{ dataIndex: 'AMEND_YN',  width: 10, hidden: true } 
			,{ dataIndex: 'OUTSTOCK_Q',  width: 10, hidden: true } 
			,{ dataIndex: 'ORDER_CUST_NM',  width: 10, hidden: true } 
			,{ dataIndex: 'STOCK_CARE_YN',  width: 10, hidden: true } 
			,{ dataIndex: 'NOTOUT_Q',  width: 10, hidden: true } 
			,{ dataIndex: 'SORT_KEY',  width: 10, hidden: true } 
			,{ dataIndex: 'REF_AGENT_TYPE',  width: 10, hidden: true } 
			,{ dataIndex: 'REF_WON_CALC_TYPE',  width: 10, hidden: true } 
			,{ dataIndex: 'REF_CODE2',  width: 10, hidden: true }
			,{ dataIndex: 'COMP_CODE',  width: 10, hidden: true }
			,{ dataIndex: 'PAY_METHODE1',  width: 150 } 
			,{ dataIndex: 'LC_SER_NO',  width: 150	 } 
			,{ dataIndex: 'GUBUN',  width: 150 }
		  ] 
		,listeners: {	
			}
		,setItemData: function(record, dataClear) {
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
				grdRecord.set('ITEM_CODE'			,record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			,record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'		,record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				,record['SPEC']); 
				grdRecord.set('ORDER_UNIT'			,record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			,record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'			,record['WH_CODE']);
				grdRecord.set('REF_STOCK_CARE_YN'	,record['STOCK_CARE_YN']);
				// grdRecord.set('OUT_DIV_CODE' ,record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			,record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			,record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			,record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			,record['UNIT_VOL']);
				grdRecord.set('ORDER_NUM'			,detailForm.getValue('ORDER_NUM'));
				
				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
				
			}
		},
		setEstiData:function(record) {
			var grdRecord = this.getSelectedRecord();
		
			//grdRecord.set('DIV_CODE'			,record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			,detailForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			,record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			,record['ITEM_NAME']);	
			grdRecord.set('ITEM_ACCOUNT'		,record['ITEM_ACCOUNT']);	
			grdRecord.set('SPEC'		,record['SPEC']);	
			grdRecord.set('ORDER_UNIT'		,record['ESTI_UNIT']);	
			grdRecord.set('TRANS_RATE'		,record['TRANS_RATE']);	
			grdRecord.set('ORDER_Q'		,record['ESTI_QTY']);	
			grdRecord.set('ORDER_P'		,record['ESTI_PRICE']);	
			grdRecord.set('SCM_FLAG_YN'		,'N');	
			if(detailForm.getValue('TAX_TYPE') != 50)	
			{
				grdRecord.set('TAX_TYPE'		,detailForm.getValue('TAX_TYPE').TAX_TYPE);	
			}
			if(Ext.isEmpty(detailForm.getValue('DVRY_DATE'))) {
				
				grdRecord.set('DVRY_DATE'		,detailForm.getValue('ORDER_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,detailForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		,0);	
			grdRecord.set('REF_WH_CODE'		,record['WH_CODE']);	
			grdRecord.set('REF_STOCK_CARE_YN'		,record['STOCK_CARE_YN']);	
			grdRecord.set('OUT_DIV_CODE'		,UserInfo.divCode);	
			grdRecord.set('STOCK_UNIT'		,record['STOCK_UNIT']);	
			grdRecord.set('ACCOUNT_YNC'		,'Y');	
			
			if(Ext.isEmpty(detailForm.getValue('SALE_CUST_CD'))) {
				grdRecord.set('SALE_CUST_CD'		,detailForm.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,detailForm.getValue('SALE_CUST_CD'));
			}
			
			if(Ext.isEmpty(detailForm.getValue('SALE_CUST_NM'))) {
				grdRecord.set('CUSTOM_NAME'		,detailForm.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'		,detailForm.getValue('SALE_CUST_NM'));
			}
			grdRecord.set('PROD_PLAN_Q'		,0);	
			grdRecord.set('ESTI_NUM'		,record['ESTI_NUM']);	
			grdRecord.set('ESTI_SEQ'		,record['ESTI_SEQ']);	
			grdRecord.set('REF_ORDER_DATE'		,detailForm.getValue('ORDER_DATE'));	
			grdRecord.set('REF_ORD_CUST'		,detailForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('REF_ORDER_TYPE'		,detailForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		,detailForm.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		,detailForm.getValue('TAX_TYPE').TAX_TYPE);
			//FIXME gsExchageRate값 설정
			//grdRecord.set('REF_EXCHG_RATE_O'		,gsExchageRate);	
			grdRecord.set('REF_REMARK'		,detailForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'		,record['ESTI_QTY']);	
			grdRecord.set('REF_BILL_TYPE'		,detailForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH'		,detailForm.getValue('RECEIPT_METH'));	
			grdRecord.set('WGT_UNIT'		,record['WGT_UNIT']);	
			grdRecord.set('UNIT_WGT'		,record['UNIT_WGT']);	
			grdRecord.set('VOL_UNIT'		,record['VOL_UNIT']);	
			grdRecord.set('UNIT_VOL'		,record['UNIT_VOL']);
			UniSales.fnGetPriceInfo(grdRecord
									,'R'
									,UserInfo.compCode
									,detailForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ESTI_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,detailForm.getValue('ORDER_DATE')
									,grdRecord.get('ORDER_Q')
									,record['WGT_UNIT']
									,record['VOL_UNIT']
									,record['UNIT_WGT']
									,record['UNIT_VOL']
									,record['PRICE_TYPE']
									);
			
			//수주수량/단가(중량) 재계산
			var	sUnitWgt	= grdRecord.get('UNIT_WGT');
			var	sOrderWgtQ = grdRecord.set('ORDER_WGT_Q', (grdRecord.get('ORDER_Q') * sUnitWgt));
			
			if( sUnitWgt == 0) { 
				grdRecord.set('ORDER_WGT_P'		,0);
			} else {
				grdRecord.set('ORDER_WGT_P', (grdRecord.get('ORDER_P') / sUnitWgt))
			}
			
			//수주수량/단가(부피) 재계산
			var	sUnitVol	= grdRecord.get('UNIT_VOL');
			var	sOrderVolQ = grdRecord.set('ORDER_VOL_Q', (grdRecord.get('ORDER_Q') * sUnitVol));
			
			if( sUnitVol == 0) { 
				grdRecord.set('ORDER_VOL_P'		,0);
			} else {
				grdRecord.set('ORDER_VOL_P', (grdRecord.get('ORDER_P') / sUnitVol))
			}
			
			/*
				
				Call top.fraBody1.fnOrderAmtCal(lRow, "Q")
				Call top.fraBody1.fnStockQ(lRow)	 //현재고량 조회
			*/
			
			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = grdRecord.get('TRANS_RATE');
			
			if(!Ext.isEmpty(grdRecord.get('STOCK_Q'))) {
				dStockQ = grdRecord.get('STOCK_Q');
			}
			
			if(!Ext.isEmpty(grdRecord.get('ORDER_Q'))) {
				dOrderQ = grdRecord.get('ORDER_Q');
			}
			
			if(dStockQ > 0 ) {
				if(dStockQ > dOrderQ) {	//'재고량 > 수주량
					grdRecord.set('PROD_SALE_Q'		,0);	
					grdRecord.set('PROD_Q'		,0);	
					grdRecord.set('PROD_END_DATE'		,'');	
				} else {
					if(grdRecord.get('ITEM_ACCOUNT')=="00") {
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 ) {
							grdRecord.set('PROD_SALE_Q'		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate - dStockQ ) );
							grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
						}
					}
				}
			}else {
				if(grdRecord.get('ITEM_ACCOUNT')=="00") {
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 ) {
							grdRecord.set('PROD_SALE_Q'		,dOrderQ);	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate ) );
						}
					}
			}
			if(BsaCodeInfo.gsProdtDtAutoYN=='Y') {
				var dProdtQ = 0;
				if(!Ext.isEmpty(grdRecord.get('PROD_SALE_Q'))) {
					dProdtQ = grdRecord.get('PROD_SALE_Q');
				}
				if(dProdtQ > 0) {
					grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
				}
			}
		},
		setRefData: function(record) {
			var grdRecord = this.getselectedrecord();
		
			grdRecord.set('DIV_CODE'			,record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			,detailForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			,record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			,record['ITEM_NAME']);	
			grdRecord.set('ITEM_ACCOUNT'		,record['ITEM_ACCOUNT']);	
			grdRecord.set('SPEC'		,record['SPEC']);	
			grdRecord.set('ORDER_UNIT'		,record['ORDER_UNIT']);	
			grdRecord.set('TRANS_RATE'		,record['TRANS_RATE']);	
			grdRecord.set('ORDER_Q'		,record['ORDER_Q']);	
			grdRecord.set('ORDER_P'		,record['ORDER_P']);	
			grdRecord.set('SCM_FLAG_YN'		,'N');	
			
			if(detailForm.getValue('TAX_TYPE') != 50)	
			{
				grdRecord.set('TAX_TYPE'		,record['TAX_TYPE']);	
			}
			if(Ext.isEmpty(detailForm.getValue('DVRY_DATE'))) {
				
				grdRecord.set('DVRY_DATE'		,detailForm.getValue('ORDER_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,detailForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		,0);	
			grdRecord.set('REF_WH_CODE'			,record['WH_CODE']);	
			grdRecord.set('REF_STOCK_CARE_YN'	,record['STOCK_CARE_YN']);	
			grdRecord.set('OUT_DIV_CODE'		,record['OUT_DIV_CODE']);	
			grdRecord.set('STOCK_UNIT'			,record['STOCK_UNIT']);	
			grdRecord.set('ACCOUNT_YNC'			,record['ACCOUNT_YNC']);	
			
			
			if(Ext.isEmpty(detailForm.getValue('SALE_CUST_CD'))) {
				grdRecord.set('SALE_CUST_CD'		,detailForm.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,detailForm.getValue('SALE_CUST_CD'));
			}
			
			if(Ext.isEmpty(detailForm.getValue('SALE_CUST_NM'))) {
				grdRecord.set('CUSTOM_NAME'		,detailForm.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'		,detailForm.getValue('SALE_CUST_NM'));
			}			
			
			grdRecord.set('DVRY_CUST_CD'		,record['DVRY_CUST_CD']);	
			grdRecord.set('DVRY_CUST_NAME'		,record['DVRY_CUST_NAME']);	
			grdRecord.set('PRICE_YN'			,record['PRICE_YN']);
			
			grdRecord.set('PROD_PLAN_Q'		,0);	
			
			grdRecord.set('DISCOUNT_RATE'			,record['DISCOUNT_RATE']);
			grdRecord.set('PRE_ACCNT_YN'			,record['PRE_ACCNT_YN']);
			grdRecord.set('REF_ORDER_DATE'		,detailForm.getValue('ORDER_DATE'));	
			
			grdRecord.set('REF_ORD_CUST'		,detailForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('REF_ORDER_TYPE'		,detailForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		,detailForm.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		,detailForm.getValue('TAX_TYPE').TAX_TYPE);
			//FIXME gsExchageRate값 설정
			//grdRecord.set('REF_EXCHG_RATE_O'		,gsExchageRate);	
			grdRecord.set('REF_REMARK'		,detailForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'		,record['ORDER_Q']);	
			grdRecord.set('REF_BILL_TYPE'		,detailForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH'		,detailForm.getValue('RECEIPT_METH'));	
			grdRecord.set('WGT_UNIT'		,record['WGT_UNIT']);	
			grdRecord.set('UNIT_WGT'		,record['UNIT_WGT']);	
			grdRecord.set('VOL_UNIT'		,record['VOL_UNIT']);	
			grdRecord.set('UNIT_VOL'		,record['UNIT_VOL']);
			
			UniSales.fnGetPriceInfo(grdRecord
									,'R'
									,UserInfo.compCode
									,detailForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ORDER_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,detailForm.getValue('ORDER_DATE')
									,grdRecord.get('ORDER_Q')
									,grdRecord.get('WGT_UNIT')
									,grdRecord.get('VOL_UNIT')
									,grdRecord.get('UNIT_WGT')
									,grdRecord.get('UNIT_VOL')
									,grdRecord.get('PRICE_TYPE')
									);
			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			UniSales.fnStockQ(grdRecord, UserInfo.compCode, record['OUT_DIV_CODE'], null,record['ITEM_CODE'],record['WH_CODE']);
			//FIXME fnStockQ가 실행 후 STOCK_Q 값을 가져온 후 아래 로직을 실행해야 함..
			
			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = grdRecord.get('TRANS_RATE');
			
			if(!Ext.isEmpty(grdRecord.get('STOCK_Q'))) {
				dStockQ = grdRecord.get('STOCK_Q');
			}
			
			if(!Ext.isEmpty(grdRecord.get('ORDER_Q'))) {
				dOrderQ = grdRecord.get('ORDER_Q');
			}
			
			if(dStockQ > 0 ) {
				if(dStockQ > dOrderQ) {	//'재고량 > 수주량
					grdRecord.set('PROD_SALE_Q'		,0);
					grdRecord.set('PROD_Q'			,0);
					grdRecord.set('PROD_END_DATE'	,'');
				} else {
					if(grdRecord.get('ITEM_ACCOUNT')=="00") {
						grdRecord.set('PROD_SALE_Q'		,0);
						grdRecord.set('PROD_Q'			,0);
						grdRecord.set('PROD_END_DATE'	,'');
					}else {
						if(lTrnsRate > 0 ) {
							grdRecord.set('PROD_SALE_Q'		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate - dStockQ ) );	
							grdRecord.set('PROD_END_DATE'	,grdRecord.get('DVRY_DATE'));
						}
					}
				}
			}else {
				if(grdRecord.get('ITEM_ACCOUNT')=="00") {
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 ) {
							grdRecord.set('PROD_SALE_Q'		,dOrderQ);	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate ) );	
						}
					}
			}
			
			if(BsaCodeInfo.gsProdtDtAutoYN=='Y') {
				var dProdtQ = 0;
				if(!Ext.isEmpty(grdRecord.get('PROD_SALE_Q'))) {
					dProdtQ = grdRecord.get('PROD_SALE_Q');
				}
				
				if(dProdtQ > 0) {
					grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
				}
				
			}
		}
	});

	/**
	 * 견적참조
	 */
	Unilite.defineModel('str102ukrvESTIModel', {
		fields: [
			 {name: 'CUSTOM_CODE'		,text:'<t:message code="unilite.msg.sMS774" default="견적처"/>'					,type : 'string'} 
			,{name: 'CUSTOM_NAME'		,text:'<t:message code="unilite.msg.sMS774" default="견적처"/>'					,type : 'string'} 
			,{name: 'ESTI_DATE'			,text:'<t:message code="unilite.msg.sMSR002" default="견적일"/>'				,type : 'string'} 
			,{name: 'ESTI_NUM'			,text:'<t:message code="unilite.msg.sMS538" default="견적번호"/>'				,type : 'string'} 
			,{name: 'ESTI_SEQ'			,text:'<t:message code="unilite.msg.sMSR003" default="순번"/>'					,type : 'string'} 
			,{name: 'ITEM_CODE'			,text:'<t:message code="unilite.msg.sMS501" default="품목코드"/>'				,type : 'string'} 
			,{name: 'ITEM_NAME'			,text:'<t:message code="unilite.msg.sMS688" default="품명"/>'					,type : 'string'} 
			,{name: 'SPEC'				,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'					,type : 'string'} 
			,{name: 'ESTI_UNIT'			,text:'<t:message code="unilite.msg.sMS690" default="판매단위"/>'				,type : 'string'} 
			,{name: 'TRANS_RATE'		,text:'<t:message code="unilite.msg.sMSR010" default="입수"/>'					,type : 'string'} 
			,{name: 'ESTI_QTY'			,text:'<t:message code="unilite.msg.sMSR004" default="견적수량"/>'				,type : 'string'} 
			,{name: 'ESTI_PRICE'		,text:'<t:message code="unilite.msg.sMSR005" default="견적단가"/>'				,type : 'string'} 
			,{name: 'ESTI_AMT'			,text:'<t:message code="unilite.msg.sMSR006" default="견적금액"/>'				,type : 'string'} 
			,{name: 'ESTI_TAX_AMT'		,text:'<t:message code="unilite.msg.sMS775" default="견적세액"/>'				,type : 'string'} 
			,{name: 'TAX_TYPE'			,text:'<t:message code="unilite.msg.sMSR289" default="과세구분"/>'				,type : 'string'} 
			,{name: 'MONEY_UNIT'		,text:'<t:message code="unilite.msg.sMSR047" default="화폐단위"/>'				,type : 'string'} 
			,{name: 'EXCHANGE_RATE' 	,text:'<t:message code="unilite.msg.sMSR031" default="환율"/>'					,type : 'string'} 
			,{name: 'WH_CODE'			,text:'<t:message code="unilite.msg.sMS698" default="창고코드"/>'				,type : 'string'} 
			,{name: 'STOCK_UNIT'		,text:'<t:message code="unilite.msg.sMS700" default="재고단위"/>'				,type : 'string'} 
			,{name: 'STOCK_CARE_YN' 	,text:'<t:message code="unilite.msg.sMS776" default="재고관리여부"/>'			,type : 'string'} 
			,{name: 'ITEM_ACCOUNT'		,text:'ITEM_ACCOUNT'	,type : 'string'} 
		]
	});

	var estimateStore = Unilite.createStore('str102ukrvEstiStore', {
			model: 'str102ukrvESTIModel',
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
					read	: 'str102ukrvService.selectEstiList'
					
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts) {
						if(successful) {
							var masterRecords = directMasterStore.data.filterBy(directMasterStore.filterNewOnly);
							var estiRecords = new Array();

							if(masterRecords.items.length > 0) {
							console.log("store.items :", store.items);
							console.log("records", records);

								Ext.each(records, 
										function(item, i) {
											Ext.each(masterRecords.items, function(record, i) {
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
			,loadStoreRecords : function() {
				var param= estimateSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	var divPrsnStore = Unilite.createStore('SOF100UKRV_DIV_PRSN', {
			fields:["value","text","option"],
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
					read	: 'salesCommonService.fnRecordCombo'
					
				}
			}
			,listeners:{
				load: function( store, records, successful, eOpts ) {
							console.log("영업담당 store",this);

							if(successful) {
								estimateSearch.setValue('ESTI_PRSN', detailForm.getValue('ORDER_PRSN'));
							}
					  }
			}
			,loadStoreRecords : function() {
				var param= { 'COMP_CODE' : UserInfo.compCode,
							 'MAIN_CODE' : 'S010',
							 'DIV_CODE' : detailForm.getValue('DIV_CODE')	,
							 'TYPE':'DIV_PRSN'
							}
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	var estimateSearch = Unilite.createSearchForm('estimateSForm', {
		
			layout :  {type : 'uniTable', columns : 2},
			items :[	Unilite.popup('AGENT_CUST',{fieldLabel:'견적처' ,  validateBlank: false})
						,{ fieldLabel: '<t:message code="unilite.msg.sMS538" default="견적번호"/>'  ,		name: 'ESTI_NUM'}
						,{ fieldLabel: '<t:message code="unilite.msg.sMS147" default="견적일"/>'
							,xtype: 'uniDateRangefield'
							,startFieldName: 'FR_ESTI_DATE'
							,endFieldName: 'TO_ESTI_DATE'	
							,width: 350
							,startDate: UniDate.get('startOfMonth')
							,endDate: UniDate.get('today')
						 }
						 ,{fieldLabel: '<t:message code="unilite.msg.sMS573" default="영업담당"/>'	, name: 'ESTI_PRSN',	xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('SOF100UKRV_DIV_PRSN') }
					]
		
	}); 
	var estimateGrid = Unilite.createGrid('str102ukrvEsitGrid', {
		// title: '기본',
		layout : 'fit',
		store: estimateStore,
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
			uniOpt:{
				onLoadSelectFirst : false
			},
		columns:  [  
					 { dataIndex: 'CUSTOM_CODE',  width: 50 } 
					,{ dataIndex: 'CUSTOM_NAME',  width: 150 } 
					,{ dataIndex: 'ESTI_DATE',  width: 110 } 
					,{ dataIndex: 'ESTI_NUM',  width: 140 } 
					,{ dataIndex: 'ESTI_SEQ',  width: 60 } 
					,{ dataIndex: 'ITEM_CODE',  width: 110 } 
					,{ dataIndex: 'ITEM_NAME',  width: 150 } 
					,{ dataIndex: 'SPEC',  width: 150 } 
					,{ dataIndex: 'ESTI_UNIT',  width: 90 } 
					,{ dataIndex: 'TRANS_RATE',  width: 60 } 
					,{ dataIndex: 'ESTI_QTY',  width: 120 } 
					,{ dataIndex: 'ESTI_PRICE',  width: 110 } 
					,{ dataIndex: 'ESTI_AMT',  width: 100 } 
					,{ dataIndex: 'ESTI_TAX_AMT',  width: 50 } 
					,{ dataIndex: 'TAX_TYPE',  width: 50 } 
					,{ dataIndex: 'MONEY_UNIT',  width: 50 } 
					,{ dataIndex: 'EXCHANGE_RATE',  width: 50 } 
					,{ dataIndex: 'WH_CODE',  width: 50 } 
					,{ dataIndex: 'STOCK_UNIT',  width: 50 } 
					,{ dataIndex: 'STOCK_CARE_YN',  width: 50 } 
					,{ dataIndex: 'ITEM_ACCOUNT',  width: 50 } 
		  ] 
		,listeners: {	
				onGridDblClick:function(grid, record, cellIndex, colName) {
					
				}
			}
		,returnData: function() {
			var records = this.getSelectedRecords();
			
			Ext.each(records, function(record,i){
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setEstiData(record.data);
									}); 
			this.deleteSelectedRow();
		}
	});

	function openEstimateWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
	
		estimateSearch.setValue('CUSTOM_CODE', detailForm.getValue('CUSTOM_CODE'));	
		estimateSearch.setValue('CUSTOM_NAME', detailForm.getValue('CUSTOM_NAME'));
		estimateSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', detailForm.getValue('ORDER_DATE')) );
		estimateSearch.setValue('TO_ESTI_DATE', detailForm.getValue('ORDER_DATE'));
		estimateSearch.setValue('DIV_CODE', detailForm.getValue('DIV_CODE'));
		divPrsnStore.loadStoreRecords(); // 사업장별 영업사원 콤보
		
		if(!EstimateWin) {
			EstimateWin = Ext.create('widget.uniDetailWindow', {
				title: '견적참조',
				width: 830,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				
				items: [estimateSearch, estimateGrid],
				tbar:  ['->',
									{	itemId : 'saveBtn',
										text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
										handler: function() {
											estimateStore.loadStoreRecords();
										},
										disabled: false
									}, 
									{	itemId : 'confirmBtn',
										text: '수주적용',
										handler: function() {
											estimateGrid.returnData();
										},
										disabled: false
									},
									{	itemId : 'confirmCloseBtn',
										text: '수주적용 후 닫기',
										handler: function() {
											estimateGrid.returnData();
											EstimateWin.hide();
										},
										disabled: false
									},{
										itemId : 'closeBtn',
										text: '<t:message code="system.label.sales.close" default="닫기"/>',
										handler: function() {
											EstimateWin.hide();
										},
										disabled: false
									}
							]
						,
			listeners : {beforehide: function(me, eOpt) {
										//estimateSearch.clearForm();
										//estimateGrid,reset();
									},
						 beforeclose: function( panel, eOpts ) {
										//estimateSearch.clearForm();
										//estimateGrid,reset();
									},
						 beforeshow: function ( me, eOpts ) {
							estimateStore.loadStoreRecords();
						 }
				}
			})
		}
		EstimateWin.show();
	}

	 
	/**
	 * 수주이력참조
	 *
	 */
	Unilite.defineModel('str102ukrvRefModel', {
		fields: [
			 { name: 'CUSTOM_CODE'			, text:'<t:message code="unilite.msg.sMS777" default="수주처"/>' ,type : 'string' } 
			,{ name: 'CUSTOM_NAME'			, text:'<t:message code="unilite.msg.sMS777" default="수주처"/>' ,type : 'string' } 
			,{ name: 'ORDER_DATE'			, text:'<t:message code="unilite.msg.sMS508" default="수주일"/>' ,type : 'string' } 
			,{ name: 'ORDER_NUM'			, text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>' ,type : 'string' } 
			,{ name: 'SER_NO'				, text:'<t:message code="unilite.msg.sMSR003" default="순번"/>' ,type : 'int' } 
			,{ name: 'ITEM_CODE'			, text:'<t:message code="unilite.msg.sMS501" default="품목코드"/>' ,type : 'string' } 
			,{ name: 'ITEM_NAME'			, text:'<t:message code="unilite.msg.sMS688" default="품명"/>' ,type : 'string' } 
			,{ name: 'SPEC'					, text:'<t:message code="unilite.msg.sMSR033" default="규격"/>' ,type : 'string' } 
			,{ name: 'ORDER_UNIT'			, text:'<t:message code="unilite.msg.sMS690" default="판매단위"/>' ,type : 'string' , comboType:'AU', comboCode:'B013', displayField: 'value'} 
			,{ name: 'TRANS_RATE'			, text:'<t:message code="unilite.msg.sMSR010" default="입수"/>' ,type : 'string' } 
			,{ name: 'ORDER_Q'				, text:'<t:message code="unilite.msg.sMS543" default="수주량"/>' ,type : 'uniQty' } 
			,{ name: 'ORDER_P'				, text:'개별단가' ,type : 'uniUnitPrice' } 
			,{ name: 'ORDER_WGT_Q'			, text:'수주량(중량)' ,type : 'uniQty' } 
			,{ name: 'ORDER_WGT_P'			, text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>' ,type : 'uniQty' } 
			,{ name: 'ORDER_VOL_Q'			, text:'수주량(부피)' ,type : 'uniUnitPrice' } 
			,{ name: 'ORDER_VOL_P'			, text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>' ,type : 'uniQty' } 
			,{ name: 'ORDER_O'				, text:'<t:message code="unilite.msg.sMS681" default="금액"/>' ,type : 'uniPrice' } 
			,{ name: 'ORDER_TAX_O'			, text:'ORDER_TAX_O'		 ,type : 'uniPrice' } 
			,{ name: 'TAX_TYPE'				, text:'TAX_TYPE'				 ,type : 'string' } 
			,{ name: 'DIV_CODE'				, text:'DIV_CODE'				 ,type : 'string' } 
			,{ name: 'OUT_DIV_CODE'			, text:'OUT_DIV_CODE'		 ,type : 'string' } 
			,{ name: 'ACCOUNT_YNC'			, text:'ACCOUNT_YNC'		 ,type : 'string' } 
			,{ name: 'SALE_CUST_CD'			, text:'SALE_CUST_CD'		 ,type : 'string' } 
			,{ name: 'SALE_CUST_NM'			, text:'SALE_CUST_NM'		 ,type : 'string' } 
			,{ name: 'PRICE_YN'				, text:'PRICE_YN'				 ,type : 'string' } 
			,{ name: 'STOCK_Q'				, text:'STOCK_Q'				 ,type : 'string' } 
			,{ name: 'DVRY_CUST_CD'			, text:'DVRY_CUST_CD'		 ,type : 'string' } 
			,{ name: 'DVRY_CUST_NAME'		, text:'DVRY_CUST_NAME'	 ,type : 'string' } 
			,{ name: 'STOCK_UNIT'			, text:'STOCK_UNIT'			 ,type : 'string' } 
			,{ name: 'WH_CODE'				, text:'WH_CODE'				 ,type : 'string' } 
			,{ name: 'STOCK_CARE_YN'		, text:'STOCK_CARE_YN'	 ,type : 'string' } 
			,{ name: 'DISCOUNT_RATE'		, text:'DISCOUNT_RATE'	 ,type : 'string' } 
			,{ name: 'ITEM_ACCOUNT'			, text:'ITEM_ACCOUNT'		 ,type : 'string' } 
			,{ name: 'PRICE_TYPE'			, text:'PRICE_TYPE'			 ,type : 'string' } 
			,{ name: 'WGT_UNIT'				, text:'WGT_UNIT'				 ,type : 'string' } 
			,{ name: 'UNIT_WGT'				, text:'UNIT_WGT'				 ,type : 'string' } 
			,{ name: 'VOL_UNIT'				, text:'VOL_UNIT'				 ,type : 'string' } 
			,{ name: 'UNIT_VOL'				, text:'UNIT_VOL' ,type : 'string' } 
			,{ name: 'SO_KIND'				, text:'SO_KIND' ,type : 'string' } 
		]
	});

	var refStore = Unilite.createStore('str102ukrvRefStore', {
		model: 'str102ukrvRefModel',
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
				read	: 'str102ukrvService.selectRefList'
				
			}
		}
		,loadStoreRecords : function() {
			var param= refSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var refSearch = Unilite.createSearchForm('RefSForm', {
			layout :  {type : 'uniTable', columns : 3},
			items :[	Unilite.popup('AGENT_CUST',{fieldLabel:'<t:message code="system.label.sales.soplace" default="수주처"/>' ,  validateBlank: false})
						,Unilite.popup('ITEM',{  validateBlank: false, colspan:2})					
						,{ fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>'
							,xtype: 'uniDateRangefield'
							,startFieldName: 'FR_ORDER_DATE'
							,endFieldName: 'TO_ORDER_DATE'	
							,width: 350
							,startDate: UniDate.get('startOfMonth')
							,endDate: UniDate.get('today')
						 }
						 ,{fieldLabel: '<t:message code="unilite.msg.sMS573" default="영업담당"/>'		, name: 'ORDER_PRSN',	xtype:'uniCombobox', comboType:'AU', comboCode:'S010'}
						 ,{fieldLabel: '최근수주'		, name: 'RDO_YN',	xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010' , width:235, allowBlank:false, value:'Y'}
					]
	}); 

	var refGrid = Unilite.createGrid('str102ukrvRefGrid', {
		// title: '기본',
		layout : 'fit',
		store: refStore,
		selModel :	Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
			uniOpt:{
				onLoadSelectFirst : false
			},
		columns:  [  
					 { dataIndex: 'CUSTOM_CODE',  width: 50 , hidden:true} 
					,{ dataIndex: 'CUSTOM_NAME',  width: 110 } 
					,{ dataIndex: 'ORDER_DATE',  width: 80 } 
					,{ dataIndex: 'ORDER_NUM',  width: 100 } 
					,{ dataIndex: 'SER_NO',  width: 60 } 
					,{ dataIndex: 'ITEM_CODE',  width: 00 } 
					,{ dataIndex: 'ITEM_NAME',  width: 110 } 
					,{ dataIndex: 'SPEC',  width: 130 } 
					,{ dataIndex: 'ORDER_UNIT',  width: 80, align: 'center' } 
					,{ dataIndex: 'TRANS_RATE',  width: 60 } 
					,{ dataIndex: 'ORDER_Q',  width: 90 } 
					,{ dataIndex: 'ORDER_P',  width: 80 } 
					,{ dataIndex: 'ORDER_WGT_Q',  width: 90 } 
					,{ dataIndex: 'ORDER_WGT_P',  width: 90 } 
					,{ dataIndex: 'ORDER_VOL_Q',  width: 90 } 
					,{ dataIndex: 'ORDER_VOL_P',  width: 90 } 
					,{ dataIndex: 'ORDER_O',  width: 90 } 
					,{ dataIndex: 'ORDER_TAX_O',  width: 50 , hidden:true} 
					,{ dataIndex: 'TAX_TYPE',  width: 50 , hidden:true} 
					,{ dataIndex: 'DIV_CODE',  width: 50 , hidden:true} 
					,{ dataIndex: 'OUT_DIV_CODE',  width: 50 , hidden:true} 
					,{ dataIndex: 'ACCOUNT_YNC',  width: 50 , hidden:true} 
					,{ dataIndex: 'SALE_CUST_CD',  width: 50 , hidden:true} 
					,{ dataIndex: 'SALE_CUST_NM',  width: 50 , hidden:true} 
					,{ dataIndex: 'PRICE_YN',  width: 50 , hidden:true} 
					,{ dataIndex: 'STOCK_Q',  width: 50 , hidden:true} 
					,{ dataIndex: 'DVRY_CUST_CD',  width: 50 , hidden:true} 
					,{ dataIndex: 'DVRY_CUST_NAME',  width: 50 , hidden:true} 
					,{ dataIndex: 'STOCK_UNIT',  width: 50 , hidden:true} 
					,{ dataIndex: 'WH_CODE',  width: 50 , hidden:true} 
					,{ dataIndex: 'STOCK_CARE_YN',  width: 50 , hidden:true} 
					,{ dataIndex: 'DISCOUNT_RATE',  width: 50 , hidden:true} 
					,{ dataIndex: 'ITEM_ACCOUNT',  width: 50 , hidden:true} 
					,{ dataIndex: 'PRICE_TYPE',  width: 50 , hidden:true} 
					,{ dataIndex: 'WGT_UNIT',  width: 50 , hidden:true} 
					,{ dataIndex: 'UNIT_WGT',  width: 50 , hidden:true} 
					,{ dataIndex: 'VOL_UNIT',  width: 50 , hidden:true} 
					,{ dataIndex: 'UNIT_VOL',  width: 50 , hidden:true} 
					,{ dataIndex: 'SO_KIND',  width: 50 , hidden:true} 
		]
		,listeners: {	
				onGridDblClick:function(grid, record, cellIndex, colName) {
					
				}
			}
		,returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setRefData(record.data);
									}); 
			this.deleteSelectedRow();
		}
	});

	function openRefWindow() {
			if(!UniAppManager.app.checkForNewDetail()) return false;
			
			refSearch.setValue('CUSTOM_CODE', detailForm.getValue('CUSTOM_CODE'));
			refSearch.setValue('CUSTOM_NAME', detailForm.getValue('CUSTOM_NAME'));
			refSearch.setValue('ORDER_PRSN', detailForm.getValue('ORDER_PRSN'));
			
			if(!RefWin) {
				RefWin = Ext.create('widget.uniDetailWindow', {
					title: '수주이력참조',
					width: 830,
					height: 580,
					layout:{type:'vbox', align:'stretch'},
					
					items: [refSearch, refGrid],
					tbar:  ['->',
											{	itemId : 'saveBtn',
												text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
												handler: function() {
													refStore.loadStoreRecords();
												},
												disabled: false
											}, 
											{	itemId : 'confirmBtn',
												text: '수주적용',
												handler: function() {
													refGrid.returnData();
												},
												disabled: false
											},
											{	itemId : 'confirmCloseBtn',
												text: '수주적용 후 닫기',
												handler: function() {
													refGrid.returnData();
													RefWin.hide();
												},
												disabled: false
											},{
												itemId : 'closeBtn',
												text: '<t:message code="system.label.sales.close" default="닫기"/>',
												handler: function() {
													RefWin.hide();
												},
												disabled: false
											}
									]
								,
					listeners : {beforehide: function(me, eOpt) {
												//refSearch.clearForm();
												//refGrid.reset();
											},
								 beforeclose: function( panel, eOpts ) {
												//RefSearch.clearForm();
												//refGrid.reset();
											},
								  beforeshow: function ( me, eOpts ) {
									refStore.loadStoreRecords();
								 }
					}
				})
			}
			RefWin.show();
	}

	/**
	 * 수주번호 검색 팝업
	 */
	Unilite.defineModel('orderNoMasterModel', {
		fields: [
					 { name: 'COMP_CODE'				,text:'COMP_CODE'				,type : 'string'} 
					,{ name: 'DIV_CODE'					,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'			,type: 'string' ,comboType:'BOR120'} 
					,{ name: 'CUSTOM_CODE'				,text:'<t:message code="system.label.sales.custom" default="거래처"/>' 		,type: 'string' } 
					,{ name: 'CUSTOM_NAME'				,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'		,type: 'string' } 
					,{ name: 'ORDER_DATE'				,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'		,type: 'uniDate'} 
					,{ name: 'ORDER_NUM'				,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>' 	,type: 'string' } 
					,{ name: 'ORDER_TYPE'				,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'		,type: 'string' ,comboType:'AU', comboCode:'S002'} 
					,{ name: 'ORDER_PRSN'				,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'		,type: 'string' ,comboType:'AU', comboCode:'S010'} 
					,{ name: 'PJT_CODE'					,text:'<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'													,type: 'string' } 
					,{ name: 'PJT_NAME'					,text:'<t:message code="system.label.sales.project" default="프로젝트"/>'														,type: 'string' } 
					,{ name: 'ORDER_Q'					,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'		,type: 'uniQty' } 
					,{ name: 'ORDER_O'					,text:'수주금액'														,type: 'uniPrice' }
				]
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
			model: 'orderNoMasterModel',
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
					read	: 'str102ukrvService.selectOrderNumMasterList'
				}
			}
			,loadStoreRecords : function() {
				var param= orderNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	Unilite.defineModel('orderNoDetailModel', {
		fields: [
				 { name: 'DIV_CODE'	 ,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'			,type: 'string' ,comboType:'BOR120'} 
				,{ name: 'ITEM_CODE'	,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>' 		,type: 'string' } 
				,{ name: 'ITEM_NAME'	,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'		,type: 'string' } 
				,{ name: 'SPEC'		,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>' 	,type: 'string' } 
				,{ name: 'ORDER_DATE'	,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'		,type: 'uniDate'} 
				,{ name: 'DVRY_DATE'	,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'		,type: 'uniDate'} 
				,{ name: 'ORDER_Q'		,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'		,type: 'uniQty' } 
				,{ name: 'ORDER_TYPE'	,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'		,type: 'string' ,comboType:'AU', comboCode:'S002'} 
				,{ name: 'ORDER_PRSN'	,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'		,type: 'string' ,comboType:'AU', comboCode:'S010'} 
				,{ name: 'PO_NUM'		,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>' 		,type: 'string' }
				,{ name: 'PROJECT_NO'	,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>' 		,type: 'string' }
				,{ name: 'ORDER_NUM'	,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>' 	,type: 'string' } 
				,{ name: 'SER_NO'		,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>' 		,type: 'string' }
				,{ name: 'CUSTOM_CODE'	,text:'<t:message code="system.label.sales.custom" default="거래처"/>' 		,type: 'string' } 
				,{ name: 'CUSTOM_NAME'  ,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'		,type: 'string' } 
				,{ name: 'COMP_CODE'	,text:'COMP_CODE'		,type: 'string' } 
				,{ name: 'PJT_CODE'		,text:'<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'													,type: 'string' } 
				,{ name: 'PJT_NAME'		,text:'<t:message code="system.label.sales.project" default="프로젝트"/>'														,type: 'string' } 
			]
	});

	var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
			model: 'orderNoDetailModel',
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
					read	: 'str102ukrvService.selectOrderNumDetailList'
				}
			}
			,loadStoreRecords : function() {
				var param= orderNoSearch.getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
			layout : {type : 'uniTable', columns : 3},
			trackResetOnLoad:true,
			items :[	 { fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>'  ,		name: 'DIV_CODE',	xtype:'uniCombobox', comboType:'BOR120', value:UserInfo.divCode, allowBlank:false}
						,{ fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>'
							,xtype: 'uniDateRangefield'
							,startFieldName: 'FR_ORDER_DATE'
							,endFieldName: 'TO_ORDER_DATE'	
							,width: 350
							,startDate: UniDate.get('startOfMonth')
							,endDate: UniDate.get('today')
							,colspan:2
						 }
						,{fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>'		, name: 'ORDER_PRSN',	xtype:'uniCombobox',comboType:'AU', comboCode:'S010'}	
						,Unilite.popup('AGENT_CUST',{fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' , validateBlank: false,colspan:2})
						,Unilite.popup('AGENT_CUST',{fieldLabel:'<t:message code="system.label.sales.project" default="프로젝트"/>' , valueFieldName:'PROJECT_NO', textFieldName:'PROJECT_NAME', validateBlank: false})
						,Unilite.popup('ITEM',{colspan:2})
						,{fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>'		, name: 'ORDER_TYPE',	xtype:'uniCombobox',comboType:'AU', comboCode:'S002'}
						,{fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>'			, name: 'PO_NUM'}
						,{fieldLabel: '<t:message code="system.label.sales.inquiryclass" default="조회구분"/>'	,xtype:'uniRadiogroup', allowBlank:false,  width:235, name:'RDO_TYPE'
							,items:[
										 {boxLabel:'<t:message code="system.label.sales.master" default="마스터"/>', name:'RDO_TYPE'		, inputValue:'master', checked:true},
										 {boxLabel:'<t:message code="system.label.sales.detail" default="디테일"/>', name:'RDO_TYPE'		, inputValue:'detail'}
								  ]
							,listeners: { change : function( field, newValue, oldValue, eOpts ) {
													 if(newValue.RDO_TYPE=='detail') {
														if(orderNoMasterGrid) orderNoMasterGrid.hide();
														if(orderNoDetailGrid) orderNoDetailGrid.show();
													 }else {
														if(orderNoDetailGrid) orderNoDetailGrid.hide();
														if(orderNoMasterGrid) orderNoMasterGrid.show();
													 }
										}
							}
						}
						
					]
		
	}); // createSearchForm

	/**
	 * 수주번호 검색 Master Grid 정의(Grid Panel)
	 * 
	 * @type
	 */ 
	var orderNoMasterGrid = Unilite.createGrid('str102ukrvOrderNoGrid', {
		// title: '기본',
		layout : 'fit',		
		store: orderNoMasterStore,
		uniOpt:{
					useRowNumberer: false
		},
		columns:  [ 
					 { dataIndex: 'DIV_CODE',  width: 80 } 
					,{ dataIndex: 'CUSTOM_NAME',  width: 150 } 
					,{ dataIndex: 'ORDER_DATE',  width: 80 } 
					,{ dataIndex: 'ORDER_NUM',  width: 120 } 
					,{ dataIndex: 'ORDER_TYPE',  width: 80 } 
					,{ dataIndex: 'ORDER_PRSN',  width: 80 } 
					,{ dataIndex: 'PJT_NAME',  width: 150 } 
					,{ dataIndex: 'ORDER_Q',  width: 110 } 
					,{ dataIndex: 'ORDER_O',  width: 120 }
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
					orderNoMasterGrid.returnData(record);
					UniAppManager.app.onQueryButtonDown();
					orderNoWin.hide();
			}
		} // listeners
		,returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			detailForm.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
		}
	});

	var orderNoDetailGrid = Unilite.createGrid('str102ukrvOrderNoDetailGrid', {
		// title: '기본',
		layout : 'fit',
		store: orderNoDetailStore,
		uniOpt:{
			useRowNumberer: false
		},
		hidden : true,
		columns:  [ 
			 { dataIndex: 'DIV_CODE',  width: 80 } 
			,{ dataIndex: 'ITEM_CODE',  width: 120 } 
			,{ dataIndex: 'ITEM_NAME',  width: 150 } 
			,{ dataIndex: 'SPEC',  width: 150 } 
			,{ dataIndex: 'ORDER_DATE',  width: 80 } 
			,{ dataIndex: 'DVRY_DATE',  width: 80 , hidden:true} 
			,{ dataIndex: 'ORDER_Q',  width: 80 } 
			,{ dataIndex: 'ORDER_TYPE',  width: 90 } 
			,{ dataIndex: 'ORDER_PRSN',  width: 90 , hidden:true} 
			,{ dataIndex: 'PO_NUM',  width: 100 } 
			,{ dataIndex: 'PROJECT_NO',  width: 90 } 
			,{ dataIndex: 'ORDER_NUM',  width: 120 } 
			,{ dataIndex: 'SER_NO',  width: 70 , hidden:true} 
			,{ dataIndex: 'CUSTOM_CODE',  width: 120 , hidden:true} 
			,{ dataIndex: 'CUSTOM_NAME',  width: 200 } 
			,{ dataIndex: 'COMP_CODE',  width: 80 ,hidden:true} 
			,{ dataIndex: 'PJT_CODE',  width: 120 , hidden:true} 
			,{ dataIndex: 'PJT_NAME',  width: 200 } 
		] ,
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
					orderNoDetailGrid.returnData(record)
					UniAppManager.app.onQueryButtonDown();
					orderNoWin.hide();
			}
		} // listeners
		,returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			detailForm.setValues({'DIV_CODE':record.get('DIV_CODE'), 'ORDER_NUM':record.get('ORDER_NUM')});
		}
	});

	function openOrderNoWindow() {
		if(!orderNoWin) {
			orderNoWin = Ext.create('widget.uniDetailWindow', {
				title: '수주번호검색',
				width: 830,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
				tbar:  ['->',
										{	itemId : 'saveBtn',
											text: '<t:message code="system.label.sales.inquiry" default="조회"/>',
											handler: function() {
												var rdoType = orderNoSearch.getValue('RDO_TYPE');
												console.log('rdoType : ',rdoType)
												if(rdoType.RDO_TYPE=='master') {
													orderNoMasterStore.loadStoreRecords();
												}else {
													orderNoDetailStore.loadStoreRecords();
												}
											},
											disabled: false
										}, {
											itemId : 'OrderNoCloseBtn',
											text: '<t:message code="system.label.sales.close" default="닫기"/>',
											handler: function() {
												orderNoWin.hide();
											},
											disabled: false
										}
								],
				listeners : {beforehide: function(me, eOpt) {
											orderNoSearch.clearForm();
											orderNoMasterGrid.reset();
											orderNoDetailGrid.reset();
										},
							beforeclose: function( panel, eOpts ) {
											orderNoSearch.clearForm();
											orderNoMasterGrid.reset();
											orderNoDetailGrid.reset();
										},
							show: function( panel, eOpts ) {
								orderNoSearch.setValue('DIV_CODE',detailForm.getValue('DIV_CODE'));
								orderNoSearch.setValue('ORDER_PRSN',detailForm.getValue('ORDER_PRSN'));
								orderNoSearch.setValue('CUSTOM_CODE',detailForm.getValue('CUSTOM_CODE'));
								orderNoSearch.setValue('CUSTOM_NAME',detailForm.getValue('CUSTOM_NAME'));
								orderNoSearch.setValue('ORDER_TYPE',detailForm.getValue('ORDER_TYPE'));
								orderNoSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth', detailForm.getValue('ORDER_DATE')));
								orderNoSearch.setValue('TO_ORDER_DATE',detailForm.getValue('ORDER_DATE'));
								
							}
				}
			})
		}
		orderNoWin.show();
	}
	

	/**
	 * main app
	 */
	Unilite.Main( {
		id		: 'str102ukrvApp',
		items	: [ detailForm, discountSearch, masterGrid],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev','next'],true)
			this.setDefault();
		},
		onQueryButtonDown:function () {
			detailForm.setAllFieldsReadOnly(false);
			var orderNo = detailForm.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				openOrderNoWindow() 
			} else {
				var param= detailForm.getValues();
				detailForm.getForm().load({params : param})
				directMasterStore.loadStoreRecords();	
			}
		},
		onNewDataButtonDown: function() {
			if(!this.checkForNewDetail()) return false;
			/**
			 * Detail Grid Default 값 설정
			 */
			var orderNum = detailForm.getValue('ORDER_NUM')

			var seq = directMasterStore.max('SER_NO');
			if(!seq) seq = 1;
			else  seq += 1;

			var taxType ='1';
			if(detailForm.getValue('BILL_TYPE')=='50') {
				taxType ='2';
			}

			var dvryDate = '';
			if(!Ext.isEmpty(detailForm.getValue('DVRY_DATE'))) {
				dvryDate=detailForm.getValue('DVRY_DATE');
			}else {
				dvryDate= new Date();
			}

			var saleCustCd = '';
			if(!Ext.isEmpty(detailForm.getValue('SALE_CUST_CD'))) {
				saleCustCd=detailForm.getValue('SALE_CUST_CD');
			}

			var custName = '';
			if(!Ext.isEmpty(detailForm.getValue('SALE_CUST_NM'))) {
				custName=detailForm.getValue('SALE_CUST_NM');
			}

			var refOrderDate = '';
			if(!Ext.isEmpty(detailForm.getValue('ORDER_DATE'))) {
				refOrderDate=detailForm.getValue('ORDER_DATE');
			}

			var refOrdCust = '';
			if(!Ext.isEmpty(detailForm.getValue('CUSTOM_CODE'))) {
				refOrdCust=detailForm.getValue('CUSTOM_CODE');
			}

			var refOrderType = '';
			if(!Ext.isEmpty(detailForm.getValue('ORDER_TYPE'))) {
				refOrderType=detailForm.getValue('ORDER_TYPE');
			}

			var projectNo = '';
			if(!Ext.isEmpty(detailForm.getValue('PLAN_NUM'))) {
				projectNo=detailForm.getValue('PLAN_NUM');
			}

			var refBillType = '';
			if(!Ext.isEmpty(detailForm.getValue('BILL_TYPE'))) {
				refBillType=detailForm.getValue('BILL_TYPE');
			}

			var refReceiptSetMeth = '';
			if(!Ext.isEmpty(detailForm.getValue('RECEIPT_METH'))) {
				refReceiptSetMeth=detailForm.getValue('RECEIPT_METH');
			}

			//var r =  Ext.create ('str102ukrvModel', {
			var r = {
				ORDER_NUM			: orderNum,
				SER_NO				: seq,
				TAX_TYPE			: taxType,
				DVRY_DATE			: dvryDate,
				SALE_CUST_CD		: saleCustCd,
				CUSTOM_NAME			: custName,
				REF_ORDER_DATE		: refOrderDate,
				REF_ORD_CUST		: refOrdCust,
				REF_ORDER_TYPE		: refOrderType,
				PROJECT_NO			: projectNo,
				REF_BILL_TYPE		: refBillType,
				REF_RECEIPT_SET_METH: refReceiptSetMeth
			};
			masterGrid.createRow(r, 'ITEM_CODE', directMasterStore.data.length-1);
			//directMasterStore.insert(seq-1, r);
			//masterGrid.select(seq-1);
			detailForm.setAllFieldsReadOnly(true);
		},
		onResetButtonDown:function() {
			detailForm.clearForm();
			detailForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			this.fnInitBinding();
			detailForm.getField('CUSTOM_CODE').focus();
		},
		onSaveDataButtonDown: function (config) {
			var orderNo = detailForm.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				if(directMasterStore.data.length == 0) {
					Unilite.messageBox('수주상세정보를 입력하세요.');
					return;
				}
			}
			/**
			 * 여신한도 확인
			 */ 
			if(!detailForm.fnCreditCheck()) {
				return ;
			}
			var param= detailForm.getValues();
			detailForm.getForm().submit({
				params : param,
				success : function(form, action) {
					detailForm.setValue("ORDER_NUM", action.result.ORDER_NUM);
					if(directMasterStore.isDirty()) {
						directMasterStore.saveStore(config);
					}else {
						detailForm.getForm().wasDirty = false;
						detailForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.");
						Ext.getBody().unmask();
					}
				}
			});
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {
					Unilite.messageBox('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				}else {
					masterGrid.deleteSelectedRow();
				}
			}
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('str102ukrvAdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore.rejectChanges();

			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected		= masterGrid.getSelectedRecord();
				var selected_doc_no	= selected.data['DOC_NO'];
				bdc100ukrvService.getFileList({DOC_NO : selected_doc_no}, function(provider, response) {
				});
			}
			directMasterStore.onStoreActionEnable();
		},
		confirmSaveData: function(config) {
			var fp = Ext.getCmp('str102ukrvFileUploadPanel');
			if(directMasterStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			detailForm.setValue('DIV_CODE'	, UserInfo.divCode);
			detailForm.setValue('ORDER_DATE', new Date());
			detailForm.setValue('TAX_TYPE'	, '1');
			detailForm.setValue('STATUS'	, '1');

			if( BsaCodeInfo.gsCreditYn == 'N') {
				detailForm.getField('REMAIN_CREDIT').uniSetDisplayed(true);
			}

			if(BsaCodeInfo.gsAutoType=='Y') {
			}else {
				detailForm.getField('ORDER_NUM').setReadOnly(false);
			}

			var billType	= detailForm.getField('BILL_TYPE');
			var orderType	= detailForm.getField('ORDER_TYPE');
			var receiptMeth	= detailForm.getField('RECEIPT_METH');

			detailForm.getForm().wasDirty = false;
			detailForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);	
		},
		checkForNewDetail:function() {
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(detailForm.getValue('ORDER_NUM'))) {
				Unilite.messageBox('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			
			/**
			 * 여신한도 확인
			 */ 
			if(!detailForm.fnCreditCheck()) {
				return false;
			}
			
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return detailForm.setAllFieldsReadOnly(true);
		},
		fnOrderAmtCal: function(rtnRecord, sType, nValue) {
			var dTransRate= sType=='R' ? nValue : Unilite.nvl(rtnRecord.get('TRANS_RATE'),1);
			var dOrderQ= sType=='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q'),0);
			var dOrderP= sType=='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_P'),0); //단가
			var dOrderO= sType=='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O'),0); //금액
			var dDcRate= sType=='C' ? nValue : Unilite.nvl(rtnRecord.get('DISCOUNT_RATE'),0); 

			if(sType == 'P' || sType == 'Q') {	//업종별 프로세스 적용
				var dOrderUnitQ = 0;
				if(BsaCodeInfo.gsProcessFlag == 'PG') {
					dOrderO = dOrderQ * dOrderP * dTransRate;
				}else {
					dOrderO = dOrderQ * dOrderP;
				}
				dOrderUnitQ = dOrderQ * dTransRate;
				rtnRecord.set('ORDER_O', dOrderO);
				rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
				this.fnTaxCalculate(rtnRecord, dOrderO)
			}else if(sType == 'R' ) {
				dOrderUnitQ = dOrderQ * dTransRate;
				rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
			}else if(sType == 'O' ) {
				if(BsaCodeInfo.gsProcessFlag == 'PG') {
					dOrderP =dOrderO / (dOrderQ * dTransRate);
				}else {
					dOrderP = dOrderO / dOrderQ;
				}
				rtnRecord.set('ORDER_P', dOrderP);
				this.fnTaxCalculate(rtnRecord, dOrderO)
			}else if(sType == 'C' ) {
				dOrderP = (dOrderP - (dOrderP * (dDcRate / 100)));
				rtnRecord.set('ORDER_P', dOrderP);
				if(BsaCodeInfo.gsProcessFlag == 'PG') {
					dOrderO = dOrderQ * dOrderP * dTransRate ;
				}else {
					dOrderO = dOrderQ * dOrderP
				}
				this.fnTaxCalculate(rtnRecord, dOrderO)
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO) {
			var sTaxType = rtnRecord.get('TAX_TYPE');
			var sTaxInoutType = detailForm.getValue('TAX_TYPE').TAX_TYPE;
			var dVatRate = parseInt(BsaCodeInfo.gsVatRate);
			var dOrderAmtO = 0;
			var dTaxAmtO = 0;
			var dAmountI = 0;

			if(sTaxInoutType=="1") {
				dOrderAmtO = dOrderO;
				dTaxAmtO	= dOrderO * dVatRate / 100
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderAmtO, CustomCodeInfo.gsUnderCalBase);
				if(UserInfo.compCountry == 'CN') {
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO	= UniSales.fnAmtWonCalca(dTaxAmtO, '3');
				}else {
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO	= UniSales.fnAmtWonCalca(dTaxAmtO, CustomCodeInfo.gsUnderCalBase);
				}
			}else if(sTaxInoutType=="2") {
				dAmountI = dOrderO;
				if(UserInfo.compCountry == 'CN') {
					dTemp	  = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, '3');
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO	= UniSales.fnAmtWonCalca(dTemp * dVatRate / 100, '3');
				}else {
					dTemp	  = UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, CustomCodeInfo.gsUnderCalBase);
					//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
					dTaxAmtO	= UniSales.fnAmtWonCalca(dTemp * dVatRate / 100, CustomCodeInfo.gsUnderCalBase);
				}
				dOrderAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsUnderCalBase);
			}
			if(sTaxType == "2") {
				dOrderAmtO = UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase );
				dTaxAmtO = 0;
			}
			rtnRecord.set('ORDER_O',dOrderAmtO);
			rtnRecord.set('ORDER_TAX_O',dTaxAmtO);
			rtnRecord.set('ORDER_O_TAX_O',dOrderAmtO+dTaxAmtO);
		},
		fnCheckNum: function(value, record, fieldName) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
				r = true;
			}else if(record.get("PRICE_YN") == "2" ) {
				if(value < 0) {
					Unilite.messageBox(Msg.sMB076);
					r=false;
					return r;
				}else if(value == 0) {
					if(fieldName == "ORDER_TAX_O") {
						if(BsaCodeInfo.gsVatRate != 0) {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
							r=false;
						}
					}else {
						Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
						r=false;
					}
				}
			}
			return r;
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "DVRY_TIME" :
					//fnGetTimeChk(grdSheet1.TextMatrix(Row, grdSheet1.colindex("DVRY_TIME")))
					var regex=/^(2[0-3])|[01][0-9]:[0-5][0-9]$/;
					if(!regex.test(newValue)) {
						rv=Msg.fSbMsgZ0003;
						record.set('DVRY_TIME', oldValue);
					}
					break;

				case "OUT_DIV_CODE" :
					var itemCode = record.get('ITEM_CODE');
					if(itemCode != "") {
						Ext.getBody().mask();
						var param = {'DIV_CODE':newValue, 'ITEM_CODE':itemCode, 'S_COMP_CODE':UserInfo.compCode, 'USELIKE':false};
						popupService.itemPopup(param, function(provider, response) {
							if(Ext.isEmpty(provider)) {
								Unilite.messageBox(Msg.sMS288);
								Ext.getBody().unmask();
							}else {
								console.log("provider",provider)
								if(!Ext.isEmpty('provider')) masterGrid.setItemData(provider[0],false);	
								else setItemData(null, true);	
								//UniSales.fnStockQ(record, UserInfo.compCode, newValue, null, record.get('ITEM_CODE'),  record.get('REF_WH_CODE'));
								
							}
						});
						outDivCode=newValue;
						break;
					}
					if(Ext.isEmpty(newValue))  record.get("DIV_CODE") =	newValue;

					break;

				case "ORDER_UNIT" :
					UniSales.fnGetPriceInfo(record
													, 'I'
													, UserInfo.compCode
													, detailForm.getValue('CUSTOM_CODE')
													, CustomCodeInfo.gsAgentType
													, record.get('ITEM_CODE')
													, BsaCodeInfo.gsMoneyUnit
													, record.get('ORDER_UNIT')
													, record.get('STOCK_UNIT')
													, record.get('TRANS_RATE')
													, detailForm.getValue('ORDER_DATE')
													, record.get('ORDER_Q')
													, record.get('WGT_UNIT')
													, record.get('VOL_UNIT')
													, record.get('UNIT_WGT')
													, record.get('UNIT_VOL')
													, record.get('PRICE_TYPE')
													);
					break;

				case "TRANS_RATE" :
					if(newValue <= 0) {
						rv=Msg.sMB076;
						record.set('TRANS_RATE',oldValue);
						break
					}
					UniSales.fnGetPriceInfo(record
											,'R'
											,UserInfo.compCode
											,detailForm.getValue('CUSTOM_CODE')
											,CustomCodeInfo.gsAgentType
											,record.get('ITEM_CODE')
											,BsaCodeInfo.gsMoneyUnit
											,record.get('ORDER_UNIT')
											,record.get('STOCK_UNIT')
											,record.get('TRANS_RATE')
											,detailForm.getValue('ORDER_DATE')
											,record.get('ORDER_Q')
											, record.get('WGT_UNIT')
											, record.get('VOL_UNIT')
											, record.get('UNIT_WGT')
											, record.get('UNIT_VOL')
											, record.get('PRICE_TYPE')
											)
					UniAppManager.app.fnOrderAmtCal(record, "R", newValue);
					break;

				case "ORDER_Q" :
					if(!UniAppManager.app.fnCheckNum(newValue, record)) {
						record.set('ORDER_Q',oldValue, fieldName);
						break;
					}
					var sOrderQ = Unilite.nvl(newValue,0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q'),0);
					if(sOrderQ < sIssueQ) {
						rv = Msg.sMS286;
						break;
					}
					var dStockQ = 0;
					var dOrderQ = 0;
					var dProdSaleQ = 0;
					var lTrnsRate = record.get('TRANS_RATE');

					if(Ext.isNumeric(record.get('STOCK_Q')))	dStockQ = record.get('STOCK_Q');
					if(Ext.isNumeric(record.get('ORDER_Q')))	dOrderQ = record.get('ORDER_Q');

					if(dStockQ > 0) {
						if(dStockQ > dOrderQ) {					//재고량 > 수주량
							record.set('PROD_SALE_Q', 0);
							record.set('PROD_Q', 0);
							record.set('PROD_END_DATE', '');
						}else if(dStockQ <= dOrderQ) {		//재고량 <= 수주량
							dProdQ = (dOrderQ * lTrnsRate - dStockQ) / lTrnsRate ;
							dProdSaleQ = (dOrderQ * lTrnsRate - dStockQ)
							record.set('PROD_SALE_Q', dProdSaleQ);
							record.set('PROD_Q', dProdQ);		
							if(dProdSaleQ == 0) {
								record.set('PROD_END_DATE', '');
							}else {
								record.set('PROD_END_DATE', record.get('DVRY_DATE'));
							}
						}
					}else if(dStockQ <= 0 ) {
						record.set('PROD_SALE_Q', dOrderQ);
						record.set('PROD_Q', dOrderQ * lTrnsRate);
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue);

					if(BsaCodeInfo.gsProdtDtAutoYN == 'Y') {
						var dProdtQ =Unilite.nvl(record.get('PROD_SALE_Q'), 0);
						if(dProdtQ > 0) {
							record.set('PROD_END_DATE', record.get('DVRY_DATE'));
						}
					}
					break;

				case "ORDER_P" :
					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName) ) {
						record.set('ORDER_P',oldValue);
						break;
					}
					UniAppManager.app.fnOrderAmtCal(record, "P", newValue)
					record.set('DISCOUNT_RATE', 0);
					break;

				case "ORDER_O" :
					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName) ) {
						record.set('ORDER_O',oldValue);
						break;
					}
					var dTaxAmtO = Unilite.nvl(record.get('ORDER_TAX_O'),0); 
					if(newValue > 0 && dTaxAmtO > newValue) {
						rv=Msg.sMS224;
					}else {
						UniAppManager.app.fnOrderAmtCal(record, "O", newValue);
					}
					break;

				case "TAX_TYPE" :
					if(detailForm.getValue('BILL_TYPE')=="50") {
						rv=Msg.sMS313;
						record.set('TAX_TYPE', '2');
					}
					//업종별 프로세스 적용
					if(BsaCodeInfo.gsProcessFlag == 'PG') {
						var dOrderQ=record.get('ORDER_Q')*record.get('ORDER_P')*record.get('TRANS_RATE');
						record.set('ORDER_O', dOrderQ);
					}else {
						var dOrderQ=record.get('ORDER_Q')*record.get('ORDER_P');
						record.set('ORDER_O', dOrderQ);
					}
					UniAppManager.app.fnOrderAmtCal(record, "O", dOrderQ);
					break;

				case "ORDER_TAX_O" :
					if(!UniAppManager.app.fnCheckNum(newValue, record, fieldName)) {
						record.set('ORDER_TAX_O', oldValue);
					}
					var dSaleAmtO = Unilite.nvl(record.get('ORDER_O'),0);
					if(dSaleAmtO > 0) {
						if( dSaleAmtO < newValue) {
							rv=Msg.sMS226;
							break;
						}
					}
					var dOrderOTaxO = record.get('ORDER_O')+record.get('ORDER_TAX_O');
					record.set('ORDER_O_TAX_O', dOrderOTaxO);
					break;

				case "DVRY_DATE" :
					if(record.get('DVRY_DATE') < detailForm.getValue('ORDER_DATE')) {
						rv = Msg.sMS217;
						break;
					}
					if(Ext.isNumeric(record.get('PROD_SALE_Q')) && record.get('PROD_SALE_Q')==0) {
						record.set('PROD_END_DATE', '');
					}else {
						record.set('PROD_END_DATE', record.get('DVRY_DATE'));
					}
					break;

				case "DISCOUNT_RATE" :
					if(newValue < 0) {
						rv=Msg.sMB076;
						record.set('DISCOUNT_RATE', oldValue);
						break;
					}
					UniAppManager.app.fnOrderAmtCal(record, "C", newValue);
					break;

				case "ACCOUNT_YNC" :
					if(record.phantom && !Ext.isEmpty(record.get('PRE_ACCNT_YN'))) {
						if(newValue != record.get('PRE_ACCNT_YN')) {
							if(confirm(Msg.sMS251+'/n'+Msg.sMS357)) {
								record.set('REF_FLAG', newValue);
							}else {
								record.set('REF_FLAG', 'F');
							}
						}else {
							record.set('REF_FLAG', 'F');
						}
					}
					break;

				case "PROD_SALE_Q" :
					if(!Ext.isEmpty(record.get('PROD_END_DATE'))) {
						if(Ext.isEmpty(newValue) || newValue == 0) {
							rv='<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>';
						}
						break;
					}
					var lTrnsRate = record.get("TRANS_RATE");
					var chkValue=0;
					var dProdQ=0;

					if(newValue  < 0 ) {
						rv = Msg.sMB076;
						record.set('PROD_SALE_Q', oldValue);
						if(Ext.isEmpty(oldValue))	oldValue = 0;
						record.set('PROD_Q', (oldValue*lTrnsRate));
						break;
					}

					if(!Ext.isNumeric(newValue) || newValue==0) {
						record.set('PROD_END_DATE','');
						record.set('PROD_SALE_Q',0);
						record.set('PROD_Q',0);
					}else {
						record.set('PROD_END_DATE',record.get('DVRY_DATE'));
						record.set('PROD_Q',(newValue*lTrnsRate) );
					}
					break;

				case "PROD_END_DATE" :
					if( Ext.isEmpty(newValue) )	record.set('PROD_END_DATE', oldValue);
					break;

					if(newValue < detailForm.getValue('ORDER_DATE')) {
						rv = Msg.sMS217;
						record.set('PROD_END_DATE', record.get('DVRY_DATE'));
						break;
					}

					if(newValue > record.get('DVRY_DATE')) {
						rv = Msg.sMS218;
						record.set('PROD_END_DATE', record.get('DVRY_DATE'));
						break;
					}
					break;
			}
			return rv;
		}
	}); // validator
}
</script>