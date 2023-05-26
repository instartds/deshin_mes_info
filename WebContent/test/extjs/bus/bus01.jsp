<%@page language="java" contentType="text/html; charset=utf-8"%>
<style>

	.busDriver {
		width: 220px;
		height: 232px;
		background: url("./images/_bus.gif") no-repeat;
		
	}
</style>
<script type="text/javascript" charset="UTF-8" src='DnDView.js'></script> 

<script type="text/javascript">

Ext.onReady(function () {
	
	var imgStore = Ext.create('Ext.data.Store', {
			fields:['imgFile', 'name'],
			data: [
				{imgFile:'photo01.jpg', name:'김기수'},
				{imgFile:'photo02.jpg', name:'홍길동'},
				{imgFile:'photo03.jpg', name:'이수현'},
				{imgFile:'photo04.jpg', name:'박재석'}
			]});
			
	
	var busStore = Ext.create('Ext.data.Store', {
			fields:['routeNo', 'driver', 'driverPhoto', 'plateNo' ],
			data: [
				{routeNo:'51', driver:'김기수', driverPhoto:'photo01.jpg', plateNo:'2213'},
				{routeNo:'51', driver:'홍길동', driverPhoto:'photo02.jpg', plateNo:'1987'},
				{routeNo:'51', driver:'이수현', driverPhoto:'photo03.jpg', plateNo:'3345'},
				{routeNo:'51', driver:'박재석', driverPhoto:'photo04.jpg', plateNo:'1234'}
			]});
	
	var imageList = Ext.create('DnDView', {
		itemId:'imageList',
		store: imgStore,  
	    itemSelector: 'div.thumb-landscape-wrap',
	    ddGroup: 'photoDnd',
		tpl: [
            '<tpl for=".">',
                '<div class="thumb-landscape-wrap">',
                    '<div ><img src="./images/{imgFile}" width="132" height="132">',
                    '<br/><span>{name}</span></div>',
                '</div>',
            '</tpl>',
            '<div class="x-clear"></div>'
        ]  
	});

	
	var busList = Ext.create('DnDView', {
		itemId:'busList',
		store: busStore, 
	    itemSelector: 'div.thumb-landscape-wrap', 
		//draggable: 'thumb-landscape-wrap',
	    ddGroup: 'busDnd',
		tpl: [
            '<tpl for=".">',
                '<div class="thumb-landscape-wrap">',
	                '<div class="busDriver"><table width="100%" border="0"><tr height="42">',
	            		'<td colspan="2" align="center"><b>{routeNo}</b></td>',
	            	'</tr><tr height="90">',
	            		'<td width="100" align="center">{driver}</td>',
	            		'<td align="right" style="padding-right:20px"><img src="./images/{driverPhoto}" title="{name:htmlEncode}" ',
	            		'    width="77" height="77" ></td>',
	            	'</tr><tr height="62">',
	            		'<td  colspan="2" align="center"><b>{plateNo}</b></td>',
	            	'</tr>',
	            	'</table></div>',
                '</div>',
            '</tpl>',
            '<div class="x-clear"></div>'
        ]
	});	
	Ext.create('Ext.container.Viewport', {
		layout:  {	type: 'vbox', pack: 'start', align: 'stretch' },
		 items:[imageList, busList  ]
		// items:[imageList ]
		 //items:[busList ]
	})
   
    
});  // Ext.onReady
</script>