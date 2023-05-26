<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cam040ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="CA05" /> <!-- 배부유형 -->
	<t:ExtComboStore comboType="A" comboCode="CA05" /> <!-- 배부유형 -->
	<t:ExtComboStore items="${COST_POOL}" storeId="costPool"/>
</t:appConfig>	
<script type="text/javascript" >

function appMain() {     

	/* Cost Pool 정보 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'cam040ukrvService.selectList',
			create  : 'cam040ukrvService.insertDetail',
			update  : 'cam040ukrvService.updateDetail',
			destroy : 'cam040ukrvService.deleteDetail',
			syncAll : 'cam040ukrvService.saveAll'
		}
 	});	

	/* Cost Pool 정보 */
	//모델 정의
	Unilite.defineModel('cam040ukrvModel', {
	    fields: [{name: 'DIV_CODE'			,text:'사업장'		,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode},
	    		 {name: 'WORK_MONTH'		,text:'작업년월'		,type : 'string', allowBlank:false},
	    		 {name: 'ALLOCATION_CODE'	,text:'배부유형'		,type : 'string', allowBlank:false, comboType:'A', comboCode:'CA05'},
	    		 {name: 'COST_POOL_CODE'	,text:'부문'			,type : 'string', allowBlank:false, store:Ext.StoreManager.lookup('costPool')},
	    		 {name: 'ALLOCATION_VALUE'	,text:'배부값'		,type : 'float', allowBlank:false},
				 {name: 'REMARK'			,text:'비고'			,type : 'string'}
			]
	});	

	//스토어 정의
	var cam040ukrvStore = Unilite.createStore('cam040ukrvStore',{
		model: 'cam040ukrvModel',
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy2,
        loadStoreRecords : function()	{
        	panelResult.setValue('isCopy', 'N');
        	var chkValid = panelResult.isValid();
        	if(chkValid)	{
				var param= Ext.getCmp('resultForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
        	}
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
		
			var rv = true;
		        
			if(inValidRecs.length == 0 ) {          
				config = {
					params: [panelResult.getValues()],
					success: function(batch, option) {        
						panelResult.setValue('isCopy', 'N');
						UniAppManager.setToolbarButtons('save', false);   
					} 
				};     
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		},
		listeners:{
			load:function(store, records){
				store.setCheckRecord(records);
			}
		},
		setCheckRecord:function(records)	{
			var chk = false
			var store = this;
			Ext.each(records, function(record, idx){
				if(!record.get('UPDATE_DB_TIME'))	{
					//store.insert(idx, record);
					var newRecord =  Ext.create (store.model);
					if(record.data)	{
						Ext.each(Object.keys(record.data), function(key, idx){
							newRecord.set(key, record.data[key]);
						});
					}
					newRecord.phantom = true;
					store.remove(record);
					store.insert(idx, newRecord);
					if(!chk)	{
						chk=true;
						setTimeout(function(){UniAppManager.setToolbarButtons('save', true);}, 1000);
					}
				}
			
			});
		}    
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		xtype: 'uniSearchForm',
		itemId:'calcuBasisSearch1',
		region:'north',
		layout:{type:'uniTable', columns:'4'},
		items:[{
			xtype:'uniCombobox',
			comboType:'BOR120',
			fieldLabel:'사업장',
			name:'DIV_CODE',
			allowBlank:false,
			value:UserInfo.divCode
		},{
			xtype:'uniMonthfield',
			fieldLabel:'기준년월',
			labelWidth:120,
			allowBlank:false,
			name:'WORK_MONTH',
			value:UniDate.get('today')
		},{
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'CA05',
			fieldLabel:'배부유형',
			name:'ALLOCATION_CODE'
		},{
			xtype:'uniTextfield',
			fieldLabel:'전월복사여부',
			labelWidth:120,
			name:'isCopy',
			value:'N',
			hidden:true
		},{
			xtype:'button',
			text:'전월데이타복사',
			tdAttrs:{align:'right', width:200},
			handler:function(){
				var form  = panelResult;
				form.setValue('ALLOCATION_CODE', '');
				if(form.isValid())	{
					var param = form.getValues();
					Ext.getBody().mask("Loading...");
					cam040ukrvStore.loadData({});
					cam040ukrvService.selectCopy(param, function(responseText, response){
						
						cam040ukrvStore.loadData(responseText);
						cam040ukrvStore.setCheckRecord(cam040ukrvStore.getData().items);
						form.setValue('isCopy', 'Y');
						Ext.getBody().unmask()
					});
				}
			}
		}]
	
	});
	
	var masterGrid = Unilite.createGrid('cam040ukrvGrid', {
		itemId:'cam040ukrvsGrid',
	    store : cam040ukrvStore,
	    layout:'fit',
	    region:'center',
	    uniOpt: {			
		    useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: true,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: true,	
			copiedRow			: true,
		    filter: {				
				useFilter		: false,
				autoCreate		: false
			}			
		},		        
		columns: [{dataIndex: 'WORK_MONTH' 		, width: 150, hidden:true},
				  {dataIndex: 'ALLOCATION_CODE'  	, width: 250, editor:{
				  		xtype:'uniCombobox',
				  		comboType:'AU',
				  		comboCode:'CA05'
				  }},
				  {dataIndex: 'COST_POOL_CODE' 		, width: 150},
				  {dataIndex: 'ALLOCATION_VALUE' 	, width: 150},
				  {dataIndex: 'REMARK'				, width: 300}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field == 'COST_POOL_CODE'){
					if(e.record.phantom){
						return true;
					}else{
						return false;
					}
				}
			}	
		}
	});

	/* 기준코드등록	*/
	Unilite.Main( {
		id 			: 'cam040ukrvApp',
		borderItems : [ 
			panelResult,
			masterGrid		 	
		], 
		fnInitBinding : function(param) {	
			if(param && param.DIV_CODE)	{
				panelResult.setValue("DIV_CODE",param.DIV_CODE);
				panelResult.setValue("WORK_MONTH",param.WORK_MONTH);
			}
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
		},
		onQueryButtonDown : function()	{		
			cam040ukrvStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			if(panelResult.isValid())	{
				var divCode      = panelResult.getValue("DIV_CODE");
	            var workMonth    = UniDate.getMonthStr(panelResult.getValue("WORK_MONTH"));
				
				var r = {
					DIV_CODE	: divCode,
					WORK_MONTH  : workMonth
				}
				masterGrid.createRow(r);
			}
		
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();
		},		
		onSaveDataButtonDown: function () {
			cam040ukrvStore.saveStore();
		}
	});
};
</script>