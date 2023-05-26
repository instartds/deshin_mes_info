<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");

    %>

	{	title		: '신규 거래처코드 채번(노비스바이오)',
						defaultType: 'uniTextfield',
						flex		: 1,
						id          : 'autoCustomCodeFieldset',
						defaults	: { labelWidth: 120},
						layout		: {
							type		: 'uniTable',
							tableAttrs	: { style: { width: '100%' } },
			//				tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
							columns		: 2
						},
						items :[{
									fieldLabel	: '<t:message code="system.label.base.classfication" default="구분"/>',
									name		: 'CUSTOM_TYPE_NEW',
									xtype		: 'uniCombobox',
									comboType	: 'AU',
									comboCode	: 'B015' ,
									allowBlank	: true,
									listeners	: {
										change: function(field, newValue, oldValue, eOpts) {
										var param = {
												"CUSTOM_TYPE" : newValue
											};
											if(!Ext.isEmpty(newValue)){
												bcm106ukrvService.selectAutoCustomCode(param, function(provider, response) {
													if(!Ext.isEmpty(provider))	{
														detailForm.setValue('AUTO_CUSTOM_CODE', provider.AUTO_CUSTOM_CODE);
														detailForm.setValue('LAST_CUSTOM_CODE', provider.LAST_CUSTOM_CODE.substring(1));

														detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
														detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);

													}else{
														detailForm.setValue('AUTO_CUSTOM_CODE','');
														detailForm.setValue('LAST_CUSTOM_CODE','');

														detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
														detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);

													}
												})

											}
										}
									}
								},{
									fieldLabel	: '최종 순번',
									name		: 'LAST_CUSTOM_CODE' ,
									margin : '0 0 0 -130',
		//							allowBlank	: false,
									readOnly	: true
								},{
									fieldLabel	: '신규 거래처코드',
									name		: 'AUTO_CUSTOM_CODE' ,
									margin : '0 0 0 0',
		//							allowBlank	: false,
									readOnly	: true
								},{
						        	xtype:'button',
						        	text:'채번 확정',
						    		width: 100,
						    		margin : '0 0 0 -5',
						        	handler:function(){
						        		if(Ext.isEmpty(detailForm.getValue('CUSTOM_TYPE_NEW'))){
						        			Unilite.messageBox('신규 거래처 구분 값이 없습니다.');
						        			return false;
						        		}else if(Ext.isEmpty(detailForm.getValue('AUTO_CUSTOM_CODE'))){
						        			Unilite.messageBox('신규 거래처 코드 값이 없습니다.');
						        			return false;
						        		}else if(!Ext.isEmpty(detailForm.getValue('CUSTOM_CODE'))){
						        			Unilite.messageBox('이미 거래처 코드 값이 입력되어있습니다.');
						        			return false;
						        		}else{
					        				var param = {
					                        	"AUTO_MAN": detailForm.getValue('AUTO_MAN'),
					                        	"LAST_SEQ": detailForm.getValue('LAST_SEQ')
					        				};

					        				bcm106ukrvService.saveAutoCustomCode(param, function(provider, response)  {
							                    if(!Ext.isEmpty(provider)){
							                        if(provider=='Y'){

														detailForm.setValue('CUSTOM_CODE',detailForm.getValue('AUTO_CUSTOM_CODE'));
														detailForm.setValue('CUSTOM_TYPE',detailForm.getValue('CUSTOM_TYPE_NEW'));

														detailForm.getField('CUSTOM_CODE').setReadOnly(true);
														detailForm.getField('CUSTOM_TYPE').setReadOnly(true);

							                    	}else{
							                    	    Unilite.messageBox( "확정 실패");
							                    	}
							                    }else{
							                        Unilite.messageBox( "확정 실패");
							                    }
								        	})
						        		}
						        	}
					        	},{
									fieldLabel	: 'LAST_SEQ',
									name		: 'LAST_SEQ' ,
									margin : '0 0 0 0',
									readOnly	: true,
									hidden: true
								},{
									fieldLabel	: 'AUTO_MAN',
									name		: 'AUTO_MAN' ,
									margin : '0 0 0 0',
									readOnly	: true,
									hidden: true
								}]
			},

