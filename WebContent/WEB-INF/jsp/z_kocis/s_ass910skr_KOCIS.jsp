<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="s_ass910skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A396" /> 					<!-- 작품구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A397" /> 					<!-- 취득이유 -->
	<t:ExtComboStore comboType="AU" comboCode="A398" /> 					<!-- 가치등급분류 -->
	<t:ExtComboStore comboType="AU" comboCode="A399" /> 					<!-- 작품상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> 					<!-- 사용여부 -->
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> 	<!--기관-->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
</t:appConfig>
<script type="text/javascript" >


/*var BsaCodeInfo = {
	gsAutoType: '${gsAutoType}',	
	gsAccntBasicInfo : '${getAccntBasicInfo}',
	gsMoneyUnit : '${gsMoneyUnit}'
};*/

function appMain() {
	
	var buttonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_ass910skrService_KOCIS.insertDetail1',
			syncAll	: 's_ass910skrService_KOCIS.saveAll'
        }
	});

	
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('S_ass910skrModel', {
	    fields: [{name: 'ITEM_GBN'		 	,text: '작품구분' 				,type: 'string', 		comboType	: 'AU'		, comboCode	: 'A396'},	    		
				 {name: 'SPEC'		 		,text: '작품크기' 				,type: 'string'},	    		
				 {name: 'ITEM_CODE'		 	,text: '작품코드' 				,type: 'string'},	    		
				 {name: 'ITEM_NM'		 	,text: '작품명' 				,type: 'string'},	    		
				 {name: 'AUTHOR'		 	,text: '작가명' 				,type: 'string'},
				 {name: 'AUTHOR_HO'	 		,text: '호' 					,type: 'string'},
				 {name: 'DEPT_CODE'	 		,text: '보유기관명' 			,type: 'string'},	    		
				 {name: 'DEPT_NAME'		 	,text: '보유기관명' 			,type: 'string'},	    		
				 {name: 'PURCHASE_DATE'		,text: '취득일' 				,type: 'uniDate'},	    		
				 {name: 'PURCHASE_WHY'		,text: '취득이유' 				,type: 'string', 		comboType	: 'AU'		, comboCode	: 'A397'},	    		
				 {name: 'ACQ_AMT_I'	 		,text: '취득가격' 				,type: 'uniPrice'},	    		
				 {name: 'EXPECT_AMT_I'	 	,text: '추정가격' 				,type: 'uniPrice'},	    		
				 {name: 'ESTATE_AMT_I'	 	,text: '감정가격' 				,type: 'uniPrice'},	    		
				 {name: 'SALES_AMT_I'	 	,text: '작품가격' 				,type: 'uniPrice'},	    		
				 {name: 'REMARK'	 		,text: '특기사항' 				,type: 'string'},	    		
				 {name: 'ITEM_STATE'	 	,text: '작품상태' 				,type: 'string', 		comboType	: 'AU'		, comboCode	: 'A399'},	    		
				 {name: 'VALUE_GUBUN'	 	,text: '가치등급분류' 			,type: 'string', 		comboType	: 'AU'		, comboCode	: 'A398'},	    		
				 {name: 'ITEM_DIR'	 		,text: '게시장소' 				,type: 'string'},	    		
				 {name: 'INSERT_DB_TIME' 	,text: '등록일' 				,type: 'uniDate'},	    		
				 {name: 'INSUR_YN'		 	,text: '보험가입여부'			,type: 'string', 		comboType	: 'AU'		, comboCode	: 'B010'},	    		
				 {name: 'OPEN_YN'		 	,text: '공개여부' 				,type: 'string', 		comboType	: 'AU'		, comboCode	: 'B010'},	
				 {name: 'FIRST_CHECK_YN'    ,text: '점검여부'	 			,type: 'string', 		comboType	: 'AU'		, comboCode	: 'B010'},	    		
				 {name: 'FIRST_CHECK_DATE' 	,text: '점검일자' 				,type: 'uniDate'},	    		
				 {name: 'FIRST_CHECK_DESC'  ,text: '세부점검사항'			,type: 'string'},	
				 {name: 'SECOND_CHECK_YN'   ,text: '점검여부'	 			,type: 'string', 		comboType	: 'AU'		, comboCode	: 'B010'},	    		
				 {name: 'SECOND_CHECK_DATE' ,text: '점검일자' 				,type: 'uniDate'},	    		
				 {name: 'SECOND_CHECK_DESC' ,text: '세부점검사항'			,type: 'string'}
			]
	});

	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_ass910skrMasterStore',{
		model	: 'S_ass910skrModel',
		uniOpt	: {
        	isMaster	: true,				// 상위 버튼 연결 
        	editable	: false	,			// 수정 모드 사용 
        	deletable	: false	,			// 삭제 가능 여부 
            useNavi		: false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
            type: 'direct',
            api: {			
            	   read: 's_ass910skrService_KOCIS.selectList'                	
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
			}          		
      	}
	});
	
	var buttonStore = Unilite.createStore('s_ass910skr_KOCISbuttonStore',{
		model		: 'S_ass910skrModel',
		uniOpt		: {
        	isMaster	: false,			// 상위 버튼 연결 
        	editable	: false	,			// 수정 모드 사용 
        	deletable	: false	,			// 삭제 가능 여부 
            useNavi		: false				// prev | newxt 버튼 사용
        },
        autoLoad	: false,
        proxy		: buttonProxy,
		saveStore	: function()	{
			var config = {
				success	: function()	{
					UniAppManager.setToolbarButtons('save', false);	
					UniAppManager.app.onQueryButtonDown(); 
				},
				failure: function(batch, option) {
					UniAppManager.app.onQueryButtonDown(); 
				}
			}
			this.syncAllDirect(config);			
		},
		listeners	: {
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', false);	
			}
		}
	});	
	
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
        collapsed	: true,
        listeners	: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',
		    items		: [{ 
	        	fieldLabel	: '취득일',
				xtype		: 'uniDateRangefield',  
				startFieldName: 'FR_PURCHASE_DATE',
				endFieldName: 'TO_PURCHASE_DATE',
				startDate	: UniDate.get('startOfMonth'),
				endDate		: UniDate.get('today'),
//				allowBlank	: false,
				width		: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_PURCHASE_DATE', newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_PURCHASE_DATE',newValue);
			    	}   	
			    }
			},{
	            fieldLabel	: '점검시기',
	            xtype		: 'uniYearField',
	            name		: 'CLOSING_YEAR',
//	            value		: new Date().getFullYear(),
//	            allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
			    		panelResult.setValue('CLOSING_YEAR',newValue);
					}
				}
	         },{
				fieldLabel	: '작품구분'	,
				name		: 'ITEM_GBN', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'A396',	
//		 		allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
			    		panelResult.setValue('ITEM_GBN',newValue);	
					}
				} 
			},{
	            fieldLabel	: '기관',
	            xtype		: 'uniCombobox',
	            name		: 'DEPT_CODE',
	            store		: Ext.data.StoreManager.lookup('deptKocis'),
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
			    		panelResult.setValue('DEPT_CODE',newValue);	
					}
				} 
	        },
		    	Unilite.popup('ART_KOCIS',{
			    fieldLabel	: '작품코드',
//			    allowBlank	: false,
				listeners	: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NM', newValue);				
					}
				}
		   	})]
		}]
	});
		
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4, tableAttrs: {width: '100%'}/*, tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/ },
		padding	: '1 1 1 1',
		border	: true,
	    items	: [{ 
        	fieldLabel	: '취득일',
			xtype		: 'uniDateRangefield',  
			startFieldName: 'FR_PURCHASE_DATE',
			endFieldName: 'TO_PURCHASE_DATE',
			startDate	: UniDate.get('startOfMonth'),
			endDate		: UniDate.get('today'),
//			allowBlank	: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('FR_PURCHASE_DATE', newValue);
            	}   
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('TO_PURCHASE_DATE',newValue);
		    	}   	
		    }
		},{
            fieldLabel	: '점검시기',
            xtype		: 'uniYearField',
            name		: 'CLOSING_YEAR',
//            value		: new Date().getFullYear(),
//            allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
		    		panelSearch.setValue('CLOSING_YEAR',newValue);
				}
			}
         },{
			fieldLabel	: '작품구분'	,
			name		: 'ITEM_GBN', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'A396',	
//	 		allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
		    		panelSearch.setValue('ITEM_GBN',newValue);	
				}
			} 
		},{
			xtype		: 'component',
			width		: 200
		},{
            fieldLabel	: '기관',
            xtype		: 'uniCombobox',
            name		: 'DEPT_CODE',
            store		: Ext.data.StoreManager.lookup('deptKocis'),
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
		    		panelSearch.setValue('DEPT_CODE',newValue);	
				}
			} 
        },
	    	Unilite.popup('ART_KOCIS',{
		    fieldLabel	: '작품코드',  
//		    validateBlank: false, 
//		    allowBlank	: false,
			listeners	: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NM', newValue);				
				}
			}
	   	})]
	});

	
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_ass910skrGrid1', {
    	store		: masterStore,
        layout		: 'fit',
        region		: 'center',
		uniOpt		: {
			useMultipleSorting	: false,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: false,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: false,			
			useContextMenu		: false,		
			useRowNumberer		: false,			
			expandLastColumn	: false,		
			useRowContext		: true,			
	    	filter				: {
				useFilter		: false,		
				autoCreate		: false		
			},
			excel				: {
				useExcel		: true,			//엑셀 다운로드 사용 여부
				exportGroup 	: false, 		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: false
			}
		},
        tbar: [{
        	text	: '점검내용 초기화',
        	id		: 'initButton',
        	disabled: true,
        	handler	: function() {
				var records = masterGrid.getSelectedRecords();
				
                if(records.length > 0){
                    //insert할 데이터 저장용 store에 저장
                    buttonStore.clearData();

					Ext.each(records, function(record, index) {
                        record.phantom = true;
                        buttonStore.insert(index, record);
					});
					buttonStore.saveStore();
					
                } else {
                    Ext.Msg.alert('확인','선택된 데이터가 없습니다.'); 
                }
        	}
        }],
		//그리드 체크박스
    	selModel	: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false  ,
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts ){  
	    			if (this.selected.getCount() > 0) {
						Ext.getCmp('initButton').enable();
	    			}
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
	    			if (this.selected.getCount() == 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
						Ext.getCmp('initButton').disable();
	    			}
                }
            }
        }),
    	features: [ {
    		id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false ,
    		//컬럼헤더에서 그룹핑 사용 안 함
            enableGroupingMenu:false
    	},{
    		id : 'masterGridTotal'		, itemID:	'test'		, ftype: 'uniSummary'		, dock : 'top'	, showSummaryRow: false,
            enableGroupingMenu:false
    	}],
        columns:  [ {
						xtype		: 'rownumberer',
						align		: 'center  !important', 
						sortable	: false,
						resizable	: true, 
						width		: 35
					},				 
        			{ dataIndex: 'ITEM_GBN'		 	,width:80	},	    		
				 	{ dataIndex: 'SPEC'		 		,width:100	},	    		
				 	{ dataIndex: 'ITEM_CODE'		,width:80		, hidden: true	},	    		
				 	{ dataIndex: 'ITEM_NM'		 	,width:120	},	    		
				 	{ dataIndex: 'AUTHOR'		 	,width:100	},	    		
					{ dataIndex: 'AUTHOR_HO'	 	,width:80	},	    		
				 	{ dataIndex: 'DEPT_CODE'	 	,width:80		, hidden: true },	    		
				 	{ dataIndex: 'DEPT_NAME'		,width:110	},
        			{ dataIndex: 'PURCHASE_DATE'	,width:100	},
        			{ dataIndex: 'PURCHASE_WHY'		,width:100	}, 		
        			{ text		: '작품가액',
        			  columns	: [
					 	{ dataIndex: 'ACQ_AMT_I'	 	,width:110	},	    		
						{ dataIndex: 'EXPECT_AMT_I'	 	,width:110	},	    		
					 	{ dataIndex: 'ESTATE_AMT_I'	 	,width:110	},	    		
					 	{ dataIndex: 'SALES_AMT_I'	 	,width:110	}
					  ]
        			},
        			{ dataIndex: 'REMARK'	 		,width:150	},
        			{ dataIndex: 'ITEM_STATE'	 	,width:90	},   		
				 	{ dataIndex: 'VALUE_GUBUN'	 	,width:90	},	    		
					{ dataIndex: 'ITEM_DIR'	 		,width:100	},	    		
				 	{ dataIndex: 'INSERT_DB_TIME'	,width:100	},	    		
				 	{ dataIndex: 'INSUR_YN'		 	,width:90	},
        			{ dataIndex: 'OPEN_YN'		 	,width:90	},
        			{ text		: '상반기',
        			  columns	: [
	        			{ dataIndex: 'FIRST_CHECK_YN'   ,width:90	},
	        			{ dataIndex: 'FIRST_CHECK_DATE' ,width:100	},	    		
					 	{ dataIndex: 'FIRST_CHECK_DESC' ,width:120	}
					  ]
        			},
        			{ text		: '하반기',
        			  columns	: [
	        			{ dataIndex: 'SECOND_CHECK_YN'  ,width:90	},
	        			{ dataIndex: 'SECOND_CHECK_DATE',width:100	},
	        			{ dataIndex: 'SECOND_CHECK_DESC',width:120	}
					  ]
        			}
        ],
		listeners: {
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
    		},
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                if(grid.grid.contextMenu) {
                    var menuItem = grid.grid.contextMenu.down('#link_S_Ass900ukr');
                    
                    if(menuItem) {
                        menuItem.handler();
                    }
                }
            }
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{
	  		return true;
  		},
        uniRowContextMenu:{
			items: [{
	        		text: '미술품내역 등록',   
	            	itemId	: 'link_S_Ass900ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		var param = {
	            			'PGM_ID'		: 's_ass910skr_KOCIS',
							'ITEM_CODE' : record.data['ITEM_CODE'],
							'ITEM_NM'	: record.data['ITEM_NM']
	            		};
	            		masterGrid.goto_S_Ass900ukr(param);
	            	}
	        	}
	        ]
	    },
		goto_S_Ass900ukr: function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 's_ass900ukr_KOCIS', 'text':''}};							
			parent.openTab(rec1, '/z_kocis/s_ass900ukr_KOCIS.do', params);
    	}
    });  
	
	
	

    /** main app
	 */
    Unilite.Main({
		id			: 's_ass910skrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]	
		},
			panelSearch
		],
		
		fnInitBinding : function(params) {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_PURCHASE_DATE');

			this.setDefault();
		},
		
		onQueryButtonDown : function()	{										
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크							
				return false;									
			}										
			masterStore.loadStoreRecords();										
			UniAppManager.setToolbarButtons('reset',true);										
		},													
													
		onResetButtonDown: function() {											
			panelSearch.clearForm();										
			panelResult.clearForm();										
			masterGrid.getStore().loadData({});										
			masterStore.clearData();										
			this.fnInitBinding();										
		},
	
		
		setDefault: function() {
			panelSearch.setValue('FR_PURCHASE_DATE'		, UniDate.get('startOfMonth'));		//취득일 from
			panelSearch.setValue('TO_PURCHASE_DATE'		, UniDate.get('today'));			//취득일 to
//			panelSearch.setValue('CLOSING_YEAR'			, new Date().getFullYear());		//점검시기
			
			panelResult.setValue('FR_PURCHASE_DATE'		, UniDate.get('startOfMonth'));		//취득일 from
			panelResult.setValue('TO_PURCHASE_DATE'		, UniDate.get('today'));			//취득일 to
//			panelResult.setValue('CLOSING_YEAR'			, new Date().getFullYear());		//점검시기
			
			Ext.getCmp('initButton').disable();
		}
	});
};

</script>
