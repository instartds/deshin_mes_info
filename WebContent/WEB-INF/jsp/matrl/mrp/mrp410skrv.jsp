<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp410skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var selectWeek = ${selectWeek};

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mrp410skrvModel', {
		fields: [
			{name: 'SUPPLY_TYPE'			,text:'<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type:'string'},
			{name: 'SUPPLY_NAME'			,text:'<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	,type:'string'},
			{name: 'ORDER_PRSN'				,text:'<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'				,type:'string'},
			{name: 'ORDER_PRSN_NAME'		,text:'<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'				,type:'string'},
			{name: 'DOM_FORIGN'				,text:'<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>'		,type:'string'},
			{name: 'DOM_FORIGN_NAME'		,text:'<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>'		,type:'string'},
			{name: 'ITEM_ACCOUNT'			,text:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type:'string'},
			{name: 'ITEM_ACCOUNT_NAME'		,text:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'				,type:'string'},
			{name: 'ITEM_CODE'				,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'					,type:'string'},
			{name: 'ITEM_NAME'				,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'					,type:'string'},
			{name: 'SPEC'					,text:'<t:message code="system.label.purchase.spec" default="규격"/>'							,type:'string'},

			{name: 'QUERY_TYPE'				,text:'SHEET<t:message code="system.label.purchase.settings" default="설정"/>'				,type:'string'},

			{name: 'ORDER_PLAN_Q_01'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_01'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_01'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_02'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_02'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_02'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_03'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_03'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_03'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_04'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_04'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_04'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_05'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_05'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_05'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_06'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_06'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_06'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_07'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_07'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_07'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_08'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_08'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_08'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_09'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_09'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_09'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_10'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_10'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_10'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_11'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_11'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_11'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_12'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_12'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_12'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_13'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_13'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_13'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_14'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_14'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_14'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_15'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_15'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_15'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_16'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_16'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_16'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_17'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_17'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_17'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_18'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_18'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_18'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_19'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_19'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_19'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'},

			{name: 'ORDER_PLAN_Q_20'		,text:'<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>'				,type:'uniQty'},
			{name: 'TOTAL_NEED_Q_20'		,text:'<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>'			,type:'uniQty'},
			{name: 'NET_REQ_Q_20'			,text:'<t:message code="system.label.purchase.netreq" default="순소요량"/>'						,type:'uniQty'}
		]
	});		// end of Unilite.defineModel('Mrp410Model', {



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mrp410skrvMasterStore1',{
		model	: 'Mrp410skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'mrp410skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}//, groupField: ''
	});		// end of var directMasterStore1 = Unilite.createStore('mrp410MasterStore1',{



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		//collapsed:true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.basisweek " default="기준주차"/>',
				name		: 'BASE_DATE',
				xtype		: 'uniDatefield',
				allowBlank	: false,
				width		: 200,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASE_DATE', newValue);
						var param= Ext.getCmp('searchForm').getValues();
							mrp410skrvService.planDateFrSet(param,
							function(provider, response) {
								panelResult.setValue('BASE_DATE_FR', provider[0].WEEKFR);
								//panelResult.setValue('PLAN_DATE_TO', provider[0].WEEKTO);
								panelSearch.setValue('BASE_DATE_FR', provider[0].WEEKFR);
								//panelSearch.setValue('PLAN_DATE_TO', provider[0].WEEKTO);
							}
						)
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.basisweek " default="기준주차"/>',
				name		:'BASE_DATE_FR',
				xtype		: 'uniTextfield',
				hidden		: true,
				width		: 200,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASE_DATE_FR', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK', {
				fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				textFieldWidth	: 170,
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'M201',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel	: 'Sheet<t:message code="system.label.purchase.settings" default="설정"/>',
				xtype		: 'uniCheckboxgroup',
				items		: [{
					boxLabel: '<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>',
					width	: 90,
					name	: 'QUERY_TYPE1',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('QUERY_TYPE1', newValue);
						
							if(newValue) {
								fnSetColumn('ORDER_PLAN_Q', true);
								
							} else {
								fnSetColumn('ORDER_PLAN_Q', false);
							}
						}
					}
				},{
					boxLabel: '<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>',
					width	: 90,
					name	: 'QUERY_TYPE2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('QUERY_TYPE2', newValue);
						
							if(newValue) {
								fnSetColumn('TOTAL_NEED_Q', true);
								
							} else {
								fnSetColumn('TOTAL_NEED_Q', false);
							}
						}
					}
				},{
					boxLabel: '<t:message code="system.label.purchase.netreq" default="순소요량"/>',
					width	: 90,
					name	: 'QUERY_TYPE3',
					checked	: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('QUERY_TYPE3', newValue);
						
							if(newValue) {
								fnSetColumn('NET_REQ_Q', true);
								
							} else {
								fnSetColumn('NET_REQ_Q', false);
							}
						}
					}
				}]
			}]
		}],
		setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
						return !field.validate();
					});
					if(invalid.length > 0) {
					r=false;
						var labelText = ''

					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
							var labelText = invalid.items[0]['fieldLabel']+':';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
						}

						alert(labelText+Msg.sMB083);
						invalid.items[0].focus();
				} else {
				//	this.mask();
					}
			} else {
				this.unmask();
			}
			return r;
		}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.basisweek " default="기준주차"/>',
			name		: 'BASE_DATE',
			xtype		: 'uniDatefield',
			allowBlank	: false,
			width		: 200,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASE_DATE', newValue);
					var param= Ext.getCmp('searchForm').getValues();
					mrp410skrvService.planDateFrSet(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
							panelResult.setValue('BASE_DATE_FR', provider[0].WEEKFR);
							//panelResult.setValue('PLAN_DATE_TO', provider[0].WEEKTO);
							panelSearch.setValue('BASE_DATE_FR', provider[0].WEEKFR);
							//panelSearch.setValue('PLAN_DATE_TO', provider[0].WEEKTO);
						}
					});
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.basisweek " default="기준주차"/>',
			name		: 'BASE_DATE_FR',
			xtype		: 'uniTextfield',
			hidden		: true,
			width		: 200,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('BASE_DATE_FR', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK', {
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			textFieldWidth	: 170,
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					panelResult.setValue('ITEM_CODE', newValue);
					panelSearch.setValue('ITEM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					panelResult.setValue('ITEM_NAME', newValue);
					panelSearch.setValue('ITEM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M201',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_PRSN', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
			fieldLabel	: 'Sheet<t:message code="system.label.purchase.settings" default="설정"/>',
			xtype		: 'uniCheckboxgroup',
			items		: [{
				boxLabel: '<t:message code="system.label.purchase.planordeqty" default="계획오더량"/>',
				width	: 90,
				name	: 'QUERY_TYPE1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('QUERY_TYPE1', newValue);
						
						if(newValue) {
							fnSetColumn('ORDER_PLAN_Q', true);
							
						} else {
							fnSetColumn('ORDER_PLAN_Q', false);
						}
					}
				}
			},{
				boxLabel: '<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>',
				width	: 90,
				name	: 'QUERY_TYPE2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('QUERY_TYPE2', newValue);
						
						if(newValue) {
							fnSetColumn('TOTAL_NEED_Q', true);
							
						} else {
							fnSetColumn('TOTAL_NEED_Q', false);
						}
					}
				}
			},{
				boxLabel: '<t:message code="system.label.purchase.netreq" default="순소요량"/>',
				width	: 90,
				name	: 'QUERY_TYPE3',
				checked	: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('QUERY_TYPE3', newValue);
						
						if(newValue) {
							fnSetColumn('NET_REQ_Q', true);
							
						} else {
							fnSetColumn('NET_REQ_Q', false);
						}
					}
				}
			}]
		}]
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mrp410skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns:  [
			{ dataIndex: 'SUPPLY_TYPE'		, width: 66, hidden: true},
			{ dataIndex: 'SUPPLY_NAME'		, width: 80, locked : true ,align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.classficationtotal2" default="분류계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
			{ dataIndex: 'ORDER_PRSN'		, width: 66, hidden: true},
			{ dataIndex: 'ORDER_PRSN_NAME'	, width: 80, locked : true},
			{ dataIndex: 'DOM_FORIGN'		, width: 66, hidden: true},
			{ dataIndex: 'DOM_FORIGN_NAME'	, width: 90, locked : true ,align:'center'},
			{ dataIndex: 'ITEM_ACCOUNT'		, width: 66, hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT_NAME', width: 100, locked : true ,align:'center'},
			{ dataIndex: 'ITEM_CODE'		, width: 120, locked : true},
			{ dataIndex: 'ITEM_NAME'		, width: 200, locked : true},
			{ dataIndex: 'SPEC'				, width: 230},
			{
				text: '1',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_01'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_01'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_01'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '2',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_02'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_02'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_02'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '3',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_03'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_03'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_03'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '4',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_04'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_04'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_04'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '5',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_05'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_05'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_05'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '6',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_06'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_06'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_06'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '7',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_07'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_07'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_07'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '8',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_08'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_08'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_08'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '9',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_09'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_09'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_09'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '10',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_10'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_10'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_10'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '11',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_11'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_11'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_11'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '12',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_12'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_12'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_12'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '13',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_13'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_13'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_13'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '14',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_14'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_14'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_14'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '15',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_15'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_15'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_15'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '16',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_16'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_16'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_16'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '17',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_17'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_17'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_17'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '18',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_18'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_18'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_18'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '19',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_19'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_19'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_19'		, width: 100, summaryType:'sum'}
				]
			},
			{
				text: '20',
				columns:[
					{ dataIndex: 'ORDER_PLAN_Q_20'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'TOTAL_NEED_Q_20'	, width: 100, hidden: true, summaryType:'sum'},
					{ dataIndex: 'NET_REQ_Q_20'		, width: 100, summaryType:'sum'}
				]
			}
		]
	});		// end of var masterGrid = Unilite.createGrid('mrp410Grid1', {



	Unilite.Main( {
		id			: 'mrp410skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			} else {
				directMasterStore1.loadStoreRecords();
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});



	//조건에 맞는 컬럼 생성	
	function fnSetColumn(columnName, flag) {
		for (var i = 1; i <= 20; i++){
			var index = '';
			if(i < 10) {
				index = '0' + i;
			} else {
				index = i;
			}
			masterGrid.getColumn(columnName + '_' + index).setVisible(flag);
		}
	}
};
</script>
