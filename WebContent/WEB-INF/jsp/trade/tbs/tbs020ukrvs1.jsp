<%@page language="java" contentType="text/html; charset=utf-8"%>

	var standard_Setup = {
		layout: {type: 'vbox', align:'stretch'},
		items:[{
			title:'<t:message code="system.label.trade.tradesetup" default="무역업무설정"/>',
			itemId: 'tab_standard',
			xtype: 'uniDetailForm',
			disabled:false,
			api: {
	            load :  'tbs020ukrvService.selectForm',
	            submit: 'tbs020ukrvService.syncForm'	
		    },
    		layout: {type: 'hbox', align:'stretch'},
    		flex:1,
 			autoScroll:false,
 			items:[{	
		    		xtype: 'uniDetailForm',
					disabled:false,
			        dockedItems: [{
				        xtype: 'toolbar',
				        dock: 'top',
				        padding:'0px',
				        border:0,
				        padding: '0 0 0 0'
				  	 }],
	        layout: {type: 'vbox', align: 'stretch' ,padding: '0 0 0 0'},
			items:[{
					xtype: 'fieldset',
					title: '수출관리 자동채번 여부',
					layout: {type: 'uniTable', columns: 2},
					items:[{
								border: false,
								name: '',
								html: "<font color = 'blue' >OFFER 관리번호를</font>",
								width: 350
							}, {
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RDO1',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO1',
					    			inputValue: 'N'	
			    				}]
					        }, {
								border: false,
								name: '',
								html: "<font color = 'blue' >L/C관리번호를</font>",
								width: 350
							}, {
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RDO2',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO2',
					    			inputValue: 'N'
					    		}]
					        },{
								border: false,
								name: '',
								html: "<font color = 'blue' >LOCAL L/C관리번호를</font>",
								width: 350
							}, {
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RDO3',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO3',
					    			inputValue: 'N'
					    		}]
					        }, {
								border: false,
								name: '',
								html: "<font color = 'blue' >통관관리번호를</font>",
								width: 350
							}, {
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RDO4',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO4',
					    			inputValue: 'N'
					    		}]
					        },{
								border: false,
								name: '',
								html: "<font color = 'blue' >LOCAL 매출 인수증번호를</font>",
								width: 350
							},{
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RDO5',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO5',
					    			inputValue: 'N'
					    		}]
					        },{
								border: false,
								name: '',
								html: "<font color = 'blue' >선적관리번호를</font>",
								width: 350
							},{
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RDO6',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO6',
					    			inputValue: 'N'
					    		}]
					        },{
								border: false,
								name: '',
								html: "<font color = 'blue' >NEGO관리번호를</font>",
								width: 350
							},{
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RDO7',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO7',
					    			inputValue: 'N'
					    		}]
					        },{
								border: false,
								name: '',
								html: "<font color = 'blue' >대금관리번호를</font>",
								width: 350
							}, {
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RDO8',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO8',
					    			inputValue: 'N'
					    		}]
					       }]			
					},
					{
					xtype: 'fieldset',
					title: '수입관리 자동채번 여부',
					layout: {type: 'uniTable', columns: 2},
					items:[{
								border: false,
								name: '',
								html: "<font color = 'blue' >OFFER 관리번호를</font>",
								width: 350
							}, {
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RDO9',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO9',
					    			inputValue: 'N'	
			    				}]
					        }, {
								border: false,
								name: '',
								html: "<font color = 'blue' >L/C관리번호를</font>",
								width: 350
							}, {
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RD10',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RDO10',
					    			inputValue: 'N'
					    		}]
					        },{
								border: false,
								name: '',
								html: "<font color = 'blue' >LOCAL L/C관리번호를</font>",
								width: 350
							}, {
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RD11',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RD11',
					    			inputValue: 'N'
					    		}]
					        }, {
								border: false,
								name: '',
								html: "<font color = 'blue' >선적관리번호를</font>",
								width: 350
							}, {
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RD12',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RD12',
					    			inputValue: 'N'
					    		}]
					        },{
								border: false,
								name: '',
								html: "<font color = 'blue' >통관관리번호를</font>",
								width: 350
							},{
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RD13',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RD13',
					    			inputValue: 'N'
					    		}]
					        },{
								border: false,
								name: '',
								html: "<font color = 'blue' >보세입출고번호를</font>",
								width: 350
							},{
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RD14',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RD14',
					    			inputValue: 'N'
					    		}]
					        },{
								border: false,
								name: '',
								html: "<font color = 'blue' >대금관리번호를</font>",
								width: 350
							},{
					    		xtype: 'uniRadiogroup',
					    		items: [{
					    			boxLabel: '자동 채번한다.',
					    			width: 150,
					    			name: 'RD15',
					    			inputValue: 'Y'
					    		}, {
					    			boxLabel: '수동 채번한다.',
					    			width: 150,
					    			name: 'RD15',
					    			inputValue: 'N'
					    		}]
					    	}]
			   			},   //title: '자재 소요량 오더 분할 기준정보'
				    	{
						xtype: 'fieldset',
						title: '<t:message code="system.label.trade.expensedistributionsetup" default="부대비배부기준"/>',
						layout: {type: 'uniTable', columns: 2},
						items:[{
							border: false,
							name: '',
							html: "<font color = 'blue' >[부대비배부 기준은 무엇입니까?]</font>",
							width: 350
						}, {
							xtype: 'uniRadiogroup',
				    		items: [{
				    			boxLabel: '금액기준',
				    			width: 150,
				    			name: 'RD16',
				    			inputValue: '1'
				    		}, {
				    			boxLabel: '<t:message code="system.label.trade.qty" default="수량"/>기준',
				    			width: 150,
				    			name: 'RD16',
				    			inputValue: '2'
				    		}]    		
				    	}]
		    	
				}]
			}],	    //xtype: 'uniDetailForm'
				listeners: {
					           	afterrender: function(form) {
					           		form.getForm().load();
					           	},
								dirtychange:function( basicForm, dirty, eOpts ) {
									UniAppManager.setToolbarButtons('save', true);
								}
							}
		}]   //title:'<t:message code="system.label.trade.tradesetup" default="무역업무설정"/>'
	}
	 
	 
	 
	 