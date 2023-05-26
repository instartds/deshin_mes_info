<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_grg200ukrv");
%>
<t:appConfig pgmId="grg200ukrv"  >
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
			read: 'grg200ukrvService.selectList'
			//update: 'grg200ukrvService.updateDetail',
			//create: 'grg200ukrvService.insertDetail',
			//destroy: 'grg200ukrvService.deleteDetail',
			//syncAll: 'grg200ukrvService.saveAll'
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
		title: '운송원가명세서',
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
    			window.open(CPATH+'/busevaluation/excel/grg200out?SERVICE_YEAR='+panelSearch.getValue('SERVICE_YEAR'), "_self");
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
				columns:16,
				tableAttrs: {style: 'border : 1px solid #ced9e7;'},
    			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			
			items: [
			
				{name: 'COMP_CODE', fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode},
				{ xtype: 'component'	 ,  html:'<b>시내버스(일반/좌석/직좌)</b>' ,colspan:4 , tdAttrs: {height: 28}},
				{ xtype: 'component'	 ,  html:'<b>시외버스(완행/직행/공항)</b>' ,colspan:4},
				{ xtype: 'component'	 ,  html:'<b>공항버스(한정면허)</b>'      ,colspan:4},
				{ xtype: 'component'	 ,  html:'<b>기타(마을/전체)</b>'       ,colspan:4},
		    	
		    	{ xtype: 'component',  html:'<b>계&nbsp;&nbsp;정&nbsp;&nbsp;&nbsp;&nbsp;과&nbsp;&nbsp;&nbsp;목</b>' ,colspan :2 , tdAttrs: {width: 150 , height: 28}},
		    	{ xtype: 'component',  html:'<b>코드</b>'     			, tdAttrs: {width: 30}},
		    	{ xtype: 'component',  html:'<b>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</b>' , tdAttrs: {width: 86}},
		    	{ xtype: 'component',  html:'<b>계&nbsp;&nbsp;정&nbsp;&nbsp;&nbsp;&nbsp;과&nbsp;&nbsp;&nbsp;목</b>' ,colspan :2 , tdAttrs: {width: 150}},
		    	{ xtype: 'component',  html:'<b>코드</b>'     			, tdAttrs: {width: 30}},
		    	{ xtype: 'component',  html:'<b>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</b>' , tdAttrs: {width: 86}},
		    	{ xtype: 'component',  html:'<b>계&nbsp;&nbsp;정&nbsp;&nbsp;&nbsp;&nbsp;과&nbsp;&nbsp;&nbsp;목</b>' ,colspan :2  , tdAttrs: {width: 150}},
		    	{ xtype: 'component',  html:'<b>코드</b>'     			, tdAttrs: {width: 30}},
		    	{ xtype: 'component',  html:'<b>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</b>' , tdAttrs: {width: 86}},
		    	{ xtype: 'component',  html:'<b>계&nbsp;&nbsp;정&nbsp;&nbsp;&nbsp;&nbsp;과&nbsp;&nbsp;&nbsp;목</b>' ,colspan :2 , tdAttrs: {width: 150}},
		    	{ xtype: 'component',  html:'<b>코드</b>'     			, tdAttrs: {width: 30}},
		    	{ xtype: 'component',  html:'<b>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</b>', tdAttrs: {width: 86}},
		    	
		    	{ xtype: 'component',  html:'<b>Ⅰ.</b>'     					, tdAttrs: {width: 30}},
		    	{ xtype: 'component',  html:'<b>재&nbsp;&nbsp;&nbsp;료&nbsp;&nbsp;&nbsp;비</b>' , tdAttrs: {width: 120}},
		    	{ xtype: 'component',  html:'01'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_01'     		,width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅰ.</b>'     					, tdAttrs: {width: 30}},
		    	{ xtype: 'component',  html:'<b>재&nbsp;&nbsp;&nbsp;료&nbsp;&nbsp;&nbsp;비</b>' , tdAttrs: {width: 120}},
		    	{ xtype: 'component',  html:'01'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_01'     		,width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅰ.</b>'     					, tdAttrs: {width: 30}},
		    	{ xtype: 'component',  html:'<b>재&nbsp;&nbsp;&nbsp;료&nbsp;&nbsp;&nbsp;비</b>' , tdAttrs: {width: 120}},
		    	{ xtype: 'component',  html:'01'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_01'     		,width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅰ.</b>'     					, tdAttrs: {width: 30}},
		    	{ xtype: 'component',  html:'<b>재&nbsp;&nbsp;&nbsp;료&nbsp;&nbsp;&nbsp;비</b>' , tdAttrs: {width: 120}},
		    	{ xtype: 'component',  html:'01'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_01'     		,width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'1.'     			,rowspan:2},
		    	{ xtype: 'component',  html:'연료비(경유)'     						},
		    	{ xtype: 'component',  html:'02'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_02_01'     	,width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'1.'     			,rowspan:2},
		    	{ xtype: 'component',  html:'연료비(경유)'     						},
		    	{ xtype: 'component',  html:'02'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_02_01'     	,width:80 , holdable: 'hold' },
		    	{ xtype: 'component',  html:'1.'     			,rowspan:2},
		    	{ xtype: 'component',  html:'연료비(경유)'     						},
		    	{ xtype: 'component',  html:'02'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_02_01'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'1.'     			,rowspan:2},
		    	{ xtype: 'component',  html:'연료비(경유)'     						},
		    	{ xtype: 'component',  html:'02'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_02_01'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'보조금(경유)'     						},
		    	{ xtype: 'component',  html:'02'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_02_02'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'보조금(경유)'     						},
		    	{ xtype: 'component',  html:'02'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_02_02'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'보조금(경유)'     						},
		    	{ xtype: 'component',  html:'02'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_02_02'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'보조금(경유)'     						},
		    	{ xtype: 'component',  html:'02'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_02_02'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'2.'     			,rowspan:2},
		    	{ xtype: 'component',  html:'연료비(CNG)'     					},
		    	{ xtype: 'component',  html:'03'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_03_01'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'2.'     			,rowspan:2},
		    	{ xtype: 'component',  html:'연료비(CNG)'     					},
		    	{ xtype: 'component',  html:'03'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_03_01'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'2.'     			,rowspan:2},
		    	{ xtype: 'component',  html:'연료비(CNG)'     					},
		    	{ xtype: 'component',  html:'03'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_03_01'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'2.'     			,rowspan:2},
		    	{ xtype: 'component',  html:'연료비(CNG)'     					},
		    	{ xtype: 'component',  html:'03'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_03_01'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'보조금(CNG)'     					},
		    	{ xtype: 'component',  html:'03'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_03_02'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'보조금(CNG)'     					},
		    	{ xtype: 'component',  html:'03'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_03_02'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'보조금(CNG)'     					},
		    	{ xtype: 'component',  html:'03'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_03_02'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'보조금(CNG)'     					},
		    	{ xtype: 'component',  html:'03'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_03_02'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'부  품  비'     						},
		    	{ xtype: 'component',  html:'04'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_04'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'부  품  비'     						},
		    	{ xtype: 'component',  html:'04'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_04'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'부  품  비'     						},
		    	{ xtype: 'component',  html:'04'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_04'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'부  품  비'     						},
		    	{ xtype: 'component',  html:'04'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_04'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'4.'     							},
		    	{ xtype: 'component',  html:'자가구입타이어비'     					},
		    	{ xtype: 'component',  html:'05'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_05'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'4.'     							},
		    	{ xtype: 'component',  html:'자가구입타이어비'     					},
		    	{ xtype: 'component',  html:'05'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_05'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'4.'     							},
		    	{ xtype: 'component',  html:'자가구입타이어비'     					},
		    	{ xtype: 'component',  html:'05'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_05'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'4.'     							},
		    	{ xtype: 'component',  html:'자가구입타이어비'     					},
		    	{ xtype: 'component',  html:'05'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_05'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'5.'     							},
		    	{ xtype: 'component',  html:'외주수리비'     						},
		    	{ xtype: 'component',  html:'06'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_06'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'5.'     							},
		    	{ xtype: 'component',  html:'외주수리비'     						},
		    	{ xtype: 'component',  html:'06'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_06'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'5.'     							},
		    	{ xtype: 'component',  html:'외주수리비'     						},
		    	{ xtype: 'component',  html:'06'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_06'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'5.'     							},
		    	{ xtype: 'component',  html:'외주수리비'     						},
		    	{ xtype: 'component',  html:'06'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_06'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'6.'     							},
		    	{ xtype: 'component',  html:'외주타이어비'     						},
		    	{ xtype: 'component',  html:'07'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_07'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'6.'     							},
		    	{ xtype: 'component',  html:'외주타이어비'     						},
		    	{ xtype: 'component',  html:'07'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_07'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'6.'     							},
		    	{ xtype: 'component',  html:'외주타이어비'     						},
		    	{ xtype: 'component',  html:'07'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_07'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'6.'     							},
		    	{ xtype: 'component',  html:'외주타이어비'     						},
		    	{ xtype: 'component',  html:'07'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_07'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'7.'     							},
		    	{ xtype: 'component',  html:'기타'     							},
		    	{ xtype: 'component',  html:'08'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_08'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'7.'     							},
		    	{ xtype: 'component',  html:'기타'     							},
		    	{ xtype: 'component',  html:'08'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_08'  , width:80 , holdable: 'hold'},
				{ xtype: 'component',  html:'7.'     							},
		    	{ xtype: 'component',  html:'기타'     							},
		    	{ xtype: 'component',  html:'08'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_08'  , width:80 , holdable: 'hold'},
				{ xtype: 'component',  html:'7.'     							},
		    	{ xtype: 'component',  html:'기타'     							},
		    	{ xtype: 'component',  html:'08'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_08'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'<b>Ⅱ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>노&nbsp;&nbsp;&nbsp;무&nbsp;&nbsp;&nbsp;비</b>'},
		    	{ xtype: 'component',  html:'09'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_09'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅱ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>노&nbsp;&nbsp;&nbsp;무&nbsp;&nbsp;&nbsp;비</b>'},
		    	{ xtype: 'component',  html:'09'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_09'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅱ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>노&nbsp;&nbsp;&nbsp;무&nbsp;&nbsp;&nbsp;비</b>'},
		    	{ xtype: 'component',  html:'09'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_09'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅱ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>노&nbsp;&nbsp;&nbsp;무&nbsp;&nbsp;&nbsp;비</b>'},
		    	{ xtype: 'component',  html:'09'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_09'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'1.'     							},
		    	{ xtype: 'component',  html:'급여'     							},
		    	{ xtype: 'component',  html:'10'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_10'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'1.'     							},
		    	{ xtype: 'component',  html:'급여'     							},
		    	{ xtype: 'component',  html:'10'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_10'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'1.'     							},
		    	{ xtype: 'component',  html:'급여'     							},
		    	{ xtype: 'component',  html:'10'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_10'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'1.'     							},
		    	{ xtype: 'component',  html:'급여'     							},
		    	{ xtype: 'component',  html:'10'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_10'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'2.'     							},
		    	{ xtype: 'component',  html:'일용급여'     						},
		    	{ xtype: 'component',  html:'11'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_11'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'2.'     							},
		    	{ xtype: 'component',  html:'일용급여'     						},
		    	{ xtype: 'component',  html:'11'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_11'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'2.'     							},
		    	{ xtype: 'component',  html:'일용급여'     						},
		    	{ xtype: 'component',  html:'11'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_11'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'2.'     							},
		    	{ xtype: 'component',  html:'일용급여'     						},
		    	{ xtype: 'component',  html:'11'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_11'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'퇴직급여'     						},
		    	{ xtype: 'component',  html:'12'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_12'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'퇴직급여'     						},
		    	{ xtype: 'component',  html:'12'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_12'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'퇴직급여'     						},
		    	{ xtype: 'component',  html:'12'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_12'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'퇴직급여'     						},
		    	{ xtype: 'component',  html:'12'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_12'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'<b>Ⅲ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>경&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;비</b>'},
		    	{ xtype: 'component',  html:'13'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_13'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅲ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>경&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;비</b>'},
		    	{ xtype: 'component',  html:'13'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_13'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅲ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>경&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;비</b>'},
		    	{ xtype: 'component',  html:'13'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_13'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅲ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>경&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;비</b>'},
		    	{ xtype: 'component',  html:'13'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_13'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'1.'     							},
		    	{ xtype: 'component',  html:'전력·가스·수도비'     					},
		    	{ xtype: 'component',  html:'14'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_14'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'1.'     							},
		    	{ xtype: 'component',  html:'전력·가스·수도비'     					},
		    	{ xtype: 'component',  html:'14'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_14'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'1.'     							},
		    	{ xtype: 'component',  html:'전력·가스·수도비'     					},
		    	{ xtype: 'component',  html:'14'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_14'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'1.'     							},
		    	{ xtype: 'component',  html:'전력·가스·수도비'     					},
		    	{ xtype: 'component',  html:'14'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_14'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'2.'     							},
		    	{ xtype: 'component',  html:'통행료'     							},
		    	{ xtype: 'component',  html:'15'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_15'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'2.'     							},
		    	{ xtype: 'component',  html:'통행료'     							},
		    	{ xtype: 'component',  html:'15'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_15'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'2.'     							},
		    	{ xtype: 'component',  html:'통행료'     							},
		    	{ xtype: 'component',  html:'15'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_15'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'2.'     							},
		    	{ xtype: 'component',  html:'통행료'     							},
		    	{ xtype: 'component',  html:'15'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_15'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'청소비'     							},
		    	{ xtype: 'component',  html:'16'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_16'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'청소비'     							},
		    	{ xtype: 'component',  html:'16'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_16'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'청소비'     							},
		    	{ xtype: 'component',  html:'16'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_16'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'3.'     							},
		    	{ xtype: 'component',  html:'청소비'     							},
		    	{ xtype: 'component',  html:'16'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_16'  , width:80 , holdable: 'hold'},

		    	{ xtype: 'component',  html:'4.'     							},
		    	{ xtype: 'component',  html:'감가삼각비'     						},
		    	{ xtype: 'component',  html:'17'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_17'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'4.'     							},
		    	{ xtype: 'component',  html:'감가삼각비'     						},
		    	{ xtype: 'component',  html:'17'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_17'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'4.'     							},
		    	{ xtype: 'component',  html:'감가삼각비'     						},
		    	{ xtype: 'component',  html:'17'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_17'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'4.'     							},
		    	{ xtype: 'component',  html:'감가삼각비'     						},
		    	{ xtype: 'component',  html:'17'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_17'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'5.'     							},
		    	{ xtype: 'component',  html:'수선 및 소모품비'     					},
		    	{ xtype: 'component',  html:'18'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_18'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'5.'     							},
		    	{ xtype: 'component',  html:'수선 및 소모품비'     					},
		    	{ xtype: 'component',  html:'18'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_18'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'5.'     							},
		    	{ xtype: 'component',  html:'수선 및 소모품비'     					},
		    	{ xtype: 'component',  html:'18'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_18'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'5.'     							},
		    	{ xtype: 'component',  html:'수선 및 소모품비'     					},
		    	{ xtype: 'component',  html:'18'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_18'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'6.'     							},
		    	{ xtype: 'component',  html:'세금과공과'     						},
		    	{ xtype: 'component',  html:'19'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_19'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'6.'     							},
		    	{ xtype: 'component',  html:'세금과공과'     						},
		    	{ xtype: 'component',  html:'19'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_19'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'6.'     							},
		    	{ xtype: 'component',  html:'세금과공과'     						},
		    	{ xtype: 'component',  html:'19'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_19'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'6.'     							},
		    	{ xtype: 'component',  html:'세금과공과'     						},
		    	{ xtype: 'component',  html:'19'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_19'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'7.'     							},
		    	{ xtype: 'component',  html:'임차료'     							},
		    	{ xtype: 'component',  html:'20'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_20'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'7.'     							},
		    	{ xtype: 'component',  html:'임차료'     							},
		    	{ xtype: 'component',  html:'20'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_20'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'7.'     							},
		    	{ xtype: 'component',  html:'임차료'     							},
		    	{ xtype: 'component',  html:'20'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_20'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'7.'     							},
		    	{ xtype: 'component',  html:'임차료'     							},
		    	{ xtype: 'component',  html:'20'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_20'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓵차고지'     						},
		    	{ xtype: 'component',  html:'21'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_21'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓵차고지'     						},
		    	{ xtype: 'component',  html:'21'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_21'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓵차고지'     						},
		    	{ xtype: 'component',  html:'21'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_21'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓵차고지'     						},
		    	{ xtype: 'component',  html:'21'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_21'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓶차량'     							},
		    	{ xtype: 'component',  html:'22'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_22'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓶차량'     							},
		    	{ xtype: 'component',  html:'22'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_22'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓶차량'     							},
		    	{ xtype: 'component',  html:'22'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_22'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓶차량'     							},
		    	{ xtype: 'component',  html:'22'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_22'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓷기타'     							},
		    	{ xtype: 'component',  html:'23'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_23'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓷기타'     							},
		    	{ xtype: 'component',  html:'23'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_23'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓷기타'     							},
		    	{ xtype: 'component',  html:'23'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_23'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:''     								},
		    	{ xtype: 'component',  html:'⓷기타'     							},
		    	{ xtype: 'component',  html:'23'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_23'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'8.'     							},
		    	{ xtype: 'component',  html:'보험료'     							},
		    	{ xtype: 'component',  html:'24'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_24'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'8.'     							},
		    	{ xtype: 'component',  html:'보험료'     							},
		    	{ xtype: 'component',  html:'24'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_24'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'8.'     							},
		    	{ xtype: 'component',  html:'보험료'     							},
		    	{ xtype: 'component',  html:'24'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_24'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'8.'     							},
		    	{ xtype: 'component',  html:'보험료'     							},
		    	{ xtype: 'component',  html:'24'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_24'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'9.'     							},
		    	{ xtype: 'component',  html:'복리후생비'     						},
		    	{ xtype: 'component',  html:'25'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_25'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'9.'     							},
		    	{ xtype: 'component',  html:'복리후생비'     						},
		    	{ xtype: 'component',  html:'25'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_25'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'9.'     							},
		    	{ xtype: 'component',  html:'복리후생비'     						},
		    	{ xtype: 'component',  html:'25'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_25'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'9.'     							},
		    	{ xtype: 'component',  html:'복리후생비'     						},
		    	{ xtype: 'component',  html:'25'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_25'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'10.'     							},
		    	{ xtype: 'component',  html:'교육훈련비'     						},
		    	{ xtype: 'component',  html:'26'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_26'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'10.'     							},
		    	{ xtype: 'component',  html:'교육훈련비'     						},
		    	{ xtype: 'component',  html:'26'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_26'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'10.'     							},
		    	{ xtype: 'component',  html:'교육훈련비'     						},
		    	{ xtype: 'component',  html:'26'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_26'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'10.'     							},
		    	{ xtype: 'component',  html:'교육훈련비'     						},
		    	{ xtype: 'component',  html:'26'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_26'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'11.'     							},
		    	{ xtype: 'component',  html:'카드수수료'     						},
		    	{ xtype: 'component',  html:'27'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_27'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'11.'     							},
		    	{ xtype: 'component',  html:'카드수수료'     						},
		    	{ xtype: 'component',  html:'27'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_27'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'11.'     							},
		    	{ xtype: 'component',  html:'카드수수료'     						},
		    	{ xtype: 'component',  html:'27'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_27'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'11.'     							},
		    	{ xtype: 'component',  html:'카드수수료'     						},
		    	{ xtype: 'component',  html:'27'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_27'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'12.'     							},
		    	{ xtype: 'component',  html:'매표수수료'     						},
		    	{ xtype: 'component',  html:'28'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_28'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'12.'     							},
		    	{ xtype: 'component',  html:'매표수수료'     						},
		    	{ xtype: 'component',  html:'28'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_28'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'12.'     							},
		    	{ xtype: 'component',  html:'매표수수료'     						},
		    	{ xtype: 'component',  html:'28'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_28'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'12.'     							},
		    	{ xtype: 'component',  html:'매표수수료'     						},
		    	{ xtype: 'component',  html:'28'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_28'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'13.'     							},
		    	{ xtype: 'component',  html:'사고처리비'     						},
		    	{ xtype: 'component',  html:'29'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_29'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'13.'     							},
		    	{ xtype: 'component',  html:'사고처리비'     						},
		    	{ xtype: 'component',  html:'29'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_29'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'13.'     							},
		    	{ xtype: 'component',  html:'사고처리비'     						},
		    	{ xtype: 'component',  html:'29'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_29'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'13.'     							},
		    	{ xtype: 'component',  html:'사고처리비'     						},
		    	{ xtype: 'component',  html:'29'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_29'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'14.'     							},
		    	{ xtype: 'component',  html:'기타'     							},
		    	{ xtype: 'component',  html:'30'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_30'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'14.'     							},
		    	{ xtype: 'component',  html:'기타'     							},
		    	{ xtype: 'component',  html:'30'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_30'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'14.'     							},
		    	{ xtype: 'component',  html:'기타'     							},
		    	{ xtype: 'component',  html:'30'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_30'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'14.'     							},
		    	{ xtype: 'component',  html:'기타'     							},
		    	{ xtype: 'component',  html:'30'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_30'  , width:80 , holdable: 'hold'},
		    	
		    	{ xtype: 'component',  html:'<b>Ⅳ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>당기총운송원가</b>' 					},
		    	{ xtype: 'component',  html:'31'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_IN_31'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅳ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>당기총운송원가</b>' 					},
		    	{ xtype: 'component',  html:'31'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_OUT_31'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅳ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>당기총운송원가</b>' 					},
		    	{ xtype: 'component',  html:'31'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_AIR_31'  , width:80 , holdable: 'hold'},
		    	{ xtype: 'component',  html:'<b>Ⅳ.</b>'     					},
		    	{ xtype: 'component',  html:'<b>당기총운송원가</b>' 					},
		    	{ xtype: 'component',  html:'31'     							},
		    	{ xtype: 'uniNumberfield', value:'0',  name:'G_ETC_31'  , width:80 , holdable: 'hold' }	
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
		}, api: {
				load: 'grg200ukrvService.selectList',
				submit: 'grg200ukrvService.syncMaster'				
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
		id  : 'grg200ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			detailForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('G_IN_01', 0);
			detailForm.setValue('G_IN_02_01', 0);
			detailForm.setValue('G_IN_02_02', 0);
			detailForm.setValue('G_IN_03_01', 0);
			detailForm.setValue('G_IN_03_02', 0);
			detailForm.setValue('G_IN_04', 0);
			detailForm.setValue('G_IN_05', 0);
			detailForm.setValue('G_IN_06', 0);
			detailForm.setValue('G_IN_07', 0);
			detailForm.setValue('G_IN_08', 0);
			detailForm.setValue('G_IN_09', 0);
			detailForm.setValue('G_IN_10', 0);
			detailForm.setValue('G_IN_11', 0);
			detailForm.setValue('G_IN_12', 0);
			detailForm.setValue('G_IN_13', 0);
			detailForm.setValue('G_IN_14', 0);
			detailForm.setValue('G_IN_15', 0);
			detailForm.setValue('G_IN_16', 0);
			detailForm.setValue('G_IN_17', 0);
			detailForm.setValue('G_IN_18', 0);
			detailForm.setValue('G_IN_19', 0);
			detailForm.setValue('G_IN_20', 0);
			detailForm.setValue('G_IN_21', 0);
			detailForm.setValue('G_IN_22', 0);
			detailForm.setValue('G_IN_23', 0);
			detailForm.setValue('G_IN_24', 0);
			detailForm.setValue('G_IN_25', 0);
			detailForm.setValue('G_IN_26', 0);
			detailForm.setValue('G_IN_27', 0);
			detailForm.setValue('G_IN_28', 0);
			detailForm.setValue('G_IN_29', 0);
			detailForm.setValue('G_IN_30', 0);
			detailForm.setValue('G_IN_31', 0);
			detailForm.setValue('G_OUT_01', 0);
			detailForm.setValue('G_OUT_02_01', 0);
			detailForm.setValue('G_OUT_02_02', 0);
			detailForm.setValue('G_OUT_03_01', 0);
			detailForm.setValue('G_OUT_03_02', 0);
			detailForm.setValue('G_OUT_04', 0);
			detailForm.setValue('G_OUT_05', 0);
			detailForm.setValue('G_OUT_06', 0);
			detailForm.setValue('G_OUT_07', 0);
			detailForm.setValue('G_OUT_08', 0);
			detailForm.setValue('G_OUT_09', 0);
			detailForm.setValue('G_OUT_10', 0);
			detailForm.setValue('G_OUT_11', 0);
			detailForm.setValue('G_OUT_12', 0);
			detailForm.setValue('G_OUT_13', 0);
			detailForm.setValue('G_OUT_14', 0);
			detailForm.setValue('G_OUT_15', 0);
			detailForm.setValue('G_OUT_16', 0);
			detailForm.setValue('G_OUT_17', 0);
			detailForm.setValue('G_OUT_18', 0);
			detailForm.setValue('G_OUT_19', 0);
			detailForm.setValue('G_OUT_20', 0);
			detailForm.setValue('G_OUT_21', 0);
			detailForm.setValue('G_OUT_22', 0);
			detailForm.setValue('G_OUT_23', 0);
			detailForm.setValue('G_OUT_24', 0);
			detailForm.setValue('G_OUT_25', 0);
			detailForm.setValue('G_OUT_26', 0);
			detailForm.setValue('G_OUT_27', 0);
			detailForm.setValue('G_OUT_28', 0);
			detailForm.setValue('G_OUT_29', 0);
			detailForm.setValue('G_OUT_30', 0);
			detailForm.setValue('G_OUT_31', 0);
			detailForm.setValue('G_AIR_01', 0);
			detailForm.setValue('G_AIR_02_01', 0);
			detailForm.setValue('G_AIR_02_02', 0);
			detailForm.setValue('G_AIR_03_01', 0);
			detailForm.setValue('G_AIR_03_02', 0);
			detailForm.setValue('G_AIR_04', 0);
			detailForm.setValue('G_AIR_05', 0);
			detailForm.setValue('G_AIR_06', 0);
			detailForm.setValue('G_AIR_07', 0);
			detailForm.setValue('G_AIR_08', 0);
			detailForm.setValue('G_AIR_09', 0);
			detailForm.setValue('G_AIR_10', 0);
			detailForm.setValue('G_AIR_11', 0);
			detailForm.setValue('G_AIR_12', 0);
			detailForm.setValue('G_AIR_13', 0);
			detailForm.setValue('G_AIR_14', 0);
			detailForm.setValue('G_AIR_15', 0);
			detailForm.setValue('G_AIR_16', 0);
			detailForm.setValue('G_AIR_17', 0);
			detailForm.setValue('G_AIR_18', 0);
			detailForm.setValue('G_AIR_19', 0);
			detailForm.setValue('G_AIR_20', 0);
			detailForm.setValue('G_AIR_21', 0);
			detailForm.setValue('G_AIR_22', 0);
			detailForm.setValue('G_AIR_23', 0);
			detailForm.setValue('G_AIR_24', 0);
			detailForm.setValue('G_AIR_25', 0);
			detailForm.setValue('G_AIR_26', 0);
			detailForm.setValue('G_AIR_27', 0);
			detailForm.setValue('G_AIR_28', 0);
			detailForm.setValue('G_AIR_29', 0);
			detailForm.setValue('G_AIR_30', 0);
			detailForm.setValue('G_AIR_31', 0);
			detailForm.setValue('G_ETC_01', 0);
			detailForm.setValue('G_ETC_02_01', 0);
			detailForm.setValue('G_ETC_02_02', 0);
			detailForm.setValue('G_ETC_03_01', 0);
			detailForm.setValue('G_ETC_03_02', 0);
			detailForm.setValue('G_ETC_04', 0);
			detailForm.setValue('G_ETC_05', 0);
			detailForm.setValue('G_ETC_06', 0);
			detailForm.setValue('G_ETC_07', 0);
			detailForm.setValue('G_ETC_08', 0);
			detailForm.setValue('G_ETC_09', 0);
			detailForm.setValue('G_ETC_10', 0);
			detailForm.setValue('G_ETC_11', 0);
			detailForm.setValue('G_ETC_12', 0);
			detailForm.setValue('G_ETC_13', 0);
			detailForm.setValue('G_ETC_14', 0);
			detailForm.setValue('G_ETC_15', 0);
			detailForm.setValue('G_ETC_16', 0);
			detailForm.setValue('G_ETC_17', 0);
			detailForm.setValue('G_ETC_18', 0);
			detailForm.setValue('G_ETC_19', 0);
			detailForm.setValue('G_ETC_20', 0);
			detailForm.setValue('G_ETC_21', 0);
			detailForm.setValue('G_ETC_22', 0);
			detailForm.setValue('G_ETC_23', 0);
			detailForm.setValue('G_ETC_24', 0);
			detailForm.setValue('G_ETC_25', 0);
			detailForm.setValue('G_ETC_26', 0);
			detailForm.setValue('G_ETC_27', 0);
			detailForm.setValue('G_ETC_28', 0);
			detailForm.setValue('G_ETC_29', 0);
			detailForm.setValue('G_ETC_30', 0);
			detailForm.setValue('G_ETC_31', 0);
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