<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had890ukr"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005"/>	<!-- 직위 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var resultEmailPop; // 이메일 전송 결과 팝업
	
	Ext.create('Ext.data.Store',{
		storeId: "retrTypeStore",
		data:[
			{text: '중도퇴사', value: 'Y'},
			{text: '연말정산', value: 'N'}
		]
	});
	/**
	 *Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Had890ukrModel', {
		fields: [
			{name: 'DIV_CODE'				,text: '사업장',		type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_NAME'				,text: '부서',		type: 'string'},
			{name: 'DEPT_CODE'				,text: '부서코드',		type: 'string'},
			{name: 'POST_CODE'				,text: '직위',		type: 'string', comboType: 'AU', comboCode:'H005'},
			{name: 'NAME'					,text: '성명',		type: 'string'},
			{name: 'PERSON_NUMB'			,text: '사번',		type: 'string'},
			{name: 'JOIN_DATE'				,text: '입사일',		type: 'uniDate'},
			{name: 'RETR_DATE'				,text: '퇴사일',		type: 'uniDate'},

			{name: 'DEF_IN_TAX_I'			,text: '소득세',		type: 'uniPrice'},
			{name: 'DEF_LOCAL_TAX_I'		,text: '주민세',		type: 'uniPrice'},
			{name: 'NOW_IN_TAX_I'			,text: '소득세',		type: 'uniPrice'},
			{name: 'NOW_LOCAL_TAX_I'		,text: '주민세',		type: 'uniPrice'},
			{name: 'PREV_IN_TAX_I'			,text: '소득세',		type: 'uniPrice'},
			{name: 'PREV_LOCAL_TAX_I'		,text: '주민세',		type: 'uniPrice'},
			{name: 'IN_TAX_I'				,text: '소득세',		type: 'uniPrice'},
			{name: 'LOCAL_TAX_I'			,text: '주민세',		type: 'uniPrice'},
			{name: 'ACTUAL_TAX_RATE'		,text: '실효세율',		type: 'float'	, decimalPrecision: 1},
			
			{name: 'INCOME_SUPP_TOTAL_I'	,text: '총급여액',		type: 'uniPrice'},
			
			{name: 'EMAIL_ADDR'				,text: '이메일',		type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('had890ukrMasterStore1',{
		model: 'Had890ukrModel',
		uniOpt : {
			isMaster: false,	// 상위 버튼 연결 
			editable: true,		// 수정 모드 사용 
			deletable:false,	// 삭제 가능 여부 
			useNavi : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'had890ukrService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param = Ext.getCmp('searchForm').getValues();
			
			this.load({
				params : param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
		
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '검색조건',		
		defaultType: 'uniSearchSubPanel',
		listeners: {
			collapse: function () {
				panelResult.show();
				detailForm.show();
			},
			expand: function() {
				panelResult.hide();
				detailForm.hide();
			}
		},
		items: [{
			title: '기본정보',
			id: 'search_panel1',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '정산구분',
				name:'HALFWAY_TYPE',
				allowBlank: false,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('retrTypeStore'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('HALFWAY_TYPE', newValue);
						
						var year = panelSearch.getValue('YEAR_YYYY')
						panelSearch.setValue('TITLE', year + '년도 ' + this.rawValue +' 원천징수 영수증');
						detailForm.setValue('TITLE1', year + '년도 ' + this.rawValue +' 원천징수 영수증');
					}
				}
			},{
				fieldLabel : '정산년도',
				name : 'YEAR_YYYY',
				xtype : 'uniYearField',
				allowBlank: false,
				value:UniHuman.getTaxReturnYear(),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('YEAR_YYYY', newValue);
						
						var halfwayType = panelSearch.getField('HALFWAY_TYPE').rawValue;
						panelSearch.setValue('TITLE', newValue + '년도 ' + halfwayType +' 원천징수 영수증');
						detailForm.setValue('TITLE1', newValue + '년도 ' + halfwayType +' 원천징수 영수증');
					}
				}
			},{
				fieldLabel: '신고사업장',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
					'onValueFieldChange': function(field, newValue, oldValue  ){
							panelResult.setValue('DEPT',newValue);
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
							panelResult.setValue('DEPT_NAME',newValue);
					},
					'onValuesChange':  function( field, records){
							var tagfield = panelResult.getField('DEPTS');
							tagfield.setStoreData(records)
					}
				}
			}),
			Unilite.popup('Employee',{
				validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					}
				}
			}),{
				fieldLabel: '퇴사일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'RETIRE_DATE_FR',
				endFieldName: 'RETIRE_DATE_TO',
				width: 325,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('RETIRE_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('RETIRE_DATE_TO', newValue);
					}
				}
			}]
		},{ 
			title: '추가정보',  
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				id :'TITLE',
				name: 'TITLE', 
				fieldLabel: '제목',
				xtype: 'uniTextfield',
				allowBlank: false,
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('TITLE1', newValue);
					}
				}
			}
			,{
				fieldLabel: '비고',
				id:'COMMENTS',
				xtype: 'textareafield',
				name: 'COMMENTS',
				height : 80,
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						detailForm.setValue('COMMENTS1', newValue);
					}
				}
			}]
		}]
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
		region: 'north',
		layout : {type : 'uniTable', columns :	3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '정산구분'	,
			name:'HALFWAY_TYPE',
			xtype: 'uniCombobox',
			allowBlank: false,
			store: Ext.data.StoreManager.lookup('retrTypeStore'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('HALFWAY_TYPE', newValue);
					
					var year = panelResult.getValue('YEAR_YYYY');
					panelSearch.setValue('TITLE', year + '년도 ' + this.rawValue +' 원천징수 영수증');
					detailForm.setValue('TITLE1', year + '년도 ' + this.rawValue +' 원천징수 영수증');
				}
			}
		},{
			fieldLabel : '정산년도',
			name : 'YEAR_YYYY',
			xtype : 'uniYearField',
			allowBlank: false,
			value:UniHuman.getTaxReturnYear(),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					
					panelSearch.setValue('YEAR_YYYY', newValue);
					
					var halfwayType = panelResult.getField('HALFWAY_TYPE').rawValue;
					panelSearch.setValue('TITLE', newValue + '년도 ' + halfwayType +' 원천징수 영수증');
					detailForm.setValue('TITLE1', newValue + '년도 ' + halfwayType +' 원천징수 영수증');
				}
			}
		},{
			fieldLabel: '신고사업장',
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
				'onValueFieldChange': function(field, newValue, oldValue  ){
						panelSearch.setValue('DEPT',newValue);
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelSearch.setValue('DEPT_NAME',newValue);
				},
				'onValuesChange':  function( field, records){
						var tagfield = panelSearch.getField('DEPTS');
						tagfield.setStoreData(records)
				}
			}
		}),
		Unilite.popup('Employee',{
			validateBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
					panelResult.setValue('PERSON_NUMB', '');
					panelResult.setValue('NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);
				}
			}
		}),{ 
			fieldLabel: '퇴사일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'RETIRE_DATE_FR',
			endFieldName: 'RETIRE_DATE_TO',
			width: 325,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('RETIRE_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('RETIRE_DATE_TO', newValue);
				}
			}
		}]
	});
	
	var detailForm = Unilite.createForm('detailForm',{
		region: 'center',
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { width: '100%'},
			tdAttrs: {width: '100%'}
		},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		items: [{
				id :'TITLE1',
				name: 'TITLE1', 
				fieldLabel: '제목',
				width: 1000,
				xtype: 'uniTextfield',
				colspan: 3,
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TITLE', newValue);
					}
				}
			},{
				fieldLabel: '내용',
				id:'COMMENTS1',
				width: 1000,
				autoScroll:true,
				xtype: 'textareafield',
				name: 'COMMENTS1',
				height : 100,
				rowspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('COMMENTS', newValue);
					}
				}
			}
		]
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	
	var masterGrid = Unilite.createGrid('had890ukrGrid', {
		layout : 'fit',
		region:'south',
		uniOpt:{	
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			onLoadSelectFirst : false,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			},
			state: {					//그리드 설정 사용 여부
				useState: false,
				useStateList: false
			} 
		},
		tbar: [{
			xtype: 'button',
			text: '메일전송',
			listeners: {
			click: function() {
				if(Ext.isEmpty(panelSearch.getValue('TITLE'))){
					alert('제목은 필수입나다.');
					return false;
				}
				
				if(!panelSearch.getForm().isValid()){
					var invalid = panelSearch.getForm().getFields().filterBy(
						function(field) {
							return !field.validate();
					});
					// 필수 항목에 값이 없는 경우
					if (invalid.length > 0) {
						r = false;
						var labelText = '';
						
						if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
							var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
						} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
						}
						Ext.Msg.alert("경고", labelText + '필수입력 항목입니다.');
						invalid.items[0].focus();
					}
				}

				var param = new Array();
				var selectedModel = masterGrid.getSelectionModel().getSelection();

				Ext.each(selectedModel, function(record,i){
					record.data['COMMENTS']			= '<pre>' + Ext.getCmp('COMMENTS').getValue() + '</pre>';
					record.data['TITLE']			= Ext.getCmp('TITLE').getValue();
					record.data['HALFWAY_TYPE_NM']	= panelSearch.getField('HALFWAY_TYPE').rawValue;
					record.data['HALFWAY_TYPE']		= panelSearch.getValue('HALFWAY_TYPE');
					record.data['YEAR_YYYY']		= panelSearch.getValue('YEAR_YYYY');
					record.data['FRRETIREDATE']		= Ext.getCmp('searchForm').getValue('RETIRE_DATE_FR');
					record.data['TORETIREDATE']		= Ext.getCmp('searchForm').getValue('RETIRE_DATE_TO');
					param.push(record.data);
				});
				
				if(confirm('이메일을 전송하시겠습니까?')) {
					Ext.Ajax.request({
						url		: CPATH+'/human/had890ukr_email.do', 
						params	: {
							data: JSON.stringify(param)
						},
						method: 'post',
						async : true
					});
					Unilite.messageBox("이메일 전송이 시작되었습니다. 이메일전송 결과로 확인하세요.");
					}
				}
			} //listner
		},{
			xtype: 'button',
			text: '이메일전송결과',
			handler: function(){
				var param= Ext.getCmp('searchForm').getValues();
				openResultPopup(param);
			}
		}],
		features: [{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		store: directMasterStore1,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick: false }),  // checkbox
		columns: [
				{ dataIndex: 'DIV_CODE'					,					width: 120,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
					}
				},
				{ dataIndex: 'DEPT_NAME'				,width: 120 },
				{ dataIndex: 'DEPT_CODE'				,width: 120, hidden: true},
				{ dataIndex: 'POST_CODE'				,width: 70 , align:'center'},
				{ dataIndex: 'NAME'						,width: 70 , align:'center'},
				{ dataIndex: 'PERSON_NUMB'				,width: 80 , align:'center'},
				{ dataIndex: 'JOIN_DATE'				,width: 90 , hidden: true },
				{ dataIndex: 'RETR_DATE'				,width: 90 , hidden: true },
				{ text: '근로소득금액', columns: [
					{ dataIndex: 'INCOME_SUPP_TOTAL_I'		,width: 100, summaryType: 'sum' }
				]},
				{ text: '세액명세', columns: [
					{ text: '결정세액', columns: [
							{ dataIndex: 'DEF_IN_TAX_I'				,width: 100, summaryType: 'sum' },
							{ dataIndex: 'DEF_LOCAL_TAX_I'			,width: 100, summaryType: 'sum' }
					]},
					{ text: '기납부세액', columns: [
						{ text: '주(현)근무지', columns: [
							{ dataIndex: 'NOW_IN_TAX_I'				,width: 100, summaryType: 'sum' },
							{ dataIndex: 'NOW_LOCAL_TAX_I'			,width: 100, summaryType: 'sum' }
						]},
						{ text: '종(전)근무지', columns: [
							{ dataIndex: 'PREV_IN_TAX_I'			,width: 100, summaryType: 'sum' },
							{ dataIndex: 'PREV_LOCAL_TAX_I'			,width: 100, summaryType: 'sum' }
						]}
					]},
					{ text: '차감징수(환급)세액', columns: [
						{ dataIndex: 'IN_TAX_I'					,width: 100, summaryType: 'sum' },
						{ dataIndex: 'LOCAL_TAX_I'				,width: 100, summaryType: 'sum' }
					]},
					{ dataIndex: 'ACTUAL_TAX_RATE'			,width:  60	, text: '실효<br/>세율' }
				]},
				{ dataIndex: 'EMAIL_ADDR'				,width: 200 }
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['EMAIL_ADDR'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});
	
	function openResultPopup(param)	{
		
		if(!resultEmailPop)	{
			Unilite.defineModel('resultModel',{
				fields: [
					  {name : 'YEAR_YYYY'		, text : '정산년도'		, type: 'string'}
					 ,{name : 'HALFWAY_TYPE'	, text : '정산구분'		, type: 'string', store: Ext.data.StoreManager.lookup('retrTypeStore')}
					 ,{name : 'PERSON_NUMB'		, text : '사번'		, type: 'string'}
					 ,{name : 'SEND_SEQ'		, text : '순번'		, type: 'string'}
					 ,{name : 'DIV_CODE'		, text : '사업장'		, type: 'string', comboType: 'BOR120'}
					 ,{name : 'NAME'			, text : '이름'		, type: 'string'}
					 ,{name : 'POST_CODE'		, text : '직위'		, type: 'string', comboType: 'AU', comboCode:'H005' }
					 ,{name : 'DEPT_CODE'		, text : '부서코드'		, type: 'string'}
					 ,{name : 'DEPT_NAME'		, text : '부서명'		, type: 'string'}
					 ,{name : 'EMAIL_ADDR'		, text : '이메일'		, type: 'string'}
					 ,{name : 'SEND_RESULT'		, text : '결과'		, type: 'string'}
					 ,{name : 'ERROR_MSG'		, text : '메세지'		, type: 'string'}
					 ,{name : 'INSERT_DB_USER'	, text : '전송자'		, type: 'string'}
					 ,{name : 'INSERT_DB_TIME'	, text : '전송일'		, type: 'string'}
				]
			});
			resultEmailPop = Ext.create('widget.uniDetailWindow', {
				title: '이메일 전송 결과',
				width: 1100,
				height:600,
				
				layout: {type:'vbox', align:'stretch'},
				items: [{
						itemId:'search',
						xtype:'uniSearchForm',
						layout:{type:'uniTable',columns:3},
						items:[
							{
								fieldLabel: '정산년도',
								xtype: 'uniYearField',
								name: 'YEAR_YYYY',
								value:UniHuman.getTaxReturnYear(),
								allowBlank: false
							},{
								fieldLabel: '정산구분',
								name:'HALFWAY_TYPE',
								allowBlank: false,
								xtype: 'uniCombobox',
								store: Ext.data.StoreManager.lookup('retrTypeStore'),
								allowBlank: false
							},{
								fieldLabel: '사업장',
								name:'DIV_CODE',
								xtype: 'uniCombobox',
								comboType:'BOR120'
							}
							,Unilite.treePopup('DEPTTREE',{
									fieldLabel: '부서',
									valueFieldName:'DEPT',
									textFieldName:'DEPT_NAME' ,
									valuesName:'DEPTS' ,
									selectChildren:true,
									DBvalueFieldName:'TREE_CODE',
									DBtextFieldName:'TREE_NAME',
									textFieldWidth:130,
									validateBlank:true,
									width:350,
									autoPopup:true,
									useLike:true
							})
							,Unilite.popup('Employee')
						]
					},
					Unilite.createGrid('', {
						itemId:'grid',
						layout : 'fit',
						store: Unilite.createStoreSimple('resultStore', {
							model: 'resultModel' ,
							proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
								api: {
									read : 'had890ukrService.selectResultList'
								}
							}),
							loadStoreRecords : function() {
								var param = resultEmailPop.down('#search').getValues();
								this.load({
									params: param
								});
							}
						}),
						selModel:'rowmodel',
						uniOpt:{	
							expandLastColumn: false	//마지막 컬럼 * 사용 여부
						},
						columns: [  
							  {dataIndex : 'YEAR_YYYY'		, width : 80  , align:'center'}
							 ,{dataIndex : 'HALFWAY_TYPE'	, width : 80  , align:'center'}
							 ,{dataIndex : 'DIV_CODE'		, width : 120}
							 ,{dataIndex : 'DEPT_NAME'		, width : 120}
							 ,{dataIndex : 'POST_CODE'		, width : 100 , align:'center'}
							 ,{dataIndex : 'NAME'			, width : 70  , align:'center'}
							 ,{dataIndex : 'PERSON_NUMB'	, width : 100 , align:'center'}
							 ,{dataIndex : 'EMAIL_ADDR'		, width : 160}
							 ,{dataIndex : 'SEND_SEQ'		, width : 50  , align:'center'}
							 ,{dataIndex : 'SEND_RESULT'	, width : 60  , align:'center'}
							 ,{dataIndex : 'INSERT_DB_TIME'	, width : 130}
							 ,{dataIndex : 'ERROR_MSG'		, width : 300}
						]
					})
					   
				],
				tbar:  ['->',
					 {
						itemId : 'searchtBtn',
						text: '조회',
						handler: function() {
							var form = resultEmailPop.down('#search');
							var store = Ext.data.StoreManager.lookup('resultStore');
							store.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							resultEmailPop.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
							resultEmailPop.down('#search').clearForm();
							resultEmailPop.down('#grid').reset();
						},
					beforeclose: function( panel, eOpts )  {
							resultEmailPop.down('#search').clearForm();
							resultEmailPop.down('#grid').reset();
						},
					show: function( panel, eOpts ) {
							var form = resultEmailPop.down('#search');
							form.clearForm();
							form.setValues(resultEmailPop.param);
							var store = Ext.data.StoreManager.lookup('resultStore')
							store.loadStoreRecords();
						 }
					}
				});
		}
		resultEmailPop.param = param;
		resultEmailPop.center();
		resultEmailPop.show();
	}

	Unilite.Main({
		borderItems:[{
			region:'center',
			layout  : {type: 'vbox', align: 'stretch'},
			border  : false,
			items:[
				panelResult,detailForm, masterGrid
			]
		},
			panelSearch
		],
		id  : 'had890ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('HALFWAY_TYPE', 'N');
			panelResult.setValue('HALFWAY_TYPE', 'N');
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('HALFWAY_TYPE');
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		}
	});
};

</script>
