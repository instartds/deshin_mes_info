<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo210skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo210skrv" /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP42" /> <!--발송결과-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mpo210skrvModel', {
	    fields: [
	    	{name: 'DELETE_YN'			, text: '전송파일삭제'	, type: 'string'},
	    	{name: 'TR_BATCHID'			, text: '발송순번'		, type: 'string'},
	    	{name: 'TR_TITLE'			, text: '팩스제목'		, type: 'string'},
	    	{name: 'TR_SENDNAME'		, text: '발신자명'		, type: 'string'},
	    	{name: 'TR_SENDFAXNUM'		, text: '발신자번호'	, type: 'string'},
	    	{name: 'TR_MSGCOUNT'		, text: '통보건수'		, type: 'string'},
	    	{name: 'TR_DOCNAME'			, text: '파일명'		, type: 'string'},
	    	{name: 'TR_SENDSTAT'		, text: '상태값'		, type: 'string'},
	    	{name: 'TR_NAME'			, text: '수신자명'		, type: 'string'},
	    	{name: 'TR_PHONE'			, text: '수신자 팩스번호', type: 'string'},
	    	{name: 'TR_RSLTSTAT'		, text: '발송결과'		, type: 'string', comboType:'AU', comboCode:'YP42'},
	    	{name: 'TR_SENDTIME'		, text: '발송시간'		, type: 'string'},
	    	{name: 'TR_RECVTIME'		, text: '수신시간'		, type: 'string'},
	    	{name: 'TR_PAGECNT'			, text: '페이지수'		, type: 'string'}
	    ]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo210skrvService.selectList',
			update: 'mpo210skrvService.updateDetail',
			syncAll: 'mpo210skrvService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('mpo210skrvMasterStore1', {
		model: 'Mpo210skrvModel',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});				
		},			
		saveStore: function() {
			config = {
				success: function(batch, option) {
					UniAppManager.setToolbarButtons('save', false);
					masterGrid.getStore().loadStoreRecords();
				}
			};
			this.syncAllDirect(config);
		},
		_onStoreDataChanged: function( store, eOpts )	{
	    	
    	}
				
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '발송일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'TR_SENDDATE_FR',
				endFieldName: 'TR_SENDDATE_TO',
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('TR_SENDDATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TR_SENDDATE_TO',newValue);
			    	}
			    }
			},{
				xtype:'uniTextfield',
				name: 'TR_NAME',
				fieldLabel: '수신자',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TR_NAME', newValue);
					}
				}				
			},{
				xtype:'uniTextfield',
				name: 'TR_PHONE',
				fieldLabel: '수신자 팩스번호',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TR_PHONE', newValue);
					}
				}				
			}/*,{
				xtype: 'button',
				text: '전송파일 삭제',
				handler: function(){    	
//					var param = masterGrid.getSelectedRecords();
//					mpo210skrvService.deleteSendFile(param, function(provider, response)	{
//						
//					});
					directMasterStore.saveStore();
				}
				
			}*/]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '발송일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'TR_SENDDATE_FR',
			endFieldName: 'TR_SENDDATE_TO',
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('TR_SENDDATE_FR',newValue);
					
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TR_SENDDATE_TO',newValue);
		    	}
		    }
		},{
			xtype:'uniTextfield',
			name: 'TR_NAME',
			fieldLabel: '수신자',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TR_NAME', newValue);
				}
			}
		},{
			xtype:'uniTextfield',
			name: 'TR_PHONE',
			fieldLabel: '수신자 팩스번호',
			labelWidth: 130,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TR_PHONE', newValue);
				}
			}
		}/*,{
			xtype: 'button',
			text: '전송파일 삭제',
			handler: function(){
				directMasterStore.saveStore();
			}
			
		}*/]
    });		
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mpo210skrvGrid1', {
		layout: 'fit',
		region: 'center',
		excelTitle: '<t:message code="system.label.purchase.postatusinquiry" default="발주현황조회"/>',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false,
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
			showSummaryRow: false
		}],
    	store: directMasterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false
        	,listeners: { 
				select: function(grid, record, index, eOpts ){
					record.set('DELETE_YN', '삭제')
				},	          
				deselect:  function(grid, record, index, eOpts ){
					record.set('DELETE_YN', '')
        		}
        	}
        }),
        columns: [        
        	{dataIndex: 'DELETE_YN'			, width: 100, align: 'center'},
        	{dataIndex: 'TR_BATCHID'		, width: 66, align: 'center'},
        	{dataIndex: 'TR_TITLE'			, width: 150},
        	{dataIndex: 'TR_SENDNAME'		, width: 100},
        	{dataIndex: 'TR_SENDFAXNUM'		, width: 90},
        	{dataIndex: 'TR_MSGCOUNT'		, width: 66, align: 'center'},
        	{dataIndex: 'TR_DOCNAME'		, width: 140},
        	{dataIndex: 'TR_SENDSTAT'		, width: 60, align: 'center'},
        	{dataIndex: 'TR_NAME'			, width: 120},
        	{dataIndex: 'TR_PHONE'			, width: 110},
        	{dataIndex: 'TR_RSLTSTAT'		, width: 250},
        	{dataIndex: 'TR_SENDTIME'		, width: 100},
        	{dataIndex: 'TR_RECVTIME'		, width: 100},
        	{dataIndex: 'TR_PAGECNT'		, width: 66, align: 'center'}
        	
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
		id: 'mpo210skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('TR_SENDDATE_FR',UniDate.get('today'));
			panelSearch.setValue('TR_SENDDATE_TO',UniDate.get('today'));
			panelSearch.setValue('TR_NAME', '');
			panelSearch.setValue('TR_PHONE', '');
			
			panelResult.setValue('TR_SENDDATE_FR',UniDate.get('today'));
			panelResult.setValue('TR_SENDDATE_TO',UniDate.get('today'));
			panelResult.setValue('TR_NAME', '');
			panelResult.setValue('TR_PHONE', '');
			
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {	
			masterGrid.getStore().loadStoreRecords();			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		}
	});
};


</script>
