<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr581skrv">
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B083"/>		<!-- BOM PATH 정보 -->
	<t:ExtComboStore comboType="AU" comboCode="B018"/>		<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>		<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>		<!-- 예/아니오 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var BsaCodeInfo={
		'gsBomPathYN'	:'${gsBomPathYN}',			//BOM PATH 관리여부(B082)
		'gsExchgRegYN'	:'${gsExchgRegYN}',			//대체품목 등록여부(B081)
		'gsItemCheck'	:'PROD'						//품목구분(PROD:모품목, CHILD:자품목)
	}


	/** proxy 정의
	 * @type
	 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 'bpr581skrvService.selectList2'
//			update	: 'bpr581skrvService.updateDetail',
//			create  : 'bpr581skrvService.insertDetail',
//			destroy : 'bpr581skrvService.deleteDetail',
//			syncAll : 'bpr581skrvService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('bpr581skrvModel', {
		fields: [
			{name: 'parentId'			,text:'<t:message code="system.label.base.parentid" default="상위소속"/>'					,type:'string'	 ,editable:false   },
			{name: 'DIV_CODE'			,text:'<t:message code="system.label.base.division" default="사업장"/>'					,type:'string'},
			{name: 'PROD_ITEM_CODE'		,text:'<t:message code="system.label.base.parentitemcode" default="모품목코드"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>'					,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.base.itemname" default="품목명"/>'					,type:'string'},
			{name: 'SPEC'				,text:'<t:message code="system.label.base.spec" default="규격"/>'							,type:'string'},
			{name: 'STOCK_UNIT'			,text:'<t:message code="system.label.base.unit" default="단위"/>'							,type:'string'},
			{name: 'UNIT_Q'				,text:'<t:message code="system.label.base.originunitqty" default="원단위량"/>'				,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PROD_UNIT_Q'		,text:'<t:message code="system.label.base.parentitembaseqty" default="모품목기준수"/>'		,type:'uniQty'},
			{name: 'LOSS_RATE'			,text:'<t:message code="system.label.base.lossrate" default="LOSS율"/>'					,type:'uniPercent'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		,text:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>'	,type : 'string',comboType:'AU', comboCode:'B014'},
			{name: 'START_DATE'			,text:'<t:message code="system.label.base.compstartdate" default="구성시작일"/>'				,type:'uniDate'},
			{name: 'STOP_DATE'			,text:'<t:message code="system.label.base.compenddate" default="구성종료일"/>'				,type:'uniDate'},
			{name: 'PATH_CODE'			,text:'<t:message code="system.label.base.pathinfo" default="PATH정보"/>'					,type:'string'},
			{name: 'BOM_YN'				,text:'<t:message code="system.label.base.bomcomp" default="BOM구성"/>'					,type:'string', comboType:'AU',comboCode:'B018'},
			{name: 'USE_YN'				,text:'<t:message code="system.label.base.photoflag" default="사진유무"/>'					,type:'string', comboType:'AU',comboCode:'B018'},
			{name: 'MAN_HOUR'			,text:'<t:message code="system.label.base.standardtacttime" default="표준공수"/>'			,type:'uniER'},
			{name: 'UNIT_P1'			,text:'<t:message code="system.label.base.materialcost" default="재료비"/>'				,type:'uniUnitPrice'},
			{name: 'UNIT_P2'			,text:'<t:message code="system.label.base.laborexpenses" default="노무비"/>'				,type:'uniUnitPrice'},
			{name: 'UNIT_P3'			,text:'<t:message code="system.label.base.expense" default="경비"/>'						,type:'uniUnitPrice'},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.base.maincustom" default="주거래처"/>'					,type:'string'},
			{name: 'SUB_FLAG'			,text:'<t:message code="system.label.base.sub_flag" default="대체구분"/>'					,type:'string'},
			{name: 'SEQ'				,text:'<t:message code="system.label.base.seq" default="순번"/>'							,type:'string'},
			//{name: 'ITEM_ACCOUNT'		,text:'<t:message code="system.label.base.accountclass" default="계정구분"/>'				,type:'string'},
			{name: 'INTENS_Q'			,text:'INTENS_Q'		,type:'uniQty'},
			{name: 'SPEC_NUM'			,text:'<t:message code="system.label.base.drawingnumber" default="도면번호"/>'				,type:'string'},
			{name: 'STOCK_Q'			,text:'<t:message code="system.label.base.onhandstock" default="현재고"/>'					,type:'uniQty'},
			{name: 'LVL'				,text:'<t:message code="system.label.base.level" default="레벨"/>'						,type:'int'},
			{name: 'REMARK'				,text:'<t:message code="system.label.base.remarks" default="비고"/>'						,type:'string'},
			//20180528 추가
			{name: 'MATERIAL_CNT'		,text: '<t:message code="system.label.base.qty" default="수량"/>'							,type: 'int'},
			{name: 'SET_QTY'			,text: '<t:message code="system.label.base.setqty" default="조시용"/>'						,type: 'uniQty'},
			//20190621 구매단가 추가
			{name: 'PURCHASE_BASE_P'	,text:'<t:message code="system.label.base.purchaseprice" default="구매단가"/>'				,type: 'uniUnitPrice'},
			//20210622 평균단가 추가
			{name: 'AVERAGE_P'			,text:'<t:message code="system.label.base.averageprice" default="평균단가"/>'				,type: 'uniUnitPrice'}			
		]
	});

	Unilite.defineModel('Bpr581skrvModel1', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type: 'string', defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.base.division" default="사업장"/>'			,type: 'string', defaultValue: UserInfo.divCode},
			{name: 'PROD_ITEM_CODE'		,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'			,type: 'string'},
			{name: 'CHILD_ITEM_CODE'	,text: '<t:message code="system.label.base.childitemcode" default="자품목코드"/>'	,type: 'string', defaultValue: '$'},
			{name: 'ITEM_LEVEL1'		,text: '<t:message code="system.label.base.majorgroup" default="대분류"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2'		,text: '<t:message code="system.label.base.middlegroup" default="중분류"/>'		,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
			{name: 'ITEM_LEVEL3'		,text: '<t:message code="system.label.base.minorgroup" default="소분류"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.base.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.base.spec" default="규격"/>'				,type: 'string'},
			{name: 'START_DATE'			,text: '<t:message code="system.label.base.startdate" default="시작일"/>'			,type: 'uniDate', defaultValue: UniDate.get('today')},
			{name: 'STOP_DATE'			,text: '<t:message code="system.label.base.enddate" default="종료일"/>'			,type: 'uniDate', defaultValue: '2999.12.31'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createTreeStore('bpr581skrvMasterStore1', {
		model		: 'bpr581skrvModel',
		uniOpt		: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad	: false,
		folderSort	: true,
		proxy		: {
			type: 'direct',
			api: {
				read: 'bpr581skrvService.selectList'
			}
		},
		loadStoreRecords: function(record) {
			var searchParam= Ext.getCmp('searchForm').getValues();
			var param= {};
			if(BsaCodeInfo.gsBomPathYN =='Y' ) {
				param.StPathY = searchParam.StPathY;
			}else{
				param.StPathY = 'N';
			}
			param.ITEM_CODE = record.data.PROD_ITEM_CODE;
			var params = Ext.merge(searchParam, param);
			console.log( param );
			this.load({
				params : params
			});
		},
		listeners: {
			'load' : function( store, records, successful, operation, node, eOpts ) {
				if(records) {
					var root = this.getRoot();
					if(root) {
						root.expandChildren();
							node.cascadeBy(function(n){
							if(n.hasChildNodes())   {
								console.log("n",n)
								n.expand();
							}
							n.set("LVL", n.getDepth());
						})
						store.commitChanges();
					}
				}
			}
		}
//		,groupField: 'ITEM_NAME'
	});

	var directMasterStore2 = Unilite.createStore('bpr581skrvMasterStore1',{
		proxy	: directProxy1,
		model	: 'Bpr581skrvModel1',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= Ext.getCmp('panelResultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
			},
			datachanged : function(store, eOpts) {
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
				name		: 'DIV_CODE',
				value		: UserInfo.divCode,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,			//20210817 수정: true -> false
//				autoPopup		: true,				//20210817 주석
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
//					onSelected: {
//						fn: function(records, type) {
//							console.log('records : ', records);
//							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelResult.setValue('ITEM_CODE', '');
//						panelResult.setValue('ITEM_NAME', '');
//					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						if(Ext.getCmp('optsel').getChecked()[0].inputValue == "0"){
							popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20','40']});
						}
//						popup.setExtParam({'ITEM_ACCOUNT': '10'});
					}
				}
			}),{
					xtype:'uniCombobox',
					fieldLabel:'<t:message code="system.label.base.itemaccount" default="품목계정"/>',
					name:'ITEM_ACCOUNT',
					comboType : 'AU',
					comboCode : 'B020',
					value :'10',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
				xtype: 'radiogroup',
				id: 'optsel',
				fieldLabel: '<t:message code="system.label.base.deploymentgubun" default="전개구분"/>',
				items: [{
					boxLabel: '<t:message code="system.label.base.explosion" default="정전개"/>',
					width: 120,
					name: 'OPTSEL',
					inputValue: '0',
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.base.implosion" default="역전개"/>',
					width: 60,
					name: 'OPTSEL',
					inputValue: '1'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelResult.getField('RDO').setValue({RDO: newValue});
						//panelResult.getField('OPTSEL').setValue(newValue.OPTSEL);
						//UniAppManager.app.onQueryButtonDown();
						panelResult.getField('OPTSEL').setValue(newValue.OPTSEL);
						masterGrid1.reset();
						directMasterStore2.commitChanges();
						masterGrid.reset();
						directMasterStore1.commitChanges();
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.base.itemsearch" default="품목검색"/>',
				xtype: 'radiogroup',
				items: [{
					boxLabel: '<t:message code="system.label.base.currentapplieditem" default="현재적용품목"/>',
					width: 120,
					name: 'ITEM_SEARCH',
					inputValue: 'C',
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.base.whole" default="전체"/>',
					width: 60,
					name: 'ITEM_SEARCH',
					inputValue: 'A'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelResult.getField('RDO').setValue({RDO: newValue});
						panelResult.getField('ITEM_SEARCH').setValue(newValue.ITEM_SEARCH);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				xtype: 'uniRadiogroup',
				fieldLabel: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
				name: 'StPathY',
				comboType:'AU',
				comboCode:'A020',
				width:240,
				hidden: BsaCodeInfo.gsBomPathYN =='Y' ? false:true,
//				allowBlank:false,
				value:'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('StPathY').setValue(newValue.StPathY);
					}
				}
			}]
		}],
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

						Unilite.messageBox(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
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

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
			items: [{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name: 'DIV_CODE',
				value : UserInfo.divCode,
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 3},
				defaultType: 'uniTextfield',
				defaults : {enforceMaxLength: true},
				items:[
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					popupWidth		: 800,
					validateBlank	: false,			//20210817 수정: true -> false
//					autoPopup		: true,				//20210817 주석
					colspan			: 2,
//					textFieldWidth	: 170,
					listeners		: {
						//20210817 수정: 조회조건 팝업설정에 맞게 변경
						onValueFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
//						onSelected: {
//							fn: function(records, type) {
//								console.log('records : ', records);
//								panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
//								panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
//								panelResult.setValue('SPEC',records[0]["SPEC"]);
//							},
//							scope: this
//						},
//						onClear: function(type) {
//							panelResult.setValue('ITEM_CODE', '');
//							panelResult.setValue('ITEM_NAME', '');
//							panelResult.setValue('SPEC','');
//						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							if(Ext.getCmp('optsel').getChecked()[0].inputValue == "0"){
								popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20','40']});
							}
//							popup.setExtParam({'ITEM_ACCOUNT': '10'});
						}
					}
				}),{
					name:'SPEC',
					xtype:'uniTextfield',
					holdable: 'hold',
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}]
			},{
				xtype:'uniCombobox',
				fieldLabel:'<t:message code="system.label.base.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				comboType : 'AU',
				comboCode : 'B020',
				value :'10',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.base.deploymentgubun" default="전개구분"/>',
				items: [{
					boxLabel: '<t:message code="system.label.base.explosion" default="정전개"/>',
					width: 80,
					name: 'OPTSEL',
					inputValue: '0',
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.base.implosion" default="역전개"/>',
					width: 80,
					name: 'OPTSEL',
					inputValue: '1'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelSearch.getField('RDO').setValue({RDO: newValue});
						//panelSearch.getField('OPTSEL').setValue(newValue.OPTSEL);
						//UniAppManager.app.onQueryButtonDown();
						panelSearch.getField('OPTSEL').setValue(newValue.OPTSEL);
						masterGrid1.reset();
						directMasterStore2.commitChanges();
						masterGrid.reset();
						directMasterStore1.commitChanges();
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.base.itemsearch" default="품목검색"/>',
				xtype: 'radiogroup',
				items: [{
					boxLabel: '<t:message code="system.label.base.currentapplieditem" default="현재적용품목"/>',
					width: 100,
					name: 'ITEM_SEARCH',
					inputValue: 'C',
					checked: true
				}, {
					boxLabel: '<t:message code="system.label.base.whole" default="전체"/>',
					width: 100,
					name: 'ITEM_SEARCH',
					inputValue: 'A'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelSearch.getField('RDO').setValue({RDO: newValue});
						panelSearch.getField('ITEM_SEARCH').setValue(newValue.ITEM_SEARCH);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				xtype: 'uniRadiogroup',
				fieldLabel: '<t:message code="system.label.base.standardpathyn" default="표준Path 여부"/>',
				name: 'StPathY',
				comboType:'AU',
				comboCode:'A020',
				width:240,
				hidden: BsaCodeInfo.gsBomPathYN =='Y' ? false:true,
				allowBlank:false,
				value:'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('StPathY').setValue(newValue.StPathY);
					}
				}
			}
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
						Unilite.messageBox(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
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


	/** Grid 정의(Grid Panel),
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('bpr581skrvGrid2', {
		store: directMasterStore2,
		layout : 'fit',
		region:'west',
		flex: .3,
		split: true,
		itemId:'bpr581skrvGrid2',
		uniOpt:{
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		selModel: 'rowmodel',
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary',	  showSummaryRow: false} ],
		columns:  [{ dataIndex: 'COMP_CODE'			,width: 66, hidden: true   },
				   { dataIndex: 'DIV_CODE'			,width: 66, hidden: true   },
				   { dataIndex: 'PROD_ITEM_CODE'	,width: 90,  tdCls:'x-change-cell',
					  editor: Unilite.popup('DIV_PUMOK_G', {
							textFieldName: 'PROD_ITEM_CODE',
							DBtextFieldName: 'ITEM_CODE',
							autoPopup: true,
							listeners: {'onSelected': {
								fn: function(records, type) {
									console.log('records : ', records);
									Ext.each(records, function(record,i) {
										if(i==0) {
											masterGrid1.setItemData(record,false, masterGrid1.uniOpt.currentRecord);
										} else {
											UniAppManager.app.onNewDataButtonDown();
											masterGrid1.setItemData(record,false, masterGrid1.getSelectedRecord());
										}
									});
								},
								scope: this
								},
								'onClear': function(type) {
									masterGrid1.setItemData(null,true);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL'			   : 'MULTI'});
									popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
									popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
									popup.setExtParam({'DEFAULT_ITEM_ACCOUNT': '10'});
								}
							}
						})
					},
				   { dataIndex: 'CHILD_ITEM_CODE'	,width: 66,  hidden: true},
				   { dataIndex: 'ITEM_NAME'			,width: 166 ,
					  editor: Unilite.popup('DIV_PUMOK_G', {
//							extParam: {DIV_CODE: UserInfo.divCode, ITEM_ACCOUNT_FILTER:['10','20'], ITEM_EXCLUDE:'DIV_CODE' ,DEFAULT_ITEM_ACCOUNT:'10'},
								autoPopup: true,
								listeners: {'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid1.setItemData(record,false, masterGrid1.uniOpt.currentRecord);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid1.setItemData(record,false, masterGrid1.getSelectedRecord());
											}
										});
									},
									scope: this
									},
									'onClear': function(type) {
										masterGrid1.setItemData(null,true);
									},
									applyextparam: function(popup){
										popup.setExtParam({'SELMODEL'			   : 'MULTI'});
										popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
										popup.setExtParam({'DEFAULT_ITEM_ACCOUNT': '10'});
									}
								}
						})
					},
				   { dataIndex: 'SPEC'				,width: 100  },
				   { dataIndex: 'START_DATE'		,width: 100, hidden: false   },
				   { dataIndex: 'STOP_DATE'			,width: 100, hidden: false}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					masterSelectedGrid = girdNm;
					if(grid.getStore().getCount() > 0)  {
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
				   return false;
				}
				if (UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','CHILD_ITEM_CODE', 'SPEC']))
					return false;
				else
					return true;
			},
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record = selected[0];
					directMasterStore1.loadData({})
					directMasterStore1.loadStoreRecords(record);
				}
			},
			returnData: function(record)   {
				if(Ext.isEmpty(record)) {
					record = this.getSelectedRecord();
				}
			}
		},
		setItemData: function(record, dataClear,grdRecord) {
			if(dataClear) {
				grdRecord.set('PROD_ITEM_CODE'	,"");
				grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,"");
			}
			else {
				grdRecord.set('PROD_ITEM_CODE'	, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
			}
		}
	});

	var masterGrid = Unilite.createTreeGrid('bpr581skrvGrid1', {
		layout: 'fit',
		region:'center',
		store: directMasterStore1,
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
		},
		tbar:[{
			xtype: 'uniBaseButton',
			iconCls: 'icon-excel',
			width: 26, height: 26,
			tooltip: 'Download Excel',
			handler: function() {
				masterGrid.downloadExcelXmlTreeGrid(false,'<t:message code="system.label.base.mfgbominquiry" default="제조BOM조회"/>');
			}
		}],
		columns: [
			{
				xtype: 'treecolumn', //this is so we know which column will show the tree
				text: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
				width:250,
				sortable: false,
				dataIndex: 'ITEM_CODE', editable: false
			},
			{dataIndex: 'LVL'				, width: 40, align: 'center'},
			{dataIndex: 'ITEM_NAME'			, width: 250},
			{dataIndex: 'SPEC'				, width: 170},
			{dataIndex: 'STOCK_UNIT'		, width: 66 ,align: 'center'},
			{dataIndex: 'UNIT_Q'			, width: 100, xtype: 'uniNnumberColumn'},
			{dataIndex: 'PROD_UNIT_Q'		, width: 100},
			{dataIndex: 'LOSS_RATE'			, width: 100},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 100,align: 'center'},
			{dataIndex: 'SUPPLY_TYPE'		, width: 100,align: 'center'},
			{dataIndex: 'AVERAGE_P'			, width: 100},
			//20190621 구매단가(PURCHASE_BASE_P) 추가
			{dataIndex: 'PURCHASE_BASE_P'	, width: 100},
			{dataIndex: 'STOCK_Q'			, width: 100},
			{dataIndex: 'START_DATE'		, width: 100,align: 'center'},
			{dataIndex: 'STOP_DATE'			, width: 100,align: 'center'},
			{dataIndex: 'PATH_CODE'			, width: 100 ,hidden: true},
			{dataIndex: 'BOM_YN'			, width: 66,align: 'center'},
			{dataIndex: 'USE_YN'			, width: 66,align: 'center'},
			{dataIndex: 'MAN_HOUR'			, width: 100},
			//20180528 MATERIAL_CNT, SET_QTY 추가
			{dataIndex: 'MATERIAL_CNT'		, width: 80 ,hidden: true},
			{dataIndex: 'SET_QTY'			, width: 80 ,hidden: true},
			{dataIndex: 'UNIT_P1'			, width: 100},
			{dataIndex: 'UNIT_P2'			, width: 100},
			{dataIndex: 'UNIT_P3'			, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 200},
			{dataIndex: 'SUB_FLAG'			, width: 100 ,hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'		, width: 100 ,hidden: true},
			{dataIndex: 'SEQ'				, width: 100 ,hidden: true},
			{dataIndex: 'INTENS_Q'			, width: 100 ,hidden: true},
			{dataIndex: 'SPEC_NUM'			, width: 100},
			{dataIndex: 'REMARK'			, width:200}
		],
		listeners:{
			cellclick : function( grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(grid.ownerCt.getColumns()[cellIndex].dataIndex == "LVL") {
					var currentLevel = record.get('LVL');
					var root = grid.getStore().getRoot();
					root.cascadeBy(function(n){
						if(n.hasChildNodes())   {
							if(n.getDepth() == currentLevel) {
								if(n.isExpanded()) {
									n.collapse()
								}else {
									n.expand();
								}
							}

						}
					});
				}
			}
		},
		downloadExcelXmlTreeGrid: function(includeHidden, title) {
			var me = this;
			if (!title) title = this.title;

			if (Ext.isEmpty(title)) {
				title = this.id ? this.id : 'Export';
			}else {
				if(title.indexOf("/") >= 0) {
					title = title.replace(/\//g, "");
				}
			}
			var vExportContent = this.getExcelXml(includeHidden, title);
			var fileName = title + "-" + Ext.Date.format(new Date(), 'Y-m-d Hi');
			var serviceName = me.getStore().getProxy().getApi().read.$name;
			if(!Ext.isDefined(serviceName)) {
				Unilite.messageBox('<t:message code="system.message.base.lookupbox.emptyText" default="조회된 결과가 없습니다."/>');
				return;
			}
			var arrServiceName = serviceName.split(".");
			var form = this.down('form#uploadForm');
			if (form) {
				form.destroy();
			}
			form = this.add({
				xtype: 'form',
				itemId: 'uploadForm',
				hidden: true,
				standardSubmit: true,
				url: CPATH+'/base/bpr581skrvdownloadExcel.do',
				items: [{
					xtype: 'hiddenfield',
					name: 'xmlData',
					value: vExportContent
				},{
					xtype: 'hiddenfield',
					name: 'pgmId',
					value: PGM_ID
				},{
					xtype: 'hiddenfield',
					name: 'extAction',
					value : arrServiceName[0]
				},{
					xtype: 'hiddenfield',
					name: 'extMethod',
					value : arrServiceName[1]
				},{
					xtype: 'hiddenfield',
					name: 'fileName',
					value : fileName
				},{
					xtype: 'hiddenfield',
					name: 'onlyData',
					value : 'false'
				}]
			});

			if(arrServiceName.length == 2 ) {
				form.getForm().submit({
					params: {data:this.getParams(me.getStore().readParams)}
				});
			}else {
				Unilite.messageBox('<t:message code="system.message.base.message032" default="엑셀 다운로드 서비스가 없습니다."/>');
			}
		},
		getParams:function(params) {
			return Ext.JSON.encode(params);
		},
		getExcelXml: function(includeHidden, title) {
			var theTitle = title || this.title;
			var worksheet = this.createWorksheet(includeHidden, theTitle);
			var totalWidth = this.columns.length;
			//<?xml version="1.0" encoding="utf-8" ?>
			return ''.concat(
				'<?xml version="1.0" encoding="UTF-8"  ?>',
				'<!DOCTYPE excelDownload PUBLIC ',
				' "-//TLab//DTD excep upload config XML V1.0//EN" ',
				'"../ExcelDownload/dtd/excel-download.dtd">',
				'<workBook name="'+PGM_ID+'" desc="'+theTitle+'" >',
				 worksheet.xml,
				'</workBook>'
			);
		},
		getModelField: function(fieldName) {

			var fields = this.store.model.getFields();
			for (var i = 0; i < fields.length; i++) {
				if (fields[i].name === fieldName) {
					return fields[i];
				}
			}
		},
		setCellType:function(format) {
			if(format.indexOf('.') > -1) {
				return 'number';
			}else {
				return 'integer';
			}
		},
		createWorksheet: function(includeHidden, theTitle) {
			var me = this;
			var cm = this.getView().getGridColumns();

			var store = this.getStore();
			var colCount = cm.length;
			var isSummary = false;
			var isGroupSummary = false;

			var gridFeatures  = this.getView().features;
			var colXml = '<sheet name="'+theTitle+'" desc="'+theTitle+'" startRow="2" ' ;

			if(store) {
				if(Ext.isDefined(store.getProxy()) ) {
					colXml += 'readService="'+store.getProxy().getApi().read.$name+'"' ;
				}
				if(Ext.isDefined(store.getGroupField()) ) {
					colXml +=  ' groupField="'+store.getGroupField()+'" ' ;
				}
			}
			colXml +=  ' isSummary="'+isSummary+'" '
			colXml +=  ' isGroupSummary="'+isGroupSummary+'" '
			colXml += '>';
			var col = 0;
			var isRowNumber = false;

			for (var i = 0; i < colCount; i++) {
				if(cm[i].xtype == 'rownumberer'){
					isRowNumber = true;
				}
				if (cm[i].xtype != 'actioncolumn' && cm[i].xtype != 'rownumberer' && (cm[i].dataIndex != ''&& cm[i].dataIndex != null) && (cm[i].dataIndex != '*') && (includeHidden || !cm[i].hidden)) {
					var fld = this.getModelField(cm[i].dataIndex);
					if(isRowNumber)  {
						col = i-1;
					}else {
						col = i
					}
					if (cm[i].text !== "")  {
						var type = 'string';
						var vFormat = '';
						if(fld) {
							switch (fld.type) {
								case "uniQty":
									type = this.setCellType(UniFormat.Qty);
									vFormat = UniFormat.Qty;
									break;
								case 'uniUnitPrice':
									type = this.setCellType(UniFormat.UnitPrice);
									vFormat = UniFormat.UnitPrice;
									break;
								case "int":
									type = 'integer';
									break;
								case "uniPrice":
									type = this.setCellType(UniFormat.Price);
									vFormat = UniFormat.Price;
									break;
								case "float":
									if(fld.format) {
										type = this.setCellType(fld.format);
										vFormat = fld.format;
									}else {
										type = 'integer';
									}
									break;
								case "uniPercent":
									type = this.setCellType(UniFormat.Percent);
									vFormat = UniFormat.Percent;
									break;
								case "uniFC":
									type = this.setCellType(UniFormat.FC);
									vFormat = UniFormat.FC;
									break;
								case "uniER":
									type = this.setCellType(UniFormat.ER);
									vFormat = UniFormat.ER;
									break;
								case "bool":
									type = 'string';
									break;
								case "boolean":
									type = 'string';
									break;
								case "uniDate":
									type = 'string';
									break;
								case "date":
									type = 'string';
									break;
								default:
									type = 'string';
									break;
							}
						}

						colXml += '<field col="'+col+'"' +
										 ' title="'+cm[i].text.replace("<span style='color:#f00 !important;font-weight:bold'>*</span>","")+'" ' +
										 ' name="'+cm[i].dataIndex+'"'+
										 ' width="' + cm[i].width + '"' +
										 ' align="' +cm[i].align +'"'+
										 ' type="' +type +'"'+
										 ' format="' +vFormat +'"';

						if(fld) {
							if(fld.comboType) {
								colXml +=		 ' comboType="' +fld.comboType +'"';
							}
							if(fld.comboCode) {
								colXml +=		 ' comboCode="' +fld.comboCode +'"';
							}
							if(fld.includeMainCode) {
								colXml +=		 ' includeMainCode="' +fld.includeMainCode +'"';
							}
							if(store.model.getField(cm[i].dataIndex).store && (!Ext.isDefined(fld.comboCode) || fld.comboType != 'AU' )) {
								var comboDataArr = "{" ;
								Ext.each(store.model.getField(cm[i].dataIndex).store.data.items, function(item, idx){
									comboDataArr = comboDataArr +"'"+item.data.value+"':'"+ item.data.text.replace(/&/g, '')+"',";
								});
								var comboDataArr = comboDataArr.substring(0, comboDataArr.length-1)+"}";
								colXml +=		 ' comboData="' +comboDataArr +'"';
							}
							if(fld.includeMainCode) {
								var comboDataArr = "{" ;
								Ext.each(cm[i].editor.getStore().data.items, function(item, idx){
									comboDataArr = comboDataArr +"'"+item.data.value+"':'"+ item.data.text.replace(/&/g, '')+"',";
								});
								var comboDataArr = comboDataArr.substring(0, comboDataArr.length-1)+"}";
								colXml +=		 ' comboData="' +comboDataArr +'"';
							}
						}

						if(isSummary || isGroupSummary) {
							if(cm[i].summaryType && !Ext.isFunction(cm[i].summaryType)) {
								colXml +=		 ' summaryType="' + cm[i].summaryType +'"';
							}
							if(Ext.isFunction(cm[i].summaryRenderer)) {
								colXml +=		 ' summaryfunction="' +theTitle+cm[i].dataIndex+'"';
							}
						}
						colXml +=  '/>';
					}
				}
			}
			colXml +='</sheet>';
			result={xml :colXml};
			return result;
		}
	});

	Unilite.Main({
		id: 'bpr581skrvApp',
		borderItems: [{
			region:'center',
			layout: 'border',
			border: false,
			items:[panelResult,{
				region: 'center',
				layout: {type: 'hbox', align: 'stretch'},
				border: false,
				flex: .7,
				items: [masterGrid1, masterGrid]
			}]
		}
		, panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ITEM_ACCOUNT','10');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ITEM_ACCOUNT','10');
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid1.getStore().loadStoreRecords();
		}
	});
};

/*
,{
			//추가검색
			xtype: 'container',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 3},
			hidden: true,
			id: 'AdvanceSerch',
			items: [
					{
				fieldLabel: '영업담당',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S010'
			}, {
				fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'TXTLV_L2'
			}, {
				fieldLabel: '수주량',
				name:'FR_ORDER_QTY',
				suffixTpl:'&nbsp;이상',
				labelWidth:120
			}, {
				fieldLabel: '거래처분류',
				name:'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055'
			}, {
				fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3'
			}, {
				fieldLabel: '~',
				name:'TO_ORDER_QTY',
				suffixTpl:'&nbsp;이하',
				labelWidth:120
			}, {
				fieldLabel: '지역',
				name:'AREA_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B056'
			}, {
				fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				colspan: 2
			}, {
				fieldLabel: '판매유형',
				name:'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S002'
			},
				Unilite.popup('ITEM2',{ fieldLabel: '<t:message code="system.label.base.repmodelcode" default="대표모델코드"/>', textFieldWidth:170, validateBlank:false, popupWidth: 710, colspan: 2}),
			  {
				xtype: 'container',
				defaultType: 'uniTextfield',
				layout: {type: 'uniTable', columns: 3},
				width:325,
				items:[{
					fieldLabel:'수주번호', suffixTpl:'&nbsp;~&nbsp;', name: 'FR_ORDER_NUM', width:218
				}, {
					name: 'TO_ORDER_NUM', width:107
				}]
			}, {
				fieldLabel: '납기일',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				width: 315,
				colspan: 2
			}, {
				fieldLabel: '생성경로',
				name:'TXT_CREATE_LOC',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B031'
			}, {
				xtype: 'radiogroup',
				fieldLabel: '마감여부',
				id: 'ORDER_STATUS',
				items: [{
					boxLabel: '전체', width: 50, name: 'ORDER_STATUS', inputValue: '%', checked: true
				}, {
					boxLabel: '마감', width: 60, name: 'ORDER_STATUS', inputValue: 'Y'
				}, {
					boxLabel: '미마감', width: 80, name: 'ORDER_STATUS', inputValue: 'N'
				}]
			}, {
				fieldLabel: '상태',
				xtype: 'radiogroup',
				id: 'rdoSelect2',
				labelWidth:120,
				items: [{
					boxLabel: '전체', width: 50,  name: 'rdoSelect2', inputValue: 'A', checked: true
				}, {
					boxLabel: '미승인', width: 60, name: 'rdoSelect2', inputValue: 'N'
				}, {
					boxLabel: '승인(완료)', width: 80, name: 'rdoSelect2', inputValue: '6'
				}, {
					boxLabel: '반려', width: 60, name: 'rdoSelect2', inputValue: '5'
				}]
			}]
*/
</script>