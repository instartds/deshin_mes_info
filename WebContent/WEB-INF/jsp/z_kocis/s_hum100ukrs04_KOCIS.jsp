<%@page language="java" contentType="text/html; charset=utf-8"%>
var healthInfo =	 {
		title:'신상정보', 
		itemId: 'healthInfo',
        
        items:[
        	basicInfo,
        	{
    			xtype: 'uniDetailForm',
		        api: {
		         		 load: s_hum100ukrService_KOCIS.healthInfo,
		         		 submit: s_hum100ukrService_KOCIS.saveHum710
				},
				itemId: 'healthForm',
	        	disabled: false,
    			bodyCls: 'human-panel-form-background',
    			layout: {type:'uniTable', columns:'3'},
        		margin:'0 10 0 10',
        		padding:'0',
        		defaults: {
        					width:260,
        					labelWidth:140
        		},
        		flex:1, 			
    			items: [
    					{
                	  	 	fieldLabel: '사번'    ,
						 	name:'PERSON_NUMB' , 
						 	hidden: true
		        		},{
		        	  	 	fieldLabel: '신장',
						 	name:'HEIGHT',
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;cm'
						},{
		        	  	 	fieldLabel: '주거형태',
						 	name:'LIVE_KIND', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H082'    
						},{
		        	  	 	fieldLabel: '보훈구분',
						 	name:'AGENCY_KIND', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H084'    
						},{
		        	  	 	fieldLabel: '체중',
						 	name:'WEIGHT' ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;&nbsp;kg'
						},{
		        	  	 	fieldLabel: '대지',
						 	name:'GROUND'   ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;&nbsp;&nbsp;&nbsp;평'
						},{
		        	  	 	fieldLabel: '보훈번호',
						 	name:'AGENCY_GRADE'   
						},{
		        	  	 	fieldLabel: '시력(좌)',
						 	name:'SIGHT_LEFT'   
						},{
		        	  	 	fieldLabel: '건평',
						 	name:'FLOOR_SPACE'   ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;&nbsp;&nbsp;&nbsp;평'
						},{
		        	  	 	fieldLabel: '장애구분',
						 	name:'HITCH_KIND', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H085'    
						},{
		        	  	 	fieldLabel: '시력(우)',
						 	name:'SIGHT_RIGHT'   
						},{
		        	  	 	fieldLabel: '동산',
						 	name:'GARDEN'   ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;만원'
						},{
		        	  	 	fieldLabel: '장애등급',
						 	name:'HITCH_GRADE'   ,
						 	xtype:'uniNumberfield'
						},{
		        	  	 	fieldLabel: '혈액형',
						 	name:'BLOOD_KIND', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H080'    
						},{
		        	  	 	fieldLabel: '부동산',
						 	name:'REAL_PROPERTY'  ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;만원'
						},{
		        	  	 	fieldLabel: '장애인등록일',
						 	name:'HITCH_DATE', 
						 	xtype: 'uniDatefield'
						},{
		        	  	 	fieldLabel: '색맹여부',
						 	name:'COLOR_YN', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H081'    
						},{
		        	  	 	fieldLabel: '생활수준',
						 	name:'LIVE_LEVEL', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H083'    
						},{
		        	  	 	fieldLabel: '특기',
						 	name:'SPECIAL_ABILITY'   
						},{
							xtype:'component', 
							colspan:2,
							autoEl:{tag:'div'}
						},{
		        	  	 	fieldLabel: '종교',
						 	name:'RELIGION', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H086',
						 	colspan: 2
						}
		        	],
					listeners:{
						uniOnChange:function( form, dirty, eOpts ) {
							console.log("onDirtyChange");
							UniAppManager.setToolbarButtons('save', true);
						}
					}
        		}
        	
		],
		loadData:function(personNum)	{
				//this.down('#healthForm').getForm().load({params : {'PERSON_NUMB':personNum}});
				var healthFormPanel = this.down('#healthForm');
				healthFormPanel.clearForm();
				healthFormPanel.uniOpt.inLoading = true; 
				healthFormPanel.getForm().load({params : {'PERSON_NUMB':personNum},
									 success: function(form, action)	{
									 	healthFormPanel.uniOpt.inLoading = false; 
									 },
									 failure: function(form, action)	{
									 	healthFormPanel.uniOpt.inLoading = false; 
									 }
									}
								   );
		}		        	
	}