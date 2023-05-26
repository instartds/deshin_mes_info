<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<t:appConfig pgmId="qba120ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B001" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /><!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
	<t:ExtComboStore items="${COMBO_TEST_GROUP}" storeId="COMBO_TEST_GROUP" /><!-- 대분류 -->
	<t:ExtComboStore items="${COMBO_TEST_CODE}" storeId="COMBO_TEST_CODE" /><!-- 시험항목 -->
	<t:ExtComboStore items="${COMBO_TEST_CODE}" storeId="COMBO_TEST_CODE2" /><!-- 시험항목 -->

</t:appConfig>
<script type="text/javascript">
function appMain(){

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('qba120ukrvMaterModel',{
		fields: [
			{name: 'TEST_GROUP'		,text:'대분류'	,type: 'string' ,store: Ext.data.StoreManager.lookup('COMBO_TEST_GROUP') ,allowBlank: false},
			{name: 'TEST_GROUP2'	,text:'품목계정'	,type: 'string' , comboType:'AU', comboCode:'B020' ,allowBlank: false},
			{name: 'TEST_CODE'		,text:'시험항목'	,type: 'string' ,store: Ext.data.StoreManager.lookup('COMBO_TEST_CODE') ,allowBlank: false},
			{name: 'NAME'			,text:'항목코드'	,type: 'string'},
			{name: 'COND'			,text:'시험기준'	,type: 'string'},
			//20190424 추가 (TEST_COND_FROM, TEST_COND_TO)
			{name: 'TEST_COND_FROM'	,text: 'FROM'	,type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'TEST_COND_TO'	,text: 'TO'		,type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'UNIT'			,text:'단위'		,type: 'string'},
			{name: 'LOC'			,text:'시험장소'	,type: 'string'},
			{name: 'SEQ'			,text:'정렬순서'	,type: 'int'	},
			{name: 'REMARK'			,text:'비고'		,type: 'string'},
			{name: 'DIV_CODE'		,text:'사업장번호' ,type: 'string'}
		]
	});



	/** directProxy 정의 (Service 정의)
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'qba120ukrvService.selectList',
			update	: 'qba120ukrvService.updateMulti',
			create	: 'qba120ukrvService.insertMulti',
			destroy	: 'qba120ukrvService.deleteMulti',
			syncAll	: 'qba120ukrvService.saveAll'
		}
	});



	/** directMasterStore 정의
	 * @type
	 */
	var directMasterStore = Unilite.createStore('qba120ukrvMasterStore',{
		model  : 'qba120ukrvMaterModel',
		autoLoad : false,
		proxy: directProxy,
		uniOpt :{
				isMaster	: true,			// 상위 버튼 연결
				editable	: true,			// 수정 모드 사용
				deletable	: true,			// 삭제 가능 여부
				useNavi		: false			// prev | newxt 버튼 사용
		},
		// Store 관련 BL 로직
		// 검색 조건을 통해 DB에서 데이타 읽어 오기
		loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				//this.syncAll({});
				this.syncAllDirect();
			}else {
				var grid = Ext.getCmp('masterGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		layout : {type : 'uniTable' , columns: 3 },
		items: [
			{fieldLabel: '사업장',
			 xtype: 'uniCombobox',
			 name: 'DIV_CODE',
			 comboType: 'AU',
			 comboCode: 'B001',
			 allowBlank: false,
			 value: UserInfo.divCode
			},
			{fieldLabel: '대분류',
			 xtype: 'uniCombobox',
			 name: 'TEST_GROUP',
			 store: Ext.data.StoreManager.lookup('COMBO_TEST_GROUP')
			 }
			]
	});



	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		store: directMasterStore,
		uniOpt: {
			useRowNumberer: false
		},
		columns:[
			{dataIndex:'TEST_GROUP'		,width:100 },
			{dataIndex:'TEST_GROUP2'	,width:100 },
			{dataIndex:'TEST_CODE'		,width:150,
				listeners:{
					render:function(elm)	{
						var tGrid = elm.getView().ownerGrid;
						elm.editor.on('beforequery',function(queryPlan, eOpts)  {
							var store = queryPlan.combo.store;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == panelResult.getValue('DIV_CODE');
							});
	
						})
					}
				}
			},
			{dataIndex:'NAME'			,width:100 },
			{dataIndex:'COND'			,width:150 },
			//20190424 추가 (TEST_COND_FROM, TEST_COND_TO)
			{dataIndex:'TEST_COND_FROM'	,width:90 },
			{dataIndex:'TEST_COND_TO'	,width:90 },
			{dataIndex:'UNIT'			,width:100, align:'center'},
			{dataIndex:'LOC'			,width:170 },
			{dataIndex:'SEQ'			,width:100, align:'center' },
			{dataIndex:'REMARK'			,width:250 }
//	 		{dataIndex:'DIV_CODE'		,width:100 }
			],
	listeners: {
		beforeedit: function( editor, e, eOpts ){			
			if(e.record.phantom){
				 if(UniUtils.indexOf(e.field, [ 'NAME', 'COND', 'UNIT', 'LOC', 'REMARK',
												//20190424 추가
				 								'TEST_COND_FROM', 'TEST_COND_TO'
				 					])){
					 return false;
				 }
			} else if(UniUtils.indexOf(e.field, ['TEST_GROUP', 'TEST_CODE', 'NAME', 'COND', 'UNIT', 'LOC', 'REMARK',
												//20190424 추가
				 								'TEST_COND_FROM', 'TEST_COND_TO'
				 					])){
				return false;
  			}
		}		
 }
//		{name: 'TEST_GROUP'  ,text:'대분류'	 ,type: 'string' ,store: Ext.data.StoreManager.lookup('bpr300ukrvLevel1Store')},
//		 {name: 'TEST_CODE'	,text:'시험항목'	,type: 'string'	},
//		 {name: 'TEST_NAME'	,text:'항목명'	 ,type: 'string'	},
//		 {name: 'TEST_COND'	,text:'시험기준'	,type: 'string'	},
//		 {name: 'TEST_UNIT'	,text:'단위'		,type: 'string'	},
//		 {name: 'TEST_LOC'	,text:'시험장소'	,type: 'string'	},
//		 {name: 'SEQ'		 ,text:'정렬순서'	,type: 'int'		},
//		 {name: 'REMARK'	  ,text:'비고'		,type: 'string'	}

	 });

	Unilite.Main({
		items : [panelResult, masterGrid],
	fnInitBinding : function() {
		UniAppManager.setToolbarButtons(['reset','newData'],true);
	},
	onQueryButtonDown : function() {
		directMasterStore.loadStoreRecords();
	},
	onSaveAndQueryButtonDown : function()	{
		this.onSaveDataButtonDown();
	},
	onNewDataButtonDown : function()	{
	 var seq = 1;
	 var div = panelResult.getValue('DIV_CODE');
		param = {'SEQ':seq, 'DIV_CODE':div}
		masterGrid.createRow(param);
	},
	onSaveDataButtonDown: function () {
		var masterGrid = Ext.getCmp('masterGrid');
		directMasterStore.saveStore();
	},
	onDeleteDataButtonDown : function()	{
		masterGrid.deleteSelectedRow();
		UniAppManager.setToolbarButtons(['save'],true);
	},
	onResetButtonDown:function() {
		var masterGrid = Ext.getCmp('masterGrid');
		Ext.getCmp('resultForm').getForm().reset();
		masterGrid.getStore().loadData({});
		UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
	}
	});

	Unilite.createValidator('validator01',{
		store: directMasterStore,
		grid: masterGrid,

		validate: function(type, fieldName, newValue, oldValue, record, eopt, editor, e){
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
		var rv = true;
		switch(fieldName){
		  case "TEST_CODE" :
				var COMBO_TEST_CODE = Ext.data.StoreManager.lookup('COMBO_TEST_CODE2');// TEST_CODE COMBO STORID 가져오기
				Ext.each(COMBO_TEST_CODE.data.items, function(comboData, jdx) {
					if(comboData.get("value") == newValue){
						record.set('NAME', comboData.get('value'))
						record.set('COND', comboData.get('refCode1'))
						record.set('UNIT', comboData.get('refCode2'))
						record.set('LOC', comboData.get('refCode3'))
						record.set('REMARK', comboData.get('refCode4'))
					}
				});
				break;
		}
		return rv;
	}
});
};
</script>