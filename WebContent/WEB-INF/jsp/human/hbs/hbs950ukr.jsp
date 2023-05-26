<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hbs950ukr"  >
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	var colData = "${colData}";
	
	var panelSearch = Unilite.createForm('hbs950ukrDetail', {		
    	  disabled :false
    	, id: 'searchForm'
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
        , defaults: {labelWidth: 100}
	    , items :[{
			fieldLabel: '최종마감',
			name: 'OLD_YYYY',
    		xtype: 'uniYearField',
    		readOnly: true
		},{
			fieldLabel: '마감',
			name: 'NOW_YYYY',
    		xtype: 'uniYearField',
    		minValue: '2015',
   			maxValue: '2050',
    		allowBlank: false,
    		value:  Ext.Date.format(UniDate.get('today'), 'Y')//UniDate.extSafeParse(UniDate.get('today'), 'm') > '03' ? UniDate.extSafeParse(UniDate.get('today'), 'Y') :  UniDate.extSafeParse(UniDate.get('startOfLastYear'), 'Y')
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: ' ',						            		
			id: 'rdoSelect1',
			items: [{
				boxLabel: '마감', 
				width: 70, 
				name: 'rdoSelect1',
				inputValue: 'Y',
				checked: true
			},{
				boxLabel : '취소', 
				width: 70,
				name: 'rdoSelect1',
				inputValue: 'N' 
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					if(newValue.rdoSelect1 == 'Y'){
						var oldYYYY = panelSearch.getValue('OLD_YYYY');
						panelSearch.setValue('NOW_YYYY', UniDate.add(UniDate.extParseDate(oldYYYY + '0101'), {years: +1}).getFullYear());
					}else{
						panelSearch.setValue('NOW_YYYY', panelSearch.getValue('OLD_YYYY'));
					}					
				}
			}
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
	    		handler: function(){
	    			var param = panelSearch.getValues();
	    			if(panelSearch.getField('rdoSelect1').getValue().rdoSelect1 == "Y"){	//마감
	    				if(confirm(Msg.sMB383)) {	//마감을 실행 시키겠습니까?
	    					panelSearch.getEl().mask('로딩중...','loading-indicator');
			    			hbs950ukrService.doBatch(param, function(provider, response)	{
								if(provider){
									UniAppManager.updateStatus(Msg.sMB011);
									date(false, false);
								}
								panelSearch.getEl().unmask();
							});	
	    				}	    				
	    			}else{	//취소
	    				if(confirm(Msg.sMB384)) {	//마감을 취소하겠습니까?
	    					var nowYYYY = panelSearch.getValue('NOW_YYYY');
		    				param.NOW_YYYY = UniDate.add(UniDate.extParseDate(nowYYYY + '0101'), {years: -1}).getFullYear();
		    				panelSearch.getEl().mask('로딩중...','loading-indicator');
			    			hbs950ukrService.doBatch(param, function(provider, response)	{
								if(provider){
									UniAppManager.updateStatus(Msg.sMB011);
									date(false, true);	
								}
								panelSearch.getEl().unmask();
							});
						}
	    			}
	    			
	    		}
	    	}]
	    }]      
	});
	
	function date(init, cancel) {
		if(init){	//초기화
			var oldYYYY = panelSearch.getValue('OLD_YYYY');
			if(oldYYYY && oldYYYY != 0) {
				var nowYYYY = UniDate.add(UniDate.extParseDate(oldYYYY + '0101'), {years: +1}); 
				nowYYYY = nowYYYY.getFullYear();
				panelSearch.setValue('NOW_YYYY', nowYYYY);
			}
		}else{	//실행 버튼 후
			if(cancel){	//취소	
				var nowYYYY = panelSearch.getValue('NOW_YYYY');
				if(nowYYYY && nowYYYY != 0) {
					nowYYYY = UniDate.add(UniDate.extParseDate(nowYYYY + '0101'), {years: -1});
					panelSearch.setValue('OLD_YYYY', nowYYYY.getFullYear());
					panelSearch.setValue('NOW_YYYY', nowYYYY.getFullYear());
				}
			}else{	//마감
				var nowYYYY = panelSearch.getValue('NOW_YYYY');
				panelSearch.setValue('OLD_YYYY', nowYYYY);
				var oldYYYY = panelSearch.getValue('OLD_YYYY');
				if(oldYYYY && oldYYYY != 0) {
					var nowYYYY = UniDate.add(UniDate.extParseDate(oldYYYY + '0101'), {years: +1}); 
					nowYYYY = nowYYYY.getFullYear();
					panelSearch.setValue('NOW_YYYY', nowYYYY);
				}
			}
		}
		
		if(!Ext.isEmpty(panelSearch.getValue('NOW_YYYY')) && panelSearch.getValue('NOW_YYYY') != 0){
       		panelSearch.getField('NOW_YYYY').setReadOnly(true);
       }else{
       		panelSearch.getField('NOW_YYYY').setReadOnly(false);
       }
	}	   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	
    Unilite.Main( {
		items:[
	 		 panelSearch
		],
		id  : 'hbs950ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'query'], false);
			panelSearch.setValue('OLD_YYYY', colData);
			date(true,false);
		}
	});

};


</script>
			