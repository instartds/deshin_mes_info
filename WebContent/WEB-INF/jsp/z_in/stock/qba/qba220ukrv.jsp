<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qba220ukrv" >
  <t:ExtComboStore comboType="BOR120" pgmId="bcm120ukrv"/> <!-- 사업장 -->
  <t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 	-->
  <t:ExtComboStore comboType="AU" comboCode="B131" />	<!-- 예/아니오 	-->
</t:appConfig>
<script type="text/javascript">

function appMain() {

	var selectedR;
	var isItemGridUseChange = false;

	var qbaComboStore = new Ext.data.Store({
		storeId: 'qbaComboStore',
		fields	: ['value',
					'text',
					'refCode1',
					'refCode2',
					'refCode3',
					'refCode4',
					'refCode5',
					'refCode6',
					'refCode7',
					'refCode8',
					'refCode9',
					'refCode10',
					'refCode11',
					'refCode12',
					'refCode13',
					'refCode14',
					'refCode15',
					'option'],
		//autoLoad: true,
		proxy: {
			type: 'direct',
			api: {
				 read: 'UniliteComboServiceImpl.getQbaListCombo'
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
					if(successful)  {
					}
			}
		},
		loadStoreRecords: function(records)	{
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});
	var gsRecord ;
	Unilite.defineModel('qba220ukrvItemModel', {
		fields : [ {name : 'DIV_CODE',		text : '사업장',		type : 'string'}
				  ,{name : 'ITEM_CODE',		text : '품목코드',		type : 'string'}
				  ,{name : 'ITEM_NAME',		text : '품목명',      	type : 'string'}
				  ,{name : 'SPEC',			text : '규격',      	type : 'string'}
				  ,{name : 'ITEM_ACCOUNT',  text : '품목계정',     type : 'string', 			comboType:'AU', 			comboCode:'B020'}
				  ,{name : 'USE_YN',		text : '등록여부',     type : 'string', 			comboType:'AU', 			comboCode:'B131'}
				  ,{name : 'CNT',		   text : '등록행수',      	type : 'int'}
		]

	});

	var directItemStore = Unilite.createStore('qba220ukrvItemStore', {
		model : 'qba220ukrvItemModel',
		autoLoad : false,
		uniOpt : {
			isMaster : false,
			editable : false,
			deletable: false,
			useNavi  : false
		},
		proxy : {
			type : 'direct',
			api  : {
				read : 'qba220ukrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param = Ext.getCmp('qba220ukrvSearchForm').getValues();
			this.load({
				params: param,
				callback : function(records,options,success)    {
                    if(success) {
                    	if(!Ext.isEmpty(records)){
            	        	UniAppManager.setToolbarButtons(['newData'], true);
            	        } else {
            	        	UniAppManager.setToolbarButtons(['newData'], false);
            	        	testGrid.getStore().loadData({});
            	        }
                    }}
			});
		}
	});

	Unilite.defineModel('qba220ukrvTestModel', {
		fields : [ {name : 'DIV_CODE',			text : '사업장',			 	type: 'string',		allowBlank:false}
				  ,{name : 'ITEM_CODE',			text : '품목코드',			 	type: 'string',		allowBlank:false}
				  ,{name : 'TEST_CODE',			text : '항목코드',			 	type: 'string'}
				  ,{name : 'TEST_NAME',			text : '검사항목',			 	type: 'string',	    allowBlank:false, store: Ext.data.StoreManager.lookup('qbaComboStore'), displayField: 'text'}
				  ,{name : 'TEST_NAME_ENG',		text : '검사항목_영문',			type: 'string' ,allowBlank:true}
				  ,{name : 'TEST_NAME_DB',		text : '검사항목',			 	type: 'string',	    allowBlank:false}
				  ,{name : 'TEST_METH',			text : '검사방법',			 	type: 'string'}
				  ,{name : 'TEST_COND',			text : '검사기준<br/>(규격)',  	type: 'string'}
				  ,{name : 'TEST_COND_ENG',		text : '검사기준_영문',			type: 'string'}
				  ,{name : 'TEST_COND_FROM',	text : 'FROM<br/>(하한값)', 	type: 'float' , decimalPrecision: 2 , format:'0,000.00'}
				  ,{name : 'TEST_COND_TO',		text : 'TO<br/>(상한값)',   	type: 'float' , decimalPrecision: 2 , format:'0,000.00'}
				  ,{name : 'TEST_VALUE',		text : '검사값(기준값)',       	type: 'float', decimalPrecision: 2 , format:'0,000.00'}
				  ,{name : 'TEST_RESULT',		text : '검사결과<br/>(논리표현)',	type: 'string'}
				  ,{name : 'TEST_UNIT',			text : '단위',			   	type: 'string', comboType:'AU', comboCode:'B013'}
				  ,{name : 'TEST_PRSN',			text : '시험자',				type: 'string'}
				  ,{name : 'REVISION_DATE',		text : '개정일자',			 	type: 'uniDate',		allowBlank:false}
				  ,{name : 'TEST_VER',			text : '버전',			  	type: 'float', 		maxLength: 10, 		decimalPrecision: 2, 	format: '00,000,000.00'}
	              ,{name : 'USE_YN',			text : '사용여부',				type: 'string'}
	              ,{name : 'SEQ',				text : '정렬',				type: 'int'}
				  ,{name : 'REMARK',			text : '비고',				type: 'string'}
				  ,{name : 'VALUE_POINT',		text: '소수점'	,				type: 'int'}
		]
	});

	var directTestModelProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api : {
			read : 'qba220ukrvService.selectTestList',
			update : 'qba220ukrvService.updateDetail',
			create : 'qba220ukrvService.insertDetail',
			destroy : 'qba220ukrvService.deleteDetail',
			syncAll : 'qba220ukrvService.saveAll'
		}
	});

	var directTestStore = Unilite.createStore('qba220ukrvTestStore', {
		model : 'qba220ukrvTestModel',
		autoLoad : false,
		uniOpt : {
			isMaster : true,
			editable : true,
			deletable : true,
			useNavi : false
		},
		proxy : directTestModelProxy,
		loadStoreRecords : function(record) {
			var searchParam = Ext.getCmp('qba220ukrvSearchForm').getValues();
			var param = {'ITEM_CODE'		: gsRecord.get('ITEM_CODE')};
			var params = Ext.merge(searchParam, param);
			this.load({
				params: params,
				callback : function(records,options,success)    {
					isItemGridUseChange = false;

				}
			});
		},
		listneers : {
			datachanged : function( store, eOpts ) {
				if( directMasterStore1.isDirty() || directMasterStore3.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		},
		saveStore : function() {

			var inValidRecs = this.getInvalidRecords();
		   	var record = itemGrid.getSelectedRecord();
		   	var searchParam = Ext.getCmp('qba220ukrvSearchForm').getValues();
			var param = {	'DIV_CODE' : gsRecord.get('DIV_CODE'),
							'ITEM_CODE'	: gsRecord.get('ITEM_CODE'),
						 	'REVISION_DATE': searchParam.REVISION_DATE};
			if(inValidRecs.length == 0 ) {
				config = {
					/* params: [param], */
					success: function(batch, option) {
						UniAppManager.app.fnChangeUse();

						var chkRecord = qba220ukrvService.getCntQba220t(param, function(provider, response){
							 var useYn = provider[0].USE_YN;

							 Ext.each(selectedR, function(record, i){
									record.set('USE_YN', useYn);
							 });
						});
						directTestStore.loadStoreRecords(record);
				 	}
				}
				this.syncAllDirect(config);
			}else {
				testGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}

	});

	var buttonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'qba220ukrvService.testcodeCopy',
			syncAll	: 'qba220ukrvService.copyAll'
		}
	});

	var buttonStore = Unilite.createStore('orderConfirmButtonStore',{
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy		: buttonProxy,
		saveStore	: function() {
//			var inValidRecs	= this.getInvalidRecords();

			var paramMaster = panelResult.getValues();
//			alert(testGrid.down('#selItemCode').getValue());
			paramMaster.SEL_ITEM_CODE	= testGrid.down('#selItemCode').getValue();

//			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						Ext.getCmp('qba220ukrvApp').unmask();
						buttonStore.clearData();
						itemGrid.getStore().loadStoreRecords();
					},
					failure: function(batch, option) {
						Ext.getCmp('qba220ukrvApp').unmask();
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
//			}
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



	var panelSearch = Unilite.createSearchPanel('qba220ukrvSearchForm', {
        title: '검색조건',
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
	    	title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
           	items : [{
					fieldLabel: '사업장',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					value: '01',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
							qbaComboStore.loadStoreRecords(newValue);

						}
						,applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
		        	fieldLabel: '품목',
		        	valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   		}),{
					fieldLabel: '품목계정',
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
					fieldLabel: '개정일자',
					name: 'REVISION_DATE',
					xtype: 'uniDatefield',
					value: UniDate.get('today'),
					holdable: 'hold',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('REVISION_DATE', newValue);
						}
					}
				},{
				    xtype: 'radiogroup',
				    fieldLabel: '등록여부',
				    items : [{
				    	boxLabel: '전체',
				    	name: 'CHK_RDO',
				    	inputValue: 'ALL',
				    	width:80,
				    	checked: true
				    }, {
				    	boxLabel: '미등록',
				    	name: 'CHK_RDO' ,
				    	inputValue: 'N',
				    	width:80
				    }, {
				    	boxLabel: '등록',
				    	name: 'CHK_RDO' ,
				    	inputValue: 'Y',
				    	width:80
				    }],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('CHK_RDO').setValue(newValue.CHK_RDO);
						}
					}
				},{
				xtype: 'checkbox',
				name: 'ITEM_USE_YN',
				inputValue :'Y',
				checked:true,
				fieldLabel:'미사용품목제외',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_USE_YN', newValue);
					}
				}
			}]
		}]
    });


    var panelResult = Unilite.createSearchForm('resultForm', {
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: '01',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
						qbaComboStore.loadStoreRecords(newValue);
					}
					,applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
	        	fieldLabel: '품목',
	        	valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
	        	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		   	}),{
				fieldLabel: '품목계정',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel: '개정일자',
				name: 'REVISION_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('REVISION_DATE', newValue);
					}
				}
			},{
			    xtype: 'radiogroup',
			    fieldLabel: '등록여부',
			    items : [{
			    	boxLabel: '전체',
			    	name: 'CHK_RDO',
			    	inputValue: 'ALL',
			    	width:80,
			    	checked: true
			    }, {
			    	boxLabel: '미등록',
			    	name: 'CHK_RDO' ,
			    	inputValue: 'N',
			    	width:80
			    }, {
			    	boxLabel: '등록',
			    	name: 'CHK_RDO' ,
			    	inputValue: 'Y',
			    	width:80
			    }],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('CHK_RDO').setValue(newValue.CHK_RDO);
					}
				}
			},{
				xtype: 'checkbox',
				name: 'ITEM_USE_YN',
				inputValue :'Y',
				checked:true,
				fieldLabel:'미사용품목제외',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_USE_YN', newValue);
					}
				}
			}
		]
	});
    var itemGrid = Unilite.createGrid('qba220ukrvItemGrid', {
    	store : directItemStore,
    	layout : 'fit',
    	title : '품목리스트',
    	split:true,
    	flex: 1.6,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false, showHeaderCheckbox : false,
            listeners: {
		                select: function(grid, selectRecord, index, rowIndex, eOpts ){
						   if(selectRecord.get('CNT') != 0) {
						     itemGrid.getSelectionModel().deselect(selectRecord);
						     return false;
						   }
		                },
		                deselect:  function(grid, selectRecord, index, eOpts ){
		                }
		            }
		        }),
    	uniOpt:{
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			copiedRow : true,
			onLoadSelectFirst : false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [{
            id: 'detailGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'detailGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
		//selModel:'rowmodel',
    	columns : [
    		{dataIndex : 'DIV_CODE',		width:200, 		hidden : true },
    		{dataIndex : 'ITEM_CODE',		width:100 },
    		{dataIndex : 'ITEM_NAME',		width:200 },
    		{dataIndex : 'SPEC',			width:70 },
    		{dataIndex : 'ITEM_ACCOUNT',	width:70,align:'center' },
    		{dataIndex : 'USE_YN',			width:100, 		hidden : true },
    		{dataIndex : 'CNT',			    width:80,align:'center' }
    	],
    	listeners: {
    		render: function(grid, eOpts){
    		},

			beforeselect : function ( grid, record, index, eOpts )
			{
				var detailStore = directTestStore;
				if(detailStore.isDirty())	{
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
						var inValidRecs = detailStore.getInvalidRecords();
						if(inValidRecs.length > 0 )	{
							alert(Msg.sMB083);
							return false;
						}else {
							detailStore.saveStore();
							UniAppManager.app.fnChangeUse();
							isItemGridUseChange = true;
						}
					}
				}
			},
			selectionchange : function( model1, selected, eOpts ){
				//qbaComboStore.loadStoreRecords(selected[0]);
			},onGridDblClick:function(grid, record, cellIndex, colName, eOpts) {
				gsRecord = record;
				this.setDetailGrd( record, eOpts);
				testGrid.down('#selItemCode').setValue(record.get('ITEM_CODE'));
				testGrid.down('#selItemName').setValue(record.get('ITEM_NAME'));
				testGrid.down('#selRegCnt').setValue(record.get('CNT'));
			}
		},
		 setDetailGrd : function ( selected, eOpts) {
			 if(! Ext.isEmpty(selected)) {
					var record = selected;
					directTestStore.loadData({});
					directTestStore.loadStoreRecords(record);
				}
		 }
    });

    var testGrid = Unilite.createGrid('qba220ukrvtestGrid', {
		store : directTestStore,
		title : '검사항목리스트',
		flex : 3,
		split:true,
		uniOpt:{
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false
		},
		tbar: [ {	name	 :'SEL_ITEM_CODE',
					xtype	 :'uniTextfield',
					itemId	 :'selItemCode',
					width	 : 100,
					readOnly :true
				},
				{
					name	 :'SEL_ITEM_NAME',
					itemId	 :'selItemName',
					xtype	 :'uniTextfield',
					width	 : 200,
					readOnly :true
				},{
					xtype	: 'uniNumberfield',
					itemId	: 'selRegCnt',
					readOnly: true,
					hidden  : false,
					width	: 50
				},
				{  itemId: 'requestBtn',
		            text: '선택품목에 복사',
		            handler: function() {

						var detailSelectedRecs	= itemGrid.getSelectedRecords();
						var selRegCnt 	= testGrid.down('#selRegCnt').getValue();
						if(detailSelectedRecs.length == 0 || selRegCnt == 0){
							Unilite.messageBox('품목리스트에서 더블클릭하시고 검사항목이 등록되어 있는 품목을 선택하여 주십시오.');
							return;
						}

						if(confirm('선택품목에 검사항목정보를 복사하시겠습니까?')){
							Ext.getCmp('qba220ukrvApp').mask('<t:message code="system.message.human.message010" default="저장중..."/>','loading-indicator');

							var selRecords = itemGrid.getSelectionModel().getSelection();
							Ext.each(selRecords, function(selRecord, index) {
								if(selRecord.get('USE_YN') == 'N') {
									selRecord.phantom = true;
									buttonStore.insert(index, selRecord);
								}
								if(selRecords.length == index + 1) {
									buttonStore.saveStore();
								}
							})
						}

		                }
		        },'-',{
					itemId: 'reqIssueLinkBtn',
					text: '검사항목 가져오기',
					handler: function() {
						var record = itemGrid.getSelectedRecords();
						var divCode = panelResult.getValue('DIV_CODE');
						var revisionDate = panelResult.getValue('REVISION_DATE');
						var selItemCode = testGrid.down('#selItemCode').getValue();
						var selRegCnt 	= testGrid.down('#selRegCnt').getValue();
						if(Ext.isEmpty(selItemCode)){
							Unilite.messageBox('품목리스트에서 더블클릭하시고 품목을 선택하여 주십시오.');
							return;
						}
						if(!Ext.isEmpty(selItemCode) && selRegCnt == 0 && directTestStore.getCount() == 0){
						//	if(!Ext.isEmpty(record)){
									var param = {"S_COMP_CODE": UserInfo.compCode,
									"DIV_CODE": divCode};

								qba220ukrvService.selectTestListNew(param, function(provider, response) {
									var records = response.result;
									if(!Ext.isEmpty(provider)) {
									   Ext.each(records, function(record,i) {
				   								var r = {
													DIV_CODE		: divCode,
													ITEM_CODE		: selItemCode,
													TEST_CODE		: record.TEST_CODE,
													TEST_NAME		: record.TEST_CODE,
													TEST_NAME_DB	: record.TEST_NAME,
													TEST_NAME_ENG	: record.TEST_NAME_ENG,
													TEST_METH		: record.TEST_METH,
													TEST_COND	    : record.TEST_COND,
													TEST_COND_ENG	: record.TEST_COND_ENG,
													TEST_COND_FROM	: record.TEST_COND_FROM,
													TEST_COND_TO	: record.TEST_COND_TO,
													TEST_VALUE		: record.TEST_VALUE,
													TEST_RESULT		: record.TEST_RESULT,
													TEST_UNIT		: record.TEST_UNIT,
													TEST_PRSN		: record.TEST_PRSN,
													REVISION_DATE	: revisionDate,
													TEST_VER		: '1',
													SEQ             : record.SEQ,
													USE_YN          : 'Y',
													REMARK          : record.REMARK,
													VALUE_POINT     : record.VALUE_POINT

												};

							            	testGrid.createRow(r);

									   })
									}
								})
						//	}
						}else{
							Unilite.messageBox('이미 품목이 등록된 경우는 검사 항목을 가져올 수 없습니다.');
							return;
						}
					}
		},'-'],
		features: [{
            id: 'detailGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'detailGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
		columns : [
    		{dataIndex : 'DIV_CODE',		width:100, 		hidden : true },
    		{dataIndex : 'ITEM_CODE',		width:100, 		hidden : true },
    		{dataIndex : 'TEST_CODE',		width:100},
    		{dataIndex : 'TEST_NAME',		width:100},
    		{dataIndex : 'TEST_NAME_DB',	width:100, 		hidden : true },
			{dataIndex : 'TEST_NAME_ENG',	width:100},
			{dataIndex :'TEST_METH'			,width:100},
			{dataIndex :'TEST_COND'			,width:200},
			{dataIndex :'TEST_COND_ENG'		,width:200},
			{dataIndex :'TEST_COND_FROM'	,width:90},
			{dataIndex :'TEST_COND_TO'		,width:90},
			{dataIndex :'TEST_VALUE'		,width:100,
				renderer: function(value, metaData, record) {
					var formatStyle = '0,000'
					formatStyle = UniAppManager.app.fnFormatStyle(record.get('VALUE_POINT'));
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, formatStyle) + '</div>';
                }
			},
			{dataIndex:'TEST_RESULT'	,width:200},
			{dataIndex:'TEST_UNIT'		,width:105},
			{dataIndex:'TEST_PRSN'		,width:70},
			{dataIndex:'REVISION_DATE'  ,width:100},
			{dataIndex:'TEST_VER'		,width:70,hidden : true},
			{dataIndex:'SEQ'			,width:50 ,align:'center'},
			{dataIndex:'USE_YN'			,width:70 ,align:'center',hidden : true},
			{dataIndex:'REMARK'			,width:300},
			{dataIndex:'VALUE_POINT'	,width:100,hidden : true}
    	],
    	listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['DIV_CODE', 'ITEM_CODE','TEST_CODE','TEST_NAME','REVISION_DATE', 'TEST_UNIT', 'TEST_PRSN'])){
						return false;
					}

				}else if(e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['DIV_CODE', 'ITEM_CODE', 'TEST_UNIT', 'TEST_PRSN', 'TEST_CODE'])){
						return false;
					}
				}
			}
		}
    });



    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
				region: 'center',
				layout: {type: 'hbox', align: 'stretch'},
				border: false,
				flex: 1,
				items: [itemGrid, testGrid]
				//items: [testGrid]

			}, panelResult]
		}
    	, panelSearch
		],
		id : 'qba220ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset'], true);
         	// UniAppManager.setToolbarButtons('newData', false);
			this.setDefault();
		},
		onQueryButtonDown:function() {
	        itemGrid.getStore().loadStoreRecords();
			testGrid.down('#selItemCode').setValue('');
			testGrid.down('#selItemName').setValue('');
			testGrid.down('#selRegCnt').setValue('');
			testGrid.reset();
			directTestStore.clearData();
	        //testGrid.getStore().loadStoreRecords();
      	},
      	onSaveDataButtonDown: function () {
           if(directTestStore.isDirty()) {
        	   directTestStore.saveStore();
           }
        },
        onResetButtonDown:function() {
			itemGrid.getStore().loadData({});
			testGrid.getStore().loadData({});
			Ext.getCmp('qba220ukrvSearchForm').reset();
			this.fnInitBinding();
        },
        onNewDataButtonDown : function()    {
			 /**
			  * Detail Grid Default 값 설정
			  */
			var divCode = panelResult.getValue('DIV_CODE');
			var revisionDate = panelResult.getValue('REVISION_DATE');
			//var record = itemGrid.getSelectedRecords();
			if(!Ext.isEmpty(gsRecord)){
				var r = {
					     DIV_CODE		: divCode,
					     ITEM_CODE		: gsRecord.data['ITEM_CODE'],
					     REVISION_DATE	: revisionDate,
					     TEST_VER       : '1',
					     USE_YN         : 'Y'

					};
				testGrid.createRow(r);
			}
       },
        onDeleteDataButtonDown: function() {
			var selRow = testGrid.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                	testGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                	testGrid.deleteSelectedRow();
                }
            }
        },
        setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.getForm().wasDirty = false;
        	panelSearch.resetDirtyStatus();
			testGrid.down('#selItemCode').setValue('');
			testGrid.down('#selItemName').setValue('');
			testGrid.down('#selRegCnt').setValue('');
            UniAppManager.setToolbarButtons('save', false);
            qbaComboStore.loadStoreRecords(UserInfo.divCode);
        },
		fnChangeUse: function() {
			/* var iCnt = 0; */
			var itemRecords = directTestStore.data.items;
			var selectedItemRecord = itemGrid.getSelectedRecord();
			if (!isItemGridUseChange && /* !Ext.isEmpty(itemRecords) && */ !Ext.isEmpty(selectedItemRecord)){
				selectedR = selectedItemRecord;
				/* Ext.each(itemRecords, function(record, i){
					if(record.get('USE_YN') == 'Y') {
						iCnt = iCnt + 1;

						return false;
					}
				})

				if(iCnt > 0){
					Ext.each(selectedItemRecord, function(record, i){
						selectedItemRecord.set('USE_YN', 'Y')
					})
				}else{
					Ext.each(selectedItemRecord, function(record, i){
						selectedItemRecord.set('USE_YN', 'N')
					})
				} */
			}

		},
			fnFormatStyle:function(value) {
			    	if(value == 1){
				formatStyle = '0,000.0';
				    	}else if(value == 2){
				    	formatStyle = '0,000.00';
				    	}else if(value == 3){
				    	formatStyle = '0,000.000';
				    	}else if(value == 4){
				    	formatStyle = '0,000.0000';
				    	}else if(value == 5){
				    	formatStyle = '0,000.00000';
				    	}else if(value == 6){
				    	formatStyle = '0,000.000000';
				    	}else if(value == 7){
				    	formatStyle = '0,000.0000000';
				    	}else if(value == 8){
				    	formatStyle = '0,000.00000000';
				    	}else if(value == 9){
				    	formatStyle = '0,000.000000000';
				    	}else{
				    	formatStyle = '0,000';
				    	}
				    	return formatStyle;
				}
    });

	Unilite.createValidator('qba220ukrvValidator', {
		store: directTestStore,
		grid: testGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(newValue == oldValue){
				return true;
			}
			var rv = true;
			switch(fieldName) {
				case "TEST_NAME" :
					var COMBO_TEST_CODE = Ext.data.StoreManager.lookup('qbaComboStore');// TEST_CODE COMBO STORID 가져오기
					Ext.each(COMBO_TEST_CODE.data.items, function(comboData, jdx) {
						if(comboData.get("value") == newValue){
							record.set('TEST_CODE'		, comboData.get('value'))
							record.set('TEST_NAME_DB'	, comboData.get('text'))
							record.set('TEST_COND'		, comboData.get('refCode1'))
							record.set('TEST_COND_FROM'	, comboData.get('refCode2'))
							record.set('TEST_COND_TO'	, comboData.get('refCode3'))
							record.set('TEST_METH'		, comboData.get('refCode4'))
							record.set('TEST_UNIT'		, comboData.get('refCode5'))
							record.set('TEST_RESULT'	, comboData.get('refCode6'))
							record.set('TEST_PRSN'		, comboData.get('refCode8'))
							record.set('SEQ'			, comboData.get('refCode9'))
							record.set('VALUE_TYPE'		, comboData.get('refCode10'))
							record.set('REMARK'			, comboData.get('refCode11'))
							record.set('VALUE_POINT'	, comboData.get('refCode12'))
							record.set('TEST_VALUE'		, comboData.get('refCode13'))
							record.set('TEST_NAME_ENG'	, comboData.get('refCode14'))
							record.set('TEST_COND_ENG'	, comboData.get('refCode15'))
						}
					});
				break;
			}
			return rv;
		}
	});

		function fnMakeLogStore() {
		var records = itemGrid.getSelectedRecords();
		buttonStore.clearData();
		Ext.each(records, function(record, index) {
			record.phantom = true;
			buttonStore.insert(index, record);
			});
			buttonStore.saveStore();
		}

};


</script>