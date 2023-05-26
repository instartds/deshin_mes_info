<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'<t:message code="system.label.trade.hsinfoentry" default="HS 정보 등록"/>',
		xtype: 'uniDetailFormSimple',
		itemId: 'tbs030ukrvs3Tab',
		id: 'tbs030ukrvs3Tab',
		layout: {type: 'vbox', align:'stretch'},
		padding: '0 0 0 0',
		items:[{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 2},
				items : [ 
					 Unilite.popup('ITEM',{
						fieldLabel: '<t:message code="system.label.trade.itemcode" default="품목코드"/>',
						valueFieldName: 'ITEM_CODE_FR',
						textFieldName: 'ITEM_NAME_FR',
						validateBlank: false,		//20210827 추가
						listeners		: {
							//20210824 추가: 조회조건 팝업설정에 맞게 변경
							onValueFieldChange: function(field, newValue, oldValue){
								if(!Ext.isObject(oldValue)) {
									panelDetail.down('#tbs030ukrvs3Tab').setValue('ITEM_NAME_FR', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){
								if(!Ext.isObject(oldValue)) {
									panelDetail.down('#tbs030ukrvs3Tab').setValue('ITEM_CODE_FR', '');
								}
							}
						}
					}),{
						fieldLabel	: '대분류',
						name		: 'ITEM_LEVEL1', 
						xtype		: 'uniCombobox',  
						store		: Ext.data.StoreManager.lookup('itemLeve1Store'), 
						child		: 'ITEM_LEVEL2'
					},
					Unilite.popup('ITEM',{
						fieldLabel		: '~',
						valueFieldName	: 'ITEM_CODE_TO', 
						textFieldName	: 'ITEM_NAME_TO',
						////20210827 추가
						validateBlank: false,
						listeners		: {
							onValueFieldChange: function(field, newValue, oldValue){
								if(!Ext.isObject(oldValue)) {
									panelDetail.down('#tbs030ukrvs3Tab').setValue('ITEM_NAME_TO', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){
								if(!Ext.isObject(oldValue)) {
									panelDetail.down('#tbs030ukrvs3Tab').setValue('ITEM_CODE_TO', '');
								}
							}
						}
					}),{
						fieldLabel	: '중분류',
						name		: 'ITEM_LEVEL2',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
						child		: 'ITEM_LEVEL3'
					},{ 
						xtype: 'component'
					},{ 
						fieldLabel	: '소분류',
						name		: 'ITEM_LEVEL3',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
						colspan		: 2
					},{
						xtype	: 'container',
						tdAttrs	: {align: 'center'},
						layout	: {type : 'uniTable', columns : 1, tableAttrs: {width: '98%', align: 'right'}},
						margin	: '10 5 0 0',
						colspan	: 3,
						items	:[{
							xtype	: 'component',
							tdAttrs	: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;'}
						}]
					},
					Unilite.popup('HS',{
						fieldLabel		: '품목적용HS번호',
						valueFieldName	: 'HS_CODE', 
						textFieldName	: 'HS_NAME',
						autoPopup		: true,			//20210819 추가
						listeners		: {
							onSelected: {
								fn: function(records, type) {
									panelDetail.down('#tbs030ukrvs3Tab').setValue('HS_CODE', records[0].HS_NO);
									panelDetail.down('#tbs030ukrvs3Tab').setValue('HS_SPEC', records[0].HS_SPEC);
									panelDetail.down('#tbs030ukrvs3Tab').setValue('HS_UNIT', records[0].HS_UNIT);
								},
								scope: this
							},
							onClear: function(type)	{
								panelDetail.down('#tbs030ukrvs3Tab').setValue('HS_CODE', '');
								panelDetail.down('#tbs030ukrvs3Tab').setValue('HS_SPEC', '');
								panelDetail.down('#tbs030ukrvs3Tab').setValue('HS_UNIT', '');
							}
						}
					}),{
						xtype	: 'uniTextfield',
						name	: 'HS_CODE',
						hidden	: true
					},{
						fieldLabel	: 'HS규격',
						name		: 'HS_SPEC',
						xtype		: 'uniTextfield',
						holdable	: 'hold',
						readOnly	: true
					},{
						fieldLabel	: 'HS단위',
						name		: 'HS_UNIT',
						xtype		: 'uniTextfield',
						holdable	: 'hold',
						readOnly	: true
					}
				]
			},{
				xtype		: 'uniGridPanel',
				region		: 'center',
				itemId		: 'tbs030ukrvs3Grid',
				id			: 'tbs030ukrvs3Grid',
				store		: tbs030ukrvs3Store,
				padding		: '0 0 0 0',
				dockedItems	: [{
					xtype	: 'toolbar',
					dock	: 'top',
					padding	: '0px',
					border	: 0
				}],
				uniOpt: {
					expandLastColumn	: true,
					useRowNumberer		: true,
					onLoadSelectFirst	: false,
					useMultipleSorting	: false
				},
				selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
					listeners: {
						select: function(grid, selectRecord, index, rowIndex, eOpts, oldValue ){
							var panelData = panelDetail.down('#tbs030ukrvs3Tab').getValues();
							selectRecord.set('HS_NO'	, panelData.HS_CODE);
							selectRecord.set('HS_NAME'	, panelData.HS_NAME);
							selectRecord.set('HS_SPEC'	, panelData.HS_SPEC);
							selectRecord.set('HS_UNIT'	, panelData.HS_UNIT);
						},
						deselect:  function(grid, selectRecord, index, rowIndex, eOpts, oldValue ){
							var panelData = panelDetail.down('#tbs030ukrvs3Tab').getValues();
							selectRecord.set('HS_NO'	, selectRecord.get('HS_NO_TEMP'));
							selectRecord.set('HS_NAME'	, selectRecord.get('HS_NAME_TEMP'));
							selectRecord.set('HS_SPEC'	, selectRecord.get('HS_SPEC_TEMP'));
							selectRecord.set('HS_UNIT'	, selectRecord.get('HS_UNIT_TEMP'));
						}
					}
				}),
				columns: [
					{dataIndex: 'ITEM_CODE'			, width: 86},
					{dataIndex: 'ITEM_NAME'			, width: 186},
					{dataIndex: 'SPEC'				, width: 106},
				   	{dataIndex: 'HS_NO'				, width: 100},
					{dataIndex: 'HS_NAME'			, width: 153},
					{dataIndex: 'HS_UNIT'			, width: 66, align: 'center'},
					// HIDDEN
					{dataIndex: 'SPEC_TEMP'			, width: 106, hidden: true},
				   	{dataIndex: 'HS_NO_TEMP'		, width: 100, hidden: true},
					{dataIndex: 'HS_NAME_TEMP'		, width: 153, hidden: true},
					{dataIndex: 'HS_UNIT_TEMP'		, width: 66, hidden: true}
				],
				listeners: {
					selectionchange:function(selected, eOpts ) {
						var record = Ext.getCmp('tbs030ukrvs3Tab').down('#tbs030ukrvs3Grid').getSelectedRecord();
					}
				}
			}
		]
	}