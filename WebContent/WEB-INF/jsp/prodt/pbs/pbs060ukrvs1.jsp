<%@page language="java" contentType="text/html; charset=utf-8"%>

	var	operating_Criteria = {
		layout: {type: 'vbox', align:'stretch'},
		items:[{
			title:'<t:message code="system.label.product.productionbasissetting" default="생산기준설정"/>',
			itemId: 'tab_operating',
			xtype: 'uniDetailForm',
			layout: {type: 'hbox', align: 'stretch'},			
    		flex:1,
 			autoScroll:false,
 			disabled:false,
			api: {
		        load : 'pbs060ukrvService.selectForm',
		        submit: 'pbs060ukrvService.syncForm'	
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
					title: '자동채번 설정',
					layout: {type: 'uniTable', columns: 2},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >작업지시 번호를</font>",
						width: 350
					}, {
			    		xtype: 'radiogroup',
			    		id: 'rdo1',
			    		items: [{
			    			boxLabel: '자동 채번한다.',
			    			width: 150,
			    			name: 'P005_2',
			    			inputValue: 'Y'
			    			//checked: true
			    		}, {
			    			boxLabel: '수동 채번한다.',
			    			width: 150,
			    			name: 'P005_2',
			    			inputValue: 'N'
			    		}]
			        }, {
						border: false,
						name: '',
						html: "<font color = 'blue' >출고요청 번호를</font>",
						width: 350
					}, {
			    		xtype: 'radiogroup',
			    		id: 'rdo2',
			    		items: [{
			    			boxLabel: '자동 채번한다.',
			    			width: 150,
			    			name: 'P005_3',
			    			inputValue: 'Y'
			    			//checked: true
			    		}, {
			    			boxLabel: '수동 채번한다.',
			    			width: 150,
			    			name: 'P005_3',
			    			inputValue: 'N'
			    		}]
			        }]			
				}, {
					xtype: 'fieldset',
					title: '작업지시 수량대비 초과 생산실적 등록여부',
					layout: {type: 'uniTable', columns: 4},
					items:[{
			    		xtype: 'radiogroup',
			    		id: 'rado',
			    		items: [{
			    			boxLabel: '허용하지 않음',
			    			width: 150,
			    			name: 'P100_1',
			    			inputValue: 'N'
			    		}, {
			    			boxLabel: '허용함',
			    			width: 150,
			    			name: 'P100_1',
			    			inputValue: 'Y'
			    			//checked: true
			    		}]
			        },{
						border: false,
						layout: {type: 'uniTable', columns: 3},
						items: [{
							name: 'P100_2',
							html: "<font color = 'blue' >한다면</font>",
							width: 40,
							border: false
						}, {
				            xtype: 'uniNumberfield',
				            name:'P100_2',
				            //defaultAlign: 'right',
				            width: 30,
				            //suffixTpl: '&nbsp;'
				            //value:100
				            allowBlank:false,
				            listeners: {
                                change: function(field, newValue, oldValue, eOpts) {                        
                                    if(newValue == '-') {
                                    	alert("양수만 입력가능합니다.");
                                    	panelDetail.down('#tab_operating').setValue('P100_2', '10');
                                    } else {
                                    	
                                    }
                                }
                            }
						}, {					
							html: "<font color = 'blue' > % 까지 초과 가능하다.</font>",
							width: 200,
							border: false
						}]
			        }]			
				}, {
					xtype: 'fieldset',
					title: '생산계획구간 관리',
						layout: {type: 'uniTable', columns: 3, height:500},
						items: [{
							name: 'P107_1',
							html: "<font color = 'blue' >생산계획기간(Planning Horizon) 관리</font>",
							width: 348,
							border: false
						}, {
				            xtype: 'uniNumberfield',
				            name:'P107_1',
				            width: 30,
				            //value: 60,
			        		allowBlank:false
						}, {					
							html: "<font color = 'blue' >&nbsp;&nbsp;&nbsp; 일  (최대 60일)</font>",
							width: 200,
							border: false
						}]		
				}, {
					xtype: 'fieldset',
					title: '생산계획 작성시 일일생산량 관리',
					layout: {type: 'uniTable', columns: 3},
					items:[{
						border: false,
						name: 'P104_1',
						html: "<font color = 'blue' >일일 생산량을</font>",
						width: 150
					}, {
			    		xtype: 'radiogroup',
			    		id: 'radio',
			    		items: [{
			    			boxLabel: '최대 생산량',
			    			width: 150,
			    			name: 'P104_1',
			    			inputValue: '2'
			    			//checked: true
			    		}, {
			    			boxLabel: '표준 생산량',
			    			width: 100,
			    			name: 'P104_1',
			    			inputValue: '3'
			    		}]
			    	},{
						border: false,
						name: '',
						html: "<font color = 'blue' >로 관리한다.</font>",
						width: 350	
			        }]			
				}, {
					xtype: 'fieldset',
					title: '작업지시 생성관리',
					layout: {type: 'uniTable', columns: 3},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >작업지시등록시 자품목 가용재고 체크여부</font>",
						width: 350
					}, {
			    		xtype: 'radiogroup',
			    		id: 'radio1',
			    		items: [{
			    			boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
			    			width: 150,
			    			name: 'P112_1',
			    			inputValue: 'Y'
			    		}, {
			    			boxLabel: '<t:message code="system.label.product.no" default="아니오"/>',
			    			width: 100,
			    			name: 'P112_1',
			    			inputValue: 'N'
			    			//checked: true
			    		}]
			        }]			
				}, {
					xtype: 'fieldset',
					title: '출고요청정보 자동생성관리',
					layout: {type: 'uniTable', columns: 2},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >작업지시등록시 출고요청정보 자동생성여부</font>",
						width: 350
					}, {
			    		xtype: 'radiogroup',
			    		id: 'radio2',
			    		items: [{
			    			boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
			    			width: 150,
			    			name: 'P109_1',
			    			inputValue: 'Y'
			    		}, {
			    			boxLabel: '<t:message code="system.label.product.no" default="아니오"/>',
			    			width: 100,
			    			name: 'P109_1',
			    			inputValue: 'N'
			    			//checked: true
			    		}]
			        },{
						border: false,
						name: '',
						html: "<font color = 'blue' >&nbsp;(단 해당 품목의 생산출고방법이 메뉴얼인 경우) </font>",
						width: 350	
			        }]			
				}, {
					xtype: 'fieldset',
					title: '검사접수내역 자동생성관리',
					layout: {type: 'uniTable', columns: 2},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >생산실적등록시 검사접수내역 자동생성여부</font>",
						width: 350
					}, {
						border: false,
			    		xtype: 'radiogroup',
			    		id: 'radio3',
			    		items: [{
			    			boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
			    			width: 150,
			    			name: 'P111_1',
			    			inputValue: 'Y'
			    		}, {
			    			boxLabel: '<t:message code="system.label.product.no" default="아니오"/>',
			    			width: 100,
			    			name: 'P111_1',
			    			inputValue: 'N'
			    			//checked: true
			    		}]
			    		
			        },{ 
			        	colspan: 2,
						border: false,
						name: '',
						html: "<font color = 'blue' >&nbsp;(단 해당 품목의 품질대상여부가 '<t:message code="system.label.product.yes" default="예"/>' 이고 실적입고방식이 수동입고인 경우) </font>",
						width: 500
			        }]			
				}, {
					xtype: 'fieldset',
					title: '자재출고량관리',
					layout: {type: 'uniTable', columns: 2},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >실적등록시 출고량 확인 여부</font>",
						width: 350
					}, {
			    		xtype: 'radiogroup',
			    		id: 'radio4',
			    		items: [{
			    			boxLabel: '<t:message code="system.label.product.yes" default="예"/>',
			    			width: 150,
			    			name: 'P110_1',
			    			inputValue: 'Y'
			    		}, {
			    			boxLabel: '<t:message code="system.label.product.no" default="아니오"/>',
			    			width: 100,
			    			name: 'P110_1',
			    			inputValue: 'N'
			    			//checked: true
			    		}]
			        }]			
				}],
				listeners: {
					dirtychange:function( basicForm, dirty, eOpts ) {
						if(gsButtonFlag) {
							UniAppManager.setToolbarButtons('save', true);
							
						} else {
							UniAppManager.setToolbarButtons('save', false);
						}
					}
				}
			}]
		}]
	}	
