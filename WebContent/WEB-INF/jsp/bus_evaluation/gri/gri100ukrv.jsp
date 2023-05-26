<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_gri100ukrv");
%>
<t:appConfig pgmId="gri100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	-->  
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {

	    fields: [
 
			]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gri100ukrvService.selectList'
			//update: 'gri100ukrvService.updateDetail',
			//create: 'gri100ukrvService.insertDetail',
			//destroy: 'gri100ukrvService.deleteDetail',
			//syncAll: 'gri100ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            loadStoreRecords: function() {
				var param= panelSearch.getValues();			
				console.log(param);
				this.load({
					params : param
				});
			},
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
				}else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '인건비',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
        width: 330,
		items: [{	
			title: '검색조건', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',  
           	defaults:{
           		labelWidth:80
           	},
	    	items:[{
				fieldLabel: '기준년도',
				name: 'SERVICE_YEAR',
				xtype: 'uniYearField',	
				width: 185,
				value: new Date().getFullYear(),
				allowBlank: false,				
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SERVICE_YEAR', newValue);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]				
		}]
		
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '기준년도',
			name: 'SERVICE_YEAR',
			xtype: 'uniYearField',
			width: 185,
			value: new Date().getFullYear(),
			allowBlank: false,				
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SERVICE_YEAR', newValue);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		}]
	});
   
   var detailForm = Unilite.createSearchForm('detailForm',{	
		autoScroll: true,
		region: 'center',
		border: 1,
		padding: '1 1 1 1',  
		layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},	
		tbar: [{
        	xtype: 'uniBaseButton',
    		iconCls: 'icon-excel',
    		width: 26, height: 26,
    		tooltip: '엑셀 다운로드',
    		handler: function() {
    			
    		}
        }, '->',{
        	itemId : 'ref1', iconCls : 'icon-referance'	,
    		text:'전년도 데이터 복사하기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		}, {
        	itemId : 'ref2', iconCls : 'icon-referance'	,
    		text:'기준년도 데이터 가져오기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		 }],
		xtype: 'container',
		layout:{type:'vbox', align:'stretch'},				
		
			xtype: 'container',
			layout: {
				type: 'uniTable',
				columns:34,
				tableAttrs: {style: 'border : 1px solid #ced9e7;', width: 2900},
    			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			
			items: [
			
				{name: 'COMP_CODE', fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode},
				{ xtype: 'component'	 ,  html:'<b>구분</b>' 			 ,colspan:4 , rowspan:3 },
				{ xtype: 'component'	 ,  html:'<b>평균인건비(원/인/월)</b>' ,colspan:3 , tdAttrs: {height : 28}},
				{ xtype: 'component'	 ,  html:'<b>년간인건비(인,원/년)</b>' ,colspan:3 },
				{ xtype: 'component'	 ,  html:'<b>월별인건비(인,원/월)</b>' ,colspan:24 },
				
				{ xtype: 'component'	 ,  html:'<b>1월 ~ 12월</b>' ,colspan:3 , tdAttrs: {height : 28}},
				{ xtype: 'component'	 ,  html:'<b>1월 ~ 12월</b>' ,colspan:3 },
				{ xtype: 'component'	 ,  html:'<b>1월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>2월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>3월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>4월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>5월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>6월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>7월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>8월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>9월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>10월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>11월</b>' 		   ,colspan:2 },
				{ xtype: 'component'	 ,  html:'<b>12월</b>' 		   ,colspan:2 },
				
				{ xtype: 'component'	 ,  html:'<b>전체</b>' 		   , tdAttrs: {width: 86 , height : 28}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>전체</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>만근자</b>' 		   , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>입퇴사자</b>' 	   , tdAttrs: {width: 86}},
				
		
				/* 시내-일반(대)*/
				{ xtype: 'component'	 ,  html:'<b>직<br>접<br>인<br>원</b>' 	   ,rowspan:33 , tdAttrs: {width: 20}},
				{ xtype: 'component'	 ,  html:'운<br>전<br>직' 	   	   ,rowspan:30 		, tdAttrs: {width: 20}},
				{ xtype: 'component'	 ,  html:'시내-일반(대)' 	   ,rowspan:5  				, tdAttrs: {width: 100}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   						    , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:'', tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'', tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'', tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				
				
				{ xtype: 'component'	 ,  html:'급여계' 	  	  , tdAttrs: {width: 60} },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   	   , width:80},
				
				{ xtype: 'component'	 ,  html:'기본급' 	  	 , tdAttrs: {width: 60}  },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_01'	   , width:80 , holdable: 'hold' },   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_01'	   , width:80 , holdable: 'hold' },   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_02'	   , width:80 , holdable: 'hold' },   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_02'	   , width:80 , holdable: 'hold' },   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_03'	   , width:80 , holdable: 'hold' },   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_03'	   , width:80 , holdable: 'hold' },   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_04'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_04'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_05'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_05'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_06'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_06'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_07'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_07'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_08'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_08'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_09'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_09'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_10'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_10'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_11'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_11'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_FULL_12'	   , width:80 , holdable: 'hold' },	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BASE_PART_12'	   , width:80 , holdable: 'hold' },	   
				
				{ xtype: 'component'	 ,  html:'상여금' 	  	, tdAttrs: {width: 60}   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_FULL_12'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_BONUS_PART_12'	, width:80 , holdable: 'hold' },  
				
				{ xtype: 'component'	 ,  html:'제수당' 	  	, tdAttrs: {width: 60}   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_FULL_12'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_LARGE_EXTRA_PART_12'	, width:80 , holdable: 'hold' },  
				
				/* 시내-일반(중)*/
				{ xtype: 'component'	 ,  html:'시내-일반(중)' 	   ,rowspan:5  , tdAttrs: {width: 10}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				
				{ xtype: 'component'	 ,  html:'급여계' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	   
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				
				{ xtype: 'component'	 ,  html:'기본급' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_FULL_12'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BASE_PART_12'	, width:80 , holdable: 'hold' },  
				
				{ xtype: 'component'	 ,  html:'상여금' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_01'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_01'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_02'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_02'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_03'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_03'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_04'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_04'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_05'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_05'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_06'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_06'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_07'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_07'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_08'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_08'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_09'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_09'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_10'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_10'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_11'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_11'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_FULL_12'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_BONUS_PART_12'	, width:80 , holdable: 'hold' }, 
				
				{ xtype: 'component'	 ,  html:'제수당' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_01'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_01'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_02'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_02'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_03'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_03'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_04'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_04'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_05'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_05'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_06'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_06'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_07'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_07'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_08'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_08'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_09'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_09'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_10'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_10'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_11'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_11'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_FULL_12'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_MEDIUM_EXTRA_PART_12'	 , width:80 , holdable: 'hold' }, 
				
				 /*시내-좌석버스*/
				{ xtype: 'component'	 ,  html:'시내-좌석버스' 	   ,rowspan:5  , tdAttrs: {width: 100}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:''  , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:''  , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:''  , tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				
				{ xtype: 'component'	 ,  html:'급여계' 	  , tdAttrs: {width: 60}	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				
				{ xtype: 'component'	 ,  html:'기본급' 	  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_FULL_12'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BASE_PART_12'	, width:80 , holdable: 'hold' },  
				
				{ xtype: 'component'	 ,  html:'상여금' 	  , tdAttrs: {width: 60}	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_01'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_02'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_03'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_04'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_05'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_06'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_07'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_08'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_09'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_10'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_11'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_FULL_12'	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_BONUS_PART_12'	, width:80 , holdable: 'hold' },  
				
				{ xtype: 'component'	 ,  html:'제수당' 	 , tdAttrs: {width: 60} 	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_01'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_01'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_02'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_02'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_03'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_03'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_04'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_04'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_05'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_05'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_06'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_06'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_07'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_07'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_08'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_08'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_09'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_09'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_10'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_10'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_11'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_11'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_FULL_12'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_EXPRESS_EXTRA_PART_12'	 , width:80 , holdable: 'hold' }, 
				
				/* 시내-직행좌석 */
				{ xtype: 'component'	 ,  html:'시내-직행좌석' 	   ,rowspan:5  , tdAttrs: {width: 100}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				
				{ xtype: 'component'	 ,  html:'급여계' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				
				{ xtype: 'component'	 ,  html:'기본급' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_01'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_01'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_02'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_02'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_03'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_03'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_04'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_04'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_05'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_05'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_06'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_06'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_07'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_07'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_08'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_08'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_09'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_09'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_10'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_10'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_11'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_11'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_FULL_12'	 , width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BASE_PART_12'	 , width:80 , holdable: 'hold' }, 
				
				{ xtype: 'component'	 ,  html:'상여금' 	  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_01'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_01'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_02'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_02'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_03'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_03'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_04'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_04'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_05'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_05'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_06'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_06'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_07'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_07'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_08'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_08'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_09'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_09'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_10'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_10'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_11'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_11'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_FULL_12'	  , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_BONUS_PART_12'	  , width:80 , holdable: 'hold' },
				
				{ xtype: 'component'	 ,  html:'제수당' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_01'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_01'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_02'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_02'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_03'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_03'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_04'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_04'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_05'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_05'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_06'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_06'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_07'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_07'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_08'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_08'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_09'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_09'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_10'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_10'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_11'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_11'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_FULL_12'	 , width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'IN_NONSTOP_EXTRA_PART_12'	 , width:80 , holdable: 'hold' },
				
				/* 시외-완행버스*/
				{ xtype: 'component'	 ,  html:'시외-완행버스' 	   ,rowspan:2  , tdAttrs: {width: 100}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				
				{ xtype: 'component'	 ,  html:'급여계' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_01'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_01'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_02'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_02'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_03'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_03'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_04'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_04'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_05'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_05'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_06'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_06'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_07'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_07'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_08'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_08'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_09'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_09'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_10'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_10'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_11'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_11'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_FULL_12'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_SLOW_PAY_PART_12'	  	, width:80 , holdable: 'hold' },  
				
				/* 시외-직행버스 */
				{ xtype: 'component'	 ,  html:'시외-직행버스' 	   ,rowspan:2  , tdAttrs: {width: 100}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				
				{ xtype: 'component'	 ,  html:'급여계' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_01'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_01'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_02'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_02'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_03'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_03'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_04'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_04'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_05'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_05'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_06'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_06'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_07'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_07'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_08'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_08'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_09'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_09'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_10'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_10'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_11'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_11'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_FULL_12'	, width:80 , holdable: 'hold' },
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_NONSTOP_PAY_PART_12'	, width:80 , holdable: 'hold' },
				
				/* 시외-공항버스 */
				{ xtype: 'component'	 ,  html:'시외-공항버스' 	   ,rowspan:2  , tdAttrs: {width: 100}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				
				{ xtype: 'component'	 ,  html:'급여계' 	, tdAttrs: {width: 60}  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_01'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_01'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_02'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_02'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_03'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_03'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_04'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_04'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_05'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_05'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_06'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_06'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_07'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_07'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_08'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_08'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_09'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_09'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_10'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_10'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_11'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_11'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_FULL_12'	  , width:80 , holdable: 'hold' },	
				{ xtype: 'uniNumberfield', value:'0' , name:'OUT_AIR_PAY_PART_12'	  , width:80 , holdable: 'hold' },	
				
				/* 시외-한정면허 */
				{ xtype: 'component'	 ,  html:'시외-한정면허' 	   ,rowspan:2  , tdAttrs: {width: 100}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:''  , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:''  , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:''  , tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				
				{ xtype: 'component'	 ,  html:'급여계' 	 , tdAttrs: {width: 60} 	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_01'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_01'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_02'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_02'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_03'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_03'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_04'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_04'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_05'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_05'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_06'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_06'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_07'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_07'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_08'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_08'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_09'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_09'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_10'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_10'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_11'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_11'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_FULL_12'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'AIR_LIMIT_PAY_PART_12'	  	, width:80 , holdable: 'hold' }, 
				
				/* 시외-기타(마을/전세버스) 등 */
				{ xtype: 'component'	 ,  html:'시외-기타<br>(마을/전세버스)' 	   ,rowspan:2  , tdAttrs: {width: 100}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:''			, tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:''			, tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:''			, tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				
				{ xtype: 'component'	 ,  html:'급여계' 	 , tdAttrs: {width: 60} 	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_01'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_01'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_02'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_02'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_03'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_03'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_04'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_04'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_05'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_05'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_06'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_06'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_07'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_07'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_08'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_08'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_09'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_09'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_10'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_10'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_11'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_11'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_FULL_12'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ETC_VILLIAGE_PAY_PART_12'	, width:80 , holdable: 'hold' }, 
				
				/* 정비직 */
				{ xtype: 'component'	 ,  html:'정 비 직' 	   	   ,rowspan:2, colspan:2, tdAttrs: {width: 150}},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:''  		, tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:''  		, tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:''  		, tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				
				{ xtype: 'component'	 ,  html:'급여계' 	  	, tdAttrs: {width: 60}   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_01'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_01'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_02'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_02'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_03'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_03'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_04'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_04'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_05'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_05'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_06'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_06'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_07'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_07'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_08'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_08'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_09'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_09'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_10'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_10'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_11'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_11'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_FULL_12'	  	, width:80 , holdable: 'hold' },  
				{ xtype: 'uniNumberfield', value:'0' , name:'MECHANIC_PAY_PART_12'	  	, width:80 , holdable: 'hold' },  
				
				 /*소계 */
				{ xtype: 'component'	 ,  html:'<b>소  계</b>' 	   	   	   , colspan:2, tdAttrs: {width: 150}},
				{ xtype: 'component'	 ,  html:'급여계' 	  	   , tdAttrs: {width: 60}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'component'	 , value:'' , tdAttrs: {width: 86}},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				
				/*간접인원 임원*/
				{ xtype: 'component'	 ,  html:'<b>간<br>접<br>인<br>원</b>' 	   ,rowspan:5 , tdAttrs: {width: 25}},
				{ xtype: 'component'	 ,  html:'임 원' 	   	   	   ,colspan: 2,rowspan:2 },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   },
				{ xtype: 'component'	 , value:''},
				{ xtype: 'component'	 , value:''},
				{ xtype: 'component'	 , value:''},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				
				{ xtype: 'component'	 ,  html:'급여계' 	  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_01'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_01'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_02'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_02'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_03'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_03'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_04'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_04'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_05'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_05'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_06'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_06'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_07'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_07'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_08'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_08'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_09'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_09'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_10'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_10'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_11'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_11'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_FULL_12'	  	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'EXECUTIVE_PAY_PART_12'	  	, width:80 , holdable: 'hold' }, 
				
				/* 간접인원 관리직 */
				{ xtype: 'component'	 ,  html:'관 리 직' 	   	   ,colspan: 2,rowspan:2 },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   },
				{ xtype: 'component'	 , value:''},
				{ xtype: 'component'	 , value:''},
				{ xtype: 'component'	 , value:''},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},
				
				{ xtype: 'component'	 ,  html:'급여계' 	  	   },
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_01'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_01'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_02'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_02'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_03'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_03'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_04'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_04'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_05'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_05'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_06'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_06'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_07'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_07'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_08'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_08'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_09'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_09'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_10'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_10'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_11'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_11'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_FULL_12'	, width:80 , holdable: 'hold' }, 
				{ xtype: 'uniNumberfield', value:'0' , name:'ADMINISTRATIVE_PAY_PART_12'	, width:80 , holdable: 'hold' }, 
				
				/*간접인원 소계*/
				{ xtype: 'component'	 ,  html:'<b>소 계</b>' 	   	  	 	,colspan: 2 },
				{ xtype: 'component'	 ,  html:'급여계' 	  	   },
				{ xtype: 'component'	 , value:''},
				{ xtype: 'component'	 , value:''},
				{ xtype: 'component'	 , value:''},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				
				/* 총계 */
				{ xtype: 'component'	 ,  html:'<b>총 계</b>' 	   	  	   ,colspan: 3 , tdAttrs: {width: 190}},
				{ xtype: 'component'	 ,  html:'급여계' 	  	   },
				{ xtype: 'component'	 , value:''},
				{ xtype: 'component'	 , value:''},
				{ xtype: 'component'	 , value:''},
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80},	 
				{ xtype: 'uniNumberfield', value:'0' , name:'' , readOnly:true	  	   , width:80}
				
		    ],
		    setAllFieldsReadOnly: function(b) {	
			var r= true
			if(b) {				 
				//this.mask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(true); 
						}						
					}
				})
   				
	  		} else {
				//this.unmask();
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
						
					}
				})
			}
			return r;
		},  api: {
         		 load: 'gri100ukrvService.selectList',
         		submit: 'gri100ukrvService.syncMaster'				
			}, 
			listeners : {
				uniOnChange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					UniAppManager.setToolbarButtons('save', true);
				}
			}
	});
	
      Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			
			items:[
				detailForm, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'gri100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			detailForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('IN_LARGE_BASE_FULL_01', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_02', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_03', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_04', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_05', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_06', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_07', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_08', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_09', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_10', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_11', 0);
			detailForm.setValue('IN_LARGE_BASE_FULL_12', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_01', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_02', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_03', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_04', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_05', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_06', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_07', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_08', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_09', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_10', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_11', 0);
			detailForm.setValue('IN_LARGE_BASE_PART_12', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_01', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_02', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_03', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_04', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_05', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_06', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_07', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_08', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_09', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_10', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_11', 0);
			detailForm.setValue('IN_LARGE_BONUS_FULL_12', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_01', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_02', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_03', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_04', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_05', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_06', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_07', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_08', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_09', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_10', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_11', 0);
			detailForm.setValue('IN_LARGE_BONUS_PART_12', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_01', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_02', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_03', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_04', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_05', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_06', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_07', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_08', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_09', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_10', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_11', 0);
			detailForm.setValue('IN_LARGE_EXTRA_FULL_12', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_01', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_02', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_03', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_04', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_05', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_06', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_07', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_08', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_09', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_10', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_11', 0);
			detailForm.setValue('IN_LARGE_EXTRA_PART_12', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_01', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_02', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_03', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_04', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_05', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_06', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_07', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_08', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_09', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_10', 0);			
			detailForm.setValue('IN_MEDIUM_BASE_FULL_11', 0);
			detailForm.setValue('IN_MEDIUM_BASE_FULL_12', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_01', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_02', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_03', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_04', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_05', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_06', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_07', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_08', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_09', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_10', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_11', 0);
			detailForm.setValue('IN_MEDIUM_BASE_PART_12', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_01', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_02', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_03', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_04', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_05', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_06', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_07', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_08', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_09', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_10', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_11', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_FULL_12', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_01', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_02', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_03', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_04', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_05', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_06', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_07', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_08', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_09', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_10', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_11', 0);
			detailForm.setValue('IN_MEDIUM_BONUS_PART_12', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_01', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_02', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_03', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_04', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_05', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_06', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_07', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_08', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_09', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_10', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_11', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_FULL_12', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_01', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_02', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_03', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_04', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_05', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_06', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_07', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_08', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_09', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_10', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_11', 0);
			detailForm.setValue('IN_MEDIUM_EXTRA_PART_12', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_01', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_02', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_03', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_04', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_05', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_06', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_07', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_08', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_09', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_10', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_11', 0);
			detailForm.setValue('IN_EXPRESS_BASE_FULL_12', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_01', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_02', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_03', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_04', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_05', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_06', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_07', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_08', 0);			
			detailForm.setValue('IN_EXPRESS_BASE_PART_09', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_10', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_11', 0);
			detailForm.setValue('IN_EXPRESS_BASE_PART_12', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_01', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_02', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_03', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_04', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_05', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_06', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_07', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_08', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_09', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_10', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_11', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_FULL_12', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_01', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_02', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_03', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_04', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_05', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_06', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_07', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_08', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_09', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_10', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_11', 0);
			detailForm.setValue('IN_EXPRESS_BONUS_PART_12', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_01', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_02', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_03', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_04', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_05', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_06', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_07', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_08', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_09', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_10', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_11', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_FULL_12', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_01', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_02', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_03', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_04', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_05', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_06', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_07', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_08', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_09', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_10', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_11', 0);
			detailForm.setValue('IN_EXPRESS_EXTRA_PART_12', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_01', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_02', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_03', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_04', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_05', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_06', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_07', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_08', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_09', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_10', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_11', 0);
			detailForm.setValue('IN_NONSTOP_BASE_FULL_12', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_01', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_02', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_03', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_04', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_05', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_06', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_07', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_08', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_09', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_10', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_11', 0);
			detailForm.setValue('IN_NONSTOP_BASE_PART_12', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_01', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_02', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_03', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_04', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_05', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_06', 0);			
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_07', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_08', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_09', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_10', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_11', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_FULL_12', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_01', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_02', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_03', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_04', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_05', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_06', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_07', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_08', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_09', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_10', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_11', 0);
			detailForm.setValue('IN_NONSTOP_BONUS_PART_12', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_01', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_02', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_03', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_04', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_05', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_06', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_07', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_08', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_09', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_10', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_11', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_FULL_12', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_01', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_02', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_03', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_04', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_05', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_06', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_07', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_08', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_09', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_10', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_11', 0);
			detailForm.setValue('IN_NONSTOP_EXTRA_PART_12', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_01', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_02', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_03', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_04', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_05', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_06', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_07', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_08', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_09', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_10', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_11', 0);
			detailForm.setValue('OUT_SLOW_PAY_FULL_12', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_01', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_02', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_03', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_04', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_05', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_06', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_07', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_08', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_09', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_10', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_11', 0);
			detailForm.setValue('OUT_SLOW_PAY_PART_12', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_01', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_02', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_03', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_04', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_05', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_06', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_07', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_08', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_09', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_10', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_11', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_FULL_12', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_01', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_02', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_03', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_04', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_05', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_06', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_07', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_08', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_09', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_10', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_11', 0);
			detailForm.setValue('OUT_NONSTOP_PAY_PART_12', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_01', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_02', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_03', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_04', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_05', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_06', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_07', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_08', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_09', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_10', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_11', 0);
			detailForm.setValue('OUT_AIR_PAY_FULL_12', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_01', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_02', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_03', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_04', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_05', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_06', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_07', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_08', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_09', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_10', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_11', 0);
			detailForm.setValue('OUT_AIR_PAY_PART_12', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_01', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_02', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_03', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_04', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_05', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_06', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_07', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_08', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_09', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_10', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_11', 0);
			detailForm.setValue('AIR_LIMIT_PAY_FULL_12', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_01', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_02', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_03', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_04', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_05', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_06', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_07', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_08', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_09', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_10', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_11', 0);
			detailForm.setValue('AIR_LIMIT_PAY_PART_12', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_01', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_02', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_03', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_04', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_05', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_06', 0);			
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_07', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_08', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_09', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_10', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_11', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_FULL_12', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_01', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_02', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_03', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_04', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_05', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_06', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_07', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_08', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_09', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_10', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_11', 0);
			detailForm.setValue('ETC_VILLIAGE_PAY_PART_12', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_01', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_02', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_03', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_04', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_05', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_06', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_07', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_08', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_09', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_10', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_11', 0);
			detailForm.setValue('MECHANIC_PAY_FULL_12', 0);
			detailForm.setValue('MECHANIC_PAY_PART_01', 0);
			detailForm.setValue('MECHANIC_PAY_PART_02', 0);
			detailForm.setValue('MECHANIC_PAY_PART_03', 0);
			detailForm.setValue('MECHANIC_PAY_PART_04', 0);
			detailForm.setValue('MECHANIC_PAY_PART_05', 0);
			detailForm.setValue('MECHANIC_PAY_PART_06', 0);
			detailForm.setValue('MECHANIC_PAY_PART_07', 0);
			detailForm.setValue('MECHANIC_PAY_PART_08', 0);
			detailForm.setValue('MECHANIC_PAY_PART_09', 0);
			detailForm.setValue('MECHANIC_PAY_PART_10', 0);
			detailForm.setValue('MECHANIC_PAY_PART_11', 0);
			detailForm.setValue('MECHANIC_PAY_PART_12', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_01', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_02', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_03', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_04', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_05', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_06', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_07', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_08', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_09', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_10', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_11', 0);
			detailForm.setValue('EXECUTIVE_PAY_FULL_12', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_01', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_02', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_03', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_04', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_05', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_06', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_07', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_08', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_09', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_10', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_11', 0);
			detailForm.setValue('EXECUTIVE_PAY_PART_12', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_01', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_02', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_03', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_04', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_05', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_06', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_07', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_08', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_09', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_10', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_11', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_FULL_12', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_01', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_02', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_03', 0);			
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_04', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_05', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_06', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_07', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_08', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_09', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_10', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_11', 0);
			detailForm.setValue('ADMINISTRATIVE_PAY_PART_12', 0);
		},
		
		onQueryButtonDown : function()	{
			var param= detailForm.getValues();
			param.SERVICE_YEAR = panelSearch.getValue('SERVICE_YEAR');
				detailForm.uniOpt.inLoading = true;				
				detailForm.getForm().load({
					params: param,
					success:function()	{
						detailForm.uniOpt.inLoading = false;
						detailForm.getForm().wasDirty = false;
						detailForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						detailForm.setAllFieldsReadOnly(false);
					}
				})
			
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
			masterGrid.createRow();
		},	
		
		onSaveDataButtonDown: function (config) {
			var param= detailForm.getValues();
			param.SERVICE_YEAR = panelSearch.getValue('SERVICE_YEAR');
			detailForm.uniOpt.inLoading = true;
			detailForm.getForm().submit({
					 params : param,
					 success : function(form, action) {
		 					detailForm.getForm().wasDirty = false;
							detailForm.resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
		            		detailForm.uniOpt.inLoading = false;
		            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.		            		
					 }	
			});
					
		},
		onResetButtonDown:function() {
			var me = this;
			me.fnInitBinding();
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});

	
	
}; // main
  
</script>