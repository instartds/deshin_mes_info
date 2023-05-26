<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title: '원가업무설정',
		itemId: 'tab_cbm002ukrv',
		id: 'tab_cbm002ukrv',
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		api: {
//			load: 'aba060ukrsService.fnGetBaseData',
//			submit: 'aba060ukrsService.saveBaseData'	
		},
		items:[{
			xtype: 'fieldset',
			title: '기본설정',
			layout: {type: 'uniTable', columns: 2},
			items:[{
				border: false,
				html: "<font color = 'blue' >[직/간접재료비 적상시 사용할 적용 단가]</font>",
				width: 350
			}, {
		 		name: 'APPLY_UNIT', 
		 		fieldLabel: '',
		 		xtype: 'uniCombobox',
			  	value: '02',
		 		comboType: 'AU',
		 		comboCode: 'CC05',
		 		allowBlank: false
	        }, {
				border: false,
				html: "<font color = 'blue' >[공통재료비의 배부시 사용할 배부유형]</font>",
				width: 350
			}, {
		 		name: 'DIST_KIND', 
		 		fieldLabel: '',
		 		xtype: 'uniCombobox',
			  	value: '01',
		 		comboType: 'AU',
		 		comboCode: 'C101',
		 		allowBlank: false
	        }]			
		}],
		listeners: {
           	afterrender: function(form) {
//           		form.getForm().load();
           	},
			dirtychange:function( basicForm, dirty, eOpts ) {
				UniAppManager.setToolbarButtons('save', true);
			}
		}
	}