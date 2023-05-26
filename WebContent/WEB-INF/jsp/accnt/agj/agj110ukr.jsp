<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj110ukr"> 
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A011"/>
	<t:ExtComboStore comboType="AU" comboCode="A001"/>
	<t:ExtComboStore comboType="AU" comboCode="A022"/><!-- 매입증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>
	<t:ExtComboStore comboType="AU" comboCode="A003"/>
	<t:ExtComboStore comboType="AU" comboCode="A002"/>
	<t:ExtComboStore comboType="AU" comboCode="A014"/><!--승인상태-->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>
	<t:ExtComboStore comboType="AU" comboCode="A058"/>
	<t:ExtComboStore comboType="AU" comboCode="A149"/>
	<t:ExtComboStore comboType="AU" comboCode="A016"/>
	<t:ExtComboStore comboType="AU" comboCode="A012"/>
	<t:ExtComboStore comboType="AU" comboCode="A070"/>
	<t:ExtComboStore comboType="AU" comboCode="A084"/>
</t:appConfig>

<script type="text/javascript" >

var csINPUT_DIVI	= "3";	//1:결의전표/2:결의전표(전표번호별)
var csSLIP_TYPE		= "2";	//1:회계전표/2:결의전표
var csSLIP_TYPE_NAME= "결의전표";
var csINPUT_PATH	= 'X1';
var gsChargeDivi	= '${gsChargeDivi}';
var gsInputPath		= "X1", gsInputDivi, gsDraftYN  , gsApSts;
var postitWindow;			// 각주팝업
var creditNoWin;			// 신용카드번호 & 현금영수증 팝업
var comCodeWin ;			// A070 증빙유형팝업
var creditWIn;				// 신용카드팝업
var printWin;				//전표출력팝업
var foreignWindow;			//외화금액입력
var multipleDivCodeAllowYN	= '${multipleDivCodeAllowYN}';
var gsBankBookNum ,gsBankName ;
var tab;
var searchPopup;
var clickedGrid = 'agj110ukrGrid1';
var tempFridForViewoWin;
var asstInfoWindow;
var addLoading = false;		// 전표번호 생성 flag
var slipNumMessageWin;
//조회된 합계, 건수 계산용 변수 선언
var sumJAmtI	= 0;
	sumForJAmtI	= 0;
var doNotModifiedFields = [  'INPUT_PATH'	,'INPUT_DIVI'	,'AUTO_SLIP_NUM','CLOSE_FG'		,'INPUT_DATE'		,'INPUT_USER_ID'
							,'CHARGE_CODE'	,'AP_STS'		,'AP_DATE'		,'AP_USER_ID'	,'AP_CHARGE_CODE'	,'AC_DATE'
							,'SLIP_NUM'		,'SLIP_SEQ'		,'DRAFT_YN'		,'AGREE_YN'		,'INPUT_PATH'		,'INPUT_DIVI'];
function appMain() {
	var gsSlipNum		=""; // 링크로 넘어오는 Slip_NUM
	var gsProcessPgmId	=""; // Store 에서 링크로 넘어온 Data 값 체크 하기 위해 전역변수 사용
	var baseInfo = {
		gsLocalMoney		: '${gsLocalMoney}',
		gsBillDivCode		: '${gsBillDivCode}',
		gsPendYn			: '${gsPendYn}',
		gsChargePNumb		: '${gsChargePNumb}',
		gsChargePName		: '${gsChargePName}',
		gbAutoMappingA6		: '${gbAutoMappingA6}',	// '결의전표 관리항목 사번에 로그인정보 자동매핑함
		gsDivChangeYN		: '${gsDivChangeYN}',	// '귀속부서 입력시 사업장 자동 변경 사용여부
		gsRemarkCopy		: '${gsRemarkCopy}',	// '전표_적요 copy방식_적요 빈 값 상태에서 Enter칠 때 copy
		gsAmtEnter			: '${gsAmtEnter}',		// '전표_금액이 0이면 마지막 행에서 Enter안넘어감(부가세 제외)
		gsAmtPoint			: ${gsAmtPoint},		// 외화금액 format
		customCodeCopy		: '${customCodeCopy}',
		customCodeAutoPopup	: '${customCodeAutoPopup}' == 'Y' ? true : false,
		profitEarnAccnt		: '${profitEarnAccnt}',
		profitLossAccnt		: '${profitLossAccnt}',
		gsDeptCode			: '${gsDeptCode}',
		gsDeptName			: '${gsDeptName}',
		inDeptCodeBlankYN   : '${inDeptCodeBlankYN}' // 귀속부서 팝업창 오픈시 검색어 공백 처리(A165, 75)
	}

	 var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'agj110ukrService.selectList',
				update	: 'agj110ukrService.update',
				create	: 'agj110ukrService.insert',
				destroy	: 'agj110ukrService.delete',
				syncAll	: 'agj110ukrService.saveAll'
			}
		});
	var detailDirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'agj110ukrService.selectList4'
		}
	});
	<%@include file="./accntGridConfig.jsp"%>

	/** 일반전표 Store 정의(Service 정의)
	 * @type 
	 */
	Unilite.defineModel('agj110ukrv', {
		fields: [ 
			 {name: 'AC_DAY'			,text:'일자'				,type : 'string', allowBlank:false,maxLength:2} 
			,{name: 'SLIP_NUM'			,text:'번호'				,type : 'int', allowBlank:false,maxLength:7} 
			,{name: 'SLIP_SEQ'			,text:'순번'				,type : 'int', editable:false} 
			,{name: 'SLIP_DIVI'			,text:'구분'				,type : 'string', allowBlank:false, defaultValue:'3', comboType:'A', comboCode:'A005'} 
			,{name: 'ACCNT'				,text:'계정코드'			,type : 'string', allowBlank:false,maxLength:16} 
			,{name: 'ACCNT_NAME'		,text:'계정과목명'			,type : 'string', allowBlank:false,maxLength:50} 
			,{name: 'CUSTOM_CODE'		,text:'거래처'				,type : 'string', maxLength:8} 
			,{name: 'CUSTOM_NAME'		,text:'거래처명'			,type : 'string', maxLength:40} 
			,{name: 'DR_AMT_I'			,text:'차변금액'			,type : 'uniPrice'} 
			,{name: 'CR_AMT_I'			,text:'대변금액'			,type : 'uniPrice', maxLength:30} 
			,{name: 'REMARK'			,text:'적요'				,type : 'string',  maxLength:100 } 
			,{name: 'PROOF_KIND_NM'		,text:'증빙유형'			,type : 'string'} 
			//,{name: 'DEPT_NAME'			,text:'귀속부서'			,type : 'string', allowBlank:false, defaultValue:UserInfo.deptName,maxLength:30} 
			//,{name: 'DEPT_NAME'			,text:'귀속부서'			,type : 'string', allowBlank:false, defaultValue:baseInfo.gsDeptName,maxLength:30}
			,{name: 'DEPT_NAME'			,text:'귀속부서'			,type : 'string', allowBlank:false, defaultValue:baseInfo.gsDeptName,maxLength:30}
			,{name: 'DIV_CODE'			,text:'사업장'				,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue:UserInfo.divCode}
			,{name: 'OLD_AC_DATE'		,text:'OLD_AC_DATE'		,type : 'uniDate'} 
			,{name: 'OLD_SLIP_NUM'		,text:'OLD_SLIP_NUM'	,type : 'int'} 
			,{name: 'OLD_SLIP_SEQ'		,text:'OLD_SLIP_SEQ'	,type : 'int'}
			,{name: 'AC_DATE'			,text:'전표일자'			,type : 'uniDate'} 
			,{name: 'DR_CR'				,text:'차대구분'			,type : 'string', defaultValue:'1', comboType:'AU', comboCode:'A001' } 
			,{name: 'P_ACCNT'			,text:'상대계정코드'			,type : 'string'} 
			//,{name: 'DEPT_CODE'			,text:'귀속부서코드'			,type : 'string', allowBlank:false, defaultValue:UserInfo.deptCode,maxLength:8} 
			,{name: 'DEPT_CODE'			,text:'귀속부서코드'			,type : 'string', allowBlank:false, defaultValue:baseInfo.gsDeptCode,maxLength:8}
			,{name: 'PROOF_KIND'		,text:'증빙유형'			,type : 'string',  maxLength:2, comboType:'AU', comboCode:'A022'} 
			,{name: 'CREDIT_CODE'		,text:'신용카드사코드'			,type : 'string'} 
			,{name: 'REASON_CODE'		,text:'불공제사유코드'			,type : 'string'} 
			,{name: 'CREDIT_NUM'		,text:'카드번호/현금영수증'		,type : 'string', editable:false} 
			,{name: 'CREDIT_NUM_EXPOS'	,text:'카드번호/현금영수증'		,type : 'string', editable:false} 
			,{name: 'CREDIT_NUM_MASK'	,text:'카드번호/현금영수증'		,type : 'string', editable:false, defaultValue:'***************'} 
			,{name: 'MONEY_UNIT'		,text:'화폐단위'			,type : 'string', defaultValue:baseInfo.gsLocalMoney, comboType:'AU',comboCode:'B004'} 
			,{name: 'EXCHG_RATE_O'		,text:'환율'				,type : 'uniER'} 
			,{name: 'FOR_AMT_I'			,text:'외화금액'			,type : 'uniFC'}
			,{name: 'IN_DIV_CODE'		,text:'결의사업장코드'			,type : 'string', defaultValue:UserInfo.divCode} 
			,{name: 'IN_DEPT_CODE'		,text:'결의부서코드'			,type : 'string', defaultValue:baseInfo.gsDeptCode} 
			,{name: 'IN_DEPT_NAME'		,text:'결의부서'			,type : 'string', defaultValue:baseInfo.gsDeptName}
			
			//,{name: 'IN_DEPT_CODE'		,text:'결의부서코드'			,type : 'string', defaultValue:UserInfo.deptCode} 
			//,{name: 'IN_DEPT_NAME'		,text:'결의부서'			,type : 'string', defaultValue:UserInfo.deptName}
			,{name: 'BILL_DIV_CODE'		,text:'신고사업장코드'			,type : 'string', defaultValue:UserInfo.divCode}
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
			,{name: 'SPEC_DIVI'			,text:'자산부채특성'			,type : 'string', comboType:'AU', comboCode:'A016'} 
			,{name: 'PROFIT_DIVI'		,text:'손익특성'			,type : 'string'}
			,{name: 'JAN_DIVI'			,text:'잔액변(차대)'			,type : 'string'}
			,{name: 'PEND_YN'			,text:'미결관리여부'			,type : 'string', defaultValue:'N'} 
			,{name: 'PEND_CODE'			,text:'미결항목'			,type : 'string'}
			,{name: 'PEND_DATA_CODE'	,text:'미결항목데이터코드'		,type : 'string'}
			,{name: 'BUDG_YN'			,text:'예산사용여부'			,type : 'string'}
			,{name: 'BUDGCTL_YN'		,text:'예산통제여부'			,type : 'string'}
			,{name: 'FOR_YN'			,text:'외화구분'			,type : 'string'}
			,{name: 'POSTIT_YN'			,text:'주석체크여부'			,type : 'string'}
			,{name: 'POSTIT'			,text:'주석내용'			,type : 'string'}
			,{name: 'POSTIT_USER_ID'	,text:'주석체크자'			,type : 'string'}
			,{name: 'INPUT_PATH'		,text:'입력경로'			,type : 'string', defaultValue: csINPUT_PATH} 
			,{name: 'INPUT_DIVI'		,text:'전표입력경로'			,type : 'string', defaultValue: csINPUT_DIVI} 
			,{name: 'AUTO_SLIP_NUM'		,text:'자동기표번호'			,type : 'string'}
			,{name: 'CLOSE_FG'			,text:'마감여부'			,type : 'string'}
			,{name: 'INPUT_DATE'		,text:'입력일자'			,type : 'string'}
			,{name: 'INPUT_USER_ID'		,text:'입력자ID'			,type : 'string'}
			,{name: 'CHARGE_CODE'		,text:'담당자코드'			,type : 'string'}
			,{name: 'CHARGE_NAME'		,text:'담당자명'			,type : 'string'}
			,{name: 'AP_STS'			,text:'승인상태'			,type : 'string', defaultValue:'1'} 
			,{name: 'AP_DATE'			,text:'승인처리일'			,type : 'string'}
			,{name: 'AP_USER_ID'		,text:'승인자ID'			,type : 'string'}
			,{name: 'EX_DATE'			,text:'회계전표일자'			,type : 'string'}
			,{name: 'EX_NUM'			,text:'회계전표번호'			,type : 'int'}
			,{name: 'EX_SEQ'			,text:'회계전표순번'			,type : 'string'}
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
			,{name: 'OPR_FLAG'			,text:'editFlag'		,type : 'string', defaultValue:'L'} 
			,{name: 'ORG_DATA'			,text:'ORG_DATA'		,type : 'string'}
			,{name: 'store2Idx'			,text:'store2Idx'		,type : 'string'}
			
			//===========================================
			// L_AGB320T 에 입력될 필드
			 ,{name: 'ORG_AC_DATE'		,text: '전표일'				,type: 'string'}
			 ,{name: 'ORG_SLIP_NUM'		,text: '번호'					,type: 'string'}
			 ,{name: 'ORG_SLIP_SEQ'		,text: '순번'					,type: 'int'}
			 ,{name: 'J_AMT_I'			,text: '반제가능금액'	 			,type: 'uniPrice'}
			 ,{name: 'FOR_J_AMT_I'		,text: '외화반제가능금액'			,type: 'uniFC'}
			 ,{name: 'DEPT_NAME'		,text: '귀속부서'				,type: 'string'}
			 ,{name: 'SEQ'				,text: 'SEQ'				,type: 'int'}
			 ,{name: 'J_EX_DATE'		,text: ''					,type: 'uniDate'}
			 ,{name: 'J_EX_NUM'			,text: ''					,type: 'int'}
			 ,{name: 'J_EX_SEQ'			,text: '순번'					,type: 'int'}
			 ,{name: 'FOR_BLN_I'		,text: '외화잔액'				,type: 'uniFC'}
			 ,{name: 'BLN_I'			,text: ''					,type: 'uniPrice'}
			 ,{name: 'IS_PEND_INPUT'	,text: '미결반제데이터여부'			,type: 'string'}
		]
	});
	// 미결 참조 filter
	var pendRefFilter = new Ext.util.Filter({
		filterFn: function(item) {
			return item.get("FLAG") == "R";
		}
	});
	var directMasterStore1 = Unilite.createStore('agj110ukrMasterStore1',{
		model: 'agj110ukrv',
		autoLoad: false,
		uniOpt : {
			isMaster: true,		 // 상위 버튼 연결
			editable: true,		 // 수정 모드 사용
			deletable:true,		 // 삭제 가능 여부
			useNavi : false,			// prev | next 버튼 사용
			allDeletable : true
		},
		proxy: directProxy, // proxy
		// Store 관련 BL 로직
		// 검색 조건을 통해 DB에서 데이터 읽어 오기
		loadStoreRecords : function(records) {
			var param ;
			
			var me = this;
			slipStore1.removeAll();
			slipStore2.removeAll();
			
			if(!Ext.isEmpty(records) && !Ext.isDefined(records[0].data)) {
				Ext.each(records, function(record){
					newRecord =  Ext.create (me.model, record);
					me.insert(0,newRecord);
				});
				
			} else {
				//me.insert(0,records);;
				Ext.each(records, function(record){
					newRecord =  Ext.create (me.model, record.data);
					me.insert(0,newRecord);
				});
			}
			
			Ext.each(me.getData().items, function(record){
				record.set('OPR_FLAG', 'L');
			})
			me.commitChanges();
			UniAppManager.app.setToolbarButtons("save", false);
			this.slipGridChange(me.getData().items);
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore : function(config) {
			var activeTab
			var activeTabId;
			if(tab) {
				activeTab = tab.getActiveTab();
				activeTabId = activeTab.getItemId();
			}else {
				activeTabId = 'agjTab1'
			}
			var paramMaster = {};

			var insertRecords=this.getNewRecords( );
			var updateRecords=this.getUpdatedRecords( );
			var removedRecords=this.getRemovedRecords( );
			// editFlag
			//N: 변동없음, I: 신규, U: 수정 R:삭제
			Ext.each(insertRecords	, function(record){record.set('OPR_FLAG', 'N')})
			Ext.each(updateRecords	, function(record){record.set('OPR_FLAG', 'U')})
			Ext.each(removedRecords	, function(record){record.set('OPR_FLAG', 'D')})

			var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
			Ext.each(changedRec, function(cRec){
				if(Ext.isEmpty(cRec.get('CHARGE_CODE'))) {
					cRec.set('CHARGE_CODE',slipForm.getValue('CHARGE_CODE'));
				}
			})
			//변경된 record와 같은 전표번호 데이터를 서버로 전송하기 위해 OPR_FLAG값 변경
			Ext.each(this.data.items, function(record){
				if(record.get('OPR_FLAG') == 'L') {
					Ext.each(changedRec, function(cRec){
						if(UniDate.getDateStr(record.get('AC_DATE')) == UniDate.getDateStr(cRec.get('AC_DATE')) &&
							record.get('SLIP_NUM') == cRec.get('SLIP_NUM')) {
							record.set('OPR_FLAG','U')
						}
					})
				}
			});

			updateRecords=this.getUpdatedRecords( );
			//changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
			//관리항목 필수 사항 체크, 순번 저장
			var saveRec	= [].concat(updateRecords).concat(insertRecords);
			var tempRec	= [].concat(updateRecords).concat(removedRecords);  // 신규 데이터 old_ext_seq 값 생성을 위해 사용
			var slipNum	= 0;
			var slipSeq	= 1
			var chk		= true;
			var tmpI	= tempRec.length + 1;		// 신규 데이터 old_ext_seq 값 생성을 위해 사용

			Ext.each(saveRec, function(rec, idx){
				//순번 저장
				var viewIdx = directMasterStore2.findBy( function(data2Rec, idx){return data2Rec.getId() == rec.get("store2Idx")});
				var viewRecord = directMasterStore2.getAt(viewIdx);
				var viewPendIdx = detailStore.findBy( function(pandRec, idx){return pandRec.getId() == rec.get("store2Idx")});
				
				var viewPendGrid = detailStore.getAt(viewPendIdx)
				if(viewIdx > -1)	{
					rec.set('SLIP_SEQ', viewIdx+1);
				} else if(viewPendIdx > -1)	{
					rec.set('SLIP_SEQ', viewPendIdx + directMasterStore2.getData().items.length +1 );
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
				slipNum = rec.get('SLIP_NUM');

				//관리항목 필수 사항 체크
				for(var i=1; i <= 6; i++) {
					if(!UniUtils.indexOf(panelSearch.getValue(), ['50','52','58'])) {
						if(rec.get("AC_CTL"+i.toString()) =="Y" ) {
							if(Ext.isEmpty(rec.get("AC_DATA"+i.toString()))) {
								alert("전표번호 " + rec.get("SLIP_NUM")+",전표순번 "+rec.get("SLIP_SEQ")+"의 "+rec.get("AC_NAME"+i.toString())+"을(를) 입력해 주세요.");
								chk=false;
								break;
							}
						}
					}
					if(rec.get("AC_FORMAT"+i.toString())=="D" ) {
						if(rec.get("AC_DATA"+i.toString()) && rec.get("AC_DATA"+i.toString()).length != 8) {
							rec.set("AC_DATA"+i.toString(), UniDate.getDateStr(new Date(rec.get("AC_DATA"+i.toString()))));
						}
					}
				}
			})
			
			//삭제전표 순번 채번
			slipSeq = saveRec.length +1;
			Ext.each(removedRecords, function(rec, idx){
				rec.set('SLIP_SEQ', slipSeq+idx);
				if(rec.phantom) {
					rec.set('OLD_SLIP_SEQ', slipSeq+idx);
				}
			})
			//미결반제 전표가 포함 되어있는지 확인
			if(saveRec.length > 0 && pendGrid.getStore().count() == 0) {
					chk = false;
					Unilite.messageBox("미결 반제가 존재하지 않습니다.");
			}
			if(!chk) {
				return;
			}
			
			//차대변 금액이 일치하는지 검사
			var checkDCSum = this.checkSum();
			if(checkDCSum !== true) {
				/*if(checkDCSum == false) {
					if(pendGrid.getStore().count() == 0) {
						alert("선택된 반제리스트가 존재하지 않습니다.");
					}
					if(masterGrid1.getStore().count() == 0) {
						alert("반제리스트의 차변대변 과목을 입력하십시오.");
					}
				} else {*/
					alert(Msg.sMA0052+'\n'+'전표번호:'+checkDCSum);
				//}
				return;
			}
			//같은 전표안에서 대체차변, 대체대변과 입금, 출금이 동시에 존재하는지를 체크
			if(!this.checkDivi()) {
				return;
			}
			
			Ext.each(insertRecords, function(rec){
				rec.set('OLD_AC_DATE'	, rec.get('AC_DATE'));
				rec.set('OLD_SLIP_NUM'	, rec.get('SLIP_NUM'));
//				rec.set('OLD_SLIP_SEQ'	, rec.get('SLIP_SEQ'));
			});
			
			if(!this.checkDept()){
				return
			}
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			
			if(inValidRecs.length == 0 ) {
				var params1 = slipForm.getValues();
				var config={
						scope			: this,
						params			: [params1],
						useSavedMessage	: false,
						success			: function(batch, option, arg1, arg2) {
							if(batch.operations && batch.operations.length > 0) {
								if(option && option.params) {
									Ext.each(detailStore.getData().items, function(uRec, idx) {
										if(uRec.get("OPR_FLAG") == 'L') {
											uRec.set("OPR_FLAG",'U')
										}
									})
									var rExNum = batch.operations[0]._resultSet.EX_NUM
									panelSearch.setValue("EX_NUM", rExNum);
									slipForm.setValue("EX_NUM", rExNum);
									
									var rRecord2 = directMasterStore2.getData();
									Ext.each(rRecord2.items, function(item, idx){
										item.set('SLIP_NUM',rExNum );
										item.set('OLD_SLIP_NUM',rExNum );
									})


								}
							directMasterStore2.commitChanges();
							directMasterStore1.commitChanges();
							detailStore.commitChanges();
							slipForm.resetDirtyStatus();
							UniAppManager.app.setSearchReadOnly(true);
							Ext.getBody().unmask();
						}
					} , 
					callback : function(responseText, arg0, arg1)	{
						console.log("responseText",responseText);
						console.log("arg0",arg0);
						console.log("arg1",arg1);
					}
				}
				this.syncAllDirect(config);
			}else {
				if(tempGridForView) {
					tempGridForView.uniSelectInvalidColumnAndAlert(inValidRecs);
				} else {
					Unilite.messageBox(Msg.sMB083);
				}
			}
		},
		checkSum:function() {
			var insertRecords=this.getNewRecords( );
			var updateRecords=this.getUpdatedRecords( );
			var removedRecords=this.getRemovedRecords( );
			var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
			var rtn = true;
			var store = this;
			Ext.each(changedRec, function(rec) {
				var cr_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== rec.get("AC_DAY") && record.get('SLIP_NUM')== rec.get("SLIP_NUM") && record.get('DR_CR') == '2') } ).items);	  
				var dr_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== rec.get("AC_DAY") && record.get('SLIP_NUM')== rec.get("SLIP_NUM") && record.get('DR_CR') == '1') } ).items);	  
				
				var crSum=0;
				var crLen = cr_data.length;
				var drSum=0;
				var drLen = dr_data.length;
				if(rec.get('SLIP_DIVI') != 1 && rec.get('SLIP_DIVI') != 2) {
					
					Ext.each(cr_data, function(item){
						crSum += item.get("AMT_I");
						if(Ext.isEmpty(item.get('CASH_NUM'))) {
							if(drLen == 1) {
								item.set('P_ACCNT', dr_data[0].get('ACCNT'));
							}else {
								item.set('P_ACCNT', '99999');
							}
						}
						
					})
					Ext.each(dr_data, function(item){
						drSum += item.get("AMT_I");
						if(Ext.isEmpty(item.get('CASH_NUM'))) {
							if(crLen == 1) {
								item.set('P_ACCNT', cr_data[0].get('ACCNT'));
							}else {
								item.set('P_ACCNT', '99999');
							}
						}/*else {
							var pItemId = store.findBy(function(rec, idx){
								return rec.get('AC_DAY') == item.get('AC_DAY') && rec.get('SLIP_NUM')==item.get('SLIP_NUM') && rec.get('CASH_NUM') == item.get('SLIP_SEQ');
							});
							var pRecord = store.getAt(pItemId);
							item.set('P_ACCNT', pRecord.get('SLIP_SEQ'));
						}*/
					})
					console.log("crSum : ", crSum ," drSum =",drSum);
					/*if(crSum == 0 && drSum == 0 ) {
						rtn = false;
						return false;
					}*/
					if(crSum != drSum ) {
						
						rtn = rec.get('SLIP_NUM');
					}
				
				}else {
					Ext.each(cr_data, function(item){
						item.set('P_ACCNT', "11110");
						
					})
					Ext.each(dr_data, function(item){
						item.set('P_ACCNT', "11110");
						
					})
				}
			})
			
			return rtn;
		},
		checkDivi:function() {
			var insertRecords=this.getNewRecords( );
			var updateRecords=this.getUpdatedRecords( );
			var removedRecords=this.getRemovedRecords( );
			
			var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
			var rtn = true;
			var store = this;
			Ext.each(changedRec, function(rec) {
				var slip_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== rec.get("AC_DAY") && record.get('SLIP_NUM')== rec.get("SLIP_NUM") ) } ).items);	 
				for(var i=0; i < slip_data.length-1; i++) {
					if((slip_data[i].get("SLIP_DIVI") =="1" || slip_data[i].get("SLIP_DIVI") == "2") && slip_data[i].get("SLIP_DIVI") != slip_data[i+1].get("SLIP_DIVI")) {
						alert(Msg.sMA0053);
						return false;
					}else if((slip_data[i].get("SLIP_DIVI") =="3" || slip_data[i].get("SLIP_DIVI") == "4") && (slip_data[i+1].get("SLIP_DIVI") =="1" || slip_data[i+1].get("SLIP_DIVI") == "2") ) {
						alert(Msg.sMA0053);
						return false;
					}
				}
			})
			return true;
		},
		checkDept:function() {
			var insertRecords=this.getNewRecords( );
			var updateRecords=this.getUpdatedRecords( );
			//20200813 추가: detailStore의 데이터도 체크하도록 로직 추가
			var insertRecords2 = detailStore.getNewRecords( );
			var updateRecords2 = detailStore.getUpdatedRecords( );
			//20200813 수정: detailStore의 데이터도 체크하도록 로직 수정
//			var changedRec = [].concat(insertRecords).concat(updateRecords);
			var changedRec = [].concat(insertRecords).concat(updateRecords).concat(insertRecords2).concat(updateRecords2);

			var rtn = true;
			//20200813 수정: detailStore의 데이터도 체크하고 사업장 부터 체크한 후 부서 체크도록 로직 전체수정
//			var checked= false;
			var cDept_code_checked	= false;
			var cDiv_code_checked	= false;
			var store				= this;
			var err_msg1			= '';
			var err_msg2			= '';
			Ext.each(changedRec, function(rec) {
				var slip_data	= Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== rec.get("AC_DAY") && record.get('SLIP_NUM')== rec.get("SLIP_NUM") ) } ).items);	 
				var cDept_code	= rec.get("DEPT_CODE");
				var cDiv_code	= rec.get("DIV_CODE");
				Ext.each(slip_data, function(data, idx){
					if(rtn && !cDiv_code_checked) {
						if(cDiv_code != data.get("DIV_CODE")) {
//							if(!confirm("사업장이 다른 전표가 있습니다. 저장하시겠습니까?")) {
//								rtn = false;
//								checked = true;
//							} else {
//								checked = true;
//							}
//							Unilite.messageBox('사업장이 다른 전표가 있습니다.');
							
							if(multipleDivCodeAllowYN == 'N') {
								err_msg1 = '사업장이 다른 전표가 있습니다.';
								rtn = false;
								cDiv_code_checked = true;
							}
						}
					}
					if(rtn && !cDept_code_checked) {
						if(cDept_code != data.get("DEPT_CODE")) {
//							if(!confirm("귀속부서가 다른 전표가 있습니다. 저장하시겠습니까?")) {
//								rtn = false;
//								cDept_code_checked = true;
//							} else {
//								cDept_code_checked = true;
//							}
							err_msg2 = '귀속부서가 다른 전표가 있습니다.';
							cDept_code_checked = true;
						}
					}
				});
			})
			if(!Ext.isEmpty(err_msg1)) {
				Unilite.messageBox('사업장이 다른 전표가 있습니다.');
			} else {
				if(!Ext.isEmpty(err_msg2)) {
					if(!confirm("귀속부서가 다른 전표가 있습니다. 저장하시겠습니까?")) {
						rtn = false;
					}
				}
			}
			return rtn;
		},
		slipGridChange:function(records){
			//var grid = masterGrid1;
			grid = UniAppManager.app.getActiveGrid();
			//var record = grid.getSelectedRecord();
			var me = this;
			Ext.each(records, function(record, idx) {
				
				if(record){
					if(!Ext.isEmpty(record.get('AC_DAY')) && !Ext.isEmpty(record.get('SLIP_NUM')) && !Ext.isEmpty(record.get('DR_CR'))) {
						
						slipStore1.loadStoreRecords(me, record.get('AC_DAY'),  record.get('SLIP_NUM'));
						slipStore2.loadStoreRecords(me, record.get('AC_DAY'),  record.get('SLIP_NUM'));
					}
				}
			});
			if(Ext.isEmpty(me.getData())) {
				slipStore1.loadData({})
				slipStore2.loadData({})
			}
		},
		checkSupplySum:function(salesSupplyAmt, salesTaxAmt, proofKind) {
			var rtn = true;
			
			var acSuppyAmt=0;
			var acTaxAmt=0;
			var drSum = 0;
			var rtn = true;
			var store = this;
			var spec_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('SPEC_DIVI') == 'F1' || record.get('SPEC_DIVI') == 'F2') } ).items);		
			var dr_data = Ext.Array.push(store.data.filterBy(function(record) {return ( record.get('DR_CR') == '1') } ).items);	 
			 
			Ext.each(spec_data, function(item){
				for(var i=1; i <=6; i++) {
					if(item.get('AC_CODE'+i.toString()) == 'I1') {
						var amt = item.get('AC_DATA'+i.toString())
						if(amt){
							acSuppyAmt += parseInt(amt);
						}
					}
					if(item.get('AC_CODE'+i.toString()) == 'I6') {
						var tax = item.get('AC_DATA'+i.toString())
						if(tax){
							acTaxAmt += parseInt(tax);
						}
					}
				}
			})
			
			Ext.each(dr_data, function(item){
				drSum += item.get("AMT_I");
			})  
			
			console.log("drSum :", drSum, ", salesSupplyAmt :", salesSupplyAmt,", salesTaxAmt :", salesTaxAmt, ", acSuppyAmt :", acSuppyAmt,", acTaxAmt :", acTaxAmt);
			
			if(proofKind == '56') {
				if(drSum != salesTaxAmt) {
					if(!confirm(Msg.sMA0130+'\n'+ Msg.sMB061)) {
						rtn = false;
					}
				}
			}
			
			if(drSum != (salesSupplyAmt + salesTaxAmt) || salesSupplyAmt !=acSuppyAmt || salesTaxAmt != acTaxAmt) {
				if(!confirm(Msg.sMA0130+'\n'+ Msg.sMB061)) {
					rtn = false;
				}
			}
			
			
			return rtn;
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records == null || records.length == 0) {
					gsDraftYN   = "N"
					gsInputDivi = csINPUT_DIVI;
				}
			},
			add:function( store, records, index, eOpts ) {
				this.slipGridChange(records);
			},
			update:function( store, record, operation, modifiedFieldNames, details, eOpts) {
				
				if(UniUtils.indexOf('CUSTOM_NAME', modifiedFieldNames)) {
					if(record.get('CUSTOM_NAME') == '')	 {
						record.set('CUSTOM_CODE','');
					}
				}
				this.slipGridChange([record]);
			},
			remove:function( store, records, index, isMove, eOpts ) {
				setTimeout(this.slipGridChange(records), 10);
			},
			write: function(store, operation, eOpts) {
				console.log("write operation ", operation);
				if(operation.success && (operation._response.method =="insert" || operation._response.method =="update" || operation._response.method =="delete" )	)	{
					var pendRecord = detailStore.getData();
					Ext.each(pendRecord.items, function(item, idx){
						var tRecIdx = directMasterStore1.findBy(function(record) {return record.get("store2Idx") == item.getId()});
						var tRec = directMasterStore1.getAt(tRecIdx);
						if(tRec)	{
							item.set('J_EX_NUM'		, tRec.get("J_EX_NUM") );
							item.set('J_EX_SEQ'		, tRec.get("J_EX_SEQ") );
							item.set('BLN_I'		, tRec.get("BLN_I"));	
							item.set('FOR_BLN_I'	, tRec.get("FOR_BLN_I"));
							item.set('OPR_FLAG'		, "L");
						}
					})
					detailStore.commitChanges();
				}
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('agj110ukrMasterStore2',{
			model: 'agj110ukrv',
			autoLoad: false,
			uniOpt : {
				isMaster	: false,		// 상위 버튼 연결
				editable	: true,			// 수정 모드 사용
				deletable   : true,			// 삭제 가능 여부
				useNavi	 : false			// prev | next 버튼 사용
			},
			proxy: directProxy, // proxy
			// Store 관련 BL 로직
			// 검색 조건을 통해 DB에서 데이터 읽어 오기
			loadStoreRecords : function() {
				var param ;
				var form = Ext.getCmp('searchForm');
				if(form.isValid()) {
					param= form.getValues();
					slipForm.setValue("AP_STS", "");
					UniAppManager.app.setSearchReadOnly(true);
					this.load({
							params : param,
							callback:function(records, operation, success) {
								
								if(!Ext.isEmpty(records) && records.length > 0 ) {
									slipForm.setValue("AC_DATE",records[0].get("AC_DATE"));
									slipForm.setValue("EX_NUM", records[0].get("SLIP_NUM"));
									slipForm.setValue("IN_DIV_CODE", records[0].get("IN_DIV_CODE"));
									slipForm.setValue("IN_DEPT_CODE", records[0].get("IN_DEPT_CODE"));
									slipForm.setValue("IN_DEPT_NAME", records[0].get("IN_DEPT_NAME"));
									slipForm.setValue("CHARGE_CODE", records[0].get("CHARGE_CODE"));
									slipForm.setValue("CHARGE_NAME", records[0].get("CHARGE_NAME"));
									slipForm.setValue("AP_STS", records[0].get("AP_STS"));
									
									gsApSts	  = records[0].get("AP_STS");
									gsInputPath  = records[0].get("INPUT_PATH");
									gsInputDivi  = records[0].get("INPUT_DIVI");
									gsDraftYN	= records[0].get("DRAFT_YN");
						
								}
								detailStore.loadStoreRecords(param, records);
								
							}
					});
				}
			},
			listeners:{
				load:function(store, records, successful, operation, eOpt) {
					Ext.each(records, function(record){
						record.set("store2Idx", record.getId());
					})
					store.commitChanges();
					//directMasterStore1.loadStoreRecords(records);
					directMasterStore1.loadData(records);
				},
				add:function( store, records, index, eOpts ) {
					Ext.each(records, function(record){
						record.set("store2Idx", record.getId());
					})
					directMasterStore1.add(records);
				},
				update:function( store, record, operation, modifiedFieldNames, details, eOpts) {
					var store1dx = directMasterStore1.findBy(function(fRecord){return fRecord.get("store2Idx") == record.getId();} );
					
					if(store1dx>=0) {
						var dataRecord = directMasterStore1.getAt(store1dx);
						Ext.each(modifiedFieldNames, function(item, idx){
							if(dataRecord.phantom || (!dataRecord.phantom && !UniUtils.indexOf(item, doNotModifiedFields)) ) {
								dataRecord.set(item, record.get(item));
							}
						});
					}
					
					if(record.get("DR_CR") == "1" && record.get("SPEC_DIVI") =="F1" ) {
						var acCd_Idx = UniAccnt.findAcCode(record,"E2" );
						if(!Ext.isEmpty(acCd_Idx)) {
							var currentIdx = store.indexOf(record);
							if(currentIdx > 0) {
								var preRecord = store.getAt(currentIdx-1);
								record.set("AC_DATA"+acCd_Idx.toString(), preRecord.get("ACCNT"))
								record.set("AC_DATA_NAME"+acCd_Idx.toString(), preRecord.get("ACCNT_NAME"))
							}
						}
					}
					//공급가액(I1)
					if(UniUtils.indexOf('SPEC_DIVI', modifiedFieldNames) && (record.get("SPEC_DIVI") =="F1" || record.get("SPEC_DIVI") =="F2")) {
						
						var currentIdx = store.indexOf(record);
						var prevRecord = store.getAt(currentIdx-1);
						if(prevRecord) {
							UniAppManager.app.fnSetAcCode(record, "I1", prevRecord.get("AMT_I"));	// 공급가액
						}
					}
					// 세액(I6)
					if(UniUtils.indexOf('AMT_I', modifiedFieldNames) && (record.get("SPEC_DIVI") =="F1" || record.get("SPEC_DIVI") =="F2")) {
						UniAppManager.app.fnSetAcCode(record, "I6", record.get("AMT_I"));	// 세액
					}
					if(UniUtils.indexOf('CUSTOM_NAME', modifiedFieldNames)) {
						if(record.get('CUSTOM_NAME') == '')	 {
							record.set('CUSTOM_CODE','');
						}
					}
					//this.slipGridChange([record]);
				},
				remove:function( store, records, index, isMove, eOpts ) {
					Ext.each(records, function(delRecord, idx) {
						var store1dx = directMasterStore1.findBy(function(fRecord) {return fRecord.get("store2Idx") == delRecord.getId();} )
						if(store1dx>=0) {
							directMasterStore1.removeAt( store1dx ) ;
						}
					});
					
					
				}
			}
	});
	Unilite.defineModel('Agj110ukrPendModel', {
		fields: [{name: 'SLIP_SEQ'				,text: '순번'				,type: 'int'},
			 {name: 'ACCNT'						,text: '계정코드'			,type: 'string'},
			 {name: 'ACCNT_NAME'				,text: '계정과목명'			,type: 'string'},
			 //{name: 'ORG_AC_DATE'				,text: '전표일'			,type: 'uniDate'},
			 {name: 'ORG_AC_DATE'				,text: '전표일'			,type: 'string'},
			 {name: 'ORG_SLIP_NUM'				,text: '번호'				,type: 'string'},
			 {name: 'ORG_SLIP_SEQ'				,text: '순번'				,type: 'int'},
			 {name: 'PEND_NAME'					,text: '미결항목코드'			,type: 'string'},
			 {name: 'PEND_DATA_CODE'			,text: '미결코드'			,type: 'string'},
			 {name: 'PEND_DATA_NAME'			,text: '미결항목명'			,type: 'string'}, 
			 {name: 'PEND_YN'					,text: '미결항목여부'	 		,type: 'string'},
			 {name: 'J_AMT_I'					,text: '반제가능금액'	 		,type: 'uniPrice', editable:true},
			 {name: 'FOR_J_AMT_I'				,text: '외화반제가능금액'		,type: 'uniFC', editable:true},
			 {name: 'EXCHG_RATE_O'				,text: '환율'				,type: 'uniER'},
			 {name: 'MONEY_UNIT'				,text: '화폐단위'			,type: 'string'},
			 {name: 'REMARK'					,text: '적요'				,type: 'string', editable:true},
			 {name: 'BLN_I'						,text: '잔액'				,type: 'string'},
			 {name: 'DEPT_NAME'					,text: '귀속부서'			,type: 'string'},
			 {name: 'DIV_NAME'					,text: '귀속사업장'			,type: 'string'},
	
			 {name: 'OLD_AC_DATE'				,text: 'OLD_AC_DATE'	,type: 'uniDate'},
			 {name: 'OLD_SLIP_NUM'				,text: 'OLD_SLIP_NUM'	,type: 'int'},
			 {name: 'OLD_SLIP_SEQ'				,text: 'OLD_SLIP_SEQ'	,type: 'int'},
			 
		 
			 {name: 'SEQ'						,text: 'SEQ'			,type: 'int'},
			 {name: 'P_ACCNT'					,text: ''				,type: 'string'},
			 {name: 'ORG_DATA'					,text: ''				,type: 'string'},
			 {name: 'PEND_CODE'					,text: ''				,type: 'string'},
			 {name: 'INPUT_PATH'				,text: ''				,type: 'string'},
			 {name: 'FOR_BLN_I'					,text: '외화잔액'			,type: 'uniFC'},
			 {name: 'BLN_I'						,text: ''				,type: 'uniPrice'},
			 {name: 'DEPT_CODE'					,text: ''				,type: 'string'},
			 {name: 'BILL_DIV_CODE'				,text: ''				,type: 'string'},
			 {name: 'J_EX_DATE'					,text: ''				,type: 'uniDate'},
			 {name: 'J_EX_NUM'					,text: ''				,type: 'int'},
			 {name: 'J_EX_SEQ'					,text: '순번'				,type: 'int'},
			 {name: 'DR_CR'						,text: '차대구분'			,type: 'string', defaultValue:'1', comboType:'AU', comboCode:'A001'},
			 {name: 'CUSTOM_CODE'				,text: ''				,type: 'string'},
			 {name: 'CUSTOM_NAME'				,text: ''				,type: 'string'},
			 
			 {name: 'ACCNT_SPEC'				,text: ''				,type: 'string'},
			 {name: 'SPEC_DIVI'					,text: ''				,type: 'string'},
			 {name: 'PROFIT_DIVI'				,text: ''				,type: 'string'},
			 {name: 'JAN_DIVI'					,text: ''				,type: 'string'},
			 {name: 'BUDG_YN'					,text: ''				,type: 'string'},
			 {name: 'BUDGCTL_YN'				,text: ''				,type: 'string'},
			 {name: 'FOR_YN'					,text: ''				,type: 'string'},
			 {name: 'DIV_CODE'					,text: '귀속사업장'  ,type: 'string', comboType:'BOR120'},
					  
			
			 {name: 'AC_CODE1'					,text:'관리항목코드1'			,type : 'string'}
			,{name: 'AC_CODE2'					,text:'관리항목코드2'			,type : 'string'}
			,{name: 'AC_CODE3'					,text:'관리항목코드3'			,type : 'string'}
			,{name: 'AC_CODE4'					,text:'관리항목코드4'			,type : 'string'}
			,{name: 'AC_CODE5'					,text:'관리항목코드5'			,type : 'string'}
			,{name: 'AC_CODE6'					,text:'관리항목코드6'			,type : 'string'}
			
			,{name: 'AC_NAME1'					,text:'관리항목명1'			,type : 'string'}
			,{name: 'AC_NAME2'					,text:'관리항목명2'			,type : 'string'}
			,{name: 'AC_NAME3'					,text:'관리항목명3'			,type : 'string'}
			,{name: 'AC_NAME4'					,text:'관리항목명4'			,type : 'string'}
			,{name: 'AC_NAME5'					,text:'관리항목명5'			,type : 'string'}
			,{name: 'AC_NAME6'					,text:'관리항목명6'			,type : 'string'}
			
			,{name: 'AC_DATA1'					,text:'관리항목데이터1'		,type : 'string'}
			,{name: 'AC_DATA2'					,text:'관리항목데이터2'		,type : 'string'}
			,{name: 'AC_DATA3'					,text:'관리항목데이터3'		,type : 'string'}
			,{name: 'AC_DATA4'					,text:'관리항목데이터4'		,type : 'string'}
			,{name: 'AC_DATA5'					,text:'관리항목데이터5'		,type : 'string'}
			,{name: 'AC_DATA6'					,text:'관리항목데이터6'		,type : 'string'}
			
			,{name: 'AC_DATA_NAME1'				,text:'관리항목데이터명1'		,type : 'string'}
			,{name: 'AC_DATA_NAME2'				,text:'관리항목데이터명2'		,type : 'string'}
			,{name: 'AC_DATA_NAME3'				,text:'관리항목데이터명3'		,type : 'string'}
			,{name: 'AC_DATA_NAME4'				,text:'관리항목데이터명4'		,type : 'string'}
			,{name: 'AC_DATA_NAME5'				,text:'관리항목데이터명5'		,type : 'string'}
			,{name: 'AC_DATA_NAME6'				,text:'관리항목데이터명6'		,type : 'string'}
			,{name: 'AC_CTL1'					,text:'관리항목필수1'	 		,type : 'string'}
			,{name: 'AC_CTL2'					,text:'관리항목필수2'	 		,type : 'string'}
			,{name: 'AC_CTL3'					,text:'관리항목필수3'	 		,type : 'string'}
			,{name: 'AC_CTL4'					,text:'관리항목필수4'	 		,type : 'string'}
			,{name: 'AC_CTL5'					,text:'관리항목필수5'	 		,type : 'string'}
			,{name: 'AC_CTL6'					,text:'관리항목필수6'	 		,type : 'string'}
			
			,{name: 'BOOK_CODE1'				,text:''				,type : 'string'}
			,{name: 'BOOK_CODE2'				,text:''				,type : 'string'}
			,{name: 'BOOK_DATA1'				,text:''				,type : 'string'}
			,{name: 'BOOK_DATA2'				,text:''				,type : 'string'}
			,{name: 'BOOK_DATA_NAME1'			,text:''				,type : 'string'}
			,{name: 'BOOK_DATA_NAME2'			,text:''				,type : 'string'}
		
			,{name: 'AP_STS'					,text:''				,type : 'string'}
			,{name: 'AP_CHARGE_NAME'			,text:''				,type : 'string'}
			,{name: 'OPR_FLAG'					,text:''				,type : 'string',   defaultValue:'L'}
			,{name: 'INPUT_USER_ID'				,text:''				,type : 'string'}
			
			
			/*,{name: 'AC_TYPE1'				,text:'관리항목1유형'	 ,type : 'string'} 
			,{name: 'AC_TYPE2'				  ,text:'관리항목2유형'	 ,type : 'string'} 
			,{name: 'AC_TYPE3'				  ,text:'관리항목3유형'	 ,type : 'string'} 
			,{name: 'AC_TYPE4'				  ,text:'관리항목4유형'	 ,type : 'string'} 
			,{name: 'AC_TYPE5'				  ,text:'관리항목5유형'	 ,type : 'string'} 
			,{name: 'AC_TYPE6'				  ,text:'관리항목6유형'	 ,type : 'string'} 
			
			,{name: 'AC_LEN1'				   ,text:'관리항목1길이'	 ,type : 'string'}
			,{name: 'AC_LEN2'				   ,text:'관리항목2길이'	 ,type : 'string'}
			,{name: 'AC_LEN3'				   ,text:'관리항목3길이'	 ,type : 'string'}
			,{name: 'AC_LEN4'				   ,text:'관리항목4길이'	 ,type : 'string'}
			,{name: 'AC_LEN5'				   ,text:'관리항목5길이'	 ,type : 'string'}
			,{name: 'AC_LEN6'				   ,text:'관리항목6길이'	 ,type : 'string'}
			
			,{name: 'AC_POPUP1'				 ,text:'관리항목1팝업여부'   ,type : 'string'} 
			,{name: 'AC_POPUP2'				 ,text:'관리항목2팝업여부'   ,type : 'string'} 
			,{name: 'AC_POPUP3'				 ,text:'관리항목3팝업여부'   ,type : 'string'} 
			,{name: 'AC_POPUP4'				 ,text:'관리항목4팝업여부'   ,type : 'string'} 
			,{name: 'AC_POPUP5'				 ,text:'관리항목5팝업여부'   ,type : 'string'} 
			,{name: 'AC_POPUP6'				 ,text:'관리항목6팝업여부'   ,type : 'string'} 
			
			,{name: 'AC_FORMAT1'				,text:'관리항목1포멧'	 ,type : 'string'} 
			,{name: 'AC_FORMAT2'				,text:'관리항목2포멧'	 ,type : 'string'} 
			,{name: 'AC_FORMAT3'				,text:'관리항목3포멧'	 ,type : 'string'} 
			,{name: 'AC_FORMAT4'				,text:'관리항목4포멧'	 ,type : 'string'} 
			,{name: 'AC_FORMAT5'				,text:'관리항목5포멧'	 ,type : 'string'} 
			,{name: 'AC_FORMAT6'				,text:'관리항목6포멧'	 ,type : 'string'} 
		 */
		 ]
	});

	var detailStore = Unilite.createStore('agj110ukrDetailStore',{
		model: 'Agj110ukrPendModel',
		uniOpt : {
			isMaster:   true,		   // 상위 버튼 연결 
			editable:   true,		   // 수정 모드 사용 
			deletable:  true,		   // 삭제 가능 여부 
			useNavi :   false,		  // prev | newxt 버튼 사용
			allDeletable : true
		},
		autoLoad: false,
		proxy:detailDirectProxy,
		loadStoreRecords : function(param) {
			if(param) {
				console.log( param );
				this.load({
					params : param
				});
			}
		},
		saveStore:function() {},
		listeners:{
			load:function( store , records , successful , operation , eOpts ) {
				if(Ext.isEmpty(records) && directMasterStore2.count() == 0 ) {
					openSearchPopup();
					return;
				}
				var masterRecords = new Array();
				var sDate = slipForm.getValue("AC_DATE");
				var exNum = slipForm.getValue("EX_NUM");
				var sDay = Ext.Date.format(sDate, 'd').toString();
				var maxSeq = Unilite.nvl(directMasterStore1.max("SLIP_SEQ"),0) ;
				
				Ext.each(records, function(record, idx){
					var pendRefRecords = Ext.Array.push(
											pendRefStore.data.filterBy(function(rec) {
												return rec.get("ORG_DATA") == record.get("ORG_DATA") ;
											} ).items
										);
					if(pendRefRecords) {
						Ext.each(pendRefRecords, function(item, idx){
							if(item.get("J_AMT_I") == 0)  item.set("FLAG","D");
						})
					}
					var seq = maxSeq +1;
					masterRecords.push({
						'AC_DATE'			   : record.get("J_EX_DATE")
						,'SLIP_NUM'			   : record.get("J_EX_NUM")
						,'AC_DAY'			   :  Ext.Date.format(record.get("J_EX_DATE"), 'd').toString()
						
						,'SLIP_SEQ'			 : record.get("J_EX_SEQ")
						,'SLIP_DIVI'			: record.get("DR_CR") == "1" ? "3":"4"
						,'ACCNT'				: record.get("ACCNT")
						,'ACCNT_NAME'		   : record.get("ACCNT_NAME")
						,'CUSTOM_CODE'		  : record.get("CUSTOM_CODE")
						,'CUSTOM_NAME'		  : record.get("CUSTOM_NAME")
						,'DR_AMT_I'			 : record.get("DR_CR") == "1" ? record.get("J_AMT_I"):0
						,'CR_AMT_I'			 : record.get("DR_CR") == "2" ? record.get("J_AMT_I"):0
						,'REMARK'			   : record.get("REMARK")
						,'DIV_CODE'			 : record.get("DIV_CODE")
						,'OLD_AC_DATE'		  : record.get("OLD_AC_DATE")
						,'OLD_SLIP_NUM'		 : record.get("OLD_SLIP_NUM")
						,'OLD_SLIP_SEQ'		 : record.get("OLD_SLIP_SEQ")
						
						,'DR_CR'				: record.get("DR_CR")
						,'DEPT_CODE'			: record.get("DEPT_CODE")
						,'MONEY_UNIT'		   : record.get("MONEY_UNIT")
						,'EXCHG_RATE_O'		 : record.get("EXCHG_RATE_O")
						,'FOR_AMT_I'			: record.get("FOR_J_AMT_I")
											   
						,'IN_DIV_CODE'		  : record.get("IN_DIV_CODE") ? record.get("IN_DIV_CODE"):UserInfo.divCode
						,'IN_DEPT_CODE'		 : record.get("IN_DEPT_CODE") ? record.get("IN_DEPT_CODE"):baseInfo.gsDeptCode
						,'IN_DEPT_NAME'		 : record.get("IN_DEPT_NAME") ? record.get("IN_DEPT_NAME"):baseInfo.gsDeptName
						
						//,'IN_DEPT_CODE'		 : record.get("IN_DEPT_CODE") ? record.get("IN_DEPT_CODE"):UserInfo.deptCode
						//,'IN_DEPT_NAME'		 : record.get("IN_DEPT_NAME") ? record.get("IN_DEPT_NAME"):UserInfo.deptName
						,'BILL_DIV_CODE'		: record.get("BILL_DIV_CODE")

						,'AC_CODE1'			 : record.get("AC_CODE1")
						,'AC_CODE2'			 : record.get("AC_CODE2")
						,'AC_CODE3'			 : record.get("AC_CODE3")
						,'AC_CODE4'			 : record.get("AC_CODE4")
						,'AC_CODE5'			 : record.get("AC_CODE5")
						,'AC_CODE6'			 : record.get("AC_CODE6")
						
						,'AC_NAME1'			 : record.get("AC_NAME1")
						,'AC_NAME2'			 : record.get("AC_NAME2")
						,'AC_NAME3'			 : record.get("AC_NAME3")
						,'AC_NAME4'			 : record.get("AC_NAME4")
						,'AC_NAME5'			 : record.get("AC_NAME5")
						,'AC_NAME6'			 : record.get("AC_NAME6")

						,'AC_DATA1'			 : record.get("AC_DATA1")
						,'AC_DATA2'			 : record.get("AC_DATA2")
						,'AC_DATA3'			 : record.get("AC_DATA3")
						,'AC_DATA4'			 : record.get("AC_DATA4")
						,'AC_DATA5'			 : record.get("AC_DATA5")
						,'AC_DATA6'			 : record.get("AC_DATA6")

						,'AC_DATA_NAME1'		: record.get("AC_DATA_NAME1")
						,'AC_DATA_NAME2'		: record.get("AC_DATA_NAME2")
						,'AC_DATA_NAME3'		: record.get("AC_DATA_NAME3")
						,'AC_DATA_NAME4'		: record.get("AC_DATA_NAME4")
						,'AC_DATA_NAME5'		: record.get("AC_DATA_NAME5")
						,'AC_DATA_NAME6'		: record.get("AC_DATA_NAME6")

						,'BOOK_CODE1'		   : record.get("BOOK_CODE1")
						,'BOOK_CODE2'		   : record.get("BOOK_CODE2")
						,'BOOK_DATA1'		   : record.get("BOOK_DATA1")
						,'BOOK_DATA2'		   : record.get("BOOK_DATA2")
						,'BOOK_DATA_NAME1'	  : record.get("BOOK_DATA_NAME1")
						,'BOOK_DATA_NAME2'	  : record.get("BOOK_DATA_NAME2")
						
						,'AC_CTL1'			  : record.get("AC_CTL1")
						,'AC_CTL2'			  : record.get("AC_CTL2")
						,'AC_CTL3'			  : record.get("AC_CTL3")
						,'AC_CTL4'			  : record.get("AC_CTL4")
						,'AC_CTL5'			  : record.get("AC_CTL5")
						,'AC_CTL6'			  : record.get("AC_CTL6")
						
						,'ACCNT_SPEC'		   : record.get("ACCNT_SPEC")
						,'SPEC_DIVI'			: record.get("SPEC_DIVI")
						,'PROFIT_DIVI'		  : record.get("PROFIT_DIVI")
						,'JAN_DIVI'			 : record.get("JAN_DIVI")

						,'PEND_CODE'			: record.get("PEND_CODE")
						,'PEND_DATA_CODE'	   : record.get("PEND_DATA_CODE")
						,'PEND_YN'			  : record.get("PEND_YN")
						,'BUDG_YN'			  : record.get("BUDG_YN")
						,'BUDGCTL_YN'		   : record.get("BUDGCTL_YN")
						,'FOR_YN'			   : record.get("FOR_YN")
						
						,'INPUT_PATH'		   : record.get("INPUT_PATH")
						,'CHARGE_CODE'		  : '${chargeCode}'
						,'AP_STS'			   : "1"
						
						,'EX_DATE'			  : record.get("J_EX_DATE")
						,'EX_NUM'			   : record.get("J_EX_NUM")
						,'EX_SEQ'			   : record.get("J_EX_SEQ")

						,'COMP_CODE'			: UserInfo.comp_code
						,'AMT_I'				: record.get("J_AMT_I")
						
						,'OPR_FLAG'			 : 'N'
						,'ORG_DATA'			 : record.get("ORG_DATA")
						,'INPUT_USER_ID'		: record.get("INPUT_USER_ID")
						
						,'POSTIT_YN'			:'N'
						,'ORG_FLAG'			 :'L'
						,'store2Idx'         : record.getId()
						, 'ORG_AC_DATE' 	 : record.get('ORG_AC_DATE')
						, 'ORG_SLIP_NUM'  	 : record.get('ORG_SLIP_NUM')
						, 'ORG_SLIP_SEQ' 	 : record.get('ORG_SLIP_SEQ')
						, 'J_AMT_I' 		 : record.get('J_AMT_I')
						, 'FOR_J_AMT_I'		 : record.get('FOR_J_AMT_I')
						, 'DEPT_NAME'		 : record.get('DEPT_NAME')
						, 'SEQ'				 : record.get('SEQ')
						, 'J_EX_DATE'		 : record.get('J_EX_DATE')
						, 'J_EX_NUM'		 : record.get('J_EX_NUM')
						, 'J_EX_SEQ'		 : record.get('J_EX_SEQ')
						, 'IS_PEND_INPUT'    : 'Y' 
					});
					
				})
				store.commitChanges();
				directMasterStore1.loadStoreRecords(masterRecords);
			},
			add:function(store, records, index, eOpts ) {
				var sDate = slipForm.getValue("AC_DATE");
				var exNum = slipForm.getValue("EX_NUM");
				var sDay = Ext.Date.format(sDate, 'd').toString();
				var maxSeq = Unilite.nvl(directMasterStore1.max("SLIP_SEQ"),0) ;
				
				Ext.each(records, function(record, idx) {
					record.set('OPR_FLAG','N');
					maxSeq =maxSeq+1;
					var r = {
						'AC_DATE'			   : sDate
						,'SLIP_NUM'			   : exNum
						,'AC_DAY'			   : sDay
						
						,'SLIP_SEQ'			   : maxSeq
						,'SLIP_DIVI'		   : record.get("DR_CR") == "1" ? "3":"4"
						,'ACCNT'			   : record.get("ACCNT")
						,'ACCNT_NAME'		   : record.get("ACCNT_NAME")
						,'CUSTOM_CODE'		   : record.get("CUSTOM_CODE")
						,'CUSTOM_NAME'		   : record.get("CUSTOM_NAME")
						,'DR_AMT_I'			   : record.get("DR_CR") == "1" ? record.get("J_AMT_I"):0
						,'CR_AMT_I'			   : record.get("DR_CR") == "2" ? record.get("J_AMT_I"):0
						,'REMARK'			   : record.get("REMARK")
						,'DIV_CODE'			   : record.get("DIV_CODE")

						
						,'OLD_AC_DATE'		   : sDate
						,'OLD_SLIP_NUM'		   : exNum
						,'OLD_SLIP_SEQ'		   : maxSeq
						
						,'DR_CR'			   : record.get("DR_CR")
						,'DEPT_CODE'		   : record.get("DEPT_CODE")
						,'MONEY_UNIT'		   : record.get("MONEY_UNIT")
						,'EXCHG_RATE_O'		   : record.get("EXCHG_RATE_O")
						,'FOR_AMT_I'		   : record.get("FOR_J_AMT_I")
						
						,'IN_DIV_CODE'		   : UserInfo.divCode
						,'IN_DEPT_CODE'		   : baseInfo.gsDeptCode
						,'IN_DEPT_NAME'		   : baseInfo.gsDeptName
						
						//,'IN_DEPT_CODE'	   : UserInfo.deptCode
						//,'IN_DEPT_NAME'	   : UserInfo.deptName
						,'BILL_DIV_CODE'	   : record.get("BILL_DIV_CODE")

						,'AC_CODE1'			   : record.get("AC_CODE1")
						,'AC_CODE2'			   : record.get("AC_CODE2")
						,'AC_CODE3'			   : record.get("AC_CODE3")
						,'AC_CODE4'			   : record.get("AC_CODE4")
						,'AC_CODE5'			   : record.get("AC_CODE5")
						,'AC_CODE6'			   : record.get("AC_CODE6")
						
						,'AC_NAME1'			   : record.get("AC_NAME1")
						,'AC_NAME2'			   : record.get("AC_NAME2")
						,'AC_NAME3'			   : record.get("AC_NAME3")
						,'AC_NAME4'			   : record.get("AC_NAME4")
						,'AC_NAME5'			   : record.get("AC_NAME5")
						,'AC_NAME6'			   : record.get("AC_NAME6")

						,'AC_DATA1'			   : record.get("AC_DATA1")
						,'AC_DATA2'			   : record.get("AC_DATA2")
						,'AC_DATA3'			   : record.get("AC_DATA3")
						,'AC_DATA4'			   : record.get("AC_DATA4")
						,'AC_DATA5'			   : record.get("AC_DATA5")
						,'AC_DATA6'			   : record.get("AC_DATA6")
						
						,'AC_CTL1'			   : record.get("AC_CTL1")
						,'AC_CTL2'			   : record.get("AC_CTL2")
						,'AC_CTL3'			   : record.get("AC_CTL3")
						,'AC_CTL4'			   : record.get("AC_CTL4")
						,'AC_CTL5'			   : record.get("AC_CTL5")
						,'AC_CTL6'			   : record.get("AC_CTL6")
						
						,'AC_DATA_NAME1'	   : record.get("AC_DATA_NAME1")
						,'AC_DATA_NAME2'	   : record.get("AC_DATA_NAME2")
						,'AC_DATA_NAME3'	   : record.get("AC_DATA_NAME3")
						,'AC_DATA_NAME4'	   : record.get("AC_DATA_NAME4")
						,'AC_DATA_NAME5'	   : record.get("AC_DATA_NAME5")
						,'AC_DATA_NAME6'	   : record.get("AC_DATA_NAME6")

						,'BOOK_CODE1'		   : record.get("BOOK_CODE1")
						,'BOOK_CODE2'		   : record.get("BOOK_CODE2")
						,'BOOK_DATA1'		   : record.get("BOOK_DATA1")
						,'BOOK_DATA2'		   : record.get("BOOK_DATA2")
						,'BOOK_DATA_NAME1'	   : record.get("BOOK_DATA_NAME1")
						,'BOOK_DATA_NAME2'	   : record.get("BOOK_DATA_NAME2")

						,'ACCNT_SPEC'		   : record.get("ACCNT_SPEC")
						,'SPEC_DIVI'		   : record.get("SPEC_DIVI")
						,'PROFIT_DIVI'		   : record.get("PROFIT_DIVI")
						,'JAN_DIVI'			   : record.get("JAN_DIVI")

						,'PEND_CODE'		   : record.get("PEND_CODE")
						,'PEND_YN'			   : record.get("PEND_YN")
						,'PEND_DATA_CODE'	   : record.get("PEND_DATA_CODE")
						,'BUDG_YN'			   : record.get("BUDG_YN")
						,'BUDGCTL_YN'		   : record.get("BUDGCTL_YN")
						,'FOR_YN'			   : record.get("FOR_YN")
						
						,'INPUT_PATH'		   : record.get("INPUT_PATH")
						,'CHARGE_CODE'		   : '${chargeCode}'
						,'AP_STS'			   : "1"
						
						,'EX_DATE'			   : record.get("J_EX_DATE")
						,'EX_NUM'			   : record.get("J_EX_NUM")
						,'EX_SEQ'			   : maxSeq

						,'COMP_CODE'		   : UserInfo.comp_code
						,'AMT_I'			   : record.get("J_AMT_I")
						
						,'OPR_FLAG'			   : 'N'
						,'ORG_DATA'			   : record.get("ORG_DATA")
						,'POSTIT_YN'		   :'N'
						,'INPUT_USER_ID'	   : record.get("INPUT_USER_ID")
						, 'ORG_AC_DATE' 	   : record.get('ORG_AC_DATE')
						, 'ORG_SLIP_NUM'  	   : record.get('ORG_SLIP_NUM')
						, 'ORG_SLIP_SEQ' 	   : record.get('ORG_SLIP_SEQ')
						, 'J_AMT_I' 		   : record.get('J_AMT_I')
						, 'FOR_J_AMT_I'		   : record.get('FOR_J_AMT_I')
						, 'DEPT_NAME'		   : record.get('DEPT_NAME')
						, 'SEQ'				   : record.get('SEQ')
						, 'J_EX_DATE'		   : record.get('J_EX_DATE')
						, 'J_EX_NUM'		   : record.get('J_EX_NUM')
						, 'J_EX_SEQ'		   : record.get('J_EX_SEQ')
						, 'IS_PEND_INPUT'      : 'Y'
					};
					UniAppManager.app.setSearchReadOnly(true, false);
					var model = directMasterStore1.add(r);
					if(model && model.length > 0)	{
						model[0].set('store2Idx', record.getId());
					}
				})
			},
			update:function(store, record, operation, modifiedFieldNames, details, eOpts){
				//record.set('OPR_FLAG','U');
				var sRecordIdx = directMasterStore1.findBy(function(rec,id){
					return rec.get("ORG_DATA") == record.get("ORG_DATA") && rec.get("store2Idx") == record.getId();
				})
				if(sRecordIdx != null && sRecordIdx >= 0) {
					var sRecord = directMasterStore1.getAt(sRecordIdx);
				 
					Ext.each(modifiedFieldNames, function(name, idx){
						switch(name) {
							case 'ACCNT'				: sRecord.set(name, record.get("ACCNT"));
														  break;
							case 'ACCNT_NAME'		   : sRecord.set(name, record.get("ACCNT_NAME"));
														  break;
							case 'CUSTOM_CODE'		  : sRecord.set(name,record.get("CUSTOM_CODE"));
														  break;
							case 'CUSTOM_NAME'		  : sRecord.set(name,record.get("CUSTOM_NAME"));
														  break;
							case 'J_AMT_I'			  : sRecord.set(record.get("DR_CR") == "1" ? "DR_AMT_I":"CR_AMT_I",  record.get("J_AMT_I"));
														  sRecord.set(record.get("DR_CR") == "1" ? "CR_AMT_I":"DR_AMT_I",  0);
														  sRecord.set("AMT_I",  record.get("J_AMT_I"));
														 pendRefStore.removeFilter(pendRefFilter);
														  var refDataIdx = pendRefStore.findBy(function(fRecord) { return fRecord.get("ORG_DATA") == record.get("ORG_DATA");});
														  if(refDataIdx > -1) {
															  var refData = pendRefStore.getAt(refDataIdx);
															  var relateRecs = Ext.Array.push(store.data.filterBy(function(myRecord) {return (myRecord.get('ORG_DATA')== record.get("ORG_DATA") ) && myRecord.phantom == true } ).items);
															  var sum = 0, forSum = 0;
															  Ext.each(relateRecs, function(summaryRec){
																sum += summaryRec.get("J_AMT_I");
																forSum += summaryRec.get("FOR_J_AMT_I");
															  })
															  if(refData.get("J_AMT_I") != sum) {
																	refData.set("FLAG","R");
																	// 참조 반제금액 = 참조잔액 - 참조 결의금액 - 미결반제의 반제금액
																	refData.set("J_AMT_I",refData.get("BLN_I") - refData.get("EX_AMT_I") - sum);
																	refData.set("FOR_J_AMT_I",refData.get("FOR_BLN_I")- refData.get("FOR_EX_AMT_I") - forSum);
															  }
														  }
														  pendRefStore.addFilter(pendRefFilter);
														  sRecord.set(name,record.get("J_AMT_I"));
														  break;
							case 'DR_CR'				: sRecord.set(name, record.get("DR_CR"));
														  sRecord.set("SLIP_DIVI", record.get("DR_CR") == "1" ? "3":"4");
														  break;
							case 'REMARK'			   : sRecord.set(name,record.get("REMARK"));
														  break;
							case 'DIV_CODE'			 : sRecord.set(name,record.get("DIV_CODE"));
														  break;
							
							case 'DEPT_CODE'			: sRecord.set(name,record.get("DEPT_CODE"));
														  break;
							case 'MONEY_UNIT'		   : sRecord.set(name,record.get("MONEY_UNIT"));
														  break;
							case 'EXCHG_RATE_O'		 : sRecord.set(name,record.get("EXCHG_RATE_O"));
														  break;
							case 'FOR_J_AMT_I'		  : sRecord.set("FOR_AMT_I",record.get("FOR_J_AMT_I"));	
														  /* sRecord : directMasterStore1
														  	 refData :pendRefStore
														  	relateRecs : detailStore
														  */
														  pendRefStore.removeFilter(pendRefFilter);
														  var refDataIdx = pendRefStore.findBy(function(fRecord) {return fRecord.get("ORG_DATA") == record.get("ORG_DATA");});
														  if(refDataIdx > -1) {
															  var refData = pendRefStore.getAt(refDataIdx);
															  var relateRecs = Ext.Array.push(store.data.filterBy(function(myRecord) {return (myRecord.get('ORG_DATA')== record.get("ORG_DATA")) && myRecord.phantom == true } ).items);
															  var sum = 0, forSum = 0;		  
															  Ext.each(relateRecs, function(summaryRec){
																sum += summaryRec.get("J_AMT_I");
																forSum += summaryRec.get("FOR_J_AMT_I");
															  })
															  if(refData.get("FOR_J_AMT_I") != forSum) {
																	refData.set("FLAG","R");
																	// 참조 반제금액 = 참조잔액 - 참조 결의금액 - 미결반제의 반제금액
																	refData.set("J_AMT_I",refData.get("BLN_I") - refData.get("EX_AMT_I") - sum);
																	refData.set("FOR_J_AMT_I",refData.get("FOR_BLN_I")- refData.get("FOR_EX_AMT_I") - forSum);
															  }
														  }
														  pendRefStore.addFilter(pendRefFilter);
														  sRecord.set(name,record.get("FOR_J_AMT_I"));
														  break;
												   
							case 'BILL_DIV_CODE'		: sRecord.set(name,record.get("BILL_DIV_CODE"));
														  break;
							
							case 'ACCNT_SPEC'		   : sRecord.set(name,record.get("ACCNT_SPEC"));
														  break;
							case 'SPEC_DIVI'			: sRecord.set(name,record.get("SPEC_DIVI"));
														  break;
							case 'PROFIT_DIVI'		  : sRecord.set(name,record.get("PROFIT_DIVI"));
														  break;
							case 'JAN_DIVI'			 : sRecord.set(name,record.get("JAN_DIVI"));
														  break;

							case 'PEND_CODE'			: sRecord.set(name,record.get("PEND_CODE"));
														  break;
							case 'PEND_DATA_CODE'	   : sRecord.set(name,record.get("PEND_DATA_CODE"));
														  break;
							case 'BUDG_YN'			  : sRecord.set(name,record.get("BUDG_YN"));
														  break;
							case 'BUDGCTL_YN'		   : sRecord.set(name,record.get("BUDGCTL_YN"));
														  break;
							case 'FOR_YN'			   : sRecord.set(name,record.get("FOR_YN"));
														  break;
							case 'OPR_FLAG'			 : sRecord.set(name,record.get("OPR_FLAG"));
														  break;
							case 'AC_DATA1'			 : sRecord.set(name,record.get("AC_DATA1"));
						  								  break;
							case 'AC_DATA2'			 : sRecord.set(name,record.get("AC_DATA2"));
							  							  break;
							case 'AC_DATA3'			 : sRecord.set(name,record.get("AC_DATA3"));
							  							  break;
							case 'AC_DATA4'			 : sRecord.set(name,record.get("AC_DATA4"));
							  							  break;
							case 'AC_DATA5'			 : sRecord.set(name,record.get("AC_DATA5"));
							  							  break;
							case 'AC_DATA6'			 : sRecord.set(name,record.get("AC_DATA6"));
														  break;
							case 'ORG_AC_DATE'		 : sRecord.set(name,record.get("ORG_AC_DATE"));
							 							  break;
							case 'ORG_SLIP_NUM'		 : sRecord.set(name,record.get("ORG_SLIP_NUM"));
														  break;
							case 'ORG_SLIP_SEQ'		 : sRecord.set(name,record.get("ORG_SLIP_SEQ"));
														  break;
							case 'DEPT_NAME'		 : sRecord.set(name,record.get("DEPT_NAME"));
														  break;
							case 'SEQ'				 : sRecord.set(name,record.get("SEQ"));
														  break;
							case 'J_EX_DATE'		 : sRecord.set(name,record.get("J_EX_DATE"));
														  break;
							case 'J_EX_NUM'			 : sRecord.set(name,record.get("J_EX_NUM"));
														  break;
							case 'J_EX_SEQ'			 : sRecord.set(name,record.get("J_EX_SEQ"));
														  break;
							default:break;
						}
						
					})
				}else {
					console.log("sRecord is null");
				}
				
			},
			remove : function( store , records , index , isMove , eOpts ) {
				//저장 Store에서 삭제
				Ext.each(records, function(record, idx){
					record.set('OPR_FLAG','D');
					var sRecords = Ext.Array.push(
										directMasterStore1.data.filterBy(function(rec) {
											return rec.get("ORG_DATA") == record.get("ORG_DATA")  && rec.get("store2Idx") == record.getId();
										} ).items
									);
					directMasterStore1.remove(sRecords);
					
					// 미결 참조 데이터 
					pendRefStore.removeFilter(pendRefFilter);
					var refDataIdx = pendRefStore.findBy(function(fRecord){return fRecord.get("ORG_DATA") == record.get("ORG_DATA");});
					if(refDataIdx > -1) {
						var refData = pendRefStore.getAt(refDataIdx);
						refData.set("FLAG","R");
						refData.set("J_AMT_I",refData.get("J_AMT_I") + record.get("J_AMT_I"));
						refData.set("FOR_J_AMT_I",refData.get("FOR_J_AMT_I") + record.get("FOR_J_AMT_I"));
					}
					pendRefStore.addFilter(pendRefFilter);
				});
				
			}
		}
	}); 
	
		
	
	/**
	 * 검색조건 (Search Panel) 
	 * @type 
	 */
	//hidden form
	var panelSearch =  Unilite.createSearchPanel('searchForm',  {
		title: '검색조건',
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
			title: '기본정보',  
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items:[{
					fieldLabel: '전표일',
					xtype: 'uniDatefield',
					name: 'AC_DATE',
					value: UniDate.get('today'),
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('AC_DATE', newValue);
						}
					}
				},{
					fieldLabel: '전표번호',
					xtype: 'uniNumberfield',
					name: 'EX_NUM',
					allowBlank:false,
					value:1,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('EX_NUM', newValue); 
						}
					}
				},
				{
					fieldLabel: '회계부서구분',
					name: 'CHARGE_DIVI' ,
					value :gsChargeDivi,
					hidden:true
				},
				{
					fieldLabel:'결의부서',
					name : 'IN_DEPT_CODE',
					allowBlank:false,
					//value:UserInfo.deptCode,
					value:baseInfo.gsDeptCode,
					width:160,
					hidden:true,
					listeners:{
						change:function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('IN_DEPT_CODE'.newValue)
						}
					}
				},
				{
					fieldLabel:'입력자',
					name : 'CHARGE_CODE',
					allowBlank:false,
					value:'${chargeCode}',
					width:160,
					hidden:true,
					listeners:{
						change:function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('CHARGE_CODE'.newValue)
						}
					}
				}
		]}
	]
	});
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:0,
		border:true,
		items: [{   xtype:'displayfield',
					hideLabel:true,
					value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[조회]</div>',
					width:50
				},
				{
					fieldLabel: '전표일',
					xtype: 'uniDatefield',
					name: 'AC_DATE',
					labelWidth:60,
					width:245,
					value: UniDate.get('today'),
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('AC_DATE', newValue);
						}
					}
				},{
					fieldLabel: '전표번호',
					xtype: 'uniNumberfield',
					name: 'EX_NUM',
					allowBlank:false,
					value:1,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('EX_NUM', newValue);
						}
					}
				},
				{
					fieldLabel: '회계부서구분',
					name: 'CHARGE_DIVI' ,
					value :gsChargeDivi,
					hidden:true
				},
				{
					fieldLabel:'결의부서',
					name : 'IN_DEPT_CODE',
					allowBlank:false,
					//value:UserInfo.deptCode,
					value:baseInfo.gsDeptCode,
					width:160,
					hidden:true,
					listeners:{
						change:function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('IN_DEPT_CODE'.newValue)
						}
					}
				},
				{
					fieldLabel:'입력자',
					name : 'CHARGE_CODE',
					allowBlank:false,
					value:'${chargeCode}',
					width:160,
					hidden:true,
					listeners:{
						change:function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('CHARGE_CODE'.newValue)
						}
					}
				}
		]
	});
	//createSearchForm
	var slipForm =  Unilite.createSearchForm('agj110ukrSlipForm',  {
		itemId: 'agj110ukrSlipForm',
		masterGrid: masterGrid1,
		height: 60,
		disabled: false,
		trackResetOnLoad:false,
		border: true,
		padding: 0,
		layout: {
			type: 'uniTable', 
			columns:4
		},
		defaults:{
			width: 246,
			labelWidth: 90
		},
		items:[{	xtype:'displayfield',
					hideLabel:true,
					value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[입력]</div>',
					width:50
				},
				{
					fieldLabel: '사업장',
					name: 'IN_DIV_CODE',
					labelWidth:60,
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					value:UserInfo.divCode,
					allowBlank:false
				},{
					xtype:'container',
					defaultType:'uniTextfield',
					layout:{type:'hbox', align:'stretch'},
					items:[
						{
							fieldLabel:'결의부서',
							name : 'IN_DEPT_CODE',
							allowBlank:false,
							readOnly:true,
							//value:UserInfo.deptCode,
							value:baseInfo.gsDeptCode,
							width:160
						 /*   listeners:{
								change:function(field, newValue, oldValue, eOpts) {
									panelSearch.setValue('DEPT_CODE'.newValue)
								}
							}*/
						},{
							fieldLabel: '결의부서명',
							name:'IN_DEPT_NAME',
							allowBlank:false,
							readOnly:true,
							//value: UserInfo.deptName,
							value: baseInfo.gsDeptName,
							hideLabel:true,
							width:85
					   /*	 listeners:{
								change:function(field, newValue, oldValue, eOpts) {
									panelSearch.setValue('DEPT_NAME'.newValue)
								}
							}*/
						}
					]
				},Unilite.popup('ACCNT_PRSN', {
					fieldLabel: '입력자ID',
					valueFieldName:'CHARGE_CODE',
					textFieldName:'CHARGE_NAME',
					allowBlank:false,
					labelWidth:88,
					textFieldWidth:150,
					readOnly:true
				}),{
					xtype:'displayfield',
					hideLable:true,
					value:'<div style="color:blue;font-weight:bold;padding-left:5px;">&nbsp;</div>',
					width:50,
					tdAttrs:{width:50}
				},{	 
					fieldLabel: '전표일',
					xtype: 'uniDatefield',
					labelWidth:60,
					name: 'AC_DATE',
					value: UniDate.get('today'),
					allowBlank:false,
					listeners:{
						change:function(field, newValue, oldValue) {
							
							var value = field.getValue();
							var exNum = slipForm.getValue("EX_NUM");
							var sDay = Ext.Date.format(value, 'd').toString();
							//날짜와 전표 번호 생성
							if(!Ext.isEmpty(newValue) &&Ext.isDate(newValue)) {
								panelSearch.setValue('AC_DATE',newValue);
								panelResult.setValue('AC_DATE',newValue);
							
								Ext.getBody().unmask();
								agj100ukrService.getSlipNum({'EX_DATE':UniDate.getDbDateStr(newValue)}, function(provider, result ) {
									slipForm.setValue("EX_NUM", provider.SLIP_NUM);
									var data = directMasterStore1.getData();
									Ext.each(data.items, function(item, idx){
										item.set("AC_DATE", value);
										item.set("AC_DAY", sDay);
										if(item.phantom ) {
											item.set('OLD_SLIP_NUM', provider.SLIP_NUM);
										}
									});
									var pendData = detailStore.getData();
									Ext.each(pendData.items, function(item, idx){
										item.set("J_EX_DATE", value);
										item.set('J_EX_NUM', provider.SLIP_NUM);
									});
									Ext.getBody().unmask();
								});
							}
						}
					}
				},{	 
					fieldLabel: '전표번호',
					xtype: 'uniNumberfield',
					name: 'EX_NUM',
					allowBlank:false,
					value:'1',
					listeners:{
						change:function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('EX_NUM',newValue);
							panelResult.setValue('EX_NUM',newValue);
							var value = newValue;
							var sDate = UniDate.getDbDateStr(slipForm.getValue("AC_DATE"));
							if(!Ext.isEmpty(value) && Ext.isDate(slipForm.getValue("AC_DATE"))) {
								Ext.getBody().mask();
								
								agj100ukrService.getSlipNum({'EX_DATE':sDate}, function(provider, result ) {
									slipForm.setValue("EX_NUM", provider.SLIP_NUM); 
									panelSearch.setValue('EX_NUM',provider.SLIP_NUM);
									panelResult.setValue('EX_NUM',provider.SLIP_NUM);
									var data = directMasterStore1.getData();
									Ext.each(data.items, function(item, idx){
										
										item.set("SLIP_NUM", provider.SLIP_NUM)
										if(item.phantom ) {
											item.set('OLD_SLIP_NUM', provider.SLIP_NUM);
										}
									});
									
									var pendData = detailStore.getData();
									Ext.each(pendData.items, function(item, idx){
										item.set('J_EX_NUM', provider.SLIP_NUM);
									});
									
									Ext.getBody().unmask();
								});
									
							}
						}
					}
				},{
					fieldLabel: '전표구분',
					name: 'SLIP_DIVI' ,
					/*xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'A002' ,
					labelWidth:88,
					allowBlank: false,*/
					value :'3',
					hidden:true,
					disabled: true
				},
				{
					fieldLabel: '회계부서구분',
					name: 'CHARGE_DIVI' ,
					value :gsChargeDivi,
					hidden:true
				},
				{
					fieldLabel: '승인여부',
					name: 'AP_STS' ,
					hidden:true
				}
				
		]
	});
	
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
			}else {
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
	/**
	 * 일발전표 Master Grid 정의(Grid Panel)
	 * @type 
	 */
	//var masterGridTmp = Unilite.createGrid('agj110ukrGridTmp', getGridConfig(directMasterStore1,'agj110ukrGridTmp','agj110ukrDetailFormTmp', 0.6, false, '2'));

	var masterGrid1 = Unilite.createGrid('agj110ukrGrid1', {
			layout : 'fit',
			flex:.6,
			uniOpt:{
				copiedRow:true,
				useContextMenu:false,
				expandLastColumn: false,
				useMultipleSorting: false,
				useNavigationModel:false,
				dblClickToEdit:true,
				//20210615 추가
				nonTextSelectedColumns:['REMARK']
			},
			itemId:'agj110ukrGrid1',
			enableColumnHide :false,
			sortableColumns : false,
			border:true,
			tbar:[
				'->',
				{
					xtype:'button',
					text:'외화환차손익',
					handler:function() {
						var grid = Ext.getCmp('agj110ukrGrid1');
						var form = Ext.getCmp('agj110ukrDetailForm1');
						addExchangeAccnt(grid, form, directMasterStore1, directMasterStore2, slipForm);
					}
				},{
					xtype:'button',
					text:'전표출력',
					handler:function() {
						var grid = Ext.getCmp('agj110ukrGrid1');
						var selRecord = grid.getSelectedRecord();
						if (pendGrid.store.data.length == 0) {
							var pendGridFlag = false;
							
						} else {
							var pendGridFlag = true;
						}
						openPrint(selRecord, '', pendGridFlag);
					}
				}/*, //20161220 분개장출력 버튼 삭제
				{
					xtype:'button',
					text:'분개장출력',
					handler:function() {
						
					}
				}
				*/
				,{
					xtype:'button',
					text :'전체 데이터 보기',
					
					handler:function() {
						openTempGridWin();
					}
				}
			],
			store: directMasterStore2,
			columns:[
			//   { dataIndex: 'AC_DAY'		  ,width: 45 , align:'center' }
			//  ,{ dataIndex: 'AC_DATE'		 ,width: 45 , align:'center' }
			//  ,{ dataIndex: 'SLIP_NUM'		,width: 55 , align:'center' }
			//  ,{ dataIndex: 'EX_DATE'		 ,width: 45 , align:'center' }
			//  ,{ dataIndex: 'EX_NUM'		  ,width: 45 , align:'center' },
			//	{dataIndex: 'CLOSE_FG'		  ,width: 45 },
				{ dataIndex: 'SLIP_SEQ'	 ,width: 45 , align:'center'}
				,{ dataIndex: 'DR_CR'		   ,width: 80 } 
				,{ dataIndex: 'SLIP_DIVI'	   ,width: 80 ,hidden:true} 
				,{ dataIndex: 'ACCNT'		   ,width: 100 ,
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						textFieldName:'ACCNT',
						DBtextFieldName: 'ACCNT_CODE',
						listeners:{
							scope:this,
							onSelected:function(records, type ) {
								var aGridID = 'agj110ukrGrid1', aDetailFormID='agj110ukrDetailForm1';
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								grid.uniOpt.currentRecord.set('ACCNT', records[0].ACCNT_CODE);
								grid.uniOpt.currentRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
								//UniAppManager.app.setAccntInfo(grid.uniOpt.currentRecord, form )
								
								UniAppManager.app.loadDataAccntInfo(grid.uniOpt.currentRecord, form, records[0])
							},
							onClear:function(type) {
								var aGridID = 'agj110ukrGrid1', aDetailFormID='agj110ukrDetailForm1';
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								UniAppManager.app.clearAccntInfo(grid.uniOpt.currentRecord, form);
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'RDO': '3',
										'TXT_SEARCH': popup.textField.getValue(),
										'CHARGE_CODE':slipForm.getValue('CHARGE_CODE'),
										'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
									}
									popup.setExtParam(param);
								}
							}
						}
						
					})
				} 
				,{ dataIndex: 'ACCNT_NAME'	  ,width: 140,
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						listeners:{
							scope:this,
							onSelected:function(records, type ) {
								var aGridID = 'agj110ukrGrid1', aDetailFormID='agj110ukrDetailForm1';
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								grid.uniOpt.currentRecord.set('ACCNT', records[0].ACCNT_CODE);
								grid.uniOpt.currentRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
								//UniAppManager.app.setAccntInfo(grid.uniOpt.currentRecord, form)
								UniAppManager.app.loadDataAccntInfo(grid.uniOpt.currentRecord, form, records[0]);
							},
							onClear:function(type) {
								var aGridID = 'agj110ukrGrid1', aDetailFormID='agj110ukrDetailForm1';
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								UniAppManager.app.clearAccntInfo(grid.uniOpt.currentRecord, form);
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
							
								var param = {
									'RDO': '4',
									'TXT_SEARCH': popup.textField.getValue(),
									'CHARGE_CODE':slipForm.getValue('CHARGE_CODE'),
									'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
								}
								popup.setExtParam(param);
								}
							}
						}
						
					})} 
				,{ dataIndex: 'CUSTOM_CODE'	 ,width: 80,
					'editor' : Unilite.popup('CUST_G',{
						textFieldName:'CUSTOM_CODE',
						DBtextFieldName:'CUSTOM_CODE',
						autoPopup: true,
						extParam:{"CUSTOM_TYPE":['1','2','3']},
						listeners: {
							'onSelected':  function(records, type  ){
									var aGridID = 'agj110ukrGrid1', aDetailFormID='agj110ukrDetailForm1';
									var grid = Ext.getCmp(aGridID);
									var form = Ext.getCmp(aDetailFormID);
									var grdRecord = grid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									for(var i=1 ; i <= 6 ; i++) {
										if(grdRecord.get("AC_CODE"+i.toString()) == 'A4') {
											grdRecord.set('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
											grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['CUSTOM_NAME']);
										}else if(grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
											grdRecord.set('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
											grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['BOOK_NAME']);
										}
									}
									form.setActiveRecord(grdRecord);
							},
							'onClear':  function( type  ){
									var aGridID = 'agj110ukrGrid1', aDetailFormID='agj110ukrDetailForm1';
									var grid = Ext.getCmp(aGridID);
									var form = Ext.getCmp(aDetailFormID);
									var grdRecord = grid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_NAME','');
									grdRecord.set('CUSTOM_CODE','');
									for(var i=1 ; i <= 6 ; i++) {
										if(grdRecord.get("AC_CODE"+i.toString()) == 'A4' || grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
											grdRecord.set('AC_DATA'+i.toString()		,'');
											grdRecord.set('AC_DATA_NAME'+i.toString()   ,'');
										}
									}
									form.setActiveRecord(grdRecord);
							}
						} // listeners
					})	  
				 } 
				,{ dataIndex: 'CUSTOM_NAME'	 ,width: 140 ,
					'editor' : (baseInfo.customCodeAutoPopup	)	?  Unilite.popup('CUST_G',{ 
						textFieldName:'CUSTOM_NAME',
						validateBlank:false,
						autoPopup: true,
						extParam:{"CUSTOM_TYPE":['1','2','3']},
						listeners: {
							'onSelected':  function(records, type  ){
									var aGridID = 'agj110ukrGrid1', aDetailFormID='agj110ukrDetailForm1';
									var grid = Ext.getCmp(aGridID);
									var form = Ext.getCmp(aDetailFormID);
									
									var grdRecord = grid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									for(var i=1 ; i <= 6 ; i++) {
										if(grdRecord.get("AC_CODE"+i.toString()) == 'A4') {
											grdRecord.set('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
											grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['CUSTOM_NAME']);
										}else if(grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
											grdRecord.set('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
											grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['BOOK_NAME']);
										}
									}
									form.setActiveRecord(grdRecord);
							},
							'onClear':  function( type  ){
									var aGridID = 'agj110ukrGrid1', aDetailFormID='agj110ukrDetailForm1';
									var grid = Ext.getCmp(aGridID);
									var form = Ext.getCmp(aDetailFormID);
									
									var grdRecord = grid.uniOpt.currentRecord;
									grdRecord.set('CUSTOM_CODE','');
									for(var i=1 ; i <= 6 ; i++) {
										if(grdRecord.get("AC_CODE"+i.toString()) == 'A4' || grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
											grdRecord.set('AC_DATA'+i.toString()		,'');
											grdRecord.set('AC_DATA_NAME'+i.toString()   ,'');
										}
									}
									form.setActiveRecord(grdRecord);
							}
						} // listeners
					}) : {xtype : 'textfield' }
				 } 
				,{ dataIndex: 'MONEY_UNIT'		,width: 100, hidden:true}
				,{ dataIndex: 'EXCHG_RATE_O'		,width: 100, hidden:true}
				,{ dataIndex: 'FOR_AMT_I'		,width: 100, hidden:true}
				,{ dataIndex: 'DR_AMT_I'		,width: 100}
				,{ dataIndex: 'CR_AMT_I'		,width: 100} 
				,{ dataIndex: 'REMARK'		  ,width: 200 ,
//					renderer:function(value, metaData, record) {
//						var r = value;
//						if(record.get('POSTIT_YN') == 'Y') r ='<img src="'+CPATH+'/resources/images/PostIt.gif"/>'+value
//						return r;
//					},
					editor:Unilite.popup('REMARK_G',{
										textFieldName:'REMARK',
										validateBlank:false,
					  					//autoPopup: true,
										listeners:{
											'onSelected':function(records, type) {
												var aGridID = 'agj110ukrGrid1';
												var grid = Ext.getCmp(aGridID);
												var selectedRec = grid.getSelectedRecord();// masterGrid1.uniOpt.currentRecord;
												selectedRec.set('REMARK', records[0].REMARK_NAME);
												
											},
											'onClear':function(type) {
												var aGridID = 'agj110ukrGrid1';
												var grid = Ext.getCmp(aGridID);
												var selectedRec = grid.getSelectedRecord();
												//selectedRec.set('REMARK', '');
											}
											
										}
										
									})
				} 
				
				,{ dataIndex: 'SPEC_DIVI'   ,width: 110 , hidden:true}
				,{ dataIndex: 'PROOF_KIND'  ,width: 110 
				  ,editor:{
						xtype:'uniCombobox',
						store:Ext.data.StoreManager.lookup('CBS_AU_A022'),
						listeners:{
							
							beforequery:function(queryPlan, value) {
								var aGridID = 'agj110ukrGrid1';
								var grid = Ext.getCmp(aGridID);
								
								this.store.clearFilter();
								if(grid.uniOpt.currentRecord.get('SPEC_DIVI') == 'F1') {
									this.store.filterBy(function(record){return record.get('refCode3') == '1'},this)
								}else if(grid.uniOpt.currentRecord.get('SPEC_DIVI') == 'F2') {
									this.store.filterBy(function(record){return record.get('refCode3') == '2'},this)
								}
							}
						}
					}
				} 
				,{ dataIndex: 'CREDIT_NUM'	  	 ,width: 150 , hidden:true}
				,{ dataIndex: 'CREDIT_NUM_EXPOS'	 ,width: 150 , hidden:true}
				,{ dataIndex: 'CREDIT_NUM_MASK'	  ,width: 150 }
				,{ dataIndex: 'DEPT_NAME'	   ,width: 100 ,
				   editor:Unilite.popup('DEPT_G',{
									showValue:false,
									extParam:{'TXT_SEARCH':'', 'isClearSearchTxt':baseInfo.inDeptCodeBlankYN == 'Y' ? true : false},
					  				autoPopup: true,
									listeners:{
										'onSelected':function(records, type) {
											var aGridID = 'agj110ukrGrid1';
											var grid = Ext.getCmp(aGridID);
											var selectedRec = grid.uniOpt.currentRecord;
											selectedRec.set('DEPT_NAME', records[0].TREE_NAME);
											selectedRec.set('DEPT_CODE', records[0].TREE_CODE);
											selectedRec.set('DIV_CODE', records[0].DIV_CODE);
											selectedRec.set('BILL_DIV_CODE', records[0].BILL_DIV_CODE);
											
										},
										'onClear':function(type) {
											var aGridID = 'agj110ukrGrid1';
											var grid = Ext.getCmp(aGridID);
											var selectedRec = grid.uniOpt.currentRecord;
											selectedRec.set('DEPT_NAME', '');
											selectedRec.set('DEPT_CODE', '');
											selectedRec.set('DIV_CODE', '');
											selectedRec.set('BILL_DIV_CODE', '');
										}
										
									}
									
								})
				 } 
//			   ,{ dataIndex: 'EXCHG_RATE_O'	   ,width:80}
//			   ,{ dataIndex: 'OPR_FLAG'	   ,width:80} 
//			   ,{ dataIndex: 'CHARGE_CODE'		,width:80} 
//			   ,{ dataIndex: 'AP_DATE'		,width:80} 
//			   ,{ dataIndex: 'SPEC_DIVI'	   ,width:80} 
//			   ,{ dataIndex: 'REASON_CODE'	 ,width:80} 
//			   ,{ dataIndex: 'CREDIT_CODE'	 ,width:80}
//			   ,{ dataIndex: 'CASH_NUM'		,width:80} 
//			   ,{ dataIndex: 'AC_DATA1'		,width:80} 
//			   ,{ dataIndex: 'AC_DATA2'	,width:80} 
//			   ,{ dataIndex: 'AC_DATA3'	,width:80}
//			   ,{ dataIndex:  'AC_DATA4'   ,width:80} 
//			   ,{ dataIndex:  'AC_DATA5'   ,width:80}
//			   ,{ dataIndex:  'AC_DATA6'   ,width:80}
//			   ,{ dataIndex: 'OLD_AC_DATE'		,width:80} 
//			   ,{ dataIndex: 'OLD_SLIP_NUM'	   ,width:80} 
				,{ dataIndex: 'DIV_CODE'		,flex: 1 , minWidth:60}
			  ] ,
			listeners:{
				render:function(grid, eOpt) {
					grid.getEl().on('click', function(e, t, eOpt) {
						activeGrid = grid.getItemId();
						clickedGrid = grid.getItemId();
					});
					var b = false;
					
					var i=0;
					if(b) {
						i=0;
					}
					var tbar = grid._getToolBar();
					if(b) {
						tbar[0].insert(i++,{
								xtype: 'uniBaseButton',
								iconCls: 'icon-getauto',
								width: 26, height: 26,
								tooltip:'자동분개 불러오기',
								handler:function() {
									masterGrid1.getStore().clearFilter();
									//openPostIt();
								}
						});
						tbar[0].insert(i++,{
								xtype: 'uniBaseButton',
								iconCls: 'icon-saveauto',
								width: 26, height: 26,
								tooltip:'자동분개 등록하기',
								handler:function() {
									//openPostIt();
								}
						});
					}
					
					tbar[0].insert(i++,{
							xtype: 'uniBaseButton',
							iconCls: 'icon-saveRemark',
							width: 26, height: 26,
							tooltip:'적요 등록하기',
							handler:function() {
								//openPostIt();
							}
					});tbar[0].insert(i++,{
							xtype: 'uniBaseButton',
							iconCls: 'icon-postit',
							width: 26, height: 26,
							tooltip:'각주',
							handler:function() {
								openPostIt(grid);
							}
					});
					tbar[0].insert(i++,{
						xtype: 'uniBaseButton',
						iconCls: 'icon-foreignAmt',
						width: 26, height: 26,
						tooltip:'외화금액표시',
						handler:function() {
							 var grid = this.up('uniGridPanel');
							 if(grid) {
								 var forAmtIColumn = grid.getColumn('FOR_AMT_I');
								 var exchangeRateOColumn = grid.getColumn('EXCHG_RATE_O');
								 var moneyUnitColumn = grid.getColumn('MONEY_UNIT');
								 if(forAmtIColumn) {
									if( forAmtIColumn.isVisible()) {
										forAmtIColumn.hide();
										exchangeRateOColumn.hide();
										moneyUnitColumn.hide();
									} else {
										forAmtIColumn.show();
										exchangeRateOColumn.show();
										moneyUnitColumn.show();
									}
								 }
							 }
						}
				});
				},
				selectionChange: function( grid, selected, eOpts ) {
					if(selected.length == 1) {
						gsDraftYN   = selected[0].get('DRAFT_YN');
						gsInputDivi = selected[0].get('INPUT_DIVI');
						
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
						var aDetailFormID='agj110ukrDetailForm1';
						var form = Ext.getCmp(aDetailFormID);
						var selectedRecord = Ext.isEmpty(selected)?null:selected[0];
						var prevRecord, store = grid.getStore();
						selectedIdx = store.indexOf(selectedRecord)
						if(selectedIdx >0) prevRecord = store.getAt(selectedIdx-1);
						
						UniAccnt.addMadeFields(form, dataMap, form, '', Ext.isEmpty(selected)?null:selected[0], prevRecord);
						if(selected && selected.length == 1) {
							form.setActiveRecord(selected[0]);
						}
										
						
						//spec_divi = 'F1', 'F2' 인 경우 관리항목으로 focus 이동해야 하므로 wasSpecDiviFocus 값 초기화
						wasSpecDiviFocus = false;
					}			   
				},
				beforeedit:function( editor, context, eOpts ) {
					
					if(context.field == "CR_AMT_I" && context.record.get("DR_CR") == '1') {
						return false;
					}else if(context.field == "CR_AMT_I" && context.record.get("FOR_YN") == "Y") {
						if(context.record.get("CR_AMT_I") == 0) {
							openForeignCur(context.record, "CR_AMT_I");
							return false;
						}
						
					}
					
					if(context.field == "DR_AMT_I" && context.record.get("DR_CR") == '2') {
						return false;
					}else if(context.field == "DR_AMT_I" && context.record.get("FOR_YN") == "Y") {
						if(context.record.get("DR_AMT_I") == 0) {
							openForeignCur(context.record, "DR_AMT_I");
							return false;
						}
						
					}
					
					if(context.field == "PROOF_KIND" && !(context.record.get("SPEC_DIVI") == 'F1' || context.record.get("SPEC_DIVI") == 'F2')) {
						return false;
					}
					
					if(context.record.get('AP_STS') == '2' ) {
						return false;
					}
					if(context.record.get("FOR_YN") !="Y") {
						if(context.field == "MONEY_UNIT" || context.field =='EXCHG_RATE_O' || context.field =='FOR_AMT_I') {
							return false;
						}
					}
					return true;
				},
				celldblclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
					if(e.position.column.dataIndex=='CREDIT_NUM') {
						UniAppManager.app.fnProofKindPopUp(record, null, 'agj110ukrGrid1');
						//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM'), "CREDIT_NUM", null, null, null, null,  'VALUE');
					}
					if(e.position.column.dataIndex=='PROOF_KIND') {
						UniAppManager.app.fnProofKindPopUp(record, null, 'agj110ukrGrid1');
					}		   
					
					if(e.position.column.dataIndex== "CR_AMT_I" && record.get("DR_CR") == '2' && record.get("FOR_YN") == "Y") {
						openForeignCur(record, "CR_AMT_I");
					}
					
					if(e.position.column.dataIndex== "DR_AMT_I" && record.get("DR_CR") == '1'  && record.get("FOR_YN") == "Y") {
						openForeignCur(record, "DR_AMT_I");
					}
				},
				cellkeydown:function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
					//pause key(19) 입력시 금액 자동 계산
					this.suspendEvent();
					var keyCode = e.getKey();
					var colName = e.position.column.dataIndex;
					//PAUSE key
					if(keyCode == 19 && (colName == 'CR_AMT_I' || colName == 'DR_AMT_I' ) ) {
						var dataStore = directMasterStore2;
						if(record.get("DR_CR") == '1') {
							var amtI = slipStore1.sum('AMT_I') + slipStore2.sum('AMT_I') - slipStore1.sum('AMT_I');
							record.set(colName, amtI);
							record.set('AMT_I', amtI);
							dataStore.slipGridChange(dataStore.getData().items);
						}else if(record.get("DR_CR") == '2'){
							var amtI = slipStore2.sum('AMT_I') + slipStore1.sum('AMT_I') - slipStore2.sum('AMT_I');
							record.set(colName, amtI);
							record.set('AMT_I', amtI);
							dataStore.slipGridChange(dataStore.getData().items);
						}
					}
					if(keyCode == 13) {
						enterNavigation(e);
					}
					if(keyCode == e.F8 && colName == 'CREDIT_NUM') {
						UniAppManager.app.fnProofKindPopUp(record, null, 'agj110ukrGrid1');
					}
					if((keyCode == e.F8 || keyCode == 13) && e.position.column.dataIndex== "CR_AMT_I" && record.get("DR_CR") == '2' && record.get("FOR_YN") == "Y") {
						openForeignCur(record, "CR_AMT_I");
					}
					
					if((keyCode == e.F8 || keyCode == 13) && e.position.column.dataIndex== "DR_AMT_I" && record.get("DR_CR") == '1'  && record.get("FOR_YN") == "Y") {
						openForeignCur(record, "DR_AMT_I");
					}
				}
			}
		});

	var detailForm1 = Unilite.createForm('agj110ukrDetailForm1',  getAcFormConfig('agj110ukrDetailForm1',masterGrid1 ));
 // var detailFormTmp = Unilite.createForm('agj110ukrDetailFormTmp',  getAcFormConfig('agj110ukrDetailFormTmp',masterGridTmp ));

	var pendGrid = Unilite.createGrid('agj110ukrPendGrid', {
		// for tab	  
		layout : 'fit',
		minHeight :100,
		store: detailStore,
		
		viewConfig:{
			itemId:'agj110ukrPendGrid'
		},
		uniOpt:{
			useMultipleSorting  : true,
			useLiveSearch	    : false,
			onLoadSelectFirst   : true,
			dblClickToEdit	    : true,
			useGroupSummary	    : false,
			useContextMenu	    : false,
			useRowNumberer	    : true,	 
			expandLastColumn	: true,
			useRowContext	    : false,
			nonTextSelectedColumns:['REMARK'],
			filter: {
				useFilter	   : false,
				autoCreate	  : false
			},
			userToolbar :false
		},
		columns:  [
//			{ dataIndex: 'J_EX_DATE'			  , width: 80},
//			{ dataIndex: 'J_EX_NUM'			   , width: 80 },
//			
//			{ dataIndex: 'OLD_AC_DATE'			  , width: 80},
//			{ dataIndex: 'OLD_SLIP_NUM'			   , width: 80 },
//			{ dataIndex: 'OLD_SLIP_SEQ'			  , width: 80},
//			{ dataIndex: 'SEQ'				, width: 80},
//			
//			{ dataIndex: 'OPR_FLAG'			 , width: 80},
			{ dataIndex: 'J_EX_SEQ'			 , width: 45 , align:'center'},
			{ dataIndex: 'DR_CR'				, width: 80 },
			{ dataIndex: 'ACCNT'				, width: 100 },
			{ dataIndex: 'ACCNT_NAME'		   , width: 140 },
			{ dataIndex: 'ORG_AC_DATE'		  , width: 80 },
			{ dataIndex: 'ORG_SLIP_NUM'		 , width: 45 , align:'center' },
			{ dataIndex: 'ORG_SLIP_SEQ'		 , width: 45 , align:'center'},
			{ dataIndex: 'PEND_NAME'			, width: 100 },
			{ dataIndex: 'PEND_DATA_CODE'	   , width: 100 },
			{ dataIndex: 'PEND_DATA_NAME'	   , width: 120 },
			{ dataIndex: 'J_AMT_I'			  , width: 130 },
			{ dataIndex: 'FOR_J_AMT_I'		  , width: 130 },
			
			{ dataIndex: 'EXCHG_RATE_O'		 , width: 80 },
			{ dataIndex: 'MONEY_UNIT'		   , width: 100 },
			{ dataIndex: 'REMARK'			   , width: 120},
//			  { dataIndex: 'FOR_BLN_I'			, width: 100 },
//			  { dataIndex: 'BLN_I'				, width: 100 },
			{ dataIndex: 'DEPT_NAME'			, width: 100 },
		   //   { dataIndex: 'DR_CR'			, width: 100 },
			{ dataIndex: 'DIV_CODE'			 , flex: 1, minWidth:80 }
		] ,
		listeners:{
			beforeedit:function(editor, context, eOpts) {
				if(context.record.get('AP_STS') == '2' && context.field != "REMARK") {
						return false;
				}
				if(context.field == "J_AMT_I" || context.field == "REMARK") {
					return true;
				}
				if(context.field == "FOR_J_AMT_I" && context.record.get('MONEY_UNIT') != UserInfo.currency) {
					return true;
				}
				return false;
			},
			containerclick:function(view,  e , eOpts) {
				activeGrid = 'agj110ukrPendGrid';
				clickedGrid = 'agj110ukrPendGrid';
			},
			itemclick:function ( view , record , item , index , e , eOpts ) {
				activeGrid = 'agj110ukrPendGrid';
				clickedGrid ='agj110ukrPendGrid';
			}
		}
	});
	
	var pendRefForm = Unilite.createSearchForm('agj110ukrPendRefForm',  {
		itemId: 'agj110ukrPendRefForm',
		height: 85,
		disabled: false,
		trackResetOnLoad:false,
		border: true,
		padding: 0,
		layout: {
			type: 'uniTable', 
			columns:4/*, tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/
		},
		defaults:{
			labelWidth: 90
		},
		items:[
			Unilite.popup('MANAGE',{
				valueFieldWidth : 80,
				textFieldWidth  : 140,
				tdAttrs		 : {width: 330},
//			  allowBlank	  : false,
				listeners	   : {
					onSelected: {
						fn: function(records, type) {
							/**
							 * 관리항목 팝업을 작동했을때의 동적 필드 생성 
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음
							 *			  필드			  
							 * valueFieldName	textFieldName  
							 * DYNAMIC_CODE_FR   DYNAMIC_NAME_FR 
							 * --------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음
							 *		필드				 
							 *  DYNAMIC_CODE_FR		  
							 **/
							var param = {AC_CD : pendRefForm.getValue('MANAGE_CODE')};
							accntCommonService.fnGetAcCode(param, function(provider, response) {
								var dataMap = provider;
								UniAccnt.changeOneField(pendRefForm, dataMap, null);
								
								pendGrid.getColumn('PEND_DATA_CODE').setText(provider.AC_NAME);
								pendGrid.getColumn('PEND_DATA_NAME').setText(provider.AC_NAME + '명');
								
								sPendCode  = provider.AC_NAME; 
								sPendName  = provider.AC_NAME + '명'; 
								
								pendRefForm.down('#conArea1').show();
								pendRefForm.down('#pendDataCode').hide();
								pendRefForm.down('#pendDataName').hide();
							});
						},
						scope: this
					},
					onClear: function(type) {
						pendRefForm.down('#conArea1').hide();
						pendRefForm.down('#pendDataCode').show();
						pendRefForm.down('#pendDataName').show();
						/** onClear시 removeField..
						 */
						UniAccnt.removeField(pendRefForm);
					},
					applyextparam: function(popup){
					}
				}
			}),{
				xtype	    : 'container',
				defaultType : 'uniTextfield',
				layout	    : {type:'hbox'  , align:'stretch'},
				items	    : [{
					fieldLabel  :' 미결항목',
					name		: 'PEND_DATA_CODE',
					itemId	    : 'pendDataCode',
					width	    : 170
				},{
					fieldLabel  : '미결항목명',
					name		: 'PEND_DATA_NAME',
					itemId	    : 'pendDataName',
					hideLabel   : true,
					width	    : 140
				},{
					xtype   : 'container',
					itemId  : 'conArea1',
					items   : [{
						xtype   : 'container',
						colspan : 1,
						itemId  : 'formFieldArea1',
						layout  : {
							type	: 'table', 
							columns : 1,
							itemCls :'table_td_in_uniTable',
							tdAttrs : {
								width: 350
							}
						}
					}]
				}
			]},Unilite.popup('ACCNT', {
				valueFieldWidth:80, textFieldWidth:140, autoPopup:true, colspan:2
			}),{
				fieldLabel: '원전표일',
				xtype: 'uniDateRangefield',
				startFieldName: 'AC_DATE_FR',
				endFieldName: 'AC_DATE_TO',
				startDate:  UniDate.get('startOfMonth'),
				endDate:  UniDate.get('today'),
				allowBlank:false
			},{
				fieldLabel  : '사업장',
				name		: 'DIV_CODE',
				xtype	    : 'uniCombobox',
				comboType   : 'BOR120',
				value	    : UserInfo.divCode,
				multiSelect : true,
				tdAttrs	    : {width: 330},
				width	    : 310
			},{
				xtype:'container',
				defaultType:'uniNumberfield',
				layout:{type:'hbox', align:'stretch'},
				items:[
					{
						fieldLabel  : '원화/외화금액',
						name		: 'AMT',
						type 		: 'uniPrice',
						readOnly	: true,
						width	    : 210
					},{
						//xtype	    : 'uniNumberfield',
						fieldLabel  : '외화금액',
						name		: 'FOR_AMT',
						//decimalPrecision:2,
						type : 'uniFC',
						hideLabel   : true,
						readOnly	: true,
						width	    : 110
					}
				]
			},{
				fieldLabel		: '결제예정일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PAYMENT_DAY_FR',
				endFieldName	: 'PAYMENT_DAY_TO'
			},Unilite.popup('ACCNT_PRSN', {
				fieldLabel: '입력자ID',
				valueFieldName:'CHARGE_CODE',
				textFieldName:'CHARGE_NAME',
				labelWidth:88,
				valueFieldWidth:80, textFieldWidth:140
			}),{
				fieldLabel: '적요',
				name: 'REMARK',
				width:310
			},
			Unilite.popup('DEPT',{
				fieldLabel: '입력부서',
				validateBlank:false,
				valueFieldName:'DEPT_CODE',
				textFieldName:'DEPT_NAME'
			})
		]
	});
	
	Unilite.defineModel('Agj110ukrPendRefModel', {
		fields: [
				 {name: 'ACCNT'					,text: '계정코드'			,type: 'string'},
				 {name: 'ACCNT_NAME'			,text: '계정과목명'			,type: 'string'},
				 {name: 'ORG_AC_DATE'			,text: '전표일'			,type: 'string'},
				 {name: 'ORG_SLIP_NUM'			,text: '번호'				,type: 'string'},
				 {name: 'ORG_SLIP_SEQ'			,text: '순번'				,type: 'int'},
				 {name: 'PEND_NAME'				,text: '미결항목코드'			,type: 'string'},
				 {name: 'PEND_YN'				,text: '미결항목여부'			,type: 'string'},
				 {name: 'PEND_DATA_CODE'		,text: '미결코드'			,type: 'string'},
				 {name: 'PEND_DATA_NAME'		,text: '미결항목명'			,type: 'string'},
				 {name: 'ORG_AMT_I'				,text: '발생금액'			,type: 'uniPrice'},
				 {name: 'BLN_I'					,text: '잔액'				,type: 'uniPrice'},
				 {name: 'EX_AMT_I'				,text: '결의금액'			,type: 'uniPrice'},
				 {name: 'J_AMT_I'				,text: '반제가능금액'			,type: 'uniPrice'},
				 {name: 'FOR_ORG_AMT_I'			,text: '외화발생금액'			,type: 'uniFC'},
				 {name: 'FOR_BLN_I'				,text: '외화잔액'				,type: 'uniFC'},
				 {name: 'FOR_EX_AMT_I'			,text: '외화결의금액'			,type: 'uniFC'},
				 {name: 'FOR_J_AMT_I'			,text: '외화반제가능금액'		,type: 'uniFC'},
				 {name: 'MONEY_UNIT'			,text: '화폐단위'			,type: 'string'},
				 {name: 'REMARK'				,text: '적요'				,type: 'string', editable:true},
				 {name: 'DEPT_NAME'				,text: '귀속부서'			,type: 'string'},
				 {name: 'DIV_NAME'				,text: '귀속사업장'			,type: 'string'},
				 
				 {name: 'ORG_DATA'				,text: ''				,type: 'string'},
				 {name: 'PEND_CODE'				,text: ''				,type: 'string'},
				 {name: 'INPUT_PATH'			,text: ''				,type: 'string'},
				 {name: 'EXCHG_RATE_O'			,text: '환율'				,type: 'uniER'},
				 {name: 'DEPT_CODE'				,text: ''				,type: 'string'},
				 {name: 'BILL_DIV_CODE'			,text: ''				,type: 'string'},
				 {name: 'DR_CR'					,text: ''				,type: 'string'},
				 {name: 'CUSTOM_CODE'			,text: ''				,type: 'string'},
				 {name: 'CUSTOM_NAME'			,text: ''				,type: 'string'},
				 
				 {name: 'ACCNT_SPEC'			,text: ''				,type: 'string'},
				 {name: 'SPEC_DIVI'				,text: ''				,type: 'string'},
				 {name: 'PROFIT_DIVI'			,text: ''				,type: 'string'},
				 {name: 'JAN_DIVI'				,text: ''				,type: 'string'},
				 {name: 'BUDG_YN'				,text: ''				,type: 'string'},
				 {name: 'BUDGCTL_YN'			,text: ''				,type: 'string'},
				 {name: 'FOR_YN'				,text: ''				,type: 'string'},
				 {name: 'DIV_CODE'				,text: '귀속사업장'			,type: 'string', comboType:'BOR120'},
				 
				
				 {name: 'AC_CODE1'				,text:'관리항목코드1'			,type : 'string'}
				,{name: 'AC_CODE2'				,text:'관리항목코드2'			,type : 'string'}
				,{name: 'AC_CODE3'				,text:'관리항목코드3'			,type : 'string'}
				,{name: 'AC_CODE4'				,text:'관리항목코드4'			,type : 'string'}
				,{name: 'AC_CODE5'				,text:'관리항목코드5'			,type : 'string'}
				,{name: 'AC_CODE6'				,text:'관리항목코드6'			,type : 'string'}
				
				,{name: 'AC_NAME1'				,text:'관리항목명1'			,type : 'string'}
				,{name: 'AC_NAME2'				,text:'관리항목명2'			,type : 'string'}
				,{name: 'AC_NAME3'				,text:'관리항목명3'			,type : 'string'}
				,{name: 'AC_NAME4'				,text:'관리항목명4'			,type : 'string'}
				,{name: 'AC_NAME5'				,text:'관리항목명5'			,type : 'string'}
				,{name: 'AC_NAME6'				,text:'관리항목명6'			,type : 'string'}
				
				,{name: 'AC_DATA1'				,text:'관리항목데이터1'		,type : 'string'}
				,{name: 'AC_DATA2'				,text:'관리항목데이터2'		,type : 'string'}
				,{name: 'AC_DATA3'				,text:'관리항목데이터3'		,type : 'string'}
				,{name: 'AC_DATA4'				,text:'관리항목데이터4'		,type : 'string'}
				,{name: 'AC_DATA5'				,text:'관리항목데이터5'		,type : 'string'}
				,{name: 'AC_DATA6'				,text:'관리항목데이터6'		,type : 'string'}
				
				,{name: 'AC_DATA_NAME1'			,text:'관리항목데이터명1'		,type : 'string'}
				,{name: 'AC_DATA_NAME2'			,text:'관리항목데이터명2'		,type : 'string'}
				,{name: 'AC_DATA_NAME3'			,text:'관리항목데이터명3'		,type : 'string'}
				,{name: 'AC_DATA_NAME4'			,text:'관리항목데이터명4'		,type : 'string'}
				,{name: 'AC_DATA_NAME5'			,text:'관리항목데이터명5'		,type : 'string'}
				,{name: 'AC_DATA_NAME6'			,text:'관리항목데이터명6'		,type : 'string'}
				,{name: 'AC_CTL1'				,text:'관리항목필수1'	 		,type : 'string'}
				,{name: 'AC_CTL2'				,text:'관리항목필수2'	 		,type : 'string'}
				,{name: 'AC_CTL3'				,text:'관리항목필수3'	 		,type : 'string'}
				,{name: 'AC_CTL4'				,text:'관리항목필수4'	 		,type : 'string'}
				,{name: 'AC_CTL5'				,text:'관리항목필수5'	 		,type : 'string'}
				,{name: 'AC_CTL6'				,text:'관리항목필수6'	 		,type : 'string'}
				
				,{name: 'BOOK_CODE1'			,text:''				,type : 'string'}
				,{name: 'BOOK_CODE2'			,text:''				,type : 'string'}
				,{name: 'BOOK_DATA1'			,text:''				,type : 'string'}
				,{name: 'BOOK_DATA2'			,text:''				,type : 'string'}
				,{name: 'BOOK_DATA_NAME1'		,text:''				,type : 'string'}
				,{name: 'BOOK_DATA_NAME2'		,text:''				,type : 'string'}
			
				,{name: 'AP_STS'				,text:''				,type : 'string'}
				,{name: 'AP_CHARGE_NAME'		,text:''				,type : 'string'}
				,{name: 'PAYMENT_DAY'			,text: '결제예정일'			,type: 'uniDate'}
				,{name: 'FLAG'					,text:''				,type : 'string', defaultValue:"R"}
			 ]
		});
	
	var pendRefStore = Unilite.createStore('Agj110ukrPendRefStore',{
			model: 'Agj110ukrPendRefModel',
			uniOpt : {
				isMaster:   false,		  // 상위 버튼 연결 
				editable:   false,		  // 수정 모드 사용 
				deletable:  false,		  // 삭제 가능 여부 
				useNavi :   false		   // prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {
					   read: 'agj110ukrService.selectPendRef'
				}
			},
			filters: [pendRefFilter ],
			loadStoreRecords : function() {
				var form = Ext.getCmp('agj110ukrPendRefForm');
				if(form.getInvalidMessage()) {
					var param= form.getValues();
					
					//param.CHAEGE_CODE = slipForm.getValue("CHAEGE_CODE");
					//param.DEPT_CODE = slipForm.getValue("DEPT_CODE");
					//param.CHAEGE_DIVI = gsChargeDivi;
					if(param) {
						console.log( param );
						this.load({
							params : param
						});
					}
				} else {
				
				}
			},
			listeners:{
				load:function(tore, records, index, eOpts) {
					var pendData = detailStore.getData();
					Ext.each(records,function(record, idx){
						if(!record.isModified()) {
							record.set("FLAG","R");
						}
						Ext.each(pendData.items,function(item, index){
							if(record.get('ORG_DATA') == item.get('ORG_DATA') ) {
								var sum = 0;
								var for_sum = 0;
								Ext.each(pendData.items,function(item2, index2){
									if(record.get('ORG_DATA') == item2.get('ORG_DATA') && item2.get('FLAG') == "N" ) {
										sum = sum + item2.get('J_AMT_I');
										for_sum = for_sum + item2.get('FOR_J_AMT_I');
									}
								});
								if(record.get("J_AMT_I") == sum && record.get("FOR_J_AMT_I") == for_sum) {
									record.set("FLAG","U");
								}else{
									record.set("J_AMT_I",	   record.get("BLN_I") - record.get("EX_AMT_I") - sum); //BLN_I EX_AMT_I	J_AMT_I
									record.set("FOR_J_AMT_I",   record.get("FOR_BLN_I") - record.get("FOR_EX_AMT_I") - for_sum);
									
								}
							}
						});
						
					})
				}
			}
	}); 
	var pendRefGrid = Unilite.createGrid('agj110ukrRefGrid', {
		// for tab	  
		store	   : pendRefStore,
		layout	  : 'fit',
		region	  : 'center',
		minHeight   : 100,
		uniOpt	  : {					 
			useMultipleSorting  : true,
			useLiveSearch	    : false,
			onLoadSelectFirst   : false,
			dblClickToEdit		: true,
			useGroupSummary	    : false,
			useContextMenu	    : false,
			useRowNumberer	    : true,	
			expandLastColumn	: true,
			useRowContext	    : false,
			filter: {
				useFilter	    : false,
				autoCreate	    : false
			},
			userToolbar :true
		},
		pendApply:function(gRec, sRec, slipSeq, isNew) {
			//if(isNew) {
			if(gRec.get("J_AMT_I") == 0 ) {
				return ;
			}
			//var maxSeq = Unilite.nvl(directMasterStore1.max("SLIP_SEQ"),0) ;
			sRec = pendGrid.createRow({'ORG_DATA'	   : gRec.get("ORG_DATA"),
										"ACCNT"		 : gRec.get("ACCNT"),
										"ACCNT_NAME"	: gRec.get("ACCNT_NAME"),
										"SLIP_SEQ"	  : slipSeq,
										
										"MONEY_UNIT"	: gRec.get("MONEY_UNIT"),
										"EXCHG_RATE_O"  : gRec.get("EXCHG_RATE_O"),
										"OLD_AC_DATE"   : slipForm.getValue("AC_DATE"),
										"OLD_SLIP_NUM"  : slipForm.getValue("EX_NUM"),
										"OLD_SLIP_SEQ"  : slipSeq,
//											"J_AC_DATE"	   : slipForm.getValue("AC_DATE"),
//											"J_SLIP_NUM"	  : slipForm.getValue("EX_NUM"),
//											"J_SLIP_SEQ"	  : slipSeq,
										"ACCNT"		 : gRec.get("ACCNT"),
										"ACCNT_NAME"	: gRec.get("ACCNT_NAME"),
										"P_ACCNT"	   :   "",
										"SEQ"		   : Unilite.nvl(detailStore.max("SEQ"),0)+1,
										"PEND_CODE"	 : gRec.get("PEND_CODE"),
										"PEND_NAME"	 : gRec.get("PEND_NAME"),
										"PEND_DATA_CODE": gRec.get("PEND_DATA_CODE"),
										"PEND_DATA_NAME": gRec.get("PEND_DATA_NAME"),
										"INPUT_PATH"	: "X1",
										"SLIP_SEQ"	  : slipSeq,
										"ORG_AC_DATE"   : gRec.get("ORG_AC_DATE").replace(/\./gi, ""),
										"ORG_SLIP_NUM"  : gRec.get("ORG_SLIP_NUM"),
										"ORG_SLIP_SEQ"  : gRec.get("ORG_SLIP_SEQ"),
										"MONEY_UNIT"	: gRec.get("MONEY_UNIT"),
										"EXCHG_RATE_O"  : gRec.get("EXCHG_RATE_O"),
										"FOR_BLN_I"	   : gRec.get("FOR_BLN_I"),
										"BLN_I"		   : gRec.get("BLN_I"),
										//"FOR_J_AMT_I" : gRec.get("FOR_J_AMT_I"),
										//"J_AMT_I"	 : gRec.get("J_AMT_I"),
										"DEPT_CODE"	 : gRec.get("DEPT_CODE"),
										"DEPT_NAME"	 : gRec.get("DEPT_NAME"),
										"BILL_DIV_CODE" : gRec.get("BILL_DIV_CODE"),
										"DIV_CODE"	  : gRec.get("DIV_CODE"),
										"J_EX_DATE"	 : slipForm.getValue("AC_DATE"),
										"J_EX_NUM"	  : slipForm.getValue("EX_NUM"),
										"J_EX_SEQ"	  : slipSeq, 
										"REMARK"		: gRec.get("REMARK"),
										"DR_CR"		 : gRec.get("DR_CR"),
										
										"CUSTOM_CODE"   : gRec.get("CUSTOM_CODE"),
										"CUSTOM_NAME"   : gRec.get("CUSTOM_NAME"),
										
										"ACCNT_SPEC"	: gRec.get("ACCNT_SPEC"),
										"SPEC_DIVI"	 : gRec.get("SPEC_DIVI"),
										"PROFIT_DIVI"   : gRec.get("PROFIT_DIVI"),
										"JAN_DIVI"	  : gRec.get("JAN_DIVI"),
										"PEND_YN"	   : gRec.get("PEND_YN"),
										"PEND_CODE"	 : gRec.get("PEND_CODE"),
										"PEND_DATA_CODE": gRec.get("PEND_DATA_CODE"),
										"BUDG_YN"	   : gRec.get("BUDG_YN"),
										"BUDGCTL_YN"	: gRec.get("BUDGCTL_YN"),
										"FOR_YN"		: gRec.get("FOR_YN"),
										
										"AC_CODE1"	  : gRec.get("AC_CODE1"),
										"AC_CODE2"	  : gRec.get("AC_CODE2"),
										"AC_CODE3"	  : gRec.get("AC_CODE3"),
										"AC_CODE4"	  : gRec.get("AC_CODE4"),
										"AC_CODE5"	  : gRec.get("AC_CODE5"),
										"AC_CODE6"	  : gRec.get("AC_CODE6"),
										
										"AC_DATA1"	  : gRec.get("AC_DATA1"),
										"AC_DATA2"	  : gRec.get("AC_DATA2"),
										"AC_DATA3"	  : gRec.get("AC_DATA3"),
										"AC_DATA4"	  : gRec.get("AC_DATA4"),
										"AC_DATA5"	  : gRec.get("AC_DATA5"),
										"AC_DATA6"	  : gRec.get("AC_DATA6"),
										
										"AC_DATA_NAME1" : gRec.get("AC_DATA_NAME1"),
										"AC_DATA_NAME2" : gRec.get("AC_DATA_NAME2"),
										"AC_DATA_NAME3" : gRec.get("AC_DATA_NAME3"),
										"AC_DATA_NAME4" : gRec.get("AC_DATA_NAME4"),
										"AC_DATA_NAME5" : gRec.get("AC_DATA_NAME5"),
										"AC_DATA_NAME6" : gRec.get("AC_DATA_NAME6"),
										
										"AC_CTL1"	   : gRec.get("AC_CTL1"),
										"AC_CTL2"	   : gRec.get("AC_CTL2"),
										"AC_CTL3"	   : gRec.get("AC_CTL3"),
										"AC_CTL4"	   : gRec.get("AC_CTL4"),
										"AC_CTL5"	   : gRec.get("AC_CTL5"),
										"AC_CTL6"	   : gRec.get("AC_CTL6"),
										
										"BOOK_CODE1"	: gRec.get("BOOK_CODE1"),
										"BOOK_CODE2"	: gRec.get("BOOK_CODE2"),   
										"BOOK_DATA1"	: gRec.get("BOOK_DATA1"),
										"BOOK_DATA2"	: gRec.get("BOOK_DATA2"),
										"BOOK_DATA_NAME1"	   : gRec.get("BOOK_DATA_NAME1"),
										"BOOK_DATA_NAME2"	   : gRec.get("BOOK_DATA_NAME2"),
										
										"INPUT_USER_ID" : UserInfo.userID,
										'INPUT_DIVI'	:'3',
										'OPR_FLAG'	  : 'N'
			});
				
			var lForBlnAmt  = Ext.isEmpty(sRec.get("FOR_BLN_I"))	? 0:sRec.get("FOR_BLN_I");
			var lBlnAmt	 = Ext.isEmpty(sRec.get("BLN_I"))		? 0:sRec.get("BLN_I");
			var lForJBlnAmt = Ext.isEmpty(sRec.get("FOR_J_AMT_I"))  ? 0:sRec.get("FOR_J_AMT_I");
			var lJBlnAmt	= Ext.isEmpty(sRec.get("J_AMT_I"))	  ? 0:sRec.get("J_AMT_I");
				
			sRec.set("J_EX_SEQ"			 , slipSeq);
			
			sRec.set("OLD_AC_DATE"		  , slipForm.getValue("AC_DATE"));
			sRec.set("OLD_SLIP_NUM"		 , slipForm.getValue("EX_NUM"));
			sRec.set("ACCNT"				, gRec.get("ACCNT"));
			sRec.set("ACCNT_NAME"		   , gRec.get("ACCNT_NAME"));
			sRec.set("P_ACCNT"			  ,   "")
			sRec.set("PEND_CODE"			, gRec.get("PEND_CODE"));
			sRec.set("PEND_NAME"			, gRec.get("PEND_NAME"));
			sRec.set("PEND_DATA_CODE"	   , gRec.get("PEND_DATA_CODE"));
			sRec.set("PEND_DATA_NAME"	   , gRec.get("PEND_DATA_NAME"));
			sRec.set("INPUT_PATH"		   , Ext.isEmpty(gsInputPath) ? "X1":gsInputPath);
			sRec.set("SLIP_SEQ"			 , slipSeq);
			sRec.set("ORG_AC_DATE"		  , gRec.get("ORG_AC_DATE").replace(/\./gi, ""));
			sRec.set("ORG_SLIP_NUM"		 , gRec.get("ORG_SLIP_NUM"));
			sRec.set("ORG_SLIP_SEQ"		 , gRec.get("ORG_SLIP_SEQ"));
			sRec.set("MONEY_UNIT"		   , gRec.get("MONEY_UNIT"));
			sRec.set("EXCHG_RATE_O"		 , gRec.get("EXCHG_RATE_O"));
			sRec.set("FOR_BLN_I"			, gRec.get("FOR_J_AMT_I")); //lForBlnAmt+ gRec.get("FOR_BLN_I"));
			sRec.set("BLN_I"				, gRec.get("J_AMT_I")); //lBlnAmt + gRec.get("BLN_I"));
			sRec.set("FOR_J_AMT_I"		  , lForJBlnAmt + gRec.get("FOR_J_AMT_I"));
			sRec.set("J_AMT_I"			  , lJBlnAmt + gRec.get("J_AMT_I"));
			sRec.set("DEPT_CODE"			, gRec.get("DEPT_CODE"));
			sRec.set("DEPT_NAME"			, gRec.get("DEPT_NAME"));
			sRec.set("BILL_DIV_CODE"		, gRec.get("BILL_DIV_CODE"));
			sRec.set("DIV_CODE"			 , gRec.get("DIV_CODE"));
			sRec.set("J_EX_DATE"			, slipForm.getValue("AC_DATE"));
			sRec.set("J_EX_NUM"			 , slipForm.getValue("EX_NUM"));
			sRec.set("REMARK"			   , gRec.get("REMARK"));
			sRec.set("DR_CR"				, gRec.get("DR_CR"));
			
			sRec.set("CUSTOM_CODE"		  , gRec.get("CUSTOM_CODE"));
			sRec.set("CUSTOM_NAME"		  , gRec.get("CUSTOM_NAME"));
			
			/*sRec.set("accnt_spec"		   , gRec.get("accnt_spec"));
			sRec.set("spec_divi"			, gRec.get("spec_divi"));
			sRec.set("profit_divi"		  , gRec.get("profit_divi"));
			sRec.set("jan_divi"			 , gRec.get("jan_divi"));
			sRec.set("budg_yn"			  , gRec.get("budg_yn"));
			sRec.set("budgctl_yn"		   , gRec.get("budgctl_yn"));
			sRec.set("for_yn"			   , gRec.get("for_yn"));
			*/
			sRec.set("AC_CODE1"			 , gRec.get("AC_CODE1"));
			sRec.set("AC_CODE2"			 , gRec.get("AC_CODE2"));
			sRec.set("AC_CODE3"			 , gRec.get("AC_CODE3"));
			sRec.set("AC_CODE4"			 , gRec.get("AC_CODE4"));
			sRec.set("AC_CODE5"			 , gRec.get("AC_CODE5"));
			sRec.set("AC_CODE6"			 , gRec.get("AC_CODE6"));
			
			sRec.set("AC_DATA1"			 , gRec.get("AC_DATA1"));
			sRec.set("AC_DATA2"			 , gRec.get("AC_DATA2"));
			sRec.set("AC_DATA3"			 , gRec.get("AC_DATA3"));
			sRec.set("AC_DATA4"			 , gRec.get("AC_DATA4"));
			sRec.set("AC_DATA5"			 , gRec.get("AC_DATA5"));
			sRec.set("AC_DATA6"			 , gRec.get("AC_DATA6"));
			
			sRec.set("AC_DATA_NAME1"		, gRec.get("AC_DATA_NAME1"));
			sRec.set("AC_DATA_NAME2"		, gRec.get("AC_DATA_NAME2"));
			sRec.set("AC_DATA_NAME3"		, gRec.get("AC_DATA_NAME3"));
			sRec.set("AC_DATA_NAME4"		, gRec.get("AC_DATA_NAME4"));
			sRec.set("AC_DATA_NAME5"		, gRec.get("AC_DATA_NAME5"));
			sRec.set("AC_DATA_NAME6"		, gRec.get("AC_DATA_NAME6"));
			
			sRec.set("AC_CTL1"			  , gRec.get("AC_CTL1"));
			sRec.set("AC_CTL2"			  , gRec.get("AC_CTL2"));
			sRec.set("AC_CTL3"			  , gRec.get("AC_CTL3"));
			sRec.set("AC_CTL4"			  , gRec.get("AC_CTL4"));
			sRec.set("AC_CTL5"			  , gRec.get("AC_CTL5"));
			sRec.set("AC_CTL6"			  , gRec.get("AC_CTL6"));
			
			sRec.set("BOOK_CODE1"		   , gRec.get("BOOK_CODE1"));
			sRec.set("BOOK_CODE2"		   , gRec.get("BOOK_CODE2"));
			sRec.set("BOOK_DATA1"		   , gRec.get("BOOK_DATA1"));
			sRec.set("BOOK_DATA2"		   , gRec.get("BOOK_DATA2"));
			sRec.set("BOOK_DATA_NAME1"	  , gRec.get("BOOK_DATA_NAME1"));
			sRec.set("BOOK_DATA_NAME2"	  , gRec.get("BOOK_DATA_NAME2"));
			if(sRec.phantom) {
				sRec.set("OPR_FLAG"	 , 'N');
				
			}else {
				sRec.set("OPR_FLAG"	 , 'U');
			}
			
			UniAppManager.app.fnSetAcCode(sRec, 'D1', (lForJBlnAmt + gRec.get("FOR_J_AMT_I")), null);
		},
		selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : true,showHeaderCheckbox :true }),
		tbar: [{
			text:'반제적용',
			align   : 'left',
			handler: function() {
				if(slipForm.getValue("AP_STS") !="2") {
					var selectedRecords = pendRefGrid.getSelectedRecords();
					var detailRecords = detailStore.getData().items;
					var maxSlipSeq =  Unilite.nvl(directMasterStore1.max("SLIP_SEQ"),0)+1;//selRecord.get("SLIP_SEQ") == 0 ? 1:selRecord.get("SLIP_SEQ") ;
						
					Ext.each(selectedRecords, function(selRecord, idx){
						var isExist = false;
						/*var filterData = Ext.Array.push(detailStore.data.filterBy(function(record) {return (selRecord.get('ORG_DATA')== record.get('ORG_DATA')) } ).items);
						if(filterData && filterData.length > 1) {
							
							pendRefGrid.pendApply(selRecord, filterData[0], maxSlipSeq,false);
						} else {
							pendRefGrid.pendApply(selRecord, null, maxSlipSeq,true);
						}*/
						pendRefGrid.pendApply(selRecord, null, maxSlipSeq,true);
						selRecord.set("FLAG","D");
						selRecord.set("J_AMT_I",0);
						selRecord.set("FOR_J_AMT_I",0);
						
						maxSlipSeq++;
				
					})
				} else {
					alert("승인된 전표입니다.");
				}
			}
		},'','',
		'->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->'],
		columns:  [
			{ dataIndex: 'ACCNT'				, width: 100  },
			{ dataIndex: 'ACCNT_NAME'			, width: 140 },
			{ dataIndex: 'ORG_AC_DATE'			, width: 80  },
			{ dataIndex: 'PAYMENT_DAY'			, width: 80  },
			{ dataIndex: 'ORG_SLIP_NUM'			, width: 50  },
			{ dataIndex: 'ORG_SLIP_SEQ'			, width: 50  },
			{ dataIndex: 'PEND_NAME'			, width: 100 },
			{ dataIndex: 'PEND_DATA_CODE'		, width: 100 },
			{ dataIndex: 'PEND_DATA_NAME'		, width: 120 },
			{ dataIndex: 'ORG_AMT_I'			, width: 100 },
			{ dataIndex: 'BLN_I'				, width: 100 },
			{ dataIndex: 'EX_AMT_I'				, width: 100 },
			{ dataIndex: 'J_AMT_I'				, width: 130 },
			{ dataIndex: 'FOR_ORG_AMT_I'		, width: 100 },
			{ dataIndex: 'FOR_BLN_I'			, width: 100 },
			{ dataIndex: 'FOR_EX_AMT_I'			, width: 100 },
			{ dataIndex: 'FOR_J_AMT_I'			, width: 130 },
			{ dataIndex: 'MONEY_UNIT'			, width: 100 },
			{ dataIndex: 'REMARK'				, width: 120 },
			{ dataIndex: 'DEPT_NAME'			, width: 100 },
			//{ dataIndex: 'FLAG'				, width: 100 },
			{ dataIndex: 'DIV_CODE'				, flex: 1	   , minWidth:80 }
		],
		listeners: {
			select: function(grid, record, index, rowIndex, eOpts ){
				sumJAmtI	= sumJAmtI	  + record.get('J_AMT_I');
				sumForJAmtI = sumForJAmtI   + record.get('FOR_J_AMT_I');
				pendRefForm.setValue('AMT'	  , sumJAmtI);
				pendRefForm.setValue('FOR_AMT'  , sumForJAmtI);
				if(record.get("J_AMT_I") == 0) {
					Unilite.messageBox("반제가능금액이 0 인 경우 참조할 수 없습니다.");
					grid.deselect(record);
				}
			},
			deselect:  function(grid, record, index, rowIndex, eOpts ){
				sumJAmtI	= sumJAmtI	  - record.get('J_AMT_I');
				sumForJAmtI = sumForJAmtI   - record.get('FOR_J_AMT_I');
				pendRefForm.setValue('AMT'	  , sumJAmtI)
				pendRefForm.setValue('FOR_AMT'  , sumForJAmtI)
			}
		}
	});
	
	var pend_tab = Unilite.createTabPanel('agj110ukrvTab',{
		region:'south',
		//flex:.4,
		flex:1,
		activeTab: 0,
		border: false,
		items:[
			{
				title: '미결반제',
				xtype: 'panel',
				itemId: 'pandTab1',
				id: 'pandTab1',
				layout:{type:'vbox', align:'stretch'},
				
				items:[
					pendGrid
				]
			},{
				title: '미결참조',
				xtype:'container',
				itemId: 'pandTab2',
				layout:{type:'vbox', align:'stretch'},
				defaults:{
					style:{left:'1px !important'}
				},
				items:[
					pendRefForm, pendRefGrid
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts ) {
				if(newCard.getItemId() == 'pandTab1') {
					UniAppManager.app.setGridMasterType(true);
					var slipCompGrids = Ext.getCmp('AgjSlipContainer');
					slipCompGrids.show();
				}else {
					UniAppManager.app.setGridMasterType(false);
					var slipCompGrids = Ext.getCmp('AgjSlipContainer');
					slipCompGrids.hide();
				}
			}
		}
	})
	
	function openSearchPopup() {
		if(!searchPopup) {
			
				Unilite.defineModel('searchModel', {
					fields: [
								 {name: 'J_EX_DATE'		 ,text:'반제결의일자'	  		,type:'uniDate'}
								,{name: 'J_EX_NUM'		  ,text:'반제결의번호'		,type:'int'}
								,{name: 'IN_DEPT_CODE'	  ,text:'귀속부서'			,type:'string'}
								,{name: 'CHARGE_CODE'	   ,text:'입력자'			,type:'string'}
								,{name: 'CHARGE_NAME'	   ,text:'입력자명'			,type:'string'}
								,{name: 'DR_AMT_I'		  ,text:'차변금액'			,type:'uniPrice'}
								,{name: 'CR_AMT_I'		  ,text:'대변금액'			,type:'uniPrice'}
								,{name: 'J_AC_DATE'		 ,text:'회계전표일자'	 		,type:'uniDate'}
								,{name: 'J_SLIP_NUM'		,text:'회계전표번호'		,type:'int'}
								,{name: 'AP_STS'			,text:'승인여부코드'		,type:'string'  , comboType:'AU', comboCode:'A014'}
								,{name: 'AP_STS_NM'		 ,text:'승인여부'			,type:'string'}
								,{name: 'INPUT_PATH'		,text:'입력경로'		,type:'string'}
								,{name: 'INPUT_DIVI'		,text:'전표입력경로'		,type:'string'}
								,{name: 'DRAFT_YN'		  ,text:'기안여부'			,type:'string'}
								,{name: 'IN_DIV_CODE'	   ,text:'귀속사업장'		,type:'string'}
								
							]
				});
				var searchDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
					api: {
						read : 'agj110ukrService.selectSearch'
					}
				});
				
				var searchStore = Unilite.createStore('searchStore', {
						model: 'searchModel',
						proxy: searchDirctProxy,
						loadStoreRecords : function() {
							var param= searchPopup.down('#search').getValues();
							
							this.load({
								params: param
							});
						}
				});
		
				searchPopup = Ext.create('widget.uniDetailWindow', {
					title: '미결반제검색',
					width: 800,
					height:500,
					
					layout: {type:'vbox', align:'stretch'},
					items: [{
							itemId:'search',
							xtype:'uniSearchForm',
							layout:{type:'uniTable',columns:2},
							items:[{
									fieldLabel: '반제결의일자',
									xtype: 'uniDateRangefield',
									startFieldName: 'FR_AC_DATE',
									endFieldName: 'TO_AC_DATE',
									startDate:  UniDate.get('startOfMonth'),//'20130801', //
									endDate:  UniDate.get('today'),//'20130831', //
									allowBlank:false
								},{
									fieldLabel: '사업장',
									name: 'DIV_CODE',
									xtype: 'uniCombobox' ,
									comboType: 'BOR120'
								},{
									xtype:'container',
									defaultType:'uniTextfield',
									layout:{type:'hbox', align:'stretch'},
									items:[
										{
											fieldLabel:'반제결의번호',
											name : 'EX_NUM_FR',
											width:195
										},{
											fieldLabel: '~',
											labelWidth:4,
											name:'EX_NUM_TO',
											width:118
										}
									]
								},{
									fieldLabel: '승인여부',
									name: 'AP_STS',
									xtype: 'uniCombobox',
									comboType:'AU',
									comboCode:'A014',
									flex:1
								},{
									fieldLabel: '결의담당자',
									name: 'CHARGE_CODE',
									hidden:true,
									value:'${chargeCode}'
								},{
									fieldLabel: '결의부서',
									name: 'IN_DEPT_CODE',
									hidden:true,
									value:'${chargeCode}'
								}
								
							]
						},
						Unilite.createGrid('', {
							itemId:'grid',
							layout : 'fit',
							store: searchStore,
							selModel:'rowmodel',
							uniOpt:{
								useMultipleSorting  : true,
								useLiveSearch		: false,
								onLoadSelectFirst	: true,
								useRowNumberer		: false,
								expandLastColumn	: false,
								useRowContext		: false,
								filter: {
									useFilter		: false,
									autoCreate		: false
								},
								userToolbar :false
							},
							columns:  [  
									 { dataIndex: 'J_EX_DATE'		,width: 100}
									,{ dataIndex: 'J_EX_NUM'		,width: 100}
									,{ dataIndex: 'DR_AMT_I'		,width: 100}
									,{ dataIndex: 'CR_AMT_I'		,width: 100}
									,{ dataIndex: 'J_AC_DATE'		,width: 100}
									,{ dataIndex: 'J_SLIP_NUM'		,width: 100}
									,{ dataIndex: 'AP_STS_NM'		,width: 80}
							]
							 ,listeners: {  
									onGridDblClick:function(grid, record, cellIndex, colName) {
										grid.ownerGrid.returnData();
										searchPopup.hide();
									}
								}
							,returnData: function() {
								var record = this.getSelectedRecord();
								searchPopup.returnRecord = record;
								panelSearch.setValue('AC_DATE',record.get("J_EX_DATE"));
								slipForm.setValue('AC_DATE',record.get("J_EX_DATE"));
								
								panelSearch.setValue('EX_NUM',record.get("J_EX_NUM"));
								slipForm.setValue('EX_NUM',record.get("J_EX_NUM"));
								
								panelSearch.setValue('DIV_CODE',record.get("IN_DIV_CODE"));
								slipForm.setValue('DIV_CODE',record.get("IN_DIV_CODE"));
								
								panelSearch.setValue('DEPT_CODE',record.get("IN_DEPT_CODE"));
								slipForm.setValue('DEPT_CODE',record.get("IN_DEPT_CODE"));
								
								panelSearch.setValue('CHARGE_CODE',record.get("CHARGE_CODE"));
								slipForm.setValue('CHARGE_CODE',record.get("CHARGE_CODE"));
								
								panelSearch.setValue('CHARGE_NAME',record.get("CHARGE_NAME"));
								slipForm.setValue('CHARGE_NAME',record.get("CHARGE_NAME"));
								
								gsApSts	  = record.get("AP_STS");
								gsInputPath  = record.get("INPUT_PATH");
								gsInputDivi  = record.get("INPUT_DIVI");
								gsDraftYN	= record.get("DRAFT_YN");
								var girdStore = Ext.data.StoreManager.lookup('agj110ukrMasterStore2');
								girdStore.loadStoreRecords();
							}
							
						})
					
					],
					tbar:  [
						 {
							itemId : 'searchtBtn',
							text: '조회',
							handler: function() {
								var form = searchPopup.down('#search');
								var store = Ext.data.StoreManager.lookup('searchStore')
								store.loadStoreRecords();
							},
							disabled: false
						},
						 '->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								if(searchStore.getCount()>0) {
									searchPopup.down('#grid').returnData()
								}
								searchPopup.hide();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								searchPopup.hide();
							},
							disabled: false
						}
					],
					listeners : {beforehide: function(me, eOpt) {
									searchPopup.down('#search').clearForm();
									searchPopup.down('#grid').reset();
								},
								 beforeclose: function( panel, eOpts ) {
									searchPopup.down('#search').clearForm();
									searchPopup.down('#grid').reset();
								},
								 show: function( panel, eOpts ) {
									var form = searchPopup.down('#search');
									form.clearForm();
									searchPopup.center();
								 }
					}	   
				});
		}
		
		searchPopup.center();
		searchPopup.show();
		var sForm = searchPopup.down('#search');
		sForm.setValue("FR_AC_DATE", UniDate.get('startOfMonth',slipForm.getValue("AC_DATE")));
		sForm.setValue("TO_AC_DATE", slipForm.getValue("AC_DATE"));
		sForm.setValue("CHARGE_CODE", '${chargeCode}');
		sForm.setValue("IN_DEPT_CODE", slipForm.getValue("DEPT_CODE"));
	}
	//차대변 비교
	<%@include file="./agjSlip.jsp" %> 
	var centerContainer = {
		region:'center',
		flex:.5,
		//flex:1,
		xtype:'container',
		layout:{type:'vbox', align:'stretch'},
		items:[
			slipForm,
			masterGrid1,
			detailForm1//,
			//masterGridTmp,
			//detailFormTmp//,
			//slipContainer
		]
	}

	var tempGridForView = Unilite.createGrid('tempGridForView', {
		
			uniOpt:{
				copiedRow:false,
				useContextMenu:false,
				expandLastColumn: false,
				useMultipleSorting: false,
				useNavigationModel:false/*,
				dblClickToEdit:false*/
			},
			enableColumnHide :false,
			sortableColumns : false,
			border:true,
		
			store: directMasterStore1,
			
			
		
		
			columns:[
				 { dataIndex: 'AC_DAY'			  ,width: 45 , align:'center' } 
				,{ dataIndex: 'AC_DATE'			  ,width: 55 , align:'center'} 
				,{ dataIndex: 'SLIP_NUM'		  ,width: 55 , format:'0', align:'center'}
				,{ dataIndex: 'SLIP_SEQ'		  ,width: 45 , align:'center'} 
				,{ dataIndex: 'DR_CR'			  ,width: 80 }
				,{ dataIndex: 'SLIP_DIVI'		  ,width: 80 }
				,{ dataIndex: 'ACCNT'			  ,width: 80 }
				,{ dataIndex: 'ACCNT_NAME'		  ,width: 130}
				,{ dataIndex: 'CUSTOM_CODE'		  ,width: 80 }
				,{ dataIndex: 'CUSTOM_NAME'		  ,width: 140 }
				,{ dataIndex: 'DR_AMT_I'		  ,width: 100 }
				,{ dataIndex: 'CR_AMT_I'		  ,width: 100 }
				,{ dataIndex: 'REMARK'			  ,width: 200 }
				,{ dataIndex: 'SPEC_DIVI'   	  ,width: 110 }
				,{ dataIndex: 'PROOF_KIND'  	  ,width: 110 }
				,{ dataIndex: 'CREDIT_NUM'  	  ,width: 150 , hidden: true}
				,{ dataIndex: 'CREDIT_NUM_EXPOS'  ,width: 150 }
				,{ dataIndex: 'DEPT_NAME'		  ,width: 100 }
				,{ dataIndex: 'EXCHG_RATE_O'	  ,width:80}
				,{ dataIndex: 'OPR_FLAG'		  ,width:80}
				,{ dataIndex: 'CHARGE_CODE'	 	  ,width:80}
				,{ dataIndex: 'AP_DATE'			  ,width:80}
				,{ dataIndex: 'SPEC_DIVI'		  ,width:80}
				,{ dataIndex: 'REASON_CODE'		  ,width:80}
				,{ dataIndex: 'CREDIT_CODE'	 	  ,width:80}
				,{ dataIndex: 'CASH_NUM'		  ,width:80}
				,{ dataIndex: 'AC_DATA1'		  ,width:80}
				,{ dataIndex: 'AC_DATA2'		  ,width:80}
				,{ dataIndex: 'AC_DATA3'		  ,width:80}
				,{ dataIndex:  'AC_DATA4'   	  ,width:80}
				,{ dataIndex:  'AC_DATA5'   	  ,width:80}
				,{ dataIndex:  'AC_DATA6'   	  ,width:80}
				,{ dataIndex: 'OLD_AC_DATE'	 	  ,width:80}
				,{ dataIndex: 'OLD_SLIP_NUM'	  ,width:80}
				,{ dataIndex: 'OLD_SLIP_SEQ'	  ,width:80}
				
				,{ dataIndex: 'AMT_I'			  ,width:80} 
				,{ dataIndex: 'INPUT_USER_ID'	  ,width:80}
				
				,{ dataIndex: 'DIV_CODE'		  ,flex: 1 , minWidth:60}
				,{ dataIndex: 'BILL_DIV_CODE'	  ,width:80}
				
				,{dataIndex: 'OLD_AC_DATE'		  ,width:80}
				,{dataIndex: 'OLD_SLIP_NUM'		  ,width:80}
				,{dataIndex: 'OLD_SLIP_SEQ'		  ,width:80}
				,{dataIndex: 'P_ACCNT'			  ,width:80}
				,{dataIndex: 'MONEY_UNIT'		  ,width:80}
				,{dataIndex: 'EXCHG_RATE_O'		  ,width:80}
				,{dataIndex: 'FOR_AMT_I'		  ,width:80}
				,{dataIndex: 'IN_DIV_CODE'		  ,width:80}
				,{dataIndex: 'IN_DEPT_CODE'		  ,width:80}
				,{dataIndex: 'BILL_DIV_CODE'	  ,width:80}
				
				,{dataIndex: 'AC_CODE1'			  ,width:80}
				,{dataIndex: 'AC_CODE2'			  ,width:80}
				,{dataIndex: 'AC_CODE3'			  ,width:80}
				,{dataIndex: 'AC_CODE4'			  ,width:80}
				,{dataIndex: 'AC_CODE5'			  ,width:80}
				,{dataIndex: 'AC_CODE6'			  ,width:80}
				
				,{dataIndex: 'AC_NAME1'			  ,width:80}
				,{dataIndex: 'AC_NAME2'			  ,width:80}
				,{dataIndex: 'AC_NAME3'			  ,width:80}
				,{dataIndex: 'AC_NAME4'			  ,width:80}
				,{dataIndex: 'AC_NAME5'			  ,width:80}
				,{dataIndex: 'AC_NAME6'			  ,width:80}
				
				,{dataIndex: 'AC_DATA1'			  ,width:80}
				,{dataIndex: 'AC_DATA2'			  ,width:80}
				,{dataIndex: 'AC_DATA3'			  ,width:80}//,text:'관리항목데이터3'		,type : 'string'}
				,{dataIndex: 'AC_DATA4'			  ,width:80}//,text:'관리항목데이터4'		,type : 'string'}
				,{dataIndex: 'AC_DATA5'			  ,width:80}//,text:'관리항목데이터5'		,type : 'string'}
				,{dataIndex: 'AC_DATA6'			  ,width:80}//,text:'관리항목데이터6'		,type : 'string'}
				
				,{dataIndex: 'AC_DATA_NAME1'	  ,width:80}//,text:'관리항목데이터명1'   ,type : 'string'}
				,{dataIndex: 'AC_DATA_NAME2'	  ,width:80}//,text:'관리항목데이터명2'   ,type : 'string'}
				,{dataIndex: 'AC_DATA_NAME3'	  ,width:80}//,text:'관리항목데이터명3'   ,type : 'string'}
				,{dataIndex: 'AC_DATA_NAME4'	  ,width:80}//,text:'관리항목데이터명4'   ,type : 'string'}
				,{dataIndex: 'AC_DATA_NAME5'	  ,width:80}//,text:'관리항목데이터명5'   ,type : 'string'}
				,{dataIndex: 'AC_DATA_NAME6'	  ,width:80}//,text:'관리항목데이터명6'   ,type : 'string'}
				
				,{dataIndex: 'BOOK_CODE1'		  ,width:80}//,text:'계정잔액코드1'	 ,type : 'string'} 
				,{dataIndex: 'BOOK_CODE2'		  ,width:80}//,text:'계정잔액코드2'	 ,type : 'string'} 
				,{dataIndex: 'BOOK_DATA1'		  ,width:80}//,text:'계정잔액데이터1'		,type : 'string'} 
				,{dataIndex: 'BOOK_DATA2'		  ,width:80}//,text:'계정잔액데이터2'		,type : 'string'} 
				,{dataIndex: 'BOOK_DATA_NAME1'    ,width:80}//,text:'계정잔액데이터명1'   ,type : 'string'}
				,{dataIndex: 'BOOK_DATA_NAME2'    ,width:80}//,text:'계정잔액데이터명2'   ,type : 'string'}
				
				,{dataIndex: 'ACCNT_SPEC'		  ,width:80}//,text:'계정특성'			,type : 'string'}
				,{dataIndex: 'SPEC_DIVI'		  ,width:80}//,text:'자산부채특성'	  ,type : 'string', comboType:'AU', comboCode:'A016'}
				,{dataIndex: 'PROFIT_DIVI'		  ,width:80}//,text:'손익특성'			,type : 'string'}
				,{dataIndex: 'JAN_DIVI'			  ,width:80}//,text:'잔액변(차대)'	 ,type : 'string'}
				,{dataIndex: 'PEND_YN'			  ,width:80}//,text:'미결관리여부'	  ,type : 'string', defaultValue:'N'}
				,{dataIndex: 'PEND_CODE'		  ,width:80}//,text:'미결항목'			,type : 'string'}
				,{dataIndex: 'PEND_DATA_CODE'	  ,width:80}//,text:'미결항목데이터코드'   ,type : 'string'}
				,{dataIndex: 'BUDG_YN'			  ,width:80}//,text:'예산사용여부'	  ,type : 'string'}
				,{dataIndex: 'BUDGCTL_YN'		  ,width:80}//,text:'예산통제여부'	  ,type : 'string'}
				,{dataIndex: 'FOR_YN'			  ,width:80}//,text:'외화구분'			,type : 'string'}
				
				,{dataIndex: 'POSTIT_YN'		  ,width:80}//,text:'주석체크여부'	  ,type : 'string'} 
				,{dataIndex: 'POSTIT'			  ,width:80}//,text:'주석내용'			,type : 'string'} 
				,{dataIndex: 'POSTIT_USER_ID'	  ,width:80}//,text:'주석체크자'		   ,type : 'string'} 
				
				,{dataIndex: 'INPUT_PATH'		  ,width:80}//,text:'입력경로'			,type : 'string', defaultValue: csINPUT_PATH} 
				,{dataIndex: 'INPUT_DIVI'		  ,width:80}//,text:'전표입력경로'	  ,type : 'string', defaultValue: csINPUT_DIVI} 
				,{dataIndex: 'AUTO_SLIP_NUM'	  ,width:80}//,text:'자동기표번호'	  ,type : 'string'} 
				,{dataIndex: 'CLOSE_FG'		  ,width:80}//,text:'마감여부'			,type : 'string'} 
				,{dataIndex: 'INPUT_DATE'		,width:80}//,text:'입력일자'			,type : 'string'} 
				,{dataIndex: 'INPUT_USER_ID'	 ,width:80}//,text:'입력자ID'		   ,type : 'string'} 
				,{dataIndex: 'CHARGE_CODE'	   ,width:80}//,text:'담당자코드'		   ,type : 'string'} 
				,{dataIndex: 'CHARGE_NAME'	   ,width:80}//,text:'담당자명'			,type : 'string'} 
				
				,{dataIndex: 'AP_STS'			,width:80}//,text:'승인상태'			,type : 'string', defaultValue:'1'} 
				,{dataIndex: 'AP_DATE'		   ,width:80}//,text:'승인처리일'		   ,type : 'string'} 
				,{dataIndex: 'AP_USER_ID'		,width:80}//,text:'승인자ID'		   ,type : 'string'} 
				,{dataIndex: 'EX_DATE'		   ,width:80}//,text:'회계전표일자'	  ,type : 'string'} 
				,{dataIndex: 'EX_NUM'			,width:80}//,text:'회계전표번호'	  ,type : 'int'} 
				,{dataIndex: 'EX_SEQ'			,width:80}//,text:'회계전표순번'	  ,type : 'string'} 
				,{dataIndex: 'COMP_CODE'		 ,width:80}//,text:'법인코드'			,type : 'string'} 
				,{dataIndex: 'AMT_I'			 ,width:80}//,text:'금액'			  ,type : 'uniPrice'} 
				,{dataIndex: 'DRAFT_YN'		  ,width:80}//,text:'기안여부(E-Ware)'	,type : 'string'} 
				,{dataIndex: 'AGREE_YN'		  ,width:80}//,text:'결재완료(E-Ware)'	,type : 'string'} 
				,{dataIndex: 'CASH_NUM'		  ,width:80}//,text:'CASH_NUM'			,type : 'string'}
				,{dataIndex: 'OPR_FLAG'		  ,width:80}//,text:'editFlag'			,type : 'string', defaultValue:'L'} 
				,{dataIndex: 'ORG_DATA'		  ,width:80}//,text:'ORG_DATA'			,type : 'string'} 
				,{dataIndex: 'store2Idx'		 ,width:80}//,text:'store2Idx'		   ,type : 'string'} 
				
				,{dataIndex: 'AC_CTL1'		   ,text:'관리항목필수1'	 	,width : 100} 
				,{dataIndex: 'AC_CTL2'		   ,text:'관리항목필수2'	 	,width : 100} 
				,{dataIndex: 'AC_CTL3'		   ,text:'관리항목필수3'	 	,width : 100} 
				,{dataIndex: 'AC_CTL4'		   ,text:'관리항목필수4'	 	,width : 100} 
				,{dataIndex: 'AC_CTL5'		   ,text:'관리항목필수5'	 	,width : 100} 
				,{dataIndex: 'AC_CTL6'		   ,text:'관리항목필수6'	 	,width : 100} 
				,{dataIndex: 'ORG_AC_DATE'		,text: '미결전표일'		,width : 100}
				,{dataIndex: 'ORG_SLIP_NUM'		,text: '미결전표번호'	,width : 100}					 
				,{dataIndex: 'ORG_SLIP_SEQ'		,text: '미결순번'		,width : 100}			
				,{dataIndex: 'J_AMT_I'			,text: '반제가능금액'	,width : 100}				
				,{dataIndex: 'FOR_J_AMT_I'		,text: '외화반제가능금액',width : 100}			   
				,{dataIndex: 'DEPT_NAME'		,text: '귀속부서명'	    ,width : 100}				  
				,{dataIndex: 'SEQ'				,text: '미결반제SEQ'		,width : 100}
				,{dataIndex: 'J_EX_DATE'		,text: '미결반제전표일'	,width : 100}
				,{dataIndex: 'J_EX_NUM'			,text: '미결반제전표번호'	,width : 100}
				,{dataIndex: 'J_EX_SEQ'			,text: '미결번재전표순번'	,width : 100}
				,{dataIndex: 'FOR_BLN_I'		,text: '미결외화잔액'	,width : 100}
				,{dataIndex: 'BLN_I'			,text: '미결잔액'		,width : 100}
				,{dataIndex: 'IS_PEND_INPUT'	,text: '미결반제데이터여부',width : 100}
//			  
//			  ,{dataIndex: 'AC_TYPE1'		  ,text:'관리항목1유형'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_TYPE2'		  ,text:'관리항목2유형'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_TYPE3'		  ,text:'관리항목3유형'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_TYPE4'		  ,text:'관리항목4유형'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_TYPE5'		  ,text:'관리항목5유형'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_TYPE6'		  ,text:'관리항목6유형'	 ,type : 'string'} 
//			  
//			  ,{dataIndex: 'AC_LEN1'		   ,text:'관리항목1길이'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_LEN2'		   ,text:'관리항목2길이'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_LEN3'		   ,text:'관리항목3길이'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_LEN4'		   ,text:'관리항목4길이'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_LEN5'		   ,text:'관리항목5길이'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_LEN6'		   ,text:'관리항목6길이'	 ,type : 'string'} 
//			  
//			  ,{dataIndex: 'AC_POPUP1'		 ,text:'관리항목1팝업여부'   ,type : 'string'} 
//			  ,{dataIndex: 'AC_POPUP2'		 ,text:'관리항목2팝업여부'   ,type : 'string'} 
//			  ,{dataIndex: 'AC_POPUP3'		 ,text:'관리항목3팝업여부'   ,type : 'string'} 
//			  ,{dataIndex: 'AC_POPUP4'		 ,text:'관리항목4팝업여부'   ,type : 'string'} 
//			  ,{dataIndex: 'AC_POPUP5'		 ,text:'관리항목5팝업여부'   ,type : 'string'} 
//			  ,{dataIndex: 'AC_POPUP6'		 ,text:'관리항목6팝업여부'   ,type : 'string'} 
//			  
//			  ,{dataIndex: 'AC_FORMAT1'		,text:'관리항목1포멧'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_FORMAT2'		,text:'관리항목2포멧'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_FORMAT3'		,text:'관리항목3포멧'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_FORMAT4'		,text:'관리항목4포멧'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_FORMAT5'		,text:'관리항목5포멧'	 ,type : 'string'} 
//			  ,{dataIndex: 'AC_FORMAT6'		,text:'관리항목6포멧'	 ,type : 'string'} 
				
			
			  ] ,
			  
			listeners:{
				beforeedit:function( editor, context, eOpts ) {
						return false;
				}
			}
	});
	
	function openTempGridWin() {
		
			if(!tempFridForViewoWin) {
					tempFridForViewoWin = Ext.create('widget.uniDetailWindow', {
						title: '저장데이터보기',
						width: 1000,
						height:200,
						
						layout: {type:'vbox', align:'stretch'},
						items: [tempGridForView],
						tbar:  [
							 '->',{
								itemId : 'closeBtn',
								text: '닫기',
								handler: function() {
									tempFridForViewoWin.hide();
								},
								disabled: false
							}
						],
						listeners : {
									show: function( panel, eOpts ) {
										tempGridForView.view.refresh()
									}
						}
					});
			}   
			tempFridForViewoWin.center();
			tempFridForViewoWin.show();
	}

	Unilite.Main({
		borderItems:[ 
			panelSearch,
			{
				region:'center',
				layout: 'border',
				border: false,
				
				defaults:{
					style:{left:'1px'}
				},
				items:[
					panelResult,
					centerContainer, 
					{
						region:'south',
						xtype:'container',
						layout:{type:'vbox', align:'stretch'},
						flex:.5,
						//height:400,
						items:[
							slipContainer,
							pend_tab
						]
					}
				]
			}
			
		],
		id  : 'agj110ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons([ 'newData', 'reset'],true);
			
			panelSearch.setValue('AC_DATE','${initExDate}');
			panelSearch.setValue('EX_NUM','${initExNum}');
			
			panelResult.setValue('AC_DATE','${initExDate}');
			panelResult.setValue('EX_NUM','${initExNum}');
			
			slipForm.setValue('AC_DATE','${initExDate}');
			slipForm.setValue('EX_NUM','${initExNum}');
			slipForm.setValue('CHARGE_CODE','${chargeCode}');
			slipForm.setValue('CHARGE_NAME','${chargeName}');  
			if(Ext.isEmpty('${chargeCode}')) {
				alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
			}
				
			if(gsChargeDivi == '1'){
				pendRefForm.getField('DEPT_CODE').setReadOnly(false);
				pendRefForm.getField('DEPT_NAME').setReadOnly(false);
			
			}else{
				pendRefForm.getField('DEPT_CODE').setReadOnly(true);
				pendRefForm.getField('DEPT_NAME').setReadOnly(true);
			
				pendRefForm.setValue('DEPT_CODE',baseInfo.gsDeptCode);
				pendRefForm.setValue('DEPT_NAME',baseInfo.gsDeptName);
				
				//pendRefForm.setValue('DEPT_CODE',UserInfo.deptCode);
				//pendRefForm.setValue('DEPT_NAME',UserInfo.deptName);
			}
			if(params && params.PGM_ID) {
				this.processParams(params);
			}
		},
		onQueryButtonDown : function() {
			if(Ext.isEmpty('${chargeCode}')) {
				alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
				return false;
			}
			if(pend_tab.getActiveTab().getItemId() == 'pandTab1') {
				detailForm1.down('#formFieldArea1').removeAll();
				//directMasterStore1.loadStoreRecords();
				//slipForm.setValue("AC_DATE", UniDate.get('today'));
				if(searchPopup == null || (searchPopup && !searchPopup.isVisible())) {
					if(panelSearch.isValid()) {
						this.setSearchReadOnly(false, true);
						directMasterStore1.removeAll(true);
						directMasterStore1.commitChanges();
						directMasterStore2.loadStoreRecords()
					} else {
						
						openSearchPopup();
					}
				}
			} else {
				pendRefStore.loadStoreRecords();
				sumForJAmtI = 0;
				sumJAmtI	= 0;
			}
		},
		onNewDataButtonDown : function() {
			if(Ext.isEmpty('${chargeCode}')) {
				alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
				return false;
			}
			if(slipForm.getValue("AP_STS") != "2") {
				this.fnAddSlipRecord();
				UniAppManager.app.setSearchReadOnly(true, false);
			}else {
				alert("승인된 전표입니다.");
			}
				//UniAppManager.app.setSearchReadOnly(true);
		},  
		onSaveDataButtonDown: function (config) {
			if(slipForm.getValue("AP_STS") != "2") {
				directMasterStore1.saveStore(config);
			}else {
				alert("승인된 전표입니다.");
				this.rejectSave();
			}
			
		},
		onDeleteDataButtonDown : function() {
			if(slipForm.getValue("AP_STS") != "2") {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					if(clickedGrid == 'agj110ukrGrid1') {
						masterGrid1.deleteSelectedRow();
						if(masterGrid1.getStore().getCount() == 0) {
							detailForm1.down('#formFieldArea1').removeAll();
						}
					}else if(clickedGrid == 'agj110ukrPendGrid') {
						pendGrid.deleteSelectedRow();
					}
				}
			}else {
				alert("승인된 전표입니다.");
			}
		},
		onDeleteAllButtonDown : function() {
			if(slipForm.getValue("AP_STS") != "2") {
				if(confirm('전체 삭제 하시겠습니까?')) {
					//directMasterStore2.removeAll();// event 실행하지 않아 못씀
					var cnt = directMasterStore2.count();
					for(var i=0 ; i < cnt ; i++) {
						directMasterStore2.removeAt(0);
					}
					var cnt2 = detailStore.count();
					for(var i=0 ; i < cnt2 ; i++) {
						detailStore.removeAt(0);
					}
					detailForm1.down('#formFieldArea1').removeAll();
				}
			}else {
				alert("승인된 전표입니다.");
			}
		},
		onPrevDataButtonDown:  function() {
			
		},
		onNextDataButtonDown:  function() {
			
		},
		onResetButtonDown:function(params) {
			gsSlipNum = "";
			gsProcessPgmId ="";
			
			var masterGrid1 = Ext.getCmp('agj110ukrGrid1');
			masterGrid1.reset();
			masterGrid1.getStore().commitChanges();
			this.setSearchReadOnly(false, false);
			slipForm.getForm().reset(); 
			tempEditMode = true;
			detailForm1.down('#formFieldArea1').removeAll();
			
			drSum = 0, crSum=0;
			directMasterStore1.removeAll();
			directMasterStore1.commitChanges();
			
			pendGrid.reset();
			pendGrid.getStore().commitChanges();
			pendRefGrid.reset();
			
			pendRefForm.clearForm();
			pendRefForm.setValue('AC_DATE_FR'   , UniDate.get('startOfMonth'));
			pendRefForm.setValue('AC_DATE_TO'   , UniDate.get('today'));
			pendRefForm.setValue('DIV_CODE'	 , UserInfo.divCode);
			sumForJAmtI = 0;
			sumJAmtI	= 0;
			
			slipGrid1.reset();
			slipGrid1.getStore().clearData();
			slipGrid2.reset();
			slipGrid2.getStore().clearData();
			
			UniAppManager.setToolbarButtons(['save'],false);
			
			
			
			slipForm.setValue('AC_DATE','${initExDate}');
			slipForm.setValue('EX_NUM','${initExNum}');
			slipForm.setValue('CHARGE_CODE','${chargeCode}');
			slipForm.setValue('CHARGE_NAME','${chargeName}');
			if(Ext.isEmpty(params) || (params && Ext.isEmpty(params.EX_NUM)))	{
				agj100ukrService.getSlipNum({'EX_DATE':UniDate.getDbDateStr(slipForm.getValue('AC_DATE'))}, function(provider, result ) {
						slipForm.setValue("EX_NUM", provider.SLIP_NUM); 
						panelSearch.setValue('EX_NUM',provider.SLIP_NUM);
				})
			}
		},
		onDetailButtonDown:function() {
			
		},
		rejectSave: function() {
			directMasterStore1.rejectChanges();
			directMasterStore2.rejectChanges();
			detailStore.rejectChanges();
			var refData = penRefStore.getData();
			Ext.each(refData.item, function(item, idx){
				item.set("FLAG","R");
			});
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
		setGridMasterType:function(b) {
			directMasterStore1.uniOpt.isMaster = b;
			detailStore.uniOpt.isMaster = b;
			if(b) {
				this.setToolbarButtons('newData', true);
				// delete 버튼, directMasterStore1 detailStore의 uniOpt 설정이 같으므로 한번만 호출함
				if(directMasterStore1.count() > 0 || detailStore.count() > 0) {
					this.setToolbarButtons(['delete', 'deleteAll'], true);
				}else {
					this.setToolbarButtons(['delete', 'deleteAll'], false);
				}
				// 저장버튼
				if(directMasterStore1.isDirty() || detailStore.isDirty()) {
					this.setToolbarButtons('save', true);
				}
			}else {
				this.setToolbarButtons(['delete', 'deleteAll', 'save', 'newData'], false);
			}
		},
		//링크로 넘어오는 params 받는 부분 (Agj240skr)
		processParams: function(params) {
			UniAppManager.app.onResetButtonDown(params);
			pend_tab.setActiveTab(Ext.getCmp('pandTab1'));
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'abh300ukr') {
				slipForm.setValue('AC_DATE',params.EX_DATE);
				slipForm.setValue('INPUT_PATH',params.INPUT_PATH);
				slipForm.setValue('AP_STS',params.AP_STS);
				slipForm.setValue('IN_DIV_CODE',params.DIV_CODE);

				gsProcessPgmId  = params.PGM_ID;
				gsSlipNum	   = params.SLIP_NUM;
				gsSlipSeq	   = params.EX_SEQ;
				
				this.onQueryButtonDown();
				//masterGrid1.getStore().loadStoreRecords();
				
			}  else if(params.PGM_ID == 'agj230ukr') {
				if(!Ext.isEmpty(params.AC_DATE_FR)){
					panelSearch.setValue('AC_DATE',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE',params.AC_DATE_FR);
					slipForm.setValue('AC_DATE',params.AC_DATE_FR);
				}else{
					panelSearch.setValue('AC_DATE',params.EX_DATE_FR);
					panelResult.setValue('AC_DATE',params.EX_DATE_FR);
					slipForm.setValue('AC_DATE',params.EX_DATE_FR);
				}
//			  if(!Ext.isEmpty(params.SLIP_NUM)){
//				  panelSearch.setValue('EX_NUM'   ,params.SLIP_NUM);
//				  panelResult.setValue('EX_NUM'   ,params.SLIP_NUM);
//				  slipForm.setValue('EX_NUM'	  ,params.SLIP_NUM);
//			  }else{
					panelSearch.setValue('EX_NUM'   ,params.EX_NUM);
					panelResult.setValue('EX_NUM'   ,params.EX_NUM);
					slipForm.setValue('EX_NUM'	  ,params.EX_NUM);
//			  }
				slipForm.setValue('AP_STS'		  ,params.AP_STS);
				slipForm.setValue('IN_DIV_CODE'	 ,params.DIV_CODE);
				slipForm.setValue('IN_DEPT_CODE'		,params.DEPT_CODE);
				slipForm.setValue('IN_DEPT_NAME'		,params.DEPT_NAME);
				slipForm.setValue('CHARGE_CODE'	 ,params.CHARGE_CODE);
				slipForm.setValue('CHARGE_NAME'	 ,params.CHARGE_NAME);
				slipForm.setValue('SLIP_DIVI'	   ,params.SLIP_DIVI);

				gsProcessPgmId  = params.PGM_ID;
				gsSlipNum	   = params.SLIP_NUM;
				gsSlipSeq	   = params.SLIP_SEQ;
				
				this.onQueryButtonDown();
				//masterGrid1.getStore().loadStoreRecords();
				
			} else if(params.PGM_ID == 'agj240skr') {
				if(!Ext.isEmpty(params.AC_DATE_FR)){
					panelSearch.setValue('AC_DATE'  ,params.AC_DATE_FR);
					panelResult.setValue('AC_DATE'  ,params.AC_DATE_FR);
					slipForm.setValue('AC_DATE'	 ,params.AC_DATE_FR);
				}else{
					panelSearch.setValue('AC_DATE'  ,params.EX_DATE_FR);
					panelResult.setValue('AC_DATE'  ,params.EX_DATE_FR);
					slipForm.setValue('AC_DATE'	 ,params.EX_DATE_FR);
				}
//			  if(!Ext.isEmpty(params.SLIP_NUM)){
//				  panelSearch.setValue('EX_NUM'   ,params.SLIP_NUM);
//				  panelResult.setValue('EX_NUM'   ,params.SLIP_NUM);
//				  slipForm.setValue('EX_NUM'	  ,params.SLIP_NUM);
//			  }else{
					panelSearch.setValue('EX_NUM'   ,params.EX_NUM);
					panelResult.setValue('EX_NUM'   ,params.EX_NUM);
					slipForm.setValue('EX_NUM'	  ,params.EX_NUM);
//			  }
				slipForm.setValue('AP_STS'		  ,params.AP_STS);
				slipForm.setValue('IN_DIV_CODE'	 ,params.DIV_CODE);
				slipForm.setValue('IN_DEPT_CODE'		,params.DEPT_CODE);
				slipForm.setValue('IN_DEPT_NAME'		,params.DEPT_NAME);
				slipForm.setValue('CHARGE_CODE'	 ,params.CHARGE_CODE);
				slipForm.setValue('CHARGE_NAME'	 ,params.CHARGE_NAME);
				slipForm.setValue('SLIP_DIVI'	   ,params.SLIP_DIVI);

				gsProcessPgmId  = params.PGM_ID;
				gsSlipNum	   = params.SLIP_NUM;
				gsSlipSeq	   = params.SLIP_SEQ;
				
				this.onQueryButtonDown();
				//masterGrid1.getStore().loadStoreRecords();
			} else if(params.PGM_ID == 'agj245skr') {
				if(!Ext.isEmpty(params.AC_DATE_FR)){
					panelSearch.setValue('AC_DATE',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE',params.AC_DATE_FR);
					slipForm.setValue('AC_DATE',params.AC_DATE_FR);
				}else{
					panelSearch.setValue('AC_DATE',params.EX_DATE_FR);
					panelResult.setValue('AC_DATE',params.EX_DATE_FR);
					slipForm.setValue('AC_DATE',params.EX_DATE_FR);
				}
//			  if(!Ext.isEmpty(params.SLIP_NUM)){
//				  panelSearch.setValue('EX_NUM',params.SLIP_NUM);
//				  panelResult.setValue('EX_NUM',params.SLIP_NUM);
//				  slipForm.setValue('EX_NUM',params.SLIP_NUM);
//			  }else{
					panelSearch.setValue('EX_NUM',params.EX_NUM);
					panelResult.setValue('EX_NUM',params.EX_NUM);
					slipForm.setValue('EX_NUM',params.EX_NUM);
//			  }

				slipForm.setValue('AP_STS'		  ,params.AP_STS);
				slipForm.setValue('IN_DIV_CODE'	 ,params.DIV_CODE);
				slipForm.setValue('IN_DEPT_CODE'		,params.DEPT_CODE);
				slipForm.setValue('IN_DEPT_NAME'		,params.DEPT_NAME);
				slipForm.setValue('CHARGE_CODE'	 ,params.CHARGE_CODE);
				slipForm.setValue('CHARGE_NAME'	 ,params.CHARGE_NAME);
				slipForm.setValue('SLIP_DIVI'	   ,params.SLIP_DIVI);
				
				this.onQueryButtonDown();
				//masterGrid1.getStore().loadStoreRecords();
				
			} else if(params.PGM_ID == 'agj270skr') {
				if(!Ext.isEmpty(params.AC_DATE_FR)){
					panelSearch.setValue('AC_DATE',params.AC_DATE_FR);
					panelResult.setValue('AC_DATE',params.AC_DATE_FR);
					slipForm.setValue('AC_DATE',params.AC_DATE_FR);
				}else{
					panelSearch.setValue('AC_DATE',params.EX_DATE_FR);
					panelResult.setValue('AC_DATE',params.EX_DATE_FR);
					slipForm.setValue('AC_DATE',params.EX_DATE_FR);
				}
				panelSearch.setValue('EX_NUM'   ,params.EX_NUM);
				panelResult.setValue('EX_NUM'   ,params.EX_NUM);
				slipForm.setValue('EX_NUM'	  ,params.EX_NUM);


				gsProcessPgmId  = params.PGM_ID;
				gsSlipNum	   = params.SLIP_NUM;
				gsSlipSeq	   = params.SLIP_SEQ;
				
				this.onQueryButtonDown();
				//masterGrid1.getStore().loadStoreRecords();
				
			}
		},
		setSearchReadOnly:function(b, isOldData) {
			if(!isOldData) {
				slipForm.getField('AC_DATE').setReadOnly(b);
				slipForm.getField('EX_NUM').setReadOnly(b);
			}
			slipForm.getField('IN_DIV_CODE').setReadOnly(b);
			
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
								alert(Msg.sMA0040);
								this.clearAccntInfo(rtnRecord, detailForm);
							}
						}
						/*alert(Msg.sMA0006);
						if(fieldName) {
							record.set(fieldName, '');
						}*/
					}
					Ext.getBody().unmask();
					
				})
			}
		},
		loadDataAccntInfo:function(rtnRecord, detailForm, provider) {
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
						alert(Msg.sMA0040);
						this.clearAccntInfo(rtnRecord, detailForm);
						return;
					}
				}
			}	   
			if(!Ext.isEmpty(provider.ACCNT_CODE)) {
				rtnRecord.set("ACCNT", provider.ACCNT_CODE);
			}else if(!Ext.isEmpty(provider.ACCNT)) {
				rtnRecord.set("ACCNT", provider.ACCNT); //이전행에서 복사한 경우 
			}
			//rtnRecord.set("ACCNT", provider.ACCNT);
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
				
			}else if(rtnRecord.get("DR_CR") == "2") { 
				
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
			UniAppManager.app.fnSetDefaultAcCodeI5(rtnRecord);
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
			
			record.set("CREDIT_CODE", "");
			record.set("REASON_CODE", "");
			detailForm.down('#formFieldArea1').removeAll();
			Ext.getBody().unmask();
		},
		getActiveForm:function() {
			var form = detailForm1;
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
			
			if((isAddRow && store.getCount() == 0 )) {   // 처름 행 추가 한
																	// 경우
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
			if(addLoading) {
				Ext.getBody().mask();
				fnAddSlipMessageWin();
				return;
			}
			addLoading = true;
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
			
			var slipSeq = Unilite.nvl(directMasterStore1.max("SLIP_SEQ"),0)+1 ;
			// 순번 생성 End
			
			var slipDivi = slipForm.getValue('SLIP_DIVI');
			var recordSlipDivi = "";
			if(slipDivi=="3")   recordSlipDivi = "3";
			else if(slipDivi=="1")  recordSlipDivi = "2";
			else if(slipDivi=="2")  recordSlipDivi = "1";
			
			if(recordSlipDivi == null || typeof recordSlipDivi == 'undefined' || recordSlipDivi == "") {
				recordSlipDivi = "3";
				slipDivi = "3";
			}
			
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
				'SLIP_DIVI':Ext.isEmpty(selectedRecord) ? recordSlipDivi : selectedRecord.get("SLIP_DIVI") ,
				'DR_CR':slipDivi=="1" ? "2" :(Ext.isEmpty(selectedRecord) ? "1":selectedRecord.get("DR_CR")),
				'AP_STS':'1',
				'DIV_CODE':slipForm.getValue('IN_DIV_CODE'),
				'DEPT_CODE':baseInfo.gsDeptCode,
				'DEPT_NAME':baseInfo.gsDeptName,
				
				//'DEPT_CODE':UserInfo.deptCode,
				//'DEPT_NAME':UserInfo.deptName,
				'CUSTOM_CODE'	: (Ext.isEmpty(selectedRecord) || baseInfo.customCodeCopy == "N" ) ? '': selectedRecord.get('CUSTOM_CODE'),
				'CUSTOM_NAME'	: (Ext.isEmpty(selectedRecord) || baseInfo.customCodeCopy == "N" ) ? '': selectedRecord.get('CUSTOM_NAME'),
				'POSTIT_YN':'N',
				'INPUT_PATH':gsInputPath,
				'INPUT_USER_ID':UserInfo.userID,
				'CHARGE_CODE':slipForm.getValue('CHARGE_CODE')
			};
			
			var mRow = grid.createRow(r);
			addLoading = false;
			
			UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, mRow, slipForm.getValue('IN_DIV_CODE'));
		}
		,fnSetBillDate: function(record) {
			
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
																			})
												  );
			if(fRecord) {
				gsInputDivi = fRecord.get('INPUT_DIVI');
			}
		},
		fnGetProofKind:function(record, billType) {
			var sSaleDivi, sProofKindSet, sBillType = billType;
			
			if(record.get("DR_CR") == "1" && record.get("SPEC_DIVI") == "F1") {
				sSaleDivi = "1" ;   // 매입
				if(sBillType == "")  sBillType = "51";
					
			}else if(record.get("DR_CR") == "2" && record.get("SPEC_DIVI") == "F2") {
				sSaleDivi = "2"	 // 매출
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
			if(selRecord) sProofKindNm =	selRecord.get("text");
			
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
						alert(Msg.sMA0278);
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
						alert(Msg.sMA0006);
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
			
				// 전자발행여부 default 설정
				for(var i =1 ; i <= 6; i++) {
					if(record.get('AC_CODE'+i.toString()) == "I7" ) {
						record.set('AC_DATA'+i.toString(), defaultValue);
						record.set('AC_DATA_NAME'+i.toString(), defaultValueName);
						
					}
				};
				var form = this.getActiveForm()
				form.setActiveRecord((record.type=='grid') ? record.obj:record);
				
			}
		},
		fnSetDefaultAcCodeA6:function(record) {
			if(baseInfo.gbAutoMappingA6 != "Y" ) {
				return;
			}
			for(var i =1 ; i <= 6; i++) {
				if(record.get('AC_CODE'+i.toString()) == "A6" ) {
					record.set('AC_DATA'+i.toString(), baseInfo.gsChargePNumb);
					record.set('AC_DATA_NAME'+i.toString(), baseInfo.gsChargePName);
				}
			}
			var form = this.getActiveForm()
			form.setActiveRecord( (record.type=='grid') ? record.obj:record);
		},
		fnSetDefaultAcCodeI5:function(record, newValue) {
			var form = this.getActiveForm();
			var proofKind = newValue ? newValue : record.get("PROOF_KIND");
			for(var i =1 ; i <= 6; i++) {
				if(record.get('AC_CODE'+i.toString()) == "I5" ) {
					if(Ext.isEmpty(record.get('AC_DATA'+i.toString())) && !Ext.isEmpty(proofKind)) {
						record.set('AC_DATA'+i.toString(), proofKind);
						form.setValue('AC_DATA'+i.toString(), proofKind);
					} else if(!Ext.isEmpty(record.get('AC_DATA'+i.toString())) && Ext.isEmpty(proofKind)) {
						record.set("PROOF_KIND", record.get('AC_DATA'+i.toString()));
					} else {
						record.set('AC_DATA'+i.toString(), proofKind);
						form.setValue('AC_DATA'+i.toString(), proofKind);
						record.set("PROOF_KIND", proofKind);
					}
					var defaultValue = record.get('AC_DATA'+i.toString())
					var param = {
						'MAIN_CODE':'A022',
						'SUB_CODE' : defaultValue,
						'field' : 'text'
					};
					defaultValueName = UniAccnt.fnGetRefCode(param);
					record.set('AC_DATA_NAME'+i.toString(), defaultValueName);
					form.setValue('AC_DATA_NAME'+i.toString(), defaultValueName);
				}
			}
		},
	
		fnCheckNoteAmt:function(grid, record, damt, dOldAmt, fieldName) {
			var lAcDataCol;
			var sSpecDivi, sDrCr;
			var isNew = false;
			
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
			
			if(Ext.isEmpty(record.get(lAcDataCol))) {
				isNew = true;
				this.fnSetTaxAmt(record);
				return;
			}
			
			sSpecDivi = record.get('SPEC_DIVI'); 
			sDrCr =  record.get('DR_CR');  
			var noteNum = record.get(lAcDataCol);
			UniAccnt.fnGetNoteAmt(UniAppManager.app.cbCheckNoteAmt,noteNum, 0,0, record.get('PROOF_KIND'), damt, dOldAmt, record , fieldName)
								  
			
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
				
				this.fnSetAcCode(record, "I1", dSupplyAmt)  // 공급가액
				this.fnSetAcCode(record, "I6", dTaxAmt)	 // 세액'
			}
			
			
		},
		fnCalTaxAmt:function(record) {
			UniAccnt.fnGetTaxRate(UniAppManager.app.cbGetTaxAmtForSales, record)
		},
		fnProofKindPopUp:function(record, newValue, gridId) {
			var proofKind = newValue ? newValue : record.get("PROOF_KIND");
			record.set("REASON_CODE", '');
			record.set("CREDIT_NUM", '');
			// 증빙유형 - 증빙사유 코드 팝업
			//comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입불공제사유', 'AU', 'A070', 'VALUE');
			//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, null, null, null,  'VALUE')   
			//openCrediNotWin(record);
			
			//고정자산
			if(proofKind == "55" || proofKind == "61" || proofKind == "68" || proofKind == "69" ) {
				openAsstInfo(record);
			}
			
			//매입세액불공제/고정자산매입(불공)
			if(proofKind == "54" || proofKind == "61" ) {
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				record.set('CREDIT_NUM', '');			   
				
			//신용카드매입/신용카드매입(고정자산)/신용카드(의제매입)/신용카드(불공제)
			}else if(proofKind == "53" || proofKind == "68" || proofKind == "64") {			   
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null, "CREDIT_NUM", null, null, null,  'VALUE', gridId);		  
				record.set("REASON_CODE",  "");
		
			//현금영수증매입/현금영수증(고정자산)/현금영수증(불공제)
			}else if (proofKind == '62' ||proofKind == '69' ) {
				openCrediNotWin(record);
				record.set("REASON_CODE", '');
				
			//신용카드매입(불공제)
			}else if (proofKind == "70" ) {
				//openCrediNotWin(record);	  
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null,"CREDIT_NUM", null, null, null,  'VALUE', gridId);		  
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				
			//현금영수증(불공제)
			} else if(proofKind == "71" ) {
				openCrediNotWin(record);
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				
				//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM'), "CREDIT_NUM", null, null, null, null,  'VALUE');
		
			//카드과세/면세/영세
			} else if( proofKind >= "13" && proofKind <= "17") {			   
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null,"CREDIT_NUM", null, null, null,  'VALUE', gridId);			  
				record.set("REASON_CODE", '');
			//고정자산정보
			} else if(proofKind == "55" ) {
				//상단에서 호출함
				//openAsstInfo(record);
			}else { 
				record.set("REASON_CODE", '');
				record.set("CREDIT_NUM", '');
			}
			UniAppManager.app.fnSetDefaultAcCodeI5(record, newValue);
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
				
				this.fnSetAcCode(record, "I1", dSupplyAmt)  // 공급가액
				this.fnSetAcCode(record, "I6", dTaxAmt)	 // 세액'
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
				alert(Msg.sMA0306);
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
							alert(Msg.sMA0330);
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
							alert(Msg.sMA0332);
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
			record.set('BILL_DIV_CODE', billDivCode);
		}
	
	}); // Main
	
		Unilite.createValidator('validator01', {
		store : directMasterStore2,
		grid: masterGrid1,
		forms: {'formA:':detailForm1},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue) {
				return true;
			}
			var rv = true;
			switch(fieldName) {
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
						record.set('SLIP_DIVI',"3");
						if(record.get('CR_AMT_I') != 0 ) {
							record.set('DR_AMT_I',record.get('CR_AMT_I'));
						}
						record.set('CR_AMT_I',0);
						record.set('AMT_I',record.get('DR_AMT_I'));
						
					}else{
						
						record.set('SLIP_DIVI',"4");
						if(record.get('DR_AMT_I') != 0 ) {
							record.set('CR_AMT_I',record.get('DR_AMT_I'));
						}
						record.set('DR_AMT_I',0);
						record.set('AMT_I',record.get('CR_AMT_I'));
						
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
					
					//UniAppManager.app.fnSetBillDate(record);
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					//UniAppManager.app.fnSetDefaultAcCodeI7(record)

					// 입력자의 사번을 이용해 관리항목(사번) 기본값 설정
					//UniAppManager.app.fnSetDefaultAcCodeA6(record)	
					break;
				case 'DR_AMT_I' :
					
					if(record.get('SLIP_DIVI') == '1' || record.get('SLIP_DIVI') == '4' ) {
						rv =false;
						return rv;
					}
					var specDivi = record.get("SPEC_DIVI");
					if(specDivi && specDivi.substring(0,1) == "D" ) {
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue, fieldName)
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
						UniAppManager.app.fnCheckNoteAmt(this.grid, record, newValue, oldValue, fieldName)
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
					UniAppManager.app.fnProofKindPopUp(record, newValue, this.grid.getId());
					UniAppManager.app.fnSetTaxAmt(record)
					// 증빙유형의 참조코드1에 따라 전자발행여부 기본값 설정
					UniAppManager.app.fnSetDefaultAcCodeI7(record, newValue)
					break;
				case 'DIV_CODE':
					UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, record, newValue);
					break;
				case 'MONEY_UNIT':
					if(newValue != oldValue){
						  if(!Ext.isEmpty(newValue)) {
							  var agrid = this.grid
							  agrid.mask();
							  accntCommonService.fnGetExchgRate(
								  {
									  'AC_DATE':  UniDate.getDbDateStr(record.get('AC_DATE')),
									  'MONEY_UNIT':newValue													   
								  }, 
								  function(provider, response){
									  agrid.unmask();
									  if(!Ext.isEmpty(provider['BASE_EXCHG'])) {
										  record.set('EXCHG_RATE_O',provider['BASE_EXCHG'])
										  var amtField = "DR_AMT_I";
										  if(record.get("DR_CR") == '2') {
											  amtField = "CR_AMT_I";
										  }
										  setForeignAmt(record.obj, newValue, provider['BASE_EXCHG'], record.get("FOR_AMT_I"), amtField)  ;
									  }
								  }
							  )
						  } 
						
					}
					break;
				case 'EXCHG_RATE_O':
						var amtField = "DR_AMT_I";
						if(record.get("DR_CR") == '2') {
					  	  amtField = "CR_AMT_I";
						}
						setForeignAmt(record.obj, record.get("MONEY_UNIT") , newValue, record.get("FOR_AMT_I"), amtField)  ;
					break;
				case 'FOR_AMT_I':
						var amtField = "DR_AMT_I";
						if(record.get("DR_CR") == '2') {
					  	  amtField = "CR_AMT_I";
						}
						setForeignAmt(record.obj, record.get("MONEY_UNIT") , record.get("EXCHG_RATE_O"),  newValue, amtField)  ;
						break;
				
				default:
					break;
			}
			if(!record.obj.phantom && UniUtils.indexOf(fieldName, doNotModifiedFields) ) {
				rv =false
			}
			return rv;
			
		}
	}); // validator01
	
	Unilite.createValidator('validator02', {
		store : detailStore,
		grid: pendGrid,
		forms: {},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue) {
				return true;
			}
			var rv = true;
			switch(fieldName) {
				case 'J_AMT_I' :
					//if(record.obj.phantom) {
						if(record.get("BLN_I")  > 0 && newValue < 0)	{
							rv = "반제가능급액이 0보다 크므로 반제금액을 0보다 작은 금액을 입력할 수 없습니다.";
							break;
						}
						if(record.get("BLN_I")  < 0 && newValue > 0)	{
							rv = "반제가능급액이 0보다 작으므로 반제금액을 0보다 큰 금액을 입력할 수 없습니다.";
							break;
						}
						if((record.get("BLN_I") > 0 && newValue > record.get("BLN_I")) || (record.get("BLN_I") < 0 && newValue < record.get("BLN_I"))) {
							rv = "반제 금액이 초과되었습니다.";
						}
					//}
					break;
				case 'FOR_J_AMT_I' :
					//if(record.obj.phantom) {
						if(record.get("FOR_BLN_I")  > 0 && newValue < 0)	{
							rv = "외화 반제가능급액이 0보다 크므로 반제금액을 0보다 작은 금액을 입력할 수 없습니다.";
							break;
						}
						if(record.get("FOR_BLN_I")  < 0 && newValue > 0)	{
							rv = "외화 반제가능급액이 0보다 작으므로 반제금액을 0보다 큰 금액을 입력할 수 없습니다.";
							break;
						}
						if((record.get("FOR_BLN_I") > 0 && newValue > record.get("FOR_BLN_I")) || (record.get("FOR_BLN_I") < 0 && newValue < record.get("FOR_BLN_I"))) {
							rv = "반제 금액이 초과되었습니다.";
						} else {
							var exchangeRate = record.get("EXCHG_RATE_O");
							var jAmtI = newValue * exchangeRate;
							var numDigit;
							if(UniFormat.Price.indexOf(".") > -1) {
								numDigit = (UniFormat.Price.length - (UniFormat.Price.indexOf(".")+1));
							}
							jAmtI = UniAccnt.fnAmtWonCalc(jAmtI, baseInfo.gsAmtPoint, numDigit);
							record.set("J_AMT_I",jAmtI) ;

							UniAppManager.app.fnSetAcCode(record, 'D1', newValue, null)  ;
						}
					//}
				default:
					break;
			}
			return rv;
			
		}
	}); // validator02
}; // main
</script>