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


			
	
	var busStore = Ext.create('Ext.data.Store', {
			fields:[
				{name:'id2',type:'string'}, 
				{name:'name2',type:'string'}, 
				{name:'imgFile2', type:'string'},
				{name:'routeNo', type:'string'},
				{name:'id',type:'string'}, 
				{name:'name', type:'string'}, 
				{name:'imgFile', type:'string'}, 
				{name:'plateNo' , type:'string'}
			],
			data: [
				{id2:'1', name2:'김기수', imgFile2:'photo01.jpg',routeNo:'51', id:'1', name:'김기수', imgFile:'photo01.jpg', plateNo:'2213'},
				{id2:'2', name2:'홍길동', imgFile2:'photo02.jpg',routeNo:'51', id:'2',name:'홍길동', imgFile:'photo02.jpg', plateNo:'1987'},
				{id2:'3', name2:'이수현', imgFile2:'photo03.jpg',outeNo:'51', id:'3',name:'이수현', imgFile:'photo03.jpg', plateNo:'3345'},
				{id2:'4', name2:'박재석', imgFile2:'photo04.jpg',routeNo:'51', id:'4',name:'박재석', imgFile:'photo04.jpg', plateNo:'1234'}
			]});
	

	
	var busList = Unilite.createGrid('bus02.2', {
	    store: busStore,
	    uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
	    columns: [
	    	{ header:'이름', dataIndex: 'name2', width:100},
	        { header:'사진', dataIndex: 'imgFile2', width:150,
	          renderer: function(value ){	  
					  r = 	'<img src="./images/'+value+'" width="132" height="132">'; 			 	
	  			 	return r;
	 			}
	        },
	    	{ header:'노선번호', dataIndex: 'routeNo', width:100},
	    	{ header:'차량번호', dataIndex: 'plateNo', width:100},
	        { header:'이름', dataIndex: 'name', width:100},
	        { header:'사진', dataIndex: 'imgFile', width:150,
	          renderer: function(value ){	  	
	          		  
					  r = 	'<img src="./images/'+value+'" width="132" height="132">';
	  			 	return r;
	 			}
	        }
	    ],
	    viewConfig: {
            plugins: {
                ptype: 'celldragdrop',
                // remove text from source cell and replace with value of emptyText
                applyEmptyText: false,
                dropBackgroundColor: Ext.themeName === 'neptune' ? '#a4ce6c' : 'green',
                noDropBackgroundColor: Ext.themeName === 'neptune' ? '#d86f5d' : 'red',
                //emptyText: Ext.String.htmlEncode('<<foo>>'),

                // will only allow drops of the same type
                enforceType: true
            }
        },
	    height: 200,
	    width: 400,
	     listeners: {
                drop: function(node, data, dropRec, dropPosition) {
                	alert('drop');
                    //var dropOn = dropRec ? ' ' + dropPosition + ' ' + dropRec.get('name') : ' on empty view';
                    //Ext.example.msg("Drag from right to left", 'Dropped ' + data.records[0].get('name') + dropOn);
                }
            }
	});
	
	Ext.create('Ext.container.Viewport', {
		layout:  {	type: 'hbox', pack: 'start', align: 'stretch' },
		  items:[busList ]
		 //items:[imageList ]
		 //items:[busList ]
	})

		
});  
</script>