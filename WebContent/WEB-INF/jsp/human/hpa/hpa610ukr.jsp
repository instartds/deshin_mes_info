<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa610ukr"  >
<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="B030" /> <!-- 세액구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H147" /> <!-- 입퇴사구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!-- 지급/공제구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-grid-item-focused  .x-grid-cell-inner:before {
	border: 0px; 
}
</style>

<script type="text/javascript" >
/**
 * 월차내역 탭은 사용안하기로 함..저장 sp필요.. 현재 조회까지만 됨.. unilite상에서는 버그 많음..
 * 
 * 
 */
function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hpa610ukrService.selectHPA400T',
			update: 'hpa610ukrService.updateDetail',
			syncAll: 'hpa610ukrService.saveAll'
		}
	}); 
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa610ukrModel1', {
		fields: [
			{name: 'PAY_YYYYMM'					, text: '<t:message code="system.label.human.suppyyyymm1" default="지급년월"/>'			, type: 'string'},
			{name: 'SUPP_TYPE'					, text: '<t:message code="system.label.human.bonustype" default="상여구분"/>'				, type: 'string'},
			{name: 'PERSON_NUMB'				, text: '<t:message code="system.label.human.personnumb" default="사번"/>'				, type: 'string'},
			{name: 'DED_CODE'					, text: '<t:message code="system.label.human.dedname" default="공제내역"/>'				, type: 'string'},
			{name: 'WAGES_NAME'					, text: '<t:message code="system.label.human.dedname" default="공제내역"/>'				, type: 'string'},
			{name: 'DED_AMOUNT_I'				, text: '<t:message code="system.label.human.dedamount" default="공제금액"/>'				, type: 'uniPrice'},
			{name: 'COMP_CODE'					, text: 'COMP_CODE'			, type: 'string'},
			{name: 'UPDATE_DB_USER'				, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'				, text: 'UPDATE_DB_TIME'	, type: 'string'}
		]
	});		//End of Unilite.defineModel('Hpa610ukrModel', {
		
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hpa610ukrMasterStore1', {
		model: 'Hpa610ukrModel1',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			param.SUPP_TYPE = 'F';
			this.load({
				params: param
			});
		},
		saveStore: function() {
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
				var toUpdate = this.getUpdatedRecords();				
				var toDelete = this.getRemovedRecords();
				var list = [].concat(toUpdate, toCreate);
	
				var paramMaster = Ext.Object.merge(panelResult.getValues(), detailForm.getValues()); ;	//syncAll 수정
				
				if(inValidRecs.length == 0) {
						config = {
								params: [paramMaster],
								success: function(batch, option) {
									directMasterStore1.loadStoreRecords();
								} 
						};
					this.syncAllDirect(config);
				}else{
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});//End of var directMasterStore1 = Unilite.createStore('hpa610ukrMasterStore1', {
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: {width: '100%'},
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {width: 500},	
			items:[{
				fieldLabel: '<t:message code="system.label.human.suppyyyymm1" default="지급년월"/>',
				xtype: 'uniMonthfield',
				name: 'PAY_YYYYMM',
				width:250,
				value: new Date(),
				allowBlank: false
				
			},			
				Unilite.popup('Employee',{
				valueFieldName: 'PERSON_NUMB',
				textFieldName: 'NAME',
				width:200,
				validateBlank: false,
				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
	
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					}
				}
			})]
		},
		{
			xtype: 'button',
			itemId : 'refBtn',
//			margin: '0 0 0 700',
//			align: 'right',
			text:'연월차수당 재계산',
			tdAttrs: {align : 'right'},
			handler: function() {
				if(!panelResult.getInvalidMessage()){
					return false;
				}
				
//				var formParam= Ext.getCmp('searchForm').getValues();
//				var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
//				var mon = payDate.getMonth() + 1;
//				var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);
//				
				var params = {
					PAY_YYYYMM : panelResult.getValue('PAY_YYYYMM'),
					PERSON_NUMB : panelResult.getValue('PERSON_NUMB'),
					NAME : panelResult.getValue('NAME')
				};
				var rec = {data : {prgID : 'hpa600ukr', 'text':'<t:message code="system.label.human.monthlypaycount" default="년월차수당계산"/>'}};						 
				parent.openTab(rec, '/human/hpa600ukr.do', params);
			}
		 }
		
		]	
	});
	
	var detailForm = Unilite.createForm('hpa610ukrDetailForm',{
		disabled :false,
		xtype: 'container',
		flex:1,
//		region: 'center',
		layout: {
			type: 'vbox', 
			align : 'stretch'
		},
		api: {
			load: 'hpa610ukrService.selectHPA600T'
		},
		padding: '1 1 1 1',
		border: true,
		items: [{
			xtype:'panel',
			padding: '60 1 1 1',
			defaultType: 'uniTextfield',
			flex: 1,
			border: false,
			defaults: {
				readOnly: true
			},
			layout: {
				type: 'uniTable',
				columns : 2
			},
			items: [{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.human.taxcalculation" default="세액계산"/>',
				labelWidth: 150,
//				margin : '20 0 0 150',
				id: 'rdoSelect1',
				defaults: {
					readOnly: true
				},
				hidden	: true,			//20210611 추가
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>', 
					width: 70, 
					name: 'rdoSelect1name',
					inputValue: 'Y'
				},{
					boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>', 
					width: 70,
					name: 'rdoSelect1name',
					inputValue: 'N',
					checked: true 
				}]
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.human.hireinsurtype2" default="고용보험계산"/>',
				labelWidth: 200,
//				margin: '0 0 30 150',
				id: 'rdoSelect2',
				defaults: {
					readOnly: true
				},
				hidden	: true,			//20210611 추가
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>', 
					width: 70, 
					name: 'rdoSelect2name',
					inputValue: 'Y'
				},{
					boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>', 
					width: 70,
					name: 'rdoSelect2name',
					inputValue: 'N',
					checked: true 
				}]
			},
				Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
					labelWidth: 150,
					textFieldWidth: 170,
					name: 'DEPT_CODE'
			}),{
				fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				name: 'PAY_CODE', 
				labelWidth: 200,
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H028'
			},{
				fieldLabel: '<t:message code="system.label.human.postcode" default="직위"/>',
				name: 'POST_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H005',
				labelWidth: 150
			},{
				fieldLabel: '<t:message code="system.label.human.taxtype" default="세액구분"/>',
				name: 'TAX_CODE', 
				labelWidth: 200,
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H029'
			},{
				fieldLabel: '<t:message code="system.label.human.abil" default="직책"/>',
				name: 'ABIL_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				labelWidth: 150,
				comboCode: 'H006'
			},{
				fieldLabel: '<t:message code="system.label.human.suppdate" default="지급일"/>',
// 				id: 'SUPP_DATE',
				labelWidth: 200,
				xtype: 'uniDatefield',
				name: 'SUPP_DATE'
			},{
				fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
				name: 'EMPLOY_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H024',
				labelWidth: 150
			},{
				xtype: 'radiogroup',							
				fieldLabel: '<t:message code="system.label.human.spouser" default="배우자"/>',	
				labelWidth: 200,										
				id: 'rdoSelect3',
				defaults: {
					readOnly: true
				},
				items: [{
					boxLabel: '<t:message code="system.label.human.have" default="유"/>', 
					width: 70, 
					name: 'SPOUSE',
					inputValue: 'Y'
				},{
					boxLabel : '<t:message code="system.label.human.havenot" default="무"/>', 
					width: 70,
					name: 'SPOUSE',
					inputValue: 'N',
					checked: true 
				}]
			},{
				fieldLabel: '<t:message code="system.label.human.joindate" default="입사일"/>',
				labelWidth: 150,
				xtype: 'uniDatefield',
				name: 'JOIN_DATE'
			},{
				layout: {type:'hbox'},
				xtype: 'container',
				defaults: {
					readOnly: true
				},
				items: [{
					fieldLabel: '<t:message code="system.label.human.agednum20" default="부양자.20세이하자녀"/>',
//					margin: '0 0 30 150',
					xtype: 'uniNumberfield',
					name: 'SUPP_NUM',
					flex: 3.5,
					labelWidth: 200,
					value: 0
				},{
					xtype: 'uniNumberfield',
					name: 'CHILD_20_NUM',
					flex: 1,
					suffixTpl: '<t:message code="system.label.human.num" default="명"/>',
					value: 0
				}]
			},{fieldLabel: '전년이월연차', name: 'IWALL_SAVE', id: 'IWALL_SAVE', labelWidth: 150, regex: /^[0-9]*$/, fieldStyle: 'text-align:right', listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						Ext.getCmp('YEARTOTAL').setValue(calcYearTotal());
//					  Ext.getCmp('MON_YEAR_PROV').setValue(calcMonYearProv());
//					  Ext.getCmp('BONUS_TOTAL_I').setValue(calcBonusTotal());
					}
				}
			}
			,{fieldLabel: '<t:message code="system.label.human.longtotmonth" default="총근속개월수"/>', name: 'LONG_MONTH', labelWidth: 200,  regex: /^[0-9]*$/, fieldStyle: 'text-align:right'}
			,{fieldLabel: '중간입사자연차', name: 'JOIN_YEAR_SAVE', id: 'JOIN_YEAR_SAVE', labelWidth: 150, regex: /^[0-9]*$/, fieldStyle: 'text-align:right', listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						Ext.getCmp('YEARTOTAL').setValue(calcYearTotal());
//					  Ext.getCmp('MON_YEAR_PROV').setValue(calcMonYearProv());
//					  Ext.getCmp('BONUS_TOTAL_I').setValue(calcBonusTotal());
					}
				}
			}
			,{fieldLabel: '<t:message code="system.label.human.yearbonusi" default="근속가산"/>', name: 'YEAR_ADD', id:'YEAR_ADD', regex: /^[0-9]*$/, labelWidth: 200, fieldStyle: 'text-align:right', listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						Ext.getCmp('YEARTOTAL').setValue(calcYearTotal());
//					  Ext.getCmp('MON_YEAR_PROV').setValue(calcMonYearProv());
//					  Ext.getCmp('BONUS_TOTAL_I').setValue(calcBonusTotal());
					}
				}
			}
			,{fieldLabel: '연차', name: 'YEAR_CRT', id: 'YEAR_CRT', labelWidth: 150, regex: /^[0-9]*$/, fieldStyle: 'text-align:right', listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						Ext.getCmp('YEARTOTAL').setValue(calcYearTotal());
//						Ext.getCmp('MON_YEAR_PROV').setValue(calcMonYearProv());
//						Ext.getCmp('BONUS_TOTAL_I').setValue(calcBonusTotal());
					}
				}
			}
			
			
			,{fieldLabel: '연차기준금',name: 'COM_YEAR_WAGES', id: 'BONUS_STD_I',  labelWidth: 200,  regex: /^[0-9]*$/, xtype:'uniNumberfield', listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						Ext.getCmp('BONUS_TOTAL_I').setValue(calcBonusTotal());
//					}
				}
			}
			,{fieldLabel: '총연차', name: 'YEARTOTAL', id: 'YEARTOTAL', labelWidth: 150, readOnly: true, fieldStyle: 'text-align:right'}
			,{
				xtype: 'panel',
				border: 0,
				margin: '0 0 0 150'
			}
			,{
				xtype: 'panel',
				border: 0
			}
			,{fieldLabel: '연차총액', name: 'BONUS_TOTAL_I', id: 'BONUS_TOTAL_I', readOnly: true, labelWidth: 200,  xtype:'uniNumberfield'}
			// TODO edit
			,{fieldLabel: '<t:message code="system.label.human.useday" default="사용일수"/>', name: 'MON_YEAR_USE',labelWidth: 150, id: 'MON_YEAR_USE', regex: /^[0-9]*$/, fieldStyle: 'text-align:right', listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						Ext.getCmp('MON_YEAR_PROV').setValue(calcMonYearProv());
//						Ext.getCmp('BONUS_TOTAL_I').setValue(calcBonusTotal());
//					}
				}
			}
			,{fieldLabel: '<t:message code="system.label.human.dedtotali" default="공제총액"/>', name: 'DED_TOTAL_I', readOnly: true, labelWidth: 200,  readOnly: true, xtype:'uniNumberfield'}
			,{fieldLabel: '<t:message code="system.label.human.givenum" default="지급일수"/>', name: 'MON_YEAR_PROV', id: 'MON_YEAR_PROV',labelWidth: 150, readOnly: true, fieldStyle: 'text-align:right'}
			,{fieldLabel: '<t:message code="system.label.human.realamounti" default="실지급액"/>', name: 'REAL_AMOUNT_I', readOnly: true, labelWidth: 200,  readOnly: true, xtype:'uniNumberfield'}
			,{fieldLabel: '<t:message code="system.label.human.busisharei" default="사회보험사업자부담금"/>', name: 'BUSI_SHARE_I', readOnly: true, labelWidth: 150, hidden: false, readOnly: true, xtype:'uniNumberfield'}
			,{
				xtype: 'panel',
				border: 0
			}
			//,{fieldLabel: '청년세액감면율', name: 'YOUTH_EXEMP_RATE', readOnly: true, labelWidth: 150,  readOnly: true, xtype:'uniNumberfield'}
			,{
				fieldLabel: '청년세액감면율',
				name: 'YOUTH_EXEMP_RATE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H179',
				labelWidth: 150
			}
			,{fieldLabel: '청년세액감면기간', name: 'YOUTH_EXEMP_DATE', readOnly: true, labelWidth: 200, hidden: false, readOnly: true, xtype: 'uniDatefield'}
			]
		}]
	});		// var detailForm = Unilite.createSearchPanel('resultForm1',{
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hpa610ukrGrid1', {
		flex:0.5,
		store: directMasterStore1,
		uniOpt: {
			expandLastColumn: false
//			copiedRow: true
//			useContextMenu: true,
		},
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true,
			dock:'bottom'
		}],
		columns: [
			{dataIndex: 'PAY_YYYYMM'				, width: 100, hidden: true},   
			{dataIndex: 'SUPP_TYPE'					, width: 100, hidden: true},   
			{dataIndex: 'PERSON_NUMB'				, width: 100, hidden: true},   
			{dataIndex: 'DED_CODE'					, width: 100, hidden: true},   
			{dataIndex: 'WAGES_NAME'				, width: 146, 
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.subtotal" default="소계"/>', '<t:message code="system.label.human.totwagesi" default="합계"/>');
				}
			},				
			{dataIndex: 'DED_AMOUNT_I'				, flex: 1, summaryType:'sum'},				
			{dataIndex: 'COMP_CODE'					, width: 100, hidden: true},   
			{dataIndex: 'UPDATE_DB_USER'			, width: 100, hidden: true}, 
			{dataIndex: 'UPDATE_DB_TIME'			, width: 100, hidden: true}  
		],
		listeners:{
			beforeedit: function( editor, e, eOpts ) {
				
				if(UniUtils.indexOf(e.field, ['DED_AMOUNT_I'])){
					return true;
				}else{
					return false;
				}
			}
		}
		
	});//End of var masterGrid = Unilite.createGr100id('hpa610ukrGrid1', {  
	
	Unilite.Main( {
		 borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,
				
				{
				region:'center',
				xtype:'container',
				layout:{type:'hbox', align:'stretch'},
				title:'연차내역',
				items:[
					masterGrid,detailForm
				]
			}
				
			]
		}],
		id: 'hpa610ukrApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons(['newData','delete','save'], false);
			panelResult.setValue('PAY_YYYYMM', new Date());
			panelResult.onLoadSelectText('PERSON_NUMB');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			}
//			panelResult.getForm().getFields().each(function (field) {
//				 field.setReadOnly(true);
//			});
			detailForm.mask('<t:message code="system.label.human.loading" default="로딩중..."/>','loading-indicator');
			directMasterStore1.loadStoreRecords();	

			var param= panelResult.getValues();
			detailForm.getForm().load({
				params: param,
				success: function(form, action) {
			
					detailForm.unmask();
			
				},
				failure: function(form, action) {
					detailForm.unmask();
				}
			})
			//UniAppManager.setToolbarButtons('delete', true);
		},
		onResetButtonDown: function() {
			masterGrid.reset();
			directMasterStore1.clearData();
			panelResult.clearForm();
			detailForm.clearForm();
			panelResult.getForm().getFields().each(function (field) {
				 field.setReadOnly(false);
			});
			UniAppManager.app.fnInitBinding();
		},
		onDeleteDataButtonDown : function() {
			Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message009" default="삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					var searchForm = Ext.getCmp('resultForm');

					if(UniAppManager.app.isValidSearchForm())   {
						var param= searchForm.getValues();
						hpa610ukrService.closedateconfirm(param, function(provider, response){
							if(!Ext.isEmpty(provider) && param.PAY_YYYYMM <= provider){
								alert('전체마감된 자료입니다.' + '마감년월 :' + provider);
								return false;
							}else{
								hpa610ukrService.closedateconfirm1(param, function(provider, response){
									if(!Ext.isEmpty(provider) && param.PAY_YYYYMM <= provider){
										alert('개인별마감된 자료입니다.' + '마감년월 :' + provider);
										return false;
									}else{
										hpa610ukrService.deleteList(param, function(provider, response){
											UniAppManager.app.onResetButtonDown();
										});
									}
								});
							}
						});
					}
				}
			});
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onPrevDataButtonDown: function() {
			console.log('Go Prev > ' + data[0].PV_D + 'NAME > ' + data[0].PV_NAME);
			loadRecord(data[0].PV_D, data[0].PV_NAME, tab.getActiveTab().getId());
		},
		onNextDataButtonDown: function() {
			console.log('Go Next > ' + data[0].NX_D + 'NAME > ' + data[0].NX_NAME);
			loadRecord(data[0].NX_D, data[0].NX_NAME, tab.getActiveTab().getId());
		},		
		//링크로 넘어오는 params 받는 부분 (hpa950skr)
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'hpa950skr') {
				panelResult.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
//				panelSearch.setValue('SUPP_TYPE'	,params.SUPP_NAME);
				panelResult.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelResult.setValue('NAME'			,params.NAME);

				/*panelResult.setValue('PAY_YYYYMM'	,params.data.PAY_YYYYMM);
//				panelResult.setValue('SUPP_TYPE'	,params.data.SUPP_NAME);
				panelResult.setValue('PERSON_NUMB'	,params.data.PERSON_NUMB);
				panelResult.setValue('NAME'			,params.data.NAME);*/
				loadRecord('', '', tab.getActiveTab().getId());
			}
		}

	});//End of Unilite.Main( {
	
	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "DED_AMOUNT_I" :

					detailForm.setValue('DED_TOTAL_I', 0);
					detailForm.setValue('REAL_AMOUNT_I', 0);
					
				var records = directMasterStore1.data.items;
				var dedTotalI = 0;
					Ext.each(records, function(item, i) {
						dedTotalI = dedTotalI + item.get('DED_AMOUNT_I');
					});

					detailForm.setValue('DED_TOTAL_I', dedTotalI - oldValue + newValue );
					detailForm.setValue('REAL_AMOUNT_I', detailForm.getValue('BONUS_TOTAL_I') - (dedTotalI - oldValue + newValue));
				break;
			}
			return rv;
		}
	});
	
	
	// 그리드 및 폼의 데이터를 불러옴
	 function loadRecord(person_numb, name, tabId) {
			Ext.getCmp('PERSON_NUMB').setReadOnly(true);
			Ext.getCmp('PAY_YYYYMM').setReadOnly(true);
			UniAppManager.setToolbarButtons('reset',true);
			
			if (tabId == 'tab01'){
				// grid
				directMasterStore1.loadStoreRecords(person_numb, name);
				// form
				var param = Ext.getCmp('searchForm').getValues();
				param.SUPP_TYPE = 'F';
				detailForm.getForm().load({
					 params : param,
					 success: function(form, action){
						 Ext.getCmp('rdoSelect3').setValue({SPOUSE : action.result.data.SPOUSE});
						 if (typeof action.result.data.MON_YEAR_USE !== 'undefined') {
							form.getFields().each(function (field) {
								if (field.name == 'rdoSelect1name' || field.name == 'rdoSelect2name') {
									field.setReadOnly(false);
								} else {
									field.setReadOnly(true);
								}
							});
						} else {
							form.getFields().each(function (field) {
								if (field.name == 'YEARTOTAL' || field.name == 'MON_YEAR_PROV' || field.name == 'BUSI_SHARE_I' ||
										field.name == 'AL_I' || field.name == 'DED_TOTAL_I' || field.name == 'REAL_AMOUNT_I') {
									field.setReadOnly(true);
								}
							});	
						}
					 },
					 failure: function(form, action) {
						// form reset
						 form.getFields().each(function (field) {
							 field.setValue('');
						 });
					 }
					}
				);
			} 
//			else {
//				// grid
//				directMasterStore2.loadStoreRecords(person_numb, name);
//				// form
//				var param = Ext.getCmp('searchForm').getValues();
//				param.SUPP_TYPE = 'G';
//				detailForm2.getForm().load({
//					params : param,
//					success: function(form, action){
//						console.log(action);
//						Ext.getCmp('rdoSelect6').setValue({SPOUSE : action.result.data.SPOUSE});
//						if (typeof action.result.data.MON_YEAR_USE !== 'undefined') {
//							form.getFields().each(function (field) {
//								if (field.name == 'rdoSelect4name' || field.name == 'rdoSelect5name') {
//									field.setReadOnly(false);
//								} else {
//									field.setReadOnly(true);
//								}
//							});
//						} else {
//							form.getFields().each(function (field) {
//								if (field.name == 'MON_YEAR_PROV' || field.name == 'BUSI_SHARE_I' ||
// 									field.name == 'AL_I' || field.name == 'DED_TOTAL_I' || field.name == 'REAL_AMOUNT_I') {
//									field.setReadOnly(true);
//								}
//							});	
//						}
//					},
//					failure: function(form, action) {
//						form.getFields().each(function (field) {
//							field.setValue('');
//						});
//					}
//				});
//			}
			
			// TODO : Fix it!!
//			var viewNormal1 = masterGrid.normalGrid.getView();
//			var viewNormal2 = masterGrid2.normalGrid.getView();
//			viewNormal1.getFeature('masterGridTotal1').toggleSummaryRow(true);
//			viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
			// Prev, Next 데이터 검사
			checkAvailableNavi();
	}

	// 선택된 사원의 전후로 데이터가 있는지 검색함
	function checkAvailableNavi(){
		 var param = Ext.getCmp('searchForm').getValues();
		 console.log(param);
		 Ext.Ajax.request({
			 url: CPATH+'/human/checkAvailableNaviHpa330.do',
			 params: param,
			 success: function(response){
				 data = Ext.decode(response.responseText);
				 console.log(data);
				 var prevBtnAvailable = (data[0].PV_D == 'BOF' ? false : true)
				 var nextBtnAvailable = (data[0].NX_D == 'EOF' ? false : true)
				 UniAppManager.setToolbarButtons('prev', prevBtnAvailable);
				 UniAppManager.setToolbarButtons('next', nextBtnAvailable);
			 },
			 failure: function(response){
				 console.log(response);
			 }
		});
	}

	// 총년차 계산
	function calcYearTotal() {
		var yearTotal = 0;
		if (Ext.getCmp('YEAR_CRT').getValue() != '' && Ext.getCmp('YEAR_CRT').getValue() != null) {
			yearTotal = Ext.getCmp('YEAR_CRT').getValue();
		}
		if (Ext.getCmp('YEAR_ADD').getValue() != '' && Ext.getCmp('YEAR_ADD').getValue() != null) {
			yearTotal =  parseInt(yearTotal) + parseInt(Ext.getCmp('YEAR_ADD').getValue());
		}
		if (Ext.getCmp('IWALL_SAVE').getValue() != '' && Ext.getCmp('IWALL_SAVE').getValue() != null) {
			yearTotal =  parseInt(yearTotal) + parseInt(Ext.getCmp('IWALL_SAVE').getValue());
		}
		if (Ext.getCmp('JOIN_YEAR_SAVE').getValue() != '' && Ext.getCmp('JOIN_YEAR_SAVE').getValue() != null) {
			yearTotal =  parseInt(yearTotal) + parseInt(Ext.getCmp('JOIN_YEAR_SAVE').getValue());
		}
		return yearTotal;
	}
//		
//	// 년차 지급일수 계산
//	function calcMonYearProv() {
//		var monYearProv = 0;
//		if (Ext.getCmp('YEARTOTAL').getValue() != '' && Ext.getCmp('YEARTOTAL').getValue() != null) {
//			monYearProv = Ext.getCmp('YEARTOTAL').getValue();
//		}
//		if (Ext.getCmp('MON_YEAR_USE').getValue() != '' && Ext.getCmp('MON_YEAR_USE').getValue() != null) {
//			monYearProv =  parseInt(monYearProv) - parseInt(Ext.getCmp('MON_YEAR_USE').getValue()) / 100;
//		}
//		return monYearProv;
//	}
//	
//	// 년차총액 계산
//	function calcBonusTotal() {
//		var bonusTotal = 0;
//		if (Ext.getCmp('BONUS_STD_I').getValue() != '' && Ext.getCmp('BONUS_STD_I').getValue() != null) {
//			bonusTotal = Ext.getCmp('BONUS_STD_I').getValue();
//		}
//		if (Ext.getCmp('MON_YEAR_PROV').getValue() != '' && Ext.getCmp('MON_YEAR_PROV').getValue() != null) {
//			bonusTotal =  parseInt(bonusTotal) * parseInt(Ext.getCmp('MON_YEAR_PROV').getValue());
//		}
//		return bonusTotal;
//	}
//	
//	// 월차총액 계산
//	function calcBonusTotal2() {
//		var bonusTotal = 0;
//		if (Ext.getCmp('BONUS_STD_I2').getValue() != '' && Ext.getCmp('BONUS_STD_I2').getValue() != null) {
//			bonusTotal = Ext.getCmp('BONUS_STD_I2').getValue();
//		}
//		if (Ext.getCmp('MON_YEAR_PRO2V').getValue() != '' && Ext.getCmp('MON_YEAR_PROV2').getValue() != null) {
//			bonusTotal =  parseInt(bonusTotal) * parseInt(Ext.getCmp('MON_YEAR_PROV2').getValue());
//		}
//		return bonusTotal;
//	}
};
</script>