<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa600skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa600skrv"  /> <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->	
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 세금계산서종류 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="S037" /> <!-- 링크프로그램 -->
	
</t:appConfig>
<script type="text/javascript" >
var BsaCodeinfo = {
	gsMoneyUnit	: '${gsMoneyUnit}',
	gsAmtBase	: '${gsAmtBase}',
	gsSiteCode	: '${gsSiteCode}'		//20210331 추가
};

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ssa600skrvModel1', {
		fields: [ {name: 'CUSTOM_CODE'				,text:'<t:message code="system.label.sales.custom" default="거래처"/>'						,type:'string'}
				 ,{name: 'CUSTOM_NAME'				,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'				,type:'string'}
				 ,{name: 'MONEY_UNIT'				,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'				,type:'string'}
				 ,{name: 'UN_COLLECT_AMT'			,text:'<t:message code="system.label.sales.lastdayar" default="전일미수"/>'					,type:'uniPrice'}
				 ,{name: 'SALE_LOC_AMT_I'			,text:'<t:message code="system.label.sales.salesamount" default="매출액"/>'				,type:'uniPrice'}
				 ,{name: 'TAX_AMT_O'				,text:'<t:message code="system.label.sales.vat" default="부가세"/>'						,type:'uniPrice'}
				 ,{name: 'ENURI_AMT_I'				,text:'<t:message code="system.label.sales.discount2" default="에누리"/>'					,type:'uniPrice'}
				 ,{name: 'ENURI_TAX_AMT_O'			,text:'<t:message code="system.label.sales.discount2tax" default="에누리세엑"/>'				,type:'uniPrice'}
				 ,{name: 'TOT_SALE_AMT'				,text:'<t:message code="system.label.sales.salestotal" default="매출계"/>'					,type:'uniPrice'}
				 ,{name: 'CASH_COLLECT_AMT'			,text:'<t:message code="system.label.sales.cashpayment" default="현금입금"/>'				,type:'uniPrice'}
				 ,{name: 'NOTE_COLLECT_AMT'			,text:'<t:message code="system.label.sales.notedeposit" default="어음입금"/>'				,type:'uniPrice'}
				 ,{name: 'DIS_COLLECT_AMT'			,text:'<t:message code="system.label.sales.discount" default="할인"/>'					,type:'uniPrice'}
				 ,{name: 'UP_COLLECT_AMT'			,text:'<t:message code="system.label.sales.bonus" default="장려금"/>'						,type:'uniPrice'}
				 ,{name: 'TOT_COLLECT_AMT'			,text:'<t:message code="system.label.sales.deposittotal" default="입금계"/>'				,type:'uniPrice'}
				 ,{name: 'GRANT_UN_COLLECT_AMT'		,text:'<t:message code="system.label.sales.uncollectedloanamount" default="채권미수액"/>'	,type:'uniPrice'}
				 ,{name: 'CARD_AMT_O'				,text:'<t:message code="system.label.sales.creditcardsale" default="카드매출"/>'			,type:'uniPrice'}
				 ,{name: 'SALE_PRSN'				,text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>'				,type:'string',comboType:'AU', comboCode:'S010'}
				 ,{name: 'DIV_CODE'					,text:'<t:message code="system.label.sales.division" default="사업장"/>'					,type:'string',comboType:'BOR120'}
				 ,{name: 'AGENT_TYPE'				,text:'<t:message code="system.label.sales.customclass" default="거래처분류"/>'				,type:'string',comboType:'AU', comboCode:'B055'}
				 ,{name: 'AREA_TYPE'				,text:'<t:message code="system.label.sales.area" default="지역"/>'						,type:'string',comboType:'AU', comboCode:'B056'}
				 ,{name: 'M_CUSTOM_CODE'			,text:'<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'			,type:'string'}
				 ,{name: 'M_CUSTOM_NAME'			,text:'<t:message code="system.label.sales.summarycustomname" default="집계거래처명"/>'		,type:'string'}
				 ,{name: 'CREDIT_AMT'				,text:'<t:message code="system.label.sales.creditloanamount" default="신용여신액"/>'			,type:'uniPrice'}
				 ,{name: 'REMAIN_CREDIT'			,text:'<t:message code="system.label.sales.creditbalance" default="여신잔액"/>'				,type:'uniPrice'}
				 // 수금예정일 탭
				 ,{name: 'PAYMENT_DAY'				,text:'<t:message code="system.label.sales.collectionschdate" default="수금예정일"/>'		,type:'uniDate'}
			]
	});
	
	Unilite.defineModel('Ssa600skrvModel2', {
		fields: [ {name: 'CUSTOM_CODE'				,text:'<t:message code="system.label.sales.custom" default="거래처"/>'					,type:'string'}
				 ,{name: 'CUSTOM_NAME'				,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'			,type:'string'}
				 ,{name: 'BILL_DATE'				,text:'<t:message code="system.label.sales.publishdate" default="발행일"/>'			,type:'uniDate'}
				 ,{name: 'PUB_NUM'					,text:'<t:message code="system.label.sales.billno" default="계산서번호"/>'				,type:'string'}
				 ,{name: 'PUB_AMT'					,text:'<t:message code="system.label.sales.supplyamount" default="공급가액"/>'			,type:'uniPrice'}
				 ,{name: 'TAX_AMT_O'				,text:'<t:message code="system.label.sales.vat" default="부가세"/>'					,type:'uniPrice'}
				 ,{name: 'TOT_AMT_O'				,text:'<t:message code="system.label.sales.total" default="총계"/>'					,type:'uniPrice'}
				 ,{name: 'COLET_AMT'				,text:'<t:message code="system.label.sales.collectionamount" default="수금액"/>'		,type:'uniPrice'}
				 ,{name: 'UN_COLET_AMT'				,text:'<t:message code="system.label.sales.aramount" default="미수액"/>'				,type:'uniPrice'}
				 ,{name: 'SALE_PRSN'				,text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type:'string',comboType:'AU', comboCode:'S010'}
				 ,{name: 'DIV_CODE'					,text:'<t:message code="system.label.sales.division" default="사업장"/>'				,type:'string',comboType:'BOR120'}
				 ,{name: 'AGENT_TYPE'				,text:'<t:message code="system.label.sales.customclass" default="거래처분류"/>'			,type:'string',comboType:'AU', comboCode:'B055'}
				 ,{name: 'AREA_TYPE'				,text:'<t:message code="system.label.sales.area" default="지역"/>'					,type:'string',comboType:'AU', comboCode:'B056'}
				 ,{name: 'M_CUSTOM_CODE'			,text:'<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'		,type:'string'}
				 ,{name: 'M_CUSTOM_NAME'			,text:'<t:message code="system.label.sales.summarycustomname" default="집계거래처명"/>'	,type:'string'}
				 ,{name: 'BILL_TYPE'				,text:'<t:message code="system.label.sales.billtype" default="계산서종류"/>'				,type:'string',comboType:'AU', comboCode:'A022'}
				 ,{name: 'REMARK'					,text:'<t:message code="system.label.sales.remarks" default="비고"/>'					,type:'string'}
			]
	});	




	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('ssa600skrvMasterStore1',{
		model: 'Ssa600skrvModel1',
		uniOpt : {
			isMaster	: false,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ssa600skrvService.selectList1'
			}
		},
		loadStoreRecords : function() {	
			var param= search1.getValues();
			param.GS_MONEY_UNIT = BsaCodeinfo.gsMoneyUnit;
			param.GS_AMT_BASE = BsaCodeinfo.gsAmtBase;
			if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == "1"){
				param.sFld_SaleAmt		= 'SALE_AMT_O'
				param.sFld_CollectAmt	= 'COLLECT_FOR_AMT'
				param.sFld_PassAmt		= 'PASS_AMT'
				param.sFld_PayAmt		= 'PAY_AMT'
				param.sFld_BLAmt		= 'BL_AMT'
			}else{
				param.sFld_SaleAmt		= 'SALE_LOC_AMT_I'
				param.sFld_CollectAmt	= 'COLLECT_AMT'
				param.sFld_PassAmt		= 'PASS_AMT_WON'
				param.sFld_PayAmt		= 'PAY_AMT_WON'
				param.sFld_BLAmt		= 'BL_AMT_WON'
			}
			Ext.applyIf(param,panelSearch.getValues());
			this.load({
				params : param
			});
			
		},
		groupField: 'MONEY_UNIT'
	});

	var directMasterStore2 = Unilite.createStore('ssa600skrvMasterStore2',{
		model: 'Ssa600skrvModel2',
		uniOpt : {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'ssa600skrvService.selectList2'
			}
		},
		loadStoreRecords : function() {
			var param= search2.getValues();
			Ext.applyIf(param,panelSearch.getValues());
			this.load({
				params : param
			});
		},
		groupField: 'CUSTOM_NAME'
	});

	/** 수금예쩡일 Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore3 = Unilite.createStore('ssa600skrvMasterStore3',{
		model: 'Ssa600skrvModel1',
		uniOpt : {
			isMaster	: false,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'ssa600skrvService.selectList3'
			}
		},
		loadStoreRecords : function() {	
			var param			= search3.getValues();
			param.GS_MONEY_UNIT	= BsaCodeinfo.gsMoneyUnit;
			param.GS_AMT_BASE	= BsaCodeinfo.gsAmtBase;

			if(Ext.getCmp('rdoSelect3').getChecked()[0].inputValue == "1") {
				param.sFld_SaleAmt		= 'SALE_AMT_O'
				param.sFld_CollectAmt	= 'COLLECT_FOR_AMT'
				param.sFld_PassAmt		= 'PASS_AMT'
				param.sFld_PayAmt		= 'PAY_AMT'
				param.sFld_BLAmt		= 'BL_AMT'
			}else{
				param.sFld_SaleAmt		= 'SALE_LOC_AMT_I'
				param.sFld_CollectAmt	= 'COLLECT_AMT'
				param.sFld_PassAmt		= 'PASS_AMT_WON'
				param.sFld_PayAmt		= 'PAY_AMT_WON'
				param.sFld_BLAmt		= 'BL_AMT_WON'
			}
			Ext.applyIf(param,panelSearch.getValues());
			this.load({
				params : param
			});
		},
		groupField: 'MONEY_UNIT'
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name:'AGENT_TYPE', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055',
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}  
			},Unilite.popup('AGENT_CUST',{
				fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners	: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
			})]		
		},{
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name:'TXT_AREA_TYPE',	
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B056'
			},{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
				name:'ORDER_PRSN',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				xtype: 'uniNumberfield',
				fieldLabel: '<t:message code="system.label.sales.uncollectedloanamount" default="채권미수액"/>',
				name:'TXT_FR_SALE_AMT' ,
				suffixTpl:'&nbsp;<t:message code="system.label.sales.over" default="이상"/>'
			},  {
				xtype: 'uniNumberfield',
				fieldLabel: '~',
				name:'TXT_TO_SALE_AMT',
				suffixTpl:'&nbsp;<t:message code="system.label.sales.below" default="이하"/>'
			}, Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
				validateBlank	: false,
				valueFieldName	: 'MANAGE_CUSTOM_CODE',
				textFieldName	: 'MANAGE_CUSTOM_NAME', 
				extParam		: {'CUSTOM_TYPE':''},
				listeners	: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('MANAGE_CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('MANAGE_CUSTOM_CODE', '');
						}
					}
				}
			})]
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
				}
	 		}
			return r;
 		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value: UserInfo.divCode,
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			} 
		},{
			fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
			name:'AGENT_TYPE', 
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B055',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}  
		},Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="system.label.sales.custom" default="거래처"/>' ,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank: false,
			listeners	: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		})]	
	});
	
	var search1 = Unilite.createSearchForm('search1',{
		layout:{type:'hbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{ fieldLabel: '<t:message code="system.label.sales.creditdate" default="채권일"/>'
					,xtype: 'uniDateRangefield'
					,startFieldName: 'BILL_FR_DATE'
					,endFieldName: 'BILL_TO_DATE'
					,startDate: UniDate.get('startOfMonth')
					,endDate: UniDate.get('today')
					,allowBlank:false
					,width:315
				}
				,{fieldLabel: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>' ,name:'MONEY_UNIT',	xtype: 'uniCombobox', comboType:'AU',comboCode:'B004', id:'amtUnit', labelWidth:100, displayField: 'value', fieldStyle: 'text-align: center;'  }
				,{
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.sales.basisamount" default="금액기준"/>',
					id: 'rdoSelect',
					items : [{
						boxLabel  : '<t:message code="system.label.sales.occurredmoneybasis" default="발생화폐기준"/>',
						name: 'RDO',
						inputValue: '1',
						width:100,checked: true,
						handler:function(){
							//如果选中grid MONEY_UNIT列隐藏
							var RDO=search1.getValue("RDO");
							var column=masterGrid1.getColumn("MONEY_UNIT");
							if(!RDO){
								directMasterStore1.groupField='MONEY_UNIT';
								column.hide();
							}else{
								directMasterStore1.groupField='';
								column.show();
							}
							UniAppManager.app.onQueryButtonDown();
						}
					},{
						boxLabel  : '<t:message code="system.label.sales.comoneyunitbase" default="자사화폐기준"/>',
						name: 'RDO' ,
						inputValue: '2',
						handler:function(){
							UniAppManager.app.onQueryButtonDown();
						}
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue.RDO == '1'){
								var length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
								masterGrid1.getColumn("UN_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("UN_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("TAX_AMT_O").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("ENURI_AMT_I").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("ENURI_AMT_I").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("ENURI_TAX_AMT_O").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("ENURI_TAX_AMT_O").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("TOT_SALE_AMT").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("TOT_SALE_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("CASH_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("CASH_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("NOTE_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("NOTE_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("DIS_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("DIS_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("UP_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("UP_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("TOT_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("TOT_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("GRANT_UN_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("GRANT_UN_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("CARD_AMT_O").setConfig('format',UniFormat.FC);
								masterGrid1.getColumn("CARD_AMT_O").setConfig('decimalPrecision',length);
								masterGrid1.getView().refresh(true);
							}else{
								var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
								masterGrid1.getColumn("UN_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("UN_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("TAX_AMT_O").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("ENURI_AMT_I").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("ENURI_AMT_I").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("ENURI_TAX_AMT_O").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("ENURI_TAX_AMT_O").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("TOT_SALE_AMT").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("TOT_SALE_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("CASH_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("CASH_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("NOTE_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("NOTE_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("DIS_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("DIS_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("UP_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("UP_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("TOT_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("TOT_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("GRANT_UN_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("GRANT_UN_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid1.getColumn("CARD_AMT_O").setConfig('format',UniFormat.Price);
								masterGrid1.getColumn("CARD_AMT_O").setConfig('decimalPrecision',length);
								masterGrid1.getView().refresh(true);
							}
						}
					}
				}
				,{xtype:'hiddenfield', hidden:false}		
				,{xtype:'container',html:"<div id='ssa600skrvMessage1' class='x-hide-display' align='right' style='margin-top:5px'><div style='font-weight:bold; color:blue;'>※<t:message code="system.label.sales.tradeinclusion" default="무역포함"/></div>", flex: 1}
			]
		});
		
	var search2 = Unilite.createSearchForm('search2',{
						layout: {type:'hbox', align:'stretch', defaultMargins: '0 0 5 0'},
						items: [{ fieldLabel: '<t:message code="system.label.sales.publishdate" default="발행일"/>'
								,xtype: 'uniDateRangefield'
								,startFieldName: 'BILL_FR_DATE'
								,endFieldName: 'BILL_TO_DATE'
								,startDate: UniDate.get('startOfMonth')
								,endDate: UniDate.get('today')
								,allowBlank:false
								,width:315
								}
								,{xtype:'hiddenfield', hidden:false}
								,{xtype:'container',html:"<div id='ssa600skrvMessage2' class='x-hide-display' align='right' style='margin-top:5px'><div style='font-weight:bold; color:blue;'>※<t:message code="system.label.sales.salesmoduseonly" default="영업모듈만 적용됨"/></div>", flex: 1}
						]
			
		});
	// 결제예정일 탭 조회조건
	var search3 = Unilite.createSearchForm('search3',{
		layout:{type:'hbox', align:'stretch', defaultMargins: '0 0 5 0'},
		items: [{ fieldLabel		: '<t:message code="system.label.sales.paymentday" default="결제예정일"/>'
					,xtype			: 'uniDateRangefield'
					,startFieldName	: 'PAYMENT_DAY_FR'
					,endFieldName	: 'PAYMENT_DAY_TO'
					,startDate		: UniDate.get('startOfMonth')
					,endDate		: UniDate.get('today')
					,allowBlank		: false
					,width			: 315
				},{	fieldLabel	: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>' ,
					name		: 'MONEY_UNIT',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B004',
					labelWidth	: 100,
					displayField: 'value',
					fieldStyle	: 'text-align: center;'
				},{
					xtype		: 'radiogroup',
					fieldLabel	: '<t:message code="system.label.sales.basisamount" default="금액기준"/>',
					id			: 'rdoSelect3',
					items : [{
						boxLabel	: '<t:message code="system.label.sales.occurredmoneybasis" default="발생화폐기준"/>',
						name		: 'RDO',
						inputValue	: '1',
						width		: 100,
						checked		: true,
						handler : function(){
							// 수금예정일 탭의 발생화폐기준
							var RDO = search3.getValue("RDO");
							var column = masterGrid3.getColumn("MONEY_UNIT");
							if(!RDO){
								directMasterStore3.groupField='MONEY_UNIT';
								column.hide();
							}else{
								directMasterStore3.groupField='';
								column.show();
							}
							UniAppManager.app.onQueryButtonDown();
						}
					},{
						boxLabel	: '<t:message code="system.label.sales.comoneyunitbase" default="자사화폐기준"/>',
						name		: 'RDO',
						inputValue	: '2',
						handler:function(){
							UniAppManager.app.onQueryButtonDown();
						}
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue.RDO == '1'){
								var length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
								masterGrid3.getColumn("UN_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("UN_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("TAX_AMT_O").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("ENURI_AMT_I").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("ENURI_AMT_I").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("ENURI_TAX_AMT_O").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("ENURI_TAX_AMT_O").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("TOT_SALE_AMT").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("TOT_SALE_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("CASH_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("CASH_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("NOTE_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("NOTE_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("DIS_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("DIS_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("UP_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("UP_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("TOT_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("TOT_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("GRANT_UN_COLLECT_AMT").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("GRANT_UN_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("CARD_AMT_O").setConfig('format',UniFormat.FC);
								masterGrid3.getColumn("CARD_AMT_O").setConfig('decimalPrecision',length);
								masterGrid3.getView().refresh(true);
							}else{
								var length = Ext.isEmpty(UniFormat.Price.split('.')[1]) ? 0 : UniFormat.Price.split('.')[1].length;
								masterGrid3.getColumn("UN_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("UN_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("TAX_AMT_O").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("ENURI_AMT_I").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("ENURI_AMT_I").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("ENURI_TAX_AMT_O").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("ENURI_TAX_AMT_O").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("TOT_SALE_AMT").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("TOT_SALE_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("CASH_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("CASH_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("NOTE_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("NOTE_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("DIS_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("DIS_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("UP_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("UP_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("TOT_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("TOT_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("GRANT_UN_COLLECT_AMT").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("GRANT_UN_COLLECT_AMT").setConfig('decimalPrecision',length);
								masterGrid3.getColumn("CARD_AMT_O").setConfig('format',UniFormat.Price);
								masterGrid3.getColumn("CARD_AMT_O").setConfig('decimalPrecision',length);
								masterGrid3.getView().refresh(true);
							}
						}
					}
				}
				//,{xtype:'hiddenfield', hidden:false}		
				//,{xtype:'container',html:"<div id='ssa600skrvMessage1' class='x-hide-display' align='right' style='margin-top:5px'><div style='font-weight:bold; color:blue;'>※<t:message code="system.label.sales.tradeinclusion" default="무역포함"/></div>", flex: 1}
			]
		});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('ssa600skrvGrid1', {
		// for tab  
		layout : 'fit',		
		store: directMasterStore1,
		flex: 1,
		uniOpt:{
		 expandLastColumn: false
		},
		features: [ {id : 'masterGridSubTotal1', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal1',	ftype: 'uniSummary',	  showSummaryRow: false} 
		],
						
		columns:  [  { dataIndex:'CUSTOM_CODE'				,				width:86, locked: false,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					 	return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.htotal" default="환종계"/>', '');
					} }
					,{ dataIndex:'CUSTOM_NAME'				,				width:140, locked: false }
					,{ dataIndex:'MONEY_UNIT'				,				width:66 ,locked: false, align: 'center'}
					,{ dataIndex:'UN_COLLECT_AMT'			,				width:126 ,locked: false, summaryType:'sum'}
					,{ dataIndex:'SALE_LOC_AMT_I'			,				width:126 , summaryType:'sum'}
					,{ dataIndex:'TAX_AMT_O'				,				width:113 , summaryType:'sum'}
					,{ dataIndex:'ENURI_AMT_I'				,				width:126 , summaryType:'sum'}
					,{ dataIndex:'ENURI_TAX_AMT_O'			,				width:113 , summaryType:'sum'}
					,{ dataIndex:'TOT_SALE_AMT'				,				width:146 , summaryType:'sum'}
					,{ dataIndex:'CASH_COLLECT_AMT'			,				width:123 , summaryType:'sum'}
					,{ dataIndex:'NOTE_COLLECT_AMT'			,				width:123 , summaryType:'sum'}
					,{ dataIndex:'DIS_COLLECT_AMT'			,				width:123 , summaryType:'sum'}
					,{ dataIndex:'UP_COLLECT_AMT'			,				width:123 , summaryType:'sum'}
					,{ dataIndex:'TOT_COLLECT_AMT'			,				width:123 , summaryType:'sum'}
					,{ dataIndex:'GRANT_UN_COLLECT_AMT'		,				width:123 , summaryType:'sum'}
					,{ dataIndex:'CREDIT_AMT'				,				width:123 , summaryType:'sum'}
					,{ dataIndex:'REMAIN_CREDIT'			,				width:123 , summaryType:'sum'}
					,{ dataIndex:'CARD_AMT_O'				,				width:106 , summaryType:'sum'}
					,{ dataIndex:'SALE_PRSN'				,				width:80 }
					,{ dataIndex:'DIV_CODE'					,				width:100, hidden:true }
					,{ dataIndex:'AGENT_TYPE'				,				width:113 }
					,{ dataIndex:'AREA_TYPE'				,				width:113 }
					,{ dataIndex:'M_CUSTOM_CODE'			,				width:113, hidden:true }
					,{ dataIndex:'M_CUSTOM_NAME'			,				width:113 }
		],
		listeners: {  
			onGridDblClick: function(grid, record, cellIndex, colName) {
				//20210331 추가: 월드와이드메모리는 거래처원장 조회(매출/매입)으로 이동하도록 로직 추가
				if(BsaCodeinfo.gsSiteCode == 'WM') {
					var params = {
						appId		: UniAppManager.getApp().id,
						DIV_CODE	: record.get('DIV_CODE'), 
						CUSTOM_CODE	: record.get('CUSTOM_CODE'),
						CUSTOM_NAME	: record.get('CUSTOM_NAME'),
						FrDate		: search1.getValue('BILL_FR_DATE'),		//20210507 추가
						ToDate		: search1.getValue('BILL_TO_DATE')		//20210507 추가
					}
					var rec = {data: {prgID: 'ssa615skrv', 'text': ''}};
					parent.openTab(rec, '/sales/ssa615skrv.do', params);
				} else {
					var params = {
						appId		: UniAppManager.getApp().id,
						DIV_CODE	: record.get('DIV_CODE'), 
						CUSTOM_CODE	: record.get('CUSTOM_CODE'),
						CUSTOM_NAME	: record.get('CUSTOM_NAME')
					}
					var rec = {data: {prgID: 'ssa610skrv', 'text': ''}};
					parent.openTab(rec, '/sales/ssa610skrv.do', params);
				}
			}
		}
	});
	
	var masterGrid2 = Unilite.createGrid('ssa600skrvGrid2', {
		layout : 'fit',		
		store: directMasterStore2,
		flex: 1,
		uniOpt:{
		 expandLastColumn: false
		},
		features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal2',	ftype: 'uniSummary',	  showSummaryRow: false} ],
		columns:  [  { dataIndex:'CUSTOM_CODE'				,				width:100, locked:false, 
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					 	return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.customsubtotal" default="거래처계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
					} }
					,{ dataIndex:'CUSTOM_NAME'				,				width:146, locked:false  }
					,{ dataIndex:'BILL_DATE'				,				width:80, locked:false  }
					,{ dataIndex:'PUB_NUM'					,				width:126, locked:false  }
					,{ dataIndex:'PUB_AMT'					,				width:126, summaryType:'sum' }
					,{ dataIndex:'TAX_AMT_O'				,				width:140, summaryType:'sum' }
					,{ dataIndex:'TOT_AMT_O'				,				width:166, summaryType:'sum' }
					,{ dataIndex:'COLET_AMT'				,				width:126, summaryType:'sum' }
					,{ dataIndex:'UN_COLET_AMT'				,				width:126, summaryType:'sum' }
					,{ dataIndex:'SALE_PRSN'				,				width:80, hidden:true }
					,{ dataIndex:'DIV_CODE'					,				width:100, hidden:true }
					,{ dataIndex:'AGENT_TYPE'				,				width:113 }
					,{ dataIndex:'AREA_TYPE'				,				width:113 }
					,{ dataIndex:'M_CUSTOM_CODE'			,				width:66, hidden:true }
					,{ dataIndex:'M_CUSTOM_NAME'			,				width:113 }
					,{ dataIndex:'BILL_TYPE'				,				width:113 }
					,{ dataIndex:'REMARK'					,				width:126 }
		  ],
		  listeners: {  
			  onGridDblClick: function(grid, record, cellIndex, colName) {
					var params = {
						appId: UniAppManager.getApp().id,
						sender: me,
						DIV_CODE: record.get('DIV_CODE'), 
						CUSTOM_CODE: record.get('CUSTOM_CODE')
					}
					var rec = {data : {prgID : 'ssa610skrv', 'text':''}};	
					parent.openTab(rec, '/base/ssa610skrv.do', params);
			  }
		  }
	});
	// 수금예정일탭  Grid
	var masterGrid3 = Unilite.createGrid('ssa600skrvGrid3', {
		// for tab  
		layout	: 'fit',
		store	: directMasterStore3,
		flex	: 1,
		uniOpt	: {
			expandLastColumn: false
		},
		features: [ {id : 'masterGridSubTotal3', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal3',	ftype: 'uniSummary',	  showSummaryRow: false} 
		],
						
		columns:[{ dataIndex:'CUSTOM_CODE'				,				width:86, locked: false,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.htotal" default="환종계"/>', '');
					}
				}
				,{ dataIndex:'CUSTOM_NAME'				, width:140, locked: false }
				,{ dataIndex:'MONEY_UNIT'				, width:66 ,locked: false, align: 'center'}
				,{ dataIndex:'UN_COLLECT_AMT'			, width:126 ,locked: false, summaryType:'sum'}
				,{ dataIndex:'SALE_LOC_AMT_I'			, width:126 , summaryType:'sum'}
				,{ dataIndex:'TAX_AMT_O'				, width:113 , summaryType:'sum'}
				,{ dataIndex:'ENURI_AMT_I'				, width:126 , summaryType:'sum'}
				,{ dataIndex:'ENURI_TAX_AMT_O'			, width:113 , summaryType:'sum'}
				,{ dataIndex:'TOT_SALE_AMT'				, width:146 , summaryType:'sum'}
				,{ dataIndex:'CASH_COLLECT_AMT'			, width:123 , summaryType:'sum'}
				,{ dataIndex:'NOTE_COLLECT_AMT'			, width:123 , summaryType:'sum'}
				,{ dataIndex:'DIS_COLLECT_AMT'			, width:123 , summaryType:'sum'}
				,{ dataIndex:'UP_COLLECT_AMT'			, width:123 , summaryType:'sum'}
				,{ dataIndex:'TOT_COLLECT_AMT'			, width:123 , summaryType:'sum'}
				,{ dataIndex:'GRANT_UN_COLLECT_AMT'		, width:123 , summaryType:'sum'}
				,{ dataIndex:'CARD_AMT_O'				, width:106 , summaryType:'sum'}
				,{ dataIndex:'SALE_PRSN'				, width:80 }
				,{ dataIndex:'DIV_CODE'					, width:100, hidden:true }
				,{ dataIndex:'AGENT_TYPE'				, width:113 }
				,{ dataIndex:'AREA_TYPE'				, width:113 }
				,{ dataIndex:'M_CUSTOM_CODE'			, width:113, hidden:true }
				,{ dataIndex:'M_CUSTOM_NAME'			, width:113 }
				,{ dataIndex:'PAYMENT_DAY'				, width:113 }
		],
		listeners: {  
			onGridDblClick: function(grid, record, cellIndex, colName) {
				//20210331 추가: 월드와이드메모리는 거래처원장 조회(매출/매입)으로 이동하도록 로직 추가
				if(BsaCodeinfo.gsSiteCode == 'WM') {
					var params = {
						appId		: UniAppManager.getApp().id,
						DIV_CODE	: record.get('DIV_CODE'), 
						CUSTOM_CODE	: record.get('CUSTOM_CODE'),
						CUSTOM_NAME	: record.get('CUSTOM_NAME'),
						FrDate		: search1.getValue('PAYMENT_DAY_FR'),
						ToDate		: search1.getValue('PAYMENT_DAY_TO')
					}
					var rec = {data: {prgID: 'ssa615skrv', 'text': ''}};
					parent.openTab(rec, '/sales/ssa615skrv.do', params);
				} else {
					var params = {
						appId		: UniAppManager.getApp().id,
						DIV_CODE	: record.get('DIV_CODE'), 
						CUSTOM_CODE	: record.get('CUSTOM_CODE'),
						CUSTOM_NAME	: record.get('CUSTOM_NAME')
					}
					var rec = {data: {prgID: 'ssa610skrv', 'text': ''}};
					parent.openTab(rec, '/sales/ssa610skrv.do', params);
				}
			}
		}
	});
	
	var tab = Unilite.createTabPanel('tabPanel',{
		region: 'center',
		activeTab: 0,
		items: [{	
					  title	: '<t:message code="system.label.sales.parenbyeachsalescredit2" default="매출채권별"/>'
					, xtype	: 'container'
					, id	: 'tab1'
					, layout: {type:'vbox', align:'stretch'}
					, items	: [search1, masterGrid1]
				},{
					  title	: '<t:message code="system.label.sales.parenbyeachbillissue2" default="계산서발행별"/>'
					, xtype	: 'container'
					, id	: 'tab2'
					, layout: {type:'vbox', align:'stretch'}
					, items	: [search2, masterGrid2]
				},{
					  title	: '<t:message code="system.label.sales.paymentday" default="결제예정일"/>'
					, xtype	: 'container'
					, id	: 'tab3'
					, layout: {type:'vbox', align:'stretch'}
					, items	: [search3, masterGrid3]
				}
		]
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
		id  : 'ssa600skrvApp',
		fnInitBinding : function(params) {		//20210507 추가: 수주등록에서 넘어오는 링크 받는 로직 추가(params)
			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			if(BsaCodeinfo.gsAmtBase == "1"){
				search1.getField('RDO').setValue('1');
				var length = Ext.isEmpty(UniFormat.FC.split('.')[1]) ? 0 : UniFormat.FC.split('.')[1].length;
				masterGrid1.getColumn("UN_COLLECT_AMT").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("UN_COLLECT_AMT").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("SALE_LOC_AMT_I").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("SALE_LOC_AMT_I").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("TAX_AMT_O").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("TAX_AMT_O").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("ENURI_AMT_I").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("ENURI_AMT_I").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("ENURI_TAX_AMT_O").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("ENURI_TAX_AMT_O").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("TOT_SALE_AMT").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("TOT_SALE_AMT").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("CASH_COLLECT_AMT").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("CASH_COLLECT_AMT").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("NOTE_COLLECT_AMT").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("NOTE_COLLECT_AMT").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("DIS_COLLECT_AMT").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("DIS_COLLECT_AMT").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("UP_COLLECT_AMT").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("UP_COLLECT_AMT").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("TOT_COLLECT_AMT").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("TOT_COLLECT_AMT").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("GRANT_UN_COLLECT_AMT").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("GRANT_UN_COLLECT_AMT").setConfig('decimalPrecision',length);
				masterGrid1.getColumn("CARD_AMT_O").setConfig('format',UniFormat.FC);
				masterGrid1.getColumn("CARD_AMT_O").setConfig('decimalPrecision',length);
				masterGrid1.getView().refresh(true);
			}else{
				search1.getField('RDO').setValue('2');
			}
			if(params && params.PGM_ID) {		//20210507 추가: 수주등록에서 넘어오는 링크 받는 로직 추가(params)
				this.processParams(params);
			}
		},
		processParams: function(params) {		//20210507 추가: 수주등록에서 넘어오는 링크 받는 로직 추가(params)
			if(params.PGM_ID == 'sof100ukrv') {
				panelSearch.setValue('DIV_CODE'		, params.DIV_CODE);
				panelSearch.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
				panelSearch.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
				panelResult.setValue('DIV_CODE'		, params.DIV_CODE);
				panelResult.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
				panelResult.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
				setTimeout(function(){
					UniAppManager.app.onQueryButtonDown();
				}, 600);
			}
		},
		onQueryButtonDown : function()	{	
			var viewLocked;
			var viewNormal;
			
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}	
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'tab1'){	
				masterGrid1.reset();
				directMasterStore1.loadStoreRecords();
//				viewLocked = masterGrid1.lockedGrid.getView();
				viewNormal = masterGrid1.getView();
//				viewLocked.getFeature('masterGridSubTotal1').toggleSummaryRow(true);
//				viewLocked.getFeature('masterGridTotal1').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridSubTotal1').toggleSummaryRow(true);
//				viewNormal.getFeature('masterGridTotal1').toggleSummaryRow(true);
			}
			else if(activeTabId == 'tab2'){
				masterGrid2.reset();
				directMasterStore2.loadStoreRecords();
//				viewLocked = masterGrid2.lockedGrid.getView();
				viewNormal = masterGrid2.getView();
//				viewLocked.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
//				viewLocked.getFeature('masterGridTotal2').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
				viewNormal.getFeature('masterGridTotal2').toggleSummaryRow(true);
			} else if(activeTabId == 'tab3'){
				
				// 초기화
				masterGrid3.reset();
				
				directMasterStore3.loadStoreRecords();
				viewNormal = masterGrid3.getView();
				viewNormal.getFeature('masterGridSubTotal3').toggleSummaryRow(true);
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.getStore().loadData({})
			masterGrid2.getStore().loadData({})
			masterGrid3.getStore().loadData({})
			this.fnInitBinding();
		}
	});
};
</script>