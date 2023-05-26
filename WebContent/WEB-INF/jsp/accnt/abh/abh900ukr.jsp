<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="abh900ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="A014"  /> 			<!-- 전표승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A392"  /> 			<!-- 가수금 IN_GUBUN -->
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	
//조회된 합계, 건수 계산용 변수 선언
var selectedAmt = 0;					//선택된 그리드 합계
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'abh900ukrService.selectList'
//			update	: 'abh900ukrService.updateDetail',
//			create	: 'abh900ukrService.insertDetail',
//			destroy	: 'abh900ukrService.deleteDetail',
//			syncAll	: 'abh900ukrService.saveAll'
		}
	});	
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'abh900ukrService.runProcedure',
            syncAll	: 'abh900ukrService.callProcedure'
		}
	});	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('abh900ukrModel', {
	    fields: [
	        {name: 'AUTO_NUM'               ,text: '순번'                   ,type: 'int'},
			{name: 'NOTE_NUM'				,text: '전자어음번호'			,type: 'string'  },
			{name: 'PUB_DATE'				,text: '전자어음발행일'			,type: 'uniDate'  },
			{name: 'OC_AMT_I'				,text: '전자어음금액'			,type: 'uniPrice'},
			{name: 'EXP_DATE'				,text: '전자어음만기일자'		,type: 'uniDate'  },
			{name: 'PUB_COMPANY_NUM'		,text: '발행인주민사업자번호'	,type: 'string'	 },
			{name: 'PUB_MAN'				,text: '발행인법인명'			,type: 'string'  },
			{name: 'PUB_TOT_NAME'			,text: '발행인성명'				,type: 'string'  },
			{name: 'CUSTOM_CODE'			,text: '거래처코드'				,type: 'string'  },
			{name: 'DIV_CODE'				,text: '사업장코드'				,type: 'string'  },
			{name: 'DEPT_CODE'				,text: '귀속부서코드'			,type: 'string'  },
			{name: 'DEPT_NAME'				,text: '귀속부서명'				,type: 'string'  },
			{name: 'EX_DATE'				,text: '결의일자'				,type: 'uniDate'	 },
			{name: 'EX_NUM'					,text: '결의번호'				,type: 'string' },
			{name: 'AGREE_YN'				,text: '승인여부'				,type: 'string'  },
			{name: 'AC_DATE'				,text: '회계일자'				,type: 'uniDate'  },
			{name: 'SLIP_NUM'				,text: '회계번호'				,type: 'int'     },
			{name: 'AUTO_SLIP_NUM'			,text: '자동기표KEY'			,type: 'string'  }
		]
	});
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('abh900ukrmasterStore',{
		model: 'abh900ukrModel',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 	
			deletable	: false,			// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
		proxy	: directProxy,
        
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param.PROC_FLAG = Ext.getCmp('rdoSelect1').getChecked()[0].inputValue
			console.log( param );
			this.load({
				params : param
			});
		},
		
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();

			if(inValidRecs.length == 0) {
				config = {
					success: function(batch, option) {
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						if (masterStore.count() == 0) {   
//							UniAppManager.app.onResetButtonDown();
							
						}else{
//							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},

		listeners: {
           	load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
				if(store.getCount() > 0){
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
        			masterGrid.down('#btnViewAutoSlip').enable();
        			UniAppManager.setToolbarButtons(['delete', 'deleteAll'], false);

    			}else{
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
				}
				
//				//summaryRow에 쿼리에서 조회한 데이터 입력 후, 대체한 첫 번째 이월금액 그리드 삭제
//				Ext.each(records, function(record, rowIndex){ 
//					if(record.get('BANK_NAME') == '9999'){
//						masterStore.remove(record);
//						masterStore.commitChanges();
//						
//					}
//				});
   				
           		if(addResult.getValue('WORK_DIVI') == 1){
//           		if(gsConfirmYN == "Y"){
       				Ext.getCmp('procCanc').setText('개별자동기표');
       				Ext.getCmp('procCanc2').setText('일괄자동기표');
       			}else {
       				Ext.getCmp('procCanc').setText('개별기표취소');
       				Ext.getCmp('procCanc2').setText('일괄기표취소');
       			}
			}
		}
	});
	
    var buttonStore = Unilite.createStore('abh800ukrButtonStore',{      
        uniOpt: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,        	// 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

			//폼에서 필요한 조건 가져올 경우
			var paramMaster			= panelSearch.getValues();
			paramMaster.DIV_CODE	= addResult.getValue('DIV_CODE');
            paramMaster.OPR_FLAG	= buttonFlag;
            paramMaster.LANG_TYPE	= UserInfo.userLang
// 			paramMaster.PROC_DATE	= UniDate.getDbDateStr(addResult.getValue('EX_DATE'));	//일괄자동기표일 때 전표일자 처리용(전표일)
           
            
			if(inValidRecs.length == 0) {
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
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',		
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
			title	: '기본정보', 	
   			itemId	: 'search_panel1',
           	layout	: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items	: [{ 
    			fieldLabel	: '입금일자',
		        xtype		: 'uniDateRangefield',
		        startFieldName: 'DATE_FR',
		        endFieldName: 'DATE_TO',
		        startDate	: UniDate.get('startOfMonth'),
		        endDate		: UniDate.get('today'),
		        allowBlank	: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO',newValue);
			    	}
			    }
	        },{
                xtype       : 'uniTextfield',
                fieldLabel  : '전자어음번호',
                name        : 'NOTE_NUM',
                listeners   : {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('NOTE_NUM', newValue);
                    }
                }
            }
			]		
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3/*, tableAttrs: {width: '100%'}*/
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			xtype: 'container',
			layout:{type : 'uniTable', columns : 3},
			items:[{
				fieldLabel	: '입금일자',
		        xtype		: 'uniDateRangefield',
		        startFieldName: 'DATE_FR',
		        endFieldName: 'DATE_TO',
		        startDate	: UniDate.get('startOfMonth'),
		        endDate		: UniDate.get('today'),
		        allowBlank	: false,
				tdAttrs		: {width: 380},    
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('DATE_FR',newValue);
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('DATE_TO',newValue);
			    	}
			    }
	        },{
                xtype       : 'uniTextfield',
                fieldLabel  : '전자어음번호',
                name        : 'NOTE_NUM',
                listeners   : {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('NOTE_NUM', newValue);
                    }
                }
            }]
		}]
    });  

	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
		items: [{
			xtype: 'container',
			layout:{type : 'uniTable', columns : 5
//			,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
			},
			items:[{ 
				fieldLabel: '일괄기표전표일',
				name	: 'EX_DATE',
				xtype	: 'uniDatefield',
				value	: UniDate.get('today'),
				width	: 245,
				allowBlank: false
			},{
	    		xtype		: 'radiogroup',		            		
				fieldLabel	: '',						            		
				id			: 'rdoSelect0',
				tdAttrs		: {align: 'left'},
				items		: [{
					boxLabel: '발생일', 
					width	: 70, 
					name	: 'DATE_DIVI',
	    			inputValue: 'C',
					checked	: true  
				},{
					boxLabel: '실행일', 
					width	: 60,
					name	: 'DATE_DIVI',
	    			inputValue: 'B'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(Ext.getCmp('rdoSelect0').getChecked()[0].inputValue == 'C'){
							addResult.getField('EX_DATE').setReadOnly(true);
						}else{
							addResult.getField('EX_DATE').setReadOnly(false);
						}
					}
				}
			},{
	    		xtype		: 'radiogroup',		            		
				fieldLabel	: '작업구분',						            		
				id			: 'rdoSelect1',
//				colspan		: 2, 
				tdAttrs		: {align: 'left'},
				items		: [{
					boxLabel: '자동기표 대상', 
					width	: 120, 
					name	: 'WORK_DIVI',
	    			inputValue: 'Proc',
					checked	: true  
				},{
					boxLabel: '기표취소 대상', 
					width	: 120,
					name	: 'WORK_DIVI',
	    			inputValue: 'Canc'
				},{
					boxLabel: '전체', 
					width	: 90,
					name	: 'WORK_DIVI',
	    			inputValue: ''
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Proc'){
							Ext.getCmp('procCanc').enable();
		       				Ext.getCmp('procCanc2').enable();
		       				Ext.getCmp('procCanc').setText('개별자동기표');
		       				Ext.getCmp('procCanc2').setText('일괄자동기표');

						} else if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Canc'){
							Ext.getCmp('procCanc').enable();
		       				Ext.getCmp('procCanc2').enable();
		       				Ext.getCmp('procCanc').setText('개별기표취소');
		       				Ext.getCmp('procCanc2').setText('일괄기표취소');
		       				
						} else if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == ''){
							Ext.getCmp('procCanc').disable(true);
		       				Ext.getCmp('procCanc2').disable(true);
						}
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 2},
				colspan	: 2,
				items	: [{				   
					xtype	: 'button',
					id		: 'getElecData',
					text	: '데이터가져오기',
					tdAttrs	: {padding	: '0 0 2 0', width: '100%', align : 'right'},
					width	: 100,
					handler : function() {
						var me = this;
						var param = panelSearch.getValues();
						param.LANG_TYPE = UserInfo.userLang
						me.setDisabled(true);
						abh900ukrService.getData(param,
						    function(provider, response) {
                                if(provider) {  
                                    UniAppManager.updateStatus("완료 되었습니다.");
                                    me.setDisabled(true);                           
                                }
                                UniAppManager.app.onQueryButtonDown();
                                console.log("response",response)
                                me.setDisabled(false);
                            }
                        )
					}
				},{ //컬럼 맞춤용
                    xtype   : 'component',
                    width   : 100
                }/*,{				   
					xtype	: 'button',
					id		: 'specialButton',
					text	: '인터페이스',
					width	: 100,
//					hidden: true,
					handler : function() {
						var param	= [];
						var records	= masterGrid.getSelectedRecords();
						Ext.each(records, function(record, index) {
							param.push(record.data);
						});
						
						if (Ext.isEmpty(param)) {
							alert (Msg.sMA0256);									//선택된 자료가 없습니다.
							return false;
						
						} else {
	//						var paramMaster 	= panelSearch.getValues();
	//						param.paramMaster 	= paramMaster;
							var param		= [];
							abh900ukrService.runInterface(param, function(provider, response) {
	
							});
						}
					}
				}*/]
			},{
				fieldLabel	: '전표귀속사업장',
				name		: 'DIV_CODE' ,          
				xtype		: 'uniCombobox' ,
				comboType	: 'BOR120',
				value       : UserInfo.divCode,
				allowBlank	: false
			},{//count
				xtype	: 'uniTextfield',
				name	: 'COUNT',
				hidden	: true
			},{	//컬럼 맞춤용
				xtype	: 'component'
			},{	//컬럼 맞춤용
				xtype	: 'component'
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable'},
			 	tdAttrs	: {align: 'right', width: '100%'},
			 	padding	: '0 0 3 0',
			 	colspan	: 2,
				items	: [{
					fieldLabel	: '입금액 합계',
					name		: 'SELECTED_AMT', 
					xtype		: 'uniNumberfield',
					value		: '0',
					readOnly	: true
				},{	//컬럼 맞춤용
					xtype	: 'component',
					width	: 30
				},{				   
					xtype	: 'button',
					//name	: 'CONFIRM_CHECK',
					id		: 'procCanc',
					text	: '개별자동기표',
					width	: 100,
					handler : function() {
						var records = masterGrid.getSelectedRecords();
						if(!addResult.getInvalidMessage()) {											//addResult의 필수값 체크
							return false;
						}
						if (Ext.isEmpty(records)) {
							alert (Msg.sMA0256);														//선택된 자료가 없습니다.
							return false;
						}
						if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Proc') {					//자동기표 "실행"일 때~~~
				            var buttonFlag	= 'N';								//자동기표 FLAG
				            var procType	= 'C';								//C:개별, B:일괄
				            fnMakeLogTable(buttonFlag, procType);				

						} else if (Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Canc') {			//자동기표 "취소"일 때~~~
				            var buttonFlag	= 'D';
				            var procType	= 'C';								//C:개별, B:일괄
				            fnMakeLogTable(buttonFlag, procType);
						}
					}
				},{				   
					xtype	: 'button',
					//name: 'CONFIRM_CHECK',
					id		: 'procCanc2',
					text	: '일괄자동기표',
					width	: 100,
					handler : function() {
						var records = masterGrid.getSelectedRecords();
						if(!addResult.getInvalidMessage()) {											//addResult의 필수값 체크
							return false;
						}
						if (Ext.isEmpty(records)) {
							alert (Msg.sMA0256);														//선택된 자료가 없습니다.
							return false;
						} 
						if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Proc') {					//자동기표 "실행"일 때~~~
				            var buttonFlag	= 'N';								//자동기표 FLAG
				            var procType	= 'B';								//C:개별, B:일괄
				            fnMakeLogTable(buttonFlag, procType);

						} else if (Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == 'Canc') {			//자동기표 "취소"일 때~~~
				            var buttonFlag	= 'D';								//자동기표 FLAG
				            var procType	= 'B';								//C:개별, B:일괄
				            fnMakeLogTable(buttonFlag, procType);
						}
					}
				}]
			}]
		}]
	});

		        
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('abh900ukrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	excelTitle: '미착대체자동기표',
        uniOpt: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: true,	
		    useGroupSummary		: true,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
		tbar: [{
			xtype: 'button',
			text: '자동기표조회',
			itemId: 'btnViewAutoSlip',
			handler: function() {
				var record = masterGrid.getSelectedRecord();
				
				if(Ext.isEmpty(record)){
					alert(Msg.sMA0256);
					return false;	
				} else {
					if(Ext.isEmpty(record.data.EX_NUM)){
						alert('결의일이 없는 데이터는 조회할 수 없습니다.'/*Msg.sMA0256*/);
						return false;	
					}
				}

				var params = {
					'PGM_ID'	: 'abh900ukr',
					'DIV_CODE'	: record.data.DIV_CODE,
					'SLIP_NUM'	: record.data.EX_NUM,
					'EX_DATE'	: record.data.EX_DATE,
					'EX_SEQ'	: '1',						//회계전표순번
					'AP_STS'	: '', 
					'INPUT_PATH': '70'						//이체지급자동기표
				}
				var rec = {data : {prgID : 'agj105ukr', 'text':''}};       
				parent.openTab(rec, '/accnt/agj105ukr.do', params);
			}
        }],
    	store: masterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
    		listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					selectedAmt = selectedAmt + selectRecord.data.INOUT_AMT_I;
					addResult.setValue('SELECTED_AMT', selectedAmt)
    			},
    			
	    		deselect:  function(grid, selectRecord, index, rowIndex, eOpts ){
					selectedAmt = selectedAmt - selectRecord.data.INOUT_AMT_I;
					addResult.setValue('SELECTED_AMT', selectedAmt)
	    		}
    		}
        }),
        columns:  [{
				xtype	: 'rownumberer', 
				sortable: false, 
				//locked: true, 
				width	: 35,
				align	: 'center  !important',
				resizable: true},
            { dataIndex: 'AUTO_NUM'             , width:50, hidden: true},
			{ dataIndex: 'NOTE_NUM'				, width:120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
                }
        	},
			{ dataIndex: 'PUB_DATE'				, width:120	},
			{ dataIndex: 'OC_AMT_I'				, width:140, summaryType:'sum'	},
			{ dataIndex: 'EXP_DATE'				, width:120 },
        	{ dataIndex: 'PUB_COMPANY_NUM'		, width:140 },				
			{ dataIndex: 'PUB_MAN'				, width:140	},
			{ dataIndex: 'PUB_TOT_NAME'			, width:120	},
			{ dataIndex: 'CUSTOM_CODE'			, width:140	},
			{ dataIndex: 'DIV_CODE'				, width:140	},
			{ dataIndex: 'DEPT_CODE'			, width:140 },
			{ dataIndex: 'DEPT_NAME'			, width:160 },
			{ dataIndex: 'EX_DATE'				, width:120	},
			{ dataIndex: 'EX_NUM'				, width:100	},
			{ dataIndex: 'AGREE_YN'				, width:100	},
			{ dataIndex: 'AC_DATE'				, width:120	},
			{ dataIndex: 'SLIP_NUM'				, width:100	},
			{ dataIndex: 'AUTO_SLIP_NUM'		, width:100		,hidden: true}
        ],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(!UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME', 'REMARK2', 'IN_GUBUN'])){
					return false;
				}
			}	
		}
    });   
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, 
				panelResult,
				{
					region : 'north',
					xtype : 'container',
					highth: 20,
					layout : 'fit',
					items : [ addResult ]
				}
			]
		},
			panelSearch  	
		],
		id: 'abh900ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO', UniDate.get('today'));
			panelResult.setValue('DATE_TO', UniDate.get('today'));
			addResult.setValue('EX_DATE', UniDate.get('today'));

			addResult.getField('WORK_DIVI').setValue('1');
			addResult.getField('EX_DATE').setReadOnly(true);
   			Ext.getCmp('procCanc').setText('개별자동기표');
   			Ext.getCmp('procCanc2').setText('일괄자동기표');

	   		addResult.setValue('SELECTED_AMT', 0);
	   		
	   		masterGrid.down('#btnViewAutoSlip').disable(true);	//자동기표조회

			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);

			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('DATE_FR');		
		},
		
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()){
				return false;
			}
            UniAppManager.setToolbarButtons('delete', false);
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			masterGrid.reset();
			masterStore.clearData();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			masterStore.loadStoreRecords();	
		},

//		onDeleteDataButtonDown: function() {
//			var selRow = masterGrid.getSelectedRecord();						
//			console.log("selRow",selRow);
//			
//			if (selRow.phantom == true) {
//				masterGrid.deleteSelectedRow();
//				
//			} else if (confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {			//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
//				masterGrid.deleteSelectedRow();
//				UniAppManager.setToolbarButtons('save'	, true);
//			}
//		},
//		
//		onDeleteAllButtonDown: function() {			
//			var records = masterStore.data.items;
//			var isNewData = false;
//			Ext.each(records, function(record,i) {
//				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
//					isNewData = true;
//				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
//					if(confirm(Msg.sMB064)) {			//전체삭제 하시겠습니까?
//						var deletable = true;
//						if(deletable){		
//							masterGrid.reset();			
//							UniAppManager.app.onSaveDataButtonDown();	
//						}
//						isNewData = false;							
//					}
//					return false;
//				}
//			});
//			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
//				masterGrid.reset();
//				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
//			}
//		},
		
		onSaveDataButtonDown: function(config) {
			if(!this.isValidSearchForm()) {
				return false;
			}
//			if(!addResult.getInvalidMessage()) {
//				return false;
//			}
			masterStore.saveStore();
		},
		
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			newYN = 1;
			this.fnInitBinding();
		}
	});
	
	function fnMakeLogTable(buttonFlag, procType) {
		records = masterGrid.getSelectedRecords();

		buttonStore.clearData();															//buttonStore 클리어
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;											//자동기표 flag
			record.data.PROC_TYPE	= procType;												//개별/일괄 flag
			record.data.PROC_DATE	= UniDate.getDbDateStr(addResult.getValue('EX_DATE'));	//일괄자동기표일 때 전표일자 처리용(전표일)
            
            buttonStore.insert(index, record);
            
			//KEY_STRING이 같은 데이터는 한번만 실행
/*			if(!Ext.isEmpty(record.data.get('KEY_STRING'))) {								//자동기표는 KEY_STRING 값이 없으므로 그냥 진행						
            	buttonStore.insert(index, record);
			
			} else {																		//기표취소의 경우 KEY_STRING이 같으면 한번만 store에 insert
				var keyFlag = true;
				buttonRecords = buttonStore.getValues();
				Ext.each(buttonRecords, function(buttonRecord, i) {
					if(buttonRecord.data.get('KEY_STRING') == record.data.get('KEY_STRING')) {
						keyFlag = false;
					}
				});
				
				if (keyFlag) {
    				buttonStore.insert(index, record);
				}
			}	*/
			
			if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
			}
		});
	}
};

</script>
