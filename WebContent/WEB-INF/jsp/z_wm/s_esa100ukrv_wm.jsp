<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_esa100ukrv_wm"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>	<!-- 예/아니오-->
	<t:ExtComboStore comboType="AU" comboCode="S802"/>	<!-- 유무상구분-->
	<t:ExtComboStore comboType="AU" comboCode="S805"/>	<!-- 처리방법-->
	<t:ExtComboStore comboType="AU" comboCode="ZM05"/>	<!-- AS접수담당 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM06"/>	<!-- AS접수구분 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM07"/>	<!-- AS완료여부 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM08"/>	<!-- AS구분 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM09"/>	<!-- AS구분(세부내역) -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;};
	#ext-element-3 {align:center}
</style>
<script type="text/javascript">
	//우편번호 다음 API 연동
	var protocol = ("https:" == document.location.protocol) ? "https" : "http";
	if(protocol == "https")	{
		document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	} else {
		document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	}
</script><!-- Unilite.popup('ZIP',..) -->

<script type="text/javascript" >
function appMain() {
	var SearchInfoWindow;	//검색 팝업
	var OrderInfoWindow;	//수주상세 참조 팝업
	var isLoad		= false;
	var gsSaveFlag	= false;							//20210119 추가: 운송장 수량변경은 저장과 관련 없음 -> 운송장 출력, 반송요청 전 저장할 데이터는 저장해야 하므로 처리로직 필요
	var BsaCodeInfo	= {
		defaultReceiptPrsn: '${defaultReceiptPrsn}'		//20210119 추가 - 사용자의 접수담당 가져와서 기본값 SET하는 로직
	}

	var masterForm = Unilite.createForm('s_esa100ukrv_wmDetail', {
		disabled: false,
		border	: true,
		split	: true,
		region	: 'center',
		padding	: '1 1 1 1',
		layout	: {type : 'uniTable', columns : 3},
		api		: {
			load	: 's_esa100ukrv_wmService.selectForm',
			submit	: 's_esa100ukrv_wmService.syncForm'
		},
		items: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false
		},{
			fieldLabel	: '접수일',
			name		: 'ACCEPT_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false
		},{
			fieldLabel	: '접수번호',
			name		: 'AS_NUM',
			xtype		: 'uniTextfield',
			readOnly	: true
		},{
			fieldLabel	: '접수담당',
			name		: 'ACCEPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM05',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '접수구분',
			name		: 'ACCEPT_GUBUN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM06',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(isLoad) {		//20201204 추가
						isLoad = false;
						return false;
					}
					if(newValue && newValue != oldValue) {
						if(newValue != '1') {							//접수구분이 "바른서비스"이면 ref_code1값의 거래처정보 화면에 set
							var commonCodes = Ext.data.StoreManager.lookup('CBS_AU_ZM06').data.items;
							var basisValue;
							Ext.each(commonCodes,function(commonCode, i) {
								if(commonCode.get('value') == newValue) {
									basisValue = commonCode.get('refCode1');
								}
							})
							if(Ext.isEmpty(basisValue)) {
								Unilite.messageBox('공통코드에 거래처 정보를 등록하세요.');
								return false;
							}
							var param = {
								CUSTOM_CODE	: basisValue
							}
							s_esa100ukrv_wmService.getCustomInfo(param, function(provider, response){
								if(provider) {
									masterForm.setValues({
										PHONE		: provider[0].TELEPHON,
										HPHONE		: provider[0].HAND_PHON,
										ZIP_CODE	: provider[0].ZIP_CODE,
										ADDR1		: provider[0].ADDR1,
										ADDR2		: provider[0].ADDR2
									});
								}
							});
						} else {
							if(!Ext.isEmpty(masterForm.getValue('AS_PRSN')) && detailStore.data.items.length > 0) {		//접수구분이 "고객"이고 a/s요청자 값이 있으면 해당 요청자의 정보 화면에 set
								var detailData = detailStore.data.items;
								masterForm.setValues({
									PHONE		: detailData[0].data.TELEPHONE_NUM1,
									HPHONE		: detailData[0].data.TELEPHONE_NUM2,
									ZIP_CODE	: detailData[0].data.ZIP_NUM,
									ADDR1		: detailData[0].data.ADDRESS1,
									ADDR2		: detailData[0].data.ADDRESS2
								});
							} else {
								masterForm.setValues({
									PHONE		: '',
									HPHONE		: '',
									ZIP_CODE	: '',
									ADDR1		: '',
									ADDR2		: ''
								});
							}
						}
					}
				}
			}
		},{
			fieldLabel	: '완료여부',
			name		: 'AS_STATUS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM07',
			allowBlank	: false
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				fieldLabel	: 'A/S요청자',
				name		: 'AS_PRSN',
				xtype		: 'uniTextfield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							var newValue = masterForm.getValue('AS_PRSN');
							if(!Ext.isEmpty(newValue)) {
								openOrderInfoWindow();
							}
						}
					}
				}
			},{
				xtype	: 'button',
				text	: '검색',
				margin	: '0 0 3 2',
				itemId	: 'serchBtn',
				width	: 80,
				handler	: function() {
					openOrderInfoWindow();
				}
			}]
		},{
			fieldLabel	: '연락처',
			name		: 'PHONE',
			xtype		: 'uniTextfield',
			allowBlank	: false
		},{
			fieldLabel	: '휴대폰',
			name		: 'HPHONE',
			xtype		: 'uniTextfield'
		},
		Unilite.popup('CUST', {
			fieldLabel		: '거래처',
			valueFieldName	: 'AS_CUSTOMER_CD',
			textFieldName	: 'AS_CUSTOMER_NM',
			allowBlank		: false
		}),{//20201203 추가
			fieldLabel	: '구분',
			name		: 'AS_GUBUN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM08'
		},{	//20201203 추가
			fieldLabel	: '세부내역',
			name		: 'AS_GUBUN_DETAIL',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM09'
		},
		Unilite.popup('ZIP',{
			showValue		: false,
			textFieldName	: 'ZIP_CODE',
			DBtextFieldName	: 'ZIP_CODE',
			popupHeight		: 600,
			listeners		: {
				'onSelected': {
					fn: function(records, type  ){
						masterForm.setValue('ADDR1', records[0]['ZIP_NAME']);
						masterForm.setValue('ADDR2', records[0]['ADDR2']);
					},
					scope: this
				},
				'onClear' : function(type)	{
					masterForm.setValue('ADDR1', '');
					masterForm.setValue('ADDR2', '');
				},
				applyextparam: function(popup){
					var paramAddr	= masterForm.getValue('ADDR1'); //우편주소 파라미터로 넘기기
					if(Ext.isEmpty(paramAddr)){
						popup.setExtParam({'GBN': 'post'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
					} else {
						popup.setExtParam({'GBN': 'addr'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
					}
					popup.setExtParam({'ADDR': paramAddr});
				}
			}
		}),{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			colspan	: 2,
				items	: [{
				fieldLabel	: '주소',
				xtype		: 'uniTextfield',
				name		: 'ADDR1' ,
				holdable	: 'hold',
				width		: 350
			},{
				fieldLabel	: '',
				xtype		: 'uniTextfield',
				name		: 'ADDR2',
				holdable	: 'hold',
				width		: 143
			}]
		},{
			fieldLabel	: '비고',
			xtype		: 'uniTextfield',
			name		: 'REMARK' ,
			width		: 818,
			colspan		: 3
		},{
			fieldLabel	: '운송장번호',
			name		: 'INVOICE_NUM',
			xtype		: 'uniTextfield',
			hidden		: true			//20210119 수정: S_EAS110T_WM으로 이동
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			colspan	: 3,
			items	: [{
				fieldLabel	: '상담내용',
				xtype		: 'textarea',
				name		: 'SANGDAM_REMARK',
				width		: 516,
				height		: 50,
				listeners	: {
					focus: function(field, event, eOpts) {
						masterForm.setValue('SANGDAM_REMARK', '');
//						masterForm.setValue('MANAGE_REMARK'	, '');
					}
				}
			},{
				fieldLabel	: '',
				xtype		: 'textarea',
				name		: 'MANAGE_REMARK',
				margin		: '0 0 2 2',
				width		: 300,
				height		: 50,
				listeners	: {
					focus: function(field, event, eOpts) {
//						masterForm.setValue('SANGDAM_REMARK', '');
						masterForm.setValue('MANAGE_REMARK'	, '');
					}
				}
			}]
		},{
			fieldLabel	: 'ORDER_NUM',
			name		: 'ORDER_NUM',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'SER_NO',
			name		: 'SER_NO',
			xtype		: 'uniNumberfield',
			hidden		: true
		},{
			fieldLabel	: 'DELETE_ALL',
			name		: 'DELETE_ALL',
			xtype		: 'uniTextfield',
			hidden		: true
		}],
		listeners: {
			uniOnChange: function(basicForm, field, newValue, oldValue) {
				if(basicForm.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		}
	});


	/** 상담이력 (S_EAS130T_WM)
	 */
	Unilite.defineModel('s_esa100ukrv_wmOlModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '법인코드'			, type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장'			, type: 'string'},
			{name: 'AS_NUM'			, text: '상담코드'			, type: 'string'},
			{name: 'SANGDAM_SEQ'	, text: '순번'			, type: 'int'},
			{name: 'ACCEPT_DATE'	, text: '상담일자'			, type: 'uniDate'},
			{name: 'SANGDAM_REMARK'	, text: '상담내용'			, type: 'string'},
			{name: 'MANAGE_REMARK'	, text: '처리내용'			, type: 'string'},
			{name: 'UPDATE_USER_ID'	, text: '등록자'			, type: 'string'},
			{name: 'UPDATE_USER_NM'	, text: '등록자'			, type: 'string'},
			//SOF110T의 정보
			{name: 'ORDER_NUM'		, text: '수주번호'			, type: 'string'},
			{name: 'SER_NO'			, text: '수주순번'			, type: 'int'	, allowBlank: false},
			{name: 'UNIQUEID'		, text: 'UNIQUEID'		, type: 'string'},							//UNIQUEID
			{name: 'NUMBER'			, text: 'NUMBER'		, type: 'string'},							//NUMBER
			{name: 'SITE_CODE'		, text: '판매사이트코드'		, type: 'string', allowBlank: false},		//SITECODE
			{name: 'SITE_NAME'		, text: '판매사이트'			, type: 'string', allowBlank: false},		//SITENAME
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'					, type: 'string', allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string', editable: false},
			{name: 'ORDER_UNIT'		, text:'<t:message code="system.label.sales.unit" default="단위"/>'						, type: 'string', comboType: 'AU', comboCode: 'B013', allowBlank:false, displayField: 'value'},
			{name: 'SHOP_SALE_NAME'	, text: '상품명'			, type: 'string'},							//SHOP_SALE_NAME
			{name: 'SHOP_OPT_NAME'	, text: '옵션명'			, type: 'string'},							//SHOP_SALE_NAME
			{name: 'ORDER_Q'		, text: '수량'			, type: 'uniQty', allowBlank: false},		//COUNT
			{name: 'ORDER_PRICE'	, text: '판매가'			, type: 'uniUnitPrice'},					//PRICE
			{name: 'SHOP_ORD_NO'	, text: '주문번호'			, type: 'string'},							//SHOP_ORD_NO
			{name: 'RECEIVER_NAME'	, text: '수령자명'			, type: 'string'},							//RECIPIENTNAME
			{name: 'TELEPHONE_NUM1'	, text: '수령자전화번호'		, type: 'string'},							//RECIPIENTTEL
			{name: 'TELEPHONE_NUM2'	, text: '수령자핸드폰'		, type: 'string'},							//RECIPIENTHTEL
			{name: 'ZIP_NUM'		, text: '우편번호'			, type: 'string'},							//RECIPIENTZIP
			{name: 'ADDRESS1'		, text: '주소'			, type: 'string'},							//RECIPIENTADDRESS
			{name: 'DELIV_METHOD'	, text: '배송방법'			, type: 'string'},							//DELIVMETHOD
			{name: 'ISSUING_NUMBER'	, text: '운송장발행수'		, type: 'int'},
			{name: 'INVOICE_NUM'	, text: '운송장번호1'		, type: 'string'},
			{name: 'INVOICE_NUM2'	, text: '운송장번호2'		, type: 'string'},
			{name: 'TRNS_YN'		, text: '택배전송여부'		, type: 'string', comboType: 'AU', comboCode: 'B087'},
			{name: 'TRNS_ERROR'		, text: '오류'			, type: 'string'},
			{name: 'ORD_STATUS'		, text: 'ORD_STATUS'	, type: 'string'},							//ORD_STATUS
			{name: 'SENDER_CODE'	, text: '택배사코드'			, type: 'int'},								//SENDER_CODE
			{name: 'SENDER'			, text: '택배사'			, type: 'string'},							//SENDER
			{name: 'DELIV_PRICE'	, text: '배송비'			, type: 'uniPrice'},						//DELIVPRICE
			{name: 'DVRY_DATE'		, text: '배송예정일'			, type: 'uniPrice'},						//DELIVDATE
			{name: 'CUSTOMER_ID2'	, text: '주문자ID'			, type: 'string'},							//ORDERID
			{name: 'ORDER_NAME'		, text: '주문자명'			, type: 'string'},							//ORDERNAME
			{name: 'ORDER_TEL1'		, text: '주문자전화번호'		, type: 'string'},							//ORDERTEL
			{name: 'ORDER_TEL2'		, text: '주문자핸드폰'		, type: 'string'},							//ORDERHTEL
			{name: 'ORDER_MAIL'		, text: '주문자email'		, type: 'string'},							//ORDEREMAIL
			{name: 'MSG'			, text: '배송메세지'			, type: 'string'},							//MSG
			{name: 'INVOICE_NUM'	, text: '송장번호'			, type: 'string'},							//INVOICE_NUM
			{name: 'SHOP_SALE_NO'	, text: '쇼핑몰 판매번호'		, type: 'string'},							//SHOP_SALE_NO
			{name: 'ISSUE_REQ_Q'	, text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'		, type: 'uniQty' , defaultValue: 0},
			{name: 'OUTSTOCK_Q'		, text: 'OUTSTOCK_Q'	, type: 'int', defaultValue: 0}
		]
	});

	var outLineStore = Unilite.createStore('s_esa100ukrv_wmOutLineStore', {
		model	: 's_esa100ukrv_wmOlModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_esa100ukrv_wmService.selectOutLineList'
			}
		},
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords: function() {
			var param = masterForm.getValues();
			console.log(param);
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
						if(records.length > 0) {
							UniAppManager.setToolbarButtons(['deleteAll'], true);
						}
					}
				}
			});
		}
	});

	var outLineGrid = Unilite.createGrid('s_esa100ukrv_wmOutLineGrid', {
		title	: '상담이력',
		store	: outLineStore,
		region	: 'east',
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: true,
			userToolbar			: false,		//그리드 속성, 다운로드 등 툴바 사용 여부
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		columns: [
			{ dataIndex: 'COMP_CODE'		, width: 80	, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 80	, hidden: true},
			{ dataIndex: 'AS_NUM'			, width: 80	, hidden: true},
			{ dataIndex: 'SANGDAM_SEQ'		, width: 130, hidden: true},
			{ dataIndex: 'ACCEPT_DATE'		, width: 100},
			{ dataIndex: 'SANGDAM_REMARK'	, width: 250},
			{ dataIndex: 'MANAGE_REMARK'	, width: 250},
			{ dataIndex: 'UPDATE_USER_ID'	, width: 120, hidden: true},
			{ dataIndex: 'UPDATE_USER_NM'	, width: 100}
		],
		listeners: {
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				var saveFlag = UniAppManager.app._needSave();
				masterForm.setValue('SANGDAM_REMARK', record.get('SANGDAM_REMARK'));
				masterForm.setValue('MANAGE_REMARK'	, record.get('MANAGE_REMARK'));
				masterForm.getForm().wasDirty = false;
				masterForm.resetDirtyStatus();
				UniAppManager.setToolbarButtons(['save'], saveFlag);
			}
		}
	});



	/** orderGridModel (S_EAS110T_WM)
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_esa100ukrv_wmService.selectList',
			create	: 's_esa100ukrv_wmService.insertDetail',
			update	: 's_esa100ukrv_wmService.updateDetail',
			destroy	: 's_esa100ukrv_wmService.deleteDetail',
			syncAll	: 's_esa100ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_esa100ukrv_wmModel', {
		fields: [
			{name: 'DIV_CODE'		, text: '<t:message code="unilite.msg.sMS631" default="사업장"/>'		, type: 'string'	, comboType:'BOR120'},
			{name: 'ITEM_CODE'		, text: '<t:message code="unilite.msg.sMR004" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="unilite.msg.sMR349" default="품명"/>'		, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="unilite.msg.sMSR033" default="규격"/>'		, type: 'string'},
			{name: 'ORDER_DATE'		, text: '<t:message code="unilite.msg.sMS122" default="수주일"/>'		, type: 'uniDate'},
			{name: 'INOUT_DATE'		, text: '출고일'			, type: 'uniDate'},
			{name: 'DVRY_DATE'		, text: '<t:message code="unilite.msg.sMS123" default="납기일"/>'		, type: 'uniDate'},
			{name: 'ORDER_Q'		, text: '<t:message code="unilite.msg.sMS543" default="수주량"/>'		, type: 'uniQty'},
			{name: 'ORDER_NUM'		, text: '<t:message code="unilite.msg.sMS533" default="수주번호"/>'		, type: 'string'},
			{name: 'SER_NO'			, text: '<t:message code="unilite.msg.sMS783" default="수주순번"/>'		, type: 'int'},
			{name: 'CUSTOM_CODE'	, text: '<t:message code="unilite.msg.sMSR213" default="거래처"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '<t:message code="unilite.msg.sMSR279" default="거래처명"/>'	, type: 'string'},
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type: 'string'},
			{name: 'TELEPHONE_NUM1'	, text: 'TELEPHONE_NUM1', type: 'string'},
			{name: 'TELEPHONE_NUM2'	, text: 'TELEPHONE_NUM2', type: 'string'},
			{name: 'ZIP_NUM'		, text: 'ZIP_NUM'		, type: 'string'},
			{name: 'ADDRESS1'		, text: 'ADDRESS1'		, type: 'string'},
			{name: 'ADDRESS2'		, text: 'ADDRESS2'		, type: 'string'},
			//S_EAS110T_WM
			{name: 'AS_NUM'			, text: '상담코드'			, type: 'string'},
			{name: 'AS_SEQ'			, text: '순번'			, type: 'int'},
			{name: 'TO_AS_DATE'		, text: 'AS기간'			, type: 'uniDate'},
			{name: 'ARRIVAL_YN'		, text: '도착여부'			, type: 'string'	, comboType:'AU', comboCode:'B131'},
			{name: 'REMARK'			, text: '비고'			, type: 'string'},
			//20210118 추가: AS수량, 운송장수량, 운송장번호, 반송번호
			{name: 'AS_ACCEPT_Q'	, text: 'AS수량'			, type: 'uniQty'	, allowBlank: false},
			{name: 'INVOICE_Q'		, text: '운송장수량'			, type: 'uniQty'},
			{name: 'INVOICE_NUM'	, text: '운송장번호'			, type: 'string'},
			{name: 'RETURN_NUM'		, text: '반송번호'			, type: 'string'}
		]
	});

	var detailStore = Unilite.createStore('s_esa100ukrv_wmDetailStore', {
		model	: 's_esa100ukrv_wmModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords: function(FLAG) {
			var param = masterForm.getValues();
			if(!Ext.isEmpty(FLAG)) {
				param.REF_FLAG = FLAG;
			}
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var inValidRecs	= this.getInvalidRecords();
//			var list		= [].concat(toUpdate, toCreate, toDelete);
//			var listLength	= list.length;
			var paramMaster = masterForm.getValues();	//syncAll 수정
			if (inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						if (detailStore2.isDirty()) {
							detailStore2.saveStore();
						} else {
//							var master = batch.operations[0].getResultSet();
//							masterForm.setValue("AS_NUM", master.AS_NUM);
							masterForm.getForm().wasDirty = false;
							masterForm.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
							UniAppManager.app.onQueryButtonDown();
							Ext.getCmp('pageAll').getEl().unmask();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var detailGrid = Unilite.createGrid('s_esa100ukrv_wmGrid', {
//		title	: '고객주문정보',
		store	: detailStore,
		region	: 'south',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		tbar: [{
			itemId	: 'reqAsBtn',
			text	: 'AS 요청서',
			width	: 100,
			handler	: function() {
				var param			= masterForm.getValues();
				param.PGM_ID		= 's_esa100ukrv_wm';
				param.MAIN_CODE		= 'Z012';

				var win = Ext.create('widget.ClipReport', {
					url			: CPATH+'/z_wm/s_esa100clrkrv_wm.do',
					prgID		: 's_esa100ukrv_wm',
					extParam	: param,
					submitType	: 'POST'
				});
				win.center();
				win.show();
			}
		},{
			itemId	: 'carriageBillprintBtn',
			text	: '운송장 출력',
			width	: 100,
			handler	: function() {
				if(UniAppManager.app._needSave()) {
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
					return false;
				}
				//운송장번호 채번 / CJ interface 후, 출력로직 호출
				var selectedRecord		= detailGrid.getSelectedRecord();
				var param				= masterForm.getValues();
				param.InvoiceYn			= true;
				param.ISSUING_NUMBER	= selectedRecord.get('INVOICE_Q');
				//수화인 정보: masterForm 데이터 사용
				//상품정보
				param.ITEM_CODE			= selectedRecord.get('ITEM_CODE');
				param.ITEM_NAME			= selectedRecord.get('ITEM_NAME');
				param.AS_ACCEPT_Q		= selectedRecord.get('AS_ACCEPT_Q');
				param.CPATH				= CPATH;				//20210302 추가: TEST에서는 아래로직 수행하지 않도록 로직 추가

				if(param.ISSUING_NUMBER == 0) {
					Unilite.messageBox('출력할 운송장 수량이 0 입니다.');
					return false;
				}
				if(Ext.isEmpty(param.ZIP_CODE)) {
					Unilite.messageBox('운송장 출력 시, 우편번호는 필수입력 입니다.');
					masterForm.getField('ZIP_CODE').focus();
					return false;
				}
				s_esa100ukrv_wmService.insertTrnOrder (param, function(provider, response) {
					if(provider != 'success') {	//20210217 수정
						return false;
					}
					//운송장 출력
					var param			= masterForm.getValues();
					param.PGM_ID		= 's_esa100ukrv_wm(C)';
					param.MAIN_CODE		= 'Z012';

					var win = Ext.create('widget.ClipReport', {
						url			: CPATH + '/z_wm/s_esa100clukrv_wm(C).do',
						prgID		: 's_esa100ukrv_wm(C)',
						extParam	: param,
						submitType	: 'POST'
					});
					win.center();
					win.show();
				});
				UniAppManager.app.onQueryButtonDown();
			}
		},{
			itemId	: 'carriageBillprintBtn2',
			text	: '반송요청',
			width	: 100,
			handler	: function() {
				if(UniAppManager.app._needSave()) {
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
					return false;
				}
				//운송장번호 채번 / CJ interface 후, 출력로직 호출
				var selectedRecord		= detailGrid.getSelectedRecord();
				if(Ext.isEmpty(selectedRecord.get('INVOICE_NUM'))) {				//20210218 추가
					Unilite.messageBox('반송요청할 데이터가 없습니다.');
					return false;
				}
				if(selectedRecord.get('INVOICE_Q') == 0) {
					Unilite.messageBox('반송요청할 운송장 수량이 0 입니다.');
					return false;
				}
				var param				= masterForm.getValues();					//수화인 정보: masterForm 데이터 사용
				param.InvoiceYn			= false;
				param.ISSUING_NUMBER	= selectedRecord.get('INVOICE_Q');
				//상품정보
				param.ITEM_CODE			= selectedRecord.get('ITEM_CODE');
				param.ITEM_NAME			= selectedRecord.get('ITEM_NAME');
				param.AS_ACCEPT_Q		= selectedRecord.get('AS_ACCEPT_Q');
				param.INVOICE_NUM		= selectedRecord.get('INVOICE_NUM');		//20210218 추가
				param.CPATH				= CPATH;				//20210302 추가: TEST에서는 아래로직 수행하지 않도록 로직 추가

				if(Ext.isEmpty(param.ZIP_CODE)) {
					Unilite.messageBox('운송장 출력 시, 우편번호는 필수입력 입니다.');
					masterForm.getField('ZIP_CODE').focus();
					return false;
				}
				//20210218 수정: 체크로직 수정
				s_esa100ukrv_wmService.insertTrnOrder (param, function(provider, response) {
					if(!Ext.isEmpty(provider) && provider == 'success') {
						Unilite.messageBox('반송요청이 완료 되었습니다.');
						UniAppManager.app.onQueryButtonDown();
					}
				});
			}
		}],
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 80	, hidden:true},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 150},
			{dataIndex: 'ORDER_DATE'	, width: 80},
			{dataIndex: 'INOUT_DATE'	, width: 80},
			{dataIndex: 'DVRY_DATE'		, width: 80, hidden:true},
			{dataIndex: 'ORDER_Q'		, width: 90},
			//20210118 추가: AS수량, 운송장수량
			{dataIndex: 'AS_ACCEPT_Q'	, width: 90},
			{dataIndex: 'INVOICE_Q'		, width: 90},
			{dataIndex: 'ORDER_NUM'		, width: 120},
			{dataIndex: 'SER_NO'		, width: 70	, align:'center'},
			{dataIndex: 'CUSTOM_CODE'	, width: 120, hidden:true},
			{dataIndex: 'CUSTOM_NAME'	, width: 200, hidden:true},
			{dataIndex: 'AS_NUM'		, width: 120, hidden:true},
			{dataIndex: 'AS_SEQ'		, width: 200, hidden:true},
			{dataIndex: 'TO_AS_DATE'	, width: 80},
			{dataIndex: 'ARRIVAL_YN'	, width: 80	, align:'center'},
			{dataIndex: 'REMARK'		, width: 200},
			//20210118 추가: 운송장번호, 반송번호
			{dataIndex: 'INVOICE_NUM'	, width: 200},
			{dataIndex: 'RETURN_NUM'	, width: 200}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				//완료여부 체크하여 완료일 경우에는 수정 안 됨
				var asStatus = masterForm.getValue('AS_STATUS');
				if(asStatus == '9') {
					Unilite.messageBox('완료된 데이터는 수정할 수 없습니다.');
					return false;
				} else {
					if (UniUtils.indexOf(e.field, ['ARRIVAL_YN', 'REMAK'
												, 'AS_ACCEPT_Q', 'INVOICE_Q'])) {		//20210118 추가: AS수량, 운송장수량
						return true;
					} else {
						return false;
					}
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			},
			//20210119 추가: 운송장 수량변경은 저장과 관련 없음 -> 운송장 출력, 반송요청 전 저장할 데이터는 저장해야 하므로 처리로직 필요
			edit: function(editor, e) {
				if(editor.context.field == 'INVOICE_Q') {
					UniAppManager.setToolbarButtons(['save'], gsSaveFlag);
					if(!gsSaveFlag) {
						e.record.commit();
					}
				}
			}
		}
	});



	/** optionGridModel (S_EAS120T_WM)
	 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_esa100ukrv_wmService.selectList2',
			create	: 's_esa100ukrv_wmService.insertDetail2',
			update	: 's_esa100ukrv_wmService.updateDetail2',
			destroy	: 's_esa100ukrv_wmService.deleteDetail2',
			syncAll	: 's_esa100ukrv_wmService.saveAll2'
		}
	});

	Unilite.defineModel('s_esa100ukrv_wmModel2', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'	, type: 'string'},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'	, type: 'string'},
			{name: 'AS_NUM'			, text: 'AS_NUM'	, type: 'string'},
			{name: 'AS_SEQ'			, text: 'AS_SEQ'	, type: 'int'},
			{name: 'SUB_SEQ'		, text: 'SUB_SEQ'	, type: 'int'},
			{name: 'ITEM_CODE'		, text: '<t:message code="unilite.msg.sMR004" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'		, text: '<t:message code="unilite.msg.sMR349" default="품명"/>'		, type: 'string'},
			{name: 'SPEC'			, text: '<t:message code="unilite.msg.sMSR033" default="규격"/>'		, type: 'string'},
			{name: 'UNIT_Q'			, text: '수량'		, type: 'uniQty'},
			{name: 'AS_Q'			, text: 'AS수량'		, type: 'uniQty'},
			{name: 'AS_P'			, text: '단가'		, type: 'uniUnitPrice'},
			{name: 'AS_O'			, text: '금액'		, type: 'uniPrice'},
			{name: 'AS_TAX'			, text: '부가세액'		, type: 'uniPrice'},
			{name: 'SALE_YN'		, text: '유/무상'		, type: 'string', comboType: 'AU', comboCode: 'S802'},
			{name: 'REQ_OUT_Q'		, text: '출고요청'		, type: 'uniQty'},
			{name: 'REQ_RETURN_Q'	, text: '반품예정'		, type: 'uniQty'},
			{name: 'OUT_Q'			, text: '출고수량'		, type: 'uniQty'},
			{name: 'RETURN_Q'		, text: '반품수량'		, type: 'uniQty'},
			{name: 'INOUT_NUM'		, text: '수불번호'		, type: 'string'},
			{name: 'INOUT_SEQ'		, text: '수불순번'		, type: 'int'},
			{name: 'REMARK'			, text: '비고'		, type: 'string'},
			{name: 'AS_P_REF'		, text: '단가(계산)'	, type: 'uniUnitPrice'},
			{name: 'AS_O_REF'		, text: '금액(계산)'	, type: 'uniPrice'}
		]
	});

	var detailStore2 = Unilite.createStore('s_esa100ukrv_wmDetailStore2', {
		model	: 's_esa100ukrv_wmModel2',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords: function(FLAG) {
			var param = masterForm.getValues();
			if(!Ext.isEmpty(FLAG)) {
				param.REF_FLAG = FLAG;
			}
			console.log(param);
			this.load({
				params	: param
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var inValidRecs	= this.getInvalidRecords();
//			var list		= [].concat(toUpdate, toCreate, toDelete);
//			var listLength	= list.length;
			var paramMaster = masterForm.getValues();	//syncAll 수정
			if (inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
//						var master = batch.operations[0].getResultSet();
//						masterForm.setValue("AS_NUM", master.AS_NUM);
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
						Ext.getCmp('pageAll').getEl().unmask();
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var detailGrid2 = Unilite.createGrid('s_esa100ukrv_wmGrid2', {
		title	: '주문옵션정보',
		store	: detailStore2,
		region	: 'south',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: true,
			userToolbar			: false,		//그리드 속성, 다운로드 등 툴바 사용 여부
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 80	, hidden:true},
			{dataIndex: 'ITEM_CODE'		, width: 120},
			{dataIndex: 'ITEM_NAME'		, width: 150},
			{dataIndex: 'SPEC'			, width: 150},
			{dataIndex: 'UNIT_Q'		, width: 100},
			{dataIndex: 'REQ_OUT_Q'		, width: 100},
			{dataIndex: 'REQ_RETURN_Q'	, width: 100},
			{dataIndex: 'OUT_Q'			, width: 100},
			{dataIndex: 'RETURN_Q'		, width: 100},
			{dataIndex: 'AS_P'			, width: 100},
			{dataIndex: 'AS_O'			, width: 100},
			{dataIndex: 'AS_TAX'		, width: 100},
			{dataIndex: 'SALE_YN'		, width: 80	, align: 'center'},
			{dataIndex: 'REMARK'		, width: 200},
			{dataIndex: 'AS_NUM'		, width: 200, hidden:true},
			{dataIndex: 'AS_SEQ'		, width: 120, hidden:true},
			{dataIndex: 'SUB_SEQ'		, width: 200, hidden:true},
			{dataIndex: 'AS_Q'			, width: 80	, hidden:true},
			{dataIndex: 'INOUT_NUM'		, width: 80	, hidden:true},
			{dataIndex: 'INOUT_SEQ'		, width: 80	, hidden:true},
			{dataIndex: 'AS_P_REF'		, width: 80	, hidden:false},
			{dataIndex: 'AS_O_REF'		, width: 80	, hidden:false}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				//완료여부 체크하여 완료일 경우에는 수정 안 됨
				var asStatus = masterForm.getValue('AS_STATUS');
				if(asStatus == '9') {
					Unilite.messageBox('완료된 데이터는 수정할 수 없습니다.');
					return false;
				} else {
					if (UniUtils.indexOf(e.field, ['REQ_OUT_Q', 'REQ_RETURN_Q', 'SALE_YN', 'REMARK'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			},
			edit: function(editor, e) {
			}
		}
	});





	/** 수주상세 팝업
	 */
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout: {
			type	: 'uniTable',
			columns	: 3
		},
		trackResetOnLoad: true,
		items: [{
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = orderNoSearch.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
			}, {
				fieldLabel		: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_ORDER_DATE',
				endFieldName	: 'TO_ORDER_DATE',
				width			: 350,
				startDate		: UniDate.get('twelveMonthsAgo'),
				endDate			: UniDate.get('today'),
				colspan			: 2
			}, {
				fieldLabel	: '<t:message code="unilite.msg.sMS573" default="sMS669"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
					if (eOpts) {
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
				validateBlank	: false,
				colspan			: 2,
				listeners		: {
					applyextparam: function(popup) {
						popup.setExtParam({
							'AGENT_CUST_FILTER': ['1', '3']
						});
						popup.setExtParam({
							'CUSTOM_TYPE': ['1', '3']
						});
					}
				}
			}),{
				fieldLabel	: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S002'
			},
			Unilite.popup('DIV_PUMOK', {
				colspan		: 2,
				listeners	: {
					applyextparam: function(popup) {
						popup.setExtParam({
							'DIV_CODE': orderNoSearch.getValue('DIV_CODE')
						});
					}
				}
			}),{
				fieldLabel	: '고객명',
				name		: 'AS_PRSN',
				xtype		: 'uniTextfield',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '비고',
				name		: 'REMARK'
			}
		]
	}); // createSearchForm

	Unilite.defineModel('orderNoDetailModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '법인코드'			, type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장'			, type: 'string'},
			{name: 'ORDER_DATE'		, text: '수주일'			, type: 'uniDate'},
			{name: 'ORDER_NUM'		, text: '수주번호'			, type: 'string'},
			{name: 'SER_NO'			, text: '수주순번'			, type: 'int'	, allowBlank: false},
			{name: 'UNIQUEID'		, text: 'UNIQUEID'		, type: 'string'},							//UNIQUEID
			{name: 'NUMBER'			, text: 'NUMBER'		, type: 'string'},							//NUMBER
			{name: 'CUSTOM_CODE'	, text: '판매사이트코드'		, type: 'string', allowBlank: false},		//SITECODE
			{name: 'CUSTOM_NAME'	, text: '판매사이트'			, type: 'string', allowBlank: false},		//SITENAME
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'					, type: 'string', allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.sales.spec" default="규격"/>'						, type: 'string', editable: false},
			{name: 'ORDER_UNIT'		, text:'<t:message code="system.label.sales.unit" default="단위"/>'						, type: 'string', comboType: 'AU', comboCode: 'B013', allowBlank:false, displayField: 'value'},
			{name: 'SHOP_SALE_NAME'	, text: '상품명'			, type: 'string'},							//SHOP_SALE_NAME
			{name: 'SHOP_OPT_NAME'	, text: '옵션명'			, type: 'string'},							//SHOP_SALE_NAME
			{name: 'ORDER_Q'		, text: '수량'			, type: 'uniQty', allowBlank: false},		//COUNT
			{name: 'ORDER_PRICE'	, text: '판매가'			, type: 'uniUnitPrice'},					//PRICE
			{name: 'SHOP_ORD_NO'	, text: '주문번호'			, type: 'string'},							//SHOP_ORD_NO
			{name: 'RECEIVER_NAME'	, text: '수령자명'			, type: 'string'},							//RECIPIENTNAME
			{name: 'TELEPHONE_NUM1'	, text: '수령자전화번호'		, type: 'string'},							//RECIPIENTTEL
			{name: 'TELEPHONE_NUM2'	, text: '수령자핸드폰'		, type: 'string'},							//RECIPIENTHTEL
			{name: 'ZIP_NUM'		, text: '우편번호'			, type: 'string'},							//RECIPIENTZIP
			{name: 'ADDRESS1'		, text: '주소'			, type: 'string'},							//RECIPIENTADDRESS
			{name: 'ADDRESS2'		, text: '주소2'			, type: 'string'},							//RECIPIENTADDRESS
			{name: 'DELIV_METHOD'	, text: '배송방법'			, type: 'string'},							//DELIVMETHOD
			{name: 'ISSUING_NUMBER'	, text: '운송장발행수'		, type: 'int'},
			{name: 'INVOICE_NUM'	, text: '운송장번호1'		, type: 'string'},
			{name: 'INVOICE_NUM2'	, text: '운송장번호2'		, type: 'string'},
			{name: 'TRNS_YN'		, text: '택배전송여부'		, type: 'string', comboType: 'AU', comboCode: 'B087'},
			{name: 'TRNS_ERROR'		, text: '오류'			, type: 'string'},
			{name: 'ORD_STATUS'		, text: 'ORD_STATUS'	, type: 'string'},							//ORD_STATUS
			{name: 'SENDER_CODE'	, text: '택배사코드'			, type: 'int'},								//SENDER_CODE
			{name: 'SENDER'			, text: '택배사'			, type: 'string'},							//SENDER
			{name: 'DELIV_PRICE'	, text: '배송비'			, type: 'uniPrice'},						//DELIVPRICE
			{name: 'DVRY_DATE'		, text: '배송예정일'			, type: 'uniPrice'},						//DELIVDATE
			{name: 'CUSTOMER_ID2'	, text: '주문자ID'			, type: 'string'},							//ORDERID
			{name: 'ORDER_NAME'		, text: '주문자명'			, type: 'string'},							//ORDERNAME
			{name: 'ORDER_TEL1'		, text: '주문자전화번호'		, type: 'string'},							//ORDERTEL
			{name: 'ORDER_TEL2'		, text: '주문자핸드폰'		, type: 'string'},							//ORDERHTEL
			{name: 'ORDER_MAIL'		, text: '주문자email'		, type: 'string'},							//ORDEREMAIL
			{name: 'MSG'			, text: '배송메세지'			, type: 'string'},							//MSG
			{name: 'INVOICE_NUM'	, text: '송장번호'			, type: 'string'},							//INVOICE_NUM
			{name: 'SHOP_SALE_NO'	, text: '쇼핑몰 판매번호'		, type: 'string'},							//SHOP_SALE_NO
			{name: 'ISSUE_REQ_Q'	, text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'		, type: 'uniQty' , defaultValue: 0},
			{name: 'OUTSTOCK_Q'		, text: 'OUTSTOCK_Q'	, type: 'int', defaultValue: 0},
			{name: 'INOUT_DATE'		, text: '출고일'			, type: 'uniDate'}
		]
	});

	var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
		model: 'orderNoDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: false, // 상위 버튼 연결
			editable: false, // 수정 모드 사용
			deletable: false, // 삭제 가능 여부
			useNavi: false // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_esa100ukrv_wmService.selectOrderNumDetailList'
			}
		},
		loadStoreRecords: function() {
			var param = orderNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode; // 부서코드
			if (authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))) {
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var orderNoDetailGrid = Unilite.createGrid('orderNoDetailGrid', {
		layout: 'fit',
		store: orderNoDetailStore,
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer	: true
		},
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'UNIQUEID'			, width: 100, hidden: true},
			{dataIndex: 'NUMBER'			, width: 100, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 100, hidden: true},
			{dataIndex: 'SER_NO'			, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_NAME'		, width: 100, align: 'center'},
			{dataIndex: 'CUSTOM_NAME'		, width: 100},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 150},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'ORDER_DATE'		, width: 100},
			{dataIndex: 'ORDER_Q'			, width: 80	, align: 'center'},
			{dataIndex: 'SHOP_SALE_NAME'	, width: 120},
			{dataIndex: 'SHOP_OPT_NAME'		, width: 120, hidden: true},
			{dataIndex: 'TELEPHONE_NUM1'	, width: 120},
			{dataIndex: 'TELEPHONE_NUM2'	, width: 120},
			{dataIndex: 'ZIP_NUM'			, width: 100},
			{dataIndex: 'ADDRESS1'			, width: 200},
			{dataIndex: 'ORDER_PRICE'		, width: 100, hidden: true},
			{dataIndex: 'SHOP_ORD_NO'		, width: 100, hidden: true},
			{dataIndex: 'RECEIVER_NAME'		, width: 100, hidden: true},
			{dataIndex: 'DELIV_METHOD'		, width: 100, hidden: true},
			{dataIndex: 'ORD_STATUS'		, width: 100, hidden: true},
			{dataIndex: 'DELIV_PRICE'		, width: 100, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 100, hidden: true},
			{dataIndex: 'CUSTOMER_ID2'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_TEL1'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_TEL2'		, width: 100, hidden: true},
			{dataIndex: 'ORDER_MAIL'		, width: 100, hidden: true},
			{dataIndex: 'MSG'				, width: 100, hidden: true},
			{dataIndex: 'SENDER_CODE'		, width: 100, hidden: true},
			{dataIndex: 'SENDER'			, width: 100, hidden: true},
			{dataIndex: 'ISSUING_NUMBER'	, width: 100, hidden: false},
			{dataIndex: 'INVOICE_NUM'		, width: 100, hidden: false},
			{dataIndex: 'INVOICE_NUM2'		, width: 100, hidden: false},
			{dataIndex: 'TRNS_YN'			, width: 100, hidden: false, align: 'center'},
			{dataIndex: 'TRNS_ERROR'		, width: 100, hidden: false},
			{dataIndex: 'INOUT_DATE'		, width: 100, hidden: false}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoDetailGrid.returnData(record)
				OrderInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if (Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			masterForm.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),
				'AS_CUSTOMER_CD'	: record.get('CUSTOM_CODE'),
				'AS_CUSTOMER_NM'	: record.get('CUSTOM_NAME'),
				'AS_PRSN'			: record.get('RECEIVER_NAME'),
				'ORDER_NUM'			: record.get('ORDER_NUM'),
				'SER_NO'			: record.get('SER_NO')
			});
			if(masterForm.getValue('ACCEPT_GUBUN') == '1') {
				masterForm.setValues({
					'PHONE'				: record.get('TELEPHONE_NUM1'),
					'HPHONE'			: record.get('TELEPHONE_NUM2'),
					'ZIP_CODE'			: record.get('ZIP_NUM'),
					'ADDR1'				: record.get('ADDRESS1'),
					'ADDR2'				: record.get('ADDRESS2')
				});
			}
			var param		= masterForm.getValues();
			param.REF_FLAG	= 'REF';
			s_esa100ukrv_wmService.selectList (param, function(provider, response) {
				if(response && !Ext.isEmpty(response.result)) {
					Ext.each(provider, function(record, i){
						UniAppManager.app.onNewDataButtonDown();
						var grdRecord = detailGrid.getSelectedRecord();
						grdRecord.set('COMP_CODE'		, record.COMP_CODE);
						grdRecord.set('DIV_CODE'		, record.DIV_CODE);
						grdRecord.set('ITEM_CODE'		, record.ITEM_CODE);
						grdRecord.set('ITEM_NAME'		, record.ITEM_NAME);
						grdRecord.set('ITEM_CODE'		, record.ITEM_CODE);
						grdRecord.set('SPEC'			, record.SPEC);
						grdRecord.set('ORDER_DATE'		, record.ORDER_DATE);
						grdRecord.set('INOUT_DATE'		, record.INOUT_DATE);
						grdRecord.set('ORDER_Q'			, record.ORDER_Q);
						grdRecord.set('ORDER_TYPE'		, record.ORDER_TYPE);
						grdRecord.set('ORDER_PRSN'		, record.ORDER_PRSN);
						grdRecord.set('ORDER_NUM'		, record.ORDER_NUM);
						grdRecord.set('SER_NO'			, record.SER_NO);
						grdRecord.set('CUSTOM_CODE'		, record.CUSTOM_CODE);
						grdRecord.set('CUSTOM_NAME'		, record.CUSTOM_NAME);
						grdRecord.set('TO_AS_DATE'		, record.TO_AS_DATE);
						grdRecord.set('ARRIVAL_YN'		, record.ARRIVAL_YN);
						grdRecord.set('TELEPHONE_NUM1'	, record.TELEPHONE_NUM1);
						grdRecord.set('TELEPHONE_NUM2'	, record.TELEPHONE_NUM2);
						grdRecord.set('ZIP_NUM'			, record.ZIP_NUM);
						grdRecord.set('ADDRESS1'		, record.ADDRESS1);
						grdRecord.set('ADDRESS2'		, record.ADDRESS2);
						//20210118 추가: AS수량, 운송장수량
						grdRecord.set('AS_ACCEPT_Q'		, record.ORDER_Q);
						grdRecord.set('INVOICE_Q'		, record.ORDER_Q);
					});
				}
			});
			s_esa100ukrv_wmService.selectList2 (param, function(provider, response) {
				if(response && !Ext.isEmpty(response.result)) {
					var maxAS_SEQ = detailGrid.getStore().max('AS_SEQ');
					Ext.each(provider, function(record, i){
						UniAppManager.app.onNewDataButtonDown2(maxAS_SEQ);
						var grdRecord = detailGrid2.getSelectedRecord();
						grdRecord.set('COMP_CODE'	, record.COMP_CODE);
						grdRecord.set('DIV_CODE'	, record.DIV_CODE);
						grdRecord.set('ORDER_NUM'	, record.ORDER_NUM);
						grdRecord.set('SER_NO'		, record.SER_NO);
						grdRecord.set('ITEM_CODE'	, record.ITEM_CODE);
						grdRecord.set('ITEM_NAME'	, record.ITEM_NAME);
						grdRecord.set('SPEC'		, record.SPEC);
						grdRecord.set('UNIT_Q'		, record.UNIT_Q);
						grdRecord.set('REQ_OUT_Q'	, record.REQ_OUT_Q);
						grdRecord.set('AS_P_REF'	, record.AS_P_REF);
						grdRecord.set('AS_O_REF'	, record.AS_O_REF);
						grdRecord.set('SALE_YN'		, record.SALE_YN);
						grdRecord.set('AS_SEQ'		, maxAS_SEQ);
					});
				}
			});
//			detailStore.loadStoreRecords('REF');
//			detailStore2.loadStoreRecords('REF');
		}
	});

	function openOrderInfoWindow() {
		if (!OrderInfoWindow) {
			OrderInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '수주번호검색',
				width	: 830,
				height	: 580,
				layout	: {
					type	: 'vbox',
					align	: 'stretch'
				},
				items	: [orderNoSearch, orderNoDetailGrid],
				tbar	: ['->',{
					itemId: 'searchBtn',
					text: '조회',
					handler: function() {
						if(!orderNoSearch.getInvalidMessage()) return false;
						orderNoDetailStore.loadStoreRecords();
					},
					disabled: false
				}, {
					itemId: 'closeBtn',
					text: '닫기',
					handler: function() {
						OrderInfoWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
						orderNoSearch.clearForm();
						orderNoDetailGrid.reset();
						orderNoDetailStore.clearData();
					},
					beforeclose: function(panel, eOpts) {
					},
					show: function(panel, eOpts) {
						orderNoSearch.setValue('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
						orderNoSearch.setValue('FR_ORDER_DATE'	, UniDate.get('twelveMonthsAgo'));
						orderNoSearch.setValue('TO_ORDER_DATE'	, UniDate.get('today'));
						orderNoSearch.setValue('AS_PRSN'		, masterForm.getValue('AS_PRSN'));
						//20200119 추가: a/s 요청자가 있으면 자동 조회
						if(!Ext.isEmpty(masterForm.getValue('AS_PRSN'))) {
							if(!orderNoSearch.getInvalidMessage()) return false;
							orderNoDetailStore.loadStoreRecords();
						}
					}
				}
			})
		}
		OrderInfoWindow.center();
		OrderInfoWindow.show();
	}





	/** 검색팝업
	 */
	var searchPopupPanel = Unilite.createSearchForm('searchPopupPanel', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
//					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = orderNoSearch.getField('ORDER_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '접수일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ACCEPT_DATE_FR',
			endFieldName	: 'ACCEPT_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},{
			fieldLabel	: '접수담당',
			name		: 'ACCEPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM05',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '접수번호',
			name		: 'AS_NUM',
			xtype		: 'uniTextfield'
		}]
	}); // createSearchForm
	//검색 모델
	Unilite.defineModel('searchPopupModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'	,type:'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>', type: 'string'},
			{name: 'AS_NUM'			, text: '접수번호'		, type: 'string'},
			{name: 'ACCEPT_DATE'	, text: '접수일'		, type: 'uniDate'},
			{name: 'ACCEPT_PRSN'	, text: '접수담당'		, type: 'string', comboType: 'AU', comboCode: 'ZM05'},
			{name: 'ACCEPT_GUBUN'	, text: '접수구분'		, type: 'string', comboType: 'AU', comboCode: 'ZM06'},
			{name: 'AS_CUSTOMER_CD'	, text: '거래처'		, type: 'string'},
			{name: 'AS_CUSTOMER_NM'	, text: '거래처'		, type: 'string'},
			{name: 'AS_PRSN'		, text: 'A/S요청자'	, type: 'string'},
			{name: 'AS_STATUS'		, text: '완료여부'		, type: 'string', comboType: 'AU', comboCode: 'ZM07'},
			{name: 'PHONE'			, text: '연락처'		, type: 'string'},
			{name: 'HPHONE'			, text: '휴대폰'		, type: 'string'},
			{name: 'INVOICE_NUM'	, text: '운송장번호'		, type: 'string'},
			{name: 'ZIP_CODE'		, text: '우편번호'		, type: 'string'},
			{name: 'ADDR1'			, text: '주소'		, type: 'string'},
			{name: 'ADDR2'			, text: '상세주소'		, type: 'string'},
			{name: 'REMARK'			, text: '비고'		, type: 'string'}
		]
	});
	//검색 스토어
	var searchPopupStore = Unilite.createStore('searchPopupStore', {
		model	: 'searchPopupModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 's_esa100ukrv_wmService.searchPopupList'
			}
		},
		loadStoreRecords : function()  {
			var param = searchPopupPanel.getValues();
//			var authoInfo = pgmInfo.authoUser;		// 권한정보(N-전체,A-자기사업장>5-자기부서)
//			if(authoInfo == "5" && Ext.isEmpty(searchPopupPanel.getValue('DEPT_CODE'))){
//				param.DEPT_CODE = deptCode;
//			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드
	var searchPopupGrid = Unilite.createGrid('scn100ukrvsearchPopupGrid', {
		store	: searchPopupStore,
		layout	: 'fit',
		uniOpt	:{
			expandLastColumn: true,
			useRowNumberer	: true
		},
		selModel:'rowmodel',
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 80		, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width: 80		, hidden: true},
			{ dataIndex: 'AS_NUM'			, width: 120},
			{ dataIndex: 'ACCEPT_DATE'		, width: 100},
			{ dataIndex: 'ACCEPT_PRSN'		, width: 100	, align: 'center'},
			{ dataIndex: 'ACCEPT_GUBUN'		, width: 110	, align: 'center'},
			{ dataIndex: 'AS_CUSTOMER_CD'	, width: 100},
			{ dataIndex: 'AS_CUSTOMER_NM'	, width: 150},
			{ dataIndex: 'AS_PRSN'			, width: 100	, align: 'center'},
			{ dataIndex: 'AS_STATUS'		, width: 100	, align: 'center'},
			{ dataIndex: 'PHONE'			, width: 120},
			{ dataIndex: 'HPHONE'			, width: 120},
			{ dataIndex: 'INVOICE_NUM'		, width: 120},
			{ dataIndex: 'ZIP_CODE'			, width: 100},
			{ dataIndex: 'ADDR1'			, width: 130},
			{ dataIndex: 'ADDR2'			, width: 100},
			{ dataIndex: 'REMARK'			, width: 150}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				searchPopupGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			isLoad = true;					//20201204 추가
			masterForm.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),
				'AS_NUM'			: record.get('AS_NUM'),
				'ACCEPT_DATE'		: record.get('ACCEPT_DATE'),
				'ACCEPT_PRSN'		: record.get('ACCEPT_PRSN'),
				'ACCEPT_GUBUN'		: record.get('ACCEPT_GUBUN'),
				'AS_CUSTOMER_CD'	: record.get('AS_CUSTOMER_CD'),
				'AS_CUSTOMER_NM'	: record.get('AS_CUSTOMER_NM'),
				'AS_PRSN'			: record.get('AS_PRSN'),
				'AS_STATUS'			: record.get('AS_STATUS'),
				'PHONE'				: record.get('PHONE'),
				'HPHONE'			: record.get('HPHONE'),
				'INVOICE_NUM'		: record.get('INVOICE_NUM'),
				'ZIP_CODE'			: record.get('ZIP_CODE'),
				'ADDR1'				: record.get('ADDR1'),
				'ADDR2'				: record.get('ADDR2'),
				'REMARK'			: record.get('REMARK'),
				'AS_GUBUN'			: record.get('AS_GUBUN'),		//20201203 추가
				'AS_GUBUN_DETAIL'	: record.get('AS_GUBUN_DETAIL')	//20201203 추가
			});
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons(['save'], false);
		}
	});
	//openSearchInfoWindow(검색 메인)
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: 'A/S 접수번호 검색',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [searchPopupPanel, searchPopupGrid],
				tbar	:  ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						searchPopupStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					beforeclose: function( panel, eOpts )  {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					show: function( panel, eOpts ) {
						searchPopupPanel.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));
						searchPopupPanel.setValue('ACCEPT_DATE_FR', UniDate.get('startOfMonth'));
						searchPopupPanel.setValue('ACCEPT_DATE_TO', UniDate.get('today'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}





	Unilite.Main({
		id			: 's_esa100ukrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			id		: 'pageAll',
			items	: [
				masterForm, outLineGrid, detailGrid, detailGrid2
			]
		}],
		fnInitBinding: function() {
			masterForm.setValue("DIV_CODE"		, UserInfo.divCode);
			masterForm.setValue("ACCEPT_DATE"	, UniDate.get('today'));
			masterForm.setValue("AS_STATUS"		, '2');								//20210119 추가: 완료여부 기본값 설정
			masterForm.setValue("ACCEPT_PRSN"	, BsaCodeInfo.defaultReceiptPrsn);	//20210119 추가: 접수담당 기본값 설정로직 추가해야함

			UniAppManager.setToolbarButtons(['reset']	, true);
			UniAppManager.setToolbarButtons(['save']	, false);
			masterForm.down('#serchBtn').enable();		//20201204 추가: 하나의 상세만 추가할 수 있도록 변경
		},
		onResetButtonDown: function() {
			masterForm.getField('DIV_CODE').setReadOnly(false);
			masterForm.getField('AS_PRSN').setReadOnly(false);
			masterForm.clearForm();
			outLineStore.loadData({});
			detailStore.loadData({});
			detailStore2.loadData({});
			this.fnInitBinding();
		},
		onQueryButtonDown: function() {
			if(Ext.isEmpty(masterForm.getValue('AS_NUM'))) {
				openSearchInfoWindow();
			} else {
				masterForm.getField('DIV_CODE').setReadOnly(true);
				masterForm.getField('AS_PRSN').setReadOnly(true);
				masterForm.setValue('SANGDAM_REMARK', '');
				masterForm.setValue('MANAGE_REMARK'	, '');

				masterForm.uniOpt.inLoading = true;
				masterForm.load({
					params:masterForm.getValues(),
					success: function()	{
						outLineStore.loadStoreRecords();
						detailStore.loadStoreRecords();
						detailStore2.loadStoreRecords();
						masterForm.down('#serchBtn').disable();		//20201204 추가: 하나의 상세만 추가할 수 있도록 변경
						masterForm.uniOpt.inLoading = false;
					},
					failure: function(form, action) {
						masterForm.uniOpt.inLoading = false;
					}
				});
			}
		},
		onNewDataButtonDown: function() {
			masterForm.getField('DIV_CODE').setReadOnly(true);
			masterForm.getField('AS_PRSN').setReadOnly(true);

			var asNum	= masterForm.getValue('AS_NUM');
			var divCode	= masterForm.getValue('DIV_CODE');
			var seq		= detailGrid.getStore().max('AS_SEQ');
			if(!seq){
				seq = 1;
			} else {
				seq += 1;
			}
			var r = {
				COMP_CODE	: UserInfo.compCode,
				DIV_CODE	: divCode,
				AS_NUM		: asNum,
				AS_SEQ		: seq
			}
			detailGrid.createRow(r);
			masterForm.down('#serchBtn').disable();		//20201204 추가: 하나의 상세만 추가할 수 있도록 변경
		},
		onNewDataButtonDown2: function(maxAS_SEQ) {
			detailStore2.filterBy(function(record){
				return record.get('AS_SEQ') == maxAS_SEQ;
			})
			var asNum	= masterForm.getValue('AS_NUM');
			var divCode	= masterForm.getValue('DIV_CODE');
			var seq		= detailGrid2.getStore().max('SUB_SEQ');
			if(!seq){
				seq = 1;
			} else {
				seq += 1;
			}
			var r = {
				COMP_CODE	: UserInfo.compCode,
				DIV_CODE	: divCode,
				AS_NUM		: asNum,
				SUB_SEQ		: seq
			}
			detailGrid2.createRow(r);
			detailStore2.clearFilter();
			masterForm.down('#serchBtn').disable();		//20201204 추가: 하나의 상세만 추가할 수 있도록 변경
		},
		onSaveDataButtonDown: function() {
			if(!masterForm.getInvalidMessage()) return;   //필수체크

			if(masterForm.isDirty()) {
				Ext.getCmp('pageAll').getEl().mask('저장 중...','loading-indicator');
				var param = masterForm.getValues();
				param.FLAG = "S";
				masterForm.getForm().submit({
					params: param,
					success: function(form, action) {
						masterForm.setValue('AS_NUM', action.result.resultData.as_NUM);
						if (detailStore.isDirty()) {
							detailStore.saveStore();
						} else if (detailStore2.isDirty()) {
							detailStore2.saveStore();
						} else {
							masterForm.getForm().wasDirty = false;
							masterForm.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);
							UniAppManager.updateStatus(Msg.sMB011); // "저장되었습니다.
							if(masterForm.getValue('DELETE_ALL') == 'Y') {
								UniAppManager.app.onResetButtonDown();
							} else {
								UniAppManager.app.onQueryButtonDown();
							}
							Ext.getCmp('pageAll').getEl().unmask();
						}
					},
					failure: function(form, action)	{
						Ext.getCmp('pageAll').getEl().unmask();
					}
				});
			} else if (detailStore.isDirty()) {
				detailStore.saveStore();
			} else if (detailStore2.isDirty()) {
				detailStore2.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {/*
			var selRow = detailGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)){
				if(selRow.phantom === true) {
					detailGrid.deleteSelectedRow();
					detailGrid2.deleteSelectedRow();
					UniAppManager.setToolbarButtons(['delete'], false);
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
					detailGrid.deleteSelectedRow();
					detailGrid2.deleteSelectedRow();
					UniAppManager.setToolbarButtons('save', true);
				}
			} else {
				if(!masterForm.getInvalidMessage()) return;   //필수체크
				var finishyn;
				var param = {
					AS_NUM		: panelSearch.getValue('AS_NUM_SEACH'),
					DIV_CODE	: panelSearch.getValue('DIV_CODE')
				}
				s_esa100ukrv_wmService.checkFinishData (param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						finishyn = provider.data.AS_STATUS;
						if(finishyn != '9'){
							if(confirm('현재 접수건을 삭제 합니다.\n 삭제 하시겠습니까?')){
								Ext.getCmp('pageAll').getEl().mask('저장 중...','loading-indicator');
								var param = masterForm.getValues();
								param.DIV_CODE = panelSearch.getValue('DIV_CODE');
								param.FLAG = "D";
								masterForm.getForm().submit({
									params: param,
									success: function(form, action) {
										masterForm.setValue('AS_NUM',action.result.resultData.as_NUM);
										masterForm.getForm().wasDirty = false;
										masterForm.resetDirtyStatus();
										UniAppManager.setToolbarButtons('save', false);
										UniAppManager.updateStatus(Msg.sMB011); // "저장되었습니다.
										UniAppManager.app.onResetButtonDown();
										Ext.getCmp('pageAll').getEl().unmask();
										UniAppManager.setToolbarButtons('newData', true);
									},
									failure: function(form, action) {
										Ext.getCmp('pageAll').getEl().unmask();	 
									}
								});
							}
						} else {
							Unilite.messagBox('진행상태가 완료인 접수건은 삭제 할 수 없습니다.');
						}
					}
				});
			}
		*/},
		onDeleteAllButtonDown: function() {
			//완료여부 체크하여 완료일 경우에는 확인 후 전체삭제 진행
			var asStatus = masterForm.getValue('AS_STATUS');
			if(asStatus == '9') {
				if(confirm('완료된 접수 데이터 입니다.'+'\n'+ '삭제하시겠습니까?')) {
					masterForm.setValue('DELETE_ALL', 'Y');
					UniAppManager.app.onSaveDataButtonDown();
				}
			} else {
				masterForm.setValue('DELETE_ALL', 'Y');
				UniAppManager.app.onSaveDataButtonDown();
			}
		}
	});





	//20210118 추가: AS수량 변경 시, 운송장수량 같이 변경
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "AS_ACCEPT_Q":
					if(newValue != oldValue) {
						if(newValue <= 0){
							rv = '<t:message code="system.message.purchase.message068" default="0보다 큰 값이 입력되어야 합니다."/>';
							record.set('AS_ACCEPT_Q', oldValue)
							break;
						}
						if(newValue > record.get('ORDER_Q')) {
							rv = 'AS수량은 수주량보다 클 수 없습니다.';
							record.set('AS_ACCEPT_Q', oldValue)
							break;
						}
						record.set('INVOICE_Q', newValue);
					}
				break;

				case "INVOICE_Q":
					//20210119 추가: 운송장 수량변경은 저장과 관련 없음 -> 운송장 출력, 반송요청 전 저장할 데이터는 저장해야 하므로 처리로직 필요
					gsSaveFlag = UniAppManager.app._needSave();
				break;
			}
			return rv;
		}
	});
};
</script>