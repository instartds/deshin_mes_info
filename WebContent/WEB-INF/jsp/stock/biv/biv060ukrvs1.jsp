<%@page language="java" contentType="text/html; charset=utf-8"%>


	var	operating_Criteria = {
		//itemId: 'operating_Criteria',
		layout: {type: 'vbox', align:'stretch'},
		items:[{
			title:'재고업무설정',
			itemId: 'tab_operating',
			xtype: 'uniDetailForm',
    		layout: {type: 'hbox', align:'stretch'},
    		flex:1,
 			autoScroll:false,
 			disabled:false,
			api: {
	                load :  'biv060ukrvService.selectForm',
	                submit: 'biv060ukrvService.syncForm'	
	        },
 			items:[{	
 				disabled:false,
	    		xtype: 'uniDetailForm',
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
					title: '재고이동시 기준설정',
					layout: {type: 'uniTable', columns: 2},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >[요청번호를]</font>",
						width: 350
						}, {
				    		xtype: 'radiogroup',
				    		//name: 'B041_3',
				    		//id: 'rdo1',
				    		items: [{
				    			boxLabel: '자동채번한다',
				    			width: 150,
				    			name: 'B041_3',
				    			inputValue: 'Y'
				    			//checked: true
				    		}, {
				    			boxLabel: '수동채번한다',
				    			width: 150,
				    			name: 'B041_3',
				    			inputValue: 'N'
				    		}]
				        }, {
							border: false,
							name: '',
							html: "<font color = 'blue' >[출고번호를]</font>",
							width: 350
						}, {
				    		xtype: 'radiogroup',
				    		//id: 'rdo2',
				    		items: [{
				    			boxLabel: '자동채번한다',
				    			width: 150,
				    			name: 'B041_1',
				    			inputValue: 'Y'
				    			//checked: true
				    		}, {
				    			boxLabel: '수동채번한다',
				    			width: 150,
				    			name: 'B041_1',
				    			inputValue: 'N'
				    		}]
			        	}, {
							border: false,
							name: '',
							html: "<font color = 'blue' >[입고번호를]</font>",
							width: 350
						}, {
				    		xtype: 'radiogroup',
				    		//id: 'rdo8',
				    		items: [{
				    			boxLabel: '자동채번한다',
				    			width: 150,
				    			name: 'B041_2',
				    			inputValue: 'Y'
				    			//checked: true
				    		}, {
				    			boxLabel: '수동채번한다',
				    			width: 150,
				    			name: 'B041_2',
				    			inputValue: 'N'
				    		}]
				        }, {
							border: false,
							name: '',
							html: "<font color = 'blue' >[출고시 자동으로 입고등록을]</font>",
							width: 350
						}, {
				    		xtype: 'radiogroup',
				    		//id: 'rdo3',
				    		items: [{
				    			boxLabel: '한다',
				    			width: 150,
				    			name: 'B045_1',
				    			inputValue: '1'
				    			//checked: true
				    		}, {
				    			boxLabel: '하지 않는다',
				    			width: 150,
				    			name: 'B045_1',
				    			inputValue: '2'
				    		}]
				    	}]	
			        }, {
					xtype: 'fieldset',
					title: '재고금액 평가방법 설정',
					layout: {type: 'uniTable', columns: 1},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >재고금액의 평가방법은</font>",
						width: 350
						}, {
				    		xtype: 'radiogroup',
				    		//id: 'rdo3',
				    		items: [{
				    			boxLabel: '월 총평균법',
				    			width: 150,
				    			name: 'B049_1',
				    			inputValue: '1'
				    			//checked: true
				    		}, {
				    			boxLabel: '이동평균단가',
				    			width: 150,
				    			name: 'B049_1',
				    			inputValue: '2'
				    		}]
				    	}]	
			        },{
					xtype: 'fieldset',
					title: '예상재고 관리기준',
					layout: {type: 'uniTable', columns: 3},
					items:[{
						border: false,
						name: '',
						html: "예상 입/출고 재고 산정시 조회기간을 얼마로 하시겠습니까?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
						}, {
				    		xtype: 'uniNumberfield',
				    		name: 'M011_1',
				    		width: 50,
				    		allowBlank: false,
				    		defaultAlign: 'right',
				    		value: '100',
				    		suffixTpl: '&nbsp;'
					        }, {
					        	border: false,
								name: '',
								html: "&nbsp;&nbsp;일"
					        }]			
					}, {
					xtype: 'fieldset',
					title: '재고관리 기준',
					layout: {type: 'uniTable', columns: 2},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >현재고 산정시 불량재고를 반영 하시겠습니까?</font>",
						width: 350
					}, {
			    		xtype: 'radiogroup',		            		
			    		fieldLabel: '',
			    		items: [{
			    			boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
			    			width: 150,
			    			name: 'M013_1',
			    			inputValue: '1'
			    		}, {
			    			boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>',
			    			width: 150,
			    			name: 'M013_1',
			    			inputValue: '2'
			    		}]
			        }]	
				}]
			}],
		

			listeners: {
	           	afterrender: function(form) {
	           		form.getForm().load();
	           	},
				dirtychange:function( basicForm, dirty, eOpts ) {
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		}]
		
	}			
			