<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//운행현황 
request.setAttribute("PKGNAME","Unilite_app_grd200ukrv");
%>
<t:appConfig pgmId="grd200ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="GO10"/>					<!-- 운행구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO11"/>					<!-- 노선구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO12"/>					<!-- 시계	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {

		fields: [
			{name: 'COMP_CODE'      		,text:'법인코드'						,type : 'string'}, 
		//	{name: 'SERVICE_YEAR'   		,text:'기준년도'						,type : 'uniDate'},
			{name: 'ROUTE_NUM'      		,text:'노선번호</br>&nbsp;&nbsp;(B+NM)'			,type : 'string', allowBlank: false},
			{name: 'ROUTE_ID'       		,text:'노선번호</br>&nbsp;&nbsp;(ID)'				,type : 'string', allowBlank: false},
			{name: 'OPERATION_TYPE' 		,text:'유형구분'						,type : 'string',comboType:'AU', comboCode:'GO10', allowBlank: false},
			{name: 'ROUTE_TYPE'     		,text:'노선구분'						,type : 'string',comboType:'AU', comboCode:'GO11', allowBlank: false},
			{name: 'OPERATION_MONTH'		,text:'운행연월'						,type : 'string', allowBlank: false},
			{name: 'DATE_COUNT'     		,text:'월일자'						,type : 'string'},
			{name: 'OWN_BUS'        		,text:'보유대수</br>&nbsp;&nbsp;(대/일)'			,type : 'uniQty'},
			{name: 'OPERATION_BUS'  		,text:'가동대수</br>&nbsp;&nbsp;(대/일)'			,type : 'uniQty'},
			{name: 'BACKUP_BUS'    			,text:'예비차량</br>&nbsp;&nbsp;(대/일)'			,type : 'uniQty'},
			{name: 'APPROV_DISTANCE'		,text:'노선거리</br>&nbsp;&nbsp;(편도,KM)'			,type : 'uniPrice'},
			{name: 'RUN_CNT_AVG'    		,text:'평균운행 회수 편도기준</br>&nbsp;&nbsp;(회/대/일)'	,type : 'uniQty'},
			{name: 'EMPTY_DISTANCE' 		,text:'공차거리</br>&nbsp;&nbsp;(KM/대/일)'			,type : 'uniPrice'},
			{name: 'OWN_BUS_COUNT' 			,text:'보유대수</br>&nbsp;&nbsp;(대/노선/월)'			,type : 'uniQty'},
			{name: 'OPERATION_BUS_COUNT' 	,text:'가동대수</br>&nbsp;&nbsp;(대/노선/월)'			,type : 'uniQty'},
			{name: 'OPERATION_DISTANCE' 	,text:'운행거리</br>&nbsp;&nbsp;(KM/노선/월)'		,type : 'uniPrice'},
			{name: 'REMARK' 				,text:'비고'							,type : 'uniPrice'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'grd200ukrvService.selectList',
			update: 'grd200ukrvService.updateDetail',
			create: 'grd200ukrvService.insertDetail',
			destroy: 'grd200ukrvService.deleteDetail',
			syncAll: 'grd200ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function(config)	{	

            	var paramMaster= panelSearch.getValues();
				var inValidRecs = this.getInvalidRecords();
				
					if(inValidRecs.length == 0 )	{
					config = {
							params: [paramMaster]
					};
					
					this.syncAllDirect(config);					
            }else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
			groupField: ''
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '운행현황',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
        width: 330,
		items: [{	
			title: '검색조건', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',  
           	defaults:{
           		labelWidth:80
           	},
	    	items:[{
				fieldLabel: '기준년도',
				name: 'BASE_YEAR',
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
				width:185,
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASE_YEAR', newValue);
					}
				}
			}]				
		}]
		
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '기준년도',
			name: 'BASE_YEAR',
			xtype: 'uniYearField',
			value: new Date().getFullYear(),
			width:185,
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BASE_YEAR', newValue);
				}
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
						//this.mask();
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
  					//this.unmask();
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
  		},
  		setLoadRecord: function(record)	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
     var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
        layout : 'fit',        
    	region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        tbar: [{
        	itemId : 'ref1', iconCls : 'icon-referance'	,
    		text:'전년도참조하기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		 },
   		 {
        	itemId : 'ref2', iconCls : 'icon-referance'	,
    		text:'데이터가져오기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		 }],
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore, 
		columns:[
			{xtype: 'rownumberer', /* dataIndex:'SEQ', */ 			width: 40, text:'연번',sortable: false},
			{dataIndex:'COMP_CODE'        		,width: 80 ,hidden:true},
		//	{dataIndex:'SERVICE_YEAR'     		,width: 80 ,hidden:true},
			{dataIndex:'ROUTE_NUM'        		,width: 80 },
			{dataIndex:'ROUTE_ID'         		,width: 80 },
			{dataIndex:'OPERATION_TYPE'   		,width: 120 },
			{dataIndex:'ROUTE_TYPE'       		,width: 100 },
			{dataIndex:'OPERATION_MONTH'       	,width: 80, summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
			{dataIndex:'DATE_COUNT'            	,width: 80,summaryType: 'sum' },
			{ 
	         	text:'운행현황',
	         		columns: [
			         	{dataIndex:'OWN_BUS'        	  	,width: 120,summaryType: 'sum' },
			         	{dataIndex:'OPERATION_BUS'  	  	,width: 120,summaryType: 'sum' },
			         	{dataIndex:'BACKUP_BUS'    		  	,width: 120,summaryType: 'sum' },
			         	{dataIndex:'APPROV_DISTANCE'	  	,width: 130,summaryType: 'sum' },
			         	{dataIndex:'RUN_CNT_AVG'    	  	,width: 200,summaryType: 'sum' },
			         	{dataIndex:'EMPTY_DISTANCE' 	  	,width: 130,summaryType: 'sum' },
			         	{dataIndex:'OWN_BUS_COUNT' 		  	,width: 130,summaryType: 'sum' },
			         	{dataIndex:'OPERATION_BUS_COUNT'  	,width: 130,summaryType: 'sum' },
			         	{dataIndex:'OPERATION_DISTANCE'   	,width: 135,summaryType: 'sum' },
			         	{dataIndex:'REMARK' 			  	,width: 80 }
		         	]
			}] 
   });
	
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
		id  : 'grc100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print','newData'],false);
			UniAppManager.setToolbarButtons(['reset',  'excel', 'prev', 'next' ],true);
			panelSearch.setValue('BASE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('BASE_YEAR', new Date().getFullYear() -1);
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['newData'],true);
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
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
					masterGrid.deleteSelectedRow();
				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
			this.fnInitBinding();
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			//보류
				case "" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}
					record.set('OPERATION_SUM',newValue + record.get('OPERATION_CNG_GEN') + record.get('OPERATION_CNG_LOW'));
					record.set('OWN_GAN_GEN', newValue + record.get('BACKUP_GAS_GEN'));
					record.set('OWN_SUM', newValue + record.get('BACKUP_GAS_GEN') + record.get('OWN_CNG_GEN') + record.get('OWN_CNG_LOW'));
			break;
						
			}
				return rv;
						}
			});
	
	
}; // main
  
</script>