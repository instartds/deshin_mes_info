<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat920ukr_kd"	>
	<t:ExtComboStore comboType="BOR120"	pgmId="s_hat920ukr_kd"/> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 							<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 							<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 							<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H156" /> 							<!-- 반영여부 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var payGrdWin;						//급호봉 / 지급수당 / 기술수당 팝업
	var gsGradeFlag		= '';			//급호봉 / 지급수당 / 기술수당 flag
	var wageStd			= ${wageStd};	//급호봉 코드 정보
    var dateFlag		= true;
    var checkCount = 0;
    var gsHumanManager = '${IsManager}';

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_hat920ukr_kdService.selectList',
			update	: 's_hat920ukr_kdService.updateDetail',
			create	: 's_hat920ukr_kdService.insertDetail',
			destroy	: 's_hat920ukr_kdService.deleteDetail',
			syncAll	: 's_hat920ukr_kdService.saveAll'
		}
	});

/* 	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 's_hat920ukr_kdService.runProcedure',
            syncAll	: 's_hat920ukr_kdService.callProcedure'
		}
	});
 */


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_hat920ukr_kdModel1', {
		fields: [
			///////////////////// 중식 //////////////////////////
					{name: 'COMP_CODE'	  		,text:'법인코드'		 	,type:'string' 		},
					{name: 'SEQ'              	,text:'순번'            	,type:'int' 		},
					{name: 'PERSON_NUMB'	 	,text:'사원번호'		 	,type:'string' 		},
					{name: 'NAME'				,text:'사원명'		  	,type:'string' 		},
					{name: 'DEPT_CODE'		   	,text:'부서코드'		 	,type:'string' 		},
					{name: 'DEPT_NAME'		 	,text:'부서명'	  		,type:'string' 		},
					{name: 'WORK_TEAM'			,text:'근무조'			,type:'string' 		},
					{name: 'WORK_TEAM_NAME'		,text:'근무조명'			,type:'string' 		},
					{name: 'DUTY_YYYYMMDD'		,text:'출근일'   		 	,type:'uniDate'		},
					{name: 'DUTY_FR_TIME'		,text:'출근'   		 	,type:'string'		},
					{name: 'MIDDLE_MEAL_CHK'	,text:'중식예정'   	 	,type: 'boolean'	},
					{name: 'DINNER_MEAL_CHK'    ,text:'석식예정'     		,type: 'boolean'  	},
					{name: 'NIGHT_MEAL_CHK'		,text:'야간예정'   		,type: 'boolean' 	},
					{name: 'FOOD_COUPON_NO'		,text:'식권번호'   	 	,type:'string'		}
		]
	});

	/** Model 정의
     * @type
     */
    Unilite.defineModel('s_hat920ukr_kdModel2', {
    	fields: [
    				///////////////////// 석식 //////////////////////////
    				{name: 'COMP_CODE'	  		,text:'법인코드'		 	,type:'string' 		},
    				{name: 'SEQ'                ,text:'순번'          	,type:'int' 		},
    				{name: 'PERSON_NUMB'	    ,text:'사원번호'		 	,type:'string' 		},
    				{name: 'NAME'				,text:'사원명'		 	,type:'string' 		},
    				{name: 'DEPT_CODE'		   	,text:'부서코드'		 	,type:'string' 		},
    				{name: 'DEPT_NAME'		 	,text:'부서명'	     	,type:'string' 		},
    				{name: 'WORK_TEAM'			,text:'근무조'		 	,type:'string' 		},
    				{name: 'WORK_TEAM_NAME'		,text:'근무조명'		 	,type:'string' 		},
    				{name: 'DUTY_YYYYMMDD'		,text:'출근일'   		 	,type:'uniDate' 	},
    				{name: 'DUTY_FR_TIME'		,text:'출근'   		 	,type:'string' 		},
    				{name: 'MIDDLE_MEAL_CHK'	,text:'중식예정'   	 	,type: 'boolean' 	},
    				{name: 'DINNER_MEAL_CHK'    ,text:'석식예정'     	 	,type: 'boolean'  	},
    				{name: 'NIGHT_MEAL_CHK'		,text:'야간예정'   		,type: 'boolean' 	},
    				{name: 'FOOD_COUPON_NO'		,text:'식권번호'   	 	,type:'string' 		}
    			]
    });

    /** Model 정의
     * @type
     */
    Unilite.defineModel('s_hat920ukr_kdModel3', {
    	fields: [
    				///////////////////// 야간 //////////////////////////
    				{name: 'COMP_CODE'	  		,text:'법인코드'		 	,type:'string' 		},
    				{name: 'SEQ'                ,text:'순번'            	,type:'int' 		},
    				{name: 'PERSON_NUMB'	   	,text:'사원번호'		 	,type:'string'		},
    				{name: 'NAME'				,text:'사원명'		   	,type:'string'		},
    				{name: 'DEPT_CODE'		   	,text:'부서코드'		 	,type:'string' 		},
    				{name: 'DEPT_NAME'		 	,text:'부서명'	     	,type:'string' 		},
    				{name: 'WORK_TEAM'			,text:'근무조'			,type:'string' 		},
    				{name: 'WORK_TEAM_NAME'		,text:'근무조명'		 	,type:'string' 		},
    				{name: 'DUTY_YYYYMMDD'		,text:'출근일'   		 	,type:'uniDate' 	},
    				{name: 'DUTY_FR_TIME'		,text:'출근'   		 	,type:'string' 		},
    				{name: 'MIDDLE_MEAL_CHK'	,text:'중식예정'   		,type: 'boolean' 	},
    				{name: 'DINNER_MEAL_CHK'    ,text:'석식예정'     		,type: 'boolean'  	},
    				{name: 'NIGHT_MEAL_CHK'		,text:'야간예정'   		,type: 'boolean' 	},
    				{name: 'FOOD_COUPON_NO'		,text:'식권번호'   	 	,type:'string' 		}
    			]
    });

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_hat920ukr_kdMasterStore1',{
		model		: 's_hat920ukr_kdModel1',
		proxy		: directProxy,
		autoLoad	: false,
		uniOpt 		: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,	    // 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelResult.getValues();
			param.GBN = '1';
			if(gsHumanManager == 'N'){
				param.HUMAN_MANAGER_YN = 'N';
			}else{
				param.HUMAN_MANAGER_YN = 'Y';
			}
			console.log( param );
			this.load({ params : param});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			console.log("toUpdate",toUpdate);

			var rv = true;
			var paramMaster = panelResult.getValues();
			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						//directMasterStore.loadStoreRecords();
					 }
				};
				this.syncAllDirect(config);

			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var viewNormal = masterGrid1.getView();
				if(store.getCount() > 0){
					//("QU1:NI1:NW1:DL1:SV0:DA1:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
					UniAppManager.setToolbarButtons(['reset' ], true);
					UniAppManager.setToolbarButtons(['save', 'print'], false);

					masterGrid1.focus();
				}else{
					//"QU1:NI1:NW1:DL0:SV0:DA0:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
					UniAppManager.setToolbarButtons(['reset'], true);
					UniAppManager.setToolbarButtons(['delete', 'save', 'print'], false);

					panelResult.onLoadSelectText('DUTY_YYYYMMDD');
				}
			}
		}
	});
	/** Store 정의(Service 정의)
     * @type
     */
    var directMasterStore2 = Unilite.createStore('s_hat920ukr_kdMasterStore2',{
        model       : 's_hat920ukr_kdModel2',
        proxy       : directProxy,
        autoLoad    : false,
        uniOpt      : {
            isMaster    : true,         // 상위 버튼 연결
            editable    : true,         // 수정 모드 사용
            deletable   : false,         // 삭제 가능 여부
            useNavi     : false         // prev | newxt 버튼 사용
        },
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            param.GBN = '2';
            if(gsHumanManager == 'N'){
				param.HUMAN_MANAGER_YN = 'N';
			}else{
				param.HUMAN_MANAGER_YN = 'Y';
			}
            console.log( param );
            this.load({ params : param});
        },
        // 수정/추가/삭제된 내용 DB에 적용 하기
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            console.log("toUpdate",toUpdate);

            var rv = true;
            var paramMaster = panelResult.getValues();
            if(inValidRecs.length == 0 )    {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);
                        //directMasterStore.loadStoreRecords();
                     }
                };
                this.syncAllDirect(config);

            }else {
                masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var viewNormal = masterGrid2.getView();
                if(store.getCount() > 0){
                    //("QU1:NI1:NW1:DL1:SV0:DA1:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
                    UniAppManager.setToolbarButtons(['reset' ], true);
                    UniAppManager.setToolbarButtons(['save', 'print'], false);

                    masterGrid2.focus();
                }else{
                    //"QU1:NI1:NW1:DL0:SV0:DA0:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
                    UniAppManager.setToolbarButtons(['reset'], true);
                    UniAppManager.setToolbarButtons(['delete', 'save', 'print'], false);

                    panelResult.onLoadSelectText('DUTY_YYYYMMDD');
                }
            }
        }
    });
    /** Store 정의(Service 정의)
     * @type
     */
    var directMasterStore3 = Unilite.createStore('s_hat920ukr_kdMasterStore3',{
        model       : 's_hat920ukr_kdModel3',
        proxy       : directProxy,
        autoLoad    : false,
        uniOpt      : {
            isMaster    : true,         // 상위 버튼 연결
            editable    : true,         // 수정 모드 사용
            deletable   : false,         // 삭제 가능 여부
            useNavi     : false         // prev | newxt 버튼 사용
        },
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            param.GBN = '3';
            if(gsHumanManager == 'N'){
				param.HUMAN_MANAGER_YN = 'N';
			}else{
				param.HUMAN_MANAGER_YN = 'Y';
			}
            console.log( param );
            this.load({ params : param});
        },
        // 수정/추가/삭제된 내용 DB에 적용 하기
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            console.log("toUpdate",toUpdate);

            var rv = true;
            var paramMaster = panelResult.getValues();
            if(inValidRecs.length == 0 )    {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);
                        //directMasterStore.loadStoreRecords();
                     }
                };
                this.syncAllDirect(config);

            }else {
                masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var viewNormal = masterGrid2.getView();
                if(store.getCount() > 0){
                    //("QU1:NI1:NW1:DL1:SV0:DA1:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
                    UniAppManager.setToolbarButtons(['reset' ], true);
                    UniAppManager.setToolbarButtons(['save', 'print'], false);

                    masterGrid3.focus();
                }else{
                    //"QU1:NI1:NW1:DL0:SV0:DA0:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
                    UniAppManager.setToolbarButtons(['reset'], true);
                    UniAppManager.setToolbarButtons(['delete', 'save', 'print'], false);

                    panelResult.onLoadSelectText('DUTY_YYYYMMDD');
                }
            }
        }
    });



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			multiSelect	: true,
			typeAhead	: false,
			comboType	: 'BOR120',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
	 		fieldLabel: '근태일자',
	 		xtype: 'uniDatefield',
	 		name: 'DUTY_YYYYMMDD',
	 		value: new Date(),
	 		allowBlank:false,
	 		holdable: 'hold',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
    		}
		}, Unilite.popup('DEPT',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,
                autoPopup       : true,
                tdAttrs         : {width: 380},
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {

                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('DEPT_CODE', '');
                        panelResult.setValue('DEPT_NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),{
                fieldLabel: 'TREE_LEVEL',
                name:'TREE_LEVEL',
                xtype: 'uniTextfield',
                hidden: true
            }
            ]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('s_hat920ukr_kdGrid1', {
		store	: directMasterStore1,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: false,
			onLoadSelectFirst	: false,
			dblClickToEdit		: true,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter: {
				useFilter		: false,
				autoCreate		: true
			}
		},
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
           tbar: [{
               itemId : 'estimateBtn',
               id:'PRINT_BTN1',
               iconCls : 'icon-referance'  ,
               text:'출 력',
               handler: function() {
            	  if(masterGrid1.getStore().count() == 0){
            		  alert('출력할 대상이 없습니다.');
            		  return false;
            	  }

            	   if(!panelResult.getInvalidMessage()) return;
             		 var param= panelResult.getValues();
             		 param.GBN = '1';
                     //	param.OPT_PRINT_GB = panelResult.getValue('optPrintGb').optPrintGb;
                         var win = Ext.create('widget.CrystalReport', {
                             url: CPATH+'/z_kd/s_hat920rkrv_kd.do',
                             prgID: 's_hat920rkrv_kd',
                             extParam: param
                         });
                         win.center();
                         win.show();

               }
           },{
               itemId : 'button',
               id:'btnAllSelect',
               text:'전체선택',
               handler: function() {
                    var records = directMasterStore1.data.items;
                        if(records.length < 1) return false;
                        var bChecked = true;
                        Ext.each(records, function(record, i){
                                record.set('MIDDLE_MEAL_CHK', bChecked);
                                if(bChecked) checkCount++;
                        })
               }
           }],
		columns:	[
			{ dataIndex: 'COMP_CODE'					, width: 100	, hidden: true},
			{ dataIndex: 'SEQ'                      , width: 50    , hidden: true, align: 'center'},
			{ dataIndex: 'PERSON_NUMB'					, width: 88, align: 'center'},
			{ dataIndex: 'NAME'							, width: 100},
			{ dataIndex: 'DEPT_CODE'					, width: 88 , hidden: true},
			{ dataIndex: 'DEPT_NAME'					, width: 160},
			{ dataIndex: 'WORK_TEAM' 					, width: 88, hidden: true},
			{ dataIndex: 'WORK_TEAM_NAME'					, width: 120},
			{ dataIndex: 'DUTY_YYYYMMDD'    		, width: 80, align: 'center'},
			{ dataIndex: 'DUTY_FR_TIME'    		, width: 80, align: 'center'},
			{ dataIndex: 'MIDDLE_MEAL_CHK'	, width: 80, xtype: 'checkcolumn', align: 'center'},
			{ dataIndex: 'DINNER_MEAL_CHK'    , width: 80, xtype: 'checkcolumn', align: 'center', hidden: true},
			{ dataIndex: 'NIGHT_MEAL_CHK'	, width: 80, xtype: 'checkcolumn', align: 'center', hidden: true},
			{ dataIndex: 'FOOD_COUPON_NO'                       , width: 80, align: 'center'}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				/*   if (e.record.data.APPLY_YN == 'Y') {
	                    alert('이미 반영된 데이터는 수정할 수 없습니다.');
	                    return false;

	                } */
				   if(UniUtils.indexOf(e.field, ['MIDDLE_MEAL_CHK' ])) {
						return true;		// 수정가능
					}
					else
					{
						return false;		// 수정불가
					}
			}

		}
	});

	/** Master Grid2 정의(Grid Panel)
     * @type
     */
    var masterGrid2 = Unilite.createGrid('s_hat920ukr_kdGrid2', {
        store   : directMasterStore2,
        region  : 'center',
        layout  : 'fit',
        uniOpt  : {
            useMultipleSorting  : true,
            useLiveSearch       : false,
            onLoadSelectFirst   : false,
            dblClickToEdit      : true,
            useGroupSummary     : true,
            useContextMenu      : false,
            useRowNumberer      : true,
            expandLastColumn    : true,
            useRowContext       : false,
            filter: {
                useFilter       : false,
                autoCreate      : true
            }
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id : 'masterGridTotal',    ftype: 'uniSummary',      showSummaryRow: false} ],
        tbar: [{
                        itemId : 'estimateBtn',
                        id:'PRINT_BTN2',
                        iconCls : 'icon-referance'  ,
                        text:'출 력',
                        handler: function() {
                      	  if(masterGrid1.getStore().count() == 0){
                    		  alert('출력할 대상이 없습니다.');
                    		  return false;
                    	  }

                    	   if(!panelResult.getInvalidMessage()) return;
                     		 var param= panelResult.getValues();
                     		 param.GBN = '2';
                             //	param.OPT_PRINT_GB = panelResult.getValue('optPrintGb').optPrintGb;
                                 var win = Ext.create('widget.CrystalReport', {
                                     url: CPATH+'/z_kd/s_hat920rkrv_kd.do',
                                     prgID: 's_hat920rkrv_kd',
                                     extParam: param
                                 });
                                 win.center();
                                 win.show();
                       }

          },{
               itemId : 'button',
               id:'btnAllSelect2',
               text:'전체선택',
               handler: function() {
                    var records = directMasterStore2.data.items;
                        if(records.length < 1) return false;
                        var bChecked = true;
                        Ext.each(records, function(record, i){
                                record.set('DINNER_MEAL_CHK', bChecked);
                                if(bChecked) checkCount++;
                        })
               }
           }],
        columns:	[
			{ dataIndex: 'COMP_CODE'					, width: 100	, hidden: true},
			{ dataIndex: 'SEQ'                      , width: 50    , hidden: true, align: 'center'},
			{ dataIndex: 'PERSON_NUMB'					, width: 88, align: 'center'},
			{ dataIndex: 'NAME'							, width: 100},
			{ dataIndex: 'DEPT_CODE'					, width: 88 , hidden: true},
			{ dataIndex: 'DEPT_NAME'					, width: 160},
			{ dataIndex: 'WORK_TEAM' 					, width: 88, hidden: true},
			{ dataIndex: 'WORK_TEAM_NAME'					, width: 120},
			{ dataIndex: 'DUTY_YYYYMMDD'    		, width: 80},
			{ dataIndex: 'DUTY_FR_TIME'    		, width: 80, align: 'center'},
			{ dataIndex: 'MIDDLE_MEAL_CHK'	, width: 80, xtype: 'checkcolumn', align: 'center', hidden: true},
			{ dataIndex: 'DINNER_MEAL_CHK'    , width: 80, xtype: 'checkcolumn', align: 'center'},
			{ dataIndex: 'NIGHT_MEAL_CHK'	, width: 80, xtype: 'checkcolumn', align: 'center', hidden: true},
			{ dataIndex: 'FOOD_COUPON_NO'                       , width: 80, align: 'center'}
		],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {

                if(UniUtils.indexOf(e.field, ['DINNER_MEAL_CHK' ])) {
					return true;		// 수정가능
				}
				else
				{
					return false;		// 수정불가
				}
            }
        }
    });

    /** Master Grid3 정의(Grid Panel)
     * @type
     */
    var masterGrid3 = Unilite.createGrid('s_hat920ukr_kdGrid3', {
        store   : directMasterStore3,
        region  : 'center',
        layout  : 'fit',
        uniOpt  : {
            useMultipleSorting  : true,
            useLiveSearch       : false,
            onLoadSelectFirst   : false,
            dblClickToEdit      : true,
            useGroupSummary     : true,
            useContextMenu      : false,
            useRowNumberer      : true,
            expandLastColumn    : true,
            useRowContext       : false,
            filter: {
                useFilter       : false,
                autoCreate      : true
            }
        },
        tbar: [{
            itemId : 'estimateBtn',
            id:'PRINT_BTN3',
            iconCls : 'icon-referance'  ,
            text:'출 력',
            handler: function() {
          	  if(masterGrid1.getStore().count() == 0){
        		  alert('출력할 대상이 없습니다.');
        		  return false;
        	  }

        	   if(!panelResult.getInvalidMessage()) return;
         		 var param= panelResult.getValues();
         		 param.GBN = '3';
                 //	param.OPT_PRINT_GB = panelResult.getValue('optPrintGb').optPrintGb;
                     var win = Ext.create('widget.CrystalReport', {
                         url: CPATH+'/z_kd/s_hat920rkrv_kd.do',
                         prgID: 's_hat920rkrv_kd',
                         extParam: param
                     });
                     win.center();
                     win.show();
            }
        },{
               itemId : 'button',
               id:'btnAllSelect3',
               text:'전체선택',
               handler: function() {
                    var records = directMasterStore3.data.items;
                        if(records.length < 1) return false;
                        var bChecked = true;
                        Ext.each(records, function(record, i){
                                record.set('NIGHT_MEAL_CHK', bChecked);
                                if(bChecked) checkCount++;
                        })
               }
        }],
        columns:	[
			{ dataIndex: 'COMP_CODE'					, width: 100	, hidden: true},
			{ dataIndex: 'SEQ'                      , width: 50    , hidden: true, align: 'center'},
			{ dataIndex: 'PERSON_NUMB'					, width: 88, align: 'center'},
			{ dataIndex: 'NAME'							, width: 100},
			{ dataIndex: 'DEPT_CODE'					, width: 88 , hidden: true},
			{ dataIndex: 'DEPT_NAME'					, width: 160},
			{ dataIndex: 'WORK_TEAM' 					, width: 88, hidden: true},
			{ dataIndex: 'WORK_TEAM_NAME'					, width: 120},
			{ dataIndex: 'DUTY_YYYYMMDD'    		, width: 80},
			{ dataIndex: 'DUTY_FR_TIME'    		, width: 80, align: 'center'},
			{ dataIndex: 'MIDDLE_MEAL_CHK'	, width: 80, xtype: 'checkcolumn', align: 'center', hidden:true},
			{ dataIndex: 'DINNER_MEAL_CHK'    , width: 80, xtype: 'checkcolumn', align: 'center', hidden:true},
			{ dataIndex: 'NIGHT_MEAL_CHK'	, width: 80, xtype: 'checkcolumn', align: 'center'},
			{ dataIndex: 'FOOD_COUPON_NO'                       , width: 80, align: 'center'}
		],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {

                if(UniUtils.indexOf(e.field, ['NIGHT_MEAL_CHK' ])) {
					return true;		// 수정가능
				}
				else
				{
					return false;		// 수정불가
				}
            }
        }
    });
	function onPrint(gbn){
		alert(gbn);
	}
	   var tab = Unilite.createTabPanel('s_hat920ukr_kdTab',{
        region      : 'center',
        activeTab   : 0,
        border      : false,
        items       : [{
                title   : '   중 식   ',
                xtype   : 'container',
                itemId  : 's_hat920ukr_kdTab1',
                layout  : {type:'vbox', align:'stretch'},
                items   : [
                    masterGrid1
                ]
            },{
                title   : '   석 식   ',
                xtype   : 'container',
                itemId  : 's_hat920ukr_kdTab2',
                layout  : {type:'vbox', align:'stretch'},
                hidden  : true,
                items:[
                    masterGrid2
                ]
            },{
                title   : '   야 간   ',
                xtype   : 'container',
                itemId  : 's_hat920ukr_kdTab3',
                layout  : {type:'vbox', align:'stretch'},
                hidden  : true,
                items:[
                    masterGrid3
                ]
            }
        ],
        listeners:{
            tabchange: function( tabPanel, newCard, oldCard, eOpts )    {
                if(newCard.getItemId() == 's_hat920ukr_kdTab1') {
                    UniAppManager.app.onQueryButtonDown();
                }else if(newCard.getItemId() == 's_hat920ukr_kdTab2') {
                    UniAppManager.app.onQueryButtonDown();
                }else{
                    UniAppManager.app.onQueryButtonDown();
                }
            }
        }
    })

	Unilite.Main({
		id			: 's_hat920ukr_kdApp',
		borderItems	: [{
		region		: 'center',
		layout		: 'border',
		border		: false,
		items		: [
			   panelResult , tab
		 	]
		}],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset'],true);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DUTY_YYYYMMDD',UniDate.get('today'));
			if(gsHumanManager == 'N')	{
				panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
				panelResult.setValue('DEPT_NAME', UserInfo.deptName);
				panelResult.getField('DEPT_CODE').setReadOnly(true);
				panelResult.getField('DEPT_NAME').setReadOnly(true);
			}
			panelResult.onLoadSelectText('DUTY_YYYYMMDD');
			/* var param = {PERSON_NUMB : UserInfo.personNumb};
			s_hat920ukr_kdService.selectMealPersonId(
					param,
					function(provider, response) {
						if(!Ext.isEmpty(provider)){
							panelResult.setValue('TREE_LEVEL', provider[0].TREE_LEVEL);
							panelResult.setValue('DEPT_CODE', provider[0].DEPT_CODE);
							panelResult.setValue('DEPT_NAME', provider[0].DEPT_NAME);
							panelResult.getField('DEPT_CODE').setReadOnly(true);
							panelResult.getField('DEPT_NAME').setReadOnly(true);
							gsHumanManager = 'N';
						}else{
							gsHumanManager = 'Y';
						}
					}
			); */

		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}

			var activeTab = tab.getActiveTab().getItemId();

			if ( activeTab == 's_hat920ukr_kdTab1'){
			     masterGrid1.getStore().loadStoreRecords();
			}else if( activeTab == 's_hat920ukr_kdTab2'){
			     masterGrid2.getStore().loadStoreRecords();
			}else{
				 masterGrid3.getStore().loadStoreRecords();
			}

			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('newdata', 'delete', false);
		},
		onNewDataButtonDown: function()	{
			var compCode		 = UserInfo.compCode;
			var applyYyyymm		 = UniDate.getDbDateStr(panelResult.getValue('FR_DATE')).substring(0,6);

			var r ={
				COMP_CODE			: compCode,
				APPLY_YYYYMM_STR	: applyYyyymm.substring(0,4) + '.' + applyYyyymm.substring(4,6),
				APPLY_YN			: 'N',
				PERSON_AGE          : 0
				//REG_DATE			: UniDate.getDateStr(new Date())
			};
			var activeTab = tab.getActiveTab().getItemId();

            if ( activeTab == 's_hat920ukr_kdTab1'){
            	 r = { WORK_TYPE : '1' }
			     masterGrid1.createRow(r);
            }else if( activeTab == 's_hat920ukr_kdTab2'){
            	r = { WORK_TYPE : '2' }
            	 masterGrid2.createRow(r);
            }
		},
		onResetButtonDown:function() {
			panelResult.clearForm();
			masterGrid1.getStore().loadData({});
			masterGrid2.getStore().loadData({});

			this.fnInitBinding();
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = tab.getActiveTab().getItemId();

            if ( activeTab == 's_hat920ukr_kdTab1'){
			     directMasterStore1.saveStore(config);
            }else if( activeTab == 's_hat920ukr_kdTab2'){
            	 directMasterStore2.saveStore(config);
            }else{
            	directMasterStore3.saveStore(config);
            }
		}

	});




	//만나이 계산 함수
	function calcAge(birth) {
	    var date = new Date();
	    var year = date.getFullYear();
	    var month = (date.getMonth() + 1);
	    var day = date.getDate();
	    if (month < 10) month = '0' + month;
	    if (day < 10) day = '0' + day;
	    var monthDay = month + day;

	    birth = birth.replace('-', '').replace('-', '');
	    var birthdayy = birth.substr(0, 4);
	    var birthdaymd = birth.substr(4, 4);

	    var age = monthDay < birthdaymd ? year - birthdayy - 1 : year - birthdayy;
	    return age;
	}



	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
				case "BIRTH_DATE" : // 생일

					break;
				case "EXPIRY_DATE":
					break;
			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator02', {
        store   : directMasterStore2,
        grid    : masterGrid2,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;

            switch(fieldName) {
                case "BIRTH_DATE" : // 생일

                    break;
            }
            return rv;
        }
    }); // validator

    Unilite.createValidator('validator03', {
        store   : directMasterStore3,
        grid    : masterGrid3,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;

            switch(fieldName) {
                case "BIRTH_DATE" : // 생일

                    break;
            }
            return rv;
        }
    }); // validator
};

</script>
