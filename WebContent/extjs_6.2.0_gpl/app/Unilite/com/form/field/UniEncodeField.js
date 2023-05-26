//@charset UTF-8
 /**
  * Unilite용 암호화데이타 표시 필드
  */
Ext.define('Unilite.com.form.field.UniEncodeField', {
	extend: 'Unilite.com.form.field.UniTextField',
    alias: 'widget.uniEncodeField',
    mixins: {
        uniBaseField: 'Unilite.com.form.field.UniBaseField'
    },
    uniOpt:{
    	clickToPopup:true
    },
    vtype: 'uniEncode',
    inputType:'password',
    parentType:'form',
    constructor : function(config){    
        var me = this;
       	
        if (config) {
            Ext.apply(me, config);
        }
        
        this.callParent([config]);
 	},
	initComponent: function () {
		var me = this;
	 	this.callParent();
    	if(me.uniOpt.clickToPopup)	{
    		//this.on('afterrender', this.onRender);
    	}
	},
	/**
	 * returnData : 
	 */
	onRender:function(field)	{
		var me = this;
		field.on('click',me.onOpenPopup);
	}, 
	onOpenPopup:function()	{
		var me = this;
		var encodeWin ;
		var returnObjType = me.parentType;
		var returnData ;
		if(returnObjType == "form")	{
			returnData = me.up("form");
		} else {
			returnData = me.up("gridpanel").uniOpt.currentRecord;
		}
        if(!encodeWin) {
            encodeWin = Ext.create('widget.uniDetailWindow', {
                title: me.fieldName,
                width: 400,				                
                height:400,
            	'returnData'	: returnData,
			    'returnObjType'	: returnObjType,
			    'fieldName' 	: me.name,
                layout: {type:'vbox', align:'stretch'},	                
                items: [{
	                	itemId:'search',
	                	xtype:'uniSearchForm',
	                	layout:{type:'uniTable',columns:2},
	                	items:[
	                		{	
	                			fieldLabel:me.fieldLabel,
	                			labelWidth:60,
	                			name :'DECODE_VALUE',
	                			width:250
	                		}
	                	]
               	}],
                tbar:  [
			         '->',{
						itemId : 'closeBtn',
						text: '확인',
						handler: function() {
							var windowPanel = me;
							var form = windowPanel.down('#search');
							if(returnObjType == "record")	{
								panel.returnData.get(form.getValue("DECODE_VALUE"));
							}
							if(returnObjType == "form")	{
								panel.returnData.setValue(form.getValue("DECODE_VALUE"));
							}
							windowPanel.close();
						}
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							var windowPanel = me;
							windowPanel.close();
						},
						disabled: false
					}
			    ],
				listeners : {beforehide: function(panel, eOpt)	{
								panel.down('#search').clearForm();
                			},
                			 beforeclose: function( panel, eOpts )	{
								encodeWin.down('#search').clearForm();
                			},
                			 show: function( panel, eOpts )	{
								var form = panel.down('#search');
								form.clearForm();
								if(returnObjType == "record")	{
									form.setValue(panel.returnData.get(panel.fieldName));
								}
								if(returnObjType == "form")	{
									form.setValue(panel.returnData.getValue(panel.fieldName));
								}
                			 }
                }		
			});

			}
	}
});
