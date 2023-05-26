// @charset UTF-8
Ext.define('Unilite.com.form.UniSearchSubPanel', {
			extend : 'Ext.panel.Panel',
			alias : 'widget.uniSearchSubPanel',
			defaultType : 'uniTextfield',
			collapsible : true,
			titleCollapse : true,
			hideCollapseTool : true,
            cls: 'uniSearchSubPanel',
			bodyStyle : {
				'border-width' : '0px',
				'spacing-bottom' : '3px'
			},
			header : {
				xtype : 'header',
				style : {
					'background-color' : '#D9E7F8',
					'background-image' : 'none',
					'color' : '#333333',
					'font-weight' : 'normal',
					'border-width' : '0px',
					'spacing' : '5px'
				}
			}
		});

Ext.define('Unilite.human.ImageListPanel', {
	extend : 'Ext.view.View',
	alias : 'widget.humImageListPanel',
    tpl: [
            '<tpl for=".">',
                '<div class="thumb-wrap">',
                    '<div class="thumb"><img src="'+CPATH+'/uploads/employeePhoto/{PERSON_NUMB}?_dc={dc}" title="{NAME:htmlEncode}" width="100"></div>',
                    '<span class="x-editable">{NAME:htmlEncode}</span>',
                '</div>',
            '</tpl>',
            '<div class="x-clear"></div>'
        ],        
//        this.down('#EmpImg').getEl().dom.src=CPATH+'/human/viewPhoto.do?personNumb='+data['PERSON_NUMB'];
        trackOver: true,
        frame:true,
        overItemCls: 'x-item-over',
        itemSelector: 'div.thumb-wrap',
        emptyText: 'No images to display'
});
