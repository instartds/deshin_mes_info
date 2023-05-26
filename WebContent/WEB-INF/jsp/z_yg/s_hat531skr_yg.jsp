<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat531skr_yg"  >
	<t:ExtComboStore comboType="BOR120"  />					<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('s_hat531skr_ygModel', {
		fields: [ 
			{name: 'PERSON_NUMB'				, text: '사번'				, type: 'string'},
			{name: 'NAME'								, text: '성명'				, type: 'string'},
			{name: 'NWK_DATE'					, text: '총근무(일)'		, type: 'int'},
			{name: 'WK_DATE'						, text: '충근(일)'			, type: 'int'},
			{name: 'WK_DATE_LATE'				, text: '출근율(%)'		, type: 'int'},
			{name: 'YHOL'								, text: '년차(일)'			, type: 'int'},
			{name: 'ABSEN'								, text: '결근(일)'			, type: 'int'},
			{name: 'PHOL'								, text: '유급(일)'			, type: 'int'},
			{name: 'OHOL'								, text: '무급(일)'			, type: 'int'},
			{name: 'EDUC'								, text: '교육(일)'			, type: 'int'},
			{name: 'TRAIN'								, text: '훈련(일)'			, type: 'int'},
			{name: 'LATEN'								, text: '회수'				, type: 'int'},  //지각
			{name: 'LATENTIME'					, text: '시간'				, type: 'string'},  //지각
			{name: 'EALIER'								, text: '회수'				, type: 'int'},  //조퇴
			{name: 'EALIERTIME'					, text: '시간'				, type: 'string'},  //조퇴
			{name: 'OUTB'								, text: '회수'				, type: 'int'},  //외출
			{name: 'OUTBTIME'						, text: '회수'				, type: 'string'}  //외출
		]
	});
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore1 = Unilite.createStore('s_hat531skr_ygMasterStore1',{
         model: 's_hat531skr_ygModel',
         uniOpt : {
               isMaster: true,         // 상위 버튼 연결 
               editable: false,         // 수정 모드 사용 
               deletable:false,         // 삭제 가능 여부 
               useNavi : false         // prev | newxt 버튼 사용
                  //비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {          
                      read: 's_hat531skr_ygService.selectList'                   
                }
            },
    	    loadStoreRecords : function()   {
	            var param= Ext.getCmp('searchForm').getValues();         
	            console.log( param );
	            this.load({
	               params : param
	            });
	        }
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
	    items: [
	      {
		        fieldLabel: '사업장',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox',
				comboType:'BOR120',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
		    },{
				fieldLabel: '근태일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'DUTY_DATE_FR',
				endFieldName: 'DUTY_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank:false,
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
		     },Unilite.popup('DEPT', {
	            fieldLabel: '부서', 
	            valueFieldName: 'DEPT_CODE_FR',
	            textFieldName: 'DEPT_NAME_FR', 
	            listeners: {
	                onSelected: {
	                    fn: function(records, type) {
	                    	panelResult.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE_FR'));
	                    	panelResult.setValue('DEPT_NAME_FR', panelSearch.getValue('DEPT_NAME_FR'));                                                                                                         
	                    },
	                    scope: this
	                },
	                onClear: function(type) {
	                	panelResult.setValue('DEPT_CODE_FR', '');
	                	panelResult.setValue('DEPT_NAME_FR', '');
	                }
	            }
	    }),
		    Unilite.popup('DEPT', {
		        fieldLabel: '~', 
		        valueFieldName: 'DEPT_CODE_TO',
		        textFieldName: 'DEPT_NAME_TO', 
		        listeners: {
		            onSelected: {
		                fn: function(records, type) {
		                	panelResult.setValue('DEPT_CODE_TO', panelSearch.getValue('DEPT_CODE_TO'));
		                	panelResult.setValue('DEPT_NAME_TO', panelSearch.getValue('DEPT_NAME_TO'));                                                                                                         
		                },
		                scope: this
		            },
		            onClear: function(type) {
		            	panelResult.setValue('DEPT_CODE_TO', '');
		            	panelResult.setValue('DEPT_NAME_TO', '');
		            }
		        }
		}),
		Unilite.popup('Employee',{
            fieldLabel:'사원',
            valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelResult.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('NAME', newValue);				
				},
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT': '00000000'}); 
				},
			}
		}),
		{
                xtype: 'radiogroup',  
                name: 'PAY_GUBUN',
                fieldLabel: '비정규직 포함', 
                labelWidth: 90,
                items: [{
                    boxLabel: '한다', 
                    width: 50, 
                    name: 'PAY_GUBUN',
                    inputValue: '1',
                    checked: true  
                },{
                    boxLabel: '안한다',  
                    width: 70, 
                    name: 'PAY_GUBUN',
                    inputValue: '2'
                }],
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('PAY_GUBUN', newValue);
					}
				}
            }]    	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [
		 {
		        fieldLabel: '사업장',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox',
				comboType:'BOR120',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		    },{
			fieldLabel: '근태일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'DUTY_DATE_FR',
			endFieldName: 'DUTY_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank:false,
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
	    Unilite.popup('DEPT', {
            fieldLabel: '부서', 
            valueFieldName: 'DEPT_CODE_FR',
            textFieldName: 'DEPT_NAME_FR', 
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                    	panelSearch.setValue('DEPT_CODE_FR', panelResult.getValue('DEPT_CODE_FR'));
                    	panelSearch.setValue('DEPT_NAME_FR', panelResult.getValue('DEPT_NAME_FR'));                                                                                                         
                    },
                    scope: this
                },
                onClear: function(type) {
                	panelSearch.setValue('DEPT_CODE_FR', '');
                	panelSearch.setValue('DEPT_NAME_FR', '');
                }
            }
    }),
	    Unilite.popup('DEPT', {
	        fieldLabel: '~', 
	        valueFieldName: 'DEPT_CODE_TO',
	        textFieldName: 'DEPT_NAME_TO', 
	        listeners: {
	            onSelected: {
	                fn: function(records, type) {
	                	panelSearch.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_TO'));
	                	panelSearch.setValue('DEPT_NAME_TO', panelResult.getValue('DEPT_NAME_TO'));                                                                                                         
	                },
	                scope: this
	            },
	            onClear: function(type) {
	            	panelSearch.setValue('DEPT_CODE_TO', '');
	            	panelSearch.setValue('DEPT_NAME_TO', '');
	            }
	        }
			}),
			Unilite.popup('Employee',{
		        fieldLabel:'사원',
		        valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					},
					applyextparam: function(popup){	
						popup.setExtParam({'BASE_DT': '00000000'}); 
					}
				}
			}),{
                xtype: 'radiogroup',  
                name: 'PAY_GUBUN',
                id: 'PAY_GUBUN',
                fieldLabel: '비정규직 포함', 
                labelWidth: 90,
                items: [{
                    boxLabel: '한다', 
                    width: 50, 
                    name: 'PAY_GUBUN',
                    inputValue: '',
                    checked: true  
                },{
                    boxLabel: '안한다',  
                    width: 70, 
                    name: 'PAY_GUBUN',
                    inputValue: '1'
                }],
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('PAY_GUBUN', newValue);
					}
				}
            }]  
    });
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('s_hat531skr_ygGrid1', {
       region: 'center',
        layout: 'fit',
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
        tbar: [
        	{
             	xtype:'button',
             	text:'엑셀파일 생성',
             	id : 'excelDown',
 	        	handler:function(){
	        		if(panelSearch.setAllFieldsReadOnly(true) == false){
	    				return ;
	    			}
	        		
	        		var form = panelFileDown;
	        		form.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
	        		form.setValue('DUTY_DATE_FR', UniDate.getDateStr(panelSearch.getValue('DUTY_DATE_FR')));
	        		form.setValue('DUTY_DATE_TO', UniDate.getDateStr(panelSearch.getValue('DUTY_DATE_TO')));
	        		
	        		form.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE_FR'));
	        		form.setValue('DEPT_CODE_TO', panelSearch.getValue('DEPT_CODE_TO'));
	        		
	        		form.setValue('PAY_GUBUN', Ext.getCmp('PAY_GUBUN').getChecked()[0].inputValue);
	        		//form.setValue('PAY_GUBUN', '');
	        		
	        		/*var toUpdate = directMasterStore.getUpdatedRecords();
	        		var budgData = [];
	        		if(toUpdate.length > 0){
	        			for(var i = 0; i < toUpdate.length; i++){
	            			var data = toUpdate[i].data;
	            			var itemCode = data.ITEM_CODE;
	            			var budgetO = data.BUDGET_O;
	            			var budgetP = data.BUDGET_UNIT_O;
	            			budgData.push({
	            				'ITEM_CODE' 	: itemCode,
	            				'BUDGET_UNIT_O' : budgetP,
	            				'BUDGET_O' 		: budgetO
	            			});
	            		}
	        		}*/
	        		
	        		//form.setValue('BUDG_DATA', JSON.stringify(budgData));
	        		var param = form.getValues();
	
	        		form.submit({
	                    params: param,
	                    success:function()  {
	                    },
	                    failure: function(form, action){
	                    }
	                });
	        	}
             	/*handler:function()	{
             		UniAppManager.app.onPrintButtonDown();
             	}*/
        }],
		features: [
			    {id: 'masterGridSubTotal'		, ftype: 'uniGroupingsummary'		, showSummaryRow: false},
				{id: 'masterGridTotal'				, ftype: 'uniSummary'						, showSummaryRow: false}
		    ],

		store: directMasterStore1,
        columns: [
			{dataIndex: 'PERSON_NUMB'	,    width: 100},
			{dataIndex: 'NAME'			,	width: 100},
			{dataIndex: 'NWK_DATE'		,	width: 100},
			{dataIndex: 'WK_DATE'		,	width: 100},
			{dataIndex: 'WK_DATE_LATE'	,	width: 100},
			{dataIndex: 'YHOL'			,     width: 100},
			{dataIndex: 'ABSEN'			,     width: 100},
			{dataIndex: 'PHOL'			,	width: 100 },
			{dataIndex: 'OHOL'			,	width: 100 },
			{dataIndex: 'EDUC'			,	width: 100 },
			{dataIndex: 'TRAIN'			,    width: 100 },
			{ text : '지각' ,
                columns: [
					{dataIndex: 'LATEN'			,    width: 100 },
					{dataIndex: 'LATENTIME'		,    width: 100 ,align: 'center'}
				]},
			{ text : '조퇴' ,
                columns: [
					{dataIndex: 'EALIER'		,		width: 100 },
					{dataIndex: 'EALIERTIME'	,	    width: 100 ,align: 'center'}
				]},
			{ text : '외출' ,
                columns: [
					{dataIndex: 'OUTB'			,	width: 100 },
					{dataIndex: 'OUTBTIME'		,	width: 100 ,align: 'center'}
				]}
        ]
    });
    
	var panelFileDown = Unilite.createForm('FileDownForm', {
		url: CPATH+'/z_yg/hat531skrvExcelDown.do',
		colspan: 2,
		layout: {type: 'uniTable', columns: 1},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true,  
		items:[{
			xtype: 'uniTextfield',
			name: 'DIV_CODE'
		},{
			xtype: 'uniTextfield',
			name: 'DUTY_DATE_FR'
		},{
			xtype: 'uniTextfield',
			name: 'DUTY_DATE_TO'
		},{
			xtype: 'uniTextfield',
			name: 'DEPT_CODE_FR'
		},{
			xtype: 'uniTextfield',
			name: 'DEPT_CODE_TO'
		},{
			xtype: 'uniTextfield',
			name: 'PAY_GUBUN'
		}]
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
      id  : 's_hat531skr_ygApp',
      fnInitBinding : function() {
         panelResult.setValue('DIV_CODE',UserInfo.divCode);
         panelResult.setValue('DUTY_DATE_FR',UniDate.get('startOfMonth'));
         panelResult.setValue('DUTY_DATE_TO',UniDate.get('today'));
         panelSearch.setValue('DIV_CODE',UserInfo.divCode);
         panelSearch.setValue('DUTY_DATE_FR',UniDate.get('startOfMonth'));
         panelSearch.setValue('DUTY_DATE_TO',UniDate.get('today'));
         UniAppManager.setToolbarButtons(['reset','save'],false);
      },
      onQueryButtonDown : function()   {         
    	  directMasterStore1.loadStoreRecords();
    	  UniAppManager.setToolbarButtons('reset',true);
      },
      onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			//directMasterStore1.clearData();
			this.fnInitBinding();			
		},
		onPrintButtonDown: function() {
/*			var param = Ext.getCmp('searchForm').getValues();  		// 하단 검색조건
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/z_yg/s_hat531crkr_yg.do',
                prgID: 's_hat531crkr_yg',
                extParam: param
            });
	            
	        win.center();
	        win.show();*/
			

	    }
		
   });
};


</script>