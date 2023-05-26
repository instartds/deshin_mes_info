<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_hpa900skr_jw"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->   
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" />		<!-- 신고사업장 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('s_hpa900skr_jwForm', {
		region: 'center',
    	disabled :false,
    	border: false,
    	flex:1,
    	layout: {
	    	type: 'uniTable',
			columns:1
	    },
	    defaults:{
	    	width:325,
			labelWidth:90
	    },
		defaultType: 'uniTextfield',
		padding:'20 0 0 0',
		width:400,
	    items :[{
                fieldLabel: '기준년월',
                xtype: 'uniMonthfield',
                name: 'BASE_DATE',
                labelWidth:90,
                value: new Date(),
                allowBlank: false,
                listeners: {
                      change: function(field, newValue, oldValue, eOpts) {  
                      }
                }
            },{
    			fieldLabel: '사업장',
    			id: 'DIV_CODE', 
    			name: 'DIV_CODE', 
    			xtype: 'uniCombobox',
    			comboType: 'BOR120'
    			//allowBlank: false
    		},Unilite.popup('DEPT',{
    		        fieldLabel: '부서',
    			    valueFieldName:'DEPT_CODE',
    			    textFieldName:'DEPT_NAME',
    			    itemId:'DEPT_CODE',
        			autoPopup: true
    	    }),
    		Unilite.popup('Employee',{
    			fieldLabel: '사원',
    		  	valueFieldName:'PERSON_NUMB',
    		    textFieldName:'NAME',
    			validateBlank:false,
    			autoPopup:true,
    			id : 'PERSON_NUMB', 
    			listeners: {
    			}
    		}),
    		{
             	xtype:'button',
             	text:'출    력',
             	width:235,
             	tdAttrs:{'align':'center', style:'padding-left:95px'},
        		handler:function()	{
             		UniAppManager.app.onPrintButtonDown();
             	}
             }
    	    ]		
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
 
    Unilite.Main( {
		items 	: [ panelSearch],
		id  : 's_hpa900skr_jwApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ST_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',false);
		},
		onQueryButtonDown : function()	{			
			
				/*masterGrid1.getStore().loadStoreRecords();
				var viewLocked = masterGrid1.lockedGrid.getView();
				var viewNormal = masterGrid1.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/				
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
			if(!panelSearch.getInvalidMessage()) return;   
			var param= panelSearch.getValues();
			var win = Ext.create('widget.CrystalReport', {
				url: CPATH+'/z_jw/s_hpa900cskrv_jw.do',
				prgID: 's_hpa900skr_jw',
					extParam: param
				});
			win.center();
			win.show();   				
		}
	});

};


</script>
			