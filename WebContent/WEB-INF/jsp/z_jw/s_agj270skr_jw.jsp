<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agj270skr_jw"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A011" /> <!-- 입력경로 -->
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->
	<t:ExtComboStore comboType="AU" comboCode="A023" /> <!--결의회계구분-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >

var printType = '';
var KeyValue  = '';

function appMain() {

    var directReportProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 's_agj270skr_jwService.insertDetail',
            syncAll: 's_agj270skr_jwService.saveAll'
        }
    });
	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('s_agj270skr_jwModel1', {
		fields: [
			{name: 'AUTO_NUM'			,text: '자동채번' 	,type: 'string'},
	    	{name: 'AC_DATE'			,text: '전표일' 		,type: 'uniDate'},
	    	{name: 'SLIP_NUM'			,text: '번호' 		,type: 'string'},
	    	{name: 'EX_DATE'			,text: 'EX_DATE' 	,type: 'uniDate'},
	    	{name: 'EX_NUM'				,text: 'EX_NUM' 	,type: 'string'},
	    	{name: 'DR_AMT_I'			,text: '차변금액' 		,type: 'uniPrice'},
	    	{name: 'CR_AMT_I'			,text: '대변금액' 		,type: 'uniPrice'},
	    	{name: 'INPUT_PATH'			,text: '입력경로' 		,type: 'string' ,comboType:"AU", comboCode:"A011" },
	    	{name: 'CHARGE_NAME'		,text: '입력자' 		,type: 'string'},
	    	{name: 'INPUT_DATE'			,text: '입력일' 		,type: 'uniDate'},
	    	{name: 'AP_CHARGE_NAME'		,text: '승인자' 		,type: 'string'} ,
	    	{name: 'AP_DATE'			,text: '승인일' 		,type: 'uniDate'},
	    	{name: 'INPUT_DIVI'			,text: 'INPUT_DIVI' ,type: 'string'}
		]
	});

	Unilite.defineModel('s_agj270skr_jwModel2', {
		fields: [
	    	{name: 'EX_SEQ'			,text: '순번' 		,type: 'string'},
	    	{name: 'SLIP_SEQ'		,text: '순번' 		,type: 'string'},
	    	{name: 'SLIP_DIVI_NM'	,text: '차대구분' 		,type: 'string'},
	    	{name: 'ACCNT'			,text: '계정코드' 		,type: 'string'},
	    	{name: 'ACCNT_NAME'		,text: '계정과목명' 		,type: 'string'},
	    	{name: 'AMT_I'			,text: '금액' 		,type: 'uniPrice'},
	    	{name: 'MONEY_UNIT'		,text: '화폐' 		,type: 'string'},
	    	{name: 'EXCHG_RATE_O'	,text: '환율' 		,type: 'uniER'},
	    	{name: 'FOR_AMT_I'		,text: '외화금액' 		,type: 'uniFC'},
	    	{name: 'REMARK'			,text: '적요' 		,type: 'string'},
	    	{name: 'DEPT_CODE'		,text: '부서코드' 		,type: 'string'},
	    	{name: 'DEPT_NAME'		,text: '귀속부서' 		,type: 'string'},
	    	{name: 'DIV_NAME'		,text: '귀속사업장' 		,type: 'string'},
	    	{name: 'PROOF_KIND_NM'	,text: '증빙유형' 		,type: 'string'},

	    	{name: 'POSTIT_YN'		,text: 'POSTIT_YN' 	,type: 'string'},

	    	/* Hidden */
	    	{name: 'AC_CODE1'		,text: 'AC_CODE1'	 	,type: 'string'},
	    	{name: 'AC_CODE2'		,text: 'AC_CODE2'	 	,type: 'string'},
	    	{name: 'AC_CODE3'		,text: 'AC_CODE3' 		,type: 'string'},
	    	{name: 'AC_CODE4'		,text: 'AC_CODE4' 		,type: 'string'},
	    	{name: 'AC_CODE5'		,text: 'AC_CODE5' 		,type: 'string'},
	    	{name: 'AC_CODE6'		,text: 'AC_CODE6' 		,type: 'string'},

	    	{name: 'AC_NAME1'		,text: 'AC_NAME1' 		,type: 'string'},
	    	{name: 'AC_NAME2'		,text: 'AC_NAME2' 		,type: 'string'},
	    	{name: 'AC_NAME3'		,text: 'AC_NAME3' 		,type: 'string'},
	    	{name: 'AC_NAME4'		,text: 'AC_NAME4' 		,type: 'string'},
	    	{name: 'AC_NAME5'		,text: 'AC_NAME5' 		,type: 'string'},
	    	{name: 'AC_NAME6'		,text: 'AC_NAME6' 		,type: 'string'},

	    	{name: 'AC_DATA1'		,text: 'AC_DATA1' 		,type: 'string'},
	    	{name: 'AC_DATA2'		,text: 'AC_DATA2' 		,type: 'string'},
	    	{name: 'AC_DATA3'		,text: 'AC_DATA3' 		,type: 'string'},
	    	{name: 'AC_DATA4'		,text: 'AC_DATA4' 		,type: 'string'},
	    	{name: 'AC_DATA5'		,text: 'AC_DATA5' 		,type: 'string'},
	    	{name: 'AC_DATA6'		,text: 'AC_DATA6'	 	,type: 'string'},

	    	{name: 'AC_DATA_NAME1'	,text: 'AC_DATA_NAME1' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME2'	,text: 'AC_DATA_NAME2' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME3'	,text: 'AC_DATA_NAME3' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME4'	,text: 'AC_DATA_NAME4' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME5'	,text: 'AC_DATA_NAME5' 	,type: 'string'},
	    	{name: 'AC_DATA_NAME6'	,text: 'AC_DATA_NAME6' 	,type: 'string'},

	    	{name: 'AC_TYPE1'		,text: 'AC_TYPE1' 		,type: 'string'},
	    	{name: 'AC_TYPE2'		,text: 'AC_TYPE2' 		,type: 'string'},
	    	{name: 'AC_TYPE3'		,text: 'AC_TYPE3' 		,type: 'string'},
	    	{name: 'AC_TYPE4'		,text: 'AC_TYPE4' 		,type: 'string'},
	    	{name: 'AC_TYPE5'		,text: 'AC_TYPE5' 		,type: 'string'},
	    	{name: 'AC_TYPE6'		,text: 'AC_TYPE6' 		,type: 'string'},

	    	{name: 'AC_FORMAT1'		,text: 'AC_FORMAT1' 	,type: 'string'},
	    	{name: 'AC_FORMAT2'		,text: 'AC_FORMAT2' 	,type: 'string'},
	    	{name: 'AC_FORMAT3'		,text: 'AC_FORMAT3' 	,type: 'string'},
	    	{name: 'AC_FORMAT4'		,text: 'AC_FORMAT4' 	,type: 'string'},
	    	{name: 'AC_FORMAT5'		,text: 'AC_FORMAT5' 	,type: 'string'},
	    	{name: 'AC_FORMAT6'		,text: 'AC_FORMAT6' 	,type: 'string'},

	    	{name: 'AC_POPUP1' 		,text:'관리항목1팝업여부'		,type : 'string'},
			{name: 'AC_POPUP2'   	,text:'관리항목2팝업여부'		,type : 'string'},
			{name: 'AC_POPUP3'   	,text:'관리항목3팝업여부'		,type : 'string'},
			{name: 'AC_POPUP4'   	,text:'관리항목4팝업여부'		,type : 'string'},
			{name: 'AC_POPUP5'   	,text:'관리항목5팝업여부'		,type : 'string'},
			{name: 'AC_POPUP6'   	,text:'관리항목6팝업여부'		,type : 'string'}

		]
	});

    var reportStore = Unilite.createStore('s_agj270skr_jwReportStore',{
        uniOpt: {
            isMaster: false,
            editable: false,
            deletable: false,
            useNavi: false
        },
        proxy: directReportProxy,
        saveStore: function() {
            config = {
                success: function(batch, option) {
                    var resultValue = batch.operations[0].getResultSet();
                    var FR_AC_DATE = '';
                    var TO_AC_DATE = '';
                    var SLIP_DIVI = '';


                    KeyValue = resultValue[0].KEY_VALUE;

                     var param = {
                                KEY_VALUE       : KeyValue,
                                FR_AC_DATE      : UniDate.getDbDateStr(panelSearch.getValue('FR_AC_DATE')),
                                TO_AC_DATE      : UniDate.getDbDateStr(panelSearch.getValue('TO_AC_DATE')),
                                SLIP_DIVI       : panelResult.getValue('SLIP_DIVI')

                            }

                    var win = Ext.create('widget.CrystalReport', {
                        url: CPATH+'/z_yg/s_agj271crkr_yg.do',
                        prgID: 's_agj271crkr_yg',
                        extParam: param
                    });
                    win.center();
                    win.show();
                    reportStore.clearData();

                 },
                 failure: function(batch, option) {
                    reportStore.clearData();
                 }
            };
            this.syncAllDirect(config);
        }
    });

	/* Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_agj270skr_jwDetailStore',{
		model: 's_agj270skr_jwModel1',
		uniOpt : {
        	isMaster:	true,			// 상위 버튼 연결
        	editable:	false,			// 수정 모드 사용
        	deletable:	false,			// 삭제 가능 여부
            useNavi:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_agj270skr_jwService.selectList'
            }
        },
		loadStoreRecords : function()	{
			var form = Ext.getCmp('searchForm');
			var param= form.getValues();
			console.log( param );
			if(form.isValid())	{
				detailForm.down('#formFieldArea1').removeAll();
				detailGrid.reset();
                detailStore.clearData();
				this.load({
					params : param
				});
			}
		},
		/*saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);
        	var rv = true;


			if(inValidRecs.length == 0 )	{
				config = {
						success: function(batch, option) {

//                        reportStore.clearData();
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);
							//directMasterStore.loadStoreRecords();
							var resultValue = batch.operations[0].getResultSet();
							KeyValue = resultValue[0].KEY_VALUE;

							var win = Ext.create('widget.PDFPrintWindow', {
								url: CPATH+'/agj/agj270rkrPrint.do',
								prgID: 'agj270rkr_S3',
									extParam: {
										//AC_DATE			: acDate,
										KEY_VALUE       : KeyValue,
										FR_AC_DATE      : UniDate.getDbDateStr(panelSearch.getValue('FR_AC_DATE')),
										TO_AC_DATE		: UniDate.getDbDateStr(panelSearch.getValue('TO_AC_DATE')),
										SLIP_DIVI  		: panelSearch.getValue('SLIP_DIVI'),
										SLIP_NAME   	: panelSearch.getField('SLIP_DIVI').getRawValue(),
										PRINT_TYPE		: "S3",
										PGM_ID			: 'AGJ270SKR'
									}
								});
								win.center();
								win.show();
						 }
				};
				this.syncAllDirect(config);

			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},*/
		listeners:{
			load:function( store, records, successful, operation, eOpts ){
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
				if(store.getCount() > 0){
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				}else{
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
				}
			}
		}
	});

	var detailStore = Unilite.createStore('s_agj270skr_jwDetailStore',{
			model: 's_agj270skr_jwModel2',
			uniOpt : {
            	isMaster:	false,			// 상위 버튼 연결
            	editable:	false,			// 수정 모드 사용
            	deletable:	false,			// 삭제 가능 여부
	            useNavi :	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 's_agj270skr_jwService.selectList2'
                }
            },
            loadStoreRecords : function(record)	{
				 var searchParam = Ext.getCmp('searchForm').getValues();
				 if(!Ext.isEmpty(record)){
					 var param= {
					 	'AC_DATE': Ext.isEmpty(record.data.AC_DATE) ? '': UniDate.getDbDateStr(record.data.AC_DATE).substring(0.6),
						'SLIP_NUM':record.data.SLIP_NUM,
						'INPUT_PATH':record.data.INPUT_PATH
					};

					var params = Ext.merge(searchParam, param);
					console.log( param );
					this.load({
						params : params
					});
				}
			},
			listeners:{
				load: function(store, records, successful, eOpts) {
					if(!Ext.isEmpty(detailGrid.getSelectionModel())) {
						detailGrid.getSelectionModel().select(0);
					}
					masterGrid.focus();
				}
			}
	});

	/* 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        url: CPATH+'/z_jw/s_agj270skr_jwExcelDown.do',
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
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
    			fieldLabel: '전표일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_AC_DATE',
		        endFieldName: 'TO_AC_DATE',
		        width: 470,
		        allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
						panelResult.setValue('FR_AC_DATE',newValue);
			    	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_AC_DATE',newValue);
			    	}
			    }
	        }, {
    			fieldLabel: '입력일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_IN_DATE',
		        endFieldName: 'TO_IN_DATE',
		        width: 470,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
							panelResult.setValue('FR_IN_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_IN_DATE',newValue);
			    	}
			    }
	        },{
		        fieldLabel: '사업장',
			    name:'DIV_CODE',
			    xtype: 'uniCombobox',
				multiSelect: true,
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
			    width: 325,
			    colspan:2,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		    },
		        Unilite.popup('DEPT',{
		        fieldLabel: '입력부서',
//		        validateBlank:false,
		    	valueFieldName:'IN_DEPT_CODE',
		    	textFieldName:'IN_DEPT_NAME',
	        	listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
					onValueFieldChange:function( elm, newValue) {
						panelResult.setValue('IN_DEPT_CODE', newValue);
                	},
                	onTextFieldChange:function( elm, newValue) {
						panelResult.setValue('IN_DEPT_NAME', newValue);
                	}
				}
		    }),
	        	//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
	        	Unilite.popup('ACCNT_PRSN',{
		        fieldLabel: '입력자',
//		        validateBlank:false,
		        autoPopup:true,
			    valueFieldName:'PRSN_CODE',
			    textFieldName:'PRSN_NAME',
	        	listeners: {
	        		onValueFieldChange: function(field, newValue){
						panelResult.setValue('PRSN_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PRSN_NAME', newValue);
					}
				}
		    }),{
		        fieldLabel: '입력경로',
			    name:'INPUT_PATH',
			    xtype: 'uniCombobox',
//				multiSelect: true,
//				typeAhead: false,
				comboType:'AU',
    			comboCode:'A011',
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INPUT_PATH', newValue);
					}
				}
		    },{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'회계번호',
					xtype: 'uniTextfield',
					name: 'FR_SLIP_NUM',
					width:195,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('FR_SLIP_NUM', newValue);
						}
					}
				},{
					xtype:'component',
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'',
					xtype: 'uniTextfield',
					name: 'TO_SLIP_NUM',
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TO_SLIP_NUM', newValue);
						}
					}
				}]
			}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'결의번호',
					xtype: 'uniTextfield',
					name: 'FR_EX_NUM',
					width:195,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('FR_EX_NUM', newValue);
						}
					}
				},{
					xtype:'component',
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'',
					xtype: 'uniTextfield',
					name: 'TO_EX_NUM',
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TO_EX_NUM', newValue);
						}
					}
				}]
			},{
				fieldLabel: '전표구분',
				xtype: 'uniCombobox',
				name: 'SLIP_DIVI',
				comboType: 'AU',
				comboCode:'A023',
	        	allowBlank: false,
	        	readOnly:true,
	        	value: '2',
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SLIP_DIVI', newValue);
					}
				}
			}]
		}, {
			title: '추가정보',
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'금액',
					xtype: 'uniTextfield',
					name: 'FR_AMT_I',
					width:195
				},{
					xtype:'component',
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'',
					xtype: 'uniTextfield',
					name: 'TO_AMT_I',
					width: 110
				}]
			}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'외화금액',
					xtype: 'uniTextfield',
					name: 'FR_FOR_AMT_I',
					width:195
				},{
					xtype:'component',
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'',
					xtype: 'uniTextfield',
					name: 'TO_FOR_AMT_I',
					width: 110
				}]
			},{
				fieldLabel: '승인여부',
				xtype: 'uniCombobox',
				name: 'AP_STS',
				comboType: 'AU',
				comboCode:'A014'
			},{
	            fieldLabel: 'EX_NUMS',
	            xtype: 'uniTextfield',
	            name: 'EX_NUMS',
	            hidden: false
	        }]
		}]
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3
		},
		padding:'1 1 1 1',
		border:true,
		items : [{
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'FR_AC_DATE',
	        endFieldName: 'TO_AC_DATE',
	        //width: 470,
	        allowBlank: false,
	        tdAttrs: {width: 380},
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
					panelSearch.setValue('FR_AC_DATE',newValue);
		    	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_AC_DATE',newValue);
		    	}
		    }
        },
        	Unilite.popup('DEPT',{
	        fieldLabel: '입력부서',
//	        validateBlank:false,
		    valueFieldName:'IN_DEPT_CODE',
		    textFieldName:'IN_DEPT_NAME',
	        tdAttrs: {width: 380},
        	listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				},
				onValueFieldChange:function( elm, newValue) {
					panelSearch.setValue('IN_DEPT_CODE', newValue);
				},
				onTextFieldChange:function( elm, newValue) {
					panelSearch.setValue('IN_DEPT_NAME', newValue);
				}
			}
	    }),{
			fieldLabel: '사업장',
		    name:'DIV_CODE',
		    xtype: 'uniCombobox',
			multiSelect: true,
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
		    width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '입력일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'FR_IN_DATE',
	        endFieldName: 'TO_IN_DATE',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_IN_DATE',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_IN_DATE',newValue);
		    	}
		    }
        },
        	Unilite.popup('ACCNT_PRSN',{
	        fieldLabel: '입력자',
//	        validateBlank:false,
	        autoPopup:true,
		    valueFieldName:'PRSN_CODE',
		    textFieldName:'PRSN_NAME',
        	listeners: {
        		onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PRSN_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PRSN_NAME', newValue);
				}
			}
	    }),{
			fieldLabel: '입력경로',
		    name:'INPUT_PATH',
		    xtype: 'uniCombobox',
//			multiSelect: true,
//			typeAhead: false,
			comboType: 'AU',
			comboCode: 'A011',
		    width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INPUT_PATH', newValue);
				}
			}
		},{
		    xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:325,
			items :[{
				fieldLabel:'회계번호',
				xtype: 'uniTextfield',
				name: 'FR_SLIP_NUM',
				width:195,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('FR_SLIP_NUM', newValue);
					}
				}
			},{
				xtype:'component',
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'',
				xtype: 'uniTextfield',
				name: 'TO_SLIP_NUM',
				width: 110,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TO_SLIP_NUM', newValue);
					}
				}
			}]
		}, {
		    xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:325,
			items :[{
				fieldLabel:'결의번호',
				xtype: 'uniTextfield',
				name: 'FR_EX_NUM',
				width:195,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('FR_EX_NUM', newValue);
					}
				}
			},{
				xtype:'component',
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'',
				xtype: 'uniTextfield',
				name: 'TO_EX_NUM',
				width: 110,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TO_EX_NUM', newValue);
					}
				}
			}]
		},{
			fieldLabel: '전표구분',
			xtype: 'uniCombobox',
			name: 'SLIP_DIVI',
			comboType: 'AU',
			comboCode:'A023',
			width: 172,
        	allowBlank: false,
        	readOnly: true,
        	value: '2',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SLIP_DIVI', newValue);
				}
			}
		}]
	});

	/* Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_agj270skr_jwGrid', {
        layout : 'fit',
        region:'center',
        flex: 3,
    	store: masterStore,
    	uniOpt : {
			useMultipleSorting	: true,
	    	useLiveSearch		: true,
	    	onLoadSelectFirst	: false,
	    	dblClickToEdit		: false,
	    	useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
	    	filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
        tbar:[
        	'->',
    	{
        	xtype:'button',
        	text:'전표출력',
        	handler:function()	{
        		printType = 'slip'; /* 전표  */

        		var formSearch =  Ext.getCmp('searchForm');
        		var form = panelFileDown;
        		var selectedRecords = masterGrid.getSelectionModel().getSelection();
        		if(!Ext.isEmpty(selectedRecords)) {

        			var param = formSearch.getValues();
            		param.SLIP_NUM = '1';
            		param.AC_DATE = '20180801';
    	        		form.submit({
    	                    params: param,
    	                    success:function()  {
    	                    },
    	                    failure: function(form, action){
    	                    }
    	             });
        		}
        		//form.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
        		//form.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));

        	//	var toUpdate = directMasterStore.getUpdatedRecords();
        		/* var budgData = [];
        		if(toUpdate.length > 0){
        			for(var i = 0; i < toUpdate.length; i++){
            			var data = toUpdate[i].data;
            			var itemCode = data.ITEM_CODE;
            			var budgetO = data.BUDGET_O;
            			var budgetP = data.BUDGET_UNIT_O; */
            		//	 var budgData = [];
            		//	budgData.push({
            		//		'ITEM_CODE' 	: '1',
            		//		'BUDGET_UNIT_O' : '2',
            		//		'BUDGET_O' 		: '333'
            		//	});
            	/* 	}
        		} */

        		//form.setValue('BUDG_DATA', JSON.stringify(budgData));


    		}
    	},/*{
        	xtype:'button',
        	text:'분개장출력',
        	handler:function()	{
        		printType = 'journal';  분개장

        		if(masterGrid.getSelectedRecords().length > 0 ){
	    			alert("분개장 출력 레포트를 만들어주세요.");
	    		}
	    		else{
	    			alert("선택된 자료가 없습니다.");
	    		}
    		}
    	},*/{
        	xtype:'button',
        	text:'분개장출력',
        	hidden:true,
        	handler:function()	{
        		printType = 'journal';  /* 집계표 */

        		if(masterGrid.getSelectedRecords().length > 0 ){
	    			UniAppManager.app.onPrintButtonDown(printType);
	    		}else{
	    			alert("선택된 자료가 없습니다.");
	    		}
    		}
    	}],
        enableColumnHide :true,
        sortableColumns : false,
        border:true,
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false,
	        listeners: {
	        	 select: function(grid, selectRecord, index, rowIndex, eOpts ){
	        		 var formSearch =  Ext.getCmp('searchForm');
	        		 var acDate = UniDate.getDbDateStr(selectRecord.get('AC_DATE'));
	                    if(Ext.isEmpty(formSearch.getValue('EX_NUMS'))) {
	                    	formSearch.setValue('EX_NUMS', acDate + selectRecord.get('SLIP_NUM'));
	                    } else {
	                        var exNums = formSearch.getValue('EX_NUMS');
	                        exNums = exNums + ',' + acDate + selectRecord.get('SLIP_NUM');
	                        formSearch.setValue('EX_NUMS', exNums);
	                    }
	                },
	                deselect:  function(grid, selectRecord, index, eOpts ){
	                	var formSearch =  Ext.getCmp('searchForm');
	                	 var acDate = UniDate.getDbDateStr(selectRecord.get('AC_DATE'));
	                	var exNums     = formSearch.getValue('EX_NUMS');
	                    var deselectedNum0  = acDate + selectRecord.get('SLIP_NUM') + ',';
	                    var deselectedNum1  = ',' + acDate + selectRecord.get('SLIP_NUM');
	                    var deselectedNum2  = acDate + selectRecord.get('SLIP_NUM');
	                    exNums = exNums.split(deselectedNum0).join("");
	                    exNums = exNums.split(deselectedNum1).join("");
	                    exNums = exNums.split(deselectedNum2).join("");
	                    formSearch.setValue('EX_NUMS', exNums);
	                }
	    	}
        }),
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
			{ dataIndex:'SEQ'				, 	width:50 ,	text : '순번',	align : 'center'},
	   		{ dataIndex:'AC_DATE'		 	, 	width:80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		    	}
	   		},
			{ dataIndex:'SLIP_NUM'			, 		width:50 ,	align : 'center'},
			{ dataIndex:'DR_AMT_I'		 	, 		width:120,	summaryType: 'sum'},
			{ dataIndex:'CR_AMT_I'		 	, 		width:120,	summaryType: 'sum'},
			{ dataIndex:'INPUT_PATH'		, 		width:140},
			{ dataIndex:'CHARGE_NAME'		, 		width:120},
			{ dataIndex:'INPUT_DATE'		, 		width:100},
			{ dataIndex:'AP_CHARGE_NAME'	, 		width:100},
			{ dataIndex:'AP_DATE'			, 		width:100},
			{ dataIndex:'EX_NUM'			, 		width:100		, hidden: true},
			{ dataIndex:'EX_DATE'			, 		width:100		, hidden: true},
			{ dataIndex:'INPUT_DIVI'		, 		width:100		, hidden: true}
        ],
        listeners: {
        	select: function(grid, record, index, eOpts ){
        		detailStore.loadStoreRecords(record);
        	},
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{
	        	view.ownerGrid.setCellPointer(view, item);
        	},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
        		masterGrid.gotoAgj(record);
            }
        },
/*      	uniRowContextMenu:{												//마우스 오른 쪽 링크 삭제(20170110)
			items: [
	             {	text: '결의전표입력 보기',
	            	itemId	: 'linkAgj100ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgj(param.record);
	            	}
	        	},{	text: '결의미결반제입력 보기',
	            	itemId	: 'linkAgj110ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgj(param.record);
	            	}
	        	},{	text: '회계전표입력 보기',
	            	itemId	: 'linkAgj200ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgj(param.record);
	            	}
	        	},{	text: '회계전표입력(전표번호별)보기',
	            	itemId	: 'linkAgj205ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgj(param.record);
	            	}
	        	},{	text: '결의전표입력(전표번호별)보기',
	            	itemId	: 'linkAgj105ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgj(param.record);
	            	}
	        	},{	text: 'Dgj100ukr',
	            	itemId	: 'linkDgj100ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgj(param.record);
	            	}
	        	}
	        ]
	    },
	    onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
		    if(panelSearch.getValue('SLIP_DIVI') == 1){
				if(record.get('INPUT_DIVI') == '2' || record.get('INPUT_DIVI') == '3') {
					menu.down('#linkAgj100ukr').hide();
					menu.down('#linkAgj110ukr').hide();
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkAgj205ukr').show();	// 회계전표입력(전표번호별) 보기
		      		menu.down('#linkAgj105ukr').hide();
					menu.down('#linkDgj100ukr').hide();

				} else if(record.get('INPUT_PATH') == 'Z3') {
					menu.down('#linkAgj100ukr').hide();
					menu.down('#linkAgj110ukr').hide();
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkAgj205ukr').hide();
		      		menu.down('#linkAgj105ukr').hide();
					menu.down('#linkDgj100ukr').show();	// Dgj100ukrv 미개발
				} else {
					menu.down('#linkAgj100ukr').hide();
					menu.down('#linkAgj110ukr').hide();
					menu.down('#linkAgj200ukr').show();	// 회계전표입력 보기
					menu.down('#linkAgj205ukr').hide();
		      		menu.down('#linkAgj105ukr').hide();
					menu.down('#linkDgj100ukr').hide();
				}
      			return true;
	    	}
	    	else if(panelSearch.getValue('SLIP_DIVI') == 2){
	    		if(record.get('INPUT_DIVI') == '2') {
					menu.down('#linkAgj100ukr').hide();
					menu.down('#linkAgj110ukr').hide();
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkAgj205ukr').hide();
		      		menu.down('#linkAgj105ukr').show();	// 결의전표입력(전표번호별) 보기
					menu.down('#linkDgj100ukr').hide();

				} else if(record.get('INPUT_DIVI') == '3') {
					menu.down('#linkAgj100ukr').hide();
					menu.down('#linkAgj110ukr').show();
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkAgj205ukr').hide();
		      		menu.down('#linkAgj105ukr').hide();
					menu.down('#linkDgj100ukr').hide();	// Dgj100ukrv 미개발

				} else if(record.get('INPUT_PATH') == 'Z3') {
					menu.down('#linkAgj100ukr').hide();
					menu.down('#linkAgj110ukr').hide();
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkAgj205ukr').hide();
		      		menu.down('#linkAgj105ukr').hide();
					menu.down('#linkDgj100ukr').show();	// Dgj100ukrv 미개발

				} else {
					menu.down('#linkAgj100ukr').show();	// 결의전표입력 보기
					menu.down('#linkAgj110ukr').hide();
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkAgj205ukr').hide();
		      		menu.down('#linkAgj105ukr').hide();
					menu.down('#linkDgj100ukr').hide();
				}
				return true;
	    	}
      	},
*/
      	gotoAgj:function(record)	{
    		if(panelSearch.getValue('SLIP_DIVI') == 1){
				if(record)	{
			    	var params = {
			    		action				: 'select',
				    	'PGM_ID'			: 'agj270skr',
				    	'AC_DATE' 			: record.data['AC_DATE'],
				    	'AC_DATE'			: record.data['AC_DATE'],
				    	'INPUT_PATH' 		: record.data['INPUT_PATH'],
				    	'SLIP_NUM'			: record.data['EX_NUM'],
				    	'SLIP_SEQ' 			: "1",
				    	'AP_STS'			: "",
				    	'DIV_NAME'   		: panelSearch.getValue('DIV_NAME')
					}
					//입력경로가 'Z1'일 경우 결의전표입력으로 이동
/*		  			if (record.data['INPUT_PATH'] == 'Z1'){
	          			var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};
						parent.openTab(rec1, '/accnt/agj105ukr.do', params);
	          		} else if (record.data['INPUT_DIVI'] == '3'){
	          			var rec1 = {data : {prgID : 'agj110ukr', 'text':''}};
						parent.openTab(rec1, '/accnt/agj110ukr.do', params);
	          		} else*/ if (record.data['INPUT_DIVI'] == '1'){
	          			var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};
						parent.openTab(rec1, '/accnt/agj200ukr.do', params);
	          		}/*else if(record.data['INPUT_PATH'] == 'Z3'){
	          			var rec1 = {data : {prgID : 'dgj100ukr', 'text':''}};
						parent.openTab(rec1, '/accnt/dgj100ukr.do', params);
	          		}*/else{
	          			var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};
						parent.openTab(rec1, '/accnt/agj205ukr.do', params);
	          		}
				}
    		}else{
				var apSts = "";
    			if(record.data['AP_DATE'] == ''){
					apSts =  "1"
				} else {
					apSts =  "2"
				}
				var params = {
					action:'select',
					'PGM_ID'	 : 's_agj270skr_jw',
					'AC_DATE' 	 : UniDate.getDbDateStr(record.data['AC_DATE']),
					'EX_DATE' 	 : UniDate.getDbDateStr(record.data['EX_DATE']),
					'INPUT_PATH' : record.data['INPUT_PATH'],
			    	'SLIP_NUM'	 : record.data['SLIP_NUM'],
			    	'SLIP_SEQ' 	 : "1",
					'EX_NUM' 	 : record.data['EX_NUM'],
					'EX_SEQ'	 : 1,
					'AP_STS'	 : apSts,
					'DIV_CODE'   : panelSearch.getValue('DIV_CODE'),
					'DIV_NAME'   : panelSearch.getValue('DIV_NAME')
				}

				if (record.data['INPUT_PATH'] == 'Z1'){
          			var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/agj105ukr.do', params);
          		}else if (record.data['INPUT_DIVI'] == '1'){
          			var rec1 = {data : {prgID : 'agj100ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/agj100ukr.do', params);
          		}else if(record.data['INPUT_DIVI'] == '3'){
          			var rec1 = {data : {prgID : 'agj110ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/agj110ukr.do', params);
          		}else if(record.data['INPUT_PATH'] == 'Z3'){
          			var rec1 = {data : {prgID : 'dgj110ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/dgj110ukr.do', params);
          		}else{
          			var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};
					parent.openTab(rec1, '/accnt/agj105ukr.do', params);
          		}

//				else{
//					apSts =  "2"
//		  			if (record.data['INPUT_DIVI'] == '1'){
//	          			var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};
//						parent.openTab(rec1, '/accnt/agj200ukr.do', params);
//	          		} else{
//	          			var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};
//						parent.openTab(rec1, '/accnt/agj205ukr.do', params);
//	          		}
//				}
    		}
    	},
		returnCell: function(record){
        	var AC_DATE			= record.get("AC_DATE");
        	var SLIP_NUM		= record.get("SLIP_NUM");
        	var EX_NUM			= record.get("EX_NUM");
        	var AP_DATE			= record.get("AP_DATE");
        	var INPUT_PATH		= record.get("INPUT_PATH");
		}
	});

    var detailGrid = Unilite.createGrid('s_agj270skr_jwGrid2', {
    	// for tab
        layout : 'fit',
        region:'south',
        flex: 2,
    	split: true,
    	store: detailStore,
    	uniOpt : {
			useMultipleSorting	: true,
	    	useLiveSearch		: false,
	    	onLoadSelectFirst	: false,
	    	dblClickToEdit		: false,
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
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
        	{ dataIndex:'EX_SEQ'		, 		width:50 ,align : 'center'},
			{ dataIndex:'SLIP_DIVI_NM'	, 		width:80},
			{ dataIndex:'ACCNT'			, 		width:100},
			{ dataIndex:'ACCNT_NAME'	, 		width:160},

			{ dataIndex:'AMT_I'			, 		width:120},
			{ dataIndex:'MONEY_UNIT'	, 		width:66},
			{ dataIndex:'EXCHG_RATE_O'	, 		width:100},
			{ dataIndex:'FOR_AMT_I'		, 		width:100},
			{ dataIndex:'REMARK'		, 		width:333},
			{ dataIndex:'DEPT_NAME'		, 		width:120},
			{ dataIndex:'DIV_NAME'		, 		width:120},
			{ dataIndex:'PROOF_KIND_NM'	, 		width:200}
        ],
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners:{
			selectionchange:function(grid, selected, eOpt)	{
        		if(selected && selected.length > 0)	{
	        		var dataMap = selected[selected.length-1].data;
		    		UniAccnt.addMadeFields(detailForm, dataMap, detailForm, '', Ext.isEmpty(selected)?null:selected[selected.length-1]);
		    		detailForm.setActiveRecord(selected[selected.length-1]);
	    		}
	    	}
		}
    });

    var detailForm = Unilite.createForm('s_agj270skr_jwDetailForm',  {
        itemId: 's_agj270skr_jwDetailForm',
		masterGrid: detailGrid,
		minHeight :85,
		height: 85,
		disabled: false,
		border: true,
		padding: '1',
		layout : 'hbox',
		items:[{
			xtype: 'container',
			itemId: 'formFieldArea1',
			layout: {
				type: 'uniTable',
				columns:2
			},
			defaults:{
				width:365,
				labelWidth: 130,
				readOnly: 'true',
				editable: false
			}
		}]
    });

    var panelFileDown = Unilite.createForm('FileDownForm', {
		url: CPATH+'/z_jw/s_agj270skr_jwExcelDown.do',
		colspan: 2,
		layout: {type: 'uniTable', columns: 1},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true,
		items:[{
			xtype: 'uniTextfield',
			name: 'PJT_CODE'
		},{
			xtype:'uniTextfield',
			name:'BUDG_DATA'
		}]
	});

    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
			 	panelResult,
				masterGrid,
				{
					region:'south',
					xtype:'container',
					minHeight :220,
					flex:0.35,
					layout:{type:'vbox', align:'stretch'},
					items:[
						detailGrid, detailForm
					]
				}
			]
		}
		,panelSearch
		],
		id  : 's_agj270skr_jwApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_AC_DATE', UniDate.get('today'));
			panelSearch.setValue('TO_AC_DATE', UniDate.get('today'));
			panelResult.setValue('FR_AC_DATE', UniDate.get('today'));
			panelResult.setValue('TO_AC_DATE', UniDate.get('today'));
			panelSearch.setValue('SLIP_DIVI', '2');
			UniAppManager.setToolbarButtons(['reset','save','print'],false);
			//panelResult.setValue('PRSN_CODE', UserInfo.userID);
			//panelResult.setValue('PRSN_NAME', UserInfo.userName);
			//panelSearch.setValue('PRSN_CODE', UserInfo.userID);
			//panelSearch.setValue('PRSN_NAME', UserInfo.userName);
			panelResult.getField('PRSN_CODE').setReadOnly(true);
			panelResult.getField('PRSN_NAME').setReadOnly(true);
			panelSearch.getField('PRSN_CODE').setReadOnly(true);
			panelSearch.getField('PRSN_NAME').setReadOnly(true);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_AC_DATE');
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			detailForm.clearForm();
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			beforeRowIndex = -1;
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			detailForm.clearForm();
			masterGrid.reset();
			detailGrid.reset();
			masterStore.clearData();
            detailStore.clearData();
			printType = '';
			this.fnInitBinding();
		},
		      onPrintButtonDown: function(printType) {

            var mainPrintType = printType;
            var param = masterGrid.getSelectedRecords();
            var acDate = new Array();
            var acDate2 = new Array();
            var slipNum = new Array();

            var pgmId = 's_agj270skr_jw'

            Ext.each(param,
                function(record, i) {
                    if(!Ext.isEmpty(record.get('AC_DATE'))){
                        acDate[i] = UniDate.getDbDateStr(record.get('AC_DATE')).substring(0, 8) + record.get('SLIP_NUM');  // 201601011
                    }else{
                        acDate[i] =' ';
                    }

                    if(!Ext.isEmpty(record.get('AC_DATE'))){
                        acDate2[i] = UniDate.getDbDateStr(record.get('AC_DATE')).substring(0, 8);
                    }else{
                        acDate2[i] =' ';
                    }
                    if(!Ext.isEmpty(record.get('SLIP_NUM'))){
                        slipNum[i] = record.get('SLIP_NUM');
                    }
                    else{
                        slipNum[i] =' ';
                    }

            });


            if(mainPrintType == 'slip'){

                var proParam = {"S_COMP_CODE" : UserInfo.compCode};
                accntCommonService.fnGetPrintSetting(proParam, function(provider, response)    {

                        if(!Ext.isEmpty(provider)){
                            //
                            if(provider[0].SLIP_PRINT == 1){

                            	if(provider[0].RETURN_YN == 1){
                                    var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                       "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                       "AC_DATE" : acDate,
                                                       "PRINT_TYPE" : "P1",
                                                       "PRINT_LINE" : "2"
                                                      };
                            	 } else  {
                                    var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                       "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                       "AC_DATE" : acDate,
                                                       "PRINT_TYPE" : "P2",
                                                       "PRINT_LINE" : "2"
                                                      };
                            	 }



                             } else if (provider[0].SLIP_PRINT == 2){
                               	 if(provider[0].RETURN_YN == 1){
                               	     var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                        "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                        "AC_DATE" : acDate,
                                                        //"PRINT_TYPE" : "P3",
                                                        "PRINT_TYPE" : "P1",
                                                        "PRINT_LINE" : "1"
                                                        };
                               	 } else {

                                var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                   "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                   "AC_DATE" : acDate,
                                                   //"PRINT_TYPE" : "P4",
                                                   "PRINT_TYPE" : "P2",
                                                   "PRINT_LINE" : "1"
                                                  };

                               	 }

                             } else {
                                if(provider[0].RETURN_YN == 1){
                                     var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                        "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                        "AC_DATE" : acDate,
                                                        "PRINT_TYPE" : "L1",
                                                        "PRINT_LINE" : "1"
                                                       };
                                 } else {

                                      var reportParam = {"S_COMP_CODE" : UserInfo.compCode,
                                                         "SLIP_DIVI" : panelSearch.getValue('SLIP_DIVI'),
                                                         "AC_DATE" : acDate,
                                                         //"PRINT_TYPE" : "L2",
                                                         "PRINT_TYPE" : "L1",
                                                         "PRINT_LINE" : "1"
                                                         };

                                 }

                             }

                            var win = Ext.create('widget.CrystalReport', {
                                url: CPATH+'/z_yg/s_agj270crkr_yg.do',
                                prgID: 's_agj270crkr_yg',
                                extParam: reportParam
                            });

                            win.center();
                            win.show();


                    }

                });

            }else if(mainPrintType == 'journal'){ // 집계표 일 경우
                var selectedRecords = masterGrid.getSelectedRecords();
                if(selectedRecords.length > 0){
                    reportStore.clearData();
                    Ext.each(selectedRecords, function(record,i){
                        record.phantom = true;
                        reportStore.insert(i, record);
                    });
                    reportStore.saveStore();
                }
            }

        }
	});
};


</script>

