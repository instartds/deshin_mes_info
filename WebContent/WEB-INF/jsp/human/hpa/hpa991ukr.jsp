<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa991ukr"  >
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H157" /> <!-- 신고구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 일괄납부여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B012" /> <!-- 국가코드 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 자사화폐 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createForm('searchForm', {		
		disabled	: false,
    	flex		: 1,
    	layout		: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items		: [{
			fieldLabel	: '신고사업장',
			id			: 'DIV_CODE',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'BILL',
			labelWidth	: 110,
			allowBlank	: false
		},{
			fieldLabel	: '신고구분',
			id			: 'TAX_TYPE',
			name		: 'TAX_TYPE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H157',
			value		: '1',
			labelWidth	: 110,
			allowBlank	: false
		},{
			fieldLabel	: '급여년월',
			id			: 'PAY_YYYYMM',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',                    
			value		: UniDate.get('today'), 
			labelWidth	: 110,                   
			allowBlank	: false
		},{
			fieldLabel	: '귀속년월',
			id			: 'PAY_INCOM_DT',
			xtype		: 'uniMonthfield',
			name		: 'PAY_INCOM_DT',                    
			value		: UniDate.get('today'),     
			labelWidth	: 110,               
			allowBlank	: false
		},{
			fieldLabel	: '지급년월',
			id			: 'SUPP_DATE',
			xtype		: 'uniMonthfield',
			name		: 'SUPP_DATE',                    
			value		: UniDate.get('today'),     
			labelWidth	: 110,               
			allowBlank	: false
		},{
			fieldLabel	: '신고년월',
			id			: 'TAX_YYYYMM',
			xtype		: 'uniMonthfield',
			name		: 'TAX_YYYYMM',                    
			value		: UniDate.get('today'),   
			labelWidth	: 110,                 
			allowBlank	: false
		},{
			fieldLabel	: '작성일자',
			id			: 'CRT_DATE',
			xtype		: 'uniDatefield',
			name		: 'CRT_DATE',                    
			value		: UniDate.get('today'), 
			labelWidth	: 110,                 
			allowBlank	: false
		},{
			fieldLabel	: '홈텍스ID',
			name		: 'USER_ID',
			xtype		: 'uniTextfield',
			labelWidth	: 110,
			allowBlank	: false
		},{
			fieldLabel	: '일괄납부여부',
			name		: 'BATCH_YN', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B010',
			value		: 'N',
			labelWidth	: 110,
			allowBlank	: false
		},{
        	fieldLabel	: '연말정산포함여부',
        	name		: 'YEAR_TAX_FLAG',
			id			: 'YEAR_TAX_FLAG',
			value		: 'Y',
			xtype		: 'checkbox',
			labelWidth	: 110
		},{
    		xtype		: 'button',
    		text		: '자료생성',
    		width		: 100,
			margin		: '0 0 5 120',
    		handler		: function(){
				if(!panelSearch.getInvalidMessage()) {
					return;
				}
				
    			Ext.Msg.show({
    			    title	: '',
    			    msg		: '자료생성을 실행 하시겠습니까?',
    			    buttons	: Ext.Msg.YESNO,
    			    icon	: Ext.Msg.QUESTION,
    			    fn		: function(btn) {
    			        if (btn === 'yes') {
    			        	//runProc();
    			        	createElectronicFilingFIle();
    			        } else if (btn === 'no') {
    			            this.close();
    			        } 
    			    }
    			});
    		}
    	}]
	});
	
			
	function createElectronicFilingFIle() {						
	//var paramForm2= Ext.getCmp('createDataForm2').getValues();		

	var form = panelFileDown;
	form.setValue('DIV_CODE', Ext.getCmp('searchForm').getValue('DIV_CODE'));
	form.setValue('WORK_TYPE', Ext.getCmp('searchForm').getValue('TAX_TYPE'));
	form.setValue('HOMETAX_YYYYMM', Ext.getCmp('searchForm').getValue('TAX_YYYYMM'));
	form.setValue('BELONG_YYYYMM', Ext.getCmp('searchForm').getValue('PAY_INCOM_DT'));
	form.setValue('SUPP_YYYYMM', Ext.getCmp('searchForm').getValue('SUPP_DATE'));
	form.setValue('PAY_YYYYMM', Ext.getCmp('searchForm').getValue('PAY_YYYYMM'));
	form.setValue('WORK_DATE', Ext.getCmp('searchForm').getValue('CRT_DATE'));
	form.setValue('HOMETAX_ID', Ext.getCmp('searchForm').getValue('USER_ID'));
	form.setValue('ALL_YN', Ext.getCmp('searchForm').getValue('BATCH_YN'));
	//form.setValue('YEAR_YN', Ext.getCmp('searchForm').getValue('YEAR_TAX_FLAG'));
	if(Ext.getCmp('searchForm').getValue('YEAR_TAX_FLAG'))	{
		form.setValue('YEAR_YN', "Y");
	} else {
		form.setValue('YEAR_YN', "1");
	} 
	
	var param = form.getValues();
	Ext.getBody().mask('로딩중...','loading-indicator');
					
	hpa991ukrService.checkProcedureExec(param, function(provider, response) {
		if (response.message == 'Server Error'){
			alert(response.where);
		} else {
			if (!Ext.isEmpty(provider)) {                    

				if(provider.RETURN_VALUE == '1'){      

					form.submit({
                        params: param,
                        success:function()  {
                            //Ext.getBody().unmask();
                        },
                        failure: function(form, action){
                            //Ext.getBody().unmask();
                        }
                    });
					
				}else {
					Ext.Msg.alert('실패', '원천징수이행상황신고자료생성을 실패하였습니다.');
					//Ext.getBody().unmask();
				}
			}
		}
	});
	
	Ext.getBody().unmask();
	
	}

	var panelFileDown = Unilite.createForm('FileDownForm', {
		url: CPATH+'/human/createWithholdingFile.do',
		colspan: 2,
		layout: {type: 'uniTable', columns: 1},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true,  
		items:[{
			xtype: 'uniTextfield',
			name: 'DIV_CODE'
		},{
			xtype: 'uniTextfield',
			name: 'WORK_TYPE'
		},{
			xtype: 'uniMonthfield',
			name: 'HOMETAX_YYYYMM'
		},{
			xtype: 'uniMonthfield',
			name: 'BELONG_YYYYMM'
		},{
			xtype: 'uniMonthfield',
			name: 'SUPP_YYYYMM'
		},{
			xtype: 'uniMonthfield',
			name: 'PAY_YYYYMM'
		},{
	 		xtype: 'uniDatefield',
	 		name: 'WORK_DATE'
		},{
	 		xtype: 'uniTextfield',
	 		name: 'HOMETAX_ID'
		},{
	 		xtype: 'uniTextfield',
	 		name: 'ALL_YN'
		},{
	 		xtype: 'uniTextfield',
	 		name: 'YEAR_YN'
		}]
	});

	
	// 프로시져 실행
	function runProc() {		
		var form = panelSearch.getForm();
		if (form.isValid()) {
			//Ajax
			var param= Ext.getCmp('searchForm').getValues();		
					
				Ext.Ajax.on("beforerequest", function(){
					Ext.getBody().mask('로딩중...', 'loading')
			    }, Ext.getBody());
				Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext.getBody());
				Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext.getBody());
				
				Ext.Ajax.request({
					url     : CPATH+'/human/hpa991proc.do',
					params: param,
					success: function(response){
	 					data = Ext.decode(response.responseText);
	 					console.log("data:::",data);
	 					
	 					if(data.RETURN_VALUE == '-1'){
	 						if(data.ERROR_CODE == '55208'){
	 							Ext.Msg.alert('실패', '원친징수이행상황신고서 내역이 없습니다.');
	 						}else if(data.ERROR_CODE == '55207'){
	 							Ext.Msg.alert('실패', '원친징수이행상황신고서 HEADER 내역이 없습니다.');
	 						}else if(data.ERROR_CODE == '55209'){
	 							Ext.Msg.alert('실패', '원친징수이행상황신고서_부표 내역이 없습니다.');
	 						}else{
	 							Ext.Msg.alert('실패', '년월차수당 계산 수행을 실패하였습니다.');
	 						}
	 						
	 					}else if(data.RETURN_VALUE == '1'){
	 						Ext.Msg.alert('성공', '년월차수당 계산을 수행하였습니다.');
	 					}	 					
						
					},
					failure: function(response){
						console.log(response);
						Ext.Msg.alert('실패', response.statusText);
					}
				});
				
		} else {
			var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});
			    	
			if(invalid.length > 0)	{
				r = false;
				var labelText = ''
				    	
				if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
				
				// Ext.Msg.alert(타이틀, 표시문구); 
				Ext.Msg.alert('확인', labelText+Msg.sMB083);
				// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
				invalid.items[0].focus();
			}
		}	
		
    }
	
    Unilite.Main( {
		items	: [ panelSearch ],
		id		: 'hpa991ukrApp',
		
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			//년월차구분 설정
			var store = Ext.getStore('CBS_AU_H157');						
			var selectedModel = store.getRange();
			Ext.each(selectedModel, function(record,i){       
				if (record.data.value == '3'||record.data.value == '4') {							    	
					store.remove(record);							    	  							    	  
				}			       
			});
			var combo = Ext.getCmp('TAX_TYPE');
			console.log("combo",combo);
			combo.bindStore('CBS_AU_H157');
			 
			//초기 버튼 위치 세팅
			panelSearch.onLoadSelectText('DIV_CODE');
		}
	});

};


</script>
    		