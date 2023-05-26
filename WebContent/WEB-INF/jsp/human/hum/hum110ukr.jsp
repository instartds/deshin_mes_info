<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum110ukr">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005"/>						<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006"/>						<!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H173"/>						<!-- 직렬 -->
	<t:ExtComboStore comboType="AU" comboCode="H072"/>						<!-- 직종 -->
	<t:ExtComboStore items="${BussOfficeCode}" storeId="BussOfficeCode" />	<!-- 소속지점 -->
	<t:ExtComboStore comboType="AU" comboCode="H011"/>						<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B012"/>						<!-- 국가 -->
	<t:ExtComboStore comboType="AU" comboCode="H028"/>						<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031"/>						<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H024"/>						<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H153"/>						<!-- 마감여부 -->
	<t:ExtComboStore comboType="AU" comboCode="H181"/>						<!-- 사원그룹 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
	var protocol = ("https:" == document.location.protocol)  ? "https" : "http"  ;
	if(protocol == "https") {
		document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
	} else {
		document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
	}
</script>
<script type="text/javascript" >
function appMain() {
	
	var excelWindow;	// 엑셀 업로드
	
	Ext.create('Ext.data.Store',{
		storeId: "sexCodeStore",
		data:[
			{text: '남', value: 'M'},
			{text: '여', value: 'F'}
		]
	});
	Ext.create('Ext.data.Store',{
		storeId: "houseHolderYnStore",
		data:[
			{text: '예', value: '1'},
			{text: '아니오', value: '2'}
		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hum110ukrService.getSelectList',
			update: 'hum110ukrService.updateList',
			create: 'hum110ukrService.insertList',
			destroy: 'hum110ukrService.deleteList',
			syncAll	: 'hum110ukrService.saveAll'
		}
	});

	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hum110ukrModel', {
		fields: [
			{name: 'COMP_CODE',			text: '<t:message code="system.label.human.compcode"			default="법인코드"/>',		type: 'string', defaultValue:UserInfo.comCode},
			{name: 'AUTO_NUM',			text: '',																				type: 'int'},
			{name: 'PROC_YN',			text: '확정여부',																			type: 'string'},
			{name: 'DIV_CODE',			text: '<t:message code="system.label.human.division"			default="사업장"/>',		type: 'string', comboType:'BOR120' , allowBlank: false},
			{name: 'SECT_CODE',			text: '<t:message code="system.label.human.sectcode"			default="신고사업장"/>',		type: 'string', comboType:'BOR120' , allowBlank: false},
			{name: 'PERSON_NUMB',		text: '<t:message code="system.label.human.personnumb"			default="사번"/>',		type: 'string', allowBlank: false},
			{name: 'NAME',				text: '<t:message code="system.label.human.name"				default="성명"/>',		type: 'string', allowBlank: false},
			{name: 'NAME_ENG',			text: '<t:message code="system.label.human.engname"				default="영문명"/>',		type: 'string'},
			{name: 'NAME_CHI',			text: '<t:message code="system.label.human.namechi"				default="한자명"/>',		type: 'string'},
			{name: 'SEX_CODE',			text: '<t:message code="system.label.human.sexcode"				default="성별"/>',		type: 'string', allowBlank: false, store: Ext.data.StoreManager.lookup('sexCodeStore')},
			{name: 'BIRTH_DATE',		text: '<t:message code="system.label.human.birthdate"			default="생년월일"/>',		type: 'uniDate'},

			{name: 'REPRE_NUM',			text: '<t:message code="system.label.human.reprenum"			default="주민등록번호"/>',	type: 'string', allowBlank: false},
			{name: 'REPRE_NUM_EXPOS',	text: '<t:message code="system.label.human.reprenum"			default="주민등록번호"/>',	type: 'string', defaultValue:'***************'},
			
			{name: 'DEPT_CODE',			text: '<t:message code="system.label.human.deptcodet"			default="부서코드"/>',		type: 'string', allowBlank: false},
			{name: 'DEPT_NAME',			text: '<t:message code="system.label.human.deptname"			default="부서명"/>',		type: 'string', allowBlank: false},
			{name: 'POST_CODE',			text: '<t:message code="system.label.human.postcode"			default="직위"/>',		type: 'string', comboType:'AU', comboCode:'H005', allowBlank: false},
			{name: 'ABIL_CODE',			text: '<t:message code="system.label.human.abil"				default="직책"/>',		type: 'string', comboType:'AU', comboCode:'H006'},
			{name: 'AFFIL_CODE',		text: '<t:message code="system.label.human.serial"				default="직렬"/>',		type: 'string', comboType:'AU', comboCode:'H173'},
			{name: 'KNOC',				text: '<t:message code="system.label.human.ocpt"				default="직종"/>',		type: 'string', comboType:'AU', comboCode:"H072"},
			{name: 'BUSS_OFFICE_CODE',	text: '<t:message code="system.label.human.bussofficecode" 		default="소속지점"/>', 		type: 'string', store: Ext.data.StoreManager.lookup('BussOfficeCode')},
			{name: 'PAY_GUBUN',			text: '<t:message code="system.label.human.paygubun"			default="고용형태"/>',		type: 'string', comboType:'AU', comboCode:'H011'},
			{name: 'ZIP_CODE',			text: '<t:message code="system.label.human.zipcode"				default="우편번호"/>',		type: 'string'},
			{name: 'KOR_ADDR',			text: '<t:message code="system.label.human.address2"			default="주소"/>',		type: 'string'},
			{name: 'NATION_CODE',		text: '<t:message code="system.label.human.nationcode"			default="국가"/>',		type: 'string', comboType:'AU', comboCode:'B012'},
			{name: 'LIVE_CODE',			text: '<t:message code="system.label.human.livecode"			default="거주지국"/>',		type: 'string', comboType:'AU', comboCode:'B012'},
			{name: 'JOIN_DATE',			text: '<t:message code="system.label.human.joindate"			default="입사일"/>',		type: 'uniDate', allowBlank: false},
			{name: 'ORI_JOIN_DATE',		text: '<t:message code="system.label.human.firstjoindate"		default="최초입사일"/>',		type: 'uniDate'},
			{name: 'JOIN_CODE',			text: '<t:message code="system.label.human.joinway"				default="입사방식"/>',		type: 'string', comboType:'AU', comboCode:'H012', allowBlank: false},
			{name: 'EMPLOY_TYPE',		text: '<t:message code="system.label.human.employtype"			default="사원구분"/>',		type: 'string', comboType:'AU', comboCode:'H024'},
			{name: 'RETR_OT_KIND',		text: '<t:message code="system.label.human.retrotkind2"			default="퇴직계산분류"/>',	type: 'string', comboType:'AU', comboCode:'H112', allowBlank: false},
			{name: 'JOB_CODE',			text: '<t:message code="system.label.human.jobcode1"			default="담당업무"/>',		type: 'string', comboType:'AU', comboCode:'H008'},
			{name: 'PAY_GRADE_BASE',	text: '<t:message code="system.label.human.paygrade1"			default="호봉"/>',		type: 'string', comboType:'AU', comboCode:'H174'},
			{name: 'PAY_GRADE_01',		text: '<t:message code="system.label.human.paygrade01"			default="급"/>',			type: 'string'},
			{name: 'PAY_GRADE_02',		text: '<t:message code="system.label.human.paygrade02"			default="호"/>',			type: 'string'},
			{name: 'ANNUAL_SALARY_I',	text: '<t:message code="system.label.human.annualsalaryi"		default="연봉"/>',		type: 'uniPrice'},
			{name: 'WAGES_STD_I',		text: '<t:message code="system.label.human.wagesstdi"			default="기본급"/>',		type: 'uniPrice'},
			{name: 'PAY_PROV_FLAG',		text: '<t:message code="system.label.human.payprovflag2"		default="지급차수"/>',		type: 'string', comboType:'AU', comboCode:'H031', allowBlank: false},
			{name: 'PAY_CODE',			text: '<t:message code="system.label.human.paymethodcode"		default="급여지급방식"/>',	type: 'string', comboType:'AU', comboCode:'H028', allowBlank: false},
			{name: 'TAX_CODE',			text: '<t:message code="system.label.human.taxcodeamt"			default="연장수당세액"/>',	type: 'string', comboType:'AU', comboCode:'H030', allowBlank: false},
			{name: 'TAX_CODE2',			text: '<t:message code="system.label.human.taxcode3"			default="보육수당세액"/>',	type: 'string', comboType:'AU', comboCode:'H029', allowBlank: false},
			{name: 'BANK_CODE1',		text: '<t:message code="system.label.human.payrolltrnasferbank"	default="급여이체은행"/>',	type: 'string'},
			{name: 'BANK_NAME1',		text: '<t:message code="system.label.human.payrolltrnasferbank"	default="급여이체은행"/>',	type: 'string'},
			{name: 'BANK_ACCOUNT1',		text: '<t:message code="system.label.human.bankaccount"			default="계좌번호"/>',		type: 'string'},
			{name: 'BANK_ACCOUNT1_EXPOS',text: '<t:message code="system.label.human.bankaccount"		default="계좌번호"/>',		type: 'string', defaultValue:'*************'},
			{name: 'BANKBOOK_NAME',		text: '<t:message code="system.label.human.accountholder"		default="예금주"/>',		type: 'string'},
			{name: 'EMAIL_ADDR',		text: 'E-mail', 																		type: 'string'},
			
			{name: 'MED_AVG_I',			text: '<t:message code="system.label.human.medavgi"				default="보수월액"/>',		type: 'uniPrice'},
			{name: 'ORI_MED_INSUR_I',	text: '<t:message code="system.label.human.orimedinsuri"		default="건강보험료"/>',		type: 'uniPrice'},
			{name: 'OLD_MED_INSUR_I',	text: '<t:message code="system.label.human.oldmedinsuri"		default="노인장기요양"/>',	type: 'uniPrice'},
			{name: 'ANU_BASE_I',		text: '<t:message code="system.label.human.anubasisei"			default="기준소득월액"/>',	type: 'uniPrice'},
			{name: 'ANU_INSUR_I',		text: '<t:message code="system.label.human.anuinsuri"			default="국민연금"/>',		type: 'uniPrice'},
			
			{name: 'MAKE_SALE',			text: '<t:message code="system.label.human.makesale" 			default="제조판관구분"/>',	type: 'string', comboType:"AU", comboCode:"A006"},
			{name: 'PHONE_NO',			text: '<t:message code="system.label.human.cellphone"			default="핸드폰"/>',		type: 'string'},
			{name: 'WEDDING_DATE',		text: '<t:message code="system.label.human.weddingdate"			default="결혼기념일"/>',		type: 'uniDate'},
			{name: 'FOREIGN_NUM',		text: '<t:message code="system.label.human.foreignnum"			default="외국인등록번호"/>',	type: 'string'},
			{name: 'LIVE_GUBUN',		text: '<t:message code="system.label.human.livegubun"			default="거주구분"/>',		type: 'string', comboType:'AU', comboCode:'H115'},
			{name: 'HOUSEHOLDER_YN',	text: '<t:message code="system.label.human.householdyn"			default="세대주여부"/>',		type: 'string', store: Ext.data.StoreManager.lookup('houseHolderYnStore')},
			
			{name: 'NUNB_YN',			text: '사번존재여부', 																		type: 'string'},
			{name: 'REPER_YN',			text: '주민등록번호 존재여부',																	type: 'string'},
			{name: 'CHK_YN',			text: '체크여부',																			type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('hum110ukrMasterStore1',{
		model: 'Hum110ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,		// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad	: false,
		proxy		: directProxy,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			
			if(inValidRecs.length == 0) {
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});


	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',
			id			: 'search_panel1',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}]
		}]
	});
	
	/** 검색조건 (Search Form)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 1, tableAttrs: {width: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			tdAttrs	: {align: 'right'},
			items	: [{
				itemId	: 'excelBtn',
				xtype	: 'button',
				text	: '엑셀참조',
				width	: 100,
				handler	: function() {
					openExcelWindow();
				}
			},{
				itemId	: 'confirmBtn',
				xtype	: 'button',
				text	: '인사마스터 반영',
				width	: 150,
				handler	: function() {
					
					// 변경 사항 존재하는지 체크
					if(UniAppManager.app._needSave()) {
						Unilite.messageBox(Msg.fstMsgH0103); // 먼저 저장 후 다시 작업하십시오.
						return false;
					}
					
					var records = masterGrid.getSelectionModel().getSelection();
					var rtnBol = true;
					// 선택한 값이 없는 경우
					if(records.length < 1){
						Unilite.messageBox(Msg.sMA0256); // 선택된 자료가 없습니다.
						return false;
					}
					
					// 인사테이블에(hum100t)동일한 사번이 존재할 경우 오류
					Ext.each(records, function(record,i){
						if(record.data.NUNB_YN == 'Y'){
							alert("동일한 사번의 사원이 존재합니다.");
							rtnBol = false;
							return false;
						}
					});
					
					// 인사테이블(hum100T)에 동일한 주민등록번호가 존재할 경우 확인
					if(rtnBol){
						var rtnCnt = 0;
						var rtnName = "";
						
						Ext.each(records, function(record,i){
							if(record.data.REPER_YN == 'Y'){
								rtnName += (rtnName == "") ? record.data.NAME : (',' + record.data.NAME);
								rtnCnt ++;
							}
						});
					
						if(rtnCnt > 0){
							Ext.Msg.confirm('<t:message code="system.label.human.delete" default="확인"/>','인사마스터에 [ ' + rtnName + ' ] 사원의 동일한 주민등록번호가 존재합니다.<br>반영하시겠습니까?', function(btn){
								if (btn == 'no') {
									return false;
								}
							});
						}
						// 저장후 조건 세팅
						var config = {
								params: [{"CONFIRM_YN" : 'Y'}],
								success: function(batch, option) {
									UniAppManager.app.onQueryButtonDown();
								}
						};
						directMasterStore.saveStore(config);
					}
				}
			}]
		}]
	});

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('hum110ukrGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: false
		},
		sortableColumns : true,
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [ { dataIndex: 'DIV_CODE'			, width: 100 },
					{ dataIndex: 'SECT_CODE'		, width: 100 },
					{ dataIndex: 'PERSON_NUMB'		, width: 80  , align: 'center'},
					{ dataIndex: 'NAME'				, width: 80  , align: 'center'},
					{ dataIndex: 'NAME_ENG'			, width: 130},
					{ dataIndex: 'NAME_CHI'			, width: 80  , align: 'center'},
					
					{ dataIndex: 'REPRE_NUM'		, width: 100 , hidden: true},
					{ dataIndex: 'REPRE_NUM_EXPOS'	, width: 100 },
					{ dataIndex: 'BIRTH_DATE'		, width: 100},
					{ dataIndex: 'SEX_CODE'			, width: 100 , align: 'center'},
					{ dataIndex: 'DEPT_CODE'		, width: 80  , align: 'center',
						'editor': Unilite.popup('DEPT_G',{
							autoPopup: true,
							listeners: { 'onSelected': {
								fn: function(records, type  ){
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
									grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
								},
								scope: this
								},
								'onClear' : function(type)	{
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('DEPT_CODE','');
									grdRecord.set('DEPT_NAME','');
								}
							}
						})
					},
					{ dataIndex: 'DEPT_NAME'		, width: 100,
						'editor': Unilite.popup('DEPT_G',{
							autoPopup: true,
							listeners: { 'onSelected': {
								fn: function(records, type){
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
									grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
								},
								scope: this
								},
								'onClear' : function(type)	{
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('DEPT_CODE','');
									grdRecord.set('DEPT_NAME','');
								}
							}
						})
					},
					{ dataIndex: 'POST_CODE'		, width: 80  , align: 'center'},
					{ dataIndex: 'ABIL_CODE'		, width: 80  , align: 'center'},
					{ dataIndex: 'AFFIL_CODE'		, width: 80  , align: 'center'},
					{ dataIndex: 'KNOC'				, width: 80  , align: 'center'},
					{ dataIndex: 'BUSS_OFFICE_CODE'	, width: 80  , align: 'center'},
					{ dataIndex: 'PAY_GUBUN'		, width: 80  , align: 'center'},
					{ dataIndex: 'ZIP_CODE'			, width: 80  , align: 'center',
						editor: Unilite.popup('ZIP_G',{
							textFieldName	: 'ZIP_CODE',
							DBtextFieldName	: 'ZIP_CODE',
							autoPopup		: true,
							listeners		: {
								'onSelected': {
									fn: function(records, type){
										var grdRecord = masterGrid.uniOpt.currentRecord;
										grdRecord.set('KOR_ADDR' , records[0]['ZIP_NAME'] + (Ext.isEmpty(records[0]['ADDR2']) ? '':' ' + records[0]['ADDR2']));
										grdRecord.set('ZIP_CODE' , records[0]['ZIP_CODE']);
									},
									scope: this
								},
								'onClear' : function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('KOR_ADDR' , '');
									grdRecord.set('ZIP_CODE' , '');
								}
							}
						})
					},
					{ dataIndex: 'KOR_ADDR'			, width: 250,
						editor: Unilite.popup('ZIP_G',{
							textFieldName	: 'ZIP_CODE',
							DBtextFieldName	: 'ZIP_CODE',
							autoPopup		: true,
							listeners		: {
								'onSelected': {
									fn: function(records, type){
										var grdRecord = masterGrid.uniOpt.currentRecord;
										grdRecord.set('KOR_ADDR'	, records[0]['ZIP_NAME'] + (Ext.isEmpty(records[0]['ADDR2']) ? '':' ' + records[0]['ADDR2']));
										grdRecord.set('ZIP_CODE', records[0]['ZIP_CODE']);
									},
									scope: this
								},
								'onClear' : function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('KOR_ADDR'	, '');
									grdRecord.set('ZIP_CODE', '');
								}
							}
						})},
					{ dataIndex: 'NATION_CODE'		, width: 80  , align: 'center'},
					{ dataIndex: 'LIVE_CODE'		, width: 80  , align: 'center'},
					{ dataIndex: 'JOIN_DATE'		, width: 80  },
					{ dataIndex: 'ORI_JOIN_DATE'	, width: 80},
					{ dataIndex: 'JOIN_CODE'		, width: 80  , align: 'center'},
					{ dataIndex: 'EMPLOY_TYPE'		, width: 80  , align: 'center'},
					{ dataIndex: 'RETR_OT_KIND'		, width: 100 , align: 'center'},
					{ dataIndex: 'JOB_CODE'			, width: 120},
					{ dataIndex: 'PAY_GRADE_BASE'	, width: 80},
					{ dataIndex: 'PAY_GRADE_01'		, width: 80,
						'editor' : Unilite.popup('PAY_GRADE_G',{
							validateBlank : true,
							autoPopup:true,
							listeners: {'onSelected': {
									fn: function(records, type) {
										var grdRecord = masterGrid.uniOpt.currentRecord;
										record = records[0];
										grdRecord.set('PAY_GRADE_01', record.PAY_GRADE_01);
										grdRecord.set('PAY_GRADE_02', record.PAY_GRADE_02);
									},
									scope: this
								},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('PAY_GRADE_01','');
									grdRecord.set('PAY_GRADE_02','');
								}
							}
						})
					},
					{ dataIndex: 'PAY_GRADE_02'		, width: 80,
						'editor' : Unilite.popup('PAY_GRADE_G',{
							validateBlank : true,
							autoPopup:true,
							listeners: {'onSelected': {
									fn: function(records, type) {
										var grdRecord = masterGrid.uniOpt.currentRecord;
										record = records[0];
										grdRecord.set('PAY_GRADE_01', record.PAY_GRADE_01);
										grdRecord.set('PAY_GRADE_02', record.PAY_GRADE_02);
									},
									scope: this
								},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('PAY_GRADE_01','');
									grdRecord.set('PAY_GRADE_02','');
								}
							}
						})
					},
					{ dataIndex: 'ANNUAL_SALARY_I'	, width: 80},
					{ dataIndex: 'WAGES_STD_I'		, width: 80},
					{ dataIndex: 'PAY_PROV_FLAG'	, width: 80 },
					{ dataIndex: 'PAY_CODE'			, width: 100},
					{ dataIndex: 'TAX_CODE'			, width: 100 , align: 'center'},
					{ dataIndex: 'BANK_CODE1'		, width: 100 , align: 'center',
						  editor: Unilite.popup('BANK_G', {
								autoPopup: true,
								DBtextFieldName: 'BANK_CODE',
								listeners: {'onSelected': {
									fn: function(records, type) {
											var rtnRecord = masterGrid.uniOpt.currentRecord;	
											rtnRecord.set('BANK_CODE1', records[0]['BANK_CODE']);
											rtnRecord.set('BANK_NAME1', records[0]['BANK_NAME']);
										},
									scope: this	
									},
									'onClear': function(type) {
										var rtnRecord = masterGrid.uniOpt.currentRecord;
											rtnRecord.set('BANK_CODE1', '');
											rtnRecord.set('BANK_NAME1', '');
									}
								}
							})
					},
					{ dataIndex: 'BANK_NAME1'		, width: 100 , align: 'center',
						  editor: Unilite.popup('BANK_G', {
								autoPopup: true,
								DBtextFieldName: 'BANK_CODE',
								listeners: {'onSelected': {
									fn: function(records, type) {
											var rtnRecord = masterGrid.uniOpt.currentRecord;	
											rtnRecord.set('BANK_CODE1', records[0]['BANK_CODE']);
											rtnRecord.set('BANK_NAME1', records[0]['BANK_NAME']);
										},
									scope: this	
									},
									'onClear': function(type) {
										var rtnRecord = masterGrid.uniOpt.currentRecord;
											rtnRecord.set('BANK_CODE1', '');
											rtnRecord.set('BANK_NAME1', '');
									}
								}
							})
					},
					{ dataIndex: 'BANK_ACCOUNT1'	, width: 100 , hidden: true},
					{ dataIndex: 'BANK_ACCOUNT1_EXPOS'	, width: 100},
					{ dataIndex: 'BANKBOOK_NAME'	, width: 80  , align: 'center'},
					{ dataIndex: 'EMAIL_ADDR'		, width: 150},
					
					{ dataIndex: 'MED_AVG_I'		, width: 100},
					{ dataIndex: 'ORI_MED_INSUR_I'	, width: 100},
					{ dataIndex: 'OLD_MED_INSUR_I'	, width: 120},
					{ dataIndex: 'ANU_BASE_I'		, width: 110},
					{ dataIndex: 'ANU_INSUR_I'		, width: 100},
					
					{ dataIndex: 'MAKE_SALE'		, width: 100 , align: 'center'},
					{ dataIndex: 'PHONE_NO'			, width: 100},
					{ dataIndex: 'WEDDING_DATE'		, width: 80},
					{ dataIndex: 'FOREIGN_NUM'		, width: 80},
					{ dataIndex: 'LIVE_GUBUN'		, width: 100},
					{ dataIndex: 'HOUSEHOLDER_YN'	, width: 100 , align: 'center'},
					{ dataIndex: 'CHK_YN'			, width: 100 , hidden: true}
					
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,	// checkBox
			listeners: {
				// checkbox check
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					if (this.selected.getCount() > 0) {
						var setBtn = false;
						if(UniAppManager.app._needSave()) setBtn = true;
						selectRecord.set('CHK_YN'	, 'Y');
						
						if(!setBtn) UniAppManager.setToolbarButtons(['save'], false);
						panelResult.down('#confirmBtn').enable();
					}
				},
				// checkbox uncheck
				deselect: function(grid, selectRecord, index, eOpts ) {
					if (this.selected.getCount() == 0) {
						selectRecord.set('CHK_YN'	, '');
						panelResult.down('#confirmBtn').disable();
					}
				}
			}
		}),
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field, ['REPRE_NUM_EXPOS', 'BANK_ACCOUNT1_EXPOS'])){
						return false;
					}
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td) {
				// 주민등록번호 더블클릭
				if (colName =="REPRE_NUM_EXPOS") {
					grid.ownerGrid.openRepreNumPopup(record);
				} else if(colName = 'BANK_ACCOUNT1_EXPOS') {
					grid.ownerGrid.openCryptBankPopup(record);
				}
			}
		},
		openRepreNumPopup:function( record ) {
			// 주민등록번호 암호화 보여주기
			if(record) {
				var params = {'REPRE_NUM': record.get('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
			}
		},
		openCryptBankPopup:function( record )	{
			// 계좌번호 암호화 보여주기
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT1'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT1_EXPOS', 'BANK_ACCOUNT1', params);
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				// hum100t에 동일한 사번이 존재할 경우
				if(!Ext.isEmpty(record.get('NUNB_YN')) && record.get('NUNB_YN') == 'Y'){
					cls = 'x-change-celltext_red';
					
				// hum100t에 동일한 주민등록 번호가 존재할 경우
				} else if(!Ext.isEmpty(record.get('REPER_YN')) && record.get('REPER_YN') == 'Y'){
					cls = 'x-change-cell_light';
				}
				return cls;
			}
		}
	});

	Unilite.Main({
		id			: 'hum110ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			// 사업장 default 세션값 세팅
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);

			UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('reset',false);

			panelResult.down('#confirmBtn').disable(); // 인사마스터반영 버튼
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			
			directMasterStore.loadStoreRecords(); //조회
			UniAppManager.setToolbarButtons(['delete', 'reset'], true); // 삭제 신규 버튼 활성화
		},
		onNewDataButtonDown: function() {
			var r = {
				COMP_CODE	: UserInfo.compCode
			};
			masterGrid.createRow(r); // 행추가
			UniAppManager.setToolbarButtons(['delete', 'reset'], true); // 삭제 신규 버튼 활성화
		},
		onResetButtonDown:function() {
			// 초기화
			panelSearch.clearForm();
			panelResult.clearForm();
			
			masterGrid.reset();
			directMasterStore.removeAll();
			directMasterStore.commitChanges();
			
			UniAppManager.app.setToolbarButtons("save", false);
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown : function() {
			var config = {
					success: function(batch, option) {
						UniAppManager.setToolbarButtons('save', false);
					}
				};
			masterGrid.getSelectionModel().deselectAll();
			directMasterStore.saveStore(config);
			
		},
		onDeleteDataButtonDown : function() {
			var selRow = masterGrid.getSelectionModel().getSelection()[0];
			if (!Ext.isEmpty(selRow) && selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			} else {
				if(Ext.isEmpty(selRow)) {
					Unilite.messageBox('선택된 행이 없습니다.', '선택된 행이 없습니다.');
				}
				else {
					Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '선택한행을 삭제 합니다. 삭제 하시겠습니까?', function(btn){
						if (btn == 'yes') {
							masterGrid.deleteSelectedRow();
							UniAppManager.setToolbarButtons('save', true);
							masterGrid.getSelectionModel().deselectAll();
						}
					});
				}
			}
		}
	});

	// 엑셀 팝업 open
	function openExcelWindow() {
		
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		
		if(!directMasterStore.isDirty()) {										//화면에 저장할 내용이 있을 경우 저장여부 확인
			directMasterStore.loadStoreRecords();
		} else {
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
				directMasterStore.loadStoreRecords();
			}
		}

		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
					width		: 600,
					height		: 200,
					modal		: false,
					resizable	: false,
					excelConfigName: 'hum110ukr',
					extParam: {
						'PGM_ID': 'hum110ukr'
					},
					listeners: {
						close: function() {
							this.hide();
						}
					},uploadFile: function() {
						var me = this,
						frm = me.down('#uploadForm')

						if(Ext.isEmpty(frm.getValue('excelFile'))){
							alert(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
							return false;
						}
						
					 	frm.submit({
							params	: me.extParam,
							waitMsg	: 'Uploading...',
							success	: function(form, action) {
								Ext.Msg.alert('Success', 'Upload 성공 하였습니다.');
								
								me.hide();
								UniAppManager.app.onQueryButtonDown();
							},
							failure: function(form, action) {
								Unilite.messageBox(action.result.msg);
							}
						});
						
					},
					// 적용 버튼 삭제
					_setToolBar: function() {
						var me = this;
						me.tbar = [{
							xtype: 'button',
							text : '업로드',
							tooltip : '업로드', 
							handler: function() { 
								me.jobID = null;
								me.uploadFile();
							}
						},
						'->',
						{
							xtype: 'button',
							text : '닫기',
							tooltip : '닫기', 
							handler: function() {
								me.hide();
							}
						}
					]}
			 });
		}
		excelWindow.center();
		excelWindow.show();
	}
};
</script>