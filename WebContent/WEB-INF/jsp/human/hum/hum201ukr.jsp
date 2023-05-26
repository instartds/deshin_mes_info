<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum201ukr">
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" />			<!-- 사용여부(예/아니오) -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /> 		<!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" />			<!-- 직위구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" />			<!-- 직책구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H094" /> 		<!-- 발령코드 -->
    <t:ExtComboStore comboType="AU" comboCode="H023" />         <!--  퇴사사유         -->
    <t:ExtComboStore comboType="AU" comboCode="H173" />         <!--  관리구분         -->
    <t:ExtComboStore comboType="AU" comboCode="H028" />         <!--  급여지급방식         -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var batchEmployWin;					//일괄적용 시 사원선택 버튼에 사용되는 팝업
	var payGrdWin;						//급호봉 / 지급수당 / 기술수당 팝업
	var gsGradeFlag		= '';			//급호봉 / 지급수당 / 기술수당 flag
	var gsGridOrPanel	= '';			//팝업 호출한 곳 구분 (01: dataForm, 02: grid)
	var wageStd			= ${wageStd};	//급호봉 코드 정보
	var gsQueryParam	= null;
	var gsPayGradeYyyy	= '';

	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'hum201ukrService.insertList',
			read	: 'hum201ukrService.selectList',
			update	: 'hum201ukrService.updateList',
			destroy	: 'hum201ukrService.deleteList',
			syncAll	: 'hum201ukrService.saveAll'
		}
	});

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'hum201ukrService.runProcedure',
			syncAll	: 'hum201ukrService.callProcedure'
		}
	});




	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('hum201ukrModel', {
		fields: [
			{name: 'COMP_CODE'					, text: '근무조'				, type: 'string', comboType:'AU', comboCode:'H004', allowBlank: false},
			{name: 'PERSON_NUMB'				, text: '사원번호'				, type: 'string', allowBlank: false},
			{name: 'NAME'						, text: '사원명'				, type: 'string', allowBlank: false},
			{name: 'DEPT_CODE'					, text: '부서코드'				, type: 'string', allowBlank: false},
			{name: 'DEPT_NAME'					, text: '부서명'				, type: 'string'},
			{name: 'BE_EMPLOY_TYPE'			    , text: '발령전'				, type: 'string'},
			{name: 'AF_EMPLOY_TYPE'				, text: '발령후'		        , type: 'string'},
			{name: 'ANNOUNCE_DATE'				, text: '발령일자'				, type: 'uniDate', allowBlank: false},
			{name: 'ANNOUNCE_CODE'				, text: '발령코드'				, type: 'string', comboType:'AU', comboCode:'H094', allowBlank: false},

			{name: 'RETR_RESN'                   , text: '퇴사사유'              , type: 'string', comboType:'AU', comboCode:'H023'},

			{name: 'APPLY_YEAR'                 , text: '적용년'                , type: 'string'},
			{name: 'APPLY_YN'					, text: '확정여부'				, type: 'string', comboType:'AU', comboCode:'B010', allowBlank: false},
			{name: 'BE_DIV_CODE'				, text: '발령전'				, type: 'string', comboType:'BOR120'},
			{name: 'AF_DIV_CODE'				, text: '발령후'				, type: 'string', comboType:'BOR120', allowBlank: false},
			{name: 'BE_DEPT_CODE'				, text: '발령전 부서코드'		    , type: 'string'},
			{name: 'BE_DEPT_NAME'				, text: '발령전 부서명'			, type: 'string'},
			{name: 'AF_DEPT_CODE'				, text: '발령후 부서코드'		    , type: 'string', allowBlank: false},
			{name: 'AF_DEPT_NAME'				, text: '발령후 부서명'			, type: 'string', allowBlank: false },
			{name: 'BE_PAY_CODE'                , text: '전'                 , type: 'string' , comboType: 'AU', comboCode: 'H028'},
			{name: 'AF_PAY_CODE'                , text: '후'                 , type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'H028'},
			{name: 'AFFIL_CODE'                 , text: '전'                 , type: 'string', comboType: 'AU', comboCode: 'H173'},
			{name: 'AF_AFFIL_CODE'              , text: '후'                 , type: 'string', allowBlank: false , comboType: 'AU', comboCode: 'H173'},
			{name: 'POST_CODE'					, text: '직위'				, type: 'string', comboType:'AU', comboCode:'H005'},
			{name: 'ABIL_CODE'					, text: '직책'				, type: 'string', comboType:'AU', comboCode:'H006'},

			{name: 'AF_POST_CODE'               , text: '직위'                , type: 'string', allowBlank: false, comboType:'AU', comboCode:'H005'},
            {name: 'AF_ABIL_CODE'               , text: '직책'                , type: 'string', comboType:'AU', comboCode:'H006'},

			{name: 'PAY_GRADE_01'				, text: '호봉(급)'			, type: 'string'},
			{name: 'PAY_GRADE_01_NAME'          , text: '호봉(급)'            , type: 'string'},
			{name: 'PAY_GRADE_02'				, text: '호봉(호)'			, type: 'string'},
			{name: 'PAY_GRADE_03'				, text: '호봉(직)'			, type: 'string'},
			{name: 'PAY_GRADE_04'				, text: '호봉(기)'			, type: 'string'},
			{name: 'PAY_GRADE_05'               , text: '호봉(조)'           , type: 'string'},
			{name: 'AF_PAY_GRADE_01'			, text: '호봉(급)'			, type: 'string'},
			{name: 'AF_PAY_GRADE_01_NAME'       , text: '호봉(급)'            , type: 'string'},
			{name: 'AF_PAY_GRADE_02'			, text: '호봉(호)'			, type: 'string'},
			{name: 'AF_PAY_GRADE_03'			, text: '호봉(직)'			, type: 'string'},
			{name: 'AF_PAY_GRADE_04'			, text: '호봉(기)'			, type: 'string'},
			{name: 'AF_PAY_GRADE_05'			, text: '호봉(조)'           , type: 'string'},

			{name: 'BE_PROG_WORK_CODE'          , text: '공정코드'           , type: 'string'},
			{name: 'BE_PROG_WORK_NAME'          , text: '공정명'             , type: 'string'},
			{name: 'AF_PROG_WORK_CODE'          , text: '공정코드'           , type: 'string'},
			{name: 'AF_PROG_WORK_NAME'          , text: '공정명'             , type: 'string'},

			{name: 'ANNOUNCE_REASON'			, text: '발령사유'			, type: 'string'},
			{name: 'BE_WAGES_AMT_01'			, text: '발령전 기본급'  		, type: 'int'},
			{name: 'BE_WAGES_AMT_02'			, text: '발령전 시간외'			, type: 'int'},
			{name: 'BE_WAGES_AMT_03'			, text: '발령전 직책수당'		, type: 'int'},
			{name: 'BE_WAGES_AMT_04'			, text: '발령전 기술수당'		, type: 'int'},
			{name: 'BE_WAGES_AMT_05'			, text: '발령전 가족수당'		, type: 'int'},
			{name: 'BE_WAGES_AMT_06'			, text: '발령전 생산장려'		, type: 'int'},
			{name: 'BE_WAGES_AMT_07'			, text: '발령전 반장수당'		, type: 'int'},
			{name: 'BE_WAGES_AMT_08'			, text: '발령전 연구수당'		, type: 'int'},
			{name: 'BE_WAGES_AMT_09'			, text: '발령전 기타수당1'		, type: 'int'},
			{name: 'BE_WAGES_AMT_10'			, text: '발령전 기타수당2'		, type: 'int'},
			{name: 'BE_WAGES_AMT_11'			, text: '발령전 운전수당'		, type: 'int'},
			{name: 'BE_WAGES_AMT_12'			, text: '발령전 연수수당'		, type: 'int'},
			{name: 'BE_WAGES_AMT_13'             , text: '발령전 조정수당'      , type: 'int'},
			{name: 'WAGES_STD_I'                , text: '기본급(급호봉)'        , type: 'int'},
			{name: 'WAGES_AMT_01'				, text: '기본급'  			, type: 'int'},
			{name: 'WAGES_AMT_02'				, text: '시간외'				, type: 'int'},
			{name: 'WAGES_AMT_03'				, text: '직책수당'				, type: 'int'},
			{name: 'WAGES_AMT_04'				, text: '기술수당'				, type: 'int'},
			{name: 'WAGES_AMT_05'				, text: '가족수당'				, type: 'int'},
			{name: 'WAGES_AMT_06'				, text: '생산장려'				, type: 'int'},
			{name: 'WAGES_AMT_07'				, text: '반장수당'				, type: 'int'},
			{name: 'WAGES_AMT_08'				, text: '연구수당'				, type: 'int'},
			{name: 'WAGES_AMT_09'				, text: '기타수당1'			, type: 'int'},
			{name: 'WAGES_AMT_10'				, text: '기타수당2'			, type: 'int'},
			{name: 'WAGES_AMT_11'				, text: '운전수당'				, type: 'int'},
			{name: 'WAGES_AMT_12'				, text: '연수수당'				, type: 'int'},
			{name: 'WAGES_AMT_13'               , text: '조정수당'              , type: 'int'}
		]
	});//End of Unilite.defineModel('hum201ukrModel', {



	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('hum201ukrMasterStore1', {
		model	: 'hum201ukrModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				config = {
//					params: [paramMaster],
					success: function(batch, option) {

					 }
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function() {
				if (this.getCount() > 0) {
//				  	UniAppManager.setToolbarButtons('delete', true);
					} else {
//				  	  	UniAppManager.setToolbarButtons('delete', false);
					}
			}
		}
	});

	var buttonStore = Unilite.createStore('hum201ukrButtonStore',{
		proxy		: directButtonProxy,
		uniOpt		: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,		   // 삭제 가능 여부
			useNavi		: false		 	// prev | newxt 버튼 사용
		},
		saveStore	: function(buttonFlag) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();

			var paramMaster		 	= panelResult.getValues();
			paramMaster.WORK_GB		= buttonFlag;
			paramMaster.LANG_TYPE   = UserInfo.userLang

			if (buttonFlag == '2') {

				config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                            //return 값 저장
                            var master = batch.operations[0].getResultSet();

                            UniAppManager.app.onQueryButtonDown();
                            buttonStore.clearData();
                         },

                         failure: function(batch, option) {
                            buttonStore.clearData();
                         }
                    };
                    this.syncAllDirect(config);

			} else { if(inValidRecs.length == 0) {
                    config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                            //return 값 저장
                            var master = batch.operations[0].getResultSet();

                            UniAppManager.app.onQueryButtonDown();
                            buttonStore.clearData();
                         },

                         failure: function(batch, option) {
                            buttonStore.clearData();
                         }
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('hum201ukrGrid1');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
	       }

		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel		: '발령기간',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_ANNOUNCE_DATE',
				endFieldName	: 'TO_ANNOUNCE_DATE',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				allowBlank		: false,
				tdAttrs			: {width: 350},
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				multiSelect	: true,
				typeAhead	: false,
				comboType	: 'BOR120',
				colspan		: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},
/* 			{
			fieldLabel	: '발령코드',
			name		: 'ANNOUNCE_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H094',
			//allowBlank	: false,
			tdAttrs		: {width: 350},
			holdable	: 'hold',
			listeners:{
                                change:function(field, newValue, oldValue, eOpts )  {

                                }
                            }
		}
		),*/
			Unilite.treePopup('DEPTTREE',{
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT',
				textFieldName	: 'DEPT_NAME' ,
				valuesName		: 'DEPTS' ,
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName	: 'TREE_NAME',
				selectChildren	: true,
				validateBlank	: true,
				autoPopup		: true,
				useLike			: true,
				listeners		: {
					'onValueFieldChange': function(field, newValue, oldValue  ){
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
					},
					'onValuesChange':  function( field, records){
					}
				}
			}),
			Unilite.popup('Employee',{
				fieldLabel		: '사원',
			  	valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
			}),{
				fieldLabel	: '발령코드',
				name		: 'ANNOUNCE_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H094'
			}
/* 			,{
            fieldLabel  : '퇴사사유',
            name        : 'RETR_RESN',
            xtype       : 'uniCombobox',
            comboType   : 'AU',
            comboCode   : 'H023',
            tdAttrs     : {width: 350},
            holdable    : 'hold'
        } */
		]
	});

	var dataForm = Unilite.createSearchForm('panelDetailForm',{
		layout	: {type : 'uniTable', columns : 2
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		region	: 'center',
		items	: [{
			fieldLabel	: '발령일자',
			xtype		: 'uniDatefield',
			name		: 'ANNOUNCE_DATE',
			value		: UniDate.get('today'),
			allowBlank	: false,
			tdAttrs		: {width: 10},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '발령코드',
			name		: 'ANNOUNCE_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H094',
			allowBlank	: false,
// 			tdAttrs		: {width: 950},
			holdable	: 'hold',
			listeners:{
//                                 change:function(field, newValue, oldValue, eOpts )  {
//                                 	if (newValue >= 60 && newValue <= 79){
//                                 		Ext.getCmp('retrResn').enable();
//                                         dataForm.setValue('RETR_RESN', '10');
// //                                         Ext.getCmp('applyyear').disable();
// //                                         dataForm.setValue('APPLY_YEAR', '');
//                                 	}
//                                     else if (newValue == 96){
//                                     	Ext.getCmp('retrResn').disable();
//                                         dataForm.setValue('RETR_RESN', '');
// //                                         Ext.getCmp('applyyear').enable();
// //                                         dataForm.setValue('APPLY_YEAR', '0');

//                                 	} else {
//                                         Ext.getCmp('retrResn').disable();
//                                         dataForm.setValue('RETR_RESN', '');
// //                                         Ext.getCmp('applyyear').disable();
// //                                         dataForm.setValue('APPLY_YEAR', '0');

//                                     }

//                                 }
                            }
		}
/* 		,{
            fieldLabel  : '퇴사사유',
            name        : 'RETR_RESN',
            xtype       : 'uniCombobox',
            id : 'retrResn',
            comboType   : 'AU',
            comboCode   : 'H023',
//            allowBlank  : false,
//            tdAttrs     : {width: 350},
            holdable    : 'hold'
//            disable : true
        } */
        ,
        {
            fieldLabel  : '발령사유',
            name        : 'ANNOUNCE_REASON',
            xtype       : 'uniTextfield',
            //allowBlank  : false,
            width       : 500,
            holdable    : 'hold'
        }
/*         ,
			{
			xtype		: 'container',
			layout 		: {type : 'uniTable'},
//			tdAttrs		: {width: 350},
			defaultType	: 'uniTextfield',
			items		: [{
		  	 	fieldLabel	: '급',
			 	name		: 'PAY_GRADE_01',
			 	//readOnly    : true,
			 	width		: 130,
			 	listeners   : {
                    render:function(el) {
                        el.getEl().on('dblclick', function(){
                            gsGridOrPanel   = '01';
                            gsGradeFlag     = '02';
                            wageCodePopup();
                        });
                    }
                }

			},{
                name        : 'PAY_GRADE_01_NAME',
                width       : 70,
                labelWidth  : 30,
                listeners   : {
                    render:function(el) {
                        el.getEl().on('dblclick', function(){
                            gsGridOrPanel   = '01';
                            gsGradeFlag     = '02';
                            wageCodePopup();
                        });
                    }
                }
            },{
		  	 	fieldLabel	: '호',
			 	name		: 'PAY_GRADE_02',
			 	width		: 70,
			 	labelWidth	: 30,
				listeners	: {
					render:function(el)	{
						el.getEl().on('dblclick', function(){
							gsGridOrPanel	= '01';
							gsGradeFlag		= '02';
							wageCodePopup();
						});
					}
				}
			},{
		  	 	fieldLabel	: '직',
			 	name		: 'PAY_GRADE_03',
			 	width		: 70,
			 	labelWidth	: 30,
				listeners	: {
					render:function(el)	{
						el.getEl().on('dblclick', function(){
							gsGridOrPanel	= '01';
							gsGradeFlag		= '03';
							wageCodePopup();
						});
					}
				}
			},{
		  	 	fieldLabel	: '기',
			 	name		: 'PAY_GRADE_04',
			 	width		: 70,
			 	labelWidth	: 30,
				listeners	: {
					render:function(el)	{
						el.getEl().on('dblclick', function(){
							gsGridOrPanel	= '01';
							gsGradeFlag		= '04';
							wageCodePopup();
						});
					}
				}
			},{
                fieldLabel  : '조',
                name        : 'PAY_GRADE_05',
                width       : 70,
                labelWidth  : 30,
                listeners   : {
                    render:function(el) {
                        el.getEl().on('dblclick', function(){
                            gsGridOrPanel   = '01';
                            gsGradeFlag     = '05';
                            wageCodePopup();
                        });
                    }
                }
            }]
		}
		,{
            fieldLabel  : '기본급(급호봉)',
            name        : 'WAGES_STD_I',
            hidden: true
        },{	//자리 맞춤용 component
			xtype	: 'component',
			width	: 10
		},

//			{
//			fieldLabel	: '발령사유',
//			name		: 'ANNOUNCE_REASON',
//			xtype		: 'uniTextfield',
//			allowBlank	: false,
//			width		: 595,
//			holdable	: 'hold'
//		},
			{
			fieldLabel  : '적용년',
			name     : 'APPLY_YEAR',
			id : 'applyyear',
			xtype        : 'uniNumberfield',
			//allowBlank   : false,
			value: 0,
            width   : 230,
            holdable    : 'hold'
        }*/
        ,{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right'},
			padding	: '0 0 5 0',
			colspan		: 2,
			items	: [{
				xtype	: 'button',
				name	: 'BUTTON_CHOISE',
				id		: 'choisePerson',
				text	: '사원선택',
//				width	: 100,
				handler	: function() {
					if(!dataForm.getInvalidMessage()){
						return false;
					}
					openBatchWin()
				}
			},{
				xtype	: 'button',
				name	: 'BUTTON_BATCH',
				id		: 'buttonBatch',
				text	: '발령확정',
//				width	: 100,
				handler : function() {
					var buttonFlag = '1';
					fnMakeLogTable(buttonFlag);
				}
			},{
				xtype	: 'button',
				name	: 'BUTTON_CANCEL',
				id		: 'buttonCancel',
				text	: '발령취소',
//				width	: 100,
				handler : function() {
					var buttonFlag = '2';
					fnMakeLogTable(buttonFlag);
				}
			}]
		}]
	});




	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('hum201ukrGrid1', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
		 	useRowNumberer		: true,
			onLoadSelectFirst	: false,
		 	copiedRow			: true,
		 	state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
//		 	useContextMenu	: true,
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount() > 0) {
						Ext.getCmp('buttonBatch').enable();
						Ext.getCmp('buttonCancel').enable();
					}
				},

				deselect:  function(grid, selectRecord, index, eOpts ){
					if (this.selected.getCount() <= 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
						Ext.getCmp('buttonBatch').disable();
						Ext.getCmp('buttonCancel').disable();
					}
				}
			}
		}),
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns	: [{
				xtype	: 'rownumberer',
				align	: 'center  !important',
				width	: 35,
				sortable: false,
				resizable: true
			},
			{dataIndex: 'PERSON_NUMB'			, width: 90,locked: true,
				'editor' : Unilite.popup('Employee_G',{
					validateBlank : true,
					autoPopup:true,
	  				listeners: {
	  					'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								console.log(records);
//								var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
								var grdRecord = masterGrid.uniOpt.currentRecord;
								//
								grdRecord.set('DEPT_NAME'		     , records[0].DEPT_NAME);
								grdRecord.set('DEPT_CODE'		     , records[0].DEPT_CODE);
								grdRecord.set('PERSON_NUMB'		     , records[0].PERSON_NUMB);
								grdRecord.set('NAME'			     , records[0].NAME);
								grdRecord.set('BE_DIV_CODE'		     , records[0].DIV_CODE);
								grdRecord.set('BE_DEPT_CODE'	     , records[0].DEPT_CODE);
								grdRecord.set('BE_DEPT_NAME'	     , records[0].DEPT_NAME);
								grdRecord.set('AF_DIV_CODE'		     , records[0].DIV_CODE);
								grdRecord.set('AF_DEPT_CODE'	     , records[0].DEPT_CODE);
								grdRecord.set('AF_DEPT_NAME'	     , records[0].DEPT_NAME);
								grdRecord.set('BE_PAY_CODE'          , records[0].PAY_CODE);
								grdRecord.set('AF_PAY_CODE'          , records[0].PAY_CODE);
								grdRecord.set('AFFIL_CODE'           , records[0].AFFIL_CODE);
								grdRecord.set('AF_AFFIL_CODE'        , records[0].AFFIL_CODE);
								grdRecord.set('POST_CODE'		     , records[0].POST_CODE);
								grdRecord.set('ABIL_CODE'		     , records[0].ABIL_CODE);
								grdRecord.set('AF_POST_CODE'         , records[0].POST_CODE);
                                grdRecord.set('AF_ABIL_CODE'         , records[0].ABIL_CODE);
								grdRecord.set('PAY_GRADE_01'	     , records[0].PAY_GRADE_01);
								grdRecord.set('PAY_GRADE_01_NAME'    , records[0].PAY_GRADE_01_NAME);
								grdRecord.set('PAY_GRADE_02'	     , records[0].PAY_GRADE_02);
								grdRecord.set('PAY_GRADE_03'	     , records[0].PAY_GRADE_03);
								grdRecord.set('PAY_GRADE_04'	     , records[0].PAY_GRADE_04);
								grdRecord.set('PAY_GRADE_05'         , records[0].PAY_GRADE_05);
								grdRecord.set('AF_PAY_GRADE_01'	     , records[0].PAY_GRADE_01);
								grdRecord.set('AF_PAY_GRADE_01_NAME' , records[0].PAY_GRADE_01_NAME);
								grdRecord.set('AF_PAY_GRADE_02'	     , records[0].PAY_GRADE_02);
								grdRecord.set('AF_PAY_GRADE_03'	     , records[0].PAY_GRADE_03);
								grdRecord.set('AF_PAY_GRADE_04'	     , records[0].PAY_GRADE_04);
								grdRecord.set('AF_PAY_GRADE_05'      , records[0].PAY_GRADE_05);

								fnGetWages(grdRecord, records[0].PERSON_NUMB);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_NAME'		      , '');
							grdRecord.set('DEPT_CODE'		      , '');
							grdRecord.set('PERSON_NUMB'		      , '');
							grdRecord.set('NAME'			      , '');
							grdRecord.set('BE_DIV_CODE'		      , '');
							grdRecord.set('BE_DEPT_CODE'	      , '');
							grdRecord.set('BE_DEPT_NAME'	      , '');
							grdRecord.set('AF_DIV_CODE'		      , '');
							grdRecord.set('AF_DEPT_CODE'	      , '');
							grdRecord.set('AF_DEPT_NAME'	      , '');
							grdRecord.set('BE_PAY_CODE'           , '');
                            grdRecord.set('AF_PAY_CODE'           , '');
                            grdRecord.set('AFFIL_CODE'            , '');
                            grdRecord.set('AF_AFFIL_CODE'         , '');
							grdRecord.set('POST_CODE'		      , '');
							grdRecord.set('ABIL_CODE'		      , '');
							grdRecord.set('AF_POST_CODE'          , '');
                            grdRecord.set('AF_ABIL_CODE'          , '');
							grdRecord.set('PAY_GRADE_01'	      , '');
							grdRecord.set('PAY_GRADE_02'	      , '');
							grdRecord.set('PAY_GRADE_03'	      , '');
							grdRecord.set('PAY_GRADE_04'	      , '');
							grdRecord.set('AF_PAY_GRADE_01'	      , '');
							grdRecord.set('AF_PAY_GRADE_01_NAME'  , '');
							grdRecord.set('AF_PAY_GRADE_02'	      , '');
							grdRecord.set('AF_PAY_GRADE_03'	      , '');
							grdRecord.set('AF_PAY_GRADE_04'	      , '');
							grdRecord.set('AF_PAY_GRADE_05'       , '');

							fnGetWages(grdRecord, '');
						},
						applyextparam: function(popup){
//							popup.setExtParam({'PAY_GUBUN' : '2'});
						}
	 				}
				})
			},
			{dataIndex: 'NAME'			  	  	, width: 100,locked: true,
				'editor' : Unilite.popup('Employee_G',{
					validateBlank : true,
					autoPopup:true,
	  				listeners: {
	  					'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								console.log(records);
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('DEPT_NAME'		, records[0].DEPT_NAME);
								grdRecord.set('DEPT_CODE'		, records[0].DEPT_CODE);
								grdRecord.set('PERSON_NUMB'		, records[0].PERSON_NUMB);
								grdRecord.set('NAME'			, records[0].NAME);
								grdRecord.set('BE_DIV_CODE'		, records[0].DIV_CODE);
								grdRecord.set('BE_DEPT_CODE'	, records[0].DEPT_CODE);
								grdRecord.set('BE_DEPT_NAME'	, records[0].DEPT_NAME);
								grdRecord.set('AF_DIV_CODE'		, records[0].DIV_CODE);
								grdRecord.set('AF_DEPT_CODE'	, records[0].DEPT_CODE);
								grdRecord.set('AF_DEPT_NAME'	, records[0].DEPT_NAME);
								grdRecord.set('BE_PAY_CODE'     , records[0].PAY_CODE);
                                grdRecord.set('AF_PAY_CODE'     , records[0].PAY_CODE);
                                grdRecord.set('AFFIL_CODE'      , records[0].AFFIL_CODE);
                                grdRecord.set('AF_AFFIL_CODE'   , records[0].AFFIL_CODE);
								grdRecord.set('POST_CODE'		, records[0].POST_CODE);
								grdRecord.set('ABIL_CODE'		, records[0].ABIL_CODE);
								grdRecord.set('AF_POST_CODE'    , records[0].POST_CODE);
                                grdRecord.set('AF_ABIL_CODE'    , records[0].ABIL_CODE);
								grdRecord.set('PAY_GRADE_01'	, records[0].PAY_GRADE_01);
								grdRecord.set('PAY_GRADE_01_NAME'    , records[0].PAY_GRADE_01_NAME);
								grdRecord.set('PAY_GRADE_02'	, records[0].PAY_GRADE_02);
								grdRecord.set('PAY_GRADE_03'	, records[0].PAY_GRADE_03);
								grdRecord.set('PAY_GRADE_04'	, records[0].PAY_GRADE_04);
								grdRecord.set('PAY_GRADE_05'    , records[0].PAY_GRADE_05);
								grdRecord.set('AF_PAY_GRADE_01'	, records[0].PAY_GRADE_01);
								grdRecord.set('AF_PAY_GRADE_01_NAME' , records[0].PAY_GRADE_01_NAME);
								grdRecord.set('AF_PAY_GRADE_02'	, records[0].PAY_GRADE_02);
								grdRecord.set('AF_PAY_GRADE_03'	, records[0].PAY_GRADE_03);
								grdRecord.set('AF_PAY_GRADE_04'	, records[0].PAY_GRADE_04);
								grdRecord.set('AF_PAY_GRADE_05' , records[0].PAY_GRADE_05);

								fnGetWages(grdRecord, records[0].PERSON_NUMB);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_NAME'		, '');
							grdRecord.set('DEPT_CODE'		, '');
							grdRecord.set('PERSON_NUMB'		, '');
							grdRecord.set('NAME'			, '');
							grdRecord.set('BE_DIV_CODE'		, '');
							grdRecord.set('BE_DEPT_CODE'	, '');
							grdRecord.set('BE_DEPT_NAME'	, '');
							grdRecord.set('AF_DIV_CODE'		, '');
							grdRecord.set('AF_DEPT_CODE'	, '');
							grdRecord.set('AF_DEPT_NAME'	, '');
							grdRecord.set('BE_PAY_CODE'     , '');
                            grdRecord.set('AF_PAY_CODE'     , '');
                            grdRecord.set('AFFIL_CODE'      , '');
                            grdRecord.set('AF_AFFIL_CODE'   , '');
							grdRecord.set('POST_CODE'		, '');
							grdRecord.set('ABIL_CODE'		, '');
							grdRecord.set('AF_POST_CODE'        , '');
                            grdRecord.set('AF_ABIL_CODE'       , '');
							grdRecord.set('PAY_GRADE_01'	, '');
							grdRecord.set('PAY_GRADE_01_NAME' , '');
							grdRecord.set('PAY_GRADE_02'	, '');
							grdRecord.set('PAY_GRADE_03'	, '');
							grdRecord.set('PAY_GRADE_04'	, '');
							grdRecord.set('PAY_GRADE_05' , '');
							grdRecord.set('AF_PAY_GRADE_01'	, '');
							grdRecord.set('AF_PAY_GRADE_01_NAME'  , '');
							grdRecord.set('AF_PAY_GRADE_02'	, '');
							grdRecord.set('AF_PAY_GRADE_03'	, '');
							grdRecord.set('AF_PAY_GRADE_04'	, '');
							grdRecord.set('AF_PAY_GRADE_05'  , '');

							fnGetWages(grdRecord, '');
						},
						applyextparam: function(popup){
//							popup.setExtParam({'PAY_GUBUN' : '2'});
						}
	 				}
				})
			},
			{dataIndex: 'DEPT_CODE'	  			, width: 120,locked: true,
				'editor': Unilite.popup('DEPT_G', {
//		 					DBtextFieldName: 'DEPT_CODE',
			  		autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								record = records[0];
								grdRecord.set('DEPT_CODE'	, record['TREE_CODE']);
								grdRecord.set('DEPT_NAME'	, record['TREE_NAME']);
								grdRecord.set('BE_DEPT_CODE', record['TREE_CODE']);
								grdRecord.set('BE_DEPT_NAME', record['TREE_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE'	, '');
							grdRecord.set('DEPT_NAME'	, '');
							grdRecord.set('BE_DEPT_CODE', '');
							grdRecord.set('BE_DEPT_NAME', '');
						},
						applyextparam: function(popup){

						}
					}
				})
			},
			{dataIndex: 'DEPT_NAME'	  			, width: 120, locked: true,
				'editor': Unilite.popup('DEPT_G', {
//		 					DBtextFieldName: 'DEPT_CODE',
			  		autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								record = records[0];
								grdRecord.set('DEPT_CODE'	, record['TREE_CODE']);
								grdRecord.set('DEPT_NAME'	, record['TREE_NAME']);
								grdRecord.set('BE_DEPT_CODE', record['TREE_CODE']);
								grdRecord.set('BE_DEPT_NAME', record['TREE_NAME']);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('DEPT_CODE'	, '');
							grdRecord.set('DEPT_NAME'	, '');
							grdRecord.set('BE_DEPT_CODE', '');
							grdRecord.set('BE_DEPT_NAME', '');
						},
						applyextparam: function(popup){

						}
					}
				})
			},
			{dataIndex: 'ANNOUNCE_DATE'			, width: 100},
			{dataIndex: 'ANNOUNCE_CODE'		 	, width: 130},

			{dataIndex: 'RETR_RESN'          , width: 80},  //퇴사사유

			{dataIndex: 'APPLY_YEAR'            , width: 130},
			{dataIndex: 'APPLY_YN'			 	, width: 80},
			{text: '사업장',
              	columns:[
					{dataIndex: 'BE_DIV_CODE'			, width: 130},
					{dataIndex: 'AF_DIV_CODE'			, width: 130}
			]},
			{text: '부서명',
              	columns:[
					{dataIndex: 'BE_DEPT_NAME'			, width: 133},
					{dataIndex: 'AF_DEPT_NAME'			, width: 133,
						'editor': Unilite.popup('DEPT_G', {
			  				autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										var grdRecord = masterGrid.uniOpt.currentRecord;
										record = records[0];
										grdRecord.set('AF_DEPT_CODE', record['TREE_CODE']);
										grdRecord.set('AF_DEPT_NAME', record['TREE_NAME']);
									},
									scope: this
								},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('AF_DEPT_CODE', '');
									grdRecord.set('AF_DEPT_NAME', '');
								},
								applyextparam: function(popup){

								}
							}
						})
					}
			]},
			{text: '급여지급방식',
                columns:[
                    {dataIndex: 'BE_PAY_CODE'          , width: 133},
                    {dataIndex: 'AF_PAY_CODE'          , width: 133}
            ]},
            {text: '관리구분',
                columns:[
                    {dataIndex: 'AFFIL_CODE'          , width: 133},
                    {dataIndex: 'AF_AFFIL_CODE'          , width: 133}
            ]},

			{text: '발령 전',
                columns:[
        			{dataIndex: 'POST_CODE'				, width: 133, hidden:false},
        			{dataIndex: 'ABIL_CODE'				, width: 133}
			]},

			{text: '발령 후',
                columns:[
                    {dataIndex: 'AF_POST_CODE'          , width: 133, hidden:false},
                    {dataIndex: 'AF_ABIL_CODE'          , width: 133}
            ]},

			{text: '발령 전',
              	columns:[
					{dataIndex: 'PAY_GRADE_01'			, width: 90, hidden: true},
					{dataIndex: 'PAY_GRADE_01_NAME'     , width: 120},
					{dataIndex: 'PAY_GRADE_02'			, width: 90},
					{dataIndex: 'PAY_GRADE_03'			, width: 90},
					{dataIndex: 'PAY_GRADE_04'			, width: 90},
					{dataIndex: 'PAY_GRADE_05'          , width: 90}
			]},
			{text: '발령 후',
              	columns:[
					{dataIndex: 'AF_PAY_GRADE_01'		, width: 90, hidden: true},
					{dataIndex: 'AF_PAY_GRADE_01_NAME'  , width: 120},
					{dataIndex: 'AF_PAY_GRADE_02'		, width: 90},
					{dataIndex: 'AF_PAY_GRADE_03'		, width: 90},
					{dataIndex: 'AF_PAY_GRADE_04'		, width: 90},
					{dataIndex: 'AF_PAY_GRADE_05'       , width: 90}
			]},

			{text: '발령 전',
                columns:[
                    {dataIndex: 'BE_PROG_WORK_CODE'          , width: 90,
                    'editor': Unilite.popup('PROG_WORK_CODE_G', {
                                textFieldName:   'PROG_WORK_NAME',
                                DBtextFieldName: 'PROG_WORK_NAME',
                                //extParam: {SELMODEL: 'MULTI'},
                                autoPopup: true,
                                listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        Ext.each(records, function(record,i) {
                                            if(i==0) {
                                                masterGrid.setItemData2(record,false, masterGrid.uniOpt.currentRecord);
                                            }else{
                                                UniAppManager.app.onNewDataButtonDown();
                                                masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                            }
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    var grdRecord = masterGrid.getSelectedRecord();
                                    masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                                },
                                applyextparam: function(popup){
                                    var record = masterGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE'       : UserInfo.divCode});
                                    popup.setExtParam({'WORK_SHOP_CODE' : ''}); //3321
                                    //popup.setExtParam({'SELMODEL' : 'MULTI'});
                                }
                            }
                        })
                    },
                    {dataIndex: 'BE_PROG_WORK_NAME'         , width: 120, hidden: true}
            ]},
            {text: '발령 후',
                columns:[
                    {dataIndex: 'AF_PROG_WORK_CODE'       , width: 90,
                    'editor': Unilite.popup('PROG_WORK_CODE_G', {
                                textFieldName:   'PROG_WORK_NAME',
                                DBtextFieldName: 'PROG_WORK_NAME',
                                //extParam: {SELMODEL: 'MULTI'},
                                autoPopup: true,
                                listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        Ext.each(records, function(record,i) {
                                            if(i==0) {
                                                masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                            }else{
                                                UniAppManager.app.onNewDataButtonDown();
                                                masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                            }
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    var grdRecord = masterGrid.getSelectedRecord();
                                    masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                                },
                                applyextparam: function(popup){
                                    var record = masterGrid.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE'       : UserInfo.divCode});
                                    popup.setExtParam({'WORK_SHOP_CODE' : ''}); //3321
                                    //popup.setExtParam({'SELMODEL' : 'MULTI'});
                                }
                            }
                        })
                    },
                    {dataIndex: 'AF_PROG_WORK_NAME'      , width: 120, hidden: true


                    }
            ]},

			{dataIndex: 'ANNOUNCE_REASON'		, width: 200},
            {dataIndex: 'WAGES_STD_I'           , width: 200, hidden: true},
            {text: '발령전 급여 정보',
              	columns:[
					{dataIndex: 'BE_WAGES_AMT_01'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_02'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_03'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_04'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_05'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_06'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_07'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_08'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_09'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_10'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_11'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_12'		, width: 133, hidden: true},
					{dataIndex: 'BE_WAGES_AMT_13'       , width: 133, hidden: true}
			]},
			{text: '급여 정보',
              	columns:[
					{dataIndex: 'WAGES_AMT_01'		, width: 133},
					{dataIndex: 'WAGES_AMT_02'		, width: 133},
					{dataIndex: 'WAGES_AMT_03'		, width: 133},
					{dataIndex: 'WAGES_AMT_04'		, width: 133},
					{dataIndex: 'WAGES_AMT_05'		, width: 133},
					{dataIndex: 'WAGES_AMT_06'		, width: 133},
					{dataIndex: 'WAGES_AMT_07'		, width: 133},
					{dataIndex: 'WAGES_AMT_08'		, width: 133},
					{dataIndex: 'WAGES_AMT_09'		, width: 133},
					{dataIndex: 'WAGES_AMT_10'		, width: 133},
					{dataIndex: 'WAGES_AMT_11'		, width: 133},
					{dataIndex: 'WAGES_AMT_12'		, width: 133},
					{dataIndex: 'WAGES_AMT_13'      , width: 133}
			]}
		],
        setItemData: function(record, dataClear, grdRecord) {
            if(dataClear) {

                grdRecord.set('AF_PROG_WORK_CODE'          , '');
                //grdRecord.set('AF_PROG_WORK_NAME'          , '');
            }else{

                grdRecord.set('AF_PROG_WORK_CODE'          , record['PROG_WORK_CODE']);
                //grdRecord.set('AF_PROG_WORK_NAME'          , record['PROG_WORK_NAME']);
            }
        },
        setItemData2: function(record, dataClear, grdRecord) {
            if(dataClear) {
                grdRecord.set('BE_PROG_WORK_CODE'          , '');

                //grdRecord.set('AF_PROG_WORK_NAME'          , '');
            }else{
                grdRecord.set('BE_PROG_WORK_CODE'          , record['PROG_WORK_CODE']);

                //grdRecord.set('AF_PROG_WORK_NAME'          , record['PROG_WORK_NAME']);
            }
        },
		listeners: {
      		beforeedit  : function( editor, e, eOpts ) {
				if (e.record.data.APPLY_YN == 'Y') {
					if(UniUtils.indexOf(e.field,['BE_PROG_WORK_CODE','AF_PROG_WORK_CODE'])){
						return true;
					}
					return false;
				}
	      		if(e.record.phantom){
	      			if (UniUtils.indexOf(e.field, ['DEPT_NAME', 'DEPT_CODE', 'BE_DIV_CODE', 'BE_DEPT_NAME', 'APPLY_YN', /*'POST_CODE', 'ABIL_CODE',*/ 
	      										   'BE_PAY_CODE', 'AFFIL_CODE', 'POST_CODE', 'ABIL_CODE',
	      										   'PAY_GRADE_01', 'PAY_GRADE_01_NAME', 'PAY_GRADE_02', 'PAY_GRADE_03', 'PAY_GRADE_04', 'PAY_GRADE_05'])){
	      			//if (UniUtils.indexOf(e.field, ['DEPT_NAME', 'DEPT_CODE', 'BE_DIV_CODE', 'BE_DEPT_NAME', 'APPLY_YN', /*'POST_CODE', 'ABIL_CODE',*/ 'PAY_GRADE_01', 'PAY_GRADE_02', 'PAY_GRADE_03', 'PAY_GRADE_04', 'PAY_GRADE_05'])){
	      			/*if (UniUtils.indexOf(e.field, ['DEPT_NAME', 'DEPT_CODE', 'BE_DIV_CODE', 'BE_DEPT_CODE', 'BE_DEPT_NAME', 'APPLY_YN', 'POST_CODE', 'ABIL_CODE', 'PAY_GRADE_01', 'PAY_GRADE_02', 'PAY_GRADE_03', 'PAY_GRADE_04',
	      			                              'BE_WAGES_AMT_01', 'BE_WAGES_AMT_02', 'BE_WAGES_AMT_03', 'BE_WAGES_AMT_04', 'BE_WAGES_AMT_05', 'BE_WAGES_AMT_06', 'BE_WAGES_AMT_07', 'BE_WAGES_AMT_08', 'BE_WAGES_AMT_09', 'BE_WAGES_AMT_10'
	      			                              , 'BE_WAGES_AMT_11', 'BE_WAGES_AMT_12'])){*/
						return false;
					}
				} else {
	      			if (UniUtils.indexOf(e.field, ['PERSON_NUMB','NAME', 'DEPT_NAME', 'DEPT_CODE', 'BE_DIV_CODE', 'BE_DEPT_CODE', 'BE_DEPT_NAME', 'APPLY_YN', 'POST_CODE', 'ABIL_CODE', 'PAY_GRADE_01', 'PAY_GRADE_02', 'PAY_GRADE_03', 'PAY_GRADE_04', 'PAY_GRADE_05'
	      			                              , 'BE_WAGES_AMT_01', 'BE_WAGES_AMT_02', 'BE_WAGES_AMT_03', 'BE_WAGES_AMT_04', 'BE_WAGES_AMT_05', 'BE_WAGES_AMT_06', 'BE_WAGES_AMT_07', 'BE_WAGES_AMT_08', 'BE_WAGES_AMT_09', 'BE_WAGES_AMT_10'
                                                  , 'BE_WAGES_AMT_11', 'BE_WAGES_AMT_12', 'BE_WAGES_AMT_13'
                                                  , 'BE_PAY_CODE', 'AFFIL_CODE', 'POST_CODE', 'ABIL_CODE'
                                                  , 'PAY_GRADE_01', 'PAY_GRADE_01_NAME', 'PAY_GRADE_02', 'PAY_GRADE_03', 'PAY_GRADE_04', 'PAY_GRADE_05'
                                                  ])){
						return false;
					}
				}
      		},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
        		if (colName == 'AF_PAY_GRADE_01') {
					gsGridOrPanel	= '02';
					gsGradeFlag		= '01';
					gsQueryParam	= null;
					gsPayGradeYyyy	= UniDate.getDbDateStr(record.get('ANNOUNCE_DATE')).substring(0, 4);
					
					wageCodePopup();

        		} else if (colName == 'AF_PAY_GRADE_01_NAME') {
                    gsGridOrPanel   = '02';
                    gsGradeFlag     = '01';
					gsPayGradeYyyy	= UniDate.getDbDateStr(record.get('ANNOUNCE_DATE')).substring(0, 4);
                    
                    gsQueryParam = {
                    	PAY_GRADE_01_NAME	: record.get('AF_PAY_GRADE_01_NAME'),
                    	PAY_GRADE_02		: record.get('AF_PAY_GRADE_02')
                    };
                    
                    wageCodePopup();
                } else if (colName == 'AF_PAY_GRADE_02') {
					gsGridOrPanel	= '02';
					gsGradeFlag		= '02';
					gsPayGradeYyyy	= UniDate.getDbDateStr(record.get('ANNOUNCE_DATE')).substring(0, 4);
                    
                    gsQueryParam = {
                    	PAY_GRADE_01_NAME	: record.get('AF_PAY_GRADE_01_NAME'),
                    	PAY_GRADE_02		: record.get('AF_PAY_GRADE_02')
                    };
                    
                    wageCodePopup();
        		} else if (colName == 'AF_PAY_GRADE_03') {
					gsGridOrPanel	= '02';
					gsGradeFlag		= '03';
					gsQueryParam	= null;
					gsPayGradeYyyy	= UniDate.getDbDateStr(record.get('ANNOUNCE_DATE')).substring(0, 4);
					
					wageCodePopup();

        		} else if (colName == 'AF_PAY_GRADE_04') {
					gsGridOrPanel	= '02';
					gsGradeFlag		= '04';
					gsQueryParam	= null;
					gsPayGradeYyyy	= UniDate.getDbDateStr(record.get('ANNOUNCE_DATE')).substring(0, 4);
					
					wageCodePopup();
        		} /*else if (colName == 'AF_PAY_GRADE_05') {
                    gsGridOrPanel   = '02';
                    gsGradeFlag     = '05';
                    gsQueryParam	= null;
                    wageCodePopup();
                }*/
            }
        }
	});//End of var masterGrid = Unilite.createGr100id('hum201ukrGrid1', {




	Unilite.Main( {
		id			: 'hum201ukrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: {type: 'vbox', align: 'stretch'},
			border	: false,
			items	: [
				panelResult, dataForm, masterGrid
			]
		}],

		fnInitBinding: function(params) {
			//초기값 설정
			panelResult.setValue('FR_ANNOUNCE_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('TO_ANNOUNCE_DATE'	, UniDate.get('today'));
			panelResult.setValue('PAY_CODE'			, '0');
			dataForm.setValue('ANNOUNCE_DATE'		, UniDate.get('today'));
			Ext.getCmp('buttonBatch').disable();
			Ext.getCmp('buttonCancel').disable();
// 			Ext.getCmp('retrResn').disable();
// 			Ext.getCmp('applyyear').disable();

			//버튼 설정
			UniAppManager.setToolbarButtons(['newData']			, true);
			UniAppManager.setToolbarButtons(['reset', 'save']	, false);

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('FR_ANNOUNCE_DATE');
			
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		//링크로 넘어오는 params 받는 부분 
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'hum105ukr') {
				panelResult.setValue('FR_ANNOUNCE_DATE',params.ANNOUNCE_DATE);
				panelResult.setValue('TO_ANNOUNCE_DATE',params.ANNOUNCE_DATE);
				panelResult.setValue('ANNOUNCE_CODE','10');
				//panelResult.setValue('PERSON_NUMB',params.PERSON_NUMB);
			}
			
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown: function() {
			//필수입력값 체크
			if(!this.isValidSearchForm()){
				return false;
			}

			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			dataForm.clearForm();
		},

		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			if(!dataForm.getInvalidMessage()){
				return false;
			}

			if(dataForm.getValue('ANNOUNCE_CODE') == 96) {
				if(dataForm.getValue('APPLY_YEAR') == '0'){

                    alert('발령코드가 연봉계약일 경우, 적용년는 필수입력항목입니다.');
                    return false;
				} else if (Ext.isEmpty(dataForm.getValue('APPLY_YEAR'))) {
				    alert('발령코드가 연봉계약일 경우, 적용년는 필수입력항목입니다.');
                    return false;
				}
            }

//			panelResult.getForm().getFields().each(function(field) {
//				  field.setReadOnly(true);
//			});

//			var retrResn;
//			if(dataForm.getValue('ANNOUNCE_CODE') < 90){
//			     retrResn = '';
//			}else {
//			     retrResn = dataForm.getValue('RETR_RESN');
//			}


			var record = {
				COMP_CODE		: UserInfo.compCode,
				ANNOUNCE_DATE	: UniDate.getDbDateStr(dataForm.getValue('ANNOUNCE_DATE')),
				ANNOUNCE_CODE	: dataForm.getValue('ANNOUNCE_CODE'),
				APPLY_YN		: 'N',
				ANNOUNCE_REASON	: dataForm.getValue('ANNOUNCE_REASON'),
				APPLY_YEAR : 0,

				RETR_RESN : dataForm.getValue('RETR_RESN')
//				RETR_RESN : retrResn



			};
			masterGrid.createRow(record, null, masterGrid.getStore().getCount()-1);
			UniAppManager.setToolbarButtons('reset', true);
		},

		onSaveDataButtonDown : function() {
			masterGrid.getStore().saveStore();
		},

		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			//var selRow = masterGrid.uniOpt.currentRecord;
			if(selRow && selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if (selRow && selRow.get('APPLY_YN') == 'Y') {
					alert('이미 확정된 데이터는 삭제할 수 없습니다.');
					return false;

				} else {
					masterGrid.deleteSelectedRow();
				}
			}
		},

		onResetButtonDown : function() {
			panelResult.getForm().getFields().each(function(field) {
				  field.setReadOnly(false);
			});
			panelResult.clearForm();
			dataForm.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
	});//End of Unilite.Main( {




	//사원선택 윈도우
	function openBatchWin()	{
		if(!batchEmployWin) {
			//Model 정의
			Unilite.defineModel('batchEmployeePopupModel', {
			fields: [ 	 {name: 'NAME' 				,text:'성명' 			,type:'string'}
						,{name: 'PERSON_NUMB' 		,text:'사번' 			,type:'string'}
						,{name: 'DIV_CODE'	 		,text:'사업장' 		    ,type:'string'}
						,{name: 'POST_CODE' 		,text:'직위CD' 		,type:'string'}
						,{name: 'POST_CODE_NAME' 	,text:'직위' 			,type:'string'}
						,{name: 'DEPT_CODE' 		,text:'부서CD' 		,type:'string'}
						,{name: 'DEPT_NAME' 		,text:'부서' 			,type:'string'}
						,{name: 'AFFIL_CODE'        ,text:'관리구분'       ,type:'string'}
						,{name: 'PAY_CODE'          ,text:'급여지급구분'     ,type:'string'}
						,{name: 'JOIN_DATE' 		,text:'입사일' 		,type:'uniDate'}
						,{name: 'ABIL_CODE' 		,text:'직책CD' 		,type:'string'}
						,{name: 'ABIL_NAME' 		,text:'직책' 			,type:'string'}
						,{name: 'PAY_GRADE_01'		,text:'호봉(급)'		,type:'string'}
						,{name: 'PAY_GRADE_01_NAME'        ,text:'호봉(급)'       ,type:'string'}
						,{name: 'PAY_GRADE_02'		,text:'호봉(호)'		,type:'string'}
						,{name: 'PAY_GRADE_03'		,text:'호봉(직)'		,type:'string'}
						,{name: 'PAY_GRADE_04'		,text:'호봉(기)'		,type:'string'}
						,{name: 'PAY_GRADE_05'        ,text:'호봉(조)'       ,type:'string'}
					]
			});

			//Proxy 생성
			var batchEmployeePopupProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				api: {
					read : 'popupService.employeePopup'
				}
			});

			//Store 생성
			var batchEmployeeStore = Unilite.createStore('batchEmployeeStore', {
				model	: 'batchEmployeePopupModel' ,
				uniOpt	: {
					isMaster	: false,			// 상위 버튼 연결
					editable	: false,			// 수정 모드 사용
					deletable	: false,			// 삭제 가능 여부
					useNavi		: false				// prev | newxt 버튼 사용
				},
				proxy	: batchEmployeePopupProxy,
				loadStoreRecords : function()	{
					var param= batchEmployWin.down('#search').getValues();

					this.load({
						params: param
					});
				}
			});

			//OPEN할 팝업(Window) 생성
			batchEmployWin = Ext.create('widget.uniDetailWindow', {
				title	: '사원선택 POPUP',
				width	: 600,
				height	: 400,
				layout	: {type:'vbox', align:'stretch'},
				items	: [{
					itemId	: 'search',
					xtype	: 'uniSearchForm',
					layout	: {type:'uniTable',columns:2},
					items	: [{
						fieldLabel	: '기준일',
						name		: 'BASE_DT',
						xtype		: 'uniDatefield',
						value     : UniDate.get('today')
					//value        : new Date()

					},{
						fieldLabel	: '부서',
						name		: 'DEPT_SEARCH',
						xtype		: 'uniTextfield'
					},{
						fieldLabel	: '조회조건',
						name		: 'TXT_SEARCH',
						xtype		: 'uniTextfield' ,
                        listeners	: {
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }]
				},
					Unilite.createGrid('batchEmployGrd', {
						store	: batchEmployeeStore,
						itemId	: 'grid',
						layout	: 'fit',
				    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
				    		listeners: {
				    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
					    			if (this.selected.getCount() > 0) {
					    			}

				    			},
					    		deselect:  function(grid, selectRecord, index, eOpts ){
					    			if (this.selected.getCount() == 0) {
					    			}
					    		}
				    		}
				    	}),
						uniOpt	: {
							expandLastColumn	: false,
							useRowNumberer		: false,
							onLoadSelectFirst	: false,
							userToolbar			: false
						},
					    columns:  [{
								xtype	: 'rownumberer',
								sortable: false,
								width	: 35,
								align	:'center  !important',
								resizable: true
				        	},
					    	{dataIndex: 'NAME' 				,width:90	,locked:true},
				    		{dataIndex: 'PERSON_NUMB' 		,width:100	,locked:true},
				    		{dataIndex: 'DIV_CODE'          ,width:100  ,hidden:true},
			    			{dataIndex: 'POST_CODE' 		,width:100	,hidden:true},
		    				{dataIndex: 'POST_CODE_NAME' 	,width:100	},
	    					{dataIndex: 'DEPT_CODE' 		,width:100	,hidden:true},
    						{dataIndex: 'DEPT_NAME' 		,width:130	},
    						{dataIndex: 'AFFIL_CODE'         ,width:100 },
    						{dataIndex: 'PAY_CODE'         ,width:100  },
							{dataIndex: 'JOIN_DATE' 		,width:100	},
							{dataIndex: 'ABIL_CODE' 		,width:100	,hidden:true},
							{dataIndex: 'ABIL_NAME' 		,width:100	},
							{dataIndex: 'PAY_GRADE_01'      ,width:90  },
							{dataIndex: 'PAY_GRADE_01_NAME'      ,width:120  },
							{dataIndex: 'PAY_GRADE_02'      ,width:90  },
							{dataIndex: 'PAY_GRADE_03'      ,width:90  },
							{dataIndex: 'PAY_GRADE_04'      ,width:90  },
							{dataIndex: 'PAY_GRADE_05'      ,width:90  }
					    ],
						listeners: {
					  		onGridDblClick:function(grid, record, cellIndex, colName) {
			  					grid.ownerGrid.returnData();
			  					batchEmployWin.hide();
			  				}
						},
//						returnData: function()	{
						returnData: function(record)	{

//							var records = this.uniOpt.currentRecord;
							var records = this.sortedSelectedRecords(this);
							//uniOpt.currentRecord;
							//var records = this.getSelectionModel().getSelection();


			                Ext.each(records, function(record, index) {
								var param = {
									PERSON_NUMB    : record.get('PERSON_NUMB')
								}

//			                	UniAppManager.app.onNewDataButtonDown();
//                                masterGrid.setMrpData(record.data);



								hum201ukrService.getWages(param, function(provider, response)	{



									//var store = Ext.data.StoreManager.lookup(storeId);
									if (!Ext.isEmpty(provider)) {
										var beWagesAmt_01	= provider[0].BE_WAGES_AMT_01;
										var beWagesAmt_02	= provider[0].BE_WAGES_AMT_02;
										var beWagesAmt_03	= provider[0].BE_WAGES_AMT_03;
										var beWagesAmt_04	= provider[0].BE_WAGES_AMT_04;
										var beWagesAmt_05	= provider[0].BE_WAGES_AMT_05;
										var beWagesAmt_06	= provider[0].BE_WAGES_AMT_06;
										var beWagesAmt_07	= provider[0].BE_WAGES_AMT_07;
										var beWagesAmt_08	= provider[0].BE_WAGES_AMT_08;
										var beWagesAmt_09	= provider[0].BE_WAGES_AMT_09;
										var beWagesAmt_10	= provider[0].BE_WAGES_AMT_10;
										var beWagesAmt_11	= provider[0].BE_WAGES_AMT_11;
										var beWagesAmt_12	= provider[0].BE_WAGES_AMT_12;
										var beWagesAmt_13   = provider[0].BE_WAGES_AMT_13;

										var wagesAmt_01		= provider[0].BE_WAGES_AMT_01;
										var wagesAmt_02		= provider[0].BE_WAGES_AMT_02;
										var wagesAmt_03		= provider[0].BE_WAGES_AMT_03;
										var wagesAmt_04		= provider[0].BE_WAGES_AMT_04;
										var wagesAmt_05		= provider[0].BE_WAGES_AMT_05;
										var wagesAmt_06		= provider[0].BE_WAGES_AMT_06;
										var wagesAmt_07		= provider[0].BE_WAGES_AMT_07;
										var wagesAmt_08		= provider[0].BE_WAGES_AMT_08;
										var wagesAmt_09		= provider[0].BE_WAGES_AMT_09;
										var wagesAmt_10		= provider[0].BE_WAGES_AMT_10;
										var wagesAmt_11		= provider[0].BE_WAGES_AMT_11;
										var wagesAmt_12		= provider[0].BE_WAGES_AMT_12;
										var wagesAmt_13     = provider[0].BE_WAGES_AMT_13;

									} else {
										var beWagesAmt_01	= 0;
										var beWagesAmt_02	= 0;
										var beWagesAmt_03	= 0;
										var beWagesAmt_04	= 0;
										var beWagesAmt_05	= 0;
										var beWagesAmt_06	= 0;
										var beWagesAmt_07	= 0;
										var beWagesAmt_08	= 0;
										var beWagesAmt_09	= 0;
										var beWagesAmt_10	= 0;
										var beWagesAmt_11	= 0;
										var beWagesAmt_12	= 0;
										var beWagesAmt_13   = 0;

										var wagesAmt_01		= 0;
										var wagesAmt_02		= 0;
										var wagesAmt_03		= 0;
										var wagesAmt_04		= 0;
										var wagesAmt_05		= 0;
										var wagesAmt_06		= 0;
										var wagesAmt_07		= 0;
										var wagesAmt_08		= 0;
										var wagesAmt_09		= 0;
										var wagesAmt_10		= 0;
										var wagesAmt_11		= 0;
										var wagesAmt_12		= 0;
										var wagesAmt_13     = 0;
									}


									var r = {
										COMP_CODE		: UserInfo.compCode,
										ANNOUNCE_DATE	: UniDate.getDbDateStr(dataForm.getValue('ANNOUNCE_DATE')),
										ANNOUNCE_CODE	: dataForm.getValue('ANNOUNCE_CODE'),
										ANNOUNCE_REASON	: dataForm.getValue('ANNOUNCE_REASON'),
										APPLY_YEAR : dataForm.getValue('APPLY_YEAR'),
										APPLY_YN		: 'N',

										RETR_RESN   : dataForm.getValue('RETR_RESN'), //퇴사사유


										DEPT_NAME		: record.get('DEPT_NAME'),
										DEPT_CODE		: record.get('DEPT_CODE'),
										PERSON_NUMB		: record.get('PERSON_NUMB'),
										NAME			: record.get('NAME'),
//										BE_DIV_CODE		: record.get('BE_DIV_CODE'),
										BE_DIV_CODE		: record.get('DIV_CODE'),
										BE_DEPT_CODE	: record.get('DEPT_CODE'),
										BE_DEPT_NAME	: record.get('DEPT_NAME'),
//										AF_DIV_CODE		: record.get('AF_DIV_CODE'),
										AF_DIV_CODE		: record.get('DIV_CODE'),
										AF_DEPT_CODE	: record.get('DEPT_CODE'),
										AF_DEPT_NAME	: record.get('DEPT_NAME'),
										POST_CODE		: record.get('POST_CODE'),
										ABIL_CODE		: record.get('ABIL_CODE'),
										PAY_GRADE_01	: record.get('PAY_GRADE_01'),
										PAY_GRADE_01_NAME  : record.get('PAY_GRADE_01_NAME'),
										PAY_GRADE_02	: record.get('PAY_GRADE_02'),
										PAY_GRADE_03	: record.get('PAY_GRADE_03'),
										PAY_GRADE_04	: record.get('PAY_GRADE_04'),
										PAY_GRADE_05    : record.get('PAY_GRADE_05'),
										AF_PAY_GRADE_01	: record.get('PAY_GRADE_01'),
										AF_PAY_GRADE_01_NAME  : record.get('PAY_GRADE_01_NAME'),
										AF_PAY_GRADE_02	: record.get('PAY_GRADE_02'),
										AF_PAY_GRADE_03	: record.get('PAY_GRADE_03'),
										AF_PAY_GRADE_04	: record.get('PAY_GRADE_04'),
										AF_PAY_GRADE_05 : record.get('PAY_GRADE_05'),

										BE_WAGES_AMT_01	: beWagesAmt_01,
										BE_WAGES_AMT_02	: beWagesAmt_02,
										BE_WAGES_AMT_03	: beWagesAmt_03,
										BE_WAGES_AMT_04	: beWagesAmt_04,
										BE_WAGES_AMT_05	: beWagesAmt_05,
										BE_WAGES_AMT_06	: beWagesAmt_06,
										BE_WAGES_AMT_07	: beWagesAmt_07,
										BE_WAGES_AMT_08	: beWagesAmt_08,
										BE_WAGES_AMT_09	: beWagesAmt_09,
										BE_WAGES_AMT_10	: beWagesAmt_10,
										BE_WAGES_AMT_11	: beWagesAmt_11,
										BE_WAGES_AMT_12	: beWagesAmt_12,
										BE_WAGES_AMT_13 : beWagesAmt_13,

										WAGES_AMT_01	: wagesAmt_01,
										WAGES_AMT_02	: wagesAmt_02,
										WAGES_AMT_03	: wagesAmt_03,
										WAGES_AMT_04	: wagesAmt_04,
										WAGES_AMT_05	: wagesAmt_05,
										WAGES_AMT_06	: wagesAmt_06,
										WAGES_AMT_07	: wagesAmt_07,
										WAGES_AMT_08	: wagesAmt_08,
										WAGES_AMT_09	: wagesAmt_09,
										WAGES_AMT_10	: wagesAmt_10,
										WAGES_AMT_11	: wagesAmt_11,
										WAGES_AMT_12	: wagesAmt_12,
										WAGES_AMT_13    : wagesAmt_13
									};


									masterGrid.createRow(r, null, masterGrid.getStore().getCount()-1);
								})
			                });
							UniAppManager.setToolbarButtons('reset', true);
						}
					})

				],
				tbar:  ['->',{
						itemId	: 'searchtBtn',
						text	: '조회',
						handler	: function() {
							var form = batchEmployWin.down('#search');
							var store = Ext.data.StoreManager.lookup('creditStore')
							batchEmployeeStore.loadStoreRecords();
						},
						disabled: false
					},
					 {
						itemId	: 'submitBtn',
						text	: '확인',
						handler	: function() {
							batchEmployWin.down('#grid').returnData()
							batchEmployWin.hide();
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '닫기',
						handler	: function() {
							batchEmployWin.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						batchEmployWin.down('#search').clearForm();
						batchEmployWin.down('#grid').reset();
						batchEmployeeStore.clearData();
					},
					beforeclose: function( panel, eOpts )	{
						batchEmployWin.down('#search').clearForm();
						batchEmployWin.down('#grid').reset();
						batchEmployeeStore.clearData();
					},
					show: function( panel, eOpts )	{
						var form = batchEmployWin.down('#search');
						form.clearForm();
						form.setValue('GRADE_FLAG', gsGradeFlag);
                        form.setValue('BASE_DT', UniDate.get('today'));
						Ext.data.StoreManager.lookup('batchEmployeeStore').loadStoreRecords();
					}
				}
			});
		}
		batchEmployWin.center();
		batchEmployWin.show();
		return batchEmployWin;
	}




	//급호봉 / 지급수당 / 기술수당 팝업
	function wageCodePopup()	{
		if(!payGrdWin) {
			//Model 정의
			var winfields = [
				{name: 'PAY_GRADE_01' 		,text:'급' 					,type:'string'	},
				{name: 'PAY_GRADE_01_NAME'  ,text:'급'                  ,type:'string'  },
				{name: 'PAY_GRADE_02' 		,text:'호' 					,type:'string'	}
			];
			Ext.each(wageStd, function(stdCode, idx) {
				winfields.push({name: 'CODE'+stdCode.WAGES_CODE 	,text:stdCode.WAGES_NAME+'코드' 		,type:'string'	});
				winfields.push({name: 'STD'+stdCode.WAGES_CODE 		,text:stdCode.WAGES_NAME 			,type:'uniPrice'});
			})
			Unilite.defineModel('WagesCodeModel', {
				fields: winfields
			});

			//Proxy 생성
			var wagesCodeDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
				api: {
					read : 'hum105ukrService.fnHum100P2'
				}
			});

			//Store 생성
			var wageCodeStore = Unilite.createStore('wageCodeStore', {
				model	: 'WagesCodeModel' ,
				uniOpt	: {
					isMaster	: false,			// 상위 버튼 연결
					editable	: false,			// 수정 모드 사용
					deletable	: false,			// 삭제 가능 여부
					useNavi		: false				// prev | newxt 버튼 사용
				},
				proxy	: wagesCodeDirctProxy,
				loadStoreRecords : function()	{
					var param= payGrdWin.down('#search').getValues();
					param.PAY_GRADE_YYYY = Ext.Date.format(dataForm.getValue('ANNOUNCE_DATE'), 'Y');
					
					if(Ext.isEmpty(param.PAY_GRADE_YYYY)) {
						param.PAY_GRADE_YYYY = gsPayGradeYyyy;
					}
					
					this.load({
						params: param
					});
				}
			});

			//Grid 생성
			var wageColumns = [
				{ dataIndex: 'PAY_GRADE_01' 			,width: 40  },
				{ dataIndex: 'PAY_GRADE_01_NAME'        ,width: 80  },
				{ dataIndex: 'PAY_GRADE_02' 			,width: 40  }
			];
			Ext.each(wageStd, function(stdCode, idx) {
				wageColumns.push({dataIndex: 'CODE'+stdCode.WAGES_CODE 		,width: 50 	, hidden:true});
				wageColumns.push({dataIndex: 'STD'+stdCode.WAGES_CODE 		,width: 100  });
			});


			//OPEN할 팝업(Window) 생성
			payGrdWin = Ext.create('widget.uniDetailWindow', {
				title	: '급호봉조회POPUP',
				width	: 400,
				height	: 400,
				layout	: {type:'vbox', align:'stretch'},
				items	: [{
						itemId	: 'search',
						xtype	: 'uniSearchForm',
						layout	: {type:'uniTable',columns:2},
						items	: [{
							fieldLabel	: '급',
							name		: 'PAY_GRADE_01',
							labelWidth	: 60,
							width		: 160
						},{

							fieldLabel	: '호',
							name		: 'PAY_GRADE_02',
							labelWidth	: 60,
							width		: 160
						},{

							fieldLabel	: '구분',
							name		: 'GRADE_FLAG',
							labelWidth	: 60,
							width		: 160,
							hidden		: true
						}]
						},
					Unilite.createGrid('payGrd', {
						store	: wageCodeStore,
						itemId	: 'grid',
						layout	: 'fit',
						selModel: 'rowmodel',
						uniOpt	: {
							expandLastColumn	: false,
							useRowNumberer		: false,
							onLoadSelectFirst	: true,
							userToolbar			: false
						},
						columns	: wageColumns,
						listeners: {
						  		onGridDblClick:function(grid, record, cellIndex, colName) {
				  					grid.ownerGrid.returnData();
				  					payGrdWin.hide();
				  				}
							},
							returnData: function()	{
								var record = this.getSelectedRecord();
								if (gsGridOrPanel == '01') {
									if (gsGradeFlag == '03') {
										dataForm.setValue('PAY_GRADE_03', record.get("PAY_GRADE_02"));
//                                        dataForm.setValue('WAGES_STD_I', record.get("WAGES_STD_I"));

									} else if (gsGradeFlag == '04') {
										dataForm.setValue('PAY_GRADE_04', record.get("PAY_GRADE_02"));
//                                        dataForm.setValue('WAGES_STD_I', record.get("WAGES_STD_I"));

									} else if (gsGradeFlag == '05') {
                                        dataForm.setValue('PAY_GRADE_05', record.get("PAY_GRADE_02"));
//                                        dataForm.setValue('WAGES_STD_I', record.get("WAGES_STD_I"));

                                    } else {
										dataForm.setValue('PAY_GRADE_01', record.get("PAY_GRADE_01"));
										dataForm.setValue('PAY_GRADE_01_NAME', record.get("PAY_GRADE_01_NAME"));
										dataForm.setValue('PAY_GRADE_02', record.get("PAY_GRADE_02"));
                                        dataForm.setValue('WAGES_STD_I', record.get("STD100"));
									}
								} else {
									var grdRecord = masterGrid.uniOpt.currentRecord;

									var payGrad01 = '';
                                    var amt00 = 0.0;
                                    var amt01 = 0;             //기본급
                                    var amt02 = 0;             //시간외수당
                                    var amt04 = 0;             //기술수당
                                    var amt06 = 0;             //생산장려
                                    var amt07 = 0;             //반장수당

									if (gsGradeFlag == '03') {
										grdRecord.set('AF_PAY_GRADE_03', record.get("PAY_GRADE_02"));
										grdRecord.set('WAGES_AMT_03', record.get("STD110"));			//직책수당
                                        grdRecord.set('WAGES_STD_I', record.get("WAGES_STD_I"));
                                        if (grdRecord.get('AF_POST_CODE') == '57'){
                                            grdRecord.set('WAGES_AMT_07', 50000)
                                        } else {
                                        	grdRecord.set('WAGES_AMT_07', 0)
                                        }
									} else if (gsGradeFlag == '04') {
										grdRecord.set('AF_PAY_GRADE_04', record.get("PAY_GRADE_02"));
										grdRecord.set('WAGES_AMT_04', record.get("STD120"));			//기술수당
                                        grdRecord.set('WAGES_STD_I', record.get("WAGES_STD_I"));
                                        if (grdRecord.get('AF_POST_CODE') == '57'){
                                            grdRecord.set('WAGES_AMT_07', 50000)
                                        } else {
                                            grdRecord.set('WAGES_AMT_07', 0)
                                        }
									} else if (gsGradeFlag == '05') {
                                        grdRecord.set('AF_PAY_GRADE_05', record.get("PAY_GRADE_02"));
                                        grdRecord.set('WAGES_AMT_13', record.get("STD110"));            //기술수당

                                    } else {
										grdRecord.set('AF_PAY_GRADE_01', record.get("PAY_GRADE_01"));
										grdRecord.set('AF_PAY_GRADE_01_NAME', record.get("PAY_GRADE_01_NAME"));
										grdRecord.set('AF_PAY_GRADE_02', record.get("PAY_GRADE_02"));
                                        grdRecord.set('WAGES_STD_I', record.get("STD100"));
                                        if (grdRecord.get('AF_POST_CODE') == '57'){
                                            grdRecord.set('WAGES_AMT_07', 50000)
                                        } else {
                                            grdRecord.set('WAGES_AMT_07', 0)
                                        }
                                        grdRecord.set('WAGES_AMT_06', 80000);

										payGrad01 = grdRecord.get('AF_PAY_GRADE_01');
										var amt02 = 0;
                                        var num = 1.0;
                                        var num2 = 0.1;
                                        var amt01 = grdRecord.get('WAGES_STD_I') * num2.toFixed(1);
                                        amt01 = Math.round(amt01.toFixed(1) * 209) * 10;    //기본급
                                        var wagesStdI = grdRecord.get('WAGES_STD_I') * num.toFixed(1);
                                        var wagesAmt06 = grdRecord.get('WAGES_AMT_06') * num.toFixed(1);
                                        var wagesAmt03 = grdRecord.get('WAGES_AMT_03') * num.toFixed(1);
                                        var wagesAmt07 = grdRecord.get('WAGES_AMT_07') * num.toFixed(1);
                                        var wagesAmt13 = grdRecord.get('WAGES_AMT_13') * num.toFixed(1);

										if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){

											amt02 = ((wagesStdI + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209))+ (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5
                                            grdRecord.set('WAGES_AMT_01'      , amt01)
                                            grdRecord.set('WAGES_AMT_02'      , amt02.toFixed(1));

//											amt01 = record.get("STD100")
//											amt01 = amt01 * 209    //기본급
//
//											amt00 = Math.round(amt01 * 0.1) //마지막 자리 숫자 사사오입을 위해 소수점만듬
//
//                                            amt01 = amt00 * 10
//
//                                            grdRecord.set('WAGES_AMT_01', amt01);
//
//                                            amt01 = grdRecord.get('WAGES_AMT_01');
//                                            amt04 = grdRecord.get('WAGES_AMT_04');
//                                            amt06 = grdRecord.get('WAGES_AMT_06');
//                                            amt07 = grdRecord.get('WAGES_AMT_07');
//
//                                            amt02 = (((amt01 + amt04 + amt06 + amt07) / 209) * 22) * 1.5
//
//                                            grdRecord.set('WAGES_AMT_02', amt02);                           //시간외수당
//
//                                            grdRecord.set('WAGES_AMT_05', record.get("STD130"));            //가족수당

									 	} else {

									 	    grdRecord.set('WAGES_AMT_01', record.get("STD100"));            //기본급
                                            grdRecord.set('WAGES_AMT_02', record.get("STD300"));            //시간외수당
                                            grdRecord.set('WAGES_AMT_05', record.get("STD130"));            //가족수당
									 	}

									}
								}
							}
					})

				],
				tbar:  ['->',{
						itemId	: 'searchtBtn',
						text	: '조회',
						handler	: function() {
							wageCodeStore.loadStoreRecords();
						},
						disabled: false
					},
					 {
						itemId	: 'submitBtn',
						text	: '확인',
						handler	: function() {
							payGrdWin.down('#grid').returnData()
							payGrdWin.hide();
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '닫기',
						handler	: function() {
							payGrdWin.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						payGrdWin.down('#search').clearForm();
						payGrdWin.down('#grid').reset();
						wageCodeStore.clearData();
						
						payGrdWin.down('#search').setValue('PAY_GRADE_01', '');
						payGrdWin.down('#search').setValue('PAY_GRADE_02', '');
					},
					beforeclose: function( panel, eOpts )	{
						payGrdWin.down('#search').clearForm();
						payGrdWin.down('#grid').reset();
						wageCodeStore.clearData();
						
						payGrdWin.down('#search').setValue('PAY_GRADE_01', '');
						payGrdWin.down('#search').setValue('PAY_GRADE_02', '');
					},
					show: function( panel, eOpts )	{
						var form = payGrdWin.down('#search');
						form.clearForm();
						form.setValue('GRADE_FLAG', gsGradeFlag);
						
						if(gsQueryParam != null) {
							form.setValue('PAY_GRADE_01', gsQueryParam.PAY_GRADE_01_NAME);
							form.setValue('PAY_GRADE_02', gsQueryParam.PAY_GRADE_02);
						}
						else {
							form.setValue('PAY_GRADE_01', '');
							form.setValue('PAY_GRADE_02', '');
						}
						
						Ext.data.StoreManager.lookup('wageCodeStore').loadStoreRecords();
					}
				}
			});
		}
		
//		if(queryParams != null) {
//			var form = payGrdWin.down('#search');
//			form.setValue('PAY_GRADE_01', queryParams.PAY_GRADE_01_NAME);
//			form.setValue('PAY_GRADE_02', queryParams.PAY_GRADE_02);
//		}
//		else {
//			var form = payGrdWin.down('#search');
//			form.setValue('PAY_GRADE_01', '');
//			form.setValue('PAY_GRADE_02', '');
//		}
		
		payGrdWin.center();
		payGrdWin.show();
		return payGrdWin;
	}



	//확정된 발령등록 테이블 정보 가져오기
	function fnGetWages(grdRecord, personNumb)	{
		var param = {
			PERSON_NUMB 	: personNumb
		}
		hum201ukrService.getWages(param, function(provider, response)	{
			//var store = Ext.data.StoreManager.lookup(storeId);
			if (!Ext.isEmpty(provider)) {
				grdRecord.set('BE_WAGES_AMT_01'	, provider[0].BE_WAGES_AMT_01);
				grdRecord.set('BE_WAGES_AMT_02'	, provider[0].BE_WAGES_AMT_02);
				grdRecord.set('BE_WAGES_AMT_03'	, provider[0].BE_WAGES_AMT_03);
				grdRecord.set('BE_WAGES_AMT_04'	, provider[0].BE_WAGES_AMT_04);
				grdRecord.set('BE_WAGES_AMT_05'	, provider[0].BE_WAGES_AMT_05);
				grdRecord.set('BE_WAGES_AMT_06'	, provider[0].BE_WAGES_AMT_06);
				grdRecord.set('BE_WAGES_AMT_07'	, provider[0].BE_WAGES_AMT_07);
				grdRecord.set('BE_WAGES_AMT_08'	, provider[0].BE_WAGES_AMT_08);
				grdRecord.set('BE_WAGES_AMT_09'	, provider[0].BE_WAGES_AMT_09);
				grdRecord.set('BE_WAGES_AMT_10'	, provider[0].BE_WAGES_AMT_10);
				grdRecord.set('BE_WAGES_AMT_11'	, provider[0].BE_WAGES_AMT_11);
				grdRecord.set('BE_WAGES_AMT_12'	, provider[0].BE_WAGES_AMT_12);
				grdRecord.set('BE_WAGES_AMT_13' , provider[0].BE_WAGES_AMT_13);

				grdRecord.set('WAGES_AMT_01'	, provider[0].BE_WAGES_AMT_01);
				grdRecord.set('WAGES_AMT_02'	, provider[0].BE_WAGES_AMT_02);
				grdRecord.set('WAGES_AMT_03'	, provider[0].BE_WAGES_AMT_03);
				grdRecord.set('WAGES_AMT_04'	, provider[0].BE_WAGES_AMT_04);
				grdRecord.set('WAGES_AMT_05'	, provider[0].BE_WAGES_AMT_05);
				grdRecord.set('WAGES_AMT_06'	, provider[0].BE_WAGES_AMT_06);
				grdRecord.set('WAGES_AMT_07'	, provider[0].BE_WAGES_AMT_07);
				grdRecord.set('WAGES_AMT_08'	, provider[0].BE_WAGES_AMT_08);
				grdRecord.set('WAGES_AMT_09'	, provider[0].BE_WAGES_AMT_09);
				grdRecord.set('WAGES_AMT_10'	, provider[0].BE_WAGES_AMT_10);
				grdRecord.set('WAGES_AMT_11'	, provider[0].BE_WAGES_AMT_11);
				grdRecord.set('WAGES_AMT_12'	, provider[0].BE_WAGES_AMT_12);
				grdRecord.set('WAGES_AMT_13'    , provider[0].BE_WAGES_AMT_13);

			} else {
				grdRecord.set('BE_WAGES_AMT_01'	, 0);
				grdRecord.set('BE_WAGES_AMT_02'	, 0);
				grdRecord.set('BE_WAGES_AMT_03'	, 0);
				grdRecord.set('BE_WAGES_AMT_04'	, 0);
				grdRecord.set('BE_WAGES_AMT_05'	, 0);
				grdRecord.set('BE_WAGES_AMT_06'	, 0);
				grdRecord.set('BE_WAGES_AMT_07'	, 0);
				grdRecord.set('BE_WAGES_AMT_08'	, 0);
				grdRecord.set('BE_WAGES_AMT_09'	, 0);
				grdRecord.set('BE_WAGES_AMT_10'	, 0);
				grdRecord.set('BE_WAGES_AMT_11'	, 0);
				grdRecord.set('BE_WAGES_AMT_12'	, 0);
				grdRecord.set('BE_WAGES_AMT_13' , 0);

				grdRecord.set('WAGES_AMT_01'	, 0);
				grdRecord.set('WAGES_AMT_02'	, 0);
				grdRecord.set('WAGES_AMT_03'	, 0);
				grdRecord.set('WAGES_AMT_04'	, 0);
				grdRecord.set('WAGES_AMT_05'	, 0);
				grdRecord.set('WAGES_AMT_06'	, 0);
				grdRecord.set('WAGES_AMT_07'	, 0);
				grdRecord.set('WAGES_AMT_08'	, 0);
				grdRecord.set('WAGES_AMT_09'	, 0);
				grdRecord.set('WAGES_AMT_10'	, 0);
				grdRecord.set('WAGES_AMT_11'	, 0);
				grdRecord.set('WAGES_AMT_12'	, 0);
				grdRecord.set('WAGES_AMT_13'    , 0);
			}
		})
	}



	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();								//buttonStore 클리어
		Ext.each(records, function(record, index) {
			record.phantom 		= true;
			record.data.WORK_GB	= buttonFlag;
			buttonStore.insert(index, record);

			if (records.length == index +1) {
				buttonStore.saveStore(buttonFlag);
			}
		});
	}



	Unilite.createValidator('validator01', {
        store: masterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
        console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            if(newValue != oldValue)    {
                switch(fieldName) {

					case "AF_PAY_GRADE_01" :
						gsGridOrPanel	= '02';
						gsGradeFlag		= '01';
						gsQueryParam	= null;
						wageCodePopup();
                        break;
                        
					case "AF_PAY_GRADE_01_NAME" :
	                    gsGridOrPanel   = '02';
	                    gsGradeFlag     = '01';
	                    
	                    gsQueryParam = {
	                    	PAY_GRADE_01_NAME	: newValue,
	                    	PAY_GRADE_02		: record.get('AF_PAY_GRADE_02')
	                    };
	                    wageCodePopup();
                        break;
                        
					case "AF_PAY_GRADE_02" :
						gsGridOrPanel	= '02';
						gsGradeFlag		= '02';
	                    
	                    gsQueryParam = {
	                    	PAY_GRADE_01_NAME	: record.get('AF_PAY_GRADE_01_NAME'),
	                    	PAY_GRADE_02		: newValue
	                    };
	                    wageCodePopup();
                        break;
                        
					case "AF_PAY_GRADE_03" :
						gsGridOrPanel	= '02';
						gsGradeFlag		= '03';
						gsQueryParam	= null;
						wageCodePopup();
                        break;
						
					case "AF_PAY_GRADE_04" :
						gsGridOrPanel	= '02';
						gsGradeFlag		= '04';
						gsQueryParam	= null;
						wageCodePopup();
                        break;
						
                    case "WAGES_AMT_01" :
                        //record.set('TOT_AMT_I', newValue + record.get('SUPPLY_AMT_I'));
//                        var payGrad01 = '';
//                        var amt01 = 0;             //기본급
//                        var amt02 = 0;             //시간외수당
//                        var amt04 = 0;             //기술수당
//                        var amt06 = 0;             //생산장려
//                        var amt07 = 0;             //반장수당
//
//                        payGrad01 = record.get("AF_PAY_GRADE_01");
//
//                        if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
//
//                        	record.set('WAGES_AMT_01', newValue);
//
//                        	amt01 = record.get('WAGES_AMT_01');
//                            amt02 = record.get('WAGES_AMT_02');
//                            amt04 = record.get('WAGES_AMT_04');
//                            amt06 = record.get('WAGES_AMT_06');
//                            amt07 = record.get('WAGES_AMT_07');
//
//                            amt02 = (((amt01 + amt04 + amt06 + amt07) / 209) * 22) * 1.5
//
//                            record.set('WAGES_AMT_02', amt02);
//                        }

                        var payGrad01 = record.get('PAY_GRADE_01');
                        var amt02 = 0;
                        var num = 1.0;
                        var wagesAmt01 = record.get('WAGES_AMT_01') * num.toFixed(1);
                        var wagesAmt06 = record.get('WAGES_AMT_06') * num.toFixed(1);
                        var wagesAmt03 = record.get('WAGES_AMT_03') * num.toFixed(1);
                        var wagesAmt07 = record.get('WAGES_AMT_07') * num.toFixed(1);
                        var wagesAmt13 = record.get('WAGES_AMT_13') * num.toFixed(1);

                        //if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                            amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5

                            record.set('WAGES_AMT_02', amt02.toFixed(1));
                        //}

                        break;

                     case "WAGES_AMT_03" :
                        //record.set('TOT_AMT_I', newValue + record.get('SUPPLY_AMT_I'));
//                        var payGrad01 = '';
//                        var amt01 = 0;             //기본급
//                        var amt02 = 0;             //시간외수당
//                        var amt04 = 0;             //기술수당
//                        var amt06 = 0;             //생산장려
//                        var amt07 = 0;             //반장수당
//
//                        payGrad01 = record.get("AF_PAY_GRADE_01");
//
//                        if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
//
//                          record.set('WAGES_AMT_01', newValue);
//
//                          amt01 = record.get('WAGES_AMT_01');
//                            amt02 = record.get('WAGES_AMT_02');
//                            amt04 = record.get('WAGES_AMT_04');
//                            amt06 = record.get('WAGES_AMT_06');
//                            amt07 = record.get('WAGES_AMT_07');
//
//                            amt02 = (((amt01 + amt04 + amt06 + amt07) / 209) * 22) * 1.5
//
//                            record.set('WAGES_AMT_02', amt02);
//                        }

                        var payGrad01 = record.get('PAY_GRADE_01');
                        var amt02 = 0;
                        var num = 1.0;
                        var wagesAmt01 = record.get('WAGES_AMT_01') * num.toFixed(1);
                        var wagesAmt06 = record.get('WAGES_AMT_06') * num.toFixed(1);
                        var wagesAmt03 = newValue * num.toFixed(1);
                        var wagesAmt07 = record.get('WAGES_AMT_07') * num.toFixed(1);
                        var wagesAmt13 = record.get('WAGES_AMT_13') * num.toFixed(1);

                        //if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                            amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5

                            record.set('WAGES_AMT_02', amt02.toFixed(1));
                        //}

                        break;

//                   case "WAGES_AMT_04" :

//                        var payGrad01 = '';
//                        var amt01 = 0;             //기본급
//                        var amt02 = 0;             //시간외수당
//                        var amt04 = 0;             //기술수당
//                        var amt06 = 0;             //생산장려
//                        var amt07 = 0;             //반장수당
//
//                        payGrad01 = record.get("AF_PAY_GRADE_01");
//
//                        if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
//
//                        	record.set('WAGES_AMT_04', newValue);
//
//                            amt01 = record.get('WAGES_AMT_01');
//                            amt02 = record.get('WAGES_AMT_02');
//                            amt04 = record.get('WAGES_AMT_04');
//                            amt06 = record.get('WAGES_AMT_06');
//                            amt07 = record.get('WAGES_AMT_07');
//
//                            amt02 = (((amt01 + amt04 + amt06 + amt07) / 209) * 22) * 1.5
//
//                            record.set('WAGES_AMT_02', amt02);
//                        }

//                        var payGrad01 = record.get('PAY_GRADE_01');
//                        var amt02 = 0;
//                        var num = 1.0;
//                        var wagesStdI = record.get('WAGES_STD_I') * num.toFixed(1);
//                        var wagesAmt06 = record.get('WAGES_AMT_06') * num.toFixed(1);
//                        var wagesAmt03 = record.get('WAGES_AMT_03') * num.toFixed(1);
//                        var wagesAmt07 = record.get('WAGES_AMT_07') * num.toFixed(1);
//
//                        if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
//                            amt02 = ((wagesStdI + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209))) * 22) * 1.5
//
//                            record.set('WAGES_AMT_02', amt02.toFixed(1));
//                        }
//
//                        break;

                   case "WAGES_AMT_06" :
//                        var payGrad01 = '';
//                        var amt01 = 0;             //기본급
//                        var amt02 = 0;             //시간외수당
//                        var amt04 = 0;             //기술수당
//                        var amt06 = 0;             //생산장려
//                        var amt07 = 0;             //반장수당
//
//                        payGrad01 = record.get("AF_PAY_GRADE_01");
//
//                        if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
//
//                            record.set('WAGES_AMT_06', newValue);
//
//                            amt01 = record.get('WAGES_AMT_01');
//                            amt02 = record.get('WAGES_AMT_02');
//                            amt04 = record.get('WAGES_AMT_04');
//                            amt06 = record.get('WAGES_AMT_06');
//                            amt07 = record.get('WAGES_AMT_07');
//
//                            amt02 = (((amt01 + amt04 + amt06 + amt07) / 209) * 22) * 1.5
//
//                            record.set('WAGES_AMT_02', amt02);
//                        }

                        var payGrad01 = record.get('PAY_GRADE_01');
                        var amt02 = 0;
                        var num = 1.0;
                        var wagesAmt01 = record.get('WAGES_AMT_01') * num.toFixed(1);
                        var wagesAmt06 = newValue * num.toFixed(1);
                        var wagesAmt03 = record.get('WAGES_AMT_03') * num.toFixed(1);
                        var wagesAmt07 = record.get('WAGES_AMT_07') * num.toFixed(1);
                        var wagesAmt13 = record.get('WAGES_AMT_13') * num.toFixed(1);

                        //if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                            amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5

                            record.set('WAGES_AMT_02', amt02.toFixed(1));
                        //}

                        break;

                   case "WAGES_AMT_07" :
//                        var payGrad01 = '';
//                        var amt01 = 0;             //기본급
//                        var amt02 = 0;             //시간외수당
//                        var amt04 = 0;             //기술수당
//                        var amt06 = 0;             //생산장려
//                        var amt07 = 0;             //반장수당
//
//                        payGrad01 = record.get("AF_PAY_GRADE_01");
//
//                        if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
//
//                            record.set('WAGES_AMT_07', newValue);
//
//                            amt01 = record.get('WAGES_AMT_01');
//                            amt02 = record.get('WAGES_AMT_02');
//                            amt04 = record.get('WAGES_AMT_04');
//                            amt06 = record.get('WAGES_AMT_06');
//                            amt07 = record.get('WAGES_AMT_07');
//
//                            amt02 = (((amt01 + amt04 + amt06 + amt07) / 209) * 22) * 1.5
//
//                            record.set('WAGES_AMT_02', amt02);
//                        }

                        var payGrad01 = record.get('PAY_GRADE_01');
                        var amt02 = 0;
                        var num = 1.0;
                        var wagesAmt01 = record.get('WAGES_AMT_01') * num.toFixed(1);
                        var wagesAmt06 = record.get('WAGES_AMT_06') * num.toFixed(1);
                        var wagesAmt03 = record.get('WAGES_AMT_03') * num.toFixed(1);
                        var wagesAmt07 = newValue * num.toFixed(1);
                        var wagesAmt13 = record.get('WAGES_AMT_13') * num.toFixed(1);

                        //if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                            amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5

                            record.set('WAGES_AMT_02', amt02.toFixed(1));
                        //}

                        break;
                        case "WAGES_AMT_13" :
//                        var payGrad01 = '';
//                        var amt01 = 0;             //기본급
//                        var amt02 = 0;             //시간외수당
//                        var amt04 = 0;             //기술수당
//                        var amt06 = 0;             //생산장려
//                        var amt07 = 0;             //반장수당
//
//                        payGrad01 = record.get("AF_PAY_GRADE_01");
//
//                        if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
//
//                            record.set('WAGES_AMT_07', newValue);
//
//                            amt01 = record.get('WAGES_AMT_01');
//                            amt02 = record.get('WAGES_AMT_02');
//                            amt04 = record.get('WAGES_AMT_04');
//                            amt06 = record.get('WAGES_AMT_06');
//                            amt07 = record.get('WAGES_AMT_07');
//
//                            amt02 = (((amt01 + amt04 + amt06 + amt07) / 209) * 22) * 1.5
//
//                            record.set('WAGES_AMT_02', amt02);
//                        }

                        var payGrad01 = record.get('PAY_GRADE_01');
                        var amt02 = 0;
                        var num = 1.0;
                        var wagesAmt01 = record.get('WAGES_AMT_01') * num.toFixed(1);
                        var wagesAmt06 = record.get('WAGES_AMT_06') * num.toFixed(1);
                        var wagesAmt03 = record.get('WAGES_AMT_03') * num.toFixed(1);
                        var wagesAmt07 = record.get('WAGES_AMT_07') * num.toFixed(1);
                        var wagesAmt13 =  newValue * num.toFixed(1);

                        //if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                            amt02 = (((Math.round(wagesAmt01.toFixed(1) / 209)) + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5

                            record.set('WAGES_AMT_02', amt02.toFixed(1));
                        //}

                        break;

                        case "AF_POST_CODE" :
                            record.set('AF_ABIL_CODE', newValue);
                            record.set('WAGES_AMT_07', 50000);
                            var payGrad01 = record.get('PAY_GRADE_01');
                            var amt02 = 0;
                            var num = 1.0;
                            var wagesStdI = record.get('WAGES_STD_I') * num.toFixed(1);
                            var wagesAmt06 = record.get('WAGES_AMT_06') * num.toFixed(1);
                            var wagesAmt03 = record.get('WAGES_AMT_03') * num.toFixed(1);
                            var wagesAmt07 = record.get('WAGES_AMT_07') * num.toFixed(1);
                            var wagesAmt13 = record.get('WAGES_AMT_13') * num.toFixed(1);

                            if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                                amt02 = ((wagesStdI + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5

                                record.set('WAGES_AMT_02', amt02.toFixed(1));
                            }

                        break;

                        case "AF_ABIL_CODE" :
                            record.set('AF_POST_CODE', newValue);
                            record.set('WAGES_AMT_07', 50000);
                            var payGrad01 = record.get('PAY_GRADE_01');
                            var amt02 = 0;
                            var num = 1.0;
                            var wagesStdI = record.get('WAGES_STD_I') * num.toFixed(1);
                            var wagesAmt06 = record.get('WAGES_AMT_06') * num.toFixed(1);
                            var wagesAmt03 = record.get('WAGES_AMT_03') * num.toFixed(1);
                            var wagesAmt07 = record.get('WAGES_AMT_07') * num.toFixed(1);
                            var wagesAmt13 = record.get('WAGES_AMT_13') * num.toFixed(1);

                            if (payGrad01 == '60' || payGrad01 == '65' || payGrad01 == '70' || payGrad01 == '75' || payGrad01 == '80' || payGrad01 == '90' || payGrad01 == '92'){
                                amt02 = ((wagesStdI + (Math.round(wagesAmt06.toFixed(1) / 209)) + (Math.round(wagesAmt03.toFixed(1) / 209)) + (Math.round(wagesAmt07.toFixed(1) / 209)) + (Math.round(wagesAmt13.toFixed(1) / 209))) * 22) * 1.5

                                record.set('WAGES_AMT_02', amt02.toFixed(1));
                            }

                        break;

                        case "AF_PAY_GRADE_05" :

							record.set('WAGES_AMT_13', newValue * 10000);

                        break;

                        case "AF_PAY_CODE" :
							var anCode = record.get('ANNOUNCE_CODE').toString();
							if(anCode == '10') {
								record.set('BE_PAY_CODE', newValue);
							}

                        break;

                }
            }
            return rv;
        }
    });



};
</script>
