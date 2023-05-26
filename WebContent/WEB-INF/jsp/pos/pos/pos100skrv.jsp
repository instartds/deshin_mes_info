<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pos100skrv"  >
<t:ExtComboStore comboType="AU" comboCode="S010"/>	<!-- 담당자명		-->
<t:ExtComboStore items="${COMBO_POS_NO}" storeId="PosNo" /><!--POS 명-->	
<t:ExtComboStore comboType="BOR120" pgmId="pos100skrv" /> 			<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var searchTime = Unilite.createStore('pos100skrvsSearchTimeStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'08:00'	, 'value':'0800'},
			        {'text':'09:00'	, 'value':'0900'},
			        {'text':'10:00'	, 'value':'1000'},
			        {'text':'11:00'	, 'value':'1100'},
			        {'text':'12:00'	, 'value':'1200'},
			        {'text':'13:00'	, 'value':'1300'},
			        {'text':'14:00'	, 'value':'1400'},
			        {'text':'15:00'	, 'value':'1500'},
			        {'text':'16:00'	, 'value':'1600'},
			        {'text':'17:00'	, 'value':'1700'}
	    		]
	});
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('pos100skrvModel', {
	    fields: [
	    	{name:'POS_NO' 		, text: 'POS'		, type: 'string'},
	    	{name:'POS_NAME' 	, text: 'POS명'		, type: 'string'},
	    	{name:'RECEIPT_NO' 	, text: '영수증NO'	, type: 'string'},
	    	{name:'SALE_TIME' 	, text: '거래시간'		, type: 'string'},
	    	{name:'STAFF_CODE' 	, text: '담당자'		, type: 'string'},
	    	{name:'STAFF_NM' 	, text: '담당자명'		, type: 'string' },
	    	{name:'SALE_Q' 		, text: '매출수량'		, type: 'uniQty'},
	    	{name:'DETAIL_CNT' 	, text: '종수'		, type: 'uniQty'},
	    	{name:'DISCOUNT_O' 	, text: '할인액'		, type: 'uniPrice'},
	    	{name:'CARD_O' 		, text: '카드'		, type: 'uniPrice'},
	    	{name:'CREDIT_O' 	, text: '외상'		, type: 'uniPrice'},
	    	{name:'CASH_O' 		, text: '현금'		, type: 'uniPrice'},
	    	{name:'ETC' 		, text: '기타'		, type: 'uniPrice'},
	    	{name:'TOTAL_AMT_O' , text: '합계'		, type: 'uniPrice'},
	    	{name:'SALE_DATE'   , text: '매출일'      , type: 'uniDate'},
	    	{name:'CUSTOM_NAME' , text: '거래처'      , type: 'string'},
	    	{name:'SALE_DATE' 	, text: '거래일자'		, type: 'string'}
	    	
	    ]
	    
	});		//End of Unilite.defineModel('pos100skrvModel', {
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('pos100skrvMasterStore',{
			model: 'pos100skrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'pos100skrvService.selectList'
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
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
					var msg = count + Msg.sMB001; //'건이 조회되었습니다.';
					UniAppManager.updateStatus(msg, true);
				},
				update: function(store, records, successful, eOpts) {
					store.commitChanges();
					UniAppManager.setToolbarButtons(['save'], false);
				},
				datachanged: function( store, eOpts ){
					store.commitChanges();
					UniAppManager.setToolbarButtons(['save'], false);
				}
			},
			groupField: 'POS_NAME'
			
	});		// End of var MasterStore = Unilite.createStore('pos100skrvMasterStore',{
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
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
			title: '기본정보',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
        	},
        		Unilite.popup('DEPT',{
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),{
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('PosNo'),
		        multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('POS_CODE', newValue);
					},
					beforequery: function(queryPlan, eOpts ) {
				        var pValue = panelSearch.getValue('DIV_CODE');
				        var store = queryPlan.combo.getStore();
				        if(!Ext.isEmpty(pValue)) {
				        	store.clearFilter(true);
				        	queryPlan.combo.queryFilter = null;    
				         	store.filter('option', pValue);
				        }else {
					         store.clearFilter(true);
					         queryPlan.combo.queryFilter = null; 
					         store.loadRawData(store.proxy.data);
				        }
				     }
				}
			},{
		 		fieldLabel: '매출일',
		 		xtype: 'uniDatefield',
		 		name: 'SALE_DATE',
		 		value: UniDate.get('today'), // UniDate.get('today'),
		 		allowBlank: false,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('SALE_DATE', newValue);
					}
				}
			},{
	        	fieldLabel: '시간',
	        	name: 'SALE_TIME',
	        	xtype:'uniCombobox',
	        	store: Ext.data.StoreManager.lookup('pos100skrvsSearchTimeStore'),
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALE_TIME', newValue);
					}
				}
	        },{
		        fieldLabel: '영수증번호',
		        name:'RECEIPT_NO',
		        xtype: 'uniTextfield',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RECEIPT_NO', newValue);
					}
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
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
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
					fieldLabel: '부서',
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
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
				fieldLabel: 'POS',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				store:Ext.data.StoreManager.lookup('PosNo'),
		        multiSelect: true, 
		        typeAhead: false,
				width: 400,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('POS_CODE', newValue);
						},
						beforequery: function(queryPlan, eOpts ) {
					        var pValue = panelSearch.getValue('DIV_CODE');
					        var store = queryPlan.combo.getStore();
					        if(!Ext.isEmpty(pValue)) {
					        	store.clearFilter(true);
					        	queryPlan.combo.queryFilter = null;    
					         	store.filter('option', pValue);
					        }else {
						         store.clearFilter(true);
						         queryPlan.combo.queryFilter = null; 
						         store.loadRawData(store.proxy.data);
					        }
					     }
					}
			},{
		 		fieldLabel: '매출일',
		 		xtype: 'uniDatefield',
		 		name: 'SALE_DATE',
		 		value: UniDate.get('today'), // UniDate.get('today'),
		 		allowBlank: false,
		 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_DATE', newValue);
					}
				}
			},{
	        	fieldLabel: '시간',
	        	name: 'SALE_TIME',
	        	xtype:'uniCombobox',
	        	store: Ext.data.StoreManager.lookup('pos100skrvsSearchTimeStore'),
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SALE_TIME', newValue);
					}
				}
	        },{
		        fieldLabel: '영수증번호',
		        name:'RECEIPT_NO',
		        xtype: 'uniTextfield',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('RECEIPT_NO', newValue);
					}
				}
		    }]
    });
    
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('pos100skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
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
        columns:  [
			{dataIndex:'POS_NO' 	 		, width: 60 , locked: true
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			{dataIndex:'POS_NAME' 			, width: 120 , locked: true},
			{dataIndex:'RECEIPT_NO' 	 	, width: 75  , locked: true ,isLink:true},
			{dataIndex:'SALE_TIME' 	 		, width: 85},
			{dataIndex:'STAFF_CODE'  		, width: 80},
			{dataIndex:'STAFF_NM'  			, width: 95},
			{dataIndex:'SALE_Q' 			, width: 100 , summaryType: 'sum'},
			{dataIndex:'DETAIL_CNT' 		, width: 88 , summaryType: 'sum'},
			{dataIndex:'TOTAL_AMT_O' 		, width: 100 , summaryType: 'sum'},
			{dataIndex:'CASH_O' 			, width: 100 , summaryType: 'sum'},
			{dataIndex:'CARD_O' 			, width: 100 , summaryType: 'sum'},
			{dataIndex:'CREDIT_O' 			, width: 100 , summaryType: 'sum'},
			{dataIndex:'DISCOUNT_O' 		, width: 100 , summaryType: 'sum'},
			{dataIndex:'ETC' 				, width: 100 , summaryType: 'sum'},
			{dataIndex:'CUSTOM_NAME' 		, width: 120 },
			{dataIndex:'SALE_DATE' 			, width: 120 ,hidden:true}
			
			
		],
		listeners: {
			afterrender: function(grid) {	
					//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성					
					this.contextMenu.add(
						{
					        xtype: 'menuseparator'
					    },{	
					    	text: '상세보기',   iconCls : '',
		                	handler: function(menuItem, event) {	
		                		var record = grid.getSelectedRecord();
								var params = {
									action:'select',
									'SALE_DATE' : record.data['SALE_DATE'],
									'POS_NO' : record.data['POS_NO'],
									'RECEIPT_NO' : record.data['RECEIPT_NO']
								}
								var rec = {data : {prgID : 'pos101skrv', 'text':''}};									
								parent.openTab(rec, '/pos/pos101skrv.do', params);
		                	}
		            	}
	       			)
				},
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom || !e.record.phantom)	{
					if (UniUtils.indexOf(e.field, 
							['POS_NO','POS_NAME','RECEIPT_NO','SALE_TIME','STAFF_CODE','STAFF_NM','SALE_Q',
							 'DETAIL_CNT','TOTAL_AMT_O','CASH_O','CARD_O'
							 ,'CREDIT_O','DISCOUNT_O','ETC','SALE_DATE']
							 
						))
					return false;
				}	
			},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'RECEIPT_NO' :
							var params = {
								action:'select',
								'SALE_DATE' : record.data['SALE_DATE'],
								'POS_NO' : record.data['POS_NO'],
								'RECEIPT_NO' : record.data['RECEIPT_NO']
								
								/*'SALE_DATE' 		: panelSearch.setValue('SALE_DATE'),
								'POS_NO' 			: panelSearch.setValue('POS_NO'),
								'POS_NAME'  		: panelSearch.setValue('POS_NAME'),
								'RECEIPT_NO' 		: panelSearch.setValue('RECEIPT_NO')    */
							}
							var rec = {data : {prgID : 'pos101skrv', 'text':''}};							
							parent.openTab(rec, '/pos/pos101skrv.do', params);
							
							break;		
					default:
							break;
	      			}
          		}
          	}
          }
    });		//End of var masterGrid = Unilite.createGrid('pos100skrvGrid', {
    
    /**
	 * Main 정의(Main 정의)
	 * @type 
	 */
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
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons('save',false);
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			/*panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);*/
			panelSearch.setValue('SALE_DATE',UniDate.get('today'));
			panelResult.setValue('SALE_DATE',UniDate.get('today'));
			
			this.processParams(params);
			
			
			/*var param = {DIV_CODE: panelSearch.getValue('DIV_CODE'), POS_CODE: panelSearch.getValue('POS_CODE')}
			pos100skrvService.userPosCode(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('POS_CODE',provider['POS_NO']);
					panelResult.setValue('POS_CODE',provider['POS_NO']);
				}
			})	*/
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			UniAppManager.setToolbarButtons(['print'], false);
			
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var searchParam = Ext.getCmp('searchForm').getValues();
	         var record      = masterGrid.getSelectedRecord();
			 var param= {
				'POS_NO':record.get('POS_NO'),
				'POS_NAME':record.get('POS_NAME'),
				'RECEIPT_NO':record.get('RECEIPT_NO'),
				'CUSTOM_NAME':record.get('CUSTOM_NAME')
			};		
				
			 var params = Ext.merge(searchParam, param);
			 /*console.log( param );
			 this.load({
				 params : params
			 });*/
	          
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/pos/pos100rkrPrint.do',
	            prgID: 'pos100rkr',
	               extParam: {
	                  
	                  DIV_CODE  	: params.DIV_CODE,
	                  SALE_DATE		: params.SALE_DATE,
	                  POS_NO		: params.POS_NO,
	                  POS_NAME		: params.POS_NAME,
	                  RECEIPT_NO	: params.RECEIPT_NO,
	                  CUSTOM_NAME	: params.CUSTOM_NAME
	               }
	            });
	            win.center();
	            win.show();
	               
	    },
		onQueryButtonDown: function(){
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
			
			
			masterGrid.getStore().loadStoreRecords();
			var viewNormal = masterGrid.normalGrid.getView();
			var viewLocked = masterGrid.lockedGrid.getView();
			
			console.log("viewNormal : ",viewNormal);
			console.log("viewLocked : ",viewLocked);
			
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params && params.SALE_DATE ) {
				if(params.action == 'excelNew') {	//품목 신규 등록(수주등록->엑셀참조에서 호출)
					var rec = masterGrid.createRow(
						{
							DIV_CODE :params.DIV_CODE,
							DEPT_CODE :params.DEPT_CODE,
							DEPT_NAME :params.DEPT_NAME,
							SALE_DATE: params.SALE_DATE,
							POS_CODE : params.POS_NO,
							RECEIPT_NO: params.RECEIPT_NO
						}
					);
			        panelSearch.loadForm(rec);
			        panelResult.loadForm(rec);
			       	
				} else {
					panelSearch.setValue('DIV_CODE',params.DIV_CODE);
					panelSearch.setValue('DEPT_CODE',params.DEPT_CODE);
					panelSearch.setValue('DEPT_NAME',params.DEPT_NAME);
					panelSearch.setValue('SALE_DATE',params.SALE_DATE);
					panelSearch.setValue('POS_CODE',params.POS_NO);
					panelSearch.setValue('RECEIPT_NO',params.RECEIPT_NO);
					
					panelResult.setValue('DIV_CODE',params.DIV_CODE);
					panelResult.setValue('DEPT_CODE',params.DEPT_CODE);
					panelResult.setValue('DEPT_NAME',params.DEPT_NAME);
					panelResult.setValue('SALE_DATE',params.SALE_DATE);
					panelResult.setValue('POS_CODE',params.POS_NO);
					panelResult.setValue('RECEIPT_NO',params.RECEIPT_NO);
					
					masterGrid.getStore().loadStoreRecords();
				}
			}
		}
	});		// End of Unilite.Main( {
};
</script>
