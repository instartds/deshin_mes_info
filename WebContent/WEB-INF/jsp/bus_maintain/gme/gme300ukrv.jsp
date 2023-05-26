<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//정비기술평가정보
request.setAttribute("PKGNAME","Unilite_app_gme300ukrv");
%>
<t:appConfig pgmId="gme300ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
</t:appConfig>
<script type="text/javascript">
var activeGrid;
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	    fields: [
			 {name: 'DIV_CODE'   		,text:'사업장'		,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
			,{name: 'MECHANIC_CODE'    	,text:'사번'		,type : 'string'  ,allowBlank:false} 
			,{name: 'MECHANIC_NAME'    	,text:'성명'		,type : 'string'  ,allowBlank:false}
			,{name: 'ASSESSMENT_DATE'   ,text:'평가기준일'	,type : 'uniDate' ,allowBlank:false} 	
			,{name: 'MAINTENANCE' 		,text:'정비'		,type : 'number' } 
			,{name: 'DIAGNOSIS' 		,text:'진단'		,type : 'number' } 	
			,{name: 'ARC'    			,text:'ARC'			,type : 'number' }
			,{name: 'DUTY'    			,text:'근태'		,type : 'number'} 	
			,{name: 'CNG'    			,text:'천연가스'	,type : 'number' } 	
			,{name: 'REMARK' 			,text:'비고'		,type : 'string' } 
		]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'gme300ukrvService.selectList',
			update	: 'gme300ukrvService.update',
			create	: 'gme300ukrvService.insert',
			syncAll	: 'gme300ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
      
			loadStoreRecords: function(record)	{				
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}		
			},
			saveStore:function(config)	{
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0) {
					this.syncAllDirect(config);
				}
			}
            
		});

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '정비사 평가 정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		   			height:160,
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
						allowBlank:false
					},Unilite.popup('MECHANIC',
						 {
						 	itemId:'mechanic',
						 	extParam:{'DIV_CODE': UserInfo.divCode}
						 }
					 )	
					 ,{	    
						fieldLabel: '평가기준일',
						name: 'ASSESSMENT_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ASSESSMENT_DATE_FR',
			            endFieldName: 'ASSESSMENT_DATE_TO',	
			            startDate: UniDate.get('startOfMonth'),
			            endDate: UniDate.get('endOfMonth'),
			            width:320
					}]				
				}]

	});	//end panelSearch    

	var masterGrid = Unilite.createGrid('${PKGNAME}grid', { 
		region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: false,   
			   useStateList: false  
			}
        },
    	store: masterStore,
		columns:[
			{dataIndex:'ASSESSMENT_DATE'	,width: 100},
			{dataIndex:'MECHANIC_CODE'		,width: 100 ,
			  editor: Unilite.popup('MECHANIC_G',
						 {
						 	itemId:'mechanic',
						 	textFieldName:'MECHANIC_CODE',
						 	DBtextFieldName:'MECHANIC_CODE',
						 	extParam:{'DIV_CODE': UserInfo.divCode},
						 	listeners: {
				                'onSelected':  function(records, type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
				                    	grdRecord.set('MECHANIC_CODE',records[0]['MECHANIC_CODE']);
				                    	grdRecord.set('MECHANIC_NAME',records[0]['MECHANIC_NAME']);
				                }
				                ,'onClear':  function( type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
				                    	grdRecord.set('MECHANIC_CODE','');
				                    	grdRecord.set('MECHANIC_NAME','');
				                }
				            } 
						 }
					 )
			},
			{dataIndex:'MECHANIC_NAME',
			  editor: Unilite.popup('MECHANIC_G',
						 {
						 	itemId:'mechanic',
						 	extParam:{'DIV_CODE': UserInfo.divCode},
						 	listeners: {
				                'onSelected':  function(records, type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
				                    	grdRecord.set('MECHANIC_CODE',records[0]['MECHANIC_CODE']);
				                    	grdRecord.set('MECHANIC_NAME',records[0]['MECHANIC_NAME']);
				                }
				                ,'onClear':  function( type  ){
				                    	var grdRecord = masterGrid.uniOpt.currentRecord;
				                    	grdRecord.set('MECHANIC_CODE','');
				                    	grdRecord.set('MECHANIC_NAME','');
				                }
				            } 
						 }
					 )		,width: 100},
			{dataIndex:'MAINTENANCE'		,width: 100, format:'0.0'},
			{dataIndex:'DIAGNOSIS'			,width: 100, format:'0.0'},
			{dataIndex:'ARC'				,width: 100, format:'0.0'},
			{dataIndex:'DUTY'				,width: 100, format:'0.0'},
			{dataIndex:'CNG'				,width: 100, format:'0.0'},			
			{dataIndex:'REMARK'				,flex: 1}
		]
   });	
      Unilite.Main({
		borderItems:[
	 		  panelSearch,
	 		  masterGrid
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print', 'excel', 'newData'],false);
			UniAppManager.setToolbarButtons(['newData'],true);
		},
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{	
			masterGrid.createRow()
		},	
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore(config);					
		},
		onDeleteDataButtonDown : function()	{
			
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
}; // main

</script>