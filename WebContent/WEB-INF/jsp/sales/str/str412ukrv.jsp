<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str412ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="str412ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B086" /> <!-- 전자문서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S050" /> <!-- 상태 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var BsaCodeInfo = {
	gsStr100UkrLink: '${gsStr100UkrLink}',
	gsOptQ: '${gsOptQ}',
	gsBillYN: ${gsBillYN}
};
var isOptQ = false; //수량단위구분, 단가금액출력여부
if(BsaCodeInfo.gsOptQ == "2"){
	isOptQ = true;	
}

var activeGrid;			// 보여질 그리드(sendBill or webCash)
var beforeRowIndex;		//마스터그리드 같은row중복 클릭시 다시 load되지 않게

var billTypeIsHidden = true;	//전자문서구분 hidden 여부
BsaCodeInfo.gsBillYN[0].SUB_CODE == "01"? billTypeIsHidden = false : billTypeIsHidden = true;

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Str412ukrvSendBillModel', {//"01" 샌드빌용 모델
	    fields: [  	 
			{name: 'TRANSYN_NAME'					    ,text: '전송'						,type: 'string'},  	 
			{name: 'STS'							    ,text: '상태'						,type: 'string'},  	 
			{name: 'DT'			   				   		,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'					,type: 'uniDate'},  	 
			{name: 'CUSTOM_CODE'					    ,text: '<t:message code="system.label.sales.client" default="고객"/>'					,type: 'string'},  	 
			{name: 'RCOMPANY'						    ,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'					,type: 'string'},  	 
			{name: 'RVENDERNO'						    ,text: '사업자번호'				,type: 'string'},  	 
			{name: 'SUPMONEY'						    ,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'					,type: 'uniPrice'},  	 
			{name: 'TAXMONEY'						    ,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'						,type: 'uniPrice'},  	 
			{name: 'TOT_AMT_I'						    ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'						,type: 'uniPrice'},  	 
			{name: 'SEND_DATE'						    ,text: '전송일시'					,type: 'uniDate'},  	 
			{name: 'BILLSEQ'						    ,text: '<t:message code="system.label.sales.tranno" default="수불번호"/>'					,type: 'string'},  	 
			{name: 'EB_NUM'							    ,text: '전자문서번호'				,type: 'string'},  	 
			{name: 'CREATE_DT'						    ,text: '생성된 일자'				,type: 'uniDate'},  	 
			{name: 'TRANSYN'						    ,text: '전송'						,type: 'string'},  	 
			{name: 'TAXRATE'						    ,text: '세율구분'					,type: 'string'},  	 
			{name: 'BILLTYPE'						    ,text: '거래명세서종류'				,type: 'string'},  	 
			{name: 'CASH'							    ,text: '거래명세서상의 현금지급액'		,type: 'uniPrice'},  	 
			{name: 'CHECKS'							    ,text: '거래명세서상의 수표지급액'		,type: 'uniPrice'},  	 
			{name: 'NOTE'							    ,text: '거래명세서상의 어음지급액'		,type: 'uniPrice'},  	 
			{name: 'CREDIT'							    ,text: '거래명세서상의 외상미수금'		,type: 'uniPrice'},  	 
			{name: 'GUBUN'							    ,text: '영수/청구 구분'				,type: 'string'},  	 
			{name: 'BIGO'							    ,text: '<t:message code="system.label.sales.remarks" default="비고"/>'						,type: 'string'},  	 
			{name: 'SVENDERNO'						    ,text: '공급자 사업자번호'			,type: 'string'},  	 
			{name: 'SCOMPANY'						    ,text: '공급자 업체명'				,type: 'string'},  	 
			{name: 'SCEONAME'						    ,text: '공급자 대표자명'				,type: 'string'},  	 
			{name: 'SUPTAE'							    ,text: '공급자업태'				,type: 'string'},  	 
			{name: 'SUPJONG'						    ,text: '공급자 업종'				,type: 'string'},  	 
			{name: 'SADDRESS'						    ,text: '공급자주소'				,type: 'string'},  	 
			{name: 'SADDRESS2'						    ,text: '공급자 상세주소'				,type: 'string'},  	 
			{name: 'SUSER'							    ,text: '공급자 담당자명'				,type: 'string'},  	 
			{name: 'SDIVISION'						    ,text: '공급자 부서명'				,type: 'string'},  	 
			{name: 'STELNO'							    ,text: '공급자 전화번호'				,type: 'string'},  	 
			{name: 'SEMAIL'							    ,text: '공급자 이메일주소'			,type: 'string'},  	 
			{name: 'RCEONAME'						    ,text: '공급받는자 대표자명'			,type: 'string'},  	 
			{name: 'RUPTAE'							    ,text: '공급받는자 업태'				,type: 'string'},  	 
			{name: 'RUPJONG'						    ,text: '공급받는자 업종'				,type: 'string'},  	 
			{name: 'RADDRESS'						    ,text: '공급받는자 주소'				,type: 'string'},  	 
			{name: 'RADDRESS2'						    ,text: '공급받는자 상세주소'			,type: 'string'},  	 
			{name: 'RUSER'							    ,text: '<t:message code="system.label.sales.chargername" default="담당자명"/>'					,type: 'string'},  	 
			{name: 'RDIVISION'						    ,text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'					,type: 'string'},  	 
			{name: 'RTELNO'							    ,text: '핸드폰'					,type: 'string'},
			{name: 'REMAIL'							    ,text: 'E-MAIL'					,type: 'string'},
			{name: 'REVERSEYN'						    ,text: '역발행여부'				,type: 'string'},  	 
			{name: 'SENDID'							    ,text: '공급자'					,type: 'string'},  	 
			{name: 'RECVID'							    ,text: '공급받는자'				,type: 'string'},  	 
			{name: 'DIV_CODE'						    ,text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'				,type: 'string'},  	 
			{name: 'DEL_YN'							    ,text: '삭제가능여부'				,type: 'string'},  	 
			{name: 'COMP_CODE'						    ,text: 'COMP_CODE'				,type: 'string'},  	 
			{name: 'BILL_MEM_TYPE'					    ,text: '회원구분'					,type: 'string'},  	 
			{name: 'ERR_GUBUN'     				    	,text: '에러구분'					,type: 'string'}
		]
	});
	
	Unilite.defineModel('str412ukrvWebCashModel', {//"02" 웹캐시용 모델
	    fields: [  	 
	    	{name: 'TRANSYN_NAME'						,text: '전송'						,type: 'string'},
			{name: 'STAT_CODE'							,text: '상태'						,type: 'string'},
			{name: 'STS'			    				,text: '상태'						,type: 'string'},
			{name: 'REGS_DATE'							,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'					,type: 'uniDate'},
			{name: 'SELR_CORP_NO'						,text: '공급자사업자번호'			,type: 'string'},
			{name: 'SELR_CORP_NM'						,text: '공급자업체명'				,type: 'string'},
			{name: 'SELR_CEO'							,text: '공급자대표자명'				,type: 'string'},
			{name: 'SELR_CORP_ADDS'						,text: '공급자주소'				,type: 'string'},
			{name: 'SELR_BUSS_CONS'						,text: '공급자업태'				,type: 'string'},
			{name: 'SELR_BUSS_TYPE'						,text: '공급자업종'				,type: 'string'},
			{name: 'SELR_TEL'							,text: '공급자전화번호'				,type: 'string'},
			{name: 'BUYR_CORP_NO'						,text: '사업자번호'				,type: 'string'},
			{name: 'CUSTOM_CODE'						,text: '<t:message code="system.label.sales.client" default="고객"/>'					,type: 'string'},
			{name: 'BUYR_CORP_NM'						,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'					,type: 'string'},
			{name: 'BUYR_CEO'							,text: '공급받는자대표자명'			,type: 'string'},
			{name: 'BUYR_CORP_ADDS'						,text: '공급받는자주소'				,type: 'string'},
			{name: 'BUYR_TEL'							,text: '공급받는자전화번호'			,type: 'string'},
			{name: 'CHRG_AMT'							,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'					,type: 'uniPrice'},
			{name: 'TAX_AMT'							,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'						,type: 'uniPrice'},
			{name: 'TOTL_AMT'							,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'						,type: 'uniPrice'},
			{name: 'SUM_AMT'							,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'						,type: 'uniPrice'},
			{name: 'BUYR_CHRG_NM1'						,text: '<t:message code="system.label.sales.charger" default="담당자"/>'					,type: 'string'},
			{name: 'BUYR_CHRG_MOBL1'					,text: '핸드폰'					,type: 'string'},
			{name: 'BUYR_CHRG_EMAIL1'					,text: 'E-MAIL'					,type: 'string'},
			{name: 'SND_MAL_YN'							,text: 'Email발행요청유무'			,type: 'string'},
			{name: 'SND_SMS_YN'							,text: 'SMS발행요청유무'			,type: 'string'},
			{name: 'SND_FAX_YN'							,text: 'FAX발행요청유무'			,type: 'string'},
			{name: 'BILLSEQ'							,text: '<t:message code="system.label.sales.tranno" default="수불번호"/>'					,type: 'string'},
			{name: 'ERP_SEQ'							,text: '전자문서번호'				,type: 'string'},
			{name: 'DIV_CODE'							,text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'				,type: 'string'},
			{name: 'DEL_YN'			    				,text: '삭제가능여부'				,type: 'string'},
			{name: 'COMP_CODE'							,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					,type: 'string'},
			{name: 'ERR_GUBUN'							,text: '에러구분'					,type: 'string'},
			{name: 'SEND_DATE'							,text: '전송일시'					,type: 'uniDate'}			
		]
	});
		
		Unilite.defineModel('str412ukrvDetailModel', {
	    fields: [ 		
			{name: 'DT'			 	       	,text: '출고일자'					,type: 'uniDate'},
			{name: 'CODE'		 	       	,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'NAME'		 	       	,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'UNIT'		 	       	,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'VLM'		 	       	,text: '<t:message code="system.label.sales.qty" default="수량"/>'						,type: 'uniQty'},
			{name: 'DANGA'		 	       	,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniPrice'},
			{name: 'SUP'		 	       	,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'					,type: 'uniPrice'},
			{name: 'TAX'		 	       	,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'						,type: 'uniPrice'},
			{name: 'COMP_CODE'	 	       	,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					,type: 'string'},
			{name: 'DIV_CODE'	 	       	,text: '<t:message code="system.label.sales.division" default="사업장"/>'					,type: 'string'},
			{name: 'INOUT_NUM'	 	       	,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					,type: 'string'},
			{name: 'INOUT_SEQ'	 	       	,text: '<t:message code="system.label.sales.seq" default="순번"/>'						,type: 'string'},
			{name: 'ITEM_CODE'	 	       	,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'CUSTOM_CODE' 	       	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
			{name: 'SALE_UNIT'	 	       	,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'					,type: 'string'},
			{name: 'TRANS_RATE'	 	       	,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'						,type: 'int'} 	 
		]  
	});		//End of Unilite.defineModel('Str412ukrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	
	var sendBillStore = Unilite.createStore('str412ukrvSendBillStore',{
			model: 'Str412ukrvSendBillModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'str412ukrvService.selectSendBillMaster'                	
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
	           			detailStore.loadStoreRecords(records[0]);
	           			
	           			var viewNormal = detailGrid.getView();						
						viewNormal.getFeature('detailGridTotal').toggleSummaryRow(true);
						UniAppManager.app.fnSendBillColSet(records);	//전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기						
	           		}else{
	           			detailStore.removeAll('clear');           		
	           		}
	           	}
			}
	});		// End of var sendBillStore = Unilite.createStore('str412ukrvSendBillStore',{
	
	var webCashStore = Unilite.createStore('str412ukrvWebCashStore',{
			model: 'str412ukrvWebCashModel',
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'str412ukrvService.WebCashMaster'                	
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
	           			detailStore.loadStoreRecords(records[0]);
	           			var viewNormal = detailGrid.getView();						
						viewNormal.getFeature('detailGridTotal').toggleSummaryRow(true);						
						UniAppManager.app.fnWebCashColSet(records);	//전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
	           		}else{
	           			detailStore.removeAll('clear');           		
	           		}
	           	}
			}
	});
	
	var detailStore = Unilite.createStore('str412ukrvDetailStore',{
			model: 'str412ukrvDetailModel',
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'str412ukrvService.selectDetail'                	
                }
            }
			,loadStoreRecords : function(record){
				var gridParam = record.data; 
				var formParam = {};
				formParam.UNIT_TYPE = masterForm.getField('UNIT_TYPE').getValue() ? '1' : '2';
				formParam.PRINT_TYPE = masterForm.getField('PRINT_TYPE').getValue() ? '1' : '2';
				var params = Ext.merge(gridParam, formParam);
				this.load({
					//params : record.data
					params : params
				});				
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
						          		
	           	}
			}
	});	
	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
 	
	var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120'
			},{
	        	fieldLabel: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'INOUT_DATE_FR',
	        	endFieldName: 'INOUT_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today')
			},
				Unilite.popup('AGENT_CUST',{ 
					fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>', 
					validateBlank: false
				}),
			{
				fieldLabel: '상태',
				name:'BILLSTAT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S050'
			},{
				fieldLabel: '전자문서구분',
				name:'BILL_MEM_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B086',
				hidden: billTypeIsHidden
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '전송여부',
				items: [{
					boxLabel: '미전송', 
					width:80, 
					name: 'BILL_SEND_YN', 
					inputValue: 'N', 
					checked: true
				},{
					boxLabel: '전송', 
					width:80, 
					name: 'BILL_SEND_YN', 
					inputValue: 'Y'
				}]
			},{					
    			fieldLabel: '에러내용',
    			name:'TXT_ERR_MSG',
    			xtype: 'textareafield',
    			width: 315,
    			height: 35,
    			readOnly: true
    		},{
    			xtype: 'container',
    			html: '<hr></hr>'
    		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '수량단위구분',
				items: [{
					boxLabel: '<t:message code="system.label.sales.salesunit" default="판매단위"/>', 
					width:80, 
					name: 'UNIT_TYPE', 
					inputValue: '1',
					checked: !isOptQ
				},{
					boxLabel: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>', 
					width:80, 
					name: 'UNIT_TYPE', 
					inputValue: '2',
					checked: isOptQ
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '단가금액출력',
				items: [{
					boxLabel: '예', 
					width:80, 
					name: 'PRINT_TYPE', 
					inputValue: '1', 
					checked: true
				},{
					boxLabel: '아니오', 
					width:80, 
					name: 'PRINT_TYPE', 
					inputValue: '2'
				}]
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
    });		// End of var masterForm = Unilite.createSearchForm('searchForm',{    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var sendBillGrid= Unilite.createGrid('str412ukrvSendBillGrid', {
        layout:'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true,
			onLoadSelectFirst : false
        },
    	store: sendBillStore,
    	features: [{
    		id: 'gridTotal', 
    		ftype: 'uniSummary',
    		showSummaryRow: false 
    	}],    	
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false, 
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			if(record.get('TRANSYN_NAME') == '<span style="color:' + 'red' + ';">' + 'Error' + '</span>'){//Error컬럼은 선택 못하게
						return false;        			        				
        			}
        		},
				select: function(grid, record, index, eOpts ){					
					
	          	},
				deselect:  function(grid, record, index, eOpts ){					
        		}
        	}
        }),
        columns:  [
        	{dataIndex:'TRANSYN_NAME'							    , width:60,locked:true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '총합계', '총합계');
            }
            },
        	{dataIndex:'STS'									    , width:60,locked:true},
        	{dataIndex:'DT'			   							    , width:86,locked:true},
        	{dataIndex:'CUSTOM_CODE'							    , width:86,locked:true,
				summaryRenderer: function(value, summaryData, dataIndex ) {
              		var	rv =  "<div align='center'>건수 : " + sendBillStore.getCount() + " 건</div>";		                	
            		return rv;										
	            }
	        },
        	{dataIndex:'RCOMPANY'								    , width:160,locked:true},
        	{dataIndex:'RVENDERNO'								    , width:100},
        	{dataIndex:'SUPMONEY'								    , width:113, summaryType: 'sum'},
        	{dataIndex:'TAXMONEY'								    , width:86, summaryType: 'sum'},
        	{dataIndex:'TOT_AMT_I'								    , width:113, summaryType: 'sum'},
        	{dataIndex:'SEND_DATE'								    , width:146},
        	{dataIndex:'BILLSEQ'								    , width:133},
        	{dataIndex:'EB_NUM'									    , width:86},
        	{dataIndex:'CREATE_DT'								    , width:33, hidden:true},
        	{dataIndex:'TRANSYN'								    , width:100, hidden:true},
        	{dataIndex:'TAXRATE'								    , width:33, hidden:true},
        	{dataIndex:'BILLTYPE'								    , width:33, hidden:true},
        	{dataIndex:'CASH'									    , width:33, hidden:true},
        	{dataIndex:'CHECKS'									    , width:33, hidden:true},
        	{dataIndex:'NOTE'									    , width:33, hidden:true},
        	{dataIndex:'CREDIT'									    , width:33, hidden:true},
        	{dataIndex:'GUBUN'									    , width:33, hidden:true},
        	{dataIndex:'BIGO'									    , width:33, hidden:true},
        	{dataIndex:'SVENDERNO'								    , width:33, hidden:true},
        	{dataIndex:'SCOMPANY'								    , width:33, hidden:true},
        	{dataIndex:'SCEONAME'								    , width:33, hidden:true},
        	{dataIndex:'SUPTAE'									    , width:33, hidden:true},
        	{dataIndex:'SUPJONG'								    , width:33, hidden:true},
        	{dataIndex:'SADDRESS'								    , width:33, hidden:true},
        	{dataIndex:'SADDRESS2'								    , width:33, hidden:true},
        	{dataIndex:'SUSER'									    , width:33, hidden:true},
        	{dataIndex:'SDIVISION'								    , width:33, hidden:true},
        	{dataIndex:'STELNO'									    , width:33, hidden:true},
        	{dataIndex:'SEMAIL'									    , width:33, hidden:true},
        	{dataIndex:'RCEONAME'								    , width:33, hidden:true},
        	{dataIndex:'RUPTAE'									    , width:33, hidden:true},
        	{dataIndex:'RUPJONG'								    , width:33, hidden:true},
        	{dataIndex:'RADDRESS'								    , width:33, hidden:true},
        	{dataIndex:'RADDRESS2'								    , width:33, hidden:true},
        	{dataIndex:'RUSER'									    , width:100},
        	{dataIndex:'RDIVISION'								    , width:100},        	
        	{dataIndex:'RTELNO'									    , width:100},
        	{dataIndex:'REMAIL'									    , width:100},
        	{dataIndex:'REVERSEYN'								    , width:33, hidden:true},
        	{dataIndex:'SENDID'									    , width:33, hidden:true},
        	{dataIndex:'RECVID'									    , width:33, hidden:true},
        	{dataIndex:'DIV_CODE'								    , width:33, hidden:true},
        	{dataIndex:'DEL_YN'									    , width:33, hidden:true},
        	{dataIndex:'COMP_CODE'								    , width:33, hidden:true},
        	{dataIndex:'BILL_MEM_TYPE'							    , width:33, hidden:true},
        	{dataIndex:'ERR_GUBUN'     							    , width:33, hidden:true}

        ],
        tbar: [{	////전송버튼들 로직 만들어야함.
	    	itemId : 'submitBtn', iconCls : 'icon-referance'	,
			text:'전송',
			handler: function() {
				
			}
       	}, {
       		itemId : 'reSubmitBtn', iconCls : 'icon-referance'	,
			text:'재전송',
			handler: function() {
				
			}
       	}, {
       		itemId : 'cancelSubmitBtn', iconCls : 'icon-referance'	,
			text:'전송취소',
			handler: function() {
				
			}
       	}],        
		listeners: {
//			beforecellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				return view.getSelectionModel().isSelected();
//			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(record.get('TRANSYN_NAME') == '<span style="color:' + 'red' + ';">' + 'Error' + '</span>'){
					UniAppManager.app.fnSetErrMsg(record);	// 에러폼에 에러메시지 삽입	
				}else{
					masterForm.setValue('TXT_ERR_MSG', '')
				}
				if(rowIndex != beforeRowIndex){
					detailStore.loadStoreRecords(record);	//바로 디테일 데이터 조회
				}
				beforeRowIndex = rowIndex;
//				var selModel = view.getSelectionModel();
//				if(selModel.isSelected()){
//          			detailStore.loadStoreRecords(record);
//				}
				
   		  	////ROW더블클릭시 개별세금계산서 등록으로 데이터 전송및 조회되게 하는 부분 해야함.
   		  	////row클릭시 선택된 row색깔 표시 되야함.
			}
       }              
    });		// End of v'DIV_CODE'     ilite.createGrid('str412ukrvGrid1', {

    var webCashGrid= Unilite.createGrid('str412ukrvWebCashGrid', {
	    layout:'fit',
	    region:'center',
	    uniOpt: {
			expandLastColumn: true,
			onLoadSelectFirst: false,
			useRowNumberer: false
	    },
		store: webCashStore,
		features: [{
			id: 'gridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],    	
	    selModel: Ext.create('Ext.selection.CheckboxModel', {
	    	checkOnly: true,
	    	toggleOnClick: false,
	    	listeners: {        		
	    		beforeselect: function(rowSelection, record, index, eOpts) {
	    			
	    		},
				select: function(grid, record, index, eOpts ){					
					
	          	},
				deselect:  function(grid, record, index, eOpts ){					
	    		}
	    	}
	    }),
	    columns:  [                                                            
	    	{dataIndex:'TRANSYN_NAME'						,			 width:66, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '총합계', '총합계');
            }/*,					            
                renderer : function(val) {
                    if (val == 'Error') {
                        return '<span style="color:' + 'red' + ';">' +  '<b>' + val + '<b>' +'</span>';
                    }else{
                    	return '<span style="color:' + 'red' + ';">' +  '<b>' + val + '<b>' +'</span>';
                    } 
                    return val;
                }*/
			},
	    	{dataIndex:'STAT_CODE'							,			 width:60, hidden: true},
	    	{dataIndex:'STS'			    				,			 width:100, locked: true},
	    	{dataIndex:'REGS_DATE'							,			 width:80, locked: true},
	    	{dataIndex:'SELR_CORP_NO'						,			 width:100, hidden: true},
	    	{dataIndex:'SELR_CORP_NM'						,			 width:100, hidden: true},
	    	{dataIndex:'SELR_CEO'							,			 width:100, hidden: true},
	    	{dataIndex:'SELR_CORP_ADDS'						,			 width:100, hidden: true},
	    	{dataIndex:'SELR_BUSS_CONS'						,			 width:100, hidden: true},
	    	{dataIndex:'SELR_BUSS_TYPE'						,			 width:100, hidden: true},
	    	{dataIndex:'SELR_TEL'							,			 width:100, hidden: true},
	    	{dataIndex:'BUYR_CORP_NO'						,			 width:100, locked: true},
	    	{dataIndex:'CUSTOM_CODE'						,			 width:86, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + webCashStore.getCount() +  '건', metaData, '건수 : ' + webCashStore.getCount() +  '건');
            }
	        },
	    	{dataIndex:'BUYR_CORP_NM'						,			 width:160, locked: true},
	    	{dataIndex:'BUYR_CEO'							,			 width:100, hidden: true},
	    	{dataIndex:'BUYR_CORP_ADDS'						,			 width:100, hidden: true},
	    	{dataIndex:'BUYR_TEL'							,			 width:100, hidden: true},
	    	{dataIndex:'CHRG_AMT'							,			 width:133, summaryType: 'sum'},
	    	{dataIndex:'TAX_AMT'							,			 width:100, summaryType: 'sum'},
	    	{dataIndex:'TOTL_AMT'							,			 width:133, summaryType: 'sum'},
	    	{dataIndex:'SUM_AMT'							,			 width:133, hidden: true},
	    	{dataIndex:'BUYR_CHRG_NM1'						,			 width:100},
	    	{dataIndex:'BUYR_CHRG_MOBL1'					,			 width:100},
	    	{dataIndex:'BUYR_CHRG_EMAIL1'					,			 width:186},
	    	{dataIndex:'SND_MAL_YN'							,			 width:100, hidden: true},
	    	{dataIndex:'SND_SMS_YN'							,			 width:100, hidden: true},
	    	{dataIndex:'SND_FAX_YN'							,			 width:100, hidden: true},
	    	{dataIndex:'BILLSEQ'							,			 width:120},
	    	{dataIndex:'ERP_SEQ'							,			 width:133},
	    	{dataIndex:'DIV_CODE'							,			 width:100, hidden: true},
	    	{dataIndex:'DEL_YN'			    				,			 width:100, hidden: true},
	    	{dataIndex:'COMP_CODE'							,			 width:100, hidden: true},
	    	{dataIndex:'ERR_GUBUN'							,			 width:100, hidden: true},
	    	{dataIndex:'SEND_DATE'							,			 width:133}	    	
	    ],
	    tbar: [{	////전송버튼들 로직 만들어야함.
	    	itemId : 'submitBtn', iconCls : 'icon-referance'	,
			text:'전송',
			handler: function() {
				
			}
	   	}, {
	   		itemId : 'reSubmitBtn', iconCls : 'icon-referance'	,
			text:'재전송',
			handler: function() {
				
			}
	   	}, {
	   		itemId : 'cancelSubmitBtn', iconCls : 'icon-referance'	,
			text:'전송취소',
			handler: function() {
				
			}
	   	}],	    
		listeners: {
	//			beforecellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
	//				return view.getSelectionModel().isSelected();
	//			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				
				if(record.get('TRANSYN_NAME') == '<span style="color:' + 'red' + ';">' + 'Error' + '</span>'){
					UniAppManager.app.fnSetErrMsg(record);	// 에러폼에 에러메시지 삽입	
				}else{
					masterForm.setValue('TXT_ERR_MSG', '')
				}
				
				if(rowIndex != beforeRowIndex){
					detailStore.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
	//				var selModel = view.getSelectionModel();
	//				if(selModel.isSelected()){
	//          			detailStore.loadStoreRecords(record);
	//				}
				
		  	////ROW더블클릭시 개별세금계산서 등록으로 데이터 전송및 조회되게 하는 부분 해야함.
		  	////row클릭시 선택된 row색깔 표시 되야함.
			}
	   }             
    });    
    //활성화할 그리드 activeGrid에 담기
    BsaCodeInfo.gsBillYN[0].SUB_CODE == "01" ? activeGrid = sendBillGrid : activeGrid = webCashGrid;
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
	var detailGrid= Unilite.createGrid('str412ukrvDetailGrid', {
		layout:'fit',
        region:'south',
        uniOpt: {
			expandLastColumn: true
        },
    	store: detailStore,
    	features: [{
    		id: 'detailGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex:'DT'			     , width:100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '총합계', '총합계');
            }
            },
        	{dataIndex:'CODE'		     , width:233,hidden:true},
        	{dataIndex:'NAME'		     , width:233,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + detailStore.getCount() +  '건', metaData, '건수 : ' + detailStore.getCount() +  '건');
            }
	        },
        	{dataIndex:'UNIT'		     , width:133},
        	{dataIndex:'VLM'		     , width:120, summaryType: 'sum'},
        	{dataIndex:'DANGA'		     , width:120},
        	{dataIndex:'SUP'		     , width:133, summaryType: 'sum'},
        	{dataIndex:'TAX'		     , width:120, summaryType: 'sum'},
        	{dataIndex:'COMP_CODE'	     , width:66,hidden:true},
        	{dataIndex:'DIV_CODE'	     , width:66,hidden:true},
        	{dataIndex:'INOUT_NUM'	     , width:66,hidden:true},
        	{dataIndex:'INOUT_SEQ'	     , width:66,hidden:true},
        	{dataIndex:'ITEM_CODE'	     , width:66,hidden:true},
        	{dataIndex:'CUSTOM_CODE'     , width:66,hidden:true},
        	{dataIndex:'SALE_UNIT'	     , width:66,hidden:true},
        	{dataIndex:'TRANS_RATE'	     , width:66,hidden:true}
    	] 
	});		// End of var masterGrid2= Unilite.createGrid('str412ukrvGrid2', {
    
    Unilite.Main({ 

borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				activeGrid, detailGrid
			]	
		}		
		,masterForm
		],
		id: 'str412ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{
			activeGrid.getStore().loadStoreRecords();
			beforeRowIndex = -1;
			var viewLocked = activeGrid.lockedGrid.getView();
			var viewNormal = activeGrid.normalGrid.getView();	
			
			viewLocked.getFeature('gridTotal').toggleSummaryRow(true);			
			viewNormal.getFeature('gridTotal').toggleSummaryRow(true);
		},
		fnSetErrMsg: function(record) {	// 에러폼에 에러메시지 삽입		
			if(record.get('ERR_GUBUN') == '1'){
				masterForm.setValue('TXT_ERR_MSG', Msg.fStMsgS0092);
			}
			if(record.get('ERR_GUBUN') == '2'){
				masterForm.setValue('TXT_ERR_MSG', Msg.fStMsgS0093);
			}
			if(record.get('ERR_GUBUN') == '3'){
				masterForm.setValue('TXT_ERR_MSG', Msg.fStMsgS0094);
			}
			if(record.get('ERR_GUBUN') == '4'){
				masterForm.setValue('TXT_ERR_MSG', Msg.fStMsgS0095);
			}			
			
		},
		fnSendBillColSet: function(records) {	//센드빌 전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
			Ext.each(records, function(record) {
				//공급자 업체명, 대표자명, 업태, 업종, 주소
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
			});
		},
		fnWebCashColSet: function(records) {	//웹캐시 전송 컬럼에 Error 및 에러구분컬럼에 에러코드주기
			Ext.each(records, function(record) {
				//공급자 업체명, 대표자명, 업태, 업종, 주소
				if(Ext.isEmpty(record.get('SELR_CORP_NM')) || Ext.isEmpty(record.get('SELR_CEO')) || Ext.isEmpty(record.get('SELR_CORP_ADDS'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '1');
				}
				//공급 받는자 업체명, 대표자명, 주소
				else if(Ext.isEmpty(record.get('BUYR_CORP_NM')) || Ext.isEmpty(record.get('BUYR_CEO')) || Ext.isEmpty(record.get('BUYR_CORP_ADDS'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '3');
				}
				//공급 받는자 담당자명, 전화번호, 이메일주소
				else if(Ext.isEmpty(record.get('BUYR_CHRG_NM1')) || Ext.isEmpty(record.get('BUYR_CHRG_MOBL1')) || Ext.isEmpty(record.get('BUYR_CHRG_EMAIL1'))){
					record.set('TRANSYN_NAME', '<span style="color:' + 'red' + ';">' + 'Error' + '</span>');
					record.set('ERR_GUBUN', '4');
				}				
			});
		}	
	});		// End of Unilite.Main({
};
</script>
