<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_aisc150ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A049" /> <!-- 예적금구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B001" /> <!-- ? -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 예/아니오 -->
    <t:ExtComboStore comboType="AU" comboCode="A392" />            <!-- 가수금 IN_GUBUN -->
	<t:ExtComboStore comboType="AU" comboCode="BS25" /> <!-- 계좌집금 유형 (통합계좌서비스 대상)-->
	<t:ExtComboStore comboType="AU" comboCode="BS26" /> <!-- CMS 계좌 유형 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_aisc150ukrv_mitService.selectList',
			update: 's_aisc150ukrv_mitService.updateDetail',
			create: 's_aisc150ukrv_mitService.insertDetail',
			syncAll: 's_aisc150ukrv_mitService.saveAll'
		}
	});	
	/**
	 * Model 정의
	 * 
	 * @type
	 */

	 Unilite.defineModel('s_aisc150ukrv_mitModel', {
		    fields: [{name: 'ASST'				,text:'자산코드'				,type : 'string'  , allowBlank: false},
		    		 {name: 'ASST_NAME'			,text:'자산명'				,type : 'string'  , allowBlank: false},
					 {name: 'DPR_YYMM'			,text:'상각년월'				,type : 'string'  , allowBlank: false, convert:monthFormat},
					 {name: 'TM_DPR_I'   		,text:'월상각액(시스템)'		,type : 'uniPrice'},
					 {name: 'U_TM_DPR_I'   		,text:'월상각액'				,type : 'uniPrice'},
					 {name: 'EX_DATE'  			,text:'결의일자'				,type : 'uniDate' },
					 {name: 'EX_NUM' 			,text:'결의번호'				,type : 'int'	  },
					 {name: 'REMARK'  			,text:'비고'					,type : 'string'  }
				]
		});	
	function monthFormat(value){
		var r = value;
		if(Ext.isDate(value)) {
			r = Ext.Date.format(value, Unilite.monthFormat);
		} 
		return r;
	}
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	 var directMasterStore = Unilite.createStore('directMasterStore',{
		model: 's_aisc150ukrv_mitModel',
		autoLoad: false,
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,    
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect();			 //syncAllDirect	
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords : function(){
			if(panelResult.getInvalidMessage())	{
				var param =  panelResult.getValues()
				this.load({
				   params: param
				});
			}
		},
		listeners:{
			load:function(store, records){
				if(!records || records.length == 0){
					logStore.loadStoreRecords();
				} else {
					panelResult.getField("ASST").setReadOnly(true);
					panelResult.getField("ASST_NAME").setReadOnly(true);
				}
			}
		}
	});	
	
	 var logStore = Unilite.createStore('directLogStore',{
		model: 's_aisc150ukrv_mitModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
	      
		proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read: 's_aisc150ukrv_mitService.selectLogList'
			}
		}),    
		loadStoreRecords : function(param){
			if(panelResult.getInvalidMessage())	{
				directMasterStore.loadData({});
	        	var param =  panelResult.getValues();
	        	masterGrid.mask();
		        this.load({
		           params: param
		        });
        	}
	    },
		listeners:{
			load:function(store, records){
				if(records && records.length > 0){
					Ext.each(records, function(rec, idx){
						var newRecord =  Ext.create(directMasterStore.model);
						if(rec.data)	{
							Ext.each(Object.keys(rec.data), function(key){
								newRecord.set(key, rec.data[key]);
							});
							newRecord.phantom = true;
							directMasterStore.insert(idx, newRecord)
						}
						
					});
					panelResult.getField("ASST").setReadOnly(true);
					panelResult.getField("ASST_NAME").setReadOnly(true);
					
				}
				masterGrid.unmask();
			}
		}
	    
	});	
	var panelResult = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('ASST_MIT',{
				fieldLabel: '자산코드',
				allowBlank : false
			})/* ,
			{
				margin:'0 0 0 100',
	        	xtype:'button',
	        	text:'감가상각재계산',
	        	width: 130,
	        	tdAttrs:{'align':'center'},
	        	handler: function()	{
					UniAppManager.app.onRecalulate();
	        	}
			} */
	     ]
	});	
		
    var masterGrid = Unilite.createGrid('s_aisc150ukrvGrid1', {
        region:'center',
        store : directMasterStore,
		columns: [{dataIndex: 'ASST'		,width:100 },				 
				  {dataIndex: 'ASST_NAME'  	,width:220 },
				  {dataIndex: 'DPR_YYMM' 	,width:80,  align:'center', editor:{xtype : 'uniMonthfield',  format: Unilite.monthFormat  }},	
				  {dataIndex: 'TM_DPR_I'  	,width:120 },	
				  {dataIndex: 'U_TM_DPR_I' 	,width:100 },			  
				  {dataIndex: 'EX_DATE'  	,width:80  },				  
				  {dataIndex: 'EX_NUM' 		,width:80  },
				  {dataIndex: 'REMARK'		,flex:1}
		],
		listeners: {
    		beforeedit: function( editor, e, eOpts ) {
   				if(e.record.phantom == true && UniUtils.indexOf(e.field, ['DPR_YYMM', 'U_TM_DPR_I', 'REMARK'])) {
					return true;
				}
   				if(e.record.phantom != true && UniUtils.indexOf(e.field, [ 'U_TM_DPR_I', 'REMARK'])) {
					return true;
				}
    			return false;
        	}
		}
    });  

    
	Unilite.Main( {
		borderItems:[
			 masterGrid
			,panelResult
		],
		id: 's_aisc150ukrv_mitApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['query' ,'newData'],true);
			UniAppManager.setToolbarButtons(['delete' ],false);
			panelResult.getField("ASST").setReadOnly(false);
			panelResult.getField("ASST_NAME").setReadOnly(false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			if(panelResult.getInvalidMessage())	{
				
				var r = {
					ASST 		: panelResult.getValue("ASST"),
					ASST_NAME	: panelResult.getValue("ASST_NAME")
				}
				masterGrid.createRow(r , null);
				panelResult.getField("ASST").setReadOnly(true);
				panelResult.getField("ASST_NAME").setReadOnly(true);
				UniAppManager.setToolbarButtons(['reset'],true);
			}
				
		},
		onResetButtonDown: function() {		
			panelResult.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore();
		},
		onRecalulate:function(){
			logStore.loadStoreRecords();	
		}
	});
	
};



</script>
