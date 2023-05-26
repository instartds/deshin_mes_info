<%@page language="java" contentType="text/html; charset=utf-8"%>
 <t:appConfig pgmId="hum101ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H034" /> <!-- 지급구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

function appMain() {
	
	var hum101InsuranceStore = Ext.create('Ext.data.Store',{
		storeId: 'hum101ukrInsuranceCombo',
        fields:[
        	'value',
        	'text'
        ],
        data:[
        	{'value':'1' , text:'국민연금'},
        	{'value':'2' , text:'건강보험'},
        	{'value':'3' , text:'고용보험'}
        ]
	});
	
	
	var panelSearch = Unilite.createForm('searchForm', {		
    	  disabled :false
    	, id: 'searchForm'
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
        , defaults: {labelWidth: 100}
	    , items :[{ 
			fieldLabel: '세액년도',
			xtype: 'uniYearField',
			value: new Date().getFullYear(),
		    id: 'BASE_YEAR',
		    name: 'BASE_YEAR'
		 }, {	
			 fieldLabel: '보험구분',
			 name:'CLOSE_TYPE', 
			 id:'CLOSE_TYPE', 
			 xtype: 'uniCombobox',
			 store: Ext.data.StoreManager.lookup('hum101ukrInsuranceCombo')
		},{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'vbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[{
	    		width : 100,
	    		xtype: 'button',
	    		text: '실행',
	    		handler: function(btn){
	    			var param = panelSearch.getValues();
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					
					hum101ukrService.doBatch(param, function(provider, response)	{
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);
						}
						panelSearch.getEl().unmask();
					});
				}
	    	}]
	    }]      
	});

	   Unilite.Main( {
			items:[
		 		 panelSearch
			],
			id  : 'hum101ukrApp',
			fnInitBinding : function() {
				
				panelSearch.onLoadSelectText('BASE_YEAR');
				UniAppManager.setToolbarButtons(['reset', 'query'], false);

			}
		});

	};


</script>
