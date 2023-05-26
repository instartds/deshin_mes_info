<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pms500rkrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->     
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="S106" /> <!-- 품목계정 -->

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
	Unilite.defineModel('model1', {
	    fields: [
	    	{name: 'DIV_CODE'		, text: '사업장'					, type: 'string'},
	    	{name: 'CUSTOM_CODE'	, text: '거래처코드'				, type: 'string'},
	    	{name: 'CUSTOM_NAME'	, text: '거래처명'					, type: 'string'},
	    	{name: 'NATION_CODE'	, text: '국가'					, type: 'string'},
	    	{name: 'WKORD_NUM'		, text: '작업지시번호'				, type: 'string'},
	    	{name: 'ITEM_CODE'		, text: '품목코드'					, type: 'string'},
	    	{name: 'ITEM_NAME'		, text: '품목명'					, type: 'string'},
	    	{name: 'SPEC'			, text: '규격'					, type: 'string'},
	    	{name: 'LOT_NO'			, text: 'LOT NO'				, type: 'string'},
	    	{name: 'WKORD_Q'		, text: '수량'					, type: 'uniQty'},
	    	{name: 'SN'					, text: 'SN'				, type: 'string'},
	    	{name: 'EXPIRATION_DATE'	, text: '유효기간'				, type: 'uniDate'},
	    	{name: 'PRINT_Q'			, text: '출력수'				, type: 'int'}
	    ]
	});
	
	var detailStore = Unilite.createStore('detailStore',{
		model: 'model1',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,		// 수정 모드 사용 
            deletable: false,		// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	read: 's_pms500rkrv_mitService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var msg = records.length + Msg.sMB001;
				UniAppManager.updateStatus(msg, true);
           	},
           	add: function(store, records, index, eOpts) {
           		
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		
           	},
           	remove: function(store, record, index, isMove, eOpts) {	
           	}
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120', 
	        	allowBlank: false,
	        	value : UserInfo.divCode,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
				}
	        },{
	        	fieldLabel: '완료예정일', 
				xtype: 'uniDateRangefield', 
				startFieldName: 'PRODT_START_DATE_FR',
	        	endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('PRODT_START_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PRODT_START_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType:'W',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                            prStore.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
				}
			},{
				fieldLabel: '라벨유형',
				name:'LABEL_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S106',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LABEL_TYPE', newValue);
					}
				}
			}]	            			 
		}]
    });    
	
    var panelResult = Unilite.createSimpleForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{
        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        	name:'DIV_CODE', 
        	xtype: 'uniCombobox', 
        	comboType:'BOR120', 
        	allowBlank: false,
        	value : UserInfo.divCode,
        	listeners: {
			change: function(field, newValue, oldValue, eOpts) {						
				panelSearch.setValue('DIV_CODE', newValue);
				panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
        },{
        	fieldLabel: '완료예정일', 
			xtype: 'uniDateRangefield', 
			startFieldName: 'PRODT_START_DATE_FR',
        	endFieldName:'PRODT_START_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PRODT_START_DATE_TO',newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name:'WORK_SHOP_CODE', 
			xtype: 'uniCombobox', 
			comboType:'W',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                    store.clearFilter();
                    prStore.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                        prStore.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                    }else{
                        store.filterBy(function(record){
                            return false;   
                        });
                        prStore.filterBy(function(record){
                            return false;   
                        });
                    }
                }
			}
		},{
			fieldLabel: '라벨유형',
			name:'LABEL_TYPE',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'S106',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('LABEL_TYPE', newValue);
				}
			}
		},{
			xtype:'component'
		},{
			xtype:'button',
			text:'라벨출력',
			disabled:false,
			width: 190,
			margin: '0 0 0 55',
			handler: function(){
           		if(!panelResult.getInvalidMessage()) return;   //필수체크
           		
           		if(Ext.isEmpty(panelResult.getValue('LABEL_TYPE'))){
           			alert('라벨유형을 선택해주십시오.');
           			return false;
           		}
           		
           		var selectedRecords = detailGrid.getSelectedRecords();
           		
           		if(Ext.isEmpty(selectedRecords)){
           			alert('출력할 데이터가 없습니다.');
           			return false;
           		}
           		UniAppManager.app.onPrintButtonDown();

			}
		}]	            			 
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('detailGrid', {
    	layout : 'fit',
    	region:'center',
        store : detailStore, 
        uniOpt:{
        	expandLastColumn: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true,// mode: "SIMPLE",
    		listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
//                	var selectedRecords = tab1Grid.getSelectedRecords();
//                	selectRecord.set('CHECK','Y');
//                    if(Ext.isEmpty(selectedRecords)){
//                    	UniAppManager.setToolbarButtons(['save'], false);
//                    }else{
//                    	UniAppManager.setToolbarButtons(['save'], true);
//                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
//                	var selectedRecords = tab1Grid.getSelectedRecords();
//                	selectRecord.set('CHECK','');
//                    if(Ext.isEmpty(selectedRecords)){
//                    	UniAppManager.setToolbarButtons(['save'], false);
//                    }else{
//                    	UniAppManager.setToolbarButtons(['save'], true);
//                    }
                }
    		}
    	}),
        columns: [
			{dataIndex: 'DIV_CODE'			     			,         	width: 100,hidden:true},	
			{dataIndex: 'CUSTOM_CODE'		     			,         	width: 100},
			{dataIndex: 'CUSTOM_NAME'		     			,         	width: 100},
			{dataIndex: 'NATION_CODE'		     			,         	width: 100},
			{dataIndex: 'WKORD_NUM'			     			,         	width: 100},
			{dataIndex: 'ITEM_CODE'			     			,         	width: 100},
			{dataIndex: 'ITEM_NAME'			     			,         	width: 100},
			{dataIndex: 'SPEC'				     			,         	width: 100},
			{dataIndex: 'LOT_NO'				     		,         	width: 100},
			{dataIndex: 'WKORD_Q'			     			,         	width: 100},
			{dataIndex: 'SN'					     		,         	width: 100},
			{dataIndex: 'EXPIRATION_DATE'	     			,         	width: 100},
			{dataIndex: 'PRINT_Q'			     			,         	width: 100}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,['SN','PRINT_Q'])){
					return true;
				}else{
					return false;
				}
			}
		}
    });
    
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
 			border: false,
         	items:[
				detailGrid, panelResult
			]
		},
			panelSearch
		],	
		id  : 's_pms500rkrv_mitApp',
		fnInitBinding : function() {
			this.fnInitInputFields();
		},
		onQueryButtonDown : function()	{
			if(!panelResult.getInvalidMessage()) return;   //필수체크
			detailStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitInputFields();
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('WORK_SHOP_CODE','W40');
			panelResult.setValue('WORK_SHOP_CODE','W40');
						
			panelSearch.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			panelResult.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			UniAppManager.setToolbarButtons('save', false);
		},
		onPrintButtonDown: function() {
			var dataList = '';
			
			var selectAllRecords = detailGrid.getSelectedRecords();
			
			Ext.each(selectAllRecords, function(selectRecord,index){
				dataList += selectRecord.get('WKORD_NUM')+'$'+selectRecord.get('SN')+'$'+selectRecord.get('PRINT_Q')+'#';
			});
			
			var param = {
				'DIV_CODE':panelResult.getValue('DIV_CODE'),
				'LABEL_TYPE':panelResult.getValue('LABEL_TYPE'),
				'DATA_LIST': dataList
				}
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["MAIN_CODE"] = 'P010';//생산용 공통 코드
			var win = null;
			win = Ext.create('widget.ClipReport', {
				url: CPATH+'/z_mit/s_pms500clrkrv_mit.do',
				prgID: 's_pms500rkrv_mit',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};


</script>
