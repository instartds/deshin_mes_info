<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bco100ukrv_kd" >
	<t:ExtComboStore comboType="BOR120" pgmId="s_bco100ukrv_kd"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />				<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B010" />				<!-- 사용-->
	<t:ExtComboStore comboType="AU" comboCode="B024" />				<!-- 담당자-->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 재고단위  -->
	<t:ExtComboStore comboType="AU" comboCode="B015" />				<!-- 거래처구분	-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />				<!-- 기준화폐-->
	<t:ExtComboStore comboType="AU" comboCode="B038" />				<!-- 결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="B034" />				<!-- 결제조건-->
	<t:ExtComboStore comboType="AU" comboCode="B055" />				<!-- 거래처분류-->
	<t:ExtComboStore comboType="AU" comboCode="A003" />				<!-- 구분  -->
	<t:ExtComboStore comboType="AU" comboCode="WB26" />				<!-- 단가구분  -->
	<t:ExtComboStore comboType="AU" comboCode="T005" />				<!-- 가격조건  -->
	<t:ExtComboStore comboType="AU" comboCode="WB01" />				<!-- 운송방법  -->
	<t:ExtComboStore comboType="AU" comboCode="WB03" />				<!-- 변동사유  -->
	<t:ExtComboStore comboType="AU" comboCode="WB04" />				<!-- 차종  -->
	<t:ExtComboStore comboType="AU" comboCode="WB18" />				<!-- 내수구분  -->
	<t:ExtComboStore comboType="AU" comboCode="WB22" />				<!-- 의뢰서구분  -->
	<t:ExtComboStore items="${WB22_LIST}" storeId="WB22List" /> 	<!--의뢰서구분리스트-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴.
	gsAutoType	: '${gsAutoType}',
	gsMoneyUnit	: '${gsMoneyUnit}'
};

var outDivCode = UserInfo.divCode;
var SearchReqNumWindow;	// 검색창
var CopyReqNumWindow;	// 기존의뢰번호 검색창
var SearchInfoWindow;	// 추가정보창
var gstypeChk;
var gsHscode;
function appMain() {
	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url


	/** Model 정의
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bco100ukrv_kdService.selectList',
			update	: 's_bco100ukrv_kdService.updateDetail',
			create	: 's_bco100ukrv_kdService.insertDetail',
			destroy	: 's_bco100ukrv_kdService.deleteDetail',
			syncAll	: 's_bco100ukrv_kdService.saveAll'
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '99.5%'}},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				holdable: 'hold',
				tdAttrs: {width: 346},
				allowBlank:false
			},{
				fieldLabel: '의뢰번호',
				name:'P_REQ_NUM',
				xtype: 'uniTextfield',
				readOnly: isAutoOrderNum,
				holdable: isAutoOrderNum ? 'readOnly':'hold',
				tdAttrs: {width: 346}
//				allowBlank:false
			},
			Unilite.popup('DEPT', {
				fieldLabel: '부서',
				valueFieldName: 'TREE_CODE',
				textFieldName: 'TREE_NAME',
				holdable: 'hold',
				autoPopup:true,
				allowBlank:false,
				listeners: {
					applyextparam: function(popup){
						var authoInfo = pgmInfo.authoUser;			//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;   //부서정보
						var divCode = '';				//사업장
						if(authoInfo == "A"){   //자기사업장
							popup.setExtParam({'TREE_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
							popup.setExtParam({'TREE_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}else if(authoInfo == "5"){	//부서권한
							popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
			{
				xtype: 'component'
			},{
				fieldLabel: '구분',
				name:'TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A003',
				holdable: 'hold',
				allowBlank:false,
				listeners:{
					change:function(field, newValue, oldValue) {
						panelResult.setValue('P_REQ_TYPE', '');


					}
				}
			},{
				fieldLabel: '의뢰일',
				name: 'P_REQ_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false
			},
			Unilite.popup('Employee',{
					fieldLabel: '담당자',
					holdable: 'hold',
					valueFieldName:'PERSON_NUMB',
					textFieldName:'PERSON_NAME',
					validateBlank:false,
					autoPopup:true,
					allowBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var param= Ext.getCmp('resultForm').getValues();
								s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response)  {
									if(!Ext.isEmpty(provider)){
										panelResult.setValue('TREE_CODE', provider[0].DEPT_CODE);
										panelResult.setValue('TREE_NAME', provider[0].DEPT_NAME);
									}
								});
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('PERSON_NUMB', '');
							panelResult.setValue('PERSON_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DEPT_SEARCH': panelResult.getValue('TREE_NAME')});
						}
					}
			}),{
				xtype: 'component'
			},{
				fieldLabel: '의뢰서구분',
				name:'P_REQ_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'WB22',
				holdable: 'hold',
				allowBlank:false,
				listeners:{
						beforequery: function( queryPlan, eOpts ) {
							var store = queryPlan.combo.getStore();
							var sType = panelResult.getValue('TYPE');
							var rtn = typeChk(sType);
							var rtnValue = rtn[0];
							var default1 = rtn[1];
							var default2 = rtn[2];

							store.clearFilter();
							store.getFilters().add({
								property: 'value',
								value: rtnValue,
								operator: 'in'
							});
						}
				}
			},{
				fieldLabel: '적용일',
				name: 'APLY_START_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('startOfMonth'),
				holdable: 'hold',
				allowBlank: false
			},{
				fieldLabel: '화폐',
				name:'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B004',
				holdable: 'hold',
				displayField: 'value',
				allowBlank:false
			},{
				width: 100,
				xtype: 'button',
				text: '기존의뢰서복사',
				tdAttrs: {align: 'right'},
				handler: function() {
					//20191218 필수 체크로직 추가
					if (!panelResult.getInvalidMessage()) {
						return false;
					}
					openCopyPreqNumWindow();
				}
			},{
				fieldLabel: '기안여부TEMP',
				name:'GW_TEMP',
				xtype: 'uniTextfield',
				hidden: true
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var reqNumSearch = Unilite.createSearchForm('reqNumSearchForm', {	// 검색팝업창 / 기존의뢰서
		layout: {type: 'uniTable', columns : 3},
		items: [{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank:false
			},{
				fieldLabel: '의뢰번호',
				xtype:'uniTextfield',
				name: 'P_REQ_NUM',
				listeners:{
					change:function(field, newValue, oldValue) {
					}
				}
			},{
				fieldLabel: '구분',
				name:'TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A003',
				listeners:{
					change:function(field, newValue, oldValue) {
						if(gstypeChk == 'Y'){
							reqNumSearch.setValue('P_REQ_TYPE', '');
						}
					}
				}
			},
			Unilite.popup('DEPT', {
				fieldLabel: '부서',
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				autoPopup:true,
				allowBlank:false
			}),
			Unilite.popup('Employee',{
				fieldLabel: '담당자',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'PERSON_NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var param= Ext.getCmp('reqNumSearchForm').getValues();
							s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response)  {
								if(!Ext.isEmpty(provider)){
									reqNumSearch.setValue('DEPT_CODE', provider[0].DEPT_CODE);
									reqNumSearch.setValue('DEPT_NAME', provider[0].DEPT_NAME);
								}
							});
						},
						scope: this
					},
					onClear: function(type) {
						reqNumSearch.setValue('PERSON_NUMB', '');
						reqNumSearch.setValue('PERSON_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DEPT_SEARCH': reqNumSearch.getValue('DEPT_NAME')});
					}
				}
			}),{
				fieldLabel: '적용일',
				name: 'APLY_START_DATE',
				xtype: 'uniDatefield',
				hidden: true
			},{
				fieldLabel: '의뢰서구분',
				name:'P_REQ_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'WB22',
				listeners:{
					change:function(field, newValue, oldValue) {
						var sType = reqNumSearch.getValue('TYPE');
						var rtnData = typeChk(newValue);
						var refcode = rtnData[0];
						var defaultValue1 = rtnData[1];
						var defaultValue2 = rtnData[2];
						if(!Ext.isEmpty(newValue)){
							if(sType == '1'){//매입인 경우
								if(refcode == '2'){
									alert("매입단가에 맞는 의뢰서 구분을 선택해주세요.");
									if(Ext.isEmpty(oldValue)){
										field.setValue(defaultValue1);
									}else{
										field.setValue(oldValue);
									}
								}
							}else{
								if(refcode == '1'){
									alert("매출단가에 맞는 의뢰서 구분을 선택해주세요.");
									if(Ext.isEmpty(oldValue)){
										field.setValue(defaultValue2);
									}else{
										field.setValue(oldValue);
									}
								}
							}
						}
					}
				}
			}
		],
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	}); // createSearchForm

	function typeChk(newValue) {		//매입,의뢰서구분 관련 체크 로직
		var records = Ext.data.StoreManager.lookup('WB22List').data.items;
		var refcode = '';
		var defaultValue1 = '';
		var defaultValue2 = '';
		var rtnVal =  new Array();
		Ext.each(records, function(item, i){
			if(item.get("value") == newValue){
				refcode = item.get("refCode1");
			}
			if(item.get("refCode2") == '1' ){
				defaultValue1 = item.get("value");
			}
			if(item.get("refCode2") == '2' ){
				defaultValue2 = item.get("value");
			}
		})
		rtnVal[0] = refcode;
		rtnVal[1] = defaultValue1;
		rtnVal[2] = defaultValue2;
		return rtnVal ;
	}

	var reqNumSearch2 = Unilite.createSearchForm('reqNumSearchForm2', {	// 검색팝업창 / 기존의뢰서
		layout: {type: 'uniTable', columns : 3},
		items: [{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				holdable: 'hold',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank:false
			},{
				fieldLabel: '의뢰번호',
				xtype:'uniTextfield',
				name: 'P_REQ_NUM'
			},{	//20191218 필드 / 기본값 setting 로직 추가
				fieldLabel		: '의뢰일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'P_REQ_DATE_FR',
				endFieldName	: 'P_REQ_DATE_TO'
			},{
				fieldLabel: '구분',
				name:'TYPE',
				xtype: 'uniCombobox',
				readOnly: true,
				comboType:'AU',
				comboCode:'A003'
			},
			Unilite.popup('DEPT', {
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					autoPopup:true//,
					//20191218 주석: 다른 담당자 정보도 참조할 수 있게 하기 위해서
//					allowBlank:false
			}),
			Unilite.popup('Employee',{
				fieldLabel: '담당자',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'PERSON_NAME',
				//20191224 주석: 코드 초기화 시, 명도 초기화 하기 위해
//				validateBlank:false,
				autoPopup:true,
				//20191218 주석: 다른 담당자 정보도 참조할 수 있게 하기 위해서
//				allowBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var param= Ext.getCmp('reqNumSearchForm2').getValues();
							s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response)  {
								if(!Ext.isEmpty(provider)){
									reqNumSearch2.setValue('DEPT_CODE', provider[0].DEPT_CODE);
									reqNumSearch2.setValue('DEPT_NAME', provider[0].DEPT_NAME);
								}
							});
						},
						scope: this
					},
					onClear: function(type) {
						reqNumSearch2.setValue('PERSON_NUMB', '');
						reqNumSearch2.setValue('PERSON_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DEPT_SEARCH': reqNumSearch2.getValue('DEPT_NAME')});
					}
				}
			}),{
				fieldLabel: '적용일',
				name: 'APLY_START_DATE',
				xtype: 'uniDatefield',
				holdable: 'hold',
				hidden: true
			},{
				fieldLabel: '의뢰서구분',
				name:'P_REQ_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'WB22',
				holdable: 'hold',
				readOnly: true,
				allowBlank:false
			},{	//20191216 필드 추가
				fieldLabel	: '단가차액',
				xtype		: 'uniNumberfield',
				name		: 'DIFFERENCE_AMT'
			},{	//20191216 필드 추가
				fieldLabel	: '종전단가사용',
				itemId		: 'rdoSelect',
				xtype		: 'uniRadiogroup',
				items		: [{
					boxLabel: '예',
					name: 'USE_YN',
					inputValue: 'Y',
					width: 90
				}, {
					boxLabel: '아니오',
					name: 'USE_YN',
					inputValue: 'N',
					width: 130
				}] ,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}
		],
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
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
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
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});


	Unilite.defineModel('s_bco100ukrv_kdModel', {		// 메인1
		fields: [
			{name: 'P_REQ_NUM'			, text: '의뢰번호'		, type: 'string', allowBlank: isAutoOrderNum},
			{name: 'SER_NO'				, text: '의뢰순번'		, type: 'int'},
			{name: 'COMP_CODE'			, text: '법인코드'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'		, type: 'string'},
			{name: 'TREE_CODE'			, text: '부서코드'		, type: 'string'},
			{name: 'TREE_NAME'			, text: '부서명'		, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사원코드'		, type: 'string'},
			{name: 'PERSON_NAME'		, text: '사원명'		, type: 'string'},
			{name: 'TYPE'				, text: '구분'		, type: 'string', comboType:'AU', comboCode:'A003'},
			{name: 'MONEY_UNIT'			, text: '화폐단위'		, type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
			{name: 'P_REQ_DATE'			, text: '의뢰일'		, type: 'uniDate'},
			{name: 'APLY_START_DATE'	, text: '적용일'		, type: 'uniDate'},
			{name: 'GW_FLAG'			, text: '기안'		, type: 'string', comboType:'AU', comboCode:'WB17'},
			{name: 'MAKER_CODE'			, text: '제조처코드'		, type: 'string'},
			{name: 'MAKER_NAME'			, text: '제조처명'		, type: 'string'},
			{name: 'NEW_ITEM_FREFIX'	, text: '신규품목코드'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'		, type: 'string', allowBlank: false},
			{name: 'ORDER_UNIT'			, text: '단위'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value'},
			{name: 'PRICE_TYPE'			, text: '단가구분'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'WB26'},
			{name: 'ITEM_P'				, text: '단가'		, type: 'uniUnitPrice', allowBlank: false},
			{name: 'NS_FLAG'			, text: '내수구분'		, type: 'string', comboType:'AU', comboCode:'WB18'},
			{name: 'CUSTOM_CODE'		, text: '거래처코드'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'		, type: 'string', allowBlank: false},
			{name: 'PACK_ITEM_P'		, text: '포장단가'		, type: 'uniUnitPrice'},
			{name: 'PRE_ITEM_P'			, text: '종전단가'		, type: 'uniUnitPrice'},
			{name: 'HS_CODE'			, text: 'HS번호'		, type: 'string'},
			{name: 'HS_NAME'			, text: 'HS명'		, type: 'string'},
			{name: 'PAY_TERMS'			, text: '결제조건'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'B034'},
			{name: 'TERMS_PRICE'		, text: '가격조건'		, type: 'string', comboType:'AU', comboCode:'T005', displayField: 'value'},
			{name: 'DELIVERY_METH'		, text: '운송방법'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'WB01'},
			{name: 'CH_REASON'			, text: '단가변동사유'	, type: 'string', comboType:'AU', comboCode:'WB03'},
			{name: 'OEM_YN'				, text: 'OEM'		, type: 'boolean'/*, allowBlank: false, comboType:'AU', comboCode:'B010'*/},
			{name: '13199_YN'			, text: '수출'		, type: 'boolean'/*, allowBlank: false, comboType:'AU', comboCode:'B010'*/},
			{name: '12199_YN'			, text: '시중'		, type: 'boolean'/*, allowBlank: false, comboType:'AU', comboCode:'B010'*/},
			{name: '14199_YN'			, text: '대리점'		, type: 'boolean'/*, allowBlank: false, comboType:'AU', comboCode:'B010'*/},
			{name: '13301_YN'			, text: '청도'		, type: 'boolean'/*, allowBlank: false, comboType:'AU', comboCode:'B010'*/},
			{name: 'SPEC'				, text: '규격/품번'		, type: 'string'},
			{name: 'CAR_TYPE'			, text: '차종'		, type: 'string', comboType:'AU', comboCode:'WB04', valueWidth:40, textWidth:40},
			{name: 'STOCK_UNIT'			, text: '재고단위'		, type: 'string', displayField: 'value'},
			{name: 'CUSTOM_FULL_NAME'	, text: '거래처명'		, type: 'string'},
			{name: 'ADD01_CUSTOM_CODE'	, text: '거래처1'		, type: 'string'},
			{name: 'ADD02_CUSTOM_CODE'	, text: '거래처2'		, type: 'string'},
			{name: 'ADD03_CUSTOM_CODE'	, text: '거래처3'		, type: 'string'},
			{name: 'ADD04_CUSTOM_CODE'	, text: '거래처4'		, type: 'string'},
			{name: 'ADD05_CUSTOM_CODE'	, text: '거래처5'		, type: 'string'},
			{name: 'ADD06_CUSTOM_CODE'	, text: '거래처6'		, type: 'string'},
			{name: 'ADD07_CUSTOM_CODE'	, text: '거래처7'		, type: 'string'},
			{name: 'ADD08_CUSTOM_CODE'	, text: '거래처8'		, type: 'string'},
			{name: 'ADD09_CUSTOM_CODE'	, text: '거래처9'		, type: 'string'},
			{name: 'ADD10_CUSTOM_CODE'	, text: '거래처10'		, type: 'string'},
			{name: 'ADD11_CUSTOM_CODE'	, text: '거래처11'		, type: 'string'},
			{name: 'ADD12_CUSTOM_CODE'	, text: '거래처12'		, type: 'string'},
			{name: 'ADD13_CUSTOM_CODE'	, text: '거래처13'		, type: 'string'},
			{name: 'ADD14_CUSTOM_CODE'	, text: '거래처14'		, type: 'string'},
			{name: 'ADD15_CUSTOM_CODE'	, text: '거래처15'		, type: 'string'},
			{name: 'ADD16_CUSTOM_CODE'	, text: '거래처16'		, type: 'string'},
			{name: 'ADD17_CUSTOM_CODE'	, text: '거래처17'		, type: 'string'},
			{name: 'ADD18_CUSTOM_CODE'	, text: '거래처18'		, type: 'string'},
			{name: 'ADD19_CUSTOM_CODE'	, text: '거래처19'		, type: 'string'},
			{name: 'ADD20_CUSTOM_CODE'	, text: '거래처20'		, type: 'string'},
			{name: 'ADD21_CUSTOM_CODE'	, text: '거래처21'		, type: 'string'},
			{name: 'ADD22_CUSTOM_CODE'	, text: '거래처22'		, type: 'string'},
			{name: 'ADD01_CUSTOM_NAME'	, text: '거래처1'		, type: 'string'},
			{name: 'ADD02_CUSTOM_NAME'	, text: '거래처2'		, type: 'string'},
			{name: 'ADD03_CUSTOM_NAME'	, text: '거래처3'		, type: 'string'},
			{name: 'ADD04_CUSTOM_NAME'	, text: '거래처4'		, type: 'string'},
			{name: 'ADD05_CUSTOM_NAME'	, text: '거래처5'		, type: 'string'},
			{name: 'ADD06_CUSTOM_NAME'	, text: '거래처6'		, type: 'string'},
			{name: 'ADD07_CUSTOM_NAME'	, text: '거래처7'		, type: 'string'},
			{name: 'ADD08_CUSTOM_NAME'	, text: '거래처8'		, type: 'string'},
			{name: 'ADD09_CUSTOM_NAME'	, text: '거래처9'		, type: 'string'},
			{name: 'ADD10_CUSTOM_NAME'	, text: '거래처10'		, type: 'string'},
			{name: 'ADD11_CUSTOM_NAME'	, text: '거래처11'		, type: 'string'},
			{name: 'ADD12_CUSTOM_NAME'	, text: '거래처12'		, type: 'string'},
			{name: 'ADD13_CUSTOM_NAME'	, text: '거래처13'		, type: 'string'},
			{name: 'ADD14_CUSTOM_NAME'	, text: '거래처14'		, type: 'string'},
			{name: 'ADD15_CUSTOM_NAME'	, text: '거래처15'		, type: 'string'},
			{name: 'ADD16_CUSTOM_NAME'	, text: '거래처16'		, type: 'string'},
			{name: 'ADD17_CUSTOM_NAME'	, text: '거래처17'		, type: 'string'},
			{name: 'ADD18_CUSTOM_NAME'	, text: '거래처18'		, type: 'string'},
			{name: 'ADD19_CUSTOM_NAME'	, text: '거래처19'		, type: 'string'},
			{name: 'ADD20_CUSTOM_NAME'	, text: '거래처20'		, type: 'string'},
			{name: 'ADD21_CUSTOM_NAME'	, text: '거래처21'		, type: 'string'},
			{name: 'ADD22_CUSTOM_NAME'	, text: '거래처22'		, type: 'string'},
			{name: 'REMARK'				, text: '비고'		, type: 'string'},
			{name: 'CONFIRM_YN'			, text: '확정'		, type: 'string', comboType:'AU', comboCode:'B010'},
			{name: 'RENEWAL_YN'			, text: '갱신'		, type: 'string', comboType:'AU', comboCode:'B010'},
			{name: 'INSERT_DB_USER'		, text: '입력ID'		, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '입력일'		, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'		, text: '수정ID'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'		, type: 'uniDate'},
			{name: 'TEMPC_01'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPC_02'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPC_03'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPN_01'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPN_02'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPN_03'			, text: '여유컬럼'		, type: 'string'},
			{name: 'OEM_APLY_YN'		, text: 'OEM적용여부'	, type: 'string', comboType:'AU', comboCode:'B010'},
			{name: 'ITEM_NAME2'			, text: '품목명'		, type: 'string'},
			{name: 'SPEC2'				, text: '규격'		, type: 'string'},
			{name: 'CAR_TYPE2'			, text: '차종'		, type: 'string', comboType:'AU', comboCode:'WB04', valueWidth:40, textWidth:40},
			{name: 'NEW_CAR_TYPE'		, text: '신규차종'		, type: 'string'},
			{name: 'STOCK_UNIT2'		, text: '재고단위'		, type: 'string', comboType:'AU', comboCode:'B013', displayField: 'value'},
			{name: 'CUSTOM_NAME2'		, text: '거래처약명'		, type: 'string'},
			{name: 'CUSTOM_FULL_NAME2'	, text: '거래처전명'		, type: 'string'},
			{name: 'P_REQ_TYPE'			, text: '의뢰서구분'		, type: 'string', comboType:'AU', comboCode:'WB22'},
			{name: 'FLAG'				, text: 'FLAG'		, type: 'string'},
			{name: 'OLD_CUSTOM_CODE'	, text: 'OLD_거래처'	, type: 'string'},
			{name: 'OLD_CUSTOM_NAME'	, text: 'OLD_거래처명'	, type: 'string'},
			//20191216 추가
			{name: 'DIFFER_UNIT_P'		, text: '단가차액'		, type: 'uniUnitPrice'},
			//20191219 mainGrid에 적용된 데이터는 기존단가의뢰번호검색 팝업에서 삭제하기 위해 컬럼 추가
			{name: 'REF_P_REQ_NUM'		, text: 'REF_NUM'	, type: 'string'},
			{name: 'REF_SER_NO'			, text: 'REF_SER_NO', type: 'int'}
		]
	});//End of Unilite.defineModel('s_bco100ukrv_kdModel', {

	Unilite.defineModel('s_bco100ukrv_kdModel2', {		// 검색 팝업창
		fields: [
			{name: 'P_REQ_NUM'			, text: '의뢰번호'		, type: 'string', allowBlank: isAutoOrderNum},
			{name: 'SER_NO'				, text: '의뢰순번'		, type: 'int'},
			{name: 'COMP_CODE'			, text: '법인코드'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'		, type: 'string'},
			{name: 'TREE_CODE'			, text: '부서코드'		, type: 'string'},
			{name: 'TREE_NAME'			, text: '부서명'		, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사원코드'		, type: 'string'},
			{name: 'PERSON_NAME'		, text: '사원명'		, type: 'string'},
			{name: 'TYPE'				, text: '구분'		, type: 'string', comboType:'AU', comboCode:'A003'},
			{name: 'MONEY_UNIT'			, text: '화폐단위'		, type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
			{name: 'P_REQ_DATE'			, text: '의뢰일'		, type: 'uniDate'},
			{name: 'APLY_START_DATE'	, text: '적용일'		, type: 'uniDate'},
			{name: 'GW_FLAG'			, text: '기안'		, type: 'string', comboType:'AU', comboCode:'WB17'},
			{name: 'MAKER_CODE'			, text: '제조처코드'		, type: 'string'},
			{name: 'MAKER_NAME'			, text: '제조처명'		, type: 'string'},
			{name: 'NEW_ITEM_FREFIX'	, text: '신규품목코드'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'		, type: 'string'},
			{name: 'PRICE_TYPE'			, text: '단가구분'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'WB26'},
			{name: 'ORDER_UNIT'			, text: '단위'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value'},
			{name: 'ITEM_P'				, text: '단가'		, type: 'uniUnitPrice', allowBlank: false},
			{name: 'NS_FLAG'			, text: '내수구분'		, type: 'string', comboType:'AU', comboCode:'WB18'},
			{name: 'CUSTOM_CODE'		, text: '거래처코드'		, type: 'string'/*, allowBlank: false*/},
			{name: 'CUSTOM_NAME'		, text: '거래처명'		, type: 'string'},
			{name: 'PACK_ITEM_P'		, text: '포장단가'		, type: 'uniUnitPrice'},
			{name: 'PRE_ITEM_P'			, text: '종전단가'		, type: 'uniUnitPrice'},
			{name: 'HS_CODE'			, text: 'HS번호'		, type: 'string'},
			{name: 'HS_NAME'			, text: 'HS명'		, type: 'string'},
			{name: 'PAY_TERMS'			, text: '결제조건'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'B034'},
			{name: 'TERMS_PRICE'		, text: '가격조건'		, type: 'string', comboType:'AU', comboCode:'T005', displayField: 'value'},
			{name: 'DELIVERY_METH'		, text: '운송방법'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'WB01'},
			{name: 'CH_REASON'			, text: '단가변동사유'	, type: 'string', comboType:'AU', comboCode:'WB03'},
			{name: 'OEM_YN'				, text: 'OEM'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'B010'},
			{name: '12199_YN'			, text: '시중'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'B010'},
			{name: '13199_YN'			, text: '수출'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'B010'},
			{name: '14199_YN'			, text: '대리점'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'B010'},
			{name: '13301_YN'			, text: '청도'		, type: 'string', allowBlank: false, comboType:'AU', comboCode:'B010'},
			{name: 'SPEC'				, text: '규격/품번'		, type: 'string'},
			{name: 'CAR_TYPE'			, text: '차종'		, type: 'string', comboType:'AU', comboCode:'WB04', valueWidth:40, textWidth:40},
			{name: 'STOCK_UNIT'			, text: '재고단위'		, type: 'string', displayField: 'value'},
			{name: 'CUSTOM_FULL_NAME'	, text: '거래처명'		, type: 'string'},
			{name: 'ADD01_CUSTOM_CODE'	, text: '거래처1'		, type: 'string'},
			{name: 'ADD02_CUSTOM_CODE'	, text: '거래처2'		, type: 'string'},
			{name: 'ADD03_CUSTOM_CODE'	, text: '거래처3'		, type: 'string'},
			{name: 'ADD04_CUSTOM_CODE'	, text: '거래처4'		, type: 'string'},
			{name: 'ADD05_CUSTOM_CODE'	, text: '거래처5'		, type: 'string'},
			{name: 'ADD06_CUSTOM_CODE'	, text: '거래처6'		, type: 'string'},
			{name: 'ADD07_CUSTOM_CODE'	, text: '거래처7'		, type: 'string'},
			{name: 'ADD08_CUSTOM_CODE'	, text: '거래처8'		, type: 'string'},
			{name: 'ADD09_CUSTOM_CODE'	, text: '거래처9'		, type: 'string'},
			{name: 'ADD10_CUSTOM_CODE'	, text: '거래처10'		, type: 'string'},
			{name: 'ADD11_CUSTOM_CODE'	, text: '거래처11'		, type: 'string'},
			{name: 'ADD12_CUSTOM_CODE'	, text: '거래처12'		, type: 'string'},
			{name: 'ADD13_CUSTOM_CODE'	, text: '거래처13'		, type: 'string'},
			{name: 'ADD14_CUSTOM_CODE'	, text: '거래처14'		, type: 'string'},
			{name: 'ADD15_CUSTOM_CODE'	, text: '거래처15'		, type: 'string'},
			{name: 'ADD16_CUSTOM_CODE'	, text: '거래처16'		, type: 'string'},
			{name: 'ADD17_CUSTOM_CODE'	, text: '거래처17'		, type: 'string'},
			{name: 'ADD18_CUSTOM_CODE'	, text: '거래처18'		, type: 'string'},
			{name: 'ADD19_CUSTOM_CODE'	, text: '거래처19'		, type: 'string'},
			{name: 'ADD20_CUSTOM_CODE'	, text: '거래처20'		, type: 'string'},
			{name: 'ADD21_CUSTOM_CODE'	, text: '거래처21'		, type: 'string'},
			{name: 'ADD22_CUSTOM_CODE'	, text: '거래처22'		, type: 'string'},
			{name: 'ADD01_CUSTOM_NAME'	, text: '거래처1'		, type: 'string'},
			{name: 'ADD02_CUSTOM_NAME'	, text: '거래처2'		, type: 'string'},
			{name: 'ADD03_CUSTOM_NAME'	, text: '거래처3'		, type: 'string'},
			{name: 'ADD04_CUSTOM_NAME'	, text: '거래처4'		, type: 'string'},
			{name: 'ADD05_CUSTOM_NAME'	, text: '거래처5'		, type: 'string'},
			{name: 'ADD06_CUSTOM_NAME'	, text: '거래처6'		, type: 'string'},
			{name: 'ADD07_CUSTOM_NAME'	, text: '거래처7'		, type: 'string'},
			{name: 'ADD08_CUSTOM_NAME'	, text: '거래처8'		, type: 'string'},
			{name: 'ADD09_CUSTOM_NAME'	, text: '거래처9'		, type: 'string'},
			{name: 'ADD10_CUSTOM_NAME'	, text: '거래처10'		, type: 'string'},
			{name: 'ADD11_CUSTOM_NAME'	, text: '거래처11'		, type: 'string'},
			{name: 'ADD12_CUSTOM_NAME'	, text: '거래처12'		, type: 'string'},
			{name: 'ADD13_CUSTOM_NAME'	, text: '거래처13'		, type: 'string'},
			{name: 'ADD14_CUSTOM_NAME'	, text: '거래처14'		, type: 'string'},
			{name: 'ADD15_CUSTOM_NAME'	, text: '거래처15'		, type: 'string'},
			{name: 'ADD16_CUSTOM_NAME'	, text: '거래처16'		, type: 'string'},
			{name: 'ADD17_CUSTOM_NAME'	, text: '거래처17'		, type: 'string'},
			{name: 'ADD18_CUSTOM_NAME'	, text: '거래처18'		, type: 'string'},
			{name: 'ADD19_CUSTOM_NAME'	, text: '거래처19'		, type: 'string'},
			{name: 'ADD20_CUSTOM_NAME'	, text: '거래처20'		, type: 'string'},
			{name: 'ADD21_CUSTOM_NAME'	, text: '거래처21'		, type: 'string'},
			{name: 'ADD22_CUSTOM_NAME'	, text: '거래처22'		, type: 'string'},
			{name: 'REMARK'				, text: '비고'		, type: 'string'},
			{name: 'CONFIRM_YN'			, text: '확정'		, type: 'string', comboType:'AU', comboCode:'B010'},
			{name: 'RENEWAL_YN'			, text: '갱신'		, type: 'string', comboType:'AU', comboCode:'B010'},
			{name: 'INSERT_DB_USER'		, text: '입력ID'		, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '입력일'		, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'		, text: '수정ID'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'		, type: 'uniDate'},
			{name: 'TEMPC_01'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPC_02'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPC_03'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPN_01'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPN_02'			, text: '여유컬럼'		, type: 'string'},
			{name: 'TEMPN_03'			, text: '여유컬럼'		, type: 'string'},
			{name: 'OEM_APLY_YN'		, text: 'OEM적용여부'	, type: 'string', comboType:'AU', comboCode:'B010'},
			{name: 'ITEM_NAME2'			, text: '품목명'		, type: 'string'},
			{name: 'SPEC2'				, text: '규격'		, type: 'string'},
			{name: 'CAR_TYPE2'			, text: '차종'		, type: 'string', comboType:'AU', comboCode:'WB04', valueWidth:40, textWidth:40},
			{name: 'NEW_CAR_TYPE'		, text: '신규차종'		, type: 'string'},
			{name: 'STOCK_UNIT2'		, text: '재고단위'		, type: 'string', comboType:'AU', comboCode:'B013', displayField: 'value'},
			{name: 'CUSTOM_NAME2'		, text: '거래처약명'		, type: 'string'},
			{name: 'CUSTOM_FULL_NAME2'	, text: '거래처전명'		, type: 'string'},
			{name: 'P_REQ_TYPE'			, text: '의뢰서구분'		, type: 'string', comboType:'AU', comboCode:'WB22'},
			//20191219 참조적용 로직 변경을 위해 참조데이터 조회 시, BPR400T의 최종 ITEM_P 가져오는 로직 추가
			{name: 'BPR400T_ITEM_P'		, text: 'BPR400T_P'	, type: 'uniUnitPrice'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_bco100ukrv_kdMasterStore1', {
		model: 's_bco100ukrv_kdModel',
		autoLoad: false,
		uniOpt : {
			isMaster: true,		// 상위 버튼 연결
			editable: true,		// 수정 모드 사용
			deletable:true,		// 삭제 가능
			useNavi : false		// prev | newxt 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords : function()  {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param,
				callback: function(records, operation, success) {
					console.log(records);
					if(success){
						if(masterGrid.getStore().getCount() == 0) {
							Ext.getCmp('GW').setDisabled(true);
						} else if(masterGrid.getStore().getCount() != 0) {
							UniBase.fnGwBtnControl('GW', directMasterStore1.data.items[0].data.GW_FLAG);
						}
					}
				}
			});
		},
		saveStore : function(pReqNo)   {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();   //syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("P_REQ_NUM", master.P_REQ_NUM);
						panelResult.setValue("P_REQ_NUM", master.P_REQ_NUM);
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if (directMasterStore1.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							directMasterStore1.loadStoreRecords();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_bco100ukrv_kdGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			}
		}
	});	// End of var directMasterStore1 = Unilite.createStore('s_bco100ukrv_kdMasterStore1',{

	var reqNumMasterStore = Unilite.createStore('s_bco100ukrv_kdMasterStore1', {		// 검색 팝업창
		model: 's_bco100ukrv_kdModel2',
		autoLoad: false,
		uniOpt : {
			isMaster: true,		// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable:false,		// 삭제 가능
			useNavi : false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_bco100ukrv_kdService.selectReqNumList'
			}
		},
		loadStoreRecords : function()  {
			var param= Ext.getCmp('reqNumSearchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});	// End of var directMasterStore1 = Unilite.createStore('s_bco100ukrv_kdMasterStore1',{

	var copyReqNumMasterStore = Unilite.createStore('s_bco100ukrv_kdMasterStore1', {	// 기존의뢰번호
		model: 's_bco100ukrv_kdModel2',
		autoLoad: false,
		uniOpt : {
			isMaster: true,		// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable:false,		// 삭제 가능
			useNavi : false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_bco100ukrv_kdService.copyReqNumList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful) {
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					var refRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
								console.log("record :", record);
								//20191219 mainGrid에 적용된 데이터 기존단가의뢰번호검색 팝업에서 삭제하한 체크로직 수정
//								if((record.data['P_REQ_NUM'] == item.data['P_REQ_NUM'])
//									|| (record.data['ITEM_CODE'] == item.data['ITEM_CODE'])
//									&& (record.data['ITEM_NAME'] == item.data['ITEM_NAME'])
								if((record.data['REF_P_REQ_NUM'] == item.data['P_REQ_NUM'])
									&& (record.data['REF_SER_NO'] == item.data['SER_NO'])
								){
									refRecords.push(item);
								}
							});
						});
						store.remove(refRecords);
					}
				}
			}
		},
		loadStoreRecords : function()  {
			var param= Ext.getCmp('reqNumSearchForm2').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_bco100ukrv_kdGrid1', {
		sortableColumns : false,
		layout: 'fit',
		region: 'center',
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: true,
			useMultipleSorting: true,	//순번표시
			copiedRow: true
		},
		store: directMasterStore1,
		tbar: [{
			itemId : 'estimateBtn',
			id:'INFO_BTN',
			iconCls : 'icon-referance'  ,
			text:'추가정보',
			handler: function() {
				openSearchInfoWindow();
			}
		},{
			itemId : 'GWBtn',
			id:'GW',
			iconCls : 'icon-referance'  ,
			text:'기안',
			handler: function() {
				var param = panelResult.getValues();
				param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('P_REQ_NUM');
				if(confirm('기안 하시겠습니까?')) {
					s_bco100ukrv_kdService.selectGwData(param, function(provider, response) {
						if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
							panelResult.setValue('GW_TEMP', '기안중');
							s_bco100ukrv_kdService.makeDraftNum(param, function(provider2, response)   {
								UniAppManager.app.requestApprove();
							});
						} else {
							alert('이미 기안된 자료입니다.');
							return false;
						}
					});
				}
				UniAppManager.app.onQueryButtonDown();
			}
		}],
		columns: [
			{dataIndex: 'P_REQ_NUM'			, width:150, hidden: true},
			{dataIndex: 'SER_NO'			, width:80, hidden: true},
			{dataIndex: 'COMP_CODE'			, width:100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width:100, hidden: true},
			{dataIndex: 'NEW_ITEM_FREFIX'	, width: 120, hidden: true},
			{dataIndex: 'P_REQ_TYPE'		, width:100},
			{dataIndex: 'ITEM_CODE'			, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
						textFieldName: 'ITEM_CODE',
						DBtextFieldName: 'ITEM_CODE',
						extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
						autoPopup:true,
						listeners: {'onSelected': {
							fn: function(records, type) {

								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {

							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width:200},
			{dataIndex: 'CAR_TYPE'			, width:100},
			{dataIndex: 'HS_CODE'			, width: 120,
				editor: Unilite.popup('HS_G', {
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('HS_CODE', records[0]['HS_NO']);
								grdRecord.set('HS_NAME', records[0]['HS_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('HS_CODE', '');
							grdRecord.set('HS_NAME', '');
						},
						applyextparam: function(popup){

						}
					}
				})
			},
			{dataIndex: 'HS_NAME'			, width: 120, hidden: true},
			{dataIndex: 'ORDER_UNIT'		, width:100, align: 'center'},
			{dataIndex: 'PRICE_TYPE'		, width:100,
				editor:{
					xtype:'uniCombobox',
					store:Ext.data.StoreManager.lookup('CBS_AU_WB26'),
					listeners:{
						beforequery: function(queryPlan, eOpts )	{
							var fValue = panelResult.getValue('TYPE');
							var store = queryPlan.combo.getStore();
							if(!Ext.isEmpty(fValue) )   {
								store.clearFilter(true);
								queryPlan.combo.queryFilter = null;
								console.log("fValue :",fValue);
								store.filterBy(function(record, id){
									if(fValue == '1') {
									if(record.get('value') == 'N' || record.get('value') == 'Y' || record.get('value') == '3') {
										return record;
									} else {
										return null;
									}
									} else if(fValue == '2') {
										if(record.get('value') == '1' || record.get('value') == '2' || record.get('value') == '3') {
										return record;
									} else {
										return null;
									}
									}
								});
							} else {
								store.clearFilter(true);
								queryPlan.combo.queryFilter = null;
								store.loadRawData(store.proxy.data);
							}
						}
					}
				}
			},
			{dataIndex: 'NS_FLAG'			, width:100},
			{dataIndex: 'ITEM_P'			, width:85},
			{dataIndex: 'PACK_ITEM_P'		, width:85},
			{dataIndex: 'PRE_ITEM_P'		, width:85},
			//20191216 추가: DIFFER_UNIT_P
			{dataIndex: 'DIFFER_UNIT_P'		, width:85, editable: false},
			{dataIndex: 'MONEY_UNIT'		, width:100, align: 'center'},
			{dataIndex: 'TERMS_PRICE'		, width:85, align: 'center'},
			{dataIndex: 'APLY_START_DATE'	, width:100},
			{dataIndex: 'CUSTOM_CODE'		, width:120,
				'editor': Unilite.popup('AGENT_CUST_G',{
					textFieldName : 'CUSTOM_CODE',
					DBtextFieldName : 'CUSTOM_CODE',
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								var oldCustomCode = grdRecord.get("OLD_CUSTOM_CODE");
								var oldCustomName = grdRecord.get("OLD_CUSTOM_NAME");
	
								if( grdRecord.get("ADD01_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD02_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD03_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD04_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD05_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD06_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD07_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD08_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD09_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD10_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD11_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD12_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD13_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD14_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD15_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD16_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD17_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD18_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD19_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD20_CUSTOM_CODE") == records[0]['CUSTOM_CODE']
								|| grdRecord.get("ADD21_CUSTOM_CODE") == records[0]['CUSTOM_CODE'] || grdRecord.get("ADD22_CUSTOM_CODE") == records[0]['CUSTOM_CODE']){
									alert("추가거래처에 메인거래처와 동일한 정보가 입력되어 있습니다.");
									grdRecord.set("CUSTOM_CODE",oldCustomCode)
									grdRecord.set("CUSTOM_NAME",oldCustomName)
								}else{
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
									grdRecord.set('OLD_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('OLD_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
									var param = {
										'COMP_CODE': UserInfo.compCode
										, 'MONEY_UNIT': grdRecord.get('MONEY_UNIT')
										, 'APLY_START_DATE': UniDate.getDbDateStr(grdRecord.get('APLY_START_DATE'))
										, 'TYPE': panelResult.getValue('TYPE')
										, 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
										, 'ITEM_CODE': grdRecord.get('ITEM_CODE')
										, 'ORDER_UNIT': grdRecord.get('ORDER_UNIT')
										, 'DIV_CODE': panelResult.getValue('DIV_CODE')
										, 'NEW_ITEM_FREFIX': grdRecord.get('NEW_ITEM_FREFIX')
										, 'ITEM_NAME2': grdRecord.get('ITEM_NAME2')
										, 'SPEC2': grdRecord.get('SPEC2')
									};
									s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
										s_bco100ukrv_kdService.selectCustomData(param, function(provider2, response2) {
											if(!Ext.isEmpty(provider[0])) {
												grdRecord.set('PRE_ITEM_P'			, provider[0].ITEM_P);
												//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
												if(grdRecord.get('PRE_ITEM_P') == 0) {
													grdRecord.set('DIFFER_UNIT_P'	, 0);
												} else {
													grdRecord.set('DIFFER_UNIT_P'	, grdRecord.get('ITEM_P') - grdRecord.get('PRE_ITEM_P'));
												}
			//									grdRecord.set('APLY_START_DATE'	, UniDate.add(panelResult.getValue('APLY_START_DATE'), {days:-1}));
			//									grdRecord.set('PRICE_TYPE1'			, provider[0].PRICE_TYPE);
			//									grdRecord.set('PRICE_TYPE2'			, provider[0].PRICE_TYPE);
											}
											if(!Ext.isEmpty(provider2[0])){
												grdRecord.set('PAY_TERMS'			, provider2[0].RECEIPT_DAY);
												grdRecord.set('DELIVERY_METH'		, provider2[0].DELIVERY_METH);
											}
										});
									});
								}
							},
							scope: this
						},
						'onClear' : function(type)	{
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
								grdRecord.set('OLD_CUSTOM_CODE','');
								grdRecord.set('OLD_CUSTOM_NAME','');
								grdRecord.set('ITEM_P','');
								//20191216 추가: DIFFER_UNIT_P
								grdRecord.set('DIFFER_UNIT_P', 0);
	//							grdRecord.set('PRICE_TYPE1','');
	//							grdRecord.set('PRICE_TYPE2','');
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'		, width: 200},
			{dataIndex: 'PAY_TERMS'			, width:100},
			{dataIndex: 'DELIVERY_METH'		, width:100},
			{dataIndex: 'MAKER_CODE'		, width: 120,
				'editor': Unilite.popup('AGENT_CUST_G',{
					textFieldName : 'MAKER_CODE',
					DBtextFieldName : 'CUSTOM_CODE',
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('MAKER_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('MAKER_NAME',records[0]['CUSTOM_NAME']);
								var param = {
									'COMP_CODE': UserInfo.compCode
									, 'MONEY_UNIT': grdRecord.get('MONEY_UNIT')
									, 'APLY_START_DATE': UniDate.getDbDateStr(grdRecord.get('APLY_START_DATE'))
									, 'TYPE': panelResult.getValue('TYPE')
									, 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
									, 'ITEM_CODE': grdRecord.get('ITEM_CODE')
									, 'ORDER_UNIT': grdRecord.get('ORDER_UNIT')
									, 'DIV_CODE': panelResult.getValue('DIV_CODE')
									, 'NEW_ITEM_FREFIX': grdRecord.get('NEW_ITEM_FREFIX')
									, 'ITEM_NAME2': grdRecord.get('ITEM_NAME2')
									, 'SPEC2': grdRecord.get('SPEC2')
								};
								s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
									if(!Ext.isEmpty(provider)) {
										grdRecord.set('PRE_ITEM_P'		, provider[0].ITEM_P);
										//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
										if(grdRecord.get('PRE_ITEM_P') == 0) {
											grdRecord.set('DIFFER_UNIT_P'	, 0);
										} else {
											grdRecord.set('DIFFER_UNIT_P'	, grdRecord.get('ITEM_P') - grdRecord.get('PRE_ITEM_P'));
										}
//										grdRecord.set('APLY_START_DATE'	, UniDate.add(panelResult.getValue('APLY_START_DATE'), {days:-1}));
//										grdRecord.set('PRICE_TYPE1'		, provider[0].PRICE_TYPE);
//										grdRecord.set('PRICE_TYPE2'		, provider[0].PRICE_TYPE);
									}
								});
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('MAKER_CODE','');
							grdRecord.set('MAKER_NAME','');
							grdRecord.set('ITEM_P','');
							//20191216 추가: DIFFER_UNIT_P
							grdRecord.set('DIFFER_UNIT_P', 0);
//							grdRecord.set('PRICE_TYPE1','');
//							grdRecord.set('PRICE_TYPE2','');
						}
					}
				})
			},
			{dataIndex: 'MAKER_NAME'		, width:200},
			{dataIndex: 'CH_REASON'			, width:200},
			{dataIndex: 'OEM_APLY_YN'		, width:100},
			{dataIndex: 'OEM_YN'			, width:85, xtype: 'checkcolumn'},
			{dataIndex: '13199_YN'			, width:85, xtype: 'checkcolumn'},
			{dataIndex: '12199_YN'			, width:85, xtype: 'checkcolumn'},
			{dataIndex: '14199_YN'			, width:85, xtype: 'checkcolumn'},
			{dataIndex: '13301_YN'			, width:85, xtype: 'checkcolumn'},
			{dataIndex: 'CONFIRM_YN'		, width:85},
			{dataIndex: 'RENEWAL_YN'		, width:85},
			{dataIndex: 'GW_FLAG'			, width:100},
			{dataIndex: 'ITEM_NAME2'		, width:100, hidden: true},
			{dataIndex: 'SPEC2'				, width:100, hidden: true},
			{dataIndex: 'CAR_TYPE2'			, width:100, hidden: true},
			{dataIndex: 'NEW_CAR_TYPE'		, width:100, hidden: true},
			{dataIndex: 'STOCK_UNIT2'		, width:100, hidden: true},
			{dataIndex: 'CUSTOM_NAME2'		, width:100, hidden: true},
			{dataIndex: 'CUSTOM_FULL_NAME2'	, width:100, hidden: true},
			{dataIndex: 'TREE_CODE'			, width:100, hidden: true},
			{dataIndex: 'TREE_NAME'			, width:150, hidden: true},
			{dataIndex: 'PERSON_NUMB'		, width:100, hidden: true},
			{dataIndex: 'PERSON_NAME'		, width:150, hidden: true},
			{dataIndex: 'TYPE'				, width:100, hidden: true},
			{dataIndex: 'P_REQ_DATE'		, width:100, hidden: true},
			{dataIndex: 'SER_NO'			, width:100, hidden: true},
			{dataIndex: 'SPEC'				, width:100, hidden: true},
			{dataIndex: 'STOCK_UNIT'		, width:100, hidden: true},
			{dataIndex: 'CUSTOM_FULL_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD01_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD02_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD03_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD04_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD05_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD06_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD07_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD08_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD09_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD10_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD11_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD12_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD13_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD14_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD15_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD16_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD17_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD18_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD19_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD20_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD21_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD22_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'ADD01_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD02_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD03_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD04_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD05_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD06_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD07_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD08_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD09_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD10_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD11_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD12_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD13_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD14_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD15_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD16_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD17_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD18_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD19_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD20_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD21_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'ADD22_CUSTOM_NAME'	, width:100, hidden: true},
			{dataIndex: 'REMARK'			, width:100, hidden: true},
			{dataIndex: 'INSERT_DB_USER'	, width:100, hidden: true},
			{dataIndex: 'INSERT_DB_TIME'	, width:100, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width:100, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width:100, hidden: true},
			{dataIndex: 'TEMPC_01'			, width:100, hidden: true},
			{dataIndex: 'TEMPC_02'			, width:100, hidden: true},
			{dataIndex: 'TEMPC_03'			, width:100, hidden: true},
			{dataIndex: 'TEMPN_01'			, width:100, hidden: true},
			{dataIndex: 'TEMPN_02'			, width:100, hidden: true},
			{dataIndex: 'TEMPN_03'			, width:100, hidden: true},
			{dataIndex: 'FLAG'				, width:100, hidden: true},
			{dataIndex: 'OLD_CUSTOM_CODE'	, width:100, hidden: true},
			{dataIndex: 'OLD_CUSTOM_NAME'	, width:100, hidden: true},
			//20191219 mainGrid에 적용된 데이터는 기존단가의뢰번호검색 팝업에서 삭제하기 위해 컬럼 추가
			{dataIndex: 'REF_P_REQ_NUM'		, width:100, hidden: true},
			{dataIndex: 'REF_SER_NO'		, width:100, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(panelResult.getValue('GW_TEMP') == '기안중') {
						return false;
					}
					var record = masterGrid.getSelectedRecord();
					if(record.get('GW_FLAG') == '1' || record.get('GW_FLAG') == '3' || record.get('CONFIRM_YN') == 'Y') {
						return false;
					} else {
//					if(UniUtils.indexOf(e.field, ['P_REQ_NUM', 'ITEM_NAME', 'CAR_TYPE', 'CUSTOM_NAME', 'ORDER_UNIT', 'SER_NO', 'PRE_ITEM_P', 'SPEC', 'CONFIRM_YN', 'RENEWAL_YN', 'TREE_CODE', 'TREE_NAME', 'PERSON_NUMB', 'PERSON_NAME', 'GW_FLAG', 'P_REQ_TYPE']))
					if(UniUtils.indexOf(e.field, ['P_REQ_NUM', 'ITEM_NAME', 'CAR_TYPE', 'CUSTOM_NAME', 'ORDER_UNIT', 'SER_NO',  'SPEC', 'CONFIRM_YN', 'RENEWAL_YN', 'TREE_CODE', 'TREE_NAME', 'PERSON_NUMB', 'PERSON_NAME', 'GW_FLAG', 'P_REQ_TYPE']))

					{
							return false;
						} else {
							return true;
						}
					}
				} else {
//					if(UniUtils.indexOf(e.field, ['P_REQ_NUM', 'ITEM_NAME', 'CAR_TYPE', 'CUSTOM_NAME', 'ORDER_UNIT', 'SER_NO', 'PRE_ITEM_P', 'CONFIRM_YN', 'SPEC', 'RENEWAL_YN', 'TREE_CODE', 'TREE_NAME', 'PERSON_NUMB', 'PERSON_NAME', 'GW_FLAG', 'P_REQ_TYPE']))
					if(UniUtils.indexOf(e.field, ['P_REQ_NUM', 'ITEM_NAME', 'CAR_TYPE', 'CUSTOM_NAME', 'ORDER_UNIT', 'SER_NO',  'CONFIRM_YN', 'SPEC', 'RENEWAL_YN', 'TREE_CODE', 'TREE_NAME', 'PERSON_NUMB', 'PERSON_NAME', 'GW_FLAG', 'P_REQ_TYPE']))
					{
						return false;
					} else {
						return true;
					}
				}
			}/*,
			selectionchange:function( model1, selected, eOpts ){
				var count = masterGrid.getStore().getCount();
				if(count > 0) {
					var record = selected[0];
					if(record.get('CONFIRM_YN') == 'Y') {
						Ext.getCmp('INFO_BTN').setDisabled(true);
					} else {
						Ext.getCmp('INFO_BTN').setDisabled(false);
					}
				}
			}*/
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, '');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
				grdRecord.set('ORDER_UNIT'		, '');
				grdRecord.set('CAR_TYPE'		, '');
				grdRecord.set('HS_CODE'			, '');
				grdRecord.set('HS_NAME'			, '');
				grdRecord.set('PRE_ITEM_P'		, '');
				//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
				if(grdRecord.get('PRE_ITEM_P') == 0) {
					grdRecord.set('DIFFER_UNIT_P'	, 0);
				} else {
					grdRecord.set('DIFFER_UNIT_P'	, grdRecord.get('ITEM_P') - grdRecord.get('PRE_ITEM_P'));
				}
				grdRecord.set('STOCK_UNIT'		, '');

				grdRecord.set('NEW_ITEM_FREFIX'	, '');
				grdRecord.set('ITEM_NAME2'		, '');
				grdRecord.set('SPEC2'			, '');
				grdRecord.set('CAR_TYPE2'		, '');
				grdRecord.set('NEW_CAR_TYPE'	, '');
				grdRecord.set('STOCK_UNIT2'		, '');
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				if(panelResult.getValue('TYPE') == '1') {
					grdRecord.set('ORDER_UNIT'	, record['ORDER_UNIT']);
				} else {
					grdRecord.set('ORDER_UNIT'	, record['SALE_UNIT']);
				}
				grdRecord.set('CAR_TYPE'		, record['CAR_TYPE']);
				grdRecord.set('HS_CODE'			, record['HS_NO']);
				grdRecord.set('HS_NAME'			, record['HS_NAME']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);

				grdRecord.set('NEW_ITEM_FREFIX'	, '');
				grdRecord.set('ITEM_NAME2'		, '');
				grdRecord.set('SPEC2'			, '');
				grdRecord.set('CAR_TYPE2'		, '');
				grdRecord.set('NEW_CAR_TYPE'	, '');
				grdRecord.set('STOCK_UNIT2'		, '');
//				grdRecord.set('PRE_ITEM_P'		, '');
				var param = {
					'COMP_CODE': UserInfo.compCode
					, 'MONEY_UNIT': grdRecord.get('MONEY_UNIT')
					, 'APLY_START_DATE': UniDate.getDbDateStr(grdRecord.get('APLY_START_DATE'))
					, 'TYPE': panelResult.getValue('TYPE')
					, 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
					, 'ITEM_CODE': grdRecord.get('ITEM_CODE')
					, 'ORDER_UNIT': grdRecord.get('ORDER_UNIT')
					, 'DIV_CODE': panelResult.getValue('DIV_CODE')
					, 'NEW_ITEM_FREFIX': grdRecord.get('NEW_ITEM_FREFIX')
					, 'ITEM_NAME2': grdRecord.get('ITEM_NAME2')
					, 'SPEC2': grdRecord.get('SPEC2')
				};
				s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('PRE_ITEM_P'		, provider[0].ITEM_P);
						//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
						if(provider[0].ITEM_P == 0) {
							grdRecord.set('DIFFER_UNIT_P'	, 0);
						} else {
							grdRecord.set('DIFFER_UNIT_P'	, grdRecord.get('ITEM_P') - provider[0].ITEM_P);
						}
//						grdRecord.set('APLY_START_DATE'	, UniDate.add(panelResult.getValue('APLY_START_DATE'), {days:-1}));
//						grdRecord.set('PRICE_TYPE1'		, provider[0].PRICE_TYPE);
//						grdRecord.set('PRICE_TYPE2'		, provider[0].PRICE_TYPE);
					}
				});
			}
		},
		setCopyData: function(record) {
			var grdRecord = this.getSelectedRecord();
			if(!Ext.isEmpty(grdRecord)){
				grdRecord.set('SER_NO'					, record['SER_NO']);
				grdRecord.set('COMP_CODE'				, UserInfo.compCode);
				grdRecord.set('DIV_CODE'				, panelResult.getValue('DIV_CODE'));
				grdRecord.set('TREE_CODE'				, panelResult.getValue('TREE_CODE'));
				grdRecord.set('TREE_NAME'				, panelResult.getValue('TREE_NAME'));
				grdRecord.set('PERSON_NUMB'				, panelResult.getValue('PERSON_NUMB'));
				grdRecord.set('PERSON_NAME'				, panelResult.getValue('PERSON_NAME'));
				grdRecord.set('TYPE'					, record['TYPE']);
				grdRecord.set('MONEY_UNIT'				, record['MONEY_UNIT']);
				grdRecord.set('P_REQ_DATE'				, panelResult.getValue('P_REQ_DATE'));
				grdRecord.set('APLY_START_DATE'			, panelResult.getValue('APLY_START_DATE'));
				grdRecord.set('GW_FLAG'					, 'N');
				grdRecord.set('CUSTOM_CODE'				, record['CUSTOM_CODE']);
				grdRecord.set('CUSTOM_NAME'				, record['CUSTOM_NAME']);
				grdRecord.set('MAKER_CODE'				, record['MAKER_CODE']);
				grdRecord.set('MAKER_NAME'				, record['MAKER_NAME']);
				grdRecord.set('NEW_ITEM_FREFIX'			, record['NEW_ITEM_FREFIX']);
				grdRecord.set('ITEM_CODE'				, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'				, record['ITEM_NAME']);
				grdRecord.set('PRICE_TYPE'				, record['PRICE_TYPE']);
				grdRecord.set('ORDER_UNIT'				, record['ORDER_UNIT']);
				grdRecord.set('ITEM_P'					, record['ITEM_P']);
				grdRecord.set('PACK_ITEM_P'				, record['PACK_ITEM_P']);
				grdRecord.set('PRE_ITEM_P'				, record['PRE_ITEM_P']);
				grdRecord.set('HS_CODE'					, record['HS_CODE']);
				grdRecord.set('HS_NAME'					, record['HS_NAME']);
				grdRecord.set('PAY_TERMS'				, record['PAY_TERMS']);
				grdRecord.set('TERMS_PRICE'				, record['TERMS_PRICE']);
				grdRecord.set('DELIVERY_METH'			, record['DELIVERY_METH']);
				grdRecord.set('CH_REASON'				, record['CH_REASON']);
				grdRecord.set('OEM_YN'					, record['OEM_YN']);
				grdRecord.set('12199_YN'				, record['12199_YN']);
				grdRecord.set('13199_YN'				, record['13199_YN']);
				grdRecord.set('14199_YN'				, record['14199_YN']);
				grdRecord.set('13301_YN'				, record['13301_YN']);
				grdRecord.set('SPEC'					, record['SPEC']);
				grdRecord.set('CAR_TYPE'				, record['CAR_TYPE']);
				grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);
				grdRecord.set('CUSTOM_FULL_NAME'		, record['CUSTOM_FULL_NAME']);
				grdRecord.set('ADD01_CUSTOM_CODE'		, record['ADD01_CUSTOM_CODE']);
				grdRecord.set('ADD02_CUSTOM_CODE'		, record['ADD02_CUSTOM_CODE']);
				grdRecord.set('ADD03_CUSTOM_CODE'		, record['ADD03_CUSTOM_CODE']);
				grdRecord.set('ADD04_CUSTOM_CODE'		, record['ADD04_CUSTOM_CODE']);
				grdRecord.set('ADD05_CUSTOM_CODE'		, record['ADD05_CUSTOM_CODE']);
				grdRecord.set('ADD06_CUSTOM_CODE'		, record['ADD06_CUSTOM_CODE']);
				grdRecord.set('ADD07_CUSTOM_CODE'		, record['ADD07_CUSTOM_CODE']);
				grdRecord.set('ADD08_CUSTOM_CODE'		, record['ADD08_CUSTOM_CODE']);
				grdRecord.set('ADD09_CUSTOM_CODE'		, record['ADD09_CUSTOM_CODE']);
				grdRecord.set('ADD10_CUSTOM_CODE'		, record['ADD10_CUSTOM_CODE']);
				grdRecord.set('ADD11_CUSTOM_CODE'		, record['ADD11_CUSTOM_CODE']);
				grdRecord.set('ADD12_CUSTOM_CODE'		, record['ADD12_CUSTOM_CODE']);
				grdRecord.set('ADD13_CUSTOM_CODE'		, record['ADD13_CUSTOM_CODE']);
				grdRecord.set('ADD14_CUSTOM_CODE'		, record['ADD14_CUSTOM_CODE']);
				grdRecord.set('ADD15_CUSTOM_CODE'		, record['ADD15_CUSTOM_CODE']);
				grdRecord.set('ADD16_CUSTOM_CODE'		, record['ADD16_CUSTOM_CODE']);
				grdRecord.set('ADD17_CUSTOM_CODE'		, record['ADD17_CUSTOM_CODE']);
				grdRecord.set('ADD18_CUSTOM_CODE'		, record['ADD18_CUSTOM_CODE']);
				grdRecord.set('ADD19_CUSTOM_CODE'		, record['ADD19_CUSTOM_CODE']);
				grdRecord.set('ADD20_CUSTOM_CODE'		, record['ADD20_CUSTOM_CODE']);
				grdRecord.set('ADD21_CUSTOM_CODE'		, record['ADD21_CUSTOM_CODE']);
				grdRecord.set('ADD22_CUSTOM_CODE'		, record['ADD22_CUSTOM_CODE']);
				grdRecord.set('ADD01_CUSTOM_NAME'		, record['ADD01_CUSTOM_NAME']);
				grdRecord.set('ADD02_CUSTOM_NAME'		, record['ADD02_CUSTOM_NAME']);
				grdRecord.set('ADD03_CUSTOM_NAME'		, record['ADD03_CUSTOM_NAME']);
				grdRecord.set('ADD04_CUSTOM_NAME'		, record['ADD04_CUSTOM_NAME']);
				grdRecord.set('ADD05_CUSTOM_NAME'		, record['ADD05_CUSTOM_NAME']);
				grdRecord.set('ADD06_CUSTOM_NAME'		, record['ADD06_CUSTOM_NAME']);
				grdRecord.set('ADD07_CUSTOM_NAME'		, record['ADD07_CUSTOM_NAME']);
				grdRecord.set('ADD08_CUSTOM_NAME'		, record['ADD08_CUSTOM_NAME']);
				grdRecord.set('ADD09_CUSTOM_NAME'		, record['ADD09_CUSTOM_NAME']);
				grdRecord.set('ADD10_CUSTOM_NAME'		, record['ADD10_CUSTOM_NAME']);
				grdRecord.set('ADD11_CUSTOM_NAME'		, record['ADD11_CUSTOM_NAME']);
				grdRecord.set('ADD12_CUSTOM_NAME'		, record['ADD12_CUSTOM_NAME']);
				grdRecord.set('ADD13_CUSTOM_NAME'		, record['ADD13_CUSTOM_NAME']);
				grdRecord.set('ADD14_CUSTOM_NAME'		, record['ADD14_CUSTOM_NAME']);
				grdRecord.set('ADD15_CUSTOM_NAME'		, record['ADD15_CUSTOM_NAME']);
				grdRecord.set('ADD16_CUSTOM_NAME'		, record['ADD16_CUSTOM_NAME']);
				grdRecord.set('ADD17_CUSTOM_NAME'		, record['ADD17_CUSTOM_NAME']);
				grdRecord.set('ADD18_CUSTOM_NAME'		, record['ADD18_CUSTOM_NAME']);
				grdRecord.set('ADD19_CUSTOM_NAME'		, record['ADD19_CUSTOM_NAME']);
				grdRecord.set('ADD20_CUSTOM_NAME'		, record['ADD20_CUSTOM_NAME']);
				grdRecord.set('ADD21_CUSTOM_NAME'		, record['ADD21_CUSTOM_NAME']);
				grdRecord.set('ADD22_CUSTOM_NAME'		, record['ADD22_CUSTOM_NAME']);
				grdRecord.set('REMARK'					, record['REMARK']);
				grdRecord.set('CONFIRM_YN'				, 'N');
				grdRecord.set('RENEWAL_YN'				, 'N');
				grdRecord.set('INSERT_DB_USER'			, record['INSERT_DB_USER']);
				grdRecord.set('INSERT_DB_TIME'			, record['INSERT_DB_TIME']);
				grdRecord.set('UPDATE_DB_USER'			, record['UPDATE_DB_USER']);
				grdRecord.set('UPDATE_DB_TIME'			, record['UPDATE_DB_TIME']);
				grdRecord.set('TEMPC_01'				, record['TEMPC_01']);
				grdRecord.set('TEMPC_02'				, record['TEMPC_02']);
				grdRecord.set('TEMPC_03'				, record['TEMPC_03']);
				grdRecord.set('TEMPN_01'				, record['TEMPN_01']);
				grdRecord.set('TEMPN_02'				, record['TEMPN_02']);
				grdRecord.set('TEMPN_03'				, record['TEMPN_03']);
				grdRecord.set('OEM_APLY_YN'				, record['OEM_APLY_YN']);
				grdRecord.set('ITEM_NAME2'				, record['ITEM_NAME2']);
				grdRecord.set('SPEC2'					, record['SPEC2']);
				grdRecord.set('CAR_TYPE2'				, record['CAR_TYPE2']);
				grdRecord.set('NEW_CAR_TYPE'			, record['NEW_CAR_TYPE']);
				grdRecord.set('STOCK_UNIT2'				, record['STOCK_UNIT2']);
				grdRecord.set('CUSTOM_NAME2'			, record['CUSTOM_NAME2']);
				grdRecord.set('CUSTOM_FULL_NAME2'		, record['CUSTOM_FULL_NAME2']);
				//20191216 로직 추가: 품목코드가 없을 경우 - 종전단가사용옵션 체크햐여 로직 수행
				if(Ext.isEmpty(record['ITEM_CODE'])) {
					if(record['USE_YN'] == 'Y') {
						grdRecord.set('PRE_ITEM_P'		, record['ITEM_P']);
						grdRecord.set('ITEM_P'			, record['ITEM_P'] + record['DIFFERENCE_AMT']);
					} else {
						grdRecord.set('PRE_ITEM_P'		, 0);
						grdRecord.set('ITEM_P'			, 0);
					}
					//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
					if(grdRecord.get('PRE_ITEM_P') == 0) {
						grdRecord.set('DIFFER_UNIT_P'	, 0);
					} else {
						grdRecord.set('DIFFER_UNIT_P'	, grdRecord.get('ITEM_P') - grdRecord.get('PRE_ITEM_P'));
					}
				} else {
					//COMP_CODE, TYPE, DIV_CODE, ITEM_CODE, CUSTOM_CODE, MONEY_UNIT, ORDER_UNIT, APLY_START_DATE
					var param = {
						COMP_CODE	: UserInfo.compCode,
						DIV_CODE	: panelResult.getValue('DIV_CODE'),
						TYPE		: record['TYPE'],
						ITEM_CODE	: record['ITEM_CODE'],
						CUSTOM_CODE	: record['CUSTOM_CODE'],
						MONEY_UNIT	: record['MONEY_UNIT'],
						ORDER_UNIT	: record['ORDER_UNIT']
					}
					s_bco100ukrv_kdService.getPreItemP(param, function(provider, response) {
						if(Ext.isEmpty(provider)) {
							grdRecord.set('PRE_ITEM_P'	, 0);
						} else {
							grdRecord.set('PRE_ITEM_P'	, provider);
						}
						grdRecord.set('ITEM_P'			, record['ITEM_P'] + record['DIFFERENCE_AMT']);
						//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
						if(grdRecord.get('PRE_ITEM_P') == 0) {
							grdRecord.set('DIFFER_UNIT_P'	, 0);
						} else {
							grdRecord.set('DIFFER_UNIT_P'	, grdRecord.get('ITEM_P') - grdRecord.get('PRE_ITEM_P'));
						}
					});
				}
			}
		}
	});//End of var masterGrid = Unilite.createGrid('s_bco100ukrv_kdGrid1', {

	var reqNumMasterGrid = Unilite.createGrid('reqNumMasterGrid', {	// 검색 팝업창
		// title: '기본',
		layout : 'fit',
		store: reqNumMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
		columns:  [
			{dataIndex : 'GW_FLAG'			, width : 80},
			{dataIndex : 'P_REQ_NUM'		, width : 100},
			{dataIndex : 'TYPE'				, width : 80},
			{dataIndex : 'ITEM_CODE'		, width : 110},
			{dataIndex : 'ITEM_NAME'		, width : 200},
			{dataIndex : 'SPEC'				, width : 200},
			{dataIndex : 'CUSTOM_NAME'		, width : 200},
			{dataIndex : 'ITEM_P'			, width : 80},
			{dataIndex : 'MONEY_UNIT'		, width : 100},
			{dataIndex : 'APLY_START_DATE'	, width : 80},
			{dataIndex : 'PERSON_NAME'		, width : 150},
			{dataIndex : 'P_REQ_DATE'		, width : 80, hidden: true},
			{dataIndex : 'PERSON_NUMB'		, width : 100, hidden: true},
			{dataIndex : 'DIV_CODE'			, width : 80, hidden: true} ,
			{dataIndex : 'P_REQ_TYPE'		, width : 80, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				if(reqNumSearch.setAllFieldsReadOnly(true) == false){
					return false;
				} else {
					reqNumMasterGrid.returnData(record);
					UniAppManager.app.onQueryButtonDown();
					SearchReqNumWindow.hide();
				}
			}
		},
		returnData: function(record)   {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE')});
			panelResult.setValues({'P_REQ_NUM':record.get('P_REQ_NUM')});
			panelResult.setValues({'TREE_CODE':record.get('TREE_CODE')});
			panelResult.setValues({'TREE_NAME':record.get('TREE_NAME')});
			panelResult.setValues({'TYPE':record.get('TYPE')});
			panelResult.setValues({'P_REQ_DATE':record.get('P_REQ_DATE')});
			panelResult.setValues({'APLY_START_DATE':record.get('APLY_START_DATE')});
			panelResult.setValues({'PERSON_NUMB':record.get('PERSON_NUMB')});
			panelResult.setValues({'PERSON_NAME':record.get('PERSON_NAME')});
			panelResult.setValues({'MONEY_UNIT':record.get('MONEY_UNIT')});
			panelResult.setValues({'P_REQ_TYPE':record.get('P_REQ_TYPE')});

			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE')});
			panelResult.setValues({'P_REQ_NUM':record.get('P_REQ_NUM')});
			panelResult.setValues({'TREE_CODE':record.get('TREE_CODE')});
			panelResult.setValues({'TREE_NAME':record.get('TREE_NAME')});
			panelResult.setValues({'TYPE':record.get('TYPE')});
			panelResult.setValues({'P_REQ_DATE':record.get('P_REQ_DATE')});
			panelResult.setValues({'APLY_START_DATE':record.get('APLY_START_DATE')});
			panelResult.setValues({'PERSON_NUMB':record.get('PERSON_NUMB')});
			panelResult.setValues({'PERSON_NAME':record.get('PERSON_NAME')});
			panelResult.setValues({'MONEY_UNIT':record.get('MONEY_UNIT')});
			panelResult.setValues({'P_REQ_TYPE':record.get('P_REQ_TYPE')});
		}
	});

	var copyReqNumMasterGrid = Unilite.createGrid('copyReqNumMasterGrid', {	// 기존의뢰번호 팝업창
		store	: copyReqNumMasterStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst	: false,
			useRowNumberer		: false
		},
		columns	: [{
				xtype		: 'rownumberer', 
				align		: 'center  !important',
				sortable	: false,
				resizable	: true, 
				width		: 35
			},	
			{dataIndex: 'GW_FLAG'			, width: 100},
			{dataIndex: 'P_REQ_NUM'			, width: 150},
			//20191218 SER_NO, P_REQ_DATE 컬럼 순서 변경 / hidden: false로 설정
			{dataIndex: 'SER_NO'			, width: 80, hidden: false},
			{dataIndex: 'P_REQ_DATE'		, width: 100, hidden: false},
			{dataIndex: 'TYPE'				, width: 100},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			//201912224 추가
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ITEM_P'			, width: 85},
			{dataIndex: 'MONEY_UNIT'		, width: 100, align: 'center'},
			{dataIndex: 'APLY_START_DATE'	, width: 100},
			{dataIndex: 'PERSON_NAME'		, width: 150},
			{dataIndex: 'PACK_ITEM_P'		, width: 85, hidden: true},
			{dataIndex: 'PRE_ITEM_P'		, width: 85, hidden: true},
			{dataIndex: 'TERMS_PRICE'		, width: 85, align: 'center', hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 120, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 200},
			{dataIndex: 'P_REQ_TYPE'		, width: 100},
			{dataIndex: 'PAY_TERMS'			, width: 100, hidden: true},
			{dataIndex: 'DELIVERY_METH'		, width: 100, hidden: true},
			{dataIndex: 'MAKER_CODE'		, width: 120, hidden: true},
			{dataIndex: 'MAKER_NAME'		, width: 200, hidden: true},
			{dataIndex: 'CH_REASON'			, width: 200, hidden: true},
			{dataIndex: 'OEM_APLY_YN'		, width: 100, hidden: true},
			{dataIndex: 'OEM_YN'			, width: 85, xtype: 'checkcolumn', hidden: true},
			{dataIndex: '13199_YN'			, width: 85, xtype: 'checkcolumn', hidden: true},
			{dataIndex: '12199_YN'			, width: 85, xtype: 'checkcolumn', hidden: true},
			{dataIndex: '14199_YN'			, width: 85, xtype: 'checkcolumn', hidden: true},
			{dataIndex: '13301_YN'			, width: 85, xtype: 'checkcolumn', hidden: true},
			{dataIndex: 'CONFIRM_YN'		, width: 85, hidden: true},
			{dataIndex: 'RENEWAL_YN'		, width: 85, hidden: true},
			{dataIndex: 'SPEC'				, width: 100, hidden: true},
			{dataIndex: 'CAR_TYPE'			, width: 100, hidden: true},
			{dataIndex: 'HS_CODE'			, width: 120, hidden: true},
			{dataIndex: 'HS_NAME'			, width: 120, hidden: true},
			{dataIndex: 'ORDER_UNIT'		, width: 100, align: 'center', hidden: true},
			{dataIndex: 'PRICE_TYPE'		, width: 100},
			{dataIndex: 'NS_FLAG'			, width: 100, hidden: true},
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'NEW_ITEM_FREFIX'	, width: 120, hidden: true},
			{dataIndex: 'TREE_CODE'			, width: 100, hidden: true},
			{dataIndex: 'TREE_NAME'			, width: 150, hidden: true},
			{dataIndex: 'PERSON_NUMB'		, width: 100, hidden: true},
			{dataIndex: 'SER_NO'			, width: 100, hidden: true},
			{dataIndex: 'SPEC'				, width: 100, hidden: true},
			{dataIndex: 'STOCK_UNIT'		, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_FULL_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD01_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD02_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD03_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD04_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD05_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD06_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD07_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD08_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD09_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD10_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD11_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD12_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD13_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD14_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD15_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD16_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD17_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD18_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD19_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD20_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD21_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD22_CUSTOM_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ADD01_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD02_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD03_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD04_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD05_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD06_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD07_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD08_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD09_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD10_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD11_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD12_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD13_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD14_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD15_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD16_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD17_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD18_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD19_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD20_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD21_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'ADD22_CUSTOM_NAME'	, width: 100, hidden: true},
			{dataIndex: 'REMARK'			, width: 100, hidden: true},
			{dataIndex: 'INSERT_DB_USER'	, width: 100, hidden: true},
			{dataIndex: 'INSERT_DB_TIME'	, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100, hidden: true},
			{dataIndex: 'TEMPC_01'			, width: 100, hidden: true},
			{dataIndex: 'TEMPC_02'			, width: 100, hidden: true},
			{dataIndex: 'TEMPC_03'			, width: 100, hidden: true},
			{dataIndex: 'TEMPN_01'			, width: 100, hidden: true},
			{dataIndex: 'TEMPN_02'			, width: 100, hidden: true},
			{dataIndex: 'TEMPN_03'			, width: 100, hidden: true},
			{dataIndex: 'ITEM_NAME2'		, width: 100, hidden: true},
			{dataIndex: 'SPEC2'				, width: 100, hidden: true},
			{dataIndex: 'CAR_TYPE2'			, width: 100, hidden: true},
			{dataIndex: 'NEW_CAR_TYPE'		, width: 100, hidden: true},
			{dataIndex: 'STOCK_UNIT2'		, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_NAME2'		, width: 100, hidden: true},
			{dataIndex: 'CUSTOM_FULL_NAME2'	, width: 100, hidden: true},
			//20191219 참조적용 로직 변경을 위해 참조데이터 조회 시, BPR400T의 최종 ITEM_P 가져오는 로직 추가
			{dataIndex: 'BPR400T_ITEM_P'	, width: 100, hidden: true}
		],
		returnData: function(record)   {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i) {
				//20191216 로직 추가: 팝업창에 추가된 필드 값 record 값과 같이 넘김
				record.set('DIFFERENCE_AMT'	, reqNumSearch2.getValue('DIFFERENCE_AMT'));
				record.set('USE_YN'			, reqNumSearch2.down('#rdoSelect').getValue().USE_YN);
				//20191219 기존의뢰서복사 데이터 적용 방식 변경: store에 직접 load하는 방식으로 변경 - 주석
//				UniAppManager.app.onNewDataButtonDown('Y', record);
			});
			//20191219 기존의뢰서복사 데이터 적용 방식 변경: store에 직접 load하는 방식으로 변경 - 신규 생성한 함수 호출
			UniAppManager.app.fnMakeMainData(records);
			this.getStore().remove(records);
		}
	});

	var orderNoSearch = Unilite.createSearchForm('otherorderForm', {		// 추가정보 팝업창
		layout: {type : 'uniTable', columns : 3},
		height: 580,
		masterGrid: masterGrid,
		defaults : {enforceMaxLength: true},
		items:[
			{
				fieldLabel: '의뢰번호',
				name:'P_REQ_NUM',
				xtype: 'uniTextfield',
				readOnly: true
			},{
				fieldLabel: '의뢰순번',
				name:'SER_NO',
				xtype: 'uniTextfield',
				readOnly: true,
				colspan: 2
			},{
				xtype:'displayfield',
				hideLabel:true,
				value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[신규물품정보]</div>',
				colspan: 3
			},{
				fieldLabel: '신규품목코드',
				name:'NEW_ITEM_FREFIX',
				xtype: 'uniTextfield',
				maxLength: 4
			},{
				fieldLabel: '품목명',
				name:'ITEM_NAME2',
				xtype: 'uniTextfield',
				width: 350,
				maxLength: 40
			},{
				fieldLabel: '규격/품번',
				xtype: 'uniTextfield',
				name: 'SPEC2',
				width: 300,
				colspan: 1
			},{
				fieldLabel: '신규차종',
				xtype: 'uniTextfield',
				name: 'NEW_CAR_TYPE',
				maxLength: 20
			},{
				name: 'CAR_TYPE2',
				fieldLabel: '차종',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'WB04'
			},{
				name: 'STOCK_UNIT2',
				fieldLabel: '재고단위',
				xtype:'uniCombobox',
				displayField: 'value',
				comboType:'AU',
				comboCode:'B013',
				fieldStyle: 'text-align: center;',
				colspan: 1
			},{
				xtype:'displayfield',
				hideLabel:true,
				value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[신규업체정보]</div>',
				colspan: 3
			},{
				fieldLabel: '거래처약명',
				name:'CUSTOM_NAME2',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '거래처전명',
				xtype: 'uniTextfield',
				width: 650,
				colspan: 3,
				name: 'CUSTOM_FULL_NAME2'
			},{
				xtype:'displayfield',
				hideLabel:true,
				value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[추가업체정보]</div>',
				colspan: 3
			},
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처01',
				valueFieldName: 'ADD01_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME01',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD01_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME01', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD01_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME01', '');

						}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처02',
				valueFieldName: 'ADD02_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME02',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE ){
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD02_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME02', '');
							}else if(orderNoSearch.getValue('ADD01_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
								|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
								|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
								|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
								|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
								|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
								|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
								|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD02_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME02', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처03',
				valueFieldName: 'ADD03_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME03',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
									alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
									orderNoSearch.setValue('ADD03_CUSTOM_CODE', '');
									orderNoSearch.setValue('CUSTOM_NAME03', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD01_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){

								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD03_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME03', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처04',
				valueFieldName: 'ADD04_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME04',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE ) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD04_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME04', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
								||orderNoSearch.getValue('ADD01_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD04_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME04', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처05',
				valueFieldName: 'ADD05_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME05',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD05_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME05', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD01_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD05_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME05', '');

							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처06',
				valueFieldName: 'ADD06_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME06',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE ) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD06_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME06', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD01_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD06_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME06', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처07',
				valueFieldName: 'ADD07_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME07',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD07_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME07', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD01_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD07_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME07', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처08',
				valueFieldName: 'ADD08_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME08',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE ){
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD08_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME08', '');
							}else if( orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD01_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD08_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME08', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처09',
				valueFieldName: 'ADD09_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME09',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD09_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME09', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD01_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD09_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME09', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처10',
				valueFieldName: 'ADD10_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME10',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD10_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME10', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD10_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME10', '');

							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처11',
				valueFieldName: 'ADD11_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME11',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD11_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME11', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD11_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME11', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처12',
				valueFieldName: 'ADD12_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME12',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD12_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME12', '');
							}else if( orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD12_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME12', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처13',
				valueFieldName: 'ADD13_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME13',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD13_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME13', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){

								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD12_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME12', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처14',
				valueFieldName: 'ADD14_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME14',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD14_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME14', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD14_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME14', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처15',
				valueFieldName: 'ADD15_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME15',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD15_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME15', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD15_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME15', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처16',
				valueFieldName: 'ADD16_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME16',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD16_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME16', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD16_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME16', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처17',
				valueFieldName: 'ADD17_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME17',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD17_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME17', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD17_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME17', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처18',
				valueFieldName: 'ADD18_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME18',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD18_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME18', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD18_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME18', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처19',
				valueFieldName: 'ADD19_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME19',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE ){
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD19_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME19', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD19_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME19', '');
							}
						},
						scope: this
					}
				}
			}),
			Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처20',
				valueFieldName: 'ADD20_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME20',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD20_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME20', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD19_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME19', '');
							}
						},
						scope: this
					}
				}
			}),Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처21',
				valueFieldName: 'ADD21_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME21',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE ) {
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD21_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME21', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD22_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD21_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME21', '');
							}
						},
						scope: this
					}
				}
			}),Unilite.popup('AGENT_CUST',{
				fieldLabel:'거래처22',
				valueFieldName: 'ADD22_CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME22',
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							var record = masterGrid.getSelectedRecord();
							if(record.get('CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('메인거래처와 동일한 추가거래처는 입력 할 수 없습니다.');
								orderNoSearch.setValue('ADD22_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME22', '');
							}else if(orderNoSearch.getValue('ADD02_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD03_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD04_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD05_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD06_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD07_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD08_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD09_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD10_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD11_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD12_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD13_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD14_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD15_CUSTOM_CODE') == records[0].CUSTOM_CODE
									|| orderNoSearch.getValue('ADD16_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD17_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD18_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD19_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD20_CUSTOM_CODE') == records[0].CUSTOM_CODE || orderNoSearch.getValue('ADD21_CUSTOM_CODE') == records[0].CUSTOM_CODE
										|| orderNoSearch.getValue('ADD1_CUSTOM_CODE') == records[0].CUSTOM_CODE){
								alert('동일한 거래처는 입력할수 없습니다.');
								orderNoSearch.setValue('ADD22_CUSTOM_CODE', '');
								orderNoSearch.setValue('CUSTOM_NAME22', '');
							}
						},
						scope: this
					}
				}
			}),{
				xtype: 'component'
			}
		]/*,
		loadForm: function(record)  {
			// window 오픈시 form에 Data load
			var count = masterGrid.getStore().getCount();
			if(count > 0) {
				this.reset();
				this.setActiveRecord(record[0] || null);
				this.resetDirtyStatus();
			}
		}*/
	});

	function openSearchPreqNumWindow() {	// 검색 팝업창
		if(!SearchReqNumWindow) {
			SearchReqNumWindow = Ext.create('widget.uniDetailWindow', {
				title: '단가의뢰번호검색',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [reqNumSearch, reqNumMasterGrid],
				tbar:  ['->',
					{itemId : 'saveBtn',
					text: '조회',
					handler: function() {
						if(reqNumSearch.setAllFieldsReadOnly(true) == false){
							return false;
						} else {
							reqNumMasterStore.loadStoreRecords();
						}
					},
					disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '닫기',
						handler: function() {
							gstypeChk = 'N';
							SearchReqNumWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {
					beforeshow: function( panel, eOpts )	{
						gstypeChk = 'Y';
						reqNumSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						reqNumSearch.setValue('P_REQ_NUM',panelResult.getValue('P_REQ_NUM'));
						reqNumSearch.setValue('DEPT_CODE',panelResult.getValue('TREE_CODE'));
						reqNumSearch.setValue('DEPT_NAME',panelResult.getValue('TREE_NAME'));
						reqNumSearch.setValue('TYPE',panelResult.getValue('TYPE'));
						reqNumSearch.setValue('P_REQ_DATE',panelResult.getValue('P_REQ_DATE'));
						reqNumSearch.setValue('APLY_START_DATE',panelResult.getValue('APLY_START_DATE'));
						reqNumSearch.setValue('PERSON_NUMB',panelResult.getValue('PERSON_NUMB'));
						reqNumSearch.setValue('PERSON_NAME',panelResult.getValue('PERSON_NAME'));
						reqNumSearch.setValue('MONEY_UNIT',panelResult.getValue('MONEY_UNIT'));
						reqNumSearch.setValue('P_REQ_TYPE',panelResult.getValue('P_REQ_TYPE'));
						if(!Ext.isEmpty(reqNumSearch.getValue('DEPT_CODE')) && !Ext.isEmpty(reqNumSearch.getValue('P_REQ_TYPE'))) {
							reqNumMasterStore.loadStoreRecords();
						}
					}
				}
			})
		}
		SearchReqNumWindow.center();
		SearchReqNumWindow.show();
	}

	function typeChk(sType) {				//매입,의뢰서구분 관련 체크 로직
		var records = Ext.data.StoreManager.lookup('WB22List').data.items;
		var sValue = [];
		var defaultValue1 = '';
		var defaultValue2 = '';
		var rtnVal =  new Array();
		Ext.each(records, function(item, i){
			if(sType == '1'){
				if(item.get("refCode1") == '1'){
					sValue.push(item.get("value"));
				}
			}else{
				if(item.get("refCode1") == '2'){
					sValue.push(item.get("value"));
				}
			}

			if(item.get("refCode2") == '1' ){
				defaultValue1 = item.get("value");
			}
			if(item.get("refCode2") == '2' ){
				defaultValue2 = item.get("value");
			}
		})

		rtnVal[0] = sValue;
		rtnVal[1] = defaultValue1;
		rtnVal[2] = defaultValue2;

		return rtnVal ;
	}

	function openCopyPreqNumWindow() {		// 기존의뢰번호 검색
		if(!CopyReqNumWindow) {
			CopyReqNumWindow = Ext.create('widget.uniDetailWindow', {
				title: '기존단가의뢰번호검색',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [reqNumSearch2, copyReqNumMasterGrid],
				tbar:  ['->',
					{itemId : 'saveBtn',
					text: '조회',
					handler: function() {
						if(reqNumSearch2.setAllFieldsReadOnly(true) == false){
							return false;
						}
						copyReqNumMasterStore.loadStoreRecords();
					},
					disabled: false
					},{
						itemId : 'confirmCloseBtn',
						text: '적용 후 닫기',
						handler: function() {
							copyReqNumMasterGrid.returnData();
							CopyReqNumWindow.hide();
	//					directMasterStore1.loadStoreRecords();

							var count = masterGrid.getStore().getCount();
							if(count > 0) {
								panelResult.setAllFieldsReadOnly(true);
							} else {
								panelResult.setAllFieldsReadOnly(false);
							}
						},
						disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '닫기',
						handler: function() {
							CopyReqNumWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {
					beforeshow: function( panel, eOpts) {
						reqNumSearch2.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						reqNumSearch2.setValue('P_REQ_NUM'		, panelResult.getValue('P_REQ_NUM'));
						reqNumSearch2.setValue('DEPT_CODE'		, panelResult.getValue('TREE_CODE'));
						reqNumSearch2.setValue('DEPT_NAME'		, panelResult.getValue('TREE_NAME'));
						reqNumSearch2.setValue('TYPE'			, panelResult.getValue('TYPE'));
						reqNumSearch2.setValue('P_REQ_DATE'		, panelResult.getValue('P_REQ_DATE'));
						reqNumSearch2.setValue('APLY_START_DATE', panelResult.getValue('APLY_START_DATE'));
						reqNumSearch2.setValue('PERSON_NUMB'	, panelResult.getValue('PERSON_NUMB'));
						reqNumSearch2.setValue('PERSON_NAME'	, panelResult.getValue('PERSON_NAME'));
						reqNumSearch2.setValue('MONEY_UNIT'		, panelResult.getValue('MONEY_UNIT'));
						reqNumSearch2.setValue('P_REQ_TYPE'		, panelResult.getValue('P_REQ_TYPE'));
						reqNumSearch2.setValue('DIFFERENCE_AMT'	, 0);
						reqNumSearch2.setValue('USE_YN'			, 'Y');
						//20191218 필드 / 기본값 setting 로직 추가
						reqNumSearch2.setValue('P_REQ_DATE_FR'	, UniDate.get('startOfLastMonth'));
						reqNumSearch2.setValue('P_REQ_DATE_TO'	, UniDate.get('today'));
						//20191218 주석
//						if(!Ext.isEmpty(reqNumSearch2.getValue('DEPT_CODE')) && !Ext.isEmpty(reqNumSearch2.getValue('P_REQ_TYPE'))) {
//							copyReqNumMasterStore.loadStoreRecords();
//						}
					}
				}
			})
		}
		CopyReqNumWindow.center();
		CopyReqNumWindow.show();
	}

	function openSearchInfoWindow() {		// 추가정보 팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '단가의뢰서추가정보',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch],

				tbar:  ['->',
					{   itemId : 'copyBtn',
						text: '이전레코드복사',
						handler: function(rowIndex,colIndex,store,view) {
							var record = masterGrid.getSelectedRecord();
							var param = {
							DIV_CODE	: record.get('DIV_CODE'),
							P_REQ_NUM   : record.get('P_REQ_NUM'),
							SER_NO	: record.get('SER_NO') - 1
							}
							s_bco100ukrv_kdService.selectPreSeqList(param, function(provider, response)   {
								if(!Ext.isEmpty(provider)) {
//									orderNoSearch.setValue('P_REQ_NUM'		,record.data.P_REQ_NUM);
//									orderNoSearch.setValue('SER_NO'			,record.data.SER_NO);
									orderNoSearch.setValue('NEW_ITEM_FREFIX'	,provider[0].NEW_ITEM_FREFIX);
									orderNoSearch.setValue('ITEM_NAME2'		,provider[0].ITEM_NAME2);
									orderNoSearch.setValue('SPEC2'			,provider[0].SPEC2);
									orderNoSearch.setValue('NEW_CAR_TYPE'	,provider[0].NEW_CAR_TYPE);
									orderNoSearch.setValue('CAR_TYPE2'		,provider[0].CAR_TYPE2);
									orderNoSearch.setValue('STOCK_UNIT2'		,provider[0].STOCK_UNIT2);
									orderNoSearch.setValue('CUSTOM_NAME2'	,provider[0].CUSTOM_NAME2);
									orderNoSearch.setValue('CUSTOM_FULL_NAME2'  ,provider[0].CUSTOM_FULL_NAME2);
									orderNoSearch.setValue('ADD01_CUSTOM_CODE'  ,provider[0].ADD01_CUSTOM_CODE);
									orderNoSearch.setValue('ADD02_CUSTOM_CODE'  ,provider[0].ADD02_CUSTOM_CODE);
									orderNoSearch.setValue('ADD03_CUSTOM_CODE'  ,provider[0].ADD03_CUSTOM_CODE);
									orderNoSearch.setValue('ADD04_CUSTOM_CODE'  ,provider[0].ADD04_CUSTOM_CODE);
									orderNoSearch.setValue('ADD05_CUSTOM_CODE'  ,provider[0].ADD05_CUSTOM_CODE);
									orderNoSearch.setValue('ADD06_CUSTOM_CODE'  ,provider[0].ADD06_CUSTOM_CODE);
									orderNoSearch.setValue('ADD07_CUSTOM_CODE'  ,provider[0].ADD07_CUSTOM_CODE);
									orderNoSearch.setValue('ADD08_CUSTOM_CODE'  ,provider[0].ADD08_CUSTOM_CODE);
									orderNoSearch.setValue('ADD09_CUSTOM_CODE'  ,provider[0].ADD09_CUSTOM_CODE);
									orderNoSearch.setValue('ADD10_CUSTOM_CODE'  ,provider[0].ADD10_CUSTOM_CODE);
									orderNoSearch.setValue('ADD11_CUSTOM_CODE'  ,provider[0].ADD11_CUSTOM_CODE);
									orderNoSearch.setValue('ADD12_CUSTOM_CODE'  ,provider[0].ADD12_CUSTOM_CODE);
									orderNoSearch.setValue('ADD13_CUSTOM_CODE'  ,provider[0].ADD13_CUSTOM_CODE);
									orderNoSearch.setValue('ADD14_CUSTOM_CODE'  ,provider[0].ADD14_CUSTOM_CODE);
									orderNoSearch.setValue('ADD15_CUSTOM_CODE'  ,provider[0].ADD15_CUSTOM_CODE);
									orderNoSearch.setValue('ADD16_CUSTOM_CODE'  ,provider[0].ADD16_CUSTOM_CODE);
									orderNoSearch.setValue('ADD17_CUSTOM_CODE'  ,provider[0].ADD17_CUSTOM_CODE);
									orderNoSearch.setValue('ADD18_CUSTOM_CODE'  ,provider[0].ADD18_CUSTOM_CODE);
									orderNoSearch.setValue('ADD19_CUSTOM_CODE'  ,provider[0].ADD19_CUSTOM_CODE);
									orderNoSearch.setValue('ADD20_CUSTOM_CODE'  ,provider[0].ADD20_CUSTOM_CODE);
									orderNoSearch.setValue('ADD21_CUSTOM_CODE'  ,provider[0].ADD20_CUSTOM_CODE);
									orderNoSearch.setValue('ADD22_CUSTOM_CODE'  ,provider[0].ADD20_CUSTOM_CODE);
									orderNoSearch.setValue('CUSTOM_NAME01'  ,provider[0].ADD01_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME02'  ,provider[0].ADD02_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME03'  ,provider[0].ADD03_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME04'  ,provider[0].ADD04_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME05'  ,provider[0].ADD05_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME06'  ,provider[0].ADD06_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME07'  ,provider[0].ADD07_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME08'  ,provider[0].ADD08_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME09'  ,provider[0].ADD09_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME10'  ,provider[0].ADD10_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME11'  ,provider[0].ADD11_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME12'  ,provider[0].ADD12_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME13'  ,provider[0].ADD13_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME14'  ,provider[0].ADD14_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME15'  ,provider[0].ADD15_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME16'  ,provider[0].ADD16_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME17'  ,provider[0].ADD17_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME18'  ,provider[0].ADD18_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME19'  ,provider[0].ADD19_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME20'  ,provider[0].ADD20_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME21'  ,provider[0].ADD21_CUSTOM_NAME);
									orderNoSearch.setValue('CUSTOM_NAME22'  ,provider[0].ADD21_CUSTOM_NAME);
								} else {
									alert('이전자료가 없습니다.');
								}
							});
						},
						disabled: false
					}, {
						itemId : 'OrderNoSetBtn',
						text: '적용',
						handler: function() {
							var record = masterGrid.getSelectedRecord();
//							if(record.get('FLAG') != 'N') {

								if (orderNoSearch.getValue('ITEM_NAME2') != "")
								{
//								if(Ext.isEmpty(orderNoSearch.getValue('NEW_CAR_TYPE')) ) {
//										alert("신규차종 필수입력값입니다.");
//										return false;
//								}

								var carType = orderNoSearch.getValue('CAR_TYPE2');
								var newCarType = orderNoSearch.getValue('NEW_CAR_TYPE');
								var sType = panelResult.getValue('TYPE');

								if (!Ext.isEmpty(carType) && !Ext.isEmpty(newCarType))
								{
										alert("신규차종 또는 차종중 하나의 정보만 입력하십시오.");
										return false;
								}

								if(sType == '2'){
										if (Ext.isEmpty(carType) && Ext.isEmpty(newCarType))
										{
												alert("신규차종 또는 차종은 필수입력값입니다.");
												return false;
										}
								}

								if(Ext.isEmpty(orderNoSearch.getValue('ITEM_NAME2')) || Ext.isEmpty(orderNoSearch.getValue('STOCK_UNIT2')) || Ext.isEmpty(orderNoSearch.getValue('SPEC2'))) {
									alert("품목명, 규격, 재고단위는 필수입력값입니다.");
									return false;
								}
								if(!Ext.isEmpty(orderNoSearch.getValue('ITEM_NAME2'))) {
									if(Ext.isEmpty(orderNoSearch.getValue('STOCK_UNIT2')) && Ext.isEmpty(orderNoSearch.getValue('SPEC2'))) {
										alert("규격 또는 재고단위는 필수입력값입니다.");
										return false;
									}
								}
								if(!Ext.isEmpty(orderNoSearch.getValue('STOCK_UNIT2'))) {
									if(Ext.isEmpty(orderNoSearch.getValue('ITEM_NAME2')) && Ext.isEmpty(orderNoSearch.getValue('SPEC2'))) {
										alert("품목명 또는 규격은 필수입력값입니다.");
										return false;
									}
								}
								if(!Ext.isEmpty(orderNoSearch.getValue('SPEC2'))) {
									if(Ext.isEmpty(orderNoSearch.getValue('ITEM_NAME2')) && Ext.isEmpty(orderNoSearch.getValue('STOCK_UNIT2'))) {
										alert("품목명 또는 재고단위는 필수입력값입니다.");
										return false;
									}
								}

							}

								UniAppManager.app.setSearchInfoData();
								SearchInfoWindow.hide();
						},
						disabled: false
					},{
						itemId : 'OrderNoCloseBtn',
						text: '닫기',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {
					beforeshow: function( panel, eOpts )	{
						var record = masterGrid.getSelectedRecord();
						orderNoSearch.setValue('P_REQ_NUM'		,record.data.P_REQ_NUM);
						orderNoSearch.setValue('SER_NO'			,record.data.SER_NO);
						if(Ext.isEmpty(record.data.ITEM_CODE)) {
							orderNoSearch.setValue('NEW_ITEM_FREFIX'	,record.data.NEW_ITEM_FREFIX);
							orderNoSearch.setValue('ITEM_NAME2'		,record.data.ITEM_NAME2);
							orderNoSearch.setValue('SPEC2'			,record.data.SPEC2);
							orderNoSearch.setValue('NEW_CAR_TYPE'	,record.data.NEW_CAR_TYPE);
							orderNoSearch.setValue('CAR_TYPE2'		,record.data.CAR_TYPE2);
							orderNoSearch.setValue('STOCK_UNIT2'		,record.data.STOCK_UNIT2);
						} else {
							orderNoSearch.setValue('NEW_ITEM_FREFIX'	, '');
							orderNoSearch.setValue('ITEM_NAME2'		, '');
							orderNoSearch.setValue('SPEC2'			, '');
							orderNoSearch.setValue('NEW_CAR_TYPE'	, '');
							orderNoSearch.setValue('CAR_TYPE2'		, '');
							orderNoSearch.setValue('STOCK_UNIT2'		, '');
						}
						if(Ext.isEmpty(record.data.CUSTOM_CODE)) {
							orderNoSearch.setValue('CUSTOM_NAME2'	,record.data.CUSTOM_NAME2);
							orderNoSearch.setValue('CUSTOM_FULL_NAME2'  ,record.data.CUSTOM_FULL_NAME2);
						} else {
							orderNoSearch.setValue('CUSTOM_NAME2'	, '');
							orderNoSearch.setValue('CUSTOM_FULL_NAME2'  , '');
						}
						orderNoSearch.setValue('ADD01_CUSTOM_CODE'  ,record.data.ADD01_CUSTOM_CODE);
						orderNoSearch.setValue('ADD02_CUSTOM_CODE'  ,record.data.ADD02_CUSTOM_CODE);
						orderNoSearch.setValue('ADD03_CUSTOM_CODE'  ,record.data.ADD03_CUSTOM_CODE);
						orderNoSearch.setValue('ADD04_CUSTOM_CODE'  ,record.data.ADD04_CUSTOM_CODE);
						orderNoSearch.setValue('ADD05_CUSTOM_CODE'  ,record.data.ADD05_CUSTOM_CODE);
						orderNoSearch.setValue('ADD06_CUSTOM_CODE'  ,record.data.ADD06_CUSTOM_CODE);
						orderNoSearch.setValue('ADD07_CUSTOM_CODE'  ,record.data.ADD07_CUSTOM_CODE);
						orderNoSearch.setValue('ADD08_CUSTOM_CODE'  ,record.data.ADD08_CUSTOM_CODE);
						orderNoSearch.setValue('ADD09_CUSTOM_CODE'  ,record.data.ADD09_CUSTOM_CODE);
						orderNoSearch.setValue('ADD10_CUSTOM_CODE'  ,record.data.ADD10_CUSTOM_CODE);
						orderNoSearch.setValue('ADD11_CUSTOM_CODE'  ,record.data.ADD11_CUSTOM_CODE);
						orderNoSearch.setValue('ADD12_CUSTOM_CODE'  ,record.data.ADD12_CUSTOM_CODE);
						orderNoSearch.setValue('ADD13_CUSTOM_CODE'  ,record.data.ADD13_CUSTOM_CODE);
						orderNoSearch.setValue('ADD14_CUSTOM_CODE'  ,record.data.ADD14_CUSTOM_CODE);
						orderNoSearch.setValue('ADD15_CUSTOM_CODE'  ,record.data.ADD15_CUSTOM_CODE);
						orderNoSearch.setValue('ADD16_CUSTOM_CODE'  ,record.data.ADD16_CUSTOM_CODE);
						orderNoSearch.setValue('ADD17_CUSTOM_CODE'  ,record.data.ADD17_CUSTOM_CODE);
						orderNoSearch.setValue('ADD18_CUSTOM_CODE'  ,record.data.ADD18_CUSTOM_CODE);
						orderNoSearch.setValue('ADD19_CUSTOM_CODE'  ,record.data.ADD19_CUSTOM_CODE);
						orderNoSearch.setValue('ADD20_CUSTOM_CODE'  ,record.data.ADD20_CUSTOM_CODE);
						orderNoSearch.setValue('ADD21_CUSTOM_CODE'  ,record.data.ADD20_CUSTOM_CODE);
						orderNoSearch.setValue('ADD22_CUSTOM_CODE'  ,record.data.ADD20_CUSTOM_CODE);
						orderNoSearch.setValue('CUSTOM_NAME01'	,record.data.ADD01_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME02'	,record.data.ADD02_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME03'	,record.data.ADD03_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME04'	,record.data.ADD04_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME05'	,record.data.ADD05_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME06'	,record.data.ADD06_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME07'	,record.data.ADD07_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME08'	,record.data.ADD08_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME09'	,record.data.ADD09_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME10'	,record.data.ADD10_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME11'	,record.data.ADD11_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME12'	,record.data.ADD12_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME13'	,record.data.ADD13_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME14'	,record.data.ADD14_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME15'	,record.data.ADD15_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME16'	,record.data.ADD16_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME17'	,record.data.ADD17_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME18'	,record.data.ADD18_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME19'	,record.data.ADD19_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME20'	,record.data.ADD20_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME21'	,record.data.ADD21_CUSTOM_NAME);
						orderNoSearch.setValue('CUSTOM_NAME22'	,record.data.ADD21_CUSTOM_NAME);
						if(Ext.isEmpty(record.data.ITEM_CODE)) {
							orderNoSearch.getField('NEW_ITEM_FREFIX').setReadOnly(false);
							orderNoSearch.getField('ITEM_NAME2').setReadOnly(false);
							orderNoSearch.getField('SPEC2').setReadOnly(false);
							orderNoSearch.getField('NEW_CAR_TYPE').setReadOnly(false);
							orderNoSearch.getField('CAR_TYPE2').setReadOnly(false);
							orderNoSearch.getField('STOCK_UNIT2').setReadOnly(false);
						} else if(!Ext.isEmpty(record.data.ITEM_CODE)) {
							orderNoSearch.getField('NEW_ITEM_FREFIX').setReadOnly(true);
							orderNoSearch.getField('ITEM_NAME2').setReadOnly(true);
							orderNoSearch.getField('SPEC2').setReadOnly(true);
							orderNoSearch.getField('NEW_CAR_TYPE').setReadOnly(true);
							orderNoSearch.getField('CAR_TYPE2').setReadOnly(true);
							orderNoSearch.getField('STOCK_UNIT2').setReadOnly(true);
						}
						if(!Ext.isEmpty(record.data.CUSTOM_CODE)) {
							orderNoSearch.getField('CUSTOM_NAME2').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_FULL_NAME2').setReadOnly(true);
						} else if(Ext.isEmpty(record.data.CUSTOM_CODE)) {
							orderNoSearch.getField('CUSTOM_NAME2').setReadOnly(false);
							orderNoSearch.getField('CUSTOM_FULL_NAME2').setReadOnly(false);
						}
						if(record.data.CONFIRM_YN == 'Y') {
							orderNoSearch.getField('ADD01_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD02_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD03_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD04_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD05_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD06_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD07_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD08_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD09_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD10_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD11_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD12_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD13_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD14_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD15_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD16_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD17_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD18_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD19_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD20_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD21_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('ADD22_CUSTOM_CODE').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME01').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME02').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME03').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME04').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME05').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME06').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME07').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME08').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME09').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME10').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME11').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME12').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME13').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME14').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME15').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME16').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME17').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME18').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME19').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME20').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME21').setReadOnly(true);
							orderNoSearch.getField('CUSTOM_NAME22').setReadOnly(true);
						} else {
							orderNoSearch.getField('ADD01_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD02_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD03_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD04_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD05_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD06_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD07_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD08_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD09_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD10_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD11_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD12_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD13_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD14_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD15_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD16_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD17_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD18_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD19_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD20_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD21_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('ADD22_CUSTOM_CODE').setReadOnly(false);
							orderNoSearch.getField('CUSTOM_NAME01').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME02').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME03').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME04').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME05').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME06').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME07').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME08').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME09').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME10').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME11').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME12').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME13').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME14').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME15').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME16').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME17').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME18').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME19').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME20').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME21').setDisabled(true);
							orderNoSearch.getField('CUSTOM_NAME22').setDisabled(true);
						}
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	Unilite.Main( {
			borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					masterGrid, panelResult
				]
			}
		],
		id: 's_bco100ukrv_kdApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['newData', 'prev', 'next'], true);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('TYPE', '1');
			panelResult.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
			panelResult.setValue('P_REQ_DATE', UniDate.get('today'));
			panelResult.setValue('APLY_START_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('P_REQ_DATE', UniDate.get('today'));
			panelResult.setValue('APLY_START_DATE', UniDate.get('startOfMonth'));
			Ext.getCmp('INFO_BTN').setDisabled(true);
			Ext.getCmp('GW').setDisabled(true);
			var rtnData = typeChk("");
			var defaultValue1 = rtnData[1];
			panelResult.setValue('P_REQ_TYPE', defaultValue1);

		},
		onQueryButtonDown: function() {
			panelResult.setValue('GW_TEMP', '');
			var pReqNum = panelResult.getValue('P_REQ_NUM');
			if(Ext.isEmpty(pReqNum)) {
				openSearchPreqNumWindow()
			} else {
				var param= panelResult.getValues();
				directMasterStore1.loadStoreRecords();
				UniAppManager.setToolbarButtons(['reset','newData'], true);
				Ext.getCmp('INFO_BTN').setDisabled(false);
			}
		},
		setDefault: function() {		// 기본값
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('TYPE', '1');
			panelResult.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
			panelResult.setValue('P_REQ_DATE', UniDate.get('today'));
			panelResult.setValue('APLY_START_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('P_REQ_DATE', UniDate.get('today'));
			panelResult.setValue('APLY_START_DATE', UniDate.get('startOfMonth'));
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onResetButtonDown: function() {	// 초기화
			this.suspendEvents();
			masterGrid.reset();
			panelResult.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelResult.setValue('P_REQ_NUM', '');
			panelResult.setValue('P_REQ_NUM', '');
			Ext.getCmp('INFO_BTN').setDisabled(true);
			Ext.getCmp('GW').setDisabled(true);
			UniAppManager.setToolbarButtons(['save'],false);
			UniAppManager.setToolbarButtons(['newData', 'prev', 'next'], true);
			directMasterStore1.clearData();
		},
		onNewDataButtonDown: function(flag, record) {	// 행추가
//			var record = masterGrid.getSelectedRecord();
//			if(record.get('PRINT_YN') == 'Y' || record.get('CONFIRM_YN') == 'Y' || record.get('RENEWAL_YN') == 'Y') {
//				alert('출력, 확정, 갱신된 데이터는 추가가 불가능합니다.');
//			} else {
			var param = panelResult.getValues();
			s_bco100ukrv_kdService.selectGwData(param, function(provider, response) {
				if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
					if(panelResult.setAllFieldsReadOnly(true) == false){
						return false;
					}
					var pReqNum			= panelResult.getValue('P_REQ_NUM');
					var serNo			= directMasterStore1.max('SER_NO');
						if(!serNo) serNo	= 1;
						else serNo			+= 1;
					var compCode		= UserInfo.compCode;
					var divCode			= panelResult.getValue('DIV_CODE');
					var treeCode		= panelResult.getValue('TREE_CODE');
					var treeName		= panelResult.getValue('TREE_NAME');
					var personNumb		= panelResult.getValue('PERSON_NUMB');
					var personName		= panelResult.getValue('PERSON_NAME');
					var type			= panelResult.getValue('TYPE');
					var moneyUnit		= panelResult.getValue('MONEY_UNIT');
					var pReqDate		= panelResult.getValue('P_REQ_DATE');
					var aplyStartDate	= panelResult.getValue('APLY_START_DATE');
					var gwFlag			= 'N';
					var customCode		= '';
					var itemCode		= '';
					if(panelResult.getValue('TYPE') == '1') {
						var priceType		= 'Y';
					} else {
						var priceType		= '2';
					}
					var nsFlag			= '1';
					var orderUnit		= '';
					var itemP			= '0';
					var packItemP		= '0';
					var preItemP		= '0';
					var hsCode			= '';
					var payTerms		= '';
					var termsPrice		= '';
					var deliveryMeth	= '';
					var chReason		= '';
					var oemYn			= 'N';
					var n12199Yn		= 'N';
					var n13199Yn		= 'N';
					var n14199Yn		= 'N';
					var n13301Yn		= 'N';
					var spec			= '';
					var carType			= '';
					var stockUnit		= '';
					var customFullName	= '';
					var add01CustomCode	= '';
					var add02CustomCode	= '';
					var add03CustomCode	= '';
					var add04CustomCode	= '';
					var add05CustomCode	= '';
					var add06CustomCode	= '';
					var add07CustomCode	= '';
					var add08CustomCode	= '';
					var add09CustomCode	= '';
					var add10CustomCode	= '';
					var add11CustomCode	= '';
					var add12CustomCode	= '';
					var add13CustomCode	= '';
					var add14CustomCode	= '';
					var add15CustomCode	= '';
					var add16CustomCode	= '';
					var add17CustomCode	= '';
					var add18CustomCode	= '';
					var add19CustomCode	= '';
					var add20CustomCode	= '';
					var add21CustomCode	= '';
					var add22CustomCode	= '';
					var remark			= '';
					var confirmYn		= 'N';
					var renewalYn		= 'N';
					var pReqType		= panelResult.getValue('P_REQ_TYPE');

					var r = {
						'P_REQ_NUM'				: pReqNum,
						'SER_NO'				: serNo,
						'COMP_CODE'				: compCode,
						'DIV_CODE'				: divCode,
						'TREE_CODE'				: treeCode,
						'TREE_NAME'				: treeName,
						'PERSON_NUMB'			: personNumb,
						'PERSON_NAME'			: personName,
						'TYPE'					: type,
						'MONEY_UNIT'			: moneyUnit,
						'P_REQ_DATE'			: pReqDate,
						'APLY_START_DATE'		: aplyStartDate,
						'GW_FLAG'				: gwFlag,
						'CUSTOM_CODE'			: customCode,
						'ITEM_CODE'				: itemCode,
						'PRICE_TYPE'			: priceType,
						'NS_FLAG'				: nsFlag,
						'ORDER_UNIT'			: orderUnit,
						'ITEM_P'				: itemP,
						'PACK_ITEM_P'			: packItemP,
						'PRE_ITEM_P'			: preItemP,
						'HS_CODE'				: hsCode,
						'PAY_TERMS'				: payTerms,
						'TERMS_PRICE'			: termsPrice,
						'DELIVERY_METH'			: deliveryMeth,
						'CH_REASON'				: chReason,
						'OEM_YN'				: oemYn,
						'12199_YN'				: n12199Yn,
						'13199_YN'				: n13199Yn,
						'14199_YN'				: n14199Yn,
						'13301_YN'				: n13301Yn,
						'SPEC'					: spec,
						'CAR_TYPE'				: carType,
						'STOCK_UNIT'			: stockUnit,
						'CUSTOM_FULL_NAME'		: customFullName,
						'ADD01_CUSTOM_CODE'		: add01CustomCode,
						'ADD02_CUSTOM_CODE'		: add02CustomCode,
						'ADD03_CUSTOM_CODE'		: add03CustomCode,
						'ADD04_CUSTOM_CODE'		: add04CustomCode,
						'ADD05_CUSTOM_CODE'		: add05CustomCode,
						'ADD06_CUSTOM_CODE'		: add06CustomCode,
						'ADD07_CUSTOM_CODE'		: add07CustomCode,
						'ADD08_CUSTOM_CODE'		: add08CustomCode,
						'ADD09_CUSTOM_CODE'		: add09CustomCode,
						'ADD10_CUSTOM_CODE'		: add10CustomCode,
						'ADD11_CUSTOM_CODE'		: add11CustomCode,
						'ADD12_CUSTOM_CODE'		: add12CustomCode,
						'ADD13_CUSTOM_CODE'		: add13CustomCode,
						'ADD14_CUSTOM_CODE'		: add14CustomCode,
						'ADD15_CUSTOM_CODE'		: add15CustomCode,
						'ADD16_CUSTOM_CODE'		: add16CustomCode,
						'ADD17_CUSTOM_CODE'		: add17CustomCode,
						'ADD18_CUSTOM_CODE'		: add18CustomCode,
						'ADD19_CUSTOM_CODE'		: add19CustomCode,
						'ADD20_CUSTOM_CODE'		: add20CustomCode,
						'ADD21_CUSTOM_CODE'		: add21CustomCode,
						'ADD22_CUSTOM_CODE'		: add22CustomCode,
						'REMARK'				: remark,
						'CONFIRM_YN'			: confirmYn,
						'RENEWAL_YN'			: renewalYn,
						'P_REQ_TYPE'			: pReqType,
						'FLAG'					: "N"
					};
					masterGrid.createRow(r);
					UniAppManager.setToolbarButtons(['reset'], true);
					Ext.getCmp('INFO_BTN').setDisabled(false);
					if(flag == 'Y'){
						masterGrid.setCopyData(record.data);
					}
				} else {
					alert('이미 기안된 자료입니다.');
					return false;
				}
			});
//			}
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			var pReqNum = panelResult.getValue('P_REQ_NUM');
			var pReqType = panelResult.getValue('P_REQ_TYPE');
			if(Ext.isEmpty(pReqType)){
				alert("의뢰서 구분을 선택해주세요.");
				return false;
			}
			if(Ext.isEmpty(pReqNum)) {
				var param = panelResult.getValues();
				s_bco100ukrv_kdService.selectMasterCheck(param, function(provider, response) {
					console.log("dataCheckSave", response);
					if(Ext.isEmpty(provider)) {
						directMasterStore1.saveStore();
					} else {
						alert("중복된 의뢰번호가 입력되었습니다.");
						return false;
					}
				});
			} else {
				directMasterStore1.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var param = panelResult.getValues();
			if(!Ext.isEmpty(param.REQSTOCK_NUM)) {
				s_bco100ukrv_kdService.selectGwData(param, function(provider, response) {
					if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
						var record = masterGrid.getSelectedRecord();
						if(record.get('GW_FLAG') == 'Y') {
							alert('기안된 데이터는 삭제가 불가능합니다.');
							return false;
						} else {
							if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
								masterGrid.deleteSelectedRow();
								var count = masterGrid.getStore().getCount();
								if(count > 0) {
									panelResult.setAllFieldsReadOnly(true);
								} else {
									panelResult.setAllFieldsReadOnly(false);
								}
							}
						}
					} else {
						alert('기안된 데이터는 삭제가 불가능합니다.');
						return false;
					}
				})
			} else {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
					var count = masterGrid.getStore().getCount();
					if(count > 0) {
						panelResult.setAllFieldsReadOnly(true);
					} else {
						panelResult.setAllFieldsReadOnly(false);
					}
				}
			}
		},
		setSearchInfoData: function(record, dataClear) {
			var record = masterGrid.getSelectedRecord();
//			record.set('P_REQ_NUM'				,record.get('P_REQ_NUM'));
//			record.set('SER_NO'					,record.get('SER_NO'));
			if(Ext.isEmpty(record.get('ITEM_CODE'))) {
				record.set('NEW_ITEM_FREFIX'		,orderNoSearch.getValue('NEW_ITEM_FREFIX'));
				record.set('ITEM_NAME'				,orderNoSearch.getValue('ITEM_NAME2'));
				record.set('ITEM_NAME2'				,orderNoSearch.getValue('ITEM_NAME2'));
				record.set('SPEC'					,orderNoSearch.getValue('SPEC2'));
				record.set('SPEC2'					,orderNoSearch.getValue('SPEC2'));
				record.set('NEW_CAR_TYPE'			,orderNoSearch.getValue('NEW_CAR_TYPE'));
				record.set('CAR_TYPE'				,orderNoSearch.getValue('CAR_TYPE2'));
				record.set('CAR_TYPE2'				,orderNoSearch.getValue('CAR_TYPE2'));
				record.set('ORDER_UNIT'				,orderNoSearch.getValue('STOCK_UNIT2'));
				record.set('STOCK_UNIT'				,orderNoSearch.getValue('STOCK_UNIT2'));
				record.set('STOCK_UNIT2'			,orderNoSearch.getValue('STOCK_UNIT2'));
			}
			if(Ext.isEmpty(record.get('CUSTOM_CODE'))) {
				record.set('CUSTOM_NAME'			,orderNoSearch.getValue('CUSTOM_NAME2'));
				record.set('CUSTOM_NAME2'			,orderNoSearch.getValue('CUSTOM_NAME2'));
				record.set('CUSTOM_FULL_NAME'		,orderNoSearch.getValue('CUSTOM_FULL_NAME2'));
				record.set('CUSTOM_FULL_NAME2'		,orderNoSearch.getValue('CUSTOM_FULL_NAME2'));
			}
			record.set('ADD01_CUSTOM_CODE'		,orderNoSearch.getValue('ADD01_CUSTOM_CODE'));
			record.set('ADD02_CUSTOM_CODE'		,orderNoSearch.getValue('ADD02_CUSTOM_CODE'));
			record.set('ADD03_CUSTOM_CODE'		,orderNoSearch.getValue('ADD03_CUSTOM_CODE'));
			record.set('ADD04_CUSTOM_CODE'		,orderNoSearch.getValue('ADD04_CUSTOM_CODE'));
			record.set('ADD05_CUSTOM_CODE'		,orderNoSearch.getValue('ADD05_CUSTOM_CODE'));
			record.set('ADD06_CUSTOM_CODE'		,orderNoSearch.getValue('ADD06_CUSTOM_CODE'));
			record.set('ADD07_CUSTOM_CODE'		,orderNoSearch.getValue('ADD07_CUSTOM_CODE'));
			record.set('ADD08_CUSTOM_CODE'		,orderNoSearch.getValue('ADD08_CUSTOM_CODE'));
			record.set('ADD09_CUSTOM_CODE'		,orderNoSearch.getValue('ADD09_CUSTOM_CODE'));
			record.set('ADD10_CUSTOM_CODE'		,orderNoSearch.getValue('ADD10_CUSTOM_CODE'));
			record.set('ADD11_CUSTOM_CODE'		,orderNoSearch.getValue('ADD11_CUSTOM_CODE'));
			record.set('ADD12_CUSTOM_CODE'		,orderNoSearch.getValue('ADD12_CUSTOM_CODE'));
			record.set('ADD13_CUSTOM_CODE'		,orderNoSearch.getValue('ADD13_CUSTOM_CODE'));
			record.set('ADD14_CUSTOM_CODE'		,orderNoSearch.getValue('ADD14_CUSTOM_CODE'));
			record.set('ADD15_CUSTOM_CODE'		,orderNoSearch.getValue('ADD15_CUSTOM_CODE'));
			record.set('ADD16_CUSTOM_CODE'		,orderNoSearch.getValue('ADD16_CUSTOM_CODE'));
			record.set('ADD17_CUSTOM_CODE'		,orderNoSearch.getValue('ADD17_CUSTOM_CODE'));
			record.set('ADD18_CUSTOM_CODE'		,orderNoSearch.getValue('ADD18_CUSTOM_CODE'));
			record.set('ADD19_CUSTOM_CODE'		,orderNoSearch.getValue('ADD19_CUSTOM_CODE'));
			record.set('ADD20_CUSTOM_CODE'		,orderNoSearch.getValue('ADD20_CUSTOM_CODE'));
			record.set('ADD21_CUSTOM_CODE'		,orderNoSearch.getValue('ADD21_CUSTOM_CODE'));
			record.set('ADD22_CUSTOM_CODE'		,orderNoSearch.getValue('ADD22_CUSTOM_CODE'));
			record.set('ADD01_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME01'));
			record.set('ADD02_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME02'));
			record.set('ADD03_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME03'));
			record.set('ADD04_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME04'));
			record.set('ADD05_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME05'));
			record.set('ADD06_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME06'));
			record.set('ADD07_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME07'));
			record.set('ADD08_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME08'));
			record.set('ADD09_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME09'));
			record.set('ADD10_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME10'));
			record.set('ADD11_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME11'));
			record.set('ADD12_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME12'));
			record.set('ADD13_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME13'));
			record.set('ADD14_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME14'));
			record.set('ADD15_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME15'));
			record.set('ADD16_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME16'));
			record.set('ADD17_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME17'));
			record.set('ADD18_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME18'));
			record.set('ADD19_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME19'));
			record.set('ADD20_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME20'));
			record.set('ADD21_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME21'));
			record.set('ADD22_CUSTOM_NAME'		,orderNoSearch.getValue('CUSTOM_NAME22'));
		},
		requestApprove: function(){	//결재 요청
			//var gsWin = window.open('about:blank','payviewer','width=500,height=500');

			var frm		= document.f1;
			var compCode	= UserInfo.compCode;
			var divCode	= panelResult.getValue('DIV_CODE');
			var pReqNum	= panelResult.getValue('P_REQ_NUM');
			var spText	= 'EXEC omegaplus_kdg.unilite.USP_GW_BCO100T01 ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + pReqNum + "'";
			var spCall	= encodeURIComponent(spText);
			console.log(spText);
//			frm.action = '/payment/payreq.php';
			//frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_bco100ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('P_REQ_NUM') + "&sp=" + spCall/* + Base64.encode()*/;
			//frm.target   = "payviewer";
			//frm.method   = "post";
			//frm.submit();

			/*20180517 추가 start*/
			var gwurl = groupUrl  + "viewMode=docuDraft" + "&prg_no=s_bco100ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('P_REQ_NUM') + "&sp=" + spCall/* + Base64.encode()*/;
			console.log(gwurl);
			UniBase.fnGw_Call(gwurl,frm,'GW');
			/*end*/
		},
		//20191219 기존의뢰서복사 데이터 적용 방식 변경: store에 직접 load하는 방식으로 변경
		fnMakeMainData: function(records){
			//Detail Grid Default 값 설정
			var param = panelResult.getValues();
			var newDetailRecords = new Array();
			s_bco100ukrv_kdService.selectGwData(param, function(provider, response) {
				if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
					if(panelResult.setAllFieldsReadOnly(true) == false){
						return false;
					}
					var pReqNum			= panelResult.getValue('P_REQ_NUM');
					var serNo			= directMasterStore1.max('SER_NO');
						if(!serNo) serNo	= 1;
						else serNo			+= 1;
					var compCode		= UserInfo.compCode;
					var divCode			= panelResult.getValue('DIV_CODE');
					var treeCode		= panelResult.getValue('TREE_CODE');
					var treeName		= panelResult.getValue('TREE_NAME');
					var personNumb		= panelResult.getValue('PERSON_NUMB');
					var personName		= panelResult.getValue('PERSON_NAME');
					var type			= panelResult.getValue('TYPE');
					var moneyUnit		= panelResult.getValue('MONEY_UNIT');
					var pReqDate		= panelResult.getValue('P_REQ_DATE');
					var aplyStartDate	= panelResult.getValue('APLY_START_DATE');
					var gwFlag			= 'N';
					var customCode		= '';
					var itemCode		= '';
					if(panelResult.getValue('TYPE') == '1') {
						var priceType		= 'Y';
					} else {
						var priceType		= '2';
					}
					var nsFlag			= '1';
					var orderUnit		= '';
					var itemP			= '0';
					var packItemP		= '0';
					var preItemP		= '0';
					var hsCode			= '';
					var payTerms		= '';
					var termsPrice		= '';
					var deliveryMeth	= '';
					var chReason		= '';
					var oemYn			= 'N';
					var n12199Yn		= 'N';
					var n13199Yn		= 'N';
					var n14199Yn		= 'N';
					var n13301Yn		= 'N';
					var spec			= '';
					var carType			= '';
					var stockUnit		= '';
					var customFullName	= '';
					var add01CustomCode	= '';
					var add02CustomCode	= '';
					var add03CustomCode	= '';
					var add04CustomCode	= '';
					var add05CustomCode	= '';
					var add06CustomCode	= '';
					var add07CustomCode	= '';
					var add08CustomCode	= '';
					var add09CustomCode	= '';
					var add10CustomCode	= '';
					var add11CustomCode	= '';
					var add12CustomCode	= '';
					var add13CustomCode	= '';
					var add14CustomCode	= '';
					var add15CustomCode	= '';
					var add16CustomCode	= '';
					var add17CustomCode	= '';
					var add18CustomCode	= '';
					var add19CustomCode	= '';
					var add20CustomCode	= '';
					var add21CustomCode	= '';
					var add22CustomCode	= '';
					var remark			= '';
					var confirmYn		= 'N';
					var renewalYn		= 'N';
					var pReqType		= panelResult.getValue('P_REQ_TYPE');

					Ext.each(records, function(record,i){
						if(i == 0){
							serNo = serNo;
						} else {
							serNo += 1;
						}
						var r = {
							'P_REQ_NUM'				: pReqNum,
							'SER_NO'				: serNo,
							'COMP_CODE'				: compCode,
							'DIV_CODE'				: divCode,
							'TREE_CODE'				: treeCode,
							'TREE_NAME'				: treeName,
							'PERSON_NUMB'			: personNumb,
							'PERSON_NAME'			: personName,
							'TYPE'					: type,
							'MONEY_UNIT'			: moneyUnit,
							'P_REQ_DATE'			: pReqDate,
							'APLY_START_DATE'		: aplyStartDate,
							'GW_FLAG'				: gwFlag,
							'CUSTOM_CODE'			: customCode,
							'ITEM_CODE'				: itemCode,
							'PRICE_TYPE'			: priceType,
							'NS_FLAG'				: nsFlag,
							'ORDER_UNIT'			: orderUnit,
							'ITEM_P'				: itemP,
							'PACK_ITEM_P'			: packItemP,
							'PRE_ITEM_P'			: preItemP,
							'HS_CODE'				: hsCode,
							'PAY_TERMS'				: payTerms,
							'TERMS_PRICE'			: termsPrice,
							'DELIVERY_METH'			: deliveryMeth,
							'CH_REASON'				: chReason,
							'OEM_YN'				: oemYn,
							'12199_YN'				: n12199Yn,
							'13199_YN'				: n13199Yn,
							'14199_YN'				: n14199Yn,
							'13301_YN'				: n13301Yn,
							'SPEC'					: spec,
							'CAR_TYPE'				: carType,
							'STOCK_UNIT'			: stockUnit,
							'CUSTOM_FULL_NAME'		: customFullName,
							'ADD01_CUSTOM_CODE'		: add01CustomCode,
							'ADD02_CUSTOM_CODE'		: add02CustomCode,
							'ADD03_CUSTOM_CODE'		: add03CustomCode,
							'ADD04_CUSTOM_CODE'		: add04CustomCode,
							'ADD05_CUSTOM_CODE'		: add05CustomCode,
							'ADD06_CUSTOM_CODE'		: add06CustomCode,
							'ADD07_CUSTOM_CODE'		: add07CustomCode,
							'ADD08_CUSTOM_CODE'		: add08CustomCode,
							'ADD09_CUSTOM_CODE'		: add09CustomCode,
							'ADD10_CUSTOM_CODE'		: add10CustomCode,
							'ADD11_CUSTOM_CODE'		: add11CustomCode,
							'ADD12_CUSTOM_CODE'		: add12CustomCode,
							'ADD13_CUSTOM_CODE'		: add13CustomCode,
							'ADD14_CUSTOM_CODE'		: add14CustomCode,
							'ADD15_CUSTOM_CODE'		: add15CustomCode,
							'ADD16_CUSTOM_CODE'		: add16CustomCode,
							'ADD17_CUSTOM_CODE'		: add17CustomCode,
							'ADD18_CUSTOM_CODE'		: add18CustomCode,
							'ADD19_CUSTOM_CODE'		: add19CustomCode,
							'ADD20_CUSTOM_CODE'		: add20CustomCode,
							'ADD21_CUSTOM_CODE'		: add21CustomCode,
							'ADD22_CUSTOM_CODE'		: add22CustomCode,
							'REMARK'				: remark,
							'CONFIRM_YN'			: confirmYn,
							'RENEWAL_YN'			: renewalYn,
							'P_REQ_TYPE'			: pReqType,
							'FLAG'					: "N"
						};
						newDetailRecords[i] = directMasterStore1.model.create( r );

						newDetailRecords[i].set('SER_NO'				, record.get('SER_NO'));
						newDetailRecords[i].set('COMP_CODE'				, UserInfo.compCode);
						newDetailRecords[i].set('DIV_CODE'				, panelResult.getValue('DIV_CODE'));
						newDetailRecords[i].set('TREE_CODE'				, panelResult.getValue('TREE_CODE'));
						newDetailRecords[i].set('TREE_NAME'				, panelResult.getValue('TREE_NAME'));
						newDetailRecords[i].set('PERSON_NUMB'			, panelResult.getValue('PERSON_NUMB'));
						newDetailRecords[i].set('PERSON_NAME'			, panelResult.getValue('PERSON_NAME'));
						newDetailRecords[i].set('TYPE'					, record.get('TYPE'));
						newDetailRecords[i].set('MONEY_UNIT'			, record.get('MONEY_UNIT'));
						newDetailRecords[i].set('P_REQ_DATE'			, panelResult.getValue('P_REQ_DATE'));
						newDetailRecords[i].set('APLY_START_DATE'		, panelResult.getValue('APLY_START_DATE'));
						newDetailRecords[i].set('GW_FLAG'				, 'N');
						newDetailRecords[i].set('CUSTOM_CODE'			, record.get('CUSTOM_CODE'));
						newDetailRecords[i].set('CUSTOM_NAME'			, record.get('CUSTOM_NAME'));
						newDetailRecords[i].set('MAKER_CODE'			, record.get('MAKER_CODE'));
						newDetailRecords[i].set('MAKER_NAME'			, record.get('MAKER_NAME'));
						newDetailRecords[i].set('NEW_ITEM_FREFIX'		, record.get('NEW_ITEM_FREFIX'));
						newDetailRecords[i].set('ITEM_CODE'				, record.get('ITEM_CODE'));
						newDetailRecords[i].set('ITEM_NAME'				, record.get('ITEM_NAME'));
						newDetailRecords[i].set('PRICE_TYPE'			, record.get('PRICE_TYPE'));
						newDetailRecords[i].set('ORDER_UNIT'			, record.get('ORDER_UNIT'));
						newDetailRecords[i].set('ITEM_P'				, record.get('ITEM_P'));
						newDetailRecords[i].set('PACK_ITEM_P'			, record.get('PACK_ITEM_P'));
						newDetailRecords[i].set('PRE_ITEM_P'			, record.get('PRE_ITEM_P'));
						newDetailRecords[i].set('HS_CODE'				, record.get('HS_CODE'));
						newDetailRecords[i].set('HS_NAME'				, record.get('HS_NAME'));
						newDetailRecords[i].set('PAY_TERMS'				, record.get('PAY_TERMS'));
						newDetailRecords[i].set('TERMS_PRICE'			, record.get('TERMS_PRICE'));
						newDetailRecords[i].set('DELIVERY_METH'			, record.get('DELIVERY_METH'));
						newDetailRecords[i].set('CH_REASON'				, record.get('CH_REASON'));
						newDetailRecords[i].set('OEM_YN'				, record.get('OEM_YN'));
						newDetailRecords[i].set('12199_YN'				, record.get('12199_YN'));
						newDetailRecords[i].set('13199_YN'				, record.get('13199_YN'));
						newDetailRecords[i].set('14199_YN'				, record.get('14199_YN'));
						newDetailRecords[i].set('13301_YN'				, record.get('13301_YN'));
						newDetailRecords[i].set('SPEC'					, record.get('SPEC'));
						newDetailRecords[i].set('CAR_TYPE'				, record.get('CAR_TYPE'));
						newDetailRecords[i].set('STOCK_UNIT'			, record.get('STOCK_UNIT'));
						newDetailRecords[i].set('CUSTOM_FULL_NAME'		, record.get('CUSTOM_FULL_NAME'));
						newDetailRecords[i].set('ADD01_CUSTOM_CODE'		, record.get('ADD01_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD02_CUSTOM_CODE'		, record.get('ADD02_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD03_CUSTOM_CODE'		, record.get('ADD03_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD04_CUSTOM_CODE'		, record.get('ADD04_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD05_CUSTOM_CODE'		, record.get('ADD05_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD06_CUSTOM_CODE'		, record.get('ADD06_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD07_CUSTOM_CODE'		, record.get('ADD07_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD08_CUSTOM_CODE'		, record.get('ADD08_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD09_CUSTOM_CODE'		, record.get('ADD09_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD10_CUSTOM_CODE'		, record.get('ADD10_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD11_CUSTOM_CODE'		, record.get('ADD11_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD12_CUSTOM_CODE'		, record.get('ADD12_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD13_CUSTOM_CODE'		, record.get('ADD13_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD14_CUSTOM_CODE'		, record.get('ADD14_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD15_CUSTOM_CODE'		, record.get('ADD15_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD16_CUSTOM_CODE'		, record.get('ADD16_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD17_CUSTOM_CODE'		, record.get('ADD17_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD18_CUSTOM_CODE'		, record.get('ADD18_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD19_CUSTOM_CODE'		, record.get('ADD19_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD20_CUSTOM_CODE'		, record.get('ADD20_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD21_CUSTOM_CODE'		, record.get('ADD21_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD22_CUSTOM_CODE'		, record.get('ADD22_CUSTOM_CODE'));
						newDetailRecords[i].set('ADD01_CUSTOM_NAME'		, record.get('ADD01_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD02_CUSTOM_NAME'		, record.get('ADD02_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD03_CUSTOM_NAME'		, record.get('ADD03_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD04_CUSTOM_NAME'		, record.get('ADD04_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD05_CUSTOM_NAME'		, record.get('ADD05_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD06_CUSTOM_NAME'		, record.get('ADD06_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD07_CUSTOM_NAME'		, record.get('ADD07_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD08_CUSTOM_NAME'		, record.get('ADD08_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD09_CUSTOM_NAME'		, record.get('ADD09_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD10_CUSTOM_NAME'		, record.get('ADD10_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD11_CUSTOM_NAME'		, record.get('ADD11_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD12_CUSTOM_NAME'		, record.get('ADD12_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD13_CUSTOM_NAME'		, record.get('ADD13_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD14_CUSTOM_NAME'		, record.get('ADD14_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD15_CUSTOM_NAME'		, record.get('ADD15_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD16_CUSTOM_NAME'		, record.get('ADD16_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD17_CUSTOM_NAME'		, record.get('ADD17_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD18_CUSTOM_NAME'		, record.get('ADD18_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD19_CUSTOM_NAME'		, record.get('ADD19_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD20_CUSTOM_NAME'		, record.get('ADD20_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD21_CUSTOM_NAME'		, record.get('ADD21_CUSTOM_NAME'));
						newDetailRecords[i].set('ADD22_CUSTOM_NAME'		, record.get('ADD22_CUSTOM_NAME'));
						newDetailRecords[i].set('REMARK'				, record.get('REMARK'));
						newDetailRecords[i].set('CONFIRM_YN'			, 'N');
						newDetailRecords[i].set('RENEWAL_YN'			, 'N');
						newDetailRecords[i].set('INSERT_DB_USER'		, record.get('INSERT_DB_USER'));
						newDetailRecords[i].set('INSERT_DB_TIME'		, record.get('INSERT_DB_TIME'));
						newDetailRecords[i].set('UPDATE_DB_USER'		, record.get('UPDATE_DB_USER'));
						newDetailRecords[i].set('UPDATE_DB_TIME'		, record.get('UPDATE_DB_TIME'));
						newDetailRecords[i].set('TEMPC_01'				, record.get('TEMPC_01'));
						newDetailRecords[i].set('TEMPC_02'				, record.get('TEMPC_02'));
						newDetailRecords[i].set('TEMPC_03'				, record.get('TEMPC_03'));
						newDetailRecords[i].set('TEMPN_01'				, record.get('TEMPN_01'));
						newDetailRecords[i].set('TEMPN_02'				, record.get('TEMPN_02'));
						newDetailRecords[i].set('TEMPN_03'				, record.get('TEMPN_03'));
						newDetailRecords[i].set('OEM_APLY_YN'			, record.get('OEM_APLY_YN'));
						newDetailRecords[i].set('ITEM_NAME2'			, record.get('ITEM_NAME2'));
						newDetailRecords[i].set('SPEC2'					, record.get('SPEC2'));
						newDetailRecords[i].set('CAR_TYPE2'				, record.get('CAR_TYPE2'));
						newDetailRecords[i].set('NEW_CAR_TYPE'			, record.get('NEW_CAR_TYPE'));
						newDetailRecords[i].set('STOCK_UNIT2'			, record.get('STOCK_UNIT2'));
						newDetailRecords[i].set('CUSTOM_NAME2'			, record.get('CUSTOM_NAME2'));
						newDetailRecords[i].set('CUSTOM_FULL_NAME2'		, record.get('CUSTOM_FULL_NAME2'));
						//20191219 mainGrid에 적용된 데이터는 기존단가의뢰번호검색 팝업에서 삭제하기 위해 컬럼 추가
						newDetailRecords[i].set('REF_P_REQ_NUM'			, record.get('P_REQ_NUM'));
						newDetailRecords[i].set('REF_SER_NO'			, record.get('SER_NO'));
						//20191216 로직 추가: 품목코드가 없을 경우 - 종전단가사용옵션 체크햐여 로직 수행
						if(Ext.isEmpty(record.get('ITEM_CODE'))) {
							if(record.get('USE_YN') == 'Y') {
								newDetailRecords[i].set('PRE_ITEM_P'	, record.get('ITEM_P'));
								newDetailRecords[i].set('ITEM_P'		, record.get('ITEM_P') + record.get('DIFFERENCE_AMT'));
							} else {
								newDetailRecords[i].set('PRE_ITEM_P'	, 0);
								newDetailRecords[i].set('ITEM_P'		, 0);
							}
							//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0 
							if(newDetailRecords[i].get('PRE_ITEM_P') == 0) {
								newDetailRecords[i].set('DIFFER_UNIT_P'	, 0);
							} else {
								newDetailRecords[i].set('DIFFER_UNIT_P'	, newDetailRecords[i].get('ITEM_P') - newDetailRecords[i].get('PRE_ITEM_P'));
							}
						} else {
							if(Ext.isEmpty(record.get('BPR400T_ITEM_P'))) {
								newDetailRecords[i].set('PRE_ITEM_P'	, 0);
							} else {
								newDetailRecords[i].set('PRE_ITEM_P'	, record.get('BPR400T_ITEM_P'));
							}
							newDetailRecords[i].set('ITEM_P'			, record.get('ITEM_P') + record.get('DIFFERENCE_AMT'));
							//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0 
							if(newDetailRecords[i].get('PRE_ITEM_P') == 0) {
								newDetailRecords[i].set('DIFFER_UNIT_P'	, 0);
							} else {
								newDetailRecords[i].set('DIFFER_UNIT_P'	, newDetailRecords[i].get('ITEM_P') - newDetailRecords[i].get('PRE_ITEM_P'));
							}
						}
					});
					directMasterStore1.loadData(newDetailRecords, true);
				} else {
					alert('이미 기안된 자료입니다.');
					return false;
				}
			});
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "APLY_START_DATE" :
					var param = {
						'COMP_CODE': UserInfo.compCode
						, 'MONEY_UNIT': record.get('MONEY_UNIT')
						, 'APLY_START_DATE': UniDate.getDbDateStr(newValue)
						, 'TYPE': panelResult.getValue('TYPE')
						, 'CUSTOM_CODE': record.get('CUSTOM_CODE')
						, 'ITEM_CODE': record.get('ITEM_CODE')
						, 'ORDER_UNIT': record.get('ORDER_UNIT')
						, 'DIV_CODE': panelResult.getValue('DIV_CODE')
						, 'NEW_ITEM_FREFIX': record.get('NEW_ITEM_FREFIX')
						, 'ITEM_NAME2': record.get('ITEM_NAME2')
						, 'SPEC2': record.get('SPEC2')
					};
					s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
						if(!Ext.isEmpty(provider)) {
							record.set('PRE_ITEM_P'			, provider[0].ITEM_P);
							//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0 
							if(record.get('PRE_ITEM_P') == 0) {
								record.set('DIFFER_UNIT_P'	, 0);
							} else {
								record.set('DIFFER_UNIT_P'	, record.get('ITEM_P') - record.get('PRE_ITEM_P'));
							}
 //							record.set('APLY_START_DATE'	, UniDate.add(panelResult.getValue('APLY_START_DATE'), {days:-1}));
//							grdRecord.set('PRICE_TYPE1'		, provider[0].PRICE_TYPE);
//							grdRecord.set('PRICE_TYPE2'		, provider[0].PRICE_TYPE);
						}
					});
				break;

				case "MONEY_UNIT" :
					var param = {
						'COMP_CODE': UserInfo.compCode
						, 'MONEY_UNIT': newValue
						, 'APLY_START_DATE': UniDate.getDbDateStr(record.get('APLY_START_DATE'))
						, 'TYPE': panelResult.getValue('TYPE')
						, 'CUSTOM_CODE': record.get('CUSTOM_CODE')
						, 'ITEM_CODE': record.get('ITEM_CODE')
						, 'ORDER_UNIT': record.get('ORDER_UNIT')
						, 'DIV_CODE': panelResult.getValue('DIV_CODE')
						, 'NEW_ITEM_FREFIX': record.get('NEW_ITEM_FREFIX')
						, 'ITEM_NAME2': record.get('ITEM_NAME2')
						, 'SPEC2': record.get('SPEC2')
					};
					s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
						if(!Ext.isEmpty(provider)) {
							record.set('PRE_ITEM_P'			, provider[0].ITEM_P);
							//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
							if(record.get('PRE_ITEM_P') == 0) {
								record.set('DIFFER_UNIT_P'	, 0);
							} else {
								record.set('DIFFER_UNIT_P'	, record.get('ITEM_P') - record.get('PRE_ITEM_P'));
							}
//							record.set('APLY_START_DATE'	, UniDate.add(panelResult.getValue('APLY_START_DATE'), {days:-1}));
//							grdRecord.set('PRICE_TYPE1'		, provider[0].PRICE_TYPE);
//							grdRecord.set('PRICE_TYPE2'		, provider[0].PRICE_TYPE);
						}
					});
				break;

				case "ORDER_UNIT" :
					var param = {
						'COMP_CODE': UserInfo.compCode
						, 'MONEY_UNIT': record.get('MONEY_UNIT')
						, 'APLY_START_DATE': UniDate.getDbDateStr(record.get('APLY_START_DATE'))
						, 'TYPE': panelResult.getValue('TYPE')
						, 'CUSTOM_CODE': record.get('CUSTOM_CODE')
						, 'ITEM_CODE': record.get('ITEM_CODE')
						, 'ORDER_UNIT': newValue
						, 'DIV_CODE': panelResult.getValue('DIV_CODE')
						, 'NEW_ITEM_FREFIX': record.get('NEW_ITEM_FREFIX')
						, 'ITEM_NAME2': record.get('ITEM_NAME2')
						, 'SPEC2': record.get('SPEC2')
					};
					s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
						if(!Ext.isEmpty(provider)) {
							record.set('PRE_ITEM_P'			, provider[0].ITEM_P);
							//20191216 추가: DIFFER_UNIT_P, 20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
							if(record.get('PRE_ITEM_P') == 0) {
								record.set('DIFFER_UNIT_P'	, 0);
							} else {
								record.set('DIFFER_UNIT_P'	, record.get('ITEM_P') - record.get('PRE_ITEM_P'));
							}
//							record.set('APLY_START_DATE'	, UniDate.add(panelResult.getValue('APLY_START_DATE'), {days:-1}));
//							grdRecord.set('PRICE_TYPE1'		, provider[0].PRICE_TYPE);
//							grdRecord.set('PRICE_TYPE2'		, provider[0].PRICE_TYPE);
						}
					});
				break;

				case "ITEM_CODE" :
					if(Ext.isEmpty(newValue)){
						record.set('ITEM_NAME'		, '');
					}
				break;

				//20191216 계산로직 추가
				case "ITEM_P" :
					//20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
					if(record.get('PRE_ITEM_P') == 0) {
						record.set('DIFFER_UNIT_P', 0);
					} else {
						record.set('DIFFER_UNIT_P', newValue - record.get('PRE_ITEM_P'));
					}
				break;

				//20191216 계산로직 추가
				case "PRE_ITEM_P" :
					//20191224 수정: if 종전단가 <> 0 이면 단가차액=단가-종전단가, else 단가차액 = 0
					if(newValue == 0) {
						record.set('DIFFER_UNIT_P', 0);
					} else {
						record.set('DIFFER_UNIT_P', record.get('ITEM_P') - newValue);
					}
				break;
			}
			return rv;
		}
	})
};
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>