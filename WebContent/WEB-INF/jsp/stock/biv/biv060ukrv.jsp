<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv060ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="S012" />	 <!-- 영업자동채번정보 -->
	<t:ExtComboStore comboType="AU" comboCode="S022" />	 <!-- 판매계획설정 -->
	<t:ExtComboStore comboType="AU" comboCode="S026" />	 <!-- 여신적용시점 -->
	<t:ExtComboStore comboType="AU" comboCode="S019" />	 <!-- 어음적용구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S028" />	 <!-- 부가세율 -->
	<t:ExtComboStore comboType="AU" comboCode="S025" />	 <!-- 미수잔액생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="S031" />	 <!-- 수주등록내 생산완료일 자동/수동여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S029" />	 <!-- 매출사업장지정 -->
	
	<t:ExtComboStore comboType="AU" comboCode="S033" />	 <!-- 출고 자동매출 생성삭제여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S034" />	 <!-- 반품 자동매출 생성삭제여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S035" />	 <!-- 매출 출고자동출고 생성삭제여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S038" />	 <!-- 매출 반품자동출고 생성삭제여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S044" />	 <!-- 수주승인 사용여부 -->	
	
	<t:ExtComboStore comboType="AU" comboCode="" /> <!--수량-->
	<t:ExtComboStore comboType="AU" comboCode="" /> <!--단가-->
	<t:ExtComboStore comboType="AU" comboCode="" /> <!--자국화폐금액-->
	<t:ExtComboStore comboType="AU" comboCode="" /> <!--외화화폐금액-->
	<t:ExtComboStore comboType="AU" comboCode="" /> <!--환율-->
</t:appConfig>

<style type= "text/css">
.x-grid-cell {
    border-left: 0px !important;
    border-right: 0px !important;
}
.x-tree-icon-leaf {
    background-image:none;
}
.search-hr {
	height: 1px;
	border: 0;
	color: #fff;
	background-color: #330;
	width: 98%;
}
.x-grid-item-focused  .x-grid-cell-inner:before {
    border: 0px; 
}
</style>
<script type="text/javascript" >       

function appMain() {     	
	var biv060ukrvStore = Ext.create('Ext.data.Store',{
		storeId: 'biv060ukrvCombo',
        fields:[
        	'value',
        	'text'
        ],
        data:[
        	{'value':'0' , text:'0'},
        	{'value':'1' , text:'0.9'},
        	{'value':'2' , text:'0.99'},
        	{'value':'3' , text:'0.999'},
        	{'value':'4' , text:'0.9999'},
        	{'value':'5' , text:'0.99999'},        	
        	{'value':'6' , text:'0.999999'}
        ]
	});	
	
    <%@include file="./biv060ukrvs1.jsp" %>	// 재고업무설정
	<%@include file="./biv060ukrvs2.jsp" %>	// 조회데이타포멧설정	

    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'biv060Tab',
	    	cls:'human-panel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [
				operating_Criteria,	  // 재고업무설정
				reference_Data  	  // 조회데이타포멧설정
	    	 ]
	    }]
    });	

	 Unilite.Main( {
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'biv060ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			var activeTab = panelDetail.down('#biv060Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_operating"){
				var param= panelDetail.down('#tab_operating').getValues();
				panelDetail.down('#tab_operating').getForm().load({
					
					params: param
				})		
			}else if(activeTab.getItemId() == "tab_format"){
				var param= panelDetail.down('#tab_format').getValues();
				panelDetail.down('#tab_format').getForm().load({
					
					params: param
				})
			}
		},
		onSaveDataButtonDown: function(config) {
			var activeTab = panelDetail.down('#biv060Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_operating"){
				var param= panelDetail.down('#tab_operating').getValues();
				panelDetail.down('#tab_operating').getForm().submit({
					 params : param,
						 success : function(actionform, action) {
		 					panelDetail.down('#tab_operating').getForm().wasDirty = false;
							panelDetail.down('#tab_operating').resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
		            		UniAppManager.updateStatus(Msg.sMB011);
		            		UniAppManager.app.onQueryButtonDown();
						 }
				});
			}else if(activeTab.getItemId() == "tab_format"){
				var param= panelDetail.down('#tab_format').getValues();
				panelDetail.down('#tab_format').getForm().submit({
					 params : param,
						 success : function(actionform, action) {
		 					panelDetail.down('#tab_format').getForm().wasDirty = false;
							panelDetail.down('#tab_format').resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
		            		UniAppManager.updateStatus(Msg.sMB011);
		            		UniAppManager.app.onQueryButtonDown();
						 }
				});
			}
		}
		
		
		
//			var activeTab = panelDetail.down('#aba060Tab').getActiveTab();
//
//			if (activeTab.getId() == 'tab_aba100ukr'){
//				var param= panelDetail.down('#tab_aba100ukr').getValues();
//				panelDetail.down('#tab_aba100ukr').getForm().submit({
//					 params : param,
//						 success : function(actionform, action) {
//		 					panelDetail.down('#tab_aba100ukr').getForm().wasDirty = false;
//							panelDetail.down('#tab_aba100ukr').resetDirtyStatus();											
//							UniAppManager.setToolbarButtons('save', false);	
//		            		UniAppManager.updateStatus(Msg.sMB011);
//		            		UniAppManager.app.onQueryButtonDown();
////		            		alert("변경된 데이타포맷을 적용하려면 프로그램 종료후 로그인을 다시 하셔야 합니다.");
//						 }
//				});
//			}		
		
	});
};


</script> 