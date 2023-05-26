<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hxt100ukr">
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> 		<!-- 사용여부 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'hxt100ukrService.insertList',				
			read	: 'hxt100ukrService.selectList',
			update	: 'hxt100ukrService.updateList',
			destroy	: 'hxt100ukrService.deleteList',
			syncAll	: 'hxt100ukrService.saveAll'
		}
	});
	
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hxt100ukrModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'		 	, type: 'string'},
			{name: 'CAR_NUM'			, text: '차량번호'		 	, type: 'string'	, allowBlank: false},
			{name: 'CAR_TYPE'			, text: '차종'		 	, type: 'string'},
			{name: 'CAR_YEAR'			, text: '연식'		 	, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'		 	, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서명'		 	, type: 'string'},
			{name: 'CAR_INSURANCE'		, text: '보험회사'	 		, type: 'string'},
			{name: 'EXPIRATION_DATE'	, text: '보험만기일'	 	, type: 'uniDate'},
			{name: 'PERIODIC_TEST_DATE'	, text: '정기검사일'		, type: 'uniDate'},
			{name: 'USE_YN'				, text: '사용여부'		 	, type: 'string'	, comboType:'AU', comboCode:'B010'},
			{name: 'REMARK'				, text: '비고'			, type: 'string'}
		]										
	});//End of Unilite.defineModel('hxt100ukrModel', {
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */			
	var masterStore = Unilite.createStore('hxt100ukrMasterStore1', {
		model	: 'hxt100ukrModel',
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
				fieldLabel		: '보험만기일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'EXPIRATION_DATE_FR',
				endFieldName	: 'EXPIRATION_DATE_TO',
//				startDate		: UniDate.get('startOfMonth'),
//				endDate			: UniDate.get('today'),
//				allowBlank		: false,	  	
				tdAttrs			: {width: 350}, 
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},{
				fieldLabel	: '사용여부',
				name		: 'USE_YN', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B010',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
			},{ 
				fieldLabel		: '정기검사일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PERIODIC_TEST_DATE_FR',
				endFieldName	: 'PERIODIC_TEST_DATE_TO',
//				startDate		: UniDate.get('startOfMonth'),
//				endDate			: UniDate.get('today'),  	
				tdAttrs			: {width: 350}, 
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			}
		]
	});
	
		
	
	
	
	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hxt100ukrGrid1', {
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
			{dataIndex: 'CAR_NUM'				, width: 130},
			{dataIndex: 'CAR_TYPE'				, width: 110},
			{dataIndex: 'CAR_YEAR'				, width: 110},
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
							var grdRecord = Ext.getCmp('hxt100ukrGrid1').uniOpt.currentRecord;
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
							var grdRecord = Ext.getCmp('hxt100ukrGrid1').uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE'	, '');	
							grdRecord.set('DEPT_NAME'	, '');
						},
						applyextparam: function(popup){
							
						}									
					}
				})
			},
			{dataIndex: 'CAR_INSURANCE'			, width: 110},
			{dataIndex: 'EXPIRATION_DATE'		, width: 100},
			{dataIndex: 'PERIODIC_TEST_DATE'	, width: 100},
			{dataIndex: 'USE_YN'				, width: 80},
			{dataIndex: 'REMARK'				, width: 250}
		], 
		listeners: {
	  		beforeedit  : function( editor, e, eOpts ) {
	      		if(!e.record.phantom){
		  			if (UniUtils.indexOf(e.field, ['CAR_NUM', 'CAR_TYPE', 'CAR_YEAR'])){
						return false;
					}
				} 
	  		}
		}
	});//End of var masterGrid = Unilite.createGr100id('hxt100ukrGrid1', {	
			
	
	
	
	Unilite.Main( {
		id			: 'hxt100ukrApp',
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
			panelResult.setValue('USE_YN'	, 'Y');
//			panelResult.setValue('EXPIRATION_DATE_FR'	, UniDate.get('startOfMonth'));
//			panelResult.setValue('EXPIRATION_DATE_TO'	, UniDate.get('today'));

			//버튼 설정
			UniAppManager.setToolbarButtons(['newData']			, true);
			UniAppManager.setToolbarButtons(['reset', 'save']	, false);

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('EXPIRATION_DATE_FR');
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
			var record = {};
			masterGrid.createRow(record, null, masterGrid.getStore().getCount()-1);
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
