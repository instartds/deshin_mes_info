<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript">

Ext.onReady(function() {
		var fsf = {
			xtype : 'uniSearchForm',
			id : 'searchForm',
			items : [ {		
						name : 'from',
						xtype : 'datefield',
						fieldLabel:'기간'					
					},
				{
					xtype:'fieldcontainer',
					fieldLabel : '기간',
					layout: {
						type:'uniTable', columns:3
					},
					items: [{		
							name : 'from',
							xtype : 'datefield'
						
						},{tbtext: 'tbspacer', text:'-'},
						{
							name : 'to',
							xtype : 'datefield'				
						}
					] 
				} // fieldcontainer
			]
		};


		Ext.create('Ext.Viewport', {
			layout : {
				type : 'vbox',
				pack : 'start',
				align : 'stretch'
			},

			items : [fsf, {contentEl:'test'} ],
			renderTo : Ext.getBody()
		});

	});
	
	
</script>
<!-- Search Area  -->
<div id="ext" > </div>
<div id="test">
</div>
<!-- //List Area -->
