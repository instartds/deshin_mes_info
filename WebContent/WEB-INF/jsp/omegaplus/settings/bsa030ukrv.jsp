<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//다국어코드 등록(화면)
request.setAttribute("PKGNAME","Unilite_app_bsa030ukrv");
%>
<t:appConfig pgmId="bsa030ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="B902" />
	<t:ExtComboStore comboType="AU" comboCode="B903" />
	<t:ExtComboStore comboType="AU" comboCode="B904" />
	<t:ExtComboStore comboType="AU" comboCode="B905" />
</t:appConfig>
<script type="text/javascript">
var fileWindow;
function appMain() {

		Unilite.defineModel('${PKGNAME}MasterModel', { 
			fields : [ {name : 'SYSTEM',		text : '구분',		type : 'string',	allowBlank:false, comboType : 'AU', comboCode : 'B902'}
					 , {name : 'MODULE',		text : '모듈',		type : 'string',	allowBlank:false, comboType : 'AU', comboCode : 'B904'}
					 , {name : 'NAME',			text : '코드',		type : 'string',    allowBlank:false	  }	
					 , {name : 'CODE',			text : '키',		type : 'string',    allowBlank:false, editable:false}					 				 
					 , {name : 'CODE_NAME',		text : '한국어',	type : 'string'  }
					 , {name : 'CODE_NAME_EN',	text : '영어',		type : 'string'	 }
					 , {name : 'CODE_NAME_CN',	text : '중국어',	type : 'string'  }
					 , {name : 'CODE_NAME_JP',	text : '일본어',	type : 'string'  }
					 , {name : 'CODE_NAME_VI',	text : '베트남어',	type : 'string'  }
					 , {name : 'TYPE',			text : '유형',		type : 'string',	allowBlank:false, comboType : 'AU', comboCode : 'B903'}
					 , {name : 'REF_MSG_NO1',	text : '참조1',		type : 'string'  }
					 , {name : 'REF_MSG_NO2',	text : '참조2',		type : 'string'  }
					 , {name : 'REF_MSG_NO3',	text : '참조3',		type : 'string'  }
					 , {name : 'REF_MSG_NO4',	text : '참조4',		type : 'string'  }
					 , {name : 'REF_MSG_NO5',	text : '참조5',		type : 'string'  }
					 , {name : 'tag',			text : 'Tag',		type : 'string'  , convert:fnConvert, editable:false}
					]
		});
		function fnConvert( value, record)	{
			return '&#706;t:message code="'+record.get("CODE")+'" default="'+record.get("CODE_NAME")+'"/&#707;';
		}
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
				var param= Ext.getCmp('bsa030ukrvSearchForm').getValues();	
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
		
		//new Ext.data.Store({
					        
		var sortStore = Ext.create('Ext.data.Store', { 
			storeId: 'sort',
			field : [
				{name:'text' , type:'string'},
				{name:'value' , type:'string'}
			],
			data:[
				{'text':'한국어' ,value:'CODE_NAME'},
				{'text':'코드' ,value:'NAME'},
				{'text':'키' ,value:'CODE'}
			]
		});
		
		

		// create the Grid
		var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
			region : 'center',
			uniOpt:{expandLastColumn:false, useContextMenu:true, copiedRow:true},
			store: directMasterStore,
	        itemId:'${PKGNAME}Grid',
			columns : [   {dataIndex : 'SYSTEM',			width : 80		}
						, {dataIndex : 'TYPE',				width : 70		}
						, {dataIndex : 'MODULE',			width : 80		}
						, {dataIndex : 'NAME',				width : 110		}
						, {dataIndex : 'CODE',				width : 250		}						
						, {dataIndex : 'CODE_NAME',			width : 150		}
						, {dataIndex : 'CODE_NAME_EN',		width : 150		}
						, {dataIndex : 'CODE_NAME_CN',		width : 150		}
						, {dataIndex : 'CODE_NAME_JP',		width : 150		}		
						, {dataIndex : 'CODE_NAME_VI',		width : 150		}	
						, {dataIndex : 'REF_MSG_NO1',		width : 100		}	
						, {dataIndex : 'REF_MSG_NO2',		width : 100		}	
						, {dataIndex : 'tag',				width : 300		}
						, {dataIndex : 'REF_MSG_NO3',		width : 100,	hidden:true	}	
						, {dataIndex : 'REF_MSG_NO4',		width : 100,	hidden:true }	
						, {dataIndex : 'REF_MSG_NO5',		width : 100,	hidden:true	}
						
					],
			listeners: {          	
				beforeedit  : function( editor, e, eOpts ) {
					if(UniUtils.indexOf(e.field, ['SYSTEM','TYPE','MODULE','NAME','CODE'])){
	    				if(e.record.phantom){
	    				    return true;
	    				}else{
	    				    return false;
	    				}
					}
				},
				edit:function(editor)	{
					masterForm.setActiveRecord(editor.context.record);
				},
				selectionchangerecord:function(selected)	{
          			masterForm.setActiveRecord(selected);
				}
			}
			,makeName:function(record, obj)	{ // obj = {'colNm' :fieldName, 'nValue': newValue}
				var systemCode,typeCode,moduleCode, keyname , rtn="";
				var me = this;
				
				if(Ext.isDefined(record.get('SYSTEM'))) {
					systemCode = me.getComboRefCode('CBS_AU_B902',  obj.colNm == 'SYSTEM' ? obj.nValue : record.get('SYSTEM'));
				}
				if(Ext.isDefined(record.get('TYPE'))) {
					typeCode = me.getComboRefCode('CBS_AU_B903',  obj.colNm == 'TYPE' ? obj.nValue : record.get('TYPE'));
				}
				if(Ext.isDefined(record.get('MODULE'))) {
					moduleCode = me.getComboRefCode('CBS_AU_B904',  obj.colNm == 'MODULE' ? obj.nValue : record.get('MODULE'));
				}
				if(Ext.isDefined(record.get('NAME'))) {
					keyname =  obj.colNm == 'NAME' ? obj.nValue : record.get('NAME');
				}
				console.log(' systemCode :',systemCode,'  moduleCode :',moduleCode);
				if( systemCode && typeCode && keyname) {
					if(Ext.isDefined(keyname) )	{
						var rStr = "";
						if(systemCode != null)	rStr += systemCode+".";
						if(typeCode != null)	rStr += typeCode+".";
						if(moduleCode != null)	rStr += moduleCode+".";
						rStr += keyname;
						return rStr ;
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
		var masterForm  = Unilite.createForm('detailForm', {
			region:'south',
			height:165,
			disabled:false,
	    	masterGrid: masterGrid,
	        autoScroll:true,
	        border: false,
	        padding: '10 10 10 10',       
	        uniOpt:{
	        	store : directMasterStore
	        },
		    //for Form      
		    layout: {
		    	type: 'uniTable',
		    	columns: 1
		    },
		    masterGrid: masterGrid,
		    items : [
		    	  { fieldLabel: '한국어'	, name : 'CODE_NAME',			width : 1300		}
				, { fieldLabel: '영어'		, name : 'CODE_NAME_EN',		width : 1300		}
				, { fieldLabel: '중국어'	, name : 'CODE_NAME_CN',		width : 1300		}
				, { fieldLabel: '일본어'	, name : 'CODE_NAME_JP',		width : 1300		}		
				, { fieldLabel: '베트남어'	, name : 'CODE_NAME_VI',		width : 1300		}
			]
		});

  var panelSearch = Unilite.createSearchForm('bsa030ukrvSearchForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 7},
		padding:'1 1 1 1',
		border:true,
		items: [
			  {fieldLabel : '코드',			name : 'CODE'}
			, {fieldLabel : '시스템구분',	name : 'SYSTEM', 	xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B902', value:'1'} 
			, {fieldLabel : '유형',			name : 'TYPE', 	xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B903'} 
			
			, {fieldLabel : '모듈',			name : 'MODULE', 	xtype:'uniCombobox', 	comboType : 'AU', comboCode : 'B904'}
			, {fieldLabel : '정렬',			name : 'SORT', 	xtype:'uniCombobox', store:sortStore, value:'CODE_NAME'
				
			  }
			, {xtype:'button', text:'파일생성', tdAttrs:{ align:'right', width:'40%'}
				,handler:function(){
				    if(!fileWindow) {
					    	Unilite.defineModel('printModel', {
							fields: [
							    	{name: 'Module'			,text: '모듈' 			,type: 'string'}, 
							    	{name: 'downloaded'		,text: 'downloaded' 	,type: 'int', defaultValue:0}
								]
							});
							var moduleStore = Ext.data.StoreManager.lookup('CBS_AU_B904')
		                	var moduleList = moduleStore.getData().items;
		                	var data = Array();
		                	Ext.each(moduleList,function(record,idx){
		                		data.push({'Module' : record.get("value"),'Text':record.get('text'), downloaded:0});
		                	})
							var store1 = new Ext.data.Store({
					        	storeId: 'lang',
					      		model:'printModel',
					    		data:data
					    	});
							
							fileWindow = Ext.create('widget.uniDetailWindow', {
				                title: '파일생성',
				                width: 400,				                
				                height: 150,
				                layout: {type:'uniTable', columns:1, tableAttrs:{'width':'100%'}},	                
				                items: [{
					                	itemId:'fileDownloadForm',
					                	xtype:'uniSearchForm',
					                	flex: 1,
					                	url: CPATH+'/omegaplus/downloadLangugeFile.do',
								    	standardSubmit: true,
					                	style:{'background-color':'#fff'},
					                	items:[
					                		{	
					                			fieldLabel:'언어선택',
					                			xtype:'uniCombobox',
					                			name :'LANG_CODE',
					                			allowBlank:false,
					                			comboType : 'AU', 
					                			comboCode : 'B905',
					                			listeners:{
					                				change:function(field, newValue, oldValue)	{
					                					var langStore = Ext.data.StoreManager.lookup('CBS_AU_B905');
					                					var record = langStore.getAt(langStore.find("value", newValue));
					                					if(record)	{
															field.ownerCt.setValue("LANG", record.get("refCode2"));
					                					}
					                				}
					                			}
					                		},{
					                			fieldLabel:'언어코드',
					                			name:'LANG',
					                			hidden:true
					                		},{
					                			fieldLabel:'모듈코드',
					                			xtype:'uniCombobox',
					                			name:'MODULE_CODE',
					                			comboType : 'AU', 
					                			comboCode : 'B904'
					                		}
					                	]
				               		}
								],
				                tbar:  [
							         '->',{
										itemId : 'submitBtn',
										text: '내려받기',
										handler: function() {
											fileWindow.onApply();
										},
										disabled: false
									},{
										itemId : 'closeBtn',
										text: '닫기',
										handler: function() {
											fileWindow.hide();
										},
										disabled: false
									}
							    ],
								listeners : {
									beforehide: function(me, eOpt)	{
										fileWindow.down('#fileDownloadForm').clearForm();
				                	},
				                	beforeclose: function( panel, eOpts )	{
										fileWindow.down('#fileDownloadForm').clearForm();
				                	},
				                	show: function( panel, eOpts )	{
										var form = fileWindow.down('#fileDownloadForm');
										form.reset();
		                			}
				                },
				                onApply:function()	{
				                	var len = moduleList.length;
				                	var form = fileWindow.down('#fileDownloadForm');
				                	if(Ext.isEmpty(form.getValue("LANG_CODE")))	{
				                		alert("언어를 선택 하세요")
				                		return;
				                	}
				                	var interValTime = 1000;
				                	if(Ext.isEmpty(form.getValue("MODULE_CODE")))	{ 
					                	Ext.each(moduleList, function(module, idx){
					                		var iframeName = module.get("value")+module.get("text")+idx;//param.TYPE+param.MODULE+param.MODULE_INITIAL;
						                	var iframe1 = Ext.create('Ext.ux.IFrame', {
						                		//<iframe src="{src}" id="{id}-iframeEl" data-ref="iframeEl" name="{frameName}" width="100%" height="100%" frameborder="0"></iframe>'
						                		src: "about:blank",
						                		frameName:"Label"+iframeName,
												width:0,
												height:0
						                	});
						                	form.add(iframe1);
						                	var iframe2 = Ext.create('Ext.ux.IFrame', {
						                		//<iframe src="{src}" id="{id}-iframeEl" data-ref="iframeEl" name="{frameName}" width="100%" height="100%" frameborder="0"></iframe>'
						                		src: "about:blank",
						                		frameName:"Message"+iframeName,
												width:0,
												height:0
						                	});
						                	form.add(iframe2);
					                		console.log("Label "+module.get("text")+" "+idx+' '+interValTime*idx);
						                	setTimeout(function(){fileWindow.download(module, "Label", "Label"+iframeName);}	, interValTime*idx);
						                	console.log("Message "+module.get("text")+" "+idx+' '+(interValTime*len+interValTime*idx));
						                	setTimeout(function(){fileWindow.download(module, "Message", "Message"+iframeName);}	, interValTime*len+interValTime*idx);
					                	})
				                	} else {
										var moduleStore = Ext.data.StoreManager.lookup('CBS_AU_B904');
		                				var module = moduleStore.getAt(moduleStore.find("value", form.getValue("MODULE_CODE")));
		                				
		                				var iframeName = module.get("value")+module.get("text");//param.TYPE+param.MODULE+param.MODULE_INITIAL;
					                	var iframe1 = Ext.create('Ext.ux.IFrame', {
					                		//<iframe src="{src}" id="{id}-iframeEl" data-ref="iframeEl" name="{frameName}" width="100%" height="100%" frameborder="0"></iframe>'
					                		src: "about:blank",
					                		frameName:"Label"+iframeName,
											width:0,
											height:0
					                	});
					                	form.add(iframe1);
					                	var iframe2 = Ext.create('Ext.ux.IFrame', {
					                		//<iframe src="{src}" id="{id}-iframeEl" data-ref="iframeEl" name="{frameName}" width="100%" height="100%" frameborder="0"></iframe>'
					                		src: "about:blank",
					                		frameName:"Message"+iframeName,
											width:0,
											height:0
					                	});
					                	form.add(iframe2);
			                			if(module)	{
					                		setTimeout(function(){fileWindow.download(module, "Label", "Label"+iframeName);}	, interValTime);
							                setTimeout(function(){fileWindow.download(module, "Message", "Message"+iframeName);}	, interValTime*2);
		                				}
				                	}
				                },
				                download:function(module, type, iframeName)	{
				                	var form = fileWindow.down('#fileDownloadForm');
				                	var moduleStore = Ext.data.StoreManager.lookup('CBS_AU_B904');
		                			var moduleList = moduleStore.getData().items;
				                	var len= moduleStore.getData().items.length;
				                	
				                	var typeStore = Ext.data.StoreManager.lookup('CBS_AU_B903');
		                			var typeRecord = typeStore.getAt(typeStore.find("refCode1", type.toLowerCase()));
				                	
				                	
				                	if(Ext.isEmpty(form.getValue("LANG_CODE")))	{
				                		return;
				                	}
				                	var param = form.getValues();
				                	
				                	param.MODULE = module.get("value");
				                	param.MODULE_INITIAL = module.get("refCode2");
				                	param.TYPE = type;
				                	param.TYPE_CODE = typeRecord.get("value");
				                	
			                		form.getForm().submit({params:param, target:iframeName,/* target:'_blank',*/ success:function(){console.log("test",param.MODULE_INITIAL,param.TYPE)}});
				                }
							});
				    }	
					fileWindow.center();
					fileWindow.show();
			
			   }}
			
			, {xtype:'component', width:10, html:'&nbsp;'}
			,{fieldLabel : '한국어',			name : 'CODE_NAME'}
			,{fieldLabel : '영어',			name : 'CODE_NAME_EN'}
			,{fieldLabel : '중국어',			name : 'CODE_NAME_CN'}
			,{fieldLabel : '일본어',			name : 'CODE_NAME_JP'}
			,{fieldLabel : '베트남어',			name : 'CODE_NAME_VI', colspan:3}
			
		]})
		
    Unilite.Main({
    		 id  : 'baa030ukrvApp',
			 borderItems : [ panelSearch, masterGrid , masterForm]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
			}
			, onQueryButtonDown:function() {
//				if(!UniAppManager.app._needSave())	{
					masterGrid.getStore().loadStoreRecords();
//				}
			}
			, onNewDataButtonDown : function()	{
				var codeName = '';
				if(masterGrid.store.getSorters()&& masterGrid.store.getSorters().items.length)	{
					var sel = masterGrid.getSelectedRecord();
					codeName = sel != null ? sel.get('CODE_NAME'):''
				}
					
				var r = masterGrid.createRow({
						SYSTEM: panelSearch.getValue('SYSTEM'),
						MODULE:panelSearch.getValue('MODULE'), 
						TYPE: panelSearch.getValue('TYPE'),
						CODE_NAME: codeName
					}, null, null);
				
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
				if(  fieldName == 'SYSTEM' || fieldName == 'TYPE' || fieldName == 'MODULE' || fieldName == 'NAME') {	
					record.set('CODE', masterGrid.makeName(record, {'colNm' :fieldName, 'nValue': newValue}));
					return true;
				}else if(fieldName == 'CODE_NAME' || fieldName == 'NAME'){
					setTimeout(function(){record.set('tag',fnConvert( '', record))},1);
					return true;
				}else {
					return true;
				}
				
			}
		})
		
};	// appMain
</script>