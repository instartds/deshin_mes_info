<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba800ukr">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A005"/>	<!-- 입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A127"/>	<!-- 분개구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"/>	<!-- 증빙유형 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >
var creditNoWin;				// 신용카드번호 & 현금영수증 팝업
var comCodeWin ;				// A070 증빙유형팝업
var creditWIn;					// 신용카드팝업
var foreignWindow;				//외화금액입력
var taxWindow;					//부가세 정보 팝업

function appMain() {
	var gsChargeCode	= '${getChargeCode}';
	var gsChargeDivi	= '${gsChargeDivi}';
	var gsProofKindList	= ${proofKindList};
	var gsAmtEnter		= '${gsAmtEnter}';		//'전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
	var gsAmtPoint		= ${gsAmtPoint};

	Unilite.defineModel('aba800ukrSlipModel', {
		fields: [
			 {name: 'SLIP_NUM'		,text:'번호'		,type : 'int'}
			,{name: 'SLIP_SEQ'		,text:'순번'		,type : 'int'}
			,{name: 'ACCNT'			,text:'계정코드'	,type : 'string'}
			,{name: 'ACCNT_NAME'	,text:'계정과목명'	,type : 'string'}
			,{name: 'AMT_I'			,text:'금액'		,type : 'uniPrice'}
		]
	});

	var slipStore1 = Unilite.createStore('agj100ukrSlipStore1',{
		model	: 'aba800ukrSlipModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function(store) {
			var data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('SLIP_DIVI') == '2' || record.get('SLIP_DIVI') == '3') } ).items);
			var data2 = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('SLIP_DIVI') == '1' || record.get('SLIP_DIVI') == '4') } ).items);
			Ext.each(data2, function(rec, idx){
				if(rec.get('SLIP_DIVI')=='1' || rec.get('SLIP_DIVI')=='2')
				data.push({'SLIP_NUM':rec.get('SLIP_NUM'), 'SLIP_SEQ':rec.get('SLIP_SEQ'), 'ACCNT':'11110', 'ACCNT_NAME':'현금', 'AMT_I':rec.get('AMT_I') })
			});
			this.loadData(data);
			console.log("slipGrid1:", slipGrid1);
			console.log("slipGrid1.frame:", slipGrid1.frame);
		}
	});

	var slipGrid1 = Unilite.createGrid('agj100ukrAccGrid1', {
		store		: slipStore1,
		region		: 'west',
		border		: true,
		hideHeaders	: true,
		flex		: .5,
		height		: 150,
		uniOpt		: {
			expandLastColumn	: false,
			useMultipleSorting	: false
//			userToolbar:false
		},
		features: [{
			id				: 'slipGrid1Total',
			ftype			: 'uniSummary',
			showSummaryRow	: true,
			dock			: 'bottom',
			style			: { width:450 }
		}],
		columns:[
			{ dataIndex: 'ACCNT'		,width: 100 ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{ dataIndex: 'ACCNT_NAME'	,flex:1 },
			{ dataIndex: 'AMT_I'		,width: 150	,summaryType:'sum'}
		]
	});

	var slipStore2 = Unilite.createStore('agj100ukrSlipStore2',{
		model	: 'aba800ukrSlipModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function(store) {
			var data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('SLIP_DIVI') == '1' || record.get('SLIP_DIVI') == '4') } ).items);
			var data2 = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('SLIP_DIVI') == '2' || record.get('SLIP_DIVI') == '3') } ).items);
			Ext.each(data2, function(rec, idx){
				if(rec.get('SLIP_DIVI')=='1' || rec.get('SLIP_DIVI')=='2')
				data.push({'SLIP_NUM':rec.get('SLIP_NUM'), 'SLIP_SEQ':rec.get('SLIP_SEQ'), 'ACCNT':'11110', 'ACCNT_NAME':'현금', 'AMT_I':rec.get('AMT_I') })
			});
			this.loadData(data);
		}
	});

	var slipGrid2 = Unilite.createGrid('agj100ukrAccGrid2', {
		store		: slipStore2,
		region		: 'center',
		border		: true,
		flex		: .5,
		height		: 150,
		hideHeaders	: true,
		border		: false,
		uniOpt		: {
			expandLastColumn	: false,
			useMultipleSorting	: false
		},
		features: [{
			id				: 'slipGrid1Total',
			ftype			: 'uniSummary',
			showSummaryRow	: true,
			dock			: 'bottom',
			style			: { width:450 }
		}],
		columns:[
			{ dataIndex: 'ACCNT'		,width: 100 ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{ dataIndex: 'ACCNT_NAME'	,flex:1 },
			{ dataIndex: 'AMT_I'		,width: 150	,summaryType:'sum'}
		],
		listeners:{
			afterrender:function(grid, eOpts) {
				grid.dockedItems.hidden = true;
				grid.getView().refresh()
			}
		}
	});

	var slipContainer = {
		xtype	: 'container',
		layout	: 'hbox',
		border	: false,
		height	: 150,
		items	: [
			slipGrid1,
			slipGrid2
		]
	}



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Aba800ukrModel1', {
		fields: [
			{name: 'AUTO_CD'			, text: '자동분개'				, type: 'string'},
			{name: 'AUTO_NM'			, text: '자동분개명'				, type: 'string'},
			{name: 'AUTO_GUBUN'			, text: '분개구분'				, type: 'string', comboType: 'AU', comboCode: 'A127'},
			{name: 'AUTO_DATA'			, text: 'AUTO_DATA'			, type: 'string'},
			{name: 'AUTO_DATA_NAME'		, text: 'AUTO_DATA_NAME'	, type: 'string'},
			{name: 'USER_ID'			, text: '사용자'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'				, type: 'string'},
			{name: 'DEPT_CODE'			, text: '사용부서'				, type: 'string'},
			{name: 'DEPT_NAME'			, text: '사용부서'				, type: 'string'},
			{name: 'KEY_STRING'			, text: 'KEY_STRING'		, type: 'string'}
		]
	});

	Unilite.defineModel('Aba800ukrModel2', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'SLIP_DIVI'			, text: '구분'			, type: 'string', comboType: 'AU', comboCode: 'A005'},
			{name: 'ACCNT'				, text: '계정코드'			, type: 'string', allowBlank: false},
			{name: 'ACCNT_NAME'			, text: '계정과목명'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '거래처'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'			, type: 'string'},
			{name: 'AMT_I'				, text: '금액'			, type: 'uniPrice'},
			{name: 'REMARK'				, text: '적요'			, type: 'string'},
			{name: 'PROOF_KIND'			, text: '증빙유형'			, type: 'string', comboType: 'AU', comboCode: 'A022'},
			{name: 'DEPT_CODE'			, text: '귀속부서'			, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '귀속사업장'			, type: 'string', comboType: 'BOR120', allowBlank: false},
			{name: 'AUTO_CD'			, text: '자동분개코드'		, type: 'string'},
			{name: 'SEQ'				, text: '순번'			, type: 'int'},
			{name: 'PROOF_KIND_NM'		, text: 'PROOF_KIND_NM'	, type: 'string'},
			{name: 'DR_CR'				, text: 'DR_CR'			, type: 'string'},
			{name: 'SPEC_DIVI'			, text: 'SPEC_DIVI'		, type: 'string'},
			{name: 'AC_CODE1'			, text: 'AC_CODE1'		, type: 'string'},
			{name: 'AC_CODE2'			, text: 'AC_CODE2'		, type: 'string'},
			{name: 'AC_CODE3'			, text: 'AC_CODE3'		, type: 'string'},
			{name: 'AC_CODE4'			, text: 'AC_CODE4'		, type: 'string'},
			{name: 'AC_CODE5'			, text: 'AC_CODE5'		, type: 'string'},
			{name: 'AC_CODE6'			, text: 'AC_CODE6'		, type: 'string'},
			{name: 'AC_NAME1'			, text: 'AC_NAME1'		, type: 'string'},
			{name: 'AC_NAME2'			, text: 'AC_NAME2'		, type: 'string'},
			{name: 'AC_NAME3'			, text: 'AC_NAME3'		, type: 'string'},
			{name: 'AC_NAME4'			, text: 'AC_NAME4'		, type: 'string'},
			{name: 'AC_NAME5'			, text: 'AC_NAME5'		, type: 'string'},
			{name: 'AC_NAME6'			, text: 'AC_NAME6'		, type: 'string'},
			{name: 'AC_DATA1'			, text: 'AC_DATA1'		, type: 'string'},
			{name: 'AC_DATA2'			, text: 'AC_DATA2'		, type: 'string'},
			{name: 'AC_DATA3'			, text: 'AC_DATA3'		, type: 'string'},
			{name: 'AC_DATA4'			, text: 'AC_DATA4'		, type: 'string'},
			{name: 'AC_DATA5'			, text: 'AC_DATA5'		, type: 'string'},
			{name: 'AC_DATA6'			, text: 'AC_DATA6'		, type: 'string'},
			{name: 'AC_DATA_NAME1'		, text: 'AC_DATA_NAME1'	, type: 'string'},
			{name: 'AC_DATA_NAME2'		, text: 'AC_DATA_NAME2'	, type: 'string'},
			{name: 'AC_DATA_NAME3'		, text: 'AC_DATA_NAME3'	, type: 'string'},
			{name: 'AC_DATA_NAME4'		, text: 'AC_DATA_NAME4'	, type: 'string'},
			{name: 'AC_DATA_NAME5'		, text: 'AC_DATA_NAME5'	, type: 'string'},
			{name: 'AC_DATA_NAME6'		, text: 'AC_DATA_NAME6'	, type: 'string'},
			{name: 'AC_TYPE1'			, text: 'AC_TYPE1'		, type: 'string'},
			{name: 'AC_TYPE2'			, text: 'AC_TYPE2'		, type: 'string'},
			{name: 'AC_TYPE3'			, text: 'AC_TYPE3'		, type: 'string'},
			{name: 'AC_TYPE4'			, text: 'AC_TYPE4'		, type: 'string'},
			{name: 'AC_TYPE5'			, text: 'AC_TYPE5'		, type: 'string'},
			{name: 'AC_TYPE6'			, text: 'AC_TYPE6'		, type: 'string'},
			{name: 'AC_LEN1'			, text: 'AC_LEN1'		, type: 'string'},
			{name: 'AC_LEN2'			, text: 'AC_LEN2'		, type: 'string'},
			{name: 'AC_LEN3'			, text: 'AC_LEN3'		, type: 'string'},
			{name: 'AC_LEN4'			, text: 'AC_LEN4'		, type: 'string'},
			{name: 'AC_LEN5'			, text: 'AC_LEN5'		, type: 'string'},
			{name: 'AC_LEN6'			, text: 'AC_LEN6'		, type: 'string'},
			{name: 'AC_POPUP1'			, text: 'AC_POPUP1'		, type: 'string'},
			{name: 'AC_POPUP2'			, text: 'AC_POPUP2'		, type: 'string'},
			{name: 'AC_POPUP3'			, text: 'AC_POPUP3'		, type: 'string'},
			{name: 'AC_POPUP4'			, text: 'AC_POPUP4'		, type: 'string'},
			{name: 'AC_POPUP5'			, text: 'AC_POPUP5'		, type: 'string'},
			{name: 'AC_POPUP6'			, text: 'AC_POPUP6'		, type: 'string'}
		]
	});

	/** 마스터Grid Store 정의(Service 정의)
	 * @type
	 */
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aba800ukrService.selectMasterList',
			create	: 'aba800ukrService.insertMaster',
			update	: 'aba800ukrService.updateMaster',
			destroy	: 'aba800ukrService.deleteMaster',
			syncAll	: 'aba800ukrService.saveMasterAll'
		}
	});

	/** 디테일Grid Store 정의(Service 정의)
	 * @type
	 */
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'aba800ukrService.selectDetailList',
			update	: 'aba800ukrService.updateDetail',
			create	: 'aba800ukrService.insertDetail',
			destroy	: 'aba800ukrService.deleteDetail',
			syncAll	: 'aba800ukrService.saveAll'
		}
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('aba900ukrMasterStore1',{
		model	: 'Aba800ukrModel1',
		proxy	: directMasterProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부 , detail이 모두 삭제되면 삭제됨
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= panelSearch.getValues();
//			if(autoCd){
//				param.AUTO_CD = autoCd;
//			}
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector) {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 && innerForm.isValid()) {
				if(directDetailStore.count() == 0 && directDetailStore.getRemovedRecords( ).length == 0) {
					Unilite.messageBox("자동분개 상세내역을 등록해 주세요.");
					return;
				}
				this.syncAllDirect();
			}
		}
	});

	var directDetailStore = Unilite.createStore('aba800ukrMasterStore2',{
		model	: 'Aba800ukrModel2',
		proxy	: directDetailProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			if(innerForm.isValid()) {
				innerForm.setAllFieldsReadOnly(true);
				var param= innerForm.getValues();
				console.log( param );
				this.load({
					params : param
				});
			} else {
				var invalid = innerForm.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
				Unilite.messageBox(labelText+Msg.sMB083);
				invalid.items[0].focus();
			}
		},
		saveStore : function(selector) {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 && innerForm.isValid()) {
				var config = {
					params:[innerForm.getValues()],
					success : function(batch, option) {
						var master = batch.operations[0].getResultSet();
						if(master) innerForm.setValue('AUTO_CD', master.AUTO_CD);
						directMasterStore.commitChanges();

						if(directDetailStore.getCount() == 0){
							slipGrid1.getStore().loadData({});
							slipGrid2.getStore().loadData({});
//							UniAppManager.app.onResetButtonDown();
						}
					}
				}
				this.syncAllDirect(config);
			} else {
				if(inValidRecs.length > 0) {
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		},
		slipGridChange:function(){
			slipStore1.loadStoreRecords(this);
			slipStore2.loadStoreRecords(this);
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
//				if(records == null || records.length == 0) {
//					gsDraftYN   = "N"
//					gsInputDivi = csINPUT_DIVI;
//				}
			},
			add:function( store, records, index, eOpts ) {
			},
			update:function( store, record, operation, modifiedFieldNames, details, eOpts) {
				this.slipGridChange();
			},
			datachanged:function( store,  eOpts ) {
				this.slipGridChange();
			},
			remove:function( store, records, index, isMove, eOpts ) {
			}
		}
	});

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
		items: [{
			title		: '기본정보',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '분개구분',
				name		: 'AUTO_GUBUN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A127',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						var sUserid1	= panelSearch.getField('USER_ID');
						var sUserid2	= panelResult.getField('USER_ID');
						var sDeptCd1	= panelSearch.getField('DEPT_CODE');
						var sDeptCd2	= panelResult.getField('DEPT_CODE');
						var sDeptNm1	= panelSearch.getField('DEPT_NAME');
						var sDeptNm2	= panelResult.getField('DEPT_NAME');
						var sdivC1		= panelSearch.getField('DIV_CODE');
						var sdivC2		= panelResult.getField('DIV_CODE');
						if(newValue == "01"){			//개인
							panelSearch.setValue('USER_ID'	, UserInfo.userID);
							panelResult.setValue('USER_ID'	, UserInfo.userID);
							panelSearch.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
							panelResult.setValue('DEPT_NAME', '');
							panelSearch.setValue('DIV_CODE'	, '');
							panelResult.setValue('DIV_CODE'	, '');
							if(gsChargeDivi != '1'){	//회계부서가 아닐 경우
								sUserid1.setReadOnly(true);
								sUserid2.setReadOnly(true);
							} else {
								sUserid1.setReadOnly(false);
								sUserid2.setReadOnly(false);
							}
							sDeptCd1.setReadOnly(true);
							sDeptCd2.setReadOnly(true);
							sDeptNm1.setReadOnly(true);
							sDeptNm2.setReadOnly(true);
							sdivC1.setReadOnly(true);
							sdivC2.setReadOnly(true);

						} else if(newValue == "02"){	//부서
							panelSearch.setValue('USER_ID'	, '');
							panelResult.setValue('USER_ID'	, '');
							panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
							panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
							panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
							panelResult.setValue('DEPT_NAME', UserInfo.deptName);
							panelSearch.setValue('DIV_CODE'	, '');
							panelResult.setValue('DIV_CODE'	, '');

							sUserid1.setReadOnly(true);
							sUserid2.setReadOnly(true);
							if(gsChargeDivi != '1'){	//회계부서가 아닐 경우
								sDeptCd1.setReadOnly(true);
								sDeptCd2.setReadOnly(true);
								sDeptNm1.setReadOnly(true);
								sDeptNm2.setReadOnly(true);
							} else {
								sDeptCd1.setReadOnly(false);
								sDeptCd2.setReadOnly(false);
								sDeptNm1.setReadOnly(false);
								sDeptNm2.setReadOnly(false);
							}
							sdivC1.setReadOnly(true);
							sdivC2.setReadOnly(true);

						} else if(newValue == "03"){	//사업장
							panelSearch.setValue('USER_ID'	, '');
							panelResult.setValue('USER_ID'	, '');
							panelSearch.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
							panelResult.setValue('DEPT_NAME', '');
							panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
							panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
							sUserid1.setReadOnly(true);
							sUserid2.setReadOnly(true);
							sDeptCd1.setReadOnly(true);
							sDeptCd2.setReadOnly(true);
							sDeptNm1.setReadOnly(true);
							sDeptNm2.setReadOnly(true);
							if(gsChargeDivi != '1'){	//회계부서가 아닐 경우
								sdivC1.setReadOnly(true);
								sdivC2.setReadOnly(true);
							} else {
								sdivC1.setReadOnly(false);
								sdivC2.setReadOnly(false);
							}
							if(gsChargeDivi != '1'){	//회계부서가 아닐 경우
								sUserid1.setReadOnly(true);
								sUserid2.setReadOnly(true);
								sDeptCd1.setReadOnly(true);
								sDeptCd2.setReadOnly(true);
								sDeptNm1.setReadOnly(true);
								sDeptNm2.setReadOnly(true);
								sdivC1.setReadOnly(true);
								sdivC2.setReadOnly(true);
							}
						} else {
							panelSearch.setValue('USER_ID'	, '');
							panelResult.setValue('USER_ID'	, '');
							panelSearch.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
							panelResult.setValue('DEPT_NAME', '');
							panelSearch.setValue('DIV_CODE'	, '');
							panelResult.setValue('DIV_CODE'	, '');
							sUserid1.setReadOnly(true);
							sUserid2.setReadOnly(true);
							sDeptCd1.setReadOnly(true);
							sDeptCd2.setReadOnly(true);
							sDeptNm1.setReadOnly(true);
							sDeptNm2.setReadOnly(true);
							sdivC1.setReadOnly(true);
							sdivC2.setReadOnly(true);
						}
						panelResult.setValue('AUTO_GUBUN', newValue);
					}
				}
			},
			Unilite.popup('USER_SINGLE', {
				textFieldName	: 'USER_ID',
				DBtextFieldName	: 'USER_ID',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('USER_ID', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('USER_ID', newValue);
					},
					applyextparam: function(popup){
					}
				}
			}),
			Unilite.popup('DEPT', {
				fieldLabel		: '사용부서',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);
					},
					applyextparam: function(popup){
					}
				}
			}),{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}]
		}],
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '분개구분',
			name		: 'AUTO_GUBUN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A127',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					var sUserid1 = panelSearch.getField('USER_ID');
					var sUserid2 = panelResult.getField('USER_ID');
					var sDeptCd1 = panelSearch.getField('DEPT_CODE');
					var sDeptCd2 = panelResult.getField('DEPT_CODE');
					var sDeptNm1 = panelSearch.getField('DEPT_NAME');
					var sDeptNm2 = panelResult.getField('DEPT_NAME');
					var sdivC1   = panelSearch.getField('DIV_CODE');
					var sdivC2   = panelResult.getField('DIV_CODE');
					if(newValue == "01"){			//개인
						panelSearch.setValue('USER_ID'	, UserInfo.userID);
						panelResult.setValue('USER_ID'	, UserInfo.userID);
						panelSearch.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
						panelResult.setValue('DEPT_NAME', '');
						panelSearch.setValue('DIV_CODE'	, '');
						panelResult.setValue('DIV_CODE'	, '');
						if(gsChargeDivi != '1'){	//회계부서가 아닐 경우
							sUserid1.setReadOnly(true);
							sUserid2.setReadOnly(true);
						} else {
							sUserid1.setReadOnly(false);
							sUserid2.setReadOnly(false);
						}
						sDeptCd1.setReadOnly(true);
						sDeptCd2.setReadOnly(true);
						sDeptNm1.setReadOnly(true);
						sDeptNm2.setReadOnly(true);
						sdivC1.setReadOnly(true);
						sdivC2.setReadOnly(true);
					} else if(newValue == "02"){	//부서
						panelSearch.setValue('USER_ID'	, '');
						panelResult.setValue('USER_ID'	, '');
						panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
						panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
						panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
						panelResult.setValue('DEPT_NAME', UserInfo.deptName);
						panelSearch.setValue('DIV_CODE'	, '');
						panelResult.setValue('DIV_CODE'	, '');

						sUserid1.setReadOnly(true);
						sUserid2.setReadOnly(true);
						if(gsChargeDivi != '1'){	//회계부서가 아닐 경우
							sDeptCd1.setReadOnly(true);
							sDeptCd2.setReadOnly(true);
							sDeptNm1.setReadOnly(true);
							sDeptNm2.setReadOnly(true);
						} else {
							sDeptCd1.setReadOnly(false);
							sDeptCd2.setReadOnly(false);
							sDeptNm1.setReadOnly(false);
							sDeptNm2.setReadOnly(false);
						}
						sdivC1.setReadOnly(true);
						sdivC2.setReadOnly(true);
					} else if(newValue == "03"){	//사업장
						panelSearch.setValue('USER_ID'	, '');
						panelResult.setValue('USER_ID'	, '');
						panelSearch.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
						panelResult.setValue('DEPT_NAME', '');
						panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
						panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
						sUserid1.setReadOnly(true);
						sUserid2.setReadOnly(true);
						sDeptCd1.setReadOnly(true);
						sDeptCd2.setReadOnly(true);
						sDeptNm1.setReadOnly(true);
						sDeptNm2.setReadOnly(true);
						if(gsChargeDivi != '1'){ //회계부서가 아닐 경우
							sdivC1.setReadOnly(true);
							sdivC2.setReadOnly(true);
						} else {
							sdivC1.setReadOnly(false);
							sdivC2.setReadOnly(false);
						}

					} else {
						panelSearch.setValue('USER_ID'	, '');
						panelResult.setValue('USER_ID'	, '');
						panelSearch.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
						panelResult.setValue('DEPT_NAME', '');
						panelSearch.setValue('DIV_CODE'	, '');
						panelResult.setValue('DIV_CODE'	, '');
						sUserid1.setReadOnly(true);
						sUserid2.setReadOnly(true);
						sDeptCd1.setReadOnly(true);
						sDeptCd2.setReadOnly(true);
						sDeptNm1.setReadOnly(true);
						sDeptNm2.setReadOnly(true);
						sdivC1.setReadOnly(true);
						sdivC2.setReadOnly(true);
					}
					panelSearch.setValue('AUTO_GUBUN', newValue);
				}
			}
		},
		Unilite.popup('USER_SINGLE', {
			textFieldName	: 'USER_ID',
			DBtextFieldName	: 'USER_ID',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('USER_ID', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('USER_ID', newValue);
				},
				applyextparam: function(popup){

				}
			}
		}),
		Unilite.popup('DEPT', {
			fieldLabel		: '사용부서',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);
				},
				applyextparam: function(popup){
				}
			}
		}),{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}],
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});

	var innerForm = Unilite.createSearchForm('aba800ukrInnerForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 2},
		masterGrid	: masterGrid,
		disabled	: false,
		padding		: '1 1 1 1',
		border		: true,
		items		: [{
			fieldLabel	: '분개구분',
			name		: 'AUTO_GUBUN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A127',
			allowBlank	: false,
			value		: '04',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(!innerForm.uniOpt.inLoading){
						var sUserid = innerForm.getField('USER_ID');
						var sDeptCd = innerForm.getField('DEPT_CODE');
						var sDeptNm = innerForm.getField('DEPT_NAME');
						var sdivC   = innerForm.getField('DIV_CODE');

						if(newValue == "01"){			//개인
							innerForm.setValue('USER_ID'	, UserInfo.userID);
							innerForm.setValue('DEPT_CODE'	, '');
							innerForm.setValue('DEPT_NAME'	, '');
							innerForm.setValue('DIV_CODE'	, '');
							if(gsChargeDivi != '1'){	//회계부서가 아닐 경우
								sUserid.setReadOnly(true);
							} else {
								sUserid.setReadOnly(false);
							}
							sDeptCd.setReadOnly(true);
							sDeptNm.setReadOnly(true);
							sdivC.setReadOnly(true);
						} else if(newValue == "02"){	//부서
							innerForm.setValue('USER_ID'	, '');
							innerForm.setValue('DEPT_CODE'	, UserInfo.deptCode);
							innerForm.setValue('DEPT_NAME'	, UserInfo.deptName);
							innerForm.setValue('DIV_CODE'	, '');
							sUserid.setReadOnly(true);
							if(gsChargeDivi != '1'){	//회계부서가 아닐 경우
								sDeptCd.setReadOnly(true);
								sDeptNm.setReadOnly(true);
							} else {
								sDeptCd.setReadOnly(false);
								sDeptNm.setReadOnly(false);
							}
							sdivC.setReadOnly(true);
						} else if(newValue == "03"){	//사업장
							innerForm.setValue('USER_ID'	, '');
							innerForm.setValue('DEPT_CODE'	, '');
							innerForm.setValue('DEPT_NAME'	, '');
							innerForm.setValue('DIV_CODE'	, UserInfo.divCode);
							sUserid.setReadOnly(true);
							sDeptCd.setReadOnly(true);
							sDeptNm.setReadOnly(true);
							if(gsChargeDivi != '1'){	//회계부서가 아닐 경우
								sdivC.setReadOnly(true);
							} else {
								sdivC.setReadOnly(false);
							}
						} else {
							innerForm.setValue('USER_ID'	, '');
							innerForm.setValue('DEPT_CODE'	, '');
							innerForm.setValue('DEPT_NAME'	, '');
							innerForm.setValue('DIV_CODE'	, '');
							sUserid.setReadOnly(true);
							sDeptCd.setReadOnly(true);
							sDeptNm.setReadOnly(true);
							sdivC.setReadOnly(true);
						}
					}
				}
			}
		},
		Unilite.popup('USER_SINGLE', {
			textFieldName	: 'USER_ID',
			DBtextFieldName	: 'USER_ID',
			validateBlank	: false
		}),{
			xtype			: 'container',
			defaultType		: 'uniNumberfield',
			layout			: {type: 'hbox', align:'stretch'},
			width			: 600,
			margin			: 0,
			items			: [{
				fieldLabel	: '자동분개',
				name		: 'AUTO_CD',
				xtype		: 'uniTextfield',
				readOnly	: true,
				width		: 155
			},{
				fieldLabel	: '자동분개명',
				name		: 'AUTO_NM',
				xtype		: 'uniTextfield',
				hideLabel	: true,
				width		: 170,
				allowBlank	: false
			}]
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '사용부서',
			validateBlank	: false
		}),{
			xtype: 'component'
		},{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120'
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
				}
			}
			return r;
		},
		listeners:{
			validitychange : function(form, valid) {
				if(valid) {
					if(!form.owner.activeRecord) {
						var newRecord = masterGrid.createRow(form.getValues(), null);
						form.owner.setActiveRecord(newRecord);
					}
				}
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('aba800ukrGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
//		width	: 100,
		selModel: 'rowmodel',
		itemId	: 'aba800ukrGrid1',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: true
		},
		dirtyChecked: false,			// 행 추가 후 beforedeselect 실행 하여 저장여부를 확인을 제외 시키는 조건으로 사용
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],
		columns: [
			{dataIndex: 'AUTO_CD'			, width: 66},
			{dataIndex: 'AUTO_NM'			, width: 173},
			{dataIndex: 'AUTO_GUBUN'		, width:65}	,
//			{dataIndex: 'COMP_CODE'			, width: 66, hidden: true},
			{dataIndex: 'AUTO_DATA'			, width: 66},
			{dataIndex: 'AUTO_DATA_NAME'	, width: 66},
			{dataIndex: 'DEPT_CODE'			, width: 66},
			{dataIndex: 'DEPT_NAME'			, width: 66},
			{dataIndex: 'DIV_CODE'			, width: 66},
			{dataIndex: 'USER_ID'			, width: 66}
//			{dataIndex: 'KEY_STRING'		, width: 66, hidden: true}
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
				//innerForm.clearForm();
				var sAutoCd, sAutoGubun, sAutoData, sAutoDataName;
				if(selected.length > 0) {
					innerForm.uniOpt.inLoading = true;
					var record = selected[0];
					innerForm.setActiveRecord(record);
					if(!record.phantom) {
						directDetailStore.loadStoreRecords();
					} else {
						directDetailStore.loadData({});
					}
					innerForm.uniOpt.inLoading = false;
					fnDisabledInput();		//20200814 추가: 입력조건 필드 setting로직 호출
				}
			},
			beforedeselect : function( model, record, index, eOpts ) {
				if(!masterGrid.dirtyChecked) {
					if((directDetailStore.isDirty() || directMasterStore.isDirty()) ){
						if(confirm('저장하지 않은 자동분개내역이 있습니다. 저장하시겠습니까?')) {
							UniAppManager.app.onSaveDataButtonDown();
							return false;
						} else {
							directDetailStore.rejectChanges();
							directMasterStore.rejectChanges();
							//UniAppManager.setToolbarButtons('save', false);
						}
					}
				} else {
					masterGrid.dirtyChecked = false;
				}
				return true;
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					UniAppManager.app.setActiveGridId(girdNm);
					UniAppManager.setToolbarButtons('delete',false);
				});
			 }
		}
	});

	var detailGrid = Unilite.createGrid('aba800DetailGrid', {
		store	: directDetailStore,
//		split	: true,
		layout	: 'fit',
		itemId	:'aba800DetailGrid',
//		selModel:'rowmodel',
		uniOpt	:{
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true,
			useNavigationModel	: false
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],
		columns: [
			{dataIndex: 'AUTO_CD'			, width: 66, hidden: true},
			{dataIndex: 'SEQ'				, width: 66, hidden: true},
			{dataIndex: 'SLIP_DIVI'			, width: 66},
			{dataIndex: 'ACCNT'				, width: 80,
				editor: Unilite.popup('ACCNT_G', {
					DBtextFieldName: 'ACCNT_CODE',
					autoPopup:true,
	 				listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = detailGrid.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									grdRecord.set('ACCNT', record['ACCNT_CODE']);
									grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
								});
								UniAppManager.app.setAccntInfo(detailGrid.uniOpt.currentRecord);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
							UniAppManager.app.clearAccntInfo(detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var param = {
								'RDO': '3',
								'TXT_SEARCH': popup.textField.getValue(),
								'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
								'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
							}
							popup.setExtParam(param);
						}
					}
				})
			},
			{dataIndex: 'ACCNT_NAME'		, width: 170,
				editor: Unilite.popup('ACCNT_G', {
					autoPopup:true,
					listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = detailGrid.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									grdRecord.set('ACCNT', record['ACCNT_CODE']);
									grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
								});
								UniAppManager.app.setAccntInfo(detailGrid.uniOpt.currentRecord);
							},
								scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
							UniAppManager.app.clearAccntInfo(detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var param = {
								'RDO': '3',
								'TXT_SEARCH': popup.textField.getValue(),
								'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
								'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
							}
							popup.setExtParam(param);
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_CODE'		, width: 66,
				'editor': Unilite.popup('CUST_G',{
					textFieldName : 'CUSTOM_CODE',
					DBtextFieldName : 'CUSTOM_CODE',
					autoPopup:true,
					listeners: { 'onSelected': {
						fn: function(records, type  ){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							UniAppManager.app.fnGetProofKind(grdRecord,  records[0]['BILL_TYPE']);
							UniAppManager.app.fnSetTaxAmt(grdRecord);
							for(var i=1 ; i <= 6 ; i++) {
								if(grdRecord.get("AC_CODE"+i.toString()) == 'A4') {
									grdRecord.set('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['CUSTOM_NAME']);

									detailForm.setValue('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
									detailForm.setValue('AC_DATA_NAME'+i.toString()   ,records[0]['CUSTOM_NAME']);

								} else if(grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
									grdRecord.set('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['BOOK_NAME']);

									detailForm.setValue('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
									detailForm.setValue('AC_DATA_NAME'+i.toString()   ,records[0]['BOOK_NAME']);
								}
							}
						},
						scope: this
					},
					'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							for(var i=1 ; i <= 6 ; i++) {
								if(grdRecord.get("AC_CODE"+i.toString()) == 'A4' || grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
									grdRecord.set('AC_DATA'+i.toString()		,'');
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,'');
									detailForm.setValue('AC_DATA'+i.toString()		,'');
									detailForm.setValue('AC_DATA_NAME'+i.toString()   ,'');
								}
							}
						}
					}
				})
			},
			{dataIndex: 'CUSTOM_NAME'		, width: 170,
				'editor': Unilite.popup('CUST_G',{
					autoPopup:true,
					listeners: { 'onSelected': {
						fn: function(records, type  ){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							UniAppManager.app.fnGetProofKind(grdRecord,  records[0]['BILL_TYPE']);
							UniAppManager.app.fnSetTaxAmt(grdRecord);
							for(var i=1 ; i <= 6 ; i++) {
								if(grdRecord.get("AC_CODE"+i.toString()) == 'A4') {
									grdRecord.set('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['CUSTOM_NAME']);

									detailForm.setValue('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
									detailForm.setValue('AC_DATA_NAME'+i.toString()   ,records[0]['CUSTOM_NAME']);

								} else if(grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
									grdRecord.set('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['BOOK_NAME']);

									detailForm.setValue('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
									detailForm.setValue('AC_DATA_NAME'+i.toString()   ,records[0]['BOOK_NAME']);

								}
							}
						},
						scope: this
					},
					'onClear' : function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							for(var i=1 ; i <= 6 ; i++) {
								if(grdRecord.get("AC_CODE"+i.toString()) == 'A4' || grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
									grdRecord.set('AC_DATA'+i.toString()		,'');
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,'');
									detailForm.setValue('AC_DATA'+i.toString()		,'');
									detailForm.setValue('AC_DATA_NAME'+i.toString()   ,'');
								}
							}
					  }
					}
				})
			},
			{dataIndex: 'AMT_I'				, width: 100},
			{dataIndex: 'REMARK'			,width: 200 ,
				renderer:function(value, metaData, record) {
					var r = value;
					if(record.get('POSTIT_YN') == 'Y') r ='<img src="'+CPATH+'/resources/images/PostIt.gif"/>'+value
					return r;
				},
				editor:Unilite.popup('REMARK_G',{
					textFieldName:'REMARK',
					validateBlank:false,
					autoPopup:false,
					listeners:{
						'onSelected':function(records, type) {
							var selectedRec = detailGrid.getSelectedRecord();// masterGrid1.uniOpt.currentRecord;
							selectedRec.set('REMARK', records[0].REMARK_NAME);

						},
						'onClear':function(type) {
							var selectedRec = detailGrid.getSelectedRecord();
							//selectedRec.set('REMARK', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var slipDivi = detailGrid.uniOpt.currentRecord.get("SLIP_DIVI");
								var param = {
									'ACCNT': Unilite.nvl(detailGrid.uniOpt.currentRecord.get("ACCNT"), ''),
									'DR_CR': Unilite.nvl((( slipDivi == '1' || slipDivi == '4')? '2':'1'), '')
								 }
								 popup.setExtParam(param);
							}
						}
					}
				})
			},
			{dataIndex: 'PROOF_KIND'		, width: 100
				,editor:{
						xtype:'uniCombobox',
						store:Ext.data.StoreManager.lookup('CBS_AU_A022'),
						listeners:{

							beforequery:function(queryPlan, value) {
								this.store.clearFilter();
								if(detailGrid.uniOpt.currentRecord.get('SPEC_DIVI') == 'F1') {
									this.store.filterBy(function(record){return record.get('refCode3') == '1'},this)
								} else if(detailGrid.uniOpt.currentRecord.get('SPEC_DIVI') == 'F2') {
									this.store.filterBy(function(record){return record.get('refCode3') == '2'},this)
								}
							}
						}
					}},
			{dataIndex: 'DEPT_CODE'			, width: 66,
				editor: Unilite.popup('DEPT_G', {
//					textFieldName: 'TREE_CODE',
 					DBtextFieldName: 'TREE_CODE',
					autoPopup:true,
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = detailGrid.uniOpt.currentRecord;
									rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
								},
							scope: this
							},
							'onClear': function(type) {
								var rtnRecord = detailGrid.uniOpt.currentRecord;
									rtnRecord.set('DEPT_CODE', '');
									rtnRecord.set('DEPT_NAME', '');
							},
							applyextparam: function(popup){

							}
						}
				})
			},
			{dataIndex: 'DEPT_NAME'			, width: 80,
				editor: Unilite.popup('DEPT_G', {
//					textFieldName: 'TREE_NAME',
 					DBtextFieldName: 'TREE_NAME',
					autoPopup:true,
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = detailGrid.uniOpt.currentRecord;
									rtnRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
								},
							scope: this
							},
							'onClear': function(type) {
								var rtnRecord = detailGrid.uniOpt.currentRecord;
									rtnRecord.set('DEPT_CODE', '');
									rtnRecord.set('DEPT_NAME', '');
							},
							applyextparam: function(popup){

							}
						}
				})
			},
			{dataIndex: 'DIV_CODE'			, minWidth: 100, flex: 1}
//			{dataIndex: 'COMP_CODE'			, width: 66, hidden: true},
//			{dataIndex: 'AUTO_CD'			, width: 80, hidden: true},
//			{dataIndex: 'SEQ'				, width: 80, hidden: true},
//			{dataIndex: 'PROOF_KIND_NM'		, width: 80, hidden: true},
//			{dataIndex: 'DR_CR'				, width: 80, hidden: true},
//			{dataIndex: 'SPEC_DIVI'			, width: 80, hidden: true},
//			{dataIndex: 'AC_CODE1'			, width: 80, hidden: true},
//			{dataIndex: 'AC_CODE2'			, width: 80, hidden: true},
//			{dataIndex: 'AC_CODE3'			, width: 80, hidden: true},
//			{dataIndex: 'AC_CODE4'			, width: 80, hidden: true},
//			{dataIndex: 'AC_CODE5'			, width: 80, hidden: true},
//			{dataIndex: 'AC_CODE6'			, width: 80, hidden: true},
//			{dataIndex: 'AC_NAME1'			, width: 80, hidden: true},
//			{dataIndex: 'AC_NAME2'			, width: 80, hidden: true},
//			{dataIndex: 'AC_NAME3'			, width: 80, hidden: true},
//			{dataIndex: 'AC_NAME4'			, width: 80, hidden: true},
//			{dataIndex: 'AC_NAME5'			, width: 80, hidden: true},
//			{dataIndex: 'AC_NAME6'			, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA1'			, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA2'			, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA3'			, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA4'			, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA5'			, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA6'			, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA_NAME1'		, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA_NAME2'		, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA_NAME3'		, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA_NAME4'		, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA_NAME5'		, width: 80, hidden: true},
//			{dataIndex: 'AC_DATA_NAME6'		, width: 80, hidden: true},
//			{dataIndex: 'AC_TYPE1'			, width: 80, hidden: true},
//			{dataIndex: 'AC_TYPE2'			, width: 80, hidden: true},
//			{dataIndex: 'AC_TYPE3'			, width: 80, hidden: true},
//			{dataIndex: 'AC_TYPE4'			, width: 80, hidden: true},
//			{dataIndex: 'AC_TYPE5'			, width: 80, hidden: true},
//			{dataIndex: 'AC_TYPE6'			, width: 80, hidden: true},
//			{dataIndex: 'AC_LEN1'			, width: 80, hidden: true},
//			{dataIndex: 'AC_LEN2'			, width: 80, hidden: true},
//			{dataIndex: 'AC_LEN3'			, width: 80, hidden: true},
//			{dataIndex: 'AC_LEN4'			, width: 80, hidden: true},
//			{dataIndex: 'AC_LEN5'			, width: 80, hidden: true},
//			{dataIndex: 'AC_LEN6'			, width: 80, hidden: true},
//			{dataIndex: 'AC_POPUP1'			, width: 80, hidden: true},
//			{dataIndex: 'AC_POPUP2'			, width: 80, hidden: true},
//			{dataIndex: 'AC_POPUP3'			, width: 80, hidden: true},
//			{dataIndex: 'AC_POPUP4'			, width: 80, hidden: true},
//			{dataIndex: 'AC_POPUP5'			, width: 80, hidden: true},
//			{dataIndex: 'AC_POPUP6'			, width: 80, hidden: true}

		],
		listeners:{
			selectionChange: function( grid, selected, eOpts ) {
				if(selected.length == 1) {
					var fName, acCode, acName, acType, acPopup, acLen, acCtl, acFormat;
					var dataMap = selected[0].data;
					/**
					 * masterGrid의 ROW를 select할때마다 동적 필드 생성 최대 6개까지 생성 생성된 필드가
					 * 팝업일시 필드name은 아래와 같음 valueFieldName textFieldName
					 * AC_DATA1(~6) AC_DATA_NAME1(~6)
					 * --------------------------------------------------------------------------
					 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드
					 * name은 아래와 같음 AC_DATA1(~6)
					 */
					UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', Ext.isEmpty(selected)?null:selected[0]);
					if(selected && selected.length == 1) {
						detailForm.setActiveRecord(selected[0]);
					}
					directDetailStore.slipGridChange();
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field == "AMT_I" && e.record.get("FOR_YN") == "Y") {
					if(e.record.get("AMT_I") == 0) {
						openForeignCur(e.record, "CR_AMT_I");
						return false;
					}
				}

				if(e.field== "AMT_I" && e.record.get("DR_CR") == '1' && e.record.get("SPEC_DIVI") == "F1") {
					fnTaxPopup(e.record, "AMT_I", e.grid.getStore());
				}
				if(e.field== "AMT_I" && e.record.get("DR_CR") == '2'  && e.record.get("SPEC_DIVI") == "F2") {
					fnTaxPopup(e.record, "AMT_I", e.grid.getStore());
				}

				if (UniUtils.indexOf(e.field,  ["SLIP_DIVI", "ACCNT", "ACCNT_NAME", "CUSTOM_CODE", "CUSTOM_NAME"
												,"AMT_I", "REMARK", "DEPT_CODE", "DEPT_NAME", "DIV_CODE"])){
					return true;
				} else if(e.field == "PROOF_KIND"){
					if(!(e.record.get("SPEC_DIVI") == 'F1' || e.record.get("SPEC_DIVI") == 'F2')) {
						return false;
					} else {
						return true;
					}
				} else {
					return false;
				}
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					UniAppManager.app.setActiveGridId(girdNm);
					//store.onStoreActionEnable();
					if( directMasterStore.isDirty() || directDetailStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					} else {
						UniAppManager.setToolbarButtons('save', false);
					}
				});
			},
			cellkeydown:function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				//pause key(19) 입력시 금액 자동 계산
				var keyCode = e.getKey();
				var colName = e.position.column.dataIndex;
				//PAUSE key
				if(keyCode == 19 && colName == 'AMT_I' ) {
					if(record.get("DR_CR") == '1' && colName == 'AMT_I') {
						var amtI = slipStore1.sum('AMT_I') + slipStore2.sum('AMT_I') - slipStore1.sum('AMT_I');
					   record.set(colName, amtI);
						view.getStore().slipGridChange();
					} else if(record.get("DR_CR") == '2' && colName == 'AMT_I'){
						var amtI = slipStore2.sum('AMT_I') + slipStore1.sum('AMT_I') - slipStore2.sum('AMT_I');
						record.set(colName, amtI);
						view.getStore().slipGridChange();
					}
				}
				if(keyCode == 13) {
					enterNavigation(e);
				}
				if(keyCode == e.F8 && colName == 'CREDIT_NUM_EXPOS') {
					UniAppManager.app.fnProofKindPopUp(record);
				}
				var accntType = view.ownerCt.accntType;

				if(colName== "AMT_I" && record.get("DR_CR") == '1' && record.get("SPEC_DIVI") == "F1") {
					fnTaxPopup(record, "AMT_I", view.getStore());
				}
				if(colName== "AMT_I" && record.get("DR_CR") == '2'  && record.get("SPEC_DIVI") == "F2") {
					fnTaxPopup(record, "AMT_I", view.getStore());
				}

				if((keyCode == e.F8 || keyCode == e.ENTER) && e.position.column.dataIndex== "AMT_I" && record.get("DR_CR") == '2' && record.get("FOR_YN") == "Y") {
					openForeignCur(record, "AMT_I");
				}

				if((keyCode == e.F8 || keyCode == e.ENTER) && e.position.column.dataIndex== "AMT_I" && record.get("DR_CR") == '1'  && record.get("FOR_YN") == "Y") {
					openForeignCur(record, "AMT_I");
				}
			}
		}
	});

	var detailForm = Unilite.createForm('agba800ukrDetailForm1',  {
		itemId		: 'aba800ukrDetailForm',
		masterGrid	: masterGrid,
		height		: 85,
		disabled	: false,
		border		: true,
		padding		: 0,
//		flex		: 1,
		layout		: 'hbox',
		defaults	: {
			labelWidth: 100
		},
		items:[{
			xtype	: 'container',
			itemId	: 'formFieldArea1',
			defaults: {
				width		: 365,
				labelWidth	: 130
			},
			layout: {
				type: 'uniTable',
				columns:2
			}
		}]
	});
	function openForeignCur(record, amtFieldNm) {
		//var record = grid.getSelectedRecord();
		if(record){
			if(!foreignWindow) {
					foreignWindow = Ext.create('widget.uniDetailWindow', {
						title: '외화금액입력',
						width: 300,
						height: 150,
						returnField : amtFieldNm,
						aRecord : record,
						layout: {type:'uniTable', columns:1, tableAttrs:{'width':'100%'}},
						items: [{
							itemId:'foreignCurrency',
							xtype:'uniSearchForm',
							flex: 1,
							style:{'background-color':'#fff'},
							items:[{
								fieldLabel:'화폐단위',
								name :'MONEY_UNIT',
								xtype:'uniCombobox',
								comboType:'AU',
								comboCode:'B004',
								displayField: 'value',
								listeners:{
									change:function(field, newValue, oldValue) {
										if(newValue != oldValue){
											var form = foreignWindow.down('#foreignCurrency');
											if(!form.uniOpt.inLoading){
												if(!Ext.isEmpty(newValue)) {
													foreignWindow.mask();
													accntCommonService.fnGetExchgRate(
														{
															'AC_DATE':  UniDate.getDbDateStr(form.getValue('AC_DATE')),
															'MONEY_UNIT':newValue
														},
														function(provider, response){
															foreignWindow.unmask();
															var form = foreignWindow.down('#foreignCurrency');
															if(!Ext.isEmpty(provider['BASE_EXCHG'])) {
																form.setValue('EXCHANGE_RATE',provider['BASE_EXCHG'])
															}
														}
													)
												} else {
													if(!Ext.isEmpty(newValue)) {
														Unilite.messageBox('화폐단위를 입력해 주세요')
														return false;
													}
												}
											}
										}
										return true;
									},
									specialkey:function(field, event){
										if(event.getKey() == 13) {
											var form = foreignWindow.down("#foreignCurrency");
											var nextField = form.getField("EXCHANGE_RATE");
											if(nextField) {
												nextField.focus();
												setTimeout(function(){nextField.el.down('.x-form-field').dom.select();},10);
											}
										}
									}
								}
							},{
								fieldLabel:'환율',
								xtype:'uniNumberfield',
								name :'EXCHANGE_RATE',
								allowOnlyWhitespace : true,
								decimalPrecision: UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.'):0,
								minValue:0,
								value:1,
								listeners:{
									specialkey:function(field, event){
										if(event.getKey() == 13) {
											var form = foreignWindow.down("#foreignCurrency");
											var nextField = form.getField("FOR_AMT_I");
											if(nextField) {
												nextField.focus();
												setTimeout(function(){nextField.el.down('.x-form-field').dom.select();},10);
											}
										}
									}
								}
							},{
								fieldLabel:'외화금액',
								xtype:'uniNumberfield',
								name :'FOR_AMT_I',
								type:'uniFC',
								listeners:{
									specialkey:function(field, event) {
										if(event.getKey() == event.ENTER) {
											foreignWindow.onApply();
										}
									}
								}
							},{
								hidden:true,
								fieldLabel:'일자',
								xtype:'uniDatefield',
								name :'AC_DATE'
							}]
						}
					],
					tbar:  [
						 '->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								foreignWindow.onApply();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								foreignWindow.hide();
							},
							disabled: false
						}
					],
					listeners : {
						beforehide: function(me, eOpt) {
							foreignWindow.down('#foreignCurrency').clearForm();
						},
						 beforeclose: function( panel, eOpts ) {
							foreignWindow.down('#foreignCurrency').clearForm();
						},
						show: function( panel, eOpts ) {
							var selectedRec = foreignWindow.aRecord;
							var form = foreignWindow.down('#foreignCurrency');
							form.uniOpt.inLoading =true;
							form.setValue('AC_DATE', selectedRec.get('AC_DATE'));
							form.setValue('EXCHANGE_RATE', selectedRec.get('EXCHG_RATE_O'));
							form.setValue('MONEY_UNIT', selectedRec.get('MONEY_UNIT'));
							form.setValue('FOR_AMT_I', selectedRec.get('FOR_AMT_I'));
							form.uniOpt.inLoading =false;
							var focusField = form.getField("MONEY_UNIT");
							setTimeout(function(){focusField.el.down('.x-form-field').dom.select();},50);
						}
					},
					onApply:function() {
						var record = foreignWindow.aRecord;
						var form = foreignWindow.down('#foreignCurrency');
						var mUnit = form.getValue('MONEY_UNIT'),
							forAmt = form.getValue('FOR_AMT_I'),
							exRate = Ext.isEmpty(form.getValue('EXCHANGE_RATE')) ? 1:form.getValue('EXCHANGE_RATE') ;
						if(!Ext.isEmpty(mUnit) && !Ext.isEmpty(forAmt) &&  !Ext.isEmpty(exRate)) {
							record.set('MONEY_UNIT',	mUnit);
							record.set('EXCHG_RATE_O',  exRate );
							record.set('FOR_AMT_I',	 forAmt );
							var numDigit = 0;
							if(UniFormat.Price.indexOf(".") > -1) {
								numDigit = (UniFormat.Price.length - (UniFormat.Price.indexOf(".")+1));
							}
							var amt = forAmt * exRate;
							amt = UniAccnt.fnAmtWonCalc(amt, gsAmtPoint, numDigit);
							record.set(foreignWindow.returnField, amt);
							record.set("AMT_I", amt);
						} else {
							if(Ext.isEmpty(mUnit)) Unilite.messageBox("화폐단위를 입력해 주세요");
							if(Ext.isEmpty(forAmt)) Unilite.messageBox("환율을 입력해 주세요");
							if(Ext.isEmpty(exRate)) Unilite.messageBox("외화금액을 입력해 주세요");
						}
						foreignWindow.hide();
					}
				});
			}
			foreignWindow.returnField = amtFieldNm;
			foreignWindow.aRecord = record;
			foreignWindow.center();
			foreignWindow.show();
		}
	}

	var wasSpecDiviFocus = false;  // selectionChange 시 초기화 시킴.
	function enterNavigation(keyEvent) {
		var position = keyEvent.position,
		view = position.view;
		navi = view.getNavigationModel(),
		dataIndex = position.column.dataIndex;
		var goToForm = false, bSpecDivi  = false, goFName ;
		var record = keyEvent.record;
		var form = detailForm;

		if(keyEvent.keyCode ==13 && view.store.uniOpt.editable && keyEvent.position.isLastColumn() && !keyEvent.position.column.isLocked() && view.ownerGrid.uniOpt.enterKeyCreateRow) {
			if(record) {
				bSpecDivi = UniUtils.indexOf(record.get("SPEC_DIVI"),['F1','F2']) ;
				for(var i =1 ; i <= 6 ; i++) {
					if(!goToForm && "Y" ==record.get('AC_CTL'+i.toString())) {
						goFName = "AC_DATA"+i.toString();

						if(form && Ext.isEmpty(record.get(goFName))) {
							var field = form.getField(goFName);
							if(record.get('AC_POPUP'+i.toString()) == 'Y' && !field) {
								goFName = "AC_DATA_NAME"+i.toString();
							}
							goToForm = true;
						}
					}
				}
			}

			if(!goToForm &&  !bSpecDivi ) {
				UniAppManager.app.onNewDataButtonDown();
				return;
			} else if(bSpecDivi  ){
				// SPEC_DIVI == F1, F2 인경우 값이 있더라고 해당 관리항목으로 Focus 이동
				if(!wasSpecDiviFocus) {
					wasSpecDiviFocus = true;
					goField("AC_DATA1");
				} else if(!goToForm) {
					UniAppManager.app.onNewDataButtonDown();
					return;
				}
			} else if(goToForm) {
				if(Ext.isEmpty(record.get(goFName))) {
					goField(goFName);
				} else {
					UniAppManager.app.onNewDataButtonDown();
					return;
				}
			}
		}

		if( gsAmtEnter == "Y" && record.get(dataIndex) == 0 && dataIndex == 'AMT_I') {
			return;
		}

		if(Ext.isEmpty(record.get(dataIndex)) && record.phantom  ) {
			var rowIdx = position.rowIdx;
			if(rowIdx > 0) {
				var store = view.getStore();
				var prevRec = store.getAt(rowIdx-1);
				if(prevRec.get('AC_DAY') == record.get('AC_DAY') && prevRec.get('SLIP_NUM') == record.get('SLIP_NUM')) {
					if(dataIndex != 'ACCNT' && dataIndex != 'CUSTOM_CODE' && dataIndex != 'PROOF_KIND' && dataIndex != 'PROOF_KIND_NM') {
						record.set(dataIndex, prevRec.get(dataIndex));
						if(dataIndex == 'ACCNT_NAME' && !Ext.isEmpty(prevRec.get("ACCNT")) ) {
							record.set("ACCNT", prevRec.get("ACCNT"));
							var accnt = prevRec.get("ACCNT");

							 UniAppManager.app.setAccntInfo(record)

							//UniAppManager.app.loadDataAccntInfo(record, form, prevRec.data )
						}
						if(dataIndex == 'CUSTOM_NAME') {
							var form = detailForm;
							record.set("CUSTOM_CODE", prevRec.get("CUSTOM_CODE"));
							record.set('CUSTOM_NAME',prevRec.get('CUSTOM_NAME'));
							for(var i=1 ; i <= 6 ; i++) {
								if(record.get("AC_CODE"+i.toString()) == 'A4') {
									record.set('AC_DATA'+i.toString()	   ,prevRec.get("CUSTOM_CODE"));
									record.set('AC_DATA_NAME'+i.toString()  ,prevRec.get("CUSTOM_NAME"));
									form.setValue('AC_DATA'+i.toString()		,prevRec.get("CUSTOM_CODE"));
									form.setValue('AC_DATA_NAME'+i.toString()   ,prevRec.get("CUSTOM_NAME"));
								} else if(record.get("AC_CODE"+i.toString()) == 'O2') {
									record.set('AC_DATA'+i.toString()	   ,prevRec.get('AC_DATA'+i.toString()));
									record.set('AC_DATA_NAME'+i.toString()  ,prevRec.get('AC_DATA_NAME'+i.toString()));
									form.setValue('AC_DATA'+i.toString()		,prevRec.get('AC_DATA'+i.toString()));
									form.setValue('AC_DATA_NAME'+i.toString()   ,prevRec.get('AC_DATA_NAME'+i.toString()));
								}
							}
							//
							//form.setActiveRecord(record);
						}
						if(dataIndex == 'DR_CR') {
							record.set(dataIndex, prevRec.get(dataIndex));
						}
					}
				}
			}
		}
		var newPosition ;
		if(!keyEvent.shiftKey) {
			newPosition = navi.move('right', keyEvent);
		} else {
			newPosition = navi.move('left', keyEvent);
		}

		if (newPosition) {
			navi.setPosition(newPosition, null, keyEvent);
		}
	}

	function fnTaxPopup(record, field, store) {
		if(record) {
			if(record.get("SPEC_DIVI") != "F1" && record.get("SPEC_DIVI") != "F2") {
				return;
			}

			if(record.get("SPEC_DIVI") == "F2" && record.get("DR_CR") != "2") {
				return;
			}
			if(record.get("SPEC_DIVI") == "F1" && record.get("DR_CR") != "1") {
				return;
			}
			var params = {
				'DR_CR'			: record.get("DR_CR"),
				'SPEC_DIVI'		: record.get("SPEC_DIVI"),
				'DIV_CODE'		: record.get("DIV_CODE"),
				'AC_DATE'		: record.get("AC_DATE"),
				'PUB_DATE'		: record.get("AC_DATA"+UniAccnt.findAcCode(record, "I3")),
				'BILL_DIV_CODE'	: record.get("BILL_DIV_CODE") ? record.get("BILL_DIV_CODE"):record.get("DIV_CODE"),
				'AC_CODE'		: record.get("AC_CODE"),
				'PROOF_KIND'	: record.get("PROOF_KIND"),
				'SUPP_AMT'		: record.get("AC_DATA"+UniAccnt.findAcCode(record, "I1")),
				'TAX_AMT'		: record.get("AC_DATA"+UniAccnt.findAcCode(record, "I6")),
				'CUSTOM_CODE'	: record.get("CUSTOM_CODE"),
				'CUSTOM_NAME'	: record.get("CUSTOM_NAME"),
				'COMPANY_NUM'	: record.get("COMPANY_NUM"),
				'REASON_CODE'	: record.get("REASON_CODE"),
				'CREDIT_CODE'	: record.get("CREDIT_CODE"),
				'CREDIT_NAME'	: record.get("CREDIT_NAME"),
				'CREDIT_NUM'	: record.get("CREDIT_NUM"),
				'CREDIT_NUM_EXPOS'	: record.get("CREDIT_NUM_EXPOS"),
				'CREDIT_NUM_MASK'	: record.get("CREDIT_NUM_MASK"),
				'EB_YN'			: record.get("AC_DATA"+UniAccnt.findAcCode(record, "I7"))
			}

			if(!taxWindow) {
					taxWindow = Ext.create('widget.uniDetailWindow', {
						title: '부가세정보입력',
						width: 400,
						height: 350,
						aRecord : record,
						layout: {type:'uniTable', columns:1, tableAttrs:{'width':'100%'}},
						items: [{
							itemId:'taxInfo',
							xtype:'uniDetailForm',
							disabled:false,
							flex: 1,
							style:{'background-color':'#fff'},
							items:[
								{
									fieldLabel:'신고사업장',
									name :'BILL_DIV_CODE',
									xtype:'uniCombobox',
									comboType:'BOR120',
									allowBlank:false
								},{
									fieldLabel:'계산서일',
									xtype:'uniDatefield',
									name :'PUB_DATE',
									allowBlank:false
								},{
									fieldLabel:'증빙유형',
									name :'PROOF_KIND',
									xtype:'uniCombobox',
									comboType:'AU',
									comboCode:'A022',
									allowBlank:false,
									listeners:{
										change:function(field, newValue, oldValue) {
											var form = taxWindow.down('#taxInfo');
											if(!form.uniOpt.inLoading){
												form.setValue("SUPP_AMT", 0);
												form.setValue("TAX_AMT", 0);
												form.fnCalTaxAmt({"PROOF_KIND":newValue});
												form.fnSetReasonCode(field,newValue);
											}
										},
										beforequery:function(queryPlan, value) {
											var aRecord = taxWindow.aRecord;
											this.store.clearFilter();
											if(aRecord.get('SPEC_DIVI') == 'F1') {
												this.store.filterBy(function(record){return record.get('refCode3') == '1'},this)
											} else if(aRecord.get('SPEC_DIVI') == 'F2') {
												this.store.filterBy(function(record){return record.get('refCode3') == '2'},this)
											}
										}
									}
								},{
									fieldLabel:'공급가액',
									xtype:'uniNumberfield',
									name :'SUPP_AMT',
									type:'uniPrice',
									listeners:{
										change:function(field, newValue, oldValue) {
											var form = taxWindow.down('#taxInfo');
											if(!form.uniOpt.inLoading){
												if(newValue == 0) {
													form.setValue("TAX_AMT", 0)
												}
											}
										}
										,blur:function(){
											var form = taxWindow.down('#taxInfo');
											form.fnCalTaxAmt();
										}
									}
								},{
									fieldLabel:'세액',
									xtype:'uniNumberfield',
									name :'TAX_AMT',
									type:'uniPrice'
								},Unilite.popup('COMMON', {
									xtype:'uniPopupField',
									fieldLabel : '전자발행여부',
									valueFieldName:'EB_YN',
									textFieldName:'EB_YN_NAME',
									valueFieldWidth: 60,
									textFieldWidth: 170,
									popupWidth:579,
									popupHeight:407,
									pageTitle: '전자발행여부',
									extParam:{'BSA_CODE':'A149', HEADER:"전자발행여부"}
								}),{
									fieldLabel:'사업자번호',
									name :'COMPANY_NUM',
									xtype:'uniTextfield'
								}
								,Unilite.popup('CUST',{
									extParam:{"CUSTOM_TYPE":["1","2","3"] },
									listeners:{
										onSelected:function(records, type){
											if(records && records.length > 0) {
												var form = taxWindow.down('#taxInfo');
												form.setValue("COMPANY_NUM", records[0]["COMPANY_NUM"]);
											}
										},
										onClear:function() {
											var form = taxWindow.down('#taxInfo');
											form.setValue("COMPANY_NUM", "");
										}
									}
								})
								,Unilite.popup('COMMON', {
									xtype:'uniPopupField',
									fieldLabel : '불공제사유',
									valueFieldName:'REASON_CODE',
									textFieldName:'REASON_NAME',
									valueFieldWidth: 60,
									textFieldWidth: 170,
									popupWidth:579,
									popupHeight:407,
									pageTitle: '불공제사유',
									extParam:{'BSA_CODE':'A070', HEADER:"불공제사유"}
								})
								,Unilite.popup('CUST_CREDIT_CARD',{
									fieldLabel:'신용카드거래처',
									valueFieldName:'CREDIT_CODE',
									textFieldName:'CREDIT_NAME'
								}),
								{
									fieldLabel:'신용카드번호',
									xtype:'uniTextfield',
									name:'CREDIT_NUM_MASK',
									readOnly:true,
									value:'***************',
									listeners:{
										render:function(field) {
											var me = field;
											me.getEl().on('click', function(){
												me.onPopupFocus();
											}, field.getEl() )
										}
									},
									onPopupFocus:function() {
										var form = taxWindow.down('#taxInfo');
										var me = this;
										if(!me.readOnly) {
											Unilite.popupCipherComm('form', form, "CREDIT_NUM_MASK", "CREDIT_NUM",  {'CRDT_FULL_NUM':form.getValue('CREDIT_NUM'), 'GUBUN_FLAG': '1', 'INCDRC_GUBUN':'INC'});
										}
									}
										/*
										scope:this,
										onSelected:function(records, type ) {
											form = taxWindow.down('#taxInfo');
											form.setValue("CREDIT_NUM_EXPOS", records[0].INC_WORD);
											form.setValue("CREDIT_NUM_MASK", '***************');
										},
										onClear:function(type) {
										   form = taxWindow.down('#taxInfo');
										   form.setValue("CREDIT_NUM", "");
										   form.setValue("CREDIT_NUM_EXPOS", "");
										   form.setValue("CREDIT_NUM_MASK", "");
										}
									}*/
								},{
									xtype:'uniTextfield',
									name:'CREDIT_NUM_EXPOS',
									xtype:'uniTextfield',
									hidden:true
								},{
									xtype:'uniTextfield',
									name:'CREDIT_NUM',
									xtype:'uniTextfield',
									hidden:true
								}
								/*,Unilite.popup('CREDIT_NO',{
									valueFieldName:'CREDIT_NUM',
									textFieldName:'CREDIT_NAME',
									api:popupService.creditCard3,
									readOnly:true
								})*/
							],
							fnSetReasonCode:function(field, newValue){
								var form = taxWindow.down('#taxInfo');
								if(newValue) {
									if(newValue >= "13" && newValue <="17") {
										form.getField("REASON_CODE").setReadOnly(true);
										form.getField("REASON_NAME").setReadOnly(true);
										form.getField("CREDIT_CODE").setReadOnly(false);
										form.getField("CREDIT_NAME").setReadOnly(false);
										form.getField("CREDIT_NUM").setReadOnly(true);
										form.getField("CREDIT_NUM_MASK").setReadOnly(true);
										form.setValue("REASON_CODE", "");
										form.setValue("REASON_NAME", "");
										form.setValue("CREDIT_NUM", "");
										form.setValue("CREDIT_NUM_EXPOS", "");
										form.setValue("CREDIT_NUM_MASK", "");
									} else if(newValue == "54" || newValue =="61") { //매입세액불공제
										form.getField("REASON_CODE").setReadOnly(false);
										form.getField("REASON_NAME").setReadOnly(false);
										form.getField("CREDIT_CODE").setReadOnly(true);
										form.getField("CREDIT_NAME").setReadOnly(true);
										form.getField("CREDIT_NUM").setReadOnly(true);
										form.getField("CREDIT_NUM_MASK").setReadOnly(true);
										form.setValue("REASON_CODE", "");
										form.setValue("REASON_NAME", "");
										form.setValue("CREDIT_NUM", "");
										form.setValue("CREDIT_NUM_EXPOS", "");
										form.setValue("CREDIT_NUM_MASK", "");
									} else if(newValue == "53" || newValue =="64" || newValue =="68") { //신용카드매입
										form.getField("REASON_CODE").setReadOnly(true);
										form.getField("REASON_NAME").setReadOnly(true);
										form.getField("CREDIT_CODE").setReadOnly(true);
										form.getField("CREDIT_NAME").setReadOnly(true);
										form.getField("CREDIT_NUM").setReadOnly(false);
										form.getField("CREDIT_NUM_MASK").setReadOnly(false);
										form.setValue("REASON_CODE", "");
										form.setValue("REASON_NAME", "");
										form.setValue("CREDIT_CODE", "");
										form.setValue("CREDIT_NAME", "");
										form.getField("CREDIT_NUM_MASK").setFieldLabel("신용카드번호");
									} else if(newValue == "62" || newValue =="69") { //현금영수증, 현금영수증(자산)
										form.getField("REASON_CODE").setReadOnly(true);
										form.getField("REASON_NAME").setReadOnly(true);
										form.getField("CREDIT_CODE").setReadOnly(true);
										form.getField("CREDIT_NAME").setReadOnly(true);
										form.getField("CREDIT_NUM").setReadOnly(false);
										form.getField("CREDIT_NUM_MASK").setReadOnly(false);
										form.setValue("REASON_CODE", "");
										form.setValue("REASON_NAME", "");
										form.setValue("CREDIT_CODE", "");
										form.setValue("CREDIT_NAME", "");
										form.getField("CREDIT_NUM_MASK").setFieldLabel("현금영수증번호");
									} else if(newValue == "70" ) { //신용카드매입_불공제 (불공제사유와 신용카드번호 입력)
										form.getField("REASON_CODE").setReadOnly(false);
										form.getField("REASON_NAME").setReadOnly(false);
										form.getField("CREDIT_CODE").setReadOnly(true);
										form.getField("CREDIT_NAME").setReadOnly(true);
										form.getField("CREDIT_NUM").setReadOnly(false);
										form.getField("CREDIT_NUM_MASK").setReadOnly(false);
										form.setValue("CREDIT_CODE", "");
										form.setValue("CREDIT_NAME", "");
										form.getField("CREDIT_NUM_MASK").setFieldLabel("신용카드번호");
									} else if(newValue == "71" ) { //현금영수증_불공제 (불공제사유와 현금영수증번호 입력)
										form.getField("REASON_CODE").setReadOnly(false);
										form.getField("REASON_NAME").setReadOnly(false);
										form.getField("CREDIT_CODE").setReadOnly(true);
										form.getField("CREDIT_NAME").setReadOnly(true);
										form.getField("CREDIT_NUM").setReadOnly(false);
										form.getField("CREDIT_NUM_MASK").setReadOnly(false);
										form.setValue("CREDIT_CODE", "");
										form.setValue("CREDIT_NAME", "");
										form.setValue("CREDIT_NUM", "");
										form.setValue("CREDIT_NUM_EXPOS", "");
										form.setValue("CREDIT_NUM_MASK", "");
										form.getField("CREDIT_NUM_MASK").setFieldLabel("현금영수증번호");
									} else {
										form.getField("REASON_CODE").setReadOnly(true);
										form.getField("REASON_NAME").setReadOnly(true);
										form.getField("CREDIT_CODE").setReadOnly(true);
										form.getField("CREDIT_NAME").setReadOnly(true);
										form.getField("CREDIT_NUM").setReadOnly(true);
										form.getField("CREDIT_NUM_MASK").setReadOnly(true);
										form.setValue("REASON_CODE", "");
										form.setValue("REASON_NAME", "");
										form.setValue("CREDIT_CODE", "");
										form.setValue("CREDIT_NAME", "");
										form.setValue("CREDIT_NUM", "");
										form.setValue("CREDIT_NUM_EXPOS", "");
										form.setValue("CREDIT_NUM_MASK", "");
									}
									form.fnSetDefaultAcCodeI7(newValue);
								}
							}
							,fnSetDefaultAcCodeI7:function(newValue) {
								var form = this;
								var specDivi = form.getValue("SPEC_DIVI");
								if(specDivi != "F1" && specDivi != "F2" ) {
									return;
								}

								// 증빙유형의 참조코드1 설정값 가져오기
								//if(form.getValue('PROOF_KIND') != "") {
									var defaultValue, defaultValueName;
									var param = {
										'MAIN_CODE':'A022',
										'SUB_CODE' : Ext.isEmpty(newValue) ? form.getValue('PROOF_KIND'):newValue,
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

									var record = taxWindow.aRecord;
									for(var i =1 ; i <= 6; i++) {
										if(record.get('AC_CODE'+i.toString()) == "I7" ) {
											record.set('AC_DATA'+i.toString(), defaultValue);
											record.set('AC_DATA_NAME'+i.toString(), defaultValueName);

											form.setValue("EB_YN", defaultValue);;
											form.setValue("EB_YN_NAME", defaultValueName);
										}
									};
								//}
							},
							fnCalTaxAmt:function(newValue) {
								var form = taxWindow.down('#taxInfo');
								var sProofKind, dTaxRate
								var dSupplyAmt, dTmpSupplyAmt, dTaxAmt

								dSupplyAmt = (newValue && newValue.SUPP_AMT) ? newValue.SUPP_AMT:form.getValue("SUPP_AMT")
								sProofKind = (newValue && newValue.PROOF_KIND) ? newValue.PROOF_KIND:form.getValue("PROOF_KIND")

								if(sProofKind) {
									taxWindow.body.mask();
									accntCommonService.fnGetTaxRate({'PROOF_KIND':sProofKind}, function(provider, response) {
										var taxRate = provider.TAX_RATE
										if(sProofKind == "24" || sProofKind == "13" || sProofKind == "14" ) {
											dTmpSupplyAmt = dSupplyAmt / ((100 + taxRate) * 0.01)
											dTaxAmt = Math.floor(dTmpSupplyAmt * taxRate * 0.01);
											dSupplyAmt = dSupplyAmt - dTaxAmt;
											form.setValue("SUPP_AMT",dSupplyAmt);
											form.setValue("TAX_AMT",dTaxAmt);
										} else {
											dTaxAmt = Math.floor(dSupplyAmt * taxRate * 0.01);
											form.setValue("TAX_AMT",dTaxAmt);
										}
										taxWindow.body.unmask();
									})
								}
							}
						}
					],
					tbar:  [
						 '->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								taxWindow.onApply();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								taxWindow.hide();
							},
							disabled: false
						}
					],
					listeners : {
						beforehide: function(me, eOpt) {
							taxWindow.down('#taxInfo').clearForm();
						},
						 beforeclose: function( panel, eOpts ) {
							taxWindow.down('#taxInfo').clearForm();
						},
						show: function( panel, eOpts ) {
							var selectedRec = taxWindow.aRecord;
							var form = taxWindow.down('#taxInfo');
							form.uniOpt.inLoading = true;
							var reasonField = form.getField("REASON_CODE");
							var proofKind = taxWindow.params.PROOF_KIND
							if(proofKind) {
								form.fnSetReasonCode(reasonField, proofKind);
							}
							form.setValues(taxWindow.params);
							if(UniUtils.indexOf(taxWindow.params.PROOF_KIND , ["53","62","64","68","69","70","71"])) {
								form.getField("CREDIT_NUM").setReadOnly(false);
							}

							var param2 = {
								'MAIN_CODE':'A149',
								'SUB_CODE' : taxWindow.params["EB_YN"],
								'field' : 'text'
							};
							var ebName = UniAccnt.fnGetRefCode(param2);
							form.setValue("EB_YN_NAME", ebName);

							var param3 = {
								'MAIN_CODE':'A070',
								'SUB_CODE' : taxWindow.params["REASON_CODE"],
								'field' : 'text'
							};
							var reasonName = UniAccnt.fnGetRefCode(param3);
							form.setValue("REASON_NAME", reasonName);

							var pubDate = UniAccnt.fnGetRefCode(param3);
							form.setValue("PUB_DATE", taxWindow.params.PUB_DATE);

							form.getField("BILL_DIV_CODE").focus();
							form.uniOpt.inLoading = false;
						}
					},
					onApply:function() {
						var record = taxWindow.aRecord;
						var form = taxWindow.down('#taxInfo');
						var dAmtI = 0;
						if(form.getValue("PROOF_KIND") >= "13" && form.getValue("PROOF_KIND") <= "17") {
							if(!form.getValue("CREDIT_CODE") || !form.getValue("CREDIT_NAME")) {
								Unilite.messageBox("신용카드거래처를 입력하세요.");
								return;
							}
						}
						if(form.getValue("PROOF_KIND") == "54" || form.getValue("PROOF_KIND") == "61") {
							if(!form.getValue("REASON_CODE") || !form.getValue("REASON_NAME")) {
								Unilite.messageBox("불공제사유를 입력하세요.");
								return;
							}
						}
						if(form.getValue("PROOF_KIND") == "53" || form.getValue("PROOF_KIND") == "64" || form.getValue("PROOF_KIND") == "68" ) {
							if(!form.getValue("CREDIT_NUM") ) {
								Unilite.messageBox("신용카드번호를 입력하세요.");
								return;
							}
						}
						if(form.getValue("PROOF_KIND") == "62" || form.getValue("PROOF_KIND") == "69" ) {
							if(!form.getValue("CREDIT_NUM") ) {
								Unilite.messageBox("현금영수증번호를 입력하세요.");
								return;
							}
						}
						if( form.getValue("PROOF_KIND") == "70") {
							if(!form.getValue("REASON_CODE") || !form.getValue("REASON_NAME")) {
								Unilite.messageBox("불공제사유를 입력하세요.");
								return;
							}
							if(!form.getValue("CREDIT_NUM") ) {
								Unilite.messageBox("신용카드번호를 입력하세요.");
								return;
							}
						}
						if(form.getValue("PROOF_KIND") == "71") {
							if(!form.getValue("REASON_CODE") || !form.getValue("REASON_NAME")) {
								Unilite.messageBox("불공제사유를 입력하세요.");
								return;
							}
							if(!form.getValue("CREDIT_NUM") ) {
								Unilite.messageBox("현금영수증번호를 입력하세요.");
								return;
							}
						}
						if(UniUtils.indexOf(form.getValue("PROOF_KIND"), ["54","61","70","71"])) {
							dAmtI = 0;
						} else {
							dAmtI = form.getValue("TAX_AMT");
						}
						taxWindow.aRecord.set("AMT_I", dAmtI);

						taxWindow.aRecord.set("AC_DATA"+UniAccnt.findAcCode(taxWindow.aRecord, "A4"), form.getValue("CUSTOM_CODE"));
						taxWindow.aRecord.set("AC_DATA_NAME"+UniAccnt.findAcCode(taxWindow.aRecord, "A4"), form.getValue("CUSTOM_NAME"));
						taxWindow.aRecord.set("AC_DATA"+UniAccnt.findAcCode(taxWindow.aRecord, "I3"), UniDate.getDbDateStr(form.getValue("PUB_DATE")));
						taxWindow.aRecord.set("AC_DATA"+UniAccnt.findAcCode(taxWindow.aRecord, "I1"), form.getValue("SUPP_AMT"));
						taxWindow.aRecord.set("AC_DATA"+UniAccnt.findAcCode(taxWindow.aRecord, "I6"), form.getValue("TAX_AMT"));
						taxWindow.aRecord.set("AC_DATA"+UniAccnt.findAcCode(taxWindow.aRecord, "I7"), form.getValue("EB_YN"));
						taxWindow.aRecord.set("AC_DATA_NAME"+UniAccnt.findAcCode(taxWindow.aRecord, "I7"), form.getValue("EB_YN_NAME"));

						taxWindow.aRecord.set("CUSTOM_CODE"		, form.getValue("CUSTOM_CODE"));
						taxWindow.aRecord.set("CUSTOM_NAME"		, form.getValue("CUSTOM_NAME"));
						taxWindow.aRecord.set("COMPANY_NUM"		, form.getValue("COMPANY_NUM"));
						taxWindow.aRecord.set("PROOF_KIND"			, form.getValue("PROOF_KIND"));
						taxWindow.aRecord.set("PROOF_KIND_NM"		, form.getValue("PROOF_KIND_NM"));
						taxWindow.aRecord.set("REASON_CODE"		, form.getValue("REASON_CODE"));
						taxWindow.aRecord.set("CREDIT_CODE"		, form.getValue("CREDIT_CODE"));
						taxWindow.aRecord.set("BILL_DIV_CODE"		, form.getValue("BILL_DIV_CODE"));
						taxWindow.aRecord.set("CREDIT_NUM"			, form.getValue("CREDIT_NUM"));
						taxWindow.aRecord.set("CREDIT_NUM_EXPOS"	, form.getValue("CREDIT_NUM_EXPOS"));
						taxWindow.aRecord.set("CREDIT_NUM_MASK"	, form.getValue("CREDIT_NUM_MASK"));
						//var masterGrid = UniAppManager.app.getActiveGrid();
						//var curRecord = masterGrid.getSelectedRecord();
						//UniAppManager.app.getActiveForm().setActiveRecord(taxWindow.aRecord);
						detailForm.setValues(taxWindow.aRecord.data)
						taxWindow.hide();
					}
				});
			}
			taxWindow.aRecord = record;
			taxWindow.params = params;
			taxWindow.center();
			taxWindow.show();
		}
	}

	function openCrediNotWin(record) {
		if(record){
			if(!creditNoWin) {
					creditNoWin = Ext.create('widget.uniDetailWindow', {
						title: '현금영수증번호',
						width: 300,
						height:140,
						layout: {type:'vbox', align:'stretch'},
						items: [{
							itemId:'search',
							xtype:'uniSearchForm',
							style:{
								'background':'#fff',
								'width':'300px'
							},
							margine:'3 3 3 3',
							items:[{
								xtype:'component',
								html:' <div style="line-height:30px;"> * 번호를 입력하십시오.</div>'
							},{
								hideLabel:true,
								height:28,
								//labelWidth:60,
								name :'CREDIT_NUM',
								width:275
							},{
								fieldLabel: '복호화',
								name:'DECRYP_WORD',
								hidden: true
							},
							{
								fieldLabel: '암호화',
								name:'INCRYP_WORD',
								hidden: true
							},{
								fieldLabel: '암호화구분',
								name:'INCDRC_GUBUN',
								hidden: true
							}]
						}],
						tbar:  ['->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								var form = creditNoWin.down('#search');
								var creditNum = creditNoWin.down('#search').getValue('CREDIT_NUM');

//									if(creditNum && creditNum.length > 0) {
//										creditNoWin.rtnRecord.set('CREDIT_NUM', creditNum );
//									}
//									creditNoWin.hide();

								if(Ext.isEmpty(creditNum)){
									//form.setValue('INCRYP_WORD', '');
									//creditNoWin.rtnRecord.set('CREDIT_NUM', creditNum );
									Unilite.messageBox('카드번호/현금영수증 번호를 입력하세요.');
									//creditNoWin.hide();
								} else {
									form.setValue('DECRYP_WORD', creditNum);
									form.setValue('INCDRC_GUBUN',  'INC');

									creditNoWin.fnIncryptDecrypt();
								}
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								creditNoWin.hide();
							},
							disabled: false
						}],
						listeners : {beforehide: function(me, eOpt) {
										creditNoWin.down('#search').clearForm();
									},
									beforeclose: function( panel, eOpts ) {
										creditNoWin.down('#search').clearForm();
									},
									show: function( panel, eOpts ) {
										var form = creditNoWin.down('#search');
										//form.setValue('CREDIT_NUM', creditNoWin.rtnRecord.get('CREDIT_NUM'));

										//var frm = me.panelSearch;
										//if(!Ext.isEmpty(param.DECRYP_WORD))   frm.setValue('DECRYP_WORD', param.DECRYP_WORD);

										//Unilite.messageBox(param['CRDT_FULL_NUM']);
										if(!Ext.isEmpty(creditNoWin.rtnRecord.get('CREDIT_NUM'))){

											form.setValue('INCDRC_GUBUN', 'DEC');
											form.setValue('INCRYP_WORD', creditNoWin.rtnRecord.get('CREDIT_NUM'));
											//Unilite.messageBox(creditNoWin.rtnRecord.get('CREDIT_NUM'));
											creditNoWin.fnIncryptDecrypt();
										}

										//creditNoWin._dataLoad();
									}
						},
						fnIncryptDecrypt: function() {
							//var me = this;
							//var param= me.panelSearch.getValues();

							var form = creditNoWin.down('#search');
							var param = creditNoWin.down('#search').getValues();

							popupService.incryptDecryptPopup(param, function(provider, response) {
								if(!Ext.isEmpty(provider)){
									//Unilite.messageBox(provider);
									if(form.getValue('INCDRC_GUBUN') == 'INC'){
										form.setValue('INCRYP_WORD', provider);

										creditNoWin.rtnRecord.set('CREDIT_NUM', provider);
										creditNoWin.hide();
									} else {
										form.setValue('CREDIT_NUM', provider);
										form.setValue('DECRYP_WORD', provider);
									}
								}
							})
						}
					});
			}
			creditNoWin.rtnRecord = record;
			creditNoWin.center();
			creditNoWin.show();
		}
	}

	function creditPopup (popupWin, returnRecord, searchTxt, codeColName, nameColName, creditNum, companyColName, companyNmColName, rateColNme,  rdoType) {
		if(!popupWin) {
			Unilite.defineModel('creditModelAccntGrid', {
				fields: [
					 {name: 'CRDT_NUM'		  ,text:'신용카드코드'		  ,type:'string'  }
					,{name: 'CRDT_NAME'		 ,text:'카드명'				 ,type:'string'  }
					,{name: 'CRDT_FULL_NUM_MASK'	,text:'신용카드번호'		  ,type:'string', defaultValue: '***************'}
					,{name: 'CRDT_FULL_NUM_EXPOS'   ,text:'신용카드번호'		  ,type:'string'  }
					,{name: 'CRDT_FULL_NUM'	 ,text:'신용카드번호(DB)'		  ,type:'string'  }
					,{name: 'BANK_CODE'		 ,text:'은행코드'				,type:'string'  }
					,{name: 'BANK_NAME'		 ,text:'은행명'				 ,type:'string'  }
					,{name: 'ACCOUNT_NUM_MASK' ,text:'결제계좌번호'		   ,type:'string', defaultValue: '***************'}
					,{name: 'ACCOUNT_NUM_EXPOS' ,text:'결제계좌번호'		  ,type:'string'  }
					,{name: 'ACCOUNT_NUM'	   ,text:'결제계좌번호(DB)'		  ,type:'string'  }
					,{name: 'SET_DATE'		  ,text:'결제일'				 ,type:'uniDate' }
					,{name: 'PERSON_NAME'	   ,text:'사원명'				 ,type:'string'  }
					,{name: 'CRDT_COMP_CD'	  ,text:'신용카드사'			   ,type:'string'  }
					,{name: 'CRDT_COMP_NM'	  ,text:'신용카드사명'		  ,type:'string'  }
					,{name: 'COMP_CODE'		 ,text:'법인코드'				,type:'string'  }
				]
			});
			var creditDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				api: {
					read : 'popupService.creditCard3'
				}
			});

			var creditStore = Unilite.createStore('creditStore', {
				model: 'creditModelAccntGrid' ,
				proxy: creditDirctProxy,
				loadStoreRecords : function() {
					var param= popupWin.down('#search').getValues();

					this.load({
						params: param
					});
				}
			});

			popupWin = Ext.create('widget.uniDetailWindow', {
				title: '신용카드',
				width: 600,
				height:400,
				'returnRecord'	  : returnRecord,
				'rdoType'		   : rdoType,
				'searchTxt'		 : searchTxt,
				'codeColName'	   : codeColName,
				'nameColName'	   : nameColName,
				'creditNum'		: creditNum,
				'companyColName'	: companyColName,
				'companyNmColName'  : companyNmColName,
				'rateColNme'		: rateColNme,
				layout: {type:'vbox', align:'stretch'},
				items: [{
					itemId:'search',
					xtype:'uniSearchForm',
					layout:{type:'uniTable',columns:2},
					items:[{
							hideLabel:true,
							xtype: 'radiogroup',
							width: 200,
							items:[ {inputValue: '3', boxLabel:'신용카드코드', name: 'RDO', checked: true},
									{inputValue: '2', boxLabel:'카드명',   name: 'RDO'}
							]
						},{
							fieldLabel:'검색어',
							labelWidth:60,
							name :'TXT_SEARCH',
							width:250
						},
						{ xtype: 'uniTextfield',	  name:'INCRYP_WORD', hidden: true},
						{ xtype: 'uniTextfield',	  name:'INCDRC_GUBUN', hidden: true}
					]
				},
				Unilite.createGrid('', {
					itemId:'grid',
					layout : 'fit',
					store: creditStore,
					selModel:'rowmodel',
					uniOpt:{
						onLoadSelectFirst : true
					},
					columns:  [
							 { dataIndex: 'CRDT_NUM'			,width: 80  }
							,{ dataIndex: 'CRDT_NAME'		   ,width: 100 }
							,{ dataIndex: 'CRDT_FULL_NUM_MASK'	  ,width: 140 }
							,{ dataIndex: 'CRDT_FULL_NUM_EXPOS'	 ,width: 140, hidden: true }
							,{ dataIndex: 'CRDT_FULL_NUM'	   ,width: 140, hidden: true }
							,{ dataIndex: 'BANK_CODE'		   ,width: 80  }
							,{ dataIndex: 'BANK_NAME'		   ,width: 80  }
							,{ dataIndex: 'ACCOUNT_NUM_MASK'		,width: 120 }
							,{ dataIndex: 'ACCOUNT_NUM_EXPOS'	   ,width: 120, hidden: true }
							,{ dataIndex: 'ACCOUNT_NUM'		 ,width: 120, hidden: true }
							,{ dataIndex: 'SET_DATE'			,width: 80  }
							,{ dataIndex: 'PERSON_NAME'		 ,width: 80  }
							,{ dataIndex: 'CRDT_COMP_CD'		,width: 100 }
							,{ dataIndex: 'CRDT_COMP_NM'		 ,width: 150}
					]
					,listeners: {
							onGridDblClick:function(grid, record, cellIndex, colName) {
								grid.ownerGrid.returnData();
								popupWin.hide();
							},
							beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {
								var records = creditStore.data.items;
								Ext.each(records, function(record,i) {
									if(record.data['CRDT_FULL_NUM_MASK'] != '***************'){
										record.set('CRDT_FULL_NUM_MASK','***************');
									}
									if(record.data['ACCOUNT_NUM_MASK'] != '***************'){
										record.set('ACCOUNT_NUM_MASK','***************');
									}
								});
							}
					 }
					,returnData: function() {
						var record = this.getSelectedRecord();
						if(Ext.isEmpty(record)) {
							Unilite.messageBox(Msg.sMA0256);
							return false;
						}
						if(popupWin.codeColName) {
							popupWin.returnRecord.set(popupWin.codeColName, record.get("CRDT_NUM"))
						}
						if(popupWin.nameColName) {
							popupWin.returnRecord.set(popupWin.nameColName, record.get("CRDT_NAME"))
						}
						if(popupWin.creditNum) {
							popupWin.returnRecord.set(popupWin.creditNum, record.get("CRDT_FULL_NUM"))
							popupWin.returnRecord.set(popupWin.creditNum+'_EXPOS', record.get("CRDT_FULL_NUM_EXPOS"))
						}
						if(popupWin.companyColName) {
							popupWin.returnRecord.set(popupWin.companyColName, record.get("CRDT_COMP_CD"))
						}
						if(popupWin.companyNmColName) {
							popupWin.returnRecord.set(popupWin.companyNmColName, record.get("CRDT_COMP_NM"))
						}/*
						if(popupWin.rateColNme) {
							popupWin.returnRecord.set(popupWin.rateColNme, record.get("FEE_RATE"))
						}*/
					}
				})],
				tbar:  ['->',
					 {
						itemId : 'searchtBtn',
						text: '조회',
						handler: function() {
							var form = popupWin.down('#search');
							var store = Ext.data.StoreManager.lookup('creditStore')
							creditStore.loadStoreRecords();
						},
						disabled: false
					},
					 {
						itemId : 'submitBtn',
						text: '확인',
						handler: function() {
							popupWin.down('#grid').returnData()
							popupWin.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							popupWin.hide();
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt) {
								popupWin.down('#search').clearForm();
								popupWin.down('#grid').reset();
							},
							 beforeclose: function( panel, eOpts ) {
								popupWin.down('#search').clearForm();
								popupWin.down('#grid').reset();
							},
							 show: function( panel, eOpts ) {
								var form = popupWin.down('#search');
								form.clearForm();
								if(popupWin.rdoType == "TEXT") {
									form.setValue('RDO', '2');
									form.setValue('TXT_SEARCH', popupWin.returnRecord.get(popupWin.nameColName));
								} else {
									form.setValue('RDO', '1');
									if(popupWin.searchTxt) {
//										  form.setValue('TXT_SEARCH', popupWin.returnRecord.get(popupWin.searchTxt));
										if(!Ext.isEmpty(popupWin.searchTxt)){
												form.setValue('INCDRC_GUBUN', 'DEC');
												form.setValue('INCRYP_WORD', popupWin.searchTxt);

												this.fnDecrypt();   //함수내에서 복호화후 조회
										}
										form.setValue('TXT_SEARCH', popupWin.searchTxt); // 카드번호/현금영수증 팝업 띄울시 팝업 SEARCH FIELD에  값 셋팅 안되는 문제 때문에 수정 20161219
									} else {
										form.setValue('TXT_SEARCH', popupWin.returnRecord.get(popupWin.codeColName));
									}

								}
								Ext.data.StoreManager.lookup('creditStore').loadStoreRecords();
							 }
				},
				//조회조건 계좌번호 복호화
				fnDecrypt: function() {
					var form = popupWin.down('#search');
					var param= form.getValues();
					popupService.incryptDecryptPopup(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							form.setValue('TXT_SEARCH', provider);
						}
					})
				}
			});
		}
		if(!(returnRecord.get("DR_CR") == "2" && returnRecord.get("SPEC_DIVI") == "F2" && UniUtils.indexOf(returnRecord.get("PROOF_KIND"),["13","14","15","16","17"]) > -1 )) {
			popupWin.returnRecord	   = returnRecord;
			popupWin.searchTxt		  = searchTxt;
			popupWin.codeColName		= codeColName;
			popupWin.nameColName		= nameColName;
			popupWin.creditNum			= creditNum;
			popupWin.companyColName	 = companyColName;
			popupWin.companyNmColName   = companyNmColName;
			popupWin.rateColNme		 = rateColNme;
			popupWin.rdoType			= rdoType;
			popupWin.center();
			popupWin.show();
		}
		return popupWin;
	}

	function goField(fieldName) {
		var focusField = detailForm.getField(fieldName);
		var fEl = Ext.isEmpty(focusField.el.down('.x-form-cb-input')) ? focusField.el.down('.x-form-field'):focusField.el.down('.x-form-cb-input');
		fEl.focus(10);
	}



	Unilite.Main({
		id			: 'aba800ukrApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[panelResult, {
				region : 'west',
				xtype : 'container',
				layout : 'fit',
				width : 361,
				items : [ masterGrid ]
			},{
				region : 'center',
				xtype : 'container',
				layout:{type:'vbox', align:'stretch'},
//				hight: 500,
				items : [innerForm, detailGrid, detailForm, slipContainer]
			}]
		},
		panelSearch
		],
		fnInitBinding : function(params) {
			if(params && params.data) {
				var r = true;
				if(this.isDirty()) {
					Ext.MessageBox.show({
						msg : '저장되지 않은 자료가 있습니다. 진행하시겠습니까?' ,
						icon: Ext.Msg.WARNING,
						buttons : Ext.MessageBox.OKCANCEL,
						fn : function(buttonId) {
							switch (buttonId) {
								case 'ok' :
									UniAppManager.app.processParams(params);
									break;
								case 'cancel' :
									break;
							}
						},
						scope : this
					}); // MessageBox
				} else {
					UniAppManager.app.processParams(params);
				}
			}
			fnDisabledCondi();		//20200814 추가: 조회조건 필드 setting로직 호출
			fnDisabledInput();		//20200814 추가: 입력조건 필드 setting로직 호출
/*			//20200814: 이전 초기화 로직 주석
			panelSearch.getField('USER_ID').setReadOnly(true);
			panelResult.getField('USER_ID').setReadOnly(true);
			panelSearch.getField('DEPT_CODE').setReadOnly(true);
			panelResult.getField('DEPT_CODE').setReadOnly(true);
			panelSearch.getField('DEPT_NAME').setReadOnly(true);
			panelResult.getField('DEPT_NAME').setReadOnly(true);
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			panelResult.getField('DIV_CODE').setReadOnly(true);

			if(gsChargeDivi != '1'){
				panelSearch.getField('USER_ID').setReadOnly(true);
				panelResult.getField('USER_ID').setReadOnly(true);
				panelSearch.getField('DEPT_CODE').setReadOnly(true);
				panelResult.getField('DEPT_CODE').setReadOnly(true);
				panelSearch.getField('DEPT_NAME').setReadOnly(true);
				panelResult.getField('DEPT_NAME').setReadOnly(true);
				panelSearch.getField('DIV_CODE').setReadOnly(true);
				panelResult.getField('DIV_CODE').setReadOnly(true);
				panelSearch.setValue('USER_ID',UserInfo.userID);
				panelResult.setValue('USER_ID',UserInfo.userID);
				panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
				panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
				panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
				panelResult.setValue('DEPT_NAME',UserInfo.deptName);
				panelSearch.setValue('DIV_CODE',UserInfo.divCode);
				panelResult.setValue('DIV_CODE',UserInfo.divCode);
				innerForm.getField('USER_ID').setReadOnly(true);
				innerForm.getField('DEPT_CODE').setReadOnly(true);
				innerForm.getField('DEPT_NAME').setReadOnly(true);
				innerForm.getField('DIV_CODE').setReadOnly(true);
			}*/
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
			detailGrid.changeFocusCls("aba800ukrGrid1");
			setTimeout(function() { innerForm.getField('AUTO_NM').focus();},1000);
		},
		processParams:function(params){
			if(params && params.data) {
				panelSearch.clearForm();
				panelResult.clearForm();

				detailForm.down('#formFieldArea1').removeAll();
				masterGrid.getStore().loadData({});
				innerForm.clearForm();
				innerForm.setDisabled(false);
				detailGrid.getStore().loadData({});
				slipGrid1.getStore().loadData({});
				slipGrid2.getStore().loadData({});
				
				innerForm.uniOpt.inLoading = true;
				innerForm.setActiveRecord(directMasterStore.getAt(0));
				
				var mRecord = {
					'AUTO_CD'			: '',
					'AUTO_NM'			: '',
					'AUTO_GUBUN'		: '04',
					'AUTO_DATA'			: '',
					'AUTO_DATA_NAME'	: '',
					'USER_ID'			: '',
					'DIV_CODE'			: '',
					'DEPT_CODE'			: '',
					'DEPT_NAME'			: '',
					'KEY_STRING'		: ''
				};
				
				var mRow = masterGrid.createRow(mRecord);
				
				innerForm.uniOpt.inLoading = false;
				
				Ext.each(params.data, function(record, idx){
					record.SEQ=idx+1;
					var newRecord = detailGrid.createRow(record, 'SLIP_DIVI');
					UniAccnt.addMadeFields(detailForm, record, detailForm, '', newRecord);
					detailForm.setActiveRecord(newRecord||null);

//					if(idx == 0) {
//						
//						directMasterStore.loadData([record]);
//						setTimeout(function(){
//							innerForm.uniOpt.inLoading = true;
//							innerForm.setActiveRecord(directMasterStore.getAt(0));
//							innerForm.setValue("AUTO_GUBUN","04");
//							innerForm.setValue("USER_ID","");
//							innerForm.setValue("DIV_CODE","");
//							innerForm.setValue("DEPT_CODE","");
//							innerForm.setValue("DEPT_NAME","");
//							innerForm.setValue("AUTO_CD","");
//							innerForm.setValue("AUTO_NM","");
//							innerForm.uniOpt.inLoading = false;
//						}, 1000);
//					}
				});
				setTimeout(function() { innerForm.getField('AUTO_NM').focus();},1500);
			}
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function(additemCode) {
			/*if(!innerForm.setAllFieldsReadOnly(true)){
				return false;
			}
			*/
			//aba800ukrGrid1 aba800DetailGrid
			if(activeGridId == 'aba800ukrGrid1') {
				if(directDetailStore.isDirty()||directMasterStore.isDirty()) {
					if(!confirm('저장하지 않은 자동분개내역이 있습니다. 저장하시겠습니까?')) {
						UniAppManager.setToolbarButtons('save',false);
						directDetailStore.rejectChanges();
						directMasterStore.rejectChanges();
						detailForm.down('#formFieldArea1').removeAll();
						masterGrid.dirtyChecked = true; // 행 추가 후 beforedeselect 실행 하여 저장여부를 확인을 제외 시키는 조건으로 사용
						masterGrid.createRow({'AUTO_GUBUN':'04'}, null);
						var oldGrid = Ext.getCmp(activeGridId);
						detailGrid.changeFocusCls(oldGrid);
						UniAppManager.app.setActiveGridId(detailGrid.getId());
						innerForm.getField("AUTO_NM").focus();
					} else {
						this.onSaveDataButtonDown();
					}

				} else {
					detailForm.down('#formFieldArea1').removeAll();
					masterGrid.dirtyChecked = true; // 행 추가 후 beforedeselect 실행 하여 저장여부를 확인을 제외 시키는 조건으로 사용
					masterGrid.createRow({'AUTO_GUBUN':'04'}, null);
					var oldGrid = Ext.getCmp(activeGridId);
					detailGrid.changeFocusCls(oldGrid);
					UniAppManager.app.setActiveGridId( detailGrid.getId());
					innerForm.getField("AUTO_NM").focus();
				}

			} else {
				var seq = directDetailStore.max('SEQ');
				 if(!seq) seq = 1;
				 else  seq += 1;
				 var r = {
					AUTO_CD: innerForm.getValue('AUTO_CD'),
					SLIP_DIVI: '3',
					DR_CR: '1',
					DIV_CODE: UserInfo.divCode,
					DEPT_CODE: UserInfo.deptCode,
					DEPT_NAME: UserInfo.deptName,
					COMP_CODE: UserInfo.compCode,
					SEQ: seq
	//				AMT_I: '1'
				};
				if(!masterGrid.getSelectedRecord()) {
					masterGrid.createRow({'AUTO_GUBUN':'04'}, null);
				}
				detailGrid.createRow(r, 'SLIP_DIVI');
			}
		},
		onDeleteDataButtonDown: function() {
			if(activeGridId == 'aba800ukrGrid1') {
				this.onDeleteAllButtonDown();
			} else {
				var selRow = detailGrid.getSelectedRecord();
				if(selRow.phantom === true) {
					detailGrid.deleteSelectedRow();
				} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailGrid.deleteSelectedRow();
					detailForm.down('#formFieldArea1').removeAll();
				}
				if(detailGrid.store.count() == 0) {
					this.onDeleteAllButtonDown();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directDetailStore.data.items;
			if(confirm('전체삭제 하시겠습니까?')) {
				detailGrid.getStore().removeAll();
				detailForm.down('#formFieldArea1').removeAll();
				UniAppManager.app.onSaveDataButtonDown();
				innerForm.setActiveRecord(null);
				innerForm.clearForm();
				innerForm.setDisabled(false);
				masterGrid.deleteSelectedRow();
				directMasterStore.commitChanges();
				slipGrid1.getStore().loadData({});
				slipGrid2.getStore().loadData({});
//				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onSaveDataButtonDown: function (config) {
			//20200813 추가: 분개구분이 변경되었을 때, 신규 데이터 생성을 해야해서 로직 추가
			if(directMasterStore.isDirty() && Ext.isDefined(masterGrid.getSelectedRecord()) && Ext.isDefined(masterGrid.getSelectedRecord().modified) && Ext.isDefined(masterGrid.getSelectedRecord().modified.AUTO_GUBUN) && !Ext.isEmpty(masterGrid.getSelectedRecord().modified.AUTO_GUBUN)) {
				var detailRecords = directDetailStore.data.items;
				extraStore.clearData();
				Ext.each(detailRecords, function(detailRecord, index) {
					detailRecord.phantom = true;
					extraStore.insert(index, detailRecord);

					if (detailRecords.length == index +1) {
						Ext.getCmp('aba800ukrApp').mask();
						extraStore.saveStore();
					}
				})
			} else {
				if(directDetailStore.isDirty()) {
					directDetailStore.saveStore(config);
				} else if(directMasterStore.isDirty()) {
					directMasterStore.saveStore(config);
				}
			}
		},
		onResetButtonDown:function() {
			/*panelSearch.clearForm();
			panelResult.clearForm();

			detailForm.down('#formFieldArea1').removeAll();
			masterGrid.getStore().loadData({});
			innerForm.setActiveRecord(null);
			innerForm.clearForm();
			innerForm.setDisabled(false);
			detailGrid.getStore().loadData({});
			slipGrid1.getStore().loadData({});
			slipGrid2.getStore().loadData({});
			this.fnInitBinding();*/
			activeGridId = 'aba800ukrGrid1';
			this.fnInitBinding();			//20200814 초기화로직 수정
		},
		getActiveGrid:function() { // 관리항목 폼에서 focusNexField 에서 이용
			return detailGrid;
		},
		setAccntInfo:function(record) {
			Ext.getBody().mask();
			var accnt = record.get('ACCNT');
			//UniAccnt.fnIsCostAccnt(accnt, true);
			if(accnt) {
				accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
					var rtnRecord = record;
					if(provider){
						rtnRecord.set("ACCNT", provider.ACCNT);
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

//						UniAppManager.app.fnGetProofKind(rtnRecord, provider.ACCNT_CODE);

						rtnRecord.set("CREDIT_CODE", "");
						rtnRecord.set("REASON_CODE", "");

						var dataMap = rtnRecord.data;
						UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', rtnRecord);
						detailForm.setActiveRecord(rtnRecord||null);
//						UniAppManager.app.fnCheckPendYN(rtnRecord, detailForm);
//						UniAppManager.app.fnSetBillDate(rtnRecord)
//						UniAppManager.app.fnSetDefaultAcCodeI7(rtnRecord);
//						UniAppManager.app.fnSetDefaultAcCodeA6(rtnRecord);

						var slipDivi = rtnRecord.get('SLIP_DIVI');
						if(slipDivi == '1' || slipDivi == '2') {
							if(rtnRecord.get('SPEC_DIVI') == 'A') {
								Unilite.messageBox(Msg.sMA0040);
								UniAppManager.app.clearAccntInfo(rtnRecord, detailForm);
							}
						}
					}
					Ext.getBody().unmask();

				})
			}
		},
		clearAccntInfo:function(record){
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
			record.set("CREDIT_CODE", "");
			record.set("REASON_CODE", "");
			detailForm.down('#formFieldArea1').removeAll();
			Ext.getBody().unmask();
		},
		fnGetProofKind:function(record, billType) {
			var sSaleDivi, sProofKindSet, sBillType = billType;

			if(record.get("DR_CR") == "1" && record.get("SPEC_DIVI") == "F1") {
				sSaleDivi = "1"	;	// 매입
				if(sBillType == "")  sBillType = "51";

			} else if(record.get("DR_CR") == "2" && record.get("SPEC_DIVI") == "F2") {
				sSaleDivi = "2"		// 매출
				if(sBillType == "" ) sBillType == "11";

			} else {
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
				} else {
					sBillType = "51"
				}
				selRecordIdx = store.findBy(function(record){return (record.get("value") == sBillType && record.get("refCode3")==sSaleDivi)});
				selRecord = store.getAt(selRecordIdx);
				if(selRecord) sProofKindNm = selRecord.get("text");
			}
			return {"sBillType":sBillType, "sProofKindNm":sProofKindNm};
		},
		fnSetTaxAmt:function(record, fieldName, nValue) {
			var dAmtI = 0;
			var dTaxRate = 0;
			var dTaxAmt = fieldName=='AMT_I' 	? nValue : Unilite.nvl(record.get('AMT_I'),1);
			var sProofKind = fieldName=='PROOF_KIND' ? nValue : record.get('PROOF_KIND');

			if(record.get('SPEC_DIVI') != 'F1' && record.get('SPEC_DIVI') != 'F2') {
				return false;
			}
			if(dTaxAmt == 0 || Ext.isEmpty(sProofKind)){
				return false;
			}
			dTaxRate = UniAppManager.app.fnGetTaxRate(sProofKind);	//증빙 유형의 부가세율 가져 오기..
			dAmtI = dTaxAmt * dTaxRate;

			this.fnSetAcCode(record, "I1", dAmtI)		// 공급가액
			this.fnSetAcCode(record, "I6", dTaxAmt)		// 세액
		},
		fnSetAcCode:function(record, acCode, acValue) {
			var sValue =  !Ext.isEmpty(acValue)  ? acValue.toString(): "";
			for(var i=1 ; i <= 6; i++) {
				if( record.get('AC_CODE'+i.toString()) == acCode) {
					record.set('AC_DATA'+i.toString(), sValue);
					record.set('AC_DATA_NAME'+i.toString(), '');
				}
			}
		},
		fnGetTaxRate: function(subCode){
			var fRecord ='';
			Ext.each(gsProofKindList, function(item, i) {
				if(item['codeNo'] == subCode) {
					fRecord = item['refCode2'];
					return false;
				}
			});
			return fRecord;
		},
		setActiveGridId:function(strId) {
			activeGridId = strId;
			var check = false
			if(strId == "aba800DetailGrid") {
				if(detailGrid.store.count() > 0) {
					check = true;
				}
			}
			UniAppManager.setToolbarButtons('delete', check);
		},
		fnCheckNoteAmt:function(grid, record, damt, dOldAmt) {
			var lAcDataCol;
			var sSpecDivi;
			var isNew = false;

			for(var i =1 ; i <= 6 ; i++) {
				if('C2' == record.get('AC_CODE'+i.toString())) {
					lAcDataCol = "AC_DATA"+i.toString()
				}
			}
			// 부도어음일 때 어음번호를 관리하지 않을 수 있다.
			if(Ext.isEmpty(lAcDataCol)) {
				isNew = true;
				this.fnSetTaxAmt(record);
				return
			}

			if(Ext.isEmpty(record.get(lAcDataCol))) {
				isNew = true;
				this.fnSetTaxAmt(record);
				return;
			}

			sSpecDivi = record.get('SPEC_DIVI');
			var noteNum = record.get(lAcDataCol);
			UniAccnt.fnGetNoteAmt(UniAppManager.app.cbCheckNoteAmt,noteNum, 0,0, record.get('PROOF_KIND'), damt, dOldAmt, record )
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
					} else {
						isNew = true;
					}
				} else {
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
							return false;
						} else {
							isNew = true;
						}
					} else {
						// 어음 미결제 잔액 계산 (발행금액 - 반제금액)
						var dNoteAmtI = rtn.OC_AMT_I - rtn.J_AMT_I;
						// 반결제여부 확인
						if((dNoteAmtI - newAmt) > 0) {
							if(!confirm(Msg.sMA0330+'\n'+Msg.sMA0333)) {
								record.set(fidleName, oldAmt);
								return false;
							} else {
								isNew = true;
							}
						} else if ((dNoteAmtI - newAmt)  < 0 ) {
							Unilite.messageBox(Msg.sMA0332);
							record.set(fidleName, oldAmt);
							return false;
						} else {
							isNew = true;
						}
					}
				}
				if(isNew){
					UniAppManager.app.fnSetTaxAmt(record, rtn.TAX_RATE);
				}
			}
			return true;
		}
	});

	Unilite.createValidator('validator01', {
		store	: directDetailStore,
		grid	: detailGrid,
		forms	: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue) {
				return true;
			}
			var rv = true;
			switch(fieldName) {
				case 'SLIP_DIVI':
					if(oldValue == newValue) {
						return rv;
					}
					if(newValue == "" ) {
						rv = false;
						return rv;
					}
					if (newValue == '2' || newValue == '3') {
						record.set('DR_CR','1');
					} else {
						record.set('DR_CR','2');
					}
					if (newValue == '1' || newValue == '2') {
						if(record.get('SPEC_DIVI') == 'A') {
							Unilite.messageBox(Msg.sMA0040);
							UniAppManager.app.clearAccntInfo(record);
						}
					}
					break;
				case 'AMT_I' :
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" ) {
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue)
					}
					UniAppManager.app.fnSetTaxAmt(record, fieldName, newValue);
					break;
				case 'PROOF_KIND':
					UniAppManager.app.fnSetTaxAmt(record, fieldName, newValue);
					break;y
				default:
					break;
			}
			return rv;
		}
	});

	//20200814: 필드 setting로직 추가 (fnDisabledCondi, fnDisabledInput)
	function fnDisabledCondi() {		//조회필드 set
		var autoGubun	= panelSearch.getValue('AUTO_GUBUN');
		var sUserid		= panelSearch.getField('USER_ID');
		var sDeptCd		= panelSearch.getField('DEPT_CODE');
		var sDeptNm		= panelSearch.getField('DEPT_NAME');
		var sdivC		= panelSearch.getField('DIV_CODE');
		var sUserid2	= panelResult.getField('USER_ID');
		var sDeptCd2	= panelResult.getField('DEPT_CODE');
		var sDeptNm2	= panelResult.getField('DEPT_NAME');
		var sdivC2		= panelResult.getField('DIV_CODE');

		switch(autoGubun) {
			case '01':	//개인
				sUserid.setReadOnly(false);
				sDeptCd.setReadOnly(true);
				sDeptNm.setReadOnly(true);
				sdivC.setReadOnly(true);
				sUserid2.setReadOnly(false);
				sDeptCd2.setReadOnly(true);
				sDeptNm2.setReadOnly(true);
				sdivC2.setReadOnly(true);

				panelSearch.setValue('USER_ID'	, UserInfo.userID);
				panelSearch.setValue('DEPT_CODE', '');
				panelSearch.setValue('DEPT_NAME', '');
				panelSearch.setValue('DIV_CODE'	, '');
				panelResult.setValue('USER_ID'	, UserInfo.userID);
				panelResult.setValue('DEPT_CODE', '');
				panelResult.setValue('DEPT_NAME', '');
				panelResult.setValue('DIV_CODE'	, '');
			break;

			case '02':	//부서
				sUserid.setReadOnly(true);
				sDeptCd.setReadOnly(false);
				sDeptNm.setReadOnly(false);
				sdivC.setReadOnly(true);
				sUserid2.setReadOnly(true);
				sDeptCd2.setReadOnly(false);
				sDeptNm2.setReadOnly(false);
				sdivC2.setReadOnly(true);

				panelSearch.setValue('USER_ID'	, '');
				panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
				panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
				panelSearch.setValue('DIV_CODE'	, '');
				panelResult.setValue('USER_ID'	, '');
				panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
				panelResult.setValue('DEPT_NAME', UserInfo.deptName);
				panelResult.setValue('DIV_CODE'	, '');
			break;

			case '03':	//사업장
				sUserid.setReadOnly(true);
				sDeptCd.setReadOnly(true);
				sDeptNm.setReadOnly(true);
				sdivC.setReadOnly(false);
				sUserid2.setReadOnly(true);
				sDeptCd2.setReadOnly(true);
				sDeptNm2.setReadOnly(true);
				sdivC2.setReadOnly(false);

				panelSearch.setValue('USER_ID'	, '');
				panelSearch.setValue('DEPT_CODE', '');
				panelSearch.setValue('DEPT_NAME', '');
				panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
				panelResult.setValue('USER_ID'	, '');
				panelResult.setValue('DEPT_CODE', '');
				panelResult.setValue('DEPT_NAME', '');
				panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			break;

			default :
				sUserid.setReadOnly(true);
				sDeptCd.setReadOnly(true);
				sDeptNm.setReadOnly(true);
				sdivC.setReadOnly(true);
				sUserid2.setReadOnly(true);
				sDeptCd2.setReadOnly(true);
				sDeptNm2.setReadOnly(true);
				sdivC2.setReadOnly(true);

				panelSearch.setValue('USER_ID'	, '');
				panelSearch.setValue('DEPT_CODE', '');
				panelSearch.setValue('DEPT_NAME', '');
				panelSearch.setValue('DIV_CODE'	, '');
				panelResult.setValue('USER_ID'	, '');
				panelResult.setValue('DEPT_CODE', '');
				panelResult.setValue('DEPT_NAME', '');
				panelResult.setValue('DIV_CODE'	, '');
			break;
		}

		if(gsChargeDivi != '1'){
			sUserid.setReadOnly(true);
			sDeptCd.setReadOnly(true);
			sDeptNm.setReadOnly(true);
			sdivC.setReadOnly(true);
			sUserid2.setReadOnly(true);
			sDeptCd2.setReadOnly(true);
			sDeptNm2.setReadOnly(true);
			sdivC2.setReadOnly(true);
		}
	}

	function fnDisabledInput() {		//입력필드 set
		var autoGubun	= innerForm.getValue('AUTO_GUBUN');
		var sUserid		= innerForm.getField('USER_ID');
		var sDeptCd		= innerForm.getField('DEPT_CODE');
		var sDeptNm		= innerForm.getField('DEPT_NAME');
		var sdivC		= innerForm.getField('DIV_CODE');
		switch(autoGubun) {
			case '01':	//개인
				sUserid.setReadOnly(false);
				sDeptCd.setReadOnly(true);
				sDeptNm.setReadOnly(true);
				sdivC.setReadOnly(true);
				innerForm.setValue('USER_ID'	, UserInfo.userID);
				innerForm.setValue('DEPT_CODE'	, '');
				innerForm.setValue('DEPT_NAME'	, '');
				innerForm.setValue('DIV_CODE'	, '');
			break;

			case '02':	//부서
				sUserid.setReadOnly(true);
				sDeptCd.setReadOnly(false);
				sDeptNm.setReadOnly(false);
				sdivC.setReadOnly(true);
				innerForm.setValue('USER_ID'	, '');
				innerForm.setValue('DEPT_CODE'	, UserInfo.deptCode);
				innerForm.setValue('DEPT_NAME'	, UserInfo.deptName);
				innerForm.setValue('DIV_CODE'	, '');
			break;

			case '03':	//사업장
				sUserid.setReadOnly(true);
				sDeptCd.setReadOnly(true);
				sDeptNm.setReadOnly(true);
				sdivC.setReadOnly(false);
				innerForm.setValue('USER_ID'	, '');
				innerForm.setValue('DEPT_CODE'	, '');
				innerForm.setValue('DEPT_NAME'	, '');
				innerForm.setValue('DIV_CODE'	, UserInfo.divCode);
			break;

			default :
				sUserid.setReadOnly(true);
				sDeptCd.setReadOnly(true);
				sDeptNm.setReadOnly(true);
				sdivC.setReadOnly(true);
				innerForm.setValue('USER_ID'	, '');
				innerForm.setValue('DEPT_CODE'	, '');
				innerForm.setValue('DEPT_NAME'	, '');
				innerForm.setValue('DIV_CODE'	, '');
			break;
		}

		if(gsChargeDivi != '1'){
			sUserid.setReadOnly(true);
			sDeptCd.setReadOnly(true);
			sDeptNm.setReadOnly(true);
			sdivC.setReadOnly(true);
		}
	}


	//분개구분 시, 저장로직 - 20200813 추가
	var directExtraProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'aba800ukrService.insertNew',
			syncAll	: 'aba800ukrService.saveNew'
		}
	});

	var extraStore = Unilite.createStore('extraextraStore',{
		uniOpt: {
			isMaster	: false,	//상위 버튼 연결
			editable	: false,	//수정 모드 사용
			deletable	: false,	//삭제 가능 여부
			useNavi		: false		//prev | next 버튼 사용
		},
		proxy		: directExtraProxy,
		saveStore	: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var paramMaster	= masterGrid.getSelectedRecord().data;

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						Ext.getCmp('aba800ukrApp').unmask();
						extraStore.clearData();
						UniAppManager.app.onQueryButtonDown();
					},
					failure: function(batch, option) {
						Ext.getCmp('aba800ukrApp').unmask();
						extraStore.clearData();
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
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
};
var activeGridId = 'aba800DetailGrid';
</script>