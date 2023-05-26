<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa710ukrv"  >
   <t:ExtComboStore comboType="BOR120" pgmId="ssa710ukrv" />         <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="B066" /> <!-- 계산서유형 -->
   <t:ExtComboStore comboType="AU" comboCode="S099" /> <!-- 생성경로 -->
   <t:ExtComboStore comboType="AU" comboCode="S050" /> <!-- 상태 -->
   <t:ExtComboStore comboType="AU" comboCode="B086" /> <!-- 전자문서구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}   
</style>
<script type="text/javascript" >

function appMain() {
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Ssa710ukrvModel', {
		fields: [
			{name: 'CHK'			            	, text: '<t:message code="system.label.sales.selection" default="선택"/>'				, type: 'string'},
			{name: 'TRANSYN_NAME'	            	, text: '전송'				, type: 'string'},
			{name: 'STS'                        	, text: '상태'				, type: 'string'},
			{name: 'REPORT_STAT'                	, text: '국세청신고상태'			, type: 'string'},
			{name: 'CRT_LOC'                    	, text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'				, type: 'string'},
			{name: 'PLUS_MINUS_TYPE'            	, text: '세금계산서 구분'			, type: 'string'},
			{name: 'GUBUN'                      	, text: '영수/청구'			, type: 'string'},
			{name: 'DT'		                    	, text: '<t:message code="system.label.sales.publishdate" default="발행일"/>'				, type: 'uniDate'},
			{name: 'CUSTOM_CODE'	            	, text: '<t:message code="system.label.sales.client" default="고객"/>'				, type: 'string'},
			{name: 'RCOMPANY'		            	, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'				, type: 'string'},
			{name: 'RVENDERNO'		            	, text: '사업자번호'			, type: 'string'},
			{name: 'RREG_ID'                    	, text: '종사업자번호'			, type: 'string'},
			{name: 'BILLTYPENAME'               	, text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'			, type: 'string'},
			{name: 'SUPMONEY'                   	, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'				, type: 'uniPrice'},
			{name: 'TAXMONEY'		            	, text: '<t:message code="system.label.sales.taxamount" default="세액"/>'				, type: 'uniPrice'},
			{name: 'TOT_AMT_I'   	            	, text: '<t:message code="system.label.sales.totalamount" default="합계"/>'				, type: 'string'},
			{name: 'SEND_DATE'		            	, text: '전송일시'				, type: 'uniDate'},
			{name: 'BILLSEQ'		            	, text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'			, type: 'string'},
			{name: 'BILLPRSN'		            	, text: '<t:message code="system.label.sales.charger" default="담당자"/>'				, type: 'string'},
			{name: 'HANDPHON'		            	, text: '핸드폰번호'			, type: 'string'},
			{name: 'REMAIL'			            	, text: 'E-MAIL'				, type: 'string'},
			{name: 'EB_NUM'			            	, text: '전자문서번호'			, type: 'string'},
			{name: 'REPORT_AMEND_CD'            	, text: '수정사유'				, type: 'string'},
			{name: 'BIGO'                       	, text: '<t:message code="system.label.sales.remarks" default="비고"/>'				, type: 'string'},
			{name: 'REPORT_ISSUE_ID'            	, text: '국세청고유코드'			, type: 'string'},
			{name: 'REPORT_EXCEPT_YN'            	, text: '국세청신고제외여부'		, type: 'string'},
			{name: 'TRANSYN'		            	, text: '전송여부'				, type: 'string'},
			{name: 'BILLTYPE'                   	, text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'			, type: 'string'},
			{name: 'TAXRATE'                    	, text: '세율구분'				, type: 'string'},
			{name: 'CASH'                       	, text: '세금계산서상의 현금지급액'	, type: 'uniPrice'},
			{name: 'CHECKS'                     	, text: '세금계산서상의 수표지급액'	, type: 'uniPrice'},
			{name: 'NOTE'                       	, text: '세금계산서상의 어음지급액'	, type: 'uniPrice'},
			{name: 'CREDIT'                     	, text: '세금계산서상의 외상미수금'	, type: 'uniPrice'},
			
			{name: 'SVENDERNO'                  	, text: '공급자 사업자번호'		, type: 'string'},
			{name: 'SCOMPANY'                   	, text: '공급자 업체명'			, type: 'string'},
			{name: 'SREG_ID'                    	, text: '공급자 종사업자번호'		, type: 'string'},
			{name: 'SCEONAME'                   	, text: '공급자 대표자명'			, type: 'string'},
			{name: 'SUPTAE'                     	, text: '공급자 업태'			, type: 'string'},
			{name: 'SUPJONG'                    	, text: '공급자 업종'			, type: 'string'},
			{name: 'SADDRESS'                   	, text: '공급자 주소'			, type: 'string'},
			{name: 'SADDRESS2'                  	, text: '공급자 상세주소'			, type: 'string'},
			{name: 'SUSER'                      	, text: '공급자 담당자명'			, type: 'string'},
			{name: 'SDIVISION'                  	, text: '공급자 부서명'			, type: 'string'},
			{name: 'STELNO'                     	, text: '공급자 전화번호'			, type: 'string'},
			{name: 'SEMAIL'                     	, text: '공급자 이메일주소'		, type: 'string'},
			{name: 'RCEONAME'                   	, text: '공급받는자 대표자명'		, type: 'string'},
			{name: 'RUPTAE'                     	, text: '공급받는자 업태'			, type: 'string'},
			{name: 'RUPJONG'                    	, text: '공급받는자 업종'			, type: 'string'},
			{name: 'RADDRESS'                   	, text: '공급받는자 주소'			, type: 'string'},
			{name: 'RADDRESS2'                  	, text: '공급받는자 상세주소'		, type: 'string'},
			{name: 'RUSER'                      	, text: '공급받는자 담당자명'		, type: 'string'},
			{name: 'RDIVISION'                  	, text: '공급받는자 부서명'		, type: 'string'},
			{name: 'RTELNO'                     	, text: '공급받는자 전화번호'		, type: 'string'},
			{name: 'REVERSEYN'                  	, text: '역발행여부'			, type: 'string'},
			{name: 'SENDID'                     	, text: '공급자'				, type: 'string'},
			{name: 'RECVID'                     	, text: '공급받는자'			, type: 'string'},
			{name: 'DIV_CODE'                   	, text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'			, type: 'string'},
			{name: 'SALE_DIV_CODE'              	, text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'			, type: 'string'},
			{name: 'DEL_YN'                     	, text: '삭제가능여부'			, type: 'string'},
			{name: 'COMP_CODE'                  	, text: 'COMP_CODE'			, type: 'string'},
			{name: 'BILL_MEM_TYPE'              	, text: '전자문서구분'				, type: 'string'},
			{name: 'CREATE_DT'                  	, text: '생성일자'				, type: 'uniDate'},
			{name: 'REPORT_ETC01'               	, text: '당초승인번호'			, type: 'string'},
			{name: 'ERR_GUBUN'                  	, text: '에러구분'				, type: 'string'},
			{name: 'BEFORE_PUB_NUM'             	, text: '수정전세금계산서번호'		, type: 'string'},
			{name: 'ORIGINAL_PUB_NUM'            	, text: '원본세금계산서번호'		, type: 'string'},
			
			{name: 'SEQ_GUBUN'                  	, text: '순번정열'				, type: 'string'}
		]
	});//End of Unilite.defineModel('Ssa710ukrvModel', {
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore1 = Unilite.createStore('ssa710ukrvMasterStore1',{
		model: 'Ssa710ukrvModel',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결 
			editable: false,         // 수정 모드 사용 
			deletable:false,         // 삭제 가능 여부 
			useNavi : false         // prev | next 버튼 사용
		},
			autoLoad: false,
			proxy: {
				type: 'direct',
				api: {         
					read: 'ssa710ukrvService.selectList'                   
				}
			},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();         
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
	});//End of var directMasterStore1 = Unilite.createStore('ssa710ukrvMasterStore1',{

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
				fieldLabel: '<t:message code="system.label.sales.publishdate" default="발행일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: '',
				endFieldName: '',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank:true
			},
				Unilite.popup('AGENT_CUST', { 
					fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>', 
					 
					validateBlank: false,
					extParam: {'CUSTOM_TYPE': '3'}
				}),
			{
				fieldLabel: '<t:message code="system.label.sales.billclass" default="계산서유형"/>', 
				name: '', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B066'
			},{
				fieldLabel: '전자문서구분', 
				name: '', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B086'
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '전송여부',						            		
				id: 'rdoSelect',
				items: [{
					boxLabel: '미전송', 
					width:60, 
					name: 'rdoSelect', 
					inputValue: 'A', 
					checked: true
				},{
					boxLabel: '전송', 
					width:60, 
					name: 'rdoSelect', 
					inputValue: 'Y'
				}]
			},{
				fieldLabel: '상태', 
				name: '', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S050'
			},{
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>', 
				name: '', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'S099'
			},{					
    			fieldLabel: '에러내용',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly:true
    		}]                         
		}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ssa710ukrvGrid1', {
       // for tab       
		layout: 'fit',
		region: 'center',
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'CHK'			              	, width:33,locked:true},
			{dataIndex: 'TRANSYN_NAME'	              	, width:60,locked:true},
			{dataIndex: 'STS'                          	, width:60,locked:true},
			{dataIndex: 'REPORT_STAT'                  	, width:110,locked:true},
			{dataIndex: 'CRT_LOC'                      	, width:80,locked:true},
			{dataIndex: 'PLUS_MINUS_TYPE'              	, width:120,locked:true},
			{dataIndex: 'GUBUN'                        	, width:100,locked:true},
			{dataIndex: 'DT'		                    , width:86,locked:true},
			{dataIndex: 'CUSTOM_CODE'	              	, width:86,locked:true},
			{dataIndex: 'RCOMPANY'		              	, width:160,locked:true},
			{dataIndex: 'RVENDERNO'		              	, width:100},
			{dataIndex: 'RREG_ID'                      	, width:88},
			{dataIndex: 'BILLTYPENAME'                 	, width:86},
			{dataIndex: 'SUPMONEY'                     	, width:113},
			{dataIndex: 'TAXMONEY'		              	, width:86},
			{dataIndex: 'TOT_AMT_I'   	              	, width:113},
			{dataIndex: 'SEND_DATE'		              	, width:166},
			{dataIndex: 'BILLSEQ'		              	, width:120},
			{dataIndex: 'BILLPRSN'		              	, width:100},
			{dataIndex: 'HANDPHON'		              	, width:100},
			{dataIndex: 'REMAIL'			            , width:166},
			{dataIndex: 'EB_NUM'			            , width:120},
			{dataIndex: 'REPORT_AMEND_CD'              	, width:133},
			{dataIndex: 'BIGO'                         	, width:120},
			{dataIndex: 'REPORT_ISSUE_ID'              	, width:166},
			{dataIndex: 'REPORT_EXCEPT_YN'             	, width:166},
			{dataIndex: 'TRANSYN'		              	, width:100,hidden:true},
			{dataIndex: 'BILLTYPE'                     	, width:33,hidden:true},
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
			{dataIndex: 'ERR_GUBUN'                    	, width:33,hidden:true},
			{dataIndex: 'BEFORE_PUB_NUM'               	, width:33,hidden:true},
			{dataIndex: 'ORIGINAL_PUB_NUM'             	, width:33,hidden:true},
			
			{dataIndex: 'SEQ_GUBUN'                    	, width:33,hidden:true}
		] 
	});//End of var masterGrid = Unilite.createGrid('ssa710ukrvGrid1', {   

	Unilite.Main( {
		borderItems:[ 
	 		 masterGrid,
			panelSearch
		],  	
		id: 'ssa710ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown: function() {         
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ", viewLocked);
			console.log("viewNormal: ", viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);   
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');   
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});//End of Unilite.Main( {
};


</script>