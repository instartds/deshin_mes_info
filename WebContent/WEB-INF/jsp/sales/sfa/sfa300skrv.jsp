<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sfa300skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="sfa300skrv"/> <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var idr = '';

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Sfa300skrvModel', {
	    fields: [
	    	{name: 'TEAM_CODE'				, text: '사업팀코드'		, type: 'string'},
	    	{name: 'TEAM_NAME'				, text: '사업팀'			, type: 'string'},
	    	{name: 'DEPT_CODE'				, text: '<t:message code="system.label.sales.department" default="부서"/>'			, type: 'string'},
	    	{name: 'DEPT_NAME'				, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'			, type: 'string'},
	    	{name: 'LAST_YEAR_SALE_AMT_O'	, text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'			, type: 'uniPrice'},
	    	{name: 'LAST_YEAR_CM_FEE'		, text: '위탁수수료'		, type: 'uniPrice'},
	    	{name: 'LAST_YEAR_SALE_AMT_SUM'	, text: '<t:message code="system.label.sales.totalamount" default="합계"/>'			, type: 'uniPrice'},
	    	{name: 'SALE_AMT_O'				, text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'			, type: 'uniPrice'},
	    	{name: 'CM_FEE'					, text: '위탁수수료'		, type: 'uniPrice'},
	    	{name: 'SALE_AMT_SUM'			, text: '<t:message code="system.label.sales.totalamount" default="합계"/>'			, type: 'uniPrice'},
	    	{name: 'INCREASE_DECREASE_O'	, text: '증감액'			, type: 'uniPrice'},
	    	{name: 'INCREASE_DECREASE_RATE'	, text: '<t:message code="system.label.sales.decreasingrate" default="증감율"/>'			, type: 'uniER'},
	    	{name: 'LAST_SALE_DATA_FR'		, text: 'LAST_SALE_DATA_FR'			, type: 'string'},
	    	{name: 'LAST_SALE_DATA_TO'		, text: 'LAST_SALE_DATA_TO'			, type: 'string'},
	    	{name: 'SALE_DATA_FR'			, text: 'SALE_DATA_FR'				, type: 'string'},
	    	{name: 'SALE_DATA_TO'			, text: 'SALE_DATA_TO'				, type: 'string'}
	    ]
	});//End of Unilite.defineModel('Sfa300skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sfa300skrvMasterStore1', {
		model: 'Sfa300skrvModel',
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
				read: 'sfa300skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
				
		},
		
		groupField: 'TEAM_CODE',
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(!Ext.isEmpty(records)){
           			var lastDtFr = records[0].get('LAST_SALE_DATA_FR').substring(0,10);
           			var lastDtTo = records[0].get('LAST_SALE_DATA_TO').substring(0,10);
           			var dtFr = records[0].get('SALE_DATA_FR').substring(0,10);
           			var dtTo = records[0].get('SALE_DATA_TO').substring(0,10);
	           		masterGrid.down('#LAST_SALE_DATA').setText('전년도 매출현황' + ' (' + lastDtFr + ' ~ ' + lastDtTo +')');
					masterGrid.down('#SALE_DATA').setText('금년도 매출현황' + ' (' + dtFr + ' ~ ' + dtTo +')');
           		}
           		
           		var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
	           	
           	}
		}
		/*,
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
			}
		}*/
			
	});//End of var directMasterStore1 = Unilite.createStore('sfa300skrvMasterStore1', {
	
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
				fieldLabel: '매출일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
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
			Unilite.popup('DEPT', { 
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
					}/*,
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
					}*/
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);		
					}
				}
			}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '매출일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'SALE_DATE_FR',
			endFieldName: 'SALE_DATE_TO',
			startDate: UniDate.get('today'),
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
		Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>',
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
				}/*,
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
				}*/
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name: 'DIV_CODE',
			xtype:'uniCombobox',
			comboType:'BOR120',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);		
				}
			}
		}]
	});		// end of var panelSearch = Unilite.createSearchPanel('bid200skrvpanelSearch',{		// 메인
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('sfa300skrvGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
    	store: directMasterStore1,
    	columns: [
        	{dataIndex: 'TEAM_CODE'					, width: 80, hidden: true},
        	{dataIndex: 'TEAM_NAME'					, width: 150},
        	{dataIndex: 'DEPT_CODE'					, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
        	{dataIndex: 'DEPT_NAME'					, width: 150},
        	{       
        	itemId: 'LAST_SALE_DATA',
	      	text:'전년도 매출현황',
     			columns: [
		        	{dataIndex: 'LAST_YEAR_SALE_AMT_O'			, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'LAST_YEAR_CM_FEE'				, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'LAST_YEAR_SALE_AMT_SUM'		, width: 100,summaryType: 'sum'}
        	]},
        	{
    		itemId: 'SALE_DATA',
	      	text:'금년도 매출현황',
     			columns: [
		        	{dataIndex: 'SALE_AMT_O'					, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'CM_FEE'						, width: 100,summaryType: 'sum'},
		        	{dataIndex: 'SALE_AMT_SUM'					, width: 100,summaryType: 'sum'}
        	]},        		   
			{dataIndex: 'INCREASE_DECREASE_O'					, width: 100,summaryType: 'sum'},
        	{dataIndex: 'INCREASE_DECREASE_RATE'				, width: 100,
    		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
    			if(metaData.record.data.LAST_YEAR_SALE_AMT_SUM == 0){
    				return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">' + Ext.util.Format.number(0,'0,000.00'), '<div align="right">' + Ext.util.Format.number(0,'0,000.00'));
    			}else{
			    	return Unilite.renderSummaryRow(summaryData, metaData, '<div align="right">' + Ext.util.Format.number(metaData.record.data.INCREASE_DECREASE_O / metaData.record.data.LAST_YEAR_SALE_AMT_SUM * 100,'0,000.00'), '<div align="right">' + Ext.util.Format.number(metaData.record.data.INCREASE_DECREASE_O / metaData.record.data.LAST_YEAR_SALE_AMT_SUM * 100,'0,000.00'));
    			}
	    	}
        }]
    });//End of var masterGrid = Unilite.createGrid('ssd100skrvGrid1', {  
	
	Unilite.Main({
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
		id: 'sfa300skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('detail',false);
			panelSearch.setValue('SALE_DATE_FR', UniDate.get('today'));
			panelSearch.setValue('SALE_DATE_TO', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_FR', UniDate.get('today'));
			panelResult.setValue('SALE_DATE_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {
			masterGrid.getStore().loadStoreRecords();
			var viewNormal = masterGrid.getView();
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.down('#LAST_SALE_DATA').setText('전년도 매출현황');
			masterGrid.down('#SALE_DATA').setText('금년도 매출현황');
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('searchForm').getValues();
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/sfa/sfa300rkrPrint.do',
	            prgID: 'sfa300rkr',
	               extParam: {	
//					  DIV_CODE			: param.DIV_CODE,		
					  SALE_DATE_FR			: param.SALE_DATE_FR,
					  SALE_DATE_TO			: param.SALE_DATE_TO,
					  DEPT_CODE			: param.DEPT_CODE
//					  COLLECT_DAY		: param.COLLECT_DAY,
//					  CUSTOM_CODE		: param.CUSTOM_CODE,
//					  CUSTOM_NAME		: param.CUSTOM_NAME,
//					  AGENT_TYPE		: param.AGENT_TYPE,
//					  RECEIPT_DAY		: param.RECEIPT_DAY,
//					  CREDIT_YN			: param.CREDIT_YN
					  
	               }
	            });
	            win.center();
	            win.show();
	      }
      
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});
	
};


</script>
