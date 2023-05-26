<%@page language="java" contentType="text/html; charset=utf-8"%>

<script type="text/javascript" >
            
// Ext.onReady(function() {});


function appMain() {
	
		var tbar = Ext.create('Ext.toolbar.Toolbar', {
	    width   : 500,
	    items: [
	        {
	            // xtype: 'button', // default for Toolbars
	        	iconCls: 'icon-save',
	            text: 'Button',
	            handler: function(){
	            	alert('hi');
	            }
	            
	        },
	        {
	            xtype: 'splitbutton',
	            text : 'Split Button'
	        },
	        // begin using the right-justified button container
	        '->', // same as { xtype: 'tbfill' }
	        {
	            xtype    : 'textfield',
	            name     : 'field1',
	            emptyText: 'enter search term'
	        },
	        // add a vertical separator bar between toolbar items
	        '-', // same as {xtype: 'tbseparator'} to create Ext.toolbar.Separator
	        'text 1', // same as {xtype: 'tbtext', text: 'text1'} to create Ext.toolbar.TextItem
	        { xtype: 'tbspacer' },// same as ' ' to create Ext.toolbar.Spacer
	        'text 2',
	        { xtype: 'tbspacer', width: 50 }, // add a 50px space
	        'text 3'
	    ]
	});	
	
	Ext.create('Ext.data.Store', {
    storeId:'simpsonsStore',
    fields:['name', 'email', 'phone'],
    data:{'items':[
        { 'name': 'Lisa',  "email":"lisa@simpsons.com",  "phone":"555-111-1224"  },
        { 'name': 'Bart',  "email":"bart@simpsons.com",  "phone":"555-222-1234" },
        { 'name': 'Homer', "email":"home@simpsons.com",  "phone":"555-222-1244"  },
        { 'name': 'Marge', "email":"marge@simpsons.com", "phone":"555-222-1254"  }
    ]},
    proxy: {
        type: 'memory',
        reader: {
            type: 'json',
            root: 'items'
        }
    }
	});

	var grid1 = Ext.create('Ext.grid.Panel', {
    title: 'Simpsons',
    store: Ext.data.StoreManager.lookup('simpsonsStore'),
    columns: [
        { text: 'Name',  dataIndex: 'name' },
        { text: 'Email', dataIndex: 'email', flex: 1 },
        { text: 'Phone', dataIndex: 'phone' }
    ],
    listeners:{
    	selectionchange: function(grid, selected, eOpts){
    		console.log('test');
    	}
    }
	});
	
	var panel = Ext.create('Ext.form.Panel',{
		id: 'main-panel',
		width: '100%',
		padding: '5 5 0 5',
		layout:{type: 'vbox'},
		defaultType: 'textfield',
		bbar: tbar,
		items: [
			{ title: '기본정보',
			xtype:'fieldset',
			defaultType: 'textfield',
			layout:'hbox',			
			items: [
				{fieldLabel:'item1-1', name:'x01-1', allowBlank: false, labelAlign:'right'},
				{fieldLabel:'item1-2', name:'x01-1', labelAlign:'right'},
				{fieldLabel:'item1-3', name:'x01-1', labelAlign:'right'}
			]},
			{ title: '계획',
			xtype:'fieldset',
			defaultType: 'textfield',
			layout:'hbox',
			labelAlign:'right',
			items: [
				{fieldLabel:'item2-1', name:'x02-1', allowBlank: false, labelAlign:'right'},
				{fieldLabel:'item2-2', name:'x02-2', labelAlign:'right'},
				{fieldLabel:'item2-3', name:'x02-3', labelAlign:'right'}
			]}
		] });


	Unilite.Main({
		items : [panel,{
						type:'container',
						flex: 1,
						items: [grid1]
					}]
	});  //Unilite.Main
	
}


	
</script>
      

      