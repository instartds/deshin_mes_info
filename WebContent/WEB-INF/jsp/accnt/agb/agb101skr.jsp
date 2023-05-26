<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb101skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;				//당기시작월 관련 전역변수

function appMain() {
	/*  Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb101skrModel', {
	    fields: [{name: 'ACCNT'			 	,text: '계정코드' 			,type: 'string'},	    		
				 {name: 'ACCNT_NAME'   	 	,text: '계정과목명' 		,type: 'string'},			
				 {name: 'BOOKCODE_YN' 	 	,text: 'BOOKCODE_YN'	,type: 'string'},	    		
				 {name: 'IWALL_TOT_AMT'  	,text: '이월잔액' 			,type: 'uniPrice'},	    		
				 {name: 'DR_TOT_AMT'     	,text: '차변금액' 			,type: 'uniPrice'},	    		
				 {name: 'CR_TOT_AMT'     	,text: '대변금액' 			,type: 'uniPrice'},	    		
				 {name: 'JAN_TOT_AMT'    	,text: '잔액' 			,type: 'uniPrice'},	    		
				 {name: 'GUBUN'			 	,text: 'gubun' 			,type: 'string'}				 
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('agb101skrMasterStore',{
		model: 'Agb101skrModel',
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
            	   read: 'agb101skrService.selectList'                	
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
      	}
		//groupField: 'CUSTOM_NAME'			
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',         
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
//	        collapse: function () {
//	        	panelResult.show();
//	        },
//	        expand: function() {
//	        	panelResult.hide();
//	        }
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
//		        width: 470,
	/*			startDate, endDate: fnInitBinding에서 설정
			    startDate: UniDate.get('startOfMonth'),
			    endDate: UniDate.get('today'),				*/
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
//			    extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE
//			    			/* , 'ADD_QUERY': "" },  
				listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('ACCNT_CODE_FR', newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('ACCNT_NAME_FR', newValue);                                                                                                           
                    }
				}
		    }),	    
		    	Unilite.popup('ACCNT',{
		    	fieldLabel: '~',
				valueFieldName: 'ACCNT_CODE_TO',
		    	textFieldName: 'ACCNT_NAME_TO',  
                autoPopup: true,			
//			    extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE
//			    			/* , 'ADD_QUERY': "" },  
				listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('ACCNT_CODE_TO', newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('ACCNT_NAME_TO', newValue);                                                                                                           
                    }
				}
	    	}),  
                Unilite.popup('DEPT',{
                    fieldLabel: '부서',
                    valueFieldName:'DEPT_CODE_FR',
                    textFieldName:'DEPT_NAME_FR',
                    autoPopup: true,
                    validateBlank:false,
                    listeners: {
                        'onValueFieldChange': function(field, newValue, oldValue  ){
                                panelResult.setValue('DEPT_CODE_FR', newValue);
                        },
                        'onTextFieldChange':  function( field, newValue, oldValue  ){
                                panelResult.setValue('DEPT_NAME_FR', newValue);                                                                                                           
                        }
                    }
            }),
                Unilite.popup('DEPT',{
                    fieldLabel: '~',
                    valueFieldName:'DEPT_CODE_TO',
                    textFieldName:'DEPT_NAME_TO',
                    autoPopup: true,
                    validateBlank:false,
                    listeners: {
                        'onValueFieldChange': function(field, newValue, oldValue  ){
                                panelResult.setValue('DEPT_CODE_TO', newValue);
                        },
                        'onTextFieldChange':  function( field, newValue, oldValue  ){
                                panelResult.setValue('DEPT_NAME_TO', newValue);                                                                                                           
                        }
                    }
            })]
		},{
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [ {
				fieldLabel: '당기시작년월',
				name: 'START_DATE',
				xtype: 'uniMonthfield',
				allowBlank: false
			}/*,{
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
	        }*/]		
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
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
			tdAttrs: {width: 350},  
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
            tdAttrs: {width: 350},  		
            colspan: 2,
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
			tdAttrs: {width: 350},  
//			    extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE
//			    			/* , 'ADD_QUERY': "" },  
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                        panelSearch.setValue('ACCNT_CODE_FR', newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                        panelSearch.setValue('ACCNT_NAME_FR', newValue);                                                                                                           
                }
			}
	    }),		    
	    	Unilite.popup('ACCNT',{
	    	fieldLabel: '~',
//			labelWidth: 15,
			valueFieldName: 'ACCNT_CODE_TO',
	    	textFieldName: 'ACCNT_NAME_TO',  
            autoPopup: true,			
            colspan: 2,
//			    extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE
//			    			/* , 'ADD_QUERY': "" },  
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                        panelSearch.setValue('ACCNT_CODE_TO', newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                        panelSearch.setValue('ACCNT_NAME_TO', newValue);                                                                                                           
                }
			}
    	}),  
            Unilite.popup('DEPT',{
                fieldLabel: '부서',
                valueFieldName:'DEPT_CODE_FR',
                textFieldName:'DEPT_NAME_FR',
                autoPopup: true,            
                validateBlank:false,
                listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_CODE_FR', newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME_FR', newValue);                                                                                                           
                    }
                }
        }),
            Unilite.popup('DEPT',{
                fieldLabel: '~',
                valueFieldName:'DEPT_CODE_TO',
                textFieldName:'DEPT_NAME_TO',
                autoPopup: true,            
                validateBlank:false,
                colspan: 2,
                listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_CODE_TO', newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME_TO', newValue);                                                                                                           
                    }
                }
        })]	
    });
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agb101skrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: MasterStore,
		selModel	: 'rowmodel',
    	uniOpt:{
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
			useSqlTotal			: true,	
	    	filter: {
				useFilter		: true,		
				autoCreate		: true		
			}
		},
        tbar: [{ 
            text:'총계정원장출력',
            handler: function() {
                var win = Ext.create('widget.PDFPrintWindow', {
                    url: CPATH+'/agb/agb101rkr.do',
                    prgID: 'agb101rkr',
                    extParam: panelSearch.getValues()
                });
                win.center();
                win.show();
/*                var params = {
                    'AC_DATE_FR'      : panelSearch.getValue('AC_DATE_FR'),
                    'AC_DATE_TO'      : panelSearch.getValue('AC_DATE_TO'),
                    'ACCNT_DIV_CODE'  : panelSearch.getValue('ACCNT_DIV_CODE'),
                    'DEPT_CODE_FR'    : panelSearch.getValue('DEPT_CODE_FR'),
                    'DEPT_CODE_TO'    : panelSearch.getValue('DEPT_CODE_TO'),
                    'DEPT_NAME_FR'    : panelSearch.getValue('DEPT_NAME_FR'),
                    'DEPT_NAME_TO'    : panelSearch.getValue('DEPT_NAME_TO'),
                    'START_DATE'      : panelSearch.getValue('START_DATE')

                }
                //전송
                var rec1 = {data : {prgID : 'agb120rkr', 'text':''}};                           
                parent.openTab(rec1, '/accnt/agb120rkr.do', params);*/
                
            }
        }],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [ { dataIndex: 'ACCNT'		,width: 120,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					       return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
		            	}
	            	},
        			{ dataIndex: 'ACCNT_NAME'   ,width:	186},
        			{ dataIndex: 'BOOKCODE_YN'	,width:	186		, hidden: true},
        			{ dataIndex: 'IWALL_TOT_AMT',width:	180, summaryType: 'sum'},
        			{ dataIndex: 'DR_TOT_AMT'   ,width:	180, summaryType: 'sum'},
        			{ dataIndex: 'CR_TOT_AMT'   ,width:	180, summaryType: 'sum'},        			
        			{ dataIndex: 'JAN_TOT_AMT'  ,width: 180 , summaryType: 'sum'}/*,   
        			{ dataIndex: 'GUBUN'		,width:	20, hidden: true}*/
        ],
		listeners: {
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
    		},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
            	if (record.data['ACCNT'] != '합계' && record.data['ACCNT_NAME'] != '전일시제/당일시제'){
            		if(record.data['BOOKCODE_YN'] == 'N') {
						masterGrid.gotoAgb110skr(record);
            		} else {
						masterGrid.gotoAgb140skr(record);
            		}
//                    if(grid.grid.contextMenu) {
//                        var menuItem = grid.grid.contextMenu.down('#linkAgb110skr');
//                        if(menuItem) {
//                            menuItem.handler();
//                        }
//                    }   
                }
                
            }
    	},
	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			if (record.data['ACCNT'] == '합계' || record.data['ACCNT_NAME'] == '전일시제/당일시제'){
				return false;
				
			}else{
            	if (record.data['ACCNT'] != '합계' && record.data['ACCNT_NAME'] != '전일시제/당일시제'){
            		if(record.data['BOOKCODE_YN'] == 'N') {
						menu.down('#linkAgb110skr').show();
			      		menu.down('#linkAgb140skr').hide();
			      		
            		} else {
						menu.down('#linkAgb110skr').hide();
			      		menu.down('#linkAgb140skr').show();
            		}
            	}				
				return true;
			}
  		},
        uniRowContextMenu:{
			items: [{
            	text: '보조부  보기',   
            	itemId	: 'linkAgb110skr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		masterGrid.gotoAgb110skr(param);
            	}
        	},{
            	text: '계정명세  보기',   
            	itemId	: 'linkAgb140skr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		masterGrid.gotoAgb140skr(param);
            	}
        	}]
	    },
		gotoAgb110skr:function(record)	{
			if(record)	{
        		var record	= masterGrid.getSelectedRecord();
				var params	= {
					'PGM_ID'			: 'agb101skr',
					'START_DATE'		: panelSearch.getValue('START_DATE'),
					'ACCNT' 			: record.data['ACCNT'],
					'ACCNT_NAME'		: record.data['ACCNT_NAME'],
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'AC_DATE_FR'		: panelSearch.getValue('AC_DATE_FR'),
					'AC_DATE_TO'		: panelSearch.getValue('AC_DATE_TO')
				};
			}
	  		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agb110skr.do', params);
    	},
		gotoAgb140skr:function(record)	{
			if(record)	{
        		var record	= masterGrid.getSelectedRecord();
				var params	= {
					'PGM_ID'			: 'agb101skr',
					'START_DATE'		: panelSearch.getValue('START_DATE'),
					'ACCNT' 			: record.data['ACCNT'],
					'ACCNT_NAME'		: record.data['ACCNT_NAME'],
					'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
					'AC_DATE_FR'		: panelSearch.getValue('AC_DATE_FR'),
					'AC_DATE_TO'		: panelSearch.getValue('AC_DATE_TO')
				};
			}
	  		var rec1 = {data : {prgID : 'agb140skr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agb140skr.do', params);
    	},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('ACCNT_DIVI') == '2') {
					cls = 'x-change-cell_light';
				}else if(record.get('ACCNT_DIVI') == '1'){
					cls = 'x-change-cell_medium_light';
				} else if(record.get('ACCNT_DIVI') == '0'){ 
					cls = 'x-change-cell_normal';
					
				} else if(record.get('ACCNT') == '합계') {
					cls = 'x-change-cell_dark';
				}
				
				if(record.get('GUBUN') == '2'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }
    });   
	
    Unilite.Main( {
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'agb101skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			//사용자 ID에 따라 과목명 default 값 다르게 가져옴
//			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			//당기시작월 세팅
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			panelSearch.setValue('AC_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('AC_DATE_FR',UniDate.get('today'));
			panelResult.setValue('AC_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('AC_DATE_FR');		
		}
		,
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
