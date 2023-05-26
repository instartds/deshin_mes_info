<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//현금 수입금 등록
request.setAttribute("PKGNAME","Unilite_app_grg100ukrv");
%>
<t:appConfig pgmId="grg100ukrv"  >	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'grg100ukrvService.selectDetailList',
			update: 'grg100ukrvService.updateDetail',
			create: 'grg100ukrvService.insertDetail',
			destroy: 'grg100ukrvService.deleteDetail',
			syncAll: 'grg100ukrvService.saveAll'
		}
	});	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '손익계산서',
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
    			window.open(CPATH+'/busevaluation/excel/grg100out?SERVICE_YEAR='+panelSearch.getValue('SERVICE_YEAR'), "_self");
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
			{ xtype: 'component', html:'<b>계        정        과        목</b>', colspan: 2},
			{ xtype: 'component', html:'<b>코드</b>'},
			{ xtype: 'component', html:'<b>금                  액</b>', width: 154},
			{ xtype: 'component', html:'<b>계        정        과        목</b>', colspan:  2},
			{ xtype: 'component', html:'<b>코드</b>'},
			{ xtype: 'component', html:'<b>금                  액</b>', height: 25, width: 154},
			
			{ xtype: 'component',  		html:'Ⅰ.', width: 30 },
			{ xtype: 'component',  		html:'매출액', width: 200 },
			{ xtype: 'component',  		html:'01', width: 30 },
			{ xtype: 'uniNumberfield',  name:'G_01', holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html:'Ⅵ.', width: 30 },
			{ xtype: 'component',  		html:'영업외수익', width: 200 },
			{ xtype: 'component', 		html:'42', width: 30 },
			{ xtype: 'uniNumberfield',  name:'G_42', holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '(1)' },
			{ xtype: 'component',  		html: '운송수입'  },
			{ xtype: 'component',  		html: '02'  },
			{ xtype: 'uniNumberfield',  name:'G_02' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '1.'  },
			{ xtype: 'component',  		html: '이자수익'  },
			{ xtype: 'component', 		html: '43'  },
			{ xtype: 'uniNumberfield',  name:'G_43' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '시내버스'  },
			{ xtype: 'component',  		html: '03'  },
			{ xtype: 'uniNumberfield',  name:'G_03' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '2.'  },
			{ xtype: 'component',  		html: '배당금수익'  },
			{ xtype: 'component', 		html: '44'  },
			{ xtype: 'uniNumberfield',  name:'G_44' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '시외버스'  },
			{ xtype: 'component',  		html: '04'  },
			{ xtype: 'uniNumberfield',  name:'G_04' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '3.'  },
			{ xtype: 'component',  		html: '임대료'  },
			{ xtype: 'component', 		html: '45'  },
			{ xtype: 'uniNumberfield',  name:'G_45' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '3.' },
			{ xtype: 'component',  		html: '공항버스'  },
			{ xtype: 'component',  		html: '05'  },
			{ xtype: 'uniNumberfield',  name:'G_05' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '4.'  },
			{ xtype: 'component',  		html: '유가증권처분이익'  },
			{ xtype: 'component', 		html: '46'  },
			{ xtype: 'uniNumberfield',  name:'G_46' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '4.' },
			{ xtype: 'component',  		html: '기타(마을/전세버스 등)'  },
			{ xtype: 'component',  		html: '06'  },
			{ xtype: 'uniNumberfield',  name:'G_06' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '5.'  },
			{ xtype: 'component',  		html: '유가증권평가이익'  },
			{ xtype: 'component', 		html: '47'  },
			{ xtype: 'uniNumberfield',  name:'G_47' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '(2)' },
			{ xtype: 'component',  		html: '광고수입'  },
			{ xtype: 'component',  		html: '07'  },
			{ xtype: 'uniNumberfield',  name:'G_07' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '6.'  },
			{ xtype: 'component',  		html: '외환차익(환산이익포함)'  },
			{ xtype: 'component', 		html: '48'  },
			{ xtype: 'uniNumberfield',  name:'G_48' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '시내버스'  },
			{ xtype: 'component',  		html: '08'  },
			{ xtype: 'uniNumberfield',  name:'G_08' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '7.'  },
			{ xtype: 'component',  		html: '정부보조금(성과)'  },
			{ xtype: 'component', 		html: '49'  },
			{ xtype: 'uniNumberfield',  name:'G_49' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '시외버스'  },
			{ xtype: 'component',  		html: '09'  },
			{ xtype: 'uniNumberfield',  name:'G_09' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '8.'  },
			{ xtype: 'component',  		html: '지분법평가이익'  },
			{ xtype: 'component', 		html: '50'  },
			{ xtype: 'uniNumberfield',  name:'G_50' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '3.' },
			{ xtype: 'component',  		html: '공항버스'  },
			{ xtype: 'component',  		html: '10'  },
			{ xtype: 'uniNumberfield',  name:'G_10' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '9.'  },
			{ xtype: 'component',  		html: '투자유가증권감액손실환입'  },
			{ xtype: 'component', 		html: '51'  },
			{ xtype: 'uniNumberfield',  name:'G_51' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '4.' },
			{ xtype: 'component',  		html: '기타(마을/전세버스 등)'  },
			{ xtype: 'component',  		html: '11'  },
			{ xtype: 'uniNumberfield',  name:'G_11' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '10.'  },
			{ xtype: 'component',  		html: '투자자산처분이익'  },
			{ xtype: 'component', 		html: '52'  },
			{ xtype: 'uniNumberfield',  name:'G_52' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '(3)' },
			{ xtype: 'component',  		html: '정부보조금(보전)'  },
			{ xtype: 'component',  		html: '12'  },
			{ xtype: 'uniNumberfield',  name:'G_12' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '11.'  },
			{ xtype: 'component',  		html: '버스차량처분이익'  },
			{ xtype: 'component', 		html: '53'  },
			{ xtype: 'uniNumberfield',  name:'G_53' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '시내버스'  },
			{ xtype: 'component',  		html: '13'  },
			{ xtype: 'uniNumberfield',  name:'G_13' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '12.'  },
			{ xtype: 'component',  		html: '일반유형자산처분이익'  },
			{ xtype: 'component', 		html: '54'  },
			{ xtype: 'uniNumberfield',  name:'G_54' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '시외버스'  },
			{ xtype: 'component',  		html: '14'  },
			{ xtype: 'uniNumberfield',  name:'G_14' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '13.'  },
			{ xtype: 'component',  		html: '탁송화물수익'  },
			{ xtype: 'component', 		html: '55'  },
			{ xtype: 'uniNumberfield',  name:'G_55' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '3.' },
			{ xtype: 'component',  		html: '공항버스'  },
			{ xtype: 'component',  		html: '15'  },
			{ xtype: 'uniNumberfield',  name:'G_15' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '14.'  },
			{ xtype: 'component',  		html: '사고보상비'  },
			{ xtype: 'component', 		html: '56'  },
			{ xtype: 'uniNumberfield',  name:'G_56' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '4.' },
			{ xtype: 'component',  		html: '기타(마을/전세버스 등)'  },
			{ xtype: 'component',  		html: '16'  },
			{ xtype: 'uniNumberfield',  name:'G_16' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '15.'  },
			{ xtype: 'component',  		html: '전기오류수정이익'  },
			{ xtype: 'component', 		html: '57'  },
			{ xtype: 'uniNumberfield',  name:'G_57' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '(4)' },
			{ xtype: 'component',  		html: '기타수입'  },
			{ xtype: 'component',  		html: '17'  },
			{ xtype: 'uniNumberfield',  name:'G_17' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '16.'  },
			{ xtype: 'component',  		html: '기타'  },
			{ xtype: 'component', 		html: '58'  },
			{ xtype: 'uniNumberfield',  name:'G_58' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: 'Ⅱ.' },
			{ xtype: 'component',  		html: '매출원가'  },
			{ xtype: 'component',  		html: '18'  },
			{ xtype: 'uniNumberfield',  name:'G_18' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: 'Ⅶ.'  },
			{ xtype: 'component',  		html: '영업외비용'  },
			{ xtype: 'component', 		html: '59'  },
			{ xtype: 'uniNumberfield',  name:'G_59' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '(1)' },
			{ xtype: 'component',  		html: '운송원가'  },
			{ xtype: 'component',  		html: '19'  },
			{ xtype: 'uniNumberfield',  name:'G_19' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '1.'  },
			{ xtype: 'component',  		html: '이자비용'  },
			{ xtype: 'component', 		html: '60'  },
			{ xtype: 'uniNumberfield',  name:'G_60' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '시내버스'  },
			{ xtype: 'component',  		html: '20'  },
			{ xtype: 'uniNumberfield',  name:'G_20' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '2.'  },
			{ xtype: 'component',  		html: '기타의대손상각비'  },
			{ xtype: 'component', 		html: '61'  },
			{ xtype: 'uniNumberfield',  name:'G_61' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '시외버스'  },
			{ xtype: 'component',  		html: '21'  },
			{ xtype: 'uniNumberfield',  name:'G_21' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '3.'  },
			{ xtype: 'component',  		html: '범칙금 및 과태료'  },
			{ xtype: 'component', 		html: '62'  },
			{ xtype: 'uniNumberfield',  name:'G_62' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '3.' },
			{ xtype: 'component',  		html: '공항버스'  },
			{ xtype: 'component',  		html: '22'  },
			{ xtype: 'uniNumberfield',  name:'G_22' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '4.'  },
			{ xtype: 'component',  		html: '유가증권처분손실'  },
			{ xtype: 'component', 		html: '63'  },
			{ xtype: 'uniNumberfield',  name:'G_63' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '4.' },
			{ xtype: 'component',  		html: '기타(마을/전세버스 등)'  },
			{ xtype: 'component',  		html: '23'  },
			{ xtype: 'uniNumberfield',  name:'G_23' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '5.'  },
			{ xtype: 'component',  		html: '유가증권평가손실'  },
			{ xtype: 'component', 		html: '64'  },
			{ xtype: 'uniNumberfield',  name:'G_64' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '(2)' },
			{ xtype: 'component',  		html: '기타수입원가'  },
			{ xtype: 'component',  		html: '24'  },
			{ xtype: 'uniNumberfield',  name:'G_24' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '6.'  },
			{ xtype: 'component',  		html: '재고자산평가손실'  },
			{ xtype: 'component', 		html: '65'  },
			{ xtype: 'uniNumberfield',  name:'G_65' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: 'Ⅲ.' },
			{ xtype: 'component',  		html: '매출총이익'  },
			{ xtype: 'component',  		html: '25'  },
			{ xtype: 'uniNumberfield',  name:'G_25' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '7.'  },
			{ xtype: 'component',  		html: '외화차손'  },
			{ xtype: 'component', 		html: '66'  },
			{ xtype: 'uniNumberfield',  name:'G_66' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: 'Ⅳ.' },
			{ xtype: 'component',  		html: '팡매비와 관리비'  },
			{ xtype: 'component',  		html: '26'  },
			{ xtype: 'uniNumberfield',  name:'G_26' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '8.'  },
			{ xtype: 'component',  		html: '외화환산손실'  },
			{ xtype: 'component', 		html: '67'  },
			{ xtype: 'uniNumberfield',  name:'G_67' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '1.' },
			{ xtype: 'component',  		html: '급여'  },
			{ xtype: 'component',  		html: '27'  },
			{ xtype: 'uniNumberfield',  name:'G_27' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '9.'  },
			{ xtype: 'component',  		html: '지분법평가손실'  },
			{ xtype: 'component', 		html: '68'  },
			{ xtype: 'uniNumberfield',  name:'G_68' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '2.' },
			{ xtype: 'component',  		html: '일용직급여'  },
			{ xtype: 'component',  		html: '28'  },
			{ xtype: 'uniNumberfield',  name:'G_28' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '10.'  },
			{ xtype: 'component',  		html: '투자유가증권감액손실환입'  },
			{ xtype: 'component', 		html: '69'  },
			{ xtype: 'uniNumberfield',  name:'G_69' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '3.' },
			{ xtype: 'component',  		html: '퇴직급여(충당금전입액포함)'  },
			{ xtype: 'component',  		html: '29'  },
			{ xtype: 'uniNumberfield',  name:'G_29' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '11.'  },
			{ xtype: 'component',  		html: '투자자산처분손실'  },
			{ xtype: 'component', 		html: '70'  },
			{ xtype: 'uniNumberfield',  name:'G_70' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '4.' },
			{ xtype: 'component',  		html: '복리후생비'  },
			{ xtype: 'component',  		html: '30'  },
			{ xtype: 'uniNumberfield',  name:'G_30' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '12.'  },
			{ xtype: 'component',  		html: '유무형자산처분손실'  },
			{ xtype: 'component', 		html: '71'  },
			{ xtype: 'uniNumberfield',  name:'G_71' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '5.' },
			{ xtype: 'component',  		html: '임차료'  },
			{ xtype: 'component',  		html: '31'  },
			{ xtype: 'uniNumberfield',  name:'G_31' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '13.'  },
			{ xtype: 'component',  		html: '기부금'  },
			{ xtype: 'component', 		html: '72'  },
			{ xtype: 'uniNumberfield',  name:'G_72' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '6.' },
			{ xtype: 'component',  		html: '접대비'  },
			{ xtype: 'component',  		html: '32'  },
			{ xtype: 'uniNumberfield',  name:'G_32' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '14.'  },
			{ xtype: 'component',  		html: '전기오류수정손실'  },
			{ xtype: 'component', 		html: '73'  },
			{ xtype: 'uniNumberfield',  name:'G_73' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '7.' },
			{ xtype: 'component',  		html: '감가상각비'  },
			{ xtype: 'component',  		html: '33'  },
			{ xtype: 'uniNumberfield',  name:'G_33' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: '15.'  },
			{ xtype: 'component',  		html: '기타'  },
			{ xtype: 'component', 		html: '74'  },
			{ xtype: 'uniNumberfield',  name:'G_74' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '8.' },
			{ xtype: 'component',  		html: '무형(이연)자산상각비'  },
			{ xtype: 'component',  		html: '34'  },
			{ xtype: 'uniNumberfield',  name:'G_34' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: 'Ⅷ.'  },
			{ xtype: 'component',  		html: '법인세차감전순이익(손실)'  },
			{ xtype: 'component', 		html: '75'  },
			{ xtype: 'uniNumberfield',  name:'G_75' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '9.' },
			{ xtype: 'component',  		html: '세금과공과'  },
			{ xtype: 'component',  		html: '35'  },
			{ xtype: 'uniNumberfield',  name:'G_35' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component', 		html: '76'  },
			{ xtype: 'component'},
			
			
			{ xtype: 'component',  		html: '10.' },
			{ xtype: 'component',  		html: '광고선전비'  },
			{ xtype: 'component',  		html: '36'  },
			{ xtype: 'uniNumberfield',  name:'G_36' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component', 		html: '77'  },
			{ xtype: 'component'},
			
			{ xtype: 'component',  		html: '11.' },
			{ xtype: 'component',  		html: '대손상각비'  },
			{ xtype: 'component',  		html: '37'  },
			{ xtype: 'uniNumberfield',  name:'G_37' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component', 		html: '78'  },
			{ xtype: 'component'},
			
			{ xtype: 'component',  		html: '12.' },
			{ xtype: 'component',  		html: '지급수수료'  },
			{ xtype: 'component',  		html: '38'  },
			{ xtype: 'uniNumberfield',  name:'G_38' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component',  		html: ''  },
			{ xtype: 'component', 		html: '79'  },
			{ xtype: 'component'},
			
			{ xtype: 'component',  		html: '13.' },
			{ xtype: 'component',  		html: '일반차량유지비'  },
			{ xtype: 'component',  		html: '39'  },
			{ xtype: 'uniNumberfield',  name:'G_39' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: 'Ⅸ'  },
			{ xtype: 'component',  		html: '법인세비용'  },
			{ xtype: 'component', 		html: '80'  },
			{ xtype: 'uniNumberfield',  name:'G_80' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: '14.' },
			{ xtype: 'component',  		html: '기타'  },
			{ xtype: 'component',  		html: '40'  },
			{ xtype: 'uniNumberfield',  name:'G_40' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: 'Ⅹ.'  },
			{ xtype: 'component',  		html: '당가순이익(순손실)'  },
			{ xtype: 'component', 		html: '81'  },
			{ xtype: 'uniNumberfield',  name:'G_81' , holdable: 'hold', value: 0 },
			
			{ xtype: 'component',  		html: 'Ⅴ.' },
			{ xtype: 'component',  		html: '영업이익'  },
			{ xtype: 'component',  		html: '41'  },
			{ xtype: 'uniNumberfield',  name:'G_41' , holdable: 'hold', value: 0 },
			{ xtype: 'component',  		html: 'XI.'  },
			{ xtype: 'component',  		html: '배당금지급액'  },
			{ xtype: 'component', 		html: '82'  },
			{ xtype: 'uniNumberfield',  name:'G_82' , holdable: 'hold', value: 0 
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
		}
		, 
		api: {
			load: 'grg100ukrvService.selectMaster',
			submit: 'grg100ukrvService.syncMaster'				
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
		id  : 'grg100ukrvApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			detailForm.setAllFieldsReadOnly(true);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			detailForm.clearForm();
			detailForm.setValue('G_01', 0);
			detailForm.setValue('G_02', 0);
			detailForm.setValue('G_03', 0);
			detailForm.setValue('G_04', 0);
			detailForm.setValue('G_05', 0);
			detailForm.setValue('G_06', 0);
			detailForm.setValue('G_07', 0);
			detailForm.setValue('G_08', 0);
			detailForm.setValue('G_09', 0);
			detailForm.setValue('G_10', 0);
			detailForm.setValue('G_11', 0);
			detailForm.setValue('G_12', 0);
			detailForm.setValue('G_13', 0);
			detailForm.setValue('G_14', 0);
			detailForm.setValue('G_15', 0);
			detailForm.setValue('G_16', 0);
			detailForm.setValue('G_17', 0);
			detailForm.setValue('G_18', 0);
			detailForm.setValue('G_19', 0);
			detailForm.setValue('G_20', 0);
			detailForm.setValue('G_21', 0);
			detailForm.setValue('G_22', 0);
			detailForm.setValue('G_23', 0);
			detailForm.setValue('G_24', 0);
			detailForm.setValue('G_25', 0);
			detailForm.setValue('G_26', 0);
			detailForm.setValue('G_27', 0);
			detailForm.setValue('G_28', 0);
			detailForm.setValue('G_29', 0);
			detailForm.setValue('G_30', 0);
			detailForm.setValue('G_31', 0);
			detailForm.setValue('G_32', 0);
			detailForm.setValue('G_33', 0);
			detailForm.setValue('G_34', 0);
			detailForm.setValue('G_35', 0);
			detailForm.setValue('G_36', 0);
			detailForm.setValue('G_37', 0);
			detailForm.setValue('G_38', 0);
			detailForm.setValue('G_39', 0);
			detailForm.setValue('G_40', 0);
			detailForm.setValue('G_41', 0);
			detailForm.setValue('G_42', 0);
			detailForm.setValue('G_43', 0);
			detailForm.setValue('G_44', 0);
			detailForm.setValue('G_45', 0);
			detailForm.setValue('G_46', 0);
			detailForm.setValue('G_47', 0);
			detailForm.setValue('G_48', 0);
			detailForm.setValue('G_49', 0);
			detailForm.setValue('G_50', 0);
			detailForm.setValue('G_51', 0);
			detailForm.setValue('G_52', 0);
			detailForm.setValue('G_53', 0);
			detailForm.setValue('G_54', 0);
			detailForm.setValue('G_55', 0);
			detailForm.setValue('G_56', 0);
			detailForm.setValue('G_57', 0);
			detailForm.setValue('G_58', 0);
			detailForm.setValue('G_59', 0);
			detailForm.setValue('G_60', 0);
			detailForm.setValue('G_61', 0);
			detailForm.setValue('G_62', 0);
			detailForm.setValue('G_63', 0);
			detailForm.setValue('G_64', 0);
			detailForm.setValue('G_65', 0);
			detailForm.setValue('G_66', 0);
			detailForm.setValue('G_67', 0);
			detailForm.setValue('G_68', 0);
			detailForm.setValue('G_69', 0);
			detailForm.setValue('G_70', 0);
			detailForm.setValue('G_71', 0);
			detailForm.setValue('G_72', 0);
			detailForm.setValue('G_73', 0);
			detailForm.setValue('G_74', 0);
			detailForm.setValue('G_75', 0);
			detailForm.setValue('G_76', 0);
			detailForm.setValue('G_77', 0);
			detailForm.setValue('G_78', 0);
			detailForm.setValue('G_79', 0);
			detailForm.setValue('G_80', 0);
			detailForm.setValue('G_81', 0);
			detailForm.setValue('G_82', 0);			
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