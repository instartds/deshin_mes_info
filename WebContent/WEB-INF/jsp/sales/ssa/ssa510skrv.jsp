<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa510skrv" >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa510skrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 정산여부 -->	
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

	Unilite.defineModel('ssa510skrvModel', {
	    fields: [
	    	{name: 'DEPT_CODE'			, text: '<t:message code="system.label.sales.department" default="부서"/>'			, type: 'string'},
	    	{name: 'DEPT_NAME'			, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'			, type: 'string'},
	    	{name: 'SALE_DATE'			, text: '판매일자'			, type: 'uniDate'},
	    	{name: 'POS_NO'				, text: 'POS번호'			, type: 'string'},
	    	{name: 'POS_NAME'			, text: 'POS명'			, type: 'string'},
	    	{name: 'SALE_CUSTOM_CODE'	, text: '<t:message code="system.label.sales.custom" default="거래처"/>'		, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'			, type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			, type: 'string'},
	    	{name: 'SALE_Q'				, text: '판매수량'			, type: 'uniQty'},
	    	{name: 'TOT_AMT'			, text: '<t:message code="system.label.sales.sellingamount" default="판매금액"/>'			, type: 'uniPrice'},
	    	{name: 'RECEIPT_NO'			, text: '<t:message code="system.label.sales.receiptdocno" default="영수증번호"/>'		, type: 'string'}
	    ]
	});//End of Unilite.defineModel('ssa510skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ssa510skrvMasterStore1', {
		model: 'ssa510skrvModel',
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
				read: 'ssa510skrvService.selectList'                	
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
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
				else{
					UniAppManager.setToolbarButtons(['print'], false);
				}
			}
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
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
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
			})]	
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('ssa510skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		uniOpt: {
			expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useRowNumberer: false,
    		filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
	   	store: directMasterStore,
        columns: [
        	{dataIndex: 'DEPT_CODE'			,		 width:	60},
        	{dataIndex: 'DEPT_NAME'			,		 width:	100,
        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
            {dataIndex: 'POS_NO'			,		 width:	60},
        	{dataIndex: 'POS_NAME'			,		 width:	100},
        	{dataIndex: 'RECEIPT_NO'		,		 width:	80 , isLink:true},
        	{dataIndex: 'SALE_DATE'			,		 width:	100},
        	{dataIndex: 'SALE_CUSTOM_CODE'	,		 width:	100},
        	{dataIndex: 'CUSTOM_NAME'		,		 width:	200 },
        	{dataIndex: 'ITEM_CODE'			,		 width:	100},
        	{dataIndex: 'ITEM_NAME'			,		 width:	250},
        	{dataIndex: 'SALE_Q'			,		 width:	80  , summaryType: 'sum'},
        	{dataIndex: 'TOT_AMT'			,		 width:	110 , summaryType: 'sum'}	
		],
		listeners: {
			afterrender: function(grid) {	
					//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성					
				this.contextMenu.add(
					{
				        xtype: 'menuseparator'
				    },{	
				    	text: '<t:message code="system.label.sales.detailsview" default="상세보기"/>',   iconCls : '',
	                	handler: function(menuItem, event) {	
	                		var record = grid.getSelectedRecord();
							var params = {
								action:'select',
								'DIV_CODE'  : panelResult.getValue('DIV_CODE'),
								'DEPT_CODE'  : record.data['DEPT_CODE'],
								'DEPT_NAME'  : record.data['DEPT_NAME'],
								'SALE_DATE' : record.data['SALE_DATE'],
								'POS_NO' : record.data['POS_NO'],
								'RECEIPT_NO' : record.data['RECEIPT_NO']
							}
							var rec = {data : {prgID : 'pos100skrv', 'text':''}};									
							parent.openTab(rec, '/pos/pos100skrv.do', params);
	                	}
	            	}
       			)
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'RECEIPT_NO' :
							var params = {
								action:'select',
								'DIV_CODE'  : panelResult.getValue('DIV_CODE'),
								'DEPT_CODE'  : record.data['DEPT_CODE'],
								'DEPT_NAME'  : record.data['DEPT_NAME'],
								'SALE_DATE' : record.data['SALE_DATE'],
								'POS_NO' : record.data['POS_NO'],
								'RECEIPT_NO' : record.data['RECEIPT_NO']

							}
							var rec = {data : {prgID : 'pos100skrv', 'text':''}};							
							parent.openTab(rec, '/pos/pos100skrv.do', params);
							
							break;		
					default:
							break;
	      			}
          		}
          	}	
		}
    });//End of var masterGrid = Unilite.createGrid('ssa510skrvGrid1', {  
	
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
		id: 'ssa510skrvApp',
		fnInitBinding: function(params) {
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
			UniAppManager.app.processParams(params);
			if(params && params.DIV_CODE){
				masterGrid.getStore().loadStoreRecords();	
			}
		},
		onQueryButtonDown: function() {			
			masterGrid.getStore().loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/ssa/ssa510rkrPrint.do',
	            prgID: 'ssa510rkr',
	               extParam: {
	                  DIV_CODE  	: param.DIV_CODE,
	                  DEPT_CODE 	: param.DEPT_CODE,
	                  SALE_DATE_FR  : param.SALE_DATE_FR,
	                  SALE_DATE_TO  : param.SALE_DATE_TO,
	                  DEPT_NAME		: param.DEPT_NAME,
	                  CUSTOM_CODE 	: param.CUSTOM_CODE,
	                  CUSTOM_NAME 	: param.CUSTOM_NAME
	               }
	            });
	            win.center();
	            win.show();
          
	    },
		processParams: function(params) {
			this.uniOpt.appParams = params;		
			if(params && params.DIV_CODE) {
				if(params.action == 'new') {
		//				Unilite.messageBox('assd')
					panelSearch.setValue('SALE_DATE_FR', params.SALE_DATE_FR);
					panelSearch.setValue('SALE_DATE_TO', params.SALE_DATE_TO);
					panelResult.setValue('SALE_DATE_FR', params.SALE_DATE_FR);
					panelResult.setValue('SALE_DATE_TO', params.SALE_DATE_TO);
					
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
				}
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();			
		}
	});

};


</script>
