<%@page language="java" contentType="text/html; charset=utf-8"%>



	var prodt_Calender_Info =	 {
			xtype: 'container',
			itemId: 'prodt_Calender_Info',
			id:'prodt_Calender_Info',
			layout: {type: 'vbox', align:'stretch'},
			items:[{	
				title:'카렌더정보생성',
				itemId: 'tab_Cal_Info',
				id:'tab_Cal_Info',
				xtype: 'uniDetailFormSimple',
        		layout: {type: 'vbox', align:'stretch'},
     			//bodyCls: 'human-panel-form-background',
	        	padding: '0 0 0 0',
        		items:[{
					xtype: 'container',
					id : 'container2',
					layout: {type: 'uniTable'},
					items:[{
		        		fieldLabel: '카렌더 타입',
		        		id: 'CAL_TYPE',
		        		name:'CAL_TYPE',
		        		xtype: 'uniCombobox',
		        		comboType: 'AU',
		        		comboCode: 'B062',
		        		allowBlank: false,
		        		width:200
		        	},{
		        		fieldLabel: '생성년도',
		        		id: 'START_DATE',
		        		name:'START_DATE',
		        		xtype: 'uniYearField',
		        		allowBlank: false,
		        		value: UniDate.get('today').substring(0, 4),
		        		width:200
		        	}]
	        	},{
					xtype: 'fieldset',
					title: '공휴일 선택사항',
					layout: {type: 'uniTable', columns: 1},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >1. 요일선택</font>",
						width: 350
					}, {
			    		xtype: 'uniCheckboxgroup',		            		
			    		fieldLabel: '',
			    		items: [{
			    			boxLabel: '일요일',
			    			width: 100,
			    			name: 'HOLYDAY1',
			    			inputValue: '1',
			    			checked	  :true
			    		},{
			    			boxLabel: '월요일',
			    			width: 100,
			    			name: 'HOLYDAY2',
			    			inputValue: '2'
			    		},{
			    			boxLabel: '화요일',
			    			width: 100,
			    			name: 'HOLYDAY3',
			    			inputValue: '3'
			    		},{
			    			boxLabel: '수요일',
			    			width: 100,
			    			name: 'HOLYDAY4',
			    			inputValue: '4'
			    		},{
			    			boxLabel: '목요일',
			    			width: 100,
			    			name: 'HOLYDAY5',
			    			inputValue: '5'
			    		},{
			    			boxLabel: '금요일',
			    			width: 100,
			    			name: 'HOLYDAY6',
			    			inputValue: '6'
			    		},{
			    			boxLabel: '토요일',
			    			width: 100,
			    			name: 'HOLYDAY7',
			    			inputValue: '7'
			    		}]
			        },{
						border: false,
						name: '',
						html: "<font color = 'blue' >2. 지정공휴일</font>",
						width: 350
					}]		
				},{             
                        xtype: 'uniGridPanel',
                        itemId:'pbs070ukrvs_2Grid',
                        store : pbs070ukrvs_2Store,
                        width: 1000,
                        height: 450,
                        uniOpt: {
                            onLoadSelectFirst: false, 
                            useGroupSummary: false,
                            useLiveSearch: true,
                            useContextMenu: false,
                            useMultipleSorting: true,
                            useRowNumberer: false,
                            expandLastColumn: false,
                            filter: {
                                useFilter: false,
                                autoCreate: false
                            }
                        },     
                        columns: [{dataIndex: 'HOLY_MONTH'          , width: 66, maxLength: 2 ,align:'center'},
                                  {dataIndex: 'HOLY_DAY'            , width: 66, maxLength: 2 ,align:'center'},
                                  
                                  {dataIndex: 'HOLY_MONTH_RENDER'   , width: 66, maxLength: 2 ,align:'center' ,hidden: true},
                                  {dataIndex: 'HOLY_DAY_RENDER'     , width: 66, maxLength: 2 ,align:'center' ,hidden: true},
                                  {dataIndex: 'REMARK'              , flex: 1  },
                                  {dataIndex: 'UPDATE_DB_USER'      , width: 100 , hidden: true},
                                  {dataIndex: 'UPDATE_DB_TIME'      , width: 100 , hidden: true},
                                  {dataIndex: 'COMP_CODE'           , width: 100 , hidden: true}
                                    
                        ]
                    },{
			    	xtype: 'container',
			    	//padding: '-50 0 0 0',
			    	margin: '0 0 0 -200',
			    	layout: {
			    		type: 'hbox',
						align: 'center',
						pack:'center'
			    	},
			    	items:[{
			    		xtype: 'button',
			    		text: '생  성',	
			    		width: 60,	       
						handler : function() {
							var rv = true;				
							if(!UniAppManager.app.checkForNewDetail2()){
								return false;
							}else{
								if(confirm(Msg.sMB063)) {
									var param= panelDetail.down('#tab_Cal_Info').getForm().getValues();
									pbs070ukrvsService.checkYear(param, function(provider, response) {					
										panelDetail.down('#pbs070ukrvs_2Grid').getEl().mask('<t:message code="system.label.product.loading" default="로딩중..."/>','loading-indicator');
										pbs070ukrvsService.updateDetail2(param, function(provider, response) {   // 공휴일 선택사항 ( 요일별, 지정공휴일 동시에 처리 )
											if(provider != null) {		
												alert(Msg.sMB021);
											}
	  			 							panelDetail.down('#pbs070ukrvs_2Grid').getEl().unmask();
										});
									});
								} else {
							   			
								}
								return rv;
							}
						}
			    	},{
			    		xtype: 'button',
			    		text: '취  소',	
			    		margin: '0 0 2 20',
			    		width: 60,					   	
						handler : function() {
							var rv = true;
							if(!UniAppManager.app.checkForNewDetail2()){
								return false;
							}else{
								if(confirm(Msg.sMB063)) {
									var param= panelDetail.down('#tab_Cal_Info').getForm().getValues();
									
									pbs070ukrvsService.deleteDetail2_1(param, function(provider, response) {					
										panelDetail.down('#pbs070ukrvs_2Grid').getEl().mask('<t:message code="system.label.product.loading" default="로딩중..."/>','loading-indicator');
										pbs070ukrvsService.deleteDetail2_2(param, function(provider, response) {          
											if(provider != null) {
												alert(Msg.sMB021);
											}
	  			 							panelDetail.down('#pbs070ukrvs_2Grid').getEl().unmask();
										});
									});
								} else {
							   			
								}
								return rv;
							}
						}
			    	}
			    ]
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}	
		}]
	}