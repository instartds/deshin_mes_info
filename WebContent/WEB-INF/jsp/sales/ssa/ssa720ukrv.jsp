<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa720ukrv"  >
   <t:ExtComboStore comboType="BOR120" pgmId="ssa720ukrv" />		 <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="B066" /> <!-- 계산서유형 -->
   <t:ExtComboStore comboType="AU" comboCode="S080" /> <!-- 응답상태(웹캐시) -->
   <t:ExtComboStore comboType="AU" comboCode="S093" /> <!-- 국세청신고제외여부 -->
   <t:ExtComboStore comboType="AU" comboCode="S094" /> <!-- 국세청신고상태 -->
   <t:ExtComboStore comboType="AU" comboCode="S095" /> <!-- 국세청수정사유 -->
   <t:ExtComboStore comboType="AU" comboCode="S096" /> <!-- 세금계산서구분 -->
   <t:ExtComboStore comboType="AU" comboCode="S099" /> <!-- 생성경로 -->
   <t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 주영업담당 -->
   <t:ExtComboStore comboType="AU" comboCode="S076" /> <!-- 영수 / 청구구분 -->
   
   <t:ExtComboStore comboType="AU" comboCode="S084" /> <!-- 전자세금계산서 연계여부 -->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsSsa560UkrLink: '${gsSsa560UkrLink}',
	gsTem100UkrLink: '${gsTem100UkrLink}',
	gsStr100UkrLink: '${gsAtx110UkrLink}',
	gsOptQ: '${gsOptQ}',
	gsBillYN: ${gsBillYN}
};

function appMain() {
	var sumAmountTotI = 0;
	var newYN_ISSUE	= 0;																//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다 (중복수행 방지를 위해 panelResult에서만 처리)


/** Model 정의 
	* @type 
	*/
	Unilite.defineModel('Ssa720ukrvWebCashModel', {			//웹캐시용 모델
		fields: [  	 
			{name:'CHK'					,text:'<t:message code="system.label.sales.selection" default="선택"/>'				,type: 'string'},
			{name:'TRANSYN_NAME' 		,text:'전송'				,type: 'string'},
			{name:'STAT_CODE' 			,text:'상태'				,type: 'string' , comboType: 'AU' , comboCode: 'S080'},
			{name:'STS'					,text:'상태'				,type: 'string'},
			{name:'WEB_TAXBILL'			,text:'상세조회'			,type: 'string'},
			{name:'CRT_LOC'				,text:'<t:message code="system.label.sales.creationpath" default="생성경로"/>'			,type: 'string' , comboType: 'AU' , comboCode: 'S099'},
			{name:'BILL_FLAG'			,text:'세금계산서구분'		,type: 'string' , comboType: 'AU' , comboCode: 'S096'},
			{name:'TAX_TYPE'			,text:'세금계산서종류'		,type: 'string'},
			{name:'POPS_CODE'			,text:'영수/청구'			,type: 'string' , comboType: 'AU' , comboCode: 'S076'},
			{name:'REGS_DATE'			,text:'<t:message code="system.label.sales.publishdate" default="발행일"/>'			,type: 'uniDate'},
			{name:'SELR_CORP_NO'		,text:'사업자번호'			,type: 'string'},			//'공급자 사업자번호'
			{name:'SELR_CORP_NM'		,text:'업체명'			,type: 'string'},			//'공급자 업체명'
			{name:'SELR_CODE'			,text:'종사업자번호'		,type: 'string'},			//'공급자 종사업자번호'
			{name:'SELR_CEO'			,text:'대표자명'			,type: 'string'},			//'공급자 대표자명'
			{name:'SELR_BUSS_CONS'		,text:'업태'				,type: 'string'},			//'공급자 업태'
			{name:'SELR_BUSS_TYPE'		,text:'업종'				,type: 'string'},			//'공급자 업종'
			{name:'SELR_ADDR'			,text:'<t:message code="system.label.sales.address" default="주소"/>'					,type: 'string'},			//'공급자 주소'
			{name:'SELR_CHRG_NM'		,text:'<t:message code="system.label.sales.chargername" default="담당자명"/>'			,type: 'string'},			//'공급자 담당자명'
			{name:'SELR_CHRG_POST'		,text:'<t:message code="system.label.sales.departmentname" default="부서명"/>'		,type: 'string'},			//'공급자 부서명'
			{name:'SELR_CHRG_TEL'		,text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				,type: 'string'},			//'공급자 전화번호'
			{name:'SELR_CHRG_EMAIL'		,text:'이메일주소'			,type: 'string'},			//'공급자 이메일주소'
			{name:'SELR_CHRG_MOBL'		,text:'휴대폰번호'			,type: 'string'},			//'공급자 휴대폰번호'
			{name:'CUSTOM_CODE'			,text:'<t:message code="system.label.sales.client" default="고객"/>'					,type: 'string'},
			{name:'BUYR_CORP_NM'		,text:'<t:message code="system.label.sales.clientname" default="고객명"/>'			,type: 'string'},
			{name:'BUYR_GB'				,text:'<t:message code="system.label.sales.classficationcode" default="구분코드"/>'	,type: 'string'},			//'공급받는자 구분코드'
			{name:'BUYR_CORP_NO'		,text:'사업자번호'			,type: 'string'},			//'공급받는자 사업자번호'
			{name:'BUYR_CODE'			,text:'종사업자번호'		,type: 'string'},			//'공급받는자 종사업자번호'
			{name:'BILLTYPENAME'		,text:'<t:message code="system.label.sales.billclass" default="계산서유형"/>'			,type: 'string'},
//			{name:'ISSUE_DETAILS'		,text:'발행내역'			,type: 'string'},
			{name:'CHRG_AMT'			,text:'<t:message code="system.label.sales.supplyamount" default="공급가액"/>'			,type: 'uniPrice'},
			{name:'TAX_AMT'				,text:'<t:message code="system.label.sales.taxamount" default="세액"/>'				,type: 'uniPrice'},
			{name:'TOTL_AMT'			,text:'<t:message code="system.label.sales.totalamount" default="합계"/>'				,type: 'uniPrice'},
			{name:'BUYR_CEO'			,text:'대표자명'			,type: 'string'},			//'공급받는자 대표자명'
			{name:'BUYR_BUSS_CONS'		,text:'업태'				,type: 'string'},			//'공급받는자 업태'
			{name:'BUYR_BUSS_TYPE'		,text:'업종'				,type: 'string'},			//'공급받는자 업종'
			{name:'BUYR_ADDR'			,text:'<t:message code="system.label.sales.address" default="주소"/>'					,type: 'string'},			//'공급받는자 주소'
			{name:'BUYR_CHRG_NM1'		,text:'<t:message code="system.label.sales.charger" default="담당자"/>'				,type: 'string'},			//'전자문서담당자'
			{name:'BUYR_CHRG_TEL1'		,text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				,type: 'string'},			//'전자문서전화번호'
			{name:'BUYR_CHRG_MOBL1'		,text:'핸드폰'			,type: 'string'},			//'전자문서핸드폰'
			{name:'BUYR_CHRG_EMAIL1'	,text:'E-MAIL'			,type: 'string'},			//'전자문서E-MAIL'
			{name:'BUYR_CHRG_NM2'		,text:'담당자2'			,type: 'string'},			//'전자문서담당자2'
			{name:'BUYR_CHRG_MOBL2'		,text:'핸드폰2'			,type: 'string'},			//'전자문서핸드폰2'
			{name:'BUYR_CHRG_EMAIL2'	,text:'E-MAIL2'			,type: 'string'},			//'전자문서E-MAIL2'
			//위수탁발행 사용 안 함
//			{name:'BROK_CUSTOM_CODE'	,text:'수탁거래처코드'		,type: 'string'},
//			{name:'BROK_COMPANY_NUM'	,text:'수탁사업자번호'		,type: 'string'},
//			{name:'BROK_TOP_NUM'		,text:'수탁주민번호'		,type: 'string'},
//			{name:'BROK_PRSN_NAME'		,text:'수탁담당자명'		,type: 'string'},
//			{name:'BROK_PRSN_EMAIL'		,text:'수탁이메일'			,type: 'string'},
			{name:'SEND_DATE'			,text:'전송일시'			,type: 'uniDate'},
			{name:'ISSU_SEQNO'			,text:'전자문서번호'		,type: 'string'},
			{name:'SELR_MGR_ID3'		,text:'<t:message code="system.label.sales.billno" default="계산서번호"/>'			,type: 'string'},
			{name:'SND_STAT'			,text:'메일전송상태'		,type: 'string'},
			{name:'RCV_VIEW_YN'			,text:'메일확인여부'		,type: 'string'},
			{name:'NOTE1'				,text:'<t:message code="system.label.sales.remarks" default="비고"/>'				,type: 'string'},
			{name:'MODY_CODE'			,text:'수정코드'			,type: 'string'},
			{name:'REQ_STAT_CODE'		,text:'요청상태코드'		,type: 'string'},
			{name:'BILL_PUBLISH_TYPE'	,text:'발행 유형 '			,type: 'string'},
			{name:'RECP_CD'				,text:'역발행 구분 '		,type: 'string'},
			{name:'BILL_TYPE'			,text:'매출/매입구분'		,type: 'string'},
			{name:'SND_MAIL_YN'			,text:'Email 발행요청유무'	,type: 'string'},
			{name:'SND_SMS_YN'			,text:'SMS 발행요청유무'	,type: 'string'},
			{name:'SND_FAX_YN'			,text:'FAX 발행요청여부'	,type: 'string'},
			{name:'COMP_CODE'			,text:'<t:message code="system.label.sales.compcode" default="법인코드"/>'			,type: 'string'},
			{name:'DIV_CODE'			,text:'<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'	,type: 'string'},
			{name:'SALE_DIV_CODE'		,text:'<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'	,type: 'string'},
			{name:'DEL_YN'				,text:'삭제여부'			,type: 'string'},
			{name:'REPORT_AMEND_CD'		,text:'신고문서 수정사유 코드'	,type: 'string'},
			{name:'BFO_ISSU_ID'			,text:'당초승인번호'		,type: 'string'},
			{name:'ERR_GUBUN'			,text:'에러구분'			,type: 'string'},
			{name:'ISSU_ID'				,text:'국세청 일련번호'		,type: 'string'},
			{name:'ERR_MSG'				,text:'에러메세지'			,type: 'string'},
			{name:'BEFORE_PUB_NUM'		,text:'수정전세금계산번호'	,type: 'string'},
			{name:'ORIGINAL_PUB_NUM'	,text:'원본세금계산서번호'	,type: 'string'},
			{name:'PLUS_MINUS_TYPE'		,text:'계산서구분'			,type: 'string'},
			{name:'SEQ_GUBUN'			,text:'순번정렬'			,type: 'string'},
			{name:'BUSINESS_TYPE'		,text:'사업자구분'			,type: 'string'}
		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ssa720ukrvService.selectWebCashMaster' ,
			update	: 'ssa720ukrvService.saveWebCash',
			syncAll	: 'ssa720ukrvService.saveAllWebCash'
		}
	});

	var webCashStore = Unilite.createStore('ssa720ukrvWebCashStore',{
		model	: 'Ssa720ukrvWebCashModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy,
		loadStoreRecords: function(billSendYn, issueGubun)	{
			//조회 시, 에러내용 / 총합계 reset
			centerNorth2Panel.reset();
			sumAmountTotI = 0;
			var param= Ext.getCmp('resultForm').getValues();
			
			if(!Ext.isEmpty(billSendYn)) {
				param.BILL_SEND_YN = billSendYn;
			}
			if(!Ext.isEmpty(issueGubun)) {
				param.ISSUE_GUBUN = issueGubun;
			}
			
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore : function(OPR_FLAG)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();

			var selRecords = webCashGrid.getSelectedRecords();
			Ext.each(selRecords, function(record, idx){
				record.set('OPR_FLAG', OPR_FLAG);
			});
			
			var paramMaster 			= panelResult.getValues();
			paramMaster.OPR_FLAG		= OPR_FLAG;
			paramMaster.LANG_TYPE		= UserInfo.userLang
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//return 값 저장
						var master = batch.operations[0].getResultSet();
						
						UniAppManager.app.onQueryButtonDown();
					},

					failure: function(batch, option) {
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ssa720ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					//directStore.loadStoreRecords(records[0]);
					UniAppManager.app.fnWebCashColSet(records);				//전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기		
					store.commitChanges();
				}
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(!this.uniOpt.isMaster) {
				if (records.length > 0) {
					UniAppManager.setToolbarButtons('save', false);
					var msg = records.length + Msg.sMB001;					//'건이 조회되었습니다.';
					UniAppManager.updateStatus(msg, true);	
				}
			}
		}
	});


/** 검색조건 (Search Panel)
	* @type 
	*/
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight	:-100,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: 0,
		spacing	: 2,
		border	: false,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>', 
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox', 
				comboType	: 'BOR120', 
				tdAttrs		: {width: 350},
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
				
					}
				}
			},{
				fieldLabel		: '등록일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'BILL_DATE_FR',
				endFieldName	: 'BILL_DATE_TO',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				allowBlank		: true,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.billclass" default="계산서유형"/>', 
				name		: 'BILL_TYPE', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'B066',
				listeners	:{
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},
			Unilite.popup('AGENT_CUST', { 
				fieldLabel		: '<t:message code="system.label.sales.client" default="고객"/>',
				textFieldName	: 'CUSTOM_NAME',
				valueFieldName	: 'CUSTOM_CODE',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){	
						popup.setExtParam({'CUSTOM_TYPE' : '3'});
					}
				}
			}),{
				fieldLabel		: '입력일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'INSERT_DB_TIME_FR',
				endFieldName	: 'INSERT_DB_TIME_TO',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.creationpath" default="생성경로"/>', 
				name		: 'CRT_LOC', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'S099',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},
			Unilite.popup('AGENT_CUST', { 
				fieldLabel		: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>', 
				textFieldName	: 'MANAGE_CUST_NM',
				valueFieldName	: 'MANAGE_CUST_CD',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('MANAGE_CUST_NM', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('MANAGE_CUST_CD', '');
						}
					}, 
					applyextparam: function(popup){	
						popup.setExtParam({'CUSTOM_TYPE' : '3'});
					}
				}
			}),{
				fieldLabel		: '전송일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'SEND_LOG_TIME_FR',
				endFieldName	: 'SEND_LOG_TIME_TO',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},{
				fieldLabel	: '상태', 
				name		: 'BILLSTAT', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'S050',
				listeners	:{
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '전송여부', 
				xtype		: 'uniRadiogroup',
				name		: 'BILL_SEND_YN',
				id			: 'BILL_SEND_YN',
				comboType	: 'AU', 
				comboCode	: 'B087',
				value		: 'N',
				width		: 250,
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						console.log(" BILL_SEND_YN : ", newValue);
						panelResult.setActionBtn(newValue);

						if (newYN_ISSUE == '1'){					//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN_ISSUE = '0'
							return false;
						}else {
							centerNorth2Panel.reset();
							webCashStore.loadStoreRecords(newValue.BILL_SEND_YN);
						}	
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '발행구분',
				id			: 'rdoSelect0',
				width		: 250,
				items		: [{
					boxLabel: '정발행', 
					name	: 'ISSUE_GUBUN',
					inputValue: '1',
//					width	: 70, 
					checked	: true  
				},{
					boxLabel: '역발행',
					inputValue: '2',
					name	: 'ISSUE_GUBUN'//, 
//					width	: 70
				}/*,{										//위수탁발행 사용 안 함
					boxLabel: '위수탁발행',
					inputValue: '3',
					name	: 'ISSUE_GUBUN', 
					width	: 100
				}*/],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('ISSUE_GUBUN').setValue(newValue.ISSUE_GUBUN);
						
						//위수탁발행 사용 안 함
//						if (newValue.ISSUE_GUBUN !=3) {
//							webCashGrid.getColumn('BROK_CUSTOM_CODE').setHidden(true);
//							webCashGrid.getColumn('BROK_COMPANY_NUM').setHidden(true);
//							webCashGrid.getColumn('BROK_TOP_NUM').setHidden(true);
//							webCashGrid.getColumn('BROK_PRSN_NAME').setHidden(true);
//							webCashGrid.getColumn('BROK_PRSN_EMAIL').setHidden(true);
//							
//						} else {
//							webCashGrid.getColumn('BROK_CUSTOM_CODE').setHidden(false);
//							webCashGrid.getColumn('BROK_COMPANY_NUM').setHidden(false);
//							webCashGrid.getColumn('BROK_TOP_NUM').setHidden(false);
//							webCashGrid.getColumn('BROK_PRSN_NAME').setHidden(false);
//							webCashGrid.getColumn('BROK_PRSN_EMAIL').setHidden(false);
//						}

						if (newYN_ISSUE == '1'){					//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN_ISSUE = '0'
							return false;
						}else {
							centerNorth2Panel.reset();
							webCashStore.loadStoreRecords(null, newValue.ISSUE_GUBUN);
						}	
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'BUSI_PRSN',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('salesPrsn')
			},{
				fieldLabel	: '수량단위',
				name		: 'UNIT_OPT',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'S053',
				allowBlank	: false,
				value		: BsaCodeInfo.gsOptQ,
				width		: 250
			},{					
				fieldLabel	: '<t:message code="system.label.sales.remarks" default="비고"/>',
				name		: 'REMARK',
				xtype		: 'uniTextfield',
				colspan		: 2,
				width		: 560,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}
		],
		setActionBtn: function(value)	{
			var actionPanel = Ext.getCmp('ssa720ukrv1ActionPanel');
			console.log("value : ", value);
			if(value.BILL_SEND_YN == "N")	{
				actionPanel.down('#sendBtn').setDisabled(false);
				actionPanel.down("#sendEmailBtn").setDisabled(true);
				actionPanel.down("#cancelSendBtn").setDisabled(true);
				//20190604 전자세금계산서 전송 시 담당자에게 메일 발송 되므로 숨김: 용도가 불명확
//				actionPanel.down("#confirmEmailBtn").setDisabled(false);
			} else {
				actionPanel.down("#sendBtn").setDisabled(true);
				actionPanel.down("#sendEmailBtn").setDisabled(false);
				actionPanel.down("#cancelSendBtn").setDisabled(false);
				//20190604 전자세금계산서 전송 시 담당자에게 메일 발송 되므로 숨김: 용도가 불명확
//				actionPanel.down("#confirmEmailBtn").setDisabled(true);
			}
		}
	})
	
	var webCashGrid = Unilite.createGrid('ssa720ukrvGrid', {
		store	: webCashStore,
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			useMultipleSorting	: false, 	//정렬 버튼 사용 여부
			useLiveSearch		: false,	//내용검색 버튼 사용 여부
			onLoadSelectFirst	: false,
			dblClickToEdit		: true,
			useGroupSummary		: false,	//그룹핑 버튼 사용 여부
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
			copiedRow			: false,
			filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
 				useState		: true,		//그리드 설정 버튼 사용 여부
 				useStateList	: true		//그리드 설정 목록 사용 여부
			}
		},
		tbar:[{
			fieldLabel	: '영수/청구', 
			name		: 'POPS_CODE', 
			itemId		: 'popsCode',
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'S076',
			labelWidth	: 60,
			width		: 150
		},{
			xtype	: 'button',
			text	: '전체반영',
			handler	: function()	{
				var gbnField = webCashGrid.down("#popsCode") ;
				if(gbnField) {
					var gbn = gbnField.getValue();
					Ext.each(webCashStore.data.items, function(record, idx){
						record.set('POPS_CODE', gbn);
					})
				}
			}
		},{	
				xtype : 'tbspacer',
				width : 8
		},{	
				xtype : 'tbseparator'
		},{	
				xtype : 'tbspacer',
				width : 8
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly		: true,
			toggleOnClick	: true,
			listeners		: {				
				beforeselect: function(rowSelection, record, index, eOpts) {
					//Error컬럼은 선택 못하게(20190604: 단, 전송일 때는 전송취소를 해야하므로 체크할 수 있도록 수정)
					if(record.get('TRANSYN_NAME') == 'Error' && Ext.getCmp('BILL_SEND_YN').getChecked()[0].inputValue == 'N'){
						return false;
					}
				},
				select: function(grid, record, index, rowIndex, eOpts ){
					sumAmountTotI = sumAmountTotI + record.get('TOTL_AMT');
					centerNorth2Panel.setValue('TXT_TOTAL', sumAmountTotI)
			  	},
				deselect:  function(grid, record, index, rowIndex, eOpts ){
					sumAmountTotI = sumAmountTotI - record.get('TOTL_AMT');
					centerNorth2Panel.setValue('TXT_TOTAL', sumAmountTotI)
				}
			}
		}),
		viewConfig: {
			forceFit		: true,
			showPreview		: true, // custom property
			enableRowBody	: true, // required to create a second, full-width row to show expanded Record data
			getRowClass		: function(record, rowIndex, rp, ds){ // rp = rowParams
				if(record.get("DEL_YN") != "Y" && record.get("STS") != ""){
					return 'essRow';
				}
				return 'optRow';
			},
			getRowClass: function(record, rowIndex, rowParams, store){			//오류 row 빨간색 표시		
				var cls = '';

				if(record.get('TRANSYN_NAME') == 'Error'){
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		},
		features: [
			{id : 'webCashGridTotal' ,   ftype: 'uniSummary', 		 showSummaryRow: true}
		],
		columns: [{ 
				xtype	: 'rownumberer',
				align	: 'center  !important',
				width	: 35,
				sortable: false,
				resizable: true
			},{
				dataIndex: 'WEB_TAXBILL'		, width: 100		,
				renderer: function (val, meta, record) {
//					if (!Ext.isEmpty(record.data.ISSU_ID) && record.data.STAT_CODE == '00') {
					if (!Ext.isEmpty(record.data.ISSU_ID) && record.data.TRANSYN_NAME == '전송') {
						return '<a href="https://web.taxbill365.com/jsp/corp/comm/comm_0001_02.jsp?SCH_GB=2&ISSU_ID=' + record.data.ISSU_ID + '" target="_blank">' + '상세조회' + '</a>';
					} else {
						return '';
					}
				}
			},
			{dataIndex: 'CHK'							, width:33		,locked: false, hidden: true},
			{dataIndex: 'TRANSYN_NAME'					, width:80		,locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
			}},
			{dataIndex: 'STAT_CODE'						, width:100		,locked: false ,hidden: true},
			{dataIndex: 'STS'							, width:93		,locked: false},
			{dataIndex: 'CRT_LOC'						, width:80		,locked: false},
			{dataIndex: 'BILL_FLAG'						, width:100		,locked: false},
			{dataIndex: 'TAX_TYPE'						, width:100		,locked: false ,hidden: true},
			{dataIndex: 'POPS_CODE'						, width:100		,locked: false },
			{dataIndex: 'REGS_DATE'						, width:86		,locked: false },
			{dataIndex: 'SELR_CORP_NO'					, width:100		,locked: false ,hidden: true},
			{dataIndex: 'SELR_CORP_NM'					, width:100		,hidden: true},
			{dataIndex: 'SELR_CODE'						, width:100		,hidden: true},
			{dataIndex: 'SELR_CEO'						, width:100		,hidden: true},
			{dataIndex: 'SELR_BUSS_CONS'				, width:100		,hidden: true},
			{dataIndex: 'SELR_BUSS_TYPE'				, width:100		,hidden: true},
			{dataIndex: 'SELR_ADDR'						, width:100		,hidden: true},
			{dataIndex: 'SELR_CHRG_NM'					, width:100		,hidden: true},
			{dataIndex: 'SELR_CHRG_POST'				, width:100		,hidden: true},
			{dataIndex: 'SELR_CHRG_TEL'					, width:100		,hidden: true},
			{dataIndex: 'SELR_CHRG_EMAIL'				, width:100		,hidden: true},
			{dataIndex: 'SELR_CHRG_MOBL'				, width:100		,hidden: true},
			{dataIndex: 'CUSTOM_CODE'					, width:86		,locked: false},
			{dataIndex: 'BUYR_CORP_NM'					, width:160		,locked: false},
			{dataIndex: 'BUYR_GB'						, width:100		,hidden: true},
			{dataIndex: 'BUYR_CORP_NO'					, width:100		,
				renderer:function(value, metaData, record)	{
					var r = value;
					if(record.get('BUYR_GB') == '02') r ='*************'
					return r;
				}
			},
			{dataIndex: 'BUYR_CODE'						, width:100 },
			{dataIndex: 'BILLTYPENAME'					, width:100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + webCashStore.getCount() + '건','건수 : ' + webCashStore.getCount() + '건');
				}
			},
//			{dataIndex: 'ISSUE_DETAILS'					, width:113 },
			{dataIndex: 'CHRG_AMT'						, width:113 , summaryType: 'sum'},
			{dataIndex: 'TAX_AMT'						, width:86  , summaryType: 'sum'},
			{dataIndex: 'TOTL_AMT'						, width:113 , summaryType: 'sum'},
			{dataIndex: 'BUYR_CEO'						, width:86 },
			{dataIndex: 'BUYR_BUSS_CONS'				, width:66 },
			{dataIndex: 'BUYR_BUSS_TYPE'				, width:200 },
			{dataIndex: 'BUYR_ADDR'						, width:400 },
			{dataIndex: 'BUYR_CHRG_NM1'					, width:100 ,
				editor: Unilite.popup("CUST_BILL_PRSN_G",{
					textFieldName:'BILLPRSN',
					listeners:{
						onSelected: {
							fn:function(records, type)	{
								var grdRecord = webCashGrid.uniOpt.currentRecord;
								grdRecord.set('BUYR_CHRG_NM1',records[0]['PRSN_NAME']);
								grdRecord.set('BUYR_CHRG_EMAIL1',records[0]['MAIL_ID']);
							},
							scope: this
						},
						onClear: {
							fn: function(records, type)	{
								var grdRecord = webCashGrid.uniOpt.currentRecord;
								grdRecord.set('BUYR_CHRG_NM1','');
								grdRecord.set('BUYR_CHRG_EMAIL1','');
							}
						},
						applyextparam: function(popup){
							var grdRecord = webCashGrid.uniOpt.currentRecord;
							popup.setExtParam({'SEARCH_TYPE' : 'BILLPRSN'});
							popup.setExtParam({'CUSTOM_CODE' : grdRecord.get('CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'BUYR_CHRG_TEL1'				, width:100 },
			{dataIndex: 'BUYR_CHRG_MOBL1'				, width:100 },
			{dataIndex: 'BUYR_CHRG_EMAIL1'				, width:166 ,
				editor: Unilite.popup("CUST_BILL_PRSN_G",{
					textFieldName:'BUYR_CHRG_EMAIL1',
					listeners:{
						onSelected: {
							fn:function(records, type)	{
								var grdRecord = webCashGrid.uniOpt.currentRecord;
								grdRecord.set('BUYR_CHRG_NM1',records[0]['PRSN_NAME']);
								grdRecord.set('BUYR_CHRG_EMAIL1',records[0]['MAIL_ID']);
							},
							scope: this
						},
						onClear: {
							fn: function(records, type)	{
								var grdRecord = webCashGrid.uniOpt.currentRecord;
								grdRecord.set('BUYR_CHRG_NM1','');
								grdRecord.set('BUYR_CHRG_EMAIL1','');
							}
						},
						applyextparam: function(popup){	
							var grdRecord = webCashGrid.uniOpt.currentRecord;
							popup.setExtParam({'SEARCH_TYPE' : 'REMAIL'});
							popup.setExtParam({'CUSTOM_CODE' : grdRecord.get('CUSTOM_CODE')});
						}
					}
				})
			},
			{dataIndex: 'BUYR_CHRG_NM2'					, width:100 },
			{dataIndex: 'BUYR_CHRG_MOBL2'				, width:100 },
			{dataIndex: 'BUYR_CHRG_EMAIL2'				, width:166 },
			//위수탁발행 사용 안 함
//			{dataIndex: 'BROK_CUSTOM_CODE'				, width:140	, hidden: true },
//			{dataIndex: 'BROK_COMPANY_NUM'				, width:140	, hidden: true },
//			{dataIndex: 'BROK_TOP_NUM'					, width:120	, hidden: true },
//			{dataIndex: 'BROK_PRSN_NAME'				, width:120	, hidden: true },
//			{dataIndex: 'BROK_PRSN_EMAIL'				, width:180	, hidden: true },
			{dataIndex: 'SEND_DATE'						, width:133 },
			{dataIndex: 'ISSU_SEQNO'					, width:133 },
			{dataIndex: 'SELR_MGR_ID3'					, width:133 },
			{dataIndex: 'NOTE1'							, width:133 },
			{dataIndex: 'MODY_CODE'						, width:133 },
			{dataIndex: 'REQ_STAT_CODE'					, width:100 ,hidden: true},
			{dataIndex: 'RECP_CD'						, width:100 ,hidden: true},
			{dataIndex: 'BILL_TYPE'						, width:100 ,hidden: true},
			{dataIndex: 'SND_MAIL_YN'					, width:100 ,hidden: true},
			{dataIndex: 'SND_SMS_YN'					, width:100 ,hidden: true},
			{dataIndex: 'SND_FAX_YN'					, width:100 ,hidden: true},
			{dataIndex: 'COMP_CODE'						, width:100 ,hidden: true},
			{dataIndex: 'DIV_CODE'						, width:100 ,hidden: true},
			{dataIndex: 'SALE_DIV_CODE'					, width:100 ,hidden: true},
			{dataIndex: 'DEL_YN'						, width:100 ,hidden: true},
			{dataIndex: 'REPORT_AMEND_CD'				, width:100 ,hidden: true},
			{dataIndex: 'BFO_ISSU_ID'					, width:100 ,hidden: true},
			{dataIndex: 'ERR_GUBUN'						, width:33	,hidden: false},
			{dataIndex: 'ISSU_ID'						, width:166 },
			{dataIndex: 'ERR_MSG'   					, flex : 1	, minWidth: 300},
			{dataIndex: 'BEFORE_PUB_NUM'				, width:100 ,hidden:true},
			{dataIndex: 'ORIGINAL_PUB_NUM'				, width:100 ,hidden:true},
			{dataIndex: 'PLUS_MINUS_TYPE'				, width:100 ,hidden:true},
			{dataIndex: 'SEQ_GUBUN'						, width:100 ,hidden:true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['POPS_CODE', 'BUYR_CHRG_NM1', 'BUYR_CHRG_EMAIL1'])){
					return true;
					
				} else {
					return false;
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.app.fnSetErrMsg(record);
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
				if(colName =="BUYR_CORP_NO") {
					if(record.get('BUYR_GB') == '02') {
						webCashGrid.openCryptRepreNoPopup(record);
					}
				}
				if(colName == 'CRT_LOC')	{
					var crtLoc = record.get(colName);
					switch(crtLoc)	{
						case '1':	
							var rec = {data : {prgID : BsaCodeInfo.gsSsa560UkrLink}};
							parent.openTab(rec, '/sales/'+BsaCodeInfo.gsSsa560UkrLink+'.do', {});
							break;
						case '3':
							var rec = {data : {prgID : BsaCodeInfo.gsSsa560UkrLink}};
							parent.openTab(rec, '/sales/'+BsaInfo.gsTem100UkrLink+'.do', {});
							break;
						case '5':
							if( record.get("BILL_FLAG") != '2')	{
								var rec = {data : {prgID : BsaCodeInfo.gsSsa560UkrLink}};
								parent.openTab(rec, '/sales/'+BsaCodeInfo.gsStr100UkrLink+'.do', {});
							}
						default:
							break;
					}
				}
			}
		},
		openCryptRepreNoPopup:function( record )	{
			if(record)	{
				var params = {'REPRE_NO': record.get('BUYR_CORP_NO'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BUYR_CORP_NO', 'BUYR_CORP_NO', params);
			}		
		}
	});
	
	var centerNorthPanel = {
		id		:'ssa720ukrv1ActionPanel',
		region	: 'north' ,
		weight	: -100,
		border	: false,
		layout	: {type: 'hbox', align: 'stretch'},
		defaults: {
			margin:'0 0 0 0'
		},
		items	: [{
			xtype	: 'component',
			flex	: 1,
			margin	: '5 2 2 2',
			style	: {
				'color'			: 'blue',
				'vertical-align': 'middle',
				'line-height'	: '29px'
			},
			html: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※ 공급자는 사업장정보, 공급받는자는 거래처정보에서 회사명, 대표자, 업태, 업종, 주소, 전화번호, EMAIL 등을 참조합니다.'
		},{
			xtype	: 'container',
			layout	: 'hbox',
			defaults: {
				margin: '10 2 0 0'
			},
			style:{
				'vertical-align': 'middle',
				'line-height'	: '22px'
			},
			items:[{
				xtype	: 'button',
				text	: '전송',
				itemId	: 'sendBtn',
				width	: 90,
				handler	: function()	{
					var records = webCashGrid.getSelectionModel().getSelection();
					if(Ext.isEmpty(records)) {
						Unilite.messageBox(Msg.fsbMsgS0037);				//전송할 데이터가 존재하지 않습니다.
						return false;
					}
					webCashStore.saveStore('N');
				}
			},{
				xtype	: 'button',
				text	: '전송취소',
				itemId	: 'cancelSendBtn',
				disabled: true,
				width	: 90,
				handler	: function()	{
					var records = webCashGrid.getSelectionModel().getSelection();
					if(Ext.isEmpty(records)) {
						Unilite.messageBox(Msg.fsbMsgS0037);				//전송할 데이터가 존재하지 않습니다.
						return false;
					}
					webCashStore.saveStore('D');
				}
			},{
				xtype	: 'button',
				text	: '확인메일전송',
				itemId	: 'confirmEmailBtn',
				width	: 90,
				//20190604 전자세금계산서 전송 시 담당자에게 메일 발송 되므로 숨김: 용도가 불명확
				hidden	: true,
				handler	: function()  {
					var records = webCashGrid.getSelectionModel().getSelection();
					var errFlag = false;
					if(Ext.isEmpty(records)) {
						Unilite.messageBox(Msg.fsbMsgS0037);				//전송할 데이터가 존재하지 않습니다.
						return false;
					}
					//메일 주소 확인
					Ext.each(records, function(record) {
						var eMail = record.get('BUYR_CHRG_EMAIL1')
						if(Ext.isEmpty(eMail)) {
							errFlag = true;
							Unilite.messageBox(Msg.sMH1280);
							return false;
						}
					});
					if (!errFlag) {
						webCashStore.saveStore('CM');
					}
				}
			},{
				xtype	: 'button',
				text	: 'Mail 재전송',
				itemId	: 'sendEmailBtn',
				disabled: true,
				width	: 90,
				handler	: function()	{
					var records = webCashGrid.getSelectionModel().getSelection();
					var errFlag = false;
					if(Ext.isEmpty(records)) {
						Unilite.messageBox(Msg.fsbMsgS0037);				//전송할 데이터가 존재하지 않습니다.
						return false;
					}
					//메일 주소 확인
					Ext.each(records, function(record) {
						var eMail = record.get('BUYR_CHRG_EMAIL1')
						if(Ext.isEmpty(eMail)) {
							errFlag = true;
							Unilite.messageBox(Msg.sMH1280);
							return false;
						}
					});
					if (!errFlag) {
						webCashStore.saveStore('M');
					}
				}
			}]
		}]
	};
	
	var centerNorth2Panel = Unilite.createSearchForm('ssa720ukrv1SummaryForm',{
		region	: 'north' ,
		weight	: -100,
		padding	: 0,
		defaults: {
			padding:'2 2 2 2'
		},
		bodyStyle: {
			'background-color':'#D9E7F8'
		},
		border	: true,
		margin	: 1,
		layout	: {type: 'hbox', align: 'stretch'},
		defaultType:'uniTextfield',
		items:[{
			fieldLabel	: '에러내용',
			name		: 'TXT_ERR_MSG',
			labelWidth	: 80,
			flex		: 1,
			readOnly: true
		},{					
			fieldLabel	: '총합계',
			name		: 'TXT_TOTAL',
			xtype		: 'uniNumberfield',
			value		: '0',
			readOnly	: true
		}]
	})
	
	
	Unilite.Main( {
		id			: 'ssa720ukrvApp',
		borderItems	:[ 
	 		webCashGrid,
	 		panelResult,
	 		centerNorthPanel,
	 		centerNorth2Panel
		],
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('BILL_DATE_FR', UniDate.get('today'));
			panelResult.setValue('BILL_DATE_TO', UniDate.get('today'));
			panelResult.setValue('BILL_SEND_YN', 'N');
			panelResult.getField('ISSUE_GUBUN').setValue('1');

			UniAppManager.setToolbarButtons(['reset','newData'], false);
			
			//초기화 시 전표일로 포커스 이동
			panelResult.onLoadSelectText('DIV_CODE');
			
			newYN_ISSUE		= 0;
			sumAmountTotI	= 0;
		},
		onQueryButtonDown: function() {
			centerNorth2Panel.reset();
			webCashStore.loadStoreRecords();
		},
		fnSetErrMsg: function(record) {	// 에러폼에 에러메시지 삽입		
			if(record.get('TRANSYN_NAME') == 'Error')	{
				if(record.get('ERR_GUBUN') == '1'){
					centerNorth2Panel.setValue('TXT_ERR_MSG', Msg.fStMsgS0092);
				} else if(record.get('ERR_GUBUN') == '2'){
					centerNorth2Panel.setValue('TXT_ERR_MSG', Msg.fStMsgS0093);
				} else if(record.get('ERR_GUBUN') == '3'){
					centerNorth2Panel.setValue('TXT_ERR_MSG', Msg.fStMsgS0094);
				} else if(record.get('ERR_GUBUN') == '4'){
					centerNorth2Panel.setValue('TXT_ERR_MSG', Msg.fStMsgS0095);
				} else if(record.get('ERR_GUBUN') == '5'){
					centerNorth2Panel.setValue('TXT_ERR_MSG', '공급 받는자 정보를 확인하세요.(업종, 업태)');
				} else  if(record.get('ERR_GUBUN') == ''){
					var param = {'ISSU_SEQNO': record.get('ISSU_SEQNO')}
					ssa720ukrvService.getErrMsg(param, function(provider, response){
						if(provider != null && !Ext.isEmpty(provider))	{
							centerNorth2Panel.setValue('TXT_ERR_MSG', provider['ERR_MESG']);
						}
					});
				}
			}else {
				centerNorth2Panel.setValue('TXT_ERR_MSG', '');
			}
		},
		fnWebCashColSet: function(records) {	//웹캐시 전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
			Ext.each(records, function(record) {
				//공급자 업체명, 대표자명, 필수제거(업태, 업종, 주소 - 2012.12.21)
				if(Ext.isEmpty(record.get('SELR_CORP_NM')) || Ext.isEmpty(record.get('SELR_CEO')) || Ext.isEmpty(record.get('SELR_CORP_NO'))
				   //2012.12.21 필수 제거
//				   || Ext.isEmpty(record.get('SELR_BUSS_CONS'))
//				   || Ext.isEmpty(record.get('SELR_BUSS_TYPE'))  || Ext.isEmpty(record.get('SELR_ADDR'))
				   ){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '1');
				}
				//공급 받는자 업체명, 대표자명, 주소
				else if(Ext.isEmpty(record.get('BUYR_GB')) || Ext.isEmpty(record.get('BUYR_CORP_NO'))  || record.get('BUYR_CORP_NO') == '--' || Ext.isEmpty(record.get('BUYR_CORP_NM')) || Ext.isEmpty(record.get('BUYR_CEO'))
				   //필수제거(주소 - 2012.12.21)
//				   || Ext.isEmpty(record.get('BUYR_ADDR'))			//2012.12.21 필수제거
				){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '3');
				}
				//공급 받는자 담당자명, 전화번호, 이메일주소 -- 필수 아니므로 제외
//				else if(Ext.isEmpty(record.get('BUYR_CHRG_NM1')) || Ext.isEmpty(record.get('BUYR_CHRG_TEL1')) || Ext.isEmpty(record.get('BUYR_CHRG_EMAIL1'))){
//					record.set('TRANSYN_NAME', 'Error');
//					record.set('ERR_GUBUN', '4');
//				}				
			});
		}
	});//End of Unilite.Main( {
};

</script>