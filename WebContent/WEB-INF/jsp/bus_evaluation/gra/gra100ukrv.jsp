<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_gra100ukrv");
%>
<t:appConfig pgmId="gra100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	-->  
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {

	    fields: []
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gra100ukrvService.selectList',
			update: 'gra100ukrvService.updateDetail',
			create: 'gra100ukrvService.insertDetail',
			destroy: 'gra100ukrvService.deleteDetail',
			syncAll: 'gra100ukrvService.saveAll'
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
		title: '회사개요',
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
	
   
   var detailForm = Unilite.createForm('detailForm',{	
		autoScroll: true,
		region: 'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
		border: 1,
		padding: '1 1 1 1',  
		tbar: [{
        	xtype: 'uniBaseButton',
    		iconCls: 'icon-excel',
    		width: 26, 
    		height: 26,
    		tooltip: '엑셀 다운로드',
    		handler: function() { 
    			window.open(CPATH+'/busevaluation/excel/gra100out?SERVICE_YEAR='+panelSearch.getValue('SERVICE_YEAR'), "_self");
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
				columns:6,
				tableAttrs: {style: 'border : 1px solid #ced9e7;'},
    			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
			},
			
			items: [
			
			    {name: 'COMP_CODE', fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode},
				{ xtype: 'component'	 ,  html:'<b>A1.법 인 명(NM)</b>' 		 , width :175 },
		    	{ xtype: 'uniTextfield'	 , name:'COMP_NAME'                  , width :170 , holdable: 'hold'},
		    	{ xtype: 'component'	 ,  html:'<b>A2.법 인 명(ID)</b>' 		 , width :175 },
		    	{ xtype: 'uniTextfield'	 ,  name:'COMP_ID'           	   	 , width :170 , holdable: 'hold'},		 
		    	{ xtype: 'component'	 ,  html:'<b>A3.사업등록번호</b>'  	     , width :175 },
		    	{ xtype: 'uniTextfield'	 ,  name:'COMPANY_NUM'           	 , width :170 , holdable: 'hold'},
		    	
		    	{ xtype: 'component'	 ,  html:'<b>A4.소 재 지</b>'    		 , rowspan:2 },
		    	{ xtype: 'component'	 ,  html:'도/시'       							, tdAttrs: {height: 27} },
		    	{ xtype: 'component'	 ,  html:'시/군/구'     							 },
		    	{ xtype: 'component'	 ,  html:'읍/면/동'     							 },		 
		    	{ xtype: 'component'	 ,  html:'이하' 		   				 , colspan:2 },
		    	
		    	{ xtype: 'uniTextfield'	 ,  name:'ADDR1'           			 , width :170, holdable: 'hold'},
		    	{ xtype: 'uniTextfield'	 ,  name:'ADDR2'   		  			 , width :170, holdable: 'hold'},
		    	{ xtype: 'uniTextfield'	 ,  name:'ADDR3'          	 		 , width :170, holdable: 'hold'},		 
		    	{ xtype: 'uniTextfield'	 ,  name:'ADDR4' 		  			 , colspan:2  , width :347 , holdable: 'hold'},
		    	
		    	{ xtype: 'component'	 ,  html:'<b>A5.자 본 금(원)</b>' 					 },
		    	{ xtype: 'uniNumberfield',  name:'CAPITAL_AMT' , value : '0', width :347 ,colspan:2 , holdable: 'hold'},
		    	{ xtype: 'component'	 ,  html:'주주명단(상위4인)' 						 },
		    	{ xtype: 'component'	 ,  html:'주식수(출자비율)'  						 },
		    	{ xtype: 'component'	 ,  html:'지분율'        							 },
		    	
		    	{ xtype: 'component'	 ,  html:'<b>A6.주주현황</b>'   					 },
		    	{ xtype: 'component'	 ,  html:'주주수(명)'  							 },
		    	{ xtype: 'uniNumberfield', value : '0',  name:'STOCKHOLDER_NUM'    , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniTextfield'  , value : '0',  name:'STOCKHOLDER_NAME1'  , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'STOCK_NUM1'   	   , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniTextfield', value : '0',  name:'colSum1_1'            , width :170 , readOnly:true, fieldStyle: 'text-align: right; font-weight:bold;'},
		    	
		    	{ xtype: 'component'	 ,  html:'<b>A7.종사자수</b>'  			   ,rowspan:5},
		    	{ xtype: 'component'	 ,  html:'구   분'   	 							 },
		    	{ xtype: 'component'	 ,  html:'인원수'      							 },
		    	{ xtype: 'uniTextfield'  , value : '0',  name:'STOCKHOLDER_NAME2'  , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'STOCK_NUM2'         , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniTextfield', value : '0',  name:'colSum1_2'            , width :170 , readOnly:true, fieldStyle: 'text-align: right; font-weight:bold;'},
		    	
		    	{ xtype: 'component'	 ,  html:'임   원(명)'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'EXECUTIVE_NUM' 	   , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniTextfield'  , value : '0',  name:'STOCKHOLDER_NAME3'  , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'STOCK_NUM3'         , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniTextfield', value : '0',  name:'colSum1_3'            , width :170 , readOnly:true, fieldStyle: 'text-align: right; font-weight:bold;'},
		    	
		    	{ xtype: 'component'	 ,  html:'관리직(명)'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'ADMINISTRATIVE_NUM' , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniTextfield'  , value : '0',  name:'STOCKHOLDER_NAME4'  , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'STOCK_NUM4'         , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniTextfield', value : '0',  name:'colSum1_4'        	   , width :170 , readOnly:true, fieldStyle: 'text-align: right; font-weight:bold;'},
		    	
		    	{ xtype: 'component'	 ,  html:'운전직(명)'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'DRIVER_NUM'         , width :170 , holdable: 'hold'},
		    	{ xtype: 'component'	 ,  html:'기   타'   },
		    	{ xtype: 'uniNumberfield', value : '0',  name:'STOCK_NUM_ETC'      , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniTextfield', value : '0',  name:'colSum1_5'            , width :170 , readOnly:true, fieldStyle: 'text-align: right; font-weight:bold;'},
		    	
		    	{ xtype: 'component'	 ,  html:'정비직(명)'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'MECHANIC_NUM'       , width :170 , holdable: 'hold'},
		    	{ xtype: 'component'	 ,  html:'<b>총   계</b>'      },
		    	{ xtype: 'uniNumberfield', value : '0',  name:'STOCK_NUM_TOT'      , width :170 , readOnly:true, fieldStyle: 'font-weight:bold;'},
		    	{ xtype: 'uniTextfield', value : '0',  name:'colTotSum'            , width :170 , readOnly:true, fieldStyle: 'text-align: right;'},

		    	{ xtype: 'component'	 ,  html:'<b>A8.차량현황</b>'  			   , rowspan:11},
		    	{ xtype: 'component'	 ,  html:'구   분'   						   , width :175, tdAttrs: {height: 27}},
		    	{ xtype: 'component'	 ,  html:'<b>계</b>'     				   , width :175},
		    	{ xtype: 'component'	 ,  html:'일반노선(대)'					   , width :175},
		    	{ xtype: 'component'	 ,  html:'벽지노선(대)'  					   , width :175},
		    	{ xtype: 'component'	 ,  html:'공영버스(대)'					   , width :175},
		    	
		    	{ xtype: 'component'	 ,  html:'<b>계</b>'   	},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'lowSum1_1'      			   , width :170  , readOnly:true, fieldStyle: 'font-weight:bold;'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'lowSum1_2'     			   , width :170  , readOnly:true, fieldStyle: 'font-weight:bold;'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'lowSum1_3'     			   , width :170  , readOnly:true, fieldStyle: 'font-weight:bold;'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'lowSum1_4'     			   , width :170  , readOnly:true, fieldStyle: 'font-weight:bold;'},
		    	
		    	{ xtype: 'component'	 ,  html:'시내-일반(대)'   	},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'colSum2_1'      			   , width :170 , readOnly:true},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'IN_LARGE_GEN'       , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'IN_LARGE_CTR'       , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'IN_LARGE_PUB'       , width :170 , holdable: 'hold'},
		    	
		    	{ xtype: 'component'	 ,  html:'시내-일반(중)'   	},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'colSum2_2'      			   , width :170 , readOnly:true},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'IN_MEDIUM_GEN'      , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'IN_MEDIUM_CTR'      , width :170 , holdable: 'hold'},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'IN_MEDIUM_PUB'      , width :170 , holdable: 'hold'},
		    	
		    	{ xtype: 'component'	 ,  html:'시내-좌석버스'   	},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'colSum2_3'      			   , width :170 , readOnly:true},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'IN_EXPRESS_GEN'     , width :170 , holdable: 'hold'},
		    	{ xtype: 'component' 	 , html:''},
		    	{ xtype: 'component' 	 , html:''},
		    	
		    	{ xtype: 'component'	 ,  html:'시내-직행좌석'   	},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'colSum2_4'      			   , width :170 , readOnly:true},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'IN_NONSTOP_GEN'     , width :170 , holdable: 'hold'},
		    	{ xtype: 'component' 	 , html:''},
		    	{ xtype: 'component'	 , html:''},
		    	
		    	{ xtype: 'component'	 ,  html:'시외-완행버스'   	},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'colSum2_5'      			   , width :170 , readOnly:true},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'OUT_SLOW_GEN'       , width :170 , holdable: 'hold'},
		    	{ xtype: 'component' 	 , html:''},
		    	{ xtype: 'component' 	 , html:''},
		    	
		    	{ xtype: 'component'	 ,  html:'시외-직행버스'   	},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'colSum2_6'      			   , width :170 , readOnly:true},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'OUT_NONSTOP_GEN'    , width :170 , holdable: 'hold'},
		    	{ xtype: 'component' 	 , html:''},
		    	{ xtype: 'component' 	 , html:''},
		    	
		    	{ xtype: 'component'	 ,  html:'시외-공항버스'   	},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'colSum2_7'      			   , width :170 , readOnly:true},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'OUT_AIR_GEN'        , width :170 , holdable: 'hold'},
		    	{ xtype: 'component' 	 , html:''},
		    	{ xtype: 'component' 	 , html:''},
		    	
		    	{ xtype: 'component'	 ,  html:'공항-한정면허'   	},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'colSum2_8'      			   , width :170 , readOnly:true},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'AIR_LIMIT_GEN'      , width :170 , holdable: 'hold'},
		    	{ xtype: 'component' 	 , html:''},
		    	{ xtype: 'component' 	 , html:''},
		    	
		    	{ xtype: 'component'	 ,  html:'기타(마을/전세)'  },
		    	{ xtype: 'uniNumberfield', value : '0',  name:'colSum2_9'      			   , width :170 , readOnly:true},
		    	{ xtype: 'uniNumberfield', value : '0',  name:'ETC_VILLEAGE_GEN'   , width :170 , holdable: 'hold'},
		    	{ xtype: 'component' 	 , html:''},
		    	{ xtype: 'component' 	 , html:''}
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
			} 
		    , api: {
         		 load: 'gra100ukrvService.selectList',
         		 submit: 'gra100ukrvService.syncMaster'	
			},
			listeners : {
				uniOnChange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					UniAppManager.setToolbarButtons('save', true);
					this.fnAmtSum();
				}
			},
			fnAmtSum: function() {				
				var colSum1_1 = 0;
				var colSum1_2 = 0;
				var colSum1_3 = 0;
				var colSum1_4 = 0;
				var colSum1_5 = 0;
				var colSum1_6 = 0;
				
				stockNumTot = detailForm.getValue('STOCK_NUM1') + detailForm.getValue('STOCK_NUM2') + detailForm.getValue('STOCK_NUM3') +
							  detailForm.getValue('STOCK_NUM4') + detailForm.getValue('STOCK_NUM_ETC');
				detailForm.setValue('STOCK_NUM_TOT', stockNumTot);
				if(detailForm.getValue('STOCK_NUM1') != 0 ||
				   detailForm.getValue('STOCK_NUM2') != 0 ||
				   detailForm.getValue('STOCK_NUM3') != 0 ||
				   detailForm.getValue('STOCK_NUM4') != 0 ||
				   detailForm.getValue('STOCK_NUM_ETC') != 0
				){
					colSum1_1 = (detailForm.getValue('STOCK_NUM1')) / detailForm.getValue('STOCK_NUM_TOT') * 100;
					colSum1_2 = (detailForm.getValue('STOCK_NUM2')) / detailForm.getValue('STOCK_NUM_TOT') * 100;
					colSum1_3 = (detailForm.getValue('STOCK_NUM3')) / detailForm.getValue('STOCK_NUM_TOT') * 100;
					colSum1_4 = (detailForm.getValue('STOCK_NUM4')) / detailForm.getValue('STOCK_NUM_TOT') * 100;
					colSum1_5 = (detailForm.getValue('STOCK_NUM_ETC')) / detailForm.getValue('STOCK_NUM_TOT') * 100;				
					detailForm.setValue('colSum1_1', Math.floor(colSum1_1 * 100) / 100);
					detailForm.setValue('colSum1_2', Math.floor(colSum1_2 * 100) / 100);
					detailForm.setValue('colSum1_3', Math.floor(colSum1_3 * 100) / 100);
					detailForm.setValue('colSum1_4', Math.floor(colSum1_4 * 100) / 100);
					detailForm.setValue('colSum1_5', Math.floor(colSum1_5 * 100) / 100);
				}else{
					detailForm.setValue('colSum1_1', 0);
					detailForm.setValue('colSum1_2', 0);
					detailForm.setValue('colSum1_3', 0);
					detailForm.setValue('colSum1_4', 0);
					detailForm.setValue('colSum1_5', 0);
				}
				var colSum2_1 = 0;
				var colSum2_2 = 0;
				var colSum2_3 = 0;
				var colSum2_4 = 0;
				var colSum2_5 = 0;
				var colSum2_6 = 0;
				var colSum2_7 = 0;
				var colSum2_8 = 0;
				var colSum2_9 = 0;
				
				colSum2_1 = detailForm.getValue('IN_LARGE_GEN') + detailForm.getValue('IN_LARGE_CTR') + detailForm.getValue('IN_LARGE_PUB');
				colSum2_2 = detailForm.getValue('IN_MEDIUM_GEN') + detailForm.getValue('IN_MEDIUM_CTR') + detailForm.getValue('IN_MEDIUM_PUB');
				colSum2_3 = detailForm.getValue('IN_EXPRESS_GEN');
				colSum2_4 = detailForm.getValue('IN_NONSTOP_GEN');
				colSum2_5 = detailForm.getValue('OUT_SLOW_GEN');
				colSum2_6 = detailForm.getValue('OUT_NONSTOP_GEN');
				colSum2_7 = detailForm.getValue('OUT_AIR_GEN');
				colSum2_8 = detailForm.getValue('AIR_LIMIT_GEN');
				colSum2_9 = detailForm.getValue('ETC_VILLEAGE_GEN');
				detailForm.setValue('colSum2_1', colSum2_1);
				detailForm.setValue('colSum2_2', colSum2_2);
				detailForm.setValue('colSum2_3', colSum2_3);
				detailForm.setValue('colSum2_4', colSum2_4);
				detailForm.setValue('colSum2_5', colSum2_5);
				detailForm.setValue('colSum2_6', colSum2_6);
				detailForm.setValue('colSum2_7', colSum2_7);
				detailForm.setValue('colSum2_8', colSum2_8);
				detailForm.setValue('colSum2_9', colSum2_9);
				
				var lowSum1_1 = 0;
				var lowSum1_2 = 0;
				var lowSum1_3 = 0;
				var lowSum1_4 = 0;				
				lowSum1_1 = parseInt(colSum2_1) + parseInt(colSum2_2) + parseInt(colSum2_3) + parseInt(colSum2_4) + parseInt(colSum2_5) + 
							parseInt(colSum2_6) + parseInt(colSum2_7) + parseInt(colSum2_8) + parseInt(colSum2_9); 
				lowSum1_2 = detailForm.getValue('IN_LARGE_GEN') + detailForm.getValue('IN_MEDIUM_GEN') + detailForm.getValue('IN_EXPRESS_GEN') + 
							detailForm.getValue('IN_NONSTOP_GEN') + detailForm.getValue('OUT_SLOW_GEN') + detailForm.getValue('OUT_NONSTOP_GEN') + 
							detailForm.getValue('OUT_AIR_GEN') + detailForm.getValue('AIR_LIMIT_GEN') + detailForm.getValue('ETC_VILLEAGE_GEN'); 
				lowSum1_3 = detailForm.getValue('IN_LARGE_CTR') + detailForm.getValue('IN_MEDIUM_CTR');
				lowSum1_4 = detailForm.getValue('IN_LARGE_PUB') + detailForm.getValue('IN_MEDIUM_PUB');				
				detailForm.setValue('lowSum1_1', lowSum1_1);
				detailForm.setValue('lowSum1_2', lowSum1_2);
				detailForm.setValue('lowSum1_3', lowSum1_3);
				detailForm.setValue('lowSum1_4', lowSum1_4);
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
		id  : 'gra100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
//			detailForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('COMP_NAME', '');
			detailForm.setValue('COMP_ID', '');
			detailForm.setValue('COMPANY_NUM', '');
			detailForm.setValue('ADDR1', '');
			detailForm.setValue('ADDR2', '');
			detailForm.setValue('ADDR3', '');
			detailForm.setValue('ADDR4', '');
			detailForm.setValue('CAPITAL_AMT', 0);
			detailForm.setValue('STOCKHOLDER_NUM', 0);
			detailForm.setValue('STOCKHOLDER_NAME1', '');
			detailForm.setValue('STOCKHOLDER_NAME2', '');
			detailForm.setValue('STOCKHOLDER_NAME3', '');
			detailForm.setValue('STOCKHOLDER_NAME4', '');
			detailForm.setValue('STOCK_NUM1', 0);
			detailForm.setValue('STOCK_NUM2', 0);
			detailForm.setValue('STOCK_NUM3', 0);
			detailForm.setValue('STOCK_NUM4', 0);
			detailForm.setValue('STOCK_NUM_ETC', 0);
			detailForm.setValue('STOCK_NUM_TOT', '');
			detailForm.setValue('EXECUTIVE_NUM', 0);
			detailForm.setValue('ADMINISTRATIVE_NUM', 0);
			detailForm.setValue('DRIVER_NUM', 0);
			detailForm.setValue('MECHANIC_NUM', 0);
			detailForm.setValue('IN_LARGE_GEN', 0);
			detailForm.setValue('IN_LARGE_CTR', 0);
			detailForm.setValue('IN_LARGE_PUB', 0);
			detailForm.setValue('IN_MEDIUM_GEN', 0);
			detailForm.setValue('IN_MEDIUM_CTR', 0);
			detailForm.setValue('IN_MEDIUM_PUB', 0);
			detailForm.setValue('IN_EXPRESS_GEN', 0);
			detailForm.setValue('IN_NONSTOP_GEN', 0);
			detailForm.setValue('OUT_SLOW_GEN', 0);
			detailForm.setValue('OUT_NONSTOP_GEN', 0);
			detailForm.setValue('OUT_AIR_GEN', 0);
			detailForm.setValue('AIR_LIMIT_GEN', 0);
			detailForm.setValue('ETC_VILLEAGE_GEN', 0);
		},
		
		onQueryButtonDown : function()	{
//			detailForm.setAllFieldsReadOnly(false);
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
						detailForm.fnAmtSum();
						detailForm.setDisabled(false);
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
			detailForm.setDisabled(true);
//			detailForm.setAllFieldsReadOnly(true);
			me.fnInitBinding();
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});// main
}; 

</script>