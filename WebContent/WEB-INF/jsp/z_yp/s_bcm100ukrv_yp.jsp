<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bcm100ukrv_yp">
	<t:ExtComboStore comboType="AU" comboCode="B015" />					<!-- 거래처구분		-->
	<t:ExtComboStore comboType="AU" comboCode="B016" />					<!-- 법인/개인		-->
	<t:ExtComboStore comboType="AU" comboCode="B012" />					<!-- 국가코드		-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />					<!-- 기준화폐		-->
	<t:ExtComboStore comboType="AU" comboCode="B017" />					<!-- 원미만계산		-->
	<t:ExtComboStore comboType="AU" comboCode="A022" />					<!-- 계산서종류		-->
	<t:ExtComboStore comboType="AU" comboCode="B038" />					<!-- 결제방법		-->
	<t:ExtComboStore comboType="AU" comboCode="B034" />					<!-- 결제조건		-->
	<t:ExtComboStore comboType="AU" comboCode="B033" />					<!-- 마감종류		-->
	<t:ExtComboStore comboType="AU" comboCode="B010" />					<!-- 사용여부		-->
	<t:ExtComboStore comboType="AU" comboCode="B030" />					<!-- 세액포함여부		-->
	<t:ExtComboStore comboType="AU" comboCode="B051" />					<!-- 세액계산법		-->
	<t:ExtComboStore comboType="AU" comboCode="B055" />					<!-- 거래처분류		-->
	<t:ExtComboStore comboType="AU" comboCode="B056" />					<!-- 지역구분		-->
	<t:ExtComboStore comboType="AU" comboCode="B057" />					<!-- 미수관리방법		-->
	<t:ExtComboStore comboType="AU" comboCode="S010" />					<!-- 주담당자		-->
	<t:ExtComboStore comboType="AU" comboCode="B062" />					<!-- 카렌더타입		-->
	<t:ExtComboStore comboType="AU" comboCode="B086" />					<!-- 카렌더타입		-->
	<t:ExtComboStore comboType="AU" comboCode="S051" />					<!-- 전자문서구분		-->
	<t:ExtComboStore comboType="AU" comboCode="A020" />					<!-- 전자문서주담당여부	-->
	<t:ExtComboStore comboType="AU" comboCode="B109" />					<!-- 유통채널		-->
	<t:ExtComboStore comboType="AU" comboCode="B232" />					<!-- 신/구 주소구분	-->
	<t:ExtComboStore comboType="AU" comboCode="B131" />					<!-- 예/아니오		-->
	<t:ExtComboStore comboType="AU" comboCode="Z001" />					<!-- 인증서 구분		-->
	<t:ExtComboStore comboType="AU" comboCode="Z003" />					<!-- 출하회		-->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
var protocol =	("https:" == document.location.protocol)? "https" : "http";
if(protocol == "https")	{
	document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
}else {
	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
}
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >

function appMain() {
	//인증서 이미지 등록에 사용되는 변수 선언
	var uploadWin;				//인증서 업로드 윈도우
	var uploadFarmHouseWin;             //인증서 업로드 윈도우
	var photoWin;				//인증서 이미지 보여줄 윈도우
	var fid = '';				//인증서 ID
	var gsNeedPhotoSave	= false;
	var gsDc = 0;               //이미지 dc용
	var gsChkFlag = 'N';               //약어 중복체크 여부
	var BsaCodeInfo		= {
		gsHiddenField: '${gsHiddenField}'
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bcm100ukrv_ypService.selectList',
			update	: 's_bcm100ukrv_ypService.updateDetail',
			create	: 's_bcm100ukrv_ypService.insertDetail',
			destroy	: 's_bcm100ukrv_ypService.deleteDetail',
			syncAll	: 's_bcm100ukrv_ypService.saveAll'
		}
	});

	//SUB 프록시 (BCM130T - 계좌정보)
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bcm100ukrv_ypService.getBankBookInfo',
			update	: 's_bcm100ukrv_ypService.updateList',
			create	: 's_bcm100ukrv_ypService.insertList',
			destroy	: 's_bcm100ukrv_ypService.deleteList',
			syncAll	: 's_bcm100ukrv_ypService.saveAll2'
		}
	});

	//SUB 프록시 (BCM120T - 전자문서정보)
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bcm100ukrv_ypService.getSubInfo3',
			update	: 's_bcm100ukrv_ypService.updateList3',
			create	: 's_bcm100ukrv_ypService.insertList3',
			destroy : 's_bcm100ukrv_ypService.deleteList3',
			syncAll : 's_bcm100ukrv_ypService.saveAll3'
		}
	});

	//SUB 프록시 (S_BCM100T_YP - 인증서정보)
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bcm100ukrv_ypService.getCertInfo',
			update	: 's_bcm100ukrv_ypService.certInfoUpdate',
			create	: 's_bcm100ukrv_ypService.certInfoInsert',
			destroy : 's_bcm100ukrv_ypService.certInfoDelete',
			syncAll : 's_bcm100ukrv_ypService.saveAll4'
		}
	});

	//SUB 프록시 (S_BCM101T_YP - 농가이력 재배품목1)
    var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 's_bcm100ukrv_ypService.getGrowthList1',
            update  : 's_bcm100ukrv_ypService.growthUpdateList1',
            create  : 's_bcm100ukrv_ypService.growthInsertList1',
            destroy : 's_bcm100ukrv_ypService.growthDeleteList1',
            syncAll : 's_bcm100ukrv_ypService.saveAll5'
        }
    });

    //SUB 프록시 (S_BCM102T_YP - 농가이력 재배품목2)
    var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 's_bcm100ukrv_ypService.getGrowthList2',
            update  : 's_bcm100ukrv_ypService.growthUpdateList2',
            create  : 's_bcm100ukrv_ypService.growthInsertList2',
            destroy : 's_bcm100ukrv_ypService.growthDeleteList2',
            syncAll : 's_bcm100ukrv_ypService.saveAll6'
        }
    });

    //SUB 프록시 (S_BCM105T_YP - 교육참석현황)
    var directProxy7 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 's_bcm100ukrv_ypService.getEduList',
            update  : 's_bcm100ukrv_ypService.eduUpdateList',
            create  : 's_bcm100ukrv_ypService.eduInsertList',
            destroy : 's_bcm100ukrv_ypService.eduDeleteList',
            syncAll : 's_bcm100ukrv_ypService.saveAll7'
        }
    });



	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('s_bcm100ukrv_ypModel', {
		// pkGen : user, system(default)
		 fields: [
			{name: 'CUSTOM_CODE'		,text:'거래처코드'			,type:'string'	/*, isPk:true, pkGen:'user'*/	, readOnly: true, defaultValue: Msg.sMSR226},
			{name: 'CUSTOM_TYPE'		,text:'구분'				,type:'string'	, comboType:'AU',comboCode:'B015' ,allowBlank: false, defaultValue:'1'},
			{name: 'CUSTOM_NAME'		,text:'거래처명'			,type:'string'	, allowBlank:false},
			{name: 'CUSTOM_NAME1'		,text:'거래처명1'			,type:'string'	},
			{name: 'CUSTOM_NAME2'		,text:'거래처명2'			,type:'string'	},
			{name: 'CUSTOM_FULL_NAME'	,text:'거래처명(전명)'		,type:'string'	, allowBlank:false},
			{name: 'NATION_CODE'		,text:'국가코드'			,type:'string'	, comboType:'AU',comboCode:'B012'},
			{name: 'COMPANY_NUM'		,text:'사업자번호'			,type:'string'	},
			{name: 'TOP_NUM'			,text:'주민번호'			,type:'string'	},
			{name: 'TOP_NAME'			,text:'대표자'				,type:'string'	},
			{name: 'BUSINESS_TYPE'		,text:'법인/구분'			,type:'string'	, comboType:'AU',comboCode:'B016'},
			{name: 'USE_YN'				,text:'사용유무'			,type:'string'	, comboType:'AU',comboCode:'B010', defaultValue:'Y'},
			{name: 'COMP_TYPE'			,text:'업태'				,type:'string'	},
			{name: 'COMP_CLASS'			,text:'업종'				,type:'string'	},
			{name: 'AGENT_TYPE'			,text:'거래처분류'			,type:'string'	, comboType:'AU',comboCode:'B055' ,allowBlank: false, defaultValue:'1'},
			{name: 'AGENT_TYPE2'		,text:'거래처분류2'			,type:'string'	},
			{name: 'AGENT_TYPE3'		,text:'거래처분류3'			,type:'string'	},
			{name: 'AREA_TYPE'			,text:'지역'				,type:'string'	, comboType:'AU',comboCode:'B056'},
			{name: 'DELIVERY_UNION'			,text:'출하회'				,type:'string'	, comboType:'AU',comboCode:'Z003'},
			{name: 'ZIP_CODE'			,text:'우편번호'			,type:'string'	},
			{name: 'ADDR1'				,text:'주소1'				,type:'string'	},
			{name: 'ADDR2'				,text:'주소2'				,type:'string'	},
			{name: 'TELEPHON'			,text:'연락처'				,type:'string'	},
			{name: 'FAX_NUM'			,text:'FAX번호'			,type:'string'	},
			{name: 'HTTP_ADDR'			,text:'홈페이지'			,type:'string'	},
			{name: 'MAIL_ID'			,text:'E-mail'			,type:'string'	},
			{name: 'WON_CALC_BAS'		,text:'원미만계산'			,type:'string'	, comboType:'AU',comboCode:'B017'},
			{name: 'START_DATE'			,text:'거래시작일'			,type:'uniDate'	, allowBlank: false},
			{name: 'STOP_DATE'			,text:'거래중단일'			,type:'uniDate'	},
			{name: 'TO_ADDRESS'			,text:'송신주소'			,type:'string'	},
			{name: 'TAX_CALC_TYPE'		,text:'세액계산법'			,type:'string'	, comboType:'AU',comboCode:'B051', defaultValue:'1'},
			{name: 'RECEIPT_DAY'		,text:'결제기간'			,type:'string'	, comboType:'AU',comboCode:'B034'},
			{name: 'MONEY_UNIT'			,text:'기준화폐'			,type:'string'	, comboType:'AU',comboCode:'B004'},
			{name: 'TAX_TYPE'			,text:'세액포함여부'			,type:'string'	, comboType:'AU',comboCode:'B030', defaultValue:'1'},
			{name: 'BILL_TYPE'			,text:'계산서유형'			,type:'string'	, comboType:'AU',comboCode:'A022'},
			{name: 'SET_METH'			,text:'결제방법'			,type:'string'	, comboType:'AU',comboCode:'B038'},
			{name: 'VAT_RATE'			,text:'세율'				,type:'uniFC'	, defaultValue:0},
			{name: 'TRANS_CLOSE_DAY'	,text:'마감종류'			,type:'string'	, comboType:'AU',comboCode:'B033'},
			{name: 'COLLECT_DAY'		,text:'수금일'				,type:'integer' , defaultValue:1, minValue:1},
			{name: 'CREDIT_YN'			,text:'여신적용여부'			,type:'string'	, comboType:'AU',comboCode:'B010', defaultValue: 'N'},
			{name: 'TOT_CREDIT_AMT'		,text:'여신(담보)액'			,type:'uniPrice'	},
			{name: 'CREDIT_AMT'			,text:'신용여신액'			,type:'uniPrice'	},
			{name: 'CREDIT_YMD'			,text:'신용여신만료일'			,type:'uniDate'	},
			{name: 'COLLECT_CARE'		,text:'미수관리방법'			,type:'string'	, comboType:'AU',comboCode:'B057', defaultValue:'1'},
			{name: 'BUSI_PRSN'			,text:'주담당자'			,type:'string'	, comboType:'AU',comboCode:'S010'},
			{name: 'CAL_TYPE'			,text:'카렌더타입'			,type:'string'	, comboType:'AU',comboCode:'B062'},
			{name: 'REMARK'				,text:'비고'				,type:'string'	},
			{name: 'MANAGE_CUSTOM'		,text:'집계거래처'			,type:'string'	},
			{name: 'MCUSTOM_NAME'		,text:'집계거래처명'			,type:'string'	},
			{name: 'COLLECTOR_CP'		,text:'수금거래처'			,type:'string'	},
			{name: 'COLLECTOR_CP_NAME'	,text:'수금거래처명'			,type:'string'	},
			{name: 'BANK_CODE'			,text:'금융기관'			,type:'string'	},
			{name: 'BANK_NAME'			,text:'금융기관명'			,type:'string'	},
			{name: 'BANKBOOK_NUM'		,text:'계좌번호'			,type:'string'	},
			{name: 'BANKBOOK_NAME'		,text:'예금주'				,type:'string'	},
			{name: 'CUST_CHK'			,text:'거래처변경여부'			,type:'string'	},
			{name: 'SSN_CHK'			,text:'주민번호변경여부'		,type:'string'	},
			{name: 'UPDATE_DB_USER'		,text:'작성자'				,type:'string'	},
			{name: 'UPDATE_DB_TIME'		,text:'작성시간'			,type:'uniDate'	},
			{name: 'PURCHASE_BANK'		,text:'구매카드은행'			,type:'string'	},
			{name: 'PURBANKNAME'		,text:'구매카드은행명'			,type:'string'	},
			{name: 'BILL_PRSN'			,text:'전자문서담당자'			,type:'string'	},
			{name: 'HAND_PHON'			,text:'핸드폰번호'			,type:'string'	},
			{name: 'BILL_MAIL_ID'		,text:'전자문서E-mail'		,type:'string'	},
			{name: 'BILL_PRSN2'			,text:'전자문서담당자2'		,type:'string'	},
			{name: 'HAND_PHON2'			,text:'핸드폰번호2'			,type:'string'	},
			{name: 'BILL_MAIL_ID2'		,text:'전자문서E-mail2'		,type:'string'	},
			{name: 'BILL_MEM_TYPE'		,text:'전자세금계산서'			,type:'string'	},
			{name: 'ADDR_TYPE'			,text:'신/구주소 구분'		,type:'string'	, comboType:'AU',comboCode:'B232'},
			{name: 'COMP_CODE'			,text:'COMP_CODE'		,type:'string'	, defaultValue: UserInfo.compCode},
			{name: 'CHANNEL'			,text:'약어'				,type:'string'	, maxLength: 2, editable: false},
			{name: 'BILL_CUSTOM'		,text:'매출/계산서거래처코드'	,type:'string'	},
			{name: 'BILL_CUSTOM_NAME'	,text:'매출/계산서거래처'		,type:'string'	},
			{name: 'CREDIT_OVER_YN'		,text:'CREDIT_OVER_YN'	,type:'string'	},
			{name: 'Flag'				,text:'Flag'			,type:'string'	},
			{name: 'DEPT_CODE'			,text:'관련부서'			,type:'string'	},
			{name: 'DEPT_NAME'			,text:'관련부서명'			,type:'string'	},
			{name: 'BILL_PUBLISH_TYPE'	,text:'전자세금계산서발행유형' 	,type:'string'	, defaultValue:'1'}, //임시 2016.11.07
			// 추가(극동)
			{name: 'R_PAYMENT_YN'		,text:'정기결제여부'			,type:'string'	, allowBlank: false , comboType:'AU',comboCode:'B010', defaultValue: 'N' },
//			{name: 'DELIVERY_METH'		,text:'운송방법'			,type:'string'	},
			// 추가(양평공사)
			{name: 'PURCH_TYPE'			,text:'발주형태'			,type:'string'	, comboType:'AU',comboCode:'B051'},
			{name: 'ITEM_NAME'           ,text:'주요품목'           ,type:'string'  },
			{name: 'CULTI_AREA'           ,text:'재배면적'           ,type:'int'  },
			{name: 'CULTI_ADDR'           ,text:'재배지'           ,type:'string'  },
			{name: 'TYPE'						,text:'인증구분'			,type:'string'	, allowBlank: true , comboType:'AU',comboCode:'Z001', defaultValue: 'N' },
			{name: 'CERT_NO'           ,text:'인증번호'           ,type:'string'  },
			{name: 'CERT_DATE'           ,text:'인증일자'           ,type:'uniDate'  },
			{name: 'APLY_START_DATE'           ,text:'인증시작일'           ,type:'uniDate'  },
			{name: 'APLY_END_DATE'           ,text:'인증종료일'           ,type:'uniDate'  },
			{name: 'CERT_ORG'           ,text:'인증기관'           ,type:'string'  },
			{name: 'CERT_COUNT'           ,text:'인증서수'           ,type:'int'  }
		]
	});

	//SUB 모델 (BCM130T - 계좌정보)
	Unilite.defineModel('s_bcm100ukrv_ypModel2', {
		fields: [
			{name: 'COMPC_CODE'			,text: '법인코드'			,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '거래처코드'			,type: 'string'},
			{name: 'SEQ'				,text: '순번'				,type: 'int'},
			{name: 'BOOK_CODE'			,text: '계좌코드'			,type: 'string'},
			{name: 'BOOK_NAME'			,text: '계좌명'			,type: 'string'},
			{name: 'BANK_CODE'			,text: '은행코드'			,type: 'string'},
			{name: 'BANK_NAME'			,text: '은행명'			,type: 'string'},
			{name: 'BANKBOOK_NUM'		,text: '계좌번호(DB)'		,type: 'string'},
			{name: 'BANKBOOK_NUM_EXPOS'	,text: '계좌번호'			,type: 'string'	,defaultValue: '***************'},
			{name: 'BANKBOOK_NAME'		,text: '예금주'			,type: 'string'},
			{name: 'MAIN_BOOK_YN'		,text: '주지급계좌'			,type: 'string'	, comboType:'AU',comboCode:'B131'}
		]
	});

	//SUB 모델 (BCM120T - 전자문서정보)
	Unilite.defineModel('s_bcm100ukrv_ypModel3', {
		fields: [
			{name: 'COMP_CODE'			,text: '법인코드'			,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '거래처코드'			,type: 'string'},
			{name: 'SEQ'				,text: '순번'				,type: 'int'},
			{name: 'PRSN_NAME'			,text: '담당자명'			,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'			,type: 'string'},
			{name: 'HAND_PHON'			,text: '핸드폰번호'			,type: 'string'},
			{name: 'TELEPHONE_NUM1'		,text: '전화번호1'			,type: 'string'},
			{name: 'TELEPHONE_NUM2'		,text: '전화번호2'			,type: 'string'},
			{name: 'FAX_NUM'			,text: '팩스번호'			,type: 'string'},
			{name: 'MAIL_ID'			,text: 'E-MAIL주소'		,type: 'string'	, allowBlank:false},
			{name: 'BILL_TYPE'			,text: '전자문서구분'		,type: 'string'	, comboType:'AU',comboCode:'S051'},
			{name: 'MAIN_BILL_YN'		,text: '전자문서담당자여부'	,type: 'string'	, allowBlank: false		, comboType:'AU',comboCode:'A020'},
			{name: 'REMARK'				,text: '비고'				,type: 'string'}
		]
	 });

	//SUB 모델 (S_BCM100T_YP - 인증서정보)
	Unilite.defineModel('s_bcm100ukrv_ypModel4', {
		fields: [
			{name: 'COMP_CODE'			,text: '법인코드'			,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '거래처코드'			,type: 'string'},
			{name: 'TYPE'				,text: '구분'				,type: 'string'		, allowBlank: false		, comboType: 'AU'	, comboCode: 'Z001'},
			{name: 'CERT_NO'			,text: '인증번호'			,type: 'string'		, allowBlank: false},
			{name: 'CERT_DATE'			,text: '인증일자'			,type: 'uniDate'	, allowBlank: false},
			{name: 'APLY_START_DATE'	,text: '시작'				,type: 'uniDate'	, allowBlank: false},
			{name: 'APLY_END_DATE'		,text: '종료'				,type: 'uniDate'	, allowBlank: false},
			{name: 'CERT_ORG'			,text: '인증기관'			,type: 'string'		, allowBlank: false},
			{name: 'REMARK'				,text: '비고'				,type: 'string'},
			{name: 'CERT_FILE'			,text: '파일명'			,type: 'string'},
			{name: 'FILE_ID'			,text: '저장된 파일명'		,type: 'string'},
			{name: 'FILE_PATH'			,text: '저장된 파일경로'		,type: 'string'},
			{name: 'FILE_EXT'			,text: '저장된 파일확장자'		,type: 'string'}
		]
	 });

	//SUB 모델 (S_BCM101T_YP - 농가이력 재배품목1)
    Unilite.defineModel('s_bcm100ukrv_ypModel5', {
        fields: [
            {name: 'DOC_ID'           ,text: 'DOC_ID'        ,type: 'string'},
            {name: 'CUSTOM_CODE'      ,text: '거래처코드'       ,type: 'string'},
            {name: 'ITEM_CODE'        ,text: '품목코드'        ,type: 'string'},
            {name: 'ITEM_NAME'        ,text: '품명'           ,type: 'string'},
            {name: 'DVLY_SEASON'      ,text: '출하시기'        ,type: 'string'},
            {name: 'CULTI_AREA'       ,text: '면적'           ,type: 'int'},
            {name: 'REMARK'           ,text: '비고'           ,type: 'string'}
        ]
     });

     //SUB 모델 (S_BCM102T_YP - 농가이력 재배품목2)
    Unilite.defineModel('s_bcm100ukrv_ypModel6', {
        fields: [
            {name: 'DOC_ID'           ,text: 'DOC_ID'        ,type: 'string'},
            {name: 'CUSTOM_CODE'      ,text: '거래처코드'       ,type: 'string'},
            {name: 'ITEM_CODE'        ,text: '품목코드'        ,type: 'string'},
            {name: 'ITEM_NAME'        ,text: '품명'           ,type: 'string', allowBlank: false},
            {name: 'HIS_DATE'         ,text: '년.월.일'       ,type: 'uniDate', allowBlank: false},
            {name: 'HIS_CONTENT'      ,text: '출하내용'        ,type: 'string'},
            {name: 'CONFIRM_YN'       ,text: '확인'           ,type: 'string'},
            {name: 'REMARK'           ,text: '비고'           ,type: 'string'}
        ]
     });

     //SUB 모델 (S_BCM105T_YP - 농가이력 교육참석현황)
    Unilite.defineModel('s_bcm100ukrv_ypModel7', {
        fields: [
            {name: 'DOC_ID'            ,text: 'DOC_ID'        ,type: 'string'},
            {name: 'CUSTOM_CODE'       ,text: '거래처코드'       ,type: 'string'},
            {name: 'EDU_TITLE'         ,text: '교육명'          ,type: 'string'},
            {name: 'EDU_FR_DATE'       ,text: '교육시작일자'      ,type: 'uniDate'},
            {name: 'EDU_TO_DATE'       ,text: '교육종료일자'      ,type: 'uniDate'},
            {name: 'EDU_PLACE'         ,text: '교육장소'         ,type: 'string'},
            {name: 'EDU_CONTENTS'      ,text: '교육내용'         ,type: 'string'},
            {name: 'EDU_GUBUN'         ,text: '교육구분'         ,type: 'string'},
            {name: 'EDU_ORGAN'         ,text: '교육기관'         ,type: 'string'},
            {name: 'REMARK'            ,text: '비고'            ,type: 'string'}
        ]
     });




	/* Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_bcm100ukrv_ypMasterStore',{
		model	: 's_bcm100ukrv_ypModel',
		autoLoad: false,
		uniOpt	: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : true			// prev | next 버튼 사용
		},

		proxy	: directProxy,

		// Store 관련 BL 로직
		// 검색 조건을 통해 DB에서 데이타 읽어 오기
		loadStoreRecords : function()	{
			var param= Ext.getCmp('s_bcm100ukrv_ypSearchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},

		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();

			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var lists		= [].concat(toUpdate, toCreate);
			//약어(CHANNEL) 관련 로직 자동채번으로 변경하면서 JAVA, XML에서 처리
//			var errFlag		= 'N'
//			Ext.each(lists, function(rec,i) {
//                if((rec.get('CUSTOM_TYPE') == '1' || rec.get('CUSTOM_TYPE') == '2') && Ext.isEmpty(rec.get('CHANNEL'))) {
//                    alert('구분이 공통 또는 매입 일 시 약어는 필수입니다.');
//                    errFlag = 'Y';
//                    return false;
//                }
//			});
//			if(errFlag == 'Y') {
//                return false;
//            }
//			Ext.each(lists, function(checkList1,i) {
//				Ext.each(lists, function(checkList2,i) {
//					if(checkList1.get('CUSTOM_CODE') != checkList2.get('CUSTOM_CODE')) {
//						if(checkList1.get('CHANNEL') == checkList2.get('CHANNEL') && checkList1.get('CHANNEL') != '') {
//							errFlag = 'Y';
//							alert('다른 거래처에 동일한 약어는 사용할 수 없습니다.\n 거래처코드[' + checkList1.get('CUSTOM_CODE') +', ' + checkList2.get('CUSTOM_CODE') + ']');
//							return false;
//						}
//						if(errFlag == 'Y') {
//							return false;
//						}
//					}
//				});
//			});
//			if(errFlag == 'Y') {
//				return false;
//			}
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			load: function(store, records, successful, eOpts) {
				if(Ext.isEmpty(records)){
					tab.down('#s_bcm100ukrv_ypTab3').setDisabled(true);
				}else{
				    tab.down('#s_bcm100ukrv_ypTab3').setDisabled(false);
				    farmHouseForm.setActiveRecord(records[0]);
                    var activeTabId = tab.getActiveTab().getItemId();
                    if(activeTabId == 's_bcm100ukrv_ypTab3')    {
                       farmHouseForm.down('#custImg').getEl().dom.src=CPATH+'/uploads/farmHouseImages/'+ farmHouseForm.getValue('CUSTOM_CODE') + '?_dc=' + gsDc;
                       gsDc++
                    }
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
//				detailForm.setActiveRecord(record);
			},
			metachange:function( store, meta, eOpts ){

			}
		} // listeners
	});

	var accountStore = Unilite.createStore('s_bcm100ukrv_ypAccountStore',{
		model: 's_bcm100ukrv_ypModel2',
		autoLoad: false,
		uniOpt : {
			isMaster: false,		// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},

		proxy: directProxy2,

		loadStoreRecords : function(getCustomCode)	{
			var param= Ext.getCmp('s_bcm100ukrv_ypSearchForm').getValues();
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
				accountGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},

			metachange:function( store, meta, eOpts ){
			}
		},

		 _onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save', true);
		 }, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
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
			var toolbar = accountGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}

	});

	var electroInfoStore = Unilite.createStore('s_bcm100ukrv_ypElectroInfoStore',{
		model	: 's_bcm100ukrv_ypModel3',
		autoLoad: false,
		uniOpt	: {
			isMaster: false,		// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:true,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},

		proxy: directProxy3,

		loadStoreRecords : function(getCustomCode){
			var param= Ext.getCmp('s_bcm100ukrv_ypSearchForm').getValues();
			param.CUSTOM_CODE = getCustomCode

			console.log( param );
			this.load({
				params : param
			});
		},

		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	 {
				this.syncAllDirect(config);
			}else {
				electroInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ){
			},
			metachange:function( store, meta, eOpts ){
			}
		},

		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save3', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save3', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts )	{
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0){
				this.setToolbarButtons(['sub_delete3'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete3':false}});
			}else {
				if(this.uniOpt.deletable)	{
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

		setToolbarButtons: function( btnName, state) {
			var toolbar = electroInfoGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});

	//인증서정보 - S_BCM100T_YP
	var certInfoStore = Unilite.createStore('s_bcm100ukrv_ypCertInfoStore',{
		model	: 's_bcm100ukrv_ypModel4',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},

		proxy: directProxy4,

		loadStoreRecords : function(getCustomCode){
			var param= Ext.getCmp('s_bcm100ukrv_ypSearchForm').getValues();
			param.CUSTOM_CODE = getCustomCode

			console.log( param );
			this.load({
				params : param
			});
		},

		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	 {
				config = {
					success	: function(batch, option) {
						if(gsNeedPhotoSave){
							fnPhotoSave();
						}
					}
				};
				this.syncAllDirect(config);
			}else {
				certInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ){
			},
			metachange:function( store, meta, eOpts ){
			}
		},

		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save4', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save4', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts )	{
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0){
				this.setToolbarButtons(['sub_delete4'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':false}});
			}else {
				if(this.uniOpt.deletable)	{
					this.setToolbarButtons(['sub_delete4'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':true}});
				}
			}
			if(store.isDirty()) {
				this.setToolbarButtons(['sub_save4'], true);
			}else {
				this.setToolbarButtons(['sub_save4'], false);
			}
		},

		setToolbarButtons: function( btnName, state)	 {
			var toolbar = certInfoGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});


	//농가이력 재배품목1 스토어 - S_BCM101T_YP
    var growthStore1 = Unilite.createStore('s_bcm100ukrv_ypGrowthStore1',{
        model   : 's_bcm100ukrv_ypModel5',
        autoLoad: false,
        uniOpt  : {
            isMaster    : false,        // 상위 버튼 연결
            editable    : true,         // 수정 모드 사용
            deletable   : true,         // 삭제 가능 여부
            useNavi     : false         // prev | next 버튼 사용
        },

        proxy: directProxy5,

        loadStoreRecords : function(getCustomCode){
            var param= Ext.getCmp('s_bcm100ukrv_ypSearchForm').getValues();
            param.CUSTOM_CODE = getCustomCode

            console.log( param );
            this.load({
                params : param
            });
        },

        saveStore : function(config) {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);
            if(inValidRecs.length == 0 )     {
                config = {
                    success : function(batch, option) {
                        if(gsNeedPhotoSave){
                            fnPhotoSave();
                        }
                    }
                };
                this.syncAllDirect(config);
            }else {
                electroInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },

        listeners: {
            update:function( store, record, operation, modifiedFieldNames, eOpts ){
            },
            metachange:function( store, meta, eOpts ){
            }
        },

        _onStoreUpdate: function (store, eOpt) {
            console.log("Store data updated save btn enabled !");
            this.setToolbarButtons('sub_save5', true);
        }, // onStoreUpdate

        _onStoreLoad: function ( store, records, successful, eOpts ) {
            console.log("onStoreLoad");
            if (records) {
                this.setToolbarButtons('sub_save5', false);
            }
        },
        _onStoreDataChanged: function( store, eOpts )   {
            console.log("_onStoreDataChanged store.count() : ", store.count());
            if(store.count() == 0){
                this.setToolbarButtons(['sub_delete5'], false);
                Ext.apply(this.uniOpt.state, {'btn':{'sub_delete5':false}});
            }else {
                if(this.uniOpt.deletable)   {
                    this.setToolbarButtons(['sub_delete5'], true);
                    Ext.apply(this.uniOpt.state, {'btn':{'sub_delete5':true}});
                }
            }
            if(store.isDirty()) {
                this.setToolbarButtons(['sub_save5'], true);
            }else {
                this.setToolbarButtons(['sub_save5'], false);
            }
        },

        setToolbarButtons: function( btnName, state)     {
            var toolbar = growthGrid1.getDockedItems('toolbar[dock="top"]');
            var obj = toolbar[0].getComponent(btnName);
            if(obj) {
                (state) ? obj.enable():obj.disable();
            }
        }
    });

    //농가이력 재배품목2 스토어 - S_BCM102T_YP
    var growthStore2 = Unilite.createStore('s_bcm100ukrv_ypGrowthStore2',{
        model   : 's_bcm100ukrv_ypModel6',
        autoLoad: false,
        uniOpt  : {
            isMaster    : false,        // 상위 버튼 연결
            editable    : true,         // 수정 모드 사용
            deletable   : true,         // 삭제 가능 여부
            useNavi     : false         // prev | next 버튼 사용
        },

        proxy: directProxy6,

        loadStoreRecords : function(getCustomCode){
            var param= Ext.getCmp('s_bcm100ukrv_ypSearchForm').getValues();
            param.CUSTOM_CODE = getCustomCode

            console.log( param );
            this.load({
                params : param
            });
        },

        saveStore : function(config) {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);
            if(inValidRecs.length == 0 )     {
                config = {
                    success : function(batch, option) {
                        if(gsNeedPhotoSave){
                            fnPhotoSave();
                        }
                    }
                };
                this.syncAllDirect(config);
            }else {
                electroInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },

        listeners: {
            update:function( store, record, operation, modifiedFieldNames, eOpts ){
            },
            metachange:function( store, meta, eOpts ){
            }
        },

        _onStoreUpdate: function (store, eOpt) {
            console.log("Store data updated save btn enabled !");
            this.setToolbarButtons('sub_save6', true);
        }, // onStoreUpdate

        _onStoreLoad: function ( store, records, successful, eOpts ) {
            console.log("onStoreLoad");
            if (records) {
                this.setToolbarButtons('sub_save6', false);
            }
        },
        _onStoreDataChanged: function( store, eOpts )   {
            console.log("_onStoreDataChanged store.count() : ", store.count());
            if(store.count() == 0){
                this.setToolbarButtons(['sub_delete6'], false);
                Ext.apply(this.uniOpt.state, {'btn':{'sub_delete6':false}});
            }else {
                if(this.uniOpt.deletable)   {
                    this.setToolbarButtons(['sub_delete6'], true);
                    Ext.apply(this.uniOpt.state, {'btn':{'sub_delete6':true}});
                }
            }
            if(store.isDirty()) {
                this.setToolbarButtons(['sub_save6'], true);
            }else {
                this.setToolbarButtons(['sub_save6'], false);
            }
        },

        setToolbarButtons: function( btnName, state)     {
            var toolbar = growthGrid2.getDockedItems('toolbar[dock="top"]');
            var obj = toolbar[0].getComponent(btnName);
            if(obj) {
                (state) ? obj.enable():obj.disable();
            }
        }
    });


     //교육참석현황 스토어 - S_BCM105T_YP
    var eduStore = Unilite.createStore('s_bcm100ukrv_ypEduStore',{
        model   : 's_bcm100ukrv_ypModel7',
        autoLoad: false,
        uniOpt  : {
            isMaster    : false,        // 상위 버튼 연결
            editable    : false,         // 수정 모드 사용
            deletable   : false,         // 삭제 가능 여부
            useNavi     : false         // prev | next 버튼 사용
        },

        proxy: directProxy7,

        loadStoreRecords : function(getCustomCode){
            var param= Ext.getCmp('s_bcm100ukrv_ypSearchForm').getValues();
            param.CUSTOM_CODE = getCustomCode

            console.log( param );
            this.load({
                params : param
            });
        },

        saveStore : function(config) {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);
            if(inValidRecs.length == 0 )     {
                config = {
                    success : function(batch, option) {
                        if(gsNeedPhotoSave){
                            fnPhotoSave();
                        }
                    }
                };
                this.syncAllDirect(config);
            }else {
                electroInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },

        listeners: {
            update:function( store, record, operation, modifiedFieldNames, eOpts ){
            },
            metachange:function( store, meta, eOpts ){
            }
        },

        _onStoreUpdate: function (store, eOpt) {
            console.log("Store data updated save btn enabled !");
            this.setToolbarButtons('sub_save7', true);
        }, // onStoreUpdate

        _onStoreLoad: function ( store, records, successful, eOpts ) {
            console.log("onStoreLoad");
            if (records) {
                this.setToolbarButtons('sub_save7', false);
            }
        },
        _onStoreDataChanged: function( store, eOpts )   {
            console.log("_onStoreDataChanged store.count() : ", store.count());
            if(store.count() == 0){
                this.setToolbarButtons(['sub_delete7'], false);
                Ext.apply(this.uniOpt.state, {'btn':{'sub_delete7':false}});
            }else {
                if(this.uniOpt.deletable)   {
                    this.setToolbarButtons(['sub_delete7'], true);
                    Ext.apply(this.uniOpt.state, {'btn':{'sub_delete7':true}});
                }
            }
            if(store.isDirty()) {
                this.setToolbarButtons(['sub_save7'], true);
            }else {
                this.setToolbarButtons(['sub_save7'], false);
            }
        },

        setToolbarButtons: function( btnName, state)     {
            var toolbar = eduGrid.getDockedItems('toolbar[dock="top"]');
            var obj = toolbar[0].getComponent(btnName);
            if(obj) {
                (state) ? obj.enable():obj.disable();
            }
        }
    });


	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('s_bcm100ukrv_ypSearchForm',{
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		listeners	: {
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
			title		: '기본정보',
			id			: 'search_panel1',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '거래처코드',
				name		: 'CUSTOM_CODE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '거래처명',
				name		: 'CUSTOM_NAME',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				}
			},{
				fieldLabel	: '구분',
				name		: 'CUSTOM_TYPE' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B015',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CUSTOM_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '약어',
				name		: 'CHANNEL',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CHANNEL', newValue);
					}
				}
			}]
		}, {
			title		: '추가정보',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '지역',
				name		: 'AREA_TYPE' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B056'
			},{
				fieldLabel	: '주영업담당',
				name		: 'BUSI_PRSN' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'S010'
			},{
				fieldLabel	: '고객분류'	 ,
				name		: 'AGENT_TYPE' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B055'
			},{
				fieldLabel	: '법인/개인',
				name		: 'BUSINESS_TYPE' ,
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B016'
			},{
				fieldLabel	: '사용유무'	,
				name		: 'USE_YN',
				xtype		: 'uniCombobox' ,
				comboType	: 'AU',
				comboCode	: 'B010'
			},{
				fieldLabel	: '대표자명'	,
				name		: 'TOP_NAME'
			},{
				fieldLabel	: '사업자번호',
				name		: 'COMPANY_NUM'
			 }]
		}]
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		weight	: -100,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '거래처코드',
			name		: 'CUSTOM_CODE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '거래처명',
			name		: 'CUSTOM_NAME',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_NAME', newValue);
				}
			}
		},{
			fieldLabel	: '구분',
			name		: 'CUSTOM_TYPE' ,
			xtype		: 'uniCombobox' ,
			comboType	: 'AU',
			comboCode	: 'B015',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CUSTOM_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '약어',
			name		: 'CHANNEL',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CHANNEL', newValue);
				}
			}
		}]
	 });



	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_bcm100ukrv_ypGrid', {
		store	: masterStore,
		region	: 'west',
		flex	: 1,
		uniOpt	:{
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
            copiedRow           : true
		},
		border:true,
		columns:[{dataIndex:'CUSTOM_CODE'		,width:80	, hideable:false	, editable: false},
				{dataIndex:'CUSTOM_TYPE'		,width:80	, hidden:true},
				{dataIndex:'CUSTOM_NAME'		,flex: 1	, minWidth:130		, hideable:false},
				{dataIndex:'CUSTOM_NAME1'		,width:150	, hidden:true},
				{dataIndex:'CUSTOM_NAME2'		,width:150	, hidden:true},
				{dataIndex:'CUSTOM_FULL_NAME'	,width:170	, hidden:true},
				{dataIndex:'NATION_CODE'		,width:130	, hidden:true},
				{dataIndex:'COMPANY_NUM'		,width:100	, hidden:true},
				{dataIndex:'TOP_NUM'			,width:100	, hidden:true},
				{dataIndex:'TOP_NAME'			,width:100	, hidden:true},
				{dataIndex:'BUSINESS_TYPE'		,width:110	, hidden:true},
				{dataIndex:'USE_YN'				,width:60	, hidden:true},
				{dataIndex:'COMP_TYPE'			,width:140	, hidden:true},
				{dataIndex:'COMP_CLASS'			,width:140	, hidden:true},
				{dataIndex:'AGENT_TYPE'			,width:120	, hidden:true},
				{dataIndex:'AGENT_TYPE2'		,width:80	, hidden:true},
				{dataIndex:'AGENT_TYPE3'		,width:80	, hidden:true},
				{dataIndex:'AREA_TYPE'			,width:80	, hidden:true},
				{dataIndex:'DELIVERY_UNION'		,width:80	, hidden:true},
				{dataIndex:'ZIP_CODE'			, hidden : true
					,'editor' : Unilite.popup('ZIP_G',{
						listeners: {
							'onSelected': {
								fn: function(records, type){
									var me = this;
									var grdRecord = Ext.getCmp('s_bcm100ukrv_ypGrid').uniOpt.currentRecord;
									grdRecord.set('ADDR1',records[0]['ZIP_NAME']);
									grdRecord.set('ADDR2',records[0]['ADDR2']);
								},
								scope: this
							},
							'onClear' : function(type){
								var me = this;
								var grdRecord = Ext.getCmp('s_bcm100ukrv_ypGrid').uniOpt.currentRecord;
								grdRecord.set('ADDR1','');
								grdRecord.set('ADDR2','');
							}
						}
					})
				},
				{dataIndex:'ADDR1'				,width:200	, hidden:true},
				{dataIndex:'ADDR2'				,width:200	, hidden:true},
				{dataIndex:'TELEPHON'			,width:80	, hidden:true},
				// 추가(극동)
				{dataIndex:'R_PAYMENT_YN'		,width:100	, hidden:true},
				// 추가 (양평공사)
				{dataIndex:'PURCH_TYPE'			,width:100	, hidden:true},
				// 추가(극동)
//				{dataIndex:'DELIVERY_METH'		,width:80	, hidden:true},
				//
				{dataIndex:'FAX_NUM'			,width:80	, hidden:true},
				{dataIndex:'HTTP_ADDR'			,width:140	, hidden:true},
				{dataIndex:'MAIL_ID'			,width:100	, hidden:true},
				{dataIndex:'WON_CALC_BAS'		,width:80	, hidden:true},
				{dataIndex:'START_DATE'			,width:110	, hidden:true},
				{dataIndex:'STOP_DATE'			,width:110	, hidden:true},
				{dataIndex:'TO_ADDRESS'			,width:140	, hidden:true},
				{dataIndex:'TAX_CALC_TYPE'		,width:90	, hidden:true},
				{dataIndex:'TRANS_CLOSE_DAY'	,width:120	, hidden:true},
				{dataIndex:'RECEIPT_DAY'		,width:120	, hidden:true},
				{dataIndex:'MONEY_UNIT'			,width:130	, hidden:true},
				{dataIndex:'TAX_TYPE'			,width:90	, hidden:true},
				{dataIndex:'BILL_TYPE'			,width:120	, hidden:true},
				{dataIndex:'SET_METH'			,width:90	, hidden:true},
				{dataIndex:'VAT_RATE'			,width:60	, hidden:true},
				{dataIndex:'TRANS_CLOSE_DAY'	,width:90	, hidden:true},
				{dataIndex:'COLLECT_DAY'		,width:90	, hidden:true, maxValue: 31, minValue: 1},
				{dataIndex:'CREDIT_YN'			,width:80	, hidden:true},
				{dataIndex:'TOT_CREDIT_AMT'		,width:90	, hidden:true},
				{dataIndex:'CREDIT_AMT'			,width:80	, hidden:true},
				{dataIndex:'CREDIT_YMD'			,width:110	, hidden:true},
				{dataIndex:'COLLECT_CARE'		,width:120	, hidden:true},
				{dataIndex:'BUSI_PRSN'			,width:90	, hidden:true},
				{dataIndex:'CAL_TYPE'			,width:110	, hidden:true},
				{dataIndex:'REMARK'				,width:250	, hidden:true	, flex:1},
				{dataIndex:'MANAGE_CUSTOM'		,width:140	, hidden:true},
				{dataIndex:'MCUSTOM_NAME'		,width:140	, hidden:true
					,editor : Unilite.popup('CUST_G',{
						textFieldName:'MCUSTOM_NAME',
						listeners: {
							'onSelected':function(records, type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
								grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							'onClear':function( type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('MCUSTOM_NAME','');
								grdRecord.set('MANAGE_CUSTOM','');
							}
						} // listeners
					})
				},
				{dataIndex:'COLLECTOR_CP'		,width:140	, hidden:true},
				{dataIndex:'COLLECTOR_CP_NAME'	,width:140	, hidden:true
					,'editor' : Unilite.popup('CUST_G',	{
						textFieldName:'COLLECTOR_CP_NAME',
						listeners: {
							'onSelected':function(records, type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
								grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
							},
							'onClear':function( type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('COLLECTOR_CP_NAME','');
								grdRecord.set('COLLECTOR_CP','');
							}
						} // listeners
					})
				},
				{dataIndex:'BANK_NAME',width: 100		, hidden: true
					,'editor' : Unilite.popup('BANK_G',	{
						textFieldName:'BANK_NAME',
						listeners: {
							'onSelected': function(records, type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							},
							'onClear':function( type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_NAME','');
								grdRecord.set('BANK_CODE','');
							}
						} // listeners
					})
				},
				{dataIndex:'BANKBOOK_NUM'		,width:100	, hidden:true},
				{dataIndex:'BANKBOOK_NAME'		,width:100	, hidden:true},
				{dataIndex:'CUST_CHK'			,width:90	, hidden:true},
				{dataIndex:'SSN_CHK'			,width:90	, hidden:true},
				{dataIndex:'UPDATE_DB_USER'		,width:90	, hidden:true},
				{dataIndex:'UPDATE_DB_TIME'		,width:90	, hidden:true},
				{dataIndex:'PURCHASE_BANK'		,width:150	, hidden:true},
				{dataIndex:'PURBANKNAME'		,width:150	, hidden:true},
				{dataIndex:'BILL_PRSN'			,width:110	, hidden:true},
				{dataIndex:'HAND_PHON'			,width:110	, hidden:true},
				{dataIndex:'BILL_MAIL_ID'		,width:140	, hidden:true},
				{dataIndex:'ADDR_TYPE'			,width:120	, hidden:true},
				{dataIndex:'CHANNEL'			,width:80	, hidden:true},
				{dataIndex:'BILL_CUSTOM'		,width:120	, hidden:true},
				{dataIndex:'BILL_PUBLISH_TYPE'	,width:120	, hidden:true}, //임시
				{dataIndex:'BILL_CUSTOM_NAME'	,width:120	, hidden:true
					,'editor' : Unilite.popup('CUST_G',{
						textFieldName:'BILL_CUSTOM_NAME',
						listeners: {
							'onSelected':function(records, type){
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
									grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							'onClear':function( type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('BILL_CUSTOM_NAME','');
								grdRecord.set('BILL_CUSTOM','');
							}
						} //listeners
					})
				}
			],
			listeners: {
				beforePasteRecord: function(rowIndex, record) {
                    record.CUSTOM_CODE = Msg.sMSR226;
                    record.CHANNEL = '';
                    return true;
                },
				beforeedit: function( editor, e, eOpts ) {
					if (UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_TYPE', 'CUSTOM_NAME'])){
						return false;
					}
				},
				selectionchangerecord:function(selected)	{
					gsChkFlag = 'N';
					detailForm.setActiveRecord(selected);
					farmHouseForm.setActiveRecord(selected);
//					if(!Ext.isEmpty(farmHouseForm.down('#custImg').getEl())){
//					   farmHouseForm.down('#custImg').getEl().dom.src=CPATH+'/uploads/farmHouseImages/'+ param.CUSTOM_CODE + '?_dc=' + data['UPDATE_DB_TIME'];;
//					}

					var customCode = selected.get('CUSTOM_CODE');
					accountStore.loadStoreRecords(customCode);
					electroInfoStore.loadStoreRecords(customCode);
					certInfoStore.loadStoreRecords(customCode);
					growthStore1.loadStoreRecords(customCode);
					growthStore2.loadStoreRecords(customCode);
					eduStore.loadStoreRecords(customCode);
				},
				onGridDblClick:function(grid, record, cellIndex, colName) {
				},
				hide:function()	{
				},
				edit: function(editor, e) {
					gsChkFlag = 'N';
					var record = masterGrid.getSelectedRecord();
					detailForm.setActiveRecord(record);
					farmHouseForm.setActiveRecord(record);
				}
			}
	});

	var masterGrid2 = Unilite.createGrid('s_bcm100ukrv_ypGrid2', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: true,
			useMultipleSorting	: true,
            copiedRow           : true
		},
		border:true,
		columns:[
			{dataIndex:'CUSTOM_CODE'		,width:80	, hideable:false	, editable: false},
			{dataIndex:'CUSTOM_TYPE'		,width:80	, hideable:false},
			{dataIndex:'CUSTOM_NAME'		,width:130	, hideable:false},
			{dataIndex:'CUSTOM_NAME1'		,width:150	, hidden:true},
			{dataIndex:'CUSTOM_NAME2'		,width:150	, hidden:true},
			{dataIndex:'CUSTOM_FULL_NAME'	,width:170},
			{dataIndex:'NATION_CODE'		,width:130	, hidden:true},
			{dataIndex:'COMPANY_NUM'		,width:100},
			{dataIndex:'TOP_NUM'			,width:100	, hidden:true},
			{dataIndex:'TOP_NAME'			,width:100},
			{dataIndex:'BUSINESS_TYPE'		,width:110	, hidden:true},
			{dataIndex:'USE_YN'				,width:60	, hidden:true},
			{dataIndex:'COMP_TYPE'			,width:140},
			{dataIndex:'COMP_CLASS'			,width:140},
			{dataIndex:'AGENT_TYPE'			,width:120},
			{dataIndex:'AGENT_TYPE2'		,width:80	, hidden:true},
			{dataIndex:'AGENT_TYPE3'		,width:80	, hidden:true},
			{dataIndex:'AREA_TYPE'			,width:80	, hidden:true},
			{dataIndex:'DELIVERY_UNION'			,width:80	, hidden:true},
			{dataIndex:'ZIP_CODE'			, hidden : true
				,'editor' : Unilite.popup('ZIP_G',{
					listeners: {
						'onSelected': {
							fn: function(records, type){
								var me = this;
								var grdRecord = Ext.getCmp('s_bcm100ukrv_ypGrid').uniOpt.currentRecord;
								grdRecord.set('ADDR1',records[0]['ZIP_NAME']);
								grdRecord.set('ADDR2',records[0]['ADDR2']);
							},
							scope: this
						},
						'onClear' : function(type){
							var me = this;
							var grdRecord = Ext.getCmp('s_bcm100ukrv_ypGrid').uniOpt.currentRecord;
							grdRecord.set('ADDR1','');
							grdRecord.set('ADDR2','');
						}
					}
				})
			},
			{dataIndex:'ADDR1'				,width:200	, hidden:true},
			{dataIndex:'ADDR2'				,width:200	, hidden:true},
			{dataIndex:'TELEPHON'			,width:80},
			// 추가(극동)
			{dataIndex:'R_PAYMENT_YN'		,width:100},
			// 추가 (양평공사)
			{dataIndex:'PURCH_TYPE'		,width:100	},
			// 추가(극동)
//				{dataIndex:'DELIVERY_METH'		,width:80},
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
			{dataIndex:'REMARK'			,width:250},
			{dataIndex:'TYPE'			,width:100	, hidden:false},
			{dataIndex:'CERT_NO'			,width:100	, hidden:false},
			{dataIndex:'CERT_DATE'			,width:90	, hidden:false},
			{dataIndex:'APLY_START_DATE'			,width:90	, hidden:false},
			{dataIndex:'APLY_END_DATE'			,width:90	, hidden:false},
			{dataIndex:'CERT_ORG'			,width:140	, hidden:false},
			{dataIndex:'CERT_COUNT'			,width:80	, hidden:false},
			{dataIndex:'MANAGE_CUSTOM'		,width:140	, hidden:true},
			{dataIndex:'MCUSTOM_NAME'		,width:140	, hidden:true
				,editor : Unilite.popup('CUST_G',{
					textFieldName:'MCUSTOM_NAME',
					listeners: {
						'onSelected':function(records, type){
								var grdRecord = masterGrid2.uniOpt.currentRecord;
								grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
								grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
						}
						,'onClear':function( type){
							var grdRecord = masterGrid2.uniOpt.currentRecord;
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
					listeners: {
						'onSelected':function(records, type){
								var grdRecord = masterGrid2.uniOpt.currentRecord;
								grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
									grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
						},
						'onClear':function( type){
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('COLLECTOR_CP_NAME','');
							grdRecord.set('COLLECTOR_CP','');
						}
					} // listeners
				})
			},
			{dataIndex:'BANK_NAME',width: 100		, hidden: true
				,'editor' : Unilite.popup('BANK_G',	{
					textFieldName:'BANK_NAME',
					listeners: {
						'onSelected': function(records, type){
								var grdRecord = masterGrid2.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
						},
						'onClear':function( type){
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BANK_NAME','');
							grdRecord.set('BANK_CODE','');
						}
					} // listeners
				})
			},

			{dataIndex:'BANKBOOK_NUM'		,width:100	, hidden:true},
			{dataIndex:'BANKBOOK_NAME'		,width:100	, hidden:true},
			{dataIndex:'CUST_CHK'			,width:90	, hidden:true},
			{dataIndex:'SSN_CHK'			,width:90	, hidden:true},
			{dataIndex:'UPDATE_DB_USER'		,width:90	, hidden:true},
			{dataIndex:'UPDATE_DB_TIME'		,width:90	, hidden:true},
			{dataIndex:'PURCHASE_BANK'		,width:150	, hidden:true},
			{dataIndex:'PURBANKNAME'		,width:150	, hidden:true},
			{dataIndex:'BILL_PRSN'			,width:110	, hidden:true},
			{dataIndex:'HAND_PHON'			,width:110	, hidden:true},
			{dataIndex:'BILL_MAIL_ID'		,width:140	, hidden:true},
			{dataIndex:'ADDR_TYPE'			,width:120	, hidden:true},
			{dataIndex:'CHANNEL'			,width:80	},
			{dataIndex:'BILL_CUSTOM'		,width:120	, hidden:true},
			{dataIndex:'BILL_PUBLISH_TYPE'	,width:120	, hidden:true}, //임시
			{dataIndex:'BILL_CUSTOM_NAME'	,width:120	, hidden:true
				,'editor' : Unilite.popup('CUST_G',{
					textFieldName:'BILL_CUSTOM_NAME',
					listeners: {
						'onSelected':function(records, type){
								var grdRecord = masterGrid2.uniOpt.currentRecord;
								grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
								grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						'onClear':function( type){
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BILL_CUSTOM_NAME','');
							grdRecord.set('BILL_CUSTOM','');
						}
					} //listeners
				})
			}
		],
		listeners: {
			beforePasteRecord: function(rowIndex, record) {
                record.CUSTOM_CODE = Msg.sMSR226;
                record.CHANNEL = '';
                return true;
            },
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['CUSTOM_CODE','TYPE','CERT_NO','CERT_DATE','APLY_START_DATE','APLY_END_DATE','CERT_ORG','CERT_COUNT'/*, 'CUSTOM_TYPE', 'CUSTOM_NAME'*/])){
					return false;
				}
			},
			selectionchangerecord:function(selected)	{
				gsChkFlag = 'N';
				detailForm.setActiveRecord(selected);
				farmHouseForm.setActiveRecord(selected);
				var customCode = selected.get('CUSTOM_CODE');
				accountStore.loadStoreRecords(customCode);
				electroInfoStore.loadStoreRecords(customCode);
				certInfoStore.loadStoreRecords(customCode);
				growthStore1.loadStoreRecords(customCode);
				growthStore2.loadStoreRecords(customCode);
				eduStore.loadStoreRecords(customCode);
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			},
			hide:function()	{
			},
			edit: function(editor, e) {
				gsChkFlag = 'N';
				var record = masterGrid2.getSelectedRecord();
				detailForm.setActiveRecord(record);
				farmHouseForm.setActiveRecord(record);
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				masterGrid.getNavigationModel().setPosition(rowIndex, 0);
				masterGrid.getSelectionModel().select(rowIndex);
			}
		}
	 });

	var accountGrid = Unilite.createGrid('s_bcm100ukrv_ypGrid3', {
		store	: accountStore,
		border	: true,
		height	: 150,
		width	: 912,
		padding	: '0 0 5 0',
		sortableColumns : false,

		excelTitle: '계좌정보',
		uniOpt:{
			 expandLastColumn	: true,
			 useRowNumberer		: true,
			 useMultipleSorting	: false
//			 enterKeyCreateRow	: true						//마스터 그리드 추가기능 삭제
		},
		dockedItems	: [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text 	: '조회',
				tooltip	: '조회',
				iconCls	: 'icon-query',
				width	: 26,
				height	: 26,
				itemId	: 'sub_query',
				handler: function() {
					//if( me._needSave()) {
					var toolbar = accountGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					var record = masterGrid.getSelectedRecord();
					if(needSave) {
						Ext.Msg.show({
							title	:'확인',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								//console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										accountStore.saveStore();
									});
									saveTask.delay(500);

								} else if(res === 'no') {
									accountStore.loadStoreRecords(record.get('CUSTOM_CODE'));
								}
							}
						});
					} else {
						accountStore.loadStoreRecords(record.get('CUSTOM_CODE'));
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '신규',
				tooltip : '초기화',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
				itemId	: 'sub_reset',
				handler	: function() {
					var toolbar = accountGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
							title	: '확인',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										accountStore.saveStore();
									});
									saveTask.delay(500);

								} else if(res === 'no') {
									accountGrid.reset();
									accountStore.clearData();
									accountStore.setToolbarButtons('sub_save'	, false);
									accountStore.setToolbarButtons('sub_delete'	, false);
								}
							}
						});
					} else {
						accountGrid.reset();
						accountStore.clearData();
						accountStore.setToolbarButtons('sub_save'	, false);
						accountStore.setToolbarButtons('sub_delete'	, false);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData',
				handler	: function() {
					var record			= masterGrid.getSelectedRecord();
					var compCode		= UserInfo.compCode;
					var customCode		= record.get('CUSTOM_CODE');
					var bankBookNumExpos= '';
					var mainBookYn		= 'N';

					var r = {
						COMP_CODE			: compCode,
						CUSTOM_CODE			: customCode,
						MAIN_BOOK_YN		: mainBookYn,
						BANKBOOK_NUM_EXPOS	: bankBookNumExpos
					};
					accountGrid.createRow(r);
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26,
				height	: 26,
				itemId	: 'sub_delete',
				handler	: function() {
					var selRow = accountGrid.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
						if(selRow.phantom === true)	{
							accountGrid.deleteSelectedRow();
						}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
							accountGrid.deleteSelectedRow();
						}
					} else {
						alert(Msg.sMA0256);
						return false;
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '저장',
				tooltip	: '저장',
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
				itemId	: 'sub_save',
				handler : function() {
					var inValidRecs = accountStore.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							accountStore.saveStore();
						});
						saveTask.delay(500);

					} else {
						accountGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}]
		 }],

		columns:[
			{ dataIndex: 'BOOK_CODE'			, width: 120},
			{ dataIndex: 'BOOK_NAME'			, width: 100},
			{ dataIndex: 'BANK_CODE'			, width: 120,
				editor: Unilite.popup('BANK_G',{
 					DBtextFieldName	: 'BANK_CODE',
 					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type){
								var grdRecord = accountGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = accountGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
						}
					}
				})
			 },{ dataIndex: 'BANK_NAME'			, width: 160,
					editor		: Unilite.popup('BANK_G',{
 					autoPopup	: true,
					listeners	:{
						'onSelected': {
							fn: function(records, type){
								var grdRecord = accountGrid.uniOpt.currentRecord;
								grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
								grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = accountGrid.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
						}
					}
				})
			},
			{ dataIndex: 'BANKBOOK_NUM_EXPOS'	, width: 120 	},
			{ dataIndex: 'BANKBOOK_NUM'			, width: 160,	hidden: true},
			{ dataIndex: 'BANKBOOK_NAME'		, width: 120},
			{ dataIndex: 'MAIN_BOOK_YN'			, width: 100}

		],

		listeners: {
			beforeedit: function( editor, e, eOpts ) {
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
				}
			}
		},
		openCryptBankAccntPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCNT_CODE': record.get('BANKBOOK_NUM')};
				Unilite.popupCryptBankAccnt('grid', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
			}

		}

	});

	var electroInfoGrid = Unilite.createGrid('s_bcm100ukrv_ypGrid4', {
		store	: electroInfoStore,
		border	: true,
		height	: 150,
		width	: 912,
		padding	: '0 0 5 0',
		sortableColumns : false,

		excelTitle: '전자문서정보',
		uniOpt:{
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting : false
//			enterKeyCreateRow: true							//마스터 그리드 추가기능 삭제
		},
		dockedItems : [{
				xtype	: 'toolbar',
				dock	: 'top',
				items	: [{
					xtype	: 'uniBaseButton',
					text	: '조회',
					tooltip: '조회',
					iconCls: 'icon-query',
					width	: 26,
					height	: 26,
					itemId	: 'sub_query3',
					handler: function() {
						//if( me._needSave()) {
						var toolbar	= electroInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save3').isDisabled();
						var record	= masterGrid.getSelectedRecord();
						if(needSave) {
								Ext.Msg.show({
									title:'확인',
									msg: Msg.sMB017 + "\n" + Msg.sMB061,
									buttons: Ext.Msg.YESNOCANCEL,
									icon: Ext.Msg.QUESTION,
									fn: function(res) {
										//console.log(res);
										if (res === 'yes' ) {
												var saveTask =Ext.create('Ext.util.DelayedTask', function(){
													electroInfoStore.saveStore();
												});
												saveTask.delay(500);
										} else if(res === 'no') {
												electroInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
										}
									}
								});
						} else {
								electroInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
						}
					}
				},{
					xtype	: 'uniBaseButton',
					text	: '신규',
					tooltip: '초기화',
					iconCls: 'icon-reset',
					width	: 26,
					height	: 26,
					itemId	: 'sub_reset3',
					handler: function() {
						var toolbar	= electroInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save3').isDisabled();
						if(needSave) {
								Ext.Msg.show({
									title:'확인',
									msg: Msg.sMB017 + "\n" + Msg.sMB061,
									buttons: Ext.Msg.YESNOCANCEL,
									icon: Ext.Msg.QUESTION,
									fn: function(res) {
										console.log(res);
										if (res === 'yes' ) {
												var saveTask =Ext.create('Ext.util.DelayedTask', function(){
													electroInfoStore.saveStore();
												});
												saveTask.delay(500);
										} else if(res === 'no') {
												electroInfoGrid.reset();
												electroInfoStore.clearData();
												electroInfoStore.setToolbarButtons('sub_save3', false);
												electroInfoStore.setToolbarButtons('sub_delete3', false);
										}
									}
								});
						} else {
								electroInfoGrid.reset();
								electroInfoStore.clearData();
								electroInfoStore.setToolbarButtons('sub_save3', false);
								electroInfoStore.setToolbarButtons('sub_delete3', false);
						}
					}
				},{
					xtype	: 'uniBaseButton',
					text	: '추가',
					tooltip: '추가',
					iconCls: 'icon-new',
					width	: 26,
					height	: 26,
					itemId	: 'sub_newData3',
					handler: function() {
						var record		= masterGrid.getSelectedRecord();
						var compCode	= UserInfo.compCode;
						var customCode	= record.get('CUSTOM_CODE');
						var seq			= electroInfoStore.max('SEQ');
						if(!seq){
								seq = 1;
						}else{
								seq += 1;
						}
						var r = {
								COMP_CODE	:	compCode,
								CUSTOM_CODE	:	customCode,
								SEQ			:	seq,
								BILL_TYPE	:	"1",
								MAIN_BILL_YN:	"Y"
						};
						electroInfoGrid.createRow(r);
					}
				},{
					xtype		: 'uniBaseButton',
					text		: '삭제',
					tooltip	: '삭제',
					iconCls	: 'icon-delete',
					disabled	: true,
					width		: 26,
					height		: 26,
					itemId		: 'sub_delete3',
					handler	: function() {
						var selRow = electroInfoGrid.getSelectedRecord();
						if(!Ext.isEmpty(selRow)) {
							if(selRow.phantom === true) {
								electroInfoGrid.deleteSelectedRow();
							}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
								electroInfoGrid.deleteSelectedRow();
							}
						} else {
							alert(Msg.sMA0256);
							return false;
						}
					}
				},{
					xtype		: 'uniBaseButton',
					text		: '저장',
					tooltip	: '저장',
					iconCls	: 'icon-save',
					disabled	: true,
					width		: 26,
					height		: 26,
					itemId		: 'sub_save3',
					handler	: function() {
						var inValidRecs = electroInfoStore.getInvalidRecords();
						if(inValidRecs.length == 0 )	 {
								var saveTask =Ext.create('Ext.util.DelayedTask', function(){
									electroInfoStore.saveStore();
								});
								saveTask.delay(500);
						} else {
								electroInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
						}
					}
				}]
		}],

		columns:[
				{ dataIndex: 'COMP_CODE'		, width: 80		,hidden:true},
				{ dataIndex: 'CUSTOM_CODE'		, width: 80		,hidden:true},
				{ dataIndex: 'SEQ'				, width: 60},
				{ dataIndex: 'PRSN_NAME'		, width: 100},
				{ dataIndex: 'DEPT_NAME'		, width: 100},
				{ dataIndex: 'HAND_PHON'		, width: 120},
				{ dataIndex: 'TELEPHONE_NUM1'	, width: 120},
				{ dataIndex: 'TELEPHONE_NUM2'	, width: 120},
				{ dataIndex: 'FAX_NUM'			, width: 100},
				{ dataIndex: 'MAIL_ID'			, width: 140},
				{ dataIndex: 'BILL_TYPE'		, width: 120},
				{ dataIndex: 'MAIN_BILL_YN'		, width: 150},
				{ dataIndex: 'REMARK'			, width: 100}
		],

		listeners: {
			beforeedit: function( editor, e, eOpts ) {
			}
		}
	});

	//인증서정보 - S_BCM100T_YP
	var certInfoGrid = Unilite.createGrid('s_bcm100ukrv_ypGrid5', {
		store	: certInfoStore,
		border	: true,
		height	: 180,
		width	: 912,
		padding	: '0 0 5 0',
		sortableColumns : false,
		excelTitle: '인증서정보',
		uniOpt	:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false
//			enterKeyCreateRow: true							//마스터 그리드 추가기능 삭제
		},
		dockedItems : [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '조회',
				tooltip: '조회',
				iconCls: 'icon-query',
				width	: 26,
				height	: 26,
				itemId	: 'sub_query4',
				handler: function() {
					//if( me._needSave()) {
					var toolbar	= certInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					var record	= masterGrid.getSelectedRecord();
					if (needSave) {
						Ext.Msg.show({
							title	: '확인',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								//console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										certInfoStore.saveStore();
									});
									saveTask.delay(500);
								} else if(res === 'no') {
										certInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
								}
							}
						});
					} else {
						certInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '신규',
				tooltip: '초기화',
				iconCls: 'icon-reset',
				width	: 26,
				height	: 26,
				itemId	: 'sub_reset4',
				handler: function() {
					var toolbar	= certInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					if(needSave) {
							Ext.Msg.show({
								title:'확인',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									console.log(res);
									if (res === 'yes' ) {
											var saveTask =Ext.create('Ext.util.DelayedTask', function(){
												certInfoStore.saveStore();
											});
											saveTask.delay(500);
									} else if(res === 'no') {
											certInfoGrid.reset();
											certInfoStore.clearData();
											certInfoStore.setToolbarButtons('sub_save4', false);
											certInfoStore.setToolbarButtons('sub_delete4', false);
									}
								}
							});
					} else {
							certInfoGrid.reset();
							certInfoStore.clearData();
							certInfoStore.setToolbarButtons('sub_save4', false);
							certInfoStore.setToolbarButtons('sub_delete4', false);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip: '추가',
				iconCls: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData4',
				handler: function() {
					var record		= masterGrid.getSelectedRecord();
					var compCode	= UserInfo.compCode;
					var customCode	= record.get('CUSTOM_CODE');
					var r = {
						COMP_CODE		:	compCode,
						CUSTOM_CODE		:	customCode,
						APLY_START_DATE	:	new Date()
					};
					certInfoGrid.createRow(r);
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_delete4',
				handler	: function() {
					var selRow = certInfoGrid.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
						if(selRow.phantom === true) {
							certInfoGrid.deleteSelectedRow();
						}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
							certInfoGrid.deleteSelectedRow();
						}
					} else {
						alert(Msg.sMA0256);
						return false;
					}
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '저장',
				tooltip		: '저장',
				iconCls		: 'icon-save',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_save4',
				handler	: function() {
					var inValidRecs = certInfoStore.getInvalidRecords();
					if(inValidRecs.length == 0 )	 {
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							certInfoStore.saveStore();
						});
						saveTask.delay(500);
					} else {
						certInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}]
		}],

		columns:[
				{ dataIndex	: 'COMP_CODE'			, width: 80		,hidden:true},
				{ dataIndex	: 'CUSTOM_CODE'			, width: 80		,hidden:true},
				{ dataIndex	: 'TYPE'				, width: 80 },
				{ dataIndex	: 'CERT_NO'				, width: 100},
				{ dataIndex	: 'CERT_DATE'			, width: 100},
				{ text		: '인증기간',
				 	columns:[
						{ dataIndex: 'APLY_START_DATE'		, width: 100},
						{ dataIndex: 'APLY_END_DATE'		, width: 100}
				]},
				{ text		: '인증서',
				 	columns:[
						{ dataIndex	: 'CERT_FILE'			, width: 150		, align: 'center'	,
							renderer: function (val, meta, record) {
								if (!Ext.isEmpty(record.data.CERT_FILE)) {
									return '<font color = "blue" >' + val + '</font>';

								} else {
									return '';
								}
							}
						},{
							text		: '',
							dataIndex	: 'REG_IMG',
							xtype		: 'actioncolumn',
							align		: 'center',
							padding		: '-2 0 2 0',
							width		: 30,
							items		: [{
								icon	: CPATH+'/resources/css/theme_01/barcodetest.png',
								handler	: function(grid, rowIndex, colIndex, item, e, record) {
									certInfoGrid.getSelectionModel().select(record);
									openUploadWindow();
								}
							}]
						}
					]
				},
				{ dataIndex	: 'CERT_ORG'			, width: 130},
				{ dataIndex	: 'REMARK'				, flex: 1	, minWidth: 30}/*,
				{
				  text		: '등록 버튼으로 구현 한 것',
				  align	: 'center',
				  width	: 50,
				  renderer	: function(value, meta, record) {
						var id = Ext.id();
						Ext.defer(function(){
							new Ext.Button({
								text	: '등록',
				  				margin	: '-2 0 2 0',
								handler : function(btn, e) {
									certInfoGrid.getSelectionModel().select(record);
									openUploadWindow();
								}
							}).render(document.body, id);
						},50);
						return Ext.String.format('<div id="{0}"></div>', id);
					}
				}*/
		],

		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {					//
					if (UniUtils.indexOf(e.field, ['TYPE', 'CERT_NO', 'CERT_FILE'])){
						return false;
					}

				} else {
					if (UniUtils.indexOf(e.field, ['CERT_FILE'])){
						return false;
					}
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(cellIndex == 8 && !Ext.isEmpty(record.get('CERT_FILE'))) {
					fid = record.data.FILE_ID
					var fileExtension	= record.get('CERT_FILE').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadCertImage/' + fid,
							prgID	: 's_bcm100ukrv_yp'
						});
						win.center();
						win.show();

					} else {
						openPhotoWindow();
					}
				}
			}
		}
	});

	//농가이력 제배품목1그리드 - S_BCM101T_YP
    var growthGrid1 = Unilite.createGrid('s_bcm100ukrv_ypGrid6', {
        store   : growthStore1,
        border  : true,
        height  : 180,
        width   : 751,
        padding : '0 0 5 0',
        sortableColumns : false,
        excelTitle: '재배품목',
        uniOpt  :{
            onLoadSelectFirst   : false,
            expandLastColumn    : false,
            useRowNumberer      : true,
            useMultipleSorting  : false
//          enterKeyCreateRow: true                         //마스터 그리드 추가기능 삭제
        },
        dockedItems : [{
            xtype   : 'toolbar',
            dock    : 'top',
            items   : [{
                xtype   : 'uniBaseButton',
                text    : '조회',
                tooltip: '조회',
                iconCls: 'icon-query',
                width   : 26,
                height  : 26,
                itemId  : 'sub_query5',
                handler: function() {
                    //if( me._needSave()) {
                    var toolbar = growthGrid1.getDockedItems('toolbar[dock="top"]');
                    var needSave= !toolbar[0].getComponent('sub_save5').isDisabled();
//                    var record  = masterGrid.getSelectedRecord();
                    if (needSave) {
                        Ext.Msg.show({
                            title   : '확인',
                            msg     : Msg.sMB017 + "\n" + Msg.sMB061,
                            buttons : Ext.Msg.YESNOCANCEL,
                            icon    : Ext.Msg.QUESTION,
                            fn      : function(res) {
                                //console.log(res);
                                if (res === 'yes' ) {
                                    var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                                        growthStore1.saveStore();
                                    });
                                    saveTask.delay(500);
                                } else if(res === 'no') {
                                        growthStore1.loadStoreRecords(farmHouseForm.getValue('CUSTOM_CODE'));
                                }
                            }
                        });
                    } else {
                        growthStore1.loadStoreRecords(farmHouseForm.getValue('CUSTOM_CODE'));
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '신규',
                tooltip: '초기화',
                iconCls: 'icon-reset',
                width   : 26,
                height  : 26,
                itemId  : 'sub_reset5',
                handler: function() {
                    var toolbar = growthGrid1.getDockedItems('toolbar[dock="top"]');
                    var needSave= !toolbar[0].getComponent('sub_save5').isDisabled();
                    if(needSave) {
                            Ext.Msg.show({
                                title:'확인',
                                msg: Msg.sMB017 + "\n" + Msg.sMB061,
                                buttons: Ext.Msg.YESNOCANCEL,
                                icon: Ext.Msg.QUESTION,
                                fn: function(res) {
                                    console.log(res);
                                    if (res === 'yes' ) {
                                            var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                                                growthStore1.saveStore();
                                            });
                                            saveTask.delay(500);
                                    } else if(res === 'no') {
                                            growthGrid1.reset();
                                            growthStore1.clearData();
                                            growthStore1.setToolbarButtons('sub_save5', false);
                                            growthStore1.setToolbarButtons('sub_delete5', false);
                                    }
                                }
                            });
                    } else {
                            growthGrid1.reset();
                            growthStore1.clearData();
                            growthStore1.setToolbarButtons('sub_save5', false);
                            growthStore1.setToolbarButtons('sub_delete5', false);
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '추가',
                tooltip: '추가',
                iconCls: 'icon-new',
                width   : 26,
                height  : 26,
                itemId  : 'sub_newData5',
                handler: function() {
//                    var record      = masterGrid.getSelectedRecord();
                    var compCode    = UserInfo.compCode;
                    var customCode  = farmHouseForm.getValue('CUSTOM_CODE');
                    if(Ext.isEmpty(customCode)) return false;
                    var r = {
                        COMP_CODE       :   compCode,
                        CUSTOM_CODE     :   customCode,
                        APLY_START_DATE :   new Date()
                    };
                    growthGrid1.createRow(r);
                }
            },{
                xtype       : 'uniBaseButton',
                text        : '삭제',
                tooltip : '삭제',
                iconCls : 'icon-delete',
                disabled    : true,
                width       : 26,
                height      : 26,
                itemId      : 'sub_delete5',
                handler : function() {
                    var selRow = growthGrid1.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
	                    if(selRow.phantom === true) {
	                        growthGrid1.deleteSelectedRow();
	                    }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
	                        growthGrid1.deleteSelectedRow();
	                    }
					} else {
						alert(Msg.sMA0256);
						return false;
					}
                }
            },{
                xtype       : 'uniBaseButton',
                text        : '저장',
                tooltip : '저장',
                iconCls : 'icon-save',
                disabled    : true,
                width       : 26,
                height      : 26,
                itemId      : 'sub_save5',
                handler : function() {
                    var inValidRecs = growthStore1.getInvalidRecords();
                    if(inValidRecs.length == 0 )     {
                        var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                            growthStore1.saveStore();
                        });
                        saveTask.delay(500);
                    } else {
                        growthGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
                    }
                }
            }]
        }],

        columns:[
                { dataIndex : 'DOC_ID'           , width: 100, hidden: true     },
                { dataIndex : 'CUSTOM_CODE'      , width: 100, hidden: true     },
                { dataIndex : 'ITEM_CODE'        , width: 100, hidden: true     },
                { dataIndex : 'ITEM_NAME'        , width: 150     },
                { dataIndex : 'DVLY_SEASON'      , width: 100     },
                { dataIndex : 'CULTI_AREA'       , width: 100     },
                { dataIndex : 'REMARK'           , minWidth: 100, flex: 1     }

        ],

        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(!e.record.phantom) {                 //
                    if (UniUtils.indexOf(e.field, ['TYPE', 'CERT_NO', 'CERT_FILE'])){
                        return false;
                    }

                } else {
                    if (UniUtils.indexOf(e.field, ['CERT_FILE'])){
                        return false;
                    }
                }
            },
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//                if(cellIndex == 8) {
//                    fid = record.data.FILE_ID
//                    openPhotoWindow();
//                }
            }
        }
    });


    //농가이력 제배품목2그리드 - S_BCM101T_YP
    var growthGrid2 = Unilite.createGrid('s_bcm100ukrv_ypGrid7', {
        store   : growthStore2,
        border  : true,
        height  : 180,
        width   : 940,
        padding : '0 0 5 0',
        sortableColumns : false,
        excelTitle: '인증서정보',
        uniOpt  :{
            onLoadSelectFirst   : false,
            expandLastColumn    : false,
            useRowNumberer      : true,
            useMultipleSorting  : false
//          enterKeyCreateRow: true                         //마스터 그리드 추가기능 삭제
        },
        dockedItems : [{
            xtype   : 'toolbar',
            dock    : 'top',
            items   : [{
                xtype   : 'uniBaseButton',
                text    : '조회',
                tooltip: '조회',
                iconCls: 'icon-query',
                width   : 26,
                height  : 26,
                itemId  : 'sub_query6',
                handler: function() {
                    //if( me._needSave()) {
                    var toolbar = growthGrid2.getDockedItems('toolbar[dock="top"]');
                    var needSave= !toolbar[0].getComponent('sub_save6').isDisabled();
//                    var record  = masterGrid.getSelectedRecord();
                    if (needSave) {
                        Ext.Msg.show({
                            title   : '확인',
                            msg     : Msg.sMB017 + "\n" + Msg.sMB061,
                            buttons : Ext.Msg.YESNOCANCEL,
                            icon    : Ext.Msg.QUESTION,
                            fn      : function(res) {
                                //console.log(res);
                                if (res === 'yes' ) {
                                    var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                                        growthStore2.saveStore();
                                    });
                                    saveTask.delay(500);
                                } else if(res === 'no') {
                                        growthStore2.loadStoreRecords(farmHouseForm.getValue('CUSTOM_CODE'));
                                }
                            }
                        });
                    } else {
                        growthStore2.loadStoreRecords(farmHouseForm.getValue('CUSTOM_CODE'));
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '신규',
                tooltip: '초기화',
                iconCls: 'icon-reset',
                width   : 26,
                height  : 26,
                itemId  : 'sub_reset6',
                handler: function() {
                    var toolbar = growthGrid2.getDockedItems('toolbar[dock="top"]');
                    var needSave= !toolbar[0].getComponent('sub_save6').isDisabled();
                    if(needSave) {
                            Ext.Msg.show({
                                title:'확인',
                                msg: Msg.sMB017 + "\n" + Msg.sMB061,
                                buttons: Ext.Msg.YESNOCANCEL,
                                icon: Ext.Msg.QUESTION,
                                fn: function(res) {
                                    console.log(res);
                                    if (res === 'yes' ) {
                                            var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                                                growthStore2.saveStore();
                                            });
                                            saveTask.delay(500);
                                    } else if(res === 'no') {
                                            growthGrid2.reset();
                                            growthStore2.clearData();
                                            growthStore2.setToolbarButtons('sub_save6', false);
                                            growthStore2.setToolbarButtons('sub_delete6', false);
                                    }
                                }
                            });
                    } else {
                            growthGrid2.reset();
                            growthStore2.clearData();
                            growthStore2.setToolbarButtons('sub_save6', false);
                            growthStore2.setToolbarButtons('sub_delete6', false);
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '추가',
                tooltip: '추가',
                iconCls: 'icon-new',
                width   : 26,
                height  : 26,
                itemId  : 'sub_newData6',
                handler: function() {
//                    var record      = masterGrid.getSelectedRecord();
                    var compCode    = UserInfo.compCode;
                    var customCode  = farmHouseForm.getValue('CUSTOM_CODE');
                    if(Ext.isEmpty(customCode)) return false;
                    var r = {
                        COMP_CODE       :   compCode,
                        CUSTOM_CODE     :   customCode,
                        APLY_START_DATE :   new Date()
                    };
                    growthGrid2.createRow(r);
                }
            },{
                xtype       : 'uniBaseButton',
                text        : '삭제',
                tooltip : '삭제',
                iconCls : 'icon-delete',
                disabled    : true,
                width       : 26,
                height      : 26,
                itemId      : 'sub_delete6',
                handler : function() {
                    var selRow = growthGrid2.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
	                    if(selRow.phantom === true) {
	                        growthGrid2.deleteSelectedRow();
	                    }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
	                        growthGrid2.deleteSelectedRow();
	                    }
					} else {
						alert(Msg.sMA0256);
						return false;
					}
               }
            },{
                xtype       : 'uniBaseButton',
                text        : '저장',
                tooltip : '저장',
                iconCls : 'icon-save',
                disabled    : true,
                width       : 26,
                height      : 26,
                itemId      : 'sub_save6',
                handler : function() {
                    var inValidRecs = growthStore2.getInvalidRecords();
                    if(inValidRecs.length == 0 )     {
                        var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                            growthStore2.saveStore();
                        });
                        saveTask.delay(500);
                    } else {
                        growthGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
                    }
                }
            }]
        }],

        columns:[
                { dataIndex : 'DOC_ID'           , width: 100, hidden: true     },
                { dataIndex : 'CUSTOM_CODE'      , width: 100, hidden: true     },
                { dataIndex : 'ITEM_CODE'        , width: 100, hidden: true     },
                { dataIndex : 'ITEM_NAME'        , width: 150     },
                { dataIndex : 'HIS_DATE'         , width: 100     },
                { dataIndex : 'HIS_CONTENT'      , width: 180     },
                { dataIndex : 'CONFIRM_YN'       , width: 100     },
                { dataIndex : 'REMARK'           , minWidth: 100, flex: 1     }
        ],

        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(!e.record.phantom) {                 //
                    if (UniUtils.indexOf(e.field, ['TYPE', 'CERT_NO', 'CERT_FILE'])){
                        return false;
                    }

                } else {
                    if (UniUtils.indexOf(e.field, ['CERT_FILE'])){
                        return false;
                    }
                }
            },
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//                if(cellIndex == 8) {
//                    fid = record.data.FILE_ID
//                    openPhotoWindow();
//                }
            }
        }
    });

    //농가이력 교육참석현황 - S_BCM105T_YP
    var eduGrid = Unilite.createGrid('s_bcm100ukrv_ypGrid8', {
        store   : eduStore,
        border  : true,
        height  : 180,
        width   : 940,
        padding : '0 0 5 0',
        sortableColumns : false,
        excelTitle: '인증서정보',
        uniOpt  :{
            onLoadSelectFirst   : false,
            expandLastColumn    : false,
            useRowNumberer      : true,
            useMultipleSorting  : false
//          enterKeyCreateRow: true                         //마스터 그리드 추가기능 삭제
        },
        dockedItems : [{
            xtype   : 'toolbar',
            dock    : 'top',
            items   : [{
                xtype   : 'uniBaseButton',
                text    : '조회',
                tooltip: '조회',
                iconCls: 'icon-query',
                width   : 26,
                height  : 26,
                itemId  : 'sub_query7',
                handler: function() {
                    //if( me._needSave()) {
                    var toolbar = eduGrid.getDockedItems('toolbar[dock="top"]');
                    var needSave= !toolbar[0].getComponent('sub_save7').isDisabled();
//                    var record  = masterGrid.getSelectedRecord();
                    if (needSave) {
                        Ext.Msg.show({
                            title   : '확인',
                            msg     : Msg.sMB017 + "\n" + Msg.sMB061,
                            buttons : Ext.Msg.YESNOCANCEL,
                            icon    : Ext.Msg.QUESTION,
                            fn      : function(res) {
                                //console.log(res);
                                if (res === 'yes' ) {
                                    var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                                        eduStore.saveStore();
                                    });
                                    saveTask.delay(500);
                                } else if(res === 'no') {
                                        eduStore.loadStoreRecords(farmHouseForm.getValue('CUSTOM_CODE'));
                                }
                            }
                        });
                    } else {
                        eduStore.loadStoreRecords(farmHouseForm.getValue('CUSTOM_CODE'));
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '신규',
                tooltip: '초기화',
                iconCls: 'icon-reset',
                width   : 26,
                height  : 26,
                itemId  : 'sub_reset7',
                handler: function() {
                    var toolbar = eduGrid.getDockedItems('toolbar[dock="top"]');
                    var needSave= !toolbar[0].getComponent('sub_save7').isDisabled();
                    if(needSave) {
                            Ext.Msg.show({
                                title:'확인',
                                msg: Msg.sMB017 + "\n" + Msg.sMB061,
                                buttons: Ext.Msg.YESNOCANCEL,
                                icon: Ext.Msg.QUESTION,
                                fn: function(res) {
                                    console.log(res);
                                    if (res === 'yes' ) {
                                            var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                                                eduStore.saveStore();
                                            });
                                            saveTask.delay(500);
                                    } else if(res === 'no') {
                                            eduGrid.reset();
                                            eduStore.clearData();
                                            eduStore.setToolbarButtons('sub_save7', false);
                                            eduStore.setToolbarButtons('sub_delete7', false);
                                    }
                                }
                            });
                    } else {
                            eduGrid.reset();
                            eduStore.clearData();
                            eduStore.setToolbarButtons('sub_save7', false);
                            eduStore.setToolbarButtons('sub_delete7', false);
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '추가',
                tooltip: '추가',
                disabled    : true,
                iconCls: 'icon-new',
                width   : 26,
                height  : 26,
                itemId  : 'sub_newData7',
                handler: function() {
//                    var record      = masterGrid.getSelectedRecord();
                    var compCode    = UserInfo.compCode;
                    var customCode  = farmHouseForm.getValue('CUSTOM_CODE');
                    var r = {
                        COMP_CODE       :   compCode,
                        CUSTOM_CODE     :   customCode,
                        APLY_START_DATE :   new Date()
                    };
                    eduGrid.createRow(r);
                }
            },{
                xtype       : 'uniBaseButton',
                text        : '삭제',
                tooltip : '삭제',
                iconCls : 'icon-delete',
                disabled    : true,
                width       : 26,
                height      : 26,
                itemId      : 'sub_delete7',
                handler : function() {
                    var selRow = eduGrid.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
	                    if(selRow.phantom === true) {
	                        eduGrid.deleteSelectedRow();
	                    }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
	                        eduGrid.deleteSelectedRow();
	                    }
					} else {
						alert(Msg.sMA0256);
						return false;
					}
                }
            },{
                xtype       : 'uniBaseButton',
                text        : '저장',
                tooltip : '저장',
                iconCls : 'icon-save',
                disabled    : true,
                width       : 26,
                height      : 26,
                itemId      : 'sub_save7',
                handler : function() {
                    var inValidRecs = eduStore.getInvalidRecords();
                    if(inValidRecs.length == 0 )     {
                        var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                            eduStore.saveStore();
                        });
                        saveTask.delay(500);
                    } else {
                        eduGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                    }
                }
            }]
        }],

        columns:[
                { dataIndex : 'DOC_ID'            , width: 100, hidden: true     },
                { dataIndex : 'CUSTOM_CODE'       , width: 100, hidden: true     },
                { dataIndex : 'EDU_TITLE'         , width: 130     },
                { dataIndex : 'EDU_FR_DATE'       , width: 90     },
                { dataIndex : 'EDU_TO_DATE'       , width: 90     },
                { dataIndex : 'EDU_PLACE'         , width: 110     },
                { dataIndex : 'EDU_CONTENTS'      , width: 220     },
                { dataIndex : 'EDU_GUBUN'         , width: 100     },
                { dataIndex : 'EDU_ORGAN'         , width: 100     },
                { dataIndex : 'REMARK'           , minWidth: 100, flex: 1     }
        ],

        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(!e.record.phantom) {                 //
                    if (UniUtils.indexOf(e.field, ['TYPE', 'CERT_NO', 'CERT_FILE'])){
                        return false;
                    }

                } else {
                    if (UniUtils.indexOf(e.field, ['CERT_FILE'])){
                        return false;
                    }
                }
            },
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//                if(cellIndex == 8) {
//                    fid = record.data.FILE_ID
//                    openPhotoWindow();
//                }
            }
        }
    });

	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm',
		api			: {
			submit	: s_bcm100ukrv_ypService.photoUploadFile
		},
		items		: [{
				xtype		: 'filefield',
				buttonOnly	: false,
				fieldLabel	: '사진',
				flex		: 1,
				name		: 'photoFile',
				id			: 'photoFile',
				buttonText	: '파일선택',
				width		: 270,
				labelWidth	: 70
			}
		]
	});

	function openUploadWindow() {
		if(!uploadWin) {
			uploadWin = Ext.create('Ext.window.Window', {
				title		: '사진등록',
				closable	: false,
				closeAction	: 'hide',
				modal		: true,
				resizable	: true,
				width		: 300,
				height		: 100,
				layout		: {
					type	: 'fit'
				},
				items		: [
					photoForm,
					{
						xtype		: 'uniDetailForm',
						itemId		: 'photoForm',
						disabled	: false,
						fileUpload	: true,
						api			: {
							submit: s_bcm100ukrv_ypService.photoUploadFile
						},
						items		:[{
						 	xtype		: 'filefield',
							fieldLabel	: '사진',
							name		: 'photoFile',
							buttonText	: '파일선택',
							buttonOnly	: false,
							labelWidth	: 70,
							flex		: 1,
							width		: 270
						}]
					}
				],
				listeners : {
					beforeshow: function( window, eOpts)	{
 						var toolbar	= certInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
						var record = certInfoGrid.getSelectedRecord();

						if (needSave) {
							if(Ext.isEmpty(record.data.TYPE) || Ext.isEmpty(record.data.CERT_NO) || Ext.isEmpty(record.data.APLY_START_DATE) || Ext.isEmpty(record.data.APLY_END_DATE)){
								alert('필수입력사항을 입력하신 후 사진을 올려주세요.');
								return false;
							}
						} else {
							if (Ext.isEmpty(record)) {
								alert('고객 인증정보를 입력하신 후, 사진을 업로드 하시기 바랍니다.');
								return false;
							}
						}
					},
					show: function( window, eOpts)	{
						window.center();
					}
				},
				afterSuccess: function()	{
					var record	= masterGrid.getSelectedRecord();
					certInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
					this.afterSavePhoto();
				},
				afterSavePhoto: function()	{
					var photoForm = uploadWin.down('#photoForm');
					photoForm.clearForm();
					uploadWin.hide();
				},
				tbar:['->',{
					xtype	: 'button',
					text	: '올리기',
					handler	: function()	{
						var photoForm	= uploadWin.down('#photoForm');
						var toolbar		= certInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave	= !toolbar[0].getComponent('sub_save4').isDisabled();

						if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
							alert('업로드 할 파일을 선택하십시오.');
							return false;
						}

						//jpg파일만 등록 가능
						var filePath		= photoForm.getValue('photoFile');
						var fileExtension	= filePath.lastIndexOf( "." );
						var fileExt			= filePath.substring( fileExtension + 1 );

						if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
							alert('이미지 파일(jpg, png, bmp)또는 pdf파일만 업로드 할 수 있습니다.');
							return false;
						}


						if(needSave)	{
							gsNeedPhotoSave = needSave;
							certInfoStore.saveStore();

						} else {
							fnPhotoSave();
						}
					}
				},{
					xtype	: 'button',
					text	: '닫기',
					handler	: function()	{
//						var photoForm = uploadWin.down('#photoForm').getForm();
//						if(photoForm.isDirty())	{
//							if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))	{
//								var config = {
//									success : function()	{
//										// TODO: fix it!!!
//										uploadWin.afterSavePhoto();
//									}
//								}
//								UniAppManager.app.onSaveDataButtonDown(config);
//
//							}else{
								// TODO: fix it!!!
								uploadWin.afterSavePhoto();
//							}
//
//						} else {
							uploadWin.hide();
//						}
					}
				}]
			});
		}
		uploadWin.show();
	}

	function openPhotoWindow() {
		photoWin = Ext.create('widget.uniDetailWindow', {
			title		: '미리보기',
			modal		: true,
			resizable	: true,
			closable	: false,
			width		: '80%',
			height		: '100%',
			layout		: {
				type	: 'fit'
			},
			closeAction	: 'destroy',
			items		: [{
				xtype		: 'uniDetailForm',
				itemId		: 'downForm',
				url			: CPATH + "/fileman/downloadCertImage/" + fid,
				layout		: {type: 'uniTable', columns:'1'},
				standardSubmit: true,
				disabled	: false,
				autoScroll	: true,
				items		: [{
					xtype	: 'image',
					itemId	: 'photView',
					autoEl	: {
						tag: 'img',
						src: CPATH+'/resources/images/human/noPhoto.png'
					}
	  			}]
			}],
			listeners : {
				beforeshow: function( window, eOpts)	{
					window.down('#photView').setSrc(CPATH+'/fileman/downloadCertImage/' + fid);
				},
				show: function( window, eOpts)	{
					window.center();
				}
			},
			tbar:['->',{
				xtype	: 'button',
				text	: '다운로드',
				handler	: function() {
					photoWin.down('#downForm').submit({
						success:function(comp, action)  {
							Ext.getBody().unmask();
						},
						failure: function(form, action){
							Ext.getBody().unmask();
						}
					});
				}
			},{
				xtype	: 'button',
				text	: '닫기',
				handler	: function()	{
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}




	var farmHousePhotoForm = Ext.create('Unilite.com.form.UniDetailForm',{
        xtype       : 'uniDetailForm',
        disabled    : false,
        fileUpload  : true,
        itemId      : 'farmHousePhotoForm',
        api         : {
            submit  : s_bcm100ukrv_ypService.farmHousePhotoUploadFile
        },
        items       : [{
                xtype       : 'filefield',
                buttonOnly  : false,
                fieldLabel  : '사진',
                flex        : 1,
                name        : 'photoFile',
                id          : 'photoFile2',
                buttonText  : '파일선택',
                width       : 270,
                labelWidth  : 70
            }
        ]
    });

    function openFarmHouseUploadWindow() {
        if(!uploadFarmHouseWin) {
            uploadFarmHouseWin = Ext.create('Ext.window.Window', {
                title       : '사진등록',
                closable    : false,
                closeAction : 'hide',
                modal       : true,
                resizable   : true,
                width       : 300,
                height      : 100,
                layout      : {
                    type    : 'fit'
                },
                items       : [
                    farmHousePhotoForm,
                    {
                        xtype       : 'uniDetailForm',
                        itemId      : 'farmHousePhotoForm',
                        disabled    : false,
                        fileUpload  : true,
                        api         : {
                            submit: s_bcm100ukrv_ypService.farmHousePhotoUploadFile
                        },
                        items       :[{
                            xtype       : 'filefield',
                            fieldLabel  : '사진',
                            name        : 'photoFile',
                            buttonText  : '파일선택',
                            buttonOnly  : false,
                            labelWidth  : 70,
                            flex        : 1,
                            width       : 270,
                            reset  : function () {
                             var me = this,
                             clear = me.clearOnSubmit;
                             if (me.rendered) {
                              me.button.reset(clear);
                              me.fileInputEl = me.button.fileInputEl;
                              me.fileInputEl.set({
                               accept: 'image/jpeg, image/png'
                              });
                              if (clear) {
                               me.inputEl.dom.value = '';
                              }
                              me.callParent();
                             }
                            },
                            listeners:{
                             afterrender:function(cmp){
                              cmp.fileInputEl.set({
                               accept:'image/jpeg, image/png'
                              });
                             }
                            }
                        }]
                    }
                ],
                listeners : {
                    beforeshow: function( window, eOpts)    {
//                        var toolbar = certInfoGrid.getDockedItems('toolbar[dock="top"]');
//                        var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
//                        var record = certInfoGrid.getSelectedRecord();
//
//                        if (needSave) {
//                            if(Ext.isEmpty(record.data.TYPE) || Ext.isEmpty(record.data.CERT_NO) || Ext.isEmpty(record.data.APLY_START_DATE) || Ext.isEmpty(record.data.APLY_END_DATE)){
//                                alert('필수입력사항을 입력하신 후 사진을 올려주세요.');
//                                return false;
//                            }
//                        } else {
//                            if (Ext.isEmpty(record)) {
//                                alert('고객 인증정보를 입력하신 후, 사진을 업로드 하시기 바랍니다.');
//                                return false;
//                            }
//                        }
                    },
                    show: function( window, eOpts)  {
                        window.center();
                    }
                },
                afterSuccess: function()    {
                    var record  = masterGrid.getSelectedRecord();
                    certInfoStore.loadStoreRecords(record.get('CUSTOM_CODE'));
                    this.afterSavePhoto();
                },
                afterSavePhoto: function()  {
                    var farmHousePhotoForm = uploadFarmHouseWin.down('#farmHousePhotoForm');
                    farmHousePhotoForm.clearForm();
                    uploadFarmHouseWin.hide();
                },
                tbar:['->',{
                    xtype   : 'button',
                    text    : '올리기',
                    handler : function()    {
                        var farmHousePhotoForm   = uploadFarmHouseWin.down('#farmHousePhotoForm');
//                        var toolbar     = certInfoGrid.getDockedItems('toolbar[dock="top"]');
//                        var needSave    = !toolbar[0].getComponent('sub_save4').isDisabled();

                        if (Ext.isEmpty(farmHousePhotoForm.getValue('photoFile'))) {
                            alert('업로드 할 파일을 선택하십시오.');
                            return false;
                        }

                        //jpg파일만 등록 가능
                        var filePath        = farmHousePhotoForm.getValue('photoFile');
                        var fileExtension   = filePath.lastIndexOf( "." );
                        var fileExt         = filePath.substring( fileExtension + 1 );

                        if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp') {
                            alert('이미지 파일(jpg, png, bmp)만 업로드 할 수 있습니다.');
                            return false;
                        }

//                        if(needSave)    {
//                            gsNeedPhotoSave = needSave;
//                            certInfoStore.saveStore();
//
//                        } else {
                            fnFarmHousePhotoSave();
//                        }
                    }
                },{
                    xtype   : 'button',
                    text    : '닫기',
                    handler : function()    {
//                      var farmHousePhotoForm = uploadWin.down('#farmHousePhotoForm').getForm();
//                      if(farmHousePhotoForm.isDirty()) {
//                          if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))   {
//                              var config = {
//                                  success : function()    {
//                                      // TODO: fix it!!!
//                                      uploadWin.afterSavePhoto();
//                                  }
//                              }
//                              UniAppManager.app.onSaveDataButtonDown(config);
//
//                          }else{
                                // TODO: fix it!!!
                                uploadFarmHouseWin.afterSavePhoto();
//                          }
//
//                      } else {
                            uploadFarmHouseWin.hide();
//                      }
                    }
                }]
            });
        }
        uploadFarmHouseWin.show();
    }








	/** 상세 조회(Detail Form Panel)
	* @type
	*/
	var detailForm = Unilite.createForm('detailForm', {
		masterGrid	: masterGrid,
		region		: 'center',
		flex		: 4,
		autoScroll	: true,
		border		: false,
		padding		: '0 0 0 1',
		defaults	: { padding: '10 15 15 10'},
		uniOpt:{
			store : masterStore
		},
		layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType	: 'uniFieldset',
		defineEvent	: function(){
			var me = this;
			me.getField('CUSTOM_NAME').on ('blur', function( field, blurEvent, eOpts )	{
				if(me.getValue('CUSTOM_FULL_NAME') == "")
					me.setValue('CUSTOM_FULL_NAME',this.getValue());
			});
		},
		items : [{
			title		: '기본정보',
			defaultType	: 'uniTextfield',
			flex		: 1,
			defaults	: { labelWidth: 120},
			layout		: {
				type		: 'uniTable',
				tableAttrs	: { style: { width: '100%' } },
//				tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
				columns		: 4
			},
			items :[{
				fieldLabel	: '코드',
				name		: 'CUSTOM_CODE' ,
//				allowBlank	: false,
				readOnly	: true,
				focusable	: false
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '법인/개인',
				name		: 'BUSINESS_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B016'
			},{
				fieldLabel	: '구분',
				name		: 'CUSTOM_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B015' ,
				allowBlank	: false
			},{
				fieldLabel	: '거래처(약명)',
				name		: 'CUSTOM_NAME',
				allowBlank	: false,
				listenersX	:{blur : function(){
					var frm = Ext.getCmp('detailForm');
					if(frm.getValue('CUSTOM_FULL_NAME') == "")
						frm.setValue('CUSTOM_FULL_NAME',this.getValue());
				}}
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '사업자번호',
				name		: 'COMPANY_NUM'
			},{
				fieldLabel	: '업태',
				name		: 'COMP_TYPE'
			},{
				fieldLabel	: '거래처(약명1)',
				name		: 'CUSTOM_NAME1'
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '대표자명',
				name		: 'TOP_NAME'
			},{
				fieldLabel	: '업종',
				name		: 'COMP_CLASS'
			},{
				fieldLabel	: '거래처(약명2)',
				name		: 'CUSTOM_NAME2'
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '주민등록번호',
				name		: 'TOP_NUM_EXPOS',
				xtype		: 'uniTextfield',
				readOnly	: true,
				focusable	: false,
				listeners	: {
					afterrender:function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick	: function(event, elm)	{
					detailForm.openCryptRepreNoPopup();
				}
			},{
				fieldLabel	: '주민번호',
				name		: 'TOP_NUM',
				hidden		: true
			},{
				fieldLabel	: '고객분류',
				name		: 'AGENT_TYPE',
				xtype		: 'uniCombobox',
				allowBlank	: false,
				comboType	: 'AU',
				comboCode	: 'B055'
			},{
				fieldLabel	: '거래처(전명)',
				name		: 'CUSTOM_FULL_NAME',
				allowBlank	: false
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '지역',
				name		: 'AREA_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B056'
			},{
				fieldLabel	: '출하회',
				name		: 'DELIVERY_UNION',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z003'
			},{
				fieldLabel	: '거래시작일',
				name		: 'START_DATE' ,
				xtype		: 'uniDatefield',
				allowBlank	: false
			},{
				xtype		: 'component',
				width		: 30
			},{
				fieldLabel	: '거래중단일',
				name		: 'STOP_DATE',
				xtype		: 'uniDatefield'
			},{
				fieldLabel	: '사용여부',
				name		: 'USE_YN',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B010',
				value		: 'Y' ,
				width		: 250,
				allowBlank	: false
			},{
				fieldLabel	: '사업자번호변경여부',
				name		: 'CUST_CHK',
				hidden		: true
			},{
				fieldLabel	: '주민번호변경여부',
				name		: 'SSN_CHK', hidden:true
			}]
		},{
			title		: '업무정보',
			defaultType	: 'uniTextfield',
			flex		: 1,
			defaults	: { labelWidth: 120, enforceMaxLength: true},
			layout		: {
				type		: 'uniTable',
				tableAttrs	: { style: { width: '100%' } },
//				tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
				columns		: 3
			},

			items :[{
				fieldLabel	: '국가코드',
				name		: 'NATION_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B012'
			},{
				fieldLabel	: '계산서종류',
				name		: 'BILL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A022'
			},{
				fieldLabel	: '여신(담보)액',
				name		: 'TOT_CREDIT_AMT',
				xtype		: 'uniNumberfield'
			},{
				fieldLabel	: '기준화폐',
				name		: 'MONEY_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B004'
			},{
				fieldLabel	: '결제방법',
				name		: 'SET_METH',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B038'
			},{
				fieldLabel	: '신용여신액',
				name		: 'CREDIT_AMT',
				xtype		: 'uniNumberfield'
			},{
				fieldLabel	: '세액포함여부',
				name		: 'TAX_TYPE',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B030',
				value		: '1' ,
				width		: 250,
				allowBlank	: false
			},{
				fieldLabel	: '결제조건',
				name		: 'RECEIPT_DAY',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B034'
			},{
				fieldLabel	: '신용여신만료일',
				name		: 'CREDIT_YMD',
				xtype		: 'uniDatefield'
			},{
				fieldLabel	: '세액계산법',
				name		: 'TAX_CALC_TYPE',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B051',
				value		: '1',
				width		: 250,
				allowBlank	: false
			},{
				fieldLabel	: '마감종류',
				name		: 'TRANS_CLOSE_DAY',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B033'
			},{
				fieldLabel	: '미수관리방법',
				name		: 'COLLECT_CARE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B057'
			},{
				fieldLabel	: '원미만계산',
				name		: 'WON_CALC_BAS',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B017'
			},{
				fieldLabel	: '수금(예정)일',
				name		: 'COLLECT_DAY',
				xtype		: 'uniNumberfield'
			},{
				fieldLabel	: '주영업담당',
				name		: 'BUSI_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010'
			},{
				fieldLabel	: '세율',
				name		: 'VAT_RATE',
				xtype		: 'uniNumberfield',
				suffixTpl	: '&nbsp;%'
			},{
				fieldLabel	: '여신적용여부',
				name		: 'CREDIT_YN',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B010',
				value		: 'N',
				width		: 250,
				allowBlank:false
			},{
				fieldLabel	: '카렌더타입',
				name		: 'CAL_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B062'
			},
			Unilite.popup('DEPT',{
				fieldLabel		: '관련부서',
				textFieldName	: 'DEPT_NAME',
				valueFieldName	: 'DEPT_CODE',
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName	: 'TREE_NAME',
				valueFieldWidth	: 57,
				textFieldWidth	: 110,
				listeners		: {
					'onSelected': function(records, type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
							grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
					},
					'onClear':function( type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('DEPT_NAME','');
							grdRecord.set('DEPT_CODE','');
					}
				}
			}),{
				fieldLabel	: '전자문서담당자2',
				name		: 'BILL_PRSN2'
			},{
				fieldLabel	: '전자문서핸드폰2',
				name		: 'HAND_PHON2'
			},{
				fieldLabel	: '전자문서Email2',
				name		: 'BILL_MAIL_ID2'
			},{
				fieldLabel	: '전자문서구분',
				name		: 'BILL_MEM_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S051'
			},{
				fieldLabel	: '정기결제여부',
				name		: 'R_PAYMENT_YN',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B010',
				value		: 'N',
				width		: 250,
				allowBlank	: false
			},{
				fieldLabel	: '발주형태',
				name		: 'PURCH_TYPE',
				xtype		: 'uniRadiogroup',
				comboType	: 'AU',
				comboCode	: 'B051',
				value		: '1',
				width		: 250,
				allowBlank	: false
			},{
				fieldLabel	: '약어',
				name		: 'CHANNEL',
				readOnly	: true,
				maxLength	: 2,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						var record = masterGrid.getSelectedRecord();
						newValue = newValue.toUpperCase();
						if(newValue.length == 2) {
						/* 	for (var i=0; i<newValue.length; i++) {
								var chk = newValue.substring(i,i+1);
								if(!chk.match(/[a-z]|[A-Z]/)) {
									detailForm.setValue('CHANNEL', '');
									alert(Msg.sMH1441);
									return false;
								}
							} */
							if(record && gsChkFlag == 'Y') {
								Ext.getBody().mask();
								var param = {
									'CHANNEL'		: newValue,
									'CUSTOM_CODE'	: masterGrid.getSelectedRecord().get('CUSTOM_CODE')
								}
								s_bcm100ukrv_ypService.checkCh(param, function(provider, response)	{
									Ext.getBody().unmask();
									if(!Ext.isEmpty(provider) && provider['CNT'] > 0){
										record.set('CHANNEL','');
										detailForm.setValue('CHANNEL', '');
										alert(Msg.sMS004);
										return false;
									} else {
										detailForm.setValue('CHANNEL', newValue);
										return true;
									}
								});
							}
							gsChkFlag = 'Y';
						}
					},
					blur: function(field, event, eOpts )	{
						if(field.value.length != 2 && field.value != '') {
							detailForm.setValue('CHANNEL', '');
							alert('약어는 두 자리 영문으로 입력하세요.');
						}
					}
				}
			}/*,{
				fieldLabel	: '운송방법',
				name		: 'DELIVERY_METH',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S051',
				colspan		: 2
			 }*/]
		},{
			title		: '일반정보',
			flex		: 1,
			defaultType	: 'uniTextfield',
			defaults	: { labelWidth: 120},
			layout		: {
				type		: 'uniTable',
				tableAttrs	: { style: { width: '100%' } },
//				tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
				columns		: 3
			},
			items :[
				Unilite.popup('ZIP',{
					showValue		: false,
					textFieldName	: 'ZIP_CODE',
					DBtextFieldName	: 'ZIP_CODE',
					listeners		: {
						'onSelected': {fn: function(records, type){
							var frm = Ext.getCmp('detailForm');
							frm.setValue('ADDR1', records[0]['ZIP_NAME']);
							frm.setValue('ADDR2', records[0]['ADDR2']);
						},
						scope: this
						},
						'onClear' : function(type)	{
								var frm = Ext.getCmp('detailForm');
							frm.setValue('ADDR1', '');
							frm.setValue('ADDR2', '');
						}
					}
			}),{
				fieldLabel	: '홈페이지',
				name		: 'HTTP_ADDR',
				labelWidth	: 138
			},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '집계거래처', /* id:'MANAGE_CUSTOM', */
					valueFieldName	: 'MANAGE_CUSTOM',
					textFieldName	: 'MCUSTOM_NAME',
					DBvalueFieldName: 'CUSTOM_CODE',
					DBtextFieldName	: 'CUSTOM_NAME',
					valueFieldWidth	: 50,
					textFieldWidth	: 100,
					labelWidth		: 138,
					listeners		: {
						'onSelected': function(records, type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
							grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						'onClear':function( type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('MANAGE_CUSTOM','');
							grdRecord.set('MCUSTOM_NAME','');
						}
					}
			}),{
				fieldLabel	: '우편주소',
				name		: 'ADDR1' ,
				id			: 'ADDR1_F'
			},{
				fieldLabel	: 'E-mail',
				name		: 'MAIL_ID',
				labelWidth	: 138
			},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '수금거래처',
					valueFieldName	: 'COLLECTOR_CP',
					textFieldName	: 'COLLECTOR_CP_NAME',
					DBvalueFieldName: 'CUSTOM_CODE',
					DBtextFieldName	: 'CUSTOM_NAME',
					valueFieldWidth	: 50,
					textFieldWidth	: 100,
					labelWidth		: 138,
					listeners		: {
						'onSelected': function(records, type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
							grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
						},
						'onClear':function( type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('COLLECTOR_CP','');
							grdRecord.set('COLLECTOR_CP_NAME','');
						}
					}
			}),{
				fieldLabel	: '상세주소',
				name		: 'ADDR2',
				id			: 'ADDR2_F'
			},
				Unilite.popup('BANK',{
					fieldLabel		: '금융기관',
					id				: 'BANK_CODE',
					valueFieldName	: 'BANK_CODE',
					textFieldName	: 'BANK_NAME' ,
					DBvalueFieldName: 'BANK_CODE',
					DBtextFieldName	: 'BANK_NAME',
					valueFieldWidth	: 50,
					textFieldWidth	: 100,
					labelWidth		: 138,
					listeners		: {
						'onSelected': function(records, type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
							grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
						},
						'onClear':function( type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
						}
					}
			}),
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '매출/계산서거래처',
					id				: 'BILL_CUSTOM',
					valueFieldName	: 'BILL_CUSTOM',
					textFieldName	: 'BILL_CUSTOM_NAME' ,
					DBvalueFieldName: 'CUSTOM_CODE',
					DBtextFieldName	: 'CUSTOM_NAME',
					valueFieldWidth	: 50,
					textFieldWidth	: 100,
					labelWidth		: 138,
					listeners		: {
						'onSelected': function(records, type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
							grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						'onClear':function( type){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('BILL_CUSTOM','');
							grdRecord.set('BILL_CUSTOM_NAME','');
						}
					}
			}),{
				fieldLabel	: '전화번호',
				name		: 'TELEPHON'
			},{
				fieldLabel	: 'FAX번호',
				name		: 'FAX_NUM',
				labelWidth	: 138
			},{
                xtype: 'radiogroup',
                fieldLabel: '전자세금계산서발행',
                labelWidth      : 138,
                items : [{
                    boxLabel: '정발행',
                    width:80 ,
                    name: 'BILL_PUBLISH_TYPE',
                    inputValue: '1',
                    checked: true
                }, {
                    boxLabel: '역발행',
                    width:80 ,
                    name: 'BILL_PUBLISH_TYPE' ,
                    inputValue: '2'
                }]
            },{
				fieldLabel	: '계좌번호',
				name		: 'BANKBOOK_NUM_EXPOS',
				readOnly	: true,
				focusable	: false,
				listeners	: {
					afterrender:function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick	: function(event, elm)	{
					detailForm.openCryptBankAccntPopup();
				}
			},{
				fieldLabel	: '계좌번호',
				name		: 'BANKBOOK_NUM',
				xtype		: 'uniTextfield',
				maxLength	: 50,
				hidden		: true
			},{
				fieldLabel	: '예금주',
				name		: 'BANKBOOK_NAME',
				labelWidth	: 138,
				colspan		: 2,
				hidden		: false
			},{
				fieldLabel	: '비고',
				name		: 'REMARK',
				xtype		: 'textarea',
				width		: 740,
				height		: 80,
				colspan		: 3
			}]
		},{
			title		: '인증서정보',
			defaultType	: 'uniTextfield',
			layout		: {
				type	: 'uniTable',
				tdAttrs	: {valign:'top'},
				columns	: 3
			},
			items		: [certInfoGrid]
		},{
			title		: '계좌정보',
			defaultType	: 'uniTextfield',
			layout		: {
				type	: 'uniTable',
				tdAttrs	: {valign:'top'},
				columns	: 3
			},
			items		: [accountGrid]
		},{
			title		: '전자문서정보',
			defaultType	: 'uniTextfield',
			layout		: {
				type	: 'uniTable',
				tdAttrs	: {valign:'top'},
				columns	: 3
			},
			items		: [electroInfoGrid]
		}],
		listeners:{
		},
		openCryptBankAccntPopup:function()	{
			var record = this;
			if(this.activeRecord)	{
				var params = {'BANK_ACCOUNT': this.getValue('BANKBOOK_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'};
				Unilite.popupCipherComm('form', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
			}
		},
		openCryptRepreNoPopup:function()	{
			var record = this;
			var params = {'REPRE_NUM':this.getValue('TOP_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
			Unilite.popupCipherComm('form', record, 'TOP_NUM_EXPOS', 'TOP_NUM', params);
		}
	}); // detailForm









	/** 상세 조회(Detail Form Panel)
    * @type
    */
    var farmHouseForm = Unilite.createForm('farmHouseForm', {
        masterGrid  : masterGrid,
        region      : 'center',
        flex        : 4,
        autoScroll  : true,
        border      : false,
        padding     : '0 0 0 1',
        defaults    : { padding: '10 15 15 10'},
        disabled    : false,
        uniOpt:{
            store : masterStore
        },
        layout      : {type: 'uniTable', columns: 2, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
        defaultType : 'uniFieldset',
        defineEvent : function(){
            var me = this;
            me.getField('CUSTOM_NAME').on ('blur', function( field, blurEvent, eOpts )  {
                if(me.getValue('CUSTOM_FULL_NAME') == "")
                    me.setValue('CUSTOM_FULL_NAME',this.getValue());
            });
        },
        items : [{
            title       : '기본정보',
            defaultType : 'uniTextfield',
            flex        : 1,
            defaults    : { labelWidth: 120},
            layout      : {
                type        : 'uniTable',
                tableAttrs  : { style: { width: '100%' } },
//              tdAttrs     : {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
                columns     : 2
            },
            colspan: 2,
            items :[{
                fieldLabel  : '거래처 코드',
                name        : 'CUSTOM_CODE' ,
//              allowBlank  : false,
                readOnly    : true,
                focusable   : false
            },{
                fieldLabel  : '주요품목',
                name        : 'ITEM_NAME'
            },{
                fieldLabel  : '농가명',
                readOnly    : true,
                name        : 'CUSTOM_NAME'
            },{
                fieldLabel  : '재배면적',
                xtype       : 'uniNumberfield',
                name        : 'CULTI_AREA',
                suffixTpl   : 'm²'
            },{
                fieldLabel  : '재배지',
                name        : 'CULTI_ADDR',
                width       : 450
            },{
                name        : 'UPDATE_DB_TIME',
                hidden      : true
            },{
                name        : 'S_COMP_CODE',
                hidden      : true
            }]
        },{
            xtype:'component',
            itemId:'custImg',
            width:180,
            height: 220,
            autoEl: {
                tag: 'img',
                src: CPATH+'/resources/images/human/noPhoto.png',
                cls:'photo-wrap'
            },
            listeners   : {
                click : {
                    element : 'el',
                    fn      : function( e, t, eOpts )   {
                        openFarmHouseUploadWindow();
                    }
                }
            }
        },{
            title       : '재배품목',
            defaultType : 'uniTextfield',
            layout      : {
                type    : 'uniTable',
                tdAttrs : {valign:'top'},
                columns : 3
            },
            items       : [growthGrid1]
        },{
//            title       : '재배품목',
            defaultType : 'uniTextfield',
            layout      : {
                type    : 'uniTable',
                tdAttrs : {valign:'top'},
                columns : 3
            },
            colspan: 2,
            items       : [growthGrid2]
        },{
            title       : '교육참석현황',
            defaultType : 'uniTextfield',
            layout      : {
                type    : 'uniTable',
                tdAttrs : {valign:'top'},
                columns : 3
            },
            colspan: 2,
            items       : [eduGrid]
        }],
        listeners:{
        },
        openCryptBankAccntPopup:function()  {
            var record = this;
            if(this.activeRecord)   {
                var params = {'BANK_ACCNT_CODE': this.getValue('BANKBOOK_NUM')};
                Unilite.popupCryptBankAccnt('form', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
            }
        },
        openCryptRepreNoPopup:function()    {
            var record = this;
            var params = {'REPRE_NO':this.getValue('TOP_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
            Unilite.popupCipherComm('form', record, 'TOP_NUM_EXPOS', 'TOP_NUM', params);
        }
    }); // farmHouseForm










	var tab = Unilite.createTabPanel('s_bcm100ukrv_ypTab',{
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '기본',
				xtype	: 'container',
				itemId	: 's_bcm100ukrv_ypTab1',
				border	: true,
				layout	: 'border',
				items	: [
					masterGrid, detailForm
				]
			},{
				title	: '전체',
				xtype	: 'container',
				itemId	: 's_bcm100ukrv_ypTab2',
				border	: true,
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			},{
                title   : '농가이력',
                xtype   : 'container',
                itemId  : 's_bcm100ukrv_ypTab3',
                border  : true,
                layout  : {type:'vbox', align:'stretch'},
                items:[
                    farmHouseForm
                ]
            }
		],
		listeners:{
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{},
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard == oldCard) {
					return false;
				}
				if(newCard.getItemId() == 's_bcm100ukrv_ypTab3')	{
				    if(!Ext.isEmpty(farmHouseForm.getValue('CUSTOM_CODE'))){
                        farmHouseForm.down('#custImg').getEl().dom.src=CPATH+'/uploads/farmHouseImages/'+ farmHouseForm.getValue('CUSTOM_CODE') + '?_dc=' + gsDc;
                        gsDc++
				    }
				}
			}
		}
	});



	Unilite.Main({
		id		: 's_bcm100ukrv_ypApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, panelResult, tab
			]
		}],
		fnInitBinding : function(params) {
			if(BsaCodeInfo.gsHiddenField == 'Y'){
				detailForm.getField('BANKBOOK_NAME').setHidden(true);
				detailForm.getField('BANKBOOK_NUM_EXPOS').setHidden(true);
			}else{
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
			var masterGrid = Ext.getCmp('s_bcm100ukrv_ypGrid');
			masterGrid.downloadExcelXml();
		},

		onQueryButtonDown : function()	{
//			detailForm.clearForm ();
			gsChkFlag = 'N';
			var activeTabId = tab.getActiveTab().getItemId();
            if(activeTabId == 's_bcm100ukrv_ypTab3') {
                var customCode = farmHouseForm.getValue('CUSTOM_CODE');
                if(!Ext.isEmpty(customCode)){
                    growthStore1.loadStoreRecords(customCode);
                    growthStore2.loadStoreRecords(customCode);
                    eduStore.loadStoreRecords(customCode);
                }else{
//                    masterStore.loadStoreRecords();
                }
            }else{
                masterStore.loadStoreRecords();
            }

		},
		onNewDataButtonDown : function()	{
			masterGrid.createRow(null, null, masterGrid.getStore().getCount()-1);
//			openDetailWindow(null, true);
		},
		onPrevDataButtonDown:function()	{
			masterGrid.selectPriorRow();
			var activeTabId = tab.getActiveTab().getItemId();
			if(activeTabId == 's_bcm100ukrv_ypTab3') {
                if(!Ext.isEmpty(farmHouseForm.getValue('CUSTOM_CODE'))){
                    farmHouseForm.down('#custImg').getEl().dom.src=CPATH+'/uploads/farmHouseImages/'+ farmHouseForm.getValue('CUSTOM_CODE') + '?_dc=' + gsDc;
                    gsDc++
                }
            }
		},
		onNextDataButtonDown:function()	{
			masterGrid.selectNextRow();
			var activeTabId = tab.getActiveTab().getItemId();
			if(activeTabId == 's_bcm100ukrv_ypTab3') {
                if(!Ext.isEmpty(farmHouseForm.getValue('CUSTOM_CODE'))){
                    farmHouseForm.down('#custImg').getEl().dom.src=CPATH+'/uploads/farmHouseImages/'+ farmHouseForm.getValue('CUSTOM_CODE') + '?_dc=' + gsDc;
                    gsDc++
                }
            }
		},

		onSaveDataButtonDown: function (config) {
			//필수 입력값 체크
			if (!detailForm.getInvalidMessage()) {
				return false;
			}
			masterStore.saveStore(config);
		},

		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true)	{
				masterGrid.deleteSelectedRow();

			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},

		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			farmHouseForm.clearForm();
			masterGrid.getStore().loadData({});
			growthGrid1.getStore().loadData({});
            growthGrid2.getStore().loadData({});
            eduGrid.getStore().loadData({});

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
			masterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		},
		confirmSaveData: function()	{
			if(masterStore.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown();
				} else {
					this.rejectSave();
				}
			}
		}
	});	// Main



	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		forms	: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			/* 거래처코드는 자동채번
  			if(fieldName=='CUSTOM_CODE')	{
				Ext.getBody().mask();
				var param = {
					'CUSTOM_CODE':newValue
				}
				var currentRecord = record;
				s_bcm100ukrv_ypService.chkPK(param, function(provider, response)	{
					Ext.getBody().unmask();
					console.log('provider', provider);
					if(!Ext.isEmpty(provider) && provider['CNT'] > 0){
						alert(Msg.fSbMsgZ0049);
						currentRecord.set('CUSTOM_CODE','');
					}
				});
			} else */if( fieldName == 'CUSTOM_NAME' ) {		// 거래처(약명)
				if(newValue == '')	{
					rv = Msg.sMB083;
				}else {
					if(record.get('CUSTOM_FULL_NAME') == '')	{
						record.set('CUSTOM_FULL_NAME',newValue);
					}
				}
			} else if( fieldName == 'COMPANY_NUM') { 		// '사업자번호'
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
			}*/ else if( fieldName == "MONEY_UNIT") { 			// 기준화폐
				if(UserInfo.currency == newValue) {
					record.set('CREDIT_YN', 'Y');
				}else {
					record.set('CREDIT_YN', 'N');
				}
			} else if( fieldName == "CREDIT_YN" ) {			// 여신적용여부
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
			} else if( fieldName == "TOT_CREDIT_AMT") {		// 여신(담보)액
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




	Unilite.createValidator('validator02', {
		store	: masterStore,
		grid	: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "CHANNEL"	:
					var record = masterGrid2.getSelectedRecord();
					newUpperValue = newValue.toUpperCase();
					if(newValue.length == 2) {
						for (var i=0; i<newValue.length; i++) {
							var chk = newValue.substring(i,i+1);
							if(!chk.match(/[a-z]|[A-Z]/)) {
								record.set('CHANNEL', oldValue);
								detailForm.setValue('CHANNEL', oldValue);
								rv = Msg.sMH1441;
								break;
							}
						}
						if(rv == true && !Ext.isEmpty(newValue)) {
							Ext.getBody().mask();
							var param = {
								'CHANNEL'		: newValue,
								'CUSTOM_CODE'	: record.get('CUSTOM_CODE')
							}
							s_bcm100ukrv_ypService.checkCh(param, function(provider, response)	{
								Ext.getBody().unmask();
								gsChkFlag = 'N';
								if(!Ext.isEmpty(provider) && provider['CNT'] > 0){
									record.set('CHANNEL','');
									detailForm.setValue('CHANNEL', '');
									alert( Msg.sMS004 );
									return false;

								} else {
									record.set('CHANNEL', newUpperValue);
									detailForm.setValue('CHANNEL', newUpperValue);
									rv = false
								}
							});
						}
					} else if(newValue.length != 0) {
						record.set('CHANNEL', oldValue);
						detailForm.setValue('CHANNEL', oldValue);
						rv = '약어는 두 자리 영문으로 입력하세요.';
					}
				break;
			}
			return rv;
		}
	}); // validator


	function fnPhotoSave() {														//이미지 등록
		//조건에 맞는 내용은 적용 되는 로직
		var record	= certInfoGrid.getSelectedRecord();
		var photoForm	= uploadWin.down('#photoForm').getForm();
		var param		= {
			CUSTOM_CODE	: record.data.CUSTOM_CODE,
			CERT_NO		: record.data.CERT_NO,
			TYPE		: record.data.TYPE
		}

		photoForm.submit({
			params	: param,
			waitMsg	: 'Uploading your files...',
			success	: function(form, action)	{
				uploadWin.afterSuccess();
				gsNeedPhotoSave = false;
			}
		});
	}

	function fnFarmHousePhotoSave() {                                                       //농가이력 이미지 등록
        //조건에 맞는 내용은 적용 되는 로직
//        var record  = certInfoGrid.getSelectedRecord();
        var farmHousePhotoForm   = uploadFarmHouseWin.down('#farmHousePhotoForm').getForm();
        var param       = {
            CUSTOM_CODE : farmHouseForm.getValue('CUSTOM_CODE')
        }
        farmHousePhotoForm.submit({
            params  : param,
            waitMsg : 'Uploading your files...',
            success : function(form, action)    {
//                farmHouseForm.afterSuccess();
                gsNeedPhotoSave = false;
//                farmHouseForm.down('#custImg').setSrc(CPATH+'/fileman/downloadCertImage/' + fid);
//                farmHouseForm.setValue('UPDATE_DB_TIME', UniDate.get('today'));
                uploadFarmHouseWin.afterSuccess();
                farmHouseForm.down('#custImg').getEl().dom.src=CPATH+'/uploads/farmHouseImages/'+ farmHouseForm.getValue('CUSTOM_CODE') + '?_dc=' + gsDc;
                gsDc++
            }
        });
    }

}; // main
</script>


