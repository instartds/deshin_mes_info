<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum900ukr">
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B043" /> 		<!-- 국내수출계정구분(출장구분(임시): 박부장님이 신규로 등록하면 그걸로 교체) --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'hum900ukrService.insertList',				
			read	: 'hum900ukrService.selectList',
			update	: 'hum900ukrService.updateList',
			destroy	: 'hum900ukrService.deleteList',
			syncAll	: 'hum900ukrService.saveAll'
		}
	});
	
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum900ukrModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'		 	, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사원번호'		 	, type: 'string'	, allowBlank: false},
			{name: 'NAME'				, text: '성명'		 	, type: 'string'	, allowBlank: false},
			{name: 'DEPT_CODE'			, text: '부서코드'		 	, type: 'string'	/*, allowBlank: false*/},
			{name: 'DEPT_NAME'			, text: '부서명'		 	, type: 'string'	/*, allowBlank: false*/},
			{name: 'SEQ'				, text: '순번'		 	, type: 'string'},
			{name: 'OUT_FROM_DATE'		, text: '출장시작일자'	 	, type: 'uniDate'	, allowBlank: false},
			{name: 'OUT_TO_DATE'		, text: '출장종료일자'	 	, type: 'uniDate'	, allowBlank: false},
			{name: 'BUSINESS_GUBUN'		, text: '출장구분'			, type: 'string'	, comboType:'AU', comboCode:'B043'	, allowBlank: false, editable: false},	//1 = 국내, 2 = 해외
			{name: 'NATION'				, text: '출장국가'		 	, type: 'string'	, allowBlank: false},
			{name: 'CITY'				, text: '출장지역'			, type: 'string'	, allowBlank: false},
			{name: 'PURPOSE'			, text: '목적'			, type: 'string'},
			{name: 'REMARK'				, text: '비고'			, type: 'string'}
		]										
	});//End of Unilite.defineModel('hum900ukrModel', {
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	var masterStore = Unilite.createStore('hum900ukrMasterStore1', {
		model	: 'hum900ukrModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				config = {
//					params: [paramMaster],
					success: function(batch, option) {
						
					 } 
				};
				this.syncAllDirect(config);				
			}else {					
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function() {
				if (this.getCount() > 0) {
//				  	UniAppManager.setToolbarButtons('delete', true);
					} else {
//				  	  	UniAppManager.setToolbarButtons('delete', false);
					}  
			}
		}
	});
		

	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
				fieldLabel		: '출장기간',
				xtype			: 'uniMonthRangefield',
				startFieldName	: 'OUT_FROM_MONTH',
				endFieldName	: 'OUT_TO_MONTH',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				allowBlank		: false,	  	
				tdAttrs			: {width: 350}, 
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				multiSelect	: true, 
				typeAhead	: false,
				comboType	: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			},
			Unilite.popup('Employee',{
				fieldLabel		: '사원',
			  	valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
			}),
			Unilite.treePopup('DEPTTREE',{
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT',
				textFieldName	: 'DEPT_NAME' ,
				valuesName		: 'DEPTS' ,
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName	: 'TREE_NAME',
				selectChildren	: true,
				validateBlank	: true,
				autoPopup		: true,
				useLike			: true,
				listeners		: {
					'onValueFieldChange': function(field, newValue, oldValue  ){
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
					},
					'onValuesChange':  function( field, records){
					}
				}
			})
		]
	});
	
		
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hum900ukrGrid1', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
		 	useRowNumberer	: true,
		 	copiedRow		: true
//		 	useContextMenu	: true,
		},
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
				   	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns	: [	
			{dataIndex: 'PERSON_NUMB'			, width: 90,
				'editor' : Unilite.popup('Employee_G',{
					validateBlank : true,
					autoPopup:true,
	  				listeners: {
	  					'onSelected': {
							fn: function(records, type) {
									console.log('records : ', records);
									console.log(records);
									var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
									grdRecord.set('DEPT_NAME'		, records[0].DEPT_NAME);
									grdRecord.set('DEPT_CODE'		, records[0].DEPT_CODE);
									grdRecord.set('PERSON_NUMB'		, records[0].PERSON_NUMB);
									grdRecord.set('NAME'			, records[0].NAME);
								},			  						
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('hum900ukrGrid1').uniOpt.currentRecord;
							grdRecord.set('DEPT_NAME'		, '');
							grdRecord.set('DEPT_CODE'		, '');
							grdRecord.set('PERSON_NUMB'		, '');
							grdRecord.set('NAME'			, '');
						},
						applyextparam: function(popup){	
//							popup.setExtParam({'PAY_GUBUN' : '2'});
						}
	 				}
				})
			},
			{dataIndex: 'NAME'			  	  	, width: 100,
				'editor' : Unilite.popup('Employee_G',{
					validateBlank : true,
					autoPopup:true,
	  				listeners: {
	  					'onSelected': {
							fn: function(records, type) {
									console.log('records : ', records);
									console.log(records);
									var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
									grdRecord.set('DEPT_NAME'		, records[0].DEPT_NAME);
									grdRecord.set('DEPT_CODE'		, records[0].DEPT_CODE);
									grdRecord.set('PERSON_NUMB'		, records[0].PERSON_NUMB);
									grdRecord.set('NAME'			, records[0].NAME);
								},			  						
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('hum900ukrGrid1').uniOpt.currentRecord;
							grdRecord.set('DEPT_NAME'		, '');
							grdRecord.set('DEPT_CODE'		, '');
							grdRecord.set('PERSON_NUMB'		, '');
							grdRecord.set('NAME'			, '');
						},
						applyextparam: function(popup){	
//							popup.setExtParam({'PAY_GUBUN' : '2'});
						}
	 				}
				})
			},
			{dataIndex: 'DEPT_CODE'	  			, width: 120,
				'editor': Unilite.popup('DEPT_G', {
//		 					DBtextFieldName: 'DEPT_CODE',
			  		autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
								record = records[0];									
								grdRecord.set('DEPT_CODE'	, record['TREE_CODE']);		
								grdRecord.set('DEPT_NAME'	, record['TREE_NAME']);
							},
							scope: this	
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('hum900ukrGrid1').uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE'	, '');
							grdRecord.set('DEPT_NAME'	, '');
						},
						applyextparam: function(popup){
							
						}									
					}
				})
			},
			{dataIndex: 'DEPT_NAME'	  			, width: 120,
				'editor': Unilite.popup('DEPT_G', {
//		 					DBtextFieldName: 'DEPT_CODE',
			  		autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
								record = records[0];								
								grdRecord.set('DEPT_CODE'	, record['TREE_CODE']);	
								grdRecord.set('DEPT_NAME'	, record['TREE_NAME']);
							},
							scope: this	
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('hum900ukrGrid1').uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE'	, '');	
							grdRecord.set('DEPT_NAME'	, '');
						},
						applyextparam: function(popup){
							
						}									
					}
				})
			},
			{dataIndex: 'SEQ'					, width: 80},
			{dataIndex: 'OUT_FROM_DATE'			, width: 100},
			{dataIndex: 'OUT_TO_DATE'		 	, width: 100},
			{dataIndex: 'BUSINESS_GUBUN'		, width: 110},
			{dataIndex: 'NATION'				, width: 110},
			{dataIndex: 'CITY'					, width: 110},
			{dataIndex: 'PURPOSE'				, width: 250},
			{dataIndex: 'REMARK'				, width: 200}
		], 
		listeners: {
	  		beforeedit  : function( editor, e, eOpts ) {
	      		if(e.record.phantom){
		  			if (UniUtils.indexOf(e.field, ['DEPT_NAME', 'DEPT_CODE', 'SEQ'])){
						return false;
					}
					
				} else {
	      			if (UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME', 'DEPT_NAME', 'DEPT_CODE', 'BUSINESS_GUBUN', 'OUT_FROM_DATE', 'SEQ'])){
						return false;
					}
				}
	  		}
		}
	});//End of var masterGrid = Unilite.createGr100id('hum900ukrGrid1', {	
			
	
	
	
	Unilite.Main( {
		id			: 'hum900ukrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: {type: 'vbox', align: 'stretch'},
			border	: false,
			items	: [
				panelResult, masterGrid 
			]
		}],
		
		fnInitBinding: function() {
			//초기값 설정
			panelResult.setValue('OUT_FROM_MONTH'	, UniDate.get('startOfMonth'));
			panelResult.setValue('OUT_TO_MONTH'		, UniDate.get('today'));

			//버튼 설정
			UniAppManager.setToolbarButtons(['newData']			, true);
			UniAppManager.setToolbarButtons(['reset', 'save']	, false);

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('OUT_FROM_MONTH');
		},
		
		onQueryButtonDown: function() {
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			/*var record = {};
			masterGrid.createRow(record, null, masterGrid.getStore().getCount()-1);*/
			
		
            
            var r = {
                BUSINESS_GUBUN:          "2"
            };
            masterGrid.createRow(r);
            
			UniAppManager.setToolbarButtons('reset', true);
		},
		
		onSaveDataButtonDown : function() {
			masterGrid.getStore().saveStore();
		},
		
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		
		onResetButtonDown : function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
	});//End of Unilite.Main( {
};
</script>
