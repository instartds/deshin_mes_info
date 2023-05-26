<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hrt700skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H053" /> <!-- 퇴직구분 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var person_numb	=  '';
	var retr_type	= '';
	var retr_date	= '';
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hrt700skrModel', {
	    fields: [
	    	{name: 'DIV_CODE'		, text: '기관'			, type: 'string'		, comboType:'BOR120'},
	    	{name: 'DEPT_NAME'		, text: '부서'			, type: 'string'},
	    	{name: 'POST_CODE'		, text: '직위'			, type: 'string'		, comboType:'AU',comboCode:'H005'},
	    	{name: 'NAME'			, text: '성명'			, type: 'string'},
	    	{name: 'PERSON_NUMB'	, text: '사번'			, type: 'string'},
	    	{name: 'CODE_NAME'		, text: '퇴직구분'		, type: 'string'},
	    	{name: 'ENTR_DATE'		, text: '입사일'		, type: 'uniDate'},
	    	{name: 'JOIN_DATE'		, text: '정산시작일'	, type: 'uniDate'},
	    	{name: 'RETR_DATE'		, text: '정산일'		, type: 'uniDate'},
	    	{name: 'DUTY_YYYY'		, text: '근속기간'		, type: 'string'},
	    	{name: 'LONG_TOT_DAY'	, text: '근속일수'		, type: 'uniDate'},
	    	{name: 'PAY_TOTAL_I'	, text: '급여총액'		, type: 'uniPrice'},
	    	{name: 'BONUS_TOTAL_I'	, text: '상여총액'		, type: 'uniPrice'},
	    	{name: 'YEAR_TOTAL_I'	, text: '년월차총액'	, type: 'uniPrice'},
	    	{name: 'AVG_PAY_I'		, text: '급여평균임금'	, type: 'uniPrice'},
	    	{name: 'RETR_ANNU_I'	, text: '퇴직금'		, type: 'uniPrice'},
	    	{name: 'ADD_MONTH'		, text: '누진개월'		, type: 'uniDate'},
	    	{name: 'RETR_TYPE'		, text: '구분'			, type: 'string'}
		]
	});//End of Unilite.defineModel('Hrt700skrModel', {
		
	Unilite.defineModel('sub1Model', {
	    fields: [
	    	{name: 'PAY_YYYYMM'		, text: '급여년월'		, type: 'string'},
	    	{name: 'WAGES_NAME'		, text: '지급구분'		, type: 'string'},
	    	{name: 'AMOUNT_I'		, text: '금액'			, type: 'uniPrice'}
		]
	});
	
	Unilite.defineModel('sub2Model', {
	    fields: [
	    	{name: 'PAY_YYYYMM'		, text: '급여년월'		, type: 'string'},
	    	{name: 'WEL_NAME'		, text: '지급구분'		, type: 'string'},
	    	{name: 'GIVE_I'			, text: '금액'			, type: 'uniPrice'}
		]
	});
	
	Unilite.defineModel('sub3Model', {
	    fields: [
	    	{name: 'BONUS_YYYYMM'	, text: '상여년월'		, type: 'string'},
	    	{name: 'BONUS_TYPE'		, text: '상여구분'		, type: 'string'},
	    	{name: 'BONUS_I'		, text: '금액'			, type: 'uniPrice'}
		]
	});
	
	Unilite.defineModel('sub4Model', {
	    fields: [
	    	{name: 'BONUS_YYYYMM'	, text: '년월차년월'	, type: 'string'},
	    	{name: 'BONUS_TYPE'		, text: '년월차구분'	, type: 'string'},
	    	{name: 'BONUS_I'		, text: '금액'			, type: 'uniPrice'}
		]
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hrt700skrMasterStore1',{
		model: 'Hrt700skrModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt700skrService_KOCIS.selectList'                	
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'DIV_CODE'
	});	//End of var directMasterStore1 = Unilite.createStore('hrt700skrMasterStore1',{
		
	var sub1Store = Unilite.createStore('sub1Store',{
		model: 'sub1Model',
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt700skrService_KOCIS.selectSub1'                	
			}
		},
		loadStoreRecords: function(person_numb, retr_type, retr_date) {
			//var param = masterGrid.getSelectionModel().getSelection();
		
			var param = Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			param.RETR_TYPE = retr_type;
			param.RETR_DATE = retr_date;
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'PAY_YYYYMM'
	});
	
	var sub2Store = Unilite.createStore('sub2Store',{
		model: 'sub2Model',
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt700skrService_KOCIS.selectSub2'                	
			}
		},
		loadStoreRecords: function(person_numb, retr_type, retr_date) {
			var param = Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			param.RETR_TYPE = retr_type;
			param.RETR_DATE = retr_date;
			console.log( param );
			this.load({
				params : param
			});
		}
	});	
	
	var sub3Store = Unilite.createStore('sub3Store',{
		model: 'sub3Model',
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt700skrService_KOCIS.selectSub3'                	
			}
		},
		loadStoreRecords: function(person_numb, retr_type, retr_date) {
			var param = Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			param.RETR_TYPE = retr_type;
			param.RETR_DATE = retr_date;
			this.load({
				params : param
			});
		}
	});	
	
	var sub4Store = Unilite.createStore('sub4Store',{
		model: 'sub4Model',
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 's_hrt700skrService_KOCIS.selectSub4'                	
			}
		},
		loadStoreRecords: function(person_numb, retr_type, retr_date) {
			var param = Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			param.RETR_TYPE = retr_type;
			param.RETR_DATE = retr_date;
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
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
		region		: 'west',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items		: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',
    		items		: [{
    				fieldLabel	: '기관',
    				name		: 'DIV_CODE',
    				xtype		: 'uniCombobox',
    				comboType	: 'BOR120',
				    listeners	: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
    			}/*,
					Unilite.popup('DEPT',{
						fieldLabel: '부서',
						valueFieldName: 'DEPT_CODE1',
				    	textFieldName: 'DEPT_NAME1',
						textFieldWidth: 170,
						validateBlank: false,
						popupWidth: 710
					}),
					Unilite.popup('DEPT', {
				    	fieldLabel: '~',
				    	valueFieldName: 'DEPT_CODE2',
				    	textFieldName: 'DEPT_NAME2',
				    	textFieldWidth: 170,
				    	validateBlank: false,
				    	popupWidth: 710
				    })*/,
				    Unilite.popup('Employee',{ 
						fieldLabel		: '성명',
						valueFieldName	: 'PERSON_NUMB',
						textFieldWidth	: 150,
						validateBlank	: false,    			
						listeners		: {
							onValueFieldChange: function(field, newValue){
								panelResult.setValue('PERSON_NUMB', newValue);								
							},
							onTextFieldChange: function(field, newValue){
								panelResult.setValue('NAME', newValue);				
							}
						}
					}),
					{
						fieldLabel: '퇴직구분',
						name		: 'CODE_NAME',
						xtype		: 'uniCombobox',
						comboType	: 'AU',
						comboCode	: 'H053',
					    listeners	: {
							change: function(field, newValue, oldValue, eOpts) {      
								panelResult.setValue('CODE_NAME', newValue);
							}
						}
					}
// 		     		Unilite.popup('Employee',{ 
// 		     			
// 		     			textFieldWidth: 170,
// 		     			validateBlank: false,
// 		     			extParam: {
// 		     				'CUSTOM_TYPE':'3'
// 		     			}
// 		   			})
    		]},{
		   	title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
    		items: [{
					fieldLabel		: '정산일',
			    	xtype			: 'uniDateRangefield',
			   		startFieldName	: 'FR_DATE',
			   		endFieldName	: 'TO_DATE',
			    	width			: 315
				}
		    ]}
    	]		
	});  	
 
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{
				fieldLabel	: '기관',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
			    listeners	: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}/*,
				Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE1',
			    	textFieldName: 'DEPT_NAME1',
					textFieldWidth: 170,
					validateBlank: false,
					popupWidth: 710
				}),
				Unilite.popup('DEPT', {
			    	fieldLabel: '~',
			    	valueFieldName: 'DEPT_CODE2',
			    	textFieldName: 'DEPT_NAME2',
			    	textFieldWidth: 170,
			    	validateBlank: false,
			    	popupWidth: 710
			    })*/,
			    Unilite.popup('Employee',{ 
					fieldLabel		: '성명',
					valueFieldName	: 'PERSON_NUMB',
					textFieldWidth	: 150,
					validateBlank	: false,    			
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('NAME', newValue);				
						}
					}
				}),
				{
					fieldLabel	: '퇴직구분',
					name		: 'CODE_NAME',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'H053',
				    listeners	: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('CODE_NAME', newValue);
						}
					}
				}
// 		     		Unilite.popup('Employee',{ 
// 		     			
// 		     			textFieldWidth: 170,
// 		     			validateBlank: false,
// 		     			extParam: {
// 		     				'CUSTOM_TYPE':'3'
// 		     			}
// 		   			})
		]
	});
    

	
	
	/**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hrt700skrGrid1', {
    	store	: directMasterStore1,
        layout	: 'fit',
        region	: 'center',
		uniOpt	: {						
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
			},					
			excel: {					
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: false,	//group 상태로 export 여부	
				onlyData		: false,		
				summaryExport	: false			
			}					
		},						
      
    	features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true },
    	           	{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} 
       	],
        columns: [
			{dataIndex: 'DIV_CODE'		, width: 100,
				summaryRenderer:function(value, summaryData,	dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
		    	}
		    },
			{dataIndex: 'DEPT_NAME'		, width: 80		, hidden: true},
			{dataIndex: 'POST_CODE'		, width: 73},
			{dataIndex: 'NAME'  		, width: 120},
			{dataIndex: 'PERSON_NUMB'	, width: 86		, hidden: true},
			{dataIndex: 'CODE_NAME'		, width: 70},
			{dataIndex: 'ENTR_DATE'		, width: 80		, hidden: true},
			{dataIndex: 'JOIN_DATE'		, width: 80},
			{dataIndex: 'RETR_DATE'		, width: 80},
			{dataIndex: 'DUTY_YYYY'		, width: 66		, align: 'center'},
			{dataIndex: 'LONG_TOT_DAY'	, width: 66		, hidden: true},
			{dataIndex: 'PAY_TOTAL_I'	, width: 120	, summaryType: 'sum'},
			{dataIndex: 'BONUS_TOTAL_I'	, width: 120	, summaryType: 'sum'},
			{dataIndex: 'YEAR_TOTAL_I'	, width: 120	, summaryType: 'sum'},
			{dataIndex: 'AVG_PAY_I'		, width: 120	, hidden: true},
			{dataIndex: 'RETR_ANNU_I'	, width: 120	, summaryType: 'sum'},
			{dataIndex: 'ADD_MONTH'		, width: 33		, hidden: true},
			{dataIndex: 'RETR_TYPE'		, width: 6		, hidden: true}
		],
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
        listeners: {
            selectionchange: function(grid, selNodes ){
           	   console.log(selNodes[0]);
            	if (typeof selNodes[0] != 'undefined') {
                  sub1Store.clearData();
                  sub2Store.clearData();
                  sub3Store.clearData();
                  sub4Store.clearData();
                  
            	  console.log("===================="+selNodes[0].data.CODE_NAME);
                  
                  person_numb = selNodes[0].data.PERSON_NUMB;
                  retr_type = selNodes[0].data.RETR_TYPE;
                  retr_date = UniDate.getDbDateStr(selNodes[0].data.RETR_DATE);
                  
                  sub1Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub2Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub3Store.loadStoreRecords(person_numb, retr_type, retr_date);
                  sub4Store.loadStoreRecords(person_numb, retr_type, retr_date);
                }
            },
            //마우스 오른쪽 클릭 : 프로그램 링크
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	},
        	//더블클릭 : 프로그램 링크
            onGridDblClick :function( grid, record, cellIndex, colName ) {
        		masterGrid.gotolinkS_Hrt506ukr(record);
            }
        },
      	uniRowContextMenu:{
			items: [
	             {	text: '퇴직금계산 및 조정 보기',  
	            	itemId	: 'linkS_Hrt506ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotolinkS_Hrt506ukr(param.record);
	            	}
	        	}
	        ]
	    },
	    onItemcontextmenu:function( menu, grid, record, item, index, event  )	{   
			return true;
      	},
      	gotolinkS_Hrt506ukr:function(record)	{
			if(record)	{
		    	var params = {
		    		action				: 'select',
			    	'PGM_ID'			: 's_hrt700skr_KOCIS',
			    	'PERSON_NUMB' 		: record.data['PERSON_NUMB'],								
			    	'NAME'				: record.data['NAME'],								
			    	'RETR_TYPE' 		: record.data['RETR_TYPE'],					//정산구분	
			    	'RETR_DATE'			: record.data['RETR_DATE']					//정산일		
				}
      			var rec1 = {data : {prgID : 's_hrt506ukr_KOCIS', 'text':''}};							
				parent.openTab(rec1, '/z_kocis/s_hrt506ukr_KOCIS.do', params);
			}
    	}     
	});//End of var masterGrid = Unilite.createGrid('hrt700skrGrid1', {
	
	var sub1Grid = Unilite.createGrid('sub1Grid', {
    	// for tab    	
        layout: 'fit',
        region:'west',
    	store: sub1Store,
		uniOpt : {						
				useMultipleSorting	: true,			
			    useLiveSearch		: true,			
			    onLoadSelectFirst	: false,				
			    dblClickToEdit		: false,			
			    useGroupSummary		: true,			
				useContextMenu		: false,		
				useRowNumberer		: true,		
				expandLastColumn	: false,			
				useRowContext		: true,					
            	userToolbar			: false,
			    filter: {					
					useFilter		: true,	
					autoCreate		: true	
			},					
			excel: {					
				useExcel		: true,		//엑셀 다운로드 사용 여부
				exportGroup		: false,	//group 상태로 export 여부	
				onlyData		: false,		
				summaryExport	: false			
			}/*,
	    	filter: {
				useFilter	: false,		
				autoCreate	: false		
			}*/				
		},		
		features: [{
			id: 'masterGridSubTotal1'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true },{
			id: 'masterGridTotal1'		, ftype: 'uniSummary'			, showSummaryRow: true
		}],
        columns: [
			{dataIndex: 'PAY_YYYYMM'	, width: 86, align : 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');}
			},
			{dataIndex: 'WAGES_NAME'	, width: 80},
			{dataIndex: 'AMOUNT_I'		, flex:1		, minWidth: 110		, summaryType: 'sum'}
		] 
	});
	
	var sub2Grid = Unilite.createGrid('sub2Grid', {
    	// for tab    	
        layout: 'fit',
        region:'center',
    	store: sub2Store,
		features: [{
			id: 'masterGridSubTotal2'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },{
			id: 'masterGridTotal2'		, ftype: 'uniSummary'			, showSummaryRow: true
		}],
        columns: [
			{dataIndex: 'PAY_YYYYMM'	, width: 86, align : 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');}
			},
			{dataIndex: 'WEL_NAME'		, width: 80},
			{dataIndex: 'GIVE_I'		, flex:1		, minWidth: 110		, summaryType: 'sum'}
		] 
	});
	
	var sub3Grid = Unilite.createGrid('sub3Grid', {
    	// for tab    	
        layout: 'fit',
        region:'east',
    	store: sub3Store,
		features: [{
			id: 'masterGridSubTotal3'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },{
			id: 'masterGridTotal3'		, ftype: 'uniSummary'			, showSummaryRow: true
		}],
        columns: [
			{dataIndex: 'BONUS_YYYYMM'	, width: 86, align : 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');}
			},
			{dataIndex: 'BONUS_TYPE'	, width: 80},
			{dataIndex: 'BONUS_I'		, flex:1		, minWidth: 110		, summaryType: 'sum'}
		] 
	});
	
	var sub4Grid = Unilite.createGrid('sub4Grid', {
        layout: 'fit',
        region:'east',
    	store: sub4Store,
		features: [{
			id: 'masterGridSubTotal4'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },{
			id: 'masterGridTotal4'		, ftype: 'uniSummary'			, showSummaryRow: true
		}],
        columns: [
			{dataIndex: 'BONUS_YYYYMM'	, width: 86, align : 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');}
			},
			{dataIndex: 'BONUS_TYPE'	, width: 80},
			{dataIndex: 'BONUS_I'		, flex:1		, minWidth: 110		, summaryType: 'sum'}
		] 
	});
	
// 	var subTotal =  Unilite.createSimpleForm('subTotal', {
// 		region:'south', 	
//         layout : {type : 'uniTable', columns : 3},
//         padding:'1 1 1 1',
//         defaultType: 'container',
          
//     	items: [{
//     		sub1Grid, sub2Grid, sub3Grid	
//     	}]
// 	});
	
	
	
	
	
	Unilite.Main( {
		id			: 's_hrt700skrApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
			 	panelResult,
				masterGrid, 
				{
					region		: 'south',
					xtype		: 'container',
					minHeight	: 150,
					flex		: 0.3,
					layout		: {type:'hbox', align:'stretch'},
					items		: [
						sub1Grid,
						sub2Grid,
						sub3Grid,
						sub4Grid
					]
				}
			]	
		},
		panelSearch
		],
		
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);

            if(UserInfo.divCode == "01") {
                panelSearch.getField('DIV_CODE').setReadOnly(false);
                panelResult.getField('DIV_CODE').setReadOnly(false);
            }
            else {
                panelSearch.getField('DIV_CODE').setReadOnly(true);
                panelResult.getField('DIV_CODE').setReadOnly(true);
            }
		},
		onQueryButtonDown: function() {			
			masterGrid.getStore().loadStoreRecords();
			
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
