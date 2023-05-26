<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노선별차량현황 
request.setAttribute("PKGNAME","Unilite_app_grc100ukrv");
%>
<t:appConfig pgmId="grc100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="GO10"/>					<!-- 운행구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO11"/>					<!-- 노선구분 	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	
	    fields: [
	   // 	{name: 'SEQ'            				,text:'seq'			,type : 'int'}, 
			{name: 'COMP_CODE'            			,text:'법인코드'		,type : 'string'}, 
		//	{name: 'SERVICE_YEAR'         			,text:'기준년도'		,type : 'uniDate'},
			{name: 'ROUTE_NUM'            			,text:'노선번호</br>&nbsp;&nbsp;(B+NM)'	,type : 'string',allowBlank:false},
			{name: 'ROUTE_ID'             			,text:'노선번호</br>&nbsp;&nbsp;(ID)'		,type : 'string',allowBlank:false},
			{name: 'OPERATION_TYPE'       			,text:'유형구분'		,type : 'string',comboType:'AU', comboCode:'GO10',allowBlank:false},
			{name: 'ROUTE_TYPE'           			,text:'노선구분'		,type : 'string',comboType:'AU', comboCode:'GO11',allowBlank:false},
			{name: 'OWN_SUM'              			,text:'소계'			,type : 'uniQty',editable: false},
			{name: 'OWN_GAN_GEN'          			,text:'경유일반'		,type : 'uniQty',editable: false},
			{name: 'OWN_CNG_GEN'          			,text:'CNG일반'		,type : 'uniQty',editable: false},
			{name: 'OWN_CNG_LOW'          			,text:'CNG저상'		,type : 'uniQty',editable: false},
			{name: 'OPERATION_SUM'        			,text:'소계'			,type : 'uniQty',editable: false},
			{name: 'OPERATION_GAS_GEN'    			,text:'경유일반'		,type : 'uniQty'},
			{name: 'OPERATION_CNG_GEN'    			,text:'CNG일반'		,type : 'uniQty'},
			{name: 'OPERATION_CNG_LOW'    			,text:'CNG저상'		,type : 'uniQty'},
			{name: 'BACKUP_SUM'           			,text:'소계'			,type : 'uniQty',editable: false},
			{name: 'BACKUP_GAS_GEN'       			,text:'경유일반'		,type : 'uniQty'},
			{name: 'BACKUP_CNG_GEN'       			,text:'CNG일반'		,type : 'uniQty'},
			{name: 'BACKUP_CNG_LOW'       			,text:'CNG저상'		,type : 'uniQty'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'grc100ukrvService.selectList',
			update: 'grc100ukrvService.updateDetail',
			create: 'grc100ukrvService.insertDetail',
			destroy: 'grc100ukrvService.deleteDetail',
			syncAll: 'grc100ukrvService.saveAll'
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
		title: '노선별 차량현황',
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
				value: new Date().getFullYear(),
				width:185,
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
			value: new Date().getFullYear(),
			width:185,
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
	
//	var detailForm = Unilite.createSearchForm('detailForm',{	
//		autoScroll: true,
//		region: 'center',
//		border: 1,
//		padding: '1 1 1 1',  
//		tbar: [{
//        	xtype: 'uniBaseButton',
//    		iconCls: 'icon-excel',
//    		width: 26, height: 26,
//    		tooltip: '엑셀 다운로드',
//    		handler: function() {
//    			window.open(CPATH+'/busevaluation/excel/grc100out?SERVICE_YEAR='+panelSearch.getValue('SERVICE_YEAR'), "_self");
//    		}
//       }]
//	});

	
     var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
        layout : 'fit',        
    	region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
			excel: {
				useExcel: false,			//엑셀 다운로드 사용 여부
				exportGroup : false		//group 상태로 export 여부
			}
        },
		tbar: [{
        	xtype: 'uniBaseButton',
    		iconCls: 'icon-excel',
    		width: 26, 
    		height: 26,
    		tooltip: '엑셀 다운로드',
    		handler: function() { 
    			window.open(CPATH+'/busevaluation/excel/grc100out?SERVICE_YEAR='+panelSearch.getValue('SERVICE_YEAR'), "_self");
    		}
        }, '->',{
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
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore, 
		columns:[
			{xtype: 'rownumberer', /* dataIndex:'SEQ', */ 			width: 40, text:'연번',sortable: false},
			{dataIndex:'COMP_CODE'        		,width: 80 ,hidden:true},
		//	{dataIndex:'SERVICE_YEAR'     		,width: 80 ,hidden:true},
			{dataIndex:'ROUTE_NUM'        		,width: 80 },
			{dataIndex:'ROUTE_ID'         		,width: 80 },
			{dataIndex:'OPERATION_TYPE'   		,width: 130 },
			{dataIndex:'ROUTE_TYPE'       		,width: 120, summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '합계', '계');
                }
            },
			
			{ 
	         	text:'보유대수',
	         		columns: [
			         	{dataIndex:'OWN_SUM'          		,width: 80,summaryType: 'sum' },
						{dataIndex:'OWN_GAN_GEN'      		,width: 80,summaryType: 'sum' },
						{dataIndex:'OWN_CNG_GEN'      		,width: 80,summaryType: 'sum' },
						{dataIndex:'OWN_CNG_LOW'      		,width: 80,summaryType: 'sum' }
		         	]
			},{ 
	         	text:'가동대수',
	         		columns: [
			         	{dataIndex:'OPERATION_SUM'    		,width: 80,summaryType: 'sum' },
						{dataIndex:'OPERATION_GAS_GEN'		,width: 80,summaryType: 'sum' },
						{dataIndex:'OPERATION_CNG_GEN'		,width: 80,summaryType: 'sum' },
						{dataIndex:'OPERATION_CNG_LOW'		,width: 80,summaryType: 'sum' }
		         	]
			},{ 
	         	text:'예비차량',
	         		columns: [
			         	{dataIndex:'BACKUP_SUM'       		,width: 80,summaryType: 'sum' },
						{dataIndex:'BACKUP_GAS_GEN'   		,width: 80,summaryType: 'sum' },
						{dataIndex:'BACKUP_CNG_GEN'   		,width: 80,summaryType: 'sum' },
						{dataIndex:'BACKUP_CNG_LOW'   		,width: 80,summaryType: 'sum' }
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
		}/*,
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}*/
	});
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			//가동대수	
				case "OPERATION_GAS_GEN" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}
					record.set('OPERATION_SUM',newValue + record.get('OPERATION_CNG_GEN') + record.get('OPERATION_CNG_LOW'));
					record.set('OWN_GAN_GEN', newValue + record.get('BACKUP_GAS_GEN'));
					record.set('OWN_SUM', newValue + record.get('BACKUP_GAS_GEN') + record.get('OWN_CNG_GEN') + record.get('OWN_CNG_LOW'));
			break;
				case "OPERATION_CNG_GEN" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}
					record.set('OPERATION_SUM',newValue + record.get('OPERATION_GAS_GEN') + record.get('OPERATION_CNG_LOW'));
					record.set('OWN_CNG_GEN', newValue + record.get('BACKUP_CNG_GEN'));
					record.set('OWN_SUM', newValue + record.get('BACKUP_CNG_GEN') + record.get('OWN_GAN_GEN') + record.get('OWN_CNG_LOW'));
			break;		
				case "OPERATION_CNG_LOW" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}
					record.set('OPERATION_SUM',newValue + record.get('OPERATION_CNG_GEN') + record.get('OPERATION_GAS_GEN'));
					record.set('OWN_CNG_LOW', newValue + record.get('BACKUP_CNG_LOW'));
					record.set('OWN_SUM', newValue + record.get('BACKUP_CNG_LOW') + record.get('OWN_GAN_GEN') + record.get('OWN_CNG_GEN'));
			break;	
			
			//예비차량
				case "BACKUP_GAS_GEN" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
				break;
				}
					record.set('BACKUP_SUM',newValue + record.get('BACKUP_CNG_GEN') + record.get('BACKUP_CNG_LOW'));
					record.set('OWN_GAN_GEN', newValue + record.get('OPERATION_GAS_GEN'));
					record.set('OWN_SUM', newValue + record.get('OPERATION_GAS_GEN') + record.get('OWN_CNG_GEN') + record.get('OWN_CNG_LOW'));
			break;
				case "BACKUP_CNG_GEN" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}
					record.set('BACKUP_SUM',newValue + record.get('BACKUP_GAS_GEN') + record.get('BACKUP_CNG_LOW'));
					record.set('OWN_CNG_GEN', newValue + record.get('OPERATION_CNG_GEN'));
					record.set('OWN_SUM', newValue + record.get('OPERATION_CNG_GEN') + record.get('OWN_GAN_GEN') + record.get('OWN_CNG_LOW'));
			break;		
				case "BACKUP_CNG_LOW" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}
					record.set('BACKUP_SUM',newValue + record.get('BACKUP_CNG_GEN') + record.get('BACKUP_GAS_GEN'));
					record.set('OWN_CNG_LOW', newValue + record.get('OPERATION_CNG_LOW'));
					record.set('OWN_SUM', newValue + record.get('OPERATION_CNG_LOW') + record.get('OWN_GAN_GEN') + record.get('OWN_CNG_GEN'));
			break;	
						
			}
				return rv;
						}
			});
	
	
}; // main
  
</script>