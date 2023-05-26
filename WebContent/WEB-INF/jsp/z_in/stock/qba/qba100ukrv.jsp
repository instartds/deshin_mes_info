<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<t:appConfig pgmId="qba100ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B001" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /><!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
</t:appConfig>
<script type="text/javascript">

function appMain(){
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('qba100ukrvMaterModel',{
		fields: [
			{name: 'TEST_CODE'		,text: '시험항목코드'	,type: 'string' ,allowBlank:false},
			{name: 'TEST_NAME'		,text: '시험항목명'	,type: 'string' ,allowBlank:false},
			{name: 'TEST_COND'		,text: '시험기준'		,type: 'string'},
			{name: 'TEST_COND_FROM'	,text: 'FROM'		,type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'TEST_COND_TO'	,text: 'TO'			,type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'TEST_RESULT'	,text: '시험결과'		,type: 'string'},
			{name: 'TEST_UNIT'		,text: '단위'			,type: 'string', comboType:'AU', comboCode:'B013'},
			{name: 'TEST_LOC'		,text: '시험장소'		,type: 'string'},
			{name: 'TEST_PRSN'		,text: '시험자'		,type: 'string'},
			{name: 'SEQ'			,text: '정렬'			,type: 'int'},
			{name: 'USE_YN'			,text: '사용여부' 		,type: 'string', comboType:'AU', comboCode:'A004', defaultValue:'Y'},
			{name: 'REMARK'			,text: '비고'			,type: 'string'}
		]
	});



	/** directProxy 정의 (Service 정의)
	 * @type 
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read	: 'qba100ukrvService.selectList'
			,update	: 'qba100ukrvService.updateMulti'
			,create	: 'qba100ukrvService.insertMulti'
			,destroy: 'qba100ukrvService.deleteMulti'
			,syncAll: 'qba100ukrvService.saveAll'
		}
	});



	/** directMasterStore 정의 
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('qba100ukrvMasterStore',{
		model  : 'qba100ukrvMaterModel',
		autoLoad : false,
		proxy: directProxy,
		uniOpt :{
				isMaster	: true,		// 상위 버튼 연결
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
		}
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		,saveStore : function()	{				
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
			{fieldLabel: '시험항목코드',
			 name: 'TEST_CODE'
			 },
			{fieldLabel: '항목명',
			 name: 'TEST_NAME'	 
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
			{dataIndex:'TEST_CODE'		,width:105 ,align:'center'},
			{dataIndex:'TEST_NAME'		,width:200},
			{dataIndex:'TEST_COND'		,width:200},
			{dataIndex:'TEST_COND_FROM'	,width:90},
			{dataIndex:'TEST_COND_TO'	,width:90},
			{dataIndex:'TEST_RESULT'	,width:200},
			{dataIndex:'TEST_UNIT'		,width:105},
			{dataIndex:'TEST_LOC'		,width:200},
			{dataIndex:'TEST_PRSN'		,width:70},
			{dataIndex:'SEQ'			,width:50 ,align:'center'},
			{dataIndex:'USE_YN'		,width:70 ,align:'center'},
			{dataIndex:'REMARK'		,width:300}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom){
					if(UniUtils.indexOf(e.field, ['TEST_CODE'])){
					return true;
					}
				}else if(UniUtils.indexOf(e.field, ['TEST_CODE'])){
					return false;
				}
			}
		}
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
		this.onQueryButtonDown();
	},
	onNewDataButtonDown : function()	{
	 var seq = masterGrid.getStore().max('SEQ');
	 var div = panelResult.getValue('DIV_CODE');
		 if(!seq) seq = 1;
		 else  seq += 1;
		param = {'SEQ':seq,'DIV_CODE':div}

		masterGrid.createRow(param);
		UniAppManager.setToolbarButtons(['save'],true);
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
			/*  case "USE_YN" :
				if(newValue == 'Y'){
					break;
				}else if(newValue == 'N'){
					break;
				}else if(newValue == 'y'){
					record.set('USE_YN','Y');
					break;					
				}else if(newValue == 'n'){
					record.set('USE_YN','N');
					break;
				}
					rv = Msg.sMBC04 */
			}
			return rv;
		}
	});
};
</script>