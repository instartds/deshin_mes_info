<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa350ukrv"  >
		<t:ExtComboStore comboType="BOR120"  pgmId="bsa350ukrv"/> 		  <!-- 사업장 -->
		<t:ExtComboStore comboType= "AU" comboCode="B001"  /> <!-- 제조처 -->
		<t:ExtComboStore comboType= "AU" comboCode="B010"  /> <!-- 사용여부 -->
		<t:ExtComboStore comboType= "AU" comboCode="B063"  /> <!-- 참조명칭 -->
		<t:ExtComboStore comboType= "AU" comboCode="B096"  /> <!-- 외부사용자레벨 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bsa350ukrvService.selectList',
			update	: 'bsa350ukrvService.updateDetail',
			create	: 'bsa350ukrvService.insertDetail',
			destroy	: 'bsa350ukrvService.deleteDetail',
			syncAll	: 'bsa350ukrvService.saveAll'
		}
	});


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('bsa350ukrvModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type: 'string'},
			{name: 'USER_ID'			,text: '사용자ID'				,type: 'string', allowBlank: false,	enforceMaxLength: true,	maxLength:10},	//	20210416	JH.Lee	유영신 이사님 요청으로 MAX LENGTH 수정.
			{name: 'USER_NAME'			,text: '사용자명'				,type: 'string', allowBlank: false},
			{name: 'PASSDISP'			,text: '비밀번호'				,type: 'string', allowBlank: false,	enforceMaxLength: true,	maxLength:15},	//	20210416	JH.Lee	유영신 이사님 요청으로 MAX LENGTH 수정.
			{name: 'PASSWORD'			,text: '비밀번호(저장용)'			,type: 'string', allowBlank: false},
			{name: 'UNILITE_USER_ID'	,text: 'uniLITE ID'			,type: 'string'},
			{name: 'UNILITE_USER_NAME'	,text: 'uniLITE 사용자명'		,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사번'					,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '거래처코드'				,type: 'string', allowBlank: false},
			{name: 'CUSTOM_NAME'		,text: '거래처명'				,type: 'string', allowBlank: false},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.base.division" default="사업장"/>'			,type: 'string',comboType:'BOR120', allowBlank: false},
			{name: 'USER_LEVEL'			,text: '사용자레벨'				,type: 'string',comboType:'AU', comboCode:'B096'},
			{name: 'USE_YN'				,text: '<t:message code="system.label.base.useyn" default="사용여부"/>'				,type: 'string', allowBlank: false,comboType:'AU', comboCode:'B010'},
			{name: 'REMARK'				,text: '<t:message code="system.label.base.remarks" default="비고"/>'				,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: '수정자'				,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: '수정일'				,type: 'uniDate'},
			{name: 'PWD_UPDATE_DB_TIME'	,text: '비밀번호변경일'			,type: 'uniDate'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('bsa350ukrvMasterStore1',{
		model	: 'bsa350ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function() {
				var inValidRecs = this.getInvalidRecords();
				var rv = true;

				if(inValidRecs.length == 0 ) {
					config = {
					success: function(batch, option) {
						directMasterStore1.loadStoreRecords();
					}
				}
					/*Ext.each(masterGrid2.getStore().data.items,  function(record, index, records){
						if(record.get('ITEM_P') <= 0){
							Unilite.messageBox('단가가 0보다 작거나 같을 수 없습니다');
						}else if(record.get('ITEM_P') > 0){*/
							this.syncAllDirect(config);
/*						}


					})*/


				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}

	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사용자 ID',
				name:'USER_ID',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('USER_ID', newValue);
					}
				}

			},{
				fieldLabel: '사용자명',
				name:'USER_NAME',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('USER_NAME', newValue);
					}
				}

			}]
		}]/*,
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}

					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					  var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}*/
	}); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
		var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '사용자 ID',
				name:'USER_ID',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('USER_ID', newValue);
					}
				}
			},{
				fieldLabel: '사용자명',
				name:'USER_NAME',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('USER_NAME', newValue);
					}
				}
			}

		]
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type
	 */

	var masterGrid = Unilite.createGrid('bsa350ukrvGrid1', {
		layout : 'fit',
		region:'center',
		store : directMasterStore1,
//		defaults : {enforceMaxLength: true},
		uniOpt: {
			enforceMaxLength: true,
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,   //그리드 설정 (우측)버튼 사용 여부
				useStateList: false  //그리드 설정 (죄측)목록 사용 여부
			}
		},
		columns: [
			{dataIndex: 'COMP_CODE'							, width: 66 , hidden: true},
			{dataIndex: 'USER_ID'							, width: 100},
			{dataIndex: 'USER_NAME'			 				, width: 100/*, align:'center'*/
				/*editor: Unilite.popup('Employee_G',{
							listeners:{
								'onSelected': {
									fn: function(records, type  ){
										var grdRecord = masterGrid.getSelectedRecord();
//										grdRecord.set('USER_ID',records[0]['USER_ID']);
										grdRecord.set('USER_NAME',records[0]['NAME']);
										grdRecord.set('PERSON_NUMB',records[0]['PERSON_NUMB']);
										grdRecord.set('DIV_CODE',records[0]['SECT_CODE']);


									},
									scope: this
								},
								'onClear' : function(type) {
									var grdRecord = masterGrid.getSelectedRecord();
//									grdRecord.set('USER_ID','');
									grdRecord.set('USER_NAME','');
									grdRecord.set('PERSON_NUMB','');
									grdRecord.set('DIV_CODE','');
								}
							}
						})*/

			},
	/*10자리제한	*/	{dataIndex: 'PASSDISP'					, width: 100,
						renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
//						var rec = masterGrid.getStore().getAt(rowIndex);
						if(record.get('PASSDISP') != ''){
							return '********';
						}
					}

	},
			{dataIndex: 'PASSWORD'							, width: 73 , hidden: true},
			{dataIndex: 'UNILITE_USER_ID'					, width: 86,
				editor: Unilite.popup('USER_G',{
								autoPopup: true,
								listeners:{
									'onSelected': {
										fn: function(records, type  ){
											var grdRecord = masterGrid.getSelectedRecord();
											grdRecord.set('UNILITE_USER_ID',records[0]['USER_ID']);
											grdRecord.set('UNILITE_USER_NAME',records[0]['USER_NAME']);
										},
										scope: this
									},
									'onClear' : function(type) {
										var grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('UNILITE_USER_ID','');
										grdRecord.set('UNILITE_USER_NAME','');
									}
								}
							})
			},
			{dataIndex: 'UNILITE_USER_NAME' 					, width: 120, align:'center',
				editor: Unilite.popup('USER_G',{
								autoPopup: true,
								listeners:{
									'onSelected': {
										fn: function(records, type  ){
											var grdRecord = masterGrid.getSelectedRecord();
											grdRecord.set('UNILITE_USER_ID',records[0]['USER_ID']);
											grdRecord.set('UNILITE_USER_NAME',records[0]['USER_NAME']);
										},
										scope: this
									},
									'onClear' : function(type) {
										var grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('UNILITE_USER_ID','');
										grdRecord.set('UNILITE_USER_NAME','');
									}
								}
							})
			},
			{dataIndex: 'PERSON_NUMB'						, width: 86},
			{dataIndex: 'CUSTOM_CODE'						, width: 73,
				editor: Unilite.popup('CUST_G',{
				textFieldName: 'CUSTOM_CODE',
				DBtextFieldName: 'CUSTOM_CODE',
						autoPopup: true,
						listeners:{
							'onSelected': {
								fn: function(records, type  ){
									var grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								},
								scope: this
							},
							'onClear' : function(type) {
								var grdRecord = masterGrid.getSelectedRecord();
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
							}
						}
					})
			},
			{dataIndex: 'CUSTOM_NAME'		 , width: 150,
			editor: Unilite.popup('CUST_G',{
//			textFieldName: 'CUSTOM_CODE',
//			DBtextFieldName: 'CUSTOM_NAME',
			autoPopup: true,
			listeners:{
					'onSelected': {
						fn: function(records, type  ){
							var grdRecord = masterGrid.getSelectedRecord();
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						scope: this
					},
					'onClear' : function(type) {
						var grdRecord = masterGrid.getSelectedRecord();
						grdRecord.set('CUSTOM_CODE','');
						grdRecord.set('CUSTOM_NAME','');
					}
				}
			})
			},
			{dataIndex: 'DIV_CODE'							, width: 100, align:'center'/*, hidden: true*/},
			{dataIndex: 'USER_LEVEL'							, width: 73, align:'center'},
			{dataIndex: 'USE_YN'								, width: 66, align:'center'},
			{dataIndex: 'REMARK'								, width: 133, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'						, width: 80, align:'center'},
			{dataIndex: 'UPDATE_DB_TIME'						, width: 80},
			{dataIndex: 'PWD_UPDATE_DB_TIME'					, width: 80, hidden: true}

		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom){
					if (UniUtils.indexOf(e.field,
							['UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE','PASSWORD','REMARK','PWD_UPDATE_DB_TIME']))
							{
								return false;
							}else{
								return true;
							}
				}else{
					if (UniUtils.indexOf(e.field,
							['USER_ID','UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE','PASSWORD','REMARK','PWD_UPDATE_DB_TIME']))
							{
								return false;
							}else{
								return true;
							}
				}
			}
		}
	});



	Unilite.Main({
		id			: 'bsa350ukrvApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData', 'reset'], true);
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown : function() {
			directMasterStore1.loadStoreRecords();
		},
		onNewDataButtonDown: function() {
			var compCode	= UserInfo.compCode;
			var userId		= UserInfo.userID;
			var userTime	= UniDate.get('today');
			var userLevel	= '9';
			var useYn		= 'Y';
			var r			= {
				COMP_CODE		: compCode,
				UPDATE_DB_USER	: userId,
				UPDATE_DB_TIME	: userTime,
				USER_LEVEL		: userLevel,
				USE_YN			: useYn
			};
			masterGrid.createRow(r);
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
//			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore1.clearData();
			panelResult.clearForm();
			this.fnInitBinding();
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PASSDISP" :
					if(newValue != oldValue){
						record.set('PASSWORD', newValue);
					}
			}
			return rv;
		}
	});
};
</script>