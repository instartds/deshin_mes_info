<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa700ukrv"  >
   <t:ExtComboStore comboType="BOR120" pgmId="ssa700ukrv" />         <!-- 사업장 -->
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
   /**
    *   Model 정의 
    * @type 
    */
   
	Unilite.defineModel('Ssa700ukrvWebCashModel', {//"02" 웹캐시용 모델
	    fields: [  	 
	    	{name:'CHK' 							,text:'<t:message code="system.label.sales.selection" default="선택"/>' 					,type: 'string'},
			{name:'TRANSYN_NAME' 					,text:'전송(웹캐시)' 					,type: 'string'},
			{name:'STAT_CODE' 						,text:'상태'					,type: 'string' , comboType: 'AU' , comboCode: 'S080'},
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
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read : 'ssa700ukrvService.selectWebCashMaster' ,
    	   update : 'ssa700ukrvService.saveWebCash',
		   syncAll: 'ssa700ukrvService.saveAllWebCash'
		}
	});
	var webCashStore = Unilite.createStore('ssa700ukrvWebCashStore',{
			model: 'Ssa700ukrvWebCashModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
			},
			saveStore : function(OPR_FLAG)	{	
				var selRecords = webCashGrid.getSelectedRecords();
				Ext.each(selRecords, function(record, idx){
					record.set('OPR_FLAG', OPR_FLAG);
				});					
				var inValidRecs = this.getInvalidRecords();
				console.log("store : ", this);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				}
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(!Ext.isEmpty(records)){
	           			//directStore.loadStoreRecords(records[0]);
						UniAppManager.app.fnWebCashColSet(records);	//전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기		
						store.commitChanges();
			            }
	           	}
			}
		
	});


  /**
    * 검색조건 (Search Panel)
    * @type 
    */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        
		items: [{	
			title: '기본검색', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items: [{
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
					name: 'DIV_CODE', 
					xtype: 'uniCombobox', 
					comboType: 'BOR120', 
					allowBlank: false,
					child:'BUSI_PRSN',
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
					
						}
					}
					},
					Unilite.popup('AGENT_CUST', { 
						fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>', 
						validateBlank: false,
						extParam: {'CUSTOM_TYPE': '3'},
						textFieldName: 'CUSTOM_NAME',
						valueFieldName: 'CUSTOM_CODE',
						listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
									panelResult.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
						}
					}),
					Unilite.popup('AGENT_CUST', { 
						fieldLabel: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>', 
						validateBlank: false,
						extParam: {'CUSTOM_TYPE': '3'},
						textFieldName: 'MANAGE_CUST_CD',
						valueFieldName: 'MANAGE_CUST_NM',
						listeners: {
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
					fieldLabel: '등록일',
					xtype: 'uniDateRangefield',
					startFieldName: 'BILL_DATE_FR',
					endFieldName: 'BILL_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,
					allowBlank:true,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) panelResult.setValue('BILL_DATE_FR',newValue);				
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) panelResult.setValue('BILL_DATE_TO',newValue);		    		
				    }
				},
				{
					fieldLabel: '입력일',
					xtype: 'uniDateRangefield',
					startFieldName: 'INSERT_DB_TIME_FR',
					endFieldName: 'INSERT_DB_TIME_TO',
					/*startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),*/
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) panelResult.setValue('INSERT_DB_TIME_FR',newValue);			
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) panelResult.setValue('INSERT_DB_TIME_TO',newValue);		
				    }
				},
				{
					fieldLabel: '전송일',
					xtype: 'uniDateRangefield',
					startFieldName: 'SEND_LOG_TIME_FR',
					endFieldName: 'SEND_LOG_TIME_TO',
					/*startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),*/
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) panelResult.setValue('SEND_LOG_TIME_FR',newValue);			
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) panelResult.setValue('SEND_LOG_TIME_TO',newValue);	
				    }
				},{
					fieldLabel: '전송여부', 
					xtype: 'uniRadiogroup',
					name : 'BILL_SEND_YN', 
					comboType: 'AU', 
					comboCode: 'B087',
					value:'N',
					width:250,
					allowBlank:false,
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BILL_SEND_YN', newValue.BILL_SEND_YN);
							panelSearch.setActionBtn(newValue);
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.billclass" default="계산서유형"/>', 
					name: 'BILL_TYPE', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B066',
					width:315,
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BILL_TYPE', newValue);					
						}
					}
				},{
					fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>', 
					name: 'CRT_LOC', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'S099',
					width:315,
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CRT_LOC', newValue);
					
						}
					}
				},{
					fieldLabel: '상태', 
					name: 'BILLSTAT', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'S080',
					width:315,
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BILLSTAT', newValue);
					
						}
					}
				},{					
	    			fieldLabel: '<t:message code="system.label.sales.remarks" default="비고"/>',
	    			name:'REMARK',
	    			xtype: 'uniTextfield',
	    			width:315,
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('REMARK', newValue);
					
						}
					}
	    		}
	    	]
		},{
			title: '추가검색', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
    		items:[
    		 {
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>', 
				name: 'BUSI_PRSN', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('salesPrsn'),
				width:315
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '수량단위',						            		
				xtype: 'uniRadiogroup', 
				comboType: 'AU', 
				comboCode: 'S053',
				allowBlank:false,
				value:BsaCodeInfo.gsOptQ,
				width:250
			}]                         
		}],
		listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
	    setActionBtn: function(value)	{
	    	var actionPanel = Ext.getCmp('ssa700ukrv1ActionPanel');
	    	console.log("value : ", value);
	    	if(value.BILL_SEND_YN == "N")	{
	    		actionPanel.down('#sendBtn').setDisabled(false);
	    		actionPanel.down("#sendEmailBtn").setDisabled(true);
	    		actionPanel.down("#cancelSendBtn").setDisabled(true);
	    		actionPanel.down("#confirmEmailBtn").setDisabled(false);
	    	} else {
	    		actionPanel.down("#sendBtn").setDisabled(true);
	    		actionPanel.down("#sendEmailBtn").setDisabled(false);
	    		actionPanel.down("#cancelSendBtn").setDisabled(false);
	    		actionPanel.down("#confirmEmailBtn").setDisabled(true);
	    	}
	    }
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
   
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:0,
		spacing:2,
		border:false,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
				
					}
				}
			},{
				fieldLabel: '등록일',
				xtype: 'uniDateRangefield',
				startFieldName: 'BILL_DATE_FR',
				endFieldName: 'BILL_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:true,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) panelSearch.setValue('BILL_DATE_FR',newValue);				
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) panelSearch.setValue('BILL_DATE_TO',newValue);		 
			    }
			},{
				fieldLabel: '<t:message code="system.label.sales.billclass" default="계산서유형"/>', 
				name: 'BILL_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B066',
				width:315,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BILL_TYPE', newValue);
					}
				}
			},
				Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>', 
					validateBlank: false,
					extParam: {'CUSTOM_TYPE': '3'},
					textFieldName: 'CUSTOM_NAME',
					valueFieldName: 'CUSTOM_CODE',
						listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
									panelSearch.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
						}
				}),
			{
				fieldLabel: '입력일',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSERT_DB_TIME_FR',
				endFieldName: 'INSERT_DB_TIME_TO',
				/*startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),*/
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) panelSearch.setValue('INSERT_DB_TIME_FR',newValue);		
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) panelSearch.setValue('INSERT_DB_TIME_TO',newValue);	
			    }
			},{
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>', 
				name: 'CRT_LOC', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S099',
				width:315,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CRT_LOC', newValue);				
					}
				}
			},
				Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>', 
					validateBlank: false,
					extParam: {'CUSTOM_TYPE': '3'},
					textFieldName: 'MANAGE_CUST_CD',
					valueFieldName: 'MANAGE_CUST_NM',
					listeners: {
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
				}),
			{
				fieldLabel: '전송일',
				xtype: 'uniDateRangefield',
				startFieldName: 'SEND_LOG_TIME_FR',
				endFieldName: 'SEND_LOG_TIME_TO',
				/*startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),*/
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) panelSearch.setValue('SEND_LOG_TIME_FR',newValue);				
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) panelSearch.setValue('SEND_LOG_TIME_TO',newValue);		    		
			    }
			},{
				fieldLabel: '상태', 
				name: 'BILLSTAT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S050',
				width:315,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BILLSTAT', newValue);
				
					}
				}
			},{
				fieldLabel: '전송여부', 
				xtype: 'uniRadiogroup',
				name : 'BILL_SEND_YN', 
				comboType: 'AU', 
				comboCode: 'B087',
				value:'N',
				width:250,
				allowBlank:false,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {	
						console.log(" BILL_SEND_YN : ", newValue);
						panelSearch.setValue('BILL_SEND_YN', newValue.BILL_SEND_YN);
						panelSearch.setActionBtn(newValue);
				
					}
				}
			},{					
    			fieldLabel: '<t:message code="system.label.sales.remarks" default="비고"/>',
    			name:'REMARK',
    			xtype: 'uniTextfield',
    			width:315,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('REMARK', newValue);
				
					}
				}
    		}
		
		]
	})
	
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
			},
			expandLastColumn: false
        },
        tbar:[
        	{
				fieldLabel:'영수/청구', 
				name: 'POPS_CODE', 
				itemId:'popsCode',
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S076',
				labelWidth:60,
				width:150
			},{
				xtype:'button',
				text:'전체반영',
				handler:function()	{
					var gbnField = webCashGrid.down("#popsCode") ;
					if(gbnField)	{
						var gbn = gbnField.getValue();
						Ext.each(webCashStore.data.items, function(record, idx){
								record.set('POPS_CODE', gbn)
						})
					}
				}
			}
			
        ],
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: true,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			if(record.get('TRANSYN_NAME') == 'Error'){//Error컬럼은 선택 못하게
						return false;        			        				
        			}
        		}
        	}
        }),
        viewConfig: {
		    forceFit: true,
		    showPreview: true, // custom property
		    enableRowBody: true, // required to create a second, full-width row to show expanded Record data
		    getRowClass: function(record, rowIndex, rp, ds){ // rp = rowParams
		        if(record.get("DEL_YN") != "Y" && record.get("STS") != ""){
		            return 'essRow';
		        }		        
		        return 'optRow';
		    }
		},
    	features: [
    	    {id : 'webCashGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
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
				UniAppManager.app.fnSetErrMsg(record);
        		
			},
			onGridDblClick: function(grid, record, cellIndex, colName) {
				if(colName == 'CRT_LOC')	{
					var crtLoc = record.get(colName);
					switch(colName)	{
						case '1':	
							var rec = {data : {prgID : BsaInfo.gsSsa560UkrLink}};
							parent.openTab(rec, '/sales/'+BsaInfo.gsSsa560UkrLink+'.do', {});
							break;
						case '3':
							var rec = {data : {prgID : BsaInfo.gsSsa560UkrLink}};
							parent.openTab(rec, '/sales/'+BsaInfo.gsTem100UkrLink+'.do', {});
							break;
						case '5':
							if( record.get("BILL_FLAG") != '2')	{
								var rec = {data : {prgID : BsaInfo.gsSsa560UkrLink}};
								parent.openTab(rec, '/sales/'+BsaInfo.gsStr100UkrLink+'.do', {});
							}
						default:
							break;
						
					}
				}
       			
			},
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
			selectionchange:function(model, selected, eOpts)	{
    			var txtTotal = 0;
    			Ext.each(selected, function(record, idx) {
    				console.log("txtTotal : ", txtTotal);
    				txtTotal += record.get('TOT_AMT_I');
    			})        			
    			centerNorth2Panel.setValue('TXT_TOTAL', txtTotal);
 
    		}
		}
	});
	
	var centerNorthPanel = {
			region: 'north' ,
			weight:-100,
			border:false,
			layout: {type: 'hbox', align: 'stretch'},
			defaults:{
				margin:'0 0 0 0'
			},
			id :'ssa700ukrv1ActionPanel',
			items:[
			{
				xtype:'component',
				flex:1,
				margin:'5 2 2 2',
				style:{
					'color':'blue',
					'vertical-align':'middle',
					'line-height':'29px'
				},
				html: '공급자는 사업장정보, 공급받는자는 거래처정보에서 회사명, 대표자, 업태, 업종, 주소, 전화번호, EMAIL 등을 참조합니다.'
			},{
				xtype:'container',
				layout:'hbox',
				defaults:{
					margin: '10 2 0 0'
				},
				style:{
					'vertical-align':'middle',
					'line-height':'22px'
				},
				items:[{
					xtype:'button',
					text:'전송',
					itemId:'sendBtn',
					handler:function()	{
                        var records = sendBillStore.data.items;
                        Ext.each(records, function(record,i) {
                            if(record.get('CHK') == 'false' ) {
                                Unilite.messageBox(Msg.fsbMsgS0037);    
                            } else {
                                webCashStore.saveStore('N');
                            }
                        });
					}
				},{
					xtype:'button',
					text:'Mail 재전송',
					disabled:true,
					itemId:'sendEmailBtn',
					handler:function()	{
                        var records = sendBillStore.data.items;
                        Ext.each(records, function(record,i) {
                            if(record.get('CHK') == 'false' ) {
                                Unilite.messageBox(Msg.fsbMsgS0037);    
                            } else {
                                webCashStore.saveStore('U');
                            }
                        });
					}
				},{
					xtype:'button',
					text:'전송취소',
					disabled:true,
					itemId:'cancelSendBtn',
					handler:function()	{
                        var records = sendBillStore.data.items;
                        Ext.each(records, function(record,i) {
                            if(record.get('CHK') == 'false' ) {
                                Unilite.messageBox(Msg.fsbMsgS0037);    
                            } else {
                                webCashStore.saveStore('D');
                            }
                        });
					}
				},{
					xtype:'button',
					text:'확인메일전송',
					itemId:'confirmEmailBtn',
					handler:function()	{
						
					}
				}]
			}]
		};
	var centerNorth2Panel = Unilite.createSearchForm('ssa700ukrv1SummaryForm',{
			region: 'north' ,
			weight:-100,
			padding:0,
			defaults:{
				padding:'2 2 2 2'
			},
			bodyStyle:{
				'background-color':'#D9E7F8'
			},
			border:true,
			margin: 1,
			layout: {type: 'hbox', align: 'stretch'},
			defaultType:'uniTextfield',
			items:[
			{					
    			fieldLabel: '에러내용',
    			name:'TXT_ERR_MSG',
    			//width: 450,
    			flex:1,
    			labelWidth:80,
    			readOnly: true
    		},{					
    			fieldLabel: '총합계',
    			name:'TXT_TOTAL',
    			xtype: 'uniNumberfield',
    			value:'0',
    			readOnly:true
    		}]
		})
	
	
	Unilite.Main( {
		borderItems:[ 
	 		 panelSearch,
	 		 webCashGrid,
	 		 panelResult,
	 		 centerNorthPanel,
	 		 centerNorth2Panel
		],  	
		id: 'ssa700ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'], false);
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
				}else  if(record.get('ERR_GUBUN') == ''){
					var param = {'BILLSEQ': record.get('BILLSEQ')}
					ssa700ukrvService.getErrMsg(param, function(provider, response){
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
				//공급자 업체명, 대표자명, 업태, 업종, 주소
				if(Ext.isEmpty(record.get('SELR_CORP_NM')) || Ext.isEmpty(record.get('SELR_CEO')) || Ext.isEmpty(record.get('SELR_BUSS_CONS'))
				   || Ext.isEmpty(record.get('SELR_BUSS_TYPE'))  || Ext.isEmpty(record.get('SELR_ADDR'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '1');
				}
				//공급 받는자 업체명, 대표자명, 주소
				else if(Ext.isEmpty(record.get('BUYR_BUSS_CONS')) || Ext.isEmpty(record.get('BUYR_CEO')) || Ext.isEmpty(record.get('BUYR_ADDR'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '3');
				}
				//공급 받는자 담당자명, 전화번호, 이메일주소
			    else if(Ext.isEmpty(record.get('BUYR_CHRG_NM1')) || Ext.isEmpty(record.get('BUYR_CHRG_TEL1')) || Ext.isEmpty(record.get('BUYR_CHRG_EMAIL1'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '4');
				}				
			});
		}
	});//End of Unilite.Main( {
};

</script>