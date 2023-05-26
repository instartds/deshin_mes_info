<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<t:appConfig pgmId="bcm900ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B001" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /><!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" /><!-- 양품/불량구분 -->
	<t:ExtComboStore comboType="AU" comboCode="P701" /><!-- 단말기구분 -->
	<t:ExtComboStore comboType="AU" comboCode="P702" /><!-- 가능여부 -->

</t:appConfig>
<script type="text/javascript">

function appMain(){
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('bcm900ukrvMaterModel',{
		fields: [
				//{name:  'COMP_CODE'			  ,text:   '사업장'          	,type: 'string' ,	allowBlank:false},
				{name:  'DIV_CODE'            ,text:   '공장코드'         	,type: 'string' ,	allowBlank:false},
				{name:  'PPCID'               ,text:   '번호'        		,type: 'int' ,	allowBlank:false},
				{name:  'PPCNAME'             ,text:   '단말기명칭'        	,type: 'string'},
				{name:  'IP'                  ,text:   'IP'            	,type: 'string', 	format:'000.000.000.000'},
				{name:  'SERIALNO'            ,text:   '시리얼번호'        	,type: 'string'},
				{name:  'PPCFLAG'             ,text:   'PPC상태'        	,type: 'string',comboType:'AU', comboCode:'B021', defaultValue:'1'},
				{name:  'PPCERR'              ,text:   'PPC오류'         	,type: 'string'},
				{name:  'PPCLIVE'             ,text:   'PPCLIVE시간'     	,type: 'uniTime', format:'Hi'},
				{name:  'GUBUN'               ,text:   '단말기구분'         	,type: 'string',comboType:'AU', comboCode:'P701', defaultValue:'01'},
				{name:  'NOTE'                ,text:   '비고'            	,type: 'string'},
				{name:  'USEFLAG'             ,text:   '사용여부'          	,type: 'string',comboType:'AU', comboCode:'A004', defaultValue:'Y'},
				{name:  'CONFIGFILENAME'      ,text:   '환경설정파일명'       	,type: 'string'},
				{name:  'CHANGEBUFFERTIMER'   ,text:   '조교대버퍼시간'       ,type: 'uniTime', format:'Hi'},
				{name:  'ROLECD'              ,text:   '메뉴_ROLECD'     	,type: 'string'},
				{name:  'STATUS'              ,text:   '상태'             ,type: 'string',comboType:'AU', comboCode:'B021', defaultValue:'1'},
				{name:  'GROUPID'             ,text:   'GROUPID'        ,type: 'string'},
				{name:  'WORK_SPLIT_FLAG'     ,text:   '자동실적분할대상설비_YN' ,type: 'string',comboType:'AU', comboCode:'A004', defaultValue:'Y'},
				{name:  'CNT_BORD_FLAG'       ,text:   '카운트보드유무'       	,type: 'string',comboType:'AU', comboCode:'P702', defaultValue:'01'},
				{name:  'REMOTEGBN'           ,text:   '원격제어구분'        	,type: 'string',comboType:'AU', comboCode:'P702', defaultValue:'01'},
				{name:  'PPCLIVEEND'          ,text:   'PPCLIVEEND'     ,type: 'uniTime' , format:'Hi'}


		]
	});



	/** directProxy 정의 (Service 정의)
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read	: 'bcm900ukrvService.selectList'
			,update	: 'bcm900ukrvService.updateDetail'
			,create	: 'bcm900ukrvService.insertDetail'
			,destroy: 'bcm900ukrvService.deleteDetail'
			,syncAll: 'bcm900ukrvService.saveAll'
		}
	});



	/** directMasterStore 정의
	 * @type
	 */
	var directMasterStore = Unilite.createStore('bcm900ukrvMasterStore',{
		model  : 'bcm900ukrvMaterModel',
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
			{fieldLabel: '단말기번호',
			 name: 'PPCID'
			 },
			{fieldLabel: '단말기명칭',
			 name: 'PPCNAME'
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

			//{dataIndex: 'COMP_CODE'				, width: 110,hidden: false,comboType:'BOR120'},
			{dataIndex: 'DIV_CODE'          	, width: 80, align: 'center' },
			{dataIndex: 'PPCID'                	, width: 70},
			{dataIndex: 'PPCNAME'               , width: 110},
			{dataIndex: 'IP'                	, width: 110},
			{dataIndex: 'SERIALNO'          	, width: 110},
			{dataIndex: 'PPCFLAG'           	, width: 110, hidden: false, comboType:'B021'},
			{dataIndex: 'PPCERR'            	, width: 110},
			//PPC LIVE시간 //
			{dataIndex: 'PPCLIVE'               , width: 110, align:'center',editor: {
				xtype: 'timefield',
				format: 'H:i',
			//	submitFormat: 'Hi', //i tried with and without this config
				increment: 10}},

			{dataIndex: 'GUBUN'                	, width: 110, hidden: false, comboType:'P701'},
			{dataIndex: 'NOTE'                  , width: 110},
			{dataIndex: 'USEFLAG'             	, width: 110, hidden: false,comboType:'A004'},
			{dataIndex: 'CONFIGFILENAME'      	, width: 110},

			//조교대버퍼시간 //
			{dataIndex: 'CHANGEBUFFERTIMER'     , width: 90, align:'center',editor: {
				xtype: 'timefield',
				format: 'H:i',
			//	submitFormat: 'Hi', //i tried with and without this config
				increment: 10}},

			{dataIndex: 'ROLECD'              	, width: 110},
			{dataIndex: 'STATUS'              	, width: 110, hidden: false,comboType:'B021'},
			{dataIndex: 'GROUPID'             	, width: 110},
			{dataIndex: 'WORK_SPLIT_FLAG'     	, width: 110, hidden: false,comboType:'A004'},
			{dataIndex: 'CNT_BORD_FLAG'       	, width: 110, hidden: false,comboType:'P702'},
			{dataIndex: 'REMOTEGBN'             , width: 110, hidden: false,comboType:'P702'},
			//PPC LIVE 종료시간 //
			{dataIndex: 'PPCLIVEEND'     , width: 90, align:'center',editor: {
				xtype: 'timefield',
				format: 'H:i',
			//	submitFormat: 'Hi', //i tried with and without this config
				increment: 10}}
		],
		listeners: {
	/*			beforeedit현재는 필요 없음(masterStore에서 uniOpt에 editable:	false처리 해 놓았음	*/
	  			beforeedit: function( editor, e, eOpts ) {
					if (UniUtils.indexOf(e.field,
						['DIV_CODE','PPCID']))
					return false;
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
	 var seq = masterGrid.getStore().max('PPCID');
	 var div = panelResult.getValue('DIV_CODE');
		 if(!seq) seq = 1;
		 else  seq += 1;
		 var param = {DIV_CODE:panelResult.getValue("DIV_CODE")
	     			 ,PPCID:seq
				 };
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
			formatStyle = '0';
    	}else if(value == 2){
    		formatStyle = '00';
    	}else if(value == 3){
    		formatStyle = '.000';
    	}else if(value == 4){
    		formatStyle = '0.000';
    	}else if(value == 5){
    		formatStyle = '00.000';
    	}else if(value == 6){
    		formatStyle = '000.000';
    	}else if(value == 7){
    		formatStyle = '0.000.000';
    	}else if(value == 8){
    		formatStyle = '00.000.000';
    	}else if(value == 9){
    		formatStyle = '000.000.000';
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