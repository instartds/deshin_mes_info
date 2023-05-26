<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agj130ukr">
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장    -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A011"/> <!-- 입력경로		-->
	<t:ExtComboStore comboType="AU" comboCode="A001"/> <!-- 차대구분		-->
	<t:ExtComboStore comboType="AU" comboCode="A005"/> <!-- 입력구분		-->
	<t:ExtComboStore comboType="AU" comboCode="A009"/> <!-- 회계담당자		-->
	<t:ExtComboStore comboType="AU" comboCode="A015"/> <!-- 계정특성		-->
	<t:ExtComboStore comboType="AU" comboCode="A016"/> <!-- 자산부채특성		-->
	<t:ExtComboStore comboType="AU" comboCode="A017"/> <!-- 손익특성		-->
	<t:ExtComboStore comboType="AU" comboCode="A020"/> <!-- 예/아니오		-->
	<t:ExtComboStore comboType="AU" comboCode="A022"/> <!-- 증빙유형		-->
	<t:ExtComboStore comboType="AU" comboCode="A023"/> <!-- 매입매출구분		-->
	<t:ExtComboStore comboType="AU" comboCode="B004"/> <!-- 화폐단위		-->
	<t:ExtComboStore items="${AC_ITEM_LIST}" storeId="acItemList" /><!--관리항목-->
</t:appConfig>
<style>
.x-grid-cell-essential {border: red solid 1px;}
.x-grid-excel-hasWarn {color: red;}
</style>

<script type="text/javascript">

function appMain() {
	var excelWindow;
	var excelUploadJobID;

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch =  Unilite.createSearchPanel('searchForm', {
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
			items:[
			{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox' ,
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}]
		}]
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 5, tableAttrs:{'width':'100%'}},
		padding:0,
		border:true,
		items: [
		{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '',
			name		: 'CHECK_ONLY_NORMAL',
			xtype		: 'checkbox',
			width		: 200,
			value		: true,
			boxLabel	: '체크 시 경고/오류 데이터 제외',
			tdAttrs		: {style:'padding-left:30px;'}
		},{
			xtype	: 'component',
			html	: ' ',
			tdAttrs	: {width : '100%'}
		},{
			xtype	: 'button',
			text	: '엑셀 업로드',
			width	: 120,
			tdAttrs : {align:'right', style:'padding-right:5px;padding-bottom:2px;'},
			handler : function() {
				openExcelWindow();
			}
		},{
			xtype	: 'button',
			text	: '적용',
			width	: 120,
			tdAttrs : {align:'right', style:'padding-right:5px;padding-bottom:2px;'},
			handler : function(form, action) {
				var refRecords = masterGrid.getSelectedRecords();
				var chkData = {records:[]};
				Ext.each(refRecords, function(record, i){
					var hasError = record.get('_EXCEL_HAS_ERROR');
					if(hasError != 'Y' && hasError != 'W') {
						chkData.records.push(record);
					}
				});
				masterGrid.getSelectionModel().select(chkData.records);
				masterGrid.updateHeaderCheckStatus();
				
				directApplyStore.saveStore();
			}
		}]
	});


	/* 그룹 계정과목 List */
	Unilite.defineModel('accntGroupModel', { 
		fields: [ 
			 {name: 'ACCNT'			,text:'계정코드'				,type : 'string'}
			,{name: 'ACCNT_NAME'	,text:'계정과목명'				,type : 'string'}
			,{name: 'GROUP_YN'		,text:'그룹구분'				,type : 'string'}
		]
	});
	var accntGroupStore = Unilite.createStore('accntGroupStore',{
		model: 'accntGroupModel',
		uniOpt: {
			isMaster:	false,			// 상위 버튼 연결 
			editable:	false,			// 수정 모드 사용 
			deletable:	false,			// 삭제 가능 여부 
			useNavi:	false			// prev | newxt 버튼 사용
		},
		autoLoad: true,
		proxy: new Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read: 'accntCommonService.selectGroupAccntCodes'
			}
		})
	});
	
	
	var applyProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'agj100ukrService.insert',
			syncAll	: 'agj100ukrService.saveAll'
		}
	});
	
	Unilite.defineModel('applyModel', { 
		fields: [
			 {name: 'AC_DAY'			,text:'일자'				,type : 'string'}
			,{name: 'SLIP_NUM'			,text:'번호'				,type : 'int'}
			,{name: 'SLIP_SEQ'			,text:'순번'				,type : 'int'}
			,{name: 'SLIP_DIVI'			,text:'구분'				,type : 'string'}
			,{name: 'ACCNT'				,text:'계정코드'			,type : 'string'}
			,{name: 'ACCNT_NAME'		,text:'계정과목명'			,type : 'string'}
			,{name: 'CUSTOM_CODE'		,text:'거래처'				,type : 'string'}
			,{name: 'CUSTOM_NAME'		,text:'거래처명'			,type : 'string'}
			,{name: 'DR_AMT_I'			,text:'차변금액'			,type : 'uniPrice'}
			,{name: 'CR_AMT_I'			,text:'대변금액'			,type : 'uniPrice'}
			,{name: 'REMARK'			,text:'적요'				,type : 'string'}
			,{name: 'PROOF_KIND_NM'		,text:'증빙유형'			,type : 'string'}
			,{name: 'DEPT_NAME'			,text:'귀속부서'			,type : 'string'}
			,{name: 'DIV_CODE'			,text:'사업장'				,type : 'string'}
			,{name: 'OLD_AC_DATE'		,text:'OLD_AC_DATE'		,type : 'uniDate'}
			,{name: 'OLD_SLIP_NUM'		,text:'OLD_SLIP_NUM'	,type : 'int'}
			,{name: 'OLD_SLIP_SEQ'		,text:'OLD_SLIP_SEQ'	,type : 'int'}
			,{name: 'AC_DATE'			,text:'회계전표일자'			,type : 'uniDate'}
			,{name: 'DR_CR'				,text:'차대구분'			,type : 'string'}
			,{name: 'P_ACCNT'			,text:'상대계정코드'			,type : 'string'}
			,{name: 'DEPT_CODE'			,text:'귀속부서코드'			,type : 'string'}
			,{name: 'PROOF_KIND'		,text:'증빙유형'			,type : 'string'}
			,{name: 'CREDIT_CODE'		,text:'신용카드사코드'			,type : 'string'}
			,{name: 'REASON_CODE'		,text:'불공제사유코드'			,type : 'string'}
			,{name: 'CREDIT_NUM'		,text:'카드번호/현금영수증(DB)'	,type : 'string'}
			,{name: 'CREDIT_NUM_EXPOS'	,text:'카드번호/현금영수증'		,type : 'string'}
			,{name: 'CREDIT_NUM_MASK'	,text:'카드번호/현금영수증'		,type : 'string'}
			,{name: 'MONEY_UNIT'		,text:'화폐단위'			,type : 'string'}
			,{name: 'EXCHG_RATE_O'		,text:'환율'				,type : 'uniER'}
			,{name: 'FOR_AMT_I'			,text:'외화금액'			,type : 'uniFC'}
			,{name: 'IN_DIV_CODE'		,text:'결의사업장코드'			,type : 'string'}
			,{name: 'IN_DEPT_CODE'		,text:'결의부서코드'			,type : 'string'}
			,{name: 'IN_DEPT_NAME'		,text:'결의부서'			,type : 'string'}
			,{name: 'BILL_DIV_CODE'		,text:'신고사업장코드'			,type : 'string'}
			,{name: 'AC_CODE1'			,text:'관리항목코드1'			,type : 'string'}
			,{name: 'AC_CODE2'			,text:'관리항목코드2'			,type : 'string'}
			,{name: 'AC_CODE3'			,text:'관리항목코드3'			,type : 'string'}
			,{name: 'AC_CODE4'			,text:'관리항목코드4'			,type : 'string'}
			,{name: 'AC_CODE5'			,text:'관리항목코드5'			,type : 'string'}
			,{name: 'AC_CODE6'			,text:'관리항목코드6'			,type : 'string'}
			,{name: 'AC_NAME1'			,text:'관리항목명1'			,type : 'string'}
			,{name: 'AC_NAME2'			,text:'관리항목명2'			,type : 'string'}
			,{name: 'AC_NAME3'			,text:'관리항목명3'			,type : 'string'}
			,{name: 'AC_NAME4'			,text:'관리항목명4'			,type : 'string'}
			,{name: 'AC_NAME5'			,text:'관리항목명5'			,type : 'string'}
			,{name: 'AC_NAME6'			,text:'관리항목명6'			,type : 'string'}
			,{name: 'AC_DATA1'			,text:'관리항목데이터1'		,type : 'string'}
			,{name: 'AC_DATA2'			,text:'관리항목데이터2'		,type : 'string'}
			,{name: 'AC_DATA3'			,text:'관리항목데이터3'		,type : 'string'}
			,{name: 'AC_DATA4'			,text:'관리항목데이터4'		,type : 'string'}
			,{name: 'AC_DATA5'			,text:'관리항목데이터5'		,type : 'string'}
			,{name: 'AC_DATA6'			,text:'관리항목데이터6'		,type : 'string'}
			,{name: 'AC_DATA_NAME1'		,text:'관리항목데이터명1'		,type : 'string'}
			,{name: 'AC_DATA_NAME2'		,text:'관리항목데이터명2'		,type : 'string'}
			,{name: 'AC_DATA_NAME3'		,text:'관리항목데이터명3'		,type : 'string'}
			,{name: 'AC_DATA_NAME4'		,text:'관리항목데이터명4'		,type : 'string'}
			,{name: 'AC_DATA_NAME5'		,text:'관리항목데이터명5'		,type : 'string'}
			,{name: 'AC_DATA_NAME6'		,text:'관리항목데이터명6'		,type : 'string'}
			,{name: 'BOOK_CODE1'		,text:'계정잔액코드1'			,type : 'string'}
			,{name: 'BOOK_CODE2'		,text:'계정잔액코드2'			,type : 'string'}
			,{name: 'BOOK_DATA1'		,text:'계정잔액데이터1'		,type : 'string'}
			,{name: 'BOOK_DATA2'		,text:'계정잔액데이터2'		,type : 'string'}
			,{name: 'BOOK_DATA_NAME1'	,text:'계정잔액데이터명1'		,type : 'string'}
			,{name: 'BOOK_DATA_NAME2'	,text:'계정잔액데이터명2'		,type : 'string'}
			,{name: 'ACCNT_SPEC'		,text:'계정특성'			,type : 'string'}
			,{name: 'SPEC_DIVI'			,text:'자산부채특성'			,type : 'string'}
			,{name: 'PROFIT_DIVI'		,text:'손익특성'			,type : 'string'}
			,{name: 'JAN_DIVI'			,text:'잔액변(차대)'			,type : 'string'}
			,{name: 'PEND_YN'			,text:'미결관리여부'			,type : 'string'}
			,{name: 'PEND_CODE'			,text:'미결항목'			,type : 'string'}
			,{name: 'PEND_DATA_CODE'	,text:'미결항목데이터코드'		,type : 'string'}
			,{name: 'BUDG_YN'			,text:'예산사용여부'			,type : 'string'}
			,{name: 'BUDGCTL_YN'		,text:'예산통제여부'			,type : 'string'}
			,{name: 'FOR_YN'			,text:'외화구분'			,type : 'string'}
			,{name: 'POSTIT_YN'			,text:'주석체크여부'			,type : 'string'}
			,{name: 'POSTIT'			,text:'주석내용'			,type : 'string'}
			,{name: 'POSTIT_USER_ID'	,text:'주석체크자'			,type : 'string'}
			,{name: 'INPUT_PATH'		,text:'입력경로'			,type : 'string'}
			,{name: 'INPUT_DIVI'		,text:'전표입력경로'			,type : 'string'}
			,{name: 'AUTO_SLIP_NUM'		,text:'자동기표번호'			,type : 'string'}
			,{name: 'CLOSE_FG'			,text:'마감여부'			,type : 'string'}
			,{name: 'INPUT_DATE'		,text:'입력일자'			,type : 'string'}
			,{name: 'INPUT_USER_ID'		,text:'입력자ID'			,type : 'string'}
			,{name: 'CHARGE_CODE'		,text:'담당자코드'			,type : 'string'}
			,{name: 'CHARGE_NAME'		,text:'담당자명'			,type : 'string'}
			,{name: 'AP_STS'			,text:'승인상태'			,type : 'string'}
			,{name: 'AP_DATE'			,text:'승인처리일'			,type : 'string'}
			,{name: 'AP_USER_ID'		,text:'승인자ID'			,type : 'string'}
			,{name: 'EX_DATE'			,text:'회계전표일자'			,type : 'string'}
			,{name: 'EX_NUM'			,text:'회계전표번호'			,type : 'int'}
			,{name: 'EX_SEQ'			,text:'회계전표순번'			,type : 'string'}
			,{name: 'ASST_SUPPLY_AMT_I'	,text:'고정자산과표'			,type : 'uniPrice'}
			,{name: 'ASST_TAX_AMT_I'	,text:'고정자산세액'			,type : 'uniPrice'}
			,{name: 'ASST_DIVI'			,text:'자산구분'			,type : 'string'}
			,{name: 'AC_CTL1'			,text:'관리항목필수1'			,type : 'string'}
			,{name: 'AC_CTL2'			,text:'관리항목필수2'			,type : 'string'}
			,{name: 'AC_CTL3'			,text:'관리항목필수3'			,type : 'string'}
			,{name: 'AC_CTL4'			,text:'관리항목필수4'			,type : 'string'}
			,{name: 'AC_CTL5'			,text:'관리항목필수5'			,type : 'string'}
			,{name: 'AC_CTL6'			,text:'관리항목필수6'			,type : 'string'}
			,{name: 'AC_TYPE1'			,text:'관리항목1유형'			,type : 'string'}
			,{name: 'AC_TYPE2'			,text:'관리항목2유형'			,type : 'string'}
			,{name: 'AC_TYPE3'			,text:'관리항목3유형'			,type : 'string'}
			,{name: 'AC_TYPE4'			,text:'관리항목4유형'			,type : 'string'}
			,{name: 'AC_TYPE5'			,text:'관리항목5유형'			,type : 'string'}
			,{name: 'AC_TYPE6'			,text:'관리항목6유형'			,type : 'string'}
			,{name: 'AC_LEN1'			,text:'관리항목1길이'			,type : 'string'}
			,{name: 'AC_LEN2'			,text:'관리항목2길이'			,type : 'string'}
			,{name: 'AC_LEN3'			,text:'관리항목3길이'			,type : 'string'}
			,{name: 'AC_LEN4'			,text:'관리항목4길이'			,type : 'string'}
			,{name: 'AC_LEN5'			,text:'관리항목5길이'			,type : 'string'}
			,{name: 'AC_LEN6'			,text:'관리항목6길이'			,type : 'string'}
			,{name: 'AC_POPUP1'			,text:'관리항목1팝업여부'		,type : 'string'}
			,{name: 'AC_POPUP2'			,text:'관리항목2팝업여부'		,type : 'string'}
			,{name: 'AC_POPUP3'			,text:'관리항목3팝업여부'		,type : 'string'}
			,{name: 'AC_POPUP4'			,text:'관리항목4팝업여부'		,type : 'string'}
			,{name: 'AC_POPUP5'			,text:'관리항목5팝업여부'		,type : 'string'}
			,{name: 'AC_POPUP6'			,text:'관리항목6팝업여부'		,type : 'string'}
			,{name: 'AC_FORMAT1'		,text:'관리항목1포멧'			,type : 'string'}
			,{name: 'AC_FORMAT2'		,text:'관리항목2포멧'			,type : 'string'}
			,{name: 'AC_FORMAT3'		,text:'관리항목3포멧'			,type : 'string'}
			,{name: 'AC_FORMAT4'		,text:'관리항목4포멧'			,type : 'string'}
			,{name: 'AC_FORMAT5'		,text:'관리항목5포멧'			,type : 'string'}
			,{name: 'AC_FORMAT6'		,text:'관리항목6포멧'			,type : 'string'}
			,{name: 'COMP_CODE'			,text:'법인코드'			,type : 'string'}
			,{name: 'AMT_I'				,text:'금액'				,type : 'uniPrice'}
			,{name: 'DRAFT_YN'			,text:'기안여부(E-Ware)'	,type : 'string'}
			,{name: 'AGREE_YN'			,text:'결재완료(E-Ware)'	,type : 'string'}
			,{name: 'CASH_NUM'			,text:'CASH_NUM'		,type : 'string'}
			,{name: 'OPR_FLAG'			,text:'editFlag'		,type : 'string'}
			,{name: 'AP_CHARGE_CODE'	,text:''				,type : 'string'}
			/*계정코드 복사용 필수입력*/
			,{name: 'CR_CTL1'			,text:'관리항목필수1'			,type : 'string'}
			,{name: 'CR_CTL2'			,text:'관리항목필수2'			,type : 'string'}
			,{name: 'CR_CTL3'			,text:'관리항목필수3'			,type : 'string'}
			,{name: 'CR_CTL4'			,text:'관리항목필수4'			,type : 'string'}
			,{name: 'CR_CTL5'			,text:'관리항목필수5'			,type : 'string'}
			,{name: 'CR_CTL6'			,text:'관리항목필수6'			,type : 'string'}
			,{name: 'DR_CTL1'			,text:'관리항목필수1'			,type : 'string'}
			,{name: 'DR_CTL2'			,text:'관리항목필수2'			,type : 'string'}
			,{name: 'DR_CTL3'			,text:'관리항목필수3'			,type : 'string'}
			,{name: 'DR_CTL4'			,text:'관리항목필수4'			,type : 'string'}
			,{name: 'DR_CTL5'			,text:'관리항목필수5'			,type : 'string'}
			,{name: 'DR_CTL6'			,text:'관리항목필수6'			,type : 'string'}
			/*계정코드 복사용 필수입력*/
		]
	});
	
	var directApplyStore = Unilite.createStore('agj130ukrApplyStore',
	{
		model: 'applyModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,	// 상위 버튼 연결
			editable: true,		// 수정 모드 사용
			deletable:true,		// 삭제 가능 여부
			allDeletable:true,
			useNavi : false		// prev | next 버튼 사용
		},
		proxy: applyProxy,
		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore : function(config) {
			var paramMaster = {};
			var refRecords = masterGrid.getSelectedRecords();
			var insertRecords = new Array();
			
			Ext.each(refRecords, function(record, i){
				var r = {
					AC_DAY				: String(record.get('EX_DATE')).substring(6, 2),
					AC_DATE				: record.get('EX_DATE'),
					SLIP_NUM			: record.get('EX_NUM'),
					SLIP_SEQ			: record.get('EX_SEQ'),
					EX_DATE				: record.get('EX_DATE'),
					EX_NUM				: record.get('EX_NUM'),
					EX_SEQ				: record.get('EX_SEQ'),
					SLIP_DIVI			: record.get('SLIP_DIVI'),
					DR_CR				: record.get('DR_CR'),
					ACCNT				: record.get('ACCNT'),
					ACCNT_NAME			: record.get('ACCNT_NAME'),
					P_ACCNT				: record.get('P_ACCNT'),
					CUSTOM_CODE			: record.get('CUSTOM_CODE'),
					CUSTOM_NAME			: record.get('CUSTOM_NAME'),
					DR_AMT_I			: (record.get('DR_CR') == '1' ? record.get('AMT_I') : 0),
					CR_AMT_I			: (record.get('DR_CR') == '2' ? record.get('AMT_I') : 0),
					REMARK				: record.get('REMARK'),
					DEPT_NAME			: record.get('DEPT_NAME'),
					DIV_CODE			: record.get('DIV_CODE'),
					DEPT_CODE			: record.get('DEPT_CODE'),
					PROOF_KIND			: record.get('PROOF_KIND'),
					CREDIT_CODE			: record.get('CREDIT_CODE'),
					REASON_CODE			: record.get('REASON_CODE'),
					CREDIT_NUM			: record.get('CREDIT_NUM'),
					MONEY_UNIT			: record.get('MONEY_UNIT'),
					EXCHG_RATE_O		: record.get('EXCHG_RATE_O'),
					FOR_AMT_I			: record.get('FOR_AMT_I'),
					IN_DIV_CODE			: record.get('IN_DIV_CODE'),
					IN_DEPT_CODE		: record.get('IN_DEPT_CODE'),
					IN_DEPT_NAME		: record.get('IN_DEPT_NAME'),
					BILL_DIV_CODE		: record.get('BILL_DIV_CODE'),
					AC_CODE1			: record.get('AC_CODE1'),
					AC_CODE2			: record.get('AC_CODE2'),
					AC_CODE3			: record.get('AC_CODE3'),
					AC_CODE4			: record.get('AC_CODE4'),
					AC_CODE5			: record.get('AC_CODE5'),
					AC_CODE6			: record.get('AC_CODE6'),
					AC_NAME1			: record.get('AC_NAME1'),
					AC_NAME2			: record.get('AC_NAME2'),
					AC_NAME3			: record.get('AC_NAME3'),
					AC_NAME4			: record.get('AC_NAME4'),
					AC_NAME5			: record.get('AC_NAME5'),
					AC_NAME6			: record.get('AC_NAME6'),
					AC_DATA1			: record.get('AC_DATA1'),
					AC_DATA2			: record.get('AC_DATA2'),
					AC_DATA3			: record.get('AC_DATA3'),
					AC_DATA4			: record.get('AC_DATA4'),
					AC_DATA5			: record.get('AC_DATA5'),
					AC_DATA6			: record.get('AC_DATA6'),
					AC_DATA_NAME1		: record.get('AC_DATA_NAME1'),
					AC_DATA_NAME2		: record.get('AC_DATA_NAME2'),
					AC_DATA_NAME3		: record.get('AC_DATA_NAME3'),
					AC_DATA_NAME4		: record.get('AC_DATA_NAME4'),
					AC_DATA_NAME5		: record.get('AC_DATA_NAME5'),
					AC_DATA_NAME6		: record.get('AC_DATA_NAME6'),
					BOOK_CODE1			: record.get('BOOK_CODE1'),
					BOOK_CODE2			: record.get('BOOK_CODE2'),
					BOOK_DATA1			: record.get('BOOK_DATA1'),
					BOOK_DATA2			: record.get('BOOK_DATA2'),
					BOOK_DATA_NAME1		: record.get('BOOK_DATA_NAME1'),
					BOOK_DATA_NAME2		: record.get('BOOK_DATA_NAME2'),
					ACCNT_SPEC			: record.get('ACCNT_SPEC'),
					SPEC_DIVI			: record.get('SPEC_DIVI'),
					PROFIT_DIVI			: record.get('PROFIT_DIVI'),
					JAN_DIVI			: record.get('JAN_DIVI'),
					PEND_YN				: record.get('PEND_YN'),
					PEND_CODE			: record.get('PEND_CODE'),
					PEND_DATA_CODE		: record.get('PEND_DATA_CODE'),
					BUDG_YN				: record.get('BUDG_YN'),
					BUDGCTL_YN			: record.get('BUDGCTL_YN'),
					FOR_YN				: record.get('FOR_YN'),
					POSTIT_YN			: record.get('POSTIT_YN'),
					POSTIT				: record.get('POSTIT'),
					POSTIT_USER_ID		: record.get('POSTIT_USER_ID'),
					INPUT_PATH			: record.get('INPUT_PATH'),
					INPUT_DIVI			: record.get('INPUT_DIVI'),
					AUTO_SLIP_NUM		: record.get('AUTO_SLIP_NUM'),
					CLOSE_FG			: record.get('CLOSE_FG'),
					INPUT_DATE			: record.get('INPUT_DATE'),
					INPUT_USER_ID		: record.get('INPUT_USER_ID'),
					CHARGE_CODE			: record.get('CHARGE_CODE'),
					AP_STS				: '1',
					AP_DATE				: record.get('AP_DATE'),
					AP_USER_ID			: record.get('AP_USER_ID'),
					ASST_SUPPLY_AMT_I	: record.get('ASST_SUPPLY_AMT_I'),
					ASST_TAX_AMT_I		: record.get('ASST_TAX_AMT_I'),
					ASST_DIVI			: record.get('ASST_DIVI'),
					AC_CTL1				: record.get('AC_CTL1'),
					AC_CTL2				: record.get('AC_CTL2'),
					AC_CTL3				: record.get('AC_CTL3'),
					AC_CTL4				: record.get('AC_CTL4'),
					AC_CTL5				: record.get('AC_CTL5'),
					AC_CTL6				: record.get('AC_CTL6'),
					COMP_CODE			: record.get('COMP_CODE'),
					AMT_I				: record.get('AMT_I'),
					DRAFT_YN			: record.get('DRAFT_YN'),
					AGREE_YN			: record.get('AGREE_YN'),
					CASH_NUM			: record.get('CASH_NUM'),
					OPR_FLAG			: 'N',
					AP_CHARGE_CODE		: '',
					OLD_AC_DATE			: record.get('EX_DATE'),
					OLD_SLIP_NUM		: record.get('EX_NUM'),
					OLD_SLIP_SEQ		: record.get('EX_SEQ')
				};
				insertRecords.push(directApplyStore.model.create( r ));
			});
			
			var chk = true;
			Ext.each(insertRecords, function(rec){
				//그룹계정 코드가 있는지 체크
				var isGroupAccnt = directApplyStore.chkGroupAccnt(rec.get("ACCNT"));
				if(!isGroupAccnt) {
					chk = false;
					var detailForm = Ext.getCmp(detailFormID);
					UniAppManager.app.clearAccntInfo(rec, detailForm);
					Unilite.messageBox("그룹 계정이 포함되어 있습니다. 계정코드를 다시 선택하세요.");
				}
				//고정자산 증빙유형 필수사항 체크
				
				if(rec.get("PROOF_KIND") == "55" || rec.get("PROOF_KIND") == "61" || rec.get("PROOF_KIND") == "68" || rec.get("PROOF_KIND") == "69" ) {
					if(Ext.isEmpty(rec.get("ASST_SUPPLY_AMT_I")) ) {
						rec.set("ASST_SUPPLY_AMT_I", 0);
					}
					if(Ext.isEmpty(rec.get("ASST_TAX_AMT_I")) ) {
						rec.set("ASST_TAX_AMT_I", 0);
					}
					if(Ext.isEmpty(rec.get("ASST_DIVI")) ) {
						chk = false;
						Unilite.messageBox("자산구분 값을 입력하세요.");
					}
				}
				
				if(!chk) {
					return;
				}
				
				//관리항목 필수 사항 체크
				for(var i = 1; i <= 6; i++) {
					if(rec.get("AC_CTL"+i.toString()) =="Y" ) {
						if(Ext.isEmpty(rec.get("AC_DATA"+i.toString()))) {
							Unilite.messageBox("전표번호 " + rec.get("SLIP_NUM")+",전표순번 "+rec.get("SLIP_SEQ")+"의 "+rec.get("AC_NAME"+i.toString())+"을(를) 입력해 주세요.");
							chk=false;
							break;
						}
					}
				}
			});
			
			if(!chk) {
				return;
			}
		
			//차대변 금액이 일치하는지 검사
			var checkDCSum = this.checkSum();
			if(checkDCSum !== true) {
				if(checkDCSum == false) {
					Unilite.messageBox("차변대변 과목을 모두 입력하십시오.");
				} else {
					Unilite.messageBox(Msg.sMA0052+'\n'+'전표번호:'+checkDCSum);
				}
				return;
			}
			
			this.loadData(insertRecords);
			
			config = {
				params: [paramMaster],
				success: function(batch, option) {
					var response, responseText = {};
					response = true;
					Ext.each(batch.getOperations(), function(operation, idx){
						if(operation.complete && !operation.success){
							response = false;
							return;
						}
					});
					
					if(response) {
						Ext.Msg.confirm('확인', '업로드가 완료되었습니다.<br>업로드한 데이터를 삭제하시겠습니까?', function(btn){
							if(btn == 'yes') {
								masterGrid.deleteSelectedRow();
								UniAppManager.app.onSaveDataButtonDown();
							}
						});
					}
				}
			};
			
			this.syncAllDirect(config);
		},
		chkGroupAccnt: function(accntCode){
			//그룹계정코드인지 확인
			var groupChk = true;
			Ext.each(accntGroupStore.getData().items, function(item, idx){
				if(item.get("ACCNT") == accntCode) {
					groupChk = false;
				}
			});
			return groupChk;
		},
		checkSum:function(changedRec) {
			var rtn = true;
			var store = this;
			Ext.each(changedRec, function(rec)  {
				var cr_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== rec.get("AC_DAY") && record.get('SLIP_NUM')== rec.get("SLIP_NUM") && record.get('DR_CR') == '2') } ).items);	  
				var dr_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== rec.get("AC_DAY") && record.get('SLIP_NUM')== rec.get("SLIP_NUM") && record.get('DR_CR') == '1') } ).items);	  
				
				var crSum=0;
				var crLen = cr_data.length;
				var drSum=0;
				var drLen = dr_data.length;
				
				if((crLen + drLen) == 1) {
					rtn = false;
					return false;
				}
				
				Ext.each(cr_data, function(item){
					crSum += item.get("AMT_I");
					if(Ext.isEmpty(item.get('CASH_NUM'))) {
						if(drLen == 1)  {
							item.set('P_ACCNT', dr_data[0].get('ACCNT'));
						}else {
							item.set('P_ACCNT', '99999');
						}
					}
				});
				
				Ext.each(dr_data, function(item){
					drSum += item.get("AMT_I");
					if(Ext.isEmpty(item.get('CASH_NUM'))) {
						if(crLen == 1)  {
							item.set('P_ACCNT', cr_data[0].get('ACCNT'));
						}else {
							item.set('P_ACCNT', '99999');
						}
					}
				});
				
				crSum = crSum.toFixed(6);
				drSum = drSum.toFixed(6);
				console.log("crSum : ", crSum ," drSum =",drSum);
				
				if(crSum != drSum ) {
					rtn = rec.get('SLIP_NUM');
				}
			});
			
			return rtn;
		}
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'agj130ukrService.selectList',
			update	: 'agj130ukrService.updateDetail',
			destroy	: 'agj130ukrService.deleteDetail',
			syncAll	: 'agj130ukrService.saveAll'
		}
	});
	
	/**
	 * Model 정의 
	 * @type
	 */
	Unilite.defineModel('agj130ukrMasterModel', {
		fields: [
			 {name: '_EXCEL_JOBID'		,text: 'EXCEL_JOBID'		,type: 'string'	, allowBlank:false}
			,{name: '_EXCEL_ROWNUM'		,text: 'EXCEL_ROWNUM'		,type: 'int'	, allowBlank:false}
			,{name: '_EXCEL_HAS_ERROR'	,text: 'EXCEL_HAS_ERROR'	,type: 'string'}
			,{name: '_EXCEL_ERROR_MSG'	,text: '오류메세지'				,type: 'string'}
			,{name: 'COMP_CODE'			,text: '법인'					,type: 'string'	, allowBlank:false}
			,{name: 'EX_DATE'			,text: '결의일'				,type: 'uniDate', allowBlank:false}
			,{name: 'EX_NUM'			,text: '전표번호'				,type: 'int'	, allowBlank:false}
			,{name: 'EX_SEQ'			,text: '전표순번'				,type: 'int'	, allowBlank:false}
			,{name: 'SLIP_DIVI'			,text: '전표구분'				,type: 'string'	, allowBlank:false	, comboType:'AU', comboCode:'A005'}
			,{name: 'DR_CR'				,text: '차대구분'				,type: 'string'	, allowBlank:false	, comboType:'AU', comboCode:'A001'}
			,{name: 'CASH_NUM'			,text: '현금구분'				,type: 'string'}
			,{name: 'ACCNT'				,text: '계정코드'				,type: 'string'	, allowBlank:false}
			,{name: 'ACCNT_NAME'		,text: '계정명'				,type: 'string'	, allowBlank:false}
			,{name: 'P_ACCNT'			,text: '상대계정코드'				,type: 'string'}
			,{name: 'CUSTOM_CODE'		,text: '거래처코드'				,type: 'string'}
			,{name: 'CUSTOM_NAME'		,text: '거래처명'				,type: 'string'	, allowBlank:false}
			,{name: 'MONEY_UNIT'		,text: '화폐단위'				,type: 'string'	, allowBlank:false	, comboType:'AU', comboCode:'B004'}
			,{name: 'EXCHG_RATE_O'		,text: '환율'					,type: 'uniER'}
			,{name: 'AMT_I'				,text: '금액'					,type: 'uniPrice', allowBlank:false}
			,{name: 'FOR_AMT_I'			,text: '외화금액'				,type: 'uniFC'}
			,{name: 'REMARK'			,text: '적요'					,type: 'string'	, maxLength:100 }
			,{name: 'IN_DIV_CODE'		,text: '입력사업장'				,type: 'string'	, comboType:'BOR120'} 
			,{name: 'IN_DEPT_CODE'		,text: '입력부서코드'				,type: 'string'} 
			,{name: 'IN_DEPT_NAME'		,text: '입력부서명'				,type: 'string'}
			,{name: 'DIV_CODE'			,text: '사업장'				,type: 'string'	, allowBlank:false	, comboType:'BOR120'}
			,{name: 'DEPT_CODE'			,text: '부서코드'				,type: 'string'	, allowBlank:false}
			,{name: 'DEPT_NAME'			,text: '부서명'				,type: 'string'}
			,{name: 'BILL_DIV_CODE'		,text: '신고사업장'				,type: 'string'	, allowBlank:false	, comboType:'BOR120', comboCode: 'BILL'}
			,{name: 'AC_CODE1'			,text: '항목'					,type: 'string'	, store: Ext.data.StoreManager.lookup('acItemList')}
			,{name: 'AC_CODE2'			,text: '항목'					,type: 'string'	, store: Ext.data.StoreManager.lookup('acItemList')}
			,{name: 'AC_CODE3'			,text: '항목'					,type: 'string'	, store: Ext.data.StoreManager.lookup('acItemList')}
			,{name: 'AC_CODE4'			,text: '항목'					,type: 'string'	, store: Ext.data.StoreManager.lookup('acItemList')}
			,{name: 'AC_CODE5'			,text: '항목'					,type: 'string'	, store: Ext.data.StoreManager.lookup('acItemList')}
			,{name: 'AC_CODE6'			,text: '항목'					,type: 'string'	, store: Ext.data.StoreManager.lookup('acItemList')}
			,{name: 'AC_DATA1'			,text: '코드'					,type: 'string'}
			,{name: 'AC_DATA2'			,text: '코드'					,type: 'string'}
			,{name: 'AC_DATA3'			,text: '코드'					,type: 'string'}
			,{name: 'AC_DATA4'			,text: '코드'					,type: 'string'}
			,{name: 'AC_DATA5'			,text: '코드'					,type: 'string'}
			,{name: 'AC_DATA6'			,text: '코드'					,type: 'string'}
			,{name: 'AC_DATA_NAME1'		,text: '명'					,type: 'string'}
			,{name: 'AC_DATA_NAME2'		,text: '명'					,type: 'string'}
			,{name: 'AC_DATA_NAME3'		,text: '명'					,type: 'string'}
			,{name: 'AC_DATA_NAME4'		,text: '명'					,type: 'string'}
			,{name: 'AC_DATA_NAME5'		,text: '명'					,type: 'string'}
			,{name: 'AC_DATA_NAME6'		,text: '명'					,type: 'string'}
			,{name: 'BOOK_CODE1'		,text: '항목'					,type: 'string'	, store: Ext.data.StoreManager.lookup('acItemList')}
			,{name: 'BOOK_CODE2'		,text: '항목'					,type: 'string'	, store: Ext.data.StoreManager.lookup('acItemList')}
			,{name: 'BOOK_DATA1'		,text: '코드'					,type: 'string'}
			,{name: 'BOOK_DATA2'		,text: '코드'					,type: 'string'}
			,{name: 'BOOK_DATA_NAME1'	,text: '명'					,type: 'string'}
			,{name: 'BOOK_DATA_NAME2'	,text: '명'					,type: 'string'}
			,{name: 'AC_CTL1'			,text: '관리항목필수1'			,type: 'string'}
			,{name: 'AC_CTL2'			,text: '관리항목필수2'			,type: 'string'}
			,{name: 'AC_CTL3'			,text: '관리항목필수3'			,type: 'string'}
			,{name: 'AC_CTL4'			,text: '관리항목필수4'			,type: 'string'}
			,{name: 'AC_CTL5'			,text: '관리항목필수5'			,type: 'string'}
			,{name: 'AC_CTL6'			,text: '관리항목필수6'			,type: 'string'}
			,{name: 'ACCNT_SPEC'		,text: '계정특성'				,type: 'string'	, comboType:'AU', comboCode:'A015'}
			,{name: 'SPEC_DIVI'			,text: '자산부채특성'				,type: 'string'	, comboType:'AU', comboCode:'A016'} 
			,{name: 'PROFIT_DIVI'		,text: '손익특성'				,type: 'string'	, comboType:'AU', comboCode:'A017'}
			,{name: 'JAN_DIVI'			,text: '잔액변(차대)'			,type: 'string'	, comboType:'AU', comboCode:'A001'}
			,{name: 'PEND_YN'			,text: '미결관리여부'				,type: 'string'	, comboType:'AU', comboCode:'A020'}
			,{name: 'PEND_CODE'			,text: '미결항목'				,type: 'string'	, store: Ext.data.StoreManager.lookup('acItemList')}
			,{name: 'PEND_DATA_CODE'	,text: '미결항목데이터코드'			,type: 'string'}
			,{name: 'BUDG_YN'			,text: '예산사용여부'				,type: 'string'	, comboType:'AU', comboCode:'A020'}
			,{name: 'BUDGCTL_YN'		,text: '예산통제여부'				,type: 'string'	, comboType:'AU', comboCode:'A020'}
			,{name: 'FOR_YN'			,text: '외화구분'				,type: 'string'	, comboType:'AU', comboCode:'A020'}
			,{name: 'PROOF_KIND'		,text: '증빙종류'				,type: 'string'	, comboType:'AU', comboCode:'A022'} 
			,{name: 'CREDIT_NUM'		,text: '카드번호/현금영수증'		,type: 'string'}
			,{name: 'CREDIT_CODE'		,text: '신용카드사코드'			,type: 'string'}
			,{name: 'REASON_CODE'		,text: '불공제사유코드'			,type: 'string'}
			,{name: 'POSTIT_YN'			,text: '주석체크여부'				,type: 'string'}
			,{name: 'POSTIT'			,text: '주석내용'				,type: 'string'}
			,{name: 'POSTIT_USER_ID'	,text: '주석체크자'				,type: 'string'}
			,{name: 'INPUT_PATH'		,text: '입력경로'				,type: 'string'	, comboType:'AU', comboCode:'A011'} 
			,{name: 'INPUT_DIVI'		,text: '전표입력경로'				,type: 'string'	, comboType:'AU', comboCode:'A023'} 
			,{name: 'AUTO_SLIP_NUM'		,text: '자동기표번호'				,type: 'string'}
			,{name: 'CLOSE_FG'			,text: '마감여부'				,type: 'string'	, comboType:'AU', comboCode:'A020'}
			,{name: 'INPUT_DATE'		,text: '입력일자'				,type: 'uniDate'}
			,{name: 'INPUT_USER_ID'		,text: '입력자ID'				,type: 'string'}
			,{name: 'CHARGE_CODE'		,text: '담당자코드'				,type: 'string'	, comboType:'AU', comboCode:'A009'}
			,{name: 'AP_STS'			,text: '승인상태'				,type: 'string'	, defaultValue:'1'}
			,{name: 'AP_DATE'			,text: '승인처리일'				,type: 'uniDate'}
			,{name: 'AP_USER_ID'		,text: '승인자ID'				,type: 'string'}
			,{name: 'AP_CHARGE_CODE'	,text: '승인담당자코드'			,type: 'string'}
			,{name: 'AC_DATE'			,text: '회계전표일자'				,type: 'uniDate'}
			,{name: 'SLIP_NUM'			,text: '회계전표번호'				,type: 'int'}
			,{name: 'SLIP_SEQ'			,text: '회계전표순번'				,type: 'int'}
			,{name: 'DRAFT_YN'			,text: '기안여부(E-Ware)'		,type: 'string'}
			,{name: 'AGREE_YN'			,text: '결재완료(E-Ware)'		,type: 'string'}
			,{name: 'MOD_USER_ID'		,text: '수정자ID'				,type: 'string'}
			,{name: 'MOD_DIVI'			,text: '수정구분'				,type: 'string'}
			,{name: 'MOD_DATE'			,text: '수정일자'				,type: 'uniDate'}
			,{name: 'REPORT_TYPE'		,text: '전표양식'				,type: 'string'}
			,{name: 'REMARK2'			,text: '전표제목'				,type: 'string'}
			,{name: 'DRAFT_CODE'		,text: '기안상태'				,type: 'string'}
			,{name: 'DRAFT_NO'			,text: '기안번호'				,type: 'string'}
			,{name: 'GW_DOC'			,text: 'GW번호'				,type: 'string'}
			,{name: 'ASST_SUPPLY_AMT_I' ,text: '고정자산과표'				,type: 'uniPrice'} 
			,{name: 'ASST_TAX_AMT_I'	,text: '고정자산세액'				,type: 'uniPrice'} 
			,{name: 'ASST_DIVI'			,text: '자산구분'				,type: 'string'	,comboType:'AU', comboCode:'A084'}
		]
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('agj130ukrMasterStore1', {
		model: 'agj130ukrMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster    : true,        // 상위 버튼 연결
			editable    : true,         // 수정 모드 사용
			deletable   : true,         // 삭제 가능 여부
			allDeletable: true,         // 삭제 가능 여부
			useNavi     : false         // prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords : function(params) {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function(config) {
			var paramMaster = panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
			var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.getCount() > 0){
					UniAppManager.setToolbarButtons('deleteAll',true);
					
					masterGrid.updateInfo();
				}else{

					UniAppManager.setToolbarButtons('deleteAll',false);
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
	
	
	/**
	 * Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agj130ukrMasterGrid', {
		store : directMasterStore,
		region: 'center',
		flex  : 1,
		uniOpt:{
			copiedRow:true,
			useContextMenu:false,
			expandLastColumn: false,
			useMultipleSorting:false,
			useNavigationModel:false,
			nonTextSelectedColumns:['REMARK'],
			onLoadSelectFirst:false
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: true, mode: 'SIMPLE', showHeaderCheckbox : true,					//checkOnly	: 체크박스만 선택		toggleOnClick: 행 재선택
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					//	오류/경고행은 제외
					var hasError = record.get('_EXCEL_HAS_ERROR');
					var bCheckOnlyNormal = panelResult.getValue('CHECK_ONLY_NORMAL');
					
					if(bCheckOnlyNormal && (hasError == 'Y' || hasError == 'W')) {
						return false;
					}
					
					return true;
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var curRecords = masterGrid.getSelectedRecords();
					var records = directMasterStore.data.items;
					var data = {records:[]};
					
					var exDate = String(selectRecord.get('EX_DATE'));
					var exNum  = Number(selectRecord.get('EX_NUM'));
					
					Ext.each(curRecords, function(record, i){
						data.records.push(record);
					});
					
					Ext.each(records, function(record, i){
						if( exDate == String(record.get('EX_DATE')) &&
							exNum  == Number(record.get('EX_NUM'))  )
						{
							data.records.push(record);
						}
					});
					masterGrid.getSelectionModel().select(data.records);
					masterGrid.updateHeaderCheckStatus();
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var curRecords = masterGrid.getSelectedRecords();
					var data = {records:[]};
					
					var exDate = String(selectRecord.get('EX_DATE'));
					var exNum  = Number(selectRecord.get('EX_NUM'));
					
					Ext.each(curRecords, function(record, i){
						if( exDate != String(record.get('EX_DATE')) ||
							exNum  != Number(record.get('EX_NUM'))  )
						{
							data.records.push(record);
						}
					});
					masterGrid.getSelectionModel().deselectAll();
					masterGrid.getSelectionModel().select(data.records);
					masterGrid.updateHeaderCheckStatus();
				}
			}
		}),
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				if (record.get('_EXCEL_HAS_ERROR') == 'Y') {
					cls = 'x-grid-excel-hasError';
				}
				else if (record.get('_EXCEL_HAS_ERROR') == 'W') {
					cls = 'x-grid-excel-hasWarn';
				}
				
				return cls;
			}
		},
		columns:  [
			   {dataIndex: '_EXCEL_JOBID'		,width: 120 , hidden: true}
			  ,{dataIndex: '_EXCEL_ROWNUM'		,width: 150 , hidden: true}
			  ,{dataIndex: '_EXCEL_HAS_ERROR'	,width: 150 , hidden: true}
			  ,{dataIndex: '_EXCEL_ERROR_MSG'	,width: 300}
			  ,{dataIndex: 'COMP_CODE'			,width:  90}
			  ,{dataIndex: 'EX_DATE'			,width:  90}
			  ,{dataIndex: 'EX_NUM'				,width:  90}
			  ,{dataIndex: 'EX_SEQ'				,width:  90}
			  ,{dataIndex: 'SLIP_DIVI'			,width:  90}
			  ,{dataIndex: 'DR_CR'				,width:  90}
			  ,{dataIndex: 'CASH_NUM'			,width:  90 , hidden: true}
			  ,{dataIndex: 'ACCNT'				,width:  90}
			  ,{dataIndex: 'ACCNT_NAME'			,width: 150}
			  ,{dataIndex: 'P_ACCNT'			,width: 100 , hidden: true}
			  ,{dataIndex: 'CUSTOM_CODE'		,width: 100}
			  ,{dataIndex: 'CUSTOM_NAME'		,width: 150}
			  ,{dataIndex: 'MONEY_UNIT'			,width:  90}
			  ,{dataIndex: 'EXCHG_RATE_O'		,width: 120}
			  ,{dataIndex: 'AMT_I'				,width: 120}
			  ,{dataIndex: 'FOR_AMT_I'			,width: 120}
			  ,{dataIndex: 'REMARK'				,width: 200}
			  ,{dataIndex: 'DIV_CODE'			,width:  90}
			  ,{dataIndex: 'DEPT_CODE'			,width:  90}
			  ,{dataIndex: 'DEPT_NAME'			,width: 120}
			  ,{dataIndex: 'IN_DIV_CODE'		,width:  90}
			  ,{dataIndex: 'IN_DEPT_CODE'		,width:  90}
			  ,{dataIndex: 'IN_DEPT_NAME'		,width: 120}
			  ,{dataIndex: 'BILL_DIV_CODE'		,width:  90}
			
			  ,{text:'관리항목1'	, columns:[
					{dataIndex: 'AC_CODE1'			,width:  90},
					{dataIndex: 'AC_CTL1'			,width: 120 , hidden: true},
					{dataIndex: 'AC_DATA1'			,width: 120,
						renderer: function(value, meta, record) {
						 	if(record.get('AC_CTL1') == 'Y') {
						 		meta.tdCls = 'x-grid-cell-essential';
						 	}
						 	return value;
						}
					},
					{dataIndex: 'AC_DATA_NAME1'		,width: 120}
				]}
			  ,{text:'관리항목2'	, columns:[
					{dataIndex: 'AC_CODE2'			,width:  90},
					{dataIndex: 'AC_CTL2'			,width: 120 , hidden: true},
					{dataIndex: 'AC_DATA2'			,width: 120,
							renderer: function(value, meta, record) {
							 	if(record.get('AC_CTL2') == 'Y') {
							 		meta.tdCls = 'x-grid-cell-essential';
							 	}
							 	return value;
							}
						},
					{dataIndex: 'AC_DATA_NAME2'		,width: 120}
				]}
			  ,{text:'관리항목3'	, columns:[
					{dataIndex: 'AC_CODE3'			,width:  90},
					{dataIndex: 'AC_CTL3'			,width: 120 , hidden: true},
					{dataIndex: 'AC_DATA3'			,width: 120,
							renderer: function(value, meta, record) {
							 	if(record.get('AC_CTL3') == 'Y') {
							 		meta.tdCls = 'x-grid-cell-essential';
							 	}
							 	return value;
							}
						},
					{dataIndex: 'AC_DATA_NAME3'		,width: 120}
				]}
			  ,{text:'관리항목4'	, columns:[
					{dataIndex: 'AC_CODE4'			,width:  90},
					{dataIndex: 'AC_CTL4'			,width: 120 , hidden: true},
					{dataIndex: 'AC_DATA4'			,width: 120,
							renderer: function(value, meta, record) {
							 	if(record.get('AC_CTL4') == 'Y') {
							 		meta.tdCls = 'x-grid-cell-essential';
							 	}
							 	return value;
							}
						},
					{dataIndex: 'AC_DATA_NAME4'		,width: 120}
				]}
			  ,{text:'관리항목5'	, columns:[
					{dataIndex: 'AC_CODE5'			,width:  90},
					{dataIndex: 'AC_CTL5'			,width: 120 , hidden: true},
					{dataIndex: 'AC_DATA5'			,width: 120,
							renderer: function(value, meta, record) {
							 	if(record.get('AC_CTL5') == 'Y') {
							 		meta.tdCls = 'x-grid-cell-essential';
							 	}
							 	return value;
							}
						},
					{dataIndex: 'AC_DATA_NAME5'		,width: 120}
				]}
			  ,{text:'관리항목6'	, columns:[
					{dataIndex: 'AC_CODE6'			,width:  90},
					{dataIndex: 'AC_CTL6'			,width: 120 , hidden: true},
					{dataIndex: 'AC_DATA6'			,width: 120,
							renderer: function(value, meta, record) {
							 	if(record.get('AC_CTL6') == 'Y') {
							 		meta.tdCls = 'x-grid-cell-essential';
							 	}
							 	return value;
							}
						},
					{dataIndex: 'AC_DATA_NAME6'		,width: 120}
				]}
			  ,{text:'계정잔액1'	, columns:[
					{dataIndex: 'BOOK_CODE1'		,width: 120},
					{dataIndex: 'BOOK_DATA1'		,width: 120},
					{dataIndex: 'BOOK_DATA_NAME1'	,width: 120}
				]}
			  ,{text:'계정잔액2'	, columns:[
					{dataIndex: 'BOOK_CODE2'		,width: 120},
					{dataIndex: 'BOOK_DATA2'		,width: 120},
					{dataIndex: 'BOOK_DATA_NAME2'	,width: 120}
				]}
			  ,{dataIndex: 'ACCNT_SPEC'			,width: 120 , hidden: true}
			  ,{dataIndex: 'SPEC_DIVI'			,width: 120 , hidden: true}
			  ,{dataIndex: 'PROFIT_DIVI'		,width: 120 , hidden: true}
			  ,{dataIndex: 'JAN_DIVI'			,width: 120 , hidden: true}
			  ,{dataIndex: 'PEND_YN'			,width: 120 , hidden: true}
			  ,{dataIndex: 'PEND_CODE'			,width: 120 , hidden: true}
			  ,{dataIndex: 'PEND_DATA_CODE'		,width: 120 , hidden: true}
			  ,{dataIndex: 'BUDG_YN'			,width: 120 , hidden: true}
			  ,{dataIndex: 'BUDGCTL_YN'			,width: 120 , hidden: true}
			  ,{dataIndex: 'FOR_YN'				,width: 120 , hidden: true}
			  ,{dataIndex: 'PROOF_KIND'			,width: 120}
			  ,{dataIndex: 'CREDIT_NUM'			,width: 120 , hidden: true}
			  ,{dataIndex: 'CREDIT_CODE'		,width: 120}
			  ,{dataIndex: 'REASON_CODE'		,width: 120 , hidden: true}
			  ,{dataIndex: 'POSTIT_YN'			,width: 120 , hidden: true}
			  ,{dataIndex: 'POSTIT'				,width: 120 , hidden: true}
			  ,{dataIndex: 'POSTIT_USER_ID'		,width: 120 , hidden: true}
			  ,{dataIndex: 'INPUT_PATH'			,width: 120 , hidden: true}
			  ,{dataIndex: 'INPUT_DIVI'			,width: 120 , hidden: true}
			  ,{dataIndex: 'AUTO_SLIP_NUM'		,width: 120 , hidden: true}
			  ,{dataIndex: 'CLOSE_FG'			,width: 120 , hidden: true}
			  ,{dataIndex: 'INPUT_DATE'			,width: 120}
			  ,{dataIndex: 'INPUT_USER_ID'		,width: 120}
			  ,{dataIndex: 'CHARGE_CODE'		,width: 120}
			  ,{dataIndex: 'AP_STS'				,width: 120 , hidden: true}
			  ,{dataIndex: 'AP_DATE'			,width: 120 , hidden: true}
			  ,{dataIndex: 'AP_USER_ID'			,width: 120 , hidden: true}
			  ,{dataIndex: 'AP_CHARGE_CODE'		,width: 120 , hidden: true}
			  ,{dataIndex: 'AC_DATE'			,width: 120 , hidden: true}
			  ,{dataIndex: 'SLIP_NUM'			,width: 120 , hidden: true}
			  ,{dataIndex: 'SLIP_SEQ'			,width: 120 , hidden: true}
			  ,{dataIndex: 'DRAFT_YN'			,width: 120 , hidden: true}
			  ,{dataIndex: 'AGREE_YN'			,width: 120 , hidden: true}
			  ,{dataIndex: 'MOD_USER_ID'		,width: 120 , hidden: true}
			  ,{dataIndex: 'MOD_DIVI'			,width: 120 , hidden: true}
			  ,{dataIndex: 'MOD_DATE'			,width: 120 , hidden: true}
			  ,{dataIndex: 'REPORT_TYPE'		,width: 120 , hidden: true}
			  ,{dataIndex: 'REMARK2'			,width: 120 , hidden: true}
			  ,{dataIndex: 'DRAFT_CODE'			,width: 120 , hidden: true}
			  ,{dataIndex: 'DRAFT_NO'			,width: 120 , hidden: true}
			  ,{dataIndex: 'GW_DOC'				,width: 120 , hidden: true}
			  ,{dataIndex: 'ASST_SUPPLY_AMT_I'	,width: 120 , hidden: true}
			  ,{dataIndex: 'ASST_TAX_AMT_I'		,width: 120 , hidden: true}
			  ,{dataIndex: 'ASST_DIVI'			,width: 120 , hidden: true}

		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
//				if (UniUtils.indexOf(e.field, ['_EXCEL_JOBID','_EXCEL_ROWNUM','_EXCEL_HAS_ERROR','_EXCEL_ERROR_MSG','COMP_CODE','EX_DATE','EX_NUM','EX_SEQ'])) {
					return false;
//				} else {
//					return true;
//				}
			},
			render:function(grid, eOpt)	{
				var tbar = grid._getToolBar();
				var items = tbar[0].items.items;
				var index = 0;
				
				Ext.each(items, function(item, i){
					if(item.id.indexOf('uniBaseButton') >= 0) {
						index++;
					}
				});
				
				tbar[0].insert(index,{
					xtype : 'component',
					style : 'font-size: 11px; margin-left: 100px;',
					id    : 'lblInfo',
					html  : ' ',		//	'※ 정상 : n건, 오류 : n건, 경고 : n건'
					hidden: false
				});
				
//				//	override areAllChecked event from ExtJS check column prototype
//				if(grid.getColumns()[0].isCheckColumn) {
//					grid.getColumns()[0].areAllChecked = function() {
//						var me = this,
//							store = me.getView().getStore(),
//							records, len, i;
//							
//						if (!store.isBufferedStore && store.getCount() > 0) {
//							records = store.getData().items;
//							len = records.length;
//							for (i = 0; i < len; ++i) {
//								var hasError = records[i].get('_EXCEL_HAS_ERROR');
//								if (!(hasError == 'Y' || hasError == 'W') && !me.isRecordChecked(records[i])) {
//									return false;
//								}
//							}
//							return true;
//						}
//					};
//				}
			}
		},
		updateInfo: function(){
			var records		= directMasterStore.data.items;
			var cntNormal	= 0;
			var cntWarn		= 0;
			var cntError	= 0;
			
			for(var lLoop = 0; lLoop < records.length; lLoop++) {
				var hasError = records[lLoop].get('_EXCEL_HAS_ERROR');
				if(hasError == 'Y') {
					cntError++;
				}
				else if(hasError == 'W') {
					cntWarn++;
				}
				else {
					cntNormal++;
				}
			}
			
			var label = '<font color="#0000ff">● 정상 : <b>' + String(cntNormal) + '</b>건</font> / <font color="#ff00ff">● 경고 : <b>' + String(cntWarn) + '</b>건</font> / <font color="#ff0000">● 오류 : <b>' + String(cntError) + '</b>건</font>'
			
			Ext.getCmp('lblInfo').setHtml(label);
		},
		updateHeaderCheckStatus : function() {
			//	오류/경고 제외하고 전부 체크 되어있는지 확인하여 css 강제 적용
			if(masterGrid.areAllChecked()) {
				masterGrid.getColumns()[0].addCls('x-grid-hd-checker-on');
			}
			else {
				masterGrid.getColumns()[0].removeCls('x-grid-hd-checker-on');
			}
		},
		areAllChecked : function() {
			var me = this,
				store = me.getView().getStore(),
				records, len, i, cnt;
				
			if (!store.isBufferedStore && store.getCount() > 0) {
				records = store.getData().items;
				len = records.length;
				cnt = 0;
				for (i = 0; i < len; ++i) {
					var hasError = records[i].get('_EXCEL_HAS_ERROR');
					if (!(hasError == 'Y' || hasError == 'W')) {
						if(!masterGrid.getColumns()[0].isRecordChecked(records[i])) {
							return false;
						}
						else {
							cnt++;
						}
					}
				}
				
				if(cnt > 0 || masterGrid.getSelectedRecords().length == len) {
					return true;
				}
				else {
					return false;
				}
			}
		}
	});
	
	

	Unilite.Main({
		id  : 'agj130ukrApp',
		borderItems:[ 
			panelSearch,
			{
				region: 'center',
				layout: 'border',
				border: false,
				items:[
					masterGrid, panelResult
				]
			}
		],
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			panelResult.onLoadSelectText('DIV_CODE');
			UniAppManager.setToolbarButtons(['reset', 'query', 'delete'], true);
			

		},
		onQueryButtonDown : function() {
			//if(!panelSearch.getInvalidMessage())	 return;					//필수조건 체크
			masterGrid.getStore().loadStoreRecords();
		},
		onSaveDataButtonDown:function() {
			var config = {
					success: function(batch, option) {
						UniAppManager.setToolbarButtons('save', false);
					}
				};
			directMasterStore.saveStore(config);
		},
		onDeleteDataButtonDown:function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onDeleteAllButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) {
				return false;
			}
			
			var param = {
				'COMP_CODE'		: UserInfo.compCode,
				'DIV_CODE'		: panelResult.getValue('DIV_CODE')
			};
			
			agj130ukrService.deleteAll(param, function(provider, response){
				if(provider) {
					Ext.Msg.alert('Success', '전체삭제 되었습니다.');
					UniAppManager.app.onQueryButtonDown();
				}
				else {
					Ext.Msg.alert('Error', provider);
				}
			});
		}
		
	});
	
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		
		if(!directMasterStore.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
			directMasterStore.loadData({});
		} else {
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
				directMasterStore.loadData({});
			}
		}
		
		
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName	: 'agj130ukr',
				modal			: false,
				height			:  93,
				extParam: {
					'PGM_ID'		: 'agj130ukr'
				},
				listeners: {
					close: function() {
						this.hide();
					}
				},
				uploadFile: function() {
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
							excelUploadJobID = action.result.jobID;
							
							Ext.Msg.alert('Success', 'Upload 성공 하였습니다.');
							
							me.hide();
							UniAppManager.app.onQueryButtonDown();
						},
						failure: function(form, action) {
							Unilite.messageBox(action.result.msg);
						}
					});
					
				},
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
					}];
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	}
	
	
}
</script>