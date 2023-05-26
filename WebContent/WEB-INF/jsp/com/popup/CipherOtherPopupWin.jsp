<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 암호화팝업
request.setAttribute("PKGNAME","Unilite.app.popup.CipherOtherPopup");
%>

		
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    uniOpt:{
    	btnQueryHide:true,
    	btnSubmitHide:false,
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
/**
 * 검색조건 (Search Panel)
 * @type 
 */

		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 1, tableAttrs: {
		        style: {
		            width: '120%'
		        }
		    }},		 
		    items: [{
				    	fieldLabel: '<t:message code="system.label.common.input" default="입력"/>',
				    	width: 326,
				    	name:'DECRYPT',
				    	listeners:{
				    		change:function()	{
				    			me.panelSearch.setValue("CRYPTGBN", "ToEncrypt");
				    		}
				    	}
				    },{
						fieldLabel: '',
				    	name:'INC_WORD',
				    	hidden: true
				    },{
						fieldLabel: '<t:message code="system.label.common.incryptype" default="암호화구분"/>',
				    	name:'CRYPTGBN',
				    	hidden: true
				    }
		    ],
            api: {
            	load: 'popupService.encryptPopup'
            }
		});  
		
		
		
		//config.items = [me.panelSearch,	me.masterGrid];
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
		
		if(!Ext.isEmpty(param)){
			if(param['ENCRYPT'])	{
		        frm.setValue('INC_WORD', param['ENCRYPT']);
		        frm.setValue('CRYPTGBN', "ToDecrypt");
		        this.onSubmitButtonDown();
	        }
		}
	},
	 onQueryButtonDown : function()	{
		
	},
	onSubmitButtonDown : function()	{
        var me = this;
        var param = me.panelSearch.getValues();
        me.isLoading = true;
        if(me.panelSearch.getValue('CRYPTGBN') != "")	{
	        popupService.encryptPopup(param, function(provider, response)	{
	        	me.isLoading = false;
				if(!Ext.isEmpty(provider)){
					if(param.CRYPTGBN=="ToDecrypt")	{
						me.panelSearch.setValue('DECRYPT', provider);
						me.panelSearch.setValue('CRYPTGBN', "");
						
					}else{
						me.panelSearch.setValue('INC_WORD', provider);
						me.panelSearch.setValue('CRYPTGBN', "");
						me.submitData();	
						me.close();
					}
							
				}
			})
		}
      		
	},
	submitData: function() {	
		var me = this;
		var encrypt= me.panelSearch.getValue("INC_WORD");
		if(!Ext.isEmpty(encrypt)){
				rv = {
					status : "OK",
					data : [{INC_WORD:encrypt}]			
				};
				me.returnData(rv);
		}		
	}
	
});
