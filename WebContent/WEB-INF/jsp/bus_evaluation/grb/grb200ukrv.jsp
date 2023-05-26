<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_grb200ukrv");
%>
<t:appConfig pgmId="grb200ukrv"  >
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
			read: 'grb200ukrvService.selectList2',
			update: 'grb200ukrvService.updateDetail',
			create: 'grb200ukrvService.insertDetail',
			destroy: 'grb200ukrvService.deleteDetail',
			syncAll: 'grb200ukrvService.saveAll'
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
            proxy: directProxy,
            loadStoreRecords: function() {
				var param= panelSearch.getValues();			
				console.log(param);
				this.load({
					params : param
				});
			},
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '종사분야별 근속년수별 인원',
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
			}],
  		setLoadRecord: function(record)	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
    var detailForm = Unilite.createSearchForm('detailForm',{	
    	region: 'center',
		autoScroll: true,
		border: 1,
		padding: '-10 -10 -10 -10',
        tbar: [{
        	xtype: 'uniBaseButton',
    		iconCls: 'icon-excel',
    		width: 26, height: 26,
    		tooltip: '엑셀 다운로드',
    		handler: function() {
    			window.open(CPATH+'/busevaluation/excel/grb200out?SERVICE_YEAR='+panelSearch.getValue('SERVICE_YEAR'), "_self");
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
		layout: {
			type: 'uniTable',
			columns:16,
			tableAttrs: {style: 'border : 1px solid #ced9e7;'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{name: 'COMP_CODE', fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode},
			// 구분/근속년수
			{ xtype: 'component',  html:'<b>구  분/근속년수</b>', 	colspan: 3,		width: 200, tdAttrs: {height: 28}},
	    	{ xtype: 'component',  html:'<b>계</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>1년미만</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>1년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>2년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>3년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>4년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>5년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>6년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>7년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>8년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>9년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>10년이상</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>비고</b>', tdAttrs: {width: 100}},
	    	
	    	// 직접인원
	    	{ xtype: 'component', 		html:'<b>직</b></br><b>접</b></br><b>인</b></br><b>원</b>', 	rowspan: 11,	width: 20},
	    	{ xtype: 'component', 		html:'<b>운<br>전<br>직</b>', 			rowspan: 9,	width: 20},
			{ xtype: 'component', 		html:'시내-일반(대)', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
			
	    	{ xtype: 'component', 		html:'시내-일반(중)', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
			
			{ xtype: 'component', 		html:'시내-좌석버스', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
	    	
	    	{ xtype: 'component', 		html:'시내-직행좌석', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
	    	
	    	{ xtype: 'component', 		html:'시외-완행버스', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
	    	
	    	{ xtype: 'component', 		html:'시외-직행버스', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
	    	
	    	{ xtype: 'component', 		html:'시외-공항버스', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
	    	
	    	{ xtype: 'component', 		html:'공항-한정면허', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
	    	
	    	{ xtype: 'component', 		html:'기 타(마을/전세버스 등)',	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
	    	
	    	{ xtype: 'component', 		html:'정비직',	colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 						width: 80},
	    	
	    	{ xtype: 'component', 		html:'<b>소 계</b>',		colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'component', 		html:'', 	width: 80},
			
	    	// 간접인원
			{ xtype: 'component', 		html:'<b>간</b></br><b>접</b></br><b>인</b></br><b>원</b>', 	rowspan: 3,		width: 20},
	    	{ xtype: 'component', 		html:'임 원',		colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
			
			{ xtype: 'component', 		html:'관리직',	colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_00',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_01',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_02',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_03',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_04',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_05',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_06',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_07',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_08',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_09',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_10',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	width: 80},
	    	
			{ xtype: 'component', 		html:'<b>소 계</b>',		colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'component', 		html:'', 	width: 80},
			
			{ xtype: 'component', 		html:'<b>총 계</b>',	colspan: 3},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: '',	width: 80, readOnly: true},
			{ xtype: 'component', 		html:'', 	width: 80}
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
         		 load: 'grb200ukrvService.selectList',
				 submit: 'grb200ukrvService.syncMaster'				
				}
		, listeners : {
				uniOnChange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					UniAppManager.setToolbarButtons('save', true);
				},
				beforeaction:function(basicForm, action, eOpts)	{
					console.log("action : ",action);
					console.log("action.type : ",action.type);
					if(action.type =='directsubmit')	{
						var invalid = this.getForm().getFields().filterBy(function(field) {
						            return !field.validate();
						    });
				        if(invalid.length > 0)	{
				        	r=false;
				        	var labelText = ''
				        	
				        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
				        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
				        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				        	}
				        	alert(labelText+Msg.sMB083);
				        	invalid.items[0].focus();
				        }																									
					}
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
		id  : 'grb200ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			detailForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('IN_LARGE_00'      , 0);
          	detailForm.setValue('IN_LARGE_01'      , 0);
          	detailForm.setValue('IN_LARGE_02'      , 0);
          	detailForm.setValue('IN_LARGE_03'      , 0);
          	detailForm.setValue('IN_LARGE_04'      , 0);
          	detailForm.setValue('IN_LARGE_05'      , 0);
          	detailForm.setValue('IN_LARGE_06'      , 0);
          	detailForm.setValue('IN_LARGE_07'      , 0);
          	detailForm.setValue('IN_LARGE_08'      , 0);
          	detailForm.setValue('IN_LARGE_09'      , 0);
          	detailForm.setValue('IN_LARGE_10'      , 0);
          	detailForm.setValue('IN_MEDIUM_00'     , 0);
          	detailForm.setValue('IN_MEDIUM_01'     , 0);
          	detailForm.setValue('IN_MEDIUM_02'     , 0);
          	detailForm.setValue('IN_MEDIUM_03'     , 0);
          	detailForm.setValue('IN_MEDIUM_04'     , 0);
          	detailForm.setValue('IN_MEDIUM_05'     , 0);
          	detailForm.setValue('IN_MEDIUM_06'     , 0);
          	detailForm.setValue('IN_MEDIUM_07'     , 0);
          	detailForm.setValue('IN_MEDIUM_08'     , 0);
          	detailForm.setValue('IN_MEDIUM_09'     , 0);
          	detailForm.setValue('IN_MEDIUM_10'     , 0);
          	detailForm.setValue('IN_EXPRESS_00'    , 0);
          	detailForm.setValue('IN_EXPRESS_01'    , 0);
          	detailForm.setValue('IN_EXPRESS_02'    , 0);
          	detailForm.setValue('IN_EXPRESS_03'    , 0);
          	detailForm.setValue('IN_EXPRESS_04'    , 0);
          	detailForm.setValue('IN_EXPRESS_05'    , 0);
          	detailForm.setValue('IN_EXPRESS_06'    , 0);
          	detailForm.setValue('IN_EXPRESS_07'    , 0);
          	detailForm.setValue('IN_EXPRESS_08'    , 0);
          	detailForm.setValue('IN_EXPRESS_09'    , 0);
          	detailForm.setValue('IN_EXPRESS_10'    , 0);
          	detailForm.setValue('IN_NONSTOP_00'    , 0);
          	detailForm.setValue('IN_NONSTOP_01'    , 0);
          	detailForm.setValue('IN_NONSTOP_02'    , 0);
          	detailForm.setValue('IN_NONSTOP_03'    , 0);
          	detailForm.setValue('IN_NONSTOP_04'    , 0);
          	detailForm.setValue('IN_NONSTOP_05'    , 0);
          	detailForm.setValue('IN_NONSTOP_06'    , 0);
          	detailForm.setValue('IN_NONSTOP_07'    , 0);
          	detailForm.setValue('IN_NONSTOP_08'    , 0);
          	detailForm.setValue('IN_NONSTOP_09'    , 0);
          	detailForm.setValue('IN_NONSTOP_10'    , 0);
          	detailForm.setValue('OUT_SLOW_00'      , 0);
          	detailForm.setValue('OUT_SLOW_01'      , 0);
          	detailForm.setValue('OUT_SLOW_02'      , 0);
          	detailForm.setValue('OUT_SLOW_03'      , 0);
          	detailForm.setValue('OUT_SLOW_04'      , 0);
          	detailForm.setValue('OUT_SLOW_05'      , 0);
          	detailForm.setValue('OUT_SLOW_06'      , 0);
          	detailForm.setValue('OUT_SLOW_07'      , 0);
          	detailForm.setValue('OUT_SLOW_08'      , 0);
          	detailForm.setValue('OUT_SLOW_09'      , 0);
          	detailForm.setValue('OUT_SLOW_10'      , 0);
          	detailForm.setValue('OUT_NONSTOP_00'   , 0);
          	detailForm.setValue('OUT_NONSTOP_01'   , 0);
          	detailForm.setValue('OUT_NONSTOP_02'   , 0);
          	detailForm.setValue('OUT_NONSTOP_03'   , 0);
          	detailForm.setValue('OUT_NONSTOP_04'   , 0);
          	detailForm.setValue('OUT_NONSTOP_05'   , 0);
          	detailForm.setValue('OUT_NONSTOP_06'   , 0);
          	detailForm.setValue('OUT_NONSTOP_07'   , 0);
          	detailForm.setValue('OUT_NONSTOP_08'   , 0);
          	detailForm.setValue('OUT_NONSTOP_09'   , 0);
          	detailForm.setValue('OUT_NONSTOP_10'   , 0);
          	detailForm.setValue('OUT_AIR_00'       , 0);
          	detailForm.setValue('OUT_AIR_01'       , 0);
          	detailForm.setValue('OUT_AIR_02'       , 0);
          	detailForm.setValue('OUT_AIR_03'       , 0);
          	detailForm.setValue('OUT_AIR_04'       , 0);
          	detailForm.setValue('OUT_AIR_05'       , 0);
          	detailForm.setValue('OUT_AIR_06'       , 0);
          	detailForm.setValue('OUT_AIR_07'       , 0);
          	detailForm.setValue('OUT_AIR_08'       , 0);
          	detailForm.setValue('OUT_AIR_09'       , 0);
          	detailForm.setValue('OUT_AIR_10'       , 0);
          	detailForm.setValue('AIR_LIMIT_00'     , 0);
          	detailForm.setValue('AIR_LIMIT_01'     , 0);
          	detailForm.setValue('AIR_LIMIT_02'     , 0);
          	detailForm.setValue('AIR_LIMIT_03'     , 0);
          	detailForm.setValue('AIR_LIMIT_04'     , 0);
          	detailForm.setValue('AIR_LIMIT_05'     , 0);
          	detailForm.setValue('AIR_LIMIT_06'     , 0);
          	detailForm.setValue('AIR_LIMIT_07'     , 0);
          	detailForm.setValue('AIR_LIMIT_08'     , 0);
          	detailForm.setValue('AIR_LIMIT_09'     , 0);
          	detailForm.setValue('AIR_LIMIT_10'     , 0);
          	detailForm.setValue('ETC_VILLEAGE_00'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_01'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_02'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_03'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_04'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_05'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_06'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_07'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_08'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_09'  , 0);
          	detailForm.setValue('ETC_VILLEAGE_10'  , 0);
          	detailForm.setValue('MECHANIC_00'      , 0);
          	detailForm.setValue('MECHANIC_01'      , 0);
          	detailForm.setValue('MECHANIC_02'      , 0);
          	detailForm.setValue('MECHANIC_03'      , 0);
          	detailForm.setValue('MECHANIC_04'      , 0);
          	detailForm.setValue('MECHANIC_05'      , 0);
          	detailForm.setValue('MECHANIC_06'      , 0);
          	detailForm.setValue('MECHANIC_07'      , 0);
          	detailForm.setValue('MECHANIC_08'      , 0);
          	detailForm.setValue('MECHANIC_09'      , 0);
          	detailForm.setValue('MECHANIC_10'      , 0);
          	detailForm.setValue('EXECUTIVE_00'     , 0);
          	detailForm.setValue('EXECUTIVE_01'     , 0);
          	detailForm.setValue('EXECUTIVE_02'     , 0);
          	detailForm.setValue('EXECUTIVE_03'     , 0);
          	detailForm.setValue('EXECUTIVE_04'     , 0);
          	detailForm.setValue('EXECUTIVE_05'     , 0);
          	detailForm.setValue('EXECUTIVE_06'     , 0);
          	detailForm.setValue('EXECUTIVE_07'     , 0);
          	detailForm.setValue('EXECUTIVE_08'     , 0);
          	detailForm.setValue('EXECUTIVE_09'     , 0);
          	detailForm.setValue('EXECUTIVE_10'     , 0);
          	detailForm.setValue('ADMINISTRATIVE_00', 0);
          	detailForm.setValue('ADMINISTRATIVE_01', 0);
          	detailForm.setValue('ADMINISTRATIVE_02', 0);
          	detailForm.setValue('ADMINISTRATIVE_03', 0);
          	detailForm.setValue('ADMINISTRATIVE_04', 0);
          	detailForm.setValue('ADMINISTRATIVE_05', 0);
          	detailForm.setValue('ADMINISTRATIVE_06', 0);
          	detailForm.setValue('ADMINISTRATIVE_07', 0);
          	detailForm.setValue('ADMINISTRATIVE_08', 0);
          	detailForm.setValue('ADMINISTRATIVE_09', 0);
          	detailForm.setValue('ADMINISTRATIVE_10', 0);
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