<%@page language="java" contentType="text/html; charset=utf-8"%>
<% String aaa = request.getParameter("aaa");%>
	var gsinit1 = false;
	var gsinit2 = false;
	var gsinit3 = false;

	var autoFieldset = {
		layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
		defaultType	: 'uniFieldset',
		masterGrid	: masterGrid,
		defaults	: { padding: '10 15 15 10'},
		colspan		: 3,
		id			: 'autoCodeFieldset',
//		hidden		: true,
		items		: [{
			title	: '품목코드 채번 (월드와이드메모리)',
			defaults: {type: 'uniTextfield'	, labelWidth:100},
			layout	: {type: 'uniTable'		, columns: 3},
			items	: [{
				fieldLabel	: '신규품목계정',
				name		: 'AUTO_ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('AUTO_ITEM_LEVEL1'	, '');
						detailForm.setValue('AUTO_ITEM_LEVEL2'	, '');
						detailForm.setValue('AUTO_ITEM_LEVEL3'	, '');
						detailForm.setValue('AUTO_MAN1'			, '');
						detailForm.setValue('AUTO_MAN2'			, '');
						detailForm.setValue('AUTO_MAN3'			, '');
						detailForm.setValue('LAST_ITEM_CODE'	, '');
						detailForm.setValue('AUTO_ITEM_CODE'	, '');

						//20201113 주석: 품목계정은 채번 시 사용하지 않음
/*						if(!Ext.isEmpty(newValue)) {
							if(!Ext.isEmpty(field.valueCollection.items[0]) && !Ext.isEmpty(field.valueCollection.items[0].data.refCode6)){
								detailForm.setValue('AUTO_MAN', field.valueCollection.items[0].data.refCode6);
							} else {
								Unilite.messageBox('채번 코드가 존재하지 않습니다.');
								detailForm.setValue('AUTO_ITEM_ACCOUNT', '');
								return false;
							}
						}*/
					}
				}
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 3},
				padding	: '0 0 3 0',
				colspan	: 2,
				items	: [{
					fieldLabel	: '<t:message code="system.label.base.itemgroup" default="품목분류"/>',
					name		: 'AUTO_ITEM_LEVEL1',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('bpr300ukrvLevel1Store'),
					child		: 'AUTO_ITEM_LEVEL2',
					labelWidth	: 138,
					width		: 298,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							//20200928 추가
							if(Ext.isEmpty(newValue)) {
								detailForm.setValue('AUTO_MAN1', '');
								detailForm.setValue('AUTO_MAN2', '');
								detailForm.setValue('AUTO_MAN3', '');
							}
							if(newValue != 'ZZ' && !Ext.isEmpty(newValue)) {
								//20201113 주석: 품목계정은 채번 시 사용 안 함
/*								if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_ACCOUNT'))) {
									Unilite.messageBox('품목계정을 입력하세요');
									detailForm.setValue('AUTO_ITEM_LEVEL1', '');
									return false;
								}*/
								detailForm.setValue('LAST_ITEM_CODE'	, '');
								detailForm.setValue('AUTO_ITEM_CODE'	, '');
								if(!Ext.isEmpty(field.valueCollection.items[0]) && !Ext.isEmpty(field.valueCollection.items[0].data.refCode10)){
									detailForm.setValue('AUTO_MAN1', field.valueCollection.items[0].data.refCode10);
								} else {
									Unilite.messageBox('채번 코드가 존재하지 않습니다.');
									detailForm.setValue('AUTO_ITEM_LEVEL1', '');
									return false;
								}
	
								if(!Ext.isEmpty(newValue)) {
									detailForm.setValue('AUTO_MAN2', '');
									detailForm.setValue('AUTO_MAN3', '');
									var itemLevel2 = Ext.data.StoreManager.lookup('bpr300ukrvLevel2Store').data.items;
									var basisValue = '';
									Ext.each(itemLevel2,function(record, i) {
										if(record.get('option') == newValue) {
											basisValue = record.get('value');
										}
									})
									if(Ext.isEmpty(basisValue)) {
										detailForm.setValue('AUTO_MAN2', 'ZZ');
										detailForm.setValue('AUTO_MAN3', 'ZZ');

										//20200925 추가: 신/중고구분 추가로 체크로직 추가, 20201113 주석
/*										if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_DIVISION'))) {
											Unilite.messageBox('신/중고 구분을 입력하세요.');
											detailForm.getField('AUTO_ITEM_DIVISION').focus();
										} else {
											var param = detailForm.getValues();
											S_Bpr300ukrv_wm_itemCodeService.selectAutoItemCode(param, function(provider, response) {
												if(!Ext.isEmpty(provider))	{
													detailForm.setValue('AUTO_ITEM_CODE', provider.AUTO_ITEM_CODE);
													detailForm.setValue('LAST_ITEM_CODE', provider.LAST_ITEM_CODE);
													detailForm.setValue('LAST_SEQ'		, provider.LAST_SEQ);
												}else{
													detailForm.setValue('LAST_SEQ'		, provider.LAST_SEQ);
												}
											})
										}*/
									}
								}
							}
						}
					}
				},{
					fieldLabel	: '',
					name		: 'AUTO_ITEM_LEVEL2',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('bpr300ukrvLevel2Store'),
					child		: 'AUTO_ITEM_LEVEL3',
					width		: 145,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							//20200928 추가
							if(Ext.isEmpty(newValue)) {
								detailForm.setValue('AUTO_MAN2', '');
								detailForm.setValue('AUTO_MAN3', '');
							}
							if(newValue != 'ZZ' && !Ext.isEmpty(newValue)) {
								detailForm.setValue('LAST_ITEM_CODE'	, '');
								detailForm.setValue('AUTO_ITEM_CODE'	, '');
								if(!Ext.isEmpty(field.valueCollection.items[0]) && !Ext.isEmpty(field.valueCollection.items[0].data.refCode10)){
									detailForm.setValue('AUTO_MAN2', field.valueCollection.items[0].data.refCode10);
								} else {
									Unilite.messageBox('채번 코드가 존재하지 않습니다.');
									detailForm.setValue('AUTO_ITEM_LEVEL2', '');
									return false;
								}
								if(!Ext.isEmpty(newValue)) {
									detailForm.setValue('AUTO_MAN3', '');
		
									var itemLevel3 = Ext.data.StoreManager.lookup('bpr300ukrvLevel3Store').data.items;
									var basisValue = '';
									Ext.each(itemLevel3,function(record, i) {
										if(record.get('option') == newValue) {
											basisValue = record.get('value');
										}
									})
									if(Ext.isEmpty(basisValue)) {
										detailForm.setValue('AUTO_MAN3', 'ZZ');

										//20200925 추가: 신/중고구분 추가로 체크로직 추가, 20201113 주석
/*										if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_DIVISION'))) {
											Unilite.messageBox('신/중고 구분을 입력하세요.');
											detailForm.getField('AUTO_ITEM_DIVISION').focus();
										} else {
											var param = detailForm.getValues();
											S_Bpr300ukrv_wm_itemCodeService.selectAutoItemCode(param, function(provider, response) {
												if(!Ext.isEmpty(provider))	{
													detailForm.setValue('AUTO_ITEM_CODE', provider.AUTO_ITEM_CODE);
													detailForm.setValue('LAST_ITEM_CODE', provider.LAST_ITEM_CODE);
													detailForm.setValue('LAST_SEQ'		, provider.LAST_SEQ);
												}else{
													detailForm.setValue('LAST_SEQ'		, provider.LAST_SEQ);
												}
											})
										}*/
									}
								}
							}
						}
					}
				},{
					fieldLabel	: '',
					name		: 'AUTO_ITEM_LEVEL3',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('bpr300ukrvLevel3Store'),
					width		: 145,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							//20200928 추가
							if(Ext.isEmpty(newValue)) {
								detailForm.setValue('AUTO_MAN3', '');
							}
							if(newValue != 'ZZ' && !Ext.isEmpty(newValue)) {
								detailForm.setValue('LAST_ITEM_CODE'	, '');
								detailForm.setValue('AUTO_ITEM_CODE'	, '');
								if(!Ext.isEmpty(field.valueCollection.items[0]) && !Ext.isEmpty(field.valueCollection.items[0].data.refCode10)){
									detailForm.setValue('AUTO_MAN3', field.valueCollection.items[0].data.refCode10);
								} else {
									Unilite.messageBox('채번 코드가 존재하지 않습니다.');
									detailForm.setValue('AUTO_ITEM_LEVEL3', '');
									return false;
								}
								if(!Ext.isEmpty(newValue)) {
									//20200925 추가: 신/중고구분 추가로 체크로직 추가, 20201113 주석
/*									if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_DIVISION'))) {
										Unilite.messageBox('신/중고 구분을 입력하세요.');
										detailForm.getField('AUTO_ITEM_DIVISION').focus();
									} else {
										var param = detailForm.getValues();
										S_Bpr300ukrv_wm_itemCodeService.selectAutoItemCode(param, function(provider, response) {
											if(!Ext.isEmpty(provider))	{
												detailForm.setValue('AUTO_ITEM_CODE', provider.AUTO_ITEM_CODE);
												detailForm.setValue('LAST_ITEM_CODE', provider.LAST_ITEM_CODE);
												detailForm.setValue('LAST_SEQ'		, provider.LAST_SEQ);
											}else{
												detailForm.setValue('LAST_SEQ'		, provider.LAST_SEQ);
											}
										})
									}*/
								}
							}
						}
					}
				}]
			},{
				fieldLabel	: '최종품목코드',
				xtype		: 'uniTextfield',
				name		: 'LAST_ITEM_CODE',
				readOnly	: true
			},{
				xtype	: 'container',
				layout	: {type : 'table', columns : 3},
//				tdAttrs	: {align: 'right'},
				width	: 150,
				colspan	: 2,
				items	: [{
					//20200925 추가
					fieldLabel	: '신/중고구분',
					name		: 'AUTO_ITEM_DIVISION',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B144',
					labelWidth	: 138,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							detailForm.setValue('AUTO_MAN4', newValue);
							if(!Ext.isEmpty(newValue)) {
								//20200928 추가
								if(!Ext.isEmpty(detailForm.getValue('AUTO_MAN1')) && !Ext.isEmpty(detailForm.getValue('AUTO_MAN2')) && !Ext.isEmpty(detailForm.getValue('AUTO_MAN3'))) {
									var param = detailForm.getValues();
									S_Bpr300ukrv_wm_itemCodeService.selectAutoItemCode(param, function(provider, response) {
										if(!Ext.isEmpty(provider))	{
											detailForm.setValue('AUTO_ITEM_CODE', provider.AUTO_ITEM_CODE);
											detailForm.setValue('LAST_ITEM_CODE', provider.LAST_ITEM_CODE);
											detailForm.setValue('LAST_SEQ'		, provider.LAST_SEQ);
										}else{
											detailForm.setValue('LAST_SEQ'		, provider.LAST_SEQ);
										}
									})
								} else {
									Unilite.messageBox('품목분류를 입력하세요');
									return false;
								}
							}
						}
					}
				},{
					xtype: 'component',
					width: 195
				},{
					xtype	: 'button',
					text	: '채번 확정',
					width	: 100,
					handler	: function() {
						//20201113 주석: 품목계정은 채번 시 사용하지 않음
/*						if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_ACCOUNT'))) {
							Unilite.messageBox('신규 품목계정 값이 없습니다.');
							return false;
						} else*/ if(Ext.isEmpty(detailForm.getValue('AUTO_ITEM_CODE'))) {
							Unilite.messageBox('신규 품목코드 값이 없습니다.');
							return false;
						} else if(!Ext.isEmpty(detailForm.getValue('ITEM_CODE'))) {
							Unilite.messageBox('이미 품목코드 값이 입력되어있습니다.');
							return false;
						} else {
							var param = detailForm.getValues();
							//확정된 데이터 BAUTONOT 등록
							S_Bpr300ukrv_wm_itemCodeService.saveAutoItemCode(param, function(provider, response) {
								if(!Ext.isEmpty(provider)) {
									if(provider == 'Y') {
										detailForm.setValue('ITEM_CODE'		, detailForm.getValue('AUTO_ITEM_CODE'));
										detailForm.setValue('ITEM_ACCOUNT'	, detailForm.getValue('AUTO_ITEM_ACCOUNT'), false);
										detailForm.setValue('ITEM_NAME'		, detailForm.getValue('AUTO_ITEM_NAME'));
										detailForm.setValue('ITEM_LEVEL1'	, detailForm.getValue('AUTO_ITEM_LEVEL1'));
										detailForm.setValue('ITEM_LEVEL2'	, detailForm.getValue('AUTO_ITEM_LEVEL2'));
										detailForm.setValue('ITEM_LEVEL3'	, detailForm.getValue('AUTO_ITEM_LEVEL3'));
										detailForm.setValue('ITEM_DIVISION'	, detailForm.getValue('AUTO_ITEM_DIVISION'));	//20200925 추가
										detailForm.getField('ITEM_CODE').setReadOnly(true);
										detailForm.getField('ITEM_ACCOUNT').setReadOnly(true);
										detailForm.getField('ITEM_LEVEL1').setReadOnly(true);
										detailForm.getField('ITEM_LEVEL2').setReadOnly(true);
										detailForm.getField('ITEM_LEVEL3').setReadOnly(true);
										detailForm.getField('ITEM_DIVISION').setReadOnly(true);							//20200925 추가
										//20201113 추가: 품목코드 채번 필드 초기화
										detailForm.setValue('AUTO_ITEM_ACCOUNT'	, '');
										detailForm.setValue('AUTO_ITEM_LEVEL1'	, '');
										detailForm.setValue('AUTO_ITEM_LEVEL2'	, '');
										detailForm.setValue('AUTO_ITEM_LEVEL3'	, '');
										detailForm.setValue('LAST_ITEM_CODE'	, '');
										detailForm.setValue('AUTO_ITEM_DIVISION', '');
										detailForm.setValue('AUTO_MAN'			, '');
										detailForm.setValue('AUTO_MAN1'			, '');
										detailForm.setValue('AUTO_MAN2'			, '');
										detailForm.setValue('AUTO_MAN3'			, '');
										detailForm.setValue('AUTO_MAN4'			, '');
										detailForm.setValue('LAST_SEQ'			, '');
										detailForm.setValue('AUTO_ITEM_CODE'	, '');
										detailForm.setValue('AUTO_ITEM_NAME'	, '');
									}else{
										Unilite.messageBox('확정 실패');
									}
								}else{
									Unilite.messageBox('확정 실패');
								}
							});
						}
					}
				}]
			},{	//구분자(품목계정)
				fieldLabel	: '품목계정',
				xtype		: 'uniTextfield',
				name		: 'AUTO_MAN',
				hidden		: true
			},{	//구분자(대분류)
				fieldLabel	: '대분류',
				xtype		: 'uniTextfield',
				name		: 'AUTO_MAN1',
				hidden		: true
			},{	//구분자(중분류)
				fieldLabel	: '중분류',
				xtype		: 'uniTextfield',
				name		: 'AUTO_MAN2',
				hidden		: true
			},{	//구분자(소분류)
				fieldLabel	: '소분류',
				xtype		: 'uniTextfield',
				name		: 'AUTO_MAN3',
				hidden		: true
			},{	//20200925 추가: 신/중고구분 추가로 체크로직 추가
				fieldLabel	: '신/중고구분',
				xtype		: 'uniTextfield',
				name		: 'AUTO_MAN4',
				hidden		: true
			},{
				fieldLabel	: 'LAST_SEQ',
				xtype		: 'uniTextfield',
				name		: 'LAST_SEQ',
				hidden		: true
			},{
				fieldLabel	: '신규품목코드',
				xtype		: 'uniTextfield',
				name		: 'AUTO_ITEM_CODE',
				readOnly	: true
			},{
				fieldLabel	:'신규품명',
				xtype		: 'uniTextfield',
				name		: 'AUTO_ITEM_NAME',
				width		: 590,
				colspan		: 2,
				labelWidth	: 138,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('ITEM_NAME', newValue);
					}
				}
			}]
		}]
	}