<%@page language="java" contentType="text/html; charset=utf-8"%> 
	<t:appConfig pgmId="afb520ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A128" /> 		<!-- 예산과목구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A133" />			<!-- 전용구분 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	var budgNameList = ${budgNameList};
	var chargeInfoList 	= ${chargeInfoList};
	var fields	= createModelField(budgNameList);
	var columns	= createGridColumn(budgNameList);
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb520ukrService.selectList'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb520ukrService.selectListTab',
			update: 'afb520ukrService.updateDetail',
			create: 'afb520ukrService.insertDetail',
			destroy: 'afb520ukrService.deleteDetail',
			syncAll: 'afb520ukrService.saveAll'
		}
	});
	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb520ukrService.selectListTab',
			update: 'afb520ukrService.updateDetail',
			create: 'afb520ukrService.insertDetail',
			destroy: 'afb520ukrService.deleteDetail',
			syncAll: 'afb520ukrService.saveAll'
		}
	});
	
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb520ukrService.selectListTab',
			update: 'afb520ukrService.updateDetail',
			create: 'afb520ukrService.insertDetail',
			destroy: 'afb520ukrService.deleteDetail',
			syncAll: 'afb520ukrService.saveAll'
		}
	});
	
	var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb520ukrService.selectListTab',
			update: 'afb520ukrService.updateDetail',
			create: 'afb520ukrService.insertDetail',
			destroy: 'afb520ukrService.deleteDetail',
			syncAll: 'afb520ukrService.saveAll'
		}
	});

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx340Model', {
	   fields:fields
	});		// End of Ext.define('Atx340ukrModel', {
	
	Unilite.defineModel('Atx340Model2', {
	   fields: [
			{name: 'COMP_CODE'					, text: '법인코드'			, type: 'string'},
			{name: 'AC_YYYY'					, text: '사업년도'			, type: 'string'},
			{name: 'DEPT_CODE'					, text: '부서코드'			, type: 'string'},
			{name: 'BUDG_CODE'					, text: '예산코드'			, type: 'string'},
			{name: 'BUDG_YYYYMM'				, text: '예산년월'			, type: 'string'	, allowBlank: false},
			{name: 'SEQ'						, text: '순번'			, type: 'uniNumber'},
			{name: 'DIVERT_DIVI'				, text: '전용구분'			, type: 'string'	, allowBlank: false		, comboType: 'AU'	, comboCode: 'A133'},
			{name: 'DIVERT_YYYYMM'				, text: '전용년월'			, type: 'string'	, allowBlank: false		, maxLength: 7},
			{name: 'DIVERT_DEPT_CODE'			, text: '전용부서'			, type: 'string'	, maxLength: 8},
			{name: 'DIVERT_DEPT_NAME'			, text: '전용부서명'			, type: 'string'	, maxLength: 30},
			{name: 'DIVERT_BUDG_CODE'			, text: '전용예산과목'		, type: 'string'	, allowBlank: false		, maxLength: 30},
			{name: 'DIVERT_BUDG_NAME'			, text: '전용예산과목명'		, type: 'string'	, maxLength: 100},
			{name: 'DIVERT_BUDG_I'				, text: '전용금액'			, type: 'uniPrice'	, allowBlank: false		, maxLength: 30},
			{name: 'REMARK'						, text: '비고'			, type: 'string'	, maxLength: 50},
			{name: 'CHARGE_CODE'				, text: '입력담당자코드'		, type: 'string'},
			{name: 'AP_STS'						, text: '승인상태'			, type: 'string'},
			{name: 'AP_DATE'					, text: '승인일'			, type: 'uniDate'},
			{name: 'AP_USER_ID'					, text: '승인자ID'			, type: 'string'},
			{name: 'AP_CHARGE_CODE'				, text: '승인담당자코드'		, type: 'string'},
			{name: 'INSERT_DB_USER'				, text: '입력자'			, type: 'string'},
			{name: 'INSERT_DB_TIME'				, text: '입력일'			, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'				, text: '수정자'			, type: 'string'},
			{name: 'UPDATE_DB_TIME'				, text: '수정일'			, type: 'uniDate'}
		]
	});
	
	var directMasterStore = Unilite.createStore('atx340MasterStore1',{
		model: 'Atx340Model',
		uniOpt: {
			isMaster: true,				// 상위 버튼 연결 
			editable: true,				// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.budgNameInfoList = budgNameList;		//예산목록	
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('atx340MasterStore2',{
		model: 'Atx340Model2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy2,
		loadStoreRecords: function(param) {
			if(param)	{
				param.DIVERT_DIVI = '1'
				console.log( param );
				this.load({
					params : param
				});
			}	
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();				
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
	   		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					} 
				};
				this.syncAllDirect(config);
			} else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var directMasterStore3 = Unilite.createStore('atx340MasterStore3',{
		model: 'Atx340Model2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy3,
		loadStoreRecords: function(param) {
			if(param)	{
				param.DIVERT_DIVI = '2'
				console.log( param );
				this.load({
					params : param
				});
			}	
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();				
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
	   		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					} 
				};
				this.syncAllDirect(config);
			} else {
				masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var directMasterStore4 = Unilite.createStore('atx340MasterStore4',{
		model: 'Atx340Model2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy4,
		loadStoreRecords: function(param) {
			if(param)	{
				param.DIVERT_DIVI = '3'
				console.log( param );
				this.load({
					params : param
				});
			}	
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();				
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
	   		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					} 
				};
				this.syncAllDirect(config);
			} else {
				masterGrid4.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var directMasterStore5 = Unilite.createStore('atx340MasterStore5',{
		model: 'Atx340Model2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy5,
		loadStoreRecords: function(param) {
			if(param)	{
				param.DIVERT_DIVI = '4'
				console.log( param );
				this.load({
					params : param
				});
			}	
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();				
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
	   		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					} 
				};
				this.syncAllDirect(config);
			} else {
				masterGrid5.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
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
			items: [{
					xtype: 'uniYearField',
					name: 'AC_YYYY',
					fieldLabel: '사업년도',
					value: new Date().getFullYear(),
					fieldStyle: 'text-align: center;',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AC_YYYY', newValue);
						}
					}
				 },
				 Unilite.popup('BUDG',{
						fieldLabel: '예산과목',
						valueFieldName:'BUDG_CODE_FR',
						textFieldName:'BUDG_NAME_FR',
						extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"},
						validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
									panelSearch.setValue('BUDG_NAME_FR', records[0][name]);	
									panelResult.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE_FR'));
									panelResult.setValue('BUDG_NAME_FR', panelSearch.getValue('BUDG_NAME_FR'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE_FR', '');
								panelResult.setValue('BUDG_NAME_FR', '');
								panelSearch.setValue('BUDG_CODE_FR', '');
								panelSearch.setValue('BUDG_NAME_FR', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
								popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
							}
						}
				}),
				 Unilite.popup('BUDG',{
						fieldLabel: '~',
						valueFieldName:'BUDG_CODE_TO',
						textFieldName:'BUDG_NAME_TO',
						extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"},
						validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
									panelSearch.setValue('BUDG_NAME_TO', records[0][name]);	
									panelResult.setValue('BUDG_CODE_TO', panelSearch.getValue('BUDG_CODE_TO'));
									panelResult.setValue('BUDG_NAME_TO', panelSearch.getValue('BUDG_NAME_TO'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE_TO', '');
								panelResult.setValue('BUDG_NAME_TO', '');
								panelSearch.setValue('BUDG_CODE_TO', '');
								panelSearch.setValue('BUDG_NAME_TO', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
								popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
							}
						}
				}),{
					xtype: 'uniCombobox',
					name: 'BUDG_TYPE',
					comboType:'AU',
					comboCode:'A132',
					fieldLabel: '수지구분',
					value: '2',
					holdable: 'hold',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BUDG_TYPE', newValue);
						}
					}
				 },
				 Unilite.popup('DEPT',{
						fieldLabel: '부서',
						allowBlank: false,
						valueFieldName:'DEPT_CODE',
						textFieldName:'DEPT_NAME',
						//validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
									panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_NAME', '');
								panelSearch.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_NAME', '');
							}
						}
				}),{
					xtype: 'uniTextfield',
					name: 'BUDG_NAME',
					fieldLabel: '예산과목명',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BUDG_NAME', newValue);
						}
					}
				 }, 
				 Unilite.popup('AC_PROJECT',{
						fieldLabel: '프로젝트',
						valueFieldName:'PJT_CODE',
						textFieldName:'PJT_NAME',
						//validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));
									panelResult.setValue('PJT_NAME', panelSearch.getValue('PJT_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('PJT_CODE', '');
								panelResult.setValue('PJT_NAME', '');
								panelSearch.setValue('PJT_CODE', '');
								panelSearch.setValue('PJT_NAME', '');
							}
						}
				})
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
				  		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
				  		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'uniYearField',
				name: 'AC_YYYY',
				fieldLabel: '사업년도',
				value: new Date().getFullYear(),
				fieldStyle: 'text-align: center;',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_YYYY', newValue);
					}
				}
			 },
			 Unilite.popup('BUDG',{
					fieldLabel: '예산과목',
					valueFieldName:'BUDG_CODE_FR',
					textFieldName:'BUDG_NAME_FR',
					extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"},
					validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
								panelResult.setValue('BUDG_NAME_FR', records[0][name]);	
								panelSearch.setValue('BUDG_CODE_FR', panelResult.getValue('BUDG_CODE_FR'));
								panelSearch.setValue('BUDG_NAME_FR', panelResult.getValue('BUDG_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BUDG_CODE_FR', '');
							panelSearch.setValue('BUDG_NAME_FR', '');
							panelResult.setValue('BUDG_CODE_FR', '');
							panelResult.setValue('BUDG_NAME_FR', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
							popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
						}
					}
			}),{
				xtype: 'uniCombobox',
				name: 'BUDG_TYPE',
				comboType:'AU',
				comboCode:'A132',
				fieldLabel: '수지구분',
				value: '2',
				holdable: 'hold',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BUDG_TYPE', newValue);
					}
				}
			 },
			 Unilite.popup('DEPT',{
					fieldLabel: '부서',
					allowBlank: false,
					valueFieldName:'DEPT_CODE',
					textFieldName:'DEPT_NAME',
					//validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						}
					}
			}),
			Unilite.popup('BUDG',{
					fieldLabel: '~',
					valueFieldName:'BUDG_CODE_TO',
					textFieldName:'BUDG_NAME_TO',
					validateBlank: false,
					extParam: {'ADD_QUERY': "GROUP_YN = N'N' AND USE_YN = N'Y'"},
					listeners: {
						onSelected: {
							fn: function(records, type) {
								var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
								panelResult.setValue('BUDG_NAME_TO', records[0][name]);	
								panelSearch.setValue('BUDG_CODE_TO', panelResult.getValue('BUDG_CODE_TO'));
								panelSearch.setValue('BUDG_NAME_TO', panelResult.getValue('BUDG_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BUDG_CODE_TO', '');
							panelResult.setValue('BUDG_NAME_TO', '');
							panelSearch.setValue('BUDG_CODE_TO', '');
							panelSearch.setValue('BUDG_NAME_TO', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
							popup.setExtParam({'DEPT_CODE': panelSearch.getValue('DEPT_CODE')});
						}
					}
			}),{
				xtype: 'uniTextfield',
				name: 'BUDG_NAME',
				fieldLabel: '예산과목명',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BUDG_NAME', newValue);
					}
				}
			 }, 
			 Unilite.popup('AC_PROJECT',{
					fieldLabel: '프로젝트',
					valueFieldName:'PJT_CODE',
					textFieldName:'PJT_NAME',
					//validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PJT_CODE', panelResult.getValue('PJT_CODE'));
								panelSearch.setValue('PJT_NAME', panelResult.getValue('PJT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PJT_CODE', '');
							panelResult.setValue('PJT_NAME', '');
							panelSearch.setValue('PJT_CODE', '');
							panelSearch.setValue('PJT_NAME', '');
						}
					}
			})
		],
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
	
	var masterGrid = Unilite.createGrid('afb520Grid1', {
		layout : 'fit',
		region : 'center',
		store: directMasterStore,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 	
			dock: 'top',
			showSummaryRow: false
		}],
		uniOpt: {						
			useMultipleSorting	: true,			
			useLiveSearch		: false,			
			onLoadSelectFirst	: true,				
			dblClickToEdit		: false,			
			useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: false,			
			useRowContext		: false,		
			filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
		},
		columns:columns,
		listeners: {
			selectionchange: function( grid, selected, eOpts) {
				if(selected && selected.length == 1)	{
					var param = {
						'AC_YYYY'			: selected[selected.length-1].get('AC_YYYY'),
						'DEPT_CODE'			: selected[selected.length-1].get('DEPT_CODE'),
						'BUDG_CODE'			: selected[selected.length-1].get('BUDG_CODE'),
						'MONTH'				: '',
						'DIVERT_DIVI'		: ''
					}
					var activeTabId = tab.getActiveTab().getId();			
					if(activeTabId == 'afb520Grid2'){
					directMasterStore2.loadStoreRecords(param);		
					} else if(activeTabId == 'afb520Grid3'){	
					directMasterStore3.loadStoreRecords(param);				
					} else if(activeTabId == 'afb520Grid4'){	
					directMasterStore4.loadStoreRecords(param);				
					} else if(activeTabId == 'afb520Grid5'){	
					directMasterStore5.loadStoreRecords(param);				
					}
				}
			},
			beforeedit:function( editor, context, eOpts )	{
				if(context.field)	{
					return false;
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					selectedMasterGrid = 'afb520Grid1';
					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				});
			}
		}
	});
	
	var masterGrid2 = Unilite.createGrid('afb520Grid2', {
		layout : 'fit',
		region : 'center',
		title: '예산조정',
		store: directMasterStore2,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true 
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 	
			dock: 'top',
			showSummaryRow: true
		}],
//		tbar: [{
//				fieldLabel: '합계', 
//				name:'ITEM_ACCOUNT', 
//				xtype: 'uniTextfield'
//			}
//		],
		uniOpt: {						
			useMultipleSorting	: true,			
			useLiveSearch		: false,			
			onLoadSelectFirst	: true,				
			dblClickToEdit		: true,			
			useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: false,		
			filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
		},
		columns: [
//			{dataIndex: 'COMP_CODE'					, width: 88, hidden: true},
//			{dataIndex: 'AC_YYYY'					, width: 88, hidden: true},
//			{dataIndex: 'DEPT_CODE'					, width: 88, hidden: true},
//			{dataIndex: 'BUDG_CODE'					, width: 88, hidden: true},
			{dataIndex: 'BUDG_YYYYMM'				, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
//			{dataIndex: 'SEQ'						, width: 88, hidden: true},
			{dataIndex: 'DIVERT_DIVI'				, width: 80},
			{dataIndex: 'DIVERT_YYYYMM'				, width: 80},
			{dataIndex: 'DIVERT_DEPT_CODE'			, width: 106,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					DBtextFieldName: 'TREE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', '');
							grdRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'DIVERT_DEPT_NAME'			, width: 133,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', '');
							grdRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'DIVERT_BUDG_CODE'			, width: 166,
				editor: Unilite.popup('BUDG_G',{
					textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							
							grdRecord.set('DIVERT_BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('DIVERT_BUDG_NAME'		,records[0][budgName]);
						},
						onClear:function(type)	{
					  		var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('DIVERT_BUDG_CODE'		,'');
							grdRecord.set('DIVERT_BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid2.uniOpt.currentRecord;
								var param = {
									'AC_YYYY' : grdRecord.get('AC_YYYY'),
									'DEPT_CODE' : grdRecord.get('DIVERT_DEPT_CODE'),
									'ADD_QUERY' : "GROUP_YN = N'N' AND USE_YN = N'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{dataIndex: 'DIVERT_BUDG_NAME'			, width: 133,
				editor: Unilite.popup('BUDG_G',{
					textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
							var grdRecord = masterGrid2.uniOpt.currentRecord;
							
							grdRecord.set('DIVERT_BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('DIVERT_BUDG_NAME'		,records[0][budgName]);
						},
						onClear:function(type)	{
					  		var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('DIVERT_BUDG_CODE'		,'');
							grdRecord.set('DIVERT_BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid2.uniOpt.currentRecord;
								var param = {
									'AC_YYYY' : grdRecord.get('AC_YYYY'),
									'DEPT_CODE' : grdRecord.get('DIVERT_DEPT_CODE'),
									'ADD_QUERY' : "GROUP_YN = N'N' AND USE_YN = N'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
//			{dataIndex: 'ORG_DIVERT_BUDG_I'			, width: 106, hidden: true},
			{dataIndex: 'DIVERT_BUDG_I'				, width: 106, summaryType: 'sum'},
			{dataIndex: 'REMARK'					, width: 106/*, flex: 1*/}
//			{dataIndex: 'CHARGE_CODE'				, width: 88, hidden: true},
//			{dataIndex: 'AP_STS'					, width: 88, hidden: true},
//			{dataIndex: 'AP_DATE'					, width: 88, hidden: true},
//			{dataIndex: 'AP_USER_ID'				, width: 88, hidden: true},
//			{dataIndex: 'AP_CHARGE_CODE'			, width: 88, hidden: true},
//			{dataIndex: 'INSERT_DB_USER'			, width: 88, hidden: true},
//			{dataIndex: 'INSERT_DB_TIME'			, width: 88, hidden: true},
//			{dataIndex: 'UPDATE_DB_USER'			, width: 88, hidden: true},
//			{dataIndex: 'UPDATE_DB_TIME'			, width: 88, hidden: true}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				var count = masterGrid2.getStore().getCount();
				if(count > 0) {
					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
				} else {
					UniAppManager.setToolbarButtons(['newData'], true);
				}
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					selectedMasterGrid = 'afb520Grid2';
					var count = masterGrid2.getStore().getCount();
					if(count > 0) {
						UniAppManager.setToolbarButtons(['newData', 'delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['newData'], true);
					}
				});
			},
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['DIVERT_BUDG_I', 'REMARK'])) 
					{ 
						return true;
	  				} else {
	  					return false;
	  				}
				} else {
					if(UniUtils.indexOf(e.field, ['BUDG_YYYYMM', 'DIVERT_DIVI']))
				   	{
						return false;
	  				} else {
	  					return true;
	  				}
				}
			}
		}
	});
	
	var masterGrid3 = Unilite.createGrid('afb520Grid3', {
		layout : 'fit',
		region : 'center',
		title: '당겨배정',
		store: directMasterStore3,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 	
			dock: 'top',
			showSummaryRow: true
		}],
//		tbar: [{
//				fieldLabel: '합계', 
//				name:'ITEM_ACCOUNT', 
//				xtype: 'uniTextfield'
//			}
//		],
		uniOpt: {						
			useMultipleSorting	: true,			
			useLiveSearch		: false,			
			onLoadSelectFirst	: true,				
			dblClickToEdit		: true,			
			useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: false,		
			filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
		},
		columns: [
//			{dataIndex: 'COMP_CODE'					, width: 88, hidden: true},
//			{dataIndex: 'AC_YYYY'					, width: 88, hidden: true},
//			{dataIndex: 'DEPT_CODE'					, width: 88, hidden: true},
//			{dataIndex: 'BUDG_CODE'					, width: 88, hidden: true},
			{dataIndex: 'BUDG_YYYYMM'				, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
//			{dataIndex: 'SEQ'						, width: 88, hidden: true},
			{dataIndex: 'DIVERT_DIVI'				, width: 80},
			{dataIndex: 'DIVERT_YYYYMM'				, width: 80},
			{dataIndex: 'DIVERT_DEPT_CODE'			, width: 106,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					DBtextFieldName: 'TREE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid3.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid3.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', '');
							grdRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'DIVERT_DEPT_NAME'			, width: 133,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid3.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid3.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', '');
							grdRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'DIVERT_BUDG_CODE'			, width: 166,
				editor: Unilite.popup('BUDG_G',{
					textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
							var grdRecord = masterGrid3.uniOpt.currentRecord;
							
							grdRecord.set('DIVERT_BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('DIVERT_BUDG_NAME'		,records[0][budgName]);
						},
						onClear:function(type)	{
					  		var grdRecord = masterGrid3.uniOpt.currentRecord;
							grdRecord.set('DIVERT_BUDG_CODE'		,'');
							grdRecord.set('DIVERT_BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid3.uniOpt.currentRecord;
								var param = {
									'AC_YYYY' : grdRecord.get('AC_YYYY'),
									'DEPT_CODE' : grdRecord.get('DIVERT_DEPT_CODE'),
									'ADD_QUERY' : "GROUP_YN = N'N' AND USE_YN = N'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{dataIndex: 'DIVERT_BUDG_NAME'			, width: 133,
				editor: Unilite.popup('BUDG_G',{
					textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
							var grdRecord = masterGrid3.uniOpt.currentRecord;
							
							grdRecord.set('DIVERT_BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('DIVERT_BUDG_NAME'		,records[0][budgName]);
						},
						onClear:function(type)	{
					  		var grdRecord = masterGrid3.uniOpt.currentRecord;
							grdRecord.set('DIVERT_BUDG_CODE'		,'');
							grdRecord.set('DIVERT_BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid3.uniOpt.currentRecord;
								var param = {
									'AC_YYYY' : grdRecord.get('AC_YYYY'),
									'DEPT_CODE' : grdRecord.get('DIVERT_DEPT_CODE'),
									'ADD_QUERY' : "GROUP_YN = N'N' AND USE_YN = N'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
//			{dataIndex: 'ORG_DIVERT_BUDG_I'			, width: 106, hidden: true},
			{dataIndex: 'DIVERT_BUDG_I'				, width: 106, summaryType: 'sum'},
			{dataIndex: 'REMARK'					, width: 106/*, flex: 1*/}
//			{dataIndex: 'CHARGE_CODE'				, width: 88, hidden: true},
//			{dataIndex: 'AP_STS'					, width: 88, hidden: true},
//			{dataIndex: 'AP_DATE'					, width: 88, hidden: true},
//			{dataIndex: 'AP_USER_ID'				, width: 88, hidden: true},
//			{dataIndex: 'AP_CHARGE_CODE'			, width: 88, hidden: true},
//			{dataIndex: 'INSERT_DB_USER'			, width: 88, hidden: true},
//			{dataIndex: 'INSERT_DB_TIME'			, width: 88, hidden: true},
//			{dataIndex: 'UPDATE_DB_USER'			, width: 88, hidden: true},
//			{dataIndex: 'UPDATE_DB_TIME'			, width: 88, hidden: true}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				var count = masterGrid3.getStore().getCount();
				if(count > 0) {
					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
				} else {
					UniAppManager.setToolbarButtons(['newData'], true);
				}
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					selectedMasterGrid = 'afb520Grid3';
					var count = masterGrid3.getStore().getCount();
					if(count > 0) {
						UniAppManager.setToolbarButtons(['newData', 'delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['newData'], true);
					}
				});
			},
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['DIVERT_BUDG_I', 'REMARK'])) 
					{ 
						return true;
	  				} else {
	  					return false;
	  				}
				} else {
					if(UniUtils.indexOf(e.field, ['DIVERT_YYYYMM', 'DIVERT_BUDG_I', 'REMARK']))
				   	{
						return true;
	  				} else {
	  					return false;
	  				}
				}
			}
		}
	});
	
	var masterGrid4 = Unilite.createGrid('afb520Grid4', {
		layout : 'fit',
		region : 'center',
		title: '예산전용',
		store: directMasterStore4,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true 
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 	
			dock: 'top',
			showSummaryRow: true
		}],
//		tbar: [{
//				fieldLabel: '합계', 
//				name:'ITEM_ACCOUNT', 
//				xtype: 'uniTextfield'
//			}
//		],
		uniOpt: {						
			useMultipleSorting	: true,			
			useLiveSearch		: false,			
			onLoadSelectFirst	: true,				
			dblClickToEdit		: true,			
			useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: false,		
			filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
		},
		columns: [
//			{dataIndex: 'COMP_CODE'					, width: 88, hidden: true},
//			{dataIndex: 'AC_YYYY'					, width: 88, hidden: true},
//			{dataIndex: 'DEPT_CODE'					, width: 88, hidden: true},
//			{dataIndex: 'BUDG_CODE'					, width: 88, hidden: true},
			{dataIndex: 'BUDG_YYYYMM'				, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
//			{dataIndex: 'SEQ'						, width: 88, hidden: true},
			{dataIndex: 'DIVERT_DIVI'				, width: 80},
			{dataIndex: 'DIVERT_YYYYMM'				, width: 80},
			{dataIndex: 'DIVERT_DEPT_CODE'			, width: 106,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					DBtextFieldName: 'TREE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid4.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid4.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', '');
							grdRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'DIVERT_DEPT_NAME'			, width: 133,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid4.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid4.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', '');
							grdRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'DIVERT_BUDG_CODE'			, width: 166,
				editor: Unilite.popup('BUDG_G',{
					textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
							var grdRecord = masterGrid4.uniOpt.currentRecord;
							
							grdRecord.set('DIVERT_BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('DIVERT_BUDG_NAME'		,records[0][budgName]);
						},
						onClear:function(type)	{
					  		var grdRecord = masterGrid4.uniOpt.currentRecord;
							grdRecord.set('DIVERT_BUDG_CODE'		,'');
							grdRecord.set('DIVERT_BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid4.uniOpt.currentRecord;
								var param = {
									'AC_YYYY' : grdRecord.get('AC_YYYY'),
									'DEPT_CODE' : grdRecord.get('DIVERT_DEPT_CODE'),
									'ADD_QUERY' : "GROUP_YN = N'N' AND USE_YN = N'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{dataIndex: 'DIVERT_BUDG_NAME'			, width: 133,
				editor: Unilite.popup('BUDG_G',{
					textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
							var grdRecord = masterGrid4.uniOpt.currentRecord;
							
							grdRecord.set('DIVERT_BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('DIVERT_BUDG_NAME'		,records[0][budgName]);
						},
						onClear:function(type)	{
					  		var grdRecord = masterGrid4.uniOpt.currentRecord;
							grdRecord.set('DIVERT_BUDG_CODE'		,'');
							grdRecord.set('DIVERT_BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid4.uniOpt.currentRecord;
								var param = {
									'AC_YYYY' : grdRecord.get('AC_YYYY'),
									'DEPT_CODE' : grdRecord.get('DIVERT_DEPT_CODE'),
									'ADD_QUERY' : "GROUP_YN = N'N' AND USE_YN = N'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
//			{dataIndex: 'ORG_DIVERT_BUDG_I'			, width: 106, hidden: true},
			{dataIndex: 'DIVERT_BUDG_I'				, width: 106, summaryType: 'sum'},
			{dataIndex: 'REMARK'					, width: 106/*, flex: 1*/}
//			{dataIndex: 'CHARGE_CODE'				, width: 88, hidden: true},
//			{dataIndex: 'AP_STS'					, width: 88, hidden: true},
//			{dataIndex: 'AP_DATE'					, width: 88, hidden: true},
//			{dataIndex: 'AP_USER_ID'				, width: 88, hidden: true},
//			{dataIndex: 'AP_CHARGE_CODE'			, width: 88, hidden: true},
//			{dataIndex: 'INSERT_DB_USER'			, width: 88, hidden: true},
//			{dataIndex: 'INSERT_DB_TIME'			, width: 88, hidden: true},
//			{dataIndex: 'UPDATE_DB_USER'			, width: 88, hidden: true},
//			{dataIndex: 'UPDATE_DB_TIME'			, width: 88, hidden: true}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				var count = masterGrid4.getStore().getCount();
				if(count > 0) {
					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
				} else {
					UniAppManager.setToolbarButtons(['newData'], true);
				}
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					selectedMasterGrid = 'afb520Grid4';
					var count = masterGrid4.getStore().getCount();
					if(count > 0) {
						UniAppManager.setToolbarButtons(['newData', 'delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['newData'], true);
					}
				});
			},
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['DIVERT_BUDG_I', 'REMARK'])) 
					{ 
						return true;
	  				} else {
	  					return false;
	  				}
				} else {
					if(UniUtils.indexOf(e.field, ['DIVERT_BUDG_CODE', 'DIVERT_BUDG_NAME', 'DIVERT_BUDG_I', 'REMARK']))
				   	{
						return true;
	  				} else {
	  					return false;
	  				}
				}
			}
		}
	});
	
	var masterGrid5 = Unilite.createGrid('afb520Grid5', {
		layout : 'fit',
		region : 'center',
		title: '추경예산',
		store: directMasterStore5,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true 
		},{
			id: 'masterGridTotal', 	
			ftype: 'uniSummary', 	
			dock: 'top',
			showSummaryRow: true
		}],
//		tbar: [{
//				fieldLabel: '합계', 
//				name:'ITEM_ACCOUNT', 
//				xtype: 'uniTextfield'
//			}
//		],
		uniOpt: {						
			useMultipleSorting	: true,			
			useLiveSearch		: false,			
			onLoadSelectFirst	: true,				
			dblClickToEdit		: true,			
			useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: false,		
			filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}
		},
		columns: [
//			{dataIndex: 'COMP_CODE'					, width: 88, hidden: true},
//			{dataIndex: 'AC_YYYY'					, width: 88, hidden: true},
//			{dataIndex: 'DEPT_CODE'					, width: 88, hidden: true},
//			{dataIndex: 'BUDG_CODE'					, width: 88, hidden: true},
			{dataIndex: 'BUDG_YYYYMM'				, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
//			{dataIndex: 'SEQ'						, width: 88, hidden: true},
			{dataIndex: 'DIVERT_DIVI'				, width: 80},
			{dataIndex: 'DIVERT_YYYYMM'				, width: 80},
			{dataIndex: 'DIVERT_DEPT_CODE'			, width: 106,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					DBtextFieldName: 'TREE_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid5.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid5.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', '');
							grdRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'DIVERT_DEPT_NAME'			, width: 133,
				editor:Unilite.popup('DEPT_G', {
					autoPopup: true,
					textFieldName:'DEPT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid5.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', records[0].TREE_CODE);
							grdRecord.set('DIVERT_DEPT_NAME', records[0].TREE_NAME);
							
						},
						onClear:function(type)	{
							var grdRecord = masterGrid5.uniOpt.currentRecord;
							grdRecord.set('DIVERT_DEPT_CODE', '');
							grdRecord.set('DIVERT_DEPT_NAME', '');
						}
					}
				})
			},
			{dataIndex: 'DIVERT_BUDG_CODE'			, width: 166,
				editor: Unilite.popup('BUDG_G',{
					textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
							var grdRecord = masterGrid5.uniOpt.currentRecord;
							
							grdRecord.set('DIVERT_BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('DIVERT_BUDG_NAME'		,records[0][budgName]);
						},
						onClear:function(type)	{
					  		var grdRecord = masterGrid5.uniOpt.currentRecord;
							grdRecord.set('DIVERT_BUDG_CODE'		,'');
							grdRecord.set('DIVERT_BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid5.uniOpt.currentRecord;
								var param = {
									'AC_YYYY' : grdRecord.get('AC_YYYY'),
									'DEPT_CODE' : grdRecord.get('DIVERT_DEPT_CODE'),
									'ADD_QUERY' : "GROUP_YN = N'N' AND USE_YN = N'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{dataIndex: 'DIVERT_BUDG_NAME'			, width: 133,
				editor: Unilite.popup('BUDG_G',{
					textFieldName: 'BUDG_NAME_L1',
					DBtextFieldName: 'BUDG_NAME_L1',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var budgName = "BUDG_NAME_L"+records[0]["CODE_LEVEL"];
							var grdRecord = masterGrid5.uniOpt.currentRecord;
							
							grdRecord.set('DIVERT_BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('DIVERT_BUDG_NAME'		,records[0][budgName]);
						},
						onClear:function(type)	{
					  		var grdRecord = masterGrid5.uniOpt.currentRecord;
							grdRecord.set('DIVERT_BUDG_CODE'		,'');
							grdRecord.set('DIVERT_BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid5.uniOpt.currentRecord;
								var param = {
									'AC_YYYY' : grdRecord.get('AC_YYYY'),
									'DEPT_CODE' : grdRecord.get('DIVERT_DEPT_CODE'),
									'ADD_QUERY' : "GROUP_YN = N'N' AND USE_YN = N'Y'"
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
//			{dataIndex: 'ORG_DIVERT_BUDG_I'			, width: 106, hidden: true},
			{dataIndex: 'DIVERT_BUDG_I'				, width: 106, summaryType: 'sum'},
			{dataIndex: 'REMARK'					, width: 106/*, flex: 1*/}
//			{dataIndex: 'CHARGE_CODE'				, width: 88, hidden: true},
//			{dataIndex: 'AP_STS'					, width: 88, hidden: true},
//			{dataIndex: 'AP_DATE'					, width: 88, hidden: true},
//			{dataIndex: 'AP_USER_ID'				, width: 88, hidden: true},
//			{dataIndex: 'AP_CHARGE_CODE'			, width: 88, hidden: true},
//			{dataIndex: 'INSERT_DB_USER'			, width: 88, hidden: true},
//			{dataIndex: 'INSERT_DB_TIME'			, width: 88, hidden: true},
//			{dataIndex: 'UPDATE_DB_USER'			, width: 88, hidden: true},
//			{dataIndex: 'UPDATE_DB_TIME'			, width: 88, hidden: true}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				var count = masterGrid5.getStore().getCount();
				if(count > 0) {
					UniAppManager.setToolbarButtons(['newData', 'delete'], true);
				} else {
					UniAppManager.setToolbarButtons(['newData'], true);
				}
			},
			render: function(grid, eOpts) {
			 	var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					selectedMasterGrid = 'afb520Grid5';
					var count = masterGrid5.getStore().getCount();
					if(count > 0) {
						UniAppManager.setToolbarButtons(['newData', 'delete'], true);
					} else {
						UniAppManager.setToolbarButtons(['newData'], true);
					}
				});
			},
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['DIVERT_BUDG_I', 'REMARK'])) 
					{ 
						return true;
	  				} else {
	  					return false;
	  				}
				} else {
					if(UniUtils.indexOf(e.field, ['DIVERT_BUDG_I', 'REMARK']))
				   	{
						return true;
	  				} else {
	  					return false;
	  				}
				}
			}
		}	
	});
	
	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab:  0,
		region: 'south',
		items:  [
			 masterGrid2,
			 masterGrid3,
			 masterGrid4,
			 masterGrid5
		],
		 listeners:  {
		 	beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {
		 		var newTabId = newCard.getId();
					console.log("newCard:  " + newCard.getId());
					console.log("oldCard:  " + oldCard.getId());
				var count = masterGrid.getStore().getCount();
				if(count > 0) {
					var record = masterGrid.getSelectedRecord();
					var param = {
						'AC_YYYY'			: record.get('AC_YYYY'),
						'DEPT_CODE'			: record.get('DEPT_CODE'),
						'BUDG_CODE'			: record.get('BUDG_CODE'),
						'MONTH'				: '',
						'DIVERT_DIVI'		: ''
					}
					switch(newTabId)	{
						case 'afb520Grid2':
							directMasterStore2.loadStoreRecords(param)
							break;
						
						case 'afb520Grid3':
							directMasterStore3.loadStoreRecords(param)
							break;
							
						case 'afb520Grid4':
							directMasterStore4.loadStoreRecords(param)
							break;
							
						case 'afb520Grid5':
							directMasterStore5.loadStoreRecords(param)
							break;
							
						default:
							break;
					}
				} else {
					switch(newTabId)	{
						case 'afb520Grid2':
							break;
						
						case 'afb520Grid3':
							break;
							
						case 'afb520Grid4':
							break;
							
						case 'afb520Grid5':
							break;
							
						default:
							break;
					}
				}
		 	}
		 }
	});
	
	Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, tab, panelResult
			]	
		}		
		, panelSearch
		],
		id  : 'afb520ukrApp',
		fnInitBinding : function() {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_YYYY');
			panelSearch.setValue('AC_YYYY'		, new Date().getFullYear());
			panelResult.setValue('AC_YYYY'		, new Date().getFullYear());
			panelSearch.setValue('BUDG_TYPE'	, '2');
			panelResult.setValue('BUDG_TYPE'	, '2');
			UniAppManager.setToolbarButtons('save', false);
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid2.reset();
			masterGrid3.reset();
			masterGrid4.reset();
			masterGrid5.reset();
			directMasterStore.clearData();
			directMasterStore2.clearData();
			directMasterStore3.clearData();
			directMasterStore4.clearData();
			directMasterStore5.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {	
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'afb520Grid2') {
				directMasterStore2.saveStore();
			} else if(activeTabId == 'afb520Grid3') {
				directMasterStore3.saveStore();
			} else if(activeTabId == 'afb520Grid4') {
				directMasterStore4.saveStore();
			} else if(activeTabId == 'afb520Grid5') {
				directMasterStore5.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'afb520Grid2') {
				if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid2.deleteSelectedRow();
				}
			} else if(activeTabId == 'afb520Grid3') {
				if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid3.deleteSelectedRow();
				}		
			} else if(activeTabId == 'afb520Grid4') {
				if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid4.deleteSelectedRow();
				}			
			} else if(activeTabId == 'afb520Grid5') {
				if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid5.deleteSelectedRow();
				}			
			}
		},
		onNewDataButtonDown: function(records)	{		// 행추가 
			var activeTabId = tab.getActiveTab().getId();	
			var record = masterGrid.getSelectedRecord();
			if(Ext.isEmpty(record)) {
				alert(Msg.sMA0256);
				return false
			}
			if(activeTabId == 'afb520Grid2') {
				var budgYyyyMm			= UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6);	
				var divertDivi			= '1';
				var chargeCode			= chargeInfoList[0].CHARGE_CODE;
				var apSts				= '1';
				var orgDibertBudgI		= '0';
				var seq					= '0';
				var acYyyy				= record.data.AC_YYYY;
				var deptCode			= panelSearch.getValue('DEPT_CODE');
				var budgCode			= record.data.BUDG_CODE;
				
				var r = {
					'BUDG_YYYYMM'			: budgYyyyMm,
					'DIVERT_DIVI'			: divertDivi,
					'CHARGE_CODE'			: chargeCode,
					'AP_STS'				: apSts,
					'ORG_DIVERT_BUDG_I'		: orgDibertBudgI,
					'SEQ'					: seq,
					'AC_YYYY'				: acYyyy,
					'DEPT_CODE'				: deptCode,
					'BUDG_CODE'				: budgCode
				}
				masterGrid2.createRow(r);
			} else if(activeTabId == 'afb520Grid3') {
				var budgYyyyMm			= UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6);   
				var divertDivi			= '2';
				var divertDeptCode		= panelSearch.getValue('DEPT_CODE');   
				var divertDeptName		= panelSearch.getValue('DEPT_NAME'); 
				var divertBudgCode		= record.data.BUDG_CODE;
				var divertBudgName		= record.data.BUDG_NAME_L7;
				var chargeCode			= chargeInfoList[0].CHARGE_CODE;
				var apSts				= '1';
				var orgDibertBudgI		= '0';
				var seq					= '0';
				var acYyyy				= record.data.AC_YYYY;
				var deptCode			= panelSearch.getValue('DEPT_CODE');
				var budgCode			= record.data.BUDG_CODE;
				
				var r = {
					'BUDG_YYYYMM'			: budgYyyyMm,
					'DIVERT_DIVI'			: divertDivi,
					'DIVERT_DEPT_CODE'		: divertDeptCode,
					'DIVERT_DEPT_NAME'		: divertDeptName,
					'DIVERT_BUDG_CODE'		: divertBudgCode,
					'DIVERT_BUDG_NAME'		: divertBudgName,
					'CHARGE_CODE'			: chargeCode,
					'AP_STS'				: apSts,
					'ORG_DIVERT_BUDG_I'		: orgDibertBudgI,
					'SEQ'					: seq,
					'AC_YYYY'				: acYyyy,
					'DEPT_CODE'				: deptCode,
					'BUDG_CODE'				: budgCode
				}
				masterGrid3.createRow(r);
			} else if(activeTabId == 'afb520Grid4') {
				var budgYyyyMm			= UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6);   
				var divertDivi			= '3';
				var divertYyyyMm		= UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6);   
				var divertDeptCode		= panelSearch.getValue('DEPT_CODE');   
				var divertDeptName		= panelSearch.getValue('DEPT_NAME'); 
				var chargeCode			= chargeInfoList[0].CHARGE_CODE;
				var apSts				= '1';
				var orgDibertBudgI		= '0';
				var seq					= '0';
				var acYyyy				= record.data.AC_YYYY;
				var deptCode			= panelSearch.getValue('DEPT_CODE');
				var budgCode			= record.data.BUDG_CODE;
				
				var r = {
					'BUDG_YYYYMM'			: budgYyyyMm,
					'DIVERT_DIVI'			: divertDivi,
					'DIVERT_YYYYMM'			: divertYyyyMm,
					'DIVERT_DEPT_CODE'		: divertDeptCode,
					'DIVERT_DEPT_NAME'		: divertDeptName,
					'CHARGE_CODE'			: chargeCode,
					'AP_STS'				: apSts,
					'ORG_DIVERT_BUDG_I'		: orgDibertBudgI,
					'SEQ'					: seq,
					'AC_YYYY'				: acYyyy,
					'DEPT_CODE'				: deptCode,
					'BUDG_CODE'				: budgCode
				}
				masterGrid4.createRow(r);
			} else if(activeTabId == 'afb520Grid5') {
				var budgYyyyMm			= UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6);   
				var divertDivi			= '4';
				var divertYyyyMm		= UniDate.getDbDateStr(UniDate.get('today')).substring(0, 6);   
				var divertDeptCode		= panelSearch.getValue('DEPT_CODE');   
				var divertDeptName		= panelSearch.getValue('DEPT_NAME'); 
				var divertBudgCode		= record.data.BUDG_CODE;
				var divertBudgName		= record.data.BUDG_NAME_L7;
				var chargeCode			= chargeInfoList[0].CHARGE_CODE;
				var apSts				= '1';
				var orgDibertBudgI		= '0';
				var seq					= '0';
				var acYyyy				= record.data.AC_YYYY;
				var deptCode			= panelSearch.getValue('DEPT_CODE');
				var budgCode			= record.data.BUDG_CODE;
				
				var r = {
					'BUDG_YYYYMM'			: budgYyyyMm,
					'DIVERT_DIVI'			: divertDivi,
					'DIVERT_YYYYMM'			: divertYyyyMm,
					'DIVERT_DEPT_CODE'		: divertDeptCode,
					'DIVERT_DEPT_NAME'		: divertDeptName,
					'DIVERT_BUDG_CODE'		: divertBudgCode,
					'DIVERT_BUDG_NAME'		: divertBudgName,
					'CHARGE_CODE'			: chargeCode,
					'AP_STS'				: apSts,
					'ORG_DIVERT_BUDG_I'		: orgDibertBudgI,
					'SEQ'					: seq,
					'AC_YYYY'				: acYyyy,
					'DEPT_CODE'				: deptCode,
					'BUDG_CODE'				: budgCode
				}
				masterGrid5.createRow(r);
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setFieldsReadOnly(true);
			return panelResult.setFieldsReadOnly(true);
		}

	});
	
	// 모델필드 생성
	function createModelField(budgNameList) {
		var fields = [
			{name: 'COMP_CODE'			, text: '법인코드'					, type: 'string'},
			{name: 'AC_YYYY'			, text: '사업년도'					, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'					, type: 'string'},
			{name: 'BUDG_CODE'			, text: '예산코드'					, type: 'string'},
			// 예산명
			{name: 'BUDG_I'				, text: '연간예산금액'				, type: 'uniPrice'},
			{name: 'BUDG_I00'			, text: '전용가능금액'				, type: 'uniPrice'},
			{name: 'BUDG_I01'			, text: '1월'					, type: 'uniPrice'},
			{name: 'BUDG_I02'			, text: '2월'					, type: 'uniPrice'},
			{name: 'BUDG_I03'			, text: '3월'					, type: 'uniPrice'},
			{name: 'BUDG_I04'			, text: '4월'					, type: 'uniPrice'},
			{name: 'BUDG_I05'			, text: '5월'					, type: 'uniPrice'},
			{name: 'BUDG_I06'			, text: '6월'					, type: 'uniPrice'},
			{name: 'BUDG_I07'			, text: '7월'					, type: 'uniPrice'},
			{name: 'BUDG_I08'			, text: '8월'					, type: 'uniPrice'},
			{name: 'BUDG_I09'			, text: '9월'					, type: 'uniPrice'},
			{name: 'BUDG_I10'			, text: '10월'					, type: 'uniPrice'},
			{name: 'BUDG_I11'			, text: '11월'					, type: 'uniPrice'},
			{name: 'BUDG_I12'			, text: '12월'					, type: 'uniPrice'},
			{name: 'INSERT_DB_USER'		, text: '입력자'					, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '입력시간'					, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'					, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정시간'					, type: 'string'},
			{name: 'FR_BUDG_YYYYMM'		, text: 'FR_BUDG_YYYYM'			, type: 'string'},
			{name: 'CTL_TERM_UNIT'		, text: 'CTL_TERM_UNIT'			, type: 'string'}
		];
					
		Ext.each(budgNameList, function(item, index) {
			var name = 'BUDG_NAME_L'+(index + 1);
			fields.push({name: name, text: item.CODE_NAME, type:'string' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(budgNameList) {
		var columns = [		
//			{dataIndex: 'COMP_CODE'					, width: 88, hidden: true},
//			{dataIndex: 'AC_YYYY'					, width: 88, hidden: true},
//			{dataIndex: 'DEPT_CODE'					, width: 88, hidden: true},
			{dataIndex: 'BUDG_CODE'					, width: 133} 
			// 예산명(쿼리읽어서 컬럼 셋팅)
		];
		// 예산명(쿼리읽어서 컬럼 셋팅)
		Ext.each(budgNameList, function(item, index) {
			var dataIndex = 'BUDG_NAME_L'+(index + 1);
			columns.push({dataIndex: dataIndex,		width: 110});	
		});
		columns.push({dataIndex: 'BUDG_I'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I00'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I01'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I02'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I03'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I04'			, width: 106});	
		columns.push({dataIndex: 'BUDG_I05'			, width: 106});
		columns.push({dataIndex: 'BUDG_I06'			, width: 106});
		columns.push({dataIndex: 'BUDG_I07'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I08'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I09'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I10'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I11'			, width: 106}); 	
		columns.push({dataIndex: 'BUDG_I12'			, width: 106}); 
//		columns.push({dataIndex: 'INSERT_DB_USER'	, width: 106, hidden: true}); 	
//		columns.push({dataIndex: 'INSERT_DB_TIME'	, width: 106, hidden: true}); 	
//		columns.push({dataIndex: 'UPDATE_DB_USER'	, width: 106, hidden: true}); 	
//		columns.push({dataIndex: 'UPDATE_DB_TIME'	, width: 106, hidden: true}); 	
//		columns.push({dataIndex: 'FR_BUDG_YYYYMM'	, width: 106, hidden: true}); 	
//		columns.push({dataIndex: 'CTL_TERM_UNIT'	, width: 106, hidden: true}); 	
		return columns;
	}
	
	Unilite.createValidator('validator01', {		// 예산조정 탭 afterEdit
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var record1 = masterGrid.getSelectedRecord();
			var sDivertingAmt = 0 + parseInt(newValue) + parseInt(record.get('ORG_DIVERT_BUDG_I'));
			var sPossibleAmt = 0;
			var sYearPossibleAmt = record1.data.BUDG_I00;
			switch(fieldName) {
				case "DIVERT_BUDG_I" :			// 전용금액
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					if(record1.data.CTL_TERM_UNIT == '4') {
						if(sDivertingAmt > sYearPossibleAmt) {
							rv = "전용/배정금액은 전용가능금액을 초과할 수 없습니다. \n전용가능금액 : [" + sYearPossibleAmt + "]";
							break;
						}
					} else {
						if(sDivertingAmt > sPossibleAmt) {
							rv = "전용/배정금액은 전용가능금액을 초과할 수 없습니다. \n전용가능금액 : [" + sPossibleAmt + "]";
							break;
						}
					}
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {		// 당겨배정 탭 afterEdit
		store: directMasterStore3,
		grid: masterGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var record1 = masterGrid.getSelectedRecord();
			var sDivertingAmt = 0 + parseInt(newValue) + parseInt(record.get('ORG_DIVERT_BUDG_I'));
			var sPossibleAmt = 0;
			var sYearPossibleAmt = record1.data.BUDG_I00;
			switch(fieldName) {
				case "DIVERT_BUDG_I" :			// 전용금액
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					if(record1.data.CTL_TERM_UNIT == '4') {
						if(sDivertingAmt > sYearPossibleAmt) {
							alert("전용/배정금액은 전용가능금액을 초과할 수 없습니다. \n  전용가능금액 : [" + sYearPossibleAmt + "]");
							break;
						}
					} else {
						if(sDivertingAmt > sPossibleAmt) {
							rv = "전용/배정금액은 전용가능금액을 초과할 수 없습니다. \n전용가능금액 : [" + sPossibleAmt + "]";
							break;
						}
					}
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator03', {		// 예산전용 탭 afterEdit
		store: directMasterStore4,
		grid: masterGrid4,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var record1 = masterGrid.getSelectedRecord();
			var sDivertingAmt = 0 + parseInt(newValue) + parseInt(record.get('ORG_DIVERT_BUDG_I'));
			var sPossibleAmt = 0;
			var sYearPossibleAmt = record1.data.BUDG_I00;
			switch(fieldName) {
				case "DIVERT_BUDG_I" :			// 전용금액
					if(newValue < 0) {
						rv= Msg.sMP570;	
						break;
					}
					break;
					if(record1.data.CTL_TERM_UNIT == '4') {
						if(sDivertingAmt > sYearPossibleAmt) {
							rv = "전용/배정금액은 전용가능금액을 초과할 수 없습니다. \n전용가능금액 : [" + sYearPossibleAmt + "]";
							break;
						}
					} else {
						if(sDivertingAmt > sPossibleAmt) {
							rv = "전용/배정금액은 전용가능금액을 초과할 수 없습니다. \n전용가능금액 : [" + sPossibleAmt + "]";
							break;
						}
					}
					break;
			}
			return rv;
		}
	});
};

</script>
