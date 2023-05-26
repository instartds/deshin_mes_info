<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="agb170rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 	
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!--비용상태-->	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var getStDt = ${getStDt};
	var getChargeCode = ${getChargeCode};
	/**
	 *   Model 정의 
	 * @type 
	 */

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */ 
    
	var panelSearch = Unilite.createSearchForm('resultForm', {		
		region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{	
    			fieldLabel: '비용처리년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'FR_MONTH',
		        endFieldName: 'TO_MONTH',
		        startDate:UniDate.get('startOfMonth'),
		        endDate: UniDate.get('endOfMonth'),
		        width: 325,
		        //startDate: UniDate.get('startOfMonth'),
		        //endDate: UniDate.get('today'),
		        allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    }
	        },{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			},		    
		    	Unilite.popup('COST',{
		    	fieldLabel: '기간비용',
	//	    	validateBlank:false,
		    	autoPopup:false,
		    	valueFieldName: 'COST_CODE_FR',
		    	textFieldName: 'COST_NAME_FR',
				listeners: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
   	 		}),		    
		    	Unilite.popup('COST',{
		    	fieldLabel: '~',
	//	    	validateBlank:false,	
		    	autoPopup:false,
				valueFieldName: 'COST_CODE_TO',
		    	textFieldName: 'COST_NAME_TO',  			
				listeners: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
	    	}),{
    			fieldLabel: '비용상태'	,
    			name:'COST_STS', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A035',
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
		}, 		    
		        Unilite.popup('DEPT',{
		        fieldLabel: '부서',
		        validateBlank:false,
		        autoPopup:false,
		        valueFieldName: 'DEPT_CODE_FR',
		    	textFieldName: 'DEPT_NAME_FR'
		    }),
		      	Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        validateBlank:false,
		        autoPopup:false,
		        valueFieldName: 'DEPT_CODE_TO',
		    	textFieldName: 'DEPT_NAME_TO'
		    }),{
             	xtype:'button',
             	text:'출    력',
             	width:235,
             	tdAttrs:{'align':'center'},
             	handler:function()	{
             		UniAppManager.app.onPrintButtonDown();
             	}
            }]		
	});    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelSearch
			]
		}
		],
		id  : 'agb170rkrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
			
			panelSearch.setValue('FR_MONTH',getStDt[0].STDT);		
			panelSearch.setValue('TO_MONTH',UniDate.get('today'));
			
			var activeSForm ;
				activeSForm = panelSearch;
			activeSForm.onLoadSelectText('FR_MONTH');
			
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();	
			}	
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function() {	
			
			//add by chenaibo  20161129
			var divName     = '';
		   if(panelSearch.getValue('ACCNT_DIV_CODE') == '' || panelSearch.getValue('ACCNT_DIV_CODE') == null ){
		 	 divName = Msg.sMAW002;  // 전체
		   }else{
		 	 divName = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
		   }
		 
			var params 	 = Ext.getCmp('resultForm').getValues();
			params["ACCNT_DIV_NAME"] = divName;
			var prgId 		 = 'agb170rkr';
			var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/agb/agb170rkr.do',
	            prgID: prgId,
	               extParam:params
	            });
	            win.center();
	            win.show();
		}
		
	});
};


</script>
