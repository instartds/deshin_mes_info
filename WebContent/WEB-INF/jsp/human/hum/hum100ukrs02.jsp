<%@page language="java" contentType="text/html; charset=utf-8"%>
var etcInfo =	 {
	title:'<t:message code="system.label.human.personaddinfo" default="인사추가정보"/>',
	itemId: 'etcInfo',
	layout:{type:'vbox', align:'stretch'},
    items:[{
		xtype: 'uniDetailForm',
		itemId: 'etcForm',
		bodyCls: 'human-panel-form-background',
		disabled: false,
		api: {
         		 load: hum100ukrService.select,
         		 submit: hum100ukrService.saveHum100
		},
		flex:1,
		items: [basicInfo,{
			xtype: 'container',
	        layout: {type: 'uniTable', columns: 5},
	        padding: '10 10 10 10',
	        items: [{
				title: '<t:message code="system.label.human.addinfo" default="추가정보"/>',
				xtype: 'uniFieldset',
				itemId:'etcForm_1',
				layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
		        padding: '10 10 10 20',
				autoScroll:false,
				defaultType:'uniTextfield',
				height:470,
				items:[{
				 	name:'REPRE_NUM_EXPOS',
				 	hidden: true
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.telephone" default="전화번호"/>',
				 	name:'TELEPHON'
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.cellphonenum" default="핸드폰번호"/>',
				 	name:'PHONE_NO',
					listeners:{
						blur: function(field, event, eOpts )	{
							if(UniAppManager.app._needSave()){
								this.up('#etcInfo').down('#empTel').update(field.getValue());
							}
						}
					}
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.marryyn" default="결혼여부"/>',
				 	name:'MARRY_YN' ,
				 	xtype: 'uniRadiogroup',
				 	width:235,
				 	items: [
	 					{boxLabel:'<t:message code="system.label.human.yes" default="예"/>', name:'MARRY_YN', inputValue:'Y', checked:true},
	 					{boxLabel:'<t:message code="system.label.human.no" default="아니오"/>', name:'MARRY_YN', inputValue:'N'}
	  				],
	  				//20210830 추가
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue.MARRY_YN == 'Y') {
								panelDetail.down('#etcForm').setValue('WEDDING_DATE', new Date());
								panelDetail.down('#etcForm').getField('WEDDING_DATE').setReadOnly(false);
							} else {
								panelDetail.down('#etcForm').setValue('WEDDING_DATE', '');
								panelDetail.down('#etcForm').getField('WEDDING_DATE').setReadOnly(true);
							}
						}
					}
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.weddingdate" default="결혼기념일"/>',
				 	name:'WEDDING_DATE',
				 	xtype:'uniDatefield'
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.promotiondate" default="승진일"/>',
				 	name: 'PROMOTION_DATE',
				 	xtype: 'uniDatefield'
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.cardnum" default="출입카드NO"/>',
				 	name:'CARD_NUM'
				},{
	                fieldLabel: '<t:message code="system.label.human.cardnum" default="출입카드NO"/>2',
	                name:'CARD_NUM2'
	            },
	            Unilite.popup('BANK',{
	    	  	 	fieldLabel: '<t:message code="system.label.human.payrolltrnasferbank" default="급여이체은행"/>2',
				 	valueFieldName:'BANK_CODE2'   ,
				 	textFieldName:'BANK_NAME2',
				 	valueFieldWidth:55,
				 	textFieldWidth:95
				}),{
	    	  	 	fieldLabel: '<t:message code="system.label.human.bankaccount" default="계좌번호"/>2',
				 	name:'BANK_ACCOUNT2_EXPOS',
	                listeners:{
	                	blur: function(field, event, eOpts ){
							if(field.lastValue != field.originalValue){
								if(!Ext.isEmpty(field.lastValue)){
									var param = {
										"DECRYP_WORD" : field.lastValue
									};
									humanCommonService.encryptField(param, function(provider, response)  {
					                    if(!Ext.isEmpty(provider)){
				                        	panelDetail.down('#etcForm').setValue('BANK_ACCOUNT2',provider);
					                    }else{
				                        	panelDetail.down('#etcForm').setValue('BANK_ACCOUNT2_EXPOS',"");
				                        	panelDetail.down('#etcForm').setValue('BANK_ACCOUNT2',"");
					                    }
				                        field.originalValue = field.lastValue;
									});
								}else{
									panelDetail.down('#etcForm').setValue('BANK_ACCOUNT2',"");
								}
							}
						},
	                    afterrender:function(field) {
	                        field.getEl().on('dblclick', field.onDblclick);
	                    }
	                },
	                onDblclick:function(event, elm) {
	                	var formPanel = panelDetail.down('#etcForm');
						var params = {'INCRYP_WORD':formPanel.getValue('BANK_ACCOUNT2')};
	                    Unilite.popupDecryptCom(params);
	                }
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.bankaccount" default="계좌번호"/>2',
				 	name:'BANK_ACCOUNT2',
				 	hidden:true
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.accountholder" default="예금주"/>',
				 	name:'BANKBOOK_NAME2'
				},{
	                fieldLabel: '<t:message code="system.label.human.otherremark" default="기타사항"/>',
	                name:'REMARK'
	            },
				Unilite.popup('ZIP',{
					fieldLabel: '<t:message code="system.label.human.oriaddr" default="본적지주소"/>',
					showValue:false,
					textFieldWidth:150,
					textFieldName:'ORI_ZIP_CODE',
					DBtextFieldName:'ZIP_CODE',
					validateBlank:false,
					listeners: {
						'onSelected': {
				        	fn: function(records, type  ){
				            	panelDetail.down('#etcForm').setValue('ORI_ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
				            },
				            scope: this
				        },
				        'onClear' : function(type)	{
				        	panelDetail.down('#etcForm').setValue('ORI_ADDR', '');
				        }
					}
				}),{
	    	  	 	fieldLabel: ' ', //기타상세주소
	        		xtype:'textarea',
				 	name:'ORI_ADDR'
				}]
	        },{
	        	xtype:'component',
	        	width:10
	    	},{
				title: '<t:message code="system.label.human.etcinfo" default="기타정보"/>',
				xtype: 'uniFieldset',
				itemId:'etcForm_2',
				layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
		        padding: '10 10 10 20',
				autoScroll:false,
				defaultType:'uniTextfield',
				height:470,
				items:[{
	    	  	 	fieldLabel: '<t:message code="system.label.human.foreignnum" default="외국인등록번호"/>',
				 	name:'FOREIGN_NUM_EXPOS',
	                labelWidth:100,
	                listeners:{
	                	blur: function(field, event, eOpts ){
							if(!Ext.isEmpty(field.lastValue)){
								var newValue = field.getValue().replace(/-/g,'');
								if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
							 		Unilite.messageBox('<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
							 		this.setValue(field.originalValue);
							 		return ;
							 	}
								if(field.lastValue != field.originalValue){

				  					if(Unilite.validate('residentno',newValue) != true && !Ext.isEmpty(newValue))	{
								 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{
								 			field.setValue(field.originalValue);
								 			return;
								 		}
								 	}
									var param = {
										"DECRYP_WORD" : field.lastValue
									};
									humanCommonService.encryptField(param, function(provider, response)  {
					                    if(!Ext.isEmpty(provider)){
				                        	panelDetail.down('#etcForm').setValue('FOREIGN_NUM',provider);
					                    }else{
				                        	panelDetail.down('#etcForm').setValue('FOREIGN_NUM_EXPOS',"");
				                        	panelDetail.down('#etcForm').setValue('FOREIGN_NUM',"");
					                    }
				                        field.originalValue = field.lastValue;
									});
								}
							}else{
								panelDetail.down('#etcForm').setValue('FOREIGN_NUM',"");
							}
						},
	                    afterrender:function(field) {
	                        field.getEl().on('dblclick', field.onDblclick);
	                    }
	                },
	                onDblclick:function(event, elm) {
	                	var formPanel = panelDetail.down('#etcForm');
						var params = {'INCRYP_WORD':formPanel.getValue('FOREIGN_NUM')};
	                    Unilite.popupDecryptCom(params);
	                }
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.foreignnum" default="외국인등록번호"/>',
				 	name:'FOREIGN_NUM',
				 	hidden:true
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.livegubun" default="거주구분"/>',
				 	name:'LIVE_GUBUN',
				 	xtype: 'uniCombobox',
				 	comboType: 'AU',
				 	comboCode: 'H007',
	                labelWidth:100
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.foreignskillyn" default="외국인기술자여부"/>',
				 	name:'FOREIGN_SKILL_YN',
				 	xtype: 'uniRadiogroup',
	                width: 250,
	                labelWidth:100,
				 	items: [
	 					{boxLabel:'<t:message code="system.label.human.yes" default="예"/>'		, name:'FOREIGN_SKILL_YN', inputValue:'Y'},
	 					{boxLabel:'<t:message code="system.label.human.no" default="아니오"/>'	, name:'FOREIGN_SKILL_YN', inputValue:'N', checked:true}
	  				]
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.forecorpaffi" default="외국법인소속"/><br><t:message code="system.label.human.dispworkyn" default="파견근로자여부"/>',
				 	name:'FOREIGN_DISPATCH_YN',
				 	xtype: 'uniRadiogroup',
	                width: 250,
	                labelWidth:100,
				 	items: [
	 					{boxLabel:'<t:message code="system.label.human.yes" default="예"/>'		, name:'FOREIGN_DISPATCH_YN', inputValue:'Y'},
	 					{boxLabel:'<t:message code="system.label.human.no" default="아니오"/>'	, name:'FOREIGN_DISPATCH_YN', inputValue:'N', checked:true}
	  				]
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.essuseyn" default="대사우사용여부"/>',
				 	name:'ESS_USE_YN',
				 	xtype: 'uniRadiogroup',
	                width: 250,
	                labelWidth:100,
					items: [
	 					{boxLabel:'<t:message code="system.label.human.yes" default="예"/>'		, name:'ESS_USE_YN', inputValue:'Y', checked:true},
	 					{boxLabel:'<t:message code="system.label.human.no" default="아니오"/>'	, name:'ESS_USE_YN', inputValue:'N'}
	  				]
				},{
		            xtype: 'container',
		            layout: {type: 'uniTable', columns: 2},
		            defaultType: 'uniTextfield',
		            items: [{
		            	xtype: 'label',
		        		padding: '0 0 0 16',
                		style: 'font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; margin-top: 3px!important;',
		            	text:'<t:message code="system.label.human.esspw" default="대사우비밀번호"/>'
					},{
					 	xtype: 'button',
					 	text:'<t:message code="system.label.human.reset" default="초기화"/>',
						width:150,
						margin: '0 0 0 5',
						tdAttrs:{align:'center'},
						handler: function()	{
							Ext.getBody().mask('<t:message code="system.message.human.message015" default="초기화 중..."/>','loading-indicator');
							var formPanel = this.up('#etcForm');
							var param = {
								"PERSON_NUMB": formPanel.getValue('PERSON_NUMB')
		                    };
		                    hum100ukrService.updateEssPass(param, function(provider, response)  {
		                        if(!Ext.isEmpty(provider)){
		                        	if(provider == 'Y'){
		                        		UniAppManager.updateStatus('<t:message code="system.message.human.message016" default="대사우 비밀번호가 초기화 되었습니다."/>');
		                        	}else{
		                        		Unilite.messageBox('<t:message code="system.message.human.message017" default="초기화에 실패 하였습니다."/>');
		                        	}
		                        }
		                        Ext.getBody().unmask();
		                    });
						}
					}]
				},{
                    fieldLabel: '<t:message code="" default="군  &nbsp;&nbsp;&nbsp;&nbsp;번"/>',
                    name:'ARMY_NO',
                    labelWidth:100
                },{
	    	  	 	fieldLabel: '<t:message code="system.label.human.armykind" default="병역군별"/>',
				 	name:'ARMY_KIND',
				 	xtype: 'uniCombobox',
				 	comboType: 'AU',
				 	comboCode: 'H017',
	                labelWidth:100
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.miltype" default="병역구분"/>',
				 	name:'MIL_TYPE'  ,
				 	xtype: 'uniCombobox',
				 	comboType: 'AU',
				 	comboCode: 'H016',
	                labelWidth:100
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.armygrade" default="병역계급"/>',
				 	name:'ARMY_GRADE',
				 	xtype: 'uniCombobox',
				 	comboType: 'AU',
				 	comboCode: 'H018',
	                labelWidth:100
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.armymajor" default="병역병과"/>',
				 	name:'ARMY_MAJOR',
				 	xtype: 'uniCombobox',
				 	comboType: 'AU',
				 	comboCode: 'H019',
	                labelWidth:100
				},{
				    fieldLabel: '<t:message code="system.label.human.armydate" default="복무기간"/>',
		            xtype: 'uniDateRangefield',
		            startFieldName: 'ARMY_STRT_DATE',
		            endFieldName: 'ARMY_LAST_DATE',
	                labelWidth:100
	        	}]
	        },{
	        	xtype:'component',
	        	width:10
	    	},{
				title: '<t:message code="system.label.human.suppagedinfo" default="부양가족정보"/>',
				xtype: 'uniFieldset',
				itemId:'etcForm_3',
				layout:{type: 'uniTable', columns:1, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'top'}},
		        padding: '10 10 10 20',
				autoScroll:false,
				defaultType:'uniTextfield',
				height:470,
				items:[{
	    	  	 	fieldLabel: '<t:message code="system.label.human.householdyn" default="세대주여부"/>',
				 	name:'HOUSEHOLDER_YN',
				 	xtype: 'uniRadiogroup',
	                width: 250,
	                labelWidth:100,
				 	items: [
	 					{boxLabel:'<t:message code="system.label.human.yes" default="예"/>'		, name:'HOUSEHOLDER_YN', inputValue:'1', checked:true},
	 					{boxLabel:'<t:message code="system.label.human.no" default="아니오"/>'	, name:'HOUSEHOLDER_YN', inputValue:'2'}
	  				]
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.spousededi" default="배우자공제"/>',
				 	name:'SPOUSE' ,
				 	xtype: 'uniRadiogroup',
	                width: 250,
	                labelWidth:100,
					items: [
	 					{boxLabel:'<t:message code="system.label.human.do" default="한다"/>', name:'SPOUSE', inputValue:'Y', checked:true},
	 					{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>', name:'SPOUSE', inputValue:'N'}
	  				],
	  				listeners:{
						change: function(field,  newValue, oldValue, eOpts )	{
							var formPanel = this.up('#etcForm');
							if (formPanel.uniOpt.inLoading == true) {
								return false;
							}
							if(newValue.SPOUSE == "Y")	{
								var chkValue = formPanel.getValue('ONE_PARENT').ONE_PARENT
								if(!Ext.isEmpty(chkValue))	{
									if(chkValue == 'Y')	{
										Unilite.messageBox('<t:message code="system.message.human.message011" default="배우자가 있는 경우에는 한부모 소득공제를 받을 수 없습니다"/>');
										formPanel.setValue('ONE_PARENT','N');
									}
								}
							}
						}
					}
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.womanded2" default="부녀자세대공제"/>',
				 	name:'WOMAN' ,
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
	                width: 250,
	                labelWidth:100,
				 	items: [
	 					{boxLabel:'<t:message code="system.label.human.do" default="한다"/>', name:'WOMAN', inputValue:'Y', checked:true},
	 					{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>', name:'WOMAN', inputValue:'N', id:'womanN'}
	  				],
	  				listeners:{
						change: function(field,  newValue, oldValue, eOpts )	{
							var formPanel = this.up('#etcForm');
							if (formPanel.uniOpt.inLoading == true) {
                                return false;
                            }
							if(newValue.WOMAN == "Y")	{
								var chkValue = formPanel.getValue('ONE_PARENT').ONE_PARENT

								var RepreNumExpos = formPanel.getValue('REPRE_NUM_EXPOS')
								var ChkNum = RepreNumExpos.substr(7,1);

								if(ChkNum == 2 || ChkNum == 6) {
									formPanel.setValue('WOMAN','Y');
								} else if(ChkNum != 2 || ChkNum != 6) {
									Unilite.messageBox('<t:message code="system.message.human.message140" default="부녀자공제는 주민등록번호 7번째 자리가 2와 6번인  경우만 가능합니다."/>');
									formPanel.setValue('WOMAN', 'N');
								}
								if(!Ext.isEmpty(chkValue))	{
									if(chkValue == 'Y')	{
										Unilite.messageBox('<t:message code="system.message.human.message012" default="한부모 소득공제를 받을 경우 부녀자 세대공제를 받을 수 없습니다."/>');
										formPanel.setValue('WOMAN','N');
									}
								}
							}
						}
					}
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.oneparent" default="한부모소득공제"/>',
				 	name:'ONE_PARENT' ,
				 	xtype: 'uniRadiogroup',
				 	store: Ext.data.StoreManager.lookup('Hum100ukrYNStore'),
	                width: 250,
	                labelWidth:100,
				 	items: [
	 					{boxLabel:'<t:message code="system.label.human.do" default="한다"/>', name:'ONE_PARENT', inputValue:'Y', checked:true},
	 					{boxLabel:'<t:message code="system.label.human.donot" default="안한다"/>', name:'ONE_PARENT', inputValue:'N'}
	  				],
	  				listeners:{
						change: function(field,  newValue, oldValue, eOpts )	{
							var formPanel = this.up('#etcForm');
							if (formPanel.uniOpt.inLoading == true) {
                                return false;
                            }
							if(newValue.ONE_PARENT == "Y")	{
								var chkValue = formPanel.getValue('SPOUSE').SPOUSE;
								var chkValue2 = formPanel.getValue('WOMAN').WOMAN
								if(!Ext.isEmpty(chkValue))	{
									if(chkValue == 'Y')	{
										Unilite.messageBox('<t:message code="system.message.human.message013" default="배우자가 있는 경우에는 한부모 소득공제를 받을 수 없습니다"/>');
										formPanel.setValue('ONE_PARENT','N');
									}
								}
								if(!Ext.isEmpty(chkValue2))	{
									if(chkValue2 == 'Y')	{
										Unilite.messageBox('<t:message code="system.message.human.message014" default="부녀자 세대공제를 받을 경우 한부모 소득공제를 받을 수 없습니다"/>');
										formPanel.setValue('ONE_PARENT','N');
									}
								}
							}
						}
					}
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.suppagednum1" default="부양가족수"/><br><t:message code="system.label.human.suppagedinfo2" default="(배우자,본인제외)"/>',
				 	name:'SUPP_AGED_NUM' ,
				 	xtype:'uniNumberfield',
				 	value:0,
	                labelWidth:100
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.child20num3" default="7세이상"/><br>~<t:message code="system.label.human.child20num" default="20세이하자녀수"/><br><t:message code="system.label.human.child20num2" default="(다자녀)"/>',
				 	name:'CHILD_20_NUM' ,
				 	xtype:'uniNumberfield',
				 	value:0,
	                labelWidth:100
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.deformqty" default="장애인수"/><br><t:message code="system.label.human.deformqty2" default="(본인포함)"/>',
				 	name:'DEFORM_NUM' ,
				 	xtype:'uniNumberfield',
				 	value:0,
	                labelWidth:100
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.agedqty" default="경로우대자수"/><br><t:message code="system.label.human.agedqty2" default="(70세이상)"/>',
				 	name:'AGED_NUM70' ,
				 	xtype:'uniNumberfield',
				 	value:0,
	                labelWidth:100
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.agedqty" default="경로우대자수"/><br><t:message code="system.label.human.agedqty3" default="(70세미만)"/>',
				 	name:'AGED_NUM' ,
				 	xtype:'uniNumberfield',
				 	value:0,
	                labelWidth:100
				},{
	    	  	 	fieldLabel: '<t:message code="system.label.human.bringchildqty" default="자녀양육수"/><br><t:message code="system.label.human.bringchildqty2" default="(6세이하)"/>',
				 	name:'BRING_CHILD_NUM' ,
				 	xtype:'uniNumberfield',
				 	value:0,
	                labelWidth:100
				}]
	        }]
		}],
		listeners:{
			uniOnChange:function( form ) {
				if(form.isDirty() && !form.uniOpt.inLoading)	{
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		},
		/**
		 * 부양가족수 체크 함수
		 */
		chkSupportNum: function()	{
			var r = true;
			var me = this;
			var sum = 0;
			sum = me.getValue('CHILD_20_NUM') + me.getValue('DEFORM_NUM') + me.getValue('AGED_NUM70') + me.getValue('AGED_NUM');//DEFORM_YN  장애인여부
			suppNum = me.getValue('SUPP_AGED_NUM')
			if(suppNum < sum)	{
				if(!confirm('<t:message code="system.message.human.message018" default="20세이하자녀수와 장애인수, 경로우대자수의 합이 부양가족수 보다 많습니다. 그래도 저장하시겠습니까?"/>'))	{
					r = false;
				}
			}

			if(!Ext.isNumber(me.getValue('CHILD_20_NUM')) && Unilite.nvl(me.getValue('CHILD_20_NUM'), '') == '')	{
				Unilite.messageBox('<t:message code="system.message.human.message019" default="해당 사항이 없는 경우 0을 입력하세요"/>');
				me.getField('CHILD_20_NUM').focus();
				r = false;
			}

			if(!Ext.isNumber(me.getValue('DEFORM_NUM')) &&  Unilite.nvl(me.getValue('DEFORM_NUM'), '') == '')	{
				Unilite.messageBox('<t:message code="system.message.human.message019" default="해당 사항이 없는 경우 0을 입력하세요"/>');
				me.getField('DEFORM_NUM').focus();
				r = false;
			}

			if(!Ext.isNumber(me.getValue('AGED_NUM70')) &&  Unilite.nvl(me.getValue('AGED_NUM70'), '') == '')	{
				Unilite.messageBox('<t:message code="system.message.human.message019" default="해당 사항이 없는 경우 0을 입력하세요"/>');
				me.getField('AGED_NUM70').focus();
				r = false;
			}

			if(!Ext.isNumber(me.getValue('AGED_NUM')) &&  Unilite.nvl(me.getValue('AGED_NUM'), '') == '')	{
				Unilite.messageBox('<t:message code="system.message.human.message019" default="해당 사항이 없는 경우 0을 입력하세요"/>');
				me.getField('AGED_NUM').focus();
				r = false;
			}
			return r;
		}
	}],
	loadData:function(personNum)	{
		var etcForm = this.down('#etcForm');
		etcForm.uniOpt.inLoading = true;
		etcForm.clearForm();
		etcForm.mask();
		etcForm.getForm().load({
			params : {'PERSON_NUMB':personNum},
			success: function(form, action)	{
				etcForm.unmask();
			 	etcForm.uniOpt.inLoading = false;
			},
			failure: function(form, action)	{
				etcForm.unmask();
			 	etcForm.uniOpt.inLoading = false;
			}
		});
	}
};