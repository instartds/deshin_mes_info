<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//운행현황 
request.setAttribute("PKGNAME","Unilite_app_gri400ukrv");
%>
<t:appConfig pgmId="gri400ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="GO10"/>					<!-- 운행구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO11"/>					<!-- 노선구분 	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
		
		fields: [{name: 'SERVICE_YEAR'         		,text:'기준년도'							,type : 'string', allowBlank: false},
				 {name: 'ROUTE_NUM'            		,text:'노선번호</br>&nbsp;&nbsp;(B+NM)'				,type : 'string', allowBlank: false},
				 {name: 'ROUTE_ID'             		,text:'노선번호ID'							,type : 'string', allowBlank: false},
				 {name: 'OPERATION_TYPE'       		,text:'유형구분'							,type : 'string',comboType:'AU', comboCode:'GO10', allowBlank: false},
				 {name: 'ROUTE_TYPE'           		,text:'노선구분'							,type : 'string',comboType:'AU', comboCode:'GO11', allowBlank: false},				 
				 {name: 'TOT_RUN'       			,text:'운행거리(KM)'						,type : 'uniPrice'},/*전체운행거리*/				 
				 {name: 'GAS_MEDIUM_RUN'       		,text:'운행거리(KM)'						,type : 'uniPrice'},
				 {name: 'GAS_MEDIUM_USE'       		,text:'연료사용(L)'						,type : 'uniPrice'},
				 {name: 'GAS_MEDIUM_AMT'       		,text:'연료구입비(원)'						,type : 'uniPrice'},
				 {name: 'GAS_MEDIUM_MILE'      		,text:'연비(KM/L)'						,type : 'uniPrice'},
				 {name: 'GAS_LARGE_RUN'        		,text:'운행거리(KM)'						,type : 'uniPrice'},
				 {name: 'GAS_LARGE_USE'        		,text:'연료사용(L)'						,type : 'uniPrice'},
				 {name: 'GAS_LARGE_AMT'        		,text:'연료구입비(원)'						,type : 'uniPrice'},
				 {name: 'GAS_LARGE_MILE'       		,text:'연비(KM/L)'						,type : 'uniPrice'},
				 {name: 'CNG_MEDIUM_RUN'       		,text:'운행거리(KM)'						,type : 'uniPrice'},
				 {name: 'CNG_MEDIUM_USE'       		,text:'연료사용(L)'						,type : 'uniPrice'},
				 {name: 'CNG_MEDIUM_AMT'       		,text:'연료구입비(원)'						,type : 'uniPrice'},
				 {name: 'CNG_MEDIUM_MILE'      		,text:'연비(KM/L)'						,type : 'uniPrice'},
				 {name: 'CNG_LARGE_RUN'        		,text:'운행거리(KM)'						,type : 'uniPrice'},
				 {name: 'CNG_LARGE_USE'        		,text:'연료사용(L)'						,type : 'uniPrice'},
				 {name: 'CNG_LARGE_AMT'        		,text:'연료구입비(원)'						,type : 'uniPrice'},
				 {name: 'CNG_LARGE_MILE'       		,text:'연비(KM/L)'						,type : 'uniPrice'},
				 {name: 'CNG_LOW_RUN'          		,text:'운행거리(KM)'						,type : 'uniPrice'},
				 {name: 'CNG_LOW_USE'          		,text:'연료사용(L)'						,type : 'uniPrice'},
				 {name: 'CNG_LOW_AMT'          		,text:'연료구입비(원)'						,type : 'uniPrice'},
				 {name: 'CNG_LOW_MILE'         		,text:'연비(KM/L)'						,type : 'uniPrice'},
				 {name: 'UPDATE_DB_USER'       		,text:'UPDATE_DB_USER'					,type : 'string'},
				 {name: 'UPDATE_DB_TIME'       		,text:'UPDATE_DB_TIME'					,type : 'string'},
				 {name: 'COMP_CODE'       			,text:'COMP_CODE'						,type : 'string', defaultValue: UserInfo.compCode}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gri400ukrvService.selectList',
			update: 'gri400ukrvService.updateDetail',
			create: 'gri400ukrvService.insertDetail',
			destroy: 'gri400ukrvService.deleteDetail',
			syncAll: 'gri400ukrvService.saveAll'
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
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					config = {
						success: function(batch, option) {			////운행거리 합계처리 및 validation()부터;				

						 } 
					};
					this.syncAllDirect(config);					
				}else {					
                	masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
		title: '연료비',
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
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore, 
		columns:[ {xtype: 'rownumberer', /* dataIndex:'SEQ', */width: 40, text:'연번',sortable: false},
				  {dataIndex:'SERVICE_YEAR'         		,    	  	width: 100, hidden: true },
     			  {dataIndex:'ROUTE_NUM'            		,    	  	width: 100 },
     			  {dataIndex:'ROUTE_ID'             		,    	  	width: 100 },
     			  {dataIndex:'OPERATION_TYPE'       		,    	  	width: 130 },
     			  {dataIndex:'ROUTE_TYPE'           		,    	  	width: 100 },
     			  {text: '전체',
     			  	columns: [
     			  		  {dataIndex:'TOT_RUN'       				,    	  	width: 100 }	
     			  	]
     			  },
     			  {text: '경유중형',
     			  	columns: [
     			  		  {dataIndex:'GAS_MEDIUM_RUN'       		,    	  	width: 100 },
		     			  {dataIndex:'GAS_MEDIUM_USE'       		,    	  	width: 100 },
		     			  {dataIndex:'GAS_MEDIUM_AMT'       		,    	  	width: 100 },
		     			  {dataIndex:'GAS_MEDIUM_MILE'      		,    	  	width: 100 }
     			  	]
     			  },
     			  {text: '경유대형',
     			  	columns: [
     			  		  {dataIndex:'GAS_LARGE_RUN'        		,    	  	width: 100 },
		     			  {dataIndex:'GAS_LARGE_USE'        		,    	  	width: 100 },
		     			  {dataIndex:'GAS_LARGE_AMT'        		,    	  	width: 100 },
		     			  {dataIndex:'GAS_LARGE_MILE'       		,    	  	width: 100 }
     			  	]
     			  },
     			  {text: 'CNG중형',
     			  	columns: [
     			  		  {dataIndex:'CNG_MEDIUM_RUN'       		,    	  	width: 100 },
		     			  {dataIndex:'CNG_MEDIUM_USE'       		,    	  	width: 100 },
		     			  {dataIndex:'CNG_MEDIUM_AMT'       		,    	  	width: 100 },
		     			  {dataIndex:'CNG_MEDIUM_MILE'      		,    	  	width: 100 }
     			  	]
     			  },
     			  {text: 'CNG대형',
     			  	columns: [
     			  		  {dataIndex:'CNG_LARGE_RUN'        		,    	  	width: 100 },
		     			  {dataIndex:'CNG_LARGE_USE'        		,    	  	width: 100 },
		     			  {dataIndex:'CNG_LARGE_AMT'        		,    	  	width: 100 },
		     			  {dataIndex:'CNG_LARGE_MILE'       		,    	  	width: 100 }
     			  	]
     			  },
     			  {text: 'CNG저상',
     			  	columns: [
     			  		  {dataIndex:'CNG_LOW_RUN'          		,    	  	width: 100 },
		     			  {dataIndex:'CNG_LOW_USE'          		,    	  	width: 100 },
		     			  {dataIndex:'CNG_LOW_AMT'          		,    	  	width: 100 },
		     			  {dataIndex:'CNG_LOW_MILE'         		,    	  	width: 100 }
     			  	]
     			  },     			 
     			  {dataIndex:'UPDATE_DB_USER'       		,    	  	width: 100, hidden: true },
     			  {dataIndex:'UPDATE_DB_TIME'       		,    	  	width: 100, hidden: true }],
     			  
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field == 'TOT_RUN') return false;	
				if(!e.record.phantom){	//신규아닐때
					if (UniUtils.indexOf(e.field, 
						[ 'ROUTE_NUM'     
   					])) 		
						return false; 
				}
			}
		}
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
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print', 'newData'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
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
			var serviceYear = panelSearch.getValue('SERVICE_YEAR');
            	 
        	var r = {
				SERVICE_YEAR: serviceYear 
	        };		        
			masterGrid.createRow(r);
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
			panelSearch.clearForm();
			panelSearch.clearForm();
			masterGrid.reset();
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});

	
	
}; // main
  
</script>