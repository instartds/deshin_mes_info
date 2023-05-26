<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_grf100ukrv");
%>
<t:appConfig pgmId="grf100ukrv"  >	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'grf100ukrvService.selectDetailList',
			update: 'grf100ukrvService.updateDetail',
			create: 'grf100ukrvService.insertDetail',
			destroy: 'grf100ukrvService.deleteDetail',
			syncAll: 'grf100ukrvService.saveAll'
		}
	});	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '재무상태',
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
						var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
							if(needSave) {
								Ext.Msg.show({
								     title:'확인',
								     msg: Msg.sMB017 + "\n" + Msg.sMB061,
								     buttons: Ext.Msg.YESNOCANCEL,
								     icon: Ext.Msg.QUESTION,
								     fn: function(res) {
								     	//console.log(res);
								     	if (res === 'yes' ) {
								     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
						                  		UniAppManager.app.onSaveAndQueryButtonDown();
						                    });
						                    saveTask.delay(500);
								     	} else if(res === 'no') {
								     		UniAppManager.app.onQueryButtonDown();
								     	}
								     }
								});
							} else {
								setTimeout(function(){
									UniAppManager.app.onQueryButtonDown()
									}
									, 500
								)
							}					
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
					var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
							if(needSave) {
								Ext.Msg.show({
								     title:'확인',
								     msg: Msg.sMB017 + "\n" + Msg.sMB061,
								     buttons: Ext.Msg.YESNOCANCEL,
								     icon: Ext.Msg.QUESTION,
								     fn: function(res) {
								     	//console.log(res);
								     	if (res === 'yes' ) {
								     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
						                  		UniAppManager.app.onSaveAndQueryButtonDown();
						                    });
						                    saveTask.delay(500);
								     	} else if(res === 'no') {
								     		UniAppManager.app.onQueryButtonDown();
								     	}
								     }
								});
							} else {
								setTimeout(function(){
									UniAppManager.app.onQueryButtonDown()
									}
									, 500
								)
							}
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
    			window.open(CPATH+'/busevaluation/excel/grf100out?SERVICE_YEAR='+panelSearch.getValue('SERVICE_YEAR'), "_self");
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
			columns:8,
			tableAttrs: {style: 'border : 1px solid #ced9e7;'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
		},
		items: [
			{name: 'COMP_CODE', fieldLabel: 'COMP_CODE', allowBlank:false ,colspan:2, hidden:true, value:UserInfo.compCode},
			{ xtype: 'component', html:'<b>자산항목</b>', colspan: 2},
			{ xtype: 'component', html:'<b>코드</b>'},
			{ xtype: 'component', html:'<b>금                  액</b>', width: 154},
			{ xtype: 'component', html:'<b>부채 및 자본항목</b>', colspan:  2},
			{ xtype: 'component', html:'<b>코드</b>'},
			{ xtype: 'component', html:'<b>금                  액</b>', height: 25,width: 154},
			
			{ xtype: 'component',  		html:'Ⅰ.' , width: 30},
			{ xtype: 'component',  		html:'유동자산', width: 200 },
			{ xtype: 'component',  		html:'01', width: 30 },
			{ xtype: 'uniNumberfield',  name:'F_01', value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html:'I.', width: 30 },
			{ xtype: 'component',  		html:'유동부채', width: 200 },
			{ xtype: 'component', 		html:'37', width: 30 },
			{ xtype: 'uniNumberfield',  name:'F_37', value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '(1)' },
			{ xtype: 'component',  		html: '당좌자산' },
			{ xtype: 'component',  		html: '02'  },
			{ xtype: 'uniNumberfield',  name:'F_02' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '1.'  },
			{ xtype: 'component',  		html: '외상매입금'},
			{ xtype: 'component', 		html: '38'  },
			{ xtype: 'uniNumberfield',  name:'F_38' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '현금 및 현금성자산'  },
			{ xtype: 'component',  		html: '03'  },
			{ xtype: 'uniNumberfield',  name:'F_03' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '2.'  },
			{ xtype: 'component',  		html: '지급어음'  },
			{ xtype: 'component', 		html: '39'  },
			{ xtype: 'uniNumberfield',  name:'F_39' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '단기금융상품'  },
			{ xtype: 'component',  		html: '04'  },
			{ xtype: 'uniNumberfield',   name:'F_04' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '3.'  },
			{ xtype: 'component',  		html: '단기차입금'  },
			{ xtype: 'component', 		html: '40'  },
			{ xtype: 'uniNumberfield',   name:'F_40' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '3.' },
			{ xtype: 'component',  		html: '단기투자자산'  },
			{ xtype: 'component',  		html: '05'  },
			{ xtype: 'uniNumberfield',   name:'F_05' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '4.'  },
			{ xtype: 'component',  		html: '미지급금'  },
			{ xtype: 'component', 		html: '41'  },
			{ xtype: 'uniNumberfield',   name:'F_41' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '4.' },
			{ xtype: 'component',  		html: '외상매출금'  },
			{ xtype: 'component',  		html: '06'  },
			{ xtype: 'uniNumberfield',   name:'F_06' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '5.'  },
			{ xtype: 'component',  		html: '미지급비용'  },
			{ xtype: 'component', 		html: '42'  },
			{ xtype: 'uniNumberfield',   name:'F_42' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '5.' },
			{ xtype: 'component',  		html: '받을어음'  },
			{ xtype: 'component',  		html: '07'  },
			{ xtype: 'uniNumberfield',   name:'F_07' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '6.'  },
			{ xtype: 'component',  		html: '기타유동부채'  },
			{ xtype: 'component', 		html: '43'  },
			{ xtype: 'uniNumberfield',   name:'F_43' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '6.' },
			{ xtype: 'component',  		html: '단기대여금'  },
			{ xtype: 'component',  		html: '08'  },
			{ xtype: 'uniNumberfield',   name:'F_08' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: 'Ⅱ.'  },
			{ xtype: 'component',  		html: '비유동부채'  },
			{ xtype: 'component', 		html: '44'  },
			{ xtype: 'uniNumberfield',   name:'F_44' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '7.' },
			{ xtype: 'component',  		html: '미수금'  },
			{ xtype: 'component',  		html: '09'  },
			{ xtype: 'uniNumberfield',   name:'F_09' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '1.'  },
			{ xtype: 'component',  		html: '장기차입금'  },
			{ xtype: 'component', 		html: '45'  },
			{ xtype: 'uniNumberfield',   name:'F_45' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '8.' },
			{ xtype: 'component',  		html: '기타유동자산'  },
			{ xtype: 'component',  		html: '10'  },
			{ xtype: 'uniNumberfield',   name:'F_10' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '2.'  },
			{ xtype: 'component',  		html: '관계회사장기차입금'  },
			{ xtype: 'component', 		html: '46'  },
			{ xtype: 'uniNumberfield',   name:'F_46' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '(2)' },
			{ xtype: 'component',  		html: '재고자산'  },
			{ xtype: 'component',  		html: '11'  },
			{ xtype: 'uniNumberfield',   name:'F_11' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '3.'  },
			{ xtype: 'component',  		html: '주주·임원·종업원차입금'  },
			{ xtype: 'component', 		html: '47'  },
			{ xtype: 'uniNumberfield',   name:'F_47' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '상품과제품'  },
			{ xtype: 'component',  		html: '12'  },
			{ xtype: 'uniNumberfield',   name:'F_12' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '4.'  },
			{ xtype: 'component',  		html: '퇴직급여충당금'  },
			{ xtype: 'component', 		html: '48'  },
			{ xtype: 'uniNumberfield',   name:'F_48' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '반제품'  },
			{ xtype: 'component',  		html: '13'  },
			{ xtype: 'uniNumberfield',   name:'F_13' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: '퇴직연금'  },
			{ xtype: 'component', 		html: '49'  },
			{ xtype: 'uniNumberfield',   name:'F_49' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '3.' },
			{ xtype: 'component',  		html: '원재료'  },
			{ xtype: 'component',  		html: '14'  },
			{ xtype: 'uniNumberfield',   name:'F_14' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: '퇴직보험예치금'  },
			{ xtype: 'component', 		html: '50'  },
			{ xtype: 'uniNumberfield',   name:'F_50' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '4.' },
			{ xtype: 'component',  		html: '저장품 등'  },
			{ xtype: 'component',  		html: '15'  },
			{ xtype: 'uniNumberfield',   name:'F_15' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: '국민연금전환금'  },
			{ xtype: 'component', 		html: '51'  },
			{ xtype: 'uniNumberfield',   name:'F_51' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: 'Ⅱ.' },
			{ xtype: 'component',  		html: '비유동자산'  },
			{ xtype: 'component',  		html: '16'  },
			{ xtype: 'uniNumberfield',   name:'F_16' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '5.'  },
			{ xtype: 'component',  		html: '기타비유동부채'  },
			{ xtype: 'component', 		html: '52'  },
			{ xtype: 'uniNumberfield',   name:'F_52' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '(1)' },
			{ xtype: 'component',  		html: '투자자산'  },
			{ xtype: 'component',  		html: '17'  },
			{ xtype: 'uniNumberfield',   name:'F_17' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component', 		html: '53'  },
			{ xtype: 'component', 		html: ''  },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '장기투자증권'  },
			{ xtype: 'component',  		html: '18'  },
			{ xtype: 'uniNumberfield',   name:'F_18' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '<b>부채총계(Ⅰ + Ⅱ)</b>' , colspan: 2},				
			{ xtype: 'component', 		html: '54'  },
			{ xtype: 'uniNumberfield',   name:'F_54' , value: 0, fieldStyle: 'font-weight:bold', readOnly: true },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '지분법적용투자주식'  },
			{ xtype: 'component',  		html: '19'  },
			{ xtype: 'uniNumberfield',   name:'F_19' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: 'Ⅲ.'  },
			{ xtype: 'component',  		html: '자본금'  },
			{ xtype: 'component', 		html: '55'  },
			{ xtype: 'uniNumberfield',   name:'F_55' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '3.' },
			{ xtype: 'component',  		html: '장기대여금'  },
			{ xtype: 'component',  		html: '20'  },
			{ xtype: 'uniNumberfield',   name:'F_20' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: 'Ⅳ.'  },
			{ xtype: 'component',  		html: '자본잉여금'  },
			{ xtype: 'component', 		html: '56'  },
			{ xtype: 'uniNumberfield',   name:'F_56' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '4.' },
			{ xtype: 'component',  		html: '기타투자자산'  },
			{ xtype: 'component',  		html: '21'  },
			{ xtype: 'uniNumberfield',   name:'F_21' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '1.'  },
			{ xtype: 'component',  		html: '주식발행초과금'  },
			{ xtype: 'component', 		html: '57'  },
			{ xtype: 'uniNumberfield',   name:'F_57' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '(2)' },
			{ xtype: 'component',  		html: '유형자산'  },
			{ xtype: 'component',  		html: '22'  },
			{ xtype: 'uniNumberfield',   name:'F_22' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '2.'  },
			{ xtype: 'component',  		html: '기타자본잉여금'  },
			{ xtype: 'component', 		html: '58'  },
			{ xtype: 'uniNumberfield',   name:'F_58' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '토지'  },
			{ xtype: 'component',  		html: '23'  },
			{ xtype: 'uniNumberfield',   name:'F_23' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: 'Ⅴ.'  },
			{ xtype: 'component',  		html: '기타포괄손익누계액'  },
			{ xtype: 'component', 		html: '59'  },
			{ xtype: 'uniNumberfield',   name:'F_59' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '건물'  },
			{ xtype: 'component',  		html: '24'  },
			{ xtype: 'uniNumberfield',   name:'F_24' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '1.'  },
			{ xtype: 'component',  		html: '매도가능증권평가손익'  },
			{ xtype: 'component', 		html: '60'  },
			{ xtype: 'uniNumberfield',   name:'F_60' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '3.' },
			{ xtype: 'component',  		html: '구축물'  },
			{ xtype: 'component',  		html: '25'  },
			{ xtype: 'uniNumberfield',   name:'F_25' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '2.'  },
			{ xtype: 'component',  		html: '기타포괄속익누계액'  },
			{ xtype: 'component', 		html: '61'  },
			{ xtype: 'uniNumberfield',   name:'F_61' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '4.' },
			{ xtype: 'component',  		html: '기계장치'  },
			{ xtype: 'component',  		html: '26'  },
			{ xtype: 'uniNumberfield',   name:'F_26' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: 'Ⅵ.'  },
			{ xtype: 'component',  		html: '자본조정'  },
			{ xtype: 'component', 		html: '62'  },
			{ xtype: 'uniNumberfield',   name:'F_62' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '5.' },
			{ xtype: 'component',  		html: '버스차량'  },
			{ xtype: 'component',  		html: '27'  },
			{ xtype: 'uniNumberfield',   name:'F_27' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: 'Ⅶ.'  },
			{ xtype: 'component',  		html: '이익잉여금'  },
			{ xtype: 'component', 		html: '63'  },
			{ xtype: 'uniNumberfield',   name:'F_63' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '6.' },
			{ xtype: 'component',  		html: '일반차량운반구'  },
			{ xtype: 'component',  		html: '28'  },
			{ xtype: 'uniNumberfield',   name:'F_28' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '1.'  },
			{ xtype: 'component',  		html: '법정준비금'  },
			{ xtype: 'component', 		html: '64'  },
			{ xtype: 'uniNumberfield',   name:'F_64' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '7.' },
			{ xtype: 'component',  		html: '기타유형자산'  },
			{ xtype: 'component',  		html: '29'  },
			{ xtype: 'uniNumberfield',   name:'F_29' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '2.'  },
			{ xtype: 'component',  		html: '임의적립금'  },
			{ xtype: 'component', 		html: '65'  },
			{ xtype: 'uniNumberfield',   name:'F_65' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '(3)' },
			{ xtype: 'component',  		html: '무형자산'  },
			{ xtype: 'component',  		html: '30'  },
			{ xtype: 'uniNumberfield',   name:'F_30' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '3.'  },
			{ xtype: 'component',  		html: '미처분이익잉여금/미처리결손금'  },
			{ xtype: 'component', 		html: '66'  },
			{ xtype: 'uniNumberfield',   name:'F_66' , value: 0, holdable: 'hold' },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '영업권'  },
			{ xtype: 'component',  		html: '31'  },
			{ xtype: 'uniNumberfield',   name:'F_31' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component', 		html: '67'  },
			{ xtype: 'component', 		html: ''  },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '기타의무형자산'  },
			{ xtype: 'component',  		html: '32'  },
			{ xtype: 'uniNumberfield',   name:'F_32' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component', 		html: '68'  },
			{ xtype: 'component', 		html: ''  },
			
			{ xtype: 'component',  		html: '(4)' },
			{ xtype: 'component',  		html: '기타비유동자산'  },
			{ xtype: 'component',  		html: '33'  },
			{ xtype: 'uniNumberfield',   name:'F_33' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '<b>자본총계</b>' , colspan: 2 },				
			{ xtype: 'component', 		html: '69' , rowspan: 2 },
			{ xtype: 'uniNumberfield',   name:'F_69' , value: 0, rowspan: 2, height: 58, readOnly: true, fieldStyle: 'font-weight:bold' },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '임차보증금'  },
			{ xtype: 'component',  		html: '34'  },
			{ xtype: 'uniNumberfield',   name:'F_34' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '(ⅳ + ⅴ + Ⅵ + Ⅶ)' , colspan: 2 },	
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '기타'  },
			{ xtype: 'component',  		html: '35'  },
			{ xtype: 'uniNumberfield',   name:'F_35' , value: 0, holdable: 'hold' },
			{ xtype: 'component',  		html: '<b>부채및자본총계</b>', colspan: 2 },
			{ xtype: 'component', 		html: '70' , rowspan: 2 },
			{ xtype: 'uniNumberfield',   name:'F_70' , value: 0,rowspan: 2, height: 58, readOnly: true, fieldStyle: 'font-weight:bold' },
			
			{ xtype: 'component',  		html: '<b>자산총계(Ⅰ + Ⅱ)</b>' , colspan: 2},				
			{ xtype: 'component',  		html: '36'  },
			{ xtype: 'uniNumberfield',   name:'F_36' , value: 0,  readOnly: true, fieldStyle: 'font-weight:bold' },
			{ xtype: 'component',  		html: '(Ⅰ+Ⅱ+Ⅲ+ⅳ+ⅴ+Ⅵ+Ⅶ)', colspan: 2 
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
			load: 'grf100ukrvService.selectMaster',
			submit: 'grf100ukrvService.syncMaster'				
		}, 
		listeners : {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
				UniAppManager.setToolbarButtons('save', true);
				this.fnAmtSum();
			}
		},
		fnAmtSum: function() {
			var form = detailForm.getValues();			
			//차변 sum
			var assetsSum = //자산총계(Ⅰ + Ⅱ)
			parseInt(form.F_01) + parseInt(form.F_02) + parseInt(form.F_03) + parseInt(form.F_04) + parseInt(form.F_05) + parseInt(form.F_06) + parseInt(form.F_07) + parseInt(form.F_08) + parseInt(form.F_09) + parseInt(form.F_10) +
			parseInt(form.F_11) + parseInt(form.F_12) + parseInt(form.F_13) + parseInt(form.F_14) + parseInt(form.F_15) + parseInt(form.F_16) + parseInt(form.F_17) + parseInt(form.F_18) + parseInt(form.F_19) + parseInt(form.F_20) + 
			parseInt(form.F_21) + parseInt(form.F_22) + parseInt(form.F_23) + parseInt(form.F_24) + parseInt(form.F_25) + parseInt(form.F_26) + parseInt(form.F_27) + parseInt(form.F_28) + parseInt(form.F_29) + parseInt(form.F_30) + 
			parseInt(form.F_31) + parseInt(form.F_32) + parseInt(form.F_33) + parseInt(form.F_34) + parseInt(form.F_35);
			
			
			
			//대변 sum
			var liabilitySum =	//부채총계(Ⅰ) + Ⅱ)
			parseInt(form.F_37) + parseInt(form.F_38) + parseInt(form.F_39) + parseInt(form.F_40) + parseInt(form.F_41) + parseInt(form.F_42) + parseInt(form.F_43) + parseInt(form.F_44) + parseInt(form.F_45) + parseInt(form.F_46) +
			parseInt(form.F_47) + parseInt(form.F_48) + parseInt(form.F_49) + parseInt(form.F_50) + parseInt(form.F_51) + parseInt(form.F_52);
			
			var capitalSum = //자본총계(ⅳ) + ⅴ) + Ⅵ) + Ⅶ)
			parseInt(form.F_56) + parseInt(form.F_57) + parseInt(form.F_58) + parseInt(form.F_59) + parseInt(form.F_60) + parseInt(form.F_61) + parseInt(form.F_62) + parseInt(form.F_63) + parseInt(form.F_64) + parseInt(form.F_65) +
			parseInt(form.F_66);
			
			var totAmt = //부채및자본총계(Ⅰ+Ⅱ+Ⅲ+ⅳ+ⅴ+Ⅵ+Ⅶ)
			liabilitySum + parseInt(form.F_55)/*자본금*/ + capitalSum;
			
			detailForm.setValue('F_36', assetsSum);
			detailForm.setValue('F_54', liabilitySum);
			detailForm.setValue('F_69', capitalSum);
			detailForm.setValue('F_70', totAmt);			
			
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
		id  : 'grf100ukrvApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			detailForm.setAllFieldsReadOnly(true);			
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('F_01', 0);
          	detailForm.setValue('F_02', 0);
          	detailForm.setValue('F_03', 0);
          	detailForm.setValue('F_04', 0);
          	detailForm.setValue('F_05', 0);
          	detailForm.setValue('F_06', 0);
          	detailForm.setValue('F_07', 0);
          	detailForm.setValue('F_08', 0);
          	detailForm.setValue('F_09', 0);
          	detailForm.setValue('F_10', 0);
          	detailForm.setValue('F_11', 0);
          	detailForm.setValue('F_12', 0);
          	detailForm.setValue('F_13', 0);
          	detailForm.setValue('F_14', 0);
          	detailForm.setValue('F_15', 0);
          	detailForm.setValue('F_16', 0);
          	detailForm.setValue('F_17', 0);
          	detailForm.setValue('F_18', 0);
          	detailForm.setValue('F_19', 0);
          	detailForm.setValue('F_20', 0);
          	detailForm.setValue('F_21', 0);
          	detailForm.setValue('F_22', 0);
          	detailForm.setValue('F_23', 0);
          	detailForm.setValue('F_24', 0);
          	detailForm.setValue('F_25', 0);
          	detailForm.setValue('F_26', 0);
          	detailForm.setValue('F_27', 0);
          	detailForm.setValue('F_28', 0);
          	detailForm.setValue('F_29', 0);
          	detailForm.setValue('F_30', 0);
          	detailForm.setValue('F_31', 0);
          	detailForm.setValue('F_32', 0);
          	detailForm.setValue('F_33', 0);
          	detailForm.setValue('F_34', 0);
          	detailForm.setValue('F_35', 0);
          	detailForm.setValue('F_36', 0);
          	detailForm.setValue('F_37', 0);
          	detailForm.setValue('F_38', 0);
          	detailForm.setValue('F_39', 0);
          	detailForm.setValue('F_40', 0);
          	detailForm.setValue('F_41', 0);
          	detailForm.setValue('F_42', 0);
          	detailForm.setValue('F_43', 0);
          	detailForm.setValue('F_44', 0);
          	detailForm.setValue('F_45', 0);
          	detailForm.setValue('F_46', 0);
          	detailForm.setValue('F_47', 0);
          	detailForm.setValue('F_48', 0);
          	detailForm.setValue('F_49', 0);
          	detailForm.setValue('F_50', 0);
          	detailForm.setValue('F_51', 0);
          	detailForm.setValue('F_52', 0);
          	detailForm.setValue('F_53', 0);
          	detailForm.setValue('F_54', 0);
          	detailForm.setValue('F_55', 0);
          	detailForm.setValue('F_56', 0);
          	detailForm.setValue('F_57', 0);
          	detailForm.setValue('F_58', 0);
          	detailForm.setValue('F_59', 0);
          	detailForm.setValue('F_60', 0);
          	detailForm.setValue('F_61', 0);
          	detailForm.setValue('F_62', 0);
          	detailForm.setValue('F_63', 0);
          	detailForm.setValue('F_64', 0);
          	detailForm.setValue('F_65', 0);
          	detailForm.setValue('F_66', 0);
          	detailForm.setValue('F_67', 0);
          	detailForm.setValue('F_68', 0);
          	detailForm.setValue('F_69', 0);
          	detailForm.setValue('F_70', 0);
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
			this.suspendEvents();
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