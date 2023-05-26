<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep880ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aep880ukr"/> 						<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	 
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'aep880ukrService.selectList',
        	update: 'aep880ukrService.updateDetail',
			create: 'aep880ukrService.insertDetail',
			destroy: 'aep880ukrService.deleteDetail',
			syncAll: 'aep880ukrService.saveAll'
        }
	});
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('aep880ukrModel', {
		fields: [ 
			{name: 'GL_DATE'			, text: '회계일자'			, type: 'uniDate'},
			{name: 'INVOICE_DATE'		, text: '증빙일자'			, type: 'uniDate'},
			{name: 'SLIP_NO'			, text: '전표번호'			, type: 'string'},
			{name: 'APPR_LINE'			, text: '결재라인'			, type: 'string'},
			{name: 'DEPT_CODE'			, text: '작성부서코드'		, type: 'string'},
			{name: 'DEPT_NAME'			, text: '작성부서'			, type: 'string'},
			{name: 'USER_ID_NAME'		, text: '작성자'			, type: 'string'},
			{name: 'ELEC_SLIP_TYPE_NM'	, text: '문서유형'			, type: 'string'},
			{name: 'VENDOR_CODE'		, text: '거래처코드'		, type: 'string'},
			{name: 'VENDOR_NAME'		, text: '거래처'			, type: 'string'},
			{name: 'CATEGORY_CODE'		, text: '업종코드'			, type: 'string'},
			{name: 'CATEGORY_NAME'		, text: '업종'			, type: 'string'},
			{name: 'ACCOUNT_CODE'		, text: '계정과목코드'		, type: 'string'},
			{name: 'ACCOUNT_NAME'		, text: '계정과목'			, type: 'string'},
			{name: 'SUPPLY_AMOUNT'		, text: '공급가액'			, type: 'uniPrice'},
			{name: 'TAX_AMOUNT'			, text: '부가세액'			, type: 'uniPrice'},
			{name: 'TOTAL_AMOUNT'		, text: '총금액'			, type: 'uniPrice'},
			{name: 'DOC_DESCRIPTION'	, text: '사용내역'			, type: 'string'},
			{name: 'TAX_TYPE'			, text: '세무'			, type: 'string'},
			{name: 'TEST16'				, text: '법인카드과세유형'	, type: 'string'},
			{name: 'TEST17'				, text: '카드상태'			, type: 'string'},
			{name: 'TEST18'				, text: '처리상태'			, type: 'string'}
		]
	});
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore = Unilite.createStore('aep880ukrMasterStore1',{
		model: 'aep880ukrModel',
		uniOpt : {
			isMaster: true,         // 상위 버튼 연결 
       		editable: true,         // 수정 모드 사용 
			deletable:true,         // 삭제 가능 여부 
			useNavi : false         // prev | newxt 버튼 사용
              //비고(*) 사용않함
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
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
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',           	
			items: [{ 
    			fieldLabel: '요청일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'regStDate',
		        endFieldName: 'regEdDate',
		        startDate: UniDate.get('today'),
        		endDate: UniDate.get('today'),
				allowBlank: false,		        
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('regStDate',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('regEdDate',newValue);
			    	}
			    }
	        },{
				fieldLabel: '전기월',  
				name: 'invYymm',
				xtype : 'uniMonthfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('invYymm', newValue);
					}
				}
			},
			Unilite.popup('DEPT',{
				fieldLabel: '작성비용부서',
			  	valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
				validateBlank:false,
				autoPopup:true,
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
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);				
					}
				}
			}),{
				fieldLabel: '유형',
				name:'GL_DATE', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: '',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('GL_DATE', newValue);
					}
				}
			},
			Unilite.popup('Employee',{
				fieldLabel: '작성자',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
				fieldLabel: '전표번호',
				name:'APPR_LINE', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('APPR_LINE', newValue);
					}
				}
			},{
				fieldLabel: '결재번호',
				name:'DEPT_NAME', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DEPT_NAME', newValue);
					}
				}
			},{
				fieldLabel: '제목',
				name:'USER_ID_NAME', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('USER_ID_NAME', newValue);
					}
				}
			},{
				fieldLabel: '진행상태',
				name:'ELEC_SLIP_TYPE_NM', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: '',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ELEC_SLIP_TYPE_NM', newValue);
					}
				}
			}
		]}]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{ 
			fieldLabel: '요청일자',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'regStDate',
	        endFieldName: 'regEdDate',
	        startDate: UniDate.get('today'),
    		endDate: UniDate.get('today'),
			allowBlank: false,		        
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('regStDate',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('regEdDate',newValue);
		    	}
		    }
        },{
			fieldLabel: '전기월',  
			name: 'invYymm',
			xtype : 'uniMonthfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('invYymm', newValue);
				}
			}
		},
		Unilite.popup('DEPT',{
			fieldLabel: '작성비용부서',
		  	valueFieldName:'DEPT_CODE',
		    textFieldName:'DEPT_NAME',
			validateBlank:false,
			autoPopup:true,
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
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);				
				}
			}
		}),{
			fieldLabel: '유형',
			name:'GL_DATE', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: '',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('GL_DATE', newValue);
				}
			}
		},
		Unilite.popup('Employee',{
			fieldLabel: '작성자',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			colspan:2,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),{
			fieldLabel: '전표번호',
			name:'APPR_LINE', 
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('APPR_LINE', newValue);
				}
			}
		},{
			fieldLabel: '결재번호',
			name:'DEPT_NAME', 
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DEPT_NAME', newValue);
				}
			}
		},{
			fieldLabel: '제목',
			name:'USER_ID_NAME', 
			xtype: 'uniTextfield',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('USER_ID_NAME', newValue);
				}
			}
		},{
			fieldLabel: '진행상태',
			name:'ELEC_SLIP_TYPE_NM', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: '',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ELEC_SLIP_TYPE_NM', newValue);
				}
			}
		}
	]
    });
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('aep880ukrGrid1', {
       region: 'center',
        layout: 'fit',
    	uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			onLoadSelectFirst: false,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
    		state: {
				useState: true,			
				useStateList: true		
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
		tbar: [{
			id: 'rejectBtn',
			text: '부결',
        	handler: function() {
	     
	        }
		}],
		store: directMasterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){	

				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
        	}
        }),
        columns: [{
			    xtype: 'rownumberer',        
			    sortable:false,         
			    width: 35, 
			    align:'center  !important',       
			    resizable: true
			},
        	{dataIndex: 'GL_DATE'				, width: 100},
        	{dataIndex: 'INVOICE_DATE'			, width: 88},
        	{dataIndex: 'SLIP_NO'				, width: 130},
        	{dataIndex: 'APPR_LINE'				, width: 300},
        	{dataIndex: 'DEPT_NAME'				, width: 100},
        	{dataIndex: 'USER_ID_NAME'			, width: 100},
        	{dataIndex: 'ELEC_SLIP_TYPE_NM'		, width: 100},
        	{dataIndex: 'VENDOR_CODE'			, width: 180		, hidden: true},
        	{dataIndex: 'VENDOR_NAME'			, width: 180},
        	{dataIndex: 'CATEGORY_CODE'			, width: 120		, hidden: true},
        	{dataIndex: 'CATEGORY_NAME'			, width: 120},
        	{dataIndex: 'ACCOUNT_CODE'			, width: 120		, hidden: true},
        	{dataIndex: 'ACCOUNT_NAME'			, width: 140},
        	{dataIndex: 'SUPPLY_AMOUNT'			, width: 140},
        	{dataIndex: 'TAX_AMOUNT'			, width: 140},
        	{dataIndex: 'TOTAL_AMOUNT'			, width: 140},
        	{dataIndex: 'DOC_DESCRIPTION'		, width: 180},
        	{dataIndex: 'TAX_TYPE'				, width: 100},
        	{dataIndex: 'TEST16'				, width: 100},
        	{dataIndex: 'TEST17'				, width: 100},
        	{dataIndex: 'TEST18'				, width: 100}
        ],
        listeners: {
        	listeners: {  
        	},
        	beforeedit: function(editor, e){      		
        	} 
    	}
    });
   
   
	Unilite.Main({
    	id			: 'aep880ukrApp',
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
		fnInitBinding : function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	UniAppManager.setToolbarButtons('reset',true);
        	UniAppManager.setToolbarButtons(['newData', 'save', 'delete'], false);

        	var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('regStDate');         
			
			Ext.getCmp('rejectBtn').disable();
        },
        
        onQueryButtonDown : function()   {
			if(!this.isValidSearchForm()){
				return false;
			}
        	masterGrid.getStore().loadStoreRecords();
        },
        
		/*onNewDataButtonDown : function() {			
			var r = {
				JOIN_DATE: UniDate.get('today')	
			};
			masterGrid.createRow(r, '');
		},*/
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				masterGrid.getStore().saveStore();
			}
		},
		/*onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},*/
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
   });
};
</script>