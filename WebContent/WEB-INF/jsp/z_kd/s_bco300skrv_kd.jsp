<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bco300skrv_kd">
	<t:ExtComboStore comboType="BOR120" pgmId="s_bco300skrv_kd" />
	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />
	<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<!-- 사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="B024" />
	<!-- 담당자-->
	<t:ExtComboStore comboType="AU" comboCode="B013" />
	<!-- 재고단위  -->
	<t:ExtComboStore comboType="AU" comboCode="B015" />
	<!-- 거래처구분    -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />
	<!-- 기준화폐-->
	<t:ExtComboStore comboType="AU" comboCode="B038" />
	<!-- 결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="B034" />
	<!-- 결제조건-->
	<t:ExtComboStore comboType="AU" comboCode="B055" />
	<!-- 거래처분류-->
	<t:ExtComboStore comboType="AU" comboCode="B038" />
	<!-- 결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="A003" />
	<!-- 구분  -->
	<t:ExtComboStore comboType="AU" comboCode="S003" />
	<!-- 단가구분1(판매)  -->
	<t:ExtComboStore comboType="AU" comboCode="M301" />
	<!-- 단가구분2(구매)  -->
	<t:ExtComboStore comboType="AU" comboCode="WB26" />
	<!-- 가격조건  -->
	<t:ExtComboStore comboType="AU" comboCode="WB01" />
	<!-- 운송방법  -->
	<t:ExtComboStore comboType="AU" comboCode="WB03" />
	<!-- 변동사유  -->
	<t:ExtComboStore comboType="AU" comboCode="WB04" />
	<!-- 차종  -->
	<t:ExtComboStore comboType="AU" comboCode="B019" />
	<!-- 국내외  -->
	<t:ExtComboStore comboType="AU" comboCode="B014" />
	<!-- 조달구분  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />
	<!-- 품목계정  -->
	<t:ExtComboStore comboType="AU" comboCode="WB17" />
	<!-- 기안  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
	color: #333333;
	font-weight: normal;
	padding: 1px 2px;
}
</style>
<script type="text/javascript">
	var BsaCodeInfo = { //컨트롤러에서 값을 받아옴.
		gsMoneyUnit : '${gsMoneyUnit}'
	};

	/*var output ='';   // 입고내역 셋팅 값 확인 alert
	 for(var key in BsaCodeInfo){
	 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	 }
	 alert(output);*/

	function appMain() {
		var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

		var panelResult = Unilite
				.createSearchForm(
						'resultForm',
						{
							hidden : !UserInfo.appOption.collapseLeftSearch,
							region : 'north',
							layout : {
								type : 'uniTable',
								columns : 3
							},
							padding : '1 1 1 1',
							border : true,
							items : [
									{
										fieldLabel : '사업장',
										name : 'DIV_CODE',
										holdable : 'hold',
										xtype : 'uniCombobox',
										comboType : 'BOR120',
										allowBlank : false
									},{
										fieldLabel : '적용일',
										xtype : 'uniDateRangefield',
										startFieldName : 'APLY_START_DATE_FR',
										endFieldName : 'APLY_START_DATE_TO'
									},
									Unilite.popup('AGENT_CUST', {
										fieldLabel : '거래처',
										valueFieldName : 'CUSTOM_CODE_FR',
										textFieldName : 'CUSTOM_NAME_FR',
										validateBlank : false
									}),
									{
										fieldLabel : '구분',
										name : 'TYPE',
										xtype : 'uniCombobox',
										comboType : 'AU',
										comboCode : 'A003',
										allowBlank : false
									},{
										fieldLabel : '입력일',
										xtype : 'uniDateRangefield',
										startFieldName : 'INPUT_DATE_FR',
										endFieldName : 'INPUT_DATE_TO'
									},
									Unilite.popup('AGENT_CUST', {
										fieldLabel : '~',
										valueFieldName : 'CUSTOM_CODE_TO',
										textFieldName : 'CUSTOM_NAME_TO',
										validateBlank : false
									}),{
										fieldLabel : '품목계정',
										name : 'ITEM_ACCOUNT',
										xtype : 'uniCombobox',
										comboType : 'AU',
										comboCode : 'B020',
										multiSelect:true,
										typeAhead: false
									},{
										fieldLabel : '국내외',
										name : 'DOM_FORIGN',
										xtype : 'uniCombobox',
										comboType : 'AU',
										comboCode : 'B019'
									},
									Unilite.popup('DIV_PUMOK', {
										fieldLabel : '품목',
										valueFieldName : 'ITEM_CODE_FR',
										textFieldName : 'ITEM_NAME_FR',
										validateBlank : false
									}),
									{
										xtype : 'radiogroup',
										fieldLabel : '조회구분',
										items : [ {
											boxLabel : '최종단가',
											width : 110,
											name : 'ALL_FLAG',
											inputValue : '1',
											checked : true
										}, {
											boxLabel : '전체',
											width : 80,
											name : 'ALL_FLAG',
											inputValue : '2'
										}],
										listeners : {
											change : function(field, newValue,oldValue, eOpts) {
												UniAppManager.app.onQueryButtonDown();
											}
										}
									},
									{
										fieldLabel : '조달구분',
										name : 'SUPPLY_TYPE',
										xtype : 'uniCombobox',
										comboType : 'AU',
										comboCode : 'B014'
									},
									
									Unilite.popup('DIV_PUMOK', {
										fieldLabel : '~',
										valueFieldName : 'ITEM_CODE_TO',
										textFieldName : 'ITEM_NAME_TO',
										validateBlank : false
									})
									
									/* {
										xtype : 'component'
									} */
									/* Unilite.popup('DEPT', {
										fieldLabel : '부서',
										valueFieldName : 'TREE_CODE',
										textFieldName : 'TREE_NAME'
									}), */
									
									
									
									
									
									
									/* {
										xtype : 'component'
									},{
										xtype : 'component'
									},{
										fieldLabel: '품목계정',  
										name: 'ITEM_ACCOUNT', 
										xtype: 'uniCheckboxgroup', 
										comboType:'AU',
										comboCode:'B020'
									}
									 */
									],
							setAllFieldsReadOnly : function(b) {
								var r = true
								if (b) {
									var invalid = this.getForm().getFields()
											.filterBy(function(field) {
												return !field.validate();
											});
									if (invalid.length > 0) {
										r = false;
										var labelText = ''
										if (Ext
												.isDefined(invalid.items[0]['fieldLabel'])) {
											var labelText = invalid.items[0]['fieldLabel']
													+ '은(는)';
										} else if (Ext
												.isDefined(invalid.items[0].ownerCt)) {
											var labelText = invalid.items[0].ownerCt['fieldLabel']
													+ '은(는)';
										}
										alert(labelText + Msg.sMB083);
										invalid.items[0].focus();
									} else {
										//this.mask();
										var fields = this.getForm().getFields();
										Ext
												.each(
														fields.items,
														function(item) {
															if (Ext
																	.isDefined(item.holdable)) {
																if (item.holdable == 'hold') {
																	item
																			.setReadOnly(true);
																}
															}
															if (item.isPopupField) {
																var popupFC = item
																		.up('uniPopupField');
																if (popupFC.holdable == 'hold') {
																	popupFC
																			.setReadOnly(true);
																}
															}
														})
									}
								} else {
									//this.unmask();
									var fields = this.getForm().getFields();
									Ext.each(fields.items, function(item) {
										if (Ext.isDefined(item.holdable)) {
											if (item.holdable == 'hold') {
												item.setReadOnly(false);
											}
										}
										if (item.isPopupField) {
											var popupFC = item
													.up('uniPopupField');
											if (popupFC.holdable == 'hold') {
												item.setReadOnly(false);
											}
										}
									})
								}
								return r;
							},
							setLoadRecord : function(record) {
								var me = this;
								me.uniOpt.inLoading = false;
								me.setAllFieldsReadOnly(true);
							}
						});

		Unilite.defineModel('s_bco300skrv_kdModel', { // 메인1
			fields : [ 
			 	{name : 'COMP_CODE',					text : '법인코드',				type : 'string'			}, 
				{name : 'DIV_CODE',							text : '사업장',					type : 'string'			}, 
				{name : 'CUSTOM_CODE',				text : '거래처코드',			type : 'string'			}, 
				{name : 'CUSTOM_NAME',				text : '거래처명',				type : 'string'			}, 
				{name : 'ITEM_CODE',						text : '품목코드',				type : 'string'			}, 
				{name : 'ITEM_NAME',						text : '품목명',					type : 'string'			},  
			//20{180517추가
				{name : 'NS_FLAG',							text : '내수구분',				type : 'string',				comboType : 'AU',				comboCode : 'WB18'			}, 
				{name : 'SPEC',									text : '규격/품번',				type : 'string'			},
				//
				{name : 'PRICE_TYPE',						text : '단가구분',				type : 'string',				comboType : 'AU',				comboCode : 'WB26'			}, 
				{name : 'ORDER_UNIT',					text : '단위',						type : 'string',				allowBlank : false,				comboType : 'AU',				comboCode : 'B013',				displayField : 'value'			}, 
				{name : 'MONEY_UNIT',					text : '화폐단위',				type : 'string'			}, 
				{name : 'ITEM_P',								text : '단가',						type : 'uniUnitPrice',				allowBlank : false			}, 
				{name : 'APLY_START_DATE',			text : '적용일',					type : 'uniDate'			}, 
				{name : 'P_REQ_NUM',					text : '의뢰번호',				type : 'string'			}, 
				{name : 'SER_NO',								text : '의뢰순번',				type : 'int'			}, 
				{name : 'PACK_ITEM_P',					text : '포장단가',				type : 'uniUnitPrice'			}, 
				{name : 'PAY_TERMS',						text : '결제조건',				type : 'string',				comboType : 'AU',				comboCode : 'B034'			}, 
				{name : 'TERMS_PRICE',					text : '가격조건',				type : 'string',				comboType : 'AU',				comboCode : 'T005'			}, 
				{name : 'DELIVERY_METH',				text : '운송방법',				type : 'string',				comboType : 'AU',				comboCode : 'WB01'			}, 
				{name : 'CH_REASON',					text : '단가변동사유',			type : 'string',				allowBlank : false,				comboType : 'AU',				comboCode : 'WB03'			}, 
				{name : 'TREE_CODE',						text : '부서코드',				type : 'string'			}, 
				{name : 'TREE_NAME',						text : '부서명',					type : 'string'			}, 
				{name : 'PERSON_NUMB',				text : '사원코드',				type : 'string'			}, 
				{name : 'PERSON_NAME',				text : '사원명',					type : 'string'			}, 
				{name : 'INSERT_DB_USER',			text : '입력ID',					type : 'string'			}, 
				{name : 'INSERT_DB_TIME',				text : '입력일',					type : 'uniDate'			}, 
				{name : 'UPDATE_DB_USER',			text : '수정ID',					type : 'string'			}, 
				{name : 'UPDATE_DB_TIME',			text : '수정일',					type : 'uniDate'			}, 
				{name : 'TEMPC_01',						text : '여유컬럼',				type : 'string'			}, 
				{name : 'TEMPC_02',						text : '여유컬럼',				type : 'string'			}, 
				{name : 'TEMPC_03',						text : '여유컬럼',				type : 'string'			}, 
				{name : 'TEMPN_01',						text : '여유컬럼',				type : 'string'			}, 
				{name : 'TEMPN_02',						text : '여유컬럼',				type : 'string'			}, 
				{name : 'TEMPN_03',						text : '여유컬럼',				type : 'string'			}, 
				{name : 'GW_FLAG',							text : '기안',						type : 'string',				comboType : 'AU',				comboCode : 'WB17'} 
				]
		});//End of Unilite.defineModel('s_bco300skrv_kdModel', {

		/**
		 * Store 정의(Service 정의)
		 * @type
		 */
		var directMasterStore1 = Unilite.createStore(
				's_bco300skrv_kdMasterStore1', {
					model : 's_bco300skrv_kdModel',
					autoLoad : false,
					uniOpt : {
						isMaster : true, // 상위 버튼 연결
						editable : false, // 수정 모드 사용
						deletable : false, // 삭제 가능 여부
						useNavi : false
					// prev | newxt 버튼 사용
					},
					proxy : {
						type : 'direct',
						api : {
							read : 's_bco300skrv_kdService.selectList'
						}
					},
					loadStoreRecords : function() {
						var param = Ext.getCmp('resultForm').getValues();
						console.log(param);
						this.load({
							params : param
						/* 	// NEW ADD
			  				callback: function(records, operation, success){
			  					console.log(records);
			  					if(success){
			  						if(masterGrid.getStore().getCount() == 0){
			  							Ext.getCmp('GW').setDisabled(true);
			  						}else if(masterGrid.getStore().getCount() != 0){
			  							UniBase.fnGwBtnControl('GW',directMasterStore1.data.items[0].data.GW_FLAG);							
			  						}
			  					}
			  				} */
						});

					},
					listeners : {
						load : function(store, records, successful, eOpts) {
							if (masterGrid.getStore().getCount() == 0) {
								Ext.getCmp('GW').setDisabled(true);
							} else {
								Ext.getCmp('GW').setDisabled(false);
							}
						}
					},
					groupField : ''
				}); // End of var directMasterStore1 = Unilite.createStore('s_bco300skrv_kdMasterStore1',{

		/**
		 * Master Grid1 정의(Grid Panel)
		 * @type
		 */
		var masterGrid = Unilite.createGrid('s_bco300skrv_kdGrid1', {
			// for tab
			layout : 'fit',
			region : 'center',
			uniOpt : {
				expandLastColumn : false,
				useRowNumberer : true,
				useMultipleSorting : true
			},
			features : [ {
				id : 'masterGridSubTotal',
				ftype : 'uniGroupingsummary',
				showSummaryRow : false
			}, {
				id : 'masterGridTotal',
				ftype : 'uniSummary',
				showSummaryRow : false
			} ],
			tbar : [ {
				itemId : 'GWBtn',
				id : 'GW',
				iconCls : 'icon-referance',
				text : '기안',
				handler : function() {
					var param = panelResult.getValues();
					param.DRAFT_NO = 0;
					
					if ((panelResult.getValue('TYPE') == '1') && (panelResult.getValue('SUPPLY_TYPE') == '2'))
					{
						alert('조달구분을 변경해주세요!');
						return false;					
					}
					

					if (confirm('기안 하시겠습니까?')) {
						s_bco300skrv_kdService.selectGwData(param, function(
								provider, response) {
							if (Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
								panelResult.setValue('GW_TEMP', '기안중');
								//s_bco300skrv_kdService.makeDraftNum(param, function(provider2, response)   {
								UniAppManager.app.requestApprove();
								//});
							} else {
								alert('이미 기안된 자료입니다.');
								return false;
							}
						});
					}
					
					UniAppManager.app.onQueryButtonDown();
				}
			} ],
			store : directMasterStore1,
			columns : [
			    {dataIndex : 'COMP_CODE',				width : 100,		hidden : true}, 
				{dataIndex : 'DIV_CODE',						width : 80,			hidden : true}, 
				{dataIndex : 'ITEM_CODE',					width : 100}, 
				{dataIndex : 'ITEM_NAME',					width : 150},  
				{dataIndex :'SPEC',								width : 150},  
				{dataIndex : 'ORDER_UNIT',				width : 50}, 
				{dataIndex : 'PRICE_TYPE',					width : 80},
				{dataIndex : 'NS_FLAG',						width : 80},
				{dataIndex : 'ITEM_P',							width : 100}, 
				{dataIndex : 'PACK_ITEM_P',				width : 100}, 
				{dataIndex : 'MONEY_UNIT',				width : 80},
				{dataIndex : 'TERMS_PRICE',				width : 100}, 
				{dataIndex : 'APLY_START_DATE',		width : 100}, 
				{dataIndex : 'CUSTOM_CODE',			width : 100}, 
				{dataIndex : 'CUSTOM_NAME',			width : 150},  
				{dataIndex : 'PAY_TERMS',					width : 100},
				{dataIndex : 'DELIVERY_METH',			width : 100}, 
				{dataIndex : 'CH_REASON',				width : 100}, 
				{dataIndex : 'P_REQ_NUM',				width : 100}, 
				{dataIndex : 'SER_NO',							width : 80},
				{dataIndex : 'TREE_CODE',					width : 100}, 
				{dataIndex : 'TREE_NAME',					width : 150},
				{dataIndex : 'PERSON_NUMB',			width : 100}, 
				{dataIndex : 'PERSON_NAME',			width : 150}, 
				{dataIndex : 'INSERT_DB_USER',		width : 85,				hidden : true	}, 
				{dataIndex : 'INSERT_DB_TIME',			width : 85,				hidden : true}, 
				{dataIndex : 'UPDATE_DB_USER',		width : 85,				hidden : true	}, 
				{dataIndex : 'UPDATE_DB_TIME',		width : 85,				hidden : true	},
				{dataIndex : 'TEMPC_01',					width : 85,				hidden : true}, 
				{dataIndex : 'TEMPC_02',					width : 100,			hidden : true	}, 
				{dataIndex : 'TEMPC_03',					width : 200,			hidden : true	}, 
				{dataIndex : 'TEMPN_01',					width : 100,			hidden : true	}, 
				{dataIndex : 'TEMPN_02',					width : 150,			hidden : true	}, 
				{dataIndex : 'TEMPN_03',					width : 100,			hidden : true	},
				{dataIndex : 'GW_FLAG',					width : 100,			hidden : true	}
			]
		});//End of var masterGrid = Unilite.createGrid('s_bco300skrv_kdGrid1', {

		Unilite	.Main({
					borderItems : [ {
						region : 'center',
						layout : 'border',
						border : false,
						items : [ masterGrid, panelResult ]
					} ],
					id : 's_bco300skrv_kdApp',
					fnInitBinding : function() {
						panelResult.setValue('DIV_CODE', UserInfo.divCode);
						panelResult.setValue('TYPE', '1');
						Ext.getCmp('GW').setDisabled(true);
						this.setDefault();
					},
					onQueryButtonDown : function() {
						if (panelResult.setAllFieldsReadOnly(true) == false) {
							return false;
						}
						if (panelResult.setAllFieldsReadOnly(true) == false) {
							return false;
						}
						masterGrid.getStore().loadStoreRecords();
						UniAppManager.setToolbarButtons([ 'reset' ], true);
					},
					setDefault : function() { // 기본값
						panelResult.setValue('DIV_CODE', UserInfo.divCode);
						panelResult.setValue('TYPE', '1');
						panelResult.setValue('APLY_START_DATE_FR', UniDate.get('startOfMonth'));
						panelResult.setValue('APLY_START_DATE_TO', UniDate.get('today'));
						panelResult.setValue('INPUT_DATE_FR', UniDate.get('startOfMonth'));
						panelResult.setValue('INPUT_DATE_TO', UniDate.get('today'));
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					},
					onResetButtonDown : function() { // 초기화
						this.suspendEvents();
						panelResult.clearForm();
						panelResult.setAllFieldsReadOnly(false);
						panelResult.setValue('DIV_CODE', UserInfo.divCode);
						panelResult.setValue('TYPE', '1');
						Ext.getCmp('GW').setDisabled(true);
						masterGrid.reset();
						this.fnInitBinding();
						directMasterStore1.clearData();
					},
					requestApprove : function() { //결재 요청
						var gsWin = window.open('about:blank', 'payviewer','width=500,height=500');

						var frm = document.f1;
						var compCode = UserInfo.compCode;
						var divCode = panelResult.getValue('DIV_CODE');
						var type = panelResult.getValue('TYPE');
						var supplyType = '';
						if(panelResult.getValue('SUPPLY_TYPE') != null){
							var supplyType = panelResult.getValue('SUPPLY_TYPE');
						}
						var customCodeFr = panelResult.getValue('CUSTOM_CODE_FR');
						var customCodeTo = panelResult.getValue('CUSTOM_CODE_TO');
						var itemCodeFr = panelResult.getValue('ITEM_CODE_FR');
						var itemCodeTo = panelResult.getValue('ITEM_CODE_TO');
						var applyDateFr = UniDate.getDbDateStr(panelResult.getValue('APLY_START_DATE_FR'));
						var applyDateTo = UniDate.getDbDateStr(panelResult.getValue('APLY_START_DATE_TO'));
						var inputDateFr = UniDate.getDbDateStr(panelResult.getValue('INPUT_DATE_FR'));  //UniDate.get('startOfMonth');
						var inputDateTo = UniDate.getDbDateStr(panelResult.getValue('INPUT_DATE_TO'));  //UniDate.get('today');
						var deptCode = '';
            var itemAccount = panelResult.getValue('ITEM_ACCOUNT')
						var allFlag = panelResult.getValue('ALL_FLAG');
						  if(allFlag == true){
							  allFlag = '1'
						  }else{

							  allFlag = '2'
						  }

						var spText = 'EXEC omegaplus_kdg.unilite.USP_GW_S_BCO300SKRV_KD '
								+ "'"
								+ compCode
								+ "'"
								+ ', '
								+ "'"
								+ divCode
								+ "'"
								+ ', '
								+ "'"
								+ type
								+ "'"
								+ ', '
								+ "'"
								+ supplyType
								+ "'"
								+ ', '
								+ "'"
								+ customCodeFr
								+ "'"
								+ ', '
								+ "'"
								+ customCodeTo
								+ "'"
								+ ', '
								+ "'"
								+ itemCodeFr
								+ "'"
								+ ', '
								+ "'"
								+ itemCodeTo
								+ "'"
								+ ', '
								+ "'"
								+ applyDateFr
								+ "'"
								+ ', '
								+ "'"
								+ applyDateTo
								+ "'"
								+ ', '
								+ "'"
								+ inputDateFr
								+ "'"
								+ ', '
								+ "'"
								+ inputDateTo
								+ "'"
								+ ', '
								+ "'"
								+ deptCode
								+ "'," 
								+ "'"
								+ itemAccount
								+ "'," 								
								+ "'" + allFlag + "'" ;

						var spCall = encodeURIComponent(spText);

						//            frm.action = '/payment/payreq.php';
						/* frm.action = groupUrl + "viewMode=docuDraft" + "&prg_no=s_bco300skrv_kd&draft_no=" + "0"	+ "&sp=" + spCall/* + Base64.encode();
						frm.target = "payviewer";
						frm.method = "post";
						frm.submit(); */

						var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_bco300skrv_kd&draft_no=" + "0"	+ "&sp=" + spCall;
			            UniBase.fnGw_Call(gwurl,frm); 
						
					}
				});
	};
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;">
	<input type="hidden" id="loginid" name="loginid" value="superadmin" />
	<input type="hidden" id="fmpf" name="fmpf" value="" /> <input
		type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
