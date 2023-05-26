<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hpa600ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	//년월차구분 store
	Ext.create('Ext.data.Store', {
		storeId:"provType",
	    fields: ['text', 'value'],
	    data : [
	        {text:"년차",   value:"F"},
	        {text:"월차", 	value:"G"}
	    ]
	});
	
	//재직형태 store
	Ext.create('Ext.data.Store', {
		storeId:"joinType",
	    fields: ['text', 'value'],
	    data : [
	        {text:"재직자",   value:"J"},
	        {text:"퇴직자", 	value:"R"}
	    ]
	});
	/**
	 * 수주등록 Master Form
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createForm('hpa600ukrDetail', {
    	disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
        defaults: {labelWidth: 140},
	    items :[{	
			fieldLabel: '지급년월',
	        xtype: 'uniMonthfield',
	        name: 'YEAR_YYYYMM',
	        allowBlank: false
        },{
        	fieldLabel: '년월차구분',
        	name: 'YEAR_TYPE',
        	xtype:'uniCombobox',
        	store: Ext.data.StoreManager.lookup( 'provType'),
        	allowBlank:false	        	
        },{
			fieldLabel: '지급일',
			name: 'SUPP_DATE',
			xtype:'uniDatefield',
			allowBlank:false,			
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {					
					
				}
			}
	     },{ 
			fieldLabel: '사업장',
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
//                'onValueFieldChange': function(field, newValue, oldValue  ){
//                    	panelResult.setValue('DEPT',newValue);
//                },
//                'onTextFieldChange':  function( field, newValue, oldValue  ){
//                    	panelResult.setValue('DEPT_NAME',newValue);
//                },
//                'onValuesChange':  function( field, records){
//                    	var tagfield = panelResult.getField('DEPTS') ;
//                    	tagfield.setStoreData(records)
//                }
			}
		}),{
        	fieldLabel: '급여지급방식',
        	name: 'PAY_CODE',
        	xtype:'uniCombobox',
        	comboType:'AU',
        	comboCode:'H028'	        	
        },{
        	fieldLabel: '지급차수',
        	name: 'PAY_PROV_FLAG',
        	xtype:'uniCombobox',
        	comboType:'AU',
        	comboCode:'H031'	        	
        },{
        	fieldLabel: '고용형태',
        	name: 'EMP_CODE',
        	xtype:'uniCombobox',
        	comboType:'AU',
        	comboCode:'H011'	        	
        },{
        	fieldLabel: '재직형태',
        	name: 'JOIN_RETR',
        	xtype:'uniCombobox',
        	store: Ext.data.StoreManager.lookup( 'joinType')      	
        },{
			fieldLabel: '기준일',
			name: 'ANN_DATE',
			xtype:'uniDatefield',			
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {					
					
				}
			}
	    },
			Unilite.popup('Employee', { 
			fieldLabel: '사원', 
			valueFieldName: 'PERSON_NUMB',
	   	 	textFieldName: 'NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {

                	},
					scope: this
				},
				onClear: function(type)	{
					
				},
				applyextparam: function(popup){							
				
				}
			}
		}), {
    		xtype: 'radiogroup',		            		
    		fieldLabel: '세금계산여부',
    		items: [{
    			boxLabel: '계산함',
    			width: 80,
    			name: 'CALC_TAX',
    			inputValue: 'Y'
    		}, {
    			boxLabel: '계산안함',
    			width: 80,
    			name: 'CALC_TAX',
    			inputValue: 'N'
    		}],
    		listeners: {
				change: function(field, newValue, oldValue, eOpts){
											
				}
			} 
        }, {
    		xtype: 'radiogroup',		            		
    		fieldLabel: '고용보험계산여부',
    		items: [{
    			boxLabel: '계산함',
    			width: 80,
    			name: 'HIR_CALCU_Y',
    			inputValue: 'Y'
    		}, {
    			boxLabel: '계산안함',
    			width: 80,
    			name: 'HIR_CALCU_Y',
    			inputValue: 'N'
    		}],
    		listeners: {
				change: function(field, newValue, oldValue, eOpts){
										
				}
			} 
        }, {
    		xtype: 'checkbox',	
    		boxLabelAlign : "before",
    		boxLabel: '<span style="padding-left:20px;">&nbsp;</span>당해년도 퇴직자 포함',
			width: 160,
    		name: 'INC_RETR_Y',
    		inputValue: 'Y',
			listeners : {
				change : function(field, newValue, oldValue) {
					if(newValue)	{
						panelSearch.setValue("RETR_CALC_TAX","Y");
						panelSearch.setValue("RETR_HIR_CALCU_Y","Y");
						
						panelSearch.down("#RETR_CALC_TAX_Y").setReadOnly(false);
						panelSearch.down("#RETR_CALC_TAX_N").setReadOnly(false);
						panelSearch.down("#RETR_HIR_CALCU_Y_Y").setReadOnly(false);
						panelSearch.down("#RETR_HIR_CALCU_Y_N").setReadOnly(false);
					} else {
		    			panelSearch.setValue("RETR_CALC_TAX","N");
						panelSearch.setValue("RETR_HIR_CALCU_Y","N");
						panelSearch.down("#RETR_CALC_TAX_Y").setReadOnly(true);
						panelSearch.down("#RETR_CALC_TAX_N").setReadOnly(true);
						panelSearch.down("#RETR_HIR_CALCU_Y_Y").setReadOnly(true);
						panelSearch.down("#RETR_HIR_CALCU_Y_N").setReadOnly(true);
					}
				}
			}
        }, {
    		xtype: 'radiogroup',		            		
    		fieldLabel: '퇴작자 세금계산여부',
    		items: [{
    			boxLabel: '계산함',
    			width: 80,
    			name: 'RETR_CALC_TAX',
    			itemId : 'RETR_CALC_TAX_Y',
    			inputValue: 'Y'
    		}, {
    			boxLabel: '계산안함',
    			width: 80,
    			name: 'RETR_CALC_TAX',
    			itemId : 'RETR_CALC_TAX_N',
    			inputValue: 'N'
    		}],
    		listeners: {
				change: function(field, newValue, oldValue, eOpts){
											
				}
			} 
        }, {
    		xtype: 'radiogroup',		            		
    		fieldLabel: '퇴직자 고용보험계산여부',
    		items: [{
    			boxLabel: '계산함',
    			width: 80,
    			name: 'RETR_HIR_CALCU_Y',
    			itemId : 'RETR_HIR_CALCU_Y_Y',
    			inputValue: 'Y'
    		}, {
    			boxLabel: '계산안함',
    			width: 80,
    			name: 'RETR_HIR_CALCU_Y',
    			itemId : 'RETR_HIR_CALCU_Y_N',
    			inputValue: 'N'
    		}],
    		listeners: {
				change: function(field, newValue, oldValue, eOpts){
										
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
	    			if(!panelSearch.getInvalidMessage()){
						return false;
					}
					var param = panelSearch.getValues();
					Ext.getBody().mask('로딩중...','loading-indicator');
					hpa600ukrService.spStart(param, function(provider, response)	{						
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);
						}
						Ext.getBody().unmask();
					});	
					
	    		}
	    	}]
	    }],
	setAllFieldsReadOnly: function(b) {
		var r= true
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
																return !field.validate();
															});
   			if(invalid.length > 0) {
				r=false;
  				var labelText = ''
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   				}
		   		alert(labelText+Msg.sMB083);
				invalid.items[0].focus();
			} else {
				//this.mask();		    
   			}
	  	} else {
			this.unmask();
		}
		return r;
	}
     ,api: {
     		 load: 'hpa600ukrService.selectMaster',
			 submit: 'hpa600ukrService.syncMaster'				
			}
	, listeners : {
			dirtychange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
//					UniAppManager.setToolbarButtons('save', true);
			},
			beforeaction:function(basicForm, action, eOpts)	{
				console.log("action : ",action);
				console.log("action.type : ",action.type);
				if(action.type =='directsubmit')	{
					var invalid = this.getForm().getFields().filterBy(function(field) {
					            return !field.validate();
					    });
			        	
		         	if(invalid.length > 0)	{
			        	r=false;
			        	var labelText = ''
			        	
			        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
			        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
			        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
			        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
			        	}
			        	alert(labelText+Msg.sMB083);
			        	invalid.items[0].focus();
			        }																									
				}
			}	
		}
	});

    /**
	 * main app
	 */
    Unilite.Main( {
    		 id  : 'hpa600ukrApp',
			 items 	: [ panelSearch],
			 fnInitBinding : function() {
				this.setDefault()
				this.setToolbarButtons(['newData','reset', 'query'],false);
			},
			setDefault: function(){
				panelSearch.setValue('YEAR_YYYYMM', UniDate.get('today'));
				//panelSearch.setValue('PAY_YYYY', '');	//현재 년도set
				panelSearch.setValue('SUPP_DATE', UniDate.get('today'));
				panelSearch.setValue('DIV_CODE', UserInfo.divCode);
				panelSearch.setValue('YEAR_TYPE', 'F');
				panelSearch.getField('CALC_TAX').setValue('Y');
				panelSearch.getField('HIR_CALCU_Y').setValue('Y');
				panelSearch.getField('INC_RETR_Y').setValue(true);
				panelSearch.getField('RETR_CALC_TAX').setValue('Y');
				panelSearch.getField('RETR_HIR_CALCU_Y').setValue('Y');
				panelSearch.onLoadSelectText('YEAR_YYYYMM');
			}
            
		});
}
</script>
