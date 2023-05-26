<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%

request.setAttribute("PKGNAME","Unilite.app.popup.DecryptComPopup");
%>

Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    uniOpt:{
    	btnQueryHide:true,
    	btnSubmitHide:true,
    	btnCloseHide:true
    },
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
		me.panelSearch =  Unilite.createSearchForm('searchPanel',{
		    layout : {type : 'uniTable', columns : 1},
//		    border:true,
		    padding: '1 1 1 1',
		    items: [{
				    	fieldLabel: '<t:message code="system.label.common.decryption" default="복호화"/>',
				    	id:'fieldNm',
				    	width: 326,
				    	name:'DECRYP_WORD',
				    	readOnly:true
				    },{
						fieldLabel: '',
				    	name:'INCRYP_WORD',
				    	hidden: true
				    },{
						fieldLabel: '<t:message code="system.label.common.incryptype" default="암호화구분"/>',
				    	name:'INCDRC_GUBUN',
				    	hidden: true
				    }
		    ]
		});

		config.items = [me.panelSearch];
     	me.callParent(arguments);
    },
	initComponent : function(){
    	var me  = this;

        me.panelSearch.focus();

    	this.callParent();
    },
	fnInitBinding : function(param) {
		var me = this;

		var frm = me.panelSearch;
		
		if(!Ext.isEmpty(param['INCRYP_WORD'])){

	        frm.setValue('INCDRC_GUBUN', 'DEC');
	        frm.setValue('INCRYP_WORD', param['INCRYP_WORD']);

	        this.fnDecrypt();
		}

//		this._dataLoad();
	},
//	_dataLoad : function() {
//		var me = this;
//		var param= me.panelSearch.getValues();
//		console.log( "_dataLoad: ", param );
//		me.panelSearch.getForm().load({
//			params : param
//		});
//	},

	fnDecrypt: function() {
		var me = this;
		var param= me.panelSearch.getValues();
		me.isLoading = true;
		popupService.decryptPopup(param, function(provider, response)	{
			me.isLoading = false;
			if(!Ext.isEmpty(provider)){
				me.panelSearch.setValue('DECRYP_WORD', provider);
			}
		})
	}

});
