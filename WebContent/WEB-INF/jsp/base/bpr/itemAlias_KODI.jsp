<%@page language="java" contentType="text/html; charset=utf-8"%>
var allProdtWindow

var itemAliasFieldset = {
	layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	defaultType	: 'uniFieldset',
	masterGrid	: masterGrid,
	defaults	: { padding: '10 15 15 10'},
	id			: 'itemAliasFieldset',
	border		: false,
		items		: [{
		title	: '약호생성 (코디)',
		defaults: {type: 'uniTextfield', labelWidth:100},
		layout	: {type: 'uniTable', columns: 3},
		items	: [{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 1},
			padding	: '0 0 3 0',
			colspan	: 2,
			items	: [{
				fieldLabel	: '약호',
				name		: 'ITEM_ALIAS',
				xtype		: 'uniTextfield',
				labelWidth	: 30,
				width		: 303,
				readOnly	: true
			},{
				xtype		: 'container',
				layout		: {type: 'uniTable', columns: 2},
				padding		: '20 0 0 80',
				items		: [{
					text	: '약호생성',
					xtype	: 'button',
//					margin	: '10 0 12 120',
					width	: 70,
					handler	: function() {
						if(Ext.isEmpty(detailForm.getValue('ITEM_ACCOUNT'))) {
							Unilite.messageBox('품목계정을 입력하신 후, 약호를 생성하시오.');
							return false;
						} else if(detailForm.getValue('ITEM_ACCOUNT') != '10' && detailForm.getValue('ITEM_ACCOUNT') != '20') {
							Unilite.messageBox('제품, 반제품만 약호 등록이 가능 합니다.');
							return false;
						}
						openMakeAliasWindow();
					}
				},{
					text	: '삭제',
					xtype	: 'button',
					margin	: '0 0 0 3',
					width	: 70,
					handler	: function() {
						if(confirm('등록된 약호를 삭제하시겠습니까?')) {
							detailForm.setValue('ITEM_ALIAS', '');
						}
					}
				}]
			}]
		}]
	}]
}
<%--
	코디 alias 생성 로직
	1. 제품
		(필수)고객사코드(4자리 - 사용자 입력) + '-' + (필수)제품명(4자리 - 사용자입력) + (선택)기초/색조(3자리 - 공통코드 생성 필요) + (선택)세트구분(3자리 - 공통코드 생성 필요) + (선택)구성수(2자리 - 1~25 - 사용자 입력: ()포합 4자리) + (선택)컬러구분(2자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 4자리)
		+ (선택)기능성구분(1자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 3자리) + (선택)리뉴얼구분(2자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 4자리) + (선택)수출전용구분(2자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 4자리) + (선택)본품 미품구분(1자리 - 공통코드 생성 필요 - 사용자 입력: ()포합 3자리)
	2. 반제품
		(필수)고객사코드(4자리 - 사용자 입력) + '-' + (필수)제품명(4자리 - 사용자입력) + (선택) 기초/색조(2자리 - 공통코드 생성필요) + (필수)홋수넘버(5자리 - '-' 포함 사용자입력) + (선택)컬러구분(2자리 - 사용자 입력: ()포합 4자리) + (선택)리뉴얼구분(2자리 - 사용자 입력: ()포합 4자리)
--%>