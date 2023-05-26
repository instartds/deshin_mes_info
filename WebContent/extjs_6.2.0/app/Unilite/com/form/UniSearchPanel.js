//@charset UTF-8
Ext.define('Unilite.com.form.UniSearchPanel', {
	extend : 'Unilite.com.form.UniAbstractForm',
	alias : 'widget.uniSearchPanel',
	defaultType : 'uniTextfield',
    region:'west', 
    padding: '1 1 1 1',
    split:{size: 0.5},
    width:350,
    border: true,
    collapsible: false, 

    autoScroll:true,
    collapseDirection: 'left',
    layout: {type: 'vbox', align:'stretch'},
    
	constructor: function(config) {
        var me = this;
        config = config || {};
        //config.trackResetOnLoad = true;
        config.collapsed= UserInfo.appOption.collapseLeftSearch;
        
    	config.animCollapse= false;
        var clapseTool= {
	        region:'west',
	        type: 'left',   
	        itemId:'left',
	        tooltip: 'Hide',
	        handler: function(event, toolEl, panelHeader) {
	                    me.collapse(); 
	                }
	        };
	    config.tools=[clapseTool];
        me.callParent([config]);
    },
	defaults : {
		listeners: {
			specialkey: function(field, e){
				// e.HOME, e.END, e.PAGE_UP, e.PAGE_DOWN,
                // e.TAB, e.ESC, arrow keys: e.LEFT, e.RIGHT, e.UP, e.DOWN
//                if (e.getKey() == e.ENTER) {
//					console.log("keyDown");
//					var app = UniAppManager.getApp();
//                	app.onQueryButtonDown();
//                }
			}
		}
	},
    enableKeyEvents: true,
	initComponent : function(){  
    	var me  = this;
    	  	
        me.on('beforerender',this._onAfterRenderFunction , this);
        
        if(UserInfo && UserInfo.appOption) {	//설정 메뉴->검색창 접기 설정값 적용
    		Ext.apply(me, {
	        	collapsed: UserInfo.appOption.collapseLeftSearch
	        })
    	}
    	
    	me.callParent();   	
	},
	
	setAllFieldsReadOnly: function(flag) {
		var r= true
		if(flag) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
																return !field.validate();
															});
			if(invalid.length > 0) {
				r=false;
				var labelText = ''

				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+UniUtils.getMessage('system.message.commonJS..invalidText','은(는) 필수입력 항목입니다.');
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+UniUtils.getMessage('system.message.commonJS..invalidText','은(는) 필수입력 항목입니다.');
				}

			   	Unilite.messageBox(labelText);
			   	invalid.items[0].focus();
			} else {
				//this.mask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(true); 
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;							
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				})
			}
  		} else {
			//this.unmask();
  			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) )	{
				 	if (item.holdable == 'hold') {
						item.setReadOnly(false); 
					}
				} 
				if(item.isPopupField)	{
					var popupFC = item.up('uniPopupField')	;	
					if(popupFC.holdable == 'hold' ) {
						item.setReadOnly(false);
					}
				}
			})
		}
		return r;
  	},
  	
  	saveForm: function()	{
  		var me = this;
		var paramMaster = me.getValues();
		me.getForm().submit({
		    
		    success:function()	{
	    		me.getForm().wasDirty = false;
				me.resetDirtyStatus();
				console.log("set was dirty to false");
				UniAppManager.setToolbarButtons('save', false);		
		    }
		})
	}
});
