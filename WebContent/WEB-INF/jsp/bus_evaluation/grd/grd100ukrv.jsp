<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노선현황 
request.setAttribute("PKGNAME","Unilite_app_grd100ukrv");
%>
<t:appConfig pgmId="grd100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="GO10"/>					<!-- 운행구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO11"/>					<!-- 노선구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO12"/>					<!-- 시계	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {

	    fields: [
			{name: 'COMP_CODE'            			,text:'법인코드'				,type : 'string'}, 
//			{name: 'SERVICE_YEAR'         			,text:'기준년도'		,type : 'uniDate'},
			{name: 'ROUTE_NUM'            			,text:'노선번호</br>&nbsp;&nbsp;(B+NM)'	,type : 'string',allowBlank:false},
			{name: 'ROUTE_ID'             			,text:'노선번호</br>&nbsp;&nbsp;(ID)'		,type : 'string',allowBlank:false},
			{name: 'OPERATION_TYPE'       			,text:'유형구분'				,type : 'string',comboType:'AU', comboCode:'GO10',allowBlank:false},
			{name: 'ROUTE_TYPE'           			,text:'노선구분'				,type : 'string',comboType:'AU', comboCode:'GO11',allowBlank:false},
			{name: 'APPROV_DISTANCE'    			,text:'노선거리</br>&nbsp;&nbsp;(편도,KM)'	,type : 'string'},
			{name: 'BOUNDARY_TYPE'      			,text:'시계'					,type : 'string',comboType:'AU', comboCode:'GO12'},
			{name: 'START_STOP'         			,text:'기점'					,type : 'string'},
			{name: 'MID_STOP'           			,text:'주요경유지'				,type : 'string'},
			{name: 'LAST_STOP'          			,text:'종점'					,type : 'string'},
			{name: 'RUN_CNT_MIN'        			,text:'최소</br>&nbsp;&nbsp;(회)'			,type : 'uniQty'},
			{name: 'RUN_CNT_MAX'        			,text:'최대</br>&nbsp;&nbsp;(회)'			,type : 'uniQty'},
			{name: 'RUN_TERM_MIN'       			,text:'최소</br>&nbsp;&nbsp;(mm)'			,type : 'uniQty'},
			{name: 'RUN_TERM_MAX'       			,text:'최대</br>&nbsp;&nbsp;(mm)'			,type : 'uniQty'},
			{name: 'RUN_START_TIME'     			,text:'첫차</br>&nbsp;&nbsp;(hh:mm)'		,type : 'string'},
			{name: 'RUN_LAST_TIME'      			,text:'막차</br>&nbsp;&nbsp;(hh:mm)'		,type : 'string'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'grd100ukrvService.selectList',
			update: 'grd100ukrvService.updateDetail',
			create: 'grd100ukrvService.insertDetail',
			destroy: 'grd100ukrvService.deleteDetail',
			syncAll: 'grd100ukrvService.saveAll'
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
		title: '노선현황',
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
    	store: masterStore, 
		columns:[
			{xtype: 'rownumberer', /* dataIndex:'SEQ', */ 			width: 40, text:'연번',sortable: false},
			{dataIndex:'COMP_CODE'        		,width: 80 ,hidden:true},
		//	{dataIndex:'SERVICE_YEAR'     		,width: 80 ,hidden:true},
			{dataIndex:'ROUTE_NUM'        		,width: 80 },
			{dataIndex:'ROUTE_ID'         		,width: 80 },
			{dataIndex:'OPERATION_TYPE'   		,width: 130 },
			{dataIndex:'ROUTE_TYPE'       		,width: 120 },
			{dataIndex:'APPROV_DISTANCE'       	,width: 80 },
			{ 
	         	text:'운행구간',
	         		columns: [
			         	{dataIndex:'BOUNDARY_TYPE'  	,width: 80 },
						{dataIndex:'START_STOP'     	,width: 80 },
						{dataIndex:'MID_STOP'       	,width: 80 },
						{dataIndex:'LAST_STOP'      	,width: 80 }
		         	]
			},{ 
	         	text:'운행횟수',
	         		columns: [
			         	{dataIndex:'RUN_CNT_MIN'      	,width: 80 },
						{dataIndex:'RUN_CNT_MAX' 		,width: 80 }
		         	]
			},{ 
	         	text:'운행간격',
	         		columns: [
			         	{dataIndex:'RUN_TERM_MIN'      	,width: 80 },
						{dataIndex:'RUN_TERM_MAX'    	,width: 80 }
		         	]
			},{ 
	         	text:'운행시간',
	         		columns: [
			         	{dataIndex:'RUN_START_TIME'    	,width: 80 },
						{dataIndex:'RUN_LAST_TIME'    	,width: 80 }
		         	]
			}],
			listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){ //신규아닐때
			 		if (UniUtils.indexOf(e.field,['ROUTE_NUM']))   
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

	
	
}; // main
  
</script>