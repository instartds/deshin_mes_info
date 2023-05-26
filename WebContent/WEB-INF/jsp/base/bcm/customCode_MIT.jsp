<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");

    %>

	{	title		: '신규 거래처코드 채번(엠아이텍)',
						defaultType: 'uniTextfield',
						flex		: 1,
						id          : 'autoCustomCodeFieldset',
						defaults	: { labelWidth: 125},
						layout		: {
							type		: 'uniTable',
							tableAttrs	: { style: { width: '100%' } },
			//				tdAttrs		: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/},
							columns		: 3
						},
						items :[{
									fieldLabel	: '<t:message code="system.label.base.classfication" default="구분"/>',
									name		: 'CUSTOM_TYPE_NEW',
									xtype		: 'uniCombobox',
									comboType	: 'AU',
									comboCode	: 'Z015' ,
									allowBlank	: true,
									width:300,
									listeners	: {
										change: function(field, newValue, oldValue, eOpts) {
											var param = {
													"CUSTOM_TYPE" : newValue
											};
											if(!Ext.isEmpty(newValue)){
												bcm106ukrvService.selectAutoCustomCodeSite(param, function(provider, response) {
													if(!Ext.isEmpty(provider))	{
															detailForm.setValue('AUTO_CUSTOM_CODE', provider.AUTO_CUSTOM_CODE);
															detailForm.setValue('CUSTOM_CODE',detailForm.getValue('AUTO_CUSTOM_CODE'));

													}else{
														detailForm.setValue('AUTO_CUSTOM_CODE','');

													}
												})

											}
										},render:function(field)	{
											detailForm.getField('CUSTOM_CODE').setReadOnly(true);
										}
									}
								},{
									fieldLabel	: '신규 거래처코드',
									name		: 'AUTO_CUSTOM_CODE' ,
									margin : '0 30 0 0',
									allowBlank	: true,
									readOnly	: true
								},{
						        	xtype:'button',
						        	text:'코드 재확인',
						    		width: 100,
						    		margin : '0 30 0 0',
						        	handler:function(){
										   var customTypeNew = detailForm.getValue('CUSTOM_TYPE_NEW');
											if(!Ext.isEmpty(detailForm.getValue('CUSTOM_TYPE_NEW'))){
												var param = {
														"CUSTOM_TYPE" : customTypeNew
												};
												bcm106ukrvService.selectAutoCustomCodeSite(param, function(provider, response) {
													if(!Ext.isEmpty(provider))	{
															detailForm.setValue('AUTO_CUSTOM_CODE', provider.AUTO_CUSTOM_CODE);
															detailForm.setValue('CUSTOM_CODE',detailForm.getValue('AUTO_CUSTOM_CODE'));
													}else{
														detailForm.setValue('AUTO_CUSTOM_CODE','');
													}
												})

											}

						        	}
					        	}]
			},

