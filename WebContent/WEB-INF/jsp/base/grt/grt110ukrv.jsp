<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노선이력정보 등록
request.setAttribute("PKGNAME","Unilite_app_grt110ukrv");
%>
<t:appConfig pgmId="grt110ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소  	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO10"/>				<!-- 운행구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO11"/>				<!-- 노선구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO12"/>				<!-- 시계구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 운행/폐지 구분  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO14"/>				<!-- 배차패턴  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO16"/>				<!-- 노선그룹  	-->	
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' ></script>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}-model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'<t:message code="system.label.base.division" default="사업장"/>'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
					,{name: 'ROUTE_CODE'    		,text:'노선코드'		,type : 'string'  ,editable:false } 
					,{name: 'ROUTE_START_DATE'    	,text:'노선변경적용일'	,type : 'uniDate' ,allowBlank:false, isPk:true, pkGen:'user' } 					
					,{name: 'ROUTE_END_DATE'    	,text:'노선변경완료일'	,type : 'uniDate' ,editable:false} 					
					,{name: 'OFFICE_CODE'    		,text:'영업소'			,type : 'string' ,comboType: 'AU' ,comboCode: 'GO01',allowBlank:false} 
					,{name: 'ROUTE_GROUP'    		,text:'노선그룹'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO16',allowBlank:false} 
					,{name: 'PLAN_PATTERN'    		,text:'배차패턴'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO14',allowBlank:false} 
					,{name: 'ROUTE_ID'    			,text:'노선ID'			,type : 'string' } 					
					,{name: 'OPERATION_TYPE'    	,text:'운행구분'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO10'} 					
					,{name: 'ROUTE_TYPE'    		,text:'노선구분'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO11'}
					,{name: 'BOUNDARY_TYPE'    		,text:'시계구분'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO12'} 					
					,{name: 'START_STOP'    		,text:'기점'			,type : 'string' }
					,{name: 'MID_STOP'    			,text:'주요경유지'		,type : 'string' } 					
					,{name: 'LAST_STOP'    			,text:'종점'			,type : 'string' }
					,{name: 'APPROV_CNT'    		,text:'인가댓수'		,type : 'uniQty' } 					
					,{name: 'APPROV_DISTANCE'    	,text:'인가거리'		,type : 'uniPercent' }
					,{name: 'ACTUAL_CNT'    		,text:'실제댓수'		,type : 'uniQty' ,editable:false} 					
					,{name: 'ACTUAL_DISTANCE'    	,text:'실제거리'		,type : 'uniPercent' }
					,{name: 'SELF_CNT'    			,text:'자차댓수'		,type : 'uniQty' }
					,{name: 'OTHER_CNT'    			,text:'타차댓수'		,type : 'uniQty' }					
					,{name: 'RUN_CNT_MAX'    		,text:'운행횟수_최대'	,type : 'uniQty' } 					
					,{name: 'RUN_CNT_MIN'    		,text:'운행횟수_최소'	,type : 'uniQty' }
					,{name: 'RUN_TERM_MAX'    		,text:'운행간격_최대'	,type : 'uniQty' } 					
					,{name: 'RUN_TERM_MIN'    		,text:'운행간격_최소'	,type : 'uniQty' }
					,{name: 'RUN_START_TIME'    	,text:'운행시각_첫차'	,type : 'string' } 	
					,{name: 'RUN_LAST_TIME'    		,text:'운행시각_막차'	,type : 'string' }
					,{name: 'MAKEREADY_TIME'    	,text:'첫차준비시간'	,type : 'int' }
					,{name: 'MANAGE_TIME'    		,text:'막차정리시간'	,type : 'int' }
					,{name: 'REMARK'  				,text:'<t:message code="system.label.base.remarks" default="비고"/>'			,type : 'string'} 
					,{name: 'COMP_CODE'  			,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
					,{name: 'DOC_NO'				,text:'문서번호'	,type:'string' , editable:false}
					,{name: 'ADD_FIDS'				,text:'등록파일'		,type:'string' , editable:false}
	             	,{name: 'DEL_FIDS'				,text:'삭제파일'		,type:'string' , editable:false}
			]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read 	: 'grt110ukrvService.selectList',
		   	update 	: 'grt110ukrvService.update',
		   	create 	: 'grt110ukrvService.insert',
		   	destroy : 'grt110ukrvService.delete',
			syncAll	: 'grt110ukrvService.saveAll'
		}
	});	
    var masterStore =  Unilite.createStore('${PKGNAME}-store',{
        model: '${PKGNAME}-model',
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
				config = {
					params:[panelSearch.getValues()],
					success: function()	{
						var fp = Ext.getCmp('${PKGNAME}-FileUploadPanel');
						
						var record = routeGrid.getSelectedRecord();
						masterStore.loadStoreRecords(record);
					}
				}
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
				}else {
					var grid = Ext.getCmp('${PKGNAME}-grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function(record)	{				
				var param= {
					'DIV_CODE' : record.get('DIV_CODE'),
					'ROUTE_CODE': record.get('ROUTE_CODE')
				}
				this.load({params: param});				
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					detailForm.setActiveRecord(record);
				}	
			
			}
            
		});
	
	Unilite.defineModel('${PKGNAME}-routeModel', {
	    fields: [
					 {name: 'DIV_CODE'   	,text:'<t:message code="system.label.base.division" default="사업장"/>'		,type : 'string'  ,comboType: 'BOR120' } 
					,{name: 'ROUTE_CODE'    ,text:'노선코드'	,type : 'string' } 
					,{name: 'ROUTE_NUM'    	,text:'번호'	,type : 'string' } 					
					,{name: 'ROUTE_NAME'    ,text:'노선명'		,type : 'string' } 
					,{name: 'ROUTE_STATUS'  ,text:'노선상태'	,type : 'string' ,comboType:'AU', comboCode:'GO13'}
					,{name: 'COMP_CODE'  	,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'	,type : 'string' } 
			]
	});


    var routeStore =  Unilite.createStore('${PKGNAME}-store',{
        model: '${PKGNAME}-routeModel',
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
                	   read : 'grt100ukrvService.selectList'                	   
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}-searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
            
		});		
		
	var routeGrid = Unilite.createGrid('${PKGNAME}-routeGrid', {
		uniOpt:{
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
				if(masterStore.isDirty() )	{
					if(confirm(Msg.sMB061))	{
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}  else {
						UniAppManager.app.rejectSave();
					}
				}
			},
      		selectionchange: function( grid, selected, eOpts ) {   
      				detailForm.clearForm();
      				detailForm.down('#fileUploadPanel').clear();
					masterStore.loadStoreRecords(selected[0]);
			}
         }
   });
		
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}-searchForm',{
		title: '노선정보',
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
						fieldLabel: '노선코드',
						name: 'ROUTE_CODE'	
					},{	    
						fieldLabel: '노선번호',
						name: 'ROUTE_NUM'	
					},{	    
						fieldLabel: '노선명',
						name: 'ROUTE_NAME'	
					},{	    
						fieldLabel: '노선상태',
						name: 'ROUTE_STATUS',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO13'
					}]				
				},{	
					header: false,
					id: 'search_panel2',
		   			itemId: 'search_panel2',
		   			layout:{type:'vbox', align:'stretch'},
		   			flex: .8,
		           	items: [routeGrid]			
				}]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}-grid', {
     	
        layout : 'fit',        
    	region:'center',
    	flex:.35,
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: true,   
			   useStateList: true  
			}
        },
    	store: masterStore,
		columns:[
		
			{dataIndex:'DIV_CODE'			,width: 80},
			{dataIndex:'ROUTE_CODE'			,width: 100},
			{dataIndex:'ROUTE_START_DATE'	,width: 110},
			{dataIndex:'ROUTE_END_DATE'		,width: 110},
			{dataIndex:'OFFICE_CODE'		,width: 100},
			{dataIndex:'ROUTE_GROUP'		,width: 100},
			{dataIndex:'PLAN_PATTERN'		,width: 300},
			{dataIndex:'ROUTE_ID'			,width: 100},
			{dataIndex:'OPERATION_TYPE'		,width: 120},
			{dataIndex:'ROUTE_TYPE'			,width: 100},
			{dataIndex:'BOUNDARY_TYPE'		,width: 100},
			{dataIndex:'START_STOP'			,width: 100},
			{dataIndex:'MID_STOP'			,width: 100},
			{dataIndex:'LAST_STOP'			,width: 100},
			{dataIndex:'APPROV_CNT'			,width: 100},
			{dataIndex:'APPROV_DISTANCE'	,width: 100},
			{dataIndex:'RUN_START_TIME'	,width: 100},
			{dataIndex:'RUN_LAST_TIME'	,width: 100}
			
			
		]
		,listeners: {	
      		selectionchangerecord: function( selected ) {
      				detailForm.loadForm(selected);
			}
         }
   });

    var detailForm = Unilite.createForm('${PKGNAME}-Form', {
    	region:'south',
    	weight:-100,
    	flex:.65,
        layout : {type:'uniTable', columns:3},
        autoScroll:true,
        masterGrid: masterGrid,
        items:[
        	{	    
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				value: UserInfo.divCode,
				allowBlank:false
			},{	    
				fieldLabel: '노선코드',
				name: 'ROUTE_CODE',
				readOnly: true,
				allowBlank:false
			},{	    
				fieldLabel: '영업소',
				name: 'OFFICE_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO01',
				allowBlank:false
			},{	    
				fieldLabel: '노선그룹',
				name: 'ROUTE_GROUP',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO16',
				allowBlank:false
			},{	    
				fieldLabel: '노선변경적용일',
				name: 'ROUTE_START_DATE',
				xtype: 'uniDatefield',
				allowBlank:false
			},{	    
				fieldLabel: '노선변경완료일',
				name: 'ROUTE_END_DATE',
				xtype: 'uniDatefield',
				readOnly: true
			},{	    
				fieldLabel: '노선ID',
				name: 'ROUTE_ID'
			},{	    
				fieldLabel: '배차패턴',
				name: 'PLAN_PATTERN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO14',
				width:490,
				colspan:2,
				allowBlank:false
			},{	    
				fieldLabel: '노선구분',
				name: 'ROUTE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO11'	
			},{	    
				fieldLabel: '운행구분',
				name: 'OPERATION_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO10'
			},{	    
				fieldLabel: '기점',
				name: 'START_STOP'
			},{	    
				fieldLabel: '시계구분',
				name: 'BOUNDARY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO12'
			},{	    
				fieldLabel: '주요경유지',
				name: 'MID_STOP'
			},{	    
				fieldLabel: '종점',
				name: 'LAST_STOP'
			},{	    
				fieldLabel: '인가댓수',
				name: 'APPROV_CNT',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '자사댓수',
				name: 'SELF_CNT',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '인가거리',
				name: 'APPROV_DISTANCE',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '실제댓수',
				name: 'ACTUAL_CNT',
				xtype: 'uniNumberfield',
				readOnly:true
			},{	    
				fieldLabel: '타사댓수',
				name: 'OTHER_CNT',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '실제거리',
				name: 'ACTUAL_DISTANCE',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '최대운행횟수',
				name: 'RUN_CNT_MAX',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '최대운행간격',
				name: 'RUN_TERM_MAX',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '첫차운행시각',
				name: 'RUN_START_TIME'
//				listeners:{
//					blur: function (field, The, eOpts )	{
//						detailForm.chkTime(UniDate.today(), field, field.getValue());
//					}
//				}
				/*,
				xtype: 'timefield',
				format:'H:i',
				altFormats:'H:i',
				submitFormat: 'H:i',
		        increment: 5*/
			},{	    
				fieldLabel: '최소운행횟수',
				name: 'RUN_CNT_MIN',
				xtype: 'uniNumberfield'
				
			},{	    
				fieldLabel: '최소운행간격',
				name: 'RUN_TERM_MIN',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '막차운행시각',
				name: 'RUN_LAST_TIME',
				/*xtype: 'timefield',
				format:'H:i',
				altFormats:'H:i',
				submitFormat: 'H:i',
		        increment: 5,*/
				colspan: 3/*,
				listeners:{
					blur: function (field, The, eOpts )	{
						detailForm.chkTime(UniDate.today(), field, field.getValue());
					}
				}*/
			},{	    
				fieldLabel: '첫차준비시간',
				name: 'MAKEREADY_TIME',
				xtype: 'uniNumberfield',
				suffixTpl:'&nbsp;분'
			},{	    
				fieldLabel: '막차정리시간',
				name: 'MANAGE_TIME',				
				colspan: 2,
				xtype: 'uniNumberfield',
				suffixTpl:'&nbsp;분'
			},{	    
				fieldLabel: '<t:message code="system.label.base.remarks" default="비고"/>',
				name: 'REMARK',				
				width: 735,
				maxLength:100,
				colspan: 3
			},{
				hideLabel:true,
				colspan: 3,
     			xtype:'xuploadpanel',
     			id : '${PKGNAME}-FileUploadPanel',
		    	itemId:'fileUploadPanel',
		    	flex:1,
		    	height:200,
		    	listeners : {
		    		change: function() {
	       				     UniAppManager.app.setToolbarButtons('save',true);
		    		}
		    	}
			}
        ],loadForm: function(record)	{
			// window 오픈시 form에 Data load
        	var fp = this.down('#fileUploadPanel');
        	fp.reset();
			this.setActiveRecord(record || null);   
			
			//첨부파일
		    var docNo='';
		    if(!Ext.isEmpty(record))	{
		    	docNo= record.data['DOC_NO'];
		    }
		    if(!Ext.isEmpty(docNo) && Ext.isDefined(docNo))	{
		   	 	bdc100ukrvService.getFileList({DOC_NO : docNo},
													function(provider, response) {
														var fp = Ext.getCmp('${PKGNAME}-FileUploadPanel');
														if(provider)	{
															fp.loadData(provider);
														}else {
															fp.reset();
														}
													}
												 )
				//조회수 update
				//var param = {'DOC_NO': docNo};
				//bdc100ukrvService.updateReadCnt(param);
			}
		},
        chkTime: function(date, fieldName, newValue)	{
			var rtn = true;
			if(!date)	{
				rtn = "날짜를 입력해 주세요.";
				return rtn;
			}
			var val = newValue.replace(/:/g, "");
			if(val.length == 4)	{
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4)))	{
					rtn = "시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00';
					return rtn;
				}
				val = val.substring(0,2)+":"+val.substring(2,4);
				detailForm.setValue(fieldName, val);
			} else if(val.length == 6){
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4), val.substring(4,6)))	{
					rtn = "시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00';
					return rtn;
				}
				val = val.substring(0,2)+":"+val.substring(2,4)+":"+val.substring(4,6);						
				detailForm.setValue(fieldName, val);
			} else  if(val.length != 0) {
				rtn = "00:00:00(시:분:초) 형식으로 입력하거나 숫자만 입력해 주세요.";				
			}					
			return rtn;
		}
//		chkTime: function(date, field, newValue)	{
//			
//			if(!date)	{
//				Unilite.messageBox("날짜를 입력해 주세요.");
//				return;
//			}
//			var val = newValue.replace(/:/g, "");
//			if(val.length == 4)	{
//				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4)))	{
//					detailForm.setValue(field.getName(), '');
//					Unilite.messageBox("시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00');
//					return;
//				}
//				val = val.substring(0,2)+":"+val.substring(2,4);
//				detailForm.setValue(field.getName(), val);
//			} else if(val.length == 6){
//				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4), val.substring(4,6)))	{
//					detailForm.setValue(field.getName(), '');
//					Unilite.messageBox("시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00');
//					return;
//				}
//				val = val.substring(0,2)+":"+val.substring(2,4)+":"+val.substring(4,6);						
//				detailForm.setValue(field.getName(), val);
//			} else  if(val.length != 0) {
//				detailForm.setValue(field.getName(), '');
//				Unilite.messageBox("00:00:00(시:분:초) 형식으로 입력하거나 숫자만 입력해 주세요.");
//				
//			}					
//		}
    });	
	
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  masterGrid,
	 		  detailForm
		],
		id  : '${PKGNAME}-ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'excel' ],true);
			if(!Ext.isEmpty(params))	{
				panelSearch.setValue('DIV_CODE',Unilite.nvl(params.DIV_CODE, UserInfo.divCode));
				panelSearch.setValue('ROUTE_CODE',params.ROUTE_CODE);
				panelSearch.setValue('ROUTE_NUM',params.ROUTE_NUM);
				panelSearch.setValue('ROUTE_NAME',params.ROUTE_NAME);
				panelSearch.setValue('ROUTE_STATUS',params.ROUTE_STATUS);
				UniAppManager.app.onQueryButtonDown();
			}
		},
		
		onQueryButtonDown : function()	{
			detailForm.clearForm();
			detailForm.down('#fileUploadPanel').clear();
			detailForm.setDisabled( true );
			routeStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			
			
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
			var selectedRec = routeGrid.getSelectedRecord();
			if(!Ext.isEmpty(selectedRec))	{
				var masterGridRec = masterGrid.getSelectedRecord();
				var r = {}
				if(masterGridRec == null || Ext.isEmpty(masterGridRec)) {
					r={ 'DIV_CODE': panelSearch.getValue('DIV_CODE'),				
						  'ROUTE_CODE' : selectedRec.get('ROUTE_CODE')
						}
				}else {
					r = masterGridRec.data;
					r["ROUTE_START_DATE"] = UniDate.getDateStr(UniDate.today());
					r["ROUTE_END_DATE"] = "29991231";
				}
				masterGrid.createRow(r);
			}else {
				Unilite.messageBox('노선을 조회 후 선택하세요.')
			}
		},	
		
		onSaveDataButtonDown: function (config) {
			var fp = detailForm.down('#fileUploadPanel');
			
			var addFiles = fp.getAddFiles();
			var delFiles = fp.getRemoveFiles();

			var record = masterGrid.getSelectedRecord();
			if(addFiles.length > 0)	{
                record.set('ADD_FIDS', addFiles );
            } else {
                record.set('ADD_FIDS', '' );
            }
			
			if(delFiles.length > 0)	{
                record.set('DEL_FIDS', delFiles );
            } else {
                record.set('DEL_FIDS', '' );
            }
            fp.reset();
			masterStore.saveStore(config);					
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
		rejectSave: function() {			
			masterStore.rejectChanges();	
			masterStore.onStoreActionEnable();
		}
	});

	//Unilite.createValidator('${PKGNAME}-validator', {
	Unilite.createValidator('${PKGNAME}-grid-validator', {
		store : masterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		//validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName)	{
				case 'ROUTE_START_DATE' :		
					var params = {
						'COMP_CODE': UserInfo.compCode,
						'DIV_CODE' : record.get('DIV_CODE'),
						'ROUTE_CODE': record.get('ROUTE_CODE'),
						'ROUTE_START_DATE': newValue
					}
					
					Ext.getBody().mask();
					var rec = record;
					grt110ukrvService.checkDate(params, function(provider, response)	{
						if(provider['CNT'] > 0)	{
							Unilite.messageBox('입력된 노선변경적용일은 이미 등록되어 있습니다.'+'\n'+'기존 등록된 변경적용일 이후의 날짜를 등록하세요.')
							rec.set('ROUTE_START_DATE', oldValue);
							detailForm.setValue('ROUTE_START_DATE', oldValue);
						}
						Ext.getBody().unmask();
					})
					break;
				case 'SELF_CNT' :	
						var actualCnt = newValue + record.get('OTHER_CNT');
						record.set('ACTUAL_CNT', actualCnt);
						detailForm.setValue('ACTUAL_CNT', actualCnt);
					break;
				case 'OTHER_CNT' :	
						var actualCnt = record.get('SELF_CNT') + newValue;
						record.set('ACTUAL_CNT', actualCnt);
						detailForm.setValue('ACTUAL_CNT', actualCnt);
					break;
				case "RUN_START_TIME" :
					rv = detailForm.chkTime(UniDate.today(), fieldName, newValue);
					break;						
					
				case "RUN_LAST_TIME" :
					rv = detailForm.chkTime(UniDate.today(), fieldName, newValue);
					break;
				default :
					break;
			}
			return rv;
		}
	}); // validator
	
	/*Unilite.createValidator('${PKGNAME}-forms-validator', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			
			switch(fieldName) {				
				case "RUN_START_TIME" :
					rv = detailForm.chkTime(UniDate.today(), field, field.getValue());
					break;						
					
				case "RUN_LAST_TIME" :
					rv = detailForm.chkTime(UniDate.today(), field, field.getValue());
					break;

			}
			return rv;
		}
	}); // form.validator
	*/
}; // main
  
</script>