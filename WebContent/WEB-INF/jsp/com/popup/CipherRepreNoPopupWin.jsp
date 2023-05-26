<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 부서팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CipherRepreNoPopup");
%>



	/**
	 *   Model 정의
	 * @type
	 */
Unilite.defineModel('${PKGNAME}CipherPopupModel', {
    extend: 'Ext.data.Model',
    fields: [ 	 {name: 'INCRYP_WORD' 		,text:'<t:message code="system.label.common.incrypword" default="암호화단어"/>'     ,type:'string'	}
				,{name: 'DECRYP_WORD' 		,text:'<t:message code="system.label.common.decrypword" default="복호화단어"/>' 		,type:'string'	}
		    ]
});

var createLocation = '' ;
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    uniOpt:{
    	btnQueryHide:true,
    	btnSubmitHide:true,
    	btnCloseHide:false
    },
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
	    var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['TYPE'] == 'VALUE') {
	            t1 = true;
	            t2 = false;

	        } else {
	            t1 = false;
	            t2 = true;

	        }
	    }

	    var inputYn = wParam.INPUT_YN;
		if(Ext.isEmpty(inputYn)){
			inputYn = 'Y';
		}
		if(inputYn == 'Y'){
			this.uniOpt.btnSubmitHide = false;

		}else{
			this.uniOpt.btnSubmitHide  = true;
		}

		//'************' 로 표시된 값을 복호화된 값으로 셋팅
		var oriValue = wParam.ORI_VALUE;
		if(Ext.isEmpty(oriValue)){
            oriValue = '';
        }

	    createLocation = wParam.CREATE_LOCATION;

/**
 * 검색조건 (Search Panel)
 * @type
 */

		me.panelSearch =  Unilite.createSearchForm('searchPanel',{
		    layout : {type : 'table', columns : 1, tableAttrs: {
		        style: {
		            width: '120%'
		        }
		    }},
		    items: [{
				    	fieldLabel: '<t:message code="system.label.common.reprenum" default="주민등록번호"/>',
				    	id:'fieldNm',
				    	width: 326,
				    	name:'DECRYP_WORD',
				    	value:oriValue,
				    	listeners : {
										blur: function(field, The, eOpts)	{
											var newValue = field.getValue().replace(/-/g,'');
											if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
										 		alert(Msg.sMB074);
										 		this.setValue('');
										 		return ;
										 	}
						  					if(Unilite.validate('residentno',newValue) != true && !Ext.isEmpty(newValue))	{
										 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{
										 			field.setValue(field.originalValue);
										 			return;
										 		}
										 	}
										}
									}
				    },{
						fieldLabel: '',
				    	name:'INCRYP_WORD',
				    	hidden: true
				    },{
						fieldLabel: '<t:message code="system.label.common.incryptype" default="암호화구분"/>',
				    	name:'INCDRC_GUBUN',
				    	hidden: true
				    }
		    ],
            api: {
            	load: 'popupService.incryptDecryptPopup'
            }
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

		/*
		if(param.LABEL_GUBUN =='1'){
			Ext.getCmp('fieldNm').setFieldLabel('주민등록번호');

		}else if(param.LABEL_GUBUN =='2'){
			Ext.getCmp('fieldNm').setFieldLabel('외국인등록번호');

		}else{
			Ext.getCmp('fieldNm').setFieldLabel('');
		}
		*/
		var frm = me.panelSearch;
	    var inputYn = param.INPUT_YN;

		if(inputYn == 'Y'){
			frm.getField('DECRYP_WORD').setReadOnly(false);
//			frm.getField('DECRYP_WORD').enable();

		}else{
			frm.getField('DECRYP_WORD').setReadOnly(true);
//			frm.getField('DECRYP_WORD').disable();

		}
		//alert(param['REPRE_NO']);
		if(!Ext.isEmpty(param['REPRE_NUM'])){

	        frm.setValue('INCDRC_GUBUN', 'DEC');
	        frm.setValue('INCRYP_WORD', param['REPRE_NUM']);

	        this.fnIncryptDecrypt();
		}

		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
        var decryptWd = me.panelSearch.getValue('DECRYP_WORD');
		if(Ext.isEmpty(createLocation)){
		        if(Ext.isEmpty(decryptWd)){
		        	me.panelSearch.setValue('INCRYP_WORD', '');
					rv = {
						status : "OK",
						data : [{INC_WORD:''}]
					};
					me.returnData(rv);
		        }else{
			        me.panelSearch.setValue('INCDRC_GUBUN', 'INC');
			        this.fnIncryptDecrypt();
		        }
		}else{
		    me.panelSearch.setValue('INCDRC_GUBUN', 'DEC');
	       	var decryptWord = me.panelSearch.getValue('DECRYP_WORD');
	       	me.panelSearch.setValue('INCRYP_WORD', decryptWord);
					rv = {
						status : "OK",
						data : [{INC_WORD:decryptWord}]
					};
			me.returnData(rv);
		}

	},

	_dataLoad : function() {
		var me = this;
		var param= me.panelSearch.getValues();
		console.log( "_dataLoad: ", param );
		me.panelSearch.getForm().load({
			params : param
		});
	},

	fnIncryptDecrypt: function() {
		var me = this;
		var param= me.panelSearch.getValues();
		
		popupService.incryptDecryptPopup(param, function(provider, response)	{
			
			if(!Ext.isEmpty(provider)){
				//alert(provider);
				if(me.panelSearch.getValue('INCDRC_GUBUN') == 'INC'){
					me.panelSearch.setValue('INCRYP_WORD', provider);
					rv = {
						status : "OK",
						data : [{INC_WORD:provider}]
					};
					me.returnData(rv);
				}else{
					me.panelSearch.setValue('DECRYP_WORD', provider);
				}

			}
		})
	}

});
