<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노무 등록
request.setAttribute("PKGNAME","Unilite_app_gla100ukrv");
%>
<t:appConfig pgmId="gla100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO31"/>				<!-- 접수방법  	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO32"/>				<!-- 발생구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO33"/>				<!-- 장소구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO34"/>				<!-- 처리결과  	-->
	<t:ExtComboStore comboType="AU" comboCode="A020"/>				<!-- 보험접수여부  	-->
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'		,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
					,{name: 'REGIST_NUM'    		,text:'접수번호'		,type : 'string'  ,editable:false } 
					,{name: 'REGIST_DATE'    		,text:'접수일'			,type : 'uniDate' ,defaultValue:UniDate.today()} 					
					,{name: 'OFFENCE_DATE'    		,text:'발생일'			,type : 'uniDate' ,defaultValue:UniDate.today()} 					
					,{name: 'OFFENCE_TIME'    		,text:'발생시간'		,type : 'string' } 					
					,{name: 'DRIVER_CODE'    		,text:'대상자코드'		,type : 'string' } 	
					,{name: 'DRIVER_NAME'    		,text:'대상자'			,type : 'string' } 
					,{name: 'REGIST_GUBUN'    		,text:'접수방법'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO31'} 					
					,{name: 'VEHICLE_CODE'    		,text:'차량코드'		,type : 'string' }
					,{name: 'VEHICLE_NAME'    		,text:'차량'			,type : 'string' }
					,{name: 'PLACE_GUBUN'    		,text:'장소구분'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO33'} 					
					,{name: 'PLACE'    				,text:'장소'			,type : 'string' }
					,{name: 'ROUTE_CODE'    		,text:'노선'			,type : 'string' , store: Ext.data.StoreManager.lookup('routeStore')} 					
					,{name: 'PENALTY_POINT'    		,text:'점수'			,type : 'int' }
					,{name: 'OFFENCE_TYPE'    		,text:'발생구분'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO32'} 					
					,{name: 'SUMMARY'    			,text:'개요'			,type : 'string' }
					,{name: 'REGIST_PERSON'    		,text:'접수자'			,type : 'string' } 					
					,{name: 'REPORT_PERSON'    		,text:'신고자'			,type : 'string' }
					,{name: 'RESULT_DATE'    		,text:'처리일'			,type : 'uniDate' } 
					,{name: 'RESULT'    			,text:'처리결과'		,type : 'string' ,comboType: 'AU' ,comboCode: 'GO34'}
					,{name: 'RESULT_PERSON'    		,text:'처리자'			,type : 'string' } 					
					,{name: 'FINE'    				,text:'과징금'			,type : 'uniPrice' }
					,{name: 'BILL_NUMBER'    		,text:'고지서번호'		,type : 'string' } 					
					,{name: 'RESULT_TEAM'    		,text:'팀'				,type : 'string' }
					,{name: 'INSURANCE_YN'    		,text:'보험접수여부'	,type : 'string' } 					
					,{name: 'RESULT_COMMENT'    	,text:'처리결과기타'	,type : 'string' }							
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'} 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string'  ,allowBlank:false ,defaultValue: UserInfo.compCode} 
			]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'gla100ukrvService.selectList',
    	   	update : 'gla100ukrvService.update',
    	   	create : 'gla100ukrvService.insert',
    	   	destroy : 'gla100ukrvService.delete',
			syncAll: 'gla100ukrvService.saveAll'
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
					this.syncAllDirect(config);
				}else {
					var grid = Ext.getCmp('${PKGNAME}grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function(record)	{				
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}					
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					detailForm.setActiveRecord(record);
				}	
			
			}
            
		});
	

		
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '노무정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false,
						listeners:{
							change:function(field, newValue, oldValue)	{
								var driverPopup = panelSearch.down('#driver');
							 	driverPopup.setExtParam({'DIV_CODE':newValue});
							}
						}
					},{	    
						fieldLabel: '접수일',
						name: 'REGIST_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'REGIST_DATE_FR',
			            endFieldName: 'REGIST_DATE_TO',	
			            startDate: UniDate.get('startOfMonth'),
			            endDate: UniDate.get('endOfMonth'),
			            width:320
					},{	    
						fieldLabel: '발생일',
						name: 'OFFENCE_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'OFFENCE_DATE_FR',
			            endFieldName: 'OFFENCE_DATE_TO',	
			            startDate: UniDate.get('startOfMonth'),
			            endDate: UniDate.get('endOfMonth'),
			            width:320
					},{	    
						fieldLabel: '접수방법',
						name: 'REGIST_GUBUN',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO31'	
					},{	    
						fieldLabel: '장소구분',
						name: 'PLACE_GUBUN',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO33'	
					},{	    
						fieldLabel: '처리결과',
						name: 'RESULT',
						xtype:'uniCombobox',
						comboType:'AU',
						comboCode:'GO34'	
					},	    
					Unilite.popup('DRIVER',
				 	 {
				 	 	fieldLabel:'대상자',
				 		itemId:'driver',
				 		extParam:{'DIV_CODE': UserInfo.divCode},
				 		useLike:true,
				 		validateBlank:false
				 	 }
			 		)
					]				
				}]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
     	
        layout : 'fit',        
    	region:'center',
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
		
			{dataIndex:'DIV_CODE'			,width: 100, hidden:true},
			{dataIndex:'REGIST_NUM'			,width: 100, hidden:true},			
			{dataIndex:'REGIST_DATE'		,width: 80},
			{dataIndex:'REGIST_GUBUN'		,width: 80},
			{dataIndex:'OFFENCE_DATE'		,width: 80},
			{dataIndex:'OFFENCE_TIME'		,width: 80},
			{dataIndex:'VEHICLE_NAME'		,width: 100,
			 'editor':Unilite.popup('VEHICLE_G',
					 {
					 	itemId:'vehicle',
					 	uniOpt:{
				 			recordFields : ['DIV_CODE'],
				 			grid:'${PKGNAME}grid'
				 		},
					  	listeners:{
					  		'onSelected': {
					         	fn: function(records, type  ){
				                	var grdRecord = masterGrid.uniOpt.currentRecord;
				               		grdRecord.set('VEHICLE_NAME',records[0]['VEHICLE_NAME']);
				                 	grdRecord.set('VEHICLE_CODE',records[0]['VEHICLE_CODE']);
					            }
					  		},
					  		'onClear': {
					  			fn: function(type)	{
					  				var grdRecord = masterGrid.uniOpt.currentRecord;
					  				grdRecord.set('VEHICLE_NAME','');
				                 	grdRecord.set('VEHICLE_CODE','');
					  			}
					  		}
					  	}
					 })
			},
			{dataIndex:'ROUTE_CODE'			,width: 80},
			{dataIndex:'DRIVER_NAME'		,width: 80,
			 'editor': Unilite.popup('DRIVER_G',
				 	 {
				 		itemId:'driver',
					 	uniOpt:{
				 			recordFields : ['DIV_CODE'],
				 			grid:'${PKGNAME}grid'
				 		},
					  	listeners:{
					  		'onSelected': {
					         	fn: function(records, type  ){
				                	var grdRecord = masterGrid.uniOpt.currentRecord;
				               		grdRecord.set('DRIVER_NAME',records[0]['DRIVER_NAME']);
				                 	grdRecord.set('DRIVER_CODE',records[0]['DRIVER_CODE']);
					            }
					  		},
					  		'onClear': {
					  			fn: function(type)	{
					  				var grdRecord = masterGrid.uniOpt.currentRecord;
					  				grdRecord.set('DRIVER_NAME','');
				                 	grdRecord.set('DRIVER_CODE','');
					  			}
					  		}
					  	}
				 	 }
			 		)
			},
			{dataIndex:'PLACE_GUBUN'			,width: 100},
			{dataIndex:'PLACE'					,width: 130},
			{dataIndex:'OFFENCE_TYPE'			,width: 220},
			{dataIndex:'PENALTY_POINT'	,width: 80},
			{dataIndex:'RESULT'			,width: 100},
			{dataIndex:'RESULT_PERSON'	,width: 80},
			{dataIndex:'BILL_NUMBER'		,width: 120}
		]
		,listeners: {	
      		selectionchangerecord: function( selected ) {
      				detailForm.setActiveRecord(selected);
			}
         }
   });

    var detailForm = Unilite.createForm('${PKGNAME}Form', {
    	region:'south',
    	weight:-100,
    	height:360,
        layout : {type:'uniTable', columns:3},
        autoScroll:true,
        trackResetOnLoad: false,
        masterGrid: masterGrid,
        items:[
        	{	    
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype:'uniCombobox',
				comboType:'BOR120',
				value: UserInfo.divCode,
				allowBlank:false,
				hidden: true
			},{	    
				fieldLabel: '접수일',
				name: 'REGIST_DATE',
				xtype: 'uniDatefield'
			},{	    
				fieldLabel: '접수방법',
				name: 'REGIST_GUBUN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO31'
			},{	    
				fieldLabel: '접수자',
				name: 'REGIST_PERSON'
			},{	    
				fieldLabel: '발생일',
				name: 'OFFENCE_DATE',
				xtype: 'uniDatefield'
			},
			{	    
				fieldLabel: '발생시간',
				name: 'OFFENCE_TIME'
			},{	    
				fieldLabel: '신고자',
				name: 'REPORT_PERSON'
			},{	    
				fieldLabel: '노선',
				name: 'ROUTE_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('routeStore')
			},
			Unilite.popup('VEHICLE',
					 {
					 	fieldLabel:'차량',
					 	itemId:'vehicle',
				 		extParam:{'DIV_CODE': UserInfo.divCode}
					 }),
			Unilite.popup('DRIVER',
				 	 {
				 	 	fieldLabel:'대상자',
				 		itemId:'driver',
				 		extParam:{'DIV_CODE': UserInfo.divCode}
					  	
				 	 }
			 		),			
			{	    
				fieldLabel: '발생구분',
				name: 'OFFENCE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO32',
				width:490,
				colspan: 2
			},{	    
				fieldLabel: '점수',
				name: 'PENALTY_POINT',
				xtype:'uniNumberfield'
			},{	    
				fieldLabel: '장소구분',
				name: 'PLACE_GUBUN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO33'
			},{	    
				fieldLabel: '장소',
				name: 'PLACE',
				width: 490,
				colspan: 2
			},{	    
				fieldLabel: '개요',
				name: 'SUMMARY',
				xtype: 'textareafield',
				width: 735,
				colspan: 3
			},{
				xtype:'component',
				html:'&nbsp;'	,
				colspan:3
			},{	    
				fieldLabel: '처리일',
				name: 'RESULT_DATE',
				xtype: 'uniDatefield'
			},{	    
				fieldLabel: '처리결과',
				name: 'RESULT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO34'
			},{	    
				fieldLabel: '처리자',
				name: 'RESULT_PERSON'
			},{	    
				fieldLabel: '과징금',
				name: 'FINE',
				xtype: 'uniNumberfield'
			},{	    
				fieldLabel: '고지서번호',
				name: 'BILL_NUMBER'
			},{	    
				fieldLabel: '팀',
				name: 'RESULT_TEAM'
			},{	    
				fieldLabel: '기타',
				name: 'REMARK',
				xtype: 'textareafield',
				width: 490,
				height:50,
				colspan: 2
			},{	    
				fieldLabel: '보험접수여부',
				name: 'INSURANCE_YN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A020',
				tdAttrs:{'valign':'top'}
			}
        ]
    });	
	
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  masterGrid,
	 		  detailForm
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'excel' ],true);
			
		},
		
		onQueryButtonDown : function()	{
			detailForm.clearForm();
			detailForm.setDisabled( true )
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
			masterStore.saveStore(config);					
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();			
				detailForm.clearForm();
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
		},
		rejectSave: function() {			
			masterStore.rejectChanges();	
			masterStore.onStoreActionEnable();
		},
        chkTime: function(date, fieldName, newValue, record)	{
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
				record.set(fieldName, val);
			} else if(val.length == 6){
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4), val.substring(4,6)))	{
					rtn = "시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00';
					return rtn;
				}
				val = val.substring(0,2)+":"+val.substring(2,4)+":"+val.substring(4,6);						
				record.set(fieldName, val);
			} else  if(val.length != 0) {
				rtn = "00:00:00(시:분:초) 형식으로 입력하거나 숫자만 입력해 주세요.";				
			}					
			return rtn;
		}
	});

	Unilite.createValidator('validator01', {
		store : masterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName)	{
				case 'OFFENCE_TIME' :
					rv = UniAppManager.app.chkTime(Unilite.nvl(record.get('OFFENCE_DATE'), UniDate.today()), fieldName, newValue, record);
					break;		
				default :
					break;
			}
			return rv;
		}
	}); // validator
	
}; // main
  
</script>