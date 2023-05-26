<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="s_bmd100ukrv_mek"  >
	<t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="ZP01" />

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 	's_bmd100ukrv_mekService.selectList',
			update: 's_bmd100ukrv_mekService.updateDetail',			//수정
			create: 's_bmd100ukrv_mekService.insertDetail',
			destroy:'s_bmd100ukrv_mekService.deleteDetail',		    //삭제
			syncAll:'s_bmd100ukrv_mekService.saveAll'				//저장
		}
	});
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('s_bmd100ukrv_mekModel', {
		fields: [
			{name: 'MODEL_ID'		, text: '모델식별'				, type: 'string'	,allowBlank: false	,comboType: 'AU',	comboCode: 'ZP01'},
			{name: 'MODEL_NAME'		, text: '모델명'				, type: 'string'	,allowBlank: false},
			{name: 'MODEL_CODE'		, text: '모델코드'				, type: 'string'	,allowBlank: false},
			{name: 'MODEL_UNI_CODE'	, text: '모델고유식별코드'			, type: 'string'	,allowBlank: false},
			{name: 'PRODUCT_CODE'	, text: '제품코드'				, type: 'string'}
		]
	});
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore = Unilite.createStore('s_bmd100ukrv_mekMasterStore',{
		model: 's_bmd100ukrv_mekModel',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결 
			editable: true,         // 수정 모드 사용 
			deletable:true,         // 삭제 가능 여부 
			useNavi : false         // prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();		//필수값 입력여부 체크
			if(inValidRecs.length == 0 ) {
				var config = {
					params:[panelResult.getValues()],		//조회조건 param
					success : function() {					//저장후 실행될 로직
						
					}
				}
				this.syncAllDirect(config);			//저장 로직 실행	
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);	//에러 발생
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('s_bmd100ukrv_mekMasterStore1',{

   /**
    * 검색조건 (Search Panel)
    * @type 
    */
	
	
	 var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				name: 'MODEL_ID',
				fieldLabel:'모델식별',
				xtype:'uniCombobox'	,
				comboType:'AU',
				comboCode:'ZP01',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						
					}
				}
 			}
 		]
	});
	/**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('s_bmd100ukrv_mekGrid1', {   
		layout: 'fit',
		region:'center',
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: false,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		}, 
		store: directMasterStore,
		columns: [
			{dataIndex: 'MODEL_ID'			, width:140},
			{dataIndex: 'MODEL_NAME'		, width:200},
			{dataIndex: 'MODEL_CODE'		, width:140},
			{dataIndex: 'PRODUCT_CODE'		, width:130},
			{dataIndex: 'MODEL_UNI_CODE'	, width:180}
			
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom == true) { // 신규가 아닐 때
					if(UniUtils.indexOf(e.field, ['MODEL_ID', 'MODEL_CODE', 'MODEL_UNI_CODE'])) {
						return false;
					}
				}
				if(!e.record.phantom == false) {
					if(UniUtils.indexOf(e.field, ['MODEL_ID', 'MODEL_NAME', 'MODEL_CODE','PRODUCT_CODE'])) {
						return true;
					}
					else {
						return false;
					}
				}
			}
		}
	});//End of var masterGrid = Unilite.createGrid('s_bmd100ukrv_mekGrid1', {   

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}],	
		id: 's_bmd100ukrv_mekApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
		},
		onQueryButtonDown: function() {
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {				// 초기화
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function() {	//삭제버튼 클릭시	
			var selRow = masterGrid.getSelectedRecord();
			if (selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else if (confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function () {	//저장버튼 클릭시
			directMasterStore.saveStore();
		},
		onNewDataButtonDown : function() {
			var record = {
				MODEL_ID		: panelResult.getValue('MODEL_ID'),
				MODEL_NAME		: panelResult.getValue('MODEL_NAME'),
				MODEL_CODE		: panelResult.getValue('MODEL_CODE'),
				MODEL_UNI_CODE	: panelResult.getValue('MODEL_UNI_CODE')
			};
			masterGrid.createRow(record, null, masterGrid.getStore().getCount()-1);
			UniAppManager.setToolbarButtons('reset', true);
		}
	});//End of Unilite.Main( {
	
	var validation = Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e ) {
			if (newValue == oldValue) {
				return false;
			}
			var rv = true;
			switch (fieldName) {
				case "MODEL_ID" :
					record.set('MODEL_UNI_CODE', newValue + record.get('MODEL_CODE'));
					break;
				case "MODEL_CODE" :
					record.set('MODEL_UNI_CODE', record.get('MODEL_ID') + newValue);
					break;
			}
		return rv;
		}
	})
};


</script>