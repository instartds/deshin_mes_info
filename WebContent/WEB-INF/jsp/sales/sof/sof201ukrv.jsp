<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof201ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="sof201ukrv"/><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>		<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>		<!-- 영업담당 -->
</t:appConfig>
<script type="text/javascript">
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sof201ukrvService.selectList',
			update	: 'sof201ukrvService.updateMulti',
			syncAll	: 'sof201ukrvService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('sof201ukrvModel', {
		fields: [
			{name: 'CUSTOM_CODE'	, text: '거래처'	, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'	, type: 'string'},
			{name: 'ITEM_CODE'		, text: '품목코드'	, type: 'string'},
			{name: 'ITEM_NAME'		, text: '품목명'	, type: 'string'},
			{name: 'SPEC'			, text: '규격'	, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '단위'	, type: 'string'},
			{name: 'TRANS_RATE'		, text: '입수'	, type: 'string'},
			{name: 'ORDER_UNIT_Q'	, text: '수주량'	, type: 'uniQty'},
			{name: 'DVRY_DATE'		, text: '납기일'	, type: 'uniDate'},
			{name: 'NOT_ISSUE_QTY'	, text: '미납량'	, type: 'uniQty'},
			{name: 'ORDER_P'		, text: '단가'	, type: 'uniPrice'},
			{name: 'ORDER_O'		, text: '금액'	, type: 'uniPrice'},
			{name: 'ORDER_DATE'		, text: '수주일'	, type: 'uniDate'},
			{name: 'ORDER_NUM'		, text: '수주번호'	, type: 'string'},
			{name: 'SER_NO'			, text: '순번'	, type: 'string'},
			{name: 'ORDER_PRSN'		, text: '영업담당'	, type: 'string',comboType:'AU', comboCode:'S010'},
			{name: 'REMARK'			, text: '비고'	, type: 'string'},
			{name: 'REMARK_INTER'	, text: '내부비고'	, type: 'string'}
		]
	});

	/* store 정의
	*/
	var directMasterStore = Unilite.createStore('sof201ukrvMasterStore',{
		model	: 'sof201ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		//Store 관련 BL 로직
		//검색 조건을 통해 DB에서 데이타 읽어 오기 
		loadStoreRecords : function() {
			var param= Ext.getCmp('sof201ukrvPanelResult').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		//수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var paramMaster= panelResult.getValues(); 
			if(inValidRecs.length == 0 ) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			}
 		}
 	});	

	var panelResult = Unilite.createSearchForm('sof201ukrvPanelResult',{
		layout	: {type : 'uniTable' , columns: 3 },
		items	:[{
			fieldLabel	: '사업장',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE',
			comboType	: 'BOR120',
			value		: '01',
			allowBlank	: false
		},{
			fieldLabel		: '납기일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'DVRY_DATE_FR',
			endFieldName	: 'DVRY_DATE_TO',
			width			: 350,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('tomorrow'),
			allowBlank		: false
		},{
			fieldLabel	: '판매유형',
			xtype		: 'uniCombobox',
			name		: 'ORDER_TYPE',
			comboType	: 'AU', 
			comboCode	: 'S002'
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '거래처' ,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			colspan			: 2,
			validateBlank	: false ,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{ 
			fieldLabel	: '영업담당',
			xtype		: 'uniCombobox',
			name		: 'ORDER_PRSN',
			comboType	: 'AU',
			comboCode	: 'S010'
		}],
		setAllFieldsReadOnly: function(b) {//필수조건검색 공란일시 메시지출력
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					// this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				// this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('sof201ukrvMasterGrid', {
		store	: directMasterStore,
		region	: 'center',
		tbar	: [{
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			margin		: '0 5 0 0',
			id			: 'upD',
			labelAlign	: 'right',
			fieldLabel	: '납기일',
			allowBlank	: false
		},{
			xtype	: 'button',
			margin	: '0 50 0 0',
			text	: "<div style='color: blue'>일괄변경</div>",
			handler	: function(){
				var masterGridRecord = masterGrid.getSelectedRecords();	 
				if(!Ext.isEmpty(masterGridRecord)){
					Ext.each(masterGridRecord, function(masterGridRecord, index) {
						masterGridRecord.set('DVRY_DATE',Ext.getCmp('upD').getValue());
					});
				}
			}
		}],
		uniOpt: {
			useContextMenu		: false,
			expandLastColumn	: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer		: false,	//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,		//찾기 버튼 사용 여부
			useRowContext		: false,
			onLoadSelectFirst	: false,
			filter				: {			//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts){
				},
				deselect: function(grid, selectRecord, index, eOpts){
					if(directMasterStore.isDirty()){
						if(!Ext.isEmpty(selectRecord.modified)){
							var oldRecord1 = UniDate.getDateStr(selectRecord.modified.DVRY_DATE);
							var oldRecord2 = selectRecord.modified.REMARK;
							var oldRecord3 = selectRecord.modified.REMARK_INTER;
							if(!Ext.isEmpty(oldRecord1)) {
								selectRecord.set('DVRY_DATE',oldRecord1);
							}
							if(!Ext.isEmpty(oldRecord2)) {
								selectRecord.set('REMARK',oldRecord2);
							}
							if(!Ext.isEmpty(oldRecord3)) {
								selectRecord.set('REMARK_INTER',oldRecord3);
							}
						}
					}
 				}
			}
		}),
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns:[
//			{xtype:'checkcolumn' ,dataIndex: 'CHK' ,width: 30, hidden:false},
			{dataIndex: 'CUSTOM_CODE'	, width:100},				//거래처
			{dataIndex: 'CUSTOM_NAME'	, width:150},				//거래처명
			{dataIndex: 'ITEM_CODE'		, width:100},				//품목코드
			{dataIndex: 'ITEM_NAME'		, width:150},				//품목명
			{dataIndex: 'SPEC'			, width:150},				//규격
			{dataIndex: 'ORDER_UNIT'	, width:66},				//단위
			{dataIndex: 'TRANS_RATE'	, width:66, align:'right'},	//입수
			{dataIndex: 'ORDER_UNIT_Q'	, width:100},				//수주량
			{dataIndex: 'DVRY_DATE'		, width:100},				//납기일
			{dataIndex: 'NOT_ISSUE_QTY'	, width:100},				//미납량
			{dataIndex: 'ORDER_P'		, width:100},				//단가
			{dataIndex: 'ORDER_O'		, width:120},				//금액
			{dataIndex: 'ORDER_DATE'	, width:100},				//수주일
			{dataIndex: 'ORDER_NUM'		, width:120},				//수주번호
			{dataIndex: 'SER_NO'		, width:50, align:'right'},	//순번
			{dataIndex: 'ORDER_PRSN'	, width:80},				//영업담당
			{dataIndex: 'REMARK'		, width:150},				//비고
			{dataIndex: 'REMARK_INTER'	, width:150}				//내부비고
		],
		listeners:{
			afterrender: function(grid) {
				var me = this;
				//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '수주등록 바로가기',
					iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender		: me,
							'PGM_ID'	: 'sof100skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							ORDER_NUM	: record.data.ORDER_NUM
						}
						var rec = {data : {prgID : 'sof100ukrv', 'text':''}};
						parent.openTab(rec, '/sales/sof100ukrv.do', params);
					}
				});
			},
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'ITEM_CODE', 'ITEM_NAME', 'SPEC',
											'ORDER_UNIT', 'TRANS_RATE', 'ORDER_UNIT_Q', 'NOT_ISSUE_QTY', 'ORDER_P',
											'ORDER_O', 'ORDER_DATE', 'ORDER_NUM', 'SER_NO', 'ORDER_PRSN'])) {
					return false;
				}
			},
			edit: function( editor, e, eOpts ) {
				var records = directMasterStore.data.items;
					data = new Object();
					data.records = [];
				Ext.each(records, function(record,idx) {
					if(record.dirty){
						data.records.push(record);
					}
				});
				masterGrid.getSelectionModel().select(data.records);
			}
		}
	});



	/* Main
	*/
	Unilite.Main({
		id		: 'sof201ukrvApp',
		items	: [panelResult, 	masterGrid],
		fnInitBinding : function() {
			getSelectedRecords = null;
			UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DVRY_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('DVRY_DATE_TO'	, UniDate.get('tomorrow'));
		},
		onQueryButtonDown : function() {
			var isTrue = panelResult.setAllFieldsReadOnly(true);
			if(!isTrue){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown:function() {
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			UniAppManager.setToolbarButtons('save', false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {
			directMasterStore.saveStore();
		}
	});
};
</script>