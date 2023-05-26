<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_gri200ukrv");
%>
<t:appConfig pgmId="gri200ukrv"  >
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
			read: 'gri200ukrvService.selectList'
			//update: 'gri200ukrvService.updateDetail',
			//create: 'gri200ukrvService.insertDetail',
			//destroy: 'gri200ukrvService.deleteDetail',
			//syncAll: 'gri200ukrvService.saveAll'
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
		title: '복리후생비',
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
			layout: {
				type: 'uniTable',
				columns:19,
				tableAttrs: {style: 'border : 1px solid #ced9e7;'},
				tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},	
			items: [
			
				{name: 'COMP_CODE', fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode},
				{ xtype: 'component'	 ,  html:'<b>구분</b>' 				,colspan:4 , rowspan:2},
				{ xtype: 'component'	 ,  html:'<b>합계</b>' 				,rowspan:2 ,width: 86},
				{ xtype: 'component'	 ,  html:'<b>법정복리후생비(원)</b>'      ,colspan:5},
				{ xtype: 'component'	 ,  html:'<b>기타복리후생비(원)</b>'      ,colspan:9 },
				
				{ xtype: 'component'	 ,  html:'<b>소계</b>' 					, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓵<br>국민<br>연금</b>' 		, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓶<br>의료<br>보험료</b>' 		, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓷<br>고용<br>보험료</b>' 		, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓸<br>산재<br>보험료</b>' 		, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>소계</b>' 					, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓹<br>피복비</b>' 			, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓺<br>주부<br>식비</b>' 		, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓻<br>특근/야근/<br>외근식대</b>', width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓼<br>직장<br>연예비</b>' 		, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓽<br>동호회<br>지원금</b>' 	, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⓾<br>경조사</b>' 			, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⑪<br>포상금</b>' 			, width:86},
		    	{ xtype: 'component'	 ,  html:'<b>⑫<br>기타</b>' 				, width:86},
		    	
		    	{ xtype: 'component'	 ,  html:'<b>직<br>접<br>인<br>원</b>' 	,rowspan:21  ,width: 25},
		    	{ xtype: 'component'	 ,  html:'운<br>전<br>직' 	   	   		,rowspan:18  ,width: 25},
		    	{ xtype: 'component'	 ,  html:'시내-일반(대)' 	   				,rowspan:2   ,width: 180},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   				,width: 86},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	    },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'IN_LARGE_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	
		    	/* 시내-일반(중)*/
		    	{ xtype: 'component'	 ,  html:'시내-일반(중)' 	   						   ,rowspan:2   },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   						    },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	   						    },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'IN_MEDIUM_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	/* 시내 - 좌석버스 */ 
		    	{ xtype: 'component'	 ,  html:'시내-좌석버스' 	   						   ,rowspan:2   },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   						    },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	    },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'IN_EXPRESS_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	/*시내-직행좌석*/
		    	{ xtype: 'component'	 ,  html:'시내-직행좌석' 	   						   ,rowspan:2   },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   						    },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	    },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'IN_NONSTOP_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	/*시외-완행버스*/
		    	{ xtype: 'component'	 ,  html:'시외-완행버스' 	   						   ,rowspan:2   },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   						    },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	   						    },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'OUT_SLOW_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	/*시외-직행버스*/
		    	{ xtype: 'component'	 ,  html:'시외-직행버스' 	   							   ,rowspan:2 },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   							  },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	       , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	  },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	       , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'OUT_NONSTOP_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	/*시외-공항버스*/
		    	{ xtype: 'component'	 ,  html:'시외-공항버스' 	   				   	 	   ,rowspan:2  },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   						   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'OUT_AIR_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	/*공항-한정면허*/
		    	{ xtype: 'component'	 ,  html:'공항-한정면허' 	   						   ,rowspan:2  },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   						   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	  },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'AIR_LIMIT_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	/*기타(마을/전세버스) 등*/
		    	{ xtype: 'component'	 ,  html:'기타 (마을/전세버스 등)' 	   					   ,rowspan:2  },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   					     	   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	       , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	       , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	/*정비직*/
		    	{ xtype: 'component'	 ,  html:'정 비 직' 	 								   ,  colspan:2,rowspan:2},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   							   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	       , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	       , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	  },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	       , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'ETC_VILLEAGE_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	/*소계*/
		    	{ xtype: 'component'	 ,  html:'<b>소 계</b>' 	 		   				   , colspan:2},
				{ xtype: 'component'	 ,  html:'집행액' 	  	   						   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
		    	
		    	/* 간접인원 */
		    	{ xtype: 'component'	 ,  html:'<b>간<br>접<br>인<br>원</b>' 	   		   ,rowspan:5 , tdAttrs: {width: 25}},
		    	{ xtype: 'component'	 ,  html:'임 원' 	   								   ,rowspan:2 , colspan:2},
				{ xtype: 'component'	 ,  html:'인원수' 	  	   						   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_ANU_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_MED_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_HIR_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_IND_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_CLO_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_FOD_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_EXT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_ENT_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_CLB_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_FAM_CNT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_REW_CNT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_ETC_CNT' , holdable: 'hold' , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_ANU_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_MED_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_HIR_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_IND_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_CLO_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_FOD_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_EXT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_ENT_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_CLB_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_FAM_AMT' , holdable: 'hold' , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_REW_AMT' , holdable: 'hold' , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'EXECUTIVE_ETC_AMT' , holdable: 'hold' , width:80},
		    	
		    	
		    	/* 관리직*/
		    	{ xtype: 'component'	 ,  html:'관 리 직' 	       , colspan:2,rowspan:2   },
				{ xtype: 'component'	 ,  html:'인원수' 	  	   						   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_ANU_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_MED_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_HIR_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_IND_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_CLO_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_FOD_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_EXT_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_ENT_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_CLB_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_FAM_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_REW_CNT' , holdable: 'hold'  , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_ETC_CNT' , holdable: 'hold'  , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'집행액' 	  	   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_ANU_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_MED_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_HIR_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_IND_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_CLO_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_FOD_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_EXT_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_ENT_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_CLB_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_FAM_CNT' , holdable: 'hold'  , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_REW_CNT' , holdable: 'hold'  , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'ADMINISTRATIVE_ETC_CNT' , holdable: 'hold'  , width:80},
		    	
		    	/* 소계*/
		    	{ xtype: 'component'	 ,  html:'<b>소 계</b>' 	           , colspan:2},
				{ xtype: 'component'	 ,  html:'집행액' 	  	  },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
		    	
		    	{ xtype: 'component'	 ,  html:'<b>총 계</b>' 	           , colspan:3 },
				{ xtype: 'component'	 ,  html:'집행액' 	  	   },
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
				{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true	  	   	   , width:80},
		    	{ xtype: 'uniNumberfield', value:'0', name:'' , readOnly:true			   , width:80}
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
		id  : 'gri200ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			detailForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('IN_LARGE_ANU_CNT', 0);
			detailForm.setValue('IN_LARGE_ANU_AMT', 0);
			detailForm.setValue('IN_LARGE_MED_CNT', 0);
			detailForm.setValue('IN_LARGE_MED_AMT', 0);
			detailForm.setValue('IN_LARGE_HIR_CNT', 0);
			detailForm.setValue('IN_LARGE_HIR_AMT', 0);
			detailForm.setValue('IN_LARGE_IND_CNT', 0);
			detailForm.setValue('IN_LARGE_IND_AMT', 0);
			detailForm.setValue('IN_LARGE_CLO_CNT', 0);
			detailForm.setValue('IN_LARGE_CLO_AMT', 0);
			detailForm.setValue('IN_LARGE_FOD_CNT', 0);
			detailForm.setValue('IN_LARGE_FOD_AMT', 0);
			detailForm.setValue('IN_LARGE_EXT_CNT', 0);
			detailForm.setValue('IN_LARGE_EXT_AMT', 0);
			detailForm.setValue('IN_LARGE_ENT_CNT', 0);
			detailForm.setValue('IN_LARGE_ENT_AMT', 0);
			detailForm.setValue('IN_LARGE_CLB_CNT', 0);
			detailForm.setValue('IN_LARGE_CLB_AMT', 0);
			detailForm.setValue('IN_LARGE_FAM_CNT', 0);
			detailForm.setValue('IN_LARGE_FAM_AMT', 0);
			detailForm.setValue('IN_LARGE_REW_CNT', 0);
			detailForm.setValue('IN_LARGE_REW_AMT', 0);
			detailForm.setValue('IN_LARGE_ETC_CNT', 0);
			detailForm.setValue('IN_LARGE_ETC_AMT', 0);
			detailForm.setValue('IN_MEDIUM_ANU_CNT', 0);
			detailForm.setValue('IN_MEDIUM_ANU_AMT', 0);
			detailForm.setValue('IN_MEDIUM_MED_CNT', 0);
			detailForm.setValue('IN_MEDIUM_MED_AMT', 0);
			detailForm.setValue('IN_MEDIUM_HIR_CNT', 0);
			detailForm.setValue('IN_MEDIUM_HIR_AMT', 0);
			detailForm.setValue('IN_MEDIUM_IND_CNT', 0);
			detailForm.setValue('IN_MEDIUM_IND_AMT', 0);
			detailForm.setValue('IN_MEDIUM_CLO_CNT', 0);
			detailForm.setValue('IN_MEDIUM_CLO_AMT', 0);
			detailForm.setValue('IN_MEDIUM_FOD_CNT', 0);
			detailForm.setValue('IN_MEDIUM_FOD_AMT', 0);
			detailForm.setValue('IN_MEDIUM_EXT_CNT', 0);
			detailForm.setValue('IN_MEDIUM_EXT_AMT', 0);
			detailForm.setValue('IN_MEDIUM_ENT_CNT', 0);
			detailForm.setValue('IN_MEDIUM_ENT_AMT', 0);
			detailForm.setValue('IN_MEDIUM_CLB_CNT', 0);
			detailForm.setValue('IN_MEDIUM_CLB_AMT', 0);
			detailForm.setValue('IN_MEDIUM_FAM_CNT', 0);
			detailForm.setValue('IN_MEDIUM_FAM_AMT', 0);
			detailForm.setValue('IN_MEDIUM_REW_CNT', 0);
			detailForm.setValue('IN_MEDIUM_REW_AMT', 0);
			detailForm.setValue('IN_MEDIUM_ETC_CNT', 0);
			detailForm.setValue('IN_MEDIUM_ETC_AMT', 0);
			detailForm.setValue('IN_EXPRESS_ANU_CNT', 0);
			detailForm.setValue('IN_EXPRESS_ANU_AMT', 0);
			detailForm.setValue('IN_EXPRESS_MED_CNT', 0);
			detailForm.setValue('IN_EXPRESS_MED_AMT', 0);
			detailForm.setValue('IN_EXPRESS_HIR_CNT', 0);
			detailForm.setValue('IN_EXPRESS_HIR_AMT', 0);
			detailForm.setValue('IN_EXPRESS_IND_CNT', 0);
			detailForm.setValue('IN_EXPRESS_IND_AMT', 0);
			detailForm.setValue('IN_EXPRESS_CLO_CNT', 0);
			detailForm.setValue('IN_EXPRESS_CLO_AMT', 0);
			detailForm.setValue('IN_EXPRESS_FOD_CNT', 0);
			detailForm.setValue('IN_EXPRESS_FOD_AMT', 0);
			detailForm.setValue('IN_EXPRESS_EXT_CNT', 0);
			detailForm.setValue('IN_EXPRESS_EXT_AMT', 0);
			detailForm.setValue('IN_EXPRESS_ENT_CNT', 0);
			detailForm.setValue('IN_EXPRESS_ENT_AMT', 0);
			detailForm.setValue('IN_EXPRESS_CLB_CNT', 0);
			detailForm.setValue('IN_EXPRESS_CLB_AMT', 0);
			detailForm.setValue('IN_EXPRESS_FAM_CNT', 0);
			detailForm.setValue('IN_EXPRESS_FAM_AMT', 0);
			detailForm.setValue('IN_EXPRESS_REW_CNT', 0);
			detailForm.setValue('IN_EXPRESS_REW_AMT', 0);
			detailForm.setValue('IN_EXPRESS_ETC_CNT', 0);
			detailForm.setValue('IN_EXPRESS_ETC_AMT', 0);
			detailForm.setValue('IN_NONSTOP_ANU_CNT', 0);
			detailForm.setValue('IN_NONSTOP_ANU_AMT', 0);
			detailForm.setValue('IN_NONSTOP_MED_CNT', 0);
			detailForm.setValue('IN_NONSTOP_MED_AMT', 0);
			detailForm.setValue('IN_NONSTOP_HIR_CNT', 0);
			detailForm.setValue('IN_NONSTOP_HIR_AMT', 0);
			detailForm.setValue('IN_NONSTOP_IND_CNT', 0);
			detailForm.setValue('IN_NONSTOP_IND_AMT', 0);
			detailForm.setValue('IN_NONSTOP_CLO_CNT', 0);
			detailForm.setValue('IN_NONSTOP_CLO_AMT', 0);
			detailForm.setValue('IN_NONSTOP_FOD_CNT', 0);
			detailForm.setValue('IN_NONSTOP_FOD_AMT', 0);
			detailForm.setValue('IN_NONSTOP_EXT_CNT', 0);
			detailForm.setValue('IN_NONSTOP_EXT_AMT', 0);
			detailForm.setValue('IN_NONSTOP_ENT_CNT', 0);
			detailForm.setValue('IN_NONSTOP_ENT_AMT', 0);
			detailForm.setValue('IN_NONSTOP_CLB_CNT', 0);
			detailForm.setValue('IN_NONSTOP_CLB_AMT', 0);
			detailForm.setValue('IN_NONSTOP_FAM_CNT', 0);
			detailForm.setValue('IN_NONSTOP_FAM_AMT', 0);
			detailForm.setValue('IN_NONSTOP_REW_CNT', 0);
			detailForm.setValue('IN_NONSTOP_REW_AMT', 0);
			detailForm.setValue('IN_NONSTOP_ETC_CNT', 0);
			detailForm.setValue('IN_NONSTOP_ETC_AMT', 0);
			detailForm.setValue('OUT_SLOW_ANU_CNT', 0);
			detailForm.setValue('OUT_SLOW_ANU_AMT', 0);
			detailForm.setValue('OUT_SLOW_MED_CNT', 0);
			detailForm.setValue('OUT_SLOW_MED_AMT', 0);
			detailForm.setValue('OUT_SLOW_HIR_CNT', 0);
			detailForm.setValue('OUT_SLOW_HIR_AMT', 0);
			detailForm.setValue('OUT_SLOW_IND_CNT', 0);
			detailForm.setValue('OUT_SLOW_IND_AMT', 0);
			detailForm.setValue('OUT_SLOW_CLO_CNT', 0);
			detailForm.setValue('OUT_SLOW_CLO_AMT', 0);
			detailForm.setValue('OUT_SLOW_FOD_CNT', 0);
			detailForm.setValue('OUT_SLOW_FOD_AMT', 0);
			detailForm.setValue('OUT_SLOW_EXT_CNT', 0);
			detailForm.setValue('OUT_SLOW_EXT_AMT', 0);
			detailForm.setValue('OUT_SLOW_ENT_CNT', 0);
			detailForm.setValue('OUT_SLOW_ENT_AMT', 0);
			detailForm.setValue('OUT_SLOW_CLB_CNT', 0);
			detailForm.setValue('OUT_SLOW_CLB_AMT', 0);
			detailForm.setValue('OUT_SLOW_FAM_CNT', 0);
			detailForm.setValue('OUT_SLOW_FAM_AMT', 0);
			detailForm.setValue('OUT_SLOW_REW_CNT', 0);
			detailForm.setValue('OUT_SLOW_REW_AMT', 0);
			detailForm.setValue('OUT_SLOW_ETC_CNT', 0);
			detailForm.setValue('OUT_SLOW_ETC_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_ANU_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_ANU_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_MED_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_MED_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_HIR_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_HIR_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_IND_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_IND_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_CLO_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_CLO_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_FOD_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_FOD_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_EXT_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_EXT_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_ENT_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_ENT_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_CLB_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_CLB_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_FAM_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_FAM_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_REW_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_REW_AMT', 0);
			detailForm.setValue('OUT_NONSTOP_ETC_CNT', 0);
			detailForm.setValue('OUT_NONSTOP_ETC_AMT', 0);
			detailForm.setValue('OUT_AIR_ANU_CNT', 0);
			detailForm.setValue('OUT_AIR_ANU_AMT', 0);
			detailForm.setValue('OUT_AIR_MED_CNT', 0);
			detailForm.setValue('OUT_AIR_MED_AMT', 0);
			detailForm.setValue('OUT_AIR_HIR_CNT', 0);
			detailForm.setValue('OUT_AIR_HIR_AMT', 0);
			detailForm.setValue('OUT_AIR_IND_CNT', 0);
			detailForm.setValue('OUT_AIR_IND_AMT', 0);
			detailForm.setValue('OUT_AIR_CLO_CNT', 0);
			detailForm.setValue('OUT_AIR_CLO_AMT', 0);
			detailForm.setValue('OUT_AIR_FOD_CNT', 0);
			detailForm.setValue('OUT_AIR_FOD_AMT', 0);
			detailForm.setValue('OUT_AIR_EXT_CNT', 0);
			detailForm.setValue('OUT_AIR_EXT_AMT', 0);
			detailForm.setValue('OUT_AIR_ENT_CNT', 0);
			detailForm.setValue('OUT_AIR_ENT_AMT', 0);
			detailForm.setValue('OUT_AIR_CLB_CNT', 0);
			detailForm.setValue('OUT_AIR_CLB_AMT', 0);
			detailForm.setValue('OUT_AIR_FAM_CNT', 0);
			detailForm.setValue('OUT_AIR_FAM_AMT', 0);
			detailForm.setValue('OUT_AIR_REW_CNT', 0);
			detailForm.setValue('OUT_AIR_REW_AMT', 0);
			detailForm.setValue('OUT_AIR_ETC_CNT', 0);
			detailForm.setValue('OUT_AIR_ETC_AMT', 0);
			detailForm.setValue('AIR_LIMIT_ANU_CNT', 0);
			detailForm.setValue('AIR_LIMIT_ANU_AMT', 0);
			detailForm.setValue('AIR_LIMIT_MED_CNT', 0);
			detailForm.setValue('AIR_LIMIT_MED_AMT', 0);
			detailForm.setValue('AIR_LIMIT_HIR_CNT', 0);
			detailForm.setValue('AIR_LIMIT_HIR_AMT', 0);
			detailForm.setValue('AIR_LIMIT_IND_CNT', 0);
			detailForm.setValue('AIR_LIMIT_IND_AMT', 0);
			detailForm.setValue('AIR_LIMIT_CLO_CNT', 0);
			detailForm.setValue('AIR_LIMIT_CLO_AMT', 0);
			detailForm.setValue('AIR_LIMIT_FOD_CNT', 0);
			detailForm.setValue('AIR_LIMIT_FOD_AMT', 0);
			detailForm.setValue('AIR_LIMIT_EXT_CNT', 0);
			detailForm.setValue('AIR_LIMIT_EXT_AMT', 0);
			detailForm.setValue('AIR_LIMIT_ENT_CNT', 0);
			detailForm.setValue('AIR_LIMIT_ENT_AMT', 0);
			detailForm.setValue('AIR_LIMIT_CLB_CNT', 0);
			detailForm.setValue('AIR_LIMIT_CLB_AMT', 0);
			detailForm.setValue('AIR_LIMIT_FAM_CNT', 0);
			detailForm.setValue('AIR_LIMIT_FAM_AMT', 0);
			detailForm.setValue('AIR_LIMIT_REW_CNT', 0);
			detailForm.setValue('AIR_LIMIT_REW_AMT', 0);
			detailForm.setValue('AIR_LIMIT_ETC_CNT', 0);
			detailForm.setValue('AIR_LIMIT_ETC_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_ANU_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_ANU_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_MED_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_MED_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_HIR_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_HIR_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_IND_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_IND_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_CLO_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_CLO_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_FOD_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_FOD_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_EXT_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_EXT_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_ENT_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_ENT_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_CLB_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_CLB_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_FAM_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_FAM_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_REW_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_REW_AMT', 0);
			detailForm.setValue('ETC_VILLEAGE_ETC_CNT', 0);
			detailForm.setValue('ETC_VILLEAGE_ETC_AMT', 0);
			detailForm.setValue('MECHANIC_ANU_CNT', 0);
			detailForm.setValue('MECHANIC_ANU_AMT', 0);
			detailForm.setValue('MECHANIC_MED_CNT', 0);
			detailForm.setValue('MECHANIC_MED_AMT', 0);
			detailForm.setValue('MECHANIC_HIR_CNT', 0);
			detailForm.setValue('MECHANIC_HIR_AMT', 0);
			detailForm.setValue('MECHANIC_IND_CNT', 0);
			detailForm.setValue('MECHANIC_IND_AMT', 0);
			detailForm.setValue('MECHANIC_CLO_CNT', 0);
			detailForm.setValue('MECHANIC_CLO_AMT', 0);
			detailForm.setValue('MECHANIC_FOD_CNT', 0);
			detailForm.setValue('MECHANIC_FOD_AMT', 0);
			detailForm.setValue('MECHANIC_EXT_CNT', 0);
			detailForm.setValue('MECHANIC_EXT_AMT', 0);
			detailForm.setValue('MECHANIC_ENT_CNT', 0);
			detailForm.setValue('MECHANIC_ENT_AMT', 0);
			detailForm.setValue('MECHANIC_CLB_CNT', 0);
			detailForm.setValue('MECHANIC_CLB_AMT', 0);
			detailForm.setValue('MECHANIC_FAM_CNT', 0);
			detailForm.setValue('MECHANIC_FAM_AMT', 0);
			detailForm.setValue('MECHANIC_REW_CNT', 0);
			detailForm.setValue('MECHANIC_REW_AMT', 0);
			detailForm.setValue('MECHANIC_ETC_CNT', 0);
			detailForm.setValue('MECHANIC_ETC_AMT', 0);
			detailForm.setValue('EXECUTIVE_ANU_CNT', 0);
			detailForm.setValue('EXECUTIVE_ANU_AMT', 0);
			detailForm.setValue('EXECUTIVE_MED_CNT', 0);
			detailForm.setValue('EXECUTIVE_MED_AMT', 0);
			detailForm.setValue('EXECUTIVE_HIR_CNT', 0);
			detailForm.setValue('EXECUTIVE_HIR_AMT', 0);
			detailForm.setValue('EXECUTIVE_IND_CNT', 0);
			detailForm.setValue('EXECUTIVE_IND_AMT', 0);
			detailForm.setValue('EXECUTIVE_CLO_CNT', 0);
			detailForm.setValue('EXECUTIVE_CLO_AMT', 0);
			detailForm.setValue('EXECUTIVE_FOD_CNT', 0);
			detailForm.setValue('EXECUTIVE_FOD_AMT', 0);
			detailForm.setValue('EXECUTIVE_EXT_CNT', 0);
			detailForm.setValue('EXECUTIVE_EXT_AMT', 0);
			detailForm.setValue('EXECUTIVE_ENT_CNT', 0);
			detailForm.setValue('EXECUTIVE_ENT_AMT', 0);
			detailForm.setValue('EXECUTIVE_CLB_CNT', 0);
			detailForm.setValue('EXECUTIVE_CLB_AMT', 0);
			detailForm.setValue('EXECUTIVE_FAM_CNT', 0);
			detailForm.setValue('EXECUTIVE_FAM_AMT', 0);
			detailForm.setValue('EXECUTIVE_REW_CNT', 0);
			detailForm.setValue('EXECUTIVE_REW_AMT', 0);
			detailForm.setValue('EXECUTIVE_ETC_CNT', 0);
			detailForm.setValue('EXECUTIVE_ETC_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_ANU_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_ANU_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_MED_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_MED_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_HIR_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_HIR_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_IND_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_IND_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_CLO_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_CLO_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_FOD_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_FOD_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_EXT_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_EXT_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_ENT_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_ENT_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_CLB_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_CLB_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_FAM_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_FAM_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_REW_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_REW_AMT', 0);
			detailForm.setValue('ADMINISTRATIVE_ETC_CNT', 0);
			detailForm.setValue('ADMINISTRATIVE_ETC_AMT', 0);		
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
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
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