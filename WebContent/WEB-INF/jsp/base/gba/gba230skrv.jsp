<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="gba230skrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장-->  
	<t:ExtComboStore comboType="AU" comboCode="B046" /> <!--구분-->
</t:appConfig>
<script type="text/javascript">
	function appMain(){
		Unilite.defineModel('Gba230skrvModel', {
			fields:[ {name:'BILL_TYPE',		text:'<t:message code="system.label.base.classfication" default="구분"/>',	  	 		type:'string'}
					,{name:'ORDER_DATE',	text:'수주일',			type:'uniDate'}
					,{name:'DVRY_DATE',		text:'납기일',			type:'uniDate'}
					,{name:'PROJECT_NO',	text:'프로젝트',			type:'string'}
					,{name:'PROJECT_NAME',	text:'프로젝트명',			type:'string'}
					,{name:'CUSTOM_NAME',	text:'고객명',			type:'string'}
					,{name:'ORDER_O',		text:'수주액',			type:'uniPrice'}
					
					,{name:'BUDGET_O',		text:'예산액',			type:'uniPercent'}
					
					,{name:'SALE_RATE',		text:'납품율',			type:'uniPercent'}
					,{name:'SALE_O',		text:'납품액',			type:'uniPrice'}
					
					,{name:'PURCHASE_O',	text:'구매액',			type:'uniPrice'}
					,{name:'STOCK_O',		text:'재고액',			type:'uniPrice'}
					,{name:'D_ETC_AMT',		text:'직과경비',			type:'uniPrice'}
					,{name:'SUB_TOT_O',		text:'계',				type:'uniPrice'}				
					,{name:'ETC_AMT',		text:'경비',				type:'uniPrice'}
				]
		});
		var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'gba230skrvService.selectDetailList'
		}
	});
		var directMasterStore = Unilite.createStore('gba230skrvMasterStore',{
			model: 'Gba230skrvModel',
            autoLoad: false,
            folderSort: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});		
			}
//			groupField:  'BILL_TYPE '
		 
		});
		var panelSearch = Unilite.createSearchForm('searchForm',{
			layout : {type : 'uniTable' , columns:3, tableAttrs: {width: '100%'}},
			items:[{
					fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
		        	xtype: 'uniCombobox', 
		        	comboType:'BOR120',
		        	allowBlank:false,
		        	value: UserInfo.divCode,
		        	name:'DIV_CODE',
		        	listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
						}
					}
				},
				Unilite.popup('PROJECT',{
				fieldLabel: '프로젝트번호',
				valueFieldName:'PJT_CODE',
			    textFieldName:'PJT_NAME',
	       		DBvalueFieldName: 'PJT_CODE',
			    DBtextFieldName: 'PJT_NAME',
			    textFieldOnly: false,
			    validateBlank:false,
				listeners: {
							onSelected: {
								fn: function(records, type) {
									
								},								
								scope: this
							},
							onClear: function(type)	{
								
							}							
						}
			}) 
				 ,{
				 fieldLabel:'완료구분',
				 xtype:'uniCombobox',
				 comboType:'AU',
				 comboCode:'B046',
				 allowBlank:true,
				 name:'STATE',
				 listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						}
					}			
				}
				,{
					fieldLabel:'기간구분',
					xtype:'uniRadiogroup',
					width:300,
					id:'rdoSelect',
					items:[
						{boxLabel:'<t:message code="unilite.msg.sMS122" default="수주일"/>',name: 'rdoSelect',inputValue: '1',checked:true},
						{boxLabel:'<t:message code="unilite.msg.sMS510" default="납기일"/>',name: 'rdoSelect',inputValue: '2'}
					]
				},{
            		fieldLabel:'기간',
            		xtype: 'uniDateRangefield',
            		startFieldName: 'ORDER_DATE',
            		endFieldName: 'ORDER_DATE_TO',    		
//            		allowBlank:false,
            		width:315
				}
			]
		});
		 var masterGrid = Unilite.createGrid('gba230skrvGrid', {
		 	layout : 'fit',
    		region:'center',
		 	store: directMasterStore,
		 	uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
       	 },
       	 features:  [ {id:  'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  true },
    	           	{id:  'masterGridTotal', 	ftype:  'uniSummary', 	  showSummaryRow:  true} ],
		 	columns:[
		 		{text:'수주' , 
	        		columns: [
						{dataIndex: 'BILL_TYPE', 	width: 60 , align:'center'},
						{dataIndex:'ORDER_DATE',width:80, align: 'center', 
       	 			 		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              				return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');}
       	 			 	},
						{dataIndex: 'DVRY_DATE', 	width: 90 , align:'center'}, 
						{dataIndex: 'PROJECT_NO', 	width: 90},
						{dataIndex: 'PROJECT_NAME', width: 150}, 
						{dataIndex: 'CUSTOM_NAME', 		width: 120},
						{dataIndex: 'ORDER_O', 		width: 120,		summaryType: 'sum'}
						]
				},{text:'예산',
					columns:[{dataIndex:'BUDGET_O',	width:120,		summaryType: 'sum'}]
				},{text:'납품',
					columns:[
						{dataIndex:'SALE_RATE',width:80},
						{dataIndex:'SALE_O',width:120,				summaryType: 'sum'}]			
				},{text:'실적',
					columns:[
						{dataIndex:'PURCHASE_O',width:120,			summaryType: 'sum'},
						{dataIndex:'STOCK_O',width:120,				summaryType: 'sum'},
						{dataIndex:'D_ETC_AMT',width:120,			summaryType: 'sum'},
						{dataIndex:'ETC_AMT',width:120,				summaryType: 'sum'},
						{dataIndex:'SUB_TOT_O',width:120,			summaryType: 'sum'}]								
				}
				
			]
		 });
		Unilite.Main({
			items:[panelSearch, 	masterGrid],
			id  : 'gba230skrvApp',
			fnInitBinding : function() {
			panelSearch.setValue("ORDER_DATE",UniDate.get('startOfMonth'));
        	panelSearch.setValue("ORDER_DATE_TO",UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',true);
			},	
			onQueryButtonDown : function() {
				if(!panelSearch.getInvalidMessage()){
					return false;
				
				};
				directMasterStore.loadStoreRecords();	
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('gba230skrvGrid');
				Ext.getCmp('searchForm').getForm().reset();		
				masterGrid.reset();
			this.fnInitBinding();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
			}
		});
	}
</script>