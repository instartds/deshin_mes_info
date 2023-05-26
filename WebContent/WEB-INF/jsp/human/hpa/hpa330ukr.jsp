<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa330ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!-- 지급/공제구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B028" /> <!-- 직간접구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직종 -->
	<t:ExtComboStore comboType="AU" comboCode="H007" /> <!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H029" /> <!-- 세액구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' />			<!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H034" /> <!-- 공제코드분 -->
	<t:ExtComboStore comboType="AU" comboCode="H036" /> <!-- 잔업구분자 -->
	<t:ExtComboStore comboType="AU" comboCode="H048" /> <!-- 입퇴사자구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H147" /> <!-- 입퇴사구분 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->


<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var gsSaveButtonYn = 0;						// 조회시에는 저장버튼 비활성화 하기 위한 변수 설정
	var gsList1 = '${gsList1}';					// 지급구분 '1'인 것만 콤보에서 보이도록 설정
	var dutyRefWindow;							// 월근무 현황 보기 팝업
	var yearEndWindow;                          // 연말정산 데이터 조회
	var gsPrev = 'N';
	var gsInitChk = 'Y';
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa330ukrService.selectList1',
			create  : 'hpa330ukrService.updateList1',
			update	: 'hpa330ukrService.updateList1',
			syncAll	: 'hpa330ukrService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa330ukrService.selectList2',
			create  : 'hpa330ukrService.updateList2',
			update	: 'hpa330ukrService.updateList2',
			syncAll	: 'hpa330ukrService.saveAll2'
		}
	});

	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Hpa330ukrModel', {
	   fields: [
			{name: 'PAY_YYYYMM'			, text: '<t:message code="system.label.human.suppyyyymm1" default="지급년월"/>'		, type: 'string'},
			{name: 'SUPP_TYPE'			, text: '<t:message code="system.label.human.supptype" default="지급구분"/>'			, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'			, type: 'string'},
			{name: 'WAGES_CODE'			, text: '<t:message code="system.label.human.stdname" default="지급내역"/>'			, type: 'string',  editable: false},
			{name: 'WAGES_NAME'			, text: '<t:message code="system.label.human.dedname" default="공제내역"/>'			, type: 'string',  editable: false},
			{name: 'AMOUNT_I'			, text: '<t:message code="system.label.human.payi" default="지급금액"/>'				, type: 'uniPrice'},//  editable: true},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'},
			{name: 'DED_CODE'			, text: '<t:message code="system.label.human.dedcode" default="공제코드"/>'			, type: 'string'},
			{name: 'DED_AMOUNT_I'		, text: '<t:message code="system.label.human.dedamount" default="공제금액"/>'			, type: 'uniPrice'}//,  editable: true}
	    ]
	});		// End of Ext.define('Hpa330ukrModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('hpa330MasterStore1',{
		model: 'Hpa330ukrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결
            editable	: true,			// 수정 모드 사용
            deletable	: true,			// 삭제 가능 여부
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			//var toCreate = this.getNewRecords();
        	//var toUpdate = this.getUpdatedRecords();
        	//console.log("toUpdate",toUpdate);

        	var rv = true;
   			var paramMaster = panelSearch.getValues();
			Ext.merge(paramMaster, panelResult.getValues());
			Ext.merge(paramMaster, panelResult2.getValues());
   			console.log("paramMaster : ",paramMaster);
        	if(inValidRecs.length == 0 )	{
				var config = {
					params:[paramMaster],
					success: function(batch, option) {
						if(directMasterStore2.isDirty())	{
							//directMasterStore2.saveStore();

	                    	if (gsPrev == 'Y')	{
								hpa330ukrService.deleteList2(paramMaster, function(provider, response){
				                	directMasterStore2.saveStore();
				            	});
					 		} else {
					 			directMasterStore2.saveStore();
					 		}

						}else{
						  if (gsPrev == 'Y')	{
							  hpa330ukrService.insertHPA600(paramMaster, function(provider, response){
				                	hpa330ukrService.calPayroll(paramMaster, function(){
//										UniAppManager.app.onQueryButtonDown();
									});
				            	});
						  }

						  UniAppManager.app.onQueryButtonDown();
						}
					 }
				};
				this.syncAllDirect(config);
			}else {
//				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        loadStoreRecords: function(person_numb, name) {
        	if (person_numb != null && person_numb != '') {
				panelSearch.getForm().setValues({'PERSON_NUMB' : person_numb});
				panelSearch.getForm().setValues({'NAME' : name});
			}
        	var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore2 = Unilite.createStore('hpa330MasterStore2',{
		model: 'Hpa330ukrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결
            editable	: true,			// 수정 모드 사용
            deletable	: true,		// 삭제 가능 여부
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			//var toCreate = this.getNewRecords();
        	//var toUpdate = this.getUpdatedRecords();
        	//console.log("toUpdate",toUpdate);
			var paramMaster = panelSearch.getValues();
			Ext.merge(paramMaster, panelResult.getValues());
			Ext.merge(paramMaster, panelResult2.getValues());
			console.log("paramMaster : ",paramMaster);
        	var rv = true;

        	if(inValidRecs.length == 0 )	{
        		var config={
        			 params: [paramMaster]
        			 ,success: function(batch, option) {
        			 	//alert('공제내역수정완료3333');

						  if (gsPrev == 'Y')	{
							  hpa330ukrService.insertHPA600(paramMaster, function(provider, response){
				                	hpa330ukrService.calPayroll(paramMaster, function(){
										//UniAppManager.app.onQueryButtonDown();
										gsPrev = 'N'
									});
				            	});
						  }
                        UniAppManager.app.onQueryButtonDown();
                        //gsPrev = 'N'
                     }
        		}
				this.syncAllDirect(config);
			}else {
//				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        loadStoreRecords: function(person_numb, name) {
        	if (person_numb != null && person_numb != '') {
				panelSearch.getForm().setValues({'PERSON_NUMB' : person_numb});
				panelSearch.getForm().setValues({'NAME' : name});
			}
        	var param= Ext.getCmp('searchForm').getValues();

			this.load({
				params : param
			});
		}
	});

	/**
	 * 월근무 현황 그리드용 스토어
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore3 = Unilite.createStore('hpa330MasterStore3',{
		fields: [
			{name: 'CODE_NAME'		, text: '<t:message code="system.label.human.dutyhistory" default="근태내역"/>'	, type: 'string'},
			{name: 'DUTY_NUM'		, text: '<t:message code="system.label.human.dutynum" default="근태횟수"/>'		, type: 'float',decimalPrecision: 2, format:'0,000.00'},
			{name: 'DUTY_TIME'		, text: '<t:message code="system.label.human.dutytime" default="근태시간"/>'		, type: 'float',decimalPrecision: 2, format:'0,000.00'},
			{name: 'WORK_TIME'		, text: '<t:message code="system.label.human.worktime" default="실근무시간"/>'		, type: 'float',decimalPrecision: 2, format:'0,000.00'}
	    ],
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {
                read: 'hpa330ukrService.selectList4'
            }
        },
        loadStoreRecords: function() {
        	var param= Ext.getCmp('searchForm').getValues();
        	param.S_COMP_CODE = UserInfo.compCode;
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records){
				if(!Ext.isEmpty(records) && records.length > 0)	{
					var workTimeField = dutyRefWindow.down('#workTime');
					workTimeField.setValue(records[0].get("WORK_TIME"));
				}
			}
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchForm('searchForm', {
        defaultType: 'uniTextfield',
		region:'north',
		padding:'1 1 1 1',
		border:true,
        layout: {type: 'uniTable', columns: 6,
        tableAttrs: {width: '100%'/*, align : 'left'*/}//,
//		tdAttrs: {style: 'border : 1px solid #ced9e7;',width:300/*, align : 'center'*/}
        },
        itemId: 'search_panel1',
		items: [
			{
		  	xtype: 'container',
		  	layout: {
		   		type: 'uniTable',
		   		columns:5,
//		   		tableAttrs: {style: 'border : 1px solid #ced9e7;', width: 900},
		   		tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width:200/*, align : 'center'*/}
	  		},
	  		items:[{
				fieldLabel: '<t:message code="system.label.human.payyyyymm1" default="귀속년월"/>',
				id: 'PAY_YYYYMM',
				xtype: 'uniMonthfield',
				name: 'PAY_YYYYMM',
				labelWidth:90,
				value: new Date(),
		        tdAttrs: {width: 300},
				allowBlank: false
			},{
				fieldLabel: '<t:message code="system.label.human.supptype" default="지급구분"/>',
				id: 'SUPP_TYPE',
				name: 'SUPP_TYPE',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'H032',
		        tdAttrs: {width: 300},
				allowBlank : false,
				value : '1'
			},
			Unilite.popup('Employee',{
                fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
                allowBlank:false,
                id: 'PERSON_NUMB',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                tdAttrs: {width: 300},
                validateBlank:true,
                listeners: {
                    applyextparam: function(popup){
                    }
                }
            }),{
	    		xtype		: 'button',
	    		text		: '<t:message code="system.label.human.deadline" default="마감"/>',
				itemId		: 'btnClose2',
	    		width		: 85,
			//	align		: 'center',
				tdAttrs: {width: 120},
				margin		: '0 0 0 20',
				hidden: false,
	    		handler		: function(){
	    			if(directMasterStore1.getCount() == 0){
	    				alert('마감 실행할 데이터가 없습니다.\n데이터 조회 후 다시 시도해주세요.');
	    				return false;
	    			}
	    			if(confirm('<t:message code="system.message.human.message067" default="마감을 실행시키겠습니까?"/>'))	{
						var formParam= Ext.getCmp('searchForm').getValues();
						var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
						var mon = payDate.getMonth() + 1;
						var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);

						var params = panelResult.getValues();
						params.PAY_YYYYMM	= dateString;
						params.NAME 		= panelSearch.getForm().findField('NAME').getValue();
						params.DIV_CODE 	= panelResult2.getValue("DIV_CODE");
						params.PERSON_NUMB	= formParam.PERSON_NUMB;
						params.SUPP_TYPE	= panelSearch.getForm().findField('SUPP_TYPE').getValue();
						params.CLOSE_TYPE	= '1'
						params.SUPP_DATE	= UniDate.getDbDateStr(UniDate.today())
						hpa330ukrService.payClose(params, function(provider, response){
							if(!Ext.isEmpty(provider)){
								alert('마감이 완료 되었습니다.');
								UniAppManager.app.onQueryButtonDown();
							}

						});
			        }
	    		}
			},{
	    		xtype		: 'button',
	    		text		: '<t:message code="system.label.human.cancel" default="취소"/>',
				itemId		: 'btnCancel2',
	    		width		: 85,
				//align		: 'left',
			    tdAttrs: {width: 110},
				margin		: '0 0 0 0',
				hidden: false,
	    		handler		: function(){
	    			if(directMasterStore1.getCount() == 0){
	    				alert('마감 취소할 데이터가 없습니다.\n데이터 조회 후 다시 시도해주세요.');
	    				return false;
	    			}
	    			if(confirm('<t:message code="system.message.human.message068" default="마감을 취소하겠습니까?"/>'))	{
						var formParam= Ext.getCmp('searchForm').getValues();
						var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
						var mon = payDate.getMonth() + 1;
						var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);

						var params = panelResult.getValues();
						params.PAY_YYYYMM	= dateString;
						params.NAME 		= panelSearch.getForm().findField('NAME').getValue();
						params.DIV_CODE 	= panelResult2.getValue("DIV_CODE");
						params.PERSON_NUMB	= formParam.PERSON_NUMB;
						params.SUPP_TYPE	= panelSearch.getForm().findField('SUPP_TYPE').getValue();
						params.CLOSE_TYPE	= '1'
						params.SUPP_DATE	= UniDate.getDbDateStr(UniDate.today())
						hpa330ukrService.payCloseCancel(params, function(provider, response){
							if(!Ext.isEmpty(provider)){
								alert('마감이 취소 되었습니다.');
								UniAppManager.app.onQueryButtonDown();
							}
						});
			        }
	    		}
			}

			]
		},{
		  	xtype: 'container',
		  	layout: {
		   		type: 'uniTable',
		   		columns:3,
		   		tdAttrs: {width: '100%', align: 'right'}
	  		},
	  		items:[{
	  			xtype	: 'button',
				text	: '연말정산분납조회',
				width	: 140,
		        tdAttrs	: {align: 'right'},
				itemId 	: 'yearEndWinBtn',
				handler	: function(btn) {
					if(!UniAppManager.app.isValidSearchForm()){
						return false;
					} else {
						openYearEndWindow();
					}
				}
			},{
				xtype: 'button',
				text: '<t:message code="system.label.human.deadlineupload" default="마감등록"/>',
				width: 85,
		        tdAttrs: {align: 'right'},
				handler: function(btn) {
					var formParam= Ext.getCmp('searchForm').getValues();
					var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
					var mon = payDate.getMonth() + 1;
					var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);

					var params = {
							PGM_ID		: 'hpa330ukr',
							PAY_YYYYMM	: dateString,
							NAME 		: panelSearch.getForm().findField('NAME').getValue(),
							PERSON_NUMB	: formParam.PERSON_NUMB,
							SUPP_TYPE	: panelSearch.getForm().findField('SUPP_TYPE').getValue()
					};
					var rec = {data : {prgID : 'hbs910ukrv', 'text':'<t:message code="system.label.human.paydinfoupload" default="급여마감정보등록(개인별)"/>'}};
					parent.openTab(rec, '/human/hbs910ukrv.do', params);
				}
			},{
				xtype: 'button',
				text: '<t:message code="system.label.human.recalculatepayroll" default="급여재계산"/>',
		        tdAttrs: {align: 'right'},
				handler: function(btn) {
					var formParam= Ext.getCmp('searchForm').getValues();
					var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
					var mon = payDate.getMonth() + 1;
					var dateString = payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);

					var params = panelResult.getValues();
					params.PAY_YYYYMM	= dateString;
					params.NAME 		= panelSearch.getForm().findField('NAME').getValue();
					params.DIV_CODE 	= panelResult2.getValue("DIV_CODE");
					params.PERSON_NUMB	= formParam.PERSON_NUMB;
					params.SUPP_TYPE	= panelSearch.getForm().findField('SUPP_TYPE').getValue();
					params.SUPP_DATE	= UniDate.getDbDateStr(UniDate.today())
					hpa330ukrService.calPayroll(params, function(){
						UniAppManager.app.onQueryButtonDown();
					});

				}
			}]
		 }]
    });

    /**
     * result form 정의(Form Panel)
     * @type
     */
	var panelResult = Unilite.createSearchForm('resultForm',{
//    	xtype: 'container',
		defaultType: 'uniTextfield',
    	region: 'east',
    	border: false,
		layout: {type: 'uniTable', align: 'stretch', columns: 1},
		tableAttrs: {width: '100%'/*, align : 'left'*/},
	    api: {
        	load	: 'hpa330ukrService.selectList3'
        },
	    padding: '1 1 1 1',
//	    flex: 0.7,
	    width: 315,
        autoScroll: true,
	    items: [{
	    	xtype:'panel',
	        defaultType: 'uniTextfield',
	        flex: 1,
	        layout: {
	        	type: 'uniTable',
	        	columns : 1
	        },
	        defaults: { readOnly:true },
	        border:false,
	        items: [{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.human.taxcalculation" default="세액계산"/>',
				id: 'rdoSelect1',
				labelWidth:130,
				name :'CALC_TAX_YN',
				tdAttrs: {width: '290'/*, align : 'left'*/},
				listeners: {
                    uniOnChange: function(basicForm, field, newValue, oldValue) {
                        if(basicForm.isDirty()){
                            UniAppManager.setToolbarButtons('save', true);
                        }
                    }
                 },
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
					width: 70,
					name: 'CALC_TAX_YN',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>',
					width: 70,
					name: 'CALC_TAX_YN',
					inputValue: 'N'
				}]
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.human.hireinsurtype2" default="고용보험계산"/>',
				id: 'rdoSelect2',
				labelWidth:130,
				name:'CALC_HIR_YN',
				listeners: {
                    uniOnChange: function(basicForm, field, newValue, oldValue) {
                        if(basicForm.isDirty()){
                            UniAppManager.setToolbarButtons('save', true);
                        }
                    }
                 },
//				disabled: true,
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
					width: 70,
					name: 'CALC_HIR_YN',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>',
					width: 70,
					name: 'CALC_HIR_YN',
					inputValue: 'N'
				}]
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.human.workconpenyn" default="산재보험계산"/>',
				id: 'rdoSelect3',
				labelWidth:130,
				name:'CALC_IND_YN',
//				disabled: true,
				listeners: {
                    uniOnChange: function(basicForm, field, newValue, oldValue) {
                        if(basicForm.isDirty()){
                            UniAppManager.setToolbarButtons('save', true);
                        }
                    }
                 },
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
					width: 70,
					name: 'CALC_IND_YN',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>',
					width: 70,
					name: 'CALC_IND_YN',
					inputValue: 'N'
				}]
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.human.anuhealthinsursum" default="국민/건강보험계산"/>',
				name:'CALC_MED_YN',
				id: 'rdoSelect6',
				labelWidth:130,
//				disabled: true,
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>',
					width: 70,
					name: 'CALC_MED_YN',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>',
					width: 70,
					name: 'CALC_MED_YN',
					inputValue: 'N'
				}]
			},{
				xtype: 'container',
	        	layout: {type: 'table', columns: 2},
	        	defaults: { xtype: 'button' },
				tdAttrs: {align : 'center'},
				items:[{
					text: '<t:message code="system.label.human.lastmonthcopy" default="전월급여복사"/>',
					width: 100,
					handler: function(btn) {
						if(!UniAppManager.app.isValidSearchForm()){
							return false;
						} else {
							copyPrevData();
						}
					}
				},{
					text: '<t:message code="system.label.human.monthlyworkinfoview" default="월근무현황보기"/>',
					width: 100,
					handler: function(btn) {
						if(!UniAppManager.app.isValidSearchForm()){
							return false;
						} else {
							openDutyRefWindow();
						}
					}
				}]
			},
	        	{fieldLabel: '<t:message code="system.label.human.p1taxexemptionstudyinotax" default="연구활동비비과세"/>',	name: 'TAX_EXEMPTION6_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.taxexemption4i" default="국외근로"/>', 					name: 'TAX_EXEMPTION4_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.taxexemption1i" default="연장비과세"/>', 				name: 'TAX_EXEMPTION1_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.taxexemption5inur" default="보육비과세"/>', 				name: 'TAX_EXEMPTION5_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.taxexemption2i" default="식대비과세"/>',					name: 'TAX_EXEMPTION2_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.taxexemption3i" default="기타비과세"/>',					name: 'TAX_EXEMPTION3_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.busisharei" default="사회보험사업자부담금"/>',				name: 'BUSI_SHARE_I',		xtype: 'uniNumberfield', hidden:true,	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.workerconpeni" default="산재보험사업자부담금"/>',			name: 'WORKER_COMPEN_I',	xtype: 'uniNumberfield', hidden:true,	labelWidth: 130
        	},{
				xtype: 'container',
				tdAttrs: {align: 'center'},
				layout:{type : 'uniTable', columns : 1, tableAttrs: {width: '95%'}},
				items:[{
					xtype: 'component',
					tdAttrs: {style: 'border-bottom: 1.4px solid #cccccc;'}
				}]
			},
	        	{fieldLabel: '<t:message code="system.label.human.taxexemptiontoti" default="비과세총액"/>',	name: 'TAX_EXEMPTIONTOT_I',	xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.nontaxi1" default="과세제외총액"/>',			name: 'NON_TAX_I',			xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.taxamounti1" default="과세분금액"/>',		name: 'TAX_AMOUNT_I',		xtype: 'uniNumberfield',	labelWidth: 130
        	},{
				xtype: 'container',
				tdAttrs: {align: 'center'},
				layout:{type : 'uniTable', columns : 1, tableAttrs: {width: '95%'}},
				items:[{
					xtype: 'component',
					tdAttrs: {style: 'border-bottom: 1.4px solid #cccccc;'}
				}]
			},
	        	{fieldLabel: '<t:message code="system.label.human.paytotali" default="급여총액"/>',		name: 'SUPP_TOTAL_I',		xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.dedtotali" default="공제총액"/>',		name: 'DED_TOTAL_I',		xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: '<t:message code="system.label.human.realamounti" default="실지급액"/>',		name: 'REAL_AMOUNT_I',		xtype: 'uniNumberfield',	labelWidth: 130},
	        	{fieldLabel: 'CLOSE_YN',		name: 'CLOSE_YN',		xtype: 'uniTextfield',	labelWidth: 130, hidden: true}
	        ]
		}]
    });

    var panelResult2 = Unilite.createSearchForm('resultForm2',{
		region: 'south',
		defaultType: 'uniTextfield',
		layout: {type: 'uniTable', columns : 5/*, tableAttrs: {align:'left'}*/
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}

		},
        height: 118,
        autoScroll: true,
	    api: {
        	load	: 'hpa330ukrService.selectList3_2'//,
            //submit: 'hpa330ukrService.form01update'
        },
        readOnly:true,
		padding:'1 1 1 1',
		border:true,
	    items: [
			{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
				name: 'DIV_CODE',
				hidden:true
			},
				Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
					name: 'DEPT_CODE',
				    valueFieldName:'DEPT_CODE',
				    textFieldName:'DEPT_NAME',
        			readOnly:true
			}),{
				fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				name: 'PAY_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H028',
        		readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.human.excepttype" default="입퇴사구분"/>',
				name: 'EXCEPT_TYPE',
				id : 'EXCEPT_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H048',
        		readOnly:true
			},{
				fieldLabel: '기준소득연금(연금)',
				xtype: 'uniNumberfield',
				name: 'ANU_BASE_I',
				labelWidth: 120,
				fieldStyle: 'text-align: right',
        		readOnly:true
			}

			,{
			fieldLabel: '청년세액감면율',
			name: 'YOUTH_EXEMP_RATE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H179',
			readOnly: true,
			labelWidth: 120
		}

/*			,{
				xtype: 'component'
			}*/

			,{
				fieldLabel: '<t:message code="system.label.human.postcode" default="직위"/>',
				name: 'POST_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H005',
        		readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
				name: 'PAY_PROV_FLAG',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031',
        		readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.human.joindate" default="입사일"/>',
				xtype: 'uniDatefield',
				id: 'JOIN_DATE',
				name: 'JOIN_DATE',
        		readOnly:true
			},{
				fieldLabel: '보수월액',
				xtype: 'uniNumberfield',
				name: 'MED_AVG_I',
				labelWidth: 120,
				fieldStyle: 'text-align: right',
        		readOnly:true
			}

			,{fieldLabel: '청년세액감면기간', name: 'YOUTH_EXEMP_DATE', readOnly: true, labelWidth: 120, hidden: false, readOnly: true, xtype: 'uniDatefield'}

/*			,{
				xtype: 'component'
			}*/

			,{
				fieldLabel: '<t:message code="system.label.human.abil" default="직책"/>',
				name: 'ABIL_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H006',
        		readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.human.taxtype" default="세액구분"/>',
				name: 'TAX_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H029',
        		readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.human.retrdate" default="퇴사일"/>',
				xtype: 'uniDatefield',
				name: 'RETR_DATE',
				id : 'RETR_DATE',
        		readOnly:true
			},{
                fieldLabel: '월평균보수(고용)',
                xtype: 'uniNumberfield',
                name: 'HIRE_AVG_I',
                labelWidth: 120,
                fieldStyle: 'text-align: right',
                readOnly:true
            },{
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.human.spouser" default="배우자"/>',
                id: 'rdoSelect4',
                labelWidth: 120,
        		readOnly:true,
                items: [{
                    boxLabel: '<t:message code="system.label.human.have" default="유"/>',
                    width: 70,
                    name: 'SPOUSE',
                    inputValue: 'Y',
        			readOnly:true
                },{
                   boxLabel : '<t:message code="system.label.human.havenot" default="무"/>',
                    width: 70,
                    name: 'SPOUSE',
                    inputValue: 'N',
                    checked: true,
        			readOnly:true
                }]

            },{
				fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
				name: 'EMPLOY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H024',
        		readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.human.wagesstdi" default="기본급"/>',
				xtype: 'uniNumberfield',
				name: 'WAGES_STD_I',
				fieldStyle: 'text-align: right',
        		readOnly:true
			},{
				fieldLabel: '<t:message code="system.label.human.salarysuppdate" default="급여지급일"/>',
				id: 'SUPP_DATE',
				xtype: 'uniDatefield',
				name: 'SUPP_DATE',
        		readOnly:true
			},{
                xtype: 'radiogroup',
                fieldLabel: '<t:message code="system.label.human.taxratebase" default="세율기준"/>',
                labelWidth: 120,
                id: 'rdoSelect5',
                items: [{
                    boxLabel: '80%',
                    width: 50,
                    name: 'TAX_RATE',
                    inputValue: '1',
                    readOnly:true
                },{
                    boxLabel : '100%',
                    width: 50,
                    name: 'TAX_RATE',
                    inputValue: '2',
                    checked: true ,
                    readOnly:true
                },{
                    boxLabel : '120%',
                    width: 50,
                    name: 'TAX_RATE',
                    inputValue: '3' ,
                    readOnly:true
                }]
            },{
				layout: {type:'hbox'},
				xtype: 'container',
				items: [{
					fieldLabel: '<t:message code="system.label.human.agednum20" default="부양자.20세이하자녀"/>',
				 	xtype: 'uniNumberfield',
				 	//value : 10,
				 	name: 'SUPP_NUM',
				 	id: 'SUPP_NUM',
				 	flex: 3,
				 	labelWidth: 120,
        			readOnly:true
				},{
				 	xtype: 'uniNumberfield',
				 	//value : 10,
				 	name: 'CHILD_20_NUM',
				 	id: 'CHILD_20_NUM',
				 	flex: 1,
				 	suffixTpl: '<t:message code="system.label.human.name1" default="명"/>',
        			readOnly:true
				}]
			}
		]
    });

    var masterGrid = Unilite.createGrid('hpa330Grid1', {
		store: directMasterStore1,
		uniOpt: {
			useMultipleSorting	: true,
	    	useLiveSearch		: false,
	    	onLoadSelectFirst	: true,
	    	useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
            userToolbar			: false,
	    	filter: {
				useFilter	: false,
				autoCreate	: false
			}
		},
    	features: [{
    		id: 'masterGridTotal1',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
        columns: [
        	{dataIndex: 'PAY_YYYYMM'			, width: 200, hidden: true},
			{dataIndex: 'SUPP_TYPE'				, width: 200, hidden: true},
			{dataIndex: 'PERSON_NUMB'			, width: 200, hidden: true},
			{dataIndex: 'WAGES_CODE'			, width: 200, hidden: true},
			{dataIndex: 'WAGES_NAME'			, width: 200, summaryRenderer: function(value){ return '<t:message code="system.label.human.totwagesi" default="합계"/>'; }, text: '<t:message code="system.label.human.stdname" default="지급내역"/>'},
			{dataIndex: 'AMOUNT_I'				, flex:1, summaryType:'sum'},
			{dataIndex: 'COMP_CODE'				, width: 200, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'		, width: 200, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 200, hidden: true}
		],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(panelResult.getValue('CLOSE_YN') == '마감'){
					return false;
  				} else {
  					return true;
  				}
			}
		}
    });

    var masterGrid2 = Unilite.createGrid('hpa330Grid2', {
//     	layout : 'fit',
		store: directMasterStore2,
		uniOpt: {
			useMultipleSorting	: true,
	    	useLiveSearch		: false,
	    	onLoadSelectFirst	: true,
	    	useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
            userToolbar			: false,
	    	filter: {
				useFilter	: false,
				autoCreate	: false
			}
		},
    	features: [{
    		id: 'masterGridTotal2',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
        columns: [
        	{dataIndex: 'PAY_YYYYMM'			, width: 200, hidden: true},
        	{dataIndex: 'SUPP_TYPE'				, width: 200, hidden: true},
        	{dataIndex: 'PERSON_NUMB'			, width: 200, hidden: true},
        	{dataIndex: 'DED_CODE'				, width: 200, hidden: true},
        	{dataIndex: 'WAGES_NAME'			, width: 200, summaryRenderer: function(value){ return '<t:message code="system.label.human.totwagesi" default="합계"/>'; }},
        	{dataIndex: 'DED_AMOUNT_I'			, flex:1, summaryType:'sum'},
        	{dataIndex: 'COMP_CODE'				, width: 200, hidden: true},
        	{dataIndex: 'UPDATE_DB_USER'		, width: 200, hidden: true},
        	{dataIndex: 'UPDATE_DB_TIME'		, width: 200, hidden: true}
		],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(panelResult.getValue('CLOSE_YN') == '마감'){
					return false;
	        	} else {
  					return true;
  				}
			}
		}
    });

    //월근무 현황 그리드 (팝업)
    var masterGrid3 = Unilite.createGrid('hpa330Grid3', {
		store: directMasterStore3,
		uniOpt: {
			useMultipleSorting	: true,
		    useLiveSearch		: false,
		    onLoadSelectFirst	: false,
		    dblClickToEdit		: false,
		    useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: false,
		    filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
		},
		tbar:  [
        	'->',
        	{
        		xtype:'uniNumberfield',
        	 	itemId :'workTime',
        	 	name :'WORK_TIME',
        	 	width:120,
        	 	labelWidth:70,
        	 	readOnly:true,
           	 	fieldLabel:'<t:message code="system.label.human.worktime" default="실근무시간"/> '
           	}
		],
        columns: [
        	{dataIndex: 'CODE_NAME'			, width: 150},
        	{dataIndex: 'DUTY_NUM'			, width: 90},
        	{dataIndex: 'DUTY_TIME'			, flex: 1	, minWidth: 90}
		]
    });

	var mainPanel = Ext.create('Ext.panel.Panel', {
		id: 'hpa330ukrPanel',
		region : 'center',
//		padding: '0 0 0 40',
// 		flex: 0.6,
		layout: {
		    type: 'hbox',
		    align : 'stretch',
		    pack  : 'start'
		},
		items:[
		    masterGrid,
			masterGrid2,
			panelResult
	    ]
	});

	Unilite.Main( {
		id : 'hpa330App',
		items:[{
			layout:'fit',
			flex:1,
			border:false,
			items:[{
				layout:'border',
//				defaults:{style:{padding: '5 5 5 5'}},
				border:false,
				items:[
					panelSearch, mainPanel, panelResult2
				]
			}]
		}],

		fnInitBinding : function(params) {
		 	Ext.getCmp('rdoSelect4').setValue({SPOUSE : 'N'});
		 	Ext.getCmp('rdoSelect5').setValue({TAX_RATE : '2'});
		 	if(gsInitChk == 'Y'){
		 		panelSearch.setValue('PAY_YYYYMM',new Date());
		 	}
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('prev', true);
            UniAppManager.setToolbarButtons('next', true);

			panelResult.setReadOnly(true);

			panelSearch.onLoadSelectText('PERSON_NUMB');
			panelSearch.getField('PERSON_NUMB').focus();

			if(params && params.PGM_ID) {
				this.processParams(params);
			}
			checkAvailableNaviInit();
			gsInitChk = 'N';
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			else {
				loadRecord('');
			}

			gsPrev = 'N';
		},
		onResetButtonDown: function() {
			gsInitChk = 'Y';
			Ext.getCmp('PERSON_NUMB').setReadOnly(false);
			Ext.getCmp('SUPP_TYPE').setReadOnly(false);
			Ext.getCmp('PAY_YYYYMM').setReadOnly(false);
			panelSearch.getForm().setValues({'PERSON_NUMB' : ''});
			panelSearch.getForm().setValues({'NAME' : ''});
			// data 초기화
			directMasterStore1.loadData([],false);
			directMasterStore2.loadData([],false);
			panelResult.reset();
			panelResult2.reset();
			panelResult.getForm().getFields().each(function (field) {
				 field.setValue('');
			});
			panelResult2.getForm().getFields().each(function (field) {
				 field.setValue('');
			});
			UniAppManager.app.fnInitBinding();
			gsPrev = 'N';
		},
		onPrevDataButtonDown: function() {
			console.log('Go Prev > ' + data[0].PV_D + 'NAME > ' + data[0].PV_NAME);
			loadRecord(data[0].PV_D, data[0].PV_NAME);
		},
		onNextDataButtonDown: function() {
			console.log('Go Next > ' + data[0].NX_D + 'NAME > ' + data[0].NX_NAME);
			loadRecord(data[0].NX_D, data[0].NX_NAME);
		},
		onDeleteDataButtonDown : function()	{
			Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message009" default="삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					var searchForm = Ext.getCmp('searchForm');

					if(UniAppManager.app.isValidSearchForm())	{
						var param= searchForm.getValues();
						hpa330ukrService.deleteList(param, function(){
							UniAppManager.app.onResetButtonDown();
						});
					}
				}
			});
		},
		onSaveDataButtonDown : function() {
			if (directMasterStore1.getCount() == 0 && directMasterStore2.getCount() == 0) {

				UniAppManager.setToolbarButtons('save', false);
				gsPrev = 'N';
				//TODO : 삭제 이후 루틴 확인 refresh?? HPA600T 삭제 확인
			// 수정
			} else {
				var searchParam = Ext.getCmp('searchForm').getValues();
				// 수정이 가능한지 확인

			 	hpa330ukrService.checkUpdateAvailable(searchParam, function(responseText, response)	{
			 		if(responseText == "")	{
				 		if (directMasterStore1.isDirty()){
				 			//alert(gsPrev);
					 		if (gsPrev == 'Y')	{
								hpa330ukrService.deleteList1(searchParam, function(provider, response){
				                	directMasterStore1.saveStore();
				            	});
					 		} else {
					 			directMasterStore1.saveStore();
					 		}

	                    } else if(directMasterStore2.isDirty())	{

	                    	if (gsPrev == 'Y')	{
								hpa330ukrService.deleteList2(searchParam, function(provider, response){
				                	directMasterStore2.saveStore();
				            	});
					 		} else {
					 			directMasterStore2.saveStore();
					 		}

	                    //	directMasterStore2.saveStore();
	                    }
			 		} else {
			 			alert(responseText);
			 		}
					//gsPrev = 'N';
			 	})
			}
		},

        //링크로 넘어오는 params 받는 부분 (Agj100skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'hpa950skr') {
				panelSearch.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
				panelSearch.setValue('SUPP_TYPE'	,params.SUPP_NAME);
				panelSearch.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelSearch.setValue('NAME'			,params.NAME);

				panelResult.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
				panelResult.setValue('SUPP_TYPE'	,params.SUPP_NAME);
				panelResult.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelResult.setValue('NAME'			,params.NAME);
				loadRecord('');
			}
			if(params.PGM_ID == 'hpa350ukr') {
				panelSearch.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
				panelSearch.setValue('SUPP_TYPE'	,params.SUPP_TYPE);
				panelSearch.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelSearch.setValue('NAME'			,params.NAME);

				panelResult.setValue('PAY_YYYYMM'	,params.PAY_YYYYMM);
				panelResult.setValue('SUPP_TYPE'	,params.SUPP_TYPE);
				panelResult.setValue('PERSON_NUMB'	,params.PERSON_NUMB);
				panelResult.setValue('NAME'			,params.NAME);
				loadRecord('');
			}
        }
	});

	 // 그리드 및 폼의 데이터를 불러옴
	 function loadRecord(person_numb, name) {
			//저장버튼 비활성화를 위한 변수 처리
			gsSaveButtonYn = 1;

		 	Ext.getCmp('PERSON_NUMB').setReadOnly(true);
		 	Ext.getCmp('SUPP_TYPE').setReadOnly(true);
			Ext.getCmp('PAY_YYYYMM').setReadOnly(true);
			Ext.getCmp('resultForm2').setReadOnly(true);
			Ext.getCmp('rdoSelect1').setReadOnly(false);
			Ext.getCmp('rdoSelect2').setReadOnly(false);
			Ext.getCmp('rdoSelect3').setReadOnly(false);
			Ext.getCmp('rdoSelect6').setReadOnly(false);

//			masterGrid.setConfig('disabled', false);
//			masterGrid2.setConfig('readOnly', true);

			UniAppManager.setToolbarButtons('reset',true);

			directMasterStore1.loadStoreRecords(person_numb, name);
			directMasterStore2.loadStoreRecords(person_numb, name);

			// TODO : Fix it!!

			panelResult.getForm().load({params : Ext.getCmp('searchForm').getValues(),
				success: function(form, action){
				 	// 비과세 총액 계산
					if (typeof action.result.data.TAX_EXEMPTION1_I !== 'undefined') {
						var totalTax = action.result.data.TAX_EXEMPTION1_I + action.result.data.TAX_EXEMPTION2_I + action.result.data.TAX_EXEMPTION3_I +
		 								action.result.data.TAX_EXEMPTION4_I + action.result.data.TAX_EXEMPTION5_I + action.result.data.TAX_EXEMPTION6_I;
		 				panelResult.getForm().setValues({ TAX_EXEMPTIONTOT_I : totalTax});
				 	}
				},
				failure: function(form, action) {
					// form reset
					form.getFields().each(function (field) {
						field.setValue('');
					});
				}
			});
			panelResult2.getForm().load({params : Ext.getCmp('searchForm').getValues(),
				 success: function(form, action){
				 	console.log(action);

			 		//배우자 유무, 세율기준, 부양자, 20세이하자녀 세팅
				 	Ext.getCmp('rdoSelect4').setValue({SPOUSE : action.result.data.SPOUSE});
				 	Ext.getCmp('rdoSelect5').setValue({TAX_RATE : action.result.data.TAXRATE_BASE});
				 	Ext.getCmp('SUPP_NUM').setValue(action.result.data.SUPP_AGED_NUM);
				 	Ext.getCmp('CHILD_20_NUM').setValue(action.result.data.CHILD_20_NUM);
					Ext.getCmp('SUPP_DATE').setValue(action.result.data.SUPP_DATE);
				 	//급여지급일
				 	var suppDate = Ext.getCmp('SUPP_DATE').getValue();
				 	if (Ext.isEmpty(suppDate) || suppDate == null ) {
				 		suppDate = UniDate.getDbDateStr(Ext.getCmp('PAY_YYYYMM').getValue()).substring(0, 6) + '01'
 					 	Ext.getCmp('SUPP_DATE').setValue(suppDate);
				 	}
				 	//입사일
				 	var joinDate = Ext.getCmp('JOIN_DATE').getValue();
				 	//퇴사일
				 	var retrDate = Ext.getCmp('RETR_DATE').getValue();

				 	//입퇴사 구분 세팅
				 	if (retrDate == suppDate){
 					 	Ext.getCmp('EXCEPT_TYPE').setValue('3');

				 	} else if (joinDate == suppDate) {
 					 	Ext.getCmp('EXCEPT_TYPE').setValue('1');

				 	} else {
 					 	Ext.getCmp('EXCEPT_TYPE').setValue('0');

				 	}
				 },
				 failure: function(form, action) {
					 // 폼을 리셋 후 readOnly를 false 로 변경함
					 form.getFields().each(function (field) {
						 if (field.name == 'WAGES_STD_I' || field.name == 'ANU_BASE_I' || field.name == 'MED_AVG_I'
							 || field.name == 'CHILD_20_NUM'|| field.name == 'SUPP_NUM') {
							 field.setValue('0');
						 } else {
							 field.setValue('');
						 }

				     });
				 }
				}
		    );
			// Prev, Next 데이터 검사
			checkAvailableNavi();
	 }

	// 선택된 사원의 전후로 데이터가 있는지 검색함
	function checkAvailableNavi(){
		var param = Ext.getCmp('searchForm').getValues();
		console.log(param);
		param.INIT_CHK = 'N';
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

	// 선택된 사원의 전후로 데이터가 있는지 검색함
	function checkAvailableNaviInit(){
		var param = Ext.getCmp('searchForm').getValues();
		console.log(param);
		param.INIT_CHK = 'Y';
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
	// 전월의 급여를 복사함
	function copyPrevData() {
	 	Ext.getCmp('PERSON_NUMB').setReadOnly(true);
	 	Ext.getCmp('SUPP_TYPE').setReadOnly(true);
		Ext.getCmp('PAY_YYYYMM').setReadOnly(true);
		masterGrid.setConfig('readOnly', true);
		masterGrid2.setConfig('readOnly', true);
		UniAppManager.setToolbarButtons('reset',true);


		var payDate = Ext.getCmp('PAY_YYYYMM').getValue();
		var date = new Date(payDate);
		date.setMonth(date.getMonth() - 1);
		var mon = date.getMonth() + 1;
		var preDate = date.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);

//		var date = Ext.getCmp('SUPP_DATE').getValue();
		var date = Ext.getCmp('PAY_YYYYMM').getValue();
		var mon = date.getMonth() + 1;
		var supp_date = date.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);

		var param = Ext.getCmp('searchForm').getValues();
		param.FR_PAY_YYYYMM = preDate;
		param.SUPP_DATE = supp_date;
		param.S_COMP_CODE = UserInfo.compCode;
		param.S_USER_ID = UserInfo.userID;
		console.log(param);

		Ext.Ajax.request({
			url: CPATH+'/human/copyPrevData.do',
			params: param,
			success: function(response){
				UniAppManager.setToolbarButtons('save', false);

				data = Ext.decode(response.responseText);
				console.log(data);

				if (data.result.length == 0) {
					Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message062" default="전월의 급여 데이터가 없습니다"/>');
					return false;
				} else {
					if (data.result[0].CLOSE_YN == '마감') {
						// TODO : disabled = true
					} else {
						// TODO : disabled = false
					}
				}
				//panelResult1, 2에 데이터 입력
				var record = data.result[0];
				panelResult.setValue('TAX_EXEMPTION6_I',	record.TAX_EXEMPTION6_I);
				panelResult.setValue('TAX_EXEMPTION4_I',	record.TAX_EXEMPTION4_I);
				panelResult.setValue('TAX_EXEMPTION1_I',	record.TAX_EXEMPTION1_I);
				panelResult.setValue('TAX_EXEMPTION5_I',	record.TAX_EXEMPTION5_I);
				panelResult.setValue('TAX_EXEMPTION2_I',	record.TAX_EXEMPTION2_I);
				panelResult.setValue('TAX_EXEMPTION3_I',	record.TAX_EXEMPTION3_I);
				panelResult.setValue('BUSI_SHARE_I',		record.BUSI_SHARE_I);
				panelResult.setValue('WORKER_COMPEN_I',		record.WORKER_COMPEN_I);
				panelResult.setValue('TAX_EXEMPTIONTOT_I',	(record.TAX_EXEMPTION1_I) + (record.TAX_EXEMPTION2_I) + (record.TAX_EXEMPTION3_I)
															+ (record.TAX_EXEMPTION4_I) + (record.TAX_EXEMPTION5_I) + (record.TAX_EXEMPTION6_I));
				panelResult.setValue('NON_TAX_I',			record.NON_TAX_I);
				panelResult.setValue('TAX_AMOUNT_I',		record.TAX_AMOUNT_I);
				panelResult.setValue('SUPP_TOTAL_I',		record.SUPP_TOTAL_I);
				panelResult.setValue('DED_TOTAL_I',			record.DED_TOTAL_I);
				panelResult.setValue('REAL_AMOUNT_I',		record.REAL_AMOUNT_I);

				panelResult2.setValue('DIV_CODE',			record.DIV_CODE);
				panelResult2.setValue('DEPT_CODE',			record.DEPT_CODE);
				panelResult2.setValue('DEPT_NAME',			record.DEPT_NAME);
				panelResult2.setValue('PAY_CODE',			record.PAY_CODE);
				panelResult2.setValue('EXCEPT_TYPE',		record.EXCEPT_TYPE);
				panelResult2.setValue('ANU_BASE_I',			record.ANU_BASE_I);
				panelResult2.setValue('POST_CODE',			record.POST_CODE);
				panelResult2.setValue('PAY_PROV_FLAG',		record.PAY_PROV_FLAG);
				panelResult2.setValue('JOIN_DATE',			record.JOIN_DATE);
				panelResult2.setValue('MED_AVG_I',			record.MED_AVG_I);
				panelResult2.setValue('ABIL_CODE',			record.ABIL_CODE);
				panelResult2.setValue('TAX_CODE',			record.TAX_CODE);
				panelResult2.setValue('SPOUSE',				record.SPOUSE);
				panelResult2.setValue('EMPLOY_TYPE',		record.EMPLOY_TYPE);
				panelResult2.setValue('WAGES_STD_I',		record.WAGES_STD_I);
				panelResult2.setValue('SUPP_DATE',			record.SUPP_DATE + '01');
				panelResult2.setValue('SUPP_NUM',			record.SUPP_NUM);
				panelResult2.setValue('CHILD_20_NUM',		record.CHILD_20_NUM);
				panelResult2.setValue('TAXRATE_BASE',		record.TAXRATE_BASE);
//				panelResult2.setValue('TAX_RATE',			record.TAX_RATE);

				//지급 내역
				var records1 = [];
				Ext.each(data.result1, function(obj, i){
	                records1.push(obj);
	            });
				directMasterStore1.loadData(records1);

				//공제 내역
				var records2 = [];
				Ext.each(data.result2, function(obj, i){
	                records2.push(obj);
	            });
				directMasterStore2.loadData(records2);

				gsPrev = 'Y';
			},
			failure: function(response){
				console.log(response);
			}
		});

	}

	// 월근무 현황 팝업을 표시함
	function openDutyRefWindow() {
		if (!dutyRefWindow) {
			dutyRefWindow = Ext.create('widget.uniDetailWindow', {
                title: '<t:message code="system.label.human.monthlyworkinfo" default="월근무현황"/>',
                width: 390,
                height: 500,
                layout:{type:'vbox', align:'stretch'},
                items: [masterGrid3],
                tbar:  [
                	'->',
                	{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.human.close" default="닫기"/>',
					handler: function() {
						dutyRefWindow.hide();
					},
					disabled: false
				}],
                listeners : {
                			 beforeshow: function ( me, eOpts )	{
                				 directMasterStore3.loadStoreRecords();
                			 }
                }
			});
		}
		dutyRefWindow.center();
		dutyRefWindow.show();

	}
	
	
	
	// 연말정산데이터 조회
	Unilite.defineModel('yearEndModel', {
	    fields: [  	    
              {name : 'DIV_CODE'        , text : '<t:message code="system.label.human.division" default="사업장"/>'			, type : 'string'       , comboType : 'BOR120'		}
	    	, {name : 'YEAR_YYYY'       , text : '<t:message code="system.label.human.reportyear" default="신고연도"/>'		, type : 'string'     	         								}
	    	, {name : 'PERSON_NUMB'     , text : '<t:message code="system.label.human.employeenumber" default="사원번호"/>'	, type : 'string' 	  	         								}
	    	, {name : 'NAME'     		, text : '<t:message code="system.label.human.employeename" default="사원명"/>'		, type : 'string'  		         								}
	    	// 연말정산
	    	, {name : 'IN_TAX_I'        , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'    	            													}
	    	, {name : 'SP_TAX_I'        , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'      										}
	    	, {name : 'LOCAL_TAX_I'     , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'   											}
	    	// 1차분납
	    	, {name : 'PAY_YYYYMM_01'   , text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'   											}
	    	, {name : 'PAY_MM_01'   	, text : ' 귀속월'		, type : 'string'   	            													}
	    	, {name : 'IN_TAX_I_01'     , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'                  																	}
	    	, {name : 'SP_TAX_I_01'     , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'                                          											}
	    	, {name : 'LOCAL_TAX_I_01'  , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'                                          											}
	    	, {name : 'PAY_APPLY_YN_01' , text : '<t:message code="system.label.human.payapplyyn" default="급여반영여부"/>'	, type : 'string'     	, store : Ext.data.StoreManager.lookup('payApplyCombo')	}
	    	// 2차분납
	    	, {name : 'PAY_YYYYMM_02'   , text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'     											}
	    	, {name : 'PAY_MM_02'   	, text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'    	              												}
	    	, {name : 'IN_TAX_I_02'     , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'         									}
	    	, {name : 'SP_TAX_I_02'     , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'                                        												}
	    	, {name : 'LOCAL_TAX_I_02'  , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'                                         											}
	    	, {name : 'PAY_APPLY_YN_02' , text : '<t:message code="system.label.human.payapplyyn" default="급여반영여부"/>'	, type : 'string'      	, store : Ext.data.StoreManager.lookup('payApplyCombo')	}
	    	// 3차분납
	    	, {name : 'PAY_YYYYMM_03'   , text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'             									}
	    	, {name : 'PAY_MM_03'   	, text : '<t:message code="system.label.human.payyyyymm1" default="귀속연월"/>'		, type : 'string'    											}
	    	, {name : 'IN_TAX_I_03'     , text : '<t:message code="system.label.human.intaxi" default="소득세"/>'			, type : 'uniPrice'                                           											}
	    	, {name : 'SP_TAX_I_03'     , text : '<t:message code="system.label.human.sptaxi" default="농특세"/>'			, type : 'uniPrice'                                            											}
	    	, {name : 'LOCAL_TAX_I_03'  , text : '<t:message code="system.label.human.localtaxi" default="지방소득세"/>'	  	, type : 'uniPrice'                                           											}
	    	, {name : 'PAY_APPLY_YN_03' , text : '<t:message code="system.label.human.payapplyyn" default="급여반영여부"/>'	, type : 'string'      	, store : Ext.data.StoreManager.lookup('payApplyCombo')	}
	    	, {name : 'OPR_FLAG' 			, text : '신규여부'	   															, type : 'string'      	    												}
	    	
		         
	    ]
	});
	var yearEndStore = Unilite.createStore('yearEndStore',{
		model : 'yearEndModel',
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {
                read: 'hpa330ukrService.selectYearEndList'
            }
        },
        loadStoreRecords: function() {
        	var param= panelSearch.getValues();
        	param.DIV_CODE = panelResult2.getValue("DIV_CODE");
			this.load({
				params : param
			});
		},
		listeners :{
			load : function(store, records) {
				if(records && records.length > 0 )	{
					var headers = yearEndGrid.headerCt.items.items;
					Ext.each(headers, function(header){
						if(header.itemId == 'yearEndHeader1')	{
							header.setText("1차분납("+records[0].get("PAY_MM_01")+"월)")
						}
						if(header.itemId == 'yearEndHeader2')	{
							header.setText("3차분납("+records[0].get("PAY_MM_02")+"월)")
						}
						if(header.itemId == 'yearEndHeader3')	{
							header.setText("3차분납("+records[0].get("PAY_MM_03")+"월)")
						}
					});
				} else {
					Unilite.messageBox('데이터가 없습니다');
					yearEndWindow.hide();
				}
			}
		}
	});
	var yearEndGrid = Unilite.createGrid('YearEndGrid', {
        store: yearEndStore,
    	region: 'center',
    	flex:1,
    	uniOpt : {
    		userToolbar :false,
    		expandLastColumn: false
    	},
        columns:  [     
        	  {dataIndex : 'PERSON_NUMB'     	, width : 100  	}
        	, {dataIndex : 'NAME'        		, width : 100 	}
        	, {
        		text:'<t:message code="system.label.human.yearEndTax" default="연말정산"/>',
        	   	columns :[
        		  {dataIndex : 'IN_TAX_I'    	, width : 80  	}
               	, {dataIndex : 'LOCAL_TAX_I'  	, width : 100   }
        	   ]
        	},{
        	   text:'<t:message code="system.label.human.firstInstallmentPayment" default="1차분납"/>',
        	   itemId : 'yearEndHeader1',
         	   columns :[
              	  {dataIndex : 'IN_TAX_I_01'   	, width : 80  	}
              	, {dataIndex : 'LOCAL_TAX_I_01'	, width : 100  	}
         	   ]
         	},{
        	   text:'<t:message code="system.label.human.secondInstallmentPayment" default="2차분납"/>',
        	   itemId : 'yearEndHeader2',
         	   columns :[
         		  {dataIndex : 'IN_TAX_I_02'  	, width : 80  	}
              	, {dataIndex : 'LOCAL_TAX_I_02'	, width : 100  	}
         	   ]
         	},{
        	   text:'<t:message code="system.label.human.thridInstallmentPayment" default="3차분납"/>',
        	   itemId : 'yearEndHeader3',
         	   columns :[
         		  {dataIndex : 'IN_TAX_I_03'  	, width : 80  	}
              	, {dataIndex : 'LOCAL_TAX_I_03'	, width : 100	}
         	   ]
         	}
		]
    });  
	function openYearEndWindow() {
		if (!yearEndWindow) {
			
			yearEndWindow = Ext.create('widget.uniDetailWindow', {
                title: '연말정산분납조회',
                width: 1000,
                height: 150,
                items: [yearEndGrid],
                tbar:  [
                	'->',
                	{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.human.close" default="닫기"/>',
					handler: function() {
						yearEndWindow.hide();
					},
					disabled: false
				}],
                listeners : {
          			 beforeshow: function ( me, eOpts )	{
          				yearEndStore.loadStoreRecords();
          			 }
                }
			});
		}
		if(masterGrid.getStore().getData().items && masterGrid.getStore().getData().items.length > 0 )	{
			yearEndWindow.center();
			yearEndWindow.show();
		} 

	}
	
	Unilite.createValidator('validator01', {
        store: directMasterStore2,
        grid: masterGrid2,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            if(newValue == oldValue){
                return false;
            }
            var rv = true;
            switch(fieldName) {
                case "DED_AMOUNT_I" :
                if(record.get('DED_CODE') == 'INC'){
                    var records = directMasterStore2.data.items;
                    Ext.each(records, function(item, i){
                        if (item.get('DED_CODE') == 'LOC'){
                           item.set('DED_AMOUNT_I', Math.floor((newValue * 0.1) * 0.1) *10);
                        }
                    });
                }
                    break;
            }
            return rv;
        }
    });
};


</script>
