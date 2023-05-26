<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj106ukr">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A011"/>
	<t:ExtComboStore comboType="AU" comboCode="A001"/>
	<t:ExtComboStore comboType="AU" comboCode="A022"/>	<!-- 매입증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>
	<t:ExtComboStore comboType="AU" comboCode="A003"/>
	<t:ExtComboStore comboType="AU" comboCode="A002"/>
	<t:ExtComboStore comboType="AU" comboCode="A014"/>	<!-- 승인상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>
	<t:ExtComboStore comboType="AU" comboCode="A058"/>
	<t:ExtComboStore comboType="AU" comboCode="A149"/>
	<t:ExtComboStore comboType="AU" comboCode="A016"/>
	<t:ExtComboStore comboType="AU" comboCode="A012"/>
	<t:ExtComboStore comboType="AU" comboCode="A070"/>
	<t:ExtComboStore items="${COMBO_DRAFT_CODE}" storeId="draftcode"/>
</t:appConfig>

<script type="text/javascript" >

var csINPUT_DIVI	= "2";	//1:결의전표/2:결의전표(전표번호별)
var csSLIP_TYPE		= "2";	//1:회계전표/2:결의전표
var csSLIP_TYPE_NAME= "결의전표";
var csINPUT_PATH	= 'Z1';
var gsInputPath, gsInputDivi, gsDraftCode	;
var postitWindow;			// 각주팝업
var creditNoWin;			// 신용카드번호 & 현금영수증 팝업
var comCodeWin ;			// A070 증빙유형팝업66
var creditWIn;				// 신용카드팝업
var printWin;				//전표출력팝업
var foreignWindow;			//외화금액입력
var gsBankBookNum, gsBankName ;
var tab;
var gwValue;				//그룹웨어 사용여부
var slipHeight;				//그룹웨어 입력필드란 높이
var slipWindow;

function appMain() {
	var gsSlipNum		=""; // 링크로 넘어오는 Slip_NUM
	var gsProcessPgmId	=""; // Store 에서 링크로 넘어온 Data 값 체크 하기 위해 전역변수 사용
	var baseInfo		= {
		gsLocalMoney	: '${gsLocalMoney}',
		gsBillDivCode	: '${gsBillDivCode}',
		gsPendYn		: '${gsPendYn}',
		gsChargePNumb	: '${gsChargePNumb}',
		gsChargePName	: '${gsChargePName}',
		gbAutoMappingA6	: '${gbAutoMappingA6}',	// '결의전표 관리항목 사번에 로그인정보 자동매핑함
		gsDivChangeYN	: '${gsDivChangeYN}',	// '귀속부서 입력시 사업장 자동 변경 사용여부
		gsRemarkCopy	: '${gsRemarkCopy}',	// '전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
		gsAmtEnter		: '${gsAmtEnter}',		// '전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
//		gsAmtPoint		: ${gsAmtPoint},		// 외화금액 format
		gsChargeDivi	: '${gsChargeDivi}',	// 1:회계부서, 2:현업부서
		gsGWUseYn		: '${gsGWUseYN}',		// 그룹웨어 사용여부
		gsGWUrl			: '${gsGWUrl}',			// 그룹웨어 결재상신경로
		inDeptCodeBlankYN   : '${inDeptCodeBlankYN}' // 귀속부서 팝업창 오픈시 검색어 공백 처리(A165, 75)
	}
	if (baseInfo.gsGWUseYn == '00'){
		gwValue = true;
		slipHeight = 100;
	}else{
		gwValue = false;
		slipHeight = 130;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'agj100ukrService.selectList',
			update	: 'agj100ukrService.update',
			create	: 'agj100ukrService.insert',
			destroy	: 'agj100ukrService.delete',
			syncAll	: 'agj100ukrService.saveAll'
		}
	});

	<%@include file="./accntGridConfig_agj106ukr.jsp" %>

	/** 일반전표 Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('agj106ukrMasterStore1',getStoreConfig());

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '검색조건',
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
		items		: [{
			title		: '기본정보', 	
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '전표일',
				xtype		: 'uniDatefield',
				name		: 'AC_DATE',
				value		: UniDate.get('today'),
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AC_DATE', newValue);
						//20200702 주석: 하는 일 없이 루프만 돌아서 주석 처리 (Ext.each안의 RECORD.SET은 기존에 주석)
//						Ext.each(directMasterStore1.getData().items, function(record, ids){
//							record.set('AC_DATE',newValue);
//							record.set('AC_DAY',Ext.Date.format(newValue,'d'));
//						})
					}
				}
			},{
				fieldLabel	: '전표번호',
				xtype		: 'uniNumberfield',
				name		: 'EX_NUM',
				allowBlank	: false,
				value		: 1,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EX_NUM', newValue);
						//20200702 주석: 하는 일 없이 루프만 돌아서 주석 처리 (Ext.each안의 RECORD.SET은 기존에 주석)
//						Ext.each(directMasterStore1.getData().items, function(record, ids){
//							record.set('EX_NUM',newValue);
//						})
					}
				}
			},{
				fieldLabel	: '입력경로',
				name		: 'INPUT_PATH',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A011',
				readOnly	: true,
				value		: csINPUT_PATH,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INPUT_PATH', newValue);
						if(newValue != csINPUT_PATH) {
							UniAppManager.app.setEditableGrid( newValue, false);
						}else {
							UniAppManager.app.setEditableGrid( csINPUT_PATH, false);
						}
					}
				}
			},{
				fieldLabel	: '승인여부',
				name		: 'AP_STS',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A014',
				value		: '1',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AP_STS', newValue);
					}
				}
			},{
				fieldLabel	: '회계부서',
				name		: 'IN_DEPT_CODE',
				value		: UserInfo.deptCode,
				hidden		:true
			},{
				fieldLabel	: '회계담당자',
				name		: 'AUTHORITY',
				value		: baseInfo.gsChargeDivi,
				hidden		: true
			},{
				fieldLabel	: '입력자',
				name		: 'CHARGE_CODE',
				value		: '${chargeCode}',
				hidden		: true
			}]
		}]
	});	//end panelSearch  

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: 0,
		border	: true,
		items	: [{
			xtype		: 'displayfield',
			hideLabel	: true,
			value		: '<div style="color:blue;font-weight:bold;padding-left:5px;">[조회]</div>',
			width		: 50
		},{
			fieldLabel	: '전표일',
			xtype		: 'uniDatefield',
			name		: 'AC_DATE',
			labelWidth	: 60,
			width		: 245,
			value		: UniDate.get('today'),
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AC_DATE', newValue);
					//20200702 주석: 하는 일 없이 루프만 돌아서 주석 처리
//					Ext.each(directMasterStore1.getData().items, function(record, ids){
//					})
				}
			}
		},{
			fieldLabel	: '전표번호',
			xtype		: 'uniNumberfield',
			name		: 'EX_NUM',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('EX_NUM', newValue);
					//20200702 주석: 하는 일 없이 루프만 돌아서 주석 처리
//					Ext.each(directMasterStore1.getData().items, function(record, ids){
//					})
				},
				render: function(component) {
					component.getEl().on('dblclick', function( event, el ) {
						openslipWindow();
					});
				}
			}
		},{
			fieldLabel	: '입력경로',
			name		: 'INPUT_PATH',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A011',
			width		: 254,
			readOnly	: true,
			value		: csINPUT_PATH,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INPUT_PATH', newValue);
					if(newValue != csINPUT_PATH) {
						UniAppManager.app.setEditableGrid( newValue, false);
					}else {
						UniAppManager.app.setEditableGrid( csINPUT_PATH, false);
					}
				}
			}
		},{
			fieldLabel	: '승인여부',
			name		: 'AP_STS',
			xtype		: 'uniCombobox' ,
			comboType	: 'AU',
			comboCode	: 'A014',
			value		: '1',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AP_STS', newValue);
				}
			}
		},{
			fieldLabel	: '회계부서',
			name		: 'IN_DEPT_CODE',
			value		: UserInfo.deptCode,
			hidden		: true
		},{
			fieldLabel	: '회계담당자',
			name		: 'AUTHORITY',
			value		: baseInfo.gsChargeDivi,
			hidden		: true
		},{
			fieldLabel	: '입력자',
			name		: 'CHARGE_CODE',
			value		: '${chargeCode}',
			hidden		: true
		}]
	});

	//createSearchForm
	var slipForm =  Unilite.createSearchForm('agj106ukrSlipForm', {
		itemId			: 'agj106ukrSlipForm',
		masterGrid		: masterGrid1,
		height			: slipHeight,
		disabled		: false,
		trackResetOnLoad: false,
		border			: true,
		padding			: 0,
		layout			: {
			type	: 'uniTable',
			columns	: 4
		},
		defaults		: {
			width		: 246,
			labelWidth	: 90
		},
		items:[{
			xtype		: 'displayfield',
			hideLable	: true,
			value		: '<div style="color:blue;font-weight:bold;padding-left:5px;">[입력]</div>',
			width		: 50,
			tdAttrs		: {width: 50}
		},{
			fieldLabel	: '사업장',
			name		: 'IN_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			labelWidth	: 60,
			value		: UserInfo.divCode
		},{
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type:'hbox', align:'stretch'},
			items		: [{
				fieldLabel	: '결의부서',
				name		: 'IN_DEPT_CODE',
				readOnly	: true,
				value		: UserInfo.deptCode,
				width		: 160
			},{
				fieldLabel	: '결의부서명',
				name		: 'IN_DEPT_NAME',
				value		: UserInfo.deptName,
				readOnly	: true,
				hideLabel	: true,
				width		: 85
			}]
		},
		Unilite.popup('ACCNT_PRSN', {
			fieldLabel		: '입력자ID',
			valueFieldName	: 'CHARGE_CODE',
			textFieldName	: 'CHARGE_NAME',
			allowBlank		: false,
			labelWidth		: 88,
			textFieldWidth	: 100,
			readOnly		: true
		}),
		/*{
			fieldLabel	: '전표양식',
			name		: 'REPORT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'AX01' ,
			labelWidth	: 88,
			allowBlank	: false,
			value		: '01'
		},*/
		{
			xtype		: 'displayfield',
			hideLable	: true,
			value		: '<div style="color:blue;font-weight:bold;padding-left:5px;">&nbsp;</div>',
			width		: 50,
			tdAttrs		: {width:50}
		},{
			fieldLabel	: '전표일',
			xtype		: 'uniDatefield',
			name		: 'AC_DATE',
			labelWidth	: 60,
			value		: UniDate.get('today'),
			allowBlank	: false,
			listeners	: {
				change:function(field, newValue, oldValue) {
					if(!slipForm.uniOpt.inLoading) {
						if(Ext.isDate(newValue)) {
							var value	= field.getValue();
							var exNum	= slipForm.getValue("EX_NUM");
							var sDay	= Ext.Date.format(value, 'd').toString();
							//날짜와 전표 번호 생성
							if(!Ext.isEmpty(exNum) && Ext.isDate(value)) {
								Ext.getBody().mask();
								agj100ukrService.getSlipNum({'EX_DATE':UniDate.getDbDateStr(value)}, function(provider, result ) {
									slipForm.setValue("EX_NUM", provider.SLIP_NUM);	
									var data = directMasterStore1.getData();
									Ext.each(data.items, function(item, idx){
										item.set("AC_DATE", value);
										item.set("AC_DAY", sDay);
										item.set('SLIP_NUM', provider.SLIP_NUM);
										if(item.phantom ) {
											item.set('OLD_SLIP_NUM', provider.SLIP_NUM);
										}
									});
									Ext.getBody().unmask();
								});
							}
						}
					}
				}
			}
		},{
			fieldLabel	: '전표번호',
			xtype		: 'uniNumberfield',
			name		: 'EX_NUM',
			allowBlank	: false,
			value		: '1',
			listeners	: {
				change:function(field, newValue, oldValue) {
					if(!slipForm.uniOpt.inLoading) {
						var value = newValue;
						var sDate = UniDate.getDbDateStr(slipForm.getValue("AC_DATE"));
						if(!Ext.isEmpty(value) && Ext.isDate(slipForm.getValue("AC_DATE"))) {
							var param = {
								'GUBUN'	: csSLIP_TYPE,
								'SDATE'	: sDate,
								'SNUM'	:value
							}
							Ext.getBody().mask();
							accntCommonService.fnGetExistSlipNum(param, function(provider, response) {
								var chk =false;
								if(provider.CNT != 0) {
									chk = true;
									//Unilite.messageBox(Msg.sMA0306);
								}
								agj100ukrService.getSlipNum({'EX_DATE':sDate}, function(provider, result ) {
									var bChange = chk;
									if(!bChange && value != provider.SLIP_NUM)  {
										//if(confirm("당일 최종 전표번호는 "+(provider.SLIP_NUM-1)+"번 입니다. "+(provider.SLIP_NUM)+"번으로 바꾸시겠습니까?")) {
										bChange = true;
										//} else {
										//	Ext.getBody().unmask();
										//	return;
										//}
									}
									if(bChange) {
										slipForm.setValue("EX_NUM", provider.SLIP_NUM);	
										var data = directMasterStore1.getData();
										Ext.each(data.items, function(item, idx){
											
											item.set("SLIP_NUM", provider.SLIP_NUM)
											item.phantom = true;
											item.set('OLD_SLIP_NUM', provider.SLIP_NUM);
											
										});
									}
									Ext.getBody().unmask();
								});
							});
						}
					}
				}
			}
		},{
			fieldLabel	: '전표구분',
			name		: 'SLIP_DIVI',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A002' ,
			labelWidth	: 88,
			allowBlank	: false,
			disabled	: true,
			value		: '3',
			listeners	: {
				specialkey: function(elm, e){
					lastFieldSpacialKey(elm, e)
				},
				change:function(field, newValue, oldValue) {
					if(cashInfo && !Ext.isDefined(cashInfo.ACCNT) && (newValue == "1" || newValue =="2")) {
						Unilite.messageBox("현금계정이 없어 입금, 출금을 선택 할 수 없습니다.");
						field.setValue(oldValue);
						return false;
					}
					return true;
				}
			}
		},
		/*,{
			fieldLabel	: '승인여부',
			name		: 'AP_STS',
			xtype		: 'uniCombobox' ,
			comboType	: 'AU',
			comboCode	: 'A014' ,
			readOnly	: true
		}*/
		{
			xtype		: 'displayfield',
			hideLable	: true,
			value		: '<div style="color:blue;font-weight:bold;padding-left:5px;">&nbsp;</div>',
			width		: 50,
			tdAttrs		: {width:50}
		
		},{
			fieldLabel	: '승인여부',
			name		: 'AP_STS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A014',
			labelWidth	: 60,
			readOnly	: true
		},{
			fieldLabel	: '기안상태',
			name		: 'DRAFT_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('draftcode'),
/*			comboType	: 'AU',
			comboCode	: 'A134',*/
			hidden		: gwValue,
			readOnly	: true
		},{
			fieldLabel	: '전표양식',
			name		: 'REPORT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A240',
			allowBlank	: false,
			hidden		: gwValue,
			value		: '01',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var rpttype = slipForm.getValue('REPORT_TYPE');
					var records = directMasterStore1.data.items;
					Ext.each(records, function(record,i){
						record.set('REPORT_TYPE',rpttype);
					});
				}
			}
		},{
			xtype		: 'displayfield',
			hideLable	: true,
			value		: '<div style="color:blue;font-weight:bold;padding-left:5px;">&nbsp;</div>',
			width		: 50,
			tdAttrs		: {width:50}
		},{
			fieldLabel	: '전표제목',
			name		: 'REMARK2',
			xtype		: 'textfield' ,
			hidden		: gwValue ,
			colspan		: 2,
			labelWidth	: 60,
			width		: 493,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					var remark2 = slipForm.getValue('REMARK2');
					var records = directMasterStore1.data.items;
					Ext.each(records, function(record,i){
						record.set('REMARK2',remark2);
					});
				}
			}
		},{
			fieldLabel	: '기안번호',
			name		: 'DRAFT_NO',
			xtype		: 'textfield',
			hidden		: gwValue,
			readOnly	: true
		}]
	});

	Unilite.defineModel('agj106ukrslipModel', {
		fields: [
			{name: 'AUTO_NUM'		, text: '번호'		, type: 'string'},
			{name: 'AC_DATE'		, text: '전표일'		, type: 'uniDate'},
			{name: 'SLIP_NUM'		, text: '전표번호'		, type: 'int'},
			{name: 'CR_AMT_I'		, text: '금액'		, type: 'uniPrice'},
			{name: 'REMARK'			, text: '적요'		, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '거래처코드'		, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'		, type: 'string'},
			{name: 'DEPT_CODE'		, text: '귀속부서'		, type: 'string'},
			{name: 'DEPT_NAME'		, text: '귀속부서명'		, type: 'string'}
		]
	});



	var slipStore = Unilite.createStore('agj106ukrslipStore', {
		model	: 'agj106ukrslipModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'agj106ukrService.selectSlipList'
			}
		},
		loadStoreRecords : function() {
			var param= slipSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var slipSearch = Unilite.createSearchForm('slipForm', {
		layout	: {type : 'uniTable', columns : 2},
		items	:[{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			allowBlank	: false,
			comboType	: 'BOR120',
			value		: '01',
			hidden		: true
		},{
			fieldLabel		: '전표일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			allowBlank		: false,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')
		},{
			fieldLabel	: '전표번호',
			xtype		: 'uniNumberfield',
			name		: 'EX_NUM'
		},
		Unilite.popup('CUST', {
			fieldLabel		: '거래처',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			extParam		: {'CUSTOM_TYPE': ['1','2']}
		}),{
			fieldLabel	: '입력경로',
			name		: 'INPUT_PATH',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A011',
			width		: 254,
			value		: csINPUT_PATH
		},{
			fieldLabel	: '입력자',
			name		: 'CHARGE_CODE',
			value		: '${chargeCode}',
			hidden		: true
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
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)   {
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
					if(item.isPopupField)   {
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
	var slipGrid = Unilite.createGrid('agj106ukrslipGrid', {
		store	: slipStore,
		layout	: 'fit',
		selModel: 'rowmodel',
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			expandLastColumn	: true,
			onLoadSelectFirst	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
//		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns: [
			{ dataIndex: 'AUTO_NUM'		, width: 90,hidden:true},
			{ dataIndex: 'AC_DATE'		, width: 90},
			{ dataIndex: 'SLIP_NUM'		, width: 90},
			{ dataIndex: 'CR_AMT_I'		, width: 180},
			{ dataIndex: 'REMARK'		, width: 80},
			{ dataIndex: 'CUSTOM_CODE'	, width: 120},
			{ dataIndex: 'CUSTOM_NAME'	, width: 138 },
			{ dataIndex: 'DEPT_CODE'	, width: 138 },
			{ dataIndex: 'DEPT_NAME'	, width: 138 }
		]
	});
	function openslipWindow() {
		if(!slipWindow) {
			slipWindow = Ext.create('widget.uniDetailWindow', {
				title	: '전표번호 팝업',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [slipSearch, slipGrid],
				tbar	: ['->',{
					itemId	: 'saveBtn',
					text	: '조회',
					handler	: function() {
						if(slipSearch.setAllFieldsReadOnly(true) == false){
							return false;
						}
						slipStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '적용 후 닫기',
					handler	: function() {
						var record = slipGrid.getSelectedRecord();
						if(record){
							panelSearch.setValues({"EX_NUM":record.get("SLIP_NUM")});
						}
						slipWindow.hide();
						slipGrid.reset();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '닫기',
					handler	: function() {
						slipGrid.reset();
						slipWindow.hide();
					},
					disabled: false
				}]
			})
		}
		slipWindow.center();
		slipWindow.show();
	};



	function lastFieldSpacialKey(elm, e) {
		if( e.getKey() == Ext.event.Event.ENTER) {
			if(elm.isExpanded) {
				var picker = elm.getPicker();
				if(picker) {
					var view = picker.selectionModel.view;
					if(view && view.highlightItem) {
						picker.select(view.highlightItem);
					}
				}
			} else {
				var grid = UniAppManager.app.getActiveGrid();
				var record = grid.getStore().getAt(0);
				if(record) {
					e.stopEvent();
					grid.editingPlugin.startEdit(record,grid.getColumn('SLIP_NUM'))
				}else {
					UniAppManager.app.onNewDataButtonDown();
				}
			}
		}
	}



	/** 일발전표 Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('agj106ukrGrid1', getGridConfig(directMasterStore1,'agj106ukrGrid1','agj106ukrDetailForm1', 0.6, false, '2'));

	var detailForm1 = Unilite.createForm('agj106ukrDetailForm1',  getAcFormConfig('agj106ukrDetailForm1',masterGrid1 ));

	//차대변 구분 전표
	<%@include file="./agjSlip.jsp" %>



	var centerContainer = {
		region	: 'center',
		xtype	: 'container',
		layout	: {type:'vbox', align:'stretch'},
		items	: [
			slipForm,
			masterGrid1,
			detailForm1,
			slipContainer
		]
	}


	Unilite.Main({
		id			: 'agj106ukrApp',
		borderItems	: [{
				region	: 'center',
				layout	: 'border',
				border	: false,
				defaults: {
					style:{left:'1px'}
				},
				items:[
					centerContainer, panelResult
				]
			}, panelSearch
		],
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['newData', 'reset','prev', 'next', 'deleteAll'], true);
			panelSearch.setValue('AC_DATE'		, '${initExDate}');
			panelSearch.setValue('EX_NUM'		, '${initExNum}');
			panelSearch.setValue('IN_DEPT_CODE'	, UserInfo.deptCode);
			panelSearch.setValue('CHARGE_CODE'	, '${chargeCode}');
			panelSearch.setValue('AUTHORITY'	, baseInfo.gsChargeDivi);

			panelResult.setValue('AC_DATE'		, '${initExDate}');
			panelResult.setValue('EX_NUM'		, '${initExNum}');
			panelResult.setValue('IN_DEPT_CODE'	, UserInfo.deptCode);
			panelResult.setValue('CHARGE_CODE'	, '${chargeCode}');
			panelResult.setValue('AUTHORITY'	, baseInfo.gsChargeDivi);

			slipForm.setValue('AC_DATE'			, '${initExDate}');
			slipForm.setValue('EX_NUM'			, '${initExNum}');
			slipForm.setValue('CHARGE_CODE'		, '${chargeCode}');
			slipForm.setValue('CHARGE_NAME'		, '${chargeName}');	
			
			if(Ext.isEmpty('${chargeCode}')) {
				Unilite.messageBox('회계담당자정보가 없습니다');
			}
			Ext.getCmp('GW').setDisabled(true);
			slipForm.setValue('DRAFT_NO','');
			gsDraftCode = '';

			this.processParams(params);
		},
		onQueryButtonDown : function() {
			detailForm1.down('#formFieldArea1').removeAll();
			directMasterStore1.loadStoreRecords(null, function(provider, response){
				if(!Ext.isEmpty(provider) && provider.length > 0) {
					slipForm.uniOpt.inLoading = true;
					slipForm.setValue("AP_STS", provider[0].get('AP_STS'));
					if(provider[0].get('AP_STS') != '2') {
						UniAppManager.app.setSearchReadOnly(false, false);
						detailForm1.setReadOnly(false);
					}else {
						detailForm1.setReadOnly(true);
					}
					slipForm.getForm().setValues(provider[0].getData());
					slipForm.setValue("EX_NUM"			, provider[0].get('SLIP_NUM'));
					slipForm.setValue("DRAFT_NO"		, provider[0].get('DRAFT_NO'));
		
					panelSearch.setValue("INPUT_PATH"	, provider[0].get('INPUT_PATH'));
					panelSearch.setValue("AP_STS"		, provider[0].get('AP_STS'));
					panelResult.setValue("INPUT_PATH"	, provider[0].get('INPUT_PATH'));
					panelResult.setValue("AP_STS"		, provider[0].get('AP_STS'));
					panelResult.setValue("REPORT_TYPE"	, provider[0].get('REPORT_TYPE'));
					panelResult.setValue("REMARK2"		, provider[0].get('REMARK2'));
					panelResult.setValue("DRAFT_CODE"	, provider[0].get('DRAFT_CODE'));

					gsDraftCode = provider[0].get('DRAFT_CODE');
					if(slipForm.getValue('DRAFT_CODE') == '1' || slipForm.getValue('DRAFT_CODE') == '3') {
						Ext.getCmp('GW').setDisabled(true);
					} else {
						Ext.getCmp('GW').setDisabled(false);
					}
					UniAppManager.app.setSearchReadOnly(true)
					slipForm.uniOpt.inLoading = false;
				} else {
					slipForm.setValue('AC_DATE', panelSearch.getValue('AC_DATE'));
					slipForm.setValue('EX_NUM' , panelSearch.getValue('EX_NUM'));
					slipForm.setValue('CHARGE_CODE','${chargeCode}');
					slipForm.setValue('CHARGE_NAME','${chargeName}');
					
					slipForm.setValue('AP_STS'	 , '');
					slipForm.setValue('DRAFT_CODE' , '');
					slipForm.setValue('REPORT_TYPE', '01');
					slipForm.setValue('REMARK2'	, '');
					slipForm.setValue('DRAFT_NO'   , '');
				}
			});
			slipForm.uniOpt.inLoading = true;
			slipForm.setValue("AC_DATE", panelSearch.getValue("AC_DATE"))
			slipForm.setValue("EX_NUM", panelSearch.getValue("EX_NUM"))
			slipForm.uniOpt.inLoading = false;

			this.setSearchReadOnly(false, true);
		},
		onNewDataButtonDown : function() {
			//20200702 수정: 기존로직으로 변경 / 메세지 변경
			if(slipForm.getValue('DRAFT_CODE') == '1' || slipForm.getValue('DRAFT_CODE') == '3') {
//			if(slipForm.getValue('DRAFT_CODE') == '1') {
				Unilite.messageBox('기안 중이거나 완결된 데이터는 행을 추가할 수 없습니다.')
				return false;
			} 
			if(!this.toolbar.down("#newData").isDisabled()) {
				this.fnAddSlipRecord();
				//UniAppManager.app.setSearchReadOnly(true);
			}
		},	
		onSaveDataButtonDown: function (config) {
			directMasterStore1.saveStore(config);
		},
		onDeleteDataButtonDown : function() {
			//20200702 수정: 기존로직으로 변경
			if(slipForm.getValue('DRAFT_CODE') == '1' || slipForm.getValue('DRAFT_CODE') == '3') {
//			if(slipForm.getValue('DRAFT_CODE') == '1') {
				Unilite.messageBox('기안 중이거나 완결된 데이터는 삭제할 수 없습니다.')
				return false;
			}
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid1.deleteSelectedRow();
			}
		},
		onPrevDataButtonDown:  function() {
			if(directMasterStore1.isDirty()) {
					if(confirm(Msg.sMB061)) {
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				return;
			}
			if(slipForm.isValid() ) {
				Ext.getBody().mask();
				var param = slipForm.getValues();
				param.INPUT_PATH = panelSearch.getValue('INPUT_PATH');
				param.AUTHORITY = panelSearch.getValue('AUTHORITY');
				agj106ukrService.getPrevSlipNum(param, function(provider, response){
					Ext.getBody().unmask();
					if(provider) {
						panelSearch.setValue('AC_DATE', provider.EX_DATE);
						panelSearch.setValue('EX_NUM', provider.EX_NUM);
						panelSearch.setValue('AP_STS', provider.AP_STS);

						panelResult.setValue('AC_DATE', provider.EX_DATE);
						panelResult.setValue('EX_NUM', provider.EX_NUM);
						panelResult.setValue('AP_STS', provider.AP_STS);

						slipForm.uniOpt.inLoading = true;
						slipForm.setValue("IN_DEPT_CODE", provider.IN_DEPT_CODE);
						slipForm.setValue("IN_DEPT_NAME", provider.IN_DEPT_NAME);
						slipForm.setValue("CHARGE_CODE", provider.CHARGE_CODE);
						slipForm.setValue("CHARGE_NAME", provider.CHARGE_NAME);
						slipForm.uniOpt.inLoading = false;

						UniAppManager.app.onQueryButtonDown()
					}
				})
			}
		},
		onNextDataButtonDown:  function() {
			if(directMasterStore1.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown();
				} else {
					this.rejectSave();
				}
				return;
			}
			if(slipForm.isValid()) {
				slipForm.uniOpt.inLoading = true;
				Ext.getBody().mask();
				var param = slipForm.getValues();
				param.INPUT_PATH = panelSearch.getValue('INPUT_PATH');
				param.AUTHORITY = panelSearch.getValue('AUTHORITY');
				
				agj106ukrService.getNextSlipNum(param, function(provider, response){
					Ext.getBody().unmask();
					if(provider) {
						panelSearch.setValue('AC_DATE'	, provider.EX_DATE);
						panelSearch.setValue('EX_NUM'	, provider.EX_NUM);
						panelSearch.setValue('AP_STS'	, provider.AP_STS);
						panelResult.setValue('AC_DATE'	, provider.EX_DATE);
						panelResult.setValue('EX_NUM'	, provider.EX_NUM);
						panelResult.setValue('AP_STS'	, provider.AP_STS);
						slipForm.uniOpt.inLoading = true;
						slipForm.setValue("IN_DEPT_CODE", provider.IN_DEPT_CODE);
						slipForm.setValue("IN_DEPT_NAME", provider.IN_DEPT_NAME);
						slipForm.setValue("CHARGE_CODE"	, provider.CHARGE_CODE);
						slipForm.setValue("CHARGE_NAME"	, provider.CHARGE_NAME);
						slipForm.uniOpt.inLoading = false;
						UniAppManager.app.onQueryButtonDown()
					}
				})
				slipForm.uniOpt.inLoading = false;
			}
		},
		onResetButtonDown:function() {
			gsSlipNum = "";
			gsProcessPgmId ="";

			var masterGrid1 = Ext.getCmp('agj106ukrGrid1');
			panelSearch.reset();
			masterGrid1.reset();
			masterGrid1.getStore().commitChanges();
			this.setSearchReadOnly(false, false);
			slipForm.getForm().reset();	

			tempEditMode = true;
			detailForm1.down('#formFieldArea1').removeAll();
			slipGrid1.reset();
			slipGrid2.reset();
			UniAppManager.setToolbarButtons(['save'],false);

			Ext.getCmp('GW').setDisabled(true);

			gsDraftCode = '';
			
			panelSearch.setValue('AC_DATE','${initExDate}');
			//panelSearch.setValue('EX_NUM','${initExNum}');
			panelResult.setValue('AC_DATE','${initExDate}');
			//panelResult.setValue('EX_NUM','${initExNum}');
			
			slipForm.setValue('AC_DATE'		,'${initExDate}');
			slipForm.setValue('EX_NUM'		,'${initExNum}');
			slipForm.setValue('CHARGE_CODE'	,'${chargeCode}');
			slipForm.setValue('CHARGE_NAME'	,'${chargeName}');	
			
			agj100ukrService.getSlipNum({'EX_DATE':UniDate.getDbDateStr(slipForm.getValue('AC_DATE'))}, function(provider, result ) {
				slipForm.setValue("EX_NUM"		, provider.SLIP_NUM);
				panelSearch.setValue('EX_NUM'	,provider.SLIP_NUM);
				panelResult.setValue('EX_NUM'	,provider.SLIP_NUM);
			})
			UniAppManager.app.fnInitBinding();
		},
		onDeleteAllButtonDown : function() {
			//20200702 추가: 기안 중이거나 완결된 데이터는 삭제 안 되도록 수정
			if(slipForm.getValue('DRAFT_CODE') == '1' || slipForm.getValue('DRAFT_CODE') == '3') {
				Unilite.messageBox('기안 중이거나 완결된 데이터는 삭제할 수 없습니다.')
				return false;
			}
			if(slipForm.getValue("AP_STS") != "2") {
				if(confirm('전체 삭제 하시겠습니까?')) {
					var cnt = directMasterStore1.count();
					for(var i=0 ; i < cnt ; i++) {
						directMasterStore1.removeAt(0);
					}
					detailForm1.down('#formFieldArea1').removeAll();
					UniAppManager.app.onSaveDataButtonDown();
				}
			}else {
				Unilite.messageBox("승인된 전표입니다.");
			}
		},
		requestApprove: function(){	//결재 요청
			var gsWin		= window.open('about:blank','payviewer','width=500,height=500');
			var frm			= document.f1;
			var compCode	= UserInfo.compCode;
			var divCode		= UserInfo.divCode;
			var userId		= UserInfo.userID;
			var acdate		= UniDate.getDbDateStr(slipForm.getValue('AC_DATE'));
			var acnum		= UniDate.getDbDateStr(slipForm.getValue('EX_NUM'));
			var reporttype	= slipForm.getValue('REPORT_TYPE');
			var draftNo		= compCode + acdate + acnum;	//법인코드+전표일+전표번호 = 기안번호
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(slipForm.getValue('AC_DATE')),
				"EX_NUM"	: slipForm.getValue('EX_NUM'),
				"DRAFT_NO"	: draftNo
			}
			agj106ukrService.draftNoUpdate(param, function(provider, result ) {
			}); 

			if(slipForm.getValue('REPORT_TYPE') == '01' || slipForm.getValue('REPORT_TYPE') == '02') {
				var groupUrl = baseInfo.gsGWUrl + "viewMode=docuDraft&prg_no=agj105ukr_2&draft_no=" + draftNo + "&sp=EXEC "
			} else if (slipForm.getValue('REPORT_TYPE') == '03' || slipForm.getValue('REPORT_TYPE') == '04') {
				var groupUrl = baseInfo.gsGWUrl + "viewMode=docuDraft&prg_no=agj105ukr_1&draft_no=" + draftNo + "&sp=EXEC "
			}

			var spText	= 'omegaplus_kdg.unilite.USP_ACCNT_AGJ105TUKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
						+ ', ' + "'" + acdate + "'" + ', ' + "" + acnum + "" + ', ' + "'" + reporttype + "'" + ', ' + "''" + ', ' + "''"
						+ ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
			var spCall	= encodeURIComponent(spText); 
			frm.action	= groupUrl + spCall/* + Base64.encode()*/;
			frm.target	= "payviewer"; 
			frm.method	= "post";
			frm.submit();

			slipForm.setValue('DRAFT_NO', draftNo);
			//slipForm.setValue("EX_NUM", provider.SLIP_NUM);
			
			var draftCd = slipForm.getValue('DRAFT_CODE');
/*			if (draftCd == '' || draftCd == '0' || draftCd == null){
				slipForm.setValue('DRAFT_CODE', '1');
				gsDraftCode = '1';
			}*/
			UniAppManager.app.setSearchReadOnly(true, true);
			//Ext.getCmp('GW').setDisabled(true);
		},
		onDetailButtonDown:function() {
		},
		rejectSave: function() {
			directMasterStore1.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		}, 
		confirmSaveData: function() {
			if(directMasterStore1.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown();
				} else {
					this.rejectSave();
				}
			}
		},
		setEditableGrid:function(sInputPath, btnReset ) {
			var inputPahtStore	=  Ext.data.StoreManager.lookup('CBS_AU_A011') ;// panelSearch.getField('INPUT_PATH').getStore();
			var grid			= UniAppManager.app.getActiveGrid();

			if(sInputPath == null ) {
				if(record) {
					sInputPath = record.get('INPUT_PATH');
				}
			}
			if(sInputPath != null ) {
				Ext.each(inputPahtStore.data.items, function(item, idx) {
					if(sInputPath == item.get('value')) {
						gsInputPath = item.get('refCode3');
					}
				});
			}
			var record = grid.getSelectedRecord();
			if(record && record.get('AP_STS') == "2") {
				UniAppManager.setToolbarButtons([ 'newData','deleteAll'],false);
				tempEditMode = false;
				directMasterStore1.uniOpt.deletable =  false;
				detailForm1.setReadOnly(true);
				var tMenu1 = grid.contextMenu.down('#copyRecord');
				var tMenu2 = grid.contextMenu.down('#pasteRecord');
				tMenu1.disable();
				tMenu2.disable();
				return;
			}
			if ((gsInputPath != csINPUT_PATH && gsInputPath != "Y") || (gsInputPath ==  csINPUT_PATH)) {
				//if(btnReset) {
				UniAppManager.setToolbarButtons([ 'newData','deleteAll'],false);
				//}
				tempEditMode = false;
				directMasterStore1.uniOpt.deletable =  false;
				detailForm1.setReadOnly(true);
				var tMenu1 = grid.contextMenu.down('#copyRecord');
				var tMenu2 = grid.contextMenu.down('#pasteRecord');
				tMenu1.disable();
				tMenu2.disable();
			} else {
				//if(btnReset) {
				UniAppManager.setToolbarButtons([ 'newData','deleteAll'],true);
				//}
				gsInputPath = sInputPath;
				tempEditMode = true;
				directMasterStore1.uniOpt.deletable = true;
				detailForm1.setReadOnly(false);
				var tMenu1 = grid.contextMenu.down('#copyRecord');
				var tMenu2 = grid.contextMenu.down('#pasteRecord');
				tMenu1.enable();
				tMenu2.enable();
			}
		},
		//링크로 넘어오는 params 받는 부분 (Agj240skr)
		processParams: function(params) {
			slipForm.uniOpt.inLoading = true;
			this.uniOpt.appParams = params;
			if(!Ext.isEmpty(params)) {
				if(params.PGM_ID == 'abh300ukr') {
					panelSearch.setValue('AC_DATE',params.EX_DATE);
					panelResult.setValue('AC_DATE',params.EX_DATE);
					slipForm.setValue('AC_DATE',params.EX_DATE);
	
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('AP_STS',params.AP_STS);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('AP_STS',params.AP_STS);
					
					panelSearch.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelSearch.setValue('CHARGE_CODE' ,params.CHARGE_CODE);
					panelResult.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					panelResult.setValue('CHARGE_CODE' ,params.CHARGE_CODE);
					
	//				slipForm.setValue('INPUT_PATH',params.INPUT_PATH);
					slipForm.setValue('AP_STS',params.AP_STS);
					slipForm.setValue('IN_DIV_CODE',params.DIV_CODE);
	
					gsProcessPgmId	= params.PGM_ID;
					gsSlipNum 		= params.SLIP_NUM;
					gsSlipSeq		= params.EX_SEQ;
					
					this.onQueryButtonDown();
					//masterGrid1.getStore().loadStoreRecords();
				} else if(params.PGM_ID == 'agj230ukr') {
					if(!Ext.isEmpty(params.AC_DATE)){
						panelSearch.setValue('AC_DATE',params.AC_DATE);
						panelResult.setValue('AC_DATE',params.AC_DATE);
						slipForm.setValue('AC_DATE',params.AC_DATE);
					}else{
						panelSearch.setValue('AC_DATE',params.EX_DATE);
						panelResult.setValue('AC_DATE',params.EX_DATE);
						slipForm.setValue('AC_DATE',params.EX_DATE);
					}
	
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('AP_STS',params.AP_STS);
					
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('AP_STS',params.AP_STS);
	
					slipForm.setValue('INPUT_PATH',params.INPUT_PATH);
					slipForm.setValue('AP_STS',params.AP_STS);
					slipForm.setValue('EX_NUM',params.EX_NUM);
					slipForm.setValue('IN_DIV_CODE',params.DIV_CODE);
					slipForm.setValue('AP_CHARGE_NAME',params.CHARGE_NAME);
	
					gsProcessPgmId	= params.PGM_ID;
					gsSlipNum 		= params.SLIP_NUM;
					gsSlipSeq		= params.SLIP_SEQ;
					
					this.onQueryButtonDown();
					//masterGrid1.getStore().loadStoreRecords();
					
				} else if(params.PGM_ID == 'agj231ukr') {
					if(!Ext.isEmpty(params.AC_DATE_FR)){
						panelSearch.setValue('AC_DATE',params.AC_DATE_FR);
						panelResult.setValue('AC_DATE',params.AC_DATE_FR);
						slipForm.setValue('AC_DATE',params.AC_DATE_FR);
					}else{
						panelSearch.setValue('AC_DATE',params.EX_DATE_FR);
						panelResult.setValue('AC_DATE',params.EX_DATE_FR);
						slipForm.setValue('AC_DATE',params.EX_DATE_FR);
					}
	
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('AP_STS',params.AP_STS);
					
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('AP_STS',params.AP_STS);
	
					slipForm.setValue('INPUT_PATH',params.INPUT_PATH);
					slipForm.setValue('AP_STS',params.AP_STS);
					slipForm.setValue('EX_NUM',params.EX_NUM);
					slipForm.setValue('IN_DIV_CODE',params.DIV_CODE);
					slipForm.setValue('AP_CHARGE_NAME',params.CHARGE_NAME);
	
					gsProcessPgmId	= params.PGM_ID;
					gsSlipNum 		= params.SLIP_NUM;
					gsSlipSeq		= params.SLIP_SEQ;
					
					this.onQueryButtonDown();
					//masterGrid1.getStore().loadStoreRecords();
					
				} else if(params.PGM_ID == 'agj240skr') {
					if(!Ext.isEmpty(params.AC_DATE)){
						panelSearch.setValue('AC_DATE'	,params.AC_DATE);
						panelResult.setValue('AC_DATE'	,params.AC_DATE);
						slipForm.setValue('AC_DATE'		,params.AC_DATE);
					}else{
						panelSearch.setValue('AC_DATE'	,params.EX_DATE);
						panelResult.setValue('AC_DATE'	,params.EX_DATE);
						slipForm.setValue('AC_DATE'		,params.EX_DATE);
					}
					if(!Ext.isEmpty(params.SLIP_NUM)){
						panelSearch.setValue('EX_NUM'	,params.SLIP_NUM);
						panelResult.setValue('EX_NUM'	,params.SLIP_NUM);
						slipForm.setValue('EX_NUM'		,params.SLIP_NUM);
					}else{
						panelSearch.setValue('EX_NUM'	,params.EX_NUM);
						panelResult.setValue('EX_NUM'	,params.EX_NUM);
						slipForm.setValue('EX_NUM'		,params.EX_NUM);
					}
					panelSearch.setValue('INPUT_PATH'	,params.INPUT_PATH);
					panelResult.setValue('INPUT_PATH'	,params.INPUT_PATH);
					
					panelSearch.setValue('AP_STS'		,params.AP_STS);
					panelResult.setValue('AP_STS'		,params.AP_STS);
					slipForm.setValue('AP_STS'			,params.AP_STS);
	
					slipForm.setValue('IN_DIV_CODE'		,params.DIV_CODE);
					slipForm.setValue('IN_DEPT_CODE'		,params.DEPT_CODE);
					slipForm.setValue('IN_DEPT_NAME'		,params.DEPT_NAME);
					slipForm.setValue('CHARGE_CODE'		,params.CHARGE_CODE);
					slipForm.setValue('CHARGE_NAME'		,params.CHARGE_NAME);
	
					gsProcessPgmId	= params.PGM_ID;
					gsSlipNum 		= params.SLIP_NUM;
					gsSlipSeq		= params.SLIP_SEQ;
					
					this.onQueryButtonDown();
					//masterGrid1.getStore().loadStoreRecords();
				} else if(params.PGM_ID == 'agj245skr') {
					if(!Ext.isEmpty(params.AC_DATE_FR)){
						panelSearch.setValue('AC_DATE',params.AC_DATE_FR);
						panelResult.setValue('AC_DATE',params.AC_DATE_FR);
					}else{
						panelSearch.setValue('AC_DATE',params.EX_DATE_FR);
						panelResult.setValue('AC_DATE',params.EX_DATE_FR);
					}
					if(!Ext.isEmpty(params.SLIP_NUM)){
						panelSearch.setValue('EX_NUM',params.SLIP_NUM);
						panelResult.setValue('EX_NUM',params.SLIP_NUM);
					}else{
						panelSearch.setValue('EX_NUM',params.EX_NUM);
						panelResult.setValue('EX_NUM',params.EX_NUM);
					}
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('SLIP_SEQ',params.SLIP_SEQ);
					panelSearch.setValue('AP_STS',params.AP_STS);
					
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('SLIP_SEQ',params.SLIP_SEQ);
					panelResult.setValue('AP_STS',params.AP_STS);
	
					if(!Ext.isEmpty(params.AC_DATE_FR)){
						slipForm.setValue('AC_DATE',params.AC_DATE_FR);
					}else{
						slipForm.setValue('AC_DATE',params.EX_DATE_FR);
					}
					if(!Ext.isEmpty(params.SLIP_NUM)){
						slipForm.setValue('SLIP_NUM',params.SLIP_NUM);
					}else{
						slipForm.setValue('SLIP_NUM',params.EX_NUM);
					}
					slipForm.setValue('INPUT_PATH',params.INPUT_PATH);
					slipForm.setValue('SLIP_SEQ',params.SLIP_SEQ);
					slipForm.setValue('AP_STS',params.AP_STS);
					slipForm.setValue('IN_DIV_CODE',params.DIV_CODE);
					slipForm.setValue('DIV_NAME',params.DIV_NAME);
					slipForm.setValue('AP_CHARGE_NAME',params.CHARGE_NAME);
					
					this.onQueryButtonDown();
					//masterGrid1.getStore().loadStoreRecords();
				} else if(params.PGM_ID == 'afb800skr') {
					panelSearch.setValue('AC_DATE',params.AC_DATE);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('AP_STS',params.AP_STS);
					panelResult.setValue('AC_DATE',params.AC_DATE);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('INPUT_PATH',params.AC_DINPUT_PATHATE);
					panelResult.setValue('AP_STS',params.AP_STS);
					slipForm.setValue('IN_DIV_CODE',params.DIV_CODE);
					slipForm.setValue('IN_DEPT_CODE',params.DEPT_CODE);
					slipForm.setValue('IN_DEPT_NAME',params.DEPT_NAME);
					slipForm.setValue('CHARG_CODE',params.CHARG_CODE);
					slipForm.setValue('CHARG_NAME',params.CHARG_NAME);
					slipForm.setValue('AC_DATE2',params.AC_DATE2);
					slipForm.setValue('EX_NUM2',params.EX_NUM2);
					slipForm.setValue('SLIP_DIVI',params.SLIP_DIVI);
				} else if(params.PGM_ID == 'agj270skr') {
					panelSearch.setValue('AC_DATE'		,params.AC_DATE);
					panelSearch.setValue('EX_NUM'		,params.SLIP_NUM);
					panelSearch.setValue('INPUT_PATH'	,params.INPUT_PATH);
					panelSearch.setValue('AP_STS'		,params.AP_STS);
					
					panelResult.setValue('AC_DATE'		,params.AC_DATE);
					panelResult.setValue('EX_NUM'		,params.SLIP_NUM);
					panelResult.setValue('INPUT_PATH'	,params.INPUT_PATH);
					panelResult.setValue('AP_STS'		,params.AP_STS);
					
					slipForm.setValue('AC_DATE',params.AC_DATE);
					slipForm.setValue('EX_NUM',params.SLIP_NUM);
					slipForm.setValue('INPUT_PATH',params.INPUT_PATH);
					slipForm.setValue('AP_STS',params.AP_STS);
					slipForm.setValue('SLIP_SEQ',params.SLIP_SEQ);
					slipForm.setValue('IN_DIV_CODE',params.DIV_CODE);
					slipForm.setValue('DIV_NAME',params.DIV_NAME);
					slipForm.setValue('AP_CHARGE_NAME',params.CHARGE_NAME);
	
					gsProcessPgmId	= params.PGM_ID;
					gsSlipNum		= params.SLIP_NUM;
					gsSlipSeq		= params.SLIP_SEQ;

					masterGrid1.getStore().loadStoreRecords();
				} else if(params.PGM_ID == 'afb700skr') {
					panelSearch.setValue('AC_DATE',params.AC_DATE);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('AP_STS', '');	

					panelResult.setValue('AC_DATE',params.AC_DATE);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('AP_STS', '');	

					slipForm.setValue('AC_DATE',params.AC_DATE);
					slipForm.setValue('EX_NUM',params.EX_NUM);
					slipForm.setValue('IN_DIV_CODE',params.DIV_CODE);
					this.onQueryButtonDown();
				} else if(params.PGM_ID == 'afb700ukr') {
					panelSearch.setValue('AC_DATE',params.SLIP_DATE);
					panelResult.setValue('AC_DATE',params.SLIP_DATE);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('AP_STS',params.AP_STS);
					panelResult.setValue('AP_STS',params.AP_STS);
					this.onQueryButtonDown();
				} else if(params.PGM_ID == 'afb800ukr') {
					panelSearch.setValue('AC_DATE',params.SLIP_DATE);
					panelResult.setValue('AC_DATE',params.SLIP_DATE);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('AP_STS',params.AP_STS);
					panelResult.setValue('AP_STS',params.AP_STS);
					this.onQueryButtonDown();
				} else if(params.PGM_ID == 'agd340ukr') {
					panelSearch.setValue('AC_DATE',params.SLIP_DATE);
					panelResult.setValue('AC_DATE',params.SLIP_DATE);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					panelSearch.setValue('AP_STS',params.AP_STS);
					panelResult.setValue('AP_STS',params.AP_STS);
					this.onQueryButtonDown();
				} else if(params.PGM_ID == 'agd160ukr') {
					panelSearch.setValue('AC_DATE',params.EX_DATE);
					panelResult.setValue('AC_DATE',params.EX_DATE);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					this.onQueryButtonDown();
				} else if(params.PGM_ID == 'abh200ukr') {
					panelSearch.setValue('AC_DATE',params.EX_DATE);
					panelResult.setValue('AC_DATE',params.EX_DATE);
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
					panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
					this.onQueryButtonDown();
				}
			}
			slipForm.uniOpt.inLoading = false;
		},
		setSearchReadOnly:function(b, isOldData) {
			if(!isOldData) {
				slipForm.getField('AC_DATE').setReadOnly(b);
				slipForm.getField('EX_NUM').setReadOnly(b);
			}
			slipForm.getField('IN_DIV_CODE').setReadOnly(b);
			
			if(slipForm.getValue('DRAFT_CODE') == '1' || slipForm.getValue('DRAFT_CODE') == '3') {
				slipForm.getField('REPORT_TYPE').setReadOnly(b);
				slipForm.getField('REMARK2').setReadOnly(b);
			} 
			//전표구분은 그리드에 data여부에 따라 readOnly 적용됨
			if(directMasterStore1.count() == 0 && !b)  slipForm.getField('SLIP_DIVI').setReadOnly(false);
			else slipForm.getField('SLIP_DIVI').setReadOnly(true);
		},
		setAccntInfo:function(record, detailForm) {
			Ext.getBody().mask();
			var accnt = record.get('ACCNT');
			//UniAccnt.fnIsCostAccnt(accnt, true);
			if(accnt) {
				accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
					var rtnRecord = record;
					if(provider){
						UniAppManager.app.loadDataAccntInfo(rtnRecord, detailForm, provider)
					}else {
						var slipDivi = rtnRecord.get('SLIP_DIVI');
						if(slipDivi == '1' || slipDivi == '2') {
							if(rtnRecord.get('SPEC_DIVI') == 'A') {
								Unilite.messageBox(Msg.sMA0040);
								this.clearAccntInfo(rtnRecord, detailForm);
							}
						}
						/*Unilite.messageBox(Msg.sMA0006);
						if(fieldName) {
							record.set(fieldName, '');
						}*/
					}
					Ext.getBody().unmask();
				})
			}
		},
		loadDataAccntInfo:function(rtnRecord, detailForm, provider) {
			//관리항목 유무 
			var chkAcCode = false;
			for(var i=1; i <= 6 ; i++) {
				if(!Ext.isEmpty(rtnRecord.get('AC_CODE'+i.toString()))) {
					chkAcCode = true;
				}
			}
			if(!chkAcCode) {
				var slipDivi = rtnRecord.get('SLIP_DIVI');
				if(slipDivi == '1' || slipDivi == '2') {
					if(rtnRecord.get('SPEC_DIVI') == 'A') {
						Unilite.messageBox(Msg.sMA0040);
						this.clearAccntInfo(rtnRecord, detailForm);
						return;
					}
				}
			}
			if(!Ext.isEmpty(provider.ACCNT_CODE)) {
				rtnRecord.set("ACCNT", provider.ACCNT_CODE);
			}else if(!Ext.isEmpty(provider.ACCNT)) {
				rtnRecord.set("ACCNT", provider.ACCNT);	//이전행에서 복사한 경우 
			}
			
			detailForm.clearForm();
			rtnRecord.set("ACCNT_NAME", provider.ACCNT_NAME);
			rtnRecord.set("CUSTOM_CODE", "");
			rtnRecord.set("CUSTOM_NAME", "");
			
			rtnRecord.set("AC_CODE1", provider.AC_CODE1);
			rtnRecord.set("AC_CODE2", provider.AC_CODE2);
			rtnRecord.set("AC_CODE3", provider.AC_CODE3);
			rtnRecord.set("AC_CODE4", provider.AC_CODE4);
			rtnRecord.set("AC_CODE5", provider.AC_CODE5);
			rtnRecord.set("AC_CODE6", provider.AC_CODE6);
			
			rtnRecord.set("AC_NAME1", provider.AC_NAME1);
			rtnRecord.set("AC_NAME2", provider.AC_NAME2);
			rtnRecord.set("AC_NAME3", provider.AC_NAME3);
			rtnRecord.set("AC_NAME4", provider.AC_NAME4);
			rtnRecord.set("AC_NAME5", provider.AC_NAME5);
			rtnRecord.set("AC_NAME6", provider.AC_NAME6);
			
			rtnRecord.set("AC_DATA1", "");
			rtnRecord.set("AC_DATA2", "");
			rtnRecord.set("AC_DATA3", "");
			rtnRecord.set("AC_DATA4", "");
			rtnRecord.set("AC_DATA5", "");
			rtnRecord.set("AC_DATA6", "");
				
			rtnRecord.set("AC_DATA_NAME1", "");
			rtnRecord.set("AC_DATA_NAME2", "");
			rtnRecord.set("AC_DATA_NAME3", "");
			rtnRecord.set("AC_DATA_NAME4", "");
			rtnRecord.set("AC_DATA_NAME5", "");
			rtnRecord.set("AC_DATA_NAME6", "");
				
			rtnRecord.set("BOOK_CODE1", provider.BOOK_CODE1);
			rtnRecord.set("BOOK_CODE2", provider.BOOK_CODE2);
			rtnRecord.set("BOOK_DATA1", "");
			rtnRecord.set("BOOK_DATA2", "");
			rtnRecord.set("BOOK_DATA_NAME1", "");
			rtnRecord.set("BOOK_DATA_NAME2", "");
			
			if(rtnRecord.get("DR_CR") == "1") {
				rtnRecord.set("AC_CTL1", provider.DR_CTL1);
				rtnRecord.set("AC_CTL2", provider.DR_CTL2);
				rtnRecord.set("AC_CTL3", provider.DR_CTL3);
				rtnRecord.set("AC_CTL4", provider.DR_CTL4);
				rtnRecord.set("AC_CTL5", provider.DR_CTL5);
				rtnRecord.set("AC_CTL6", provider.DR_CTL6);
			} else if(rtnRecord.get("DR_CR") == "2") { 
				rtnRecord.set("AC_CTL1", provider.CR_CTL1);
				rtnRecord.set("AC_CTL2", provider.CR_CTL2);
				rtnRecord.set("AC_CTL3", provider.CR_CTL3);
				rtnRecord.set("AC_CTL4", provider.CR_CTL4);
				rtnRecord.set("AC_CTL5", provider.CR_CTL5);
				rtnRecord.set("AC_CTL6", provider.CR_CTL6);
			}
			rtnRecord.set("AC_TYPE1", provider.AC_TYPE1);
			rtnRecord.set("AC_TYPE2", provider.AC_TYPE2);
			rtnRecord.set("AC_TYPE3", provider.AC_TYPE3);
			rtnRecord.set("AC_TYPE4", provider.AC_TYPE4);
			rtnRecord.set("AC_TYPE5", provider.AC_TYPE5);
			rtnRecord.set("AC_TYPE6", provider.AC_TYPE6);
				
			rtnRecord.set("AC_LEN1", provider.AC_LEN1);
			rtnRecord.set("AC_LEN2", provider.AC_LEN2);
			rtnRecord.set("AC_LEN3", provider.AC_LEN3);
			rtnRecord.set("AC_LEN4", provider.AC_LEN4);
			rtnRecord.set("AC_LEN5", provider.AC_LEN5);
			rtnRecord.set("AC_LEN6", provider.AC_LEN6);
			
			rtnRecord.set("AC_POPUP1", provider.AC_POPUP1);
			rtnRecord.set("AC_POPUP2", provider.AC_POPUP2);
			rtnRecord.set("AC_POPUP3", provider.AC_POPUP3);
			rtnRecord.set("AC_POPUP4", provider.AC_POPUP4);
			rtnRecord.set("AC_POPUP5", provider.AC_POPUP5);
			rtnRecord.set("AC_POPUP6", provider.AC_POPUP6);		
	
			rtnRecord.set("AC_FORMAT1", provider.AC_FORMAT1);
			rtnRecord.set("AC_FORMAT2", provider.AC_FORMAT2);
			rtnRecord.set("AC_FORMAT3", provider.AC_FORMAT3);
			rtnRecord.set("AC_FORMAT4", provider.AC_FORMAT4);
			rtnRecord.set("AC_FORMAT5", provider.AC_FORMAT5);
			rtnRecord.set("AC_FORMAT6", provider.AC_FORMAT6);
	
			//rtnRecord.set("MONEY_UNIT", "");
			
			rtnRecord.set("ACCNT_SPEC", provider.ACCNT_SPEC);
			rtnRecord.set("SPEC_DIVI", provider.SPEC_DIVI);
			rtnRecord.set("PROFIT_DIVI", provider.PROFIT_DIVI);
			rtnRecord.set("JAN_DIVI", provider.JAN_DIVI);
				
			rtnRecord.set("PEND_YN", provider.PEND_YN);
			rtnRecord.set("PEND_CODE", provider.PEND_CODE);
			rtnRecord.set("BUDG_YN", provider.BUDG_YN);
			rtnRecord.set("BUDGCTL_YN", provider.BUDGCTL_YN);
			rtnRecord.set("FOR_YN", provider.FOR_YN);
			
			UniAppManager.app.fnGetProofKind(rtnRecord, provider.ACCNT_CODE);
			
			rtnRecord.set("CREDIT_NUM", "");
			rtnRecord.set("CREDIT_CODE", "");
			rtnRecord.set("REASON_CODE", "");
			
			var dataMap = rtnRecord.data;
			
			var prevRecord, grid = this.getActiveGrid();
			var store = grid.getStore();
			selectedIdx = store.indexOf(rtnRecord)
			if(selectedIdx >0) prevRecord = store.getAt(selectedIdx-1);
			
			UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', rtnRecord, prevRecord);
			detailForm.setActiveRecord(rtnRecord||null);
			UniAppManager.app.fnCheckPendYN(rtnRecord, detailForm);
			UniAppManager.app.fnSetBillDate(rtnRecord)
			UniAppManager.app.fnSetDefaultAcCodeI7(rtnRecord);
			UniAppManager.app.fnSetDefaultAcCodeA6(rtnRecord);
		},
		clearAccntInfo:function(record, detailForm){
			Ext.getBody().mask();
			record.set("ACCNT", "");
			record.set("ACCNT_NAME", "");
			record.set("CUSTOM_CODE", "");
			record.set("CUSTOM_NAME", "");
			
			record.set("AC_CODE1", "");
			record.set("AC_CODE2", "");
			record.set("AC_CODE3", "");
			record.set("AC_CODE4", "");
			record.set("AC_CODE5", "");
			record.set("AC_CODE6", "");
			
			record.set("AC_NAME1", "");
			record.set("AC_NAME2", "");
			record.set("AC_NAME3", "");
			record.set("AC_NAME4", "");
			record.set("AC_NAME5", "");
			record.set("AC_NAME6", "");
			
			record.set("AC_DATA1", "");
			record.set("AC_DATA2", "");
			record.set("AC_DATA3", "");
			record.set("AC_DATA4", "");
			record.set("AC_DATA5", "");
			record.set("AC_DATA6", "");
			
			record.set("AC_DATA_NAME1", "");
			record.set("AC_DATA_NAME2", "");
			record.set("AC_DATA_NAME3", "");
			record.set("AC_DATA_NAME4", "");
			record.set("AC_DATA_NAME5", "");
			record.set("AC_DATA_NAME6", "");
			
			record.set("BOOK_CODE1", "");
			record.set("BOOK_CODE2", "");
			record.set("BOOK_DATA1", "");
			record.set("BOOK_DATA2", "");
			record.set("BOOK_DATA_NAME1", "");
			record.set("BOOK_DATA_NAME2", "");
			
			record.set("AC_CTL1", "");
			record.set("AC_CTL2", "");
			record.set("AC_CTL3", "");
			record.set("AC_CTL4", "");
			record.set("AC_CTL5", "");
			record.set("AC_CTL6", "");
			
			record.set("AC_TYPE1", "");
			record.set("AC_TYPE2", "");
			record.set("AC_TYPE3", "");
			record.set("AC_TYPE4", "");
			record.set("AC_TYPE5", "");
			record.set("AC_TYPE6", "");
			
			record.set("AC_LEN1", "");
			record.set("AC_LEN2", "");
			record.set("AC_LEN3", "");
			record.set("AC_LEN4", "");
			record.set("AC_LEN5", "");
			record.set("AC_LEN6", "");
			
			record.set("AC_POPUP1", "");
			record.set("AC_POPUP2", "");
			record.set("AC_POPUP3", "");
			record.set("AC_POPUP4", "");
			record.set("AC_POPUP5", "");
			record.set("AC_POPUP6", "");
			
			record.set("AC_FORMAT1", "");
			record.set("AC_FORMAT2", "");
			record.set("AC_FORMAT3", "");
			record.set("AC_FORMAT4", "");
			record.set("AC_FORMAT5", "");
			record.set("AC_FORMAT6", "");
		
			record.set("MONEY_UNIT", "");
			
			record.set("EXCHG_RATE_O", 0);
			record.set("FOR_AMT_I", 0);
			
			record.set("ACCNT_SPEC", "");
			record.set("SPEC_DIVI", "");
			record.set("PROFIT_DIVI", "");
			record.set("JAN_DIVI", "");
			
			record.set("PEND_YN", "");
			record.set("PEND_CODE", "");
			record.set("BUDG_YN", "");
			record.set("BUDGCTL_YN", "");
			record.set("FOR_YN", "");
			
			record.set("PROOF_KIND", "");
			record.set("PROOF_KIND_NM", "");
			
			record.set("CREDIT_NUM", "");
			record.set("CREDIT_CODE", "");
			record.set("REASON_CODE", "");
			detailForm.down('#formFieldArea1').removeAll();
			Ext.getBody().unmask();
		},
		getActiveForm:function() {
			var form;
			if(tab) {
				var activeTab = tab.getActiveTab();
				var activeTabId = activeTab.getItemId();

				if(activeTabId == 'agjTab1' ) {
					form = detailForm1;
				}else {
					form = saleDetailForm;
				}
			}else {
				form = detailForm1
			}
			return form
		},
		getActiveGrid:function() {
			var grid;
			if(tab) {
				var activeTab = tab.getActiveTab();
				var activeTabId = activeTab.getItemId();
				
				if(activeTabId == 'agjTab1' ) {
					grid = masterGrid1;
				}else {
					grid = masterGrid2;
				}
			}else {
				grid = masterGrid1;
			}
			
			return grid
		},
		needNewSlipNum:function(grid, isAddRow) {
			var needNewSlipNum = false;
			var store = grid.getStore();
			var selectedRecord = grid.getSelectedRecord();
			var nextRecordIndex = store.indexOf(selectedRecord)+1;
			var nextRecord = store.getAt(nextRecordIndex);
			
			if((isAddRow && store.getCount() == 0 )) {	// 처름 행 추가 한 경우
				needNewSlipNum = true
			}else if(!isAddRow && store.getCount() == 1 ) { // 수정할 경우 다음행 없는 경우
				needNewSlipNum = true
			}else {
				var checkAmt = false;
				var drSum = slipStore1.sum('AMT_I');
				var crSum = slipStore2.sum('AMT_I');

				if( nextRecord ) {
					if(selectedRecord.get('AC_DATE') == nextRecord.get('AC_DATE') 
						&& selectedRecord.get('SLIP_NUM') == nextRecord.get('SLIP_NUM') 
					) {
						// 같은 전표번호 사이를 선택한 경우 선택된 전표번호 사용
						needNewSlipNum = false;
					}else if((drSum+crSum) != 0 && (drSum-crSum) == 0) {
						// 같은 전표번호 마지막 row 선택한 경우 차대변 합이 0 인 경우 전표번호 생성
						needNewSlipNum = true;
					}
				}else {
					if((drSum+crSum) != 0 && (drSum-crSum) == 0) {
						needNewSlipNum = true;
					}else {
						needNewSlipNum = false;
					}
				}
			}
			//return needNewSlipNum;
			return false;
		},
		fnAddSlipRecord:function(){
			var activeTab, activeTabId ;
			if(tab){
				activeTab = tab.getActiveTab();
				activeTabId = activeTab.getItemId();
			}
			var grid = this.getActiveGrid();
			var store = grid.getStore();
			
			var selectedRecord = grid.getSelectedRecord();
			var nextRecordIndex = store.indexOf(selectedRecord)+1;
			var nextRecord = store.getAt(nextRecordIndex);
				
			// 순번 생성
			var slipSeq = 1;
			var tAcDate = slipForm.getValue('AC_DATE');
			var tSlipNum = slipForm.getValue('EX_NUM');
			
			var draftyn = ''; 
			
			//if (baseInfo.gsGWUseYn == '00'){
				draftyn = '';
			//}else{
			//	draftyn = 'Y';
			//}
			
			var slipArr = Ext.Array.push(store.data.filterBy(function(record) {
					return (	record.get('AC_DATE').getTime()== tAcDate.getTime()  && record.get('SLIP_NUM')== tSlipNum ) 
				} ).items);
			if(slipArr.length > 0) {
				//Max SLIP_SEQ 를 구하기 위해 sort
				slipArr.sort(function(a,b){return b.get('SLIP_SEQ')-a.get('SLIP_SEQ') ;})	;
				slipSeq = slipArr[0].get('SLIP_SEQ') +1;
			} 
			// 순번 생성 End
			
			var slipDivi = slipForm.getValue('SLIP_DIVI');
			/*var r = {
				'AC_DATE':slipForm.getValue('AC_DATE'),
				'AC_DAY': Ext.Date.format(slipForm.getValue('AC_DATE'),'d'),
				'SLIP_NUM':slipForm.getValue('EX_NUM'),
				'SLIP_SEQ': slipSeq,
				
				'OLD_AC_DATE':slipForm.getValue('AC_DATE'),
				'OLD_SLIP_NUM':slipForm.getValue('EX_NUM'),
				'OLD_SLIP_SEQ': slipSeq,
			
				'IN_DIV_CODE':slipForm.getValue('IN_DIV_CODE'),
				'IN_DEPT_CODE':slipForm.getValue('IN_DEPT_CODE'),
				'IN_DEPT_NAME':slipForm.getValue('IN_DEPT_NAME'),
				
				'SLIP_DIVI':Ext.isEmpty(selectedRecord) ? slipDivi : selectedRecord.get("SLIP_DIVI"),
				'DR_CR':slipDivi=="1" ? "2" :(Ext.isEmpty(selectedRecord) ? "1":selectedRecord.get("DR_CR")),
				'AP_STS':'1',
				
				'DIV_CODE': Ext.isEmpty(selectedRecord) ? slipForm.getValue('IN_DIV_CODE') : selectedRecord.get('DIV_CODE'),
				'DEPT_CODE':Ext.isEmpty(selectedRecord) ? UserInfo.deptCode : selectedRecord.get('DEPT_CODE'),
				'DEPT_NAME':Ext.isEmpty(selectedRecord) ? UserInfo.deptName : selectedRecord.get('DEPT_NAME'),
				'POSTIT_YN':'N',
				'INPUT_PATH':csINPUT_PATH,
				'INPUT_USER_ID':UserInfo.userID,
				'CHARGE_CODE':'${chargeCode}'
			};*/
			 var r = {
				'AC_DATE':slipForm.getValue('AC_DATE'),
				'AC_DAY': Ext.Date.format(slipForm.getValue('AC_DATE'),'d'),
				'SLIP_NUM':slipForm.getValue('EX_NUM'),
				'SLIP_SEQ': slipSeq,
				
				'OLD_AC_DATE':slipForm.getValue('AC_DATE'),
				'OLD_SLIP_NUM':slipForm.getValue('EX_NUM'),
				'OLD_SLIP_SEQ': slipSeq,
			
				'IN_DIV_CODE':slipForm.getValue('IN_DIV_CODE'),
				'IN_DEPT_CODE':slipForm.getValue('IN_DEPT_CODE'),
				'IN_DEPT_NAME':slipForm.getValue('IN_DEPT_NAME'),
				
				'REPORT_TYPE': slipForm.getValue('REPORT_TYPE'),
				'REMARK2'	: slipForm.getValue('REMARK2'),
				
				'DRAFT_NO'	: slipForm.getValue('DRAFT_NO'),
				'DRAFT_CODE'	: slipForm.getValue('DRAFT_CODE'),
				'GW_DOC'	: slipForm.getValue('GW_DOC'),
				
				'SLIP_DIVI'		:Ext.isEmpty(selectedRecord) ? slipDivi : selectedRecord.get("SLIP_DIVI"),
				'DR_CR'			:slipDivi=="1" ? "2" :(Ext.isEmpty(selectedRecord) ? "1":selectedRecord.get("DR_CR")),
				'AP_STS'		:Ext.isEmpty(selectedRecord)  ? '1' :selectedRecord.get('AP_STS'),
				
				'DRAFT_YN'		: draftyn,
				
				'DIV_CODE'		: Ext.isEmpty(selectedRecord) ? slipForm.getValue('IN_DIV_CODE') : selectedRecord.get('DIV_CODE'),
				'DEPT_CODE'		: Ext.isEmpty(selectedRecord) ? UserInfo.deptCode : selectedRecord.get('DEPT_CODE'),
				'DEPT_NAME'		: Ext.isEmpty(selectedRecord) ? UserInfo.deptName : selectedRecord.get('DEPT_NAME'),
				'POSTIT_YN'		: 'N',
				'INPUT_PATH'	: Ext.isEmpty(selectedRecord) ? csINPUT_PATH : selectedRecord.get('INPUT_PATH'),
				'INPUT_USER_ID'	: Ext.isEmpty(selectedRecord) ? UserInfo.userID : selectedRecord.get('INPUT_USER_ID'),
				'CHARGE_CODE'	: Ext.isEmpty(selectedRecord) ? '${chargeCode}' :selectedRecord.get('CHARGE_CODE'),
				'INPUT_DIVI'	: Ext.isEmpty(selectedRecord) ? csINPUT_DIVI : selectedRecord.get('INPUT_DIVI'),
				'AUTO_SLIP_NUM'	: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('AUTO_SLIP_NUM'),
				'CLOSE_FG'		: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('CLOSE_FG'),
				'INPUT_DATE'	: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('INPUT_DATE'),
				'AP_DATE'		: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('AP_DATE'),
				'AP_USER_ID'	: Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('AP_USER_ID'),
				'AP_CHARGE_CODE': Ext.isEmpty(selectedRecord) ? '': selectedRecord.get('AP_CHARGE_CODE')
			}; 
			grid.createRow(r);
		},
		fnCopySlip: function() {
			this.setSearchReadOnly(false, false);
			slipForm.setValue('AC_DATE', UniDate.get('today'));
			Ext.getBody().mask('Loading');
			agj100ukrService.getSlipNum({'EX_DATE':UniDate.getDbDateStr(UniDate.get('today'))}, function(provider, result ) {
				slipForm.setValue('EX_NUM', provider.SLIP_NUM)
				panelSearch.setValue("EX_NUM", provider.SLIP_NUM);
				panelResult.setValue("EX_NUM", provider.SLIP_NUM);
				
				panelSearch.setValue("AC_DATE",UniDate.get('today'));
				panelResult.setValue("AC_DATE",UniDate.get('today'));
				
				var grid = UniAppManager.app.getActiveGrid();
				var selectedRecord = grid.getSelectedRecord();
				
				var records = masterGrid1.getStore().getData();
				Ext.each(records.items, function(record, idx){
					record.set('AC_DATE',slipForm.getValue('AC_DATE'));
					record.set('AC_DAY', Ext.Date.format(slipForm.getValue('AC_DATE'),'d'));
					record.set('SLIP_NUM',slipForm.getValue('EX_NUM'));
					record.set('OLD_AC_DATE',slipForm.getValue('AC_DATE'));
					record.set('OLD_SLIP_NUM',slipForm.getValue('EX_NUM'));
					record.set('INPUT_USER_ID',UserInfo.userID);
					record.set('CHARGE_CODE','${chargeCode}');
					record.set('DRAFT_CODE', Ext.isEmpty(selectedRecord) ? '':selectedRecord.get('DRAFT_CODE'));
					record.set('DRAFT_YN', Ext.isEmpty(selectedRecord) ? '':selectedRecord.get('DRAFT_YN'));
					record.set('AGREE_YN', Ext.isEmpty(selectedRecord) ? '':selectedRecord.get('AGREE_YN'));
					record.set('OPR_FLAG','N');
					record.phantom = true;
					
				});
				console.log("new record : ", masterGrid1.getStore().getNewRecords( ))
				Ext.getBody().unmask();
			});
		},
		fnSetBillDate: function(record) {
			var sExDate   = UniDate.getDbDateStr(record.get('AC_DATE'));
			var sSpecDivi =  record.get('SPEC_DIVI');
			
			if( sSpecDivi == "F1" || sSpecDivi == "F2" ) {
				this.fnSetAcCode(record, "I3", sExDate)
			}
		},
		fnSetAcCode:function(record, acCode, acValue, acNameValue) {
			var sValue =  !Ext.isEmpty(acValue)  ? acValue.toString(): "";
			var sNameValue = !Ext.isEmpty(acNameValue)  ? acNameValue.toString():"";
			var form = this.getActiveForm();
			for(var i=1 ; i <= 6; i++) {
				if( record.get('AC_CODE'+i.toString()) == acCode) { 
					record.set('AC_DATA'+i.toString(), sValue);
					record.set('AC_DATA_NAME'+i.toString(), sNameValue);
					form.setValue('AC_DATA'+i.toString(), sValue);
					form.setValue('AC_DATA_NAME'+i.toString(), sNameValue);
				}
			}
		},
		fnFindInputDivi:function(record) {
			var grid = this.getActiveGrid()
			var fRecord = grid.getStore().getAt(grid.getStore().findBy(function(rec){
				return (rec.get('AC_DATE') == record.get('AC_DATE') 
						&& rec.get('SLIP_NUM') == record.get('SLIP_NUM') 
						&& rec.get('SLIP_SEQ') != record.get('SLIP_SEQ')) ;
			}));
			if(fRecord) {
				gsInputDivi = fRecord.get('INPUT_DIVI');
			}
		},
		fnGetProofKind:function(record, billType) {
			var sSaleDivi, sProofKindSet, sBillType = billType;

			if(record.get("DR_CR") == "1" && record.get("SPEC_DIVI") == "F1") {
				sSaleDivi = "1"	;	// 매입
				if(sBillType == "")  sBillType = "51";

			}else if(record.get("DR_CR") == "2" && record.get("SPEC_DIVI") == "F2") {
				sSaleDivi = "2"		// 매출
				if(sBillType == "" ) sBillType == "11";

			}else {
				record.set("PROOF_KIND", "");
				record.set("PROOF_KIND_NM", "");
				return;
			}
			sProofKindSet = this.fnGetProofKindName(sBillType, sSaleDivi)
		
			record.set('PROOF_KIND', sProofKindSet.sBillType);
			record.set('PROOF_KIND_NM', sProofKindSet.sProofKindNm);
		},
		fnGetProofKindName:function(sBillType, sSaleDivi) {
			var sProofKindNm;
			var store = Ext.StoreManager.lookup("CBS_AU_A022");
			var selRecordIdx = store.findBy(function(record){return (record.get("value") == sBillType && record.get("refCode3")==sSaleDivi)});
			var selRecord = store.getAt(selRecordIdx);
			if(selRecord) sProofKindNm = 	selRecord.get("text");

			if(!sProofKindNm || sProofKindNm == "") {
				if(sSaleDivi == "2") {
					sBillType = "11"
				}else {
					sBillType = "51"
				}
				selRecordIdx = store.findBy(function(record){return (record.get("value") == sBillType && record.get("refCode3")==sSaleDivi)});
				var selRecord = store.getAt(selRecordIdx);
				if(selRecord) sProofKindNm = selRecord.get("text");
			}
			return {"sBillType":sBillType, "sProofKindNm":sProofKindNm};
		},
		fnCheckPendYN: function(record, form) {
			if(baseInfo.gsPendYn == "1") {
				if(record.get('PEND_YN') == 'Y') {
					if(record.get('DR_CR') != record.get('JAN_DIVI') ) {
						Unilite.messageBox(Msg.sMA0278);
						this.clearAccntInfo(record, form);
					}
				}
			}
		},
		fnChangeAcEssInput:function(record) {
			Ext.getBody().mask();
			var accnt = record.get('ACCNT');
			UniAccnt.fnIsCostAccnt(accnt, true);
			if(accnt) {
				accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
					var rtnRecord = record.obj ? record.obj:record;
					if(provider ){
						var detailForm = UniAppManager.app.getActiveForm();
						UniAppManager.app.loadDataAccntInfo(rtnRecord, detailForm, provider);
					}else {
						Unilite.messageBox(Msg.sMA0006);
					}
					Ext.getBody().unmask();
					
				})
			}
		},
		fnSetDefaultAcCodeI7:function(record, newValue) {
			var specDivi = record.get("SPEC_DIVI");
			if(specDivi != "F1" && specDivi != "F2" ) {
				return;
			}
			// 증빙유형의 참조코드1 설정값 가져오기
			if(record.get('PROOF_KIND') != "") {
				var defaultValue, defaultValueName;
				var param = {
					'MAIN_CODE':'A022',
					'SUB_CODE' : Ext.isEmpty(newValue) ? record.get('PROOF_KIND'):newValue,
					'field' : 'refCode1'
				};
				defaultValue = UniAccnt.fnGetRefCode(param);
				if(defaultValue == 'A' ||  defaultValue == 'C' || defaultValue == 'D' || defaultValue == 'B') {
						defaultValue = "Y"
				} else {
						defaultValue = "N"
				}
				var param2 = {
					'MAIN_CODE':'A149',
					'SUB_CODE' : defaultValue,
					'field' : 'text'
				};
				defaultValueName = UniAccnt.fnGetRefCode(param2);
			
				var form = this.getActiveForm();
				// 전자발행여부 default 설정
				for(var i =1 ; i <= 6; i++) {
					if(record.get('AC_CODE'+i.toString()) == "I7" ) {
						record.set('AC_DATA'+i.toString(), defaultValue);
						record.set('AC_DATA_NAME'+i.toString(), defaultValueName);
						
						form.setValue('AC_DATA'+i.toString(), defaultValue);
						form.setValue('AC_DATA_NAME'+i.toString(), defaultValueName);
						
					}
				};
				//form.setActiveRecord((record.type=='grid') ? record.obj:record);
			}
		},
		fnSetDefaultAcCodeA6:function(record) {
			if(baseInfo.gbAutoMappingA6 != "Y" ) {
				return;
			}
			var form = this.getActiveForm()
			for(var i =1 ; i <= 6; i++) {
				if(record.get('AC_CODE'+i.toString()) == "A6" ) {
					record.set('AC_DATA'+i.toString(), baseInfo.gsChargePNumb);
					record.set('AC_DATA_NAME'+i.toString(), baseInfo.gsChargePName);
				
					form.setValue('AC_DATA'+i.toString(), baseInfo.gsChargePNumb);
					form.setValue('AC_DATA_NAME'+i.toString(), baseInfo.gsChargePName);
				}
			}
			//form.setActiveRecord( (record.type=='grid') ? record.obj:record);
		},
		fnCheckNoteAmt:function(grid, record, damt, dOldAmt) {
			var lAcDataCol;
			var sSpecDivi, sDrCr;
			var isNew = false;
			//var activeTab = tab.getActiveTab();
			//var activeTabId = activeTab.getItemId();
			
			//if(activeTabId == 'agjTab1' ) {
				for(var i =1 ; i <= 6 ; i++) {
					if('C2' == record.get('AC_CODE'+i.toString())) {
						lAcDataCol = "AC_DATA"+i.toString();
					}
				}
				// 부도어음일 때 어음번호를 관리하지 않을 수 있다.
				if(Ext.isEmpty(lAcDataCol)) {
					isNew = true;
					this.fnSetTaxAmt(record);
					return
				}
			//}
			if(Ext.isEmpty(record.get(lAcDataCol))) {
				isNew = true;
				this.fnSetTaxAmt(record);
				return;
			}
			sSpecDivi = record.get('SPEC_DIVI'); 
			sDrCr =  record.get('DR_CR');  
			var noteNum = record.get(lAcDataCol);
			UniAccnt.fnGetNoteAmt(UniAppManager.app.cbCheckNoteAmt,noteNum, 0,0, record.get('PROOF_KIND'), damt, dOldAmt, record )
			
		},
		fnSetTaxAmt:function(record, taxRate, proofKind, amt_i) {
			return;
			var dSupplyAmt, sProofKind, dTaxRate, dTaxAmt=0;
			if(record.get('SPEC_DIVI') != 'F1' && record.get('SPEC_DIVI') != 'F2') {
				return;
			}
			if(amt_i) {
				dTaxAmt = amt_i;
			}else if(record.get("DR_CR")== "1") {
				dTaxAmt = record.get("DR_AMT_I");
			}else {
				dTaxAmt = record.get("CR_AMT_I");
			}
			if(taxRate) {
				dTaxRate = taxRate
			}else {
				var param={
					'MAIN_CODE':'A022',
					'SUB_CODE':proofKind ? proofKind:record.get('PROOF_KIND'),
					'field':'refCode2'
				}
				dTaxRate = UniAccnt.fnGetRefCode(param);
			}
			if(dTaxRate != 0){
				dSupplyAmt = dTaxAmt * parseInt(dTaxRate);
				
				this.fnSetAcCode(record, "I1", dSupplyAmt)	// 공급가액
				this.fnSetAcCode(record, "I6", dTaxAmt)		// 세액'
			}
		},
		fnCalTaxAmt:function(record) {
			UniAccnt.fnGetTaxRate(UniAppManager.app.cbGetTaxAmtForSales, record)
		},
		fnProofKindPopUp:function(record, newValue) {
			var proofKind = newValue ? newValue : record.get("PROOF_KIND");
			record.set("REASON_CODE", '');
//			record.set("CREDIT_NUM", '');	카드번호/현금영수증 팝업 띄울시 팝업 SEARCH FIELD에  값 셋팅 안되는 문제 때문에 수정 20161219
			
			//매입세액불공제/고정자산매입(불공)
			if(proofKind == "54" || proofKind == "61" ) {
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				record.set('CREDIT_NUM', '');

			//신용카드매입/신용카드매입(고정자산)/신용카드(의제매입)/신용카드(불공제)
			}else if(proofKind == "53" || proofKind == "68" || proofKind == "64") {
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM_EXPOS'), "CREDIT_CODE", null, "CREDIT_NUM", null, null, null,  'VALUE');
				record.set("REASON_CODE",  "");
		
			//현금영수증매입/현금영수증(고정자산)/현금영수증(불공제)
			}else if (proofKind == '62' ||proofKind == '69' ) {
				openCrediNotWin(record);
				record.set("REASON_CODE", '');
		
			//신용카드매입(불공제)
			}else if (proofKind == "70" ) {
				//openCrediNotWin(record);
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM_EXPOS'), "CREDIT_CODE", null, "CREDIT_NUM",null, null, null,  'VALUE');
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');

			//현금영수증(불공제)
			} else if(proofKind == "71" ) {
				openCrediNotWin(record);
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM'), "CREDIT_NUM", null, null, null, null,  'VALUE');

			//카드과세/면세/영세
			} else if( proofKind >= "13" && proofKind <= "17") {
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM_EXPOS'), "CREDIT_CODE", null,"CREDIT_NUM", null, null, null,  'VALUE');
				record.set("REASON_CODE", '');

			}else {	
				record.set("REASON_CODE", '');
				record.set("CREDIT_NUM", '');
			}
		},
		cbGetTaxAmt:function(taxRate,  record) {
			if(taxRate != 0){
				var dTaxAmt=0;
				if(record.get("DR_CR")== "1") {
					dTaxAmt = record.get("DR_AMT_I");
				}else {
					dTaxAmt = record.get("CR_AMT_I");
				}
				dSupplyAmt = dTaxAmt * dTaxRate;
				
				this.fnSetAcCode(record, "I1", dSupplyAmt)	// 공급가액
				this.fnSetAcCode(record, "I6", dTaxAmt)		// 세액'
			}
		},
		
		cbGetTaxAmtForSales:function(taxRate,  record) {
			var dSupplyAmt=record.get("SUPPLY_AMT_I"), sProofKind=record.get("PROOF_KIND");
			var dTmpSupplyAmt, dTaxAmt;

			if(sProofKind == "24" || sProofKind == "13" || sProofKind == "14" ) {
				dTmpSupplyAmt = dSupplyAmt / ((100 + taxRate) * 0.01)
				dTaxAmt = Math.floor(dTmpSupplyAmt * taxRate * 0.01);
				dSupplyAmt = dSupplyAmt - dTaxAmt;
				record.set("SUPPLY_AMT_I",dSupplyAmt);
				record.set("TAX_AMT_I",dTaxAmt);
			}else {
				dTaxAmt = Math.floor(dSupplyAmt * taxRate * 0.01);
				record.set("TAX_AMT_I",dTaxAmt);
			}
		},
		cbGetExistsSlipNum:function(provider, fieldName, newValue, oldValue, record) {
			if(provider.CNT != 0) {
				Unilite.messageBox(Msg.sMA0306);
				record.set('SLIP_NUM', oldValue);
				UniAppManager.app.fnFindInputDivi(record);
			}
		}, 
		cbCheckNoteAmt: function (rtn, newAmt,  oldAmt, record, fidleName) {
			var sSpecDivi = record.get("SPEC_DIVI");
			var sDrCr = record.get("DR_CR");
			var isNew = false;
			var aBankCd, aBankNm, aCustCd, aCustNm, aExpDate

			if(record) {
				var bankIdx = UniAccnt.findAcCode(record, "A3");
				 aBankCd = "AC_DATA"+bankIdx;
				 aBankNm = "AC_DATA_NAME"+bankIdx;

				var custIdx = UniAccnt.findAcCode(record, "A4");
				 aCustCd = "AC_DATA"+custIdx;
				 aCustNm = "AC_DATA_NAME"+custIdx;

				var expDateIdx = UniAccnt.findAcCode(record, "C3");
				 aExpDate = "AC_DATA"+expDateIdx;
			}
			if(rtn) {
				if(rtn.NOTE_AMT == 0 ) {
					if( !( (sSpecDivi == "D1" && sDrCr == "1") 
							|| (sSpecDivi == "D3" && sDrCr == "2") 
						 )
					){
						record.set(fidleName, oldAmt);
						/*if(!Ext.isEmpty(aBankCd) ) record.set(aBankCd, '');
						if(!Ext.isEmpty(aBankNm) ) record.set(aBankNm, '');
						if(!Ext.isEmpty(aCustCd) ) record.set(aCustCd, '');
						if(!Ext.isEmpty(aCustNm) ) record.set(aCustNm, '');
						if(!Ext.isEmpty(aExpDate) ) record.set(aExpDate, '');*/
					}else {
						isNew = true;	
					}
				}else {
					// 받을어음이 대변에 오고 결제금액을 입력하지 않았을때
					// 선택한 어음의 발행금액을 금액에 넣어준다.'
					if(Ext.isEmpty(newAmt)) {
						newAmt = 0;
					}
					if( (sSpecDivi == "D1" &&  sDrCr == "2") && newAmt ==0 ) {
						record.set("AMT_I", rtn.OC_AMT_I);
						isNew = true;
					}
					// 지급어음 or 부도어음이 차변에 오고 결제금액을 입력하지 않았을때
					// 선택한 어음의 발행금액을 금액에 넣어준다.
					else if( ((sSpecDivi == "D3" || sSpecDivi == "D4") && sDrCr == "1") && newAmt == 0 ) {
						record.set("AMT_I", rtn.OC_AMT_I);
						isNew = true;
					}
					// 받을어음, 부도어음이 차변에 오면 금액은 발행금액만 비교한다
					else if( (sSpecDivi == "D1" || sSpecDivi == "D4") && sDrCr == "1" ) {
						if(  rtn.OC_AMT_I != newAmt) {
							Unilite.messageBox(Msg.sMA0330);
							record.set(fidleName, oldAmt);
							/*if(!Ext.isEmpty(aBankCd) ) record.set(aBankCd, '');
							if(!Ext.isEmpty(aBankNm) ) record.set(aBankNm, '');
							if(!Ext.isEmpty(aCustCd) ) record.set(aCustCd, '');
							if(!Ext.isEmpty(aCustNm) ) record.set(aCustNm, '');
							if(!Ext.isEmpty(aExpDate) ) record.set(aExpDate, '');*/
							return false;
						}else {
							isNew = true;
						}
					}else {
					
						// 어음 미결제 잔액 계산 (발행금액 - 반제금액)
						var dNoteAmtI = rtn.OC_AMT_I - rtn.J_AMT_I;
						// 반결제여부 확인
						if((dNoteAmtI - newAmt) > 0) {	 
							if(!confirm(Msg.sMA0330+'\n'+Msg.sMA0333)) {
								record.set(fidleName, oldAmt);
								/*if(!Ext.isEmpty(aBankCd) ) record.set(aBankCd, '');
								if(!Ext.isEmpty(aBankNm) ) record.set(aBankNm, '');
								if(!Ext.isEmpty(aCustCd) ) record.set(aCustCd, '');
								if(!Ext.isEmpty(aCustNm) ) record.set(aCustNm, '');
								if(!Ext.isEmpty(aExpDate) ) record.set(aExpDate, '');*/
								return false;
							}else {
								isNew = true;
							}
						}else if ((dNoteAmtI - newAmt)  < 0 ) {	
							Unilite.messageBox(Msg.sMA0332);
							record.set(fidleName, oldAmt);
							/*if(!Ext.isEmpty(aBankCd) ) record.set(aBankCd, '');
							if(!Ext.isEmpty(aBankNm) ) record.set(aBankNm, '');
							if(!Ext.isEmpty(aCustCd) ) record.set(aCustCd, '');
							if(!Ext.isEmpty(aCustNm) ) record.set(aCustNm, '');
							if(!Ext.isEmpty(aExpDate) ) record.set(aExpDate, '');*/
							return false;
						}else {
							isNew = true;
						}
					}
				}
				if(isNew){
					UniAppManager.app.fnSetTaxAmt(record, rtn.TAX_RATE);
				}
			}
			return true;
			
		},
		cbGetBillDivCode:function(billDivCode, record) {
			record.set('BILL_DIV_CODE', billDivCode)
		},
		//20200702 추가
		fnControlForm: function(record) {
			if(record.get('DRAFT_CODE') == "1" || record.get('DRAFT_CODE') == "3") {
				Ext.getCmp('agj106ukrDetailForm1').setReadOnly(true);
			} else {
				Ext.getCmp('agj106ukrDetailForm1').setReadOnly(false);
			}
		}
	});	// Main



	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid1,
		forms	: {'formA:':detailForm1},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue) {
				return true;
			}
			var rv = true;
			switch(fieldName) {
				case 'AC_DAY':
					if(!UniAccnt.isNumberString(newValue)) {
						rv = Msg.sMA0076;
						return rv;
					}
					var sDate = newValue.length == 1 ? '0'+newValue : newValue;
					var acDate = UniDate.getMonthStr(panelSearch.getValue('AC_DATE_TO'))+sDate;
					if(acDate.length == 8 && Ext.Date.isValid(parseInt(acDate.substring(0,4)), parseInt(acDate.substring(4,6)),parseInt(acDate.substring(6,8)))) {
						if(newValue != sDate) record.set(fieldName, sDate);
						record.set('AC_DATE', UniDate.extParseDate(acDate));
						
						var isNew=false;
						if(directMasterStore1.getCount() == 1 && record.obj.phantom) {
							isNew=true;
						}
						if(UniAppManager.app.needNewSlipNum(this.grid, isNew) ) {
							Ext.getBody().mask();
							agj100ukrService.getSlipNum({'EX_DATE':acDate}, function(provider, result) {
								var rec = record;
								var tAcDate = acDate;
								var tSDate = sDate;
								if(provider.SLIP_NUM) {
									rec.set('SLIP_NUM', provider.SLIP_NUM);
									// 수정된 데이타의 경우 이전 전표번호가 같은 데이타인 경우 변견된 전표일자와
									// 전표번호로 변경해 준다.
									Ext.each(directMasterStore1.data.items, function(item, idx) {
										if(Ext.isEmpty(rec.get('OLD_SLIP_NUM')) && rec.get('OLD_SLIP_NUM') == item.get('OLD_SLIP_NUM')) {
											item.set('AC_DATE',tAcDate);
											item.set('AC_DAY',tSDate);
											item.set('SLIP_NUM',provider.SLIP_NUM);
											
											if(item.phantom) {
												item.set('OLD_AC_DATE',tAcDate);
												item.set('OLD_AC_DATE',tAcDate);
											}
										}
									})
								}
								if(record.obj.phantom) {
									record.set('OLD_AC_DATE', record.get('AC_DATE'));
								}
								UniAppManager.app.fnSetBillDate(record);
								UniAppManager.app.fnFindInputDivi(record);
								record.set('INPUT_DIVI',gsInputDivi);
								Ext.getBody().unmask();
							});	
						}else {
							
							// 수정된 데이타의 경우 이전 전표번호가 같은 데이타인 경우 변견된 전표일자와 전표번호로
							// 변경해 준다.
							Ext.each(directMasterStore1.data.items, function(item, idx) {
								if(Ext.isEmpty(record.get('OLD_SLIP_NUM')) && record.get('OLD_SLIP_NUM') == item.get('OLD_SLIP_NUM')) {
									item.set('AC_DATE',acDate);
									item.set('AC_DAY',sDate);
									item.set('SLIP_NUM',record.get('SLIP_NUM'));
									
									if(item.phantom) {
										item.set('OLD_AC_DATE',tAcDate);
										item.set('OLD_AC_DATE',tAcDate);
									}
								}
							})
							
							if(record.obj.phantom) {
								record.set('OLD_AC_DATE', record.get('AC_DATE'));
							}
							UniAppManager.app.fnSetBillDate(record);
							UniAppManager.app.fnFindInputDivi(record);
							record.set('INPUT_DIVI', gsInputDivi);
						}
					} else {
						rv =Msg.sMA0076 ;
					}
					
				break;
				case 'SLIP_NUM' :
					if(oldValue != newValue) {
						if(!record.obj.phantom ) {
							UniAccnt.fnGetExistSlipNum(UniAppManager.app.cbGetExistsSlipNum, record, csSLIP_TYPE, record.get('AC_DATE'), newValue, oldValue);
						}else {
							record.set('OLD_SLIP_NUM', newValue);
						}
					}
					break;
				case 'SLIP_SEQ' :
					if(record.obj.phantom) {
						record.set('OLD_SLIP_SEQ', newValue);
					}
					break;
				case 'DR_CR':
					if(newValue == "" ) {
						rv = false;
						return rv;
					}
					var slipDivi = slipForm.getValue('SLIP_DIVI')
					if (newValue == '1') {
						if(slipDivi =='3') {
							record.set('SLIP_DIVI',"3");
						}else if( slipDivi == '2'){
							record.set('SLIP_DIVI',"2");
						} else {
							rv = false;
							return rv;
						}
						record.set('DR_AMT_I',record.get('CR_AMT_I'));
						record.set('CR_AMT_I',0);
						record.set('AMT_I',record.get('DR_AMT_I'));
						
					}else{
						if(slipDivi =='3') {
							record.set('SLIP_DIVI',"4");
						}else if( slipDivi == '1'){
							record.set('SLIP_DIVI',"1");
						} else {
							rv = false;
							return rv;
						}
						record.set('CR_AMT_I',record.get('DR_AMT_I'));
						record.set('DR_AMT_I',0);
						record.set('AMT_I',record.get('CR_AMT_I'));

						if (newValue == '1') {
							record.set('SLIP_DIVI',"1");
						}else {
							record.set('SLIP_DIVI',"4");
						}

						sAccnt = record.get('ACCNT');
						UniAccnt.fnIsCostAccnt(sAccnt, false);
					}
					console.log("SLIP_DIVI change :", record)
					UniAppManager.app.fnCheckPendYN(record, detailForm1);

					record.set('PROOF_KIND','');
					record.set('PROOF_KIND_NM','');

					UniAppManager.app.fnChangeAcEssInput(record)

					if (oldValue == "3" ) {
						if (newValue == "1" || newValue == "2") {
							record.set('ACCNT', '');
							record.set('ACCNT_NAME', '');
						}
					}
					UniAppManager.app.fnSetBillDate(record);
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					 UniAppManager.app.fnSetDefaultAcCodeI7(record)

					// 입력자의 사번을 이용해 관리항목(사번) 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeA6(record)	
					if(!Ext.isEmpty(record.get('SPEC_DIVI'))) {
						var specDivi = record.get('SPEC_DIVI');
						if(specDivi && specDivi.substring(0,1) == "D" ) {
							UniAppManager.app.fnCheckNoteAmt(this.grid, record, record.get('AMT_I'), record.get('AMT_I'));
						}
					}
					break;
				case 'DR_AMT_I' :
					if(record.get('SLIP_DIVI') == '1' || record.get('SLIP_DIVI') == '4' ) {
						rv =false;
						return rv;
					}
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" ) {
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue)
					}
					if(record.get('DR_CR') == '1') {
						record.set('AMT_I', newValue);
					}
					UniAppManager.app.fnSetTaxAmt(record, null, null, newValue);
					break;
				case 'CR_AMT_I' :
					if(record.get('SLIP_DIVI') == '2' || record.get('SLIP_DIVI') == '3' ) {
						rv =false;
						return rv;
					}
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" ) {
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue)
					}
					if(record.get('DR_CR') == '2') {
						record.set('AMT_I', newValue);
					}
					UniAppManager.app.fnSetTaxAmt(record, null, null, newValue);
					break;
				case 'PROOF_KIND':
					record.set("REASON_CODE", '');
					record.set("CREDIT_NUM", '');
					record.set("CREDIT_NUM_EXPOS", '');
					UniAppManager.app.fnProofKindPopUp(record, newValue);
					UniAppManager.app.fnSetTaxAmt(record)
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeI7(record, newValue)
					break;
				case 'DIV_CODE':
					UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, record, newValue);
					break;
				default:
					break;
			}
			return rv;
		}
	}); // validator01
}; // main
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
	<input type="hidden" id="loginid" name="loginid" value="superadmin" />
	<input type="hidden" id="fmpf" name="fmpf" value="" />
	<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>