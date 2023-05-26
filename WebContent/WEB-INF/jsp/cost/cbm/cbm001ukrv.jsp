<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title: '원가업무설정',
		itemId: 'tab_cbm001ukrv',
		id: 'tab_cbm001ukrv',
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		api: {
			load: 'cbm010ukrvService.selectMaster',
			submit: 'cbm010ukrvService.syncMaster'	
		},
		items:[{
			xtype: 'fieldset',
			layout: {type: 'uniTable', columns: 1},
			items:[{
				border: false,
				html: "<font color = 'blue' >▒ 원가기준설정 ▒</font>",
				width: 600
			},{
		 		name: 'APPLY_TYPE', 
		 		fieldLabel: '<font color = "blue" >[원가 적용단가]</font>',
		 		xtype: 'uniRadiogroup',
		 		comboType: 'AU',
		 		comboCode: 'CC05',
		 		labelWidth:180,
		 		width:500,
		 		value : codeInfo.applyType,
		 		allowBlank: false
	        },{
		 		name: 'APPLY_UNIT', 
		 		fieldLabel: "<font color = 'blue' >[배부기준 등록방법]</font>",
		 		xtype: 'uniRadiogroup',
		 		comboType: 'AU',
		 		comboCode: 'CC06',
		 		value : codeInfo.applyUnit,
		 		labelWidth:180,
		 		width:400,
		 		allowBlank: false
	        }, {
		 		name: 'DIST_KIND', 
		 		fieldLabel: "<font color = 'blue' >[공통재료비 배부유형설정]</font>",
		 		xtype: 'uniCombobox',
		 		comboType: 'AU',
		 		comboCode: 'C101',
		 		value : codeInfo.distKind,
		 		labelWidth:180,
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