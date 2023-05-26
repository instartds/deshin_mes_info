<%@page language="java" contentType="text/html; charset=utf-8"%>
    <%
        String aaa = request.getParameter("aaa");
 
    %>
 
var autoFieldset = {
	layout: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	defaultType: 'uniFieldset',
	masterGrid: masterGrid,
	defaults: { padding: '10 15 15 10'},
	colspan: 3,
	border		: false,						//20210909 추가
	id: 'autoCodeFieldset',
//			hidden:true,
	items: [{
		title: '품목코드 채번 (코디)',
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
					var param = {
						"AUTO_ITEM_ACCOUNT" : newValue,
						"AUTO_SUPPLY_TYPE" : detailForm.getValue('AUTO_SUPPLY_TYPE')
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

					}
				}
			}


		},{
			fieldLabel: '조달구분',
			name: 'AUTO_SUPPLY_TYPE',
			colspan: 2,
			xtype		: 'uniCombobox'	,
			comboType	: 'AU',
			comboCode	: 'B014',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var param = {
						"AUTO_ITEM_ACCOUNT" : detailForm.getValue('AUTO_ITEM_ACCOUNT'),
						"AUTO_SUPPLY_TYPE" : detailForm.getValue('AUTO_SUPPLY_TYPE')
					};					
					if(!Ext.isEmpty(newValue)){
						detailForm.setValue('SUPPLY_TYPE',newValue);
						
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
					}
				}
			}			
		},{
			xtype:'uniTextfield',
			fieldLabel:'최종품목코드',
			name:'LAST_ITEM_CODE',
//			labelWidth:138,
			readOnly:true

		},{
			xtype:'uniTextfield',
			fieldLabel:'신규품목코드',
			colspan: 2,
			name:'AUTO_ITEM_CODE',
			readOnly:true

		},{
			xtype:'uniTextfield',
			fieldLabel:'신규품명',
			name:'AUTO_ITEM_NAME',
//			width:550,
			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

					detailForm.setValue('ITEM_NAME',newValue);
				}
			}
		},{
			xtype: 'container',
			layout: {type : 'table', columns : 1},
			tdAttrs: {align: 'right'},
			width:150,
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

		                bpr300ukrvService.saveAutoItemCode(param, function(provider, response)  {
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
			        	})
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
		}
		]
	}]
}

