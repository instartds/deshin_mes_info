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
			fields:['routeNo', 'name', 'imgFile', 'plateNo' ],
			data: [
				{routeNo:'51', name:'김기수', imgFile:'photo01.jpg', plateNo:'2213'},
				{routeNo:'51', name:'홍길동', imgFile:'photo02.jpg', plateNo:'1987'},
				{routeNo:'51', name:'이수현', imgFile:'photo03.jpg', plateNo:'3345'},
				{routeNo:'51', name:'박재석', imgFile:'photo04.jpg', plateNo:'1234'}
			]});
	
	/*var imageList = Unilite.createGrid('bus02', {
	    store: imgStore,
	   uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
	    columns: [
	        { header:'이름', dataIndex: 'name', width:100},
	        { header:'사진', dataIndex: 'imgFile', width:100,
	          renderer: function(value){	  			 	
					  r = '<img src="./images/{value}"/>';	  			 	
	  			 	return r;
	 			}	
	        }
	    ],
	    viewConfig: {
	        plugins: {
	            ptype: 'gridviewdragdrop',
	            dragGroup: 'group1',
                dropGroup: 'group2'
	        }
	    },
	    height: 200,
	    width: 200,
	    listeners: {
                drop: function(node, data, dropRec, dropPosition) {
                    var dropOn = dropRec ? ' ' + dropPosition + ' ' + dropRec.get('name') : ' on empty view';
                    //Ext.example.msg("Drag from right to left", 'Dropped ' + data.records[0].get('name') + dropOn);
                }
            }
	});*/
	var imageList = Ext.create('DnDView', {
		id:'test1',
		itemId:'imageList',
		store: imgStore,  
		multiSelect:true,
		//draggable:true,
	    itemSelector: 'div.thumb-landscape-wrap',
	    ddGroup: 'group1',
	    
		tpl: [
            '<tpl for=".">',
                '<div id="{imgFile}" class="thumb-landscape-wrap">',
                    '<div ><img src="./images/{imgFile}" width="132" height="132">',
                    '<br/><span>{name}</span></div>',
                '</div>',
            '</tpl>'
        ]
        
	});
	
	var busList = Unilite.createGrid('bus02.2', {
	    store: busStore,
	    uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
	    columns: [
	    	{ header:'노선번호', dataIndex: 'routeNo', width:100},
	    	{ header:'차량번호', dataIndex: 'plateNo', width:100},
	        { header:'이름', dataIndex: 'name', width:100},
	        { header:'사진', dataIndex: 'imgFile', width:100,
	          renderer: function(value,metaData ){	  		
	          	console.log("metaData :", metaData );
					  r = '<img src="./images/'+value+'"/>';	  			 	
	  			 	return r;
	 			}	
	        }
	    ],
	    viewConfig: {
	        plugins: {
	            ptype: 'gridviewdragdrop',
	            dragGroup: 'group2',
                dropGroup: 'group1'
	        }
	    },
	    height: 200,
	    width: 400,
	     listeners: {
                drop: function(node, data, dropRec, dropPosition) {
                    var dropOn = dropRec ? ' ' + dropPosition + ' ' + dropRec.get('name') : ' on empty view';
                    //Ext.example.msg("Drag from right to left", 'Dropped ' + data.records[0].get('name') + dropOn);
                }
            }
	});
	
	var imageList2 = Ext.create('Ext.view.View', {
		id:'test3',
		itemId:'imageList',
		store: imgStore,  
		multiSelect:true,
		//draggable:true,
	    itemSelector: 'div.thumb-landscape-wrap',
	    dragable:{
	    	delegate: 'div.thumb-landscape-wrap'
	    },
	    
		tpl: [
            '<tpl for=".">',
                '<div id="{imgFile}" class="thumb-landscape-wrap">',
                    '<div ><img src="./images/{imgFile}" width="132" height="132">',
                    '<br/><span>{name}</span></div>',
                '</div>',
            '</tpl>'
        ]
        
	});
	
	Ext.create('Ext.container.Viewport', {
		layout:  {	type: 'hbox', pack: 'start', align: 'stretch' },
		  items:[imageList, busList  ]
		  //items:[imageList2 ]
		 //items:[imageList ]
		 //items:[busList ]
	})

		
});  
</script>