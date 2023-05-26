<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'회계기준설정',
		itemId	: 'tab_aba100ukr',
		id		: 'tab_aba100ukr',
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		api: {
                load : 'aba060ukrsService.fnGetBaseData',
                submit: 'aba060ukrsService.saveBaseData'	
		},
		items:[{
			xtype: 'fieldset',
			title: '자동채번 설정',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				html: "<font color = 'blue' >[결의전표를 자동채번하시겠습니까?]</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '예',
	    			width: 150,
	    			name: 'SLIP_NUM1',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '아니오',
	    			width: 150,
	    			name: 'SLIP_NUM1',
	    			inputValue: '2'
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >[회계전표를 자동채번하시겠습니까?]</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '예',
	    			width: 150,
	    			name: 'SLIP_NUM2',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '아니오',
	    			width: 150,
	    			name: 'SLIP_NUM2',
	    			inputValue: '2'
	    		}]
	        }]			
		}, {
			xtype: 'fieldset',
			title: '제조계정 사용여부',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				border: false,
				html: "<font color = 'blue' >사용할 계정을 선택하십시오.</font>",
				width: 350
			}, {
	    		xtype: 'uniCheckboxgroup',		            		
	    		fieldLabel: '',
	    		items: [{
	    			boxLabel: '제조계정',
	    			width: 150,
	    			name: 'PROD_ACCNT',
	    			inputValue: '1',
	    			uncheckedValue: '0'
	    		}]
	        }]			
		}, {
			xtype: 'fieldset',
			title: '기본 설정',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				html: "<font color = 'blue' >소수점 끝전처리는</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',		            		
	    		hideLabel: true,
	    		items: [{
	    			boxLabel: '절사한다.',
	    			width: 150,
	    			name: 'AMT_POINT',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '절상한다.',
	    			width: 150,
	    			name: 'AMT_POINT',
	    			inputValue: '2'
	    		}, {
	    			boxLabel: '사사오입한다.',
	    			width: 150,
	    			name: 'AMT_POINT',
	    			inputValue: '3'
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >전표입력시 기본적인 환율은</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',		            		
	    		hideLabel: true,
	    		items: [{
	    			boxLabel: '변동환율을 참조한다.',
	    			width: 150,
	    			name: 'EXCHG_BASE',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '고정환율을 참조한다.',
	    			width: 150,
	    			name: 'EXCHG_BASE',
	    			inputValue: '2'
//	    			checked: true
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >전표입력시 미결을</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',		            		
	    		hideLabel: true,
	    		items: [{
	    			boxLabel: '관리한다.',
	    			width: 150,
	    			name: 'PEND_YN',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '관리안한다.',
	    			width: 150,
	    			name: 'PEND_YN',
	    			inputValue: '2'
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >전표번호별 입력화면에서 귀속부서와 귀속사업장을</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',		            		
	    		hideLabel: true,
	    		items: [{
	    			boxLabel: '관리한다.',
	    			width: 150,
	    			name: 'RETURN_YN',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '관리안한다.',
	    			width: 150,
	    			name: 'RETURN_YN',
	    			inputValue: '2'
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >전표입력시 판관ㆍ제조경비를 대변에 등록할 경우</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',		            		
	    		hideLabel: true,
	    		items: [{
	    			boxLabel: '경고메시지를 보여준다.',
	    			width: 150,
	    			name: 'SLIP_MSG',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '보여주지 않는다.',
	    			width: 150,
	    			name: 'SLIP_MSG',
	    			inputValue: '2'
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >결산이월작업시 사업장별로 차기이월이익잉여금(결손금)을 이월</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',		            		
	    		hideLabel: true,
	    		items: [{
	    			boxLabel: '한다.',
	    			width: 150,
	    			name: 'IWOL_DIVI_YN',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '안한다.',
	    			width: 150,
	    			name: 'IWOL_DIVI_YN',
	    			inputValue: '2'
//	    			checked: true
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >전표출력은</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',		            		
	    		hideLabel: true,
	    		items: [{
	    			boxLabel: 'A4 세로 2장으로 한다.',
	    			width: 150,
	    			name: 'SLIP_PRINT',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: 'A4 세로 1장으로 한다.',
	    			width: 150,
	    			name: 'SLIP_PRINT',
	    			inputValue: '2'
	    		}]
	        }, {
				border: false,
				html: " ",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: 'A4 가로로 한다.',
	    			name: 'SLIP_PRINT',
	    			inputValue: '3'
//	    			checked: true
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >절취선 출력을</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',		            		
	    		hideLabel: true,
	    		items: [{
	    			boxLabel: '한다.',
	    			width: 150,
	    			name: 'PRINT_LINE',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '안한다.',
	    			width: 150,
	    			name: 'PRINT_LINE',
	    			inputValue: '2'
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >기초잔액 반영시 일자를</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',		            		
	    		hideLabel: true,
	    		items: [{
	    			boxLabel: '붙인다.',
	    			width: 150,
	    			name: 'BASE_BALANCE_DATE_YN',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '안붙인다.',
	    			width: 150,
	    			name: 'BASE_BALANCE_DATE_YN',
	    			inputValue: '2'
	    		}]
	        }]			
		}, {
			xtype: 'fieldset',
			title: '예산 설정',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				html: "<font color = 'blue' >예산프로세스는</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '계정과목으로 적용한다.',
	    			width: 150,
	    			name: 'BUDG_PRO_BASE',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '예산과목으로 적용한다.',
	    			width: 150,
	    			name: 'BUDG_PRO_BASE',
	    			inputValue: '2'
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >전표입력시 예산을</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '통제한다.',
	    			width: 150,
	    			name: 'BUDG_YN',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '통제안한다.',
	    			name: 'BUDG_YN',
	    			inputValue: '2'
//	    			checked: true
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >실적이 쌓이는 시점은</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '결의전표 입력시점이다.',
	    			width: 150,
	    			name: 'BUDG_BASE',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '승인 및 회계전표 입력시점이다.',	    			
	    			width: 250,
	    			name: 'BUDG_BASE',
	    			inputValue: '2'
	    		}]
	        }]			
		}, {
			xtype: 'fieldset',
			title: '기간비용관리',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				html: "<font color = 'blue' >기간비용을</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '월할로 계산한다.',
	    			width: 150,
	    			name: 'REPAY_METHOD',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '일할로 계산한다.',
	    			width: 150,
	    			name: 'REPAY_METHOD',
	    			inputValue: '2'
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >기간비용이 누락된 경우</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '당월계산시 반영한다.',
	    			width: 150,
	    			name: 'REPAY_COMPUTE',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '기말계산시 반영한다.',
	    			name: 'REPAY_COMPUTE',
	    			inputValue: '2'
	    		}]
	        }]			
		}, {
			xtype: 'fieldset',
			title: '고정자산관리',
			layout: {type: 'uniTable', columns: 2},
			items:[{
                border: false,
                html: "<font color = 'blue' >자산코드를 자동채번하시겠습니까?</font>",
                width: 350
            }, {
                xtype: 'radiogroup',
                items: [{
                    boxLabel: '예',
                    width: 150,
                    name: 'ASST_AUTOCD',
                    inputValue: '1'
//                  checked: true
                }, {
                    boxLabel: '아니오',
                    width: 150,
                    name: 'ASST_AUTOCD',
                    inputValue: '2'
                }]
            },{
                border: false,
                html: "<font color = 'blue' >국고보조금관리</font>",
                width: 350
            }, {
                xtype: 'radiogroup',
                items: [{
                    boxLabel: '예',
                    width: 150,
                    name: 'GOV_GRANT_CONT',
                    inputValue: '1'
//                  checked: true
                }, {
                    boxLabel: '아니오',
                    width: 150,
                    name: 'GOV_GRANT_CONT',
                    inputValue: '2'
                }]
            }, {
				border: false,
				html: "<font color = 'blue' >자산의 매각/폐기는</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '당월상각 전에 반영한다. ',
	    			width: 150,
	    			name: 'SALE_BASE',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '당월상각 후에 반영한다.',
	    			width: 150,
	    			name: 'SALE_BASE',
	    			inputValue: '2'
//	    			checked: true
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >매각/폐기시 상각비는</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '일할로 계산한다.',
	    			width: 150,
	    			name: 'SALE_METHOD',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '월할로 계산한다.',
	    			name: 'SALE_METHOD',
	    			inputValue: '2'
//	    			checked: true
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >비망가액처리는</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '1,000원 * 수량',
	    			width: 150,
	    			name: 'ASST_QTY_YN',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '1,000원',
	    			name: 'ASST_QTY_YN',
	    			inputValue: '2',	    			
	    			width: 150
	    			
	    		}, {
	    			boxLabel: '남기지 않는다(IFRS만 적용)',
	    			name: 'ASST_QTY_YN',
	    			inputValue: '3',	    			
	    			width: 180
	    		}]
	        }, {
				border: false,
				html: "<font color = 'blue' >무형자산 비망가액을</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '남긴다.',
	    			width: 150,
	    			name: 'ASST_PRICE_YN',
	    			inputValue: '1'
//	    			checked: true
	    		}, {
	    			boxLabel: '남기지 않는다.',
	    			name: 'ASST_PRICE_YN',
	    			inputValue: '2'
	    		}]
	        }]			
		}, {
			xtype: 'fieldset',
			title: '부가세설정',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 2},
				items:[{
					border: false,
					html: "<font color = 'blue' >부가세 신고시</font>",
					width: 350
				}, {
		    		xtype: 'radiogroup',
		    		items: [{
		    			boxLabel: '사업자단위신고.납부자가 아닌 일반 사업자로 신고한다. ',
		    			name: 'TAX_BASE',
		    			inputValue: '0'
//	    				checked: true
		    		}]
		        }, {
					border: false,
					html: " ",
					width: 350
				}, {
		    		xtype: 'radiogroup',
		    		items: [{
		    			boxLabel: '총괄납부사업자로 신고한다.',
		    			name: 'TAX_BASE',
		    			inputValue: '2'
		    		}]
		        }, {
					border: false,
					html: " ",
					width: 350
				}, {
		    		xtype: 'radiogroup',
		    		items: [{
		    			boxLabel: '사업자단위신고.과세적용사업장으로 신고한다.',
		    			name: 'TAX_BASE',
		    			inputValue: '5'
		    		}]
		    	}]
	        }, {
	        	xtype: 'container',
				layout: {type: 'uniTable', columns: 2},
				items:[{
					border: false,
					html: "<font color = 'blue' >사업자단위신고.과세적용사업장 또는 총괄납부사업자로 신고할 때의</font>",
					width: 370
				}, {
		    		xtype: 'hiddenfield',
		    		hidden: false
		        }, {
					border: false,
					layout: {type: 'uniTable', columns: 3},
					items: [{
						name: '',
						html: "<font color = 'blue' >총괄신고사업장은</font>",
						width: 110,
						border: false
					}, {
			            xtype: 'uniCombobox', 
			            comboType: 'BOR120',
			            name:'BILL_DIV_CODE',
			//2020-07-27 사업자단위신고, 납부가가 아닌 일반 사업자로 신고한다를 선택시 총괄신고사업장은 선택하지 않아도 저장이 되도록 변경함
			//            allowBlank: false,
						value: '01'
					}, {					
						html: '&nbsp;이다.',
						width: 60,
						border: false
					}]
					
				}, {
		    		xtype: 'hiddenfield',
		    		hidden: false	    		
		        }, {
					border: false,
					border: false,
					layout: {type: 'uniTable', columns: 3},
					items: [{
						html: "<font color = 'blue' >납부승인번호는</font>",
						width: 110,
						border: false
					}, {
			            xtype: 'uniTextfield',
			            name: 'APP_NUM'
					}, {					
						html: '&nbsp;이다.',
						width: 60,
						border: false
					}]
		        }]
			}]			
		}, {
			xtype: 'fieldset',
			title: '원가대체기준',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				html: "<font color = 'blue' >원가대체 입력시 재고금액을</font>",
				width: 350
			}, {
	    		xtype: 'radiogroup',
	    		items: [{
	    			boxLabel: '참조한다.',
	    			width: 150,
	    			name: 'MATRL_YN',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '참조하지 않는다.',
	    			name: 'MATRL_YN',
	    			inputValue: '2'
//	    			checked: true
	    		}]
	        }]			
		}, {
			xtype: 'fieldset',
			title: '전자장부관리',
			layout: {type: 'uniTable', columns: 3},
			items:[{
				border: false,
				html: "수정삭제이력의 데이타를 삭제할 수 있는 기간은&nbsp;&nbsp;"
			},{
	    		xtype: 'uniNumberfield',
	    		name: 'DEL_DATE',
	    		width: 50,
	    		allowBlank: false,
	    		defaultAlign: 'right',
					listeners	: {
						blur: function( field, event, eOpts ) { 
							if(field.lastValue < 1 || field.lastValue > 31){
								alert('수정삭제이력의 데이타를 삭제할 수 있는 기간은 1일부터 31일까지 설정가능 합니다.');
								panelDetail.down('#tab_aba100ukr').setValue('DEL_DATE','');
							}
						}
					}
	        },{
	        	border: false,
				html: "&nbsp;&nbsp;일이다. ( 1일 ~ 31일 설정가능)"
	        },{
	            xtype: 'uniTextfield',
	            name: 'BASE_CODE',
	            hidden: true
			},{
	            xtype: 'uniTextfield',
	            name: 'CIRCUL_ACCNT',
	            hidden: true
			},{
	            xtype: 'uniTextfield',
	            name: 'CONT_ACCNT',
	            hidden: true
			},{
	            xtype: 'uniTextfield',
	            name: 'SELL_ACCNT',
	            hidden: true
			},{
	            xtype: 'uniTextfield',
	            name: 'REPAY_BASE',
	            hidden: true
			}]			
		}
			
				
					
	/*					
							{
            xtype: 'fieldset',
            title: '경비처리기준',
            layout: {type: 'uniTable', columns: 2},
            items:[{
                border: false,
                html: "<font color = 'blue' >경비최종결재 후 자동승인</font>",
                width: 350
            }, {
                xtype: 'radiogroup',
                items: [{
                    boxLabel: '예',
                    width: 150,
                    name: 'PAY_AP_BASE',
                    inputValue: '1'
//                  checked: true
                }, {
                    boxLabel: '아니오',
                    width: 150,
                    name: 'PAY_AP_BASE',
                    inputValue: '2'
                }]
            },{
                border: false,
                html: "<font color = 'blue' >경비유형 사용</font>",
                width: 350
            }, {
                xtype: 'radiogroup',
                items: [{
                    boxLabel: '예',
                    width: 150,
                    name: 'PAY_TYPE',
                    inputValue: '1'
//                  checked: true
                }, {
                    boxLabel: '아니오',
                    width: 150,
                    name: 'PAY_TYPE',
                    inputValue: '2'
                }]
            },{
                border: false,
                html: "<font color = 'blue' >사업코드 사용</font>",
                width: 350
            }, {
                xtype: 'radiogroup',
                items: [{
                    boxLabel: '예',
                    width: 150,
                    name: 'PJT_CODE_ESS',
                    inputValue: '1'
//                  checked: true
                }, {
                    boxLabel: '아니오',
                    width: 150,
                    name: 'PJT_CODE_ESS',
                    inputValue: '2'
                }]
            },{
                border: false,
                html: "<font color = 'blue' >제품코드 사용</font>",
                width: 350
            }, {
                xtype: 'radiogroup',
                items: [{
                    boxLabel: '예',
                    width: 150,
                    name: 'ITEM_CODE_ESS',
                    inputValue: '1'
//                  checked: true
                }, {
                    boxLabel: '아니오',
                    width: 150,
                    name: 'ITEM_CODE_ESS',
                    inputValue: '2'
                }]
            }]          
		}*/
		
		
		
		],
		listeners: {
           	afterrender: function(form) {
           		form.getForm().load();
           	},
			dirtychange:function( basicForm, dirty, eOpts ) {
				UniAppManager.setToolbarButtons('save', true);
			}
		}
	}