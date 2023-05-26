<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");
 
    %>
	var code_2Store = Unilite.createStore('code_2Store',{
        proxy: {
           type: 'direct',
            api: {
            	read: 's_bpr110ukrv_novisService.getCode_2'
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
    
    var code_3Store = Unilite.createStore('code_3Store',{
        proxy: {
           type: 'direct',
            api: {
                read: 's_bpr110ukrv_novisService.getCode_3'
            }
        },
        loadStoreRecords: function(comboStore,refCode1) {
            var param= Ext.getCmp('detailForm').getValues();
            param.CODE_2_REF_CODE1 = refCode1;
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
 
 
 
 
	var autoFieldset = {
		layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType: 'uniFieldset',
		masterGrid: masterGrid,
		defaults: { padding: '10 15 15 10'},
		colspan: 3,
		id: 'autoCodeFieldset',
//			hidden:true,
		items: [{
			title: '품목코드 채번 (노비스바이오)',
			defaults: {type: 'uniTextfield', labelWidth:100},
			layout: { type: 'uniTable', columns: 3},
			items: [{

				fieldLabel: '신규품목계정',
				name: 'AUTO_ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				listeners: {
					
					
					
//						blur: function(field, event, eOpts ){
////							if(field.lastValue != field.originalValue){
//								var param = {
//									"AUTO_ITEM_ACCOUNT" : field.lastValue
//								};
//								bpr300ukrvService.selectAutoItemCode(param, function(provider, response) {
//									if(!Ext.isEmpty(provider))	{
//										detailForm.setValue('AUTO_ITEM_CODE',provider.AUTO_ITEM_CODE);
//										detailForm.setValue('LAST_ITEM_CODE',provider.LAST_ITEM_CODE);
//
//										detailForm.setValue('ITEM_CODE',provider.AUTO_ITEM_CODE);
//									}else{
//										detailForm.setValue('AUTO_ITEM_CODE','');
//										detailForm.setValue('LAST_ITEM_CODE','');
//
//										detailForm.setValue('ITEM_CODE','');
//									}
//								})
//
//								detailForm.setValue('ITEM_ACCOUNT',field.lastValue);
//
////							}
//						}


					change: function(field, newValue, oldValue, eOpts) {
						
						
						detailForm.setValue('CODE_3','');
						detailForm.setValue('CODE_2','');
						
						if(!Ext.isEmpty(field.valueCollection.items[0])){
							var refCode6 = field.valueCollection.items[0].data.refCode6;
							code_2Store.loadStoreRecords(null,refCode6);
						}
					
				/*		
						
						var param = {
							"AUTO_ITEM_ACCOUNT" : newValue
						};
						if(!Ext.isEmpty(newValue)){
							bpr300ukrvService.selectAutoItemCode(param, function(provider, response) {
								if(!Ext.isEmpty(provider))	{
									detailForm.setValue('AUTO_ITEM_CODE',provider.AUTO_ITEM_CODE);
									detailForm.setValue('LAST_ITEM_CODE',provider.LAST_ITEM_CODE);

									detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
									detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);

								}else{
									detailForm.setValue('AUTO_ITEM_CODE','');
									detailForm.setValue('LAST_ITEM_CODE','');

									detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
									detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);

								}
							})

						}*/
					}
				}


			},{
				fieldLabel: '코드2',
				name: 'CODE_2',
				xtype: 'uniCombobox',
				store:code_2Store,
//				allowBlank: false,
				labelWidth:138,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('CODE_3','');
						
						if(detailForm.getValue('AUTO_ITEM_ACCOUNT') == '00'){
							
		       				var param= Ext.getCmp('detailForm').getValues();
							if(!Ext.isEmpty(detailForm.getField('AUTO_ITEM_ACCOUNT').valueCollection.items[0])){
		       					param.CODE_1 = detailForm.getField('AUTO_ITEM_ACCOUNT').valueCollection.items[0].data.refCode6
							}
							if(!Ext.isEmpty(newValue)){
								s_bpr110ukrv_novisService.selectAutoItemCode(param, function(provider, response) {
									if(!Ext.isEmpty(provider))	{
										detailForm.setValue('AUTO_ITEM_CODE',provider.AUTO_ITEM_CODE);
										detailForm.setValue('LAST_ITEM_CODE',provider.LAST_ITEM_CODE);
		
										detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
										detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);
		
									}else{
										detailForm.setValue('AUTO_ITEM_CODE','');
										detailForm.setValue('LAST_ITEM_CODE','');
		
										detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
										detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);
		
									}
								})
		
							}
					
							
							
						}else{
							if(!Ext.isEmpty(field.valueCollection.items[0])){
								var refCode1 = field.valueCollection.items[0].data.refCode1;
								code_3Store.loadStoreRecords(null,refCode1);
							}
						}
					}
				}
			},{
	
				fieldLabel: '코드3',
				name: 'CODE_3',
				xtype: 'uniCombobox',
				store:code_3Store,
//				allowBlank: false,
				labelWidth:138,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
	       				var param= Ext.getCmp('detailForm').getValues();
						if(!Ext.isEmpty(detailForm.getField('AUTO_ITEM_ACCOUNT').valueCollection.items[0])){
	       					param.CODE_1 = detailForm.getField('AUTO_ITEM_ACCOUNT').valueCollection.items[0].data.refCode6
						}
						if(!Ext.isEmpty(newValue)){
							s_bpr110ukrv_novisService.selectAutoItemCode(param, function(provider, response) {
								if(!Ext.isEmpty(provider))	{
									detailForm.setValue('AUTO_ITEM_CODE',provider.AUTO_ITEM_CODE);
									detailForm.setValue('LAST_ITEM_CODE',provider.LAST_ITEM_CODE);
	
									detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
									detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);
	
								}else{
									detailForm.setValue('AUTO_ITEM_CODE','');
									detailForm.setValue('LAST_ITEM_CODE','');
	
									detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
									detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);
	
								}
							})
	
						}
					}
				}
			},
					
				{
				xtype:'uniTextfield',
				fieldLabel:'최종품목코드',
				name:'LAST_ITEM_CODE',
				readOnly:true

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
		        	handler:function(){
		        		if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_ACCOUNT'))){
		        			Unilite.messageBox('신규 품목계정 값이 없습니다.');
		        			return false;
		        		}else if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_CODE'))){
		        			Unilite.messageBox('신규 품목코드 값이 없습니다.');
		        			return false;
		        		}else if(!Ext.isEmpty(detailForm.getValue('ITEM_CODE'))){
		        			Unilite.messageBox('이미 품목코드 값이 입력되어있습니다.');
		        			return false;
		        		}else{
	        				var param = {
	                        	"AUTO_MAN": detailForm.getValue('AUTO_MAN'),
	                        	"LAST_SEQ": detailForm.getValue('LAST_SEQ')
	        				};

			                s_bpr110ukrv_novisService.saveAutoItemCode(param, function(provider, response)  {
			                    if(!Ext.isEmpty(provider)){
			                        if(provider=='Y'){


										detailForm.setValue('ITEM_CODE',detailForm.getValue('AUTO_ITEM_CODE'));
										detailForm.setValue('ITEM_ACCOUNT',detailForm.getValue('AUTO_ITEM_ACCOUNT'),false);

										detailForm.setValue('ITEM_NAME',detailForm.getValue('AUTO_ITEM_NAME'));

										detailForm.getField('ITEM_CODE').setReadOnly(true);
										detailForm.getField('ITEM_ACCOUNT').setReadOnly(true);


			                    	}else{
			                    	    Unilite.messageBox( "확정 실패");
			                    	}
			                    }else{
			                        Unilite.messageBox( "확정 실패");
			                    }
				        	});
				        	
		        		}
		        	}
	        	}]
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
				labelWidth:138,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

						detailForm.setValue('ITEM_NAME',newValue);
					}
				}
//
			}
			]
		}]
	}

