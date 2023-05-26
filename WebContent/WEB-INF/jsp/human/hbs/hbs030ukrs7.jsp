<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.human.legalbaseyearmonth" default="법정기준자료연도이월"/>',
		id:'hbs030ukrGrid7',
		itemId: 'hbs030ukrPanel7',
		xtype: 'uniDetailForm',
		//layout: {type: 'vbox', align: 'center', pack: 'center'},
		
		items:[{
			xtype: 'panel',
			id:'hbs030ukrPanel7Form',
			itemId:'hbs030ukrPanel7Form',
			disabled:false,
			//layout: {type: 'vbox', align:'center', pack: 'center'},
			border: false,
			items:[{
				name: '',
				xtype: 'fieldset',
				margin: '15 15 15 15',
				padding: '10 0 0 0',
				layout: {type: 'vbox', align: 'left'},
				width: 300,
				items:[{	
					fieldLabel: '<t:message code="system.label.human.oldyear" default="원본년도"/>',
					xtype: 'uniYearField',
					value: new Date().getFullYear(),
			    	id: 'OLD_YEAR',
				    name: 'OLD_YEAR',
				    allowBlank: false
				},{
					fieldLabel: '<t:message code="system.label.human.nowyearcong" default="대상년도"/>',
					xtype: 'uniYearField',
					value: new Date().getFullYear()+1,
			    	id: 'NOW_YEAR',
			    	name: 'NOW_YEAR',
			    	allowBlank: false
				},{
					xtype: 'container',
					margin: '10 100 10 95',
					items:[{
						xtype: 'button',
						text: '<t:message code="system.label.human.execute" default="실행"/>',
						width: 75,
						handler: function(btn) {
							/*var isErro = false;
							
							if(Ext.isEmpty(Ext.getCmp('OLD_YEAR').getValue()) || Ext.isEmpty(Ext.getCmp('NOW_YEAR').getValue())){
							alert('<t:message code="system.message.human.message115" default="[YYYY]형식으로 입력하십시오."/>');
								if(Ext.isEmpty(Ext.getCmp('OLD_YEAR').getValue())){
									Ext.getCmp('OLD_YEAR').focus();
								}else{
									Ext.getCmp('NOW_YEAR').focus();
								}
								isErro = true;
								return false;
							}
							if(!isErro){*/
								doBatch();
							//}
						}
					},{
						xtype: 'button',
						text: '<t:message code="system.label.human.close" default="닫기"/>',
						width: 75,
						handler: function(btn) {		// 공통 오류인지 체크 필
							var tabPanel = parent.Ext.getCmp('contentTabPanel');
							if(tabPanel) {
								var activeTab = tabPanel.getActiveTab();
								var canClose = activeTab.onClose(activeTab);
								if(canClose)  {
									tabPanel.remove(activeTab);
								}
							} else {
					     		self.close();
							}
						}
					}]
				}]
			},{
               border: false,
               name: '',
               html: "<br>" +
               		 "<font size='2' color='blue'><t:message code="system.message.human.message116" default="※ 법정기준자료 연도이월"/><br>" +
               		 "<br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message117" default="1.국민연금, 건강보험료"/> <br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message118" default="2.종합소득세율"/><br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message119" default="3.퇴직소득공제율"/><br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message120" default="4.간이소득세액표"/><br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message121" default="5.비과세근로소득코드"/><br>" +
               		 "<br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message122" default="실행버튼을 클릭하시면 위의 4가지 법정기준자료를"/><br>" +
               		 "&nbsp;&nbsp;<t:message code="system.message.human.message123" default="원본연도의 자료를 대상연도의 자료로 자동생성됩니다."/><br>" +
               		 "</font>"

            	}
			]//전체 item			
		}]   
	}