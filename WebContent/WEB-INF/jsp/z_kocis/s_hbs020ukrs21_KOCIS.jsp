<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'메일서버정보등록',
		id:'hbs020ukrTab21',
		itemId: 'hbs020ukrPanel21',
		xtype: 'uniDetailForm',		
		layout: {tyep: 'hbox', align: 'stretch'},
		listeners:{
			 uniOnChange:function( form, dirty, eOpts ) {
    			console.log("onDirtyChange");
    			UniAppManager.app.setToolbarButtons('save', true);
    		}
		},		
		items:[{
			xtype: 'panel',	
			border: false,
			width: 800,
			layout: {tyep: 'hbox', align: 'stretch'},
			items:[{
				name: '',
				xtype: 'fieldset',
				margin: '15 15 15 15',
				padding: '10 20 10 20',
				layout: {tyep: 'hbox', align: 'stretch'},
				defaults: {labelWidth: 120, enforceMaxLength: true},
				items:[{
					xtype: 'radiogroup',		            		
					fieldLabel: '메일전송방법',						            		
					id: 'rdoSelect1',
					items: [{
						boxLabel: 'LOCAL', 
						width: 70, 
						name: 'SEND_METHOD',
						inputValue: '1',
						checked: true
					},{
						boxLabel : 'MAIL SERVER', 
						width: 100,
						name: 'SEND_METHOD',
						inputValue: '2' 
					}]
				},{
					fieldLabel: '메일서버명',
					name: 'SERVER_NAME',
					id: 'SERVER_NAME21',
					xtype: 'uniTextfield',
					width: 350,
					maxLength: 30
				},{
					fieldLabel: '메일서버포트',
					xtype: 'uniNumberfield',
					id: 'SERVER_PROT21',
					name: 'SERVER_PROT',
					width: 180,
					maxLength: 4
				},{
				xtype: 'radiogroup',		            		
				fieldLabel: '보안연렬(SSL) 여부',						            		
				id: 'rdoSelect2',
				items: [{
					boxLabel: '사용', 
					width: 70, 
					name: 'SSL_USE_YN',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '미사용', 
					width: 70,
					name: 'SSL_USE_YN',
					inputValue: '2' 
				}]
				},{
					fieldLabel: 'PICKUP폴더경로',
					xtype: 'uniTextfield',
					id: 'PICKUP_FOLDER_PATH21',
					name: 'PICKUP_FOLDER_PATH',
					width: 500,
					maxLength: 200
				},{
					fieldLabel: '메일접속아이디',
					xtype: 'uniTextfield',
					id: 'SEND_USER_NAME21',
					name: 'SEND_USER_NAME',
					width: 350,
					maxLength: 80
				},{
					fieldLabel: '접속비밀번호',
					xtype: 'uniTextfield',
					inputType: 'password',
					id: 'SEND_PASSWORD21',
					name: 'SEND_PASSWORD',
					width: 350,
					maxLength: 80
				},{
					fieldLabel: '연결제한시간',
					xtype: 'uniNumberfield',					
					id: 'CONN_TIMEOUT21',
					name: 'CONN_TIMEOUT',
					width: 180,
					maxLength: 3
				}]
			}]			
		}]
	}