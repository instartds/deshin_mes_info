<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm150ukrv" >
	<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B113" /> 			<!-- 작업부서 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> 			<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> 			<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B080" /> 			<!-- 작업조 -->
	<t:ExtComboStore comboType="AU" comboCode="Q009" /> 			<!-- 공정검사구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B079" /> 			<!-- 작업그룹 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!--창고-->
	<t:ExtComboStore comboType="OU"  />                                      <!-- 창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {		//컨트롤러에서 값을 받아옴.
	gsCellCodeYN: 	'${gsCellCodeYN}'
};

/*var output =''; 	// 입고내역 셋팅 값 확인 Unilite.messageBox
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
Unilite.messageBox(output);
*/
function appMain() {
	var isCellCodeYN = true;
	if(BsaCodeInfo.gsCellCodeYN == 'Y')	{
		isCellCodeYN = false;
	}



	/** Model 정의
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm150ukrvService.selectList',
			update	: 'bcm150ukrvService.updateDetail',
			create	: 'bcm150ukrvService.insertDetail',
			destroy	: 'bcm150ukrvService.deleteDetail',
			syncAll	: 'bcm150ukrvService.saveAll'
		}
	});



	Unilite.defineModel('Bcm150ukrvModel', {
		fields: [
			{name: 'TREE_CODE'			, text: '<t:message code="system.label.base.workcentercode" default="작업장코드"/>'			, type: 'string' , allowBlank: false, maxLength: 8},
			{name: 'TREE_NAME'			, text: '<t:message code="system.label.base.workcentername" default="작업장명"/>'				, type: 'string' , allowBlank: false},
			{name: 'TYPE_LEVEL'			, text: '<t:message code="system.label.base.division" default="사업장"/>'						, type: 'string' , comboType: 'BOR120', defaultValue: UserInfo.divCode , allowBlank: false, child:'WH_CODE'},
			{name: 'GROUP_CD'			, text: '<t:message code="system.label.base.groupset" default="작업그룹"/>'					, type: 'string' , comboType: 'AU', comboCode: 'B079'},
			{name: 'SECTION_CD'			, text: '<t:message code="system.label.base.workdept" default="작업부서"/>'					, type: 'string' , comboType: 'AU', comboCode: 'B113'},
			{name: 'SHIFT_CD'			, text: '<t:message code="system.label.base.workteam" default="작업조"/>'						, type: 'string' , comboType: 'AU', comboCode: 'B080'},
			{name: 'STANDARD_TIME'		, text: '<t:message code="system.label.base.standardtime" default="표준시간"/>'				, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.base.processingwarehouse" default="가공창고"/>'			, type: 'string' , store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_NAME'			, text: '<t:message code="system.label.base.processingwarehousename" default="가공창고명"/>'	, type: 'string'},
			{name: 'WH_CELL_CODE'		, text: '<t:message code="system.label.base.warehousecell" default="창고Cell"/>'				, type: 'string'},
			{name: 'WH_CELL_NAME'		, text: '<t:message code="system.label.base.warehousecellname" default="창고Cell명"/>'		, type: 'string'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.useflag" default="사용유무"/>'						, type: 'string' , comboType: 'AU', comboCode: 'B010' ,defaultValue: 'Y' },
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.base.writer" default="작성자"/>'						, type: 'string' , defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.base.writtentiem" default="작성시간"/>'					, type: 'uniDate'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'					, type: 'string' , defaultValue: UserInfo.compCode},
			//20190402 추가 (INSPEC_TYPE)
			{name: 'INSPEC_TYPE'		, text: '<t:message code="system.label.base.routinginspecgubun" default="공정검사구분"/>'		, type: 'string' , comboType: 'AU', comboCode: 'Q009'},
			{name: 'MATRL_AUTO_OUT_YN'	, text: '생산출고 자동 여부', type: 'string' , comboType: 'AU', comboCode: 'B010' }
		]
	});//End of Unilite.defineModel('Bcm150ukrvModel', {



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('bcm150ukrvMasterStore1', {
		model: 'Bcm150ukrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		//autoLoad: false,

		proxy: directProxy,

		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			var whList2ComboStore =  Ext.data.StoreManager.lookup('whList');
      	  //whList2ComboStore.clearFilter();
      	  whList2ComboStore.getFilters().removeAll();
			this.load({
				params: param,
				callback : function(records,options,success)    {
                    if(success) {


                    }
                }
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('bcm150ukrvMasterStore1', {



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		defaults: {
			autoScroll:true
		},
		items: [{
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
   			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				value : UserInfo.divCode,
				name: 'TYPE_LEVEL',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TYPE_LEVEL', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.workcentercode" default="작업장코드"/>',
				name: 'TREE_CODE',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TREE_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.workcentername" default="작업장명"/>',
				name: 'TREE_NAME',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TREE_NAME', newValue);
					}
				}
			}
			/*Unilite.popup('WORK_SHOP',{
					fieldLabel: '작업장',
					valueFieldName: 'TREE_CODE',
					textFieldName: 'TREE_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('TREE_CODE', panelSearch.getValue('TREE_CODE'));
								panelResult.setValue('TREE_NAME', panelSearch.getValue('TREE_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('TREE_CODE', '');
							panelResult.setValue('TREE_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'TYPE_LEVEL': panelSearch.getValue('TYPE_LEVEL')});
						}
					}
		   })*/,{
				fieldLabel: '<t:message code="system.label.base.workdept" default="작업부서"/>',
				name: 'SECTION_CD',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B113',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SECTION_CD', newValue);
					}
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				value : UserInfo.divCode,
				name: 'TYPE_LEVEL',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TYPE_LEVEL', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.workcentercode" default="작업장코드"/>',
				name: 'TREE_CODE',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TREE_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.workcentername" default="작업장명"/>',
				name: 'TREE_NAME',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TREE_NAME', newValue);
					}
				}
			}/*,
			Unilite.popup('WORK_SHOP',{
					fieldLabel: '작업장',
					valueFieldName: 'TREE_CODE',
					textFieldName: 'TREE_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('TREE_CODE', panelResult.getValue('TREE_CODE'));
								panelSearch.setValue('TREE_NAME', panelResult.getValue('TREE_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('TREE_CODE', '');
							panelSearch.setValue('TREE_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'TYPE_LEVEL': panelResult.getValue('TYPE_LEVEL')});
						}
					}
		   })*/,{
				fieldLabel: '<t:message code="system.label.base.workdept" default="작업부서"/>',
				name: 'SECTION_CD',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B113',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SECTION_CD', newValue);
					}
				}
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('bcm150ukrvGrid1', {
		store	: directMasterStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	:{
			expandLastColumn: true,
			useMultipleSorting: true
		},
		border: true,
		columns: [
			{dataIndex: 'TREE_CODE'			, width:133 },
			{dataIndex: 'TREE_NAME'			, width:266 },
			{dataIndex: 'TYPE_LEVEL'		, width:153 },
			{dataIndex: 'GROUP_CD'			, width:153 },
			{dataIndex: 'SECTION_CD'		, width:153 },
			//20190402 추가 (INSPEC_TYPE)
			{dataIndex: 'INSPEC_TYPE'		, width:153 },
			{dataIndex: 'SHIFT_CD'			, width:153 },
			{dataIndex: 'STANDARD_TIME'		, width:100 },
			{dataIndex: 'WH_CODE'			, width:153 ,tdCls:'x-change-cell3',
				listeners:{
				render:function(elm)
			 	{ elm.editor.on('beforequery',function(queryPlan, eOpts)  {
                      var store = queryPlan.combo.store;
                      var selRecord =  masterGrid.uniOpt.currentRecord;
                     	 store.clearFilter();
                          if(!Ext.isEmpty(selRecord.get('TYPE_LEVEL'))){
                              store.filterBy(function(record){
                                  return record.get('option') == selRecord.get('TYPE_LEVEL');
                              });
                          }else{
                              store.filterBy(function(record){
                                  return false;
                              });
                          }
               });
    			elm.editor.on('collapse',function(combo,  eOpts )	{
					var store = combo.store;
					store.clearFilter();
    			});
			}
		}

			},
			{dataIndex: 'WH_CELL_CODE'		, width:153 ,hidden: isCellCodeYN},
			{dataIndex: 'WH_CELL_NAME'		, width:153 ,hidden:true},
			{dataIndex: 'USE_YN'			, width:120 },
			{dataIndex: 'UPDATE_DB_USER'	, width:100 ,hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	, width:100 ,hidden:true},
			{dataIndex: 'COMP_CODE'			, width:60  ,hidden:true},
			{dataIndex: 'MATRL_AUTO_OUT_YN'	, width:150 ,align:'center',hidden:true}
		],
		listeners : {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == false || !e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['COMP_CODE', 'UPDATE_DB_TIME', 'UPDATE_DB_USER']))
					{
						return false;
					}
				}
				if(e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['TREE_CODE']))
					{
						return false;
					}
				}
			}
		}
	});//End of var masterGrid = Unilite.createGrid('bcm150ukrvGrid1', {



	Unilite.Main( {
		borderItems:[{
		region:'center',
		layout: 'border',
		border: false,
		items:[
			masterGrid, panelResult
		]},
			panelSearch
		],
		id: 'bcm150ukrvApp',

		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{

			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();
				beforeRowIndex = -1;
				panelSearch.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown : function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				var compCode  = UserInfo.compCode;
				var standTime = '0';
				var useYn 	  = 'Y'

				 var r = {
					COMP_CODE	 : compCode,
					STANDARD_TIME : standTime,
					USE_YN		: useYn

				};
				masterGrid.createRow(r);

		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		},
		onSaveDataButtonDown: function (config) {

			directMasterStore.saveStore(config);

		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
//				}
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			if(fieldName == "STANDARD_TIME" )	{
				if(newValue < 0 ) {
					 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
					 record.set('STANDARD_TIME',oldValue);
				}

				if(!Ext.isNumeric(newValue)){
					 rv='<t:message code="unilite.msg.sMB074" default="숫자만 입력가능합니다."/>';
					 record.set('STANDARD_TIME',oldValue);
				}
			}
			return rv;
		}
	});
};
</script>
