<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd370ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 --> 
	<t:ExtComboStore comboType="A" comboCode="A118" /> 				<!-- 소득구분 -->
<style type="text/css">	

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
//조회된 합계, 건수 계산용 변수 선언
var sumTaxAmtI = 0;
	sumCheckedCount = 0;
	newYN = 0;

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            read    : 'agd370ukrService.selectList',
		    create	: 'agd370ukrService.runProcedure',
            syncAll	: 'agd370ukrService.callProcedure'
		}
	});	

	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agd370ukrModel1', {
		fields: [
            {name: 'COMP_CODE'          ,text: 'COMP_CODE'     ,type: 'string'},
            {name: 'LOANNO'             ,text: '차입금코드'    ,type: 'string'},
            {name: 'LOAN_NAME'          ,text: '차입금명'      ,type: 'string'},
            {name: 'PUB_DATE'           ,text: '차입일자'      ,type: 'uniDate'},
            {name: 'BASE_DATE'          ,text: '이자지급일'    ,type: 'uniDate'},
            {name: 'SEQ'                ,text: '순번'        ,type: 'string'},
            {name: 'DIV_CODE'           ,text: 'DIV_CODE'      ,type: 'string'     ,comboType: 'BOR120'},
            {name: 'CHOICE'             ,text: '선택'        ,type: 'string'},
            {name: 'DAY_CNT'            ,text: '이자일수'      ,type: 'string'},
            {name: 'BLN_DATE'           ,text: '결산기준일'    ,type: 'uniDate'},
            {name: 'BLN_DAY_CNT'        ,text: '결산일수'      ,type: 'string'},
            {name: 'TREAT_TYPE'         ,text: '처리유형'      ,type: 'string'     ,comboType: "AU", comboCode: "A369"},
            {name: 'EX_REPAY_AMT'       ,text: '만기상환액'     ,type: 'uniPrice'},
            {name: 'CASH_INT'           ,text: '현금이자'      ,type: 'uniPrice'},
            {name: 'EX_DATE'            ,text: '결의일자'      ,type: 'uniDate'},
            {name: 'EX_NUM'             ,text: '번호'        ,type: 'int'},
            {name: 'AP_STS'             ,text: '전표승인여부' ,type: 'string'     ,comboType: "AU", comboCode: "A014"},
            {name: 'AP_STS_NM'          ,text: '전표승인여부' ,type: 'string'},
            {name: 'AUTO_NUM'           ,text: 'AUTO_NUM'   ,type: 'string'}
 

	    	]
	});
	


	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('agd370ukrmasterStore',{
		model	: 'Agd370ukrModel1',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 	
			deletable	: false,		// 삭제 가능 여부 	
			useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: true,
        proxy	: {
            type: 'direct',
            api	: {			
            	   read: 'agd370ukrService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param.PROC_DATE	= UniDate.getDbDateStr(addResult.getValue('PROC_DATE'));
			param.PROC_FLAG	= Ext.getCmp('rdoSelect1').getChecked()[0].inputValue;
			param.WORK_DIVI	= Ext.getCmp('rdoSelect2').getChecked()[0].inputValue;

           
			console.log( param );
			this.load({
				params : param
			});
			Ext.getCmp('procCanc').disable();
			Ext.getCmp('procCanc2').disable();
		}			
	});

    var buttonStore = Unilite.createStore('Agd370UkrButtonStore',{      
        uniOpt	: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,      		// 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy	: directButtonProxy,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

            var paramMaster= panelSearch.getValues();
            
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
                var grid = Ext.getCmp('agd370ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
    
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',		
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
			title	: '기본정보', 	
   			itemId	: 'search_panel1',
           	layout	: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items	: [{ 
    			fieldLabel	: '기준일',
		        xtype		: 'uniDateRangefield',
		        startFieldName	: 'DATE_FR',
		        endFieldName	: 'DATE_TO',
//		        width: 470,
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
			},
		    Unilite.popup('DEBT_NO',{
		        fieldLabel		: '차입금번호',
		        validateBlank	: false,
			    valueFieldName	: 'DEBT_NO_CODE',
			    textFieldName	: 'DEBT_NO_NAME',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEBT_NO_CODE', panelSearch.getValue('DEBT_NO_CODE'));
							panelResult.setValue('DEBT_NO_NAME', panelSearch.getValue('DEBT_NO_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEBT_NO_CODE', '');
						panelResult.setValue('DEBT_NO_NAME', '');
					}
				}
			}),
			{
	     		fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				value		: UserInfo.divCode,
				comboType	: 'BOR120',
				multiSelect	: true, 
				typeAhead	: false,
				listeners	: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
			}]		
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3	
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{ 
			fieldLabel	: '기준일',
// 		    width: 315,
	        xtype		: 'uniDateRangefield',
	        startFieldName	: 'DATE_FR',
	        endFieldName	: 'DATE_TO',
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
        },
        Unilite.popup('DEBT_NO',{
            fieldLabel      : '차입금번호',
            valueFieldName  : 'DEBT_NO_CODE',
            textFieldName   : 'DEBT_NO_NAME',
            tdAttrs         : {width: 380}, 
            listeners       : {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('DEBT_NO_CODE', panelResult.getValue('DEBT_NO_CODE'));
                        panelSearch.setValue('DEBT_NO_NAME', panelResult.getValue('DEBT_NO_NAME'));

                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('DEBT_NO_CODE', '');
                    panelSearch.setValue('DEBT_NO_NAME', '');
                },
                applyextparam: function(popup){
                    
                }
            }
        }),{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
            tdAttrs		: {width: 380}, 
			multiSelect	: true, 
			typeAhead	: false,   
			listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
		}]
    });  

	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3, tdAttrs: {width: '100%'/*, style: 'border : 1px solid #ced9e7;'*/}
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
		items: [{
			xtype: 'container',
			layout : {type : 'uniTable'},
			tdAttrs: {width: 380},    
	    	items:[{
				fieldLabel	: '실행일',
	            xtype		: 'uniDatefield',
			 	name		: 'PROC_DATE',
		        value		: UniDate.get('today'),
				readOnly	: true,
			 	allowBlank	: false,
			 	width		: 220,
	        	listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
					}
				}
	     	},{
				xtype		: 'radiogroup',		            		
				fieldLabel	: '',						            		
				id			: 'rdoSelect1',
				items		: [{
					boxLabel	: '이자지급일', 
					name		: 'PROC_FLAG',
	    			inputValue	: '1',
					width		: 100
                    
				},{
					boxLabel	: '실행일', 
					name		: 'PROC_FLAG',
	    			inputValue	: '2',
					width		: 70  
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						if(addResult.getValue('PROC_FLAG') == '1'){ //이자지급일선택
							addResult.getField('PROC_DATE').setReadOnly(true);
						}else{ //실행일선택
							addResult.getField('PROC_DATE').setReadOnly(false);
						}
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
	    	items	: [{
	    		xtype		: 'radiogroup',		            		
				fieldLabel	: '작업구분',						            		
				id			: 'rdoSelect2',
				tdAttrs		: {align: 'left'},
				items		: [{
					boxLabel	: '자동기표', 
					name		: 'WORK_DIVI',
					width		: 90, 
	    			inputValue	: '1',
					checked: true  
				},{
					boxLabel	: '기표취소', 
					name		: 'WORK_DIVI',
					width		: 90,
	    			inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
			    		if(newValue.WORK_DIVI == 1){
		       				Ext.getCmp('procCanc').setHidden(false);
		       				Ext.getCmp('procCanc').setText('일괄자동기표');
		       				Ext.getCmp('procCanc2').setText('개별자동기표');
		
		   				}else {
		       				Ext.getCmp('procCanc').setHidden(true);
		       				Ext.getCmp('procCanc2').setText('기표취소');
		       			}

						//if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
						//	newYN = '0'
						//	return false;
						//}else {
						//	UniAppManager.app.onQueryButtonDown();	
						//}	
					}
				}
			}]
		},{
			//컬럼 맞춤용
			xtype	: 'component'
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2, tdAttrs: {width: '100%'}},
			colspan	: 2,
	    	items	: [{
				xtype		: 'uniNumberfield',		            		
				fieldLabel	: '합계(선택)',
				name		: 'SELECTED_AMT',
				readOnly	: true,
				tdAttrs		: {align: 'right'},
				value		: 0,	
				labelWidth	: 60,					            		
				width		: 200
			},{
				xtype		: 'uniNumberfield',		            		
				fieldLabel	: '건수(선택)',
				name		: 'COUNT',
				readOnly	: true,
				tdAttrs		: {align: 'right'},
				labelWidth	: 100,						            		
				width		: 160,
				value		: 0
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right'},
			width	: 210,
			items	: [{				   
				xtype	: 'button',
				//name: 'CONFIRM_CHECK',
				id		: 'procCanc',
				text	: '일괄자동기표',
		 		tdAttrs	: {align: 'right'},
				width	: 100,
				handler : function() {
					if(!addResult.getInvalidMessage()){						//조회전 필수값 입력 여부 체크
						return false;
					}
		            var buttonFlag = 'AS';									//일괄자동기표 FLAG		
		            fnMakeLogTable(buttonFlag);								
				}
			},{				   
				xtype	: 'button',
				//name: 'CONFIRM_CHECK',
				id		: 'procCanc2',
				text	: '개별자동기표',
		 		tdAttrs	: {align: 'right'},
				width	: 100,
				handler : function() {
					if(!addResult.getInvalidMessage()){						//조회전 필수값 입력 여부 체크
						return false;
					}
					//자동기표일 때 SP 호출
					if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '1'){
			            var buttonFlag = 'IS';								//개별자동기표 FLAG
			            fnMakeLogTable(buttonFlag);							//개별자동기표취소 FLAG
					}
					//기표취소일 때 SP 호출
					if(Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2'){
    					var checkFlag = true;								//기표취소시, 승인된 전표 체크하기 위한 flag 
						records = masterGrid.getSelectedRecords();
						Ext.each(records, function(record, index) {
			    			if (record.get('AP_STS') == '2') {
			    				alert('해당 ' +record.get('LOAN_NUM') + '(은)는 ' + Msg.fSbMsgA0380);
			    				checkFlag = false; 
			    				return false;
			    			} 
						});
						if (checkFlag) {
				            var buttonFlag = 'C';
				            fnMakeLogTable(buttonFlag);
						}
					}
				}
			}]
		}]
	});
	
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agd370ukrGrid', {  	
    	store	: masterStore,
        layout	: 'fit',
        region	: 'center',
    	excelTitle: '차입금자동기표(자동기표)',
        uniOpt	: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,	
		    useGroupSummary		: false,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
    	features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
    	           	{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
    		listeners: { 
    			beforeselect: function( grid , record , index , eOpts ) {
	    			//기표취소일 때, 승인여부가 승인이면 선택 안 됨 (atx110ukr로 링크와 관련해서 주석 - 기표 취소 로직에서 안되도록 수정)
	    			if (Ext.getCmp('rdoSelect2').getChecked()[0].inputValue == '2'&& record.get('AP_STS') == '2') {
	    				alert('이미 승인된 자료는 기표취소할 수 없습니다.');
	    				return false;
	    			}
    			},  
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
	    			sumTaxAmtI = sumTaxAmtI + selectRecord.get('CASH_INT');
					sumCheckedCount = sumCheckedCount + 1;
	    			addResult.setValue('SELECTED_AMT', sumTaxAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
	    			
					if(this.selected.getCount() > 0){
						Ext.getCmp('procCanc').enable();
						Ext.getCmp('procCanc2').enable();
    				}
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			sumTaxAmtI = sumTaxAmtI - selectRecord.get('CASH_INT');
					sumCheckedCount = sumCheckedCount - 1;
	    			addResult.setValue('SELECTED_AMT', sumTaxAmtI)
	    			addResult.setValue('COUNT', sumCheckedCount)
	    			
	    			if (this.selected.getCount() <= 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
						Ext.getCmp('procCanc').disable();
						Ext.getCmp('procCanc2').disable();
	    			}
	    		}
    		}
        }),
        columns:  [{
				xtype	: 'rownumberer', 
				width	: 35,
				align	: 'center  !important',
				sortable: false, 
				resizable: true
			},
//          { dataIndex: 'CHOICE'               ,width:66   },
            { dataIndex: 'LOANNO'            ,width:100  ,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<span style= "color:' + 'blue' + '">' + Msg.sMAP025 + '</span>');
                }
            },
            { dataIndex: 'LOAN_NAME'            ,width:100  },
            { dataIndex: 'PUB_DATE'         ,width:120  },
            { dataIndex: 'BASE_DATE'           ,width:100  },
            { dataIndex: 'SEQ'                  ,width:66   },
            { dataIndex: 'DAY_CNT'              ,width:100  },
            { dataIndex: 'BLN_DATE'              ,width:100  },
            { dataIndex: 'BLN_DAY_CNT'              ,width:100  },
            { dataIndex: 'TREAT_TYPE'              ,width:100  },
            { dataIndex: 'CASH_INT'          ,width:120      ,summaryType: 'sum'     ,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '','<div align="right">' + '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(value,'0,000') + '</span>' + '</div>');
                }
            },
            { dataIndex: 'EX_DATE'              ,width:100  },
            { dataIndex: 'EX_NUM'               ,width:100 , format:'0' },
            { dataIndex: 'AP_STS'               ,width:100  },
            { dataIndex: 'AP_STS_NM'            ,width:100      ,hidden: true},
            { dataIndex: 'AUTO_NUM'             ,width:50       ,hidden: true},
            { dataIndex: 'COMP_CODE'            ,width:80       ,hidden: true},
            { dataIndex: 'DIV_CODE'             ,width:80       ,hidden: true},
            { dataIndex: 'PROC_DATE'            ,width:80       }
            
		] 
    });   

    
    Unilite.Main( {
		id			: 'agd370ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
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
		
		fnInitBinding : function() {
			//각 기본값 설정
			panelSearch.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO', UniDate.get('today'));

			panelResult.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_TO', UniDate.get('today'));

			addResult.setValue('PROC_DATE', UniDate.get('today'));
			addResult.getField('PROC_FLAG').setValue('2');
			addResult.getField('WORK_DIVI').setValue('1');
			Ext.getCmp('procCanc').setText('일괄자동기표');
   			Ext.getCmp('procCanc2').setText('개별자동기표');
			Ext.getCmp('procCanc').disable();
			Ext.getCmp('procCanc2').disable();
			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);

			//toolbar button 설정
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);

			//화면 초기화 시 포커스 설정
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('DATE_FR');		
			newYN = 0;	
		},
		
		onQueryButtonDown : function()	{	
			//if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
		//		return false;
		//	}
			sumTaxAmtI = 0;
			sumCheckedCount = 0;
			addResult.setValue('SELECTED_AMT',0);
			addResult.setValue('COUNT',0);
			
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},
		
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			newYN = 1;
			this.fnInitBinding();
		}
	});
	
	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();											//buttonStore 클리어
		Ext.each(records, function(record, index) {
			record.phantom 			= true;
            record.data.OPR_FLAG    = buttonFlag;                                               //자동기표 flag
            //record.data.PROC_FLAG    = addResult.getValue('PROC_FLAG') ;                         //실행일 flag
			record.data.PROC_DATE	= UniDate.getDbDateStr(addResult.getValue('PROC_DATE'));	//일괄자동기표일 때 전표일자 처리용(실행일자)
			//alert(UniDate.getDbDateStr(addResult.getValue('PROC_DATE')));
            //alert(record.data.PROC_FLAG);
            //alert(record.data.PROC_DATE);
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore();
			}
		});
	}

};
</script>
