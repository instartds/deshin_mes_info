<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hpa620ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> <!-- 입력경로 -->	
</t:appConfig>

<script type="text/javascript" >
function appMain() {	
	var result = ${result};
	
	var tab01ComboStore1 = Ext.create('Ext.data.Store', {
	    fields: ['value', 'name'],
	    data : [
	        {'value':'1', 'name':'2년전'},
	        {'value':'2', 'name':'전년도'},
	        {'value':'3', 'name':'당년도'}
	    ]
	});
	
	var panelSearch = Unilite.createForm('searchForm', {		
		disabled :false
    ,	flex:1        
    ,	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	,	items: [
		{
			xtype: 'radiogroup',		            		
			readOnly :true,
			hidden: true,
			fieldLabel: '연차계산방식',	 
			colspan: 7,
			id: 'yearCalc',
			items : [{
				boxLabel: '회계연도기준',
				width:110 ,
				name: 'YEAR_TYPE', 
				inputValue: '1',
				readOnly :true,
				checked: true
			}, {
				boxLabel: '입사일 기준', 
				width:110 ,
				name: 'YEAR_TYPE' , 
				inputValue: '2',
				hidden: true,
				readOnly :true
			} 
//			{
//				boxLabel: '<t:message code="system.label.human.halfyearbase" default="상하반기 기준"/>',
//				width:110 , 
//				name: 'YEAR_TYPE' ,
//				inputValue: '3'
//			}
			],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.YEAR_TYPE == "1"){
                        Ext.getCmp('hidefield1').show();
						Ext.getCmp('hidefield2').hide();
						Ext.getCmp('hidefield3').hide();
					}
//					else if(newValue.YEAR_TYPE == "2"){
//						Ext.getCmp('hidefield1').hide();
//                        Ext.getCmp('hidefield2').show();
//						Ext.getCmp('hidefield3').hide();
//					}
//					else if(newValue.YEAR_TYPE == "3"){
//						Ext.getCmp('hidefield1').hide();
//						Ext.getCmp('hidefield2').hide();
//						Ext.getCmp('hidefield3').show();
//					}
				}
			}
        },{
        	xtype: 'container',
        	layout: {type: 'uniTable', columns: 1},
        	id: 'hidefield1',
        	items:[{
				fieldLabel: '생성기준년도',
				id: 'YEAR_YYYY',
				xtype: 'uniYearField',
				name: 'YEAR_YYYY',
//				value: Ext.Date.format(new Date(), 'Y'),
				allowBlank: true,
				regex: /^[0-9]{4,4}$/,
	// 				maskRe: /^[0-9]{4,4}$/,
	// 				invalidText:
				listeners:{
					blur: function(){
						if(Ext.getCmp('yearCalc').getChecked()[0].inputValue != "1") return false;
						if(this.isValid()){
							loadStdYyyy('blur');
						}else{
							alert('<t:message code="system.message.human.message073" default="입력 양식이 옳지 않습니다."/>');								
						}		
					}
				}
			},{
	    		xtype: 'container',
	    		width: 350,
	    		layout: {type: 'hbox'},
	    		items:[{
		    	   xtype: 'uniDateRangefield',
		    	   fieldLabel: '생성기준기간',
		    	   items:[{        		    	   	
						id: 'YEAR_DT_FR',
						name: 'YEAR_DT_FR',
						xtype: 'uniDatefield',
						width: 100,
						fieldStyle: "text-align:center;",
						readOnly: true		       					
					},{
					  	xtype: 'label',
					  	text: '~',
					  	style: 'margin-top: 3px!important;'
					},{
						id: 'YEAR_DT_TO',
						name: 'YEAR_DT_TO',
						xtype: 'uniDatefield',
						width: 110,
						fieldStyle: "text-align:center;",
						readOnly: true
					}]
		       }]	        	
			},{
	    		xtype: 'container',
	    		layout: {type: 'hbox'},
	    		width: 350,
	    		items:[{
		    	   xtype: 'uniDateRangefield',
		    	   fieldLabel: '연차사용기간',
		    	   items:[{        		    	   	
						id: 'YEAR_USE_DT_FR',
						name: 'YEAR_USE_DT_FR',
						xtype: 'uniDatefield',
						width: 100,
						fieldStyle: "text-align:center;",
						readOnly: true		       					
					},{
					  	xtype: 'label',
					  	text: '~',
					  	style: 'margin-top: 3px!important;'
					},{
						id: 'YEAR_USE_DT_TO',
						name: 'YEAR_USE_DT_TO',
						xtype: 'uniDatefield',
						width: 110,
						fieldStyle: "text-align:center;",
						readOnly: true
					}]
		       }]	        	
			},{
					fieldLabel: '연차사용년도',
					name: 'YYYY',					
					xtype: 'uniYearField',
					readOnly: true
				}        	
        	]
        },{
        	xtype: 'container',
        	layout: {type: 'uniTable', columns: 1},
        	id: 'hidefield2',
        	items:[{
        		xtype: 'uniMonthfield',
        		name: 'BASE_YYYY_MM',
        		allowBlank: true,
        		fieldLabel: '<t:message code="system.label.human.applyyymm" default="기준년월"/>',
        		listeners:{
        			change: function(field, newValue, oldValue, eOpts){
//        				panelSearch.setValue('BASE_YYYY_MM', UniDate.get('today'));			
						var frDate = UniDate.add(newValue, {years: -1});
						var frDate = UniDate.add(frDate, {months: +1});
						panelSearch.setValue('BASE_DATE_FR', frDate);
						panelSearch.setValue('BASE_DATE_TO', newValue);
//						panelSearch.setValue('YEAR_USE_DT_FR', UniDate.add(UniDate.extParseDate(UniDate.get('startOfYear')), {years: dffYear}));
//						panelSearch.setValue('YEAR_USE_DT_TO', UniDate.add(UniDate.extParseDate(UniDate.get('endOfYear')), {years: dffYear}));        			
        			}        		        		
        		}
        	},{
	        	fieldLabel: '<t:message code="system.label.accnt.period" default="기간"/>', 
				xtype: 'uniMonthRangefield',   
				startFieldName: 'BASE_DATE_FR',
				endFieldName: 'BASE_DATE_TO',
				startDD: 'first',
				endDD: 'last',
//				startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
				allowBlank: true,
				readOnly: true
	        }]	
        },{        	
        	xtype: 'container',
        	layout: {type: 'uniTable', columns: 1},        	
        	id: 'hidefield3',
        	items:[{				
				xtype: 'container',
				layout: {type: 'uniTable', columns: 3},
				items: [{
					xtype: 'radiogroup',
					fieldLabel:'<t:message code="system.label.human.halfyeargubun" default="상하반기 구분"/>',
					id: 'YEAR_HALF',
					colspan:3,
					items: [{
						boxLabel: '<t:message code="system.label.human.firsthalfyear" default="상반기"/>',
						name: 'YEAR_HALF',
						width: 110,
						inputValue: '1',
						checked: true
					}, {
						boxLabel: '<t:message code="system.label.human.secondhalfyear" default="하반기"/>',
						name: 'YEAR_HALF',
						width: 110,
						inputValue: '2'
					}]
				},{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 5},
					colspan: 7,
						items: [{
						fieldLabel: '<t:message code="system.label.human.firsthalfyear" default="상반기"/>',						
						name: 'YEAR_STD_FR_YYYY', 
						xtype: 'combo',
						store: tab01ComboStore1,
						queryMode: 'local',
						displayField: 'name',
						valueField: 'value',
						width: 180
					},{
						xtype: 'uniTextfield',
						name:'YEAR_STD_FR_MM',
						fieldStyle: 'text-align:left',
						suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
						width:50,
						padding: '0 0 0 10',
						enforceMaxLength: true,
						maxLength: 2,				
						listeners: {
							blur: function(field) {	
								newValue = field.getValue();
								if(Ext.isEmpty(newValue)) return false;
								if(isNaN(newValue)){
									alert('<t:message code="system.message.human.message046" default="숫자만 입력 가능합니다."/>');
									field.setValue('');
									return false;
								}
								if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
									alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
									field.setValue('');
									return false;
								}						
								if(newValue.length == 1){
									field.setValue('0' + newValue);													
								}					
							}
						}
					},{
						xtype:  'displayfield', 
						value:'&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;'
					},{
						name: 'YEAR_STD_TO_YYYY', 
						xtype: 'combo',
						store: tab01ComboStore1,
						queryMode: 'local',
						displayField: 'name',
						valueField: 'value',
						width: 85
					},{
						xtype: 'uniTextfield',
						name:'YEAR_STD_TO_MM',
						fieldLabel: '',
						fieldStyle: 'text-align:left',
						suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
						padding: '0 0 0 10',
						width:50,
						enforceMaxLength: true,
						maxLength: 2,
						listeners: {
							blur: function(field) {	
								newValue = field.getValue();
								if(Ext.isEmpty(newValue)) return false;
								if(isNaN(newValue)){
									alert('<t:message code="system.message.human.message046" default="숫자만 입력 가능합니다."/>');
									field.setValue('');
									return false;
								}
								if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
									alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
									field.setValue('');
									return false;
								}						
								if(newValue.length == 1){
									field.setValue('0' + newValue);													
								}					
							}
						}
					}]
				}]
			},{				
				xtype: 'container',
				layout: {type: 'uniTable', columns: 5},
				items: [{
					fieldLabel: '<t:message code="system.label.human.secondhalfyear" default="하반기"/>',					
					name: 'YEAR_STD_FR_YYYY_2', 
					xtype: 'combo',
					store: tab01ComboStore1,
					queryMode: 'local',
					displayField: 'name',
					valueField: 'value',
					width: 180
				},{
					xtype: 'uniTextfield',
					name:'YEAR_STD_FR_MM_2',
//					fieldLabel: '<t:message code="system.label.human.secondhalfyear" default="하반기"/>',
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
					padding: '0 0 0 10',
					width:50,
					enforceMaxLength: true,
					maxLength: 2,	
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력 가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
								alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}					
						}
					}
				},{
					xtype:  'displayfield', 
					value:'&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;'
				},{
					name: 'YEAR_STD_TO_YYYY_2', 
					xtype: 'combo',
					store: tab01ComboStore1,
					queryMode: 'local',
					displayField: 'name',
					valueField: 'value',
					width: 85
				},{
					xtype: 'uniTextfield',
					name:'YEAR_STD_TO_MM_2',
					fieldLabel: '',
					fieldStyle: 'text-align:left',
					suffixTpl: '<t:message code="system.label.human.month" default="월"/>',
					padding: '0 0 0 10',
					width:50,
					enforceMaxLength: true,
					maxLength: 2,
					listeners: {
						blur: function(field) {	
							newValue = field.getValue();
							if(Ext.isEmpty(newValue)) return false;
							if(isNaN(newValue)){
								alert('<t:message code="system.message.human.message046" default="숫자만 입력 가능합니다."/>');
								field.setValue('');
								return false;
							}
							if(parseInt(newValue) < 1 || parseInt(newValue) >12){						
								alert('<t:message code="system.message.human.message075" default="정확한 월을 입력하십시오."/>');
								field.setValue('');
								return false;
							}						
							if(newValue.length == 1){
								field.setValue('0' + newValue);													
							}
						}
					}
				}]
			}]	
        },{
			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},Unilite.treePopup('DEPTTREE',{
            fieldLabel: '부서',
            valueFieldName:'DEPT',
            textFieldName:'DEPT_NAME' ,
            valuesName:'DEPTS' ,
            DBvalueFieldName:'TREE_CODE',
            DBtextFieldName:'TREE_NAME',
            selectChildren:true,
            textFieldWidth:89,
            validateBlank:true,
            width:300,
            autoPopup:true,
            useLike:true,
            listeners: {
//                'onValueFieldChange': function(field, newValue, oldValue  ){
//                      panelResult.setValue('DEPT',newValue);
//                },
//                'onTextFieldChange':  function( field, newValue, oldValue  ){
//                      panelResult.setValue('DEPT_NAME',newValue);
//                },
//                'onValuesChange':  function( field, records){
//                      var tagfield = panelResult.getField('DEPTS') ;
//                      tagfield.setStoreData(records)
//                }
            }
        }),{
            fieldLabel: '급여지급방식',
            name: 'PAY_CODE',
            xtype:'uniCombobox',
            comboType:'AU',
            comboCode:'H028'                
        },{
            fieldLabel: '지급차수',
            name: 'PAY_PROV_FLAG',
            xtype:'uniCombobox',
            comboType:'AU',
            comboCode:'H031'                
        },Unilite.popup('Employee', { 
            fieldLabel: '사원', 
            valueFieldName: 'PERSON_NUMB',
            textFieldName: 'NAME',
            autoPopup:true,
            listeners: {
                onSelected: {
                    fn: function(records, type) {

                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('PERSON_NUMB', '');
                    panelSearch.setValue('NAME', '');
                },
                applyextparam: function(popup){                         
                
                }
            }
        }),{
        	fieldLabel: ' ',
        	name: 'RETR_YN',
			xtype: 'checkbox',
			//labelWidth: 200,
			boxLabel: '당해년도 퇴직자 포함'
        },{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'vbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[{
	    		xtype: 'button',
	    		text: '<t:message code="system.label.human.execute" default="실행"/>',
	    		width: 100,
	    		handler: function(){		    			
		        	if(!panelSearch.setAllFieldsReadOnly(true)){
			    		return false;
			    	}
			    	var param = panelSearch.getValues();
			    	param.BASE_DATE_FR = panelSearch.getField('BASE_DATE_FR').getStartDate();
			    	param.BASE_DATE_TO = panelSearch.getField('BASE_DATE_TO').getEndDate();
			    	param.DEPT         = panelSearch.getValue('DEPT');
			    	param.DEPT_NAME    = panelSearch.getValue('DEPT_NAME');
			    	param.PAY_CODE     = panelSearch.getValue('PAY_CODE');
			    	param.PAY_PROV_FLAG= panelSearch.getValue('PAY_PROV_FLAG');
			    	param.PERSON_NUMB  = panelSearch.getValue('PERSON_NUMB');
			    	param.NAME         = panelSearch.getValue('NAME');
			    	param.RETR_YN		= (panelSearch.getValue('RETR_YN') ? 'Y' : 'N');
			    	
			    	if(Ext.getCmp('yearCalc').getChecked()[0].inputValue == "2"){
			    		param.YEAR_USE_DT_FR = UniDate.getDbDateStr(panelSearch.getValue('BASE_YYYY_MM')).substring(0, 4) + '0101';
			    		param.YEAR_USE_DT_TO = UniDate.getDbDateStr(panelSearch.getValue('BASE_YYYY_MM')).substring(0, 4) + '1231';
			    	}else if(Ext.getCmp('yearCalc').getChecked()[0].inputValue == "3"){//상하반기 기준일시
			    		var frYear = new Date().getFullYear();
			    		var toYear = new Date().getFullYear();			    		
			    		if(Ext.getCmp('YEAR_HALF').getChecked()[0].inputValue == "1"){	//상반기
			    			if(panelSearch.getValue('YEAR_STD_FR_YYYY') == "1"){	//2년전
			    				frYear = 	parseInt(frYear) - 2;
			    			}else if(panelSearch.getValue('YEAR_STD_FR_YYYY') == "2"){//전년도
			    				frYear = 	parseInt(frYear) - 1;
			    			}else{//당년도
			    			
			    			}			    			
			    			
			    			if(panelSearch.getValue('YEAR_STD_TO_YYYY') == "1"){	//2년전
			    				toYear = 	parseInt(toYear) - 2;
			    			}else if(panelSearch.getValue('YEAR_STD_TO_YYYY') == "2"){//전년도
			    				toYear = 	parseInt(toYear) - 1;
			    			}else{//당년도
			    			
			    			}			    			
			    			param.YEAR_DATE_FR = frYear + panelSearch.getValue('YEAR_STD_FR_MM') + '01';
			    			var lastDate = new Date(toYear, panelSearch.getValue('YEAR_STD_TO_MM'), 0).getDate();			    			
			    			param.YEAR_DATE_TO = toYear + panelSearch.getValue('YEAR_STD_TO_MM') + lastDate;
			    			var nowDate = new Date().getFullYear() + panelSearch.getValue('YEAR_STD_TO_MM') + lastDate;
			    			param.DUTY_YYYY = UniDate.getDbDateStr(UniDate.add(UniDate.extParseDate(nowDate), {months: +1})).substring(0, 6);
//			    			alert(param.YEAR_YYYY)
			    		}else{	//하반기
			    			if(panelSearch.getValue('YEAR_STD_FR_YYYY_2') == "1"){	//2년전
			    				frYear = 	parseInt(frYear) - 2;
			    			}else if(panelSearch.getValue('YEAR_STD_FR_YYYY_2') == "2"){//전년도
			    				frYear = 	parseInt(frYear) - 1;
			    			}else{//당년도
			    			
			    			}
			    						    			
			    			if(panelSearch.getValue('YEAR_STD_TO_YYYY_2') == "1"){	//2년전
			    				toYear = 	parseInt(toYear) - 2;
			    			}else if(panelSearch.getValue('YEAR_STD_TO_YYYY_2') == "2"){//전년도
			    				toYear = 	parseInt(toYear) - 1;
			    			}else{//당년도
			    			
			    			}
			    			param.YEAR_DATE_FR = frYear + panelSearch.getValue('YEAR_STD_FR_MM_2') + '01';
			    			var lastDate = new Date(toYear, panelSearch.getValue('YEAR_STD_TO_MM_2'), 0).getDate();
			    			param.YEAR_DATE_TO = toYear + panelSearch.getValue('YEAR_STD_TO_MM_2') + lastDate;
			    			var nowDate = new Date().getFullYear() + panelSearch.getValue('YEAR_STD_TO_MM_2') + lastDate;
			    			param.DUTY_YYYY = UniDate.getDbDateStr(UniDate.add(UniDate.extParseDate(nowDate), {months: +1})).substring(0, 6);
//			    			alert(param.YEAR_YYYY)
			    		}
//			    		alert(param.YEAR_DATE_FR + '\n' +param.YEAR_DATE_TO);
			    	}			    	
					Ext.getBody().mask('<t:message code="system.label.human.loading" default="로딩중..."/>','loading-indicator');
					hpa620ukrService.yearCheck(param, function(provider, response)	{
						if(provider != 0){
							if(confirm('이미 생성된 연차가 있습니다. 다시 생성하시겠습니까?')){
								hpa620ukrService.spStart(param, function(provider, response)	{
									if(provider){
										UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
									}
									Ext.getBody().unmask();
								});
							}else{
								Ext.getBody().unmask();
							}
						}else{
							hpa620ukrService.spStart(param, function(provider, response) {
                            if(provider){
                                    UniAppManager.updateStatus('<t:message code="system.message.human.message007" default="저장되었습니다."/>');
                                }
                                Ext.getBody().unmask();
                            });
						}
					});			
	    		}
	    	}]
	    }],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   	   			if(invalid.length > 0) {
					r=false;
	  				var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   				}
			   		alert(labelText+'<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});
	
	// 프로시져 실행
	function runProc() {		
		var form = panelSearch.getForm();
		if (form.isValid()) {
			//Ajax
			var param= Ext.getCmp('searchForm').getValues();		
					
				Ext.Ajax.on("beforerequest", function(){
					Ext.getBody().mask('<t:message code="system.label.human.loading" default="로딩중..."/>', 'loading')
			    }, Ext.getBody());
				Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext.getBody());
				Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext.getBody());
				
				Ext.Ajax.request({
					url     : CPATH+'/human/hpa620proc.do',
					params: param,
					success: function(response){
	 					data = Ext.decode(response.responseText);
	 					console.log(data);					
						Ext.Msg.alert('<t:message code="system.label.human.completion" default="완료"/>','<t:message code="system.message.human.message076" default="등록이 완료되었습니다."/>');
					},
					failure: function(response){
						console.log(response);
						Ext.Msg.alert('<t:message code="system.label.human.fail" default="실패"/>', response.statusText);
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
				Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', labelText+'<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
				// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
				invalid.items[0].focus();
			}
		}	
		
    }
	
	// 페이지 로딩시 년도값 초기화
	function loadStdYyyy(check){		
		//if(Ext.getCmp('yearCalc').getChecked()[0].inputValue == "1"){
			var year_yyyy = '';
			var yyyy = '';
			var param = {COMP_CODE: UserInfo.compCode};					
			if(check=='load'){
				yyyy = new Date().getFullYear();	// 년차년도
				hpa620ukrService.selectcaltype(param, function(provider, response)    {
					 Ext.getCmp('yearCalc').setValue({YEAR_TYPE : provider} );
				})
			}else{
				year_yyyy = panelSearch.getValue('YEAR_YYYY');	// 생성년도
			}					
									 					
			// 생성기간과 사용기간의 기준년도를 가져옴 
			var std_fr = result.YEAR_STD_FR_YYYY;	//생성기간
			var std_to = result.YEAR_STD_TO_YYYY;	//생성기간
			var use_fr = result.YEAR_USE_FR_YYYY;	//사용기간
			var use_to = result.YEAR_USE_TO_YYYY;	//사용기간
	
			var std_fr_year = '';
			var std_to_year = '';
			var use_fr_year = '';
			var use_to_year = '';
			
			//  '.월.일'
			var tail1 = "."+ result.YEAR_STD_FR_MM+"."+result.YEAR_STD_FR_DD;
			var tail2 = "."+ result.YEAR_STD_TO_MM+"."+result.YEAR_STD_TO_DD;
			var tail3 = "."+ result.YEAR_USE_FR_MM+"."+result.YEAR_USE_FR_DD;
			var tail4 = "."+ result.YEAR_USE_TO_MM+"."+result.YEAR_USE_TO_DD;
			
			if(check != 'load'){
				if(std_fr == '1'){
					yyyy = Number(year_yyyy) + 2;
				}else if(std_fr == '2'){
					yyyy = Number(year_yyyy) + 1;
				}else if(std_fr == '3'){
					yyyy = Number(year_yyyy);
				}
			}
								
		
			if(std_fr == '1'){	//2년전
				std_fr_year = Number(yyyy) - 2;		 		 			
			}else if(std_fr == '2'){	//전년도
				std_fr_year = Number(yyyy) - 1;		 		 			
			}else if(std_fr == '3'){	//당년
				std_fr_year = Number(yyyy);		 		 			
			}
			
			if(std_to == '1'){	//2년전
				std_to_year = Number(yyyy) - 2;		 		 			
			}else if(std_to == '2'){	//전년도
				std_to_year = Number(yyyy) - 1;		 		 			
			}else if(std_to == '3'){	//당년
				std_to_year = Number(yyyy);		 		 			
			}
			
			if(use_fr == '2'){	//전년도
				use_fr_year = Number(yyyy) - 1;		 		 			
			}else if(use_fr == '3'){	//당년도
				use_fr_year = Number(yyyy);		 		 			
			}else if(use_fr == '4'){	//익년도
				use_fr_year = Number(yyyy) + 1;		 		 			
			}
			
			if(use_to == '2'){	//전년도
				use_to_year = Number(yyyy) - 1;		 		 			
			}else if(use_to == '3'){	//당년도
				use_to_year = Number(yyyy);		 		 			
			}else if(use_to == '4'){	//익년도
				use_to_year = Number(yyyy) + 1;		 		 			
			}
	
			//화면출력
			if(check == 'load'){
				panelSearch.setValue('YEAR_YYYY', std_fr_year);	//생성년도
				panelSearch.setValue('YYYY', yyyy);	//년차년도
			}else{						
				panelSearch.setValue('YYYY', use_fr_year);	//년차년도
			}
			panelSearch.setValue('YEAR_DT_FR', std_fr_year+tail1);	     //생성기간FR
			panelSearch.setValue('YEAR_DT_TO', std_to_year+tail2);	     //생성기간TO
			panelSearch.setValue('YEAR_USE_DT_FR', use_fr_year+tail3);	 //사용기간FR
			panelSearch.setValue('YEAR_USE_DT_TO', use_to_year+tail4);	 //사용기간TO		
			
		//}else if(Ext.getCmp('yearCalc').getChecked()[0].inputValue == "2"){
			panelSearch.setValue('BASE_YYYY_MM', UniDate.get('today'));			
			var frDate = UniDate.add(panelSearch.getValue('BASE_YYYY_MM'), {years: -1});
			var frDate = UniDate.add(frDate, {months: +1});
			panelSearch.setValue('BASE_DATE_FR', frDate);
			panelSearch.setValue('BASE_DATE_TO', panelSearch.getValue('BASE_YYYY_MM'));
//			var baseYYYY = UniDate.getDbDateStr(panelSearch.getValue('BASE_YYYY_MM')).substring(0, 4);
//			var useYYYY = UniDate.getDbDateStr(panelSearch.getValue('BASE_YYYY_MM')).substring(0, 4);
//			var dffYear = parseInt(baseYYYY) - parseInt(useYYYY);			//기준년월에 맞는 년월을 사용년월에 set하기 위해.. 차이나는 년수를 구함.
//			panelSearch.setValue('YEAR_USE_DT_FR', UniDate.add(UniDate.get('startOfYear')));
//			panelSearch.setValue('YEAR_USE_DT_TO', UniDate.add(UniDate.get('endOfYear')));	

		//}else if(Ext.getCmp('yearCalc').getChecked()[0].inputValue == "3"){
			panelSearch.setValue('YEAR_STD_FR_YYYY', result.YEAR_STD_FR_YYYY);	     //상반기 구분 FR
			panelSearch.setValue('YEAR_STD_TO_YYYY', result.YEAR_STD_TO_YYYY);	     //상반기 구분 TO
			panelSearch.setValue('YEAR_STD_FR_YYYY_2', result.YEAR_STD_FR_YYYY_2);	     //하반기 구분 FR
			panelSearch.setValue('YEAR_STD_TO_YYYY_2', result.YEAR_STD_TO_YYYY_2);	     //하반기 구분 TO
			
			panelSearch.setValue('YEAR_STD_FR_MM', result.YEAR_STD_FR_MM);	     //상반기FR
			panelSearch.setValue('YEAR_STD_TO_MM', result.YEAR_STD_TO_MM);	     //상반기TO
			panelSearch.setValue('YEAR_STD_FR_MM_2', result.YEAR_STD_FR_MM_2);	 //하반기FR		
			panelSearch.setValue('YEAR_STD_TO_MM_2', result.YEAR_STD_TO_MM_2);	 //하반기TO		
		//}	
		
		panelSearch.setValue('BASE_YYYY_MM', UniDate.get('today'));           
        var frDate = UniDate.add(panelSearch.getValue('BASE_YYYY_MM'), {years: -1});
        var frDate = UniDate.add(frDate, {months: +1});
        panelSearch.setValue('BASE_DATE_FR', frDate);
        panelSearch.setValue('BASE_DATE_TO', panelSearch.getValue('BASE_YYYY_MM'));
        
        
        
		panelSearch.setValue('YEAR_STD_FR_YYYY', result.YEAR_STD_FR_YYYY);         //상반기 구분 FR
        panelSearch.setValue('YEAR_STD_TO_YYYY', result.YEAR_STD_TO_YYYY);       //상반기 구분 TO
        panelSearch.setValue('YEAR_STD_FR_YYYY_2', result.YEAR_STD_FR_YYYY_2);       //하반기 구분 FR
        panelSearch.setValue('YEAR_STD_TO_YYYY_2', result.YEAR_STD_TO_YYYY_2);       //하반기 구분 TO
        
        panelSearch.setValue('YEAR_STD_FR_MM', result.YEAR_STD_FR_MM);       //상반기FR
        panelSearch.setValue('YEAR_STD_TO_MM', result.YEAR_STD_TO_MM);       //상반기TO
        panelSearch.setValue('YEAR_STD_FR_MM_2', result.YEAR_STD_FR_MM_2);   //하반기FR        
        panelSearch.setValue('YEAR_STD_TO_MM_2', result.YEAR_STD_TO_MM_2);   //하반기TO        
	}
	

    Unilite.Main( {
		items:[panelSearch],
		id  : 'hpa620ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			loadStdYyyy('load');			
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
	         if(Ext.getCmp('yearCalc').getChecked()[0].inputValue == "1"){
                panelSearch.onLoadSelectText('YEAR_YYYY');
             }else if(Ext.getCmp('yearCalc').getChecked()[0].inputValue == "2"){
                panelSearch.onLoadSelectText('BASE_YYYY_MM');
             }if(Ext.getCmp('yearCalc').getChecked()[0].inputValue == "3"){
                panelSearch.onLoadSelectText('YEAR_STD_FR_MM');
             }
			
             setTimeout( function() { 
                 Ext.getCmp('hidefield1').show();
                 Ext.getCmp('hidefield2').hide();
                 Ext.getCmp('hidefield3').hide();
             }, 1 );
            
/* 			if('${yearCalculation}' == "1"){
				panelSearch.onLoadSelectText('YEAR_YYYY');
			}else if('${yearCalculation}' == "2"){
				panelSearch.onLoadSelectText('BASE_YYYY_MM');
			}if('${yearCalculation}' == "3"){
				panelSearch.onLoadSelectText('YEAR_STD_FR_MM');
			} */
			
		},
		onQueryButtonDown : function()	{			
			
			masterGrid1.getStore().loadStoreRecords();
			var viewLocked = masterGrid1.lockedGrid.getView();
			var viewNormal = masterGrid1.normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
