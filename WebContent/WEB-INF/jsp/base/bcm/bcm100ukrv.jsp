<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bcm100ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B015" /><!-- 거래처구분    -->
	<t:ExtComboStore comboType="AU" comboCode="B016" /><!-- 법인/개인-->
	<t:ExtComboStore comboType="AU" comboCode="B012" /><!-- 국가코드-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /><!-- 기준화폐-->
	<t:ExtComboStore comboType="AU" comboCode="B017" /><!-- 원미만계산-->
	<t:ExtComboStore comboType="AU" comboCode="A022" /><!-- 계산서종류-->
	<t:ExtComboStore comboType="AU" comboCode="B038" /><!--결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="B034" /><!--결제조건-->
	<t:ExtComboStore comboType="AU" comboCode="B033" /><!--마감종류-->
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!--사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="B030" /><!--세액포함여부-->
	<t:ExtComboStore comboType="AU" comboCode="B051" /><!--세액계산법-->
	<t:ExtComboStore comboType="AU" comboCode="B055" /><!--거래처분류-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /><!--지역구분   -->
	<t:ExtComboStore comboType="AU" comboCode="B057" /><!--미수관리방법-->
	<t:ExtComboStore comboType="AU" comboCode="S010" /><!--주담당자  -->
	<t:ExtComboStore comboType="AU" comboCode="B062" /><!--카렌더타입  -->
	<t:ExtComboStore comboType="AU" comboCode="B086" /><!--카렌더타입 -->
	<t:ExtComboStore comboType="AU" comboCode="S051" /><!--전자문서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="WB01" /><!--운송방법-->
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!--전자문서주담당여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B109" /><!--유통채널	-->
	<t:ExtComboStore comboType="AU" comboCode="B232" /><!--신/구 주소구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B131" /><!--예/아니오 -->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >
var detailWin;


var BsaCodeInfo = {
	gsHiddenField: '${gsHiddenField}',
	gsCompanyNumChk: '${gsCompanyNumChk}'
}
function appMain() {

	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('bcm100ukrvModel', {
		// pkGen : user, system(default)
	    fields: [{name: 'CUSTOM_CODE' 		,text:'<t:message code="system.label.base.customcode" default="거래처코드"/>' 		,type:'string'	, isPk:true, pkGen:'user'},
				 {name: 'CUSTOM_TYPE' 		,text:'<t:message code="system.label.base.classfication" default="구분"/>' 			,type:'string'	,comboType:'AU',comboCode:'B015' ,allowBlank: false, defaultValue:'1'},
				 {name: 'CUSTOM_NAME' 		,text:'<t:message code="system.label.base.customname" default="거래처명"/>' 		,type:'string'	,allowBlank:false},
				 {name: 'CUSTOM_NAME1' 		,text:'<t:message code="system.label.base.customname1" default="거래처명1"/>' 		,type:'string'	},
				 {name: 'CUSTOM_NAME2' 		,text:'<t:message code="system.label.base.customname2" default="거래처명2"/>' 		,type:'string'	},
				 {name: 'CUSTOM_FULL_NAME' 	,text:'<t:message code="system.label.base.customnamefull" default="거래처명(전명)"/>' 	,type:'string'	,allowBlank:false},
				 {name: 'NATION_CODE' 		,text:'<t:message code="system.label.base.countrycode" default="국가코드"/>' 		,type:'string'	,comboType:'AU',comboCode:'B012'},
				 {name: 'COMPANY_NUM' 		,text:'<t:message code="system.label.base.businessnumber" default="사업자번호"/>' 	,type:'string'	},
				 {name: 'TOP_NUM' 			,text:'<t:message code="system.label.base.socialsecuritynumber" default="주민번호"/>' 		,type:'string'	},
				 {name: 'TOP_NAME' 			,text:'<t:message code="system.label.base.representative" default="대표자"/>' 		,type:'string'	},
				 {name: 'BUSINESS_TYPE' 	,text:'<t:message code="system.label.base.companytype" default="법인구분"/>' 		,type:'string'	,comboType:'AU',comboCode:'B016'},
				 {name: 'USE_YN' 			,text:'<t:message code="system.label.base.photoflag" default="사진유무"/>' 		,type:'string'	,comboType:'AU',comboCode:'B010', defaultValue:'Y'},
				 {name: 'COMP_TYPE' 		,text:'<t:message code="system.label.base.businessconditions" default="업태"/>' 			,type:'string'	},
				 {name: 'COMP_CLASS' 		,text:'<t:message code="system.label.base.businesstype" default="업종"/>' 			,type:'string'	},
				 {name: 'AGENT_TYPE' 		,text:'<t:message code="system.label.base.customclassfication" default="거래처분류"/>' 	,type:'string'	,comboType:'AU',comboCode:'B055' ,allowBlank: false, defaultValue:'1'},
				 {name: 'AGENT_TYPE2' 		,text:'<t:message code="system.label.base.customclassfication2" default="거래처분류2"/>' 	,type:'string'	},
				 {name: 'AGENT_TYPE3' 		,text:'<t:message code="system.label.base.customclassfication3" default="거래처분류3"/>' 	,type:'string'	},
				 {name: 'AREA_TYPE' 		,text:'<t:message code="system.label.base.area2" default="지역"/>' 			,type:'string'	,comboType:'AU',comboCode:'B056'},
				 {name: 'ZIP_CODE' 			,text:'<t:message code="system.label.base.zipcode" default="우편번호"/>' 		,type:'string'	},
				 {name: 'ADDR1' 			,text:'<t:message code="system.label.base.address1" default="주소1"/>' 		,type:'string'	},
				 {name: 'ADDR2' 			,text:'<t:message code="system.label.base.address2" default="주소2"/>' 		,type:'string'	},
				 {name: 'TELEPHON' 			,text:'<t:message code="system.label.base.phoneno1" default="연락처"/>' 		,type:'string'	},
				 {name: 'FAX_NUM' 			,text:'<t:message code="system.label.base.faxno" default="팩스번호"/>' 		,type:'string'	},
				 {name: 'HTTP_ADDR' 		,text:'<t:message code="system.label.base.homepage" default="홈페이지"/>' 		,type:'string'	},
				 {name: 'MAIL_ID' 			,text:'<t:message code="system.label.base.emailaddr" default="이메일주소"/>' 		,type:'string'	},
				 {name: 'WON_CALC_BAS' 		,text:'<t:message code="system.label.base.decimalcalculation" default="원미만계산"/>' 	,type:'string'	,comboType:'AU',comboCode:'B017'},
				 {name: 'START_DATE' 		,text:'<t:message code="system.label.base.transactionstartdate" default="거래시작일"/>' 	,type:'uniDate'	,allowBlank: false, defaultValue:UniDate.today()},
				 {name: 'STOP_DATE' 		,text:'<t:message code="system.label.base.transactionbreakdate" default="거래중단일"/>' 	,type:'uniDate'	},
				 {name: 'TO_ADDRESS' 		,text:'<t:message code="system.label.base.sendaddress" default="송신주소"/>' 		,type:'string'	},
				 {name: 'TAX_CALC_TYPE' 	,text:'<t:message code="system.label.base.taxcalculationmethod" default="세액계산법"/>' 	,type:'string'	,comboType:'AU',comboCode:'B051', defaultValue:'1'},
				 {name: 'RECEIPT_DAY' 		,text:'<t:message code="system.label.base.payperiod" default="결제기간"/>' 		,type:'string'	,comboType:'AU',comboCode:'B034'},
				 {name: 'MONEY_UNIT' 		,text:'<t:message code="system.label.base.basiscurrency" default="기준화폐"/>' 		,type:'string'	, comboType:'AU',comboCode:'B004', displayField: 'value'},
				 {name: 'TAX_TYPE' 			,text:'<t:message code="system.label.base.taxincludedflag" default="세액포함여부"/>' 	,type:'string'	, comboType:'AU',comboCode:'B030', defaultValue:'1'},
				 {name: 'BILL_TYPE' 		,text:'<t:message code="system.label.base.billtype" default="계산서유형"/>' 	,type:'string'	, comboType:'AU',comboCode:'A022'},
				 {name: 'SET_METH' 			,text:'<t:message code="system.label.base.payingmethod" default="결제방법"/>' 		,type:'string'	, comboType:'AU',comboCode:'B038'},
				 {name: 'VAT_RATE' 			,text:'<t:message code="system.label.base.taxrate" default="세율"/>' 			,type:'uniFC'	,defaultValue:0},
				 {name: 'TRANS_CLOSE_DAY' 	,text:'<t:message code="system.label.base.closingtype" default="마감종류"/>' 		,type:'string'	, comboType:'AU',comboCode:'B033'},
				 {name: 'COLLECT_DAY' 		,text:'<t:message code="system.label.base.collectiondate" default="수금일"/>'  		,type:'integer' ,defaultValue:1, minValue:1},
				 {name: 'CREDIT_YN' 		,text:'<t:message code="system.label.base.creditapplyyn" default="여신적용여부"/>' 	,type:'string'	, comboType:'AU',comboCode:'B010', defaultValue: 'N'},
				 {name: 'TOT_CREDIT_AMT' 	,text:'<t:message code="system.label.base.creditloanamount2" default="여신(담보)액"/>' 	,type:'uniPrice'	},
				 {name: 'CREDIT_AMT' 		,text:'<t:message code="system.label.base.creditloanamount" default="신용여신액"/>' 	,type:'uniPrice'	},
				 {name: 'CREDIT_YMD' 		,text:'<t:message code="system.label.base.creditloanduedate" default="신용여신만료일"/>' 	,type:'uniDate'	},
				 {name: 'COLLECT_CARE' 		,text:'<t:message code="system.label.base.armanagemethod" default="미수관리방법"/>' 	,type:'string'	, comboType:'AU',comboCode:'B057', defaultValue:'1'},
				 {name: 'BUSI_PRSN' 		,text:'<t:message code="system.label.base.maincharger" default="주담당자"/>' 		,type:'string'	, comboType:'AU',comboCode:'S010'},
				 {name: 'CAL_TYPE' 			,text:'<t:message code="system.label.base.calendartype" default="카렌더 타입"/>' 	,type:'string'	, comboType:'AU',comboCode:'B062'},
				 {name: 'REMARK' 			,text:'<t:message code="system.label.base.remarks" default="비고"/>' 			,type:'string'	},
				 {name: 'MANAGE_CUSTOM' 	,text:'<t:message code="system.label.base.summarycustom" default="집계거래처"/>' 	,type:'string'	},
				 {name: 'MCUSTOM_NAME' 		,text:'<t:message code="system.label.base.summarycustomname" default="집계거래처명"/>' 	,type:'string'	},
				 {name: 'COLLECTOR_CP' 		,text:'<t:message code="system.label.base.collectioncustomer" default="수금거래처"/>' 	,type:'string'	},
				 {name: 'COLLECTOR_CP_NAME' ,text:'<t:message code="system.label.base.collectioncustomername" default="수금거래처명"/>' 	,type:'string'	},
				 {name: 'BANK_CODE' 		,text:'<t:message code="system.label.base.financialinstitution" default="금융기관"/>' 		,type:'string'	},
				 {name: 'BANK_NAME' 		,text:'<t:message code="system.label.base.financialinstitutionname" default="금융기관명"/>' 	,type:'string'	},
				 {name: 'BANKBOOK_NUM' 		,text:'<t:message code="system.label.base.bankaccount" default="계좌번호"/>' 		,type:'string'	},
				 {name: 'BANKBOOK_NUM_EXPOS',text:'<t:message code="system.label.base.bankaccount" default="계좌번호"/>' 		,type:'string'	},
				 {name: 'BANKBOOK_NAME' 	,text:'<t:message code="system.label.base.accountholder" default="예금주"/>' 		,type:'string'	},
				 {name: 'CUST_CHK' 			,text:'<t:message code="system.label.base.changecustomerflag" default="거래처변경여부"/>' 	,type:'string'	},
				 {name: 'SSN_CHK' 			,text:'<t:message code="system.label.base.socialsecuritynumberchangeflag" default="주민번호변경여부"/>',type:'string'	},
				 {name: 'UPDATE_DB_USER' 	,text:'<t:message code="system.label.base.writer" default="작성자"/>' 		,type:'string'	},
				 {name: 'UPDATE_DB_TIME' 	,text:'<t:message code="system.label.base.writtentiem" default="작성시간"/>' 		,type:'uniDate'	},
				 {name: 'PURCHASE_BANK' 	,text:'<t:message code="system.label.base.purchasecardbank" default="구매카드은행"/>' 	,type:'string'	},
				 {name: 'PURBANKNAME' 		,text:'<t:message code="system.label.base.purchasecardbankname" default="구매카드은행명"/>' 	,type:'string'	},
				 {name: 'BILL_PRSN' 		,text:'<t:message code="system.label.base.electronicdocumentcharger" default="전자문서담당자"/>' 	,type:'string'	},
				 {name: 'HAND_PHON' 		,text:'<t:message code="system.label.base.cellphonenum" default="핸드폰번호"/>' 	,type:'string'	},
				 {name: 'BILL_MAIL_ID' 		,text:'<t:message code="system.label.base.electronicdocumentemail" default="전자문서Email"/>'	,type:'string'	},
				 {name: 'BILL_PRSN2' 		,text:'<t:message code="system.label.base.electronicdocumentcharger2" default="전자문서담당자2"/>' ,type:'string'	},
				 {name: 'HAND_PHON2' 		,text:'<t:message code="system.label.base.cellphonenum2" default="핸드폰번호2"/>' 	,type:'string'	},
				 {name: 'BILL_MAIL_ID2' 	,text:'<t:message code="system.label.base.electronicdocumentemail2" default="전자문서Email2"/>'	,type:'string'	},
				 {name: 'BILL_MEM_TYPE' 	,text:'<t:message code="system.label.base.electronicbill" default="전자세금계산서"/>' 		,type:'string'	},
				 {name: 'ADDR_TYPE' 		,text:'<t:message code="system.label.base.newoldaddressflag" default="신/구주소구분"/>' 		,type:'string'	, comboType:'AU',comboCode:'B232'},
				 {name: 'COMP_CODE' 		,text:'COMP_CODE' 		,type:'string'	, defaultValue: UserInfo.compCode},
				 {name: 'CHANNEL' 			,text:'CHANNEL' 		,type:'string'	},
				 {name: 'BILL_CUSTOM' 		,text:'<t:message code="system.label.base.billcustomcode" default="계산서거래처코드"/>'		,type:'string'	},
				 {name: 'BILL_CUSTOM_NAME' 	,text:'<t:message code="system.label.base.billcustom" default="계산서거래처"/>' 	  	,type:'string'	},
				 {name: 'CREDIT_OVER_YN' 	,text:'CREDIT_OVER_YN' 	,type:'string'	},
				 {name: 'Flag' 				,text:'Flag' 			,type:'string'	},
				 {name: 'DEPT_CODE' 		,text:'<t:message code="system.label.base.relateddepartments" default="관련부서"/>' 			,type:'string'	},
				 {name: 'DEPT_NAME' 		,text:'<t:message code="system.label.base.Related departmentsname" default="관련부서명"/>' 		,type:'string'	},
				 {name: 'BILL_PUBLISH_TYPE' ,text:'<t:message code="system.label.base.electronicbillissuetype" default="전자세금계산서 발행유형"/>' 		,type:'string'	, defaultValue:'1'}, //임시 2016.11.07
				 // 추가(극동)
                 {name: 'R_PAYMENT_YN'      ,text:'<t:message code="system.label.base.regularpaymentflag" default="정기결제여부"/>'    ,type:'string', allowBlank: false , comboType:'AU',comboCode:'B010', defaultValue: 'N' },
                 {name: 'DELIVERY_METH'     ,text:'<t:message code="system.label.base.transportmethod" default="운송방법"/>'        ,type:'string', comboType:'AU',comboCode:'WB01'  }
                 //

			]
	});

	//SUB 모델 (BCM130T - 계좌정보)
	Unilite.defineModel('bcm100ukrvModel2', {
		fields: [
			{name: 'COMPC_CODE'	 		,text: '<t:message code="system.label.base.companycode" default="법인코드"/>' 				,type: 'string'},
			{name: 'CUSTOM_CODE' 		,text: '<t:message code="system.label.base.customcode" default="거래처코드"/>' 			,type: 'string'},
			{name: 'SEQ'			 	,text: '<t:message code="system.label.base.seq" default="순번"/>' 				,type: 'int'},
            {name: 'BOOK_CODE'          ,text: '<t:message code="system.label.base.bankaccountcode" default="계좌코드"/>'              ,type: 'string'},
            {name: 'BOOK_NAME'          ,text: '<t:message code="system.label.base.bankaccountname" default="계좌명"/>'               ,type: 'string'},
			{name: 'BANK_CODE'	 		,text: '<t:message code="system.label.base.bankcode" default="은행코드"/>' 				,type: 'string'},
			{name: 'BANK_NAME'	 		,text: '<t:message code="system.label.base.bankname" default="은행명"/>' 				,type: 'string'},
			{name: 'BANKBOOK_NUM'	 	,text: '<t:message code="system.label.base.bankaccount" default="계좌번호"/>'			,type: 'string'},
			{name: 'BANKBOOK_NUM_EXPOS'	, text: '<t:message code="system.label.base.bankaccount" default="계좌번호"/>'		 		,type: 'string'		,defaultValue: '***************'},
			{name: 'BANKBOOK_NAME'	 	,text: '<t:message code="system.label.base.accountholder" default="예금주"/>' 				,type: 'string'},
			{name: 'MAIN_BOOK_YN'       ,text: '<t:message code="system.label.base.mainaccount" default="주지급계좌"/>'            ,type: 'string', comboType:'AU',comboCode:'B131'}
		]
	});

	//SUB 모델 (BCM120T - 전자문서정보)
    Unilite.defineModel('bcm100ukrvModel3', {
        fields: [
            {name: 'COMP_CODE'             ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'            ,type: 'string'},
            {name: 'CUSTOM_CODE'           ,text: '<t:message code="system.label.base.customcode" default="거래처코드"/>'           ,type: 'string'},
            {name: 'SEQ'                   ,text: '<t:message code="system.label.base.seq" default="순번"/>'               ,type: 'int'},
            {name: 'PRSN_NAME'             ,text: '<t:message code="system.label.base.chargername" default="담당자명"/>'            ,type: 'string'},
            {name: 'DEPT_NAME'             ,text: '<t:message code="system.label.base.departmentname" default="부서명"/>'             ,type: 'string'},
            {name: 'HAND_PHON'             ,text: '<t:message code="system.label.base.cellphonenum" default="핸드폰번호"/>'          ,type: 'string'},
            {name: 'TELEPHONE_NUM1'        ,text: '<t:message code="system.label.base.phonenum1" default="전화번호1"/>'           ,type: 'string'},
            {name: 'TELEPHONE_NUM2'        ,text: '<t:message code="system.label.base.phonenum2" default="전화번호2"/>'           ,type: 'string'},
            {name: 'FAX_NUM'               ,text: '<t:message code="system.label.base.faxno" default="팩스번호"/>'            ,type: 'string'},
            {name: 'MAIL_ID'               ,text: '<t:message code="system.label.base.emailaddr" default="이메일주소"/>'         ,type: 'string'	, allowBlank:false},
            {name: 'BILL_TYPE'             ,text: '<t:message code="system.label.base.electronicdocumentdivision" default="전자문서구분"/>'         ,type: 'string'	, comboType:'AU',comboCode:'S051'},
            {name: 'MAIN_BILL_YN'          ,text: '<t:message code="system.label.base.electronicdocumentchargerflag" default="전자문서담당자여부"/>'     ,type: 'string'	, allowBlank: false		, comboType:'AU',comboCode:'A020'},
            {name: 'REMARK'                ,text: '<t:message code="system.label.base.remarks" default="비고"/>'               ,type: 'string'}
        ]
    });


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm100ukrvService.selectList',
			update	: 'bcm100ukrvService.updateDetail',
			create	: 'bcm100ukrvService.insertDetail',
			destroy	: 'bcm100ukrvService.deleteDetail',
			syncAll	: 'bcm100ukrvService.saveAll'
		}
	});

	//SUB 프록시 (BCM130T - 계좌정보)
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm100ukrvService.getBankBookInfo',
			update	: 'bcm100ukrvService.updateList',
			create	: 'bcm100ukrvService.insertList',
			destroy	: 'bcm100ukrvService.deleteList',
			syncAll	: 'bcm100ukrvService.saveAll2'
		}
	});
	//SUB 프록시 (BCM120T - 전자문서정보)
    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'bcm100ukrvService.getSubInfo3',
            update  : 'bcm100ukrvService.updateList3',
            create  : 'bcm100ukrvService.insertList3',
            destroy : 'bcm100ukrvService.deleteList3',
            syncAll : 'bcm100ukrvService.saveAll3'
        }
    });
	/* Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('bcm100ukrvMasterStore',{
			model: 'bcm100ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : true			// prev | next 버튼 사용
            },

            proxy: directProxy,

            listeners: {
            	update:function( store, record, operation, modifiedFieldNames, eOpts )	{
//					detailForm.setActiveRecord(record);
				},
				metachange:function( store, meta, eOpts ){

				}

            }, // listeners

			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기
			loadStoreRecords : function()	{
				var param= Ext.getCmp('bcm100ukrvSearchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},

			// 수정/추가/삭제된 내용 DB에 적용 하기
			saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}

		});

	var directMasterStore2 = Unilite.createStore('bcm100ukrvMasterStore2',{
		model: 'bcm100ukrvModel2',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,		// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:true,			// 삭제 가능 여부
            useNavi : false			// prev | next 버튼 사용
        },

        proxy: directProxy2,

        listeners: {
        	update:function( store, record, operation, modifiedFieldNames, eOpts )	{
			},

			metachange:function( store, meta, eOpts ){
			}
        },

        loadStoreRecords : function(getCustomCode)	{
			var param= Ext.getCmp('bcm100ukrvSearchForm').getValues();
			param.CUSTOM_CODE = getCustomCode


			console.log( param );
			this.load({
				params : param
			});
		},

		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

	    _onStoreUpdate: function (store, eOpt) {
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save', true);
	    } // onStoreUpdate

	    ,_onStoreLoad: function ( store, records, successful, eOpts ) {
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save', false);
	    	}
	    },
		_onStoreDataChanged: function( store, eOpts )	{
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':false}});
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':true}});
       			}
       		}

       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save'], true);
       		}else {
       			this.setToolbarButtons(['sub_save'], false);
       		}
    	},

    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = masterGrid2.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}

	});

	var directMasterStore3 = Unilite.createStore('bcm100ukrvMasterStore3',{
        model: 'bcm100ukrvModel3',
        autoLoad: false,
        uniOpt : {
            isMaster: false,        // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable:true,         // 삭제 가능 여부
            useNavi : false         // prev | next 버튼 사용
        },

        proxy: directProxy3,

        listeners: {
            update:function( store, record, operation, modifiedFieldNames, eOpts )  {
            },

            metachange:function( store, meta, eOpts ){
            }
        },

        loadStoreRecords : function(getCustomCode)  {
            var param= Ext.getCmp('bcm100ukrvSearchForm').getValues();
            param.CUSTOM_CODE = getCustomCode


            console.log( param );
            this.load({
                params : param
            });
        },

        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);
            if(inValidRecs.length == 0 )    {
                this.syncAllDirect(config);
            }else {
                masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },

        _onStoreUpdate: function (store, eOpt) {
            console.log("Store data updated save btn enabled !");
            this.setToolbarButtons('sub_save3', true);
        } // onStoreUpdate

        ,_onStoreLoad: function ( store, records, successful, eOpts ) {
            console.log("onStoreLoad");
            if (records) {
                this.setToolbarButtons('sub_save3', false);
            }
        },
        _onStoreDataChanged: function( store, eOpts )   {
            console.log("_onStoreDataChanged store.count() : ", store.count());
            if(store.count() == 0)  {
                this.setToolbarButtons(['sub_delete3'], false);
                Ext.apply(this.uniOpt.state, {'btn':{'sub_delete3':false}});
            }else {
                if(this.uniOpt.deletable)   {
                    this.setToolbarButtons(['sub_delete3'], true);
                    Ext.apply(this.uniOpt.state, {'btn':{'sub_delete3':true}});
                }
            }

            if(store.isDirty()) {
                this.setToolbarButtons(['sub_save3'], true);
            }else {
                this.setToolbarButtons(['sub_save3'], false);
            }
        },

        setToolbarButtons: function( btnName, state)    {
            var toolbar = masterGrid3.getDockedItems('toolbar[dock="top"]');
            var obj = toolbar[0].getComponent(btnName);
            if(obj) {
                (state) ? obj.enable():obj.disable();
            }
        }

    });
	/**
	 * 전자세금계산서 모델 정의
	 */
	Unilite.defineModel('bcm120ukrvModel', {
	    extend: 'Ext.data.Model',
	    fields: [{name: 'COMP_CODE' 		,text:'<t:message code="system.label.base.companycode" default="법인코드"/>' 				,type:'string'	, allowBlank: false	},
				 {name: 'CUSTOM_CODE' 		,text:'<t:message code="system.label.base.customcode" default="거래처코드"/>' 		,type:'string'	, allowBlank: false	},
				 {name: 'SEQ' 				,text:'<t:message code="system.label.base.seq" default="순번"/>' 				,type:'integer'	, allowBlank: false	},
				 {name: 'PRSN_NAME' 		,text:'<t:message code="system.label.base.chargername" default="담당자명"/>' 			,type:'string'	, allowBlank: false	},
				 {name: 'DEPT_NAME' 		,text:'<t:message code="system.label.base.departmentname" default="부서명"/>' 			,type:'string'	},
				 {name: 'HAND_PHON' 		,text:'<t:message code="system.label.base.cellphonenum" default="핸드폰번호"/>' 		,type:'string'	},
				 {name: 'TELEPHONE_NUM1' 	,text:'<t:message code="system.label.base.phonenum1" default="전화번호1"/>' 			,type:'string'	, allowBlank: false	},
				 {name: 'TELEPHONE_NUM2' 	,text:'<t:message code="system.label.base.phonenum2" default="전화번호2"/>' 			,type:'string'	},
				 {name: 'FAX_NUM' 			,text:'<t:message code="system.label.base.faxno" default="팩스번호"/>' 			,type:'string'	},
				 {name: 'MAIL_ID' 			,text:'<t:message code="system.label.base.emailaddr" default="이메일주소"/>' 		,type:'string'	, allowBlank: false	},
				 {name: 'BILL_TYPE' 		,text:'<t:message code="system.label.base.electronicdocumentdivision" default="전자문서구분"/>'		,type:'string'	, comboType:'AU',comboCode:'S051'},
				 {name: 'MAIN_BILL_YN' 		,text:'<t:message code="system.label.base.electronicdocumentmainyn" default="전자문서주담당여부"/>'  ,type:'string'	, comboType:'AU',comboCode:'A020'	,allowBlank: false},
				 {name: 'REMARK' 			,text:'<t:message code="system.label.base.remarks" default="비고"/>' 				,type:'string'	}
			]
	});




	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('bcm100ukrvSearchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		defaults: {
			autoScroll:true
	  	},
		items:[{
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	    	items:[{
				fieldLabel: '<t:message code="system.label.base.customcode" default="거래처코드"/>',
				name: 'CUSTOM_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_CODE', newValue);
					}
				}
			},{
			    fieldLabel: '<t:message code="system.label.base.customname" default="거래처명"/>',
				name: 'CUSTOM_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
				name: 'CUSTOM_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B015',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_TYPE', newValue);
					}
				}
			}]
		}, {
		 	title:'<t:message code="system.label.base.additionalinfo" default="추가정보"/>',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
		 	items: [{
				fieldLabel: '<t:message code="system.label.base.area2" default="지역"/>',
				name: 'AREA_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B056'
			},{
				fieldLabel: '<t:message code="system.label.base.mainsalescharge" default="주영업담당"/>',
				name: 'BUSI_PRSN' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'S010'
			},{
				fieldLabel: '<t:message code="system.label.base.clienttype" default="고객분류"/>'    ,
				name: 'AGENT_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B055'
			},{
				fieldLabel: '<t:message code="system.label.base.businesstype2" default="법인/개인"/>',
				name: 'BUSINESS_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B016'
			},{
				fieldLabel: '<t:message code="system.label.base.photoflag" default="사진유무"/>'     ,
				name: 'USE_YN',
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B010'
			},{
				fieldLabel: '<t:message code="system.label.base.representativename" default="대표자명"/>'     ,
				name: 'TOP_NAME'
			},{
				fieldLabel: '<t:message code="system.label.base.businessnumber" default="사업자번호"/>',
				name: 'COMPANY_NUM'
		    }/*,{
				fieldLabel: '사업자번호체크' ,
				name: 'CHK_COMPANY_NUM' ,
				xtype: 'checkboxfield'
	    	}*/]
		}]
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.base.customcode" default="거래처코드"/>',
			name: 'CUSTOM_CODE',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_CODE', newValue);
				}
			}
		},{
		    fieldLabel: '<t:message code="system.label.base.customname" default="거래처명"/>',
			name: 'CUSTOM_NAME',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_NAME', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
			name: 'CUSTOM_TYPE' ,
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'B015',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_TYPE', newValue);
				}
			}
		}]
    });

    /**
     * Master Grid 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('bcm100ukrvGrid', {
    	region:'center',
    	store: directMasterStore,
        layout : 'fit',
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: true,
            enterKeyCreateRow	: true
        },
        border:true,
//        tbar: [
//	            {
//	        	text:'상세보기',
//	        	handler: function() {
//	        		var record = masterGrid.getSelectedRecord();
//		        	if(record) {
//		        		openDetailWindow(record);
//		        	}
//	        	}
//        }],
		columns:[{dataIndex:'CUSTOM_CODE'		,width:80, hideable:false, isLink:true},
				 {dataIndex:'CUSTOM_TYPE'		,width:80, hideable:false},
				 {dataIndex:'CUSTOM_NAME'		,width:170,hideable:false},
				 {dataIndex:'CUSTOM_NAME1'		,width:150	, hidden:true},
				 {dataIndex:'CUSTOM_NAME2'		,width:150	, hidden:true},
				 {dataIndex:'CUSTOM_FULL_NAME'	,width:170},
				 {dataIndex:'NATION_CODE'		,width:130	, hidden:true},
				 {dataIndex:'COMPANY_NUM'		,width:100},
				 {dataIndex:'TOP_NUM'			,width:100	, hidden:true},
				 {dataIndex:'TOP_NAME'			,width:100},
				 {dataIndex:'BUSINESS_TYPE'		,width:110	, hidden:true},
				 {dataIndex:'USE_YN'			,width:60	, hidden:true},
				 {dataIndex:'COMP_TYPE'			,width:140},
				 {dataIndex:'COMP_CLASS'		,width:140},
				 {dataIndex:'AGENT_TYPE'		,width:120},
				 {dataIndex:'AGENT_TYPE2'		,width:80	, hidden:true},
				 {dataIndex:'AGENT_TYPE3'		,width:80	, hidden:true},
				 {dataIndex:'AREA_TYPE'			,width:80	, hidden:true},
				 {dataIndex:'ZIP_CODE'			, hidden : true
					,'editor' : Unilite.popup('ZIP_G',{
			  					autoPopup: true,
								listeners: {
						                'onSelected': {
						                    fn: function(records, type  ){
						                    	var me = this;
						                    	var grdRecord = Ext.getCmp('bcm100ukrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('ADDR1',records[0]['ZIP_NAME']);
						                    	grdRecord.set('ADDR2',records[0]['ADDR2']);
						                    },
						                    scope: this
						                },
						                'onClear' : function(type){
						                		var me = this;
						                    	var grdRecord = Ext.getCmp('bcm100ukrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('ADDR1','');
						                    	grdRecord.set('ADDR2','');
						                }
						            }
								})},
				 {dataIndex:'ADDR1'				,width:200	, hidden:true},
				 {dataIndex:'ADDR2'				,width:200	, hidden:true},
				 {dataIndex:'TELEPHON'			,width:80},
				 // 추가(극동)
                 {dataIndex:'R_PAYMENT_YN'      ,width:100},
                 {dataIndex:'DELIVERY_METH'     ,width:80},
                 //
				 {dataIndex:'FAX_NUM'			,width:80	, hidden:true},
				 {dataIndex:'HTTP_ADDR'			,width:140	, hidden:true},
				 {dataIndex:'MAIL_ID'			,width:100	, hidden:true},
				 {dataIndex:'WON_CALC_BAS'		,width:80	, hidden:true},
				 {dataIndex:'START_DATE'		,width:110	, hidden:true},
				 {dataIndex:'STOP_DATE'			,width:110	, hidden:true},
				 {dataIndex:'TO_ADDRESS'		,width:140	, hidden:true},
				 {dataIndex:'TAX_CALC_TYPE'		,width:90	, hidden:true},
				 {dataIndex:'TRANS_CLOSE_DAY'	,width:120	, hidden:true},
				 {dataIndex:'RECEIPT_DAY'		,width:120	, hidden:true},
				 {dataIndex:'MONEY_UNIT'		,width:130	, hidden:true},
				 {dataIndex:'TAX_TYPE'			,width:90	, hidden:true},
				 {dataIndex:'BILL_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'SET_METH'			,width:90	, hidden:true},
				 {dataIndex:'VAT_RATE'			,width:60	, hidden:true},
				 {dataIndex:'TRANS_CLOSE_DAY'	,width:90	, hidden:true},
				 {dataIndex:'COLLECT_DAY'		,width:90	, hidden:true, maxValue: 31, minValue: 1},
				 {dataIndex:'CREDIT_YN'			,width:80	, hidden:true},
				 {dataIndex:'TOT_CREDIT_AMT'	,width:90	, hidden:true},
				 {dataIndex:'CREDIT_AMT'		,width:80	, hidden:true},
				 {dataIndex:'CREDIT_YMD'		,width:110	, hidden:true},
				 {dataIndex:'COLLECT_CARE'		,width:120	, hidden:true},
				 {dataIndex:'BUSI_PRSN'			,width:90	, hidden:true},
				 {dataIndex:'CAL_TYPE'			,width:110	, hidden:true},
				 {dataIndex:'REMARK'			,width:250	, flex:1},
				 {dataIndex:'MANAGE_CUSTOM'		,width:140	, hidden:true},
				 {dataIndex:'MCUSTOM_NAME'		,width:140	, hidden:true
				  ,editor : Unilite.popup('CUST_G',{
				    				textFieldName:'MCUSTOM_NAME',
			  						autoPopup: true,
				    				listeners: {
						                'onSelected':  function(records, type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
						                    	grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
						                }
						                ,'onClear':  function( type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('MCUSTOM_NAME','');
						                    	grdRecord.set('MANAGE_CUSTOM','');
						                }
						            } // listeners
								})
				},
				 {dataIndex:'COLLECTOR_CP'	,width:140	, hidden:true},
				 {dataIndex:'COLLECTOR_CP_NAME'	,width:140	, hidden:true
					,'editor' : Unilite.popup('CUST_G',	{
				    					textFieldName:'COLLECTOR_CP_NAME',
			  							autoPopup: true,
					    				listeners: {
							                'onSelected':  function(records, type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
							                   		grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
							                },
							                'onClear':  function( type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('COLLECTOR_CP_NAME','');
							                    	grdRecord.set('COLLECTOR_CP','');
							                }
							            } // listeners
								})
				},
				 {dataIndex:'BANK_NAME',  width: 100   	, hidden: true
						,'editor' : Unilite.popup('BANK_G',	{
										textFieldName:'BANK_NAME',
			  							autoPopup: true,
				    					listeners: {
							                'onSelected': function(records, type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
							                    	grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							                },
							                'onClear':  function( type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BANK_NAME','');
							                    	grdRecord.set('BANK_CODE','');
							                }
						            	} // listeners
								})
					},

				 {dataIndex:'BANKBOOK_NUM'		,width:100	, hidden:true},
				 {dataIndex:'BANKBOOK_NUM_EXPOS',width: 120 	},
				 {dataIndex:'BANKBOOK_NAME'		,width:100	, hidden:true},
				 {dataIndex:'CUST_CHK'			,width:90	, hidden:true},
				 {dataIndex:'SSN_CHK'			,width:90	, hidden:true},
				 {dataIndex:'UPDATE_DB_USER'	,width:90	, hidden:true},
				 {dataIndex:'UPDATE_DB_TIME'	,width:90	, hidden:true},
				 {dataIndex:'PURCHASE_BANK'		,width:150	, hidden:true},
				 {dataIndex:'PURBANKNAME'		,width:150	, hidden:true},
				 {dataIndex:'BILL_PRSN'			,width:110	, hidden:true},
				 {dataIndex:'HAND_PHON'			,width:110	, hidden:true},
				 {dataIndex:'BILL_MAIL_ID'		,width:140	, hidden:true},
				 {dataIndex:'ADDR_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'CHANNEL'			,width:80	, hidden:true},
				 {dataIndex:'BILL_CUSTOM'	    ,width:120	, hidden:true},
				 {dataIndex:'BILL_PUBLISH_TYPE'	,width:120	, hidden:true}, //임시
				 {dataIndex:'BILL_CUSTOM_NAME'	,width:120	, hidden:true
					,'editor' : Unilite.popup('CUST_G',{
										textFieldName:'BILL_CUSTOM_NAME',
			  							autoPopup: true,
										listeners: {
							                'onSelected':  function(records, type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
							                    	grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							                },
							                'onClear':  function( type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BILL_CUSTOM_NAME','');
							                    	grdRecord.set('BILL_CUSTOM','');
							                }
						            	} //listeners
								})
				 }


          ]
         ,
         listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.field == "BANKBOOK_NUM_EXPOS")	{
					//e.grid.openCryptPopup( e.record );
					return false;
				}
			},
          	selectionchangerecord:function(selected)	{
          		detailForm.setActiveRecord(selected)
				directMasterStore2.loadStoreRecords(selected.get('CUSTOM_CODE'));
                directMasterStore3.loadStoreRecords(selected.get('CUSTOM_CODE'));
          	},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
 				if(colName =="BANKBOOK_NUM_EXPOS") {
					grid.ownerGrid.openCryptBankAccntPopup(record);
					//팝업에서 직접입력(암호화팝업)으로 변경
//					grid.ownerGrid.openCryptBankAccntPopup(record);
				}
         		if(!record.phantom) {
	      			switch(colName)	{
					case 'CUSTOM_CODE' :
							masterGrid.hide();
							break;
					default:
							break;
	      			}
          		}
          	},
			hide:function()	{
				detailForm.show();
			},
			edit: function(editor, e) {
				var record = masterGrid.getSelectedRecord();
                detailForm.setActiveRecord(record);
            }
          },
		openCryptBankAccntPopup:function(record)	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANKBOOK_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
			}
		}
    });

    var masterGrid2 = Unilite.createGrid('bcm100ukrvGrid2', {
    	store	: directMasterStore2,
    	border	: true,
    	height	: 150,
    	width	: 912,
    	padding	: '0 0 5 0',
    	sortableColumns : false,

    	excelTitle: '<t:message code="system.label.base.accountinformation" default="계좌정보"/>',
    	uniOpt:{
			 expandLastColumn	: true,
			 useRowNumberer		: true,
			 useMultipleSorting	: false,
			 enterKeyCreateRow	: false						//마스터 그리드 추가기능 삭제
    	},
    	dockedItems	: [{
	        xtype	: 'toolbar',
	        dock	: 'top',
	        items	: [{
                xtype	: 'uniBaseButton',
		 		text 	: '<t:message code="system.label.base.inquiry" default="조회"/>',
		 		tooltip	: '<t:message code="system.label.base.inquiry" default="조회"/>',
		 		iconCls	: 'icon-query',
		 		width	: 26,
		 		height	: 26,
		 		itemId	: 'sub_query',
				handler: function() {
					//if( me._needSave()) {
					var toolbar = masterGrid2.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					var record = masterGrid.getSelectedRecord();
					if(needSave) {
						Ext.Msg.show({
						     title:'<t:message code="system.label.base.confirm" default="확인"/>',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  		directMasterStore2.saveStore();
				                    });
				                    saveTask.delay(500);
						     	} else if(res === 'no') {
						     		directMasterStore2.loadStoreRecords(record.get('CUSTOM_CODE'));
						     	}
						     }
						});
					} else {
						directMasterStore2.loadStoreRecords(record.get('CUSTOM_CODE'));
					}
				}
			},{
                xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.reset" default="신규"/>',
				tooltip : '<t:message code="system.label.base.reset2" default="초기화"/>',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_reset',
				handler	: function() {
					var toolbar = masterGrid2.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
						     title:'<t:message code="system.label.base.confirm" default="확인"/>',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
					                  	directMasterStore2.saveStore();
					                });
					                saveTask.delay(500);
						     	} else if(res === 'no') {
						     		masterGrid2.reset();
						     		directMasterStore2.clearData();
						     		directMasterStore2.setToolbarButtons('sub_save', false);
						     		directMasterStore2.setToolbarButtons('sub_delete', false);
						     	}
						     }
						});
					} else {
						masterGrid2.reset();
						directMasterStore2.clearData();
						directMasterStore2.setToolbarButtons('sub_save', false);
						directMasterStore2.setToolbarButtons('sub_delete', false);
					}
				}
			},{
                xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.add" default="추가"/>',
				tooltip	: '<t:message code="system.label.base.add" default="추가"/>',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_newData',
				handler	: function() {
					var record = masterGrid.getSelectedRecord();

					var compCode	= UserInfo.compCode;
					var customCode	= record.get('CUSTOM_CODE');
					var bankBookNumExpos  = '';
					var mainBookYn  = 'N';


	            	var r = {
	            	 	COMP_CODE:			compCode,
	            	 	CUSTOM_CODE:		customCode,
	            	 	MAIN_BOOK_YN:       mainBookYn,
	            	 	BANKBOOK_NUM_EXPOS : bankBookNumExpos
			        };
					masterGrid2.createRow(r);
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.delete" default="삭제"/>',
				tooltip	: '<t:message code="system.label.base.delete" default="삭제"/>',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_delete',
				handler	: function() {
					var selRow = masterGrid2.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid2.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid2.deleteSelectedRow();
					}
				}
			},{
                xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.save" default="저장 "/>',
				tooltip	: '<t:message code="system.label.base.save" default="저장 "/>',
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_save',
				handler : function() {
					var inValidRecs = directMasterStore2.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
	                  		directMasterStore2.saveStore();
						});
						saveTask.delay(500);
					} else {
						masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
                }
			}]
	    }],

		columns:  [
            { dataIndex: 'BOOK_CODE'            ,       width: 120},
            { dataIndex: 'BOOK_NAME'            ,       width: 100},

        	{ dataIndex: 'BANK_CODE'	 		,  		width: 120,
				editor: Unilite.popup('BANK_G',{
 	 				DBtextFieldName: 'BANK_CODE',
 	 				autoPopup: true,
					listeners:{ 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
							grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
	                    },
	                    scope: this
              	   },
	                  'onClear' : function(type)	{
	                  		var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
	                  }
					}
				})
			 },{ dataIndex: 'BANK_NAME'	 		,  		width: 160,
	  			editor: Unilite.popup('BANK_G',{
 	 				autoPopup: true,
	  				listeners:{ 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
							grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
	                    },
	                    scope: this
              	   	},
	                  'onClear' : function(type)	{
	                  		var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
	                  }
					}
				})
	  		},
			{ dataIndex: 'BANKBOOK_NUM_EXPOS'	, width: 120 	},
			{ dataIndex: 'BANKBOOK_NUM'	 		, width: 160,	hidden: true},
	  		{ dataIndex: 'BANKBOOK_NAME'	 	,  		width: 120},
	  		{ dataIndex: 'MAIN_BOOK_YN'       ,       width: 100}

		],

		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['BOOK_CODE'])){
    				if(e.record.phantom){
    				    return true;
    				}else{
    				    return false;
    				}
				}else if(e.field == "BANKBOOK_NUM_EXPOS")	{
					//e.grid.openCryptPopup( e.record );
					return false;
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANKBOOK_NUM_EXPOS") {
					grid.ownerGrid.openCryptBankAccntPopup(record);
					//팝업에서 직접입력(암호화팝업)으로 변경
//					grid.ownerGrid.openCryptBankAccntPopup(record);
				}
			}
		},
//		openCryptBankAccntPopup:function( record )	{
//			if(record)	{
//				var params = {'BANK_ACCNT_CODE': record.get('BANKBOOK_NUM')};
//				Unilite.popupCryptBankAccnt('grid', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
//			}
//
//		},
		openCryptBankAccntPopup:function(record)	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANKBOOK_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
			}
		}
	});

    var masterGrid3 = Unilite.createGrid('bcm100ukrvGrid3', {
        store   : directMasterStore3,
        border  : true,
        height  : 150,
        width   : 912,
    	padding	: '0 0 5 0',
        sortableColumns : false,

        excelTitle: '<t:message code="system.label.base.electronicdocumentinfo" default="전자문서정보"/>',
        uniOpt:{
             expandLastColumn   : true,
             useRowNumberer     : true,
             useMultipleSorting : false,
	         enterKeyCreateRow  : false                      //마스터 그리드 추가기능 삭제
        },
        dockedItems : [{
            xtype   : 'toolbar',
            dock    : 'top',
            items   : [{
                xtype   : 'uniBaseButton',
                text    : '<t:message code="system.label.base.inquiry" default="조회"/>',
                tooltip : '<t:message code="system.label.base.inquiry" default="조회"/>',
                iconCls : 'icon-query',
                width   : 26,
                height  : 26,
                itemId  : 'sub_query3',
                handler: function() {
                    //if( me._needSave()) {
                    var toolbar = masterGrid3.getDockedItems('toolbar[dock="top"]');
                    var needSave = !toolbar[0].getComponent('sub_save3').isDisabled();
                    var record = masterGrid.getSelectedRecord();
                    if(needSave) {
                        Ext.Msg.show({
                             title:'<t:message code="system.label.base.confirm" default="확인"/>',
                             msg: Msg.sMB017 + "\n" + Msg.sMB061,
                             buttons: Ext.Msg.YESNOCANCEL,
                             icon: Ext.Msg.QUESTION,
                             fn: function(res) {
                                //console.log(res);
                                if (res === 'yes' ) {
                                    var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
                                        directMasterStore3.saveStore();
                                    });
                                    saveTask.delay(500);
                                } else if(res === 'no') {
                                    directMasterStore3.loadStoreRecords(record.get('CUSTOM_CODE'));
                                }
                             }
                        });
                    } else {
                        directMasterStore3.loadStoreRecords(record.get('CUSTOM_CODE'));
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '<t:message code="system.label.base.reset" default="신규"/>',
                tooltip : '<t:message code="system.label.base.reset2" default="초기화"/>',
                iconCls : 'icon-reset',
                width   : 26,
                height  : 26,
                itemId  : 'sub_reset3',
                handler : function() {
                    var toolbar = masterGrid3.getDockedItems('toolbar[dock="top"]');
                    var needSave = !toolbar[0].getComponent('sub_save3').isDisabled();
                    if(needSave) {
                        Ext.Msg.show({
                             title:'<t:message code="system.label.base.confirm" default="확인"/>',
                             msg: Msg.sMB017 + "\n" + Msg.sMB061,
                             buttons: Ext.Msg.YESNOCANCEL,
                             icon: Ext.Msg.QUESTION,
                             fn: function(res) {
                                console.log(res);
                                if (res === 'yes' ) {
                                    var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
                                        directMasterStore3.saveStore();
                                    });
                                    saveTask.delay(500);
                                } else if(res === 'no') {
                                    masterGrid3.reset();
                                    directMasterStore3.clearData();
                                    directMasterStore3.setToolbarButtons('sub_save3', false);
                                    directMasterStore3.setToolbarButtons('sub_delete3', false);
                                }
                             }
                        });
                    } else {
                        masterGrid3.reset();
                        directMasterStore3.clearData();
                        directMasterStore3.setToolbarButtons('sub_save3', false);
                        directMasterStore3.setToolbarButtons('sub_delete3', false);
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '<t:message code="system.label.base.add" default="추가"/>',
                tooltip : '<t:message code="system.label.base.add" default="추가"/>',
                iconCls : 'icon-new',
                width   : 26,
                height  : 26,
                itemId  : 'sub_newData3',
                handler : function() {
                    var record = masterGrid.getSelectedRecord();

                    var compCode    = UserInfo.compCode;
                    var customCode  = record.get('CUSTOM_CODE');
                    var seq = directMasterStore3.max('SEQ');
                    if(!seq){
                        seq = 1;
                    }else{
                        seq += 1;
                    }
                    var r = {
                        COMP_CODE:          compCode,
                        CUSTOM_CODE:        customCode,
                        SEQ:                seq,
                        BILL_TYPE:			"1",
                        MAIN_BILL_YN:		"Y"
                    };
                    masterGrid3.createRow(r);
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '<t:message code="system.label.base.delete" default="삭제"/>',
                tooltip : '<t:message code="system.label.base.delete" default="삭제"/>',
                iconCls : 'icon-delete',
                disabled: true,
                width   : 26,
                height  : 26,
                itemId  : 'sub_delete3',
                handler : function() {
                    var selRow = masterGrid3.getSelectedRecord();
                    if(selRow.phantom === true) {
                        masterGrid3.deleteSelectedRow();
                    }else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
                        masterGrid3.deleteSelectedRow();
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '<t:message code="system.label.base.save" default="저장 "/>',
                tooltip : '<t:message code="system.label.base.save" default="저장 "/>',
                iconCls : 'icon-save',
                disabled: true,
                width   : 26,
                height  : 26,
                itemId  : 'sub_save3',
                handler : function() {
                    var inValidRecs = directMasterStore3.getInvalidRecords();
                    if(inValidRecs.length == 0 )    {
                        var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
                            directMasterStore3.saveStore();
                        });
                        saveTask.delay(500);
                    } else {
                        masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
                    }
                }
            }]
        }],

        columns:  [
            { dataIndex: 'COMP_CODE'              ,       width: 80,hidden:true},
            { dataIndex: 'CUSTOM_CODE'            ,       width: 80,hidden:true},
            { dataIndex: 'SEQ'                    ,       width: 60},
            { dataIndex: 'PRSN_NAME'              ,       width: 100},
            { dataIndex: 'DEPT_NAME'              ,       width: 100},
            { dataIndex: 'HAND_PHON'              ,       width: 120},
            { dataIndex: 'TELEPHONE_NUM1'         ,       width: 120},
            { dataIndex: 'TELEPHONE_NUM2'         ,       width: 120},
            { dataIndex: 'FAX_NUM'                ,       width: 100},
            { dataIndex: 'MAIL_ID'                ,       width: 140},
            { dataIndex: 'BILL_TYPE'              ,       width: 120},
            { dataIndex: 'MAIN_BILL_YN'           ,       width: 150},
            { dataIndex: 'REMARK'                 ,       width: 100}
        ],

        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
            }
        }
    });
    /**
     * 상세 조회(Detail Form Panel)
     * @type
     */
    var detailForm = Unilite.createForm('detailForm', {
//      region:'south',
//    	weight:-100,
//    	height:400,
//    	split:true,
    	hidden: true,
    	masterGrid: masterGrid,
        autoScroll:true,
        border: false,
        padding: '0 0 0 1',
        uniOpt:{
        	store : directMasterStore
        },
	    //for Form
	    layout: {
	    	type: 'uniTable',
	    	columns: 1,
	    	tableAttrs:{cellpadding:5},
	    	tdAttrs: {valign:'top'}
	    },
	    defaultType: 'fieldset',
	    masterGrid: masterGrid,
	    defineEvent: function(){
	    	var me = this;
	        me.getField('CUSTOM_NAME').on ('blur', function( field, blurEvent, eOpts )	{
				//var frm = Ext.getCmp('detailForm');
				if(me.getValue('CUSTOM_FULL_NAME') == "")
					me.setValue('CUSTOM_FULL_NAME',this.getValue());
			} );
		},
	    items : [{
	    	title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
        	defaultType: 'uniTextfield',
        	flex : 1,
    		padding	: '0 0 5 0',
        	layout: {
	            type: 'uniTable',
	            tableAttrs: { style: { width: '100%' } },
	            columns: 3
			},

			items :[{
				fieldLabel: '<t:message code="system.label.base.customcode" default="거래처코드"/>',
				name: 'CUSTOM_CODE' ,
				allowBlank: false,
				readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.base.businesstype2" default="법인/개인"/>',
				name: 'BUSINESS_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B016'
			},{
				fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
				name: 'CUSTOM_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B015' ,
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.base.customabbreviationname" default="거래처(약명)"/>',
				name: 'CUSTOM_NAME'  ,
				allowBlank: false,
				listenersX:{blur : function(){
					var frm = Ext.getCmp('detailForm');
					if(frm.getValue('CUSTOM_FULL_NAME') == "")
					frm.setValue('CUSTOM_FULL_NAME',this.getValue());
				}}
			},{
				fieldLabel: '<t:message code="system.label.base.businessnumber" default="사업자번호"/>',
				name: 'COMPANY_NUM'
			},{
				fieldLabel: '<t:message code="system.label.base.businessconditions" default="업태"/>',
				name: 'COMP_TYPE'
			},{
				fieldLabel: '<t:message code="system.label.base.customabbreviationname1" default="거래처(약명1)"/>',
				name: 'CUSTOM_NAME1'
			},{
				fieldLabel: '<t:message code="system.label.base.representativename" default="대표자명"/>',
				name: 'TOP_NAME'
			},{
				fieldLabel: '<t:message code="system.label.base.businesstype" default="업종"/>',
				name: 'COMP_CLASS'
			},{
				fieldLabel: '<t:message code="system.label.base.customabbreviationname2" default="거래처(약명2)"/>',
				name: 'CUSTOM_NAME2'
			},
			{
				fieldLabel:'<t:message code="system.label.base.residentno" default="주민등록번호"/>',
				name :'TOP_NUM_EXPOS',
				xtype: 'uniTextfield',
				readOnly:true,
				focusable:false,
				listeners:{
					afterrender:function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{
					detailForm.openCryptRepreNoPopup();
				}
			},{
				fieldLabel: '<t:message code="system.label.base.socialsecuritynumber" default="주민번호"/>',
				name: 'TOP_NUM',
				hidden: true
			},{
				fieldLabel: '<t:message code="system.label.base.clienttype" default="고객분류"/>',
				name: 'AGENT_TYPE',
				xtype : 'uniCombobox',
				allowBlank: false,
				comboType:'AU',
				comboCode:'B055'
			},{
				fieldLabel: '<t:message code="system.label.base.customnamefull" default="거래처명(전명)"/>',
				name: 'CUSTOM_FULL_NAME',
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.base.area2" default="지역"/>',
				name: 'AREA_TYPE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B056' ,
				colspan:2
			},{
				fieldLabel: '<t:message code="system.label.base.transactionstartdate" default="거래시작일"/>',
				name: 'START_DATE' ,
				xtype : 'uniDatefield',
				allowBlank:false
			},{
				fieldLabel: '<t:message code="system.label.base.transactionbreakdate" default="거래중단일"/>',
				name: 'STOP_DATE',
				xtype : 'uniDatefield'
			},{
				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',
				name: 'USE_YN',
				xtype: 'uniRadiogroup',
				width: 230,
				comboType:'AU',
				comboCode:'B010',
				value:'Y' ,
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.base.businessnumberchangeflag" default="사업자번호변경여부"/>',
				name: 'CUST_CHK',
				hidden:true
			},{
				fieldLabel: '<t:message code="system.label.base.socialsecuritynumberchangeflag" default="주민번호변경여부"/>',
				name: 'SSN_CHK', hidden:true
			}]
	    },{
	    	title: '<t:message code="system.label.base.businessinformation" default="업무정보"/>',
        	//,collapsible: true
        	defaultType: 'uniTextfield',
        	flex : 1,
  		  	padding	: '0 0 5 0',
			layout: {
	            type: 'uniTable',
	            tableAttrs: { style: { width: '100%' } },
	            columns: 3
			},

			items :[{
				fieldLabel: '<t:message code="system.label.base.countrycode" default="국가코드"/>',
				name: 'NATION_CODE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B012'
			},{
				fieldLabel: '<t:message code="system.label.base.billtype1" default="계산서종류"/>',
				name: 'BILL_TYPE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'A022'
			},{
				fieldLabel: '<t:message code="system.label.base.creditloanamount2" default="여신(담보)액"/>',
				name: 'TOT_CREDIT_AMT',
				xtype:'uniNumberfield'
			},{
				fieldLabel: '<t:message code="system.label.base.basiscurrency" default="기준화폐"/>',
				name: 'MONEY_UNIT',
				xtype : 'uniCombobox',
				comboType:'AU',
				fieldStyle: 'text-align: center;',
				comboCode:'B004',
		 		displayField: 'value'
			},{
				fieldLabel: '<t:message code="system.label.base.payingmethod" default="결제방법"/>',
				name: 'SET_METH',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B038'
			},{
				fieldLabel: '<t:message code="system.label.base.creditloanamount" default="신용여신액"/>',
				name: 'CREDIT_AMT',
				xtype:'uniNumberfield'
			},{
				fieldLabel: '<t:message code="system.label.base.taxincludedflag" default="세액포함여부"/>',
				name: 'TAX_TYPE',
				xtype: 'uniRadiogroup',
				width: 230,
				comboType:'AU',
				comboCode:'B030',
				value:'1' ,
				allowBlank:false
			},{
				fieldLabel: '<t:message code="system.label.base.paymentcondition" default="결제조건"/>',
				name: 'RECEIPT_DAY',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B034'
			},{
				fieldLabel: '<t:message code="system.label.base.creditloanduedate" default="신용여신만료일"/>',
				name: 'CREDIT_YMD',
				xtype : 'uniDatefield'
			},{
				fieldLabel: '<t:message code="system.label.base.taxcalculationmethod" default="세액계산법"/>',
				name: 'TAX_CALC_TYPE',
				xtype: 'uniRadiogroup',
				width: 230, comboType:'AU',
				comboCode:'B051',
				value:'1',
				allowBlank:false
			},{
				fieldLabel: '<t:message code="system.label.base.closingtype" default="마감종류"/>',
				name: 'TRANS_CLOSE_DAY',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B033'
			},{
				fieldLabel: '<t:message code="system.label.base.armanagemethod" default="미수관리방법"/>',
				name: 'COLLECT_CARE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B057'
			},{
				fieldLabel: '<t:message code="system.label.base.decimalcalculation" default="원미만계산"/>',
				name: 'WON_CALC_BAS',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B017'
			},{
				fieldLabel: '<t:message code="system.label.base.plandcollectiondate" default="수금(예정)일"/>',
				name: 'COLLECT_DAY',
				xtype:'uniNumberfield'
			},{
				fieldLabel: '<t:message code="system.label.base.mainsalescharge" default="주영업담당"/>',
				name: 'BUSI_PRSN',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'S010'
			},{
				fieldLabel: '<t:message code="system.label.base.taxrate" default="세율"/>',
				name: 'VAT_RATE',
				minWidth:50, suffixTpl:'&nbsp;%' ,
				xtype:'uniNumberfield'
			},{
				fieldLabel: '<t:message code="system.label.base.creditapplyyn" default="여신적용여부"/>',
				name:'CREDIT_YN',
				xtype: 'uniRadiogroup',
				width: 230,
				comboType:'AU',
				comboCode:'B010',
				value:'N',
				allowBlank:false
			},{
				fieldLabel: '<t:message code="system.label.base.calendartype" default="카렌더 타입"/>',
				name: 'CAL_TYPE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B062'
			},
				Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.base.relateddepartments" default="관련부서"/>',
					valueFieldWidth:50,
					textFieldWidth:100,
					textFieldName:'DEPT_NAME',
					valueFieldName:'DEPT_CODE',
					DBvalueFieldName: 'TREE_CODE',
					DBtextFieldName: 'TREE_NAME',
					listeners: {
		                'onSelected': function(records, type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
		                    	grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('DEPT_NAME','');
		                    	grdRecord.set('DEPT_CODE','');
		                }
					}
			}),
			 {
			 	fieldLabel: '<t:message code="system.label.base.electronicdocumentcharger2" default="전자문서담당자2"/>',
			 	//labelWidth:120,
			 	hidden: true,
			 	name: 'BILL_PRSN2',
			 	width:245
			 },{
			 	fieldLabel: '<t:message code="system.label.base.electronicdocumencellphone2" default="전자문서핸드폰2"/>',
			 	//labelWidth:120,
			 	name: 'HAND_PHON2',
			 	hidden: true,
			 	width:245
			 },{
			 	fieldLabel: '<t:message code="system.label.base.electronicdocumentemail2" default="전자문서Email2"/>',
			 	//labelWidth:120,
			 	name: 'BILL_MAIL_ID2',
			 	width:245
			 },{
			 	fieldLabel: '<t:message code="system.label.base.electronicdocumentdivision" default="전자문서구분"/>',
			 	//labelWidth:120,
			 	name: 'BILL_MEM_TYPE',
			 	xtype : 'uniCombobox',
			 	comboType:'AU',
			 	comboCode:'S051',
			 	width:245
			 },{
                fieldLabel: '<t:message code="system.label.base.regularpaymentflag" default="정기결제여부"/>',
                name:'R_PAYMENT_YN',
                xtype: 'uniRadiogroup',
                width: 230,
                comboType:'AU',
                comboCode:'B010',
                value:'N',
                allowBlank:false
            },/* {
                xtype: 'component'
            },{
                xtype: 'component'
            }, */{
                fieldLabel: '<t:message code="system.label.base.transportmethod" default="운송방법"/>',
                //labelWidth:120,
                name: 'DELIVERY_METH',
                xtype : 'uniCombobox',
                comboType:'AU',
                comboCode:'WB01',
                width:245
//                colspan:2
             }]
		},{
			title: '<t:message code="system.label.base.generalinfo" default="일반정보"/>',
			flex : 1,
			defaultType: 'uniTextfield',
    		padding	: '0 0 5 0',
			layout: {
			            type: 'uniTable',
			            tableAttrs: { style: { width: '100%' } },
			            tdAttrs:{valign:'top'},
			            columns: 3
			},
			items :[
				Unilite.popup('ZIP',{
					showValue:false,
					textFieldName:'ZIP_CODE',
					DBtextFieldName:'ZIP_CODE',
					popupHeight:600,
					listeners: { 'onSelected': {
					                    fn: function(records, type  ){
					                    	var frm = Ext.getCmp('detailForm');
					                    	frm.setValue('ADDR1', records[0]['ZIP_NAME']);
					                    	frm.setValue('ADDR2', records[0]['ADDR2']);
					                    	//console.log("(records[0]['ZIP_CODE1_NAME'] : ", records[0]['ZIP_CODE1_NAME']);
					                    	//Ext.getCmp('ADDR2_F').setValue(records[0]['ADDR2']);
					                    },
					                    scope: this
					                  },
					                  'onClear' : function(type)	{
					                  		var frm = Ext.getCmp('detailForm');
					                    	frm.setValue('ADDR1', '');
					                    	frm.setValue('ADDR2', '');
					                  },
										applyextparam: function(popup){
											var frm = Ext.getCmp('detailForm');
											var paramAddr = frm.getValue('ADDR1'); //우편주소 파라미터로 넘기기
											if(Ext.isEmpty(paramAddr)){
												popup.setExtParam({'GBN': 'post'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
											}else{
												popup.setExtParam({'GBN': 'addr'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
											}
											popup.setExtParam({'ADDR': paramAddr});
										}
					}
			}),{
			  	fieldLabel: '<t:message code="system.label.base.mailingaddress" default="우편주소"/>',
			  	name: 'ADDR1' ,
			  	xtype:'uniTextfield',
			  	holdable: 'hold',
			  	width: 500,
			  	colspan:2
			},{
				xtype: 'component'
            },{
				fieldLabel: '<t:message code="system.label.base.addressdetail" default="상세주소"/>',
				name: 'ADDR2',
			  	xtype:'uniTextfield',
			  	holdable: 'hold',
			  	width: 500,
			  	colspan:2
			},{
				fieldLabel: '<t:message code="system.label.base.phoneno" default="전화번호"/>',
				name: 'TELEPHON'
			},{
                fieldLabel: '<t:message code="system.label.base.faxno" default="팩스번호"/>',
                name: 'FAX_NUM'
            },{
				fieldLabel: '<t:message code="system.label.base.homepage" default="홈페이지"/>',
				name: 'HTTP_ADDR'
            },
					Unilite.popup('BANK',{
					fieldLabel: '<t:message code="system.label.base.financialinstitution" default="금융기관"/>',
					id:'BANK_CODE',
					valueFieldName:'BANK_CODE',
					textFieldName:'BANK_NAME' ,
					DBvalueFieldName:'BANK_CODE',
					DBtextFieldName:'BANK_NAME',
					listeners: {
		                'onSelected': function(records, type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
		                    	grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('BANK_CODE','');
		                    	grdRecord.set('BANK_NAME','');
		                }
					}
			}),

            {
				fieldLabel:'<t:message code="system.label.base.bankaccount" default="계좌번호"/>',
				name :'BANKBOOK_NUM_EXPOS',
				readOnly:true,
				focusable:false,
				listeners:{
					afterrender:function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{
					detailForm.openCryptBankAccntPopup();
				}
			},
			{
				fieldLabel: '<at:message code="system.label.base.bankaccount" default="계좌번호"/>',
				name: 'BANKBOOK_NUM',
				xtype: 'uniTextfield',
				maxLength:50,
				hidden:true
			},

			{
				fieldLabel: '<t:message code="system.label.base.accountholder" default="예금주"/>',
				name: 'BANKBOOK_NAME',
				colspan:2,
				hidden:false
			},
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.base.summarycustom" default="집계거래처"/>', /* id:'MANAGE_CUSTOM', */
					valueFieldName:'MANAGE_CUSTOM',
					textFieldName:'MCUSTOM_NAME',
				    DBvalueFieldName:'CUSTOM_CODE',
				    DBtextFieldName:'CUSTOM_NAME',
					listeners: {
		                'onSelected': function(records, type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
		                    	grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('MANAGE_CUSTOM','');
		                    	grdRecord.set('MCUSTOM_NAME','');
		                }
					}
		  	}),
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.base.collectioncustomer" default="수금거래처"/>',
					valueFieldName:'COLLECTOR_CP',
					textFieldName:'COLLECTOR_CP_NAME',
					DBvalueFieldName:'CUSTOM_CODE',
					DBtextFieldName:'CUSTOM_NAME',
					listeners: {
		                'onSelected': function(records, type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
		                    	grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('COLLECTOR_CP','');
		                    	grdRecord.set('COLLECTOR_CP_NAME','');
		                }
					}
			}),
				{

            	fieldLabel: 'E-mail',
				name: 'MAIL_ID'
			},
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.base.billcustom" default="계산서거래처"/>',
					id:'BILL_CUSTOM',
					valueFieldName:'BILL_CUSTOM',
					textFieldName:'BILL_CUSTOM_NAME' ,
					DBvalueFieldName:'CUSTOM_CODE',
					DBtextFieldName:'CUSTOM_NAME',
					listeners: {
		                'onSelected': function(records, type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
		                    	grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('BILL_CUSTOM','');
		                    	grdRecord.set('BILL_CUSTOM_NAME','');
		                }
					}
			}),{
				fieldLabel: '<t:message code="system.label.base.remarks" default="비고"/>',
				name: 'REMARK',
				xtype:'textarea',
				width:570,
				height:30,
				colspan:3
			}]
	    },{
			title	: '<t:message code="system.label.base.accountinformation" default="계좌정보"/>',
//			flex 	: 1,
			defaultType: 'uniTextfield',
			layout	: {
	            type		: 'uniTable',
//	            tableAttrs	: { style: { width: '100%' } },
	            tdAttrs		: {valign:'top'},
	            columns		: 3
			},
			items : [masterGrid2]
	    },{
            title   : '<t:message code="system.label.base.electronicdocumentinfo" default="전자문서정보"/>',
//            flex    : 1,
            defaultType: 'uniTextfield',
            layout  : {
                type        : 'uniTable',
//                tableAttrs  : { style: { width: '100%' } },
                tdAttrs     : {valign:'top'},
                columns     : 3
            },
            items : [masterGrid3]
        }],
		listeners:{
			hide:function()	{
					masterGrid.show();
					if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
						panelResult.show();
					}
				}

   		},
//   		openCryptBankAccntPopup:function(  )	{
//			var record = this;
//			if(this.activeRecord)	{
//				var params = {'BANK_ACCNT_CODE': this.getValue('BANKBOOK_NUM')};
//				Unilite.popupCryptBankAccnt('form', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
//			}
//
//		},
 		openCryptBankAccntPopup:function()	{
			var record = this;
			var params = {'BANK_ACCOUNT': this.getValue('BANKBOOK_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('form', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
		},
  		openCryptRepreNoPopup:function(  )	{
			var record = this;

			var params = {'REPRE_NUM':this.getValue('TOP_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
			Unilite.popupCipherComm('form', record, 'TOP_NUM_EXPOS', 'TOP_NUM', params);

		}

//	    		,dockedItems: [{
//								    xtype: 'toolbar',
//								    dock: 'bottom',
//								    ui: 'footer',
//								    items: [
//									        {	id : 'saveBtn',
//												itemId : 'saveBtn',
//												text: '저장',
//												handler: function() {
//													UniAppManager.app.onSaveDataButtonDown();
//												},
//												disabled: true
//											}, '-',{
//												id : 'saveCloseBtn',
//												itemId : 'saveCloseBtn',
//												text: '저장 후 닫기',
//												handler: function() {
//													if(!detailForm.isDirty() )	{
//														detailWin.hide();
//													}else {
//														var config = {success :
//																	function()	{
//																		detailWin.hide();
//																	}
//															}
//														UniAppManager.app.onSaveDataButtonDown(config);
//													}
//												},
//												disabled: true
//											}, '-',{
//												id : 'deleteCloseBtn',
//												itemId : 'deleteCloseBtn',
//												text: '삭제',
//												handler: function() {
//														var record = masterGrid.getSelectedRecord();
//														var phantom = record.phantom;
//														UniAppManager.app.onDeleteDataButtonDown();
//														var config = {success :
//																	function()	{
//
//																		detailWin.hide();
//																	}
//															}
//														if(!phantom)	{
//															UniAppManager.app.onSaveDataButtonDown(config);
//														} else {
//															detailWin.hide();
//														}
//
//												},
//												disabled: false
//											}, '->',{
//												itemId : 'closeBtn',
//												text: '닫기',
//												handler: function() {
//													detailWin.hide();
//												},
//												disabled: false
//											}
//								    ]
//								}]
//				,loadForm: function(record)	{
//       				// window 오픈시 form에 Data load
//					this.reset();
//					this.setActiveRecord(record || null);
//					this.resetDirtyStatus();
//
//					var win = this.up('uniDetailFormWindow');
//                    if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
//       				     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
//                         win.setToolbarButtons(['prev','next'],true);
//                    }
//
//       			}
//       			, listeners : {
//       				uniOnChange : function( form, field, newValue, oldValue )	{
//       					var b = form.isValid();
//       					this.up('uniDetailFormWindow').setToolbarButtons(['saveBtn','saveCloseBtn'],b);
//                        this.up('uniDetailFormWindow').setToolbarButtons(['prev','next'],!b);   // 저장이 필요할경우 이전 다음 disable
//       				}
//
//       			}
	}); // detailForm

//	function openDetailWindow(selRecord, isNew) {
//    		// 그리드 저장 여부 확인
//    		var edit = masterGrid.findPlugin('cellediting');
//			if(edit && edit.editing)	{
//				setTimeout("edit.completeEdit()", 1000);
//			}
//			UniAppManager.app.confirmSaveData();
//
//			// 추가 Record 인지 확인
//			if(isNew)	{
//				var r = masterGrid.createRow();
//				selRecord = r[0];
//			}
//			// form에 data load
//			detailForm.loadForm(selRecord);
//
//			if(!detailWin) {
//				detailWin = Ext.create('widget.uniDetailFormWindow', {
//	                title: '상세정보',
//	                width: 810,
//	                height: 500,
//	                isNew: false,
//	                x:0,
//	                y:0,
//	                items: [detailForm],
//	                listeners : {
//	                			 show:function( window, eOpts)	{
//	                			 	detailForm.body.el.scrollTo('top',0);
//	                			 }
//	                },
//                    onCloseButtonDown: function() {
//                        this.hide();
//                    },
//                    onDeleteDataButtonDown: function() {
//                        var record = masterGrid.getSelectedRecord();
//                        var phantom = record.phantom;
//                        UniAppManager.app.onDeleteDataButtonDown();
//                        var config = {success :
//                                    function()  {
//                                        detailWin.hide();
//                                    }
//                            }
//                        if(!phantom)    {
//
//                                UniAppManager.app.onSaveDataButtonDown(config);
//
//                        } else {
//                            detailWin.hide();
//                        }
//                    },
//                    onSaveDataButtonDown: function() {
//                        var config = {success : function()	{
//                    						 	detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
//                    						 	detailWin.setToolbarButtons(['prev','next'],true);
//                    					}
//                    	}
//                        UniAppManager.app.onSaveDataButtonDown(config);
//                    },
//                    onSaveAndCloseButtonDown: function() {
//                        if(!detailForm.isDirty())   {
//                            detailWin.hide();
//                        }else {
//                            var config = {success :
//                                        function()  {
//                                            detailWin.hide();
//                                        }
//                                }
//                            UniAppManager.app.onSaveDataButtonDown(config);
//                        }
//                    },
//			        onPrevDataButtonDown:  function()   {
//			            if(masterGrid.selectPriorRow()) {
//	                        var record = masterGrid.getSelectedRecord();
//	                        if(record) {
//                                detailForm.loadForm(record);
//	                        }
//                        }
//			        },
//			        onNextDataButtonDown:  function()   {
//			            if(masterGrid.selectNextRow()) {
//                            var record = masterGrid.getSelectedRecord();
//                            if(record) {
//                                detailForm.loadForm(record);
//                            }
//                        }
//			        }
//
//				})
//    		}
//
//			detailWin.show();
//
//    }
    Unilite.Main({
    	id  : 'bcm100ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'거래처정보',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [
					{
						type: 'hum-grid',
			            handler: function () {
			            	detailForm.hide();
			                //masterGrid.show();
			            	//panelResult.show();
			            }
					},{

						type: 'hum-photo',
			            handler: function () {
			            	/*
			            	var edit = masterGrid.findPlugin('cellediting');
							if(edit && edit.editing)	{
								setTimeout("edit.completeEdit()", 1000);
							}
							*/
			                masterGrid.hide();
			                panelResult.hide();
			                //detailForm.show();
			            }
					}
				],
				items:[
					masterGrid,
					detailForm
				]
			}
		],
		autoButtonControl : false,
		fnInitBinding : function(params) {
			if(BsaCodeInfo.gsHiddenField == 'Y'){
//                detailForm.getField('BANKBOOK_NUM').setHidden(true);
                detailForm.getField('BANKBOOK_NAME').setHidden(true);
                detailForm.getField('BANKBOOK_NUM_EXPOS').setHidden(true);
            }else{
//                detailForm.getField('BANKBOOK_NUM').setHidden(false);
                detailForm.getField('BANKBOOK_NAME').setHidden(false);
                detailForm.getField('BANKBOOK_NUM_EXPOS').setHidden(false);
           }

			if(params && params.CUSTOM_CODE ) {
				panelSearch.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
				panelSearch.setValue('COMP_CODE',params.COMP_CODE);
				masterGrid.getStore().loadStoreRecords();
			}
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);
		},

		onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('bcm100ukrvGrid');
			 masterGrid.downloadExcelXml();
		},

		onQueryButtonDown : function()	{
//			detailForm.clearForm ();
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			masterGrid.createRow();
//			openDetailWindow(null, true);
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},
		onSaveDataButtonDown: function (config) {

			directMasterStore.saveStore(config);

		},
		onDeleteDataButtonDown : function()	{
			if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			detailForm.clearForm();
//			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function()	{
			directMasterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		},
		confirmSaveData: function()	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}

            }
	});	// Main

	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(fieldName=='CUSTOM_CODE')	{
				Ext.getBody().mask();
				var param = {
					'CUSTOM_CODE':newValue
				}
				var currentRecord = record;
				bcm100ukrvService.chkPK(param, function(provider, response)	{
					Ext.getBody().unmask();
					console.log('provider', provider);
					if(!Ext.isEmpty(provider) && provider['CNT'] > 0){
						Unilite.messageBox(Msg.fSbMsgZ0049);
						currentRecord.set('CUSTOM_CODE','');
					}
				});
			} else if( fieldName == 'CUSTOM_NAME' ) {		// 거래처(약명)
				if(newValue == '')	{
					rv = Msg.sMB083;
				}else {
					if(record.get('CUSTOM_FULL_NAME') == '')	{
					 	record.set('CUSTOM_FULL_NAME',newValue);
					}
				}
			} else if( fieldName == 'COMPANY_NUM') { 		// '사업자번호'
				if(BsaCodeInfo.gsCompanyNumChk == 'Y'){
    				if(!Ext.isEmpty(newValue)){
    					Ext.getBody().mask();
    					
        				var param = {
        					'COMPANY_NUM' : newValue
        				}
        				var currentRecord = record;
        				bcm100ukrvService.chkCN(param, function(provider, response){
        				    Ext.getBody().unmask();
        				    console.log('provider',provider);
        				    if(!Ext.isEmpty(provider) && provider['CNT'] > 0){
        				    	Unilite.messageBox("해당 사업자번호가 이미 존재합니다.");
        				    	currentRecord.set('COMPANY_NUM','');
        				    }
        				});
    				}
				}
				
				if(newValue.trim().replace(/-/g,'').length !=10){
				 		Unilite.messageBox('사업자번호 10자리를 입력해주세요.');
				 		rv = false;
				}else {
					record.set('CUST_CHK','T');
					if ( (newValue != oldValue) && ( newValue.trim().length > 0 ) )	{
					 	if(Unilite.validate('bizno', newValue) != true)	{
					 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
					 			rv = false;
					 		}
					 	}else {
					 		newValue = newValue.replace(/-/g,'');
					 		var v = newValue.substring(0,3)+ "-"+ newValue.substring(3,5)+"-" + newValue.substring(5,10);
					 		if(type == 'grid') {
								e.cancel=true;
								record.set(fieldName, v);
							}else {
								editor.setValue(v);
							}
					 	}
					}
				}
			} /*else if( fieldName == 'TOP_NUM') { 		// '주민번호'
				 if ( (newValue != oldValue) && ( newValue.trim().length > 0 ) )	{
				 	if(Unilite.validate('residentno', newValue) != true)	{
				 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{
				 			rv = false;
				 		}
				 	}else {
				 		newValue = newValue.replace(/-/g,'');
				 		var v = newValue.substring(0,6)+ "-"+ newValue.substring(6,13);
				 		if(type == 'grid') {
							e.cancel=true;
							record.set(fieldName, v);
						}else {
							editor.setValue(v);
						}
				 	}
				 }
			}*/ else if( fieldName ==  "MONEY_UNIT") { 			// 기준화폐
				if(UserInfo.currency == newValue) {
					record.set('CREDIT_YN', 'Y');
				}else {
					record.set('CREDIT_YN', 'N');
				}
			} else if( fieldName ==  "CREDIT_YN" ) {			// 여신적용여부
				if(UserInfo.currency != record.get("MONEY_UNIT")) {
					console.log('GRID CREDIT_YN BLUR');
					if("Y" == newValue ) 	{
						record.set('CREDIT_YN','N');
						rv = Msg.sMB217;
					}
				}
			} else if( fieldName == "VAT_RATE" ) { 			// 세율
				if(newValue < 0 ) {
					rv = Msg.sMB076;
				}
			} else if( fieldName ==  "TOT_CREDIT_AMT") {		// 여신(담보)액
				if(newValue < 0 ) {
					rv = Msg.sMB076;
				}
			} else if( fieldName == "COLLECT_DAY") {
				if(newValue < 1 || newValue > 31 ) {
					rv = Msg.sMB210;
				}
			}

			return rv;
		}
	}); // validator


}; // main


</script>


