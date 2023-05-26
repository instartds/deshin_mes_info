<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");

    %>
    var code_1Store = Unilite.createStore('code_1Store',{
        proxy: {
           type: 'direct',
            api: {
            	read: 's_bpr300ukrv_shService.getCode_1'
            }
        },
        loadStoreRecords: function(comboStore,refCode6) {
            var param= Ext.getCmp('detailForm').getValues();
            param.CODE_1 = refCode6;
            console.log( param );
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });

	var code_2Store = Unilite.createStore('code_2Store',{
        proxy: {
           type: 'direct',
            api: {
            	read: 's_bpr300ukrv_shService.getCode_2'
            }
        },
        loadStoreRecords: function(comboStore,refCode2) {
            var param= Ext.getCmp('detailForm').getValues();
            param.CODE_2 = refCode2;
            console.log( param );
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });

    var small_1Store = Unilite.createStore('small_1Store',{
        proxy: {
           type: 'direct',
            api: {
                read: 's_bpr300ukrv_shService.getSmallCode_1'
            }
        },
        loadStoreRecords: function(comboStore, refCode2) {
            var param= Ext.getCmp('detailForm').getValues();
            param.CODE_2 = refCode2;
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });

    var small_2Store = Unilite.createStore('small_2Store',{
        proxy: {
           type: 'direct',
            api: {
                read: 's_bpr300ukrv_shService.getSmallCode_2'
            }
        },
        loadStoreRecords: function(comboStore, refCode2) {
            var param= Ext.getCmp('detailForm').getValues();
            param.CODE_2 = refCode2;
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });

	   var small_3Store = Unilite.createStore('small_3Store',{
        proxy: {
           type: 'direct',
            api: {
                read: 's_bpr300ukrv_shService.getSmallCode_3'
            }
        },
        loadStoreRecords: function(comboStore, refCode2) {
            var param= Ext.getCmp('detailForm').getValues();
            param.CODE_2 = refCode2;
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });

       var small_4Store = Unilite.createStore('small_4Store',{
        proxy: {
           type: 'direct',
            api: {
                read: 's_bpr300ukrv_shService.getSmallCode_4'
            }
        },
        loadStoreRecords: function(comboStore, refCode2) {
            var param= Ext.getCmp('detailForm').getValues();
            param.CODE_2 = refCode2;
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });

	var autoFieldset = {
		layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType: 'uniFieldset',
		masterGrid: masterGrid,
		defaults: { padding: '10 15 15 10'},
		colspan: 3,
		id: 'autoCodeFieldset',
//			hidden:true,
		items: [{
			title: '품목코드 채번 (신환)',
			defaults: {type: 'uniTextfield', labelWidth:100},
			layout: { type: 'uniTable', columns: 3},
			items: [{

				fieldLabel: '신규품목계정',
				name: 'AUTO_ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				listeners: {

					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('CODE_1','',true);
					    detailForm.setValue('CODE_2','',true);
						detailForm.setValue('CODE_SMALL_1','',true);
						detailForm.setValue('CODE2_MANUAL','',true);
						detailForm.setValue('CODE_SMALL_2','',true);
						detailForm.setValue('CODE_SMALL_3','',true);
						detailForm.setValue('CODE_SMALL_4','',true);
						detailForm.setValue('AUTO_ITEM_CODE','',true);
						if(!Ext.isEmpty(field.valueCollection.items[0])){
							var refCode6 = field.valueCollection.items[0].data.refCode6;
							code_1Store.loadStoreRecords(null,refCode6);
						}

					}
				}


			},{
				fieldLabel: '대분류',
				name: 'CODE_1',
				xtype: 'uniCombobox',
				store:code_1Store,
//				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

						detailForm.setValue('CODE_2','',true);
						detailForm.setValue('CODE_SMALL_1','',true);
						detailForm.setValue('CODE2_MANUAL','',true);
						detailForm.setValue('CODE_SMALL_2','',true);
						detailForm.setValue('CODE_SMALL_3','',true);
						detailForm.setValue('CODE_SMALL_4','',true);
						detailForm.setValue('AUTO_ITEM_CODE','',true)
						var selItem = '';
						if(!Ext.isEmpty(field.valueCollection.items[0])){
							selItem = field.valueCollection.items[0].data.refCode3;
						}
						if(!Ext.isEmpty(selItem)){
							if(selItem == 'M'){//수동입력시
								detailForm.getField('CODE_2').setReadOnly( true );
								detailForm.getField('CODE2_MANUAL').setReadOnly( false );
							}else{
								detailForm.getField('CODE_2').setReadOnly( false );
								detailForm.getField('CODE2_MANUAL').setReadOnly( true );

							}
							var refCode2 = field.valueCollection.items[0].data.refCode2;
							code_2Store.loadStoreRecords(null,refCode2);
						}
					},beforequery:function( queryPlan, eOpts )   {
						var autoItemAccount = detailForm.getValue('AUTO_ITEM_ACCOUNT');
						if(Ext.isEmpty(autoItemAccount)){
							Unilite.messageBox('신규품목계정이 비어있습니다. 신규품목계정을 입력해주세요.');
							detailForm.getField('AUTO_ITEM_ACCOUNT').focus();
							return false;
						}

					}
				}
			},
			{
				xtype: 'container',
				layout: {type : 'table', columns : 1},
				tdAttrs: {align: 'right'},
				width:150,
				colspan:2,
		    	items:[{
				        	xtype:'button',
				        	text:'채번 확정',
				    		width: 100,
				    		itemId: 'confirmItemCode',
				        	handler:function(){
								var autoItemCode =  detailForm.getValue('AUTO_ITEM_CODE');
				        		if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_ACCOUNT'))){
				        			Unilite.messageBox('신규 품목계정 값이 없습니다.');
				        			return false;
				        		}else if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_CODE'))){
				        			Unilite.messageBox('신규 품목코드 값이 없습니다.');
				        			return false;
				        		}else if(!Ext.isEmpty(detailForm.getValue('ITEM_CODE'))){
					        			//Unilite.messageBox('이미 품목코드 값이 입력되어있습니다.');
					        			//return false;
		        						detailForm.setValue('ITEM_CODE',detailForm.getValue('AUTO_ITEM_CODE'));
										detailForm.setValue('ITEM_ACCOUNT',detailForm.getValue('AUTO_ITEM_ACCOUNT'),false);

										detailForm.setValue('ITEM_NAME',detailForm.getValue('AUTO_ITEM_NAME'));

										detailForm.getField('ITEM_CODE').setReadOnly(true);
												detailForm.getField('ITEM_ACCOUNT').setReadOnly(true);
				        		}else if(autoItemCode.indexOf('null') != -1){
				        			Unilite.messageBox('품목코드 채번이 정확하지 않습니다.');
				        			return false;
				        		}else{
				        						detailForm.setValue('ITEM_CODE',detailForm.getValue('AUTO_ITEM_CODE'));
												detailForm.setValue('ITEM_ACCOUNT',detailForm.getValue('AUTO_ITEM_ACCOUNT'),false);

												detailForm.setValue('ITEM_NAME',detailForm.getValue('AUTO_ITEM_NAME'));

												detailForm.getField('ITEM_CODE').setReadOnly(true);
												detailForm.getField('ITEM_ACCOUNT').setReadOnly(true);

				        		}

				        	}
			        	}]
        	},{
				fieldLabel: '중분류',
				name: 'CODE_2',
				xtype: 'uniCombobox',
				store:code_2Store,
//				allowBlank: false,

				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

						detailForm.setValue('CODE_SMALL_1','',true);
						detailForm.setValue('CODE2_MANUAL','',true);
						detailForm.setValue('CODE_SMALL_2','',true);
						detailForm.setValue('CODE_SMALL_3','',true);
						detailForm.setValue('CODE_SMALL_4','',true);
						detailForm.setValue('AUTO_ITEM_CODE','',true);
							if(!Ext.isEmpty(field.valueCollection.items[0])){
								var refCode2 = field.valueCollection.items[0].data.refCode2;
								small_1Store.loadStoreRecords(null,refCode2);
							}
					},beforequery:function( queryPlan, eOpts )   {
						var code1 = detailForm.getValue('CODE_1');
						if(Ext.isEmpty(code1)){
							Unilite.messageBox('대분류가 비어있습니다. 대분류를 입력해주세요.');
							detailForm.getField('CODE_1').focus();
							return false;
						}
					}
				}
			},{
				xtype:'uniTextfield',
				fieldLabel:'중분류 수동입력',
				name:'CODE2_MANUAL',
				hidden:false,
				readOnly:true,
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('CODE_2','',true);
						detailForm.setValue('CODE_SMALL_1','',true);
						detailForm.setValue('CODE_SMALL_2','',true);
						detailForm.setValue('CODE_SMALL_3','',true);
						detailForm.setValue('CODE_SMALL_4','',true);
						detailForm.setValue('AUTO_ITEM_CODE','',true);
						if(!Ext.isEmpty(newValue)){
								var field =  detailForm.getField('CODE_1');
								var code1 =  detailForm.getValue('CODE_1');
								if(Ext.isEmpty(code1)){
									Unilite.messageBox('대분류가 비어있습니다. 대분류를 입력해주세요.');
									detailForm.getField('CODE_1').focus();
									return false;
								}
								var refCode2 = field.valueCollection.items[0].data.refCode2;
								small_1Store.loadStoreRecords(null, refCode2);
						}
					},blur: function(field, event, eOpts ){
						var strChk = detailForm.getValue('CODE2_MANUAL');
						if(strChk.length != 4 && !Ext.isEmpty(detailForm.getValue('CODE_1'))){
							Unilite.messageBox('중분류는 4자리만 가능합니다.');
							detailForm.setValue('CODE2_MANUAL','',true);
						}
					}
				}
			},{

				fieldLabel: '소분류1',
				name: 'CODE_SMALL_1',
				xtype: 'uniCombobox',
				store:small_1Store,
//				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {


						detailForm.setValue('CODE_SMALL_2','',true);
						detailForm.setValue('CODE_SMALL_3','',true);
						detailForm.setValue('CODE_SMALL_4','',true);
						detailForm.setValue('AUTO_ITEM_CODE','',true);
	       				if(!Ext.isEmpty(field.valueCollection.items[0])){
								var refCode2 = field.valueCollection.items[0].data.refCode2;
								small_2Store.loadStoreRecords(null, refCode2);
						}
					},beforequery:function( queryPlan, eOpts )   {
						var field1 =  detailForm.getField('CODE_1');
						var autoChk = '';
						if(!Ext.isEmpty(field1.valueCollection.items[0])){
							autoChk = field1.valueCollection.items[0].data.refCode3;
						}
						if(autoChk == 'A'){//자동입력시
							var code2 = detailForm.getValue('CODE_2');
							if(Ext.isEmpty(code2)){
								Unilite.messageBox('중분류가 비어있습니다. 중분류를 입력해주세요.');
								detailForm.getField('CODE_2').focus();
								return false;
							}
						}else{
							var code2 = detailForm.getValue('CODE2_MANUAL');
							if(Ext.isEmpty(code2)){
								Unilite.messageBox('중분류가 비어있습니다. 중분류를 수동 입력해주세요.');
								//detailForm.getField('CODE2_MANUAL').focus();
								return false;
							}
						}

					}
				}
			},{

				fieldLabel: '소분류2',
				name: 'CODE_SMALL_2',
				xtype: 'uniCombobox',
				store:small_2Store,
//				allowBlank: false,
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

						detailForm.setValue('CODE_SMALL_3','',true);
						detailForm.setValue('CODE_SMALL_4','',true);
						detailForm.setValue('AUTO_ITEM_CODE','',true);
	      					if(!Ext.isEmpty(field.valueCollection.items[0])){
								var refCode2 = field.valueCollection.items[0].data.refCode2;
								small_3Store.loadStoreRecords(null, refCode2);
							}
					},beforequery:function( queryPlan, eOpts )   {
						var codeSmall1 = detailForm.getValue('CODE_SMALL_1');
						if(Ext.isEmpty(codeSmall1)){
							Unilite.messageBox('소분류1이 비어있습니다. 소분류1을 입력해주세요.');
							detailForm.getField('CODE_SMALL_1').focus();
							return false;
						}

					}
				}
			},{

				fieldLabel: '소분류3',
				name: 'CODE_SMALL_3',
				xtype: 'uniCombobox',
				store:small_3Store,
//				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('CODE_SMALL_4','',true);
						detailForm.setValue('AUTO_ITEM_CODE','',true);

						//var field1 =  detailForm.getField('CODE_1');
						//var code1Val =  detailForm.getValue('CODE_1');
						var autoChk = '';
						//if(!Ext.isEmpty(code1Val)){
						 autoChk = field.valueCollection.items[0].data.refCode3;
						//}

						if(autoChk == 'A' ){ //자동채번 (자동으로 SEQ 생성)
							detailForm.getField('CODE_SMALL_4').setReadOnly( true );
							var code1          =  detailForm.getValue('CODE_1');
							var code2 		   =  detailForm.getValue('CODE_2');
							var code2Manual =  detailForm.getValue('CODE2_MANUAL');
							var codeSmall1   =  detailForm.getValue('CODE_SMALL_1');
							var codeSmall2   =  detailForm.getValue('CODE_SMALL_2');
							var codeSmall3   =  detailForm.getValue('CODE_SMALL_3');
							if(Ext.isEmpty(code2Manual)){
								code2Manual = '';
							}
							if(Ext.isEmpty(code2)){
								code2 = '';
							}
							var autoItemCode =  code1 + code2 + code2Manual + codeSmall1 + '-' + codeSmall2 + codeSmall3 ;
							detailForm.setValue('AUTO_MAN',autoItemCode,true);
							var param= Ext.getCmp('detailForm').getValues();

							if(!Ext.isEmpty(newValue)){
								s_bpr300ukrv_shService.selectAutoItemCode(param, function(provider, response) {
									if(!Ext.isEmpty(provider))	{
										detailForm.setValue('AUTO_ITEM_CODE',provider.AUTO_ITEM_CODE,true);
										detailForm.setValue('LAST_SEQ',provider.LAST_SEQ,true);
										detailForm.setValue('AUTO_YN','Y',true);

									}else{
										detailForm.setValue('AUTO_ITEM_CODE','',true);
										detailForm.setValue('LAST_SEQ','',true);

									}
								})

							}
						}else{
							detailForm.getField('CODE_SMALL_4').setReadOnly( false );
							if(!Ext.isEmpty(field.valueCollection.items[0])){
								var refCode2 = field.valueCollection.items[0].data.refCode2;
								small_4Store.loadStoreRecords(null, refCode2);
							}

						}

					},beforequery:function( queryPlan, eOpts )   {
						var codeSmall2 = detailForm.getValue('CODE_SMALL_2');
						if(Ext.isEmpty(codeSmall2)){
							Unilite.messageBox('소분류2가 비어있습니다. 소분류2를 입력해주세요.');
							detailForm.getField('CODE_SMALL_2').focus();
							return false;
						}
					}
				}
			},{

				fieldLabel: '소분류4',
				name: 'CODE_SMALL_4',
				xtype: 'uniCombobox',
				store:small_4Store,
//				allowBlank: false,
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

						var code1          =  detailForm.getValue('CODE_1');
						var code2 		   =  detailForm.getValue('CODE_2');
						var code2Manual =  detailForm.getValue('CODE2_MANUAL');
						var codeSmall1   =  detailForm.getValue('CODE_SMALL_1');
						var codeSmall2   =  detailForm.getValue('CODE_SMALL_2');
						var codeSmall3   =  detailForm.getValue('CODE_SMALL_3');
						var codeSmall4   =  detailForm.getValue('CODE_SMALL_4');
						if(Ext.isEmpty(code2Manual)){
							code2Manual = '';
						}
						if(Ext.isEmpty(code2)){
							code2 = '';
						}

						var autoItemCode =  code1 + code2 + code2Manual + codeSmall1 + '-' + codeSmall2 + codeSmall3 + codeSmall4;
	       				detailForm.setValue('AUTO_ITEM_CODE',autoItemCode,true);

					},beforequery:function( queryPlan, eOpts )   {
						var codeSmall3 = detailForm.getValue('CODE_SMALL_3');
						if(Ext.isEmpty(codeSmall3)){
							Unilite.messageBox('소분류3이 비어있습니다. 소분류3을 입력해주세요.');
							detailForm.getField('CODE_SMALL_3').focus();
							return false;
						}

					}
				}
			},{
				xtype:'uniTextfield',
				fieldLabel:'AUTO_MAN',
				name:'AUTO_MAN',
				hidden:true
			},{
				xtype:'uniTextfield',
				fieldLabel:'LAST_SEQ',
				name:'LAST_SEQ',
				hidden:true
			},
			{
				xtype:'uniTextfield',
				fieldLabel:'신규품목코드',
				name:'AUTO_ITEM_CODE',
				readOnly:true

			},{
				xtype:'uniTextfield',
				fieldLabel:'신규품명',
				name:'AUTO_ITEM_NAME',
				width:590,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

						detailForm.setValue('ITEM_NAME',newValue);
					}
				}
//
			},
			{
				xtype:'uniTextfield',
				fieldLabel:'AUTO_YN',
				name:'AUTO_YN',
				readOnly:true,
				hidden:true
			}
			]
		}]
	}

	function emptyChk(){
		var fieldArry = new Array(); //배열선언
		var fieldArry1 = new Array(); //배열선언
 	    fieldArry[0]= 'AUTO_ITEM_ACCOUNT';
 	    fieldArry[1]= 'CODE_1';
        fieldArry[2]= 'CODE_2';
        fieldArry[3]= 'CODE2_MANUAL';
        fieldArry[4]= 'CODE_SMALL_1';
        fieldArry[5]= 'CODE_SMALL_2';
        fieldArry[6]= 'CODE_SMALL_3';
        fieldArry[7]= 'CODE_SMALL_4';

		fieldArry1[0]= '신규품목계정';
 	    fieldArry1[1]= '대분류';
        fieldArry1[2]= '중분류';
        fieldArry1[3]= '중분류 수동입력';
        fieldArry1[4]= '소분류1';
        fieldArry1[5]= '소분류2';
        fieldArry1[6]= '소분류3';
        fieldArry1[7]= '소분류4';
		var isErr = false;
         for(var i=0; i < fieldArry.length; i++){
			if(fieldArry[i] == 'CODE_2' || fieldArry[i] =='CODE2_MANUAL'){
				if(Ext.isEmpty(detailForm.getValue('CODE_2')) && Ext.isEmpty(detailForm.getValue('CODE2_MANUAL')) ){
					Unilite.messageBox('중분류 값이 비어 있습니다.');
					isErr = true;
					break;
				}
			}else{
				if(Ext.isEmpty(detailForm.getValue(fieldArry[i]))){
				Unilite.messageBox(fieldArry1[i] + '의 값이 비어있습니다.');
				isErr = true;
				break;
				}
			}
		 }
		return isErr;
	}
