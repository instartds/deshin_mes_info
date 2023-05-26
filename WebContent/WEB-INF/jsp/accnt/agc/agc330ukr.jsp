<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc330ukr"  >
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
var getStDt = Ext.isEmpty(${getStDt}) ? ['']: ${getStDt} ;                              //당기시작월 관련 전역변수
if (!Ext.isEmpty(getStDt)) {
    var stDt    = Ext.isEmpty(getStDt[0].STDT) ? '': getStDt[0].STDT ;                   //당기시작월 관련 전역변수
    var toDt    = Ext.isEmpty(getStDt[0].TODT) ? '': getStDt[0].TODT ;
    
} else {
    var stDt    = ''
    var toDt    = ''
}

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createForm('searchForm', {
    	disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
//        padding: '50 0 0 0',
		items :[{ 
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'DVRY_DATE_FR',
	        endFieldName: 'DVRY_DATE_TO',
	        width: 470,
	        startDate: stDt,
	        endDate: toDt,
	        allowBlank: false
        },{
			xtype: 'radiogroup',		            		
			fieldLabel: '차기이월</br>계정분개를',						            		
			id: 'rdoSelect',
			items : [{
				boxLabel: '한다', 
				width:60, 
				name:'rdoSelect', 
				inputValue: '1', 
				checked: true
			},{
				boxLabel: '안한다', 
				width: 60, 
				name: 'rdoSelect', 
				inputValue: '2'
			}]
		},{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'hbox'
//				align: 'center',
//				pack:'center'
	    	},
	    	items:[{
	    		xtype: 'button',
	    		text: '실행',
	    		width: 60,
	    		margin: '10 0 0 120',
	    		handler : function() {
					panelSearch.getEl().mask('로딩중...','loading-indicator');

					var param = panelSearch.getValues();
                    param.LANG_TYPE = UserInfo.userLang;

                    agc330ukrService.procButton(param, function(provider, response) {
                        if(!Ext.isEmpty(provider) && Ext.isEmpty(provider.ERROR_DESC)) {  
                            UniAppManager.updateStatus("결산이월작업이 완료 되었습니다.");
                            panelSearch.setValue('DVRY_DATE_FR', provider.S_RET_FR_DATE);
                            panelSearch.setValue('DVRY_DATE_TO', provider.S_RET_TO_DATE);
                        }
                        console.log("response",response)
                        panelSearch.getEl().unmask();
                    });
   				}
	    	},{
	    		xtype: 'button',
	    		text: '취소',
	    		width: 60,
	    		margin: '10 0 0 0',                                                       
	    		handler : function() {
					panelSearch.getEl().mask('로딩중...','loading-indicator');

					var param = panelSearch.getValues();
					param.LANG_TYPE = UserInfo.userLang;

					agc330ukrService.cancButton(param, function(provider, response) {
                        if(!Ext.isEmpty(provider) && Ext.isEmpty(provider.ERROR_DESC)) {  
                            UniAppManager.updateStatus("취소가 완료 되었습니다.");
                            panelSearch.setValue('DVRY_DATE_FR', provider.S_RET_FR_DATE);
                            panelSearch.setValue('DVRY_DATE_TO', provider.S_RET_TO_DATE);
                        }
                        console.log("response",response)
                        panelSearch.getEl().unmask();
                    });
   				}
	    	}]
	    }]		
	});  
	
	
	var textForm = Unilite.createSearchForm('textForm', {
		region: 'south',
        defaultType: 'uniSearchSubPanel',
        collapseDirection: 'bottom',
        border: true,
        collapsible: true,
        padding: '1 1 1 1',
		items: [{
			padding: '5 5 0 5',
			xtype: 'container',
			html: '</br><b>※ 결산실행방법</b></br></br>'+
				  ' 1) 전표일이 결산할 회계기간인지 확인합니다. 예)2004년 1월 1일 ~ 2004년 12월 31일</br></br>'+
				  ' 2) 시스템을 처음 도입할 때는 기초잔액에서 전기이월이익잉여금이나 전기이월결손금으로 등록합니다.</br></br>',
			style: {
				color: 'blue'				
			}	  
		},{
			padding: '0 5 0 5',
			xtype: 'container',
			html: ' 3) 실행 한 번으로 손익계산서계정과 대차대조표계정이 동시에 마감됩니다.</br></br>',
			style: {
				color: 'red'				
			}	  
		},{
			padding: '0 5 0 5',
			xtype: 'container',
			html: ' 4) 차기이월계정분개를 한다. 를 선택하면 처분전이익잉여금 계정은 차기이월이익잉여금 계정에 대체 분개됩니다.</br></br>'+
				  ' &nbsp&nbsp&nbsp&nbsp차기이월계정분개를 안한다. 를 선택하면 다음 회계년도에 이익잉여금 처분 후 전기이월이익잉여금 대체분개를 직접 전표처리하셔야 됩니다.</br></br>'+
				  ' 5) 전표일이 다음 회계기간으로 자동으로 바뀝니다. 예)2005년 1월 1일 ~ 2005년 12월 31일</br></br>'+
				  '</br><b>※ 결산취소방법</b></br></br>'+
				  ' 1) 전표일이 결산이월을 취소할 회계기간인지 확인합니다. 예)2005년 1월 1일 ~ 2005년 12월 31일</br></br>',
			style: {
				color: 'blue'				
			}	  
		},{
			padding: '0 5 0 5',
			xtype: 'container',
			html: ' 2) 실행 한 번으로 손익계산서계정과 대차대조표계정이 동시에 마감취소됩니다.</br></br>',
			style: {
				color: 'red'				
			}	  
		},{
			padding: '0 5 5 5',
			xtype: 'container',
			html: ' 3) 전표일이 이전 회계기간으로 자동으로 바뀝니다. 예)2004년 1월 1일 ~ 2004년 12월 31일</br></br>',
			style: {
				color: 'blue'				
			}	  
		}]
	});     
	
	
    Unilite.Main( {
		items:[panelSearch,textForm],
		id  : 'agc330ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);

            panelSearch.getField('DVRY_DATE_FR').setReadOnly(true);
            panelSearch.getField('DVRY_DATE_TO').setReadOnly(true);
		}
	});

};
</script>
