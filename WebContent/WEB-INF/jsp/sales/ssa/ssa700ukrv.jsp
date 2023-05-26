<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa700ukrv"  >
   <t:ExtComboStore comboType="BOR120"  pgmId="ssa700ukrv" />         <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="B066" /> <!-- 계산서유형 -->
   <t:ExtComboStore comboType="AU" comboCode="S050" /> <!-- 상태(센드빌) -->
   <t:ExtComboStore comboType="AU" comboCode="B086" /> <!-- 전자문서구분(센드빌) -->
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

var isOptQ = false; //수량단위구분, 단가금액출력여부
if(BsaCodeInfo.gsOptQ == "2"){
	isOptQ = true;	
}

var activeGrid;

var billTypeIsHidden = true;	//전자문서구분 hidden 여부
BsaCodeInfo.gsBillYN[0].SUB_CODE == "01"? billTypeIsHidden = false : billTypeIsHidden = true;

function appMain() {
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Ssa700ukrvSendBillModel', {//"01" 센드빌 모델
		fields: [
			{name: 'CHK'			            	, text: '<t:message code="system.label.sales.selection" default="선택"/>'				, type: 'string'},
			{name: 'TRANSYN_NAME'	            	, text: '전송여부명(샌드빌)'			, type: 'string' },
			{name: 'STS'                        	, text: '상태'				, type: 'string' , comboType: 'AU' , comboCode: 'S050'},
			{name: 'REPORT_STAT'                	, text: '국세청신고상태'			, type: 'string' , comboType: 'AU' , comboCode: 'S094'},
			{name: 'CRT_LOC'                    	, text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'				, type: 'string' , comboType: 'AU' , comboCode: 'S099'},
			{name: 'BILL_FLAG'            			, text: '세금계산서 구분'		, type: 'string' , comboType: 'AU' , comboCode: 'S096'},
			{name: 'GUBUN'		                    , text: '영수/청구'			, type: 'string' , comboType: 'AU' , comboCode: 'S076'},
			{name: 'DT'		                    	, text: '<t:message code="system.label.sales.publishdate" default="발행일"/>'				, type: 'uniDate'},
			{name: 'CUSTOM_CODE'	            	, text: '<t:message code="system.label.sales.client" default="고객"/>'				, type: 'string'},
			{name: 'RCOMPANY'		            	, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'RVENDERNO'		            	, text: '사업자번호'			, type: 'string'},
			{name: 'RREG_ID'                    	, text: '종사업자번호'			, type: 'string'},
			{name: 'BILLTYPE'               		, text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'			, type: 'string' , comboType: 'AU' , comboCode: 'B066'},
			{name: 'SUPMONEY'                   	, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'TAXMONEY'		            	, text: '<t:message code="system.label.sales.taxamount" default="세액"/>'				, type: 'uniPrice'},
			{name: 'TOT_AMT_I'   	            	, text: '<t:message code="system.label.sales.totalamount" default="합계"/>'				, type: 'uniPrice'},
			{name: 'SEND_DATE'		            	, text: '전송일시'				, type: 'uniDate'},
			{name: 'BILLSEQ'		            	, text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'			, type: 'string'},
			{name: 'BILLPRSN'		            	, text: '<t:message code="system.label.sales.charger" default="담당자"/>'				, type: 'string'},
			{name: 'HANDPHON'		            	, text: '핸드폰번호'			, type: 'string'},
			{name: 'REMAIL'			            	, text: 'E-MAIL'			, type: 'string'},
			{name: 'EB_NUM'			            	, text: '전자문서번호'			, type: 'string'},
			{name: 'REPORT_AMEND_CD'            	, text: '국세청수정사유'			, type: 'string' , comboType: 'AU' , comboCode: 'S095'},
			{name: 'BIGO'                       	, text: '<t:message code="system.label.sales.remarks" default="비고"/>'				, type: 'string'},
			{name: 'REPORT_ISSUE_ID'            	, text: '신고문서고유코드'		, type: 'string'},
			{name: 'REPORT_EXCEPT_YN'            	, text: '국세청신고제외여부'		, type: 'string' , comboType: 'AU' , comboCode: 'S093'},
			{name: 'TRANSYN'		            	, text: '전송여부'				, type: 'string'},
			{name: 'BILLTYPE'                   	, text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'			, type: 'string' , comboType: 'AU' , comboCode: 'B066' },
			{name: 'TAXRATE'                    	, text: '세율구분'				, type: 'string'},
			{name: 'CASH'                       	, text: '세금계산서상의 현금지급액'	, type: 'uniPrice'},
			{name: 'CHECKS'                     	, text: '세금계산서상의 수표지급액'	, type: 'uniPrice'},
			{name: 'NOTE'                       	, text: '세금계산서상의 어음지급액'	, type: 'uniPrice'},
			{name: 'CREDIT'                     	, text: '세금계산서상의 외상미수금'	, type: 'uniPrice'},
			{name: 'SVENDERNO'                  	, text: '사업자번호'			, type: 'string'},     //'공급자 사업자번호'	
			{name: 'SCOMPANY'                   	, text: '업체명'				, type: 'string'},	   //'공급자 업체명'	
			{name: 'SREG_ID'                    	, text: '종사업자번호'			, type: 'string'},     //'공급자 종사업자번호'
			{name: 'SCEONAME'                   	, text: '대표자명'				, type: 'string'},     //'공급자 대표자명'	
			{name: 'SUPTAE'                     	, text: '업태'				, type: 'string'},     //'공급자 업태'	
			{name: 'SUPJONG'                    	, text: '업종'				, type: 'string'},     //'공급자 업종'	
			{name: 'SADDRESS'                   	, text: '<t:message code="system.label.sales.address" default="주소"/>'				, type: 'string'},     //'공급자 주소'	
			{name: 'SADDRESS2'                  	, text: '상세주소'				, type: 'string'},     //'공급자 상세주소'	
			{name: 'SUSER'                      	, text: '<t:message code="system.label.sales.chargername" default="담당자명"/>'				, type: 'string'},     //'공급자 담당자명'	
			{name: 'SDIVISION'                  	, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'				, type: 'string'},	   //'공급자 부서명'	
			{name: 'STELNO'                     	, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				, type: 'string'},     //'공급자 전화번호'	
			{name: 'SEMAIL'                     	, text: '이메일주소'			, type: 'string'},     //'공급자 이메일주소'	
			{name: 'RCEONAME'                   	, text: '대표자명'				, type: 'string'},     //'공급받는자 대표자명'
			{name: 'RUPTAE'                     	, text: '업태'				, type: 'string'},     //'공급받는자 업태'	
			{name: 'RUPJONG'                    	, text: '업종'				, type: 'string'},     //'공급받는자 업종'	
			{name: 'RADDRESS'                   	, text: '<t:message code="system.label.sales.address" default="주소"/>'				, type: 'string'},     //'공급받는자 주소'	
			{name: 'RADDRESS2'                  	, text: '상세주소'				, type: 'string'},	   //'공급받는자 상세주소'
			{name: 'RUSER'                      	, text: '<t:message code="system.label.sales.chargername" default="담당자명"/>'				, type: 'string'},     //'공급받는자 담당자명'
			{name: 'RDIVISION'                  	, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'				, type: 'string'},     //'공급받는자 부서명'	
			{name: 'RTELNO'                     	, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				, type: 'string'},     //'공급받는자 전화번호'
			{name: 'REVERSEYN'                  	, text: '역발행여부'			, type: 'string'},
			{name: 'SENDID'                     	, text: '공급자'				, type: 'string'},
			{name: 'RECVID'                     	, text: '공급받는자'			, type: 'string'},
			{name: 'DIV_CODE'                   	, text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'			, type: 'string'},
			{name: 'SALE_DIV_CODE'              	, text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'			, type: 'string'},
			{name: 'DEL_YN'                     	, text: '삭제가능여부'			, type: 'string'},
			{name: 'COMP_CODE'                  	, text: 'COMP_CODE'			, type: 'string'},
			{name: 'BILL_MEM_TYPE'              	, text: '전자문서구분'			, type: 'string' , comboType: 'AU' , comboCode: 'S096' , hidden:billTypeIsHidden},
			{name: 'CREATE_DT'                  	, text: '생성일자'				, type: 'uniDate'},
			{name: 'REPORT_ETC01'               	, text: '당초승인번호'			, type: 'string'},
			{name: 'ERR_GUBUN'                  	, text: '에러구분'				, type: 'string'},
			{name: 'BEFORE_PUB_NUM'             	, text: '수정전세금계산서번호'		, type: 'string'},
			{name: 'ORIGINAL_PUB_NUM'            	, text: '원본세금계산서번호'		, type: 'string'},
			{name: 'PLUS_MINUS_TYPE'            	, text: '계산서구분'			, type: 'string'},
			{name: 'SEQ_GUBUN'                  	, text: '순번정열'				, type: 'string'},
			{name: 'BUSI_PRSN'                  	, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				, type: 'string', comboYype:'AU', comboCode:'S010'},
			{name: 'BILLSTAT'                  		, text: '상태'				, type: 'string', comboYype:'AU', comboCode:'S050'}
		]
	});//End of Unilite.defineModel('Ssa700ukrvSendBillModel', {
   
	Unilite.defineModel('Ssa700ukrvWebCashModel', {//"02" 웹캐시용 모델
	    fields: [  	 
	    	{name:'CHK' 							,text:'<t:message code="system.label.sales.selection" default="선택"/>' 					,type: 'string'},
			{name:'TRANSYN_NAME' 					,text:'전송(웹캐시)' 					,type: 'string'},
			{name:'STAT_CODE' 						,text:'상태'					,type: 'string' , comboType: 'AU' , comboCode: 'S050'},
			{name:'STS'								,text:'상태' 					,type: 'string'},
			{name:'CRT_LOC'							,text:'<t:message code="system.label.sales.creationpath" default="생성경로"/>' 				,type: 'string' , comboType: 'AU' , comboCode: 'S099'},
			{name:'BILL_FLAG'						,text:'세금계산서구분' 			,type: 'string' , comboType: 'AU' , comboCode: 'S096'},
			{name:'TAX_TYPE'						,text:'세금계산서종류' 			,type: 'string'},
			{name:'POPS_CODE'						,text:'영수/청구 구분' 			,type: 'string' , comboType: 'AU' , comboCode: 'S076'},
			{name:'REGS_DATE'						,text:'<t:message code="system.label.sales.publishdate" default="발행일"/>'				,type: 'uniDate'},
			{name:'SELR_CORP_NO'					,text:'사업자번호' 				,type: 'string'},  //   '공급자 사업자번호' 
			{name:'SELR_CORP_NM' 					,text:'업체명' 				,type: 'string'},  //	'공급자 업체명' 	
			{name:'SELR_CODE'						,text:'종사업자번호' 			,type: 'string'},  //	'공급자 종사업자번호'
			{name:'SELR_CEO' 						,text:'대표자명' 				,type: 'string'},  // 	'공급자 대표자명' 	
			{name:'SELR_BUSS_CONS' 					,text:'업태' 					,type: 'string'},  //	'공급자 업태' 		
			{name:'SELR_BUSS_TYPE' 					,text:'업종' 					,type: 'string'},  //	'공급자 업종' 		
			{name:'SELR_ADDR' 						,text:'<t:message code="system.label.sales.address" default="주소"/>' 					,type: 'string'},  //	'공급자 주소' 		
			{name:'SELR_CHRG_NM' 					,text:'<t:message code="system.label.sales.chargername" default="담당자명"/>' 				,type: 'string'},  //	'공급자 담당자명' 	
			{name:'SELR_CHRG_POST'					,text:'<t:message code="system.label.sales.departmentname" default="부서명"/>' 				,type: 'string'},  //	'공급자 부서명' 	
			{name:'SELR_CHRG_TEL'					,text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>' 				,type: 'string'},  //	'공급자 전화번호' 	
			{name:'SELR_CHRG_EMAIL'					,text:'이메일주소' 				,type: 'string'},  //	'공급자 이메일주소' 
			{name:'SELR_CHRG_MOBL'					,text:'휴대폰번호' 				,type: 'string'},  //   '공급자 휴대폰번호' 
			{name:'CUSTOM_CODE'						,text:'<t:message code="system.label.sales.client" default="고객"/>' 				,type: 'string'},
			{name:'BUYR_CORP_NM'					,text:'<t:message code="system.label.sales.clientname" default="고객명"/>' 				,type: 'string'},
			{name:'BUYR_GB'							,text:'<t:message code="system.label.sales.classficationcode" default="구분코드"/>' 				,type: 'string'},  //  '공급받는자 구분코드' 	
			{name:'BUYR_CORP_NO'					,text:'사업자번호' 				,type: 'string'},  //	'공급받는자 사업자번호' 
			{name:'BUYR_CODE'						,text:'종사업자번호' 			,type: 'string'},  //  '공급받는자 종사업자번호'
			{name:'BILLTYPENAME'					,text:'<t:message code="system.label.sales.billclass" default="계산서유형"/>' 				,type: 'string' },
			{name:'CHRG_AMT'						,text:'<t:message code="system.label.sales.supplyamount" default="공급가액"/>' 				,type: 'uniPrice'},
			{name:'TAX_AMT'							,text:'<t:message code="system.label.sales.taxamount" default="세액"/>' 					,type: 'uniPrice'},
			{name:'TOTL_AMT'						,text:'<t:message code="system.label.sales.totalamount" default="합계"/>' 					,type: 'uniPrice'},
			{name:'BUYR_CEO'						,text:'대표자명' 				,type: 'string'},    // '공급받는자 대표자명' 		
			{name:'BUYR_BUSS_CONS'					,text:'업태' 					,type: 'string'},	 //	'공급받는자 업태' 		
			{name:'BUYR_BUSS_TYPE'					,text:'업종' 					,type: 'string'},    // '공급받는자 업종' 		
			{name:'BUYR_ADDR'						,text:'<t:message code="system.label.sales.address" default="주소"/>' 					,type: 'string'},   //   '공급받는자 주소' 		
			{name:'BUYR_CHRG_NM1'					,text:'<t:message code="system.label.sales.charger" default="담당자"/>' 				,type: 'string'},   //   '전자문서담당자' 	
			{name:'BUYR_CHRG_TEL1' 					,text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>' 				,type: 'string'},   //   '전자문서전화번호' 	
			{name:'BUYR_CHRG_MOBL1' 				,text:'핸드폰' 				,type: 'string'},   //   '전자문서핸드폰' 	
			{name:'BUYR_CHRG_EMAIL1' 				,text:'E-MAIL' 				,type: 'string'},   //    '전자문서E-MAIL' 	
			{name:'BUYR_CHRG_NM2' 					,text:'담당자2' 				,type: 'string'},   //   '전자문서담당자2' 	
			{name:'BUYR_CHRG_MOBL2' 				,text:'핸드폰2' 				,type: 'string'},   //   '전자문서핸드폰2' 	
			{name:'BUYR_CHRG_EMAIL2'				,text:'E-MAIL2' 			,type: 'string'},   //   '전자문서E-MAIL2' 
			{name:'SEND_DATE'						,text:'전송일시' 				,type: 'uniDate'},
			{name:'ISSU_SEQNO'						,text:'전자문서번호' 			,type: 'string'},
			{name:'SELR_MGR_ID3'					,text:'<t:message code="system.label.sales.billno" default="계산서번호"/>' 				,type: 'string'},
			{name:'NOTE1'							,text:'<t:message code="system.label.sales.remarks" default="비고"/>' 					,type: 'string'},
			{name:'MODY_CODE'						,text:'수정코드' 				,type: 'string'},
			{name:'REQ_STAT_CODE'					,text:'요청상태코드' 			,type: 'string'},
			{name:'RECP_CD'							,text:'역발행 구분 ' 			,type: 'string'},
			{name:'BILL_TYPE'						,text:'매출/매입구분' 			,type: 'string'},    
			{name:'SND_MAL_YN'						,text:'Email 발행요청유무' 		,type: 'string'},    
			{name:'SND_SMS_YN'						,text:'SMS 발행요청유무' 		,type: 'string'},
			{name:'SND_FAX_YN'						,text:'FAX 발행요청여부' 		,type: 'string'},    
			{name:'COMP_CODE'						,text:'<t:message code="system.label.sales.compcode" default="법인코드"/>' 				,type: 'string'},    
			{name:'DIV_CODE'						,text:'<t:message code="system.label.sales.divisioncode" default="사업장코드"/>' 				,type: 'string'},    
			{name:'SALE_DIV_CODE'					,text:'<t:message code="system.label.sales.divisioncode" default="사업장코드"/>' 				,type: 'string'},
			{name:'DEL_YN'							,text:'삭제여부' 				,type: 'string'},
			{name:'REPORT_AMEND_CD'					,text:'신고문서 수정사유 코드' 		,type: 'string'},
			{name:'BFO_ISSU_ID'						,text:'당초승인번호' 			,type: 'string'},    
			{name:'ERR_GUBUN'						,text:'에러구분' 				,type: 'string'},    
			{name:'ISSU_ID'							,text:'국세청 일련번호' 			,type: 'string'},
			{name:'BEFORE_PUB_NUM'					,text:'수정전세금계산번호' 		,type: 'string'},    
			{name:'ORIGINAL_PUB_NUM'				,text:'원본세금계산서번호' 		,type: 'string'},    
			{name:'PLUS_MINUS_TYPE'					,text:'계산서구분' 				,type: 'string'},    
			{name:'SEQ_GUBUN'						,text:'순번정렬' 				,type: 'string'}
		]
	});
	
	
	var sendBillStore = Unilite.createStore('ssa700ukrvSendBillStore',{
			model: 'Ssa700ukrvSendBillModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa700ukrvService.selectSendBillMaster'  
                }
            },
            loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});			
			},
//			fnTotalSum: function() {			
//			console.log("=============Exec fnfnTotalSum()");
//			var sumTotal = Ext.isNumeric(this.sum('TOT_AMT_I')) ? this.sum('TOT_AMT_I'):0;
//			
//			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(!Ext.isEmpty(records)){
	           			//directStore.loadStoreRecords(records[0]);
						UniAppManager.app.fnSendBillColSet(records);	//전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기		

			            }
	           	}
		}
	});		// End of var sendBillStore = Unilite.createStore('ssa700ukrvSendBillStore',{
	
	var webCashStore = Unilite.createStore('ssa700ukrvWebCashStore',{
			model: 'Ssa700ukrvWebCashModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa700ukrvService.selectWebCashMaster'                	
                }
            },
            loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(!Ext.isEmpty(records)){
//	           			detailStore.loadStoreRecords(records[0]);
//	           			var viewNormal = detailGrid.getView();						
//						viewNormal.getFeature('detailGridTotal').toggleSummaryRow(true);						
						UniAppManager.app.fnWebCashColSet(records);	//전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
	           		}
			}
		}
	});

   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	
   /**
    * 검색조건 (Search Panel)
    * @type 
    */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		items: [{
			xtype:'container',
			layout: {type: 'uniTable', columns: 1},
			items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false
			},{
				fieldLabel: '등록일',
				xtype: 'uniDateRangefield',
				startFieldName: 'BILL_DATE_FR',
				endFieldName: 'BILL_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:true
			},{
				fieldLabel: '<t:message code="system.label.sales.billclass" default="계산서유형"/>', 
				name: 'BILL_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B066'
			},
				Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>', 
					 
					validateBlank: false,
					extParam: {'CUSTOM_TYPE': '3'},
					textFieldName: 'CUSTOM_NAME',
					valueFieldName: 'CUSTOM_CODE'
				}),
			{
				fieldLabel: '입력일',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSERT_DB_TIME_FR',
				endFieldName: 'INSERT_DB_TIME_TO',
				/*startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),*/
				width: 315
			},{
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>', 
				name: 'CRT_LOC', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S099'
			},
				Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>', 
					 
					validateBlank: false,
					extParam: {'CUSTOM_TYPE': '3'},
					textFieldName: 'MANAGE_CUST_CD',
					valueFieldName: 'MANAGE_CUST_NM'
				}),
			{
				fieldLabel: '전송일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SEND_LOG_TIME_FR',
				endFieldName: 'SEND_LOG_TIME_TO',
				/*startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),*/
				width: 315
			},{
				fieldLabel: '상태', 
				name: 'BILLSTAT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S050'
			},{
				xtype: 'radiogroup',
				id : 'BILL_SEND_YN', 
				fieldLabel: '전송여부',						            		
				items: [{
					boxLabel: '미전송', 
					width:60, 
					name: 'BILL_SEND_YN', 
					inputValue: 'N', 
					checked: true
				},{
					boxLabel: '전송', 
					width:60, 
					name: 'BILL_SEND_YN', 
					inputValue: 'Y'
				}]
			},{					
    			fieldLabel: '<t:message code="system.label.sales.remarks" default="비고"/>',
    			name:'REMARK',
    			xtype: 'uniTextfield'
    		},{
				fieldLabel: '전자문서구분', 
				name: 'BILL_MEM_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B086'
			},{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>', 
				name: 'BUSI_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S010'
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '수량단위',						            		
				id: 'rdoSelect1',
				items: [{
					boxLabel: '<t:message code="system.label.sales.salesunit" default="판매단위"/>', 
					width:80, 
					name: 'rdoSelect1', 
					inputValue: 'A', 
					checked: !isOptQ
				},{
					boxLabel: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>', 
					width:80, 
					name: 'rdoSelect1', 
					checked: isOptQ
				}]
			},{					
    			fieldLabel: '에러내용',
    			name:'TXT_ERR_MSG',
    			xtype: 'textareafield',
    			width: 315,
    			height: 35,
    			readOnly: true
    		},{					
    			fieldLabel: '총합계',
    			name:'TXT_TOTAL',
    			xtype: 'uniNumberfield',
    			value:'0',
    			readOnly:true
    		},{
				fieldLabel: '영수/청구', 
				name: 'GUBUN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S076'
			},{
				xtype:'container',
				layout: {type: 'uniTable', columns: 2},
				style: {
					color: 'blue'				
				},
				items:[{
					xtype: 'container',
					html: '※&nbsp;</br></br></br>'					
				}, {
					xtype: 'container',
					html: '공급자는 사업장정보, 공급받는자는 거래처정보에서 회사</br>명, 대표자, 업태, 업종, 주소, 전화번호, EMAIL 등을 참조</br>합니다.'				
				}]
			}]                         
		}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
   
    /**
     * sendBillGrid 정의(Grid Panel)
     * @type 
     */
	var sendBillGrid = Unilite.createGrid('Ssa700ukrvSendBillModel', {
       // for tab       
		region: 'center' ,
        layout : 'fit',
        uniOpt:{
        	useGroupSummary: false,  //그룹핑 버튼 사용 여부
        	useRowNumberer: false,
			useMultipleSorting: false, //정렬 버튼 사용 여부
			useLiveSearch: false,  //내용검색 버튼 사용 여부
			onLoadSelectFirst: false,
			state: {
 				useState: true,   //그리드 설정 버튼 사용 여부
 				useStateList: true  //그리드 설정 목록 사용 여부
			}
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	uniOpt:{
        		onLoadSelectFirst: false
        	},
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			if(record.get('TRANSYN_NAME') == '<span style="color:' + 'red' + ';">' + 'Error' + '</span>'){//Error컬럼은 선택 못하게
						return false;        			        				
        			}
        		},
				select: function(grid, record, index, eOpts ){
					
					var a =	panelSearch.getValue('TXT_TOTAL');
					var b = record.get('TOT_AMT_I');
					panelSearch.setValue('TXT_TOTAL',a+b);
	          	},
				deselect:  function(grid, record, index, eOpts ){
														
					var a =	panelSearch.getValue('TXT_TOTAL');
					var b = record.get('TOT_AMT_I');
					panelSearch.setValue('TXT_TOTAL', a-b);
        		}
        	}
        }),
    	features: [
    		{id : 'sendBillGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'sendBillGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
		store: sendBillStore,
		columns: [
			{dataIndex: 'CHK'			              	, width:33,locked:true, hidden: true},
			{dataIndex: 'TRANSYN_NAME'	              	, width:80,locked:true
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
			{dataIndex: 'STS'                          	, width:60,locked:true},
			{dataIndex: 'REPORT_STAT'                  	, width:110,locked:true},
			{dataIndex: 'CRT_LOC'                      	, width:80,locked:true},
			{dataIndex: 'BILL_FLAG'                     , width:100,locked:true},
			{dataIndex: 'GUBUN'                        	, width:100,locked:true  , comboType: 'AU' , comboCode: 'S076'},
			{dataIndex: 'DT'		                    , width:86,locked:true},
			{dataIndex: 'CUSTOM_CODE'	              	, width:86,locked:true},
			{dataIndex: 'RCOMPANY'		              	, width:160,locked:true},
			{dataIndex: 'RVENDERNO'		              	, width:100},
			{dataIndex: 'RREG_ID'                      	, width:88},
			{dataIndex: 'BILLTYPE'                 		, width:86,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + sendBillStore.getCount() + ' 건', '건수 : ' + sendBillStore.getCount() + ' 건');
            }
				
				
				/*summaryRenderer: function(value, summaryData, dataIndex ) {
              		var	rv =  "<div align='center'>건수 : " + sendBillStore.getCount() + " 건</div>";		                	
            		return rv;										
	            }*/
			},
			{dataIndex: 'SUPMONEY'                     	, width:113 , summaryType: 'sum'},
			{dataIndex: 'TAXMONEY'		              	, width:86  , summaryType: 'sum'},
			{dataIndex: 'TOT_AMT_I'   	              	, width:113 , summaryType: 'sum'},
			{dataIndex: 'SEND_DATE'		              	, width:166},
			{dataIndex: 'BILLSEQ'		              	, width:120},
			{dataIndex: 'BILLPRSN'		              	, width:100,
			 editor: Unilite.popup("CUST_BILL_PRSN_G",{
			 		textFieldName:'BILLPRSN',
			 		listeners:{
			 			onSelected: {
				 			fn:function(records, type)	{
		                    	var grdRecord = sendBillGrid.uniOpt.currentRecord;
		                    	grdRecord.set('BILLPRSN',records[0]['PRSN_NAME']);
		                    	grdRecord.set('REMAIL',records[0]['MAIL_ID']);
				 			},
				 			scope: this
				 			},
			 			onClear: {
			 				fn: function(records, type)	{
			 					var grdRecord = sendBillGrid.uniOpt.currentRecord;
						        grdRecord.set('BILLPRSN','');
						        grdRecord.set('REMAIL','');
			 				}
			 			}
			 		}
			 	
			 })
			
			},
			{dataIndex: 'HANDPHON'		              	, width:100},
			{dataIndex: 'REMAIL'			            , width:166,
			 editor: Unilite.popup("CUST_BILL_PRSN_G",{
			 		textFieldName:'REMAIL',
			 		DBtextFieldName:'MAIL_ID',
			 		listeners:{
			 			onSelected: {
				 			fn:function(records, type)	{
		                    	var grdRecord = sendBillGrid.uniOpt.currentRecord;
		                    	grdRecord.set('BILLPRSN',records[0]['PRSN_NAME']);
		                    	grdRecord.set('REMAIL',records[0]['MAIL_ID']);
				 			},
				 			scope: this
				 			},
			 			onClear: {
			 				fn: function(records, type)	{
			 					var grdRecord = sendBillGrid.uniOpt.currentRecord;
			 					grdRecord.set('BILLPRSN','');
						        grdRecord.set('REMAIL','');
			 				}
			 			}
			 		}
			 	
			 })
			},
			{dataIndex: 'EB_NUM'			            , width:120},
			{dataIndex: 'REPORT_AMEND_CD'              	, width:133},
			{dataIndex: 'BIGO'                         	, width:120},
			{dataIndex: 'REPORT_ISSUE_ID'              	, width:166},
			{dataIndex: 'REPORT_EXCEPT_YN'             	, width:166},
			{dataIndex: 'TRANSYN'		              	, width:100,hidden:true},
			{dataIndex: 'TAXRATE'                      	, width:33,hidden:true},
			{dataIndex: 'CASH'                         	, width:33,hidden:true},
			{dataIndex: 'CHECKS'                       	, width:33,hidden:true},
			{dataIndex: 'NOTE'                         	, width:33,hidden:true},
			{dataIndex: 'CREDIT'                       	, width:33,hidden:true},
			{dataIndex: 'SVENDERNO'                    	, width:33,hidden:true},
			{dataIndex: 'SCOMPANY'                     	, width:33,hidden:true},
			{dataIndex: 'SREG_ID'                      	, width:66,hidden:true},
			{dataIndex: 'SCEONAME'                     	, width:33,hidden:true},
			{dataIndex: 'SUPTAE'                       	, width:33,hidden:true},
			{dataIndex: 'SUPJONG'                      	, width:33,hidden:true},
			{dataIndex: 'SADDRESS'                     	, width:33,hidden:true},
			{dataIndex: 'SADDRESS2'                    	, width:33,hidden:true},
			{dataIndex: 'SUSER'                        	, width:33,hidden:true},
			{dataIndex: 'SDIVISION'                    	, width:33,hidden:true},
			{dataIndex: 'STELNO'                       	, width:33,hidden:true},
			{dataIndex: 'SEMAIL'                       	, width:33,hidden:true},
			{dataIndex: 'RCEONAME'                     	, width:33,hidden:true},
			{dataIndex: 'RUPTAE'                       	, width:33,hidden:true},
			{dataIndex: 'RUPJONG'                      	, width:33,hidden:true},
			{dataIndex: 'RADDRESS'                     	, width:33,hidden:true},
			{dataIndex: 'RADDRESS2'                    	, width:33,hidden:true},
			{dataIndex: 'RUSER'                        	, width:33,hidden:true},
			{dataIndex: 'RDIVISION'                    	, width:33,hidden:true},
			{dataIndex: 'RTELNO'                       	, width:33,hidden:true},
			{dataIndex: 'REVERSEYN'                    	, width:33,hidden:true},
			{dataIndex: 'SENDID'                       	, width:33,hidden:true},
			{dataIndex: 'RECVID'                       	, width:33,hidden:true},
			{dataIndex: 'DIV_CODE'                     	, width:33,hidden:true},
			{dataIndex: 'SALE_DIV_CODE'                	, width:33,hidden:true},
			{dataIndex: 'DEL_YN'                       	, width:33,hidden:true},
			{dataIndex: 'COMP_CODE'                    	, width:33,hidden:true},
			{dataIndex: 'BILL_MEM_TYPE'                	, width:120},
			{dataIndex: 'CREATE_DT'                    	, width:33,hidden:true},
			{dataIndex: 'REPORT_ETC01'                 	, width:66,hidden:true},
			{dataIndex: 'ERR_GUBUN'                    	, width:33,hidden:true}, // test false // 
			{dataIndex: 'BEFORE_PUB_NUM'               	, width:33,hidden:true},
			{dataIndex: 'ORIGINAL_PUB_NUM'             	, width:33,hidden:true},
			{dataIndex: 'PLUS_MINUS_TYPE'              	, width:33,hidden:true},
			{dataIndex: 'SEQ_GUBUN'                    	, width:33,hidden:true}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(record.get('TRANSYN_NAME') == '<span style="color:' + 'red' + ';">' + 'Error' + '</span>'){
					UniAppManager.app.fnSetErrMsg(record);	// 에러폼에 에러메시지 삽입	
				}else{
					panelSearch.setValue('TXT_ERR_MSG', '')
				}
				beforeRowIndex = rowIndex;
//				var selModel = view.getSelectionModel();
//				if(selModel.isSelected()){
//          			detailStore.loadStoreRecords(record);
//				}
				
   		  	////ROW더블클릭시 개별세금계산서 등록으로 데이터 전송및 조회되게 하는 부분 해야함.
   		  	////row클릭시 선택된 row색깔 표시 되야함.
			},
			
			onGridDblClick: function(grid, record, cellIndex, colName) {
		    	var crtLoc     = record.get("CRT_LOC");   
       			var billFlag   = record.get("BILL_FLAG");
       			
       			if(crtLoc == '5' && billFlag =='2' ){
       				return false;
       			}
       			
       			if(panelSearch){
       			}
       			
       			if(crtLoc == '1'){
       				
       			}else if(crtLoc == '3'){
       				
       			}else if(crtLoc == '5'){
       				
       			}			
			},
			beforeedit  : function( editor, e, eOpts ){
				if(e.record.phantom || !e.record.phantom ){
					if (e.record.data.CRT_LOC !='5' && e.record.data.BILL_FLAG !='2')
							if (UniUtils.indexOf(e.field,
										['REPORT_AMEND_CD','BIGO']))
							return false;
					else if (UniUtils.indexOf(e.field,
										['TRANSYN_NAME','STS','REPORT_STAT','CRT_LOC','BILL_FLAG','DT','CUSTOM_CODE'/*,
										 'RCOMPANY','RVENDERNO','RREG_ID','BILLTYPE',
										 'SUPMONEY','TAXMONEY','TOT_AMT_I','SEND_DATE','BILLSEQ','BILLPRSN','HANDPHON'
										 ,'REMAIL','EB_NUM','REPORT_ISSUE_ID','TRANSYN','TAXRATE','CASH','CHECKS'
										 ,'NOTE','CREDIT','SVENDERNO','SCOMPANY','SREG_ID','SCEONAME','SUPTAE','SUPJONG'
										 ,'SADDRESS','SADDRESS2','SUSER','SDIVISION','STELNO','SEMAIL','RCEONAME',''
										 ,'RUPTAE','RUPJONG','RADDRESS','RADDRESS2','RUSER','RDIVISION','RTELNO','REVERSEYN','SENDID'
										 ,'RECVID','DIV_CODE','SALE_DIV_CODE','DEL_YN','COMP_CODE','BILL_MEM_TYPE','CREATE_DT','REPORT_ETC01'*/
										 ,'ERR_GUBUN','BEFORE_PUB_NUM','ORIGINAL_PUB_NUM','PLUS_MINUS_TYPE','SEQ_GUBUN']))
							return false;
					}
			}
		}
	});//End of var sendBillGrid = Unilite.createGrid('ssa700ukrvGrid1', {   
	
	/* webCash Grid */
	
	
	var webCashGrid = Unilite.createGrid('Ssa700ukrvwebCashModel', {
       // for tab       
		region: 'center' ,
        layout : 'fit',
        uniOpt:{
        	onLoadSelectFirst : false,
        	useGroupSummary: false,  //그룹핑 버튼 사용 여부
        	useRowNumberer: false,
			useMultipleSorting: false, //정렬 버튼 사용 여부
			useLiveSearch: false,  //내용검색 버튼 사용 여부
			state: {
 				useState: true,   //그리드 설정 버튼 사용 여부
 				useStateList: true  //그리드 설정 목록 사용 여부
			}
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: true,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			if(record.get('TRANSYN_NAME') == '<span style="color:' + 'red' + ';">' + 'Error' + '</span>'){//Error컬럼은 선택 못하게
						return false;        			        				
        			}
        		},
	          	select: function(grid, record, index, eOpts ){
					
					var a =	panelSearch.getValue('TXT_TOTAL');
					var b = record.get('TOTL_AMT');
					panelSearch.setValue('TXT_TOTAL',a+b);
	          	},
				deselect:  function(grid, record, index, eOpts ){
														
					var a =	panelSearch.getValue('TXT_TOTAL');
					var b = record.get('TOTL_AMT');
					panelSearch.setValue('TXT_TOTAL', a-b);
        		}
        	}
        }),
    	features: [
    		{id : 'sendBillGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'sendBillGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
		store: webCashStore,
		columns: [
			{dataIndex: 'CHK'			              	, width:33  ,locked:true, hidden: true},
			{dataIndex: 'TRANSYN_NAME'	              	, width:80  ,locked:true
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
			{dataIndex: 'STAT_CODE'		            	, width:60 ,locked:true ,hidden: true},
			{dataIndex: 'STS'				            , width:93 ,locked:true},
			{dataIndex: 'CRT_LOC'			            , width:60 ,locked:true},
			{dataIndex: 'BILL_FLAG'		             	, width:93 ,locked:true},
			{dataIndex: 'TAX_TYPE'		            	, width:86 ,locked:true ,hidden: true},
			{dataIndex: 'POPS_CODE'		             	, width:66 ,locked:true },
			{dataIndex: 'REGS_DATE'		           		, width:86 ,locked:true },
			{dataIndex: 'SELR_CORP_NO'	           		, width:33 ,locked:true ,hidden: true},
			{dataIndex: 'SELR_CORP_NM'	           		, width:33 ,hidden: true},
			{dataIndex: 'SELR_CODE'                   	, width:33 ,hidden: true},
			{dataIndex: 'SELR_CEO'		        		, width:33 ,hidden: true},
			{dataIndex: 'SELR_BUSS_CONS'	            , width:66 ,hidden: true},
			{dataIndex: 'SELR_BUSS_TYPE'	           	, width:133 ,hidden: true},
			{dataIndex: 'SELR_ADDR'		           		, width:166 ,hidden: true},
			{dataIndex: 'SELR_CHRG_NM'	           		, width:33 ,hidden: true},
			{dataIndex: 'SELR_CHRG_POST'	           	, width:33 ,hidden: true},
			{dataIndex: 'SELR_CHRG_TEL'	           		, width:33 ,hidden: true},
			{dataIndex: 'SELR_CHRG_EMAIL'	           	, width:33 ,hidden: true},
			{dataIndex: 'SELR_CHRG_MOBL'		        , width:33 ,hidden: true},
			{dataIndex: 'CUSTOM_CODE'			        , width:86 ,locked:true},
			{dataIndex: 'BUYR_CORP_NM'	            	, width:160 ,locked:true},
			{dataIndex: 'BUYR_GB'			           	, width:33 ,hidden: true},
			{dataIndex: 'BUYR_CORP_NO'	            	, width:86 },
			{dataIndex: 'BUYR_CODE'                   	, width:80 },
			{dataIndex: 'BILLTYPENAME'	           		, width:100,
			/*summaryRenderer: function(value, summaryData, dataIndex ) {
              		var	rv =  "<div align='center'>건수 : " + webCashStore.getCount() + " 건</div>";		                	
            		return rv;										
	            }*/
	          summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + webCashStore.getCount() + '건','건수 : ' + webCashStore.getCount() + '건');
            }  
	            
			},
			{dataIndex: 'CHRG_AMT'		            	, width:113 , summaryType: 'sum'},
			{dataIndex: 'TAX_AMT'			            , width:86  , summaryType: 'sum'},
			{dataIndex: 'TOTL_AMT'		            	, width:113 , summaryType: 'sum'},
			{dataIndex: 'BUYR_CEO'		            	, width:86 },
			{dataIndex: 'BUYR_BUSS_CONS'	            , width:66 },
			{dataIndex: 'BUYR_BUSS_TYPE'	            , width:200 },
			{dataIndex: 'BUYR_ADDR'		            	, width:400 },
			{dataIndex: 'BUYR_CHRG_NM1'	            	, width:100 },
			{dataIndex: 'BUYR_CHRG_TEL1'	            , width:100 },
			{dataIndex: 'BUYR_CHRG_MOBL1'             	, width:100 },
			{dataIndex: 'BUYR_CHRG_EMAIL1'            	, width:166 },
			{dataIndex: 'BUYR_CHRG_NM2'	            	, width:100 },
			{dataIndex: 'BUYR_CHRG_MOBL2'             	, width:100 },
			{dataIndex: 'BUYR_CHRG_EMAIL2'            	, width:166 },
			{dataIndex: 'SEND_DATE'		            	, width:133 },
			{dataIndex: 'ISSU_SEQNO'		            , width:133 },
			{dataIndex: 'SELR_MGR_ID3'	            	, width:133 },
			{dataIndex: 'NOTE1'			            	, width:133 },
			{dataIndex: 'MODY_CODE'		            	, width:133 },
			{dataIndex: 'REQ_STAT_CODE'	            	, width:33 ,hidden: true},
			{dataIndex: 'RECP_CD'			            , width:33 ,hidden: true},
			{dataIndex: 'BILL_TYPE'		            	, width:33 ,hidden: true},
			{dataIndex: 'SND_MAL_YN'		            , width:33 ,hidden: true},
			{dataIndex: 'SND_SMS_YN'		            , width:33 ,hidden: true},
			{dataIndex: 'SND_FAX_YN'		            , width:33 ,hidden: true},
			{dataIndex: 'COMP_CODE'		            	, width:33 ,hidden: true},
			{dataIndex: 'DIV_CODE'		            	, width:33 ,hidden: true},
			{dataIndex: 'SALE_DIV_CODE'	            	, width:33 ,hidden: true},
			{dataIndex: 'DEL_YN'			            , width:33 ,hidden: true},
			{dataIndex: 'REPORT_AMEND_CD'	            , width:33 ,hidden: true},
			{dataIndex: 'BFO_ISSU_ID'                 	, width:33 ,hidden: true},
			{dataIndex: 'ERR_GUBUN'                   	, width:33 ,hidden: false},
			{dataIndex: 'ISSU_ID'                     	, width:166 },
			{dataIndex: 'BEFORE_PUB_NUM'              	, width:33 ,hidden:true},
			{dataIndex: 'ORIGINAL_PUB_NUM'            	, width:33 ,hidden:true},
			{dataIndex: 'PLUS_MINUS_TYPE'             	, width:33 ,hidden:true},
			{dataIndex: 'SEQ_GUBUN'                   	, width:33 ,hidden:true}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(record.get('TRANSYN_NAME') == '<span style="color:' + 'red' + ';">' + 'Error' + '</span>'){
					UniAppManager.app.fnSetErrMsg(record);	// 에러폼에 에러메시지 삽입	
				}else{
					panelSearch.setValue('TXT_ERR_MSG', '')
				}
				beforeRowIndex = rowIndex;
//				var selModel = view.getSelectionModel();
//				if(selModel.isSelected()){
//          			detailStore.loadStoreRecords(record);
//				}
				
   		  	////ROW더블클릭시 개별세금계산서 등록으로 데이터 전송및 조회되게 하는 부분 해야함.
   		  	////row클릭시 선택된 row색깔 표시 되야함.
			},
			beforeedit  : function( editor, e, eOpts ){
				if(e.record.phantom || !e.record.phantom ){
					if (e.record.data.CRT_LOC !='5' && e.record.data.BILL_FLAG !='2')
							if (UniUtils.indexOf(e.field,
										['REPORT_AMEND_CD','BIGO']))
							return false;
					else if (UniUtils.indexOf(e.field,
										['TRANSYN_NAME','STAT_CODE','STS','CRT_LOC','BILL_FLAG','TAX_TYPE','POPS_CODE',
										 'REGS_DATE','SELR_CORP_NO','SELR_CORP_NM','SELR_CODE',
										 'SELR_CEO','SELR_BUSS_CONS','SELR_BUSS_TYPE','SELR_ADDR','SELR_CHRG_NM','SELR_CHRG_POST','SELR_CHRG_TEL'
										 ,'SELR_CHRG_EMAIL','SELR_CHRG_MOBL','CUSTOM_CODE','BUYR_CORP_NM','BUYR_GB','BUYR_CORP_NO','BUYR_CODE'
										 ,'BILLTYPENAME','CHRG_AMT','TAX_AMT','TOTL_AMT','BUYR_CEO','BUYR_BUSS_CONS','BUYR_BUSS_TYPE','BUYR_ADDR'
										 ,'BUYR_CHRG_NM1','BUYR_CHRG_TEL1','BUYR_CHRG_MOBL1','BUYR_CHRG_NM2','BUYR_CHRG_MOBL2','BUYR_CHRG_EMAIL2','SEND_DATE',''
										 ,'ISSU_SEQNO','SELR_MGR_ID3','NOTE1','MODY_CODE','REQ_STAT_CODE','RECP_CD','BILL_TYPE','SND_MAL_YN','SND_SMS_YN'
										 ,'SND_FAX_YN','COMP_CODE','DIV_CODE','SALE_DIV_CODE','DEL_YN','BFO_ISSU_ID','ERR_GUBUN','ISSU_ID'
										 ,'BEFORE_PUB_NUM','ORIGINAL_PUB_NUM','PLUS_MINUS_TYPE','SEQ_GUBUN']))
							return false;
					}
			}
		}
	});
	
	BsaCodeInfo.gsBillYN[0].SUB_CODE == "01" ? activeGrid = sendBillGrid : activeGrid = webCashGrid;
	
	Unilite.Main( {
		borderItems:[ 
	 		 activeGrid,
			panelSearch
		],  	
		id: 'ssa700ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', true);
		},
		onQueryButtonDown: function() {         
			activeGrid.getStore().loadStoreRecords();
			
			
//			var viewLocked = activeGrid.lockedGrid.getView();
//			var viewNormal = activeGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//			viewLocked.getFeature('activeGridSubTotal').toggleSummaryRow(true);
//			viewLocked.getFeature('activeGridTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('activeGridSubTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('activeGridTotal').toggleSummaryRow(true);   
		},
//		onNewDataButtonDown:  function()	{
//			activeGrid.createRow();
//		},
		fnSetErrMsg: function(record) {	// 에러폼에 에러메시지 삽입		
			if(record.get('ERR_GUBUN') == '1'){
				panelSearch.setValue('TXT_ERR_MSG', Msg.fStMsgS0092);
			}
			if(record.get('ERR_GUBUN') == '2'){
				panelSearch.setValue('TXT_ERR_MSG', Msg.fStMsgS0093);
			}
			if(record.get('ERR_GUBUN') == '3'){
				panelSearch.setValue('TXT_ERR_MSG', Msg.fStMsgS0094);
			}
			if(record.get('ERR_GUBUN') == '4'){
				panelSearch.setValue('TXT_ERR_MSG', Msg.fStMsgS0095);
			}
			if(record.get('ERR_GUBUN') == '5'){
				panelSearch.setValue('TXT_ERR_MSG', '공급 받는자 정보를 확인하세요.(업종, 업태)');
			}	
		},
		fnSendBillColSet: function(records) {	//센드빌 전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
			Ext.each(records, function(record) {
				//공급자 업체명, 전화번호, 이메일주소
				if(Ext.isEmpty(record.get('SCOMPANY')) || Ext.isEmpty(record.get('SCEONAME')) || Ext.isEmpty(record.get('SUPTAE')) || Ext.isEmpty(record.get('SUPJONG')) || Ext.isEmpty(record.get('SADDRESS'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '1');
				}
				//공급자 담당자명, 전화번호, 이메일
				else if(Ext.isEmpty(record.get('SUSER')) || Ext.isEmpty(record.get('STELNO')) || Ext.isEmpty(record.get('SEMAIL'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '2');
				}
				//공급 받는자 업체명, 대표자명, 주소
				else if(Ext.isEmpty(record.get('RCOMPANY')) || Ext.isEmpty(record.get('RCEONAME')) || Ext.isEmpty(record.get('RADDRESS'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '3');
				}
				//공급 받는자 담당자명, 전화번호, 이메일주소
				else if(Ext.isEmpty(record.get('RUSER')) || Ext.isEmpty(record.get('RTELNO')) || Ext.isEmpty(record.get('REMAIL'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '4');
				}
				//공급 받는자 업종, 업태
				else if(Ext.isEmpty(record.get('RUPTAE')) || Ext.isEmpty(record.get('RUPJONG'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '5');
				}
			});
		},
		fnWebCashColSet: function(records) {	//웹캐시 전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
			Ext.each(records, function(record) {
				//공급자 업체명, 대표자명, 업태, 업종, 주소
				if(Ext.isEmpty(record.get('SELR_CORP_NM')) || Ext.isEmpty(record.get('SELR_CEO')) || Ext.isEmpty(record.get('SELR_BUSS_CONS'))
				   || Ext.isEmpty(record.get('SELR_BUSS_TYPE'))  || Ext.isEmpty(record.get('SELR_ADDR'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '1');
				}
				//공급 받는자 업체명, 대표자명, 주소
				else if(Ext.isEmpty(record.get('BUYR_BUSS_CONS')) || Ext.isEmpty(record.get('BUYR_CEO')) || Ext.isEmpty(record.get('BUYR_ADDR'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '3');
				}
				//공급 받는자 담당자명, 전화번호, 이메일주소
			    else if(Ext.isEmpty(record.get('BUYR_CHRG_NM1')) || Ext.isEmpty(record.get('BUYR_CHRG_TEL1')) || Ext.isEmpty(record.get('BUYR_CHRG_EMAIL1'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '4');
				}				
			});
		}
	});//End of Unilite.Main( {
};

</script>