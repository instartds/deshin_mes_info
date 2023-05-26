<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="laa100ukrv">
	<t:ExtComboStore comboType="AU" comboCode="B001" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /><!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
	<t:ExtComboStore items="${regulation}" storeId="regulation" /> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>	
</t:appConfig>

<script type="text/javascript" >

function appMain(){
	/** directProxy 정의 (Service 정의)
	 * @type 
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'laa100ukrvService.selectList',
			update	: 'laa100ukrvService.updateMulti',
			create	: 'laa100ukrvService.insertMulti',
			destroy	: 'laa100ukrvService.deleteMulti',
			syncAll	: 'laa100ukrvService.saveAll'
		}
	});



	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('laa100ukrvMaterModel',{
		fields: [
			{name: 'COMP_CODE'			,text: '법인코드'		,type: 'string' ,allowBlank:false},		//법인코드'
			{name: 'CHEMICAL_CODE'		,text: '성분코드'		,type: 'string' ,allowBlank:false},		//성분코드'
			{name: 'CHEMICAL_NAME'		,text: '한글명'		,type: 'string' ,allowBlank:false},		//성분명_한글'
			{name: 'CHEMICAL_NAME_EN'	,text: '영문명'		,type: 'string' ,allowBlank:false},		//성분명_영문'
			{name: 'CHEMICAL_NAME_CH'	,text: '중문명'		,type: 'string'},						//성분명_중문'
			{name: 'CHEMICAL_NAME_JP'	,text: '일문명'		,type: 'string'},						//성분명_일문'
			{name: 'CAS_NO'				,text: 'CAS NO'		,type: 'string'},						//CAS NO'
			{name: 'FUNCTION_DESC'		,text: 'Function'	,type: 'string'},						//기능'
			{name: 'CONTROL_CH'			,text: '중국규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_중국'
			{name: 'CONTROL_JP'			,text: '일본규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_일본'
			{name: 'CONTROL_USA'		,text: '미국규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_미국'
			{name: 'CONTROL_ETC1'		,text: '기타1규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_기타1'
			{name: 'CONTROL_ETC2'		,text: '기타2규제'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('regulation')},	//규제_기타2'
			{name: 'CONTROL_ETC3'		,text: '기타3규제'		,type: 'string'},						//규제_기타3'
			{name: 'CONTROL_ETC4'		,text: '기타4규제'		,type: 'string'},						//규제_기타4'
			{name: 'CONTROL_ETC5'		,text: '기타5규제'		,type: 'string'},						//규제_기타5'
			{name: 'REMARK'				,text: '비고'			,type: 'string'}						//비고'
		]
	});



	/** directMasterStore 정의
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('laa100ukrvMasterStore',{
		model  : 'laa100ukrvMaterModel',
		autoLoad : false,
		proxy: directProxy,
		uniOpt :{
				isMaster	: true,		// 상위 버튼 연결
				editable	: true,		// 수정 모드 사용
				deletable	: true,		// 삭제 가능 여부
				useNavi		: false		// prev | newxt 버튼 사용 
		},
		// 검색 조건을 통해 DB에서 데이타 읽어 오기 
		loadStoreRecords : function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
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
		region	: 'north',
		layout	: {type : 'uniTable' , columns: 3 },
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '성분코드/명',
			xtype		: 'uniTextfield',
			name		: 'CHEMICAL_CODE',
			width		: 300
		}]
	});



	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	: {
			useRowNumberer: true
		},
		columns:[
			{dataIndex:'COMP_CODE'			,width:105 ,hidden: true},
			{dataIndex:'CHEMICAL_CODE'		,width:100},
			{dataIndex:'CHEMICAL_NAME_EN'	,width:200},
			{dataIndex:'CHEMICAL_NAME'		,width:200},
			{dataIndex:'CAS_NO'				,width:100},
			{dataIndex:'FUNCTION_DESC'		,width:100},
			{dataIndex:'CHEMICAL_NAME_CH'	,width:200},
			{dataIndex:'CHEMICAL_NAME_JP'	,width:200},
			{dataIndex:'CONTROL_CH'			,width:100},
			{dataIndex:'CONTROL_JP'			,width:100},
			{dataIndex:'CONTROL_USA'		,width:100},
			{dataIndex:'CONTROL_ETC1'		,width:100},
			{dataIndex:'CONTROL_ETC2'		,width:100},
//			{dataIndex:'CONTROL_ETC3'		,width:100},
//			{dataIndex:'CONTROL_ETC4'		,width:100},
//			{dataIndex:'CONTROL_ETC5'		,width:100},
			{dataIndex:'REMARK'				,width:100}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom){
					return true;
				}else if(UniUtils.indexOf(e.field, ['CHEMICAL_CODE'])){
					return false;
				}
			}
		}
	});



	Unilite.Main({
		id			: 'laa100ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [panelResult, masterGrid]
		}],
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
			var compCOde = UserInfo.compCode;
			param = {'COMP_CODE':compCOde}
	
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
		store	: directMasterStore,
		grid	: masterGrid,
		
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