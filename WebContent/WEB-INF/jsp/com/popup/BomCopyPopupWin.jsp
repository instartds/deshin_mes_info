<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
	//  BOM 참조 'Unilite.app.popup.BomCopyPopupWin'
	request.setAttribute("PKGNAME","Unilite.app.popup.BomCopyPopup");
%>
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B020" />	// '품목계정
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B013"/>	// 단위
	<t:ExtComboStore useScriptTag="false" comboType="AU" comboCode="B083"  /> 		<!-- BOM PATH 정보 -->
	<t:ExtComboStore useScriptTag="false" comboType="BOR120" />				// 사업장

	var bsaInfo={
		'gsBomPathYN'  	:'${gsBomPathYN}',			//BOM PATH 관리여부(B082)
		'gsExchgRegYN' 	:'${gsExchgRegYN}'			//대체품목 등록여부(B081)
	}

	/** Model 정의
	 */
	Unilite.defineModel('${PKGNAME}getBomCopyPopupModel', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.common.companycode" default="법인코드"/>' 		,type: 'string' , defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.common.division" default="사업장"/>' 			,type: 'string', defaultValue: UserInfo.divCode},
			{name: 'SEQ'			,text: '<t:message code="system.label.common.seq" default="순번"/>' 					,type: 'int'},
			{name: 'PROD_ITEM_CODE'	,text: '내용물코드'		,type: 'string'},
			{name: 'ITEM_ACCOUNT'	,text: '<t:message code="system.label.common.itemaccount" default="품목계정"/>' 		,type: 'string'},
			{name: 'CHILD_ITEM_CODE',text: '<t:message code="system.label.common.childitemcode" default="자품목코드"/>'		,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.common.itemname" default="품목명"/>' 			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.common.spec" default="규격"/>' 					,type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.common.unit" default="단위"/>' 					,type: 'string', comboType:'AU' ,comboCode:'B013', displayField: 'value'},
			{name: 'PATH_CODE'		,text: '<t:message code="system.label.common.pathinfo" default="PATH정보"/>'			,type: 'string', comboType:'AU' ,comboCode:'B083', defaultValue:'0'},
			{name: 'UNIT_Q'			,text: '<t:message code="system.label.common.originunitqty" default="원단위량"/>'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000', defaultValue:1},
			{name: 'PROD_UNIT_Q'	,text: '<t:message code="system.label.common.parentitembaseqty" default="모품목기준수"/>'	,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000', defaultValue:1},
			{name: 'LOSS_RATE'		,text: '<t:message code="system.label.common.lossrate" default="LOSS율"/>' 			,type: 'uniPercent', defaultValue:0},
			{name: 'UNIT_P1'		,text: '<t:message code="system.label.common.materialcost" default="재료비"/>' 		,type: 'uniPrice', defaultValue:0},
			{name: 'UNIT_P2'		,text: '<t:message code="system.label.common.laborexpenses" default="노무비"/>' 		,type: 'uniPrice', defaultValue:0},
			{name: 'UNIT_P3'		,text: '<t:message code="system.label.common.expense" default="경비"/>' 				,type: 'uniPrice', defaultValue:0},
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.common.standardtacttime" default="표준공수"/>' 	,type: 'uniQty', defaultValue:0},
			{name: 'USE_YN'			,text: '<t:message code="system.label.common.use" default="사용"/>' 					,type: 'string'  , defaultValue:'1' ,store: Ext.data.StoreManager.lookup('bpr560ukrvBPRYnStore')},
			{name: 'BOM_YN'			,text: '<t:message code="system.label.common.compyn" default="구성여부"/>' 				,type: 'string'	 , defaultValue:'1' ,store: Ext.data.StoreManager.lookup('bpr560ukrvBPRYnStore')},
			{name: 'START_DATE'		,text: '<t:message code="system.label.common.compstartdate" default="구성시작일"/>'		,type: 'uniDate' ,allowBlank:false, defaultValue: UniDate.get('today')},
			{name: 'STOP_DATE'		,text: '<t:message code="system.label.common.compenddate" default="구성종료일"/>' 		,type: 'uniDate', defaultValue: '2999.12.31'},
			{name: 'REMARK'			,text: '<t:message code="system.label.common.remarks" default="비고"/>' 				,type: 'string'},
			{name: 'LAB_NO'			,text: 'LAB NO'		,type: 'string'},
			{name: 'REQST_ID'		,text: '샘플ID'		,type: 'string'},
			{name: 'SET_QTY'		,text: '<t:message code="system.label.common.stockcountingusagerate" default="실사용률(%)"/>'		,type: 'number', defaultValue:0},
			{name: 'MATERIAL_CNT'	,text: '<t:message code="system.label.common.qty" default="수량"/>'					,type: 'int'},
			{name: 'REQST_ID'		,text: '샘플ID'		,type: 'string'},
			{name: 'GROUP_CODE'		,text: '<t:message code="system.label.base.routinggroup" default="공정그룹"/>'			,type: 'string'  , comboType: 'AU', comboCode:'B140'}
		]
	});


Ext.define('${PKGNAME}', {
	extend: 'Unilite.com.BaseJSPopupApp',
	constructor : function(config){
		var me = this;
		if (config) {
			Ext.apply(me, config);
		}
		/** 검색조건 (Search Panel)
		 * @type
		 */
		var wParam = this.param;
		var t1= false, t2 = false;
		if( Ext.isDefined(wParam)) {
			if(wParam['POPUP_TYPE'] == 'GRID_CODE') {
				t1 = true;
				t2 = false;
			}else {
				if(wParam['TYPE'] == 'VALUE') {
					t1 = true;
					t2 = false;
				} else {
					t1 = false;
					t2 = true;
				}
			}
		}
		me.panelSearch = Unilite.createSearchForm('',{
			layout	: {type : 'uniTable', columns : 2, tableAttrs: {
				/*style: {
					width: '100%'
				}*/
			}},
			items	: [{
				fieldLabel	: '<t:message code="system.label.common.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false,
				colspan		: 2
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.common.parentitemcode" default="모품목코드"/>',
				valueFieldName	: 'PROD_ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				valueFieldWidth	: 100,
				textFieldWidth	: 170,
				allowBlank		: false,
				listeners		: {
						onSelected: {
							fn: function(records, type) {
								me.panelSearch.setValue('PROD_ITEM_CODE', records[0]['ITEM_CODE']);
								me.panelSearch.setValue('ITEM_NAME'		, records[0]['ITEM_NAME']);
								me.panelSearch.setValue('SPEC'			, records[0]['SPEC']);
							},
							scope: this
						},
						onClear: function(type)	{
							me.panelSearch.setValue('PROD_ITEM_CODE', '');
							me.panelSearch.setValue('ITEM_NAME'		, '');
							me.panelSearch.setValue('SPEC'			, '');
						},
						applyextparam: function(popup){
							if(Ext.isDefined(me.panelSearch)){
								popup.setExtParam({'DIV_CODE'				: me.panelSearch.getValue("DIV_CODE")});
								popup.setExtParam({'ITEM_ACCOUNT_FILTER'	: ['10', '20']});	/// 점검필요
								//20190916 - 조회 테이블이 BPR580T일 경우, 기본 품목계정을 30으로 set: 아직은 사용 안 함, 추후 사용 예정
								if(me.panelSearch.getValue('TABLE_NAME') == 'BPR580T') {
									popup.setExtParam({'DEFAULT_ITEM_ACCOUNT'	: '30'});
								}
							}
						}
					}
			}),{
				name	: 'SPEC',
				xtype	: 'uniTextfield',
				hideLabel: true,
				readOnly: true
			},{
				//20190520 조회할 테이블
				name	: 'TABLE_NAME',
				xtype	: 'uniTextfield',
				hidden	: true
			},{
				//20190520 조회할 데이터 (모품목, 자푸목 구분)
				name	: 'PROD_ITEM_YN',
				xtype	: 'uniTextfield',
				hidden	: true
			}]
		});


		/** Master Grid 정의(Grid Panel)
		 * @type
		 */
		var masterGridConfig = {
			store : Unilite.createStoreSimple('${PKGNAME}getBomCopyPopupStore',{
				model	: '${PKGNAME}getBomCopyPopupModel',
				autoLoad: false,
				proxy	: {
					type: 'direct',
					api	: {
						read: 'popupService.getBomCopyPopup'
					}
				}
			}),
			uniOpt:{
				onLoadSelectFirst	: false,
				useRowNumberer		: false,
				state				: {
					useState	: false,
					useStateList: false
				},
				pivot : {
					use : false
				}
			},
//			selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }),
			columns	:  [
				{ dataIndex: 'COMP_CODE'		,width: 66  , hidden: true},
				{ dataIndex: 'DIV_CODE'			,width: 66  , hidden: true},
				{ dataIndex: 'LAB_NO'			,width: 133 , hidden: true},
				{ dataIndex: 'SEQ'				,width: 60  , hidden: true},
				{ dataIndex: 'PROD_ITEM_CODE'	,width: 120 , hidden: true},
				{ dataIndex: 'ITEM_ACCOUNT'		,width: 66  , hidden: true},
				{ dataIndex: 'CHILD_ITEM_CODE'	,width: 120 , hidden: true},
				{ dataIndex: 'ITEM_NAME'		,width: 133 },
				{ dataIndex: 'SPEC'				,width: 170 },
				{ dataIndex: 'STOCK_UNIT'		,width: 60  , align: 'center'},
				{ dataIndex: 'OLD_PATH_CODE'	,width: 10  , hidden: true},
				{ dataIndex: 'PATH_CODE'		,width: 90  , hidden: true},
				{ dataIndex: 'UNIT_Q'			,width: 120 },
				{ dataIndex: 'PROD_UNIT_Q'		,width: 110 },
				{ dataIndex: 'GROUP_CODE'		,width: 100 , align: 'center'},
				{ dataIndex: 'LOSS_RATE'		,width: 66  },
				{ dataIndex: 'SET_QTY'			,width: 100 },
				{ dataIndex: 'MATERIAL_CNT'		,width: 80 },
				{ dataIndex: 'UNIT_P1'			,width: 66  },
				{ dataIndex: 'UNIT_P2'			,width: 66  },
				{ dataIndex: 'UNIT_P3'			,width: 66  },
				{ dataIndex: 'MAN_HOUR'			,width: 66  },
				{ dataIndex: 'USE_YN'			,width: 66  },
				{ dataIndex: 'BOM_YN'			,width: 66  },
				{ dataIndex: 'START_DATE'		,width: 100 },
				{ dataIndex: 'STOP_DATE'		,width: 100 },
				{ dataIndex: 'REMARK'			,width: 226 },
				{ dataIndex: 'UPDATE_DB_USER'	,width: 66  , hidden: true},
				{ dataIndex: 'UPDATE_DB_TIME'	,width: 66  , hidden: true}
			],
			listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					var rv = {
						status : "OK",
						data:[record.data]
					};
					me.returnData(rv);
				},
				onGridKeyDown: function(grid, keyCode, e) {
					if(e.getKey() == Ext.EventObject.ENTER) {
						var selectRecord = grid.getSelectedRecord();
						var rv = {
							status : "OK",
							data:[selectRecord.data]
						};
						me.returnData(rv);
					}
				}
			}
		};

		if(Ext.isDefined(wParam)) {
			if(wParam['SEL_MODEL'] == 'MULTI') {
				masterGridConfig.selModel = Ext.create("Ext.selection.CheckboxModel", { checkOnly : false });
			}
		}

		me.masterGrid = Unilite.createGrid('', masterGridConfig);


		// -----------------------
		config.items = [me.panelSearch, me.masterGrid];
		me.callParent(arguments);
	}, //constructor
	initComponent : function(){
		var me  = this;
		me.masterGrid.focus();
		this.callParent();
	},
	fnInitBinding : function(param) {
		//var param = window.dialogArguments;
		var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;
		var frm= panelSearch.getForm();

		var rdo = frm.findField('rdoRadio');
		var fieldTxt = frm.findField('ITEM_SEARCH');

		if( Ext.isDefined(param)) {
			if(fieldTxt && Ext.isDefined(fieldTxt) && fieldTxt.isFormField) {
				if(param['POPUP_TYPE'] == 'GRID_CODE')	{
					fieldTxt.setValue(param['ITEM_CODE']);
					fieldTxt.setFieldLabel( '품목코드' );
					rdo.setValue('1');
				}else {
					if(param['TYPE'] == 'VALUE') {
						fieldTxt.setValue(param['ITEM_CODE']);
						fieldTxt.setFieldLabel( '품목코드' );
						rdo.setValue('1');
					} else {
						fieldTxt.setValue(param['ITEM_NAME']);
						fieldTxt.setFieldLabel( '품목명' );
						rdo.setValue('2');
					}
				}
				if(param['DIV_CODE'])	{
					frm.findField('DIV_CODE').setValue(param['DIV_CODE']);
				}
				if(param['PROD_ITEM_CODE'])	{
					frm.findField('PROD_ITEM_CODE').setValue(param['PROD_ITEM_CODE']);
					this._dataLoad();
				}
			}
			frm.setValues(param);

			//20190520 처방등록, 전성분 조회에서 호출 시 테이블 변경 (BPR580T)
			if(!Ext.isEmpty(param['TABLE_NAME']))	{
				frm.findField('TABLE_NAME').setValue(param['TABLE_NAME']);
				//20190916 - LAB_NO 컬럼 보이지 않게 처리
//				masterGrid.getColumn("LAB_NO").show();
			} else {
				frm.findField('TABLE_NAME').setValue('BPR500T');
			}

			//20190521 처방등록, 전성분 조회에서 호출 시 조회 데이터 구분(전성분조회: 모품목, 처방등록: 자품목)
			if(!Ext.isEmpty(param['PROD_ITEM_YN']))	{
				frm.findField('PROD_ITEM_YN').setValue(param['PROD_ITEM_YN']);
				masterGrid.getColumn("PROD_ITEM_CODE").show();
			} else {
				frm.findField('PROD_ITEM_YN').setValue('');
				masterGrid.getColumn("CHILD_ITEM_CODE").show();
				masterGrid.getColumn("SEQ").show();
			}

			var sType = param['sType'];
			if(sType == "T")	{
				masterGrid.getColumn("HS_NO").show();
				masterGrid.getColumn("HS_NAME").show();
				masterGrid.getColumn("HS_UNIT").show();
			}
			//20190521 너무 많은 데이터 조회되기 때문에 조회조건 있을 때만 조회되도록 수정
			if(!Ext.isEmpty(panelSearch.getValue('PROD_ITEM_CODE'))) {
				this._dataLoad();
			}
		}
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
		var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;
		var selectRecords = masterGrid.getSelectedRecords();
		var rvRecs= new Array();
		Ext.each(selectRecords, function(record, i)	{
			rvRecs[i] = record.data;
		})
	 	var rv = {
			status : "OK",
			data:rvRecs
		};

		me.returnData(rv);
	},
	_dataLoad : function() {
		var me = this,
			masterGrid = me.masterGrid,
			panelSearch = me.panelSearch;
		if(panelSearch.isValid())	{
			var param= panelSearch.getValues();
			console.log( param );
			me.isLoading = true;
			masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	}
});
