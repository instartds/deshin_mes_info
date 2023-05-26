<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노선별차량현황 
request.setAttribute("PKGNAME","Unilite_app_grc200ukrv");
%>
<t:appConfig pgmId="grc200ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="GO10"/>					<!-- 운행구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO11"/>					<!-- 노선구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO06"/>					<!-- 차종	--> 
<t:ExtComboStore comboType="AU" comboCode="GO07"/>					<!-- 제작사--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
  
	    fields: [
			{name: 'COMP_CODE'                			,text:'법인코드'		,type : 'string'}, 
		//	{name: 'SERVICE_YEAR'             			,text:'기준년도'		,type : 'uniDate'},
			{name: 'ROUTE_NUM'                			,text:'노선번호</br>&nbsp;&nbsp;(B+NM)'	,type : 'string',allowBlank:false},
			{name: 'ROUTE_ID'                 			,text:'노선번호</br>&nbsp;&nbsp;(ID)'		,type : 'string',allowBlank:false},
			{name: 'OPERATION_TYPE'           			,text:'유형구분'		,type : 'string',comboType:'AU', comboCode:'GO10',allowBlank:false},
			{name: 'ROUTE_TYPE'               			,text:'노선구분'		,type : 'string',comboType:'AU', comboCode:'GO11',allowBlank:false},
			{name: 'VEHICLE_TYPE'             			,text:'차량형식'		,type : 'string',comboType:'AU', comboCode:'GO06'},
			{name: 'VEHICLE_MAKE'             			,text:'제조업체'		,type : 'string',comboType:'AU', comboCode:'GO07'},
			{name: 'VEHICLE_PURCHASE_DATE'    			,text:'취득일자'		,type : 'uniDate'},
			{name: 'VEHICLE_REGIST_NO'        			,text:'차량번호'		,type : 'string', allowBlank: false},
			{name: 'VEHICLE_PURCHASE_AMT'     			,text:'구입가격'		,type : 'uniPrice'},
			{name: 'VEHICLE_SUBSIDY_AMT'      			,text:'차량보조금'		,type : 'uniPrice'},
			{name: 'VEHICLE_EXPENSES_AMT'     			,text:'부대비용'		,type : 'uniPrice'},
			{name: 'GAIN_AMT'     						,text:'취득가격'		,type : 'uniPrice',editable:false}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'grc200ukrvService.selectList',
			update: 'grc200ukrvService.updateDetail',
			create: 'grc200ukrvService.insertDetail',
			destroy: 'grc200ukrvService.deleteDetail',
			syncAll: 'grc200ukrvService.saveAll'
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
			},
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '차량별 상세내역',
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
			{xtype: 'rownumberer', /* dataIndex:'SEQ', */width: 40, text:'연번',sortable: false},
			{dataIndex:'COMP_CODE'                		,width: 80 ,hidden:true},
		//	{dataIndex:'SERVICE_YEAR'             		,width: 80 ,hidden:true},
			{dataIndex:'ROUTE_NUM'                		,width: 80 },
			{dataIndex:'ROUTE_ID'                 		,width: 80 },
			{dataIndex:'OPERATION_TYPE'           		,width: 130 },
			{dataIndex:'ROUTE_TYPE'               		,width: 120 },
			{dataIndex:'VEHICLE_TYPE'           		,width: 80 },
			{dataIndex:'VEHICLE_MAKE'           		,width: 80 },
			{dataIndex:'VEHICLE_PURCHASE_DATE'  		,width: 80 },
			{dataIndex:'VEHICLE_REGIST_NO'      		,width: 80 },
			{dataIndex:'VEHICLE_PURCHASE_AMT'   		,width: 80 },
			{dataIndex:'VEHICLE_SUBSIDY_AMT'    		,width: 80 },
			{dataIndex:'VEHICLE_EXPENSES_AMT'   		,width: 80 },
			{dataIndex:'GAIN_AMT'     					,width: 80 }
		],
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
			UniAppManager.setToolbarButtons(['reset','excel', 'prev', 'next' ],true);
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
			//구입가격
				
				case "VEHICLE_PURCHASE_AMT" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}
					record.set('GAIN_AMT',newValue - record.get('VEHICLE_SUBSIDY_AMT') + record.get('VEHICLE_EXPENSES_AMT'));
				break;
			//차량 보조금
				case "VEHICLE_SUBSIDY_AMT" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}
					record.set('GAIN_AMT',-newValue + record.get('VEHICLE_PURCHASE_AMT') + record.get('VEHICLE_EXPENSES_AMT'));
				break;
				
			//부대비용
				case "VEHICLE_EXPENSES_AMT" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}
					record.set('GAIN_AMT',newValue + record.get('VEHICLE_PURCHASE_AMT') - record.get('VEHICLE_SUBSIDY_AMT'));
				break;
			}
				return rv;
						}
			});
	
	
}; // main
  
</script>