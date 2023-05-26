<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx170ukr"  >
   <t:ExtComboStore comboType="BOR120" pgmId="atx170ukr" />         <!-- 사업장 -->
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
	gsAtx110UkrLink: '${gsAtx110UkrLink}',
//	gsBillYN: ${gsBillYN}
};

function appMain() {
	var newYN_ISSUE	= 0;																//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다 (중복수행 방지를 위해 panelResult에서만 처리)
	var totAmtI		= 0;																//선택된 row 합계
	var allTotAmtI	= 0;																//전송여부가 "전송"일 때, 조회된 데이터 전체 합계 
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'atx170ukrService.runProcedure',
            syncAll	: 'atx170ukrService.callProcedure'
		}
	});	

	
	/* Model 정의 
    * @type 
    */
	Unilite.defineModel('atx170ukrModel', {												//웹캐시용 모델
		fields: [  	 
			{name: 'TRANSYN_NAME' 					, text: '전송(웹캐시)' 			, type: 'string' },
			{name: 'STAT_CODE' 						, text: '상태'				, type: 'string' 	, comboType: 'AU' , comboCode: 'S080'},
			{name: 'STS'							, text: '상태' 				, type: 'string' },
			{name: 'WEB_TAXBILL'					, text: '상세조회' 			, type: 'string' },
			{name: 'CRT_LOC'						, text: '생성경로' 			, type: 'string' 	, comboType: 'AU' , comboCode: 'S099'},
			{name: 'BILL_FLAG'						, text: '세금계산서구분' 		, type: 'string' 	, comboType: 'AU' , comboCode: 'S096'},
			{name: 'TAX_TYPE'						, text: '세금계산서종류' 		, type: 'string'	, allowBlank: false},
			{name: 'POPS_CODE'						, text: '영수/청구 구분' 		, type: 'string'	, allowBlank: false 	, comboType: 'AU' , comboCode: 'S076'},
			{name: 'REGS_DATE'						, text: '발행일'				, type: 'uniDate'	, allowBlank: false},
			{name: 'SELR_CORP_NO'					, text: '사업자번호' 			, type: 'string'	, allowBlank: false},		//   '공급자 사업자번호' 
			{name: 'SELR_CORP_NM' 					, text: '업체명' 				, type: 'string'	, allowBlank: false},		//	'공급자 업체명' 	
			{name: 'SELR_CODE'						, text: '종사업자번호' 			, type: 'string' },		//	'공급자 종사업자번호'
			{name: 'SELR_CEO' 						, text: '대표자명' 			, type: 'string'	, allowBlank: false},		// 	'공급자 대표자명' 	
			{name: 'SELR_BUSS_CONS' 				, text: '업태' 				, type: 'string' },		//	'공급자 업태' 		
			{name: 'SELR_BUSS_TYPE' 				, text: '업종' 				, type: 'string' },		//	'공급자 업종' 		
			{name: 'SELR_ADDR' 						, text: '주소' 				, type: 'string'	, allowBlank: false},		//	'공급자 주소' 		
			{name: 'SELR_CHRG_NM' 					, text: '담당자명' 			, type: 'string' },		//	'공급자 담당자명' 	
			{name: 'SELR_CHRG_POST'					, text: '부서명' 				, type: 'string' },		//	'공급자 부서명' 	
			{name: 'SELR_CHRG_TEL'					, text: '전화번호' 			, type: 'string' },		//	'공급자 전화번호' 	
			{name: 'SELR_CHRG_EMAIL'				, text: '이메일주소' 			, type: 'string' },		//	'공급자 이메일주소' 
			{name: 'SELR_CHRG_MOBL'					, text: '휴대폰번호' 			, type: 'string' },		//   '공급자 휴대폰번호' 
			{name: 'CUSTOM_CODE'					, text: '고객코드' 			, type: 'string' },
			{name: 'BUYR_CORP_NM'					, text: '고객명' 				, type: 'string'	, allowBlank: false},
			{name: 'BUYR_GB'						, text: '구분코드' 			, type: 'string' },		//  '공급받는자 구분코드' 	
			{name: 'BUYR_CORP_NO'					, text: '사업자번호' 			, type: 'string'	, allowBlank: false},		//	'공급받는자 사업자번호' 
			{name: 'BUYR_CODE'						, text: '종사업자번호' 			, type: 'string' },		//  '공급받는자 종사업자번호'
			{name: 'BILLTYPENAME'					, text: '계산서유형' 			, type: 'string' },
			{name: 'ISSUE_DETAILS'					, text: '발행내역' 			, type: 'string' },
			{name: 'CHRG_AMT'						, text: '공급가액' 			, type: 'uniPrice'	, allowBlank: false},
			{name: 'TAX_AMT'						, text: '세액' 				, type: 'uniPrice'},
			{name: 'TOTL_AMT'						, text: '합계' 				, type: 'uniPrice'	, allowBlank: false},
			{name: 'BUYR_CEO'						, text: '대표자명' 			, type: 'string'	, allowBlank: false},		// '공급받는자 대표자명' 		
			{name: 'BUYR_BUSS_CONS'					, text: '업태' 				, type: 'string' },		//	'공급받는자 업태' 		
			{name: 'BUYR_BUSS_TYPE'					, text: '업종' 				, type: 'string' },		// '공급받는자 업종' 		
			{name: 'BUYR_ADDR'						, text: '주소' 				, type: 'string'	, allowBlank: false},		//   '공급받는자 주소' 		
			{name: 'BUYR_CHRG_NM1'					, text: '담당자' 				, type: 'string' },		//   '전자문서담당자' 	
			{name: 'BUYR_CHRG_TEL1' 				, text: '전화번호' 			, type: 'string' },		//   '전자문서전화번호' 	
			{name: 'BUYR_CHRG_MOBL1' 				, text: '핸드폰' 				, type: 'string' },		//   '전자문서핸드폰' 	
			{name: 'BUYR_CHRG_EMAIL1' 				, text: 'E-MAIL' 			, type: 'string' },		//    '전자문서E-MAIL' 	
			{name: 'BUYR_CHRG_NM2' 					, text: '담당자2' 			, type: 'string' },		//   '전자문서담당자2' 	
			{name: 'BUYR_CHRG_MOBL2' 				, text: '핸드폰2' 			, type: 'string' },		//   '전자문서핸드폰2' 	
			{name: 'BUYR_CHRG_EMAIL2'				, text: 'E-MAIL2' 			, type: 'string' },		//   '전자문서E-MAIL2' 
			{name: 'BROK_CUSTOM_CODE'				, text: '수탁거래처코드'			, type: 'string' },
			{name: 'BROK_COMPANY_NUM'				, text: '수탁사업자번호'			, type: 'string' },
			{name: 'BROK_TOP_NUM'					, text: '수탁주민번호'			, type: 'string' },
			{name: 'BROK_PRSN_NAME'					, text: '수탁담당자명'			, type: 'string' },
			{name: 'BROK_PRSN_EMAIL'				, text: '수탁이메일'			, type: 'string' },
			{name: 'SEND_DATE'						, text: '전송일시' 			, type: 'uniDate'},
			{name: 'ISSU_SEQNO'						, text: '전자문서번호' 			, type: 'string' },
			{name: 'SELR_MGR_ID3'					, text: '계산서번호'  			, type: 'string' },
			{name: 'SND_STAT'						, text: '메일전송상태'  		, type: 'string' },
			{name: 'RCV_VIEW_YN'					, text: '메일확인여부' 			, type: 'string' },
			{name: 'NOTE1'							, text: '비고' 				, type: 'string' },
			{name: 'MODY_CODE'						, text: '수정코드' 			, type: 'string' },
			{name: 'REQ_STAT_CODE'					, text: '요청상태코드' 			, type: 'string' },
			{name: 'BILL_PUBLISH_TYPE'				, text: '발행 유형 ' 			, type: 'string' },
			{name: 'BILL_TYPE'						, text: '매출/매입구분' 		, type: 'string' },    
			{name: 'SND_MAIL_YN'					, text: 'Email 발행요청유무' 	, type: 'string' },    
			{name: 'SND_SMS_YN'						, text: 'SMS 발행요청유무' 		, type: 'string' },
			{name: 'SND_FAX_YN'						, text: 'FAX 발행요청여부' 		, type: 'string' },    
			{name: 'COMP_CODE'						, text: '법인코드' 			, type: 'string' },    
			{name: 'DIV_CODE'						, text: '사업장코드' 			, type: 'string' },    
			{name: 'SALE_DIV_CODE'					, text: '사업장코드' 			, type: 'string' },
			{name: 'DEL_YN'							, text: '삭제여부' 			, type: 'string' },
			{name: 'REPORT_AMEND_CD'				, text: '신고문서 수정사유 코드' 	, type: 'string' },
			{name: 'BFO_ISSU_ID'					, text: '당초승인번호' 			, type: 'string' },    
			{name: 'ISSU_ID'						, text: '국세청 일련번호' 		, type: 'string' },
			{name: 'ERR_MSG'						, text: '에러메세지' 			, type: 'string' },    
			{name: 'BEFORE_PUB_NUM'					, text: '수정전세금계산번호' 		, type: 'string' },    
			{name: 'ORIGINAL_PUB_NUM'				, text: '원본세금계산서번호' 		, type: 'string' },    
			{name: 'PLUS_MINUS_TYPE'				, text: '계산서구분' 			, type: 'string' },    
			{name: 'SEQ_GUBUN'						, text: '순번정렬' 			, type: 'string' },
			{name: 'BUSINESS_TYPE'					, text: '사업자구분' 			, type: 'string' }
		]
	});
	
	
	var masterStore = Unilite.createStore('atx170ukrMasterStore',{
		model	: 'atx170ukrModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 (수정하여 전자세금계산서, MAIL 전송에만 사용하고 저장하지는 않으므로, false설정) 
			editable	: true,			// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'atx170ukrService.selectList'                	
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
				if(panelSearch.getValue('BILL_SEND_YN').BILL_SEND_YN == 'Y') {
	    			Ext.each(records, function(record, idx) {
						allTotAmtI = allTotAmtI + record.get('TOTL_AMT');
	    			})        			
					buttonPanel.setValue('TXT_TOTAL', allTotAmtI);

				}
			}
		},
		
		_onStoreLoad: function ( store, records, successful, eOpts ) {
	    	if(this.uniOpt.isMaster) {
		    	if (records.length > 0) {
			    	UniAppManager.setToolbarButtons('save', false);
					var msg = records[0].data.COUNT + Msg.sMB001; 					//'건이 조회되었습니다.';
			    	UniAppManager.updateStatus(msg, true);	
		    	}
	    	}
	    }
	});
	
    var buttonStore = Unilite.createStore('atx170ukrButtonStore',{      
        uniOpt: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,           // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy	: directButtonProxy,
        
        saveStore: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

            var paramMaster 			= panelSearch.getValues();
            paramMaster.OPR_FLAG		= buttonFlag;
            paramMaster.LANG_TYPE		= UserInfo.userLang
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();
                        
                        UniAppManager.app.onQueryButtonDown();
                        buttonStore.clearData();
                     },

                     failure: function(batch, option) {
                        buttonStore.clearData();
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('atx170ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
    
    
	/* 검색조건 (Search Panel)
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
		items		: [{	
			title	: '기본검색', 	
   			itemId	: 'search_panel1',
           	layout	: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items	: [{
					fieldLabel	: '사업장', 
					name		: 'DIV_CODE', 
					xtype		: 'uniCombobox', 
					comboType	: 'BOR120', 
//					allowBlank	: false,
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
					
						}
					}},
					Unilite.popup('AGENT_CUST', { 
						fieldLabel	: '고객', 
						extParam	: {'CUSTOM_TYPE': '3'},
						textFieldName: 'CUSTOM_NAME',
						valueFieldName: 'CUSTOM_CODE',
						validateBlank: false,
						listeners: {
							onValueFieldChange: function(field, newValue){	
								panelResult.setValue('CUSTOM_CODE', newValue);
							},	
							onTextFieldChange: function(field, newValue){	
								panelResult.setValue('CUSTOM_NAME', newValue);
							}	
						}
					}),
					Unilite.popup('AGENT_CUST', { 
						fieldLabel	: '집계거래처', 
						extParam	: {'CUSTOM_TYPE': '3'},
						textFieldName: 'MANAGE_CUST_CD',
						valueFieldName: 'MANAGE_CUST_NM',
						validateBlank: false,
						listeners	: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('MANAGE_CUST_CD', panelSearch.getValue('MANAGE_CUST_CD'));
									panelResult.setValue('MANAGE_CUST_NM', panelSearch.getValue('MANAGE_CUST_NM'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('MANAGE_CUST_CD', '');
								panelResult.setValue('MANAGE_CUST_NM', '');
							}
						}
					}),{
					fieldLabel	: '등록일',
					xtype		: 'uniDateRangefield',
					startFieldName: 'DATE_FR',
					endFieldName: 'DATE_TO',
					startDate	: UniDate.get('today'),
					endDate		: UniDate.get('today'),
					allowBlank	: true,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) panelResult.setValue('DATE_FR',newValue);				
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) panelResult.setValue('DATE_TO',newValue);		    		
				    }
				},{
					fieldLabel	: '입력일',
					xtype		: 'uniDateRangefield',
					startFieldName: 'INSERT_DB_TIME_FR',
					endFieldName: 'INSERT_DB_TIME_TO',
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) panelResult.setValue('INSERT_DB_TIME_FR',newValue);			
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) panelResult.setValue('INSERT_DB_TIME_TO',newValue);		
				    }
				},{
					fieldLabel	: '전송일',
					xtype		: 'uniDateRangefield',
					startFieldName: 'SEND_LOG_TIME_FR',
					endFieldName: 'SEND_LOG_TIME_TO',
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) panelResult.setValue('SEND_LOG_TIME_FR',newValue);			
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) panelResult.setValue('SEND_LOG_TIME_TO',newValue);	
				    }
				},{
					fieldLabel	: '전송여부', 
					xtype		: 'uniRadiogroup',
					name		: 'BILL_SEND_YN', 
					comboType	: 'AU', 
					comboCode	: 'B087',
					value		: 'N',
					width		: 240,
					allowBlank	: false,
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BILL_SEND_YN', newValue.BILL_SEND_YN);
							panelSearch.setActionBtn(newValue.BILL_SEND_YN);

							if (newYN_ISSUE == '1'){					//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
								newYN_ISSUE = '0'
								return false;
							}else {
								UniAppManager.app.onQueryButtonDown();	
							}	
						}
					}
				},{
					xtype		: 'radiogroup',		            		
					fieldLabel	: '발행구분',					            		
					id			: 'rdoSelect1',
					items		: [{
						boxLabel: '정발행', 
						width	: 70, 
						name	: 'ISSUE_GUBUN',
						inputValue: '1',
						checked	: true  
					},{
						boxLabel: '역발행', 
						width	: 70,
						name	: 'ISSUE_GUBUN',
						inputValue: '2'
					},{
						boxLabel: '위수탁발행', 
						width	: 100,
						name	: 'ISSUE_GUBUN',
						inputValue: '3'
					}],
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelResult.getField('ISSUE_GUBUN').setValue(newValue.ISSUE_GUBUN);
							if (newValue.ISSUE_GUBUN !=3) {
								masterGrid.getColumn('BROK_CUSTOM_CODE').setHidden(true);
								masterGrid.getColumn('BROK_COMPANY_NUM').setHidden(true);
								masterGrid.getColumn('BROK_TOP_NUM').setHidden(true);
								masterGrid.getColumn('BROK_PRSN_NAME').setHidden(true);
								masterGrid.getColumn('BROK_PRSN_EMAIL').setHidden(true);
								
							} else {
								masterGrid.getColumn('BROK_CUSTOM_CODE').setHidden(false);
								masterGrid.getColumn('BROK_COMPANY_NUM').setHidden(false);
								masterGrid.getColumn('BROK_TOP_NUM').setHidden(false);
								masterGrid.getColumn('BROK_PRSN_NAME').setHidden(false);
								masterGrid.getColumn('BROK_PRSN_EMAIL').setHidden(false);
							}
						
//							if (newYN_ISSUE == '1'){									//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다 (중복수행 방지를 위해 panelResult에서만 처리)	
//								newYN_ISSUE = '0'
//								return false;
//							}else {
//								UniAppManager.app.onQueryButtonDown();	
//							}	
						}
					}
				},{
					fieldLabel	: '계산서유형', 
					name		: 'BILL_TYPE', 
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B066',
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BILL_TYPE', newValue);					
						}
					}
				},{
					fieldLabel	: '생성경로', 
					name		: 'CRT_LOC', 
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'S099',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CRT_LOC', newValue);
					
						}
					}
				},{
					fieldLabel	: '상태', 
					name		: 'BILL_STAT', 
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'S080',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BILL_STAT', newValue);
					
						}
					}
				},{					
	    			fieldLabel	: '비고',
	    			name		: 'REMARK',
	    			xtype		: 'uniTextfield',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('REMARK', newValue);
					
						}
					}
	    		},{
					fieldLabel	: ' ',
					name		: 'CHECKBOX1',
					xtype		: 'uniCheckboxgroup', 
					items		: [{
			        	boxLabel		: '동일 거래처/년월/금액 허용',
			        	name			: 'OPR_FLAG2',
						width			: 170,
			        	inputValue		: 'GO',
			        	uncheckedValue	: 'INIT',
			        	checked			: false,
						listeners		: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('OPR_FLAG2', newValue);
							}
						}
			        }]
				},{
					fieldLabel	: ' ',
					name		: 'CHECKBOX2',
					xtype		: 'uniCheckboxgroup', 
					items		: [{
			        	boxLabel		: '전월데이터 허용',
			        	name			: 'OPR_FLAG3',
						width			: 120,
			        	inputValue		: 'GO',
			        	uncheckedValue	: 'INIT',
			        	checked			: false,
						listeners		: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('OPR_FLAG3', newValue);
							}
						}
			        }]
				}
	    	]
		}],
	    setActionBtn: function(value)	{												//전송여부에 따른 버튼 test 설정 (버튼은 모두 초기화(disable))
	    	var actionPanel = Ext.getCmp('atx170ukrButtonPanel');
	    	console.log("value : ", value);
	    	if(value == "N")	{
	    		buttonPanel.down('#sendBtn').setText('전송');
	    		
	    	} else {
	    		buttonPanel.down('#sendBtn').setText('다시 전송');
	    	}
    		buttonPanel.down('#sendBtn').disable();
    		buttonPanel.down("#sendEmailBtn").disable();
//    		buttonPanel.down("#confirmEmailBtn").disable();

	    }
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
   
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: 0,
		spacing	: 2,
		weight	: -100,
		border	: false,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items: [
			{
				fieldLabel	: '사업장', 
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox', 
				comboType	: 'BOR120',       	
				tdAttrs		: {width: 380},  
//				allowBlank	: false,   
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
				
					}
				}
			},{
				fieldLabel	: '등록일',
				xtype		: 'uniDateRangefield',
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
				startDate	: UniDate.get('today'),
				endDate		: UniDate.get('today'),
				tdAttrs		: {width: 380},  
				allowBlank:true,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) panelSearch.setValue('DATE_FR',newValue);				
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) panelSearch.setValue('DATE_TO',newValue);		 
			    }
			},{
				fieldLabel	: '계산서유형', 
				name		: 'BILL_TYPE', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'B066',
				tdAttrs		: {width: 380},  
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BILL_TYPE', newValue);
					}
				}
			},
			Unilite.popup('AGENT_CUST', { 
				fieldLabel	: '고객', 
				extParam	: {'CUSTOM_TYPE': '3'},
				textFieldName: 'CUSTOM_NAME',
				valueFieldName: 'CUSTOM_CODE',
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){	
						panelSearch.setValue('CUSTOM_CODE', newValue);
					},	
					onTextFieldChange: function(field, newValue){	
						panelSearch.setValue('CUSTOM_NAME', newValue);
					}	
				}
			}),{
				fieldLabel	: '입력일',
				xtype		: 'uniDateRangefield',
				startFieldName: 'INSERT_DB_TIME_FR',
				endFieldName: 'INSERT_DB_TIME_TO',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) panelSearch.setValue('INSERT_DB_TIME_FR',newValue);		
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) panelSearch.setValue('INSERT_DB_TIME_TO',newValue);	
			    }
			},{
				fieldLabel	: '생성경로', 
				name		: 'CRT_LOC', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'S099',
//				width		: 315,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CRT_LOC', newValue);				
					}
				}
			},
			Unilite.popup('AGENT_CUST', { 
				fieldLabel	: '집계거래처', 
				extParam	: {'CUSTOM_TYPE': '3'},
				textFieldName: 'MANAGE_CUST_CD',
				valueFieldName: 'MANAGE_CUST_NM',
				validateBlank: false,
				listeners	: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('MANAGE_CUST_CD', panelResult.getValue('MANAGE_CUST_CD'));
							panelSearch.setValue('MANAGE_CUST_NM', panelResult.getValue('MANAGE_CUST_NM'));	
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('MANAGE_CUST_CD', '');
						panelSearch.setValue('MANAGE_CUST_NM', '');
					}
				}
			}),{
				fieldLabel	: '전송일',
				xtype		: 'uniDateRangefield',
				startFieldName: 'SEND_LOG_TIME_FR',
				endFieldName: 'SEND_LOG_TIME_TO',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) panelSearch.setValue('SEND_LOG_TIME_FR',newValue);				
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) panelSearch.setValue('SEND_LOG_TIME_TO',newValue);		    		
			    }
			},{
				fieldLabel	: '상태', 
				name		: 'BILL_STAT', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'S080',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BILL_STAT', newValue);
				
					}
				}
			},{
				fieldLabel	: '전송여부', 
				xtype		: 'uniRadiogroup',
				name		: 'BILL_SEND_YN', 
				id			: 'billSendYn',
				comboType	: 'AU', 
				comboCode	: 'B087',
				value		: 'N',
				width		: 250,
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {	
						console.log(" BILL_SEND_YN : ", newValue);
						panelSearch.setValue('BILL_SEND_YN', newValue.BILL_SEND_YN);
						panelSearch.setActionBtn(newValue.BILL_SEND_YN);
						
						if (newYN_ISSUE == '1'){					//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN_ISSUE = '0'
							return false;
						}else {
							UniAppManager.app.onQueryButtonDown();	
						}	
					}
				}
			},{
				xtype		: 'radiogroup',		            		
				fieldLabel	: '발행구분',				            		
				id			: 'rdoSelect0',
				items		: [{
					boxLabel: '정발행', 
					width	: 70, 
					name	: 'ISSUE_GUBUN',
					inputValue: '1',
					checked	: true  
				},{
					boxLabel: '역발행', 
					width	: 70,
					inputValue: '2',
					name	: 'ISSUE_GUBUN'
				},{
					boxLabel: '위수탁발행', 
					width	: 100,
					inputValue: '3',
					name	: 'ISSUE_GUBUN'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						panelSearch.getField('ISSUE_GUBUN').setValue(newValue.ISSUE_GUBUN);

						if (newValue.ISSUE_GUBUN !=3) {
							masterGrid.getColumn('BROK_CUSTOM_CODE').setHidden(true);
							masterGrid.getColumn('BROK_COMPANY_NUM').setHidden(true);
							masterGrid.getColumn('BROK_TOP_NUM').setHidden(true);
							masterGrid.getColumn('BROK_PRSN_NAME').setHidden(true);
							masterGrid.getColumn('BROK_PRSN_EMAIL').setHidden(true);
							
						} else {
							masterGrid.getColumn('BROK_CUSTOM_CODE').setHidden(false);
							masterGrid.getColumn('BROK_COMPANY_NUM').setHidden(false);
							masterGrid.getColumn('BROK_TOP_NUM').setHidden(false);
							masterGrid.getColumn('BROK_PRSN_NAME').setHidden(false);
							masterGrid.getColumn('BROK_PRSN_EMAIL').setHidden(false);
						}

						if (newYN_ISSUE == '1'){					//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN_ISSUE = '0'
							return false;
						}else {
							UniAppManager.app.onQueryButtonDown();	
						}	
					}
				}
			},{					
    			fieldLabel: '비고',
    			name	: 'REMARK',
    			xtype	: 'uniTextfield',
    			width:315,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('REMARK', newValue);
				
					}
				}
    		},{
				fieldLabel	: ' ',
				name		: 'CHECKBOX1',
				xtype		: 'uniCheckboxgroup', 
				colspan		: 2,
				items		: [{
		        	boxLabel		: '동일 거래처/년월/금액 허용',
		        	name			: 'OPR_FLAG2',
					width			: 185,
		        	inputValue		: 'GO',
		        	uncheckedValue	: 'INIT',
		        	checked			: false,
					listeners		: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('OPR_FLAG2', newValue);
						}
					}
		        },{
		        	boxLabel		: '전월데이터 허용',
		        	name			: 'OPR_FLAG3',
					width			: 120,
		        	inputValue		: 'GO',
		        	uncheckedValue	: 'INIT',
		        	checked			: false,
					listeners		: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('OPR_FLAG3', newValue);
						}
					}
		        }]
			}
		]
	})
	
	var messagePanel = Unilite.createSearchForm('atx170ukrMessagePanel',{
		region	: 'north' ,
		weight	: -100,
		border	: false,
		padding	: 1,
		layout	: {type	: 'hbox'	, align: 'stretch'},
		defaults: {padding:'2 2 2 2'},
		weight	: -100,
		items	: [{
			xtype	: 'component',
			flex	: 1,
			style	: {
				'color'			: 'blue',
				'line-height'	: '29px',
				'vertical-align': 'middle'
			},
			html: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※ 공급자는 사업장정보, 공급받는자는 거래처정보에서 회사명, 대표자, 업태, 업종, 주소, 전화번호, EMAIL 등을 참조합니다.'
		}]
	})	;
	
	var buttonPanel = Unilite.createSearchForm('atx170ukrButtonPanel',{
		id		: 'atx170ukrButtonPanel',
		region	: 'north',
		weight	: -100,
		border	: true,
		padding	: 1,
//		margin	: 1,
		defaults: {padding:'2 2 2 2'},
		layout	: {type: 'hbox'		,tdAttrs	: {style: 'border : 1px solid #f00;', align: 'right'	, width: '100%'}
		},
		bodyStyle:{'background-color':'#D9E7F8'},
		defaultType:'uniTextfield',
		items:[{
			xtype	: 'component',
			flex	: 1
		
		},{					
			fieldLabel: '총합계',
			name	: 'TXT_TOTAL',
			xtype	: 'uniNumberfield',
			value	: '0',
			readOnly: true
		},{
			xtype	: 'container',
			layout	: 'hbox',
			style	: {'vertical-align':'middle'	,'line-height':'22px'},
			items	: [{
				text	: '전송',
				xtype	: 'button',
				itemId	: 'sendBtn',
				width	: 100,
				handler	: function()	{
					//전송일 때 SP 호출
					if(Ext.getCmp('billSendYn').getChecked()[0].inputValue == 'N'){
			            var buttonFlag = 'T';		
			            fnMakeLogTable(buttonFlag);
					}
					//다시 전송일 때 SP 호출
					if(Ext.getCmp('billSendYn').getChecked()[0].inputValue == 'Y'){
						if(confirm("다시 전송하시기 전에 데이터를 확인하시기 바랍니다. \n 데이터 확인 없이 계속 진행하시겠습니까?")) {
				            var buttonFlag = 'RT';
				            fnMakeLogTable(buttonFlag);
						} else {
							return false;
						}
					}
				}
			},{
				text	: 'Mail 재전송',
				xtype	: 'button',
				itemId	: 'sendEmailBtn',
				width	: 100,
				disabled: true,
				handler	: function()	{
		            var buttonFlag = 'M';
		            fnMakeLogTable(buttonFlag);
				}
			}/*,{//20161129 - 버튼 삭제
				text	: '확인메일전송',
				xtype	: 'button',
				itemId	: 'confirmEmailBtn',
				width	: 100,
				handler	: function()	{
		            var buttonFlag = 'CM';
		            fnMakeLogTable(buttonFlag);
				}
			}*/]
		}]
	})
	
	
	/* 그리드 (masterGrid)
	 * 
	 */
	var masterGrid = Unilite.createGrid('atx170ukrGrid', {
       // for tab       
		store	: masterStore,
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
				text		: '전체반영',
				xtype		: 'button',
				width		: 80,
				handler		: function()	{
					var gbnField = masterGrid.down("#popsCode");
					if(gbnField) {
						var gbn = gbnField.getValue();
						Ext.each(masterStore.data.items, function(record, idx){
								record.set('POPS_CODE', gbn)
						})
					}
				}
			},{	
				   xtype: 'tbspacer',
				   width	: 8
			},{	
				    xtype: 'tbseparator'
			},{	
				   xtype: 'tbspacer',
				   width	: 8
			}	
		],
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly		: true,
        	toggleOnClick	: true,
        	listeners		: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			if(panelSearch.getValue('BILL_SEND_YN').BILL_SEND_YN == 'N' && record.get('TRANSYN_NAME') == 'Error'){							//Error컬럼은 선택 못하게
						return false;        			        				
        			}
        		},  
        		
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(panelSearch.getValue('BILL_SEND_YN').BILL_SEND_YN == 'N') {		//미전송일 때, 체크된 값만 총합계에 합계표시
		    			totAmtI = totAmtI + selectRecord.get('TOTL_AMT');
						buttonPanel.setValue('TXT_TOTAL', totAmtI);
					}

	    			if (this.selected.getCount() > 0 && Ext.getCmp('billSendYn').getChecked()[0].inputValue == 'N') {
			    		buttonPanel.down('#sendBtn').enable();
			    		buttonPanel.down("#sendEmailBtn").disable();
//			    		buttonPanel.down("#confirmEmailBtn").enable();
			    		
	    			} else if (this.selected.getCount() > 0 && Ext.getCmp('billSendYn').getChecked()[0].inputValue == 'Y') {
						//보낸 데이터 중, error 있는 경우 "다시 전송" 버튼 로직 구현 추가 로직 구현해야 함
	    				if(selectRecord.get('TRANSYN_NAME') == 'Error') {
			    			buttonPanel.down('#sendBtn').enable();
	    				}
			    		buttonPanel.down("#sendEmailBtn").enable();
//			    		buttonPanel.down("#confirmEmailBtn").disable();
	    				
	    			}
    			},
    			
	    		deselect:  function(grid, selectRecord, index, eOpts ){
					if(panelSearch.getValue('BILL_SEND_YN').BILL_SEND_YN == 'N') {		//미전송일 때, 체크된 값만 총합계에 합계표시
		    			totAmtI = totAmtI - selectRecord.get('TOTL_AMT');
						buttonPanel.setValue('TXT_TOTAL', totAmtI);
					}
					
	    			if (this.selected.getCount() <= 0) {								//체크된 데이터가 0개일  때는 버튼 비활성화
			    		buttonPanel.down('#sendBtn').disable();
			    		buttonPanel.down("#sendEmailBtn").disable();
//			    		buttonPanel.down("#confirmEmailBtn").disable();
	    			}
	    		}
        	}
        }),
        viewConfig: {
		    forceFit		: true,
		    showPreview		: true,														// custom property
		    enableRowBody	: true,														// required to create a second, full-width row to show expanded Record data
		    getRowClass		: function(record, rowIndex, rp, ds){						// rp = rowParams
		        if(record.get("DEL_YN") != "Y" && record.get("STS") != ""){
		            return 'essRow';
		        }		        
		        return 'optRow';
		    },
		    
	        getRowClass: function(record, rowIndex, rowParams, store){ 					//오류 row 빨간색 표시		
	        	var cls = '';

	        	if(record.get('TRANSYN_NAME') == 'Error'){
					cls = 'x-change-celltext_red';
				}
				return cls;
	        }
	    
		},
    	features: [
    	    {id : 'masterGridTotal'		, ftype: 'uniSummary'		, showSummaryRow: true}
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
//	            	if (!Ext.isEmpty(record.data.ISSU_ID) && record.data.STAT_CODE == '00') {
	            	if (!Ext.isEmpty(record.data.ISSU_ID) && record.data.TRANSYN_NAME == '전송') {
	                	return '<a href="https://web.taxbill365.com/jsp/corp/comm/comm_0001_02.jsp?SCH_GB=2&ISSU_ID=' + record.data.ISSU_ID + '" target="_blank">' + '상세조회' + '</a>';
	            	} else {
	            		return '';
	            	}
	            }
	        },
			{dataIndex: 'TRANSYN_NAME'	        , width: 100		,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
/*			{
			    text: 'URL',
			    width: 250,
			    dataIndex: 'url',
			    xtype: 'templatecolumn',
			    tpl: '<a href = "https://devweb.taxbill365.com/jsp/corp/comm/comm_0001_02.jsp?SCH_GB=2&ISSU_ID=' + '2016090541000026a010092k' + '" target="_blank">' + '상세조회' +'</a>'
			},*/
			{dataIndex: 'STAT_CODE'		        , width: 100 },
			{dataIndex: 'STS'				    , width: 93  , hidden: true},
			{dataIndex: 'CRT_LOC'			    , width: 80  },
			{dataIndex: 'BILL_FLAG'		        , width: 100 },
			{dataIndex: 'TAX_TYPE'		        , width: 100	, hidden: true },
			{dataIndex: 'POPS_CODE'		        , width: 100 },
			{dataIndex: 'REGS_DATE'		        , width: 86  },
			{dataIndex: 'SELR_CORP_NO'	        , width: 100	, hidden: true },
			{dataIndex: 'SELR_CORP_NM'	        , width: 100	, hidden: true },
			{dataIndex: 'SELR_CODE'             , width: 100	, hidden: true },
			{dataIndex: 'SELR_CEO'		        , width: 100	, hidden: true },
			{dataIndex: 'SELR_BUSS_CONS'	    , width: 100	, hidden: true },
			{dataIndex: 'SELR_BUSS_TYPE'	    , width: 100	, hidden: true },
			{dataIndex: 'SELR_ADDR'		        , width: 100	, hidden: true },
			{dataIndex: 'SELR_CHRG_NM'	        , width: 100	, hidden: true },
			{dataIndex: 'SELR_CHRG_POST'	    , width: 100	, hidden: true },
			{dataIndex: 'SELR_CHRG_TEL'	        , width: 100	, hidden: true },
			{dataIndex: 'SELR_CHRG_EMAIL'	    , width: 100	, hidden: true },
			{dataIndex: 'SELR_CHRG_MOBL'		, width: 100	, hidden: true },
			{dataIndex: 'CUSTOM_CODE'			, width: 86	 },
			{dataIndex: 'BUYR_CORP_NM'	        , width: 160 },
			{dataIndex: 'BUYR_GB'			    , width: 100	, hidden: true },
			{dataIndex: 'BUYR_CORP_NO'	        , width: 100	,
				renderer:function(value, metaData, record)	{
					var r = value;
					if(record.get('BUYR_GB') == '02') r ='*************'
					return r;
				}
			},
			{dataIndex: 'BUYR_CODE'             , width: 100 },
			{dataIndex: 'BILLTYPENAME'	        , width: 100,
	        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + masterStore.getCount() + '건','건수 : ' + masterStore.getCount() + '건');
            	}
			},
			{dataIndex: 'ISSUE_DETAILS'		    , width: 113 },
			{dataIndex: 'CHRG_AMT'		        , width: 113	, summaryType: 'sum'},
			{dataIndex: 'TAX_AMT'			    , width: 86		, summaryType: 'sum'},
			{dataIndex: 'TOTL_AMT'		        , width: 113	, summaryType: 'sum'},
			{dataIndex: 'BUYR_CEO'		        , width: 86  },
			{dataIndex: 'BUYR_BUSS_CONS'	    , width: 66  },
			{dataIndex: 'BUYR_BUSS_TYPE'	    , width: 200 },
			{dataIndex: 'BUYR_ADDR'		        , width: 400 },
			{dataIndex: 'BUYR_CHRG_NM1'	        , width: 100 },
			{dataIndex: 'BUYR_CHRG_TEL1'	    , width: 100 },
			{dataIndex: 'BUYR_CHRG_MOBL1'       , width: 100 },
			{dataIndex: 'BUYR_CHRG_EMAIL1'      , width: 166 },
			{dataIndex: 'BUYR_CHRG_NM2'	        , width: 100 },
			{dataIndex: 'BUYR_CHRG_MOBL2'       , width: 100 },
			{dataIndex: 'BUYR_CHRG_EMAIL2'      , width: 166 },
			{dataIndex: 'BROK_CUSTOM_CODE'		, width: 140	, hidden: true },
			{dataIndex: 'BROK_COMPANY_NUM'		, width: 140	, hidden: true },
			{dataIndex: 'BROK_TOP_NUM'			, width: 120	, hidden: true },
			{dataIndex: 'BROK_PRSN_NAME'		, width: 120	, hidden: true },
			{dataIndex: 'BROK_PRSN_EMAIL'		, width: 180	, hidden: true },
			{dataIndex: 'SEND_DATE'		       	, width: 133 },
			{dataIndex: 'ISSU_SEQNO'		    , width: 133 },
			{dataIndex: 'SELR_MGR_ID3'	        , width: 133 },
			{dataIndex: 'SND_STAT'	       		, width: 133 },
			{dataIndex: 'RCV_VIEW_YN'	        , width: 133 },
			{dataIndex: 'NOTE1'			        , width: 133 },
			{dataIndex: 'MODY_CODE'		        , width: 133 },
			{dataIndex: 'REQ_STAT_CODE'	        , width: 100	, hidden: true },
			{dataIndex: 'BILL_PUBLISH_TYPE'	    , width: 100	, hidden: true },
			{dataIndex: 'BILL_TYPE'		        , width: 100	, hidden: true },
			{dataIndex: 'SND_MAIL_YN'		    , width: 100	, hidden: true },
			{dataIndex: 'SND_SMS_YN'		    , width: 100	, hidden: true },
			{dataIndex: 'SND_FAX_YN'		    , width: 100	, hidden: true },
			{dataIndex: 'COMP_CODE'		        , width: 100	, hidden: true },
			{dataIndex: 'DIV_CODE'		        , width: 100	, hidden: true },
			{dataIndex: 'SALE_DIV_CODE'	        , width: 100	, hidden: true },
			{dataIndex: 'DEL_YN'			    , width: 100	, hidden: true },
			{dataIndex: 'REPORT_AMEND_CD'	    , width: 100	, hidden: true },
			{dataIndex: 'BFO_ISSU_ID'           , width: 100	, hidden: true },
			{dataIndex: 'ISSU_ID'               , width: 166 },
			{dataIndex: 'ERR_MSG'   			, flex : 1		, minWidth: 300},
			{dataIndex: 'BEFORE_PUB_NUM'        , width: 100	, hidden: true },
			{dataIndex: 'ORIGINAL_PUB_NUM'      , width: 100	, hidden: true },
			{dataIndex: 'PLUS_MINUS_TYPE'       , width: 100	, hidden: true },
			{dataIndex: 'SEQ_GUBUN'             , width: 100	, hidden: true }
		],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['POPS_CODE', 'BUYR_CHRG_EMAIL1', 'ISSUE_DETAILS'])){
					return true;
					
				} else {
					return false;
				}
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
          		if(colName =="BUYR_CORP_NO") {
          			if(record.get('BUYR_GB') == '02') {
						grid.ownerGrid.openCryptRepreNoPopup(record);
          			}
				}
				if(colName == 'CRT_LOC')	{
					var crtLoc = record.get(colName);
					switch(colName)	{
						case '5':
							if( record.get("BILL_FLAG") != '2')	{
								var rec = {data : {prgID : BsaInfo.gsSsa560UkrLink}};
								parent.openTab(rec, '/accnt/'+BsaInfo.gsAgj100UkrLink+'.do', {});
							}
						default:
							break;
						
					}
				}
       			
			}/*,
			
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field =='BILLPRSN')	{
					console.log("e.record.get('CUSTOM_CODE'):",e.record.get('CUSTOM_CODE'));
					editor.extParam = {'CUSTOM_CODE':e.record.get('CUSTOM_CODE')};
					e.extParam = {'CUSTOM_CODE':e.record.get('CUSTOM_CODE')};
				}
				if(e.record.phantom || !e.record.phantom ) 
				{
					if (!(e.record.get('CRT_LOC') =='5' && e.record.get('BILL_FLAG') =='2')) {
						if (UniUtils.indexOf(e.field,['REPORT_AMEND_CD','BIGO'])) {
							return false;
						}
					}
				}
			},
			
			selectionchange: function(model, selected, eOpts)	{
    			var txtTotal = 0;
    			Ext.each(selected, function(record, idx) {
    				console.log("txtTotal : ", txtTotal);
    				txtTotal += record.get('TOTL_AMT');
    			})        			
    			buttonPanel.setValue('TXT_TOTAL', txtTotal);
 
    		}*/
		},
    	openCryptRepreNoPopup:function( record )	{
		  	if(record)	{
				var params = {'REPRE_NO': record.get('BUYR_CORP_NO'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BUYR_CORP_NO', 'BUYR_CORP_NO', params);
			}		
		}
	});

	
	Unilite.Main({
		id			: 'atx170ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
		 		 masterGrid,
		 		 panelResult,
		 		 messagePanel,
		 		 buttonPanel
			]
		},
 		panelSearch
		],
		
		fnInitBinding: function() {
			//각 panel 값 set
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('DATE_FR', UniDate.get('today'));
			panelSearch.setValue('DATE_TO', UniDate.get('today'));
			panelSearch.setValue('BILL_SEND_YN', 'N');
			panelSearch.getField('ISSUE_GUBUN').setValue('1');
			
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DATE_FR', UniDate.get('today'));
			panelResult.setValue('DATE_TO', UniDate.get('today'));
			panelResult.setValue('BILL_SEND_YN', 'N');
			panelResult.getField('ISSUE_GUBUN').setValue('1');
			
			buttonPanel.setValue('TXT_TOTAL', 0);
    		buttonPanel.down('#sendBtn').setText('전송');
    		buttonPanel.down('#sendBtn').setConfig('hidden', false);
			
			//button 활성화 set
			panelSearch.setActionBtn('N');			

			//set master button 
			UniAppManager.setToolbarButtons(['newData'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			
			//초기화 시 전표일로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
			
			newYN_ISSUE	= 0;
		},
		
		onQueryButtonDown: function() {   
			totAmtI 	= 0;															//합계변수 초기화
			allTotAmtI	= 0;
			
			buttonPanel.reset();
			masterStore.loadStoreRecords();
		},
		
		onResetButtonDown: function() {
			newYN_ISSUE = '1';
			
			panelSearch.clearForm();
			panelResult.clearForm();
			buttonPanel.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			UniAppManager.app.fnInitBinding();
		}
		
/*		fnWebCashColSet: function(records) {											//웹캐시 전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
			Ext.each(records, function(record) {
				//공급자 업체명, 대표자명, 업태, 업종, 주소
				if(Ext.isEmpty(record.get('SELR_CORP_NM')) || Ext.isEmpty(record.get('SELR_CEO')) || Ext.isEmpty(record.get('SELR_BUSS_CONS'))
				   || Ext.isEmpty(record.get('SELR_BUSS_TYPE'))  || Ext.isEmpty(record.get('SELR_ADDR'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '1');
					record.set('ERR_MSG', Msg.fStMsgS0092);

				//공급 받는자 업체명, 대표자명, 주소
				} else if(Ext.isEmpty(record.get('BUYR_BUSS_CONS')) || Ext.isEmpty(record.get('BUYR_CEO')) || Ext.isEmpty(record.get('BUYR_ADDR'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '3');
					record.set('ERR_MSG', Msg.fStMsgS0094);
					
				//공급 받는자 담당자명, 전화번호, 이메일주소
				} else if(Ext.isEmpty(record.get('BUYR_CHRG_NM1')) || Ext.isEmpty(record.get('BUYR_CHRG_TEL1')) || Ext.isEmpty(record.get('BUYR_CHRG_EMAIL1'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '4');
					record.set('ERR_MSG', Msg.fStMsgS0095);

				} else {
					record.set('ERR_MSG', '');
				}

			});
		}*/
	});//End of Unilite.Main( {
	
	function fnMakeLogTable(buttonFlag) {
			//조건에 맞는 내용은 적용 되는 로직															//전송 외의 경우, 자동채번로직 없이 SP호출
			records = masterGrid.getSelectedRecords();
			buttonStore.clearData();														//buttonStore 클리어
			if(buttonFlag == 'RT') {										//세부로직 구현 해야 함
				Ext.each(records, function(record, index) {
					if (record.get('TRANSYN_NAME') == 'Error') {
			            record.phantom 			= true;
						record.data.OPR_FLAG	= buttonFlag;
			            buttonStore.insert(index, record);
						
						if (records.length == index +1) {
			                buttonStore.saveStore(buttonFlag);
						}
					}
				});
				
			} else {
				Ext.each(records, function(record, index) {
		            record.phantom 			= true;
					record.data.OPR_FLAG	= buttonFlag;
		            buttonStore.insert(index, record);
					
					if (records.length == index +1) {
		                buttonStore.saveStore(buttonFlag);
					}
				});
			}
//		}
	}

};

</script>