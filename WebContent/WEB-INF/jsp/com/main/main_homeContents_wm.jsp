<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
{
	xtype	: 'container',
	title	: '<t:message code="system.label.common.home" default="Home"/>',
	itemId	: 'home',
	uniOpt	: {
		'prgID': 'home',
		'title': 'Home'
	},
	closable: false,
	layout	: {
		type	: 'vbox',
		align	: 'stretch'
	},
	items: [{
		xtype		: 'container',
		contentEl	: 'home_notice',
		style		: {
			'background-color': '#0d385d'
		}
	},{
		xtype		: 'container',
		bodyPadding	: 10,
		flex		: 1,
		defaults	: {
			frame: true,
			boder: true
		},
		style: {
			'overflow'					: 'auto',
			'background-image'			: 'url(' + CPATH + '/resources/css/theme_01/bg.png )',
			'background-color'			: '#0d385d',
			'background-position'		: 'fixed',
			'background-repeat'			: 'no-repeat',
			'-webkit-background-size'	: 'cover',		//For WebKit
			'-moz-background-size'		: 'cover',		//Mozilla
			'-o-background-size'		: 'cover',		//Opera
			'background-size'			: 'cover'		//Generic
		},
		layout: {
			type		: 'table',
			columns		: 1,
			border		: 40,
			tableAttrs	: {
				style: {
					'position'	: 'absolute',
					'top'		: '25%',
					'left'		: '50%',
					'transform'	: 'translate(-50%, -25%)'
				}
			},
			tdAttrs: {
				style: {
					width			: '780px',
					'vertical-align': 'top'
				}
			}
		},
		items: [{
			xtype	: 'container',
			layout	: 'auto',
			defaults: {
				style: {
					float: 'left',
					width: 130
				}
			},
			items: modules
		},{
			xtype	: 'container',
			padding	: '0 0 0 0',
			margin	: '80 0 0 18',
			layout	: {type : 'uniTable', columns : 2},
			//20210303 추가: 운송장 사용량 확인 필드 추가(손소장님 확인 가능)
			hidden	: UserInfo.userID == 'unilite5' || UserInfo.userID == 'son' ? false: true,
			items	: [{
				html	: '※ 운송장 대역 사용량',
				xtype	: 'component',
				colspan	: 2
			},{
				fieldLabel	: '',
				id			: 'USED_QTY',
				xtype		: 'uniTextfield',
				readOnly	: true,
				fieldStyle	: 'text-align: center;',
				width		: 110
			},{
				html	: ' (현재 사용량 / 할당받은 량)',
				xtype	: 'component'
			}]
		}]
	}]	// modules
}