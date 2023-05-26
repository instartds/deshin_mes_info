<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv121ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="biv121ukrv"/>			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="J010"/>	<!-- 실사반영여부 -->
	<t:ExtComboStore items="${COMBO_SECTOR_LIST}" storeId="sectorList" /><!--구역-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {			// 컨트롤러에서 값을 받아옴
	gsSumTypeCell:		'${gsSumTypeCell}',
	gsMoneyUnit:		'${gsMoneyUnit}'
};

/*var output ='';
	for(var key in BsaCodeInfo){
		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	}
	alert(output);*/
var excelWindow;			// 엑셀참조
var outDivCode	= UserInfo.divCode;
var gsWhCode	= '';		//창고코드

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'biv121ukrvService.selectMaster',
			update	: 'biv121ukrvService.updateDetail',
			create	: 'biv121ukrvService.insertDetail',
			destroy	: 'biv121ukrvService.deleteDetail',
			syncAll	: 'biv121ukrvService.saveAll'
		}
	});


	var masterForm = Unilite.createSearchPanel('searchForm', {		// 메인
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '기본정보',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: '01',
				holdable: 'hold',
				child:'WH_CODE',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				holdable: 'hold',
				store: Ext.data.StoreManager.lookup('whList'),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '실사일',
				name: 'COUNT_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('COUNT_DATE', newValue);
					}
				}
			},
			Unilite.popup('DEPT', {
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					allowBlank: true,
					hidden: true,
					holdable: 'hold',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));
								gsWhCode = records[0]['WH_CODE'];
								var whStore = masterForm.getField('WH_CODE').getStore();
								console.log("whStore : ",whStore);
								whStore.clearFilter(true);
								whStore.filter([
									 {property:'option', value:masterForm.getValue('DIV_CODE')}
									,{property:'value', value: records[0]['WH_CODE']}
								]);
								masterForm.getField('WH_CODE').setValue(records[0]['WH_CODE']);
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장

							if(authoInfo == "A"){
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});

							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});

							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
		   }),{
				fieldLabel: '구역',
				name: 'SECTOR',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('sectorList'),
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SECTOR', newValue);
					},
					expand: function(field,eOpts) {
						if(Ext.isEmpty(masterForm.getValue('WH_CODE') && masterForm.getValue('DEPT_CODE'))){
							alert("필수입력값을 확인해 주세요.");
						}
						var maskedCombo = field.getPicker();

						maskedCombo.mask('loading...');
						var param = {
							"DIV_CODE": masterForm.getValue('DIV_CODE'),
							"COUNT_DATE": UniDate.getDbDateStr(masterForm.getValue('COUNT_DATE')).substring(0, 8),
							"WH_CODE": masterForm.getValue('WH_CODE')
						};
						biv121ukrvService.getSectorList(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								Ext.data.StoreManager.lookup('sectorList').loadData(provider);
								maskedCombo.unmask();
							}
						});
					},
					beforequery: function(queryPlan, eOpts ) {
						queryPlan.combo.bindStore(Ext.data.StoreManager.lookup('sectorList'));
					 }
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '참조구분',
				hidden: true,
				items : [{
					boxLabel: 'PDA',
					name: 'REF_CLASS',
					inputValue: 'PDA',
					width:80
				}, {
					boxLabel: 'Excel업로드',
					name: 'REF_CLASS' ,
					inputValue: 'EXCEL',
					width:100,
					checked: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('REF_CLASS').setValue(newValue.REF_CLASS);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '실사반영 여부',
				items : [{
					boxLabel: '미반영',
					name: 'SEND_YN',
					inputValue: 'N',
					width:80,
					checked: true
				}, {
					boxLabel: '반영',
					name: 'SEND_YN' ,
					inputValue: 'Y',
					width:80
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('SEND_YN').setValue(newValue.SEND_YN);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '실사회차',
				hidden: true,
				items : [{
					boxLabel: '최종',
					name: 'COUNT_FLAG',
					inputValue: '1',
					width:80
				}, {
					boxLabel: '전체',
					name: 'COUNT_FLAG' ,
					inputValue: '2',
					checked: true,
					width:80
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('COUNT_FLAG').setValue(newValue.COUNT_FLAG);
					}
				}
			}]
		},{
			xtype: 'container',
			padding: '10 0 0 0',
			layout: {
				type: 'hbox',
				align: 'center',
				pack: 'center'
			},
			items:[{
					xtype: 'button',
					text: '데이터 검증',
					id: 'DATA_CHECK',
					name: 'EXECUTE_TYPE',
					//inputValue: '1',
					width: 90,
					handler : function() {
						var records = directMasterStore.data.items;
						var me = this;
						var param = panelResult.getValues();
					//Ext.each(records, function(record,i) {
						param['EXECUTE_TYPE'] = '1';
						me.setDisabled(true);
						masterForm.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
						biv121ukrvService.dataCheckSave(param,
							function(provider, response) {
								if(provider) {
									UniAppManager.updateStatus("데이터 검증이 완료 되었습니다.");
									me.setDisabled(true);
								}
								UniAppManager.app.onQueryButtonDown();
								var records = directMasterStore.data.items;
								Ext.each(records, function(record,i) {
									if(Ext.isEmpty(record.get('_EXCEL_ERROR_MSG'))){
										Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(false);
										Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(false);
										if(record.get('SEND_YN') == '반영') {
											Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(true);
											Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(true);
										}/* else {
											Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(false);
											Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(false);
										}*/
									} else {
										Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(true);
										Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(true);
									}
								});
								console.log("response",response)
								me.setDisabled(false);
								masterForm.getEl().unmask();
							}
						)
						//});
					}
				},{
					xtype: 'button',
					text: '실사 등록',
					id: 'STOCK_COUNT_REGISTER',
					name: 'EXECUTE_TYPE',
					//inputValue: '2',
					margin: '0 50 10 20',
					width: 90,
					handler : function() {
						//20200713 추가
						Ext.getCmp('biv121ukrvApp').mask('<t:message code="system.message.human.message010" default="저장중..."/>','loading-indicator');
						var records = directMasterStore.data.items;
						var me = this;
						var param = panelResult.getValues();
						var record = directMasterStore.data.items[0];
						//Ext.each(records, function(record,i) {
							if(!Ext.isEmpty(record.get('_EXCEL_ERROR_MSG'))) {
								alert("에러가 있는 행은 등록이 불가능합니다.");
								//20200713 추가
								Ext.getCmp('biv121ukrvApp').unmask();
								return false;
							} else {
								param['EXECUTE_TYPE'] = '2';
								me.setDisabled(true);
								//20200713 주석
//								masterForm.getEl().mask('<t:message code="system.label.inventory.loading" default="로딩중..."/>','loading-indicator');
								biv121ukrvService.dataCheckSave(param, function(provider, response){
									//UniAppManager.updateStatus(Msg.sMB011);
									UniAppManager.app.onQueryButtonDown();
									console.log("dataCheckSave", response);
									if(provider) {
										UniAppManager.updateStatus(Msg.sMB011);
										//me.setDisabled(true);
									}
									me.setDisabled(false);
									//20200713 주석
//									masterForm.getEl().unmask();
								});
							}
						//});
					}
				}
			]
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value: '01',
			holdable: 'hold',
			child:'WH_CODE',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			holdable: 'hold',
			store: Ext.data.StoreManager.lookup('whList'),
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '실사일',
			name: 'COUNT_DATE',
			xtype: 'uniDatefield',
			value: UniDate.get('today'),
			holdable: 'hold',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('COUNT_DATE', newValue);
				}
			}
		},
		Unilite.popup('DEPT', {
			fieldLabel: '부서',
			valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
			allowBlank: true,
			hidden: true,
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						masterForm.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						masterForm.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
						gsWhCode = records[0]['WH_CODE'];
						var whStore = panelResult.getField('WH_CODE').getStore();
						console.log("whStore : ",whStore);
						whStore.clearFilter(true);
						whStore.filter([
							 {property:'option', value:panelResult.getValue('DIV_CODE')}
							,{property:'value', value: records[0]['WH_CODE']}
						]);
						panelResult.getField('WH_CODE').setValue(records[0]['WH_CODE']);
					},
					scope: this
				},
				onClear: function(type) {
					masterForm.setValue('DEPT_CODE', '');
					masterForm.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장

					if(authoInfo == "A"){
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});

					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});

					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),{
			fieldLabel: '구역',
			name: 'SECTOR',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('sectorList'),
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('SECTOR', newValue);
				},
				expand: function(field,eOpts) {
					if(Ext.isEmpty(masterForm.getValue('WH_CODE') && masterForm.getValue('DEPT_CODE'))){
						alert("필수입력값을 확인해 주세요.");
					}
					var maskedCombo = field.getPicker();

					maskedCombo.mask('loading...');
					var param = {
						"DIV_CODE": masterForm.getValue('DIV_CODE'),
						"COUNT_DATE": UniDate.getDbDateStr(masterForm.getValue('COUNT_DATE')).substring(0, 8),
						"WH_CODE": masterForm.getValue('WH_CODE')
					};
					biv121ukrvService.getSectorList(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							Ext.data.StoreManager.lookup('sectorList').loadData(provider);
							maskedCombo.unmask();
						}
					});
				},
				beforequery: function(queryPlan, eOpts ) {
					queryPlan.combo.bindStore(Ext.data.StoreManager.lookup('sectorList'));
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '참조구분',
			id: 'REF_CLASS_BUTTON',
			hidden: true,
			items : [{
				boxLabel: 'PDA',
				name: 'REF_CLASS',
				inputValue: 'PDA',
				width:60
			}, {
				boxLabel: 'Excel업로드',
				name: 'REF_CLASS' ,
				inputValue: 'EXCEL',
				width:90,
				checked: true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.getField('REF_CLASS').setValue(newValue.REF_CLASS);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '실사반영 여부',
			id: 'SEND_YN_BUTTON',
			items : [{
				boxLabel: '미반영',
				name: 'SEND_YN',
				inputValue: 'N',
				width:80,
				checked: true
			}, {
				boxLabel: '반영',
				name: 'SEND_YN' ,
				inputValue: 'Y',
				width:80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.getField('SEND_YN').setValue(newValue.SEND_YN);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '실사회차',
			hidden: true,
			items : [{
				boxLabel: '최종',
				name: 'COUNT_FLAG',
				inputValue: '1',
				width:80
			}, {
				boxLabel: '전체',
				name: 'COUNT_FLAG' ,
				inputValue: '2',
				width:80,
				checked: true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.getField('COUNT_FLAG').setValue(newValue.COUNT_FLAG);
				}
			}
		},{
			xtype: 'container',
//				padding: '0 1 0 50',		//20200713 주석
			layout: {
				type: 'hbox',
				align: 'center',
				pack: 'center'
			},
			width:300,
			items:[{
				xtype: 'button',
				text: '데이터 검증',
				id: 'DATA_CHECK2',
				name: 'EXECUTE_TYPE',
				margin: '0 0 0 95',		//20200713 수정
				width: 90,
				handler : function(grid, record) {
					var records = directMasterStore.data.items;
					var param = panelResult.getValues();
					var me = this;
					//Ext.each(records, function(record,i) {
					param['EXECUTE_TYPE'] = '1';
					me.setDisabled(true);
					//20200713 추가
					Ext.getCmp('biv121ukrvApp').mask('<t:message code="system.message.human.message010" default="저장중..."/>','loading-indicator');
					biv121ukrvService.dataCheckSave(param, function(provider, response) {
						if(provider) {
							UniAppManager.updateStatus("데이터 검증이 완료 되었습니다.");
							me.setDisabled(true);
						}
						UniAppManager.app.onQueryButtonDown();
						var records = directMasterStore.data.items;
						Ext.each(records, function(record,i) {
							if(Ext.isEmpty(record.get('_EXCEL_ERROR_MSG'))){
								Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(false);
								Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(false);
								if(record.get('SEND_YN') == '반영') {
									Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(true);
									Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(true);
								}/* else {
									Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(false);
									Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(false);
								}*/
							} else {
								Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(true);
								Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(true);
							}
						});
						console.log("response",response)
						me.setDisabled(false);
						masterForm.getEl().unmask();
					})
					//});
				}
			},{
				xtype: 'button',
				text: '실사 등록',
				id: 'STOCK_COUNT_REGISTER2',
				name: 'EXECUTE_TYPE',
				//inputValue: '2',
				margin: '0 50 0 10',		//20200713 수정
				width: 90,
				handler : function(records) {
					//20200713 추가
					Ext.getCmp('biv121ukrvApp').mask('<t:message code="system.message.human.message010" default="저장중..."/>','loading-indicator');
					var records = directMasterStore.data.items;
					var me = this;
					var param = panelResult.getValues();
					var record = directMasterStore.data.items[0];
						if(!Ext.isEmpty(record.get('_EXCEL_ERROR_MSG'))) {
							//20200713 추가
							Ext.getCmp('biv121ukrvApp').unmask();
							alert("에러가 있는 행은 등록이 불가능합니다.");
							return false;
						} else {
							param['EXECUTE_TYPE'] = '2';
							me.setDisabled(true);
							biv121ukrvService.dataCheckSave(param, function(provider, response){
								UniAppManager.app.onQueryButtonDown();
								console.log("dataCheckSave", response);
								if(provider) {
									UniAppManager.updateStatus(Msg.sMB011);
								}
								me.setDisabled(false);
							});
						}
					//});
				}
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	//biv121ukrvs1 Model
	Unilite.defineModel('Biv121ukrvModel', {		// 메인
		fields: [
			{name: 'COMP_CODE'			 ,text:'<t:message code="system.label.inventory.companycode" default="법인코드"/>'		,type: 'string'},
			{name: 'DIV_CODE'			 ,text:'<t:message code="system.label.inventory.division" default="사업장"/>'		,type: 'string'},
			{name: 'ITEM_CODE'			 ,text:'<t:message code="system.label.inventory.item" default="품목"/>'		,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			 ,text:'<t:message code="system.label.inventory.itemname" default="품목명"/>'		,type: 'string', allowBlank: false},
			{name: 'LOT_NO'				 ,text:'<t:message code="system.label.inventory.lotno" default="LOT번호"/>'		,type: 'string'},
			{name: 'GOOD_STOCK_Q'		 ,text:'수량'			,type: 'uniQty', allowBlank: false},
			{name: 'REF_CLASS'			 ,text:'구분'			,type: 'string'/*, comboType: 'AU', comboCode: 'J010'*/},
			{name: 'SECTOR'				 ,text:'구역'			,type: 'string'},
			{name: 'SEND_YN'			 ,text:'실사반영'		,type: 'string'/*, comboType: 'AU', comboCode: 'J010'*/},
			{name: '_EXCEL_HAS_ERROR'	 ,text:'에러'			,type: 'string'},
			{name: '_EXCEL_ERROR_MSG'	 ,text:'검증결과'		,type: 'string'},
			{name: 'COUNT_DATE_SEQ'		 ,text:'실사회차'		,type: 'int', allowBlank: false},
			{name: 'COUNT_DATE'			 ,text:'실사일'		,type: 'uniDate', allowBlank: false},
			{name: 'WH_CODE'			 ,text:'<t:message code="system.label.inventory.warehouse" default="창고"/>'	, store: Ext.data.StoreManager.lookup('whList') ,type: 'string', allowBlank: false},
			{name: 'WH_CELL_CODE'		 ,text:'<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'		,type: 'string'},
			{name: 'DEPT_CODE'			 ,text:'부서코드'		,type: 'string', allowBlank: false},
			{name: 'DEPT_NAME'			 ,text:'부서명'		,type: 'string', allowBlank: false},
			{name: 'SEQ'				 ,text:'순번'			,type: 'int'},
			{name: 'ITEM_SEQ'			 ,text:'ITEM_SEQ'	,type: 'string'},
			{name: 'PDA_NO'				 ,text:'PDA_NO'		,type: 'string'}
		]
	});

	// 엑셀참조
	Unilite.Excel.defineModel('excel.biv121.sheet01', {
		fields: [
			{name: 'COMP_CODE'		 ,text:'<t:message code="system.label.inventory.companycode" default="법인코드"/>'		,type: 'string'},
			{name: 'DIV_CODE'		 ,text:'<t:message code="system.label.inventory.division" default="사업장"/>'		,type: 'string'},
			{name: 'ITEM_CODE'		 ,text:'<t:message code="system.label.inventory.item" default="품목"/>'		,type: 'string'},
			{name: 'ITEM_NAME'		 ,text:'<t:message code="system.label.inventory.itemname" default="품목명"/>'		,type: 'string'},
			{name: 'LOT_NO'			 ,text:'<t:message code="system.label.inventory.lotno" default="LOT번호"/>'		,type: 'string'},
			{name: 'GOOD_STOCK_Q'	 ,text:'수량'			,type: 'uniQty'},
			{name: 'REF_CLASS'		 ,text:'구분'			,type: 'string'},
			{name: 'SEND_YN'		 ,text:'실사반영'		,type: 'string'},
			{name: 'SECTOR'			 ,text:'구역'			,type: 'string'},
			{name: 'CHECK_RESULT'	 ,text:'검증결과'		,type: 'string'},
			{name: 'COUNT_DATE_SEQ'	 ,text:'실사회차'		,type: 'int'},
			{name: 'COUNT_DATE'		 ,text:'실사일'		,type: 'uniDate'},
			{name: 'WH_CODE'		 ,text:'<t:message code="system.label.inventory.warehouse" default="창고"/>'	, store: Ext.data.StoreManager.lookup('whList')		,type: 'string'},
			{name: 'WH_CELL_CODE'	 ,text:'<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'		,type: 'string'},
			{name: 'DEPT_CODE'		 ,text:'부서코드'		,type: 'string'}
		]
	});

	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';

		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: 'biv121',
				extParam: {
					'DIV_CODE': masterForm.getValue('DIV_CODE'),
					'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE'),
					'DEPT_CODE': panelResult.getValue('DEPT_CODE')
				},
				grids: [{
					itemId		: 'grid01',
					title		: '실사등록Excel',
					useCheckbox	: true,
					model		: 'excel.biv121.sheet01',
					readApi		: 'biv121ukrvService.selectExcelUploadSheet1',
					useCheckbox	: false,
					columns		: [
						{dataIndex: 'ITEM_CODE'		, width: 110,
							editor: Unilite.popup('DIV_PUMOK_G', {
								textFieldName: 'ITEM_CODE',
								DBtextFieldName: 'ITEM_CODE',
								extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
								autoPopup: true,
								listeners: {'onSelected': {
										fn: function(records, type) {
											console.log('records : ', records);
											Ext.each(records, function(record,i) {
												console.log('record',record);
												if(i==0) {
													masterGrid.setItemData(record,false);
												} else {
													//UniAppManager.app.onNewDataButtonDown();
													masterGrid.setItemData(record,false);
												}
											});
										},
										scope: this
									},
									'onClear': function(type) {
										masterGrid.setItemData(null,true);
									}
								}
							})
						},
						{dataIndex: 'ITEM_NAME'		, width: 200,
							editor: Unilite.popup('DIV_PUMOK_G', {
								extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
								autoPopup: true,
								listeners: {'onSelected': {
										fn: function(records, type) {
											console.log('records : ', records);
											Ext.each(records, function(record,i) {
												if(i==0) {
													masterGrid.setItemData(record,false);
												} else {
													//UniAppManager.app.onNewDataButtonDown();
													masterGrid.setItemData(record,false);
												}
											});
										},
										scope: this
									},
									'onClear': function(type) {
										masterGrid.setItemData(null,true);
									}
								}
							})
						},
						{dataIndex: 'LOT_NO'		, width: 110 },
						{dataIndex: 'SECTOR'		, width: 150 },
						{dataIndex: 'WH_CODE'		, width: 90, allowBlank: false },
						{dataIndex: 'WH_CELL_CODE'	, width: 90, allowBlank: false },
						{dataIndex: 'GOOD_STOCK_Q'	, width: 60 },
						{dataIndex: 'REF_CLASS'		, width: 60 },
						{dataIndex: 'SEND_YN'		, width: 90 },
						{dataIndex: 'COUNT_DATE'	, width: 90, allowBlank: false }
					],
					listeners: {
						afterrender: function(grid) {
							var me = this;
							this.contextMenu = Ext.create('Ext.menu.Menu', {});
							this.contextMenu.add({
								text: '품목등록',   iconCls : '',
								handler: function(menuItem, event) {
									var records = grid.getSelectionModel().getSelection();
									var record = records[0];
									var params = {
										appId: UniAppManager.getApp().id,
										sender: me,
										action: 'excelNew',
										_EXCEL_JOBID: excelWindow.jobID,
										_EXCEL_ROWNUM: record.get('_EXCEL_ROWNUM'),
										ITEM_CODE: record.get('ITEM_CODE')
									}
									var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};
									parent.openTab(rec, '/base/bpr100ukrv.do', params);
								}
							});
							me.on('cellcontextmenu', function( view, cell, cellIndex, record, row, rowIndex, event ) {
								event.stopEvent();
								if(record.get('_EXCEL_HAS_ERROR') == 'Y')
									me.contextMenu.showAt(event.getXY());
							});
						}
					}
				}],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function()	{
					Ext.getCmp('biv121ukrvApp').mask('<t:message code="system.message.human.message010" default="저장중..."/>','loading-indicator');	//20200713 추가
					var me		= this;
					var grid	= this.down('#grid01');
					var records	= grid.getStore().getAt(0);
					var param	= {
						"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID'),
						"DEPT_CODE"		: panelResult.getValue('DEPT_CODE')
					};
					panelResult.setValue('WH_CODE'		, records.get('WH_CODE'));
					panelResult.setValue('COUNT_DATE'	, records.get('COUNT_DATE'));
					masterForm.setValue('WH_CODE'		, records.get('WH_CODE'));
					masterForm.setValue('COUNT_DATE'	, records.get('COUNT_DATE'));
					biv121ukrvService.insertExcelData(param, function(response, provider) {
						UniAppManager.app.onQueryButtonDown2();
						console.log("response",response)
						grid.getStore().removeAll();
						me.hide();
					});
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	}

	//directMasterStore
	var directMasterStore = Unilite.createStore('biv121ukrvMasterStore1',{		// 메인
		model	: 'Biv121ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(masterForm.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param,
				//20200713 추가
				callback: function(records,options,success) {
					Ext.getCmp('biv121ukrvApp').unmask();
				}
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(directMasterStore.count() == 0)	{
					Ext.getCmp('DATA_CHECK').setDisabled(true);
					Ext.getCmp('DATA_CHECK2').setDisabled(true);
					Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(true);
					Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(true);

					UniAppManager.setToolbarButtons(['print'], false);
				} else {
					Ext.getCmp('DATA_CHECK').setDisabled(false);
					Ext.getCmp('DATA_CHECK2').setDisabled(false);
					/*Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(true);
					Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(true);*/

					var divCode		= panelResult.getValue('DIV_CODE');
					var deptCode	= panelResult.getValue('DEPT_CODE');
					var countDate	= panelResult.getValue('COUNT_DATE');
					var sector		= panelResult.getValue('SECTOR');
					var whCode		= panelResult.getValue('WH_CODE');

					if(!Ext.isEmpty(divCode) && !Ext.isEmpty(deptCode) && !Ext.isEmpty(countDate) && !Ext.isEmpty(sector) && !Ext.isEmpty(whCode)){
					//if(!divCode == null && !deptCode == null && !countDate == null && !sector == null && !whCode == null){
						UniAppManager.setToolbarButtons(['print'], true);
					}else{
						UniAppManager.setToolbarButtons(['print'], false);
					}
				}
			}
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			//var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/*var master = batch.operations[0].getResultSet();
						masterForm.setValue("ORDER_NUM", master.ORDER_NUM);*/
						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('biv121ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		groupField: 'SECTOR'
	});	// End of var directMasterStore1

	var masterGrid = Unilite.createGrid('biv121ukrvGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: false,
			useContextMenu	: true
		},
		margin	: 0,
		tbar	: [{
			itemId	: 'excelBtn',
			text	: '<div style="color: blue">엑셀참조</div>',
			handler	: function() {
				openExcelWindow();
			}
		}],
		features: [
			{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 180,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
						}
					}
				})
			},
			{dataIndex: 'LOT_NO'			, width: 120},
			{dataIndex: 'GOOD_STOCK_Q'		, width: 100},
			{dataIndex: 'REF_CLASS'			, width: 60	, align: 'center'},
			{dataIndex: '_EXCEL_HAS_ERROR'	, width: 60, hidden: true},
			{dataIndex: 'SECTOR'			, width: 150 },
			{dataIndex: '_EXCEL_ERROR_MSG'	, width: 600},
			{dataIndex: 'SEND_YN'			, width: 70	, align: 'center'},
			{dataIndex: 'COUNT_DATE_SEQ'	, width: 80, hidden: false},
			{dataIndex: 'COUNT_DATE'		, width: 100, hidden: false},
			{dataIndex: 'WH_CODE'			, width: 200, hidden: false},
			{dataIndex: 'WH_CELL_CODE'		, width: 70, hidden: true},
			{dataIndex:	'DEPT_CODE'			, width:95,
				editor: Unilite.popup('DEPT_G', {
					textFieldName: 'DEPT_CODE',
					DBtextFieldName: 'DEPT_CODE',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var rtnRecord = masterGrid.getSelectedRecord();
								Ext.each(records, function(record,i) {
									rtnRecord.set('DEPT_CODE', record['TREE_CODE']);
									rtnRecord.set('DEPT_NAME', record['TREE_NAME']);
									//rtnRecord.set('PLAN_TYPE2_CODE', record['TREE_CODE']);
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.getSelectedRecord();
							rtnRecord.set('DEPT_CODE', '');
							rtnRecord.set('DEPT_NAME', '');
							//rtnRecord.set('PLAN_TYPE2_CODE', '');
						},
						applyextparam: function(popup){
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장

							if(authoInfo == "A"){	//자기사업장
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				})
			},
			{dataIndex: 'DEPT_NAME'			, width:120,
				editor: Unilite.popup('DEPT_G', {
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var rtnRecord = masterGrid.getSelectedRecord();
								Ext.each(records, function(record,i) {
									rtnRecord.set('DEPT_CODE', record['TREE_CODE']);
									rtnRecord.set('DEPT_NAME', record['TREE_NAME']);
									//rtnRecord.set('PLAN_TYPE2_CODE', record['TREE_CODE']);
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var rtnRecord = masterGrid.getSelectedRecord();
							rtnRecord.set('DEPT_CODE', '');
							rtnRecord.set('DEPT_NAME', '');
							//rtnRecord.set('PLAN_TYPE2_CODE', '');
						},
						applyextparam: function(popup){
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장

							if(authoInfo == "A"){	//자기사업장
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				})
			},
			{dataIndex: 'SEQ'				, width: 50, hidden: true},
			{dataIndex: 'ITEM_SEQ'			, width: 50, hidden: true},
			{dataIndex: 'PDA_NO'			, width: 50, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['GOOD_STOCK_Q', 'SECTOR'])) {
						return true;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'GOOD_STOCK_Q', 'SECTOR', 'COUNT_DATE_SEQ'])) {
						return true;
					} else {
						return false;
					}
				}
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE', '');
				grdRecord.set('ITEM_NAME', '');
			} else {
				grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
			}
		},
		viewConfig: {
			getRowClass: function(record) {
				if ( !Ext.isEmpty(record.get('_EXCEL_ERROR_MSG')) ) {
					return 'x-grid-excel-hasError';
				}
			}
		}
	});	//End of var masterGrid = Unilite.createGrid('biv121ukrvGrid1', {



	Unilite.Main({
		id			: 'biv121ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons([ 'prev', 'next', 'save', 'newData'], false);
			biv121ukrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('WH_CODE'	, provider['WH_CODE']);
					panelResult.setValue('WH_CODE'	, provider['WH_CODE']);
				}
			})
			masterForm.setValue('DEPT_CODE'	, UserInfo.deptCode);
			masterForm.setValue('DEPT_NAME'	, UserInfo.deptName);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			Ext.getCmp('DATA_CHECK').setDisabled(true);
			Ext.getCmp('DATA_CHECK2').setDisabled(true);
			Ext.getCmp('STOCK_COUNT_REGISTER').setDisabled(true);
			Ext.getCmp('STOCK_COUNT_REGISTER2').setDisabled(true);
			this.setDefault();
		},
		onQueryButtonDown: function() {		// 조회버튼 눌렀을떄
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
		/*	if(Ext.getCmp('REF_CLASS_BUTTON').getChecked()[0].inputValue == 'PDA') {
				UniAppManager.setToolbarButtons(['reset', 'newData', 'save'], true);
			} else if(Ext.getCmp('REF_CLASS_BUTTON').getChecked()[0].inputValue == 'EXCEL') {
				UniAppManager.setToolbarButtons(['newData', 'save'], false);
				UniAppManager.setToolbarButtons(['reset'], true);
			} PDA숨기기 */
			UniAppManager.setToolbarButtons(['newData', 'save'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			//UniAppManager.setToolbarButtons('delete', false);
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{		// 행추가
			var compCode		= UserInfo.compCode;
			var divCode			= masterForm.getValue('DIV_CODE');
			var itemCode		= '';
			var itemName		= '';
			var goodStockQ		= '';
			var refClass		= Ext.getCmp('REF_CLASS_BUTTON').getChecked()[0].inputValue
			var Sector			= masterForm.getValue('SECTOR');
			var sendYn			= Ext.getCmp('SEND_YN_BUTTON').getChecked()[0].inputValue
			var countDateSeq	= '';
			var countDate		= masterForm.getValue('COUNT_DATE');
			var whCode			= masterForm.getValue('WH_CODE');
			var whCellCode		= '1';
			var deptCode		= masterForm.getValue('DEPT_CODE');
			var deptName		= masterForm.getValue('DEPT_NAME');
			var seq				= directMasterStore.max('SEQ');
			if(!seq) seq = 1;
			else seq += 1;

			var r = {
				COMP_CODE		: compCode,
				DIV_CODE		: divCode,
				ITEM_CODE		: itemCode,
				ITEM_NAME		: itemName,
				GOOD_STOCK_Q	: goodStockQ,
				REF_CLASS		: refClass,
				SECTOR			: Sector,
				SEND_YN			: sendYn,
				COUNT_DATE_SEQ	: countDateSeq,
				COUNT_DATE		: countDate,
				WH_CODE			: whCode,
				WH_CELL_CODE	: whCellCode,
				DEPT_CODE		: deptCode,
				DEPT_NAME		: deptName,
				SEQ				: seq
			};
			masterGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		setDefault: function() {		// 기본값
			masterForm.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			masterForm.reset();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.reset();
			this.fnInitBinding();
			masterForm.getField('WH_CODE').focus();
			panelResult.getField('WH_CODE').focus();
			directMasterStore.clearData();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore.saveStore();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function() {
			//var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
			var param	= Ext.getCmp('searchForm').getValues();
			var win		= Ext.create('widget.PDFPrintWindow', {
				url		: CPATH+'/biv/biv122rkrPrint.do',
				prgID	: 'biv122rkr',
				extParam: {
					COMP_CODE	: UserInfo.compCode,
					DIV_CODE	: param.DIV_CODE,
					WH_CODE		: param.WH_CODE,
					COUNT_DATE	: param.COUNT_DATE,
					DEPT_CODE	: param.DEPT_CODE,
					SECTOR		: param.SECTOR
				}
			});
			win.center();
			win.show();
		},
		onQueryButtonDown2: function() {		// 엑셀 참조 자동 조회
			UniAppManager.setToolbarButtons(['newData', 'save'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			panelResult.getField('REF_CLASS').setValue('EXCEL');
			masterForm.getField('REF_CLASS').setValue('EXCEL');

			//UniAppManager.setToolbarButtons('delete', false);
			directMasterStore.loadStoreRecords();
		}
	});//End of Unilite.Main( {

	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "COUNT_DATE_SEQ" :		// 실사회차
					if(newValue < '0') {
						alert("양수를 입력해주세요.");
						break;
					}
				break;
			}
			return rv;
		}
	})
};
</script>