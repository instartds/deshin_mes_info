<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa580skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="ssa580skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>			<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056"/>			<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>			<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B066"/>			<!-- 세금계산서종류 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**Model 정의
	 * @type
	 */
	Unilite.defineModel('Ssa580skrvModel1', {
		fields: [
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.client" default="고객"/>'								,type: 'string'},
			{name: 'CUSTOM_FULL_NAME'		,text: '<t:message code="system.label.sales.clientname" default="고객명"/>(<t:message code="system.label.sales.fullname" default="전명"/>)'	,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.clientname" default="고객명"/>(<t:message code="system.label.sales.name3" default="약명"/>)'		,type: 'string'},
			{name: 'BILL_DATE'				,text: '<t:message code="system.label.sales.publishdate" default="발행일"/>'						,type: 'uniDate'},
			{name: 'BILL_TYPE_CD'			,text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'						,type: 'string'},
			{name: 'BILL_TYPE_NM'			,text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'						,type: 'string'},
			{name: 'PUB_NUM'				,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'							,type: 'string'},
			{name: 'SALE_LOC_AMT_I'			,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'						,type: 'uniPrice'},
			{name: 'TAX_AMT_O'				,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'							,type: 'uniPrice'},
			{name: 'TOT_SALE_LOC_AMT'		,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'						,type: 'uniPrice'},
			{name: 'COLET_AMT'				, text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'					,type: 'uniPrice'},
			{name: 'UN_COLL_AMT'			,text: '<t:message code="system.label.sales.arbalance" default="미수잔액"/>'						,type: 'uniFC', defaultValue: 0},

			{name: 'PUB_FR_DATE'			,text: '<t:message code="system.label.sales.salesdatefrom" default="매출일(FROM)"/>'				,type: 'uniDate'},
			{name: 'PUB_TO_DATE'			,text: '<t:message code="system.label.sales.salesdateto" default="매출일(TO)"/>'					,type: 'uniDate'},
			{name: 'RECEIPT_PLAN_DATE'		,text: '<t:message code="system.label.sales.collectionschdate" default="수금예정일"/>'				,type: 'uniDate'},
			//20210616 추가
			{name: 'PRE_SEND_YN'			,text: '<t:message code="system.label.sales.presendyn" default="선발행여부"/>'						,type: 'string'},
			{name: 'AGENT_TYPE'				,text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>'						,type: 'string'},
			{name: 'AREA_TYPE'				,text: '<t:message code="system.label.sales.area" default="지역"/>'								,type: 'string'},
			{name: 'MANAGE_CUSTOM_CD'		,text: '<t:message code="system.label.sales.summarycustomcode" default="집계거래처코드"/>'			,type: 'string'},
			{name: 'MANAGE_CUSTOM_NM'		,text: '<t:message code="system.label.sales.summarycustomname" default="집계거래처명"/>'				,type: 'string'},
			{name: 'PROJECT_NO'				,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'						,type: 'string'},
			{name: 'PJT_CODE'				,text: '<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'					,type: 'string'},
			{name: 'PJT_NAME'				,text: '<t:message code="system.label.sales.project" default="프로젝트"/>'							,type: 'string'},
			{name: 'REMARK'					,text: '<t:message code="system.label.sales.remarks" default="비고"/>'							,type: 'string'},
			{name: 'COMPANY_NUM1'			,text: '<t:message code="system.label.sales.summarycustompersonnum" default="집계거래처사업자번호"/>'	,type: 'string'},
			{name: 'GUBUN'					,text: '<t:message code="system.label.sales.classfication" default="구분"/>'						,type: 'string'},
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'					,type: 'string'},
			{name: 'SORT'					,text: '<t:message code="system.label.sales.btnSort" default="정렬"/>'							,type: 'string'},
			{name: 'SALE_DIV_CODE'			,text: '<t:message code="system.label.sales.salesdivcode" default="영업사업장코드"/>'					,type: 'string'},
			{name: 'BILL_SEND_YN'			,text: '<t:message code="system.label.sales.sendyn" default="전송여부"/>'							,type: 'string'},
			{name: 'EB_NUM'					,text: '<t:message code="system.label.sales.electronicbillnum" default="전자세금계산서번호"/>'			,type: 'string'},
			{name: 'BILL_FLAG'				,text: '<t:message code="system.label.sales.billclass" default="계산서유형"/>'						,type: 'string'},
			{name: 'MODI_REASON'			,text: '<t:message code="system.label.sales.updatereason" default="수정사유"/>'						,type: 'string'},
			{name: 'SALE_PRSN'				,text: '<t:message code="system.label.sales.salescharger" default="영업담당자"/>'					,type: 'string'},
			{name: 'SALE_PRSN2'				,text: '매출담당자'																					,type: 'string'},
			{name: 'BEFORE_PUB_NUM'			,text: '<t:message code="system.label.sales.beforebillnum" default="수정전계산서번호"/>'				,type: 'string'},
			{name: 'ORIGINAL_PUB_NUM'		,text: '<t:message code="system.label.sales.beforepubnum" default="원본계산서번호"/>'					,type: 'string'},
			{name: 'PLUS_MINUS_TYPE'		,text: '<t:message code="system.label.sales.invoiceclass" default="계산서구분"/>'					,type: 'string'},
			{name: 'COMPANY_NUM'			,text: '<t:message code="system.label.sales.businessnumber" default="사업자번호"/>'					,type: 'string'},
			{name: 'SERVANT_COMPANY_NUM'	,text: '<t:message code="system.label.sales.servantbusinessnum" default="종사업자번호"/>'			,type: 'string'},
			{name: 'TOP_NAME'				,text: '<t:message code="system.label.sales.representativename" default="대표자명"/>'				,type: 'string'},
			{name: 'ADDR'					,text: '<t:message code="system.label.sales.address" default="주소"/>'							,type: 'string'},
			{name: 'COMP_CLASS'				,text: '<t:message code="system.label.sales.businesstype" default="업종"/>'						,type: 'string'},
			{name: 'COMP_TYPE'				,text: '<t:message code="system.label.sales.businessconditions" default="업태"/>'					,type: 'string'},
			{name: 'RECEIVE_PRSN_NAME'		,text: '<t:message code="system.label.sales.receiveprsnname" default="공급받는자명"/>'				,type: 'string'},
			{name: 'RECEIVE_PRSN_EMAIL'		,text: '<t:message code="system.label.sales.receiveprsnemail" default="공급받는자이메일"/>'			,type: 'string'},
			{name: 'RECEIVE_PRSN_TEL'		,text: '<t:message code="system.label.sales.receiveprsntel" default="공급받는자전화번호"/>'			,type: 'string'},
			{name: 'RECEIVE_PRSN_MOBL'		,text: '<t:message code="system.label.sales.receiveprsnmobl" default="공급받는자핸드폰"/>'				,type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('ssa580skrvMasterStore1',{
		model	: 'Ssa580skrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'ssa580skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	


	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
			items: [{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
				items: [{
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				}, {
					fieldLabel: '<t:message code="system.label.sales.publishdate" default="발행일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_DATE',
					endFieldName: 'TO_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,					
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);
							// panelResult.getField('ISSUE_REQ_DATE_FR').validate();
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_DATE', newValue);
							// panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
				}, {
					fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
					name: 'SALE_PRSN', 
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S010',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SALE_PRSN', newValue);
						}
					}
				},
					Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),{
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.sales.autoslipyn" default="자동기표여부"/>',
					items: [{
						boxLabel : '<t:message code="system.label.sales.whole" default="전체"/>',
						name: 'SLIP_YN',
						inputValue: 'A',
						checked: true ,
						width: 50 
					}, {
						boxLabel : '<t:message code="system.label.sales.slipposting" default="기표"/>',
						name: 'SLIP_YN',
						inputValue: 'Y', 
						width: 50
					}, {
						boxLabel : '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
						name: 'SLIP_YN' ,
						inputValue: 'N', 
						width: 70
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							// panelSearch.getField('SALE_YN').setValue({SALE_YN:
							// newValue});
							panelResult.getField('SLIP_YN').setValue(newValue.SLIP_YN);
						}
					}
				},
				{
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.sales.collectyn"  default="수금여부"/>',
					items: [{
						boxLabel : '<t:message code="system.label.sales.whole" default="전체"/>',
						name: 'COLLECT_YN',
						inputValue: 'A',
						checked: true ,
						width: 50 
					}, {
						boxLabel : '<t:message code="system.label.sales.getcollecting" default="예"/>',
						name: 'COLLECT_YN',
						inputValue: '1', 
						width: 50
					}, {
						boxLabel : '<t:message code="system.label.sales.notcollecting" default="아니오"/>',
						name: 'COLLECT_YN' ,
						inputValue: '2', 
						width: 70
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('COLLECT_YN').setValue(newValue.COLLECT_YN);
						}
					}
				},
					{	//20210616 추가
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.sales.presendyn"  default="선발행여부"/>',
					items: [{
						boxLabel : '<t:message code="system.label.sales.whole" default="전체"/>',
						name: 'PRE_SEND_YN',
						inputValue: 'A',
						checked: true ,
						width: 50 
					}, {
						boxLabel : '<t:message code="system.label.sales.getsending" default="예"/>',
						name: 'PRE_SEND_YN',
						inputValue: '1', 
						width: 50
					}, {
						boxLabel : '<t:message code="system.label.sales.notsending" default="아니오"/>',
						name: 'PRE_SEND_YN' ,
						inputValue: '2', 
						width: 60
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('PRE_SEND_YN').setValue(newValue.PRE_SEND_YN);
						}
					}
				}]	
			}]
		}, {
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
			 	fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
			 	name: 'AGENT_TYPE',
			 	xtype: 'uniCombobox',
			 	comboType: 'AU',
			 	comboCode: 'B055'
			 },
			 	Unilite.popup('AGENT_CUST',{
			 	fieldLabel: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
			 	valueFieldName:'MNG_CUSTOM_CODE',
				textFieldName:'MNG_CUSTOM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('MNG_CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('MNG_CUSTOM_NAME', '');
							panelResult.setValue('MNG_CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('MNG_CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('MNG_CUSTOM_CODE', '');
							panelResult.setValue('MNG_CUSTOM_CODE', '');
						}
					}
				}
			}),{
				xtype: 'uniNumberfield',
				fieldLabel: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>',
				name: 'FROM_AMT' ,
				suffixTpl: '&nbsp;<t:message code="system.label.sales.over" default="이상"/>'
			}, {
				xtype: 'uniNumberfield',
				fieldLabel: '~',
				name: 'TO_AMT' ,
				suffixTpl: '&nbsp;<t:message code="system.label.sales.below" default="이하"/>'
			}, {
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name: 'AREA_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B056'
			}, {
			 	xtype: 'container',
				defaultType: 'uniTextfield',
 				layout: {type: 'uniTable', columns: 1},
 				width: 315,
 				items: [{
 					fieldLabel: '<t:message code="system.label.sales.billno" default="계산서번호"/>',
 					name: 'FROM_NUM'
 				}, {
 					fieldLabel: '~',
 					name: 'TO_NUM'
 				}] 
			}, {
				fieldLabel: '<t:message code="system.label.sales.billtype" default="계산서종류"/>',
				name: 'BILL_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B066'
			}]
		}], setAllFieldsReadOnly: function(b) {
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
				}
			}
			return r;
		}
	});		

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.publishdate" default="발행일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_DATE',
			endFieldName: 'TO_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,					
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
					// panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE', newValue);
					// panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
			name: 'SALE_PRSN', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.sales.autoslipyn" default="자동기표여부"/>',
			items: [{
				boxLabel : '<t:message code="system.label.sales.whole" default="전체"/>',
				name: 'SLIP_YN',
				inputValue: 'A',
				checked: true ,
				width: 50 
			}, {
				boxLabel : '<t:message code="system.label.sales.slipposting" default="기표"/>',
				name: 'SLIP_YN',
				inputValue: 'Y', 
				width: 50
			}, {
				boxLabel : '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
				name: 'SLIP_YN' ,
				inputValue: 'N', 
				width: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					// panelSearch.getField('SALE_YN').setValue({SALE_YN:
					// newValue});
					panelSearch.getField('SLIP_YN').setValue(newValue.SLIP_YN);
				}
			}
		},
		{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.sales.collectyn"  default="수금여부"/>',
			items: [{
				boxLabel : '<t:message code="system.label.sales.whole" default="전체"/>',
				name: 'COLLECT_YN',
				inputValue: 'A',
				checked: true ,
				width: 60 
			}, {
				boxLabel : '<t:message code="system.label.sales.getcollecting" default="예"/>',
				name: 'COLLECT_YN',
				inputValue: '1', 
				width: 50
			}, {
				boxLabel : '<t:message code="system.label.sales.notcollecting" default="아니오"/>',
				name: 'COLLECT_YN' ,
				inputValue: '2', 
				width: 70
			}],
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('COLLECT_YN').setValue(newValue.COLLECT_YN);
					}
				}
			},
		{	//20210616 추가
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.sales.presendyn"  default="선발행여부"/>',
			items: [{
				boxLabel : '<t:message code="system.label.sales.whole" default="전체"/>',
				name: 'PRE_SEND_YN',
				inputValue: 'A',
				checked: true ,
				width: 50 
			}, {
				boxLabel : '<t:message code="system.label.sales.getsending" default="예"/>',
				name: 'PRE_SEND_YN',
				inputValue: '1', 
				width: 50
			}, {
				boxLabel : '<t:message code="system.label.sales.notsending" default="아니오"/>',
				name: 'PRE_SEND_YN' ,
				inputValue: '2', 
				width: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('PRE_SEND_YN').setValue(newValue.PRE_SEND_YN);
					}
				}
			}]	
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('ssa660skrvGrid1', {
		store	: directMasterStore1,
		region	: 'center',	
		layout	: 'fit',
		uniOpt	: {
			useContextMenu	: true,		//20200221 [매출현황조회, 개별세금계산서등록]으로 화면 링크 기능 추가
			useRowNumberer	: false
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{ dataIndex: 'CUSTOM_CODE'			, width: 80, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			}
			,{ dataIndex: 'CUSTOM_FULL_NAME'	, width: 146, locked: true	}
			,{ dataIndex: 'CUSTOM_NAME'			, width: 146, hidden: true}
			,{ dataIndex: 'BILL_DATE'			, width: 80	, locked: true}
			,{ dataIndex: 'BILL_TYPE_CD'		, width: 93	, hidden: true}
			,{ dataIndex: 'BILL_TYPE_NM'		, width: 93	, locked: true}
			,{ dataIndex: 'PUB_NUM'				, width: 113, locked: true}
			,{ dataIndex: 'SALE_LOC_AMT_I'		, width: 120, summaryType: 'sum'}
			,{ dataIndex: 'TAX_AMT_O'			, width: 100, summaryType: 'sum'}
			,{ dataIndex: 'TOT_SALE_LOC_AMT'	, width: 120, summaryType: 'sum'}
			,{ dataIndex: 'COLET_AMT'	, width: 120, summaryType: 'sum'}
			,{ dataIndex: 'UN_COLL_AMT'	, width: 120, summaryType: 'sum'}
			
			,{ dataIndex: 'PUB_FR_DATE'			, width: 93	}
			,{ dataIndex: 'PUB_TO_DATE'			, width: 93	}
			,{ dataIndex: 'RECEIPT_PLAN_DATE'	, width: 93	}
			//20210616 추가
			,{ dataIndex: 'PRE_SEND_YN'			, width: 93, align:'center'}
			,{ dataIndex: 'AGENT_TYPE'			, width: 93	}
			,{ dataIndex: 'AREA_TYPE'			, width: 93	}
			,{ dataIndex: 'MANAGE_CUSTOM_CD'	, width: 100}
			,{ dataIndex: 'MANAGE_CUSTOM_NM'	, width: 120}
			,{ dataIndex: 'PROJECT_NO'			, width: 93	}
			,{ dataIndex: 'PJT_CODE'			, width: 80	, hidden: true}
			,{ dataIndex: 'PJT_NAME'			, width: 166}
			,{ dataIndex: 'REMARK'				, width: 120}
			,{ dataIndex: 'COMPANY_NUM1'		, width: 120}
			,{ dataIndex: 'GUBUN'				, width: 66, hidden: true}
			,{ dataIndex: 'DIV_CODE'			, width: 66, hidden: true}
			,{ dataIndex: 'SORT'				, width: 66, hidden: true}
			,{ dataIndex: 'SALE_DIV_CODE'		, width: 66, hidden: true}
			,{ dataIndex: 'BILL_SEND_YN'		, width: 66	}
			,{ dataIndex: 'EB_NUM'				, width: 120}
			,{ dataIndex: 'BILL_FLAG'			, width: 80	}
			,{ dataIndex: 'MODI_REASON'			, width: 120}
			,{ dataIndex: 'SALE_PRSN'			, width: 86	}
			,{ dataIndex: 'SALE_PRSN2'			, width: 86	}
			,{ dataIndex: 'BEFORE_PUB_NUM'		, width: 120}
			,{ dataIndex: 'ORIGINAL_PUB_NUM'	, width: 106}
			,{ dataIndex: 'PLUS_MINUS_TYPE'		, width: 80	}
			,{ dataIndex: 'COMPANY_NUM'			, width: 93	}
			,{ dataIndex: 'SERVANT_COMPANY_NUM'	, width: 80	}
			,{ dataIndex: 'TOP_NAME'			, width: 80	}
			,{ dataIndex: 'ADDR'				, width: 166}
			,{ dataIndex: 'COMP_CLASS'			, width: 120}
			,{ dataIndex: 'COMP_TYPE'			, width: 66	}
			,{ dataIndex: 'RECEIVE_PRSN_NAME'	, width: 100}
			,{ dataIndex: 'RECEIVE_PRSN_EMAIL'	, width: 146}
			,{ dataIndex: 'RECEIVE_PRSN_TEL'	, width: 146}
			,{ dataIndex: 'RECEIVE_PRSN_MOBL'	, width: 146}
		],
		//20200221 [매출현황조회, 개별세금계산서등록]으로 화면 링크 기능 추가
		listeners:{
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text	: '매출현황 조회',   iconCls : '',
					handler	: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender		: me,
							'PGM_ID'	: 'ssa580skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							PUB_NUM		: record.data.PUB_NUM,
							PUB_FR_DATE	: record.data.PUB_FR_DATE,
							PUB_TO_DATE	: record.data.PUB_TO_DATE,
							CUSTOM_CODE	: record.data.CUSTOM_CODE,
							CUSTOM_NAME	: record.data.CUSTOM_NAME
						}
						var rec = {data : {prgID : 'ssa450skrv', 'text':''}};
						parent.openTab(rec, '/sales/ssa450skrv.do', params);
					}
				});
				this.contextMenu.add({
					text	: '개별세금계산서 등록',   iconCls : '',
					handler	: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender		: me,
							'PGM_ID'	: 'ssa580skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							PUB_NUM		: record.data.PUB_NUM
						}
						var rec = {data : {prgID : 'ssa560ukrv', 'text':''}};
						parent.openTab(rec, '/sales/ssa560ukrv.do', params);
					}
				});
			}
		}
	});



	Unilite.Main({
		id			: 'ssa580skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail', true);
			UniAppManager.setToolbarButtons('reset'	, false);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>