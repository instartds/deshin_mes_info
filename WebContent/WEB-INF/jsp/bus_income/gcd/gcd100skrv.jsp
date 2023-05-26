<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일근태내역 조회
request.setAttribute("PKGNAME","Unilite_app_gcd100skrv");
%>
<t:appConfig pgmId="gcd100skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 
	<t:ExtComboStore items="${ROUTEGROUP_COMBO}" storeId="routeGroupStore" /> <!-- 노선그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>					<!-- 영업소   	--> 
	<t:ExtComboStore comboType="AU" comboCode="A020"/>					<!-- 예/아니오   	--> 
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [  	 
	    	{name: 'COMP_CODE'		,		text: '법인코드',				type:'string'},
	    	{name: 'DIV_CODE'		,		text: '사업장코드',				type:'string'},
	    	{name: 'CALCULATE_DATE'	,		text: '운행일',				type:'uniDate'},
	    	{name: 'OFFICE_CODE'	,		text: '영업소',				type:'string',comboType:'AU', comboCode:'GO01'},
	    	{name: 'ROUTE_GROUP'	,		text: '노선그룹',				type:'string',store: Ext.data.StoreManager.lookup('routeGroupStore')},
	    	{name: 'ROUTE_GROUP_NAME',		text: '노선그룹',				type:'string'},
	    	{name: 'ROUTE_CODE'		,		text: '노선코드',				type:'string'},
	    	{name: 'ROUTE_NUM'		,		text: '노선',					type:'string'},
	    	{name: 'VEHICLE_CODE'	,		text: '차량코드',				type:'string'},
	    	{name: 'VEHICLE_NAME'	,		text: '차량명',				type:'string'},
	    	{name: 'ADULT_COUNT'	,		text: '일반건수',				type:'uniQty'},
	    	{name: 'ADULT_AMOUNT'	,		text: '일반금액',				type:'uniPrice'},
	    	{name: 'STUDENT_COUNT'	,		text: '학생건수',				type:'uniQty'},
	    	{name: 'STUDENT_AMOUNT'	,		text: '학생금액',				type:'uniPrice'},
	    	{name: 'CHILD_COUNT'	,		text: '어린이건수',				type:'uniQty'},
	    	{name: 'CHILD_AMOUNT'	,		text: '어린이금액',				type:'uniPrice'},
	    	{name: 'FREE_COUNT'		,		text: '무임건수',				type:'uniQty'},
	    	{name: 'FREE_AMOUNT'	,		text: '무임금액',				type:'uniPrice'},
	    	{name: 'TOTAL_COUNT'	,		text: '건수합계',				type:'uniQty'},
	    	{name: 'TOTAL_AMOUNT'	,		text: '금액합계',				type:'uniPrice'},
	    	{name: 'REMARK'			,		text: '비고',					type:'string'}
		]
	});
	
	Unilite.defineModel('${PKGNAME}model2', {
	    fields: [  	 
	    	{name: 'COMP_CODE'		,		text: '법인코드',				type:'string'},
	    	{name: 'DIV_CODE'		,		text: '사업장코드',				type:'string'},
	    	{name: 'PAYMENT_DATE'	,		text: '운행일',				type:'uniDate'},
	    	{name: 'DRIVER_CODE'	,		text: '기사코드',				type:'string'},
	    	{name: 'DRIVER_NAME'	,		text: '기사명',				type:'string'},
	    	{name: 'VEHICLE_CODE'	,		text: '차량코드',				type:'string'},
	    	{name: 'VEHICLE_NAME'	,		text: '차량명',				type:'string'},
	    	{name: 'ADULT_COUNT'	,		text: '일반건수',				type:'uniQty'},
	    	{name: 'ADULT_AMOUNT'	,		text: '일반금액',				type:'uniPrice'},
	    	{name: 'STUDENT_COUNT'	,		text: '학생건수',				type:'uniQty'},
	    	{name: 'STUDENT_AMOUNT'	,		text: '학생금액',				type:'uniPrice'},
	    	{name: 'CHILD_COUNT'	,		text: '어린이건수',				type:'uniQty'},
	    	{name: 'CHILD_AMOUNT'	,		text: '어린이금액',				type:'uniPrice'},
	    	{name: 'TOTAL_COUNT'	,		text: '건수합계',				type:'uniQty'},
	    	{name: 'TOTAL_AMOUNT'	,		text: '건수금액',				type:'uniPrice'},
	    	{name: 'REMARK'			,		text: '비고',					type:'string'}
	    	
		]
	});

	var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'gcd100skrvService.selectList'
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
            groupField: 'ROUTE_GROUP_NAME'
		});
	var masterStore2 =  Unilite.createStore('${PKGNAME}store2',{
        model: '${PKGNAME}model2',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'gcd100skrvService.selectList2'
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
		
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '카드수입금정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false,
						listeners:{
							change:function(field, newValue, oldValue)	{
								var vehiclePopup = panelSearch.down('#vehicle');
							 	vehiclePopup.setExtParam({'DIV_CODE':newValue});
							}
						}
					},{	    
						fieldLabel: '영업소',
						name: 'OFFICE_CODE',
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO01'
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeGroupStore'),
						listeners: {
							change:function()	{
								panelSearch.setValue('ROUTE_CODE', '');
							}
						}
					},{	    
						fieldLabel: '노선',
						name: 'ROUTE_CODE'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeStore'),
						listeners:{
							beforequery: function(queryPlan, eOpts )	{
								var pValue = panelSearch.getValue('ROUTE_GROUP');
								var store = queryPlan.combo.getStore();
								if(!Ext.isEmpty(pValue) )	{
									store.clearFilter(true);
									queryPlan.combo.queryFilter = null;				
									store.filter('option', pValue);
								} else {
									store.clearFilter(true);
									queryPlan.combo.queryFilter = null;	
									store.loadRawData(store.proxy.data);
								}
							}
						}						
					},{	    
						fieldLabel: '운행일',
						name: 'CALCULATE_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'CALCULATE_DATE_FR',
			            endFieldName: 'CALCULATE_DATE_TO',	
			            startDate: UniDate.get('today'),
			            endDate: UniDate.get('today'),
			            width:320,
						allowBlank:false
					},{
						xtype: 'radiogroup',		            		
						fieldLabel: '조회기준',
						labelWidth:90,
						items : [{
							boxLabel: '정산일',
							width:80,
							name:'RD',
							inputValue: 'A',
							checked: true
						},{
							boxLabel: '사용일',
							width:80,
							name:'RD',
							inputValue: 'B'
						}],
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(panelSearch.getValue('RD') == true){	
								masterGrid2.hide();
								masterGrid.show();
							}else if(panelSearch.getValue('RD') == false){
								masterGrid.hide();
								masterGrid2.show();
							}
							
						}
					}
					}]				
				}]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
        layout : 'fit',        
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore,
		columns:[
			{dataIndex:'COMP_CODE'			,width: 100, hidden: true},
			{dataIndex:'DIV_CODE'			,width: 100, hidden: true},
			{dataIndex:'CALCULATE_DATE'		,width: 100},
			{dataIndex:'OFFICE_CODE'		,width: 100},
			{dataIndex:'ROUTE_GROUP'		,width: 100,hidden:true},
			{dataIndex:'ROUTE_GROUP_NAME'	,width: 100, summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
            	}
            },
			{dataIndex:'ROUTE_CODE'			,width: 100, hidden: true},
			{dataIndex:'ROUTE_NUM'			,width: 100},
			{dataIndex:'VEHICLE_CODE'		,width: 100},
			{dataIndex:'VEHICLE_NAME'		,width: 100},
			{dataIndex:'ADULT_COUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'ADULT_AMOUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'STUDENT_COUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'STUDENT_AMOUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'CHILD_COUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'CHILD_AMOUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'FREE_COUNT'			,width: 100,summaryType: 'sum'},
			{dataIndex:'FREE_AMOUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'TOTAL_COUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'TOTAL_AMOUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'REMARK'				,width: 100}
		] 
   });
   
   var masterGrid2 = Unilite.createGrid('${PKGNAME}grid2', {
        layout : 'fit',        
    	hidden: true,
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore2,
		columns:[
			{dataIndex:'COMP_CODE'			,width: 100, hidden: true},
			{dataIndex:'DIV_CODE'			,width: 100, hidden: true},
			{dataIndex:'PAYMENT_DATE'		,width: 100},
			{dataIndex:'DRIVER_CODE'		,width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
                }
	         },
			{dataIndex:'DRIVER_NAME'		,width: 100},
			{dataIndex:'VEHICLE_CODE'		,width: 100},
			{dataIndex:'VEHICLE_NAME'		,width: 100},
			{dataIndex:'ADULT_COUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'ADULT_AMOUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'STUDENT_COUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'STUDENT_AMOUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'CHILD_COUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'CHILD_AMOUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'TOTAL_COUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'TOTAL_AMOUNT'		,width: 100,summaryType: 'sum'},
			{dataIndex:'REMARK'				,width: 100}
		] 
   });

      Unilite.Main({
		borderItems:[
	 		    panelSearch
	 		  ,{
	 		  	 region:'center',
	 		  	 xtype:'container',
	 		  	 layout:{type:'vbox', align:'stretch'},
	 		  	 items:[
	 		  	 	masterGrid
	 		  	 	,masterGrid2
	 		  	 ]
	 		  }
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print', 'newData'], false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ], true);
		},
		
		onQueryButtonDown : function()	{
			if(masterGrid.isVisible())	{
				masterStore.loadStoreRecords();
			} else if(masterGrid2.isVisible())	{
				masterStore2.loadStoreRecords();
			}
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
			masterGrid.createRow();
		},	
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}
	});

	
	
}; // main
  
</script>