<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//차량이력정보 등록
request.setAttribute("PKGNAME","Unilite_app_gve110ukrv");
%>
<t:appConfig pgmId="gve110ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO04"/>				<!-- 차량운행상태  	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO05"/>				<!-- 차량용도  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO06"/>				<!-- 차종  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO07"/>				<!-- 제작사  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO08"/>				<!-- 사용연료  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO09"/>				<!-- 폐차(매각)구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 운행/폐지 구분  	-->	
	
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO02"/>				<!-- 운행조   	-->  
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹  	-->	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   				,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
					,{name: 'VEHICLE_CODE'    			,text:'차량코드'		,type : 'string'  ,editable:false } 
					,{name: 'VEHICLE_START_DATE'    	,text:'차량변경적용일'	,type : 'uniDate' ,allowBlank:false, isPk:true, pkGen:'user' } 					
					,{name: 'VEHICLE_END_DATE'    		,text:'차량변경완료일'	,type : 'uniDate' ,defaultValue:'29991231'} 					
					,{name: 'VEHICLE_OP_STATUS'    		,text:'차량운행상태'	,type : 'string' ,comboType: 'AU' ,comboCode: 'GO04'} 					
					,{name: 'VEHICLE_PURPOSE'    		,text:'차량용도'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO05'} 					
					,{name: 'VEHICLE_TYPE'    			,text:'차종'			,type : 'string' ,comboType: 'AU' ,comboCode: 'GO06'} 					
					,{name: 'VEHICLE_MODEL'    			,text:'차명'			,type : 'string' }
					,{name: 'VEHICLE_GRADE'    			,text:'형식'			,type : 'string' } 					
					,{name: 'VEHICLE_MODEL_YEAR'    	,text:'년식'			,type : 'string' }
					,{name: 'VEHICLE_VIN'    			,text:'차대번호'		,type : 'string' } 					
					,{name: 'VEHICLE_ENGINE_TYPE'    	,text:'원동기형식'		,type : 'string' }
					,{name: 'VEHICLE_MAKE'    			,text:'제작사'			,type : 'string' ,comboType: 'AU' ,comboCode: 'GO07'} 					
					,{name: 'VEHICLE_REGIST_DATE'    	,text:'최초등록일'		,type : 'uniDate' }
					,{name: 'VEHICLE_EXPIRE_DATE'    	,text:'차량만료일'		,type : 'uniDate' } 					
					,{name: 'VEHICLE_PURCHASE_DATE'    	,text:'구입일자'		,type : 'uniDate' }
					,{name: 'VEHICLE_PURCHASE_AMT'    	,text:'구입금액'		,type : 'uniPrice' } 					
					,{name: 'PERIODIC_INSPEC_DATE'    	,text:'정기검사일'		,type : 'uniDate' }
					,{name: 'ROUTINE_CHECK_DATE'    	,text:'정기점검일'		,type : 'uniDate' } 					
					,{name: 'MID_INSPEC_DATE'    		,text:'중간점검일'		,type : 'uniDate' }
					,{name: 'CNG_INSPEC_DATE'    		,text:'CNG검사일'		,type : 'uniDate' } 					
					,{name: 'VEHICLE_APPROVAL_NO'    	,text:'승인번호'		,type : 'string' }
					,{name: 'VEHICLE_LENGTH'    		,text:'<t:message code="system.label.base.length" default="길이"/>'			,type : 'uniUnitPrice' } 					
					,{name: 'VEHICLE_WIDTH'    			,text:'너비'			,type : 'uniUnitPrice' }
					,{name: 'VEHICLE_HEIGHT'    		,text:'높이'			,type : 'uniUnitPrice' } 					
					,{name: 'VEHICLE_WEIGHT'    		,text:'중량'			,type : 'uniUnitPrice' }
					,{name: 'VEHICLE_DISPLACEMENT'    	,text:'배기량'			,type : 'uniUnitPrice' } 					
					,{name: 'VEHICLE_MAX_POWER'    		,text:'정격출력'		,type : 'uniUnitPrice' }
					,{name: 'VEHICLE_SEAT_CAPA'    		,text:'승차정원'		,type : 'uniQty' } 					
					,{name: 'VEHICLE_CURB_WEIGHT'    	,text:'최대적재량'		,type : 'uniUnitPrice' }
					,{name: 'VEHICLE_CYLINDERS'    		,text:'기통수'			,type : 'uniUnitPrice' } 					
					,{name: 'VEHICLE_FUEL_SYSTEM'    	,text:'사용연료'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO08'}
					,{name: 'VEHICLE_FUEL_ECONOMY'    	,text:'연비'			,type : 'uniPercent' } 					
					,{name: 'GAS_TANK_COUNT'  			,text:'가스탱크수'		,type : 'uniQty'} 
					,{name: 'AIR_CONDITION_MAKE'  		,text:'에어컨'		,type : 'string'} 
					,{name: 'VEHICLE_DISUSED_STATUS'	,text:'폐차(매각)구분'	,type : 'string' ,comboType: 'AU' ,comboCode: 'GO09'}
					,{name: 'VEHICLE_DISUSED_DATE'    	,text:'폐차(매각)일자'	,type : 'uniDate' } 					
					,{name: 'REMARK'  					,text:'<t:message code="system.label.base.remarks" default="비고"/>'			,type : 'string'} 
					,{name: 'COMP_CODE'  				,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode}
					
			]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'gve110ukrvService.selectList',
    	   	update 	: 'gve110ukrvService.update',
    	   	create 	: 'gve110ukrvService.insert',
    	   	destroy : 'gve110ukrvService.delete',
			syncAll	: 'gve110ukrvService.saveAll'
		}
	});
	
    var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();	
				config = {
					params:[panelSearch.getValues()],
					success: function()	{
						var record = vehicleGrid.getSelectedRecord();
						masterStore.loadStoreRecords(record);
					}
				}
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
				}else {
					var grid = Ext.getCmp('${PKGNAME}grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function(record)	{				
				var param= {
					'DIV_CODE' : record.get('DIV_CODE'),
					'VEHICLE_CODE': record.get('VEHICLE_CODE')
				}
				this.load({params: param});				
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					detailForm.setActiveRecord(record);
				}	
			
			}
            
		});
	
	Unilite.defineModel('${PKGNAME}vehicleModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  ,comboType: 'BOR120'  } 
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'		,type : 'string'  } 
					,{name: 'VEHICLE_NAME'    		,text:'차량명'			,type : 'string'  } 					
					,{name: 'VEHICLE_REGIST_NO'    	,text:'차량등록번호'	,type : 'string'  } 
					,{name: 'REGIST_STATUS'    		,text:'등록상태'	,type : 'string'  ,comboType:'AU', comboCode:'GO13' }
					,{name: 'COMP_CODE'  			,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string'   } 
			]
	});

    var vehicleStore =  Unilite.createStore('${PKGNAME}vehicleStore',{
        model: '${PKGNAME}vehicleModel',
         autoLoad: false,
          uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'gve100ukrvService.selectList'                	   
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				masterStore.loadData({});
				routeHistoryStore.loadData({});
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
		});		
		
	var vehicleGrid = Unilite.createGrid('${PKGNAME}vehicleGrid', {
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
          
        	state: {
			   useState: false,   
			   useStateList: false  
			}
            
        },
        border: false,
    	store: vehicleStore,
		columns: [
			{dataIndex:'VEHICLE_CODE'		,width: 65 },
			{dataIndex:'VEHICLE_NAME'		,width: 50 },
			{dataIndex:'VEHICLE_REGIST_NO'	,width: 100},
			{dataIndex:'REGIST_STATUS'		,flex: 1}
		],
		listeners: {
			beforedeselect: function( grid, record, index, eOpts )	{
				if(masterStore.isDirty() )	{
					if(confirm(Msg.sMB061))	{
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}  else {
						UniAppManager.app.rejectSave();
					}
				}
			},
      		selectionchange: function( grid, selected, eOpts ) {      
					masterStore.loadStoreRecords(selected[0]);
					routeHistoryStore.loadStoreRecords(selected[0]);
			}
         }
   });
		
   
   Unilite.defineModel('${PKGNAME}routeHistoryModel', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  ,comboType: 'BOR120'  } 
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'		,type : 'string'  } 
					,{name: 'OFFICE_CODE'    		,text:'영업소'			,type : 'string'  ,comboType:'AU', comboCode:'GO01'} 					
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'		,type : 'string'  ,comboType:'AU', comboCode:'GO16'} 
					,{name: 'ROUTE_CODE'    		,text:'노선'			,type : 'string'  ,store: Ext.data.StoreManager.lookup('routeStore') }
					,{name: 'ASSIGN_START_DATE'  	,text:'노선변경일'		,type : 'uniDate'   } 
			]
	});

    var routeHistoryStore =  Unilite.createStore('${PKGNAME}routeHistoryModel',{
        model: '${PKGNAME}routeHistoryModel',
         autoLoad: false,
          uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'gve110ukrvService.selectRouteHistory'                	   
                }
            },
			loadStoreRecords: function(record)	{
				if(record)	{
					var param = {
						'DIV_CODE': record.get('DIV_CODE'),
						'VEHICLE_CODE':record.get('VEHICLE_CODE')
					}
					this.load({params: param});
				}else {
					routeHistoryGrid.reset();
				}
			}
            
		});		
		
	var routeHistoryGrid = Unilite.createGrid('${PKGNAME}routeHistoryGrid', {
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
          
        	state: {
			   useState: false,   
			   useStateList: false  
			},
            excel: {
				useExcel: false,		
				exportGroup : false		
			}
        },
    	store: routeHistoryStore,
		columns: [
			{dataIndex:'OFFICE_CODE'		,width: 65 },
			{dataIndex:'ROUTE_GROUP'		,width: 65 },
			{dataIndex:'ROUTE_CODE'			,width: 100},
			{dataIndex:'ASSIGN_START_DATE'	,flex: 1}
		]
   });
   
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '차량정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false
					},{	    
						fieldLabel: '차량코드',
						name: 'VEHICLE_CODE'	
					},{	    
						fieldLabel: '차량명',
						name: 'VEHICLE_NAME'	
					},{	    
						fieldLabel: '차량등록번호',
						name: 'VEHICLE_REGIST_NO'	
					},{	    
						fieldLabel: '등록상태',
						name: 'REGIST_STATUS',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO13'
					}]				
				},{	
					header:false,
					id: 'search_panel2',
		   			itemId: 'search_panel2',
		   			layout:{type:'vbox', align:'stretch'},
		   			flex: .8,
		           	items: [vehicleGrid]			
				},{	
					header:false,
					id: 'search_panel3',
		   			itemId: 'search_panel3',
		   			layout:{type:'vbox', align:'stretch'},
		   			height:100,
		           	items: [routeHistoryGrid]			
				}]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
     	
        layout : 'fit',        
    	region:'center',
    	flex:.35,
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: true,   
			   useStateList: true  
			}
            
        },
    	store: masterStore,
		columns:[
		
			{dataIndex:'DIV_CODE'				,width: 80},
			{dataIndex:'VEHICLE_CODE'			,width: 100},
			{dataIndex:'VEHICLE_START_DATE'		,width: 110},
			{dataIndex:'VEHICLE_END_DATE'		,width: 110},
			{dataIndex:'VEHICLE_OP_STATUS'		,width: 100},
			{dataIndex:'VEHICLE_PURPOSE'		,width: 100},
			{dataIndex:'VEHICLE_TYPE'			,width: 100},
			{dataIndex:'VEHICLE_MODEL'			,width: 100},
			{dataIndex:'VEHICLE_GRADE'			,width: 100},
			{dataIndex:'VEHICLE_MODEL_YEAR'		,width: 100},
			{dataIndex:'VEHICLE_VIN'			,width: 100},
			{dataIndex:'VEHICLE_ENGINE_TYPE'	,width: 100},
			{dataIndex:'VEHICLE_MAKE'			,width: 100},
			{dataIndex:'PERIODIC_INSPEC_DATE'	,width: 100},
			{dataIndex:'ROUTINE_CHECK_DATE'		,width: 100},
			{dataIndex:'MID_INSPEC_DATE'		,width: 100},
			{dataIndex:'CNG_INSPEC_DATE'		,width: 100},
			
			{dataIndex:'GAS_TANK_COUNT'			,width: 100},
			{dataIndex:'AIR_CONDITION_MAKE'		,width: 100}			
		]
		,listeners: {	
      		selectionchangerecord: function( selected ) {
      				detailForm.setActiveRecord(selected);
			}
         }
   });

    var detailForm = Unilite.createForm('${PKGNAME}Form', {
    	region:'south',
    	weight:-100,
    	flex:.65,
        layout : {type:'uniTable', columns:3},
        autoScroll:true,
        masterGrid: masterGrid,
        items:[
        	{	    
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				value: UserInfo.divCode,
				allowBlank:false
			},{	    
				fieldLabel: '차량코드',
				name: 'VEHICLE_CODE',
				readOnly: true,
				allowBlank:false
			},{	    
				fieldLabel: '차량변경적용일',
				name: 'VEHICLE_START_DATE',
				xtype: 'uniDatefield',
				allowBlank:false
			},{	    
				fieldLabel: '차량변경완료일',
				name: 'VEHICLE_END_DATE',
				xtype: 'uniDatefield',
				readOnly: true
			},{	    
				fieldLabel: '차량운행상태',
				name: 'VEHICLE_OP_STATUS',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO04'
			},{	    
				fieldLabel: '차량용도',
				name: 'VEHICLE_PURPOSE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO05'
			},{	    
				fieldLabel: '차종',
				name: 'VEHICLE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO06'
			},{	    
				fieldLabel: '차명',
				name: 'VEHICLE_MODEL'
			},{	    
				fieldLabel: '형식',
				name: 'VEHICLE_GRADE'
			},{	    
				fieldLabel: '년식',
				name: 'VEHICLE_MODEL_YEAR',
				suffixTpl:'&nbsp;년월'
			},{	    
				fieldLabel: '차대번호',
				name: 'VEHICLE_VIN'
			},{	    
				fieldLabel: '원동기형식',
				name: 'VEHICLE_ENGINE_TYPE'
			},{	    
				fieldLabel: '제작사',
				name: 'VEHICLE_MAKE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO07'
			},{	    
				fieldLabel: '최초등록일',
				name: 'VEHICLE_REGIST_DATE',
				xtype: 'uniDatefield'
			},{	    
				fieldLabel: '차량만료일',
				name: 'VEHICLE_EXPIRE_DATE',
				xtype: 'uniDatefield'
			},{	    
				fieldLabel: '구입일자',
				name: 'VEHICLE_PURCHASE_DATE',
				xtype: 'uniDatefield'
			},{	    
				fieldLabel: '구입금액',
				name: 'VEHICLE_PURCHASE_AMT',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '정기검사일',
				name: 'PERIODIC_INSPEC_DATE',
				xtype: 'uniDatefield'
			},{	    
				fieldLabel: '정기점검일',
				name: 'ROUTINE_CHECK_DATE',
				xtype: 'uniDatefield'
			},{	    
				fieldLabel: '중간점검일',
				name: 'MID_INSPEC_DATE',
				xtype: 'uniDatefield'
			},{	    
				fieldLabel: 'CNG검사일',
				name: 'CNG_INSPEC_DATE',
				xtype: 'uniDatefield'
			},{	    
				fieldLabel: '승인번호',
				name: 'VEHICLE_APPROVAL_NO'
			},{	    
				fieldLabel: '<t:message code="system.label.base.length" default="길이"/>',
				name: 'VEHICLE_LENGTH',
				xtype: 'uniNumberfield',
				decimalPrecision:2,
				suffixTpl:'&nbsp;mm'
			},{	    
				fieldLabel: '너비',
				name: 'VEHICLE_WIDTH',
				xtype: 'uniNumberfield',
				decimalPrecision:2,
				suffixTpl:'&nbsp;&nbsp;&nbsp;mm'
			},{	    
				fieldLabel: '높이',
				name: 'VEHICLE_HEIGHT',
				xtype: 'uniNumberfield',
				decimalPrecision:2,
				suffixTpl:'&nbsp;mm'
			},{	    
				fieldLabel: '중량',
				name: 'VEHICLE_WEIGHT',
				xtype: 'uniNumberfield',
				decimalPrecision:2,
				suffixTpl:'&nbsp;&nbsp;&nbsp;Kg'
			},{	    
				fieldLabel: '배기량',
				name: 'VEHICLE_DISPLACEMENT',
				xtype: 'uniNumberfield'	,
				decimalPrecision:2,
				suffixTpl:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cc'
			},{	    
				fieldLabel: '정격출력',
				name: 'VEHICLE_MAX_POWER',
				xtype: 'uniNumberfield',
				decimalPrecision:2,
				suffixTpl:'&nbsp;&nbsp;&nbsp;ps'
			},{	    
				fieldLabel: '승차정원',
				name: 'VEHICLE_SEAT_CAPA',
				xtype: 'uniNumberfield',
				suffixTpl:'&nbsp;&nbsp;&nbsp;&nbsp;명'
			},{	    
				fieldLabel: '최대적재량',
				name: 'VEHICLE_CURB_WEIGHT',
				xtype: 'uniNumberfield',
				decimalPrecision:2,
				suffixTpl:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Kg'
			},{	    
				fieldLabel: '기통수',
				name: 'VEHICLE_CYLINDERS',
				xtype: 'uniNumberfield',
				suffixTpl:'&nbsp;mm'
			},{	    
				fieldLabel: '사용연료',
				name: 'VEHICLE_FUEL_SYSTEM',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO08'
			},{	    
				fieldLabel: '연비',
				name: 'VEHICLE_FUEL_ECONOMY',
				xtype: 'uniNumberfield',
				decimalPrecision:2,
				suffixTpl:'&nbsp;Km/L'
			},{	    
				fieldLabel: '가스탱크수',
				name: 'GAS_TANK_COUNT',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '에어컨',
				name: 'AIR_CONDITION_MAKE',
				colspan: 2,
				width: 490
			},{	    
				fieldLabel: '폐차(매각)구분',
				name: 'VEHICLE_DISUSED_STATUS',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO09'
			},{	    
				fieldLabel: '폐차(매각)일자',
				name: 'VEHICLE_DISUSED_DATE',
				xtype: 'uniDatefield',
				colspan: 2
			},{	    
				fieldLabel: '<t:message code="system.label.base.remarks" default="비고"/>',
				name: 'REMARK',				
				width: 735,
				maxLength:100,
				colspan: 3
			}
        ]
    });	
	
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  masterGrid,
	 		  detailForm
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'excel' ],true);
			if(!Ext.isEmpty(params))	{
				panelSearch.setValue('DIV_CODE',Unilite.nvl(params.DIV_CODE, UserInfo.divCode));
				panelSearch.setValue('VEHICLE_CODE',params.VEHICLE_CODE);
				panelSearch.setValue('VEHICLE_NAME',params.VEHICLE_NAME);
				panelSearch.setValue('VEHICLE_REGIST_NO',params.VEHICLE_REGIST_NO);
				panelSearch.setValue('REGIST_STATUS',params.REGIST_STATUS);
				UniAppManager.app.onQueryButtonDown();
			}
		},
		
		onQueryButtonDown : function()	{
			detailForm.clearForm();
			detailForm.setDisabled( true )
			vehicleStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
			var selectedRec = vehicleGrid.getSelectedRecord();
			var masterGridRec = masterGrid.getSelectedRecord();
			var r = {};
			if(!Ext.isEmpty(selectedRec))	{
				
				if(!Ext.isEmpty(masterGridRec) || masterGridRec != null)	{
					r = masterGridRec.data;
					r["VEHICLE_START_DATE"] = UniDate.getDateStr(UniDate.today());
					r["VEHICLE_END_DATE"] = "29991231";
					r["PERIODIC_INSPEC_DATE"] = "";
					r["ROUTINE_CHECK_DATE"] = "";
					r["MID_INSPEC_DATE"] = "";
					r["CNG_INSPEC_DATE"] = "";
					r["VEHICLE_EXPIRE_DATE"] = "";
					r["VEHICLE_DISUSED_STATUS"] = "";
					r["VEHICLE_DISUSED_DATE"] = "";
					r["REMARK"] = "";
				} else{
				    r = { 'DIV_CODE': panelSearch.getValue('DIV_CODE'),				
						  'VEHICLE_CODE' : selectedRec.get('VEHICLE_CODE')
						}
				}
				masterGrid.createRow(r);
			}else {
				Unilite.messageBox('차량을 조회 후 선택하세요.')
			}
		},	
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore(config);					
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
		},
		rejectSave: function() {			
			masterStore.rejectChanges();	
			masterStore.onStoreActionEnable();
		}
	});

	Unilite.createValidator('validator01', {
		store : masterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName)	{
				case 'VEHICLE_START_DATE' :		// 거래처(약명)
					var params = {
						'COMP_CODE': UserInfo.compCode,
						'DIV_CODE' : record.get('DIV_CODE'),
						'VEHICLE_CODE': record.get('VEHICLE_CODE'),
						'VEHICLE_START_DATE': newValue
					}
					
					Ext.getBody().mask();
					var rec = record;
					gve110ukrvService.checkDate(params, function(provider, response)	{
						if(provider['CNT'] > 0)	{
							Unilite.messageBox('입력된 차량변경적용일은 이미 등록되어 있습니다.'+'\n'+'기존 등록된 변경적용일 이후의 날짜를 등록하세요.')
							rec.set('VEHICLE_START_DATE', oldValue);
							detailForm.setValue('VEHICLE_START_DATE', oldValue);
						}
						Ext.getBody().unmask();
					})
					break;
				default :
					break;
			}
			return rv;
		}
	}); // validator
	
}; // main
  
</script>