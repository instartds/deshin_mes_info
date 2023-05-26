<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_grb100ukrv");
%>
<t:appConfig pgmId="grb100ukrv"  >
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
			read: 'grb100ukrvService.selectList',
			update: 'grb100ukrvService.updateDetail',
			create: 'grb100ukrvService.insertDetail',
			destroy: 'grb100ukrvService.deleteDetail',
			syncAll: 'grb100ukrvService.saveAll'
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
		title: '종사분야별 인원',
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
           	setAllFieldsReadOnly: function(b) {	
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
						return !field.validate();
					});				   															
	   				if(invalid.length > 0) {
						r=false;
	   					var labelText = ''
	   	
						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
						//this.mask();
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
								
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							
							}
						})
	   				}
		  		} else {
  					//this.unmask();
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
							
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
							
						}
					})
  				}
				return r;
  		},
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
    			window.open(CPATH+'/busevaluation/excel/grb100out?SERVICE_YEAR='+panelSearch.getValue('SERVICE_YEAR'), "_self");
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
			columns:13,
			tableAttrs: {style: 'border : 1px solid #ced9e7;'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{name: 'COMP_CODE', fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode},
			// 구분1
			{ xtype: 'component',  html:'<b>구  분</b>', 		colspan: 3,		rowspan: 2,		width: 120},
	    	{ xtype: 'component',  html:'<b>계</b>',			colspan: 2, tdAttrs: {height: 28}},
	    	{ xtype: 'component',  html:'<b>일반노선</b>', 	colspan: 2},
	    	{ xtype: 'component',  html:'<b>광역급행</b>', 	colspan: 2},	
	    	{ xtype: 'component',  html:'<b>벽지노선</b>', 	colspan: 2},	
	    	{ xtype: 'component',  html:'<b>공영버스</b>', 	colspan: 2},	
	    	
	    	// 구분2
			{ xtype: 'component',  html:'<b>정규직</b>', tdAttrs: {width: 86, height: 28}},
	    	{ xtype: 'component',  html:'<b>비정규직</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>정규직</b>', tdAttrs: {width: 86}},	
	    	{ xtype: 'component',  html:'<b>비정규직</b>', tdAttrs: {width: 86}},	
	    	{ xtype: 'component',  html:'<b>정규직</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>비정규직</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>정규직</b>', tdAttrs: {width: 86}},
	    	{ xtype: 'component',  html:'<b>비정규직</b>', tdAttrs: {width: 86}},	
	    	{ xtype: 'component',  html:'<b>정규직</b>', tdAttrs: {width: 86}},	
	    	{ xtype: 'component',  html:'<b>비정규직</b>', tdAttrs: {width: 86}},
	    	
	    	// 직접인원
	    	{ xtype: 'component', 		html:'<b>직</b></br><b>접</b></br><b>인</b></br><b>원</b>', 	rowspan: 11,	width: 20},
	    	{ xtype: 'component', 		html:'<b>운<br>전<br>직</b>', 			rowspan: 9,	width: 20},
			{ xtype: 'component', 		html:'시내-일반(대)', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum1_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum1_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_GEN_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_GEN_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_CTR_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_CTR_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_PUB_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_LARGE_PUB_PART',	width: 80, holdable: 'hold'},
			
	    	{ xtype: 'component', 		html:'시내-일반(중)', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum2_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum2_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_GEN_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_GEN_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_CTR_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_CTR_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_PUB_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_MEDIUM_PUB_PART',	width: 80, holdable: 'hold'},
			
			{ xtype: 'component', 		html:'시내-좌석버스', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum3_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum3_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_GEN_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_EXPRESS_GEN_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	
	    	{ xtype: 'component', 		html:'시내-직행좌석', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum4_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum4_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_GEN_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'IN_NONSTOP_GEN_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	
	    	{ xtype: 'component', 		html:'시외-완행버스', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum5_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum5_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_GEN_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_SLOW_GEN_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	
	    	{ xtype: 'component', 		html:'시외-직행버스', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum6_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum6_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_GEN_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_NONSTOP_GEN_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	
	    	{ xtype: 'component', 		html:'시외-공항버스', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum7_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum7_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_GEN_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'OUT_AIR_GEN_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	
	    	{ xtype: 'component', 		html:'공항-한정면허', 	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum8_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum8_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_GEN_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'AIR_LIMIT_GEN_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	
	    	{ xtype: 'component', 		html:'기 타(마을/전세버스 등)',	colspan: 1},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum9_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum9_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_GEN_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ETC_VILLEAGE_GEN_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	
	    	{ xtype: 'component', 		html:'정비직',colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum10_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum10_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'MECHANIC_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	
	    	{ xtype: 'component', 		html:'<b>소 계</b>',	colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum1_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum1_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum1_3',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum1_4',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum1_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum1_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum1_5',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum1_6',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum1_7',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum1_8',	width: 80, readOnly: true },
			
	    	// 간접인원
			{ xtype: 'component', 		html:'<b>간</b></br><b>접</b></br><b>인</b></br><b>원</b>', 	rowspan: 3,		width: 20},
	    	{ xtype: 'component', 		html:'임 원',	colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum1_3',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum1_4',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'EXECUTIVE_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
			
			{ xtype: 'component', 		html:'관리직',	colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum2_3',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'leftSum2_4',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_FULL',	width: 80, holdable: 'hold'},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'ADMINISTRATIVE_PART',	width: 80, holdable: 'hold'},
			{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1,	width: 80},
	    	{ xtype: 'component', 		html:'', 	colspan: 1, width: 80},
	    	
			{ xtype: 'component', 		html:'<b>소 계</b>',	colspan: 2},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum2_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum2_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum2_3',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'rowSum2_4',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum2_1',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum2_2',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum2_3',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum2_4',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum2_5',	width: 80, readOnly: true },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum2_6',	width: 80, readOnly: true },
			
			{ xtype: 'component', 		html:'<b>총 계</b>',	colspan: 3},
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'totalsum1',	width: 80, readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'totalsum2',	width: 80, readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'totalsum3',	width: 80, readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'totalsum4',	width: 80, readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum3_1',			width: 80, readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'blankRowSum3_2',			width: 80, readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'totalsum5',	width: 80, readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'totalsum6',	width: 80, readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'totalsum7',	width: 80, readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'uniNumberfield', 	value:'0', 	name: 'totalsum8',	width: 80, readOnly: true, fieldStyle: 'font-weight:bold' }
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
         		 load: 'grb100ukrvService.selectList',
				 submit: 'grb100ukrvService.syncMaster'				
				}
		, listeners : {
				uniOnChange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					UniAppManager.setToolbarButtons('save', true);
					this.fnAmtSum();
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
		},
		fnAmtSum: function() {
			var form = detailForm.getValues();
			var  leftSum1_1 = 0;     var  leftSum1_2 = 0; 
			var  leftSum2_1 = 0;     var  leftSum2_2 = 0; 
			var  leftSum3_1 = 0;     var  leftSum3_2 = 0; 
			var  leftSum4_1 = 0;     var  leftSum4_2 = 0; 
			var  leftSum5_1 = 0;     var  leftSum5_2 = 0; 
			var  leftSum6_1 = 0;     var  leftSum6_2 = 0; 
			var  leftSum7_1 = 0;     var  leftSum7_2 = 0; 
			var  leftSum8_1 = 0;     var  leftSum8_2 = 0; 
			var  leftSum9_1 = 0;     var  leftSum9_2 = 0; 
			var  leftSum10_1 = 0;    var  leftSum10_2 = 0;
			
			leftSum1_1 = parseInt(form.IN_LARGE_GEN_FULL) + parseInt(form.IN_LARGE_CTR_FULL) + parseInt(form.IN_LARGE_PUB_FULL);
			leftSum1_2 = parseInt(form.IN_LARGE_GEN_PART) + parseInt(form.IN_LARGE_CTR_PART) + parseInt(form.IN_LARGE_PUB_PART);
			leftSum2_1 = parseInt(form.IN_MEDIUM_GEN_FULL) + parseInt(form.IN_MEDIUM_CTR_FULL) + parseInt(form.IN_MEDIUM_PUB_FULL);
			leftSum2_2 = parseInt(form.IN_MEDIUM_GEN_PART) + parseInt(form.IN_MEDIUM_CTR_PART) + parseInt(form.IN_MEDIUM_PUB_PART);
			detailForm.setValue('leftSum1_1', leftSum1_1);
			detailForm.setValue('leftSum1_2', leftSum1_2);
			detailForm.setValue('leftSum2_1', leftSum2_1);
			detailForm.setValue('leftSum2_2', leftSum2_2);
			
			leftSum3_1 = parseInt(form.IN_EXPRESS_GEN_FULL);
			leftSum3_2 = parseInt(form.IN_EXPRESS_GEN_PART);
			leftSum4_1 = parseInt(form.IN_NONSTOP_GEN_FULL);
			leftSum4_2 = parseInt(form.IN_NONSTOP_GEN_PART);
			leftSum5_1 = parseInt(form.OUT_SLOW_GEN_FULL);
			leftSum5_2 = parseInt(form.OUT_SLOW_GEN_PART);
			leftSum6_1 = parseInt(form.OUT_NONSTOP_GEN_FULL);
			leftSum6_2 = parseInt(form.OUT_NONSTOP_GEN_PART);
			leftSum7_1 = parseInt(form.OUT_AIR_GEN_FULL);
			leftSum7_2 = parseInt(form.OUT_AIR_GEN_PART);
			leftSum8_1 = parseInt(form.AIR_LIMIT_GEN_FULL);
			leftSum8_2 = parseInt(form.AIR_LIMIT_GEN_PART);
			leftSum9_1 = parseInt(form.ETC_VILLEAGE_GEN_FULL);
			leftSum9_2 = parseInt(form.ETC_VILLEAGE_GEN_PART);
			leftSum10_1 = parseInt(form.MECHANIC_FULL);
			leftSum10_2 = parseInt(form.MECHANIC_PART);			
			detailForm.setValue('leftSum3_1', leftSum3_1);
			detailForm.setValue('leftSum3_2', leftSum3_2);
			detailForm.setValue('leftSum4_1', leftSum4_1);
			detailForm.setValue('leftSum4_2', leftSum4_2);
			detailForm.setValue('leftSum5_1', leftSum5_1);
			detailForm.setValue('leftSum5_2', leftSum5_2);
			detailForm.setValue('leftSum6_1', leftSum6_1);
			detailForm.setValue('leftSum6_2', leftSum6_2);
			detailForm.setValue('leftSum7_1', leftSum7_1);
			detailForm.setValue('leftSum7_2', leftSum7_2);
			detailForm.setValue('leftSum8_1', leftSum8_1);
			detailForm.setValue('leftSum8_2', leftSum8_2);
			detailForm.setValue('leftSum9_1', leftSum9_1);
			detailForm.setValue('leftSum9_2', leftSum9_2);
			detailForm.setValue('leftSum10_1', leftSum10_1);
			detailForm.setValue('leftSum10_2', leftSum10_2);
			
			
			
						
			var rowSum1_1 = 0; var rowSum1_2 = 0; var rowSum1_3 = 0; var rowSum1_4 = 0; var rowSum1_5 = 0; var rowSum1_6 = 0; var rowSum1_7 = 0; var rowSum1_8 = 0;
			rowSum1_1 = parseInt(leftSum1_1) +
						parseInt(leftSum2_1) +
						parseInt(leftSum3_1) +
						parseInt(leftSum4_1) +
						parseInt(leftSum5_1) +
						parseInt(leftSum6_1) +
						parseInt(leftSum7_1) +
						parseInt(leftSum8_1) +
						parseInt(leftSum9_1) +
						parseInt(leftSum10_1);
			
			rowSum1_2 = parseInt(leftSum1_2) +
						parseInt(leftSum2_2) +
						parseInt(leftSum3_2) +
						parseInt(leftSum4_2) +
						parseInt(leftSum5_2) +
						parseInt(leftSum6_2) +
						parseInt(leftSum7_2) +
						parseInt(leftSum8_2) +
						parseInt(leftSum9_2) +
						parseInt(leftSum10_2);	
			
			rowSum1_3 = parseInt(form.IN_LARGE_GEN_FULL) + 
			            parseInt(form.IN_MEDIUM_GEN_FULL) + 
			            parseInt(form.IN_EXPRESS_GEN_FULL) + 
			            parseInt(form.IN_NONSTOP_GEN_FULL) + 
			            parseInt(form.OUT_SLOW_GEN_FULL) + 
			            parseInt(form.OUT_NONSTOP_GEN_FULL) + 
			            parseInt(form.OUT_AIR_GEN_FULL) + 
			            parseInt(form.AIR_LIMIT_GEN_FULL) + 
			            parseInt(form.ETC_VILLEAGE_GEN_FULL) + 
			            parseInt(form.MECHANIC_FULL);
			            
			rowSum1_4 = parseInt(form.IN_LARGE_GEN_PART) + 
			            parseInt(form.IN_MEDIUM_GEN_PART) + 
			            parseInt(form.IN_EXPRESS_GEN_PART) + 
			            parseInt(form.IN_NONSTOP_GEN_PART) + 
			            parseInt(form.OUT_SLOW_GEN_PART) + 
			            parseInt(form.OUT_NONSTOP_GEN_PART) + 
			            parseInt(form.OUT_AIR_GEN_PART) + 
			            parseInt(form.AIR_LIMIT_GEN_PART) + 
			            parseInt(form.ETC_VILLEAGE_GEN_PART) + 
			            parseInt(form.MECHANIC_PART);			            
			
			rowSum1_5 = parseInt(form.IN_LARGE_CTR_FULL) + 
			            parseInt(form.IN_MEDIUM_CTR_FULL);

			rowSum1_6 = parseInt(form.IN_LARGE_CTR_PART) + 
			            parseInt(form.IN_MEDIUM_CTR_PART);

			rowSum1_7 = parseInt(form.IN_LARGE_PUB_FULL) + 
			            parseInt(form.IN_MEDIUM_PUB_FULL);

			rowSum1_8 = parseInt(form.IN_LARGE_PUB_PART) + 
			            parseInt(form.IN_MEDIUM_PUB_PART);			            
			detailForm.setValue('rowSum1_1', rowSum1_1);
			detailForm.setValue('rowSum1_2', rowSum1_2);
			detailForm.setValue('rowSum1_3', rowSum1_3);
			detailForm.setValue('rowSum1_4', rowSum1_4);
			detailForm.setValue('blankRowSum1_1', 0);
			detailForm.setValue('blankRowSum1_2', 0);
			detailForm.setValue('rowSum1_5', rowSum1_5);
			detailForm.setValue('rowSum1_6', rowSum1_6);
			detailForm.setValue('rowSum1_7', rowSum1_7);
			detailForm.setValue('rowSum1_8', rowSum1_8);
			
			var leftSum1_3 = 0;		var leftSum1_4 = 0;
			var leftSum2_3 = 0;		var leftSum2_4 = 0;
			
			leftSum1_3 = parseInt(form.EXECUTIVE_FULL);
			leftSum2_3 = parseInt(form.ADMINISTRATIVE_FULL);
			leftSum1_4 = parseInt(form.EXECUTIVE_PART);			            
			leftSum2_4 = parseInt(form.ADMINISTRATIVE_PART); 
			detailForm.setValue('leftSum1_3', leftSum1_3);
			detailForm.setValue('leftSum2_3', leftSum2_3);
			detailForm.setValue('leftSum1_4', leftSum1_4);
			detailForm.setValue('leftSum2_4', leftSum2_4);			
			
			var rowSum2_1 = 0; var rowSum2_2 = 0; var rowSum2_3 = 0; var rowSum2_4 = 0;
			
			rowSum2_1 = leftSum1_3 + leftSum2_3;
			rowSum2_2 = leftSum1_4 + leftSum2_4;
			rowSum2_3 = rowSum2_1;
			rowSum2_4 = rowSum2_2;
			detailForm.setValue('rowSum2_1', rowSum2_1);
			detailForm.setValue('rowSum2_2', rowSum2_2);
			detailForm.setValue('rowSum2_3', rowSum2_3);
			detailForm.setValue('rowSum2_4', rowSum2_4);
			detailForm.setValue('blankRowSum2_1', 0);
			detailForm.setValue('blankRowSum2_2', 0);
			detailForm.setValue('blankRowSum2_3', 0);
			detailForm.setValue('blankRowSum2_4', 0);
			detailForm.setValue('blankRowSum2_5', 0);
			detailForm.setValue('blankRowSum2_6', 0);
			
			
			var totalsum1 = 0; var totalsum2 = 0; var totalsum3 = 0; var totalsum4 = 0; var totalsum5 = 0; var totalsum6 = 0;var totalsum7 = 0; var totalsum8 = 0;
			totalsum1 = rowSum1_1 + rowSum2_1;
			totalsum2 = rowSum1_2 + rowSum2_2;
			totalsum3 = rowSum1_3 + rowSum2_3;
			totalsum4 = rowSum1_4 + rowSum2_4;
			totalsum5 = rowSum1_5;
			totalsum6 = rowSum1_6;
			totalsum7 = rowSum1_7;
			totalsum8 = rowSum1_8;
			detailForm.setValue('totalsum1', totalsum1);
			detailForm.setValue('totalsum2', totalsum2);
			detailForm.setValue('totalsum3', totalsum3);
			detailForm.setValue('totalsum4', totalsum4);
			detailForm.setValue('blankRowSum3_1', 0);
			detailForm.setValue('blankRowSum3_2', 0);
			detailForm.setValue('totalsum5', totalsum5);
			detailForm.setValue('totalsum6', totalsum6);
			detailForm.setValue('totalsum7', totalsum7);
			detailForm.setValue('totalsum8', totalsum8);
			
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
		id  : 'grb100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			detailForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('SERVICE_YEAR'          , 0);
          	detailForm.setValue('IN_LARGE_GEN_FULL'     , 0);
          	detailForm.setValue('IN_LARGE_GEN_PART'     , 0);
          	detailForm.setValue('IN_LARGE_CTR_FULL'     , 0);
          	detailForm.setValue('IN_LARGE_CTR_PART'     , 0);
          	detailForm.setValue('IN_LARGE_PUB_FULL'     , 0);
          	detailForm.setValue('IN_LARGE_PUB_PART'     , 0);
          	detailForm.setValue('IN_MEDIUM_GEN_FULL'    , 0);
          	detailForm.setValue('IN_MEDIUM_GEN_PART'    , 0);
          	detailForm.setValue('IN_MEDIUM_CTR_FULL'    , 0);
          	detailForm.setValue('IN_MEDIUM_CTR_PART'    , 0);
          	detailForm.setValue('IN_MEDIUM_PUB_FULL'    , 0);
          	detailForm.setValue('IN_MEDIUM_PUB_PART'    , 0);
          	detailForm.setValue('IN_EXPRESS_GEN_FULL'   , 0);
          	detailForm.setValue('IN_EXPRESS_GEN_PART'   , 0);
          	detailForm.setValue('IN_NONSTOP_GEN_FULL'   , 0);
          	detailForm.setValue('IN_NONSTOP_GEN_PART'   , 0);
          	detailForm.setValue('OUT_SLOW_GEN_FULL'     , 0);
          	detailForm.setValue('OUT_SLOW_GEN_PART'     , 0);
          	detailForm.setValue('OUT_NONSTOP_GEN_FULL'  , 0);
          	detailForm.setValue('OUT_NONSTOP_GEN_PART'  , 0);
          	detailForm.setValue('OUT_AIR_GEN_FULL'      , 0);
          	detailForm.setValue('OUT_AIR_GEN_PART'      , 0);
          	detailForm.setValue('AIR_LIMIT_GEN_FULL'    , 0);
          	detailForm.setValue('AIR_LIMIT_GEN_PART'    , 0);
          	detailForm.setValue('ETC_VILLEAGE_GEN_FULL' , 0);
          	detailForm.setValue('ETC_VILLEAGE_GEN_PART' , 0);
          	detailForm.setValue('EXECUTIVE_FULL'        , 0);
          	detailForm.setValue('EXECUTIVE_PART'        , 0);
          	detailForm.setValue('ADMINISTRATIVE_FULL'   , 0);
          	detailForm.setValue('ADMINISTRATIVE_PART'   , 0);
          	detailForm.setValue('MECHANIC_FULL'         , 0);
          	detailForm.setValue('MECHANIC_PART'         , 0);
			
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
						detailForm.fnAmtSum();
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