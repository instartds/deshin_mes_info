<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mba020ukrv">
		
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
	var mba020ukrvStore = Ext.create('Ext.data.Store',{
		storeId: 'mba020ukrvCombo',
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
	<%@include file="./mba020ukrvs1.jsp" %>	//구매자재기준설정
	<%@include file="./mba020ukrvs2.jsp" %>	//조회데이타포맷설정
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'mba020Tab',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [
	    	
				standard_Setup,	  // 구매자재기준설정
				format_Setup  	  // 조회데이타포멧설정
	    	 ]
	    }]
    });

	 Unilite.Main( {
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'mba020ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			var activeTab = panelDetail.down('#mba020Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_standard"){
				var param= panelDetail.down('#tab_standard').getValues();
				panelDetail.down('#tab_standard').getForm().load({
					
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
			var activeTab = panelDetail.down('#mba020Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_standard"){
				var param= panelDetail.down('#tab_standard').getValues();
				panelDetail.down('#tab_standard').getForm().submit({
					 params : param,
						 success : function(actionform, action) {
		 					panelDetail.down('#tab_standard').getForm().wasDirty = false;
							panelDetail.down('#tab_standard').resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
		            		UniAppManager.updateStatus(Msg.sMB011);
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
						 }
				});
			}
		}
//		loadTabData: function(tab, itemId, mainCode){
//			//tab.down('#'+itemId).getStore().loadStoreRecords({'MAIN_CODE':mainCode});
//				//panelDetail.down('#sbs010ukrvs_4Store').load();
//
//				tab.getForm().load();
//
//		}
	});
};


</script>
