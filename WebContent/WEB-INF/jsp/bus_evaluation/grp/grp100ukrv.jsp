<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//운행현황 
request.setAttribute("PKGNAME","Unilite_app_grp100ukrv");
%>
<t:appConfig pgmId="grp100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="GO10"/>					<!-- 운행구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO11"/>					<!-- 노선구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO12"/>					<!-- 시계	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {

		fields: [
			{name: 'COMP_CODE'      		,text:'법인코드'			,type : 'string'}, 
//			{name: 'SERVICE_YEAR'   		,text:'기준년도'			,type : 'string'},
			{name: 'ROUTE_NUM'      		,text:'노선번호</br>&nbsp;&nbsp;(B+NM)'				,type : 'string', allowBlank: false},
			{name: 'ROUTE_ID'       		,text:'노선번호</br>&nbsp;&nbsp;(ID)'				,type : 'string', allowBlank: false},
			{name: 'OPERATION_TYPE' 		,text:'유형구분'			,type : 'string',comboType:'AU', comboCode:'GO10', allowBlank: false},
			{name: 'ROUTE_TYPE'     		,text:'노선구분'			,type : 'string',comboType:'AU', comboCode:'GO11', allowBlank: false},
			{name: 'ROUTE_DATE'				,text:'발생일자'			,type : 'uniDate' },
			{name: 'PROPERTY_TRANS_TYPE'     ,text:'형식'				,type : 'string'/*,comboType:'AU', comboCode:'XXXX' 콤보코드필요*/},
			{name: 'PROPERTY_TRANS_COMP'     ,text:'이전업체'			,type : 'string'},
			{name: 'APPROV_DISTANCE_BEFORE'  ,text:'당초'				,type : 'uniQty'},
			{name: 'APPROV_DISTANCE_AFTER'   ,text:'변경'				,type : 'uniQty'},
			{name: 'START_STOP'        		,text:'기점'				,type : 'string'},
			{name: 'MID_STOP'  				,text:'주요경유지'			,type : 'string'},
			{name: 'LAST_STOP'    			,text:'종점'				,type : 'string'},
			{name: 'RUN_CNT_MAX_BEFORE'		,text:'당초최소'			,type : 'uniQty'},
			{name: 'RUN_CNT_MIN_BEFORE'    	,text:'당초최대'			,type : 'uniQty'},
			{name: 'RUN_CNT_MAX_AFTER' 		,text:'변경최소'			,type : 'uniQty'},
			{name: 'RUN_CNT_MIN_AFTER' 		,text:'변경최대'			,type : 'uniQty'}

		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'grp100ukrvService.selectList',
			update: 'grp100ukrvService.updateDetail',
			create: 'grp100ukrvService.insertDetail',
			destroy: 'grp100ukrvService.deleteDetail',
			syncAll: 'grp100ukrvService.saveAll'
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
			}			
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '노선및 운행변동사항',
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
				name: 'SERVICE_YEAR',
				xtype: 'uniYearField',
				width: 185,
				value: new Date().getFullYear(),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SERVICE_YEAR', newValue);
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
			name: 'SERVICE_YEAR',
			xtype: 'uniYearField',
			width: 185,
			value: new Date().getFullYear(),
			allowBlank: false,
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SERVICE_YEAR', newValue);
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
    	tbar: [ '->',{
        	itemId : 'ref1', iconCls : 'icon-referance'	,
    		text:'전년도 데이터 복사하기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		}, {
        	itemId : 'ref2', iconCls : 'icon-referance'	,
    		text:'기준년도 데이터 가져오기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		 }],
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore, 
		columns:[
			{xtype: 'rownumberer',			     width: 40, text:'연번',sortable: false},
			{dataIndex:'COMP_CODE'        		,width: 80 ,hidden:true},
//			{dataIndex:'SERVICE_YEAR'     		,width: 80 ,hidden:true},
			{dataIndex:'ROUTE_NUM'        		,width: 120 , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
			{dataIndex:'ROUTE_ID'         		,width: 80 },
			{dataIndex:'OPERATION_TYPE'   		,width: 120 },
			{dataIndex:'ROUTE_TYPE'       		,width: 100 },
			{dataIndex:'ROUTE_DATE'       		,width: 120 },
			{ 
	         	text:'소유권(현식/소유권이전업체)',
	         		columns: [
			         	{dataIndex:'PROPERTY_TRANS_TYPE'        	,width: 120},
			         	{dataIndex:'PROPERTY_TRANS_COMP'  	  		,width: 120}
		         	]
			},{ 
	         	text:'노선거리',
	         		columns: [
			         	{dataIndex:'APPROV_DISTANCE_BEFORE'        	,width: 120},
			         	{dataIndex:'APPROV_DISTANCE_AFTER'  	  	,width: 120}
		         	]
			},{ 
	         	text:'운행구간(기점-경유지-종점)',
	         		columns: [
			         	{dataIndex:'START_STOP'        				,width: 120},
			         	{dataIndex:'MID_STOP'  	  					,width: 120},
			         	{dataIndex:'LAST_STOP'  	  				,width: 120}
		         	]
			},{ 
	         	text:'운행횟수(당초, 변경)',
	         		columns: [
			         	{dataIndex:'RUN_CNT_MAX_BEFORE'        				,width: 80,summaryType: 'sum' },
			         	{dataIndex:'RUN_CNT_MIN_BEFORE'  	  				,width: 80,summaryType: 'sum' },
			         	{dataIndex:'RUN_CNT_MAX_AFTER'  	  				,width: 80,summaryType: 'sum' },
			         	{dataIndex:'RUN_CNT_MIN_AFTER'  	  				,width: 80,summaryType: 'sum' }
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
		id  : 'grp100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print','newData'],false);
			UniAppManager.setToolbarButtons(['reset',  'excel', 'prev', 'next' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
		},
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
			
			UniAppManager.setToolbarButtons(['newData'],true);
		},
		
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
					masterGrid.deleteSelectedRow();
				
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
			this.fnInitBinding();
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});

	
	
}; // main
  
</script>