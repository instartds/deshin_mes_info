<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx111ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B066" />			<!-- 계산서유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A012" />			<!-- 매임매출거래유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A183" />			<!-- 계산서유형 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {	 
	var excelWindow; 				//업로드 윈도우 생성
	var newYN_ISSUE	= 0;			//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다 (중복수행 방지를 위해 panelResult에서만 처리)
	var newYN_APPLY	= 0;			//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다 (중복수행 방지를 위해 panelResult에서만 처리)
	var gubun	= '공급받는자';			//그리드 명 동적으로 처리하기 위한 변수 처리
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}

	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'atx111ukrService.selectList',
			update	: 'atx111ukrService.updateList',
//			create	: 'atx111ukrService.insertList',
			destroy	: 'atx111ukrService.deleteList',
			syncAll	: 'atx111ukrService.saveAll'
		}
	});	
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'atx111ukrService.runProcedure',
			syncAll	: 'atx111ukrService.callProcedure'
		}
	});	

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('atx111ukrModel', {
		fields: [
			 {name: 'COMP_CODE'				, text: '법인코드'				, type: 'string'	}
			,{name: 'DOC_ID'				, text: 'NO'				, type: 'string'	}
			,{name: 'SALE_DIV_CODE'			, text: '매출사업장'			, type: 'string'	}
			,{name: 'DIV_CODE'				, text: '신고사업장코드'			, type: 'string'	 , comboType: 'BOR120'}
			,{name: 'SERVANT_COMPANY_NUM'	, text: '종사업장번호'			, type: 'string'	}
			,{name: 'BILL_TYPE'				, text: '계산서유형'			, type: 'string'	}
			,{name: 'ISSUE_GUBUN'			, text: '발행구분'				, type: 'string'	}
			,{name: 'BILL_DATE'				, text: '계산서일'				, type: 'uniDate'		, allowBlank: false	}
			,{name: 'SALE_AMT'				, text: '공급가액'				, type: 'uniPrice'		, allowBlank: false	}
			,{name: 'TAX_AMT'				, text: '세액'				, type: 'uniPrice'		/*, allowBlank: false	*/}
			,{name: 'BUSI_TYPE'				, text: '거래유형'				, type: 'string'		, allowBlank: false		, comboType: 'AU'	, comboCode: 'A012'	}
			,{name: 'CUSTOM_CODE'			, text: '거래처코드'			, type: 'string'	}
			,{name: 'CUSTOM_NAME'			, text: '거래처명'				, type: 'string'	}
			,{name: 'COMPANY_NUM'			, text: gubun + '등록번호'		, type: 'string'		, allowBlank: false	} //변수
			,{name: 'TOP_NUM'				, text: '주민번호'				, type: 'string'	}
			,{name: 'PRSN_NAME'				, text: gubun + '담당자'		, type: 'string'		, allowBlank: false	} //변수
			,{name: 'PRSN_EMAIL'			, text: gubun + '이메일주소'	, type: 'string'		, allowBlank: false	} //변수
			,{name: 'BILL_GUBUN'			, text: '청구여부'				, type: 'string'		, allowBlank: false		, comboType: 'AU'	, comboCode: 'A183' }
			,{name: 'REMARK'				, text: '적요'				, type: 'string'		, allowBlank: false	}
			,{name: 'BROK_CUSTOM_CODE'		, text: '수탁거래처코드'			, type: 'string'	}
			,{name: 'BROK_COMPANY_NUM'		, text: '수탁사업자번호'			, type: 'string'	}
			,{name: 'BROK_TOP_NUM'			, text: '수탁주민번호'			, type: 'string'	}
			,{name: 'BROK_PRSN_NAME'		, text: '수탁담당자명'			, type: 'string'	}
			,{name: 'BROK_PRSN_EMAIL'		, text: '수탁이메일'			, type: 'string'	}
			,{name: 'PUB_NUM'				, text: '세금계산서번호'			, type: 'string'	}
			,{name: 'APPLY_YN'				, text: '반영여부'				, type: 'string'	}
			,{name: 'INSERT_DB_USER'		, text: 'INSERT_DB_USER'	, type: 'string'	}
			,{name: 'INSERT_DB_TIME'		, text: 'INSERT_DB_TIME'	, type: 'uniDate'	}
			,{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'	}
			,{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'uniDate'	}
			,{name: 'INPUT_PATH'			, text: '입력경로'				, type: 'string'	}
			,{name: 'TEMPC_01'				, text: 'TEMPC_01'			, type: 'string'	}
			,{name: 'TEMPC_02'				, text: 'TEMPC_02'			, type: 'string'	}
			,{name: 'TEMPC_03'				, text: 'TEMPC_03'			, type: 'string'	}
			,{name: 'TEMPN_01'				, text: 'TEMPN_01'			, type: 'string'	}
			,{name: 'TEMPN_02'				, text: 'TEMPN_02'			, type: 'string'	}
			,{name: 'TEMPN_03'				, text: 'TEMPN_03'			, type: 'string'	}
		]
	});		// End of Ext.define('atx111ukrModel', {
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('atx111ukrMasterStore1',{
		model	: 'atx111ukrModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi 	: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();		//조회폼 파라미터 수집		
			console.log( param );
			this.load({								//그리드에 Load..
				params : param,
				callback : function(records, operation, success) {
					if(success)	{	//조회후 처리할 내용
					
					}
				}
			});
//			Ext.getCmp('confirmCust').disable();
//			Ext.getCmp('confirmCust1').disable();
			Ext.getCmp('apply').disable();
			Ext.getCmp('apply1').disable();
			Ext.getCmp('unapply').disable();
			Ext.getCmp('unapply1').disable();

		},
		
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
	   		var toUpdate = this.getUpdatedRecords();				
	   		var toDelete = this.getRemovedRecords();
			
//			폼에서 필요한 조건 가져올 경우
			var paramMaster = Ext.getCmp('searchForm').getValues();
	   		var rv = true;
	   		
			if(inValidRecs.length == 0 )	{
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
					} 
				};					
				this.syncAllDirect(config);
				
			}else {
//				alert(Msg.sMB083);
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
 		},
 		
		listeners: {
		  	load: function(store, records, successful, eOpts) {
			}		  		
	  	}/*,
	  	
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				if (records.length > 0) {
					UniAppManager.setToolbarButtons('save', false);
					var msg = records[0].data.COUNT + Msg.sMB001; 					//'건이 조회되었습니다.';
					UniAppManager.updateStatus(msg, true);	
				}
			}
		}*/
	});

	var buttonStore = Unilite.createStore('Atx111ukrButtonStore',{	  
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,		   // 삭제 가능 여부 
			useNavi		: false		 	// prev | newxt 버튼 사용
		},
		proxy: directButtonProxy,
		saveStore: function(buttonFlag) {			 
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();

//			계산서 유형에 따른 세액 체크로직 추가해야 함
//			Ext.each(toCreate, function(record, index) {					
//				if(record.get('CUST_CODE') == 'Y' && Ext.isEmpty(record.get('CUSTOM_CODE'))){
//					custCheck = '거래처: ' + str
//					isErr = true;
//					errRow = index;
//				}
//				if(isErr) return false;
//			});
			var paramMaster		 = panelSearch.getValues();
			paramMaster.OPR_FLAG	= buttonFlag;
			paramMaster.LANG_TYPE   = UserInfo.userLang

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//return 값 저장
						var master = batch.operations[0].getResultSet();
						
						UniAppManager.app.onQueryButtonDown();
						buttonStore.clearData();
					 },

					 failure: function(batch, option) {
						buttonStore.clearData();
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('atx111ukrGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items	: [{	
			title	: '기본정보', 	
	   		itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items	: [{ 
				fieldLabel	: '매출사업장',
				name		: 'SALE_DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
//				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALE_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '계산서일',
				xtype		: 'uniDateRangefield',
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',  
				allowBlank	: false,				
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DATE_FR', newValue);						
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DATE_TO', newValue);							
					}
				}
		 	},{
				fieldLabel	: '계산서유형', 
				name		: 'BILL_TYPE', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU', 
				comboCode	: 'B066',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {	
						panelResult.setValue('BILL_TYPE', newValue);
					}
				}
			},
			Unilite.popup('CUST',{
				fieldLabel	: '거래처',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
		   		extParam	: {'CUSTOM_TYPE': ['1','3']},  
				listeners	: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
						panelSearch.setValue('CUSTOM_CODE', '');
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				}
			}),{
				xtype		: 'radiogroup',							
				fieldLabel	: '발행구분',									
				id			: 'rdoSelect0',
				items		: [{
					boxLabel: '정발행', 
					width	: 60, 
					name	: 'ISSUE_GUBUN',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '역발행', 
					width	: 60,
					inputValue: '2',
					name	: 'ISSUE_GUBUN'
				},{
					boxLabel: '위수탁발행', 
					width	: 100,
					inputValue: '3',
					name	: 'ISSUE_GUBUN'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						panelResult.getField('ISSUE_GUBUN').setValue(newValue.ISSUE_GUBUN);
						
						if(Ext.getCmp('rdoSelect0').getChecked()[0].inputValue == '1'){
							gubun = '공급받는자';
							masterGrid.getColumn('COMPANY_NUM').setText(gubun + '등록번호');		
							masterGrid.getColumn('PRSN_NAME').setText(gubun + '담당자');		
							masterGrid.getColumn('PRSN_EMAIL').setText(gubun + '이메일주소');	
							
						} else if(Ext.getCmp('rdoSelect0').getChecked()[0].inputValue == '2'){
							gubun = '공급자';
							masterGrid.getColumn('COMPANY_NUM').setText(gubun + '등록번호');		
							masterGrid.getColumn('PRSN_NAME').setText(gubun + '담당자');		
							masterGrid.getColumn('PRSN_EMAIL').setText(gubun + '이메일주소');	
							
						} else if(Ext.getCmp('rdoSelect0').getChecked()[0].inputValue == '3'){
							gubun = '공급받는자';
							masterGrid.getColumn('COMPANY_NUM').setText(gubun + '등록번호');		
							masterGrid.getColumn('PRSN_NAME').setText(gubun + '담당자');		
							masterGrid.getColumn('PRSN_EMAIL').setText(gubun + '이메일주소');	
						}
						
//						if (newYN_ISSUE == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다 (중복수행 방지를 위해 panelResult에서만 처리)
//							newYN_ISSUE = '0'
//							return false;
//						}else {
//							UniAppManager.app.onQueryButtonDown();	
//						}	
					}
				}
			},{
				xtype	: 'radiogroup',							
				fieldLabel: '반영여부',											
				id		: 'rdoSelect0_0',
				items	: [{
					boxLabel: '미반영', 
					width	: 100, 
					name	: 'APPLY_YN',
					inputValue: 'N',
					checked	: true  
				},{
					boxLabel: '반영', 
					width	: 100,
					name	: 'APPLY_YN',
					inputValue: 'Y',
					listeners: {
						specialkey: function(field, event){
							if(event.getKey() == event.ENTER){
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						panelResult.getField('APPLY_YN').setValue(newValue.APPLY_YN);
					}
				}
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				tdAttrs: {width: 380, align:'center'},	
				items:[/*{			   
					labelText : '',
					xtype	: 'button',
					id		: 'confirmCust',
					itemId	: 'confirmCust',
					text	: '거래처 확인',
					margin	: '0 0 2 5',
					width	: 100,
					tdAttrs	: {align: 'left'},
					handler : function() {
						var buttonFlag = 'C';
						fnMakeLogTable(buttonFlag);
					}
				},*/{			   
					labelText : '',
					xtype	: 'button',
					id		: 'apply',
					itemId	: 'apply',
					text	: '세금계산서반영',
					margin	: '0 0 2 5',
					width	: 100,
					tdAttrs	: {align: 'left'},
					handler : function() {
						var buttonFlag = 'A';
						fnMakeLogTable(buttonFlag);
					}
				},{			   
					labelText : '',
					xtype	: 'button',
					id		: 'unapply',
					itemId	: 'unapply',
					text	: '반영취소',
					margin	: '0 0 2 5',
					width	: 100,
					tdAttrs	: {align: 'left'},
					handler : function() {
						var buttonFlag = 'D';
						fnMakeLogTable(buttonFlag);
					}
				}]
			}]	
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3//,
//		tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	:'1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel	: '매출사업장',
			name		: 'SALE_DIV_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
//			allowBlank	: false,
			tdAttrs		: {width: 380},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '계산서일',
			xtype		: 'uniDateRangefield',
			startFieldName: 'DATE_FR',
			endFieldName: 'DATE_TO', 
			allowBlank	: false, 
			colspan		: 2,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DATE_FR', newValue);						
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('DATE_TO', newValue);							
				}
			}
	 	},{
			fieldLabel	: '계산서유형', 
			name		: 'BILL_TYPE', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'B066',
			allowBlank	: false,
			tdAttrs		: {width: 380},
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BILL_TYPE', newValue);
				}
			}
		},
		Unilite.popup('CUST',{
			fieldLabel	: '거래처',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			tdAttrs		: {width: 380},
			extParam	: {'CUSTOM_TYPE': ['1','3']},  
			colspan		: 2, 
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('CUSTOM_CODE', '');
					panelResult.setValue('CUSTOM_NAME', '');
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					
				}
			}
		}),{
			xtype		: 'radiogroup',							
			fieldLabel	: '발행구분',										
			id			: 'rdoSelect1',
			tdAttrs		: {width: 380},
			items		: [{
				boxLabel: '정발행', 
				width	: 60, 
				name	: 'ISSUE_GUBUN',
				inputValue: '1',
				checked	: true  
			},{
				boxLabel: '역발행', 
				width	: 60,
				name	: 'ISSUE_GUBUN',
				inputValue: '2'
			},{
				boxLabel: '위수탁발행', 
				width	: 100,
				name	: 'ISSUE_GUBUN',
				inputValue: '3'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {			
					panelSearch.getField('ISSUE_GUBUN').setValue(newValue.ISSUE_GUBUN);
				
					if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == '1'){
						gubun = '공급받는자';
						masterGrid.getColumn('COMPANY_NUM').setText(gubun + '등록번호');		
						masterGrid.getColumn('PRSN_NAME').setText(gubun + '담당자');		
						masterGrid.getColumn('PRSN_EMAIL').setText(gubun + '이메일주소');	
						
					} else if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == '2'){
						gubun = '공급자';
						masterGrid.getColumn('COMPANY_NUM').setText(gubun + '등록번호');		
						masterGrid.getColumn('PRSN_NAME').setText(gubun + '담당자');		
						masterGrid.getColumn('PRSN_EMAIL').setText(gubun + '이메일주소');	
						
					} else if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == '3'){
						gubun = '공급받는자';
						masterGrid.getColumn('COMPANY_NUM').setText(gubun + '등록번호');		
						masterGrid.getColumn('PRSN_NAME').setText(gubun + '담당자');		
						masterGrid.getColumn('PRSN_EMAIL').setText(gubun + '이메일주소');	
					}
					
					if (newYN_ISSUE == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
						newYN_ISSUE = '0'
						return false;
					}else {
						UniAppManager.app.onQueryButtonDown();	
					}	
				}
			}
		},{
			xtype		: 'radiogroup',							
			fieldLabel	: '반영여부',											
			id			: 'rdoSelect0_1',
			tdAttrs		: {width: 380},
			items		: [{
				boxLabel: '미반영', 
				width	: 100, 
				name	: 'APPLY_YN',
				inputValue: 'N',
				checked	: true  
			},{
				boxLabel: '반영', 
				width	: 100,
				name	: 'APPLY_YN',
				inputValue: 'Y',
				listeners: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}],
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('APPLY_YN').setValue(newValue.APPLY_YN);

					if (newYN_APPLY == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
						newYN_APPLY = '0'
						return false;
					}else {
						UniAppManager.app.onQueryButtonDown();	
					}	
				}
			}
		},{
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {width: 380, align:'right', width: '100%'},	
			items:[/*{			   
				labelText : '',
				xtype	: 'button',
				id		: 'confirmCust1',
				itemId	: 'confirmCust1',
				text	: '거래처 확인',
				margin	: '0 0 2 5',
				width	: 100,
				tdAttrs	: {align: 'left'},
				handler : function() {
					var buttonFlag = 'C';
					fnMakeLogTable(buttonFlag);
				}
			},*/{			   
				labelText : '',
				xtype	: 'button',
				id		: 'apply1',
				itemId	: 'apply1',
				text	: '세금계산서반영',
				margin	: '0 0 2 5',
				width	: 100,
				tdAttrs	: {align: 'left'},
				handler : function() {
					var buttonFlag = 'A';
					fnMakeLogTable(buttonFlag);
				}
			},{			   
				labelText : '',
				xtype	: 'button',
				id		: 'unapply1',
				itemId	: 'unapply1',
				text	: '반영취소',
				margin	: '0 0 2 5',
				width	: 100,
				tdAttrs	: {align: 'left'},
				handler : function() {
					var buttonFlag = 'D';
					fnMakeLogTable(buttonFlag);
				}
			}]
		}]
	});
	
	/* Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('atx111ukrGrid1', {
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		tbar: [{
			text:'엑셀파일 UpLoad',
			handler: function() {
				openExcelWindow();
			}
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount() > 0) {
//						Ext.getCmp('confirmCust').enable();
//						Ext.getCmp('confirmCust1').enable();
						if(Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue == 'N') {
							Ext.getCmp('apply').enable();
							Ext.getCmp('apply1').enable();
						} else {
							Ext.getCmp('unapply').enable();
							Ext.getCmp('unapply1').enable();
						}
					}
				},
				
				deselect:  function(grid, selectRecord, index, eOpts ){
					if (this.selected.getCount() <= 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
//						Ext.getCmp('confirmCust').disable();
//						Ext.getCmp('confirmCust1').disable();
						Ext.getCmp('apply').disable();
						Ext.getCmp('apply1').disable();
						Ext.getCmp('unapply').disable();
						Ext.getCmp('unapply1').disable();
					}
				}
			}
		}),
		store	: masterStore,
		features: [{
			id		: 'masterGridSubTotal',
			ftype	: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id		: 'masterGridTotal', 	
			ftype	: 'uniSummary', 	  
			showSummaryRow: false
		}],
		columns: [{ 
				xtype	: 'rownumberer', 
				align	: 'center  !important',		
				width	: 35,	   
				sortable: false,		
				resizable: true
			}
			,{dataIndex: 'COMP_CODE'			, width: 100		, hidden: true}
			,{dataIndex: 'DOC_ID'				, width: 80			, hidden: true}
			,{dataIndex: 'BILL_DATE'			, width: 100}
			,{dataIndex: 'BUSI_TYPE'			, width: 120}
			,{dataIndex: 'DIV_CODE'				, width: 100}
			,{dataIndex: 'SERVANT_COMPANY_NUM'	, width: 100}
			,{dataIndex: 'CUSTOM_CODE'			, width: 100,
			  'editor': Unilite.popup('CUST_G',{
					textFieldName : 'CUSTOM_CODE',
					DBtextFieldName : 'CUSTOM_CODE',
			  		autoPopup: true,
					listeners: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM']);
							},
						scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('COMPANY_NUM','');
						}
					}
				})
			}
			,{dataIndex: 'CUSTOM_NAME'			, width: 140,
			  'editor': Unilite.popup('CUST_G',{
					textFieldName : 'CUSTOM_CODE',
					DBtextFieldName : 'CUSTOM_CODE',
			  		autoPopup: true,
					listeners: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM']);
							},
						scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('COMPANY_NUM','');
						}
					}
				})
			}
			,{dataIndex: 'COMPANY_NUM'			, width: 140,
			  'editor': Unilite.popup('CUST_G',{
					textFieldName : 'CUSTOM_CODE',
					DBtextFieldName : 'CUSTOM_CODE',
			  		autoPopup: true,
					listeners: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM']);
							},
						scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
							grdRecord.set('COMPANY_NUM','');
						}
					}
				})/*,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					r = (val.substring(0,3) + '-' + val.substring(3,5) + '-' + val.substring(5,10));
					return r
				}*/
			}
			,{dataIndex: 'PRSN_NAME'			, width: 120}
			,{dataIndex: 'PRSN_EMAIL'			, width: 180}
			,{dataIndex: 'BILL_GUBUN'			, width: 100			, align: 'center'}
			,{dataIndex: 'SALE_AMT'				, width: 120}
			,{dataIndex: 'TAX_AMT'				, width: 120}
			,{dataIndex: 'REMARK'				, width: 220}
			,{dataIndex: 'BROK_COMPANY_NUM'		, width: 140,
			  'editor': Unilite.popup('CUST_G',{
					textFieldName : 'CUSTOM_CODE',
					DBtextFieldName : 'CUSTOM_CODE',
			  		autoPopup: true,
					listeners: { 
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('BROK_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('BROK_COMPANY_NUM',records[0]['COMPANY_NUM']);
								grdRecord.set('BROK_PRSN_NAME',records[0]['PRSN_NAME']);
								grdRecord.set('BROK_PRSN_EMAIL',records[0]['PRSN_EMAIL']);
							},
						scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BROK_CUSTOM_CODE','');
							grdRecord.set('BROK_COMPANY_NUM','');
							grdRecord.set('BROK_PRSN_NAME','');
							grdRecord.set('BROK_PRSN_EMAIL','');
						}
					}
				})/*,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					r = (val.substring(0,3) + '-' + val.substring(3,5) + '-' + val.substring(5,10));
					return r
				}*/
			}
			,{dataIndex: 'BROK_PRSN_NAME'		, width: 120}
			,{dataIndex: 'BROK_PRSN_EMAIL'		, width: 180}
			,{dataIndex: 'PUB_NUM'				, width: 120}
			,{dataIndex: 'APPLY_YN'				, width: 100			, align: 'center'}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(Ext.getCmp('rdoSelect0_1').getChecked()[0].inputValue == 'Y') {
					return false;
				} else  {
					if(UniUtils.indexOf(e.field, ['PUB_NUM', 'APPLY_YN'])){
						return false;	
					} else {
						if(Ext.getCmp('rdoSelect0').getChecked()[0].inputValue != '3') {
							if(UniUtils.indexOf(e.field, ['BROK_COMPANY_NUM', 'BROK_PRSN_NAME', 'BROK_PRSN_EMAIL'])){
								return false;	
							} else {
								return true;
							}
						}
						return true;
					}
				}
			}
		}
	});	
	
	 Unilite.Main( {
		id			: 'atx111ukrApp',
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
			panelSearch.setValue('SALE_DIV_CODE',UserInfo.divCode);
			//사용자가 직접 선택하도록 변경
//			var billTypeSelect = Ext.data.StoreManager.lookup('CBS_AU_B066').getAt(0).get('value');
//			panelSearch.setValue('BILL_TYPE', billTypeSelect);
//			panelResult.setValue('BILL_TYPE', billTypeSelect);
			
			panelSearch.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO',UniDate.get('endOfMonth'));
			panelSearch.setValue('ISSUE_GUBUN','1');
			panelSearch.setValue('APPLY_YN','N');

			panelResult.setValue('SALE_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_TO',UniDate.get('endOfMonth'));
			panelResult.setValue('ISSUE_GUBUN','1');
			panelResult.setValue('APPLY_YN','N');
			//버튼 비활성화
//			Ext.getCmp('confirmCust').disable();
//			Ext.getCmp('confirmCust1').disable();
			Ext.getCmp('apply').disable();
			Ext.getCmp('apply1').disable();
			Ext.getCmp('unapply').disable();
			Ext.getCmp('unapply1').disable();

			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
			
			//화면 초기화 시 첫번째 필드에 포커스 가도록 설정
			var activeSForm ;	
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('SALE_DIV_CODE');
			newYN_ISSUE = '0';
			newYN_APPLY = '0';
		},
		
		onResetButtonDown: function() {
			newYN_ISSUE = '1';
			newYN_APPLY = '1';
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			UniAppManager.app.fnInitBinding();
		},

		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
				return false;
			}
			masterStore.loadStoreRecords();
		},

		onDeleteDataButtonDown : function()	{
			if (Ext.getCmp('rdoSelect0_1').getChecked()[0].inputValue == 'Y') {
				alert("세금계산서(계산서)에 반영된 데이터는 삭제할 수 없습니다. \n 먼저 반영취소한 후에 삭제하시기 바랍니다.");
				return false;
			}
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		
		onSaveDataButtonDown: function () {
			masterStore.saveStore();
		}

	});

	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();								//buttonStore 클리어
		Ext.each(records, function(record, index) {
			record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;
			buttonStore.insert(index, record);
			
			if (records.length == index +1) {
				buttonStore.saveStore(buttonFlag);
			}
		});
	}
	
	Unilite.defineModel('excel.atx111ukr.sheet01', {
		fields: [
			 {name: '_EXCEL_ROWNUM'			,text:'순번'							,type : 'int'  } 
			,{name: '_EXCEL_HAS_ERROR'		,text:'에러메세지'						,type : 'string'  } 
			,{name: '_EXCEL_ERROR_MSG'		,text:'에러메세지'						,type : 'string'  } 
			,{name: 'DOC_ID'				,text:'NO'							,type : 'string' } 
			,{name: 'BILL_DATE'				,text:'작성일'						,type : 'uniDate'  } 
			,{name: 'BUSI_TYPE'				,text:'거래유형'						,type : 'string'  } 
			,{name: 'COMPANY_NUM'			,text:'공급받는자/공급자 사업자등록번호'		,type : 'string'  } 
			,{name: 'PRSN_NAME'				,text:'공급받는자/공급자 담당자'			,type : 'string'  } 
			,{name: 'PRSN_EMAIL'			,text:'공급받는자/공급자 이메일주소'			,type : 'string'  } 		
			,{name: 'APPLY_YN'				,text:'청구여부'						,type : 'string'  }
			,{name: 'SALE_AMT'				,text:'공급가액'						,type : 'uniPrice'}
			,{name: 'TAX_AMT'				,text:'세액'							,type : 'uniPrice'}
			,{name: 'REMARK'				,text:'적요'							,type : 'string'  } 
			,{name: 'BROK_COMPANY_NUM'		,text:'수탁사업장등록번호'				,type : 'string'  }
			,{name: 'BROK_PRSN_NAME'		,text:'수탁담당자'						,type : 'string'  } 
			,{name: 'BROK_PRSN_EMAIL'		,text:'수탁이메일주소'					,type : 'string'  }
			,{name: 'PUB_NUM'				,text: '세금계산서번호'					,type : 'string'  }
		]
	});
		
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		if(!masterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			masterStore.loadData({});
		} else {
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
				masterStore.loadData({});
			}
		}
		if(Ext.isEmpty(panelSearch.getValue('BILL_TYPE'))) {
			alert("업로드 할 데이터의 계산서 유형을 선택하시기 바랍니다.");
			return false;
		}
		
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.BILL_TYPE		= panelResult.getValue('BILL_TYPE');
			excelWindow.extParam.ISSUE_GUBUN	= Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//			excelWindow.extParam.APPLY_YN		= Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 'atx111ukr',
				width	: 600,
				height	: 200,
				modal	: false,
				extParam: { 
					'PGM_ID'		: 'atx111ukr',
					'BILL_TYPE'		: panelSearch.getValue('BILL_TYPE'),
					'ISSUE_GUBUN'	: Ext.getCmp('rdoSelect0').getChecked()[0].inputValue
//					'APPLY_YN'		: Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue
//					'SALE_DIV_CODE'	: panelSearch.getValue('SALE_DIV_CODE'),
//					'BILL_DIV_CODE'	: baseInfo.gsBillDivCode
//					'CUSTOM_CODE'	: panelSearch.getValue('CUSTOM_CODE'),
				},

				listeners: {
					close: function() {
						this.hide();
					},
					show:function()	{
					}
				},
				
				uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm');
					frm.submit({
						params: me.extParam,
						waitMsg: 'Uploading...',
						success: function(form, action) {
							var param = {
								 jobID : action.result.jobID
							}
							atx111ukrService.getErrMsg(param, function(provider, response){
								if (Ext.isEmpty(provider)) {
									me.jobID = action.result.jobID;
									me.readGridData(me.jobID);
									me.down('tabpanel').setActiveTab(1);
									Ext.Msg.alert('Success', 'Upload 되었습니다.');
									
									me.hide();
									
									//계산서 유형 readOnly 처리 필요
									
									UniAppManager.app.onQueryButtonDown();
									
								} else {
									alert(provider);
								}
//								//로그테이블 삭제
//								atx111ukrService.deleteLog({}, function(provider, response){});
							});
						},
						failure: function(form, action) {
							Ext.Msg.alert('Failed', action.result.msg);
						}
						
					});
				},

				_setToolBar: function() {
					var me = this;
					me.tbar = [
						{
							xtype: 'button',
							text : '업로드',
							tooltip : '업로드', 
							handler: function() { 
								me.jobID = null;
								me.uploadFile();
							}
						}, '->', {
							xtype: 'button',
							text : '닫기',
							tooltip : '닫기', 
							handler: function() { 
								me.hide();
							}
						}
					]
				 }
			});
		}
		excelWindow.center();
		excelWindow.show();
	};
	
	
/*	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "DIV_CODE":
					atx111ukr.getServantCompanyNum (param, function(provider, response) {						  
						if(provider) {
								
						} else {
							
						}
					});	
					break;
			
			}
			return rv;
		}
	});	*/
};
</script>
