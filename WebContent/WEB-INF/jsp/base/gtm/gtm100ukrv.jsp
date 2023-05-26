<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노선별운행시간 등록
request.setAttribute("PKGNAME","Unilite_app_gtm100ukrv");
%>
<t:appConfig pgmId="gtm100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 운행/폐지 구분  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹 		  	-->	
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
</t:appConfig>
<script type="text/javascript">
var selectGrid;
function appMain() {
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'		,type : 'string'  ,editable:false ,allowBlank:false} 
					,{name: 'OPERATION_DATE'    	,text:'운행일'			,type : 'uniDate' ,editable:false ,allowBlank:false} 					
					,{name: 'OPERATION_COUNT'   	,text:'운행순번'		,type : 'uniQty'  ,editable:false ,allowBlank:false} 	
					,{name: 'DUTY_FR_TIME'  		,text:'출근기준시간'		,type : 'string'} 
					,{name: 'DUTY_TO_TIME'  		,text:'퇴근기준시간'		,type : 'string'} 
					
					,{name: 'R0'  					,text:'시각'			,type : 'string'} 
					,{name: 'R1'  					,text:'시각'			,type : 'string'} 
					,{name: 'R2'  					,text:'시각'			,type : 'string'} 
					,{name: 'R3'  					,text:'시각'			,type : 'string'} 
					,{name: 'R4'  					,text:'시각'			,type : 'string'} 
					,{name: 'R5'  					,text:'시각'			,type : 'string'} 
					,{name: 'R6'  					,text:'시각'			,type : 'string'} 
					,{name: 'R7'  					,text:'시각'			,type : 'string'} 
					,{name: 'R8'  					,text:'시각'			,type : 'string'} 
					,{name: 'R9'  					,text:'시각'			,type : 'string'} 
					,{name: 'R10'  					,text:'시각'			,type : 'string'} 
					,{name: 'R11'  					,text:'시각'			,type : 'string'} 
					,{name: 'R12'  					,text:'시각'			,type : 'string'} 
					,{name: 'R13'  					,text:'시각'			,type : 'string'} 
					,{name: 'R14'  					,text:'시각'			,type : 'string'} 
					,{name: 'R15'  					,text:'시각'			,type : 'string'} 
					,{name: 'R16'  					,text:'시각'			,type : 'string'} 
					,{name: 'R17'  					,text:'시각'			,type : 'string'} 
					,{name: 'R18'  					,text:'시각'			,type : 'string'} 
					,{name: 'R19'  					,text:'시각'			,type : 'string'} 
					,{name: 'R20'  					,text:'시각'			,type : 'string'} 
					
					,{name: 'S0'  					,text:'출발'			,type : 'string'} 
					,{name: 'S1'  					,text:'출발'			,type : 'string'} 
					,{name: 'S2'  					,text:'출발'			,type : 'string'} 
					,{name: 'S3'  					,text:'출발'			,type : 'string'} 
					,{name: 'S4'  					,text:'출발'			,type : 'string'} 
					,{name: 'S5'  					,text:'출발'			,type : 'string'} 
					,{name: 'S6'  					,text:'출발'			,type : 'string'} 
					,{name: 'S7'  					,text:'출발'			,type : 'string'} 
					,{name: 'S8'  					,text:'출발'			,type : 'string'} 
					,{name: 'S9'  					,text:'출발'			,type : 'string'} 
					,{name: 'S10'  					,text:'출발'			,type : 'string'} 
					,{name: 'S11'  					,text:'출발'			,type : 'string'} 
					,{name: 'S12'  					,text:'출발'			,type : 'string'} 
					,{name: 'S13'  					,text:'출발'			,type : 'string'} 
					,{name: 'S14'  					,text:'출발'			,type : 'string'} 
					,{name: 'S15'  					,text:'출발'			,type : 'string'} 
					,{name: 'S16'  					,text:'출발'			,type : 'string'} 
					,{name: 'S17'  					,text:'출발'			,type : 'string'} 
					,{name: 'S18'  					,text:'출발'			,type : 'string'} 
					,{name: 'S19'  					,text:'출발'			,type : 'string'} 
					,{name: 'S20'  					,text:'출발'			,type : 'string'} 
					
					,{name: 'E0'  					,text:'도착'			,type : 'string'} 
					,{name: 'E1'  					,text:'도착'			,type : 'string'} 
					,{name: 'E2'  					,text:'도착'			,type : 'string'} 
					,{name: 'E3'  					,text:'도착'			,type : 'string'} 
					,{name: 'E4'  					,text:'도착'			,type : 'string'} 
					,{name: 'E5'  					,text:'도착'			,type : 'string'} 
					,{name: 'E6'  					,text:'도착'			,type : 'string'} 
					,{name: 'E7'  					,text:'도착'			,type : 'string'} 
					,{name: 'E8'  					,text:'도착'			,type : 'string'} 
					,{name: 'E9'  					,text:'도착'			,type : 'string'} 
					,{name: 'E10'  					,text:'도착'			,type : 'string'} 
					,{name: 'E11'  					,text:'도착'			,type : 'string'} 
					,{name: 'E12'  					,text:'도착'			,type : 'string'} 
					,{name: 'E13'  					,text:'도착'			,type : 'string'} 
					,{name: 'E14'  					,text:'도착'			,type : 'string'} 
					,{name: 'E15'  					,text:'도착'			,type : 'string'} 
					,{name: 'E16'  					,text:'도착'			,type : 'string'} 
					,{name: 'E17'  					,text:'도착'			,type : 'string'} 
					,{name: 'E18'  					,text:'도착'			,type : 'string'} 
					,{name: 'E19'  					,text:'도착'			,type : 'string'} 
					,{name: 'E20'  					,text:'도착'			,type : 'string'} 
					
					
					,{name: 'RB0'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB1'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB2'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB3'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB4'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB5'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB6'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB7'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB8'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB9'  					,text:'시각'			,type : 'string'} 
					,{name: 'RB10'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB11'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB12'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB13'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB14'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB15'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB16'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB17'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB18'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB19'  				,text:'시각'			,type : 'string'} 
					,{name: 'RB20'  				,text:'시각'			,type : 'string'} 
					
					,{name: 'BS0'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS1'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS2'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS3'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS4'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS5'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS6'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS7'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS8'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS9'  					,text:'출발'			,type : 'string'} 
					,{name: 'BS10'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS11'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS12'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS13'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS14'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS15'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS16'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS17'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS18'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS19'  				,text:'출발'			,type : 'string'} 
					,{name: 'BS20'  				,text:'출발'			,type : 'string'} 
					
					,{name: 'BE0'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE1'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE2'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE3'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE4'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE5'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE6'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE7'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE8'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE9'  					,text:'도착'			,type : 'string'} 
					,{name: 'BE10'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE11'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE12'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE13'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE14'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE15'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE16'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE17'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE18'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE19'  				,text:'도착'			,type : 'string'} 
					,{name: 'BE20'  				,text:'도착'			,type : 'string'}

					,{name: 'REMARK'  				,text:'<t:message code="system.label.base.remarks" default="비고"/>'			,type : 'string'} 
					,{name: 'MAX_RUN_COUNT'  		,text:'MAX_COL_CNT'			,type : 'string'} 
					,{name: 'MAX_OPERATION_COUNT'  	,text:'MAX_ROW_CNT'			,type : 'string'} 			
					,{name: 'LAST_STOP'   			,text:'하행'			,type : 'string'} 
					,{name: 'START_STOP'  			,text:'상행'			,type : 'string'} 
					
					,{name: 'COMP_CODE'  			,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
			]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'gtm100ukrvService.selectList',
    	   	update 	: 'gtm100ukrvService.update',
    	   	create 	: 'gtm100ukrvService.insert',
    	   	destroy : 'gtm100ukrvService.delete',
			syncAll	: 'gtm100ukrvService.saveAll'
		}
	});

    var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy,
            saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();	
				if(config == null)	{
					config = {
						params:[panelSearch.getValues()],
						success: function()	{
							UniAppManager.setToolbarButtons('save',false);
						}
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
					'ROUTE_CODE': record.get('ROUTE_CODE'),
					'OPERATION_DATE': UniDate.getDateStr(panelSearch.getValue('OPERATION_DATE'))
				}
				this.load({params: param});				
			},
			listeners:{
				load:function(store, records, successful)	{
					masterGrid.makeGrid(0,30);
					if(successful)	{
						UniAppManager.setToolbarButtons('save',false);
						if(records && records.length > 0)	{
							 //종점행
							masterGrid.down('#departure1').setValue(records[0].get('START_STOP'));
    						masterGrid.down('#destination1').setValue(records[0].get('LAST_STOP'));    						
							//기점행
							masterGrid.down('#departure2').setValue(records[0].get('LAST_STOP'));
							masterGrid.down('#destination2').setValue(records[0].get('START_STOP'));
						}else {
							//종점행 
							masterGrid.down('#destination1').setValue('');
							masterGrid.down('#departure1').setValue('');
				
							//기점행
							masterGrid.down('#departure2').setValue('');
							masterGrid.down('#destination2').setValue('');
						}
					}
					/*if(successful)	{
						if(records && records.length > 0)	{
							masterGrid.makeGrid(records[0].get('MAX_OPERATION_COUNT'), records[0].get('MAX_RUN_COUNT'));
							masterGrid.down('#row').setValue(records[0].get('MAX_OPERATION_COUNT'))
							masterGrid.down('#col').setValue(records[0].get('MAX_RUN_COUNT'))
						}
					}*/
				}
			}
            
		});
	
	Unilite.defineModel('${PKGNAME}routeModel', {
	    fields: [
					 {name: 'DIV_CODE'   	,text:'<t:message code="system.label.base.division" default="사업장"/>'		,type : 'string'  ,comboType: 'BOR120' } 
					,{name: 'ROUTE_CODE'    ,text:'노선코드'	,type : 'string' } 
					,{name: 'ROUTE_NUM'    	,text:'번호'	,type : 'string' } 					
					,{name: 'ROUTE_NAME'    ,text:'노선명'		,type : 'string' } 
					,{name: 'ROUTE_STATUS'  ,text:'노선상태'	,type : 'string' ,comboType:'AU', comboCode:'GO13'}
					,{name: 'ACTUAL_CNT'    ,text:'실제댓수'		,type : 'int' } 
					,{name: 'RUN_CNT_MAX'   ,text:'운행횟수_최대'		,type : 'int' } 
					,{name: 'COMP_CODE'  	,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'	,type : 'string' } 
			]
	});


    var routeStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}routeModel',
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
                	   read : 'gopCommonService.selectRouteList'                	   
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
		
	var routeGrid = Unilite.createGrid('${PKGNAME}routeGrid', {
		uniOpt:{
			onLoadSelectFirst: false,
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: false,   
			   useStateList: false  
			}
            
        },
        border:false,
    	store: routeStore,
		columns: [
			{dataIndex:'ROUTE_CODE'		,width: 65 },
			{dataIndex:'ROUTE_NUM'		,width: 50 },
			{dataIndex:'ROUTE_NAME'		,width: 85},
			{dataIndex:'ROUTE_STATUS'	,flex: 1}
		],
		listeners: {
			beforedeselect: function( grid, record, index, eOpts )	{
				if(UniAppManager.app._needSave())	{
					if(confirm(Msg.sMB061))	{
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}  else {
						UniAppManager.app.rejectSave();
					}
				}
			},
      		selectionchange: function( grid, selected, eOpts ) {   
      				/*masterGrid.resetGrid();
      				masterGrid.down('#row').setValue(selected[0].get('ACTUAL_CNT'))
					masterGrid.down('#col').setValue(selected[0].get('RUN_CNT_MAX'))*/
					masterStore.loadStoreRecords(selected[0]);
			}
         }
   });
  	
		
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '운행시간정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
	  	
        width: 330,
		items: [{	
					title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		   			height:110,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',   			
			    	items:[{	    
						fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
						name: 'DIV_CODE',
						hidden:true,
						value:UserInfo.divCode
					},{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						allowBlank:false,
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
						name: 'OPERATION_DATE',
						xtype: 'uniDatefield',
						value: UniDate.today(),
						allowBlank:false,
						listeners:{
							blur:function(field, event, eOpts)	{
								panelSearch.setValue("B_REF_OPERATION_DATE", field.getValue());
							}
						}
					}]				
				},{	
					header: false,
					id: 'search_panel2',
		   			itemId: 'search_panel2',
		   			layout:{type:'vbox', align:'stretch'},
		   			flex: .8,
		           	items: [routeGrid]			
				},{
					itemId:'task',
					title:'운행시간 생성조건',
			        border:0,
			        itemId: 'search_panel3',
		   			height:120,
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:80
		           	},
			        flex:1,			        
			        items: [{	    
						fieldLabel: '영업소',
						name: 'B_OFFICE_CODE',
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO01'
					},{	    
						fieldLabel: '노선그룹',
						name: 'B_ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
						listeners: {
							change:function(field, newValue, oldValue)	{
								panelSearch.setValue('B_ROUTE_CODE', '');
							}
						}
					},{	    
						fieldLabel: '노선',
						name: 'B_ROUTE_CODE'	,
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('routeStore'),
						listeners:{
							beforequery: function(queryPlan, eOpts )	{
								var pValue = panelSearch.getValue('B_ROUTE_GROUP');
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
						fieldLabel:'참조단위',
						xtype:'uniRadiogroup',
						name: 'B_REF_TYPE',
						width: 240,
						items:[
							 { boxLabel: '일단위', name: 'B_REF_TYPE', inputValue: 'D' },
							 { boxLabel: '주간단위', name: 'B_REF_TYPE', inputValue: 'W', checked:true }
						],
						listeners:{
							change:function(field, newValue, oldValue, eOpts)	{
								if(newValue.B_REF_TYPE == "D")	{
									panelSearch.getField("B_REF_OPERATION_DATE").setReadOnly(false);
									panelSearch.getField("B_REF_OPERATION_DATE_FR").setReadOnly(true);
									panelSearch.getField("B_REF_OPERATION_DATE_TO").setReadOnly(true);
								}
								if(newValue.B_REF_TYPE == "W")	{
									panelSearch.getField("B_REF_OPERATION_DATE").setReadOnly(true);
									panelSearch.getField("B_REF_OPERATION_DATE_FR").setReadOnly(false);
									panelSearch.getField("B_REF_OPERATION_DATE_TO").setReadOnly(false);
								}
							}
						}
					
					},{	    
						fieldLabel: '참조운행일',
						name: 'B_REF_OPERATION_DATE',
						xtype: 'uniDatefield',
						value:UniDate.today(),
						readOnly:true,
						listeners:{
			            	blur:function(field, event, eOpts)	{
			            		panelSearch.setValue("OPERATION_DATE", field.getValue());
			            	}
						}
					},{	    
						fieldLabel: '참조운행기간',
						xtype: 'uniDateRangefield',
			            startFieldName: 'B_REF_OPERATION_DATE_FR',
			            endFieldName: 'B_REF_OPERATION_DATE_TO',	
			            startDate: UniDate.add(UniDate.today(),{ days: -7 }),
			            endDate: UniDate.add(UniDate.today(),{ days: -1 }),
			            width:320,
			            allowBlank:false,
			            listeners:{
			            	render: function()	{
			            		this.startDateField.on('blur', this.onBlur, this.startDateField);  	
			            		this.endDateField.on('blur', this.onBlur, this.endDateField);  	
			            	}
		            	},
			            onBlur:function()	{
		            		var sdate = panelSearch.getValue('B_REF_OPERATION_DATE_FR');
		            		var edate = panelSearch.getValue('B_REF_OPERATION_DATE_TO');
		            		if(!Ext.isEmpty(sdate) && !Ext.isEmpty(edate))	{
		            			var diffdays = UniDate.diffDays(sdate,edate);
		            			if(diffdays > 7)	{
		            				Unilite.messageBox("참조운행 기간은 1주일입니다.");
		            				panelSearch.setValue('B_REF_OPERATION_DATE_FR','');
		            				panelSearch.setValue('B_REF_OPERATION_DATE_TO','');
		            			}
		            		}
		            	}
					},{	    
						fieldLabel: '운행일',
						name: 'B_OPERATION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'B_OPERATION_DATE_FR',
			            endFieldName: 'B_OPERATION_DATE_TO',	
			            startDate: UniDate.today(),
			            endDate: UniDate.add(UniDate.today(),{ days: 6 }),
			            width:320,
			            allowBlank:false
					},{
			        	xtype:'button',
			        	text:'실행',
			        	width: 300,
			        	tdAttrs:{'align':'center'},
			        	handler: function()	{
			        		var sForm = Ext.getCmp('${PKGNAME}searchForm');
			        		if(!Ext.isEmpty(sForm.getValue('B_REF_TYPE'))) {
			        			var refType = sForm.getValue('B_REF_TYPE');
				        		if(refType.B_REF_TYPE == 'D'){
					        		if(Ext.isEmpty(sForm.getValue('B_REF_OPERATION_DATE')) )	{
					        			Unilite.messageBox("참조운행일은 필수입력입니다.");
					        			sForm.getField("B_REF_OPERATION_DATE").focus();
					        			return;
					        		}
			        			}
				        		if(refType.B_REF_TYPE == 'W'){
					        		if(Ext.isEmpty(sForm.getValue('B_REF_OPERATION_DATE_FR')) )	{
					        			Unilite.messageBox("참조운행일은 필수입력입니다.");
					        			sForm.getField("B_REF_OPERATION_DATE_FR").focus();
					        			return;
					        		}
					        		
					        		if(Ext.isEmpty(sForm.getValue('B_REF_OPERATION_DATE_TO')))	{
					        			Unilite.messageBox("참조운행일은 필수입력입니다.");
					        			sForm.getField("B_REF_OPERATION_DATE_TO").focus();
					        			return;
					        		}
				        		}
			        		
			        		}else {
			        			Unilite.messageBox("참조딘위는 필수입력입니다.");
					        	sForm.getField("B_REF_TYPE").focus();
					        	return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('B_OPERATION_DATE_FR')) )	{
			        			Unilite.messageBox("운행일은 필수입력입니다.");
			        			sForm.getField("B_OPERATION_DATE_FR").focus();
			        			return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('B_OPERATION_DATE_TO')))	{
			        			Unilite.messageBox("운행일은 필수입력입니다.");
			        			sForm.getField("B_OPERATION_DATE_TO").focus();
			        			return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('B_ROUTE_GROUP')))	{
			        			Unilite.messageBox("노선그룹은 필수입력입니다.");
			        			sForm.getField("B_ROUTE_GROUP").focus();
			        			return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('B_ROUTE_CODE')))	{
			        			Unilite.messageBox("노선은 필수입력입니다.");
			        			sForm.getField("B_ROUTE_CODE").focus();
			        			return;
			        		}
			        		var params = sForm.getValues();
			        		Ext.getBody().mask();
			        		gtm100ukrvService.copySchedule(params, function(provider, response)	{
			        			console.log("response", response);
			        			console.log("provider", provider);
			        			if(provider!= null && provider.ErrorDesc == '')	{
			        				Unilite.messageBox("운행시간 생성이 완료되었습니다.");
			        			}
			        			Ext.getBody().unmask();
			        		})
			        		  
			        	}
			        }]
			}]
		
	});	//end panelSearch     	
		
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
     	region:'center',
        layout : 'fit',       
    	flex: .35,
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: false,   
			   useStateList: false  
			}
        },
        dockedItems: [{
		    xtype: 'toolbar',
		    dock: 'top',
		    items: ['->', 
		    	{xtype:'uniTextfield', itemId:'departure1',		fieldLabel: '하행',  		name:'DEPARTURE1',  		width:130, labelWidth:40,suffixTpl:'~'},
    			{xtype:'uniTextfield', itemId:'destination1',	hideLabel:true, 				name:'DESTINATION1',		width:80, labelWidth:10},
    			{xtype:'uniTextfield', itemId:'departure2',		fieldLabel: '&nbsp;상행',  	name:'DEPARTURE2'  ,  		width:135, labelWidth:45,suffixTpl:'~'},
    			{xtype:'uniTextfield', itemId:'destination2', 	hideLabel:true, 				name:'DESTINATION2',  		width:80, labelWidth:10,suffixTpl:'&nbsp;&nbsp;'}
    			/*'-',
    			{ 
    				xtype: 'uniNumberfield', 
    				itemId:'row', 
    				name:'row', 
    				hideLabel:true, 
    				fieldLabel: '<t:message code="system.label.base.seq" default="순번"/>', 
    				suffixTpl:'&nbsp;순번&nbsp;&nbsp;',
    				width: 70
    			},{ 
    				xtype: 'uniNumberfield', 
    				itemId:'col', 
    				name:'col', 
    				hideLabel:true, 
    				fieldLabel: '회차', 
    				suffixTpl:'&nbsp;회차&nbsp;&nbsp;',
    				width: 70
    			},{ 
    				xtype: 'button', 
    				text: '운행시간표만들기',
        		  	handler:function()	{
        		  		var rowField = masterGrid.down('#row');
        		  		var colField = masterGrid.down('#col');
        		  		
        		  		var colCnt = colField.getValue();
        		  		var rowCnt = rowField.getValue();
        		  		
        		  		if(rowCnt <= 0 || colCnt <= -1)	{
        		  			Unilite.messageBox('순번과 회차를 모두 입력하세요.')
        		  			return;
        		  		}
        		  		masterGrid.makeGrid(rowCnt, colCnt);     
        		  		masterGrid.select(0);
        		  	}
        		 }*//*,
        		 '-',
        		 { 
    				xtype: 'button', 
    				text: '운행시간 재계산',
        		  	handler:function()	{
        		  			var sForm = Ext.getCmp('${PKGNAME}searchForm');
			        		var record = routeGrid.getSelectedRecord();
			        		if(Ext.isEmpty(sForm.getValue('OPERATION_DATE')) )	{
			        			Unilite.messageBox("운행일은 필수입력입니다.");
			        			sForm.getField("OPERATION_DATE").focus();
			        			return;
			        		}
			        		if(!Ext.isDefined(record))	{
			        			Unilite.messageBox("노선정보를 선택하세요.");
			        			return;
			        		}
			        		var params = {
			        			'DIV_CODE'	: record.get('DIV_CODE'),
			        			'ROUTE_CODE': record.get('ROUTE_CODE'),
			        			'OPERATION_DATE': UniDate.getDateStr(panelSearch.getValue('OPERATION_DATE'))
			        		}
			        		Ext.getBody().mask();
			        		gtm100ukrvService.calculateTime(params, function(provider, response)	{
			        			console.log("response", response);
			        			console.log("provider", provider);
			        			if(provider!= null && provider.ErrorDesc == '')	{
			        				Unilite.messageBox("운행시간 재계산이 완료되었습니다.");
			        			}
			        			Ext.getBody().unmask();
			        		})
        		  	}
        		 }*/
        		 
		    ]
		}],
    	store: masterStore,
    	itemId:'masterGrid',
    	
		columns:[
			{dataIndex:'OPERATION_COUNT' ,width: 60},	
			{dataIndex:'DUTY_FR_TIME'		,width: 80},
			{dataIndex:'DUTY_TO_TIME'		,width: 80},
			{	
				text:'0회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S0'	,width: 60},{dataIndex:'E0'		,width: 60},{dataIndex:'R0'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS0'	,width: 60},{dataIndex:'BE0'	,width: 60},{dataIndex:'RB0'	,width: 60}]}
				]
			},
			{text:'1회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S1',itemId:'S1'	,width: 60},{dataIndex:'E1'		,width: 60},{dataIndex:'R1'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS1',itemId:'BS1'	,width: 60},{dataIndex:'BE1'	,width: 60},{dataIndex:'RB1'	,width: 60}]}
				]
			},
			{text:'2회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S2'	,width: 60},{dataIndex:'E2'		,width: 60},{dataIndex:'R2'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS2'	,width: 60},{dataIndex:'BE2'	,width: 60},{dataIndex:'RB2'	,width: 60}]}
				]
			},
			{text:'3회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S3'	,width: 60},{dataIndex:'E3'		,width: 60},{dataIndex:'R3'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS3'	,width: 60},{dataIndex:'BE3'	,width: 60},{dataIndex:'RB3'	,width: 60}]}
				]
			},
			{text:'4회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S4'	,width: 60},{dataIndex:'E4'		,width: 60},{dataIndex:'R4'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS4'	,width: 60},{dataIndex:'BE4'	,width: 60},{dataIndex:'RB4'	,width: 60}]}
				]
			},
			{text:'5회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S5'	,width: 60},{dataIndex:'E5'		,width: 60},{dataIndex:'R5'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS5'	,width: 60},{dataIndex:'BE5'	,width: 60},{dataIndex:'RB5'	,width: 60}]}
				]
			},
			
			{text:'6회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S6'	,width: 60},{dataIndex:'E6'		,width: 60},{dataIndex:'R6'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS6'	,width: 60},{dataIndex:'BE6'	,width: 60},{dataIndex:'RB6'	,width: 60}]}
				]
			},
			{text:'7회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S7'	,width: 60},{dataIndex:'E7'		,width: 60},{dataIndex:'R7'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS7'	,width: 60},{dataIndex:'BE7'	,width: 60},{dataIndex:'RB7'	,width: 60}]}
				]
			},
			{text:'8회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S8'	,width: 60},{dataIndex:'E8'		,width: 60},{dataIndex:'R8'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS8'	,width: 60},{dataIndex:'BE8'	,width: 60},{dataIndex:'RB8'	,width: 60}]}
				]
			},
			{text:'9회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S9'	,width: 60},{dataIndex:'E9'		,width: 60},{dataIndex:'R9'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS9'	,width: 60},{dataIndex:'BE9'	,width: 60},{dataIndex:'RB9'	,width: 60}]}
				]
			},
			{text:'10회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S10'	,width: 60},{dataIndex:'E10'		,width: 60},{dataIndex:'R10'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS10'	,width: 60},{dataIndex:'BE10'	,width: 60},{dataIndex:'RB10'	,width: 60}]}
				]
			},
			
			{text:'11회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S11'	,width: 60},{dataIndex:'E11'		,width: 60},{dataIndex:'R11'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS11'	,width: 60},{dataIndex:'BE11'	,width: 60},{dataIndex:'RB11'	,width: 60}]}
				]
			},
			{text:'12회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S12'	,width: 60},{dataIndex:'E12'		,width: 60},{dataIndex:'R12'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS12'	,width: 60},{dataIndex:'BE12'	,width: 60},{dataIndex:'RB12'	,width: 60}]}
				]
			},
			{text:'13회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S13'	,width: 60},{dataIndex:'E13'		,width: 60},{dataIndex:'R13'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS13'	,width: 60},{dataIndex:'BE13'	,width: 60},{dataIndex:'RB13'	,width: 60}]}
				]
			},
			{text:'14회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S14'	,width: 60},{dataIndex:'E14'		,width: 60},{dataIndex:'R14'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS14'	,width: 60},{dataIndex:'BE14'	,width: 60},{dataIndex:'RB14'	,width: 60}]}
				]
			},
			{text:'15회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S15'	,width: 60},{dataIndex:'E15'		,width: 60},{dataIndex:'R15'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS15'	,width: 60},{dataIndex:'BE15'	,width: 60},{dataIndex:'RB15'	,width: 60}]}
				]
			},
			
			{text:'16회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S16'	,width: 60},{dataIndex:'E16'		,width: 60},{dataIndex:'R16'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS16'	,width: 60},{dataIndex:'BE16'	,width: 60},{dataIndex:'RB16'	,width: 60}]}
				]
			},
			{text:'17회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S17'	,width: 60},{dataIndex:'E17'		,width: 60},{dataIndex:'R17'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS17'	,width: 60},{dataIndex:'BE17'	,width: 60},{dataIndex:'RB17'	,width: 60}]}
				]
			},
			{text:'18회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S18'	,width: 60},{dataIndex:'E18'		,width: 60},{dataIndex:'R18'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS18'	,width: 60},{dataIndex:'BE18'	,width: 60},{dataIndex:'RB18'	,width: 60}]}
				]
			},
			{text:'19회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S19'	,width: 60},{dataIndex:'E19'		,width: 60},{dataIndex:'R19'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS19'	,width: 60},{dataIndex:'BE19'	,width: 60},{dataIndex:'RB19'	,width: 60}]}
				]
			},
			{text:'20회',  
				columns:[
					{text:'하행',  columns:[{dataIndex:'S20'	,width: 60},{dataIndex:'E20'		,width: 60},{dataIndex:'R20'		,width: 60}]},
					{text:'상행',  columns:[{dataIndex:'BS20'	,width: 60},{dataIndex:'BE20'	,width: 60},{dataIndex:'RB20'	,width: 60}]}
				]
			}
			
		],
		listeners:{
			beforeedit:function( editor, e, eOpts )	{
				
				var fieldName = e.field;
				if(fieldName.substring(0,2) == 'RB' || fieldName.substring(0,2) == 'BS' || fieldName.substring(0,1) == 'BE')	{
					masterGrid.setPlace(e.record, fieldName.substring(2,fieldName.length), '2');
				}else {
					masterGrid.setPlace(e.record, fieldName.substring(1,fieldName.length), '1');
				}				
			},
    				
			edit:function( editor, e, eOpts )	{
				var fieldName = e.field;
				var record = e.record;
				var val = e.value;
				if(fieldName == 'DUTY_FR_TIME' || fieldName=='DUTY_TO_TIME' || (fieldName.substring(0,1) == 'R' && fieldName != 'ROUTE_CODE' && fieldName != 'REMARK') )	{
					var date = record.get("OPERATION_DATE");
					
					if(val.length == 4)	{
						val = val.substring(0,2)+":"+val.substring(2,4);
						record.set(fieldName, val);
						editor.value = val;
						e.value = val;
					} else if(val.length == 6){
						val = val.substring(0,2)+":"+val.substring(2,4)+":"+val.substring(4,6);		
						record.set(fieldName, val);
						editor.value = val;
						e.value = val;
					}
				
				}
			},
			
			itemcontextmenu:function( grid, record, item, index, event, eOpts )	{
          	  		event.stopEvent();
					contextMenu.selectedRecord = record;
					contextMenu.selectedIndex = index;
					contextMenu.showAt(event.getXY());					
          	 }
    			
		}
		,
		setPlace: function(record, runCount, direction)	{
			if(direction =='1')	{
				if(Ext.isEmpty(record.get('S'+runCount)))	{
					record.set('S'+runCount, masterGrid.down('#departure1').getValue());
				}
				if(Ext.isEmpty(record.get('E'+runCount)))	{
					record.set('E'+runCount, masterGrid.down('#destination1').getValue());
				}
			}
			if(direction =='2')	{
				if(Ext.isEmpty(record.get('BS'+runCount)))	{
					record.set('BS'+runCount, masterGrid.down('#departure2').getValue());
				}
				if(Ext.isEmpty(record.get('BE'+runCount)))	{
					record.set('BE'+runCount, masterGrid.down('#destination2').getValue());
				}
			}
		}
		,makeGrid: function(rowCnt, colCnt)	{
			/*var columns  = masterGrid.getColumns();
	  		var colPosition = (parseInt(colCnt+1)*2)+1
	  		console.log("colPosition :", colPosition);
	  		
	  		//  Visible and Hide Columns
	  		Ext.each(columns, function(column, index)	{
	  			console.log("column :", column);
	  			console.log("index :", index);
	  			if( index < colPosition)	{ // 운행순번 ~ 출발시간
					column.setWidth(60);
	  			} else if (index == columns.length ) { // 퇴근시간
					column.setWidth(60);
	  			} else {
	  				if(column.isVisible())	{
		  				column.setWidth(0);
		  				// Hide되는 컬럼 빈값 셋팅
		  				Ext.each(masterStore.data.items, function(item, idx)	{
		  					var rNumber = (((index-2)/2)).toString();
		  					console.log('R'+rNumber, item);
		  					item.set('R'+rNumber, '');
		  					item.set('RB'+rNumber, '');
		  			
		  				})
	  				}
	  			}
			});*/
			
			//Insert and Delete Rows
			rowCnt = 50;
			
			var routeRecord = routeGrid.getSelectedRecord();
			if(Ext.isEmpty(routeRecord))	{
				Unilite.messageBox('노선과 운행일을 선택해 주세요.');
				return;
			}else {			
				var newRecord = {};	
				var dataRow = masterStore.getCount();
				for(var i=0 ; i < rowCnt; i++)	{
					if(i > (dataRow-1))	{
						 newRecord = {
						 	'ROUTE_CODE' :  routeRecord.get('ROUTE_CODE'),
							'OPERATION_DATE' :  panelSearch.getValue('OPERATION_DATE'),
							'OPERATION_COUNT' :  parseInt(Unilite.nvl(masterStore.max('OPERATION_COUNT'),0))+1
						}
						if(i==1) {
							var	record =  Ext.create (masterStore.model, newRecord);
							masterStore.insert(1, record);
						}else {
							masterGrid.createRow(newRecord, null, i-1);
						}
					}
				}	
				
				/*dataRow = masterStore.getCount();
				if(dataRow > rowCnt)	{
					for(var i=dataRow-1; i >= rowCnt ; i--)	{							
							masterStore.removeAt(i);							
					}	
				}*/
				
				masterGrid.select(0);
			}
		}
		,resetGrid: function()	{
			/*var columns  = this.getColumns();
	  		this.reset();
	  		//  Visible and Hide Columns
	  		Ext.each(columns, function(column, index)	{	  			
  				if(column.isVisible())	{
	  				column.setVisible(false);
  				}
			});*/
		}
         
   });
    
       var contextMenu = new Ext.menu.Menu({
	        items: [
	                {	text: '선택순번삭제',   iconCls : 'icon-link',
	                	handler: function(menuItem, event) {
	                		var param = menuItem.up('menu');
	                		var record = masterStore.getAt(param.selectedIndex);
	                		for(var i=0;i<=15;i++){
								record.set('S'+i,'');
								record.set('E'+i,'');
								record.set('R'+i,'');
								record.set('BS'+i,'');
								record.set('BE'+i,'');
								record.set('RB'+i,'');
	                		}
	                		UniAppManager.app.setToolbarButtons('save',true);
	                	}
	            	}
	        	]
    	});
    	
    	
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  masterGrid
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print','reset', 'newData'],false);
		},
		
		onQueryButtonDown : function()	{
			//masterGrid.down('#row').setValue('')
			//masterGrid.down('#col').setValue('')
			//masterGrid.resetGrid();			
			masterGrid.reset();		
			routeStore.loadStoreRecords();
		},
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore(config);	
		},
		
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			routeGrid.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
		},
		rejectSave: function() {			
			masterStore.rejectChanges();	
			masterStore.onStoreActionEnable();
		}
	});

	Unilite.createValidator('${PKGNAME}gridValidator', {
		store : masterStore,
		grid: masterGrid,
		//validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
				
			var rv = true;
			console.log("fieldName : ", fieldName);
			console.log("fieldName.substring(0,1) : ", fieldName.substring(0,1));
			
			if(fieldName == 'DUTY_FR_TIME' || fieldName=='DUTY_TO_TIME' || (fieldName.substring(0,1) == 'R' && fieldName != 'ROUTE_CODE' && fieldName != 'REMARK') )	{
				var date = record.get("OPERATION_DATE");
				
				var val = newValue.replace(/:/g, '');
				if(val.length == 4)	{
					if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4)))	{
						//record.set(fieldName, '');
						rv= '시간을 정확히 입력해 주세요.'+'\n'+'예: 06:00:00';
						return;
					}
					/*val = val.substring(0,2)+":"+val.substring(2,4);
					
					record.set(fieldName, val);
					editor.value = val;
					e.value = val;
					*/
				} else if(val.length == 6){
					if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4), val.substring(4,6)))	{
						//record.set(fieldName, '');
						rv= '시간을 정확히 입력해 주세요.'+'\n'+'예: 06:00:00';
						return;
					}
					/*val = val.substring(0,2)+":"+val.substring(2,4)+":"+val.substring(4,6);		
					record.set(fieldName, val);
					editor.value = val;
					e.value = val;
					*/
				} else  if(val.length != 0) {
					rv= '00:00:00(시:분:초) 형식으로 입력하거나 숫자만 입력해 주세요.';
				}
				
			}
			
			if(rv) {
				console.log("masterStore.getUpdatedRecords() : ", masterStore.getUpdatedRecords());
				UniAppManager.setToolbarButtons('save',true);
			}
			return rv;
		}
	}); // validator
	
	
}; // main
  
</script>