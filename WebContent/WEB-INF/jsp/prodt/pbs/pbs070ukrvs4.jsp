<%@page language="java" contentType="text/html; charset=utf-8"%>


	var prodt_Calender_Search =	 {
			itemId: 'prodt_Calender_Search',
			id:'prodt_Calender_Search',
			layout: {type: 'vbox', align:'stretch'},
			items:[{	
				title:'카렌더정보조회',
				itemId: 'tab_Cal_Search',
				xtype: 'uniDetailFormSimple',
		        		layout: {type: 'vbox', align:'stretch'},
		     			//bodyCls: 'human-panel-form-background',
			        	padding: '0 0 0 0',
		        		items:[{
							xtype: 'container',
							id : 'container4',
							layout: {type: 'uniTable'},
							items:[{
				        		fieldLabel: '카렌더 타입',
				        		name: 'CAL_TYPE',
				        		xtype: 'uniCombobox',
				        		comboType: 'AU',
				        		comboCode: 'B062',
				        		allowBlank: false,
				        		width:200
				        	},{
				        		fieldLabel: '생성년도',
				        		name: 'START_DATE',
				        		xtype: 'uniYearField',
				        		allowBlank: false,
				        		value: new Date().getFullYear(),
				        		width:200
				        	}]
			        	},{	
			        		xtype: 'uniGridPanel',
			        		itemId:'pbs070ukrvs_4Grid',
					        store : pbs070ukrvs_4Store, 
					        padding: '0 0 0 0',
					        dockedItems: [{
						        xtype: 'toolbar',
						        dock: 'top',
						        padding:'0px',
						        border:0
						    }],
					        uniOpt:{	expandLastColumn: false,
					        			useRowNumberer: true,
					                    useMultipleSorting: false
					        },
				columns: [{dataIndex: 'CAL_NO'			, width: 88},
						  {dataIndex: 'START_DATE'		, width: 120 ,align:'center'},
						  {dataIndex: 'END_DATE'		, width: 120 ,align:'center'},
						  {dataIndex: 'WORK_DAY'		, flex: 1    ,align:'right'}
						 ]
					/*,getSubCode: function()	{
					return this.subCode;
				}*/
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