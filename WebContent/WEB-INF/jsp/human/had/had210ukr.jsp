<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had210ukr"  >
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	
	var panelSearch = Unilite.createForm('had210ukrDetail', {		
    	  disabled :false
    	, id: 'searchForm'
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
        , defaults: {labelWidth: 100}
	    , items :[{
			fieldLabel: '급여지급년도',
			name: 'PAY_YYYY',
			xtype: 'uniYearField',
			value: UniHuman.getTaxReturnYear(),
			allowBlank: false
		},
         	Unilite.popup('Employee',{
								
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type)	{
				}
			}
         }),{
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
	    		handler: function(){
	    			var param = panelSearch.getValues();
	    			param.MONTHS = [1,2,3,4,5,6,7,8,9,10,11,12];
	    			panelSearch.getEl().mask('로딩중...','loading-indicator');
	    			had210ukrService.doBatch(param, function(provider, response)	{
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);
						}
						panelSearch.getEl().unmask();
					});
	    		}
	    	}]
	    }]      
	});
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	
    Unilite.Main( {
		items:[
	 		 panelSearch
		],
		id  : 'had210ukrApp',
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['reset', 'query'], false);
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
                this.processParams(params);
			}
		},
		//링크로 넘어오는 params 받는 부분 
        processParams: function(params) {
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'hpe100ukr') {
            	panelSearch.setValue('PAY_YYYY'			,params.YEAR_YYYY);
            }
        }
	});

};


</script>
