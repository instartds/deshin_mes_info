<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr910ukrv_jw">
	<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />				<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B131" />				<!-- 예/아니오 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	//인증서 이미지 등록에 사용되는 변수 선언
	var uploadWin;							//인증서 업로드 윈도우
	var photoWin;							//인증서 이미지 보여줄 윈도우
	var fid				= '';				//인증서 ID
	var gsNeedPhotoSave	= false;
	var gsFileType      = '';

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bpr910ukrv_jwService.selectList',
			update	: 's_bpr910ukrv_jwService.updateList',
			create	: 's_bpr910ukrv_jwService.insertList',
			destroy	: 's_bpr910ukrv_jwService.deleteList',
			syncAll	: 's_bpr910ukrv_jwService.saveAll'
		}
	});




	Unilite.defineModel('s_bpr910ukrv_jwModel', {
		fields: [
			{name: 'COMP_CODE'          , text: '<t:message code="system.label.base.compcode" default="법인코드"/>'	, type: 'string'},
			{name: 'DIV_CODE'           , text: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>'	, type: 'string'	, comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'        , text: '<t:message code="system.label.common.client" default="고객"/>'	, type: 'string'},
			{name: 'CUSTOM_NAME'        , text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.base.item" default="품목"/>'				, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'MODEL'              , text: 'MODEL'	, type: 'string'	, allowBlank: false},
			{name: 'PART_NAME'          , text: 'PART NAME'	, type: 'string'},
			{name: 'REV_NO'             , text: 'REV No'	, type: 'string'},
			{name: 'CUSTOM_REV'         , text: '<t:message code="system.label.base.customrev" default="고객REV"/>'	, type: 'string'},
			{name: 'INSIDE_REV'         , text: '<t:message code="system.label.base.insiderev" default="내부REV"/>'	, type: 'string'},
			{name: 'RECEIPT_DATE'       , text: '<t:message code="system.label.common.receiptdate" default="접수일"/>'	, type: 'uniDate'},
			{name: 'CERT_FILE_01'       , text: '<t:message code="system.label.base.filename" default="파일명"/>'	, type: 'string'},
			{name: 'FILE_ID_01'         , text: 'FILE_ID_01'	, type: 'string'},
			{name: 'CERT_FILE_02'       , text: '<t:message code="system.label.base.filename" default="파일명"/>'	, type: 'string'},
			{name: 'FILE_ID_02'         , text: 'FILE_ID_02'	, type: 'string'},
			{name: 'CERT_FILE_03'       , text: '<t:message code="system.label.base.filename" default="파일명"/>'	, type: 'string'},
			{name: 'FILE_ID_03'         , text: 'FILE_ID_03'	, type: 'string'},
			{name: 'DEVELOPMENT_LEVEL'  , text: '<t:message code="system.label.base.developmentlevel" default="개발단계"/>'	, type: 'string', comboType:'AU', comboCode:'ZN03'},
			{name: 'RECEIPT_TYPE'       , text: '<t:message code="system.label.common.accepttype" default="접수구분"/>'	, type: 'string', comboType:'AU', comboCode:'ZN04'},
			{name: 'RECEIPT_DETAIL'     , text: '<t:message code="system.label.base.receiptdetail" default="접수내용"/>'	, type: 'string'},
			{name: 'WKORD_NUM'          , text: '<t:message code="system.label.base.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'WORK_DATE'          , text: '<t:message code="system.label.product.workday" default="작업일"/>'	, type: 'uniDate'},
			{name: 'WORK_Q'             , text: '<t:message code="system.label.product.workqty" default="작업량"/>'	, type: 'uniQty'},
			{name: 'WOODEN_PATTEN'      , text: '<t:message code="system.label.base.woodenpatten" default="목형번호"/>'	, type: 'string'},
			{name: 'WOODEN_ORDER_DATE'  , text: '<t:message code="system.label.base.woodenorderdate" default="목형발주일"/>'	, type: 'uniDate'},
			{name: 'WOODEN_UNIT_PRICE'  , text: '<t:message code="system.label.base.woodenprice" default="목형단가"/>'	, type: 'int'},
			{name: 'WOODEN_ORDER_YN'    , text: '<t:message code="system.label.base.woodenorderyn" default="목형발주여부"/>'	, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'SAMPLE_DATE'        , text: '<t:message code="system.label.base.sampledate" default="샘플발송일"/>'	, type: 'uniDate'},
			{name: 'SAMPLE_RESULT'      , text: '<t:message code="system.label.base.sampleresult" default="샘플결과"/>'	, type: 'string'},
			{name: 'CERT_FILE_04'       , text: '<t:message code="system.label.base.filename" default="파일명"/>'	, type: 'string'},
			{name: 'FILE_ID_04'         , text: 'FILE_ID_04'	, type: 'string'},
			{name: 'LINE_BAD_DETAIL'    , text: '<t:message code="system.label.base.linebaddetail" default="LINE발생 불량현상 내용"/>'	, type: 'string'},
			{name: 'IMPROVING_MEASURE'  , text: '<t:message code="system.label.common.improvingneasure" default="개선조치"/>'	, type: 'string'},
			{name: 'CERT_FILE_05'       , text: '<t:message code="system.label.base.filename" default="파일명"/>'	, type: 'string'},
			{name: 'FILE_ID_05'         , text: 'FILE_ID_05'	, type: 'string'},
			{name: 'PRODT_Q'            , text: '<t:message code="system.label.common.productionqty" default="생산량"/>'	, type: 'uniQty'},
			{name: 'BAD_Q'              , text: '<t:message code="system.label.base.defectqty" default="불량수량"/>'	, type: 'uniQty'},
			{name: 'BAD_RATE'           , text: '<t:message code="system.label.base.defectrate" default="불량율"/>'	, type: 'uniPercent'},
			{name: 'BAD_CODE1'          , text: 'WORST 1'	, type: 'string', comboType:'AU', comboCode:'P003'},
			{name: 'BAD_CODE2'          , text: 'WORST 2'	, type: 'string', comboType:'AU', comboCode:'P003'},
			{name: 'BAD_CODE3'          , text: 'WORST 3'	, type: 'string', comboType:'AU', comboCode:'P003'},
			{name: 'FABRIC_COST'        , text: '<t:message code="system.label.base.fabridcost" default="원단비용"/>'	, type: 'int'},
			{name: 'SAMPLE_COST'        , text: '<t:message code="system.label.base.samplecost" default="샘플비용"/>'	, type: 'int'},
			{name: 'SAMSUNG_MANAGER'    , text: '<t:message code="system.label.base.charger" default="담당자"/>'	, type: 'string'},
			{name: 'SUBMISSION'         , text: '<t:message code="system.label.base.submission" default="재출처"/>'	, type: 'string'},
			{name: 'MONEY_UNIT'         , text: '<t:message code="system.label.base.currencyunit" default="화폐단위"/>'	, type: 'string', comboType:'AU', comboCode:'B004'},
			{name: 'ITEM_PRICE'         , text: '<t:message code="system.label.base.itemprice" default="제품단가"/>'	, type: 'uniUnitPrice'},
			{name: 'CUSTOMER_SUBMIT_Q'  , text: '<t:message code="system.label.base.customerSubmitQ" default="고객제출수량"/>'	, type: 'uniQty'},
			{name: 'PRICE'              , text: '<t:message code="system.label.sales.amount" default="금액"/>'	, type: 'uniUnitPrice'},
			{name: 'ACCOUNT_MANAGER'    , text: '<t:message code="system.label.common.accountManger" default="계산서발행 담당자"/>'	, type: 'string'},
			{name: 'ACCOUNT_YN'         , text: '<t:message code="system.label.base.accountYn" default="계산서발행여부"/>'	, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'QUOT_DATE'          , text: '<t:message code="system.label.base.quotdate" default="견적제출일"/>'	, type: 'uniDate'},
			{name: 'ACCOUNT_DATE'       , text: '<t:message code="system.label.base.billissuedate" default="계산서발행일"/>'	, type: 'uniDate'},
			{name: 'ACCOUNT_PRICE'      , text: '<t:message code="system.label.base.accountprice" default="계산서발행금액"/>'	, type: 'int'},
			{name: 'DEV_COST_RECALL'    , text: '<t:message code="system.label.base.devcostrecall" default="개발비용회수율"/>'	, type: 'uniPercent'},
			{name: 'FILE_EXT_01'         , text: 'FILE_EXT_01'	, type: 'string'},
			{name: 'FILE_EXT_02'         , text: 'FILE_EXT_02'	, type: 'string'},
			{name: 'FILE_EXT_03'         , text: 'FILE_EXT_03'	, type: 'string'},
			{name: 'FILE_EXT_04'         , text: 'FILE_EXT_04'	, type: 'string'},
			{name: 'FILE_EXT_05'         , text: 'FILE_EXT_05'	, type: 'string'}

		]
	});




	var masterStore = Unilite.createStore('s_bpr910ukrv_jwMasterStore',{
		model	: 's_bpr910ukrv_jwModel',
	 	proxy	: directProxy,
	 	autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();


			if(inValidRecs.length == 0 )	{
				if(config == null)	{
					config = {success : function() {
						masterStore.loadStoreRecords();
					}};
				}
				this.syncAllDirect(config);
			} else {
		 		 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
	 	listeners: {
			load: function(store, records, successful, eOpts) {
		 		if(!Ext.isEmpty(records)){
	 			}
	 		},
			write: function(proxy, operation){
				if (operation.action == 'destroy') {
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
			},
			remove: function( store, records, index, isMove, eOpts ) {
				if(store.count() == 0) {
				}
			}
		}
	});




	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.common.client" default="고객"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank   : false,
			autoPopup       : true,
            listeners       : {
                applyextparam: function(popup){
                    popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                    popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                }
            }
        }),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.base.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				'applyextparam': function(popup){
					var divCode = panelResult.getValue('DIV_CODE');
					popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.common.receiptdate" default="접수일"/>',
		 	xtype: 'uniDateRangefield',
		 	startFieldName: 'RECEIPT_DATE_FR',
		 	endFieldName: 'RECEIPT_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
	 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
		},{
			fieldLabel	: '<t:message code="system.label.base.developmentlevel" default="개발단계"/>',
			name		: 'DEVELOPMENT_LEVEL',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZN03',
			colspan     :2,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: 'MODEL',
			name: 'MODEL',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: 'PART_NM',
			name: 'PART_NM',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});


	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm',
		api			: {
			submit	: s_bpr910ukrv_jwService.photoUploadFile
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

	//미리보기 관련 윈도우
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
				url			: CPATH + "/fileman/downloadRevInfoImage/" + fid,
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
				beforeshow: function( window, eOpts) {
					window.down('#photView').setSrc(CPATH+'/fileman/downloadRevInfoImage/' + fid);
				},
				show: function( window, eOpts) {
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
				handler	: function() {
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}

	var masterGrid = Unilite.createGrid('s_bpr910ukrv_jwGrid', {
		store	: masterStore,
	 	region	: 'center',
		sortableColumns : true,
		uniOpt	:{
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 93		, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	,
			  'editor': Unilite.popup('AGENT_CUST_G',{
			  	 	textFieldName	: 'CUSTOM_CODE',
			  	 	DBtextFieldName	: 'CUSTOM_CODE',
			  	 	autoPopup		: true,
			  	 	listeners		: {
			  	 		'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
			  	 		},
			  	 		'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
					  	}
			  	 	}
				}),
                listeners       : {
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                        popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                    }
                }
			},
			{dataIndex: 'CUSTOM_NAME'		, width: 133	,
			  'editor': Unilite.popup('AGENT_CUST_G',{
			  	 	autoPopup		: true,
			  	 	listeners		: {
			  	 		'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
					  	'onClear' : function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
						}
			  	 	}
				}),
                listeners       : {
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','3']});
                        popup.setExtParam({'CUSTOM_TYPE'        : ['1','3']});
                    }
                }
			},
			{dataIndex: 'ITEM_CODE'			, width: 110	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
				 	autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'		,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'		,records[0]['ITEM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'		,'');
							grdRecord.set('ITEM_NAME'		,'');
						},
						'applyextparam': function(popup){
							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 150	,
				editor: Unilite.popup('DIV_PUMOK_G',{
				 	autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ITEM_CODE'		,records[0]['ITEM_CODE']);
								grdRecord.set('ITEM_NAME'		,records[0]['ITEM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)  {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ITEM_CODE'		,'');
							grdRecord.set('ITEM_NAME'		,'');
						}
					}
				})
			},
			{dataIndex: 'MODEL'	        , width: 100},
			{dataIndex: 'PART_NAME'	    , width: 100},
			{dataIndex: 'REV_NO'	    , width: 100},
			{dataIndex: 'CUSTOM_REV'	, width: 100},
			{dataIndex: 'INSIDE_REV'	, width: 100},
			{dataIndex: 'RECEIPT_DATE'	, width: 100},
			{ text		: '<t:message code="system.label.base.receiptphoto" default="접수사진"/>',
			 	columns:[
					{ dataIndex	: 'CERT_FILE_01'	, width: 230		, align: 'center'	,
						renderer: function (val, meta, record) {
							if (!Ext.isEmpty(record.data.CERT_FILE_01)) {
								if(record.data.FILE_EXT_01 == 'jpg' || record.data.FILE_EXT_01 == 'png' || record.data.FILE_EXT_01 == 'pdf'){
									return '<font color = "blue" >' + val + '</font>';

								} else {
									var selItemCode	= record.data.ITEM_CODE;
									var revNo	    = record.data.REV_NO;
									var filetype	= '01';
									var specialYn   = 'false';
								 	if(selItemCode.indexOf('#')!= -1){
										selItemCode = selItemCode.replace('#','^^^');
										specialYn = 'true';
									}
									return  '<A href="'+ CHOST + CPATH + '/fileman/downloadRevFile/' + PGM_ID + '/' + selItemCode + '/' + revNo + '/' + filetype + '/' + specialYn  +'">' + val + '</A>';
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
								masterGrid.getSelectionModel().select(record);
								if (!e.record.phantom){
									gsFileType = '01';
									openUploadWindow();
								}else{
										Unilite.messageBox('<t:message code="system.message.base.message034" default="품목 관련 정보를 먼저 등록 저장후, 사진을 업로드 하시기 바랍니다."/>');
										return false;
								}
							}
						}]
					}
				]
			},
			{dataIndex: 'FILE_ID_01'	    , width: 100, hidden:true},
			{ text		: '<t:message code="system.label.base.customerphoto" default="고객접수사진"/>',
			 	columns:[
					{ dataIndex	: 'CERT_FILE_02'	, width: 230		, align: 'center'	,
						renderer: function (val, meta, record) {
							if (!Ext.isEmpty(record.data.CERT_FILE_02)) {
								if(record.data.FILE_EXT_02 == 'jpg' || record.data.FILE_EXT_02 == 'png' || record.data.FILE_EXT_02 == 'pdf'){
									return '<font color = "blue" >' + val + '</font>';
								} else {
									var selItemCode	= record.data.ITEM_CODE;
									var revNo	    = record.data.REV_NO;
									var filetype	= '02';
									var specialYn   = 'false';
								 	if(selItemCode.indexOf('#')!= -1){
										selItemCode = selItemCode.replace('#','^^^');
										specialYn = 'true';
									}
									return  '<A href="'+ CHOST + CPATH + '/fileman/downloadRevFile/' + PGM_ID + '/' + selItemCode + '/' + revNo + '/' + filetype + '/' + specialYn  +'">' + val + '</A>';
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
								masterGrid.getSelectionModel().select(record);
								if (!e.record.phantom){
									gsFileType = '02';
									openUploadWindow();
								}else{
										Unilite.messageBox('<t:message code="system.message.base.message034" default="품목 관련 정보를 먼저 등록 저장후, 사진을 업로드 하시기 바랍니다."/>');
										return false;
								}
							}
						}]
					}
				]
			},
			{dataIndex: 'FILE_ID_02'	    , width: 100, hidden:true},
			{ text		: 'DRAWING',
			 	columns:[
					{ dataIndex	: 'CERT_FILE_03'	, width: 230		, align: 'center'	,
						renderer: function (val, meta, record) {
							if (!Ext.isEmpty(record.data.CERT_FILE_03)) {
								if(record.data.FILE_EXT_03 == 'jpg' || record.data.FILE_EXT_03 == 'png' || record.data.FILE_EXT_03 == 'pdf'){
									return '<font color = "blue" >' + val + '</font>';
								} else {
									var selItemCode	= record.data.ITEM_CODE;
									var revNo	    = record.data.REV_NO;
									var filetype	= '03';
									var specialYn   = 'false';
								 	if(selItemCode.indexOf('#')!= -1){
										selItemCode = selItemCode.replace('#','^^^');
										specialYn = 'true';
									}
									return  '<A href="'+ CHOST + CPATH + '/fileman/downloadRevFile/' + PGM_ID + '/' + selItemCode + '/' + revNo + '/' + filetype + '/' + specialYn  +'">' + val + '</A>';
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
								masterGrid.getSelectionModel().select(record);
								if (!e.record.phantom){
									gsFileType = '03';
									openUploadWindow();
								}else{
										Unilite.messageBox('<t:message code="system.message.base.message034" default="품목 관련 정보를 먼저 등록 저장후, 사진을 업로드 하시기 바랍니다."/>');
										return false;
								}
							}
						}]
					}
				]
			},
			{dataIndex: 'FILE_ID_03'	    , width: 100, hidden:true},
			{dataIndex: 'DEVELOPMENT_LEVEL'	, width: 100},
			{dataIndex: 'RECEIPT_TYPE'	    , width: 100},
			{dataIndex: 'RECEIPT_DETAIL'	, width: 100},
			{dataIndex: 'WKORD_NUM'	        , width: 100},
			{dataIndex: 'WORK_DATE'	        , width: 100},
			{dataIndex: 'WORK_Q'	        , width: 100},
			{dataIndex: 'WOODEN_PATTEN'	    , width: 100},
			{dataIndex: 'WOODEN_ORDER_DATE'	, width: 100},
			{dataIndex: 'WOODEN_UNIT_PRICE'	, width: 100},
			{dataIndex: 'WOODEN_ORDER_YN'	, width: 100},
			{dataIndex: 'SAMPLE_DATE'	    , width: 100},
			{dataIndex: 'SAMPLE_RESULT'	    , width: 100},
			{ text		: '<t:message code="system.label.base.linebadphoto" default="LINE발생 불량현상 사진"/>',
			 	columns:[
					{ dataIndex	: 'CERT_FILE_04'	, width: 230		, align: 'center'	,
						renderer: function (val, meta, record) {
							if (!Ext.isEmpty(record.data.CERT_FILE_04)) {
								if(record.data.FILE_EXT_04 == 'jpg' || record.data.FILE_EXT_04 == 'png' || record.data.FILE_EXT_04 == 'pdf'){
									return '<font color = "blue" >' + val + '</font>';
								} else {
									var selItemCode	= record.data.ITEM_CODE;
									var revNo	    = record.data.REV_NO;
									var filetype	= '04';
									var specialYn   = 'false';
								 	if(selItemCode.indexOf('#')!= -1){
										selItemCode = selItemCode.replace('#','^^^');
										specialYn = 'true';
									}
									return  '<A href="'+ CHOST + CPATH + '/fileman/downloadRevFile/' + PGM_ID + '/' + selItemCode + '/' + revNo + '/' + filetype + '/' + specialYn  +'">' + val + '</A>';
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
								masterGrid.getSelectionModel().select(record);
								if (!e.record.phantom){
									gsFileType = '04';
									openUploadWindow();
								}else{
										Unilite.messageBox('<t:message code="system.message.base.message034" default="품목 관련 정보를 먼저 등록 저장후, 사진을 업로드 하시기 바랍니다."/>');
										return false;
								}
							}
						}]
					}
				]
			},
			{dataIndex: 'FILE_ID_04'	    , width: 100, hidden:true},
			{dataIndex: 'LINE_BAD_DETAIL'	, width: 100},
			{dataIndex: 'IMPROVING_MEASURE'	, width: 100},
			{ text		: '<t:message code="system.label.common.improvingphoto" default="개선사진"/>',
			 	columns:[
					{ dataIndex	: 'CERT_FILE_05'	, width: 230		, align: 'center'	,
						renderer: function (val, meta, record) {
							if (!Ext.isEmpty(record.data.CERT_FILE_05)) {
								if(record.data.FILE_EXT_05 == 'jpg' || record.data.FILE_EXT_05 == 'png' || record.data.FILE_EXT_05 == 'pdf'){
									return '<font color = "blue" >' + val + '</font>';
								} else {
									var selItemCode	= record.data.ITEM_CODE;
									var revNo	    = record.data.REV_NO;
									var filetype	= '05';
									var specialYn   = 'false';
								 	if(selItemCode.indexOf('#')!= -1){
										selItemCode = selItemCode.replace('#','^^^');
										specialYn = 'true';
									}
									return  '<A href="'+ CHOST + CPATH + '/fileman/downloadRevFile/' + PGM_ID + '/' + selItemCode + '/' + revNo + '/' + filetype + '/' + specialYn  +'">' + val + '</A>';
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
								masterGrid.getSelectionModel().select(record);
								if (!e.record.phantom){
									gsFileType = '05';
									openUploadWindow();
								}else{
										Unilite.messageBox('<t:message code="system.message.base.message034" default="품목 관련 정보를 먼저 등록 저장후, 사진을 업로드 하시기 바랍니다."/>');
										return false;
								}
							}
						}]
					}
				]
			},
			{dataIndex: 'FILE_ID_05'	    , width: 100, hidden:true},
			{text	: 'PP DATA',
				columns: [
							{dataIndex: 'PRODT_Q'	        , width: 100},
							{dataIndex: 'BAD_Q'	            , width: 100},
							{dataIndex: 'BAD_RATE'	        , width: 100},
							{dataIndex: 'BAD_CODE1'	        , width: 100},
							{dataIndex: 'BAD_CODE2'	        , width: 100},
							{dataIndex: 'BAD_CODE3'	        , width: 100}
							]
			},
			{dataIndex: 'FABRIC_COST'	    , width: 100},
			{dataIndex: 'SAMPLE_COST'	    , width: 100},
			{dataIndex: 'SAMSUNG_MANAGER'	, width: 100},
			{dataIndex: 'SUBMISSION'	    , width: 100},
			{dataIndex: 'MONEY_UNIT'	    , width: 100},
			{dataIndex: 'ITEM_PRICE'	    , width: 100},
			{dataIndex: 'CUSTOMER_SUBMIT_Q'	, width: 100},
			{dataIndex: 'PRICE'	            , width: 100},
			{dataIndex: 'ACCOUNT_MANAGER'	, width: 100},
			{dataIndex: 'ACCOUNT_YN'	    , width: 100},
			{dataIndex: 'QUOT_DATE'	        , width: 100},
			{dataIndex: 'ACCOUNT_DATE'	    , width: 100},
			{dataIndex: 'ACCOUNT_PRICE'	    , width: 100},
			{dataIndex: 'DEV_COST_RECALL'	, width: 100},
			{dataIndex: 'FILE_EXT_01'	    , width: 100, hidden:true},
			{dataIndex: 'FILE_EXT_02'	    , width: 100, hidden:true},
			{dataIndex: 'FILE_EXT_03'	    , width: 100, hidden:true},
			{dataIndex: 'FILE_EXT_04'	    , width: 100, hidden:true},
			{dataIndex: 'FILE_EXT_05'	    , width: 100, hidden:true}

		],
		listeners: {
	  		beforeedit  : function( editor, e, eOpts ) {
	  			if (!e.record.phantom){
		  			if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'ITEM_CODE', 'ITEM_NAME', 'REV_NO', 'SAMPLE_COST', 'DEV_COST_RECALL', 'CERT_FILE_01', 'CERT_FILE_02', 'CERT_FILE_03', 'CERT_FILE_04', 'CERT_FILE_05'])){
						return false;
					}
	  			}
				else{
		  			if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'REV_NO', 'SAMPLE_COST', 'DEV_COST_RECALL', 'CERT_FILE_01', 'CERT_FILE_02', 'CERT_FILE_03', 'CERT_FILE_04', 'CERT_FILE_05'])){
						return false;
					}

				}
	  		},
			selectionchangerecord:function(selected)	{
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(cellIndex == 13 && !Ext.isEmpty(record.get('CERT_FILE_01'))) {
					fid = record.data.FILE_ID_01
					var fileExtension	= record.get('CERT_FILE_01').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE_01').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadRevInfoImage/' + fid,
							prgID	: 's_bpr910ukrv_jw'
						});
						win.center();
						win.show();

					} else if(fileExt == 'jpg' || fileExt == 'png') {
						openPhotoWindow();
					} else {
					}
				}

				if(cellIndex == 16 && !Ext.isEmpty(record.get('CERT_FILE_02'))) {
					fid = record.data.FILE_ID_02
					var fileExtension	= record.get('CERT_FILE_02').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE_02').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadRevInfoImage/' + fid,
							prgID	: 's_bpr910ukrv_jw'
						});
						win.center();
						win.show();

					} else if(fileExt == 'jpg' || fileExt == 'png') {
						openPhotoWindow();
					} else {
					}
				}

				if(cellIndex == 19 && !Ext.isEmpty(record.get('CERT_FILE_03'))) {
					fid = record.data.FILE_ID_03
					var fileExtension	= record.get('CERT_FILE_03').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE_03').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadRevInfoImage/' + fid,
							prgID	: 's_bpr910ukrv_jw'
						});
						win.center();
						win.show();

					} else if(fileExt == 'jpg' || fileExt == 'png') {
						openPhotoWindow();
					} else {
					}
				}

				if(cellIndex == 34 && !Ext.isEmpty(record.get('CERT_FILE_04'))) {
					fid = record.data.FILE_ID_04
					var fileExtension	= record.get('CERT_FILE_04').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE_04').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadRevInfoImage/' + fid,
							prgID	: 's_bpr910ukrv_jw'
						});
						win.center();
						win.show();

					} else if(fileExt == 'jpg' || fileExt == 'png') {
						openPhotoWindow();
					} else {
					}
				}

				if(cellIndex == 39 && !Ext.isEmpty(record.get('CERT_FILE_05'))) {
					fid = record.data.FILE_ID_05
					var fileExtension	= record.get('CERT_FILE_05').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE_05').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadRevInfoImage/' + fid,
							prgID	: 's_bpr910ukrv_jw'
						});
						win.center();
						win.show();

					} else if(fileExt == 'jpg' || fileExt == 'png') {
						openPhotoWindow();
					} else {
					}
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {

			}
		}
	});


	Unilite.Main({
		id			: 's_bpr910ukrv_jwApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],

		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['newData'],true);

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');

			this.setDefault();
		},

		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
		},

		onNewDataButtonDown : function()	{
			var r = {
				COMP_CODE		: UserInfo.compCode,
				DIV_CODE		: panelResult.getValue('DIV_CODE')
			};
			masterGrid.createRow(r, null, masterStore.getCount() - 1);
		},

		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true)	{
				masterGrid.deleteSelectedRow();

			} else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},

		onSaveDataButtonDown: function (config) {
			//필수 입력값 체크
			if (!panelResult.getInvalidMessage()) {
				return false;
			}
			masterStore.saveStore(config);
		},

		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			this.fnInitBinding();
		},

		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},

		setDefault: function() {
	 		panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
	 		panelResult.setValue('RECEIPT_DATE'	, UniDate.get('today'));
	 		panelResult.setValue('WORK_DATE'	, UniDate.get('today'));
		}

	});



	function fnPhotoSave() {				//이미지 등록
		//조건에 맞는 내용은 적용 되는 로직
		var record		= masterGrid.getSelectedRecord();
		var photoForm	= uploadWin.down('#photoForm').getForm();
		var param		= {
			ITEM_CODE	: record.data.ITEM_CODE,
			FILE_TYPE	: gsFileType,
			REV_NO      : record.data.REV_NO
		}
		photoForm.submit({
			params	: param,
			waitMsg	: 'Uploading your files...',
			success	: function(form, action) {
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
							submit: s_bpr910ukrv_jwService.photoUploadFile
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
					beforeshow: function( window, eOpts) {
						var record	= masterGrid.getSelectedRecord();
						if(Ext.isEmpty(record.data.ITEM_CODE)){
							Unilite.messageBox('<t:message code="system.message.base.message004" default="품목 관련 정보를 입력하신 후, 사진을 업로드 하시기 바랍니다."/>');
							return false;
						}

					},
					show: function( window, eOpts) {
						window.center();
					}
				},
				afterSuccess: function() {
					var record	= masterGrid.getSelectedRecord();
					this.afterSavePhoto();
					masterStore.loadStoreRecords();
				},
				afterSavePhoto: function() {
					var photoForm = uploadWin.down('#photoForm');
					photoForm.clearForm();
					uploadWin.hide();
				},
				tbar:['->',{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.upload" default="올리기"/>',
					handler	: function() {
						var photoForm	= uploadWin.down('#photoForm');

						if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
							Unilite.messageBox('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
							return false;
						}

						//jpg파일만 등록 가능
						var filePath		= photoForm.getValue('photoFile');
						var fileExtension	= filePath.lastIndexOf( "." );
						var fileExt			= filePath.substring( fileExtension + 1 );

						fnPhotoSave();

					}
				},{
					xtype	: 'button',
					text	: '<t:message code="system.label.base.close" default="닫기"/>',
					handler	: function() {

							uploadWin.afterSavePhoto();

							uploadWin.hide();

					}
				}]
			});
		}
		uploadWin.show();
	}

	/*	{name: 'PRODT_Q'            , text: '<t:message code="system.label.common.productionqty" default="생산량"/>'	, type: 'uniQty'},
			{name: 'BAD_Q'              , text: '<t:message code="system.label.base.defectqty" default="불량수량"/>'	, type: 'uniQty'},
			{name: 'BAD_RATE' */

	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				 case "PRODT_Q" :
		                if(newValue == 0){
		                	return false;
		                }
		                var badRate = (record.get('BAD_Q') / newValue) * 100
	                	record.set('BAD_RATE', badRate);
	                    break;

	              case "BAD_Q" :
						if(record.get('PRODT_Q') == 0){
		                	return false;
		                }
	    				var badRate = (newValue / record.get('PRODT_Q')) * 100
	                	record.set('BAD_RATE', badRate);
	                    break;

	              case "FABRIC_COST" :
	    				var sampleCost = newValue + record.get('WOODEN_UNIT_PRICE')
	                	record.set('SAMPLE_COST', sampleCost);
	                    break;

	              case "WOODEN_UNIT_PRICE" :
	    				var sampleCost = newValue + record.get('FABRIC_COST')
	                	record.set('SAMPLE_COST', sampleCost);
	                    break;

	              case "ACCOUNT_PRICE" :
						if(record.get('SAMPLE_COST') == 0){
		                	return false;
		                }
	    				var recallRate = (newValue / record.get('SAMPLE_COST')) * 100
	                	record.set('DEV_COST_RECALL', recallRate);
	                    break;

	              case "SAMPLE_COST" :
		                if(newValue == 0){
		                	return false;
		                }
		                var recallRate = (record.get('ACCOUNT_PRICE') / newValue) * 100
	                	record.set('DEV_COST_RECALL', recallRate);
	                    break;
			}
			return rv;
		}
	})

};
</script>