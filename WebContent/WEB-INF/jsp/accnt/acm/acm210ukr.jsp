<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="acm210ukr"> 
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A001"/><!-- 차대구분-->
	<t:ExtComboStore comboType="AU" comboCode="A022"/><!-- 매입증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004"/><!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A149"/><!-- 증빙유형의 참조코드1 -->
	<t:ExtComboStore comboType="AU" comboCode="A016"/><!-- 자산부채특성 -->
	<t:ExtComboStore comboType="AU" comboCode="A070"/><!-- 매입세불공제사유 -->
</t:appConfig>

<script type="text/javascript" >

var csINPUT_DIVI	= "3";	//1:결의전표/2:결의전표(전표번호별)
var csSLIP_TYPE		= "1";	//1:회계전표/2:결의전표
var csSLIP_TYPE_NAME= "회계전표";
var csINPUT_PATH	= 'C1';
var gsChargeDivi	= '${gsChargeDivi}';
var gsInputPath		= "C1", gsInputDivi;
var creditNoWin;			// 신용카드번호 & 현금영수증 팝업
var comCodeWin ;			// A070 증빙유형팝업
var creditWIn;				// 신용카드팝업
var multipleDivCodeAllowYN	= '${multipleDivCodeAllowYN}';
var tab;
var searchPopup;			// 입출금 내역 조회 팝업
var clickedGrid = 'acm210ukrGrid1';
var addLoading = false;		// 전표번호 생성 flag
var doNotModifiedFields = [  'INPUT_PATH'	,'INPUT_DIVI'	,'AUTO_SLIP_NUM','INPUT_DATE'	,'INPUT_USER_ID'
							,'CHARGE_CODE'	,'AP_DATE'		,'AP_USER_ID'	,'AP_CHARGE_CODE'	,'AC_DATE'
							,'SLIP_NUM'		,'SLIP_SEQ'		,'INPUT_PATH'	,'INPUT_DIVI'];
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
				read	: 'acm210ukrService.selectList',
				update	: 'acm210ukrService.update',
				create	: 'acm210ukrService.insert',
				destroy	: 'acm210ukrService.delete',
				syncAll	: 'acm210ukrService.saveAll'
			}
		});
	var detailDirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'acm210ukrService.selectList2'
		}
	});
	<%@include file="../agj/accntGridConfig.jsp"%>

	/** 일반전표 Store 정의(Service 정의)
	 * @type 
	 */
	Unilite.defineModel('acm210ukrv', {
		fields: [ 
			 {name: 'AC_DAY'			,text:'일자'				,type : 'string', allowBlank:false,maxLength:2} 
			,{name: 'SLIP_NUM'			,text:'번호'				,type : 'int'	, allowBlank:false,maxLength:7} 
			,{name: 'SLIP_SEQ'			,text:'순번'				,type : 'int'	, editable:false} 
			,{name: 'SLIP_DIVI'			,text:'구분'				,type : 'string', allowBlank:false, defaultValue:'3', comboType:'A', comboCode:'A005'} 
			,{name: 'ACCNT'				,text:'계정코드'			,type : 'string', allowBlank:false,maxLength:16} 
			,{name: 'ACCNT_NAME'		,text:'계정과목명'			,type : 'string', allowBlank:false,maxLength:50} 
			,{name: 'CUSTOM_CODE'		,text:'거래처'				,type : 'string', maxLength:8} 
			,{name: 'CUSTOM_NAME'		,text:'거래처명'			,type : 'string', maxLength:40} 
			,{name: 'DR_AMT_I'			,text:'차변금액'			,type : 'uniPrice'} 
			,{name: 'CR_AMT_I'			,text:'대변금액'			,type : 'uniPrice', maxLength:30} 
			,{name: 'REMARK'			,text:'적요'				,type : 'string',  maxLength:100 } 
			,{name: 'PROOF_KIND_NM'		,text:'증빙유형'			,type : 'string'}
			,{name: 'DEPT_NAME'			,text:'귀속부서'			,type : 'string', allowBlank:false, defaultValue:baseInfo.gsDeptName,maxLength:30}
			,{name: 'DIV_CODE'			,text:'사업장'				,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue:UserInfo.divCode}
			,{name: 'OLD_AC_DATE'		,text:'OLD_AC_DATE'		,type : 'uniDate'} 
			,{name: 'OLD_SLIP_NUM'		,text:'OLD_SLIP_NUM'	,type : 'int'} 
			,{name: 'OLD_SLIP_SEQ'		,text:'OLD_SLIP_SEQ'	,type : 'int'}
			,{name: 'AC_DATE'			,text:'전표일자'			,type : 'uniDate'} 
			,{name: 'DR_CR'				,text:'차대구분'			,type : 'string', defaultValue:'1', comboType:'AU', comboCode:'A001' } 
			,{name: 'P_ACCNT'			,text:'상대계정코드'			,type : 'string'}
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
			,{name: 'INPUT_PATH'		,text:'입력경로'			,type : 'string', defaultValue: gsInputPath} 
			,{name: 'INPUT_DIVI'		,text:'전표입력경로'			,type : 'string', defaultValue: csINPUT_DIVI} 
			,{name: 'AUTO_SLIP_NUM'		,text:'자동기표번호'			,type : 'string'}
			,{name: 'INPUT_DATE'		,text:'입력일자'			,type : 'string'}
			,{name: 'INPUT_USER_ID'		,text:'입력자ID'			,type : 'string'}
			,{name: 'CHARGE_CODE'		,text:'담당자코드'			,type : 'string'}
			,{name: 'CHARGE_NAME'		,text:'담당자명'			,type : 'string'}
			,{name: 'AP_DATE'			,text:'승인처리일'			,type : 'string'}
			,{name: 'AP_USER_ID'		,text:'승인자ID'			,type : 'string'}
			,{name: 'AP_CHARGE_CODE'	,text:'담장자ID'			,type : 'string'}
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
			,{name: 'OPR_FLAG'			,text:'editFlag'		,type : 'string', defaultValue:'L'}
			,{name: 'store2Idx'			,text:'store2Idx'		,type : 'string'}
			//========================================================================================
			,{name: 'APPR_AMT_I'		,text: '금액'	 			,type: 'uniPrice'}
			,{name: 'DEPT_NAME'			,text: '귀속부서'			,type: 'string'}
			
			,{name: 'APPR_DATE'			,text: '승인일자'			,type: 'uniDate'}
			,{name: 'APPR_NO'			,text: '승인번호'			,type: 'string'}
		]
	});
	// 참조 filter
	var apprCardRefFilter = new Ext.util.Filter({
		filterFn: function(item) {
			return item.get("FLAG") == "R";
		}
	});
	var directMasterStore1 = Unilite.createStore('acm210ukrMasterStore1',{
		model: 'acm210ukrv',
		autoLoad: false,
		uniOpt : {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false,		// prev | next 버튼 사용
			allDeletable : true
		},
		proxy : directProxy, // proxy
		// Store 관련 BL 로직
		// 검색 조건을 통해 DB에서 데이터 읽어 오기
		loadStoreRecords : function(records) {
			var param ;
			
			var me = this;
			slipStore1.removeAll();
			slipStore2.removeAll();
			
			if(!Ext.isEmpty(records) && !Ext.isDefined(records[0].data)) {
				Ext.each(records, function(record){
					var newRecord =  Ext.create (me.model, record);
					me.insert(0,newRecord);
				});
				
			} else {
				Ext.each(records, function(record){
					var newRecord =  Ext.create (me.model, record.data);
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
			var activeTab;
			var activeTabId;
			
			if(tab) {
				activeTab = tab.getActiveTab();
				activeTabId = activeTab.getItemId();
			}else {
				activeTabId = 'agjTab1'
			}
			var paramMaster = {};

			var insertRecords  = this.getNewRecords();
			var updateRecords  = this.getUpdatedRecords();
			var removedRecords = this.getRemovedRecords();

			//N: 신규, U: 수정, D : 삭제
			Ext.each(insertRecords	, function(record){record.set('OPR_FLAG', 'N')})
			Ext.each(updateRecords	, function(record){record.set('OPR_FLAG', 'U')})
			Ext.each(removedRecords	, function(record){record.set('OPR_FLAG', 'D')})

			var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
			Ext.each(changedRec, function(cRec){
				if(Ext.isEmpty(cRec.get('CHARGE_CODE'))) {
					cRec.set('CHARGE_CODE', slipForm.getValue('CHARGE_CODE'));
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

			updateRecords = this.getUpdatedRecords();
			
			//관리항목 필수 사항 체크, 순번 저장
			var saveRec	= [].concat(updateRecords).concat(insertRecords);
			var tempRec	= [].concat(updateRecords).concat(removedRecords);  // 신규 데이터 old_ext_seq 값 생성을 위해 사용
			var slipSeq	= 1
			var chk		= true;
			var tmpI	= tempRec.length + 1;		// 신규 데이터 old_ext_seq 값 생성을 위해 사용

			Ext.each(saveRec, function(rec, idx){
				//순번 저장
				var viewIdx = directMasterStore2.findBy( function(data2Rec, idx){return data2Rec.getId() == rec.get("store2Idx")});
				var viewRecord = directMasterStore2.getAt(viewIdx);
				var viewPendIdx = detailStore.findBy( function(pandRec, idx){return pandRec.getId() == rec.get("store2Idx")});
				
				var viewapprCardGrid = detailStore.getAt(viewPendIdx)
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
			if(saveRec.length > 0 && apprCardGrid.getStore().count() == 0) {
				chk = false;
				Unilite.messageBox("입출금 내역이 존재하지 않습니다.");
			}
			if(!chk) {
				return;
			}
			
			//차대변 금액이 일치하는지 검사
			var checkDCSum = this.checkSum();
			if(checkDCSum !== true) {
					alert(Msg.sMA0052+'\n'+'전표번호:'+checkDCSum);
				return;
			}
			//같은 전표안에서 대체차변, 대체대변과 입금, 출금이 동시에 존재하는지를 체크
			if(!this.checkDivi()) {
				return;
			}
			
			Ext.each(insertRecords, function(rec){
				rec.set('OLD_AC_DATE'	, rec.get('AC_DATE'));
				rec.set('OLD_SLIP_NUM'	, rec.get('SLIP_NUM'));
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
									var rSlipNum = batch.operations[0]._resultSet.SLIP_NUM
									panelSearch.setValue("SLIP_NUM", rSlipNum);
									slipForm.setValue("SLIP_NUM", rSlipNum);
									
									var rRecord2 = directMasterStore2.getData();
									Ext.each(rRecord2.items, function(item, idx){
										item.set('SLIP_NUM',rSlipNum );
										item.set('OLD_SLIP_NUM',rSlipNum );
									})
									
									// 저장 or 수정
									if(batch.operations[0]._resultSet.FLAG == "S") {
										UniAppManager.app.onQueryButtonDown();
									// 삭제
									} else {
										UniAppManager.app.onResetButtonDown();
									}
								}
							}
							Ext.getBody().unmask();
						} ,
						callback : function(responseText, arg0, arg1)	{
							console.log("responseText",responseText);
							console.log("arg0",arg0);
							console.log("arg1",arg1);
							Ext.getBody().unmask();
						}
				}
				this.syncAllDirect(config);
			}else {
				Unilite.messageBox(Msg.sMB083); // 필수입력 항목입니다.
			}
		},
		// 차대변 금액 확인
		checkSum:function() {
			var insertRecords  = this.getNewRecords();
			var updateRecords  = this.getUpdatedRecords();
			var removedRecords = this.getRemovedRecords();
			var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
			var rtn = true;
			var store = this;
			Ext.each(changedRec, function(rec) {
				var cr_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY') == rec.get("AC_DAY") && record.get('SLIP_NUM') == rec.get("SLIP_NUM") && record.get('DR_CR') == '2') } ).items);
				var dr_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY') == rec.get("AC_DAY") && record.get('SLIP_NUM') == rec.get("SLIP_NUM") && record.get('DR_CR') == '1') } ).items);
				
				var crSum = 0;
				var crLen = cr_data.length;
				var drSum = 0;
				var drLen = dr_data.length;
				if(rec.get('SLIP_DIVI') != 1 && rec.get('SLIP_DIVI') != 2) {
					
					Ext.each(cr_data, function(item){
						crSum += item.get("AMT_I");
						if(drLen == 1) {
							item.set('P_ACCNT', dr_data[0].get('ACCNT'));
						}else {
							item.set('P_ACCNT', '99999');
						}
						
						
					})
					Ext.each(dr_data, function(item){
						drSum += item.get("AMT_I");
						if(crLen == 1) {
							item.set('P_ACCNT', cr_data[0].get('ACCNT'));
						}else {
							item.set('P_ACCNT', '99999');
						}
					})
					console.log("crSum : ", crSum ," drSum =",drSum);
					
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
			var insertRecords  = this.getNewRecords();
			var updateRecords  = this.getUpdatedRecords();
			var removedRecords = this.getRemovedRecords();
			
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
			var insertRecords=this.getNewRecords();
			var updateRecords=this.getUpdatedRecords();
			//20200813 추가: detailStore의 데이터도 체크하도록 로직 추가
			var insertRecords2 = detailStore.getNewRecords();
			var updateRecords2 = detailStore.getUpdatedRecords();
			//20200813 수정: detailStore의 데이터도 체크하도록 로직 수정;
			var changedRec = [].concat(insertRecords).concat(updateRecords).concat(insertRecords2).concat(updateRecords2);

			var rtn = true;
			//20200813 수정: detailStore의 데이터도 체크하고 사업장 부터 체크한 후 부서 체크도록 로직 전체수정
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
							if(multipleDivCodeAllowYN == 'N') {
								err_msg1 = '사업장이 다른 전표가 있습니다.';
								rtn = false;
								cDiv_code_checked = true;
							}
						}
					}
					if(rtn && !cDept_code_checked) {
						if(cDept_code != data.get("DEPT_CODE")) {
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

			var grid = UniAppManager.app.getActiveGrid();
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
							item.set('APPR_AMT_I'		, tRec.get("APPR_AMT_I"));
							item.set('OPR_FLAG'		, "L");
						}
					})
					detailStore.commitChanges();
				}
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('acm210ukrMasterStore2',{
			model    : 'acm210ukrv',
			autoLoad : false,
			uniOpt   : {
				isMaster	: false,	// 상위 버튼 연결
				editable	: true,		// 수정 모드 사용
				deletable	: true,		// 삭제 가능 여부
				useNavi		: false		// prev | next 버튼 사용
			},
			proxy : directProxy, // proxy
			// Store 관련 BL 로직
			// 검색 조건을 통해 DB에서 데이터 읽어 오기
			loadStoreRecords : function() {
				var param ;
				var form = Ext.getCmp('searchForm');
				
				if(form.isValid()) {
					param = form.getValues();
					UniAppManager.app.setSearchReadOnly(true);
					this.load({
							params   : param,
							callback : function(records, operation, success) {
								
								if(!Ext.isEmpty(records) && records.length > 0 ) {
									slipForm.setValue("AC_DATE"    ,records[0].get("AC_DATE"));
									slipForm.setValue("SLIP_NUM"   , records[0].get("SLIP_NUM"));
									slipForm.setValue("DIV_CODE"   , records[0].get("DIV_CODE"));
									slipForm.setValue("DEPT_CODE"  , records[0].get("DEPT_CODE"));
									slipForm.setValue("DEPT_NAME"  , records[0].get("DEPT_NAME"));
									slipForm.setValue("CHARGE_CODE", records[0].get("CHARGE_CODE"));
									slipForm.setValue("CHARGE_NAME", records[0].get("CHARGE_NAME"));

									gsInputDivi  = records[0].get("INPUT_DIVI");
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
	Unilite.defineModel('Acm210ukrApprCardModel', {
		fields: [{name: 'SLIP_SEQ'		,text: '순번'				,type: 'int'},
			 {name: 'ACCNT'				,text: '계정코드'			,type: 'string'},
			 {name: 'ACCNT_NAME'		,text: '계정과목명'			,type: 'string'},

			 {name: 'PEND_YN'			,text: '미결항목여부'	 		,type: 'string'},
			 {name: 'MONEY_UNIT'		,text: '화폐단위'			,type: 'string'},
			 {name: 'REMARK'			,text: '적요'				,type: 'string'},
			 
			 {name: 'DEPT_NAME'			,text: '귀속부서'			,type: 'string'},
			 {name: 'DIV_NAME'			,text: '귀속사업장'			,type: 'string'},

			 {name: 'OLD_AC_DATE'		,text: 'OLD_AC_DATE'	,type: 'uniDate'},
			 {name: 'OLD_SLIP_NUM'		,text: 'OLD_SLIP_NUM'	,type: 'int'},
			 {name: 'OLD_SLIP_SEQ'		,text: 'OLD_SLIP_SEQ'	,type: 'int'},

			 {name: 'SEQ'				,text: 'SEQ'			,type: 'int'},
			 {name: 'P_ACCNT'			,text: ''				,type: 'string'},
			 {name: 'INPUT_PATH'		,text: ''				,type: 'string'},
			 {name: 'DEPT_CODE'			,text: ''				,type: 'string'},
			 {name: 'BILL_DIV_CODE'		,text: ''				,type: 'string'},
			 {name: 'DR_CR'				,text: '차대구분'			,type: 'string', defaultValue:'1', comboType:'AU', comboCode:'A001'},
			 {name: 'CUSTOM_CODE'		,text: '거래처코드'			,type: 'string'},
			 {name: 'CUSTOM_NAME'		,text: '거래처명'			,type: 'string'},
			 
			 {name: 'ACCNT_SPEC'		,text: ''				,type: 'string'},
			 {name: 'SPEC_DIVI'			,text: ''				,type: 'string'},
			 {name: 'PROFIT_DIVI'		,text: ''				,type: 'string'},
			 {name: 'JAN_DIVI'			,text: ''				,type: 'string'},
			 {name: 'BUDG_YN'			,text: ''				,type: 'string'},
			 {name: 'BUDGCTL_YN'		,text: ''				,type: 'string'},
			 {name: 'FOR_YN'			,text: ''				,type: 'string'},
			 {name: 'DIV_CODE'			,text: '귀속사업장'			,type: 'string', comboType:'BOR120'},
			
			 {name: 'AC_CODE1'			,text:'관리항목코드1'			,type : 'string'} 
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
			,{name: 'AC_CTL1'			,text:'관리항목필수1'	 		,type : 'string'}
			,{name: 'AC_CTL2'			,text:'관리항목필수2'			,type : 'string'}
			,{name: 'AC_CTL3'			,text:'관리항목필수3'			,type : 'string'}
			,{name: 'AC_CTL4'			,text:'관리항목필수4'			,type : 'string'}
			,{name: 'AC_CTL5'			,text:'관리항목필수5'			,type : 'string'}
			,{name: 'AC_CTL6'			,text:'관리항목필수6'			,type : 'string'}
			
			,{name: 'BOOK_CODE1'		,text:''				,type : 'string'}
			,{name: 'BOOK_CODE2'		,text:''				,type : 'string'}
			,{name: 'BOOK_DATA1'		,text:''				,type : 'string'}
			,{name: 'BOOK_DATA2'		,text:''				,type : 'string'}
			,{name: 'BOOK_DATA_NAME1'	,text:''				,type : 'string'}
			,{name: 'BOOK_DATA_NAME2'	,text:''				,type : 'string'}

			,{name: 'AP_CHARGE_NAME'	,text:''				,type : 'string'}
			,{name: 'OPR_FLAG'			,text:''				,type : 'string',   defaultValue:'L'} 
			,{name: 'INPUT_USER_ID'		,text:''				,type : 'string'}
			
			,{name: 'AP_DATE'			,text: '승인처리일'			,type : 'string'}
			,{name: 'AP_USER_ID'		,text: '승인자ID'			,type : 'string'}
			,{name: 'AP_CHARGE_CODE'	,text: '담장자ID'			,type : 'string'}
			
			,{name: 'APPR_DATE'			,text: '승인일자'			,type: 'string'}
			,{name: 'APPR_NO'			,text: '승인번호'			,type: 'string'}
			
			,{name: 'PROOF_KIND'		,text: '증빙유형'			,type : 'string',  maxLength:2, comboType:'AU', comboCode:'A022'}
			
			,{name: 'CREDIT_NUM'		,text:'카드번호/현금영수증'		,type : 'string', editable:false}
			,{name: 'CREDIT_NUM_EXPOS'	,text:'카드번호/현금영수증'		,type : 'string', editable:false}
			
			,{name: 'CREDIT_CODE'		,text: '카드코드'			,type: 'string'}
			,{name: 'CRDT_NAME'			,text: '카드명'			,type: 'string'}
			,{name: 'APPR_AMT_I'		,text: '금액'				,type: 'uniPrice'}
			
		 ]
	});

	var detailStore = Unilite.createStore('acm210ukrDetailStore',{
		model: 'Acm210ukrApprCardModel',
		uniOpt : {
			isMaster:   true,		// 상위 버튼 연결 
			editable:   true,		// 수정 모드 사용 
			deletable:  true,		// 삭제 가능 여부 
			useNavi :   false,		// prev | newxt 버튼 사용
			allDeletable : true
		},
		autoLoad : false,
		proxy    : detailDirectProxy,
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
				var sDate         = slipForm.getValue("AC_DATE");
				var slipNum       = slipForm.getValue("SLIP_NUM");
				var sDay          = Ext.Date.format(sDate, 'd').toString();
				var maxSeq        = Unilite.nvl(directMasterStore1.max("SLIP_SEQ"),0) ;

				Ext.each(records, function(record, idx){
					var seq = maxSeq +1;
					
					masterRecords.push({
						  'AC_DATE'			: record.get("AC_DATE")
						, 'SLIP_NUM'		: record.get("SLIP_NUM")
						, 'AC_DAY'			: sDay
						
						, 'SLIP_SEQ'		: record.get("SLIP_SEQ")
						, 'SLIP_DIVI'		: record.get("DR_CR") == "1" ? "3":"4"
						, 'ACCNT'			: record.get("ACCNT")
						, 'ACCNT_NAME'		: record.get("ACCNT_NAME")
						, 'CUSTOM_CODE'		: record.get("CUSTOM_CODE")
						, 'CUSTOM_NAME'		: record.get("CUSTOM_NAME")
						, 'DR_AMT_I'		: record.get("DR_CR") == "1" ? record.get("APPR_AMT_I")  : 0
						, 'CR_AMT_I'		: record.get("DR_CR") == "2" ? record.get("APPR_AMT_I") : 0
						, 'REMARK'			: record.get("REMARK")
						, 'DIV_CODE'		: record.get("DIV_CODE")
						, 'OLD_AC_DATE'		: record.get("OLD_AC_DATE")
						, 'OLD_SLIP_NUM'	: record.get("OLD_SLIP_NUM")
						, 'OLD_SLIP_SEQ'	: record.get("OLD_SLIP_SEQ")
						
						, 'DR_CR'			: record.get("DR_CR")
						, 'DEPT_CODE'		: record.get("DEPT_CODE")
						, 'MONEY_UNIT'		: record.get("MONEY_UNIT")

						, 'IN_DIV_CODE'		: record.get("IN_DIV_CODE") ? record.get("IN_DIV_CODE")   : UserInfo.divCode
						, 'IN_DEPT_CODE'	: record.get("IN_DEPT_CODE") ? record.get("IN_DEPT_CODE") : baseInfo.gsDeptCode
						, 'IN_DEPT_NAME'	: record.get("IN_DEPT_NAME") ? record.get("IN_DEPT_NAME") : baseInfo.gsDeptName

						, 'BILL_DIV_CODE'	: record.get("BILL_DIV_CODE")

						, 'AC_CODE1'		: record.get("AC_CODE1")
						, 'AC_CODE2'		: record.get("AC_CODE2")
						, 'AC_CODE3'		: record.get("AC_CODE3")
						, 'AC_CODE4'		: record.get("AC_CODE4")
						, 'AC_CODE5'		: record.get("AC_CODE5")
						, 'AC_CODE6'		: record.get("AC_CODE6")
						
						, 'AC_NAME1'		: record.get("AC_NAME1")
						, 'AC_NAME2'		: record.get("AC_NAME2")
						, 'AC_NAME3'		: record.get("AC_NAME3")
						, 'AC_NAME4'		: record.get("AC_NAME4")
						, 'AC_NAME5'		: record.get("AC_NAME5")
						, 'AC_NAME6'		: record.get("AC_NAME6")

						, 'AC_DATA1'		: record.get("AC_DATA1")
						, 'AC_DATA2'		: record.get("AC_DATA2")
						, 'AC_DATA3'		: record.get("AC_DATA3")
						, 'AC_DATA4'		: record.get("AC_DATA4")
						, 'AC_DATA5'		: record.get("AC_DATA5")
						, 'AC_DATA6'		: record.get("AC_DATA6")

						, 'AC_DATA_NAME1'	: record.get("AC_DATA_NAME1")
						, 'AC_DATA_NAME2'	: record.get("AC_DATA_NAME2")
						, 'AC_DATA_NAME3'	: record.get("AC_DATA_NAME3")
						, 'AC_DATA_NAME4'	: record.get("AC_DATA_NAME4")
						, 'AC_DATA_NAME5'	: record.get("AC_DATA_NAME5")
						, 'AC_DATA_NAME6'	: record.get("AC_DATA_NAME6")

						, 'BOOK_CODE1'		: record.get("BOOK_CODE1")
						, 'BOOK_CODE2'		: record.get("BOOK_CODE2")
						, 'BOOK_DATA1'		: record.get("BOOK_DATA1")
						, 'BOOK_DATA2'		: record.get("BOOK_DATA2")
						, 'BOOK_DATA_NAME1'	: record.get("BOOK_DATA_NAME1")
						, 'BOOK_DATA_NAME2'	: record.get("BOOK_DATA_NAME2")
						
						, 'AC_CTL1'			: record.get("AC_CTL1")
						, 'AC_CTL2'			: record.get("AC_CTL2")
						, 'AC_CTL3'			: record.get("AC_CTL3")
						, 'AC_CTL4'			: record.get("AC_CTL4")
						, 'AC_CTL5'			: record.get("AC_CTL5")
						, 'AC_CTL6'			: record.get("AC_CTL6")
						
						, 'P_ACCNT'			: record.get("P_ACCNT") ? record.get("P_ACCNT") : ''
						, 'ACCNT_SPEC'		: record.get("ACCNT_SPEC")
						, 'SPEC_DIVI'		: record.get("SPEC_DIVI")
						, 'PROFIT_DIVI'		: record.get("PROFIT_DIVI")
						, 'JAN_DIVI'		: record.get("JAN_DIVI")

						, 'PEND_CODE'		: record.get("PEND_CODE")
						, 'PEND_DATA_CODE'	: record.get("PEND_DATA_CODE")
						, 'PEND_YN'			: record.get("PEND_YN")
						, 'BUDG_YN'			: record.get("BUDG_YN")
						, 'BUDGCTL_YN'		: record.get("BUDGCTL_YN")
						, 'FOR_YN'			: record.get("FOR_YN")
						
						, 'INPUT_PATH'		: record.get("INPUT_PATH")
						
						, 'EX_DATE'			: record.get("EX_DATE")
						, 'EX_NUM'			: record.get("EX_NUM")
						, 'EX_SEQ'			: record.get("EX_SEQ")

						, 'COMP_CODE'		: UserInfo.comp_code
						, 'AMT_I'			: record.get("APPR_AMT_I")
						
						, 'OPR_FLAG'		: 'N'
						, 'INPUT_USER_ID'	: record.get("INPUT_USER_ID") ? record.get("INPUT_USER_ID") :UserInfo.userID
						
						, 'POSTIT_YN'		:'N'
						, 'store2Idx'		: record.getId()
						
						, 'CHARGE_CODE'		: '${chargeCode}'

						, 'CREDIT_CODE'		: record.get('CREDIT_CODE')
						, 'CREDIT_NUM_EXPOS': record.get('CREDIT_NUM_EXPOS')
						, 'CREDIT_NUM'		: record.get('CREDIT_NUM')
						, 'APPR_AMT_I'		: record.get('APPR_AMT_I')
						, 'DEPT_NAME'		: record.get('DEPT_NAME')
						
						, 'AP_DATE'			: UniDate.get('today')
						, 'AP_USER_ID'		: UserInfo.userID
						, 'AP_CHARGE_CODE'	: '${chargeCode}'
						
						, 'APPR_DATE'		: record.get('APPR_DATE')
						, 'APPR_NO'			: record.get('APPR_NO')
					});
				})
				store.commitChanges();
				directMasterStore1.loadStoreRecords(masterRecords);
			},
			add:function(store, records, index, eOpts ) {
				var sDate   = slipForm.getValue("AC_DATE");
				var slipNum = slipForm.getValue("SLIP_NUM");
				var sDay    = Ext.Date.format(sDate, 'd').toString();
				var maxSeq  = Unilite.nvl(directMasterStore1.max("SLIP_SEQ"),0) ;

				Ext.each(records, function(record, idx) {
					record.set('OPR_FLAG','N');
					maxSeq += 1;
					var r = {
						 'AC_DATE'			: sDate
						, 'SLIP_NUM'		: slipNum
						, 'AC_DAY'			: sDay
						
						, 'SLIP_SEQ'		: maxSeq
						, 'SLIP_DIVI'		: record.get("DR_CR") == "1" ? "3":"4"
						, 'ACCNT'			: record.get("ACCNT")
						, 'ACCNT_NAME'		: record.get("ACCNT_NAME")
						, 'CUSTOM_CODE'		: record.get("CUSTOM_CODE")
						, 'CUSTOM_NAME'		: record.get("CUSTOM_NAME")
						, 'DR_AMT_I'		: record.get("DR_CR") == "1" ? record.get("APPR_AMT_I") : 0
						, 'CR_AMT_I'		: record.get("DR_CR") == "2" ? record.get("APPR_AMT_I") : 0
						, 'REMARK'			: record.get("REMARK")
						, 'DIV_CODE'		: record.get("DIV_CODE")

						
						, 'OLD_AC_DATE'		: sDate
						, 'OLD_SLIP_NUM'	: slipNum
						, 'OLD_SLIP_SEQ'	: maxSeq
						
						, 'DR_CR'			: record.get("DR_CR")
						, 'DEPT_CODE'		: record.get("DEPT_CODE")
						, 'MONEY_UNIT'		: record.get("MONEY_UNIT")

						, 'IN_DIV_CODE'		: UserInfo.divCode
						, 'IN_DEPT_CODE'	: baseInfo.gsDeptCode
						, 'IN_DEPT_NAME'	: baseInfo.gsDeptName
						
						, 'BILL_DIV_CODE'	: record.get("BILL_DIV_CODE")

						, 'AC_CODE1'		: record.get("AC_CODE1")
						, 'AC_CODE2'		: record.get("AC_CODE2")
						, 'AC_CODE3'		: record.get("AC_CODE3")
						, 'AC_CODE4'		: record.get("AC_CODE4")
						, 'AC_CODE5'		: record.get("AC_CODE5")
						, 'AC_CODE6'		: record.get("AC_CODE6")
						
						, 'AC_NAME1'		: record.get("AC_NAME1")
						, 'AC_NAME2'		: record.get("AC_NAME2")
						, 'AC_NAME3'		: record.get("AC_NAME3")
						, 'AC_NAME4'		: record.get("AC_NAME4")
						, 'AC_NAME5'		: record.get("AC_NAME5")
						, 'AC_NAME6'		: record.get("AC_NAME6")

						, 'AC_DATA1'		: record.get("AC_DATA1")
						, 'AC_DATA2'		: record.get("AC_DATA2")
						, 'AC_DATA3'		: record.get("AC_DATA3")
						, 'AC_DATA4'		: record.get("AC_DATA4")
						, 'AC_DATA5'		: record.get("AC_DATA5")
						, 'AC_DATA6'		: record.get("AC_DATA6")
						
						, 'AC_CTL1'			: record.get("AC_CTL1")
						, 'AC_CTL2'			: record.get("AC_CTL2")
						, 'AC_CTL3'			: record.get("AC_CTL3")
						, 'AC_CTL4'			: record.get("AC_CTL4")
						, 'AC_CTL5'			: record.get("AC_CTL5")
						, 'AC_CTL6'			: record.get("AC_CTL6")
						
						, 'AC_DATA_NAME1'	: record.get("AC_DATA_NAME1")
						, 'AC_DATA_NAME2'	: record.get("AC_DATA_NAME2")
						, 'AC_DATA_NAME3'	: record.get("AC_DATA_NAME3")
						, 'AC_DATA_NAME4'	: record.get("AC_DATA_NAME4")
						, 'AC_DATA_NAME5'	: record.get("AC_DATA_NAME5")
						, 'AC_DATA_NAME6'	: record.get("AC_DATA_NAME6")

						, 'BOOK_CODE1'		: record.get("BOOK_CODE1")
						, 'BOOK_CODE2'		: record.get("BOOK_CODE2")
						, 'BOOK_DATA1'		: record.get("BOOK_DATA1")
						, 'BOOK_DATA2'		: record.get("BOOK_DATA2")
						, 'BOOK_DATA_NAME1'	: record.get("BOOK_DATA_NAME1")
						, 'BOOK_DATA_NAME2'	: record.get("BOOK_DATA_NAME2")
						
						, 'P_ACCNT'			: record.get("P_ACCNT") ? record.get("P_ACCNT") : ''
						, 'ACCNT_SPEC'		: record.get("ACCNT_SPEC")
						, 'SPEC_DIVI'		: record.get("SPEC_DIVI")
						, 'PROFIT_DIVI'		: record.get("PROFIT_DIVI")
						, 'JAN_DIVI'		: record.get("JAN_DIVI")

						, 'PEND_YN'			: record.get("PEND_YN")
						, 'BUDG_YN'			: record.get("BUDG_YN")
						, 'BUDGCTL_YN'		: record.get("BUDGCTL_YN")
						, 'FOR_YN'			: record.get("FOR_YN")
						
						, 'INPUT_PATH'		: gsInputPath
						, 'CHARGE_CODE'		: '${chargeCode}'
						
						, 'EX_DATE'			: record.get("EX_DATE")
						, 'EX_NUM'			: record.get("EX_NUM")
						, 'EX_SEQ'			: record.get("EX_SEQ")

						, 'COMP_CODE'		: UserInfo.comp_code
						, 'AMT_I'			: record.get("APPR_AMT_I")
						
						, 'OPR_FLAG'		: 'N'
						
						, 'INPUT_USER_ID'	: record.get("INPUT_USER_ID") ? record.get("INPUT_USER_ID") :UserInfo.userID
						, 'POSTIT_YN'		:'N'
						
						, 'CREDIT_CODE'		: record.get('CREDIT_CODE')
						, 'CREDIT_NUM_EXPOS': record.get('CREDIT_NUM_EXPOS')
						, 'CREDIT_NUM'		: record.get('CREDIT_NUM')
						, 'APPR_AMT_I'		: record.get('APPR_AMT_I')
						
						, 'DEPT_NAME'		: record.get('DEPT_NAME')
						
						, 'AP_DATE'			: UniDate.get('today')
						, 'AP_USER_ID'		: UserInfo.userID
						, 'AP_CHARGE_CODE'	: '${chargeCode}'
						
						, 'APPR_DATE'		: record.get("APPR_DATE")
						, 'APPR_NO'			: record.get("APPR_NO")
					};
					
					
					UniAppManager.app.setSearchReadOnly(true, false);
					var model = directMasterStore1.add(r);
					if(model && model.length > 0)	{
						model[0].set('store2Idx', record.getId());
					}
				})
			},
			update:function(store, record, operation, modifiedFieldNames, details, eOpts){
				var sRecordIdx = directMasterStore1.findBy(function(rec,id){
					return rec.get("APPR_NO")     == record.get("APPR_NO")
						&& rec.get("store2Idx") == record.getId();
				})
				
				if(sRecordIdx != null && sRecordIdx >= 0) {
					var sRecord = directMasterStore1.getAt(sRecordIdx);
					Ext.each(modifiedFieldNames, function(name, idx){
						if("DR_CR" == name){
							sRecord.set(name, record.get("DR_CR"));
							sRecord.set("SLIP_DIVI", record.get("DR_CR") == "1" ? "3":"4");
						}else {
							sRecord.set(name, record.get(name));
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
											return rec.get("APPR_NO")     == record.get("APPR_NO")
												&& rec.get("store2Idx") == record.getId();
										} ).items
									);
					directMasterStore1.remove(sRecords);
					
					// 참조 데이터 
					apprCardRefStore.removeFilter(apprCardRefFilter);
					var refDataIdx = apprCardRefStore.findBy(function(fRecord){
							return fRecord.get("APPR_NO") == record.get("APPR_NO");
						});
					if(refDataIdx > -1) {
						var refData = apprCardRefStore.getAt(refDataIdx);
						refData.set("FLAG","R");
					} 
					apprCardRefStore.addFilter(apprCardRefFilter);
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
			title		: '기본정보',  
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items : [{		
					fieldLabel	: '전표일',
					xtype		: 'uniDatefield',
					name		: 'AC_DATE',
					value		: UniDate.get('today'),
					allowBlank	: false,
					listeners	: {
						change : function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('AC_DATE', newValue);
						}
					}
				},{	 
					fieldLabel	: '전표번호',
					xtype		: 'uniNumberfield',
					name		: 'SLIP_NUM',
					allowBlank	: false,
					value		: 1,
					listeners	: {
						change : function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SLIP_NUM', newValue); 
						}
					}
				},
				{
					fieldLabel	: '회계부서구분',
					name		: 'CHARGE_DIVI' ,
					value		: gsChargeDivi,
					hidden		: true
				},
				{
					fieldLabel	: '부서',
					name		: 'DEPT_CODE',
					allowBlank	: false,
					value		: baseInfo.gsDeptCode,
					width		: 160,
					hidden		: true,
					listeners : {
						change : function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('DEPT_CODE'.newValue)
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
					name: 'SLIP_NUM',
					allowBlank:false,
					value:1,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('SLIP_NUM', newValue);
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
					name : 'DEPT_CODE',
					allowBlank:false,
					value:baseInfo.gsDeptCode,
					width:160,
					hidden:true,
					listeners:{
						change:function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('IN_DEPT_CODE'.newValue)
						}
					}
				}
		]
	});
	//createSearchForm
	var slipForm =  Unilite.createSearchForm('acm210ukrSlipForm', {
		itemId		: 'acm210ukrSlipForm',
		masterGrid	: masterGrid1,
		height		: 60,
		disabled	: false,
		trackResetOnLoad : false,
		border		: true,
		padding		: 0,
		layout : {
			type	: 'uniTable',
			columns	: 4
		},
		defaults:{
			width: 246,
			labelWidth: 90
		},
		items:[{	xtype		: 'displayfield',
					hideLabel	: true,
					value		: '<div style="color:blue;font-weight:bold;padding-left:5px;">[입력]</div>',
					width		: 50
				},
				{
					fieldLabel	: '사업장',
					name		: 'DIV_CODE',
					labelWidth	: 60,
					xtype		: 'uniCombobox' ,
					comboType	: 'BOR120',
					value		: UserInfo.divCode,
					allowBlank	: false
				},{
					xtype		: 'container',
					defaultType	: 'uniTextfield',
					layout : {type:'hbox', align:'stretch'},
					items : [
						{
							fieldLabel	: '부서',
							name 		: 'DEPT_CODE',
							allowBlank	: false,
							readOnly	: true,
							value		: baseInfo.gsDeptCode,
							width		: 160
						},{
							fieldLabel	: '부서명',
							name		: 'DEPT_NAME',
							allowBlank	: false,
							readOnly	: true,
							value		: baseInfo.gsDeptName,
							hideLabel	: true,
							width		: 85
						}
					]
				},Unilite.popup('ACCNT_PRSN', {
					fieldLabel		: '입력자ID',
					valueFieldName	: 'CHARGE_CODE',
					textFieldName	: 'CHARGE_NAME',
					allowBlank		: false,
					labelWidth		: 88,
					textFieldWidth	: 150,
					readOnly		: true
				}),{	
					xtype		: 'displayfield',
					hideLable	: true,
					value		: '<div style="color:blue;font-weight:bold;padding-left:5px;">&nbsp;</div>',
					width		: 50,
					tdAttrs		: {width:50}
				},{	 
					fieldLabel	: '전표일',
					xtype		: 'uniDatefield',
					labelWidth	: 60,
					name		: 'AC_DATE',
					value		: UniDate.get('today'),
					allowBlank	: false,
					listeners	: {
						change:function(field, newValue, oldValue) {
							
							var value = field.getValue();
							var slipNum = slipForm.getValue("SLIP_NUM");
							var sDay = Ext.Date.format(value, 'd').toString();
							//날짜와 전표 번호 생성
							if(!Ext.isEmpty(newValue) &&Ext.isDate(newValue)) {
								panelSearch.setValue('AC_DATE',newValue);
								panelResult.setValue('AC_DATE',newValue);
							
								Ext.getBody().unmask();
								acm210ukrService.getSlipNum({'AC_DATE':UniDate.getDbDateStr(newValue)}, function(provider, result ) {
									slipForm.setValue("AC_NUM", provider.SLIP_NUM); 
									
									var pendData = detailStore.getData();
									Ext.each(pendData.items, function(item, idx){
										item.set("AC_DATE", value);
										item.set('SLIP_NUM', provider.SLIP_NUM);
										item.set("AC_DAY", sDay);
									});
									Ext.getBody().unmask();
								});
							}
						}
					}
				},{	 
					fieldLabel	: '전표번호',
					xtype		: 'uniNumberfield',
					name		: 'SLIP_NUM',
					allowBlank	: false,
					value		: '1',
					listeners	: {
						change:function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('SLIP_NUM',newValue);
							panelResult.setValue('SLIP_NUM',newValue);
							var value = newValue;
							var sDate = UniDate.getDbDateStr(slipForm.getValue("AC_DATE"));
							if(!Ext.isEmpty(value) && Ext.isDate(slipForm.getValue("AC_DATE"))) {
								Ext.getBody().mask();
								
								acm210ukrService.getSlipNum({'AC_DATE':sDate}, function(provider, result ) {
									slipForm.setValue("SLIP_NUM", provider.SLIP_NUM); 
									panelSearch.setValue('SLIP_NUM',provider.SLIP_NUM);
									panelResult.setValue('SLIP_NUM',provider.SLIP_NUM);
									
									var pendData = detailStore.getData();
									Ext.each(pendData.items, function(item, idx){
										item.set('SLIP_NUM', provider.SLIP_NUM);
									});
									
									Ext.getBody().unmask();
								});
							}
						}
					}
				}
		]
	});

	/**
	 * 일발전표 Master Grid 정의(Grid Panel)
	 * @type 
	 */

	var masterGrid1 = Unilite.createGrid('acm210ukrGrid1', {
			layout : 'fit',
			flex:.6,
			uniOpt:{
				copiedRow          : true,
				useContextMenu     : false,
				expandLastColumn   : false,
				useMultipleSorting : false,
				useNavigationModel : false,
				dblClickToEdit     : true,
				nonTextSelectedColumns:['REMARK']
			},		
			itemId           : 'acm210ukrGrid1',
			enableColumnHide : false,  // 숨긴 컬럼 보여주는 옵션
			sortableColumns  : false,
			border           : true,
			store            : directMasterStore2,
			columns:[
				 { dataIndex: 'SLIP_SEQ'		,width: 45 , align:'center'}
				,{ dataIndex: 'DR_CR'			,width: 80 } 
				,{ dataIndex: 'SLIP_DIVI'		,width: 80 ,hidden:true} 
				,{ dataIndex: 'ACCNT'			,width: 100 ,
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						textFieldName:'ACCNT',
						DBtextFieldName: 'ACCNT_CODE',
						listeners:{
							scope:this,
							onSelected:function(records, type ) {
								var aGridID = 'acm210ukrGrid1', aDetailFormID='acm210ukrDetailForm1';
								var grid    = Ext.getCmp(aGridID);
								var form    = Ext.getCmp(aDetailFormID);
								
								grid.uniOpt.currentRecord.set('ACCNT', records[0].ACCNT_CODE);
								grid.uniOpt.currentRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);

								UniAppManager.app.loadDataAccntInfo(grid.uniOpt.currentRecord, form, records[0])
							},
							onClear:function(type) {
								var aGridID = 'acm210ukrGrid1', aDetailFormID='acm210ukrDetailForm1';
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								UniAppManager.app.clearAccntInfo(grid.uniOpt.currentRecord, form);
							},
							applyExtParam: {
								scope : this,
								fn : function(popup){
									var param = {
										'RDO'			: '3',
										'TXT_SEARCH'	: popup.textField.getValue(),
										'CHARGE_CODE'	: slipForm.getValue('CHARGE_CODE'),
										'ADD_QUERY'		: "SLIP_SW = N'Y' AND GROUP_YN = N'N'"
									}
									popup.setExtParam(param);
								}
							}
						}
						
					})
				} 
				,{ dataIndex: 'ACCNT_NAME'	  ,width: 140 ,
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						listeners:{
							scope:this,
							onSelected:function(records, type ) {
								var aGridID = 'acm210ukrGrid1', aDetailFormID='acm210ukrDetailForm1';
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								grid.uniOpt.currentRecord.set('ACCNT', records[0].ACCNT_CODE);
								grid.uniOpt.currentRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
								
								UniAppManager.app.loadDataAccntInfo(grid.uniOpt.currentRecord, form, records[0]);
							},
							onClear:function(type) {
								var aGridID = 'acm210ukrGrid1', aDetailFormID='acm210ukrDetailForm1';
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
									'ADD_QUERY' : "SLIP_SW = N'Y' AND GROUP_YN = N'N'"
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
									var aGridID = 'acm210ukrGrid1', aDetailFormID='acm210ukrDetailForm1';
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
									var aGridID = 'acm210ukrGrid1', aDetailFormID='acm210ukrDetailForm1';
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
									var aGridID = 'acm210ukrGrid1', aDetailFormID='acm210ukrDetailForm1';
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
									var aGridID = 'acm210ukrGrid1', aDetailFormID='acm210ukrDetailForm1';
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
				,{dataIndex: 'MONEY_UNIT'		,width: 100, hidden:true} 
				,{dataIndex: 'EXCHG_RATE_O'		,width: 100, hidden:true} 
				,{dataIndex: 'FOR_AMT_I'		,width: 100, hidden:true}
				,{ dataIndex: 'DR_AMT_I'		,width: 100} 
				,{ dataIndex: 'CR_AMT_I'		,width: 100} 
				,{ dataIndex: 'REMARK'		  ,width: 200 ,
					editor:Unilite.popup('REMARK_G',{
										textFieldName:'REMARK',
										validateBlank:false,
										listeners:{
											'onSelected':function(records, type) {
												var aGridID = 'acm210ukrGrid1';
												var grid = Ext.getCmp(aGridID);
												var selectedRec = grid.getSelectedRecord();
												selectedRec.set('REMARK', records[0].REMARK_NAME);
												
											},
											'onClear':function(type) {
												var aGridID = 'acm210ukrGrid1';
												var grid = Ext.getCmp(aGridID);
												var selectedRec = grid.getSelectedRecord();
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
								var aGridID = 'acm210ukrGrid1';
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
				,{ dataIndex: 'CREDIT_NUM'			,width: 150 , hidden:true}
				,{ dataIndex: 'CREDIT_NUM_EXPOS'	,width: 150 , hidden:true}
				,{ dataIndex: 'CREDIT_NUM_MASK'		,width: 150 }
				,{ dataIndex: 'DEPT_NAME'			,width: 100 ,
				   editor:Unilite.popup('DEPT_G',{
									showValue:false,
									extParam:{'TXT_SEARCH':'', 'isClearSearchTxt':baseInfo.inDeptCodeBlankYN == 'Y' ? true : false},
					  				autoPopup: true,
									listeners:{
										'onSelected':function(records, type) {
											var aGridID = 'acm210ukrGrid1';
											var grid = Ext.getCmp(aGridID);
											var selectedRec = grid.uniOpt.currentRecord;
											
											selectedRec.set('DEPT_NAME', records[0].TREE_NAME);
											selectedRec.set('DEPT_CODE', records[0].TREE_CODE);
											selectedRec.set('DIV_CODE', records[0].DIV_CODE);
											selectedRec.set('BILL_DIV_CODE', records[0].BILL_DIV_CODE);
											
										},
										'onClear':function(type) {
											var aGridID = 'acm210ukrGrid1';
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
				,{ dataIndex: 'DIV_CODE'		,flex: 1 , minWidth:60} 
			  ] ,
			listeners:{
				render:function(grid, eOpt) {
					grid.getEl().on('click', function(e, t, eOpt) {
						activeGrid = grid.getItemId();
						clickedGrid = grid.getItemId();
					});
				},
				selectionChange: function( grid, selected, eOpts ) {
					if(selected.length == 1) {
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
						var aDetailFormID='acm210ukrDetailForm1';
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
					
					/* if(context.record.get('AP_STS') == '2' ) {
						return false;
					} */
					if(context.record.get("FOR_YN") !="Y") {
						if(context.field == "MONEY_UNIT" || context.field =='EXCHG_RATE_O' || context.field =='FOR_AMT_I') {
							return false;
						}
					}
					return true;
				},
				celldblclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
					if(e.position.column.dataIndex=='CREDIT_NUM') {
						UniAppManager.app.fnProofKindPopUp(record, null, 'acm210ukrGrid1');
						//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM'), "CREDIT_NUM", null, null, null, null,  'VALUE');			
					}
					if(e.position.column.dataIndex=='PROOF_KIND') {
						UniAppManager.app.fnProofKindPopUp(record, null, 'acm210ukrGrid1');
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
						UniAppManager.app.fnProofKindPopUp(record, null, 'acm210ukrGrid1');
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

	var detailForm1 = Unilite.createForm('acm210ukrDetailForm1',  getAcFormConfig('acm210ukrDetailForm1', masterGrid1 ));

	// 카드승인내역 grid
	var apprCardGrid = Unilite.createGrid('acm210ukrApprCardGrid', { 
		layout    : 'fit',
		minHeight : 100,
		store     : detailStore,
		
		viewConfig:{
			itemId:'acm210ukrApprCardGrid'
		},
		uniOpt:{
			useMultipleSorting	: true,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: false,
			userToolbar			: false,
			filter: {
				useFilter		: false,
				autoCreate		: false
			},
			nonTextSelectedColumns:['REMARK']
		},
		columns:  [
			{ dataIndex: 'SLIP_SEQ'			, width: 45  , align:'center'},
			{ dataIndex: 'DR_CR'			, width: 80  , align:'center'},
			{ dataIndex: 'ACCNT'			,width: 100 ,
				editor:Unilite.popup('ACCNT_AC_G', {
					autoPopup: true,
					textFieldName:'ACCNT',
					DBtextFieldName: 'ACCNT_CODE',
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grid    = Ext.getCmp('acm210ukrApprCardGrid');
							var grdRecord = grid.uniOpt.currentRecord;
							
							grdRecord.set('ACCNT', records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
							
							UniAppManager.app.setAccntInfo(grdRecord);
						},
						onClear:function(type) {
							var grid    = Ext.getCmp('acm210ukrApprCardGrid');
							var grdRecord = grid.uniOpt.currentRecord;
							
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
							
							UniAppManager.app.setAccntInfo(grdRecord);
						},
						applyExtParam: {
							scope : this,
							fn : function(popup){
								var param = {
									'RDO'			: '3',
									'TXT_SEARCH'	: popup.textField.getValue(),
									'CHARGE_CODE'	: slipForm.getValue('CHARGE_CODE'),
									'ADD_QUERY'		: "SLIP_SW = N'Y' AND GROUP_YN = N'N'"
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
			} 
			,{ dataIndex: 'ACCNT_NAME'	  ,width: 140 ,
				editor:Unilite.popup('ACCNT_AC_G', {
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grid    = Ext.getCmp('acm210ukrApprCardGrid');
							var grdRecord = grid.uniOpt.currentRecord;
							
							grdRecord.set('ACCNT', records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
							
							UniAppManager.app.setAccntInfo(grdRecord);
						},
						onClear:function(type) {
							var grid    = Ext.getCmp('acm210ukrApprCardGrid');
							var grdRecord = grid.uniOpt.currentRecord;
							
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
							
							UniAppManager.app.setAccntInfo(grdRecord);
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
						
							var param = {
								'RDO': '4',
								'TXT_SEARCH': popup.textField.getValue(),
								'CHARGE_CODE':slipForm.getValue('CHARGE_CODE'),
								'ADD_QUERY' : "SLIP_SW = N'Y' AND GROUP_YN = N'N'"
							}
							popup.setExtParam(param);
							}
						}
					}
					
			})},
			
			{ dataIndex: 'CREDIT_NUM_EXPOS'	, width: 120 },
			{ dataIndex: 'CREDIT_CODE'		, width: 80  , align:'center'},
			{ dataIndex: 'CRDT_NAME'		, width: 180 },
			{ dataIndex: 'APPR_AMT_I'		, width: 100 },
			
			{ dataIndex: 'APPR_DATE'		, width: 40  , hidden:true},
			{ dataIndex: 'APPR_NO'			, width: 40  , hidden:true},

			{ dataIndex: 'CUSTOM_CODE'		, width: 100 ,
				editor: Unilite.popup('CUST_G',{
					textFieldName: 'CUSTOM_CODE',
 	 				DBtextFieldName: 'CUSTOM_CODE',
					listeners:{ 'onSelected': {
						fn: function(records, type){
							var aGridID = 'acm210ukrApprCardGrid'
							var grid = Ext.getCmp(aGridID);
							var grdRecord = grid.uniOpt.currentRecord;
							
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							
							// AcData가 A4,O2인 경우 Data세팅
							for(var i=1 ; i <= 6 ; i++) {
								if(grdRecord.get("AC_CODE"+i.toString()) == 'A4') {
									grdRecord.set('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['CUSTOM_NAME']);
									
								}else if(grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
									grdRecord.set('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['BOOK_NAME']);
								}
							}
						},
						scope: this
						},
						'onClear' : function(type) {
							var aGridID = 'acm210ukrApprCardGrid'
							var grid = Ext.getCmp(aGridID);
							var grdRecord = grid.uniOpt.currentRecord;
							
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							
							for(var i=1 ; i <= 6 ; i++) {
								if(grdRecord.get("AC_CODE"+i.toString()) == 'A4' || grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
									grdRecord.set('AC_DATA'+i.toString()		,'');
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,'');
								}
							}
						}
					}
				})
			}
			,{ dataIndex: 'CUSTOM_NAME'	 		,		width: 150,
				editor: Unilite.popup('CUST_G',{
					listeners:{ 'onSelected': {
						fn: function(records, type){
							var aGridID = 'acm210ukrApprCardGrid'
							var grid = Ext.getCmp(aGridID);
							var grdRecord = grid.uniOpt.currentRecord;
							
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							
							for(var i=1 ; i <= 6 ; i++) {
								if(grdRecord.get("AC_CODE"+i.toString()) == 'A4') {
									grdRecord.set('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['CUSTOM_NAME']);
								}else if(grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
									grdRecord.set('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,records[0]['BOOK_NAME']);
								}
							}
						},
						scope: this
						},
						'onClear' : function(type) {
							var aGridID = 'acm210ukrApprCardGrid'
							var grid = Ext.getCmp(aGridID);
							var grdRecord = grid.uniOpt.currentRecord;
							
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							
							for(var i=1 ; i <= 6 ; i++) {
								if(grdRecord.get("AC_CODE"+i.toString()) == 'A4' || grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
									grdRecord.set('AC_DATA'+i.toString()		,'');
									grdRecord.set('AC_DATA_NAME'+i.toString()   ,'');
								}
							}
						}
					}
				})
	 		},
	 		{ dataIndex: 'PROOF_KIND'  ,width: 110 
				,editor:{
					xtype:'uniCombobox',
					store:Ext.data.StoreManager.lookup('CBS_AU_A022'),
					listeners:{
						
						beforequery:function(queryPlan, value) {
							var aGridID = 'acm210ukrApprCardGrid';
							var grid = Ext.getCmp(aGridID);
							
							this.store.clearFilter();
							if(grid.uniOpt.currentRecord.get('SPEC_DIVI') == 'F1') {
								this.store.filterBy(function(record){return record.get('refCode3') == '1'},this)
							} else if(grid.uniOpt.currentRecord.get('SPEC_DIVI') == 'F2') {
								this.store.filterBy(function(record){return record.get('refCode3') == '2'},this)
							}
						}
					}
				}
			} ,
	 		{ dataIndex: 'REMARK'			,width: 200 ,
				editor:Unilite.popup('REMARK_G',{
							textFieldName:'REMARK',
							validateBlank:false,
							listeners:{
								'onSelected':function(records, type) {
									var aGridID = 'acm210ukrApprCardGrid';
									var grid = Ext.getCmp(aGridID);
									var selectedRec = grid.getSelectedRecord();
									selectedRec.set('REMARK', records[0].REMARK_NAME);
									
								},
								'onClear':function(type) {
									var aGridID = 'acm210ukrApprCardGrid';
									var grid = Ext.getCmp(aGridID);
									var selectedRec = grid.getSelectedRecord();
								}
								
							}
							
						})
			},

			{ dataIndex: 'DEPT_NAME'		,width: 100 ,
				editor:Unilite.popup('DEPT_G',{
					showValue:false,
					extParam:{'TXT_SEARCH':'', 'isClearSearchTxt':baseInfo.inDeptCodeBlankYN == 'Y' ? true : false},
	  				autoPopup: true,
					listeners:{
						'onSelected':function(records, type) {
							var aGridID = 'acm210ukrApprCardGrid';
							var grid = Ext.getCmp(aGridID);
							var selectedRec = grid.uniOpt.currentRecord;
							
							selectedRec.set('DEPT_NAME', records[0].TREE_NAME);
							selectedRec.set('DEPT_CODE', records[0].TREE_CODE);
							selectedRec.set('DIV_CODE', records[0].DIV_CODE);
							selectedRec.set('BILL_DIV_CODE', records[0].BILL_DIV_CODE);
							
						},
						'onClear':function(type) {
							var aGridID = 'acm210ukrApprCardGrid';
							var grid = Ext.getCmp(aGridID);
							var selectedRec = grid.uniOpt.currentRecord;
							
							selectedRec.set('DEPT_NAME', '');
							selectedRec.set('DEPT_CODE', '');
							selectedRec.set('DIV_CODE', '');
							selectedRec.set('BILL_DIV_CODE', '');
						}
						
					}
				})
			},
			{ dataIndex: 'DIV_CODE'		, flex: 1, minWidth : 200 }
		] ,
		listeners:{
			beforeedit : function(editor, context, eOpts) {
				
				if(context.field == "ACCNT" || context.field == "ACCNT_NAME" || context.field == "PROOF_KIND"
						|| context.field == "CUSTOM_CODE" || context.field == "CUSTOM_NAME" || context.field == "REMARK"
						|| context.field == "DEPT_NAME" || context.field == "DIV_CODE") {
					return true;
				}
				return false;
			},
			// 삭제 할 경우 클릭했던 grid의 행을 지우기 위함
			containerclick : function(view,  e , eOpts) {
				activeGrid = 'acm210ukrApprCardGrid';
				clickedGrid = 'acm210ukrApprCardGrid';
			},
			itemclick : function ( view , record , item , index , e , eOpts ) {
				activeGrid = 'acm210ukrApprCardGrid';
				clickedGrid ='acm210ukrApprCardGrid';
			}
		}
	});
	
	var apprCardRefForm = Unilite.createSearchForm('acm210ukrApprCardRefForm', {
		itemId			: 'acm210ukrApprCardRefForm',
		height			: 85,
		disabled		: false,
		trackResetOnLoad:false,
		border			: true,
		padding			: 0,
		layout: {
			type: 'uniTable', 
			columns:2
		},
		defaults:{
			labelWidth: 90
		},
		items:[
			{
				fieldLabel		: '거래일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FROM_TRADE_DATE',
				endFieldName	: 'TO_TRADE_DATE',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				width			: 350,
				allowBlank		: false
			},{
				fieldLabel	: '카드번호/카드명',
				name		: 'CRDT_FULL_NUM',
				xtype		: 'uniTextfield',
				width		: 300
			}
		]
	});
	
	Unilite.defineModel('Acm210ukrApprCardRefModel', {
		fields: [
				 {name: 'CREDIT_NUM_EXPOS'		,text: '카드번호'		,type : 'string'  },
				 {name: 'CREDIT_NUM'			,text: '카드번호'		,type : 'string'  },
				 {name: 'CREDIT_CODE'			,text: '카드코드'		,type : 'string'  },
				 {name: 'CRDT_NAME'				,text: '카드명'		,type : 'string'  },
				 {name: 'APPR_DATE'				,text: '승인일'		,type : 'uniDate' },
				 {name: 'CHAIN_ID'				,text: '가맹점ID'		,type : 'string'  },
				 {name: 'CHAIN_NAME'			,text: '가맹점명'		,type : 'string'  },
				 {name: 'APPR_SUPP_I'			,text: '공급가액'		,type : 'uniPrice'},
				 {name: 'APPR_TAX_I'			,text: '부가세액'		,type : 'uniPrice'},
				 {name: 'APPR_AMT_I'			,text: '합계금액'		,type : 'uniPrice'},
				 {name: 'FLAG'					,text:''			,type : 'string', defaultValue:"R"},
				 {name: 'APPR_NO'				,text: '승인번호'		,type : 'string'},
				 {name: 'MONEY_UNIT'			,text:'화폐단위'		,type : 'string', defaultValue:baseInfo.gsLocalMoney, comboType:'AU',comboCode:'B004'}
			 ]
		});
	
	var apprCardRefStore = Unilite.createStore('Acm210ukrApprCardRefStore',{
		model: 'Acm210ukrApprCardRefModel',
		uniOpt : {
			isMaster  : false,	// 상위 버튼 연결 
			editable  : false,	// 수정 모드 사용 
			deletable : false,	// 삭제 가능 여부 
			useNavi   : false	// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy: {
			type: 'direct',
			api: {
				read: 'acm210ukrService.selectApprCardRef'
			}
		},
		filters: [apprCardRefFilter],
		loadStoreRecords : function() {
			var form = Ext.getCmp('acm210ukrApprCardRefForm');
			if(form.getInvalidMessage()) {
				var param= form.getValues();
				if(param) {
					console.log( param );
					this.load({
						params : param
					});
				}
			}
		}
	}); 
	var apprCardRefGrid = Unilite.createGrid('acm210ukrRefGrid', {
		// for tab	  
		store		: apprCardRefStore,
		layout		: 'fit',
		region		: 'center',
		minHeight	: 100,
		uniOpt		: {
			useMultipleSorting	: true,  // 정렬버튼
			onLoadSelectFirst	: false, // 체크박스
			useRowNumberer		: true,  // 첫번째 컬럼 순번 사용여부
			expandLastColumn	: true,  // 마지막 컬럼 확장
			userToolbar			: true
		},
		apprCardApply:function(gRec, sRec, slipSeq, isNew) {
			// 체크한 row 값 세팅
			sRec = apprCardGrid.createRow({	"SLIP_SEQ"			: slipSeq,
											"DR_CR"				: '1',
											"ACCNT"				: '',
											"ACCNT_NAME"		: '',
											
											"APPR_AMT_I"		: gRec.get("APPR_SUPP_I"),
											
											"APPR_DATE"			: gRec.get("APPR_DATE"),
											"APPR_NO"			: gRec.get("APPR_NO"),
											
											"COUSTOM_CODE"		: '',
											"COUSTOM_NAME"		: '',
											"DEPT_CODE"			: UserInfo.deptCode,
											"DEPT_NAME"			: UserInfo.deptName,
											"DIV_CODE"			: UserInfo.divCode,
											"OLD_AC_DATE"		: slipForm.getValue("AC_DATE"),
											"OLD_SLIP_NUM"		: slipForm.getValue("SLIP_NUM"),
											"P_ACCNT"			: '',
											
											"CRDT_NAME"			: gRec.get("CRDT_NAME"),
											"CREDIT_CODE"		: gRec.get("CREDIT_CODE"),
											"CREDIT_NUM"		: gRec.get("CREDIT_NUM"),
											"CREDIT_NUM_EXPOS"	: gRec.get("CREDIT_NUM_EXPOS")
								});
			

			if(sRec.phantom) {
				sRec.set("OPR_FLAG"	 , 'N');
			}else {
				sRec.set("OPR_FLAG"	 , 'U');
			}
			// accnt 정보 세팅
			UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, sRec, sRec.get('DIV_CODE')); // 신고사업장 세팅
			
			sRec = masterGrid1.createRow({"SLIP_SEQ"			: slipSeq + 1,
											"AC_DATE"			: slipForm.getValue("AC_DATE"),
											"SLIP_NUM"			: slipForm.getValue("SLIP_NUM"),
											"AC_DAY"			: Ext.Date.format(slipForm.getValue('AC_DATE'),'d'),
											
											"DR_CR"				: '1',
											"ACCNT"				: '',
											"ACCNT_NAME"		: '',

											"CRDT_NAME"			: gRec.get("CRDT_NAME"),
											
											"DR_AMT_I"			: gRec.get("APPR_TAX_I"),
											"CR_AMT_I"			: 0,
											
											"AMT_I"				: gRec.get("APPR_TAX_I"),
											"PROOF_KIND"		: '53',
											
											"APPR_DATE"			: gRec.get("APPR_DATE"),
											
											
											"COUSTOM_CODE"		: '',
											"COUSTOM_NAME"		: '',
											
											"DEPT_CODE"			: UserInfo.deptCode,
											"DEPT_NAME"			: UserInfo.deptName,
											"DIV_CODE"			: UserInfo.divCode,
											
											'OLD_AC_DATE'		: slipForm.getValue('AC_DATE'),
											'OLD_SLIP_NUM'		: slipForm.getValue('SLIP_NUM'),
											'OLD_SLIP_SEQ'		: slipSeq,
											
											'IN_DIV_CODE'		: slipForm.getValue('DIV_CODE'),
											'IN_DEPT_CODE'		: slipForm.getValue('DEPT_CODE'),
											'IN_DEPT_NAME'		: slipForm.getValue('DEPT_NAME'),
											
											'INPUT_USER_ID'		: UserInfo.userID,
											'CHARGE_CODE'		: slipForm.getValue('CHARGE_CODE'),
											
											'AP_DATE'			: UniDate.get('today'),
											'AP_USER_ID'		: UserInfo.userID,
											'AP_CHARGE_CODE'	: '${chargeCode}',
											
											"P_ACCNT"			: '',
											'POSTIT_YN'			: 'N',
											
											"CREDIT_CODE"		: gRec.get("CREDIT_CODE"),
											"CREDIT_NUM_EXPOS"	: gRec.get("CREDIT_NUM_EXPOS"),
											"CREDIT_NUM"		: gRec.get("CREDIT_NUM")
								});
			
			if(sRec.phantom) {
				sRec.set("OPR_FLAG"	 , 'N');
			}else {
				sRec.set("OPR_FLAG"	 , 'U');
			}
			
			var accnt = '${initTaxAccnt}'
			sRec.set("ACCNT"		, accnt);
			sRec.set("ACCNT_NAME"	, '${initTaxAccntNm}');
			
			// accnt 정보 세팅
			accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
				var rtnRecord = sRec;
				if(provider){
					UniAppManager.app.loadDataAccntInfo(rtnRecord, Ext.getCmp('acm210ukrDetailForm1'), provider);
				
				}else {
					var slipDivi = rtnRecord.get('SLIP_DIVI');
					if(slipDivi == '1' || slipDivi == '2') {
						if(rtnRecord.get('SPEC_DIVI') == 'A') {
							alert(Msg.sMA0040);
						}
					}
				}
			})
			UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, sRec, sRec.get('DIV_CODE')); // 신고사업장 세팅
		},
		selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : true,showHeaderCheckbox :true }), 
		tbar: [{
			text    : '참조적용',
			align   : 'left',
			handler : function() {
				var selectedRecords = apprCardRefGrid.getSelectedRecords();                 // 참조 Grid에서 체크한 rows
				var maxSlipSeq      = Unilite.nvl(directMasterStore1.max("SLIP_SEQ"),0)+1;  // 카드승인내역 순번
				
				if(selectedRecords < 1){
					Unilite.messageBox("참조 적용할 데이터를 선택해주세요.");
				}
				
				// 체크한 참조 데이터
				Ext.each(selectedRecords, function(selRecord, idx){
					apprCardRefGrid.apprCardApply(selRecord, null, maxSlipSeq,true);  // 카드승인내역 데이터 CreateRow
					selRecord.set("FLAG","D"); // filter 조건
					maxSlipSeq++;
				
				})
			}
		},'','',
		'->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->'],
		columns: [
			{ dataIndex: 'CREDIT_NUM_EXPOS'	, width: 130 , align:'center'},
			{ dataIndex: 'CREDIT_CODE'		, width: 70  , align:'center'},
			{ dataIndex: 'CRDT_NAME'		, width: 200 },
			{ dataIndex: 'APPR_DATE'		, width: 80  },
			{ dataIndex: 'CHAIN_NAME'		, width: 250 },
			{ dataIndex: 'APPR_SUPP_I'		, width: 100 },
			{ dataIndex: 'APPR_TAX_I'		, width: 100 },
			{ dataIndex: 'APPR_AMT_I'		, width: 100 }
		],
		listeners: {
			select: function(grid, record, index, rowIndex, eOpts ){
				// 통장master에 통장정보가 없을 경우
				if(Ext.isEmpty(record.get('CREDIT_CODE')) || record.get('CREDIT_CODE') == ''){
					Unilite.messageBox("카드가 등록되어있지 않습니다.\n카드정보를 확인해주세요.");
					grid.deselect(record);
				}
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				// 통장master에 통장정보가 없을 경우 row 색 변경
				if(Ext.isEmpty(record.get('CREDIT_CODE')) || record.get('CREDIT_CODE') == ''){
					cls = 'x-change-cell_light';
				}
				return cls;
			}
		}
	});
	
	var pend_tab = Unilite.createTabPanel('acm210ukrvTab',{	 
		region:'south',
		flex:1,
		activeTab: 0,
		border: false,
		items:[
			{
				title: '카드승인내역',
				xtype: 'panel',
				itemId: 'pandTab1',
				id: 'pandTab1',
				layout:{type:'vbox', align:'stretch'},
				
				items:[
					apprCardGrid
				]
			},{
				title: '참조',
				xtype:'container',
				itemId: 'pandTab2',
				layout:{type:'vbox', align:'stretch'},
				defaults:{
					style:{left:'1px !important'}
				},
				items:[
					apprCardRefForm, apprCardRefGrid
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
	
	// 입출금 내역 조회 팝업
	function openSearchPopup() {
		if(!searchPopup) {
				Unilite.defineModel('searchModel', {
					fields: [
								 {name: 'J_AC_DATE'		,text:'회계전표일자'		,type:'uniDate'}
								,{name: 'J_SLIP_NUM'	,text:'회계전표번호'		,type:'int'}
								,{name: 'DIV_CODE'		,text:'귀속사업장'		,type:'string'}
								,{name: 'DEPT_CODE'		,text:'귀속부서'		,type:'string'}
								,{name: 'CHARGE_CODE'	,text:'입력자'			,type:'string'}
								,{name: 'CHARGE_NAME'	,text:'입력자명'		,type:'string'}
								,{name: 'DR_AMT_I'		,text:'차변금액'		,type:'uniPrice'}
								,{name: 'CR_AMT_I'		,text:'대변금액'		,type:'uniPrice'}
								,{name: 'INPUT_PATH'	,text:'입력경로'		,type:'string'}
								,{name: 'INPUT_NAME'	,text:'입력경로'		,type:'string'}
								,{name: 'INPUT_DIVI'	,text:''			,type:'string'}
							]
				});
				// Proxy
				var searchDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
					api: {
						read : 'acm210ukrService.selectSearch'
					}
				});
				// store
				var searchStore = Unilite.createStore('searchStore', {
						model : 'searchModel',
						proxy : searchDirctProxy,
						loadStoreRecords : function() {
							var param= searchPopup.down('#search').getValues();
							this.load({
								params: param
							});
						}
				});
				// 팝업 layout setting
				searchPopup = Ext.create('widget.uniDetailWindow', {
					title: '카드승인내역검색',
					width: 800,
					height:500,
					autoLoad: true,
					layout: {type:'vbox', align:'stretch'},
					items: [{
							itemId : 'search',
							xtype  : 'uniSearchForm',
							layout : {type:'uniTable',columns:2},
							items  : [{
									fieldLabel		: '회계전표일자',
									xtype			: 'uniDateRangefield',
									startFieldName	: 'FR_AC_DATE',
									endFieldName	: 'TO_AC_DATE',
									startDate		: UniDate.get('startOfMonth'),
									endDate			: UniDate.get('today'),
									allowBlank		: false
								},{
									fieldLabel	: '사업장',
									name		: 'DIV_CODE',
									xtype		: 'uniCombobox',
									comboType	: 'BOR120'
								}
							]
						},
						Unilite.createGrid('', {
							itemId:'grid',
							layout : 'fit',
							store: searchStore,
							selModel:'rowmodel',
							uniOpt:{					
								useMultipleSorting	: true,
								useLiveSearch		: false,
								onLoadSelectFirst	: true,
								useRowNumberer		: false,
								expandLastColumn	: false,
								useRowContext		: false,
								userToolbar			: false
							},
							columns:  [  
									 { dataIndex: 'J_AC_DATE'		,width: 100 }
									,{ dataIndex: 'J_SLIP_NUM'		,width: 100 }
									,{ dataIndex: 'DR_AMT_I'		,width: 100 }
									,{ dataIndex: 'CR_AMT_I'		,width: 100 }
									,{ dataIndex: 'INPUT_NAME'		,width: 200 }
							]
							 ,listeners: {  
									onGridDblClick:function(grid, record, cellIndex, colName) {
										if(grid.ownerGrid.returnData()){
											searchPopup.hide();
										}
									}
								}
							,returnData: function() {
								var record = this.getSelectedRecord();  
								
								if(Ext.isEmpty(record)) {
									Unilite.messageBox("조회내역이 없습니다.");
									return false;
								}
								
								searchPopup.returnRecord = record;
								panelSearch.setValue('AC_DATE',record.get("J_AC_DATE"));
								slipForm.setValue('AC_DATE',record.get("J_AC_DATE"));
								
								panelSearch.setValue('SLIP_NUM',record.get("J_SLIP_NUM"));
								slipForm.setValue('SLIP_NUM',record.get("J_SLIP_NUM"));
								
								panelSearch.setValue('DIV_CODE',record.get("DIV_CODE"));
								slipForm.setValue('DIV_CODE',record.get("DIV_CODE"));

								slipForm.setValue('CHARGE_CODE',record.get("CHARGE_CODE"));
								slipForm.setValue('CHARGE_NAME',record.get("CHARGE_NAME"));

								gsInputDivi  = record.get("INPUT_DIVI");
								var girdStore = Ext.data.StoreManager.lookup('acm210ukrMasterStore2');
								girdStore.loadStoreRecords();
								
								return true;
							}
							
						})
					],
					tbar : ['->',
						{
							itemId : 'searchtBtn',
							text: '조회',
							handler: function() {
								var form = searchPopup.down('#search');
								var store = Ext.data.StoreManager.lookup('searchStore')
								store.loadStoreRecords();
							},
							disabled: false
						},{
							xtype: 'tbspacer'
						},{
							xtype: 'tbseparator'
						},{
							xtype: 'tbspacer'
						},{
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
		sForm.setValue("DEPT_CODE", slipForm.getValue("DEPT_CODE"));
	}
	//차대변 비교
	<%@include file="../agj/agjSlip.jsp" %> 
	var centerContainer = {
		region:'center',
		flex:.5,
		xtype:'container',
		layout:{type:'vbox', align:'stretch'},
		items:[
			slipForm,
			masterGrid1,
			detailForm1 
		]
	}
	
	var tempGridForView = Unilite.createGrid('tempGridForView', {
		uniOpt:{
			copiedRow			: false,
			useContextMenu		: false,
			expandLastColumn	: false,
			useMultipleSorting	: false,
			useNavigationModel	: false
		},
		enableColumnHide	: false,
		sortableColumns		: false,
		border				: true,
		
		store: directMasterStore1,

		columns:[
			 { dataIndex: 'AC_DAY'			, width: 45 , align:'center' }
			,{ dataIndex: 'AC_DATE'	 		, width: 55 , align:'center'}
			,{ dataIndex: 'SLIP_NUM'		, width: 55 , format:'0', align:'center'}
			,{ dataIndex: 'SLIP_SEQ'		, width: 45 , align:'center'}
			,{ dataIndex: 'DR_CR'			, width: 80 }
			,{ dataIndex: 'SLIP_DIVI'		, width: 80 }
			,{ dataIndex: 'ACCNT'			, width: 80 }
			,{ dataIndex: 'ACCNT_NAME'		, width: 130}
			,{ dataIndex: 'CUSTOM_CODE'		, width: 80 }
			,{ dataIndex: 'CUSTOM_NAME'		, width: 140 }
			,{ dataIndex: 'DR_AMT_I'		, width: 100 }
			,{ dataIndex: 'CR_AMT_I'		, width: 100 }
			,{ dataIndex: 'REMARK'			, width: 200 }
			,{ dataIndex: 'SPEC_DIVI'		, width: 110 }
			,{ dataIndex: 'PROOF_KIND'		, width: 110 }
			,{ dataIndex: 'CREDIT_CODE'		, width: 150 }
			,{ dataIndex: 'CREDIT_NUM'		, width: 150 , hidden: true}
			,{ dataIndex: 'CREDIT_NUM_EXPOS', width: 150 }
			,{ dataIndex: 'DEPT_NAME'		, width: 100 }
			,{ dataIndex: 'EXCHG_RATE_O'	, width:80}
			,{ dataIndex: 'OPR_FLAG'		, width:80}
			,{ dataIndex: 'CHARGE_CODE'		, width:80}
			,{ dataIndex: 'AP_DATE'			, width:80}
			,{ dataIndex: 'SPEC_DIVI'		, width:80}
			,{ dataIndex: 'REASON_CODE'		, width:80}
			,{ dataIndex: 'CREDIT_CODE'		, width:80}
			,{ dataIndex: 'AC_DATA1'		, width:80}
			,{ dataIndex: 'AC_DATA2'		, width:80}
			,{ dataIndex: 'AC_DATA3'		, width:80}
			,{ dataIndex: 'AC_DATA4'		, width:80}
			,{ dataIndex: 'AC_DATA5'		, width:80}
			,{ dataIndex: 'AC_DATA6'		, width:80}
			,{ dataIndex: 'OLD_AC_DATE'		, width:80}
			,{ dataIndex: 'OLD_SLIP_NUM'	, width:80}
			,{ dataIndex: 'OLD_SLIP_SEQ'	, width:80}
			
			,{ dataIndex: 'AMT_I'			, width:80}
			,{ dataIndex: 'INPUT_USER_ID'	, width:80}
			
			,{ dataIndex: 'DIV_CODE'		, flex: 1 , minWidth:60}
			,{ dataIndex: 'BILL_DIV_CODE'	, width:80}
			
			,{dataIndex: 'OLD_AC_DATE'		, width:80}
			,{dataIndex: 'OLD_SLIP_NUM'		, width:80}
			,{dataIndex: 'OLD_SLIP_SEQ'		, width:80}
			,{dataIndex: 'P_ACCNT'			, width:80}
			,{dataIndex: 'MONEY_UNIT'		, width:80}
			,{dataIndex: 'EXCHG_RATE_O'		, width:80}
			,{dataIndex: 'FOR_AMT_I'		, width:80}
			,{dataIndex: 'IN_DIV_CODE'		, width:80}
			,{dataIndex: 'IN_DEPT_CODE'		, width:80}
			,{dataIndex: 'BILL_DIV_CODE'	, width:80}
			
			,{dataIndex: 'AC_CODE1'			, width:80}
			,{dataIndex: 'AC_CODE2'			, width:80}
			,{dataIndex: 'AC_CODE3'			, width:80}
			,{dataIndex: 'AC_CODE4'			, width:80}
			,{dataIndex: 'AC_CODE5'			, width:80}
			,{dataIndex: 'AC_CODE6'			, width:80}
			
			,{dataIndex: 'AC_NAME1'			, width:80}
			,{dataIndex: 'AC_NAME2'			, width:80}
			,{dataIndex: 'AC_NAME3'			, width:80}
			,{dataIndex: 'AC_NAME4'			, width:80}
			,{dataIndex: 'AC_NAME5'			, width:80}
			,{dataIndex: 'AC_NAME6'			, width:80}
			
			,{dataIndex: 'AC_DATA1'			, width:80}
			,{dataIndex: 'AC_DATA2'			, width:80}
			,{dataIndex: 'AC_DATA3'			, width:80}
			,{dataIndex: 'AC_DATA4'			, width:80}
			,{dataIndex: 'AC_DATA5'			, width:80}
			,{dataIndex: 'AC_DATA6'			, width:80}
			
			,{dataIndex: 'AC_DATA_NAME1'	, width:80}
			,{dataIndex: 'AC_DATA_NAME2'	, width:80}
			,{dataIndex: 'AC_DATA_NAME3'	, width:80}
			,{dataIndex: 'AC_DATA_NAME4'	, width:80}
			,{dataIndex: 'AC_DATA_NAME5'	, width:80}
			,{dataIndex: 'AC_DATA_NAME6'	, width:80}
			
			,{dataIndex: 'BOOK_CODE1'		, width:80}
			,{dataIndex: 'BOOK_CODE2'		, width:80}
			,{dataIndex: 'BOOK_DATA1'		, width:80}
			,{dataIndex: 'BOOK_DATA2'		, width:80}
			,{dataIndex: 'BOOK_DATA_NAME1'	, width:80}
			,{dataIndex: 'BOOK_DATA_NAME2'	, width:80}
			
			,{dataIndex: 'ACCNT_SPEC'		, width:80}
			,{dataIndex: 'SPEC_DIVI'		, width:80}
			,{dataIndex: 'PROFIT_DIVI'		, width:80}
			,{dataIndex: 'JAN_DIVI'			, width:80}
			,{dataIndex: 'PEND_YN'			, width:80}
			,{dataIndex: 'PEND_CODE'		, width:80}
			,{dataIndex: 'PEND_DATA_CODE'	, width:80}
			,{dataIndex: 'BUDG_YN'			, width:80}
			,{dataIndex: 'BUDGCTL_YN'		, width:80}
			,{dataIndex: 'FOR_YN'			, width:80}
			
			,{dataIndex: 'POSTIT_YN'		, width:80} 
			,{dataIndex: 'POSTIT'			, width:80} 
			,{dataIndex: 'POSTIT_USER_ID'	, width:80} 
			
			,{dataIndex: 'INPUT_PATH'		, width:80}
			,{dataIndex: 'INPUT_DIVI'		, width:80}
			,{dataIndex: 'AUTO_SLIP_NUM'	, width:80}
			,{dataIndex: 'INPUT_DATE'		, width:80}
			,{dataIndex: 'INPUT_USER_ID'	, width:80}
			,{dataIndex: 'CHARGE_CODE'		, width:80}
			,{dataIndex: 'CHARGE_NAME'		, width:80}
			 
			,{dataIndex: 'AP_DATE'			, width:80}
			,{dataIndex: 'AP_USER_ID'		, width:80}
			,{dataIndex: 'EX_DATE'			, width:80}
			,{dataIndex: 'EX_NUM'			, width:80}
			,{dataIndex: 'EX_SEQ'			, width:80}
			,{dataIndex: 'COMP_CODE'		, width:80}
			,{dataIndex: 'AMT_I'			, width:80}
			,{dataIndex: 'OPR_FLAG'			, width:80}
			,{dataIndex: 'store2Idx'		, width:80}
			
			,{dataIndex: 'AC_CTL1'			, text:'관리항목필수1'		,width : 100} 
			,{dataIndex: 'AC_CTL2'			, text:'관리항목필수2'		,width : 100} 
			,{dataIndex: 'AC_CTL3'			, text:'관리항목필수3'		,width : 100} 
			,{dataIndex: 'AC_CTL4'			, text:'관리항목필수4'		,width : 100} 
			,{dataIndex: 'AC_CTL5'			, text:'관리항목필수5'		,width : 100} 
			,{dataIndex: 'AC_CTL6'			, text:'관리항목필수6'		,width : 100} 
			,{dataIndex: 'J_AMT_I'			, text: '반제가능금액'		,width : 100}
			,{dataIndex: 'FOR_J_AMT_I'		, text: '외화반제가능금액'		,width : 100}
			,{dataIndex: 'DEPT_NAME'		, text: '귀속부서명'			,width : 100}
			,{dataIndex: 'SEQ'				, text: '미결반제SEQ'		,width : 100}
			,{dataIndex: 'FOR_BLN_I'		, text: '미결외화잔액'		,width : 100}
			,{dataIndex: 'BLN_I'			, text: '미결잔액'			,width : 100}
			,{dataIndex: 'IS_PEND_INPUT'	, text: '미결반제데이터여부'	,width : 100}
		],
		
		listeners:{
			beforeedit:function( editor, context, eOpts ) {
				return false;
			}
		}
});

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
		id  : 'acm210ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons([ 'newData', 'reset'],true);
			
			panelSearch.setValue('AC_DATE','${initAcDate}');
			panelSearch.setValue('SLIP_NUM','${initSlipNum}');
			
			panelResult.setValue('AC_DATE','${initAcDate}');
			panelResult.setValue('SLIP_NUM','${initSlipNum}');
			
			slipForm.setValue('AC_DATE','${initAcDate}');
			slipForm.setValue('SLIP_NUM','${initSlipNum}');
			slipForm.setValue('CHARGE_CODE','${chargeCode}');
			slipForm.setValue('CHARGE_NAME','${chargeName}');  
			if(Ext.isEmpty('${chargeCode}')) {
				alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
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
				
				// tab1 조회 클릭시 팝업 조회
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
				apprCardRefStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown : function() {
			if(Ext.isEmpty('${chargeCode}')) {
				alert('회계담당자정보가 없습니다. 먼저 담당자 정보를 입력해주세요.');
				return false;
			}
			this.fnAddSlipRecord();
			UniAppManager.app.setSearchReadOnly(true, false);
		},  
		onSaveDataButtonDown: function (config) {
			directMasterStore1.saveStore(config);
		},
		onDeleteDataButtonDown : function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(clickedGrid == 'acm210ukrGrid1') {
					masterGrid1.deleteSelectedRow();
					if(masterGrid1.getStore().getCount() == 0) {
						detailForm1.down('#formFieldArea1').removeAll();
					}
				}else if(clickedGrid == 'acm210ukrApprCardGrid') {
					apprCardGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown : function() {
			if(confirm('전체 삭제 하시겠습니까?')) {
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

		},
		onResetButtonDown:function(params) {
			gsSlipNum = "";
			gsProcessPgmId ="";
			
			var masterGrid1 = Ext.getCmp('acm210ukrGrid1');
			masterGrid1.reset();
			masterGrid1.getStore().commitChanges();
			this.setSearchReadOnly(false, false);
			slipForm.getForm().reset(); 
			//tempEditMode = true;
			detailForm1.down('#formFieldArea1').removeAll();
			
			drSum = 0, crSum=0;
			directMasterStore1.removeAll();
			directMasterStore1.commitChanges();
			
			// 카드승인내역 grid
			apprCardGrid.reset();
			apprCardGrid.getStore().commitChanges();
			apprCardRefGrid.reset();
			
			// 참조 조회조건 form
			apprCardRefForm.clearForm();
			apprCardRefForm.setValue('FROM_TRADE_DATE' , UniDate.get('startOfMonth'));
			apprCardRefForm.setValue('TO_TRADE_DATE'   , UniDate.get('today'));
			
			// 카드승인내역 탭 차대변 grid
			slipGrid1.reset();
			slipGrid1.getStore().clearData();
			slipGrid2.reset();
			slipGrid2.getStore().clearData();
			
			UniAppManager.setToolbarButtons(['save'], false);
			
			slipForm.setValue('AC_DATE','${initAcDate}');
			slipForm.setValue('CHARGE_CODE','${chargeCode}');
			slipForm.setValue('CHARGE_NAME','${chargeName}');
			
			if(Ext.isEmpty(params) || (params && Ext.isEmpty(params.SLIP_NUM)))	{
				acm210ukrService.getSlipNum({'AC_DATE':UniDate.getDbDateStr(slipForm.getValue('AC_DATE'))}, function(provider, result ) {
						slipForm.setValue("SLIP_NUM", provider.SLIP_NUM); 
						panelSearch.setValue('SLIP_NUM',provider.SLIP_NUM);
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
		},
		setSearchReadOnly:function(b, isOldData) {
			if(!isOldData) {
				slipForm.getField('AC_DATE').setReadOnly(b);
				slipForm.getField('SLIP_NUM').setReadOnly(b);
			}
			slipForm.getField('DIV_CODE').setReadOnly(b);		   
			
		},
		
		setAccntInfo:function(record) {
			var accnt = record.get('ACCNT');
			if(!Ext.isEmpty(accnt) && accnt != '') {
				Ext.getBody().mask();
				accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
					var rtnRecord = record;
					if(provider){
						UniAppManager.app.loadDataAccntInfo1(rtnRecord, provider)
					
					}else {
						var slipDivi = rtnRecord.get('SLIP_DIVI');
						if(slipDivi == '1' || slipDivi == '2') {
							if(rtnRecord.get('SPEC_DIVI') == 'A') {
								alert(Msg.sMA0040);
							}
						}
					}
					Ext.getBody().unmask();
				})
			}
		},
		// 계정정보 세팅
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
			
			//rtnRecord.set("CREDIT_CODE", "");
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
			UniAppManager.app.fnSetDefaultAcCode(rtnRecord);
			UniAppManager.app.fnSetDefaultAcCodeI7(rtnRecord);
			UniAppManager.app.fnSetDefaultAcCodeA6(rtnRecord);
			UniAppManager.app.fnSetDefaultAcCodeI5(rtnRecord);
		},
		loadDataAccntInfo1:function(rtnRecord, provider) {
			
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
						return;
					}
				}
			}	   
			if(!Ext.isEmpty(provider.ACCNT_CODE)) {
				rtnRecord.set("ACCNT", provider.ACCNT_CODE);
			}else if(!Ext.isEmpty(provider.ACCNT)) {
				rtnRecord.set("ACCNT", provider.ACCNT); //이전행에서 복사한 경우 
			}

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
			
			rtnRecord.set("ACCNT_SPEC"	, provider.ACCNT_SPEC);
			rtnRecord.set("SPEC_DIVI"	, provider.SPEC_DIVI);
			rtnRecord.set("PROFIT_DIVI"	, provider.PROFIT_DIVI);
			rtnRecord.set("JAN_DIVI"	, provider.JAN_DIVI);
				
			rtnRecord.set("PEND_YN"		, provider.PEND_YN);
			rtnRecord.set("PEND_CODE"	, provider.PEND_CODE);
			rtnRecord.set("BUDG_YN"		, provider.BUDG_YN);
			rtnRecord.set("BUDGCTL_YN"	, provider.BUDGCTL_YN);
			rtnRecord.set("FOR_YN"		, provider.FOR_YN);
			
			rtnRecord.set("BUDG_YN"		, provider.BUDG_YN);
			rtnRecord.set("BUDGCTL_YN"	, provider.BUDGCTL_YN);
			rtnRecord.set("FOR_YN"		, provider.FOR_YN);
			
			UniAppManager.app.fnGetProofKind(rtnRecord, provider.ACCNT_CODE);
			
			//rtnRecord.set("CREDIT_CODE", "");
			rtnRecord.set("REASON_CODE", "");
			
			UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, rtnRecord, rtnRecord.get('DIV_CODE')); // 신고사업장 세팅
			UniAppManager.app.fnSetBillDate(rtnRecord)
			UniAppManager.app.fnSetDefaultAcCode(rtnRecord);
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
			
			if((isAddRow && store.getCount() == 0 )) {      // 처음 행 추가 한경우
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
			return false;
		},
		fnAddSlipRecord:function(){
			// loading
			if(addLoading) {
				Ext.getBody().mask();
				fnAddSlipMessageWin();
				return;
			}
			addLoading = true;
			var activeTab, activeTabId ;
			if(tab){
				activeTab   = tab.getActiveTab();
				activeTabId = activeTab.getItemId();
			}
			var grid  = this.getActiveGrid();
			var store = grid.getStore();
			
			var selectedRecord  = grid.getSelectedRecord();
			var nextRecordIndex = store.indexOf(selectedRecord)+1;
			var nextRecord      = store.getAt(nextRecordIndex);
				
			// 순번 생성
			var slipSeq = Unilite.nvl(directMasterStore1.max("SLIP_SEQ"),0)+1 ;
			// 순번 생성 End
			
			var slipDivi       = slipForm.getValue('SLIP_DIVI');
			var recordSlipDivi = "";
			if(slipDivi=="3"){
				recordSlipDivi = "3";
			} else if(slipDivi=="1"){
				recordSlipDivi = "2";
			} else if(slipDivi=="2"){
				recordSlipDivi = "1";
			}
			
			if(recordSlipDivi == null || typeof recordSlipDivi == 'undefined' || recordSlipDivi == "") {
				recordSlipDivi = "3";
				slipDivi = "3";
			}
			
			var r = {
				'AC_DATE'		: slipForm.getValue('AC_DATE'),
				'AC_DAY'		: Ext.Date.format(slipForm.getValue('AC_DATE'),'d'),
				'SLIP_NUM'		: slipForm.getValue('SLIP_NUM'),
				'SLIP_SEQ'		: slipSeq,
				 
				'OLD_AC_DATE'	: slipForm.getValue('AC_DATE'),
				'OLD_SLIP_NUM'	: slipForm.getValue('SLIP_NUM'),
				'OLD_SLIP_SEQ'	: slipSeq,
			
				'IN_DIV_CODE'	: slipForm.getValue('DIV_CODE'),
				'IN_DEPT_CODE'	: slipForm.getValue('DEPT_CODE'),
				'IN_DEPT_NAME'	: slipForm.getValue('DEPT_NAME'),
				'SLIP_DIVI'		: Ext.isEmpty(selectedRecord) ? recordSlipDivi : selectedRecord.get("SLIP_DIVI") ,
				'DR_CR'			: slipDivi=="1" ? "2" :(Ext.isEmpty(selectedRecord) ? "1":selectedRecord.get("DR_CR")),
				'DIV_CODE'		: slipForm.getValue('DIV_CODE'),
				'DEPT_CODE'		: baseInfo.gsDeptCode,
				'DEPT_NAME'		: baseInfo.gsDeptName,
				
				'CUSTOM_CODE'	: (Ext.isEmpty(selectedRecord) || baseInfo.customCodeCopy == "N" ) ? '': selectedRecord.get('CUSTOM_CODE'),
				'CUSTOM_NAME'	: (Ext.isEmpty(selectedRecord) || baseInfo.customCodeCopy == "N" ) ? '': selectedRecord.get('CUSTOM_NAME'),
				'POSTIT_YN'		: 'N',
				'INPUT_USER_ID'	: UserInfo.userID,
				'CHARGE_CODE'	: slipForm.getValue('CHARGE_CODE'),
				
				'AP_DATE'		: UniDate.get('today'),
				'AP_USER_ID'	: UserInfo.userID,
				'AP_CHARGE_CODE': '${chargeCode}'
			};
			
			var mRow = grid.createRow(r);
			addLoading = false;
			
			UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, mRow, slipForm.getValue('DIV_CODE')); // 신고사업장 세팅
		}
		// 자산부채특성이 F1, F2일 경우 AC_DATA에 전표일 setting
		,fnSetBillDate: function(record) {
			
			var sExDate   = UniDate.getDbDateStr(record.get('AC_DATE'));
			var sSpecDivi =  record.get('SPEC_DIVI');
			
			if( sSpecDivi == "F1" || sSpecDivi == "F2" ) {
				this.fnSetAcCode(record, "I3", sExDate)
			}
	
		},
		// AC_CODE에 따라 DATA 세팅
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
				if(sBillType == "")  sBillType = "53";
					
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
					sBillType = "53"
				}
				selRecordIdx = store.findBy(function(record){return (record.get("value") == sBillType && record.get("refCode3")==sSaleDivi)});
				var selRecord = store.getAt(selRecordIdx);
				if(selRecord) sProofKindNm = selRecord.get("text");
			}
			
			return {"sBillType":sBillType, "sProofKindNm":sProofKindNm};
			
		},
		fnCheckPendYN: function(record, form) {
			if(baseInfo.gsPendYn == "1") {
				if(record.get('PEND_YN') == 'Y') { // 미결관리여부가 'Y'인 경우
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
		fnSetDefaultAcCode:function(record) {
			for(var i =1 ; i <= 6; i++) {
				if(record.get("AC_CODE"+i.toString()) == 'A3') {
					record.set('AC_DATA'+i.toString()		,record.get("BANK_CODE"));
					record.set('AC_DATA_NAME'+i.toString()	,record.get("BANK_NAME"));
					
				} else if(record.get("AC_CODE"+i.toString()) == 'A4') {
					record.set('AC_DATA'+i.toString()		,record.get("CUSTOM_CODE"));
					record.set('AC_DATA_NAME'+i.toString()	,record.get("CUSTOM_NAME"));
					
				} else if(record.get("AC_CODE"+i.toString()) == 'O1') {
					record.set('AC_DATA'+i.toString()		,record.get("SAVE_CODE"));
					record.set('AC_DATA_NAME'+i.toString()	,record.get("SAVE_NAME"));
					
				} else if(record.get("AC_CODE"+i.toString()) == 'O2') {
					record.set('AC_DATA'+i.toString()		,record.get("BOOK_CODE"));
					record.set('AC_DATA_NAME'+i.toString()	,record.get("BOOK_NAME"));
				}
			}
		},
		fnSetDefaultAcCodeI7:function(record, newValue) {
			var specDivi = record.get("SPEC_DIVI");
			if(specDivi != "F1" && specDivi != "F2" ) { // 부채관련(?)
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
				creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_CODE'), "CREDIT_CODE", null,"CREDIT_NUM", null, null, null,  'VALUE', gridId);
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
				
			//현금영수증(불공제)
			} else if(proofKind == "71" ) {
				openCrediNotWin(record);
				comCodeWin = UniAccnt.comCodePopup(comCodeWin, record, 'REASON_CODE', '', '매입세불공제사유', 'AU', 'A070', 'VALUE');
	
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
								return false;
							}else {
								isNew = true;
							}
						}else if ((dNoteAmtI - newAmt)  < 0 ) { 
							alert(Msg.sMA0332);
							record.set(fidleName, oldAmt);
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
		store    : directMasterStore2,
		grid     : masterGrid1,
		forms    : {'formA:':detailForm1},
		validate : function( type, fieldName, newValue, oldValue, record, eopt) {
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
									'AC_DATE'   : UniDate.getDbDateStr(record.get('AC_DATE')),
									'MONEY_UNIT': newValue
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
		store    : detailStore,
		grid     : apprCardGrid,
		forms    : {},
		validate : function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue) {
				return true;
			}
			
			var rv = true;
			
			switch(fieldName) {
				case 'DIV_CODE':
					UniAccnt.fnGetBillDivCode(UniAppManager.app.cbGetBillDivCode, record, newValue);
					break;
				default:
					break;
			}
			return rv;
			
		}
	}); // validator02
}; // main
</script>