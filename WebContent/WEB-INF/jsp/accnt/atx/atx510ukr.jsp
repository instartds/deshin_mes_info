<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx510ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx510ukrService.selectList',
			update: 'atx510ukrService.updateDetail',
			create: 'atx510ukrService.insertDetail',
			destroy: 'atx510ukrService.deleteDetail',
			syncAll: 'atx510ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Atx510ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'		   	,text: 'COMP_CODE' 				,type: 'string'},
	    	{name: 'FR_PUB_DATE'		,text: '시작계산서일자' 				,type: 'uniDate'},
	    	{name: 'TO_PUB_DATE'		,text: '종료계산서일자' 				,type: 'uniDate'},
	    	{name: 'BILL_DIV_CODE'		,text: '신고사업장' 				,type: 'string'},
	    	{name: 'SEQ'		   	  	,text: '순번' 					,type: 'string'},
	    	{name: 'SEQ_NO'				,text: '일련번호' 					,type: 'string'},
	    	{name: 'WORK_DATE'      	,text: '작성일' 					,type: 'uniDate'},
	    	{name: 'CUSTOM_CODE'		,text: '거래처코드' 				,type: 'string'},
	    	{name: 'CUSTOM_NAME'		,text: '상호(법인명)' 				,type: 'string'},
	    	{name: 'COMPANY_NUM'		,text: '사업자등록번호' 				,type: 'string'},
	    	{name: 'SALE_DATE'	    	,text: '공급일' 					,type: 'uniDate'},
	    	{name: 'ITEM_NAME'	    	,text: '품명' 					,type: 'string'},
	    	{name: 'SALE_Q'	    		,text: '수량' 					,type: 'uniQty'},
	    	{name: 'PUB_DATE'	    	,text: '작성일' 					,type: 'uniDate'},
	    	{name: 'SUPPLY_AMT_I'		,text: '공급가액' 					,type: 'uniPrice'},
	    	{name: 'REMARK'	    		,text: '비고' 					,type: 'string'},
	    	{name: 'INSERT_DB_USER'		,text: 'INSERT_DB_USER' 		,type: 'string'},
	    	{name: 'INSERT_DB_TIME'		,text: 'INSERT_DB_TIME' 		,type: 'uniDate'},
	    	{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER' 		,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME' 		,type: 'uniDate'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx510ukrMasterStore1',{
		model: 'Atx510ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
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
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
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
		    items : [{ 
    			fieldLabel: '계산서일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'temp1_fr',
		        endFieldName: 'temp1_to',
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        allowBlank: false,
		        holdable:'hold',
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('temp1_fr',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('temp1_to',newValue);
			    	}
			    }
	        },{
				fieldLabel: '신고사업장', 
				name: 'temp1', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable:'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('temp1', newValue);
					}
				}
			},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 120',                                                       
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
				}
	    	}]		
		}],
		setAllFieldsReadOnly: function(b) {
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
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '계산서일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'temp1_fr',
	        endFieldName: 'temp1_to',
	        width: 470,
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),
	        allowBlank: false,
	        holdable:'hold',
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('temp1_fr',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('temp1_to',newValue);
		    	}
		    }
        },{
			fieldLabel: '신고사업장', 
			name: 'temp1', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			holdable:'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('temp1', newValue);
				}
			}
		},{
    		xtype: 'button',
    		text: '출력',
    		width: 100,
    		margin: '0 0 0 120',                                                       
    		handler : function() {
				var me = this;
				panelSearch.getEl().mask('로딩중...','loading-indicator');
				var param = panelSearch.getValues();
			}
    	}],
		setAllFieldsReadOnly: function(b) {
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
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	}); 
	
	var tableView = Unilite.createForm('detailForm', { //createForm
		padding:'0 0 0 0',
	    title:'2. 원산지확인서 발급세액공제 계산신고 내용',
		//border: 0,
		disabled: false,
		flex: 1.5,
		xtype: 'container',
		bodyPadding: 10,
		region: 'center',
		layout:{type:'vbox',align: 'stretch'},
		items:[
			{ xtype: 'component', html: '가. 공제대상세액', height:30},
			{
			xtype:'container',
//			height:110,
			layout: {type: 'uniTable', columns: 4, 
	    			tableAttrs: {style: 'border : 1px solid #ced9e7;'},
	    			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
	   		 		},   		 		
	 	   		
	 	   items: [
				{ xtype: 'component',  html:'⑧ 원산지확인서</br> 발 급 건 수'},
		    	{ xtype: 'component',  html:'⑨ 건당 공제금액'},
		    	{ xtype: 'component',  html:'⑩ 공제가능세액</br>(⑧ X 1만원)'},
		    	{ xtype: 'component',  html:'⑪ 해당 공제세액</br>(⑩과 ⑭중 적은 금액)'},
		
		    	{ xtype: 'uniNumberfield', name:'N1', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', name:'N2', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', name:'N3', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', name:'N4', value:'0', readOnly:true}]
		},{
			xtype: 'component', html: '나. 공제 한도액 계산', height:30,margin: '10 0 0 0'
		},{
			xtype:'container',    	
			layout: {type: 'uniTable', columns: 3, 
	       		tableAttrs: {style: 'border : 1px solid #ced9e7;'},
	    		tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}
	    		},
	    		
	   		items:[{ xtype: 'container', html: '나. 공제 한도액 계산', colspan: 3}],
	    	items: [
	    		{ xtype: 'component',  html:'⑫ 연간 공제한도액'},
		    	{ xtype: 'component',  html:'⑬ 기 공제세액'},
		    	{ xtype: 'component',  html:'⑭ 해당 과세기간 공제한도액</br>(⑫ - ⑬)'},
		
		    	{ xtype: 'uniNumberfield', name:'N5', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', name:'N6', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', name:'N7', value:'0', readOnly:true}]
		}]
	});
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('atx510ukrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'south',
    	store: directMasterStore,
    	excelTitle: '원산지확인서 발급세액공제신고서',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
               		 { dataIndex: 'COMP_CODE'				   	   	, 	width: 53, hidden:true},        
               		 { dataIndex: 'FR_PUB_DATE'			   	   		, 	width: 53, hidden:true},         
               		 { dataIndex: 'TO_PUB_DATE'			   	   		, 	width: 53, hidden:true},         
               		 { dataIndex: 'BILL_DIV_CODE'			   	   	, 	width: 53, hidden:true},         
               		 { dataIndex: 'SEQ'		   		   	   			, 	width: 53, hidden:true},         
			{ text: '원산지확인서',
				columns: [
					{ dataIndex: 'SEQ_NO'					   	   	, 	width: 80},         
					{ dataIndex: 'WORK_DATE'     		   	   		, 	width: 80}
				]
			},
			{ text: '공급받는자',
				columns: [
               		 { dataIndex: 'CUSTOM_CODE'			   	   		, 	width: 100},         
               		 { dataIndex: 'CUSTOM_NAME'			   	   		, 	width: 100},         
               		 { dataIndex: 'COMPANY_NUM'			   	   		, 	width: 100}
               	]
			},
			{ text: '공급물품',
				columns: [
               		 { dataIndex: 'SALE_DATE'	   		   	   		, 	width: 66},         
               		 { dataIndex: 'ITEM_NAME'	   		   	   		, 	width: 120},         
               		 { dataIndex: 'SALE_Q'	    			   	   	, 	width: 66}
               ]
			},
			{ text: '세금계산서',
				columns: [
               		 { dataIndex: 'PUB_DATE'	   		   	   		, 	width: 80},         
               		 { dataIndex: 'SUPPLY_AMT_I'			   	   	, 	width: 120}
               ]
			},
               		 { dataIndex: 'REMARK'	    			   	   	, 	width: 133},         
               		 { dataIndex: 'INSERT_DB_USER'		   	   		, 	width: 53, hidden:true},         
               		 { dataIndex: 'INSERT_DB_TIME'		   	   		, 	width: 53, hidden:true},         
               		 { dataIndex: 'UPDATE_DB_USER'		   	   		, 	width: 53, hidden:true},         
               		 { dataIndex: 'UPDATE_DB_TIME'		   	   		, 	width: 53, hidden:true}
        ] 
    });   
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				tableView,
				{
					border: false,	
					flex: 2.5,
					layout: {type: 'vbox', align: 'stretch'},
					region: 'south',
					items: [{
						title :'<원산지(포괄)확인서>			일련번호가 같은 항목은 1건으로 간주합니다.',
						region: 'center',
						border: false
					},masterGrid
					]				
				},panelResult
			]	
		},
			panelSearch
		],
		id  : 'atx510ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('newData',false);
			this.setDefault();
		},
		onQueryButtonDown : function()	{	
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();
				UniAppManager.setToolbarButtons('newData',true);
				return panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
//			var compCode = UserInfo.compCode;
//			var insockDate = UniDate.get('today');
//			var procSw	 = '2'
            	 
            	 var r = {
//            	 	COMP_CODE : compCode,
//            	 	INSOCK_DATE : insockDate,
//            	 	PROC_SW : procSw
		        };
				masterGrid.createRow(r);
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {	
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			tableView.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//				if(selRow.get('ACCOUNT_Q') != 0)
//				{
//					alert('<t:message code="unilite.msg.sMM008"/>');
//				}else{
					masterGrid.deleteSelectedRow();
//				}
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;	
							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
        	panelSearch.setValue('temp1_fr',UniDate.get('today'));
        	panelSearch.setValue('temp1_to',UniDate.get('today'));
        	panelSearch.setValue('temp1',UserInfo.divCode);
        	panelResult.setValue('temp1_fr',UniDate.get('today'));
        	panelResult.setValue('temp1_to',UniDate.get('today'));
        	panelResult.setValue('temp1',UserInfo.divCode);
        	
        	tableView.setValue('N1',0);
        	tableView.setValue('N2',0);
        	tableView.setValue('N3',0);
        	tableView.setValue('N4',0);
        	tableView.setValue('N5',0);
        	tableView.setValue('N6',0);
        	tableView.setValue('N7',0);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};


</script>
