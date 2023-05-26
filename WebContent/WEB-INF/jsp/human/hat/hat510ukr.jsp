<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat510ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	var model_pay_code1 = null;
	var model_pay_code2 = null;
	var model_pay_code3 = null;

	var store_pay_code1 = null;
	var store_pay_code2 = null;
	var store_pay_code3 = null;

	var dutyRule = "${ dutyRule }";
	var colData = ${colData};



	//급여지급 방식에 따른 근태구분 콤보store
	var cbStore = Unilite.createStore('hat510ukrsComboStoreGrid',{
        autoLoad: false,
        fields: [
                {name: 'SUB_CODE', type : 'string'},
	    		{name: 'CODE_NAME', type : 'string'}
                ],
        proxy: {
        	type: 'direct',
            api: {
            	read: 'hat510ukrService.getComboList'
		    }
        },
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
    });
    /**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '근태년월',
				id: 'DUTY_YYYYMMDD',
				xtype: 'uniMonthfield',
				name: 'DUTY_YYYYMMDD',
				value: new Date(),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('FR_DATE', newValue);
					}
				}
			},
				Unilite.popup('Employee', {

//					validateBlank: false,
					allowBlank: false,
					extParam: {'CUSTOM_TYPE': '3'},
					id: 'PERSON_NUMB',
					listeners: {'onSelected': {
						fn: function(records, type) {
//							console.log(records);
							panelResult.setValue('PERSON_NUMB', records[0].PERSON_NUMB);
							panelResult.setValue('NAME', records[0].NAME);
							panelSearch.setValue('DIV_CODE', records[0].DIV_CODE);
							panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
							panelSearch.setValue('DEPT_CODE', records[0].DEPT_CODE);
							panelSearch.setValue('DEPT_NAME', records[0].DEPT_NAME);
							panelResult.setValue('DEPT_CODE', records[0].DEPT_CODE);
							panelResult.setValue('DEPT_NAME', records[0].DEPT_NAME);
							panelSearch.getForm().findField('PAY_CODE').setValue(records[0].PAY_CODE);
							panelSearch.getForm().findField('PAY_PROV_FLAG').setValue(records[0].PAY_PROV_FLAG);
							panelSearch.getForm().findField('JOIN_DATE').setValue(UniDate.getDbDateStr(records[0].JOIN_DATE));
							panelSearch.getForm().findField('RETR_DATE').setValue(UniDate.getDbDateStr(records[0].RETR_DATE));

							Ext.Ajax.request({
								url     : CPATH+'/human/getPostName.do',
								params: { POST_CODE: records[0].POST_CODE, S_COMP_CODE: UserInfo.compCode },
								success: function(response){
									var data = Ext.decode(response.responseText);
									console.log(data);
									if (data.POST_NAME != '' && data.POST_NAME != null) {
										panelSearch.getForm().findField('POST_NAME').setValue(data.POST_NAME);
									}
								},
								failure: function(response){
									console.log(response);
								}
							});

						},
						scope: this
						},
						'onClear': function(type) {
							panelResult.setValue('PERSON_NUMB', '');
							panelResult.setValue('NAME', '');
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
							panelResult.setValue('POST_NAME', '');
							panelResult.setValue('DIV_CODE', '');

							panelSearch.setValue('DIV_CODE', '');
							panelSearch.setValue('POST_NAME', '');
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
							panelSearch.setValue('POST_NAME', '');
							panelSearch.getForm().findField('PAY_CODE').setValue('');
							panelSearch.getForm().findField('PAY_PROV_FLAG').setValue('');
							panelSearch.getForm().findField('JOIN_DATE').setValue('');
							panelSearch.getForm().findField('RETR_DATE').setValue('');
						},
						onTextSpecialKey : function(){
							masterGrid.getStore().loadStoreRecords();
						}
					}
			}),
				Unilite.popup('DEPT', {
				readOnly: true,
				fieldLabel: '부서',
				listeners: {
					onSelected: {
						fn: function(records, type) {
	//						panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
	//						panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
	//					panelResult.setValue('DEPT_CODE', '');
	//					panelResult.setValue('DEPT_NAME', '');
					}
				}
			}),{
    			fieldLabel: '사업장',
    			readOnly: true,
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		},{
        		xtype: 'uniTextfield',
        		readOnly: true,
        		fieldLabel: '직위',
        		name: 'POST_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('POST_NAME', newValue);
					}
				}
        	},{
				fieldLabel: '지급차수',
				name: 'PAY_PROV_FLAG',
				xtype: 'hiddenfield'
			},{
				fieldLabel: '입사일',
				name: 'JOIN_DATE',
				xtype: 'hiddenfield'
			},{
				fieldLabel: '퇴사일',
				name: 'RETR_DATE',
				xtype: 'hiddenfield'
			},{
				fieldLabel: '지급구분',
				name: 'PAY_CODE',
				id: 'PAY_CODE',
				xtype: 'hiddenfield'
			}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '근태년월',
			xtype: 'uniMonthfield',
			name: 'DUTY_YYYYMMDD',
			value: new Date(),
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DUTY_YYYYMMDD', newValue);
				}
			}
		},
			Unilite.popup('Employee', {
				colspan: 2,

//				validateBlank: false,
				allowBlank: false,
				extParam: {'CUSTOM_TYPE': '3'},
				listeners: {'onSelected': {
					fn: function(records, type) {
						console.log(records);
						panelSearch.setValue('PERSON_NUMB', records[0].PERSON_NUMB);
						panelSearch.setValue('NAME', records[0].NAME);
						panelSearch.setValue('DIV_CODE', records[0].DIV_CODE);
						panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
						panelResult.setValue('DEPT_CODE', records[0].DEPT_CODE);
						panelResult.setValue('DEPT_NAME', records[0].DEPT_NAME);
						panelSearch.setValue('DEPT_CODE', records[0].DEPT_CODE);
						panelSearch.setValue('DEPT_NAME', records[0].DEPT_NAME);
						panelSearch.getForm().findField('PAY_CODE').setValue(records[0].PAY_CODE);
						panelSearch.getForm().findField('PAY_PROV_FLAG').setValue(records[0].PAY_PROV_FLAG);
						panelSearch.getForm().findField('JOIN_DATE').setValue(UniDate.getDbDateStr(records[0].JOIN_DATE));
						panelSearch.getForm().findField('RETR_DATE').setValue(UniDate.getDbDateStr(records[0].RETR_DATE));

						Ext.Ajax.request({
							url     : CPATH+'/human/getPostName.do',
							params: { POST_CODE: records[0].POST_CODE, S_COMP_CODE: UserInfo.compCode },
							success: function(response){
								var data = Ext.decode(response.responseText);
								console.log(data);
								if (data.POST_NAME != '' && data.POST_NAME != null) {
									panelSearch.getForm().findField('POST_NAME').setValue(data.POST_NAME);
								}
							},
							failure: function(response){
								console.log(response);
							}
						});

					},
					scope: this
					},
					'onClear': function(type) {
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
						panelSearch.setValue('POST_NAME', '');
						panelSearch.setValue('DIV_CODE', '');
						panelSearch.getForm().findField('PAY_CODE').setValue('');
						panelSearch.getForm().findField('PAY_PROV_FLAG').setValue('');
						panelSearch.getForm().findField('JOIN_DATE').setValue('');
						panelSearch.getForm().findField('RETR_DATE').setValue('');

						panelResult.setValue('DIV_CODE', '');
						panelResult.setValue('POST_NAME', '');
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					onTextSpecialKey : function(){
						masterGrid.getStore().loadStoreRecords();
					}
				}
		}),
			Unilite.popup('DEPT', {
			readOnly: true,
			fieldLabel: '부서',
			listeners: {
				onSelected: {
					fn: function(records, type) {
//						panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//						panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
//					panelResult.setValue('DEPT_CODE', '');
//					panelResult.setValue('DEPT_NAME', '');
				}
			}
		}),{
			fieldLabel: '사업장',
			readOnly: true,
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
    		xtype: 'uniTextfield',
    		readOnly: true,
    		fieldLabel: '직위',
    		name: 'POST_NAME',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('POST_NAME', newValue);
				}
			}
    	}]
    });

	var fields = createModelField(colData);
	columns0 = createGridColumn(colData);

	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Hat510ukrModel', {
		fields: fields
	});//End of Unilite.defineModel('Hat500ukrModel', {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hat510ukrService.selectList',
			update: 'hat510ukrService.updateList',
			destroy: 'hat510ukrService.deleteList',
			syncAll: 'hat510ukrService.saveAll'
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var store_pay_code0 = Unilite.createStore('hat510ukrMasterStore1', {
		model: 'Hat510ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			param.DUTY_RULE = dutyRule;
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
						success:function()	{
							UniAppManager.app.onQueryButtonDown();
						}
				};
				store_pay_code0.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function() {
				if (this.getCount() > 0) {
	              	UniAppManager.setToolbarButtons('delete', true);
	              	UniAppManager.setToolbarButtons('deleteAll', true);
					var record = masterGrid.getStore().getData();
					var changeFlag = false;
                        Ext.each(record.items, function(record, idx){
                            if(record.get('FLAG') == 'Y'){
                            	changeFlag = true;
                                record.set('FLAG', 'N');
                            }
                    });
                       setTimeout(function(){
   						if(changeFlag)	{
   							UniAppManager.setToolbarButtons('save', true);
   						}
   					}, 100);
                } else {
              	  	UniAppManager.setToolbarButtons('delete', false);
              	  	UniAppManager.setToolbarButtons('deleteAll', false);
                }
			}
		}
	});
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('hat510ukrGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
		uniOpt:{
			expandLastColumn: true,
			useRowNumberer: false
        },
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('HOLY_TYPE') == '0'){ //일요일
					cls = 'x-change-cell_holyday_lightred';
				}
				else if(record.get('HOLY_TYPE') == '3') {//토요일
					cls = 'x-change-cell_holyday_lightblue';
				}
				return cls;
	        }
	    },
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
//         tbar: [{
//         	text:'상세보기',
//         	handler: function() {
//         		var record = masterGrid.getSelectedRecord();
// 	        	if(record) {
// 	        		openDetailWindow(record);
// 	        	}
//         	}
//         }],
        store: store_pay_code0,
		columns: columns0,
        listeners: {
          	beforeedit: function(editor, e) {
          		if(dutyRule == 'Y'){
                    if(e.field == 'WORK_TEAM') return true;
                }else{
                    if(e.field == 'WORK_TEAM') return false;
                }
				if (e.field == 'DUTY_YYYYMMDD'  || e.field == 'DIV_CODE' || e.field == 'DEPT_NAME' || e.field == 'POST_CODE' || e.field == 'NAME' || e.field == 'PERSON_NUMB')
					return false;
			}, edit: function(editor, e) {
				var record = masterGrid.getSelectionModel().getSelection()[0];
				var fieldName = e.field;
				var num_check = /[0-9]/;
				console.log(e);


				// 근태코드에 값이 입력 된 경우 일자의 입력값을 공백처리함
				if ((dutyRule == 'Y' && e.record.data.DUTY_CODE != '')) {
					record.set('DUTY_FR_D', '');
					record.set('DUTY_FR_H', '00');
					record.set('DUTY_FR_M', '00');
					record.set('DUTY_TO_D', '');
					record.set('DUTY_TO_H', '00');
					record.set('DUTY_TO_M', '00');
					record.set('DUTY_NUM', '1');
				}
				// 근태코드에 값이 입력 된 경우 이후 시/분에 0을 넣음
				if (dutyRule == 'N' && e.record.data.NUMC != '') {
					Ext.Ajax.request({
						url     : CPATH+'/human/getDutycode.do',
						params: { PAY_CODE: Ext.getCmp('PAY_CODE').getValue(), S_COMP_CODE: UserInfo.compCode, DUTY_RULE: dutyRule },
						success: function(response){
							var data = JSON.parse(Ext.decode(response.responseText));
							Ext.each(data, function(item, index){
								record.set('TIMET' + item.SUB_CODE, '00');
								record.set('TIMEM' + item.SUB_CODE, '00');
								record.set('NUMN', '1');
							});
						},
						failure: function(response){
							console.log(response);
						}
					});
				}
				// 숫자 형식 및 근태구분 입력 유/무 검사
				if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('_M') != -1 || fieldName.indexOf('TIMET') != -1 || fieldName.indexOf('TIMEM') != -1 || fieldName.indexOf('_D') != -1 ) {
					if(Ext.isEmpty(e.value)){
						record.set(e.field, e.originalValue);
						return false;
					}
					if (isNaN(e.value)) {
							Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
							e.record.set(fieldName, e.originalValue);
							return false;
					}
					if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('TIMET') != -1) {
						if (parseInt(e.value) > 24 || parseInt(e.value) < 0) {
							Ext.Msg.alert('확인', '정확한 시를 입력하십시오.');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						if (e.originalValue != e.value && ((dutyRule == 'Y' && e.record.data.DUTY_CODE != '') || (dutyRule == 'N' && e.record.data.NUMC != ''))) {
							Ext.Msg.alert('확인', '근태구분에 값이 있으면 입력할수 없습니다.');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					} else {
						if (parseInt(e.value) > 60 || parseInt(e.value) < 0) {
							Ext.Msg.alert('확인', '정확한 분을 입력하십시오.');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						if (e.originalValue != e.value && ((dutyRule == 'Y' && e.record.data.DUTY_CODE != '') || (dutyRule == 'N' && e.record.data.NUMC != ''))) {
							Ext.Msg.alert('확인', '근태구분에 값이 있으면 입력할수 없습니다.');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					}
				}
			if (e.originalValue != e.value) {
				if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('_M') != -1 || fieldName.indexOf('TIMET') != -1 || fieldName.indexOf('TIMEM') != -1) {
					if(e.value.length == 1){
						record.set(fieldName, '0' + e.value);
					}
				}
				UniAppManager.setToolbarButtons('save', true);
			}
// 			else {
// 				UniAppManager.setToolbarButtons('save', false);
// 			}
		}
     }
	});//End of var masterGrid = Unilite.createGr100id('hat510ukrGrid1', {

	Unilite.Main( {
		 borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id: 'hat510ukrApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset', false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PERSON_NUMB');
			cbStore.loadStoreRecords();
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			//급여지급방식(PAY_CODE)에 따른 그리드 근태구분 콤보 초기화
			cbStore.loadStoreRecords();
        	if (panelSearch.getForm().isValid()) {
				var pay_code = Ext.getCmp('PAY_CODE').getValue();
				switch (pay_code) {
					case '0':
						if (store_pay_code0 == null) {
							createModelStore(pay_code);
						} else {
							masterGrid.getStore().loadStoreRecords();
							masterGrid.reconfigure(store_pay_code0, columns0);

//							var columns0 = createGridColumn(colData);
//							store_pay_code0.loadStoreRecords();
//							masterGrid.setColumnInfo(masterGrid, columns0, fields);
//							masterGrid.reconfigure(store_pay_code0, columns0);
						}
						break;
					case '1':
						if (store_pay_code1 == null) {
							createModelStore(pay_code);
						} else {
							masterGrid.getStore().loadStoreRecords();
							masterGrid.reconfigure(store_pay_code1, columns1);
						}
						break;
					case '2':
						if (store_pay_code2 == null) {
							createModelStore(pay_code);
						} else {
							masterGrid.getStore().loadStoreRecords();
							masterGrid.reconfigure(store_pay_code2, columns2);
						}
						break;
					case '3':
						if (store_pay_code3 == null) {
							createModelStore(pay_code);
						} else {
							masterGrid.getStore().loadStoreRecords();
							masterGrid.reconfigure(store_pay_code3, columns3);
						}
						break;
				}
        	} /*else {
        		var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});

				if(invalid.length > 0)	{
					r = false;
					var labelText = ''

					if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}

					Ext.Msg.alert('확인', labelText+Msg.sMB083);
					invalid.items[0].focus();
				}
        	}*/
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectionModel().getSelection()[0];
			if (selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else {
				Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
					if (btn == 'yes') {
						masterGrid.deleteSelectedRow();
						UniAppManager.setToolbarButtons('save', true);
					}
				});
			}
		},
//		onDeleteAllButtonDown : function() {
//			Ext.Msg.confirm('삭제', '전체 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
//				if (btn == 'yes') {
//					masterGrid.reset();
//					UniAppManager.app.onSaveDataButtonDown();
//						Ext.getCmp('hat510ukrGrid1').getStore().removeAll();
//						Ext.getCmp('hat510ukrGrid1').getStore().sync({
//							success: function(response) {
//								Ext.Msg.alert('확인', '삭제 되었습니다.');
//								UniAppManager.setToolbarButtons('delete', false);
//								UniAppManager.setToolbarButtons('deleteAll', false);
//					           },
//					           failure: function(response) {
//					           }
//				           });
//
//				}
//			});
//		},
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				// 입력데이터 validation
				if (!checkValidaionGrid(masterGrid.getStore())) {
					return false;
				}
				masterGrid.getStore().saveStore();
//				masterGrid.getStore().syncAll({
//					success: function(response) {
//						UniAppManager.setToolbarButtons('save', false);
//						UniAppManager.setToolbarButtons('deleteAll',false);
//						UniAppManager.setToolbarButtons('delete',false);
//		            },
//		            failure: function(response) {
//		            	UniAppManager.setToolbarButtons('save', true);
//		            }
//				});
			}
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message041" default="전체삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					//masterGrid.getStore().removeAll();
					var data = store_pay_code0.getData().items;
					store_pay_code0.remove(data);
					UniAppManager.app.onSaveDataButtonDown();
				}
			});
		}
	});//End of Unilite.Main( {
	Unilite.createValidator('validator01', {
        store: store_pay_code0,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            if(newValue == oldValue){
                return false;
            }
            var rv = true;
            switch(fieldName) {
                case "WORK_TEAM" :
                    if(!Ext.isEmpty(newValue) && dutyRule == 'Y' && Ext.isEmpty(record.get("DUTY_CODE")) ) {
                    	var param = {
								'WORK_TEAM' : newValue,
								'DUTY_YYYYMMDD' : UniDate.getDbDateStr(record.get("DUTY_YYYYMMDD"))
						}
                    	Ext.getBody().mask();
                        hat510ukrService.getDutycodeTime(param, function(provider, response)  {
                        	Ext.getBody().unmask();
                            if(!Ext.isEmpty(provider)){
                            	record.obj.set('DUTY_FR_D', provider[0].DUTY_FR_D);
                                record.obj.set('DUTY_FR_H', provider[0].DUTY_FR_H);
                                record.obj.set('DUTY_FR_M', provider[0].DUTY_FR_M);
                                record.obj.set('DUTY_TO_D', provider[0].DUTY_TO_D);
                                record.obj.set('DUTY_TO_H', provider[0].DUTY_TO_H);
                                record.obj.set('DUTY_TO_M', provider[0].DUTY_TO_M);
                            }
                        });
                    }
                    break;
                case "DUTY_CODE" :
                    if(Ext.isEmpty(newValue) && dutyRule == 'Y' && !Ext.isEmpty(record.get("WORK_TEAM")) ) {
                    	var param = {
								'WORK_TEAM' : record.get("WORK_TEAM"),
								'DUTY_YYYYMMDD' : UniDate.getDbDateStr(record.get("DUTY_YYYYMMDD"))
						}
                    	Ext.getBody().mask();
                        hat510ukrService.getDutycodeTime(param, function(provider, response)  {
                        	Ext.getBody().unmask();
                            if(!Ext.isEmpty(provider)){
                            	record.obj.set('DUTY_FR_D', provider[0].DUTY_FR_D);
                                record.obj.set('DUTY_FR_H', provider[0].DUTY_FR_H);
                                record.obj.set('DUTY_FR_M', provider[0].DUTY_FR_M);
                                record.obj.set('DUTY_TO_D', provider[0].DUTY_TO_D);
                                record.obj.set('DUTY_TO_H', provider[0].DUTY_TO_H);
                                record.obj.set('DUTY_TO_M', provider[0].DUTY_TO_M);
                            }
                        });
                    }
                    break;    
                default:
                	break;
            }
            return rv;
        }
    });
	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
		              	{name: 'HOLY_TYPE'			, text: 'HOLY_TYPE', type: 'string'},
		              	{name: 'PAY_CODE'			, text: '급여지급방식', type: 'string'},
						{name: 'WORK_TEAM'			, text: '근무조'	, type: 'string', comboType: 'AU', comboCode: 'H004'},
						{name: 'DIV_CODE'			, text: '사업장'	, type: 'string', comboType: 'BOR120'},
						{name: 'FLAG'				, text: 'flag'	, type: 'string'},
						{name: 'DUTY_YYYYMMDD'		, text: '근태년월'	, type: 'uniDate'},
						{name: 'DEPT_NAME'			, text: '부서'	, type: 'string'},
						{name: 'POST_CODE'			, text: '직위'	, type: 'string', comboType: 'AU', comboCode: 'H005'},
						{name: 'NAME'				, text: '성명'	, type: 'string'},
						{name: 'PERSON_NUMB'		, text: '사번'	, type: 'string'}
					 ];

		if (dutyRule == 'Y') {
			fields.push({name: 'DUTY_CODE'		, text: '근태구분'	, type: 'string'});
			fields.push({name: 'DUTY_FR_D'		, text: '일자'	, type: 'uniDate'});
			fields.push({name: 'DUTY_FR_H'		, text: '시'		, type: 'string', maxLength: 2});
			fields.push({name: 'DUTY_FR_M'		, text: '분'		, type: 'string', maxLength: 2});
			fields.push({name: 'DUTY_TO_D'		, text: '일자'	, type: 'uniDate'});
			fields.push({name: 'DUTY_TO_H'		, text: '시'		, type: 'string', maxLength: 2});
			fields.push({name: 'DUTY_TO_M'		, text: '분'		, type: 'string', maxLength: 2});
		} else {
			fields.push({name: 'NUMF'			, text: 'NUMF'	, type: 'string'});
			fields.push({name: 'NUMC1'			, text: 'NUMC1'	, type: 'string'});
			fields.push({name: 'NUMC'			, text: '근태구분'	, type: 'string'});
			fields.push({name: 'NUMN'			, text: 'NUMN'	, type: 'string'});
			fields.push({name: 'NUMT'			, text: 'NUMT'	, type: 'string'});
			fields.push({name: 'NUMM'			, text: 'NUMM'	, type: 'string'});
			Ext.each(colData, function(item, index){
				fields.push({name: 'TIMEF' + item.SUB_CODE, text: 'TIMEF'	, type: 'string'});
				fields.push({name: 'TIMEC' + item.SUB_CODE, text: 'TIMEC'	, type: 'string'});
				fields.push({name: 'TIMEN' + item.SUB_CODE, text: 'TIMEN'	, type: 'string'});
				fields.push({name: 'TIMET' + item.SUB_CODE, text: '시'		, type: 'string'});
				fields.push({name: 'TIMEM' + item.SUB_CODE, text: '분'		, type: 'string'});
			});
		}
		console.log(fields);
		return fields;
	}


	// 그리드 컬럼 생성
	function createGridColumn(colData) {
			var columns = [{
							xtype: 'rownumberer',
							sortable:false,
							//locked: true,
							width: 35,
							align:'center  !important',
							resizable: true
						},
						{dataIndex: 'FLAG'				, width: 25,  text: '', align: 'center'},
						{dataIndex: 'HOLY_TYPE'			, text: 'HOLY_TYPE',   hidden: true},
						{dataIndex: 'DUTY_YYYYMMDD'		, width: 96, text: '근태년월', align: 'center', style: 'text-align: center', xtype: 'uniDateColumn',
							renderer: Ext.util.Format.dateRenderer('Y.m.d')
						},
						{dataIndex: 'PAY_CODE'			, text: '급여지급방식',   hidden: true},
						{dataIndex: 'WORK_TEAM'			, width: 96, text: '근무조', style: 'text-align: center',
				            renderer: function (value) {
				            	var record = Ext.getStore('CBS_AU_H004').findRecord('value', value);
								if (record == null || record == undefined ) {
									return '';
								} else {
									return record.data.text
								}
				            },
				            editor:
				            {
				                xtype: 'uniCombobox',
				                comboType:'AU',
								comboCode:'H004'
				            }
						},
						{dataIndex: 'DIV_CODE'			, width: 100, text: '사업장', hidden: true, comboType: 'BOR120',
				            renderer: function (value) {
				            	var record = Ext.getStore('CBS_BOR120_').findRecord('value', value);
								if (record == null || record == undefined ) {
									return '';
								} else {
									return record.data.text
								}
				            }
						},
						{dataIndex: 'DEPT_NAME'			, width: 96,  hidden: true, text: '부서'},
						{dataIndex: 'POST_CODE'			, width: 96,  hidden: true, text: '직위', comboType: 'AU',
				            renderer: function (value) {
				            	var record = Ext.getStore('CBS_AU_H005').findRecord('value', value);
								if (record == null || record == undefined ) {
									return '';
								} else {
									return record.data.text
								}
				            }
						},
						{dataIndex: 'NAME'				, width: 96,  hidden: true, text: '성명'},
						{dataIndex: 'PERSON_NUMB'		, width: 96,  hidden: true, text: '사번'}
					  ];
		if (dutyRule == 'Y') {
			columns.push({dataIndex: 'DUTY_CODE'		, width: 96, text: '근태구분', style: 'text-align: center', align: 'center', editor:
	            {
	                xtype: 'uniCombobox',
	                store: cbStore,
	                lazyRender: true,
	                displayField : 'CODE_NAME',
	                valueField : 'SUB_CODE',
	                hiddenName: 'SUB_CODE',
	                hiddenValue: 'SUB_CODE'
	            },
	            renderer: function (value) {
	            	var record = Ext.getStore('hat510ukrsComboStoreGrid').findRecord('SUB_CODE', value);
					if (record == null || record == undefined ) {
						return '';
					} else {
						return record.data.CODE_NAME
					}
	            }
			});
			columns.push({text: '출근시각',
					columns:[{dataIndex: 'DUTY_FR_D'		, width: 96, text: '일자', align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}},
							 {dataIndex: 'DUTY_FR_H'		, width: 96, text: '시', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
							 {dataIndex: 'DUTY_FR_M'		, width: 96, text: '분', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
					]});
			columns.push({text: '퇴근시각',
					columns:[{dataIndex: 'DUTY_TO_D'		, width: 96, text: '일자', align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}},
							 {dataIndex: 'DUTY_TO_H'		, width: 96, text: '시', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
							 {dataIndex: 'DUTY_TO_M'		, width: 96, text: '분', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
					]});
		} else {
			columns.push({dataIndex: 'NUMF'				, width: 96		, hidden: true, text: 'NUMF'});
			columns.push({dataIndex: 'NUMC1'			, width: 96		, hidden: true, text: 'NUMC1'});
			columns.push({dataIndex: 'NUMC'				, width: 96		, text: '근태구분', style: 'text-align: center', align: 'center', editor:
	            {
	                xtype: 'uniCombobox',
	                store: cbStore,
	                lazyRender: true,
	                displayField : 'CODE_NAME',
	                valueField : 'SUB_CODE',
	                hiddenName: 'SUB_CODE',
	                hiddenValue: 'SUB_CODE'
	            },
	            renderer: function (value) {
	            	var record = Ext.getStore('hat510ukrsComboStoreGrid').findRecord('SUB_CODE', value);
					if (record == null || record == undefined ) {
						return '';
					} else {
						return record.data.CODE_NAME
					}
	            }
			});
			columns.push({dataIndex: 'NUMN'				, width: 96		, hidden: true, text: 'NUMN'});
			columns.push({dataIndex: 'NUMT'				, width: 96		, hidden: true, text: 'NUMT'});
			columns.push({dataIndex: 'NUMM'				, width: 96		, hidden: true, text: 'NUMM'});
			Ext.each(colData, function(item, index){
				columns.push({text: item.CODE_NAME,
					columns:[
						{dataIndex: 'TIMEF' + item.SUB_CODE, width:66, hidden: true, text: 'TIMEF', align: 'right', style: 'text-align: center', xtype:'uniNnumberColumn'},
						{dataIndex: 'TIMEC' + item.SUB_CODE, width:66, hidden: true, text: 'TIMEC', align: 'right', style: 'text-align: center', xtype:'uniNnumberColumn'},
						{dataIndex: 'TIMEN' + item.SUB_CODE, width:66, hidden: true, text: 'TIMEN', align: 'right', style: 'text-align: center', xtype:'uniNnumberColumn'},
						{dataIndex: 'TIMET' + item.SUB_CODE, width:66, text: '시', align: 'right', editor: {xtype: 'uniTextfield'}, style: 'text-align: center'},
						{dataIndex: 'TIMEM' + item.SUB_CODE, width:66, text: '분', align: 'right', editor: {xtype: 'uniTextfield'}, style: 'text-align: center'}
				]});
			});
		}
		console.log(columns);
		return columns;
	}

	function createModelStore(pay_value) {
		Ext.Ajax.request({
			url     : CPATH+'/human/getDutycode.do',
			params: { PAY_CODE: pay_value, S_COMP_CODE: UserInfo.compCode, DUTY_RULE: dutyRule },
			success: function(response){
				var data = JSON.parse(Ext.decode(response.responseText));
				var fields = createModelField(data);
				switch (pay_value) {
					case '0':
						store_pay_code0.loadStoreRecords();
						masterGrid.setColumnInfo(masterGrid, columns0, fields);
						masterGrid.reconfigure(store_pay_code0, columns0);
						break;
					case '1':
						columns1 = createGridColumn(data);
						model_pay_code1 = Unilite.defineModel('model_pay_code1', {
							fields: fields
						});
						store_pay_code1 = Unilite.createStore('store_pay_code1', {
							model: 'model_pay_code1',
							uniOpt: {
								isMaster: false,			// 상위 버튼 연결
								editable: true,			// 수정 모드 사용
								deletable: false,			// 삭제 가능 여부
								useNavi: false			// prev | newxt 버튼 사용
							},
							autoLoad: false,
							proxy: directProxy,
							loadStoreRecords: function(){
								var param= Ext.getCmp('searchForm').getValues();
								param.DUTY_RULE = dutyRule;
								console.log(param);
								this.load({
									params: param
								});
							},
							saveStore : function(config)	{
								var inValidRecs = this.getInvalidRecords();
								if(inValidRecs.length == 0 )	{
									var config = {

										success: function(batch, option) {
											store_pay_code1.loadStoreRecords();
											UniAppManager.setToolbarButtons('save', false);
										 }
									};
									store_pay_code1.syncAllDirect(config);
								}else {
									masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners: {
								load: function() {
									if (this.getCount() > 0) {
										UniAppManager.setToolbarButtons('delete', true);
						              	UniAppManager.setToolbarButtons('deleteAll', true);
										var record = masterGrid.getStore().getData();
					                        Ext.each(record.items, function(record, idx){
					                            if(record.get('FLAG') == 'Y'){
					                                   UniAppManager.setToolbarButtons('save', true);
					                                   record.set('FLAG', 'N');
					                            }else{
					                                   UniAppManager.setToolbarButtons('save', false);
					                            }
										    });
					                } else {
					              	  	UniAppManager.setToolbarButtons('delete', false);
					              	  	UniAppManager.setToolbarButtons('deleteAll', false);
					                }
					                masterGrid.getSelectionModel().select(0);
								}
							}
						});
						store_pay_code1.loadStoreRecords();
						masterGrid.setColumnInfo(masterGrid, columns1, fields);
						masterGrid.reconfigure(store_pay_code1, columns1);
						break;
					case '2':
						columns2 = createGridColumn(data);
						model_pay_code2 = Unilite.defineModel('model_pay_code2', {
							fields: fields
						});
						store_pay_code2 = Unilite.createStore('store_pay_code2', {
							model: 'model_pay_code2',
							uniOpt: {
								isMaster: false,			// 상위 버튼 연결
								editable: true,			// 수정 모드 사용
								deletable: false,			// 삭제 가능 여부
								useNavi: false			// prev | newxt 버튼 사용
							},
							autoLoad: false,
							proxy: directProxy,
							loadStoreRecords: function(){
								var param= Ext.getCmp('searchForm').getValues();
								param.DUTY_RULE = dutyRule;
								console.log(param);
								this.load({
									params: param
								});
							},
							saveStore : function(config)	{
								var inValidRecs = this.getInvalidRecords();
								if(inValidRecs.length == 0 )	{
									var config = {
										success: function(batch, option) {
											store_pay_code2.loadStoreRecords();
											UniAppManager.setToolbarButtons('save', false);
										 }
									};
									store_pay_code2.syncAllDirect(config);
								}else {
									masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners: {
								load: function() {
									if (this.getCount() > 0) {
						              	UniAppManager.setToolbarButtons('delete', true);
						              	UniAppManager.setToolbarButtons('deleteAll', true);
											var record = masterGrid.getStore().getData();
					                        Ext.each(record.items, function(record, idx){
					                            if(record.get('FLAG') == 'Y'){
					                                   UniAppManager.setToolbarButtons('save', true);
					                                   record.set('FLAG', 'N');
					                            }else{
					                                   UniAppManager.setToolbarButtons('save', false);
					                            }
										    });
					                } else {
					              	  	UniAppManager.setToolbarButtons('delete', false);
					              	  	UniAppManager.setToolbarButtons('deleteAll', false);
					                }
					                masterGrid.getSelectionModel().select(0);
								}
							}
						});
						store_pay_code2.loadStoreRecords();
						masterGrid.setColumnInfo(masterGrid, columns2, fields);
						masterGrid.reconfigure(store_pay_code2, columns2);
						break;
					case '3':
						columns3 = createGridColumn(data);
						model_pay_code3 = Unilite.defineModel('model_pay_code3', {
							fields: fields
						});
						store_pay_code3 = Unilite.createStore('store_pay_code3', {
							model: 'model_pay_code3',
							uniOpt: {
								isMaster: false,			// 상위 버튼 연결
								editable: true,			// 수정 모드 사용
								deletable: false,			// 삭제 가능 여부
								useNavi: false			// prev | newxt 버튼 사용
							},
							autoLoad: false,
							proxy: directProxy,
							loadStoreRecords: function(){
								var param= Ext.getCmp('searchForm').getValues();
								param.DUTY_RULE = dutyRule;
								console.log(param);
								this.load({
									params: param
								});
							},
							saveStore : function(config)	{
								var inValidRecs = this.getInvalidRecords();
								if(inValidRecs.length == 0 )	{
									var config = {

										success: function(batch, option) {
											store_pay_code3.loadStoreRecords();
											UniAppManager.setToolbarButtons('save', false);
										 }
									};
									store_pay_code3.syncAllDirect(config);
								}else {
									masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
								}
							},
							listeners: {
								load: function() {
									if (this.getCount() > 0) {
						              	UniAppManager.setToolbarButtons('delete', true);
						              	UniAppManager.setToolbarButtons('deleteAll', true);
											var record = masterGrid.getStore().getData();
					                        Ext.each(record.items, function(record, idx){
					                            if(record.get('FLAG') == 'Y'){
					                                   UniAppManager.setToolbarButtons('save', true);
					                                   record.set('FLAG', 'N');
					                            }else{
					                                   UniAppManager.setToolbarButtons('save', false);
					                            }
										    });
					                } else {
					              	  	UniAppManager.setToolbarButtons('delete', false);
					              	  	UniAppManager.setToolbarButtons('deleteAll', false);
					                }
					                masterGrid.getSelectionModel().select(0);
								}
							}
						});
						store_pay_code3.loadStoreRecords();
						masterGrid.setColumnInfo(masterGrid, columns3, fields);
						masterGrid.reconfigure(store_pay_code3, columns3);
						break;
				}

			},
			failure: function(response){
				console.log(response);
			}
		});
	}

	function checkValidaionGrid(store) {
		 // 시작시간이 종료시간 보다 큰 값이 입력이 됨
		 var rightTimeInputed = true;

		 var MsgTitle = '확인';
		 var MsgErr01 = '시작시간이 종료 시간 보다 클 수 없습니다.';

		 var grid = Ext.getCmp('hat510ukrGrid1');
		 var toUpdate = grid.getStore().getUpdatedRecords();
		 Ext.each(toUpdate, function(record,i){

			 if ( (UniDate.getDbDateStr(record.data.DUTY_FR_D) != '' && UniDate.getDbDateStr(record.data.DUTY_TO_D) == '') ||
				  (UniDate.getDbDateStr(record.data.DUTY_FR_D) == '' && UniDate.getDbDateStr(record.data.DUTY_TO_D) != '') ) {
				 rightTimeInputed = false;
				 return;
			 } else if (UniDate.getDbDateStr(record.data.DUTY_FR_D) != '' && UniDate.getDbDateStr(record.data.DUTY_TO_D) != '') {
				 if ((UniDate.getDbDateStr(record.data.DUTY_FR_D) > UniDate.getDbDateStr(record.data.DUTY_TO_D))) {
					 rightTimeInputed = false;
					 return;
				 } else {
					var fr_time = parseInt(record.data.DUTY_FR_H + record.data.DUTY_FR_M);
					var to_time = parseInt(record.data.DUTY_TO_H + record.data.DUTY_TO_M);
					if (UniDate.getDbDateStr(record.data.DUTY_FR_D) == UniDate.getDbDateStr(record.data.DUTY_TO_D) && fr_time > to_time) {
						rightTimeInputed = false;
						return;
					}
				 }
			 }
		 });

		 if (!rightTimeInputed) {
			 Ext.Msg.alert(MsgTitle, MsgErr01);
		 }else{//일자 필수값 체크..
		 	if(dutyRule == "Y"){
			 	var toCreate = store.getNewRecords();
	        	var toUpdate = store.getUpdatedRecords();
	        	var list = [].concat(toUpdate,toCreate);
				var isErr = false;
	        	Ext.each(list, function(record, index) {
	        		if(record.get('HOLY_TYPE') == '1' && record.get('HOLY_TYPE') == '2'){
    	        		if(Ext.isEmpty(record.get('DUTY_CODE')) && (Ext.isEmpty(record.get('DUTY_FR_D')) || Ext.isEmpty(record.get('DUTY_TO_D')))){
    						alert('일자를 입력해 주세요.');
    						isErr = true;
    						return false;
    					}
	        		}else{

	        		}
	        	});
	        	if(isErr) return false;
		 	}
		 }
		 return rightTimeInputed;
	}

	// TODO: prev, next


};


</script>
