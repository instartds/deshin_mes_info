<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb100skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="agb100skr"  /> 						<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> 							<!-- 입력경로 -->	
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 							<!-- 환종 -->	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default 
 {color: #333333;font-weight: normal;padding: 1px 2px;}   
 
</style>	
</t:appConfig>
<script type="text/javascript" >

var bAmtI = 0;							//잔액 계산용 전역변수
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;								//당기시작월 관련 전역변수
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수


function appMain() {
	
	
	/*   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb100skrModel', {		
	    fields: [{name: 'ACCNT'   		 	,text: '계정코드' 			,type: 'string'},	    		
				 {name: 'ACCNT_NAME'   	 	,text: '계정과목명' 			,type: 'string'},	    		
				 {name: 'AC_DATE'   	 	,text: '전표일' 			,type: 'string'},	    		
				 {name: 'DR_AMT_TOT_I'	 	,text: '차변금액' 			,type: 'uniPrice'},	    		
				 {name: 'CR_AMT_TOT_I'   	,text: '대변금액' 			,type: 'uniPrice'},	    		
				 {name: 'B_AMT_I'  		 	,text: '잔액' 			,type: 'uniPrice'},	    		
				 {name: 'JAN_DIVI'   	 	,text: '잔액구분' 			,type: 'string'}, 
				 {name: 'GUBUN'   	 		,text: '구분' 			,type: 'string'},
				 {name: 'common_total'   	,text: 'common_total' 	,type: 'string'}
		]
	});	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('agb100skrMasterStore1',{
		model: 'Agb100skrModel',
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
            	   read: 'agb100skrService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
          	load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 그리드에 포커스 가도록 변경
				if(store.getCount() > 0){
		    		masterGrid.focus();
				//조회된 데이터가 없을 때, 패널의 첫번째 필드에 포커스 가도록 변경
	    		}else{
					var activeSForm ;		
					if(!UserInfo.appOption.collapseLeftSearch)	{	
						activeSForm = panelSearch;	
					}else {		
						activeSForm = panelResult;
					}		
					activeSForm.onLoadSelectText('AC_DATE_FR');	
				}
			}          		
      	}, 
		groupField: 'ACCNT'
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '검색조건',         
		defaultType: 'uniSearchSubPanel',
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
			    startFieldName: 'AC_DATE_FR',
			    endFieldName: 'AC_DATE_TO',
			    allowBlank: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('AC_DATE_FR', newValue);
						UniAppManager.app.fnSetStDate(newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('AC_DATE_TO', newValue);				    		
			    	}
			    }
			},{
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
//			    width: 325,
			    listeners: {
			      change: function(field, newValue, oldValue, eOpts) {      
			       panelResult.setValue('ACCNT_DIV_CODE', newValue);
			      }
	     		}
			},		    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
		    	valueFieldName: 'ACCNT_CODE_FR',
		    	textFieldName: 'ACCNT_NAME_FR',
		    	autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE_FR', panelSearch.getValue('ACCNT_CODE_FR'));
							panelResult.setValue('ACCNT_NAME_FR', panelSearch.getValue('ACCNT_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE_FR', '');
						panelResult.setValue('ACCNT_NAME_FR', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
		    }),	    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '~',
				valueFieldName: 'ACCNT_CODE_TO',
		    	textFieldName: 'ACCNT_NAME_TO',  	
		    	autoPopup: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE_TO', panelSearch.getValue('ACCNT_CODE_TO'));
							panelResult.setValue('ACCNT_NAME_TO', panelSearch.getValue('ACCNT_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE_TO', '');
						panelResult.setValue('ACCNT_NAME_TO', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
	    	})]
		}, {
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '당기시작년월',
				name: 'START_DATE',
				xtype: 'uniMonthfield',
				allowBlank: false
			},  Unilite.popup('DEPT',{
			        fieldLabel: '부서',
				    valueFieldName:'DEPT_CODE_FR',
				    textFieldName:'DEPT_NAME_FR',
		    		autoPopup: true,
//			        validateBlank:false,						//autoPopup: true, 추가하면서 주석처리
			        extParam:{'CUSTOM_TYPE':'3'}
		    }),
		      	Unilite.popup('DEPT',{
			        fieldLabel: '~',
				    valueFieldName:'DEPT_CODE_TO',
				    textFieldName:'DEPT_NAME_TO',
		    		autoPopup: true,
//			        validateBlank:false,						//autoPopup: true, 추가하면서 주석처리
					extParam:{'CUSTOM_TYPE':'3'}
		    }),{
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '과목명',
	    		id: 'radio1',
	    		items: [{
	    			boxLabel: '과목명1', width: 82, name: 'ACCOUNT_NAME', inputValue: '0'
	    		}, {
	    			boxLabel: '과목명2', width: 82, name: 'ACCOUNT_NAME', inputValue: '1'
	    		}, {
	    			boxLabel: '과목명3', width: 82, name: 'ACCOUNT_NAME', inputValue: '2'
	    		}]
	        }
			]		
		}]
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns :	2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'AC_DATE_FR',
	        endFieldName: 'AC_DATE_TO',
//	        width: 315,
/*			startDate, endDate: fnInitBinding에서 설정
		    startDate: UniDate.get('startOfMonth'),
		    endDate: UniDate.get('today'),				*/
	        allowBlank: false,                	
	        tdAttrs: {width: 380},  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR', newValue);
					UniAppManager.app.fnSetStDate(newValue);
				}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('AC_DATE_TO', newValue);				    		
		    	}
		    }
        },{
	        fieldLabel: '사업장',
		    name:'ACCNT_DIV_CODE', 
		    xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
//		    width: 325,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
				panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
     		}
		},		    
	    	Unilite.popup('ACCNT',{
	    	fieldLabel: '계정과목',
	    	valueFieldName: 'ACCNT_CODE_FR',
	    	textFieldName: 'ACCNT_NAME_FR',
	    	autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCNT_CODE_FR', panelResult.getValue('ACCNT_CODE_FR'));
						panelSearch.setValue('ACCNT_NAME_FR', panelResult.getValue('ACCNT_NAME_FR'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ACCNT_CODE_FR', '');
					panelSearch.setValue('ACCNT_NAME_FR', '');
				},
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
	    }),		    
	    Unilite.popup('ACCNT',{
	    	fieldLabel: '~',
			valueFieldName: 'ACCNT_CODE_TO',
	    	textFieldName: 'ACCNT_NAME_TO', 
	    	autoPopup: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ACCNT_CODE_TO', panelResult.getValue('ACCNT_CODE_TO'));
						panelSearch.setValue('ACCNT_NAME_TO', panelResult.getValue('ACCNT_NAME_TO'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ACCNT_CODE_TO', '');
					panelSearch.setValue('ACCNT_NAME_TO', '');
				},
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
				
			}
    	})
	    ]
    });
 
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agb100skrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: MasterStore,
    	selModel:'rowmodel',
    	uniOpt:{
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
	    	filter: {
				useFilter		: true,		
				autoCreate		: true		
			}
		},
        tbar: [{
        	text:'출력',
        	handler: function() {
				var params = {
//					action:'select',
					'PGM_ID'        : 'agb100skr',
					'AC_DATE_FR'	: panelSearch.getValue('AC_DATE_FR'),
					'AC_DATE_TO'	: panelSearch.getValue('AC_DATE_TO'),
					'ACCOUNT_NAME'  : Ext.getCmp('radio1').getChecked()[0].inputValue,
					'DIV_CODE'      : panelSearch.getValue('ACCNT_DIV_CODE'),
					'P_ACCNT_CD'	: panelSearch.getValue('P_ACCNT_CD'),
					'P_ACCNT_NM'	: panelSearch.getValue('P_ACCNT_NM'),
					'CHECK_DELETE'	: panelSearch.getValue('CHECK_DELETE'),
					'CHECK_POST_IT'	: panelSearch.getValue('CHECK_POST_IT'),
					'POST_IT'		: panelSearch.getValue('POST_IT'),
					'START_DATE'	: panelSearch.getValue('START_DATE'),
					'CHARGE_CODE'	: panelSearch.getValue('CHARGE_CODE'),
					'CHARGE_NAME'	: panelSearch.getValue('CHARGE_NAME'),
					'AMT_FR'		: panelSearch.getValue('AMT_FR'),
					'AMT_TO'		: panelSearch.getValue('AMT_TO'),
					'REMARK'		: panelSearch.getValue('REMARK'),
					'FOR_AMT_FR'	: panelSearch.getValue('FOR_AMT_FR'),
					'FOR_AMT_TO'	: panelSearch.getValue('FOR_AMT_TO'),
					'DEPT_CODE_FR'  : panelSearch.getValue('DEPT_CODE_FR'),
                    'DEPT_NAME_FR'  : panelSearch.getValue('DEPT_NAME_FR'),
                    'DEPT_CODE_TO'  : panelSearch.getValue('DEPT_CODE_TO'),
                    'DEPT_NAME_TO'  : panelSearch.getValue('DEPT_NAME_TO'),
					'ACCNT_CODE_FR'	: panelSearch.getValue('ACCNT_CODE_FR'),
					'ACCNT_NAME_FR'	: panelSearch.getValue('ACCNT_NAME_FR'),
					'ACCNT_CODE_TO'	: panelSearch.getValue('ACCNT_CODE_TO'),
					'ACCNT_NAME_TO'	: panelSearch.getValue('ACCNT_NAME_TO')
				}
        		//전송
          		var rec1 = {data : {prgID : 'agb100rkr', 'text':''}};							
				parent.openTab(rec1, '/accnt/agb100rkr.do', params);	
        	}
        }],
	    
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [ { dataIndex:'GUBUN'   		 , 	width:100	, hidden:true},
        			{ dataIndex:'ACCNT'   		 , 	width:100, 
						//합계행은 계정코드, 계정과목명 생략
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("AC_DATE") == "소계(월)"){
								metaData.tdCls = 'x-change-cell_light';
							}
							else if(record.get("AC_DATE") == "합계") {
								metaData.tdCls = 'x-change-cell_normal';
							}
							
							if(record.get('GUBUN') == '6'){
								return '';
							}else{
								return val;
							}
						}				
					},
					{ dataIndex:'ACCNT_NAME'   	 , 	width:166, 
						//합계행은 계정코드, 계정과목명 생략
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {
							if(record.get("AC_DATE") == "소계(월)"){
								metaData.tdCls = 'x-change-cell_light';
							}
							else if(record.get("AC_DATE") == "합계") {
								metaData.tdCls = 'x-change-cell_normal';
							}
							
							if(record.get('GUBUN') == '6'){
								return '';
							}else{
								return val;
							}
						}
					},
					{ dataIndex:'AC_DATE'   	 , 	width:133,
						renderer: function(value, metaData, record) {
							if(record.get("AC_DATE") == "소계(월)"){
								metaData.tdCls = 'x-change-cell_light';
							}
							else if(record.get("AC_DATE") == "합계") {
								metaData.tdCls = 'x-change-cell_normal';
							}
							return value;
						}	
					},				
					{ dataIndex:'DR_AMT_TOT_I'	 , 	width:200	, summaryType: 'sum',
						renderer: function(value, metaData, record) {
							if(record.get("AC_DATE") == "소계(월)"){
								metaData.tdCls = 'x-change-cell_light';
							}
							else if(record.get("AC_DATE") == "합계") {
								metaData.tdCls = 'x-change-cell_normal';
							}
							return Ext.util.Format.number(value,'0,000');
						}
					
					}, 				
					{ dataIndex:'CR_AMT_TOT_I'   , 	width:200	, summaryType: 'sum',
						renderer: function(value, metaData, record) {
							if(record.get("AC_DATE") == "소계(월)"){
								metaData.tdCls = 'x-change-cell_light';
							}
							else if(record.get("AC_DATE") == "합계") {
								metaData.tdCls = 'x-change-cell_normal';
							}
							return Ext.util.Format.number(value,'0,000');
						}
					}, 				
					{ dataIndex:'B_AMT_I'   	 , 	width:166, 
						renderer : function(val,metaData,record,rowIndex,colIndex,store,view) {	
							
							if(record.get("AC_DATE") == "소계(월)"){
								metaData.tdCls = 'x-change-cell_light';
							}
							else if(record.get("AC_DATE") == "합계") {
								metaData.tdCls = 'x-change-cell_normal';
							}
							
							var preRecord = store.getAt(rowIndex-1);
		         		 	//구분 값이 1(전월이월)일 경우 쿼리 그대로 뿌림
							if(record.get('GUBUN') == '1' || preRecord.get('GUBUN') == '6'){
								bAmtI = 0;
								return Ext.util.Format.number(val,'0,000');								
		         		 	//구분 값이 3일 경우 이전 row의 잔액컬럼과 합계 계산
							}else if(record.get('GUBUN') == '3'){
								return Ext.util.Format.number(val,'0,000');
								/* if(bAmtI == 0 && preRecord.get('GUBUN') != '6'){
									bAmtI = preRecord.get('B_AMT_I') + record.get('B_AMT_I');
								}else{
									bAmtI = bAmtI + record.get('B_AMT_I');
								} */
								return Ext.util.Format.number(bAmtI,'0,000');
							//구분 값이 4(소계(월))일 경우 잔액 컬럼은 공백처리
							}/* else if(record.get('GUBUN') == '4'){	
								return '';
		         		 	//구분 값이 6(합계)일 경우 쿼리 그대로 뿌림
							} */else if(record.get('GUBUN') == '6'){
									return Ext.util.Format.number(val,'0,000');								
//									return '<block style= "background-color:' + '#fcfac5' + '">' + Ext.util.Format.number(val,'0,000') + '</div>';
							}
						}
					}, 				
					{ dataIndex:'JAN_DIVI'   	 , 	width:153	, hidden:true}
        ],
		listeners: {
          	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	if (record.get('GUBUN') == '3') {
                	view.ownerGrid.setCellPointer(view, item);
            	}
        	},
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
        		if (record.get('GUBUN') == '3') {
                	if(grid.grid.contextMenu) {
                		var menuItem = grid.grid.contextMenu.down('#agb110Item');
                		if(menuItem) {
                			menuItem.handler();
                		}
                	}
            	}
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		if(record.get('GUBUN') == '3')	{
      			//menu.record = record;
      			//menu.showAt(event.getXY());
      			return true;
      		}
      	},
        uniRowContextMenu:{
			items: [{	
				text: '보조부 보기',   
				itemId:'agb110Item',
            	handler: function(menuItem, event) {
	            	var record = masterGrid.getSelectedRecord();
	            	var param = {
	            		'PGM_ID'		: 'agb100skr',
						'AC_DATE'		: record.data['AC_DATE'],
						'DIV_CODE'		: panelSearch.getValue('ACCNT_DIV_CODE'),
						'ACCNT' 		: record.data['ACCNT'],
						'ACCNT_NAME'	: record.data['ACCNT_NAME'],
						'START_DATE'	: panelSearch.getValue('START_DATE')
	            	};
            		masterGrid.gotoAgb110(param);
            	}
        	}]
	    },
		gotoAgb110:function(record)	{
			if(record)	{
		    	var params = record
			}
      		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agb110skr.do', params);
    	}/*,
	    onClickSummary:function()	{
	    	alert("Execute onClickSummary!!");
	    }*/
    }); 	
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'agb100skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			//사용자 ID에 따라 과목명 default 값 다르게 가져옴
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
//			UniAppManager.setToolbarButtons('detail',false);
//			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			//당기시작월 세팅
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelResult.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('AC_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			//초기화 시 전표일로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE_FR');
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.reset();
			MasterStore.clearData();
			masterGrid.getStore().loadStoreRecords();
		},
		//당기시작월 세팅
		fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        }
	});
};
</script>
