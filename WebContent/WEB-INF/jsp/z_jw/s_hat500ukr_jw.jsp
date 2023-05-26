<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat500ukr_jw"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H033" /> <!-- 근무코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 -->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부 -->
    <t:ExtComboStore comboType="AU" comboCode="H002" /> <!-- 일구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var excelWindow;	// 엑셀참조

function appMain() {

	var colData = ${colData};
	console.log(colData);

	var fields = createModelField(colData);
	var columns = createGridColumn(colData);

	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('s_hat500ukr_jwModel', {
		fields: fields
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
//	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
//		api: {
//			create: 's_hat500ukr_jwService.insertList',
//			read: 's_hat500ukr_jwService.selectList',
//			update: 's_hat500ukr_jwService.updateList',
//			destroy: 's_hat500ukr_jwService.deleteList',
//			syncAll: 's_hat500ukr_jwService.saveAll'
//		}
//	});
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 's_hat500ukr_jwService.insertList',
			read: 's_hat500ukr_jwService.selectList',
			update: 's_hat500ukr_jwService.updateList',
			destroy: 's_hat500ukr_jwService.deleteList',
			syncAll: 's_hat500ukr_jwService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_hat500ukr_jwService.select'
		}
	});

//	var directMasterStore = Unilite.createStore('s_hat500ukr_jwMasterStore', {
//		model: 's_hat500ukr_jwModel',
//		uniOpt: {
//			isMaster: true,			// 상위 버튼 연결
//			editable: true,			// 수정 모드 사용
//			deletable: true,			// 삭제 가능 여부
//			useNavi: false			// prev | newxt 버튼 사용
//		},
//		autoLoad: false,
//		proxy: directProxy,
////		proxy: {
////                type: 'direct',
////                api: {
////                    read    : 's_hat500ukr_jwService.select'
////                }
////            },
//		loadStoreRecords: function(){
//			var param= Ext.getCmp('searchForm').getValues();
//			console.log(param);
//			this.load({
//				params: param
//			});
//		},
//        saveStore : function()	{
//			var inValidRecs = this.getInvalidRecords();
//			if(inValidRecs.length == 0 )	{
//				config = {
////					params: [paramMaster],
//					success: function(batch, option) {
//
//					 }
//				};
//				this.syncAllDirect(config);
//			}else {
//				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
//			}
//		},
//		listeners: {
//			load: function() {
//				if (this.getCount() > 0) {
////	              	UniAppManager.setToolbarButtons('delete', true);
//	                } else {
////	              	  	UniAppManager.setToolbarButtons('delete', false);
//	                }
//			}
//		}
//	});



	var directMasterStore1 = Unilite.createStore('s_hat500ukr_jwMasterStore', {
		model: 's_hat500ukr_jwModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
//		proxy: directProxy,
		proxy: {
            type: 'direct',
            api: {
                read    : 's_hat500ukr_jwService.select'
            }
        },
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
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
//				if (this.getCount() > 0) {
////	              	UniAppManager.setToolbarButtons('delete', true);
//                    var dytyDate = directMasterStore1.getAt(0).get('DUTY_DATE');
//                    panelSearch.setValue('DUTY_DATE', dytyDate);
//                    panelResult.setValue('DUTY_DATE', dytyDate);
//
//	                } else {
////	              	  	UniAppManager.setToolbarButtons('delete', false);
//
//	                }
			}
		}
	});


	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{
			title: '기본정보',
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '근태일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'DUTY_DATE_FR',
				endFieldName: 'DUTY_DATE_TO',
				startDate: UniDate.get('today'),
                endDate: UniDate.get('today'),
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                     if(panelResult) {
                         panelResult.setValue('DUTY_DATE_FR', newValue);                       
                     }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                     if(panelResult) {
                         panelResult.setValue('DUTY_DATE_TO', newValue);                           
                     }
                }
			},Unilite.popup('Employee',{
					fieldLabel: '사원',
				  	valueFieldName:'PERSON_NUMB',
				    textFieldName:'NAME',
					validateBlank:false,
					autoPopup:true,
					listeners: {
						/*onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
								panelResult.setValue('NAME', panelSearch.getValue('NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PERSON_NUMB', '');
							panelResult.setValue('NAME', '');
						}*/
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PERSON_NUMB', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);
						}
					}
				}),{
    			fieldLabel: '사업장',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),{
				fieldLabel: '근무조',
				name: 'WORK_TEAM',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H004',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_TEAM', newValue);
					}
				}
			},{
				fieldLabel: '근태구분',
				name: 'DUTY_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H033',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DUTY_CODE', newValue);
					}
				}
			},
			{
                xtype: 'uniRadiogroup',                         
                fieldLabel: '근태유무',
                name: 'ACCOUNT_NAME',
                items: [{
                    boxLabel: '근태', width: 82, name: 'ACCOUNT_NAME', inputValue: '1', checked: true
                }, {
                    boxLabel: '전체', width: 82, name: 'ACCOUNT_NAME', inputValue: ''
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('ACCOUNT_NAME').setValue(newValue);
                    }
                }
            }
//			,{
//			    fieldLabel: ' ',
//			    xtype: 'uniCheckboxgroup',
//			    items: [{
//			    	boxLabel: '이상근태만조회',
//			        name: 'DUTY_CHK_YN',
//			        width: 300,
//			        listeners: {
//						change: function(field, newValue, oldValue, eOpts) {
//							panelResult.setValue('DUTY_CHK_YN', newValue);
//						}
//					}
//				}]
//   			}

		,{
            xtype: 'uniTextfield',
            hidden:true,
            name: 'FILE_ID'                  // CSV UPLOAD 시 반드시 존재해야함.
        },{
            xtype: 'uniTextfield',
            hidden:true,
            name: 'CSV_LOAD_YN'              // CSV UPLOAD 시 반드시 존재해야함.
        },{
            xtype: 'uniTextfield',
            hidden:true,
            name: 'PGM_ID'                   // CSV UPLOAD 시 반드시 존재해야함.
        }]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {


	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '근태일자',
            xtype: 'uniDateRangefield',
            startFieldName: 'DUTY_DATE_FR',
            endFieldName: 'DUTY_DATE_TO',
            startDate: UniDate.get('today'),
            endDate: UniDate.get('today'),
            allowBlank: false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                 if(panelSearch) {
                    panelSearch.setValue('DUTY_DATE_FR', newValue);                       
                 }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                 if(panelSearch) {
                    panelSearch.setValue('DUTY_DATE_TO', newValue);                           
                 }
            }
		},
		Unilite.popup('Employee',{
					fieldLabel: '사원',
				  	valueFieldName:'PERSON_NUMB',
				    textFieldName:'NAME',
					colspan:2,
					validateBlank:false,
					autoPopup:true,
					listeners: {
						/*onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
								panelSearch.setValue('NAME', panelResult.getValue('NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('PERSON_NUMB', '');
							panelSearch.setValue('NAME', '');
						}*/

						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('PERSON_NUMB', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('NAME', newValue);
						}
					}
				}),
			{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			colspan: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),{
			fieldLabel: '근무조',
			name: 'WORK_TEAM',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H004',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_TEAM', newValue);
				}
			}
		},{
				fieldLabel: '근태구분',
				name: 'DUTY_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H033',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DUTY_CODE', newValue);
					}
				}
	    },{
            xtype: 'uniRadiogroup',                         
            fieldLabel: '근태유무',
            name: 'ACCOUNT_NAME',
            items: [{
                boxLabel: '근태', width: 82, name: 'ACCOUNT_NAME', inputValue: '1', checked: true
            }, {
                boxLabel: '전체', width: 82, name: 'ACCOUNT_NAME', inputValue: ''
            }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('ACCOUNT_NAME').setValue(newValue);
                    }
                }
        }
//			,{
//			    fieldLabel: ' ',
//			    xtype: 'uniCheckboxgroup',
//			    items: [{
//			    	boxLabel: '이상근태만조회',
//			        name: 'DUTY_CHK_YN',
//			        width: 300,
//			        listeners: {
//						change: function(field, newValue, oldValue, eOpts) {
//							panelSearch.setValue('DUTY_CHK_YN', newValue);
//						}
//					}
//				}]
//   			}
   			]
    });

//    var dutyCodeStore = Unilite.createStore('s_hat500ukr_jwDutyCodeStore',{
//        proxy: {
//           type: 'direct',
//            api: {
//                read: 's_hat500ukr_jwService.getComboList'
//            }
//        },
//        loadStoreRecords: function() {
//			var param= Ext.getCmp('searchForm').getValues();
//			console.log( param );
//			this.load({
//				params : param/*,
//				callback : function(records,options,success)	{
//					var loadDataStore = comboStore;
//					if(success)	{
//						if(loadDataStore){
//							loadDataStore.loadData(records.items);
//						}
//					}
//				}*/
//			});
//		}/*,
//		gridRoadStoreRecords: function(param, comboStore) {
//			this.load({
//				params : param,
//				callback : function(records,options,success)	{
//					var loadDataStore = comboStore;
//					if(success)	{
//						if(loadDataStore){
//							loadDataStore.loadData(records.items);
//						}
//					}
//				}
//			});
//		}*/
//	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    //에러
    var masterGrid = Unilite.createGrid('s_hat500ukr_jwGrid', {
        layout: 'fit',
        region : 'center',
    	store: directMasterStore1,
        uniOpt:{
        	expandLastColumn: false,
        	useRowNumberer: true,
            useMultipleSorting: true
    	},
    	tbar: [{
        	xtype:'button',
        	text:'출근확정',
        	hidden : true,
        	handler:function()	{
        		if(masterGrid.getSelectedRecords().length > 0 ){
        				alert("명세서출력 레포트는 현재 없습니다.");
		    		}
		    		else{
		    			alert("선택된 자료가 없습니다.");
		    		}
        		}
		},{
        	xtype:'button',
        	text:'퇴근확정',
        	hidden : true,
        	handler:function()	{
        		if(masterGrid.getSelectedRecords().length > 0 ){
        				alert("집계표출력 레포트는 현재 없습니다.");
		    		}
		    		else{
		    			alert("선택된 자료가 없습니다.");
		    		}
        		}
		},{
        	xtype:'button',
        	text:'근태파일 업로드',
        	handler:function()	{
        		openExcelWindow();
        		}
		}
		,{
            xtype:'button',
            text:'데이터 일괄생성',
            handler:function()  {
                if (panelSearch.isValid()) {
                        if(confirm('실행 하시겠습니까?')){
                            runProc();
                        }
                    }
                }
        }],
        selModel : Ext.create("Ext.selection.CheckboxModel", {
            singleSelect : false ,
            checkOnly : false, 
            showHeaderCheckbox :true,
            listeners: {
            }
        }),
        columns: columns,


//          ,

//		   setExcelData: function(record) {
//
//			   var me = this;
//	   			var grdRecord = this.getSelectionModel().getSelection()[0];
//				grdRecord.set('DEPT_NAME'			, record['DEPT_NAME']);
//				grdRecord.set('PERSON_NUMB'			, record['PERSON_NUMB']);
//	   			grdRecord.set('NAME'				, record['NAME']);
//				grdRecord.set('REPRE_NUM'			, record['REPRE_NUM']);
//	   			grdRecord.set('JOIN_DATE'			, record['JOIN_DATE']);
//
//	   			grdRecord.set('RETR_DATE'			, record['RETR_DATE']);
//				grdRecord.set('PAY_YYYYMM'			, record['PAY_YYYYMM']);
//	   			grdRecord.set('SUPP_DATE'			, record['SUPP_DATE']);
//				grdRecord.set('WORK_DAY'			, record['WORK_DAY']);
//	   			grdRecord.set('SUPP_TOTAL_I'		, record['SUPP_TOTAL_I']);
//
//	   			grdRecord.set('REAL_AMOUNT_I'		, record['REAL_AMOUNT_I']);
//	   			grdRecord.set('TAX_EXEMPTION_I'		, record['TAX_EXEMPTION_I']);
//	   			grdRecord.set('IN_TAX_I'			, record['IN_TAX_I']);
//	   			grdRecord.set('LOCAL_TAX_I'			, record['LOCAL_TAX_I']);
//				grdRecord.set('ANU_INSUR_I'			, record['ANU_INSUR_I']);
//	   			grdRecord.set('MED_INSUR_I'			, record['MED_INSUR_I']);
//
//	   			grdRecord.set('HIR_INSUR_I'			, record['HIR_INSUR_I']);
//				grdRecord.set('BUSI_SHARE_I'		, record['BUSI_SHARE_I']);
//	   			grdRecord.set('WORKER_COMPEN_I'		, record['WORKER_COMPEN_I']);
//
//			}
//    	,
        listeners: {
//        	edit: function(editor, e) {
//          		var fieldName = e.field;
//				var num_check = /[0-9]/;
//				var date_check01 = /^(19|20)\d{2}.(0[1-9]|1[012])$/;
//				var date_check02 = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
//				switch (fieldName) {
//				case 'PERSON_NUMB':
//				case 'NAME':
//					fnAmtCal(e.record);
//					fnInSur(e.record,"");
//					break;
//				case 'SUPP_TOTAL_I':
//				case 'WORK_DAY':
//
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					fnAmtCal(e.record);
//					fnInSur(e.record,"");
//					break;
//				case 'TAX_EXEMPTION_I':
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					fnAmtCal(e.record);
//					fnInSur(e.record,"");
//					break;
//				case 'IN_TAX_I':
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					LOCAL_TAX_I = e.record.data.IN_TAX_I * 0.1;
//					e.record.set("LOCAL_TAX_I",LOCAL_TAX_I);
//					fnTaxI(e.record);
//					break;
//				case 'LOCAL_TAX_I':
//				case 'ANU_INSUR_I':
//				case 'MED_INSUR_I':
//				case 'HIR_INSUR_I':
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					fnTaxI(e.record);
//					break;
//				case 'BUSI_SHARE_I':
//				case 'WORKER_COMPEN_I':
//					if (!num_check.test(e.value)) {
//						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
//						e.record.set(fieldName, e.originalValue);
//						return false;
//					}
//					break;
//
//				/*case 'PAY_YYYYMM':
//					if (e.record.data.PAY_YYYYMM != null && e.record.data.PAY_YYYYMM != '' ) {
//						if (!date_check01.test(e.value)) {
//							Ext.Msg.alert('확인', '날짜형식이 잘못되었습니다.');
//							e.record.set(fieldName, e.originalValue);
//							return false;
//						} else {
//							e.record.set('SUPP_DATE', e.record.data.PAY_YYYYMM + '.01');
//							e.record.set('RECE_DATE', e.record.data.PAY_YYYYMM + '.01');
//						}
//					}
//					break;*/
//
//				default:
//					break;
//				}
//          	},
          	beforeedit: function( editor, e, eOpts ) {
//          		if(UniUtils.indexOf(e.field, ['DUTY_DATE'])) {
//					if(e.record.phantom == true) {
//	        			return true;
//	        		}else{
//	        			return false;
//	        		}
//				}
          		if(!e.record.phantom == true) { //신규가 아닐 경우
                    if (UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME']))
                        return false;
                }
          		if(!e.record.phantom == true || e.record.phantom == true) {     // 신규이던 아니던
                    if(UniUtils.indexOf(e.field, ['DUTY_DATE', 'DAY_NAME', 'DEPT_NAME', 'WORK_TEAM', 'DUTY_CHK1_YN'])) {
                        return false;
                    }
          		}

//              if(UniUtils.indexOf(e.field, ['DUTY_DATE', 'DAY_NAME', 'DEPT_NAME', 'WORK_TEAM_NAME'])) {
//                  return false;
//              }
//              else {
//                  return true;
//              }
	        }



         },
         setExcelData: function(record) {    //엑셀 업로드 참조
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('COMP_CODE'         , record['COMP_CODE']);
            grdRecord.set('DUTY_DATE'             , record['DUTY_DATE']);
            grdRecord.set('PERSON_NUMB'             , record['PERSON_NUMB']);
            grdRecord.set('PERSON_NAME'             , record['PERSON_NAME']);
            grdRecord.set('IN_DUTY_TIME'        , record['IN_DUTY_TIME']);
            grdRecord.set('OUT_DUTY_TIME'           , record['OUT_DUTY_TIME']);
            grdRecord.set('DEPT_NAME'           , record['DEPT_NAME']);
            grdRecord.set('POST_NAME'                , record['POST_NAME']);
            grdRecord.set('DUTY_NAME'          , record['DUTY_NAME']);
            grdRecord.set('JO_DUTY_TIME'          , record['JO_DUTY_TIME']);
            grdRecord.set('OVER_DUTY_TIME'         , record['OVER_DUTY_TIME']);
            grdRecord.set('TOT_DUTY_TIME'        , record['TOT_DUTY_TIME']);
            grdRecord.set('APP_DUTY_TIME'         , record['APP_DUTY_TIME']);
            grdRecord.set('DUITY_CHK'         , record['DUITY_CHK']);
         }
    }); //End of var masterGrid = Unilite.createGrid('s_hat500ukr_jwGrid1', {

	Unilite.Main( {
		 borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id: 's_hat500ukr_jwApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DUTY_DATE_FR', UniDate.get('today'));
			panelSearch.setValue('DUTY_DATE_TO', UniDate.get('today'));
			panelResult.setValue('DUTY_DATE_FR', UniDate.get('today'));
			panelResult.setValue('DUTY_DATE_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DUTY_DATE_FR');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			//masterGrid.getStore().loadStoreRecords();
            directMasterStore1.setProxy(directProxy1);
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
//			UniAppManager.setToolbarButtons('reset', true);
//			var detailform = panelSearch.getForm();
//			if (detailform.isValid()) {
//				masterGrid.getStore().loadStoreRecords();
//				panelSearch.getForm().getFields().each(function(field) {
//				      field.setReadOnly(true);
//				});
//				panelResult.getForm().getFields().each(function(field) {
//				      field.setReadOnly(true);
//				});
//				UniAppManager.setToolbarButtons('reset', true);
//			} else {
//				var invalid = panelSearch.getForm().getFields()
//						.filterBy(function(field) {
//							return !field.validate();
//						});
//
//				if (invalid.length > 0) {
//					r = false;
//					var labelText = ''
//
//					if (Ext
//							.isDefined(invalid.items[0]['fieldLabel'])) {
//						var labelText = invalid.items[0]['fieldLabel']
//								+ '은(는)';
//					} else if (Ext
//							.isDefined(invalid.items[0].ownerCt)) {
//						var labelText = invalid.items[0].ownerCt['fieldLabel']
//								+ '은(는)';
//					}
//
//					Ext.Msg.alert('확인', labelText + Msg.sMB083);
//					invalid.items[0].focus();
//				}
//			}
		},
		onNewDataButtonDown: function()	{		// 행추가

			var grdRecord = masterGrid.getSelectedRecord();
			var compCode = UserInfo.compCode;
			var dutyDate = panelSearch.getValue('DUTY_DATE_FR');
			var dayName = panelSearch.getValue('DAY_NAME');

        	var r ={
        		COMP_CODE			: compCode,
        		DUTY_DATE  			: dutyDate
        		//DAY_NAME			: grdRecord.get('DAY_NAME')

        	};
            //param = {'SEQ':seq}
	        masterGrid.createRow(r);
//			if(!this.checkForNewDetail()) return false;
				/**
				 * Master Grid Default 값 설정
				 */

//            var divCode = panelresult.getValue('DIV_CODE');
//            var compCode = UserInfo.compCode;
//            var dutyDate = panelresult.getValue('DUTY_DATE');
//
//            var r = {
//
//				DIV_CODE: divCode,
//				DUTY_DATE : dutyDate,
//				COMP_CODE: compCode
//		    };
//
//		    masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
//			UniAppManager.setToolbarButtons('reset', true);
//
//
//			var selectNode = masterGrid.getSelectionModel().getLastSelected();
//	        var newRecord = masterGrid.createRow( );
//
//	        if(newRecord)	{
//				newRecord.set('DIV_CODE',selectNode.get('DIV_CODE'));
//				newRecord.set('COMP_CODE',selectNode.get('COMP_CODE'));
//				newRecord.set('DUTY_DATE',selectNode.get('DUTY_DATE'));
//
//	        }

		},
		onSaveDataButtonDown : function() {

			directMasterStore1.saveStore();
//			if (masterGrid.getStore().isDirty()) {
//				// 입력데이터 validation
//				if (!checkValidaionGrid(masterGrid.getStore())) {
//					return false;
//				}
//				masterGrid.getStore().saveStore();
////				masterGrid.getStore().sync({
////					success: function(response) {
////						UniAppManager.setToolbarButtons('save', false);
////		            },
////		            failure: function(response) {
////		            	UniAppManager.setToolbarButtons('save', true);
////		            }
////				});
//			}
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();
		},
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            directMasterStore1.loadStoreRecords({});
            this.fnInitBinding();
        }
//		onDeleteDataButtonDown : function()	{
//			var selRow = masterGrid.getSelectionModel().getSelection()[0];
//			if (selRow.phantom === true)	{
//				masterGrid.deleteSelectedRow();
//			} else {
//				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
//					if (btn == 'yes') {
//						masterGrid.deleteSelectedRow();
//						UniAppManager.setToolbarButtons('save', true);
//					}
//				});
//			}
//		},
//		onDeleteAllButtonDown : function() {
//			Ext.Msg.confirm('삭제', '전체 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
//				if (btn == 'yes') {
//					masterGrid.reset();
//					UniAppManager.app.onSaveDataButtonDown();
////					Ext.getCmp('hat420ukrGrid1').getStore().removeAll();
////					Ext.getCmp('hat420ukrGrid1').getStore().sync({
////						success: function(response) {
////							Ext.Msg.alert('확인', '삭제 되었습니다.');
////							UniAppManager.setToolbarButtons('delete', false);
////							UniAppManager.setToolbarButtons('deleteAll', false);
////							UniAppManager.setToolbarButtons('excel', false);
////				           },
////				           failure: function(response) {
////				           }
////			           });
//
//				}
//			});
//		}
	});//End of Unilite.Main( {
	// 엑셀참조
	Unilite.Excel.defineModel('excel.s_hat500ukr_jw.sheet01', {
		fields: [
			{name: 'COMP_CODE'    		, text: '법인코드'				, type: 'string'},
			{name: 'DUTY_DATE'    		, text: '근태일자'				, type: 'string'},
			{name: 'PERSON_NUMB'    	, text: '사원번호'			    , type: 'string'},
			{name: 'PERSON_NAME'    	, text: '사원명'				, type: 'string'},
			{name: 'IN_DUTY_TIME'    	, text: '출근시간'		        , type: 'string'},
			{name: 'OUT_DUTY_TIME'    	, text: '퇴근시간'			    , type: 'string'},
			{name: 'DEPT_NAME'    		, text: '부서명'			    , type: 'string'},
			{name: 'POST_NAME'    		, text: '직급명'			    , type: 'string'},
			{name: 'DUTY_NAME'    		, text: '근태명칭'			    , type: 'string'},
			{name: 'JO_DUTY_TIME'		, text: '조출'				, type: 'string'},
			{name: 'OVER_DUTY_TIME'		, text: '연장'			    , type: 'string'},
			{name: 'TOT_DUTY_TIME'    	, text: '총합'			    , type: 'string'},
			{name: 'APP_DUTY_TIME'    	, text: '인정'			    , type: 'string'},
			{name: 'DUITY_CHK'			, text: '출퇴근시간 이상유무'		, type: 'string'}
		]
	});

		//엑셀업로드 윈도우 생성 함수
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!directMasterStore1.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                directMasterStore1.loadData({});
            }
        }
        /*if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.DIV_CODE       = panelResult.getValue('DIV_CODE');
//          excelWindow.extParam.ISSUE_GUBUN    = Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//          excelWindow.extParam.APPLY_YN       = Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
        }*/
        if(!excelWindow) {
            excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                excelConfigName: 's_hat500ukr_jw',
                width   : 600,
                height  : 400,
                modal   : false,
                extParam: {
                    'PGM_ID'    : 's_hat500ukr_jw'
                    //'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                },
                grids: [{                           //팝업창에서 가져오는 그리드
                        itemId      : 'grid01',
                        title       : '엑셀업로드',
                        useCheckbox : true,
                        model       : 'excel.s_hat500ukr_jw.sheet01',
                        readApi     : 's_hat500ukr_jwService.selectExcelUploadSheet1',
                        columns     : [
                            {dataIndex: 'COMP_CODE'       , width: 93     , hidden: true},
                            {dataIndex: 'DUTY_DATE'       , width: 100},
                            {dataIndex: 'PERSON_NUMB'     , width: 100},
                            {dataIndex: 'PERSON_NAME'     , width: 100},
                            {dataIndex: 'IN_DUTY_TIME'    , width: 100},
                            {dataIndex: 'OUT_DUTY_TIME'   , width: 100},
                            {dataIndex: 'DEPT_NAME'       , width: 100},
                            {dataIndex: 'POST_NAME'       , width: 100},
                            {dataIndex: 'DUTY_NAME'       , width: 100},
                            {dataIndex: 'JO_DUTY_TIME'    , width: 100},
                            {dataIndex: 'OVER_DUTY_TIME'  , width: 100},
                            {dataIndex: 'TOT_DUTY_TIME'   , width: 100},
                            {dataIndex: 'APP_DUTY_TIME'   , width: 100},
                            {dataIndex: 'DUITY_CHK'       , width: 100}
                        ]
                    }
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    },
                    beforeHide: function(){
                                var grid = this.down('#grid01');
                                grid.getSelectionModel().selectAll();
                                var records = grid.getSelectionModel().getSelection();
                                grid.getStore().remove(records);
                    }
                },

                 uploadFile: function() {
                         var me = this,
                         frm = me.down('#uploadForm');
                         frm.submit({
                          params: me.extParam,
                          waitMsg: 'Uploading...',
                          success: function(form, action) {
                          	me.jobID = action.result.jobID;
                            me.readGridData(me.jobID);
                            me.down('tabpanel').setActiveTab(1);
                          	Ext.Msg.alert('Sucess', 'Upload 성공 하였습니다.');
                          	var param   = {
                                    "_EXCEL_JOBID"  : me.jobID
                            };
                          	s_hat500ukr_jwService.selectExcelUploadSheet1(param, function(provider, response){
                          		var duty_Date = response.result;
                          	    panelSearch.setValue('DUTY_DATE_FR', duty_Date);
                          	    panelSearch.setValue('DUTY_DATE_TO', duty_Date);
                                panelResult.setValue('DUTY_DATE_FR', duty_Date);
                                panelResult.setValue('DUTY_DATE_TO', duty_Date);
                                UniAppManager.app.onQueryButtonDown();
                                me.hide();
                          	});
                          	
                          },

                          failure: function(form, action) {
                           Ext.Msg.alert('Failed', 'Upload 실패 하였습니다.');
                          }
                         });
                   },

                //툴바 세팅

                _setToolBar: function() {
                    var me = this;
                    me.tbar = [
                    '->',
                    {
                        xtype   : 'button',
                        text    : '업로드',
                        tooltip : '업로드',
                        width   : 60,
                        handler: function() {
                            me.jobID = null;
                            me.uploadFile();
                            me.hide();

                        }
                    },{
                            xtype: 'tbspacer'
                    },{
                            xtype: 'tbseparator'
                    },{
                            xtype: 'tbspacer'
                    },{
                        xtype: 'button',
                        text : '닫기',
                        tooltip : '닫기',
                        handler: function() {
                            me.hide();
                        }
                    }
                ]}
            });
        }
        excelWindow.center();
        excelWindow.show();
    };




	// 쿼리 조건에 이용하기 위하여 근태년월의 형식을 변경함
	function dateChange(value) {
		if (value == null || value == '') return '';
		var year = value.getFullYear();
		var mon = value.getMonth() + 1;
		var day = value.getDate();
		return year + '' + (mon >= 10 ? mon : '0' + mon) + '' + day;
	}

	//데이터 일괄생성
    function runProc() {
        Ext.getCmp('pageAll').getEl().mask('생성중...');    // mask on
        var param= Ext.getCmp('searchForm').getValues();
        param.RE_TRY = "";

        /*panelSearch.getEl().mask('급여계산 중...','loading-indicator');*/
        s_hat500ukr_jwService.procSP(param, function(provider, response)  {
            console.log("response", response);
            console.log("provider", provider);

            if(!Ext.isEmpty(provider)){
                if(provider.ERROR_CODE == "Y")  {
                    if(confirm('기존 데이터를 삭제하고 \n 새로운 데이터를 생성하시겠습니까?')){
                        reRunProc();
                    }else{

                        Ext.getCmp('pageAll').getEl().unmask();
                    }//급여작업이 완료되었습니다.
                } else if(provider.ERROR_CODE == "") {
                    UniAppManager.app.onQueryButtonDown();

                    Ext.getCmp('pageAll').getEl().unmask();
                }
            }

        });
    }

    //데이터 일괄생성
    function reRunProc() {
        var param= Ext.getCmp('searchForm').getValues();
        param.RE_TRY = "Y";

        s_hat500ukr_jwService.procSP(param, function(provider, response)  {
            console.log("response", response);
            console.log("provider", provider);
            if(!Ext.isEmpty(provider)){
                if(provider.ERROR_CODE == "")  {
                    alert("생성이 완료되었습니다.");

                    UniAppManager.app.onQueryButtonDown();

                    Ext.getCmp('pageAll').getEl().unmask();
                }
            }

        });
    }

 // 모델 필드 생성
	function createModelField(colData) {

		var fields = [
			          	{name: 'DUTY_DATE'			, text: '근무일'			, type: 'uniDate', allowBlank: false},
						{name: 'WEEK_DAY'    		, text: '요일'			, type: 'int', maxLength: 2},
						{name: 'DAY_NAME'    		, text: '요일'			, type: 'string'},
						{name: 'HOLY_TYPE'          , text: '평일/휴일코드'           , type: 'string'},
						{name: 'HOLY_NAME'          , text: '일 구분'           , type: 'string'},
						{name: 'DEPT_CODE'    		, text: '부서코드'			, type: 'string'},
						{name: 'DEPT_NAME'    		, text: '부서명'			, type: 'string'},
						{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string', allowBlank: false, maxLength: 20},
						{name: 'NAME'		   		, text: '성명'			, type: 'string', maxLength: 10},
						{name: 'WORK_TEAM'    		, text: '근무조'			, type: 'string', comboType:'AU', comboCode:'H004'},
						{name: 'WORK_TEAM_NAME'    	, text: '근무조명'			, type: 'string'},
						{name: 'DUTY_CODE'			, text: '근태코드'			, type: 'string', comboType:'AU', comboCode:'H033', maxLength: 20},
						{name: 'DUTY_FR_D'			, text: '일'			    , type: 'uniDate'},
						{name: 'DUTY_FR_H'			, text: '시'			    , type: 'uniNumber', maxLength: 2},
						{name: 'DUTY_FR_M'			, text: '분'			    , type: 'uniNumber', maxLength: 2},
						{name: 'DUTY_TO_D'			, text: '일'			    , type: 'uniDate'},
						{name: 'DUTY_TO_H'    		, text: '시'			    , type: 'uniNumber', maxLength: 2},
						{name: 'DUTY_TO_M'    		, text: '분'			    , type: 'uniNumber', maxLength: 2},
						
						{name: 'DUTY_CHK1_YN'       , text: '조출여부'          , type: 'boolean'},
                        {name: 'DUTY_CHK1_H'        , text: '시'               , type: 'uniNumber', maxLength: 2},
                        {name: 'DUTY_CHK1_M'        , text: '분'               , type: 'uniNumber', maxLength: 2},

                        {name: 'DUTY_CHK2_YN'       , text: '점심연장반영'       , type: 'boolean'},
                        {name: 'DUTY_CHK2_H'        , text: '시'             , type: 'uniNumber', maxLength: 2},
                        {name: 'DUTY_CHK2_M'        , text: '분'             , type: 'uniNumber', maxLength: 2},
                    
                        {name: 'DUTY_CHK3_YN'       , text: '야간식사연장반영'     , type: 'boolean'},
                        {name: 'DUTY_CHK3_H'        , text: '시'             , type: 'uniNumber', maxLength: 2},
                        {name: 'DUTY_CHK3_M'        , text: '분'             , type: 'uniNumber', maxLength: 2},
                        
                        {name: 'DUTY_CHK4_YN'       , text: '지각확정'     , type: 'boolean'},
                        {name: 'LATENESS_H', text:'시', type: 'uniNumber', maxLength: 2},
                        {name: 'LATENESS_M', text:'분', type: 'uniNumber', maxLength: 2}


						];

		Ext.each(colData, function(item, index){
			if(item.SUB_CODE == '10'){	//연장
				fields.push({name: 'OVERTIME_1_H'		, text: '시'			    , type: 'uniNumber', maxLength: 2});//연장
				fields.push({name: 'OVERTIME_1_M'		, text: '분'			    , type: 'uniNumber', maxLength: 2});
//				fields.push({name: 'OVERTIME_2_H'		, text: '시'		        , type: 'uniNumber', maxLength: 2});	//추가연장
//				fields.push({name: 'OVERTIME_2_M'		, text: '분'		        , type: 'uniNumber', maxLength: 2});
//				fields.push({name: 'OVERTIME_3_H'       , text: '시'             , type: 'uniNumber', maxLength: 2});	//야근
//				fields.push({name: 'OVERTIME_3_M'       , text: '분'             , type: 'uniNumber', maxLength: 2});
			}
//			if(item.SUB_CODE == '55'){	//지각
//				fields.push({name: 'LATENESS_H', text:'시', type: 'uniNumber', maxLength: 2});//지각
//				fields.push({name: 'LATENESS_M', text:'분', type: 'uniNumber', maxLength: 2});
////				fields.push({name: 'EARLY_H', text:'일수', type:'string'});//조퇴
////				fields.push({name: 'EARLY_M', text:'일수', type:'string'});
////				fields.push({name: 'OUT_H'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});//외출
////			    fields.push({name: 'OUT_M'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
//			}
//			if(item.SUB_CODE == '09'){//조출
//				fields.push({name: 'DUTY_CHK1_YN'             , text: '조출여부'          , type: 'string'   , comboType:'AU', comboCode:'B010', defaultValue: 'N'});
//				fields.push({name: 'DUTY_CHK1_H'    	      , text: '시'			    , type: 'uniNumber', maxLength: 2});
//			    fields.push({name: 'DUTY_CHK1_M'			  , text: '분'			    , type: 'uniNumber', maxLength: 2});
//			}else if(item.SUB_CODE == '66'){//점심연장반영
//				fields.push({name: 'DUTY_CHK2_YN'             , text: '점심연장반영'       , type: 'string'   , comboType:'AU', comboCode:'B010', defaultValue: 'N'});
//                fields.push({name: 'DUTY_CHK2_H'              , text: '시'             , type: 'uniNumber', maxLength: 2});
//                fields.push({name: 'DUTY_CHK2_M'              , text: '분'             , type: 'uniNumber', maxLength: 2});
//            }else if(item.SUB_CODE == '67'){//야식연장반영
//            	fields.push({name: 'DUTY_CHK3_YN'             , text: '야간식사연장반영'     , type: 'string'   , comboType:'AU', comboCode:'B010', defaultValue: 'N'});
//                fields.push({name: 'DUTY_CHK3_H'              , text: '시'             , type: 'uniNumber', maxLength: 2});
//                fields.push({name: 'DUTY_CHK3_M'              , text: '분'             , type: 'uniNumber', maxLength: 2});
//            }
            else if(item.SUB_CODE == '11'){//심야
				fields.push({name: 'OVERTIME_2_H'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'OVERTIME_2_M'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '12'){//특근
				fields.push({name: 'OVERTIME_3_H'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'OVERTIME_3_M'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '13'){//특근연장
				fields.push({name: 'OVERTIME_4_H'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'OVERTIME_4_M'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '14'){//특심심야
				fields.push({name: 'OVERTIME_5_H'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'OVERTIME_5_M'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}
//			else if(item.SUB_CODE == '15'){//임시
//				fields.push({name: 'H_015'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
//			    fields.push({name: 'M_015'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
//			}
			else if(item.SUB_CODE == '16'){//야간조가산
				fields.push({name: 'OVERTIME_6_H'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'OVERTIME_6_M'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '17'){//야간조심야
				fields.push({name: 'OVERTIME_7_H'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'OVERTIME_7_M'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '20'){//결근
				fields.push({name: 'H_020'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_020'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '21'){//무휴
				fields.push({name: 'H_021'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_021'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '22'){//유휴
				fields.push({name: 'H_022'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_022'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '23'){//출산휴가
				fields.push({name: 'H_023'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_023'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '50'){//연차
				fields.push({name: 'H_050'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_050'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '51'){//반차
				fields.push({name: 'H_051'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_051'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '60'){//출장
				fields.push({name: 'H_060'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_060'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '61'){//공가
				fields.push({name: 'H_061'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_061'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '62'){//병가
				fields.push({name: 'H_062'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_062'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '63'){//훈련
				fields.push({name: 'H_063'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_063'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '64'){//교육
				fields.push({name: 'H_064'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_064'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '65'){//파견
				fields.push({name: 'H_065'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_065'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}else if(item.SUB_CODE == '99'){//이상근태
				fields.push({name: 'H_099'    			, text: '시'			    , type: 'uniNumber', maxLength: 2});
			    fields.push({name: 'M_099'				, text: '분'			    , type: 'uniNumber', maxLength: 2});
			}
			//fields.push({name: 'DUTY_NUM' + item.SUB_CODE, text:'일수', type:'string'});
			//fields.push({name: 'DUTY_TIME' + item.SUB_CODE, text:'시간', type:'string'});
		});
//		fields.push({name: 'HOLY_TYPE'    		, text: '근무조코드'		, type: 'string'});
//		fields.push({name: 'HOLY_NAME'    		, text: '근무조명'			, type: 'string'});
//		fields.push({name: 'CAL_DATE'    		, text: '달력'			, type: 'uniDate'});
//		fields.push({name: 'CAL_NO'    			, text: '주'				, type: 'int', maxLength: 2});
		fields.push({name: 'DIV_CODE'     		, text: '사업장'			, type: 'string', comboType:'BOR120'});
		fields.push({name: 'REMARK'       		, text: '비고'			, type: 'string', maxLength: 150});
		console.log(fields);
// 		alert(fields);
		return fields;
	}

	// 그리드 컬럼 생성
	function createGridColumn(colData) {

		var columns = [
									{dataIndex: 'DUTY_DATE'         	  	, width: 80, locked:true},
									{dataIndex: 'WEEK_DAY'         	  		, width: 66, hidden: true, locked:true},
									{dataIndex: 'DAY_NAME'         	  		, width: 66, locked:true},
									{dataIndex: 'HOLY_TYPE'                  , width: 120, hidden: true, locked:true},
									{dataIndex: 'HOLY_NAME'                  , width: 90, locked:true, hidden: true},
									{dataIndex: 'DEPT_CODE'      			, width: 120, hidden: true, locked:true},
									{dataIndex: 'DEPT_NAME'      			, width: 120, locked:true},
									{dataIndex: 'PERSON_NUMB'       	  	, width: 70,locked:true,
										'editor' : Unilite.popup('Employee_G1',{
											validateBlank : true,
											autoPopup:true,
												listeners: {
													'onSelected': {
									//					fn: function(records, type) {
									//						UniAppManager.app.fnHumanPopUpAu02(records);
									//
									//
									//						var grdRecord = masterGrid.getSelectedRecord();
									//					if(!Ext.isEmpty(grdRecord)){
									//						fnAmtCal(grdRecord);
									//						fnInSur(grdRecord,"");
									//					}
									//					},
													fn: function(records, type) {
															console.log('records : ', records);
															console.log(records);
															var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
															grdRecord.set('DIV_CODE', records[0].DIV_CODE);
															grdRecord.set('DUTY_DATE', panelSearch.getValue('DUTY_DATE_FR'));
															grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
															grdRecord.set('DEPT_CODE', records[0].DEPT_CODE);
															grdRecord.set('NAME', records[0].NAME);
															grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
															//근무조 컬럼에 데이터를 넣음
															var params = {
																S_COMP_CODE: UserInfo.compCode,
																DUTY_DATE: dateChange(panelSearch.getValue('DUTY_DATE_FR')),
																PERSON_NUMB: records[0].PERSON_NUMB
															}
															hat520ukrService.getWorkTeam(params, function(provider, response)	{
																if(!Ext.isEmpty(provider)){
																	grdRecord.set('WORK_TEAM', provider);
																}
															});

									//							Ext.Ajax.request({
									//								url     : CPATH+'/human/getWorkTeam.do',
									//								params: {
									//					   				S_COMP_CODE: UserInfo.compCode,
									//									DUTY_DATE: dateChange(panelSearch.getValue('DUTY_DATE')),
									//									PERSON_NUMB: records[0].PERSON_NUMB
									//								},
									//								method: 'get',
									//								success: function(response){
									//									if (response.responseText.indexOf('fail') == -1) {
									//										var data = JSON.parse(Ext.decode(response.responseText));
									//										console.log(data);
									//										if (data != null) {
									//											grdRecord.set('WORK_TEAM', data);
									//										}
									//									}
									//								},
									//								failure: function(response){ alert('fail');
									//									console.log(response);
									//									grdRecord.set('WORK_TEAM', '');
									//								}
									//							});

														},
														scope: this
													},
													'onClear': function(type) {
														var grdRecord = Ext.getCmp('s_hat500ukr_jwGrid').uniOpt.currentRecord;
														grdRecord.set('PERSON_NUMB','');
														grdRecord.set('NAME','');
														grdRecord.set('DEPT_CODE','');
														grdRecord.set('DEPT_NAME','');
												},
												applyextparam: function(popup){
													popup.setExtParam({'PAY_GUBUN' : '2'});
												}
												}
										})
									},
									{dataIndex: 'NAME'              	  	, width: 70, locked:true,
									'editor' : Unilite.popup('Employee_G1',{
											validateBlank : true,
											autoPopup:true,
												listeners: {
													'onSelected': {
									//              fn: function(records, type) {
									//                  UniAppManager.app.fnHumanPopUpAu02(records);
									//
									//
									//                  var grdRecord = masterGrid.getSelectedRecord();
									//                  if(!Ext.isEmpty(grdRecord)){
									//                      fnAmtCal(grdRecord);
									//                      fnInSur(grdRecord,"");
									//                  }
									//              },
									                fn: function(records, type) {
									                        console.log('records : ', records);
									                        console.log(records);
									                        var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
									                        grdRecord.set('DIV_CODE', records[0].DIV_CODE);
									                        grdRecord.set('DUTY_DATE', panelSearch.getValue('DUTY_DATE_FR'));
									                        grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
									                        grdRecord.set('DEPT_CODE', records[0].DEPT_CODE);
									                        grdRecord.set('NAME', records[0].NAME);
									                        grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
									                        //근무조 컬럼에 데이터를 넣음
									                        var params = {
									                            S_COMP_CODE: UserInfo.compCode,
									                            DUTY_DATE: dateChange(panelSearch.getValue('DUTY_DATE_FR')),
									                            PERSON_NUMB: records[0].PERSON_NUMB
									                        }
									                        hat520ukrService.getWorkTeam(params, function(provider, response)   {
									                            if(!Ext.isEmpty(provider)){
									                                grdRecord.set('WORK_TEAM', provider);
									                            }
									                        });

									//                          Ext.Ajax.request({
									//                              url     : CPATH+'/human/getWorkTeam.do',
									//                              params: {
									//                                  S_COMP_CODE: UserInfo.compCode,
									//                                  DUTY_DATE: dateChange(panelSearch.getValue('DUTY_DATE')),
									//                                  PERSON_NUMB: records[0].PERSON_NUMB
									//                              },
									//                              method: 'get',
									//                              success: function(response){
									//                                  if (response.responseText.indexOf('fail') == -1) {
									//                                      var data = JSON.parse(Ext.decode(response.responseText));
									//                                      console.log(data);
									//                                      if (data != null) {
									//                                          grdRecord.set('WORK_TEAM', data);
									//                                      }
									//                                  }
									//                              },
									//                              failure: function(response){ alert('fail');
									//                                  console.log(response);
									//                                  grdRecord.set('WORK_TEAM', '');
									//                              }
									//                          });

									                    },
									                scope: this
									            },
													'onClear': function(type) {
														var grdRecord = Ext.getCmp('s_hat500ukr_jwGrid').uniOpt.currentRecord;
														grdRecord.set('PERSON_NUMB','');
														grdRecord.set('NAME','');
														grdRecord.set('DEPT_CODE','');
														grdRecord.set('DEPT_NAME','');
												},
												applyextparam: function(popup){
													popup.setExtParam({'PAY_GUBUN' : '2'});
												}
												}
										})
									},
									{dataIndex: 'WORK_TEAM'				, width: 70},
									{dataIndex: 'WORK_TEAM_NAME'		, width: 70, hidden: true},
									{dataIndex: 'DUTY_CODE'				, width: 80},
									{text : '출근',
									    columns : [
									        {dataIndex: 'DUTY_FR_D'				, width: 90},
									        {dataIndex: 'DUTY_FR_H'             , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }},
									        {dataIndex: 'DUTY_FR_M'             , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }}
									    ]
									},
									{text : '퇴근',
									    columns : [
									        {dataIndex: 'DUTY_TO_D'             , width: 90},
									        {dataIndex: 'DUTY_TO_H'             , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }},
									        {dataIndex: 'DUTY_TO_M'             , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }}
									    ]
									},
									{text : '조출',
                                        columns : [
                                            {dataIndex: 'DUTY_CHK1_YN'            , width: 70, xtype: 'checkcolumn',
                                                listeners:{
                                                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
                                                        var grdRecord = masterGrid.getStore().getAt(rowIndex);
                                                        if(checked == true){
                                                            if(grdRecord.get('DUTY_CHK1_YN') == true){
                                                            	if(grdRecord.get('WORK_TEAM') == '2' || grdRecord.get('WORK_TEAM') == '1'){
                                                                	if(grdRecord.get('DUTY_FR_H') < 9 && grdRecord.get('DUTY_FR_H') != 0 ){
                                                                	   if(grdRecord.get('DUTY_FR_M') <= 30 && grdRecord.get('DUTY_FR_M') != 0){
                                                                	   	  grdRecord.set('DUTY_CHK1_M',30);
                                                                	   }
                                                                	   if(grdRecord.get('DUTY_FR_M') > 0){
                                                                	      grdRecord.set('DUTY_CHK1_H',(9 - grdRecord.get('DUTY_FR_H'))-1);
                                                                	   }else{
                                                                	   	  grdRecord.set('DUTY_CHK1_H',9 - grdRecord.get('DUTY_FR_H'));
                                                                	   }
                                                                	   
                                                                	}
                                                            	}
                                                            	if(grdRecord.get('WORK_TEAM') == '3'){
                                                            		if(grdRecord.get('DUTY_FR_H') < 21 && grdRecord.get('DUTY_FR_H') != 0 ){
                                                                       if(grdRecord.get('DUTY_FR_M') <= 30 && grdRecord.get('DUTY_FR_M') != 0){
                                                                          grdRecord.set('DUTY_CHK1_M',30);
                                                                       }
                                                                       if(grdRecord.get('DUTY_FR_M') > 0){
                                                                          grdRecord.set('DUTY_CHK1_H',(21 - grdRecord.get('DUTY_FR_H'))-1);
                                                                       }else{
                                                                          grdRecord.set('DUTY_CHK1_H',21 - grdRecord.get('DUTY_FR_H'));
                                                                       }
                                                                       
                                                                    }
                                                            	}
                                                            	var hour = grdRecord.get('OVERTIME_1_H');
                                                            	if(grdRecord.get('DUTY_CHK1_H') != 0 || grdRecord.get('DUTY_CHK1_M') != 0){
                                                            	    if(grdRecord.get('OVERTIME_1_H') == 0 && grdRecord.get('OVERTIME_1_M') == 0){
                                                            	    	grdRecord.set('OVERTIME_1_H',hour + grdRecord.get('DUTY_CHK1_H'));
                                                            	    	grdRecord.set('OVERTIME_1_M',grdRecord.get('DUTY_CHK1_M'));
                                                            	    }else{
                                                            	    	grdRecord.set('OVERTIME_1_H',hour + grdRecord.get('DUTY_CHK1_H'));
                                                            	    	if(grdRecord.get('OVERTIME_1_M') == 0 ){
                                                                            grdRecord.set('OVERTIME_1_M',grdRecord.get('DUTY_CHK1_M'));
                                                            	    	}else{
                                                            	    		grdRecord.set('OVERTIME_1_M',0);
                                                            	    	}
                                                            	    }
                                                            	}
                                                            }
                                                        }else{
                                                            grdRecord.set('DUTY_CHK1_H',0);
                                                            grdRecord.set('DUTY_CHK1_M',0);
                                                            var hour = grdRecord.get('OVERTIME_1_H');
                                                            if(grdRecord.get('DUTY_CHK1_H') == 0 && grdRecord.get('DUTY_CHK1_M') == 0){
                                                                if(grdRecord.get('OVERTIME_1_M') == 30 && grdRecord.get('OVERTIME_1_H') == 0){
                                                                	grdRecord.set('OVERTIME_1_M', 0);
                                                                }else{
                                                                	if(grdRecord.get('DUTY_CHK1_H') != 0 && grdRecord.get('DUTY_CHK1_M') != 0){
                                                                    	grdRecord.set('OVERTIME_1_H',hour - hour);
                                                                    	grdRecord.set('OVERTIME_1_M', 0);
                                                                	}
                                                                	if(grdRecord.get('OVERTIME_1_H') + grdRecord.get('OVERTIME_1_H') > 0 ){
                                                                		grdRecord.set('OVERTIME_1_H',hour - hour);
                                                                        grdRecord.set('OVERTIME_1_M', 0);
                                                                	}
                                                                }
                                                            }
                                                        }
                                                    }
                                                }},
                                            {dataIndex: 'DUTY_CHK1_H'            , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }},
                                            {dataIndex: 'DUTY_CHK1_M'            , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }}

                                        ]
                                    },
                                    {text : '점심연장',
                                        columns : [
                                            {dataIndex: 'DUTY_CHK2_YN'            , width: 100, xtype: 'checkcolumn',
                                                listeners:{
                                                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
                                                        var grdRecord = masterGrid.getStore().getAt(rowIndex);
                                                        if(checked == true){
                                                            if(grdRecord.get('DUTY_CHK2_YN') == true){
                                                                grdRecord.set('DUTY_CHK2_M',30);
                                                                var hour = grdRecord.get('OVERTIME_1_H');
                                                                if(grdRecord.get('OVERTIME_1_M') == 0){
                                                                    grdRecord.set('OVERTIME_1_M',30);
                                                                }else{
                                                                    grdRecord.set('OVERTIME_1_M',0);
                                                                    if(grdRecord.get('OVERTIME_1_H') == 0){
                                                                      grdRecord.set('OVERTIME_1_H',hour + 1);
                                                                    }else{
                                                                        grdRecord.set('OVERTIME_1_H',hour + 1);
                                                                    }
                                                                }
                                                            }
                                                        }else{
                                                            grdRecord.set('DUTY_CHK2_M',0);
                                                            var hour = grdRecord.get('OVERTIME_1_H');
                                                            if(grdRecord.get('OVERTIME_1_M') == 30){
                                                                grdRecord.set('OVERTIME_1_M', 0);
                                                            }else{
                                                                grdRecord.set('OVERTIME_1_H',hour - 1);
                                                                grdRecord.set('OVERTIME_1_M', 30);
                                                            }
                                                        }
                                                    }
                                                }},
                                            {dataIndex: 'DUTY_CHK2_H'            , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }},
                                            {dataIndex: 'DUTY_CHK2_M'            , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }}
                                        ]
                                    },
                                    {text : '야식반영시간',
                                        columns : [
                                             {dataIndex: 'DUTY_CHK3_YN'            , width: 120, xtype: 'checkcolumn',
                                                listeners:{
                                                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
                                                        var grdRecord = masterGrid.getStore().getAt(rowIndex);
                                                        if(checked == true){
                                                            if(grdRecord.get('DUTY_CHK3_YN') == true){
                                                                grdRecord.set('DUTY_CHK3_M',30);
                                                                var hour = grdRecord.get('OVERTIME_1_H');
                                                                if(grdRecord.get('OVERTIME_1_M') == 0){
                                                                    grdRecord.set('OVERTIME_1_M',30);
                                                                }else{
                                                                    grdRecord.set('OVERTIME_1_M',0);
                                                                    if(grdRecord.get('OVERTIME_1_H') == 0){
                                                                      grdRecord.set('OVERTIME_1_H',hour + 1);
                                                                    }else{
                                                                        grdRecord.set('OVERTIME_1_H',hour + 1);
                                                                    }
                                                                }
                                                            }
                                                        }else{
                                                            grdRecord.set('DUTY_CHK3_M',0);
                                                            var hour = grdRecord.get('OVERTIME_1_H');
                                                            if(grdRecord.get('OVERTIME_1_M') == 30){
                                                                grdRecord.set('OVERTIME_1_M', 0);
                                                            }else{
                                                                grdRecord.set('OVERTIME_1_H',hour - 1);
                                                                grdRecord.set('OVERTIME_1_M', 30);
                                                            }
                                                        }
                                                    }
                                                }},
                                             {dataIndex: 'DUTY_CHK3_H'            , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }},
                                             {dataIndex: 'DUTY_CHK3_M'            , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }}
                                        ]
                                    },
                                    {text : '지각',
                                        columns : [
                                             {dataIndex: 'DUTY_CHK4_YN'           , width: 100, xtype: 'checkcolumn'},
                                             {dataIndex: 'LATENESS_H'            , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }},
                                             {dataIndex: 'LATENESS_M'            , width: 50,
                                              renderer:function(value){
                                                if(value != 0){
                                                    return '<div style="background:orange">'+value+'</div>'
                                                }else{
                                                    return 0;
                                                }
                                              }}
                                        ]
                                    }
                                     
				];


		Ext.each(colData, function(item, index){
			if(item.SUB_CODE == '10'){//연장
				columns.push({text:'연장',
					columns:[
						  {dataIndex: 'OVERTIME_1_H'          , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }},
                           {dataIndex: 'OVERTIME_1_M'         , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }} //, hidden: true}
				]});
//				columns.push({text:'추가연장',
//					columns:[
//						  {dataIndex: 'OVERTIME_2_H'          , width: 70},
//                           {dataIndex: 'OVERTIME_2_M'          , width: 70} //, hidden: true}
//				]});
//				columns.push({text:'야근',
//					columns:[
//						  {dataIndex: 'OVERTIME_3_H'          , width: 70},
//                           {dataIndex: 'OVERTIME_3_M'          , width: 70} //, hidden: true}
//				]});
			}
//			if(item.SUB_CODE == '55'){	//지각
//				columns.push({text:'지각',
//					columns:[
//					         {dataIndex: 'LATENESS_H'            , width: 70},
//	                            {dataIndex: 'LATENESS_M'            , width: 70}
//				]});
//				columns.push({text:'조퇴',
//					columns:[
//					         {dataIndex: 'EARLY_H'               , width: 70},
//	                            {dataIndex: 'EARLY_M'               , width: 70}
//				]});
//				columns.push({text:'외출',
//					columns:[
//					         {dataIndex: 'OUT_H'                 , width: 70},
//	                            {dataIndex: 'OUT_M'                 , width: 70}
//				]});

			//}
//			if(item.SUB_CODE == '09'){//조출
//				columns.push({text:'조출',
//					columns:[
//					         {dataIndex: 'DUTY_CHK1_YN'            , width: 70},
//					         {dataIndex: 'DUTY_CHK1_H'            , width: 70},
//	                         {dataIndex: 'DUTY_CHK1_M'            , width: 70}
//				]});
//			}else if(item.SUB_CODE == '66'){//심야
//                columns.push({text:'점심연장',
//                    columns:[
//                             {dataIndex: 'DUTY_CHK2_YN'            , width: 100},
//                             {dataIndex: 'DUTY_CHK2_H'            , width: 70},
//                             {dataIndex: 'DUTY_CHK2_M'            , width: 70}
//                ]});
//            }else if(item.SUB_CODE == '67'){//심야
//                columns.push({text:'야식반영시간',
//                    columns:[
//                             {dataIndex: 'DUTY_CHK3_YN'            , width: 120},
//                             {dataIndex: 'DUTY_CHK3_H'            , width: 70},
//                             {dataIndex: 'DUTY_CHK3_M'            , width: 70}
//                ]});
//            }
            else if(item.SUB_CODE == '11'){//심야
				columns.push({text:'심야',
					columns:[
					         {dataIndex: 'OVERTIME_2_H'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }},
	                         {dataIndex: 'OVERTIME_2_M'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }}
				]});
			}else if(item.SUB_CODE == '12'){//특근
				columns.push({text:'특근',
					columns:[
					         {dataIndex: 'OVERTIME_3_H'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }},
	                         {dataIndex: 'OVERTIME_3_M'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }}
				]});
			}else if(item.SUB_CODE == '13'){//특근연장
				columns.push({text:'특근연장',
					columns:[
					         {dataIndex: 'OVERTIME_4_H'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }},
	                         {dataIndex: 'OVERTIME_4_M'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }}
				]});
			}else if(item.SUB_CODE == '14'){//특심심야
				columns.push({text:'특심심야',
					columns:[
					         {dataIndex: 'OVERTIME_5_H'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }},
	                         {dataIndex: 'OVERTIME_5_M'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }}
				]});
			}
//			else if(item.SUB_CODE == '15'){//임시
//				columns.push({text:'임시',
//					columns:[
//					         {dataIndex: 'H_015'            , width: 70},
//	                         {dataIndex: 'M_015'            , width: 70}
//				]});
//			}
			else if(item.SUB_CODE == '16'){//야간조가산
				columns.push({text:'야간조가산',
					columns:[
					         {dataIndex: 'OVERTIME_6_H'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }},
	                         {dataIndex: 'OVERTIME_6_M'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }}
				]});
			}else if(item.SUB_CODE == '17'){//야간조심야
				columns.push({text:'야간조심야',
					columns:[
					         {dataIndex: 'OVERTIME_7_H'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }},
	                         {dataIndex: 'OVERTIME_7_M'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }}
				]});
			}else if(item.SUB_CODE == '20'){//결근
				columns.push({text:'결근',
					columns:[
					         {dataIndex: 'H_020'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }},
	                         {dataIndex: 'M_020'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }}
				]});
			}else if(item.SUB_CODE == '21'){//무휴
				columns.push({text:'무휴',
					columns:[
					         {dataIndex: 'H_021'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }},
	                         {dataIndex: 'M_021'            , width: 50,
                             renderer:function(value){
                               if(value != 0){
                                    return '<div style="background:orange">'+value+'</div>'
                               }else{
                                    return 0;
                               }
                           }}
				]});
			}else if(item.SUB_CODE == '22'){//유휴
				columns.push({text:'유휴',
					columns:[
					         {dataIndex: 'H_022'            , width: 50},
	                         {dataIndex: 'M_022'            , width: 50}
				]});
			}else if(item.SUB_CODE == '23'){//출산휴가
				columns.push({text:'출산휴가',
					columns:[
					         {dataIndex: 'H_023'            , width: 50},
	                         {dataIndex: 'M_023'            , width: 50}
				]});
			}else if(item.SUB_CODE == '50'){//연차
				columns.push({text:'연차',
					columns:[
					         {dataIndex: 'H_050'            , width: 50},
	                         {dataIndex: 'M_050'            , width: 50}
				]});
			}else if(item.SUB_CODE == '51'){//반차
				columns.push({text:'반차',
					columns:[
					         {dataIndex: 'H_051'            , width: 50},
	                         {dataIndex: 'M_051'            , width: 50}
				]});
			}else if(item.SUB_CODE == '60'){//출장
				columns.push({text:'출장',
					columns:[
					         {dataIndex: 'H_060'            , width: 50},
	                         {dataIndex: 'M_060'            , width: 50}
				]});
			}else if(item.SUB_CODE == '61'){//공가
				columns.push({text:'공가',
					columns:[
					         {dataIndex: 'H_061'            , width: 50},
	                         {dataIndex: 'M_061'            , width: 50}
				]});
			}else if(item.SUB_CODE == '62'){//병가
				columns.push({text:'병가',
					columns:[
					         {dataIndex: 'H_062'            , width: 50},
	                         {dataIndex: 'M_062'            , width: 50}
				]});
			}else if(item.SUB_CODE == '63'){//훈련
				columns.push({text:'훈련',
					columns:[
					         {dataIndex: 'H_063'            , width: 50},
	                         {dataIndex: 'M_063'            , width: 50}
				]});
			}else if(item.SUB_CODE == '64'){//교육
				columns.push({text:'교육',
					columns:[
					         {dataIndex: 'H_064'            , width: 50},
	                         {dataIndex: 'M_064'            , width: 50}
				]});
			}else if(item.SUB_CODE == '65'){//파견
				columns.push({text:'파견',
					columns:[
					         {dataIndex: 'H_065'            , width: 50},
	                         {dataIndex: 'M_065'            , width: 50}
				]});
			}else if(item.SUB_CODE == '99'){//이상근태
				columns.push({text:'이상근태',
					columns:[
					         {dataIndex: 'H_099'            , width: 50},
	                         {dataIndex: 'M_099'            , width: 50}
				]});
			}

			/* columns.push({text: item.CODE_NAME,
				columns:[
					{dataIndex: 'DUTY_NUM' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
						renderer: function(value, metaData, record) {
							return Ext.util.Format.number(value, '0.0');
						}
					},
					{dataIndex: 'DUTY_TIME' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
						renderer: function(value, metaData, record) {
							return Ext.util.Format.number(value, '0.00');
						}
					}
			]}); */
		});

		console.log(columns);
		return columns;
	}
	
};


</script>
