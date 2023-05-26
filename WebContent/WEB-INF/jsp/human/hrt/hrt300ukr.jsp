<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hrt300ukr"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	
	var panelSearch = Unilite.createForm('hrt300ukrDetail', {		
		  disabled :false
		, id: 'searchForm'
	    , flex:1        
	    , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	    , items :[{
			fieldLabel: '기준년월',				
			xtype: 'uniMonthfield',
			name: 'STD_DATE',
			id: 'STD_DATE',
			value: new Date(),
			allowBlank: false,
	// 				regex: /^[0-9]{4,4}$/,
	// 				maskRe: /^[0-9]{4,4}$/,
			listeners:{
				blur:{
					fn: function(){
						if(this.isValid()){
							blurChange(this.value);
						}else{
							Ext.Msg.alert('',"입력 양식이 옳지 않습니다.");
							this.reset();								
						}														
					}						
				}
			}
		},{
			fieldLabel: '정산일',
			id: 'BASE_DATE',
			name: 'BASE_DATE',
			xtype: 'uniDatefield',
			value: Ext.Date.format(Ext.Date.getLastDateOfMonth(new Date()),'Y.m.d'),		
			readOnly: true
		},{
			xtype: 'container',
			width: 350,
			layout: {type: 'hbox'},
			items:[
			       {
			    	   xtype: 'uniDateRangefield',
			    	   fieldLabel: '생성기간',
			    	   allowBlank: false,
			    	   items:[
							{        		    	   	
								id: 'PAY_DT_FR',
								name: 'PAY_DATE_FR',
								xtype: 'uniDatefield',
								value: Ext.Date.getFirstDateOfMonth(UniDate.add(new Date(),{months:-2})),
								width: 100,
								readOnly: true,
								allowBlank: false
							},
							{
							  	xtype: 'label',
							  	text: '~',
							  	style: 'margin-top: 3px!important;'
							},
							{
								id: 'PAY_DT_TO',
								name: 'PAY_DATE_TO',
								xtype: 'uniDatefield',
								value: Ext.Date.getLastDateOfMonth(new Date()),
								width: 110,
								allowBlank: false,
								listeners:{
									blur: {
										fn: function(){												
											if(this.isValid()){
												pbyChange('PAY_DT',this.value);
											}else{
												Ext.Msg.alert('',"입력 양식이 옳지 않습니다.");
												this.reset();								
											}
										}
									}
								}
							}
			    	          ]
	    		       }
	    		]	        	
		},{
			xtype: 'container',
			width: 350,
			layout: {type: 'hbox'},
			items:[
			       {
			    	   xtype: 'uniDateRangefield',
			    	   fieldLabel: '상여기간',
			    	   allowBlank: false,
			    	   items:[
							{        		    	   	
								id: 'BONUS_DT_FR',
								name: 'BONUS_DATE_FR',
								xtype: 'uniDatefield',
								value: Ext.Date.getFirstDateOfMonth(UniDate.add(new Date(),{months:-11})),
								width: 100,
								readOnly: true,
								allowBlank: false
							},
							{
							  	xtype: 'label',
							  	text: '~',
							  	style: 'margin-top: 3px!important;'
							},
							{
								id: 'BONUS_DT_TO',
								name: 'BONUS_DATE_TO',
								xtype: 'uniDatefield',
								value: Ext.Date.getLastDateOfMonth(new Date()),
								width: 110,
								allowBlank: false,
								listeners:{
									blur: {
										fn: function(){
											if(this.isValid()){
												pbyChange('BONUS_DT',this.value);
											}else{
												Ext.Msg.alert('',"입력 양식이 옳지 않습니다.");
												this.reset();								
											}												
										}
									}
								}
							}
			    	          ]
	    		       }
	    		]	        	
		},{
			xtype: 'container',
			width: 350,
			layout: {type: 'hbox'},
			items:[
			       {
			    	   xtype: 'uniDateRangefield',
			    	   fieldLabel: '년월차기간',
			    	   allowBlank: false,
			    	   items:[
							{        		    	   	
								id: 'YEAR_DT_FR',
								name: 'YEAR_DATE_FR',
								xtype: 'uniDatefield',
								value: Ext.Date.getFirstDateOfMonth(UniDate.add(new Date(),{months:-11})),
								width: 100,
								readOnly: true,
								allowBlank: false
							},
							{
							  	xtype: 'label',
							  	text: '~',
							  	style: 'margin-top: 3px!important;'
							},
							{
								id: 'YEAR_DT_TO',
								name: 'YEAR_DATE_TO',
								xtype: 'uniDatefield',
								value: Ext.Date.getLastDateOfMonth(new Date()),
								width: 110,
								allowBlank: false,
								listeners:{
									blur: {
										fn: function(){
											if(this.isValid()){
												pbyChange('YEAR_DT',this.value);
											}else{
												Ext.Msg.alert('',"입력 양식이 옳지 않습니다.");
												this.reset();								
											}												
										}
									}
								}
							}
			    	          ]
	    		       }
	    		]	        	
		},{
			fieldLabel: '사업장',
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},
			Unilite.treePopup('DEPTTREE',{
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
                'onValueFieldChange': function(field, newValue, oldValue  ){
//                    	panelResult.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
//                    	panelResult.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),{
			fieldLabel: '지급차수',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031'
		},{
			fieldLabel: '급여지급방식',
			name: 'PAY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028'
		},				
			Unilite.popup('Employee', {
				valueFieldName: 'PERSON_NUMB',
                textFieldName: 'NAME',
				textFieldWidth: 170, 
				validateBlank: false,
				autoPopup: true,
				extParam: {'CUSTOM_TYPE': '3'},
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
                    //popup.setExtParam({'BASE_DT': '00000000'}); 
                }
            }
		}),{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'vbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[{
	    		xtype: 'button',
	    		text: '실행',
	    		width : 100,
	    		handler: function(){
	    			Ext.Msg.show({
	    			    title:'',
	    			    msg: '퇴직추계액계산을 실행합니다.\n퇴직추계액계산을 실행 하시겠습니까?',
	    			    buttons: Ext.Msg.YESNO,
	    			    icon: Ext.Msg.QUESTION,
	    			    fn: function(btn) {
	    			        if (btn === 'yes') {
	    			        	var param = panelSearch.getValues();
								Ext.getBody().mask('로딩중...','loading-indicator');
								hrt300ukrService.spStart(param, function(provider, response)	{						
									if(provider){
										UniAppManager.updateStatus(Msg.sMB011);
									}
									Ext.getBody().unmask();
								});
	    			        } else if (btn === 'no') {
	    			            this.close();
	    			        } 
	    			    }
	    			});
	    		}
	    	}]
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
					url     : CPATH+'/human/hrt300proc.do',
					params: param,
					success: function(response){
	 					data = Ext.decode(response.responseText);
	 					console.log("data:::",data);
	 					
	 					if(data.return_value == '-1'){
// 	 						if(data.ERROR_CODE == '54204'){
// 	 							Ext.Msg.alert('실패', '년월차기준등록을 확인하십시오.');
// 	 						}else if(data.ERROR_CODE == '54220'){
// 	 							Ext.Msg.alert('실패', '해당사원이 존재하지 않습니다.');
// 	 						}else{
// 	 							Ext.Msg.alert('실패', '년월차수당 계산 수행을 실패하였습니다.');
// 	 						}
	 						
	 					}else if(data.return_value == '1'){
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
	
	function blurChange(yymm){
 		/*	정산일 = 기준년월, 말일
 			급여기간 = 기준년월-2, 말일
 			상여기간 = 전년도, 기준년월+1, 1일
 			년월차기간 = 상여기간과 동일 */
		
		Ext.getCmp('PAY_DT_FR').setValue(Ext.Date.format(Ext.Date.getFirstDateOfMonth(UniDate.add(yymm,{months:-2})),'Y.m.d'));
		Ext.getCmp('PAY_DT_TO').setValue(Ext.Date.format(Ext.Date.getLastDateOfMonth(yymm),'Y.m.d'));
		
		Ext.getCmp('BONUS_DT_FR').setValue(Ext.Date.format(Ext.Date.getFirstDateOfMonth(UniDate.add(yymm,{months:-11})),'Y.m.d'));
		Ext.getCmp('BONUS_DT_TO').setValue(Ext.Date.format(Ext.Date.getLastDateOfMonth(yymm),'Y.m.d'));
		
		Ext.getCmp('YEAR_DT_FR').setValue(Ext.Date.format(Ext.Date.getFirstDateOfMonth(UniDate.add(yymm,{months:-11})),'Y.m.d'));
		Ext.getCmp('YEAR_DT_TO').setValue(Ext.Date.format(Ext.Date.getLastDateOfMonth(yymm),'Y.m.d'));
		Ext.getCmp('BASE_DATE').setValue(Ext.Date.format(Ext.Date.getLastDateOfMonth(UniDate.add(yymm)),'Y.m.d'));

				
	}
	
	function pbyChange(id,dt){
		if(id == 'PAY_DT'){
			Ext.getCmp('PAY_DT_FR').setValue(UniDate.add(dt,{months:-3, days:1}));	
		}else if(id == 'BONUS_DT'){
			Ext.getCmp('BONUS_DT_FR').setValue(UniDate.add(dt,{months:-11, days:1}));
		}else if(id == 'YEAR_DT'){
			Ext.getCmp('YEAR_DT_FR').setValue(UniDate.add(dt,{months:-11, days:1}));
		}
		
	}
    Unilite.Main( {
		items:[ 
	 		 panelSearch
		],
		id  : 'hrt300ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset', 'query'],false);
			panelSearch.onLoadSelectText('STD_DATE');
		}
	});

};


</script>
