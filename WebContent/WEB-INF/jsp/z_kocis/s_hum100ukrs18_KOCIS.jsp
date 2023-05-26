<%@page language="java" contentType="text/html; charset=utf-8"%>
var recommender = {
		title:'추천인',
		itemId: 'recommender',
        layout:{type:'vbox', align:'stretch'},	
        
        items:[ basicInfo,
        		{
	    			xtype: 'uniDetailForm',
	    			itemId: 'recommenderForm',
	    			bodyCls: 'human-panel-form-background',
	    			disabled: false,
	    			api: {
			         		 load: s_hum100ukrService_KOCIS.recommender,
			         		 submit: s_hum100ukrService_KOCIS.saveHum790
					},
	    			layout: {type:'uniTable', columns:'2'},
	    			margin:'0 10 0 10',
	        		padding:'0',
	        		defaults: {
	        					width:260,
	        					labelWidth:140 
	        		},
	        		flex:1,
	    			items: [{
			        	  	 	
							 	name:'PERSON_NUMB' ,
							 	hidden: true
							},{
								xtype:'component',
								html:'<center>[추천인1]</center>'
							},{
								xtype:'component',
								html:'<center>[추천인2]</center>'
							},{
			        	  	 	fieldLabel: '성명',
							 	name:'RECOMMEND1_NAME'  
							},{
			        	  	 	fieldLabel: '성명',
							 	name:'RECOMMEND2_NAME'  
							},{
			        	  	 	fieldLabel: '관계',
							 	name:'RECOMMEND1_RELATION',
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H020'   
							},{
			        	  	 	fieldLabel: '관계',
							 	name:'RECOMMEND2_RELATION',
							 	xtype: 'uniCombobox',
							 	comboType: 'AU', 
							 	comboCode: 'H020'   
							},{
			        	  	 	fieldLabel: '직장명',
							 	name:'RECOMMEND1_OFFICE_NAME'
							},{
			        	  	 	fieldLabel: '직장명',
							 	name:'RECOMMEND2_OFFICE_NAME'
							},{
			        	  	 	fieldLabel: '직위',
							 	name:'RECOMMEND1_CLASS'
							},{
			        	  	 	fieldLabel: '직위',
							 	name:'RECOMMEND2_CLASS'
							},
							Unilite.popup('ZIP',{
								fieldLabel: '주소',
								showValue:false,
								textFieldWidth:115,	
								textFieldName:'RECOMMEND1_ZIP_CODE',
								DBtextFieldName:'ZIP_CODE',
								validateBlank:false,
								listeners: { 'onSelected': {
							                    fn: function(records, type  ){
							                    	panelDetail.down('#recommenderForm').setValue('RECOMMEND1_ADDR', records[0]['ZIP_NAME']);
							                    	panelDetail.down('#recommenderForm').setValue('RECOMMEND1_ADDR_DE', records[0]['ADDR2']);
							                    },
							                    scope: this
							                  },
							                  'onClear' : function(type)	{
							                    	panelDetail.down('#recommenderForm').setValue('RECOMMEND1_ADDR', '');
							                    	panelDetail.down('#recommenderForm').setValue('RECOMMEND1_ADDR_DE', '');
							                  }
									}
							}),
							Unilite.popup('ZIP',{
								fieldLabel: '주소',
								showValue:false,
								textFieldWidth:115,	
								textFieldName:'RECOMMEND2_ZIP_CODE',
								DBtextFieldName:'ZIP_CODE',
								validateBlank:false,
								listeners: { 'onSelected': {
							                    fn: function(records, type  ){
							                    	panelDetail.down('#recommenderForm').setValue('RECOMMEND2_ADDR', records[0]['ZIP_NAME']);
							                    	panelDetail.down('#recommenderForm').setValue('RECOMMEND2_ADDR_DE', records[0]['ADDR2']);
							                    },
							                    scope: this
							                  },
							                  'onClear' : function(type)	{
							                    	panelDetail.down('#recommenderForm').setValue('RECOMMEND2_ADDR', '');
							                    	panelDetail.down('#recommenderForm').setValue('RECOMMEND2_ADDR_DE', '');
							                  }
									}
							}),{
			        	  	 	fieldLabel: '주소',
							 	name:'RECOMMEND1_ADDR',
								hideLabel:true,
								margin:'0 0 0 145',
								width:180
							},{
			        	  	 	fieldLabel: '주소',
							 	name:'RECOMMEND2_ADDR',
								hideLabel:true,
								margin:'0 0 0 145',
								width:180
							},{
			        	  	 	fieldLabel: '주소',
							 	name:'RECOMMEND1_ADDR_DE',
								hideLabel:true,
								margin:'0 0 0 145',
								width:180
							},{
			        	  	 	fieldLabel: '주소',
							 	name:'RECOMMEND2_ADDR_DE',
								hideLabel:true,
								margin:'0 0 0 145',
								width:180
							}
							
			        	],
					listeners:{
						uniOnChange:function( form, dirty, eOpts ) {
							console.log("onDirtyChange");
							UniAppManager.app.setToolbarButtons('save', true);
						}
					}
        		}]
        		,loadData:function(personNum)	{
        			var recommenderForm = this.down('#recommenderForm');
					recommenderForm.clearForm();
					recommenderForm.uniOpt.inLoading = true; 
					recommenderForm.getForm().load(
						{
							params : {'PERSON_NUMB':personNum},
							success: function(form, action)	{
								 	recommenderForm.uniOpt.inLoading = false; 
								 },
							failure:function(form, action)	{
								 	recommenderForm.uniOpt.inLoading = false; 
								 }
						}
					);
				}
		};