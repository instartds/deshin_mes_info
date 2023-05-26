<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj400ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="agj400ukr" /> 	<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A172"  /> 		<!-- 결제방법 -->
	<t:ExtComboStore comboType="AU" comboCode="A177"  /> 		<!-- 지출유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A006" />			<!-- 제조판관구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"  /> 		<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="A173"  /> 		<!-- 증빙구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A070"  /> 		<!-- 불공제사유 -->
	<t:ExtComboStore comboType="AU" comboCode="A149"  /> 		<!-- 전자발행여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A109"  /> 		<!-- 공제구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A178"  /> 		<!-- 구분 -->
	<t:ExtComboStore comboType="CBM600" comboCode="0"  /> 		<!-- (급여공제) Cost Pool(사업명)-->
	<t:ExtComboStore comboType="AU" comboCode="B004"  /> 		<!-- 화폐 -->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript" >
	var gsLinkedGW = "N"     //   그룹웨어연결 여부
	var referCorporationCardWindow;	//법인카드승인참조
	var referDraftNoWindow;	//예산기안참조
	var referPayDtlNoWindow;	//지급명세서참조
	var popDedAmtWindow;	//급여공제
	var gsCrdtCompCd =  "",	gsCrdtCompNm =  "", gsCrdtSetDate="";
	var gsMakeSale = '';
	var saveSuccessCheck = '';
	var docWin ;	//증빙서류등록 팝업
	
var	gsAmtPoint ='${gsAmtPoint}';
var gsCrdtRef  = '${gsCrdtRef}';
var gsPendCodeYN = '${gsPendCodeYN}';
var gsChargeCode  = '${gsChargeCode}';
var gsChargeDivi  = '${gsChargeDivi}';
var gsLocalMoney  = '${gsLocalMoney}';

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'agj400ukrService.selectDetail',
			update: 'agj400ukrService.updateDetail',
			create: 'agj400ukrService.insertDetail',
			destroy: 'agj400ukrService.deleteDetail',
			syncAll: 'agj400ukrService.saveAll'
		}
	});	
	
	var validateStore = Ext.data.StoreManager.lookup("CBS_AU_A172")
	
	Unilite.defineModel('agj400ukrModel', {
		fields: [  	  
	   	 	{name: 'PAY_DRAFT_NO'     	, text: 'PAY_DRAFT_NO' 			,type: 'string', isPk:true, pkGen:'user'},
	   	 	{name: 'SEQ'     			, text: '순번' 					,type: 'uniNumber',allowBlank:false},
	   	 	{name: 'USE_DATE'     		, text: '사용일' 				,type: 'uniDate',allowBlank:false},
	   	    {name: 'GUBUN'     		    , text: '구분' 			    	,type: 'string',comboType:'AU', comboCode:'A178',allowBlank:false},
	   	    {name: 'GUBUN_REF1'     	, text: 'GUBUN_REF1' 			,type: 'string'},  // A178 REF_CODE1
	   	 	{name: 'PAY_DIVI'     		, text: '결제방법' 				,type: 'string',comboType:'AU', comboCode:'A172'},
	   	 	{name: 'PAY_DIVI_REF1'     	, text: '지급처유형' 				,type: 'string'}, // A172 REF_CODE1 : 지급처유형(거래처:A4,사원:A6)
	   	 	{name: 'PAY_DIVI_REF2'     	, text: '필수체크<br/>(카드:C, 예금:B)' 	,type: 'string'}, // A172 REF_CODE2 : 필수체크(카드:C, 예금:B)
	   	 	{name: 'PAY_DIVI_REF3'     	, text: 'Default 입력계정' 		,type: 'string'}, // A172 REF_CODE3 : Default 입력계정
	   	 	{name: 'PAY_DIVI_REF4'     	, text: '계정명' 					,type: 'string'}, // A172 REF_CODE4 : 계정명
	   	    {name: 'PAY_TYPE'			, text: '지출유형'					,type: 'string' , comboType: 'AU', comboCode: 'A177', allowBlank : false},
	   	    {name: 'PAY_TYPE_REF4'		, text: '지출유형 <br/>부가세여부'	,type: 'string' },    // A177 REF_CODE4 : 부가세여부(Y)
	   	    {name: 'PAY_TYPE_REF6'		, text: '지출유형 <br/>REF6'		,type: 'string' },     // A177 REF_CODE6 : 
	   	    {name: 'MAKE_SALE'     		, text: '제조판관' 				,type: 'string',comboType:'AU', comboCode:'A006',allowBlank:false},
	   	    {name: 'ACCNT'     			, text: '계정코드' 				,type: 'string',allowBlank:false},
	   	 	{name: 'ACCNT_NAME'     	, text: '계정명' 					,type: 'string'},
	   	 	{name: 'REMARK'     		, text: '적요' 					,type: 'string',allowBlank:false},
	   	    {name: 'PROOF_DIVI'     	, text: '증빙구분' 				,type: 'string',comboType:'AU', comboCode:'A173'},
	   	 	{name: 'PROOF_KIND'			, text: '증빙구분REF1' 			,type: 'string'},
	   	 	{name: 'REASON_ESS'     	, text: '증빙구분REF2' 			,type: 'string'},
	   	 	{name: 'PROOF_TYPE'     	, text: '증빙구분REF3' 			,type: 'string'},
	   	 	{name: 'CUSTOM_ESS'     	, text: '증빙구분REF5' 			,type: 'string'},
	   	 	{name: 'DEFAULT_EB'     	, text: '증빙구분REF6' 			,type: 'string'},
	   	 	{name: 'DEFAULT_REASON'     , text: '증빙구분REF7' 			,type: 'string'},
	   	 	{name: 'QTY'     			, text: '수량' 					,type: 'uniQty', defaultValue:0},
	   		{name: 'PRICE'     			, text: '단가' 					,type: 'uniUnitPrice', defaultValue:0},
	   	
	   	 	{name: 'SUPPLY_AMT_I'     	, text: '공급가액' 				,type: 'uniPrice',allowBlank:false,maxLength:32, defaultValue:0,allowBlank:false},
	   	 	{name: 'TAX_AMT_I'     		, text: '세액' 					,type: 'uniPrice',maxLength:32, defaultValue:0},
	   	 	{name: 'ADD_REDUCE_AMT_I'   , text: '증가/차감액' 				,type: 'uniPrice',maxLength:32, defaultValue:0},
	   	 	{name: 'TOT_AMT_I'     		, text: '지급액' 					,type: 'uniPrice',maxLength:32, defaultValue:0 , allowBlank:false},
	   	 	{name: 'COMPANY_NUM'     	, text: '사업자번호' 				,type: 'string' , editable:false},
	   	 	{name: 'CUSTOM_CODE'     	, text: '거래처코드' 				,type: 'string',allowBlank:false},
	   	 	{name: 'CUSTOM_NAME'     	, text: '거래처명' 				,type: 'string',allowBlank:false},
	   	 	{name: 'BOOK_CODE'     		, text: '거래처<br/>계좌코드' 				,type: 'string'},
	   	 	{name: 'BOOK_NAME'     		, text: '거래처<br/>계좌명' 					,type: 'string'},
	   	    {name: 'CUST_BOOK_ACCOUNT'  , text: '거래처<br/>계좌번호' 				,type: 'string'},
	   	    
	   	 	{name: 'BANK_NAME'     		, text: '거래처<br/>은행명' 				,type: 'string', editable:false },
	   	 	{name: 'BANKBOOK_NAME'     	, text: '거래처<br/>예금주' 				,type: 'string', editable:false},	   	 
	   	    {name: 'BE_CUSTOM_CODE'     , text: '귀속 거래처코드' 			,type: 'string'},
	   	 	{name: 'BE_CUSTOM_NAME'     , text: '귀속거래처명' 				,type: 'string'},
	   	    {name: 'COST_POOL_YN'     	, text: 'COST_POOL_YN' 			,type: 'string'},
	   	 	{name: 'COST_POOL_CODE'     , text: 'Cost Pool' 			,type: 'string'},
	   	    {name: 'EB_YN'     			, text: '전자세금<br/>계산서발행'		,type: 'string',comboType:'AU', comboCode:'A149'},
	   	 	{name: 'CRDT_NUM'     		, text: '법인카드' 				,type: 'string',maxLength:20},
	   	 	{name: 'CRDT_FULL_NUM'     	, text: '법인카드번호' 				,type: 'string',maxLength:255},
	   	    {name: 'CRDT_FULL_NUM_EXPOS', text: '법인카드번호' 				,type: 'string',maxLength:255, defaultValue:'***************'},
	   	 	{name: 'APP_NUM'     		, text: '현금영수증' 				,type: 'string',maxLength:20},
	   	 	{name: 'PJT_CODE'     		, text: '프로젝트코드' 				,type: 'string'},
	   	 	{name: 'PJT_NAME'     		, text: '프로젝트명' 				,type: 'string'},
	   	 	{name: 'SAVE_CODE'     		, text: '통장코드' 				,type: 'string'},
	   	 	{name: 'SAVE_NAME'     		, text: '통장명' 					,type: 'string'},
	   	    {name: 'BANK_ACCOUNT'     	, text: '계좌번호' 				,type: 'string'},
	   	    
	   	 	{name: 'PEND_CODE'     		, text: '지급처구분' 				,type: 'string',comboType:'AU', comboCode:'A210'},
	   	 	
	   	 	{name: 'PAY_CUSTOM_CODE'    , text: '지급처코드' 				,type: 'string'},
	   	 	{name: 'PAY_CUSTOM_NAME'    , text: '지급처명' 				,type: 'string'},
	   	 	{name: 'REASON_CODE'     	, text: '불공제사유' 				,type: 'string',comboType:'AU', comboCode:'A070'},
	   	 	{name: 'SEND_DATE_YN'     	, text: 'SEND_DATE_YN' 			,type: 'string'},
	   	 	{name: 'SEND_DATE'     		, text: '지급예정일' 				,type: 'uniDate'},
	   	 	{name: 'BILL_DATE'     		, text: '계산서일/</br>카드승인일'	,type: 'uniDate'},
	   	 	{name: 'DEPT_CODE'     		, text: '귀속부서' 				,type: 'string',allowBlank:false},
	   	 	{name: 'DEPT_NAME'     		, text: '부서명' 					,type: 'string',allowBlank:false},
	   	 	{name: 'DIV_CODE'     		, text: '귀속사업장' 				,type: 'string',allowBlank:false, comboType : 'BOR120'},
	   	 	{name: 'ITEM_CODE'     		, text: '품목코드' 				,type: 'string'},
	   	 	{name: 'ITEM_NAME'     		, text: '품목명' 					,type: 'string'},
	   	    {name: 'SPEC'     			, text: '규격' 					,type: 'string'},
	   	 	{name: 'BILL_USER'     		, text: '사용자' 					,type: 'string'},
	   	    {name: 'BILL_USER_NAME'     , text: '사용자명' 				,type: 'string'},
	   	 	{name: 'REFER_NUM'     		, text: 'REFER_NUM' 			,type: 'string'},
	   	 	{name: 'CANCEL_YN'     		, text: 'CANCEL_YN' 			,type: 'string'},
	   	 	{name: 'MONEY_UNIT'			, text:'화폐단위'			,type : 'string', defaultValue:gsLocalMoney, comboType:'AU',comboCode:'B004'},
			{name: 'EXCHG_RATE_O'		, text:'환율'				,type : 'uniER'},
			{name: 'FOR_AMT_I'			, text:'외화금액'			,type : 'uniFC'}
		]
	});	
	
	var directDetailStore = Unilite.createStore('agj400ukrDirectDetailStore',{
		model: 'agj400ukrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable: true,			// 삭제 가능 여부
	        useNavi : false,				// prev | newxt 버튼 사용
	        deleteAll:true
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('detailForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
//			checkMasterOnly = '';
			var totAmtI = Unilite.nvl(this.sum('TOT_AMT_I'), 0);
       		detailForm.setValue('TOT_AMT_I', totAmtI);
       		
			var paramMaster= detailForm.getValues();

			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
        	
        	var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		
       		if(!directDetailStore.isDirty())	{
				if(detailForm.isDirty())	{
       				
		       		detailForm.getForm().submit({
					params : paramMaster,
						success : function(form, action) {
			 				detailForm.getForm().wasDirty = false;
							detailForm.resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
			            	UniAppManager.updateStatus("저장되었습니다");// 저장되었습니다
			            	UniAppManager.app.onQueryButtonDown();
							/* if(saveSuccessCheck == 'CS'){
				     			UniAppManager.app.fnCancSlip(); //자동기표취소
				     		}else if(saveSuccessCheck == 'AS'){
				     			UniAppManager.app.fnAutoSlip(); //자동기표
				     		}else if(saveSuccessCheck == 'RA'){
				     			UniAppManager.app.fnReAuto(); //재기표
				     		} */
				     		saveSuccessCheck = "";
						
						}	
					});
			
				}
			}else{
				
				var data = Ext.Array.merge(toCreate, toUpdate);
				var inVaild = false;
				var message = "";
				Ext.each(data, function(record){
					if(record.get("GUBUN_REF1") == "Y")	{
						if(Ext.isEmpty(record.get("PAY_DIVI")))	{
							inVaild = true;
							message = message + "결제방법은 필수 입력입니다."+"\n";
						}
						if(Ext.isEmpty(record.get("EB_YN")))	{
							inVaild = true;
							message = message + "전자발행여부은 필수 입력입니다."+"\n";
						}
					}
					
					if(gsChargeDivi == "2")	{
						if(Ext.isEmpty(record.get("PAY_TYPE")))	{
							inVaild = true;
							message = message + "지출유형은 필수 입력입니다."+"\n";
						}
					}
					
					if( record.get("PAY_DIVI_REF2") == "C" || record.get("PAY_DIVI_REF2") == "BC" || record.get("PAY_DIVI_REF2") == "CC")	{
						 if(Ext.isEmpty(record.get("CRDT_NUM")))	{
								inVaild = true;
								message = message + "법인카드 필수 입력입니다."+"\n";
						}
					 } 
					if(record.get("REASON_ESS") == "Y")	{
						if(Ext.isEmpty(record.get("REASON_CODE")))	{
							inVaild = true;
							message = message + "불공제사유는 필수 입력입니다."+"\n";
						}
					} 
					
					if(record.get("COST_POOL_YN") == "Y")	{
						if(Ext.isEmpty(record.get("COST_POOL_CODE")))	{
							inVaild = true;
							message = message + "Cost Pool은 필수 입력입니다."+"\n";
						}
					}
					if(record.get("SEND_DATE_YN") == "Y")	{
						if(Ext.isEmpty(record.get("SEND_DATE")))	{
							inVaild = true;
							message = message + "지급예정일은 필수 입력입니다."+"\n";
						}
					} 
				})
				
				var saveRecords = Ext.Array.merge(toCreate, toUpdate);
				
				if(saveRecords)		{
					Ext.each(saveRecords, function(record, idx){
						var validateIdx = validateStore.find('value', record.get("PAY_DIVI")); 
						var validateRecord = validateStore.getAt(validateIdx);
						var rowIdx = idx+1
						if(validateRecord.get("refCode5") == "1" && (Ext.isEmpty(record.get("TAX_AMT_I")) || record.get("TAX_AMT_I") == 0))	{
							inVaild = true;
							message = message + rowIdx +"행의 세액은 필수 입력입니다."+"\n";
						}
						if(validateRecord.get("refCode6") == "1" && Ext.isEmpty(record.get("PROOF_DIVI")))	{
							inVaild = true;
							message = message + rowIdx +"행의 증빙구분은 필수 입력입니다."+"\n";
						}
						if(validateRecord.get("refCode7") == "1" && Ext.isEmpty(record.get("EB_YN")))	{
							inVaild = true;
							message = message + rowIdx +"행의 전자세금 계산서발행은 필수 입력입니다."+"\n";
						}
						if(validateRecord.get("refCode8") == "1" && (Ext.isEmpty(record.get("CRDT_NUM")) || Ext.isEmpty(record.get("CRDT_FULL_NUM"))))	{
							inVaild = true;
							message = message + rowIdx +"행의 법인카드는 필수 입력입니다."+"\n";
						}
						if(validateRecord.get("refCode9") == "1" && Ext.isEmpty(record.get("APP_NUM")))	{
							inVaild = true;
							message = message + rowIdx +"행의 현금영수증은 필수 입력입니다."+"\n";
						}
						if(validateRecord.get("refCode10") == "1" && Ext.isEmpty(record.get("PJT_CODE")))	{
							inVaild = true;
							message = message + rowIdx +"행의 프로젝트코드은 필수 입력입니다."+"\n";
						}
						if(validateRecord.get("refCode11") == "1" && Ext.isEmpty(record.get("REASON_CODE")))	{
							inVaild = true;
							message = message + rowIdx +"행의 불공제사유는 필수 입력입니다."+"\n";
						}
						if(validateRecord.get("refCode12") == "1" && Ext.isEmpty(record.get("SEND_DATE")))	{
							inVaild = true;
							message = message + rowIdx +"행의 지급예정일은 필수 입력입니다."+"\n";
						}
						if(validateRecord.get("refCode13") == "1" && Ext.isEmpty(record.get("BILL_DATE")))	{
							inVaild = true;
							message = message + rowIdx +"행의 계산서일/카드승인일은 필수 입력입니다."+"\n";
						}
						
					})
				}
				
				if(inVaild)	{
					Unilite.messageBox("필수입력 사항입니다.",message);
					return;
				}
				
				if(inValidRecs.length == 0 )	{
					
					config = {
						params: [paramMaster],
						success: function(batch, option) {
							
							var master = batch.operations[0].getResultSet();
							detailForm.setValue("PAY_DRAFT_NO", master.PAY_DRAFT_NO);
	//						directMasterStore.loadStoreRecords();
							UniAppManager.app.onQueryButtonDown();
							/* if(saveSuccessCheck == 'CS'){
				     			UniAppManager.app.fnCancSlip(); //자동기표취소
				     		}else if(saveSuccessCheck == 'AS'){
				     			UniAppManager.app.fnAutoSlip(); //자동기표
				     		}else if(saveSuccessCheck == 'RA'){
				     			UniAppManager.app.fnReAuto(); //재기표
				     		} */
				     		saveSuccessCheck = "";
						}
					};
					
					this.syncAllDirect(config);
				
				}else {
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
       		}
		},
		listeners :{
			load : function(store, records)	{
				if(!Ext.isEmpty(records) && records.length > 0)	{
					gsMakeSale = records[0].MAKE_SALE;
					
				}
			}
		}
	});
	
	var detailForm = Unilite.createForm('detailForm',{
		split:true,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { border :0, width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
	
		},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		items: [{ 
			style:'margin-top : 5px;',
    		fieldLabel: '지출작성일',
		    xtype: 'uniDatefield',
		    width : 270,
		    name: 'PAY_DATE',
		    value: UniDate.get('today'),
		    allowBlank: false,tdAttrs: {width:1000/*align : 'center'*/},                	
            listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					if(!detailForm.inLoading) {
						detailForm.setValue('EX_DATE',newValue);
						UniAppManager.app.fnApplySlipDate(newValue);
					}
				}
			}
		},
		Unilite.popup('Employee', {			
			style:'margin-top : 5px;',
			fieldLabel: '지출작성자', 
			valueFieldName: 'DRAFTER_PN',
    		textFieldName: 'DRAFTER_NM', 
    		autoPopup:true,
    		tdAttrs: {width:'100%',align : 'left'}, 
			listeners: {
				onSelected: {
					fn: function(records, type) {
						if(!Ext.isEmpty(detailForm.getValue('DRAFTER_PN'))){
							detailForm.setValue('PAY_USER_PN', detailForm.getValue('DRAFTER_PN'));
							detailForm.setValue('PAY_USER_NM', detailForm.getValue('DRAFTER_NM'));
							detailForm.setValue('DEPT_CODE', records[0]["DEPT_CODE"]);
							detailForm.setValue('DEPT_NAME', records[0]["DEPT_NAME"]);
							detailForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
							gsMakeSale = records[0]["MAKE_SALE"];
							UniAppManager.app.fnApplyToDetail();
						}
						
                	},
					scope: this
				},
				onClear: function(type)	{

				}
			}
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left',width:120},
			items :[{
	    		xtype: 'button',
	    		text: '자동기표',	
	    		id: 'btnProc',
	    		name: 'PROC',
	    		width: 100,	
				handler : function() {
					if(detailForm.getValue('PAY_DRAFT_NO') == ''){
						Unilite.messageBox("저장 후 작업하세요.");
					}else{
						if(gsLinkedGW == 'Y'){
							//UniAppManager.app.fnApproval(); //결재상신
						}else{
//							if(detailForm.down('#btnProc').getText(Msg.fSbMsgA0049)){
							if(detailForm.getValue('EX_NUM') != '' && gsLinkedGW == 'N'){
								if(directDetailStore.getCount() == 0){
									Unilite.messageBox("자동기표 할 자료가 없습니다.");	
									return false;
								}
								
								UniAppManager.app.fnCancSlip(); //자동기표취소
							}else if (detailForm.getValue('EX_NUM') == '' && gsLinkedGW == 'N'){
								if(directDetailStore.getCount() == 0){
									Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0445);	
									return false;
								}
								
								UniAppManager.app.fnAutoSlip(); //자동기표
								
							}
						}
					}
				}
	    	}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			tdAttrs: {width:1000/*align : 'center'*/},
			defaults : {enforceMaxLength: true},
			colspan :2,
			width : 1000,
			items :[{ 
	    		fieldLabel: '사용일(전표일)',
			    xtype: 'uniDatefield',
			    name: 'EX_DATE',
			    width : 270,
			    value: UniDate.get('today'),
			    allowBlank: false,                	
	            listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						UniAppManager.app.fnApplySlipDate(newValue);
					}
				}
			},{
				fieldLabel:'',
				xtype:'uniTextfield',
				name:'EX_NUM',
				width:50,
				readOnly:true,
				tdAttrs: {align : 'left'},
				fieldStyle: 'text-align: center;'
			},{
				xtype : 'component',
				width : 500,
				html  : '<span style="color:#0000ff">사용일(전표일)은 반드시 수정하세요. 결의전표일자로 반영됩니다.</span>'
			}]
			
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
				xtype:'component',
				html:'자동기표조회',
	    		id: 'btnLinkSlip',
	    		name: 'LINKSLIP',
	    		width: 100,	
	    		tdAttrs: {align : 'center'},
	    		componentCls : 'component-text_first',
				listeners:{
					render: function(component) {
		                component.getEl().on('click', function( event, el ) {
		                	UniAppManager.app.fnOpenSlip();
		                });
		            }
				}
			}]
    	},{ 
    		fieldLabel: '지출결의번호',
		    xtype: 'uniTextfield',
		    name: 'PAY_DRAFT_NO',
		    width : 270,
		    readOnly:true,
		    tdAttrs: {width:1000/*align : 'center'*/}
		},
		Unilite.popup('Employee', {
			fieldLabel: '사용자', 
			valueFieldName: 'PAY_USER_PN',
    		textFieldName: 'PAY_USER_NM', 
    		autoPopup:true,
    		allowBlank:false,
    		tdAttrs: {width:'100%',align : 'left'},
			listeners: {
				onSelected: {
					fn: function(records, type) {
						if(!Ext.isEmpty(detailForm.getValue('PAY_USER_PN'))){
							detailForm.setValue('DEPT_CODE', records[0]["DEPT_CODE"]);
							detailForm.setValue('DEPT_NAME', records[0]["DEPT_NAME"]);
							detailForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
							
							UniAppManager.app.fnApplyToDetail();
						}
						
                	},
					scope: this
				},
				onClear: function(type)	{
					
				}
			}
			
		}),
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '복사',	
	    		id: 'btnCopy',
	    		name: 'COPY',
	    		width: 100,	
				handler : function() {
					
					var bReferNum = false;
					
					if(detailForm.getValue('PAY_DRAFT_NO') == ''){
						return false;
					}else{
						
						var records = directDetailStore.data.items;
						Ext.each(records, function(record,i){
							if(record.get('REFER_NUM') != '' ){
								bReferNum = true;
							}	
						});
						if(bReferNum == true){
							Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0439);	
						}
						
						
						detailGrid.reset();
						directDetailStore.clearData();
						var param = {"PAY_DRAFT_NO": detailForm.getValue('PAY_DRAFT_NO')
						};
						agj400ukrService.selectDetail(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								Ext.each(provider, function(record,i){
									UniAppManager.app.copyDataCreateRow();
					        		detailGrid.setNewDataCopy(record);
								});
							}
							
						});
						
//						UniAppManager.app.fnDispTotAmt();
						
							
						UniAppManager.app.fnDispMasterData("COPY");
						
						UniAppManager.app.fnMasterDisable(false);
						
//						Call goCnn.SetFrameButtonInfo("NW1:SV1")
//						If grdSheet1.Rows > csHeaderRowsCnt Then
//							Call goCnn.SetFrameButtonInfo("DL1:DA1")
//						End If


					}
				}
	    	}]
    	},{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
			width : 270,
	        comboType:'BOR120',
	        allowBlank:false,
	        tdAttrs: {width:1000/*align : 'center'*/},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {		
					UniAppManager.app.fnApplyToDetail();
				}
			}
		},Unilite.popup('DEPT',{
	        validateBlank:true,
	        autoPopup:true,
		    valueFieldName:'DEPT_CODE',
		    textFieldName:'DEPT_NAME',
		    allowBlank : false,
		    //colspan : 2,
        	listeners: {
        		onSelected:function(records, type )	{
        			if(!Ext.isEmpty(records) && records.length > 0)	{
	        			/* var param = { DEPT_CODE : records[0].TREE_CODE }
	        			agj400ukrService.selectMakeSale(param, function(responseText){
        					gsMakeSale = responseText.MAKE_SALE;
        				}); */
        			}
				},
				onClear:function(type)	{
									},
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': detailForm.getValue('DIV_CODE')});
				}
			}
	    }), {
			xtype : 'button',
			text  : '출력',
			width : 100,
			itemId : 'printBtn',
			disabled: true,
			tdAttrs : {width:120},
			handler : function() {
				var win;
				if(Ext.isEmpty(detailForm.getValue('PAY_DRAFT_NO'))  ) {
					Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
					return false;
				}
				var param = {
					  'PAY_DRAFT_NO' : detailForm.getValue('PAY_DRAFT_NO')
				};
				win = Ext.create('widget.ClipReport', {
					url		: CPATH + '/accnt/agj400clukrv.do',
					prgID	: 'agj400ukr',
					extParam: param
				});
				win.center();
				win.show();
			}
		}, { 
			fieldLabel: '지출건명(제목)',
		    xtype: 'uniTextfield',
		    name: 'TITLE',
		    width: 900,
		    colspan : 2,
		    allowBlank: false,
		    tdAttrs: {width:100/*align : 'center'*/}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'left'},
			items :[{
	    		xtype: 'button',
	    		text: '증빙등록',	
	    		width: 100,	
				handler : function() {
					 
							if(!docWin) {
								
								docWin = Ext.create('widget.uniDetailWindow', {
									title: '증빙등록',
									width: 1250,
									height:300,
									layout: {type:'vbox', align:'stretch'},
									items: [{
						     			xtype:'xuploadpanel',
						     			id : 'agj400ukrFileUploadPanel',
								    	itemId:'fileUploadPanel',
								    	height: 80,
								    	max_file_size : '1000mb',
								    	listeners : {
								    		change: function() {
								    			UniAppManager.setToolbarButtons('save', true);
								    		}
								    	}
							    	}],
									tbar:  [
										 '->',{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
												docWin.hide();
											},
											disabled: false
										}
									],
									listeners : {
										beforehide: function(me, eOpt) {
									
												
										},
										 beforeclose: function( panel, eOpts )  {
											
										},
										show: function( panel, eOpts ) {
											var fileNum = detailForm.getValue('FILE_NUM');
											if(!Ext.isEmpty(fileNum))	{
												bdc100ukrvService.getFileList({DOC_NO : fileNum},
													function(provider, response) {
														var fp = Ext.getCmp('agj400ukrFileUploadPanel');
														fp.loadData(response.result);
													}
											 	)
											}
										} 
									}
								});
							}
							docWin.center();
							docWin.show(); 
						 
				}
	    	}]
    	},{
    		style:'margin-bottom : 5px;',
	    	fieldLabel:'내용',
	    	xtype:'textarea',
	    	name:'TITLE_DESC',
	    	width:900,
		    colspan : 3
    	},{
	    	fieldLabel:'TOT_AMT_I',
	    	xtype:'uniNumberfield',
	    	name:'TOT_AMT_I',
	    	value : 0,
	    	hidden : true
    	},{
	    	fieldLabel:'파일번호',
	    	xtype:'uniTextfield',
	    	name:'FILE_NUM',
	    	hidden : true
    	},{
			xtype: 'uniTextfield',
    		fieldLabel: '업로드파일',
    		name: 'ADD_FID',
    		hidden : true
		},{
			xtype: 'uniTextfield',
    		fieldLabel: '삭제파일',
    		name: 'DEL_FID',
    		hidden : true
		}],
    	api: {
	    	load : 'agj400ukrService.selectMaster',
	 		submit: 'agj400ukrService.syncMaster'	
		}
	});
	
    
    var detailGrid = Unilite.createGrid('agj400ukrGrid', {
//    	id:'detailGridId',
//    	split:true,
    	features: [{
			id: 'detailGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'detailGridTotal',		
			ftype: 'uniSummary',		
			dock:'bottom',
			showSummaryRow: false
		}],
    	layout : 'fit',
        region : 'center',
		store: directDetailStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
    		dblClickToEdit		: true,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			state: {
				useState: true,			
				useStateList: true		
			}
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:[
        	{dataIndex: 'SEQ'    			, width: 60, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '합계');
			}},
			{dataIndex: 'USE_DATE'     		, width: 100	},
        	{dataIndex: 'GUBUN'     		, width: 100	, hidden:true},
        	{dataIndex: 'GUBUN_REF1'     	, width: 100	, hidden:true},
        	{dataIndex: 'PAY_DRAFT_NO'     	, width: 100	, hidden:true},
        	{dataIndex: 'PAY_DIVI'     		, width: 100},
        	{dataIndex: 'PAY_DIVI_REF1'     , width: 100	, hidden:true},	
        	{dataIndex: 'PAY_DIVI_REF2'     , width: 100	, hidden:true},
        	{dataIndex: 'PAY_DIVI_REF3'     , width: 100	, hidden:true},
        	{dataIndex: 'PAY_DIVI_REF4'     , width: 100	, hidden:true},
        	{dataIndex: 'MAKE_SALE'     	, width: 100	},
        	{dataIndex: 'PAY_TYPE'     		, width: 100},
        	{dataIndex: 'PAY_TYPE_REF4'     , width: 100	, hidden:true},
        	{dataIndex: 'PAY_TYPE_REF6'     , width: 100	, hidden:true},
        	{dataIndex: 'ACCNT'     		, width: 100,
        		editor:Unilite.popup('ACCNT_PAY_G', {
					autoPopup: true,
					textFieldName:'ACCNT',
					DBtextFieldName: 'ACCNT',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', records[0].ACCNT);
							grdRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
							grdRecord.set('COST_POOL_YN', records[0].COST_POOL_YN);
							grdRecord.set('SEND_DATE_YN', records[0].SEND_DATE_YN);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
							grdRecord.set('COST_POOL_YN', '');
							grdRecord.set('SEND_DATE_YN', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								if( Ext.isEmpty( grdRecord.get("GUBUN")) ) {
									Unilite.messageBox("구분값을 입력하세요");
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
									return false;
								}
								if( Ext.isEmpty( grdRecord.get("PAY_DIVI")) ) {
									Unilite.messageBox("결제방법을 입력하세요");
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
									return false;
								}
								if( Ext.isEmpty( grdRecord.get("PAY_TYPE")) ) {
									Unilite.messageBox("지출유형 값을 입력하세요");
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
									return false;
								}
								if( Ext.isEmpty( grdRecord.get("MAKE_SALE")) ) {
									Unilite.messageBox("제조판관값을 입력하세요");
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
									return false;
								}
								var param = {
									'GUBUN'	    : grdRecord.get("GUBUN"),
									'PAY_DIVI'  : grdRecord.get("PAY_DIVI"),
									'PAY_TYPE'  : grdRecord.get("PAY_TYPE"),
									'MAKE_SALE' : grdRecord.get("MAKE_SALE"),
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
        	
        	},
        	{dataIndex: 'ACCNT_NAME'     	, width: 100,
        		editor:Unilite.popup('ACCNT_PAY_G', {
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', records[0].ACCNT);
							grdRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
							grdRecord.set('COST_POOL_YN', records[0].COST_POOL_YN);
							grdRecord.set('SEND_DATE_YN', records[0].SEND_DATE_YN);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT', '');
							grdRecord.set('ACCNT_NAME', '');
							grdRecord.set('COST_POOL_YN', '');
							grdRecord.set('SEND_DATE_YN', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								if( Ext.isEmpty( grdRecord.get("GUBUN")) ) {
									Unilite.messageBox("구분값을 입력하세요");
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
									return false;
								}
								if( Ext.isEmpty( grdRecord.get("PAY_DIVI")) ) {
									Unilite.messageBox("결제방법을 입력하세요");
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
									return false;
								}
								if( Ext.isEmpty( grdRecord.get("PAY_TYPE")) ) {
									Unilite.messageBox("PAY_TYPE값을 입력하세요");
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
									return false;
								}
								if( Ext.isEmpty( grdRecord.get("MAKE_SALE")) ) {
									Unilite.messageBox("제조판관값을 입력하세요");
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
									return false;
								}
								var param = {
									'GUBUN'	    : grdRecord.get("GUBUN"),
									'PAY_DIVI'  : grdRecord.get("PAY_DIVI"),
									'PAY_TYPE'  : grdRecord.get("PAY_TYPE"),
									'MAKE_SALE' : grdRecord.get("MAKE_SALE"),
								}
								popup.setExtParam(param);
							}
						}
					}
					
				})
        	},
        	{dataIndex: 'REMARK'     		, width: 100},
        	{dataIndex: 'PROOF_KIND'		, width: 100	, hidden:true},
        	{dataIndex: 'REASON_ESS'     	, width: 100	, hidden:true},
        	{dataIndex: 'PROOF_TYPE'     	, width: 100	, hidden:true},
        	{dataIndex: 'CUSTOM_ESS'     	, width: 100	, hidden:true},
        	{dataIndex: 'DEFAULT_EB'     	, width: 100	, hidden:true},
        	{dataIndex: 'DEFAULT_REASON'    , width: 100	, hidden:true},
        	{dataIndex: 'QTY'     			, width: 100	, hidden:true},
        	{dataIndex: 'PRICE'    			, width: 100	, hidden:true},
        	{dataIndex: 'MONEY_UNIT'		, width: 100	}, 
			{dataIndex: 'EXCHG_RATE_O'		, width: 100	}, 
			{dataIndex: 'FOR_AMT_I'			, width: 100	, summaryType : 'sum'},
			{dataIndex: 'TOT_AMT_I'     	, width: 100	, summaryType : 'sum'},
        	{dataIndex: 'SUPPLY_AMT_I'      , width: 100, summaryType : 'sum'},
        	{dataIndex: 'TAX_AMT_I'     	, width: 100, summaryType : 'sum'},
        	{dataIndex: 'PROOF_DIVI'     	, width: 130},
        	{dataIndex: 'ADD_REDUCE_AMT_I'  , width: 100	, hidden:true},
        	{dataIndex: 'COMPANY_NUM'     	, width: 100	, hidden:true},
        	{dataIndex: 'CUSTOM_CODE'       , width: 100,
        		editor: Unilite.popup('CUST_G',{
	        		textFieldName: 'CUSTOM_NAME',
					DBtextFieldName: 'CUSTOM_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM']);
							
		                    var param = {"CUSTOM_CODE": grdRecord.get('CUSTOM_CODE')};
		                    Ext.getBody().mask();
							agj400ukrService.selectCustBankInfo(param, function(provider, response)	{
								 Ext.getBody().unmask();
							
								if(!Ext.isEmpty(provider)){
                    				grdRecord.set('BOOK_CODE'	,provider.BOOK_CODE);
                    				grdRecord.set('BOOK_NAME'	,provider.BOOK_NAME);
                    				grdRecord.set('BANK_NAME'	,provider.BANK_NAME);
                    				grdRecord.set('BANKBOOK_NAME',provider.BANKBOOK_NAME);
                    				grdRecord.set('CUST_BOOK_ACCOUNT',provider.BANKBOOK_NUM);
    				
								}
							})
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('BOOK_CODE'		,'');
            				grdRecord.set('BOOK_NAME'	,'');
            				grdRecord.set('BANK_NAME'	,'');
            				grdRecord.set('BANKBOOK_NAME'	,'');
            				grdRecord.set('CUST_BOOK_ACCOUNT','');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'CUSTOM_TYPE': ['1','2','3','4']
								}
								popup.setExtParam(param);
							}
						}
        			}
	        	})
        	},
        	{dataIndex: 'CUSTOM_NAME'       , width: 100,
        		editor: Unilite.popup('CUST_G',{
	        		textFieldName: 'CUSTOM_NAME',
	        		autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM']);
							
		                    var param = {"CUSTOM_CODE": grdRecord.get('CUSTOM_CODE')};
		                    Ext.getBody().mask();
		                    agj400ukrService.selectCustBankInfo(param, function(provider, response)	{
								 Ext.getBody().unmask();
							
								if(!Ext.isEmpty(provider)){
									grdRecord.set('BOOK_CODE'	,provider.BOOK_CODE);
                    				grdRecord.set('BOOK_NAME'	,provider.BOOK_NAME);
                    				grdRecord.set('BANK_NAME'	,provider.BANK_NAME);
                    				grdRecord.set('BANKBOOK_NAME',provider.BANKBOOK_NAME);
                    				grdRecord.set('CUST_BOOK_ACCOUNT',provider.BANKBOOK_NUM);
    				
								}
							})
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('BOOK_CODE'		,'');
            				grdRecord.set('BOOK_NAME'	,'');
            				grdRecord.set('BANK_NAME'	,'');
            				grdRecord.set('BANKBOOK_NAME'	,'');
            				grdRecord.set('CUST_BOOK_ACCOUNT','');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'CUSTOM_TYPE': ['1','2','3','4']
								}
								popup.setExtParam(param);
							}
						}
        			}
        		})
        	},
        	{dataIndex: 'COMPANY_NUM'     		, width: 100},
        	{dataIndex: 'BOOK_CODE'     	, width: 100, 
        		editor: Unilite.popup('BOOK_CODE_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					DBtextFieldName: 'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BOOK_CODE', records[0].BOOK_CODE);
							grdRecord.set('BOOK_NAME', records[0].BOOK_NAME);
							grdRecord.set('CUST_BOOK_ACCOUNT', records[0].BANK_ACCOUNT);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BOOK_CODE', '');
							grdRecord.set('BOOK_NAME', '');
							grdRecord.set('CUST_BOOK_ACCOUNT', '');
						}
					}
				})
        	},
        	{dataIndex: 'BOOK_NAME'     	, width: 100, 
        		editor: Unilite.popup('BOOK_CODE_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BOOK_CODE', records[0].BOOK_CODE);
							grdRecord.set('BOOK_NAME', records[0].BOOK_NAME);
							grdRecord.set('CUST_BOOK_ACCOUNT', records[0].BANK_ACCOUNT);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('BOOK_CODE', '');
							grdRecord.set('BOOK_NAME', '');
							grdRecord.set('CUST_BOOK_ACCOUNT', '');
						}
					}
				})
        	},
        	{dataIndex: 'BANK_NAME'     	, width: 100},
	   	 	{dataIndex: 'BANKBOOK_NAME'     , width: 100},
        	{dataIndex: 'CUST_BOOK_ACCOUNT'      , width: 120 },
        	{dataIndex: 'BE_CUSTOM_CODE'     	, width: 100	, hidden:true},
        	{dataIndex: 'BE_CUSTOM_NAME'     	, width: 100	, hidden:true},
        	{dataIndex: 'COST_POOL_YN'     		, width: 100	, hidden:true},
        	{dataIndex: 'COST_POOL_CODE'     	, width: 100	, hidden:true},
        	{dataIndex: 'EB_YN'     		, width: 100},
        	{dataIndex: 'CRDT_NUM'     		, width: 100,
        		editor:Unilite.popup('CREDIT_CARD2_G', {
					autoPopup: true,
					textFieldName:'CRDT_NAME',
					DBtextFieldName: 'CRDT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CRDT_NUM', records[0].CRDT_NUM);
							grdRecord.set('CRDT_FULL_NUM', records[0].CRDT_FULL_NUM);
							gsCrdtSetDate = records[0].SET_DATE;
							grdRecord.set('PAY_CUSTOM_CODE', records[0].CRDT_COMP_CD);
							grdRecord.set('PAY_CUSTOM_NAME', records[0].CRDT_COMP_NM);
							gsCrdtCompCd =  records[0].CRDT_COMP_CD;
							gsCrdtCompNm =  records[0].CRDT_COMP_NM;
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CRDT_NUM', '');
							grdRecord.set('CRDT_FULL_NUM', '');
							grdRecord.set('PAY_CUSTOM_CODE', "");
							grdRecord.set('PAY_CUSTOM_NAME', "");
							gsCrdtCompCd =  "";
							gsCrdtCompNm =  "";
						}
					}
				})
        	},
        	{dataIndex: 'CRDT_FULL_NUM'     , width: 100 ,hidden:true },
        	{dataIndex: 'CRDT_FULL_NUM_EXPOS'     , width: 100  },
        	{dataIndex: 'APP_NUM'     		, width: 100},	
        	{dataIndex: 'SAVE_CODE'     	, width: 100, hidden : true,
        		editor: Unilite.popup('BOOK_CODE_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					DBtextFieldName: 'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', records[0].BOOK_CODE);
							grdRecord.set('SAVE_NAME', records[0].BOOK_NAME);
							grdRecord.set('BANK_ACCOUNT', records[0].BANK_ACCOUNT);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
							grdRecord.set('BANK_ACCOUNT', '');
						}
					}
				})
        	},
        	{dataIndex: 'SAVE_NAME'     	, width: 100, hidden : true,
        		editor: Unilite.popup('BOOK_CODE_G', {
					autoPopup: true,
					textFieldName:'BANK_BOOK_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', records[0].BOOK_CODE);
							grdRecord.set('SAVE_NAME', records[0].BOOK_NAME);
							grdRecord.set('BANK_ACCOUNT', records[0].BANK_ACCOUNT);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('SAVE_CODE', '');
							grdRecord.set('SAVE_NAME', '');
							grdRecord.set('BANK_ACCOUNT', '');
						}
					}
				})
        	},
        	
        	{dataIndex: 'BANK_ACCOUNT'      , width: 120 , hidden : true},
        	{dataIndex: 'PJT_CODE'     		, width: 100,
        		editor: Unilite.popup('AC_PROJECT_G',{
	        		textFieldName: 'AC_PROJECT_NAME',
					DBtextFieldName: 'AC_PROJECT_NAME',
					autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
							
		                    var param = {"PJT_CODE": records[0]['AC_PROJECT_CODE']};
							accntCommonService.fnGetSaveCodeofProject(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.each(provider, function(record,i){
										grdRecord.set('SAVE_CODE'		,provider.SAVE_CODE);	
										grdRecord.set('SAVE_NAME'		,provider.SAVE_NAME);	
										grdRecord.set('BANK_ACCOUNT'	,provider.BANK_ACCOUNT);	
									})
								}
							})
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PJT_CODE'		,'');
							grdRecord.set('PJT_NAME'		,'');
							grdRecord.set('SAVE_CODE'		,'');	
							grdRecord.set('SAVE_NAME'		,'');	
							grdRecord.set('BANK_ACCOUNT'	,'');	
						}
        			}
        		})
        	},
        	{dataIndex: 'PJT_NAME'     		, width: 120,
        		editor: Unilite.popup('AC_PROJECT_G',{
	        		textFieldName: 'AC_PROJECT_NAME',
	        		autoPopup: true,
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
                    		grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
							grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
							
		                    var param = {"PJT_CODE": records[0]['AC_PROJECT_CODE']};
							accntCommonService.fnGetSaveCodeofProject(param, function(provider, response)	{
								if(!Ext.isEmpty(provider)){
									Ext.each(provider, function(record,i){
										grdRecord.set('SAVE_CODE'		,provider.SAVE_CODE);	
										grdRecord.set('SAVE_NAME'		,provider.SAVE_NAME);	
										grdRecord.set('BANK_ACCOUNT'	,provider.BANK_ACCOUNT);	
									})
								}
							})
	                    },
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PJT_CODE'		,'');
							grdRecord.set('PJT_NAME'		,'');
							grdRecord.set('SAVE_CODE'		,'');	
							grdRecord.set('SAVE_NAME'		,'');	
							grdRecord.set('BANK_ACCOUNT'	,'');
						}
        			}
        		})
        	},
        	{dataIndex: 'PEND_CODE'     	, width: 100	, hidden:true},
        	{dataIndex: 'PAY_CUSTOM_CODE'   , width: 100	, hidden:true,
        		editor:Unilite.popup('PAY_CUSTOM_G', {
					autoPopup: true,
					textFieldName:'PAY_CUSTOM_NAME',
					DBtextFieldName: 'PAY_CUSTOM_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							if(grdRecord.get('PEND_CODE') == 'A4' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'C' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'BC' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'CC') {
							   	
							   	grdRecord.set('PAY_CUSTOM_CODE'		, records[0].PAY_CUSTOM_CODE);
								grdRecord.set('PAY_CUSTOM_NAME'		, records[0].PAY_CUSTOM_NAME);
								grdRecord.set('CUSTOM_CODE'			, records[0].PAY_CUSTOM_CODE);	
								grdRecord.set('CUSTOM_NAME'			, records[0].PAY_CUSTOM_NAME);
							}else{
								grdRecord.set('PAY_CUSTOM_CODE'		, records[0].PAY_CUSTOM_CODE);
								grdRecord.set('PAY_CUSTOM_NAME'		, records[0].PAY_CUSTOM_NAME);
								
							}
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							
							if(grdRecord.get('PEND_CODE') == 'A4' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'C' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'BC' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'CC') {
							   	
							   	grdRecord.set('PAY_CUSTOM_CODE'	, '');
								grdRecord.set('PAY_CUSTOM_NAME'	, '');
							}else{
								grdRecord.set('PAY_CUSTOM_CODE'	, '');
								grdRecord.set('PAY_CUSTOM_NAME'	, '');	
								grdRecord.set('CUSTOM_CODE'		, '');	
								grdRecord.set('CUSTOM_NAME'		, '');	
							}
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								if(grdRecord.get('PEND_CODE') != ''){
									pendCode = grdRecord.get('PEND_CODE');
								}else{
									pendCode = grdRecord.get('PAY_DIVI_REF1');	
								}
								
								var param = {
									'PEND_CODE': pendCode
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{dataIndex: 'PAY_CUSTOM_NAME'   , width: 100	, hidden:true,
        		editor:Unilite.popup('PAY_CUSTOM_G', {
					autoPopup: true,
					textFieldName:'PAY_CUSTOM_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							if(grdRecord.get('PEND_CODE') == 'A4' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'C' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'BC' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'CC') {
							   	
							   	grdRecord.set('PAY_CUSTOM_CODE'		, records[0].PAY_CUSTOM_CODE);
								grdRecord.set('PAY_CUSTOM_NAME'		, records[0].PAY_CUSTOM_NAME);
								grdRecord.set('CUSTOM_CODE'			, records[0].PAY_CUSTOM_CODE);	
								grdRecord.set('CUSTOM_NAME'			, records[0].PAY_CUSTOM_NAME);
							}else{
								grdRecord.set('PAY_CUSTOM_CODE'		, records[0].PAY_CUSTOM_CODE);
								grdRecord.set('PAY_CUSTOM_NAME'		, records[0].PAY_CUSTOM_NAME);	
								
							}
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							
							if(grdRecord.get('PEND_CODE') == 'A4' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'C' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'BC' &&
							   grdRecord.get('PAY_DIVI_REF2') != 'CC') {
							   	
							   	grdRecord.set('PAY_CUSTOM_CODE'	, '');
								grdRecord.set('PAY_CUSTOM_NAME'	, '');
							}else{
								grdRecord.set('PAY_CUSTOM_CODE'	, '');
								grdRecord.set('PAY_CUSTOM_NAME'	, '');	
								grdRecord.set('CUSTOM_CODE'		, '');	
								grdRecord.set('CUSTOM_NAME'		, '');	
								
							}
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								if(grdRecord.get('PEND_CODE') != ''){
									pendCode = grdRecord.get('PEND_CODE');
								}else{
									pendCode = grdRecord.get('PAY_DIVI_REF1');	
								}
								
								var param = {
									'PEND_CODE': pendCode
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{dataIndex: 'REASON_CODE'       , width: 150},

        	{dataIndex: 'SEND_DATE_YN'     	, width: 100	, hidden:true},	
        	{dataIndex: 'SEND_DATE'     	, width: 100},	
        	{dataIndex: 'BILL_DATE'     	, width: 100},
        	{dataIndex: 'DEPT_CODE'     	, width: 100,hidden:true,
        		editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					DBtextFieldName: 'TREE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', '');
							grdRecord.set('DEPT_NAME', '');
						}
					}
				})
        	},
        	{dataIndex: 'DEPT_NAME'     	, width: 100,hidden:true,
        		editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', '');
							grdRecord.set('DEPT_NAME', '');
						}
					}
				})
        	},
        	{dataIndex: 'DIV_CODE'     		, width: 100},
        	{dataIndex: 'ITEM_CODE'     	, width: 100 	, hidden : true},
        	{dataIndex: 'ITEM_NAME'     	, width: 100 	, hidden : true},
        	{dataIndex: 'SPEC'    			, width: 100 	, hidden : true},
        	{dataIndex: 'BILL_USER'     	, width: 100 	, hidden : true},
        	{dataIndex: 'BILL_USER_NAME'     , width: 100 	, hidden : true},
        	{dataIndex: 'REFER_NUM'    		, width: 100 	, hidden : true},
        	{dataIndex: 'CANCEL_YN'    		, width: 100 	, hidden : true}
    	],               
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		if(UniUtils.indexOf(e.field, ['COMPANY_NUM','BANK_ACCOUNT','BANKBOOK_NAME','BANKBOOK_NAME'])){
        			return false;
        		}
      	 		var bEditable;	
        		
        		bEditable = true;
        		
        		if(bEditable == false){
        			return false;
        		} else if(e.field == "TAX_AMT_I") {
        			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
        			var vRecord = validateStore.getAt(vIdx);
        			if(vRecord && vRecord.get("refCode5") == "") {
	        			return false;
	        		} else {
	        			return true;
	        		}
        		} else if(e.field == "PROOF_DIVI") {
        			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
        			var vRecord = validateStore.getAt(vIdx);
        			if(vRecord && vRecord.get("refCode6") == "") {
	        			return false;
	        		} else {
	        			return true;
	        		}
        		} else if(e.field == "EB_YN") {
        			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
        			var vRecord = validateStore.getAt(vIdx);
        			if(vRecord && vRecord.get("refCode7") == "") {
	        			return false;
	        		} else {
	        			return true;
	        		}
        		} else if(UniUtils.indexOf(e.field, ['CRDT_NUM','CRDT_FULL_NUM','CRDT_FULL_NUM_EXPOS'])){
        			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
        			var vRecord = validateStore.getAt(vIdx);
        			if(vRecord && vRecord.get("refCode8") == "") {
	        			return false;
	        		} else {
	        			return true;
	        		}
        		
        		} else if(e.field == "EB_YN"){
        			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
        			var vRecord = validateStore.getAt(vIdx);
        			if(vRecord && vRecord.get("refCode9") == "") {
	        			return false;
	        		} else {
	        			return true;
	        		}
        		
        		} else if(UniUtils.indexOf(e.field, ['APP_NUM'])){
        			if(e.record.data.PROOF_TYPE == 'A'){
            			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
            			var vRecord = validateStore.getAt(vIdx);
            			if(vRecord && vRecord.get("refCode9") == "") {
    	        			return false;
    	        		} else {
    	        			return true;
    	        		}
	        		}else{
        				return false;
        			}
        		} else if(e.field == "PJT_CODE"){
        			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
        			var vRecord = validateStore.getAt(vIdx);
        			if(vRecord && vRecord.get("refCode10") == "") {
	        			return false;
	        		} else {
	        			return true;
	        		}
        		
        		} else if(e.field == "REASON_CODE"){
        			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
        			var vRecord = validateStore.getAt(vIdx);
        			if(vRecord && vRecord.get("refCode11") == "") {
	        			return false;
	        		} else {
	        			return true;
	        		}
        		
        		} else if(e.field == "SEND_DATE"){
        			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
        			var vRecord = validateStore.getAt(vIdx);
        			if(vRecord && vRecord.get("refCode12") == "") {
	        			return false;
	        		} else {
	        			return true;
	        		}
        		
        		}  else if(UniUtils.indexOf(e.field, ['BILL_DATE'])){
        			var vIdx = validateStore.find('value', e.record.get("PAY_DIVI"));
        			var vRecord = validateStore.getAt(vIdx);
        			if(vRecord && vRecord.get("refCode13") == "") {
	        			return false;
	        		} else {
	        			return true;
	        		}
        		} else if(UniUtils.indexOf(e.field, ['SEQ'])){
        			return false;
        		} else{
    				return true;
    			}
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td) {
				if(colName=='CRDT_FULL_NUM_EXPOS' ) {
					grid.ownerGrid.openCryptCardNoPopup(record);
		
				}
			}
        },
		openCryptCardNoPopup:function( record ) {
			if(record) {
				var params = {'CRDT_FULL_NUM': record.get('CRDT_FULL_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'CRDT_FULL_NUM_EXPOS', 'CRDT_FULL_NUM', params);
			}
		},
        setNewDataCopy:function(record){
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'     		,record['COMP_CODE']);
//			grdRecord.set('PAY_DRAFT_NO'        ,record['PAY_DRAFT_NO']);
//			grdRecord.set('SEQ'     			,record['SEQ']);
			grdRecord.set('GUBUN'     			,record['GUBUN']);
			grdRecord.set('GUBUN_REF1'     		,record['GUBUN_REF1']);
			grdRecord.set('PAY_DIVI'     		,record['PAY_DIVI']);
			grdRecord.set('PAY_DIVI_REF1'       ,record['PAY_DIVI_REF1']);
			grdRecord.set('PAY_DIVI_REF2'       ,record['PAY_DIVI_REF2']);
			grdRecord.set('PAY_DIVI_REF3'       ,record['PAY_DIVI_REF3']);
			grdRecord.set('PAY_DIVI_REF4'       ,record['PAY_DIVI_REF4']);
			grdRecord.set('PAY_TYPE'     		,record['PAY_TYPE']);
			grdRecord.set('PAY_TYPE_REF4'     	,record['PAY_TYPE_REF4']);
			grdRecord.set('PAY_TYPE_REF6'     	,record['PAY_TYPE_REF6']);
			grdRecord.set('MAKE_SALE'     		,record['MAKE_SALE']);
			grdRecord.set('ACCNT'     			,record['ACCNT']);
			grdRecord.set('ACCNT_NAME'     	    ,record['ACCNT_NAME']);
			grdRecord.set('REMARK'     		    ,record['REMARK']);
			grdRecord.set('PROOF_DIVI'     	    ,record['PROOF_DIVI']);
			grdRecord.set('PROOF_KIND'			,record['PROOF_KIND']);
			grdRecord.set('REASON_ESS'     	    ,record['REASON_ESS']);
			grdRecord.set('PROOF_TYPE'     	    ,record['PROOF_TYPE']);
			
			grdRecord.set('CUSTOM_ESS'     	    ,record['CUSTOM_ESS']);
			grdRecord.set('DEFAULT_EB'     	    ,record['DEFAULT_EB']);
			grdRecord.set('DEFAULT_REASON'      ,record['DEFAULT_REASON']);
			grdRecord.set('QTY'        			,record['QTY']);
			grdRecord.set('PRICE'     			,record['PRICE']);
			grdRecord.set('SUPPLY_AMT_I'        ,record['SUPPLY_AMT_I']);
			grdRecord.set('TAX_AMT_I'     		,record['TAX_AMT_I']);
			grdRecord.set('ADD_REDUCE_AMT_I'    ,record['ADD_REDUCE_AMT_I']);
			grdRecord.set('TOT_AMT_I'     		,record['TOT_AMT_I']);
			grdRecord.set('COMPANY_NUM'         ,record['COMPANY_NUM']);
			grdRecord.set('CUSTOM_CODE'         ,record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'         ,record['CUSTOM_NAME']);
			grdRecord.set('PEND_CODE'     		,record['PEND_CODE']);
			grdRecord.set('BE_CUSTOM_CODE'      ,record['BE_CUSTOM_CODE']);
			grdRecord.set('BE_CUSTOM_NAME'      ,record['BE_CUSTOM_NAME']);
			grdRecord.set('COST_POOL_YN'        ,record['COST_POOL_YN']);
			grdRecord.set('COST_POOL_CODE'      ,record['COST_POOL_CODE']);
			grdRecord.set('EB_YN'     			,record['EB_YN']);
			grdRecord.set('CRDT_NUM'     		,record['CRDT_NUM']);
			grdRecord.set('CRDT_FULL_NUM'       ,record['CRDT_FULL_NUM']);
			grdRecord.set('APP_NUM'     		,record['APP_NUM']);
			grdRecord.set('SAVE_CODE'     		,record['SAVE_CODE']);
			grdRecord.set('SAVE_NAME'     		,record['SAVE_NAME']);
			grdRecord.set('BANK_ACCOUNT'        ,record['BANK_ACCOUNT']);
			grdRecord.set('PJT_CODE'     		,record['PJT_CODE']);
			grdRecord.set('PJT_NAME'     		,record['PJT_NAME']);
			grdRecord.set('PEND_CODE'      		,record['PEND_CODE']);
			
			grdRecord.set('PAY_CUSTOM_CODE'     ,record['PAY_CUSTOM_CODE']);
			grdRecord.set('PAY_CUSTOM_NAME'     ,record['PAY_CUSTOM_NAME']);
			grdRecord.set('REASON_CODE'         ,record['REASON_CODE']);
			grdRecord.set('SEND_DATE_YN'     	,record['SEND_DATE_YN']);
			grdRecord.set('SEND_DATE'     		,record['SEND_DATE']);
			grdRecord.set('BILL_DATE'     		,record['BILL_DATE']);
			grdRecord.set('DEPT_CODE'     		,record['DEPT_CODE']);
			grdRecord.set('DEPT_NAME'     		,record['DEPT_NAME']);
			grdRecord.set('DIV_CODE'     		,record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'     		,record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'     		,record['ITEM_NAME']);
			grdRecord.set('SPEC'     			,record['SPEC']);
			grdRecord.set('BILL_USER'     	    ,record['BILL_USER']);
			grdRecord.set('BILL_USER_NAME'     	,record['BILL_USER_NAME']);
			grdRecord.set('REFER_NUM'     		,record['REFER_NUM']);
			grdRecord.set('CANCEL_YN'     		,record['CANCEL_YN']);
			
			UniAppManager.app.fnCalcTotAmt(grdRecord, record['TOT_AMT_I']);
		}
		
    });
    
	 Unilite.Main( {
		borderItems:[
				detailForm, detailGrid
		], 
		id : 'agj400ukrApp',
		fnInitBinding : function(params) {
			
			var param= Ext.getCmp('detailForm').getValues();

			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['query'], false);
			
			var fp = Ext.getCmp('agj400ukrFileUploadPanel');
			if(fp)	{
				fp.clear();
			}
			
			this.setDefault(params);
			detailForm.onLoadSelectText('PAY_DATE');
			
		},
		onQueryButtonDown : function()	{
			var fp = Ext.getCmp('agj400ukrFileUploadPanel');
			if(fp)	{
				fp.clear();
			}
			detailForm.getForm().load({
				params : {'PAY_DRAFT_NO' : detailForm.getValue('PAY_DRAFT_NO')},
				success:function(form, action){
					if(!Ext.isEmpty(detailForm.getValue("EX_NUM")) && detailForm.getValue("EX_NUM") != 0) { 
						UniAppManager.app.fnMasterDisable(true);
					} else {
						UniAppManager.app.fnMasterDisable(false);
					}
					var printBtn = detailForm.down("#printBtn");
					printBtn.setDisabled(false);
					directDetailStore.loadStoreRecords();
				},
        		failure:function(form, action){
					UniAppManager.app.onResetButtonDown();
        		}
			})
		
			
		},
		onNewDataButtonDown: function(copyCheck)	{
			if(!detailForm.getInvalidMessage()) return false;

			var gubun = "1"
			var	detailData = directDetailStore.getData().items;
			if(!Ext.isEmpty(detailData) && detailData.length > 0)	{
				gubun = detailData[0].get("GUBUN");
			}
			var payDraftNo    = detailForm.getValue('PAY_DRAFT_NO');
			var seq = directDetailStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
			var addReduceAmtI = 0;
			var ebYn	      = 'N';
			var deptCode      = detailForm.getValue('DEPT_CODE');
			var deptName      = detailForm.getValue('DEPT_NAME');
			var divCode       = detailForm.getValue('DIV_CODE');
			var billUser      = detailForm.getValue('PAY_DRAFT_PN');
			var billUserName  = detailForm.getValue('PAY_DRAFT_NM');
			var useDate       = UniDate.getDbDateStr(detailForm.getValue('EX_DATE'));
			var selectedRecord = detailGrid.getSelectedRecord();
			var customCode = "";
			var customName = "";
			var companyNum = "";
			var bookCode = "";
			var bookName = "";
			var bankName = "";
			var bankbookName = "";
			var bankAccount = "";
			
			if(selectedRecord)	{
				customCode = selectedRecord.get('CUSTOM_CODE');
				customName = selectedRecord.get('CUSTOM_NAME');
				companyNum = selectedRecord.get('COMPANY_NUM');
				bookCode = selectedRecord.get('BOOK_CODE');
				bookName = selectedRecord.get('BOOK_NAME');
				bankName = selectedRecord.get('BANK_NAME');
				bankbookName = selectedRecord.get('BANKBOOK_NAME');
				bankAccount = selectedRecord.get('CUST_BOOK_ACCOUNT');
			}
			
            var r = {   
            	GUBUN 			: gubun,
				PAY_DRAFT_NO 	: payDraftNo,
				MAKE_SALE		: gsMakeSale,
				SEQ	 		 	: seq,   
				ADD_REDUCE_AMT_I : addReduceAmtI,
				EB_YN 			: ebYn,	     
				DEPT_CODE 		: deptCode,     
				DEPT_NAME 		: deptName,    
				DIV_CODE 		: divCode,     
				BILL_USER 		: billUser,
				BILL_USER_NAME 	: billUserName,
				CUSTOM_CODE     : customCode,
				CUSTOM_NAME     : customName,
				COMPANY_NUM     : companyNum,
				USE_DATE        : useDate,
				BOOK_CODE       : bookCode,
				BOOK_NAME       : bookName,
				BANK_NAME       : bankName,
				BANKBOOK_NAME   : bankbookName,
				CUST_BOOK_ACCOUNT    : bankAccount
	        };
	        if(copyCheck == 'Y'){
	        	detailGrid.createRow(r);	
	        }else{
				detailGrid.createRow(r,'GUBUN');
	        }
	        gsCrdtCompCd = "";
		    gsCrdtCompNm = "";	
		},
		copyDataCreateRow: function()	{
			var seq = directDetailStore.max('SEQ');
        	if(!seq){
        		seq = 1;
        	}else{
        		seq += 1;
        	}
            var r = {  
				SEQ	 		 : seq
	        };
			detailGrid.createRow(r);
		},
		onDedAmtNewDataCreateRow: function()	{
			dedAmtGrid.createRow();
		},
		onResetButtonDown: function() {
			detailForm.uniOpt.inLoading = true;
			detailForm.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.app.fnInitInputFields();
			UniAppManager.app.fnMasterDisable(false);
			detailForm.uniOpt.inLoading = false;
			UniAppManager.setToolbarButtons(['delete','deleteAll','save'], false);
		},
		onSaveDataButtonDown: function(config) {

       		var fp = Ext.getCmp('agj400ukrFileUploadPanel');
       		if(fp)	{
				var addFiles = fp.getAddFiles();
				var removeFiles = fp.getRemoveFiles();
				if(detailForm.getValue('ADD_FID') != addFiles) detailForm.setValue('ADD_FID', addFiles);
				if(detailForm.getValue('DEL_FID') != removeFiles) detailForm.setValue('DEL_FID', removeFiles);
       		}
			if(!detailForm.getInvalidMessage()) return false; 
			directDetailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var records = directDetailStore.data.items;
			var selRow = detailGrid.getSelectedRecord();
			var lCnt = 0;
			var sPayDraftNo = '';
			
			var realAmtI;
			var oldTotAmtI;
			var newTotAmtI;
			
			if(detailForm.getValue('EX_NUM') != '' ){
				Unilite.messageBox("기표가 되어 삭제할 수 없습니다.")								
				return;
			}
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();
				
			}
		},
		onDeleteAllButtonDown: function() {
			
			if(!detailForm.getInvalidMessage()) return;   
				       
			if(confirm('전체삭제 하시겠습니까?')) {
				var encryptPass = new String;
				
				var temp1 = new Array();
				var temp2 = new Array();
			
				var param = {
					PAY_DRAFT_NO: detailForm.getValue('PAY_DRAFT_NO'),
					DRAFTER_PN  : detailForm.getValue('DRAFTER_PN')
				}
				Ext.getBody().mask('전체삭제 중...','loading-indicator');
				
				agj400ukrService.agj400ukrDelA(param, function(provider, response)	{							
					if(provider){	
						UniAppManager.updateStatus("삭제되었습니다.");
						
						UniAppManager.app.onResetButtonDown();		
					}
					Ext.getBody().unmask();		
					
				});
			}else{
				return false;	
			}
		},

		processParams: function(params) {
			detailForm.setValue("PAY_DRAFT_NO", params.PAY_DRAFT_NO);
			
			this.onQueryButtonDown();
		},
		setDefault: function(params){
			detailForm.uniOpt.inLoading = true;
			UniAppManager.app.fnInitInputProperties();
			
			if(!Ext.isEmpty(params.PAY_DRAFT_NO)){
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
			}
			detailForm.uniOpt.inLoading = false;
			
		},
		/**
		 * 입력란의 속성 설정 (입력가능여부 등)
		 */
		fnInitInputProperties: function() {
			
			detailForm.getField('DRAFTER_PN').setReadOnly(false);
			detailForm.getField('DRAFTER_NM').setReadOnly(false);
			
			detailForm.getField("DRAFTER_PN").setConfig('allowBlank',false);
			detailForm.getField("DRAFTER_NM").setConfig('allowBlank',false);
			
			
			//지출결의 그룹웨어 연동여부
			if(gsLinkedGW == 'Y'){
				
				detailForm.down('#btnProc').setText(Msg.fSbMsgA0437);
			}else{
				detailForm.down('#btnProc').setText("자동기표");
			}
			
			detailForm.getField('PAY_DATE').focus();
		},

		/**
		 * 입력란의 초기값 설정
		 */
		fnInitInputFields: function(){
			//지출작성일
			detailForm.setValue('PAY_DATE', UniDate.get('today'));
			
			//지출작성자
			detailForm.setValue('DRAFTER_PN',UserInfo.personNumb);
			detailForm.setValue('DRAFTER_NM',UserInfo.userName);
			
			//사용일(전표일)
			detailForm.setValue('EX_DATE', UniDate.get('today'));
			detailForm.setValue('EX_NUM','');
			
			//지출결의번호
			detailForm.setValue('PAY_DRAFT_NO','');
			
			//사용자
			detailForm.setValue('PAY_USER_PN',UserInfo.personNumb);
			detailForm.setValue('PAY_USER_NM',UserInfo.userName);
			
			//사업장
			detailForm.setValue('DIV_CODE', UserInfo.divCode);
			
			//부서
			detailForm.setValue('DEPT_CODE', UserInfo.deptCode);
			detailForm.setValue('DEPT_NAME', UserInfo.deptName);
			
			//지출건명
			detailForm.setValue('TITLE','');	
			
			//내용
			detailForm.setValue('TITLE_DESC','');
			
			detailForm.getField('PAY_DATE').focus();
		},
		
		/**
		 * 지출결의 마스터정보 표시
		 */
		fnDispMasterData:function(qryType){
			if(qryType == 'COPY'){
				//지출작성일
				detailForm.setValue('PAY_DATE',UniDate.get('today'));
				
				//지출작성자
				detailForm.setValue('DRAFTER_PN',UserInfo.personNumb);
				detailForm.setValue('DRAFTER_NM',UserInfo.userName);
				
				//사용일(전표일)
				detailForm.setValue('EX_DATE',UniDate.get('today'));
				detailForm.setValue('EX_NUM','');
				
				//지출결의번호
				detailForm.setValue('PAY_DRAFT_NO','');
				
			}else if(qryType == 'QUERY'){
				if(directMasterStore.getCount() == 0){
					
					//지출작성일
					detailForm.setValue('PAY_DATE','');
					
					//지출작성자
					detailForm.setValue('DRAFTER_PN','');
					detailForm.setValue('DRAFTER_NM','');
					
					//사용일(전표일)
					detailForm.setValue('EX_DATE','');
					detailForm.setValue('EX_NUM','');
					
					
					//사용자
					detailForm.setValue('PAY_USER_PN','');
					detailForm.setValue('PAY_USER_NM','');
					
					//사업장
					detailForm.setValue('DIV_CODE','');
					
					//부서
					detailForm.setValue('DEPT_CODE','');
					detailForm.setValue('DEPT_NAME','');	
					
					//지출건명
					detailForm.setValue('TITLE','');

					//내용
					detailForm.setValue('TITLE_DESC','');
					
					Unilite.messageBox('자료가 존재하지 않습니다.');
					
					return false;
				}else{
					
					var masterRecord = directMasterStore.data.items[0];
					
					//지출작성일
					detailForm.setValue('PAY_DATE',masterRecord.data.PAY_DATE);
					
					//사용일(전표일)
					detailForm.setValue('EX_DATE',masterRecord.data.EX_DATE);
					detailForm.setValue('EX_NUM',masterRecord.data.EX_NUM);
					
					//지출결의번호
					detailForm.setValue('PAY_DRAFT_NO',masterRecord.data.PAY_DRAFT_NO);
					
					
					//지출작성자
					detailForm.setValue('DRAFTER_PN',masterRecord.data.DRAFTER);
					detailForm.setValue('DRAFTER_NM',masterRecord.data.DRAFTER_NM);
					
					//사용자
					detailForm.setValue('PAY_USER_PN',masterRecord.data.PAY_USER);
					detailForm.setValue('PAY_USER_NM',masterRecord.data.PAY_USER_NM);
					
					//사업장
					detailForm.setValue('DIV_CODE',masterRecord.data.DIV_CODE);
					
					//부서
					detailForm.setValue('DEPT_CODE',masterRecord.data.DEPT_CODE);
					detailForm.setValue('DEPT_NAME',masterRecord.data.DEPT_NAME);
					
					//지출건명
					detailForm.setValue('TITLE',masterRecord.data.TITLE);
					
					//내용
					detailForm.setValue('TITLE_DESC',masterRecord.data.TITLE_DESC);
					
				}
			}			
		},
		/**
		 * 프리폼 입력제어 처리
		 */
		fnMasterDisable:function(bBool){
			var bExcept;
			
			bExcept = false;
			
			//조건1) 자동기표 되었거나 상신되었으면 입력란의 수정불가
			if(detailForm.getValue('EX_NUM') != '' ){
				bBool = true;
			}
			
			//지출작성일
			detailForm.getField('PAY_DATE').setReadOnly(bBool);
			
			//지출작성자
			detailForm.getField('DRAFTER_PN').setReadOnly(bBool);	
			detailForm.getField('DRAFTER_NM').setReadOnly(bBool);		
			
			
			//사용일(전표일)
			detailForm.getField('EX_DATE').setReadOnly(bBool);
			
			//사용자
			detailForm.getField('PAY_USER_PN').setReadOnly(bBool);	
			detailForm.getField('PAY_USER_NM').setReadOnly(bBool);	
			
			//사용자
			detailForm.getField('DIV_CODE').setReadOnly(bBool);
			
			//예산부서
			detailForm.getField('DEPT_CODE').setReadOnly(bBool);	
			detailForm.getField('DEPT_NAME').setReadOnly(bBool);	
			
			//지출건명
			detailForm.getField('TITLE').setReadOnly(bBool);
			
			//내용
			detailForm.getField('TITLE_DESC').setReadOnly(bBool);
			
			
			//자동기표조회, 출력버튼: 자동기표 되었으면 활성화
			
			if(detailForm.getValue('EX_NUM') == ''){
				Ext.getCmp('btnLinkSlip').setDisabled(true);
//				Ext.getCmp('출력버튼').setDisabled(true);	출력버튼 관련 pdf로
			}else{
				Ext.getCmp('btnLinkSlip').setDisabled(false);
//				Ext.getCmp('출력버튼').setDisabled(false);	출력버튼 관련 pdf로
			}
			
			//결재상신/지출결의자동기표 버튼 : 자동기표 되었으면(그룹웨어 연동 아닐때) 자동기표취소로 활성
			if(detailForm.getValue('EX_NUM') != '' && gsLinkedGW == 'N'){
				Ext.getCmp('btnProc').setDisabled(false);
				detailForm.down('#btnProc').setText("기표취소");		
			}else if(detailForm.getValue('EX_NUM') == '' && gsLinkedGW == 'N'){
				Ext.getCmp('btnProc').setDisabled(false);
				detailForm.down('#btnProc').setText("자동기표");	
			}else {
				Ext.getCmp('btnProc').setDisabled(bBool);
			}
		},
		
	
		
		
		/**
		 *  사용일(전표일) 변경 시, 증빙구분이 있는 지출결의디테일에도 반영
		 */
		fnApplySlipDate: function(slipDate){
			var records = directDetailStore.data.items;
			Ext.each(records, function(record, i){
				if(record.get('PAY_DIVI_REF2') != 'C' && 
				   record.get('PAY_DIVI_REF2') != 'BC' &&
				   record.get('PAY_DIVI_REF2') != 'CC'){
						record.set('BILL_DATE', UniDate.getDbDateStr(slipDate));
				   }
			});
		},
		/**
		 *  "사업장", "부서", "예산구분" 변경 시, 지출결의디테일에도 반영
		 */
		fnApplyToDetail: function(){
			var records = directDetailStore.data.items;
			
			Ext.each(records, function(record, i){
				record.set('BUDG_GUBUN',detailForm.getValue('BUDG_GUBUN'));
				record.set('DEPT_CODE',detailForm.getValue('DEPT_CODE'));
				record.set('DEPT_NAME',detailForm.getValue('DEPT_NAME'));
				record.set('DIV_CODE',detailForm.getValue('DIV_CODE'));
				
				if(record.get('PEND_CODE') == 'A6'){
					record.set('PAY_CUSTOM_CODE',detailForm.getValue('PAY_USER_PN'));	
					record.set('PAY_CUSTOM_NAME',detailForm.getValue('PAY_USER_NM'));	
				}
			});
		},
		
		
		/**
		 * 자동기표취소
		 */
		fnCancSlip: function(){
			var param = detailForm.getValues();
			agj400ukrService.cancSlip(param, function(responseText) {
					if(!Ext.isEmpty(responseText))  {
						UniAppManager.updateStatus("기표가 취소 되었습니다.");
						UniAppManager.app.onQueryButtonDown();
						detailForm.down('#btnProc').setText("자동기표");		
						//UniAppManager.app.fnMasterDisable(true);
					}
					
				
			});
		},
		/**
		 * 지출결의자동기표
		 */
		fnAutoSlip: function(){
			var param= detailForm.getValues();
			agj400ukrService.autoSlip(param, function(responseText) {
					if(!Ext.isEmpty(responseText))  {
						UniAppManager.updateStatus("자동기표가 실행되었습니다.")
						UniAppManager.app.onQueryButtonDown();
						detailForm.down('#btnProc').setText("기표취소");		
						//UniAppManager.app.fnMasterDisable(true);
					}
				}
			);
		},
		/**
		 * 자동기표조회 링크 관련
		 */
		fnOpenSlip: function(){
			if(detailForm.getValue('EX_NUM') == ''){
				return false;	
			}
			var params = {
//				action:'select', 
				'PGM_ID' : 'agj400ukr',
				'EX_DATE' : detailForm.getValue('EX_DATE'),
				'INPUT_PATH' : '80',
				'EX_NUM' : detailForm.getValue('EX_NUM'),
				'iRcvSlipSeq' : '1',	//?
				'AP_STS' : '',
				'DIV_CODE' : detailForm.getValue('DIV_CODE')
			}
	  		var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj105ukr.do', params);
		},
		
		/**
		 * 재기표 관련
		 */
		fnReAuto: function(){
			var param= Ext.getCmp('detailForm').getValues();
			reAutoStore.load({
				params : param,
				callback : function(records, operation, success) {
					if(success)	{
						detailForm.setValue('EX_NUM',records[0].data.EX_NUM);
						detailForm.setValue('HDD_STATUS',records[0].data.STATUS);
						
						detailForm.getField('STATUS').setValue(records[0].data.STATUS);
						
						UniAppManager.app.fnMasterDisable(true);
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0328);	
					}else{
						return false;
					}
				}
			});
		},
		
		/**
		 * 선택된 경비구분에 따라 법인카드/ 통장 필수처리
		 */
		fnSetPropertiesbyPayDivi: function(applyRecord, newValue){
			var sPayDivi = '';
			
			sPayDivi = newValue;
			
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE1, '') PAY_DIVI_REF1, " +
							"ISNULL(REF_CODE2, '') PAY_DIVI_REF2, " +
						 	"ISNULL(REF_CODE3, '') PAY_DIVI_REF3, " +
						    "ISNULL(REF_CODE4, '') PAY_DIVI_REF4", 
				ADD_QUERY2: '',
				MAIN_CODE: 'A172',
				SUB_CODE: sPayDivi
				
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{
				if(gsCrdtRef == 'Y' &&  provider.PAY_DIVI_REF2 == 'C' && applyRecord.get('REFER_NUM') == ''){
					Unilite.messagBox("결제방법이 법인카드이면 [법인카드승인참조] 탭에서 법인카드승인내역을 참조적용하여 입력하십시오.");
					applyRecord.set('PAY_DIVI','');
					
					return false;
				}
				
				applyRecord.set('PAY_DIVI_REF1'	,provider.PAY_DIVI_REF1);
				applyRecord.set('PAY_DIVI_REF2'	,provider.PAY_DIVI_REF2);
				applyRecord.set('PAY_DIVI_REF3'	,provider.PAY_DIVI_REF3);
				applyRecord.set('PAY_DIVI_REF4'	,provider.PAY_DIVI_REF4);
				
				applyRecord.set('PEND_CODE'		,applyRecord.get('PAY_DIVI_REF1'));
				
				if(provider.PAY_DIVI_REF2 == 'BC'){
					applyRecord.set('PAY_CUSTOM_CODE',applyRecord.get('PAY_DIVI_REF4'));	
				}
				
			});
		},
		fnSetPropertiesbyGubun: function(applyRecord, newValue){
			var gubunStore = Ext.data.StoreManager.lookup("CBS_AU_A178");
			var gubunRecord = gubunStore.getAt(gubunStore.find("value", newValue));
			var gubunRef1 = gubunRecord.get("refCode1");
			applyRecord.set("GUBUN_REF1", gubunRecord.get("refCode1"));
			
		},
		/**
		 * 선택된 증빙구분에 따라 증빙유형,계산서일,전자계산서발행 기본값설정, 필수입력컬럼 설정
		 */
		fnSetPropertiesbyProofKind: function(applyRecord, newValue){
			var sProofDivi = '';
			
			sProofDivi = newValue;
			
			var param = {
				ADD_QUERY1: "ISNULL(REF_CODE4,'') REF_CODE4, " +
							"ISNULL(REF_CODE1,'') REF_CODE1, " +
							"ISNULL(REF_CODE2,'') REF_CODE2, " +
							"ISNULL(REF_CODE3,'') REF_CODE3, " +
							"ISNULL(REF_CODE5,'') REF_CODE5, " +
							"ISNULL(REF_CODE6,'') REF_CODE6, " +
							"ISNULL(REF_CODE7,'') REF_CODE7",
				ADD_QUERY2: '',
				MAIN_CODE: 'A173',
				SUB_CODE: sProofDivi
			}
			accntCommonService.fnGetRefCodes(param, function(provider, response)	{
				applyRecord.set('PROOF_KIND'	,provider.REF_CODE1);
				applyRecord.set('REASON_ESS'	,provider.REF_CODE2);
				applyRecord.set('PROOF_TYPE'	,provider.REF_CODE3);
				applyRecord.set('CUSTOM_ESS'	,provider.REF_CODE5);
				applyRecord.set('DEFAULT_EB'	,provider.REF_CODE6);
				applyRecord.set('DEFAULT_REASON',provider.REF_CODE7);
				
				//UniAppManager.app.fnSetEssReasonField(applyRecord); //불공제사유 필수입력여부 설정
			
				//UniAppManager.app.fnSetEssCustomField(applyRecord); //거래처 필수입력여부 설정
				
				
				UniAppManager.app.fnCalcTotAmt(applyRecord, '');
				
				applyRecord.set('EB_YN',applyRecord.get('DEFAULT_EB')); //전자발행여부 기본값설정
				
				applyRecord.set('REASON_CODE',applyRecord.get('DEFAULT_REASON'));	//불공제사유 기본값설정
				
				
				//증빙구분에 따른 계산서일, 전자발행여부 기본값 설정
				if(applyRecord.get('PAY_DIVI_REF2') != 'C' &&
				   applyRecord.get('PAY_DIVI_REF2') != 'BC' &&
				   applyRecord.get('PAY_DIVI_REF2') != 'CC' ){
					if(newValue != ''){
						applyRecord.set('BILL_DATE' ,detailForm.getValue('EX_DATE'));		
					}else{
						applyRecord.set('EB_YN'		,'N');		
					}
				}
				
				if(provider.REF_CODE4 != 'Y'){
					if(applyRecord.get('PROOF_KIND') == ''){
						Ext.Msg(Msg.sMB099,Msg.fSbMsgA0504);
					}
				}
			});
		},
		/**
		 * 선택된 지급처구분에 따라 참조코드값 가져오기
		 */
		fnSetPropertiesbyPendCode: function(applyRecord, pendCodeNewValue, payCustomCodeNewValue, payCustomNameNewValue){
			var sPendCode = '';
			var sPayCustomCode = '';
			
			if(pendCodeNewValue == ''){
				sPendCode = applyRecord.get('PEND_CODE');
			}else{
				sPendCode = pendCodeNewValue;
			}
			
			var param1 = {
				ADD_QUERY1: "ISNULL(REF_CODE1,'') PEND_CODE_REF1, " +
							"ISNULL(REF_CODE2,'') PEND_CODE_REF2", 
				ADD_QUERY2: '',
				MAIN_CODE: 'A210',
				SUB_CODE: sPendCode
			}
			accntCommonService.fnGetRefCodes(param1, function(provider, response)	{
				applyRecord.set('PEND_CODE_REF1'	,provider.PEND_CODE_REF1);
				
				if(applyRecord.get('PEND_CODE_REF1') != ''){
					applyRecord.set('CUSTOM_CODE'	,provider.PEND_CODE_REF2);	
										
					var param2 = {"CUSTOM_CODE": applyRecord.get('CUSTOM_CODE')};
					accntCommonService.fnCustInfo(param2, function(provider, response)	{
						applyRecord.set('CUSTOM_CODE'	,provider.CUSTOM_CODE);
						applyRecord.set('CUSTOM_NAME'	,provider.CUSTOM_NAME);
						applyRecord.set('AGENT_TYPE'	,provider.AGENT_TYPE);
						
						if(payCustomCodeNewValue == ''){
							sPayCustomCode = applyRecord.get('PAY_CUSTOM_CODE');
						}else{
							sPayCustomCode = payCustomCodeNewValue;
						}
						
						if(sPayCustomCode == ''){
							applyRecord.set('CUSTOM_CODE'	,'');
							applyRecord.set('CUSTOM_NAME'	,'');
						}
						
					});
				}
			});
		},
		
		/**
		 * 증빙유형 or 공급가액 변경 시, 세액 & 지급액 계산
		 */
		fnCalcTaxAmt: function(applyRecord, supplyAmtINewValue){
			var dTot_Amt_I = 0;
			var dTaxRate = 0;
			var dSupply_Amt_I = 0;
			var dTax_Amt_I = 0;
			
			if(Ext.isEmpty(supplyAmtINewValue)){
				dSupply_Amt_I = applyRecord.get('SUPPLY_AMT_I');
			}else{
				dSupply_Amt_I = supplyAmtINewValue;
			}
						
			if(applyRecord.get('PROOF_KIND') == ''){
				dTot_Amt_I = dSupply_Amt_I;
				dTax_Amt_I = 0;
				
				applyRecord.set('TAX_AMT_I'	,dTax_Amt_I);
				applyRecord.set('TOT_AMT_I'	,dTot_Amt_I);
				
			}else{
				dTot_Amt_I = 0;
				dTax_Amt_I = 0;
				
				
				var param = {"PROOF_KIND": applyRecord.get('PROOF_KIND')}
				Ext.getBody().mask();
				accntCommonService.fnGetTaxRate(param, function(provider, response){
					Ext.getBody().unmask();
					dTaxRate = parseInt( provider.TAX_RATE);
					dTax_Amt_I = dSupply_Amt_I * (dTaxRate / 100); 
					
					dTax_Amt_I = UniAccnt.fnAmtWonCalc(dTax_Amt_I, gsAmtPoint);  
					dTot_Amt_I	= dSupply_Amt_I + dTax_Amt_I;
					
					applyRecord.set('TAX_AMT_I'	,dTax_Amt_I);
					applyRecord.set('TOT_AMT_I'	,dTot_Amt_I);
				});
			}
		},
		
		/**
		 * 지급액 = 공급가액 + 세액으로 자동 계산
		 */
		fnCalcTotAmt: function(applyRecord, totAmtNewValue, proofKindNewValue){
			var dTot_Amt_I = 0;
			var dSupply_Amt_I = 0;
			var dTax_Amt_I = 0;
			var dAddReduce_Amt_I = 0;
			
			if(Ext.isEmpty(totAmtNewValue)){
				dTot_Amt_I = applyRecord.get('TOT_AMT_I');
			} else {
				dTot_Amt_I = totAmtNewValue;
			}
			
			var proofKind = ''
				if(Ext.isEmpty(proofKindNewValue)){
					proofKind = applyRecord.get('PROOF_KIND');
				} else {
					proofKind = proofKindNewValue;
				}
			
			if(proofKind == ''){
				dTax_Amt_I = 0;
				
				applyRecord.set('SUPPLY_AMT_I'	,dTot_Amt_I);
				applyRecord.set('TAX_AMT_I'		,dTax_Amt_I);
				applyRecord.set('TOT_AMT_I'		,dTot_Amt_I);
				
				
			}else{
				
				var param = {"PROOF_KIND": proofKind}
				Ext.getBody().mask();
				accntCommonService.fnGetTaxRate(param, function(provider, response){
					Ext.getBody().unmask();
				
					dTaxRate = parseInt(provider.TAX_RATE);
					dSupply_Amt_I = dTot_Amt_I / ((100 + dTaxRate) / 100);
					
					dSupply_Amt_I = UniAccnt.fnAmtWonCalc(dSupply_Amt_I, gsAmtPoint);  
					
					dTax_Amt_I = dTot_Amt_I - dSupply_Amt_I;

					applyRecord.set('SUPPLY_AMT_I'	,dSupply_Amt_I);
					applyRecord.set('TAX_AMT_I'		,dTax_Amt_I);
					applyRecord.set('TOT_AMT_I'		,dTot_Amt_I);
					
				});
			}
			
		},
		
		/**
		 * 공급가액 = 지급액 / 1.1 자동계산
'        * 세   액 = 지급액 - 공급가액
		 */
		fnCalcSupplyAmtI: function(applyRecord, supplyAmtNewValue){
			var dTaxRate = 0;
			var dTot_Amt_I = 0;
			var dSupply_Amt_I = 0;
			var dTax_Amt_I = 0;
			
			if(Ext.isEmpty(supplyAmtNewValue)) {
				dSupply_Amt_I = Unilite.nvl(applyRecord.get('SUPPLY_AMT_I'),0);
			} else {
				dSupply_Amt_I = supplyAmtNewValue;
			}
			
			//dTot_Amt_I = dSupply_Amt_I;			
			
			if(applyRecord.get('PROOF_KIND') == ''){
				dTax_Amt_I = 0;
				
				applyRecord.set('SUPPLY_AMT_I'	,dSupply_Amt_I);
				applyRecord.set('TAX_AMT_I'		,dTax_Amt_I);
				applyRecord.set('TOT_AMT_I'		,dSupply_Amt_I);
				
				
			}else{
				
				var param = {"PROOF_KIND": applyRecord.get('PROOF_KIND')}
				Ext.getBody().mask();
				accntCommonService.fnGetTaxRate(param, function(provider, response){
					Ext.getBody().unmask();
					dTaxRate = parseInt(provider.TAX_RATE);
					//dSupply_Amt_I = dSupply_Amt_I / ((100 + dTaxRate) / 100);
					//dSupply_Amt_I = UniAccnt.fnAmtWonCalc(dSupply_Amt_I, gsAmtPoint);  
					if(Ext.isEmpty(dTaxRate) || dTaxRate == 0)	{
						dTax_Amt_I = 0;
					} else {
						dTax_Amt_I = Unilite.multiply(dSupply_Amt_I ,  (dTaxRate / 100));
					}
					dTot_Amt_I = dSupply_Amt_I + dTax_Amt_I;
					applyRecord.set('SUPPLY_AMT_I'	,dSupply_Amt_I);
					applyRecord.set('TAX_AMT_I'		,dTax_Amt_I);
					applyRecord.set('TOT_AMT_I'		,dTot_Amt_I);
					
				});
			}
		},
		
		
		/**
		 * 지급처 자동설정
		 */
		fnSetPayCustom : function(applyRecord){
			if(applyRecord.get('PAY_DIVI_REF1') =='A6'){
				applyRecord.set('PEND_CODE', 'A6');
				applyRecord.set('PAY_CUSTOM_CODE', detailForm.getValue('PAY_USER_PN'));
				applyRecord.set('PAY_CUSTOM_NAME', detailForm.getValue('PAY_USER_NM'));
			}else{
				if(applyRecord.get('PAY_DIVI_REF2') =='C' || applyRecord.get('PAY_DIVI_REF2') =='CC'){
					applyRecord.set('PAY_CUSTOM_CODE', gsCrdtCompCd);
					applyRecord.set('PAY_CUSTOM_NAME', gsCrdtCompNm);
					applyRecord.set('SEND_DATE', gsCrdtSetDate);
					
				}else if(applyRecord.get('PAY_DIVI_REF2') =='BC'){
					applyRecord.set('PAY_CUSTOM_CODE', applyRecord.get('PAY_DIVI_REF4'));
					
				}else{
					applyRecord.set('SEND_DATE', '');
					var pCustCd = "", pCustNm = "" ;
					if(gsPendCodeYN != 'Y'){
						if(applyRecord.get('PEND_CODE') == 'A4' && applyRecord.get('PAY_DIVI_REF1') == 'A4'){
							pCustCd = applyRecord.get('CUSTOM_CODE');
							pCustNm = applyRecord.get('CUSTOM_NAME');
						}
					}
					applyRecord.set('PAY_CUSTOM_CODE', pCustCd);
					applyRecord.set('PAY_CUSTOM_NAME', pCustNm);
				}
			}
		},
		/**
		 * 신용카드 지급예정일 계산
		 */
		fnSetCrdtSetDate: function(setDate){
			var sSendDate = '';
			
			sSendDate = (UniDate.getDbDateStr(detailForm.getValue('EX_DATE')).substring(0, 6)) + '01';
			
			var tempDate = '';
			tempDate = sSendDate.substring(0,4) + '/' + sSendDate.substring(4,6) + '/' + sSendDate.substring(6,8);
			
			var transDate = new Date(tempDate);
			
			sSendDate = UniDate.add(transDate, {months: +1});
			
			if(Ext.isEmpty(setDate)){
				sSendDate = UniDate.add((UniDate.add(sSendDate, {months: +1})), {days: -1});
				gsCrdtSetDate = UniDate.getDbDateStr(sSendDate);
				
			}else{
				gsCrdtSetDate =	 (UniDate.getDbDateStr(sSendDate).substring(0, 6) + setDate);
			} 
		},
		 setForeignAmt : function(record, mUnit, exRate, forAmt, amtField)  {
			if(Ext.isEmpty(exRate)){
				exRate = 1 ;
			}
		   if(!Ext.isEmpty(mUnit) && !Ext.isEmpty(forAmt) &&  !Ext.isEmpty(exRate)) {
			   
			   var numDigit = 0;
			   if(UniFormat.Price.indexOf(".") > -1) {
				numDigit = (UniFormat.Price.length - (UniFormat.Price.indexOf(".")+1));
			   }
			  var amt = forAmt * exRate;
			   amt = UniAccnt.fnAmtWonCalc(amt, gsAmtPoint, numDigit);
			   record.set(amtField, amt);
			   
			   UniAppManager.app.fnCalcTotAmt(record, amt);
		   }
		  }
	});
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "GUBUN"    : 
					var	detailData = directDetailStore.getData().items;
					if(!Ext.isEmpty(detailData) && detailData.length > 0)	{
						if(newValue != detailData[0].get("GUBUN"))	{
							rv = false;
						}
					}
					if(rv) UniAppManager.app.fnSetPropertiesbyGubun(record.obj, newValue);
				case "PAY_DIVI" :
					UniAppManager.app.fnSetPropertiesbyPayDivi(record.obj, newValue);
					
					UniAppManager.app.fnSetPayCustom(record);
					
					break;
				
				case "PEND_CODE" :
					record.set('PAY_CUSTOM_CODE'	, '');	
					record.set('PAY_CUSTOM_NAME'	, '');	
					record.set('CUSTOM_CODE'		, '');	
					record.set('CUSTOM_NAME'		, '');	
					record.set('AGENT_TYPE'			, '');	
					record.set('IN_BANK_CODE'		, '');	
					record.set('IN_BANK_NAME'		, '');	
					record.set('IN_BANKBOOK_NUM'	, '');	
					record.set('IN_BANKBOOK_NAME'	, '');	
				
					pendCodeNewValue = newValue;
					payCustomCodeNewValue = '';
					payCustomNameNewValue = '';
					
					UniAppManager.app.fnSetPropertiesbyPendCode(record.obj, pendCodeNewValue, payCustomCodeNewValue, payCustomNameNewValue);
					
					supplyAmtINewValue = '';
					UniAppManager.app.fnCalcTaxAmt(record.obj, supplyAmtINewValue);	//,,,
					break;
					
				case "PROOF_DIVI" :
					UniAppManager.app.fnSetPropertiesbyProofKind(record.obj,newValue);
					
					//UniAppManager.app.fnCalcTotAmt(record.obj, '');
					break;
					
				case "SUPPLY_AMT_I" :
				
					supplyAmtINewValue = newValue;
					UniAppManager.app.fnCalcSupplyAmtI(record.obj, supplyAmtINewValue);
					break;	
					
				case "TAX_AMT_I" :
					var totAmtI = record.get("SUPPLY_AMT_I") + newValue;
					record.set("TOT_AMT_I", totAmtI);
					//UniAppManager.app.fnCalcTSupplyAmt(record.obj, '');
					break;	
					/* 
				case "ADD_REDUCE_AMT_I" :
					
					taxAmtINewValue = '';
					addReduceAmtINewValue = newValue;
					UniAppManager.app.fnCalcTotAmt(record.obj, '');
					break;	 */
					
				case "TOT_AMT_I" :
				
					UniAppManager.app.fnCalcTotAmt(record.obj, newValue);
					break;	
					
				case "CUSTOM_CODE" :
					UniAppManager.app.fnSetPayCustom(record.obj);
					break;		
					
				case "CUSTOM_NAME" :
					UniAppManager.app.fnSetPayCustom(record.obj);
					break;	
					
				case "CRDT_NUM" :
					UniAppManager.app.fnSetPayCustom(record.obj);
					break;		
					
				case "CRDT_FULL_NUM" :
					UniAppManager.app.fnSetPayCustom(record.obj);
					break;		
						
				case "PAY_CUSTOM_CODE" :
					
					pendCodeNewValue = '';
					payCustomCodeNewValue = newValue;
					payCustomNameNewValue = '';
					
					UniAppManager.app.fnSetPropertiesbyPendCode(record.obj, pendCodeNewValue, payCustomCodeNewValue, payCustomNameNewValue);
					break;		
					
				case "PAY_CUSTOM_NAME" :
				
					pendCodeNewValue = '';
					payCustomCodeNewValue = '';
					payCustomNameNewValue = newValue;		
					
					UniAppManager.app.fnSetPropertiesbyPendCode(record.obj, pendCodeNewValue, payCustomCodeNewValue, payCustomNameNewValue);
					break;		
				case "QTY":
					if(!Ext.isEmpty(record.get("PRICE")) )	{
						var supplyAmtINewValue = Unilite.multiply(record.get("PRICE"), newValue);
						record.set("SUPPLY_AMT_I", supplyAmtINewValue);
						UniAppManager.app.fnCalcTaxAmt(record.obj, supplyAmtINewValue);
					}
					break;
				case "PRICE":
					if(!Ext.isEmpty(record.get("QTY")) )	{
						var supplyAmtINewValue = Unilite.multiply(record.get("QTY"), newValue)
						record.set("SUPPLY_AMT_I", supplyAmtINewValue);
						UniAppManager.app.fnCalcTaxAmt(record.obj, supplyAmtINewValue);
					}
					break;
				case 'MONEY_UNIT':
					if(newValue != oldValue){
						if(!Ext.isEmpty(newValue)) {
							var agrid = this.grid
							agrid.mask();
							accntCommonService.fnGetExchgRate({
									'AC_DATE'	: UniDate.getDbDateStr(record.get('USE_DATE')),
									'MONEY_UNIT': newValue
								}, 
								function(provider, response){
									agrid.unmask();
									if(!Ext.isEmpty(provider['BASE_EXCHG'])) {
										record.set('EXCHG_RATE_O',provider['BASE_EXCHG']);
										UniAppManager.app.setForeignAmt(record.obj, newValue, provider['BASE_EXCHG'], record.get("FOR_AMT_I"), "TOT_AMT_I");
									}
								}
							)
						}
					}
				break;
				case 'EXCHG_RATE_O':
					UniAppManager.app.setForeignAmt(record.obj, record.get("MONEY_UNIT") , newValue, record.get("FOR_AMT_I"), "TOT_AMT_I");
				break;
				case 'FOR_AMT_I':
					UniAppManager.app.setForeignAmt(record.obj, record.get("MONEY_UNIT") , record.get("EXCHG_RATE_O"),  newValue, "TOT_AMT_I");
				break;
			}
			return rv;
		}
	});	
	
	Unilite.createValidator('validator02', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
					UniAppManager.setToolbarButtons('save',true);
					break;
			}
			return rv;
		}
	});
};
</script>
