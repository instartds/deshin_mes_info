<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//운영자 공통코드 등록
request.setAttribute("PKGNAME","Unilite_app_bsa031ukrv");
%>
<t:appConfig pgmId="bsa031ukrv1" >
	<t:ExtComboStore comboType="AU" comboCode="B902" />
	<t:ExtComboStore comboType="AU" comboCode="B904" />
</t:appConfig>
<script type="text/javascript">
	
function appMain() {

		Unilite.defineModel('${PKGNAME}MasterModel', {
			fields : [ {name : 'SYSTEM',		text : '시스템구분',		type : 'string',	allowBlank:false, comboType : 'AU', comboCode : 'B902'}
					 , {name : 'MODULE',		text : '모듈',				type : 'string',	allowBlank:false, comboType : 'AU', comboCode : 'B904'}
					 , {name : 'NAME',			text : '코드',				type : 'string',    allowBlank:false	  }	
					 , {name : 'CODE',			text : '키',				type : 'string',    allowBlank:false, editable:false}					 				 
					 , {name : 'CODE_NAME',		text : '코드명(한국어)',	type : 'string'  }
					 , {name : 'CODE_NAME_EN',	text : '코드명(영어)',		type : 'string'	 }
					 , {name : 'CODE_NAME_CN',	text : '코드명(중국어)',	type : 'string'  }
					 , {name : 'CODE_NAME_JP',	text : '코드명(일본어)',	type : 'string'  }
					 , {name : 'TYPE',			text : '시스템구분',		type : 'string',	defaultValue:'MESSAGE'}
					
					]
		});
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read : 	 'bsa030ukrvService.selectList',
				create : 'bsa030ukrvService.insert',
				update : 'bsa030ukrvService.update',
				destroy: 'bsa030ukrvService.delete',
				syncAll: 'bsa030ukrvService.saveAll'
			}
		});
		
		var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore', { 
			model : '${PKGNAME}MasterModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : directProxy,
			loadStoreRecords : function()	{
				var param= Ext.getCmp('bsa031ukrvSearchForm').getValues();	
				this.load({
					params : param
				});
			},
			saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						this.syncAllDirect();			
					}else {
						var grid = Ext.getCmp('${PKGNAME}Grid');
						grid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				
			}
		});
		
		

		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
			region : 'center',
			uniOpt:{expandLastColumn:false},
			store: directMasterStore,
	        itemId:'${PKGNAME}Grid',
			columns : [   {dataIndex : 'SYSTEM',			width : 100		}
						, {dataIndex : 'MODULE',			width : 100		}
						, {dataIndex : 'NAME',				width : 110		}
						, {dataIndex : 'CODE',				width : 150		}						
						, {dataIndex : 'CODE_NAME',			flex : .25		}
						, {dataIndex : 'CODE_NAME_EN',		flex : .25		}
						, {dataIndex : 'CODE_NAME_CN',		flex : .25		}
						, {dataIndex : 'CODE_NAME_JP',		flex : .25		}					
					]
			,makeName:function(record, obj)	{ // obj = {'colNm' :fieldName, 'nValue': newValue}
				var systemCode,moduleCode, keyname , rtn="";
				var me = this;
				
				if(Ext.isDefined(record.get('SYSTEM'))) {
					systemCode = me.getComboRefCode('CBS_AU_B902',  obj.colNm == 'SYSTEM' ? obj.nValue : record.get('SYSTEM'));
				}
				if(Ext.isDefined(record.get('MODULE'))) {
					moduleCode = me.getComboRefCode('CBS_AU_B904',  obj.colNm == 'MODULE' ? obj.nValue : record.get('MODULE'));
				}
				if(Ext.isDefined(record.get('NAME'))) {
					keyname =  obj.colNm == 'NAME' ? obj.nValue : record.get('NAME');
				}
				console.log(' systemCode :',systemCode,'  moduleCode :',moduleCode);
				if( systemCode &&  moduleCode && keyname) {
					if(Ext.isDefined(keyname) )	{
						return systemCode+'.'+moduleCode+'.'+keyname;
					}
				}
				return rtn;
			},
			getComboRefCode : function(storeId, value)	{
				var me = this;
				var store = Ext.data.StoreManager.lookup(storeId);
				var recordIdx = store.find("value", value);
				if(recordIdx > -1){
					var record = store.getAt(recordIdx);
					return record.get("refCode1");
				}else {
					return null;
				}
			}			
		});
		
		
	
	var panelSearch = Unilite.createSearchPanel('bsa031ukrvSearchForm',{// Unilite.createSearchForm('searchForm',{
			title: '검색조건',
			defaultType: 'uniSearchSubPanel',
			collapsed: UserInfo.appOption.collapseLeftSearch,
	        listeners: {
		        collapse: function () {
		        	panelResult.show();
		        },
		        expand: function() {
		        	panelResult.hide();
		        }
		    },
			items:[{	
				id: 'search_panel1',
	   			itemId: 'search_panel1',
	           	layout: {type: 'uniTable', columns: 2},
	           	defaultType: 'uniTextfield',   			
		    	items:[ 
						  {fieldLabel : '코드명',		name : 'NAME', colspan:2,
						  	listeners:{
						  		change:function(field, newValue, oldValue)	{
						  			panelResult.setValue('NAME', newValue);
						  			return true;
						  		}
						  	}
						  }
						, {fieldLabel : '키',			name : 'CODE', colspan:2,
						  	listeners:{
						  		change:function(field, newValue, oldValue)	{
						  			panelResult.setValue('CODE', newValue);
						  			return true;
						  		}
						  	}}
						, {fieldLabel : '시스템구분',	name : 'SYSTEM', 		xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B902', colspan:2,
						  	listeners:{
						  		change:function(field, newValue, oldValue)	{
						  			panelResult.setValue('SYSTEM', newValue);
						  			return true;
						  		}
						  	}} 
						, {fieldLabel : '모듈',			name : 'MODULE', 		xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B904', colspan:2,
						  	listeners:{
						  		change:function(field, newValue, oldValue)	{
						  			panelResult.setValue('MODULE', newValue);
						  			return true;
						  		}
						  	}} 
						, {xtype:'button', text:'전체 파일생성', width:100, tdAttrs:{align:'right'},handler:function(){}}
						, {xtype:'button', text:'조건 파일생성', width:120, tdAttrs:{align:'right'},handler:function(){}}
						, {fieldLabel : '유형',			name : 'TYPE', hidden:true, value:'MESSAGE'}
						]
			}/*,{
				title: '파일생성', 	
				id: 'search_panel2',
				layout: {type: 'uniTable', columns: 2},
		    	items:[ 
						  {fieldLabel : '제품구분',		name : 'F_PRODUCT', 	xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B901', colspan:2}
						, {fieldLabel : 'SYSTEM',		name : 'F_SYSTEM', 		xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B902', colspan:2} 
						, {fieldLabel : '유형',			name : 'F_TYPE', 		xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B903', colspan:2}
						, {fieldLabel : '모듈',			name : 'F_MODULE', 		xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B904', colspan:2} 
						, {xtype:'button', text:'전체파일생성', width:100, tdAttrs:{align:'right'},handler:function(){}}
						, {xtype:'button', text:'조건별 파일생성', width:120, tdAttrs:{align:'right'},handler:function(){}}
						]
			}*/]
		});

  var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 6},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			  {fieldLabel : '키',			name : 'CODE',
			  	listeners:{
			  		change:function(field, newValue, oldValue)	{
			  			panelSearch.setValue('CODE', newValue);
			  			return true;
			  		}
			  	}
			  }
			, {fieldLabel : '코드명',		name : 'NAME' ,
			  	listeners:{
			  		change:function(field, newValue, oldValue)	{
			  			panelSearch.setValue('NAME', newValue);
			  			return true;
			  		}
			  	}
			  }
			, {fieldLabel : '시스템구분',		name : 'SYSTEM', 	xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B902',
			  	listeners:{
			  		change:function(field, newValue, oldValue)	{
			  			panelSearch.setValue('SYSTEM', newValue);
			  			return true;
			  		}
			  	}
			  } 
			, {fieldLabel : '모듈',			name : 'MODULE', 	xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B904',
			  	listeners:{
			  		change:function(field, newValue, oldValue)	{
			  			panelSearch.setValue('MODULE', newValue);
			  			return true;
			  		}
			  	}
			  } 
			, {xtype:'button', text:'전체 파일생성', tdAttrs:{align:'right', width:100},handler:function(){}}
			, {xtype:'button', text:'조건 파일생성', tdAttrs:{align:'right', width:100},handler:function(){}}
			, {fieldLabel : '유형',			name : 'TYPE', hidden:true, value:'MESSAGE'}
		]})
		
    Unilite.Main({
    		 id  : 'baa031ukrvApp',
			 borderItems : [ panelSearch, panelResult, masterGrid ]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
			}
			, onQueryButtonDown:function() {
//				if(!UniAppManager.app._needSave())	{
					masterGrid.getStore().loadStoreRecords();
//				}
			}
			, onNewDataButtonDown : function()	{
					var r = masterGrid.createRow();
				
			}
			, onSaveDataButtonDown: function () {											
					directMasterStore.saveStore();	//Master 데이타 저장 성공 후 Detail 저장함.				
				}
			, onDeleteDataButtonDown : function()	{
				var selIndex = masterGrid.getSelectedRecord();
					if(confirm(Msg.sMB045))	{
						masterGrid.deleteSelectedRow(selIndex);
					}
					
				},
				onResetButtonDown: function() {
//					if(!UniAppManager.app._needSave())	{
						panelSearch.clearForm();
						
						masterGrid.getStore().loadData({});
//					}
				}	
			
		});
		
		Unilite.createValidator('validator01', {
			store : directMasterStore,
			grid: masterGrid,
			validate: function( type, fieldName, newValue, oldValue, record, eopt) {
				console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
				var rv = true;
				if(  fieldName == 'SYSTEM'|| fieldName == 'MODULE' || fieldName == 'NAME') {		// 거래처(약명)}
					record.set('CODE', masterGrid.makeName(record, {'colNm' :fieldName, 'nValue': newValue}));
					return true;
				}else {
					return true;
				}
				
			}
		})
		
//		Unilite.createValidator('validator02', {
//			forms: {'formB':panelSearch},
//			validate: function( type, fieldName, newValue, oldValue, record, form, field, eopt) {
//				if(field.isValid())	{
//					if(form.getId() =='bsa032ukrvSearchForm')	{
//						console.log('field : ', field)
//						
//						panelResult.setValue(fieldName, newValue);
//					}else {
//						console.log('field : ', field)
//						panelSearch.setValue(fieldName, newValue);
//					}
//					return true;
//				}
//				return false;
//			}
//		})
};	// appMain
</script>