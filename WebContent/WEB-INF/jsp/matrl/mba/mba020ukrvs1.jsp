<%@page language="java" contentType="text/html; charset=utf-8"%>

	var standard_Setup = {
		layout: {type: 'vbox', align:'stretch'},
		items:[{
			title:'<t:message code="system.label.purchase.purchasebasissetup" default="구매자재기준설정"/>',
			itemId: 'tab_standard',
			xtype: 'uniDetailForm',
			disabled:false,
			api: {
	            load :  'mba020ukrvService.selectForm',
	            submit: 'mba020ukrvService.syncForm'	
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
			title: '자재관리 자동채번 설정',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				name: '',
				html: "<font color = 'blue' >발주 번호를</font>",
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
				html: "<font color = 'blue' >입/출고 번호를</font>",
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
				html: "<font color = 'blue' >자재수급 번호를</font>",
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
				html: "<font color = 'blue' >지급결의 번호를</font>",
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
	        }, {
				border: false,
				name: '',
				html: "<font color = 'blue' >계산서 번호를</font>",
				width: 350
			}, {
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
	        }]			
		},
			{
			xtype: 'fieldset',
			title: '발주승인 사용여부',
			layout: {type: 'uniTable', columns: 3},
			items:[{
				border: false,
				name: '',
				html: "<font color = 'blue' >발주관리중 발주승인 단계를 사용하시겠습니까?</font>",
				width: 350
			}, {
	    		xtype: 'uniRadiogroup',
	    		items: [{
	    			boxLabel: '예',
	    			width: 150,
	    			name: 'RDO6',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '아니오',
	    			width: 150,
	    			name: 'RDO6',
	    			inputValue: '2'
	    		}]
	        },
	        <!-- 2020-12-11 추가 -->
			Unilite.popup('USER',{
				colspan:3, allowBlank:true, 
				textFieldWidth:170, valueFieldWidth:100,
				textFieldName: 'RDO6_4_NAME',
				valueFieldName: 'RDO6_4_CODE',
				fieldLabel		: '승인자',
				listeners : {
					'onSelected': {
	                    fn: function(records, type ){
	                    	UniAppManager.setToolbarButtons('save', true);
	                    },
	                    scope: this
	                }, 
	                'onClear' : function(type)	{
                  		UniAppManager.setToolbarButtons('save', true);
                  	}			
				} 
			})]			
		}, {
			xtype: 'fieldset',
			title: '자재출고량 확인여부',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				name: '',
				html: "<font color = 'blue' >외주입고등록시 자재의 출고여부를 확인하시겠습니까?</font>",
				width: 350
			}, {
	    		xtype: 'uniRadiogroup',
	    		items: [{
	    			boxLabel: '예',
	    			width: 150,
	    			name: 'RDO7',
	    			inputValue: 'Y'
	    		}, {
	    			boxLabel: '아니오',
	    			width: 150,
	    			name: 'RDO7',
	    			inputValue: 'N'
	    		}]
	        }]			
		}, {
			xtype: 'fieldset',
			title: '자재 소요량계획 전개 기준정보',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 3},
				items:[{
					border: false,
					name: '',
					html: "<font color = 'blue' >소요량 전개 근거 내역의 보존기간을 얼마로 하시겠습니까?</font>",
					width: 350
				}, {
			            xtype: 'uniNumberfield',
			            name:'NO1'
				}, {					
						html: '&nbsp;일',
						width: 60,
						border: false
				},{
					border: false,
					name: '',
					html: "<font color = 'blue' >소요량 전개 확정기간은 얼마로 하시겠습니까?</font>",
					width: 350
				}, {
			            xtype: 'uniNumberfield',
			            name:'NO2'
				}, {					
						html: '&nbsp;일',
						width: 60,
						border: false
				},{
					border: false,
					name: '',
					html: "<font color = 'blue' >소요량 전개 예시기간은 얼마로 하시겠습니까?</font>",
					width: 350
				}, {
			            xtype: 'uniNumberfield',
			            name:'NO3'
				}, {					
						html: '&nbsp;일',
						width: 60,
						border: false
				}]
				}]
			}, {
			xtype: 'fieldset',
			title: '자재 소요량 오더 분할 기준정보',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				name: '',
				html: "<font color = 'blue' >소요량 전개시 LotSize별 오더를 분할 하시겠습니까?</font>",
				width: 350
			}, {
	    		xtype: 'uniRadiogroup',
	    		items: [{
	    			boxLabel: '예',
	    			width: 150,
	    			name: 'RDO8',
	    			inputValue: 'Y'
	    		}, {
	    			boxLabel: '아니오',
	    			width: 150,
	    			name: 'RDO8',
	    			inputValue: 'N'
	    		}]
	       },{
				border: false,
				name: '',
				html: "<font color = 'blue' >소요량 전개시 작업장별 오더 수량을 분할 하시겠습니까?</font>",
				width: 350
			}, {
	    		xtype: 'uniRadiogroup',
	    		items: [{
	    			boxLabel: '예',
	    			width: 150,
	    			name: 'RDO9',
	    			inputValue: 'Y'
	    		}, {
	    			boxLabel: '아니오',
	    			width: 150,
	    			name: 'RDO9',
	    			inputValue: 'N'
	    		}]		
		},{
				border: false,
				name: '',
				html: "<font color = 'blue' >작업장별 생산 가능 품목을 관리 하시겠습니까?</font>",
				width: 350
			}, {
	    		xtype: 'uniRadiogroup',
	    		items: [{
	    			boxLabel: '예',
	    			width: 150,
	    			name: 'RDO10',
	    			inputValue: 'Y'
	    		}, {
	    			boxLabel: '아니오',
	    			width: 150,
	    			name: 'RDO10',
	    			inputValue: 'N'
	    		}]	
	    }]
	    }, {
			xtype: 'fieldset',
			title: '소요량 계산시 Loss율 반영여부',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				name: '',
				html: "<font color = 'blue' >MRP 전개중 총 소요량 계산시 Loss율을 반영 하시겠습니까?</font>",
				width: 350
			}, {
	    		xtype: 'uniRadiogroup',
	    		items: [{
	    			boxLabel: '예',
	    			width: 150,
	    			name: 'RDO11',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '아니오',
	    			width: 150,
	    			name: 'RDO11',
	    			inputValue: '2'
	    		}]
	    	}]
		}, {
			xtype: 'fieldset',
			title: '소요량 계산 기준 카렌더 타입은?',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				border: false,
				name: '',
				html: "<font color = 'blue' >기간통합법 발주방침에 사용하는 카렌더 타입은</font>",
				width: 350,
				colspan:1
			}, {
	    		xtype: 'uniRadiogroup',
	    		columns:2,
	    		items: [{
	    			boxLabel: '월단위 카렌터를 사용한다.',
	    			width: 200,
	    			name: 'RDO12',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '순단위 카렌터를 사용한다.',
	    			width: 200,
	    			name: 'RDO12',
	    			inputValue: '2'
	    		},{
	    			boxLabel: '주단위 카렌터를 사용한다.',
	    			width: 200,
	    			name: 'RDO12',
	    			inputValue: '3'
	    		},{
	    			boxLabel: '일단위 카렌터를 사용한다.',
	    			width: 200,
	    			name: 'RDO12',
	    			inputValue: '4'
	    		}]
	    	},{
				border: false,
				name: '',
				html: "<font color = 'blue' >고정기간법 적용시 사용할 카렌더 타입은?</font>",
				width: 350
			}, {
	    		xtype: 'uniRadiogroup',
	    		items: [{
	    			boxLabel: '일반',
	    			width: 200,
	    			name: 'RDO13',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '공장 카렌더',
	    			width: 200,
	    			name: 'RDO13',
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
	 
	 
	 
	 