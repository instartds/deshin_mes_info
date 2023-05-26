<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agd500ukr">
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장    -->
	<t:ExtComboStore comboType="AU" comboCode="A011" />
	<t:ExtComboStore comboType="AU" comboCode="A005" />
	<t:ExtComboStore comboType="AU" comboCode="A022" /><!-- 매입증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />
	<t:ExtComboStore comboType="AU" comboCode="A003" />
	<t:ExtComboStore comboType="AU" comboCode="A012" />
	<t:ExtComboStore comboType="AU" comboCode="A014" /><!--승인상태-->
	<t:ExtComboStore comboType="AU" comboCode="B013" />
	<t:ExtComboStore comboType="AU" comboCode="A058" />
	<t:ExtComboStore comboType="AU" comboCode="A149" />
	<t:ExtComboStore comboType="AU" comboCode="A070" />
	<t:ExtComboStore comboType="AU" comboCode="A398" />
</t:appConfig>

<script type="text/javascript">

function appMain() {
    var excelWindow;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'agd500ukrService.selectList',
			update	: 'agd500ukrService.updateMaster',
			destroy	: 'agd500ukrService.deleteMaster',
			syncAll	: 'agd500ukrService.saveMaster'
		}
	});
	
	/**
	 * 모델
	 */
	Unilite.defineModel('agd500ukrMasterModel', {
		fields: [
			 {name: 'PUB_DATE'    		,text: '일자'				,type: 'uniDate'	, allowBlank:false}
			,{name: 'STATUS'    		,text: '상태'				,type: 'string', comboType:'AU', comboCode:'A398'}
			,{name: 'CUSTOM_CODE'    	,text: '거래처'			,type: 'string'		}
			,{name: 'CUSTOM_NAME'    	,text: '거래처명'			,type: 'string'}
			,{name: 'PROOF_KIND_NM'    	,text: '증빙유형명'			,type: 'string'}
			,{name: 'PROOF_KIND'    	,text: '증빙유형'			,type: 'string'		, allowBlank:false, comboType:'AU', comboCode:'A022'}
			,{name: 'SUPPLY_AMT_I'    	,text: '공급가액'			,type: 'uniPrice'	, defaultValue:0}
			,{name: 'TAX_AMT_I'    		,text: '세액'				,type: 'uniPrice'	, defaultValue:0}
			,{name: 'TOT_AMT_I'    		,text: '합계'				,type: 'uniPrice'	, defaultValue:0}
			,{name: 'P_ACCNT'    		,text: '차변계정코드'			,type: 'string'}
			,{name: 'P_ACCNT_NAME' 		,text: '계정명'			,type: 'string'}
			,{name: 'REMARK'    		,text: '적요'				,type: 'string'}
			,{name: 'DEPT_NAME'    		,text: '귀속부서'			,type: 'string'		, allowBlank:false, defaultValue: UserInfo.deptName}
			,{name: 'DIV_CODE'    		,text: '사업장'			,type: 'string'		, allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode}
			
			,{name: 'EX_DATE'    		,text: '전표일자'			,type: 'uniDate'	, editable:false}
			,{name: 'EX_NUM'    		,text: '전표번호'			,type: 'int', editable:false}
			,{name: 'AGREE_YN'    		,text: '승인여부'			,type: 'string' , comboType:'AU', comboCode:'A014'}
			,{name: 'IN_DIV_CODE'    	,text: '결의사업장코드'		,type: 'string'		, defaultValue: UserInfo.divCode}
			,{name: 'IN_DEPT_CODE'    	,text: '결의부서코드'			,type: 'string'		, defaultValue: UserInfo.deptCode}
			,{name: 'IN_DEPT_NAME'    	,text: '결의부서명'			,type: 'string'		, defaultValue: UserInfo.deptName}
			,{name: 'DEPT_CODE'    		,text: '귀속부서코드'			,type: 'string'		, defaultValue: UserInfo.deptCode}
			,{name: 'BILL_DIV_CODE'    	,text: '신고사업장코드'		,type: 'string'		, defaultValue: UserInfo.divCode}
			,{name: 'CREDIT_NUM'    	,text: '카드번호/현금영수증'	,type: 'string'}
			,{name: 'SEQ'		    	,text: '순번'				,type: 'int'}
			,{name: 'COMP_CODE'    		,text: '법인코드'			,type: 'string'		, defaultValue: UserInfo.compCode}
		]
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch =  Unilite.createSearchPanel('searchForm', {
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
			items:[{
				fieldLabel		: '승인일자',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'EX_DATE_FR',
				endFieldName	: 'EX_DATE_TO',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('EX_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('EX_DATE_TO', newValue);
					}
				}
			},
			Unilite.popup('CREDIT_NO', {
				fieldLabel		: '신용카드', 
				valueFieldName	: 'CREDIT_NO_CODE',
				textFieldName	: 'CREDIT_NO_NAME',
				autoPopup		: true,
//				validateBlank	: 'text',	//20210421 주석
//				listeners: {				//20210421 주석
//					onValueFieldChange: function(field, newValue){
//						panelResult.setValue('CREDIT_NO_CODE', newValue);
//					},
//					onTextFieldChange: function(field, newValue){
//						panelResult.setValue('CREDIT_NO_NAME', newValue);
//					}
////				},
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CREDIT_NO_CODE', panelSearch.getValue('CREDIT_NO_CODE'));
							panelResult.setValue('CREDIT_NO_NAME', panelSearch.getValue('CREDIT_NO_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('CREDIT_NO_CODE', '');
						panelResult.setValue('CREDIT_NO_NAME', '');
					}
				}
			}),{
				fieldLabel	: '사업장',
				name		: 'IN_DIV_CODE',
				xtype		: 'uniCombobox' ,
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
//				hidden		: hideDivCode,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('IN_DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DEPT',{
				fieldLabel		: '결의부서',
//				popupWidth		: 910,
				valueFieldName	: 'IN_DEPT_CODE',
				textFieldName	: 'IN_DEPT_NAME',
				readOnly		: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('IN_DEPT_CODE', panelSearch.getValue('IN_DEPT_CODE'));
							panelResult.setValue('IN_DEPT_NAME', panelSearch.getValue('IN_DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('IN_DEPT_CODE', '');
						panelResult.setValue('IN_DEPT_NAME', '');
					},
					applyextparam: function(popup) {
//						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}  
			}),
			Unilite.popup('ACCNT_PRSN', {
				fieldLabel		: '입력자',
				valueFieldName	: 'CHARGE_CODE',
				textFieldName	: 'CHARGE_NAME',
				allowBlank		: false,
				textFieldWidth	: 150,
				readOnly		: true,
				showValue		: false
			}),{
				fieldLabel:'기표구분',
				xtype: 'radiogroup',
				fieldLabel: '조회구분',
				items: [{
					boxLabel: '전체', 
					width: 50, 
					name: 'SLIP_YN',
					inputValue: 'A'
				},{
					boxLabel : '미기표', 
					width: 70,
					name: 'SLIP_YN',
					inputValue: 'N'
				},{
					boxLabel : '기표', 
					width: 70,
					name: 'SLIP_YN',
					inputValue: 'Y'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('SLIP_YN').setValue(newValue.SLIP_YN);
					}
				}
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 5, tableAttrs:{'width':'100%'}},
		padding:0,
		border:true,
		items: [{
			fieldLabel		: '승인일자',
			width			:350,
			xtype			: 'uniDateRangefield',
			startFieldName	: 'EX_DATE_FR',
			endFieldName	: 'EX_DATE_TO',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('EX_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('EX_DATE_TO', newValue);
				}
			}
		},
		Unilite.popup('CREDIT_NO', {
			fieldLabel		: '신용카드',
			width			: 330,
			valueFieldName	: 'CREDIT_NO_CODE',
			textFieldName	: 'CREDIT_NO_NAME',
			autoPopup		: true,
//			validateBlank	: 'text',	//20210421 주석
//			listeners: {				//20210421 주석
//				onValueFieldChange: function(field, newValue){
//					panelSearch.setValue('CREDIT_NO_CODE', newValue);
//				},
//				onTextFieldChange: function(field, newValue){
//					panelSearch.setValue('CREDIT_NO_NAME', newValue);
//				}
//			},
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CREDIT_NO_CODE', panelResult.getValue('CREDIT_NO_CODE'));
						panelSearch.setValue('CREDIT_NO_NAME', panelResult.getValue('CREDIT_NO_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('CREDIT_NO_CODE', '');
					panelSearch.setValue('CREDIT_NO_NAME', '');
				}
			}
		}),{
			fieldLabel	: '사업장',
			name		: 'IN_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			//width		: 250,
//			hidden		: hideDivCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('IN_DIV_CODE', newValue);
				}
			}
		},{
			xtype		: 'component',
			html		: '',
			tdAttrs		: {width : '30%'}			//20210421 수정: 50% -> 30%
		},{
			xtype		: 'component',
			html		: '',
			width		: 120
		},
		Unilite.popup('DEPT',{ 
			fieldLabel		: '결의부서', 
//			popupWidth		: 910,
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'IN_DEPT_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('IN_DEPT_CODE', panelResult.getValue('IN_DEPT_CODE'));
						panelSearch.setValue('IN_DEPT_NAME', panelResult.getValue('IN_DEPT_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('IN_DEPT_CODE', '');
					panelSearch.setValue('IN_DEPT_NAME', '');
				},
				applyextparam: function(popup) {
//					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}  
		}),
		Unilite.popup('ACCNT_PRSN', {
			fieldLabel		: '입력자',
			valueFieldName	: 'CHARGE_CODE',
			textFieldName	: 'CHARGE_NAME',
			allowBlank		: false,
			textFieldWidth	: 150,
			readOnly		: true,
			showValue		: false
		}),{
			fieldLabel:'기표구분',
			xtype: 'radiogroup',
			fieldLabel: '조회구분',
			items: [{
				boxLabel: '전체', 
				width: 50, 
				name: 'SLIP_YN',
				inputValue: 'A'
			},{
				boxLabel : '미기표', 
				width: 70,
				name: 'SLIP_YN',
				inputValue: 'N'
			},{
				boxLabel : '기표', 
				width: 70,
				name: 'SLIP_YN',
				inputValue: 'Y'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('SLIP_YN').setValue(newValue.SLIP_YN);
				}
			}
		},{
			xtype		: 'component',
			html		: '',
			tdAttrs		: {width : '30%'}			//20210421 수정: 50% -> 30%
		},{
			xtype	: 'button',
			text	: '파일 UpLoad',
			width	: 120,
			tdAttrs : {align:'right', style:'padding-right:10px;padding-bottom:5px;'},
			handler : function() {
				openExcelWindow();
			}
		}]
	});
	
	/**
	 * 일반전표 Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('agd500ukrMasterStore1', {
		model: 'agd500ukrMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster    : true,        // 상위 버튼 연결
			editable    : true,         // 수정 모드 사용
			deletable   : true,         // 삭제 가능 여부
			allDeletable: true,         // 삭제 가능 여부
			useNavi     : false         // prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords : function(params) {
			var param;
			var form = Ext.getCmp('searchForm');
			
			if(Ext.isEmpty(params)) {
				param = form.getValues();
			}
			else {
				param = params;
			}
			
			console.log( param );
			this.load({
				params : param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				this.syncAllDirect(config);
			} else {
				Unilite.messageBox(Msg.sMB083);
			}
		}
	});
	
	/**
	 * Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agd500ukrMasterGrid', {
		store : directMasterStore,
		region: 'center',
		flex  : 1,
		uniOpt:{
			expandLastColumn    : true,
			useMultipleSorting  : false,
			useNavigationModel	: false
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns:  [{
				text :'개별기표', 
				xtype:'actioncolumn',
	            width:80,
	            dataIndex :'eachAutoSlip',
	            align:'center',
	            hideable:false,
	            items: [{
	                icon: CPATH+'/resources/css/icons/upload_add.png',
	                iconCls:'actionColumnPaddingrigt5',
	                itemId:'autoSlip',
	                
	                tooltip: '개별기표',
	                isDisabled: function(view, rowIndex, colIndex, item, record) {
	                	if(Ext.isEmpty(record.get('EX_DATE'))) {
		            		return false
		            	}
	                	return true;
	                },
	                handler: function(grid, rowIndex, colIndex, item, e, record, row) {
	                	if(UniAppManager.app._needSave()) {
	                		Unilite.messageBox("저장할 데이타가 있습니다. 저장 후  기표해 주세요.");
	                		return false;
	                	}
	                	
	                	var chkParams = {
                			'IN_DIV_CODE'  : record.get('IN_DIV_CODE'),
                			'CREDIT_NUM'   : record.get('CREDIT_NUM'),
                			'EX_DATE_FR'   : UniDate.getDbDateStr(record.get('PUB_DATE')),
                			'EX_DATE_TO'   : UniDate.getDbDateStr(record.get('PUB_DATE')),
                			'IN_DEPT_CODE' : record.get('IN_DEPT_CODE'),
                			'SEQ'          : record.get('SEQ'),
                			'CHARGE_CODE'  : panelSearch.getValue('CHARGE_CODE')
	                	}
	                	Ext.getBody().mask();
	                	agd500ukrService.selectList(chkParams, function(provider, responseText){
	                		Ext.getBody().unmask();
	                		if(provider && provider.length > 0) {
	                			if(Ext.isEmpty(provider[0]['EX_DATE'])) {
	                				
	                				if(Ext.isEmpty(record.get("P_ACCNT"))) {
	                					Unilite.messageBox("차변계정코드는 필수 입력입니다.");
	                					return;
	                				}
	                				if(record.get("TAX_AMT_I") != 0) {
	                					if(Ext.isEmpty(record.get("CUSTOM_CODE"))) {
		                					Unilite.messageBox("거래처는 필수 입력입니다.");
		                					return;
		                				}
	                				}
	                				var params = {
											'PGM_ID' 	: 'agd500ukr',
											'sGubun' 	: '68',
											'DIV_CODE' : record.get('DIV_CODE'),
											'CREDIT_NUM' : record.get('CREDIT_NUM'),
											'SEQ' : record.get('SEQ'),
											'PROC_DATE' : UniDate.getDbDateStr(record.get('PUB_DATE'))
										}
										var rec1 = {data : {prgID : 'agj260ukr', 'text':''}};
										parent.openTab(rec1, '/accnt/agj260ukr.do', params);
			                		
	                			} else {
	                				Unilite.messageBox('이미 전표가 생성되었습니다.');
	                				record.set('EX_DATE', provider[0]['EX_DATE']);
	                				record.set('EX_NUM', provider[0]['EX_NUM']);
	                				record.commit();
	                			}
	                		}
	                	})
	                }
	           },{
	                icon: CPATH+'/resources/css/icons/upload_cancel.png',
	                itemId:'cancelSlip',
	                tooltip: '기표취소',
	                text:'기표취소',
	                isDisabled: function(view, rowIndex, colIndex, item, record) {
	                	if(Ext.isEmpty(record.get('EX_DATE'))) {
		            		return true
		            	}
	                	return false;
	                },
 	                handler: function(grid, rowIndex, colIndex, item, e, record, row) {
 	                	if(UniAppManager.app._needSave()) {
	                		Unilite.messageBox("저장할 데이타가 있습니다. 저장 후 취소해 주세요.");
	                		return false;
	                	}
	                	var chkParams =  {
                			'IN_DIV_CODE'  : record.get('IN_DIV_CODE'),
                			'CREDIT_NUM'   : record.get('CREDIT_NUM'),
                			'EX_DATE_FR'   : UniDate.getDbDateStr(record.get('PUB_DATE')),
                			'EX_DATE_TO'   : UniDate.getDbDateStr(record.get('PUB_DATE')),
                			'IN_DEPT_CODE' : record.get('IN_DEPT_CODE'),
                			'SEQ'          : record.get('SEQ'),
                			'CHARGE_CODE'  : panelSearch.getValue('CHARGE_CODE')
		                }
	                	agd500ukrService.selectList(chkParams, function(provider, responseText){
	                		if(provider && provider.length > 0) {
	                			if(!Ext.isEmpty(provider[0]['EX_DATE'])) {
				                	var params = {
										'DIV_CODE' : record.get('DIV_CODE'),
										'CREDIT_NUM' : record.get('CREDIT_NUM'),
										'SEQ' : record.get('SEQ'),
										'PROC_DATE' : UniDate.getDbDateStr(record.get('PUB_DATE'))
									}
				                	 agj260ukrService.cancelAutoSlip68 (
										params,function(provider,response) {
											if(provider && Ext.isEmpty(provider.ERROR_DESC) ) {
												UniAppManager.setToolbarButtons(['deleteAll'],true);
												Unilite.messageBox('자동기표를 취소하였습니다.');	
												record.set("EX_DATE",'');
												record.set("EX_NUM",'');
												record.commit();
											}else{
												return false;
											}
										}
									);
	                			} else if(!Ext.isEmpty(provider[0]['AGREE_YN']) && provider[0]['AGREE_YN'] == "Y") {
	                				Unilite.messageBox('승인된 전표는 취소 할 수 없습니다.');
	                			} else {
	                				Unilite.messageBox('생성된 전표가 없습니다.');
	                				record.set('EX_DATE', '');
	                				record.set('EX_NUM', '');
	                				record.commit();
	                			}
	                		}
	                	});
	                }
	           }]
			},
			{dataIndex: 'EX_DATE'			, width: 70},
			{dataIndex: 'EX_NUM'			, width: 70, align:'center'},
			{ dataIndex: 'PUB_DATE'			, width: 80, align:'center',	editable: false},
			{ dataIndex: 'CREDIT_NUM'		, width: 130,	editable: false },
			{ dataIndex: 'SEQ'				, width: 50,	editable: false },
			{ dataIndex: 'CUSTOM_CODE'		, width: 80,	editable: false,
				editor : Unilite.popup('CUST_G',{
					textFieldName:'CUSTOM_CODE',
					DBtextFieldName:'CUSTOM_CODE',
					extParam:{"CUSTOM_TYPE":['1','2','3']},
					autoPopup:true,
					listeners: {	
						'onSelected': function(records, type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							
							grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
							grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							
							grdRecord.set('CUSTOM_NAME', '');
							grdRecord.set('CUSTOM_CODE', '');
						}
					}
				})
			},
			{ dataIndex: 'CUSTOM_NAME'		, width: 120,	editable: false,
				editor : Unilite.popup('CUST_G',{
					textFieldName:'CUSTOM_NAME',
					extParam:{"CUSTOM_TYPE":['1','2','3']},
					autoPopup:true,
					listeners: {	
						'onSelected': function(records, type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							
							grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
							grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							
							grdRecord.set('CUSTOM_NAME', '');
							grdRecord.set('CUSTOM_CODE', '');
						}
					}
				})
			},
			{ dataIndex: 'PROOF_KIND'		, width: 110,
				editor:{
					xtype : 'uniCombobox',
					store : Ext.data.StoreManager.lookup('CBS_AU_A022'),
					listeners : {
						beforequery : function(queryPlan, value) {
							var saleDivi = masterGrid.uniOpt.currentRecord.get('SALE_DIVI');
							
							this.store.clearFilter();
							this.store.filterBy(function(record) {
								return record.get('refCode3') == saleDivi;
							}, this);
						}
					}
				}
			},
			{ dataIndex: 'SUPPLY_AMT_I'		, width: 100,	editable: false },
			{ dataIndex: 'TAX_AMT_I'		, width: 80,	editable: false },
			{ dataIndex: 'TOT_AMT_I'		, width: 100,	editable: false },
			{ dataIndex: 'P_ACCNT'			, width: 100,
				editor:Unilite.popup('ACCNT_AC_G', {
					autoPopup: true,
					textFieldName:'ACCNT',
					DBtextFieldName: 'ACCNT_CODE',
					listeners:{
						scope:this,
						onSelected:function(records, type ) {
							var grid = Ext.getCmp('agd500ukrMasterGrid');
							
							grid.uniOpt.currentRecord.set('P_ACCNT', records[0].ACCNT_CODE);
							grid.uniOpt.currentRecord.set('P_ACCNT_NAME', records[0].ACCNT_NAME);
							
							//UniAppManager.app.loadDataAccntInfo(grid.uniOpt.currentRecord, form, records[0]);
						},
						onClear:function(type)  {
							var grid = Ext.getCmp('agd500ukrMasterGrid');
							
							grid.uniOpt.currentRecord.set('P_ACCNT', '');
							grid.uniOpt.currentRecord.set('P_ACCNT_NAME', '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'RDO': '3',
									'TXT_SEARCH': '',
									'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
									'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},
			{ dataIndex: 'P_ACCNT_NAME'		, width: 120,	editable: false },
			{ dataIndex: 'REMARK'			, width: 120,
				editor : Unilite.popup('REMARK_G',{
					textFieldName:'REMARK',
					validateBlank:false,
					autoPopup: false,
					listeners: {	
						'onSelected': function(records, type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('REMARK', records[0]['REMARK_NAME']);
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('REMARK', '');
						}
					}
				})
			},
			{ dataIndex: 'DEPT_NAME'		, width: 100,	editable: false,
				editor : Unilite.popup('DEPT_G',{
					showValue: false,
					autoPopup: true,
					listeners: {	
						'onSelected': function(records, type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', records[0]['TREE_CODE']);
							grdRecord.set('DEPT_NAME', records[0]['TREE_NAME']);
							grdRecord.set('DIV_CODE', records[0]['DIV_CODE']);
							grdRecord.set('BILL_DIV_CODE', records[0]['BILL_DIV_CODE']);
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE', '');
							grdRecord.set('DEPT_NAME', '');
							grdRecord.set('DIV_CODE', '');
							grdRecord.set('BILL_DIV_CODE', '');
						}
					}
				})
			}
		]
	});
	
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		var configId = 'agd500ukr';
		
		if(!panelSearch.getInvalidMessage()) {
			return false;
		}
		
		if(!directMasterStore.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
			directMasterStore.loadData({});
		} else {
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
				directMasterStore.loadData({});
			}
		}
		
		if(!Ext.isEmpty(excelWindow)){
			excelWindow = null;
		}
		
		if(!excelWindow) { 
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: configId,
				width		: 600,
				height		:  193,
				modal		: false,
				resizable	: false,
				extParam: {
					'COMP_CODE'		: UserInfo.compCode,
					'DIV_CODE'		: UserInfo.divCode,
					'BILL_DIV_CODE'	: UserInfo.divCode,
					'IN_DEPT_CODE'	: UserInfo.deptCode,
					'IN_DEPT_NAME'	: UserInfo.deptName,
					'PGM_ID'		: configId,
					'USER_ID'		: UserInfo.userID
				},
				listeners: {
					close: function() {
						this.hide();
					}
				},
				uploadFile: function() {
					var me = this,
						frm = me.down('#uploadForm').getForm(),
						param = me.extParam;
					
					agd500ukrService.fnDeleteAll(param, function(provider, response) {
						if (!Ext.isEmpty(provider)) {
							frm.submit({
								params  : me.extParam,
								waitMsg : 'Uploading...',
								success : function(form, action) {
									var param = {
										'_EXCEL_JOBID' : action.result.jobID
									};
									
									agd500ukrService.fnApplyAll(param, function(provider, response) {
										if (!Ext.isEmpty(provider)) {
											directMasterStore.loadData(provider);
											directMasterStore.commitChanges();
											me.hide();
											//UniAppManager.app.onQueryButtonDown();
										} 
									});
								},
								failure: function(form, action) {
									Ext.Msg.alert('Failed', action.result.msg);
								}
							});
						}
						else {
							alert(provider);
						}
					});
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = [{
						xtype: 'button',
						text : '업로드',
						tooltip : '업로드', 
						handler: function() { 
							me.jobID = null;
							me.uploadFile();
						}
					},
					'->',
					{
						xtype: 'button',
						text : '닫기',
						tooltip : '닫기', 
						handler: function() { 
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};

	Unilite.Main({
		borderItems:[ 
			panelSearch,
			{
				region: 'center',
				layout: 'border',
				border: false,
				items:[
					masterGrid, panelResult
				]
			}
		],
		id  : 'agd500ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['reset', 'query'], true);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('EX_DATE_FR');

			panelSearch.setValue('CHARGE_CODE', UserInfo.userID);
			panelSearch.setValue('CHARGE_NAME', UserInfo.userName);
			panelResult.setValue('CHARGE_CODE', UserInfo.userID);
			panelResult.setValue('CHARGE_NAME', UserInfo.userName);

			panelSearch.setValue('SLIP_YN'	, 'A');
			panelResult.setValue('SLIP_YN'	, 'A');
		},
		onQueryButtonDown : function() {
			if(!panelSearch.getInvalidMessage())	//필수체크
				return;

			if(UniDate.extFormatMonth(panelSearch.getValue('EX_DATE_FR')) != UniDate.extFormatMonth(panelSearch.getValue('EX_DATE_TO')))  {
				Unilite.messageBox('동일한 월만 조회가 가능합니다.');
				var activeSForm ;
				if(!UserInfo.appOption.collapseLeftSearch) {
					activeSForm = panelSearch;
				} else {
					activeSForm = panelResult;
				}
				panelSearch.setValue('EX_DATE_TO','');
				panelResult.setValue('EX_DATE_TO','');
				activeSForm.getField('EX_DATE_TO').focus();
				
				return;
			}
			
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown:function() {
		},
		onSaveDataButtonDown:function() {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown:function() {
			var record = masterGrid.getSelectedRecord();
			
			if(Ext.isEmpty(record)) {
				return;
			}
			
			var chkParams = {
				'IN_DIV_CODE'	: record.get('IN_DIV_CODE'),
				'CREDIT_NUM'	: record.get('CREDIT_NUM'),
				'EX_DATE_FR'	: UniDate.getDbDateStr(record.get('PUB_DATE')),
				'EX_DATE_TO'	: UniDate.getDbDateStr(record.get('PUB_DATE')),
				'IN_DEPT_CODE'	: record.get('IN_DEPT_CODE'),
				'SEQ'			: record.get('SEQ')
			}
			Ext.getBody().mask();
			agd500ukrService.selectList(chkParams, function(provider, responseText){
				Ext.getBody().unmask();
				if(provider && provider.length > 0) {
					if(Ext.isEmpty(provider[0]['EX_DATE'])) {
						masterGrid.deleteSelectedRow();
					}
				}
			});
		},
		onDeleteAllButtonDown:function() {
			var chkParams = panelSearch.getValues();
			Ext.getBody().mask();
			agd500ukrService.selectList(chkParams, function(provider, responseText){
				Ext.getBody().unmask();
				var bProc = false;

				if(provider && provider.length > 0) {
					Ext.each(provider, function(record, index){
						if(!Ext.isEmpty(record['EX_DATE'])) {
							bProc = true;
							return;
						}
					});
					if(bProc) {
						Unilite.messageBox("이미 전표 처리된 데이터가 존재합니다.");
						return false;
					}
					else {
						masterGrid.getStore().removeAll();
					}
				}
			});
		},
		onResetButtonDown:function() {
			masterGrid.getStore().loadData({});
			this.setSearchReadOnly(false);
			UniAppManager.setToolbarButtons(['save', 'prev', 'next'], false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			directMasterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save', false);
		},
		confirmSaveData: function() {
			if(directMasterStore.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown();
				} else {
					this.rejectSave();
				}
			}
		},
		setSearchReadOnly:function(b) {
			return;
			panelSearch.getField('EX_DATE_FR').setReadOnly(b);
			panelSearch.getField('EX_DATE_TO').setReadOnly(b);

			panelResult.getField('EX_DATE_FR').setReadOnly(b);
			panelResult.getField('EX_DATE_TO').setReadOnly(b);
		}
	});
	
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt ) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue) {
				return true;
			}
			var rv = true;
			switch(fieldName) {
				default:
					break;
			}
			return rv;
		}
	});
}
</script>