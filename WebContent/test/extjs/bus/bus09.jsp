<%@page language="java" contentType="text/html; charset=utf-8"%>
<style type="text/css">

	.busDriver {
		width: 220px;
		height: 232px;
		background: url("./images/_bus.gif") no-repeat;
		
	}
.app-header .x-panel-body {
    background-color: #ddd;
    padding-left: 5px;
}

.app-header h1 {
    font-family: verdana,arial,sans-serif;
    font-size: 20px;
    color: #15428B;
}
.datat-source {
    cursor: pointer;
}

.data-over {
    background-color:#EFEFEF;
    cursor: pointer;
}
.data-selected {
    background-color: #DFE8F6;
    cursor: pointer;
}
td.blue-label {
    background-color: #d3e1f1;
    height: 24px;
    text-align: center;
}
td.bus {
    background-color: #fff;
    text-align: center;
}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/CellDragDrop.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/column/UniCellDragDrop.js" />' ></script> 
<script type="text/javascript">

Ext.require(['*']);

var editWindow;
Ext.onReady(function() {

    var busInfo = [{
        id: '1-1',
        num:'1',
        order:'1',
        name: '김기수',
        routeNo: '51',
        plateNo: '2213',
        startTime:'5:00',
        arrivalTime:'7:00',
        driverPhoto:'photo01.jpg'
    },{
        id: '1-2',
        num:'2',
        order:'1',
        name: '김기수',
        routeNo: '51',
        plateNo: '2213',
        startTime:'5:00',
        arrivalTime:'7:00',
        driverPhoto:'photo01.jpg'
    },{
        id: '1-3',
        num:'3',
        order:'1',
        name: '김기수',
        routeNo: '51',
        plateNo: '2213',
        startTime:'5:00',
        arrivalTime:'7:00',
        driverPhoto:'photo01.jpg'
    },{
        id: '1-4',
        num:'4',
        order:'1',
        name: '김기수',
        routeNo: '51',
        plateNo: '2213',
        startTime:'5:00',
        arrivalTime:'7:00',
        driverPhoto:'photo01.jpg'
    },{
        id: '1-5',
        num:'5',
        order:'1',
        name: '김기수',
        routeNo: '51',
        plateNo: '2213',
        startTime:'5:00',
        arrivalTime:'7:00',
        driverPhoto:'photo01.jpg'
    }, {
        id: '2-1',
        num:'1',
        order:'2',
        name: '홍길동',
        routeNo: '51',
        plateNo: '1987',
        startTime:'5:20',
        arrivalTime:'7:20',        
        driverPhoto:'photo02.jpg'
    }, {
        id: '2-2',
        num:'2',
        order:'2',
        name: '홍길동',
        routeNo: '51',
        plateNo: '1987',
        startTime:'5:20',
        arrivalTime:'7:20',        
        driverPhoto:'photo02.jpg'
    }, {
        id: '2-3',
        num:'3',
        order:'2',
        name: '홍길동',
        routeNo: '51',
        plateNo: '1987',
        startTime:'5:20',
        arrivalTime:'7:20',        
        driverPhoto:'photo02.jpg'
    }, {
        id: '2-4',
        num:'4',
        order:'2',
        name: '홍길동',
        routeNo: '51',
        plateNo: '1987',
        startTime:'5:20',
        arrivalTime:'7:20',        
        driverPhoto:'photo02.jpg'
    }, {
        id: '2-5',
        num:'5',
        order:'2',
        name: '홍길동',
        routeNo: '51',
        plateNo: '1987',
        startTime:'5:20',
        arrivalTime:'7:20',        
        driverPhoto:'photo02.jpg'
    },{
        id: '3-1',
        num:'1',
        order:'3',
        name: '이수현',
        routeNo: '51',
        plateNo: '3345',
        startTime:'5:40',
        arrivalTime:'7:40',
        driverPhoto:'photo03.jpg'
    },{
        id: '3-2',
        num:'2',
        order:'3',
        name: '이수현',
        routeNo: '51',
        plateNo: '3345',
        startTime:'5:40',
        arrivalTime:'7:40',
        driverPhoto:'photo03.jpg'
    },{
        id: '3-3',
        num:'3',
        order:'3',
        name: '이수현',
        routeNo: '51',
        plateNo: '3345',
        startTime:'5:40',
        arrivalTime:'7:40',
        driverPhoto:'photo03.jpg'
    },{
        id: '3-4',
        num:'4',
        order:'3',
        name: '이수현',
        routeNo: '51',
        plateNo: '3345',
        startTime:'5:40',
        arrivalTime:'7:40',
        driverPhoto:'photo03.jpg'
    },{
        id: '3-5',
        num:'5',
        order:'3',
        name: '이수현',
        routeNo: '51',
        plateNo: '3345',
        startTime:'5:40',
        arrivalTime:'7:40',
        driverPhoto:'photo03.jpg'
    },{
        id: '4-1',
        num:'1',
        order:'4',
        name: '박재석',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo04.jpg'
    },{
        id: '4-2',
        num:'2',
        order:'4',
        name: '박재석',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo04.jpg'
    },{
        id: '4-3',
        num:'3',
        order:'4',
        name: '박재석',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo04.jpg'
    },{
        id: '4-4',
        num:'4',
        order:'4',
        name: '박재석',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo04.jpg'
    },{
        id: '4-5',
        num:'5',
        order:'4',
        name: '박재석',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo04.jpg'
    }/*,{
        id: '5-1',
        num:'1',
        order:'5',
        name: '최모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo05.jpg'
    },{
        id: '5-2',
        num:'2',
        order:'5',
        name: '최모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo05.jpg'
    },{
        id: '5-3',
        num:'3',
        order:'5',
        name: '최모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo05.jpg'
    },{
        id: '5-4',
        num:'4',
        order:'5',
        name: '최모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo05.jpg'
    },{
        id: '5-5',
        num:'5',
        order:'5',
        name: '최모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo05.jpg'
    },{
        id: '6-1',
        num:'1',
        order:'6',
        name: '정모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo06.jpg'
    },{
        id: '6-2',
        num:'2',
        order:'6',
        name: '정모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo06.jpg'
    },{
        id: '6-3',
        num:'3',
        order:'6',
        name: '정모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo06.jpg'
    },{
        id: '6-4',
        num:'4',
        order:'6',
        name: '정모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo06.jpg'
    },{
        id: '6-5',
        num:'5',
        order:'6',
        name: '정모모',
        routeNo: '51',
        plateNo: '1234',
        startTime:'6:00',
        arrivalTime:'8:00',
        driverPhoto:'photo06.jpg'
    }*/];

    Ext.define('BusInfo', {
        extend: 'Ext.data.Model',
        idProperty: 'id',
        fields: [{
                name: 'id'
            },{
                name: 'num'
            },{
                name: 'order'
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
	
	var busGrid =  Unilite.createGrid('busGrid', {
		region:'center',
        margins: 0,
    	store: busInfoStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        
        columns:  [ 
        	{dataIndex:'id' ,flex:1},
        	{dataIndex:'num' ,width:100}, 
        	{dataIndex:'order' ,width:100}, 
        	{dataIndex:'name' ,width:100}, 
        	{dataIndex:'routeNo' ,width:100}, 
        	{dataIndex:'plateNo' ,width:100}, 
        	{dataIndex:'startTime' ,width:100}, 
        	{dataIndex:'arrivalTime' ,width:100}, 
        	{dataIndex:'driverPhoto' ,width:100}
        ],
        viewConfig: {
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'unicelldragdrop',
                enableDrop: true,
                enableDrag: true,
                copyType:'cell',
                onRecordDrop: function(targetRecord, dragRecord)	{
                	targetRecord.set("name", dragRecord.get("name"));
                },
                onDropEnter: function(target, dragData)	{
                	if(this.copyType != 'cell')	{
                		return false;
                	}
                	if(target.columnName != dragData.columnName)	{
                		return false
                	}
                	return true;
                }
            }
        }
    });
   /* var busTplTemplate = new Ext.XTemplate(
		    '<table space="1" padding="2" bgcolor="#eeeeee" border=0>' ,
			 '<tr>' ,
			    '<td width="20" class="blue-label">&nbsp;</td>' ,
				'<td class="blue-label">1</td>' ,
				'<td class="blue-label">2</td>' ,
				'<td class="blue-label">3</td>' ,
				'<td class="blue-label">4</td>' ,
				'<td class="blue-label">5</td>' ,
			 '</tr>' ,
			 '<tpl for=".">' ,
				'<tpl if="num == \'1\'">' ,
					'<tr><td width="30" class="blue-label">{order}</td>' ,
				'</tpl>',
		                '<td class="bus"><div class="data-source">',
			                '<div class="busDriver"><table width="100%" border="0"><tr height="42">',
			            		'<td colspan="2" align="center"><b>{routeNo}</b></td>',
			            	'</tr><tr>',
			            		'<td width="100" align="left" style="padding-left:20px">순차: {num}</td>',			            		
			            		'<td height="90" align="right" style="padding-right:20px" rowspan="3"><img src="./images/{driverPhoto}" title="{name:htmlEncode}" width="77" height="77"></td></tr>',
			            	'<tr><td width="100" align="left" style="padding-left:20px">기사: {name}</td></tr>',
			            	'<tr><td width="100" align="left" style="padding-left:20px">시간: {startTime} ~<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {arrivalTime}</td></tr>',
			            	'<tr height="62">',
			            		'<td  colspan="2" align="center"><b>{plateNo}</b></td>',
			            	'</tr>',
			            	'</table></div>',
		                '</div></td>',
		        '<tpl if="num == \'5\'">',
					'</tr>',
				'</tpl>',
	        '</tpl>' ,
	        '</table>'
		);
    var busView = Ext.create('UniDropView', {
    	autoScroll: true,
		tpl: busTplTemplate,
        store: busInfoStore,
        onDrop : function(target, dd, e, drag){
        	var me = this;
        	var drop = me.getDropRecord();
        	var dragRec = me.getDragRecord();
        	var store = me.getStore();
        	if(me.isFromDataView(drag.view))	{	           
	            var dragNum = drop.get("num");
	            var dragOrder = drop.get("order");
	            
	            Ext.each(store.data.items, function(record, idx) {
	            	var num = record.get('num'); 
	            	var order = record.get('order');
	             	if(order == dragOrder && num >= dragNum)	{
	             		record.set("name", dragRec.get("name"));
	             		record.set("driverPhoto", dragRec.get("imgFile"));
	             		record.set("plateNo", dragRec.get("plateNo"));
	             		busView.refreshNode(idx);
	             	}
        		})
        	}else {
        		var dragNum = drop.get("num");
		       var dragOrder = drop.get("order");
		            
        		if(drag.view.getItemId() == 'DirverList')	{
		            Ext.each(store.data.items, function(record, idx) {
		            	var num = record.get('num'); 
		            	var order = record.get('order');
		             	if(order == dragOrder && num >= dragNum)	{
		             		record.set("name", dragRec.get("name"));
		             		record.set("driverPhoto", dragRec.get("imgFile"));
		             		record.set("plateNo", dragRec.get("plateNo"));
		             		busView.refreshNode(idx);
		             	}
	        		})
        		}else if(drag.view.getItemId() == 'BusList')	{
		            Ext.each(store.data.items, function(record, idx) {
		            	var num = record.get('num'); 
		            	var order = record.get('order');
		             	if(order == dragOrder && num >= dragNum)	{
		             		record.set("plateNo", dragRec.get("plateNo"));
		             		busView.refreshNode(idx);
		             	}
	        		})
        		}else if(drag.view.getItemId() == 'TmpBusList')	{
		            Ext.each(store.data.items, function(record, idx) {
		            	var num = record.get('num'); 
		            	var order = record.get('order');
		             	if(order == dragOrder && num >= dragNum)	{
		             		record.set("plateNo", dragRec.get("plateNo"));
		             		busView.refreshNode(idx);
		             	}
	        		})
        		}
        	}
            return true;
        },     
        listeners: {
            render: function()	{
            	var me = this;
            	this.getEl().on('dblclick', function(e, t, eOpt) {
            		var selectEl = me.getSelectedNodes();
			    	openWindow(me.getRecord(selectEl[0]));
			    });
            }
        }
    });
    */
    
	var editForm = Unilite.createSearchForm('bus07', {
		layout: {type: 'uniTable', columns : 2},
		defaults:{
			labelWidth:60
		},
		disabled :false,
		trackResetOnLoad: true,
		defaultType:'textfield',
	    items: [	    
			{
				fieldLabel: '순차',
				name: 'num'
			},{
				fieldLabel: '기사명',
				name: 'name'
			},{
				fieldLabel: '버스번호',
				name: 'routeNo'
			},{
				fieldLabel: '차량번호',
				name: 'plateNo'
			},{
				fieldLabel: '출발시간',
				name: 'startTime'
			},{
				fieldLabel: '도착시간',
				name: 'arrivalTime'
			}
		]
	});
	
	function openWindow(record) {
		
		if(!editWindow) {
			editWindow = Ext.create('widget.uniDetailWindow', {
                title: '운행일지',
                width: 400,			                
                height: 170,
                formData: record,
                layout: {type:'vbox', align:'stretch'},	                
                items: [editForm],
                tbar:  [{
							itemId : 'applyBtn',
							text: '적용',
							handler: function() {
								var node;
								if(!Ext.isEmpty(editForm.activeRecord))	{
									node = busView.getNode(editForm.activeRecord);
									busView.refreshNode( busView.indexOf(node));
								}
								editWindow.hide();
							},
							disabled: false
						},
				        '->',{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								editWindow.hide();
							},
							disabled: false
						}
				],
				listeners : {beforehide: function(me, eOpt)	{
											editForm.clearForm();
											editForm.reset();                							
                						},
                			 beforeclose: function( panel, eOpts )	{
											editForm.clearForm();
											editForm.reset();
                			 			},
                			 show: function( panel, eOpts )	{
                			 	editForm.setActiveRecord(panel.formData);	
                			 	editWindow.center();
                			 }
                }		
			})
		}
		editWindow.formData = record;
		editWindow.show();
    }
	var imgStore = Ext.create('Ext.data.Store', {
			idProperty: 'imgFile',
			fields:[{name:'imgFile', text:'사진'}, {name:'name',text:'이름'}, {name:'plateNo',text:'차량번호'}, {name:'order',text:'순번'}],
			data: [
				{
					imgFile:'photo01.jpg',
				 	name:'김기수',
        			plateNo: '2213',
        			order:'1'
        		},
				{
					imgFile:'photo02.jpg', 
					name:'홍길동',
        			plateNo: '1987',
        			order:'2'
				},
				{
					imgFile:'photo03.jpg', 
					name:'이수현',
        			plateNo: '3345',
        			order:'3'
				},
				{
					imgFile:'photo04.jpg', 
					name:'박재석',
        			plateNo: '1234',
        			order:'4'
				}
			]});
     var imageView = Ext.create('UniDragView', {
     	id:'bus05.imageView',
		tpl: '<table space="1" padding="2" bgcolor="#eeeeee" border=0>' +
			 '<tr height:"20">' +
			 	'<td class="blue-label">사진</td>' +
				'<td class="blue-label">순번</td>' +
				'<td class="blue-label">차량번호</td>' +
				'<td class="blue-label">기사</td>' +
			 '</tr>' +
			 '<tpl for=".">'+
                '<tr class="drivers-source">'+
	                '<td><img src="./images/{imgFile}" width="72" height="72"></td>'+
	                '<td class="bus">{order}</td>'+
	                '<td class="bus">{plateNo}</td>'+
        			'<td class="bus">{name}</td>'+                    			
        		'</tr>'+
            '</tpl>' +
            '</table>',
        itemSelector: 'tr.drivers-source',
        overItemCls: 'drivers-over',
        selectedItemClass: 'drivers-selected',
        singleSelect: true,
        store: imgStore
    });
    
    var driverGrid =  Unilite.createGrid('bus05Grid', {
        region: 'east',
        flex: .15,
        title:'기사리스트',
        margins: 0,
    	store: imgStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        
        columns:  [ 
        	{dataIndex:'name' ,flex:1},
        	{dataIndex:'plateNo' ,width:100} 
        ],
        viewConfig: {
        	itemId:'DirverList',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'unicelldragdrop',
                enableDrop: false,
                enableDrag: true,
                copyType:'cell'
            }
        }
            
    });
    
     var driverGrid2 =  Unilite.createGrid('bus05Grid2', {
        region: 'east',
        flex: .1,
        title:'차량리스트',
        margins: 0,
    	store: imgStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        columns:  [ 
        	{dataIndex:'plateNo' ,flex:1} 
        ],
        viewConfig: {        	
        	itemId:'BusList',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'gridviewdragdrop',
                enableDrop: false,
                enableDrag: true
            }
        }
    });
    
    var tempBusStore = Ext.create('Ext.data.Store', {
			idProperty: 'plateNo',
			fields:[{name:'plateNo',text:'차량번호'}, {name:'order',text:'순번'}],
			data: [
				{
        			plateNo: '9213',
        			order:'1'
        		},
				{
        			plateNo: '1987',
        			order:'2'
				},
				{
        			plateNo: '9345',
        			order:'3'
				},
				{
        			plateNo: '9234',
        			order:'4'
				}
			]});
    var driverGrid3 =  Unilite.createGrid('bus05Grid3', {
        region: 'east',
        flex: .1,
        title:'예비차량리스트',
        
        margins: 0,
    	store: tempBusStore,
    	uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        
        columns:  [ 
        	{dataIndex:'plateNo' ,flex:1} 
        ],
        viewConfig: {
        	itemId:'TmpBusList',
            plugins: {
                ddGroup: 'dataGroup',
                ptype: 'gridviewdragdrop',
                enableDrop: false,
                enableDrag: true
            }
        }
    });
  
    Ext.create('Ext.Viewport', {
        layout: 'border',
        //draggable:true,
        items: [  {
            title: '승무지시',
            region: 'west',
            flex: .15,
            margins: 0,
            items: imageView
        },
        busGrid,
        driverGrid,
        driverGrid2,
        driverGrid3
        //, hospitalGrid 
        ]

    });

function initializePatientDragZone2(v) {
    v.dragZone = Ext.create('Ext.dd.DragZone', v.getEl(), {
    		ddGroup: 'dataGroup',
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
		                view: v,
		                dragFrom:'DRIVERS'
		            };
		            return r;
		        }
	    }
    });
}



});
  
</script>