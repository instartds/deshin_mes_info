<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="hpa970ukr"  >
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
	color: #333333;
	font-weight: normal;
	padding: 1px 2px;
}
</style>

<script type="text/javascript" >

function appMain() {

	/* 비과세수당일괄집계 Master Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('searchForm', {		
		disabled :false,
    	flex:1,
    	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
		items: [{
			xtype: 'uniYearField',
			fieldLabel: '귀속년도',
			name : 'THIS_YEAR',
			id : 'THIS_YEAR',
			value: new Date().getFullYear(),
			fieldStyle: 'text-align: center;',
	        tdAttrs: {width: 400},  
			allowBlank:false
	    },{
			margin : '0 0 5 40',
			xtype: 'container',
			html: '</br>1. 해당년도 근로소득원천징수영수증의 비과세소득 양식</br>&nbsp&nbsp&nbsp&nbsp으로 집계합니다.</br></br>'+
				  '2. 실행하기 전에  Configuration정보>인사급여업무설정></br>&nbsp&nbsp&nbsp&nbsp지급/공제코드등록의 비과세코드가 설정이 되었는지' +
				  '</br>&nbsp&nbsp&nbsp&nbsp확인해 주시기 바랍니다.<br></br>'

		},{
			xtype : 'button',
			text : '실행',
			width : 100,
			margin : '0 0 5 100',
			handler : function(btn) {
			var detailform = panelSearch.getForm();
				if (detailform.isValid()) {
					var month, monthOfThisYear = [];
					for (var i=1; i<13; i++) {	
						month = (i < 10 ? '0' + i : '' + i)
						monthOfThisYear.push(month)
					}
					var param = Ext.getCmp('searchForm').getValues();
					param.monthOfThisYear = monthOfThisYear
					hpa970ukrService.doBatch(param, function(provider, response)	{
						panelSearch.getEl().mask(Msg.fsbMsgH0245,'loading-indicator');
						if (provider){
		     				Ext.Msg.alert('확인', '작업이 완료되었습니다.');
						} 
						panelSearch.getEl().unmask();
					});
				}
			}
		}]
	});
	
    Unilite.Main({
		items : [ panelSearch ],
		id  : 'hpa970ukrApp',
		fnInitBinding : function() {
			//초기화 시 버튼 컨트롤
			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.onLoadSelectText('THIS_YEAR');
		}
	});

};


</script>
