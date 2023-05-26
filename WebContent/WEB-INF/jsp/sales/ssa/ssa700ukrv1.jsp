<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa700ukrv"  >
   <t:ExtComboStore comboType="BOR120" pgmId="ssa700ukrv"  />         <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="B066" /> <!-- 계산서유형 -->
   <t:ExtComboStore comboType="AU" comboCode="S050" /> <!-- 상태(센드빌) -->
   <t:ExtComboStore comboType="AU" comboCode="B086" /> <!-- 전자문서구분(센드빌) -->
   <t:ExtComboStore comboType="AU" comboCode="S093" /> <!-- 국세청신고제외여부 -->
   <t:ExtComboStore comboType="AU" comboCode="S094" /> <!-- 국세청신고상태 -->
   <t:ExtComboStore comboType="AU" comboCode="S095" /> <!-- 국세청수정사유 -->
   <t:ExtComboStore comboType="AU" comboCode="S096" /> <!-- 세금계산서구분 -->
   <t:ExtComboStore comboType="AU" comboCode="S099" /> <!-- 생성경로 -->
   <t:ExtComboStore comboType="AU" comboCode="S076" /> <!-- 영수 / 청구구분 -->
   
   <t:ExtComboStore comboType="AU" comboCode="S084" /> <!-- 전자세금계산서 연계여부 -->
   <t:ExtComboStore comboType="AU" comboCode="B087" /> <!-- 전송여부 -->
   <t:ExtComboStore items="${SALES_PRSN}" storeId="salesPrsn" /> <!-- 영업담당 -->
   
</t:appConfig>
<script type="text/javascript" >
// 샌드빌 전자세금계산서 발행
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
var billCustomCode = '';
function appMain() {
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Ssa700ukrvSendBillModel', {//"01" 센드빌 모델
		fields: [
			{name: 'CHK'			            	, text: '<t:message code="system.label.sales.selection" default="선택"/>'						, type: 'string' ,editable:false},
			{name: 'TRANSYN_NAME'	            	, text: '전송'						, type: 'string' ,editable:false},
			{name: 'STS'                        	, text: '상태'						, type: 'string' ,editable:false, comboType: 'AU' , comboCode: 'S050'},
			{name: 'REPORT_STAT'                	, text: '국세청신고상태'			, type: 'string' ,editable:false, comboType: 'AU' , comboCode: 'S094'},
			{name: 'CRT_LOC'                    	, text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'					, type: 'string' ,editable:false, comboType: 'AU' , comboCode: 'S099'},
			{name: 'BILL_FLAG'            			, text: '세금계산서구분'			, type: 'string' ,editable:false, comboType: 'AU' , comboCode: 'S096'},
			{name: 'GUBUN'		                    , text: '영수/청구'					, type: 'string' , comboType: 'AU' , comboCode: 'S076'},
			{name: 'DT'		                    	, text: '<t:message code="system.label.sales.publishdate" default="발행일"/>'					, type: 'uniDate',editable:false},
			{name: 'CUSTOM_CODE'	            	, text: '<t:message code="system.label.sales.client" default="고객"/>'					, type: 'string',editable:false},
			{name: 'RCOMPANY'		            	, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'					, type: 'string',editable:false},
			{name: 'RVENDERNO'		            	, text: '사업자번호'				, type: 'string',editable:false},
			{name: 'RREG_ID'                    	, text: '종사업자번호'				, type: 'string',editable:false},
			{name: 'BILLTYPE'               		, text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'				, type: 'string',editable:false , comboType: 'AU' , comboCode: 'B066'},
			{name: 'SUPMONEY'                   	, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'					, type: 'uniPrice',editable:false},
			{name: 'TAXMONEY'		            	, text: '<t:message code="system.label.sales.taxamount" default="세액"/>'						, type: 'uniPrice',editable:false},
			{name: 'TOT_AMT_I'   	            	, text: '<t:message code="system.label.sales.totalamount" default="합계"/>'						, type: 'uniPrice',editable:false},
			{name: 'SEND_DATE'		            	, text: '전송일시'					, type: 'uniDate',editable:false},
			{name: 'BILLSEQ'		            	, text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'				, type: 'string',editable:false},
			{name: 'BILLPRSN'		            	, text: '<t:message code="system.label.sales.charger" default="담당자"/>'					, type: 'string'},
			{name: 'HANDPHON'		            	, text: '핸드폰번호'				, type: 'string',editable:false},
			{name: 'REMAIL'			            	, text: 'E-MAIL'					, type: 'string',editable:false},
			{name: 'EB_NUM'			            	, text: '전자문서번호'				, type: 'string',editable:false},
			{name: 'REPORT_AMEND_CD'            	, text: '국세청수정사유'			, type: 'string' , comboType: 'AU' , comboCode: 'S095'},
			{name: 'BIGO'                       	, text: '<t:message code="system.label.sales.remarks" default="비고"/>'						, type: 'string',editable:false},
			{name: 'REPORT_ISSUE_ID'            	, text: '국세청고유코드'			, type: 'string'},
			{name: 'REPORT_EXCEPT_YN'            	, text: '국세청신고제외여부'		, type: 'string',editable:false , comboType: 'AU' , comboCode: 'S093'},
			{name: 'TRANSYN'		            	, text: '전송여부'					, type: 'string',editable:false},
			{name: 'BILLTYPE'                   	, text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'				, type: 'string',editable:false , comboType: 'AU' , comboCode: 'B066' },
			{name: 'TAXRATE'                    	, text: '세율구분'					, type: 'string',editable:false},
			{name: 'CASH'                       	, text: '세금계산서상의 현금지급액'	, type: 'uniPrice',editable:false},
			{name: 'CHECKS'                     	, text: '세금계산서상의 수표지급액'	, type: 'uniPrice',editable:false},
			{name: 'NOTE'                       	, text: '세금계산서상의 어음지급액'	, type: 'uniPrice',editable:false},
			{name: 'CREDIT'                     	, text: '세금계산서상의 외상미수금'	, type: 'uniPrice',editable:false},
			{name: 'SVENDERNO'                  	, text: '사업자번호'				, type: 'string',editable:false},     //'공급자 사업자번호'	
			{name: 'SCOMPANY'                   	, text: '업체명'					, type: 'string',editable:false},	   //'공급자 업체명'	
			{name: 'SREG_ID'                    	, text: '종사업자번호'				, type: 'string',editable:false},     //'공급자 종사업자번호'
			{name: 'SCEONAME'                   	, text: '대표자명'					, type: 'string',editable:false},     //'공급자 대표자명'	
			{name: 'SUPTAE'                     	, text: '업태'						, type: 'string',editable:false},     //'공급자 업태'	
			{name: 'SUPJONG'                    	, text: '업종'						, type: 'string',editable:false},     //'공급자 업종'	
			{name: 'SADDRESS'                   	, text: '<t:message code="system.label.sales.address" default="주소"/>'						, type: 'string',editable:false},     //'공급자 주소'	
			{name: 'SADDRESS2'                  	, text: '상세주소'					, type: 'string',editable:false},     //'공급자 상세주소'	
			{name: 'SUSER'                      	, text: '<t:message code="system.label.sales.chargername" default="담당자명"/>'					, type: 'string',editable:false},     //'공급자 담당자명'	
			{name: 'SDIVISION'                  	, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'					, type: 'string',editable:false},	   //'공급자 부서명'	
			{name: 'STELNO'                     	, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'					, type: 'string',editable:false},     //'공급자 전화번호'	
			{name: 'SEMAIL'                     	, text: '이메일주소'				, type: 'string',editable:false},     //'공급자 이메일주소'	
			{name: 'RCEONAME'                   	, text: '대표자명'					, type: 'string',editable:false},     //'공급받는자 대표자명'
			{name: 'RUPTAE'                     	, text: '업태'						, type: 'string',editable:false},     //'공급받는자 업태'	
			{name: 'RUPJONG'                    	, text: '업종'						, type: 'string',editable:false},     //'공급받는자 업종'	
			{name: 'RADDRESS'                   	, text: '<t:message code="system.label.sales.address" default="주소"/>'						, type: 'string',editable:false},     //'공급받는자 주소'	
			{name: 'RADDRESS2'                  	, text: '상세주소'					, type: 'string',editable:false},	   //'공급받는자 상세주소'
			{name: 'RUSER'                      	, text: '<t:message code="system.label.sales.chargername" default="담당자명"/>'					, type: 'string',editable:false},     //'공급받는자 담당자명'
			{name: 'RDIVISION'                  	, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'					, type: 'string',editable:false},     //'공급받는자 부서명'	
			{name: 'RTELNO'                     	, text: '<t:message code="system.label.sales.phoneno1" default="전화번호"/>'					, type: 'string',editable:false},     //'공급받는자 전화번호'
			{name: 'REVERSEYN'                  	, text: '역발행여부'				, type: 'string',editable:false},
			{name: 'SENDID'                     	, text: '공급자'					, type: 'string',editable:false},
			{name: 'RECVID'                     	, text: '공급받는자'				, type: 'string',editable:false},
			{name: 'DIV_CODE'                   	, text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'				, type: 'string',editable:false},
			{name: 'SALE_DIV_CODE'              	, text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'				, type: 'string',editable:false},
			{name: 'DEL_YN'                     	, text: '삭제가능여부'				, type: 'string',editable:false},
			{name: 'COMP_CODE'                  	, text: 'COMP_CODE'					, type: 'string',editable:false},
			{name: 'BILL_MEM_TYPE'              	, text: '전자문서구분'				, type: 'string',editable:false , comboType: 'AU' , comboCode: 'S096' },
			{name: 'CREATE_DT'                  	, text: '생성일자'					, type: 'uniDate',editable:false},
			{name: 'REPORT_ETC01'               	, text: '당초승인번호'				, type: 'string',editable:false},
			{name: 'ERR_GUBUN'                  	, text: '에러구분'					, type: 'string',editable:false},
			{name: 'BEFORE_PUB_NUM'             	, text: '수정전세금계산서번호'		, type: 'string',editable:false},
			{name: 'ORIGINAL_PUB_NUM'            	, text: '원본세금계산서번호'		, type: 'string',editable:false},
			{name: 'PLUS_MINUS_TYPE'            	, text: '계산서구분'				, type: 'string',editable:false},
			{name: 'SEQ_GUBUN'                  	, text: '순번정열'					, type: 'string',editable:false},
			{name: 'BUSI_PRSN'                  	, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'					, type: 'string',editable:false, store: Ext.data.StoreManager.lookup('salesPrsn')},
			{name: 'BILLSTAT'                  		, text: '상태'						, type: 'string',editable:false, comboYype:'AU', comboCode:'S050'},
			{name: 'OPR_FLAG'                  		, text: '처리형태'					, type: 'string',editable:false}
			
		]
	});//End of Unilite.defineModel('Ssa700ukrvSendBillModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read : 'ssa700ukrvService.selectSendBillMaster' ,
    	   update : 'ssa700ukrvService.saveSendBill',
		   syncAll: 'ssa700ukrvService.saveAllSendBill'
		}
	});
	
	var sendBillStore = Unilite.createStore('ssa700ukrvSendBillStore',{
			model: 'Ssa700ukrvSendBillModel',
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            loadStoreRecords: function()	{
            	//var param = (panelSearch.getCollapsed() === false) ? panelSearch.getValues() : panelResult.getValues();
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});			
			},
			saveStore : function(OPR_FLAG)	{	
				var selRecords = sendBillGrid.getSelectedRecords();
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
			} ,
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(!Ext.isEmpty(records)){
	           			//directStore.loadStoreRecords(records[0]);
						UniAppManager.app.fnSendBillColSet(records);	//전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기		
						store.commitChanges();
			            }
	           	}
		}
	});		// End of var sendBillStore = Unilite.createStore('ssa700ukrvSendBillStore',{
	
        
	
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
					comboCode: 'S050',
					width:315,
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BILLSTAT', newValue);
					
						}
					}
				},{
					fieldLabel: '전자문서구분', 
					name: 'D_GUBUN', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B086',
					width:315,
					listeners:{
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('D_GUBUN', newValue);
					
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
				fieldLabel: '전자문서구분', 
				name: 'D_GUBUN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B086',
				width:315,
				listeners:{
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('D_GUBUN', newValue);
				
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
    /**
     * sendBillGrid 정의(Grid Panel)
     * @type 
     */
	
	var sendBillGrid = Unilite.createGrid('Ssa700ukrvSendBillGrid', {
       // for tab   
		region: 'center' ,
        uniOpt:{
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
				name: 'GUBUN', 
				itemId:'gubun',
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S076',
				labelWidth:60,
				width:150
			},{
				xtype:'button',
				text:'전체반영',
				handler:function()	{
					var gbnField = sendBillGrid.down("#gubun") ;
					if(gbnField)	{
						var gbn = gbnField.getValue();
						Ext.each(sendBillStore.data.items, function(record, idx){
								record.set('GUBUN', gbn)
						})
					}
				}
			}
			
        ],
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	uniOpt:{
        		onLoadSelectFirst: false
        	},
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			if(record.get('TRANSYN_NAME')== 'Error'){//Error컬럼은 선택 못하게
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
    	    {id : 'sendBillGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
		store: sendBillStore,
		columns: [
			{dataIndex: 'CHK'			              	, width:33,locked:true, hidden: true},
			{dataIndex: 'TRANSYN_NAME'	              	, width:80,locked:true
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            	}
            	,renderer:function(value){
	            	if(value == 'Error') {
	            		return '<font color="red">'+value+'</font>';	
	            	}
	            	return value;
	            }
            },
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
			 		uniOpt:{
			 			recordFields : ['CUSTOM_CODE'],
			 			grid:'Ssa700ukrvSendBillGrid'
			 		},
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
			 		uniOpt:{
			 			recordFields : ['CUSTOM_CODE'],
			 			grid:sendBillGrid
			 		},
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
			{dataIndex: 'BILL_MEM_TYPE'                	, width:120, hidden:true},
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
	});//End of var sendBillGrid = Unilite.createGrid('ssa700ukrvGrid1', {   
	
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
					id: 'SEND_BTN',
					handler:function()	{
						var records = sendBillStore.data.items;
						Ext.each(records, function(record,i) {
						    if(record.get('CHK') == 'false' ) {
                                Unilite.messageBox(Msg.fsbMsgS0037);    
                            } else {
                                sendBillStore.saveStore('N');
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
                                sendBillStore.saveStore('U');
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
                                sendBillStore.saveStore('D');
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
	 		 sendBillGrid,
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
			sendBillStore.loadStoreRecords();
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
		fnSendBillColSet: function(records) {	//센드빌 전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
			Ext.each(records, function(record) {
				//공급자 업체명, 전화번호, 이메일주소
				if(Ext.isEmpty(record.get('SCOMPANY')) || Ext.isEmpty(record.get('SCEONAME')) || Ext.isEmpty(record.get('SUPTAE')) || Ext.isEmpty(record.get('SUPJONG')) || Ext.isEmpty(record.get('SADDRESS'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '1');
				}
				//공급자 담당자명, 전화번호, 이메일
				else if(Ext.isEmpty(record.get('SUSER')) || Ext.isEmpty(record.get('STELNO')) || Ext.isEmpty(record.get('SEMAIL'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '2');
				}
				//공급 받는자 업체명, 대표자명, 주소
				else if(Ext.isEmpty(record.get('RCOMPANY')) || Ext.isEmpty(record.get('RCEONAME')) || Ext.isEmpty(record.get('RADDRESS'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '3');
				}
				//공급 받는자 담당자명, 전화번호, 이메일주소
				else if(Ext.isEmpty(record.get('RUSER')) || Ext.isEmpty(record.get('RTELNO')) || Ext.isEmpty(record.get('REMAIL'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '4');
				}
				//공급 받는자 업종, 업태
				else if(Ext.isEmpty(record.get('RUPTAE')) || Ext.isEmpty(record.get('RUPJONG'))){
					record.set('TRANSYN_NAME', 'Error');
					record.set('ERR_GUBUN', '5');
				}
			});
			
		}
	});//End of Unilite.Main( {
};

</script>