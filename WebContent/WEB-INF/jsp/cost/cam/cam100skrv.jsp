<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cam100skrv"  >
	<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.cam100-td {
	background-color:#FFF;
	border-bottom: #c3c3c3 solid 1px;
}
</style>
<script type="text/javascript" >
function appMain() {
	
	/**
	 * 작업조건 (Search Panel)
	 * @type 
	 */
	
	
    var centerContainer = {
    	xtype:'panel',
    	region:'center',
    	layout: 'border' ,
    	style:{'background-color':'#FFF'},
    	flex:1,
    	//title:'작업결과보기',
    	
		items:[
			{
				xtype:'container',				
    			region:'center',
    			autoScroll:true,
    			flex:1,
    			width:"100%",
    			layout:{type:'hbox', align:'stretch'},
    			style:{'background-color':'#fff'},
    			items:[
    				{
    					xtype:'component',
    					width:1100,
    					style:{'background-color':'#fff'},
    					html:	'<image src="<c:url value="/resources/process/cam100skrv2.png" />" usemap="#cam100skrvmap"/ border="1">'+
    							'<map name="cam100skrvmap">'+
    							'	<area shape="rect" coords="215,55,315,85"  		title="직접재료비 품목별 부과현황(1단계)"  	href="javascript:UniAppManager.app.openLink(\'cam400skrv\', true)"/>'+
								'	<area shape="rect" coords="35,470,134,500"  	title="제조간접비 부문별 전표 입력(수동)"  	href="javascript:UniAppManager.app.openLink(\'cam350ukrv\', true)"/>'+
								'	<area shape="rect" coords="215,480,315,505"  	title="제조간접비 부문별 집계현황(2단계)"  	href="javascript:UniAppManager.app.openLink(\'cam310skrv\', true)"/>'+
								'	<area shape="rect" coords="225,595,335,620"  	title="(1차배부)제조간접비 배부기준등록"  	href="javascript:UniAppManager.app.openLink(\'cbm130ukrv\', true)"/>'+
								'	<area shape="rect" coords="225,655,325,685" 	title="(1차배부)사용자정의 배부율등록"  	href="javascript:UniAppManager.app.openLink(\'cam030ukrv\', true)"/>'+
								'	<area shape="rect" coords="460,275,570,305"		title="제조간접비 보조부문 배부결과(3단계)"  	href="javascript:UniAppManager.app.openLink(\'cam315skrv\', true)"/>'+
								'	<area shape="rect" coords="605,55,715,80"		title="품목별 원가집계표"  				href="javascript:UniAppManager.app.openLink(\'cam450skrv\', true)"/>'+
								'	<area shape="rect" coords="725,55,830,80"		title="원가수불부 조회"  				href="javascript:UniAppManager.app.openLink(\'cdr400skrv\', false)"/>'+
								'	<area shape="rect" coords="840,55,945,80"		title="작업지시별 원가집계표"  			href="javascript:UniAppManager.app.openLink(\'cam460skrv\', false)"/>'+
								'	<area shape="rect" coords="720,455,830,480"		title="제조간접비 품목별 배부결과(4단계)"	href="javascript:UniAppManager.app.openLink(\'cam010skrv\', true)"/>'+
								'	<area shape="rect" coords="690,600,790,630" 	title="보조부문 제조배부율 등록" 			href="javascript:UniAppManager.app.openLink(\'cbm140ukrv\', true)"/>'+
								'	<area shape="rect" coords="690,655,800,685" 	title="보조부문 제조배부율 집계현황"  		href="javascript:UniAppManager.app.openLink(\'cam020skrv\', true)"/>'+
								'	<area shape="rect" coords="900,485,1000,510" 	title="원가업무설정"  					href="javascript:UniAppManager.app.openLink(\'cbm100ukrv\', false)"/>'+
								'	<area shape="rect" coords="900,535,1000,560" 	title="부문정보 등록"					href="javascript:UniAppManager.app.openLink(\'cbm700ukrv\', true)"/>'+
								'	<area shape="rect" coords="900,590,1000,615" 	title="부문별-부서 매핑정보 등록"			href="javascript:UniAppManager.app.openLink(\'cbm710ukrv\', true)"/>'+
								'	<area shape="rect" coords="900,640,1000,665" 	title="부문별-작업장 매핑정보 등록"			href="javascript:UniAppManager.app.openLink(\'cbm720ukrv\', true)"/>'+
								'</map>'
						
    				}
				]
			}
		]
	}

    Unilite.Main( {
		id: 'cam100ukrvApp',
		borderItems: [centerContainer],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['query'], false);
			UniAppManager.setToolbarButtons(['detail',  'reset'], false);
		},
		onQueryButtonDown:function(){
		},
		openLink:function(pgmId, hasParams){
			var rec = {'data' : {'prgID' : pgmId, 'text':''}};
			var url = '/cost/'+pgmId+'.do';
			/*  2021.07.05 연계 파라메터 삭제
				if(hasParams)	{
				var params = { 
					'DIV_CODE' :panelSearch.getValue("DIV_CODE"),
					'WORK_MONTH' :UniDate.getMonthStr( panelSearch.getValue("WORK_MONTH"))
				}
				parent.openTab(rec, url, params)
			} else { */
				parent.openTab(rec, url)
			//}
		}
    });

};
	
</script>