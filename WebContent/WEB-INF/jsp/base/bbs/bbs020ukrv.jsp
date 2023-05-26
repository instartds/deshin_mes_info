<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bbs020ukrv"  >
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
	
	var bbs020ukrvStore = Ext.create('Ext.data.Store',{
		storeId: 'bbs020ukrvCombo',
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

    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	activeGroup: 0,
	    	collapsible:true,
	    	cls:'human-panel',
	    	items: [{
				items:[{
					title:'<t:message code="system.label.base.dataformatform" default="입력데이터형태설정"/>',
					itemId: 'dataFormatForm',
					xtype: 'uniDetailForm',
					bodyCls: 'human-panel-form-background',
					disabled:false,
				    border:0,
					layout: {tyep: 'hbox', align: 'stretch'},
					defaults: {
						labelWidth:150
					},
					margin: '10 10 10 10',
					items:[{					
							fieldLabel: '<t:message code="system.label.base.qty" default="[수량]"/>',
							name: 'FORMAT_QTY2',
							xtype: 'uniCombobox',
							store: Ext.data.StoreManager.lookup('bbs020ukrvCombo')		
						}, {					
							fieldLabel: '<t:message code="system.label.base.price" default="단가"/>',
							name: 'FORMAT_PRICE2',
							xtype: 'uniCombobox',
							store: Ext.data.StoreManager.lookup('bbs020ukrvCombo')				
						}, {					
							fieldLabel: '<t:message code="system.label.base.countrycurrencyamount" default="자국화폐금액"/>',
							name: 'FORMAT_IN2',
							xtype: 'uniCombobox',
							store: Ext.data.StoreManager.lookup('bbs020ukrvCombo')				
						}, {					
							fieldLabel: '<t:message code="system.label.base.foreigncurrencyamount1" default="외화화폐금액"/>',
							name: 'FORMAT_OUT2',
							xtype: 'uniCombobox',
							store: Ext.data.StoreManager.lookup('bbs020ukrvCombo')			
						}, {					
							fieldLabel: '<t:message code="system.label.base.exchangerate" default="환율"/>',
							name: 'FORMAT_RATE2',
							xtype: 'uniCombobox',
							store: Ext.data.StoreManager.lookup('bbs020ukrvCombo')			
						
						}
					],
					api: {
		         		 load: 'bbs020ukrvService.select',
						 submit: 'bbs020ukrvService.save'				
					},
					listeners : {
						dirtychange:function( basicForm, dirty, eOpts ) {
							UniAppManager.setToolbarButtons('save', true);
						}
					}
				}]
			}]
	    }]
    })
	
	 Unilite.Main( {
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'bbs020ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown : function()	{		
			panelDetail.down('#dataFormatForm').getForm().load();
		},
		onSaveDataButtonDown: function (config) {
				var form = panelDetail.down('#dataFormatForm');
				var param= form.getValues();
				form.getForm().submit({
						 params : param,
						 success : function(actionform, action) {
			 					form.getForm().wasDirty = false;
								form.resetDirtyStatus();											
								UniAppManager.setToolbarButtons('save', false);	
			            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
						 }	
				});
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
