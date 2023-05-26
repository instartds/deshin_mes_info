<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.ReturnNumPopup");
%>

/**
 * Model 정의
 * 
 * @type
 */
Unilite.defineModel('${PKGNAME}.ReturnNumPopupModel', {
			fields : [{
						name : 'RETURN_NO',
						text : '<t:message code="system.label.common.refundnum" default="환급번호"/>',
						type : 'string'
					}, {
						name : 'RETURN_DATE',
						text : '<t:message code="system.label.common.writtendate" default="작성일"/>',
						type : 'uniDate'
					}, {
						name : 'ENTRY_MAN',
						text : '<t:message code="system.label.common.entryuser" default="등록자"/>',
						type : 'string'
					}, {
						name : 'REMARK',
						text : '<t:message code="system.label.common.remarks" default="비고"/>',
						type : 'string'
					}]
		});

/**
 * 검색조건 (Search Panel)
 * 
 * @type
 */
Ext.define('${PKGNAME}', {
	extend : 'Unilite.com.BaseJSPopupApp',
	constructor : function(config) {
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}
		/**
		 * 검색조건 (Search Panel)
		 * 
		 * @type
		 */
		var wParam = this.param;
		var t1 = false, t2 = false;
		if (Ext.isDefined(wParam)) {
			if (wParam['TYPE'] == 'VALUE') {
				t1 = true;
				t2 = false;

			} else {
				t1 = false;
				t2 = true;

			}
		}

		me.panelSearch = Unilite.createSearchForm('', {
			layout : {
				type : 'table',
				columns : 2
			},
			items : [{
				fieldLabel : '<t:message code="system.label.common.division" default="사업장"/>',
				name : 'DIV_CODE',
				xtype : 'uniCombobox',
				comboType : 'BOR120',
				value : UserInfo.divCode,
				listeners : {
					change : function(combo, newValue, oldValue, eOpts) {
					}
				}
			}, {
				fieldLabel : '<t:message code="system.label.common.writtendate" default="작성일"/>',
				xtype : 'uniDateRangefield',
				startFieldName : 'RETURN_DATE_FR',
				endFieldName : 'RETURN_DATE_TO',
				margin : '0 0 0 -246',
				width : 350,
				startDate : new Date(),
				endDate : new Date()
			}, {
				xtype : 'uniTextfield',
				name : 'RETURN_NO',
				fieldLabel : '<t:message code="system.label.common.refundnum" default="환급번호"/>'
			}, {
				xtype : 'uniTextfield',
				name : 'ENTRY_MAN',
				margin : '0 0 0 -246',
				fieldLabel : '<t:message code="system.label.common.entryuser" default="등록자"/>'
			}, {
				xtype : 'uniTextfield',
				name : 'REMARK',
				width : 500,
				fieldLabel : '<t:message code="system.label.common.remarks" default="비고"/>'

			}]
		});
		/**
		 * Master Grid 정의(Grid Panel)
		 * 
		 * @type
		 */
		me.masterGrid = Unilite.createGrid('', {
					store : Unilite.createStore(
							'${PKGNAME}.returnNumPopupMasterStore', {
								model : '${PKGNAME}.ReturnNumPopupModel',
								autoLoad : false,
								proxy : {
									type : 'uniDirect',
									api : {
										read : 'popupService.returnNumPopup'
									}
								},
								saveStore : function(config) {
									var inValidRecs = this.getInvalidRecords();
									if (inValidRecs.length == 0) {
										// this.syncAll(config);
										this.syncAllDirect(config);
									} else {
										alert(Msg.sMB083);
									}
								}
							}),
//					selModel : 'rowmodel',
					uniOpt:{
		                 expandLastColumn: false
		                ,useRowNumberer: false,
		                state: {
							useState: false,
							useStateList: false	
			            },
						pivot : {
							use : false
						}
			        },
					columns : [{
								dataIndex : 'RETURN_NO',
								width : 120
							}, {
								dataIndex : 'RETURN_DATE',
								width : 100
							}, {
								dataIndex : 'ENTRY_MAN',
								width : 150
							}, {
								dataIndex : 'REMARK',
								width : 110
							}],
					listeners : {
						onGridDblClick : function(grid, record, cellIndex,
								colName) {
							var rv = {
								status : "OK",
								data : [record.data]
							};
							me.returnData(rv);
						},
						onGridKeyDown : function(grid, keyCode, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var selectRecord = grid.getSelectedRecord();
								var rv = {
									status : "OK",
									data : [selectRecord.data]
								};
								me.returnData(rv);
							}
						}
					}
				});
		config.items = [me.panelSearch, me.masterGrid];
		me.callParent(arguments);
	},
	initComponent : function() {
		var me = this;
		// me.masterGrid.focus();
		this.callParent();
	},
	fnInitBinding : function(param) {
		var me = this;
		me.param = param;
		var frm = me.panelSearch.getForm();
		// var fieldTxt = frm.findField('P_REQ_NUM');

		me.panelSearch.setValue('ENTRY_MAN', param.ENTRY_MAN);
		me.panelSearch.setValue('RETURN_DATE_TO', param.RETURN_DATE_TO);
		me.panelSearch.setValue('RETURN_DATE_FR', param.RETURN_DATE_FR);
		me.panelSearch.setValue('REMARK', param.REMARK);
		me.panelSearch.setValue('RETURN_NO', param.RETURN_NO);

		//this.onQueryButtonDown();  //파업과 동시에 조회

	},
	onQueryButtonDown : function() { // 조회 버튼
		this._dataLoad();
	},
	onSubmitButtonDown : function() { // 확인 버튼
		var me = this;
		var selectRecord = me.masterGrid.getSelectedRecord();
		var rv;
		if (selectRecord) {
			rv = {
				status : "OK",
				data : [selectRecord.data]

			};
		}
		// alert('RETURN_NO : ' + selectRecord.get('RETURN_NO'));
		// alert('ENTRY_MAN : ' + selectRecord.get('ENTRY_MAN'));
		// alert('REMARK : ' + selectRecord.get('REMARK'));

		me.returnData(rv);

	},
	_dataLoad : function() { // 조회 함수
		var me = this;
		var param = me.panelSearch.getValues();
		console.log("_dataLoad: ", param);
		me.isLoading = true;
		me.masterGrid.getStore().load({
			params : param,
			callback:function()	{
				me.isLoading = false;
			}

		});
	}
});
