<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="w_ssa580skrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="w_ssa580skrv_yp"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B066" /> <!-- 세금계산서종류 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 * Model 정의
	 * 
	 * @type
	 */

	    			
	Unilite.defineModel('W_ssa580skrv_ypModel1', {
	    fields: [{name: 'CUSTOM_CODE'					,text: '고객코드'			     ,type: 'string'},
	    		 {name: 'CUSTOM_FULL_NAME'				,text: '고객명(전명)'		     ,type: 'string'},
	    		 {name: 'CUSTOM_NAME'					,text: '고객명(약명)'		     ,type: 'string'},
	    		 {name: 'BILL_DATE'						,text: '발행일'			         ,type: 'uniDate'},
	    		 {name: 'BILL_TYPE_CD'					,text: '계산서유형'		         ,type: 'string'},
	    		 {name: 'BILL_TYPE_NM'					,text: '계산서유형'		         ,type: 'string'},
	    		 {name: 'PUB_NUM'						,text: '계산서번호'		         ,type: 'string'},
	    		 {name: 'SALE_LOC_AMT_I'				,text: '공급가액'			     ,type: 'uniPrice'},
	    		 {name: 'TAX_AMT_O'						,text: '세액'				     ,type: 'uniPrice'},
	    		 {name: 'TOT_SALE_LOC_AMT'				,text: '합계'				     ,type: 'uniPrice'},
	    		 {name: 'PUB_FR_DATE'					,text: '매출일(FROM)'		     ,type: 'uniDate'},
	    		 {name: 'PUB_TO_DATE'					,text: '매출일(TO)'		         ,type: 'uniDate'},
	    		 {name: 'RECEIPT_PLAN_DATE'				,text: '수금예정일'		         ,type: 'uniDate'},
	    		 {name: 'AGENT_TYPE'					,text: '고객분류'			     ,type: 'string'},
	    		 {name: 'AREA_TYPE'						,text: '지역'				     ,type: 'string'},
	    		 {name: 'MANAGE_CUSTOM_CD'				,text: '집계거래처코드'		     ,type: 'string'},
	    		 {name: 'MANAGE_CUSTOM_NM'				,text: '집계거래처명'		     ,type: 'string'},
	    		 {name: 'PROJECT_NO'					,text: '프로젝트번호'		     ,type: 'string'},
	    		 {name: 'PJT_CODE'						,text: '프로젝트코드'	 	     ,type: 'string'},
	    		 {name: 'PJT_NAME'						,text: '프로젝트'			     ,type: 'string'},
	    		 {name: 'REMARK'						,text: '비고'				     ,type: 'string'},
	    		 {name: 'COMPANY_NUM1'					,text: '집계거래처사업자번호'	 ,type: 'string'},
	    		 {name: 'GUBUN'							,text: '구분'				     ,type: 'string'},
	    		 {name: 'DIV_CODE'						,text: '사업장코드'		         ,type: 'string'},
	    		 {name: 'SORT'							,text: '정렬'				     ,type: 'string'},
	    		 {name: 'SALE_DIV_CODE'					,text: '영업사업장코드'		     ,type: 'string'},
	    		 {name: 'BILL_SEND_YN'					,text: '전송여부'			     ,type: 'string'},
	    		 {name: 'EB_NUM'						,text: '전자세금계산서번호'	     ,type: 'string'},
	    		 {name: 'BILL_FLAG'						,text: '계산서유형'		         ,type: 'string'},
	    		 {name: 'MODI_REASON'					,text: '수정사유'			     ,type: 'string'},
	    		 {name: 'SALE_PRSN'						,text: '영업담당자'		         ,type: 'string'},
	    		 {name: 'BEFORE_PUB_NUM'				,text: '수정전계산서번호'	     ,type: 'string'},
	    		 {name: 'ORIGINAL_PUB_NUM'				,text: '원본계산서번호'		     ,type: 'string'},
	    		 {name: 'PLUS_MINUS_TYPE'				,text: '계산서구분'		         ,type: 'string'},
	    		 {name: 'COMPANY_NUM'					,text: '사업자번호'		         ,type: 'string'},
	    		 {name: 'SERVANT_COMPANY_NUM'			,text: '종사업자번호'		     ,type: 'string'},
	    		 {name: 'TOP_NAME'						,text: '대표자명'			     ,type: 'string'},
	    		 {name: 'ADDR'							,text: '주소'				     ,type: 'string'},
	    		 {name: 'COMP_CLASS'					,text: '업종'				     ,type: 'string'},
	    		 {name: 'COMP_TYPE'						,text: '업태'				     ,type: 'string'},
	    		 {name: 'RECEIVE_PRSN_NAME'				,text: '공급받는자명'		     ,type: 'string'},
	    		 {name: 'RECEIVE_PRSN_EMAIL'			,text: '공급받는자이메일'	     ,type: 'string'},
	    		 {name: 'RECEIVE_PRSN_TEL'				,text: '공급받는자전화번호'	     ,type: 'string'},
	    		 {name: 'RECEIVE_PRSN_MOBL'				,text: '공급받는자핸드폰'	     ,type: 'string'}
	    		 
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore1 = Unilite.createStore('w_ssa580skrv_ypMasterStore1',{
			model: 'W_ssa580skrv_ypModel1',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'w_ssa580skrv_ypService.selectList1'                	
                }
            }
			,loadStoreRecords: function()	{	
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
			}
	});
	


	/**
	 * 검색조건 (Search Panel)
	 * 
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
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
        			fieldLabel: '사업장',
        			name: 'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
        			allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
        		}, {
        			fieldLabel: '발행일',            			 		       
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_DATE',
					endFieldName: 'TO_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);
							// panelResult.getField('ISSUE_REQ_DATE_FR').validate();
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_DATE', newValue);
				    		// panelResult.getField('ISSUE_REQ_DATE_TO').validate();
				    	}
				    }
				}, {
					fieldLabel: '영업담당'	,
					name: 'SALE_PRSN', 
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S010',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SALE_PRSN', newValue);
						}
					}
				},
					Unilite.popup('AGENT_CUST',{
					fieldLabel: '거래처',
					
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					}
				}),{
            		xtype: 'radiogroup',		            		
            		fieldLabel: '자동기표여부',            								            		
            		items: [{
            			boxLabel : '전체',
            			name: 'SLIP_YN',
            			inputValue: 'A',
            			checked: true ,
            			width: 50 
            		}, {
            			boxLabel : '기표',
            			name: 'SLIP_YN',
            			inputValue: 'Y', 
            			width: 50
            		}, {
            			boxLabel : '미기표',
            			name: 'SLIP_YN' ,
            			inputValue: 'N', 
            			width: 70
            		}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							// panelSearch.getField('SALE_YN').setValue({SALE_YN:
							// newValue});
							panelResult.getField('SLIP_YN').setValue(newValue.SLIP_YN);
						}
					}
            	}]	
        	}]
		}, {
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
		 	 	fieldLabel: '거래처분류',
		 	 	name: 'AGENT_TYPE',
		 	 	xtype: 'uniCombobox',
		 	 	comboType: 'AU',
		 	 	comboCode: 'B055'
		 	 },
		 	 	Unilite.popup('AGENT_CUST',{
		 	 	fieldLabel: '집계거래처',
		 	 	
		 	 	valueFieldName:'MNG_CUSTOM_CODE',
			    textFieldName:'MNG_CUSTOM_NAME'
			}),{
				xtype: 'uniNumberfield',
				fieldLabel: '공급가액'	,
				name: 'FROM_AMT' ,
				suffixTpl: '&nbsp;이상'
			}, {
				xtype: 'uniNumberfield',
	 	    	fieldLabel: '~',
	 	    	name: 'TO_AMT' ,
	 	    	suffixTpl: '&nbsp;이하'
	 	    }, {
				fieldLabel: '지역',
				name: 'AREA_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B056'
			}, {
		 	 	xtype: 'container',
    			defaultType: 'uniTextfield',
 				layout: {type: 'uniTable', columns: 1},
 				width: 315,
 				items: [{
 					fieldLabel: '계산서번호',
 					name: 'FROM_NUM'
 				}, {
 					fieldLabel: '~',
 					name: 'TO_NUM'
 				}] 
	 	    }, {
	 	    	fieldLabel: '계산서종류',
	 	    	name: 'BILL_TYPE',
	 	    	xtype: 'uniCombobox',
	 	    	comboType: 'AU',
	 	    	comboCode: 'B066'
	 	    }]
		}], setAllFieldsReadOnly: function(b) {
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
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '발행일',            			 		       
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_DATE',
			endFieldName: 'TO_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
					// panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE', newValue);
		    		// panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
		    	}
		    }
		}, {
			fieldLabel: '영업담당'	,
			name: 'SALE_PRSN', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '거래처',
			
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		}),{
    		xtype: 'radiogroup',		            		
    		fieldLabel: '자동기표여부',    								            		
    		items: [{
    			boxLabel : '전체',
    			name: 'SLIP_YN',
    			inputValue: 'A',
    			checked: true ,
    			width: 50 
    		}, {
    			boxLabel : '기표',
    			name: 'SLIP_YN',
    			inputValue: 'Y', 
    			width: 50
    		}, {
    			boxLabel : '미기표',
    			name: 'SLIP_YN' ,
    			inputValue: 'N', 
    			width: 70
    		}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					// panelSearch.getField('SALE_YN').setValue({SALE_YN:
					// newValue});
					panelSearch.getField('SLIP_YN').setValue(newValue.SLIP_YN);
				}
			}
    	}]	
    });
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */

    var masterGrid = Unilite.createGrid('ssa660skrvGrid1', {
    	// for tab
		region: 'center',  	
        layout: 'fit',        
    	store: directMasterStore1,
    	features: [ {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	uniOpt: {useRowNumberer: false,
            state: {
                useState: false,         //그리드 설정 버튼 사용 여부
                useStateList: false      //그리드 설정 목록 사용 여부
            }},
    	features: [{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],    	           	
        columns:  [{ dataIndex: 'CUSTOM_CODE'					,			   	width: 80, locked: true,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	   return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
    			    }
                  }
        		  ,{ dataIndex: 'CUSTOM_FULL_NAME'				,			   	width: 146, locked: true	}
        		  ,{ dataIndex: 'CUSTOM_NAME'					,			   	width: 146, hidden: true }
        		  ,{ dataIndex: 'BILL_DATE'						,			   	width: 80, locked: true	}
        		  ,{ dataIndex: 'BILL_TYPE_CD'					,			   	width: 93, hidden: true	}
        		  ,{ dataIndex: 'BILL_TYPE_NM'					,			   	width: 93, locked: true	}
        		  ,{ dataIndex: 'PUB_NUM'						,			   	width: 113, locked: true}
        		  ,{ dataIndex: 'SALE_LOC_AMT_I'				,			   	width: 120, summaryType: 'sum'	}
        		  ,{ dataIndex: 'TAX_AMT_O'						,			   	width: 100, summaryType: 'sum'	}
        		  ,{ dataIndex: 'TOT_SALE_LOC_AMT'				,			   	width: 120, summaryType: 'sum'	}
        		  ,{ dataIndex: 'PUB_FR_DATE'					,			   	width: 93	}
        		  ,{ dataIndex: 'PUB_TO_DATE'					,			   	width: 93	}
        		  ,{ dataIndex: 'RECEIPT_PLAN_DATE'				,			   	width: 93	}
        		  ,{ dataIndex: 'AGENT_TYPE'					,			   	width: 93	}
        		  ,{ dataIndex: 'AREA_TYPE'						,			   	width: 93	}
        		  ,{ dataIndex: 'MANAGE_CUSTOM_CD'				,			   	width: 100	}
        		  ,{ dataIndex: 'MANAGE_CUSTOM_NM'				,			   	width: 120	}
        		  ,{ dataIndex: 'PROJECT_NO'					,			   	width: 93	}
        		  ,{ dataIndex: 'PJT_CODE'						,			   	width: 80, hidden: true	}
        		  ,{ dataIndex: 'PJT_NAME'						,			   	width: 166	}
        		  ,{ dataIndex: 'REMARK'						,			   	width: 120	}
        		  ,{ dataIndex: 'COMPANY_NUM1'					,			   	width: 120	}
        		  ,{ dataIndex: 'GUBUN'							,			   	width: 66, hidden: true	}
        		  ,{ dataIndex: 'DIV_CODE'						,			   	width: 66, hidden: true	}
        		  ,{ dataIndex: 'SORT'							,			   	width: 66, hidden: true	}
        		  ,{ dataIndex: 'SALE_DIV_CODE'					,			   	width: 66, hidden: true	}
        		  ,{ dataIndex: 'BILL_SEND_YN'					,			   	width: 66	}
        		  ,{ dataIndex: 'EB_NUM'						,			   	width: 120	}
        		  ,{ dataIndex: 'BILL_FLAG'						,			   	width: 80	}
        		  ,{ dataIndex: 'MODI_REASON'					,			   	width: 120	}
        		  ,{ dataIndex: 'SALE_PRSN'						,			   	width: 86	}
        		  ,{ dataIndex: 'BEFORE_PUB_NUM'				,			   	width: 120	}
        		  ,{ dataIndex: 'ORIGINAL_PUB_NUM'				,			   	width: 106	}
        		  ,{ dataIndex: 'PLUS_MINUS_TYPE'				,			   	width: 80	}
        		  ,{ dataIndex: 'COMPANY_NUM'					,			   	width: 93	}
        		  ,{ dataIndex: 'SERVANT_COMPANY_NUM'			,			   	width: 80	}
        		  ,{ dataIndex: 'TOP_NAME'						,			   	width: 80	}
        		  ,{ dataIndex: 'ADDR'							,			   	width: 166	}
        		  ,{ dataIndex: 'COMP_CLASS'					,			   	width: 120	}
        		  ,{ dataIndex: 'COMP_TYPE'						,			   	width: 66	}
        		  ,{ dataIndex: 'RECEIVE_PRSN_NAME'				,			   	width: 100	}
        		  ,{ dataIndex: 'RECEIVE_PRSN_EMAIL'			,			   	width: 146	}
        		  ,{ dataIndex: 'RECEIVE_PRSN_TEL'				,			   	width: 146	}
        		  ,{ dataIndex: 'RECEIVE_PRSN_MOBL'				,			   	width: 146	}
       ]
        			
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
		id : 'w_ssa580skrv_ypApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('CUSTOM_CODE', '${gsCustomCode}');
            panelSearch.setValue('CUSTOM_NAME', '${gsCustomName}');
//            panelSearch.setValue('SALE_PRSN', '${gsBusiPrsn}');
//            panelSearch.setValue('ORDER_TYPE', '95');
            panelResult.setValue('CUSTOM_CODE', '${gsCustomCode}');
            panelResult.setValue('CUSTOM_NAME', '${gsCustomName}');
//            panelResult.setValue('SALE_PRSN', '${gsBusiPrsn}');
//            panelResult.setValue('ORDER_TYPE', '95');
            
            panelSearch.getField('CUSTOM_CODE').setReadOnly(true);
            panelSearch.getField('CUSTOM_NAME').setReadOnly(true);
            panelResult.getField('CUSTOM_CODE').setReadOnly(true);
            panelResult.getField('CUSTOM_NAME').setReadOnly(true);
		},
		onQueryButtonDown: function()	{		
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);				
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>