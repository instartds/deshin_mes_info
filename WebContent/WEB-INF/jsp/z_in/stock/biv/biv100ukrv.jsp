<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv100ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 	
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
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

		//biv100ukrvs1 Model
	Unilite.defineModel('biv100ukrvs1Model', {
	    fields: [{name: 'DIV_CODE' 		 		,text:'<t:message code="system.label.inventory.division" default="사업장"/>'		,type: 'string'},
				 {name: 'WH_CODE' 		 		,text:'<t:message code="system.label.inventory.warehouse" default="창고"/>'		,type: 'string'},
				 {name: 'ITEM_CODE' 	 		,text:'<t:message code="system.label.inventory.item" default="품목"/>'		,type: 'string'},
				 {name: 'ITEM_NAME' 	 		,text:'품명'			,type: 'string'},
				 {name: 'SPEC'		    		,text:'<t:message code="system.label.inventory.spec" default="규격"/>'			,type: 'string'},
				 {name: 'STOCK_UNIT' 	 		,text:'단위'			,type: 'string'},
				 {name: 'GOOD_STOCK_Q'  		,text:'양품량'		,type: 'string'},
				 {name: 'BAD_STOCK_Q' 	 		,text:'<t:message code="system.label.inventory.defect" default="불량"/>'			,type: 'string'},
				 {name: 'STOCK_Q' 		 		,text:'기초재고량'		,type: 'string'},
				 {name: 'AVERAGE_P' 	 		,text:'평균단가'		,type: 'string'},
				 {name: 'STOCK_I' 		 		,text:'기초금액'		,type: 'string'},
				 {name: 'BASIS_YYYYMM'  		,text:'<t:message code="system.label.inventory.applyyearmonth" default="반영년월"/>'		,type: 'string'}				 
			]
	});
	//biv100ukrvs1 store
	var biv100ukrvs1Store = Unilite.createStore('biv100ukrvs1Store',{
			model: 'biv100ukrvs1Model',
            autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: {
                type: 'direct',
                api: {
                	   read : 'hum100ukrService.familyList'
                }
            }            
            
	});
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [{
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					padding: '10 10 10 10'
				},
				items:[{
					title:'기초재고 등록',
					
					xtype: 'uniDetailForm',
					api: { load: 'aba050ukrService.select' },
					layout: 'border',
					items:[{
						region: 'west',
						xtype: 'uniSearchPanel',          
						title: '검색조건',         
						defaultType: 'uniSearchSubPanel',
						items: [{     
							title: '기본정보',   
							itemId: 'search_panel1',
							layout: {type: 'uniTable', columns: 1},
			           		defaultType: 'uniTextfield',
					   		items : [{					
			    				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			    				name:'DIV_CODE',
			    				xtype: 'uniCombobox',
			    				comboType:'BOR120',
			    				allowBlank:false
			    			}, {
				            	fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				            	name: 'TXT_WH_CODE',
				            	xtype: 'uniCombobox',
				            	store: Ext.data.StoreManager.lookup('whList'),
			    				allowBlank:false
				            }, {
				            	fieldLabel: '기초년월',
				            	name: '',
				            	xtype: 'uniTextfield',
				            	allowBlank: false
				            }, 
								Unilite.popup('DIV_PUMOK',{
								fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
								textFieldWidth: 170, 
								validateBlank: false
							}),{
								fieldLabel: 'EXCEL파일',
								xtype: 'filefield',
								name: '',
								allowBlank:false,
								buttonText: '찾아보기...'								
							}]
						}]		
					}, {
						region: 'center',
						xtype: 'uniGridPanel',
						
					    store : biv100ukrvs1Store,
					    uniOpt: {
					    	expandLastColumn: true,
					        useRowNumberer: true,
					        useMultipleSorting: false
						},		        
						columns: [{dataIndex: 'DIV_CODE' 		 		,		width: 200, hidden: true },					  	  
								  {dataIndex: 'WH_CODE' 		 		,		width: 133, hidden: true },					  	  
								  {dataIndex: 'ITEM_CODE' 	 			,		width: 133 },					  	  
								  {dataIndex: 'ITEM_NAME' 	 			,		width: 166 },					  	  
								  {dataIndex: 'SPEC'		    		,		width: 166 },					  	  
								  {dataIndex: 'STOCK_UNIT' 	 			,		width: 66 },					  	  
								  {dataIndex: 'GOOD_STOCK_Q'  			,		width: 100 },					  	  
								  {dataIndex: 'BAD_STOCK_Q' 	 		,		width: 100 },					  	  
								  {dataIndex: 'STOCK_Q' 		 		,		width: 100, hidden: true },					  	  
								  {dataIndex: 'AVERAGE_P' 	 			,		width: 100 },					  	  
								  {dataIndex: 'STOCK_I' 		 		,		width: 100, hidden: true },					  	  
								  {dataIndex: 'BASIS_YYYYMM'  			,		width: 66, hidden: true },
								  {dataIndex: 'UPDATE_DB_USER'			,		width: 66, hidden: true},
								  {dataIndex: 'UPDATE_DB_TIME'			,		width: 66, hidden: true},
								  {dataIndex: 'COMP_CODE'				,		width: 66, hidden: true}
								  
						]
					}]
				}]
			}]
	    }],
	    listeners: {
		       		beforetabchange: function ( grouptabPanel, newCard, oldCard, eOpts )	{
		       			if(Ext.isObject(oldCard))	{
			       			var personNum = oldCard.getValue('PERSON_NUMB');
			       			if(!Ext.isEmpty( personNum) )	{
				       			newCard.loadData(personNum);
								newCard.down('#EmpImg').setSrc(CPATH+'/resources/images/human/'+personNum+'.jpg');
			       			}
		       			}
		       		}
		       }
    })
	
    
	 Unilite.Main({
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'biv100ukrvApp',
		fnInitBinding : function() {			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'biv100ukrvGrid'){				
				directMasterStore1.loadStoreRecords();				
			}
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>
