<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//차량정보 등록
request.setAttribute("PKGNAME","Unilite_app_gve120ukrv");
%>
<t:appConfig pgmId="gve120ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소   	-->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹   	-->
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->	
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  	,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'		,type : 'string'  	,editable:false} 
					,{name: 'VEHICLE_NAME'    		,text:'차량'			,type : 'string' 	,allowBlank:false} 					
					,{name: 'ROUTE_START_DATE'    	,text:'노선적용일'		,type : 'uniDate' 	,allowBlank:false } 
					,{name: 'OFFICE_CODE'    		,text:'영업소'			,type : 'string'	,comboType:'AU', comboCode:'GO01'}
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'		,type : 'string' 	,comboType:'AU', comboCode:'GO16'} 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'		,type : 'string'	,store: Ext.data.StoreManager.lookup('routeStore')} 
					,{name: 'REMARK'  				,text:'<t:message code="system.label.base.remarks" default="비고"/>'			,type : 'string'} 
					,{name: 'COMP_CODE'  			,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
			]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'gve120ukrvService.selectList',
    	   	update 	: 'gve120ukrvService.update',
    	   	create 	: 'gve120ukrvService.insert',
    	   	destroy : 'gve120ukrvService.delete',
			syncAll	: 'gve120ukrvService.saveAll'
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
				
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					var grid = Ext.getCmp('${PKGNAME}grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
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
						fieldLabel: '차량명',
						name: 'VEHICLE_NAME'
						
					}/*,{	    
						fieldLabel: '노선적용일',
						xtype: 'uniDatefield',
			            name: 'ROUTE_START_DATE',
			            value: UniDate.get('today')
					}*/,{	    
						fieldLabel: '노선그룹',
						name: 'ROUTE_GROUP'	,
						xtype: 'uniCombobox',
						comboType:'AU', 
						comboCode:'GO16',
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
					},
					{
	              xtype: 'uniCombobox',
	              name: 'DEPT_NAME',
	              fieldLabel: '부서코드',
	              comboType:'AU',
	              comboCode:'B015',
	              listeners:{
	              	change:function(field, eOpts)	{
	              		if(Ext.isEmpty(field.getValue())){
	              			field.fireEvent('onClear',  type);	
	              		}else {
	              			field.openPopup();
	              		}
	              	},
	              	onSelected:function(record, type)	{
	              		console.log("onSelected popup:",record);
	              	},
	              	onClear:function(type){
	              		console.log("onClear popup:");
	              	}
	              },
				  app: 'Unilite.app.popup.DeptPopup',
	              openPopup: function() {
   			      		var me = this;

				        var param = {};
				        
					    
			           param['DEPT_NAME'] = '연구소'   ;
			        
			        
				        param['TYPE'] = 'TEXT';   
				        param['pageTitle'] = me.pageTitle;
				        
				     if(me.app) { 
				     	 var fn = function() {
			                var oWin =  Ext.WindowMgr.get(me.app);
			                if(!oWin) {
			                    oWin = Ext.create( me.app, {
			                            id: me.app, 
			                            callBackFn: me.processResult, 
			                            callBackScope: me, 
			                            popupType: 'TEXT',
			                            width: 300,
			                            height:300,
			                            title: '부서코드',
			                            param: param
			                     });
			                }
			                //oWin.fnInitBinding(param);
			                oWin.center();
			               
			                oWin.show();
					     	
					     }
				     }
				     Unilite.require(me.app, fn, this, true);
			        
			    },
			    processResult: function(result, type) {
			        var me = this, rv;
			        console.log("Result: ", result);
			        if(Ext.isDefined(result) && result.status == 'OK') {
			            me.fireEvent('onSelected',  result.data, type); 
			        }
			        
			    }
	              
	         }
					]				
				}]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
        layout : 'fit',        
    	region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
    	store: masterStore,
		columns:[
			{dataIndex:'DIV_CODE'			,width: 100},
			{dataIndex:'VEHICLE_NAME'		,width: 80 ,
			editor:Unilite.popup('VEHICLE_G',
						 {
						 	itemId:'vehicle',
						 	extParam:{'DIV_CODE': UserInfo.divCode}	,
			  				autoPopup: true,
						 	listeners:{
						 		'onSelected':  function(records, type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
				                    	grdRecord.set('VEHICLE_CODE',records[0]['VEHICLE_CODE']);
				                    	grdRecord.set('VEHICLE_NAME',records[0]['VEHICLE_NAME']);
				                }
				                ,'onClear':  function( type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
				                    	grdRecord.set('VEHICLE_CODE','');
				                    	grdRecord.set('VEHICLE_NAME','');
				                }
						 	}
						 }
					)
			},
			{dataIndex:'ROUTE_START_DATE'		,width: 100},
			{dataIndex:'OFFICE_CODE'	,width: 100},
			{dataIndex:'ROUTE_GROUP'	,width: 100},
			{dataIndex:'ROUTE_CODE'		,width: 100},
			{dataIndex:'REMARK'				,flex: 1}
			
		]
   });

      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'excel' ],true);
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
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