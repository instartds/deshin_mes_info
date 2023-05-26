<%@page language="java" contentType="text/html; charset=utf-8"%>
var makeAliasWindow

var makeAlias = Unilite.createForm('bsa300ukrvmakeAlias', {
	itemId		: 'bsa300ukrvmakeAlias',
	region		: 'center',
	layout		: {type:'uniTable', columns: 1},
	disabled	: false,
	border		: true,
	padding		: 0,
	items		: [{
		xtype	: 'component',
		hight	: 30
	},{
		fieldLabel			: '고객사',
		name				: 'CUSTOM_CODE',
		xtype				: 'uniTextfield',
		maxLength			: 4,
		enforceMaxLength	: true,
		allowBlank			: false,
		listeners			: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		xtype	: 'component',
		html	: '-',
		margin	: '0 0 0 100'
	},{
		fieldLabel			: '제품명',
		name				: 'ITEM_NAME',
		xtype				: 'uniTextfield',
		maxLength			: 4,
		enforceMaxLength	: true,
		allowBlank			: false,
		listeners			: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel	: '기초/색조',
		name		: 'COLOR',
		xtype		: 'uniCombobox',
		comboType	: 'AU',
		comboCode	: 'KA01',
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel	: '세트구분',
		name		: 'SET_GUBUN',
		xtype		: 'uniCombobox',
		comboType	: 'AU',
		comboCode	: 'KA02',
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel			: '구성수',
		name				: 'COMPONENTS_NO',
		xtype				: 'uniNumberfield',
		type				: 'int',
		maxLength			: 2,
		enforceMaxLength	: true,
		listeners			: {
			change: function(combo, newValue, oldValue, eOpts) {
				if(newValue > 25) {
					Unilite.messageBox('25보다 작은 수를 넣으시오.');
					makeAlias.setValue('COMPONENTS_NO', oldValue);
					return false;
				}
				fnMakeAlias();
			}
		}
	},{
		fieldLabel	: '컬러구분',
		name		: 'COLOR_GUBUN',
		xtype		: 'uniCombobox',
		comboType	: 'AU',
		comboCode	: 'KA03',
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel	: '기능성구분',
		name		: 'FUNCTIONAL_GUBUN',
		xtype		: 'uniCombobox',
		comboType	: 'AU',
		comboCode	: 'KA04',
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel	: '리뉴얼구분',
		name		: 'RENEWAL_GUBUN',
		xtype		: 'uniCombobox',
		comboType	: 'AU',
		comboCode	: 'KA05',
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel	: '수출전용구분',
		name		: 'EXPORT_GUBUN',
		xtype		: 'uniCombobox',
		comboType	: 'AU',
		comboCode	: 'KA06',
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel	: '본품 미품구분',
		name		: 'MAIN_GUBUN',
		xtype		: 'uniCombobox',
		comboType	: 'AU',
		comboCode	: 'KA07',
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		xtype: 'component',
		height: 30
	},{
		fieldLabel	: '약호',
		name		: 'ITME_ALIAS',
		xtype		: 'textareafield',
		labelWidth	: 40,
		width		: 250,
		height		: 50,
		readOnly	: true,
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	}]
});

var makeAlias2 = Unilite.createForm('bsa300ukrvmakeAlias2', {
	itemId		: 'bsa300ukrvmakeAlias',
	region		: 'center',
	layout		: {type:'uniTable', columns: 1},
	disabled	: false,
	border		: true,
	padding		: 0,
	items		: [{
		xtype	: 'component',
		hight	: 30
	},{
		fieldLabel			: '고객사',
		name				: 'CUSTOM_CODE',
		xtype				: 'uniTextfield',
		maxLength			: 4,
		enforceMaxLength	: true,
		allowBlank			: false,
		listeners			: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		xtype	: 'component',
		html	: '-',
		margin	: '0 0 0 100'
	},{
		fieldLabel			: '제품명',
		name				: 'ITEM_NAME',
		xtype				: 'uniTextfield',
		maxLength			: 4,
		enforceMaxLength	: true,
		allowBlank			: false,
		listeners			: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel	: '기초/색조',
		name		: 'COLOR',
		xtype		: 'uniCombobox',
		comboType	: 'AU',
		comboCode	: 'KA01',
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel			: '홋수넘버',
		name				: 'COMPONENTS_NO',
		xtype				: 'uniTextfield',
		maxLength			: 5,
		enforceMaxLength	: true,
		allowBlank			: false,
		listeners			: {
			change: function(combo, newValue, oldValue, eOpts) {
				if(Ext.isEmpty(newValue) || Ext.isNumber(parseInt(newValue.replace('-', '')))) {
					fnMakeAlias();
				} else {
					Unilite.messageBox('숫자와 [-]만 입력 가능합니다.');
					makeAlias2.setValue('COMPONENTS_NO', oldValue);
					return false;
				}
			}
		}
	},{
		fieldLabel			: '컬러구분',
		name				: 'COLOR_GUBUN',
		xtype				: 'uniTextfield',
		maxLength			: 2,
		enforceMaxLength	: true,
		listeners			: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		fieldLabel			: '리뉴얼구분',
		name				: 'RENEWAL_GUBUN',
		xtype				: 'uniTextfield',
		maxLength			: 2,
		enforceMaxLength	: true,
		listeners			: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	},{
		xtype: 'component',
		height: 30
	},{
		fieldLabel	: '약호',
		name		: 'ITME_ALIAS',
		xtype		: 'textareafield',
		labelWidth	: 40,
		width		: 250,
		height		: 50,
		readOnly	: true,
		listeners	: {
			change: function(combo, newValue, oldValue, eOpts) {
				fnMakeAlias();
			}
		}
	}]
});

var AliasPanel1 = Ext.create('Ext.panel.Panel', {
	region	: 'center',
	layout	: {
		type	: 'hbox',
		layout	: 'border',
		align	: 'stretch'
	},
	flex	: 1,
	items	: [
		makeAlias
	]
});

var AliasPanel2 = Ext.create('Ext.panel.Panel', {
	region	: 'south',
	layout	: {
		type	: 'hbox',
		layout	: 'border',
		align	: 'stretch'
	},
	flex	: 1,
	items	: [
		makeAlias2
	]
});


function openMakeAliasWindow() {
	if(!makeAliasWindow) {
		makeAliasWindow = Ext.create('widget.uniDetailWindow', {
			title	: '약호 생성',
			width	: 300,
			height	: 460,
			layout	: {type: 'hbox', align: 'stretch'},
			items	: [AliasPanel1, AliasPanel2],
			tbar	: ['->', {
				itemId	: 'saveBtn',
				text	: '확정',
				handler	: function() {
					if(detailForm.getValue('ITEM_ACCOUNT') == '10') {
						if(!makeAlias.getInvalidMessage()) return false;
						detailForm.setValue('ITEM_ALIAS', makeAlias.getValue('ITME_ALIAS'));
					} else {
						if(!makeAlias2.getInvalidMessage()) return false;
						detailForm.setValue('ITEM_ALIAS', makeAlias2.getValue('ITME_ALIAS'));
					}
					makeAliasWindow.hide();
				},
				disabled: false
			}, {
				itemId	: 'OrderNoCloseBtn',
				text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
				handler	: function() {
					makeAliasWindow.hide();
				},
				disabled: false
			}],
			listeners: {
				beforehide: function(me, eOpt) {
					makeAlias.clearForm();
					makeAlias2.clearForm();
				},
				beforeclose: function( panel, eOpts ) {
					makeAlias.clearForm();
					makeAlias2.clearForm();
				},
				show: function( panel, eOpts ) {
					if(detailForm.getValue('ITEM_ACCOUNT') == '10') {
						AliasPanel1.setHidden(false);
						AliasPanel2.setHidden(true);
						makeAliasWindow.setConfig('height', 460);
						makeAliasWindow.setTitle('약호 생성(제품)');
					} else {
						AliasPanel1.setHidden(true);
						AliasPanel2.setHidden(false);
						makeAliasWindow.setConfig('height', 350);
						makeAliasWindow.setTitle('약호 생성(반제품)');
					}
				}
			}
		})
	}
	makeAliasWindow.center();
	makeAliasWindow.show();
}

function fnMakeAlias(){
	if(detailForm.getValue('ITEM_ACCOUNT') == '10') {
		var vAlias =  makeAlias.getValue('CUSTOM_CODE') + '-'
					+ makeAlias.getValue('ITEM_NAME')
					+ (Ext.isEmpty(makeAlias.getValue('COLOR'))				? '': makeAlias.getValue('COLOR'))
					+ (Ext.isEmpty(makeAlias.getValue('SET_GUBUN'))			? '': makeAlias.getValue('SET_GUBUN'))
					+ (Ext.isEmpty(makeAlias.getValue('COMPONENTS_NO'))		? '': '(' + makeAlias.getValue('COMPONENTS_NO') + ')')
					+ (Ext.isEmpty(makeAlias.getValue('COLOR_GUBUN'))		? '': '(' + makeAlias.getValue('COLOR_GUBUN') + ')')
					+ (Ext.isEmpty(makeAlias.getValue('FUNCTIONAL_GUBUN'))	? '': '(' + makeAlias.getValue('FUNCTIONAL_GUBUN') + ')')
					+ (Ext.isEmpty(makeAlias.getValue('RENEWAL_GUBUN'))		? '': '(' + makeAlias.getValue('RENEWAL_GUBUN') + ')')
					+ (Ext.isEmpty(makeAlias.getValue('EXPORT_GUBUN'))		? '': '(' + makeAlias.getValue('EXPORT_GUBUN') + ')')
					+ (Ext.isEmpty(makeAlias.getValue('MAIN_GUBUN'))		? '': '(' + makeAlias.getValue('MAIN_GUBUN') + ')');
		makeAlias.setValue('ITME_ALIAS', vAlias);
	} else {
		var vAlias =  makeAlias2.getValue('CUSTOM_CODE') + '-'
					+ makeAlias2.getValue('ITEM_NAME')
					+ (Ext.isEmpty(makeAlias2.getValue('COLOR'))			? '': makeAlias2.getValue('COLOR'))
					+ (Ext.isEmpty(makeAlias2.getValue('COMPONENTS_NO'))	? '': makeAlias2.getValue('COMPONENTS_NO'))
					+ (Ext.isEmpty(makeAlias2.getValue('COLOR_GUBUN'))		? '': '(' + makeAlias2.getValue('COLOR_GUBUN') + ')')
					+ (Ext.isEmpty(makeAlias2.getValue('RENEWAL_GUBUN'))	? '': '(' + makeAlias2.getValue('RENEWAL_GUBUN') + ')');
		makeAlias2.setValue('ITME_ALIAS', vAlias);
	}
}

<%--
	코디 alias 생성 로직
	1. 제품
		(필수)고객사코드(4자리 - 사용자 입력) + '-' + (필수)제품명(4자리 - 사용자입력) + (선택)기초/색조(3자리 - 공통코드 생성 필요) + (선택)세트구분(3자리 - 공통코드 생성 필요) + (선택)구성수(2자리 - 1~25 - 사용자 입력: ()포합 4자리) + (선택)컬러구분(2자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 4자리)
		+ (선택)기능성구분(1자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 3자리) + (선택)리뉴얼구분(2자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 4자리) + (선택)수출전용구분(2자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 4자리) + (선택)본품 미품구분(1자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 3자리)
	2. 반제품
		(필수)고객사코드(4자리 - 사용자 입력) + '-' + (필수)제품명(4자리 - 사용자입력) + (선택) 기초/색조(2자리 - 공통코드 생성필요) + (필수)홋수넘버(5자리 - '-' 포함 사용자입력) + (선택)컬러구분(2자리 - 사용자 입력: ()포합 4자리) + (선택)리뉴얼구분(2자리 - 사용자 입력: ()포합 4자리)
--%>