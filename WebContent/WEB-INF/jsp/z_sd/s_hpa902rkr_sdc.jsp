<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_hpa902rkr_sdc"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H032" opts= '1;2;5;6;8;9'/> <!-- 지급구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 -->
		<t:ExtComboStore comboType="CBM600" comboCode="0"/> <!--  Cost Pool --> 
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
		<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden:true,
		items: [{
			xtype: 'radiogroup',		            		
			fieldLabel: '출력선택',						            		
			itemId: 'RADIO4',
			labelWidth: 90,
			items: [{
				boxLabel: '부서별지급대장', 
				width: 120, 
				name: 'STRTYPE',
				inputValue: '1',
				checked: true  
			},{
				boxLabel: '부서별집계표', 
				width: 110, 
				name: 'STRTYPE',
				inputValue: '2'
			},{
				boxLabel: '사업장별지급대장', 
				width: 140, 
				name: 'STRTYPE',
				inputValue: '3'
			},{
				boxLabel: '급여명세서', 
				width: 100, 
				name: 'STRTYPE',
				inputValue: '4'
			},{
				boxLabel: '급여명세서(1/2)', 
				width: 150, 
				name: 'STRTYPE',
				inputValue: '5'
			}]
		},{
			fieldLabel: '',
			name: 'CONTAIN_ZERO',
			xtype: 'checkbox',
			labelWidth: 200,
			boxLabel: '&nbsp;급여가 0인 금액포함'
		}]
	});	

	var panelResult2 = Unilite.createSearchForm('resultForm2',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'center',
		layout : {type : 'uniTable', columns : 1 },
		padding:'1 1 1 1',
		border:true,
		flex: 1,
		items: [{
			fieldLabel: '지급년월', 
			name: 'PAY_YYYYMM',
			xtype: 'uniMonthfield',
			value: UniDate.get('today'),
			allowBlank: false
		},{
			fieldLabel: '지급구분',
			name:'SUPP_TYPE', 	
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode:'H032',
			value: '1',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//alert(newValue);
					if (newValue == '1'){
						Ext.getCmp('printGubun').enable();
					}else{
						Ext.getCmp('printGubun').disable();
					}
				},
				beforequery:function(queryPlan, eOpts){
					var store = queryPlan.combo.store.data.items;
					Ext.each(store, function(record, i) {
						if(record.data.value == '2') {
							record.data.text = '기타복리후생비';
						}
					})
				}
			}
		},{
			xtype: 'radiogroup',                            
			fieldLabel: '직급보조,급식,효도휴가비 출력',
			id:'printGubun',
			hidden: true,
			items: [{
				boxLabel: '한다', 
				width: 50, 
				name: 'rdoSelect',
				inputValue: 'Y',
				checked: true
			},{
				boxLabel : '안한다', 
				width: 60,
				name: 'rdoSelect',
				inputValue: 'N' 
			}]
		},{
			xtype: 'radiogroup',                            
			fieldLabel: '출력구분',
			id:'printType',
			items: [{
				boxLabel: '급/상여대장', 
				width: 100,
				name: 'rdoPrintType',
				inputValue: '1',
				checked: true
			},{
				boxLabel : '간략보고서', 
				width: 100,
				name: 'rdoPrintType',
				inputValue: '2' 
			}]
		},{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			comboCode	: 'BILL'
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT_FR',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth: 159,
			validateBlank:true,
			autoPopup:true
		}),
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '~',
			valueFieldName:'DEPT_TO',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth: 159,
			validateBlank:true,
			autoPopup:true
		}),{
			fieldLabel: '급여지급방식',
			name:'PAY_CODE', 	
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H028'
		},{
			fieldLabel: '지급일',
			xtype: 'uniDatefield',
			name: 'SUPP_DATE',
			hidden:true
		},{
			fieldLabel: '지급차수',
			name:'PAY_DAY_FLAG', 	
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H031'
		},{
			fieldLabel: '고용형태',
			name:'PAY_GUBUN', 	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'H011'
		},{
			fieldLabel: '사원구분',
			name:'EMPLOY_TYPE', 	
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H024'
		},{
			fieldLabel: '사원그룹',
			name:'PERSON_GROUP', 	
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H181'
		},{
			fieldLabel: 'Cost Pool',
			name:'COST_KIND', 	
			xtype: 'uniCombobox',
			//comboType:'CBM600',
			//comboCode:'0'
			store: Ext.data.StoreManager.lookup('getHumanCostPool')
		},{
			fieldLabel: '직렬',
			name:'AFFIL_CODE', 	
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'H173'
		},
		Unilite.popup('Employee',{
			fieldLabel: '사원',
			valueFieldName:'PERSON_NUMB',
			textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true
		}),{
			fieldLabel: '적요사항',
			xtype: 'textareafield',
			name: 'REMARK',
			height : 40,
			width: 325
		},{
			xtype:'button',
			text:'출    력',
			width:235,
			tdAttrs:{'align':'center', style:'padding-left:95px'},
			handler:function()	{
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hpa902rkr_sdcModelSupply', {
		fields: [
			{name: 'CHOICE'			, text: '표기'		, type: 'bool'},
			{name: 'WAGES_CODE'		, text: '지급코드'		, type: 'string'},
			{name: 'WAGES_NAME'		, text: '지급내역'		, type: 'string'}
		]
	});

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hpa902rkr_sdcModelDeduct', {
		fields: [
			{name: 'CHOICE'			, text: '표기'		, type: 'bool'},
			{name: 'DEDUCT_CODE'	, text: '공제코드'		, type: 'string'},
			{name: 'DEDUCT_NAME'	, text: '공제내역'		, type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directStoreSupply = Unilite.createStore('s_hpa902rkr_sdcStoreSupply',{
		model: 's_hpa902rkr_sdcModelSupply',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy   : {
			type: 'uniDirect',
			api: {
				read   : 's_hpa902rkr_sdcService.selectSupplyList',
				update : 's_hpa902rkr_sdcService.updateSupplyList',
				syncAll: 's_hpa902rkr_sdcService.syncSupplyList'
			}
		},
		loadStoreRecords: function(bSetCurrMonthYn) {
			var param = Ext.getCmp('resultForm2').getValues();
			
			param.SET_CURR_MONTH_YN = (bSetCurrMonthYn ? 'Y' : 'N');
			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()  {
			var inValidRecs = this.getInvalidRecords();
			var toUpdate = this.getUpdatedRecords();
			
			var paramMaster = Ext.getCmp('resultForm2').getValues();
			
			if(inValidRecs.length == 0 )    {
				config = {
					params  : [paramMaster],
					success : function(batch, option) {
						//panelResult.resetDirtyStatus();
						//UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				gridSupply.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directStoreDeduct = Unilite.createStore('s_hpa902rkr_sdcStoreDeduct',{
		model: 's_hpa902rkr_sdcModelDeduct',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy   : {
			type: 'uniDirect',
			api: {
				read   : 's_hpa902rkr_sdcService.selectDeductList',
				update : 's_hpa902rkr_sdcService.updateDeductList',
				syncAll: 's_hpa902rkr_sdcService.syncDeductList'
			}
		},
		loadStoreRecords: function(bSetCurrMonthYn) {
			var param = Ext.getCmp('resultForm2').getValues();
			
			param.SET_CURR_MONTH_YN = (bSetCurrMonthYn ? 'Y' : 'N');
			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()  {
			var inValidRecs = this.getInvalidRecords();
			var toUpdate = this.getUpdatedRecords();
			
			var paramMaster = Ext.getCmp('resultForm2').getValues();
			
			if(inValidRecs.length == 0 )    {
				config = {
					params  : [paramMaster],
					success : function(batch, option) {
						//panelResult.resetDirtyStatus();
						//UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				gridDeduct.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var gridSupply = Unilite.createGrid('s_hpa902rkr_sdcGridSupply', {
		title: '지급항목',
		layout: 'fit',
		region: 'east',
		flex: 1,
		uniOpt: {
        	expandLastColumn: true,
			useRowNumberer: true,
			useMultipleSorting: true
		},
		tbar  : [{
			text    : '지급항목저장',
			id  	: 'btnSyncSupply',
			width   : 120,
			handler : function() {
				var store = Ext.getStore('s_hpa902rkr_sdcStoreSupply');
				
				if(store.isDirty())
					store.saveStore();
			}
		},{
			text    : '해당월 지급항목',
			id  	: 'btnGetSupplyList',
			width   : 120,
			handler : function() {
				var store = Ext.getStore('s_hpa902rkr_sdcStoreSupply');
				store.loadStoreRecords(true);
			}
		}],
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		store: directStoreSupply,
		columns: [
			{dataIndex: 'CHOICE'		, width:  60	, xtype:'checkcolumn'},
			{dataIndex: 'WAGES_CODE'	, width: 100},
			{dataIndex: 'WAGES_NAME'	, width: 200}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				var bCheck = record.get('CHOICE');
				bCheck = !bCheck;
				
				record.set('CHOICE', bCheck);
			}
		}
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var gridDeduct = Unilite.createGrid('s_hpa902rkr_sdcGridDeduct', {
		title: '공제항목',
		layout: 'fit',
		region: 'east',
		flex: 1,
		uniOpt: {
        	expandLastColumn: true,
			useRowNumberer: true,
			useMultipleSorting: true
		},
		tbar  : [{
			text    : '공제항목저장',
			id  	: 'btnSyncDeduct',
			width   : 120,
			handler : function() {
				var store = Ext.getStore('s_hpa902rkr_sdcStoreDeduct');
				
				if(store.isDirty())
					store.saveStore();
			}
		},{
			text    : '해당월 공제항목',
			id  	: 'btnGetDeductList',
			width   : 120,
			handler : function() {
				var store = Ext.getStore('s_hpa902rkr_sdcStoreDeduct');
				store.loadStoreRecords(true);
			}
		}],
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		store: directStoreDeduct,
		columns: [
			{dataIndex: 'CHOICE'		, width:  60	, xtype:'checkcolumn'},
			{dataIndex: 'DEDUCT_CODE'	, width: 100},
			{dataIndex: 'DEDUCT_NAME'	, width: 200}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				var bCheck = record.get('CHOICE');
				bCheck = !bCheck;
				
				record.set('CHOICE', bCheck);
			}
		}
	});
	
	Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult2, gridSupply, gridDeduct
			]	
		}		
		], 
		id: 's_hpa902rkr_sdcApp',
		fnInitBinding : function() {
			panelResult2.setValue('DIV_CODE',UserInfo.divCode);
			
			UniAppManager.setToolbarButtons(['query','reset','save'],false);
			
			directStoreSupply.loadStoreRecords(false);
			directStoreDeduct.loadStoreRecords(false);
		},
		onQueryButtonDown : function()	{
		},
		onResetButtonDown: function() {
		},
		
/*		onPrintButtonDown: function() {
            var param = Ext.getCmp('resultForm2').getValues();
            var param2 = Ext.getCmp('resultForm').getValues();

            
            for(var attr in param2)
                param[attr]=param2[attr];  
            if(param['CONTAIN_ZERO'] == null)
                param['CONTAIN_ZERO'] = 'off';
            var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/hpa/hpa901rkrPrint.do',
                prgID: 'hpa901rkr',
                extParam: param
            });
            win.center();
            win.show();                 
        }*/
        
		onPrintButtonDown: function() {
			var param  = Ext.getCmp('resultForm2').getValues();
			var printType = Ext.getCmp('printType').getChecked()[0].inputValue;
			var maxSupCnt = 30;
			var maxDedCnt = 20;
			
            var supplyList = Ext.getStore('s_hpa902rkr_sdcStoreSupply').getData();
            var supplyItems = '';
            supplyList.each(function(record, index) {
            	if(record.get('CHOICE'))
            		supplyItems += record.get('WAGES_CODE') + '|';
            });
            
            var deductList = Ext.getStore('s_hpa902rkr_sdcStoreDeduct').getData();
            var deductItems = '';
            deductList.each(function(record, index) {
            	if(record.get('CHOICE'))
            		deductItems += record.get('DEDUCT_CODE') + '|';
            });
            
            if(printType == '2') {
            	maxSupCnt = 20;
            	maxDedCnt = 0;
            }
            
			param.PRINT_TYPE = printType;
			param.SUP_LIST_MAX = maxSupCnt;
			param.SUP_LIST = supplyItems;
			param.DED_LIST_MAX = maxDedCnt;
			param.DED_LIST = deductItems;
			
            param.PGM_ID = 's_hpa902rkr_sdc';  //프로그램ID
            param.sTxtValue2_fileTitle = '급여대장';
            
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/human/s_hpa902clrkrv_sdc.do',
				prgID: 's_hpa902rkr_sdc',
				extParam: param
			});
            win.center();
            win.show();
		}
	}); //End of
};

</script>
