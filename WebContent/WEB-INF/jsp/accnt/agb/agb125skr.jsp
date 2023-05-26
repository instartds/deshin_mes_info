<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb125skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt} ;				//당기시작월 관련 전역변수

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb125skrModel', {
	    fields: [{name: 'SEQ'			 	,text: 'SEQ' 		,type: 'string'},	    		
				 {name: 'ACCNT_DIVI'   	 	,text: 'ACCNT_DIVI' ,type: 'string'},	    		
				 {name: 'GUBUN'       	 	,text: 'GUBUN' 		,type: 'string'},	    		
				 {name: 'TOTAL_DR_AMT_I' 	,text: '계' 			,type: 'uniPrice'},	    		
				 {name: 'TOT_DR_AMT_I'   	,text: '대체' 		,type: 'uniPrice'},	    		
				 {name: 'TOT_A_DR_AMT_I' 	,text: '현금' 		,type: 'uniPrice'},	    		
				 {name: 'ACCNT'          	,text: '계정' 		,type: 'string'},	    		
				 {name: 'ACCNT_NAME'	 	,text: '계정과목' 		,type: 'string'},	    		
				 {name: 'TOT_A_CR_AMT_I' 	,text: '현금' 		,type: 'uniPrice'},	    		
				 {name: 'TOT_CR_AMT_I'	 	,text: '대체' 		,type: 'uniPrice'},	    		
				 {name: 'TOTAL_CR_AMT_I' 	,text: '계' 			,type: 'uniPrice'}
		]
	});		
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('agb125skrmasterStore1',{
		model: 'Agb125skrModel',
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
            	   read: 'agb125skrService.selectList'                	
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
//			groupField: 'CUSTOM_NAME'
	});
	/**
	 * 검색조건 (Search Panel)
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
		    }]
		},{ 
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '당기시작년월',
				name: 'START_DATE',
				xtype: 'uniMonthfield',
				allowBlank: false
			},  
				Unilite.popup('DEPT',{
			        fieldLabel: '부서',
				    valueFieldName:'DEPT_CODE_FR',
				    textFieldName:'DEPT_NAME_FR',
			        validateBlank:false
		    }),
		      	Unilite.popup('DEPT',{
			        fieldLabel: '~',
				    valueFieldName:'DEPT_CODE_TO',
				    textFieldName:'DEPT_NAME_TO',
			        validateBlank:false
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
	        }, {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '과목구분',
	    		id: 'radio2',
	    		items: [{
	    			boxLabel: '과목' , width: 82, name: 'ACCNT_DIVI_YN', inputValue: '1', checked: true
	    		}, {
	    			boxLabel: '세목' , width: 82, name: 'ACCNT_DIVI_YN', inputValue: '2'
	    		}]
	        }]		
		}],
		 setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'AC_DATE_FR',
	        endFieldName: 'AC_DATE_TO',
//	        width: 470,
			tdAttrs: {width: 380},  
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
//		    width: 325,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
				panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
     		}
		},{
            text:'일계표(2)출력(테스트중 삭제예정)',
            xtype:'button',
            hidden:true,
            handler: function() {
//            	if(this.onFormValidate()){
					var param= panelSearch.getValues();
					
					var win = Ext.create('widget.ClipReport', {
					url: CPATH+'/accnt/agb125clrkr.do',
					prgID: 'agb125skr',
					extParam: param
					});
					win.center();
					win.show(); 
//				}

            	
            	
//                var params = {
//                    'AC_DATE_FR'      : panelSearch.getValue('AC_DATE_FR'),
//                    'AC_DATE_TO'      : panelSearch.getValue('AC_DATE_TO'),
//                    'ACCNT_DIV_CODE'  : panelSearch.getValue('ACCNT_DIV_CODE'),
//                    'CHK_TERM'        : panelSearch.getValue('CHK_TERM'),
//                    'DEPT_CODE_FR'    : panelSearch.getValue('DEPT_CODE_FR'),
//                    'DEPT_CODE_TO'    : panelSearch.getValue('DEPT_CODE_TO'),
//                    'DEPT_NAME_FR'    : panelSearch.getValue('DEPT_NAME_FR'),
//                    'DEPT_NAME_TO'    : panelSearch.getValue('DEPT_NAME_TO'),
//                    'START_DATE'      : panelSearch.getValue('START_DATE'),
//                    'ACCOUNT_NAME'    : Ext.getCmp('radio1').getChecked()[0].inputValue,
//                    'ACCNT_DIVI'      : Ext.getCmp('radio2').getChecked()[0].inputValue,
//                    'SUM_DIVI'        : Ext.getCmp('radio3').getChecked()[0].inputValue
//                }
//                //전송
//                var rec1 = {data : {prgID : 'agb120rkr', 'text':''}};                           
//                parent.openTab(rec1, '/accnt/agb120rkr.do', params);    
            }
        }
		
		
		
		]	
    });

    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agb125skrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: masterStore,
		selModel: 'rowmodel',
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
 /*		tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
				}
			}
		}],*/
		tbar: [{
			text:'일계표출력',
			handler: function() {
				var params = {
					'AC_DATE_FR'      : panelSearch.getValue('AC_DATE_FR'),
					'AC_DATE_TO'      : panelSearch.getValue('AC_DATE_TO'),
					'ACCNT_DIV_CODE'  : panelSearch.getValue('ACCNT_DIV_CODE'),
					'DEPT_CODE_FR'    : panelSearch.getValue('DEPT_CODE_FR'),
					'DEPT_CODE_TO'    : panelSearch.getValue('DEPT_CODE_TO'),
					'DEPT_NAME_FR'    : panelSearch.getValue('DEPT_NAME_FR'),
					'DEPT_NAME_TO'    : panelSearch.getValue('DEPT_NAME_TO'),
					'START_DATE'      : panelSearch.getValue('START_DATE'),
					'ACCOUNT_NAME'    : Ext.getCmp('radio1').getChecked()[0].inputValue,
					'ACCNT_DIVI'      : Ext.getCmp('radio2').getChecked()[0].inputValue
				}
				//전송
				var rec1 = {data : {prgID : 'agb125rkr', 'text':''}};                           
				parent.openTab(rec1, '/accnt/agb125rkr.do', params);    
			}
		}],
    	features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
    	           	{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
        columns:  [ /*{ dataIndex: 'SEQ'			, width:66		, hidden: true	},
        			{ dataIndex: 'ACCNT_DIVI' 	, width:133		, hidden: true	},
        			{ dataIndex: 'GUBUN'     	, width:133		, hidden: true	},*/
        			{ text: '차변',
					  columns:[{dataIndex: 'TOTAL_DR_AMT_I' 	, width:133		},
					   		   { dataIndex: 'TOT_DR_AMT_I'   	, width:133		},
        					   { dataIndex: 'TOT_A_DR_AMT_I' 	, width:133		}
					  ]
        			},
 /*       			{ dataIndex: 'ACCNT'		, width:133		, hidden: true	},*/
        			{ dataIndex: 'ACCNT_NAME'	, width:186		, align: 'center'},
        			{ text: '대변',
					  columns:[{ dataIndex: 'TOT_A_CR_AMT_I' 	, width:133		},
        					   { dataIndex: 'TOT_CR_AMT_I'	 	, width:133		},
        					   { dataIndex: 'TOTAL_CR_AMT_I' 	, width:133		}
					  ]
        			}        			      			
        ],
		listeners: {
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	if(record.get('ACCNT_DIVI') == '3') {
	        		view.ownerGrid.setCellPointer(view, item);	
	        	}
    		},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                if (record.data['ACCNT_DIVI'] == '3'){
                    if(grid.grid.contextMenu) {
                        var menuItem = grid.grid.contextMenu.down('#linkAgb110skr');
                        if(menuItem) {
                            menuItem.handler();
                        }
                    }
                }
            }
    	},
	
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
			if (record.data['ACCNT_DIVI'] == '3'){
				return true;
			} else {
				return false;
			}
  		},
        uniRowContextMenu:{
			items: [{
            	text: '보조부  보기',   
            	itemId	: 'linkAgb110skr',
            	handler: function(menuItem, event) {
            		var record	= masterGrid.getSelectedRecord();
					var param	= {
						'PGM_ID'			: 'agb125skr',
						'START_DATE'		: panelSearch.getValue('START_DATE'),
						'ACCNT' 			: record.data['ACCNT'],
						'ACCNT_NAME'		: record.data['ACCNT_NAME'],
						'ACCNT_DIV_CODE'	: panelSearch.getValue('ACCNT_DIV_CODE'),
						'AC_DATE_FR'		: panelSearch.getValue('AC_DATE_FR'),
						'AC_DATE_TO'		: panelSearch.getValue('AC_DATE_TO')
					};
            		masterGrid.gotoAgb110skr(param);
            	}
        	}]
	    },
		gotoAgb110skr:function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agb110skr.do', params);
    	},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('ACCNT_DIVI') == '2') {
					cls = 'x-change-cell_light';
				}else if(record.get('ACCNT_DIVI') == '1'){
					cls = 'x-change-cell_medium_light';
				} else if(record.get('ACCNT_DIVI') == '0' || record.get('ACCNT_DIVI') == '4'){ 
					cls = 'x-change-cell_normal';
				} else if(record.get('ACCNT_NAME') == '합계') {
					cls = 'x-change-cell_dark';
				}
				if(record.get('SUBJECT_DIVI') == '2'){
					cls = 'x-change-celltext_darkred';	
				}
				if(record.get('GUBUN') == '1'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
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
		id  : 'agb125skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			//사용자 ID에 따라 과목명 default 값 다르게 가져옴
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
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
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			}
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
