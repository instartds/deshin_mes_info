<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr150skrv"  >
	<t:ExtComboStore comboType="BOR120"  />		<!-- 사업장 -->  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	//동적 그리드 구현(공통코드(p03)에서 컬럼 가져오기)
	var gsProdtDate	= UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '.' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6) + '.' + UniDate.getDbDateStr(UniDate.get('today')).substring(6,8);
	var fields		= createModelField(gsProdtDate, true);
	var columns		= createGridColumn(gsProdtDate, true);



	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('pmr150skrvModel', {
		fields : fields
	}); //End of Unilite.defineModel('pmr150skrvModel', {



	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('pmr150skrvMasterStore1',{
		model	: 'pmr150skrvModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api: {
				read: 'pmr150skrvService.selectList'
			}
		},
		loadStoreRecords : function(prodtDateArray)	{
			var param= panelSearch.getValues();
			if(!Ext.isEmpty(prodtDateArray)) {
				param.prodtDateArray = prodtDateArray;
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					UniAppManager.setToolbarButtons('reset'	, true);
				}
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title		: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
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
				fieldLabel		: '<t:message code="system.label.product.productiondate" default="생산일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				width			: 315,
				textFieldWidth	: 170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO',newValue);
					}	
				} 
			},
			Unilite.popup('ITEM',{
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				allowBlank		: false,
//				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					}
				}
			})]
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
				//	this.mask();
				}
	  		} else {
				this.unmask();
			}
			return r;
		}
	}); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
	var panelResult = Unilite.createSearchForm('resultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		padding	: '1 1 1 1',
		layout	: {type : 'uniTable', columns : 2},
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE', 
			comboType	: 'BOR120',
			allowBlank	: false,
			tdAttrs		: {width: 290},
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{ 
			fieldLabel		: '<t:message code="system.label.product.productiondate" default="생산일"/>',
			xtype			: 'uniDateRangefield',  
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			width			: 315,
			textFieldWidth	: 170,
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_TO',newValue);
				}	
			} 
		}, 
		Unilite.popup('ITEM',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			textFieldWidth	: 420,
			colspan			: 2,
			allowBlank		: false,
//			validateBlank	: false,
		 	listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
					panelResult.setValue('ITEM_CODE', '');
					panelResult.setValue('ITEM_NAME', '');
				}
			}
		})]
	});



	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('pmr150skrGrid1', {
		region	: 'center',
		store	: directMasterStore1,
		columns	: columns,
		selModel: 'rowmodel',
		uniOpt: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			dblClickToEdit		: false,
			onLoadSelectFirst	: false,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: true,
			useRowContext 		: true,
			excel: {
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: true,		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			},
			filter: {
				useFilter		: false,
				autoCreate		: false
			},
			state: {
		    	useState: false,	//그리드 설정 버튼 사용 여부 
		   		useStateList: false	//그리드 설정 목록 사용 여부 
			}
		},
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false 
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary', 
			showSummaryRow	: false
		}],
		listeners: {
		}
/*		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				
			  	if(record.get('GUBUN') == '3'){
			  		//배경색(dark), 글자색(blue)
					cls = 'x-change-cell_Background_dark_Text_blue';
					
				} else if(record.get('GUBUN') == '2') {
					cls = 'x-change-cell_normal';
				}
				return cls;
			}
		}*/
	});



	Unilite.Main({
		id			: 'pmr150skrvApp',
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
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR'	, UniDate.get('today'));
			panelSearch.setValue('ORDER_DATE_TO'	, UniDate.get('today'));

			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR'	, UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_TO'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons('reset'	, false);

			//초기화 시  사업장으로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			} else {
				var param = panelSearch.getValues();
				pmr150skrvService.selectColumns(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						var records = response.result;
						Ext.each(provider, function(selectedDate,index) {
							if(index == 0) {
								gsProdtDate = selectedDate.PRODT_NUM + selectedDate.PRODT_DATE.replace(/\./g,'');
							} else {
								gsProdtDate += ',' + selectedDate.PRODT_NUM + selectedDate.PRODT_DATE.replace(/\./g,'');
							}
						});
						//그리드 컬럼명 조건에 맞게 재 조회하여 입력
						var newColumns = createGridColumn(records);
						masterGrid.setConfig('columns',newColumns);
				
						var prodtDateArray = new Array();
						prodtDateArray = gsProdtDate.split(',');
						directMasterStore1.loadStoreRecords(prodtDateArray);

					} else {
						alert('조회된 데이터가 없습니다.');
						UniAppManager.app.onResetButtonDown();
					}
				});
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();

			gsProdtDate	= UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) + '.' + UniDate.getDbDateStr(UniDate.get('today')).substring(4,6) + '.' + UniDate.getDbDateStr(UniDate.get('today')).substring(6,8);
			var newColumns = createGridColumn(gsProdtDate, true);
			masterGrid.setConfig('columns', newColumns);
			
			this.fnInitBinding();
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	}); //End of Unilite.Main



	// 모델 필드 생성
	function createModelField(colData, isInit) {
		var fields = [
			{name: 'DIV_CODE'	, type: 'string'},
			{name: 'ITEM_CODE'	, type: 'string' },
			{name: 'ITEM_NAME'	, type: 'string' }
		];
		
		if(isInit) {
			fields.push({name: colData, type:'string' });
		} else {
			Ext.each(colData, function(selectedDate, index) {
				if(!Ext.isEmpty(selectedDate)) {
					var name = selectedDate.PRODT_DATE.replace(/\./g,'');
					//alert(name);
					fields.push({name: 'Z' + index, type:'string' });
				}
			});
		}
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData, isInit) {
		var columns = [
			{text: '제조일',
				columns: [ 
					{text: '제조자',
						columns: [ 
							{text: '생산량',
								columns: [ 
									{text: '실적량',
										columns: [ 
											{text: '비고',
												columns: [
													{dataIndex:'ITEM_CODE',		width: 100		, text: '품목코드'		, locked: false		, sortable: false	, hidden: false},
													{dataIndex:'ITEM_NAME',		width: 200		, text: '품목명'		, locked: false		, sortable: false	, hidden: false}
												]
											}
										]
									}
								]
							}
						]
					}
				]
			}
		];
		if(isInit) {
			columns.push(
				{text: colData,
					columns: [ 
						{text: '*',
							columns: [ 
								{text: '*',
									columns: [ 
										{text: '*',
											columns: [ 
												{text: '*',
													columns: [ 
														{dataIndex: colData,	width: 130		, text: '증감(%)'		, locked: false		, sortable: false	, hidden: false}
													]
												}
											]
										}
									]
								}
							]
						}
					]
				}
			);	
		} else {
			Ext.each(colData, function(selectedDate, index) {
				var name = selectedDate.PRODT_DATE.replace(/\./g,'');
				columns.push(
					{text: selectedDate.PRODT_DATE + ' ' + selectedDate.FR_TIME,
						columns: [ 
							{text: selectedDate.PRODT_PRSN,
								columns: [ 
									{text: selectedDate.WORK_Q,
										columns: [ 
											{text: selectedDate.GOOD_WORK_Q,
												columns: [ 
													{text: Unilite.nvl(selectedDate.REMARK, '*'),
														columns: [ 
															Ext.applyIf({dataIndex: 'Z' + index,	width: 130	, text: '증감(%)'		, style: 'text-align: center'}, {align: 'right'})
														]
													}
												]
											}
										]
									}
								]
							}
						]
					}
				);	
			});
		}
		console.log(columns);
		return columns;
	}	
};
</script>
