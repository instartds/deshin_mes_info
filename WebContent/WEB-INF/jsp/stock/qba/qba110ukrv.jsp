<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<t:appConfig pgmId="qba110ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B001" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /><!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
</t:appConfig>
<script type="text/javascript">

function appMain(){
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('qba110ukrvMaterModel',{
		fields: [
			{name: 'TEST_CODE'		,text: '시험항목코드'					,type: 'string' ,allowBlank:false},
			{name: 'TEST_NAME'		,text: '시험항목명'					,type: 'string' ,allowBlank:false},
			{name: 'TEST_NAME_ENG'	,text: '시험항목명_영문'				,type: 'string' ,allowBlank:true},
			{name: 'TEST_COND'		,text: '시험기준'					,type: 'string'},
			{name: 'TEST_COND_ENG'	,text: '시험기준_영문'				,type: 'string'},
			{name: 'TEST_COND_FROM'	,text: 'FROM<br/>(하한값)'			,type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'TEST_COND_TO'	,text: 'TO<br/>(상한값)'			,type: 'float' , decimalPrecision: 2 , format:'0,000.00'},
			{name: 'TEST_RESULT'	,text: '시험결과'					,type: 'string'},
			{name: 'TEST_UNIT'		,text: '단위'						,type: 'string', comboType:'AU', comboCode:'B013'},
			{name: 'TEST_LOC'		,text: '시험장소'					,type: 'string'},
			{name: 'TEST_PRSN'		,text: '시험자'					,type: 'string'},
			{name: 'SEQ'			,text: '정렬'						,type: 'int'},
			{name: 'USE_YN'			,text: '사용여부' 					,type: 'string', comboType:'AU', comboCode:'A004', defaultValue:'Y'},
			{name: 'REMARK'			,text: '비고'						,type: 'string'},
			{name: 'TEST_METH'		,text: '검사방법'					,type: 'string'},
			{name: 'VALUE_TYPE'		,text: '검사값구분'					,type: 'string', comboType:'AU', comboCode:'Q042', defaultValue:'1'},
			{name: 'VALUE_POINT'	,text: '소수점'					,type: 'int', maxLength: 1},
			{name: 'TEST_VALUE'		,text: '검사값<br/>(기준값)'			,type: 'float', decimalPrecision: 2 , format:'0,000.00'}
		]
	});



	/** directProxy 정의 (Service 정의)
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read	: 'qba110ukrvService.selectList'
			,update	: 'qba110ukrvService.updateMulti'
			,create	: 'qba110ukrvService.insertMulti'
			,destroy: 'qba110ukrvService.deleteMulti'
			,syncAll: 'qba110ukrvService.saveAll'
		}
	});



	/** directMasterStore 정의
	 * @type
	 */
	var directMasterStore = Unilite.createStore('qba110ukrvMasterStore',{
		model  : 'qba110ukrvMaterModel',
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
			var param = {	'DIV_CODE' : panelResult.getValue('DIV_CODE') }
			if(inValidRecs.length == 0 )	{
				//this.syncAll({});
				config = {
						 params: [param]
				}
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
			{dataIndex:'TEST_NAME_ENG'	,width:200},
			{dataIndex:'TEST_METH'		,width:100},
			{dataIndex:'TEST_COND'		,width:200},
			{dataIndex:'TEST_COND_ENG'	,width:200},
			{dataIndex:'VALUE_TYPE'		,width:80, align:'center'},
			{dataIndex:'VALUE_POINT'	,width:100},
			{dataIndex:'TEST_COND_FROM'	,width:90,
				renderer: function(value, metaData, record) {
					var formatStyle = '0,000'
					formatStyle = UniAppManager.app.fnFormatStyle(record.get('VALUE_POINT'));
					masterGrid.getColumn("TEST_COND_FROM").config.editor.decimalPrecision = record.get('VALUE_POINT');
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, formatStyle) + '</div>';
                }
			},
			{dataIndex:'TEST_COND_TO'	,width:90,
				renderer: function(value, metaData, record) {
					var formatStyle = '0,000'
					formatStyle = UniAppManager.app.fnFormatStyle(record.get('VALUE_POINT'));
					masterGrid.getColumn("TEST_COND_TO").config.editor.decimalPrecision = record.get('VALUE_POINT');
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, formatStyle) + '</div>';
                }
			},
			{dataIndex:'TEST_VALUE'		,width:100,
				renderer: function(value, metaData, record) {
					var formatStyle = '0,000'
					formatStyle = UniAppManager.app.fnFormatStyle(record.get('VALUE_POINT'));
					masterGrid.getColumn("TEST_VALUE").config.editor.decimalPrecision = record.get('VALUE_POINT');
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, formatStyle) + '</div>';
                }
			},
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