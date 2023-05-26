<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//정비사승급정보
request.setAttribute("PKGNAME","Unilite_app_gme200ukrv");
%>
<t:appConfig pgmId="gme200ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 작업조  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO29"/>				<!-- 숙련도  	-->	
</t:appConfig>
<script type="text/javascript">
var activeGrid;
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	    fields: [
			 {name: 'DIV_CODE'   		,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,allowBlank:false ,defaultValue: UserInfo.divCode} 
			,{name: 'MECHANIC_CODE'    	,text:'사번'			,type : 'string' } 
			,{name: 'MECHANIC_NAME'    	,text:'성명'			,type : 'string' }
			,{name: 'PROMOTION_DATE'    ,text:'승급일'			,type : 'uniDate'} 	
			,{name: 'OFFICE_CODE' 		,text:'영업소'			,type : 'string' ,comboType: 'AU', comboCode:'GO01'} 
			,{name: 'BEFORE_SKILL' 		,text:'승급전숙련도'	,type : 'string' ,comboType: 'AU', comboCode:'GO29'} 	
			,{name: 'PRESENT_SKILL'    	,text:'승급후숙련도'	,type : 'string' ,comboType: 'AU', comboCode:'GO29'}
			,{name: 'PERIOD'    		,text:'경과기간'		,type : 'string'} 	
			,{name: 'LATEST_SALARY'    	,text:'최종급여'		,type : 'uniPrice' } 	
			,{name: 'REMARK' 			,text:'비고'			,type : 'string' } 
		]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'gme200ukrvService.selectList',
			update	: 'gme200ukrvService.update',
			create	: 'gme200ukrvService.insert',
			syncAll	: 'gme200ukrvService.saveAll'
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
						fieldLabel: '승급일',
						name: 'PROMOTION_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'PROMOTION_DATE_FR',
			            endFieldName: 'PROMOTION_DATE_TO',	
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
					 
			{dataIndex:'OFFICE_CODE'		,width: 100},
			{dataIndex:'PROMOTION_DATE'		,width: 100},
			{dataIndex:'PERIOD'				,width: 100},
			{dataIndex:'BEFORE_SKILL'		,width: 120},
			{dataIndex:'PRESENT_SKILL'		,width: 120},
			{dataIndex:'LATEST_SALARY'		,width: 100},			
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