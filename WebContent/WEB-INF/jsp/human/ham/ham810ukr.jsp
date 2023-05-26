<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ham810ukr">
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H037" /> <!-- 상여구분자 -->
	<t:ExtComboStore comboType="AU" comboCode="B030" /> <!-- 세액구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H147" /> <!-- 입퇴사구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!-- 지급/공제구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="AU" comboCode="A074" /> <!-- 분기 --> 
	<t:ExtComboStore comboType="BOR120"  /> 	
	<!-- 사업장 -->

</t:appConfig>

<script type="text/javascript">

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
    colData = ${colData};
	
    //var sEmployRate =colData[0].EMPLOY_RATE;
		
	Unilite.defineModel('Ham810ukrModel', {
	    fields: [
			{name: 'COMP_CODE'      		, text: '법인코드'				, type: 'string'},
			{name: 'DIV_CODE'             	, text: '사업장'				, type: 'string',comboType: 'BOR120',defaultValue: UserInfo.divCode},
			{name: 'DEPT_NAME'            	, text: '부서'				, type: 'string'},
			{name: 'PERSON_NUMB'          	, text: '사번'				, type: 'string'},
			{name: 'NAME'                 	, text: '성명'				, type: 'string'},
			{name: 'PAY_YYYYMM'           	, text: '급여년월'				, type: 'string'},
			{name: 'SUPP_DATE'            	, text: '지급일자'				, type: 'string'},
			{name: 'DUTY_YYYYMMDD'        	, text: '근무일자'				, type: 'uniDate', allowBlank:false},
			{name: 'WAGES_STD_I'	      	, text: '기본급'				, type: 'uniPrice',allowBlank:false},
			{name: 'DUTY_TIME_01'         	, text: '연장시간'				, type: 'string'},
			{name: 'DUTY_MINU_01'         	, text: '연장분'				, type: 'string'},
			{name: 'AMOUNT_I_01'	      	, text: '연장수당'				, type: 'uniPrice',allowBlank:false},
			{name: 'DUTY_TIME_02'         	, text: '야근시간'				, type: 'string'},
			{name: 'DUTY_MINU_02'         	, text: '야근분'				, type: 'string'},
			{name: 'AMOUNT_I_02'	      	, text: '야간수당'				, type: 'uniPrice' ,allowBlank:false},
			{name: 'SUPP_TOTAL_I'	      	, text: '지급액'				, type: 'uniPrice' ,allowBlank:false},
			{name: 'TAX_EXEMPTION_I'      	, text: '비과세금액'			, type: 'uniPrice' ,allowBlank:false},
			{name: 'IN_TAX_I'		      	, text: '소득세'				, type: 'uniPrice' ,allowBlank:false},
			{name: 'LOCAL_TAX_I'	      	, text: '주민세'				, type: 'uniPrice' ,allowBlank:false},
			{name: 'HIR_INSUR_I'	      	, text: '고용보험'				, type: 'uniPrice'},
			{name: 'REAL_AMOUNT_I'	      	, text: '실지급액'				, type: 'uniPrice'}
						    		 
			]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ham810MasterStore',{
			model: 'Ham810ukrModel',
			uniOpt: {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: true,			// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ham810ukrService.selectList' ,
                	   create: 'ham810ukrService.insertList' ,
                	   update: 'ham810ukrService.insertList' ,
                	   destroy: 'ham810ukrService.deleteList',
                	   syncAll: 'ham810ukrService.syncAll'
                }
            },
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			if(inValidRecs.length == 0 )	{
    				this.syncAll();					
    			}else {
    				alert(Msg.sMB083);
    			}
            }
            ,loadStoreRecords: function(){
    			var param= Ext.getCmp('searchForm').getValues();			
    			console.log(param);
    			this.load({
    				params: param
    			});
    		}				
	});
		
	/*  var date = new Date();
	 var year = date.getFullYear();
	 var mon = date.getMonth() + 1;
	 var dateString = year + '.' + (mon > 9 ? mon : '0' + mon); */
	
	 /**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	 var panelSearch = Unilite.createSearchPanel('searchForm', {		
			title: '검색조건',
	        defaultType: 'uniSearchSubPanel',
			items: [{	
				title: '기본정보', 	
		   		itemId: 'search_panel1',
		        layout: {type: 'uniTable', columns: 1},
		        defaultType: 'uniTextfield',
				items: [{
					fieldLabel: '급여년월',
					id: 'PAY_YYYYMM',
					name: 'PAY_YYYYMM',
					xtype: 'uniMonthfield',  
					allowBlank: false
				},
				Unilite.popup('Employee', {
					 
					textFieldWidth: 170, 
					validateBlank: false,
					valueFieldName : 'PERSON_NUMB',
					extParam: {'CUSTOM_TYPE': '3'},
					allowBlank: false,
					listeners: {'onSelected': {
						fn: function(records, type) {
								console.log('records : ', records);
								var hpa960ukrGrid1 = Ext.getCmp('hpa960ukrGrid1');
								panelSearch.setValue('DEPT_CODE2',records[0].DEPT_NAME);	
								panelSearch.setValue('DEPT_CODE',records[0].DEPT_CODE);
								panelSearch.setValue('DIV_CODE',records[0].DIV_CODE);
							},
						scope: this
						},
					'onClear': function(type) {
					 	var hpa960ukrGrid1 = Ext.getCmp('hpa960ukrGrid1');
						var grdRecord = hpa960ukrGrid1.getSelectionModel().getSelection()[0]; 
						grdRecord.set('DEPT_NAME', '');
						grdRecord.set('NAME', '');
						grdRecord.set('PERSON_NUMB', '');
						grdRecord.set('POST_CODE', '');
					}
		}
				}),
				{
					fieldLabel: '지급일자',
					id: 'SUPP_DATE',
					xtype: 'uniDatefield',
					name: 'SUPP_DATE', 
					value: new Date(),
					allowBlank: false
				},
				{	    
					fieldLabel: '사업장',
					name: 'DIV_CODE',
					xtype:'uniCombobox',
					comboType:'BOR120',
					value: UserInfo.divCode
				
				},	
				Unilite.popup('DEPT',{
						fieldLabel: '부서',
						textFieldWidth: 170,
						validateBlank: false,
						valueFieldName : 'DEPT_CODE',
						textFieldName: 'DEPT_CODE2',
						popupWidth: 710
						
				})]
			}]
		});	//end panelSearch  
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    //에러
    var masterGrid = Unilite.createGrid('ham810Grid', {
        layout: 'fit',    
        region : 'center',   
    	store: directMasterStore,
        uniOpt:{
        	expandLastColumn: false,
        	useRowNumberer: true,
            useMultipleSorting: true
    	},
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	columns:  [         				
					{dataIndex: 'COMP_CODE'          , width: 66, hidden: true}, 				
					{dataIndex: 'DIV_CODE'           , width: 100}, 				
					{dataIndex: 'DEPT_NAME'          , width: 133}, 
					{dataIndex: 'PERSON_NUMB'        , width: 90,
						editor: Unilite.popup('Employee_G', {		
							textFieldName: 'PERSON_NUMB',
			  				autoPopup: true,
							listeners: {'onSelected': {
											fn: function(records, type) {
													console.log('records : ', records);
													var ham810Grid = Ext.getCmp('ham810Grid');
													var grdRecord = ham810Grid.getSelectionModel().getSelection()[0];
													grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
													grdRecord.set('NAME', records[0].NAME);
													grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
													grdRecord.set('REPRE_NUM', records[0].REPRE_NUM);
													grdRecord.set('JOIN_DATE', records[0].JOIN_DATE);
													grdRecord.set('RETR_DATE', records[0].RETR_DATE);
												},
											scope: this
											},
										'onClear': function(type) {
										 	var ham810Grid = Ext.getCmp('ham810Grid');
											var grdRecord = ham810Grid.getSelectionModel().getSelection()[0]; 
											grdRecord.set('DEPT_NAME', '');
											grdRecord.set('NAME', '');
											grdRecord.set('PERSON_NUMB', '');
											grdRecord.set('REPRE_NUM', '');
											grdRecord.set('JOIN_DATE', '');
											grdRecord.set('RETR_DATE', '');
										}
							}
					}),hidden: true},
					{dataIndex: 'NAME'               , width: 100, hidden: true}, 				
					{dataIndex: 'PAY_YYYYMM'         , width: 100, hidden: true}, 				
					{dataIndex: 'SUPP_DATE'          , width: 100, hidden: true}, 				
					{dataIndex: 'DUTY_YYYYMMDD'      , width: 100}, 				
					{dataIndex: 'WAGES_STD_I'	     , width: 100}, 				
					{dataIndex: 'DUTY_TIME_01'       , width: 66, hidden: true}, 				
					{dataIndex: 'DUTY_MINU_01'       , width: 66, hidden: true}, 				
					{dataIndex: 'AMOUNT_I_01'	     , width: 100}, 				
					{dataIndex: 'DUTY_TIME_02'       , width: 66, hidden: true}, 				
					{dataIndex: 'DUTY_MINU_02'       , width: 66, hidden: true}, 				
					{dataIndex: 'AMOUNT_I_02'	     , width: 100}, 				
					{dataIndex: 'SUPP_TOTAL_I'	     , width: 100}, 				
					{dataIndex: 'TAX_EXEMPTION_I'    , width: 100}, 				
					{dataIndex: 'IN_TAX_I'		     , width: 100}, 				
					{dataIndex: 'LOCAL_TAX_I'	     , width: 100}, 				
					{dataIndex: 'HIR_INSUR_I'	     , width: 100}, 				
					{dataIndex: 'REAL_AMOUNT_I'	     , width: 100}     				     		
          ]
    	, 
    	listeners: {
    		beforeedit: function(editor, e) {
      		console.log(e);
      		if (e.field == 'DEPT_NAME'||e.field == 'PERSON_NUMB') {
      			return false;
      		}
		} ,
    		edit: function(editor, e) {	
				var fieldName = e.field;
				var BUSI_SHARE_I =  '0';
				var WORKER_COMPEN_I ='0';
				var txtWorkTime = colData[0].DAY_WORK_TIME;
				var txtEmpRate =colData[0].EMPLOY_RATE;	
				var gsIncRule =	colData[0].INC_CALCU_RULE;
				var param = Ext.getCmp('searchForm').getValues();
				var date = new Date(e.record.data.DUTY_YYYYMMDD);
				var year = date.getFullYear();
				var mon = date.getMonth() + 1;
				var dateString = year + (mon > 9 ? mon : '0' + mon);
		
		 if (fieldName == 'DUTY_YYYYMMDD') { 
			 	console.log(e.record.data);
			 if(dateString != param.PAY_YYYYMM){
				 Ext.Msg.alert(Msg.sMB099,"근무일자는 해당 급여년월과 동일해야 합니다.")
				 e.record.set("DUTY_YYYYMMDD",e.originalValue);
			     return false;     
			 }
	 	 }else if (fieldName == 'WAGES_STD_I') {  //기본급
	 		
	 		var Wages_I = e.record.data.WAGES_STD_I;
            var Amount1 = e.record.data.AMOUNT_I_01;//연장
            var Amount2 = e.record.data.AMOUNT_I_02;//야근수당
            //지급액
            SUPP_TOTAL_I = Wages_I + Amount1 + Amount2;
            e.record.set("SUPP_TOTAL_I",SUPP_TOTAL_I);
            //비과세금액
            TAX_EXEMPTION_I= Amount1 + Amount2;
            e.record.set("TAX_EXEMPTION_I",TAX_EXEMPTION_I);
            //지급액
            var SuppI   = e.record.data.SUPP_TOTAL_I;
            //비과세금액
            var TaxExeI =  e.record.data.TAX_EXEMPTION_I;
            //소득세
	        var InTaxI = (SuppI - TaxExeI - 100000) * 0.027;
	       	 if (InTaxI < 0) {
            		InTaxI = 0;
	 	        }
            	if(gsIncRule == "1"){ //0.70
               		 if (InTaxI < 1000){ 
                        InTaxI = 0;   	            
                   	}
                 }
	        IN_TAX_I = InTaxI;
	        e.record.set("IN_TAX_I",IN_TAX_I);
            //주민세
            LOCAL_TAX_I = InTaxI * 0.1;
            e.record.set("LOCAL_TAX_I",LOCAL_TAX_I);
            var localTaxI = e.record.data.LOCAL_TAX_I;
            //고용보험
             HIR_INSUR_I = SuppI * txtEmpRate * 0.01;
             HIR_INSUR_I = Math.abs(Math.floor(Math.abs(SuppI * txtEmpRate * 0.01) * 0.1, 1)) * 10;  //Fix(Round(Fix(SuppI * (fnCDbl(Trim(txtEmpRate.value)) * 0.01)) * 0.1, 1)) * 10
             e.record.set("HIR_INSUR_I",HIR_INSUR_I);
             
             var HireInsurI = e.record.data.HIR_INSUR_I;  
            //실지급액
            REAL_AMOUNT_I = Math.round(SuppI - (parseInt(InTaxI) + parseInt(localTaxI) + parseInt(HireInsurI)));
            e.record.set("REAL_AMOUNT_I",REAL_AMOUNT_I);

		 }else if (fieldName == 'TAX_EXEMPTION_I'){//비과세금액
	        var Duty_time1 = 0;
	        var Duty_time2 = 0;
	        var Duty_minu1 = 0;
	        var Duty_minu2 = 0;
	        
	        var Wages_I     = 0;    //기본급
	        var WorkTime    = 0;    //하루근무시간
	        var Amount1     = 0;    //연장수당
	        var Amount2     = 0;    //야근수당
	            
	        //지급액
	        var SuppI   =  e.record.data.SUPP_TOTAL_I;
	        //비과세금액
	        TAX_EXEMPTION_I= Amount1 + Amount2;
            e.record.set("TAX_EXEMPTION_I",TAX_EXEMPTION_I);
            
	        var TaxExeI =  e.record.data.TAX_EXEMPTION_I;        
	        //소득세
	        var InTaxI = (SuppI - TaxExeI - 100000) * 0.027;
	        
	        if (InTaxI < 0) {
	            InTaxI = 0 
	        }
	        if (gsIncRule == "1") {
	            if (fnCDbl(InTaxI) < 1000){
	                InTaxI = 0   	            
	        }
		    }
	        
	        IN_TAX_I  = InTaxI;
	        e.record.set("IN_TAX_I",IN_TAX_I);
	        //주민세
	        LOCAL_TAX_I = InTaxI * 0.1;
	        e.record.set("LOCAL_TAX_I",LOCAL_TAX_I);
	        
	        var localTaxI =  e.record.data.LOCAL_TAX_I;
	        
	        //고용보험
	        HIR_INSUR_I = SuppI * txtEmpRate * 0.01;
	        e.record.set("HIR_INSUR_I",HIR_INSUR_I);
            var HireInsurI = e.record.data.HIR_INSUR_I;
         	//실지급액
         	REAL_AMOUNT_I = SuppI - (parseInt(InTaxI )+ parseInt(localTaxI) + parseInt(HireInsurI));
         	e.record.set("REAL_AMOUNT_I",REAL_AMOUNT_I);
         	
		 } else if (fieldName == 'IN_TAX_I'||fieldName == 'LOCAL_TAX_I'){
			   var Duty_time1 = 0;
	           var Duty_time2 = 0;
	           var Duty_minu1 = 0;
	           var Duty_minu2 = 0;
		        
	           var Wages_I     = 0;   //기본급
	           var WorkTime    = 0;    //하루근무시간
	           var Amount1     = 0;    //연장수당
	           var Amount2     = 0;    //야근수당
		        
	            //기본급
	            Wages_I = e.record.data.WAGES_STD_I;
	            Amount1 = e.record.data.AMOUNT_I_01;
	            Amount2 = e.record.data.AMOUNT_I_02;
	            //지급액
	            SUPP_TOTAL_I = Wages_I + Amount1 + Amount2;
	            e.record.set("SUPP_TOTAL_I",SUPP_TOTAL_I);
	            //비과세금액
	             TAX_EXEMPTION_I = Amount1 + Amount2;
	             e.record.set("TAX_EXEMPTION_I",TAX_EXEMPTION_I);
	            //지급액
	            var SuppI   = e.record.data.SUPP_TOTAL_I;
	            //비과세금액
	            var TaxExeI = e.record.data.TAX_EXEMPTION_I;
	            //소득세
		        var InTaxI = e.record.data.IN_TAX_I;
	            var localTaxI = e.record.data.LOCAL_TAX_I;  
	            var HireInsurI = e.record.data.HIR_INSUR_I;
	            //실지급액
	            REAL_AMOUNT_I = SuppI - (parseInt(InTaxI) + parseInt(localTaxI) + parseInt(HireInsurI));
	            e.record.set("REAL_AMOUNT_I",REAL_AMOUNT_I);
		 } else if (fieldName == 'AMOUNT_I_01'){ //연장수당   
	            var Duty_time1 = 0
	            var Duty_time2 = 0
	            var Duty_minu1 = 0
	            var Duty_minu2 = 0
		        
	            var Wages_I     = 0    //기본급
	            var WorkTime    = 0    //'하루근무시간
	            var Amount1     = 0    //'연장수당
	            var Amount2     = 0    //'야근수당
		        
	            //'기본급
	            Wages_I = e.record.data.WAGES_STD_I;
	            Amount1 = e.record.data.AMOUNT_I_01;
	            Amount2 = e.record.data.AMOUNT_I_02;
		        
	            //'지급액
	            SUPP_TOTAL_I = Wages_I + Amount1 + Amount2
	            e.record.set("SUPP_TOTAL_I",SUPP_TOTAL_I);
	            //'비과세금액
	            TAX_EXEMPTION_I = Amount1 + Amount2
	            e.record.set("TAX_EXEMPTION_I",TAX_EXEMPTION_I);
	            //'지급액
	            SuppI   = e.record.data.SUPP_TOTAL_I;
		        
	           // '비과세금액
	            TaxExeI = e.record.data.TAX_EXEMPTION_I;
		        
	            //'소득세
		        InTaxI = (SuppI - TaxExeI - 100000) * 0.027;
		        
		        if (InTaxI < 0) {
		            InTaxI = 0
		        }
		        
	            if (gsIncRule = "1"){  
	                if (InTaxI < 1000 ){
	                    InTaxI = 0    	            
	            	}
		 		}
		        
		        IN_TAX_I = InTaxI;
		        e.record.set("IN_TAX_I",IN_TAX_I);
	            //'주민세
	            LOCAL_TAX_I = InTaxI * 0.1;
	            e.record.set("LOCAL_TAX_I",LOCAL_TAX_I);
	            localTaxI = e.record.data.LOCAL_TAX_I;
		        
	            //'고용보험
	            HIR_INSUR_I = SuppI * (txtEmpRate * 0.01)
	            
	            HIR_INSUR_ =  Math.abs(Math.floor(Math.abs(SuppI * txtEmpRate * 0.01) * 0.1, 1)) * 10;
	                        //Fix(Round(Fix(SuppI * (fnCDbl(Trim(txtEmpRate.value)) * 0.01)) * 0.1, 1)) * 10
	            HireInsurI = e.record.data.HIR_INSUR_I;
	            e.record.set("HIR_INSUR_I",HIR_INSUR_I);
	            //'실지급액
	            REAL_AMOUNT_I = SuppI - (parseInt(InTaxI) + parseInt(localTaxI) + parseInt(HireInsurI));
	            e.record.set("REAL_AMOUNT_I",REAL_AMOUNT_I);
		 
       	 } else if (fieldName == 'AMOUNT_I_02'){ //야간수당 
 
            var Duty_time1 = 0;
            var Duty_time2 = 0;
            var Duty_minu1 = 0;
            var Duty_minu2 = 0;
	        
            var Wages_I     = 0;    //'기본급
            var WorkTime    = 0;    //'하루근무시간
            var Amount1     = 0;   // '연장수당
            var Amount2     = 0;   // '야근수당
	        
            //'기본급
            Wages_I = e.record.data.WAGES_STD_I;//기본급
            Amount1 = e.record.data.AMOUNT_I_01;//연장수당
            Amount2 = e.record.data.AMOUNT_I_02;//야근수당
	        
            //'지급액
            SUPP_TOTAL_I = Wages_I + Amount1 + Amount2;
            e.record.set("SUPP_TOTAL_I",SUPP_TOTAL_I);
            //'비과세금액
            TAX_EXEMPTION_I = Amount1 + Amount2;
            e.record.set("TAX_EXEMPTION_I",TAX_EXEMPTION_I);
            //'지급액
            SuppI   = e.record.data.SUPP_TOTAL_I;
	        
            //'비과세금액
            TaxExeI = e.record.data.TAX_EXEMPTION_I;
	        
            //'소득세
	        InTaxI = (SuppI - TaxExeI - 100000) * 0.027;
	        
	        if (InTaxI < 0 ){
	            InTaxI = 0
				}
	        
	        if (gsIncRule = "1"){ 
	            if (InTaxI < 1000) {
	                InTaxI = 0    	            
	            }
	        }
	        
	        IN_TAX_I = InTaxI;
	        e.record.set("IN_TAX_I",IN_TAX_I);
            //'주민세
            LOCAL_TAX_I = InTaxI * 0.1;
            LOCAL_TAX_I = e.record.data.LOCAL_TAX_I;
            localTaxI =  e.record.data.LOCAL_TAX_I;
            e.record.set("LOCAL_TAX_I",LOCAL_TAX_I); 
            //'고용보험
            HIR_INSUR_I = SuppI * (txtEmpRate * 0.01);
            HIR_INSUR_I = Math.abs(Math.floor(Math.abs(SuppI * txtEmpRate * 0.01) * 0.1, 1)) * 10; //Fix(Round(Fix(SuppI * (fnCDbl(Trim(txtEmpRate.value)) * 0.01)) * 0.1, 1)) * 10
            e.record.set("HIR_INSUR_I",HIR_INSUR_I);
            HireInsurI = e.record.data.HIR_INSUR_I;
            //'실지급액
            REAL_AMOUNT_I = SuppI - (parseInt(InTaxI) + parseInt(localTaxI) +parseInt( HireInsurI));
            e.record.set("REAL_AMOUNT_I",REAL_AMOUNT_I);  
            
      } else if (fieldName == 'SUPP_TOTAL_I'){ //지급액
       	  
       		 var Wages_I     = 0;    //'기본급
             var Amount1     = 0;   // '연장수당
             var Amount2     = 0; 
       		 //'기본급
             Wages_I = e.record.data.WAGES_STD_I;//기본급
             Amount1 = e.record.data.AMOUNT_I_01;//연장수당
             Amount2 = e.record.data.AMOUNT_I_02;//야근수당
 	        
             //'지급액
             SUPP_TOTAL_I = Wages_I + Amount1 + Amount2;
             e.record.set("SUPP_TOTAL_I",SUPP_TOTAL_I);
       	 
      } else if (fieldName == 'TAX_EXEMPTION_I'){ //비과세금액
  
        var Duty_time1 = 0
        var Duty_time2 = 0
        var Duty_minu1 = 0
        var Duty_minu2 = 0
        
        var Wages_I     = 0    //'기본급
        var WorkTime    = 0    //'하루근무시간
        var Amount1     = 0   // '연장수당
        var Amount2     = 0   // '야근수당
            
        //'지급액
        var SuppI   = e.record.data.SUPP_TOTAL_I;
        
        //'비과세금액
        var TaxExeI = TAX_EXEMPTION_I;
        	        
        //'소득세
        var InTaxI = (SuppI - TaxExeI - 100000) * 0.027;
        
        if (InTaxI < 0){
            InTaxI = 0
        }
        
        if (gsIncRule = "1") {
            if (InTaxI < 1000){
                InTaxI = 0    	            
            }
        }
        
        IN_TAX_I = InTaxI;
        e.record.set("IN_TAX_I",IN_TAX_I);
        //'주민세
        LOCAL_TAX_I = InTaxI * 0.1
        e.record.set("LOCAL_TAX_I",LOCAL_TAX_I); 
        localTaxI = e.record.data.LOCAL_TAX_I;
        
        //'고용보험
        HIR_INSUR_I = SuppI * (txtEmpRate * 0.01);
        e.record.set("HIR_INSUR_I",HIR_INSUR_I);
       
        var HireInsurI = e.record.data.HIR_INSUR_I;
        //'실지급액
        REAL_AMOUNT_I= SuppI - (parseInt(InTaxI) + parseInt(localTaxI) + parseInt(HireInsurI));
        e.record.set("REAL_AMOUNT_I",REAL_AMOUNT_I);
   	   }  	
		 if (e.originalValue != e.value) {
					UniAppManager.setToolbarButtons('save', true);
				} 
		    	
		 },//edit
					 selectionchange: function(grid, selNodes ){
		             UniAppManager.setToolbarButtons('delete', true);
		             }
		        
          } //listeners
    });
   
	/**
     * Master Grid3 정의(Grid Panel)
     * @type 
     */
    Unilite.Main( {
		borderItems:[ 
	 		 masterGrid,
			 panelSearch
		],
		id: 'ham810ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);			
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('deleteAll',true);
		},
		onNewDataButtonDown : function() {			
			masterGrid.createRow({ 'DEPT_NAME' : panelSearch.getValue('DEPT_CODE2'), SUPP_DATE : Ext.getCmp('SUPP_DATE').rawValue,
				                   PAY_YYYYMM : Ext.getCmp('PAY_YYYYMM').rawValue, 'PERSON_NUMB' : panelSearch.getValue('PERSON_NUMB')},'',0);
			//masterGrid.createRow({ PAY_YYYYMM : Ext.getCmp('PAY_YYYYMM').rawValue},'',0)
			UniAppManager.setToolbarButtons('save', true);
			// 'DIV_CODE': panelSearch.getValue('DIV_CODE')
		},
		onSaveDataButtonDown: function() {
			if(masterGrid.getStore().isDirty()) {
				masterGrid.getStore().saveStore();	
			}
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function()	{		
			var detailform = panelSearch.getForm();
			if (detailform.isValid()) {		
				directMasterStore.loadStoreRecords();				
			} else {
				var invalid = panelSearch.getForm().getFields()
						.filterBy(function(field) {
							return !field.validate();
						});

				if (invalid.length > 0) {
					r = false;
					var labelText = ''

					if (Ext
							.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']
								+ '은(는)';
					} else if (Ext
							.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']
								+ '은(는)';
					}

					// Ext.Msg.alert(타이틀, 표시문구); 
					Ext.Msg.alert('확인', Msg.sMB083);
					// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
					invalid.items[0].focus();
				}
			}
	
		},	
		onDeleteDataButtonDown : function()	{
			if(confirm(Msg.sMB062)) {
				masterGrid.deleteSelectedRow();
				UniAppManager.setToolbarButtons('save',true);	
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		
		onDeleteAllButtonDown : function() {
			 Ext.Msg.confirm('삭제', '전체행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					directMasterStore.removeAll();
					masterGrid.getStore().syncAll({						
							success: function(response) {
								data = Ext.decode(response.responseText);
								console.log(data);
								//Ext.Msg.alert('완료','전체삭제가 완료되었습니다.');
								UniAppManager.setToolbarButtons('save',false);
								UniAppManager.setToolbarButtons('deleteAll',false);
				            },
				            failure: function(response) {
				            	console.log(response);
								Ext.Msg.alert('실패', response.statusText);
				            }
					});
				}
			}); 			
		}
	});

};


</script>
