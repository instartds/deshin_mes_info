<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
request.setAttribute("PKGNAME","Unilite.app.popup.FarmInout");
%>

<t:ExtComboStore useScriptTag="false" comboType="BOR120" />							// 사업장



	Unilite.defineModel('${PKGNAME}.FarmInoutModel', {
		fields: [
			{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.common.customcode" default="거래처코드"/>'		,type:'string'	},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.common.customname" default="거래처명"/>'		,type:'string'	},
			{name: 'FARM_CODE'			,text:'<t:message code="system.label.common.farmcode" default="농가코드"/>'		,type:'string'	},
			{name: 'FARM_NAME'			,text:'<t:message code="system.label.common.farmname" default="농가명"/>'			,type:'string'	},
//			{name: 'ITEM_CODE'			,text:'품목코드'		,type:'string'	},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.common.itemname" default="품목명"/>'			,type:'string'	},
			{name: 'ORDER_UNIT_Q'		,text:'<t:message code="system.label.common.receiptqty" default="입고수량"/>'		,type:'uniQty'	},
			{name: 'CERT_TYPE'				,text:'<t:message code="system.label.common.certtype" default="인증구분"/>'		,type:'string'	},
			{name: 'ORDER_UNIT'			,text:'<t:message code="system.label.common.purchaseunit" default="구매단위"/>'		,type:'string'	,comboType:'AU'		,comboCode:'B013'},
			{name: 'ORIGIN'					,text:'<t:message code="system.label.common.origin" default="원산지"/>'			,type:'string'	},
			{name: 'CERT_NO'					,text:'인증번호'			,type:'string'	}
		]
	});



Ext.define('${PKGNAME}', {
	extend		: 'Unilite.com.BaseJSPopupApp',
	constructor	: function(config) {
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}



		/**
		 * 검색조건 (Search Panel)
		 * @type
		 */
		var wParam = this.param;
		var t1= false, t2 = false;
		if( Ext.isDefined(wParam)) {
			if(wParam['POPUP_TYPE'] == 'GRID_CODE') {
				t1 = true;
				t2 = false;

			} else {
//				t1 = false;
//				t2 = true;
			}
		}
		me.panelSearch = Unilite.createSearchForm('',{
			layout: {
				type		: 'uniTable',
				columns		: 2,
				tableAttrs	: {
					style	: {
						width: '100%'
					}
				}
			},
			items: [
				Unilite.popup('AGENT_CUST', {
					fieldLabel: '<t:message code="system.label.common.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					allowBlank		: false,
					readOnly		: true,
					colspan			: 2,
					listeners: {
					}
				}),{
					fieldLabel	: '<t:message code="system.label.common.farmname" default="농가명"/>',
					xtype		: 'uniTextfield',
					name		: 'FARM_NAME'
				},{
					fieldLabel	: '<t:message code="system.label.common.receiptqty" default="입고수량"/>',
					xtype		: 'uniNumberfield',
					name		: 'ORDER_UNIT_Q',
					type		: 'uniQty',
					readOnly	: true
				},{
					fieldLabel	: '<t:message code="system.label.common.itemcode" default="품목코드"/>',
					xtype		: 'uniTextfield',
					name		: 'ITEM_CODE',
					hidden		: true
				},{
					fieldLabel	: '<t:message code="system.label.common.itemname" default="품목명"/>',
					xtype		: 'uniTextfield',
					name		: 'ITEM_NAME',
					hidden		: true
				},{
					fieldLabel	: '<t:message code="system.label.common.purchaseunit" default="구매단위"/>',
					xtype		: 'uniTextfield',
					name		: 'ORDER_UNIT',
					hidden		: true
				},{
					fieldLabel	: '<t:message code="system.label.common.farmcode" default="농가코드"/>',
					xtype		: 'uniTextfield',
					name		: 'FARM_CODE',
					hidden		: true
				},{
                    fieldLabel  : '원산지',
                    xtype       : 'uniTextfield',
                    name        : 'WONSANGI_NUM',
                    hidden      : true
                }
			]
		});

		me.masterGrid = Ext.create('Unilite.com.grid.UniGridPanel',{
//		var masterGridConfig = {
			store: Unilite.createStoreSimple('${PKGNAME}.FarmInoutStore',{
				model	: '${PKGNAME}.FarmInoutModel',
				autoLoad: false,
				uniOpt	: {
					isMaster	: false,
					editable	: false,
					deletable	: false,
					useNavi 	: false
				},
				proxy	: {
					type: 'direct',
					api: {
						read: 'popupService.farmInout'
					}
				}
			}),
			uniOpt:{
				expandLastColumn: true,
				dblClickToEdit	: true,
				useRowNumberer	: true,
	            state: {
					useState: false,
					useStateList: false
                },
				pivot : {
					use : false
				}
			},
			selModel	: 'rowmodel',
			columns		: [
				 { dataIndex: 'CUSTOM_CODE'		,  width: 93 }
				,{ dataIndex: 'CUSTOM_NAME'		,  width: 120}
				,{ dataIndex: 'FARM_CODE'		,  width: 90 }
				,{ dataIndex: 'FARM_NAME'		,  width: 120}
//				,{ dataIndex: 'ITEM_CODE'		,  width: 90 }
				,{ dataIndex: 'ITEM_NAME'		,  width: 120}
				,{ dataIndex: 'ORDER_UNIT_Q'	,  width: 80 }
				,{ dataIndex: 'ORDER_UNIT'		,  width: 80 }
				,{ dataIndex: 'CERT_TYPE'		,  width: 80 }
				,{ dataIndex: 'ORIGIN'		,  width: 80 }
				,{ dataIndex: 'CERT_NO'		,  width: 100 }
			],
			listeners: {
				beforeedit  : function( editor, e, eOpts ) {
					if(UniUtils.indexOf(e.field, ['ORDER_UNIT_Q'])){
						return true;
					} else {
						return false;
					}
				},
				onGridDblClick:function(grid, record, cellIndex, colName) {
				var rv = {
						status : "OK",
						data:[record.data]
					};
					me.returnData(rv);
				},
				onGridKeyDown: function(grid, keyCode, e) {		
				if(e.getKey() == Ext.EventObject.ENTER) {
						var selectRecord = grid.getSelectedRecord();
						var rv = {
							status : "OK",
							data:[selectRecord.data]
						};
						me.returnData(rv);
					}
				}
			}
		});
//		};
//		if(Ext.isDefined(wParam)) {
//			if(wParam['SELMODEL'] == 'MULTI') {
//				masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
//			}
//		}

//		me.masterGrid = Unilite.createGrid('', masterGridConfig);

		config.items = [me.panelSearch, me.masterGrid];
		me.callParent(arguments);
	},
	initComponent : function(){
		var me  = this;

		me.masterGrid.focus();

		this.callParent();
	},
	fnInitBinding : function(param) {
		var me	= this;
		me.param = param;
		var frm	= me.panelSearch.getForm();

		if( Ext.isDefined(param)) {
			me.panelSearch.setValues(param);
		}
		if(!Ext.isEmpty(me.panelSearch.getValue('WONSANGI_NUM'))){
			me.panelSearch.setValue('FARM_CODE', '');
			me.panelSearch.setValue('FARM_NAME', '');
		}
		if(param['TYPE'] == 'VALUE') {
			if(!Ext.isEmpty(param['WONSANGI_NUM']) && param['WONSANGI_NUM'] == param['FARM_CODE']){
                    me.panelSearch.setValue('WONSANGI_NUM', param['WONSANGI_NUM']);
            }else{
            	if(!Ext.isEmpty(param['FARM_CODE'])){
                   me.panelSearch.setValue('FARM_CODE', param['FARM_CODE']);
                }
            }
		}else{
			if(!Ext.isEmpty(param['WONSANGI_NUM']) && param['WONSANGI_NUM'] == param['FARM_CODE']){
                me.panelSearch.setValue('WONSANGI_NUM', param['WONSANGI_NUM']);
            }else{            
    			if(!Ext.isEmpty(param['FARM_CODE'])){
    				me.panelSearch.setValue('FARM_CODE', param['FARM_CODE']);
    			}
    			if(!Ext.isEmpty(param['FARM_NAME'])){
    				me.panelSearch.setValue('FARM_NAME', param['FARM_NAME']);
    			}
            }
			
		}
		this._dataLoad();
	},
	onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
		var me			= this;
		var sumGrid		= 0;
		var totQty		= me.panelSearch.getValue('ORDER_UNIT_Q');
		var orderUnit	= me.panelSearch.getValue('ORDER_UNIT');
	 	var rvRecs		= new Array();
		var records		= me.masterGrid.getStore().data.items;
//		var records		= me.masterGrid.getSelectedRecords();
		var seq			= 0;

//		if(!Ext.isEmpty(records)) {
			Ext.each(records, function(record, i){
				if(record.get('ORDER_UNIT_Q') != '0'){
					sumGrid		= sumGrid + record.get('ORDER_UNIT_Q');
					rvRecs[seq]	= record.data;
					seq++;
				}
			});

			//기존에 입력된 입고수량과 비교하여 처리하는 로직
			if (sumGrid > totQty) {
				alert("기존 입고수량(" + totQty + orderUnit +") 보다 많은 수량이 입력 되었습니다.")

			} else if (sumGrid < totQty) {
				if(confirm("기존 입고수량(" + totQty + orderUnit +") 보다 적은 수량(" + sumGrid + orderUnit + ")(이)가 입력 되었습니다.\n" + Msg.sMM461)) {
					var rv = {
						status	: "OK",
						data	: rvRecs
					};
					me.returnData(rv);
				}

			} else {
				var rv = {
					status	: "OK",
					data	: rvRecs
				};
				me.returnData(rv);
			}
//		} else {
//			alert('선택된 데이터가 없습니다.');
//			return false;
//		}
	},
	_dataLoad : function() {
		var me = this;
		var param= me.panelSearch.getValues();
		console.log( "_dataLoad: ", param );
		me.isLoading = true;
		me.masterGrid.getStore().load({
			params : param,
			callback:function()	{
				me.isLoading = false;
			}
		});
	}
});

