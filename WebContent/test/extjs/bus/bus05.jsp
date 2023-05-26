<%@page language="java" contentType="text/html; charset=utf-8"%>
<style>

	.busDriver {
		width: 220px;
		height: 232px;
		background: url("./images/_bus.gif") no-repeat;
		
	}
</style>
<script type="text/javascript" charset="UTF-8" src='DnDView.js'></script> 
<style type="text/css">
.app-header .x-panel-body {
    background-color: #ddd;
    padding-left: 5px;
}

.app-header h1 {
    font-family: verdana,arial,sans-serif;
    font-size: 20px;
    color: #15428B;
}

.hospital-target {
    border: 1px solid red;
    margin: 5px;
    padding: 5px;
    font-size: small;
    cursor: default;
}

.hospital-target.hospital-target-hover {
    background-color: #C0C0C0;
}

.patient-source {
    cursor: pointer;
    display: inline-block; 
}

.patient-view table {
    border-collapse: separate;
    border-spacing: 2px;
}

.patient-view td {
    font-family: verdana,arial,sans-serif;
    font-size: 12px;
}

td.patient-label {
    background-color: #ddd;
    border: 1px solid #bbb;
    font-weight: bold;
    text-align: right;
    width: 100px;
    padding: 0px 3px 0px 0px;
}

.patient-over {
    background-color:#EFEFEF;
    cursor: pointer;
}
.patient-selected {
    background-color: #DFE8F6;
    cursor: pointer;
}
</style>
<script type="text/javascript">

Ext.require(['*']);

Ext.onReady(function() {

    var busInfo = [{
        id: '1',
        name: '김기수',
        routeNo: '51',
        plateNo: '2213',
        startTime:'5:00',
        arrivalTime:'7:00',
        driverPhoto:'photo01.jpg'
    }, {
         id: '2',
        name: '홍길동',
        routeNo: '51',
        plateNo: '1987',
        startTime:'5:20',
        arrivalTime:'7:20',        
        driverPhoto:'photo02.jpg'
    }, {
         id: '3',
        name: '이수현',
        routeNo: '51',
        plateNo: '3345',
        startTime:'5:40',
        arrivalTime:'7:40',
        driverPhoto:'photo03.jpg'
    }, {
        id: '4',
        name: '박재석',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo04.jpg'
    },{
        id: '11',
        name: '김기수1',
        routeNo: '51',
        plateNo: '2213',
        startTime:'6:20',
        arrivalTime:'8:20',
        driverPhoto:'photo01.jpg'
    }, {
         id: '12',
        name: '홍길동1',
        routeNo: '51',
        plateNo: '1987',
        startTime:'6:40',
        arrivalTime:'8:40',
        driverPhoto:'photo02.jpg'
    }, {
         id: '13',
        name: '이수현1',
        routeNo: '51',
        plateNo: '3345',
        startTime:'7:00',
        arrivalTime:'9:00',
        driverPhoto:'photo03.jpg'
    }, {
        id: '14',
        name: '박재석1',
        routeNo: '51',
        plateNo: '1234',
        startTime:'7:20',
        arrivalTime:'9:20',
        driverPhoto:'photo04.jpg'
    }];

    Ext.define('BusInfo', {
        extend: 'Ext.data.Model',
        idProperty: 'id',
        fields: [{
                name: 'id'
            },{
                name: 'name'
            }, {
                name: 'routeNo'
            }, {
                name: 'plateNo'
            }, {
                name: 'startTime'
            }, {
                name: 'arrivalTime'
            }, {
                name: 'driverPhoto'
            }]
    });

    var busInfoStore = Ext.create('Ext.data.Store', {
        model: 'BusInfo',
        data: busInfo
    });

    var busView = Ext.create('Ext.view.View', {
        cls: 'patient-view',
		tpl: '<tpl for=".">'+
		                '<div class="patient-source">'+
			                '<div class="busDriver"><table width="100%" border="0"><tr height="42">'+
			            		'<td colspan="2" align="center"><b>{routeNo}</b></td>'+
			            	'</tr><tr>'+
			            		'<td width="100" align="left" style="padding-left:20px">순번: {id}</td>'+			            		
			            		'<td height="90" align="right" style="padding-right:20px" rowspan="3"><img src="./images/{driverPhoto}" title="{name:htmlEncode}" width="77" height="77"></td></tr>'+
			            	'<tr><td width="100" align="left" style="padding-left:20px">기사: {name}</td></tr>'+
			            	'<tr><td width="100" align="left" style="padding-left:20px">시간: {startTime} ~<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {arrivalTime}</td></tr>'+
			            	'<tr height="62">'+
			            		'<td  colspan="2" align="center"><b>{plateNo}</b></td>'+
			            	'</tr>'+
			            	'</table></div>'+
		                '</div>'+
		            '</tpl>',
        itemSelector: 'div.patient-source',
        overItemCls: 'patient-over',
        selectedItemClass: 'patient-selected',
        singleSelect: true,
        store: busInfoStore,
        //ddGroup: 'group1',
        listeners: {
            render: initializePatientDragZone
        }
    });
	var imgStore = Ext.create('Ext.data.Store', {
			idProperty: 'imgFile',
			fields:[{name:'imgFile', text:'사진'}, {name:'name',text:'이름'}],
			data: [
				{imgFile:'photo01.jpg', name:'김기수'},
				{imgFile:'photo02.jpg', name:'홍길동'},
				{imgFile:'photo03.jpg', name:'이수현'},
				{imgFile:'photo04.jpg', name:'박재석'}
			]});
     var imageView = Ext.create('Ext.view.View', {
     	id:'bus05.imageView',
        cls: 'patient-view',
			 tpl: '<tpl for=".">'+
			                '<div class="drivers-source"><table border=0><tbody><tr>'+
				                '<td><img src="./images/{imgFile}" width="72" height="72"></td>'+
                    			'<td>{name}</td>'+
                    			'</tr></tbody></table>'+
			                '</div>'+
			            '</tpl>',
        itemSelector: 'div.drivers-source',
        overItemCls: 'drivers-over',
        selectedItemClass: 'drivers-selected',
        singleSelect: true,
        store: imgStore,
        listeners: {
            render: initializePatientDragZone2
        }
    });
    
    var driverGrid =  Unilite.createGrid('bus05Grid', {
        region: 'east',
        flex: .1,
        title:'기사리스트',
        margins: '0 5 5 0',
    	store: imgStore,uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        
        columns:  [ 
        	{dataIndex:'name' ,width:100} 
        ],
        viewConfig: {
                plugins: {
                    ddGroup: 'group1',
                    ptype: 'gridviewdragdrop',
                    enableDrop: false,
                    enableDrag: true
                }
            }
    });
    
     var driverGrid2 =  Unilite.createGrid('bus05Grid2', {
        region: 'east',
        flex: .1,
        title:'차량리스트',
        margins: '0 5 5 0',
    	store: imgStore,uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        
        columns:  [ 
        	{dataIndex:'name' ,width:100} 
        ],
        viewConfig: {
                plugins: {
                    ddGroup: 'group1',
                    ptype: 'gridviewdragdrop',
                    enableDrop: false,
                    enableDrag: true
                }
            }
    });
    var driverGrid3 =  Unilite.createGrid('bus05Grid3', {
        region: 'east',
        flex: .1,
        title:'예비차량리스트',
        margins: '0 5 5 0',
    	store: imgStore,uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        
        columns:  [ 
        	{dataIndex:'name' ,width:100} 
        ],
        viewConfig: {
                plugins: {
                    ddGroup: 'group1',
                    ptype: 'gridviewdragdrop',
                    enableDrop: false,
                    enableDrag: true
                }
            }
    });
    Ext.create('Ext.Viewport', {
        layout: 'border',
        items: [ {
            title: '운행일지',
            region: 'center',
            width: 800,
            margins: '0 5 5 5',
            items: busView
        }, {
            title: '승무지시',
            region: 'west',
            flex: .2,
            margins: '0 5 5 5',
            items: imageView
        },
        driverGrid,
        driverGrid2,
        driverGrid3
        //, hospitalGrid 
        ]
    });


function initializePatientDragZone(v) {
    v.dragZone = Ext.create('Ext.dd.DragZone', v.getEl(), {
	    	getDragData: function(e) {
		        var sourceEl = e.getTarget(v.itemSelector, 20), d;
		        if (sourceEl) {
		            d = sourceEl.cloneNode(true);
		        	d=  v.getNode(sourceEl);
		            d.id = Ext.id();
		            var r = v.dragData = {
		                sourceEl: sourceEl,
		                repairXY: Ext.fly(sourceEl).getXY(),
		                ddel: d,
		                data: v.getRecord(sourceEl).data,
		                record:v.getRecord(sourceEl),
		                dragZone:'BUS'
		            };
		            return r;
		        }
	    }
    });
    
    v.dropZone = Ext.create('Ext.dd.DropZone', v.getEl(), {

//      If the mouse is over a target node, return that node. This is
//      provided as the "target" parameter in all "onNodeXXXX" node event handling functions
        getTargetFromEvent: function(e) {
            return e.getTarget('.patient-source');
        },

//      On entry into a target node, highlight that node.
        onNodeEnter : function(target, dd, e, data){
            Ext.fly(target).addCls('patient-source-hover');
        },

//      On exit from a target node, unhighlight that node.
        onNodeOut : function(target, dd, e, data){
            Ext.fly(target).removeCls('patient-source-hover');
        },

//      While over a target node, return the default drop allowed class which
//      places a "tick" icon into the drag proxy.
        onNodeOver : function(target, dd, e, data){
            return Ext.dd.DropZone.prototype.dropAllowed;
        },

//      On node drop, we can interrogate the target node to find the underlying
//      application object that is the real target of the dragged data.
//      In this case, it is a Record in the GridPanel's Store.
//      We can use the data set up by the DragZone's getDragData method to read
//      any data we decided to attach.
        onNodeDrop : function(target, dd, e, drag){      
        	if(drag.dragZone == 'BUS')	{
	            var drop = v.getRecord(target);
	            
	            var store = v.getStore();
	            var dragIdx = store.indexOf(drag.record);
	            var dropIdx = store.indexOf(drop);
	            var lastIdx = store.getCount()-1;
	            var updateRecords = new Array();
	            Ext.each(store.data.items, function(record, idx) {
			   		if( idx >= dragIdx)	{
			   			if(idx < lastIdx)	{
			   				record = store.getAt(idx+1);
			   			}
			   			if(idx == lastIdx)	{
			   				record = drag.record;
			   			}
			   		}
			   		updateRecords.push(record);
				});
				store.loadRecords(updateRecords);
				
				updateRecords = new Array();
				var tempRecord, tempRecord2;
				Ext.each(store.data.items, function(record, idx) {
					if( idx == dropIdx)	{
						tempRecord = record;
						record = drag.record;	
					}
			   		if( idx > dropIdx)	{
		   				tempRecord2 = record;
		   				record = tempRecord;
		   				tempRecord = tempRecord2;
			   		}
					updateRecords.push(record);
				   		
				});
				store.loadRecords(updateRecords);
	        	busView.refresh();
        	} else if(drag.dragZone == 'DRIVERS')	{
	            var drop = v.getRecord(target);	            	           
	            drop.set("name", drag.record.get("name"));
	            drop.set("driverPhoto", drag.record.get("imgFile"));
	            busView.refreshNode(v.getStore().indexOf( drop ));
        	}
            return true;
        }
        
    });
}

function initializePatientDragZone2(v) {
    v.dragZone = Ext.create('Ext.dd.DragZone', v.getEl(), {
	    	getDragData: function(e) {
		        var sourceEl = e.getTarget(v.itemSelector, 20), d;
		        if (sourceEl) {
		            d = sourceEl.cloneNode(true);
		        	d=  v.getNode(sourceEl);
		            d.id = Ext.id();
		            var r = v.dragData = {
		                sourceEl: sourceEl,
		                repairXY: Ext.fly(sourceEl).getXY(),
		                ddel: d,
		                data: v.getRecord(sourceEl).data,
		                record:v.getRecord(sourceEl),
		                dragZone:'DRIVERS'
		            };
		            return r;
		        }
	    }
    });
}



});
  
</script>