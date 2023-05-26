<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa511skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa511skrv"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> 				<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> 	<!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> 				<!-- 정산여부 -->	
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

	Unilite.defineModel('ssa511skrvModel', {
	    fields: [
	    	{name: 'SALE_DATE'			, text: '<t:message code="system.label.sales.businessdate" default="거래일"/>'		, type: 'string'},
	    	{name: 'DEPT_CODE'			, text: '<t:message code="system.label.sales.department" default="부서"/>'		, type: 'string'},
	    	{name: 'DEPT_NAME'			, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'		, type: 'string'},
	    	{name: 'POS_NO'				, text: '매장코드'		, type: 'string'},
	    	{name: 'POS_NAME'			, text: 'POS명'		, type: 'string'},
	    	{name: 'RECEIPT_NO'			, text: '<t:message code="system.label.sales.receiptdocno" default="영수증번호"/>'	, type: 'string'},
	    	{name: 'SAP_CODE'			, text: '<t:message code="system.label.sales.department" default="부서"/>'		, type: 'string'},
	    	{name: 'SALE_CUSTOM_CODE'	, text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'	, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.salesplacename" default="매출처명"/>'		, type: 'string'},
	    	{name: 'SALE_AMT_O'			, text: '공급금액'		, type: 'uniPrice'},
	    	{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'		, type: 'uniPrice'},
	    	{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'		, type: 'uniQty'},
	    	{name: 'ITEM_NAME'			, text: '사용내역'		, type: 'string'}
	    ]
	});//End of Unilite.defineModel('ssa511skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ssa511skrvMasterStore1', {
		model: 'ssa511skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'ssa511skrvService.selectList'                	
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: ''
			
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
        		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		holdable: 'hold',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},
				Unilite.popup('DEPT',{
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 				
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},
				Unilite.popup('AGENT_CUST',{
				valueFieldName:'CUSTOM_CODE_FR',
			    textFieldName:'CUSTOM_NAME_FR',
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 				
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE_FR', panelSearch.getValue('CUSTOM_CODE_FR'));
							panelResult.setValue('CUSTOM_NAME_FR', panelSearch.getValue('CUSTOM_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE_FR', '');
						panelResult.setValue('CUSTOM_NAME_FR', '');
					}
				}
			}),
				Unilite.popup('AGENT_CUST',{
				valueFieldName:'CUSTOM_CODE_TO',
			    textFieldName:'CUSTOM_NAME_TO',
				fieldLabel: '~', 				
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE_TO', panelSearch.getValue('CUSTOM_CODE_TO'));
							panelResult.setValue('CUSTOM_NAME_TO', panelSearch.getValue('CUSTOM_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE_TO', '');
						panelResult.setValue('CUSTOM_NAME_TO', '');
					}
				}
			})]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
        		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		holdable: 'hold',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},
			Unilite.popup('DEPT',{
			fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 	
			colspan:2,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){							
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		}),{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
			valueFieldName:'CUSTOM_CODE_FR',
		    textFieldName:'CUSTOM_NAME_FR',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE_FR', panelResult.getValue('CUSTOM_CODE_FR'));
						panelSearch.setValue('CUSTOM_NAME_FR', panelResult.getValue('CUSTOM_NAME_FR'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE_FR', '');
					panelSearch.setValue('CUSTOM_NAME_FR', '');
				}
			}
		}),
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '~', 
			labelWidth:15,
			valueFieldName:'CUSTOM_CODE_TO',
		    textFieldName:'CUSTOM_NAME_TO',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE_TO', panelResult.getValue('CUSTOM_CODE_TO'));
						panelSearch.setValue('CUSTOM_NAME_TO', panelResult.getValue('CUSTOM_NAME_TO'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE_TO', '');
					panelSearch.setValue('CUSTOM_NAME_TO', '');
				}
			}
		})]	
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ssa511skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useRowNumberer: false,
    		filter: {
				useFilter: true,
				autoCreate: true
			},
            excel: {
				onlyData:true
			}
        },
        features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
	   	store: directMasterStore,
        columns: [
        	{dataIndex: 'SALE_DATE'			,		 width:	120,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{dataIndex: 'DEPT_CODE'			,		 width:	80, hidden: true},
        	{dataIndex: 'DEPT_NAME'			,		 width:	120, hidden: true},
        	{dataIndex: 'POS_NO'			,		 width:	80},
        	{dataIndex: 'POS_NAME'			,		 width:	100, hidden: true},
        	{dataIndex: 'RECEIPT_NO'		,		 width:	80},
        	{dataIndex: 'SAP_CODE'			,		 width:	80},
        	{dataIndex: 'SALE_CUSTOM_CODE'	,		 width:	80, hidden: true},
        	{dataIndex: 'CUSTOM_NAME'		,		 width:	150, hidden: true},
        	{dataIndex: 'SALE_AMT_O'		,		 width:	110 , summaryType: 'sum'},
        	{dataIndex: 'TAX_AMT_O'			,		 width:	110 , summaryType: 'sum'},        	
        	{dataIndex: 'SALE_Q'			,		 width:	80 , summaryType: 'sum'},
        	{dataIndex: 'ITEM_NAME'			,		 width:	300}
		],
			listeners: {
				onGridDblClick: function(grid, record, cellIndex, colName) {
					var params = {
						action: 'new',
						DIV_CODE : panelSearch.getValue('DIV_CODE'),
						DEPT_CODE : panelSearch.getValue('DEPT_CODE'),
						DEPT_NAME : panelSearch.getValue('DEPT_NAME'),
						CUSTOM_CODE : panelSearch.getValue('CUSTOM_CODE'),
						CUSTOM_NAME : panelSearch.getValue('CUSTOM_NAME'),
						SALE_DATE_FR : panelSearch.getValue('SALE_DATE_FR'),
						SALE_DATE_TO : panelSearch.getValue('SALE_DATE_TO')
					}
					var rec = {data : {prgID : 'ssa510skrv'}};							
						parent.openTab(rec, '/sales/'+'ssa510skrv'+'.do', params);	
				}
			} 
    });//End of var masterGrid = Unilite.createGrid('ssa511skrvGrid1', {  
	
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
		id: 'ssa511skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('SALE_DATE_TO')));
		},
		onQueryButtonDown: function() {			
			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;		
			if(params) {
				if(params.action == 'new') {
		//				Unilite.messageBox('assd')
					panelSearch.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelSearch.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelResult.setValue('CUSTOM_CODE', params.CUSTOM_CODE);
					panelResult.setValue('CUSTOM_NAME', params.CUSTOM_NAME);
					panelSearch.setValue('DIV_CODE', params.DIV_CODE);
					panelResult.setValue('DIV_CODE', params.DIV_CODE);
					panelSearch.setValue('DEPT_CODE', params.DEPT_CODE);
					panelResult.setValue('DEPT_CODE', params.DEPT_CODE);
					panelSearch.setValue('DEPT_NAME', params.DEPT_NAME);
					panelResult.setValue('DEPT_NAME', params.DEPT_NAME);
					panelSearch.setValue('SALE_DATE_FR', params.SALE_DATE_FR);
					panelResult.setValue('SALE_DATE_FR', params.SALE_DATE_FR);
					panelSearch.setValue('SALE_DATE_TO', params.SALE_DATE_TO);
					panelResult.setValue('SALE_DATE_TO', params.SALE_DATE_TO);
				}
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});

};


</script>
