// @charset UTF-8
/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 */
 var refreshInterval;
 var refreshGttInterval;
 var refreshNoticeInterval;
 var blinkChkInterval;
 var pt1ShowInterval;
 var pt1HideInterval;
 var pt2ShowInterval;
 var pt2HideInterval;
 
Ext.define('Unilite.main.board.MainBoardSUWON', {
    extend: 'Unilite.com.panel.portal.UniPortalPanel',
    title: 'Board',
    itemId: 'Board',
    margin: '0 0 0 0',
    style:{
    	padding:'0 0 0 0'
    },
    bodyStyle: {
	    padding:'0 0 0 0'
	},
    uniOpt: {
       'prgID': 'board',
       'title': 'Board'
    },
    refreshTime: boardRefreshTime,
    refreshGttTime: boardGttRefreshTime,
    refreshNoticeTime:boardNoticeRefreshTime,
    
    
    
    //requires: ['Unilite.com.panel.portal.UniPortalPanel'],
    closable: false,
    
    //abstract 
    getPortalItems: function() {
    	var pt1 = this.getPortlet1();
    	var pt2 = this.getPortlet2();
    	var pt3 = this.getPortlet3();
    	var itemCol1 = {
        	 style:{
		    	padding:'0 0 0 0'
		    },
	        items: [pt1, pt2,pt3]
	    };

	    return [itemCol1]
    },
    
    //initialize
    initComponent: function() {
    	var me = this;
    	
    	
    	Ext.apply(this, {
    		items: this.getPortalItems(),
    		listeners:{
    			'afterrender':function(portalPanel, eOpts)	{
	    			var store = Ext.data.StoreManager.lookup("suwonBoardProxyStore");
	    			store.loadStoreRecords();
	    			var gttStore = Ext.data.StoreManager.lookup("suwonBoardGttProxyStore");
	    			gttStore.loadStoreRecords();
	    			var noticeStore = Ext.data.StoreManager.lookup("noticeProxyStore");
	    			noticeStore.loadStoreRecords();
	    			
    			},
    			'show':function(portalPanel, eOpts)	{
    				Ext.getCmp('panelNavigation').hide();
		    		refreshInterval = setInterval(function(){Ext.data.StoreManager.lookup("suwonBoardProxyStore").loadStoreRecords();}, me.refreshTime*1000);
		    		console.log("setInterval (refreshInterval);",refreshInterval);
		    		refreshGttInterval = setInterval(function(){Ext.data.StoreManager.lookup("suwonBoardGttProxyStore").loadStoreRecords()}, me.refreshGttTime*1000);
		    		refreshNoticeInterval = setInterval(function(){Ext.data.StoreManager.lookup("noticeProxyStore").loadStoreRecords()}, me.refreshNoticeTime*1000);
		    		
	    		},
    			'beforehide':function(portalPanel, eOpts)	{
    				Ext.getCmp('panelNavigation').show();
    				console.log("clearInterval (refreshInterval);",refreshInterval);
    				window.clearInterval(refreshInterval);
    				window.clearInterval(refreshGttInterval);
    				window.clearInterval(refreshNoticeInterval);
    				window.clearInterval(blinkChkInterval);
    				window.clearInterval(pt1ShowInterval);
    				window.clearInterval(pt1HideInterval);
    				window.clearInterval(pt2ShowInterval);
    				window.clearInterval(pt2HideInterval);
    			}
    		}
    	});
    		    
    	this.callParent();
    	
    },
	fnInterval:function(fn, t, v)	{
		if(Ext.isDefined(v)) {
			console.log("clearInterval:",v);
			clearInterval(v);
			return setInterval(fn, t);
		}else {
			return setInterval(fn, t);
		}
	},
    getPortlet1: function()	{
    	Unilite.defineModel('boardModel', {
    		
		    fields: [	 {name: 'ROUTE_NUM'   		,text:'노선번호'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'ROW_NUM'   		,text:'노선번호'	,type : 'int'  }
		    			,{name: 'DEPARTURE_DATE'   	,text:'날짜'		,type : 'uniDate'    ,defaultValue:'&nbsp;'}
		    			
		    			,{name: 'DEPARTURE_TIME1'  	,text:'출발시간'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'VEHICLE_NAME1'   	,text:'차량'		,type : 'string'    ,defaultValue:'&nbsp;'}	
		    			,{name: 'DRIVER_NAME1'   	,text:'기사'		,type : 'string'    ,defaultValue:'&nbsp;'}	
		    			,{name: 'blink1'   			,text:'Blink'		,type : 'string'    ,defaultValue:'&nbsp;'}	
	
		    			,{name: 'DEPARTURE_TIME2'  	,text:'출발시간'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'VEHICLE_NAME2'   	,text:'차량'		,type : 'string'    ,defaultValue:'&nbsp;'}	
		    			,{name: 'DRIVER_NAME2'   	,text:'기사'		,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'blink2'   			,text:'Blink'		,type : 'string'    ,defaultValue:'&nbsp;'}	
	
		    			,{name: 'DEPARTURE_TIME3'  	,text:'출발시간'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'VEHICLE_NAME3'   	,text:'차량'		,type : 'string'    ,defaultValue:'&nbsp;'}	
		    			,{name: 'DRIVER_NAME3'   	,text:'기사'		,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'blink3'   			,text:'Blink'		,type : 'string'    ,defaultValue:'&nbsp;'}	
	
		    			,{name: 'DEPARTURE_TIME4'  	,text:'출발시간'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'VEHICLE_NAME4'   	,text:'차량'		,type : 'string'    ,defaultValue:'&nbsp;'}	
		    			,{name: 'DRIVER_NAME4'   	,text:'기사'		,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'blink4'   			,text:'Blink'		,type : 'string'    ,defaultValue:'&nbsp;'}	
	
		    			,{name: 'DEPARTURE_TIME5'   ,text:'출발시간'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'VEHICLE_NAME5'   	,text:'차량'		,type : 'string'    ,defaultValue:'&nbsp;'}	
		    			,{name: 'DRIVER_NAME5'   	,text:'기사'		,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'blink5'   			,text:'Blink'		,type : 'string'    ,defaultValue:'&nbsp;'}	
	
			]
		});
		
		var proxyStore =  Ext.create('Ext.data.Store', {
			storeId:'suwonBoardProxyStore',
	        model: 'boardModel',   
	        autoLoad: false,
	     	uniOpt : {
	            	isMaster: false,			// 상위 버튼 연결 
	            	editable: false,			// 수정 모드 사용 
	            	deletable:false,			// 삭제 가능 여부 
		            useNavi : false			// prev | next 버튼 사용
	        },
	        proxy: {
	            type: 'direct',
	            api: {
	            	   read : 'mainBoardService.getGoplist'
	            }
	        },
			loadStoreRecords: function(config)	{
					this.load({
						callback:function(records)	{
							if(records)	{
								Ext.data.StoreManager.lookup("suwonBoardStore").loadStoreRecords(records);
							}
						}
					});
			}
		});	
		
		function blink(value, record)	{
			var departureTime =  new Date(Ext.Date.format(record.get('DEPARTURE_DATE'), 'Y-m-d')+'T'+record.get('DEPARTURE_TIME1')+':00Z');
			var diffVal = UniDate.diff(new Date(), departureTime, 'm' );
			//console.log("diffVal:",diffVal, record.get('DRIVER_NAME1'));
			var r = '';
			if(diffVal <800)	{
				r= '';
			}else {
				r= value;
			}
			console.log("r:", r)
			return r;
		}
		
		var pt1Store =  Ext.create('Ext.data.Store', {
			storeId:'suwonBoardStore',
	        model: 'boardModel',   
	     	uniOpt : {
	            	isMaster: false,			// 상위 버튼 연결 
	            	editable: false,			// 수정 모드 사용 
	            	deletable:false,			// 삭제 가능 여부 
		            useNavi : false			// prev | next 버튼 사용
	        },
			loadStoreRecords: function(records)	{
					this.loadData(records);
			},
			listeners:{
				refresh:function(store,  eOpts )	{
					setTimeout(function() {
						Ext.each(store.data.items,function(record, index)	{
							for(var i=1; i <= 5; i++)	{
								var departureTime =  new Date(Ext.Date.format(record.get('DEPARTURE_DATE'), 'Y-m-d')+'T'+record.get('DEPARTURE_TIME'+i)+':00Z');
								var diffVal = UniDate.diff(new Date(), departureTime, 'm' );
								console.log("diffVal:",diffVal);
								if(diffVal < 545)	{
									console.log("record.get('DRIVER_NAME"+i+"') : ", record.get('DRIVER_NAME'+i), diffVal);
									var el_t=Ext.get('blink'+i+'_'+record.get('ROW_NUM')+'_t');
						    		var el_v=Ext.get('blink'+i+'_'+record.get('ROW_NUM')+'_v');
						    		var el_n=Ext.get('blink'+i+'_'+record.get('ROW_NUM')+'_n');
									
						    		doBlink(el_t,el_v, el_n, (parseInt(boardRefreshTime)-1));
						    	}
							}
						})
					},5000)
				}
			}
		});	
		function doBlink(el_t,el_v, el_n,clearTime)	{
			var intvId = setInterval(
    			  	function()	{
    			  		console.log(el_t);
					    if(el_t != null)  el_t.isVisible() ?	el_t.hide():el_t.show();
					    if(el_v != null)  el_v.isVisible() ?	el_v.hide():el_v.show();
					    if(el_n != null)  el_n.isVisible() ?	el_n.hide():el_n.show();
					    
					    console.log("active interval id:",intvId);
						setTimeout(function(){
							console.log("@@@@@@@@@@@@@@@@@@@@@clear interval id:",intvId);
							window.clearInterval(intvId);
						},clearTime*1000)
    				},750);
		}
		 
		 var pt1View = Ext.create('Ext.view.View', {
			tpl: [
				'<div class="summary-source"  style="padding: 0 !important;border: 0 !important;overflow:hidden">' ,
				'<table cellpadding="0" cellspacing="0" border="1" width="100%"  align="center" style="border:1px solid #cccccc;">' ,				
				'<tpl for=".">' ,
				'<tpl if="	(ROW_NUM % 5) == 1">' ,
				'<tr class="x-grid-row x-grid-with-row-lines" >' ,
				'</tpl>',
				'	<td width="20%" valign="top" style="background-color: #d3e1f1;">',
				'		<table width="100%" cellpadding="0" cellspacing="0" border="0">',
				'		<tr>',
				'			<td colspan="3" class="board-route-num"><tpl if="ROUTE_NUM !=\'\'">{ROUTE_NUM}</tpl><tpl if="ROUTE_NUM ==\'\'">&nbsp;</tpl></td>',
				'		<tr>',
				'		<tr>',
				'			<td class="board-list"><div id="blink1_{ROW_NUM}_t">{DEPARTURE_TIME1}</div></td>',
				'			<td class="board-list"><div id="blink1_{ROW_NUM}_v">{VEHICLE_NAME1}</div></td>',
				'			<td class="board-list"><div id="blink1_{ROW_NUM}_n">{DRIVER_NAME1}</div></td>',
				'		</tr>',
				'		<tr>',
				'			<td class="board-list"><div id="blink2_{ROW_NUM}_t">{DEPARTURE_TIME2}</div></td>',
				'			<td class="board-list"><div id="blink2_{ROW_NUM}_v">{VEHICLE_NAME2}</div></td>',
				'			<td class="board-list"><div id="blink2_{ROW_NUM}_n">{DRIVER_NAME2}</div></td>',
				'		</tr>',
				'		<tr>',
				'			<td class="board-list"><div id="blink3_{ROW_NUM}_t">{DEPARTURE_TIME3}</div></td>',
				'			<td class="board-list"><div id="blink3_{ROW_NUM}_v">{VEHICLE_NAME3}</div></td>',
				'			<td class="board-list"><div id="blink3_{ROW_NUM}_n">{DRIVER_NAME3}</div></td>',
				'		</tr>',
				'		<tr>',
				'			<td class="board-list"><div id="blink4_{ROW_NUM}_t">{DEPARTURE_TIME4}</div></td>',
				'			<td class="board-list"><div id="blink4_{ROW_NUM}_v">{VEHICLE_NAME4}</div></td>',
				'			<td class="board-list"><div id="blink4_{ROW_NUM}_n">{DRIVER_NAME4}</div></td>',
				'		</tr>',
				'		<tr>',
				'			<td class="board-list"><div id="blink5_{ROW_NUM}_t">{DEPARTURE_TIME5}</div></td>',
				'			<td class="board-list"><div id="blink5_{ROW_NUM}_v">{VEHICLE_NAME5}</div></td>',
				'			<td class="board-list"><div id="blink5_{ROW_NUM}_n">{DRIVER_NAME5}</div></td>',
				'		</tr>',
				'		</table>',
				'	</td>',
				'<tpl if="(ROW_NUM % 5) == 0">' ,
				'</tr>' ,
				'</tpl>',
				'</tpl>',
				'</table>',
				'<div>'
				
			],
			border:false,
			autoScroll:false,
			flex:1,
			//height:986,
			itemSelector: 'div.summary-source',
	        store: pt1Store,
	        margin : '0 0 1 0',
	        listeners:{
	        	afterrender:function(view)	{
//	        		var runner = new Ext.util.TaskRunner();
//	        		runner.newTask(
//				    {
//					 	 run: function () {
//						      var el=Ext.get('blink1_1_t');
//						      el.setVisibilityMode(Ext.Element.VISIBILITY);
//						      if (el.isVisible()){
//						      	el.hide();
//						      }else {
//						      	el.show();
//						      }
//					     },
//					 	interval: 750
//				     }
//	        		)
//	        		runner.start();
	        		
	        	}
	        }
		});	
	
	    var ptPanel = {
	    	columnWidth: 1,
	    	xtype:'panel',
	    	id:'boardPt1Panel',
	    	border:false,
	    	autoScroll:false,
	    	padding:0,
	    	hidden:false,
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[pt1View],
	    	listeners:{
	    		render:function(panel, eOpts)	{
	    			var dt = new Date();
	    			var h = dt.getUTCHours();
	    			var m = dt.getUTCMinutes();
	    			var delayTimeShow = 0
	    			var delayTimeHide = 0
	    			
	    			var startTime = new Date();
	    			startTime.setHours(bordTime.startTime.substring(0,2));
	    			startTime.setMinutes(bordTime.startTime.substring(2,4));
	    			var sH = startTime.getUTCHours();
		            var sM = startTime.getUTCMinutes();
		            
	    			var endTime = new Date();
	    			endTime.setHours(bordTime.endTime.substring(0,2));
	    			endTime.setMinutes(bordTime.endTime.substring(2,4));
	    			var eH = endTime.getUTCHours();
		            var eM = endTime.getUTCMinutes();
		            
		 			var boardPanel = this.up('#Board');
		            if(dt >= startTime && dt <= endTime)	{
		            	panel.show();
		            } 
	    			
		            
	    			if(h > sH ) {
	    				delayTimeShow = (24-(h-sH))*60+(m-sM);
	    			}else {
	    			 		
	    				delayTimeShow = (sH-h)*60+(sM-m);
	    			}
	    			
	    			if(h > eH ) {
	    				delayTimeHide = (24-(h-eH))*60+(m-eM);
	    			}else {
	    			 		
	    				delayTimeHide = (eH-h)*60+(eM-m);
	    			}
	    			
	    			
	    			setTimeout(function(){
	    							var pt1Panel = Ext.getCmp('boardPt1Panel');
	    							Ext.data.StoreManager.lookup("suwonBoardProxyStore").loadStoreRecords()
	    							pt1Panel.show();
	    						},  delayTimeShow * 60 * 1000);
	    			setTimeout(function(){
	    							var pt1Panel = Ext.getCmp('boardPt1Panel');	  
	    							//pt1Panel.hide();
	    						},  delayTimeHide * 60 * 1000);
    				
	    			pt1ShowInterval = setInterval(function()	{
	    										
							    				setTimeout(function(){
							    							var pt1Panel = Ext.getCmp('boardPt1Panel');
							    							Ext.data.StoreManager.lookup("suwonBoardProxyStore").loadStoreRecords();
							    							pt1Panel.show();
							    						  },  delayTimeShow  * 60 * 1000);
	    									}, 24*60*60*1000); 
	    			pt1HideInterval = setInterval(function()	{
							    				setTimeout(function(){
							    							var pt1Panel = Ext.getCmp('boardPt1Panel');
							    							pt1Panel.hide();
							    						  },  delayTimeHide  * 60 * 1000);
	    									}, 24*60*60*1000); 
	    		}
	    	}
	    };
    	return ptPanel;
    },
    
    getPortlet2: function()	{
    	Unilite.defineModel('boardGttModel', {
    		
		    fields: [	 {name: 'ROUTE_NUM'   		,text:'노선번호'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'ROW_NUM'   		,text:'번호'	,type : 'int'  		}
		    			,{name: 'ROUTE_ROW_NUM'   	,text:'노선순번'	,type : 'int'   }
		    			
		    			
		    			,{name: 'DUTY_FR_TIME'  	,text:'출근시간'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'IN_TIME'  			,text:'출근시간'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			,{name: 'VEHICLE_NAME'   	,text:'차량'		,type : 'string'    ,defaultValue:'&nbsp;'}	
		    			,{name: 'DRIVER_NAME'   	,text:'기사'		,type : 'string'    ,defaultValue:'&nbsp;'}	
		    			,{name: 'CASE_FLAG'   		,text:'CASE_FLAG'	,type : 'string'    ,defaultValue:'&nbsp;'}	//CASE1:근태기준데이터 없음, CASE2:미출근(파란색) , CASE3:지각(빨간색), CASE4:정상출근(검은색) 

			]
		});
		
		var gttProxyStore =  Ext.create('Ext.data.Store', {
			storeId:'suwonBoardGttProxyStore',
	        model: 'boardGttModel',   
	        autoLoad: false,
	     	uniOpt : {
	            	isMaster: false,			// 상위 버튼 연결 
	            	editable: false,			// 수정 모드 사용 
	            	deletable:false,			// 삭제 가능 여부 
		            useNavi : false			// prev | next 버튼 사용
	        },
	        proxy: {
	            type: 'direct',
	            api: {
	            	   read : 'mainBoardService.getGttlist'
	            }
	        },
			loadStoreRecords: function(config)	{
					this.load({
						callback:function(records)	{
							if(records)	{
								Ext.data.StoreManager.lookup("suwonBoardGttStore").loadStoreRecords(records);
							}
						}
						
					});
			}
		});	
		
		var pt2Store =  Ext.create('Ext.data.Store', {
			storeId:'suwonBoardGttStore',
	        model: 'boardGttModel',   
	     	uniOpt : {
	            	isMaster: false,			// 상위 버튼 연결 
	            	editable: false,			// 수정 모드 사용 
	            	deletable:false,			// 삭제 가능 여부 
		            useNavi : false			// prev | next 버튼 사용
	        },
			loadStoreRecords: function(records)	{
					this.loadData(records);
			}
		});	
		 var pt2View = Ext.create('Ext.view.View', {
			tpl: [
				'<div class="summary-source"  style="padding: 0 !important;border: 0 !important;overflow:hidden">' ,
				'<table cellpadding="0" cellspacing="0" border="1" width="100%"  align="center" style="border:1px solid #cccccc;">' ,		
				'	<tr class="x-grid-row x-grid-with-row-lines" >' ,
				'	<tpl for=".">' ,
				'		<tpl if="(ROUTE_ROW_NUM != 1 && (ROW_NUM % 20) == 1) ">' ,
				'			<td width="20%" valign="top" style="background-color: #d3e1f1;">',
				'				<table width="100%" cellpadding="0" cellspacing="0" border="0">',
				'		</tpl>',
				// 노선번호 쓰기
				'		<tpl if="ROUTE_ROW_NUM == 1">' ,
				'		 <tpl if="ROW_NUM != 2 && (ROW_NUM-1) % 20 == 0 ">' ,
				'			</table>',
				'			</td>',
				'			<td width="20%" valign="top" style="background-color: #d3e1f1;">',
				'			<table width="100%" cellpadding="0" cellspacing="0" border="0">',
				'		 </tpl>',		
				'		 <tpl if="(ROW_NUM-1) % 20 == 1 ">' ,
				'			<td width="20%" valign="top" style="background-color: #d3e1f1;">',
				'			<table width="100%" cellpadding="0" cellspacing="0" border="0">',
				'		 </tpl>',
				'			<tr>',
				'				<td colspan="4" class="board-gtt-route-num">{ROUTE_NUM}</td>',
				'			</tr>',
				'		</tpl>',
				// 노선번호 끝
				'		<tr>',
				'			<td width="25%" class="board-gtt-list{CASE_FLAG}">{VEHICLE_NAME}</td>',
				'			<td width="25%" class="board-gtt-list{CASE_FLAG}">{DRIVER_NAME}</td>',
				'			<td width="25%" class="board-gtt-list{CASE_FLAG}">{DUTY_FR_TIME}</td>',
				'			<td width="25%" class="board-gtt-list{CASE_FLAG}">{IN_TIME}</td>',
				'		</tr>',
				'<tpl if=" (ROW_NUM % 20) == 0 ">' ,	
				'		</table>',
				'	</td>',
				'</tpl>',
				'</tpl>',
				'	</tr></table>',
				'<div>'
			],
			border:false,
			autoScroll:false,
			flex:1,
			//height:986,
			itemSelector: 'div.summary-source',
	        store: pt2Store,
	        margin : '0 0 1 0'
		});	
	    var ptPanel = {
	    	columnWidth: 1,
	    	xtype:'panel',
	    	border:false,
	    	autoScroll:false,
	    	padding:0,
	    	hidden:true,
	    	id:'boardPt2Panel',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[pt2View],
	    	listeners:{
	    		render:function(panel, eOpts)	{
	    			var dt = new Date();
	    			var h = dt.getUTCHours();
	    			var m = dt.getUTCMinutes();
	    			var delayTimeShow = 0
	    			var delayTimeHide = 0
	    			
	    			var startTime = new Date();
	    			startTime.setHours(bordTime.gttStartTime.substring(0,2));
	    			startTime.setMinutes(bordTime.gttStartTime.substring(2,4));
	    			var sH = startTime.getUTCHours();
		            var sM = startTime.getUTCMinutes();
		            
	    			var endTime = new Date();
	    			endTime.setHours(bordTime.gttEndTime.substring(0,2));
	    			endTime.setMinutes(bordTime.gttEndTime.substring(2,4));
	    			var eH = endTime.getUTCHours();
		            var eM = endTime.getUTCMinutes();
		            
		 
		            if(dt >= startTime && dt <= endTime)	{
		            	panel.show();
		            }
	    			
		            
	    			if(h > sH ) {
	    				delayTimeShow = (24-(h-sH))*60+(m-sM);
	    			}else {
	    			 		
	    				delayTimeShow = (sH-h)*60+(sM-m);
	    			}
	    			
	    			if(h > eH ) {
	    				delayTimeHide = (24-(h-eH))*60+(m-eM);
	    			}else {
	    			 		
	    				delayTimeHide = (eH-h)*60+(eM-m);
	    			}
	    			console.log("pt2 delayTimeShow:", delayTimeShow);
	    			console.log("pt2 delayTimeHide:", delayTimeHide);
	    			setTimeout(function(){
	    							var pt2Panel = Ext.getCmp('boardPt2Panel');
	    							pt2Panel.show();
	    						},  delayTimeShow * 60 * 1000);
	    			setTimeout(function(){
	    							var pt2Panel = Ext.getCmp('boardPt2Panel');
	    							pt2Panel.hide();
	    						},  delayTimeHide * 60 * 1000);
	    						
	    			pt2ShowInterval = setInterval(function()	{
	    										
							    				setTimeout(function(){
							    							var pt2Panel = Ext.getCmp('boardPt2Panel');
							    							pt2Panel.show();
							    						  },  delayTimeShow  * 60 * 1000);
	    									}, 24*60*60*1000); 
	    			pt2HideInterval = setInterval(function()	{
	    										
							    				setTimeout(function(){
							    							var pt2Panel = Ext.getCmp('boardPt2Panel');
							    							pt2Panel.show();
							    						  },  delayTimeShow  * 60 * 1000);
	    									}, 24*60*60*1000); 
	    			
	    		}
	    	}
	    };
    	return ptPanel;
    },
    
    getPortlet3: function()	{
    	Unilite.defineModel('noticeModel', {
    		
		    fields: [	 {name: 'NOTICE'   			,text:'공지사항'	,type : 'string'    ,defaultValue:'&nbsp;'}
		    			
			]
		});
		
		var noticeProxyStore =  Ext.create('Ext.data.Store', {
			storeId:'noticeProxyStore',
	        model: 'noticeModel',   
	        autoLoad: false,
	     	uniOpt : {
	            	isMaster: false,			// 상위 버튼 연결 
	            	editable: false,			// 수정 모드 사용 
	            	deletable:false,			// 삭제 가능 여부 
		            useNavi : false			// prev | next 버튼 사용
	        },
	        proxy: {
	            type: 'direct',
	            api: {
	            	   read : 'mainBoardService.noticelist'
	            }
	        },
			loadStoreRecords: function(config)	{
					this.load({
						callback:function(records)	{
							if(records)	{
								Ext.data.StoreManager.lookup("suwonBoardNoticeStore").loadStoreRecords(records);
							}
						}
						
					});
			}
		});	
		
		var pt3Store =  Ext.create('Ext.data.Store', {
			storeId:'suwonBoardNoticeStore',
	        model: 'noticeModel',   
	     	uniOpt : {
	            	isMaster: false,			// 상위 버튼 연결 
	            	editable: false,			// 수정 모드 사용 
	            	deletable:false,			// 삭제 가능 여부 
		            useNavi : false			// prev | next 버튼 사용
	        },
			loadStoreRecords: function(records)	{
					this.loadData(records);
			}
		});	
		 var pt3View = Ext.create('Ext.view.View', {
			tpl: [
				'<div class="summary-source"  style="padding: 0 !important;border: 0 !important;overflow:hidden">' ,
				'	<tpl for=".">' ,
				'		<div class="board-notice-list"><tpl if="!this.isFirefox()"><marquee>{NOTICE}</marquee></tpl><tpl if="this.isFirefox()"><marquee>{NOTICE}</marquee></tpl></div>',
				'	</tpl>',
				'</div>',
				{
					isFirefox:function()	{
						return navigator.userAgent.toLowerCase().indexOf('firefox') > -1;		
					}
				}
			],
			border:false,
			autoScroll:false,
			height:46,
			itemSelector: 'div.summary-source',
	        store: pt3Store,
	        margin : '0 0 1 0'
		});	
	    var ptPanel = {
	    	columnWidth: 1,
	    	xtype:'panel',
	    	border:false,
	    	autoScroll:false,
	    	padding:0,
	    	id:'boardPt3Panel',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[pt3View]
	    }
    	return ptPanel;
    }
});