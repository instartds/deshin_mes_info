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
var getStDt = ${getStDt};				//당기시작월 관련 전역변수
var getChargeCode = ${getChargeCode};


function appMain() {
	
	
	/*   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb100skrModel', {		
	    fields: [{name: 'ACCNT'   		 			,text: '계정코드' 		,type: 'string'},	    		
				 {name: 'ACCNT_NAME'   	 			,text: '계정과목명' 		,type: 'string'},	    		
				 {name: 'AC_DATE'   	 			,text: '전표일' 		,type: 'string'},	    		
				 {name: 'DR_AMT_TOT_I'	 			,text: '차변금액' 		,type: 'uniPrice'},	    		
				 {name: 'CR_AMT_TOT_I'   			,text: '대변금액' 		,type: 'uniPrice'},	    		
				 {name: 'B_AMT_I'  		 			,text: '잔액' 		,type: 'uniPrice'},	    		
				 {name: 'JAN_DIVI'   	 			,text: '잔액구분' 		,type: 'string'}, 
				 {name: 'GUBUN'   	 				,text: '구분' 		,type: 'string'}
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
        pageSize: 25,
	    remoteSort: true,
	    sorters: [{
	        property: 'ACCNT',
	        direction: 'DESC'
	    }],
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'agb100skrService.selectList'                	
            },
            reader:{
            	totalProperty:'total'
            },
            extraParams: {'AC_DATE_FR':'20160301', 'AC_DATE_TO':'20150321', 'ACCOUNT_NAME':'0','START_DATE': '201601'}
        }
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		} ,
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
			    width: 470,
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
			    width: 325,
			    colspan:2,
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
			    extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE
			    			/*, 'ADD_QUERY': ""*/},  
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
					}
				}
		    }),	    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '~',
				valueFieldName: 'ACCNT_CODE_TO',
		    	textFieldName: 'ACCNT_NAME_TO',  			
			    extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE
			    			/*, 'ADD_QUERY': ""*/},  
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
			        validateBlank:false,
			        extParam:{'CUSTOM_TYPE':'3'}
		    }),
		      	Unilite.popup('DEPT',{
			        fieldLabel: '~',
				    valueFieldName:'DEPT_CODE_TO',
				    textFieldName:'DEPT_NAME_TO',
			        validateBlank:false,
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
		layout : {type : 'uniTable', columns :	3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'AC_DATE_FR',
	        endFieldName: 'AC_DATE_TO',
	        width: 315,
/*			startDate, endDate: fnInitBinding에서 설정
		    startDate: UniDate.get('startOfMonth'),
		    endDate: UniDate.get('today'),				*/
	        allowBlank: false,                	
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
		    width: 325,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
				panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
     		}
		},{
    		xtype: 'button',
			margin:'0 0 0 50',
    		text: '출력',	
    		id: 'PrintGo',
    		width: 100,	
			handler : function() {
				/*var params = {
					action:'select',
					'DIV_CODE' : record.data['DIV_CODE'],
					'ORG_AC_DATE' : record.data['ORG_AC_DATE'],
					'INPUT_PATH' : record.data['INPUT_PATH'],
					'ORG_SLIP_NUM' : record.data['ORG_SLIP_NUM'],
					'ORG_SLIP_SEQ' : record.data['ORG_SLIP_SEQ']
				}
				if(record.data['INPUT_PATH'] == 'A0' || record.data['INPUT_PATH'] == 'A1') {
					alert("기초잔액에서 등록된 자료이므로 전표가 존재하지 않습니다.");
  				} else {
  					if(record.data['INPUT_PATH'] == '2') {
						var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};							
						parent.openTab(rec1, '/accnt/agj205ukr.do', params);
					} else if(record.data['INPUT_PATH'] == 'Z3') {
						var rec2 = {data : {prgID : 'dgj100ukr', 'text':''}};							
						parent.openTab(rec2, '/accnt/dgj100ukr.do', params);
					} else {
						var rec3 = {data : {prgID : 'agj200ukr', 'text':''}};							
						parent.openTab(rec3, '/accnt/agj200ukr.do', params);
					}
  				}*/
			}
    	},		    
	    	Unilite.popup('ACCNT',{
	    	fieldLabel: '계정과목',
	    	valueFieldName: 'ACCNT_CODE_FR',
	    	textFieldName: 'ACCNT_NAME_FR',
		    extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE
		    			/*, 'ADD_QUERY': ""*/},  
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
				}
			}
	    }),		    
	    	Unilite.popup('ACCNT',{
	    	fieldLabel: '~',
			valueFieldName: 'ACCNT_CODE_TO',
	    	textFieldName: 'ACCNT_NAME_TO',  			
		    extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE
		    			/*, 'ADD_QUERY': ""*/},  
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
				}
			}
    		})
	    ]
    });
 
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agb100skrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: MasterStore,
    	selModel:'rowmodel',
    	uniOpt:{	
    		expandLastColumn:	false,
        	useRowNumberer: 	false,
			useMultipleSorting:	true,
			useRowContext : true
        },
        uniRowContextMenu:{
			items: [
	            {	text: '보조부 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAgb110(param.record);
	            	}
	        	}
	        ]
	    },
	    bbar: new Ext.PagingToolbar({
            pageSize: 25,
            store: MasterStore,
            displayInfo: true,
            displayMsg: '조회: {0} - {1} of {2}',
            emptyMsg: ""/*,
            items:[
                '-', {
                pressed: true,
                enableToggle:true,
                text: 'Show Preview',
                cls: 'x-btn-text-icon details',
                toggleHandler: function(btn, pressed){
                    var view = masterGrid.getView();
                    view.showPreview = pressed;
                    view.refresh();
                }
            }]*/
            
        }),
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
							
							var preRecord = store.getAt(rowIndex-1)
		         		 	//구분 값이 1(전월이월)일 경우 쿼리 그대로 뿌림
							if(record.get('GUBUN') == '1'){
								bAmtI = 0;
								return Ext.util.Format.number(val,'0,000');								
		         		 	//구분 값이 3일 경우 이전 row의 잔액컬럼과 합계 계산
							}else if(record.get('GUBUN') == '3'){
								if(bAmtI == 0){
									bAmtI = preRecord.get('B_AMT_I') + record.get('B_AMT_I');
								}else{
									bAmtI = bAmtI + record.get('B_AMT_I');
								}								
								return Ext.util.Format.number(bAmtI,'0,000');
							//구분 값이 4(소계(월))일 경우 잔액 컬럼은 공백처리
							}else if(record.get('GUBUN') == '4'){	
								return '';
		         		 	//구분 값이 6(합계)일 경우 쿼리 그대로 뿌림
							}else if(record.get('GUBUN') == '6'){
								return Ext.util.Format.number(val,'0,000');								
//								return '<block style= "background-color:' + '#fcfac5' + '">' + Ext.util.Format.number(val,'0,000') + '</div>';
							}
						}
					}, 				
					{ dataIndex:'JAN_DIVI'   	 , 	width:153	, hidden:true}
        ],
		listeners: {
          	onGridDblClick:function(grid, record, cellIndex, colName) {
				grid.ownerGrid.gotoAgb110(record);
          	},
          	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	if (record.get('GUBUN') == '3') {
                	view.ownerGrid.setCellPointer(view, item);
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
		gotoAgb110:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 'agb100skr',
					'AC_DATE' 			: record.data['AC_DATE'],
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'ACCNT' 			: record.data['ACCNT'],	
					'ACCNT_NAME' 		: record.data['ACCNT_NAME'],
					'START_DATE'		: panelSearch.getValue('START_DATE')
				}
		  		if (record.data['GUBUN'] == '3'){
		      		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
					parent.openTab(rec1, '/accnt/agb110skr.do', params);	
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
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			//당기시작월 세팅
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelResult.setValue('AC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('AC_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{			
				masterGrid.reset();
				MasterStore.clearData();
				masterGrid.getStore().loadStoreRecords();
				/*var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal = masterGrid.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);		*/		
				UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			MasterStore.clearData();
			this.fnInitBinding();
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
