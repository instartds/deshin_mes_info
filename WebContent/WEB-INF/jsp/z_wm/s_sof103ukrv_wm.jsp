<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof103ukrv_wm">
	<t:ExtComboStore comboType="BOR120"  pgmId="s_sof103ukrv_wm"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A028"/>						<!-- 카드사 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>						<!-- 과세포함여부-->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>						<!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="S014"/>						<!-- 매출대상여부 -->		<%--20210406 추가 --%>
	<t:ExtComboStore comboType="AU" comboCode="S024"/>						<!-- 부가세유형 -->		<%--20210217 추가 --%>
	<t:ExtComboStore comboType="AU" comboCode="ZM11"/>						<!-- 배송방법 -->		<%--20201217 추가 --%>
	<t:ExtComboStore comboType="OU"/>										<!-- 창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_sof103ukrv_wmLevel1Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_sof103ukrv_wmLevel2Store"/>
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_sof103ukrv_wmLevel3Store"/>
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
	//20201216추가: 우편번호 다음 API 연동
	var protocol = ("https:" == document.location.protocol) ? "https" : "http";
	if(protocol == "https") {
		document.write(unescape("%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	} else {
		document.write(unescape("%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	}
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >
var isLoad			= false;						//로딩 플래그 담당, 화폐단위, 환율 change 로드시 계속 타므로 막음
var BsaCodeInfo		= {
	gsVatRate			: ${gsVatRate},
	defaultSalePrsn		: '${defaultSalePrsn}'		//영업담당(default)
};
var CustomCodeInfo	= {								//20201210 추가: 세액 세액, 합계금액 계산을 위해 추가
	gsUnderCalBase	: ''
};
var activeGridId	= 's_sof103ukrv_wmGrid';
var gsAuthToken		= '';
var initFlag		= false;						//20210201 추가
var gsFromDate		= '${gsFromDate}';				//20210319  추가

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//			, tableAttrs	: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//			, tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		items		: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			holdable	: 'hold',
			tdAttrs		: {width: 280},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
				}
			}
		},{
			fieldLabel	: '영업담당',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			holdable	: 'hold',
			allowBlank	: false,
			tdAttrs		: {width: 400},
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
				if(eOpts) {
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '주문일',
			name		: 'ORDER_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			readOnly	: true,
			colspan		: 2,				//20210319 추가
//			holdable	: 'hold',			//20201216 주석: 주문일 수정 안 됨
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				blur : function (e, event, eOpts) {
				}
			}
		},{	//20210201 추가: 조회조건 '고객분류' 추가
			fieldLabel	: '고객분류',
			name		: 'AGENT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B055'
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			padding	: '0 0 3 0',
			items	: [{
				fieldLabel	: '품목분류',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_sof103ukrv_wmLevel1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 200
			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_sof103ukrv_wmLevel2Store'),
				child		: 'ITEM_LEVEL3',
				width		: 100

			},{
				fieldLabel	: '',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('s_sof103ukrv_wmLevel3Store'),
				width		: 100
			}]
		},{	//20210319 추가
			fieldLabel	: '수집시작일',
			name		: 'FROM_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				blur : function (e, event, eOpts) {
				}
			}
		},{	//20201202 추가
			fieldLabel	: '세액포함 여부',
			name		: 'TAX_INOUT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B030',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{	//20210316 추가: 링크 넘어온 데이터 조회 시 필요
			fieldLabel	: '주문고객명',
			name		: 'ORDER_NAME',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20210201 추가: 조회조건 '출하지시여부' 추가
			fieldLabel	: '출하지시여부',
			xtype		: 'radiogroup',
			items		: [{
				boxLabel	: '미등록',
				name		: 'rdoSelect',
				inputValue	: 'N',
				width		: 70
			},{
				boxLabel	: '등록',
				name		: 'rdoSelect',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '전체',
				name		: 'rdoSelect',
				inputValue	: 'A',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//20201020 추가: 초기화 시 조회로직 타지 않도록 해당로직 추가
					if(!initFlag) {
						detailStore.loadStoreRecords(newValue.rdoSelect);
						detailStore2.loadStoreRecords(newValue.rdoSelect);
					} else {
						initFlag = false;
					}
				}
			}
		},{
			//20210201 추가: '추가(복사)' 버튼 추가
			xtype	: 'container',
			layout	: {type : 'vbox', align: 'right'},
			padding	: '0 0 3 140',
			items	: [{
				text	: '추가(복사)',
				xtype	: 'button',
				width	: 100,
				handler : function() {
					if(activeGridId == 's_sof103ukrv_wmGrid') {
						var record		= detailGrid.getSelectedRecord();
						if(Ext.isEmpty(record)) {
							Unilite.messageBox('복사할 대상이 선택되지 않았습니다.');
							return false;
						} else {
							var grdRecord	= detailGrid.uniOpt.currentRecord;
							if(Ext.isDefined(UniAppManager.app.onNewDataButtonDown()) && !UniAppManager.app.onNewDataButtonDown()) {
								return false;
							}
							var newRecord	= detailGrid.getSelectedRecord();
							var columns		= detailGrid.getColumns();
							Ext.each(columns, function(column, index) {
								newRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
							});
							var uniqueId= makeUniqueIdAndNumber(true);
							var number	= makeUniqueIdAndNumber(false);
							var serNo	= detailStore.max('SER_NO')+1;
							newRecord.set('BUNDLE_NO'	, uniqueId);
							newRecord.set('NUMBER'		, number);
							newRecord.set('SER_NO'		, serNo);
							//품목정보, 수량, 금액은 초기화
							newRecord.set('ITEM_CODE'	, '');
							newRecord.set('ITEM_NAME'	, '');
							newRecord.set('SPEC'		, '');
							newRecord.set('ORDER_Q'		, 1);
							newRecord.set('ORDER_P'		, 0);
							newRecord.set('ORDER_PRICE'	, 0);
							newRecord.set('ORDER_TAX_O'	, 0);
							newRecord.set('SUM_PRICE'	, 0);
						}
					} else {
						Unilite.messageBox('상단 그리드에서 복사할 대상을 선택한 후, 버튼을 눌러주십시오.');
						return false;
					}
				}
			}]
		},{	//20201026 추가: 저장 시 필요
			fieldLabel	: 'KEY_VALUE',
			name		: 'KEY_VALUE',
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sof103ukrv_wmService.selectList',
			update	: 's_sof103ukrv_wmService.updateDetail',
			create	: 's_sof103ukrv_wmService.insertDetail',
			destroy	: 's_sof103ukrv_wmService.deleteDetail',
			syncAll	: 's_sof103ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_sof103ukrv_wmModel', {	//SOF110T에 저장
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string', allowBlank: false},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'			, type: 'string', allowBlank: false},
			{name: 'ORDER_NUM'			, text: '수주번호'				, type: 'string'},
			{name: 'SER_NO'				, text: '수주순번'				, type: 'int'	, allowBlank: false},
			{name: 'UNIQUEID'			, text: 'UNIQUEID'			, type: 'string'},									//UNIQUEID
			{name: 'NUMBER'				, text: 'NUMBER'			, type: 'string', allowBlank: false},				//NUMBER
			{name: 'SITE_CODE'			, text: '판매사이트코드'			, type: 'string', allowBlank: false},				//SITECODE
			{name: 'SITE_NAME'			, text: '판매사이트'				, type: 'string', allowBlank: false},				//SITENAME
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'	, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'		, type: 'string', allowBlank: false},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string', editable: false},
			{name: 'SHOP_SALE_NAME'		, text: '상품명'				, type: 'string'},									//SHOP_SALE_NAME
			{name: 'SHOP_OPT_NAME'		, text: '옵션명'				, type: 'string'},									//SHOP_SALE_NAME
			{name: 'ORDER_Q'			, text: '수량'				, type: 'uniQty'		, allowBlank: false},		//COUNT
			{name: 'ORDER_P'			, text: '단가'				, type: 'uniUnitPrice'},		//20201208 추가
			{name: 'ORDER_PRICE'		, text: '판매가'				, type: 'uniPrice'		, allowBlank: false},		//PRICE
			{name: 'ORDER_TAX_O'		, text: '부가세'				, type: 'uniPrice'},								//20201208 추가
			{name: 'SUM_PRICE'			, text: '합계금액'				, type: 'uniPrice'},								//20201208 추가
			{name: 'SHOP_ORD_NO'		, text: '주문번호'				, type: 'string'},									//SHOP_ORD_NO
			{name: 'RECEIVER_NAME'		, text: '수령자명'				, type: 'string', allowBlank: false},				//RECIPIENTNAME, 20201229 필수로 변경
			{name: 'TELEPHONE_NUM1'		, text: '수령자전화번호'			, type: 'string'},									//RECIPIENTTEL
			{name: 'TELEPHONE_NUM2'		, text: '수령자핸드폰'			, type: 'string', allowBlank: false},				//RECIPIENTHTEL, 20201229 필수로 변경
			{name: 'ZIP_NUM'			, text: '우편번호'				, type: 'string'},									//RECIPIENTZIP
			{name: 'ADDRESS1'			, text: '주소1'				, type: 'string'},									//RECIPIENTADDRESS
			{name: 'ADDRESS2'			, text: '주소2'				, type: 'string'},									//RECIPIENTADDRESS
			{name: 'DELIV_METHOD'		, text: '배송방법'				, type: 'string', comboType: 'AU', comboCode: 'ZM11', allowBlank: false},	//DELIVMETHOD, 20201217 공통코드로 변경, 20201229 필수로 변경
			//화면에서는 HIDDEN
			{name: 'ORD_STATUS'			, text: '주문상태'				, type: 'string'},									//ORD_STATUS
			{name: 'SENDER_CODE'		, text: '택배사코드'				, type: 'int'},										//SENDER_CODE
			{name: 'SENDER'				, text: '택배사'				, type: 'string'},									//SENDER
			{name: 'DELIV_PRICE'		, text: '배송비'				, type: 'uniPrice'},								//DELIVPRICE
			{name: 'DVRY_DATE'			, text: '배송예정일'				, type: 'uniDate'},									//DELIVDATE
			{name: 'CUSTOMER_ID'		, text: '주문자ID'				, type: 'string'},									//ORDERID
			{name: 'ORDER_NAME'			, text: '주문자명'				, type: 'string'},									//ORDERNAME
			{name: 'ORDER_TEL1'			, text: '주문자전화번호'			, type: 'string'},									//ORDERTEL
			{name: 'ORDER_TEL2'			, text: '주문자핸드폰'			, type: 'string'},									//ORDERHTEL
			{name: 'ORDER_MAIL'			, text: '주문자email'			, type: 'string'},									//ORDEREMAIL
			{name: 'MSG'				, text: '배송메세지'				, type: 'string'},									//MSG
			{name: 'INVOICE_NUM'		, text: '송장번호'				, type: 'string'},									//INVOICE_NUM
			{name: 'SHOP_ORD_NO'		, text: '쇼핑몰 주문번호'			, type: 'string'},									//SHOP_ORD_NO
			{name: 'SHOP_SALE_NO'		, text: '쇼핑몰 판매번호'			, type: 'string'},									//SHOP_SALE_NO
			{name: 'BUNDLE_NO'			, text: '주문묶음번호'			, type: 'string'},									//BUNDLE_NO
			{name: 'PA_ADDCOL_GROUPING'	, text: 'PA_ADDCOL_GROUPING', type: 'string'},									//20210105 추가
			//20201029 추가: 체크로직을 위해 컬럼 추가
			{name: 'ISSUE_REQ_Q'		, text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'	, type: 'uniQty', defaultValue: 0},
			{name: 'OUTSTOCK_Q'			, text: 'OUTSTOCK_Q'		, type: 'int', defaultValue: 0},
			{name: 'TAX_INOUT'			, text: '세액포함 여부'			, type: 'string', comboType: 'AU', comboCode: 'B030'},	//20201202 추가,
			{name: 'PAY_TIME'			, text: '결제완료시간'			, type: 'string'},										//20201229 추가
			{name: 'BILL_TYPE'			, text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'			, type: 'string', comboType: 'AU', comboCode: 'S024', allowBlank: false},			//20210217 추가
			{name: 'CARD_CUSTOM_CODE'	, text: '카드사'				, type: 'string', comboType: 'AU', comboCode: 'A028'},	//20210223 추가
			{name: 'SRQ_YN'				, text: '출하지시여부'			, type: 'string', editable: false},						//20210319 추가
			{name: 'ACCOUNT_YNC'		, text:'<t:message code="system.label.sales.salessubject" default="매출대상"/>', type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'S014',  defaultValue: 'Y'}	//20210406 추가
		]
	});

	var detailStore = Unilite.createStore('s_sof103ukrv_wmDetailStore',{
		model	: 's_sof103ukrv_wmModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(newValue) {
			var param = panelResult.getValues();
			//20210201 추가
			if(newValue) {
				param.rdoSelect = newValue;
			}
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
						//20210316 추가: 링크 넘어온 데이터 조회 후, 초기화 - 그냥 조회조건으로 남겨도 괜찮을 듯;
//						panelResult.setValue('ORDER_NAME', '');
					}
				}
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var inValidRecs2= detailGrid2.getStore().getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			//20201216 추가: 운송방법이 택배일 경우 전화번호 필수 체크
			var list		= [].concat(toUpdate, toCreate);
			var err			= false;
			Ext.each(list, function(record,i) {
				if(record.get('DELIV_METHOD') == '무료배송' || record.get('DELIV_METHOD') == '선결제' || record.get('DELIV_METHOD') == '택배') {
					if(Ext.isEmpty(record.get('TELEPHONE_NUM1'))) {
						Unilite.messageBox('택배배송의 경우, 수령자 전화번호는 필수 입니다.', '***-****-**** 형식으로 입력하시기 바랍니다.');
						err = true;
					}
				}
			});
			if(err) {
				return false;
			}
//			return false;
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				if(inValidRecs2.length == 0) {
					if(config == null) {
						config = {
							params	: [paramMaster],
							success	: function(batch, option) {
								var master = batch.operations[0].getResultSet();
								panelResult.setValue("KEY_VALUE", master.KEY_VALUE);
	
								if(detailStore2.isDirty()) {
									detailStore2.saveStore();
								} else {
									panelResult.setValue('KEY_VALUE', '');
									panelResult.getForm().wasDirty = false;
									panelResult.resetDirtyStatus();
									console.log("set was dirty to false");
									UniAppManager.setToolbarButtons('save', false);
	
									if(detailStore.getCount() == 0) {
										UniAppManager.app.onResetButtonDown();
									} else {
										UniAppManager.app.onQueryButtonDown();
									}
								}
							}
						};
					}
					this.syncAllDirect(config);
				} else {
					detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs2);
				}
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				isLoad = false;
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				//20210208 추가: 전화번호 입력 시, 자동으로 '-' 추가하도록 로직 추가, 20210218 수정: 안심번호 체크로직 추가
				if(!Ext.isEmpty(record.get('TELEPHONE_NUM1') && modifiedFieldNames == 'TELEPHONE_NUM1')) {
//					record.set('TELEPHONE_NUM1', record.get('TELEPHONE_NUM1').replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
					record.set('TELEPHONE_NUM1', record.get('TELEPHONE_NUM1').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
				if(!Ext.isEmpty(record.get('TELEPHONE_NUM2') && modifiedFieldNames == 'TELEPHONE_NUM2')) {
//					record.set('TELEPHONE_NUM2', record.get('TELEPHONE_NUM2').replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
					record.set('TELEPHONE_NUM2', record.get('TELEPHONE_NUM2').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0) {
						var msg = records.length + Msg.sMB001; 				//'건이 조회되었습니다.';
						UniAppManager.updateStatus(msg, true);
					}
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('s_sof103ukrv_wmGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: false
		},
		/*	URL
			참고 문서
			https://doc-openapi.playauto.io/

			주문리스트
			https://openapi.playauto.io/api/orders

			주문상세정보
			https://openapi.playauto.io/api/order/:uniq
		*/
		tbar	: [{	//20201215 추가: 서버에서 API호출하는 로직으로 변경
			text	: '자료 가져오기',
			width	: 100,
			handler	: function() {
				var records = detailStore.data.items;
				if(records.length > 0) {
					Unilite.messageBox('신규 버튼을 누른 후, 작업을 진행하세요.');
					return false;
				}
				if(!panelResult.setAllFieldsReadOnly(true)) return false;								//20201221 수정: 필수체크하도록 변경
				Ext.getCmp('s_sof103ukrv_wmApp').mask('작업 진행  중...','loading-indicator');
				var param				= panelResult.getValues();
				var sdateValue			= UniDate.getDbDateStr(panelResult.getValue('FROM_DATE'));		//20210319 수정: 수집시작일 필드 추가하여 해당값으로 대체
				sdateValue				= sdateValue.substring(0, 4) + '-' + sdateValue.substring(4, 6) + '-' + sdateValue.substring(6, 8);
				var edateValue			= UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE'));
				edateValue				= edateValue.substring(0, 4) + '-' + edateValue.substring(4, 6) + '-' + edateValue.substring(6, 8);
				param.ORDER_DATE2		= UniDate.getDbDateStr(UniDate.add(panelResult.getValue('ORDER_DATE'), {days: 1}));
				param.api_url			= 'https://openapi.playauto.io/api/orders';
				param.length			= 2000;					//조회할 주문 갯수(Default value: 500)
				param.date_type			= 'wdate';				//날짜검색타입: "wdate: 주문수집일", "ord_time: 주문일", "pay_time: 결제완료일", "ord_status_mdate: 상태변경일", "ship_plan_date: 발송예정일", "ord_confirm_time: 주문확인일", "out_order_time: 출고지시일", "out_time: 출고완료일", "invoice_send_time: 송장전송일" 
				param.sdate				= sdateValue;			//검색시작일 ( 0000-00-00 )
				param.edate				= edateValue;			//검색종료일 ( 0000-00-00 )
				param.status			= [						//주문상태 ["출고대기", "출고보류", "운송장출력"] 전체조회시 ["ALL"] - "결제완료", "신규주문", "출고대기", "출고보류", "운송장출력", "출고완료", "배송중", "배송완료", "구매결정", "취소요청", "취소완료", "반품요청", "반품교환요청", "반품완료", "교환요청", "교환완료", "맞교환요청", "맞교환완료", "주문재확인"
					'신규주문'
				];
				param.status2			= [						//주문상태 ["출고대기", "출고보류", "운송장출력"] 전체조회시 ["ALL"] - "결제완료", "신규주문", "출고대기", "출고보류", "운송장출력", "출고완료", "배송중", "배송완료", "구매결정", "취소요청", "취소완료", "반품요청", "반품교환요청", "반품완료", "교환요청", "교환완료", "맞교환요청", "맞교환완료", "주문재확인"
					"출고완료","배송완료","취소완료","반품완료", "교환완료", "맞교환완료"
				];
//				param.start				= 0,					//검색시작값
//				param.orderby			= 'wdate desc',			//정렬

//				param.search_key		= '',					//검색키: "'': 전체", "shop_ord_no: 주문번호", "shop_sale_no: 쇼핑몰 상품코드", "sku_cd: SKU코드", "c_sale_cd: 판매자관리코드", "shop_sale_name: 온라인상품명", "prod_name,attri: 기초상품명", "shop_opt_name,shop_add_opt_name: 옵션명, 추가구매옵션", "order_name,order_id,to_name: 주문자, 수령자", "order_tel,order_htel: 주문자전화번호, 주문자 휴대폰번호", "to_tel,to_htel: 수령자전화번호, 수령자휴대폰번호", "memo: 메모", "gift_name: 사은품"
//				param.search_word		= '김가',				//검색어
//				param.search_type		= 'partial',				//검색타입: "exact: 완전일치", "partial: 부분일치" 

//				param.shop_id			= '',					//쇼핑몰아이디
//				param.shop_cd			= '',					//쇼핑몰코드 ( 옥션: A001, 지마켓: A006, 11번가: A112, 인터파크: A027... )
//				param.status			= [						//주문상태 ["출고대기", "출고보류", "운송장출력"] 전체조회시 ["ALL"] - "결제완료", "신규주문", "출고대기", "출고보류", "운송장출력", "출고완료", "배송중", "배송완료", "구매결정", "취소요청", "취소완료", "반품요청", "반품교환요청", "반품완료", "교환요청", "교환완료", "맞교환요청", "맞교환완료", "주문재확인"
//					'ALL'
//				],
//				param.bundle_yn			= true,					//카운팅 기준이 묶음번호 기준인지 여부 ex> length 를 1로 조회해도 bundle_yn 이 true 이고 해당 주문건이 3건이 묶여있는 상태이면 3건의 주문건이 조회됨.
//				param.delivery_vendor	= '',					//창고(배송처) 코드
//				param.gift_prod_name	= '',					//사은품코드
//				param.delay_status		= false,				//배송지연여부
//				param.unstore_status	= false,				//출고가능여부
//				param.multi_type		= 'shop_sale_no',		//멀티검색 키: "c_sale_cd: 판매자관리코드", "shop_sale_no: 쇼핑몰상품코드", "bundle_no: 묶음번호", "sku_cd: SKU코드", "shop_ord_no: 쇼핑몰주문번호", "invoice_no: 운송장번호", "shop: 쇼핑몰아이디" 
//				param.multi_search_word	= '',					//멀티검색어: \n 으로 묶어서 전송 ex> 하나\n둘\n셋\n넷
//				param.delay_ship		= false,				//출고지연여부
//				param.delay_day			= false,
//				param.map_yn			= false,				//재고매칭여부
//				param.supp_vendor		= '',					//매입처코드
//				param.memo_yn			= true					//메모여부
				s_sof103ukrv_wmService.insertAPIOrderList(param, function(provider, response) {
					//20210113 수정: 메세지 로직 수정
					if(Ext.isDefined(provider)) {
						if(!Ext.isEmpty(provider)) {
							if(provider == '0') {
								Unilite.messageBox('등록할 주문 건이 없습니다.');
							} else {
								Unilite.messageBox('등록 되지않은 주문 건이 있습니다.', provider);		//20210126 수정
							}
						} else {
							Unilite.messageBox('데이터가 정상적으로 등록 되었습니다.');
						}
						panelResult.setValue('FROM_DATE', new Date())
						UniAppManager.app.onQueryButtonDown();
					}
					Ext.getCmp('s_sof103ukrv_wmApp').unmask();
				});
			}
		}],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: true}],
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'BUNDLE_NO'			, width: 100, hidden: true},			//20201202 추가,
			{dataIndex: 'UNIQUEID'			, width: 100, hidden: true},
			{dataIndex: 'NUMBER'			, width: 100, hidden: true},
			{dataIndex: 'PA_ADDCOL_GROUPING', width: 100, hidden: true},			//20210105 추가
			{dataIndex: 'ORDER_NUM'			, width: 100, hidden: true},
			{dataIndex: 'SER_NO'			, width: 100, hidden: true},
			{dataIndex: 'SITE_CODE'			, width: 100, hidden: true},
			{dataIndex: 'ORD_STATUS'		, width: 100, hidden: false, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},																		//20201216 수정: 위치 변경 / 보이도록 설정, align: 'center', 20210614 수정: 합계 추가
			{dataIndex: 'SITE_NAME'			, width: 100,
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('SITE_CODE'		, records[0]['CUSTOM_CODE']);
								grdRecord.set('SITE_NAME'		, records[0]['CUSTOM_NAME']);
								//20201210 추가: 세액 세액, 합계금액 계산을 위해 추가
								CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
								//20210201 추가: 수령자명, 수령자전화번호, 우편번호, 주소1, 주소2 set
								grdRecord.set('RECEIVER_NAME'	, records[0]['CUSTOM_NAME']);
								grdRecord.set('TELEPHONE_NUM1'	, records[0]['TELEPHON']);
								grdRecord.set('TELEPHONE_NUM2'	, records[0]['TELEPHON']);
								grdRecord.set('ZIP_NUM'			, records[0]['ZIP_CODE']);
								grdRecord.set('ADDRESS1'		, records[0]['ADDR1']);
								grdRecord.set('ADDRESS2'		, records[0]['ADDR2']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SITE_CODE'		, '');
							grdRecord.set('SITE_NAME'		, '');
							//20201210 추가: 세액 세액, 합계금액 계산을 위해 추가
							CustomCodeInfo.gsUnderCalBase = '';
							//20210201 추가: 수령자명, 수령자전화번호, 우편번호, 주소1, 주소2 set
							grdRecord.set('RECEIVER_NAME'	, '');
							grdRecord.set('TELEPHONE_NUM1'	, '');
							grdRecord.set('TELEPHONE_NUM2'	, '');
							grdRecord.set('ZIP_NUM'			, '');
							grdRecord.set('ADDRESS1'		, '');
							grdRecord.set('ADDRESS2'		, '');
						}
					}
				})
			},
			{dataIndex: 'ITEM_CODE'			, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								detailGrid.setItemData(records, false, detailGrid.uniOpt.currentRecord);
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null, true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: divCode});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 150,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup	: true,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								detailGrid.setItemData(records, false, detailGrid.uniOpt.currentRecord);
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null, true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: divCode});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'SHOP_SALE_NAME'	, width: 120},
			{dataIndex: 'SHOP_OPT_NAME'		, width: 120, hidden: true},
			{dataIndex: 'ORDER_Q'			, width: 80	, align: 'center'},
			{dataIndex: 'ORDER_P'			, width: 100},
			{dataIndex: 'ORDER_PRICE'		, width: 100, summaryType: 'sum'},		//20210614 수정: , summaryType: 'sum' 추가
			{dataIndex: 'ORDER_TAX_O'		, width: 100, summaryType: 'sum'},		//20210614 수정: , summaryType: 'sum' 추가
			{dataIndex: 'SUM_PRICE'			, width: 100, summaryType: 'sum'},		//20210614 수정: , summaryType: 'sum' 추가
			{dataIndex: 'TAX_INOUT'			, width: 100, align: 'center'},
			{dataIndex: 'BILL_TYPE'			, width: 100, align: 'center'},			//20210217 추가
			{dataIndex: 'CARD_CUSTOM_CODE'	, width: 100, align: 'center'},			//20210223 추가
			{dataIndex: 'ACCOUNT_YNC'		, width: 100, align: 'center'},			//20210406 추가
			{dataIndex: 'SHOP_ORD_NO'		, width: 110},							//20201216 수정: 사이즈 변경 100 -> 110
			{dataIndex: 'RECEIVER_NAME'		, width: 100},
			{dataIndex: 'TELEPHONE_NUM1'	, width: 120},
			{dataIndex: 'TELEPHONE_NUM2'	, width: 120},
			{dataIndex: 'DELIV_METHOD'		, width: 100},							//20201229 수정: 위치 변경
			{dataIndex: 'ZIP_NUM'			, width: 100	,
				//20201216 추가: 팝업으로 변경
				editor: Unilite.popup('ZIP_G',{
					textFieldName	: 'ZIP_NUM',
					DBtextFieldName	: 'ZIP_NUM',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('ADDRESS1', records[0]['ZIP_NAME']);
								grdRecord.set('ADDRESS2', records[0]['ADDR2']);
								grdRecord.set('ZIP_NUM'	, records[0]['ZIP_CODE']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ADDRESS1', '');
							grdRecord.set('ADDRESS2', '');
							grdRecord.set('ZIP_NUM'	, '');
						},
						applyextparam: function(popup){
							var grdRecord	= detailGrid.uniOpt.currentRecord;
							var paramAddr	= grdRecord.get('ADDRESS1'); //우편주소 파라미터로 넘기기
							if(Ext.isEmpty(paramAddr)){
								popup.setExtParam({'GBN': 'post'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							} else {
								popup.setExtParam({'GBN': 'addr'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							}
							popup.setExtParam({'ADDR': paramAddr});
						}
					}
				})
			},
			{dataIndex: 'ADDRESS1'			, width: 200},
			{dataIndex: 'ADDRESS2'			, width: 200},
			{dataIndex: 'PAY_TIME'			, width: 130, align: 'center'},	//20201229 추가
			{dataIndex: 'DELIV_PRICE'		, width: 100, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 100, hidden: true},
			{dataIndex: 'CUSTOMER_ID'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_NAME'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_TEL1'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_TEL2'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_MAIL'		, width: 100, hidden: true},
			{dataIndex: 'MSG'				, width: 200, hidden: false},	//20210329 수정: hidden: false
			{dataIndex: 'SENDER_CODE'		, width: 100, hidden: true},
			{dataIndex: 'SENDER'			, width: 100, hidden: true},
			{dataIndex: 'SHOP_ORD_NO'		, width: 100, hidden: true},
			{dataIndex: 'SHOP_SALE_NO'		, width: 100, hidden: true}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
				detailStore2.clearFilter();
				//20201217 추가: 저장 비활성화 원인 보정
				var needSave = detailStore.isDirty() || detailStore2.isDirty() ? true: false;
				//선택된 행의 저장된 데이터만 detailGrid에 보여주도록 filter
				if(selected && selected[0]) {
					detailStore2.filterBy(function(record){
						return record.get('BUNDLE_NO') == selected[0].get('BUNDLE_NO')
							&& record.get('ORDER_NUM') == selected[0].get('ORDER_NUM')
							&& record.get('SER_NO') == selected[0].get('SER_NO');
					})
				} else {
					detailStore2.filterBy(function(record){
						return record.get('BUNDLE_NO') == 'ZZZZZ';
					})
				}
				//20201217 추가: 저장 비활성화 원인 보정
				UniAppManager.setToolbarButtons('save', needSave);
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
				detailStore2.clearFilter();
				//20201217 추가: 저장 비활성화 원인 보정
				var needSave = detailStore.isDirty() || detailStore2.isDirty() ? true: false;
				//선택된 행의 저장된 데이터만 detailGrid에 보여주도록 filter
				if(thisRecord) {
					detailStore2.filterBy(function(record){
						return record.get('BUNDLE_NO') == thisRecord.get('BUNDLE_NO')
							&& record.get('ORDER_NUM') == thisRecord.get('ORDER_NUM')
							&& record.get('SER_NO') == thisRecord.get('SER_NO');
					})
				}
				//20201217 추가: 저장 비활성화 원인 보정
				UniAppManager.setToolbarButtons('save', needSave);
				//20201217 추가: 삭제버튼 비활성화 원인 보정
				if(detailStore.data.items.length + detailStore2.data.items.length > 0) {
					UniAppManager.setToolbarButtons('delete', true);
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				//20210319 추가: 출하지시 된 데이터는 수정 불가
				if(e.record.get('SRQ_YN') == 'Y') {			//20210322 수정: 오타 수정
					return false;
				}
				//20210219 추가: 배송비 행은 수정 불가, 20210409 수정: 수주등록에서 등록한 데이터 때문에 배송비 코드(ZXDEZZ001N: 택배비)도 비교하도록 수정
				if (Ext.isEmpty(e.record.get('BUNDLE_NO')) && Ext.isEmpty(e.record.get('UNIQUEID')) && Ext.isEmpty(e.record.get('NUMBER')) && e.record.get('ITEM_CODE') == 'ZXDEZZ001N') {
					return false;
				}
				//20210223 추가: 부가세 유형은 수정 가능 && 부가세유형이 카드매출일 경우, 카드사 필드도 수정 가능, 단, 택배비는 제외, 20210406 추가: ACCOUNT_YNC 추가
				if (UniUtils.indexOf(e.field, ['BILL_TYPE', 'ACCOUNT_YNC'])) {
					return true;
				}
				if (e.record.get('BILL_TYPE') == '40' && UniUtils.indexOf(e.field, ['CARD_CUSTOM_CODE'])) {		//카드매출일 경우 카드사 필드 수정 가능
					return true;
				}
				if(e.record.phantom) {					//신규일 때
					//20201210 추가: 참조 적용된 데이터는 수량, 단가 수정 불가
					if(!Ext.isEmpty(e.record.get('UNIQUEID'))) {
						if (UniUtils.indexOf(e.field, ['SITE_NAME', 'ITEM_CODE', 'ITEM_NAME', 'SHOP_SALE_NAME', 'SHOP_ORD_NO'
													, 'RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2', 'ZIP_NUM', 'ADDRESS1', 'ADDRESS2', 'DELIV_METHOD'
													, 'BILL_TYPE', 'MSG'])) {																							//20210217 추가: BILL_TYPE 추가, 20210329: MSG 추가
							return true;
						} else {
							return false;
						}
					} else {
						//20210319 추가: 단가 가져오기 위해서 판매사이트(거래처) 필수 임
						if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME'])) {
							if(Ext.isEmpty(e.record.get('SITE_CODE'))) {
								Unilite.messageBox('판매사이트 먼저 등록하세요.');
								return false;
							}
						}
						if (UniUtils.indexOf(e.field, ['SITE_NAME', 'ITEM_CODE', 'ITEM_NAME', 'SHOP_SALE_NAME', 'ORDER_Q', 'ORDER_P'/*, 'ORDER_PRICE'*/, 'SHOP_ORD_NO'	//20201210 수정: ORDER_PRICE 주석, ORDER_P 추가
													, 'RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2', 'ZIP_NUM', 'ADDRESS1', 'ADDRESS2', 'DELIV_METHOD'
													, 'BILL_TYPE', 'SUM_PRICE', 'MSG'])) {																				//20210217 추가: BILL_TYPE 추가, 20210319 추가: SUM_PRICE, 20210329: MSG 추가
							return true;
						} else {
							return false;
						}
					}
				} else {								//신규가 아닐때
					if(Ext.isEmpty(e.record.get('BUNDLE_NO')) || e.record.get('ORDER_NUM') == e.record.get('BUNDLE_NO')) {												//20210409추가: 직접입력한 데이터는 출하지시 전까지는 신규행과 동일하게 수정 가능
						if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME'])) {
							if(Ext.isEmpty(e.record.get('SITE_CODE'))) {
								Unilite.messageBox('판매사이트 먼저 등록하세요.');
								return false;
							}
						}
						if (UniUtils.indexOf(e.field, ['SITE_NAME', 'ITEM_CODE', 'ITEM_NAME', 'SHOP_SALE_NAME', 'ORDER_Q', 'ORDER_P', 'SHOP_ORD_NO'
													, 'RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2', 'ZIP_NUM', 'ADDRESS1', 'ADDRESS2', 'DELIV_METHOD'
													, 'BILL_TYPE', 'SUM_PRICE', 'MSG'])) {
							return true;
						} else {
							return false;
						}
					} else {
						if (UniUtils.indexOf(e.field, ['RECEIVER_NAME', 'TELEPHONE_NUM1', 'TELEPHONE_NUM2', 'ZIP_NUM', 'ADDRESS1', 'ADDRESS2', 'DELIV_METHOD', 'MSG'])) {	//20210329: MSG 추가
							return true;
						} else {
							return false;
						}
					}
				}
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
				});
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'	, '');
				grdRecord.set('ITEM_NAME'	, '');
				grdRecord.set('SPEC'		, '');
			} else {
				grdRecord.set('ITEM_CODE'	, record[0].ITEM_CODE);
				grdRecord.set('ITEM_NAME'	, record[0].ITEM_NAME);
				grdRecord.set('SPEC'		, record[0].SPEC);
				//20210319 추가
				UniSales.fnGetItemInfo(
						grdRecord
						, UniAppManager.app.cbGetItemInfo
						,'I'
						,UserInfo.compCode
						,grdRecord.get('SITE_CODE')
						,CustomCodeInfo.gsAgentType
						,record[0].ITEM_CODE
						,'KRW'
						,record[0].SALE_UNIT
						,record[0].STOCK_UNIT
						,record[0].TRANS_RATE
						,UniDate.getDbDateStr(panelResult.getValue('ORDER_DATE'))
						,grdRecord.get('ORDER_Q')
						,record[0].WGT_UNIT
						,record[0].VOL_UNIT
						,''
						,''
						,''
						,panelResult.getValue('DIV_CODE')
						, null
						, ''
				);
			}
			//기존 detail data 삭제
//			detailStore2.clearFilter();
			var deleteRecords	= new Array();
			var records2		= detailStore2.data.items;
			Ext.each(records2, function(record2,i) {
				if(grdRecord.get('BUNDLE_NO')	== record2.get('BUNDLE_NO')
				&& grdRecord.get('ORDER_NUM')	== record2.get('ORDER_NUM')
				&& grdRecord.get('SER_NO')		== record2.get('SER_NO')) {
					deleteRecords.push(record2);
				}
			});
			detailStore2.remove(deleteRecords);
			if(!dataClear) {
				//새로 입력한 품목에 맞는 옵션정보 생성
				var param = {
					'COMP_CODE'	: UserInfo.compCode,
					'DIV_CODE'	: panelResult.getValue('DIV_CODE'),
					'ITEM_CODE'	: record[0].ITEM_CODE
				}
				s_sof103ukrv_wmService.getOpt(param, function(provider, response) {
					if(provider && provider.length > 0) {
						//하단 그리드에 옵션정보 생성
						Ext.each(provider, function(record, i) {
							UniAppManager.app.onNewDataButtonDown2();
							var grdRecord2 = detailGrid2.getSelectedRecord();
							grdRecord2.set('ITEM_CODE'		, record.ITEM_CODE);
							grdRecord2.set('ITEM_NAME'		, record.ITEM_NAME);
							grdRecord2.set('SPEC'			, record.SPEC);
							grdRecord2.set('UNIT_Q'			, record.UNIT_Q);
							grdRecord2.set('OLD_ITEM_CODE'	, record.OLD_ITEM_CODE);
							grdRecord2.set('OLD_ITEM_NAME'	, record.OLD_ITEM_NAME);
							grdRecord2.set('OLD_ITEM_SPEC'	, record.OLD_ITEM_SPEC);
							grdRecord2.set('OLD_UNIT_Q'		, record.OLD_UNIT_Q);
							grdRecord2.set('PROD_ITEM_CODE'	, record.PROD_ITEM_CODE);
						});
					} else {
						Unilite.messageBox('입력한 품목의 BOM정보가 없습니다.');
						return false;
					}
				});
			}
		}
	});




	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sof103ukrv_wmService.selectList2',
			update	: 's_sof103ukrv_wmService.updateDetail2',
			create	: 's_sof103ukrv_wmService.insertDetail2',
			destroy	: 's_sof103ukrv_wmService.deleteDetail2',
			syncAll	: 's_sof103ukrv_wmService.saveAll2'
		}
	});

	Unilite.defineModel('s_sof103ukrv_wmModel2', {	//S_SOF115T_WM에 저장
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'	, allowBlank: false},
			{name: 'UNIQUEID'			, text: 'UNIQUEID'		, type: 'string'},		//UNIQUEID
			{name: 'NUMBER'				, text: 'NUMBER'		, type: 'string'},		//NUMBER
			{name: 'PA_ADDCOL_GROUPING'	, text: 'PA_ADDCOL_GROUPING', type: 'string'},									//20210105 추가
			{name: 'ORDER_NUM'			, text: '수주번호'			, type: 'string'},
			{name: 'SER_NO'				, text: '수주순번'			, type: 'int'		, allowBlank: false},
			{name: 'SUB_SEQ'			, text: '구분'			, type: 'int'		, allowBlank: false},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'	, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'		, type: 'string', allowBlank: false},
			{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string', editable:false},
			{name: 'UNIT_Q'				, text: '수량'			, type: 'int'		, allowBlank: false},
			{name: 'UNIT_O'				, text: '금액'			, type: 'uniPrice'},						//20201208 추가:금액 필드 추가, 20201211 수정: 필수 제외
			{name: 'OLD_ITEM_CODE'		, text: '이전 품목'			, type: 'string'},
			{name: 'OLD_ITEM_NAME'		, text: '이전 품목명'		, type: 'string'},
			{name: 'OLD_ITEM_SPEC'		, text: '<t:message code="system.label.sales.spec" default="규격"/>'			, type: 'string', editable:false},
			{name: 'OLD_UNIT_Q'			, text: '이전 수량'			, type: 'int'},
			{name: 'PROD_ITEM_CODE'		, text: '모품목코드'			, type: 'string'},
			{name: 'BUNDLE_NO'			, text: '주문묶음번호'		, type: 'string'},							//BUNDLE_NO
			{name: 'REMARK'				, text: '비고'			, type: 'string'}							//20210316 추가
		]
	});

	var detailStore2 = Unilite.createStore('s_sof103ukrv_wmDetailStore2',{
		model	: 's_sof103ukrv_wmModel2',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function(newValue) {
			var param = panelResult.getValues();
			if(newValue) {
				param.rdoSelect = newValue;
			}
			console.log( param );
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				Ext.getCmp('s_sof103ukrv_wmApp').mask('옵션 데이터 생성 중...','loading-indicator');
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
							panelResult.setValue('KEY_VALUE', '');
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
	
							if(detailStore.getCount() == 0) {
								UniAppManager.app.onResetButtonDown();
							} else {
								UniAppManager.app.onQueryButtonDown();
							}
							Ext.getCmp('s_sof103ukrv_wmApp').unmask();
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				 detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(detailGrid.getStore().data.items.length > 1) {
					detailStore2.filterBy(function(record){
						return record.get('BUNDLE_NO') == 'ZZZZZ';
					})
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var detailGrid2 = Unilite.createGrid('s_sof103ukrv_wmGrid2', {
		store	: detailStore2,
		layout	: 'fit',
		region	: 'south',
		split	: true,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: true}],
		columns	: [
			{dataIndex: 'UNIQUEID'			, width: 100, hidden: true},
			{dataIndex: 'NUMBER'			, width: 100, hidden: true},
			{dataIndex: 'PA_ADDCOL_GROUPING', width: 100, hidden: true},		//20210105 추가
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 100, hidden: true},
			{dataIndex: 'SER_NO'			, width: 100, hidden: true},
			{dataIndex: 'SUB_SEQ'			, width: 80	, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},																	//20210614 수정: 합계 추가
			{dataIndex: 'ITEM_CODE'			, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								detailGrid2.setItemData(records, false, detailGrid2.uniOpt.currentRecord);
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid2.setItemData(null, true, detailGrid2.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: divCode});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 150,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup	: true,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								detailGrid2.setItemData(records, false, detailGrid2.uniOpt.currentRecord);
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid2.setItemData(null, true, detailGrid2.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'POPUP_TYPE'	: 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'	: divCode});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'UNIT_Q'			, width: 100, align: 'center'},
			{dataIndex: 'UNIT_O'			, width: 100, summaryType: 'sum'},	//20201208 추가:금액 필드 추가, 20210614 수정: , summaryType: 'sum' 추가
			{dataIndex: 'OLD_ITEM_CODE'		, width: 120},
			{dataIndex: 'OLD_ITEM_NAME'		, width: 150},
			{dataIndex: 'OLD_ITEM_SPEC'		, width: 130},
			{dataIndex: 'OLD_UNIT_Q'		, width: 100, align: 'center'},
			{dataIndex: 'REMARK'			, width: 200}						//20210316 추가
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom) {		//신규일 때
					if (UniUtils.indexOf(e.field, ['UNIQUEID', 'NUMBER', 'BUNDLE_NO', 'COMP_CODE', 'DIV_CODE', 'ORDER_NUM', 'SER_NO', 'SUB_SEQ'
												, 'SPEC'/*, 'UNIT_O'*/, 'OLD_ITEM_CODE', 'OLD_ITEM_NAME', 'OLD_ITEM_SPEC', 'OLD_UNIT_Q', 'PROD_ITEM_CODE'])) {	//20210201 주석: 금액 필드 수정가능하도록 변경
						return false;
					} else {
						return true;
					}
				} else {					//신규가 아닐 때
					if (UniUtils.indexOf(e.field, ['UNIQUEID', 'NUMBER', 'BUNDLE_NO', 'COMP_CODE', 'DIV_CODE', 'ORDER_NUM', 'SER_NO', 'SUB_SEQ'
												, 'SPEC'/*, 'UNIT_O'*/, 'OLD_ITEM_CODE', 'OLD_ITEM_NAME', 'OLD_ITEM_SPEC', 'OLD_UNIT_Q', 'PROD_ITEM_CODE'])) {	//20210201 주석: 금액 필드 수정가능하도록 변경
						return false;
					} else {
						return true;
					}
				}
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
				});
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, '');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
			} else {
				grdRecord.set('ITEM_CODE'		, record[0].ITEM_CODE);
				grdRecord.set('ITEM_NAME'		, record[0].ITEM_NAME);
				grdRecord.set('SPEC'			, record[0].SPEC);
			}
		}
	});



	Unilite.Main({
		id			: 's_sof103ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid, detailGrid2
			]
		}],
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);	//20201029 수정: 행 추가 기능 추가
			this.setDefault();

			//20210316 추가: 링크 받는 로직 추가
			if(params && params.PGM_ID) {
				this.processParams(params);
			}
		},
		setDefault: function() {
			initFlag = true;					//20210201 추가
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			var field = panelResult.getField('ORDER_PRSN');					//20201221 추가: 영업담당 필터링로직 추가
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, 'DIV_CODE');
			panelResult.setValue('ORDER_PRSN'	, BsaCodeInfo.defaultSalePrsn);
			panelResult.setValue('ORDER_DATE'	, new Date());
			panelResult.setValue('FROM_DATE'	, gsFromDate);				//20210319 추가
			panelResult.setValue('TAX_INOUT'	, '2');						//20201202 추가 - 세포함여부(1: 별도, 2: 포함), 20201211 기본값 변경: 별도 -> 포함
			panelResult.setValue('rdoSelect'	, 'A');						//20210201 추가
			initFlag = false;					//20210201 추가
		},
		//20210316 추가: 링크 받는 로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 's_sof103skrv_wm') {
//				gsLinkFlag = 'Y';
				panelResult.setValue('DIV_CODE'		, params.DIV_CODE);
				panelResult.setValue('ORDER_DATE'	, params.ORDER_DATE);
				panelResult.setValue('ORDER_PRSN'	, params.ORDER_PRSN);
				panelResult.setValue('ORDER_NAME'	, params.ORDER_NAME);
				setTimeout(function(){
					UniAppManager.app.onQueryButtonDown();
				}, 600);
			}
		},
		onQueryButtonDown: function () {
			if(!panelResult.getInvalidMessage()) return;					//필수체크
			panelResult.setAllFieldsReadOnly(true);
			detailStore.loadStoreRecords();
			detailStore2.loadStoreRecords();
		},
		onNewDataButtonDown : function() {
			//20201216 추가: detailGrid2 행추가 기능
			if(activeGridId == 's_sof103ukrv_wmGrid') {
				var masterRecords	= detailStore.data.items;
				var err				= false;
				Ext.each(masterRecords, function(masterRecord,i) {
					if(!masterRecord.phantom) {
						err = true;
						return false;
					}
				});
				if(err) {
					Unilite.messageBox('신규 버튼을 누른 후 진행하세요.');
					return false;
				}
				var uniqueId= makeUniqueIdAndNumber(true);
				var number	= makeUniqueIdAndNumber(false);
				var seq		= detailStore.max('SER_NO');
				if(!seq) {
					seq = 1;
				} else {
					seq += 1;
				}
				var r = {
					'COMP_CODE'	: UserInfo.compCode,
					'DIV_CODE'	: panelResult.getValue('DIV_CODE'),
					'UNIQUEID'	: '',												//20201208 수정: UNIQUEID에 ORDER_NUM + SER_NO(3자리) 입력하기 위해서 수정 - uniqueId, -> '',
					'NUMBER'	: number,
					'BUNDLE_NO'	: uniqueId,
					'SER_NO'	: seq,
					'ORDER_Q'	: 1,
					'DVRY_DATE'	: UniDate.add(panelResult.getValue('ORDER_DATE'), {days: 1}),
					'TAX_INOUT'	: panelResult.getValue('TAX_INOUT'),				//20201202 추가 - 세포함여부(1: 별도, 2: 포함)
					'PAY_TIME'	: realTimer(),										//20201229 추가 - 행추가 시, 현재시간(yyyy-mm-dd hh:mm:ss) 표시 위해
					'BILL_TYPE'	: '10',												//20210217 추가 - 기본값 '10'
					'SRQ_YN'	: 'N'												//20210319 추가 - 출하지시등록 여부
				};
				if(!panelResult.setAllFieldsReadOnly(true)) return false;			//20201221 수정: 필수체크하도록 변경
				detailGrid.createRow(r);
			} else {
				//20210319 추가: 출하지시등록 된 데이터는 수정할 수 없도록 로직 추가
				var record = detailGrid.getSelectedRecord();
				if(record.get('SRQ_YN') == 'Y') {				//20210322 수정: 오타 수정
					Unilite.messageBox('출하지시등록된 데이터는 수정할 수 없습니다.');
					return false;
				}
				UniAppManager.app.onNewDataButtonDown2();
			}
		},
		onNewDataButtonDown2 : function() {
//			var uniqueId= makeUniqueIdAndNumber(true);
//			var number	= makeUniqueIdAndNumber(false);
			var record	= detailGrid.getSelectedRecord();
			var seq		= detailStore2.max('SUB_SEQ');
			if(!seq) {
				seq = 1;
			} else {
				seq += 1;
			}
			var remark = '';
			//20210316 추가: 상단 그리드의 선택된 행이 신규가 아닐 경우, REMARK에 추가한 일자 표기
			if(record.phantom != true) {
				remark =  UniDate.getDbDateStr(new Date()).substring(0, 4) + '.'
						+ UniDate.getDbDateStr(new Date()).substring(4, 6) + '.'
						+ UniDate.getDbDateStr(new Date()).substring(6, 8) + ' 추가'
			}

			var r = {
				'COMP_CODE'			: record.get('COMP_CODE'),
				'DIV_CODE'			: record.get('DIV_CODE'),
				'UNIQUEID'			: record.get('UNIQUEID'),
				'NUMBER'			: record.get('NUMBER'),
				'BUNDLE_NO'			: record.get('BUNDLE_NO'),
				'PA_ADDCOL_GROUPING': record.get('PA_ADDCOL_GROUPING'),		//20210106 추가
				'ORDER_NUM'			: record.get('ORDER_NUM'),
				'SER_NO'			: record.get('SER_NO'),
				'SUB_SEQ'			: seq,
				'REMARK'			: remark								//20210316 추가
			};
			detailGrid2.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			if(activeGridId == 's_sof103ukrv_wmGrid') {
				var selRow = detailGrid.getSelectedRecord();
				//20210106 추가
				if(Ext.isEmpty(selRow)) {
					Unilite.messageBox('선택된 데이터가 없습니다.');
					return false;
				}
				if(selRow.phantom === true) {
					//20201028 추가: 상위 그리드 삭제 시 하위 데이터 삭제
					detailStore2.clearFilter();
					var deleteRecords	= new Array();
					var records2		= detailStore2.data.items;
					Ext.each(records2, function(record2,i) {
						if(selRow.get('BUNDLE_NO') == record2.get('BUNDLE_NO')
						&& selRow.get('ORDER_NUM') == record2.get('ORDER_NUM')
						&& selRow.get('SER_NO') == record2.get('SER_NO')) {
							deleteRecords.push(record2);
						}
					});
					detailStore2.remove(deleteRecords);
					detailGrid.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {												//동시매출발생이 아닌 경우,매출존재체크 제외
						Unilite.messageBox('<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
						return false;
					}
					//20201028 추가: 상위 그리드 삭제 시 하위 데이터 삭제
					detailStore2.clearFilter();
					var deleteRecords	= new Array();
					var records2		= detailStore2.data.items;
					Ext.each(records2, function(record2,i) {
						if(selRow.get('BUNDLE_NO') == record2.get('BUNDLE_NO')
						&& selRow.get('ORDER_NUM') == record2.get('ORDER_NUM')
						&& selRow.get('SER_NO') == record2.get('SER_NO')) {
							deleteRecords.push(record2);
						}
					});
					detailStore2.remove(deleteRecords);
					detailGrid.deleteSelectedRow();
				}
			} else {
				//20210319 추가: 출하지시등록 된 데이터는 수정할 수 없도록 로직 추가
				var record = detailGrid.getSelectedRecord();
				if(record.get('SRQ_YN') == 'Y') {				//20210322 수정: 오타 수정
					Unilite.messageBox('출하지시등록된 데이터는 수정할 수 없습니다.');
					return false;
				}

				var selRow = detailGrid2.getSelectedRecord();
				if(Ext.isEmpty(selRow)) {
					Unilite.messageBox('선택된 데이터가 없습니다.');
					return false;
				}
				if(selRow.phantom === true) {
					detailGrid2.deleteSelectedRow();
				} else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					//체크로직?
					detailGrid2.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom) {							//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {										//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						Ext.each(records, function(record,i) {
							if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
								Unilite.messageBox('<t:message code="system.message.sales.message055" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');	//매출이 진행된 건은 수정/삭제할 수 없습니다.
								deletable = false;
								return false;
							}
							if(record.get('SALE_C_YN') == "Y") {
								Unilite.messageBox('<t:message code="system.message.sales.message056" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');	//계산서가 마감된 건은 수정/삭제가 불가능합니다.
								deletable = false;
								return false;
							}
						});
						if(deletable) {
							detailGrid.reset();
							detailStore2.clearFilter();
							detailGrid2.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData) {								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function (config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			detailStore2.clearFilter();
			if(detailStore.isDirty()) {
				detailStore.saveStore();
			} else {
				detailStore2.saveStore();
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.getStore().loadData({});		//20210217 수정: reset && clearData 대신 loadData로 변경
			detailGrid2.getStore().loadData({});	//20210217 수정: reset && clearData 대신 loadData로 변경
			this.fnInitBinding();
		},
		fnOrderAmtCal: function(rtnRecord, sType, nValue, sTaxType) {
			var dOrderQ			= sType=='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q')	, 0);
			var dOrderO			= sType=='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_PRICE'), 0);
			var dOrderP			= sType=='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_P')	, 0);
			var taxType			= Unilite.nvl(sTaxType, rtnRecord.get('BILL_TYPE') == '50' ? 2:1);
			var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
			var numDigitOfPrice	= UniFormat.Price.length - digit;

			if(sType == 'P' || sType == 'Q' || sType == 'Z') {				//업종별 프로세스 적용, 20210217 수정: || sType == 'Z' 추가
				dOrderO = Unilite.multiply(dOrderQ , dOrderP);
				rtnRecord.set('ORDER_PRICE', dOrderO);
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType);			//20210217 수정: , taxType 추가
			} else if(sType == 'O') {
				if(dOrderQ != 0) {
					dOrderP = UniSales.fnAmtWonCalc(dOrderO / dOrderQ, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice);
				}
				rtnRecord.set('ORDER_P', dOrderP);
				this.fnTaxCalculate(rtnRecord, dOrderO, taxType)
			}
		},
		fnTaxCalculate: function(rtnRecord, dOrderO, sTaxType) {
			var sTaxInoutType	= panelResult.getValue('TAX_INOUT');
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
			var dOrderAmtO		= 0;
			var dTaxAmtO		= 0;
			var dAmountI		= 0;
			var sWonCalBas		= CustomCodeInfo.gsUnderCalBase;
			var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
			var numDigitOfPrice	= UniFormat.Price.length - digit;

			if(sTaxInoutType == '1') {
				dOrderAmtO	= dOrderO;
				dTaxAmtO	= dOrderO * dVatRate / 100
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO, sWonCalBas, numDigitOfPrice);
				dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);
			} else if(sTaxInoutType == '2') {
				dAmountI	= dOrderO;
				dTemp		= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
				dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);
				dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice);
			}
			//20210217 추가
			if(sTaxType == '2' || sTaxType == '3') {
				dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice);
				dTaxAmtO	= 0;
			}
			rtnRecord.set('ORDER_PRICE'	, dOrderAmtO);
			rtnRecord.set('ORDER_TAX_O'	, dTaxAmtO);
			rtnRecord.set('SUM_PRICE'	, dOrderAmtO + dTaxAmtO);
		},
		//20210319 추가: UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params) {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);
			var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);// 판매단가(중량단위)
			var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);// 판매단가(부피단위)

			if(params.sType=='I' && dSalePrice != 0) {
				// 단가구분별 판매단가 계산
				if(params.priceType == 'A') {						   // 단가구분(판매단위)
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				} else if(params.priceType == 'B') {					   // 단가구분(중량단위)
					dSalePrice = dWgtPrice  * params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				} else if(params.priceType == 'C') {					   // 단가구분(부피단위)
					dSalePrice = dVolPrice  * params.unitVol;
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
				} else {
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// 판매단가 적용
				params.rtnRecord.set('ORDER_P',dSalePrice);

				params.rtnRecord.set('TRANS_RATE',provider['SALE_TRANS_RATE']);
				params.rtnRecord.set('DISCOUNT_RATE',provider['DC_RATE']);

				// 단가구분SET //1:가단가 2:진단가
				params.rtnRecord.set('PRICE_YN',provider['PRICE_TYPE']);
// params.rtnRecord.set('PRICE_TYPE',provider['PRICE_TYPE']);
			}
			// if(params.qty > 0)
			// UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P",
			// dSalePrice);

			if(params.qty > 0 && dSalePrice > 0 ) {
				UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P", dSalePrice)
			} else {
				var dTransRate = Unilite.nvl(params.rtnRecord.get('TRANS_RATE'),1);
				var dOrderQ = Unilite.nvl(params.rtnRecord.get('ORDER_Q'),0);
				var dOrderUnitQ = 0;

				dOrderUnitQ = dOrderQ * dTransRate;
				params.rtnRecord.set('ORDER_UNIT_Q', dOrderUnitQ);
			};
		},
		// UniSales.fnGetItemInfo callback 함수
		cbGetItemInfo: function(provider, params) {
			UniAppManager.app.cbGetPriceInfo(provider, params);
		}
	});



	function makeUniqueIdAndNumber(uniqueId) {		//true: UNIQUEID 생성(16진수 40자리), false: NUMBER 생성(10진수 7자리)
		var result = '';
		if(uniqueId) {
			var var1= Math.round(Math.random() * 0xFFFFFFFF).toString(16);
			var var2= Math.round(Math.random() * 0xFFFFFFFF).toString(16);
			var var3= Math.round(Math.random() * 0xFFFFFFFF).toString(16);
			var var4= Math.round(Math.random() * 0xFFFFFFFF).toString(16);
			var var5= Math.round(Math.random() * 0xFFFFFFFF).toString(16);
			result	= var1 + var2 + var3 + var4 + var5;
		} else {
			var var1= Math.floor(Math.random()*10).toString();
			var var2= Math.floor(Math.random()*10).toString();
			var var3= Math.floor(Math.random()*10).toString();
			var var4= Math.floor(Math.random()*10).toString();
			var var5= Math.floor(Math.random()*10).toString();
			var var6= Math.floor(Math.random()*10).toString();
			var var7= Math.floor(Math.random()*10).toString();
			result	= var1 + var2 + var3 + var4 + var5 + var6 + var7;
		}
		return result
	}



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue) {
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;

			if(record.get('ISSUE_REQ_Q') > 0 || record.get('OUTSTOCK_Q') > 0 ) {
				rv = '<t:message code="system.message.sales.datacheck007" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>';
			} else {
				switch(fieldName) {
				case 'ORDER_Q':	//수주량
					if(newValue <= 0) {
						rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('ORDER_Q', oldValue);
						break
					}
					var sOrderQ = Unilite.nvl(newValue, 0);
					var sIssueQ = Unilite.nvl(record.get('OUTSTOCK_Q'), 0);
					if(sOrderQ < sIssueQ) {
						rv = '<t:message code="system.message.sales.message039" default="납기일 이전이어야 합니다."/>';
						break;
					}
					UniAppManager.app.fnOrderAmtCal(record, 'Q', newValue);
					//20201217: 하단 수량 변경 로직
					var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
					var numDigitOfPrice	= UniFormat.Price.length - digit;
					var sWonCalBas		= CustomCodeInfo.gsUnderCalBase;
					var detail2Records	= detailStore2.data.items;
					Ext.each(detail2Records, function(detail2Record, i) {
						detail2Record.set('OLD_UNIT_Q'	, Unilite.multiply((detail2Record.get('UNIT_Q') / oldValue), newValue));	//20201221 수정
						detail2Record.set('UNIT_Q'		, Unilite.multiply((detail2Record.get('UNIT_Q') / oldValue), newValue));
						detail2Record.set('UNIT_P'		, UniSales.fnAmtWonCalc(Unilite.multiply((detail2Record.get('UNIT_P') / oldValue), newValue)), sWonCalBas, numDigitOfPrice);
					});
					break;

				case 'ORDER_P':
					if(oldValue != newValue) {
						if(newValue <= 0) {
							rv=Msg.sMB076;
							record.set('ORDER_P', oldValue);
							break
						}
						UniAppManager.app.fnOrderAmtCal(record, "P", newValue)
					}
					break;

				case 'ORDER_PRICE' :
					rv = true;
					if(oldValue == newValue){
						rv = false;
						break;
					}
					var accountYnc = record.get('ACCOUNT_YNC');	//20210406 수정: 매출대상 여부 수정가능하게 변경하여 그 값으로 설정
//					var accountYnc = 'Y';
					if(accountYnc == 'Y'){//매출대상일 경우에만 양수체크
						if(newValue <= 0) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							record.set('ORDER_PRICE', oldValue);
							rv = false;
							break
						}
					}
					var dTaxAmtO = Unilite.nvl(record.get('ORDER_TAX_O'), 0);
					if(newValue > 0 && dTaxAmtO > newValue)	 {
						rv='<t:message code="system.message.sales.message040" default="매출금액은 세액보다 커야 합니다."/>';
					} else {
						UniAppManager.app.fnOrderAmtCal(record, 'O', newValue);
						break;
					}
					break;

				//20210319 추가
				case 'SUM_PRICE' :
					rv = true;
					if(oldValue == newValue){
						rv = false;
						break;
					}
					var accountYnc = record.get('ACCOUNT_YNC');	//20210406 수정: 매출대상 여부 수정가능하게 변경하여 그 값으로 설정
//					var accountYnc = 'Y';
					if(accountYnc == 'Y'){												//매출대상일 경우에만 양수체크
						if(newValue <= 0) {
							rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							record.set('SUM_PRICE', oldValue);
							rv = false;
							break
						}
					}
					var sTaxInoutType	= panelResult.getValue('TAX_INOUT');			//세액 포함 여부
					var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
					var sWonCalBas		= CustomCodeInfo.gsUnderCalBase;
					var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
					var numDigitOfPrice	= UniFormat.Price.length - digit;
					var sTaxtype		= '1';
					if(panelResult.getValue('BILL_TYPE') == '50') {						//'영세매출'일 때만 '면세'로  계산...('영세' 아님)
						sTaxtype = '2'
					} else {
						sTaxtype = '1';
					}

					var dOrderAmtO		= 0;
					var dTaxAmtO		= 0;
					var dOrderP			= 0;

					dTaxAmtO			= newValue * dVatRate / (100 + dVatRate);								//세액
					dTaxAmtO			= UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);			//세액 끝전 처리
					dOrderAmtO			= newValue - dTaxAmtO													//공급가액
					if(sTaxInoutType == '1') {																	//별도
						dOrderP = UniSales.fnAmtWonCalc(dOrderAmtO / record.get('ORDER_Q'), sWonCalBas, 0);		//20210408 계산 로직 수정
					} else if(sTaxInoutType == '2') {
						dOrderP = UniSales.fnAmtWonCalc(newValue / record.get('ORDER_Q'), sWonCalBas, 0);		//20210408 계산 로직 수정
					}
					if(sTaxtype == '2' || sTaxtype == '3') {
						dOrderAmtO	= newValue;
						dTaxAmtO	= 0;
						dOrderP		= UniSales.fnAmtWonCalc(newValue / record.get('ORDER_Q'), sWonCalBas, 0);	//20210408 계산 로직 수정
					}
					record.set('ORDER_P'	, dOrderP);
					record.set('ORDER_PRICE', dOrderAmtO);
					record.set('ORDER_TAX_O', dTaxAmtO);
					break;

				//20210208 추가: 전화번호 입력 시, 전화번호 유효성 체크로직 추가
				case "TELEPHONE_NUM1" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('TELEPHONE_NUM1', oldValue);
							break;
						}
					}
					var saveFlag = panelResult.getValues().REGI_YN;
					if(saveFlag == 'Y') {
						record.set('OPR_FLAG', 'U');
					}
					break;

				//20210208 추가: 전화번호 입력 시, 전화번호 유효성 체크로직 추가
				case "TELEPHONE_NUM2" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('TELEPHONE_NUM2', oldValue);
							break;
						}
					}
					var saveFlag = panelResult.getValues().REGI_YN;
					if(saveFlag == 'Y') {
						record.set('OPR_FLAG', 'U');
					}
					break;

				//20210217 추가, 20210223 수정: 부가세 유형 변경 시 동일 ORDER_NUM의 부가세 유형 전체 변경
				case "BILL_TYPE" :
					var saveFlag = panelResult.getValues().REGI_YN;
					var sTaxtype = '1';
					if(newValue == '50') {			//'영세매출'일 때만 '면세'로 변경 후, 재계산...('영세' 아님)
						sTaxtype = '2'
					} else {
						sTaxtype = '1';
					}
					UniAppManager.app.fnOrderAmtCal(record, 'Z', null, sTaxtype);		//20210319 추가
					var dRecords = detailStore.data.items;
					Ext.each(dRecords, function(dRecord, index) {
						if(!Ext.isEmpty(record.get('ORDER_NUM')) && dRecord.get('ITEM_CODE') != 'ZXDEZZ001N' && record.get('ORDER_NUM') == dRecord.get('ORDER_NUM')) {
							var sOrderq = dRecord.get('ORDER_Q');
							UniAppManager.app.fnOrderAmtCal(dRecord, 'Z', null, sTaxtype);
							if(saveFlag == 'Y') {
								dRecord.set('OPR_FLAG', 'U');
							}
							dRecord.set('BILL_TYPE'			, newValue);
							dRecord.set('CARD_CUSTOM_CODE'	, '');		//20210224 추가: 부가세유형 변경 시, 카드사 컬럼 초기화
						}
					});
					break;

				//20210223 추가: 카드사 변경 시 동일 ORDER_NUM의 부가세 유형 전체 변경
				case "CARD_CUSTOM_CODE" :
					var saveFlag = panelResult.getValues().REGI_YN;
					var dRecords = detailStore.data.items;
					Ext.each(dRecords, function(dRecord, index) {
						if(!Ext.isEmpty(record.get('ORDER_NUM')) && dRecord.get('ITEM_CODE') != 'ZXDEZZ001N' && record.get('ORDER_NUM') == dRecord.get('ORDER_NUM')) {
							if(saveFlag == 'Y') {
								dRecord.set('OPR_FLAG', 'U');
							}
							dRecord.set('CARD_CUSTOM_CODE', newValue);
						}
					});
					break;
				}
			}
			return rv;
		}
	});

	//20210208 추가: 전화번호 체크로직 추가, 20210218 수정: 안심번호 체크로직 추가
	function tel_check(str) {
//		str = str.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
//		var regTel = /^(01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		str = str.replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
		var regTel = /^(050[2-8]{1}|01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		if(!regTel.test(str)) {
			return false;
		}
		return true;
	}



	//20201229 추가 - 행추가 시, 현재시간(yyyy-mm-dd hh:mm:ss) 표시 위해
	function realTimer() {
		const nowDate	= new Date();
		const year		= nowDate.getFullYear();
		const month		= nowDate.getMonth() + 1;
		const date		= nowDate.getDate();
		const hour		= nowDate.getHours();
		const min		= nowDate.getMinutes();
		const sec		= nowDate.getSeconds();
		return year + '-' + addzero(month) + '-' + addzero(date) + ' ' + addzero(hour) + ':'  + addzero(min) + ':' + addzero(sec);
	}
	//20201229 추가: 1자리수의 숫자인 경우 앞에 0을 붙여준다.
	function addzero(num) {
		if(num < 10) { num = '0' + num; }
		return num;
	}
};
</script>