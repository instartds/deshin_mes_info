<%@page language="java" contentType="text/html; charset=utf-8"%>
	var operating_Criteria = {
//		itemId	: 'operating_Criteria',
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			title		: '<t:message code="system.label.sales.salesbasesetting" default="영업기준설정"/>',
			itemId		: 'tab_operating',
			xtype		: 'uniDetailForm',
			layout		: {type: 'hbox', align:'stretch'},
			flex		: 1,
 			autoScroll	: false,
 			disabled	: false,
			api			: {
				load	: 'sbs020ukrvService.selectForm',
				submit	: 'sbs020ukrvService.syncForm'
			},
 			items		: [{
				xtype		: 'uniDetailForm',
 				disabled	: false,
				dockedItems	: [{
					xtype	: 'toolbar',
					dock	: 'top',
					padding	: '0px',
					border	: 0,
					padding	: '0 0 0 0'
				}],
				layout	: {type: 'vbox', align: 'stretch' ,padding: '0 0 0 0'},
				items	: [{
					xtype	: 'fieldset',
					title	: '<t:message code="system.label.sales.automaticnumbering" default="자동채번"/><t:message code="system.label.sales.settings" default="설정"/>',
					layout	: {type: 'uniTable', columns: 2},
					items	: [{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>[견적번호를 자동채번하시겠습니까?]</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							name		: 'S012_1',
							inputValue	: 'Y',
							width		: 150
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							name		: 'S012_1',
							inputValue	: 'N',
							width		: 150
						}]
					},{
						name	: '',
						html	: "<font color = 'blue'>[수주번호를 자동채번하시겠습니까?]</font>",
						border	: false,
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							width		: 150,
							name		: 'S012_2',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							width		: 150,
							name		: 'S012_2',
							inputValue	: 'N'
						}]
					},{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>[출하지시번호를 자동채번하시겠습니까?]</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							width		: 150,
							name		: 'S012_8',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							width		: 150,
							name		: 'S012_8',
							inputValue	: 'N'
						}]
					},{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>[출고번호를 자동채번하시겠습니까?]</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							width		: 150,
							name		: 'S012_3',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							width		: 150,
							name		: 'S012_3',
							inputValue	: 'N'
						}]
					},{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>[반품번호를 자동채번하시겠습니까?]</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							width		: 150,
							name		: 'S012_4',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							width		: 150,
							name		: 'S012_4',
							inputValue	: 'N'
						}]
					},{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>[입고번호를 자동채번하시겠습니까?]</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							width		: 150,
							name		: 'S012_5',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							width		: 150,
							name		: 'S012_5',
							inputValue	: 'N'
						}]
					},{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>[계산서번호를 자동채번하시겠습니까?]</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							width		: 150,
							name		: 'S012_6',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							width		: 150,
							name		: 'S012_6',
							inputValue	: 'N'
						}]
					},{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>[수금번호를 자동채번하시겠습니까?]</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							width		: 150,
							name		: 'S012_7',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							width		: 150,
							name		: 'S012_7',
							inputValue	: 'N'
						}]
					}]
				},{
					xtype	: 'fieldset',
					title	: '<t:message code="system.label.sales.salesplan" default="판매계획"/><t:message code="system.label.sales.settings" default="설정"/>',
					layout	: {type: 'uniTable', columns: 1},
					items	: [{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>판매계획을 입력할 항목을 선택하십시요.</font>",
						width	: 350
					},{
						xtype		: 'uniCheckboxgroup',
						fieldLabel	: '',
						items		: [{
							boxLabel	: '<t:message code="system.label.sales.clientby" default="고객별"/>',
							width		: 100,
							name		: 'S022_1',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.saleschargeby" default="영업담당별"/>',
							width		: 100,
							name		: 'S022_2',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.itemby" default="품목별"/>',
							width		: 100,
							name		: 'S022_3',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.itemgroupby" default="품목분류별"/>',
							width		: 100,
							name		: 'S022_4',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.repmodelby" default="대표모델별"/>',
							width		: 100,
							name		: 'S022_5',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.clientitemby" default="고객품목별"/>',
							width		: 100,
							name		: 'S022_6',
							inputValue	: 'Y'
						},{
							boxLabel	: '<t:message code="system.label.sales.sellingtypeby" default="판매유형별"/>',
							width		: 100,
							name		: 'S022_9',
							inputValue	: 'Y'
						}]
					}]
				},{
					xtype	: 'fieldset',
					title	: '여신설정',
					layout	: {type: 'uniTable', columns: 2},
					items	: [{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>여신관리시점은</font>",
						width	: 350
					},{
						xtype		: 'radiogroup',
						hideLabel	: true,
						items		: [{
							boxLabel	: '수주시점',
							width		: 150,
							name		: 'S026_1',
							inputValue	: '1'
						},{
							boxLabel	: '출고시점',
							width		: 150,
							name		: 'S026_1',
							inputValue	: '2'
						},{
							boxLabel	: '매출시점',
							width		: 150,
							name		: 'S026_1',
							inputValue	: '3'
						},{
							boxLabel	: '미적용',
							width		: 150,
							name		: 'S026_1',
							inputValue	: '4'
						}]
					},{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>어음 여신 적용시</font>",
						width	: 350
					},{
						xtype		: 'radiogroup',
						hideLabel	: true,
						items		: [{
							boxLabel	: '자수어음만 관리',
							width		: 150,
							name		: 'S019_1',
							inputValue	: '1'
						},{
							boxLabel	: '자수/타수어음  관리',
							width		: 150,
							name		: 'S019_1',
							inputValue	: '2'
						},{
							boxLabel	: '관리하지 않음',
							width		: 150,
							name		: 'S019_1',
							inputValue	: '3'
						}]
					},{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>신용여신액 초과시</font>",
						width	: 350
					},{
						xtype		: 'radiogroup',
						hideLabel	: true,
						items		: [{
							boxLabel	: '경고',
							width		: 150,
							name		: 'S181_1',
							inputValue	: 'W'
						},{
							boxLabel	: '오류',
							width		: 150,
							name		: 'S181_1',
							inputValue	: 'E'
						}]
					}]
				},{
					xtype	: 'fieldset',
					title	: '<t:message code="system.label.sales.vatrate" default="부가세율"/>',
					layout	: {type: 'uniTable', columns: 2},
					items	: [{
						border	: false,
						html	: "부가세율&nbsp;&nbsp;&nbsp;&nbsp;"
					},{
						//S028
						xtype		: 'uniNumberfield',
						name		: 'TAX',
						width		: 90,
						allowBlank	: false,
						defaultAlign: 'right',
						suffixTpl	: '&nbsp;%'
					}]
				},{
					xtype	: 'fieldset',
					title	: '기초잔액생성',
					layout	: {type: 'uniTable', columns: 2},
					items	: [{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>기초잔액은</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '회계에서 등록한다.',
							width		: 150,
							name		: 'S025_1',
							inputValue	: '1'
						},{
							boxLabel	: '영업에서 등록한다.',
							width		: 150,
							name		: 'S025_1',
							inputValue	: '2'
						}]
					}]
				},{
					xtype	: 'fieldset',
					title	: '수주등록내 설정',
					layout	: {type: 'uniTable', columns: 2},
					items	: [{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>생산완료일은</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '자동설정으로 한다.',
							width		: 150,
							name		: 'S031_1',
							inputValue	: '1'
						},{
							boxLabel	: '수동설정으로 한다.',
							width		: 150,
							name		: 'S031_1',
							inputValue	: '2'
						}]
					}]
				},{
					xtype	: 'fieldset',
					title	: '매출사업장 지정',
					layout	: {type: 'uniTable', columns: 2},
					items	: [{
						border	: false,
						name		: '',
						html	: "<font color = 'blue'>매출사업장은</font>",
						width		: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '영업담당의 사업장으로 한다.',
							width		: 150,
							name		: 'S029_1',
							inputValue	: '1'
						},{
							boxLabel	: '출고사업장으로 한다.',
							width		: 150,
							name		: 'S029_1',
							inputValue	: '2'
						}]
					}]
				},{
					xtype	: 'fieldset',
					title	: '출고등록시 자동매출생성/삭제여부',
					layout	: {type: 'uniTable', columns: 2},
					items	: [{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>출고등록시 매출 생성/삭제를</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '자동으로 한다.(국내)',
							width		: 150,
							name		: 'S033_1',
							inputValue	: '1'
						},{
							boxLabel	: '자동으로 하지 않는다.',
							width		: 150,
							name		: 'S033_1',
							inputValue	: '2'
						},{
							boxLabel	: '자동으로 한다.(국내/외)',
							width		: 150,
							name		: 'S033_1',
							inputValue	: '3'
						}]
					}]
				},{
					xtype	: 'fieldset',
					title	: '반품등록시 자동매출생성/삭제여부',
					layout	: {type: 'uniTable', columns: 2},
					items	: [{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>반품등록시 매출 생성/삭제를</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '자동으로 한다.',
							width		: 150,
							name		: 'S034_1',
							inputValue	: '1'
						},{
							boxLabel	: '자동으로 하지 않는다.',
							width		: 150,
							name		: 'S034_1',
							inputValue	: '2'
						}]
					}]
				},{
					xtype	: 'fieldset',
					title	: '매출등록시 자동출고생성/삭제여부',
					layout	: {type: 'uniTable', columns: 2},
					items	: [{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>매출등록시 출고 생성/삭제를</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '자동으로 한다.',
							width		: 150,
							name		: 'S035_1',
							inputValue	: '1'
						},{
							boxLabel	: '자동으로 하지 않는다.',
							width		: 150,
							name		: 'S035_1',
							inputValue	: '2'
						}]
					},{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>매출등록시 반품 수정/삭제를</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '자동으로 한다.',
							width		: 150,
							name		: 'S038_1',
							inputValue	: '1'
						},{
							boxLabel	: '자동으로 하지 않는다.',
							width		: 150,
							name		: 'S038_1',
							inputValue	: '2'
						}]
					}]
				},{
					xtype	: 'fieldset',
					title	: '수주승인 사용여부',
					layout	: {type: 'uniTable', columns: 3},
					items	: [{
						border	: false,
						name	: '',
						html	: "<font color = 'blue'>수주관리중 수주승인 단계를 사용하시겠습니까?</font>",
						width	: 350
					},{
						xtype: 'radiogroup',
						items: [{
							boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
							width		: 150,
							name		: 'S044_1',
							inputValue	: '1'
						},{
							boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
							width		: 150,
							name		: 'S044_1',
							inputValue	: '2'
						}]
					},
					<!-- 2020-12-11 추가 -->
					Unilite.popup('USER',{
						colspan:3, allowBlank:true, 
						textFieldWidth:170, valueFieldWidth:100,
						textFieldName: 'S044_2_NAME',
						valueFieldName: 'S044_2_CODE',
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