<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 거래처팝업
request.setAttribute("PKGNAME","Unilite.app.popup.GridNewConfigPopup");
%>
<t:ExtComboStore useScriptTag="false" items="${TYPE_STORE}" storeId="TYPE_STORE" />


/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupGridApp',    
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
	    /**
	     * 검색조건 (Search Panel)
	     * @type 
	     */
	    var wParam = this.param;

		me.detailForm = Unilite.createForm( '', {
			disabled:false,
		    layout: {
	            type: 'uniTable',
	            columns: 1
			},	
			padding:0,
			api: {
         		 submit: extJsStateProviderService.saveState
			},
		    items: [{
		            fieldLabel: '<t:message code="system.label.common.type" default="유형"/>',
		            name: 'SHT_TYPE',
		            value: 'P',
		            hidden: true
		        },{
		            fieldLabel: '',
		            name: 'CHECK_UPDATE',
		            value: 'N',
		            hidden: true
		        },{
		            fieldLabel: '<t:message code="system.label.common.basicsetting" default="기본설정"/>',
		            name: 'DEFAULT_YN',
		            value: 'Y',
		            hidden: true
		        }, {
		            fieldLabel: '<t:message code="system.label.common.quicklist" default="빠른목록"/>',
		            name: 'QLIST_YN',
		            value: 'Y',
		            hidden: true
		        }, {
		            fieldLabel: '그리드 설정명',//'<t:message code="system.label.common.settingsname" default="설정명"/>',
		            labelWidth: 100,
		            name: 'SHT_NAME',
		            allowBlank: false,
		            width: 490
		        }, {
		            fieldLabel: '그리드 설정 내용',//'<t:message code="system.label.common.desc" default="설명"/>',
		            labelWidth: 100,
		            name: 'SHT_DESC',
		            width: 490
		        }, {
		            fieldLabel: 'USERID',
		            name: 'USER_ID',
		            allowBlank: false,
		            hidden: true
		        }, {
		            fieldLabel: '<t:message code="system.label.common.programid" default="프로그램ID"/>',
		            name: 'PGM_ID',
		            allowBlank: false,
		            hidden: true
		        }, {
		            fieldLabel: '<t:message code="system.label.common.gridid" default="그리드ID"/>',
		            name: 'SHT_ID',
		            allowBlank: false,
		            hidden: true
		        }, {
		            fieldLabel: '<t:message code="system.label.common.settings" default="설정"/>SEQ',
		            name: 'SHT_SEQ',
		            value: 0,
		            hidden: true
		        }, {
		            fieldLabel: '<t:message code="system.label.common.gridinfo" default="그리드정보"/>',
		            name: 'SHT_INFO',
		            allowBlank: false,
		            hidden: true
		        }, {
		            fieldLabel: '<t:message code="system.label.common.gridcolumninfo" default="그리드컬럼정보"/>',
		            name: 'COLUMN_INFO',
		            allowBlank: false,
		            hidden: true
		        }, {
		            fieldLabel: '<t:message code="system.label.common.gridbaseinfo" default="기본설정"/>',
		            name: 'BASE_SHT_INFO',
		            allowBlank: false,
		            hidden: true
		        }]
		});  
		
		
		config.items = [me.detailForm];
		me.callParent(arguments);
		
    },
    initComponent : function(){    
    	var me  = this;
        

    	this.callParent();    	
    },
	fnInitBinding : function(param) {
		var me = this;
		var detailForm = me.detailForm;
		me.onResetButtonDown();
		detailForm.setValue('USER_ID', 	UserInfo.userID);
		detailForm.setValue('PGM_ID', 	param.PGM_ID);
		detailForm.setValue('SHT_ID', 	param.SHT_ID);
		detailForm.setValue('SHT_INFO', param.SHT_INFO);
		detailForm.setValue('SHT_SEQ', 	param.SHT_SEQ);
		detailForm.setValue('BASE_SHT_INFO', 	Ext.encode(param.BASE_SHT_INFO));
		detailForm.setValue('COLUMN_INFO'  , 	Ext.encode(param.COLUMN_INFO));
		detailForm.setValue('SHT_TYPE', 'P');
		
		if(param.SHT_SEQ != 0)	{
			extJsStateProviderService.selectStateCheck(param, function(responseText, response){
				if(responseText.SHT_SEQ == param.SHT_SEQ)	{
					if(confirm('<t:message code="system.message.common.gridStateDuppicate" default="그리드 설정 정보를 변경 하시겠습니까?"/>'+ '\n'
		                            					+UniUtils.getLabel('system.message.commonJS.grid.stateDeleteConfirm','확인 : 현 그리드 설정에 덮어쓰기')+ '\n'
		                            					+UniUtils.getLabel('system.message.commonJS.grid.stateDeleteCancel','취소 : 새 그리드 설정에 저장하기')))	{
						detailForm.setValue('SHT_NAME', responseText.SHT_NAME);
						detailForm.setValue('SHT_DESC', responseText.SHT_DESC);
						detailForm.setValue('CHECK_UPDATE', 'Y');
					} else {
						if(detailForm)	{
							detailForm.setValue('SHT_SEQ', 0);
						}
					}
				}
			});
		}
		me.setToolbarButtons(['save'],true);
		//me.setToolbarButtons(['query','delete'],false);
	},
	onSaveDataButtonDown: function () {
		console.log('Save');
        var me = this;
        var detailForm = me.detailForm;		
        var userId = UserInfo.userID;
        var rt = true;
		if(detailForm.isValid() ) {
			var checkParam = me.detailForm.getValues();
           		if(me.detailForm.getValue('CHECK_UPDATE')!= 'Y'){
           			checkParam.SHT_SEQ = null;
           			me.getEl().mask();
           			
            		extJsStateProviderService.selectStateCheck(checkParam, function(responseText, response){
            			var pName = checkParam.SHT_NAME;
						if(responseText && responseText.SHT_NAME == pName)	{
							if(confirm('<t:message code="system.message.common.gridStateDuppicate2" default="같은 이름의 설정정보가 있습니다. 그리드 설정 정보를 변경 하시겠습니까?"/>'))	{
								me.detailForm.setValue('SHT_SEQ', responseText.SHT_SEQ);
								me.detailForm.setValue('CHECK_UPDATE', 'Y');
								rt = true;
							} else {
								me.detailForm.setValue('SHT_NAME', '');
								me.detailForm.setValue('SHT_SEQ', 0);
								rt = false;
								field.focus();
							}
						}
						
					});
           		}
				if(rt)	{
					var param= detailForm.getValues();
					detailForm.getForm().submit({
						 params : param,
						 success : function(form, action) {
						 	me._onSaved(action);
	//					 	me.setToolbarButtons(['save'],false);
						 }
					});
				}
				me.getEl().unmask();
				Ext.getBody().unmask();
			}else{
				Ext.getBody().unmask();
				var rt = detailForm.checkManadatory(['USER_ID','PGM_ID','SHT_ID','SHT_SEQ','SHT_INFO']);
				if( rt !== true) {
					alert(Msg.sMB113);
				}else {
					alert(Msg.sMB083);
				}
			}
	},
	_onSaved: function(action) {
//		me.setToolbarButtons(['save'],false);
        var me = this;
        var detailForm = me.detailForm;
        
		detailForm.setValue("SHT_SEQ", action.result.SHT_SEQ);

        UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
        Ext.getBody().unmask();
        
        var grid = Ext.getCmp(detailForm.getValue('SHT_ID'));
        if(me.param.MODE == 'save') {        	
        	grid.fireEvent('statelistchange', grid, detailForm.getValue('SHT_SEQ'));
        	grid.fireEvent('statelistselect', grid, detailForm.getValues());
        	me.close();
        }else{
        	grid.fireEvent('statelistchange', grid, "");
        }
	},
	onResetButtonDown: function()	{
		var me = this;
        var detailForm = me.detailForm;
		
		detailForm.setValue('SHT_NAME', 	'');
		detailForm.setValue('SHT_DESC', 	'');
		detailForm.setValue('SHT_TYPE', 	'');
	}
});