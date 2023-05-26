<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_gri300ukrv");
%>
<t:appConfig pgmId="gri300ukrv"  >
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
			read: 'gri300ukrvService.selectList'
			//update: 'gri300ukrvService.updateDetail',
			//create: 'gri300ukrvService.insertDetail',
			//destroy: 'gri300ukrvService.deleteDetail',
			//syncAll: 'gri300ukrvService.saveAll'
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
		title: '퇴직급여충당금',
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
				columns:11,
				tableAttrs: {style: 'border : 1px solid #ced9e7;'},
    			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			
			items: [
			
				{name: 'COMP_CODE', fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode},
				{ xtype: 'component'	 ,  html:'<b>구분</b>' 				, colspan:3 , rowspan:2},
				{ xtype: 'component'	 ,  html:'<b>대상인원(인)</b>' 			, rowspan:2 , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>예치실적(%)</b>'      	, rowspan:2 , tdAttrs: {width: 86}},
				{ xtype: 'component'	 ,  html:'<b>추계액</b>'      		, colspan:2 , tdAttrs: {height: 28}},
				{ xtype: 'component'	 ,  html:'<b>예치액</b>'      		, colspan:4 },
				
				{ xtype: 'component'	 ,  html:'<b>회사장부</b>' 		, tdAttrs: {width: 86 , height: 28}},
		    	{ xtype: 'component'	 ,  html:'<b>100%설정시</b>' 		, tdAttrs: {width: 86}},
		    	{ xtype: 'component'	 ,  html:'<b>소계</b>' 			, tdAttrs: {width: 86}},
		    	{ xtype: 'component'	 ,  html:'<b>퇴직연금</b>' 		, tdAttrs: {width: 86}},
		    	{ xtype: 'component'	 ,  html:'<b>퇴직보험예치금</b>' 	, tdAttrs: {width: 100}},
		    	{ xtype: 'component'	 ,  html:'<b>국민연금전환금</b>' 	, tdAttrs: {width: 100}},

				{ xtype: 'component'	 ,  html:'<b>직<br>접<br>인<br>원</b>' 	 ,rowspan:11 , tdAttrs: {width:25}},
		    	{ xtype: 'component'	 ,  html:'<b>운<br>전<br>직</b>' 	   	   		 ,rowspan:9 , width:25},
		    	{ xtype: 'component'	 ,  html:'시내-일반(대)' 	   				 , tdAttrs: {width: 200}},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_PERSON'	 , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_DEPOSIT'	 , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_ESTI_BOOK'	 , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_SET_100'	 , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	 , width:80},                   
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_RET_ANU'	 , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_RET_INS'	 , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_TRANS_ANU'	 , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'시내-일반(중)' 	   },
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_PERSON'	 , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_DEPOSIT'	 , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_ESTI_BOOK' , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_SET_100'	 , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	 , width:80},                   
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_RET_ANU'   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_RET_INS'   , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_TRANS_ANU' , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'시내-좌석버스' 	   },
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_PERSON'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_DEPOSIT'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_ESTI_BOOK'	  	    , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_SET_100'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	, width:80},                   
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_RET_ANU'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_RET_INS'		  	    , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_TRANS_ANU'	  	    , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'시내-직행좌석' 	   },
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_PERSON'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_DEPOSIT'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_ESTI_BOOK'	  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_SET_100'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	, width:80},                   
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_RET_ANU'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_RET_INS'		  	    , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_TRANS_ANU'	  	   	, width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'시외-완행버스' 	   },
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_PERSON'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_DEPOSIT'		  	    , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_ESTI_BOOK'	  	   	    , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_SET_100'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	, width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_RET_ANU'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_RET_INS'		  	   	, width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_TRANS_ANU'	  	   	    , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'시외-직행버스' 	   },
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_PERSON'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_DEPOSIT'		  	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_ESTI_BOOK'	  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_SET_100'		  	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	    , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_RET_ANU'		  	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_RET_INS'		  	, width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_TRANS_ANU'	  	   	, width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'시외-공항버스' 	   },
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_PERSON'		  	   	  	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_DEPOSIT'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_ESTI_BOOK'	  	   	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_SET_100'		  	   	, width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	    , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_RET_ANU'		  	    , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_RET_INS'		  	    , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_TRANS_ANU'	  	   	    , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'공항-한정면허' 	   },
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_PERSON'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_DEPOSIT'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_ESTI_BOOK'	  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_SET_100'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_RET_ANU'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_RET_INS'		  	   	   , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_TRANS_ANU'	  	   	   , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'기타(마을/전세버스 등)'  },
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_PERSON'		  	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_DEPOSIT'		  	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ESTI_BOOK'	  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_SET_100'		  	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_RET_ANU'		  	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_RET_INS'		  	   , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_TRANS_ANU'	  	   	   , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'정비직' 	   	   , colspan:2},
				{ xtype: 'uniNumberfield', value:'0', name:'MECHANIC_PERSON'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'MECHANIC_DEPOSIT'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'MECHANIC_ESTI_BOOK'	  	   	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'MECHANIC_SET_100'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'MECHANIC_RET_ANU'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'MECHANIC_RET_INS'		  	   	   , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'MECHANIC_TRANS_ANU'	  	   	       , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'<b>소 계</b>' 	   	  	 , colspan:2},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:94},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:94},
				
				{ xtype: 'component'	 ,  html:'<b>간<br>접<br>인<br>원</b>' 	   , rowspan:3 , tdAttrs: {width: 25}},
		    	{ xtype: 'component'	 ,  html:'임 원' 	   	   	   , colspan:2},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_PERSON'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_DEPOSIT'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_ESTI_BOOK'	  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_SET_100'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_RET_ANU'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_RET_INS'		  	   	   , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_TRANS_ANU'	  	   	   , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'관 리 직' 	   	   	   , colspan:2},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_PERSON'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_DEPOSIT'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_ESTI_BOOK'	  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_SET_100'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   		   , width:80 },
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_RET_ANU'		  	   	   , width:80 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_RET_INS'		  	   	   , width:94 , holdable: 'hold'},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_TRANS_ANU'	  	   	   , width:94 , holdable: 'hold'},
				
				{ xtype: 'component'	 ,  html:'<b>소 계</b>' 	   	   	   , colspan:2},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:94},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:94},
				
				{ xtype: 'component'	 ,  html:'<b>총 계</b>' 	   	   	   , colspan:3},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:94},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:94}
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
			}, 
			api: {
				load: 'gri200ukrvService.selectList',
				submit: 'gri200ukrvService.syncMaster'				
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
		id  : 'gri300ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			detailForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('IN_LARGE_PERSON', 0);
			detailForm.setValue('IN_LARGE_DEPOSIT', 0);
			detailForm.setValue('IN_LARGE_ESTI_BOOK', 0);
			detailForm.setValue('IN_LARGE_SET_100', 0);
			detailForm.setValue('IN_LARGE_RET_ANU', 0);
			detailForm.setValue('IN_LARGE_RET_INS', 0);
			detailForm.setValue('IN_LARGE_TRANS_ANU', 0);
			detailForm.setValue('IN_MEDIUM_PERSON', 0);
			detailForm.setValue('IN_MEDIUM_DEPOSIT', 0);
			detailForm.setValue('IN_MEDIUM_ESTI_BOOK', 0);
			detailForm.setValue('IN_MEDIUM_SET_100', 0);
			detailForm.setValue('IN_MEDIUM_RET_ANU', 0);
			detailForm.setValue('IN_MEDIUM_RET_INS', 0);
			detailForm.setValue('IN_MEDIUM_TRANS_ANU', 0);
			detailForm.setValue('IN_EXPRESS_PERSON', 0);
			detailForm.setValue('IN_EXPRESS_DEPOSIT', 0);
			detailForm.setValue('IN_EXPRESS_ESTI_BOOK', 0);
			detailForm.setValue('IN_EXPRESS_SET_100', 0);
			detailForm.setValue('IN_EXPRESS_RET_ANU', 0);
			detailForm.setValue('IN_EXPRESS_RET_INS', 0);
			detailForm.setValue('IN_EXPRESS_TRANS_ANU', 0);
			detailForm.setValue('IN_NONSTOP_PERSON', 0);
			detailForm.setValue('IN_NONSTOP_DEPOSIT', 0);
			detailForm.setValue('IN_NONSTOP_ESTI_BOOK', 0);
			detailForm.setValue('IN_NONSTOP_SET_100', 0);
			detailForm.setValue('IN_NONSTOP_RET_ANU', 0);
			detailForm.setValue('IN_NONSTOP_RET_INS', 0);
			detailForm.setValue('IN_NONSTOP_TRANS_ANU', 0);
			detailForm.setValue('OUT_SLOW_PERSON', 0);
			detailForm.setValue('OUT_SLOW_DEPOSIT', 0);
			detailForm.setValue('OUT_SLOW_ESTI_BOOK', 0);
			detailForm.setValue('OUT_SLOW_SET_100', 0);
			detailForm.setValue('OUT_SLOW_RET_ANU', 0);
			detailForm.setValue('OUT_SLOW_RET_INS', 0);
			detailForm.setValue('OUT_SLOW_TRANS_ANU', 0);
			detailForm.setValue('OUT_NONSTOP_PERSON', 0);
			detailForm.setValue('OUT_NONSTOP_DEPOSIT', 0);
			detailForm.setValue('OUT_NONSTOP_ESTI_BOOK', 0);
			detailForm.setValue('OUT_NONSTOP_SET_100', 0);
			detailForm.setValue('OUT_NONSTOP_RET_ANU', 0);
			detailForm.setValue('OUT_NONSTOP_RET_INS', 0);
			detailForm.setValue('OUT_NONSTOP_TRANS_ANU', 0);
			detailForm.setValue('OUT_AIR_PERSON', 0);
			detailForm.setValue('OUT_AIR_DEPOSIT', 0);
			detailForm.setValue('OUT_AIR_ESTI_BOOK', 0);
			detailForm.setValue('OUT_AIR_SET_100', 0);
			detailForm.setValue('OUT_AIR_RET_ANU', 0);
			detailForm.setValue('OUT_AIR_RET_INS', 0);
			detailForm.setValue('OUT_AIR_TRANS_ANU', 0);
			detailForm.setValue('AIR_LIMIT_PERSON', 0);
			detailForm.setValue('AIR_LIMIT_DEPOSIT', 0);
			detailForm.setValue('AIR_LIMIT_ESTI_BOOK', 0);
			detailForm.setValue('AIR_LIMIT_SET_100', 0);
			detailForm.setValue('AIR_LIMIT_RET_ANU', 0);
			detailForm.setValue('AIR_LIMIT_RET_INS', 0);
			detailForm.setValue('AIR_LIMIT_TRANS_ANU', 0);
			detailForm.setValue('ETC_VILLEAGE_PERSON', 0);
			detailForm.setValue('ETC_VILLEAGE_DEPOSIT', 0);
			detailForm.setValue('ETC_VILLEAGE_ESTI_BOOK', 0);
			detailForm.setValue('ETC_VILLEAGE_SET_100', 0);
			detailForm.setValue('ETC_VILLEAGE_RET_ANU', 0);
			detailForm.setValue('ETC_VILLEAGE_RET_INS', 0);
			detailForm.setValue('ETC_VILLEAGE_TRANS_ANU', 0);
			detailForm.setValue('MECHANIC_PERSON', 0);
			detailForm.setValue('MECHANIC_DEPOSIT', 0);
			detailForm.setValue('MECHANIC_ESTI_BOOK', 0);
			detailForm.setValue('MECHANIC_SET_100', 0);
			detailForm.setValue('MECHANIC_RET_ANU', 0);
			detailForm.setValue('MECHANIC_RET_INS', 0);
			detailForm.setValue('MECHANIC_TRANS_ANU', 0);
			detailForm.setValue('EXECUTIVE_PERSON', 0);
			detailForm.setValue('EXECUTIVE_DEPOSIT', 0);
			detailForm.setValue('EXECUTIVE_ESTI_BOOK', 0);
			detailForm.setValue('EXECUTIVE_SET_100', 0);
			detailForm.setValue('EXECUTIVE_RET_ANU', 0);
			detailForm.setValue('EXECUTIVE_RET_INS', 0);
			detailForm.setValue('EXECUTIVE_TRANS_ANU', 0);
			detailForm.setValue('ADMINISTRATIVE_PERSON', 0);
			detailForm.setValue('ADMINISTRATIVE_DEPOSIT', 0);
			detailForm.setValue('ADMINISTRATIVE_ESTI_BOOK', 0);
			detailForm.setValue('ADMINISTRATIVE_SET_100', 0);
			detailForm.setValue('ADMINISTRATIVE_RET_ANU', 0);
			detailForm.setValue('ADMINISTRATIVE_RET_INS', 0);
			detailForm.setValue('ADMINISTRATIVE_TRANS_ANU', 0);
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