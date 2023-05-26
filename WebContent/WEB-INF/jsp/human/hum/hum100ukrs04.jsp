<%@page language="java" contentType="text/html; charset=utf-8"%>
var healthInfo =	 {
		title:'<t:message code="system.label.human.healthinfo" default="신상정보"/>', 
		itemId: 'healthInfo',
        
        items:[
        	basicInfo,
        	{
    			xtype: 'uniDetailForm',
		        api: {
		         		 load: hum100ukrService.healthInfo,
		         		 submit: hum100ukrService.saveHum710
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
                	  	 	fieldLabel: '<t:message code="system.label.human.personnumb" default="사번"/>'    ,
						 	name:'PERSON_NUMB' , 
						 	hidden: true
		        		},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.height" default="신장"/>',
						 	name:'HEIGHT',
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;cm'
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.livekind2" default="주거형태"/>',
						 	name:'LIVE_KIND', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H082'    
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.agencykind" default="보훈구분"/>',
						 	name:'AGENCY_KIND', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H084'    
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.weight" default="체중"/>',
						 	name:'WEIGHT' ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;&nbsp;kg'
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.ground" default="대지"/>',
						 	name:'GROUND'   ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;&nbsp;&nbsp;&nbsp;<t:message code="system.label.human.ping" default="평"/>'
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.accnt.agencygradenum" default="보훈번호"/>',
						 	name:'AGENCY_GRADE'   
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.sightleft" default="시력(좌)"/>',
						 	name:'SIGHT_LEFT'   
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.floorspace" default="건평"/>',
						 	name:'FLOOR_SPACE'   ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;&nbsp;&nbsp;&nbsp;<t:message code="system.label.human.ping" default="평"/>'
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.hitchkind" default="장애구분"/>',
						 	name:'HITCH_KIND', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H085'    
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.sightright" default="시력(우)"/>',
						 	name:'SIGHT_RIGHT'   
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.garden" default="동산"/>',
						 	name:'GARDEN'   ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;<t:message code="system.label.human.manwon" default="만원"/>'
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.hitchgrade" default="장애등급"/>',
						 	name:'HITCH_GRADE'   ,
						 	xtype:'uniNumberfield'
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.bloodkind" default="혈액형"/>',
						 	name:'BLOOD_KIND', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H080'    
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.realproperty" default="부동산"/>',
						 	name:'REAL_PROPERTY'  ,
						 	xtype:'uniNumberfield',
							suffixTpl : '&nbsp;<t:message code="system.label.human.manwon" default="만원"/>'
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.hitchdate" default="장애인등록일"/>',
						 	name:'HITCH_DATE', 
						 	xtype: 'uniDatefield'
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.coloryn" default="색맹여부"/>',
						 	name:'COLOR_YN', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H081'    
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.livelevel" default="생활수준"/>',
						 	name:'LIVE_LEVEL', 
						 	xtype: 'uniCombobox',
						 	comboType: 'AU', 
						 	comboCode: 'H083'    
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.specialability" default="특기"/>',
						 	name:'SPECIAL_ABILITY'   
						},{
							xtype:'component', 
							colspan:2,
							autoEl:{tag:'div'}
						},{
		        	  	 	fieldLabel: '<t:message code="system.label.human.religion" default="종교"/>',
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