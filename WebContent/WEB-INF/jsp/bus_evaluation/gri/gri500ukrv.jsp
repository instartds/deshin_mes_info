<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_gri500ukrv");
%>
<t:appConfig pgmId="gri500ukrv"  >	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gri500ukrvService.selectDetailList',
			update: 'gri500ukrvService.updateDetail',
			create: 'gri500ukrvService.insertDetail',
			destroy: 'gri500ukrvService.deleteDetail',
			syncAll: 'gri500ukrvService.saveAll'
		}
	});	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '정부보조금',
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
	var detailForm = Unilite.createSearchForm('search1',{
		region: 'center',
		autoScroll: true,
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
			columns:13,
			tableAttrs: {style: 'border : 1px solid #ced9e7;'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{name: 'COMP_CODE', fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode},
			{ xtype: 'component', html:'<b>구분</b>', colspan: 2, rowspan:4},
			{ xtype: 'component', html:'<b>조사지계정(회계처리기준)</b>', rowspan:4, width: 170},
			{ xtype: 'component', html:'<b>장부상 계정</b>', colspan:10},
							
			{ xtype: 'component', html:'<b>시내버스(일반/좌석/직좌)</b>', colspan:5},
			{ xtype: 'component', html:'<b>시외(완행/직행/공황)</b>', colspan:5},
			
			{ xtype: 'component', html:'<b>금액(원)</b>', rowspan:2, tdAttrs: {width: 86}},
			{ xtype: 'component', html:'<b>수입계정</b>', colspan:2},				
			{ xtype: 'component', html:'<b>지출계정</b>', colspan:2},				
			{ xtype: 'component', html:'<b>금액(원)</b>', rowspan:2, tdAttrs: {width: 86}},
			{ xtype: 'component', html:'<b>수입계정</b>', colspan:2},				
			{ xtype: 'component', html:'<b>지출계정</b>', colspan:2},	
			
			{ xtype: 'component', html:'<b>목</b>', tdAttrs: {width: 86}},
			{ xtype: 'component', html:'<b>세목</b>', tdAttrs: {width: 86}},
			{ xtype: 'component', html:'<b>목</b>', tdAttrs: {width: 86}},
			{ xtype: 'component', html:'<b>세목</b>', tdAttrs: {width: 86}},
			{ xtype: 'component', html:'<b>목</b>', tdAttrs: {width: 86}},
			{ xtype: 'component', html:'<b>세목</b>', tdAttrs: {width: 86}},
			{ xtype: 'component', html:'<b>목</b>', tdAttrs: {width: 86}},
			{ xtype: 'component', html:'<b>세목</b>', tdAttrs: {width: 86}},
			
			{ xtype: 'component', html:'<b>계</b>', colspan:2},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: '' , width: 80, readOnly: true },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: '' , width: 80, readOnly: true},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'버스재정</br>지원금', rowspan:7, width: 85},
			{ xtype: 'component', html:'<b>소계</b>', width: 190},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: '' , width: 80, readOnly: true },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: '' , width: 80, readOnly: true },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'운영개선지원금'},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_O1_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O1_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O1_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''}, 
			{ xtype: 'uniNumberfield',   name: 'C_O1_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O1_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O1_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'인센티브'},
			{ xtype: 'component', html:'정부보조금(성과)'},
			{ xtype: 'uniNumberfield',   name: 'C_O2_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O2_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O2_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'버스차량고급화사업'},
			{ xtype: 'component', html:'미기재(비용상계)'},
			{ xtype: 'uniNumberfield',   name: 'C_O3_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O3_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O3_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O3_04' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O3_05' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'차량시설개선사업'},
			{ xtype: 'component', html:'미기재(비용상계)'},
			{ xtype: 'uniNumberfield',   name: 'C_O4_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O4_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O4_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O4_04' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O4_05' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'청소년할인결손보전'},
			{ xtype: 'component', html:'', height: 25},
			{ xtype: 'component', html:'도기타특별보조사업 항목으로 통합 작성', colspan:10},
			
			{ xtype: 'component', html:'벽지노선손실지원'},
			{ xtype: 'component', html:'', height: 25},
			{ xtype: 'component', html:'오지 도서 교통지원 항목으로 통합 작성', colspan:10},
			
			{ xtype: 'component', html:'오지도서</br>교통지원사업', rowspan:2},
			{ xtype: 'component', html:'벽지노선손실보상'},
			{ xtype: 'component', html:'정부보조금보전'},
			{ xtype: 'uniNumberfield',   name: 'C_O7_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O7_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O7_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
							
			{ xtype: 'component', html:'공영버스구입지원'},
			{ xtype: 'component', html:'미기재(자산 차감)'},
			{ xtype: 'uniNumberfield',   name: 'C_O8_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O8_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O8_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O8_04' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O8_05' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'농어촌공영버스운영결손금지원사업', colspan:2},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_O9_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O9_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_O9_03' , holdable: 'hold', value: 0, width: 80 },				
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'도기타</br>특별보조사업', rowspan:4},
			{ xtype: 'component', html:'<b>소계</b>'},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: '' , width: 80, readOnly: true },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: '' , width: 80, readOnly: true },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'수도권환승할인제 손실보전'},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_1O_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_1O_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_1O_03' , holdable: 'hold', value: 0, width: 80 },				
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'심야버스 결손보전'},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_11_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_11_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_11_03' , holdable: 'hold', value: 0, width: 80 },				
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'청소년할인 결손보전'},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_12_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_12_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_12_03' , holdable: 'hold', value: 0, width: 80 },				
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: 'C_12_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_12_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_12_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'시기타</br>특별보조사업', rowspan:4},
			{ xtype: 'component', html:'일반노선손실지원'},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_13_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_13_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_13_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: 'C_13_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_13_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_13_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'벽지노선손실지원'},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_14_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_14_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_14_03' , holdable: 'hold', value: 0, width: 80 },				
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'공영버스손실지원'},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_15_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_15_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_15_03' , holdable: 'hold', value: 0, width: 80 },				
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'기타'},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_16_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_16_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_16_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: 'C_16_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_16_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_16_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'천연가스버스</br>보급사업', rowspan:3},
			{ xtype: 'component', html:'천연가스버스구입보조'},
			{ xtype: 'component', html:'미기재(자산차감)'},
			{ xtype: 'uniNumberfield',   name: 'C_17_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_17_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_17_03' , holdable: 'hold', value: 0, width: 80 },				
			{ xtype: 'uniNumberfield',   name: 'C_17_04' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_17_05' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_17_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_17_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_17_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_17_09' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_17_10' , holdable: 'hold', value: 0, width: 80 },
							
			{ xtype: 'component', html:'천연가스 연료비(이동충전)보조'},
			{ xtype: 'component', html:'미기재(비용상계)'},
			{ xtype: 'uniNumberfield',   name: 'C_18_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_18_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_18_03' , holdable: 'hold', value: 0, width: 80 },				
			{ xtype: 'uniNumberfield',   name: 'C_18_04' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_18_05' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_18_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_18_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_18_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_18_09' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_18_10' , holdable: 'hold', value: 0, width: 80 },
			
			{ xtype: 'component', html:'천연가스버스 공차운행 연료비 보조'},
			{ xtype: 'component', html:'미기재(비용상계)'},
			{ xtype: 'uniNumberfield',   name: 'C_19_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_19_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_19_03' , holdable: 'hold', value: 0, width: 80 },				
			{ xtype: 'uniNumberfield',   name: 'C_19_04' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_19_05' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_19_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_19_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_19_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_19_09' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_19_10' , holdable: 'hold', value: 0, width: 80 },
			
			{ xtype: 'component', html:'저상버스보급사업(국토해양부)', colspan: 2},
			{ xtype: 'component', html:'미기재(자산차감)'},
			{ xtype: 'uniNumberfield',   name: 'C_20_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_20_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_20_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_20_04' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_20_05' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},				
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'유류(경유)보조금(울산광역시)', colspan: 2},
			{ xtype: 'component', html:'미기재(비용차감)'},
			{ xtype: 'uniNumberfield',   name: 'C_21_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_21_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_21_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_21_04' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_21_05' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_21_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_21_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_21_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_21_09' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_21_10' , holdable: 'hold', value: 0, width: 80 },
			
			{ xtype: 'component', html:'광역급행버스 수도권 환승할인제 손실보전', colspan: 2},
			{ xtype: 'component', html:'미기재(자산차감)'},
			{ xtype: 'uniNumberfield',   name: 'C_22_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_22_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_22_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},	
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},				
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'국가유공자할인 손실지원(보훈처)', colspan: 2},
			{ xtype: 'component', html:'정부보조금(보전)'},
			{ xtype: 'uniNumberfield',   name: 'C_23_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_23_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_23_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: 'C_23_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_23_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_23_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'천연가스버스</br>보급사업', rowspan:5},
			{ xtype: 'component', html:'장애인고용'},
			{ xtype: 'component', html:'정부보조금(성과)'},
			{ xtype: 'uniNumberfield',   name: 'C_24_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_24_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_24_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: 'C_24_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_24_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_24_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'고령자고용'},
			{ xtype: 'component', html:'정부보조금(성과)'},
			{ xtype: 'uniNumberfield',   name: 'C_25_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_25_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_25_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: 'C_25_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_25_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_25_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'대폐차지원'},
			{ xtype: 'component', html:'정부보조금(성과)'},
			{ xtype: 'uniNumberfield',   name: 'C_26_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_26_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_26_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: 'C_26_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_26_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_26_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'타기관보조금'},
			{ xtype: 'component', html:'정부보조금(성과)'},
			{ xtype: 'uniNumberfield',   name: 'C_27_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_27_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_27_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: 'C_27_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_27_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_27_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			
			{ xtype: 'component', html:'기타'},
			{ xtype: 'component', html:'정부보조금(성과)'},
			{ xtype: 'uniNumberfield',   name: 'C_28_01' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_28_02' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_28_03' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''},
			{ xtype: 'uniNumberfield',   name: 'C_28_06' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_28_07' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'uniNumberfield',   name: 'C_28_08' , holdable: 'hold', value: 0, width: 80 },
			{ xtype: 'component', html:''},
			{ xtype: 'component', html:''
		}],
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
			load: 'gri500ukrvService.selectMaster',
			submit: 'gri500ukrvService.syncMaster'				
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
		id  : 'gri500ukrvApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			detailForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('C_O1_01', 0);
			detailForm.setValue('C_O1_02', 0);
			detailForm.setValue('C_O1_03', 0);
			detailForm.setValue('C_O1_06', 0);
			detailForm.setValue('C_O1_07', 0);
			detailForm.setValue('C_O1_08', 0);
			detailForm.setValue('C_O2_01', 0);
			detailForm.setValue('C_O2_02', 0);
			detailForm.setValue('C_O2_03', 0);
			detailForm.setValue('C_O3_01', 0);
			detailForm.setValue('C_O3_02', 0);
			detailForm.setValue('C_O3_03', 0);
			detailForm.setValue('C_O3_04', 0);
			detailForm.setValue('C_O3_05', 0);
			detailForm.setValue('C_O4_01', 0);
			detailForm.setValue('C_O4_02', 0);
			detailForm.setValue('C_O4_03', 0);
			detailForm.setValue('C_O4_04', 0);
			detailForm.setValue('C_O4_05', 0);
			detailForm.setValue('C_O7_01', 0);
			detailForm.setValue('C_O7_02', 0);
			detailForm.setValue('C_O7_03', 0);
			detailForm.setValue('C_O8_01', 0);
			detailForm.setValue('C_O8_02', 0);
			detailForm.setValue('C_O8_03', 0);
			detailForm.setValue('C_O8_04', 0);
			detailForm.setValue('C_O8_05', 0);
			detailForm.setValue('C_O9_01', 0);
			detailForm.setValue('C_O9_02', 0);
			detailForm.setValue('C_O9_03', 0);
			detailForm.setValue('C_1O_01', 0);
			detailForm.setValue('C_1O_02', 0);
			detailForm.setValue('C_1O_03', 0);
			detailForm.setValue('C_11_01', 0);
			detailForm.setValue('C_11_02', 0);
			detailForm.setValue('C_11_03', 0);
			detailForm.setValue('C_12_01', 0);
			detailForm.setValue('C_12_02', 0);
			detailForm.setValue('C_12_03', 0);
			detailForm.setValue('C_12_06', 0);
			detailForm.setValue('C_12_07', 0);
			detailForm.setValue('C_12_08', 0);
			detailForm.setValue('C_13_01', 0);
			detailForm.setValue('C_13_02', 0);
			detailForm.setValue('C_13_03', 0);
			detailForm.setValue('C_13_06', 0);
			detailForm.setValue('C_13_07', 0);
			detailForm.setValue('C_13_08', 0);
			detailForm.setValue('C_14_01', 0);
			detailForm.setValue('C_14_02', 0);
			detailForm.setValue('C_14_03', 0);
			detailForm.setValue('C_15_01', 0);
			detailForm.setValue('C_15_02', 0);
			detailForm.setValue('C_15_03', 0);
			detailForm.setValue('C_16_01', 0);
			detailForm.setValue('C_16_02', 0);
			detailForm.setValue('C_16_03', 0);
			detailForm.setValue('C_16_06', 0);
			detailForm.setValue('C_16_07', 0);
			detailForm.setValue('C_16_08', 0);
			detailForm.setValue('C_17_01', 0);
			detailForm.setValue('C_17_02', 0);
			detailForm.setValue('C_17_03', 0);
			detailForm.setValue('C_17_04', 0);
			detailForm.setValue('C_17_05', 0);
			detailForm.setValue('C_17_06', 0);
			detailForm.setValue('C_17_07', 0);
			detailForm.setValue('C_17_08', 0);
			detailForm.setValue('C_17_09', 0);
			detailForm.setValue('C_17_10', 0);
			detailForm.setValue('C_18_01', 0);
			detailForm.setValue('C_18_02', 0);
			detailForm.setValue('C_18_03', 0);
			detailForm.setValue('C_18_04', 0);
			detailForm.setValue('C_18_05', 0);
			detailForm.setValue('C_18_06', 0);
			detailForm.setValue('C_18_07', 0);
			detailForm.setValue('C_18_08', 0);
			detailForm.setValue('C_18_09', 0);
			detailForm.setValue('C_18_10', 0);
			detailForm.setValue('C_19_01', 0);
			detailForm.setValue('C_19_02', 0);
			detailForm.setValue('C_19_03', 0);
			detailForm.setValue('C_19_04', 0);
			detailForm.setValue('C_19_05', 0);
			detailForm.setValue('C_19_06', 0);
			detailForm.setValue('C_19_07', 0);
			detailForm.setValue('C_19_08', 0);
			detailForm.setValue('C_19_09', 0);
			detailForm.setValue('C_19_10', 0);
			detailForm.setValue('C_20_01', 0);
			detailForm.setValue('C_20_02', 0);
			detailForm.setValue('C_20_03', 0);
			detailForm.setValue('C_20_04', 0);
			detailForm.setValue('C_20_05', 0);
			detailForm.setValue('C_21_01', 0);
			detailForm.setValue('C_21_02', 0);
			detailForm.setValue('C_21_03', 0);
			detailForm.setValue('C_21_04', 0);
			detailForm.setValue('C_21_05', 0);
			detailForm.setValue('C_21_06', 0);
			detailForm.setValue('C_21_07', 0);
			detailForm.setValue('C_21_08', 0);
			detailForm.setValue('C_21_09', 0);
			detailForm.setValue('C_21_10', 0);
			detailForm.setValue('C_22_01', 0);
			detailForm.setValue('C_22_02', 0);
			detailForm.setValue('C_22_03', 0);
			detailForm.setValue('C_23_01', 0);
			detailForm.setValue('C_23_02', 0);
			detailForm.setValue('C_23_03', 0);
			detailForm.setValue('C_23_06', 0);
			detailForm.setValue('C_23_07', 0);
			detailForm.setValue('C_23_08', 0);
			detailForm.setValue('C_24_01', 0);
			detailForm.setValue('C_24_02', 0);
			detailForm.setValue('C_24_03', 0);
			detailForm.setValue('C_24_06', 0);
			detailForm.setValue('C_24_07', 0);
			detailForm.setValue('C_24_08', 0);
			detailForm.setValue('C_25_01', 0);
			detailForm.setValue('C_25_02', 0);
			detailForm.setValue('C_25_03', 0);
			detailForm.setValue('C_25_06', 0);
			detailForm.setValue('C_25_07', 0);
			detailForm.setValue('C_25_08', 0);
			detailForm.setValue('C_26_01', 0);
			detailForm.setValue('C_26_02', 0);
			detailForm.setValue('C_26_03', 0);
			detailForm.setValue('C_26_06', 0);
			detailForm.setValue('C_26_07', 0);
			detailForm.setValue('C_26_08', 0);
			detailForm.setValue('C_27_01', 0);
			detailForm.setValue('C_27_02', 0);
			detailForm.setValue('C_27_03', 0);
			detailForm.setValue('C_27_06', 0);
			detailForm.setValue('C_27_07', 0);
			detailForm.setValue('C_27_08', 0);
			detailForm.setValue('C_28_01', 0);
			detailForm.setValue('C_28_02', 0);
			detailForm.setValue('C_28_03', 0);
			detailForm.setValue('C_28_06', 0);
			detailForm.setValue('C_28_07', 0);
			detailForm.setValue('C_28_08', 0);
			
//			this.onQueryButtonDown();
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
					
		}/*,
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
		}*/,
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
