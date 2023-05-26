<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ200ukrv"  >
   <t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="I800" /> <!-- 장비구분 -->
   <t:ExtComboStore comboType="AU" comboCode="I805" /> <!-- 도면종류 -->
   <t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-grid-cell_red {
	background-color: #ff5500;
	//color:white;
}
.x-grid-cell_yellow {
	background-color: #ffff66;
	//color:white;
}
.x-grid-cell_black {
	background-color: #eee;
	//color:white;
}

</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript" >

var spareWindow;
var selectRecordCode;

var detailWin;
var BsaCodeInfo = {
	gsSiteCode			: '${gsSiteCode}'
}
function appMain() {
	var uploadWin;				//인증서 업로드 윈도우
	var photoWin;				//인증서 이미지 보여줄 윈도우
	var fid = '';				//인증서 ID
	var gsNeedPhotoSave	= false;

	Unilite.defineModel('equ200ukrvModel1', {
		fields: [
			{name: 'COMP_CODE'		    , text: '법인코드'				, type: 'string',isPk:true},
			{name: 'DIV_CODE'		    , text: '사업장코드'				, type: 'string',isPk:true},
			{name: 'EQU_CODE_TYPE'		, text: '장비구분'				, type: 'string', allowBlank:false,comboType:'AU', comboCode:'I800' },
			{name: 'EQU_CODE'		    , text: '장비(금형)번호'				, type: 'string', allowBlank:false},
			{name: 'EQU_NAME'		    , text: '장비(금형)명'				, type: 'string',  allowBlank:false},
			{name: 'EQU_SPEC'		    , text: '규격'				, type: 'string'},
			{name: 'MODEL_CODE'		    , text: '대표모델'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '제작처'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '제작처명'				, type: 'string'},
			{name: 'PRODT_DATE'		    , text: '제작일'				    , type: 'uniDate'},
			{name: 'PRODT_Q'	   		,text: '제작수량'		,type: 'uniQty'},
			{name: 'PRODT_O'		, text: '제작금액'			, type: 'uniUnitPrice'},
			{name: 'REP_O'		, text: '수리금액'			, type: 'uniUnitPrice'},
			{name: 'ASSETS_NO'		, text: '자산번호'				, type: 'string'},
			{name: 'SN_NO'		, text: '시리얼번호'				, type: 'string'},
			{name: 'EQU_GRADE'		, text: '보관검정상태'				, type: 'string',	comboType:'AU',comboCode:'I801' },
			{name: 'WEIGHT'		, text: '장비중량'				, type: 'uniQty'},
			{name: 'EQU_PRSN'		, text: '담당자'				, type: 'string'},
			{name: 'EQU_TYPE'		, text: '금형종류'				, type: 'string',comboType:'AU',comboCode:'I802'},
			{name: 'MTRL_TYPE'		, text: '금형재질'				, type: 'string',comboType:'AU',comboCode:'I803'},
			{name: 'MTRL_TEXT'		, text: '재질_비고'				, type: 'string'},
			{name: 'BUY_COMP'		, text: '매입처'				, type: 'string'},
			{name: 'BUY_DATE'		    , text: 'BUY_DATE'				    , type: 'uniDate'},
			{name: 'BUY_AMT'		, text: '매입액'			, type: 'uniUnitPrice'},
			{name: 'SELL_DATE'		    , text: '매각일'				    , type: 'uniDate'},
			{name: 'SELL_AMT'		    , text: '매각액'				    , type: 'uniUnitPrice'},
			{name: 'ABOL_DATE'		    , text: '폐기일'				    , type: 'uniDate'},
			{name: 'ABOL_AMT'		    , text: '폐기액'				    , type: 'uniUnitPrice'},
			{name: 'TRANS_DATE'	   		,text: '이동날자'		,type: 'uniDate'},
			{name: 'FROM_DIV_CODE'	   		,text: '이관사업장'		,type: 'string'},
			{name: 'USE_CUSTOM_CODE'	   		,text: '보관처'		,type: 'string'},
            {name: 'USE_CUSTOM_NAME'            ,text: '보관처'        ,type: 'string'},
			{name: 'REMARK'	   		,text: '비고'		,type: 'string'},


			{name: 'LOCATION'	   		,text: '금형위치'		,type: 'string', comboType: 'AU', comboCode: 'I806'},
			{name: 'CAVIT_BASE_Q'	   	,text: '캐비티수'		,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'CAPA'		    	,text: '한도SHOT'		,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'WORK_Q'	   			,text: '사용SHOT'		,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'TOT_PUNCH_Q'		,text: '누적SHOT'		,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'MIN_PUNCH_Q'		,text: '점검SHOT'		,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'MAX_PUNCH_Q'		,text: '최대SHOT'		,type: 'float',decimalPrecision:0, format:'0,000'},

			{name: 'LAST_DATE'	   		,text: '최근검교정'		,type: 'uniDate'},
			{name: 'NEXT_DATE'	   		,text: '다음검교정'		,type: 'uniDate'},
			{name: 'CAL_CYCLE_MM'	   	,text: '검정주기월'		,type: 'int'},
			{name: 'CAL_CNT'		   	,text: '점검차수'			,type: 'int'},

			{name: 'CYCLE_TIME'	   		,text: '가공시간'		,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'ITEM_WEIGHT'	   	,text: '제품중량'		,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'SCRAP_WEIGHT'	   	,text: '스크랩중량'		,type: 'float',decimalPrecision:0, format:'0,000'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			, type: 'string'},
			{name: 'PROG_WORK_CODE'		, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			, type: 'string'},
			{name: 'PROG_WORK_NAME'		, text: '<t:message code="system.label.product.routingname" default="공정명"/>'			, type: 'string'},

			{name: 'INSERT_DB_USER'	   	,text: '입력자'		,type: 'string'},
			{name: 'INSERT_DB_TIME'	   	,text: '입력일자'		,type: 'string'},
			{name: 'UPDATE_DB_USER'	   	,text: '수정자'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'	   	,text: '수정일자'		,type: 'string'},

			{name: 'IMAGE_FID',  		 text: '사진FID', 		type : 'string' },
 			{name: '_fileChange',		 text: '사진저장체크' 	,type:'string'	,editable:false},
			{name: 'MOLD_STRC'          ,text: '구조'         ,type: 'string'},
			{name: 'TXT_LIFE'           ,text:'수명'          ,type: 'uniQty'},
			{name: 'MT_DEPR'            ,text:'상각방법'        ,type: 'string', comboType: 'AU', comboCode: 'A036'},
			{name: 'USE_CNT'            ,text:'사용수'          ,type: 'uniQty'},
			{name: 'DATE_BEHV'          ,text:'가동일자'         ,type: 'uniDate'},
            {name: 'COMP_KEEP'              ,text:'보관방법'               ,type: 'string'},
            {name: 'MAKE_REASON'            ,text:'제작사유'               ,type: 'string', comboType: 'AU', comboCode: 'WB10'},
            {name: 'COMP_OWN_CODE'          ,text:'소유업체코드'           ,type: 'string'},
            {name: 'COMP_OWN_NAME'          ,text:'소유업체명'             ,type: 'string'},
            {name: 'COMP_DEV_CODE'          ,text:'개발업체코드'           ,type: 'string'},
            {name: 'COMP_DEV_NAME'          ,text:'개발업체명'             ,type: 'string'},
            {name: 'TP_COLLECT'             ,text:'수금구분'               ,type: 'string', comboType: 'AU', comboCode: 'WB11'},
            {name: 'DISP_REASON'            ,text:'폐기사유'               ,type: 'string'},
            {name: 'CON_NUM'                ,text:'분할수'                 ,type: 'uniQty'},
            {name: 'INSTOCK_DATE'           ,text:'설치일자'               ,type: 'uniDate'},
            {name: 'DEPT_CODE'            	,text:'부서코드'               ,type: 'string'},
            {name: 'DEPT_NAME'            	,text:'부서명'                ,type: 'string'}
		]
	});
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'equ200ukrvService.selectList',
			update: 'equ200ukrvService.updateDetail',
			create: 'equ200ukrvService.insertDetail',
			destroy: 'equ200ukrvService.deleteDetail',
			syncAll: 'equ200ukrvService.saveAll'
		}
	});
   /**
    * Store 정의(Service 정의)
    * @type
    */
	var directMasterStore1 = Unilite.createStore('equ200ukrvMasterStore1',{
		model: 'equ200ukrvModel1',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결
			editable: true,         // 수정 모드 사용
			deletable: true,			// 삭제 가능 여부
			allDeletable: false,      // 전체 삭제 가능 여부
			useNavi : false         // prev | newxt 버튼 사용

		},
		autoLoad: false,
		proxy: directProxy1,
		listeners:{
			load: function(store, records, successful, eOpts){

			},
           	add: function(store, records, index, eOpts) {

           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {

           	},
           	remove: function(store, record, index, isMove, eOpts) {

           	}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			this.load({	params: param});

//			console.log( param );
//			this.load({
//				params: param,
//					callback:function(records, operation, success)	{
//						if(success){
//							if(!Ext.isEmpty(selectRecordCode)){
//						 		var items = directMasterStore1.data.items
//								Ext.each(items,function(item,i){
//									if(item.data.EQU_CODE == selectRecordCode){
//										masterGrid.getSelectionModel().select(item);
//										return false;
//									}
//								});
//							 }else{
//									masterGrid.getSelectionModel().select(0);
//								}
//						}
//					}
//			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();

			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);



			if(inValidRecs.length == 0) {

				var paramMaster= panelResult.getValues();	//syncAll 수정
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if (directMasterStore1.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{

						}

		    			equInfoGrid.setDisabled(false);
		        		detailForm.getField('EQU_CODE').setReadOnly(true);
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('equ200ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}


		}
	});

	/********** 파일 업로드 다운로드 2019.08.05
  	************************************************************/
  	//문서등록
  	//2019.08.12 문서 버튼 -> 그리드로 파일 업로드 변경
  	//품목 정보 관련 파일업로드
	Unilite.defineModel('equInfoModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '법인코드'			,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장코드'			,type: 'string'},
			{name: 'EQU_CODE'			,text: '장비코드'			,type: 'string'},
			{name: 'FILE_TYPE'			,text: '도면종류'			,type: 'string', 	allowBlank: false,		comboType:'AU', comboCode:'I805' },
			{name: 'MANAGE_NO'			,text: '관리번호'			,type: 'string', 	allowBlank: false},
			{name: 'UPDATE_DB_TIME'		,text: '수정일'			,type: 'uniDate'},
			{name: 'REMARK'				,text: '비고'				,type: 'string'},
			{name: 'CERT_FILE'			,text: '파일명'			,type: 'string'},
			{name: 'FILE_ID'			,text: '저장된 파일명'		,type: 'string'},
			{name: 'FILE_PATH'			,text: '저장된 파일경로'		,type: 'string'},
			{name: 'FILE_EXT'			,text: '저장된 파일확장자'		,type: 'string'}
		]
	});

	//품목 정보 관련 파일 업로드
	var equInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'equ200ukrvService.getEquInfo',
			update	: 'equ200ukrvService.equInfoUpdate',
			create	: 'equ200ukrvService.equInfoInsert',
			destroy : 'equ200ukrvService.equInfoDelete',
			syncAll : 'equ200ukrvService.saveAll2'
		}
	});

	var equInfoStore = Unilite.createStore('equInfoStore',{
		model	: 'equInfoModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},

		proxy: equInfoProxy,

		loadStoreRecords : function(record){
			var searchParam = Ext.getCmp('resultForm').getValues();
			var param = {
				'DIV_CODE' : record.get('DIV_CODE'),
				'EQU_CODE' : record.get('EQU_CODE')
			};
			var params = Ext.merge(searchParam, param);
			console.log( param );
			this.load({
				params : params,
				callback : function(records,options,success)    {
					isItemGridUseChange = false;
				}
			});
		},

		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	 {
				config = {
					success	: function(batch, option) {
						if(gsNeedPhotoSave){
							fnPhotoSave();
						}
					}
				};
				this.syncAllDirect(config);
			}else {
				equInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ){
			},
			metachange:function( store, meta, eOpts ){
			}
		},

		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save4', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save4', false);
			}
		},
		_onStoreDataChanged: function( store, eOpts ) {
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0){
				this.setToolbarButtons(['sub_delete4'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':false}});
			}else {
				if(this.uniOpt.deletable)	{
					this.setToolbarButtons(['sub_delete4'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':true}});
				}
			}
			if(store.isDirty()) {
				this.setToolbarButtons(['sub_save4'], true);
			}else {
				this.setToolbarButtons(['sub_save4'], false);
			}
		},

		setToolbarButtons: function( btnName, state)	 {
			var toolbar = equInfoGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});

	var equInfoGrid = Unilite.createGrid('equInfoGrid', {
		store	: equInfoStore,
		border	: true,
		height	: 200,
		//width	: '100%',
		//padding	: '0 0 5 0',
		sortableColumns : false,
		//excelTitle: '관련파일',
		uniOpt	:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false
//			enterKeyCreateRow: true							//마스터 그리드 추가기능 삭제
		},
		dockedItems : [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '조회',
				tooltip	: '조회',
				iconCls	: 'icon-query',
				width	: 26,
				height	: 26,
				itemId	: 'sub_query4',
				handler: function() {
					//if( me._needSave()) {
					var toolbar	= equInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					var record	= masterGrid.getSelectedRecord();
					if (needSave) {
						Ext.Msg.show({
							title	: '확인',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								//console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										equInfoStore.saveStore();
									});
									saveTask.delay(500);
								} else if(res === 'no') {
										equInfoStore.loadStoreRecords(record);
								}
							}
						});
					} else {
						equInfoStore.loadStoreRecords(record);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '신규',
				tooltip	: '초기화',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
				itemId	: 'sub_reset4',
				handler: function() {
					var toolbar	= equInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					if(needSave) {
							Ext.Msg.show({
								title:'<t:message code="system.label.base.confirm" default="확인"/>',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									console.log(res);
									if (res === 'yes' ) {
											var saveTask =Ext.create('Ext.util.DelayedTask', function(){
												equInfoStore.saveStore();
											});
											saveTask.delay(500);
									} else if(res === 'no') {
											equInfoGrid.reset();
											equInfoStore.clearData();
											equInfoStore.setToolbarButtons('sub_save4', false);
											equInfoStore.setToolbarButtons('sub_delete4', false);
									}
								}
							});
					} else {
							equInfoGrid.reset();
							equInfoStore.clearData();
							equInfoStore.setToolbarButtons('sub_save4', false);
							equInfoStore.setToolbarButtons('sub_delete4', false);
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData4',
				handler: function() {
					var record		= masterGrid.getSelectedRecord();
					var compCode	= UserInfo.compCode;
					var divCode		= record.get('DIV_CODE');
					var equCode		= record.get('EQU_CODE');
					var r = {
						COMP_CODE		:	compCode,
						DIV_CODE		:	divCode,
						EQU_CODE		:	equCode
					};
					equInfoGrid.createRow(r);
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '삭제',
				tooltip		: '삭제',
				iconCls		: 'icon-delete',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_delete4',
				handler	: function() {
					var selRow = equInfoGrid.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
						if(selRow.phantom === true) {
							equInfoGrid.deleteSelectedRow();
						}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
							equInfoGrid.deleteSelectedRow();
						}
					} else {
						alert(Msg.sMA0256);
						return false;
					}
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '저장',
				tooltip		: '저장',
				iconCls		: 'icon-save',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_save4',
				handler	: function() {
					var inValidRecs = equInfoStore.getInvalidRecords();
					if(inValidRecs.length == 0 )	 {
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							equInfoStore.saveStore();
						});
						saveTask.delay(500);
					} else {
						equInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}]
		}],

		columns:[
				{ dataIndex	: 'COMP_CODE'			, width: 80			,hidden : true },
				{ dataIndex	: 'DIV_CODE'			, width: 80			,hidden : true },
				{ dataIndex	: 'EQU_CODE'			, width: 80			,hidden : true },
				{ dataIndex	: 'FILE_TYPE'			, width: 100},
				{ dataIndex	: 'MANAGE_NO'			, width: 150},
				{ text		: '품목 관련파일',
				 	columns:[
						{ dataIndex	: 'CERT_FILE'	, width: 300		, align: 'center'	,
							renderer: function (val, meta, record) {
								if (!Ext.isEmpty(record.data.CERT_FILE)) {
								  if(record.data.FILE_EXT == 'jpg' || record.data.FILE_EXT == 'png' || record.data.FILE_EXT == 'pdf'){
									  return '<font color = "blue" >' + val + '</font>';
								  }else{
									  var fileName = record.data.FILE_ID + '.' +  record.data.FILE_EXT;
									  var originFile = record.data.CERT_FILE;
									  var divCode = record.data.DIV_CODE;
									  var EquCode = record.data.EQU_CODE;
									  var fileType = record.data.FILE_TYPE;
									  var manageNo = record.data.MANAGE_NO;
									  return  '<A href="'+ CHOST + CPATH + '/fileman/downloadEquFile/' + PGM_ID + '/' + divCode + '/' + EquCode + '/' + fileType + '/' + manageNo  +'">' + val + '</A>';
								  }
								} else {
									return '';
								}
							}
						},{
							text		: '',
							dataIndex	: 'REG_IMG',
							xtype		: 'actioncolumn',
							align		: 'center',
							padding		: '-2 0 2 0',
							width		: 30,
							items		: [{
								icon	: CPATH+'/resources/css/theme_01/barcodetest.png',
								handler	: function(grid, rowIndex, colIndex, item, e, record) {
									equInfoGrid.getSelectionModel().select(record);
									openUploadWindow();
								}
							}]
						}
					]
				},
				{ dataIndex	: 'UPDATE_DB_TIME'				, width: 100},
				{ dataIndex	: 'REMARK'			, flex: 1	, minWidth: 30}
		],

		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['FILE_TYPE', 'MANAGE_NO', 'CERT_FILE','COMP_CODE','DIV_CODE','EQU_CODE','UPDATE_DB_TIME'])){
						return false;
					}

				} else {
					if (UniUtils.indexOf(e.field, ['CERT_FILE','COMP_CODE','DIV_CODE','EQU_CODE','UPDATE_DB_TIME'])){
						return false;
					}
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if( cellIndex == 6 &&  !Ext.isEmpty(record.get('CERT_FILE'))) {
					fid = record.data.FILE_ID
					var fileExtension	= record.get('CERT_FILE').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadEquInfoImage/' + fid,
							prgID	: 'equ200ukrv'
						});
						win.center();
						win.show();

					} else if(fileExt == 'jpg' || fileExt == 'png') {
						openPhotoWindow();
					} else {

					}
				}
			}
		}
	});


	//다중파일 업로드
	var photoForm2 = Ext.create('Unilite.com.form.UniDetailForm',{

		region: 'north',
		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm2',
		api			: {
			submit	: equ200ukrvService.photoUploadFile2
		},
		items		: [{
				xtype		: 'filefield',
				buttonOnly	: false,
				fieldLabel	: '다중파일 업로드',
				flex		: 1,
				name		: 'photoFile',
				id			: 'photoFile2',
				buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
				width		: 270,
				labelWidth	: 70,
				listeners: {
                    afterrender:function(object){
                        //input type="file" 태그 속성중  multiple이라는 속성 추가
                        object.fileInputEl.set({multiple:'multiple'});
                    }

			        /* render: function(field) {
			            field.fileInputEl.set({
			                multiple: 'multiple'
			            });
			        } */
			    },
			},{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.upload" default="올리기"/>',
				handler	: function()	{

					if (Ext.isEmpty(photoForm2.getValue('photoFile2'))) {
						alert('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
						return false;
					}

					//jpg파일만 등록 가능
			//		var filePath		= photoForm.getValue('photoFile2');
			//		var fileExtension	= filePath.lastIndexOf( "." );
				//	var fileExt			= filePath.substring( fileExtension + 1 );
//
					/* if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
						alert('<t:message code="system.message.base.message001" default="이미지 파일(jpg, png, bmp) 또는 pdf파일만 업로드 할 수 있습니다."/>');
						return false;
					} */

					var param		= {
							//		DIV_CODE	: record.data.DIV_CODE,
							//		EQU_CODE	: record.data.EQU_CODE,
							//		FILE_TYPE	: record.data.FILE_TYPE,
							//		MANAGE_NO	: record.data.MANAGE_NO
								}
								photoForm2.submit({
									params	: param,
									waitMsg	: 'Uploading your files...',
									success	: function(form, action)	{
										//uploadWin.afterSuccess();
									//	gsNeedPhotoSave = false;
									//photoForm2.fileInputEl.set({multiple:'multiple'});
										photoForm2.down("filefield").fileInputEl.set({multiple:'multiple'});
										Unilite.messageBox("성공");
										//alert("성공");
									},
									failure : function(){

										photoForm2.down("filefield").fileInputEl.set({multiple:'multiple'});
										Unilite.messageBox("실패");
										//alert("실패");
									}
								});

				//	fnPhotoSave2();

				}
			}
		]
	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},// tableAttrs: { style: { width: '100%',height:'100%' } }},
		padding:'1 1 1 1',
		border:true,
		defaultType: 'container',
		items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox' ,
			allowBlank:false,
			comboType: 'BOR120'
	    },{
			fieldLabel: '장비구분',
			name: 'EQU_CODE_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'I800'
		},{
        	fieldLabel: '장비(금형)번호',
			xtype: 'uniTextfield',
			name:'EQU_CODE'
	    },{
        	fieldLabel: '대표모델',
			xtype: 'uniTextfield',
			name:'MODEL_CODE'
	    },{
			xtype:'button',
			text:'스페어등록',
			itemId:'spareBtn',
			margin:'0 0 0 50',
			hidden:true,
			handler:function()	{
				var selectRecord = masterGrid.getSelectedRecord();
				if(Ext.isEmpty(selectRecord) || selectRecord.get('EQU_CODE_TYPE') != '1'){
					Unilite.messageBox('금형정보를 선택해 주세요');
					return;
				}
				openspareWindow();
			}
	    }]
    });


	var masterGrid = Unilite.createGrid('equ200ukrvGrid1', {
       // for tab
		title: '',
		layout: 'fit',
		region:'center',

		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
			onLoadSelectFirst: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
//        viewConfig: {
//	        getRowClass: function(record, rowIndex, rowParams, store){
//
//
//	          		if(record.get("EQU_GRADE") == "C"){
//	          			return 'x-grid-cell_red';
//	          		}else if(record.get("EQU_GRADE") == "A"){
//	          			return 'x-grid-cell_yellow';
//	          		}
//					return 'x-grid-cell_black';
//
//	        }
//	    },
		store: directMasterStore1,
		columns: [
//			{dataIndex: 'COMP_CODE' , width: 120 ,hidden:true},
//			{dataIndex: 'DIV_CODE' , width: 120  ,hidden:true},
			{dataIndex: 'EQU_CODE_TYPE' , width: 80},
			{dataIndex: 'EQU_CODE' , width: 120, isLink:true},
			{dataIndex: 'EQU_NAME' , width: 120},
			{dataIndex: 'EQU_SPEC' , width: 120},
			{dataIndex: 'MODEL_CODE' , width: 120},
			{dataIndex:'CUSTOM_CODE'		,width:140
				  ,editor : Unilite.popup('CUST_G',{
	    				textFieldName:'CUSTOM_CODE',
	    				autoPopup:true,
	    				listeners: {
			                'onSelected':  function(records, type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
			                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);

			                }
			                ,'onClear':  function( type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('CUSTOM_CODE','');
			                    	grdRecord.set('CUSTOM_NAME','');

			                }
			            } // listeners
					})
				},
				{dataIndex:'CUSTOM_NAME'		,width:140
				  ,editor : Unilite.popup('CUST_G',{
	    				textFieldName:'CUSTOM_NAME',
	    				autoPopup:true,
	    				listeners: {
			                'onSelected':  function(records, type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
			                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);

			                }
			                ,'onClear':  function( type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('CUSTOM_CODE','');
			                    	grdRecord.set('CUSTOM_NAME','');

			                }
			            } // listeners
					})
				},

			{dataIndex: 'PRODT_DATE' , width: 120},
			{dataIndex: 'PRODT_Q' , width: 120},
			{dataIndex: 'PRODT_O' , width: 120},
			{dataIndex: 'REP_O' , width: 120,hidden:true},
			{dataIndex: 'ASSETS_NO' , width: 120},
			{dataIndex: 'SN_NO' , width: 120,hidden:true},
			{dataIndex: 'EQU_GRADE' , width: 120},
			{dataIndex: 'WEIGHT' , width: 120},
			{dataIndex: 'EQU_PRSN' , width: 120,hidden:true},
			{dataIndex: 'EQU_TYPE' , width: 120,hidden:true},
			{dataIndex: 'MTRL_TYPE' , width: 120,hidden:true},

			{dataIndex:'BUY_COMP'		,hidden:true,width:140
				  ,editor : Unilite.popup('CUST_G',{
	    				textFieldName:'BUY_COMP',
	    				autoPopup:true,
	    				listeners: {
			                'onSelected':  function(records, type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('BUY_COMP',records[0]['CUSTOM_CODE']);

			                }
			                ,'onClear':  function( type  ){
			                    	var grdRecord = masterGrid.uniOpt.currentRecord;
			                    	grdRecord.set('BUY_COMP','');

			                }
			            }
					})
				},

			{dataIndex: 'BUY_DATE' , width: 120,hidden:true},
			{dataIndex: 'BUY_AMT' , width: 120,hidden:true},
			{dataIndex: 'SELL_DATE' , width: 120,hidden:true},
			{dataIndex: 'SELL_AMT' , width: 120,hidden:true},
			{dataIndex: 'ABOL_DATE' , width: 120,hidden:true},
			{dataIndex: 'ABOL_AMT' , width: 120,hidden:true},
			{dataIndex: 'DISP_REASON' , width: 120,hidden:true},
			{dataIndex: 'TRANS_DATE' , width: 120,hidden:true},
			{dataIndex: 'FROM_DIV_CODE' , width: 120,hidden:true},

			{dataIndex: 'REMARK' , width: 120,hidden:true},
			{dataIndex: 'MTRL_TEXT' , width: 120},


			{dataIndex: 'LOCATION' 		, width: 120},
			{dataIndex: 'CAVIT_BASE_Q'  , width: 120},
			{dataIndex: 'CAPA' 			, width: 120},
			{dataIndex: 'WORK_Q' 		, width: 120},
			{dataIndex: 'TOT_PUNCH_Q' 		, width: 120},

			{dataIndex: 'MIN_PUNCH_Q' 			, width: 120},
			{dataIndex: 'MAX_PUNCH_Q' 		, width: 120},

			{dataIndex: 'CYCLE_TIME' 	, width: 120},
			{dataIndex: 'ITEM_WEIGHT' 	, width: 120},
			{dataIndex: 'SCRAP_WEIGHT'  , width: 120},
			{dataIndex:'DEPT_CODE'			,width:80
				  ,'editor' : Unilite.popup('DEPT_G',{
				  		textFieldName:'DEPT_CODE',
				  		textFieldWidth:100,
				  		DBtextFieldName: 'TREE_CODE',
			  			autoPopup: true,
				    	listeners: {
				    		'onSelected': {
								fn: function(records, type) {
									grdRecord = masterGrid.getSelectedRecord();
									record = records[0];
									grdRecord.set('DEPT_CODE', record.TREE_CODE);
									grdRecord.set('DEPT_NAME', record.TREE_NAME);
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
	    						grdRecord.set('DEPT_CODE','');
		                    	grdRecord.set('DEPT_NAME','');
							}
						}
					})
				}
				,{dataIndex:'DEPT_NAME'			,width:100
				  ,'editor' : Unilite.popup('DEPT_G',{
				  		textFieldName:'DEPT_NAME',
				  		textFieldWidth:100,
				  		DBtextFieldName: 'TREE_NAME',
			  			autoPopup: true,
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									grdRecord = masterGrid.getSelectedRecord();
									record = records[0];
									grdRecord.set('DEPT_CODE', record.TREE_CODE);
									grdRecord.set('DEPT_NAME', record.TREE_NAME);
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
		                    	grdRecord.set('DEPT_CODE','');
		                    	grdRecord.set('DEPT_NAME','');
							}
		 				}
					})
			},
			{dataIndex: 'LAST_DATE' 			, width: 120},
			{dataIndex: 'NEXT_DATE' 		, width: 120},
			{dataIndex: 'CAL_CYCLE_MM' 			, width: 120},
			{dataIndex: 'CAL_CNT' 		, width: 120},
			{dataIndex: 'MOLD_STRC' 	, width: 100},
			{dataIndex: 'MT_DEPR'       , width: 80},
			{dataIndex: 'USE_CNT'       , width: 80},
			{dataIndex: 'DATE_BEHV'     , width: 80},
	        {dataIndex: 'COMP_KEEP'                              ,           width: 80},
	        {dataIndex: 'MAKE_REASON'                            ,           width: 80},
            {dataIndex: 'COMP_OWN_CODE'                          ,           width: 100,
                editor:
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('COMP_OWN_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE','');
                                    grdRecord.set('COMP_OWN_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'COMP_OWN_NAME'                          ,           width: 150,
                editor:
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('COMP_OWN_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE','');
                                    grdRecord.set('COMP_OWN_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'COMP_DEV_CODE'                          ,           width: 100,
                editor:
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_DEV_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('COMP_DEV_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_DEV_CODE','');
                                    grdRecord.set('COMP_DEV_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'COMP_OWN_NAME'                          ,           width: 150,
                editor:
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('COMP_OWN_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('COMP_OWN_CODE','');
                                    grdRecord.set('COMP_OWN_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'USE_CUSTOM_CODE'                          ,           width: 100,
                editor:
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('USE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('USE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('USE_CUSTOM_CODE','');
                                    grdRecord.set('USE_CUSTOM_NAME','');
                            }
                        }
                    })
            },
            { dataIndex: 'USE_CUSTOM_NAME'                          ,           width: 150,
                editor:
                    Unilite.popup('AGENT_CUST_G',{
                        autoPopup:true,
                        listeners:{
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('USE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('USE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                           },
                           'onClear' : function(type)    {
                                    //var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('USE_CUSTOM_CODE','');
                                    grdRecord.set('USE_CUSTOM_NAME','');
                            }
                        }
                    })
            },
            {dataIndex: 'INSTOCK_DATE'     , width: 80},
            {dataIndex: 'TP_COLLECT'     , width: 80},
            {dataIndex: 'CON_NUM'       , width: 80},
            {dataIndex: 'TXT_LIFE' 		, width: 100}
		],
		listeners: {
          	selectionchangerecord:function(selected)	{
	      		detailForm.setActiveRecord(selected);
	      		itemImageForm.setImage(selected.get('IMAGE_FID'));

          	},
        	selectionchange:function(grid,selected,eOpts){
        		if(Ext.isEmpty(selected)){

                	detailForm.setDisabled(true);
                	//equInfoGrid.setDisabled(false);
	      		}else{
                	detailForm.setDisabled(false);
                	if(selected[0].phantom == true){
						detailForm.getField('EQU_CODE').setReadOnly(false);
						equInfoGrid.setDisabled(true);
                	}else{
						detailForm.getField('EQU_CODE').setReadOnly(true);
						equInfoGrid.setDisabled(false);
                	}

		      		if(selected.length > 0) {
							var record = selected[0];
							equInfoStore.loadData({});
							equInfoStore.loadStoreRecords(record);
						}

	      		}
        	},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
						case 'EQU_CODE' :
							masterGrid.hide();
							break;
						default:
							break;
	      			}
          		}
          	},
			hide:function()	{
				detailForm.show();
			},
			edit: function(editor, e) {
				var record = masterGrid.getSelectedRecord();
                detailForm.setActiveRecord(record);
            }
		}
	});
	/**
     * 상세 Form
     */
   /*   var equInfoGridForm = Unilite.createForm('equInfoGridForm', {
		 disabled:false,
		 hidden : true,
    	 width:900,
    	 height:300,
    	 padding	: '10 0 0 0',
		 layout: {type: 'uniTable', columns: 2},
		 items: [
				  {
						title	: '<t:message code="system.label.base.referfile" default="관련파일"/>',
						xtype	: 'panel',
						width	: '100%',
						colspan	: 3,
						height	: 200,
						padding	: '10 0 0 0',
						items	: [equInfoGrid]
					}
	             ]
 	});  */

 	 var itemImageForm = Unilite.createForm('equ200ImageForm' +
      		'itemImageForm', {
 	    	 			 fileUpload: true,
 						 //url:  CPATH+'/fileman/upload.do',
 	    	 			 api:{ submit: equ200ukrvService.uploadPhoto},
 						 disabled:false,
 				    	 width:450,
 				    	 height:500,
 	    	 			 layout: {type: 'uniTable', columns: 2},
 						 items: [
         						  { xtype: 'filefield',
 									buttonOnly: false,
 									fieldLabel: '사진',
 									hideLabel:true,
 									width:350,
 									name: 'fileUpload',
 									buttonText: '파일선택',
 									listeners: {change : function( filefield, value, eOpts )	{
 															var fileExtention = value.lastIndexOf(".");
 															//FIXME : 업로드 확장자 체크, 이미지파일만 upload
 															if(value !='' )	{
 																var record = masterGrid.getSelectedRecord();
 																detailForm.setValue('_fileChange', 'true');
 																//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
 		                    						 			//detailWin.setToolbarButtons(['prev','next'],false);
 															}
 														}
 									}
 								  }
 								  ,{ xtype: 'button', text:'사진저장', margin:'0 0 0 2',
 								  	 handler:function()	{
 								  	 	if(Ext.isEmpty(detailForm.getValue('EQU_CODE')))	{
 								  	 		alert('장비(금형)번호가 없습니다. 저장 후 사진을 올려주세요.')
 								  	 		return;
 								  	 	}
 								  	 	itemImageForm.submit( {
 								  	 					params :{
 								  	 						'DIV_CODE':detailForm.getValue('DIV_CODE'),
 								  	 						'EQU_CODE':detailForm.getValue('EQU_CODE')
 								  	 					},
 								  	 					success : function()	{
 								  	 						var selRecord = masterGrid.getSelectedRecord();
//                         									detailForm.loadForm(selRecord);				// 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.

 								  	 						UniAppManager.app.onQueryButtonDown();
 		                    						 		//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
 		                    						 		//detailWin.setToolbarButtons(['prev','next'],true);
 					                    	}
 			                    		});
 			                    		/*var config = {
 								  	 					success : function()	{
 								  	 						var selRecord = masterGrid.getSelectedRecord();
                         									detailForm.loadForm(selRecord);				// 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.
 		                    						 		//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
 		                    						 		//detailWin.setToolbarButtons(['prev','next'],true);
 					                    			  	}
 					                    			  };
 			                        	UniAppManager.app.onSaveDataButtonDown(config);*/
 								  	 }
 								  }
 								  ,
 								  { xtype: 'image', id:'equ200', src:CPATH+'/resources/images/nameCard.jpg', width:400,	 overflow:'auto', colspan:2}
 								 /*  ,{
 										title	: '<t:message code="system.label.base.referfile" default="관련파일"/>',
 										xtype	: 'panel',
// 										xtype	: 'uniFieldset',
 										width	: '100%',
 										colspan	: 3,
 										height	: 200,
 										//padding	: '0 3 20 5',
 										items	: [equInfoGrid]
 									} */
 					             ]
 					   , setImage : function (fid)	{
 						    	 	var image = Ext.getCmp('equ200');
 						    	 	var src = CPATH+'/resources/images/nameCard.jpg';
 						    	 	if(!Ext.isEmpty(fid))	{
 							         	//src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
 							         	src= CPATH+'/equit/equPhoto/'+fid;
 						    	 	}
 							        image.setSrc(src);
 						    	 }
 	});

    var detailForm = Unilite.createForm('detailForm', {
    	hidden: true,
    	masterGrid: masterGrid,
        autoScroll: false,
        //flex:1,
        border: false,
      	layout: {type: 'uniTable', columns: 4, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
        uniOpt:{
        	store : directMasterStore1
        },
     	api: {
	 		 load: 'equ200ukrvService.selectListForForm'
		},

		items : [{
			title: '',
			layout: {
	            type: 'uniTable',
	            columns: 1
	  		},
	  		height: 545,
	    	items : [
			    {fieldLabel: '법인코드' ,xtype:'uniTextfield' ,name: 'COMP_CODE',hidden:true},
				{fieldLabel: '사업장코드' ,xtype:'uniTextfield' ,name: 'DIV_CODE',hidden:true},
				{
					fieldLabel: '장비구분',
					name: 'EQU_CODE_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'I800',
					allowBlank:false
				},
				{fieldLabel: '장비번호' ,xtype:'uniTextfield' ,name: 'EQU_CODE', allowBlank:false },
				{fieldLabel: '장비명' ,xtype:'uniTextfield' ,name: 'EQU_NAME', allowBlank:false },
				{fieldLabel: '규격' ,xtype:'uniTextfield' ,name: 'EQU_SPEC'},
				{fieldLabel: '대표모델' ,xtype:'uniTextfield' ,name: 'MODEL_CODE'},
		//		{fieldLabel: '제작처' ,xtype:'uniTextfield' ,name: 'CUSTOM_CODE'},
				{fieldLabel: '장비중량' ,xtype:'uniNumberfield' ,name: 'WEIGHT',decimalPrecision:0},

				{fieldLabel: '제작수량' ,xtype:'uniNumberfield' ,name: 'PRODT_Q',decimalPrecision:0},
				{fieldLabel: '제작금액' ,xtype:'uniNumberfield' ,name: 'PRODT_O',decimalPrecision:2},
				{fieldLabel: '수리금액' ,xtype:'uniNumberfield' ,name: 'REP_O',decimalPrecision:2,readOnly:true},
				{fieldLabel: '자산번호' ,xtype:'uniTextfield' ,name: 'ASSETS_NO',hidden:true},
				{fieldLabel: '시리얼번호' ,xtype:'uniTextfield' ,name: 'SN_NO',hidden:true},
				{fieldLabel: '보관검정상태' ,xtype:'uniCombobox' ,name: 'EQU_GRADE',	comboType:'AU',comboCode:'I801' },
				Unilite.popup('CUST', {
					fieldLabel: '제작처',
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
			   	 	allowBlank:false,
			   	 	autoPopup:true
				}),

				{fieldLabel: '제작일' ,xtype:'uniDatefield' ,name: 'PRODT_DATE'},
				{fieldLabel: '금형종류' ,xtype:'uniCombobox' ,name: 'EQU_TYPE',	comboType:'AU',comboCode:'I802' },
				{fieldLabel: '금형재질' ,xtype:'uniCombobox' ,name: 'MTRL_TYPE',	comboType:'AU',comboCode:'I803' },

				{fieldLabel: '담당자' ,xtype:'uniTextfield' ,name: 'EQU_PRSN',hidden:true},

				{fieldLabel: '재질_비고' ,xtype:'uniTextfield' ,name: 'MTRL_TEXT'},
				{fieldLabel: '금형구조'   ,xtype:'uniTextfield'   ,name: 'MOLD_STRC'},
		//		{fieldLabel: '매입처' ,xtype:'uniTextfield' ,name: 'BUY_COMP'},
				Unilite.popup('CUST', {
					fieldLabel: '매입처',
					valueFieldName: 'BUY_COMP',
			   	 	textFieldName: 'BUY_COMP_NAME',
			   	 	autoPopup:true
				}),
				{fieldLabel: 'BUY_DATE' ,xtype:'uniDatefield' ,name: 'BUY_DATE',hidden:true},
				{fieldLabel: '매입액' ,xtype:'uniNumberfield' ,name: 'BUY_AMT',decimalPrecision:2},

		//		{fieldLabel: '한도수량' ,xtype:'uniNumberfield' ,name: 'CAPA',hidden:true},
		//		{fieldLabel: '사용수량' ,xtype:'uniNumberfield' ,name: 'WORK_Q',decimalPrecision:0,hidden:true},
		//		{fieldLabel: '캐비티수량' ,xtype:'uniNumberfield' ,name: 'CAVIT_BASE_Q',decimalPrecision:0,hidden:true},
				{fieldLabel: '이동날자' ,xtype:'uniDatefield' ,name: 'TRANS_DATE',hidden:false},
				{fieldLabel: '이관사업장' ,xtype:'uniTextfield' ,name: 'FROM_DIV_CODE',hidden:true},
		//		{fieldLabel: '보관처' ,xtype:'uniTextfield' ,name: 'USE_CUSTOM_CODE',hidden:true},

		    ]},{
				title: '',
				layout: {
		            type: 'uniTable',
		            columns: 1
		  		},
		  		height: 545,
		    	items : [
					{fieldLabel: '금형위치' ,xtype:'uniCombobox' ,name: 'LOCATION',	comboType:'AU',comboCode:'I806'},
					{fieldLabel: '캐비티수' ,xtype:'uniNumberfield' ,name: 'CAVIT_BASE_Q',decimalPrecision:0},
					{fieldLabel: '사용수'    ,xtype:'uniNumberfield' ,name: 'USE_CNT',decimalPrecision:0},
					{fieldLabel: '한도SHOT' ,xtype:'uniNumberfield' ,name: 'CAPA',decimalPrecision:0},
					{fieldLabel: '사용SHOT' ,xtype:'uniNumberfield' ,name: 'WORK_Q',decimalPrecision:0},
					{fieldLabel: '누적SHOT' ,xtype:'uniNumberfield' ,name: 'TOT_PUNCH_Q',decimalPrecision:0},
					{fieldLabel: '점검SHOT' ,xtype:'uniNumberfield' ,name: 'MIN_PUNCH_Q',decimalPrecision:0},
					{fieldLabel: '최대SHOT' ,xtype:'uniNumberfield' ,name: 'MAX_PUNCH_Q',decimalPrecision:0},
					{fieldLabel: '상각방법' ,xtype:'uniCombobox' ,name: 'MT_DEPR',	comboType:'AU',comboCode:'A036' },
					{fieldLabel: '가공시간' ,xtype:'uniNumberfield' ,name: 'CYCLE_TIME',decimalPrecision:0},
					{fieldLabel: '제품중량' ,xtype:'uniNumberfield' ,name: 'ITEM_WEIGHT',decimalPrecision:0},
					{fieldLabel: '스크랩중량' ,xtype:'uniNumberfield' ,name: 'SCRAP_WEIGHT',decimalPrecision:0},
					Unilite.popup('DEPT',{
						fieldLabel		: '부서',
						textFieldName	: 'DEPT_NAME',
						valueFieldName	: 'DEPT_CODE',
						DBvalueFieldName: 'TREE_CODE',
						DBtextFieldName	: 'TREE_NAME',

						listeners		: {
							'onSelected': function(records, type){
								/* 	var grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
									grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']); */
							},
							'onClear':function( type){
									var grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('DEPT_NAME','');
									grdRecord.set('DEPT_CODE','');
							}
						}
					}),
//					{xtype: 'component', height: 10},
					{fieldLabel: '최근검교정' 	,xtype:'uniDatefield' ,name: 'LAST_DATE'},
					{fieldLabel: '다음검교정' 	,xtype:'uniDatefield' ,name: 'NEXT_DATE'},
					{fieldLabel: '검정주기월' 	,xtype:'uniNumberfield' ,name: 'CAL_CYCLE_MM',decimalPrecision:0},
					{fieldLabel: '검정차수' 	,xtype:'uniNumberfield' ,name: 'CAL_CNT',decimalPrecision:0},
					{
						fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
						name: 'WORK_SHOP_CODE',
						xtype: 'uniCombobox',
						comboType:'W',
						allowBlank:true
					},
					Unilite.popup('PROG_WORK_CODE',{
						fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>',
						valueFieldName: 'PROG_WORK_CODE',
						textFieldName: 'PROG_WORK_NAME',
						listeners: {
							onSelected: {
								fn: function(records, type) {

		                    	},
								scope: this
							},
							onClear: function(type)	{

							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}

				})
				]
		    },{
				title: '',
				layout: {
		            type: 'uniTable',
		            columns: 1
		  		},
		  		height: 545,
		    	items : [

					{fieldLabel: '가동일자' ,xtype:'uniDatefield' ,name: 'DATE_BEHV'},
					{fieldLabel: '보관방법' ,xtype:'uniTextfield' ,name: 'COMP_KEEP'},
					{fieldLabel: '제작사유' ,xtype:'uniCombobox' ,name: 'MAKE_REASON',	comboType:'AU',comboCode:'WB10' },
					Unilite.popup('CUST', {
						fieldLabel: '소유업체',
						valueFieldName: 'COMP_OWN_CODE',
				   	 	textFieldName: 'COMP_OWN_NAME',
				   	 	allowBlank:true,
				   	 	autoPopup:true
					}),
					Unilite.popup('CUST', {
						fieldLabel: '개발업체',
						valueFieldName: 'COMP_DEV_CODE',
				   	 	textFieldName: 'COMP_DEV_NAME',
				   	    allowBlank:true,
				   	 	autoPopup:true
					}),
					Unilite.popup('CUST', {
						fieldLabel: '보관처',
						hidden: false,
						valueFieldName: 'USE_CUSTOM_CODE',
				   	 	textFieldName: 'USE_CUSTOM_NAME',
//				   	 	allowBlank:false,
				   	 	readOnly:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {

		                    	},
								scope: this
							},
							onClear: function(type)	{

							}
						}
					}),

					{fieldLabel: '수금구분' ,xtype:'uniCombobox' ,name: 'TP_COLLECT',	comboType:'AU',comboCode:'WB11' },
					{fieldLabel: '설치일자' ,xtype:'uniDatefield' ,name: 'INSTOCK_DATE',hidden:false},
					{fieldLabel: '매각일' ,xtype:'uniDatefield' ,name: 'SELL_DATE',hidden:false},
					{fieldLabel: '매각액' ,xtype:'uniNumberfield' ,name: 'SELL_AMT',decimalPrecision:2,hidden:false},
					{fieldLabel: '폐기일' ,xtype:'uniDatefield' ,name: 'ABOL_DATE',hidden:false},
					{fieldLabel: '폐기액' ,xtype:'uniNumberfield' ,name: 'ABOL_AMT',decimalPrecision:2,hidden:false},
					{fieldLabel: '폐기사유'   ,xtype:'uniTextfield'   ,name: 'DISP_REASON'},
					{fieldLabel: '분할수'    ,xtype:'uniNumberfield' ,name: 'CON_NUM',type		: 'uniQty'},
					{fieldLabel: '수명'    ,xtype:'uniNumberfield' ,name: 'TXT_LIFE',type		: 'uniQty'},
					{fieldLabel: '비고' ,xtype:'textareafield' ,name: 'REMARK', width: 315, height: 50},
					{xtype: 'component', height: 10}

				]
		    },{
		    	title: '',
		    	layout: {
		            type: 'uniTable',
		            columns: 1,
		            tdAttrs: {valign:'top'}

		        },
		        defaults: {type: 'uniTextfield'},
		        items :[
		        	itemImageForm,
		        	{ name: '_fileChange',  fieldLabel: '사진수정여부'  ,hidden:true	}


	        	]
		    },
		    {
				//title	: '관련파일',
				xtype	: 'panel',
				width	: '100%',
				colspan	: 3,
				height	: 200,
				padding	: '0 0 10 0',
				items	: [equInfoGrid]
			}]
		    ,loadForm: function(record)	{
				itemImageForm.setImage(record.get('IMAGE_FID'));
   			}
	    });



	var spareSearch = Unilite.createSearchForm('spareSearchForm', {     // 스페어
        layout: {type: 'uniTable', columns : 2},
//        trackResetOnLoad: true,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                readOnly: true
            },
            Unilite.popup('MOLD_CODE',{
                fieldLabel: '금형',
                valueFieldName:'MOLD_CODE',
                textFieldName:'MOLD_NAME',
                readOnly: true
            })
        ],
        setAllFieldsReadOnly: function(b) {
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });
                if(invalid.length > 0) {
                    r=false;
                    var labelText = ''
                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    //this.mask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) ) {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                //this.unmask();
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) ) {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField) {
                        var popupFC = item.up('uniPopupField') ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });




    var spareDirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'equ200ukrvService.selectListSpare',
            update: 'equ200ukrvService.updateSpare',
            create: 'equ200ukrvService.insertSpare',
            destroy: 'equ200ukrvService.deleteSpare',
            syncAll: 'equ200ukrvService.saveAllSpare'
        }
    });

    Unilite.defineModel('spareStoreModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string', comboType:'BOR120'},
            {name: 'MOLD_CODE'              ,text:'금형코드'               ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'품목코드'               ,type: 'string', allowBlank:false},
            {name: 'ITEM_NAME'              ,text:'품목명'                 ,type: 'string', editable:false},
            {name: 'SPEC'                   ,text:'규격'                   ,type: 'string', editable:false},
            {name: 'NEED_QTY'               ,text:'소요량'                 ,type: 'uniQty', allowBlank:false},
            {name: 'SAFE_STOCK_Q'           ,text:'안전재고량'             ,type: 'uniQty', editable:false},
            {name: 'STOCK_QTY'              ,text:'재고량'                 ,type: 'uniQty', editable:false},
            {name: 'PURCH_LDTIME'           ,text:'발주L/T'                ,type: 'uniQty', editable:false}
        ]
    });

    var spareStore = Unilite.createStore('spareStore',{
        model: 'spareStoreModel',
        uniOpt : {
            isMaster:  false,           // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: spareDirectProxy,
        loadStoreRecords : function()   {
        	var param= spareSearch.getValues();
            this.load({
                  params : param
            });
        },
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            var isErr = false;
            Ext.each(list, function(record, index) {
                if(Ext.isEmpty(record.get('ITEM_CODE')) || Ext.isEmpty(record.get('NEED_QTY'))){
                    alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '품목/소요량: 필수 입력값 입니다.');
                    isErr = true;
                    return false;
                }
            });
            if(isErr) return false;

            // 1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();    // syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();

                        spareStore.loadStoreRecords();
                    }
                };
                this.syncAllDirect(config);
            } else {
                spareGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });

    var spareGrid = Unilite.createGrid('reqNumMasterGrid', {     // 스페어
        layout : 'fit',
        store: spareStore,
        uniOpt:{
            useRowNumberer: false
        },
        columns:  [
            {dataIndex : 'COMP_CODE'                  , width : 80, hidden: true},
            {dataIndex : 'DIV_CODE'                   , width : 80, hidden: true},
            {dataIndex : 'MOLD_CODE'                  , width : 80, hidden: true},
            {dataIndex : 'ITEM_CODE'                  , width : 110,
                editor: Unilite.popup('DIV_PUMOK_G', {
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        extParam: {SELMODEL: 'MULTI', DIV_CODE: UserInfo.divCode, POPUP_TYPE: 'GRID_CODE'},
                        autoPopup:true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {
                                    if(i==0) {
                                        spareGrid.setItemData(record,false, spareGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewSpareDataButtonDown();
                                        spareGrid.setItemData(record,false, spareGrid.getSelectedRecord());
                                    }
                                });
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            spareGrid.setItemData(null,true, spareGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': spareSearch.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            {dataIndex : 'ITEM_NAME'                  , width : 200},
            {dataIndex : 'SPEC'                       , width : 200},
            {dataIndex : 'NEED_QTY'                   , width : 80},
            {dataIndex : 'SAFE_STOCK_Q'                 , width : 100},
            {dataIndex : 'STOCK_QTY'                  , width : 80},
            {dataIndex : 'PURCH_LDTIME'               , width : 80}
        ],
        setItemData: function(record, dataClear) {
            var grdRecord = this.getSelectedRecord();
            if(dataClear) {
                grdRecord.set('ITEM_CODE'           , '');
                grdRecord.set('ITEM_NAME'           , '');
                grdRecord.set('SPEC'                , '');
                grdRecord.set('SAFE_STOCK_Q'          , '');

                grdRecord.set('PURCH_LDTIME'        , '');
            } else {
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                grdRecord.set('SPEC'                , record['SPEC']);
                grdRecord.set('SAFE_STOCK_Q'          , record['SAFE_STOCK_Q']);

                grdRecord.set('PURCH_LDTIME'        , record['PURCH_LDTIME']);
            }

        }
    });

    function openspareWindow() {   // 스페어 팝업
        if(!spareWindow) {
            spareWindow = Ext.create('widget.uniDetailWindow', {
                title: '스페어등록',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [spareSearch, spareGrid],
                tbar:  ['->',
                    {
                        itemId : 'saveBtn',
                        text: '조회',
                        handler: function() {
                            if(spareSearch.setAllFieldsReadOnly(true) == false){
                                return false;
                            } else {
                                spareStore.loadStoreRecords();
                            }
                        },
                        disabled: false
                    },{
                        text: '행추가',
                        handler: function() {
                            UniAppManager.app.onNewSpareDataButtonDown();
                        },
                        disabled: false
                    },{
                        text: '행삭제',
                        handler: function() {
							var selRow = spareGrid.getSelectedRecord();
				            if(!Ext.isEmpty(selRow)){
				                if(selRow.phantom === true) {
				                    spareGrid.deleteSelectedRow();
				                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
				                    spareGrid.deleteSelectedRow();
				                }
				            }
                        },
                        disabled: false
                    },{
                        text: '저장',
                        handler: function() {
                        	spareStore.saveStore();
                        },
                        disabled: false
                    }, {
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            spareWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {
                    beforeshow: function( panel, eOpts )    {
                    	var record = masterGrid.getSelectedRecord();
                        spareSearch.setValue('DIV_CODE', record.get('DIV_CODE'));
                        spareSearch.setValue('MOLD_CODE', record.get('EQU_CODE'));
                        spareSearch.setValue('MOLD_NAME', record.get('EQU_NAME'));
                        spareStore.loadStoreRecords();
                    }
                }
            })
        }
        spareWindow.show();
        spareWindow.center();
    }


	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[

			     //  photoForm2, //다중파일 업로드 관련 필요시 사용

				panelResult,{region:'center',
				//layout : 'border',
				title:'',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [{
					type: 'hum-grid',
		            handler: function () {
		            	detailForm.hide();
		                masterGrid.show();
		            	panelResult.show();
//		            	 UniAppManager.setToolbarButtons(['newData'], true);
		            }
				},{

					type: 'hum-photo',
		            handler: function () {
		            	/*
		            	var edit = masterGrid.findPlugin('cellediting');
						if(edit && edit.editing)	{
							setTimeout("edit.completeEdit()", 1000);
						}
						*/
		                masterGrid.hide();
		                panelResult.show();
		                detailForm.show();
		                if(masterGrid.getSelectedRecord()){
		                	detailForm.setDisabled(false);


		                	if(masterGrid.getSelectedRecord().phantom == true){
								detailForm.getField('EQU_CODE').setReadOnly(false);
								equInfoGrid.setDisabled(true);
		                	}else{
								detailForm.getField('EQU_CODE').setReadOnly(true);
								equInfoGrid.setDisabled(false);
		                	}

		                	detailForm.setActiveRecord(masterGrid.getSelectedRecord());
//		                	var contrlNo = masterGrid.getSelectedRecord().get("EQU_CODE");
//			                panelResult.setValue("EQU_CODE",contrlNo);
//			                if(contrlNo){
//			                	UniAppManager.app.onLoadForm();
//			                }
		                }else{
		                	detailForm.setDisabled(true);
		                }
//		                UniAppManager.setToolbarButtons(['newData'], false);

		            }
				}],
				items:[
					masterGrid,
					detailForm
				]
			}]
		}],
		id: 'equ200ukrvApp',
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('EQU_CODE_TYPE','1');
			detailForm.getField('EQU_CODE').setReadOnly(false);
        	panelResult.getField('DIV_CODE').setReadOnly(false);

			UniAppManager.setToolbarButtons(['newData','reset'], true);
			UniAppManager.setToolbarButtons(['save','deleteAll'], false);

			if(BsaCodeInfo.gsSiteCode == 'KDG'){
				panelResult.down('#spareBtn').setHidden(false);
			}
		},

		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   // 필수체크
        	masterGrid.getStore().loadStoreRecords();
        	panelResult.getField('DIV_CODE').setReadOnly(true);
//			if(!masterGrid.hidden){
//				masterGrid.getStore().loadStoreRecords();
//			}else{
//				UniAppManager.app.onLoadForm();
//			}

		},
		onLoadForm: function(){
//			if(!panelResult.setAllFieldsReadOnly(true)){
//        		return false;
//        	}
//        	detailForm.clearForm();
//			var param= panelResult.getValues();
//			detailForm.uniOpt.inLoading = true;
//			Ext.getBody().mask('로딩중...','loading-indicator');
//			detailForm.getForm().load({
//				params: param,
//				success:function()	{
//					Ext.getBody().unmask();
//					if(masterGrid.getSelectedRecord()){
//			        	detailForm.loadForm(masterGrid.getSelectedRecord());
//					}
//
//					detailForm.uniOpt.inLoading = false;
//				},
//				failure: function(batch, option) {
//				 	Ext.getBody().unmask();
//				 }
//			})
		},
		onResetButtonDown: function() {
			masterGrid.reset();
			equInfoGrid.reset();
			directMasterStore1.clearData();
			equInfoStore.clearData();
			panelResult.clearForm();
			detailForm.clearForm();
        	detailForm.hide();

            masterGrid.show();
        	panelResult.getField('DIV_CODE').setReadOnly(false);
			detailForm.getField('EQU_CODE').setReadOnly(false);
			equInfoGrid.setDisabled(true);
			this.fnInitBinding();

		},

        onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;   // 필수체크
        	var r = {
        		'COMP_CODE':UserInfo.compCode,
        		'DIV_CODE':panelResult.getValue("DIV_CODE"),
        		'PRODT_DATE':UniDate.get("today"),
        		'BUY_DATE':UniDate.get("today"),
        		'SELL_DATE':UniDate.get("today"),
        		'ABOL_DATE':UniDate.get("today"),
        		'TRANS_DATE':UniDate.get("today"),
        		'WEIGHT':0,
        		'PRODT_Q':0,
        		'EQU_CODE_TYPE':'1'

        	};
        	masterGrid.createRow(r);
    		detailForm.setDisabled(false);
    		equInfoGrid.setDisabled(true);
        	panelResult.getField('DIV_CODE').setReadOnly(true);
        	detailForm.getField('EQU_CODE').setReadOnly(false);
        },

        onSaveDataButtonDown: function(config) {
			if(!panelResult.getInvalidMessage()) return;   // 필수체크
	        if(itemImageForm.isDirty())	{
				itemImageForm.submit({
							waitMsg: 'Uploading...',
							success: function(form, action) {
								if( action.result.success === true)	{
									masterGrid.getSelectedRecord().set('IMAGE_FID',action.result.fid);
									directMasterStore1.saveStore(config);
									itemImageForm.setImage(action.result.fid);
									itemImageForm.clearForm();
								}
							}
					});
			}else {
        		directMasterStore1.saveStore();


			}
        },
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                    masterGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                    masterGrid.deleteSelectedRow();
                }
            }
         },
         onNewSpareDataButtonDown: function() {       // 스페어 행추가
            var record = masterGrid.getSelectedRecord();
                var compCode        =   UserInfo.compCode;
                var divCode         =   record.get('DIV_CODE');
                var moldCode        =   record.get('EQU_CODE');

                var r = {
                    COMP_CODE:          compCode,
                    DIV_CODE:           divCode,
                    MOLD_CODE:          moldCode
                };
                spareGrid.createRow(r);
        }

	});
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;

			switch(fieldName) {
				case "WEIGHT" :
					if(newValue>=0){
						 rv = true;
					}
					break;
				case "PRODT_Q" :
					if(newValue>=0){
						 rv = true;
					}
					break;
				case "PRODT_O" :
					if(newValue>=0){
						 rv = true;
					}
					break;

			}
			return rv;
		}
	});

	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm',
		api			: {
			submit	: equ200ukrvService.photoUploadFile
		},
		items		: [{
				xtype		: 'filefield',
				buttonOnly	: false,
				fieldLabel	: '<t:message code="system.label.base.photo" default="사진"/>',
				flex		: 1,
				name		: 'photoFile',
				id			: 'photoFile',
				buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
				width		: 270,
				labelWidth	: 70
			}
		]
	});

	function fnPhotoSave() {				//이미지 등록
		//조건에 맞는 내용은 적용 되는 로직
		var record		= equInfoGrid.getSelectedRecord();
		var photoForm	= uploadWin.down('#photoForm').getForm();
		var param		= {
			DIV_CODE	: record.data.DIV_CODE,
			EQU_CODE	: record.data.EQU_CODE,
			FILE_TYPE	: record.data.FILE_TYPE,
			MANAGE_NO	: record.data.MANAGE_NO
		}
		photoForm.submit({
			params	: param,
			waitMsg	: 'Uploading your files...',
			success	: function(form, action)	{
				uploadWin.afterSuccess();
				gsNeedPhotoSave = false;
			}
		});
	}
	function openUploadWindow() {
		if(!uploadWin) {
			uploadWin = Ext.create('Ext.window.Window', {
				title		: '<t:message code="system.label.base.file" default="파일"/> <t:message code="system.label.base.entry" default="등록"/>',
				closable	: false,
				closeAction	: 'hide',
				modal		: true,
				resizable	: true,
				width		: 300,
				height		: 100,
				layout		: {
					type	: 'fit'
				},
				items		: [
					photoForm,
					{
						xtype		: 'uniDetailForm',
						itemId		: 'photoForm',
						disabled	: false,
						fileUpload	: true,
						api			: {
							submit: equ200ukrvService.photoUploadFile
						},
						items		:[{
						 	xtype		: 'filefield',
							fieldLabel	: '<t:message code="system.label.base.file" default="파일"/>',
							name		: 'photoFile',
							buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
							buttonOnly	: false,
							labelWidth	: 70,
							flex		: 1,
							width		: 270
						}]
					}
				],
				listeners : {
					beforeshow: function( window, eOpts)	{
 						var toolbar	= equInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
						var record	= equInfoGrid.getSelectedRecord();

						if (needSave) {
							if(Ext.isEmpty(record.data.FILE_TYPE) || Ext.isEmpty(record.data.MANAGE_NO)){
								alert('필수입력사항을 입력하신 후 파일을 올려주세요.');
								return false;
							}
						} else {
							if (Ext.isEmpty(record)) {
								alert('장비 관련 정보를 입력하신 후, 파일을 업로드 하시기 바랍니다.');
								return false;
							}
						}
					},
					show: function( window, eOpts)	{
						window.center();
					}
				},
				afterSuccess: function()	{
					var record	= masterGrid.getSelectedRecord();
					equInfoStore.loadStoreRecords(record);
					this.afterSavePhoto();
				},
				afterSavePhoto: function()	{
					var photoForm = uploadWin.down('#photoForm');
					photoForm.clearForm();
					uploadWin.hide();
				},
				tbar:['->',{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.upload" default="올리기"/>',
					handler	: function()	{
						var photoForm	= uploadWin.down('#photoForm');
						var toolbar		= equInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave	= !toolbar[0].getComponent('sub_save4').isDisabled();

						if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
							alert('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
							return false;
						}

						//jpg파일만 등록 가능
						var filePath		= photoForm.getValue('photoFile');
						var fileExtension	= filePath.lastIndexOf( "." );
						var fileExt			= filePath.substring( fileExtension + 1 );

						/* if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
							alert('<t:message code="system.message.base.message001" default="이미지 파일(jpg, png, bmp) 또는 pdf파일만 업로드 할 수 있습니다."/>');
							return false;
						} */


						if(needSave)	{
							gsNeedPhotoSave = needSave;
							equInfoStore.saveStore();

						} else {
							fnPhotoSave();
						}
					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.close" default="닫기"/>',
					handler	: function()	{
//						var photoForm = uploadWin.down('#photoForm').getForm();
//						if(photoForm.isDirty())	{
//							if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))	{
//								var config = {
//									success : function()	{
//										// TODO: fix it!!!
//										uploadWin.afterSavePhoto();
//									}
//								}
//								UniAppManager.app.onSaveDataButtonDown(config);
//
//							}else{
								// TODO: fix it!!!
								uploadWin.afterSavePhoto();
//							}
//
//						} else {
							uploadWin.hide();
//						}
					}
				}]
			});
		}
		uploadWin.show();
	}

	function openPhotoWindow() {
		photoWin = Ext.create('widget.uniDetailWindow', {
			title		: '<t:message code="system.label.base.preview" default="미리보기"/>',
			modal		: true,
			resizable	: true,
			closable	: false,
			width		: '80%',
			height		: '100%',
			layout		: {
				type	: 'fit'
			},
			closeAction	: 'destroy',
			items		: [{
				xtype		: 'uniDetailForm',
				itemId		: 'downForm',
				url			: CPATH + "/fileman/downloadEquInfoImage/" + fid,
				layout		: {type: 'uniTable', columns:'1'},
				standardSubmit: true,
				disabled	: false,
				autoScroll	: true,
				items		: [{
					xtype	: 'image',
					itemId	: 'photView',
					autoEl	: {
						tag: 'img',
						src: CPATH+'/resources/images/human/noPhoto.png'
					}
	  			}]
			}],
			listeners : {
				beforeshow: function( window, eOpts)	{
					window.down('#photView').setSrc(CPATH+'/fileman/downloadEquInfoImage/' + fid);
				},
				show: function( window, eOpts)	{
					window.center();
				}
			},
			tbar:['->',{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.download" default="다운로드"/>',
				handler	: function() {
					photoWin.down('#downForm').submit({
						success:function(comp, action)  {
							Ext.getBody().unmask();
						},
						failure: function(form, action){
							Ext.getBody().unmask();
						}
					});
				}
			},{
				xtype	: 'button',
				text	: '<t:message code="system.label.base.close" default="닫기"/>',
				handler	: function()	{
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}


};


</script>